Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 616531061B21
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBBED6B00A7; Tue, 31 Mar 2026 06:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C836B00AA; Tue, 31 Mar 2026 06:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD08B6B00AB; Tue, 31 Mar 2026 06:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD37B6B00A7
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:08:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68D6A5CA6F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:08:26 +0000 (UTC)
X-FDA: 84605933412.20.DBE0650
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id B6D64180012
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:08:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AiwWul4g;
	spf=pass (imf16.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774951705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8gHI0QkCJctS9VHjY8Ks04R+myIXiOZpZB0G1g86acc=;
	b=p6ftjBkzM9n/Dlmk9IspU/mlnszdlutKkbGNfgDxPPkcKD4KDkR6zDGRK3/48GTVObHk9r
	5s6h5NtwO5t2uKQ5c5bTK5vvmF0oJp1SEEpXh2NtYlRTtEkaXYqQt3GdHhNQKHHSlRPLUx
	XokinidsQqdC6C/FNkIaGbikUXGMdvE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AiwWul4g;
	spf=pass (imf16.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774951705; a=rsa-sha256;
	cv=none;
	b=DZaKZtyBxKiKkf9/DF2NzzdnWrIFEiDJ24Zz53ZVPUOhLgE9pWl5byRhh97/JvolUCuDrC
	t3kWyeWwVgeuar3JE/RaURAW2hqYSM5RQOpuELa8HKfa76hcwqNcRycwsbOQVjaFtAgVWo
	wRVvWCSDuWPVlAcAHyh7OObdXxhJqLk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774951702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=8gHI0QkCJctS9VHjY8Ks04R+myIXiOZpZB0G1g86acc=;
	b=AiwWul4gM0Gxxbhbpl4JRhKqHFcNw+Gd8y9Ey2HJUFdyTxIngTisM5VTZG0jx3BpU9udFi
	tUOpUxyubNObyFKwxw8q5iNRkQlTvHr0w2WrRJWxS1OjYwe46BlGRlzCf9a2iXuu8KLK7A
	W/5PLBZWunxDZGIZPai25EG69do/0qA=
From: Jackie Liu <liu.yun@linux.dev>
To: akpm@linux-foundation.org,
	joshua.hahnjy@gmail.com
Cc: linux-mm@kvack.org
Subject: [PATCH] mm/mempolicy: fix memory leak in weighted_interleave_auto_store()
Date: Tue, 31 Mar 2026 18:07:40 +0800
Message-ID: <20260331100740.84906-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B6D64180012
X-Stat-Signature: f67quogrdpggbs9jedpew3xu7qxzg97d
X-Rspam-User: 
X-HE-Tag: 1774951704-356812
X-HE-Meta: U2FsdGVkX19yx2JqcYDOW/becOIOL/x8e9uQrPpvBT6gCB2Uw47yjseM21vy/Prje+FAHrGw0lAq+SxJTBAnJgITrhHGVSfSjyo9+C8zVa6BVNiT9KaF9hP+2mf6DxchxLr8zfy5JqSftbIushK8HEKdF6W0wyYjoARo1Pz/jwFDmm9dyQTMyj2I+VRxqkARfm2e5VP3U8QVeWvgSMMoKgBOL3q5ecmudAWFpHsyqmMwUCHAlVAUiOYxcGpYoC2sfGA5fGmLICJuKkVUh0i9YYa03HS33va8agKycQFmndghcYvl5nq9xgO8gMxQBGnKrArldW2Fm5rZMAVxB3DNmpnBw6yye06TINi8Jmw2eBSTDG4N44awHKi6EyrPmRO4PAgL12odSi3jrAJ8eKt3u2aNYWMijRvxJFnftcBcYoM3WriWpIuuJv90vRISsVJaNJcLGsgRnAUZ8vshEUxSdNOdAisSXT3ZoEfATFa07AaNOkmnAhaFt0nJQSXrLPKXE0I0QkBUOoGUFmjueHKUpYSnu9FMKJdRbU4HBS//j8IPZiVbLxGx1GXhVmQuKm4KHY4Tk9m1f1OUeg8+2AktWXI3+xFkfUYmSdxAteBNCqdcA62BS0ysjURD2rvUSVWP3b0pLEqvGW1Sh7nJpoQoXNyFtpFhzW4wMNpkJ0cVJMRS7PAFbl4LeVRrayppEJICBXwFNH7Ckyofuk5q5pQolpqBss08+hbQ9Yw4ImaxCwqJ0/X6+nn5+txcg08uBTrGC9QQUjv1VPNibOtlsaJbX/tx13L8/Hya2imdcu+wPTzXeYxQgGQ3zr+sbO0YPe3o1wJ+WV43D7u9RhjON3pNhy3JZgP9SAGoKZrtFGwSim6pSqENllycMTnEFIE/b7orHojUxFi4miVEDJB6BbO2FVexH6KSyyjFmnInftKt8oyKhhGbt1EmTVtFhfUb0+1GIEZG/AixgFCJTK3Ouxv
 73NlHWC3
 k2vP2Z4KSt0TBKDltIb1XP46bnSHEZoPUSZr4QD0GGD4kv+m4C6x87y46NRG2fHuOg8B3y1v1L7V19JSJQ/CI/U4PFb3DhgeR+T3xFVayJnd2+pXOphHS/TSxj4MWxsVLWI/BuNuNWFPWMEQtp8r9XAjbIqsLMs97XX1Brz7YD4sT3u6To8rDE4WxkkWJ5QV6VPs87rXy18Y+tFM9TtZbHFTgzLQkXq89kbxRKA6Lv9Icn34gEcSAO+BbdAAfnO/9yUNK6EfmrEK1MYJ7YcimTgvakOaeB3ctsm9tG3vH+R/aRdJbWssBmNOnZfpU6GP5CWC2TV5uyTvXy4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jackie Liu <liuyun01@kylinos.cn>

Add the missing kfree(new_wi_state) when the auto mode is already set
to the requested value. When a user writes "false" to the auto sysfs
interface and the current mode is already manual (mode_auto == false),
the function returns early without freeing new_wi_state allocated at
the beginning of the function. This can be triggered repeatedly from
userspace, leaking memory on each write.

Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 mm/mempolicy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index cf92bd6a8226..9ac74178075b 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3713,6 +3713,7 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
 			goto update_wi_state;
 		if (input == old_wi_state->mode_auto) {
 			mutex_unlock(&wi_state_lock);
+			kfree(new_wi_state);
 			return count;
 		}
 
-- 
2.51.1


