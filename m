Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653C3606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 03:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=taT/mzxs
Received: by kanga.kvack.org (Postfix)
	id 732D56B086D; Wed, 21 Oct 2026 23:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E28F6B086E; Wed, 21 Oct 2026 23:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4396B086F; Wed, 21 Oct 2026 23:52:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 374D66B086D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:52:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BCD6D1A0713
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:52:33 +0000 (UTC)
X-FDA: 85348890186.23.3C49659
Received: from mta1.migadu.com (out-235.mta1.migadu.com [95.215.58.235])
	by imf04.hostedemail.com (Postfix) with ESMTP id AD97140008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:52:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="taT/mzxs";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.235 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792641152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNOMRbzYMbZGb6y5gxxZI8K9YrwqNsZRDhpCrVIh8EY=;
	b=x0C2fn2v3EZ9JDZWb+t0vLfAyOXUXZ6gbjimwTYR4HI9UF60b0a0Z4WOeHO7ajGH1vsa3l
	7NKPfto0xSoAJW4jM9/Qh5BBSX2C4uhADm64f9MB/uwKPaSY7dNmIbuCHHnGfxMt9fq5YK
	EeW0wJO55dDNGF7oBxkqvymEzKlEuDE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="taT/mzxs";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.235 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792641152;
	b=juGV2mxjZ/dVVWi/XfOALVvYYHR/OgXn5Z8H0cQxeTAOiTngGS19NwVVY13KdNKw3ylGSJ
	9g5q7u9Gg6L94bh/X9BQORdgn3QTN0U8xQuMtNqz+ItE6nBf18F7MD3EUOSCLgRiBZs/tx
	0CBghPlapr3bwt//7OXbSYJtcADuAGA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rNOMRbzYMbZGb6y5gxxZI8K9YrwqNsZRDhpCrVIh8EY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792641150; v=1; x=1793245950;
 b=taT/mzxsRCbeJUPiIxfhWUiV/XcM2Lh+W0BYcgSO6C1k671m2QgJ3Rwj/8CTnbnZDXsnf5+d
 Yozf0oEof6t822/R6V/xaSMnmTaH3en7USDeFgOcnTSDMZQxRMhphjjs86aS4aTQQqC3uVi6cr6
 kteai9BUV5uHyrVyyWox1SLg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 27a94bb973f2152f;
	Thu, 22 Oct 2026 03:52:30 +0000
X-Mizu-Trace-ID: 27a94bb973f2152f
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] mm: hugetlb_vmemmap: unify VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
Date: Thu, 22 Oct 2026 11:52:19 +0800
Message-ID: <20261022035219.45930-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
References: <20261020115824.823278-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD97140008
X-Stat-Signature: i14czpzbt7xnhozny7fnkqfmbxsy3hyc
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792641151-68673
X-HE-Meta: U2FsdGVkX1/UFle4LqtW76TPXNYaVQMs/VAlXW7NL9e3aYAE+h7L5H5KbYxbLl8+iHPnYBo97zzjiRxqZ7Ae8V+Fjk29m37DZtLkHW4lTthxoydggj+wAo8GSRJh/v9HeyJxKQ7cZomq6zsOJQaowaDXRF0EiTOBCUxPxBMVQElyCXVqXYX2o3glrfKNaV4R6hVy/mCXywPXXsoGV97Ys/PxVrb9iqDuf62tf9JW7IZIZobe84Ed8hILQeLTsFOW7cgciwlqSBVuXpOvZ59VavBuQ+q9dWWm2whKwaxHzkKghXvyhW7TUT5/y82wsuwHgVYaPvtnfAE1t24B/lE+uZuwWnC1us54Ei/MPkT0awfj+w1nq/4au8b1v2bz10EATKxooPSyags+56gOBnOyhBZOcbgAqtfdDvqzoGySJdMYC56Z88Xsa/cEp9Epbbbo8EVO/uDLh/d83aKsEl85p6E8Zf7W3OSK4CzqdhLLCWfmU8ej6LusjR5JpG/ofKqPk56VJN4FLg0enpHBolWQX913ZnKVtJkybB8wT/Fn5YEFsAIy2r6RpjihKjayS3pJP2mONl8ydZhp4SurXFjp7dBK57r43aW4d8gVHZpEWLUuJVqlJ5ua32UIVVsYyyhf/ZNSvBj+VB8hNYEZUbBJ2ZVG78gc00LWuiDG3Zb7ff2ufzy9OXHe1eUhADuIjHDZ6zXkNGwk99DEuz2uvQ4t1eyWZKHiv1P7ZKLOBGwtLGILDFuET9vXcQxf7QheKYsJBQlPY/ItjeJeR7/dibGNZdzmaIMbc5zu+K0nyee4ptkfrbrDxhuS1TYN+UL6cFCJ4N2ChlGWIKq/4UAWTkPP0ZeYFB6aWLW3Gr9IHqzt9Jabqjg2otFO//sUlVADjrab21AMc1/MAaZU8Lbr8+i0a3iEpoZT2RMNuRTWhpN+uSq5OOEgBh5zJfCeCtVyuAv4ivW+YxjodVM2XjeiOBd
 Y++BPv5/
 MzBMjRIBYyGDor6T3A9uju+hIAX2XMR1NknIF3dFHAMd2rpIlEba1UmC9subKnTIAIjFAx1nurGI4fXNYjfee2rv9IYge4EtgWqHdZ40CsiCwSOUkRq7l4epmnkLXnkryRNkpk/YnBNA45C7Zhd5gyI6IO88LnS/LA/5fxw9p+JjnDUHG8uBr8MKTjrX9g0EMr6yj/A9ssIq31z+jGOepLiPk1Qt6QthORvK+xeyyc2y85n8GwtCtW6Faje6uuYFtWIiVYRa+u9/JsUR1hO/bM7ZMu+SGSrT7DNX2zSZlzhKdmfBAPEYNrgorTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:14PM +0800, Muchun Song wrote:
>VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
>describe fully independent choices. A split-only walk can defer the
>PMD-split flush to a later global flush, and a remap-only walk can
>defer the final remap flush. However, when a PMD split is followed
>by PTE remapping, the split flush must happen before the PTEs are
>changed, because stale large-page translations must not overlap with
>new small-page translations that map different physical pages.
>
>Replace the two flags with a single VMEMMAP_REMAP_NO_TLB_FLUSH flag.
>Keep split-only walks able to defer the flush, but force the split
>flush whenever a remap_pte callback is present. Callers that batch
>HVO work can still defer the final remap flush and issue their own
>global flush.
>
>Current callers keep the same flushing behavior.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

Nice work, don't really need two flags anymore :)

If we're going to remap, we still flush after the PMD split, so we can
keep batching the final flush :)

Reviewed-by: Lance Yang <lance.yang@linux.dev>

