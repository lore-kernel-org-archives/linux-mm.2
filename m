Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 266F4CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:28:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9EC6B00A7; Thu, 25 Jun 2026 07:28:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189BF6B00A9; Thu, 25 Jun 2026 07:28:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078E56B00AC; Thu, 25 Jun 2026 07:28:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE5156B00A7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:28:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 555D11C32CD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:28:19 +0000 (UTC)
X-FDA: 84918211518.19.58C9324
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7C90D1C0003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:28:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qcB+pTle;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782386897;
	b=gA/XMGGyz8IpZwl7owQY2MaPwiYXvviyiyx6kpQG4ZEYp0mSSHcuffgSkrgmMufF5B9mOJ
	3+AGHArLfWFh79M0eAPHhSwnlOKonopTUKzWgofh4L0GEzKpK9AreLFNUi7j1UwCORWFxG
	/2dTPaEGOA1exge/PpigUTi6B5BW3AA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782386897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AizybT0CQDOCLg4ll/0xAnza6/lwZnP0ZIiS3UphQeI=;
	b=1281ncRVTUIYvkNAo2romAY6/EnAZW3WtCxCnf0sW2OJVxpZBk3ZaP8U7tmmCpoN18GSmv
	zSURkpbvfHeJWWYLZmf7zQplDLoxwL+sicA7lY6tdQ5bD5qIOhC6ZGxlIqmoXcxN3PC3LI
	BS3npB6ycdYxwi46gP+yhTKAZzLDfOU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qcB+pTle;
	spf=pass (imf18.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2c7f123b1acso13533515ad.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386896; x=1782991696; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AizybT0CQDOCLg4ll/0xAnza6/lwZnP0ZIiS3UphQeI=;
        b=qcB+pTlepaXW7rp/onNq1B9dFwPWQDPdpHJpuTXHUhZ340QyEFVzilETrzM55/lulZ
         0yXDVpLGJUMWxlp/3zNVXFdeKlj6zf5UWfAMwaIkUpKnOzXdSQVlGvpk9OTB2oi0kC6t
         NVFxdExDXPVaEHJ+EQYzM8bMAmjGy5gFwOO1tPGxE+x0XrqfPYikYmNPjnCXDVLnjJMj
         +q7SMUetjEVpV/pJ+OvGA2j9zldciI32l77FhFys8fVdwwKkIhsthb2e1KMNZCv4IEdg
         pDg0CUTT+0N25UZz/mC7FxfFwSaohn3DJkN9Oujh5AJkVYgZwLiiLb4uWteqic1PIJCi
         nW1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386896; x=1782991696;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AizybT0CQDOCLg4ll/0xAnza6/lwZnP0ZIiS3UphQeI=;
        b=po+JgnE2UFGWH/ldzzSsSRYEw9v2EjRAs0YAgDnj1fmOcdycaMToPAegr3l/0gqvtl
         DoQLatQwyD+Fq4zjIE5MRDArmQA3wyTkAoAcuALiw/71pcRFsww40q288dNvmSfh+nbO
         IUSBKuDdNG6fFfT4CK0AC3r0RzBmwV+vnd/++YhIIKjxqAiGLwpDhUNlxcVNWcmTpMQM
         8cAyh2NOp0fOO9MnxmYQbF9367GHXGFkqoSwaX0OyVxvCUfXdmHt1o25tkJFrx2Vbjk/
         rwRdnJ5qrE8yin+AyVX48GM2xCHL8fzxyKEcJdzXZOPrMyeGkB1jmR+0kjWw+jUVtPa5
         fuzg==
X-Forwarded-Encrypted: i=1; AHgh+RrU2Te4HX5G0O8RIZ49zwC3oC6XYdUVDQSmGNMcTI8DdGJlFlZnDBccoKcYVxRUqI1Z/ifKfEJaOw==@kvack.org
X-Gm-Message-State: AOJu0Yy+jJkxFgcbZPQ4vyBHtdoy9ZAAXZChbX+RaYFpIW39GU8soTau
	NZX62atpaXLQ681wAbWoul2lclSFKKbOMnOIjQJ+SdIeODdNCqNKmU5A
X-Gm-Gg: AfdE7cnfbLmar5EeF4M0xtszjsEWl73F6sR2OZzb5uSMI/2iqFbWzWHAvHqhhPpThm4
	IFGojOMqjbdi7tLDAmN/7/EOZMJ/qvrG85I2JyW3MYBBc7LeTJO44i3qMm/HA7fcB7awI6n7+JZ
	DbAqUe5ax9BxKlhupZYlBiBmi5s9jU5waeSDryEY51UzbOZofrL7FX6s5qZy4Ooqs9rnGrcGs3E
	kUhX2fEz9TA/Qkn1jCXNqY2MVMXUfW3dLMlLwER0cqO80ZutG5HlFM2i2v+9ESPJZINgXJfF/ym
	bLH95qgZW2wU9jFwmZYqcMEXj1KlYAfjqOV/miylfyN89zRTFDM/qnHGBqPDc3grDJdSbm5CAkg
	tEdCC+qhQ8KrYRoLp6Ci8fpVlnofgq72bJ8CvGuzfL6w7Y2kEwG0p3qrvGurmieo2WUQ5Cli6bR
	8Z8yl0g2v1sWcNfbru1fIrv6A31pgKO8zlW5MGNc+0tyU=
X-Received: by 2002:a17:903:2b0e:b0:2ba:3e2f:6883 with SMTP id d9443c01a7336-2c7fc6f396amr21714615ad.19.1782386896284;
        Thu, 25 Jun 2026 04:28:16 -0700 (PDT)
Received: from [10.125.192.89] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f5afb17fsm18380775ad.26.2026.06.25.04.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 04:28:15 -0700 (PDT)
Message-ID: <91297bc0-268c-e9c2-57ae-6066eee5df2f@gmail.com>
Date: Thu, 25 Jun 2026 19:28:06 +0800
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
 <0916e673-861f-b472-7417-afbffbcc98ad@gmail.com>
 <CAO9r8zPSZLaqLXw87V3q4tZa8WD7xCympKqfLMLB+o-++GksJQ@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAO9r8zPSZLaqLXw87V3q4tZa8WD7xCympKqfLMLB+o-++GksJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gju76a5kfkiyeay5wtgoobhy7r66q976
X-Rspamd-Queue-Id: 7C90D1C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782386897-674880
X-HE-Meta: U2FsdGVkX1/mQMkH4pwKftFroloXOqVxbgfZOKYs3N/slqG+T7j0tM7JheeHpfJwI6Prj8EJ6LTEYL14UivKwbR8XgSxjC9kwNNgrlMo1MRmZ7OsKdEbzZd6PFl/p5ElNfP2gv7Nhp+DhHUf0IwtKyKInIrzPdIqFb+RFziQNBxyLph15v4FK2WEWWn6uf+rNvun1mtVQ5X+NOghvun1uwvvS9Ztwy4Lnttm8ENFXe1rrZHoUubi/qNlYSN+vKPMO45/4otOJ4ZsHQAj03ju+vvzX5zpnhHQw1rTRiK8u2U4A10fzZ4v9Ym3IQLXNgeIfqvpI8Gno1Mr7Dh3+7XZvttpw+NcUpJepUS4jjClZ53Zbvtu4HJFzHzRsaXP9r+U7699hyu8ZP8xml2jM2KH9fnTKyMx8nxeJEvZQMpQFHqIRCvAXDWtgep/XMiyjjWuG7PBd+9xvoIsRxtKd8SDh3tFAaaV8uRYaXBidDyvD1p60NjKsJh1fTGmTjEd21SiMRedMjVsj+WD4Q2ezV+eG0TLpZULLb1NqLjVN4e/VUUgK5lVnxdi0jHaVC48EgO12f7xOeX3xo/csJVivrXab8HekR/1aTBtQUHQcNx1EOdypcCHmzAbX6a2Mpa8V87mQq/XpldiEjmijq9wJ9BfCUKqvhEQ2Usegvm7G5YlmYQ80HfsWCdgkphNzHjBwVvSAHY7E0WSOc4bUY+V4ng/ws0bad1pQUG7WamVKN5/9e+nt9VNeMEpfYy1sNdlzxwD1iZY7hMYWeeCjX2voUzUAsS/rBNnE9uB1aice0uNeW/qdYPEd8vxAeu98R5BBzk/qeHGR9OixyEEeg+l7YR6sNQkliK46IgItICH+p45MZ9rQibr47Es2IU8htqCxf+3uZJEELIZrAc6VKQN/8IjAYEavciSTKRfCNAnUbh1riqFWRPEBQ2a/IGCqCH7h+rGX2C1wyTf42kaq+CQveK
 YWKbJ7qp
 uRCV2W8GibWEj8HOmoe6LwEkaddbMF2q+kvC4vkkxq9gbwAUmjEhYyOpVHaYeH1DxPhrSB97RHl8qylgwIXnJr9vqlkzORI/4zYoQWMfwCUDZvgx1Jt6LBgGQGi3BwdoUK2UUqWsYZCgmSsf2xy56q0DqzUNexQkgYcBk2P+iXmPICjDnJGMcNrwEmrUr4hSljms913MMVw3WBS4sZ9fPzqQCrbwjPxMSDwFlORb/A0oAdhTmMszTlHYKW0nCv5CTioQNYZonEVi3Fgb5U6I90xRxwR3F4komIf/GxGtSUj13OcdYUjZIRmroDaeSmK80OCiXChmsxKoxeDfaw/sDhYtpwCltl0VCTLZOWfVWuPMKnG7MsinuIxuK0TGWYW67WCyxzk9qUC2Ys1S2Zip95BlxcTxa+6VJhTu5Ykj5w4lEef3k2+CDLI82cvLym4A99dQEn5pus+bJb+AUpGBvOtIaHY3+4YTWe4g681JrsCSP770B96Vdha79L+jW7zMc/q8WnW1UYJ0UcYgJtYN+AYPOaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/25 01:00, Yosry Ahmed wrote:
> On Wed, Jun 24, 2026 at 4:55 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/6/23 07:36, Yosry Ahmed wrote:

>>
>>
>> Perhaps something like this?
>>
>> struct zswap_shrink_state {
>>       int attempts;
>>       int failures;
>>       bool stop;
>> };
>>
>> static bool zswap_shrink_no_candidate(struct zswap_shrink_state *s)
>> {
>>       if (!s->attempts && ++s->failures == MAX_RECLAIM_RETRIES)
>>           return true;
>>
>>       s->attempts = 0;
>>       return false;
>> }
>>
>> static long zswap_shrink_one(struct mem_cgroup *memcg,
>>                    struct zswap_shrink_state *s)
>> {
>>       long shrunk;
>>
>>       shrunk = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
>>       if (shrunk == -ENOENT)
>>           return 0;
>>
>>       s->attempts++;
>>       if (shrunk <= 0 && ++s->failures == MAX_RECLAIM_RETRIES)
>>           s->stop = true;
> 
> Do we need 'stop' or can we just return a value here to indicate that
> we should stop (e.g. -EBUSY)?
> 

Perhaps we could return -EAGAIN instead of -EBUSY? This would align with 
the semantics of the memory.reclaim interface, which returns -EAGAIN 
when it reclaims fewer bytes than requested.


>>
>>       return shrunk;
>> }
>>
>> static void shrink_worker(struct work_struct *w)
>> {
>>       struct zswap_shrink_state s = {};
>>       unsigned long thr;
>>
>>       /* Reclaim down to the accept threshold */
>>       thr = zswap_accept_thr_pages();
>>
>>       while (zswap_total_pages() > thr) {
>>           struct mem_cgroup *memcg;
>>
>>           cond_resched();
>>
>>           memcg = zswap_iter_global();
>>           if (!memcg) {
>>               if (zswap_shrink_no_candidate(&s))
>>                   break;
>>               continue;
>>           }
>>
>>           zswap_shrink_one(memcg, &s);
>>           /* Drop the extra reference taken by the iterator. */
>>           mem_cgroup_put(memcg);
>>           if (s.stop)
>>               break;
>>       }
>> }

> 
> I think splitting the shrink/retry logic over 2 functions makes it
> more difficult to follow, so yeah I think fold
> zswap_shrink_no_candidate() into zswap_shrink_one(). Then the callers
> only need to iterate memcgs (depending on the context) and call
> zswap_shrink_one() for each of them.

So, something like this?

/* Track progress of a memcg-tree writeback walk. */
struct zswap_shrink_state {
     int attempts;
     int failures;
};

/*
  * Take one step of a memcg-tree writeback walk driven by the caller's
  * iterator, and fold the result into @s, the retry bookkeeping shared
  * across steps. @memcg is the iterator's current memcg, or NULL once
  * it has wrapped around after a full pass over the tree.
  *
  * The function returns -EAGAIN to signal the caller to abort the walk
  * after encountering the following conditions MAX_RECLAIM_RETRIES times:
  * - No writeback-candidate memcgs were found in a memcg tree walk.
  * - Shrinking a writeback-candidate memcg failed.
  *
  * Return: The number of compressed bytes written back (>= 0), or -EAGAIN
  * once the retry budget is exhausted and the caller should abort the walk.
  */
static long zswap_shrink_one(struct mem_cgroup *memcg,
                  struct zswap_shrink_state *s)
{
     long shrunk;

     /*
      * If the iterator has completed a full pass, update the shrink state
      * and check whether we should keep going.
      */
     if (!memcg) {
         /*
          * Continue shrinking without incrementing failures if we found
          * candidate memcgs in the last tree walk.
          */
         if (!s->attempts && ++s->failures == MAX_RECLAIM_RETRIES)
             return -EAGAIN;
         s->attempts = 0;
         return 0;
     }

     shrunk = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);

     /*
      * There are no writeback-candidate pages in the memcg. This is not an
      * issue as long as we can find another memcg with pages in zswap. Skip
      * this without incrementing attempts and failures.
      */
     if (shrunk == -ENOENT)
         return 0;
     s->attempts++;

     if (shrunk <= 0 && ++s->failures == MAX_RECLAIM_RETRIES)
         return -EAGAIN;

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
         long ret;

         cond_resched();

         memcg = zswap_iter_global();
         ret = zswap_shrink_one(memcg, &s);
         /* drop the extra reference taken by zswap_iter_global() */
         mem_cgroup_put(memcg);
         if (ret == -EAGAIN)
             break;
     }
}

