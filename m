Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF79CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 10:59:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3495C8E0006; Wed,  5 Nov 2025 05:59:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FAC08E0003; Wed,  5 Nov 2025 05:59:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1248E0006; Wed,  5 Nov 2025 05:59:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06C618E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 05:59:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85864C02A0
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:59:09 +0000 (UTC)
X-FDA: 84076256418.25.11DDBED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0F14D40010
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:59:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gY2kvuib;
	spf=pass (imf07.hostedemail.com: domain of lbulwahn@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=lbulwahn@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762340347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fi6lMVZB+GdSzEqZmyJtwxQVO8YBPh6HS+ZyxPLOlA0=;
	b=iXNqzzNwIuhea4ovN+xlzts2SNixxkmkqtLPJBALoabx6mqnOSBf71yLIP4G+eVCUEMHjF
	zmY34v8FmGoblpf0MnEb8ZvhZ33dOb2Uo62kCIjNyQlXGDwCzNTX+caIe8FpN0GvjBcuKM
	USUdX43Huo18QMG0YgYTGhFAa7fMOWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762340347; a=rsa-sha256;
	cv=none;
	b=LCoA11AsxBGIR180++ywQuYb7Zf2knAs0otl9VP2y0MPkHCKbyI128hp+o/+NVC20b5tlO
	XkYwCnztPQV7+rOehFWncHdULvPIYZ6Fuj1hQUxNOaHN0qEsoVFVzqx08NlKAT+uUrsOcy
	On+JgCUzkIENZyS2vG/KSSBKcOvpcpQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gY2kvuib;
	spf=pass (imf07.hostedemail.com: domain of lbulwahn@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=lbulwahn@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762340346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=fi6lMVZB+GdSzEqZmyJtwxQVO8YBPh6HS+ZyxPLOlA0=;
	b=gY2kvuibTECPs9uvDXZmuRaKEKI4/07CZXC82UwkH/v6uMr9W9wXAzoPbFX//L+U/or1/c
	bqpcXm0zc+89u6tXR8DEe4nnT7fXE3aUkVp579uNX84vJkBkhXUc9IvWplEiQm/UJVeQ2w
	M4uJXT5PE7OqSsim/nc1VETloJkDMyQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-TZacflb2Nyytaz8MU6t8_w-1; Wed, 05 Nov 2025 05:59:05 -0500
X-MC-Unique: TZacflb2Nyytaz8MU6t8_w-1
X-Mimecast-MFC-AGG-ID: TZacflb2Nyytaz8MU6t8_w_1762340344
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471201dc0e9so63386475e9.2
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 02:59:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762340344; x=1762945144;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fi6lMVZB+GdSzEqZmyJtwxQVO8YBPh6HS+ZyxPLOlA0=;
        b=GU/kkwev1vhw4qx05c9piZ1DfM9C7q5ZXLc/bqgYF7mvH0duqa30dBxhArxaF78OpP
         pKMytoT7wSQkxSBZkKdPU0d0vSjY+KXscrTrYtWg8PI7cwuKFxA+cwWiIFE9rAXknJBl
         AOlfxbECsmiglU4PS6+kS0/r+zBZzgS+mbSYR6gLtIXWELHjEgeDGA1WAu+do0T59pbH
         F91et3jqz7/24ahxW+DAslDKOxooalC5NHa80dhpr5tEuyojQYyrvfBx/Kpkp+Oa4GSx
         wwTgfpURqI4DyhcKym7uDVT7vLzwdWhFqoT6QCQQmRI6v7vTaEGAN4yRGklWwBoKQcXz
         Qvdg==
X-Forwarded-Encrypted: i=1; AJvYcCVQQsVqXRu4mkOblBSY+jop/UUrpfZ6JI0Yy81toggfhlMWzSFbBeYi6ZJZzCb58g5n6u2vj81rTg==@kvack.org
X-Gm-Message-State: AOJu0YxeN+HXksXteggjdbwpYi0J/GwUq4QJkaaQIS5DD+/2U4fGifjs
	/fn6iqyUpy4MJVlmjPaATePdg8hyd4oEIGAm7luYHfyFt+Qb77/zDxhOrOX6N8o79uHTQpxuaFh
	Ys/Gbd5pDYGwABjDrOTKQ+5f9LFRdx2oS753Ol8RNK+h6UYQAAMZV
X-Gm-Gg: ASbGnctBo79C583BBPjo8DI1jsvHJcyEXsBooOcvvZsK9G8bDmcR7GSvwqLIPHyUU8s
	lWVvxttGWmJKaohUiv1nEVIKukBcDXd8KzHNJovAxGCoNKi5NADUl5W4Zh+cWT/fKnRSmtgq1kI
	//wPDCuE4KFUUbM9ZVm8VjsgU5ghJS5dFOE/NfGGs+vQljQTp1LNbSjMTrs+udj3+r2B+nigooq
	89VtWvzmrakRK8BYhS99D+RDrcxPck0X0ZxFrNQyDNepIA1ud8tlgKVYTBg8OSiYyEWhc04L3MX
	9VC8w19ZIkVSE60vMH3Ce8oBpCd4OkgBYntDaG8NqWQZeTz2048dPej3SXCgieKICzWH8BDshWO
	bBw6hpK5KpkoQAxuTeU/Eq77R6OoC4flE+vPB3+02Skuau18K
X-Received: by 2002:a05:600c:a00a:b0:475:d8b3:a9d5 with SMTP id 5b1f17b1804b1-4775cdbf0bfmr23847065e9.10.1762340343920;
        Wed, 05 Nov 2025 02:59:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFGMcjTBOz+Nu6wkEk+5mmod0huDiyH5V1WOUYLCdKWa9YhZHNUKUTSo1PqiQsOwaH+WwN8Vg==
X-Received: by 2002:a05:600c:a00a:b0:475:d8b3:a9d5 with SMTP id 5b1f17b1804b1-4775cdbf0bfmr23846845e9.10.1762340343543;
        Wed, 05 Nov 2025 02:59:03 -0800 (PST)
Received: from lbulwahn-thinkpadx1carbongen12.rmtde.csb ([2a02:810d:7e01:ef00:1622:5a48:afdc:799f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477558c4edasm39000785e9.5.2025.11.05.02.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 02:59:02 -0800 (PST)
From: Lukas Bulwahn <lbulwahn@redhat.com>
X-Google-Original-From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
To: Matthew Wilcox <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: [PATCH] MAINTAINERS: add idr core-api doc file to XARRAY
Date: Wed,  5 Nov 2025 11:58:57 +0100
Message-ID: <20251105105857.156950-1-lukas.bulwahn@redhat.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rWuzOELygUeY_p94lG77pJYtYcpUjIIM1YXXUIOz8us_1762340344
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 1zwnh7px7yfftdg6mbysrm7wgsaosybu
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F14D40010
X-Rspamd-Server: rspam01
X-HE-Tag: 1762340346-514488
X-HE-Meta: U2FsdGVkX1+D34u3+oqfpcuczQHP8ZxjF6+CY6yvsn38Ojt4QkOSv3UqBQoIEmx1IG3k4EcxKczg3974xA8mjGBiFhbZ/BkGL3DEgqyh0WQAWc3xXIcEJBzUA5rvjQo3jWM2KxlmKeWydFmJcshQswLJt9GxhX3IpzJ0dRN5z9ZbwxeBziNO1hFZvxPHk82/Uvqzf5D3mNeG+HYJm0fgG3vHzSxtQVUS08KjoWDuBMgcvorKqCTvbOAAQ9ITawTvqBkGJDcNZ9EBCDisw/QK/6t1ZoPIJPsDVgEmNdvL8PPE3l2VME/zlY0OvwBBEtMKLWb7SAwskNUgtUA5KsL6qH8qyQPbL7HCaYQzUNG16q9rIqNrDLWREknI66w8hMh4mrOtHiqnWj8lNDkeAD74Z6ENgikLKJ5Gnpp0idnb81KKcX+rvYLXLwUI9xEWudgBvPSkOImfnP89//q6gWzuDjOuhuvLJgWAkdfaIazhShTgEIHSSPbqBK7rVxQmq1tRCcU+WzuTrPybsWRSLXeHuM/dpbfNMqCwKkDeXjUeEChUA4BVXqjw9dgaMBjVKwT9T8yUZSZMkhxoB6f2UHFHVF7qX3iIpkeHLnjqk+jWQVlbRymPXEEtLv6x/EXOkxk7Qs06uSUPsRupaCkg25G2OedfH0S38Hu4sgnLeBx6KgbTu4rA8HjLpmeoOXkgwnrmF6D2SO3Usn3ztG4H49P4t+ex8hUKeVa/o2GARn5iv3ajce9j4nrPa0JePwPoNg6DcZvrfwgewdmK2REUHSfzNv/KbxmAwGJO2R/wea5olrfdN3w21dR2d8m8BfqfLzJG6884Hl5merFj0AoGGDYIR7sXaC3Uxm32Zx++Qjc49+lptBN9ZZMa25nNEfWOhqVhDAi5TBHOx2xEC4HVz7vJj/HIMPj2jAcT09meznRkYGY7ICnqZSCGjCSyVLF6RGnRG9+h27e3uBR4Idm14ZD
 KOtJDaKx
 ot4W59qTJYKVptqbfB7PtaQLOBFfqYI5ICw1tDHu6YcMtwucGR1IZNQTzK8kFB17jXd96RVZsiPug5zZMJE7fVDAmZAN8fZGOWl3l8fZPTm2vFXJ3/6dedvCWcElrBLRlURc6dJ7aZVY88jV5IlJxe+vACGadak14sMuDYujsULa21uOoX7AvkI1VDXPSvyfK9d7ug9QvrypWf8NvPMJeUiiu213D3QFOm5Theu0DW0Eqq7vtwI7yXkMqP28CIraEIWaP3NDCxHcPGlqxXYe3s09vsdV0A5SC+rqCXaDdtPuYRNQF/pKP/gSTGv9zXVKz1dph72Y+v8SBsR9puvjFcnQf0A2XLlYosEupv2MMC/kWYZh/o+trwxySJMYMX1P9vc35F72UJM3G2CwBqZVQRIlWDxOve6la5iTgQA5MCHJoMLyWSPyL+HwPk2GbYT96Ct0JDJ/mRwY6HZKtgMxC1/I86/nQdGseii0Pp3RHhPecy3lpJTFWvsmnR32XkmqVv1bDC9HTNJ4lxpA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

The files in Documentation/core-api/ are by virtue of their top-level
directory part of the Documentation section in MAINTAINERS. Each file in
Documentation/core-api/ should however also have a further section in
MAINTAINERS it belongs to, which fits to the technical area of the
documented API in that file.

The idr.rst provides some explanation to the ID allocation API defined in
lib/idr.c, which itself is part of the XARRAY section.

Add this core-api document to XARRAY.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2b5f86dcf898..01e1668cac02 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -28010,6 +28010,7 @@ M:	Matthew Wilcox <willy@infradead.org>
 L:	linux-fsdevel@vger.kernel.org
 L:	linux-mm@kvack.org
 S:	Supported
+F:	Documentation/core-api/idr.rst
 F:	Documentation/core-api/xarray.rst
 F:	include/linux/idr.h
 F:	include/linux/xarray.h
-- 
2.51.1


