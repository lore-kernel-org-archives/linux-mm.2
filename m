Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B87C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 00:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796FE6B0088; Fri, 10 Jul 2026 20:32:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746F86B008A; Fri, 10 Jul 2026 20:32:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684056B008C; Fri, 10 Jul 2026 20:32:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 431186B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:32:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BEB8DA05F7
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:32:28 +0000 (UTC)
X-FDA: 84974619576.13.CB33D46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 33B4B20002
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:32:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbpGi1y9;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783729947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O94T837359p5/1+I5KrV7oXNHB34fvrkADLpD0vBISo=;
	b=Bjw36CwhzHqonqbtfmEff1Wv2G8Qg21WgqusWUkd5fKvueuK6eenQrjlKnXlu9UpLGBbE5
	xzcCvt9T0zSAAbraEr6c/yn29Cl0gGz79dzkdpEUTdAz5WnaihVMIRolnGeI/sa4+kdkou
	MhhleQY5tynGF7C7X94JwqJO6AA3log=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbpGi1y9;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783729947;
	b=Ym6nRLbwp0jjSOATdUAkSpi1zPXZDQyHwFGG/z86ARpZKEy4aHZrxnykIQCOaKho5cuWvk
	9giDPDgCEBaPIuGLHSk9aJ8WoOkXNBVmT2mysR1phUx8e937Ehfz5rPMbkcGI5MgV7ABNT
	h3D/7DdAmsKHDGX49wZbSa9dlHb3+Tw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BF75408F3;
	Sat, 11 Jul 2026 00:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2AA1F000E9;
	Sat, 11 Jul 2026 00:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783729945;
	bh=O94T837359p5/1+I5KrV7oXNHB34fvrkADLpD0vBISo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fbpGi1y9TAMeC8S1d+Mt8Ak4Q9UfxJ3DzSFKxt7fP6P6JdoUOCm2TV6KIhs9FczX7
	 dctEH2co+Y/neXeCeUx5sOvnF1JEkDb2IXIsn6YNi+ZzH8Sal3vLTeHt9B8H1R4TqP
	 hoykd/sktfwieRnftMgVsvY8marBmlcb5sC8AMd8wUsBH7y0JvSRir/kjc4NDpBnYK
	 ErrsXoGS+z4zeIwsomsxGxyfbsTo/L189C8UbFNu8a3Zoex5/6g27Uz5Nom39hApTv
	 kUBmo1i55K9g0hS8/oe8aHEWRhiztsJavFzCsRXrhVue9celdaRonrOaMNi/Zwzdam
	 REZpW/zAFMskg==
From: SJ Park <sj@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH] selftests/mm: remove obsolete hugetlb vmemmap test
Date: Fri, 10 Jul 2026 17:32:14 -0700
Message-ID: <20260711003215.32222-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710092427.3459121-1-songmuchun@bytedance.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wgmepk4t78d8s9zqdxh3ow3bgs6p9zbq
X-Rspamd-Queue-Id: 33B4B20002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783729947-326487
X-HE-Meta: U2FsdGVkX1/0/6eX+ccgrcTyG3XNdy2JyWe0J5T5RffxxqALmHRBOR5ZfStOGqJFlI8KIeJzzbIeEsZI+nLg2lpnVPo7ggkQwSSkRHfUHZLa6V2Xic+2IhaNax/OBbJ3BaZMbTWT8e0UlfocrrZhzHKJ/zrrcagUeTcP4clnvmp9k7XiGRy42/e8bkm5/lotWGJIZbtNSpUNvEdOkMfPBDwPcdR9kqokquyOvXxL5d3SuYVq3Naidbc6hLg2bdcdKnYI2GZXkw02Pi9neXa3kA/623LaIFTo3a+Jkg9ovOTvfmdTkLm/y1pE2QwBwJ3zYtUrfTBo0cvjjYLARrw8J2gUhmd7Mghq6hCQzDtNHABtFrjhISmdGe7NW8+Tl5U1StFu6Od08oypu9OAFo9n1RvDJ/oKiztYqKlniShy1HDnvhGhWb4IVEVUmTfHh2rv9JJekCjghGSMlTdyoTgyGpQcn2kyyJvDLY60WrFjviVVdp/rKKOgnNuIzbvP/nlHRoBfZQATViGcEpNPSTEyF+/ofzx9G4klLcVrDK20L2L8j0p+XJtSUQbQtqiU3Smadt7GGqgq8kR4ABASG8v89I6WvxP8rz9XsPMm2hWsrRjXPfb6sptBDdoMNiz0vM9RCPY4nOhYk3K+wsfsoFMonmHMFxkRA/V9K7mMpINcVkhCyE7a94tdQSx8kbFszmSSzYJd5s+k9gYVxCOz4js4IbZ7P4wmpEuyw0vYmcqhsx0K1KjqbBzHmVIcntShMyvSJeU2nrP/jpAUHrJn5IDD/op8rbyrcZQ1TyX02pmlOwBL2aQtRw3plNE9ZolrNMxZM1sxnGuDFeFrkTMs53QeyBiS/BEvgqqu3V54jlSrywmITthBAXVVRLcRYlWfLBlJMiftflH5ODwIXHzJFQmJNWwY5CD051yI6LwBS8y6tnReP2yuIc/UcQC8mdoQ8XyhSNnRuO1zJS3I6kNtsb4
 KCgq13wU
 SYtDtKCz93pTFOOf50iaJoY/wZcblFDpTIgamzWGs25nrh87K9ROoreeaEetxJpffIAfG4fuQ/Io4ySYQppfyDERZ+qGHNcW1bAr/DzO9Z3H7gZn+GpNZtSDyGaQHZ7KBa4hB3jFo2XPRoVAAyak+BmrV7j0HNYr1n+lfruwOzWcDr/Jj0FqX9mmvspJ/U6T8PYk84evTcY7yLMRI/fdGdMBpXiilRIf2AiP6LWRm8f2n4O11g7Qp5c7LIHtbAXyi22wKMc36oIFoaNmLN5Hz6PnOPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 17:24:27 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> The hugetlb vmemmap selftest was added to check the old HVO
> layout where tail vmemmap pages reused the head page.  That
> assumption no longer matches the current HVO mapping layout.
> 
> HVO now keeps a private backing page for the head vmemmap page
> and remaps redundant tail vmemmap pages to a shared read-only
> backing page.  The old page flag check is therefore testing an
> obsolete implementation detail rather than the current ABI or
> behavior.
> 
> Remove the stale test and its build, run, and ignore entries.

Nice!

> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: SJ Park <sj@kernel.org>

> ---
>  tools/testing/selftests/mm/.gitignore        |   2 -
>  tools/testing/selftests/mm/Makefile          |   1 -
>  tools/testing/selftests/mm/hugetlb-vmemmap.c | 132 -------------------
>  tools/testing/selftests/mm/run_vmtests.sh    |   1 -
>  4 files changed, 136 deletions(-)
>  delete mode 100644 tools/testing/selftests/mm/hugetlb-vmemmap.c
> 
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
> index 9ccd9e1447e6..227476d8ff1f 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -3,11 +3,9 @@ cow
>  hugepage-mmap
>  hugepage-mremap
>  hugepage-shm
> -hugepage-vmemmap
>  hugetlb-mmap
>  hugetlb-mremap
>  hugetlb-shm
> -hugetlb-vmemmap
>  hugetlb-madvise
>  hugetlb-read-hwpoison
>  hugetlb-soft-offline

I remember Linus argued [1] we shouldn't remove names from giignore.  I don't
really care, so feel free to add my R-b: tag.  I just wanted to call out,
though.

[1] https://lore.kernel.org/all/CAHk-=whVY4mq1Fd=Vhwy0dK8fR5cOLkiy1OZMG4QyEMaGEd9ZQ@mail.gmail.com/


Thanks,
SJ

[...]

