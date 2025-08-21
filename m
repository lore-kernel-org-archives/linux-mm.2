Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02361CA0FE2
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899738E0041; Thu, 21 Aug 2025 16:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B7F8E0043; Thu, 21 Aug 2025 16:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602B28E0041; Thu, 21 Aug 2025 16:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 447738E0041
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10AAF160548
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:40 +0000 (UTC)
X-FDA: 83801852400.04.F7CE8FB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id C48B240012
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ad2SbL3V;
	spf=pass (imf12.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uIthYg0x+2djveHghlw2Jb9wmVGYKVQz7R4ULrPQfiU=;
	b=CHm6Sznph731gl3JkLIpyNFdtPyZY1sHTz/P28cioZZb2iTuE5IDCp8SfXWCmwWl88+v+H
	t8KMRYKi5tfsYoqng5awNyK8JsXEK1/iwhgzGOS6ttueK66vZhVdYNoU8BWz4xM6WyKkEE
	fKYaV10RfR8m7hpd5XjeZp9hPTJx4j0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ad2SbL3V;
	spf=pass (imf12.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806917; a=rsa-sha256;
	cv=none;
	b=xlf5aNmDkBkPx6+kpygkDjDPZDnDALk5Vr4jgIyeh5Cj4aQrZB9rCGLf6ipuvgMc+LmbHi
	vhZc3lq43DWTne4ttQL3XWo6x6Wna4ZbB8+wLiWU6ph1I9C2HXZXYXXTTNAQe//oInNHaU
	Agi8ObItxI8dvRYOgJ/ctkmK4ren+G4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806917;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uIthYg0x+2djveHghlw2Jb9wmVGYKVQz7R4ULrPQfiU=;
	b=Ad2SbL3VzCw5l98GDkSDmQDvI8gCSlUffGOOOsaIvG6VzQnMrer7ytK9zzP15Iw+f94ACr
	abBGg3HqdZPydGLS68ofELxFnY/kxgXolQw37tlZkumUsyXineFJc/kL32kImLYk9nI2X2
	KksZz6+4lVY6R0EjHm/kYQ8V7yOyifg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-fgFg6sV0MvGM23LuGcSFNA-1; Thu, 21 Aug 2025 16:08:33 -0400
X-MC-Unique: fgFg6sV0MvGM23LuGcSFNA-1
X-Mimecast-MFC-AGG-ID: fgFg6sV0MvGM23LuGcSFNA_1755806912
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9e4157303so922959f8f.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806912; x=1756411712;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uIthYg0x+2djveHghlw2Jb9wmVGYKVQz7R4ULrPQfiU=;
        b=dby6w6eV21/8zg6iEbmaJakLPQcHCNTDAVsQh8Dl/k2F/9VXxItftV6MsMlsgamG1o
         rHjV3dswgNhe616q3tGVBzVzhaV2Er9fKWCB4mmix9UcWWJy8G0rRZkSJtj3czKi6e78
         KFSD+tSXhtoF5GSKXevlNDGiupEZ5rllYEpyKKycE62J07tC0ynx9vLOMjDkcHEIOQpz
         K8rWmzuWyCIVs7AgcQt1ZFQot6QOltOPd/mJJQEBRHZmdeim7uFRorhWOACgCmKDP5S7
         tKvciE8qN9fRj/FYYXyxNSuYI/cHBvdCMann0n/I7khKJgju6vV6pmQJvAkFUqA39XYi
         urrg==
X-Forwarded-Encrypted: i=1; AJvYcCV3BmJqDKvERGo3M5DyNG8f4WYpmwBt0IqnQwbMIgVp9NgeMKH21O9MjNgcJFERY3HAGMvIDoYBmg==@kvack.org
X-Gm-Message-State: AOJu0YxwhMBaTTr/iytA6B8dR5V3eYXI2mwnmviomY77SeesigC1f0bu
	zS85abK2xMgdQ3dcIsExP080kgoKCkJA1RqvR9RbfwI94qrkDWK61xwqM/OmQkbndNXzv4kvUbL
	fSjH8/b0vtfAVntBgnJ5OpBfbk3leEM7tfffgaeFPQQlLIy+C/39n
X-Gm-Gg: ASbGnctSVF986olDyu0i0aSxvUqMdJJejeDU/5uvZr9eDtpBjzgmrS9DVOMT9sWrqje
	AEabw424KXdUbdZxcGHjta8AF6Kj+KtqTYeRM8AhVBFlDZtP7Jl7QLOp/f6R0aZ+gRIchZrgm2p
	i2QtTcMi/yWmu/YvcX52cnMvmOFiIiGQCoiCyBof7gLQRFfwF+VslZLBk2klPH/g2UE9PeYDAHK
	oVffHyScsZ2LscY5MqRoiBHhTffm7HgetWktmRlZ7YjumgBOep6ojO+L3yiJQB7MnCd3OopZTa0
	C4g9Q9xhnMC5g5vL5zokZyA4DnRxPfWL55slRsUC/iUn7i6Exkp/C5xq9dBQhLyySkiLxSAbsgh
	i8LFs04vCBybLVLvmBCAtdA==
X-Received: by 2002:a05:6000:40de:b0:3a5:783f:528a with SMTP id ffacd0b85a97d-3c5dcefee22mr195283f8f.59.1755806912320;
        Thu, 21 Aug 2025 13:08:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRe/VOMg0cdir08bDTWMwU06A85Ixelypa7wMbtHpunFYS8URS38ofNnAO5nDnYJmoWLlWSQ==
X-Received: by 2002:a05:6000:40de:b0:3a5:783f:528a with SMTP id ffacd0b85a97d-3c5dcefee22mr195231f8f.59.1755806911819;
        Thu, 21 Aug 2025 13:08:31 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50f16eb1sm7598185e9.3.2025.08.21.13.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:31 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
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
Subject: [PATCH RFC 30/35] vfio/pci: drop nth_page() usage within SG entry
Date: Thu, 21 Aug 2025 22:06:56 +0200
Message-ID: <20250821200701.1329277-31-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 68sYJlAUTfkJKYK87cx-SPekjabJALBSWbEit8O86sw_1755806912
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C48B240012
X-Stat-Signature: sm6sbygpfbqb3bpni7gd74z5i5x8wy47
X-Rspam-User: 
X-HE-Tag: 1755806917-226472
X-HE-Meta: U2FsdGVkX19Rju7YLYZ7m0/Gt9jof4mjqq9bFd3iCt3pf6L/ZDGXoYqUIOZCyMa+fks2TBwv/6ejU0qdXVNoA/4OIMc0ugWGpedTTN2ZtSOIqmDdda/y/VzjtoQlKcFR3HmHTqdhykHQq+i37onYV5vzqbsfc45pI7QZkCf3grR6rAjsW8g/8XBJL/IsSlduNwCs7bZFgA7MCY3S4aB+xth9zwRS6skFpxjlZGX6Qad5i6yeGyohztdAVX24lgWwwjQQxy6D6Ht/WBmgzDWf5kgQJ7M+NCnIUPe4YergRvp/OS57P+MEmVh2vtGuqabA2yIdVuO8xHQx4nUJ9526ohHZbBw/1ptJ5nq/Aq+GISOnEH+KE6tm24x2VIFC5lLMs1PZVCjPkMBIMZdbmFqmRUg7GnVONwe/oBAT1Y1OhtyvL2BHvbSOs9Wj4P09yfKCc1zTZET0IklKtIIols3gxbigtK7O9zgaQRqDztqx4uWyv41Vz3BzngHRI4E5kVpTLGPyfEQsDcw9Y4sJvS1RmSB2ZvvINHM17l7MynGUgpTZ2Ml1T3w+XB+telAPidXFmkgSw7FtIBAuwxvgd7cjwD31S/lS3nZ2S20+1r+GTgufEfEqAn7Mzi5VDX4gLyb48+WHLnROvjQXn/tx51MQJhAz0ahJpAmzJL21m4Qn0d4TjfiLaQvbw0NP8hkjq3azSA9U0OQBF38/7zpb/MbopiDHBrzn5njkLePagq9CVPwmdrfd19qJ04wgN7E7Sk7rog/+UJOmsyAZ6uewO8L2DRM8EU2o21DpBgI+R6/1ZdF9Kvfq/fiz/Zx3LhBob5Xdf6/ZreSBepxiFhIScrKAfZ11HmEfX57R3NBfT3ByYq8LL0JBxWkSRxMCfXX+7y21NSh2zoS9YF4/gJ4gt1b/NMqsxD6sHNfcAM4mUPKH4UF+B0SNUN7f99CVvolkmv8vZ0l1H30bS2LjBqaU4xn
 M4qKoSOi
 3/TweC7hBxTAkZkNbP5ZROx28Awt1mOwRGiwhxUU1SRZvCJAF9ZKNof1MEkqSLSyA/wNSjQaAR6vo17jLikpsnoZJmj1TNnqboqA8Sr8ndw4yoIXGtU/fyYNRiH+Its+lpyrEzWdH81gsXM0BTDPGYIBALjQwSeye57LZ+fDg547DrPqz2yzORPwZENzGkEcqy/4CdcTl3fF6YkxytmL7E92hO+t6XNJvbsXncYYgYqU93J7lWYoBPkocaYtGrgJIvfbFAVNx+JnZD7fogrSB0puTSJpJPeUOyUvoorqO4d5QzAjwhqAvC68tAaaSwHQcgVKTFFyWUoy6idEHXybJZiXqhFPOxinHt3Ftd2zX0I/oezxcEJ6FbX1hhmfVmaYROVBt2rZ4Zb0o9x8uJAiidnlB/VxChfZ9tJlEfPLerZPm5CqdPb2cAYye3+AFX9V7CJxwap8+kbn2NXAHLMuFY9itSVKfBB2YGmNpnKozdOenKPj55gNVIjrdDNBUPlw2t7pf1Ll1vYzhOp4BNkDomC/OrhEalCIl01B1oBVCl1BQJlR/tyOzYcbrHKCAaBMJzP6RaTotBq3q0ApkOS9K3E+4yYa5PDwhAi3PuBnzMC8WjHlIP1ifF8Zw9nhZ91/MyGjzWlfDpQ7OkK4F+b9oDd+9h7sNJdYbCmuWXtV2I4K8kjeYSscIhMzgUhW/ihzhJLoEZ7OPG/OMVuQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() when iterating pages within a
single SG entry, so let's drop the nth_page() usage.

Cc: Brett Creeley <brett.creeley@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yishai Hadas <yishaih@nvidia.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/vfio/pci/pds/lm.c         | 3 +--
 drivers/vfio/pci/virtio/migrate.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
index f2673d395236a..4d70c833fa32e 100644
--- a/drivers/vfio/pci/pds/lm.c
+++ b/drivers/vfio/pci/pds/lm.c
@@ -151,8 +151,7 @@ static struct page *pds_vfio_get_file_page(struct pds_vfio_lm_file *lm_file,
 			lm_file->last_offset_sg = sg;
 			lm_file->sg_last_entry += i;
 			lm_file->last_offset = cur_offset;
-			return nth_page(sg_page(sg),
-					(offset - cur_offset) / PAGE_SIZE);
+			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
 		}
 		cur_offset += sg->length;
 	}
diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
index ba92bb4e9af94..7dd0ac866461d 100644
--- a/drivers/vfio/pci/virtio/migrate.c
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -53,8 +53,7 @@ virtiovf_get_migration_page(struct virtiovf_data_buffer *buf,
 			buf->last_offset_sg = sg;
 			buf->sg_last_entry += i;
 			buf->last_offset = cur_offset;
-			return nth_page(sg_page(sg),
-					(offset - cur_offset) / PAGE_SIZE);
+			return sg_page(sg) + (offset - cur_offset) / PAGE_SIZE;
 		}
 		cur_offset += sg->length;
 	}
-- 
2.50.1


