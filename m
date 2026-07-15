Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C81C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0776B00E7; Wed, 15 Jul 2026 09:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8676B00E9; Wed, 15 Jul 2026 09:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7BC6B00EA; Wed, 15 Jul 2026 09:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A58966B00E7
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:49:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA5E9C0144
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:31:06 +0000 (UTC)
X-FDA: 84990945732.17.AB94DA3
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E0B71C000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:31:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e+qO3gpc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784118665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FL4DH6iSB8h5Gk2sonUHgNYBuRFyDX29syp4nQdWWD4=;
	b=Abxh6W1wDYNxwxiQR4iV2DrODEUX8VHYLHlbIKmlIrlG6OHn9KJ5TERBb1bfGbifxwizTS
	IsMx/A+fu5dL131CuB6BPSWV7wjuEbMao1aeGZ5yP+4flwfWigWcBvVDCjYhqYSnUfSfC6
	dutBAGrFhxikus8gFT7upqCbdx415u0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e+qO3gpc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784118665;
	b=etMHa2+/MEBlEAR7Yg+xOiYdhXEucKh2TG6qhjsHkLiw9e/e0KazztQb1Xo6tDGehO6vrz
	AvIp5q1BMyQHIZMPOgyn5swnEJAbaSiV5OfQqTaawLzNaN9WLegulPtpA178YpPcCPd/wG
	Mcazh7mhFk0MOiyUQhZvL/7kVcQT/2Q=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8485ef63b68so4884418b3a.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784118664; x=1784723464; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FL4DH6iSB8h5Gk2sonUHgNYBuRFyDX29syp4nQdWWD4=;
        b=e+qO3gpc1ctuXD1e2sUj7Y5JNlByTm3jrzu4V2Uf/RzZOdtuqLHSFwsbrSHOuUtrVW
         zPg/I66SOBiR6XGQpd5Irq7HVS1lInPIASyRSGlTWhwdldYAOkGG6ndcgFAnANIROivD
         3VHIabGr30doXagXgYlrgTnU6OwQ3Nkwt28fIob+x3Wof/jbF3XbkMPL11tw/w0j8mGt
         0ygALDM0LuS4bd6le07g87ERDMubTpTzy11YQC2IfYU7f23MD7REcoRjv4A7uLk1x6cJ
         D/LZdYn8iFEbSL+Lcztao8d8aGrjgatytg0huXDwHchWizhX9z9TPuSDFoIqVKnhTRsE
         Udrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784118664; x=1784723464;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FL4DH6iSB8h5Gk2sonUHgNYBuRFyDX29syp4nQdWWD4=;
        b=UssItmAvXQLjphO5f/2u186EEAzqhh35RPK8121Mn+k/TLH4bw0WaNr6EHQUBinnaP
         gRPch7YzUfZtENrw583QN3/HbQm1CdX7f28Q4O+Z6KkFtRzdd0WxhNxm3IMtPLUVcA8W
         B2CpiSzTo10TaGjJ3KPjWv90cEP2sFhLOlQ9x9kIOGLlPYKbbcfT8CTtYMirt8D7VpWL
         Qfob4dFoMAEjsTwUc79eFix0XoNVQH0m2Rh4qesEL6kXmjSFnulCb/PfhLwD01bcEkoo
         jMd+QDGOcM58WwyD1zER1vgfOsdZ9adXnowkQvp2PnYU2mwjlgs0T+EkGwgja3lQ3Nz4
         rVUg==
X-Forwarded-Encrypted: i=1; AHgh+RqviSPJMFMm78L0ldZFzYnZ9DdnJfNZDRws+clmyc/Kc6pyh9g4r7Mt1ow/kRe9k5F1zIDQ560VBw==@kvack.org
X-Gm-Message-State: AOJu0Yx4BVuORt3iIk2/XjlaslkhfDuMF5izVxbNnkFM+huJjLqUBaOC
	P5zoWoXeznPnFZuVsLb8tTcBlURwCAbE50hrRffjrUlCC/dFBBjCeYjO
X-Gm-Gg: AfdE7cmI/QAM2x/ENgYI5gAMRLnW40cus6WlodnLE0u7AdVln0WuYko11XOjaXlEKHU
	XrlOYIpdd+IEgKWkPaozz6y8AbqtBCb1FDQi1rSbBaMczgmUYlaNG1BxezAq7FwYyVhTtCxN3Ln
	Sym02MogOc7DtCmvnXRVS1QwocpIhBB+0M3LU4QqwxzrlqHarsOtr9+u5jnJGNVfntnFo1n7buX
	xw7IoshICArKj2PT0NDrVM1AYAy3tBg2aj+lmNVlpotWRh8ENDuMQCHI8IHaxEqZbR4wO07PRZM
	3+zKp4Fa0Zoyk3QWuHz+14OmWbDh9ZQdvMP9xWanH9pcSCF9pGmNiV+fUg3igURR2WeLDNetBMj
	/NfREpOqLAtgYP+ePbwQPxNxiDmVyBbq3srKvnHy9Mg1cFdcAzSfa7G1Eq+pPvzm5nXN0f4jC+B
	FNOLCSDfBlvq3C2DQMMTcPmy6wju4DS0RbmQ==
X-Received: by 2002:a05:6a00:4612:b0:848:2f6e:e52e with SMTP id d2e1a72fcca58-84a5587a0a1mr6247775b3a.66.1784118663610;
        Wed, 15 Jul 2026 05:31:03 -0700 (PDT)
Received: from [10.125.192.114] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f7dade0sm3092157b3a.46.2026.07.15.05.30.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 05:31:03 -0700 (PDT)
Message-ID: <7a1fe347-7ca6-4768-9308-420bf1251f54@gmail.com>
Date: Wed, 15 Jul 2026 20:30:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 1/2] mm/zswap: Fix global shrinker when memory cgroup is
 disabled
To: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed
 <yosry@kernel.org>, nphamcs@gmail.com
Cc: tj@kernel.org, hannes@cmpxchg.org, shakeel.butt@linux.dev,
 mhocko@kernel.org, mkoutny@suse.com, chengming.zhou@linux.dev,
 muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-2-jiahao.kernel@gmail.com>
 <CAO9r8zM5nzDqNcx5UoDgGexvR6jf8MmJV9SomM4AS7n-rZ2o5Q@mail.gmail.com>
 <20260714193129.f81711f516504b659d544741@linux-foundation.org>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <20260714193129.f81711f516504b659d544741@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0E0B71C000A
X-Stat-Signature: 39uwmy5yc3gj1kesqbrwmx7kfan9jyuk
X-Rspam-User: 
X-HE-Tag: 1784118664-377101
X-HE-Meta: U2FsdGVkX1+9CSBQAjjyvPQe7jAZzPXgwBFT8HPzi5ruu6uMAAn5wVpjNhCA+z/akk8uz1FZ1D/QY+L4G5nHR1kTD2APo7mr61vLE10wDlnyW38BvcX5H5hdHATnd8UvKOivyohUzv3nosxp75XHCVNbrePJeAqr26Swz9ZlD6/VZPxAnCYqD2c8asnWgE7sMHpFLusAyDMNixeaDoqxTiPaWLzSTHx4XFhx1cfgLPRtmvZ5PZvoTaUHeBsd9jv+hlTGavtNLNB5dlDAW4svN2PtssDI25sn6o7LQOLip5o8TCX9tyUakYarfU4Bfk/3VhfXwuIf4nZK1661b49b+6vmw10nePIhmS7Z6fJqWr01gSnum0dG/5WOBrnV3FkcSc75jQL5um0Ujy4dkmJcBM0GM0b9rV8bLfKlh/mEMXocNLPhs801YSnvGJGGm9/9tTxZiMTMgfH/K8iXYix/gOUdF6gRd9CwHoOYiTQHQuqlD3xRzUUmTolwiHcMof1oeuWnGtfZHEuvgarsMXuF+EXy6h9nDhz8iL0uQGtp1KBpvu9oJaH8h7l2+q9/yNhJjtBZbkoB5aHQfw1Tq4RTwPszTbP9wU9c54ty3DMs2ae7w9P2QZWtzl1tfNT5Sy1VC1iuq8564z146IJ/27Pg+VTHyIfiHGcZfUraKKQ/KBv10jMS7FVBKbH9ejLr9x1BBOSGZlTxxA5EMyWPmLV+eljFUf9mjh3lx+5kY2/jxSeEqQ7TbF9WVlJnQ9S05GgsyD7HbP+/8uOta6jzaGB8N0wd/Lmu2kDNEerljhwh0zIosKCIktawSk1NMirvpVA8jEVwh/g5EIGAHGV04KZBbv6hOCbc9sJXznjSaJXl+PckmkliIuQs7CoddSddt96fpOvd/wPxeEnTDyVVb+7OgpivDQYjzrhvNgZkzFNS1h18L9OOvghbIEZBnkaPJ7jRSCLA5WhmQUUJjm+iILC
 BCcouQ1l
 R5P67PHjXtcIOyEerDEQFD6hvfzXnssyxAbMqciteQMQ8lyYAcO2o4gSTFr+GbRrlHDAE/WgpTftVzyaIGMmbtd0xrNdYejV7bGMITwQEgk0Z6DFkr3wUNVt51ENmczAK8j5kgc3gQiauO+k6rE+o7j+sKZrKgaj+qQrUgHN+afuqblL/oCeaqlsk3z7w222F2NsgLan+SnkQLL7XuaZg7Gff0ridyV9MIALmwCx8CX1ODPLoTPicnkISJU+kjKgDEVu1401Mtj4X4M3BRqw42nP6F7bSCRY5eqMsirWHRucnwged+oYqY6WNEdDgKXwnWGqFF8XYs1/vLI4hYAKvhsSGhnqamJ6I1ElxvRhMyAhTmGJMynApbUOaWBZMJawZVJ0A0wegWxhJKD0y/lfdWNUE2+yCrz5HsvIPVFe0UFDAROb88sp9itQKryfMyK1f6O2S9iCFA2UznDU5ePiW8SP9X14mf9hDHnz/DYfBqfBhSOAHpWzzDo+AmICEKiH/ydlHmPGLAGZxHtIqJCjGIj38nADOrGAU9NLylE/tYYc1+0baWRVvfQXTKvIvTENJjkM7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/7/15 10:31, Andrew Morton wrote:
> On Tue, 14 Jul 2026 09:52:59 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
> 
>>> When memory cgroup is disabled, mem_cgroup_iter() always returns NULL.
>>> Therefore, the global shrinker shrink_worker() always takes the !memcg
>>> branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply gives up,
>>> so it fails to write back anything.
>>>
>>> Therefore, when memory cgroup is disabled, fall through with the !memcg
>>> branch and shrink the root memcg directly.
>>>
>>> With memcg disabled, shrink_memcg() only returns -ENOENT when the root
>>> LRU is empty, which means the total pages are already below thr. The
>>> loop then safely bails out via the zswap_total_pages() <= thr check.
>>> For any other return value from shrink_memcg(), the loop is guaranteed
>>> to terminate, either after MAX_RECLAIM_RETRIES failures or once the
>>> threshold is met.
>>>
>>> Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
>>> Cc: stable@vger.kernel.org
>>> Suggested-by: Nhat Pham <nphamcs@gmail.com>
>>> Acked-by: Nhat Pham <nphamcs@gmail.com>
>>> Acked-by: Yosry Ahmed <yosry@kernel.org>
>>> Reported-by: Yosry Ahmed <yosry@kernel.org>
>>> Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
>>> Signed-off-by: Hao Jia <jiahao1@lixiang.com>
>>
>> Patch 2 doesn't really depend on this one, right?
>>
>> If that's the case I think this can (and should be) picked up
>> separately as a hotfix. Andrew, WDYT?
> 
> Please update the changelog to clearly describe the userspace-visible
> effects of the bug, thanks.

I am not entirely sure if my understanding is correct here, but maybe I 
should add something like this to the commit message?

When cgroup_disable=memory is used (or with CONFIG_MEMCG=n), the global 
shrinker fails to write back any pages. Consequently, the zswap pool 
fills up to its limit and rejects further storage, preventing memory 
pressure from being offloaded to the backing swap device.

> Also, AI review has flagged several possible issues, all appear to be
> serious:
> 	https://sashiko.dev/#/patchset/20260714081510.16895-1-jiahao.kernel@gmail.com

For AI review comments on this patch:
I suspect this scenario might only exist in theory. For zswap LRU to be 
empty while zswap_total_pages() > thr holds true, it would require a 
prolonged state where there are always more than thr zswap entries on 
the zswap LRU whenever zswap_total_pages() > thr is evaluated, yet the 
zswap LRU happens to be empty during shrink_memcg(root_memcg).

If we want to fix this, perhaps we could do something like this?

Yosry, Nhat, what are your thoughts on this?

diff --git a/mm/zswap.c b/mm/zswap.c
index b5a17ea20237..ca71b517a58d 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1356,11 +1356,12 @@ static void shrink_worker(struct work_struct *w)
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
+                * Count a failure only if the last pass found no 
candidates.
+                */
+               if (!memcg && !mem_cgroup_disabled()) {
                         if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
                                 break;

@@ -1378,8 +1379,15 @@ static void shrink_worker(struct work_struct *w)
                  * with pages in zswap. Skip this without incrementing 
attempts
                  * and failures.
                  */
-               if (ret == -ENOENT)
+               if (ret == -ENOENT) {
+                       /*
+                        * With memcg disabled the root LRU is the only 
target, so
+                        * we should abort if it has no 
writeback-candidate pages.
+                        */
+                       if (mem_cgroup_disabled())
+                               break;
                         continue;
+               }
                 ++attempts;

                 if (ret && ++failures == MAX_RECLAIM_RETRIES)


Thanks,
Hao

