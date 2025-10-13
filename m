Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C9BCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931BA8E0084; Mon, 13 Oct 2025 16:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909428E0036; Mon, 13 Oct 2025 16:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F308E0084; Mon, 13 Oct 2025 16:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9D58E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:35:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CD0F140583
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:14 +0000 (UTC)
X-FDA: 83994245748.07.3755FD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 94B8B100011
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:35:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jrf+Kg2/";
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9uIEvkay1m9FXLKL6nNfa5AWTjTifx45z4KghX3hjOY=;
	b=jj9gS249Wz59UHlNu1sLEK8zbOZVUq7qWJbFnYNw3+5jLHxOXp6CCFDlAl0qRERVlaP2No
	mPYxFfXgGEDI9FKrsfevQI43i+tK2iT2EADS3H1hHznRwzvQci11dT4tounGMf0vd7hM1c
	Kz1ovy/tXtjZrVW3Rh0OcTAnnc3cZHY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jrf+Kg2/";
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387712; a=rsa-sha256;
	cv=none;
	b=T3LMmojsYN2vjES6uXtyLaaVocjrdUl4U2tNoaHNQ+RpzKBB5+b0C3lN7s73X9PlHB3cU2
	2fTmkBEAWZLcAF2jU54I8iBlGeyWvDBaFu0j5ui+HBcwDsQYAPcoRDkLShQwwG2U/E4uSP
	GwGV+rM5pu8IA2omFqbYMlzvq9vHCgI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C5C848C28;
	Mon, 13 Oct 2025 20:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE4FC4CEE7;
	Mon, 13 Oct 2025 20:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387711;
	bh=Rz519K4RzNFN9C7FTifkrc2s4js15D9og5elk9stWlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jrf+Kg2/DIvGCNfyCdPFH1ePE8ZtLXxlazjx5t7J+NDYTQdXxH1vJ2Z5Scm1VwP5a
	 SFKQYCjcRmfVTw9Fxi/xNljzr9UonGFOBfXxE7QbiWus82J7VAHAAxWimL73PWy8sp
	 KQUXmznsb7ngzcRXbeFT44rPWlDAU+23nOBfivg8Tdib55Ha8FFtUFqYb4WhKj7Wdb
	 xqn7qGyWBJJwWe38QLQztBFP0hxmcWWMmsct/VYNHEJMPHbsrHisH8W6evGfhEbgWE
	 qrozZxBzKyToJTV/iTb78znyKyHVL52oqRZ4h7NX0lZJzJVoUCRjEH6fXx7vkhe3gn
	 JrvAZ+P+clgQQ==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: [PATCH 25/33] sched: Switch the fallback task allowed cpumask to HK_TYPE_DOMAIN
Date: Mon, 13 Oct 2025 22:31:38 +0200
Message-ID: <20251013203146.10162-26-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 94B8B100011
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: d8hhya56b3cbfsyrawcijki4cu6eprbe
X-HE-Tag: 1760387712-914882
X-HE-Meta: U2FsdGVkX19JXMGQcD6PjZeobi56pmJ3B9doA4xX3ppE8urSHBSNno/T3qy/Wgef/JTJQPVb0HlV/SJ2WUl1f3QdbU0S0CXfF5S6m52cJA2drtU1wm95NtQ0P313la7zpzAcKq4uszPpNSiB4Lf9Ix0UZJN3C0z3yS/dr/O8b2tSzULseQNa6sq4UOB3iU9bcL+iaQ85NJ6LzFSofyhZ4fEk8TC/B4E/N0MqBICd7DHePCoDuyMi63EFKoG+3uTYStdQP1eyHleIOasieev/edZJvn24iMPkEaHw/KYi431HQ5FMHr1q0FccNuJQTrDAsyVAzaiIqDtwbOMqdH46PMzMO2KRg3dgKx1GhFjPhcqHAltnsRpXJSid7ZE4jtnASXwn68skMFbhAwXw1pAvocL36hjPmbjlwGU/5PusYJpuqNH8ZJNMmaaOtPaoREydJhkl0A4gsRXhA42Su5lJ+JCqMqkXXII2bECoiBg13LWvlOH5xy1CP9KZAz+AEB8Fm3rIUM5cxcBWvpEHZuIY+MT1ZayAOakLFkQRkZsaXGV7WxBNMm87V8cTKqizqyx+eHGgl6bA6Q3JFV+zvrSBTgZnvHJ4HQZZorRyWvbCdyrapEG+nk6SDJozLQm3CDECx523IVLiwbUK+gOd5+NbBZ+137kuzmIEItCIOGH08rvqm+ZHqnJHTAKc4JVqxUq0X0Oxs+2qguQbBQpdlj82eClyGd7nTNb9Tp+60vV6++Qc8cDsGlOm1mvJnY3uZmN7kPKBkFFY63vJhNHUTMHX3PnvsxMu43h2oa07BMQjyS4+vB/iKUzdnxGFbfxZjLEolyGokdfn7HbYCqf0LjDLVArMTVDtfgCsYVO1XHKzGyg01219EsauxEnr2EpSDYlomiyifcQZgODLLfJP20a7QdZdecO5+Ke1Ir1vtFP8KR7OhbqGAdYrmlUxxtokWApIz9ITqBWe99QeVbFF7Wx
 +kbsE46C
 iOzo9e0nqygtFhhYpN/HclM3iq3iyLXOmwrbfB2dIG3hT0aAgPyfeyl+GR5cxuH0MljowZHnS65GXHD6Zoo4zoFq+6A47kRrCWAL0dCrGr9/qcMfiGpruuo015uKNgGVdNHK5VpfWos97sv5CleVROdmQ5rWDDGcUAnpuLl4vGfV1nQTBZb4PJsTMNp6lhiyJWd0TjigxNTPZhHIPPKB6T3Nav+1GummWphaAzmn0X6Bc02zC4GBRe2dfGlD3HGCNU4K0y7pP+JxgnsK9xvsJPJdimVzMpc+BB+ZD4B5meOYeXNiQSs397AooJd/9UEiqf/CS
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
2.51.0


