Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF33606A322
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UxKljUTN
Received: by kanga.kvack.org (Postfix)
	id D79A86B00EF; Thu, 29 Oct 2026 17:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D51CB6B05B1; Thu, 29 Oct 2026 17:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C671C6B05B3; Thu, 29 Oct 2026 17:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF756B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:07:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 377A8A056B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:07:00 +0000 (UTC)
X-FDA: 85376898600.10.C788582
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 56B8B18000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:06:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UxKljUTN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793308018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fb8kDJR3/eqMuwVk4mGcY8ktqHU/PCk1HgPlmWV1nBs=;
	b=NtK3T1mWEx9xb+nIltttahimKJ2wJ0VcsW5GmlbUuodgwUySvKjmq9pcX1pzPh8GMwfNtv
	GWXcvNWqIY0JMxSwhdgi9BXRvUWjA37qM9J17tPq8ApzFPtkwlwkpJRg9d7TydqsyUqTuD
	vd2yhYNHqW00K9TRWvqq5urz1JH3a9o=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UxKljUTN;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793308018;
	b=GcQHjDCqux3CG90I1DK0IywLK2rVe9YrzgbUhw4/8JCpKEuoQhBPWE5oi8YOI6U7NpyA8/
	6af9TElI26xXMSrRMZe/HO2OXC10HCgTNIOldCwNxa6LP9+RaD0+X5nCNMq8BkwD0Yokji
	9xRV9/3f5Tyhp6anLwxbemKPqV0lwnw=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e00eee27dso33499f8f.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:06:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793308017; cv=none;
        d=google.com; s=arc-20260327;
        b=ApzSzkWDJVOMf9MLiePuDUp3tYFqiqc6til066yphaeFGBKZL4WaWFvTPbFwV5lHFK
         vGinqKnFpwOyChlT8pKWfHC5PSNTQ2uUKg0/G61spMGZeb0V8vpDbpEFdUMGrugVdwwu
         ovi1llKD0Uf6GVG5f8WB3B/sLCFYqpkQNNqoWTfcA/k1/KMQfTaN33Z/+z2c/XGCcX9B
         nw0gCmBmktDf1yarvRXEzAnWVznqmTtL94tSeYFfK8ds2AG1ngw2VCe0LWHSEUWcMx2A
         LQHVTeZK9/Mr5Q3qfG3ZJfc9cqxGm5oEWYx8x9LRqmxwsS1eh2GP98f6i6SNtytYLq4G
         noqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fb8kDJR3/eqMuwVk4mGcY8ktqHU/PCk1HgPlmWV1nBs=;
        fh=2DIQCj0lfbX1cm3Ec/77Wf9arDFqe5K/VgT9yN4lOrA=;
        b=Cs/Tg424m9DFyKkql12RegzSfBsQ5h92NClv7eGz/2A7VSLgEYOY/bnSv2UouzXZrW
         s0sQLjmA6JwpOXMd6qM+HDwy7VSf6CzHgtkqiDFK4S/AY2uH/km+AaTwFpjgpFozUCE3
         yPcK6wEAWYK7YbV37by61NvdXwriiQQH3BH0TWbN8IRmeQYuF1vDg0xn3j0wOn23HRow
         up6bbPd0N8rNt9jOxzC1SDQ+K6v//d3ibXwGC4O3UX1tmbFxLIcRtXaL8U0vynpb2EzX
         2H9xDQ5w4WEAupX7fSMvUCuk0eR4CQpFV/1E1IMK1pGfsLjhXEA5jNtU7DEFrOHk/2Ss
         YM/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793308017; x=1793912817; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fb8kDJR3/eqMuwVk4mGcY8ktqHU/PCk1HgPlmWV1nBs=;
        b=UxKljUTNp08h+m+99YJFRocYQLEppHp9+tFnQfmyNznpfZowh2be9nD9AnWy5qTXR9
         GA/cf2cIyZ3G4ztbmj39UHS/k5eNMRuMArTgEvygXccC/3YGK2tXz9/LBUDBADz0+W4q
         3pc2s4xOCg3uK87mqoEW5WaXYfFUcipd7iHFbu6gxIYePlXtvfoN+hA8Y9/IoE4e1Q6v
         jmMAFXWrX78nQj/xIRLffT3XiPPMSIqj83O1d1u2VjEBm/UCTpK2m2uG88ed+gSh9q/H
         un/S8sGaNJd2M43UoY1afUEj0Q9DEomnz/E1HDwomSSY03n5lYOzM9+63qxqY0zjprUn
         qHlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793308017; x=1793912817;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fb8kDJR3/eqMuwVk4mGcY8ktqHU/PCk1HgPlmWV1nBs=;
        b=IszBOesNkdJhc3TvzKIkWKupeme9k3efqOP7fSbvJspba4bl3Hu6vZZbBgt58qjti9
         dOgsCtw6qFHS0rGeArapp/rtYgAYggoH89gT03fP2vrOWIFvYKRnFIlY5y0t3Icfwrva
         Gkz4zlQOIS7TV8fItjG48ceHIK33yfLWll6GhtlB59TqvUG85K81qE6P5F45VMA7l6Tc
         7tz3OBG/gkIKZUiuigwY9jIdKlx016dc3uO8hz4uDpuwHnARB9HD/NqRkA+AFkZotJbj
         PEC4wvKjPhdMDnHjF94xptA18tCUQ3s+DWnuJzPprell9qhbIPQ/xEQfu+zEdvHFvuVw
         fbMg==
X-Gm-Message-State: AFq9FYLtr3VH0kValk4cbi26iO2piYOjzJbwccSoB7ZDlL6TNWFdTxAM
	5moeVubxZ9cck5kfkZP3Iho8uGjDX72623lGS5eol3X5gRt2TpENpHzsch8mHQONyC1wFnvaE9u
	f7k+zLwHtoSszc+bV+Pb2LnN0JoaLAyE=
X-Gm-Gg: AYBFou3yRD77ucU/3kM+WEemZTtQ/9t3p9k0xxgPfqrWVA/u/cmXSaAsZcXdJSr7BAU
	CZFNyZMUMo4+vDMETmLE2NoB9I22SNH12la7HnRkxREjlkg3HEWRFxGEvt0vfJkZAEPe9JMowwP
	o2iBPH6wxuy9ADEMNzBOCjFBdHTaw7qC7uUUjF9LtWYHQD9BSK1tPnRVZCNxIWNdApYkCySP21H
	3WsLUI8bo61cGzfUllEJhbk7I7sfA6Er7D+HZZdbTHvQm6CUjdAFFZuqbgcXnCQeYCA25orRiRb
	K9Zz1dfY10H58LeepNYAqTElEwkrFoOHFeIfFei9yPxLmZd1L8+O1diNxUWU+AOcmYorTg1Mm84
	0HaWv3BcuMxN7Nn/StUZMI7R0g8ZXInkpcx+5F5+CdfV9p/8cTFNVw9mUac9dwA2RpZaSePBplP
	REuYts17zPcf7zpwH0kchAYG+CZ6DoP9I5FhfOc/uH+L6MMnjhQY/Y
X-Received: by 2002:a05:6000:4b18:b0:48e:6092:deb9 with SMTP id
 ffacd0b85a97d-48e6e2fa4e1mr1121429f8f.14.1793308016538; Thu, 29 Oct 2026
 14:06:56 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com> <20261030-swap-fixes-v1-1-73f73a59f2fc@tencent.com>
In-Reply-To: <20261030-swap-fixes-v1-1-73f73a59f2fc@tencent.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 29 Oct 2026 14:06:43 -0700
X-Gm-Features: AclHuK92wLeJ9w3J3At4Pw7sJv5ao2rkIqVVn5ak-RXKnx5xxdpjvkaqxTwN9aw
Message-ID: <CAKEwX=O+j5d874gW=ENZc7s4y2CGVKheQSK8VrfD1_eVK=6U=g@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/zswap: drop the stale zswap entry of a zero folio
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Usama Arif <usamaarif642@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 56B8B18000E
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: gggy5xrprt5e68ub3bu59tsewwhqrx6y
X-HE-Tag: 1793308018-766544
X-HE-Meta: U2FsdGVkX1+WkVSCFI/FzPD0I8blSXfn1lKeuBWnuOPUBA3lyiIcjTPhVR5Ct6dTbq/uIQd4eakPy83SAjiywpizKYaEPJeEXvpBWWxdh8tHUnNzTpf9mMrJHuNr9236f4O7MFDB4PnbTU0ldnyLuaLoVOMDRmSnsYlSYO5DnFN1EiaTWoTp4woyif9NBZe/AS26k3DJ9OUEgNYSFQfeZSEoCKVTESHEHcACzf1jd1yBj8IsNMouZsvgVU4TtooabUPMBhzl4IP8wXwSIaAGtokOXH1lUYxFD9ocMUEFkRgC1FqNZ3OPCRhlQOU3/HJGSafOSyR+lgfTwCOckAhE5fx27Gatbjn4K1hEgXq7kHnma/kzzTGxBkV1xwbL7day3dOww1iHzFIaZ2rvb88Xobs1HSAp5nUVbPjY3q2XXVwgEz9hesIsyvplYt45W2F7eWBydBXNU7Q30UY+toFTv9gQWDpUAhlgXQvWshDbd47QAsCx+W2WR/ZhE4ssIB8HhfPqV4FsvVtNBfei0G9lofPgPQox9tBA7c21LQcIvMy4BZA8Hgr/ipM7CtfTc6T5SfNPBfKCn/3SnRYL5paS764ns26kwlfdY45wQQ4cFzMzp5P87EQEKfxqZ5ObrUGLhWZSZuT1fzDHXBZznRaLrAlZ7z8G4oejFZolNub+/zwTNsLTJxKG5PbpvZsSmvzJ4e4VfngiAogiHMt4yRAiu4YwxzYiyA2NVSY+KzTRUfrDqm0SGDDTo5Nl467aqCLKt2haJ5Y7CmEVMP7dWFGiAtTfcpIaQuwfhilwvNUxX7yLet6DWUL5Uxr89dwc94uhqzRGJAnOEtdyhaALpvLXl8Upn09qk44Dd/Hkecr0PC6z8uqXXtAiYMn2itPLYVqJertaNyc/0oVPqnFp/R7LSRBIY/rjBv+w1zcXS6ZTrAsRg9yJfFNDcz4AnTQnUoYP/R7z6FhYGz7jOQussIa
 /aIYurh0
 1/9+I3TT1Do+LiaoWp91RsyrH+p9HWA+U86I0FqFtX2jd5H140Pc4ZOiyzI3IDwk3Trm5nXpdPCd+6l1zQO0Y6jIeo6Buq8qC2zOBKIaQzoQezCQgEcgcQWR4ViKOhMlxdj0K8eridKdjmSQEGGjHZ7WjwGik5t0fKzYzsV/E3I3ajLilu+ITDeWp76ROHJ5mlzVYEHc2CeWQg1uonD1lxVA9Qz4yZ7mTvHaAzfPMSDdoDdLZNDRxYF1QDgCExkZxj+EVGv7H435AkQJMK1gbdu8KCoNP5Gzj227j0T558ZlAvq0W/03vMDOTZyL+GkoUewKjEzGuySGRSpuV5qFVGOnjIzzCo6ZyA/yElZbriutB4HiMZfANPc12N7t5wf3G/F598bGZWkqWwmgRqkQEGU7EzFd7IvbG3I3i+G3pJfRayDwYJCGNLqMiHnQaWpbagbycE9Tnc4i0VzBx4wJ+a7XYxaXKrVbHqlBCAEwWLq+eM9ZFYVn3etTqkgkA7K5+UyF+wW51Pw17WpUB7ueMtMkr2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 11:32=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
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
> Fixes: 0ca0c24e3211 ("mm: store zero pages to be swapped out in a bitmap"=
)
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> [kasong@tencent.com: fix zswap_invalidate() arguments]
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

