Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8BFFE5215
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 12:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73F06B0092; Fri, 24 Apr 2026 08:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C3F6B0093; Fri, 24 Apr 2026 08:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3AC96B0095; Fri, 24 Apr 2026 08:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1F876B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:24:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F15F41C00CC
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:24:43 +0000 (UTC)
X-FDA: 84693368046.28.1EE66F8
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id 019D9180005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:24:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gKK60k+S;
	spf=none (imf06.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777033482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T58sPSkCpDO6mBCqL0XNY2K3RwSWcmiQzHhYDz9yJNk=;
	b=qyIPZFuXCRlRrxZyw3YpnADUjKa0tMiuJVD9q5lkJ1KDEHgXgYa+UoCXwDsP3qVsOsxBWY
	lc8tqyu/+tc2Hs6SqFQ8G5wRbGQzuqu5bZo4cozBBvRc1/k3cA5SusoNJCeXQ0HkZJ/pFW
	aHe2zuSjhlK7g40YTOfkQ8oSU+IBwZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777033482; a=rsa-sha256;
	cv=none;
	b=HPGzdVv2Tpeso3/B5Y0cbw6hyJ2xxEBgoh6kBD/hWBuNBUu2d0zrQQmzsD3zVhR2VF6v6J
	Hi1Tt2cPkz+KTfM+6w5YX2vmfxMGRInagxmE0E7IAHciBRcZdydYERCnnARytDSi4NEaPw
	9Db71CLdFLj75l7io/porQZOGOUR6mk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=gKK60k+S;
	spf=none (imf06.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=T58sPSkCpDO6mBCqL0XNY2K3RwSWcmiQzHhYDz9yJNk=; b=gKK60k+S3QWIkEsCrZpLN2qzb7
	nut7ZZBWKz1PqFWcgB/i1eQix6vrVsbVf5Nrkxr34b/YhxBif9c1+0eAA3/pEQ4WAHsXQEJ9MNnJi
	SdkS2/kuu+SY3XwaCJHg0iINy/ij99/44h+aDAha2ATMISlY4HV0+1j3Jb5UFpK2VH5KtagHiwfQN
	Dz7KAPRyMp5DW66Cp8F4YHEaw+KBYzYuL5E6n7qTbkup10a/+jjak64JJ2Bo6MfENvuiNtLXtvKZE
	ZLWCZj8qTrFsS3zHAtcnCspX3nJ+lmZBJN/MYuX2vDBIYzoL4BLLFegpjc/O8A1dYNwMFp4dJXR6o
	j2BqZ/BA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wGFaF-003APz-1L;
	Fri, 24 Apr 2026 12:24:35 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 24 Apr 2026 05:24:01 -0700
Subject: [PATCH v5 3/4] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260424-ecc_panic-v5-3-a35f4b50425c@debian.org>
References: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
In-Reply-To: <20260424-ecc_panic-v5-0-a35f4b50425c@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3920; i=leitao@debian.org;
 h=from:subject:message-id; bh=/qCKorRDHDfdon8uQB15LannYTC+7j0ppSiNsgWgO1Y=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp62Duf59kh2dj9J6Mb05R+4nEoFVAbAXCB+7LW
 8yh5FWm1EqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaetg7gAKCRA1o5Of/Hh3
 bSVZEACbzhttOBC3Ol+GlNv//VUwHekj1rvhaAp79eZJ8vFb8jBi8rEAbCDhEBO1mCojmLbpb2E
 rrywuAl9yDZxWmG2mQGJtDS5wvNtMbP9KWUgwtpctvC0OQnATLrf1BN46NdC4RQ/628ZoL6TgTV
 PCqSuAlxdCkZkG/xsQE+KlPmqGUTogqFEqtreAk4CxZHtPrNqTOQ2TJOtIFIxflrSFcKPlUyD2U
 c4oUttA2kx7Uk03nMUB7HTRBbQ8jdaHGr9GSU44Kfk5s1skC8xGZOd3JD+XlCsiNRD5zCfda/1i
 Bzs1tmJih0O8B6ZaZvl2RGyxIpFFEh0ekQMP6HuESvcW59bJexYxoY5Ilkz3M4RhU5n3/PzHsi4
 Vw9EHRuK7f8+ci2tANKyIZV9vIT9gRo1JWtfU2dBzicb43za53G57L9YFbwuWlyYJB9Xo55gd4Y
 qvZTF1DQ5MISTe547MZi8KsZ6qeHZUAnbIw1ua+rhwXxlipjEltrf6jdDqvcnurrPWF0FsEsk8k
 GSFndcTgQta0DeaX3U6V+zAt30Yg44jSSE2EhwydgOWLJhp8QG8HeFcCnJfq3NaIPw46+YhxASK
 uQjcjPwGAE+SIuwlCi3ow/0n1KcmQNCdQn7DNfQUarx1YP59vGKOZGahiPFCtGMp2smPr0jUTZu
 iZaBWTaaqrwqKzA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: dxu8wc9ae1qy47q8rxmeit6iboqzemjd
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 019D9180005
X-Rspam-User: 
X-HE-Tag: 1777033481-322193
X-HE-Meta: U2FsdGVkX19UtlBk3ZshrBzxaYqLP8RZYgMj7cmrjUajz30rdXIdU35446/aNXse4xPn0LbIRRYHWqYwCnwba1pUYxcz8pRzcMg1Rj6Bjn2hgQAmzhMbH1CtfQDoExxzh4WCXe9RCuPKklncAirn02lAmFiWzrpvNwpb/gI3md+f0A/1v5huCX1028K/OSA7YHkl4aGJOXMJiF6If4Tfa+vaeXUsXvGqvnCxom7dPu8Py/Dn+28+dY0df6aE6QT9Ib/rUl2eizR149WUxgbMGI1PwSGHZBFvAeaZsLJ0Dr1KO2tdIL/Mg9rIhII0FROc88gbTGSKVm06+jzdDKitMUx3moJF1/gdTLQcBTHiSpCTG20FsjWj12r7j2p3gKqlkVzirD4sA44WVEEFEXf/3kJ4ygN1tW3ikf8f4e2oNUbA0JPcDi9CnJaX6wmA3oIvg2of5fALdLTiPxkVDlGOBySTcyN6Cf87BNuzVZeB6b1E9zxfiEGED/ccS/xDxvr5FZu9/qqBImUhLDrgHxPBG3wmSxK65IRWLRKDKu2dhgBULYerH/HF8En0opO8WgteXnYktE94B5xMnXD8BltZYKDSqbaGT0qNOgCL5T/y7d1oNUSIuAJdig/f12qKNvE4o+6FeQceVcGL2hzQeOgtRuDlu2CvhCFGBdNSUsun0iY4pCR+YDsc41bubzbA+qocCocTh0hh6dCVWLyTRrH8w2YebWQtgpJs6X74Ua3lZqfnOPxugepdecFb4xnqKiryvA1TVh+d+iztSL7iC7ozmRQbOzAgH/zGtw3sZhMq1j27rbTSG7I8cTkPyFIHNFCD0j9rmEi0dY5pZsaHpqp/HzjdJchjR+qJUNbWabaFwtRqu8YC7FACeEoKujlItaLNAv6B+w/ICP8ebHgWOntFDQkI+DH9PdkGiYmvn28JhHCuTZvWDDZI3iStfqodAXgxVIwdGHl0I6n9iU5iHzO
 mtqPtnjx
 dvQGWdorX6BYWfuFB7dofjkkukFo4KJi+EagaxDfbcyr215vmNpfG/38b1Q5muNu2w/lfEUQiHaa2spwZ+bl8s2wuyMM3Q7oZn3q7i2i+ozuT0RpbatfjysziaGCo2ZZBG5cuj3YZmDtNml5dFTeE7s+n/SLEmzyseIHc6yH7nfMrdcfmPJkwgRhi711+zbYvPfGEA5q1WVA9x70Y9vhPVa0xqoLRN4qMtKSE2gvIS06K43+q/jyH0pa3FIMMZrTTbPjIgSfSBu+tPnWgzqfjmqHdNWgdyI00TjDL08jqZK2g7tNoH9OekVQSwGX+kgUQ0VZ8obQQuF9Cj9dTTtPeWgdGOXqfJMGJaAOTsJMfDudmBPL/Xua6l7PmAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for the new vm.panic_on_unrecoverable_memory_failure
sysctl, describing the three categories of failures that trigger a
panic and noting which kernel page types are not yet covered.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/sysctl/vm.rst | 65 +++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c9..f118ec5cd1fad 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -67,6 +67,7 @@ Currently, these files are in /proc/sys/vm:
 - page-cluster
 - page_lock_unfairness
 - panic_on_oom
+- panic_on_unrecoverable_memory_failure
 - percpu_pagelist_high_fraction
 - stat_interval
 - stat_refresh
@@ -925,6 +926,70 @@ panic_on_oom=2+kdump gives you very strong tool to investigate
 why oom happens. You can get snapshot.
 
 
+panic_on_unrecoverable_memory_failure
+======================================
+
+When a hardware memory error (e.g. multi-bit ECC) hits a kernel page
+that cannot be recovered by the memory failure handler, the default
+behaviour is to ignore the error and continue operation.  This is
+dangerous because the corrupted data remains accessible to the kernel,
+risking silent data corruption or a delayed crash when the poisoned
+memory is next accessed.
+
+When enabled, this sysctl triggers a panic on three categories of
+unrecoverable failures: reserved kernel pages, non-buddy kernel pages
+with zero refcount (e.g. tail pages of high-order allocations), and
+pages whose state cannot be classified as recoverable.
+
+Note that some kernel page types — such as slab objects, vmalloc
+allocations, kernel stacks, and page tables — share a failure path
+with transient refcount races and are not currently covered by this
+option. I.e, do not panic when not confident of the page status.
+
+For many environments it is preferable to panic immediately with a clean
+crash dump that captures the original error context, rather than to
+continue and face a random crash later whose cause is difficult to
+diagnose.
+
+Use cases
+---------
+
+This option is most useful in environments where unattributed crashes
+are expensive to debug or where data integrity must take precedence
+over availability:
+
+* Large fleets, where multi-bit ECC errors on kernel pages are observed
+  regularly and post-mortem analysis of an unrelated downstream crash
+  (often seconds to minutes after the original error) consumes
+  significant engineering effort.
+
+* Systems configured with kdump, where panicking at the moment of the
+  hardware error produces a vmcore that still contains the faulting
+  address, the affected page state, and the originating MCE/GHES
+  record — context that is typically lost by the time a delayed crash
+  occurs.
+
+* High-availability clusters that rely on fast, deterministic node
+  failure for failover, and prefer an immediate panic over silent data
+  corruption propagating to replicas or persistent storage.
+
+* Kernel and platform developers reproducing hwpoison issues with
+  tools such as ``mce-inject`` or error-injection debugfs interfaces,
+  where panicking on the unrecoverable path makes regressions
+  immediately visible instead of surfacing as later, unrelated
+  failures.
+
+= =====================================================================
+0 Try to continue operation (default).
+1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
+  machine will be rebooted.
+= =====================================================================
+
+Example::
+
+     echo 1 > /proc/sys/vm/panic_on_unrecoverable_memory_failure
+
+
 percpu_pagelist_high_fraction
 =============================
 

-- 
2.52.0


