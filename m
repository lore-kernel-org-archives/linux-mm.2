Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEB57CFC51F
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 18:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2F1E6B0008; Sat, 22 Nov 2025 13:08:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF736B000D; Sat, 22 Nov 2025 13:08:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCE3A6B000E; Sat, 22 Nov 2025 13:08:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C69A36B0008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 13:08:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B264130984
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 18:08:17 +0000 (UTC)
X-FDA: 84139027434.08.E072573
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6B13640015
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 18:08:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=E2PaWyGY;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763834895; a=rsa-sha256;
	cv=none;
	b=YjgBZM/TVFSlSxIsCUtodKyUOg+gcMq5OkQoVMcIAP/Snglbpm1MjHQcuRsFa88X9sfv29
	FgF0Y3QhrqCSb72WSHuDD/NyFEekNGyDFlaO6dXMgCjJDGlxm0pvpKfowFIZh5Y0fMc9yn
	9uexQvwaxRH9fGWQESQl9Z54KbUOHII=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=E2PaWyGY;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763834895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SucK0S+LKL6mpkxIG0DfWO1PUYsxUTWbPD1dv9eG2K8=;
	b=4ib5tVXnOJw5ssIE/P0hwTRb/FjebnCmRnERtxqugauVUAVp61X/r9dt4Rbeje4qphvQQr
	UwbFd7MTKY+dECB0yhx4XEzptLEyGMuAnziB1jTDxOK1FUQSJ33nLasws3Bl60eQ55otHG
	siQEFXtjSlj2ZPT9nFq7tPP3POW1aUg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Su
	cK0S+LKL6mpkxIG0DfWO1PUYsxUTWbPD1dv9eG2K8=; b=E2PaWyGYDoh0W+vS1P
	aift3gSSw3zRpuYQmA5wSYUD3/Yvu2bLHJ+odg8PPIs0XKRnIlTQdXvDQT9oDwiG
	WydQgUADtC9wPaHZa7XHTznpZW2i04+DpY6bOItD7rnNxWWVHHhziZFF/ZB6Y0V6
	SHj5uV6CJBJipgoYQ45YjBpS8=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgCnRt3Z+yFp+yVmFA--.60796S2;
	Sun, 23 Nov 2025 02:07:21 +0800 (CST)
From: ranxiaokai627@163.com
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	changyuanl@google.com,
	graf@amazon.com,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: Re: [PATCH 2/2] liveupdate: Fix boot failure due to kmemleak access to unmapped pages
Date: Sat, 22 Nov 2025 18:07:20 +0000
Message-ID: <20251122180720.92605-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <aSBq8T8ETc3zjBf6@kernel.org>
References: <aSBq8T8ETc3zjBf6@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgCnRt3Z+yFp+yVmFA--.60796S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGry5ZrWrGw13XrWUGry3Jwb_yoW5Gr43pF
	yvkF1jyw4Dt34agF47t3W0ya4Sqw4Fkr47JFyjq343Ar9xXrn2qws5Z3y0vFWUXrZYkF4j
	vF4jq3yrWr48ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUrcTPUUUUU=
X-Originating-IP: [117.176.242.91]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbB0h8OTGkh+d0vKgAAsm
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6B13640015
X-Stat-Signature: j1m4fr6ikzy3m1zeo5jmo9uyt1dsht41
X-Rspam-User: 
X-HE-Tag: 1763834893-625207
X-HE-Meta: U2FsdGVkX19mb8hOuDm+NibtVgjE6zc3SeAljRWekXc2Fql1QDJL2DQfhc7HNJa+E7NPthwjC24ss6soxXNOyUr/PIsEHRVTFEBSjGUkw0jUfzYIu/Y3/fB6OqEkNXYO1NM1kW8+SOGkTbOcaImNEs3kDXlKsNjuvw+MefCJ7//vDHni5RCzDRcypTyDpha/cjhV/Lkr19qUo9ZNGSn1Ql+PE5kvTTBE7N5P5jOaPEY5PMZwUmXL/GnSrn2iyW9EWO1VMxE88boYlhFuCilDvlkyrMnnfYaZAjUQooyiqbpAk/kuAVlCGq7TtVdr/ULBBiI58LInNAgAIIokQvC6LBrOG4Zgy0/OSCq0oFrIEkhChwZht67G/cIhISWVS1j2EfzKaJ2PQOmT3DK1HYz5z7uRUyihqVIIzZ1k9GkL2Jx3ZJ8E5x+R7e5OPAFtgtlD3LLGuaYQqR7Prn7KQqZD/57/eQ9nrfbM5XYNONgN97Q91QDoeU/IF4Am6FZDWIAz2FEEHwRS7a9L3A/oHtUhbgK0hkwg5vUERFBi4CvRxiHlCIVr96+zQFJtT1YISnY5RveAVYA4tmhFWzhxt9wRNFkAcUj2YruO0adfNGTf5pNo9kjp+PRtvrv6jNRRkbDOwrdJgbrqx/JMKuVU5yx5qKN9GovLblVbJYmK1hLZSjcBrBFqdIavmA3z7BmAXJdnhfvCe3C89P1+cR/snJhansLEjDVJ+qdlRWjqY4l07aEreaJTCMzmVn+Zz1wM+z3uDfuFswR4LNI0pxhuzzwpsSieCNMnBbFMzWtQuafZcamCTKKyQWARtUXC2z9936kea2UXEw3MUkYoNwDEbXxYiY0sdt52/edBbs8Zi/NIg0ToAUwXAvmD2qzEAlNFENpte0/IREmvlhuWGG2ynfWFOLIG53PZQuLqXZuuDOV9bGuJFMX2KXlwQ3jscJuGS39ezcNQOOxM36hhA9xsbaN
 ZHkxl12f
 B7YBZHEPor6Rvjd+CCV4Acl3nTsR13fUNpizDMzuaQgGbA1ufnZEvopOWdjRyrNatlWgOLtNJ9b0GnKC1VmsoC5e+Y6GT9lOJU6seHWwiSmNtu5dtoNk4xMmU7qkscCzUjvsytTFExjzd+7XOcDl111auiK6v3u3ncBfj7+/HPawjk21dtAWGVYI3fVodvJqOhH7WNokJyq1oq2nnD9S6XpLD1XCRzDAl3p2Kltfx3KsTKvJvQ7bHa4eHUTzxXT+Abj03Tpp9mmAv5P+qZ7mRJT1VrzitXAbLba+IWTZGSd2hSsIcPuR+wuB2wDKPWLGfZVZdRDIWZLWCSU5cV01AkLxaEbUkahxJQyfcbo0wVVqaU5oed/RyX7gr5MnbbPLoJfk+OTD+zm+ojo/OrppjK//Hd667B27jEOUDv3snVybyJMQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Thu, Nov 20, 2025 at 02:41:47PM +0000, ranxiaokai627@163.com wrote:
>> Subject: liveupdate: Fix boot failure due to kmemleak access to unmapped pages
>
>Please prefix kexec handover patches with kho: rather than liveupdate.

Thanks for your review, i will update the patch subject.

>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> 
>> When booting with debug_pagealloc=on while having:
>> CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
>> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
>> the system fails to boot due to page faults during kmemleak scanning.
>> 
>> This occurs because:
>> With debug_pagealloc enabled, __free_pages() invokes
>> debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
>> freed pages in the direct mapping.
>> Commit 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
>> releases the KHO scratch region via init_cma_reserved_pageblock(),
>> unmapping its physical pages. Subsequent kmemleak scanning accesses
>> these unmapped pages, triggering fatal page faults.
>> 
>> Call kmemleak_no_scan_phys() from kho_reserve_scratch() to
>> exclude the reserved region from scanning before
>> it is released to the buddy allocator.
>> 
>> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> ---
>>  kernel/liveupdate/kexec_handover.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index 224bdf5becb6..dd4942d1d76c 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -11,6 +11,7 @@
>>  
>>  #include <linux/cleanup.h>
>>  #include <linux/cma.h>
>> +#include <linux/kmemleak.h>
>>  #include <linux/count_zeros.h>
>>  #include <linux/kexec.h>
>>  #include <linux/kexec_handover.h>
>> @@ -654,6 +655,7 @@ static void __init kho_reserve_scratch(void)
>>  	if (!addr)
>>  		goto err_free_scratch_desc;
>>  
>> +	kmemleak_no_scan_phys(addr);
>
>There's kmemleak_ignore_phys() that can be called after the scratch areas
>allocated from memblock and with that kmemleak should not access them.
>
>Take a look at __cma_declare_contiguous_nid().

Thanks for catching this.
Since kmemleak_ignore_phys() perfectly handles this issue,
introducing another helper is unnecessary.
I'll post v2 shortly.

>>  	kho_scratch[i].addr = addr;
>>  	kho_scratch[i].size = size;
>>  	i++;
>
>-- 
>Sincerely yours,
>Mike.


