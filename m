Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A75F8CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 06:42:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D58D6B0144; Mon, 19 Oct 2026 02:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886516B0145; Mon, 19 Oct 2026 02:42:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79CE76B0146; Mon, 19 Oct 2026 02:42:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0906B0144
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:42:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BAAD9C060A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:42:47 +0000 (UTC)
X-FDA: 85338432774.24.9959B2F
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id E55C3C0002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 06:42:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NXUbyPMA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792392165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vBI495sTrHPugfVjBEVGuxFJ+6JlCnqJ4Bwn59THMd4=;
	b=KR8ytI90HZAmJ0aCbgLKX6lEk6ynDvdi/Gn4STjJmUDqO3c34y4fFMZwIIYUdr6NsgTFky
	77/LG7a4quUcJqHaLsdY/6Z6R3IWn16woxBHCFIn+wqhUiA8okgHtzxdqxUtjW7cGUvD3v
	Ed3y+894sSbPEelocUnYaPJm9cj/M/s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NXUbyPMA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792392165;
	b=6iGd9cvhmHeMoTKmw54GbgKT8HbsXU+UYZpddBcAvbQ5A/h5+J9rWxN9M7T+jtot970F0i
	TxqYu5/rR2XORJltCSP7IYUDkxO0lXiyp+HaHdip+R1OfloPGKS5mCzfKyBuXpTk8c0u4l
	lHc3hCiYn2qm6R5hJmCzs6MW0UNtEz0=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd5c9e52398so529554a12.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792392165; x=1792996965; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vBI495sTrHPugfVjBEVGuxFJ+6JlCnqJ4Bwn59THMd4=;
        b=NXUbyPMANSdqIQzPjTmyhZyfKc5nl0qIqigCV+XNxV3J23Apj8JjPhG25Dhcb/6h4a
         7P3kHH4fMOrsGik5WQh2zvDfWKyqNJIcfEkH8QbZ5iCvLx2cNN6bcUTUXdCYiUEjkGUs
         FAjCGcXmXhCBcRPvMS+kXuHJqAn2Vzh+RGyhW3OpJpu5gosVayZkfX2c/lM7eEmIBUFv
         UcVnBkO58+B9onuxXwGjVD7dCZZVS/esZYeaHxp6ZfK285uHCO4vF7mFt43aoNAr0Tdy
         +eoBFmKigf0XBDNyfCHJdHeuu9nFLCsfsSG+bllEwMSer2OTyNpaoEElerUuCr6P2KDJ
         IoMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792392165; x=1792996965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vBI495sTrHPugfVjBEVGuxFJ+6JlCnqJ4Bwn59THMd4=;
        b=eCe9nYKBjJWlabe6mh5WV2ksXb4xkFtxiXIoeuJgTCUkggBnsVRiXu4sf9l+6Hvu2B
         73KxHlJPiacOr3XDh8IEIldq94gwY5FQXaj75pismdbbaH0UrmPogdWeck2lPo06heX4
         ISXTJcGgGf9nLTJwGeedgji3nTFPTQjuP5wnQ4NwY0V08bKBNznmgN8VA+YEH8tfwADH
         xebJ2LGqbmwuZpd6RSPQrbMJzZFGjLxEVTasd3YUfMelaiNUDo+71kWr4JOvYwpwU+gD
         iJqruQmku2L3FiYeIIsLIUVtXFAhekVY5qvJGuSDuroCBD83cp2S1PYFvpHZ4/ZWgtrp
         1+Ag==
X-Forwarded-Encrypted: i=1; AKwUvBzakK+zwQtJ33991yek3VFOGBsHsp6Eh7gM95NK+D6sIk8GwR6DENRePX2uiuubLKr0y4xS6UXn/w==@kvack.org
X-Gm-Message-State: AFq9FYJ9oVifqkvkOm22dr33gcmQXeho4/tx2yxfr+mipVqi4octsntT
	jES4smkToD38yJ0gZ1z5UaIKSUkhEqCE34Q/hUnh2VCng5xYp8Imz8lj
X-Gm-Gg: AYBFou2Kc38iTHCI+PvhKBaYZORUVp4V81HEF/63TBemB96GObqdzaKaBmtpUwzw1CP
	FsrmOXfAL84+yx5SInRL0ESX02hdL0r5CnWH/lXEIW8jm+VZdlIu3Uirvo1cvTJ9P1y8KNUO88/
	aYk2L8Q/Xq9Qcm4BFVSb2eka+Ek0EJB7aUYX0GIJxdCXs6xeSnthqVZXQ43QJhCoMsbmL4VaUS/
	1R2sYM3TV5n8JRev8/unqN6Ap+AZzUpKueCalO7rbBKh6Qd+ijfTw79r+7ZNGuxH1v4y4jeux0M
	2ddTy0vQ+svzeWudWrJhlT233jI/swqYrplTrBexKYIrHwpCMmWpcOu1HAdpGYETxeMiP+9dHAs
	ANfMkefVPJ94Gl/7o/hvB7XAWHwwDuwXl8eEra6t+huQbmALsYXRVARU+E5jVx4PAKnt1NWPvAl
	nlGNR12D5/Y3v8gvWfr0UXYCAZTbPbSYKpqiSB50GWAGr7afwSSc30E6fM1xE2NsolCdoe5dnVX
	ti2ucTnqTXI1Ylj+wTLJei7lM/zkrJSfcj1Jt7HgUBwSOIbZ4Oor+YbWgK3uiKFUn6TKFk=
X-Received: by 2002:a05:6a21:482:b0:3e1:bce3:c3cb with SMTP id adf61e73a8af0-3e225fd83dcmr5763850637.44.1792392164732;
        Sun, 18 Oct 2026 23:42:44 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2100:3fed:6938:3f14:63eb:c479])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd654a3a592sm3688960a12.30.2026.10.18.23.42.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 18 Oct 2026 23:42:44 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v3 bpf-next 2/5] sched: use static_branch_likely() for the NUMA balancing tick check
Date: Mon, 19 Oct 2026 14:41:54 +0800
Message-ID: <20261019064157.29885-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261019064157.29885-1-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E55C3C0002
X-Stat-Signature: k43yqwieu1nzjy3ymzwos1piiaj5oej5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792392165-48255
X-HE-Meta: U2FsdGVkX199rnA4rsj78+f+kyM6XQmBW9DH4WJbCQye5oMBpsX3srNP+l3BcgCjhfr/RTK2P1bMNaWCuec1Y03oE4MvI8lsyeuqDu2Lo2waBqSFPSRqf2LU7tOFjRcvc+gT5yzfH870q/tBVw2tP2X/LyhDP4NiQNDvdPQjqomw1DOpbvlz8OuLnmlF8FKA6WDlHR+9T9pe4uRjevavoCeECPqthfFUXh2iio3EW2RuaCuYkVjxG64qBi38xawoXEGGY5PI+4uV/U4xloidRIYoNvbybh/ocExCy5QOZLU58r0tTcFyB1PvBIREsoEBQpXAJqnmaveXLsGTQat5UllT7WMCGGd06OuRNvqgAfEGwc9cIo1X4dGdWhoNcLwITGyInIdDOPgEPo5ribHcT/SwAMP2+hz9Thsf+PRgJ1sPJjdZVYBBn0USiH/mloag6Lht2U2NCzRJnDTYz9DDYGLhrKDvLJcsbc62D1nFKXr5ks3e6BhXeg7KVZKFUEv4UVsq3AUYiHa10R0Tj9uad+fN5z9sKNaJ2fbWKFyirLH4iRvQyw3URCcHHSx4cdROp/BVN64hiN8acAIAJqUHKDJNoQI1k3/nSHcdy9OQ2oZSouNETi0FMSxO+vMykKzUsUIhjvYhcpdRvpYtIAhpBaOHEvOl1hDT602qEJhzZ50WkwC4ux8ot3yNy88bCj5MYXTRAexHYUmYj2ddLZmVkiaBFyA+iZLPrAsrG2CbgByeBK2P7QjwWhGWwrcGqGeyCTsUirPyN1K3scwfAG5d3SqXixIe5xdCWv7szcpSf/0gcbJra+9Ji3/vFvt7MFFI3NLE+xCr/j9hVfU222bd9+J20Z0caRPYujGRXNG9E0fbFn4YNmURzc99M5SoM6vA6UK3Tg2VqXnGTvYyJz2rj9VkG9emA063Ku/c5mEl0SxCtZvVEIPowK7hR6i384Blx8k5l5TfDA70c9eqoM1
 cRmA5HmX
 mMImpVpCm+1DefOTizn48DsLB7cVsxuzYs3Yc46aT7j6GBE6wR4OJYwPN9+kgJnMUOlBY55GiZ2cr5mP3+jm3Ejo99iR3x1Aj1iXgdT+BvblUaxwYUwAzox6wRAlpQlMOh/oZbt3Y8ja43whILze0tM3UCU79dobjpUMc0pucjkSAokCZAHUbU4LOC35lThpF6rKF21pQ8owCFPHxGhHTPOTqwp27xgOVLBhAIFzwIOP2juexsJlZF0OmOGCBRvJbW3ZLJsXkdKReCpvyDLrSBT+0NNTL5jzV0/WKY7IgjymXvfeQvmgzrrnvzbMwETCXw+WZHB6oyYsFfZD5kcfRpuo7BxlRCI+XrT/VQcgEc5LjVOQZFQmLN35Dp1mP+7OCGJpIZS4YemgnopGo2SaZd6D51vUq+4wHLBdOrovZ33ipZiryvtGlUVMtxvuM+WfBqjn1n7z27OqvMgf45eyzRWcFmiDRwYEVbjyKjyl3cwbDvtrwo0A2T+jU+6XE0HMJIDATf/SYplJUK4CBJzkg1tuxJkDDOTtu9hFY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

task_tick_fair() checks sched_numa_balancing on every tick. The
static_branch_unlikely() annotation reserves the nop for the disabled case,
so the default configuration (NUMA_BALANCING_DEFAULT_ENABLED=y) pays a
taken jump per tick. Flip the polarity to static_branch_likely() so that
the fast path matches the default.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 973647ad6c2d..71dc47d6114d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -15351,7 +15351,7 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 	if (queued)
 		return;
 
-	if (static_branch_unlikely(&sched_numa_balancing))
+	if (static_branch_likely(&sched_numa_balancing))
 		task_tick_numa(rq, curr);
 
 	task_tick_cache(rq, curr);
-- 
2.52.0


