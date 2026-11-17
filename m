Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89919606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=JFtQSkzn
Received: by kanga.kvack.org (Postfix)
	id 910AC6B05BE; Tue, 17 Nov 2026 04:34:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E88D6B05BF; Tue, 17 Nov 2026 04:34:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825AF6B05C0; Tue, 17 Nov 2026 04:34:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 639E26B05BE
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:34:40 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DBF56A036B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:34:39 +0000 (UTC)
X-FDA: 85444101078.14.96B33BC
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7B2A34000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:34:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JFtQSkzn;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of evers_chen@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=evers_chen@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794908078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1YsXbWBgPDg6QmDoypidC2lwCkMp91z6UTOMZbX2UE=;
	b=VXbsF0+EOX9XEoghxNn0GRtd8FSPsG55GMsABOIVtkyrpMIhqugBSt0Y/QjRGSD1ED5IEa
	SZcXHxy36KBK09SzEQ5NVT2HLEmj3n9CvBc1XX1IQODM5LLW1OtMVgsbd+Rbmd+YLpUXKu
	mPF/zylmRZDeMDeXjBY925ePk3neSxE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JFtQSkzn;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of evers_chen@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=evers_chen@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794908078;
	b=c3CiGwyZIOPtoynEJQZJ68v3zwPKoYXHAemGMpIEztOwwsVLIPtXI9PwN8wpFT5WuZxvhZ
	/p8NOC1kybC1MGrFqN3x8XRhIWt3BrmKW6w3NwMlS6bkwfYWRRrLxn+9iCIIAbU9OvGGMh
	szKSf2frw4jyx22uvSIOpVRE+rekens=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=W1YsXbWBgPDg6QmDoypidC2lwCkMp91z6UTOMZbX2UE=;
	b=JFtQSkznZOknHa8HZjyHu84HXxspA0TJzmkgv/DYqp9Nfsxm8LvuC5m9sYJi0y
	jPA1fgR4dcLOoxCCdlj619pnkDtcJg7UZU1Uq1gHsQ3GEzAR+WSOEtYQ99emqGsu
	i+RyFY3rVRSMkHLxONTIdJb5FMwQvrkuwEVp9ttv90D6A=
Message-ID: <43104eeb-100d-41c9-a783-360b866021ec@163.com>
Date: Tue, 17 Nov 2026 17:34:16 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: handle implicit read permissions in
 madv_populate
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: shuah@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Xionggui Chen <chenxionggui@lanxincomputing.com>
References: <20261112031811.56500-1-evers_chen@163.com>
 <20261117070606.3752-1-evers_chen@163.com>
 <486cd251-f7eb-4162-a1c7-92f04f480a6f@kernel.org>
Content-Language: en-US
From: cxg <evers_chen@163.com>
In-Reply-To: <486cd251-f7eb-4162-a1c7-92f04f480a6f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wDnj0mYH_xqCdPlIg--.15158S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WrWUKw1xtFWDCw4ftw1UWrg_yoW5JF1DpF
	ykJ3WYyF4rJF17Aan7WF1xXFZ0v3Z2yF48Xw4Fqr90vwnxKFyxJr47KayYk3ykJFZ5X3Wr
	Za45uasruw1DAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Um9aPUUUUU=
X-CM-SenderInfo: xhyh22pbfkv0i6rwjhhfrp/xtbC6xrH0Wr8H5qycQAA33
X-Stat-Signature: qb7j64unc33gio4otsgidjeoccfbepo9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B2A34000D
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794908075-816444
X-HE-Meta: U2FsdGVkX1++IU1YclSKjTdjKJvEjQyzdBDqz0mhNG74MyKFI0Jzj63Wp+VPoQnQCxLl054nGRPFe+lk0GIa6nvcPaEpofKsYXr8tZn0Q+InIK5W6n6DpZnt7HN9/lO+gpsjyqbZhd2bLK1HTjsN/uAXqtqyF67eNl3044MW8IaBjBjJp+UiQqEUUHlb6lvcve4fXpxU2eqpS9LuEXnGf5UcmGgccZcTmNvnSeceWKtD783Y3fNch0LPjSqvUPKfCEXC425r7biWQ3Hcncf7CDCw2KApF/Bpe61uq+m21ts+xJ8nkOAnyt9qR6Blpr3ZVptMS5gCm/elxUNd9oPgIGFvpd0m8/BmY+L9aK1fZv61bQN1zYVR402X9uFF2nWnzR2l+FSNm/CBdA5Oh9b8j5Isw7v06mth1y3t+eW6UXDGtWM20QjoEeUcpevq+ZOU863CYD/LQIwhEzPFoeebiNl8HPxz1sU5pnUwHC65YpIC5+ZTaxz1CVBVqZBa4M4pjaj5d91dxJudL2SHEgyvb7RdPfLZyxdAknW11WiaSD8HMfyNdtwCQOoHIrTLKo1XfIih1ZCRXZG/CH8j0UnyeEBKZGjeV5r+DyTNhfPuUvCnUkT9gOgwJOkxK0pKv78/pcFf5B0Z/pYkWwzxxsQuCJUJOGFOzIGY6itXUlG20GU0cIzMvsPbvdEcRwkz0UoQlTuMCtfeokB+qSRsw/a5g+yXTPOjVbPI2VyJriiu0LbL6+1g3lkKtTXEn/MY8mRD2vdSTSMcB9uKaV0hI0NLVPdmw3WReg8G84GK9Z26NHpvl7ixlfVgvOo+JCu3AedJhvpyNXKKIoRFRayO2twPkOzz2ftBY0XbIVWYRgUoS2sr6g7bw14v7OhbrFvTPHQm1hd8rBakOLzqcVX42SoOrYjw+bTNqv+QsocRU5MNAKmhfszcxqtcUEomqx/8DhT0MnRGr0IcdnoPg+vMpjV
 5AnKNxyU
 MbB8fYlGMYUA3vLeH7pYejllRTAsfu+RdMciE1Z/CH54sH8rR0UOd0IyZVyOCXilhwADwUt/sGVdEJ/rdmfpNsctXBWiCh3HvtGLAODN5VTxj3wrkEtTYaIreiENpzp3rdlji02LgquRJQZqz2rp71seSgS3NUiYuyiBR3iyJA9PczmI7Y/7/QBygE4KaDM68Am4pTmCJnRKJM35MLpwOD7+7B/VwsWH+hSMkCGYN/Fn+vbwHftJZqFUbRM5XhiTacQzAXgY8+m+QSkk71+Jcq0p8aezVw0wn0CpeE+q99seLoGQVxPLhUqCKc67Z/WSZf17f6S5yNdlP/oOs5zKilGhlosEnsf/cxz2PBFZ31MI7r2v8f3piQw28umrCPvVpEix4i2wsd+BwMV3V2NuSQ4kgPUsy3SMam3316r/7FmhU5GLPmrdfIuf0zmimdQ+0ILowYmHjXnPnLZ8AVsQKwprc7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Thanks, David, for the Acked-by.

I'll send future patch revisions as separate threads.

Best regards,
Xionggui


On 11/17/26 16:58, David Hildenbrand (Arm) wrote:
> On 11/17/26 08:06, Xionggui Chen wrote:
>> From: Xionggui Chen <chenxionggui@lanxincomputing.com>
>>
>> The madv_populate selftest assumes that mmap(PROT_WRITE) creates a VMA
>> without VM_READ and expects MADV_POPULATE_READ to fail with EINVAL.
>>
>> On RISC-V, commit 6c7559f22b6f ("riscv/mm: ensure PROT_WRITE leads to
>> VM_READ | VM_WRITE") makes the kernel set VM_READ for mappings requested
>> with PROT_WRITE. MADV_POPULATE_READ checks this VMA permission, so it
>> succeeds and the test fails incorrectly.
>>
>> Adjust the expected result for RISC-V using an architecture-specific
>> conditional, while preserving the existing behavior on other
>> architectures.
>>
>> On RISC-V with Linux 7.2.0, the original test fails 1 out of 16 tests,
>> while the updated test passes all 16 tests.
> Thanks, please don't send new revisions in reply to previous revisions next time.
>
>> Link: https://lore.kernel.org/20261112031811.56500-1-evers_chen@163.com
>> Fixes: e5bfac53e310 ("selftests/vm: add test for MADV_POPULATE_(READ|WRITE)")
>> Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
>> ---
>> Changes in v2:
>> - Use an architecture-specific conditional for RISC-V.
>> - Remove /proc/self/maps parsing.
>> - Remove the additional PROT_NONE test.
>>
>>   tools/testing/selftests/mm/madv_populate.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
>> index 7fce5d0b622b..fa26ca2d8cf6 100644
>> --- a/tools/testing/selftests/mm/madv_populate.c
>> +++ b/tools/testing/selftests/mm/madv_populate.c
>> @@ -81,8 +81,13 @@ static void test_prot_write(void)
>>   		ksft_exit_fail_msg("mmap failed\n");
>>   
>>   	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
>> +#ifdef __riscv
>> +	ksft_test_result(ret == 0,
>> +			 "MADV_POPULATE_READ with PROT_WRITE\n");
>> +#else
>>   	ksft_test_result(ret == -1 && errno == EINVAL,
>>   			 "MADV_POPULATE_READ with PROT_WRITE\n");
>> +#endif
>>   
>>   	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
>>   	ksft_test_result(!ret, "MADV_POPULATE_WRITE with PROT_WRITE\n");
>>
> No that's a simple fix :)
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>


