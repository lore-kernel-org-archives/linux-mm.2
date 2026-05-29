Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 255D5CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843626B00EC; Fri, 29 May 2026 11:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F44F6B00EE; Fri, 29 May 2026 11:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70A246B00EF; Fri, 29 May 2026 11:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60F3D6B00EC
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:24:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3422DA01E5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:29 +0000 (UTC)
X-FDA: 84820829058.05.B41FF1E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id E7B82140018
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eI0KINbe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dg7l+XMBUZMVnB4+qTLsym8fNCo7JvPxwQL0Jq5Z3w=;
	b=BfteOEk/J1hSmsCrFls6iqTUp/z4Qi3GBmPz0IVjxH2NTuEG9LdKqEmFLseXalj5FdSrpE
	k/tOZxAbp01muSP2POWmyG3V8B4NlvUm+misOQyk57jLKJ5ZCQSLD+6IMrz7d5SVT6QRN0
	2ycthcYMXpZjRvX/YFAJQN4yebDy0tY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eI0KINbe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068267; a=rsa-sha256;
	cv=none;
	b=4GTEAY8cm1ufM8cz6Add7ZgzfQSp1cNLlDl+kGSgAEvaTdfm/iSMue+kTL4xZzyMJJyMTY
	H1gCgNZvYIKoQbIjtBULYAGX83EL9LBtAue1/Q8hcN7cIqiN9U9u8Xc0r5iDL0Dkefb1ki
	qpD1arIQtJgr5lhQw+8UjcuQwrHUdGQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8dg7l+XMBUZMVnB4+qTLsym8fNCo7JvPxwQL0Jq5Z3w=;
	b=eI0KINbeQaqrMPAgjIacyONjF/A16idgT+c5RpX10lNZd0mWEdKLGUu3RYRiuhrflAKcgE
	dhcQdLSL/pZ2/ioDLCyKwKwzbVhPv/i7XBCZMpiPPH3HmngbG2T9ih0vYuw/SPlaj34r/Z
	fAxMjAIjl8Fw54HJ0lGEM58GdVXX30E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-449-gM48n6HuO_qMMK-bOlP0Ng-1; Fri, 29 May 2026 11:24:25 -0400
X-MC-Unique: gM48n6HuO_qMMK-bOlP0Ng-1
X-Mimecast-MFC-AGG-ID: gM48n6HuO_qMMK-bOlP0Ng_1780068264
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-44696b11265so16693321f8f.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:24:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068264; x=1780673064;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8dg7l+XMBUZMVnB4+qTLsym8fNCo7JvPxwQL0Jq5Z3w=;
        b=G/UI+MnQ+vUQFhCRIzo1O8mhcs5u8gZ+u/pvOOsD1GqEfSFXTib+tVjbZtZXG73jkb
         p3iD11M+x9T+BbTlOwM96StV0VyglGPUER+EBC5eUbtY/b76Agf6vcdtyFSCEH4zzEYb
         eynbg1slUZYsdHQnd7kmLdmCQWgGPXn0uxQOF9OIqMkMMiVu6st+jrRKjv8WE/zRx+tm
         O8UP1MxfXEJB8om3RO0oAlfNaFJVMvJzvV37y2kjmYwq6yqdsaO1ULhXrPNErEPNnb+b
         Ryc5WXF9v1aIYPKzBPQDS3sEhDwtdQ5Hzv1pWRmQMPPYOTuchel1E6BlwWr15/FhiSEh
         3zpg==
X-Forwarded-Encrypted: i=1; AFNElJ8qwuqRuKXA7hQE2Pn3TUvFLgXGXoiO1RV9bNsbXLNCIR0NdkwggvsIPFmFhAQFMEvCXefs1jaiNg==@kvack.org
X-Gm-Message-State: AOJu0YxgLiwiSX3ECkbWudM4mTM3fzeTXseGFAKqnZMN/OF2EgB6t85b
	m6/VkFdhaIs0I3qgYqElduTMZQnzY66qfQbY/xRdg+VBzsBj7nqTy8LnnHK+BHQw315ZjeNG45Y
	tQJjCb+EKLI4q1HVW8g8lkQz0nBWlHTZ/DfO4995VmxEp6KLEKjel
X-Gm-Gg: Acq92OGGAobirWOoiA3VkrCJX1e4HLxETOxr8iJ2zlhvNHtr9JH36Ps7CnZ1gV8EJ+S
	L4IQhaMxmpnNni99QpPxAA1z0/8MJBLti6GGw6577RTgCeCr5Q9x9Xej0zIyOUrnvatbKM33THF
	Rf4DtgFTb/tnCCdkEzbWc+hA5yfe4n712euD4x6Ny8mWWKL4BuCMmKVULY/HWxQnvfO5MAXL5A2
	sOXgS3BSVkxHdgMS/TCJpkNbqk2AWEd33ciBvNip4dS4VJjWtDZBkz+sF2HK852bZekj1M9bXOh
	lZA7g4jEn01PUsxckqC6mdMJkKsdHL3oFrnWoAgwVx4tNOvDwqS7aGBCfkIlOu21qEPiiSXwIV3
	8iqfxdSpeplZt7YF/t3IaqLfqhydju5KUonMyVq5ZBE/tfsJ2UdjA7w==
X-Received: by 2002:adf:ea85:0:b0:45e:eec6:5023 with SMTP id ffacd0b85a97d-45ef6b8831dmr324577f8f.37.1780068263580;
        Fri, 29 May 2026 08:24:23 -0700 (PDT)
X-Received: by 2002:adf:ea85:0:b0:45e:eec6:5023 with SMTP id ffacd0b85a97d-45ef6b8831dmr324493f8f.37.1780068262980;
        Fri, 29 May 2026 08:24:22 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34b834esm4139592f8f.11.2026.05.29.08.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:22 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:18 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v9 23/37] mm: page_alloc: use aliasing checks instead of
 user_alloc_needs_zeroing
Message-ID: <8229023108f900d50b47bd85b5a8f8eb5f95ef03.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U1ivqLNbufX7PMhpBR9eDiA7HDwm51y-aQfirG_nlXc_1780068264
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E7B82140018
X-Stat-Signature: y3dj5x51kb95ogfpnuo59a8tztqoz761
X-Rspam-User: 
X-HE-Tag: 1780068266-575980
X-HE-Meta: U2FsdGVkX18Bjwjal+Eepbo/upGJ4aW3O8WoIwP/+V8qon4B0OVQmDVNbHtByUc+Xx1jJWLdbC2bl26efKJUTCMnABnE0tdqDUs3GYCLHm/zwnLoxYyvA70hM2MpgNk9h7uoTrQMPoIaTuskwIoKCUz4n/iIt4b/u0iuCWqlR13a7c7zcepRqs8wOeA3kcOE/cdIMDjgaw4uRYQ3ybRbrSqCmfffCjHjbsdg874haBclYn+W/bCGdo0SAMCZ+VVZbJ4Wewr29v/sjhz3QFipghfs9gwm2khyKJYzh8t5veCjlBDr3kh0D/G9y8paDusb5avtpiTwVrxthSO2dNcVNcDVUdoMzaEfqeFtE/xaKQYaXiybSaVmIZ+26SAS8WYq8sdJOyh2Fuwgp9na45vQTN3u2BMW+iLL0ePV/dmC5Xy4x2+IC5O216c+JwIEdN4zvghYUORbw5bdQK7RGtHdT8yrCJPuULvyVhhl7brLfDQCLZrABlsGGhk1Wa4xEsdeVNM+hZ/5RBTjphhyEzx2VjsxEgp+xR2l71youg+tQ4YttLN1/NX8Myp7kdGojHgFwUy1fsXWxoxggc3j1l6402wbGXM++unVMikW07Ed+9ec9srqtsO5eB9CGGrpPMfI8YQlVFud5CsXbNZg9ve7/AcEGsfGLflGyQkOB/2GSVIiR1A+N8fhp8NAKpHJjJreO+5HWAoiAS6fWQm5hyuUGnG6N/KLBElJjmxAAb0qWr1ai9bMlNDB+4V8cweSo9a9/fobPjGsyf3T7gG5etenTanK9UKk6sZzkBzh4FS018lypupj+Ctewt4emLCpUZFd5gOLjHMHAbx1lPN8iQt/H9Y7k8wEbHAlPdyJ/9rRH9nTI4lOwXId+ygSGrFaL9XFQ7RXhdhQhXFa+HmVVa/U9T1UZ76xiR5YdEqhp+DULJ2+1mxrQlz7KICh/9OVdGLZlpyGyQ5LiLUgWGhXnie
 B3g0vwhg
 7OZ1kemgrR2942hTj1C6OTS184lzH5/WlLnSv9QwnHqbasRrcC9Bm7djUbdKq33YrP1LQ4+acdkZOusuwtc5lDV3F6HLABQrwOd4kpsIyVDWXLNMLbpIuh8DWOadjNmQHN/Ir3bJhPmsX3jQBgmIWOz8LkWLAUP4sQNWlPiR/nGP+sS8R73wCYZ7CgLjyRaIeWgGFR5kGhnQYIbLX8aKf7vutmMw/yXBhkexIWMf8JKGgb2lMSvEmwDutdKRQASeF7L5EHx8ihj71E0MVtwjOWLGTxIalqwXhyKXgrq4mVkSKrKFJxENnFPkhtbuAXRtdcfj8gdbKXyWmPKnprIEb+zoCPg23M9Q4DOS0oim+o27H243gPfN0UE6F3apxd1eNG38Gm4W1aHpar6gJeiJIM7bBqDP0oNj2ZeeO25MpYPAHqyO//K5TT6HvPTP5M59WWXTf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace user_alloc_needs_zeroing() with the direct aliasing checks
(cpu_dcache_is_aliasing() || cpu_icache_is_aliasing()) in the
post_alloc_hook aliasing guard.

user_alloc_needs_zeroing() includes a !init_on_alloc term that
means "allocator didn't zero this page."  But in this guard's
context (!zeroed && !init && __GFP_ZERO), we already know the page
is zero; init incorporates init_on_alloc via want_init_on_alloc().
The only question left is whether the cache architecture needs
the data re-zeroed through a congruent mapping, which is purely
cpu_dcache_is_aliasing() || cpu_icache_is_aliasing().

On non-aliasing architectures with init_on_free=true and
init_on_alloc=false, this avoids a redundant re-zero of an
already-zero page.

Note on PowerPC: PowerPC overrides clear_user_page to call
flush_dcache_page after clear_page, but on freshly allocated
pages PG_dcache_clean is already clear (cleared by
__free_pages_prepare), so flush_dcache_page is a no-op.
Skipping this here thus has no effect.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5158f7e23d18..4cb7e779a6c5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1883,7 +1883,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	 */
 	if (!zeroed && !init && (gfp_flags & __GFP_ZERO) &&
 	    user_addr != USER_ADDR_NONE &&
-	    user_alloc_needs_zeroing())
+	    (cpu_dcache_is_aliasing() || cpu_icache_is_aliasing()))
 		init = true;
 	/*
 	 * If memory is still not initialized, initialize it now.
-- 
MST


