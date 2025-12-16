Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14B7CD5B87D
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 01:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64C6D6B0089; Mon, 15 Dec 2025 20:38:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624116B008A; Mon, 15 Dec 2025 20:38:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5231B6B008C; Mon, 15 Dec 2025 20:38:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EAC76B0089
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:38:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD98A16041B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:38:23 +0000 (UTC)
X-FDA: 84223624086.27.0074291
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id D0D6E10000E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:38:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765849102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=csQREpxfvMH+2uA7mCrLyxROrvg4H9ZQyQlNEvHHJcg=;
	b=CLtUnKGdtdesKMjorLlKkcDoLGELaTUKxaEpTKo+cRA6408qcoNq+e2b2uV4PffC9wUps6
	X13IXXS4kYzWL6TL8nxBMZsQ1FMhFXZLu+Qt/dWHzIzVda5meRZbXKwevlm2fcWPhvo4MV
	IxM+hkmJMDpr91lsauSrm2K5ra/n2aM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765849102; a=rsa-sha256;
	cv=none;
	b=iiIwacExhCQCWQ/NwOGp6scy6yfAe6Ydl7UTSIhjfboUNAffWmNUdnPMldeYigaKtgLN4n
	682Yp/ztJHlAma/KCiJ8lGlvKO9SAnSdmbWiHjT/XGF02///B3+lYvm+JAKqt/NDkSYTYq
	oFiQYJvS5HS7lmZguIvox8XGIDG/I70=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dVfgt4ZL5zYQtk9
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:37:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0F5821A06DE
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 09:38:11 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgCnB_j_t0BpppBdAQ--.40469S2;
	Tue, 16 Dec 2025 09:38:08 +0800 (CST)
Message-ID: <fa7b6432-a35b-4768-91dd-926b45bb6980@huaweicloud.com>
Date: Tue, 16 Dec 2025 09:38:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm/memcontrol: make lru_zone_size atomic and simplify
 sanity check
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
 Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251215-mz-lru-size-cleanup-v1-1-95deb4d5e90f@tencent.com>
 <3edf7d6a-5e32-45f1-a6fc-ca5ca786551b@huaweicloud.com>
 <CAMgjq7DVcpdBskYTRMz1U_k9qt4b0Vgrz3Qt5V7kzdj=GJ7CQg@mail.gmail.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <CAMgjq7DVcpdBskYTRMz1U_k9qt4b0Vgrz3Qt5V7kzdj=GJ7CQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnB_j_t0BpppBdAQ--.40469S2
X-Coremail-Antispam: 1UD129KBjvJXoWxWw1rCr45tw4kGw1DGF1kuFg_yoW5Cr48pF
	WUta48tF4kArn8A3sFyw12qayYk3s7GFs8ZrnxKw4UuF909F1Sqryakr45uFWvkwn3Gryj
	vF4j9asrC3W8ZFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: yuhum8dfdtg5eaa685fjzfdq6c51teqs
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0D6E10000E
X-HE-Tag: 1765849097-253710
X-HE-Meta: U2FsdGVkX1/3ydFk8xTdJ+qhTviJLeyot+yO2ulaN7wglS/ttGcRmewfmkL+plSO0s1kbhkYn4UlVChU7EEYbltNHBZKx4X7QN2YnFNbDcW0wF2OJUSwm116fGHtT98jULz/UIaNC3meXIqDDbspEh8mAuopEGtnoVkDbFH+SehkjyIJNmnGxZFq0lYNJ9nDA4Q8/tdeBXpqF0iD30aIw50PZ6COe3+dcU9d1ic3yT4QAUtVpL0Z1t8n3Qvfi1nVsht3w2KuHDqL0itvQP0BUc4ewprZ5KejX0Sz66iaalbvVwiP0JBcIv9BHIINfGI9AVeRokns2KZdKbrL+SonSj2Nzr0mK0CRHJb67Vc5dq5q1uFGpbpopOppTVFtFdhB1B0k1STKaiHj/wk5cutISUzRqSjlUjKxJtPbAhwkKYBLdPnKGOhwE1sui5pvTXbV/9aveFKDOvwOCZjZWzAGrrA1RKXq2POD94F/GTt2/xws/Fh9hBncAw5eDPVSru5N+XLOZfpPvZ6VguQvEwP8ul7u+IExITGrD/Er0NGK2nVHKoo15z/u1ZIG6eH/Tmc9cZjzSvZk+cudGT79+eNphIPIJ9aSKRdcecoSY4hYAMKgAj5422aA2fggQqE4/b0Tuy9PLt5s11PGBEnHmLcxnlyNCmxdes3X1oZnvWjvvMXlh6RzA9O7h6wvwk8oFauwrI/1mDClQ/KHqQZTbe09j30hDIaJfB8OcwYZOIZKnNtDyJEPpLpRLDeIiS7jaH99Xif4Nff19BC6114mGQzLP4z2dFxoRM20QIsI8hZdV5iDW7pXLDKuPfvaltuMFV73f16Ma/lZYVJm0ylDERJXoiDd/M40KiEB9L26pJJskwMiQAk3rZYc9XH0p7oS5COqaM2uqlU9SiXgYMtMnk51v3qfPjAn1nEGAsrtp5sKjdLsfcKGQu9NFsaMstj/sdpFED1MNdqbOTRbmljSfcW
 JvhDiIuH
 WDHB+h9yuSt1CrCaXJCp9UrFDXnl0dQLoQQnPVIhf5umYsiQ549qIWeYolpmym6j9DXgmw45S+I4UEHT6bGfxWWNX+7yPZXfZMcrq1cqduo1m6Nsa20PkRJL7qCA0SMZoYpU19rYzgaTDz9FPZQ78pBeFCkKKFw1qKQ9wHkggfUlovCI9G5+KQztC+q39WknyNrdU1H4jzExD9Fh7/E8PrO2zpjjA+Gu0+kwkxVot9CYhRr7bWhqHcO5HgbbZa5mw4kJj4VdphSWbznCTXNc7EctT/8dYiJSYEfZJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/15 16:29, Kairui Song wrote:
> On Mon, Dec 15, 2025 at 3:38 PM Chen Ridong <chenridong@huaweicloud.com> wrote:
>>
>> On 2025/12/15 14:45, Kairui Song wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> commit ca707239e8a7 ("mm: update_lru_size warn and reset bad lru_size")
>>> introduced a sanity check to catch memcg counter underflow, which is
>>> more like a workaround for another bug: lru_zone_size is unsigned, so
>>> underflow will wrap it around and return an enormously large number,
>>> then the memcg shrinker will loop almost forever as the calculated
>>> number of folios to shrink is huge. That commit also checks if a zero
>>> value matches the empty LRU list, so we have to hold the LRU lock, and
>>> do the counter adding differently depending on whether the nr_pages is
>>> negative.
>>>
>>> But later commit b4536f0c829c ("mm, memcg: fix the active list aging for
>>> lowmem requests when memcg is enabled") already removed the LRU
>>> emptiness check, doing the adding differently is meaningless now. And if
>>
>> Agree.
>>
>> I did submit a patch to address that, but it was not accepted.
>>
>> For reference, here is the link to the discussion:
>> https://lore.kernel.org/lkml/CAOUHufbCCkOBGcSPZqNY+FXcrH8+U7_nRvftzOzKUBS4hn+kuQ@mail.gmail.com/
>>
> 
> Thanks for letting me know, I wasn't aware that you noticed this too.
> 
>>From my side I'm noticing that, lru_zone_size has only one reader:
> shrink_lruvec -> get_scan_count -> lruvec_lru_size, while the updater
> is every folio on LRU.
> 
> The oldest commit introduced this was trying to catch an underflow,
> with extra sanity check to catch LRU emptiness mis-match. A later
> commit removed the LRU emptiness mis-match, and the only thing left
> here is the underflow check.
> 
> LRU counter leak (if there are) may happen anytime due to different
> reasons, and I think the time an updater sees an underflowed value is
> not unlikely to be the time the actual leak happens. (e.g. A folio was

This is exactly our concern. If we don’t read the LRU size, we won’t get a warning even if it has
overflowed. I’d like to hear the experts’ opinions on this.

> removed without updating the counter minutes ago while there are other
> folios still on the LRU, then an updater will trigger the WARN much
> later). So the major issue here is the underflow mitigation.
> 
> Turning it into an atomic long should help mitigate both underflow,
> and race (e.g. forgot to put the counter update inside LRU lock).
> Overflow is really unlikely to happen IMO, and if that's corruption,
> corruption could happen anywhere.
> 
> The reason I sent this patch is trying to move
> mem_cgroup_update_lru_size out of lru lock scope in another series for
> some other feature, just to gather some comments for this particular
> sanity check, it seems a valid clean up and micro optimization on its
> own.

I agree — it is confusing. If several of us have been confused by this, maybe it’s time we consider
making some changes.

-- 
Best regards,
Ridong


