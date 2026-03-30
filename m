Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7669FFC97F3
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C718C6B0095; Mon, 30 Mar 2026 11:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21F86B0096; Mon, 30 Mar 2026 11:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11426B0098; Mon, 30 Mar 2026 11:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B87D6B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:09:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3515F5B7DF
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:09:45 +0000 (UTC)
X-FDA: 84603063930.02.7653D61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 497E6C0006
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:09:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=czqt+VGB;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=czqt+VGB;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883383; a=rsa-sha256;
	cv=none;
	b=EvQfbSOFb3WBh3avWzVhU/rt7AG6IJIa4xFsOZ21my8rCUXyKY7ZfwyInpE+QZnkM+DJyA
	pDxXFiyQafaIXjWBtn/EaRzsew0e0EizHJgNR+KpN6mFAjzgEiklQt7Jh+6ULDtkD1s+LE
	o4oYeZuVNboMUpmNSrH7vWp86A7Qln8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVSbtOVUh7xkUqkkKFT4Ltlk29FlPESZv7E67MFSE3s=;
	b=UDs9uQATKbgR0rcuX1QDUHmDPJwCYmtrQD+BrAwaYRmCXCBt5q+NdvarfHh71LW1qBpy3T
	5w9V/ogYZyNIMFu3NN51N49kKLWKMu/s9/BkaqF1EAQe01L14TmAJZVJcmL7ui/7gq/M+k
	P7e3NcgAA8FYq71BP6owcd8rm7CK1ac=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4471E43975;
	Mon, 30 Mar 2026 15:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E7EC4CEF7;
	Mon, 30 Mar 2026 15:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774883382;
	bh=WTEs+wWGfoGp7m+1pMCQulX7OTGdD9wt7oEgo7X/NC4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=czqt+VGBQH53ovNn2cfF9ycf8x3bSlQ8hpcOwAKfQ4OG7BYzHGkpsx2uai6eAvln2
	 bCpK6pfDZWoXyOquiOplKpu0D2kJq3+0SGS9puSXKpbdhlSYtZ+f4hcljD4WRsKhQI
	 WlmBD+2zR9UDMPHKrgAS87tDd7pdmO+CzfdiBVcx7oIGSu8h30J1XGVuUmiq9hkN6Z
	 54dktGBKjl1oSvOF3EsqWS3zwqZ//hkCUliTuKxMEjMuJdzcbA3+erE+LDHtsSyi6s
	 M7dSp0+dcBT4hJLbCBVLD/k2UZ+2GukCUGcms+6oBJhZlN1BryHvwhTdh2EabfGstX
	 QzbM7F4K3m57A==
Message-ID: <b17934c0-c6f9-4160-9cdb-2f5ccbf90b1e@kernel.org>
Date: Mon, 30 Mar 2026 17:09:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3 05/24] mm: thp: handle split failure in zap_pmd_range()
To: Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, willy@infradead.org, linux-mm@kvack.org,
 fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
References: <20260327021403.214713-1-usama.arif@linux.dev>
 <20260327021403.214713-6-usama.arif@linux.dev>
 <acqC010JLTfjHF0y@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acqC010JLTfjHF0y@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 497E6C0006
X-Stat-Signature: efpodyz6f5ia8u5uxeci1r4buoqon146
X-Rspam-User: 
X-HE-Tag: 1774883383-82357
X-HE-Meta: U2FsdGVkX1/pZR7X+u6TxSb2t7+MnWxXRF2sJUK2c+KVPAFdKnDhl+Ym82x/6epJaEfqeTRKWRGFqF4dILi29ijVWdjUR2NycOlHQjDbIIGarkQ5s6bC00zcdIUXKfKbyz4tvJkIuJTcXRftnTS1V+Y8JXPf3z08Fg704i/KJnwXSUXQkXSkFS4ioXgPH0NSFlmD31hCf4htaV/WaY/W14Tb+4ouTWs9V0wEC3UzPaHjIKFfHrstg/iXPMqttLmjUET1DWcUVdqxFAr/i5mxXEB2TLhGnsjocg+Hewrci+tb8FAtL0hOF01HerdLsj4I0t4Pgh8QolQYtryf2bIAfpYMyWlv2aiwCnAC8m07tFBiLFBqSebr+2hggL7ZwOV5abxXIosfFJB3Cnzkt8IWDRYEohKn7/FaF/vqT42o2mZk5WBn7XKVEj2NPU1sXd+UNQVw65jSyrOWOqSuZFNxFgkcC3Ua5kj9pPC4VfRNEY2QqfkYmxn4wlyFHtxklAJOCLfBFGw7epUHc7e6mQbleXqmB1RWXMxsOtDMGn0Q9UxatOOjF4SxaJEN/dfLpLFj42s/6+dGIsamwlUUSIIaTI7r0MQmT2e/mmfNwkTSBRLG58G8JxmYJoUOM4DF1q0kXZQqYubhE/4WaoevWbz4GfBT2Y5jDq6X2QwvUgcKeIkseqEaeKj9ac2LfwDUKy9lQLpttmkx/9YBPbOsdsOjln3Nx1SuwuAl1FFizmPIkUhFHjxcrop6yyRBhPpBszzYtx7c7unNUGvDBMv2o2SfUCVcbBRXi/x6aLRumPB3M7DNyRA25dq/V88ujR3ASXdNcEyOUkiKYRtqg0FmsWvZv+Poyd25Izg9sYsh64Vk/kmV8ivdeDWGaaFXAl9OmEn5seLxHhgIbxgnGipnH7QStv6FeeNr5E/V+87sV7wE9e6el9B7BEzFx/YXkj0XZORwOkRdcVSbQo6ix0yafVl
 3V8XiON9
 SRvVWXzkfcg7Rq1Ux4pf4Kp/dNP6L/w6uMbESFuAIqDfuSu4crXjOtIWq/CuQt6f4S4Xp1/bcChWbDFjDFexxX0nzmB6zrENqW9zSrX5VQxC0dBrqNHHHrMsZi6sxYuCRN5Zqx/IBUOFYWlj0Lo9o2ecDsp4nmXAwGpDjWL7YkMDrK+X2pIsPGF/yAjvHvsgDErUarrplkpksna3GG+p8UEanL6O+qNshbc6ARSiHHxbSfBtfGM9G/DWQZZjSxo+qoTHuGbpgdMYd3o+jkUK07Qn5v1Ki845+hHeGQxSR8Soeq0XxulieyxRjlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 16:13, Kiryl Shutsemau wrote:
> On Thu, Mar 26, 2026 at 07:08:47PM -0700, Usama Arif wrote:
>> zap_pmd_range() splits a huge PMD when the zap range doesn't cover the
>> full PMD (partial unmap).  If the split fails, the PMD stays huge.
>> Falling through to zap_pte_range() would dereference the huge PMD entry
>> as a PTE page table pointer.
>>
>> Skip the range covered by the PMD on split failure instead.
> 
> Ughh... This is hacky as hell.
> 
>> The skip is safe across all call paths into zap_pmd_range():
>>
>> - exit_mmap() and OOM reaper: the zap range covers entire VMAs, so
>>   every PMD is fully covered (next - addr == HPAGE_PMD_SIZE).  The
>>   zap_huge_pmd() branch handles these without splitting.  The split
>>   failure path is unreachable.
>>
>> - munmap / mmap overlay: vma_adjust_trans_huge() (called from
>>   __split_vma) splits any PMD straddling the VMA boundary before the
>>   VMA is split.  If that PMD split fails, __split_vma() returns
>>   -ENOMEM and the munmap is aborted before reaching zap_pmd_range().
>>   The split failure path is unreachable.
>>
>> - MADV_DONTNEED: advisory hint, the kernel is allowed to ignore it.
>>   The pages remain valid and accessible.  A subsequent access returns
>>   existing data without faulting.
> 
> Em, no. MADV_DONTNEED users expect memory to be zeroed after the
> "advise" is complete. At very least you need to zero the skipped range.

Fully agreed. This definitely needs more thought :)

-- 
Cheers,

David

