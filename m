Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B01FFCDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 11:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5FB6B008C; Wed, 24 Jun 2026 07:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967746B0092; Wed, 24 Jun 2026 07:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8556F6B0093; Wed, 24 Jun 2026 07:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55BDB6B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:55:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB9D0167043
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:55:27 +0000 (UTC)
X-FDA: 84914651094.16.401C3F7
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id E38B540007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:55:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rWiFlsav;
	spf=pass (imf17.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782302126;
	b=G5sxJNH5/7VPRkV3aDDvt74B01YQ0kY6OMhzlmEe3Ej+tuCHe1JbYd7E3XjT+/Q/EPbuM9
	o5BVwkKYd4uCA+3p8hHUrAUkY+hMKnl8iGaa75mg9QZOjKd5j2/kyVpxtpyvUG+SE71AeL
	x5lfEOg966Da2zS9DtXRqN5jMfg6J3U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782302125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFU8MyOIrfhmG7QxZLchLSQCDUz4MOf5up+HUhjl+OU=;
	b=eZV4obudslfjsi1TeCutot0Ts/KBb7jYVWkyklBrj2gdERG/TGQiZleaspMyUqqbrhfgSR
	lNWdt/OVa/Fd620+N4idkyeFw8+v5sqsp7vSCytWD9mGZklF5mbkmSQUWSo6MVuaSVKrID
	sTZGC+kDkbmpq4f6cEwzN9wsrDz8CiI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rWiFlsav;
	spf=pass (imf17.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84236f9b638so489636b3a.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782302125; x=1782906925; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lFU8MyOIrfhmG7QxZLchLSQCDUz4MOf5up+HUhjl+OU=;
        b=rWiFlsavKJ+x8T/WWkV7xAcdtO2+w0HoHGB9wU74ZwnVBqLqAoWaRTbhFdT9dov9WB
         G6OdxUDuv5oZHBje+CB/a96LkTUIuZhn4DOllXjj0VKcnFdF1Bn8dGidYVcPr3X1rmB5
         ZKJ6gG508nnS71mDU/QfYSxg/fRAE9Vn4eWbfVkt3ZKhrl/PnyDFcGcrqi3YI/Ct078L
         Jgzz641BgReMtFdHRP2wWL0A0+uWtwMFnPlctnUbVSniH3icnE9sArqaYnNKiKX0eZv2
         ELVaYQ/WvRup8xe1NCe5Ce5CbIc69jaVUu4gm7+ge+S+S4Tb+epK2J/CzYwsh4+yyJY+
         yymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782302125; x=1782906925;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lFU8MyOIrfhmG7QxZLchLSQCDUz4MOf5up+HUhjl+OU=;
        b=AYTODeIc+KkhRGoo7GQg/rsJRHN0CaH/ncCiPwaVBPGVoEwIDbk66KTZpg6GlfTxba
         tHRL/TELst6iOP7grAPPIKGKUYl+boBfODql2v4O4I4hcxHZ+wzxN2MlZKW90G/6DyAq
         EsPgBMpS/ycceGxvdU3x5Wu0AjRoNUFq55oMOYayyulHqlR0hp/OO5d8t+XGBP0cznNG
         1MwXn9mMixrHAN8qDdTGvvywehOABeonGVfKlf/O/RKds76SL/4NOLeUzt+tYAIY360E
         s2KmKVaHj5R8+tAX1RT0WkrYvYg5Bf2BiJG5WQw/4SfF8WCwFf5os8yD9AOl5O2BVkD9
         tYmw==
X-Forwarded-Encrypted: i=1; AFNElJ8ZGGU+70LxIqbI9OjR46S4HJDk0CCMMioU7lR4muv00NlL8gW6rhKbKPpGY0C12OFps+UngxyB3Q==@kvack.org
X-Gm-Message-State: AOJu0YxbYM98oT0uMP6owXGmKEo2T1JHckBS8zJiL+Ugy59RvbpFEnVe
	ucFGPitNs6kQP1DNrQ3jcGFrbfLzTLh1RRPJiwAxr7PL9UExJ9Au5WmSgMOnlQ==
X-Gm-Gg: AfdE7ckSyYvbulhLbxqsYa6C3ewxctASfmRBQgFQ4Ey1bD/D3WZiSjfzfmcTlgf5TGY
	OfyHh8X2i2FRRpHsO7WSfN3hzPJPlTcI2paxc1nbwMMzkozR2hARazCwybsK2zXbHg/fzRrfQ/Y
	q42x1t8uc7IQel6CAg9opB3MsC6TyCPZp9KC8FkA2EWobZ68a8AE97qnBvyoEp/3wxvj4w2NylV
	m4N99ZsLBio9jVy7oxK/WhVyE8SDVSRRxZliG9781XmULzVdNwLHCGV1gis2B5zY/q84wSFhQze
	YWwgBEf8Y0xhVYnDGm3MUAhC3rDcxmmFQklxSCEuvFLe8o6+JB1G6ajMhxHffLlWQro9zm5P0Z0
	wE9sfZKfYTe/jaca6amvboNoPSvAW/CG4dhtrmHD/kAAFfNtZ5VIV24WegIBOszsJyptTLGsEIf
	trtH66LJYPm7qRrLA9tRDQ2q6uq31aVCAd
X-Received: by 2002:a05:6a00:179c:b0:845:344f:eee9 with SMTP id d2e1a72fcca58-845a26dbf63mr4128286b3a.1.1782302124802;
        Wed, 24 Jun 2026 04:55:24 -0700 (PDT)
Received: from [10.125.192.89] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a40d23ccsm2563857b3a.36.2026.06.24.04.55.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 04:55:24 -0700 (PDT)
Message-ID: <0916e673-861f-b472-7417-afbffbcc98ad@gmail.com>
Date: Wed, 24 Jun 2026 19:55:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v4 2/5] mm/zswap: Factor writeback loop out of
 shrink_worker()
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
 <20260618044857.69439-3-jiahao.kernel@gmail.com>
 <ajnGTt8tkbAWX8Oc@google.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <ajnGTt8tkbAWX8Oc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pattej8hs5aakn9csgkjb6n6yub1owok
X-Rspam-User: 
X-Rspamd-Queue-Id: E38B540007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782302125-336872
X-HE-Meta: U2FsdGVkX1/Gkd50F1XjexeZJZOqoB6pHyUGnctQbmR3XvK1DqBfvA/8V4T5KA37uIy0VkVbRbcq4+5evtDrNnrD/aJPAzJROWdAcSpPTWJmg9CXK2NdC8OsXjnVgbkTkW1y5rWiiqZrHt0hg0gdW5G3Bz96QNS4Q6Nc5qANEZBCJeA2TZGuXisPnrcngZKMegfZKIH2HE6Y08XCAyAIgGbmhekXgviGRqRhY2+fr3p04qmi5Zg/ikvgnsUwzeki63ZNQGeAvBEaixSF2QDxJTZjUngHb3u4CQKYnBHrWLpgTtSYaPoVms97z7S195TZ+N13NWExi43X0b7fdnjb9IpI13guIIWe5jGgwC3OzxP0om1Jf/tkf5wxjiJANjDOaqqjhGeUeB8cWXt3e/M4YROJDb6nRufq3gQo2nVGkTGfvwahDG7vwgWaTckFdW9bx4DWwYyfpVhq153M4JtRIVfEX4+E8EiLwKxCVZQp4MAXYcgkpiDWzKuMApuFXFdP63QsFFDrpGCCsWMy8BZ1WSd6L3vqxSdAV9zsklnXMptZF4t55qjiChx2i9sNiulC0MI9NmKdvs5LYrbqL4PwuGYIjonrn3vo66a4TzuRZAvKTpqfoS2zk/a8BGJXe14Dv67jR40fNtn4kWc6BSyNutYoOcoL8fdNPvg38tlflkfzSWbwsV+q14Q63BEoAwxXDRDHcTmVrL9fDynwLwyWQVJrFyjDhSJUtgt/NSJO2LQv/mHPvmIcvvSm1OQTyhYuQEnEvOs6N1IorRGhJppznoDwaP7ZKsg8cAwqtU6NwQHUHHc6sYAW+utm7BnPKtsjJRoknsdWzuC48x5SQEFPeRpYswdunWlonC/T7rMYXxoz9vTgg2QMyOjZQqbDWvCNBbavE6BOJT6G8cbo0ZYamsgip8db2x+XyAswO8dscwxa0UtNXdZ1JmZnaMopmSNVqQp+vi64J3bB5EOxNFd
 LTbbKB3v
 owXwBBjff4MCPS8nRCBiXBIPyefVd0TPzKupVVsNCej89/HJ0j6riisj+86fS685YkukYe6amIISKkCBFB67bTY6Qj5XsFiW6755/f/voZyafxkhOhneGjAj5FpzxSiEvJKDhJNyH/fpAkewqaVd0G1HDfn2615TmVOL9YM/JovJSGFYPNySI3XZ2cAJDV/3G8cLZcOT2LIx74PgyB0rssCddMKapLvYyulWrunLjFkbOe6QuBQGQ+TlcC+Yu3eaJkCxLsAYfaK0NhGhHC1ikOpUC4AuJRjH12uY1BqYxNMHF+iJxQl/tlDfxdwWzyZk4f99EF+djViH8wKYiVDWOSd6UOZ+o4sptLcEaQqORXNzI6ffVE6aXjRmwEXzGNPljHs0/I8FIKvhz0asaD81qogidv7WVSD1Lx7S7kqXg9ojQYwz+FlFDxeQWr3xHL1NoLIKmKPpCfl4XqfWoRaA6cDSzr7m5a6rpXAr+z1B3veyWHoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/23 07:36, Yosry Ahmed wrote:
>> +/*
>> + * Walk the memcg tree and write back zswap pages until the
>> + * (lower_pages, upper_pages) window closes, or abort encounter
>> + * MAX_RECLAIM_RETRIES times of the following conditions:
>> + * - No writeback-candidate memcgs found in a memcg tree walk.
>> + * - Shrinking a writeback-candidate memcg failed.
>> + *
>> + * For shrink_worker(), it passes lower=thr and upper=zswap_total_pages().
>> + * The @upper limit is refreshed in each iteration by re-evaluating
>> + * zswap_total_pages(), and the window closes once the total falls
>> + * below the threshold.
> 
> This is the wrong abstraction level, and it's obvious by the fact that
> the function calls zswap_total_pages() again to recalcualte
> 'upper_pages'. It gets much worse in the next patch as well.
> 
> The lower_pages and upper_pages thing is also unnecessarily hard to
> follow.
> 
> The core of the reuse here is the retry logic. So maybe keep the memcg
> iteration in the callers, and define a function that takes in one memcg
> and reclaims one batch from it? failures and attempts can be passed into
> the function to maintain the state across scans of different memcgs,
> like zswap_shrink_walk_arg?
> 
> WDYT?


Perhaps something like this?

struct zswap_shrink_state {
     int attempts;
     int failures;
     bool stop;
};

static bool zswap_shrink_no_candidate(struct zswap_shrink_state *s)
{
     if (!s->attempts && ++s->failures == MAX_RECLAIM_RETRIES)
         return true;

     s->attempts = 0;
     return false;
}

static long zswap_shrink_one(struct mem_cgroup *memcg,
                  struct zswap_shrink_state *s)
{
     long shrunk;

     shrunk = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
     if (shrunk == -ENOENT)
         return 0;

     s->attempts++;
     if (shrunk <= 0 && ++s->failures == MAX_RECLAIM_RETRIES)
         s->stop = true;

     return shrunk;
}

static void shrink_worker(struct work_struct *w)
{
     struct zswap_shrink_state s = {};
     unsigned long thr;

     /* Reclaim down to the accept threshold */
     thr = zswap_accept_thr_pages();

     while (zswap_total_pages() > thr) {
         struct mem_cgroup *memcg;

         cond_resched();

         memcg = zswap_iter_global();
         if (!memcg) {
             if (zswap_shrink_no_candidate(&s))
                 break;
             continue;
         }

         zswap_shrink_one(memcg, &s);
         /* Drop the extra reference taken by the iterator. */
         mem_cgroup_put(memcg);
         if (s.stop)
             break;
     }
}

We could also fold the logic of zswap_shrink_no_candidate() into 
zswap_shrink_one(), but adding a !memcg check inside zswap_shrink_one() 
feels a bit awkward.

WDYT?

Thanks,
Hao

