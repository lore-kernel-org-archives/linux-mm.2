Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB2FEC1127
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2666B0005; Mon, 23 Feb 2026 14:25:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CA56B0089; Mon, 23 Feb 2026 14:25:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FC16B008A; Mon, 23 Feb 2026 14:25:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18A336B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:25:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C336313A115
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:25:55 +0000 (UTC)
X-FDA: 84476701470.05.72C31E3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id C94BC40004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:25:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M2StTi2h;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771874753; a=rsa-sha256;
	cv=none;
	b=UsKOp7LWbtWqvAH7kwbTpXnOrTOcgRwUeTThHF260TGMDaMwJtyWpowIeo90fIfdNVCKEm
	yaX5/2N70hyA0sLiJuTHhhM1nkSXQ2GH+2nVUqeSdEe3HmrYFC+Tl7o1P1i7y53WOfynxB
	UkLJ0/k7uiBuwQVixHF4v0ik12CFJHQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M2StTi2h;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771874753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFnhjaLqA7xLRmKdk8xfCHnT0CZOvr+DnwNRZ1dagcE=;
	b=7ElzIJKZSZEi6rrf9daMsFm5gIAd8K6ZVJUqy1ev06iBxrciuJsCmlr13+Mcg0p84za3ZR
	Pb9Gv4eF1JInznLg9rXmvwVc01uWAzUHtivsrDXsC61poK95IKtdqv+vdddTha71SWHf/X
	iTg4vU7YKTIVWlNhJQjEjkdWLTHZbSY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771874753;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bFnhjaLqA7xLRmKdk8xfCHnT0CZOvr+DnwNRZ1dagcE=;
	b=M2StTi2hwETNvhln0VtxiNhFCDq5EqCd4fGTl94O7RM88gZl7v87cfS+ZrAPDhUP5eEWsT
	Ska2EeE2xs7kOlDsK1j7FDoNLGvj9IVgojnINagF829jeZO87hjB8hfYd8gFfwMn17Y9GZ
	wOshQ7BlgQ2nKtCBuKaJY/EB7YWdd0M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-278-CX_1MFD0PBqBp6L1CjmUoQ-1; Mon,
 23 Feb 2026 14:25:49 -0500
X-MC-Unique: CX_1MFD0PBqBp6L1CjmUoQ-1
X-Mimecast-MFC-AGG-ID: CX_1MFD0PBqBp6L1CjmUoQ_1771874748
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3365A180034A;
	Mon, 23 Feb 2026 19:25:48 +0000 (UTC)
Received: from [10.44.34.95] (unknown [10.44.34.95])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DA7530001BB;
	Mon, 23 Feb 2026 19:25:44 +0000 (UTC)
Date: Mon, 23 Feb 2026 20:25:38 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, 
    Michal Hocko <mhocko@suse.com>
cc: Christoph Hellwig <hch@infradead.org>, 
    "Uladzislau Rezki (Sony)" <urezki@gmail.com>, 
    SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
    zkabelac@redhat.com, Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
In-Reply-To: <aZykWyxLy34o7PKr@fedora>
Message-ID: <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com> <aZykWyxLy34o7PKr@fedora>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OjwYAVb4sg-PdqLfPYkzvwtgmX0RMultGG3ke9ks1Xw_1771874748
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: mwcpyuwqghr1nnmheukkbaeu1qe8yjpb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C94BC40004
X-HE-Tag: 1771874753-224863
X-HE-Meta: U2FsdGVkX1/M+YLyuyZmdRW+6vEAS9uKVAZovpnNmH/mUDzWEdl9k899lHV3mzZ1oM2CESnisup1PLx2GJz3dC1kl2j01fDdhkv/UUpWSc8ugZ0YOVkX6Jn8Fc5Vk4BPM+9+3enOAEiJveQaPxPuMjKKfQrATIcE87CkT/hxy+IUvkzqcKeZOD0vOqVF7IoDkaK/EnplKbyFaX95Jxq31+JtTHnHKGp7Vo4dy50HZbNPug6dL1IcbfVT6cDqIPahhfX+SKVXid3dV2TQOG9uuvljqqYZZXbQ9S9OFn0F8RWJ9PF+ZJ3BwOwddyMceLF3wkxZvrL6kZQW34x9wGnl3LrT2ah9hA0/bsG7o46jKj0mfIbb51hKN4gApZIMPhQxjXQGKsMyVczTSWhtxjeznnn2dfyChVub5O48RNED4YtRG1U0Yb88yOUabOvilamPq1niSPuguBs4Q+oGqqKgdIXdpaJFGE0AdHDwLMc72yskRZqHzhggmSoGV6b+uMHOYXhdAXIW6TYK3FcO1E3IhLSISQ2uz8MH5Dj+x8F/hMK2lCL4krcpu4kmmCd/OQZdvVAE20zr2TYqxQTrb+0aqSEO+PvprD8UP+HoGC9ZpsR/acdm5k1gltw0qDjshqcKuaaaBwce9HNvaCMGD6FUVe7CxgOdZctxitHbTS9Ii2XLFAc19/Ch+Mw+Bxbx5dxzZdMYu48rIESMw83C1wG9Ekp99aS7x39FtWmUj8yiig3C/8Wzk0rn+2A7XD2HX/wXpjSbKDaT+5TpfGSxWKJWAdNSYcOV7Lc3F61sSU/QJgJJVg50zPvMwQE6eNEner9+1mGi/SRhfZ/t+oq88jIej0b99mCeMjCziyhgUtIe6i6ME4L3Q5zBI3/GEK3ZCwUoGrLgk18O8HKMyribiLtIFrGjq0N/slTO5Sg91WFuZ3nTE75VFTdqw3Pj02eYQG/o0PTEz1oiR92Y94/sIER
 Inepmw4q
 9Ut9UYobSfqb6OJ7F8lKeZapKHPy/w7/0t6ziQqhJAaxYFvK17U0pP39aRZ2uw/cwkwF2WQa7ztumbHcgybz+kIBl0kt81Jn4V5lWKA4nB/2SycExJeW+EwfBkCNgCL0rZw28HwN1jigPCzfZ5grMXvntC/G8i/RUaQ6Ko6NQfPoHIYq1pBtT3s/X3gw8Coo87KgB5rdR22OohjHdGVZ+tpRfv3EmKPPBYGtvSG94tUM6sJbYSL0IkLnG98hzdevkDClaZOL2ahhetcDOcwE3ocKFyfk4kvQhmT6ZdiF17EW7nrUw4+fakgcmFQSxvyhMNkKD74H8GeR2RIrApSIxqPpkZDLhHs+TBFAv8kn1sALZMQtjNUuy9CIYrRDO7UwMEDc3sH+lhb52002cegynaOpli6L7isGn4QR/b1w7iN6X4PVt83HJTkFcqIbXjwwetI4p0Yd9j/LsCqeCZyhUAeiWLaFEFZQb9d9h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:

> On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > flags.
> > 
> > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > let's add this flag to GFP_VMALLOC_SUPPORTED.
> 
> My only skepticism about this comes from the line in the
> vmalloc_node_range() doc: 
> "and %__GFP_RETRY_MAYFAIL are not supported."
> 
> I myself don't know why that may be. Could you elaborate on if/why the
> doc is wrong please?

This statement was added by Michal Hocko in the commit 
b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
you think that __GFP_RETRY_MAYFAIL is not supported?

The VDO module needs to allocate large amounts of memory and it doesn't 
want to trigger the OOM killer (which would kill some innocent task and 
wouldn't solve the out of memory condition at all), so I think that 
__GFP_RETRY_MAYFAIL is appropriate.

Mikulas

> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
> > Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
> > Cc: stable@vger.kernel.org	# v6.19
> > 
> > ---
> >  mm/vmalloc.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: linux-2.6/mm/vmalloc.c
> > ===================================================================
> > --- linux-2.6.orig/mm/vmalloc.c
> > +++ linux-2.6/mm/vmalloc.c
> > @@ -3928,6 +3928,7 @@ fail:
> >   */
> >  #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> >  				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> > +				__GFP_RETRY_MAYFAIL |\
> >  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> >  				GFP_USER | __GFP_NOLOCKDEP)
> >  
> > 
> 


