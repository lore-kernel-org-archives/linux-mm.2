Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95132CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175748E003C; Thu, 21 Aug 2025 16:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7FDF8E003E; Thu, 21 Aug 2025 16:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B596F8E003B; Thu, 21 Aug 2025 16:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F0C68E003D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:08:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68167160413
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:17 +0000 (UTC)
X-FDA: 83801851434.02.95A706E
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf10.hostedemail.com (Postfix) with ESMTP id CA590C000A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755806894; a=rsa-sha256;
	cv=pass;
	b=O19JXDU8Z7feVkXroVxvWGolZVScXc9fmHakS/DJ0UnMHKQj81tNtyyD8kn1ELBODlWhwM
	lhYDUgZWxjzwiFnX0QEoPOz+oGtsAtgNSr5wGMzdc3uY5bi3JMLbdeneepzwEa9GUFeB3x
	ZcJTRLEAD3HsIpXWA8/laxZz/P3jItQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pq6EMCEhMXNA7HGNe/O1qYHWHhWZrBzRdRZ7YmKumJw=;
	b=2C/rmT5Wys6IiC/XpzLXFrAX339PmnkawLM5bXBY/xDqgzlNZjGexcOOzokdjF4KB6Nx5T
	6bDjyxB5tso4iB3YoGSfWfLk99EVKv88qbwPkmqhLqBJNFYVuDiMu3GiyyGDzmr9PIK1Fx
	YQmdPxRpbozN5uRi5We40Y1JPg+uD1k=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6019750449
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:14 +0000 (UTC)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CAD21172E8
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:14 +0000 (UTC)
X-FDA: 83801851308.28.13F376F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0F42580010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:08:11 +0000 (UTC)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806892; a=rsa-sha256;
	cv=none;
	b=B/4oM8s3IIz5aseySPaa5ZbfKpf4qWItkIlawbyjxMOUEfNh6uDDTUxKFz+YRdylJZYBOu
	zAbUzDBhbjUivhsZUuTFCmj9xST+QIrud+sF23nu/1PaGDUo7GpCxhKfBf/fWC71d+SgNe
	PcjNAm0RZ2g101mGrq1A+QBWZFtjR34=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LAuI4ObQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pq6EMCEhMXNA7HGNe/O1qYHWHhWZrBzRdRZ7YmKumJw=;
	b=36U6E6KwYO0C+8RZEp2SPYHNo2kdzBVfsc2YnBGz0fBjXlZ6lAv1olHvLRt/WKwC1SzW2O
	W7OzjXQiG8XdSnMLGCJLYvwkZo4Wk15EQfulphz+qv4chKSyj81NeMFJnhT5B67j47nDRT
	rnooLfFu3Y0W2goV0zzRTmodHEV9z54=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pq6EMCEhMXNA7HGNe/O1qYHWHhWZrBzRdRZ7YmKumJw=;
	b=LAuI4ObQ8SK/1nK29SQ4IEJeO17n4p53HUvNerNItBLRh4TlQsyAA9PyGpyeoH4NcTxHAC
	K9wlfm/6fKZWSTr5BDOHiWmzKPrxGtCJGsVIzgrSK99KJpkRgbq1zSw17F/AJhaUnXB3gq
	wsmylcATFHCNgNF9PJ5A09LoNOxU+2g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-Tpct2DOKO9iGQniuFH5uug-1; Thu, 21 Aug 2025 16:08:10 -0400
X-MC-Unique: Tpct2DOKO9iGQniuFH5uug-1
X-Mimecast-MFC-AGG-ID: Tpct2DOKO9iGQniuFH5uug_1755806889
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9e4f039ecso759582f8f.2
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:08:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806889; x=1756411689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pq6EMCEhMXNA7HGNe/O1qYHWHhWZrBzRdRZ7YmKumJw=;
        b=YO/kR0dmLBIi3gnNFW3Va4w7yO6Kc7rjUEpDotJWRjIrJl+Oz5nMZ18rwEbs5+9my0
         n1rAcuqt184sRQlNLNPolasMY9tIyIoCF+WYHxfrLw85Dpou0ZKMAzymQnC9aPknmm+W
         tRUuLRbIPG7/srx479VAhc8UUugyMA0o7FgXZQNsxS9+ItSZ76BzQEXMrNvslD0LfP/h
         BIfqgTdv3rqNdJHAsx1AtB5hWYNmeFWvcrPwSELg279e4uwOBqihQY5+liKHDzShbp8N
         VcGVAEQMIExwnkN6WFjQSz04stxsoNWPgcdRYYE0s2zAnJREDuEr+UzpZgdF2SoMsor2
         ZEYA==
X-Forwarded-Encrypted: i=1; AJvYcCVqp8+jgs3AkzglHy6TcixCPNTUw2jdREhNfRdMeFDIrVa8F3CEXYnw1I3IiEq/a09W8ZFPzi8FFw==@kvack.org
X-Gm-Message-State: AOJu0YzJiQ1+JpPrY+0EBwAJh8XYzJOlUHPc2ctf5/ag3RsKnqZTeEgH
	FjgQckcQSyRRgx06w5PJQZ1/aG9kzL43TK0Uld/MP2CkMCD9qJb2dSAd1ulZGLEf/daQENK4BPj
	/02NO3nHUGb9Np7fbHUEIAfttJ2hPUL2yC+XX6JkY2R3YBPnQNybY
X-Gm-Gg: ASbGncuT6bo6kgBmnRAQDHmR3Hxh4PdMsCWVwMvWp6C2bEtShEfntIqBbNyP0F5ayuy
	xdXKlnvHXJgpDZNp40NGAr4wSGCnRKIADggm0YiIy6QmhgjXAeODmD1h9P0iJ6SNce/F9c7k3pA
	psBNAE9j71YXhrVhRopHpHNRrlZIDPJtkOQfCJ/oXa4Bqisd8T+Zah8rFstQc82/Nd1zm0e6HbM
	Qj1Zry0HEPOwjvKSYLG6YP4q+2R4ZsAdBgzxXJj6PpOunQmeepN4qPnIG3RacJqej7Sj/nRJ3oz
	GruQz9GnspTdOKPXaOBJ57LYi5CacqE3WfeUm1Gec6CfB4MC38JUHtNs+k225POTwMZMeAifQrV
	plhkUtSfnZG2GG3QviDOOdA==
X-Received: by 2002:a05:6000:40c9:b0:3b7:911c:83f with SMTP id ffacd0b85a97d-3c5da83bf5bmr151953f8f.9.1755806888893;
        Thu, 21 Aug 2025 13:08:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGeHEkncn914iQLB6IDJFbFllUgyuseH1VcCPvg+Bdgchh7CcvmYDhAXktPsYS0hqHcr6hQuQ==
X-Received: by 2002:a05:6000:40c9:b0:3b7:911c:83f with SMTP id ffacd0b85a97d-3c5da83bf5bmr151916f8f.9.1755806888456;
        Thu, 21 Aug 2025 13:08:08 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b4e2790a8sm21120815e9.1.2025.08.21.13.08.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:07 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
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
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC 22/35] dma-remap: drop nth_page() in dma_common_contiguous_remap()
Date: Thu, 21 Aug 2025 22:06:48 +0200
Message-ID: <20250821200701.1329277-23-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uTXfHdOeWBmEwkMbsglMRMxxetkOklVZa1sbK9C0NIw_1755806889
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-HE-Meta: U2FsdGVkX19pdCxd91mg72NEG+vWDmxPMvwwEJBUuTlvc9nNLu0hdockTns1zFPzsDdVIiYATk0VSCaOrC5cK6pQt8ZTLQ7AFPpBxTvs/LIv0P7RHFGYWx6dwxWArtOYFSjUXBpwudhwKHR0yWf1SQ+y9KkLAYYBZzAoPKA9NiUMKMHsioLxwPb30LNvYCCBv5rV6qrXO5YNL0yoF0R616X2lpK8PR5jx6KlkS8HPI5M8YgP2IZiErT0Nl1jgQOd8rgOQNDGZ7qzXP2Ep87og+DHvqYj6vHGPIMz05hkhuq9XJva83VPxzVCmoStkLnF2F8rZ5ZhyhfRDHIi91HfzFFhpWN5qRiPs6nIFocwESvOHeCn8GqtiqcsG8c5+YNb0QgZ78irz2SvbtEeBeRU7PUuAlGGslj3ur8LY0UQeerK4aDrDdLFa9Ao/9V3mOB3UTCKRyQb2vhTO8hrklW1rQygYtgzUOLRmMZLGYh6YaQpfLJQi4v5jKSkbaVAu3mE76yF54p1H6p8F7yZRBsIm+rybKAXvxa4A7GZrqJjgCNfTo3iY3yAqT43NrxrJ5blC3g5+KvacriEIxFsUL3bTrimaR9f+8N0FG87KqkDSwdgsGZAxFQz2lwhhMIIua/fxGZGyK5Ez48be3GlkIHlVnuoAkuZS28wFdOx7U7kPbcMmz5AYBWf/oLQ/4hInp1DaqfIy4DdYJ1I2/0qTYJkFD7zpZQtgUKrXA0YwkfSWlOvZRPFsKOCDa1Il2lYvf3fXO/rjQ6aTs/pi2KqHaCtoCDVCMQxYYyIhd6TTtJrfWr4Eub7JEGUot2+XQptaGWluRvQM81f5IR/IQuj7Tnw1ArchDlUXGPP1NO/EfiLJwfW/Rkv/gzQWkzk/oSDPQwNOJ1aN3A+YLHAjCodl4Zi6l9W7xULHBOyj/I2x/U3ZX0PuaqQfP/UnQXrGcuS6/REAeb+lDLZCkQ1/9eN9Sg
 F8G9YpLU
 U2yXtGyRCM4RF2wDHHvkZjE9GVF4X6IAONaFVdNoVl5kjm9i5DDyp5sNJHKgBMmvK6onoBeJxxu3aCqaIn01TnBwvQwpI7QyHMamoFH06QuyYbgzfcyG0HL+XyVMbP/iymf98UcCEkbR/zdIhyG5gSnvaAorzMckxLQ67IZIO3xN1P/6br4DnyVDDwDYOBw9JLxsl0I9I/ACpexY//MrH3Z6FkMe/j4cAqZcC
X-Rspamd-Queue-Id: CA590C000A
X-Stat-Signature: d3xz48gdm5d4eg3ebrhgymtr8xnocbt7
X-HE-Tag-Orig: 1755806891-764480
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755806894-492222
X-HE-Meta: U2FsdGVkX19fvIIUJ85ebMFin2wylBiiWNERt/bMOwDuoLpEcOAeYs7K8UsnK1Y3KBIWunGy4Q1B6X+6r9bddv46nvJrsdpAJfgGXbWmdDhApU7gxn+4e3DUtHE/mv02MbhJZEn8xZhwrbsE+ikHIDPAZHDzvuIqT5Qs9QpXba4fctK14aiHvNEq00PkH1BquTPdlx77PAXgfSHWx9i3DNvP/ufL8E2hZjY6iJgNI8+I7LhnZnDiJETCLGZIORWIhjahXVO/oZydT3jaIpO9D1uuSGlqLeX7DwLhxgTcNR9Y+BEokVxTK3DTxoQgTjoiSft4tJIyYjGiCG8ZI+9gGIppwvE+r5HKw+WariSXF9E4uzgfg6v+SJAy2LGrRxUcD4X9qAp85TK+BsOZEvIMJJBl7Z2Rru3bC2fqoTP+9gM1gsqzqixFfhh6D9b65bZd7A6yz7k6S6saYeuV3/YCti3Ha2L06SL+VCM7bnGv5p0yOiPk0sAKkSjwUZk9NivwY/F2QTRVX+pApRU5XWKCXRrCDhD0u74Ucf7+bBztkORu8cUCmCwqo0qtAWalRjKAgI46I6zihJnHr+b2aH0juqn3FQVAn8WR8NLDskGXIBpoCE9mRy42rvbNZBAeDDvGRz/p8VxwSSRh6pdL79onVOwsAaxoiKS9zo2HfevxwOJt4EV8rTJbMPFiiE8Vte76PU5lSYz0LHECKQhBzSIzd4cX+11cuofFmY5quHUZNgcgI+YeF6O4BjkDt1SFHEHrSbc6oK2JPvwk1FsqVRlcz4jk50zxreLUq+NlvLcpL7K8c426z7rb9saLzGObGptrEF0uMSxEULjgTXoTRKKB0re0mIfccflOJCIUATzo7Jp9AzvtbwsDqiIcwKKBD5shzf0uoCE1fxyKO7xg+uxZ3iMLQ/tCjefaM5yyGcAw+cQy2DiIKWtqK4cyjfN5rmeyw3c9lwvUwVm0wx/Ne4P
 qByEKY6u
 L/ln3LCxcj+8BJJsqUb3DYVM0qixtaVfRWpFky20K7EFLLRbHvZ7CUp3u4cDqHhBw7CyhGxWeOjpi0r56zW8i0oucv8mUjkKYCC3r8lUCaJYPK5Nv7KdD5pQ35UIsu89my+pmCxaiC+kOJxuvfHuNquXRnLQNwKMvSoZvr1/+wLngbMe+Na/tXuiPOMqBbOGYA/W3caijiMpOImZm4S2HNvr6VprdYyuiPqvd0/3LO2pmvTXIfGhQqgvlQbLVYEcPPa0mzLRXUxjAO/DoC0+N4hQkWtKHwVJQzPiepo6kRUTrn/amzByfHpk0CDsSAkqpI4nRNLmjI6oKVy9IKZqkYk9aX2qIjYMuFTb+7dKlpT4/uKgHSZNVqj8mrRJqBWcEf1EwaVgKZwDUJ4+eu4YIj3OQkxOoKic83CyFupz+dqcWiALTJMVvAfIdt2GBigUoAU83lrsJoxgJ9bV6Fe9mZ5r7ULRCET707noiNiH11sN4qSCcwVhQJrjTh/WvSrkyhzBu1IEK86AlRefEHrG+l6DL2/HsEJ5IPm4F
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dma_common_contiguous_remap() is used to remap an "allocated contiguous
region". Within a single allocation, there is no need to use nth_page()
anymore.

Neither the buddy, nor hugetlb, nor CMA will hand out problematic page
ranges.

Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 kernel/dma/remap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/remap.c b/kernel/dma/remap.c
index 9e2afad1c6152..b7c1c0c92d0c8 100644
--- a/kernel/dma/remap.c
+++ b/kernel/dma/remap.c
@@ -49,7 +49,7 @@ void *dma_common_contiguous_remap(struct page *page, size_t size,
 	if (!pages)
 		return NULL;
 	for (i = 0; i < count; i++)
-		pages[i] = nth_page(page, i);
+		pages[i] = page++;
 	vaddr = vmap(pages, count, VM_DMA_COHERENT, prot);
 	kvfree(pages);
 
-- 
2.50.1



