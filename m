Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520E2C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 07:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B7D6B008C; Mon, 28 Sep 2026 03:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64ADE6B0092; Mon, 28 Sep 2026 03:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 561B36B0093; Mon, 28 Sep 2026 03:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 349556B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:45:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6EE6160117
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:45:08 +0000 (UTC)
X-FDA: 85262385096.16.2E556DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1CC0E1A0007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:45:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lVaamqi8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790581507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55E+7Xyi4mRyjZvV18kG+lC5jlQq2LH0rb3Tdnf32vg=;
	b=yepSyaZO2ztt/XqPDVWCum88o+JcuvEtNh4r57H9SVVgrSZzy00Hs0pIYlZooR9ZijI5yG
	o2X9Z0Ttopmr1Ggh94zuN+2Gjvp74v2On2UjCKXAhd9rbNZzGRWa8DErXLd4SvoxAJiQhX
	CEwzRxPOCvAPLHDXxUowGUBHL9p/8Vc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lVaamqi8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790581507;
	b=NFtAqNiTveaI1NPOLM5NKGAs9R9jH67uEBndciYZAJeI90u9Zi+J6aOMZ0PZoOwQBPd95Q
	Fnx7beFRb0L24oU0nDdnFQeZGL/wCDwxuOQFk8t/eg7OmLapbVPUhczwh9hJU7KOoLwLBD
	wcV25W0XSe0Ona4gnZW/qmVLPzHClWc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5504601FF;
	Mon, 28 Sep 2026 07:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5A41F000FF;
	Mon, 28 Sep 2026 07:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790581505;
	bh=55E+7Xyi4mRyjZvV18kG+lC5jlQq2LH0rb3Tdnf32vg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lVaamqi8MOEIqD63EMXcfX6WUtSC0+mayO++7CAbtN5Rj7XF6dFa4J3bFJZS9xUA9
	 eX0BbCOM58MtT2oHAL4U75vewBaDx54j9M67lVMa6jc9JUjRqoxqMegguF4wvPdY1V
	 Vr75Xg5+0MrMZ2roA0fVTlOZiPDE2yLQeJgKAWelgnGAvoDuQFVfDCnbUJoFCGp+TW
	 UDidlbWrzDBv8/7zWL51f63+Kqw79erWBhHPYwHn23QCmQQoGvXShmx2h0UGH1IoUt
	 Wpx7lB6J3IyDcQLHb+M+O089SXTZEYWQTMnnuA+Xz0QTYvNAo4pWz97vSCAAw2BeI0
	 109RRAMplWFfw==
Message-ID: <99023678-fd8a-4eef-8e43-a07b504e3e96@kernel.org>
Date: Mon, 28 Sep 2026 09:44:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-new 661/679] mmu.c:undefined reference to
 `__check_safe_pte_update'
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
References: <202609270030.Y0QVBPmK-lkp@intel.com>
 <20260927133100.46a4f7067c79280dcf83731b@linux-foundation.org>
 <bao3loem52ww7aplteu4ialsb2umep6mynhofp3loamdewytxc@pexxabh7vdf4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <bao3loem52ww7aplteu4ialsb2umep6mynhofp3loamdewytxc@pexxabh7vdf4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cydqapcc9f8pm93pj4annewxqhdoidqe
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1CC0E1A0007
X-HE-Tag: 1790581506-751750
X-HE-Meta: U2FsdGVkX18Q885tt6bisXMUKMGNsRvhFZ0oTD3+FQLi7QpHyI7JMrLj6GPeE9xv6BJtPucGSCXs6AG/Fc2PLcM3RLV8mlv/ztTxcMKsuVVKwtJGjWDQOtoQdqEWu78+6ojs98bkVKoueKaZwUE8MFdX2D0tP7cX5uPXoeN24vqSGfuMwnnk2tpnI4AO98t6WUrD6WYcwPmAjSOLcO8CiZ5GI8AfDj6hk1VP+80Bmb+jxpSyYytPN426ImxNGcBRIlCtdJjgV9KCBJ2ay7CqwSP0xXuUDUhU91aLUwQNDTRGai6gvSCghnbsB3xF2CL3qT6jLXBN+Eqoxm6WmVDJ69yGFFvHVvB+8l0wo5a1mTCAyCsyKVyxXrXJja//YjnzC90jnBjABI1JyD//zVrF916rOfufb7di71lIzlqy9RJ9MgFoeRcJzNcT6JTeEtAfjZolvCEGBvBXm8V0NMIh5cZDbPJonRuQcZIGWDObrbRDRgYgDDIIgCxeL4aD0NAMyI5Y9EXTVl5ycvM/kMID/Q7yW8D9xvDyOWPp72XCPBXoL2n9XoGxtJT7tIfoz/OmofzH2gSRiPCvx2qtLfakLBebhSl4/UPBNaE1LOBxvmJEV7cVlP0TiWbiu48c6TjlvPCbx5WeRQvJ5iKcxzsqg4TcwZQulacpbJ2GdvsM24oU0ZP8hpR/LMCgk7GMKKS5tYeVMcn9qVC+QXZA/7Pi5rmE25ISslF4rdUbHpMP7sx1jSvNyGbFrtoeci5hVqqFTV8QH24qbkt5j4/8YuLUUqZomqugUkQabLpaiIIW6a+KPMx5blfh/1pmyOezNCU8DBlZYTJMOQp7DU3w/SM2nZrbiRZXmiQNYrsxM6Z4PkXStCJBI2lxsKabhJ10IhcnTiUpDp9dKHieX/iRAxWCPJkqGjwYm9meaPWRyPxx9k/OidHn2u/zW/2efXat5amwYPavhTEAe/eeISv59Gm
 ohHZHJk/
 h9O9DOMjCArudG67OrUIq7UV3DDxmvGelxTAEPmRvyuDWReqMOgxFTHBFz1Ac/19LyigAW97NkjrtLB7UuONfeCUJlJt/TNXAOatV48D5H0Eo0O1dtuUkna+lv1QR2Vru0L+JZSbibU2sn0PuPEnwxVeaBEA9JxfGuUAXRlIXANIbW8op4p2vECuSUcQs84VE9ExfAi4t//lRlAy1q1hqNNxc3xZFch+5jEmPsw3yV5g6ebvEcHbstsuxmOU28xwdpCRgb4/dRY7QCwLKtviE1XglDXCvDJkGfDzJ/1c88qSGwcCBifDYKudVpdr121T8PIVoWbVXKSV19y0EjV27ETkpMHCBLCfdGFY6F4pM3D96i7UTAtB/HP5LO8tBRxRbV3wsK5rHDQG/gt8yTJiGEbk/T8RGqHsL5p3u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 06:42, Anshuman Khandual wrote:
> On Sun, Sep 27, 2026 at 01:31:00PM -0700, Andrew Morton wrote:
>> On Sun, 27 Sep 2026 00:32:54 +0800 kernel test robot <lkp@intel.com> wrote:
>>
>>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
>>> head:   b4fc90c82982d98959af08b4320420bcfc01303b
>>> commit: 2862bcaf1aca55e0b43a5692a4595281ab780f05 [661/679] arm64/mm: move __check_safe_pte_update()
>>> config: arm64-randconfig-1002-20260926 (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/config)
>>> compiler: aarch64-linux-gcc (GCC) 8.5.0
>>
>> Thanks.  It works for me, but I'm using gcc-15.2.0.
> 
> Tried building this series with a cross compiler (gcc 14.3.1) and a native
> compiler (15.2.0). The series builds successfully in both cases.

I'm getting the same problems building mm-next.

The following seems to fix it, which I will carry in for-next and for-test today.


From 448f146f16394713b28295236588ccab3a173827 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 28 Sep 2026 09:42:06 +0200
Subject: [PATCH] fixup: arm64/mm: move __check_safe_pte_update()

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm64/mm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e589fb00d1e3..7343ac9294f8 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2392,6 +2392,7 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)

 	return 0;
 }
+#endif

 /*
  * PTE bits configuration in the presence of hardware Dirty Bit Management
@@ -2440,4 +2441,3 @@ void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 		     __func__, pte_str_old, pte_str);
 }
 #endif /* CONFIG_DEBUG_VM */
-#endif
--
2.55.0

-- 
Cheers,

David

