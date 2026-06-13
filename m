Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B12FCD98D2
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 01:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433B96B0005; Fri, 12 Jun 2026 21:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3FB6B008A; Fri, 12 Jun 2026 21:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA6E6B008C; Fri, 12 Jun 2026 21:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21D4B6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 21:59:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 849471A027F
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:59:27 +0000 (UTC)
X-FDA: 84873232374.29.67976FC
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7F6C740002
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:59:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mXVkf9iC;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781315965;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6ZHe4A5e/aMPJBOdbqphS/Eo6/SVR2nadPy6eK7NUo=;
	b=pDgEoyeFt5k9TElo6nA0DGR+22oT38dg6OQ+WbqH1Tv7d+dt8RVHSXN1BMq1vT7UZRE+39
	w8lwh47j7grYw71PrW7PfGkgit7o3XDrfjftVDgvzWGyopr7hrq2cf7OFGxk71YaA9lBh9
	jK4HKTQ2/WQafibqcDGzNza8UiZew0k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781315965;
	b=a0G+1bC5dwipMFftO0jGQo23nGpasx8JA7FA1sfOs1qYZnC/jUgOUGsaaqzuK2CT+4XuTG
	MWDqG9JiTWniMSBYLcYKRREwb0apjXgojClQaxDCXZGQmjkZNLmBICUlnUau73AE+urlUP
	ZNpPir3zs/CwB1TT5v9Y76lG7LBK/3w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mXVkf9iC;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bed2195323cso239788566b.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781315964; x=1781920764; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w6ZHe4A5e/aMPJBOdbqphS/Eo6/SVR2nadPy6eK7NUo=;
        b=mXVkf9iCWFVIVv4yFqMgN+f2mR0nyD9C1heIr/BckSOF/hbW6paTMR7U2kABOhjDBH
         dU+ciUrnfXHcW3EWgmSAscxUkyTyf4/3jIuxRKzC7BDjPPE5LjTBRhjbTl7wzyQS/fHA
         cR9CdCnaFIIyLmXSCVtekk9C1ixl/Om47/BUnMQ48qHWByPhB/2vZVRdN049VCBbtuI0
         +ciVCy042JHI7I7K7SRjZw+Mc5kKeTPYo0mZ7e1V1jeUEeA75bZyxcnuB+1eFDKeowN1
         HL2+1dzH94sgfPbtLNXpgKIGC0kvaRcWZJpgX1cs3diQPcys01EUyA+Nnin/aUsA9Baf
         gvIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781315964; x=1781920764;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w6ZHe4A5e/aMPJBOdbqphS/Eo6/SVR2nadPy6eK7NUo=;
        b=YMg+CUz7IvSfUBDVd59UMXUMy69r3z58ZrjWLF6MJkdAorGcYRy6va4lvaj8eZOjhy
         RFTZ8L4d32T9DnfZc1MWLHXp0Zb5CVHA1QK6ovnQbPelzlaWudHmw0qN74tOB6j3cfWU
         22+ALE2o6ENDKrDSfNxXkE3jfGnPjsErlWa7+z2sqs2xMfIiW5sA6mVeBB5M3Y2qfmdH
         1/ELpTf8ldG/W/kQ2fOLqJkBjByIx6zaG3UFr0PF6PjJfNR3t6wgL1XNu6YwTX8uobar
         IcGwOt0O7axkPTiCYrfmPUrmd4JyIdsfBJhO0qoqnfzT5tm2Gr4/gDXyBALf0L/vy+L7
         0EvQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mgEBo5DMT7Jd2tQ5scYG87+NkW3z2FoQ0eRc1vKJnYxJ9bqdiUTQMTwNkIejofJI/wgap5+hBRA==@kvack.org
X-Gm-Message-State: AOJu0YxXhDuAgJAPR4UinE5mPgaT4urLBhg+3vHmGAemWg6Q6+j4UC1Q
	IZ+x8S7f76gDlDXoTbWARI0Zb8MKFAWJsJW5qvolSM0En/A9S5El0/tR
X-Gm-Gg: Acq92OGafUZC2CLyJvxj0e2o0q0kfDemIgPPCHC7ruNvuV7BAiKWmXv8P/lfbfBGt68
	jW8fghDSp5NRi+zjcumxTB0XYi6jseYehEb6IQ0rv1dx/wie9sdXmuxUDyzDhnjGtBOmDRl99xx
	nZZvXpDljpFOuQ7e4U/6o+mkeWx9zBe4TxvSDD/z5JfAHBhRPIJR64jGpUa/D3xzO+tPduto3BV
	kaqimKgFYDLmMnalEkQimbBYOJ9F2wTEI4zzRYH7gUBK9A5bcrRzajOoZG2LqNR9+O0mVlnkyA1
	X+3Dh937vVPLlNu+Pum3q+kmf/YK4pJQZIuXJ/JsfRnyL5a+PV4T4Wqc1E7Fs6JCZhGqXxZy5Le
	tNrchfYRvW+mCxkjfnFCJ86GNuNOjp8illotoPTMCGQ65tXgQoK8XRFL1YW1vLD/XuoNHL8R4Ge
	HhD+lWEUiJrtN4h91yagomig==
X-Received: by 2002:a17:907:1dda:b0:bed:19af:f8aa with SMTP id a640c23a62f3a-bfe26f2e649mr197263466b.13.1781315963582;
        Fri, 12 Jun 2026 18:59:23 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb7b6dbbcsm171655466b.32.2026.06.12.18.59.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Jun 2026 18:59:22 -0700 (PDT)
Date: Sat, 13 Jun 2026 01:59:20 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE
 accounting
Message-ID: <20260613015920.pvzhn7q7lijhouxa@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260609120443.71864-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609120443.71864-1-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F6C740002
X-Stat-Signature: 7x36nsu9zs6xkipgyd6yeq696jfs9hat
X-HE-Tag: 1781315965-471483
X-HE-Meta: U2FsdGVkX18vmAg9l69dh89mqL+VwkSFyNw7GuW9ArMSBLWA4jzFOeOiOF3xFJCyget56LKAMEJLFat9uVcQPx9sDapOYLGBlAd4VGj49SDjLKEX5mpGIxDvATXgUdnjWus8x/v3tisSAeIzZAmQ4gmy6O1ZUnfwu6imOGux5BhoLK7OLCOJmbKM8ixglTO1fLsIaqVaL88j3kQv1ELzLJq44Yty8B4FVynjTXBsIbSUvSeuClxWo80Eev/7GBPlQxmg5NXuVZIG9Ppe2wEyWV3JZd7H+1vcAA6St2HHMHzXZl6Cp+AWd6raqi8uID65fKWYSHBoPF+PP/vEK/PxMHhMQH0voBdTQFPsK18873jlT5M596H+tqkXGD4daKWpAvYuS88Ns6nWXZosaH92erqsaqKh+/weNXde1hfZJIc687EogYHOiz2BJqlwwn/XkvtK/NGeIiUSPrWfncqpdhrS6MVn7HbVoOFOjt+IUkd8yr6KH1cZ+1EMQ48jAR9qaoaFV+4FXE3g59q/HmyyQT8ycZvV9WHScL2qZElk+MzTAReaXhFkrOEHtXHt7RrUmgSwRNUAJ7HU63MOCiVmwHzlGqYaYeokj6onj9E9e3J7RfAmSOsfSRsdd7ZFh2ITxIRS73SRO6jcEuZDMR+ldtcptlKkA4JzF/JZD+du/qLGcsCcwCIlsnZGidoe4TapBI6KPt1pAxZZxArubdFq1QAlvNApr4eYd3uO7fADhEDGmEN3S//e8+J3SMiqCGVjQz7zzaOjZAMW1fu9TkGgtduSuTEUP/41tSsPCNkZopC2jfoSmkdqovgQq4cBiTNErCgRbsW4eCOEg/NWRMCljET5ZBtx2xLfnCMekH8cJ0Zbllri2/lWsWwkbKZfFpGtG4b7ASK5AsmenjG2J1cXRDYFPVK/hWey8CB36iBN+PUnt4hAdTmjlo70TK5566Zejf6MZKHY2x8eGzeZuvQ
 wQwxIZDv
 D4xu+V1YEpm5gykynuKg2TzXk+4yf4CLQ0+3JWU9GnufYQFXdfaosrBRR+SSg+juGuh7do5Wf7pBwK4RpawYzkwCC6V6I61qLhxs1gzIl8KnbwpbExGZTddD40qV4zLV/qUYjoFJAKT9BXR+RAMY1dEXpZM4bJbQbFepfXjg+jY8cdDZZzYffOa5lvhJA/XhvNiyJKla930ZrelZ3uM1Hgy8upl3gAK78sOYQVamQ7f82YH5H+M5mkbNwBgr6f5GFMHN4CY3zf33a5QTxjxBZOxckK1n2V6vSadst+4Igh4v/FU6+DjJIL94K5rlPndupheBUFIL0ELmVTVhtQOM9QpiZ9J8N52ymsfTCeKfTUcLcsYo+Z6eHm5AuDpc//XuCRfmlnwdha53oYLjVlCGpLSv9HKcp2p5PpXqlfihu0HtOLd0Us7P0VpjsSwDdp/WyHgk+9BZsab1/W6frj1Lt/nMQJy6NeOZRRAQ5UOl9ogpCiQ+KEK9vC9N/28efuiA2MHVDQ8IawD3ICEd63f5x51xaqYT5NvQGzVDATRn9yoseaVCGG+D38j4ICS+jMo4QHx4FMnUqsMfjtavlEMEVdzxeUKpBJqhnLfODQyEaMkhIQuxtHTNnih0vMEuwAnquZHFc47ud9HrII+zGLrEIPHqxwit180wOVlt5XC6myNiqzGI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 08:04:43PM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>mthp_collapse() uses mthp_present_ptes to decide whether a range has
>enough occupied PTEs to try collapse. Swap PTEs accepted by
>collapse_scan_pmd() are counted in unmapped, but are not represented in
>mthp_present_ptes.
>
>When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
>so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
>then checks the PMD-order candidate using the bitmap.
>
>With max_ptes_none set to 0, a range with 511 present PTEs and one swap
>PTE no longer reaches collapse_huge_page(), even though PMD collapse can
>handle swap PTEs up to max_ptes_swap.
>
>Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
>through max_ptes_swap, while lower-order mTHP collapse does not currently
>support non-present PTEs. Keep non-present PTEs out of the lower-order
>eligibility check.
>
>Signed-off-by: Lance Yang <lance.yang@linux.dev>
>---
>Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
>case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
>
>[1] https://lore.kernel.org/linux-mm/CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com/
>[2] https://lore.kernel.org/linux-mm/20260605161422.213817-12-npache@redhat.com/
>
> mm/khugepaged.c | 8 ++++++++
> 1 file changed, 8 insertions(+)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index b12187709f6d..617bca76db49 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -1508,6 +1508,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
> 		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
> 						      offset + nr_ptes);
> 
>+		/*
>+		 * Swap PTEs accepted during the scan are counted in @unmapped,
>+		 * not in the present-PTE bitmap. Account them for the PMD-order
>+		 * candidate.
>+		 */
>+		if (is_pmd_order(order))
>+			nr_occupied_ptes += unmapped;
>+

Nice catch, I didn't spot it.

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

> 		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
> 			enum scan_result ret;
> 
>-- 
>2.49.0
>

-- 
Wei Yang
Help you, Help me

