Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDFF2606A338
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mkqe2n1G
Received: by kanga.kvack.org (Postfix)
	id F3C7C6B05B1; Thu,  5 Nov 2026 12:54:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDC96B05B3; Thu,  5 Nov 2026 12:54:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD1F6B05B4; Thu,  5 Nov 2026 12:54:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B777C6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:54:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5600FA0BEC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:54:02 +0000 (UTC)
X-FDA: 85401813924.16.17850F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id BF46920006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:54:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mkqe2n1G;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793901240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EftwWfre2aiDydKcjXOvHDcLO/ReuFB640bdDH18DBw=;
	b=DMufQz4HXqJ0o5YQVyXbMNjVHf3v4dr5W6oA/kttNhmcpiT2IoZ2gjtSlDoMCip/Q4ENW4
	K/JjCZ5PflvMqyQowlLjTsOXJVQX8e46SjrlbbUnhpYvmG182z99UgHugbON2R7D26AfqT
	jk1KWO7lmrJ0XQ9khmsrmIEfM1+llHA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793901240;
	b=qkN7LI6LuTIBSKp09cayOprnkEtAMhx9hKSu0frjAY8GgiOb/xJQdPyfaKTw3W0/+L44Ul
	9sa49u462l1CfAPqjwuDuuWS93b2YoY+NrhvpR//iwlTPNH9us8G7ZpVpqiKQwG619yPYY
	rP+17M9TwDgDUPpA1E2Et70fVRW9ouM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mkqe2n1G;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8E51416F8;
	Thu,  5 Nov 2026 17:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47541F000C1;
	Thu,  5 Nov 2026 17:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793901239;
	bh=EftwWfre2aiDydKcjXOvHDcLO/ReuFB640bdDH18DBw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mkqe2n1GxIwCwQwvgdl50QCVqj2q1MbFYLkfBeiERFWUDpe4nCnIe+a/pC6Di4bYg
	 M0Wfsf63FAXtZ0YnG0EJ/ShbJp/nJjebcHidgjwK4p3Nxrp0ichyUVEd/juN/BbNmz
	 7lsP+Uy8J81vrCF+SonSWIW0IvJkzG0w9fqBhdF5u9970NqFk9lMwcw/gJH1gujL8t
	 z9LgCWRt22lk9sxZ3GjxsmyCi3FhU4T1J8KK/AzxOw0ar50XQkEsbV2wNp37Ku0Vtd
	 zlGGUIHZLduyWGqKmqAnTLCUJt+jC4zRYY9ZvPSb8h9vOFSs9YQ8ULVMKy9IwguXDp
	 ubgTD021UX0aQ==
Message-ID: <0514745a-872f-4027-9831-da06b7f075ba@kernel.org>
Date: Thu, 5 Nov 2026 18:53:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: add CONFIG_DEBUG_FS to the config fragment
To: Zi Yan <ziy@nvidia.com>, Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261105030242.1241448-1-sashal@kernel.org>
 <4B926B36-D797-4861-B6D6-27E8D7870287@nvidia.com>
 <20261105171801.2189772-1-sashal@kernel.org>
 <3BC61F94-0385-4603-B12E-BEA458BB307A@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3BC61F94-0385-4603-B12E-BEA458BB307A@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BF46920006
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: omyfritebjkkj579ojr4ocosndhhkw84
X-Rspam-User: 
X-HE-Tag: 1793901241-643332
X-HE-Meta: U2FsdGVkX19e5iAbndm9W+vsRjY14CFbUWliQHO86rZtfTw8p85oHdOztiOQawJuKvJGgTZQdZ75Zk1PZZd/heQW8vnesJbY7QAOwjCMzgt6TkkBvCVIVwjRKdz44DjrPXGRpHpfSmQZCTYAPOr3zzgtKCxgAUOfq+ar4w0crRyaSb2lsApJt7lAV2V4qQupeFxWf70cRr+LlTYvaoTfPjIAjHwDe9ZYeqPT6PJkl+zL2PLC9BSEzfLYfMlzGEdAzn2DoQBrFQ0hJVMTiyHf7NgOmQeqHDKqnP4jzUPJrfD3e0VlIHBTMY96eYLJGcLMvZPMr1M34ayOPOzCMGpGyU6K6j7N9hr3rr5R3UnoUyplSruHdp9pxKxGK39u/EpsycYlMi0pM4wR0gJvHX9aHw942syqCeV4Tpyvg74H5OLpP/4ctHp2cB8fPERjYVxPxaAFMWtfvs9gI/CVZ1HXufRpT0Q/d8ZPbYdXCU+Ih5h969K09gf/DiChYNye9n/aglF1hK01iM7bHgbzpSPnum8qOKfv8PbJjmPbjaH1FpafvjHvdm+cMIbDCYTlx/xng3pLXFBIaee2Z9XSu+Z8pZjl/zJOaXkfnQKMzg33TiUyRspG47mfHDqdobNxVdXstdW+ywVgFTrhq7wCGEowdZWPsOYqJjJvuRrEMqrB165ZNfdeP3YTmrkxLleAfCA88rEE013rK7Bj0dzb0Z26z9c2KTh3Sfsv7YPmRuX56O8s+TMWHdJ5zN0Dva7wSoWHDJQGt4tkQcal+W6A6nsejdMAABIXgUim/CuoxBYVoLGjd6CKqksJgiRVmgtPOMpx3fkZrxrlSucIsrg+le4E+5Sa/jM6nV0fYiuB0HlC6oSi8dlsAVy9rGXi/gU7P40ysi3iWYzfCvqeCjNUhtWTbLuIxIT5swD0tOkHLToCMhS33Y39jDPY1GkjrS/Fv9krYMUiPmfwrQtjmGX4ETI
 gQiTilKP
 AgwUBxIVR4wJcp9LRzz05sZ+fvMeCRoHxbfVOOqtz+W+AxQsnw7gGgluouEEcIJHiGQoRBNlPptOgpupJ0OND17u4m3XPm4Br2PC+MITCNAwawEJMGv2Oa6LOCE16JnZRy/e3BfUhS/rTesFmThABOzhE/vkZOrLMZY2CloNzv93cCdn48TJQS/DSu8Fwj2N7fD9oGqEFuhNMUZodvbmmQii+Qcbe7xPSWiZheEOicKlOiipEQxAQMfKDeTyI5N7v4MoqygaE1eeoyMc7JdAKSOp/9XooM/+ReqyPHdBpOy8gmp6vpsyP+BK2FrG9CmNaZ9E07HBRVHhUsCHl7r5g5dHIB4xXtb6QDrcP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/5/26 18:21, Zi Yan wrote:
> On 5 Nov 2026, at 12:18, Sasha Levin wrote:
> 
>> The split_huge_page and gup tests need debugfs, and CONFIG_GUP_TEST
>> depends on it. Add CONFIG_DEBUG_FS=y to the fragment.
>>
>> Suggested-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>> Merged into an x86_64 tinyconfig, the fragment leaves CONFIG_DEBUG_FS
>> and CONFIG_GUP_TEST unset without this change and sets both with it.
>> x86_64_defconfig already has CONFIG_DEBUG_FS=y and is unaffected.
>>
> 
> Thanks.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks, I'll wait a bit and then queue both.

-- 
Cheers,

David

