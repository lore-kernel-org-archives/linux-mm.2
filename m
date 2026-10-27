Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC80607351C
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QVg84aFZ
Received: by kanga.kvack.org (Postfix)
	id 0E8816B07F3; Tue, 27 Oct 2026 11:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0993D6B07F7; Tue, 27 Oct 2026 11:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F396B07F6; Tue, 27 Oct 2026 11:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6E276B07F3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D597BA0A90
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:27 +0000 (UTC)
X-FDA: 85368835734.02.44B46F8
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id F2362C0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QVg84aFZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPt0JYZ7MHrW6GDHRZTQpzJzKe8DOikeeLCfWsSdkp8=;
	b=TiNwXZXVAc729BwwGKbCTdulZhX62drLpxAihFPi0stiCfj8WKMpvGxiWPfWqnEuSp/rFS
	t96sly0NhKuW0Ph72GPZ4LvXtngg5nNiHI4INLkc563jsLlv9iIKjKfMIfURivIQjLONuO
	G5WdDQA4ZC+pLD01oS85ZnSWWYS9uHM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QVg84aFZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of griffoul@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=griffoul@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116046;
	b=IXhdELRyjN2WOe+Vlim8btp/7lOzmo7DNzgw6dJkKYW7nmaxYsPPI59aZnjybC8gHE8Utx
	HnxcfUNaObTbF9Xfy4IWgqgcrIblxKE4cpYqjGIjkP8P48M3or1qdP0PT8JVtA3sB4+vFE
	1aZMqhWN8kmrsB3PdTI9pHvFQfoM8K8=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b1ab2ad719so48720a12.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793116045; x=1793720845; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sPt0JYZ7MHrW6GDHRZTQpzJzKe8DOikeeLCfWsSdkp8=;
        b=QVg84aFZBuJJ7ly8IvpC6b9ETeT0F5RckTehJ7nvUOntcUAOX5M9iJ2OXDwtfLWe06
         CVkrkr0KTcnkblswDjMwbF3szgM9TnrmJRsVxxp9XDBOqAZC3j/k224RBF0ZxtxzKr+8
         0oIqAaTMa3oJvypuyGVYtMSv5eF20OpY+4heM0eLAEW9syPKUWEusu3u7viq30D4u0Gq
         ruEiozWfWMvRukk9lGkLaPIptsb5I8YtL2dLIPCHG/7Iz7ao0mH4rxKiAZP9yST0CDpG
         gD5cPMS0O5rZzTYtSQeX7X3ntm87qgBpapLeBTYd2ChgefvUIZznDRZRuOaktnT0lHc9
         494Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793116045; x=1793720845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=sPt0JYZ7MHrW6GDHRZTQpzJzKe8DOikeeLCfWsSdkp8=;
        b=hzoD7nAt/JUMRVesYAKIvoI5QCF2Ov22rKuWknRNqYmcw4Js/HcxCxxv27EBQCgYmk
         ck2hcG8WwliReKaY1sNsiv9CXZCcfBE8uo8W2SoW9XRnR0wehIvBjUAz4gkwqL7BFvTT
         v2x79PIYyCnWBAZN0+Ncd00cXXb2LdaALGAIQYLUgKxQBwmZZZ0evy6/rnV06g5ZUWTa
         1kw5Pu6u34AEZyYoJeg6UFuXbvylN0N8R5SGJeZyaE7HQRTbkGFN98+ptNUmt5REn/2M
         2kJMoWsH8w1zXPoMvi7Eh94EPwxRgJJFGwrdq2+yT7PWF6Y6bcuv6ZvxJi/ikiukIkU+
         eDDA==
X-Forwarded-Encrypted: i=1; AKwUvBxCSAK4HjqabkLhblpdNmy99akw+yqjm5ZlwCBbOUecDgiyrk58+LhAbciYi7ldMYzSxas2KSOygg==@kvack.org
X-Gm-Message-State: AFq9FYJeIA7nMFtKQOSFMXx4ZG1PNEnOr5hBR4Wrty7jVErXWocOakoB
	Gtwf+boySEQqUNtBA5DTRtq6/dUEfZEAVSxj419VRMePpxGG1V0DLD1k
X-Gm-Gg: AYBFou3+IVkEWZGyoA2JB9kMCOb3lVX0AbFGOHIVtV06c9PAdtG+HxxNofHKPTepfa2
	eiPqHfifZFY+YgTynAbUQ9d9Oik44Q9nUV2wHH6SQhao1bjWBm6SzBZDR3U14ITUpcvV0R8bl3y
	VtVhzvOaZY9Xa/RWfW2JH9GzhiHE9efBXQJEdyAa5dVSfknXC/mkdyNvUTtmUEGObKwnmhjeZxD
	mngr9I4L3EeMNPjGckamHW6uQUrwsBDB0YIGUpcH9RbnwAto0iafGbOXuxAAgXNrwtz5UtlhpIH
	I4wr7NOhNZdVwKPucGNKBI3vR813zunI54qdsoh6Xn0Cy7uuMpHjEqnMlPzdeGpXdzI2L5Pk1wD
	rlhvwTb9CREGweG2ar/hOK23yICkxbVaDgBmJxyWVfZWZkQmeTKzenB/YzcgTtLo4Kyq1VVFFF0
	lmDthYDw/cS53BMKGEPc9NmJMTn+5VTnN8vBthq0tPlrRFSoGgx6bipYTTlw039dJ5w3fQkAfOU
	+w8zKI5WBS4o+6eJK9uYXb/xgbp7EFs0zH/THycQLA3ofMQOjVnsj+NoOXCQilfR26vNfB3Orpq
	E+DvDJ7U3buoCzxxyzS9VX82bSVOOXMf3B4Kt5+nr8x9C516SmlxIm5bElKd8lJZW4V9j+kFf3Q
	tY9yKf2TIltjUMxml
X-Received: by 2002:a05:600c:8183:b0:4a2:8c5:5f2 with SMTP id 5b1f17b1804b1-4a35ac99b41mr172717785e9.5.1793116032487;
        Tue, 27 Oct 2026 08:47:12 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb958sm23845574f8f.21.2026.10.27.08.47.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 08:47:11 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Ackerley Tng <ackerleytng@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alexander Graf <graf@amazon.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Kardashevskiy <aik@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Connor Williamson <connordw@amazon.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Erdem Aktas <erdemaktas@google.com>,
	Frank van der Linden <fvdl@google.com>,
	Gregory Price <gourry@gourry.net>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Hugh Dickins <hughd@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	James Houghton <jthoughton@google.com>,
	Jan Kara <jack@suse.cz>,
	Jianxiong Gao <jxgao@google.com>,
	Joerg Roedel <joro@8bytes.org>,
	Joey Gouly <joey.gouly@arm.com>,
	John Starks <John.Starks@microsoft.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Justin Stitt <justinstitt@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Michael Roth <michael.roth@amd.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Oliver Upton <oupton@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Tarun Sahu <tarunsahu@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Tycho Andersen <tycho@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	x86@kernel.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: [RFC PATCH 08/14] iommufd: Track the domains of revocable pages in struct iopt_pages
Date: Tue, 27 Oct 2026 15:46:43 +0000
Message-ID: <20261027154649.91571-9-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027154649.91571-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261027154649.91571-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F2362C0005
X-Stat-Signature: 4amhbcxjz7ab48h7z58ajfrqggxmkie9
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793116045-106731
X-HE-Meta: U2FsdGVkX1+nYHi9Had1r2FitAxHd+j2J0F6VEX3crA1win5HHkHQmQkWNKQ+uATIr31DruIEJkz/Okh55wjA5tRBBoJZ1gq61WVeW+NVNX40sjpBWJXems3B1wB4EcAlSxNOBQaQ0AnHUa2S3yZxc1cehCvm8rQB23T05ZMaXX9JozLGYsBT2nZVAwte4rB8nHcUGjk7AWD9P42PlFACVDNneJ6WZ6Sj5R0S37l5PyYTVj/UMOKsTaOrduZsYRQWznk31STlRr3mkt+soBMuHBpFuljQPReZX75ecy6JDekD7ADVGQCgS/8f0RxUf/DoFfMXHfTGO6JkBCYeL1cb3ruoeZ0B/pyEPESR5r3sYxO50RH2R3UTqJr5QiaXs9BRJHJMwYIocNToaBR8NxGc8VlUYEEVNs+wf/XDS1Hy3bXcx7BJBcrFjgMRHYS5/DjNQvvxdpXwxap1HoxHL/kq3XYB5D0ICb/3kFE7p+ifhfngdmKkE8IhjqwXzyKnJuJ+d8eahkM01HltoVENEdLE0Wu+RGi/M3cOBNmFqRgBSUIs6qZk/dNA/m8cpueAP49haV+B0d3C4MUq/phEzF0STTLpQmcf8XD8/r2/7V5dCRlbtptZd987Pf2w7RcLk3SYzQw44xVY6nGKONRJOal6m5xk/PZw1AjbQ4sgMrD1Thje6JL/fr8L50OzFUbHuiPOGbB8CaX2kvWrIzaFRzqF1KdRWxxcMM+JEx9mfwHBoVr+O/qrKwlB1AWKbNwR8VEuZokJ/vT09l7oRTkhEpQ1bBJE+nFtbK+fcoPmdZnXst/sR5DfKaf52df3wUZXzk5rdgkKFiYfdDKF9YV0b0hus0EGp5mg5FbUjYEfPVwgVAWkkIH0nvgaN1Gm8jkHLmrpMRF9zqUV4yjTJeqc4OZLj8Xwm6jaQRFV1uoQuqoDQJFYjslZR+BNoVBz5PMZjUvACyOiirmyzuRd86eZLS
 VOZIIObe
 6VsaQjxpgfMl7rVI6Hg1HEpN5mzoqcdKSOyNbcGDkhYk+rSlqUL8spuQ3Zgle9ts4qFUR/vovZkJLS2O/5qJETJUw62Me77Wi1aVE5Rp6KhuZlo+LquVIu2Hj8RPv+45IyJqKyQTUw+hhXe0N/69gvXpSPehUk1d4yuI+aN4/5tJMukSR806eCCH52ZgmAjiWy7EVaBb+vWnUFcpmG9QUsi9TboPnebVqb1N0C64s0PHwjDMC3HOGxO6mybVZoMkMGe7K2J5L3f9exKmhSDvsVIpzJ26jbmkNvYOA7q2KrUJ4+MdNqifkM75RrukSbfIvTgfQGoar8UEA87SHx+UBeZqKb7M9N/UpcxmNUSsQ6LGk9Km8n6njQCJ9bIotM8m4IhRi7aB0amt2gwKgf0vn/zKEx/qNcRsL6aclW8gTO/tIRNdcI7TtS01YEHLc6xGoRqDgwFvIg2Luy5CgGi6ZTuTH8eHwNpgZIm9Oe2zLFRamBKF3uoVJ60AuIg4Goh4iDxAxe7l6U74RrKlmcjrAJ3m2m3AEcKVlNx+dK8l68d2W252DNCzjf4hVtWH2Dnuzyos1hYPeq/2QICHEueosqfo15Kl2zyfiTMjrJJKBVVINq1neRDb4zjHlIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Fred Griffoul <fgriffo@amazon.co.uk>

guest_memfd pages, like dma-buf pages, can be taken away from iommufd
whatever references it holds, but the list of (area, domain) pairs to
unmap on a revoke lives in struct iopt_pages_dmabuf.

Move it to struct iopt_pages, rename the iopt_dmabuf_*track* helpers to
iopt_pages_*, and add iopt_pages_tracked() for the page types that need
it, so that other page types can use it. No functional change.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/iommu/iommufd/io_pagetable.c | 24 +++++-----
 drivers/iommu/iommufd/io_pagetable.h | 33 +++++++++-----
 drivers/iommu/iommufd/pages.c        | 67 ++++++++++++++--------------
 3 files changed, 67 insertions(+), 57 deletions(-)

diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index 4e447ce74cf6..43d518e4ce58 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -1086,14 +1086,14 @@ static void iopt_unfill_domain(struct io_pagetable *iopt,
 				WARN_ON(!area->storage_domain);
 			if (area->storage_domain == domain)
 				area->storage_domain = storage_domain;
-			if (iopt_is_dmabuf(pages)) {
+			if (iopt_pages_tracked(pages)) {
 				if (!iopt_dmabuf_revoked(pages))
 					iopt_area_unmap_domain(area, domain);
-				iopt_dmabuf_untrack_domain(pages, area, domain);
+				iopt_pages_untrack_domain(pages, area, domain);
 			}
 			mutex_unlock(&pages->mutex);
 
-			if (!iopt_is_dmabuf(pages))
+			if (!iopt_pages_tracked(pages))
 				iopt_area_unmap_domain(area, domain);
 		}
 		return;
@@ -1111,8 +1111,8 @@ static void iopt_unfill_domain(struct io_pagetable *iopt,
 		WARN_ON(area->storage_domain != domain);
 		area->storage_domain = NULL;
 		iopt_area_unfill_domain(area, pages, domain);
-		if (iopt_is_dmabuf(pages))
-			iopt_dmabuf_untrack_domain(pages, area, domain);
+		if (iopt_pages_tracked(pages))
+			iopt_pages_untrack_domain(pages, area, domain);
 		mutex_unlock(&pages->mutex);
 	}
 }
@@ -1143,15 +1143,15 @@ static int iopt_fill_domain(struct io_pagetable *iopt,
 			continue;
 
 		guard(mutex)(&pages->mutex);
-		if (iopt_is_dmabuf(pages)) {
-			rc = iopt_dmabuf_track_domain(pages, area, domain);
+		if (iopt_pages_tracked(pages)) {
+			rc = iopt_pages_track_domain(pages, area, domain);
 			if (rc)
 				goto out_unfill;
 		}
 		rc = iopt_area_fill_domain(area, domain);
 		if (rc) {
-			if (iopt_is_dmabuf(pages))
-				iopt_dmabuf_untrack_domain(pages, area, domain);
+			if (iopt_pages_tracked(pages))
+				iopt_pages_untrack_domain(pages, area, domain);
 			goto out_unfill;
 		}
 		if (!area->storage_domain) {
@@ -1180,8 +1180,8 @@ static int iopt_fill_domain(struct io_pagetable *iopt,
 			area->storage_domain = NULL;
 		}
 		iopt_area_unfill_domain(area, pages, domain);
-		if (iopt_is_dmabuf(pages))
-			iopt_dmabuf_untrack_domain(pages, area, domain);
+		if (iopt_pages_tracked(pages))
+			iopt_pages_untrack_domain(pages, area, domain);
 		mutex_unlock(&pages->mutex);
 	}
 	return rc;
@@ -1393,7 +1393,7 @@ static int iopt_area_split(struct iopt_area *area, unsigned long iova)
 		return -EBUSY;
 
 	/* Maintaining the domains_itree below is a bit complicated */
-	if (iopt_is_dmabuf(pages))
+	if (iopt_pages_tracked(pages))
 		return -EOPNOTSUPP;
 
 	if (new_start & (alignment - 1) ||
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index 27e3e311d395..0dddfb5db5fd 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -70,15 +70,14 @@ void iopt_area_unfill_domain(struct iopt_area *area, struct iopt_pages *pages,
 void iopt_area_unmap_domain(struct iopt_area *area,
 			    struct iommu_domain *domain);
 
-int iopt_dmabuf_track_domain(struct iopt_pages *pages, struct iopt_area *area,
-			     struct iommu_domain *domain);
-void iopt_dmabuf_untrack_domain(struct iopt_pages *pages,
-				struct iopt_area *area,
-				struct iommu_domain *domain);
-int iopt_dmabuf_track_all_domains(struct iopt_area *area,
-				  struct iopt_pages *pages);
-void iopt_dmabuf_untrack_all_domains(struct iopt_area *area,
-				     struct iopt_pages *pages);
+int iopt_pages_track_domain(struct iopt_pages *pages, struct iopt_area *area,
+			    struct iommu_domain *domain);
+void iopt_pages_untrack_domain(struct iopt_pages *pages, struct iopt_area *area,
+			       struct iommu_domain *domain);
+int iopt_pages_track_all_domains(struct iopt_area *area,
+				 struct iopt_pages *pages);
+void iopt_pages_untrack_all_domains(struct iopt_area *area,
+				    struct iopt_pages *pages);
 
 static inline unsigned long iopt_area_index(struct iopt_area *area)
 {
@@ -194,7 +193,8 @@ enum iopt_address_type {
 	IOPT_ADDRESS_DMABUF,
 };
 
-struct iopt_pages_dmabuf_track {
+/* One (area, domain) mapping of revocable pages, on iopt_pages::tracker. */
+struct iopt_pages_track {
 	struct iommu_domain *domain;
 	struct iopt_area *area;
 	struct list_head elm;
@@ -205,7 +205,6 @@ struct iopt_pages_dmabuf {
 	struct phys_vec phys;
 	/* Always PAGE_SIZE aligned */
 	unsigned long start;
-	struct list_head tracker;
 };
 
 /*
@@ -246,6 +245,12 @@ struct iopt_pages {
 	struct rb_root_cached access_itree;
 	/* Of iopt_area::pages_node */
 	struct rb_root_cached domains_itree;
+	/*
+	 * Of iopt_pages_track::elm.  The owner of these pages can revoke them
+	 * whatever references iommufd holds, so every (area, domain) that
+	 * maps them is listed here for the revoke.  See iopt_pages_tracked().
+	 */
+	struct list_head tracker;
 };
 
 static inline bool iopt_is_dmabuf(struct iopt_pages *pages)
@@ -255,6 +260,12 @@ static inline bool iopt_is_dmabuf(struct iopt_pages *pages)
 	return pages->type == IOPT_ADDRESS_DMABUF;
 }
 
+/* The owner of the pages can revoke them, so their domains are tracked. */
+static inline bool iopt_pages_tracked(struct iopt_pages *pages)
+{
+	return iopt_is_dmabuf(pages);
+}
+
 static inline bool iopt_dmabuf_revoked(struct iopt_pages *pages)
 {
 	lockdep_assert_held(&pages->mutex);
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 404f31d8f729..cf0f08c4e9a6 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1384,6 +1384,7 @@ static struct iopt_pages *iopt_alloc_pages(unsigned long start_byte,
 	pages->npages = DIV_ROUND_UP(length + start_byte, PAGE_SIZE);
 	pages->access_itree = RB_ROOT_CACHED;
 	pages->domains_itree = RB_ROOT_CACHED;
+	INIT_LIST_HEAD(&pages->tracker);
 	pages->writable = writable;
 	if (capable(CAP_IPC_LOCK))
 		pages->account_mode = IOPT_PAGES_ACCOUNT_NONE;
@@ -1434,13 +1435,13 @@ struct iopt_pages *iopt_alloc_file_pages(struct file *file,
 static void iopt_revoke_notify(struct dma_buf_attachment *attach)
 {
 	struct iopt_pages *pages = attach->importer_priv;
-	struct iopt_pages_dmabuf_track *track;
+	struct iopt_pages_track *track;
 
 	guard(mutex)(&pages->mutex);
 	if (iopt_dmabuf_revoked(pages))
 		return;
 
-	list_for_each_entry(track, &pages->dmabuf.tracker, elm) {
+	list_for_each_entry(track, &pages->tracker, elm) {
 		struct iopt_area *area = track->area;
 
 		iopt_area_unmap_domain_range(area, track->domain,
@@ -1557,7 +1558,6 @@ struct iopt_pages *iopt_alloc_dmabuf_pages(struct iommufd_ctx *ictx,
 	pages->account_mode = IOPT_PAGES_ACCOUNT_NONE;
 	pages->type = IOPT_ADDRESS_DMABUF;
 	pages->dmabuf.start = start - start_byte;
-	INIT_LIST_HEAD(&pages->dmabuf.tracker);
 
 	rc = iopt_map_dmabuf(ictx, pages, dmabuf);
 	if (rc) {
@@ -1568,16 +1568,16 @@ struct iopt_pages *iopt_alloc_dmabuf_pages(struct iommufd_ctx *ictx,
 	return pages;
 }
 
-int iopt_dmabuf_track_domain(struct iopt_pages *pages, struct iopt_area *area,
-			     struct iommu_domain *domain)
+int iopt_pages_track_domain(struct iopt_pages *pages, struct iopt_area *area,
+			    struct iommu_domain *domain)
 {
-	struct iopt_pages_dmabuf_track *track;
+	struct iopt_pages_track *track;
 
 	lockdep_assert_held(&pages->mutex);
-	if (WARN_ON(!iopt_is_dmabuf(pages)))
+	if (WARN_ON(!iopt_pages_tracked(pages)))
 		return -EINVAL;
 
-	list_for_each_entry(track, &pages->dmabuf.tracker, elm)
+	list_for_each_entry(track, &pages->tracker, elm)
 		if (WARN_ON(track->domain == domain && track->area == area))
 			return -EINVAL;
 
@@ -1586,21 +1586,20 @@ int iopt_dmabuf_track_domain(struct iopt_pages *pages, struct iopt_area *area,
 		return -ENOMEM;
 	track->domain = domain;
 	track->area = area;
-	list_add_tail(&track->elm, &pages->dmabuf.tracker);
+	list_add_tail(&track->elm, &pages->tracker);
 
 	return 0;
 }
 
-void iopt_dmabuf_untrack_domain(struct iopt_pages *pages,
-				struct iopt_area *area,
-				struct iommu_domain *domain)
+void iopt_pages_untrack_domain(struct iopt_pages *pages, struct iopt_area *area,
+			       struct iommu_domain *domain)
 {
-	struct iopt_pages_dmabuf_track *track;
+	struct iopt_pages_track *track;
 
 	lockdep_assert_held(&pages->mutex);
-	WARN_ON(!iopt_is_dmabuf(pages));
+	WARN_ON(!iopt_pages_tracked(pages));
 
-	list_for_each_entry(track, &pages->dmabuf.tracker, elm) {
+	list_for_each_entry(track, &pages->tracker, elm) {
 		if (track->domain == domain && track->area == area) {
 			list_del(&track->elm);
 			kfree(track);
@@ -1610,36 +1609,36 @@ void iopt_dmabuf_untrack_domain(struct iopt_pages *pages,
 	WARN_ON(true);
 }
 
-int iopt_dmabuf_track_all_domains(struct iopt_area *area,
-				  struct iopt_pages *pages)
+int iopt_pages_track_all_domains(struct iopt_area *area,
+				 struct iopt_pages *pages)
 {
-	struct iopt_pages_dmabuf_track *track;
+	struct iopt_pages_track *track;
 	struct iommu_domain *domain;
 	unsigned long index;
 	int rc;
 
-	list_for_each_entry(track, &pages->dmabuf.tracker, elm)
+	list_for_each_entry(track, &pages->tracker, elm)
 		if (WARN_ON(track->area == area))
 			return -EINVAL;
 
 	xa_for_each(&area->iopt->domains, index, domain) {
-		rc = iopt_dmabuf_track_domain(pages, area, domain);
+		rc = iopt_pages_track_domain(pages, area, domain);
 		if (rc)
 			goto err_untrack;
 	}
 	return 0;
 err_untrack:
-	iopt_dmabuf_untrack_all_domains(area, pages);
+	iopt_pages_untrack_all_domains(area, pages);
 	return rc;
 }
 
-void iopt_dmabuf_untrack_all_domains(struct iopt_area *area,
-				     struct iopt_pages *pages)
+void iopt_pages_untrack_all_domains(struct iopt_area *area,
+				    struct iopt_pages *pages)
 {
-	struct iopt_pages_dmabuf_track *track;
-	struct iopt_pages_dmabuf_track *tmp;
+	struct iopt_pages_track *track;
+	struct iopt_pages_track *tmp;
 
-	list_for_each_entry_safe(track, tmp, &pages->dmabuf.tracker,
+	list_for_each_entry_safe(track, tmp, &pages->tracker,
 				 elm) {
 		if (track->area == area) {
 			list_del(&track->elm);
@@ -1656,6 +1655,7 @@ void iopt_release_pages(struct kref *kref)
 	WARN_ON(!RB_EMPTY_ROOT(&pages->domains_itree.rb_root));
 	WARN_ON(pages->npinned);
 	WARN_ON(!xa_empty(&pages->pinned_pfns));
+	WARN_ON(!list_empty(&pages->tracker));
 	if (iopt_is_dmabuf(pages) && pages->dmabuf.attach) {
 		struct dma_buf *dmabuf = pages->dmabuf.attach->dmabuf;
 
@@ -1664,7 +1664,6 @@ void iopt_release_pages(struct kref *kref)
 		dma_resv_unlock(dmabuf->resv);
 		dma_buf_detach(dmabuf, pages->dmabuf.attach);
 		dma_buf_put(dmabuf);
-		WARN_ON(!list_empty(&pages->dmabuf.tracker));
 	} else if (pages->type == IOPT_ADDRESS_FILE) {
 		fput(pages->file);
 	}
@@ -1749,7 +1748,7 @@ static void __iopt_area_unfill_domain(struct iopt_area *area,
 
 	lockdep_assert_held(&pages->mutex);
 
-	if (iopt_is_dmabuf(pages)) {
+	if (iopt_pages_tracked(pages)) {
 		if (WARN_ON(iopt_dmabuf_revoked(pages)))
 			return;
 		iopt_area_unmap_domain_range(area, domain, start_index,
@@ -1917,8 +1916,8 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
 		return 0;
 
 	mutex_lock(&pages->mutex);
-	if (iopt_is_dmabuf(pages)) {
-		rc = iopt_dmabuf_track_all_domains(area, pages);
+	if (iopt_pages_tracked(pages)) {
+		rc = iopt_pages_track_all_domains(area, pages);
 		if (rc)
 			goto out_unlock;
 	}
@@ -1983,8 +1982,8 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
 	}
 	pfn_reader_destroy(&pfns);
 out_untrack:
-	if (iopt_is_dmabuf(pages))
-		iopt_dmabuf_untrack_all_domains(area, pages);
+	if (iopt_pages_tracked(pages))
+		iopt_pages_untrack_all_domains(area, pages);
 out_unlock:
 	mutex_unlock(&pages->mutex);
 	return rc;
@@ -2024,8 +2023,8 @@ void iopt_area_unfill_domains(struct iopt_area *area, struct iopt_pages *pages)
 		WARN_ON(RB_EMPTY_NODE(&area->pages_node.rb));
 	interval_tree_remove(&area->pages_node, &pages->domains_itree);
 	iopt_area_unfill_domain(area, pages, area->storage_domain);
-	if (iopt_is_dmabuf(pages))
-		iopt_dmabuf_untrack_all_domains(area, pages);
+	if (iopt_pages_tracked(pages))
+		iopt_pages_untrack_all_domains(area, pages);
 	area->storage_domain = NULL;
 out_unlock:
 	mutex_unlock(&pages->mutex);
-- 
2.47.3


