Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 782CAC9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656666B008C; Mon, 28 Sep 2026 08:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A716B0092; Mon, 28 Sep 2026 08:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5936B0093; Mon, 28 Sep 2026 08:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCD46B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:46:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 924D41601C6
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:46:52 +0000 (UTC)
X-FDA: 85263145464.26.548CC63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5CAFC0009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:46:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLO2FB68;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790599610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPyOk5nBUF/LDpjxx5RQ1YM9nnmqTs1Y+tPLkniResQ=;
	b=Sy1nE5H7tfBEC1Q/h2e1wq663LrwuncFIL48UKo1W3339rt1cSUxG97ED7NjjNwbtxoIcp
	E3lY02RjzrIX6wmK3ChCyNp4xReKbA6UDk7+kGRjPG3LB8rZzM1+GVkF3wYkuUsL6DkVBR
	GreDvhFuZ193ppCHd4jh4jBomSM8v5k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CLO2FB68;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790599610;
	b=Q1IAHmmriErfRCLS07P13i1GPJW0+OzNTdrk2W/rohST2bKundIB15fKeu3Cof18sUkc55
	haf1ijfylWWe4+nVbzu08h9DlZX40jGx95zhApZtw31/2dk6c2xUTpz9vk5FiSmMYlXAmY
	lWA7qRfuyIE0HM3me5TkWZffmOYyFuc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F31860052;
	Mon, 28 Sep 2026 12:46:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FADD1F000FF;
	Mon, 28 Sep 2026 12:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790599610;
	bh=sPyOk5nBUF/LDpjxx5RQ1YM9nnmqTs1Y+tPLkniResQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CLO2FB68h13oONS0tCxT3nzpBarQ0IMXTNE8i/vtr+wdvHrdlshJxeAaSf2Vy7ANY
	 vO23AracXVaObH4KAm+tkNctqZOp8360QJq2izxto2xDz2CkjdzYaoaINh/58bZ4WS
	 p7DJh28paTWK/aQpKNmO3Zp+zCa4+mtkgDnnoiG9hWxIRcRRa40VkhWbl+T5Lih4Qp
	 dfuZT0UdAhUvgQCCSCNpjgzIdT5lS0QZHkHkFkF+buuW711LVx6MRCCVEKzG1jjE3s
	 CQ/HDjkO/BlH3+9QMoMpKI2A8plwtDPG6LYLf+bHNHmHUNoBy6mN+Y3J6uXoV+EwYS
	 JZExNChDtc8vA==
Message-ID: <8c4ffa3e-4ce6-4b0b-a2e0-08d710c54522@kernel.org>
Date: Mon, 28 Sep 2026 14:46:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/4] kselftest: mm: replace usage of /proc/self/smaps
 for __check_pmd_huge()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260924-fix_split-v8-0-cba7359d882a@arm.com>
 <20260924-fix_split-v8-2-cba7359d882a@arm.com>
 <bde32459-31ce-4b15-a129-4641ef1c6337@arm.com>
 <araDzcqZMmne_w4Z@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <araDzcqZMmne_w4Z@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5hx5hacsqatwuugmrnpqjizek1xhdf5x
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5CAFC0009
X-HE-Tag: 1790599610-845501
X-HE-Meta: U2FsdGVkX1+wy1WpK34paq3YB5HPfa5fT5MbYY9pJcXqNqNCBzyIduh8WKxwPgrEOTKWfPBJhH82SndqFYU6eBuH/OVG+ZJyXHkFwbNtjP9ucMHgNbq/yyA0L1xRPRzy93BQ9QQcpsa1Fzsau3xp0OPULuVQrKXrbD3zTEIPgN1O0glKO72KHpNHq7K7Fg9DUgJO0LwOrvaRfxujvyW9KfmjC0Ip1DAhFTrdMhajIbA7tiuUBfmQciz4N7SzX/xoV6M5pTSMtI84uA44cuGcmOuNgdffvVTHSKLjBHS9TpidJIYpHas8qDLKb6KYXv0IGbAeE9I2abgPIFh48159tPDrU+QdudlGfAm3tZ3MDygWFTyI4ulrIBqSwWtbAb+Hko/cDhRRFiA+amCQHpBgxiqjjJEYH8sWieX4bLcz/5eMXvf1TONK5gmWOoJkvn5aXr9A0mm+woKmxtL9Ilxqge43HhE7QS4qdXNvWpKGDUxynbHgncf4+FmASwxZLstKIrsGviB7vusRSiEdQUgaYCq1nSMDRZrbw+JHd6Yz+zy2nnN4hg5nlL7fzBlAEyA9UBi0SyYVYtD1q/VBvVfz6+HpemBWUc6sIiRZwb1n1wP46pL/AzfUGIumBdL+nB4NvOHuZOuGgSIkTrTEdYcIpjqW58ZaYNCYm7thBBgsfqtAaYOLJF3sBtAA4hNYHq4XNxsqQ8U+EINnqxdrHSjhjokj+5ID7H0QM8a5NbTOXXHlpfjVRJI5wMC6ZhxFJe9QMdaJv03b2m6dnskr68++7J06PJqO6ngVd2HGbm4AuS3k4imdhbeBm+fWnBufUUyrP1h+pgMwqTDFH++OmWDjt5S8OciSfRGgZQ1TrvY7nrK5qJexj2EQAtkHzzcvY6k0XcirGM2ecMBEtkDp5mmOY8hNtZn1K3xkqnTLdropk62wNw7TmuU5rqTJEJTUSVhu2TjHsHuY0QEvnyyqILa
 j22Txnkc
 MsOP5QjjinK5uyNbOonz2E+GtShoWCH/nevjrssXPq5DXErguWa/6lMQYSj3tooeKvgSEFMGXdQ27g4UpC9dPBp4P3fetvIIkzY0LvIEMWPxUnteBC+IBDqFQ7+RE2Y2aVjXkR0HxNhyR/5I7n1YJ8x1WBLJDZTfA9M+gXhRiB4Q6B0f7yGmkGvl1ci/pjfi9P3+S/latFANja9E07as1Ff1Vb02aQE7ATnwfx3f47EQoDz9tO9QfOobPO2yob91ktB7zK2LJryf1RYbY8iicz8bAPToHaAYPmkugDeUrwJC0lL1FqpitrtDdGZ4+tdtnF5pkTCCNUPyBkf4OxRrqkz+35jL0+LM/oCqAJcm6VNivksn4WGTCV1OzkU2Z+CpAfY0XF/8WLqYiVY/Rq+8Y63Am7uWa8LA1ym5C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 16:23, Yeoreum Yun wrote:
> On Fri, Sep 25, 2026 at 06:08:44PM +0530, Sarthak Sharma wrote:
>>
>>
>> On 9/25/26 12:41 AM, Yeoreum Yun wrote:
>>> Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
>>> glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
>>> made by memalign().
>>>
>>> The underlying VMA may start at a different address from the aligned
>>> address returned by memalign(). Furthermore, a subsequent
>>> madvise(MADV_HUGEPAGE) call does not split the VMA because the flag is
>>> already set.
>>>
>>> This causes split_huge_page_test to fail because the check_pmd_huge()
>>> helpers incorrectly require the address returned by memalign() to
>>> match the VMA start address reported in /proc/self/smaps.
>>>
>>> Instead of relying on /proc/self/smaps, use /proc/self/pagemap and
>>> /proc/kpageflags to detect huge-page mappings checking PAGE_IS_HUGE
>>> and PAGE_IS_FILE accroding to type of huge page.
>>
>> s/accroding/according
> 
> Okay.
> 
>>
>>>
>>> Since shmem pages are also file-backed, simply check whether the page
>>> is file-backed.
>>>
>>> Fixes: 642bc52aed9 ("selftests: vm: bring common functions to a new file")
>>
>> Checkpatch gives a warning saying it requires atleast 12 characters of
>> commit SHA.
> 
> Oops. I'll update.
> 
>>
>>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>> ---
>>
>> [...]
>>
>>> +static bool __check_pmd_huge(void *addr, size_t len, int nr_hpages,
>>> +		  uint64_t hpage_size, enum check_huge_type type)
>>> +{
>>> +	int pagemap_fd;
>>> +	int nr_pmd_mappings = 0;
>>> +	uint64_t categories;
>>> +	char *start = addr;
>>> +	char *end = start + len;
>>> +
>>> +	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
>>> +	if (pagemap_fd < 0)
>>> +		ksft_exit_fail_msg("open pagemap fail\n");
>>
>> Can we use ksft_exit_fail_perror("open pagemap") here? Will help in
>> diagnosing failures as well.
> 
> I see thanks!
> 
> 
>>
>> Apart from these nits, rest looks good.
>>
>> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> 

With these things

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks Sarthak for the review!

-- 
Cheers,

David

