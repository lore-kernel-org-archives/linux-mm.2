Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 570A0CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148988E0033; Thu, 21 Aug 2025 16:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2C78E0034; Thu, 21 Aug 2025 16:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3DED8E0033; Thu, 21 Aug 2025 16:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C913F8E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 959DC83A68
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:52 +0000 (UTC)
X-FDA: 83801850384.06.8381226
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4B3B0140005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hwJgGlgC;
	spf=pass (imf23.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
	b=QVbFKVloYm0x2jwLVvcb2UUOJ06zGETUMcMCzJLJXM+ZdfxlH8dQCnKyMdNv01Ihig6XyC
	c+wkRz561zFVx8lihOv401ghtHkhbgtvv2p3PM+b2klkhkgkEffynbWR5t7UPcqOYrmtOo
	obxuUx2Dq7RZC1KiAUZTpCzDfr3iCJo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806870; a=rsa-sha256;
	cv=none;
	b=08+kva0fDzxxxCxHYY8unHaztHbiqa1A7UDzByI8F5FS7dqalZ2MXogSbMM+FFnijG/Zjr
	x535HZbMKr0uE/c5ePo1DntlzkZIOnKI1xmFYuooeG6CyIX9FTVWvuVLytZdQqZtrzG10b
	Bkrz2KQMhgMnKJIXpHMJi7quJMG4FnM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hwJgGlgC;
	spf=pass (imf23.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
	b=hwJgGlgCUmgirtrA2eHxnEBgJ0uFpDxTtXG/HykbvGgE3BRkOkif/BQ/oCDQdu+D4BSA5d
	pXIfQgqJblIXe6lbmFJTSBxtwAQVI4ObAAfn6dmylvYDLJHr6TI5zzLr0XEj+QgBiHGDxS
	cBeoaAByPSk16R0GUz1khR8EDErkIYQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-Ox_lVGk3OiKNWMEIge8uWA-1; Thu, 21 Aug 2025 16:07:47 -0400
X-MC-Unique: Ox_lVGk3OiKNWMEIge8uWA-1
X-Mimecast-MFC-AGG-ID: Ox_lVGk3OiKNWMEIge8uWA_1755806866
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0071c1so6420375e9.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806866; x=1756411666;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
        b=ipTzsKo6E7+/8nQZPPRIHC9pX/aZaG1wZt1Svek6wiPUYE78qRJ602qqyEcgXb4+7a
         FTfxfvZKhqnzmZu3SmSaj6DSSQoYWOxF9li/gLtAs9e2XGAEG8DPuY1cPbUcrqycSHjW
         Iq3x/lsK7Ql3PW+XpSemtUSt+klQBrjknex053ySRSM1wmBq6vapwERAMQAI00sDi/PT
         GqD4wNQ3YhRHt9xIWznqk1bEnExb17TmYNgykt+w1uf5gxyNzWhPBPoQsPwhRPmNmpEz
         aynNf8mHXmQGcUBqaIaMb0c6o2JNCDpDnaBqpOg8PWfJUHQWwkqSVmT4wTqYISvyG04j
         nUOg==
X-Forwarded-Encrypted: i=1; AJvYcCU1ihM2y8l41UjgKBd1/s91a5aexvT4I8zmGhHavptWaw4gYcLt7jek34qhoSjMkawlC36JoaTsYw==@kvack.org
X-Gm-Message-State: AOJu0YyAHP5aMP2xsDhU/v5L0FRoRHpgH+01CZQlKZrYJZUcc1VYdLnw
	RMX8CSLlFhzMgILQ9ufyNNTF2q4mmizJiuVUka9xcDA8Px19OcXcIB+56i72tcxyXZEYTDl3UHc
	9tImj2ktTkQhUcL5s1qKT7MrYWt+sOWwc0g0D5SlUYOd9KSibFBgR
X-Gm-Gg: ASbGncsgSP4Pjj3q+LEFBOVEXKUO2xsEXadjXqxSDG4LxX3T67nKUqjO4uhDqzHb7YV
	waCMnnXr4l+VrUnPRRmpJiFmUpRU0CsQmZsOP72wN7cU6ObqtejL3wguJeXaj7edALkJ4AT11m+
	wTE6L3zADZiKEVhrJQDtZFBdDu3p3ozSJOixnPiAEnsUz/ql6umBRsizwwiCnV9QJXzD5sIMrpr
	nyvByor7P2SB9wy4RpGDmasxyoEx+xvMj3zdYtMgG5FU0ZnVlv0lrPz8UrEye70Rxa6uJ9Ss/mT
	C4LafHmlRvhNbqAUtXl3HoTv3tPBHKvMCvWIN0ly69D1CgAvRFpfiG3K/fAkC03pODJM1FqPzNG
	zyowyRuCcQr5pAeX7RjdEgQ==
X-Received: by 2002:a05:600c:1392:b0:453:5a04:b60e with SMTP id 5b1f17b1804b1-45b517d4e23mr2819485e9.26.1755806866192;
        Thu, 21 Aug 2025 13:07:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUtzGc4rPv18tjnV22wd1xjfGI25AJiVbHUBF3o7jj7YvZLrrv8XzLc39l/Z4dCqHj4yY2QA==
X-Received: by 2002:a05:600c:1392:b0:453:5a04:b60e with SMTP id 5b1f17b1804b1-45b517d4e23mr2819075e9.26.1755806865726;
        Thu, 21 Aug 2025 13:07:45 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dd0380sm8632985e9.10.2025.08.21.13.07.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:45 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH RFC 14/35] mm/mm/percpu-km: drop nth_page() usage within single allocation
Date: Thu, 21 Aug 2025 22:06:40 +0200
Message-ID: <20250821200701.1329277-15-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kz_eqzI-FeEnckcURuBCh6-sAJiAkccf_VKMO1qClCY_1755806866
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B3B0140005
X-Stat-Signature: 3xttc5jdxscdswb1cgnu3nj3rkfrhik5
X-Rspam-User: 
X-HE-Tag: 1755806870-554376
X-HE-Meta: U2FsdGVkX19E3GeYbCTN9giUWpBlBgrs8spp6lOdJtjUEnnJP+WDJC0esvXzMzPLsqsfhEgb+tr3KDG0u5B5syDIVXOXt+b9uFjESIE0VzdSWmZqFAXHCwPrrKbb2gqEm2yijVhaHUkCey7dyrD4NbPJA8sNTVgw5U5B2Jc6OjqNLmN+M/gaPKZ1N9sYWw5YIuoZzET8XPXGLMkrGzawtLIeL91thGKvwLcbngfJ/Be8gDmZSkl58+g8Pr7HDewHb9xzbf1RXMKpQTo3QYuRgco683rvxcnNvrCYEFGVSLgXn4lP2a5eZe1yjoaPRA9TxVO4pslcT2d3kM5FgBJQnmIf15pMEem/goA/n2fIJbFtgCim5xMUQ2WxnfO+sht+f2FDqGrwIZTeO6ZGhy+hupzLmYxpe/e3f0QsbI2bveCXAyKEVknQJa8LazSTJJh898khHr7pERVO8O24QdQJE6K5CX+OsKgRhKKvMSRGzCKS+eS8m8cPNvDBlLiTdIDsvTAB8Yh4+gwSv0Hj67ahs2FnPWJ4YFuHea7ESpezB55u6FIotE0nXQJ5P5T4lWqyTsQRkA0E8wOVHl7cCiJFSx89963lHaOjiir803vUBH1HqwJLS1nZKUVWM5H8xsDMqqWgjVKRXTTZgr1RGqwLLgohvwmJbZffs7Ko+XnaOdk71u9ut0HGCK49LXeQ7sjxP/z2dwdcPo1Q80YRTgDOIRpU/WjRSJGjBFlK24im+gMnY9majYQtH9oU/i32VPVJOpp/Fu+pFGSpKw775kxZ0hrtzHl7YaVDA178kbULvOyjO3zpm1IbRHZvtWujleCupu0Q94JF29VHgm4Oo0ZTEdU+fZEp9mUAcUitCzS1BcAaP74F5+N+B6Nq+edfwEMuG0EEXgjCAr3WbM/+DDsShxAVoBuma4lK5PHhh5NHNWT8vI+9fltlaS5vgI3IGWZ/Ekho5OEy2FJRsdudxLI
 kAvz+iAU
 jeSsff//+Jfau+nml5i/eBfJPfyPt+hgQ1qsPwXrgSdWKegGT8w6SpTFOAa4Jz85hAvOt2A7KQq6ENlriq7hq71nADEBrHhk7G9OQFrAasrQfkxJUFlePsbA7JbQ3350R/OvWOBsM3NVQajw6++f0QRnHZk9Yd63noG+TslL8TZ0BQ3a4YWV9gmwD/2bpsQNtxpTddegRP8m1Ci5fO9B3El4hd9BZ4oubhKqbiXLw+TasplyXUDcJRp3kkTdXo8jxrcqlR/TrRLC1OSezgVBn8xC6Z3jL0d+4wChFHwxqz0jNJuuujkKMa6xT891axCGrgBC3Sy0837l8jnyhayNs0m9bEWj4737SDiJMzLO3hkoFCEJ99CNnr431CZrbaCjpGG9hk+uGd8It6SssZJ7bRX6W+rtmJTsPNx39k5jplN0UEFN2LHZzsSOLKpa5vwM7XcMLw7B8S8GQf31PvoCx0y8wf/4dwxbSq+wNXFKzrlaPgbApPQAfj/zh6gYh4z0ohZ4iH+dINDX7APU8sKW6tY27MVEpPEAf6iYDyI+gWJZVvy5lWyLKMHk5wCCTd1aVCmtcbVYQnGpZrijFvbI5lR/WSwMyi9xl3O/WKRA4wqf+KKZa/ybKFMkiIhMxkZz6bDyk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We're allocating a higher-order page from the buddy. For these pages
(that are guaranteed to not exceed a single memory section) there is no
need to use nth_page().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/percpu-km.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index fe31aa19db81a..4efa74a495cb6 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -69,7 +69,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 	}
 
 	for (i = 0; i < nr_pages; i++)
-		pcpu_set_page_chunk(nth_page(pages, i), chunk);
+		pcpu_set_page_chunk(pages + i, chunk);
 
 	chunk->data = pages;
 	chunk->base_addr = page_address(pages);
-- 
2.50.1


