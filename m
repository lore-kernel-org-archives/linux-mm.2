Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDAD4D1CDC6
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 04:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B5556B0005; Sat,  6 Dec 2025 23:53:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966736B0006; Sat,  6 Dec 2025 23:53:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B8E6B0008; Sat,  6 Dec 2025 23:53:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72EC36B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:53:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E26BAC06FC
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 04:53:06 +0000 (UTC)
X-FDA: 84191455572.03.C93DA99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5C05440002
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 04:53:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5ABxrJK;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765083185; a=rsa-sha256;
	cv=none;
	b=u+n+KpGOhHM70cPg4m88Xo0gAaiBzBR+liE1XcNePZz2wOZI3UkvkLMPFdOpZ+f5+h8pS3
	t3gOgARp52/cYKA41aL/J3IiIkNWGfdog8ZxuQL/pJcDCC8I7mWF6fZ7O9nvGL5qD95xiB
	1Bvw9F6ZCMacmQgSmkw2x+1pIvRWysI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5ABxrJK;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765083185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VOITUajeJCcz6254M2QYY3xkciPgEfBKkTE+Y8PJ0+c=;
	b=8QiWwHm8I/vfzcQBMDb8H0d1l4MW22zwxtYxWADQfsmHRWi5M7k7sas1bMxB7UQYvLGzp2
	3YM4ppJyRsiSni0LoY91GdolILng3AL+iRrs936VukDXQ7JMpX7DzGSou2Bkk4rWlWqiXz
	OUkMEMNMXE8KcQkx5TCwLsXU2GKfJTs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A75260142;
	Sun,  7 Dec 2025 04:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FE5DC4CEFB;
	Sun,  7 Dec 2025 04:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765083183;
	bh=uD6Uc/3bMvUszXx059Ty5URnVwOwfY870xF8hpY9UA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5ABxrJK6aeoV2cSXcVd1GjxBrWYc40GGZveh0jSrdS94NP5jhngC3352vlrruZXv
	 PBnRxh7dnynlsNsYnn5aMeZx83m38mK2bx5k/uJQN3zQ84IYufT5b/tda/WeCcJHhY
	 XNhV/UR+Mfi0PQpcbGDA60jDAyJCfUKerPwUeeGllYdCMuPKWc8eoPtb1rDUWo+R+i
	 WHG6KIUwwwwPE/ZR38p0qk/d+EaKSMRTmHwF0YSDYzX6HKqcpz9edz6p9u68VXgrCE
	 GGORiQtB1y97wFWO3C02wfXJfij64kkoeA5RUEelwlUrTVCXjqe2ejIWQ7yKltPcyn
	 CYhkXNSeTHosw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Jann Horn <jannh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC v2 0/7] mm/damon: extend for page faults reporting based access monitoring
Date: Sat,  6 Dec 2025 20:52:56 -0800
Message-ID: <20251207045257.47035-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250727201813.53858-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C05440002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: nisogwwy3pba3tdknzngpw84inkkrhwa
X-HE-Tag: 1765083185-982737
X-HE-Meta: U2FsdGVkX1+TL8CHrh4HgLtW9LznE5zAFoxio4HGUWRA7PVRlpzh9VJpEWJAohXXmOkNtxBIeOTmzCDd9Ia0KtHIQGb2fABcKJBXhgbTajx3ffZQF8IwGmx3m+VpWyFr+XMv3Y+OVF9a1Bx6T8kK3qLIgzFYLhKcJ7PphoR/UQ61Rnf3+eYrQhQsSoO7o1hfq999Rg3B9y5pEuZ/8JxoE2V/lMzM07a4aEgg6q9Yq3BldHP9hKvB/EHosHEr/9WxTKMgY35G6Xv3AD1lcu+akmHbpukGTr7XzAfLLxwB/ri9eSGBkneGLxPyAuSaBFSjJ/MEIjR6oxgbjd8I5xervWgdKfPHQSINMSH3haazP4RfF/FIiuWKzeitpenekgU6Sopr2UqXvyrT3b6brzweFwb6TN8BAOa+5RnOBEWMnnqgXBF13qLetG/a6el6txfN/TYeKmHks4O6dRAX9AeIKZgpK0baU+Pp4E/+4U6OI1cUQINOdAwZDxZFpt3MEW+o2Ti88tePsfFw4TLeX9nMtTIwpCa6veYo00hP+bN+V4Y1cAk/vUdAX3Ucc79keSKQ/FIZg0rXrITSnvJrnQOg3O9y8R7yoLFuY7hD/XtIQsEuerlWKfpBkCivq5H2PVj5ApDA+DurqQVtRxcLZRu2j8e0pbWCjgqpbZqp+BZROeEWK+V28Gd3vepxPNAmqFeeX2TvjEmY/lVLZkgofXWb9Nnc2oHxlFuMJb/XUycC3x3EoydgFox39xdECYMBjDVt9G6+nz2fbace/9eCbS+1ra1utdo06TaXdyfGSrP7f2qP0undLcayIbIKb9Q6USyTN5zF0+MfnVRJ0/4akWeNPeqi1Gl7AbumgYOMHetOVyLqV9WlK5NKAatMkarf1CuxMIQBQic/dyL9DZJw1km2+NV9k9L3FrTUGpIhWnCDHCgm1VlCf9Jtuq2LbYwVA0lhkK9pREbqtmdwWfNQ0K0
 LhCsLNd+
 UO/5d82RTLC3e3qJj3CXYjvzhrmCYxrMsvlsxC5p1xv8lNvajRG7ECa/cFjuVZ19SJInfRN+2D6Z2cIQ2iK87crBzxer08f9WNH/bOydNe4j+G663eruG8eOnYj+K02Rc3+hBMv3BvZNJoDUOH5IWAzRf924Bs094W80hjyM+4MMt5Q/YP+ympk71BhGji2im6dL3vipZnxKOJjGPcBLdOwmEnt14nP81rPs9YMPYZshD3yA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Jul 2025 13:18:06 -0700 SeongJae Park <sj@kernel.org> wrote:

> TL; DR: Extend DAMON interface between core and operation sets for
> operation set driven report-based monitoring such as per-CPU and
> write-only access monitoring.  Further introduce an example physical
> address space monitoring operation set that uses page faults as the
> source of the information.
[...]
> Core Layer Changes for Reporting-based Monitoring
> -------------------------------------------------
> 
> Optimize such possible duplicated efforts, by updating DAMON core layer
> to support real time access reporting.  The updated interface allows
> operations set implementations to report (or, push) their information to
> the core layer, on their preferred schedule.  DAMON core layer will
> handle the reports by managing meta data and updating the final
> monitoring results (DAMON regions) accordingly.
> 
> Also add another operations set callback to determine if a given access
> report is eligible to be used for a given operations set.  For example,
> if the operations set implementation is for monitoring only specific CPU
> or writes, the operations set could ask the core layer to ignore
> reported accesses that were made by other CPUs, or were made for reads.
> 
> paddr_fault: Page Faults-based Physical Address Space Access Monitoring
> -----------------------------------------------------------------------
> 
> Using the core layer changes, implement a new DAMON operation set,
> namely paddr_fault.  It is the same as the page table Accessed bits
> based physical address space monitoring, but uses page faults as the
> source of the access information.
> 
> Specifically, it installs PAGE_NONE protection to access sampling pages
> on damon_operations->prepare_access_checks() callback.  Then, it
> captures the following access to the page in the page fault handling
> context, and directly reports the findings to DAMON, using
> damon_report_access().

I was going in this direction because obviously the protection installing is
obviously what operation set layer should do.  But, damon_report_access()
handling is on the core layer.  For followup extension for
per-CPUs/threads/read/write monitoring, we need to filtr in/out the page fault
information, but that's not only for page fault but general access check
sampling results.  And therefore it makes more sense to be done in core layer.

Also this approach is unnecessarily increasing the number of operation set.  It
is also restricting such advanced monitoring to specific operation set.

So I changed my mind to add a control data structure on the core layer.  It
will let API callers specify what access check primitives (or, sources) should
be used, and what access information should be filtered in/out.


Thanks,
SJ

[...]

