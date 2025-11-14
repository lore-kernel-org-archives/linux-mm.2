Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 877DDCE8D76
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6F48E0035; Fri, 14 Nov 2025 14:35:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E748E0021; Fri, 14 Nov 2025 14:35:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D942F8E0035; Fri, 14 Nov 2025 14:35:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8A678E0021
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:35:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 718561404CB
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:35:57 +0000 (UTC)
X-FDA: 84110217954.27.A046663
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B015D100012
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:35:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dj5HqMWk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763148955; a=rsa-sha256;
	cv=none;
	b=Qw0eHLlY9AVTDkf+dzK7bNqhaXALO2Uok8EZS8gDZ3ynFtggyEfraoDXrh/dSng+QQi4xF
	RiLE8wMV5WS20nzvZNUHQ9rFqyQJ2yU7l0gn1YHq2WGK2efrhs13RPs/1Vy35fTrFkliUq
	+ax3bJfZ1iddna68PXquuQoki2utMu4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Dj5HqMWk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763148955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyzsCX9cDFqpjYYE4CvxJEvrL1mAh/0NX+qFVB5a7ZI=;
	b=LKt1M3ewzxD8U1bAh7n4zM5Xoj10X8wGsJOcx8kHNEhvz1UBprbEMrZVkdYPXS/i1pEQXp
	kiqpagOgMYkwiGc+ifE/s6OqMUBeIxoy+wq57oHJ197pYZH7fdbx81F+AccgWgiiLNVuYl
	HdaMXc/Ok2pbiBlo+iIHQJPkaXCKk0w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A776540050;
	Fri, 14 Nov 2025 19:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4BCC19421;
	Fri, 14 Nov 2025 19:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763148954;
	bh=Q1O4BIVR1FCS7fU5WDAS+HptHA2cmt8TA5K3Q3jWw3Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Dj5HqMWkFNbuohcjbv4dicuiDeZh9VXlrv4Nq8qQeqKJfLexZPY2HiN/CaXHOqLbs
	 xsPClbHS3mTj0znKO+cynJD/nzJ1g3VtC1sRbQ5BZg8keXFC6PTtm07C9PEfRwfgID
	 9eQrI9Lgcfl4RcBrYMTj5Gxf8uCMx2ARWuSmLOp8indblWHrJwTNgBuho0KBn+0PHu
	 +yVFF9a1HKePZGlxXLWtqBRbi5qco9Y3hFVgdIMcgnLFjI38tialKDlHkQ8ynjQMux
	 grCYboOy1/R63jsDHZkcqmVY0m1TeO4Xvov+J/If6GUxuOUgBxayskyv16HXgznSbP
	 Y3uYfZM3JAT2g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v2 13/13] kho: Add Kconfig option to enable KHO by default
In-Reply-To: <20251114190002.3311679-14-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 14:00:02 -0500")
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
	<20251114190002.3311679-14-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 20:35:51 +0100
Message-ID: <mafs05xbc5rvs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: B015D100012
X-Rspamd-Server: rspam07
X-Stat-Signature: rnfw5mo6ug4qtusq3o8cgaezkwhyiff4
X-Rspam-User: 
X-HE-Tag: 1763148955-976058
X-HE-Meta: U2FsdGVkX1+ep8Ymb0OHE7QSuh6tUJs+3hXwL3Fff7cugPzcEGJunEQ58x+FZ4AYL9HadvItskp3kjHO+bQljQo8hQkPUSr+jlLNjhMaK1/kVAw+KZk0cHYwdh3LnC9yOOfaYlX2DMZoR2z0Yw6zVEgxx1d/KuNpWiBRdo1wfmFp5hzDwdWxR0XKA2PWJ/1jRGKw/P+FH+0OLlpI3RjkPWAQYzZff9VnzW1+JmGNx4HsCH7FqfX3juzyz5qEZY8HKbJcJkfSAiY/I4uBXgP1Tmga1MmXmJOxbXbZiSTSqodwK5MusxNbW+TOq7tDUQ1FhKxepXo6Uo34WEq8tCKQxyBmTBBpe0FjjKB0mDIA2NcC5ZioC052bXyGjQATOU9C1iEWqBA1wsQ5+84MAP5lpruCE+iokiE5Fmft8Pj0JfABw1aaeU6KaTSDmJk6JnAi6OfIy0j2Rl6V5TPWZctL7wn/UuyfBngrITYW464j2Dbq/qG5vcBWD1lSbrVDBRjm3DpjGr4imctiLJOk69eiqh+5im88Dqgj3erxtuHzbp/Cffz0mpLh9xBtjIMnXMxQeEiqnnW176PepBUc96LtmDKV2UZLvvSWnK4ldeLfhviw3YkloU5aKxd/Xlvcmihqfepfud66fnRpns3qCb7/qlmwyTcPrbLp1xLfO0AOjlRTvNWz5sXL/BTCIuiqW52iJMugKcqpOwCabz5nQWKQQbK8vzGhsejNvibyUvWHQdmTx1cVZwSO0ZnsFGaUF7JvIiuln1lTEPXVRFrpwy6YKDN7Pl02RYfEkg0WpwWx5I0EHYG9KLfXy4NuLkNPbCEUgJmV8lF9Ugqa6y7oaA3njR/+g5iTrFs/cge72xsKivTke94DJH3LSqPCfK8+J7a/THfa2pdbthsaIthEr2MdFyLrriFXjUm/b0oi42IYq4m9M0f8PhN1Me5U+p24+awhqyvZEWa90xabCftfbfV
 xIPCMCXR
 Cf9HonT0LoMrvuvMzUggKzb0uKuIKnLMuMHf1M7CZRlnaYvNBFM4FfzjOQu7coCq8nEgqpxgbkK76w2gJGjMqrmc13orjRa3NwWznZOxKzFmFvvl86kdJCEE3WjyW+C7P298hFqL2hrh01KNfPa0FTo2Jq3B455vouXTdQMqRb0mLPvCQgAa7KBl2HPUOUV8Y/MoJoSw4lmQgmbn5ILV7HoDVAivVshCNvvVSSzooid0cbWx6I6GGGedW+l/IF2BOTkKt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, Kexec Handover must be explicitly enabled via the kernel
> command line parameter `kho=on`.
>
> For workloads that rely on KHO as a foundational requirement (such as
> the upcoming Live Update Orchestrator), requiring an explicit boot
> parameter adds redundant configuration steps.
>
> Introduce CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT. When selected, KHO
> defaults to enabled. This is equivalent to passing kho=on at boot.
> The behavior can still be disabled at runtime by passing kho=off.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

