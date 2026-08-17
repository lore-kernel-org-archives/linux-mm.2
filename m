Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ABD7C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 15:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376276B082B; Mon, 17 Aug 2026 11:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FEE96B082C; Mon, 17 Aug 2026 11:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EDF06B082D; Mon, 17 Aug 2026 11:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F29C36B082B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 11:24:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 949711C1BB3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:24:54 +0000 (UTC)
X-FDA: 85111134108.29.3751F42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0325EA0007
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:24:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NilYUMbb;
	spf=pass (imf25.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786980293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAoVoukcfk8YQ8w/0yFAiC+Eyz8oCqkazB7WcGrnj/o=;
	b=SQkzTqbe2YTyHMGuApCS/Vuix69NREgytyWKNuOEi7EB98ZWXZ9yKqe25ik++eHqS5FAs5
	gw3fTy0sHB11gJQaGypZu6KqctuK1RZMT+msHX0JwJ4dcs+OxhCHyE72bJR2/D46kI3xdg
	K3ycPwF0rPZLQ3VhKb3mA9OcptaMB9c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NilYUMbb;
	spf=pass (imf25.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786980293;
	b=TYLqKoNfMSiX5x15/eUZdtB+BgUddVR777SNws+g0e4m28XehgQTvlo1w2+o4smg6DSyOq
	AgNXi54GoWlm8ICqq9NHVPEeBBV0COWx/HOWZlGAad+wWWYxC7oqEqtPSdNeFSliB/5f/w
	LP2RxMW6pPH9/vfNejbzkICzni4JxP8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24A214029C;
	Mon, 17 Aug 2026 15:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AD21F000E9;
	Mon, 17 Aug 2026 15:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786980292;
	bh=ZAoVoukcfk8YQ8w/0yFAiC+Eyz8oCqkazB7WcGrnj/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NilYUMbbilI4RQjUGfcn58Vwrg+9D0LLpAdWCTgds7ae60PYotSnpJNzs6UKRkcEx
	 8WG5WAPCoYDTQM2B7hlX/vmX+j96zoGKAYoKsh9ehz8SmPtrrPgl0DSkQHc1crub1a
	 7hH3NkrzgEsnwv30WHxWhQ50m6D1dVkcIMBkqkIUIDS8nlfATsMzygomGgIkCNa1+p
	 7Dsv7LLkNpuN5AN/GVcoVMUTMUdeI5dEe0pzityoUCbm9Eufc/ppNCR0GQSBPEBNIw
	 lsRs0y4VvPefoLW87NBvnT2cSTpXK5IZ0RuBz3CZ06dK7uoePZLpSFqlRCsVJ4BrN7
	 OoY1oqLq2RdzA==
From: Sasha Levin <sashal@kernel.org>
To: shakeel.butt@linux.dev
Cc: Sasha Levin <sashal@kernel.org>,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	cgroups@vger.kernel.org,
	chenxinxin@xiaomi.com,
	david@kernel.org,
	david@redhat.com,
	gregkh@linuxfoundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	jose.fernandez@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mambaxin@163.com,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	ryncsn@gmail.com,
	shakeelb@google.com,
	stable@vger.kernel.org,
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com,
	v-songbaohua@oppo.com
Subject: Re: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id on swapless host
Date: Mon, 17 Aug 2026 11:24:42 -0400
Message-ID: <20260817150000.4@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260817032622.1135640-1-mambaxin@163.com>
References: <20260817032622.1135640-1-mambaxin@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0325EA0007
X-Stat-Signature: 4ykw5zat9njsbxbjximf148jiopo56by
X-Rspam-User: 
X-HE-Tag: 1786980292-947499
X-HE-Meta: U2FsdGVkX197M5kxQsldiD84i6LbPKA3frUYQYhqjwy69W/YNPTrTB3ip9stpGz1OwQlNZOl5rX2C2RplobU0Lco0rheYaVJ18n0jxUIA8zWzD/OoQFRrPWlgh9PqP4LqADYVZm1Cu6o+gHO4Pe9Y0EJxJlD21II3fSV9oLJ5JgctQU82YwiggiYaaxRw8JsoZYNGhyU+zp4/te84dl0UAGI5LJCLBneNBrdKVyKO+YHnT8smbRh9s11oGbXiwsuHAYlCDmF3vItNvfNmjv3VCva9oT6h10KzxL95ZOrTqkRkcYG1EGxN4wiKShtQ0Qgniu3pcL3B1skeUBx5/johRiUw4mJmZ0IT0ZyPBNjJvZPSwynlxCZq793B8KivZUFZws1fYLudhXydQqnuDHpJfqPDIiwyxlaUEXt8C4JxKanUvWlLTf18dk+zjdwoErBCCh6xyhHjPFhg95ZavOuCKwEOZr8TMv890fs9/4/t+EVhXM5JFdhf732h1PvDpJL3j0pVX0F4COCBxN4oJHxVvnPF2LguYwcU5ToZCkS1Th/fiScxgHcK3gMLhvUy+leziDI1nBH2/1PX6ibTIhG8A+X108puPnjzhnOPpe7sTfBm1ZpWNKgPUlSEU8/TBhNMWWG7G6YSi6xveaDgOGcWv7tz8XTjT4aVOX4EpRzKipvBg2SJ1bVEJq7X7+OHZAu9HE+BnqqWYRXxpaKHFrNjCNyR7VLgdxz56vbhjhFNRhJzr32D7MSc4g2WLeM47dqU341qmPyEaZCK0hFM/lZnJO25zYBW6pWkqNEEOpgwifaQ2JGe5cF5JX3hfVFKi+LU4aqddJvIgIrH+3hVZMA4ruq/fHTSxPsMNXdw1gKB5vpKfLE0Gz/Cl7hlFJ0pBzNBMybvmwQPPNK8/0sJ5AahXTejenzO2MY60bftcOsRkfpb/VcVCdhnJg3nNil/bzljyU4pZeAF9/Q0HzXzMF
 zgdjv1s8
 jnRiOn3uTjTty6JsFyKCCTGjqzIVvpAg2dJn2iNd25Rt/oHtDLs8qbPMAFSeDb5p5oLxvNmFz3lsNu/dfQ7jCBB9LBI1mKrZtE/i7oIKxpCR8HX5sNh8N6adHy4LVEkWNJHvtzhK09oyqXymkP40CSoxETB/D1q18gpNZ3/709hZrTrk/+Uhc7XeU0mrAqq0dycs2ZBuy8Oeju0ztV1s9iqEGfrGpmEILf/FiFkDXPETGZ/IRYpBrjrvhqK8Z+nLQ/iKzU5TT/CtAzzSV7QBtSIMChf1tK5A78lfQeav9TegtT+WeLnhvPdFSPMYE2nZhtOUYnpCfpY1cA2dRcXYNnq7vW3mbCXN3M1YVN3ChUiV+1UVBm3B6n5oTyY3J+N5n3l7/0PgbnvwAS7jy/NljROYNzIPW1FMKpHK5WFX18bs2JjbMhBPjBlhgEANKhUWx8AYA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Yes, we would like to backport this patch to the 6.6.y stable tree.
> We have encountered the same issue on a product running the Android GKI 6.6 kernel.

This is not a 6.6.y fix. The NULL deref is only reachable through the
batching added by bea67dcc5eea ("mm: attempt to batch free swap entries
for zap_pte_range()"), which is v6.12 and newer. 6.6.y has no
swap_pte_batch() at all, so the exit_mmap -> zap_pte_range ->
lookup_swap_cgroup_id path you are hitting does not exist there and the
guard would be dead code.

Your oops is on Android GKI 6.6, which carries the batching backport
downstream - that is the tree that should carry this fix, alongside the
commit that makes it reachable.

-- 
Thanks,
Sasha

