Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E4CCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 06:47:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 356069000F4; Thu, 14 Aug 2025 02:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30719900088; Thu, 14 Aug 2025 02:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5D69000F4; Thu, 14 Aug 2025 02:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B644900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:47:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD560C0556
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:47:45 +0000 (UTC)
X-FDA: 83774432490.24.85EC7D4
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id E1E0BC0004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:47:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XUEKtGb4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755154064; a=rsa-sha256;
	cv=none;
	b=3J8zvVh1QRhK2Xk1wwA+oJazGEqyAEeqa76AI/AQhVHSSv7xd2Inqao3WFBcxC+rVQXEci
	l+DVI5wmdZQQIDVWQFt9FO3BtJZky6f711gUsRP+sPtJazE0WnrKJvxhDpEsXXEQ62mIWB
	KSGlQJROxqnwYwjBuIIZUDUYJpf6d6A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XUEKtGb4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755154064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Zc/79XSwvseOMROg0iCTGbt49umwlFqoanOatXRXlL8=;
	b=DRacOi/0fMXqvCHjDF9SQrjKhHM5aOVcdkjDyc3J5hp/Xhit8NZ4R4R7wem0MpPBQ+vUlf
	kL8rKLaf91cH64CodhGMXdIzxuMDB7C/AuFJYFDJewXsQ12aL6qd7xJ2enLnUV/gBNmyp5
	Xc3N2LqIu18QhflarXAe59R3zAYoC48=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2445805aa2eso4830415ad.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154063; x=1755758863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zc/79XSwvseOMROg0iCTGbt49umwlFqoanOatXRXlL8=;
        b=XUEKtGb4I9IudiN3rPHBpVMERl0wom0727iksBPUjleAJFB+0fGsOb9mD0mBQrJTbE
         Dvpj4lPLvqM/vfyaXCqxcK4rhRzOE9yGXhwuKaLM0gS/QJMPpXeVVh8MUTOubdsxFBUG
         RiB+yLa4FSE4gJErr2ehzZf/8W4y1T/M+vkIXwxd88Aa9KDGoo7RgywQT8kwCSa+PUkc
         vFsT81hK9Ag/J2VVD3WJhMcdNJn7+KFQpPoTUr/kzUFu70vDGRwVTY2bVFdEaQYubZko
         zvUP45V1S9atjwprIzuRApIeiWyCvyzrSQzy58KTrC15udaKL1y/ULZinUXk60+lAQqm
         OqPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154063; x=1755758863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zc/79XSwvseOMROg0iCTGbt49umwlFqoanOatXRXlL8=;
        b=bjGSYCLDr1UwvTJTRcOOP1JNDW6aOIylFiRbaWqPdPm/AJx92pgrcSq2gD73mKaifn
         0S9eaxDOEj89PmFT9Iwl+/fiL5PyxqNnU+4VHvfqOyF7MA6XWggK8VxPYCBTTs9hZYTr
         lhCNShr1MW1lqt5iNVfxxy9Lb1ILnctqNt2wlsosuGCB2R6gBw6TLQWJ98mYEGTR7Oml
         qmWkMWOuwG7fdh3jpMZJg7roE/INS4e4YyNRqMvOIUXDpWhxADqlQPV7QF8XVGaroZMq
         IrSbSn1qjKUmnyrJGt55GXSj3blSI2D8+kpiref3VlcPnHlry/8wl29lG+47mQuMT2jG
         EK0A==
X-Forwarded-Encrypted: i=1; AJvYcCXBWPMlQoxu9fISHOCkRjKfK3mzAsFKKVp+IJp2IX2FXGk0IpzwNm6u3cMlc4dW210sXxwafcRJZQ==@kvack.org
X-Gm-Message-State: AOJu0YwkdeJe++qa2HMHOq87xSPw3rSogpTUAxXMJja6Yr9ERDFna094
	nl8Xmxdlq9sc3BUp8q27vJlKmPbUbOilceLVnBLYm/mDzMzLjYsK4aogwy6nEr2G0s8=
X-Gm-Gg: ASbGncsfQwpbj79+dEtyNM0C8P4aeHnOJ8w1ZqSk4jkZ8HqgIfy7rVKR+5vYKyaUVu7
	vGFEc8nMKjLK8IQr3b6dBt1lnQOaS5t2R30R2s0Z5bgiJ6mk/o09bVi2HOFkuN3a42dPantMx1B
	P+AQ1V1ApcDHk5TCj28nR2XRvCG+s2DyJooVN5cHD/9cA+0j5wCfX+wnHEIjaWgLAnCv/+PC/Ma
	VByJhuJDpxJfvy93qfCCLh9CDXDIMIY+6SDm2BthSWHyxJJ+ed00JqoZeJJENfWEHReCJKeDSNX
	BLDftXbgdrWFESqUZISgRPQCooWSltNYG7oUAd9290zfvV9BN2NPoi/VKcVwLc8/bO5kQNZlfPv
	vqpNbz4hxlMWLgW5V/vp9WWxlYrXKLxZp5gSNyycML2XRRCvC3Q==
X-Google-Smtp-Source: AGHT+IEb3eJicXsgaNlyzBQ3nJS4mCdWERJyOxedSkNcWUM25YdoSAcIjs1UdYpqo12C3/PgqtNh2g==
X-Received: by 2002:a17:902:ebcb:b0:240:58a7:8938 with SMTP id d9443c01a7336-244584af696mr28229005ad.7.1755154062636;
        Wed, 13 Aug 2025 23:47:42 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.47.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:47:42 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com
Subject: [PATCH v5 0/5] vfio/type1: optimize vfio_pin_pages_remote() and vfio_unpin_pages_remote()
Date: Thu, 14 Aug 2025 14:47:09 +0800
Message-ID: <20250814064714.56485-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E1E0BC0004
X-Stat-Signature: dksmjh9h1yenkj3unt9mqzjrkr6r9hm7
X-HE-Tag: 1755154063-42805
X-HE-Meta: U2FsdGVkX1+VdkRyngstAtUCpzA873YTHPR2lLvk8v+8fQCAgzEB4ltYE4z+dHqc49fEi6yWbhLMzBGZw/v5EK2V2VaVvzJDKOlMZMKlExEinwnAZQnKtoYGyV0YD2U6/ay+NXehmH9DpRQrzdBe3GY45syTh2JifFxtQbdTio18OqGr4O9yR6WTFP451e2n8ntXCqQF2bwKalEnDV9IGgrJ5Mpdmx3Xg87X+gyy9i+XLMT6uMSxtDgGHN1Ockpq5yiGIzKawL4kQWxPK1e36jCjQ1P8GtctNw4PjkGsBXW+jJaZiWL4yT0BXGp/93QyQ1qR7zjGV+CMCmHYoCwr16si8pvt+1EFMMMWX7Zyky2o0tdCCuOtM8bE6rptR/JCAsB2kqouOc5PYUoVHNMNoeP/qkGvZRSkCUIVt63F21vMWK7UDxFuqooVCA1mhYQnXdk/CUtrGcB98mL4vyuLr2qfm+pCVcpK0Pp1QNMQkt1C43H93+/DZNpzw3+83jgX6XRWAAMBMmytmiT8ptfx25l4oQR5I1kI3yoZHlAgN/eAjKrnAoyNlZNr04q51Gb358oBVT6qNELiWW1x857O0Dkac7OC9eOII6qt+0p7faHndWl2yq/lI83v34ND1gv+vVGWJmV9t/6mY7TnTfs9mBsp2yAc6dZ7bWFzo2A8i4MmTGabfPsWt+7t3HoNJEC5x82c52BUKYQlvZ2CCzRljqCpGXXMXVc/2O3wfLzMY5vJE1Ni4flW0nfwfyQRGl2HJfjTrqpmIvU80qbEoOnDOYTClaKHBUOkBFLrxUdMoZYZbRNWbsDcChGv2TTMVPX/gk5jcyYwQMd0eSIxMEYdpABm+mkQl3Y73EDLmUqvKfaYwGcyjdSQHriq3ElapVOwpT7AcBsDTaBzL+OVaLnwwNQjD/f+j7uUAOOjwN7eyUsGgjmmppjcem4NpASmMM6kB+kDJsNgNsC0GMwGHEI
 Ote0/iYw
 dXE2aGJH3WVeeYKTYR9siIitBkA0qVtEmNXeApz7VsH/g7fghIQgvu4yqmDOF65MWAJG9Q8xRVmLM/j8vueE4ngI/Ne/1EJdRhJukNd0btQEH0YI5wclure8mZwXznmwipAJwK0MJY0BchXLOg9oGophX3yRjC2KTJTzcifK1MwgRmQz/Kx6DacM83AM5qj4EkLCPia1DgO/9X6o7c1CjjaUMFJhKrtbOj1MjE1Ebh5DkXtlBATpmBOZirvJvOztXUPhUY7oQfUpygzGjbb3d9xaoVezqLMxq4Zgya10obcqPsH1mxltUfkioJFu74I8lOARZEeY0LWwxxguOnUpwqgYll2CDwLqtURj6fod7sn4EBp494T1zkyNWyep3IjsKMIIhA53KadIKfkwxviiEAI8F2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

This patchset is an integration of the two previous patchsets[1][2].

When vfio_pin_pages_remote() is called with a range of addresses that
includes large folios, the function currently performs individual
statistics counting operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of pages.

The function vfio_unpin_pages_remote() has a similar issue, where executing
put_pfn() for each pfn brings considerable consumption.

This patchset primarily optimizes the performance of the relevant functions
by batching the less efficient operations mentioned before.

The first two patch optimizes the performance of the function
vfio_pin_pages_remote(), while the remaining patches optimize the
performance of the function vfio_unpin_pages_remote().

The performance test results, based on v6.16, for completing the 16G
VFIO MAP/UNMAP DMA, obtained through unit test[3] with slight
modifications[4], are as follows.

Base(6.16):
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.049 s (328.5 GB/s)
VFIO UNMAP DMA in 0.141 s (113.7 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.268 s (59.6 GB/s)
VFIO UNMAP DMA in 0.307 s (52.2 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.051 s (310.9 GB/s)
VFIO UNMAP DMA in 0.135 s (118.6 GB/s)

With this patchset:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO MAP DMA in 0.025 s (633.1 GB/s)
VFIO UNMAP DMA in 0.044 s (363.2 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO MAP DMA in 0.249 s (64.2 GB/s)
VFIO UNMAP DMA in 0.289 s (55.3 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO MAP DMA in 0.030 s (533.2 GB/s)
VFIO UNMAP DMA in 0.044 s (361.3 GB/s)

For large folio, we achieve an over 40% performance improvement for VFIO
MAP DMA and an over 67% performance improvement for VFIO DMA UNMAP. For
small folios, the performance test results show a slight improvement with
the performance before optimization.

[1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
[2]: https://lore.kernel.org/all/20250620032344.13382-1-lizhe.67@bytedance.com/#t
[3]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
[4]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/

Li Zhe (5):
  mm: introduce num_pages_contiguous()
  vfio/type1: optimize vfio_pin_pages_remote()
  vfio/type1: batch vfio_find_vpfn() in function
    vfio_unpin_pages_remote()
  vfio/type1: introduce a new member has_rsvd for struct vfio_dma
  vfio/type1: optimize vfio_unpin_pages_remote()

 drivers/vfio/vfio_iommu_type1.c | 112 ++++++++++++++++++++++++++------
 include/linux/mm.h              |   7 +-
 include/linux/mm_inline.h       |  35 ++++++++++
 3 files changed, 132 insertions(+), 22 deletions(-)

---
Changelogs:

v4->v5:
- Update the performance test results based on v6.16.
- Re-implement num_pages_contiguous() without relying on nth_page(),
  and relocate it into mm_inline.h.
- Merge the fixup patch into the original patch (patch #2).

v3->v4:
- Fix an indentation issue in patch #2.

v2->v3:
- Add a "Suggested-by" and a "Reviewed-by" tag.
- Address the compilation errors introduced by patch #1.
- Resolved several variable type issues.
- Add clarification for function num_pages_contiguous().

v1->v2:
- Update the performance test results.
- The function num_pages_contiguous() is extracted and placed in a
  separate commit.
- The phrase 'for large folio' has been removed from the patchset title.

v4: https://lore.kernel.org/all/20250710085355.54208-1-lizhe.67@bytedance.com/
v3: https://lore.kernel.org/all/20250707064950.72048-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20250704062602.33500-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20250630072518.31846-1-lizhe.67@bytedance.com/
-- 
2.20.1


