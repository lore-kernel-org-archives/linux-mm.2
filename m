Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4182CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ACCB6B00A8; Tue,  9 Sep 2025 05:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D986B00AA; Tue,  9 Sep 2025 05:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67796B00AB; Tue,  9 Sep 2025 05:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE5356B00A8
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:47:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 76E41C0458
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:47:14 +0000 (UTC)
X-FDA: 83869233588.27.E6239EC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 29D5580003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:47:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yq8oJR+9;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757411232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SKiiv6JCU2xJOp3QwKpH5ri794nlOX8D39yyZK9KigY=;
	b=OsAEcZuzYat69UNFR6Qg+bxrXpQiZcGunJosAyXuirnUgI2IP06o3CVXNWWPLg8xXGk31c
	NYWPkP+EFxzj3hXbyl8ScGlj/UDawJqEVbP0JdWdwu4/NeC0+Y3+Qzp0zw4VYk4tx5zmkQ
	b2cWMdONGecXFIeAxWbHQ6WXodK2+5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757411232; a=rsa-sha256;
	cv=none;
	b=ugTcktfvQzXiKRG780sDhJrJUG05f9LyPN2quNqHVY394zcUZdOkcYqlVX23YkrbDfCR9n
	7gGo/oUxkLwbyCfMvZJr+JFPltpPDoQBfS+d7B4aM63EPg9fWL/QKPqT+ddS2RuGFqnpY0
	A/NLTZ7BrJ78DefZ74O9SZ4Jfz/2pDk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Yq8oJR+9;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757411231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SKiiv6JCU2xJOp3QwKpH5ri794nlOX8D39yyZK9KigY=;
	b=Yq8oJR+9VrtIhMgpn+VVEaCwborHRrDBPeGvl1sZR4MKqSWz9sTlXMGFCPKGq98MKr+32+
	AJzZDaQh98J4FESkPNfJ7EOLwpZmyP7zcbyahPjlAM6WpLtksYBt3fvc1NJLa9SLyHhe/Y
	iy/la22ClG27lRU0H8KtZXMjazv1B1s=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-d2Eo-GkwOUS2Dg2DvDn-qg-1; Tue, 09 Sep 2025 05:47:09 -0400
X-MC-Unique: d2Eo-GkwOUS2Dg2DvDn-qg-1
X-Mimecast-MFC-AGG-ID: d2Eo-GkwOUS2Dg2DvDn-qg_1757411229
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45cb4f23156so29873985e9.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 02:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757411228; x=1758016028;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SKiiv6JCU2xJOp3QwKpH5ri794nlOX8D39yyZK9KigY=;
        b=vOKT7Y0qC+CaNTWPCoGkKIPwKTPJQlgY/Fze+c/OrDQOD4rCsKF2Y79GaUOnJvnoU9
         +nncj4J2YWpNWW/7pxIQMTgooOjX9UiJDGjp3V9VQ4xO9ULpH0iDcRnXQLUzxHVdyR4M
         etKHJrUBpqv2D+QfXZ0azt7EkIn1RjXXk4nz2mDVK22QzEkTzHw6rRhwHiOmJwSm2Nwo
         X1YdjOxhZws7b2kNOLH12me7LUmM6H7iEzgxVjRWnTwuRMrT856SPMyYbDSGZIppE+gg
         AOPVZy8lYPnBxqol3xPY2oFZcuVwpSqcNhp1Xwz0KLriRgGOKvzq9mJ+8D7xy5CIw/4y
         HNow==
X-Forwarded-Encrypted: i=1; AJvYcCXdJRTBq26vQ1/opKjpzP5LHdTZr5CX4NGiNHUWYalto1QNETGJhNqdSgODjWT+9xjyjcqmjSR0og==@kvack.org
X-Gm-Message-State: AOJu0YzApLJrcaFtC0ctb0HLD8iaYMWF+zy30nLWtR9+MR0CGjCzk3Hv
	t2fuKEnzmgGIoDoRkKlSU/w1GLefx/yqVuOpYUvkqa/6wBQstbbj+uDXMyuKQ3AeRTybn9BTxpt
	LQFjSG9+sXxXcM2NBBAVZmNeOlDMdkBNRYdbDw7DUCeFnWUWn33fV
X-Gm-Gg: ASbGncsXQ3fpf21aSsnGvB8Uz5d1xW/FZsPisCzUCO+zI/yn2alrhUs2hVP/sPBsAvd
	n1bPxjas/uah4z+kz8eoS8NM2NEP2QRNFtNt0uGV0NfRo30wHhlbaft19UIZCwp1686h2vqBrGu
	2xZ6r1g4aMKjBi7gj4IyOvhMUYZlxjt3OrnnXndWdNoSmDzLTp5yQznJNH9t9EEyew/xnUipLyi
	+hRVPML+5JQfuKOoF8nKr/VG6ptWcSghRwM9VPiCUe7w7TwTPbkMTQ/tcFGbQeqChNuVAzGQOSw
	xiZQOPMilijrdVDXe0GGSUXbR8K3UbcyWnDcnpz+RS/tSluRqZy2ZPlGk8Drqch7Kb4CMzZcN/Q
	a9gIjlFu4tWs3P0nNAmulrtDvB7b7C09mt8STPumEU3TF3oaLljHOHKHTzDiHGhoxzKw=
X-Received: by 2002:a05:600c:1993:b0:45c:b5eb:b0c6 with SMTP id 5b1f17b1804b1-45ddde80fd3mr102080925e9.5.1757411228582;
        Tue, 09 Sep 2025 02:47:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGI1+DChPACtKX63ACmNUkDbz+brz6ApvDkQYyqmH7m2P3PUb3SzMq80PuogArkKrAlYYqt8w==
X-Received: by 2002:a05:600c:1993:b0:45c:b5eb:b0c6 with SMTP id 5b1f17b1804b1-45ddde80fd3mr102080655e9.5.1757411228082;
        Tue, 09 Sep 2025 02:47:08 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dda202112sm183745345e9.5.2025.09.09.02.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 02:47:07 -0700 (PDT)
Message-ID: <d3c68577-131f-48e0-84be-cb4424e3fa9e@redhat.com>
Date: Tue, 9 Sep 2025 11:47:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master 6034/7427]
 arch/sh/include/asm/atomic-irq.h:69:undefined reference to
 `page_range_contiguous'
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <202509100708.5mJZ2cLm-lkp@intel.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <202509100708.5mJZ2cLm-lkp@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vMqTI_8SbTekFYClLOTVh4847m59n1y-TwsjS-wj0U0_1757411229
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kmychoody3peppe4rzi4tca6m97mhn8j
X-Rspam-User: 
X-Rspamd-Queue-Id: 29D5580003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757411231-391788
X-HE-Meta: U2FsdGVkX1+BQe9uQYK6HnmMXAr/KEJExzdIV9YMAdPut02qXAX7nOOSVsx5yDgSbwJBq+RNiYUaarQsmnAvJZv4P4/ujlbvYu5HHCdzMtQ6yRjLbr9Df9+M9LHhGbJVfqO3wi94AhsZUZ45Soup2Tj8bGsIO1GdtPkgakRmh85RoIRPMfEP0lRLiw57Y7S5gqyyrAKyD0LoW6PGrUR0N06lQ0i0E6oewI6BcpC1UD57WoZUAHuSvmuXiC8GAZtY4fb5GYHdxHqbK2S80EgK5PD3XwYy8BEz3E0+b7v/SBVWqjlg5FBgu2mE1NLttZSwAnFIEq9D96m7R5n+H6I2WmGMrj3oKJl1G4WAI0nZuXf3p9V+mrcCoTCULTq5hzP3a6g4MEwjKctd4xtPt0urh62lMJDCEyEOu2vMX0qlLycdN3GOlYkzO5iPVrox1wAd4Z1RdmV3wyRR9pDr479mXFW/K3HsxGQLMa/jhWF3c/R2+nmCvfXjVkzsNI2WNXqfaMmygS9thfJeHlL0h9w7F968lTAfqETTlcFBLjZ6BgqYvCToao9XJQDXVLV8daLzQFXyoiuIWeNtDjw+pB/K/wZF8bypAmjnHAt6gRhpeDRfGO5BtP3oJR6wqsAtfIZMN6wlVsZ5QvHpnGzptO2oi6NLTsFY4uT7qV+DVhx5AnDxdspyUX+Udd+OJwA82OEutbthXp91monjcBwW5Q9CopnzboPjhJuUEXi/ULWnBcEsUdTx2AjdbYuHLkPCCC2KrE2FpcHojNePUX5fp5X6p/ZZdTzTt9AE6xwMG1reiMf0SRwliugbMWKlnXRFQDz66uT5e3TEMR1kQ6LEBMmafLAc+9n5PVVXWYvlNHcQgjqz1QAG5vob/o24ojPS2YhPvULDs2lVg1f8qy8N5GwX5hv4aEG2v8lUuzEG1jNT4ENa2CkRQd74cM+jhKyvGA2LUkAbOMfV0nnyje6pZpH
 UguS/eVR
 OASg6r3eSNn28N/GlDwZtlg3dO2+EI6qFuJTCNakXDIzOEx/Nl8n8c0XpIC/tpgximnxVRhmyowUyVDGju3oQaT4sO9HKLJhrVt44wwrf1AEn+BHcJOTA8MP0atkW6+M6+QnGTqElKDyozVv63/45u9N85EWFQHGWPcdK+E/DjQP2tfjIawvkHM+t30nV93p9SaZl5Qj9k1Wj4HjJsixwuGywztvNqadIODnKGB/08PSKmsID3zrsDH/ZJQhSD1t0mQK1L2uFFPW4y7WuTqq95fwJkmEtHo4QXjPFAtL/5tNFeBUjKcDj4Y/MFfTnH6NTqAY3+33DaqRQO7qSXrPhk2WM2jZMEeqfuCLZSfpVmCbAwMnz0bGhCQrK31g1+wpOo8YrBL3PyYkiwyUmQY1noVb5cglkk7z0Yo9fO6JK/IY/gT+xlp4XAvUOXlrxEhDPr4jX9ujbKd3sCsHNtolO+r/eXsHNgOcC6ODgF2gvluQb+JL76qVa5DmClgGBdq3W4HBfTB+grSs4SaGLtmqDFRSg+ZSp/1d9IYuB9rwWkyZ44U2Vzu5dh7fPua+uJvALUUAjM9OzduoHfXpY5qPhV9BnSWGhE80K/TWX4+ghbr4/qF0nX8cL5on0n+hFH242hjz2VkS8tPM2UCS3I07PpTxpIGbKeduRsmfCniK4Uylk2eOPDm6cxoGjtXYLJIXn6qhE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 11:31, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   65dd046ef55861190ecde44c6d9fcde54b9fb77d
> commit: 73f5c4c5c6a36a130ccba6809337e42ccf8350fa [6034/7427] mm/gup: drop nth_page() usage in unpin_user_page_range_dirty_lock()
> config: sh-randconfig-r121-20250908 (https://download.01.org/0day-ci/archive/20250910/202509100708.5mJZ2cLm-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 15.1.0
> reproduce: (https://download.01.org/0day-ci/archive/20250910/202509100708.5mJZ2cLm-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509100708.5mJZ2cLm-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>     sh4-linux-ld: crypto/testmgr.o: in function `sg_set_buf':
>     testmgr.c:(.text+0x8fc): undefined reference to `page_range_contiguous'
>     sh4-linux-ld: drivers/usb/core/devio.o: in function `sg_set_buf':
>     devio.c:(.text+0xd54): undefined reference to `page_range_contiguous'
>     sh4-linux-ld: drivers/media/common/videobuf2/videobuf2-dma-contig.o: in function `vb2_dc_dmabuf_ops_attach':
>     videobuf2-dma-contig.c:(.text+0x920): undefined reference to `page_range_contiguous'
>     sh4-linux-ld: net/core/skbuff.o: in function `__skb_to_sgvec':
>     skbuff.c:(.text+0x2180): undefined reference to `page_range_contiguous'
>     sh4-linux-ld: mm/gup.o: in function `unpin_user_page_range_dirty_lock':
>>> arch/sh/include/asm/atomic-irq.h:69:(.text+0xe34): undefined reference to `page_range_contiguous'
>     sh4-linux-ld: fs/ecryptfs/crypto.o:crypto.c:(.text+0x954): more undefined references to `page_range_contiguous' follow
> 

Yes, can reproduce that. The config has CONFIG_SPARSEMEM without VMEMMAP and:

# CONFIG_MMU is not set

I'm surprised that we can have SPARSEMEM with NOMMU. What a time to be alive.

The following seems to fix it:

diff --git a/mm/util.c b/mm/util.c
index 248f877f629b..6c1d64ed0221 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1306,6 +1306,7 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
  {
         return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
  }
+#endif /* CONFIG_MMU */
  
  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
  /**
@@ -1342,4 +1343,3 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
  }
  EXPORT_SYMBOL(page_range_contiguous);
  #endif
-#endif /* CONFIG_MMU */


-- 
Cheers

David / dhildenb


