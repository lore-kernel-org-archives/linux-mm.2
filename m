Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 555A8CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 23:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005986B008C; Wed, 30 Sep 2026 19:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7A86B0092; Wed, 30 Sep 2026 19:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D526B0093; Wed, 30 Sep 2026 19:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD5296B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:17:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BC19C0265
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 23:17:46 +0000 (UTC)
X-FDA: 85271992932.04.DB93CC3
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf23.hostedemail.com (Postfix) with ESMTP id 328F0140004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 23:17:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Av9Dc2Cy;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 74.125.225.76 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790810264;
	b=GQd7sJ5qd+7grXqcycU65GK+iNksjH8t6JUY6zNQ03LeqJa//dyZAcU5SCUgSM43p/L53g
	O5VtblQ89mD1ruAjzWG260sXo9nx7rIgVeiMMyKK32WQVBafCtqbcViyoTsDxKUYsPmcNe
	WAFKNXs4bCbIfKhd53OLLGg9/QTghPQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Av9Dc2Cy;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 74.125.225.76 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790810264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Qqmx+w7wWMgcq8gW6PkHYUS1zHw7Tje/ih/ffys9GY0=;
	b=3IPLsoW5iOApSQQRyyx50J1+GAUfYm9Mcl1rxdwNXLmq0+OAT1LvBRIshe4aa0G87/zYHT
	SwjuSxLFz6XPtDwFLHk2MX4WJ6kL6Ubo2xJHdOVXWJK17LNlkQ7yCGZJTrgaY1ZhSKNfEH
	Qu+HscB5yC9FNZ9SSaauNOS1rGlAhIQ=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f63546c3so4600364f8f.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1790810262; x=1791415062; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qqmx+w7wWMgcq8gW6PkHYUS1zHw7Tje/ih/ffys9GY0=;
        b=Av9Dc2CyfaMhs6s8V+TAEiI14qdETaVMkap45Utw3swsEH5+3a2pE2bxo2JyBK8sKa
         El4hNURUo/mexCpkORYBt1Y/KOBtsaOiNkVmYfeOiUykrvWnEtNEcgRoACyniJSMtW48
         jCNPRdukv2nN6K/zCrLplganT133wtv9buFfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790810262; x=1791415062;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Qqmx+w7wWMgcq8gW6PkHYUS1zHw7Tje/ih/ffys9GY0=;
        b=cOFuK3CaHmkZ8TK0Au6z7PG7dQobge8znNAOQYcxzCRW8uegC1D7f9NwM7lvQS59pq
         XN4SUzIImWzLdPL73z5itcfBS05zB5VLmUi+3GTkyPp7+I7F0m+yUW5m8LtGI9hqIlPd
         E/MNHicDn4HtpDbbxTP5cFpt7+DZ00vQqD2LvOACbho/GQ6UxILViLaF45pLo5ljZuJ7
         iepL9yzQa6s6QJrbqQB3lQt98TcTfHNNt+Zn1DCggmvXrlH4kA8dYJE8sfQZktCBulkO
         uWAdYTgcw57FxO7/Z74m+aOPiQoKQIOQeXWh2xc7/VYsVgJOhGds9EmLPp+99JtmscuC
         VXuA==
X-Forwarded-Encrypted: i=1; AKwUvBySo8rVdvZflDr/8dmisdxsaIkRSbhJhv3H9P/+rXfCRfX6fzbNFHESE8I7b9tVmHKCsPgATyHwdQ==@kvack.org
X-Gm-Message-State: AFq9FYJcbljyZWlQNXLufKjepvgmcjNkR/Gzzc108I/36mEwU9JaiaIM
	01jlJD8zL02MQnMlx0EJspQCSZP8WL3SVZZ5KBpuwD2cgeek4gs8pJu9tG2dvwIfm8E=
X-Gm-Gg: AYBFou17q6ogDcc7qol3XulSYIAxW6RjNNU8Ss31+FMjrxgf02NIQDp/mNfpZ9nHlTp
	5DKXStPSVe0CYQW4ZWwCAX0hyWMjhmeONetSAbDJGscB46IopGoL0XiEk8vo5/3rNwjC3OAAWvs
	PGemrrl88GdfuIzgpf3W5aFsES9nnz4nIG2LTrBOCauaoncmrD5Gdl8L+ee0yJ2O7THV8g6IOHT
	SwRk7rdjQB5nMTjv0gIsIsERBSGnGq1Qv5t+ytkUw67GDTUsQKnUbw6jLV6/U+E9tkRRCgH9E5l
	Enxdvz8xK0KO+M2GpqoaC/5XmXHex/r8ilqvNQBnigLKVNr//Dp2Ba7QGsjL7YfIPNwa4u1i+XT
	lPqPzekQJGwGAHNWsh1jkEbIECKQa8IGqEEznUbwH3vRlz4PxET5f3iIlHPwCmo7LuUyEr/jNIN
	g44PUJpUupzCXSGA5gFMP6P2o7rWqVaO1p8s/IH9cee2kpZQ4mrcrlFPP2JIQGlcCj12DrDjZi0
	x+YLVmN+i7P6MxsEiSUIb5sq60=
X-Received: by 2002:a05:6000:4811:b0:488:8546:d0b2 with SMTP id ffacd0b85a97d-48b0253956cmr6174897f8f.51.1790810262482;
        Wed, 30 Sep 2026 16:17:42 -0700 (PDT)
Received: from localhost ([213.61.32.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b0690e060sm2332276f8f.19.2026.09.30.16.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 16:17:41 -0700 (PDT)
Date: Thu, 1 Oct 2026 01:17:40 +0200
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Kelley Nielsen <kelleynnn@gmail.com>,
	Vineeth Pillai <vineeth@bitbyteword.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH] mm: Make swapoff interruptible when unusing mms/shmem
Message-ID: <ar2YlFYjYUZ49ZA5@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam06
X-Stat-Signature: rc9shs9utoxrnisubidt94zaa3e7ayrk
X-Rspam-User: 
X-Rspamd-Queue-Id: 328F0140004
X-HE-Tag: 1790810264-669632
X-HE-Meta: U2FsdGVkX19zzWnrs/FFi3eOBqlUkFv1KBYbmdycauCvUiaD6kih8ZKXq/cIGII2NihrX9PSaf1eMkqAqq2ymSgHW1geHdvP7r+4JhiFdr125irA0qz7xkHlweLD2GcrLiXYmJYSNFBxcmR7uxoe6iy791H5eQkWnQh/UoCK6/k3E06MFm8lE8bcasgQz6hLg/XNGSMsbZJzG9/MiOzFpLJIOEDxLp9KamqLIvZxwrHmYfCoU4qwsiNm38S4qREiO4rScNRntj8fozGL6lyy3shkAL7mC0kSVKPDp2sZV97Qhxfc59PYtOibYpIMONmGyLpCvdAd1wJRLJFWto5U3s+DjxfUg11WDbhzWtwtXa7irNjPLgSh5XYha3eQo9yPQCnJs7TvLUj3YNecDtd/2/1aRe9GWJpOKiX9/DgczPuEmJuxraqjz/sJ5nOhdSvOaPURkXYYBEEWkGqnDLV98EzDNOOvFlVvJGeT26KQf3gI7vSyK7ZS6fIJdOKBeCcnPR+//R3Z6flg+UOYUWCLsnTi4850R57F3KWg2/RpkFsnuQVt9HMDeskA2XJN1eVK9/eHRMmcrXdDoXfva1wgBeol/uWpyudBnG5b/MAMduW9SI9CFBpC2LJYief2WCW2OUHaQ5UDt4KtW7fT0ClPwmwEuLKmVULPYk1jm3oi5S3VAGkyBpFgb6101i9LGO2ctz1oWyvKeMYiqV6PRPlUATfFXufRp+2DMBmc9mD3bjXDYAg4XEoJN4xtRwnI0dNOc5/4KehqI1qPRbdlgZ7O6WdLeseeKfUFXHiO6nPi12yu1x8D59dbmFBeJW9LBw9mmQpkf8AYD6cDBpb+BBkj1YKjcSZsdNJ/3mMpzOMDdNBo06mAZAEFLhAhmt78cFeAkytaVhE3/1PtUMxlW3w1qqmjhQGQqlSzDvBAi1jSMEzM+HjtdJrVezePkdcHK59CwbX5Styl10aWTDA4iQP
 W/x9UvnM
 5xaKsJmcx9WHpp0gNeuKkDZ8TvAhoymDMvFjFa25IPF227nA5UnGUdgISbB7c0GEUSQYsfJ4M9x4Q3DLX3warrkF0wN5J/oRQHRXUbaEqz8QIkyBpIeiv6ot4Rmqq2lVoPBs2VbRXBdUmB9WvW4dOmTzTBL4d9YOx/utfynhFXZAdWD0ePpXBVSpB7O3BGoLPxJUT4wHIi3ULnnXLxCJCBXQTQj9MbddfJEWU8rdW6U+6hrGl7/LkK5lTzVl8gFSQXywamm2pNSNzXn9yGLI4JB5WFDrZ2b6hCXQzqBGgJ+lUOUSh6T2LG8IjwQvhkWnNc1t8UWOX7ixtp2yIe7TfugbWUY35qeikO1jYGgm2eqakknD8t8CZHY95KZBoB4RP1vB3i0QXNNREGdOcEVK6FIdfe8R7DASEOJF7+X37wKcv+/+8V+tkJFeQKQTJWZ7E6Zzvr5n5HSeBoX/rKhBVU+6k632A/kJWi31JJgFTxZqT+wK7DdgqPUSJFAzhGtr+t5eHsjL/7F1N6LJJU6i4tCK8zvS5wxc3P90J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

try_to_unuse() only checks for a pending signal between mms, and
shmem_unuse() doesn't check at all. That means that once swapoff gets to
a process or a shmem file with a lot swapped out, nothing can interrupt
it until every last page of it has been read back in.

Just as one example of where this can concretely show up, freezing tasks
for suspend or hibernation has to wait for swapoff to notice the
freezer's fake signal, and gives up after freeze_timeout_msecs (20
seconds by default).

Here's a facetious example where one swaps out 2GiB of one process to a
swap file on ext4, starts swapoff, and half a second later tries to
freeze with pm_test=freezer. Writing to /sys/power/state then fails with
EBUSY and this in dmesg:

    Freezing user space processes failed after 20.003 seconds (1 tasks refusing to freeze, wq_busy=0):
    task:swapoff         state:D stack:0     pid:3175  tgid:3175  ppid:2955   task_flags:0x400100 flags:0x00000419
    Call trace:
     [...]
     io_schedule+0x44/0x70
     folio_wait_bit_common+0x1ec/0x3d0
     __folio_lock+0x24/0x40
     unuse_pte_range+0x2d0/0x348
     unuse_vma+0x158/0x248
     unuse_mm+0xfc/0x150
     try_to_unuse+0x104/0x3f8
     __do_sys_swapoff+0x220/0x5d8
     [...]

The same goes for anything else that wants swapoff to stop, like an
admin hitting ^C in a panic, of course.

Prior to commit b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
try_to_unuse() was driven by find_next_to_unuse() which checks for a
signal before every entry, so let's restore that behaviour.

Just as an example of the improvements, here's how long freezing takes
in the same test while swapoff is happening on my computer:

                      before                  after
    400MiB anon       8.925s                  0.028s
    400MiB shmem      1.639s                  0.003s
    2GiB anon         failed after 20.003s    0.011s

Fixes: b56a2d8af914 ("mm: rid swapoff of quadratic complexity")
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 mm/shmem.c    | 4 ++++
 mm/swapfile.c | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index ae08cff4500c..72c8a61db76f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1742,6 +1742,10 @@ static int shmem_unuse_inode(struct inode *inode, unsigned int type)
 		if (ret < 0)
 			break;
 
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
 		start = indices[folio_batch_count(&fbatch) - 1];
 	} while (true);
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 254ce86fa923..c3288910b3e3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2689,6 +2689,8 @@ static inline int unuse_pmd_range(struct vm_area_struct *vma, pud_t *pud,
 	pmd = pmd_offset(pud, addr);
 	do {
 		cond_resched();
+		if (signal_pending(current))
+			return -EINTR;
 		next = pmd_addr_end(addr, end);
 		ret = unuse_pte_range(vma, pmd, addr, next, type);
 		if (ret)

base-commit: 2ddb90ee544ae97215afc4698dc223293997cc43
-- 
2.50.1


