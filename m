Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0691EEB57B
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB176B00C2; Thu,  1 Jan 2026 17:18:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD196B00C3; Thu,  1 Jan 2026 17:18:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1816B00C4; Thu,  1 Jan 2026 17:18:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5036B00C2
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:18:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF8B4141587
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:05 +0000 (UTC)
X-FDA: 84284808930.17.21A57AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4CF11140004
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:18:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nGRmEtfZ;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/h8QDZ+sHBpzhnvHnd6Tsk6eiOFISxNm+oeftukpQuI=;
	b=e362XALE5BKi96iokltA6waQhl3neTBAL/9BmlEl4iOfEaz2RVip9jtoyycHziIR8bK6Eo
	byejqPQvOvu5Uf8FibNY0G4FbaP2tOUABo2SJ0kczmTiWm9X2v8YuZ5B1JFTbNlmuLb1rO
	bSSy93H7dHzQkTCNFaO79jKu+BKQzzI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nGRmEtfZ;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305884; a=rsa-sha256;
	cv=none;
	b=uvJH2ekCDndtO3i4+Wlo75ZlXbRpn514qHjmy5KRrTklIufGpWrYY0QmzzzvDyAxSmPEH/
	1ZXvv90IJ3k0X43TfJV0bF1+TdTA/HxnzVBFi8VC0SxuYzgeogtIG+xul7nHKt0BrRgcOX
	eE/MCgE2n5EKYEvdx/aylB7Kzi65pGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3783142E16;
	Thu,  1 Jan 2026 22:18:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB81C116D0;
	Thu,  1 Jan 2026 22:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305883;
	bh=txAoH54KyHKbuey5FYwPXMe7a123Tyjq6wOFllqOg9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGRmEtfZf/dlvXTRXeRug3jmfNXg5p3dx5FKXhG8VpPBiNBxtnzA4f4zq4cdvK7V0
	 Ajv2d1SdcQZ4WzUAu4ABDGC0IZLHAPLfc+WCdf/60Sme5hDBRAFCB6xCqi7jDHK8TF
	 4a2XPX9edzLhaEeEVfw90VYwjSLfjgww8JY6aPlYilZjglIbWHfdhP9hfdMKGiuMiN
	 CVr1nXXYlRlsxaU9eYzmlqJotqeOlCna/rZcx+YxZrtTiAiWR6tsZLK7yNbTl2KOPM
	 rXK4eWyFydu9GzHrar4isymMZ59ZNyAzDsj4JlDrWOfFfn/6xBWLEiO09OJ4w8+hTe
	 V7cgvK/o6R8RA==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 28/33] sched: Switch the fallback task allowed cpumask to HK_TYPE_DOMAIN
Date: Thu,  1 Jan 2026 23:13:53 +0100
Message-ID: <20260101221359.22298-29-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4CF11140004
X-Stat-Signature: 1b4zes1dbmzgng58uhpbdpfmk6ge7bq4
X-HE-Tag: 1767305884-241120
X-HE-Meta: U2FsdGVkX186J29zymRcufgCsUOq1q5fRMkO5I5oIxRbPn64HnAuJMZr1dGtS6kAM5zXK0xSsZN3C1SqPIfjuKhinu/NNqfTmaq69DleDHJKb/by6mkCAl793T8A/v56NKUsb7OjK17Rhvs6xV2mRhIdxc0RDQ3iJMmG5GR8SbUjN11pwwzbkMnWLgzSAmocVQ6o9HM7unqOllVPVCp9MuEcsf3FemAMhUKvaytJuWzdaazxC8tPwcl4UwywcGe6DaC/SD91LiVBtLA8CzwdiEpUzXaTP9hp7hy9pfqoMzSIK2agnHodXqr20adPeHCUbhS/RjsEbtHHcU7z3VBGKf91RsO0V7L4NlTjvyDGx6bqeYG7S6Is35VdrUh3G8jipkgC2vvTSmO2lKl1iUk9SDuIoeSgeFsBlhPaKtzFiE6eAXy+M6/rR7k+q3W5RcaNaM/JxjMY+hDuWDjM7RkA4C6Sw7E0MupOZh/wIhgWJBzuJy24aCIuQ082ZXunKboQiHDjM5nazxwBCBRL8i4RyE6HltfYdVNSdB7SWsKyKComkWxD1AcndEAm2gfMsVKqZI3QcT3uLGPT+kupu5FfaTqDjvje+Xx+5lpBsvPZjksfbBqKbdGW/BN/ZGbKwmmGzRGuPvgDc3eOJBrp/meSJXpKhMNQb6S/oLawUyAr84tos8iXT0xeQQ4aUaf+jwHkOzTxctj4PxXc8PU04vAa+bs5JwzFKJZpR5sEyLyE01EbsJvh8LyU3y8pPQK089hA8CG/Y56mHU2bEOCU36WjYrKDqSH8/bIQUmmJn2MzAyzYK3ThhKVwS3HrzxD2teNvRDFYwRsUFN0bEAKi02luqjz0sZGDX3o2ZXnNiCspmlS0g9hcRjkShgGqGWKRyffhoSy5EG/RsEmDeE44stG/E5yQxM/ss/9hPdErVh9wad1Mrzv7FEcgtTspq+IffNLvrt7dpWrPJTgRmvfdezF
 plZObu4p
 EkuL9SHIAr2xQFS2FDdNWq/iK0f1dl3D1jVZ+Ak90CZfrL8hhnKSAPPTZ+npMUteILnpowBI4Wn77NjflCXaljDgat9cDxOVme/D6nvbHAPY/rAuByV91n0EjTN+f7SZ8X1jmldZpi5VOgCZj5i2zNbRS0ZKI0sHsEP3PzHBtGdr6tpR4sxYH19GQ/sc1qKcf1s9uNfmuM7fnAsRooHvUm798qRkO0DjETTjJtb2tgF5DkgnCuTfrQkbvnd56gnf2bu1ydcH0zhFExp+R3qS4Z+lWTVrcVQUbvxQY/kvBl0j6cB3MU0E2bhaROPxK/vmm96sbnnKuzHKRR9x/sOLNQ1C14g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tasks that have all their allowed CPUs offline don't want their affinity
to fallback on either nohz_full CPUs or on domain isolated CPUs. And
since nohz_full implies domain isolation, checking the latter is enough
to verify both.

Therefore exclude domain isolation from fallback task affinity.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
---
 include/linux/mmu_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmu_context.h b/include/linux/mmu_context.h
index ac01dc4eb2ce..ed3dd0f3fe19 100644
--- a/include/linux/mmu_context.h
+++ b/include/linux/mmu_context.h
@@ -24,7 +24,7 @@ static inline void leave_mm(void) { }
 #ifndef task_cpu_possible_mask
 # define task_cpu_possible_mask(p)	cpu_possible_mask
 # define task_cpu_possible(cpu, p)	true
-# define task_cpu_fallback_mask(p)	housekeeping_cpumask(HK_TYPE_TICK)
+# define task_cpu_fallback_mask(p)	housekeeping_cpumask(HK_TYPE_DOMAIN)
 #else
 # define task_cpu_possible(cpu, p)	cpumask_test_cpu((cpu), task_cpu_possible_mask(p))
 #endif
-- 
2.51.1


