Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29270CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121998E0042; Thu, 21 Aug 2025 16:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032358E0041; Thu, 21 Aug 2025 16:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDFCD8E0042; Thu, 21 Aug 2025 16:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B07318E0041
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8652D117D77
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:32 +0000 (UTC)
X-FDA: 83801852064.07.C8E16E1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 292EA140005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NWRarvld;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806910; a=rsa-sha256;
	cv=none;
	b=HVCruhZopdUkrU9SnaYEV7MaDUDikZ9aDrqgXffdUdxVa479ViBqjRK6HND24aaFiCYHsq
	xfyhJDQf0Ls7SeIa6+phO3OL0vGtZX7/yehnct0uY8Hw/c0kXYSp5JJSCZ1BWAdPGABuqH
	nwsvIO1ju0283KoM79chE106y//2L+Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NWRarvld;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKmA6ti8X8/YIeKKq4I8EEiHVsObQn302mzSXytdc/A=;
	b=Z0CIr6ISyx5t9hVUxPwI47GpCt8csmnDctL+enM8AFVYUjyQ5tACyt+1HBtNvK1jIB4QC7
	eBIRnPWJfHU/RTLY7kuJGh+ljTIJqXIuHWIm++OKWJOMqh9c9KeDtXtaIf53FOhaI9W9nn
	ciPxpqcjdYwabAKLHWoiPccJfe9BFmU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yKmA6ti8X8/YIeKKq4I8EEiHVsObQn302mzSXytdc/A=;
	b=NWRarvldeoVMzkJGr7qTulzroZufCxwLHAjJbaWSD6NrW962U05dnJDV7gALcriLv8LryD
	/Qcd5hFcdDBwe21HYYTFZMi21CGvvsu5whVAu4qE5qqakMjJxMbvzGu7D/ay+5nAluO7tY
	D1BRN2inxycA6NonNm0YrWn08CixTPM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-ugToPI7CPNSBte5dpF0u3A-1; Thu, 21 Aug 2025 16:08:28 -0400
X-MC-Unique: ugToPI7CPNSBte5dpF0u3A-1
X-Mimecast-MFC-AGG-ID: ugToPI7CPNSBte5dpF0u3A_1755806907
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9edf332faso441385f8f.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806907; x=1756411707;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yKmA6ti8X8/YIeKKq4I8EEiHVsObQn302mzSXytdc/A=;
        b=Cu/Z0HVoqZQnpb0uQD6WVHNVcWAYec0DOGVGWme1mylJADv0vU7XmP54lrY989XxZ4
         pbrXO6IHoGlEbeSslalCCv/wsIHpd1FkwerVkXQeNLQn8E6DLxrMYOo3dLkxwysiFPLC
         qLqKO7K6+GsvHfwzBCXILVxvP+Q1v0paPxRivSEmIDMYM2UnaNjPwblt3OjNio36ks+C
         hZ7mq96yUeAV+v5PJky2roMJtTq57HOSiiFBrweL8jXRqbi6ZXMMMbFgn03F61mQ2UU8
         m+aq3Qr7zG9e0KWMOrFTLgOzIpELUfDvvQnyG1snq4uczm7h4Cup5QFRaq2PIi8kU7wW
         PY7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXcWYxXdFNDGZp8WAzldXSbhZbPNTQCbfWbnToZnfEpkaGm2QZgzbZAktzhF6sPeOv8vyq62wbIEA==@kvack.org
X-Gm-Message-State: AOJu0YxK6rv9hDzrZZIKMk8Uk/PbEAPQjy74f6+SmU7QkDWzvYTIQaNG
	yi11V95033WOq8satfbVlTOZS6JSafVb6Myqqu3eCC8dUKTZqPrdcbjz3A2rEZCATKXlLTJsxq0
	klTD4hLGbDfPXn2lSMrfUmphngrRt2tCO9zHrvUknadEDK7pFCatH
X-Gm-Gg: ASbGnctUwyOO807lKeCAzxPnK1zI9FTK3sl3oFeDXxDAyX8EmwdJzXWif7Zhwve0z7V
	LCOtsxc2RdW1CYhV1hZMRk0DjKLk8vT+W2iDC+3upHGObwIDfF7K2PPTB6dlRUn4Ep2yFK3aCy4
	4l72mj9QnVyBae/W6lYO01pAUeiIrNKOlO7+kpWFnMTW0a8foMMmhTmU60sB+NULCqNXzm9QG92
	XngI5GBYzmpU+wtipOQsQtKZRoR8RY9aYVayoLRmUgnc4Bzcq7G/An6p9CffvWg5XyYNeQcj46s
	2ea6OfscSo98/KoKXThDSMa/8/b696VQzG4UqW2NJRVIi0+6o5Ljhu+T/6QJYJ044jaiUIIKgER
	MeSmW+Em3Bw8QOqjmBRhkpw==
X-Received: by 2002:a05:6000:288a:b0:3c3:f134:28ba with SMTP id ffacd0b85a97d-3c5db2dcc73mr210124f8f.28.1755806906750;
        Thu, 21 Aug 2025 13:08:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFquQDwTQ7641wc0kBtooMvxSzqNfE3+XbhkCNDvunKpGE2abRVQ6uRBkb0Dc/grDWRh0uIiA==
X-Received: by 2002:a05:6000:288a:b0:3c3:f134:28ba with SMTP id ffacd0b85a97d-3c5db2dcc73mr210077f8f.28.1755806906301;
        Thu, 21 Aug 2025 13:08:26 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c077789d12sm12702699f8f.54.2025.08.21.13.08.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:25 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alex Dubov <oakad@yahoo.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Jesper Nilsson <jesper.nilsson@axis.com>,
	Lars Persson <lars.persson@axis.com>,
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
Subject: [PATCH RFC 28/35] mmc: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:54 +0200
Message-ID: <20250821200701.1329277-29-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OCtDAODxFWd3cB3ZlXhBZlh7uHA-AwM0H-sR3eTE5yQ_1755806907
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 292EA140005
X-Stat-Signature: n3obmng9okts86mnsncjeaca9bgc6n3a
X-HE-Tag: 1755806910-115412
X-HE-Meta: U2FsdGVkX19I9Hh7q6o153c24wHQNIbguPzIYCbPwjPEX6+b6H8xZAyVcfTqbS5TmB4/kBfblp5zbxlhmvnq49R/Tw9VNUNIXo09nQHQXtoWCANj3MUNi+lFq4AUPRuU15FT64GF/2bWkD8ba9U9r924mQRQdZCA4EwH+0D+tHB/xvk0ExCEPu5+iICBw8p5HQ7oaRqt6hw4UPtPV/TxEm1yLEp/xeSNGxAUmbx57zRE59kDKHduUH6GEIyvoHnuOixGzkEcbQaQEnyWQ71LbA0wUj/uP+wZh8NU2RIcMAUGAyLOuZ0ZLxRQZj6O3+KtMNAe5WyUiDo3N/gNTrAU3DxwtugIY1pQ2+5NjiPmxn0MluP/o+doftV2ooyGeHF0wIUOQWz0O086POdXnxuLgYJYLKqYUNEFQfV90iu/dAUmWio56VHzTE1u4FbFx2DcfSbhPapaZs8dFjiyM6pZZ2FStTTfLRK7KRSCJhqy4G4LWjZQ3M23utmrAQZycafRY0Tx9bc6I3xXAS0LWUd57nVdRz6uhD7lkoweNHahMupuhDgKnMzFR22cS8v/XymTWn66S2VbP4TFxvfHacodwY1f6hPlsM8DqTVf4YKu+VgaBCk1FFO+WupxaXwZe2+z/4idoIaePQf9wkqxhixpfBfSXjax13rVzokezt20fXbrqS4sWWUnh7Q6EBEcAjIoVG60PA/EJXzoOaEqAjeoaRzi2oJ0aA0JZthwP9Onfnf0GlrLkjYQ73S76w9HX09ecJbW1sIFT5bL8j1dU5NC+KVIpwBgpz6AlYi9GJ/cjvlitTXICSIGTcBvIbQ3vsuMUglAmUrtYumKKvIajSjmKDOP7bXbvWCDYHdZb/2OFa8abOnlfqxSafisRZ/5OdkgldSWzXJR/fZO9Zc5dJrE9OBA9f9EBqM3CVpJ6pFBQzerFg/jUY6JOf3jLlL+aXnQo6io2BNYm5AVkZJdI6C
 ec0nTJ1H
 52z4EaugqYS1RUtRlUizKBDiseGCU6lv1EsrGQ5EtV8bCyxivq7STkhjHy0BSyvgXNqGsEOi4sZoG0b5TJj/VmgyWlrIWaCzKgE83r2+KTgCLLFHfiPQOHYJcKm7LLiNcy4jHKtYJ5WQ2g/BSG0BuB/PoRd7OSwTf2dmrYKvJaJWAG/xWB1mkc9CniX2603ZuFp4RmSq4lR2ZRXZcQlTVl1O9kIiwHMk0AIrUsKygpN0BPfrTKIaEeHyDsVs/xz4hmhLJJaT8mdtCi/N6hHLUVYkMUp/wyS06hZFo89fTMpBha7iREl2FST9as81fhKFynBotjEWGJxHGYHFGmOlHKe3FWvN0Vy4JEuxZaGz7W4qe2PcLOuCFc+qMD+HVS3TspnNV8kMzEO2VFCyTs60UHoBmgLefi0gSKyJRzo9P9r1PV9KL1/Eaw6RKIRuYt4/5t1u5e8uPEVCoeOnE/xtmpNpQJGkWa6tfDtgDUPRiTAu/jLN3QIh1M4jy9/381A7/9jPTXcd3H4JuMuyXBeKoBoZmsh09xeb7bFiupTJHkfsNrkoJjvhKhtt/REf5k9obOsAWS1NEBYGKvWis7af1hQvAEnWYevAfwgQ4B4SOihg/djUCJSbSLBqM5sECe0BftQRJDNP0WTvH2m/czFvze2SRNSCpiSwBsvnxDdZ9LF83x7AxmM5RBso49e9k6QiAoD52
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Alex Dubov <oakad@yahoo.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Lars Persson <lars.persson@axis.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/mmc/host/tifm_sd.c    | 4 ++--
 drivers/mmc/host/usdhi6rol0.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index ac636efd911d3..f1ede2b39b505 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -191,7 +191,7 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
+		pg = sg_page(&sg[host->sg_pos]) + off / PAGE_SIZE;
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
@@ -240,7 +240,7 @@ static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
+		pg = sg_page(&sg[host->sg_pos]) + off / PAGE_SIZE;
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
index 85b49c07918b3..3bccf800339ba 100644
--- a/drivers/mmc/host/usdhi6rol0.c
+++ b/drivers/mmc/host/usdhi6rol0.c
@@ -323,7 +323,7 @@ static void usdhi6_blk_bounce(struct usdhi6_host *host,
 
 	host->head_pg.page	= host->pg.page;
 	host->head_pg.mapped	= host->pg.mapped;
-	host->pg.page		= nth_page(host->pg.page, 1);
+	host->pg.page		= host->pg.page + 1;
 	host->pg.mapped		= kmap(host->pg.page);
 
 	host->blk_page = host->bounce_buf;
@@ -503,7 +503,7 @@ static void usdhi6_sg_advance(struct usdhi6_host *host)
 	/* We cannot get here after crossing a page border */
 
 	/* Next page in the same SG */
-	host->pg.page = nth_page(sg_page(host->sg), host->page_idx);
+	host->pg.page = sg_page(host->sg) + host->page_idx;
 	host->pg.mapped = kmap(host->pg.page);
 	host->blk_page = host->pg.mapped;
 
-- 
2.50.1


