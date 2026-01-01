Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D77C8EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495066B0098; Thu,  1 Jan 2026 17:15:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D1D6B0099; Thu,  1 Jan 2026 17:15:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A30C6B009B; Thu,  1 Jan 2026 17:15:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2E06B0098
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:15:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C12FECE6DE
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:04 +0000 (UTC)
X-FDA: 84284801328.12.22A6000
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 374208000B
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZwXUOgHh;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6kNyjpAty5pqhw6oDvuv7eYRraJpy7CkwduZRvO+Bw=;
	b=x9YLuQ3EnVOPl3vKeozff2ZvocfDlK4/GvFdo66lE8zae2GU4m54Dt37SfiPidik7Z19NM
	7V7opynzItmALwXh7bXiB4SjvcQqFPZ58xsd0RcVI9nz/yOji3GLZiGmUUxt38UK/EacZb
	BLSQXR2SI1zbV0pKoWWlzB/Zj5ZVbOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305703; a=rsa-sha256;
	cv=none;
	b=lnmrGGJdheLpIMnN4ME5ya36KuOZafUIyJRbmhozpd+YCH6TwOzIktx+71zMQmJ9qBcNiF
	e18iN4EYoB1Omwje4x5rg5bdrkJYJX33Qhtl5nS9ASZcEPIvQvsamSaZLUJW9tbyl6Did3
	ZwWh3l6y8eLhsiqT/3ZCzwL81wPHo1I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZwXUOgHh;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C1FCE60054;
	Thu,  1 Jan 2026 22:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D948C19421;
	Thu,  1 Jan 2026 22:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305702;
	bh=pTB9cNPcvPakmWV9jutt30tCCHfCDIAA9k4V/apVATM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwXUOgHh5SZusqdj1MuBOnHQSG66GUsBSUq9kZmTGHcPWpcV945zTsBbzfhh9gRwQ
	 5Ys00+vpPwfvVsflAum3U8GgE/7M7GFNZ3ZSAEWEl4wzQYn/4oZiHZNc16OWnHbhK6
	 09XASD6Q7S/OOE+tB2MgcECKmN4VNWfVTTkcncpOgr+ODrxDK+HfyLvp+mOWp+C8vB
	 vKwMCR2Q4jkz3xaDI9brAB9ZC+E9AEoFs6nNCBkXT5TDz+brTjkc2oXuPm73U0f0CM
	 IRipKFdDs+YRB//iQcq7lQCUWK36mljq2Bo1Kr/r3JWkqQrQyod2Pxijbt0Fx/qBsL
	 Zh21Loq+Sn1UA==
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
Subject: [PATCH 06/33] cpuset: Convert boot_hk_cpus to use HK_TYPE_DOMAIN_BOOT
Date: Thu,  1 Jan 2026 23:13:31 +0100
Message-ID: <20260101221359.22298-7-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yyrhwzdu3fab9mauomuuxn614am4ax4a
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 374208000B
X-Rspam-User: 
X-HE-Tag: 1767305703-79725
X-HE-Meta: U2FsdGVkX19z9h6Zl9hEsYPZHsPklu6+rCTF2Xn4NF0IVFolcQMzUVJto+VptfUcgmJl5OBu6BV1cwNupu/ZVHY4yr1Fn0rYoRTVySMJkCdkzTyrnlU3P8ynO/DrZKvbPV6GLds7u5hLWPiAQKCNuox24JhGRt9UzUOE34qNQhUwL9J/WQ2onQ5gumNL0k+jC/iL8Hbs76ZUmJfZAyQmCfj9EQdJfqezFABpFi0iZdNxl1lhgCYQI/YbOoUw1X2etUZ2VqofZbgF+eBMIz8br/9AcCZud5MN51ojrKg/paM5qCiNb6GV9kPesYxVODdZ/dioqApfb/LrkBXSenOiQSbhwx7mTyIkaWLRXRIpUKR9J5vDoHX4keF9+mDBpLdlgmmFWh8P+jQFMbvCwig7pgw8tkZF17lMIS55iSgVCTvRXS5vdiGE3bdgGL8pKu2Pe0VQQzOi9T8rwoR1It4f/rW05XP+LiCi2cXEEyxnQlfIn2nx7v7rCTPsLVovpMx9fR1QKn4yoAnBG0goEpVPFRhFaTnM9YANPsTu8vZN3BHj225XP+rEeXeiSx+UEpVhkNkA5DygTpPwWRTFTE0Vd2kSSVPdCNvdEMzRG7Pf2zje6rsRv81G59VapZ4S11pcjZgQBGfsdPchK6YSU5PQcFUPfktPCO0Hr7HP3XFxp0tgbXO3kIFCbF26yiz54FPEpgSGWudeYQGQdoNHQ7s52EjihR5B+zHl0G/NMltUjgKdW3GcvC5PWfIkwTg9PqyxAPYc5AzKPAu8omxm/dIVyqxj6VXre8HkH5CyCvG7lafomiVPvuW7zgos0HuX4E8ypsB/TNw56I57YS6FytNQ3KusQWLc/Ofe3YvxI8uA5HPQNzxR2ru8pC+Ju4hpq905sgvXWjrhXH+pB7fnIYJJvKy8E1B0tjRaTn3iF3W/jMdOBk6IEFiyqpk2bbmt54LL+VISYMeklZQTDutqp8a
 qc2vSLAX
 03KmtpU/Gnb7+ZP+Am67W5qjPuGmXx2+N4K6MUDGLZ93CDcU2vkna94u/ezgeWLbF5lSIJnuA7/rtmcbI8SrD901z2fbIYphGakpL0Fxl/izqoSqCkn7UVZmQyK/QwagbzQaZL3Itq0vhEmZfoKMKoiFTjnSGqoujGLFB9ljqdnY0hpUqhbBqfWNTdnZoqRLgoNU1dl59VysA0vjTNtQsoGsb53iJv0Gfa0EzsY9ntfOl4iszdgmEWPu70G7E0liHQC0efCeFm1qWxL464s38a15d2gNQc986hKD6
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
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6e6eb09b8db6..3afa72f8d579 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -88,12 +88,6 @@ static cpumask_var_t	isolated_cpus;
  */
 static bool isolated_cpus_updating;
 
-/*
- * Housekeeping (HK_TYPE_DOMAIN) CPUs at boot
- */
-static cpumask_var_t	boot_hk_cpus;
-static bool		have_boot_isolcpus;
-
 /*
  * A flag to force sched domain rebuild at the end of an operation.
  * It can be set in
@@ -1453,15 +1447,16 @@ static bool isolated_cpus_can_update(struct cpumask *add_cpus,
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
@@ -3892,12 +3887,9 @@ int __init cpuset_init(void)
 
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
2.51.1


