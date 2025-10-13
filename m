Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11887CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BB1B8E0071; Mon, 13 Oct 2025 16:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 692718E0036; Mon, 13 Oct 2025 16:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8628E0071; Mon, 13 Oct 2025 16:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 47B9A8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:32:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 190FE1605D8
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:48 +0000 (UTC)
X-FDA: 83994239616.11.6839018
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 79277C0011
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uhGBkZi9;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jo8Wdjvj3YfXYEEpEI+fQEmDmOtHAHT+I0W8XkKzZIw=;
	b=R9xc0Fi7+O/LiL92zL97mEJGqBkNm41Xl8DGck9//66sHb1/v6K4RLnepp59VeROE0P9H9
	2JZiiHLCYwUEVmo4bMcpiCK/w7sm4e8f5sr17LHAck6wT7F6Z9PaWZBQ2bwy6hrgnpSCWD
	0dR6ODInWDIDqsm0N6vzCW+hHUskSX0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uhGBkZi9;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387566; a=rsa-sha256;
	cv=none;
	b=O3nDJtbUWy1ddcHrPdLlR4Td2ivaEvF/BRMIsTYILOXZcLP6OZBvMsV4ROaVk/AXBuCrca
	PPE6DvHEMVHMuSdx2vN29YuUHlXZDmxaKjGkMrrTLC2LaGEJbMVj5LPvY8wc5I96b7cPrt
	SnhT2RJfsQNtNafY6npQ2I3FaaAAFjk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E7F60602DC;
	Mon, 13 Oct 2025 20:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A89C4CEF8;
	Mon, 13 Oct 2025 20:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387565;
	bh=4bRWbV0YuzmDy1B/sRgCWln6RMh7KL9GReKc3Nnqm6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhGBkZi9MnxwjOJytxqClEHKzOENZfbkLSvQ1M4jP6Ka7W01jMwLORp33hXCTK/0F
	 lpF3bG3AY7QGUgYRotUsYLwasL8N1/87VeZZFTtlK/hw1DZyy+/hqdCPqRGd4jTz3G
	 PX1K9DMq5s229QMH06atQ5/UI6Kuz0UkIuw0GW+jCbCav8mNJfoDkzNQnR8LUaUsfb
	 DNroVXWCOkC4MrF3I0FPBreVOB6lcD+LSqvld84xyUr8SbcgH5A54O4RB3ZlCNJs8G
	 EQQfG/Di4fw9Y5LjFyLO6+KN8H3lRJPpw5aqjBqr7RCC+btrcBwDa+wITykTmbgLJ9
	 72q3ebLomqdRw==
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
Subject: [PATCH 06/33] cpuset: Convert boot_hk_cpus to use HK_TYPE_DOMAIN_BOOT
Date: Mon, 13 Oct 2025 22:31:19 +0200
Message-ID: <20251013203146.10162-7-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oc74ffg9jjz1wepi8c3af5mcdhbhc9gs
X-Rspamd-Queue-Id: 79277C0011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760387566-601811
X-HE-Meta: U2FsdGVkX1892jDfrT/TLpU4az7ITd6AbW5rsW6aYgeqKETG8USMdQf15yNbYd0H8/JrtiaEtQBm/cUTEhQzSXhMRXotIKat5t8vxjbo2txcMqoOFdFwHQB/zbEapkbqqWdHpLSZclA17nNu/Bo5wG5opA//jAZ5ZHBl11gc5C6xOrA0YvxPQxkP6EZn7fj6qOYA49PeGx/i3XDKtcmVF/P9KHl5I8W/0PXeNBmal+dzljbzfyUUwQ7U9Tzs6Py3QB2IhpurGtayrF2Yx/PLlVOUrodUaMB6ITh2gUPuVYrJAzp0PD8lESuMugGUJfdlq7PW1TXiEk45HMTkmAgls2S/i0O0Vm/AtvAgInIi9KYdtuHnJ8msaHIhoeb3zJZ4ft01TjC9BUnqBjRRN6Fgp63YIwdWILkyNAvBqocvaA+RvGesnQ2yVuKPGPZs7MhMpCdCQ+e+EgmfPpqwJuJROoy4wTE/SWIqUCvNVXMHCNBcIgldjxaJLQ+qyvAOjVirc7Gpn36EIWNS69LvlN+QBiVf9OCdGldSI9DNKZc3jQJtkXMKuaiCNEPIY7kbM+tx2tpRf/DtwdEmJEmafzRVBEOhinXd4HiblZCpZGvj7VObYB6R+6a5V/E73t2LB8a6itWTvmRNluED2SqyE25aPUBQG44BVkMp5I5XgXhf0nincKZ3zjCwBPXaOiSVS27EQZTGUprFvGWSrWe08aTdtlo1jo7SD+iiJuYDP1SGAvaXJEfKg1/vzvAxqura9I6jUPNtiLX/vWYoaO+UkAw255Ak0XsQs0QAFw1CCTYzFqotW/jc7cjLopv4Etj7fr4hjPab5QDO/3y847DXGwdP+7ybHWqivFkKJyVf1d98lZVIVFcN4kpzoUOB7mgFHQvXFMdNBe9/xRqTUdVprznCsElBTt7MFXwWB9DReGAQ5ZxwwmDjr4ClK+NeGthr1GJi28jGKPmxnpr/tKadzw/
 XyymEW8d
 2IYFZ93elh0v1Wyp2l63DN+Iltrz+kXXO+gWObD6e1CAsKOkhochl6C7oAbNzH+gYbQLskYsfYW6GX3mmbmB5J2P8+gof4hdszWZ7beiS6DR6k5uI8RWiDOAY97fWbtHvE5PPbC7B69ptXt9TCpTnrLSlS43/BwZnYdYwyARIUV/4dkqxa+xbipBikwlzjbPTl1ztQz/YVESVP/+QEuKprSqNqjL5VWJouTmPtT8t6RnSl4dTalTGN/0D2eKL8pnwNPpu0z4d7WyIpp4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

boot_hk_cpus is an ad-hoc copy of HK_TYPE_DOMAIN_BOOT. Remove it and use
the official version.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
---
 kernel/cgroup/cpuset.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 52468d2c178a..8595f1eadf23 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -81,12 +81,6 @@ static cpumask_var_t	subpartitions_cpus;
  */
 static cpumask_var_t	isolated_cpus;
 
-/*
- * Housekeeping (HK_TYPE_DOMAIN) CPUs at boot
- */
-static cpumask_var_t	boot_hk_cpus;
-static bool		have_boot_isolcpus;
-
 /* List of remote partition root children */
 static struct list_head remote_children;
 
@@ -1686,15 +1680,16 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
  * @new_cpus: cpu mask
  * Return: true if there is conflict, false otherwise
  *
- * CPUs outside of boot_hk_cpus, if defined, can only be used in an
+ * CPUs outside of HK_TYPE_DOMAIN_BOOT, if defined, can only be used in an
  * isolated partition.
  */
 static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
 {
-	if (!have_boot_isolcpus)
+	if (!housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
 		return false;
 
-	if ((prstate != PRS_ISOLATED) && !cpumask_subset(new_cpus, boot_hk_cpus))
+	if ((prstate != PRS_ISOLATED) &&
+	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
 		return true;
 
 	return false;
@@ -3824,12 +3819,9 @@ int __init cpuset_init(void)
 
 	BUG_ON(!alloc_cpumask_var(&cpus_attach, GFP_KERNEL));
 
-	have_boot_isolcpus = housekeeping_enabled(HK_TYPE_DOMAIN);
-	if (have_boot_isolcpus) {
-		BUG_ON(!alloc_cpumask_var(&boot_hk_cpus, GFP_KERNEL));
-		cpumask_copy(boot_hk_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN));
-		cpumask_andnot(isolated_cpus, cpu_possible_mask, boot_hk_cpus);
-	}
+	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
+		cpumask_andnot(isolated_cpus, cpu_possible_mask,
+			       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 
 	return 0;
 }
-- 
2.51.0


