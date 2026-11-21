Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9117F606A331
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QpmIHZYY
Received: by kanga.kvack.org (Postfix)
	id 7E8F86B00EF; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF596B05B0; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 687B36B05B2; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 499E86B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:33:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDEB81A0590
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:33:44 +0000 (UTC)
X-FDA: 85460125968.09.278EAF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 45E26C0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:33:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QpmIHZYY;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795289623;
	b=AM5dVzvkaZpF2xQVGiMvVDazfbIEHUoY/RfEkW0qsNL1y8UktMJiflcYMrhbNNltApyDQi
	01jX/yDGoQ7pCBQGTDnwFcgQ7qYozHpA6ETr9tYqA0NBmYhq+tcS3uf1f9HDTR1uUum/Zf
	ZShRZIJmrCoQu+9Lz+8S91pZlrG/uxE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795289623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oipHQJlQVylrVPx8RtKqcrMUGU679rocneT4MdJfejo=;
	b=ZQ+02cjwbk7D2O0DHbfgRhhaW93IwJcw9uHFSmLfb1UsOVY9ItSZu9ZEdnocPzWmV0l360
	IVUgYZRMySlcdEzl3iUii2aPoaXyIGs0TjDK5BKqG/KpXxBvBfUZ/jv5mb+cD87uKdjVvL
	FOhQKB3eJLKae+DQ1FY+PKf0wSirzv0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QpmIHZYY;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A0756122B;
	Sat, 21 Nov 2026 19:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C9E31F000D0;
	Sat, 21 Nov 2026 19:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795289622;
	bh=oipHQJlQVylrVPx8RtKqcrMUGU679rocneT4MdJfejo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QpmIHZYY/BPHc5mWi64zEvMbT6qYIry+GMQU2MGP0y8g71vrmVZ4jtWwn78lhyV27
	 jdbejCHx9sS+de+zXjvM8sBVyuK2IvgXYfPisudagT0hnhW6gxohFb14Ixrqh3vhlP
	 gVYZ+6j9r53ZGBg0Za2LTTMNevnq8Y81O0KAF2jc41h9zuzz/3i//40QdEtdH7hDoj
	 ejOs1c5k9VCXu6Z7FjUURuxf8AsGM7CZm+BL7733xprp/KpTYA7AYp0MjynRQC33Nv
	 WRMZ7KbTHMoqHVlX9RanLrineoeAPNrmEi6KhTD6VascSXC2dzhR6/aVXGHEcmB21P
	 oMPdCO4G73gfA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/4] Docs/mm/damon/maintainer-profile: use damon.git for patch baselines
Date: Sat, 21 Nov 2026 11:33:27 -0800
Message-ID: <20261121193331.108587-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121193331.108587-1-sj@kernel.org>
References: <20261121193331.108587-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 45E26C0005
X-Stat-Signature: hqe9endw4n194ddewi9kqqgne1tytwso
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795289623-994564
X-HE-Meta: U2FsdGVkX190tZx2o3AaU8HIh9YkO2ccD/f5Yhbsr1YtpLU9PSIBntmK1xImCgpOOhuxLyaljefofHCQslyt24UzNJCGD9avqkecsJwrcjWYSyHG/5AQMsLqYl53QV/+FA+pjF1qyFYHtIBlfQvYhvgqleeVVkUpqW7ho/i6c2j8oDT2Y7s2+QwZJs0XYNlJoYn9HFUKzJUEf0/jvBhvIZqGlBG5UV04G+OgqVhOrYaN1F5HDbEC0wXV2248UetScspLgyH1J/u+Y2iXolwN9f0Yof7uFv9kZzEWBSMBnXAPDFVTxFZtVkswfQDrOK8b/u6iuCL9QrTAaPH+d8eQwiNXkiwB228WHc4pU4Z7ZAISgty5pAYKaFVytM0iWlj6FZ/J6ud8/VJx+7VoctMa/7p1lzCLvcUz3gQcpLU+6IrTiqAVJ3Ixsow13bAWb9KFIipj4Syip8fb9xZ2EnEW6m0MqG8/J0nce0ka7sVXBsP34l0Bc0Dim/4CIEnPb9Aqm6TwJmMHJKzuXqfpGFsen+feSgBzfVe8YYmKq60yeHnWfegMmlTcL/ZJYH3vnTsrqNfCIG6wIIVFqXGPiOdObpdeE4fAiZjqxX7yFt9b3w1dOE5jjYj/cA+X5Iej8032NbbhnzFDXJElRwqvcAjDWOhfpvYaIwFEN6bGXOEMvKWCMK9CRYaKL8zIX5I38xl2cvt6PqtxsgEIsYep0zpUo5MUQcLFae14UXd0WlEc/NYbihICHKiHsPkymjh7q60D7Jld/pe3aXeU1ToG6Qh3W+x0xgziFmTMgnMGVHjf4XYOZYpOYzveeOk+W4a1nlnpQg0/8/+J21gs830PgIlIm82Dx762FHLK3zEtVbDmR8+miEmY0iX9gNqc0hR6g+V0/BiERagqZXfx0sd/W5xqOCize4EfE2GRVys9/BMPpE9FbopiRgigU7kMTo72dkZ8N6TlcqLdbGkpVmjykWt
 S/ptVFgX
 5n8ehNbZkhKegDr4hlgcUf4MqVTAzt20K0Tg6L4eVq04xPWUs0Sp1RWuy6gNaxt+zZ+JJywYxeQjHejlpXnaB4M2vRDyAf3WCNjokxE2XVWXsfFuoi2eY5vKlELfbrepZgg+onvdj0X0XTHEAPeCzYAwCDk+CaDDpBCDEr6iFEfIDJYLqmSN3ENSwRxCp0pHMP4AwFVnqp3bJFvjNtCgJnU2I8YbBIWJS69Et8p1QhF4T3z0u2hCn6/xjZUnazLz/M6yfYtoRNeFKFNoYF5P58f3b2t5hrfFNVH6PsoKtehtpMh55pAycT9nUIBvYoxZF9X0ey8H95u4SjEc78K8suWvUCTvMaTG0iKztS+07Z14pMVG4e3BY+008SM4Ie3IjR/WyUofh9zPjY1xvKxhirIWbaRiK2/cMle4HYVfWILHPiAXXT1H7sRO1K1lV49AiJase8MSqOWprH8eQN9HKncO+aPwLx1yZfeCaDtejEDA+lJpYKa8r/314IHKKyYKPhwuswiCt7EVhen8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Right after 7.5-rc1, DAMON will onboard the mm-next transition [1].
Update DAMON maintainer-profile document to suggest using damon.git [2]
for-next and for-next-fixes trees as baselines, following the mm-next
process guideline.

[1] https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/mm/damon.git/

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index c482690320249..cc6b79c066a64 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -3,13 +3,20 @@
 DAMON Maintainer Entry Profile
 ==============================
 
-The DAMON subsystem covers the files that are listed in 'DAMON' section of
-'MAINTAINERS' file.
+The DAMON subsystem covers the files that are listed in 'MEMORY MANAGEMENT -
+DAMON' section of 'MAINTAINERS' file.
 
 The mailing lists for the subsystem are damon@lists.linux.dev and
-linux-mm@kvack.org.  Patches should be made against the `mm-new tree
-<https://git.kernel.org/akpm/mm/h/mm-new>`_ whenever possible and posted to the
-mailing lists.
+linux-mm@kvack.org.
+
+Non-urgent patches should be made against the damon.git `for-next
+<https://git.kernel.org/mm/damon/h/for-next>`_ tree.  Urgent patches should be
+made against the damon.git `for-next-fixes
+<https://git.kernel.org/mm/damon/h/for-next-fixes>`_ tree.  If there is a
+reason to not use those branches as the baseline of the patch, please explain
+the reason and what baseline is used.
+
+Patches should be posted to the mailing lists whenever possible.
 
 SCM Trees
 ---------
-- 
2.47.3

