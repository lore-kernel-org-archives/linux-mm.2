Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5234AEEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBDAD6B0099; Thu,  1 Jan 2026 17:15:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F5C6B009B; Thu,  1 Jan 2026 17:15:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2636B009D; Thu,  1 Jan 2026 17:15:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4F36B0099
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:15:13 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6755B161290
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:13 +0000 (UTC)
X-FDA: 84284801706.11.1740B0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BDF31140009
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:15:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K+EkEJDq;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ughUk2eWnPugNXWzTJLzKsveJLgzP8u6JsIwIQnZTNM=;
	b=kgzpVkjPCCbm/Ei5Bt9wmSoRqBjZJMZMMAeR9FuvMeRRQQqhmXLvGC6z7QV1M7WNXoi1Wh
	9NdbRsBmNhpnQWS+NrFonDSlNL5Di7H8lEXnd7qOF+hUFiHEGAJmZSiXNOjNfSawjAkIiI
	xAgvybBovwF7voJbiHhLGZ8KosxB0+U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K+EkEJDq;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305711; a=rsa-sha256;
	cv=none;
	b=yn+GjJaN/QI1xgX+tZmg89X2RQ+H2RT1CANK+jGC/Vz5WULuq5xLenv3xOsFh0gUQn7L0G
	0G65lLUfhdkphGy3ZemCDvEeRm62Exg4zdU2FbmWP3Grikub4KGyE9r/Q7X70jKYHLhHCG
	+sRBq6/39OfVyJ5ocm8FuBDNCeF/C1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E63EF44453;
	Thu,  1 Jan 2026 22:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E172BC4CEF7;
	Thu,  1 Jan 2026 22:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305710;
	bh=N56RJwx7Vb0djbwM5UfAAN+LOP0Kn2KqSnmCrDj/jJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+EkEJDqQNm/aKnq+vMpcP7vYZHuTriYqBlXhkhZG9M7p9Lyqw5TPyIN1vavhqcbU
	 UHgyZlBi1wsopSwML+3pVUl4QgKZUfttQHhClVetTMrVGwUeao98oJTrni+4ybTLJh
	 MOA/E4b7hCFINh+fxMDb2P+r5M75YoVdlWX4FQdAQzMyMH+5XXNCwgADrrbWSGOJnm
	 KRxKzdM4UExyDT0E5oHbUbF2sl8KKJFcJhaFpGF1xKqHlRHo97gonkL4qmRP6ebt7s
	 E1Jolp6xdr7Vzr45pANOyXltQsVStN/N/HO3wQ8cLcTD8/TNMjIq3gWaJ+0Gq1lr0v
	 Y5fCkSwsE8YKw==
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
Subject: [PATCH 07/33] driver core: cpu: Convert /sys/devices/system/cpu/isolated to use HK_TYPE_DOMAIN_BOOT
Date: Thu,  1 Jan 2026 23:13:32 +0100
Message-ID: <20260101221359.22298-8-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 59f6394dwbabc5rbzxwde69b3uscqtq9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BDF31140009
X-HE-Tag: 1767305711-648455
X-HE-Meta: U2FsdGVkX18Dyhz1JoL0Aglt+smyab0YMBP009G3+FRLvxFA4KqbxB5zljPjAORt17NHZjhTI0EkjoxKaJ5B+f47+gyqm3GV36nSi475RPm/QrESbuXUe1m5weWIdLCV8WJWjHMgZojhi0tIA8RlpZoBdb8G6FfhhWlCYaHkKTmz5//7UjfwO2bIU2mqCPYyOmXRnPqAgZVAwTUIatRJVYp1lGKttAwusdCHYkKBlA53Xv7tw2edvMAICzX4VJI9W16S4UZiccFKsuqiMzyXNjSn8NuL2zzBzb0qneL742FbE8IadEdR2mau1TcHMbcCniZbR8zaDcd69L9W7XNfxInqXpPydonlK532xXd97edSWGzxBUERGTYw4/VsQqRa0/2Ql9Ku4iLkfqCguVyQXESqu3zJFP5iRU0DF7vTXhjc5P77T4ClZlxN8IkNNrSvh01BJXQNEVnrA1aMD0UjszYB4CnAZ+FSclMg96zbr/FjcfTGZh6Yrc56L1tHdWLhyGPNhJJoq5opCr+WjaxFOSF9DRscTUSX7bpwKPrEiVtKyU0K5vyhmfKuMADpsBdpjgqVNqhibpP3112RBbsR9yWiXPVDo5TZLfJ6LWlQcBHdKvDPsifQoZsVkrWEzXr+ozrdEztGKBEPAJ/BwwDsB+TteHgGkbqfhs+m/DRmbFNlfngF+irxV3Z5GUsSQaOSGDWxJn21nVwGz2Cg9GO32iZrKmNKOPB4iCgk/SqDy0/+AGp6MDp+FyrabFN4Xiq/iLWIk9p1y58tmKG2kukAQCTWNWMdQJAuqZu0cfcVEqSgiK9XPMEbddxKyIrEB8UM6j/flfyHYKpTvHRScz7txdjiz/bvljhKym3xCf3eAdXvVHJKsa5om/A5OxHIfe7m7jCCvJ5xfeNhxQm8b2hMeZCF7IX+zkALvkzyK4CRjA5kq3RAOMfZe+Hd+mpE5SQHv7Zs1CabwRJKkRP9c7h
 oNq+AaLM
 nvlKiUJ7tG1aBSXdlSENDg2RJYTRpBeUD909/t2jeGPfJpvl4adeh9TOI/YvnOFtT1zeS0z2JajtEdGNSMPvJ+Sy9PtuRHHnbnNCpumneE66YjgrOLQccAXgRqmBQJdOrAGOs62jwFheysaa+G3fhqpXVZ/Ztf4E32jJ3yqkf9p1+WjNMDHFJkKMfzFqqOW6saI6pU6J23edG5WhHbBMC/U1sk2lL+ua6lcyj6wcFZVunGzn1b5OcoN1Wrrwh5Lu6rVYwhzLSpECTiCQnH4nOm37xzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make sure /sys/devices/system/cpu/isolated only prints what was passed
through the isolcpus= parameter before HK_TYPE_DOMAIN will also
integrate cpuset isolated partitions.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/base/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index c6c57b6f61c6..3e3fa031e605 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -291,7 +291,7 @@ static ssize_t print_cpus_isolated(struct device *dev,
 		return -ENOMEM;
 
 	cpumask_andnot(isolated, cpu_possible_mask,
-		       housekeeping_cpumask(HK_TYPE_DOMAIN));
+		       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 	len = sysfs_emit(buf, "%*pbl\n", cpumask_pr_args(isolated));
 
 	free_cpumask_var(isolated);
-- 
2.51.1


