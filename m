Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A3ECA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 07:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82286B009E; Tue,  6 Oct 2026 03:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31E56B009F; Tue,  6 Oct 2026 03:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20736B00A0; Tue,  6 Oct 2026 03:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 775346B009E
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 03:03:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 082E840576
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 07:03:52 +0000 (UTC)
X-FDA: 85291311504.07.C98EACF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 57588C0006
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 07:03:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WBAQKabD;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791270230;
	b=cRrtP6PiC2Ol7k4r1i3VcGPykphdgan8sH2buNO9QoJqiY28cDL4kFHPMC3vM8kcKpqQbC
	2+UekP/1FSs42fmLFu0clOsJiotPfytHanze/Eq+IqwGQDmWKZ55uhfYBIXID2ty6YOIUx
	2rYleuMg6eJ6vNlaEmy9lJtzHGly32k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WBAQKabD;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791270230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1hVDxTNy4viAJ8iC1aCNhcpE1Gz6aEWPwVU7NsmRaA=;
	b=Qy8fcGHQMXs/Tgriu9sdtncy8nNWMQlGRDrV0nm8Sc1vTnO0Lw3DRfaRK+qw49R5hjr5U5
	tsPuOYV4N299b5eQCQ9wHEMhSogsAD7uVuQBtvv/24YrRkxMIZxWPebhJopKnkSGfJmW7i
	DBA34AmLIKPx2ZOAiwkhjDiiyikSOKc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A253741ADD;
	Tue,  6 Oct 2026 07:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85C31F000FF;
	Tue,  6 Oct 2026 07:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791270229;
	bh=K1hVDxTNy4viAJ8iC1aCNhcpE1Gz6aEWPwVU7NsmRaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBAQKabDZBxq9rzH2ZWl+hNAKEGRw2oT09YmBv/HV7EUfS6iimF4PEpnlC+8Y5HNq
	 TknANLC9j2W+KFT/q44N2INzQr+3HyO5kFy0SHpQg7wQdu/XXWifohUEqITeQmtE3v
	 1t7Kogb9qIGUS8b3vZidi8yA10P9DKruYsF1MxPrjhCm39PgggEbXTG9pC1eSl5Ycv
	 w+TDJFQRcs1MlqJXcVXNEDP3Q1QWPxX5FYWowFX+X2KcXTtqE1RmbU+kPUQBp47u8q
	 5cHvRp2cUKsQwSXIEu/oCTu+3jnhVkT9aDoLjxtWhDr4EpvL3VrZL1gxDTPkVJZnf/
	 K04VAmCbeG6tA==
From: SJ Park <sj@kernel.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	ahuang12@lenovo.com
Subject: Re: [PATCH 0/3] Docs/admin-guide/mm/damon: Minor fixes
Date: Tue,  6 Oct 2026 00:03:43 -0700
Message-ID: <20261006070343.43450-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006061549.627-1-adrianhuang0701@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8s6dnhq9f1smmio6dfi1rgrwku4ucsa4
X-Rspamd-Queue-Id: 57588C0006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791270230-116796
X-HE-Meta: U2FsdGVkX1/RvVJ/gn3Vs8GszmuUeN7bP2lLmPhkmg6kVEen5WxOmKbtBxHv9PYXen5WwMhxxm8Y43uGMSEW9LsaMkjMstIMt5V6Gfb033UH+XP3L7qU09U3WWJnqKRSYfh3yMS78tnl8b/GLgjuBJOgVjVHirw3yqOeoZrx3pwRNICPtITGzycSEzNop5ab4LJ9cFqoIDvmh5O+Ib9wpNaWPZqPLUSUnS7nYC/lxPQdLmqc1tKDI4S0X80Zx0rkt3EcC+L0zz63vL7JCQW7AisL/i1S8w0+AvHEBbJUVokjCjTQBn4CTQ2tdFl6PFB6kFVnEh+/FhJfyRpfoPU3WyUf6AkYjt/58WFUenqcp2SuFKN36Q+JZ0MBF0RXmZx3K1TTMo97mgLYNto4sFvzU1sq4R/x58x1BDr65qJjZJRlYQ0ZtizM1yxtk7JNDOSJBHy50w3xOlnElJRV7MPlwnypcJ0V+PFtGipF0+FYImyuqZEdZfa4A+Fu0TRAxkVh0t2o0SL73FzW3CMyVgLMi7V873+ribUw1Ccwuok1bQ2+QsKCCMBAAevRfZoK/SIlK5/ppo+4qnpW0F+lwUO+Z/KTmCAF7o0PQ2K0uMKj68gpRNjOyEcclWf7YmZJNp4W71NcDRZEJDOWewNl/nfB0SZ7lJoO1VMirj4cnBXElC37oH5HEe/UBfpsxfODgP+mdC3s6dZcXYvZIgJEH2tuhTAJVl66T0I/mniNcxTBdiZRyay5xVCvR5UHi9GPdtmyhRlupgcVdlU4C4rOVXVI9Kd2y4x3oXB3uGGil7VuHqOu3Dvbo6qDWjLc1ywTxsbw5vnry/1/9kJx8Rf3XTIi5ITqigEYBBmHJSZ4xZEdMVWumxU93aQQ0ebnkksuutwCjOJuzM0IRwQ+h1HHieZOKkKw/SpMDuMdIMRPgejgCspgWxtBmKRTfoiOQvOADX0m7KOehlniqI5SwQ+hQwi
 Fhx703KA
 GQypk1vrgOe85u0qeG/1sCmUUtAiXZovjsEeKECzhEWSPJycgJGtOowZdogv1+fpMJ48nTMkgditG3PaHBAggCI5sHUn+Z+F9UqemP4W7keuSZUFtbhOVq9182hv2B9uC9DW8RLcK9/OY+dfumag4A9G7S4pF+SsuVjj6QqcASY8nIWVueIg2G3r3jHv95FS1QmnHu+l9dpTR5t3DUOOvoAjAsDZ7S0NcwQUjYrPm7OfcYyLSOoZmlIfTy1jWVKN7BeygzGRxW9bT2kIEf6+ZcaF8BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  6 Oct 2026 14:15:46 +0800 "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com> wrote:

> This small patch series fixes various typos, copy-paste mistakes, and an
> incorrect command syntax in the DAMON documentation files.
> 
> Adrian Huang (Lenovo) (3):
>   Docs/admin-guide/mm/damon: Fix various typos
>   Docs/admin-guide/mm/damon/lru_sort: Fix copy-paste mistakes
>   Docs/admin-guide/mm/damon/usage: Fix incorrect option syntax in perf
>     example

Looks good to me, thank you.

I applied this series to damon/next [1] tree.  We are now quite close to next
merge window.  I'd like us (mm and damon community) to focus on making mm.git
more stabilized and therefore ready for the next merge window, rather than
adding more changes that are not really urgent.  I understand this series is
not really urgent.  Hence, Andrew might not add this patch until next -rc1
release.  In the case, I will request adding this to mm.git after next -rc1
release.  So, no action from your side is needed for now.  Let me know if I'm
missing something.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

