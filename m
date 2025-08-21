Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABFD3CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00C088E0028; Thu, 21 Aug 2025 16:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25388E0027; Thu, 21 Aug 2025 16:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B8D8E0028; Thu, 21 Aug 2025 16:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D293C8E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94482140528
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:20 +0000 (UTC)
X-FDA: 83801849040.12.127CA53
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6325FA000E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fijkw8Sr;
	spf=pass (imf15.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806838; a=rsa-sha256;
	cv=none;
	b=HqkXGAH31J0JVMSD/5JW46bx3AIQ8SrO8WrrfOxFBMxGR9rzl8If+ho4M0neTJkm6EK4x4
	cpfhJjDxk/T9tmkCEI+VBxzfKFiROkntttxLTiwTfju2lgnptNB13yeRIgYo65obT5GYCg
	5dXtNR7HVC6/4c0uQRAMowrGkh04H1U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fijkw8Sr;
	spf=pass (imf15.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7sWLap5u4LkaWlbSo2T/W3JLtp2tuveUv2Z9sucaeo0=;
	b=An3ggzk3ntwhKVchYV0jeBwHRhqLuthojGvr4V5Rt3U2e2FvrRUAtNhGMTBiTed1hbSBiQ
	BPnwQ3zi8s0DnwIp7qRsINITN0N4xELVa2DXlZh5m9O2LI4u6MaxYj/ctKk4QwqEqNCCFJ
	TSyKuBU7n+DfP3xNDczfKM/gaDnUq/A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7sWLap5u4LkaWlbSo2T/W3JLtp2tuveUv2Z9sucaeo0=;
	b=fijkw8SrjMD1mnjoMdjbgZ/5K/Tcj6o7hD/TLe1qb4fe7UFkOspB7vXrSH0i8w23J9Oirk
	F9AgrKPDdfSUPKqqeJH4ES2CucbmwXxFsaerYdj6/Ya6q09K2zclqgJiDnxx1tWsU3yLIZ
	f3gd86X+MUgHUP0AKpyBf4LWd29AEL0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-59-7fO0qfMyMpC8zRqIX4zwqg-1; Thu, 21 Aug 2025 16:07:15 -0400
X-MC-Unique: 7fO0qfMyMpC8zRqIX4zwqg-1
X-Mimecast-MFC-AGG-ID: 7fO0qfMyMpC8zRqIX4zwqg_1755806833
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05d251so7730735e9.1
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806833; x=1756411633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7sWLap5u4LkaWlbSo2T/W3JLtp2tuveUv2Z9sucaeo0=;
        b=d+ZnZLQcG8buxOabIJD8XrAfe7fiv5E9W9dffoWnqQVuY+aMqMI63gHEwh2uwgc+vU
         NCxwdCee4bfwsYDyJk3oO8/RvH5oYlzm9zVBTcY9ftgOhwE+IpNDVGn6sylC5lHJfntB
         n4set5koxcFvksAcz5oV2/tUu+v4wvCgE09jHjg4ZheTaktQTeLDvEZ3byEizKgX2IlI
         4Kgl8PRb9N8Lc2sauDv8n2wb2ThcuUWAj+bTOSuF3W4Twh8/m+bHtv9xPDPEE0W6zokI
         JXIl8rjvb77f546aCqUddqG8c7JIlGg9K5wxVyU5uMUp8TfZgtLZNulK8s3jtlCk49re
         HSFA==
X-Forwarded-Encrypted: i=1; AJvYcCUQGzajMhEISQV4acjIUj19PEJhfS5Mwcv6YsG8hdxFCPQFVR+LMDQuUsVcPL6LmTGnTGIViN6KhA==@kvack.org
X-Gm-Message-State: AOJu0YyJme+NZX9bSAblTXHWtOww11yhEPQaQY9RQ18guQv2C2wJrvn7
	AKFOW7ImGUSdzzNkUe0MWVUnkq9FrC9P35wRSqxADSTZZr2Sq2/GmHkoa2yQmd5gNfmFms/+Dg9
	rHR4WTvsoGjKzdStVWJmmDEA5FsJSc4XXa8/wN/VOm03MtKaaa+cJ
X-Gm-Gg: ASbGnctBB0VxC/6g4MCZwVlpW1ogvRgoFUWpp5rp3TipOE5nLIhTWXjt03FW27bYBfP
	NynfM5sgGuE6EIUSFnB9Ta+UtwUjEjolNlk9R5Ze4oc5riXX7Keveyh03DX7AjQ77jJy1uRCxoM
	8qamNNWQeizvOR96B+jB7eekH9jusKNWQ3qcIuSGOPatnBSdbVBfGXXDTWMenxLI+LOI8O4IIKk
	XidyE1ERlh4GoPVBE3vm/LfoPdf9ko8vofUryGZhcCi6zmhg5UOg/z7gux74zyqWSW8saEDQYeD
	6/8vAlp84o/UAonpVrU5eBvE4de7fbd5kXdXZBqSPUGSKo7g5obGLbduzNhBjRw9cvOSuymvsOz
	KZfgwh/i5ffrRlG0PdmqImA==
X-Received: by 2002:a05:600c:1d06:b0:455:ed48:144f with SMTP id 5b1f17b1804b1-45b5179669dmr2598585e9.14.1755806833371;
        Thu, 21 Aug 2025 13:07:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSutx6qbatKffMJ28UfT2ZDXFlSv+vNq81oYks3KAGI73zxxTWKo8ClwQ/mmPq6W0wDfVQow==
X-Received: by 2002:a05:600c:1d06:b0:455:ed48:144f with SMTP id 5b1f17b1804b1-45b5179669dmr2597955e9.14.1755806832889;
        Thu, 21 Aug 2025 13:07:12 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c0771c166bsm12916801f8f.33.2025.08.21.13.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:11 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 02/35] arm64: Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
Date: Thu, 21 Aug 2025 22:06:28 +0200
Message-ID: <20250821200701.1329277-3-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IcikDahjHiEwKIvgASAR-pnlwyz_QQwjzMd4ocvPBtU_1755806833
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6325FA000E
X-Stat-Signature: 4kr8dndbbgzkjbbuutg47p1qgountwgs
X-Rspam-User: 
X-HE-Tag: 1755806838-783143
X-HE-Meta: U2FsdGVkX18wjQq3ShPkWD1D+LhQMX9W4VRW+eyG0CNfEsqts3mNY2Y9qT1DhzsGSA6gxj5QvbnYFi9fGAf0FxjjUPVO+y2qn8Vva9HNggNdWJaMnSvUfhLscyY89sqh8BXSgmI8mUjJKnkLY1NfMNS87jVRIEguoYFJobdlEIP/hQopvFlh+3/GLmPDfy94OXrYo12WzcXx+cK4cxYijxZNXC06BWz2liXCnXNQYdJ359jr1W0m4hGqfH85o6pb4H+P7KEP6SsmSDmZxRzGuwT7mZfMMOaHvhutENB5Bo1gCucz7at14UsLF6D1NRzolz5wm1sAoXsfJ7shxpExVriFk2nTdnDwbfuzhETrkY9H+jG3KawtVbzKp74bX1MjVi3Vzydt6ghi230mdqllnT5oBsXqfAqYKKhjbx0OOC8nYhUyrB35wTsX/QIeRVk4VnH9Ln+XQTy/ajCNGMuXFSzFI1Nw8753kddlO0rFI/lzVw9ACjVbDyC9U7qZObBYyytcdh6pglIbUXGSNFHz0ooPd2oHvmfCQ5MIuWHr3shia4GF+BKJcuPwRWPHkIo4ky1h7a1v0f7DoRgdAtoiYYbdQ29Xo12R8jAUgCyThcEsEMxoak4Q/fMyGL8uF07CrnoiKng9TrQ3uMd2TsoQbRjt+K35x+tMn2nx3luqmIvdGE5idIOlnH93D5y1mlqMBwNKKcunw7OZy0pFy7LGxDPr1oCsj1dO8bqUtKqjzutzyu4m1TknHbs7UFu7x3ux1Zt5KxWrtRRzU9k+P/xD396QBnR5x7XCBX6C0z/ez1s58yeo3UJGTCIysKo77n938UMvnfXrLCzdg6+UwM6o8S90TwUDYgn7aUNZkVQ8qht631ybvnKstzbjDgT2bxGdlI/+hh/7wb1RAXB7qZpWuM9UNogasYiYt/KpM4mn9UjA4rJGcPxeGuWgNW7W7y3yaLBl5hgkGD/zGjmX4ux
 BzgKqWiZ
 ScHyZVxPOPhGPpR7oaVOIvtrBjEw4lhMQLsL7gXeMa1hv1LVxBz3qoZMRBZLVRisqRw+4D3XgNDQW+ncmRyx0OOAIUsOYEncocSupYRBN21kod1hUqH4PHrvGqxuKy7DtA0dKCNTfchvYpCaVUN3FTooXjqlVFuJTWrg+UsuM0CVSWA6QdM7zri8Vm82LvpfxRWPtOWvZFnVbWDqU74nd3FcA8qQ/bEqSXXKMcA14n8HRgvb2bCYle98B8pJpBwDiTUDU7jB6CKxgPvbBH2eCDPVba8Pwobw1Mhq24YU1rqRsDUTjyWyq0kEhtyFltjVjoSSlfLu0QcFooRO7DfVnkvLnHSCCy8f/5l8mJwVnymcpc5WB2/sGNEtLsaXaWWrxsRzglNRxTUf8T6lGghPAZByV9uHr2dYc/6UV9who9bjyJaGuzsRLW/vOWEd5w6bKiRKdvk93gW9aeynDa/5FqtCXaV1BJwAMRtRQM80zmBeZaLIxE8iug5VpmJGtEkuUaqZABsM4x7mwWZhhtKlJIIzfhvSQurw9h+LYv+XVUSB24MNMYzk11HbHneFjIPTKKk2QJnhHIcg3EfWuU04VPk+9brhlbCgYBB2DbpSBD2ygP16Zlwh0kLdy+daOs9UCzOYuK31+L2IGA0k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
is selected.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/arm64/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e9bbfacc35a64..b1d1f2ff2493b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1570,7 +1570,6 @@ source "kernel/Kconfig.hz"
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	select SPARSEMEM_VMEMMAP_ENABLE
-	select SPARSEMEM_VMEMMAP
 
 config HW_PERF_EVENTS
 	def_bool y
-- 
2.50.1


