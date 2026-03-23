Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D732DF4613C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 21:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F023A6B0088; Mon, 23 Mar 2026 17:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2C26B0089; Mon, 23 Mar 2026 17:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8B06B008A; Mon, 23 Mar 2026 17:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAECB6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:36:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BFA45CF91
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:36:08 +0000 (UTC)
X-FDA: 84578636016.09.B918664
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C99B2A000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:36:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gNxb4JLn;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774301766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QowRGUY/Rf5tXMlHmxXQjpsLCamtrKkANozJkRf1Ul0=;
	b=wHhGTpo30rZn+cj1anWqoXesheq920H+vSbnt03JiL44aon0nzXI1uZW1fX5Aeqj5JapRO
	Sp7Nlvbu8Mijo7BwAF1SeLfzckGws+TKBFfqNiTqt7V7/sPG8YamdgGzJh+loyq4+6UDbm
	R+IV9nGA73dVOPCvocGqV9sgEPLzepU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gNxb4JLn;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774301766; a=rsa-sha256;
	cv=none;
	b=TOupJZPOJ12oXTFgc07p04R4+3zsdoyP2hWA8EbD4pGFzMxlJjhaLyenaWEY45E/WDHPUE
	aaPJijUpvwNj/UkDCMrVIpbv+H6/Wtf1Y/Q/GDVzSN/PGdX7OPRnmTsxrCmAeGiwdOw+zI
	li+Ki83G7aMoTIp+ln6ix0LrqY3t8pg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 29B1F600AC;
	Mon, 23 Mar 2026 21:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5B6C4CEF7;
	Mon, 23 Mar 2026 21:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774301765;
	bh=/Gb305a+Cn7PNqgbnF81KjVBMXAtfU7WzFxbKVQ11/E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gNxb4JLn80isFDbfugd94d0nRtAWVEmNAFitcwGRB+lvNChb2j1ogOowP5WcNvkCo
	 8C8o+yY44JdIVm8Sptsmd9nkCBb1DnugY1xNEt4EeQeu7KghVN62EHISTftzTpWx4n
	 P+/JATelXIv+1Grehx9vPb8Uw+UBSNLTXVh9zlWw=
Date: Mon, 23 Mar 2026 14:36:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, David Hildenbrand <david@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] mm/huge_memory: refactor zap_huge_pmd()
Message-Id: <20260323143604.603b20aec4e3ab77cabec107@linux-foundation.org>
In-Reply-To: <j6hsn4mxnzoukebcdggu6ojkyaj54joohocbbkrzksm47km7ni@zzp7aurwmto7>
References: <cover.1773924928.git.ljs@kernel.org>
	<20260319200917.ce345a369d035050b6329ac5@linux-foundation.org>
	<87tsu9kgv3.fsf@linux.dev>
	<20260320203311.715ed75bcd84c18d24894324@linux-foundation.org>
	<20260321171530.8b3e8207f89d5a7384b9f01f@linux-foundation.org>
	<5cd57c69-7193-422f-b6b5-75bb5234e5f3@lucifer.local>
	<j6hsn4mxnzoukebcdggu6ojkyaj54joohocbbkrzksm47km7ni@zzp7aurwmto7>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C99B2A000E
X-Stat-Signature: 1guoh3xpyzasxj9e361b5d6ee9b8egof
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774301766-878647
X-HE-Meta: U2FsdGVkX18NUejh84+LpejqhYfjg36F1ZzGAXN6uHPdnfjqGUybxoNsN1Ws9aQiqKPcx654HljVXQ5aw3O58SliiLbnRK6ixBpb+163A6Lu7v9keWvhM7w+5G5MRFk0yNIw78lfD5YxuQQpgZo3TP54BZ1FbVmjD9ZA2iYSbYW+D4r1YJKyBO6fJkneh/kbYmGOtD/SHDJOxlL5H0L25eeH9K4cb7AFNe+7ony7a7Ui0xhlLDeTceF0XxWRmHtjc5b2b+2QzLz4SbARzouH1f+3lnU6ihjdoFDT18tCiICT66zOs1Qa69S9AsjJuoSRJU51Dw2xlrtHCkAezWBd0yoxw+8ddYL+u5bnLVNGl3yhXMOlWwyV1BSlOoRZ+VcOb3L+XNd2js/SEhPxN6s7mriMhbB+G0FaVOLCEFrh55MQZA6X7LKMgAlHQNAs98cvGt8FPwUj01xEU93eNJKZOr9D6L7c3ZBMzqvkcOvYavJvjdr3B0b7LEJm7u9t/NTRIi19SPQeliR1MOlB7nxgd+MIalFYzagVLHNaaaM9daytDeawY+P3hXEYV0f6Ic/RpGrR13t+gaS0YxMOw/jp7iaMqwMFmLw6l+BrfcVMLSw2iGR+Chqb3fB97Y6uLIK9Ibc1Kcwqd9aeFk8Zc+OJAgYI0wpzU5eLRHWC9q5VFZHCMjJ41GpWdBVSE4cfIZQlj4ot/OaxmzBntEtrr8yBBRLMc7g3O1u0CjgsWRXzMqRC4BMO6uKPRZE4t5lFjd16T9tS8GnGLMJ4VPH6fNtQpPe4kJ9SIFgY+GKhzVbQgH6/3jNDZ8uSCNgDk2XDpEuNFTEg8Mt8raQ0lPzYL+e+BU1dApNXawrcx8Wdp+jtYtOdLmU0sgugcQy/SjL37wroKy/SHJ0Bg1l3Zl46uQVRs1TCT2w9F4HXCnNDu9BZ7ZGlcTpuT0ALxv3Beq9ucjCjHIibYVdB09k2OsvRqeL
 AjGxRMx+
 zMrNb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 12:34:31 +0000 Pedro Falcato <pfalcato@suse.de> wrote:

> On Mon, Mar 23, 2026 at 11:31:29AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Sat, Mar 21, 2026 at 05:15:30PM -0700, Andrew Morton wrote:
> > > On Fri, 20 Mar 2026 20:33:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> > >
> > > > A lot of patchsets are "failed to apply".  What is Sashiko trying to
> > > > apply MM patches to?  It would take some smarts to apply the v2
> > > > patchset when v1 is presently in mm.git?
> > >
> > > ?
> > >
> > > The way things are going at present, I'm just not going to apply a
> > 
> > 50% noise vs. signal?... maybe wait until we're in the 9x'%s?
> > 
> > > series which Sashiko "failed to apply".  And that's cool, I'll just
> > > wait for a version which Sashiko was able to apply.  And then not
> > > apply unless all Sashiko questions are resolved or convincingly refuted.
> > 
> > Andrew, for crying out loud. Please don't do this.
> > 
> > 2 of the 3 series I respan on Friday, working a 13 hour day to do so, don't
> > apply to Sashiko, but do apply to the mm tree.
> > 
> > I haven't the _faintest clue_ how we are supposed to factor a 3rd party
> > experimental website applying or not applying series into our work??
> > 
> > And 'not apply unless all Sashiko questions are resolved or convincingly
> > refuted.' is seriously concerning.
> 
> FWIW I wholeheartedly agree. I don't understand how we don't require proper
> M: or R: reviews on patches before merging

I wish people would stop making this claim, without substantiation. 
I've looked (deeply) at the data, which is equally available to us all.
Has anyone else?

After weeding out a few special cases (especially DAMON) (this time
also maple_tree), the amount of such unreviewed material which enters
mm-stable and mainline is very very low.

> Like, sure, sashiko can be useful, and is better than nothing. But unless
> sashiko is better than the maintainers, it should be kept as optional.

Rule #1 is, surely, "don't add bugs".  This thing finds bugs.  If its
hit rate is 50% then that's plenty high enough to justify people
spending time to go through and check its output.

> Seriously, I can't wrap my head around the difference in treatment in
> "human maintainers, experts in the code, aren't required to review a patch"

Speaking of insulting.

> vs "make the fscking AI happy or it's not going anywhere". It's almost
> insulting.

Look, I know people are busy.  If checking these reports slows us down
and we end up merging less code and less buggy code then that's a good
tradeoff.

Also, gimme a break.  Like everyone else I'm still trying to wrap my
head how best to incorporate this new tool into our development
processes.

