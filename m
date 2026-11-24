Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8F2606A331
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XBzzZwm1
Received: by kanga.kvack.org (Postfix)
	id 3BAEB6B07F3; Tue, 24 Nov 2026 12:24:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391F96B07F5; Tue, 24 Nov 2026 12:24:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8576B07F6; Tue, 24 Nov 2026 12:24:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E606B6B07F3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:24:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76365A87B4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:24:56 +0000 (UTC)
X-FDA: 85470687792.26.2613732
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8D37510000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:24:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XBzzZwm1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795541094;
	b=wBXyD4scTdx+rA3FuQIUSoCFdLz0Ad75TMsMmZheKm14TFLGhwvue3hklorPKFnQFrgBck
	WkotZd8Gf3DmBQJg19l+HV1L3CJ6ZLr20sSki9gjf1msfHSZqRcRdM89I7Jv3yTS1tJeJC
	QugdIiPMDKpPc2iI4NeoQtTlAMK5Nfs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozTidCXqTzSwi9dcCKWD5fJGGI9rCJsLQ/Ov08gLSsk=;
	b=7Onbxpfw48Z3QqDp2+YFkVcv85lGsu8z88rR1sb05q3JPPRT7eI3mc+IPFmp8RFiULK0q5
	YVCgf9zae9j3iXBaMnlcD/IPpxa+EDvag6Zyw/Xxc6m3mBoqZohiRrtGf0gb1ni6O/mAv7
	TXI1fdug0FEY2t6ObwAlYdBKQRPt8cE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XBzzZwm1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2f04ad2c46dso28517855ad.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795541093; x=1796145893; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ozTidCXqTzSwi9dcCKWD5fJGGI9rCJsLQ/Ov08gLSsk=;
        b=XBzzZwm1p2e1MIBUWVs34UuL7iTbKvl4GJ/ehBfrvHjiiITlKFCsqY9+fp2uBXVNsb
         +U/ZOkOavLIzFUOwC7x0g/rbshxno/UJLzi8/pDCCMyBmatuuWeldUUjdKZ3vgEV4dxl
         ASOYm7Z5i/sBe6aSRHdvU4kfaYnGO00ztj5VYEVZcOObdhnTm9nmjz3ElR9Z2syiHm+M
         L23Sbs7BBsYEYEvxCsTtFrGx0x3jDyR+nnxfNGLlWRef6Px22saKh+KCSVBWKEAPS8xU
         85kaAVxDko20QE6a4KH28jqT1exPfVqdmr1K7q8FUNw8pArql229olABKl+E3prBfkLy
         8JCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541093; x=1796145893;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ozTidCXqTzSwi9dcCKWD5fJGGI9rCJsLQ/Ov08gLSsk=;
        b=gGN7OlJytY/Q0Qj/XNEvJiwWYjEX+2fuenFYzHtvVfznWqGhaX1iAydYtvJeHj/mm0
         A9x7gkovyAbKfYYrtoiQ1+1b8n9s6Ikh8LqtaijBymyKxKNlNxvyrkmzlFZIwEmrKet8
         5jiDjc+7iHROw1exZy5Xfy+bPMBvHYfHc+tT0aMTS9KlxijgQ7LAjk2PBLJPeRJSDLyi
         Y2kuUIzNcmBddFlz0b7IE6ds1YvhPEgHatQbFB1DDv980UEkvBURknnZ8IWVSfDpU6Z+
         UFhqjaBcLBu3h9ujbccJiV5l7KiO+jmC03XClPCn0yukKr+LrJnyAEQL1iVZ+tEmKkfy
         fA9Q==
X-Forwarded-Encrypted: i=1; AL+hErHma01ekBh6oHhH2qoOlZGX9rAFzGD8UuEzNgz2CD27FlOK4BZSDu7QRXopU1fZ5XrHQ7vN+P66lA==@kvack.org
X-Gm-Message-State: APuU4Z+o5KeuevKAKFVRmNT8SeT8TEEwA0uCIlFazVfzw0zw17RiHtIs
	qhqZQoexGjctreBAVXY1Pk5p8EZTj/7Nn/Z+Seif8SXeIkpRM5mIOzaN
X-Gm-Gg: AZFdTZfyjKmZbKRghLl+Zhkc3FcoqXpzJK9cFCzr4dk072d0oM1qiwn2345Ckdsi+c9
	hzSRAOgemcj8xKyfjbKGQTZL7jwF9XLJdGGAVOjrDGW1/8dczhHrQqrDBL44VjFWdjl80/rfzTT
	Yh0b+/WeemhViWOXjM1gBskrSjjDocbyttTf8fy0MyfS+43NU7ExnjsP84rkjkihGZKr91Abseq
	uhnmUy39VVNur0+oWsQqOXdJlYaKj+4hm4JVd9mWhRwUUt5248IbXuVooAQR5/wL2qmW8v8A4aS
	dOfXlpwnaVqjGRiCI3Ze+/d43AoDGyZXHMUXX47UdzbJ0OiuVPeLEaN8kJTG45ILsOQuCTkYUQU
	9rnZFTXaNSt6i0CrVhjsNIToM8bflcmMP9al+XkGUVYXCJrpPpJPLyOHLIfQ+diUsOVtjIncedI
	cYVGAJJnfnktmQ5hT2hV4Gyi6zATSMsz+ONMPzXeZSwtGEBlJrgL1JByPghnQSjggMOkDKhSeT4
	8FmgyqyoieoxpjQFKisNF5iqQtoW6cQ4G+b5dqMOe1q78ingiiGzngebZgL/ZInHaGybtA014zD
	Oa69WDzchf3MJwCNq37kL+Bgmv5/aan+cy8HO/6KpM2p4XTi320rUxKrwHp7phmpPzDnleg=
X-Received: by 2002:a17:902:f647:b0:2ef:e130:1505 with SMTP id d9443c01a7336-2f03f17d196mr143597245ad.10.1795541093208;
        Tue, 24 Nov 2026 09:24:53 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f102fc4sm72406805ad.43.2026.11.24.09.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 09:24:52 -0800 (PST)
Date: Wed, 25 Nov 2026 01:24:38 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Hugh Dickins <hughd@google.com>, SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
	Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>, 
	Ridong Chen <ridong.chen@linux.dev>
Subject: Re: [PATCH v6 15/18] mm/huge_memory: mark folio as accessed more
 accurately on split
Message-ID: <awXABa3dYhEN0YEt@KASONG-MC4>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-15-8ffea39934a6@tencent.com>
 <DN2V8E26C4EL.2TU52TEVLUFA@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DN2V8E26C4EL.2TU52TEVLUFA@nvidia.com>
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 8D37510000C
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: sunffi58su1fsj3rpzfawtf6crt73xh4
X-HE-Tag: 1795541094-784044
X-HE-Meta: U2FsdGVkX18XZ2KTq5sndwNeH2lrigDrnfa3Jt4MlNE8rtw9PGHzNi/l5cU7bFOBUTgz55MFE+RI5GProq1iM446b+gJItQBUKwW5+DNJkAoxSHeB59tSE/WNkSt8hwlQAKJ+FN1QQl/a3P6SJ3a6vxUR4pvlEivPdxCwsozm8b3AIMZlWej+rUgv/6GJi90yNb38y7mZUVTqacFA9iz+bcoAgGb/93jdco/D87RnpuFJlh3up5zpnSacUhIFjdvgS3K0gGtX1tUYGMjUEzHN1SLEIJAwqWSAGyBupRXjWgz1tKB+koxmzcgXPE41cBYYdr/sVLA/U/Xz+mQO8KBFPAA/a6+00gE/uj9aNtzFEN/u4L89V8jq/M/HLBdpyNXyP9FNneQeNbLE2p7haFv8cTuAxkXo4RwYpePMBn92OMg+4I2yhZ/LV52NS56zU5l+6Sx3G1/AnE/LIWNibk36TaVT5DJNBqftNAu2AzBziI2rxccgxfFH9A3iaKmSvQz4QEsLd+8qNLH7CeH4NMCmlLlpK0/aAo3rRiDRikAY62bSwr68+IUrqY9wMXZGPVBMJ6SZIUIip0ZXCmKK0+KSWhHfkt5EwUjnXyAuONi3JDXJO4FwQnu9KkLbrVQOZbyctch9iMNTuRCqGM1peqX0lw+FJo24fuMKEbqjaMx/Pwlk1eChskUvTKNtnoTxTxWVxObW5HcZk16toMLTsJlwzlJxBPX/qBIjH9ei6vJPS1wQCAqUJ5fhVYcGCuW/L03WOwpR86ogj3UL+I9R+Avp/oblGyMi2/hToa2Hd4FCTwkMyp/sIgI4W16KUjM8/Yoh3xWnACzWL1I13Jxt+sgVbT9M9IEyiyiDH742Ucx+F7yg5c1T0JxMlWXSMSSzCX0xKf4gBxpy/4ga/GYwnxlRc3vHI6vLpE21xbafjH+y/QXtH/pXqOckVQ0kJVGE/p1BL0fEh1pzhs1H5sNdPe
 AZOQTq6J
 tv1xkgeorf1Te5bYOb5j8SzqijOywnmgNqORQmGWSpkR+HyiKSOoj+7a6ZD3+dATGopOyjFhtdKTSFNv9ATFYDtOAc6FxNFKCixjBoPijJv9JZYdz7hlSJZf/zSXU9TiddegSZxrStUgVAbDs2MfLJj+N0kkSO1TBuPsmzrmz9LVCpOUCDFr+SlsNM8GM7bmdGccs6aEsMZgNuD7ZJzSFwosPYZZrV02VZkOF4tucDbM3xuCC23x5SK4RVK7i8fNk1z6FK0bbFXSuDAFTkanuzzs5GHHGFaPsTe2ti4XDJVK/SAgIcAChhTFiAs6QhLe2UKL2l4+KvUyqBh3mB1xaKa2/AmIeMI5qk4GfevDR+5XfDdGcjBQf4zikDRjZLhf9n1Hon++CVTmKQfSzgIWxnpFIXUkuVmgIwu6mgHJTd03hul/eyw5Tns7mR/0EHo+haWfRIq5uIfhlJWgO4IgKQ8xY6biFWMZGOr8BMFEcnDldPJoxv8V6J+jNmLhxYjX0M7JEdOF1pktbRhgObJg03Xqb776Pm/x4TAArNWx07f+ZelY6eWZ0slb8HyM1igFK+B99b69fman3Dsha+2sxZTbYFKHupCVN1j1u9o3kVhPP1ZoiSKga7JM4tOUhvn2HR+gPkx7C+JQZ80cqSPfk6R/AVFz4+fZe+cRbln+B9zfcPUb8a5SqGoEO5bNOjEcHKb57PXNN0RCttScOSo/bnKxqw2G5yAWliRtPOj9jDkTwyF8y6sXd9rULoTJyUHjGArA8/1x02kbwjln1jDXp9dCu6BwLzMAd4GLhioV5seZT0h8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 03:17:05PM +0800, Zi Yan wrote:
> On Mon Nov 23, 2026 at 1:53 PM EST, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > The behavior of updating the folio's access info isn't consistent for
> > huge mapping splitting or ordinary unmapping. The page table's young
> > flag has to be translated into folio's access info.
> >
> > Right now it only checks and sets the folio's referenced flag, which isn't
> > enough since folio flag updates on access have their own rules. Ordinary
> > unmapping (zapping) calls folio_mark_accessed(), and it also checks
> > if the VMA has recency to avoid false updates.
> 
> Can you elaborate on why vma_has_recency() should be used? "false updates"
> might be too vague.

Thanks for the careful review!

Right, maybe I shouldn't say these are "false updates" indeed. But it
makes sense to do so, will reword that paragraph.

The young PTE becomes folio hotness via the LRU refs to help improve
LRU accuracy: telling the LRU that the folio is accessed, so it should
be protected as it is more likely to be reused soon.

But vma_has_recency() is the app's hint that these accesses are not a
recency signal: MADV_RANDOM expects "page references in random order",
POSIX_FADV_NOREUSE sets FMODE_NOREUSE, and MADV_SEQUENTIAL expects
pages which "may be freed soon after they are accessed", which is the
opposite of what the refs mean. In all these cases, marking the folio
referenced from a PTE access hurts instead of helping.

zap_pte_range() and folio_referenced_one() already ignore the accessed
bit for such VMAs. The split path is the last place translating a young
PTE into folio hotness without it. So while converting to the more
useful folio_mark_accessed(), also add the missing recency check to
avoid wrong promotion.

