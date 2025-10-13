Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22532CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 617B38E0021; Mon, 13 Oct 2025 07:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF668E0007; Mon, 13 Oct 2025 07:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C308E0021; Mon, 13 Oct 2025 07:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4196E8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:00:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3B8F119C74
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:00:47 +0000 (UTC)
X-FDA: 83992798134.04.F8E3414
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9256D40014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:00:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IhoJKFb3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760353245; a=rsa-sha256;
	cv=none;
	b=EQkos61qHY37d0nFfNRHKulkGVKAItshh6KlSoijh/uJp+yhhiEdK2XfRIEauHdolpQRmL
	sI9NNm1sJAvzspP80ylu4Zo3g4Z9D/AqFSnTpfw+cg6aEPbLRL/PBggRbluwEVpgbYaHWk
	IZxay7HztbGGx8Oxz2LqhxpVkg1DmrQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IhoJKFb3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760353245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1V0QqXKTj8ZcNMA+dAf03zBCdE/xeeZHahyNYqCg5k=;
	b=6qF0EFcuSacbHLHadfk9c7fOIhXnY+8UEl/TpPNNiITK7dApTl0HkP4O0sX/i9w8A9Y/0j
	Cutnhxr4v1stPvoHOlY4zoBmCeyE1PXxNApEweWRz5n+4MUReH/IzcjoThmQWpGJyqNLFc
	U0DZaOGWbuVOXkKBkSfSr9e3VhqMV8E=
Message-ID: <c129e522-853e-45c7-a064-34c25e63e610@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760353243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K1V0QqXKTj8ZcNMA+dAf03zBCdE/xeeZHahyNYqCg5k=;
	b=IhoJKFb3ziQ/8pq+DlNF1eFjNpLYLPXCUowndf8ldIIqgeFNiWPTGvKTFRZc8IJrm6kcP3
	rYzLs5q2JSg6rbQc1MRIsV6qF1w0aJw/TL227OUBEQuF0/bUHxh2SbN8IDkdV35ZHOwhu/
	gYp95dKvcIzhgEEfuZTGY7ZgYEw7nF4=
Date: Mon, 13 Oct 2025 19:00:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 1/1] mm/ksm: Add recovery mechanism for memory
 failures
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: Longlong Xia <xialonglong2025@163.com>, nao.horiguchi@gmail.com,
 akpm@linux-foundation.org, wangkefeng.wang@huawei.com, xu.xin16@zte.com.cn,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Longlong Xia <xialonglong@kylinos.cn>, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, Miaohe Lin <linmiaohe@huawei.com>, qiuxu.zhuo@intel.com
References: <20251009070045.2011920-1-xialonglong2025@163.com>
 <20251009070045.2011920-2-xialonglong2025@163.com>
 <CABzRoyYfx0QPgGG4WYEYmT8-J10ToRCUStd3tWC0CtT_D8ctiQ@mail.gmail.com>
 <CABzRoyYK38imLh6zN2DZKPRyQrJkKyvpswqJAsWzEeECtOxaMA@mail.gmail.com>
 <55370eb6-9798-0f46-2301-d5f66528411b@huawei.com>
 <077882e3-f69f-44f3-aa74-b325721beb42@linux.dev>
 <839b72b8-55dc-4f4e-b1da-6f24ecf9446f@huawei.com>
 <f12dfacb-05dd-4b22-90eb-fcc1a8ed552b@linux.dev>
 <bd374ac3-05a2-41ae-8043-cc3575fb13c0@linux.dev>
 <3e6500dc-723f-4682-9e37-b28bc78a2bdb@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <3e6500dc-723f-4682-9e37-b28bc78a2bdb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pqwsct3eqagdgzfzo6unqho6eqxdstct
X-Rspamd-Queue-Id: 9256D40014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760353245-704790
X-HE-Meta: U2FsdGVkX1/Vu0noWQDPq+5L2wirpCfQSxjpgyHs3uhq92ji9/X58hOUSmmSW0M8s9ykKBgfkYVJ2psL8T5eIw0kh8z6i+ZdLxrniCoCKDRysI6N/W5tYEWsy9hVBrnQTtu1NaCz90HN7Ogu0ph+eNyCPGO57lHZRVAlpv/8GzX0OQ7dgHGM0SyQoQwHHEAKo2rOGwCmrRmKTIHFI+DQXBzl0Lbi3Wg1y46jONuKbnfATJQB/WQdI5WA3Ts8YP7JzJ90kPZlRe6fFAVa7ePffQL2ObzCJh8OIEhyZC3vELk+wYyLegKzw9leIZkE7zUQsISOiA1yDjWuQrxjHXm0DG7KwwwM72aywguwbQfYIVJaG6/yihm932mcu8kCf+LmwmpPUgzYoXjOfzz7+rDi3ob+yyw7uARM2GzOQoJKxeiH0z+giY3IPJev2Tw6lJ2309sQgkQTe0nRPPoeD6DZZmlFrXOs47puX5hRjYHs9hgVEvRqIoSYNIhYPMD1KlSK41YwNLk/McM5liziKRX19H/5PxaU7NEWRDuo9EcMNaVPppoq2VZFWuxFJBx9bqTsUwACgpf6eqPdStRFTS7S+vyLIBqhyBLMh10TmBQuHxMRHN5/KI6we3Ahs2vWBk20dxq9Eqzz88a4AdYSOOdR0jIUhl7E+jZj6SExcGsMBMwEL8YwQ1i5K6Ir2UeeiMlvvxOcX7ztPFAGy3W0hgbJQ/KFWrPSyAtWxZh3/N8KTQLO9gUpa0xYAvPAI2KAHUzQprixV0U5HH8yQfUUqS5WN5X0uQ9qpttCSeZKyyI6gecBhe2ac0x8hHgPzyNxYCWfwyTdSzP2jFRkHeX7aUvbKnA92+pGqzX73AhhOYuQmqTr3he3dawawenvSwQycWNHo3D6ApJXHZ8QCGp4TXeYtQZUmVTbsjDio8uoO2g9FteD8p/diFyc5EszxSMu7p5NVeC8S+UuGNgVV6k8sCV
 DbynwpQi
 f+jxwdFzeioZwr+OoYPPqEraaUZN8KCo3RWczE44OEbcZu2w9dRQnUQtqNjSS4y9SIrhhA+g/wTP2xfAX7XN1ABlWdOn3eV51ckn+ic/AUBh4JsW+pW1xJIdFWOkoomzWpnZuJhvouVfgEg3E+us3q+vbWEP72RLZ1wVcCdXEALmeARfH3v2euYgTzQsm1XagAcAdVRWrA1bOg2TT4MYJrwxwAeYgjwpy6votaGJCvrTQrnS/malnc1WBmFKGfvq4z5pEAApKrjQD8PQcwHN7c1R15A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/13 17:25, David Hildenbrand wrote:
> On 13.10.25 11:15, Lance Yang wrote:
>> @David
>>
>> Cc: MM CORE folks
>>
>> On 2025/10/13 12:42, Lance Yang wrote:
>> [...]
>>
>> Cool. Hardware error injection with EINJ was the way to go!
>>
>> I just ran some tests on the shared zero page (both regular and huge), 
>> and
>> found a tricky behavior:
>>
>> 1) When a hardware error is injected into the zeropage, the process that
>> attempts to read from a mapping backed by it is correctly killed with a
>> SIGBUS.
>>
>> 2) However, even after the error is detected, the kernel continues to
>> install
>> the known-poisoned zeropage for new anonymous mappings ...
>>
>>
>> For the shared zeropage:
>> ```
>> [Mon Oct 13 16:29:02 2025] mce: Uncorrected hardware memory error in
>> user-access at 29b8cf5000
>> [Mon Oct 13 16:29:02 2025] Memory failure: 0x29b8cf5: Sending SIGBUS to
>> read_zeropage:13767 due to hardware memory corruption
>> [Mon Oct 13 16:29:02 2025] Memory failure: 0x29b8cf5: recovery action
>> for already poisoned page: Failed
>> ```
>> And for the shared huge zeropage:
>> ```
>> [Mon Oct 13 16:35:34 2025] mce: Uncorrected hardware memory error in
>> user-access at 1e1e00000
>> [Mon Oct 13 16:35:34 2025] Memory failure: 0x1e1e00: Sending SIGBUS to
>> read_huge_zerop:13891 due to hardware memory corruption
>> [Mon Oct 13 16:35:34 2025] Memory failure: 0x1e1e00: recovery action for
>> already poisoned page: Failed
>> ```
>>
>> Since we've identified an uncorrectable hardware error on such a 
>> critical,
>> singleton page, should we be doing something more?
> 
> I mean, regarding the shared zeropage, we could try walking all page 
> tables of all processes and replace it be a fresh shared zeropage.
> 
> But then, the page might also be used for other things (I/O etc), the 
> shared zeropage is allocated by the architecture, we'd have to make 
> is_zero_pfn() succeed on the old+new page etc ...
> 
> So a lot of work for little benefit I guess? The question is how often 
> we would see that in practice. I'd assume we'd see it happen on random 
> kernel memory more frequently where we can really just bring down the 
> whole machine.

Thanks for your thoughts!

I agree, fixing the regular zeropage is a really mess ...

But for the huge zeropage, what if we just stop installing it once it's
poisoned? We could just disable it globally. Something like this:

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index f698df156bf8..8543f4385ffe 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2193,6 +2193,10 @@ int memory_failure(unsigned long pfn, int flags)
         if (!(flags & MF_SW_SIMULATED))
                 hw_memory_failure = true;

+       if (is_huge_zero_pfn(pfn))
+               clear_bit(TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
+                         &transparent_hugepage_flags);
+
         p = pfn_to_online_page(pfn);
         if (!p) {
                 res = arch_memory_failure(pfn, flags);

Seems easy enough ...

