Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BE9CA0FED
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 20:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F21C6B02EA; Tue, 26 Aug 2025 16:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09BF06B02EB; Tue, 26 Aug 2025 16:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECCC26B02EC; Tue, 26 Aug 2025 16:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBF226B02EA
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:56:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5937C140202
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:31 +0000 (UTC)
X-FDA: 83820116982.05.75DF81D
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8D1674000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z8i1Ku4o;
	spf=pass (imf12.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756241789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iTroVE/kz3b/uNx/5cVLsCA/AYU5896KtbIGYWW644M=;
	b=wReBn3GK8MMyYO8oh9QFu0VI9s84dErFgltFCupW4m+LiPcPmDLSjtJfCNfDLBguaBylPK
	sJJt4glvK4wxa0Kd/j+7x6+vF18dEfjnjwYTZq8OOnJD6hHfpVxfwq2jarpG6mjOI3Fqxh
	Le++gr3hZJAcZI8cD16lbTsCC2kY8W8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z8i1Ku4o;
	spf=pass (imf12.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756241789; a=rsa-sha256;
	cv=none;
	b=EMRJBlLQpF+ymj9mG/BZMSfUIaYGW+kgT94gH7/p7KcVlDz0svgxT/exb8GI8F8PLvtOcm
	ADrcoVRc2YAIH472nb3FGM1q10B1t5R2RVra4YZHLylzprT6x/1RGHXKQ3rbWw/JRpQ9I8
	KlPgxwMYR0bt+6qNTG8+6YLjr0U+kHU=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-771e987b4e6so2107747b3a.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756241788; x=1756846588; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iTroVE/kz3b/uNx/5cVLsCA/AYU5896KtbIGYWW644M=;
        b=Z8i1Ku4o0G2SSZ1G2C9X9DHctm/XKJjjka/w6OMgQ6lKfc1YjPd4wVmI1Ycln+JRmd
         /a1EKW/qkKKerLe6+OcUPA7qFtbSkvInX3tQ+Cm+UAwBmyZ2hGg4zjPBwH0a4SJDd85l
         Yq3nMgeUkXcOawBSz25Fb3Jz8uNwYXwd6+KCXzSjTUJB9dEdQMc9i5HpQ41+nrBAyAOR
         +4kmxApnJAhEX2u4J/O69noHkkDPsYon1p9YvvlKIyP3CsYTyS5WtF6rihxO2DeB1/iB
         W5VlYfTNy+9XgQOU2zk/f43IgRPdAtZBsXDWn7260bAtbSxPhEbTWwqYWKxWnvhJnI51
         o1HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756241788; x=1756846588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iTroVE/kz3b/uNx/5cVLsCA/AYU5896KtbIGYWW644M=;
        b=JH2kg1YxGJdhFd7b4Q6wL6DSztJu6sWaumGagib90rAnUnuq0mQScN+imdkIj5HmtI
         /h2FeDrno9F5PtmWxnaKM9gex50ANCIAbcZAeHN3RsnsC+NV3ZOOMBnD/6HS2ofJyEKt
         2C734BgW5Tg71IBtRx4r3vL3lyPy4YSXqRZ42IiOogx5mUXRcsHXVALKBj6atdCmK4Gd
         qLK+X6o+MI9UQTDQxPbaKQ6uoFxIlbMZx0/+wSaUUkbCo5/PNOhwzOkg94wQCge0b3DW
         RZnE6z6RT53wuraZMBVBpsmJfdWRCzYC7snpxTV23lGejNdDxNUsDB6f//DHqeGXDgmI
         ktuw==
X-Gm-Message-State: AOJu0Ywj1OmR2vVJnas0qgX1SduQldXszH6+sKtFKrX72p9WajVfU/HQ
	mjyYOZjgx5p7qgfOt4w9q6KXea75w+ZzdAf/3dD7VxWO6/odNkQBHgOdPRX9NA==
X-Gm-Gg: ASbGncuSokP+wtas7UxFTqj3XCypVCQAT/CeOEtu7xtqZ1pg1xUOErYoHqcsQOMMFeW
	vBaAlNyg+ejE8BuP+aanuMT4mHN0UvmKmklndMLoP5mtYGkefO/HO2nx5i1Tu0KjxnF6c8u/Bz5
	lqvao8OwaM8CTjBEyfj8FbQPFnmrrgl4xNw1V3pesxfycnrJykMFpZIU5lLgPjPQnbtKySCgLit
	nwD6R0mYt4OO7Y5S7hKZZ2RQ5C+UHn5adtB0u7dh/gnu2hjLtKqYkcg/0Lru30RTUa0hpTAFh57
	h5uR/4PZSvU1AOoV8S6WF9fsnKJesQBPfJVu+Ai3yxsF51BBv1IhIyPW8rNmo578leKRxQ3fTg6
	OLoKb4K4UmVWpqjDqdn1yaqwVKSwMHVR5PbggWgO3E1FUdoNS2j5Ilg==
X-Google-Smtp-Source: AGHT+IEIDsabh4nxrTgNsWeYxrfyRBpfU2Io7iUZO4sYrxXVXXbYXrh0I92hsnx/O4CIM5s+W39Ang==
X-Received: by 2002:a05:6a20:939f:b0:243:78a:8276 with SMTP id adf61e73a8af0-24340e1cafamr22899144637.60.1756241787836;
        Tue, 26 Aug 2025 13:56:27 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-771e814cbccsm5817935b3a.35.2025.08.26.13.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 13:56:27 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Justin Sanders <justin@coraid.com>,
	Jens Axboe <axboe@kernel.dk>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 0/7] Cleanup free_pages() misuse
Date: Tue, 26 Aug 2025 13:56:10 -0700
Message-ID: <20250826205617.1032945-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8tawhc16xko7nqkxympthmspbmaismy4
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D1674000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1756241789-549783
X-HE-Meta: U2FsdGVkX1/GbYhtQHnB0AsPsetbtIPr9RBLwqkOWVhPvHHDYYuBlw9qpoQbn5ivj9Vn4ynSuvMU5pEQ8Mr2Pk5Bf2FeDFlOThlpzWTYx+67ZrG3kNe0GEBOZF+2n92T2jAxUxOFZLkb3hAUKROxio9B50vYsmXnNVyuXGOikxULwZo7vxIbWTXqgO9UMP09/OyjM2uBYT4iIZspD6n5lvtI7vv7AxYOoh/hzMFIxyvR076a6kGqyJY1iT97qLBhnAfIHwlQlfAvEbh4jfRi2CTS+4WDIW3IQFoiPzbX9eDlf7coGv+z3EkQwsYVuGe2Uc1grED8AW61NiyntOAXRoSNE2T1ju09XOsBJGJudbAAMeHOF11bm5G++8iTuu6yArsC/KwBUxiP1AFlT+rHtgnxCMn6MhXvGqMmzCRj9dgXAV+iy5+rq+W5mCRlbzqQzhYr68N2PFgKUiki5df0fTT74o+8OqNz4phF52UWFV4jcCHeE+9Z1HQ3NWV4ahNRoDKnnF5DEBw7A6jqOGPai0qOoqx0V2CuFasqdr1qYc4NZ9p/YKf8vI7NXu0fSkaTJO1DaKt6+JW8syTJ561z/xoRHIiEc/1M7nXc7sPtz8DfsQqqNQwFZq7VqK2TOYcCNqTHKQICHZPrerWcRUBa724s/0JFX8R26qX/OJOv94hzj8PZgunSGdMLajYb4Ds6G0yRLAV6VKr11Jov2tg1mGGrMjAXadfHKoSZdS0npxEBRZuKq+ZqEZ186zACiv9vhv9faEaslqs7ldnn3qnOQjpOZmQuPWFggThStupc8mkNFE6j/Mm1YYPduTj6sE/cbdKWLDaBP0njq6pFpafGAvoFvG7mdnSeEpUxtLR3TJXJfMzchWAqiiGyla/DRlk5Wac+ntndX5Uyjp8wScqpq2SGU+sMAzYECTRfPTa1dRuQqQCBXOKkklH6QoyHsuuGoKNv9Wy9MTAlq+LGDae
 DTkBsFWz
 MRSI+SYt129ovF610k2TwXEFP1czpQ7nXCgiIK/czSrnokNlGrLN+Abn1m9FbUrVxeJkD1nAcSU//DNqxeJih65EKF3Y14plf3g0vCJJMFRYbtqqeL09ERpsIa8K5Af3WG9S1OoX3VNJ53+rXJSqdCyAPYe2/QUOQNGXTG+Y++1tQVwYitsqEhIy0YPLQOcr1GDlXkqOiOFFwid1fk0WKl8hr0RFzjSg3CwkaeIYkTZAf2AC1AXw3OVUvLt9l7FDOaGmwOMaK2qfR1KQ+VrK4SMOhO1WCdph3fBj8ttHn1APqFA9I7lpEjyB5289jCeZQPEmwJT+uhoE7jLXavdLELxZXlwyN2bRMLnCxTNBBM61A9C36KHQGJ5epzlv4NGt72gIr/E8JBRGjam0/oDLV5oRCJvc1Z2zkajBQWP/EdcD4f3SlQA6i5HGeuuDfj93anMGlJN3Am9+o9+eMUPa64WIVTdiIP4VuZkfYC4sUR7us1/eQVBVVWutjr58GgmALruSJHYO6Lsd+xpnQ1VP8dD0ivwsxkgYSI1wU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages() is supposed to be called when we only have a virtual address.
__free_pages() is supposed to be called when we have a page.

There are a number of callers that use page_address() to get a page's
virtual address then call free_pages() on it when they should just call
__free_pages() directly.

Add kernel-docs for free_pages() to help callers better understand which
function they should be calling, and replace the obvious cases of
misuse.

-----------------
Based on mm-new. I intend to have all of these taken through the mm tree.

I've split the patches into separate subsystems to make it easier to
resolve conflicts, but there aren't any functional changes.

v2:
  - Reference __get_free_pages() instead of alloc_pages() in the
  free_pages() kernel-doc
  - Get some Reviewed-by tags
  - cc the subsystem maintainers related to specific patches

Vishal Moola (Oracle) (7):
  mm/page_alloc: Add kernel-docs for free_pages()
  aoe: Stop calling page_address() in free_page()
  x86: Stop calling page_address() in free_pages()
  riscv: Stop calling page_address() in free_pages()
  powerpc: Stop calling page_address() in free_pages()
  arm64: Stop calling page_address() in free_pages()
  virtio_balloon: Stop calling page_address() in free_pages()

 arch/arm64/mm/mmu.c                      | 2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
 arch/riscv/mm/init.c                     | 4 ++--
 arch/x86/mm/init_64.c                    | 2 +-
 arch/x86/platform/efi/memmap.c           | 2 +-
 drivers/block/aoe/aoecmd.c               | 2 +-
 drivers/virtio/virtio_balloon.c          | 3 +--
 mm/page_alloc.c                          | 9 +++++++++
 8 files changed, 17 insertions(+), 9 deletions(-)

-- 
2.51.0


