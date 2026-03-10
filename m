Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0827FCC9D6
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ADAB6B0088; Tue, 10 Mar 2026 04:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C0A6B0089; Tue, 10 Mar 2026 04:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72F96B008A; Tue, 10 Mar 2026 04:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D47D06B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:06:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A1CB1C5EC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:06:24 +0000 (UTC)
X-FDA: 84529421088.02.24DCB37
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D4198C0003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:06:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kDTK3+jj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773129982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRIbrDZxkoKIPvI2kigWMe5Aopxeto+kdT0qYSbrZJ8=;
	b=73kCuEtYQdDu200D+Bmenn0VS5NA2hFbwZOuL8U5AUnwZlsMdE+og2vI2vpgOuekdcOdsK
	i3KCnUY+cCzfdVGSCz4kd94uLumEqoYd7aLq6LnlMI3vfm4Scu8pooXHDImMMyXLWChAo/
	q4bnnoOa0ityHFDbSNq7mXBL0Hb1YZQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773129982; a=rsa-sha256;
	cv=none;
	b=eazLKKxPVShmJrMYImI6VcuTLOHCobn3csf69PhOZMo/rzjBWy4kdq+PWUZAmNllY66lHM
	CIqTfhiqqhRei4i7nzi8XqbEYYEetwZtHkcz5T1S0lUL7ZKB4+k9uwi9pH8G3lYFthrIDe
	UgoM5DQEheKeFuwGQlMumwpa/tXF85M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kDTK3+jj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 498CA60054;
	Tue, 10 Mar 2026 08:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9E0C2BC86;
	Tue, 10 Mar 2026 08:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773129982;
	bh=rUdKDXI0DlYaE+1UWvtc7biFoHfgg11osLfNxYiUOkI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kDTK3+jjBknJVdHSAbYiSZVurbmj/E0XZo9xzBfJi94ogqG3EmLuPYbbls5PkYYIw
	 Ee3W87qX6JXOmAcSZ+ubsdIQMy6bisX87wg3UudFiGyXfPjBQ/P7iGFFL/mwNhwrGV
	 QYsADt+48Ta9+0Q+YTJkivBG4Exb95sRsHO1gmgFOlUneS7lsuqYacbQAXgWJ91IDv
	 mjrPK01RR52hTwOkw/779UHVnHevL+1+ZSPyPDd3QqKJOckud5lS1FUwPmI0gCtnpy
	 o2QoGxDN3e8ErY7KnUvyQ7/J7jR1Qjgs9bT0SpQe05MYMNim8pWMd7PUCPnbLcgyZv
	 iQXJ0fvTK5QUg==
Message-ID: <31f93292-3de6-475c-b7fe-82ef41a3a7de@kernel.org>
Date: Tue, 10 Mar 2026 09:06:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/9] mm/rmap: make nr_pages signed in try_to_unmap_one
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com, weixugc@google.com,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com,
 jannh@google.com, pfalcato@suse.de, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
 baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org,
 willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310073013.4069309-2-dev.jain@arm.com>
 <21801fb7-0f42-4ad3-8b85-2ac6013b8aa5@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <21801fb7-0f42-4ad3-8b85-2ac6013b8aa5@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D4198C0003
X-Stat-Signature: 5wxqmjyw5hauwo13gm175fd738bcdwfb
X-Rspam-User: 
X-HE-Tag: 1773129982-396200
X-HE-Meta: U2FsdGVkX19qSYmmjVMYuZ2vsK5oPGvQDtMHHzbYZ81UdOPitVCT3VMiYFfocVq7AZ4CXu+Pv7At26wVYx7Bt+egXPdzCkVvREcq8WEmUxGmemEkUWtkzxh7GBI/2xgXHJK6x/GoYYfaxWyfbmEMRQT/BN7j5WQZ6YJVB+gC1ef2u2I+P4DRoUlvag+Jib2TPXO4LxnUC/zmblfrxvOIuDJ7ZLMa41+ea2r8D9w3j9CecZxxLhhww3dgEFL7ibBUaSi7MNey8EjL0Qn/AKrYUBenePTO3AopGhx485kuohOQbsPcWWc6Xx3DcsfjL8BlZgPW/tGvABef3DlfVilsJ0TDknqWZ/2t8WC0rpTv/bzoZf2O3SVLDcd6QWgt/B5YazMCfAD/j4aL++lVDIjwhNKyACx0AO/k28kh/iPzdlYuss81EJZi3q0/Xj9LL7UiqQqSKviGcPDJUxHs4NkCxKkwmvRFE7Ut352q74EXvXiJ8xH5Pny91BbDdwADG75pvUEpRl4JraCabbCzGdWsH9BuJa5K5l/13xgi1lzXdiJXYhJxxv7yPHyE5oyYhIfqL7KQ7SgyYsSxBQlWnyanWbOt3b/NYl6Ry9LNrs+O8nPXl26krClhafw3GkZRXHpf9MXITg9GnnFbVX97naQeYoi3a+WuqDDHtZvzwyaQXidu08332HeqwhxiyM0GK5Q4PGDmofIwZFABygiJIcNUyA2mtuytc+vryxE26kDw5giG8UnyGdKbuIrxPdBVa8kv9wJtWjE8SPpId+OHgXDaD/KWcCmJYqJpIprU84v6jmHbX0/SBzAgKNtLaaJIJSaO2PG3CiwW/Pxiqz7to959+sGWKHkDllffTanDj1A3/lSHY1p5qFDBafG53FuBVetPIzBCtsdliq8UaRE3O+tSI3x4wsl7IpARQimUF+RzR5YfFDMWOC+7VtTpVezEjKITfdYslZc3cJVj3cxjd3q
 uL+NUvF+
 dNxoburlx8rttaJD1Yo+2PDYSuOr0oRvsT7Rg6TIdHBZ5HfH80W5IRWFknO+c5eaz9KMDKV6z6aMDJNCJNjrNSPsG0xZO5cz8oYKmdyUwAWBcz9y5CPZdZC3IYWu+gWqsPuE2ivD0QHf1lNptd+Vh4TUmzdk1UQyteUV6nUCIxlvoCEK/7QUVz5P+Dcyl/MIEhJvex8vn3l2So8vhfTm5Fon1iohwTdq4Y04A2gFaieYrQ0cXv7MPlT1I2V7XI72lSde0i8eKiC8D5aTEWi6fBLmn73L3x5qS8+5xAsz8vKrjpUVftbxSn+JUlOLULn8tVP3vcLmcnwK8cfB5BZxhXAmPxWN6284BRY7A5qGP1EBuEQ7zdS7Rw7RlB51y6vC/2RnFAmczmK8GOrI6F+iNzT2hwuhftdb+c4f25GXCjKK1LkE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 08:56, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 10, 2026 at 01:00:05PM +0530, Dev Jain wrote:
>> Currently, nr_pages is defined as unsigned long. We use nr_pages to
>> manipulate mm rss counters for lazyfree folios as follows:
>>
>> 	add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
>>
>> Suppose nr_pages = 3. -nr_pages underflows and becomes ULONG_MAX - 2. Then,
>> since add_mm_counter() uses this -nr_pages as a long, ULONG_MAX - 2 does
>> not fit into the positive range of long, and is converted to -3. Eventually
>> all of this works out, but for keeping things simple, declare nr_pages as
>> a signed variable.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 6398d7eef393f..087c9f5b884fe 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -1979,9 +1979,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  	struct page *subpage;
>>  	struct mmu_notifier_range range;
>>  	enum ttu_flags flags = (enum ttu_flags)(long)arg;
>> -	unsigned long nr_pages = 1, end_addr;
>> +	unsigned long end_addr;
>>  	unsigned long pfn;
>>  	unsigned long hsz = 0;
>> +	long nr_pages = 1;
> 
> This is a non-issue that makes the code confusing, so let's not?
> 
> The convention throughout the kernel is nr_pages generally is unsigned because
> you can't have negative nr_pages.

Indeed. Documented in:

commit fa17bcd5f65ed702df001579cca8c885fa6bf3e7
Author: Aristeu Rozanski <aris@ruivo.org>
Date:   Tue Aug 26 11:37:21 2025 -0400

    mm: make folio page count functions return unsigned
    
    As raised by Andrew [1], a folio/compound page never spans a negative
    number of pages.  Consequently, let's use "unsigned long" instead of
    "long" consistently for folio_nr_pages(), folio_large_nr_pages() and
    compound_nr().
    
    Using "unsigned long" as return value is fine, because even
    "(long)-folio_nr_pages()" will keep on working as expected.  Using
    "unsigned int" instead would actually break these use cases.
    
    This patch takes the first step changing these to return unsigned long
    (and making drm_gem_get_pages() use the new types instead of replacing
    min()).
    
    In the future, we might want to make more callers of these functions to
    consistently use "unsigned long".
    


-- 
Cheers,

David

