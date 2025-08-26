Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 102D2CA0FF0
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 20:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7FAC6B02EB; Tue, 26 Aug 2025 16:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37906B02ED; Tue, 26 Aug 2025 16:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7686B02EE; Tue, 26 Aug 2025 16:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B89BE6B02EB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:56:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 806FC8420E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:32 +0000 (UTC)
X-FDA: 83820117024.23.6174928
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id AEE3B180006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KkS9ZRjh;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756241790; a=rsa-sha256;
	cv=none;
	b=ifMtvfFy2jwJan7iEyVWeMH3PlMm4VJTTo9eLBbK4yugeZoPMCsmsE7UWTS/xwXv6uXKtg
	48LFmgAHXA8X+dgQci2J4z3907rUa7uSx4SMriB2KzY80vhbxiCDYrbOYiwyTRrMGfV3YJ
	qQynLqkEc5SJgPaeduJ+rjp7c5fOahU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KkS9ZRjh;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756241790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13eUYaWgF2/Nh4T0vIZSvkzZBvGNF1e6n77XFGF+zTg=;
	b=klcQCVU6I+Ulf7eOYc5pL5bpVqBGZJ17Et0d1U9e/P3VGc/R4gHvRR2lQXSjOoo8fJP+B/
	TnyYWi4yo6/oOObg7+4YfD2tWZq1l7YboBGW6dfq/lEU/fycokKb9qbQhf1F9Qx4vrnx1g
	7GfyHMrgKkkWqGb5jUptCWtTql9/nbo=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77033293ed8so3969071b3a.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756241789; x=1756846589; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13eUYaWgF2/Nh4T0vIZSvkzZBvGNF1e6n77XFGF+zTg=;
        b=KkS9ZRjhrmecd6esDFo2IhQsWH9Rzpwdm7GVZuIHn1QniBmhUntZhu35elbEorvMXM
         l3HKhrsAl0Q1B/UwC83mnAogwXVWxOF3/gG6h8dXUoLOKefGWtJlMnGwrGHlcu2lgi68
         lHUzgdAvGPeD0XNdA2M2I0vp9daHOj3Aw17FAnMv1MHNjV1NPjDgV8SWnxlIGM2dZd5Q
         slqAjP/exwqtbzBXg6Bhq+Ve2F0cgUHfAjRiMv63qM5rMtTDPhGDTeBhlI3BY4B5bVgJ
         //zin/tw0z+vFUOuhuZlOcTMRr8k+47CcZ68xjYe1HCDV6zdGv+l2Lgc80ZWpixJk4Gf
         K47A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756241789; x=1756846589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=13eUYaWgF2/Nh4T0vIZSvkzZBvGNF1e6n77XFGF+zTg=;
        b=VoyNmBLh7QJA4kS6LPi+0LsJwSXlvr7Df4eT3+MOXakdGByCSUb3/hfjFrtc3E8ko+
         rwMm52D1FCwe1WHHlC7VlA8xX5EHTPwvDRBudVTnCUOvcFrxwoJS+qyomg4WKXx+zk9K
         DGZWOejWXgmaEbR0L1kwejHwxDF+lKsApJPgg2Of0v0TBt4PgEfZs4bL5a4CqMLDoR5n
         IeUCufjj+8BOvTPx1NYwgM+MK296by4X8CgLgO+s3/j7nqUxizFYNsZKHWR7pdCLNTaw
         1EiuQ5iNZRqhdxZoFABOWBBH4AaELF1JgLFpnX620eeCEsvemVE5lmGLS90Pf9kwzvLW
         4l8g==
X-Gm-Message-State: AOJu0YwtTzkQFagfGiv5f0z6b+raC43p1DE3dw24OA4UQZ796HtCCMeQ
	NamX3njXaoVJvzyAlt6c65YD4QNPl8ssQTjclpMMHYeiGABMGuQy5NDgf1s89Q==
X-Gm-Gg: ASbGncujTHvjGZbsVhzwPxUx9VcSLkZhZOfCcR9P7eVHe8Ot375XI+SqBsOGs+ux02o
	KmwgXjwMvoDAgOQZ/08VPnXRQ4ybh48PPdlTVHK/nlC26ZNye3v9Gp09aRbBHDyGyc6oeq2kdZ2
	w/GzsDjm/lRDRRkvzlchyYBsGlWAVUrXBCfTt6HhBsvtCK2TpD6sDmTp3alMKwXRtVn3k9QCOP/
	gKb/TcURuvlD33R+jrUz39yRblbkGW4PIsmI5Tq1YheKq2Uex/vp/15OdWjWiH7qyqjjST3dJ2A
	vrMtFfN6edqFLtz4lYAPpt2l7zH6jPZsMYeDZvb+u3533C06SCq5hrrtAKQQ/ZmN5cah9x2k3xa
	KS4KmliDuYq4jQF/5AN562o8+RwiMU0Km04qiaIWVjIJPMUxSph0/jw==
X-Google-Smtp-Source: AGHT+IFhlIB5+rmQM4mUW5f08KcYHWotYT+bmRUhVcM2aNuDqBXEScj2FBR386dOVdHUaSBcALsk5g==
X-Received: by 2002:a05:6a00:13aa:b0:771:edda:1b9c with SMTP id d2e1a72fcca58-771edda1de7mr8650847b3a.14.1756241789054;
        Tue, 26 Aug 2025 13:56:29 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-771e814cbccsm5817935b3a.35.2025.08.26.13.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 13:56:28 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH v2 1/7] mm/page_alloc: Add kernel-docs for free_pages()
Date: Tue, 26 Aug 2025 13:56:11 -0700
Message-ID: <20250826205617.1032945-2-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826205617.1032945-1-vishal.moola@gmail.com>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AEE3B180006
X-Stat-Signature: 5k1u7nmx3e969p41bjtkn7zgco9tbmdm
X-Rspam-User: 
X-HE-Tag: 1756241790-73137
X-HE-Meta: U2FsdGVkX188pA0ryI/SQyN2KR1TlhbUjAGk+rhk3M/Bah0cUilL9igvGgdMnxrMKm8VgG6pZHbnbZgk5Zdq5LhNHNtI15TeMCu7sslVmbheBx/4r2kx9IKt8EvN9uYmboD5A/avZQWrkO/4KHJQvsuBcF21rUS6yPXaLkr4CR4j0KW84CscOYSnZJUDJ8IlNiYa6KF/udyNYZitTuTES5mUhgWQ692a1bcftcVdmwWT4k6hsqBG63T1toQ7+pjm18/JIwuGWMRmTiVBXZgeOT0K8PuD4G0DpC/4EEJCLV9KOO6d+XpGyNuvcvi/lC4TizM/r+A2/Wjfwu2ghJtKhKkXJqm3lexHSaKV2ha4+kHFo+acujocG4YN3+ugutAOwCkC5i0/+X3jSKACeq6oTa/u3soC12bbkUbImj+JhYk0Hv3CaZ+h8xC2R1Oz4D5ZCm7AyCREV0zww0AxXawMPr2MzOLzPD7bnA8qOR9Ar7sNcCHzmAhYo8XMP9pCfxWPU3J1jiafVyL+iPzl7MXgtrJKoF6CTGdih9LBWFfpkQUDrIWl9YkHaF29JvMt8Pt1hdZfK+F/pcNb1bO3VRMqbu5G15hfloFXjmMo3v30cQuRRKoWF2RqNkcn+AycfG/3BfXGmm5nQqFp+RofMb1XXnV93mv6Q6cLElP3O9Mh679VtqRauIzQUOD7Hxp+X/wfBYS8t/8PvrU098nKu6snC3rM6Mm4agrD7WUgkfRAV5qZ40Aq2tls/Sa3I9G8lAtrmdCt0PL8DwG2eCSTjtGcrR1l2h8zjBmZo/+Cov0OQb6OIlVuV2JJ5RLwUbDwL/jJH9bm2ux257BHg+0dqMQVQXXyROJV8KVtSwkm2OgJ/j1w0LuUJiOj576Z6tuBYevWynyHWcNezH0z3CvGDFlkKh9tQx6DvYMPOslb5nNVodTUb/i1PrSBiP2LX2GSnmjMHs+0+C8mzl6f6w+jD/a
 kCV2TRhm
 5/O33NCJna7sMiiuyLGBsKIiJzzm6d9Lw5vpDwmFr08p6377xKp3pr5Ps0NcffbtKTvqNeQJp5zfwmphn571PI6uPd/C8XWcDnjs0Y/bL5aPlXrMLYk7z11h95BcA97qbnGiezeiv6M81tpseoWF4OghKxmbTGcG979Mn/tkGxHS8jRpXuOtqEkUJd7GpbbBI3d0nABXSZy+8C93YNdeW+EQhVIbg5Crl6t0+Y3O6nihCxMtd8XIgDiZyCKNRAw/bU1j4EiXxISanHY+0js6N57BCUbIO65nwzGiqAPFipPh52lYHMSQzunUQjo+ZNb/sK7yR91iB6asjtqcnjEb6yNACQsvVUxFg2rPUnqu3R8iFM5lAfMWZmqdOpRLqygkIoOZErsaOFK/0z/upS8v3k/Ml0KIhdKP7uJ/j/6AFnpV8nTirxpkRsd2qlVXOGRiBnU9aqZLeiERNynBwPMltoqNgrV6Q6pUpyRDzt9dbwc0ZZM2mejKbyf7jav7GuxL9N7EF7ikcCojNSFYq4Hr+/2k/VC1eSTfObAPR34WxPidcDqhXec+ThgXhVP/KmqBNuVNb06hffIcjT0g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kernel-docs to free_pages(). This will help callers understand when
to use it instead of __free_pages().

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/page_alloc.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index baead29b3e67..f5ab7d5bcbd7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5270,6 +5270,15 @@ void free_pages_nolock(struct page *page, unsigned int order)
 	___free_pages(page, order, FPI_TRYLOCK);
 }
 
+/**
+ * free_pages - Free pages allocated with __get_free_pages().
+ * @addr: The virtual address tied to a page returned from __get_free_pages().
+ * @order: The order of the allocation.
+ *
+ * This function behaves the same as __free_pages(). Use this function
+ * to free pages when you only have a valid virtual address. If you have
+ * the page, call __free_pages() instead.
+ */
 void free_pages(unsigned long addr, unsigned int order)
 {
 	if (addr != 0) {
-- 
2.51.0


