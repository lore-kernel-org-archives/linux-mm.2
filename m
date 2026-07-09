Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8DEBC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C5126B0096; Thu,  9 Jul 2026 10:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4739B6B0099; Thu,  9 Jul 2026 10:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362426B009B; Thu,  9 Jul 2026 10:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA6116B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:51:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 646B91689F4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:51:40 +0000 (UTC)
X-FDA: 84969527160.04.F974CA6
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id AD9B54000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:51:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="k/erf7+4";
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783608698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UT00T4Ch1e//1CySv92Ba/vSdArYfFyOvtjbEmuqjN4=;
	b=K3K8pes8FupmAoOq9sKD0TR5PndqkZi4TQ1IpChOSfsL+p+sMkJJ838Mod+4smjsAwB2AJ
	4VizCuxcN00k7nPS93V6d+jQgo53+6UUg1YhRbuTY+86sH+FvAFaW786ybLRIudATQxnkG
	foLe5y0wGMTn1W4eTjuE9XeQ2fcNofg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783608698;
	b=3kIljKRV4BJguKSV/KpzrZVXAd7PjLrcLe3myd8MbtF2UNgJPrStyah5aHlkbH0m4++HIS
	pU95STN1U1BP718oHKFAsh5mVCqZdLB4CZ0qA+JztM5o2VdS8024dw98zhRuGxTizSNZ0r
	LtRH5qz49GfOhVqvOWyiBzXILWg7QIM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="k/erf7+4";
	spf=pass (imf11.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3856d4015e0so182368a91.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 07:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783608697; x=1784213497; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UT00T4Ch1e//1CySv92Ba/vSdArYfFyOvtjbEmuqjN4=;
        b=k/erf7+434OPB1aKVD2BrSxdGBoxRLc+m8SEeXWsBTQdfRshciJYds6wqVRiOZGxTd
         2GfXbwQVUpv1wbdLlfaBU9DtC/1xjgOkL4Qi/3iDc9CQMrUJ+xQt/B7NqNLvpStV2h1o
         Wj/QQ47aUT3S4sdEMMVk/8h+Y7z0X10Sf4VI7sadUAYvFQmQ5FWd4NE4v0D7ZUEO12Cc
         /O+OXvsPASrbvxdbJY0fCAu9zDB3TlK6FxGKfBvNyNi4V4S763hQB5hoK3A99hGF779z
         yRGGxRWKmqGSmQIZNJpex01k6TMAtEtweakiWdLwxB9M4181wNPQRYrM840NGPGz8+77
         OLkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783608697; x=1784213497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UT00T4Ch1e//1CySv92Ba/vSdArYfFyOvtjbEmuqjN4=;
        b=XS1PzTosdBGJDnioBI/CLKxLz4jPaP8yYdtkAYvkegV71gONIGYU780+17TJnQ22zI
         RsJ8rnaEnAaYJDvhavCqlD2tzhmP3awUrF+r+taV9wc5c9hvTW3W15U/4hTaKC2f7x3H
         4TD9rqiUgUpIXHE5OgGMP38VKE1XnizT32sDx1dj2IPhGgOo8/jLmTSX79x+OhCGDzHU
         XgUHE3ABhLGRTXdOVevvtq8mlA5MJNx+hsyne/h3hM4I3i+IGnTVbjhTpfR3pjHShFqw
         e9XaYVMkW6uPPmT6vn7HvaF8oyRMVHGWNQjI18dxk6Z9w9nCOkh/GyY+nb6mlCk/m/ce
         7EYA==
X-Forwarded-Encrypted: i=1; AHgh+RotReR3YDvQflVuyASxKi3eIKYmbkwM1ELrjjkAAPq58KN1jra2DxJfIMB4t5N/89yP/UYmcRJDpg==@kvack.org
X-Gm-Message-State: AOJu0YxkZuZpS7Xqe/lEvzi+lqpMLxeFHTNI3eXVygBcYbt9FMVdGnxv
	YsEwE/xekaWyqs6u+BSWo9c4SMOSNsc8fhmCBs5vqbgVhNY1KKE/nqp+
X-Gm-Gg: AfdE7clEDQDzsE1BAPH+dCNOCoqEKsUWX02RPIcUhbrvG7rRCTQTRy+5VvX40ZBVkp5
	EZXiuwm/8NyAgDG/n/piOx83Dgu3h9l7dwP9AJHwSNeQfN1UKkkxhBFb9hcsOHXAj3p34SXX2X3
	Qdv+weI7NcfBVbDLmBOoTWGmKA3BlxbksNmjK4kcBN1Wn0/jkPhf/zdOaxU2XVtCU7aWHKF0+Nx
	F8gsniYBcXQmW+THqYfFDlSdk3rowldHSgcemTG5tgGdsJw5xRrYN8WdZAhYHwl4csXRZPiZ5Lv
	R/m7xHNZNy6zAuymVoOTd/l0x/MRunQLN29wv/OV4YWpcePiwtYeDsV1Dn4ADLKQ7jrndYATIc1
	IqyPA8vxykG3vRuwv0ND+hfGEaO/8y6fhBF13uStKrM7YXQaQy2HFN6eiDsgI5SdMhlFvTAS93l
	V4BJ+v3NuC92C6sVE91+mgJaQwpANomN8Cbk8Ko1G59EVHH79jB3/Fl7AmxhmJ5Av5TI7cKlZu3
	fYTKxhbWU11tHhcdA==
X-Received: by 2002:a17:90b:5287:b0:381:2788:a437 with SMTP id 98e67ed59e1d1-38a1f1dbefamr3445540a91.1.1783608697342;
        Thu, 09 Jul 2026 07:51:37 -0700 (PDT)
Received: from debian.lan ([240e:391:ea3:6910:38e7:894b:82e3:a58b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a57dc5820sm1286917a91.10.2026.07.09.07.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 07:51:36 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Barry Song <baohua@kernel.org>,
	Nanzhe Zhao <zhaonanzhe@xiaomi.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v2 0/3] mm: avoid large folio splits when swap is unavailable
Date: Thu,  9 Jul 2026 22:51:21 +0800
Message-ID: <20260709145124.764807-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD9B54000D
X-Stat-Signature: nxq3r9atknacapxyea6y61jqwscfjxwk
X-HE-Tag: 1783608698-840660
X-HE-Meta: U2FsdGVkX1/IbDs86WVdgzLf6QXKLohZ3YSki2uGD+FeIb3GwCZ1zaqIE9fLebgL7Hy/BxyS2Za+fpTJt/1MuDPt/jS9J+pJn+iuxfeUJgFx8EHEVpgswD08FvIrA4UdEsBbnL+pP36gg8nj2WYmq6CHvTcENlNbC06cwL2h2Mxpv2nB/Iqr1cOQwkIPSSDRXReVnzl6bE1UKmWiVZBXrSp/dMOH9Z59cv+bTS4DAef5W2AXs+Mr0X5sk1A4T5XNMPCWED4iYz1HpDgo6+Xg3FYHqYBXj6JQ/LD3VP9UTpCp4XT/3N5ZJYoE+NmBwh3i55XkajR/OfmHF4Rzv2TBDmGY22W8MFpwLOflwuAQctJ3CiYf3bSkHB7I/elkdql+AE7GI+RxMFk+GX/j8VPfWmmEojxyJC9prUi8H3nK7oVwpQDA/XN/Q7M85T4kJAkLtFgiKIeSJZrs1BFlQFq0DciwVOILbf6zIDC/Ooj2XkP9ky9zA8S5ESSV8n9auqbOP7fwN8k1x6aYqZzjNFV19+hu+eTyu8la5PgPMu3FWtO9CpExDjIv16sn8+HefZs8eG8X0FGtYiuwjX7cw34mgizCLS9bf/VS1BL5Bo8V0rfU2/f5Tq3TEkThkO/UbmqEJLawLLducsqup5JClA249v8NXCNJq4fPyXfDlBMJ22JcTt3/i1oxmXEFTlv9rTYbETl66+nhg98TxGiRCH/ro+RiNCfD5A2eDCMVn1ipGKVtU9onGPcg0bWN9H235cSV435B+TJiPCypCxvd+AdlJYVhrB+2FBCpHXEyN8SZGbCeeOTuJuRdQbk0n/PUY9ZiUZ+XZYn1YIc93/qfcYreleUh+IGcEftQQz+PgswwH4oTR00CP2HmQVyHD74h55ocbDS7owcCVfS72MQaY0U4zCbmPqZ+RiCF/t8+HPvxxeDhWYByjoC1nmPSVrHKDfxBiiIGNB1zVCXyl3yqmLO
 zoOh/1sj
 GBKnmbGYaJqQmc/brt1idNLdA7OBTqLJ4+1QT/mFwtZetVoSralhw7wpnVjtrs6oaJCOFAKKYsHbBPDV2/HksrsGW97SCmgNPnfIIjEGjgHv5XgDrFmuJr42Vce50bxhVah4eQtQkBApdoQ1oaEb1dIqdYOcAFK9YK1Hb4TPEPSKDXlp4nAu8lM8QX+t57jRukJDo8/zqdOL2BLcdPJzum47GRYUvvKbfrgcYbPyuMIbVdcq84CIa1g4ASf675JIY3O7towIZiLCvxmQqhR83/zpttSs9BImSU2YYxGhsYTmiXaSEfIKPXjw9N/RBUEtPBHJMnDxh5D11X3NIC9EprC3sIAA21VrDj0Ht8+UMrfshuYOz7Ab1D+Wp6cVmUX3IrgAD8Q+HVN7B0mhbCmaf/vxqYTVKtsHDqYt3oYna3T9Dod1tecKpPVMDd1NMiKIApDnNSJSQdvzJrSfnsmgMBB62ecSqTtiND1RaWAkntZ6YiJooB9L/5LfHUetZyspKLTbtdh0WW6A6ISxYGElCJVgSz1aOR8xkICOd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an RFC v2 of Barry's original RFC patch, "mm: Avoiding split
large folios if swap has no space":

https://lore.kernel.org/r/20260618221720.71768-1-baohua@kernel.org

Barry's RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP: the
large-folio split counter increased by 1024 even though no swapout
progress was possible. Skipping the split in that case kept the counter
at 0.

This version keeps that behavior, but makes folio_alloc_swap() classify
the failure. The helper has both the swap allocation result and the memcg
swap charge result, so vmscan only needs to split when folio_alloc_swap()
reports that a smaller folio might still be swapped out.

Patch #1 adds page_counter_margin(), a small helper that computes the
minimum remaining chargeable space across a page_counter hierarchy.

Patch #2 uses that helper in the memcg swap path and lets
folio_alloc_swap() distinguish large-folio swap allocation failures:

  - -E2BIG: splitting may let smaller folios make progress
  - -ENOSPC: no global swap space is available
  - -ENOMEM: splitting is not expected to help, including memcg swap
    charge failures with no remaining swap capacity

Patch #3 makes vmscan split a large folio only when folio_alloc_swap()
returns -E2BIG. Other failures keep the existing activation path and avoid
destroying the large folio when no smaller part can be backed by swap
either.

RFC v1 -> RFC v2:
- Split the RFC into helper, swap allocation, and vmscan patches.
- Add page_counter_margin() and use it for hierarchical memcg swap
  capacity checks.
- Make folio_alloc_swap() return -E2BIG only when a smaller folio may
  still be swapped out.
- Return -ENOSPC for no global swap space and -ENOMEM when splitting is
  not expected to help, including memcg swap exhaustion.
- Make vmscan split large folios only on -E2BIG from folio_alloc_swap().

Barry Song (Xiaomi) (1):
  mm/vmscan: avoid pointless large folio splits without swap

Xueyuan Chen (2):
  mm: add page_counter_margin()
  mm: distinguish large folio swap allocation failures

 include/linux/page_counter.h |  1 +
 include/linux/swap.h         | 10 ++++++----
 mm/memcontrol.c              | 15 ++++++++++-----
 mm/page_counter.c            | 20 ++++++++++++++++++++
 mm/swapfile.c                | 21 +++++++++++++++------
 mm/vmscan.c                  |  7 +++++--
 6 files changed, 57 insertions(+), 17 deletions(-)

-- 
2.47.3

