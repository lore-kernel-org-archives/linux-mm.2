Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC13FCAC5B3
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 10:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BAEE8E0005; Wed, 24 Sep 2025 06:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BB88E0001; Wed, 24 Sep 2025 06:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05A2E8E0005; Wed, 24 Sep 2025 06:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E3EAE8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:15:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86BE31607E1
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:15:23 +0000 (UTC)
X-FDA: 83923736526.21.9837B16
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8D883C000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 10:15:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="C oK8aJ/";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=oeMH5ekE;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758708921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+NR7kyouAZNGlBnsC6hSsSQxGq9q0ZhEFiM9joz9Uk=;
	b=6nWjXdBPVL4LzPhdOia4IkXHo2asANFVJbS84GxnpOEkCyFCZ7WX+VbaPeEfcHGPfH9prx
	8C0E2f6vKjkY5xHSLNNebOT21thOtojM7aUEDS/y6pCHz2fqQMsOrwLzWMKoDPIHzAZKGp
	M6xMIeq9aF1DJaaZIbC60Rv3a+mWNL0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="C oK8aJ/";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=oeMH5ekE;
	spf=pass (imf22.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758708921; a=rsa-sha256;
	cv=none;
	b=NTuRK97UslUUBwACguHHPkSSC3RTr6dDIHV9BH3Ij/9yKJqXGPEc9UOO399sG61zgfjfm3
	v3Nu7cQCxuG+cJV4MYvOl+O+6o/CL5/a59tMPB7AUVhgSib1GLmGlNaML0J5nUMgvxQDMY
	SLR4j7yxF8Ez9B9zoJiLekRcGaHWaAg=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E7A4E1400094;
	Wed, 24 Sep 2025 06:15:20 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 24 Sep 2025 06:15:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758708920; x=
	1758795320; bh=9+NR7kyouAZNGlBnsC6hSsSQxGq9q0ZhEFiM9joz9Uk=; b=C
	oK8aJ/SXQYzgSpi54i2hfUFf9PYZ6ZaOWaUqTZtzxlMHpcy7b8KfRCsRMP5YRLvv
	agI1eLrb8Irj7fHvRAr/8HDmhF20HsXx6D0hMqJJrf4dvHJvd2DvrdwC6uF8ZGOe
	ej64AN6H1HTy83ZaU6/iXDYpLBeO/4S1kzdX+BFUcjZGZka7ZzeuQmgSsWDUX4w9
	3LKXxLEh9PFk4NXn7mNEyr7G4Scz4Rz+TOFpSpmrXTn2UcThwa17j3pMtne91TzW
	fDtV/Z4C9ET/MoySyvl07W0oX91Zq2KTpYCRt9WAnnUE4pkc0B5iXUcIxRv5Yjqj
	Mcyo9Zg1v429hmhuyIWBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758708920; x=1758795320; bh=9+NR7kyouAZNGlBnsC6hSsSQxGq9q0ZhEFi
	M9joz9Uk=; b=oeMH5ekEQXuEDSkHFuc/UbhaYES1O3bqPCP/p+UwWLqjtQMuTm9
	/lWrZUaexMYcY/ZBRBtFnbbz4Nw3HUtLSuEIzyFHNGT0rZ1F1shJnbvrPTCq6ZXi
	jVZCRu3y/ZUu9unP9WbUjHoVQIJ7e64ebIHAzvEMcTSqqc3Qw5ql+IYojU/S2KTb
	NsfT0jm7hSv948xW4wmfgrFjJy7kp1AktnrO/ZlWKsx40997tIDhUZDfMfsdCpHM
	9QmIsPuvHINQbyPYlQBfBoD0obbN8dCdJa0/ej8tYm0V4uSujPloBOgHufoJoebN
	RvKtJEPcRUIrStWKFO7CXRiJphMdg/A+aSw==
X-ME-Sender: <xms:tsTTaE71E8U45I0nmn-URjtPsRCZJyo7NpaBLWg2xQOp_BTTZ4iCvQ>
    <xme:tsTTaPloWH22RPiyXbjG-TFCt2KGCa8IeWx6o6g9JMgdF56_6n3_4xUIKhsM1DfA8
    oSDrqDP_Ttf7LWb3J8iTesSFqzsYpWuj8d9TnRAFBVruE2tC09TlA>
X-ME-Received: <xmr:tsTTaCyp4X9OUlVIEYO91okjhykbmKZ7A897_6yYipdR1L54JhnHKBtfUkob_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeifeefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfedv
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtg
    homhdprhgtphhtthhopehrihgthhgrrhgurdifvghihigrnhhgsehgmhgrihhlrdgtohhm
    pdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprh
    gtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgt
    phhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthhopegsrgholhhinhdrfi
    grnhhgsehlihhnuhigrdgrlhhisggrsggrrdgtohhmpdhrtghpthhtoheplhhirghmrdhh
    ohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehnphgrtghhvgesrhgvug
    hhrghtrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhm
X-ME-Proxy: <xmx:tsTTaBOuo11_00bfnMhOf0Waan3W5GtDYESA01V3DrZ0HjCCSIYj2w>
    <xmx:tsTTaMiEYj0oYPc_Qg6j1BYi-eORs-Vts_6QHSCsxtZRmmQ1y7EYBA>
    <xmx:tsTTaHXdlxvgp_cTCLt3WYqyNhZjRBSfPI8f4kcDkAiRSLp6Gwhe_Q>
    <xmx:tsTTaCzGT-vmVr2yzqny6dYjNLGD3x77pMK8rzYxAXZljPNLh_3vlw>
    <xmx:uMTTaM25mj0be4b79ztuhEhVlC4cg26HoBb7BYUTwnGiqgE6-eAAO7DE>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 24 Sep 2025 06:15:18 -0400 (EDT)
Date: Wed, 24 Sep 2025 11:15:16 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [Patch v3 1/2] mm/ksm: get mm_slot by mm_slot_entry() when slot
 is !NULL
Message-ID: <hzwqdrkfdnreb3liohafhxkd3fpfnzbpmqzlosktevehzmju2i@5nck6ryrlgrz>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-2-richard.weiyang@gmail.com>
 <27storxu4seijr5smul3xx7pofe45ittjrchii3jtwbntalsiy@2cu3wf42drwa>
 <1ebbfe02-1cb5-4f7a-a640-68d5d95cb99b@redhat.com>
 <viz42o4iscxkpxystnikuvfnqzwwfq3anivizgx5dncm4qyqvu@4kymskstues7>
 <ef32e31e-d04c-4604-9786-adac33591980@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef32e31e-d04c-4604-9786-adac33591980@redhat.com>
X-Rspamd-Queue-Id: 8D883C000A
X-Rspamd-Server: rspam05
X-Stat-Signature: gnkqncwuu1abt637j5h7u1mnytiy7hrf
X-Rspam-User: 
X-HE-Tag: 1758708921-528456
X-HE-Meta: U2FsdGVkX19Rfrws80Y3KyeKqOBYaDxau83aSQdAwyssdCa2I/z/MD4idsAu4PxkpsFs9chOl2xewvQtMQ0MHO8AyeKnOOVivR+kQ/1lNpUooIWwhM8fdGGRuKA/22LS7BH7MYB/tTseGJmjwtvXCcXadMHFTs2NPJl5OoRMvef8LB01nihCmv1SouWXmhq0Fj7ql4aeOku1ez882cXjLvXQmQ6aDmNMX0M8krLj/B7c5w7FiMnQNUq+f3Sl6CHcGXHhG4ilCZcigNUrj8nPYS0lKdgNHe6hE4yAK/L1aCJzticFtrKx4BmkgNWV48wQMnyU2dsO/ExIn92UpFrDMfDu50e/9k17rbrvV+/u9fvG6bAwjaK9hCsD+uLhcJaK739rb8MF9xyiQexZc5ZCAS+10QDrsudqEq+GFGWRIv4OYfWbleabJqUX4qbUHM1DVYi2UQmLFxfRGDNhV783mA1U1KgScrWjRgCS8TconbEehkYSackUeWPXCKanZpJp9okwoJk0TU+7k2/UmlCA46em96KBX0oHJmQBmmqd4OTVEjP2JqDWV/X7JepnIbsyUl8XZ1fdsuCEoGvhwnhGzrsHXNC5xLCL9crACipjes5sIWFZ5VlgSTmB6FxPE8obLh0fqrb8bTmv0K/Ahef1qHhmDnFzH/pT2Qqt01pXfWlgeLFO6/evOZYsCcAXvwhbe93Cu2p9Va1Cl7aIpGanPXxLynxXwKpxhMDmNByBCSRp42mkIaR6fw2O9pMDv3J/uQ/1YhfG0cp8WqHvmtGvm/IR0jss6sPorsCORX50MnmUiLDkp0ieR2n6LjIEnJHNBxotZQRGeakFWskshUshyhqhQnM0+vQyGV24Lwy3HhzouwinHKgMLQWFx2qFKi5dEMcy8y0N6KhQXC+CkmRRLM12PuRbCan6FMKhQV6OJhaGDhXUX7gkTYqEf/nIij0pFzfkevAdgRgR5thBADz
 X0NAmJsy
 kcKnVj7XttIk7WqibDSdPrMPQJ5sDhKWmuw50YESn4gjSd5r/owowEl7j2RMcp5g2NkxW8vO7k50/81rbKt4RG8UIEhwh4mQoBnnb8v7XJHD9FjniU6KTGxNa4ud+CK2Or1yNDQ1L9j7448T7CXlYwH9i4Ealr7mzRp3xcUI+ezbxbWtfquwmqMcuMtCpI5gs1ALbAQl4Z3t8roRxu67Hq5dVgpYmfKCls2wHUOa5mVeyYqYAYReIIhtO/Ug0otTMraqfduYfUoebaNifxd4O4elRDTEqwB+k0JI7Pt+MkjAP93Pw0vhMZW5uunvlj7Bp1byiMR2fYvtphqF2GybDbO0gTOTK+b9+DSXsewIQiCB5I4Dz+QQCRW1sC0yBatTUw8jsmXI68uFh54IYHnd+R/l79iQmSCezTyEgffEb0c3IHRz7nvdvXfQLQO708UFFhLqmpeeCSoIFjalgz8LNvfyt4ISSOyDIq2MSw65xuSzSwjC5EDxmKpW7+3saQL6jpO6dyGr5dvE1v0XtKFEVrBlmrP7d4t9n566mdtUiK14QMyFuP/0yPT4oew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 12:09:03PM +0200, David Hildenbrand wrote:
> > > > >    mm/ksm.c | 22 ++++++++++++----------
> > > > >    1 file changed, 12 insertions(+), 10 deletions(-)
> > > > > 
> > > > > diff --git a/mm/ksm.c b/mm/ksm.c
> > > > > index 2dbe92e3dd52..c00a21800067 100644
> > > > > --- a/mm/ksm.c
> > > > > +++ b/mm/ksm.c
> > > > > @@ -2921,7 +2921,7 @@ int __ksm_enter(struct mm_struct *mm)
> > > > >    void __ksm_exit(struct mm_struct *mm)
> > > > >    {
> > > > > -	struct ksm_mm_slot *mm_slot;
> > > > > +	struct ksm_mm_slot *mm_slot = NULL;
> > > > >    	struct mm_slot *slot;
> > > > >    	int easy_to_free = 0;
> > > > > @@ -2936,15 +2936,17 @@ void __ksm_exit(struct mm_struct *mm)
> > > > >    	spin_lock(&ksm_mmlist_lock);
> > > > >    	slot = mm_slot_lookup(mm_slots_hash, mm);
> > > > > -	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> > > > > -	if (mm_slot && ksm_scan.mm_slot != mm_slot) {
> > > > > -		if (!mm_slot->rmap_list) {
> > > > > -			hash_del(&slot->hash);
> > > > > -			list_del(&slot->mm_node);
> > > > > -			easy_to_free = 1;
> > > > > -		} else {
> > > > > -			list_move(&slot->mm_node,
> > > > > -				  &ksm_scan.mm_slot->slot.mm_node);
> > > > > +	if (slot) {
> > > > > +		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> > > > > +		if (ksm_scan.mm_slot != mm_slot) {
> > > > > +			if (!mm_slot->rmap_list) {
> > > > > +				hash_del(&slot->hash);
> > > > > +				list_del(&slot->mm_node);
> > > > > +				easy_to_free = 1;
> > > > > +			} else {
> > > > > +				list_move(&slot->mm_node,
> > > > > +					  &ksm_scan.mm_slot->slot.mm_node);
> > > > > +			}
> > > > 
> > > > Indent level gets extreme.
> > > 
> > > You call this extreme? :)
> > 
> > Emphasis on "gets". :)
> 
> :)
> 
> I would prefer to not make it okay to call mm_slot_entry() with a NULL
> pointer.

Maybe invert the checks then?

	if (!slot)
		goto unlock;
	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
	if (ksm_scan.mm_slot == mm_slot)
		goto unlock;
	if (!mm_slot->rmap_list) {
	...

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

