Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0516CEB7ECD
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 11:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610176B0089; Wed,  4 Mar 2026 06:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ED866B008A; Wed,  4 Mar 2026 06:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3566B008C; Wed,  4 Mar 2026 06:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD556B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:18:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5157B9DF1
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:18:49 +0000 (UTC)
X-FDA: 84508133178.02.F29E2A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C44E9160008
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:18:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rKIKk0Wb;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772623127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4XWfecFaMkv6EQM17f10TVkTmghvWlrmEFQjSVWH3Y=;
	b=v6x9QreASSBEHK5lFkAmA6OLLJ4ysHx4KFnVBg6n6zXHXczSYhezD+DcKgFqwSvUNEl6uB
	0MmVA5Vio0E4M/08p37N1AnaF9UvuHppo3PbQdQXpb0XmUaF3dvpnkorAJqRBrMQ94hkfT
	rD6RRoPFUPWmytAqPT6VNbSvIY89irA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rKIKk0Wb;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772623127; a=rsa-sha256;
	cv=none;
	b=F2b0joxhe9dq7zu0Pqvf1NPTqhe5WJ+QaO3NyCKCGL+gwfplVA1FFk9dFsoR/yE4G205ip
	kvEZNdsutn7e/ERgAIfPRCfaOP4q0iWUpheXyKm8PbnJVVd89D4f5udxT29q8sxipcokeb
	rH6wWXz2z/CwxALMdS4A+dkFlTTHM4A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56335401B7;
	Wed,  4 Mar 2026 11:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7713C19423;
	Wed,  4 Mar 2026 11:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772623125;
	bh=K1orK4SnlqSOeifXkMKD4BDa0aalYVqN914ZJ+k+LW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rKIKk0WbRBO20EyBuqPPN9cNsN7BzvjIA1px6MFBO6pwueh1B4NqsJZgsxSH8iQqh
	 IcnSHRSUffQVXae/5+NEkEjlg8aC7h4af7yyuMhQ19IMuVMFDnXpDwq31RymQAgAQP
	 gQ72eEuKr9HrDPcB8Lo+Ul/ymuLESTzabeXfgbMkllZcQDZOrYc0k5sstOfYN5LpH7
	 9aZr9iXZkYGf2myPLG8AbrQYw3wXXEXkB5EoBcBP1XXJfYNh9p8jk2cYUzliXw7L0A
	 feA9sxLHDA948FTrU2cu9YdIiS7JP1RenI3pTzS+hIkSmZFSlJ7qAq5qRiUkmJN+xL
	 uPumqZEIJa2CA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id B78D4F40068;
	Wed,  4 Mar 2026 06:18:43 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 04 Mar 2026 06:18:43 -0500
X-ME-Sender: <xms:ExWoacW_3PXolKUVTg6tZZk52ikTEbzSfkqmj34jhdKj5421NF5Dhg>
    <xme:ExWoabsNWOePe1-tAbeY6SFl1SF0kzqCReUsPbaJVvQ6AiLzletzSq7hDQi7H1Mue
    1eBGRXnXzHHfIuGFtmmXjFh1NbWVR6jtcJWR6IxnPUtQZuR6mD4rIo>
X-ME-Received: <xmr:ExWoaWyB5QE-kEtCXYsEokEa_L-EqRAiS0iS8XMCMs0aMbhOLB2UHSXWYWSVBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvieeffeegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepgedvpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehlvghithgrohesuggvsghirghnrdhorhhgpdhrtghpthhtoheprghkphhmsehlih
    hnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtg
    hlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomhdprhgtphhtthho
    pegsrgholhhinhdrfigrnhhgsehlihhnuhigrdgrlhhisggrsggrrdgtohhmpdhrtghpth
    htoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehn
    phgrtghhvgesrhgvughhrghtrdgtohhmpdhrtghpthhtoheprhihrghnrdhrohgsvghrth
    hssegrrhhmrdgtohhm
X-ME-Proxy: <xmx:ExWoaWQTIjvQbYz1JFUx5B1PKd9X0S31r8d6ExaRaewUjkouHS4HOg>
    <xmx:ExWoaY9Ozja9Yor_NGOdY3fEvd7mIEiywH0o6Yz5R11k7rv9AQa9Yw>
    <xmx:ExWoacY6Q7MJFk3dQFN8VYo_r-nbJtECiiq6oP2-cSALSNxK1NGfZg>
    <xmx:ExWoaRqIMVfgeGYPvoxtdXdfyow1qXDz_U3bWWaDqaYvy05mRo_Rpg>
    <xmx:ExWoaYsdWJFAc6E8Al3k3NUPrG7vc7vM8GGdkcR75I0lioIZqpUp53_k>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Mar 2026 06:18:41 -0500 (EST)
Date: Wed, 4 Mar 2026 11:18:37 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kernel-team@meta.com
Subject: Re: [PATCH 0/2] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Message-ID: <aagSrIwiFM7GaL1m@thinkstation>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304-thp_logs-v1-0-59038218a253@debian.org>
X-Rspamd-Queue-Id: C44E9160008
X-Stat-Signature: c6tycu47k363t8de76nd5npx4745n9ue
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772623127-743121
X-HE-Meta: U2FsdGVkX1/62x4jE0nso32pIYQxwHJ5MpRIsD8rwp+JUSBYUzMzFFH4Gqhw5obfWfc3upmdz5TCdMHU9w2sFfo21Lad9Kv3iMYLJiwJ3cVxT3gthPWf8uEEYukH9ltjoWN5MyAwY1Vy/mFBsehFHT1iZNyng70YdYFGLKPVO8LnYQPHVBxI5JZADNDMaFiUFEQVjTJ2tfkUtd0ivVudvMAykXq55jTbU/sVXSjmWXpmuQcOQ4UUFKIo911ndpcXxEomQlcwNKPHKQeVrSyWIom5apBKXx9KXFi2VgXhOuKufT2z94tH0zI96D/T6e1TrqqXxTZCCTLVjnQFFhtC8yRTieQCtyRDcYqmWveYWCjzUchCHmEuuObXautCuWm2iVkeoD/v5RhMGyEG0Zp41Tfqq556Oq61AEiDLz1xyJHfk6RQBjnG84VwrPVWwjWiMz8xYdpBfGTPr/AS/FObR6KNqWHO7DHpumRNvkBa/yEuuUI/0/0Cg7IHp5EHqPUXrxzmajaGxA+98gxjF7L6a/6KKNVQeS4o/UFKYCQW6lSGZ38ieLQCEfRJwhHStmfKl0oOf5xsW31QPSFzUWnnN+r5gCh6qISkPvumUpb4cm8jHCkkZd15421tM2uQ8kkQwD5Clz4AVJJvSL2IYQCrV+qlHUBgF7ECaLlAB2nis0pAaIxCStYo29ponePUKwdWGHI8JwNh1DV5n2GThCQDzfkWRT2R17dPKN8JL1x4epVcXwCiHd0IZhn+wguRhjBQyaIOY2tHljxjzf/Fzht862e4M2OaxMF4AnUzf+GDZ8p2G9FPiqqNTJDxsKYSNhrxXZIXqSGoWQgkQ0mqSwb43MeC/3V6+ifsgOrcx6Uh2ik8s1yR/tPDNK8QBehumzYVrtLUq37YPUHOjg2aPt/moKpdCAqTthRBQA0BiZ4EAKmv12iXbWz36u/WHlYpQ+1LE4mhts0bD1MIXVNgTzR
 92SpWYlE
 QHXX5lbneDHiBfi49luRCjHtfqvcFewAjfPDryM080optwH17fude2JtEDZgCQRkyuVse2veaiF+DZ+5/ilnOGkWJHjngKTHu+896tgpZJ/a8DPH6RwWIN8Q2imBv1m4kRHI8dB51sX7DlIWnmE8VMRoKvo7H0sYxiZIMX3X669IQogq4PsHsG/O8tygczPSrF5XsvsWA4ofZiannF5E14lWifKvh12RuZb9z+lAeOTLmcSjD964YVsxfdxdRq+Yqqb3VCrqOsyRN4N31yBsnSNranCCE7SM4YjRRAi+OPR3FO0EuATAaADTjHkLbqvxdLbKElJJvY3Xzdvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 02:22:32AM -0800, Breno Leitao wrote:
> Breno Leitao (2):
>       mm: thp: avoid calling start_stop_khugepaged() in anon_enabled_store()
>       mm: thp: avoid calling start_stop_khugepaged() in enabled_store()

I think the same can be achieved cleaner from within start_stop_khugepaged().

Completely untested patch is below.

One noticeable difference that with the patch we don't kick
khugepaged_wait if khugepaged_thread is there. But I don't think it
should make a difference.

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1dd3cfca610d..80f818d3a094 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2683,18 +2683,18 @@ static void set_recommended_min_free_kbytes(void)
 
 int start_stop_khugepaged(void)
 {
-	int err = 0;
+	guard(mutex)(&khugepaged_mutex);
+
+	/* Check if anything has to be done */
+	if (hugepage_pmd_enabled() == !!khugepaged_thread)
+		return 0;
 
-	mutex_lock(&khugepaged_mutex);
 	if (hugepage_pmd_enabled()) {
-		if (!khugepaged_thread)
-			khugepaged_thread = kthread_run(khugepaged, NULL,
-							"khugepaged");
+		khugepaged_thread = kthread_run(khugepaged, NULL, "khugepaged");
 		if (IS_ERR(khugepaged_thread)) {
 			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
-			err = PTR_ERR(khugepaged_thread);
 			khugepaged_thread = NULL;
-			goto fail;
+			return PTR_ERR(khugepaged_thread);
 		}
 
 		if (!list_empty(&khugepaged_scan.mm_head))
@@ -2703,10 +2703,9 @@ int start_stop_khugepaged(void)
 		kthread_stop(khugepaged_thread);
 		khugepaged_thread = NULL;
 	}
+
 	set_recommended_min_free_kbytes();
-fail:
-	mutex_unlock(&khugepaged_mutex);
-	return err;
+	return 0;
 }
 
 void khugepaged_min_free_kbytes_update(void)
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

