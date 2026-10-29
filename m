Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 264B4606A325
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H3FsUol2
Received: by kanga.kvack.org (Postfix)
	id 38BD16B05BC; Thu, 29 Oct 2026 06:58:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33CB36B05BF; Thu, 29 Oct 2026 06:58:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205A96B05C6; Thu, 29 Oct 2026 06:58:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD9DC6B05BC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:58:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74CEA80312
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:58:07 +0000 (UTC)
X-FDA: 85375364214.27.2BCCA73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A6973100002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:58:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H3FsUol2;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793271485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRlYvtp0NLbF/qBaWCj/ZYIcUA7W6S9v5stNA3ILEuU=;
	b=4nkmB5RdLQ+kt0et8ZkQna24+w7GYQxYro3hWr8CJxZk3gd+hkelm+P5IpnfAHn5ZAMKI1
	3yZ5yYCjF5W5nPuM9zc+M7gnyeP3+b++ByABhM55khpQtZ5k3ytuBg6QACYqhj8F5wLAjL
	HieEQ5upWo3xD9u8nF0AS9UIP7v4vYU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H3FsUol2;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793271485;
	b=wNUmyAJ4hYOWnQiv//LyOzVlS3SFuVBUMEs/6o4geT58YeG1EMcJh/2JuMfNda8uKfvZfm
	jwCqmO9A20WwbdN9BJElY+h/c8Vrj1LGWFLh9sMtiqj8TdEMrb8x2yYEp3K+vd9zTGon56
	YyskI4oAJfOaf7eVjD/HSqSZr+J/284=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED08F43ECB;
	Thu, 29 Oct 2026 10:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11AA1F01825;
	Thu, 29 Oct 2026 10:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793271483;
	bh=HRlYvtp0NLbF/qBaWCj/ZYIcUA7W6S9v5stNA3ILEuU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=H3FsUol2krhWc0MOsqYSy4b1n5I/yEBuYGJf4ssu48mgFUkvW+0qm9DYEj2+lgKgm
	 fFIbgCvBARf3WoqRQM+NLSRyK4kJJtyXKF974wXPAnGy4mgrBPrkqSLraPFBxk9NfV
	 L82qn5kVuNTWaxKH3veWkSXybe31FXgnFOznG6WMGFZe9paGUxsFhSbjUdaJI80DAR
	 97c4aNlaizxp0hL3Aeed13cW6uSdzU+3T6iuag663YJN6movTiPMGWocBnKF741/kS
	 kb2KEPH80ay4scp18cnaw4P1KMwb8sIEcjlJBYfiyGroVIGDg6lz21BKMsUllLAqh1
	 0vJP7Pj5AIqZA==
Message-ID: <d7b1c89f-b119-4598-af22-1a7e4e4a3037@kernel.org>
Date: Thu, 29 Oct 2026 11:57:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
To: Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
 <auB-3BQn_rR6IfY8@pedro-suse.tail5790ac.ts.net>
 <22b819a2-631d-468e-b724-770caf9f94e4@kernel.org>
 <CAGsJ_4z3qgCPBpCDitVTq+xiGsS=-yEhKSbEO4Lbdn9MVAHK0g@mail.gmail.com>
 <auHve-G8bboW77IZ@pedro-suse.tail5790ac.ts.net>
 <CAGsJ_4xD_EU9sBZmJRb3ET3zfxnOnXJvZB1p_3pTLV=Y4xHPMw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4xD_EU9sBZmJRb3ET3zfxnOnXJvZB1p_3pTLV=Y4xHPMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A6973100002
X-Stat-Signature: ta43dnhsiy8u6kaiqo3e8tgmedj7w4j7
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793271485-870568
X-HE-Meta: U2FsdGVkX19ATT/jXIvJLzjnSke8MDYIPmnLl6mzrMA5wmn4JcPv31WnmT8XVDz/AViIoHTWdTzyNyEMzCSVP6VyiWy9072oZmky3hsy3ihLKh4oqq+w+JYt1nZyYR702VEi9M0Rh7bTCaW9QbG1ox4laYL68i46F8GHFKTW7F+io/s0eQ1X0ZbVHOee4AzbqDcTvxDa96zABtZQ9BK7jAp1vC6bIHs7zz5Z98y4fSSaMCQJeLkR4hBVDW5JiZVfcgRmpCWHVaJuHNlhWQ+sTwfzZNZLUFCyMzMs5f6bmRvoifVZbVOmU+hav5fsfVRcOZuLVAOmOm+0Jc1U07aLMi5+IZ1r6AOWOZFO5WIlEyQaw2Naiq/eMEZMnltx6Oq6vsb0vscOHNmmIqCQLTJijKKhXbYUbKUkXAvflrEXm3n2cVmz9R9Ztk/0Xy9ZWZj0bi7jSqxfQx+nT1ru85ktyLNkMdQhoWLkHdfx2hedCrIqHXR38sxdvE/aDlurTsIoLD+n4N+K97A6VADQjRlpxjuw/BUE5F3U5HJXopE+apuULSKNwusZr6UTI+ecBl6JSCQmC6ZyFkeBnAmMFRX8B8XSSqT9YIASHffw0PCCi6cKl8C7+gQi+Q/4FvUPpSqYkySLaHWWQGZgsi7KzAopjNwYXpk2X2Dzojg/G/F4w5+FrjKRfHY5O3ni01sISMQe+YHi0DAZjCdzSaQPZbfZ2UgNTzQw2MRHMWItSxXBdNhKukTUrisB9tFVuauTT0eFZUbScztKp3WCuUQPqb5fgLntACpKNrXN0ib7saGZzYMyYZQe4k4DH/RD+qzEroq2bSvZlusvVjEWbBEPtsSwlMUC43mS1j0O2JDUIa1pV570Hc6DNah6HZdTqn9cGscN26mqrcvYvAnR1K37eIuf2TWIlKr0YMctRJ5Ufxz1N+bMkOT+Fh18TSSgCypp0j2MJ2u7MDfb0zXZv0i+Kq8
 qtTZnp2Q
 svZLX+cALzzxjBCFzhZisFvplCrw2EpUV9XzMoeoBdY1VHtGBS198EUzkKm/kf3NM0EAPc56Bt49n0PF2pT0zHbeuV15vRdS6bsiCsrmLdjnnGT7HnaLxXOxQyFNxsD/Cc871yeHCkD2djl8BqJpU9vaqkBB9/AHa5HS8MvfepNK8t6U4r1N/ovPZQhgZeIGSAyL8rjDb5q0+TXbGL+7AfecIWMrlFafu6JOXTMU9mg96edjrySrZUqkxbyBbizglnEAn3zh81M5q5EZsr5QPAolghyzniESUWhNKa1BNU5Ab3HQQLuxhLyLNkv93HvK18Ofl5P89K0TiJWsVdvRIZ8F2yOv30923xjEYTnOF85fKEAXegMdcgLXSwa+v6H0RY1i5rOzasW+xyU09ccyv/We5bkVqslR3RPzpk0UnwLRXeDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 22:11, Barry Song wrote:
> On Wed, Oct 28, 2026 at 8:55 PM Pedro Falcato <pfalcato@suse.de> wrote:
>>
>> On Wed, Oct 28, 2026 at 03:48:09AM +0800, Barry Song wrote:
>>> On Wed, Oct 28, 2026 at 3:07 AM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> Regarding the race with memcpy(mm, oldmm, sizeof(*mm)), we
>>> still have one [1] even after this patch.
>>>
>>> That is, copying mm_struct can happen concurrently with
>>> lru_gen_del_mm(). However, this race doesn't seem harmful.
>>> I might be missing something here though.
>>
>> I don't think it's harmful as well. mm_init() reinitializes those fields.
>>
>> Though I hate that memcpy. I think that ideally we copy by member and
>> data_race() benign races, like what is done in vm_area_init_from().
> 
> Yes. I was suggesting something like using data_race() to
> silence the warning[1], but applying it to memcpy() also
> seems a bit too drastic.
> 
> Another option is to copy members one by one, skipping those
> that don't need to be copied. However, that would make the
> code quite lengthy, and the copying might also be slower?

The compiler might do its best to improve it, but I don't think this is the
direction we want.

We'd have to figure out

> 
>>
>> Anyway, KCSAN reports aren't the most serious thing in the world, so this can
>> (should?) be cleaned up later.
> 
> Yep, I don't think there are any blockers for this patch. I had
> actually given my Reviewed-by tag before raising this race.
> 
> David discussed races between memcpy() of mm_struct
> and other operations. I recalled another related case, so I
> posted it here. Hopefully, I'm not just making noise.
Not at all. I think that needs a proper investigation as well ... and I am still
u clear how it would be valid to access the mm struct without the mmap lock (per
my patch) that way.

-- 
Cheers,

David

