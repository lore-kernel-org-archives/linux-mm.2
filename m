Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C29C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 13:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413216B0088; Mon, 20 Jul 2026 09:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4516B008A; Mon, 20 Jul 2026 09:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC3D6B008C; Mon, 20 Jul 2026 09:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0201D6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:24:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0DBDC0148
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:24:04 +0000 (UTC)
X-FDA: 85009223208.14.B11133D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 24B2040003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:24:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=WDJ4beNA;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784553843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BkKV/CXdplTRXv3/Z7GA3DMv5lr0BziwgRfgXCsS3o0=;
	b=vx7wqsePWGtjdV4YoRwLxycQJc4D956Diq9FmHXOfmM1abMfFcHWJEQQ+epwStJc26MuUz
	UmHmdVfeNshxXMxDG8qhp864l4RhgAM2ko2TvQMPTSIIN9esOZ4csA0nmE/V2S8cN8Q236
	hcLAjVvF2ySTYuNqtuNBwkXzyHd9frE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784553843;
	b=Y7hSzqu89aiJlGYIE9/6fnyiR6piEKS2aFQM/6RC3R/ksrNoYiSsoCSYY8rf2e4baHa+iu
	3mr4sIwle4FsSkqSjD7SDRHFwIlRT1hNjzhyZ4sJ23p+pB6WMXJTMSCdgQZXmT/NctkIrA
	Z1GZGtEQubFTTji8kRLlBWE6st45Sns=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=WDJ4beNA;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=BkKV/CXdplTRXv3/Z7GA3DMv5lr0BziwgRfgXCsS3o0=; b=WDJ4beNAvQwsduVlfMQF4N9GDi
	iKsoAJ3xMPMWfpHtmsQ8qx3G7zxvvj0NaLK5gb7wdiGXoq6y4XMf8mMtMhZmzqgdc7Baqh2mzN4BP
	j4W655BXOjsSosmYNE4tmdhcjNPOQDjpliQLwQSEOxTlkmApNZvltu2gnm63lHeWZNJRNUP1C9HtV
	kIXr52sbeDSHR+YYmfBN9qif2TgR/64Lg8G0ptl3gTx4sc8n1gRWAqch3sek2GAOWOir+DBEqyI3J
	e7cHxgz+G42ZnviTZD2/sTNWh6VWJ7FkCXjAPfA2jgUqgt4OS/H0ljpmjqesK5BkFMyNfOGeEVaYr
	Un63osog==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wlnyL-001Svl-18;
	Mon, 20 Jul 2026 13:23:53 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 20 Jul 2026 06:23:45 -0700
Subject: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during the
 scan
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
X-B4-Tracking: v=1; b=H4sIAGAhXmoC/x3MUQqDMBAFwKss7zuBJBbFXKWIRLPVJWolaUUQ7
 17oHGAuFM7CBZ4uZD6kyHuDJ6sI4xy2ibVEeIIzrjaNMzqtvC4cUp/Hb/8JJek6VhystUP7aKA
 Ie+aXnP/z2d33DwD+DUZjAAAA
X-Change-ID: 20260720-kmemleak_rcu_task-6d3ea111b947
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@kernel.org, puranjay@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=3492; i=leitao@debian.org;
 h=from:subject:message-id; bh=NX7o9MEnwBb1ZdXMh5zfcmhcQEOlSll9tKEHjzqLS7A=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqXiFlo5lGAhVSbkXtGZupsBhc+o/hOqPdZnkIJ
 +B/Z5gA54KJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCal4hZQAKCRA1o5Of/Hh3
 bUQSD/9c06m08PmDxKH4FhQFDUkA5k2PwriF3G4BpAD116tKr6TOrp/Qx7fSEKsCc0+71yP195B
 yMtmuOi5wSWW0JXrMGxljEckTDoo4Y6rL6lefCgbdl6d4nH5ssLbShttd4PjwUFL2vFOyRl90wH
 1whJab+QbHm+bkvaoPbUIwoxD8twoTnXWOf8nJP6V6D8Q3A1qqjDRXA6eiI0+zg3fbICZjcN/xV
 xtlsHoqBNXhqxSsZqyBJME8eadY5OqhS0g9KoqBqWozC8vwQHD8AY0Z9sxc046141YaenpfyZCT
 9gjJxuxARdo/NG6IftpcZ0ZyJcCTA7GDmoPMtUAnskHtCh5Y2kgNlfDrtG7sAYzdxeO6I54c8dE
 XB0ZwdVVEUUnPY3V+IetXbCuEvqxqbTtqpcJMyT59Quqd9u67ol5ATyLYZqgTL4yp92zFL6aUHe
 3pn92M7KraNZ8Lbvnn+JMjC5caRw3mQed0/tBBTYqfmLpvPWlbrhxiDiH7DKRFqaMpzIhEIOg2b
 qyOVCqqVE00W0RKNAUhmRiWjDrMU9bHu3M+TXqVdnSI8RXf4SGC8ymk6Wwrpn623GPPKAsxIkcw
 Sd7lOgNErLvTBcukyL0rYO1FT06lH/AqqMcy/MBtvrIeP4LxlYd3jZoY0mHB7HHVfAEVmFtJZnP
 qrAhTeTp89a0wXA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 24B2040003
X-Stat-Signature: fsbp86bigxt1nhtnsrnfdytyxs4jiwc7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784553843-707491
X-HE-Meta: U2FsdGVkX18TJ3Mktd7CvzBMfQVeQPKSosu2gIEAvYj6Wm0PnZYR/mmlnYf6u27/W7wxFF9U0RJ0vNeIYVIau5S9SQBWzZApWt0YQiq1RNZpZYBrzEuaGADBTfP5W7AwhaWnP3S6nXn4jfB+0UyhHUjeJXGa/JJwW8qR4e0qYZGhLHpbj7pkBpr/ckQdcwdf/h4wQRk6MPJo4QxZWUoz04kcb8P9tC8c66aKqW0j6HoSvxCjDHRdlp7MHX0rCipjL83uMrPDZ1F46hzZawz032tuh1Ce3a4wxHkJW7bDdXpKfuTIP5ZP91zFC83ujS6gutuNyepqWyHym6A/PNPUrBjlJT74c2i0bOpziCRLUzTvdwyarAJlyWGn6Ynt6OeQmEzf4USFGzv7qZnYHXWsIY/3tEK4vkVjgT5m5uiBYV43AZO0l+zqTH/PIonXASkiYBT+Xk7y9Ckj2atgM3AYl9lhKdQ2VXcf6PPwnny6L34qJtP6VMs3oFlSy1QwP3/L1C5e2jlbNcpG3ZHZAUJeGMC8d0FTlEQHLaaMXlKk4voBokSduD6LX+Bg7heMI2xdaz74kOQSKbclI9llNU9t1852xcqRQI9mYNtTc43sfdRQVla9iWUpu0GToK7RudR9uHlCaPk2g+ZxNX71SHhaIX6MXRvEL+Kf4xNghIBuzNWo1rxx7/U/3y5VU6zmwBrHeeD7cZFimxMoskSTbj4n/WyLeLqQ+53cPrPl2LZcOrgGmYk7p8VaecQZ4/puqffKVvzHL5UgpnXAc9YvmdBojY4C4gX6cYXfPKKZ78mI40Q0ytn3U1uTjzNKixZUXCVLi5IiXlCIk6PbxQiloA3NH+g3KyhlYndUlf57AEKn+zZJLndjzZE+QYnJY3rwWWTZKiOsd//0cyiN+zxtoglo79+I3rl1tlTN/E/d9hsdEmfDcGXAjOyzCSJXosHa6H3eDqZ/HD5Sm4NCWaTd2jc
 Y1raQxU/
 SCSYFP27XTBuSHTFSHQaf7wSFvl/9VEcLag86TMkTV2dXNPh2lhwc2SAb1yEwYEDlv3Cs/YAlzPJKcQZD8LklMj/xHLlpRA7xMMZc5531X+XKm7UUsotR2TUWcR/PvXq22eoPicqcFCYbywimvIEjh175WKXCn5eTH/fWeRjXvcjOTt4uRn/XYqnQ2PCdfrAa4YdAUdKXrQEYbv2e60DMXYMW2lnSb+suwX3E1BcbyOzx0jjVafhgJw80Y1ml3mgKTBMMdbXQnVxIJMyYwGLBx0W3uAToAVuwadng
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmemleak_scan() can run for ages on large debug kernels. It was
causing some soft-lockups which I got fixed with commit
3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
stacks") with our beloved cond_resched().

I've got the fix above deployed in the Meta fleet, and now I am seeing:

  INFO: rcu_tasks detected stalls on tasks:
    task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
     scan_block
     scan_gray_list
     kmemleak_scan

and, worse, blocks the callers waiting on that grace period. Here a BPF
struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
call_rcu_tasks), is stuck long enough to also trip the hung task check:

  INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
     __wait_rcu_gp
     bpf_struct_ops_map_free

Then I've learned that cond_resched() is not an RCU-tasks quiescent
state, so, we need to use stronger primitives.

Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
reports an RCU-tasks quiescent state as it proceeds.

Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
quiescent state for task rcu").

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 85f18b17e79c4..f63dfacee7ca1 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1586,7 +1586,7 @@ static int scan_large_block(void *start, void *end)
 		if (scan_block(start, next, NULL))
 			return 1;
 		start = next;
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	}
 
 	return 0;
@@ -1623,7 +1623,7 @@ static void scan_object(struct kmemleak_object *object)
 			scan_block(start, end, object);
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 			if (!(object->flags & OBJECT_ALLOCATED))
 				break;
@@ -1645,7 +1645,7 @@ static void scan_object(struct kmemleak_object *object)
 				break;
 
 			raw_spin_unlock_irqrestore(&object->lock, flags);
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 			raw_spin_lock_irqsave(&object->lock, flags);
 		} while (object->flags & OBJECT_ALLOCATED);
 	} else {
@@ -1673,7 +1673,7 @@ static void scan_gray_list(void)
 	 */
 	object = list_entry(gray_list.next, typeof(*object), gray_list);
 	while (&object->gray_list != &gray_list) {
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 
 		/* may add new objects to the list */
 		if (!scan_should_stop())
@@ -1708,7 +1708,7 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	raw_spin_unlock_irq(&kmemleak_lock);
 
 	rcu_read_unlock();
-	cond_resched();
+	cond_resched_tasks_rcu_qs();
 	rcu_read_lock();
 
 	raw_spin_lock_irq(&kmemleak_lock);
@@ -1753,7 +1753,7 @@ static void kmemleak_scan_task_stacks(void)
 			}
 			put_task_struct(p);
 		}
-		cond_resched();
+		cond_resched_tasks_rcu_qs();
 	} while (pid && !stop);
 }
 
@@ -1935,7 +1935,7 @@ static int __kmemleak_scan(bool full)
 			struct page *page = pfn_to_online_page(pfn);
 
 			if (!(pfn & 63))
-				cond_resched();
+				cond_resched_tasks_rcu_qs();
 
 			if (!page)
 				continue;

---
base-commit: 0718283ab28bc3907e10b61a6b4be6fefa1cbb2f
change-id: 20260720-kmemleak_rcu_task-6d3ea111b947

Best regards,
--  
Breno Leitao <leitao@debian.org>


