Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE4F606A324
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=g0RX/Vhe
Received: by kanga.kvack.org (Postfix)
	id 3F9936B05B6; Thu, 29 Oct 2026 15:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA6A6B05B7; Thu, 29 Oct 2026 15:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1916B05B8; Thu, 29 Oct 2026 15:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EECF06B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:17:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B4971404DC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:17:59 +0000 (UTC)
X-FDA: 85376623878.01.D65E222
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 35D6C1A000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:17:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="g0RX/Vhe";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793301477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ulCvwB2xwRabyK+mOG5zQB868mEQ7a193kjvrG/0Sg=;
	b=B9lhlhAitzy08RHj+bwYeqru7Z++HP5HIlR5ROHJ/Gjcbq8JzDAROnSi5edGSm+tAfHHG1
	vnapwWWodS8YsRIWVD9ghoBKfqUwTnteadB26Aa1nxxsAJZbgsRiE00vsf9Y2OfFtwh4jz
	fS0OhwP8FH0ybyFj8RNCFZNzZNrU/ZA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="g0RX/Vhe";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793301477;
	b=h8ok1/cBXY1BZdvBnVEJyAetJZ3a9jTt2ayrL8HXSEXlp5jxLLA4ircV0rkqoFkK9OxEb0
	WyKxL7QWPzmZfMGbJAo1hRAmWPo4B+yb3mV2LkU9FHISTSkOjw/NsTlgEsmmEtUwuUlCBu
	4t/SbDgtjxs5ydOVS1UqBgNSLuBGCRc=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67a79750749so1550461d50.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793301476; x=1793906276; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/ulCvwB2xwRabyK+mOG5zQB868mEQ7a193kjvrG/0Sg=;
        b=g0RX/VheGF6LAMM58c40fQWxGq7ma7b9JC1gKftsdLtbKz4F0/7+EL7RWJ9wvwZn4o
         W3PT+9NWoROPEtbuMfY2iGgDlLIOtRXeRCHirOt7hptZLd+61U6GZE2UGX0FROex8lA3
         s0DonP2EemZA5moL6BiFx0V0G4nxOAt78fiKhsm1GU0tuEOA8BfC3sHofsBspy4XwPHi
         ThCAuFRNjDPHS8ZcQiFYiJvPjQGdoRt+vAgTTOd4boiZi81P+OkIOKzlrdjInIoG1QZN
         u9O62jDmx4F05/E8Gu6DjDLEY4LC/PdytxdRVsrzEwlkTNJmi795cfHCdrWCXCbJ0nf6
         3BYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793301476; x=1793906276;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ulCvwB2xwRabyK+mOG5zQB868mEQ7a193kjvrG/0Sg=;
        b=eFlqks+G9jClAVX3OgcqvI/2WK4U9XiI3bresDOgk2ezByCYssVICGj1/B7rcQxRK7
         yiwetFYiU2/LnX7gzfAxUNhP/9NS1zGa7fUbz0jalx/yzcsWbYXLO/onMYWmf9kPlTx9
         t6NCRp81iWoJ6KJaxP0Ksl8hYTtDoPa3kSN0FGip76ry/Jey7SJLcy0adU92oHY159Gm
         lKwXyUkslKIB99z+XbfQVdKchSRCl0B2/BUtECwemS5FZrDC8qpcJhM2mI9UXtzn4R8H
         Pyl3c9uR8L2YOzaHHNfN3E6EwpIM6bVOY8gp7unA4AF7ghCClFEXyitMM+PLoJPtQ7Di
         oYEg==
X-Gm-Message-State: AFq9FYIiJ7alQyA2U7CIUZaZEfdLmNqNp3o9pTrPqN9zFDp4TiTnURIU
	UsnvBnTWapYVp33zff4w66derXUoPx8BSIndYjxAvbBrKdFV7hTnlZMo0GG3qmxTwMo=
X-Gm-Gg: AYBFou3571LyWNqcgKBJA5X17kVtUAjmmM6wNnuJtuWQND9O0BLlvnaSUHqawiXZrnm
	QANxGWxqJy73+YOGzOC8l4I+qAsfBtVADEpYUn0gZmQdO9W+Y1x925DrEuTA76ysMO5odmzdL+X
	QefO1wWsPvmncFi8W9/3wOLjzAL2JlAL0VRH3Zuc24zrOsIQlTULkeHaIuCJF7QfvS+z9kNxNNk
	1LAgm7rY8d/YX70vsM0BdZMx8jxkuoCRolpl+B4AWvvoNdCWjQSmw73WwItRgKmBLGjIGgmQXoi
	dtQMHbMTDM60rPUzlYr1v+dslp/4C9mO4kxFKYGYimRvKH4GJTxwCMacBMUImTfkMYj56ZQ+8ee
	1rOGK0VNT3M24DNMYqR61Eq72A5VhKr9q8sZgPNwwaSC6IbxDa5/xp4OAa4PBoVg6w1VFENo2N0
	8ngrtGHXBwU+H3QAvoh9jCZftbCe91R19ms/iRGGS1yk7S9I3dBZLcubaz34jB+Ztagy5lbA7S0
	wyqrrtiIUQ8hdmctrHwLKNUUpoMl5Iam/fcgAdJKcfRsu//Gx6MBB98Qsx3xqVuNQFUWCUiG8G7
	CvIuVyp3BbPMrnxYx99eXCK6dKCh
X-Received: by 2002:a53:b193:0:b0:677:cdbf:41ad with SMTP id 956f58d0204a3-67ba4c90d54mr59919d50.12.1793301476120;
        Thu, 29 Oct 2026 12:17:56 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67ba3a2552fsm148947d50.17.2026.10.29.12.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 12:17:54 -0700 (PDT)
Date: Thu, 29 Oct 2026 15:17:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Chuanhua Han <hanchuanhua@oppo.com>,
	Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>,
	Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/zswap: drop the stale zswap entry of a zero folio
Message-ID: <auOb4tvXoDbsx4jz@cmpxchg.org>
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
 <20261030-swap-fixes-v1-1-73f73a59f2fc@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-swap-fixes-v1-1-73f73a59f2fc@tencent.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35D6C1A000D
X-Stat-Signature: 16scb9ksjjuuoq4sfo3ocmyf4p6tsuba
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793301477-481357
X-HE-Meta: U2FsdGVkX1/X+CLYaLorctrZpoWMtu0O5F81FSyopoC0D8wzhyIfdQvss68MH8rvY3IwugZF83p/yvN2Ia5JyveRE1gtEwDIKk8tgvdJuu0GBl50/eJLMJG5KtA0lMp3GxEiFLJpGRbkIt9sPgoHWLs6QEjXXFK5hn73LO1Eic4040JKl0TEXi+nrOShvzOrYNmS3b0rXwgVrC0NjZ47ze/JM0H6dN7XqB3U8nWiBITVqUCiWmmGn0UyiE646qTvcRfr+OKoe3YRgrAy5D+MSobwGbj5lZoLt5SCnEL2LrBti4Zfq1TeTP5gW+jxe5CGPSRKeGO93+gTgc4k56D1m0nx0XSyAxD9dYkiaGAm4rYV45FWup7SNRKHmGlLBwAtWIsXsTBLpghGUP8hZ/TTyaS4TMz/N9BxoXOCcjmwiVeEdiToJsKo7L2Gwl7WtBkLXE9NeD1pdzE5S/fKJhsnALlIWs+PTzjFoNBLjP3fGCB9jegjTqSOShT8CkOwL3y00QSLrPMzecIlSTnzC83z6aOnVsHD7HhNERS5KDpSAsTEvAbpN6WZw/+8/PY6Z5/2xn+WlgSNa9Me9L+hhYCil7Gft+yA3xd7jAHf2J7/KaoVUClXBWAHdXygDZHi16JhPUa0zMrgYmrAcqBw8EswM9kTl+iMeSkLrgcCOUCklX3EMgX2eUG85elk/+4QvkSMpIBYsOsPLmzi0epsPSMazr/aeGmDpPEXakUTTuczpK8bstU0eQjMJrsP6Y7DM265pXizznPVikoDkvIhgsDfwlK6NWUv5+RF0EPR0yUVJxRu6jUcS00FqRsj7QNTe2TXDDcZw9W4SfVW+mHsO2xSov3v5vyIkfJ0PccG/Ak+IkFfCw1+RNAthxvzwRVbGDDHccZgcMFhIpC3hElCXoHcH0LAQbR3AV1Q5bMMnyu20JW6AX2RVf6Wn4OtAAUKQIETRJLxRD3eed0xcPyRElS
 aZiyQnOk
 bK6urE85JjuyzO1nbf7emlNB6L2YY/qqZjO3sJhc0JA/vxqWL05IZv7fepnTSW8iSMndTuI/FK3l8zrtcNRZL/fws43K3WbuXqs5x/+WBOtJWzjDqb0ez5n8B7VAGTIBz+7ITWZ9DWNZD2cIhXDq45qW1+y/6JkTK+RePuHgwpIVBuFyOTGqDiWLhyS7C6RVnJBx/A+i0HzMEDyT5Ufcx7KmkCUsovWAZ1ZhylIsMYaG0dgVnjxnTrS6/BLBPdRwDeXfCsmd55xV0kGw6ruG9TeJv4rnH3YV1sH/w7xqt1T6f6Vv/wCklWUZYffYM0HwsVKTeifEGbjwHBVIDW3YOhOQOdoymLFu8MJw+SeoktVHiaBFEiXyfTcNZa2fR6KaF5Wi4ozqQaFrvOZyO2LgNg7aMVQSuTvAvGJSgEut63RE5o+bGU6aJ1Q8J7xjmDzSBsyInylwqTp+VNvwRTnFhvUvEBJwu7fQxRQS3GBZc6jokQ51G3EAL3q/HmP6UuxJn7n/uuzU5XQfSXEVIXzbZSDh8PT2nUCn4EsrFK4KjMdFsmSjRLpluY5Sa9mKaPDFnltmctZQEKs/XxiH3mOBvJg8y87LnxDbIFQqp9wCsyzF1lD4o/6RCWBr/KPEVzJfc+ZHDhR3uN7RUwApcRKOavzn7TQFgcCX5AGKt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 02:31:41AM +0800, Kairui Song via B4 Relay wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> A folio can stay in the swap cache after zswap_store() has stored it,
> when a swapin fault gets a reference on it before reclaim can remove it.
> do_swap_page() maps an exclusive folio writable and, for a read fault,
> keeps it in the swap cache, so it can be modified and swapped out again
> to the same slot. zswap_store() handles this, it replaces the old entry,
> or drops it if the store fails or zswap got disabled, "otherwise,
> writeback could overwrite the new data in the swapfile".
> 
> swap_writeout() does not get as far as zswap_store() if the folio is
> zero-filled now. It only sets the zero flag of the slot, and the zswap
> entry with the previous contents stays in the tree and on the LRU:
> 
>   reclaim            fault              zswap shrinker
>   zswap_store(D1)
>                      swap cache hit,
>                      map, write zeroes
>   swap_writeout()
>     zero flag set
>   folio reclaimed
>                                         zswap_writeback_entry()
>                                           swap_cache_alloc_folio()
>                                           decompress D1, uptodate
>                      swap cache hit:
>                      maps D1
> 
> Swapin looks at the zero flag first, but only when it has to read the
> folio. The folio that zswap writeback leaves in the swap cache is up to
> date as far as anybody can tell, so the process gets its old data back
> instead of the zeroes it has written, until that folio is reclaimed.
> 
> Invalidate the zswap entries in the zero-filled case as well. The folio
> is locked and in the swap cache, which keeps zswap writeback away.
> 
> Fixes: 0ca0c24e3211 ("mm: store zero pages to be swapped out in a bitmap")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> [kasong@tencent.com: fix zswap_invalidate() arguments]
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

