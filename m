Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B641D232D3
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 03:30:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80C376B0089; Thu,  8 Jan 2026 22:30:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6C16B008A; Thu,  8 Jan 2026 22:30:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E29F6B008C; Thu,  8 Jan 2026 22:30:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D06E6B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:30:07 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E20B51AAE43
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:30:06 +0000 (UTC)
X-FDA: 84310996812.16.6C47855
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 22261C0006
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:30:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=g+Sk44UO;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767929405; a=rsa-sha256;
	cv=none;
	b=Z+LAbcht6P7nyR8Ymld63+fHLSfhoXeU5+Efhqh+hBuk5GidWdl1uLmv4Dr83gDTUiqgCJ
	iN3ZHjIu5cTjY61cN+0YNd0DsdsStBfbm4z880ABsl71fRi0Aqr6OKiGl9JzInM7ZiS32n
	1nkQSUF+Z1w6J4J33V8YlkU3DnAc+9w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=g+Sk44UO;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767929405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnnuOtcQSFVMOFNXUJxFTPuY0l07gNLISRT9Z4l4S6E=;
	b=aWtE+wwCzajMs7vB5gpSkqPC3hZw5BNQujNq1ULBw+B06i9eHMjR3TzX6aTZibbxLM8rBL
	5cP8O34ncUY7Mtp/N1pwXeHawrkjC/Y0YkRNmI9lZ4ZVwFJUY7ibk6I6H4G1ybIhjUTSN1
	xakpUyVM8gPEIhr3tqerD/yqzAmYm3A=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29f1bc40b35so44738225ad.2
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 19:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767929404; x=1768534204; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CnnuOtcQSFVMOFNXUJxFTPuY0l07gNLISRT9Z4l4S6E=;
        b=g+Sk44UO3HqK70f9FGP29LpSzo5z+XV3KMlVq7dry25k25zqlSdJgyJsKQGhpUdOXj
         ATsJFa8PPHEvB9hApotKJs1bHYoQLt3z9ZRrrP/KiTMbZkOIWiSexF770yu1o7SBgAF8
         09GIKS7In4cn/UiOur3R7DE/GgJNowXkaqhuc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767929404; x=1768534204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CnnuOtcQSFVMOFNXUJxFTPuY0l07gNLISRT9Z4l4S6E=;
        b=VEdlUV22DS+Ydx7B98QuHFmlrD/IShjIvPW0pTBE5VUt7ahJhuI5UtY7d5jn749p7V
         JMVw7xJ/Iaw66D+4Px0vCsW4ufS46EzByHzorKTk4b2Na0ziYI1yBwPjrFSS8q3dnxPt
         0SVFDCZ1y1OKje9xUFGlxmYfGCOPtEwIPwLj+rJMlPOhSVCHcJmtzZzdRnSGYIB5xLGu
         SW710J+R8KX9O/wU9OLHOoiEEZsjSVj/IuUob7z1yvWyDaTZhJqQSVrRZ7KnpzujcBjJ
         4l+FmrLz4nE/qHNyfvt5wzp8XjvUmPuwuToD2FXDu+qn3Xhr6JeQ5g0vfuwJd2zPsWgz
         +zOA==
X-Forwarded-Encrypted: i=1; AJvYcCUxP+w4CCplFxcesru99WLQMjuDcWHqzxt1FW5OX2kqVc/CX65iECogG/eCjrLu9cEv8Cbk8M9j0A==@kvack.org
X-Gm-Message-State: AOJu0YynPrMWjPWX87Wyt/NPfKHuVRGn2mob8efpUAoNEDqR4F8W6Gwj
	4M255LoBofLHSZ0wThna93BwNw4cdhD3mTm5VFI0g/+5cbTp9IX6P90XlzZJMaQISg==
X-Gm-Gg: AY/fxX5D+yvsuRmn0aZCQXG9OTD8Soz+bqw8eS8bhfsPz1z9gJz04leQWIyAZ2N1UDM
	33yuIUtJSkc4SG82mAQQGjTZyakM2RrY2UY08Yh792UKEHhKKxBtD1unUIBsKcABije8zcJsQB9
	vnZgOy0qfnCGfGcCADVTN1fDkfXqaWMgZQUWDS7IOBbJm0FtgNXyOyi01oyehYCB3B5ofSbVod+
	lom29D/Me9EXYvcFnXah4sXBVMryR+jr6h0yrw6Ly4LmNCg8+R0Sql3J+fc+REI9NEPBqI7R0Pj
	bNSGt1DqeKnIRe0l1gP6Wh+SVZEUZQt5Oah6PEYIA9VaKCARyPG7TsjN5DJ2Hy18kdmUr2i9nfB
	41v1Zp7q6kK8dipzqiQ/xT7SoMgYTyqIhki5TugwdkgyYaNaTD2EwGFNgVjmQRxmQKNlp61NJH/
	TTYu5WTLxGh/qMd3wbuDqp+tx98yFxsPjTFAra2NTTHTp3a5E0Nzw=
X-Google-Smtp-Source: AGHT+IEIY/uUSaX5NVDnZd9LM4ieLPIkk1BGZaa5TEPDlqlwi7AdEIO+VuPIRJg4ciwqiQifAOjLOw==
X-Received: by 2002:a17:903:2f8a:b0:24b:270e:56c7 with SMTP id d9443c01a7336-2a3ee4137cdmr83808065ad.7.1767929403996;
        Thu, 08 Jan 2026 19:30:03 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:d2de:ca1f:efcc:43e3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81e6772688asm223118b3a.45.2026.01.08.19.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 19:30:03 -0800 (PST)
Date: Fri, 9 Jan 2026 12:29:58 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <2iophcy2e6vk72ypxeshmen66e7jhr52zr34parn4uw6vdyjef@frnpfrltrky2>
References: <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
 <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
 <aVyYuS_usi-lpHkM@gondor.apana.org.au>
 <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
 <aV3uXguDCaVAbY53@gondor.apana.org.au>
 <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
 <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
 <llj3jf5evsp7f2wl2hmm6mouqzwzolvdnu4yquhxbgsgaqvsda@ltct5tqpzmyo>
 <utnvn4oupcmohosp6d3qti54qmdppg2xfw622dq6zz7t66a6ma@2pentzdw3zgk>
 <yxpn4gan74uryy6huzulsqvqvbsqiehdqe6lu7m3hjf3tjjdop@a6cifoycstso>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yxpn4gan74uryy6huzulsqvqvbsqiehdqe6lu7m3hjf3tjjdop@a6cifoycstso>
X-Rspam-User: 
X-Stat-Signature: r1yixtii9wtdkzcyzkp66amay5omr7ne
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 22261C0006
X-HE-Tag: 1767929404-921879
X-HE-Meta: U2FsdGVkX1/g1H4pzP/IsJOBB6WVbXgAMkb+nZN8idKhrpFlcfKoL+2VHoebESl6Q1iPUFSTd0M7r0FRIRdvMduUu4r3RU3XrC6V+Mp9FE5Djpr6Ui603KzQJiBaYhZ7deNlJleHBT7ICJAY0GxqNCs6MA4t585D947YhbHmUgqUt2UEv6X/+czOLuxMVmG6U1pgXWHsQaM8YHfhxcJPKbfgpiObnErBSd6+LzhDV882+0+Eqw7j/5f67L0IE+OL5mwqvZv7GrLzo+f1cdeML1mu6y4wZpxRAj2skl7uJc/cEgjKpXapseG+SA8av7LYxOHA4u+pObxijdq4u5hnInj3yiVuzn96eh9Hi/7IeRerfTonPH6Dh04vunvIR4XCWQvKVEqS0KFAW/dLsH/bIBBWc3+VyzS4wThPWDaYQ6k1L/JCXFK66bCwXJWryW+XXKcCjwes454yHG64R2reqe7LnLOJTZxd0V/w+6QQrWLCgv0kGRtzw/9AQsNbM2yBmBHWkSFJW6fLpWOhIT7Ot4GUi6IqPxb/rOCGWIPbK0tPPJxq2I2XwJ7V9VDr7/xVhdVz2QVY4ydkDwBX9WpMhvjM2ZVLRukNSUN0L0ybm3xtNqunjsPOv/hvZXkmelGFUQfIyMnUeBM6WBuKKbor/ddJZXmKi35jJUoFI3ATWvgAIaQwSW273TcIM2/ygi3lN/BItRNJ/Kynsn4hLAn5elF91BxAVPhigSCTbGpdwcSunjkCCRqbc740BrIdWrcVEBql8oazL8ywbh0heAImsRBFd8sn7gn2AFMdAZgWVJKKp4WFuGvstu1b6xrFrwfHAXbKhZUewh79IemisSPaOmWMas7VXHNc3rLvOy3QKCGLcawu94IlTvBQ5u1FTjRfSFwy7yG9IJsgqv3uBdx8u6HtLdU0NEGPo1MaXQn3zpl4Ryh8Qo0kE37BI52K3029Yr4iM4btKePbxbPNHZF
 gInKXsQg
 2Q6XQqxQPpp5W9vfrlcwHGrHydefUlCVr9tlKdB9iHygmD/yVCRBPUv+jvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/08 08:01), Yosry Ahmed wrote:
> > Yeah I agree, I guess I can cook something up.
> > 
> > For transition period we can have:
> > - current "memcpy" API
> >   for zswap
> > 
> > - SG-list API
> > 
> > I can vmap either on the zram side or have new zsmalloc vmap API
> > (alongside the memcpy and SG-list APIs).
> > 
> > Once crypto API supports SG-list and algorithms tunables I can
> > switch zram over from zcomp to crypto API and remove memcpy and
> > vmap APIs from zsmalloc.
> 
> IIUC based on Herbert's previous response, crypto and scomp already
> support passing in a discontiguous SG-list. So for zswap, if zsmalloc
> returns an SG-list, it will just be passed as-is to the crypto API.

Oh, okay,

Something like below?  Not really familiar with SG-list API.

---
 include/linux/zsmalloc.h |  4 +++
 mm/zsmalloc.c            | 65 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 5565c3171007..11e614663dd3 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -22,6 +22,7 @@ struct zs_pool_stats {
 };
 
 struct zs_pool;
+struct scatterlist;
 
 struct zs_pool *zs_create_pool(const char *name);
 void zs_destroy_pool(struct zs_pool *pool);
@@ -43,6 +44,9 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
 			size_t mem_len, void *local_copy);
 void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 		     size_t mem_len, void *handle_mem);
+int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+		   struct scatterlist *sg, size_t mem_len);
+void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len);
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 16d5587a052a..8f7569058147 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -30,6 +30,7 @@
 #include <linux/highmem.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/scatterlist.h>
 #include <linux/spinlock.h>
 #include <linux/sprintf.h>
 #include <linux/shrinker.h>
@@ -1146,6 +1147,70 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_end);
 
+int zs_obj_read_sg_begin(struct zs_pool *pool, unsigned long handle,
+		   struct scatterlist *sg, size_t mem_len)
+{
+	struct zspage *zspage;
+	struct zpdesc *zpdesc;
+	unsigned long obj, off;
+	unsigned int obj_idx;
+	struct size_class *class;
+
+	/* Guarantee we can get zspage from handle safely */
+	read_lock(&pool->lock);
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &zpdesc, &obj_idx);
+	zspage = get_zspage(zpdesc);
+
+	/* Make sure migration doesn't move any pages in this zspage */
+	zspage_read_lock(zspage);
+	read_unlock(&pool->lock);
+
+	class = zspage_class(pool, zspage);
+	off = offset_in_page(class->size * obj_idx);
+
+	if (!ZsHugePage(zspage))
+		off += ZS_HANDLE_SIZE;
+
+	if (off + mem_len <= PAGE_SIZE) {
+		/* this object is contained entirely within a page */
+		sg_init_table(sg, 1);
+		sg_set_page(sg, zpdesc_page(zpdesc), mem_len, off);
+	} else {
+		size_t sizes[2];
+
+		/* this object spans two pages */
+		sizes[0] = PAGE_SIZE - off;
+		sizes[1] = mem_len - sizes[0];
+
+		sg_init_table(sg, 2);
+		sg_set_page(sg, zpdesc_page(zpdesc), sizes[0], off);
+
+		zpdesc = get_next_zpdesc(zpdesc);
+		sg = sg_next(sg);
+
+		sg_set_page(sg, zpdesc_page(zpdesc), sizes[1], 0);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(zs_obj_read_sg_begin);
+
+void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle)
+{
+	struct zspage *zspage;
+	struct zpdesc *zpdesc;
+	unsigned long obj;
+	unsigned int obj_idx;
+
+	obj = handle_to_obj(handle);
+	obj_to_location(obj, &zpdesc, &obj_idx);
+	zspage = get_zspage(zpdesc);
+
+	zspage_read_unlock(zspage);
+}
+EXPORT_SYMBOL_GPL(zs_obj_read_sg_end);
+
 void zs_obj_write(struct zs_pool *pool, unsigned long handle,
 		  void *handle_mem, size_t mem_len)
 {
-- 
2.52.0.457.g6b5491de43-goog


