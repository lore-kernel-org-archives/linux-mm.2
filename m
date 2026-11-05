Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4F076083625
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 15:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eh4uz2E8
Received: by kanga.kvack.org (Postfix)
	id 9EA326B05B3; Thu,  5 Nov 2026 10:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1DF6B05B5; Thu,  5 Nov 2026 10:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8916B05B6; Thu,  5 Nov 2026 10:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 618856B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:51:26 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07141C0AA3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:51:25 +0000 (UTC)
X-FDA: 85401504930.09.A0DE9AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2FB3F140009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:51:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eh4uz2E8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793893883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vcoQZXzUSKAjGDFyua49S/KsemIMXjn1uFYHAPFPdCI=;
	b=dNDDCicaOXfS9FQwTo6eZVQRghVZyYxDeE+LO7o5k0H6PTQSYQl45gjaxVftNsdiQ3GcZg
	YtA4RJvSC4HNAMzXKuWZkTD3581PS0EdJ753a0QjDmuopFz2ofcgUdAP+S/lwQWEpUer3P
	um2AnqRrs97xIKC3RlQODAIv4GcBTjQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eh4uz2E8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793893883;
	b=vM9onCGHq3lzL7i95Ef8W+b0/A1LdTIVec1nzOOPmjgRG541rzbCyVulo8YqJReduyqRE8
	1RaXSUHahypBCzl89OQ5h7OF0JKEmtV5clNEVd6s208EHfX9PI5gICGq0glbBsS5Eg/vFp
	n9dKwc7UeZH/qJ8U0s6woTfp3lR5kyY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6524241A8D;
	Thu,  5 Nov 2026 15:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0F11F0093A;
	Thu,  5 Nov 2026 15:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793893882;
	bh=vcoQZXzUSKAjGDFyua49S/KsemIMXjn1uFYHAPFPdCI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eh4uz2E8DxtizBT/qw3y4t094WXgVTrlelAfeVdHut710Alzy8V538PI4x5YiPXtx
	 dUZN/TLFUPezR/ZFZdb8a2vqFcYiL+xJSsb5A/WXzlmAW6IW/6W33uWRMz72HjFxBN
	 UuvaPkB475995+O8hLONeDFXuN1nPYMooDLgiPBV+tdTqyS2Bp/Ms2HEwag44Xy/ak
	 E6rLjZoD9W40NZ/US2DZe2ptZO2+8eIQVgeETJrjQkLVMgd54Nx2NeTYDtghhq1i9P
	 P505FsGRfhntdBL8X4cU+bTOsiZx9vW4qVZJoiM2on8vYmFykyrh6gy2Yakd1tVc4e
	 qZ442+tMryYTg==
Message-ID: <e135e15d-6a93-4856-a7ac-30977a2a2b5d@kernel.org>
Date: Thu, 5 Nov 2026 16:51:14 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: skip split_huge_page_test without the
 split_huge_pages file
To: Zi Yan <ziy@nvidia.com>, Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261105030242.1241448-1-sashal@kernel.org>
 <4B926B36-D797-4861-B6D6-27E8D7870287@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4B926B36-D797-4861-B6D6-27E8D7870287@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2FB3F140009
X-Stat-Signature: xxb8o9izx4k9tqsusiostozt3hruxp3d
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793893883-311612
X-HE-Meta: U2FsdGVkX18FVYtk6Jl1Hwy0GAUJ0NDLhxOtbHo9tESN/63Vw1zaqTdqmS3O/XozgdUBBHc2nv9hJcws7wUjwFFoMFnSYqSQLXtAsViyP7pXetpyM6sby71AaSW9pcbY0Nx+SbozJXcl/EjCDF32sH2TseKkhS9hacJsLmDVZeMec6xJpXmke0WceOAzMAv9TwM83mnmFrnImgGRfYZ546YOKIpj8h3xkg2lvMaQosouJcWVB6qdz8OhoqCXVBa0Myu6hm3l8UaKEJRrDstKTQyV87xBsT7bx55dHMaxruMu3D4d8b3maqGa0eiVj3iqXB5r7gjNpGPQCLzKu0p+4d3UUsjWPu/xgQ/vsZ+VfmfSyNmtYhHqRz9Qn/KN01+Iwf/4qh65uT/GsQUNNjgw0H+hh1ZIPH96pbco/8PylvqIJC4/KMprAEuM7nxsPhnFSIt8PuxY8VGmrZFK23YIkMdA4o3RDSm6sHDoK3FMW2TFM7qeE0FwliqHSwLk0aoi9sT4aUJQYOCX43l8Xl31aFlaX4hkULsG+ZpLuamPYwxaQQbZqn99KlkZqiN8eDHPuc9gQrWuiALii4ilW1bW0rhI2KuAr/0+S+A4dGgsGMs6qC+D5WsnNOi1dPBuZarbqMm76vuQ27C2XAD/LrBeq9qLMxA00lZbw/AnNMQdNeEgzjB4KVqoCm+0J9HkLoJs+bvSJ8N0rl6ZAjkxpBu2oV9f8UCK2P2NKu7/rIyk3KMQaAh4G2WjldyDqqd8OmmfKFyz67vJhhusCaAbtyv1RxPPAhBl8eFR8cAFyrssfmYxO0bfA7wcn79xJQCw4UJRzP5k2km5lS0ezJkil1vY55N7IBI4uLbyGIgh88xoMFVF9GN+h4jugEaHuOyJru4GNjvO/gey3pfDC5rmSqhHJBsn8adtquRma9P6ICaszJSs6E+ExF0MCpATHXn1LwYzu96JowiG0COR3VRXvAj
 Zg0Sd+Ug
 MC6h5V40fw+0QHB6ydzK40Ntwy+6Yng60HF7AkCxBIBaGtriB+6ERgi+LHmcZa9O1c9fkxwpdSX7ZcybhhhKXTCESS40/fW2EzaULRzhx6hDY4AwxpX0GthIb84Q+3byzm2MYyFnHfXV86hJYt6XP5VGQ19ojp90ntnWBRGoEX+j1a+z95N+TAhKqPs34rsItEAXunq0WUAGpg/Ts+5ydVTTAB7yyma/Bh6qdXksRjbw9VTtnvKtSgStxJLK0ivcLR2q23VxBrD3PBW4IQbURC0SlsF9IVlkrEIc/dPVdtYwZfRWScv6igJz0rLjpdUYSVvO34acRyuMNeatHWT96vuD+w40PDUhqfxWsFjdMflQaul2nPVwOflcKwrU4arP7SnrCuydqITu65xo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 16:19, Zi Yan wrote:
> On 4 Nov 2026, at 22:02, Sasha Levin wrote:
> 
>> Every case in split_huge_page_test goes through
>> /sys/kernel/debug/split_huge_pages. When that file does not exist,
>> because debugfs is not mounted or the kernel has no CONFIG_DEBUG_FS, the
>> first write bails out of the whole test and it is reported as a failure:
>>
>>   Bail out! write_file(/sys/kernel/debug/split_huge_pages): No such file or directory
>>
>> Skip the test in that case.
>>
>> Fixes: fa6c02315f74 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>> Found with KernelCI's NVIDIA lab, which runs the tests in a chroot
>> without debugfs. Tested on an AMD EPYC 9655P with KernelCI's x86_64
>> build of next-20261104: without debugfs the test now skips, and with
>> debugfs mounted it still passes all 62 cases.
>>
>>  tools/testing/selftests/mm/split_huge_page_test.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
> 
> Thanks. But I do think we need a way of specifying the necessary
> Kconfig options for selftests. Oh, we do have one:
> https://elixir.bootlin.com/linux/v7.3.1/source/tools/testing/selftests/mm/config. Can you add CONFIG_DEBUG_FS=y to it while at it?

Just what I was thinking.

-- 
Cheers,

David

