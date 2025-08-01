Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DD0C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 23:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB9F6B0092; Fri,  1 Aug 2025 19:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093796B0093; Fri,  1 Aug 2025 19:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB176B0095; Fri,  1 Aug 2025 19:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E27306B0092
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:39:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B39A61A02A4
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:39:47 +0000 (UTC)
X-FDA: 83729808414.09.FC32824
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1BE1740002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:39:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SR+dMqyy;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754091586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wvjENDVfhyFo54QyWUld/7W4k1C2AP7Lw1nydGOemI=;
	b=poQNKD4rjrMaDn6plA5vXcFSldPkNl4rN6fbhoU4q3zhmf7BakEoQNPfrvLXiAEeE4YY6J
	NiUZHYetIN594gQ1EgUJH/e+3PWi4fIJcw2ENdYHH5S6JIoJgm5MATwT1gZKmS7nkUNcz+
	aGGE0CkdgOKqhLURua8IsUf5pO9P4qA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SR+dMqyy;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754091586; a=rsa-sha256;
	cv=none;
	b=HXjKv2YBy94nvEUyv7UExULa6bc0xGDZ9uK7wnWBJuJUoEk+u6VGyugrWQjPugqKmrcvQD
	p7Cc0e8+PAuoyZvY/37RWc1n5SKardxymkoSNe1h6AyWZfBBirLJP1GYZBwx7e9WheqJdo
	DuibLTSnOxkyuD1I92jxekg+wPwBCgM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 134755C69D2;
	Fri,  1 Aug 2025 23:39:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E02EC4CEE7;
	Fri,  1 Aug 2025 23:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754091584;
	bh=5tJRCSbuSBYIOjiD+lXubjl8LyV9TAUxnOkonO+FxG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SR+dMqyynB4Kf1Du44mgvAR58fTQ1TD0vFD/4VlOME/qAgvk0Aj9aYqefvY4VA4DV
	 IAY1zgJnoEOcMzoKWmDyMsTOyaou6ItJXJG7xP/3iobGCfmJqjFrhIiaGvxfqqYe5+
	 aAJ0UnM4TzQ/Jd3Th3KTXVRXY2nLNfBADBkf1KKwJSvotGYv9mWn0Pgy9ZpFXXF/D4
	 oXWgsMVC4AokCvAhItulYq+ThaOrZvH3mqgL9Ys46OeaqowPGDVwn9BCyIHfWLVtlX
	 noLxXHWVkqyBXsbfgOMdHNYfwcJvJEO9kM0ZXUNICESFGV6+2n+AkQIrDgs4X1J05u
	 KH2p05N4aNojg==
From: SeongJae Park <sj@kernel.org>
To: pyyjason@gmail.com
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/2] mm/damon: Add damos_stat support for vaddr
Date: Fri,  1 Aug 2025 16:39:42 -0700
Message-Id: <20250801233942.1614-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1754088635.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BE1740002
X-Rspamd-Server: rspam06
X-Stat-Signature: sqbu983mmyn16ibfy8bg75941o6c6sz6
X-HE-Tag: 1754091585-316558
X-HE-Meta: U2FsdGVkX1+KShICkg/7oHgQxpFUHtRkZUA8Z7mFPs0RWs95dDMA15vUeeE2G4Cc3O3LxirgaMFvcbUY0AHgVROW+X/4z2qVFXrr8a3UBjPWoPWZ3sJxqfqA10qoXwr65BA97M1tJw5HjaXFwX8H3Tfc7hUnALLGdShDvXu6VG8tWyY1h1ZbRGMf51a0hMQKFFl5G5/ta93elw2RCELJmdl6C/aQFMxfYXSgsLxOwD9tKXK2N4/scJC9WWiq8vfLnSyOxebQtwZ4ClMqef1YOwiiIu9f05LOKFBjL/XA60rRVqdg5e+AjkGK/q9PapdWaZrhsjbwRaFe6UtanYL8WeCPYwYvpWU77tebxgERg7zI0JWbdK0Ybdx93UFt7OuQC+YHwyo6gIhHrl9zfffiy7ffeb5cQsKMAqCM3FwWHHJ4n47wq/OB/HqHMriHRX/0PsIkpy9Vv84ETFemU6Hlzw5mgtvxkPh6cXUf8RckrO07ZCbAq34v3S7GNLUqPFSQkazf1hgx/zx4/4ET/mG+A4BV7yeC+W37YVx2kF9yB9a7Bhn+/W09JSNQMm5gMuOiUiMW9hbC80dPQLKt/NCL8UZwZHIg20FPS4bty+NGt1KVd302aJmTMstkhOsE/AoMiNCA6L9J4Jr94aKsqnf9iPrclc/LysFJHoEpX9Mm2y9N2AWh67dhXUIUFERfSU+IblPKYah9Vs9W5jBf7kmQ7P0dq04xNL7rEUksk4RkmXYkHExGtxjTZPx6IEhtzt7ph4zXFqzqDXZYC7FIFoxO43+e387Ogm4pMg0zD65f/E0gFMw7K3S2Ye5YGeHAs+jNhKy/hA6kzXg6lAT26FuznZSaP4hYpJunhmkgH0hoyZOtoLkqnGwPtquwYJhKja2u2YRgQpXMtKddiuuWrhRUeQkH8/8cyHl3lTcujW4DQK0foas/gKFXALSyhAYuB67zkHscp5Ol9B3YQblzikd
 LFlT9RGm
 FfGg9DpekR05S+aJ5wX+a3/s2JCcimyAxDFj6Xr1qUB1St+Tv0o69HhNWE5Z8oXt7FbYDbcGjp9pkh3bmrW84PwK78TzFbHHf7oA5IGuWnzBibLq1IbxxSxmFmf0NwthOKgxwJafwe/6A3R+018jqj5slElC8cw9tB9I1oCW9lHR73rgpDrXQCPtNP4NlSvzh105nVpweIEn7pnNQouHoxyOytkh47V7KmmcJ/sI3paqPbvG41WZ76cl0+Bc7+wO95t8BVmcEj54ODV6VNL7iVYg6FRiIrJ+YBIHoYERP9Cv0XAw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  1 Aug 2025 22:59:49 +0000 pyyjason@gmail.com wrote:

> From: Yueyang Pan <pyyjason@gmail.com>
> 
> Previously damos_stat only supoort paddr. This patch set adds support 
> for damos_stat for vaddr. Also all different types of filters are 
> supported. 

This confused[1] a person.  Technically speaking, DAMOS_STAT action is already
supported on vaddr.  The lack of support is ops level DAMOS filters combined
with DAMOS_STAT action, and this patchset is adding the support.  Could you
please rephrase the subject and the above paragraph?  For example,

    mm/damon/vaddr: support stat-purpose DAMOS filters

    Extend DAMOS_STAT handling of the DAMON operations sets for virtual address
    spaces for ops-level DAMOS filters.

> 
> Functionality Test
> ==================
> I wrote a small test program which allocates 10GB of DRAM, use 
> madvise(MADV_HUGEPAGE) to convert the base pages to 2MB huge pages
> Then my program does the following things in order:
> 1. Write sequentially to the whole 10GB region
> 2. Read the first 5GB region sequentially for 10 times
> 3. Sleep 5s
> 4. Read the second 5GB region sequentially for 10 times
> 
> With a proper damon setting, we are expected to see df-passed to be 10GB
> and hot region move around with the read
> 
> $ # Start damon record
> $sudo ./damo/damo start "./my_test/test" --monitoring_intervals 100ms\
> 1s 2s

Seems you missed my comments[2] on your v2 cover letter.  Could you please take
a look?

> 
> $ # damon report
> $sudo ./damo/damo report access --snapshot_damos_filter allow \
> hugepage_size 2MiB 2MiB

Ditto.  Please check my comments[2] on your v2 cover letter.

[...]
> $ # damon report again
> $sudo ./damo/damo report access --snapshot_damos_filter allow \

Again, please check my comments[2] on your v2 cover letter.

[...]
> 
> Revision History
> ================
> Changes from v2 [2]:
> - Fix some naming and format issues raised by SJ.

Thank you for continuing this great work!

> 
> Changes from v1 [1]:
> - Follow David's advise to combine *pmd_entry() and *pte_entry() into
>   one. Also remove manually setting walk->action
> - Use vma_normal_page and vma_normal_page_pmd instead of damon_get_folio
>   to remove redundant folio_get and folio_put
> - Follow SJ's advise to only move damon_pa_scheme_has_filter to
>   ops-common
> - Change the command used in cover-letter for more natural illustration
> 
> [1] https://lore.kernel.org/all/cover.1753794408.git.pyyjason@gmail.com/
> [2] https://lore.kernel.org/all/cover.1753895066.git.pyyjason@gmail.com/
[...]

Thanks,
SJ

[1] https://lore.kernel.org/20250731175827.16060-1-sj@kernel.org
[2] https://lore.kernel.org/20250730200239.60984-1-sj@kernel.org

