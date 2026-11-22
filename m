Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31E5C606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 13:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mwoCoFKK
Received: by kanga.kvack.org (Postfix)
	id 3A17F6B05B1; Sun, 22 Nov 2026 08:14:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37A256B05B3; Sun, 22 Nov 2026 08:14:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 269E16B05B4; Sun, 22 Nov 2026 08:14:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB25A6B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:14:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C0CB1406D7
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:14:58 +0000 (UTC)
X-FDA: 85462800276.15.BDDA561
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9B39C16000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:14:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mwoCoFKK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795353296;
	b=KtkRrJG3yIrWv/QaTdBMOBZ7GwLKCUd8cC5uxobmQwrF/q3nNCMEuCpJeWwlNrXJgBYnH4
	tHXiDRUGggFw8zDDzShnJH68nh0j/HGGBePWuOr4GFbbGPK/uUoVHUu/L0cy5g0fegkwYb
	NM1VejJZBe5TUZxRnCimMiFJo8P7eMM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795353296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8hD87ixJaXl21lUSGIciEwnoJt3nWlHx7X6q/vGOsOE=;
	b=fBbpi5Ni0hxEBBL5EXgTD3mWHvO7k4J4BmrmHfD6Lf29KuxQB24VppxAvvL5Fi8CukL5ZI
	2RMoNeYguQdvd4khfqjJuaT8vJTaGR1FuKe6Wefw4GgqHf1wU+BxoOaQzwx5lyCdT1iyH9
	WYR8hATpF+QpMVX23P/j3tHUxZXDfms=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mwoCoFKK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1b244fb7fffso2283415c88.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 05:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795353295; x=1795958095; darn=kvack.org;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8hD87ixJaXl21lUSGIciEwnoJt3nWlHx7X6q/vGOsOE=;
        b=mwoCoFKKwTBDq9lS76M+ErkQ5ZFWa/MLq0pb13EDYl4ZutvRRmkU/jep9x4bKblUBc
         ELRcnFD3YPKcXUmaVY7dwQn/TPtrHcchiMS22ZLXni/C0pwRzdNyHiKjkssZRsKyghoj
         qAc3Rf7aNJSoqYiyCxoKxgLvMKjYTG+IRBKxLpCQQ2NO0HJmvR7aX9/vGVPkubx/r8B0
         1HzzXC7a7nye+dIBDQVyayof+99ZWzaJKwwL3I9H0xN8E0Wtf3AIN8QOie/q2vJoPXUF
         6o7gXMMWazaMcsxOR2bYJCcU07mmdbmWZAt7S7WGaGNi3skS+vrZS2zcSPK/MJuBVJ+z
         ZU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795353295; x=1795958095;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8hD87ixJaXl21lUSGIciEwnoJt3nWlHx7X6q/vGOsOE=;
        b=14Bo7CbL8X+HDj21UplWzlTWUI5dASqQj0C3uFAQeAX7aG9SEiW14+0SXrexLej2A8
         CN6T326i416usTrLFTa3sn3mSaR3ErmD6WUqcWOJCxsMR2bZDZkq2lSOkkUfJTcSoDCK
         EUxSg9zE27QuBVrLdkCM6v0IJDeqC4WMvrVMmIOfrfLju7RE5+3QOBulQfHUoF77olBG
         XgqKdZFkJgYxKAwb1V0T/jmdJea/+78Z5Zei2TgkrLjrQOBCpf19madGt8ETGz5yJAU9
         XTrld2M7iP88u7zqjtppUzMH53i12rg+1bhzti9gaItGPq075iUvyjf18jU5qCvYppef
         oRoA==
X-Gm-Message-State: APuU4Z+yiPCKY8TXxJvaTwFmQABq/Yi47TLBYMSpqqp42T7AGABq1VGz
	dv1qf76+n6SovbqmUj5NHErtl3efaX9f7H6c7gWgJoy+MBabeYa3NwwF
X-Gm-Gg: AZFdTZfFeIUTPbv9BE8RhIxe5Fxp/eBYrDTz1imWaKGCAhgBhpbxWheKRqphHbvJphM
	pEbcuqzlf9czYk2tw+yd2bT1sMLf1gBw/kjpUfjDUHbXaTIsqME3/sh2fMlbeqCNOTH8gfEhB55
	MVL1MdTxLWp+yj9VBDUzGWYMOPeTuD4T+G+9HGUogegy1oyv4ifO3Mtvlvgzh0CQSQYv7rDx0vZ
	IdRGjBcPn5ihUlJQntIB55dyUnc9Nvlc/7RNzlS16J9xKMdjRMax3+YfisyzJNjozXtaXSuxBls
	I7MfPtts0LVmRcW6MOdJB9MBQ9AdniCke1k7JtW47I09BhG5z+y8Gork8FfXfOHcOTJY9g5WCeL
	9OzmDU9LlVLXs42rCQZMxDPI72nbKnT87sQ+qPayQYQIN5ku8YNO8pNL4hR2kP90pQiUAnYhVNK
	A+/hIiTDLEEw3QBg9380b9/vFjykKLGadFV9xr82DVn2/LPZU58Cv8V1mtJBjjtAj/tNlklu0d0
	sh5oVb+vkKlESE1e6yyWOVzG/nmCNkI5I1oykO89Nn5VcKER4FEBjoS+QOW8RWCAkOGRgSNhPaF
	ZomfLfmlvHMdEt41rZ6h8nUB5eZ1V96sttypABXqYH6JHdOhhusQBLiNX3Y2EwoJYii9
X-Received: by 2002:a05:701b:2215:b0:1b2:42db:8a54 with SMTP id a92af1059eb24-1b5568b3154mr8671867c88.23.1795353295194;
        Sun, 22 Nov 2026 05:14:55 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b55681301asm20797941c88.8.2026.11.22.05.14.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 05:14:54 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregory Price <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	SJ Park <sj@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Yu Zhao <yuzhao@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	Zicheng Wang <wangzicheng@honor.com>,
	Chen Ridong <chenridong@xiaomi.com>,
	Tal Zussman <tz2294@columbia.edu>,
	Kairui Song <ryncsn@gmail.com>,
	Xiang Liu <liuxiang.277@bytedance.com>,
	Ehab Ababneh <ehab.ababneh@intel.com>,
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Hui Zhu <hui.zhu@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v5 03/17] mm/mglru: make generation page counters atomic
Date: Sun, 22 Nov 2026 21:14:27 +0800
Message-ID: <20261122131433.72335-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-3-9eee2fe97a2d@tencent.com>
Content-Type: text/plain; charset="utf-8"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B39C16000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: r3cgpsuenq3j11uu9xqr81gxgy8s9g1h
X-HE-Tag: 1795353296-438801
X-HE-Meta: U2FsdGVkX18UYoOsFehUli1LIMfjWvsJPP4vQw/h5Iur80kg/nOX0Rzex4TgbdBEKuh6uIX84uT2I1XCxj7hgQBMgSau/jV/gcyHsWG8kv2183sKCghV5qOti28DH1YDJmcrmg/YzuAqhdOk/lIk1kO0La2Vu6jqC1OiQdsiD0rvps5+RhC/8biT7YDS52pOnBh/7hE4JzBUJ1kn00Guc2EgEsPN0aPjbDAOFjaJnW+SJgDpr7VFpy/IzHQFOWTWgWKibcKebqisTyo2kgb+5BEh8EscZcIUE0WkcAqoNQ1NYFS0KqEjlnku9YYSBT7UHNeC7IV33bBkEgw+AkDZxy4xWqwjqD1nBu3FYWD0NQbHojfNqVLqg9vnxl1Dsuh2bR/K9xy7RM1K+fauqrZn8tZUKY2d5sFSGZx+wJO8twisAMEXmIShr54+vd+1mFLXABoHurkgnpu5NoeKKIa4cyDZf1DgExsNo4epCbVVfUC6Vpn1U1hilXxgxA1ay6RB2qDMOe/OG1wDsKnuceC/ruTYIVyU5zNXPzBWKE4uSRgVY7YYNR1JboCIva9yLXDTVGSwMml+b9bqONXs7SNuVyO5PVYB8R8ttsYNq6WPfrF08FjRybvW4Jw1i79ERCq1QMSGeIe+E8nB9yswgsXG9OiLFk/fnw45ZmnJYgVY0ezcNyqAfnPHbfNKnU8urI5/zpZOIn79og2dQW8Xxk+8yKaF7VLXOnsqBAuIMskW0phYyBtnVVGMNIMpy3C+a1kRFIGyEsZgB8l8cBdVhnBr9mJbV1bhF8cubSEyHNd/OD7i4BmTCrN8PFdLX0RnqYQHVSPb4rGZkEgFf6mKfF7DztpwsiT8js0yF9Uf4KcQYlmp9BnZrJkqDjsRuY9NFryIqvXNEQ5d61oT+3v9004wiXvu7pl96sQcIMvGrxSbm5YjiZL/F+kM3M9X01jF4RFOdyCMSks+e1XPEK09jp+
 VY5N1YRv
 cncjZoPNlxzpxXB3Zo2ugb4zhvRrsABUqNYAfl1cIbsduL37JPPW663KtM/lNq9MjUSqRGwxVCT1On0nS6tL4F0JIHyeWPb/ME/gbAhFCqTohDkRf1oX9uBbopBhoYxuM/1HQzlFuDYZfZMSYtNobAcXsyh3fDI8mFcNW4QP9ZAilwH5k+sOSnq6ZA/jxOn9iP2S9ZwzIb5kWQYXTCM3Oa08L1bAK88oNqwFbo7YOS5LpQK9nSu4QHtX7PvVahX+7SNBQ1ut2+B3Hys3oNc0IVwl7J+GnYcgUYfEhDs12Wuytcqknq7WZ5oQqZXOJJuTmxEifiDNXf+HhI7AmECNADyMmKLHVQ+x5j4rbDlcuDUXXPE0m5Kgku4ysNtVbYg9xp7JuTEfw6H0NO42FBSUccjzAXyrhWtM+5DLs/mdQjlg6msDvDv830ULsJOuw9r9oD5yejEGA8owroRNdJnCadBTQL1gpV0eYe69/0w4hDD4gYPUwuJEvl/BunrN1UEKdak7WQqofRkJoKscc2woXUZrWp7iMbEQclRLeUnTt4Y+azBqbFN7DSb39OnBDdB/m1VX0CkCdQPOAIqQ3wnsVYyaSn86Rrv8290NZpGmUddbbfCkly28mk6JJZ4JbV2G8OmwM8WQPpV/JDwJ7aGdkTb11JhnRRnNC4J1Uhz+fRHdL0mJJs7ehCwk+YX+jJbk/py1ipoKMwOrGZLr/l93z4iq+DawZQ+LjAYTLMOI4Rm81Jw587ZO14GhymLDzjvrZCdQqHg/5wj38Pvsv6to9f9Pf2SeYYVUxUTDUy3KsObPFXnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 05:03:35 +0800 Kairui Song <kasong@tencent.com> wrote:
> From: Kairui Song <kasong@tencent.com>
>
> No feature change, convert them to atomic so we can update them without
> holding the LRU lock. A temporary underflow is fine: readers clamp a
> negative value to zero, and the counters only need to be eventually
> consistent.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM,

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

> ---
>  include/linux/mm_inline.h |  6 ++----
>  include/linux/mmzone.h    |  2 +-
>  mm/vmscan.c               | 26 +++++++++++++-------------
>  mm/vmscan.h               |  2 +-
>  4 files changed, 17 insertions(+), 19 deletions(-)

