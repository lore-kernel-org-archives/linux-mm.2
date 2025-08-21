Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C81CA0EFF
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B27F8E002B; Thu, 21 Aug 2025 16:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5624B8E0027; Thu, 21 Aug 2025 16:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478648E002B; Thu, 21 Aug 2025 16:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3690E8E0027
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04B3C1DA034
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:29 +0000 (UTC)
X-FDA: 83801849460.29.09C9107
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id C4122A0011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YYUfE958;
	spf=pass (imf25.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOl+Pd7m6DQCTUATshUDhXjEbKNtUx8aQQ0CVjE/d9w=;
	b=WBW3iAajYptW2GBsN03WTIoDBqqZlQAnfzBKMBILn+i0dvKsOpZHwvM/5PiDg6f9Rr720E
	hrtozWMoI5kOBCa2FbrgW9SJ2OZ5HtuYzESDFjjwyalqWVp5Z3+HG36uHnk2WC7fzZTmoR
	8l8SkxBQNvoUY1fY7gL/ap3MF7t8C0M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YYUfE958;
	spf=pass (imf25.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806847; a=rsa-sha256;
	cv=none;
	b=xdbNBC4vHb9YTIO8NRW2dG8cozwYOp4LbCRgn4RZGyRK3HI/N1q9DI3LA3p1YnO5Qoux5q
	OCobaubbo5vsvzQlh5eF9riyjkYzH60TDymk97Cn1l4vGGTdKsRtZoe6yfGV8hNC1cgLqx
	94WA2LNfJ2++/PgcbrEvHlApTZ9GccI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOl+Pd7m6DQCTUATshUDhXjEbKNtUx8aQQ0CVjE/d9w=;
	b=YYUfE9584t9SpFG0g/SpR3bvl+gOjx6qapUViD/xti2Nx/3xWkRdTUxs12MU4MCdUZYRfX
	BaNHrl+nh7BJNxlu8rLCXWBelPHu0luROQutEV9KBK6vfiHiXoTaAbsH/FdspiVGF9xiAL
	E7yLfLbwn8x3wI2x2uRLTqNG17eczEQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-qEf_VCCeNSiNwGpLCe9Fmw-1; Thu, 21 Aug 2025 16:07:22 -0400
X-MC-Unique: qEf_VCCeNSiNwGpLCe9Fmw-1
X-Mimecast-MFC-AGG-ID: qEf_VCCeNSiNwGpLCe9Fmw_1755806842
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0045a0so8433955e9.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806842; x=1756411642;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aOl+Pd7m6DQCTUATshUDhXjEbKNtUx8aQQ0CVjE/d9w=;
        b=VLMCrpVVo438vbsiea2fDkTQyokhKtJt83skXydwitfPHhvDBsLkVR5tmnnbcjL9YE
         CkZrXn+WhSilAxoSKDB6ZmU96BPuQOujFB1d5cF7Wv2kIrM0fuW2TEy1e85qs/ujxcoo
         I7oae5ECMMYhlsY5oNm2yAqxlF3/QdN4uoRWHhWKWRpxp8xQpOpj1MeJ7OLk+C1M71xW
         CD2qrnzlNjE0imotwuMNY//N5gW4LlCAa2oyvcWNaaeO/Iqh9W2pQRQRqBPfpMAGXjjs
         0mdgTT7rhJSwiKHHtLCy17SI5SoY0oM/rE9i6rSO3d5v3aZ4Nn5M25MkrB2hgHR1EkRt
         S07Q==
X-Forwarded-Encrypted: i=1; AJvYcCVfed/3jdMjcdg/UjBh6N7Ey1ZPrHSYUwZkCDjT2TOg9awW0nwMrrwRwubp7QK/SDVzZV4tJnjsjA==@kvack.org
X-Gm-Message-State: AOJu0YzLXnrRv+i52zCWASpQnRNzuFHD1rwTsptz7/MqDHX77J19NhGA
	RWUZMH+VPXWW6w1PRHCrY8dBzSQsf5W+NWL1XHXKSGpGPbawmAqMscC4z2+tuVxNOZW/0QTw1xW
	RYFhdKfFz9CpcSFgm6IWfNPwGRbvRWoGxi+LbLLhtd692XkiGcCfC
X-Gm-Gg: ASbGncvdZ97CwrCj6b7FqU8bW3MX1yQGhMJhOPOm5gTFThBHlXzwMYC2sP3ghW72xv2
	Q9fInE1FxD4u34ZIpr9nxkeyOllL2xXQqZMhf4ZgbY10WZuTCMmGl6Q1dlZ9yGNLabbrcvg99W9
	VCZOppiimGlIQ2TSwY7hEeYJLkx2DaBW4vH4YO3FaTrBZB1BIg91KtlQZS8dSjobYMPFAlU3zLp
	MZxA5xHHYxDvclMWH9AL+fQvGCR7daBlH15xtqAl1yBZbbad7ipMQgURmTspgqvRx9p1Bzl9y3e
	UcT+YQABfLkDdaJzqtp0DVls10zh/BTCF5krTSUDk3dOKCkGwKaue4uM7w5HGOVLVL4dKDIJdUP
	hdBj21NYm+SO+C5PdJX/W2g==
X-Received: by 2002:a05:600c:1993:b0:456:e39:ec1a with SMTP id 5b1f17b1804b1-45b517ad4a9mr2412565e9.14.1755806841692;
        Thu, 21 Aug 2025 13:07:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHtBnzBdejX2oNj8vG9iZBZKJew+pPrkGWxHzVnhFEnb5RkXIsj+cBFTtJrIXnzr/4lYhSU+w==
X-Received: by 2002:a05:600c:1993:b0:456:e39:ec1a with SMTP id 5b1f17b1804b1-45b517ad4a9mr2412295e9.14.1755806841198;
        Thu, 21 Aug 2025 13:07:21 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50dc00a8sm10960275e9.1.2025.08.21.13.07.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:20 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Shuah Khan <shuah@kernel.org>,
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
Subject: [PATCH RFC 05/35] wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Date: Thu, 21 Aug 2025 22:06:31 +0200
Message-ID: <20250821200701.1329277-6-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3goH40qiTDAIrSpl6r7FEhgslbWuE7nM1WAXSpxE5cs_1755806842
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C4122A0011
X-Stat-Signature: qo3b84m5cgruwziw7p913k6tqa77fz1i
X-Rspam-User: 
X-HE-Tag: 1755806847-517220
X-HE-Meta: U2FsdGVkX18SQgb0hiOIwv8I+nxW9R1EobSiushTCQgpbq6QsZeUlaDALCevFWGovZq0G1K8H2FIk0It9epq75Bz/iPM0l4Z2g/f5v9DFkTE5PEEQzjHOXvw3xIKcaLTgQxiIyR3gRzSzb6W6OenlrcUzA5HbwLWjFFnWUf9FnYJCHP8W7ArOx40iSYnlKJMeDL12/KJ3g9cRxBj+BDSFVtchsEhUn6Hpn870P0+vpEtO5cCBX7/Lw16RA83MbPuc3spHWEzz5XpqBFnMTyiLdIVhJu2+3vajeTGUSasLSmKcWasb24LbqeehGWkQF9HNBM1v+WLhfBoa6Z2la4r4eMz+ZWM43Ao9FVdgVhFDpm2kWtO5S3Zs/TcYmXpMqgINr82zt0P7FsVmS/MtuUEd/VpXOlGdRf4hVTjIjfiHhMrJ1Fcgw3nTyYhJQDDWdbAvfUElpZSoDTwx1mKo806ta1pTBMbZduQobSU0LTErlhoANyMzJ4nQ7mDAkFg3qx/Hd+jn/4e4IMJaXKd9FrDcSxFF97J2bjEoE4w1w58knwyReVodoxYOtIuCZ0pky9+PXcwxJYLhG420hcpKgZYp+MSqU0RiFu5/WSy2lKLZnGDPNynL1TCV1/LSTAjVaUWKc7KhdJX/pTBfq8J0XfdzqD03Nxg91flGgt0R1miVz+vB89LVvqFVJTKjPcM/Vf/Mb3Qs7sLLub7OLgZRaku4Pb/BMfall2H4XoqvFE2YzLwJlKKze1JVWsmQuvBHTDff+EAvPTjK8XJFMLGsd5XIwLnkOsrWAx/IRQAyvNz9PvtoW0E/MAcKMofmjo2InN2l7oEFM09wgyK3KfyNtd9y8aW9HJJvb4fGdDNywFRAzEwrv6El58h2T+kcYgU6s/XnXvrVpbErfgQLNcSeniiOBFCaD3g19te4DvupfvMYTPTOdVwaaf5nihp3oHg52hmC9ZZ3CCuD+6226DP048
 a7HImMzL
 7lXqGhBy9LyO41Ms0en2PVGZXjh2E+Zjd7Y2Tt3n3xOS6frnYZdp+mYkkMftS0ct3sFRgrY10IKmPu8UnXu/gsc+T04eFb1kNqOAjTGrxBsS6+ubgQsF4vEKq4ShE6WQPN5DlA2obgvcKm912KZ2PA6cd70P9Skn8TlSh5AwvvUwv1mlymwOSOLBqxLrGmkiQAj3sHAlNhcVRh8EWnnHEw8aKc0gOmflmgf9es74Kwclm/F9rtI8e3VLSLGPkg5XU8Mqc3Tyneyh5RRNRc68jl+GpcUx1lj6yaLi3FtM5MhrfodYsuB1oCVWiUP1wr8AA+67r7hwyYTJpUTQjXlom8CE7+yKpv7FCYbJYsBvVmQVC0OusUOUIEFVZEWXmbTL4DlMZCpZ43xt8EVIGWmCuoeYl+vzJodL1qpA9qYjTHojix4hCfpTv/a2SOKfKc/FEEsoVC/lS7MNaIuHEDBooGd0LARUDBVVp/UjSVeKYzxvFMn2V+0FbMq2yJCPFh22uok4lqI5Vm2A4wQoB/Jce7HonFz9HsqGEZfkUuag0bubW+6Zh5xhNjDcNNdtS53sve0K16Fwu/0zJaizg6irL+Oc14GI8A1xk+rHes21M4jYBKusJIWnEn9RIvMZqfI74Zn7fOGy/QN6F4m4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer user-selectable (and the default was already "y"), so
let's just drop it.

Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index 0a5381717e9f4..1149289f4b30f 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
 CONFIG_FUTEX=y
 CONFIG_SHMEM=y
 CONFIG_SLUB=y
-CONFIG_SPARSEMEM_VMEMMAP=y
 CONFIG_SMP=y
 CONFIG_SCHED_SMT=y
 CONFIG_SCHED_MC=y
-- 
2.50.1


