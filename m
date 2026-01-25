Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3C22E63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4BA6B00C2; Sun, 25 Jan 2026 17:49:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6B66B00C3; Sun, 25 Jan 2026 17:49:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6B56B00C4; Sun, 25 Jan 2026 17:49:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2996B00C2
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:49:43 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E933FC2060
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:42 +0000 (UTC)
X-FDA: 84371979804.22.ECA8F10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 18473140005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ct+/Hpif";
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/h8QDZ+sHBpzhnvHnd6Tsk6eiOFISxNm+oeftukpQuI=;
	b=1jv4CLNgD5+oELNLZnw/rCJguiyHUCh6Dm7mQwYCkN7jIFHVUyNcsUKvmoVGQKbb8Xx520
	OuIV8GeHpX90cxlp2FTtdAE8m3VRrFIZZQjoTRZ12WInMWc8AEv2Kp0U/bdhEbr4SIKcm3
	EC2eOelzgtCibHeVENIdncxVToOf2xs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381381; a=rsa-sha256;
	cv=none;
	b=Awal4phziAzdl4gIqY7+4FIKQOwPGMuREUcvV/Xp3cb52tcA2WexHsdvCs+nLD9vDIAKbY
	rs+RYDN6DspfIATIjZ3zA0lrj/XmvJQ3lZ7Xp7TmsaeT56UYNmbBRb2w2ejzPgkpO/xgaV
	FWHrI6RO2vjMI2eNh8d+OX5xSFKJ8xk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ct+/Hpif";
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82268600C3;
	Sun, 25 Jan 2026 22:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3229EC4CEF1;
	Sun, 25 Jan 2026 22:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381380;
	bh=txAoH54KyHKbuey5FYwPXMe7a123Tyjq6wOFllqOg9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ct+/Hpif4Fc82u2iven2KRFCFhW56c3/+0FaStQzwSlTMN2Gippl3VCDYfCTDGlsH
	 grRUbkAjXxFz8QNUB32ATVc6ffl7ouZv2PQIqbvN0EmXZclBnjEpbADbXDw8OYIS6i
	 RYSxBDD9lok+I+KvwO2sO129c1HXWc4DfBbJmfGbA7lLTnLjszzo8qkICZAnGRGmF7
	 SmjCO4HNh4E+cJw7qaQN1zg4efuWoM6ocDBuEXWoktF2g9cEtNKKAozJwfn+fhoVY0
	 zUgi+HoSWTvagYHbpkikZfHRj1znB0oDpDKy9Bc2PDCxrGkPfYZQsaq7Fpj4bCfnKa
	 ds8venZCqWWkQ==
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
Date: Sun, 25 Jan 2026 23:45:35 +0100
Message-ID: <20260125224541.50226-29-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 18473140005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: d94y38os7f73zbz3rxe9456ggyskhodk
X-HE-Tag: 1769381380-494438
X-HE-Meta: U2FsdGVkX19Hvgwjll8wxTGBMmZNk4HsxcZ0dAn02R46DlcKEym2toA87A9Ez+Mb9bWnQqIzeCN0RZwAs4BNkF4bdFqdoKd5fiUQHJR8b7slXx6HHTgdGPAW3n2u/4mf4Cl2mSZAwmHI+yD+xLyxl4lTn+/Y97tlVB62LiCnhQdKdt9PowRMKLApeq1+4BRACtG3yuRBm7OYJYByqgKubQjVRGbr5CMJwOQmPcpHtKUk8hw3PY4NBYxy4U/5D/72XYKhlwrwV+KRlUNP9mEQRXaakd/nYBkI33LBKnf3UKzmx9uZtlXKxAaFxGvqocryxQuwBw5ZEbA2Mrk3Awhpn0fP600DiDmD6EUrjIOXllH6AbjdgTVS5Cbep0WxGBzK07ZuhipNhbIeJosADObj2Xfv9IGeM/Z149U0gwOS622R1VHe7w+X6ncW99caNruW28ktfDBa4+q16jBoyiXHHMuqybNbs1GZpWdCp8BZTSeVnuTlG0S+CvDtlSxMtC3YYGG9cLYVgCkR4c80diLBDPv9Wr7QtMLWGGBV6mMKR6ppnoESoc0wj/lYsB5ceJACX9iK/6Qej5CCpxnDCR/87eXAbmQ//Y/VsNGNj4JEZ+1Yy07m7n1nIG36JMnS2q524AfC5vtGMCr5+wh2wfLCron+Ty0JqRTOMKZOtDN7FoVXC2eOmAgcNjSyKzFd2v2GsKFAWIQ4PF+OS5wkqooP80lq1tohkpj+sm9FD+eYIG8fCDzKx48xdlc530JGxFR6rHvZ/LT7xYYVOJt8bkDqr0O01NN7FzRGTPPDOczYKtPpdARDZv6SXyLeonGUpoqJK1SHscntB98xm/egaDNYM9zSDXzFxpHVZ3toqSrQJYAc96I9/g9vRFaaxe6Q7pvyttBFyduygtbZUf/TCrWgaRE1O+f+ZCHgbspidyeHlPPIsxA9nnJkVPcmiDqMm8Mq5mNyaVO4eHP6lZAztTk
 sxULoTXt
 Ofolz7KD2co2FVcQMSmA01lWjAbTF1n0GQpDI7tb/soAyh2k0AQXaIEo8uW2AC/wXB8mPJOpYGDjT2IqqamX1I4qO3tZcBV4kUvOjl6N74SKhLu2CVi1jGfIBdEno3mWRHrf0z3GpU1t/GQlY4YEJ4yvNSNd7A5SJl/d4cW2d2vUupJKfJP3eJ7NbHR9xda0kYdjkhn/L1vf/tN+9QO88UBQ3raFcCc0KkXoRoNtprGvFWS0Cq/YwL2v8Bvc1Vpf2FJ6MWIKxO6TbFyb45XT5h9kk+0ddI6JW5wypIdlR2S94dkp0LIM8Od7no70m9vVHUiZGxXADjs7Yz/TAh8ZCuzGGbw==
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


