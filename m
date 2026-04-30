Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD0DDFF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 07:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AF166B0088; Thu, 30 Apr 2026 03:02:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35F766B008A; Thu, 30 Apr 2026 03:02:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275526B008C; Thu, 30 Apr 2026 03:02:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 171626B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:02:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C32E01404E8
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:02:31 +0000 (UTC)
X-FDA: 84714328902.21.B88642B
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id D4092A000E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:02:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tWkuXsrx;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777532550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnPzbyjR2RPMnocbYTJgY5ykVBYijb42BCSHLD8WL2M=;
	b=NqR90YCFnV3OfsB1dENh0AKxKhLEi/4G2vZrm/4ir4ghgKDWvES734lBADRjb0pyju7PK6
	62KMtS9GyJJl1GlfgJUCSIAWCj0mxHpLHjSO2h4v8URTAdBWUVhHoteqx2lfoww7h1bTfm
	SWkyN5pmq+75a2DpZXKkdUqALvQLSPA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777532550; a=rsa-sha256;
	cv=none;
	b=KOFyuFzmaW+0w4/PcgFGCd3kmfqxOvT2/PFaMgBynOxkg1h+9zLoCioMbwCK403OvC4XQE
	CLQSss0uUL2v1j9tBZ+CZdnfHp8hCz0aX8XDrYZKMvh0FGdzETcpdUxBawUa2v3H/voG3s
	MTTG2pZuHLq914Dn3JYUX3qnqDh2vVk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tWkuXsrx;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777532546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XnPzbyjR2RPMnocbYTJgY5ykVBYijb42BCSHLD8WL2M=;
	b=tWkuXsrxh5SQivLKUD5ssncT32NSJKFFaVzBCoyNLPGomQrobwv7fdWUgoeRCujr65JgpM
	0x8cfxLH8zeVfolyz3QQkTiYrkymYbDM6vL+7DpD0sLayloESPYZ0FIWe9ZT4u7UhCr1Br
	czHtnmha6ci4sX71feYkefSZbepLSC4=
From: Lance Yang <lance.yang@linux.dev>
To: maobibo@loongson.cn
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: skip huge_zero_pmd in zap_huge_pmd_folio()
Date: Thu, 30 Apr 2026 15:02:17 +0800
Message-Id: <20260430070217.39679-1-lance.yang@linux.dev>
In-Reply-To: <e3f542dd-f22b-fc8c-b376-72ab5909b6c8@loongson.cn>
References: <e3f542dd-f22b-fc8c-b376-72ab5909b6c8@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D4092A000E
X-Rspam-User: 
X-Stat-Signature: nm3y79xo3eyxbbicjsox89wprehfxjq9
X-HE-Tag: 1777532549-569501
X-HE-Meta: U2FsdGVkX18mXwni/lP/1bvTNs/dUcdI5Zws8VMpBguaY+P1/9NLl/+TUJe+XWf4bGPqA82q2ZKKhHAfgYViSkjmMeMcgz2uhxj9dty1QpekHNVkbXB81ywHykDfdjCTF8TK9biwh2fqcFcTdyr0ZPswfQaxQceyflVuDEU98dp5EGdJZrhFy0/T+uXPgmEuMGi89m4MASR0DD/pIIWS72AIbU7gL3dyuPZ+2Fb5r9IfwCmcNTTvHHnXSHWVxT+F3KY5UwQvNolCgoTsz2NAsqaS9p6GcuefcCKinxgWLMU2y91zXHdZ7MjBVAgA90i5zXHd+UBpbr3zqzRptT5HpT0raxkYsxPqMoV5t2q0LcZ0IaXE/VliPDYTWJad7KNAo/xndsmDDs3ZPvTJSNh6oZlyXDI8r2azADp6fMtb0CIVlXljV9fYjXe9vV8tB39/6JSkVc2U3/nmmwlq6/KhOJbxlg8XtfH9vwfduswarU7Eto39K4JO5VMt7gRaMTTJwc0mGAX7B71o0Mu1g5QdDXws/o3jGuqG2BjibIwA4EA4xfCiuesni+RmhWFEJjMW1SpT9+WoOx/dPt11sp+I+76zmAxu6X+i+8Hary+KMfLYYF/5b9/NDBxruMfuRxtacmBFMnzi6KjOvQNTGew7ba2W1hIFdCQRdHh7r1IvBve3s/gEHbDHVFpc+bYNdNKf9xtLR5JmScHFC8S2FJyzLdjcZdiDjJtK3qqIaD1zGeWNBg754pWOEJFqtwW8LGLLCc74WwDlwfMaJXnKdtvrdrqTMEUUv/9Q7nVg+Twf8y4dcOvuVtWHUU1JPpNm7oCthrrtRTgq7VszqVg9A4LbaTvs2hDyFAVcPpUqJPwWJaW66pLPRPKO9pGc9cSz/xkZ5z5lQI+mkMuABoUqcXhaxAHHdNaZnZP1pLOAAOfgiq2IfWqf9iaVIsdFXGI7vc1/YYWmltKNFH4KNhAjL/0
 ocyHNBJq
 jqnlp4R6oROnpz7tMLVtGlGuFd8Zlbr0ylf/luWAzmDDSsg5VHIazq3OTMlTz9NXwiE6g2+omRWxQyPP2XU/hVk739ntSCJdoVu3SPMzGymf+wJj5F8tb4hT26K9cDPhcdT8UmnK20zRfSHcHmQB8Y71Ohm5kqdo81k0I3iU8PhmjDUTQjxz9zxJbPMtQIUGxJZrTA9Z6tQVdNplFU3ogPpi/++WZ4bu693bVZEkDcwyoJ6F/3tjJfuPOgXQRZy3KgT1eT1R5CxyjR/LaQ5AoqegKhuYcbAJ5tQsFpYbChoiMNGu1cjjSqwFeHDpT2j6eMt+u/S5ZfwMBfM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Apr 30, 2026 at 02:34:20PM +0800, Bibo Mao wrote:
>
>
>On 2026/4/30 下午12:28, Lance Yang wrote:
>> 
>> On Thu, Apr 30, 2026 at 12:11:20PM +0800, Bibo Mao wrote:
>>> when executing command "make check" with qemu software, there is
>>> error report like this:
>>> BUG: Bad rss-counter state mm:00000000972846bc type:MM_FILEPAGES val:-4096 Comm:bios-tables-tes Pid:27802
>>> BUG: Bad rss-counter state mm:00000000752180c5 type:MM_FILEPAGES val:-2048 Comm:worker Pid:27815
>>> BUG: Bad rss-counter state mm:000000009c2f6a61 type:MM_FILEPAGES val:-2048 Comm:qom-test Pid:27825
>> 
>> Good catch!
>> 
>>> The problem is that when application exits, rss counter is calculated
>>> with huge_zero_pmd huge page, instead it should be skipped.
>> 
>> Looks like the same problem[1] we discussed recently.
>> 
>> [1] https://lore.kernel.org/linux-mm/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com/
>> 
>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>> ---
>>> mm/huge_memory.c | 3 +++
>>> 1 file changed, 3 insertions(+)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 970e077019b7..3cbea344d4a2 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -2423,6 +2423,9 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>>> {
>>> 	const bool is_device_private = folio_is_device_private(folio);
>>>
>>> +	if (is_huge_zero_pmd(pmdval))
>>> +		return;
>>> +
>> 
>> The huge zero PMD should not be returned by vm_normal_page_pmd() or
>> vm_normal_folio_pmd() as a normal folio. If it reaches
>> zap_huge_pmd_folio(), we already made the wrong normal-vs-special
>> decision ...
>> 
>> So I don't think we should special-case it in zap_huge_pmd_folio(). That
>> only avoids this RSS decrement :)
>> 
>> Could you please check whether the fix[2] also fixes your QEMU test?
>> 
>> [2] https://lore.kernel.org/linux-mm/ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org/
>yes, I think it will solve this problem.
>
>Only that I think that there should be tlb flush operation after 
>pmdp_huge_get_and_clear_full() even with huge_zero_pmd page, so 
>tlb_remove_page_size() should be called. Is that right?

Calling tlb_remove_page_size() is not necessary there :)

zap_huge_pmd() already marks the PMD range for TLB invalidation right
after clearing the entry:

	orig_pmd = pmdp_huge_get_and_clear_full(...);
	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);

The later tlb_remove_page_size() is guarded by "is_present && folio",
and is for the normal folio case after normal_or_softleaf_folio_pmd()
return one :)

Please correct me if I missed something :D

Cheers, Lance

