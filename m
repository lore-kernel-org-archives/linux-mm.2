Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E08ECCD5BB8
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 00:08:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8992D6B0092; Sat, 23 May 2026 20:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84AA66B0095; Sat, 23 May 2026 20:08:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75FE36B0096; Sat, 23 May 2026 20:08:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 623E06B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 20:08:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E12CAC370A
	for <linux-mm@kvack.org>; Sun, 24 May 2026 00:08:17 +0000 (UTC)
X-FDA: 84800376234.13.64B98FF
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf19.hostedemail.com (Postfix) with ESMTP id EC3281A0002
	for <linux-mm@kvack.org>; Sun, 24 May 2026 00:08:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="G z2Mjny";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=P66W112j;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779581296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOW3L8R72QTY5Nd5WS70HCXZ0iclOnm9lq7EioHVhjE=;
	b=CHZeYaLTh87bhxDRYI4SQnGVkF78nXja1R9wIY/zsHYeU75ZKn2G+pePpym1BQSPfia6YE
	EO2cZKTwN4odhkmHf0UuuMBC5lk2LjT0G7OZhhbQwAx9mMGp6tm0gMMsXTmAXzwF5REFoK
	eX+M+rGgIGIdYgWiGabYonOWAKxonao=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="G z2Mjny";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=P66W112j;
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779581296; a=rsa-sha256;
	cv=none;
	b=jsu4bxWx8mKvxqS0HByo3vYBboIb1ISrJLkVMLNyoSUAVSXe1vpgGFkof4Z3uLfobtVRLE
	D2cDrQ5daE+9VOjFwUb5sWNEIBtkr+InF0/JCLbQp+0nCvXti67UcGWkHzzvX9PqnMhutP
	lCTHpFTzrgdG+SB8uHsVTqRML3Z1dJo=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 932CD130006C;
	Sat, 23 May 2026 20:08:13 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sat, 23 May 2026 20:08:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779581293; x=
	1779588493; bh=bOW3L8R72QTY5Nd5WS70HCXZ0iclOnm9lq7EioHVhjE=; b=G
	z2Mjnyy3ZUQAyP+kZpFy4wEXbtv0zxxnMI6FV69F+8GKCYhtKaiDlsMJG7jY9awP
	odBNaWeImYySll7F/C1d34/zqHhu+qsMrTtmOfbsxdZk+hayWEt6AoBrYTPQH26d
	aeHldZrblVRhSCJu147s35HSgt7FXr6ofwCOTH0r5Sd2fWvcBSYwbC5sKbZZpowV
	ekwysBPN/34GBSaXKCFJDSkLrv3Iierrpn8VldIcS5bRmtl85SmCKBI2RG6vbs4O
	Vn1Y2uSKbdFZ3VIv7kmp/puc9kRBTQZLpCg0x969TJJr/DdmwZ0AAF8EoW2zo3jv
	ILqCxHY2SrYJbagitsVgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1779581293; x=1779588493; bh=bOW3L8R72QTY5Nd5WS70HCXZ0iclOnm9lq7
	EioHVhjE=; b=P66W112jOXxtTt1/jIy4NYcASQN652h2lmLJHJxnzyIkd6LSDHS
	q+9rbiNxvG0zVVExqVdFthlE4GioU4qqIFcKXHiaR/ZevjEkAZruUCSxUTLx9nUS
	cg7LdRV0lxscEx2CiIFFFjre5ByxgXPsrviUlnoNTeMR35vDjoblNmgyNMoiGl48
	CLN2lJbQq+P+WvI0Y6u6pKkkvK/W3dOm4rc81VUKX2ExdlVi/+M0r6LBJZRvTzq/
	PLlHafce62O8Ae7clkqIbWNoHKA6fOdUzOnzQj85aZPxpbVOdw4X1svwMWxcCetE
	S57k0MBOGDhp7iwPkzeynimC1BgTWRIXdpg==
X-ME-Sender: <xms:bEESaughE1L8wNAw6-Tboi_OTEbrkiBPfWphC1gVg1RQ0KrCDmoFUw>
    <xme:bEESatfw7OYcKZuldoKZDe_ZkA6LtlHFpKmNTkcclHawnla2-c5qAYXlfJUrW4bl2
    DH3PD5U6wdkFSy4Vq9eVmGtMo2rnyzUuOfqrBnmoc4fvupH3E7v704>
X-ME-Received: <xmr:bEESatM85Kp8Ys-ayUtcBSyAEHje2dFDj7owp50PnBRNkrl7PRqsbpsYMjNjZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduheeggeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdertd
    dttddvnecuhfhrohhmpefmihhrhihlucfuhhhuthhsvghmrghuuceokhhirhhilhhlsehs
    hhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeeiveekgedugeetjefgue
    egjeejkeetvdeuvdeifffftdfhvedvffeuieegleegvdenucffohhmrghinhepkhgvrhhn
    vghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeh
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhg
    pdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopegurg
    hvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepvh
    gsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvght
    thesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:bEESaq0skpAwg1PDaGi8DjW_QLmZtPVZCUawJOQjS0k8IqvCgw_WBA>
    <xmx:bEESavKPwDlFOe7kGEZEbtj_Uc_XsLeXS-q16eVt-Aw1hmkTnjbnZQ>
    <xmx:bEESajZrCvLqVpD38kQ94zW1JHxmFlUZkVDJOddnEjnU-6y2pADqmQ>
    <xmx:bEESagnduI5E4gsBSx_8kraDKWUi1jSseknqfEBu3ikHn6oihztVYw>
    <xmx:bUESahUyLmGaTkuebIyTdGRJozup0-YDPiaBE8kJpo5RZGkYcDDzF81d>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 23 May 2026 20:08:12 -0400 (EDT)
Date: Sun, 24 May 2026 01:08:11 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org, 
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com, 
	ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, seanjc@google.com, 
	pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, sj@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	kernel-team@meta.com, linux-man@vger.kernel.org, alx@kernel.org
Subject: Re: [PATCH v3 15/16] userfaultfd.2: Add read-write protect mode
Message-ID: <ahJBTaobKD9XdT33@thinkstation>
References: <20260522133857.552279-1-kirill@shutemov.name>
 <20260522133857.552279-16-kirill@shutemov.name>
 <ahGDbKr2u6sqoc3f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahGDbKr2u6sqoc3f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC3281A0002
X-Stat-Signature: pbuhhy9eex1syu3huhj3h331psojw14r
X-HE-Tag: 1779581295-626718
X-HE-Meta: U2FsdGVkX1/bW5xLEZxVFcYgfSStuXaKsFUG4P2+bswQbTXFahtCw+kHb6EwdPV+trTQnZQZaf1XHaJz0PR7dRz+WWS0ybJTp8SdAil40RNBrzuJG1bFFzfUDlhkpbyin1dxHOhspvjA66URRr+wuP0fBBwWsGkpHEwQlnG/jSEEB/LbcQ0oREE6/4pMjYtwOZEAIjXO7xKpBJzAuaHjTp8qbAuar4Wfz0rMpMLu79RLthzJ4zBXEeV47++DMn5uPzMQ4QS5dTG0rj7BvRrExxXcy24LcqyR8NDyQS3fbZjROygSLSZXzj9f6Lasd9UqG4Q4+Rf0+PNgCKOSMi8qIlyDo9bJ4+KDybVM0DnbiOuZ5vQ03FwVZE3SHz8q2FtYobJ0JEuh7lVkhQpRX6vDnR8RHo44Hj/iOoFb/iW+/aazdF84uEXTMULH0txTS+ppBzPvCtSYk4c2DjDShMtLr5k4Lg1ZOA1/tKwb3oX7G3HIFxfJTsQRH+MndVaxcBHmVHHO8h7cK3XfqJA4mmR7qCUYTFpA7zF9wCqkKldaaJQcbSM9428GJDvGDw8n0Mu2nOmyF2Br08aO3tsFtUwHpGOWlvNI6Fp5h92CFeoSjOu3pNsq6XEZDpY/N+UsRER3DsBgrXMAFoytnWrkj48uWCJr0hSPx9fEtmLQZMvcRXQ/Cs5DgNqSlG3+Dcj1jwx8Ag4r6yw8GmPntE9bQ/ypH3M7vMjCtlcT41VI6LaZU79Ade5/lVhEf7TkD9Y4ebPxMa7CDmkfRVgtuXsDnBip/tfdpNSbEBoVdqM/KL5O4LUAKysKUm314TJnRv0krBv5RY4YibrK+1tE6Ah+3/wCaSJR1ixRtQJS4kw4F1910EMyJ+QIFeUsFk63QArQ4nvvO6HNwEMav5rdP9rjQMG7RBUcJZOwN3DcFeFKnXKJ74cdp3GCmlggdNbQTp+dCEqmH2P2Yuv/d8mmtfpfy+5
 GrPoYmdg
 ZZmF1w9eKAni+CuPCF3szeTf4hldRaIV/e95zGQYnhQtVt1fRArJWi7sTx33tMnZGHxSHNm4eh41aSW3wMkYfPANCexl90PF1pBaZ8O95fv0JcoEKHL80cyHyoX3N4COBmIqXSmvhA5VbDobzhcgsLD0uFIJ/ntEQ02Cwr+0oX6DU1nXJo8xJmd04g5eRZE0IhqUwhex2kqVIST5tQgMiDSICKikuNCbO/tbSok7OSGIvmTe04D+GcPUGgEAvu1zoQAWApUVULeCvTZo4PAb1RopZdniSdx9gctLvFFnCur/m0wkURKUfQ6VeqPPGlEeyfjXhgXT3lDTxbd7D9Y+f/0lJwrLPpR4ZE7HdFuJbwC2bcGd/h4UZyhs0rocbwXYBitV95pXwrp+MxRnIPfRAt0TFFJQk0UB7GmsMdhzLBMY0ooU4ExXG2235KSHXyiuA4koxSqfZ3lCbErEE7CW28ttyBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 23, 2026 at 01:37:32PM +0300, Mike Rapoport wrote:
> On Fri, May 22, 2026 at 02:38:56PM +0100, Kiryl Shutsemau wrote:
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > Read-write protect mode (UFFDIO_REGISTER_MODE_RWP) is supported starting
> > from Linux 7.2. It traps every access -- read or write -- to a present
> > page within a registered range. The matching UAPI consists of:
> > 
> >   - UFFDIO_REGISTER_MODE_RWP   registration-mode bit
> >   - UFFD_FEATURE_RWP           capability bit
> >   - UFFD_FEATURE_RWP_ASYNC     async (in-kernel) fault resolution
> >   - UFFDIO_RWPROTECT           install / remove RWP on a range
> >   - UFFDIO_SET_MODE            runtime sync/async toggle
> >   - UFFD_PAGEFAULT_FLAG_RWP    new pagefault.flags bit
> > 
> > Document the new registration-mode entry, the "Userfaultfd read-write
> > protect mode" section, the new pagefault flag, and a VERSIONS line.
> > 
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > ---
> >  man2/userfaultfd.2 | 147 ++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 146 insertions(+), 1 deletion(-)
> 
> This doesn't apply to the current man-pages tree
> https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
> 
> and reading raw groff hurts eyes too much.
> 
> What linux-man tree did you use to generate those?

Ughh.. Used old github mirror. Will rebase.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

