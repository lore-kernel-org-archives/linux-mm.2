Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B93C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 03:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6206B0088; Sun, 27 Jul 2025 23:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97056B0089; Sun, 27 Jul 2025 23:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACA86B008A; Sun, 27 Jul 2025 23:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BE926B0088
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 23:29:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 086D7137B9A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:29:35 +0000 (UTC)
X-FDA: 83712243510.12.3B7FE7D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6421180005
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:29:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=A54JLMjh
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753673373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U38WBbQd9E59rA3tDIm22NEKq3lI4YsOojYMeyWppNY=;
	b=58lrbHMlJQ0FOY8uzAxG7OnRDpLkrextatFj+TNn2acKweNz62877/6MIqkN8XicXo5Pyy
	BrYqwV9hb/D6dp/qQ9LYfvViyREGFdJAccuN1do3KrqYOPY7sErf7V3DjmNlwCBbPDrvWR
	Ow1hVCF2Ro66i6C7e9Y+f9wP21bgs1A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753673373; a=rsa-sha256;
	cv=none;
	b=4uW1S1nCgIdrWCo8300wcpX2BUtMEl9Ou3RApqIFvNFydzK+pvtxBPcAQmFb7ESPCSNKYh
	Oyr1TbJkbD0EKUyvbOLA98QrXHj1G8z3PBGWKUAX8Irmt7AxPxtnV2CKcmDhUH0Y5GN6mK
	7As5Tty1kJqgR0Ek7gNFIXFNPWORue0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=A54JLMjh;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=U38WBbQd9E59rA3tDIm22NEKq3lI4YsOojYMeyWppNY=; b=A54JLMjhNhTRGSAERKE/77OhSa
	a9ZrhSHuQ1VMdbt08xH4mZn8l+DM8UOq5jrln0e5FvaaxKLNGzwoQigE/xgk2UfFdo8a9UVV0hkql
	PcNwsfuyl98rI9bYR7omqAsErouMTmIco5qC5vXhklGqjAa3GaLzUtF9hswYviI4+FAIurPxD06a8
	k8H2Ka6ow5VJiWfw6FX6tb/YZq745PZhCZjSBtIIYkpZEn5TLbMpY5HgPjusgeJtyCVmuoML5Rwe3
	QDM5/fYlYSjvcLYth5sJkQxEvs/d1ykXd5x1PXz8KLGN+BbnZyE+g5Vf+bHHakOIW6WTLDyU86YBW
	/DJX08CA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ugEYE-000000040Bx-1YVw;
	Mon, 28 Jul 2025 03:29:22 +0000
Date: Mon, 28 Jul 2025 04:29:22 +0100
From: Matthew Wilcox <willy@infradead.org>
To: liqiong <liqiong@nfschina.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: slub: avoid deref of free pointer in sanity
 checks if object is invalid
Message-ID: <aIbuks-8-FOckIjo@casper.infradead.org>
References: <aIQMhSlOMREOTLyl@hyeyoo>
 <e6f14d8a-5d32-473e-ba2d-1064ab8ef8fe@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e6f14d8a-5d32-473e-ba2d-1064ab8ef8fe@nfschina.com>
X-Rspamd-Queue-Id: D6421180005
X-Stat-Signature: ra3h7kd4w8kghram335nxn63c4xku6nh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753673371-365528
X-HE-Meta: U2FsdGVkX18NCMubwWOtkDfLwkq7p2k9tBPG1dgk7fS7czaH4LQ1/lwsAMyp+jlDhBqNYjEeXgbwfF3i4zAIQvqXBq0meuvRFHG+XEx75zr4+WE/wy0gtuaXKoSUYd7V9bcxm8+8jiXJ7N732B+h8MKGq26GhKvks+s87gSc3GeIxPj87S+Nhr2vljnYSMUb7VbqD425lDr+D99JckJ5u9Ivq7WZs9JNEeeLz82IFhiqtCdkDWcpLxW/1QKdBBOiv/xzP+b41NQngAKhVaAt2bBigVHHbF/xqt26hd9FvoVWAZ0myFRgIy1hnngQrj1PrNdndKhxfTzXbECUjvFGgULhjgjT5dkTNYr04cN7kbhEB5tq73nd6V8tknbBUkIDyLnLo3Z72k+Wxgtbk18qXPKvQxA/f7EwItGdJhs37OPJu6AXZFNaAzNcIiJ4iBTOcMBzR/+hRX37mfXEpFH4OtYorQFUX0NGemLeVblcjLa3rOIQOwynm/NZqP506IqXerE5us2ixp/zyd5RqtYgixZx8Zy3zzlzRrePUI78ol2Vo9WbPKDsqynEfjHbZcd6COmih/c2nTmdHouUbFvtrlxkAm9dgkhO4f+IxlLyXihngPctb0qlK90fxbUr56SRtJQtBWsHyqe+n7TfRDjA4opuoCuqVW16956DDGrvjHdu4e1HucHKPDP83YTBNOYSzafCtEr0uNHPuZSou31o6b9Odd3xCprMDeLO9KaqBp7lfPHuuwieTcTQgKlLH0RGfUogqROxyNISnGPVE4mSVpXRx8b7h9rADUlzN2/CBLFxNjVWFszPWhWzn9BzKjKhxq7XhlyzWGmeqj8biw+pM2p2Xbh+yRibloFyMnG/GED/90iQ6cfVv9EOkc9ooWCxuQa9HL+Wqhv8D1n0fWBSAL34OqBVuq7eFfNolQXyt9jDEj0zQIED772aBAELnHviWSj0/yMfAehvVFBn3Yo
 GSMB4Ydh
 GS66ODIL9OomYMi/oCagzKI5QyTi7/x76RZ9BPYISNhMJMI1viUDgWC150kgUHCACcCSDFLks01IgsFCNPaNqQM+jHboosPNyyrcafkLG3CMmWYCDBQBbOLbAhbXJBEB+2/agpT0U9++QtomHJOzqmQZyQ+JvUrZaqsSvgs/2JdqgXiXRefo+Pd7fph655a/phsd98VhXpD6tTjo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 10:06:42AM +0800, liqiong wrote:
> >> In this case it's an object pointer, not a freelist pointer.
> >> Or am I misunderstanding something?
> > Actually, in alloc_debug_processing() the pointer came from slab->freelist,
> > so I think saying either "invalid freelist pointer" or
> > "invalid object pointer" make sense...
> 
> free_consistency_checks()  has 
>  'slab_err(s, slab, "Invalid object pointer 0x%p", object);'
> Maybe  it is better, alloc_consisency_checks() has the same  message.

No.  Think about it.

