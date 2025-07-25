Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D03DFC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 17:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5937C6B0089; Fri, 25 Jul 2025 13:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543CE6B008A; Fri, 25 Jul 2025 13:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4328D6B008C; Fri, 25 Jul 2025 13:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5986B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 13:11:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA4961408A5
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:10:59 +0000 (UTC)
X-FDA: 83703427038.07.AF1B588
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9754E1C0016
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 17:10:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=q6nsBbDk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753463458; a=rsa-sha256;
	cv=none;
	b=PICwBDMmLQdLSMBiFh7a9mOksOFlEaYXgPuP3y+ZijmvuImWqx0mthXKrdlKdVNNqFd8xV
	iQqUnezSdJ1gKwPzV4NjdWp9fGGGGS2yi6yOcan8gwJDnLy1TTLo8dBbxplNlZVluwqoK5
	nLxel7IMutU/AdZQl5bKdcDptS4b4X0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=q6nsBbDk;
	dmarc=none;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753463458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwEj7tW3R8uCNKLY055BKb1g0sfs5+82uKkf0EViQnk=;
	b=NlTl0s9TzF760mpIYSX/go1xv39DPsQUsv1HAxEL4vdQWzVY0gukzfWoKhGZmUsFkoUA+Y
	cOClobir2O3zcEzR3/coVbr1uHzGjX1iyLbxulxD4ltGVLvHlLSq1UAAg+77fbrLG61tJ9
	fRwYXbjpqgHN/qBGHpNBcfJEJyam4BM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IwEj7tW3R8uCNKLY055BKb1g0sfs5+82uKkf0EViQnk=; b=q6nsBbDkqlaOI6zpV6bJS9CTol
	XAKlVZQqfBwnB2MxRuZJMraL1hXQhohrtGkyp2l9rnDBXoyYn3Sh+LnpRalA0q42B7GYI/SJAAjJw
	PgiHY4WOGExeZoRYvl7Z41eF5QqDaiLl6thfX1Wuw+s3+QyeGBiCJkwUO1k1co1kpn6o0YrFw6Oow
	c3r+5XonilGVfG8f9gAz8TZAPMWgh9EFXqdtpi6LaNBIZcFDZzzQ+mucxd7PwH98CWHZVJK3rZj7F
	wH0HdcOTf10xE07W0zVjM8yCW3RGgOEGaxYy1fuprasrdIFzlT4mbdqQNkyTVnnbKKW5Ik5LLxXPH
	1PmDyyjA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ufLwZ-0000000FAKW-3dJu;
	Fri, 25 Jul 2025 17:10:51 +0000
Date: Fri, 25 Jul 2025 18:10:51 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Li Qiong <liqiong@nfschina.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: slub: avoid deref of free pointer in sanity
 checks if object is invalid
Message-ID: <aIO6m2C8K4SrJ6mp@casper.infradead.org>
References: <20250725064919.1785537-1-liqiong@nfschina.com>
 <996a7622-219f-4e05-96ce-96bbc70068b0@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <996a7622-219f-4e05-96ce-96bbc70068b0@suse.cz>
X-Stat-Signature: 9fwiyzhx5b4ekbej13yp7iam1cjz6qp1
X-Rspam-User: 
X-Rspamd-Queue-Id: 9754E1C0016
X-Rspamd-Server: rspam02
X-HE-Tag: 1753463457-169197
X-HE-Meta: U2FsdGVkX18x97FoIQoCGxtO04fv5nFZ11jlCs76F+cgCP96EUHd+0ngIG7atNREctz9HxqyLNDgJCxErF9SBT5nth7K4kv/jJfOP2nrlKdd/E4abFACpS72FbFOBaECbiAjjaulT/ERfX6Uz9OZ25Lb/F9pRuKlCC6Vu3EzNDLNEHxDqfTpwjmP3sUi52G+NTjsAC9ceLo8vUS2C963WBwtZzl1yRygi1MHPhwGPNHQJcI+1N/KfQhooP4fr0zcOjolJcUnNZ6ARP7nC9KsjnBkEPavB7HDoy6FcP/WFoxUjnCXEd7coIk/2+LZkl2en711S6Fd+yhUUoUvJqWJFjEyAR660eF5B4HdjJOgLkKOI+nrU+GBm4tO327sW8cMJd1Igwu7fBff9nzkqO6vWb6qYT3OzieqWRYESGuHGF1XYRT7iNG2RmJzIkDps/MVAK5GxzJW51qb4ObNYs0TVS9cnWYwSyDAVJBL9s7oa+6eW2sGu3sXO9igvunNGRtRjo5fCXWyOF0i5p8+cgbXPIUKBpTGiD9/V34Bw2GWQz6xJgePeoou0Ti2qC+PKSzqAQZ3v3jQFXrwazrduSU2ACxJcK+ax+AiUB966sQTyVAB4CFQOGGfEBxTM08uDWEYJbghDsxNXfUNgg3DY3s98rxYa0LS4xuiIYekmhCV1gvJYrNQc8AY33K8yNS/7VGECjfg08ZIvFk68L7kdTW4qaD4oYhIQ96v8yirMLYJ7UL0UJYdtF7UYTnwPxWR3CfrP6SIECxZVRfYbW0IpqMENL8saXBAt999FKX8qjaRMZnsmYVJ8rFX/1czDLlrsWKYptCkv3oXndldHel0t4vimusQ2/IhevR3quNFdLt8sslHanPshFtN9GVbXaEgRQVJrUQZ+cP9cntnLGZBCH+UsAHBIhmGm1kSntIVAvxBquwbvzySXeeeQvrhTvdFCIsptokIkhdpV2+qt4fb2JL
 bdnybPWy
 RJWPM77xGTNkTiSyI+KwFF/VBMTJHtzVDlCTbAmc+jE5vlukiF3iizcV8Z3PYnFvR4A8dgrbp91t65vTRuWCBwkbY7zXhD59tBjvcj/NfXRTA6IMUsHfzyLcImKTWXq1mJzhxjapyeGgt3vvaYg2J3S052rcUtRD8MSxl/KjYEb+pQOc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 06:47:01PM +0200, Vlastimil Babka wrote:
> On 7/25/25 08:49, Li Qiong wrote:
> > For debugging, object_err() prints free pointer of the object.
> > However, if check_valid_pointer() returns false for a object,
> > dereferncing `object + s->offset` can lead to a crash. Therefore,
> > print the object's address in such cases.

I don't know where this patch came from (was it cc'd to linux-mm? i
don't see it)

> >  
> > +/*
> > + * object - should be a valid object.
> > + * check_valid_pointer(s, slab, object) should be true.
> > + */

This comment is very confusing.  It tries to ape kernel-doc style,
but if it were kernel-doc, the word before the hyphen should be the name
of the function, and it isn't.  If we did use kernel-doc for this, we'd
use @object to denote that we're documenting the argument.

But I don't see the need to pretend this is related to kernel-doc.  This
would be better:

/*
 * 'object' must be a valid pointer into this slab.  ie
 * check_valid_pointer() would return true
 */

I'm sure better wording for that is possible ...

> >  	if (!check_valid_pointer(s, slab, object)) {
> > -		object_err(s, slab, object, "Freelist Pointer check fails");
> > +		slab_err(s, slab, "Invalid object pointer 0x%p", object);
> >  		return 0;

No, the error message is now wrong.  It's not an object, it's the
freelist pointer.

		slab_err(s, slab, "Invalid freelist pointer %p", object);

(the 0x%p is wrong because it will print 0x twice)

But I think there are even more things wrong here.  Like slab_err() is
not nerely as severe as slab_bug(), which is what used to be called.
And object_err() adds a taint, which this skips.

Altogether, this is a poorly thought out patch and should be dropped.

