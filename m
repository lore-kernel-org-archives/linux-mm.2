Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34A7BCCA472
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 310C58E0018; Tue,  7 Oct 2025 08:20:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273FE8E0005; Tue,  7 Oct 2025 08:20:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076FC8E0018; Tue,  7 Oct 2025 08:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1CE48E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:20:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB1AA1A014C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:53 +0000 (UTC)
X-FDA: 83971227186.10.DBDCF36
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id AF94E100002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CSoEGR2x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLik2R41JKKg66R9u/7D437C5tFPGxIDYan0Bcp5bSc=;
	b=Ev8thin3hVvNvgRFbEptp+b+YNmpMVLIC0/MJ+mxTFbHTWHQrREW1j4qVgUFe0GjBDZewp
	qUqa3aG1K8NdhHSexo2n86nixo1GYY0ZCtq5yTE4voNeKEwKMeKHrbxVgvcF5h7mjYFGpw
	eYzs+nndXCFekL3pKYyT+mcTvcth4Cs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CSoEGR2x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839651; a=rsa-sha256;
	cv=none;
	b=qh56+moO05iD1FmXOayPsGxQiXQ2bG9c8skzvgvRQpZhDno8oFyWhfuOGIsoD7iA/vUbD2
	ZrObHZVnGmW7BwCVNgMEx9N+I29rLEOXKtj+taoT3OVgOUW0JMmmDwfa4RmRBY7mPpn97m
	pnujy9kjmlKZOb13VjzggyCiNJXA+fg=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-57e36125e8aso5708242e87.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759839650; x=1760444450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oLik2R41JKKg66R9u/7D437C5tFPGxIDYan0Bcp5bSc=;
        b=CSoEGR2xafF5WnIIvBHCf3Pc7qikGwtFNi7hjv8BSkluti9BW5ysqG7c5b5QLpfXXK
         5LKpvD2kslcq7TFQd8yEEDR0CcdqYAqTBaCWysKpLzHsUuubPxDQIq+VXGmXuYDXmKLd
         7i1TgOJJLcOU+UmAH/yHPMygp/5xIK242xDvqPBbm61XI0sVZhSo2D7TFLOqmDtBTn6n
         gw6i1MrZXcjr8pxh/ewEgnoG+gWkRs2oSiS9nggqNHahE8l2g1SNmexXz7+eK8kd0u/d
         ZoCluuR0J1Z8Bw9WcF492vusADL3ERy1kkiBOk+R7UDLi5Fdcxl619G0ekJtQApHZBDl
         JBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759839650; x=1760444450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oLik2R41JKKg66R9u/7D437C5tFPGxIDYan0Bcp5bSc=;
        b=HUcMRlZLGhmdzVWooi6DCNL8uwfJ/J40E1bHKRxZsz2QQ3PJWwqg2NkmUsoEkQDom0
         kDfSbJ2T/8NreecRg6TqdEbX+IhhWw03EBxpSTD/8VJifDUO43eWWXY4/7pYSWjElSjr
         WvfvRuaslWZJPNcaliOxWNHGTOYZizcjEKAiPTLdzxU4flMi3g0VWhWNV+gIScNMozh1
         XblTax6qySW4a01TGN+4SMMjFUmWCZeag5L4eRNnRVwkv0W3KIyGGDtIjASp5fTWMz1f
         fyWUyEPejIs+NzW0eMPPdA+oPFpue+XtkQOleoaDT/Fk0cm9lMWk9vUyO7cKC/VPsQST
         I2TQ==
X-Gm-Message-State: AOJu0YyROaf8TFi8mebfAjsEjubVn6/UP/UvanAWweZ80KckyuE2ifub
	Gg/i8WV0k89YnauQ8c42PgdbmhZjq9VTlz2JDfYxMma2ANxmu4UwFMP01m7e8ChU
X-Gm-Gg: ASbGnctwaN3JNMVD8c0RgoBPILAUPKzNBSAj+JOlUDLuMkd0ENN/b1Acc/u5EzvAXwA
	cSYfiCLr4MM6+62OtxpKoOlV2mTuDqw+bVB7KvLSryw19ObILl34cw+JX6X3t1HL6APnRTGjVOD
	iRi8eUZFvss4uGmjkNpySflKxJPh7irzwSrgUiJivXu9xETH/mnMZRrFwXibVgjIiIV031FIE93
	l5XehN5qjSMOymR/Tm+lodnYNWI1Iov2MBWONh+Qak/dBECf+3cfiOF+NC1xjop5LyWBYgqY0y9
	7v4/821J6wbxDFe8cec0c+47PVFkeohoZ2QBZilLAoEnPp+4GQpJ0PND8b6UnrbN4UeFzBBipVq
	56GSUhvrjL9pCTmwWkVeJK2sExzFauWEu9K4VyNfl
X-Google-Smtp-Source: AGHT+IHa1fO8cLLeRNsClbO4Do0jlv/6LzDieia1Qj8zuoJTvM9U/A0btWcUHfi7JFPOE+OrJ7f71g==
X-Received: by 2002:a05:6512:3a92:b0:586:2e4b:22c5 with SMTP id 2adb3069b0e04-58cbbfc331dmr4623770e87.56.1759839649666;
        Tue, 07 Oct 2025 05:20:49 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141151sm6061947e87.59.2025.10.07.05.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 05:20:48 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v4 09/10] mm/vmalloc: Update __vmalloc_node_range() documentation
Date: Tue,  7 Oct 2025 14:20:34 +0200
Message-ID: <20251007122035.56347-10-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007122035.56347-1-urezki@gmail.com>
References: <20251007122035.56347-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AF94E100002
X-Rspamd-Server: rspam03
X-Stat-Signature: xc5zjd4tutd461yprfoio4by7b8xwseg
X-HE-Tag: 1759839651-705131
X-HE-Meta: U2FsdGVkX18yscxTlcvFD21jmSOITvQHpfjqbz8hiCKwyuRTzsWm7UoENqU5i2VJ9K0PWiHUJ/9hyO7rCNwcqKMnKrl81rPE/YZh4W/qBUsS68esR7PjbQw/m+Yd6ZPpVAcOZRzIeuK6umRGJl04zaYBnuuANIHu4O5wD1eiyMDAXM8f1CTZwDVKbu35QINjYNJql/rZVVneMuESgA30a1ZSiqaRoDe5kKYy2Zp5CceVWGh/YuQTJ0JfjZZpkoQwt+54gtlK0UZMZrqhZ6NvtIpnb2iTGiOnvs7ZqVIXEQrFZHmOWmPJbpG6Up1lqJpvi02KoC2pBN2UiMo+IBW2Dcw2//Gow1XA/uqk5ep0lrM5NPFeJ8hKXiQVyByO3pUMPdq1opdzN/BdpnJYm6S9GFO87tUHuOGoueWDqvPhZwKzLdxZdmbg5DanBMw0kEoQEQj6sE63BVHJGRD6YH8RU8wvtfDIT0PModzt+cUNdDgmQsShF8U1vkp1iRTJjfNaQB1MHwFXWsJeOgWKdksIqDRkhqJuICe973TZWdctKCI5SqkLH1qDMfgOLYQyoOaNtPdh873XwUyUT3Sfzp4Ns5I3QQ6mBc6YuY22kdx+lHzu31g9POGyYGIcA0MjSq5SLWbpPI2v0W+iVThiVGDaKQtNqWZfkNxlWStDaua/e5Vf6fCjcMxQDcRc97wYp+U0zdy53Jxdb636GgakHlFCTc4pOfR/cuxiVd9WhPNW3fWMRXFcnrCug2Gj+ptjLjBneyuS0dAX4oPAor8LMamMNiDlAMG+ABeSpEH31vJsicaQRtF15WNooLVcKSZOU65UCaUC+DjV1gUSGeSLOoppvVTO6ASDnNwL2O+N8eFQzTxQ/mPTpYe9MAHNFzFRqS+etbSJ9DNI7Tm2RXaQoZv6RSa4pmmTb87Ql/gccopy5mhueM1nwHzqIHYE7Yo2TwEdJ/884HUR7HCzjNqWz/C
 reDrgEjS
 kMImfCXHA05mFRyJEscd0imj/n3XapZXFcLZPncQvu35qy+UO8kAvXMyilZjNHWaRYUWIOgj4NxJEb+fAjiIHITHrU2lg6XdPFHAcUzEIGvoaP4SvlWh7h0UWEBiKt+80Tk63Uf2Sojzvad1jGxgY+Xdimg2XSEIZXycsMOL7RkfuDlBv3kPl1SrCCt1SBd9qTFD5wOllfJlCIZHoCirbtwYactHq3SLf1HeTXf5ZejrGI9oQ+pwbKGRUuNmTWsMIfVKS0ejKQQRaK5v3JWc+CXJi0RHqTgw1k6NYTv9syJNMqAtOxLaHvrlNs7A2F243mfOxwP2cxv6J5oWoCbzOvDHF3QZq5zXbfSq96/OGsP8cK5w3yI+Dbkf7tqjKreDpmhEWssLHAEjInxVmwxvWy+jO1iV9HaDiSP+usLEn5zRv8dQCbgx8x7MQK7mZ1PSeIFO1aZpmRIlhImlvNHsi/lBNbRRyDgbJHVClOcL8QiuDMse8NrtIxSKdK2kvG120Vla9nejVR3SVkNp/o/hl55O3gm5xza9lleDm9+IYr6BB+4D0HdlUHqVG8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmalloc() function now supports non-blocking flags such as
GFP_ATOMIC and GFP_NOWAIT. Update the documentation accordingly.

Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d7e7049e01f8..9a63c91c6150 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3881,19 +3881,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
  * @caller:		  caller's return address
  *
  * Allocate enough pages to cover @size from the page level
- * allocator with @gfp_mask flags. Please note that the full set of gfp
- * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
- * supported.
- * Zone modifiers are not supported. From the reclaim modifiers
- * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
- * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
- * __GFP_RETRY_MAYFAIL are not supported).
+ * allocator with @gfp_mask flags and map them into contiguous
+ * virtual range with protection @prot.
  *
- * __GFP_NOWARN can be used to suppress failures messages.
+ * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
+ * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
+ * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
+ * by __vmalloc().
  *
- * Map them into contiguous kernel virtual space, using a pagetable
- * protection of @prot.
+ * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
+ * and %__GFP_RETRY_MAYFAIL are not supported.
  *
+ * %__GFP_NOWARN can be used to suppress failure messages.
+ *
+ * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
  */
 void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
-- 
2.47.3


