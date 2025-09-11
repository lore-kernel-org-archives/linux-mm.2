Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF1F0CAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 11:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36EE16B000D; Thu, 11 Sep 2025 07:52:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F6C6B0022; Thu, 11 Sep 2025 07:52:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E0F6B0023; Thu, 11 Sep 2025 07:52:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FCC06B000D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:52:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF9EF16043A
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:52:10 +0000 (UTC)
X-FDA: 83876806020.16.3D58A1E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6C774160004
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:52:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WhSc4X63;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757591528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFSNAReIPxMfDq0//HsR9GYvcebZMlltpyKxC4QevlA=;
	b=IwOshKLYcGJigFxnTRU4kvDUIqXmcB+Qdz7zKvbMo/KE6c3tZWnxjZx7CCHI6EFnoz6z8/
	MJzvMKgmob5Fd0JlyEbbQpp4RVbE/wPr4/Zte8BTYSIhK3WbFiZwkrnAVfX3agb6x3F2Xz
	rCoGSoyA+bi/xqA+F6vo0YVdNi/2Opo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WhSc4X63;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757591528; a=rsa-sha256;
	cv=none;
	b=Dlfzu5OUojKMIhYHIqVtas/8LFzxMsDTyZk9M2xnYXE7nyr4UP8+pSXB+Y67YUJjBcPADQ
	eg+BPJzrHhSE9ngkKmWsX4BYC+lTlYB3dYjPEgIN6agrG4VVJsIq6Z095Dcx+aMNlluO8M
	0U+mxZHdTyfiUzQRxoW+NW3o2t0pSeU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757591527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QFSNAReIPxMfDq0//HsR9GYvcebZMlltpyKxC4QevlA=;
	b=WhSc4X63qwLqyAv0SmW/MYfjUmwnrHKMxROidgne1fCdaunzx8xF16ERFs90iayEgLrMb1
	UFZi6havjawnbSEv7JCpNet1AHeZoU1bZKcBnG2BivhBUIjUYMNe9LVZUc8wZb+HFpHQTD
	rngajiHEGxZJ8KYU5j3dDWYTz7IB/3c=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-18NiQpjvMDGZ9Gki0W46hw-1; Thu, 11 Sep 2025 07:52:06 -0400
X-MC-Unique: 18NiQpjvMDGZ9Gki0W46hw-1
X-Mimecast-MFC-AGG-ID: 18NiQpjvMDGZ9Gki0W46hw_1757591525
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-55f742d8515so400780e87.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:52:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757591525; x=1758196325;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QFSNAReIPxMfDq0//HsR9GYvcebZMlltpyKxC4QevlA=;
        b=UY5CrCK2SYnCb9mWit4ynaozKq75Kb2+UoHVLCMPqPwfWpPZUeKYb0Hm2zXS5pNHAA
         x5N3QKbcCSyZQioKUMrE6FuGokYQy1xdVmXlqUkj4NQkYW/0PYl0HKhDih2dqM0rNAAz
         2Joc/JAdHynooUpnG0vig2MSWhh7Ne5GCgRTpSIeY18xUE2U2Oi70WY/PtxSPnbwrWfV
         pEAZEXUN76Orn7zmLVTT3cc2v4MQ+UnsoWzSoIDz3oF5yh4ruIkohsTULIRMW4EAb6GM
         1INS4CMnERyhKvgbbgnGBHlE7WJwnCJcenzOvX/EXAeqrhznf0oTMHSdLpVZz/syZzvo
         uC7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVBHjvGt9QcLTks9lC1KtPfKD1r84vRuR7JkiKMLhExj6MMBr4m2XR6mpjNJloaJwAV6aoPQgP61w==@kvack.org
X-Gm-Message-State: AOJu0YxxqaewY28lAHVeA20h2l+6hiicU8fF9m0LzHQtcmUnAdXRg4BB
	ma6ciprhJeMCjicxvu8vTmuqe/ox6R+yUrqyp3azIkr11g1RMzP0xST8Fx6djhDi8HzWNBEyf1b
	Umjx42QaWQS80CTYzhrUC+ybAB5kObviseG1oq66Hl9uP1fagFLw=
X-Gm-Gg: ASbGnculgdrmpN9SGZxMaco0Gs6KBijgmVuiMgAySB34B2l+26aLK/YT1d1+PuVV5S5
	k4QxC0nGSUlyn49WmZZSaR8H1a9Z22l3ldgGN0vNl4ZRXC0oqfiWJsddvG1zEoirepZa0L47f/i
	AYyA9ulkOESYjOW+J4sbwXYXXAiJyq7vpvPexplRfXDlpzfN3L2AB+O4g3zmHlKW1JTk74c0TYS
	tQqyVFeWvED+rmsGb/nwP0BFwexiv7qRC2SAI1qGbcrVO8PVoKYJAMoi6MTfNy+1kEHEW89TQso
	ncHsTfLMf7d/6VU8e1ncxnKjZagyuIYba3rrlmMY7jUx+TprBjPGTj/PIl+hMrUAQLSH2x0EgDZ
	ioEjhjk1TqwkdfDooKW9ZRdRnE3Sd5c6AVZZ6LDNwkOeVHd8sxg==
X-Received: by 2002:a05:6512:3e19:b0:55f:6831:6eff with SMTP id 2adb3069b0e04-5625eb95710mr7497427e87.4.1757591525051;
        Thu, 11 Sep 2025 04:52:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSZqn3zLcuK5tUPBaAcRR8ioorhgaZjrssIarYSMWB+fPQ8ZMZad/gn0ZbUOMVd1PP6SS9vQ==
X-Received: by 2002:a05:6512:3e19:b0:55f:6831:6eff with SMTP id 2adb3069b0e04-5625eb95710mr7497368e87.4.1757591523996;
        Thu, 11 Sep 2025 04:52:03 -0700 (PDT)
Received: from ?IPV6:2001:999:704:9310:43e6:e14c:406:e339? (n7kwfhcd2z0e9u7cxfd-1.v6.elisa-mobile.fi. [2001:999:704:9310:43e6:e14c:406:e339])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-56e63c63e47sm377870e87.80.2025.09.11.04.52.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 04:52:03 -0700 (PDT)
Message-ID: <d35eea42-ed32-481f-9dcf-704d22eb8706@redhat.com>
Date: Thu, 11 Sep 2025 14:52:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 06/15] mm/migrate_device: implement THP migration of zone
 device pages
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-7-balbirs@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <20250908000448.180088-7-balbirs@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aXR0ZykhKkUfCRzWU4tqP93den_9WCG1oxiPKynYYDM_1757591525
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C774160004
X-Stat-Signature: jtknmxj9aggcssi6frdd75cbsinp41g7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757591528-614115
X-HE-Meta: U2FsdGVkX1/LOqPwHJYXYVo43nAKNfdGWQOuYyEACons/GN7Sgk1mW5ln/WPR17U6xbBwm70LKWCBBIcNe3QxoJgltT/tHgekfZVpkjXwZ2MWS/8nnPgcUlqa3qCCPbsOHIZ9UbbDYNTAnKtIsFNHk9PwyjMGY4+y/L0FWyb/9S6EQ7zPho/n6Q02S5Hgz8iGr24oD86yaovj3BLyKFoCrrC9zKaS91sdquHdrLuH6TSMsgh/qT3PEQzv+wG4LrI608ePXMAEFVES60OW8MH46Sj9dXbWPza36na1BHtlrt9zVlK67QHs47Kgk6FUzR4XYag1Ibl2VTxOqUua/Z4qPZH91Oxop3eHD5eKgcKQHA+/xjh/xpYodfMhzV4SlACfoVG+KSuQ0zkNfxMCsdVnlPiWwTmASowDay85EcHAf8hCICMIMbV0CU8AOXeauSyI4AcXNNQ/CXaUTiE8Usgcjeox001uVU1aeaRxRT+h5PBgGUTqHfiM0XxNZ/8CizP+EY7iqzHBE42XvmhUGvqFqquqJsa3RNtdCdL9FFSrKaEIvOzGh7//5QbvL5+GfoRZK0TqBEgUsFM7aPzv+c3zimyuffKv3BR3Q3FCZvFRFG4W1YFRL4106gV6CVTHSJxpmwg8rN6/TShRuu6XeKO2oXZeSkHEw+ocLRhdiRBTbG7SXW3HYs467iWkmIalRM0VwkGO7zeCkEnzblXR3MEBE9BqI486SFKnjuvhOX7LPlePy5PQIAebd0gHA34iIdYaI+DOl43H1IsYRwF7hUJpgGrux0Np7qnoOhAupBGkE7JSvZXFYMJ7YfweN5v4ysPwBtH83+aj/hVct3Dc6pmCwdqCPONjY3zDm7ZSXXwoQ1dk7B36u7jrWhJyWD6I954xq86z2odgSl+fTnJEtm7lojgAGyFGsaTbSKIIsvt/K3q3Nrhmkl8RsfptiTw4MMQ7ixpumK67mGbGWI5b24
 inOpfn0O
 AziJZSejLfx3luvdDul00SzFbyhu900wKkb1t21gVj6L9jRm4sKtOCuPu5GjdIp8huCc5MS48im4mThNtb+3ZLo5/ESpNlpB7lZN6/dcm5+VJTZi2FomxzT2O6n7HhfU/vkocLo8wvdSzYGXEvN1rzlKW/PF2VQDY2pzlrfktP9FY8TcIGK9+gb8nYwqvpZQvIo5DJHgnVmpRzD35h92iVwsbGst30VeRWDRve1GKMfGMatFfMfmuaFs2hGpozSb4LCb68tkKgjDyzYYxkWs1wfmNDqI8HJGLa0BrVi2tRMvsL1T8HDaICYt3GbkLz/51cosTM43zwkcYwMNF+VCh6g0btKYK6VEnxLLYiIf4b9toJek/JbQ4VDoNP73buk7Cz8gfXgTPWQ0gYZgXc1FYsBjmbIig61l3nLgx+nDKbB9VAbXRviJvq9CLP6G+Wl49dF+AmCe7HvC8PQcC2GWNUpWPQJ4So3d40IjxcmYFclpM/bEVNxysB6RHnx8+tCLqTbt8FY2VsZ3g+nsulThMJnAs6spetJ90SUWeDHIK2SsorWrvFgWR2ygDJu1rVY+B9HzeM6cOcbnzjur7uidKyTjWol9a961xhNNizGFqo7g7VhcKIuUIfQ6hyevJVqO4l7G7CcGJC7rRzvyvIQv8oSFPcAqMyyD4WmjOohRl5/iHZ2q6a9iobyMb+yam4oh6Xqxkrdf58+QYQWnhK2Nc5lvEtvFwEJDlXEkJt2hczbJ/N8nXzOaG5Y5qRvAkihgDANNFdiZtIzpvAgOkEYnf23IzC3sQjBWByJKvuzJAITR/igDU8UEYrsU6xhEfXNgi2nNcS7BpdDvWguj0Vpv8HMgyabRsKfPE36zPMH6qUwn+HswfDAIWO2DlC3fxgHFVqjXOuiD/ZOvRQhnqVb6w4XqY1638fpxTW2fkMz71H2NCpvoRRvMbviJ3U3KaE6PUP4yRGm7pZScTzeH3vCuweQryTZLB
 QthJvfBM
 QKqtLQ4OMPQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sending again for the v5 thread..

On 9/8/25 03:04, Balbir Singh wrote:

> MIGRATE_VMA_SELECT_COMPOUND will be used to select THP pages during
> migrate_vma_setup() and MIGRATE_PFN_COMPOUND will make migrating
> device pages as compound pages during device pfn migration.
>
> migrate_device code paths go through the collect, setup
> and finalize phases of migration.
>
> The entries in src and dst arrays passed to these functions still
> remain at a PAGE_SIZE granularity. When a compound page is passed,
> the first entry has the PFN along with MIGRATE_PFN_COMPOUND
> and other flags set (MIGRATE_PFN_MIGRATE, MIGRATE_PFN_VALID), the
> remaining entries (HPAGE_PMD_NR - 1) are filled with 0's. This
> representation allows for the compound page to be split into smaller
> page sizes.
>
> migrate_vma_collect_hole(), migrate_vma_collect_pmd() are now THP
> page aware. Two new helper functions migrate_vma_collect_huge_pmd()
> and migrate_vma_insert_huge_pmd_page() have been added.
>
> migrate_vma_collect_huge_pmd() can collect THP pages, but if for
> some reason this fails, there is fallback support to split the folio
> and migrate it.
>
> migrate_vma_insert_huge_pmd_page() closely follows the logic of
> migrate_vma_insert_page()
>
> Support for splitting pages as needed for migration will follow in
> later patches in this series.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lyude Paul <lyude@redhat.com>
> Cc: Danilo Krummrich <dakr@kernel.org>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Mika Penttilä <mpenttil@redhat.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Francois Dugast <francois.dugast@intel.com>
>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  include/linux/migrate.h |   2 +
>  mm/migrate_device.c     | 456 ++++++++++++++++++++++++++++++++++------
>  2 files changed, 395 insertions(+), 63 deletions(-)
>
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 1f0ac122c3bf..41b4cc05a450 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -125,6 +125,7 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>  #define MIGRATE_PFN_VALID	(1UL << 0)
>  #define MIGRATE_PFN_MIGRATE	(1UL << 1)
>  #define MIGRATE_PFN_WRITE	(1UL << 3)
> +#define MIGRATE_PFN_COMPOUND	(1UL << 4)
>  #define MIGRATE_PFN_SHIFT	6
>  
>  static inline struct page *migrate_pfn_to_page(unsigned long mpfn)
> @@ -143,6 +144,7 @@ enum migrate_vma_direction {
>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
> +	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
>  };
>  
>  struct migrate_vma {
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index f45ef182287d..1dfcf4799ea5 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -14,6 +14,7 @@
>  #include <linux/pagewalk.h>
>  #include <linux/rmap.h>
>  #include <linux/swapops.h>
> +#include <linux/pgalloc.h>
>  #include <asm/tlbflush.h>
>  #include "internal.h"
>  
> @@ -44,6 +45,23 @@ static int migrate_vma_collect_hole(unsigned long start,
>  	if (!vma_is_anonymous(walk->vma))
>  		return migrate_vma_collect_skip(start, end, walk);
>  
> +	if (thp_migration_supported() &&
> +		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> +		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
> +		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
> +		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
> +						MIGRATE_PFN_COMPOUND;
> +		migrate->dst[migrate->npages] = 0;
> +		migrate->npages++;
> +		migrate->cpages++;
> +
> +		/*
> +		 * Collect the remaining entries as holes, in case we
> +		 * need to split later
> +		 */
> +		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
> +	}
> +

seems you have to split_huge_pmd() for the huge zero page here in case
of !thp_migration_supported() afaics

>  	for (addr = start; addr < end; addr += PAGE_SIZE) {


