Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42EDACA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429EB8E0023; Thu, 21 Aug 2025 16:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4019F6B011A; Thu, 21 Aug 2025 16:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C97A8E0023; Thu, 21 Aug 2025 16:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11BA26B0119
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:07:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 902C1C0593
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:12 +0000 (UTC)
X-FDA: 83801848704.20.900CB6D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3E37540012
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:07:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bcV9eXYU;
	spf=pass (imf11.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755806830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LLdMjSHtv+zm1bY5U2c0p8D/d+U3cemLYeHBKaj7voE=;
	b=VH7HSzaH84Rf6gnBPPlwZgzY7N1fhl9l2z72AklqWJAdrs00pC+C49IVNgQwbpWDC8t+3l
	Alr42uVXc+9CA0OpkCxookze8DOpHgv0hzexOk/4hTjKTqrEbSSljKa1nUVR5KdLECXbQB
	uuZdPmV2zdNE0P0ExpSeXD8/cF2NPtU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bcV9eXYU;
	spf=pass (imf11.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755806830; a=rsa-sha256;
	cv=none;
	b=eZUXjoQX4fO1yIPPNQJjq21jrGTJRRmAmzkiKdXu0N6HroVc/XN8PG/fJcxpn/4lmRStuq
	kAZ1rdto2Z3r9rIZF/89Q4FuOHy0v8ZUguqSz8yFO8szvWvt/3adkd5Hn5a5A76hUZJgoB
	CrpBDO/6F1amdvqoo3CtYzNNDtKp2yQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LLdMjSHtv+zm1bY5U2c0p8D/d+U3cemLYeHBKaj7voE=;
	b=bcV9eXYUtzqH9TJjEoGbgWflV39yHV5sjxeWlsL1sRxxE21UtI6cY6m1+ary+5T/UflcBu
	tGhCW0wxBfHSx0tOalnL7sDJOshCvkszInHj4Jy8V0H9/tTyOLoaqUR2/54Fqk6bj4WPqG
	i5qaKWXiYKVv1inyOHNo/dpSfU8uSsc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-qW0lsPOmN8GHWQGKpYZCow-1; Thu, 21 Aug 2025 16:07:07 -0400
X-MC-Unique: qW0lsPOmN8GHWQGKpYZCow-1
X-Mimecast-MFC-AGG-ID: qW0lsPOmN8GHWQGKpYZCow_1755806827
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b51411839so818935e9.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806826; x=1756411626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LLdMjSHtv+zm1bY5U2c0p8D/d+U3cemLYeHBKaj7voE=;
        b=h7+SvkB+hjN/EyrdEQRc47GYesOKQdgD+LTsPhO3JXnzlUulDP5AAqF7j+mmx0oR1K
         6NlgOAKHY40G5I741XiTo/f6GBmy+GBHyGvPN6p6d9yWKSIMlyLtEiWLfgjqDqxe9Px+
         /6rU8r+hlU/ogNvDf9pRkOtDsPaKNdNJ5nD5wkgQzNdpHHZh6cgn43ccwuodBP24lQAP
         O3QfWMXw0NZuqVoV5tgXoh3wQ9j6KruTGnsKzejmi01LJmd2bw3YZOL+SrpShML0UTFN
         4hPpYdbyA7ZTPgKxT4+s4/WKbiCLnq97adrqfzThSTcbqNXWvbe7jOMODLRg1eYQ49Fv
         8+gg==
X-Forwarded-Encrypted: i=1; AJvYcCVWmMNXRTi/9clUbyDUSLIez7ja0PjFC851X2+RTf2pSAgO6VpkCSyYuAPUJ6qd+/COYAS5cy77Mw==@kvack.org
X-Gm-Message-State: AOJu0Yy0ukvxXyb2QpaD91UnIf6BP3j+Eb/w6ChiNIxMI/rofFDOSmay
	p+V1KDbBlBcIVua3nrWaTog6Gi4PnUb9nKnPl+Ch+qOrJQ+BWCf9XP7eXXjrqBr/ROHWoD89hzE
	xBZaRShpcZ8NGIk2c5zhlz8rXEPDx7SbvyaEvO4ldN2PQZ48wTWTa
X-Gm-Gg: ASbGncu6l3PnRSIyySJdMoRLv7mESNhF7lwvDHqJgWoFY7jpFA5DxHCg7HI9pOZn6LI
	Wh/DtOdF/0JkSS40lzKrUd0WG2UZ/Q7WGEq5/LE53scjDGVsQKDJSkbMJ5LvibPbGLVoSCY9Wj+
	ED6JwlXLur8xWI0afX+PQX1WaPke9uecYt9P1Xk2Mm5a7pbQqp9EBTrrFLTgX8vSh/jlXDr2GXM
	2PfIYWVYG5Z5mD5/qOgOkqUUPJOrttuD1o9u9tdZSYiN3llq9ijaD4L25KTCZMI/htnMBzPNPRn
	VM1ALf7fXjSO0dQ5iWjvWDrt5hgZAzagsOikbEtTiF0ARai+/5SMjgV9Ernu7qvuDtuFMPOkEMs
	MgCcpYxf3PmDj/SlDC3hVBA==
X-Received: by 2002:a05:600c:4506:b0:456:1bae:5470 with SMTP id 5b1f17b1804b1-45b5179b6camr3191425e9.8.1755806826500;
        Thu, 21 Aug 2025 13:07:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7XEacdneicK9OezeDu7E6BzvwjamEpx7+RbUEh0t7qSo20kryXdXhBwYQdhu2/m95zw+e6A==
X-Received: by 2002:a05:600c:4506:b0:456:1bae:5470 with SMTP id 5b1f17b1804b1-45b5179b6camr3190665e9.8.1755806825859;
        Thu, 21 Aug 2025 13:07:05 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c077788df7sm12764142f8f.48.2025.08.21.13.07.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:05 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-mmc@vger.kernel.org,
	linux-arm-kernel@axis.com,
	linux-scsi@vger.kernel.org,
	kvm@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-mm@kvack.org,
	io-uring@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	wireguard@lists.zx2c4.com,
	netdev@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alex Dubov <oakad@yahoo.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>,
	Brett Creeley <brett.creeley@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Damien Le Moal <dlemoal@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Airlie <airlied@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Doug Gilbert <dgilbert@interlog.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jesper Nilsson <jesper.nilsson@axis.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Lars Persson <lars.persson@axis.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Shuah Khan <shuah@kernel.org>,
	Simona Vetter <simona@ffwll.ch>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Vasily Gorbik <gor@linux.ibm.com>,
	WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>,
	Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH RFC 00/35] mm: remove nth_page()
Date: Thu, 21 Aug 2025 22:06:26 +0200
Message-ID: <20250821200701.1329277-1-david@redhat.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q-dybh1kvxqyipUI48L6yXpjG4vCnhwSZjdkDHc7BfQ_1755806827
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: wsj6nrd5kfwbex3woaj1q4kdef1u5d47
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E37540012
X-Rspamd-Server: rspam05
X-HE-Tag: 1755806830-771150
X-HE-Meta: U2FsdGVkX18lgIr1kUEx9Sb3qeo3+Sd9piHZv65GjfcM7p66yrCR1EHCFGYO72FSaYrMPjuNN1o3yCIquSjA2loT72T5vJvLlUxT1FaohZffmLmff9FPfWE7vhIl6ujkT4hURNPhOcWESScY0fhpij3ICtGt27mgdFt9Ulm9HQI65ZtHZyYrDznX7SSYdINeCpgQc5LFc+CTwDehl12MAqvNiENX2gMpbcPGAOLsLRJiw+1SOJOOTmu4MgHs5vI8MX/YRq2n5NUyvVbg9CuLXpnUEtWiVvIErmUUYbEfmlt7M0Hf+rFxy1Mf6468h0Vrb8AbI8b3kFJi+5R3qyWmXamOJ6rUHLZ1oUgWaTeZTp/4GdS/lNJzIxecWn+HCdi64HUmWXBb2DemYj3F6UDMhIgPCAtR96E+6MrcISBh7IIVs0ET4hMn8tyKOB/AfIiKbkhiwtLZJocMCGakNauzktfhCZTJZkFtKpZnwctoIVHTRcheEUVa3Ri4SbZSE+Zh3dH5KRiIE9RIiy6shh+9385KL5cyewQc0yaHt/PMy7QiSLZBe6dVoJsETS4f5rO4lfz/vxUTf0fbn0BA6GIBu3ez+gbznY/eKTVnDgLcl5io6SQQ2TdU+OWC010NOlmkw0IfbAnehHoPMNJzVibvLPlnTKeaq8FqGWGSLrdGg7Ng98gT7aL78j0EKK/42m/xmKyFmx7TmwNz52dwEJLmTtHKcewNrfFmlYWWJFbrn0wbrnN3+8eWEBB6PJKwlT0qPmZizxEW1riMnlXi5LJoxlhPu8FEr2ay7cFc5H3AVHtyN77CdY10+eq6jeL87rzisY5s8qgApO9BbXQ9u3fjrCPzBtmHYtjA0KbIoMKkyG5Hbc4b8CsyzPq8T0m3cjbDczQx6r3hPXDQVVdYBzyQ3OEDeWVeBqRzsOVgBnUhBKmlaCW2ZcUEjW25M0YwEddlc/Fnd6Gcrlsz6+VgDUh
 uaf8Yn9H
 D//psG+CU5EkmCUEaVgm9IcuZfsjeebHCMUzQy1DIOcPX+y8Fxqe3gecEAcA3pGkuada3zy0x3BHrJ686+PI6y9uScCH6SXcAwVaNZ5tzlzzscSDXzdZ2s7NbYdiBduzeQhHsyg6rz11ObDoURSKqb/oihiYurC0dogmKEk1vMd94bDYgYOfOFSi6gx8Aok/H4L2ueqay8edfXd2OWd4Bvrjoa+krxij0ANtW1gM9an9zwakpVaXuhqOVt2oEdUT24HGiDJCUVpZdubYdjMQLgLCOlhBBbS1OAXqI36j9577+o4FQhfRXg6lxAQkTq/6c97drZYLlp7jsJxy494+UDRC1YCwauk8AhhxsUpE1u/sdarCgy5ZHHN9jKMuFQCTY1ZBrVXuwOerU98BxH0o9jr8KPsuf3pmsYYmQhVXGpjYynQ8/dsFrs+ROiPyBkLzIpyktEFck/f4XSnUx4ZbNZK0y3/lvksZNa7Qhm62oQvGtreI5km6LGEtVaZwTplaD4GyT/GYdU8DJMGYxHHJli+xo81gW65hkJ7xKlQxNbzUF2GyzD9/wBIK1sPx3ks6mI86lumzRn82J70EygxKH/lz47eVN+eo9or71PgUP1IwW3GY6RqUkdrVr7PJ+j/A6UYR5U3GoDQbPeAcv3VDTJzze9X2HFQ+xNwpLKlm0iRXMSId1z9MiFuxEzb3fB8ispSvqjRd/+hNsdhGSGDUzIZFrNb6mHbbTkxwpABSDBX5KIzijm9JqvO1/roSFbeOdUFerk2GuPm6BRr+fn4iB/4dau7NrlBbdHFxUSDVUqT5NbLDkMrAs9UHA/N+T/ASm8XsEvVW/JYs/P1Nejf5B/CpR+w7AoN+jCWyJptqZGykB0KAaJ3wuNYq3IPB93Y5aY8m0Nz1u/gx9P5q2VniY18dod6N9nfom0nrsbc24FzR68UJEwDR0J6PMNr+fCmm28JGQD5mQCAuZBx8lumWejR/NKyNG
 o8msi0xD
 1ECbJRXcbY4XsCE8QD8YGX9IcjBWHdWaBpyxEIvtXnUnC9fWf7Xw11bdD73tlraL0ycmnXH40GeK2tgKHDDSR9k55PoSZhrc/Z9NhcUtppywbEX5YKrGlD1HUSnWpnlfbQ3W5ZyLu1C6MP8aleBXmW+0XzWEENWrCEqhZSiwnrn74WuaPy7ugmvkcFRSW1a3ndji/gx3q3pybOvR2EqX7THcLMtY6lMKlH6IqIYHbY2vk2NHcPY1CJUD9eyF7V5sUuAJW0IvRVKrikL57aSs5kkCGzSMi3GUOlgMrutFxY36gytOUw9gArjZgFnkSOcoTNJKxNsO1z4fl2lrLyxTSqZizZegT7+TTWVwHpQlMDvMEF6h7biXScd/t+zF5DeZP24JG5myYKlcLgwJHDNrdmky2ZmbomGt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is based on mm-unstable and was cross-compiled heavily.

I should probably have already dropped the RFC label but I want to hear
first if I ignored some corner case (SG entries?) and I need to do
at least a bit more testing.

I will only CC non-MM folks on the cover letter and the respective patch
to not flood too many inboxes (the lists receive all patches).

---

As discussed recently with Linus, nth_page() is just nasty and we would
like to remove it.

To recap, the reason we currently need nth_page() within a folio is because
on some kernel configs (SPARSEMEM without SPARSEMEM_VMEMMAP), the
memmap is allocated per memory section.

While buddy allocations cannot cross memory section boundaries, hugetlb
and dax folios can.

So crossing a memory section means that "page++" could do the wrong thing.
Instead, nth_page() on these problematic configs always goes from
page->pfn, to the go from (++pfn)->page, which is rather nasty.

Likely, many people have no idea when nth_page() is required and when
it might be dropped.

We refer to such problematic PFN ranges and "non-contiguous pages".
If we only deal with "contiguous pages", there is not need for nth_page().

Besides that "obvious" folio case, we might end up using nth_page()
within CMA allocations (again, could span memory sections), and in
one corner case (kfence) when processing memblock allocations (again,
could span memory sections).

So let's handle all that, add sanity checks, and remove nth_page().

Patch #1 -> #5   : stop making SPARSEMEM_VMEMMAP user-selectable + cleanups
Patch #6 -> #12  : disallow folios to have non-contiguous pages
Patch #13 -> #20 : remove nth_page() usage within folios
Patch #21        : disallow CMA allocations of non-contiguous pages
Patch #22 -> #31 : sanity+check + remove nth_page() usage within SG entry
Patch #32        : sanity-check + remove nth_page() usage in
                   unpin_user_page_range_dirty_lock()
Patch #33        : remove nth_page() in kfence
Patch #34        : adjust stale comment regarding nth_page
Patch #35        : mm: remove nth_page()

A lot of this is inspired from the discussion at [1] between Linus, Jason
and me, so cudos to them.

[1] https://lore.kernel.org/all/CAHk-=wiCYfNp4AJLBORU-c7ZyRBUp66W2-Et6cdQ4REx-GyQ_A@mail.gmail.com/T/#u

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: x86@kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mips@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-ide@vger.kernel.org
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-arm-kernel@axis.com
Cc: linux-scsi@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux.dev
Cc: linux-mm@kvack.org
Cc: io-uring@vger.kernel.org
Cc: iommu@lists.linux.dev
Cc: kasan-dev@googlegroups.com
Cc: wireguard@lists.zx2c4.com
Cc: netdev@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-riscv@lists.infradead.org

David Hildenbrand (35):
  mm: stop making SPARSEMEM_VMEMMAP user-selectable
  arm64: Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
  s390/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
  x86/Kconfig: drop superfluous "select SPARSEMEM_VMEMMAP"
  wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y from qemu
    kernel config
  mm/page_alloc: reject unreasonable folio/compound page sizes in
    alloc_contig_range_noprof()
  mm/memremap: reject unreasonable folio/compound page sizes in
    memremap_pages()
  mm/hugetlb: check for unreasonable folio sizes when registering hstate
  mm/mm_init: make memmap_init_compound() look more like
    prep_compound_page()
  mm/hugetlb: cleanup hugetlb_folio_init_tail_vmemmap()
  mm: sanity-check maximum folio size in folio_set_order()
  mm: limit folio/compound page sizes in problematic kernel configs
  mm: simplify folio_page() and folio_page_idx()
  mm/mm/percpu-km: drop nth_page() usage within single allocation
  fs: hugetlbfs: remove nth_page() usage within folio in
    adjust_range_hwpoison()
  mm/pagewalk: drop nth_page() usage within folio in folio_walk_start()
  mm/gup: drop nth_page() usage within folio when recording subpages
  io_uring/zcrx: remove "struct io_copy_cache" and one nth_page() usage
  io_uring/zcrx: remove nth_page() usage within folio
  mips: mm: convert __flush_dcache_pages() to
    __flush_dcache_folio_pages()
  mm/cma: refuse handing out non-contiguous page ranges
  dma-remap: drop nth_page() in dma_common_contiguous_remap()
  scatterlist: disallow non-contigous page ranges in a single SG entry
  ata: libata-eh: drop nth_page() usage within SG entry
  drm/i915/gem: drop nth_page() usage within SG entry
  mspro_block: drop nth_page() usage within SG entry
  memstick: drop nth_page() usage within SG entry
  mmc: drop nth_page() usage within SG entry
  scsi: core: drop nth_page() usage within SG entry
  vfio/pci: drop nth_page() usage within SG entry
  crypto: remove nth_page() usage within SG entry
  mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
  kfence: drop nth_page() usage
  block: update comment of "struct bio_vec" regarding nth_page()
  mm: remove nth_page()

 arch/arm64/Kconfig                            |  1 -
 arch/mips/include/asm/cacheflush.h            | 11 +++--
 arch/mips/mm/cache.c                          |  8 ++--
 arch/s390/Kconfig                             |  1 -
 arch/x86/Kconfig                              |  1 -
 crypto/ahash.c                                |  4 +-
 crypto/scompress.c                            |  8 ++--
 drivers/ata/libata-sff.c                      |  6 +--
 drivers/gpu/drm/i915/gem/i915_gem_pages.c     |  2 +-
 drivers/memstick/core/mspro_block.c           |  3 +-
 drivers/memstick/host/jmb38x_ms.c             |  3 +-
 drivers/memstick/host/tifm_ms.c               |  3 +-
 drivers/mmc/host/tifm_sd.c                    |  4 +-
 drivers/mmc/host/usdhi6rol0.c                 |  4 +-
 drivers/scsi/scsi_lib.c                       |  3 +-
 drivers/scsi/sg.c                             |  3 +-
 drivers/vfio/pci/pds/lm.c                     |  3 +-
 drivers/vfio/pci/virtio/migrate.c             |  3 +-
 fs/hugetlbfs/inode.c                          | 25 ++++------
 include/crypto/scatterwalk.h                  |  4 +-
 include/linux/bvec.h                          |  7 +--
 include/linux/mm.h                            | 48 +++++++++++++++----
 include/linux/page-flags.h                    |  5 +-
 include/linux/scatterlist.h                   |  4 +-
 io_uring/zcrx.c                               | 34 ++++---------
 kernel/dma/remap.c                            |  2 +-
 mm/Kconfig                                    |  3 +-
 mm/cma.c                                      | 36 +++++++++-----
 mm/gup.c                                      | 13 +++--
 mm/hugetlb.c                                  | 23 ++++-----
 mm/internal.h                                 |  1 +
 mm/kfence/core.c                              | 17 ++++---
 mm/memremap.c                                 |  3 ++
 mm/mm_init.c                                  | 13 ++---
 mm/page_alloc.c                               |  5 +-
 mm/pagewalk.c                                 |  2 +-
 mm/percpu-km.c                                |  2 +-
 mm/util.c                                     | 33 +++++++++++++
 tools/testing/scatterlist/linux/mm.h          |  1 -
 .../selftests/wireguard/qemu/kernel.config    |  1 -
 40 files changed, 203 insertions(+), 150 deletions(-)


base-commit: c0e3b3f33ba7b767368de4afabaf7c1ddfdc3872
-- 
2.50.1


