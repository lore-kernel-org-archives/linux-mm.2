Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CA8BF532C0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F83A6B0088; Mon, 23 Mar 2026 20:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9826B0089; Mon, 23 Mar 2026 20:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BEF86B008C; Mon, 23 Mar 2026 20:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6CDF36B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:49:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 158431B9625
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:49:33 +0000 (UTC)
X-FDA: 84579123426.23.A4BC073
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8CF38A0002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:49:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ldj034ey;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774313371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3nG1Rw0s9rA42bux0DJgkfrcrirY1f21OYcL6BLQatY=;
	b=UYqF0tU1XrUBklcYNF0wP3JaF4Zyq5Apkt+YGtpsxRefX72upSorn2omz+4K1wUJfPcODz
	wwBkIUHEXSTP1JkrVedAAiVrmBEilgbW8CqgcR2jQYK6LmYKYMHgPy+cP+EzakPhWBq+ai
	3YTcFw5n9Oi5shtkN32lqm/p3VN+Caw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ldj034ey;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774313371; a=rsa-sha256;
	cv=none;
	b=TJM3/Lj8K5C618WVCfBJfh477JS611H/277NcHkXPEj/pgtIm4MLiDN+Y16gKJNMiM0YZa
	BoXvQkmYKc+k6v0Gw4Ox66kKq1aNLCkO+i1i0iwJmqNVgsa8WaiHshdMpJLWBatHv3GaqO
	n2+brVZ0QDI5frJX58hpcEH8Au9jN8E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98DD0401FE;
	Tue, 24 Mar 2026 00:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1F2C4CEF7;
	Tue, 24 Mar 2026 00:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774313370;
	bh=ZaXWNyOg2XPWmXfa+V0XWwnXp4bXe0r1OTT8sXXPW1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldj034ey75XF5zOvdPKcpjcNxXPmm9zzSrHMHntBi10cgrtdYQA5Spk6IA1E3H45N
	 Kf/PLsmdo8wLOfUlrbF1epFNV57w3M//OJKcdGCsl+4V7PXUorwTTpxLZEJJQBEUbJ
	 YzhY/QDY/43ii0ojQz/VOLf/UXYxgPRB+Oi2mnHIlJW0y5PnJG9pxnpR6NdoC2sJFo
	 Uj7apBzIcas64FVxEiYn7ke4yoItkE8z9PgQzwardsuBfAi/6J/seDwhpXbWvC90MO
	 2d/B+O/Gc0cuMhvg+jgc7AcnEcz6+6CyfSRSbBeIkec4ypOSe8E44wF6TerGWpHhgp
	 UzaIn9whoffhw==
From: SeongJae Park <sj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm: kmemleak: add CONFIG_DEBUG_KMEMLEAK_VERBOSE build option
Date: Mon, 23 Mar 2026 17:49:22 -0700
Message-ID: <20260324004923.87190-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323-kmemleak_report-v1-1-ba2cdd9c11b9@debian.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 96k66jeromcyw85ituwnazshko1fsbgn
X-Rspamd-Queue-Id: 8CF38A0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774313371-578756
X-HE-Meta: U2FsdGVkX1+eHV7lFmNXmrgRbgyCA/9hEKADadroydDvCuIQI6IZCMP+q5Oep8iplM0Z+uGuhJ71Sm6mnzzBNiMRlJlZaEkTq7TESy1sxkoBAtYRa7drvblPU9jqIS89rn52Ap3V6s1TeUwNTaDYzU9RwbZA+uO/gQ4xVella8VDFofl+A1tqgsxBceNtE5N3A/9jjSVk43N742rg4zPHxuOZKttDJuXQX7xVsQp/jY4m9be4lgxEErq+nPmVGnsUSN9BM54uKPqjdzV3kATwlKHD/jXPrmmYM4eNqMbB5juTI87nKdSIfTKlD2JFEuuTbCkMElI3o268WBDhY0KVGdOHFMqV+u9jpSbWuMM9EWU+VoyOx3UzivyuifLaP4E1KEtFFDq/z3arIbKdDJ5VPYq+MUkfyATNMUs35GnhZ3QiSk8GZFAZAQz1tNMqEzXYimQ7MO2hCTyYirM5MFTeDsET1gQKzHpZVuOhuIG5xm5g9sq3LXvFtFeVsGrgWhX3UqELQkZn4ae7mbQCqUOc8zne2vtLFKZ7RkK2rs8G5G/whmrbjJVOPkkAnsQLVbuEbtmo4fgBekhNw4RBDAuE/mIWT7ClpRpI67LHI63SXw1bSBwTY7Ln6cJUXPEPfsRHrY35/p7rE9XKOPv65Ufc+/4EKIYGkw8Y3pCMF/POvr8aSAJ+/UqEB/RkQTD8GAOi7WnEHXzCqMLZaS8q9GHBp/1sQhw1i7X4InxbicjH6NaKkMocBI9FR4IdIwnSZpbbwgVMPgAoMgYdOhkPdabe4bWijFYoFODZehBH1Lsyt/szIumRejkqKCDfA3GUAB3/K3Be1U54CWPXO78IqwgzKK8tNxUhA3h/td7gpZNMvt3qMwcqb4oNBXczTr7ZoCbwXY/XYqRpvsZa+qx3BdRQpC963vxDfFk+pisadTHovT6xlfSEhvmqGMlrIoxCC7snftYC9pPE9Omr/NaD/I
 7TTSz1hS
 nDOdi6lXyYkvG/5I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 04:12:13 -0700 Breno Leitao <leitao@debian.org> wrote:

> Add a Kconfig option to default kmemleak verbose mode on at build time.
> This option depends on DEBUG_KMEMLEAK_AUTO_SCAN since verbose reporting
> is only meaningful when the automatic scanning thread is running.
> 
> When enabled, kmemleak prints full details (backtrace, hex dump, address)
> of unreferenced objects to dmesg as they are detected during scanning,
> removing the need to manually read /sys/kernel/debug/kmemleak.
> 
> Making this a compile-time option rather than a boot parameter allows
> debug kernel flavors to enable verbose kmemleak reporting by default
> without requiring changes to boot arguments. A machine can simply swap
> to a debug kernel and benefit from kmemleak reporting automatically.
> 
> By surfacing leak reports directly in dmesg, they are automatically
> forwarded through any kernel logging infrastructure and can be easily
> captured by log aggregation tooling, making it practical to monitor
> memory leaks across large fleets.
> 
> The verbose setting can still be toggled at runtime via
> /sys/module/kmemleak/parameters/verbose.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

