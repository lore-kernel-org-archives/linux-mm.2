Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC169606A326
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 09:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=ckBwlKs5
Received: by kanga.kvack.org (Postfix)
	id 036E96B05B4; Sat, 28 Nov 2026 04:21:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29F76B05B5; Sat, 28 Nov 2026 04:21:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6E3C6B05B6; Sat, 28 Nov 2026 04:21:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 841746B05B4
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 04:21:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 151A11405F1
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:21:53 +0000 (UTC)
X-FDA: 85483985706.24.3501CBB
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 308B480007
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 09:21:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=ckBwlKs5;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795857711;
	b=gCg5+qGsgJYRCS+99qnluikKwD12qzvgV99Vjrp31ZhIJ7ivOYPcM4cGoIdVVO/OnsiwI3
	F2NHLoLEQyvz+8wI55iNdaJZHw0KR3XqzAdQrq7Oez/mS5XwEdj17ymXLtLbs1YiAwBKlY
	3RD2SR5oRq21KUKKWtvnjpYTkGp1lg8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795857711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3oezv2c2NxkYBuJOQKRHFZurgThAtx7ut9Mj3a1tfIA=;
	b=4kgu9ucfWV2bJRlY06OiPnmfYCJbUMZTWnxqrh3PAEOezb+w03WEt5yKfaBVKinH6rf/Pe
	EWq/wgT0lSiYiBarXbggQec892x1P9hXh/csb9Sy6nTfWkp9PyqADObjpjX/qG4r/OqPTE
	BTjpZMLlgHM62nNgZ5z3Pr1cQ2AmgZg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=ckBwlKs5;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8b0ca1ebc8bso76673787b3.2
        for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1795857710; x=1796462510; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3oezv2c2NxkYBuJOQKRHFZurgThAtx7ut9Mj3a1tfIA=;
        b=ckBwlKs54GAoSwbC24PMijtBMg7ukwWdO1zhgFN9EdCNF7YyvPM1BYQoR7NyfeU6XV
         qdInXo9kGL1FRnbxWNJQpzHoZAx2iL3AiGbX5oh06U0FJa8AX8LcqiLzFJgYc37apSJ+
         TA6cM8HF33yo4x1619W3ef8KMV4MzG83idLfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795857710; x=1796462510;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3oezv2c2NxkYBuJOQKRHFZurgThAtx7ut9Mj3a1tfIA=;
        b=KxKxBsu5PBz3rifJ476/mwXpRufOehA2L3AK/5EyX+MuXC6jr9B7s6rOLk3LyzJalp
         s27slQBdN/Gqb8BGuJyL/vQEL00l94vrqZhBTSD9vrAndOe6bZ9FiDMwUcLWOv84qRzy
         HR4P2zLfMA+AqgDTj5MfApdftLWu89zXxkz+5Z0ijV+t2zD6IycXUA2FQtKIsZiXfrwk
         VBGXg5iX+2uzKiCdK4U1Giq07TPKe6w2x7k+x0iPWu9UgA0HTVTBBftldx0AmYJw3s1N
         +QqNy75SfAvGSmECUW2IWyaN5EW3u6ueqO0+/JGW5Xgzwq8D2ZhK8zLrXCINq0tq80dd
         8gyg==
X-Forwarded-Encrypted: i=1; AL+hErGkj8K2Eqi6eCi4HEUNJIygHXp4EKWxIilU+gqjhJQIFjXTFucATb7H2I2FKZVW3b2O9/Xmi3+1+g==@kvack.org
X-Gm-Message-State: APuU4Z+Gfbh7U9sWsU09sWGY/CIWP7ULJrJdakrwPaT4rHOIkn/Arght
	GyJfy/+k3RxY6cojDHBvu+lTOwYuqobVJMz6ohAyc9HfKUSwAntJxJVxmT0GDcAYar4=
X-Gm-Gg: AZFdTZc2mVXDOdpSlc08dRxDxB7sLyEhZNL7wF6v9E+1OvScRnfHzqVnZb6B5rRwWHg
	P5ThT6mOrDq4V6VzPEc1GXCHitDTj19dAYCxXRRNZ9NhTwioB9Om6M9HfQfEVW98EWvHMTM9Rng
	/r6tgHmZzTG5mn7O/dz0mBgSUcR98X2jxx7bw2/bd/xlDzFCG2iLMgVv3PSVOrBcJDRbDdWrFA8
	OJK54dV8dtiSTSWxbmMOjloWB5rXgjQ4byHkOY431e9TMAKCMaBehHrxL16f5JhYOgQunPt/TIz
	ekJD/x9B2Fumqnqr7df9JejZHTT7m1LXF+MF3lKKd6hYz5GLci/D/1cbmXJVuOujncDAqi4+w7k
	bh0zge8Wzulx5jDL2yafFuDxOJICLX5gi7dbc3SzecAEOHuw3EuexLmUyf1lcgdyex8dlRVQqxK
	41kHYbdFxiBDJca7Ejme30HlJDOk+8GnCO/R6cyUkwZANzhrRVTXA5Uy41zGX9BlBLLi4JO23wx
	hGlTArVbgRaMv4I2slDbWOuQ6TsG/XT42acw5Ca5zi4hWdapo68jfNGvHAUpedb0/AfNC/N3j5U
	uJeUahTSTpemseTlI+JSwOqQ+mrpTLtJyeqHnSTG8fuTy8hGx86BfMiPdIbNM8D0Y9e04gaVuKq
	+Z39LEAlDAvbjR9MN+U2b/pkYBSERhd4wkn4uz3G0SaHRWzjeaFhfewuB1qwq9I3hYRPTVR5Ugl
	THZQzyjDxY4s4hRwue3SVCAcmC9wilbDwEa5zYoXTla/gtvYsiFTq50/Z0tPtj0/mZbzKQINv2Y
	9swt3Dwjbm9ngTiLpN56/k=
X-Received: by 2002:a05:690c:63c6:b0:8b0:ecb2:8861 with SMTP id 00721157ae682-8b52051cd01mr122748457b3.63.1795857710306;
        Sat, 28 Nov 2026 01:21:50 -0800 (PST)
Received: from [172.20.0.3] (c-73-207-185-9.hsd1.ga.comcast.net. [73.207.185.9])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b52032d09esm102449777b3.35.2026.11.28.01.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 01:21:48 -0800 (PST)
Date: Sat, 28 Nov 2026 01:21:46 -0800
Message-ID: <cover.1795835884.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v2 0/2] kho: fixes for kho_init() failures
To: rppt@kernel.org,
    pasha.tatashin@soleen.com,
    pratyush@kernel.org
Cc: graf@amazon.com,
    kexec@lists.infradead.org,
    linux-mm@kvack.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: 1k3shxbbp3k74n9bxmxdbigcssmt3c4g
X-Rspamd-Queue-Id: 308B480007
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795857711-918763
X-HE-Meta: U2FsdGVkX1/p9CDt3ASWJTZoO+w2Wz4cU6R/5NRAHybZbrUMrNCgVLOPIUsEK5HDYOsab07R81fLqDIdth5al8zM/L1SnJ87JyyEFVJ1mxkybjjC6YxfVMFHz1a5YCRCr1OSTkhdOaFPBDlQXrPWgz52hzKlbl9bCtjT2fpbvS5VeTr1Ku0CRXVh0AC18gsxT5qV0KiOGHgHMFOta5Z9BFKCQGWnX3ZgCUjrYTqXprwa0qVyWi5LRstDzTtCB3TWEnGTLlS2T9QzTvwXzbCIa+ldqQBBYmw+eGar1Fdm6NGTp13s6B9lH4cYjofr58WkZZczlqzJ7Qv4Lh33FBHixsnEQmoIZQODVxzq5LKdHiYlLx8dhzRlD3M3/hdKJDU1UI2JalWctucw+VmkBt/Ljvle4a5nSrR0wQJ7MUlyC6rTXIy+YkeYMBGmtkkwJ/wx2NG4w85PwxYbw4nq03sGdJ0tXm0xpb5b4xTDLPieUhCo/Yp9sgL7xh0pFFchpdVLKP+6ZHg5hv2X6PYHkL/GLha7sWErFlFRCTvmwV3w/Oy0S/ApHMPMbwLqJei62p1Y/xFitahknNjg++PXd74wZ34iG0kg398LTKm3hYyyTei899/RVWNxcAFcNE4P2hfm2mlChPwYsFAzIb/O6IopaPbg7Aeco5Djlp8tn1q6b9e4VWW/0EoymMx8K4WdMYblEwyRoFpoDOzDCkgXgMlQEC/1NXar41RvLJGMZs+rx9CxWe1RK4a32mr9+PjUF+MReBVkNl6fFeUvhmFc70nX6sCSo0XPMb7nsYjkACiV5vZL1YbYNcyUiiLP64IIZz4DzCxRsFfV1zcv75R27ThOER2/3t/LKl4NuO2qfYsmgkjZRfKfd9gtkFX2ElIL70X7ervHr2DhKo5UoNVt9d6S4Ia0FGljyaqLEWoYOD8iECRR9Z8Gs6zY5ptVPV/3jxy5eg5A21ALgK3KlESuUTO
 Pz6RVwKl
 Laf5kXsLX5Qi9qts8//TKml/Z66i3Ls2FmdUqU87b5P0rH3bCrelsAEMSbnz86nUq8wTwLZmIaqJrKgX7Rv8FcjaczbCf74GNxgcO1+6W8ZwlIwNjuDTRZchpBSXRYYHxMmJVhVy5XC1fiUlyC9NbxUFdobmjvnWJpGXH5sX7M5FDr7QhsyQlDQOPxabfxTF3ESazViHqhNyb4CVDf9usdnsQoeek5twImE/VFJW77EcpLy5tbOrcBsiHX8GG9mIGbnXhc+HhWBOk796O4xQK9WakDcHQNo5jQUbP/9Jq7Y/K/NXFUhbbgmvcN8xK7+FcvlxWM3Z+UAgHSg2aqgLlMv84OiVLsxeHU1pPnkkPAYteevhatP2YaMQAqD1jAUTnPS30n3GmpNvkJFleGO7RxYyGaVIQ69NNrA4JshJeB+Ig0CQ3N3VLqSyZRG6n11cP6H5+Sx2tgGKe55ykfrQtsvcd8md3rmtTXHm4T1nqPLB3SH9pPZ/0425bSGRiz1pBUM861UaA2uo7S4gXcVR8ZMBFB7rWvAMLKyBXvL13B0gefJMlvyN9BJ3ofAdk+tGe5rMcM2ZubjM0vvmJMjLr2+UnRnXW9hmvj8RswtgG1UERSwv7bo30CEgUyRNIoIjz8swTPsYFUtf1hH/MBMMkavi15lTd0M5f1gNq0QqNOoGLQmeZwfNTqshCzW/AsRthWj5QEcuEAW+Qvek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When kho_init() fails on a KHO boot, its error path frees the bootmem
areas that were inherited from the previous kernel, even though the
running kernel was loaded into them and is still using them. The new
kernel then oopses in kho_init() and panics.

The easiest way to get there turned out to be debugfs=off. With
CONFIG_KEXEC_HANDOVER_DEBUGFS=y, kho_init() fails when it can't create
its debugfs entries, so a KHO kexec into a kernel with debugfs disabled
is enough to hit the panic. That's a bug in its own right, because it
means KHO and LUO can't be used at all on a kernel that has debugfs
disabled, although nothing in KHO needs debugfs any more.

This series stops the error path from freeing bootmem areas that it
didn't reserve, and stops kho_init() from failing when debugfs is
disabled.

v2:

- Use is_kho_boot() instead of checking fdt (Mike)
- Say who reserves the bootmem areas on each kind of boot (Mike)
- Describe how to trigger it and add the oops (Mike)
- Add a patch so that kho_init() doesn't fail when debugfs is disabled
- Rebase onto liveupdate/fixes

v1: https://lore.kernel.org/r/au_vQhHAcJbkryXN@chrisdown.name

Chris Down (2):
  kho: don't release incoming bootmem areas when kho_init() fails
  kho: don't fail kho_init() when debugfs is disabled

 kernel/liveupdate/kexec_handover.c          | 19 ++++++++-----------
 kernel/liveupdate/kexec_handover_debugfs.c  | 19 +++++++++++--------
 kernel/liveupdate/kexec_handover_internal.h |  8 ++++----
 3 files changed, 23 insertions(+), 23 deletions(-)


base-commit: fa1c0f103fd68558613d3df76e222463c6e4fc37
-- 
2.56.1


