Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0DD5C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA806B00A7; Tue, 30 Jun 2026 06:51:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91E26B00A9; Tue, 30 Jun 2026 06:51:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9828A6B00AB; Tue, 30 Jun 2026 06:51:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8006B00A7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:51:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C9AC1C69AF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:51:27 +0000 (UTC)
X-FDA: 84936262614.15.BFBAC63
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3EEB5180006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:51:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j0btUicU;
	spf=pass (imf16.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816685;
	b=ZmmKaFAD1tXTRsnCK2j3U8dN15DtgQjSCNAkOSlyFqphajHzsq4EXUWiNlI/ZLV19xcc7o
	c/MiBR1S4914sGQsZ/fS7MZMEtAAofrx0h3sJO8RZOgGySIyqKAUAvRu6yfYcJ2clVRgyK
	IwO1I9+wfjeFt1IzaKVZM8xTZ9FNoDI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zOCmAhk2QZilrROnFdYyZ9E7NHFNJQbLWBKSgKarjZM=;
	b=HJZlQdY4/7FQNsySjjL4Ni3tk5w96iQ79nbUAhdp1janWfzqxczeS/ZjS5EOg2zpYfodp8
	gn+T2mIk8dVfqfbJY99rnBubQBMWI0+qI3eu68gkVpQ1H7DNvOCnlZL/1Pk38vyZYcWfMQ
	ndPLilsVa637QI79Vzo4+T95BhWHwgo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j0btUicU;
	spf=pass (imf16.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c9b42be8feso25140895ad.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782816684; x=1783421484; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zOCmAhk2QZilrROnFdYyZ9E7NHFNJQbLWBKSgKarjZM=;
        b=j0btUicU1opylAOeoIDXIvGZxKNDhztH/hR4vQAosVJ2NufmVHz32RLsO+WaPa2Bc+
         MySOzMzvDsBKy/5tvMyK8yl4El731k9c/ElZY2BDYRd4fQ+TqxdHepIRzFClCYGBU9SE
         t7SQXlicEk4xaIgX4mVuKbdZZYBoGsWFYj+yjIUlaZl87Lm1xenLuq26FsBYMURYd7KZ
         bb88CXNZ+g6fS91z0TF/Be4doM9lozR22ChOsoMwRPmD27uUYn4X5zxssrhpTxOoVn0G
         e3NmmC33HA1QQ/iZI7ZTQnf/v8oZXokwzIsoCHiC0EPhTRnEJVgTAYgFZFPnBUFhkDXJ
         Jl0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782816684; x=1783421484;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zOCmAhk2QZilrROnFdYyZ9E7NHFNJQbLWBKSgKarjZM=;
        b=TeK64Yajoc+KXduznop+LR3hsTxcuQQG3a3W425wAxaytkyAo6wqfQiUFpW32l3Y+w
         vhSkqVjxtGb9Qqcpnh2yxCDJE8TabSCbV7CKZo5Boui3KnzXpECKlCaIKyyOZnsUNQEu
         wOstCtqJINqN5ppzoXQbwnkLNxA9ohh7U1/p/dgn2f0VfhSy2XRVwvTKOxiq4s5n89cu
         B4fICpQohV6lTUWszhnYg9gDvdLEJ2FFECXhUrVCVBE4tzoXHjhJAAteN6mT2xxvUYCx
         c6lcQ+k/5fLqiBz5ufFWxikD8ujYL+vpepDSV/8xC+UtREqgr5ayGTGhu5Tw1HUynrM2
         q/zg==
X-Forwarded-Encrypted: i=1; AHgh+Rrz38XAnOXXOsLMw+J7Akj9K46GbqdDJj5QW/3MSDFTukxTi2Lfo6ybCeTh3Ur0fL0aG/53/aHozA==@kvack.org
X-Gm-Message-State: AOJu0YxCspVbsvzmjE/UYI2huN7iCZm6hEn2QTo2aO2o355SGJKGtce3
	T0QaFGR1OxPHgV5bz72C5+MdvE4RI+voailkmquYcPTMZE2SMZ+6+D0I
X-Gm-Gg: AfdE7ck16o9vVOCV8GiWAtW/sLLkDJFvaDowJDdDr6elGcBUGADmW2ndCoCTTRo9IyE
	i4Dh0Kr/+3zJFUaFFRd9hz9yVtPfyRYT/8ywS8HDg+b3cQz52MLF9UGSfJe2KImq95K4qAfiwx7
	TasEtIH6qOEU+Sx2m2MrZPUNry36XiIZ/FFB65sp77nxWIympx6TauQh9pvzIJkMDzGJ9rvHjXQ
	kzUOGquJe9qljBIFn2pS0Nj6ZO7jC5QjPy3j/VRUe2bLswgzakhy1OJIuG+5jVFhKjl5TNfzH/o
	lXBupXCv6K+IDNwFe3c209lvHs7Nz7HVA+jLKVUt1JEzAdRBty7O2gBzSsvFz78zd5cEfDR5LDk
	dwvibVznSlSTNr2HiLJemTCFmj0R+esXhdg2o6SUbMe46ZWXHghOZWZfKB9+LCgzxfKSKZL0Jn7
	bD/Iha4rUEEepz77qz9fRcsba59jBbJSGn
X-Received: by 2002:a17:902:f68e:b0:2c2:bd7f:ccd4 with SMTP id d9443c01a7336-2ca2d56ab0fmr23156785ad.21.1782816683996;
        Tue, 30 Jun 2026 03:51:23 -0700 (PDT)
Received: from [10.125.192.77] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca3828c950sm10687625ad.51.2026.06.30.03.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2026 03:51:23 -0700 (PDT)
Message-ID: <fe15eb9f-0b6c-dcaa-d0a7-5f08c3f92bfb@gmail.com>
Date: Tue, 30 Jun 2026 18:51:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v5 1/6] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
To: Nhat Pham <nphamcs@gmail.com>, yosry@kernel.org
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-2-jiahao.kernel@gmail.com>
 <CAKEwX=MniM-4-aV17aH3UiDd_Xd2RH743fFZaxEnYX9qvnokeA@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAKEwX=MniM-4-aV17aH3UiDd_Xd2RH743fFZaxEnYX9qvnokeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 86wh7jkerbtz3z1e66y74obhyd6j3ozq
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EEB5180006
X-Rspamd-Server: rspam02
X-HE-Tag: 1782816685-977014
X-HE-Meta: U2FsdGVkX1/BarTIylBCr+jpRhFaeronir5VvQnM1PRX494bMC1nWALP2WMN3OHXim7gzMvuB0PBnI+wVS7ZM/JPRQsdx/tCwc/QHZhBokCYDoHipShYWg8HbxaF6MXZTS0+lF2yLgOea2JFA8KB7S9dHAucQdfFGyv9t5tLFNZ37bTG/Awa4O/u1bs2W67B5SR76+2vqpRGVzp0gAXyV6E+2IDe3pX1Yb9X1qdVrXnfbX21xY7AOSEMUpmgJ8nRN5SLl/1v0yPn7Ql8z1n40VwUG9KZto/L2vAGLEI1zBH8csL4qo/AObffTWKA5He+qHjfvOZi6Pr5P7wONBj0+KFyjw1YUf9kR+vjwyTEplktrYQZhfP3C1jAd9PgKCwHthHOLpO2DluYyZF+ANf8GwsbYofE8lXM7lV4XCX/WAPRbS4lBeOuRIjaqFNIr6a2ZR6lT8M4V60gVUam0h8gfeIZtfEyoY0N8pTi55AOcxX7BEkgMe4yCfsYFryUfAXcQ2/u9JsTwgk5f/yvYDTtiB0xQjrr+rJacIfaHtdqAqi0PORI7Enft2rj5nqsjjZhRU0sytPbigsRP82fsX8lIP44GUo7UL04vhPR2/P6ezjkbKL+a6kc8vzvzI+uRk3eIBJdvi/OJLoduIoA7uynQWJ9F+uNvUpMjU7hZux/xpmTRsrI0KJq2rb1tWmJTvIahXwj4Ro0qhq1QAE+gNPyD2SYvZbV2pFIkiPfWA95SquNtstX9Ujks9GjR8zy7ElJKEX4oocjnt4Q4bxQoG2MpKzeTBdcs93K+1JTJLq1I/0Hh7+XOI2YZ+rx/x6d/PmsxM2BPRaDTBBSrVwmTM4DSiBgz1EIaeB0Vd9BbUntKyVc7WlHyjOQV4wNfyAmIEePjQGhgsZVdfLS3JS4xGqcW3RutHyyPAje6w9Abh04SIt/T2s/zo5qPLnBw09DOcSkGo1O1t10So1Llhhyufd
 5dl3Jm0P
 mL9oNtWETjDZSOFUwjWHLcwnFSSSEmgKR+OaFLM+tuPdxyrZTK5Wx/tWpKm53fxpZSaJ/0XdeWnw9A33QoUZnoPnKWY+jdK/l0YjiLpiFOsuPXvvABljiY5yfqPgLSdaE6ozMjskksDAtzdUL10Abp39ffn+lR7gSlIDwxHOiQ6akzEghmO1/dv4ah7qi0yYdHvdP5C+j8QtTvx8fYpcxomT8r/n/Sa8ddr1WGOYiXznsM0Y3pNAVjNvbFYfkD12DlX3QSVGIk95cRXWKw+IMvq5iKF9oyQcf8ubgAmQ2E2q2lwa+8n+gc6UVff70F18bPcBvzwcPpXE53EnRCT7ruAMq+Za5E9wv68Ka/uZU5+zrAR1MYpwTGPDr5FX9hiLs6ISuD567b1tH9X1UAlxqBxKCg5J/o9e/Lrs8anAi9NKLr8uiS/8+QsokGZnQTyFPeyO3bKmJyAluAM4kS6kUJuoFGk3J6ppoRWXsyeGxf5mhSH+4j92H6FZ7OylAb70PCaSdqFjwq3EQ+QrMAs47WSnCYQmTEdYaiJpc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/30 02:37, Nhat Pham wrote:
> On Mon, Jun 29, 2026 at 4:20 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>> From: Hao Jia <jiahao1@lixiang.com>
>>
>> When memory cgroup is disabled, mem_cgroup_iter() always returns NULL.
>> Therefore, the global shrinker shrink_worker() always takes the !memcg
>> branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply gives up,
>> so it fails to write back anything.
>>
>> Therefore, when memory cgroup is disabled, fall through with the !memcg
>> branch and shrink the root memcg directly. Stop the loop once
>> shrink_memcg() reports -ENOENT, since the root LRU is the only target and
>> -ENOENT means it has been exhausted.
>>
>> Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
>> Cc: stable@vger.kernel.org
>> Reported-by: Yosry Ahmed <yosry@kernel.org>
>> Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
> 
> Ah good catch.
> 
> 
> 
>> ---
>>   mm/zswap.c | 16 ++++++++++++++--
>>   1 file changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 761cd699e0a3..0f8f04f22888 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1356,7 +1356,12 @@ static void shrink_worker(struct work_struct *w)
>>                  } while (memcg && !mem_cgroup_tryget_online(memcg));
>>                  spin_unlock(&zswap_shrink_lock);
>>
>> -               if (!memcg) {
>> +               /*
>> +                * Reaching a NULL memcg means a full hierarchy pass completed.
>> +                * Exclude the memcg-disabled case, where it is always NULL, and
>> +                * fall through to shrink the root LRU directly.
>> +                */
>> +               if (!memcg && !mem_cgroup_disabled()) {
>>                          /*
>>                           * Continue shrinking without incrementing failures if
>>                           * we found candidate memcgs in the last tree walk.
> 
> nit: I wonder if we can just merge this comment with the new comment
> you just added.

Updated. Please see below.

> 
>> @@ -1378,8 +1383,15 @@ static void shrink_worker(struct work_struct *w)
>>                   * with pages in zswap. Skip this without incrementing attempts
>>                   * and failures.
>>                   */
>> -               if (ret == -ENOENT)
>> +               if (ret == -ENOENT) {
>> +                       /*
>> +                        * With memcg disabled the root LRU is the only target, so
>> +                        * we should abort if it has no writeback-candidate pages.
>> +                        */
>> +                       if (mem_cgroup_disabled())
>> +                               break;
> 
> Hmm do we need to do this? Consider a system with cgroup enabled but
> with just one cgroup (root?). The behavior would just be trying that
> cgroup for MAX_RECLAIM_RETRIES failure attempts, correct?
> 
> In that case, we don't need to do this check, and we would get the
> same behavior. The loop would terminate after MAX_RECLAIM_RETRIES :)
> 
> Could you fact-check me? :)

Exactly. When memcg is disabled, shrink_memcg() returns -ENOENT only if 
the root LRU is empty. An empty root LRU implies that the total pages 
have already dropped below the threshold (thr). At this point, the loop 
safely terminates because of the zswap_total_pages() <= thr check. In 
all other cases (where shrink_memcg() returns anything other than 
-ENOENT), the loop will eventually exit either by hitting the 
MAX_RECLAIM_RETRIES limit or when zswap_total_pages() <= thr.

How about something like this? If there are no objections, I'll fold 
this into the next version.

     mm/zswap: Fix global shrinker when memory cgroup is disabled

     When memory cgroup is disabled, mem_cgroup_iter() always returns NULL.
     Therefore, the global shrinker shrink_worker() always takes the !memcg
     branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply 
gives up,
     so it fails to write back anything.

     Therefore, when memory cgroup is disabled, fall through with the !memcg
     branch and shrink the root memcg directly.

     With memcg disabled, shrink_memcg() only returns -ENOENT when the root
     LRU is empty, which means the total pages are already below thr. 
The loop
     then safely bails out via the zswap_total_pages() <= thr check. For any
     other return value from shrink_memcg(), the loop is guaranteed to 
terminate,
     either after MAX_RECLAIM_RETRIES failures or once the threshold is met.

     Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
     Cc: stable@vger.kernel.org
     Reported-by: Yosry Ahmed <yosry@kernel.org>
     Closes: 
https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
     Signed-off-by: Hao Jia <jiahao1@lixiang.com>

diff --git a/mm/zswap.c b/mm/zswap.c
index 4b5149173b0e..9d4f19fc440e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1361,11 +1361,12 @@ static void shrink_worker(struct work_struct *w)
                 } while (memcg && !mem_cgroup_tryget_online(memcg));
                 spin_unlock(&zswap_shrink_lock);

-               if (!memcg) {
-                       /*
-                        * Continue shrinking without incrementing 
failures if
-                        * we found candidate memcgs in the last tree walk.
-                        */
+               /*
+                * A NULL memcg ends a full hierarchy pass (except when 
memcg is
+                * disabled, where it is always NULL: fall through to 
the root LRU).
+                * Count a failure only if the pass found no candidates.
+                */
+               if (!memcg && !mem_cgroup_disabled()) {
                         if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
                                 break;

Thanks,
Hao

