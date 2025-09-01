Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1588DCA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0198E002A; Mon,  1 Sep 2025 05:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CC698E0002; Mon,  1 Sep 2025 05:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395B98E002A; Mon,  1 Sep 2025 05:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 209248E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBA061DE7AE
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:43 +0000 (UTC)
X-FDA: 83840133846.01.6D64DBA
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 19DE7100006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=AnLD2obB;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718382; a=rsa-sha256;
	cv=none;
	b=yUWhc6wO/bbPK+bnq/b85xLPvKECIdZXmLHkKVV6k4nHRVQUZQY5kfrbzHbXF1KieobuU+
	g6rOZ29z1vYEKs35zmQZMBZwXaQchM46Eh6/sjv5PnfLw+O6ac3dpIKbDktnhBTRQZOiNu
	zcjUbGk6j8dnfbVHRhY0TSqVDhGJ6FI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=AnLD2obB;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf05.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75MLdbHz+6QcCmBzq5cWAq79ueP+J+aGEFpDLtijxG4=;
	b=ZgpcK4M1RGVLlSz2kGvZSrAuudSjWrjqVK8YQD6aMcsZZubANDNPkzNB5puZVI8tvNS/pI
	WxlJ49tc2p+SZlt1LKNC5EK+b6Iy2muHnDcUWK1r3E8SVBTURd9XYGsgLrbo2BjIuJSHKN
	g+olzVmNrgfH4DN6X7YM8mU5H5mYk74=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afcb7a16441so635370766b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718381; x=1757323181; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=75MLdbHz+6QcCmBzq5cWAq79ueP+J+aGEFpDLtijxG4=;
        b=AnLD2obBxw9BxtXVt/aB+sm2UW6zlM19DLaAfQ8cIcKrmTy6CvBD8vCXV0CvxXjdwp
         g5AZEdUFiKIkB39U0SitWD/chDKIJi3P/lwfNuTMOK0dsEZ/4EZrEpoHRgRQesmkDnq4
         kdq4PWATl3gTQTkRlHHC4yfxBX4liStZlRjy6hDulMp/85AuTio5llU67ynr1GgtzCbn
         xkfdfi3jGnGoRZbn0pwz2pfCzzt9SPPPALGO/AE1GxjdKfNL6Kemn0803nofW82vpyT2
         4t6KeThMkcnC/uJ6eGJ2I3BCPETEgh1Q8IjAPZF+3BWc2e6yRRcspu749e+u/09J1V54
         SqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718381; x=1757323181;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=75MLdbHz+6QcCmBzq5cWAq79ueP+J+aGEFpDLtijxG4=;
        b=HnF5jZeUWXRZo9VD28kjsOPb6M9xXtIDnzHuUaXzjrjNvj/h7obGDSHHeGKkm7zto4
         hDCz6CLkadXwF8DpHEGfMrOVYExZrhUy8Kz4PTTBjA7Z00bwiitdq7VL3znjV0AVZ8Rs
         gQCkZ7ssZpA5egy4VmDDAYcz92Lc16CgZ9V33HA92mQVjeiP25Ccxq1cOQACOuCGZYBV
         8FeVavLfWd7sXuYTWwuQ0+/2VWGDMV+oEm0Z7E1VWA1mKsREQOzn4NxsQ83QYJXhwAio
         4iePybbGYGqOd2lW2meItiKNlaIZk/Aw2phBNj6OxcIgqQRovX8dg/NfJzqe0pqRDcCZ
         MoqA==
X-Forwarded-Encrypted: i=1; AJvYcCXZ0e74TdIt68W3pIYjPR0xt9/A6cbS4rzFnoFSr7JYQUIcnPqilDJ+VfMSm+B0PFeY9hVGqIrQ6w==@kvack.org
X-Gm-Message-State: AOJu0YzYcyGdi9/L23ZnFkUUFVFAU4N1S8XzKW5GgppvzUi4Z7Hmj8TN
	/NRnOHCdmz9pKchhAzpXUNgn/0PeG3aMvi7Jhy5SYl357aiq4wPVHX6bvm9KyNP8k3c=
X-Gm-Gg: ASbGnctqXjkbCklJFWVgx/8gW2H/P4IjoHHrIZlHA4Kis0uqP1hZUEQfeBkPk86sgXi
	TWV2xyJjcAvNNEbZrRMEIee/EjG7EgHgJ8XVy3RDahu+hKe/qwPmkYQCvZFsQrwIgIKgLaeVftf
	VoXobNC6K7nFcD9FcfeKqWnUYuSuEjCGSru42B6XPyAU9oR3RFHn7rL7Hyhi/pxsIa35SJdWwA8
	MIEjDNDPbl4jPsvsEa8wO3qGXA9ukfJaqRvHvIWxFpleLgeni8DuyLsDhGjiHo3amooZU7/Eldb
	jrN92D5EBgklW8oHl57MhMtAPOMSFdyEIk7RwNW6pzudPKbvZWH2ywsKxCb/Z8RyUZJX5apWFBd
	vRWD4aw9gYPKCrw4/Ta7Rp1uSGhr2E0Jyb7cREeavIDT+MvhSvYFph3awrh7U0bbzWWJoXHnHbj
	5tabdJIeIVZ+p3+/IMNYaGdqtN3HgU87ZN
X-Google-Smtp-Source: AGHT+IE9e4KQZ2t/2q7PJOIOamK0vKr4Bi6Eegeqy/erHFPooxkrsYfz9WOXXJNB6N/KC23RU22uVw==
X-Received: by 2002:a17:907:3d42:b0:afe:b92b:28d2 with SMTP id a640c23a62f3a-b01d9772e0dmr678214366b.51.1756718380546;
        Mon, 01 Sep 2025 02:19:40 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:40 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 09/12] mm/mm_types: add const to pointer parameters for improved const-correctness
Date: Mon,  1 Sep 2025 11:19:12 +0200
Message-ID: <20250901091916.3002082-10-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 19DE7100006
X-Stat-Signature: kkhxnmjdhcwc8thikbggmsj8xqocjkot
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756718381-978802
X-HE-Meta: U2FsdGVkX186P8sTXhoxoun1vlEYEk9MyDnoPIDIrIASQmPvnqCJMl4GQXw8HeqykG1Xr+st6zuzAwhh+zmp9ZdWGOMoS/NCNEAyf5QDb7q/3gyRJlsmXaK3Lt9RwHoZ9R0tf7EBkDnR2/i2P4tTVMA+rlxfbxTPQS6PjF+g4Zg4gkW0OOC6m0TDnpQ49P0h/meVkYGoF88f5bLBQ8w8B0+hKg9u5haaBWe9FQ7tQXuLzkKSkSALDcd/+64gOUCqGQqKZsCBdOl9aJKQofioxnJgLl4s8kJJAvyI7TF9PIu4AnOGV6iAj7Q/XRpQ4jt+9W1+aZVLAijp5Pr8r0RswSxMVsSTn+atXDMxnqNtO4Z36RK878fzlY4c9Sel0Gyu8LWOe/aCAgeqs+xFygrEr5cKTEcZPt8DL3TakB1+jwcGs5WTPhorcvijnPkneGIENJ7Towrfqz1MFImQNvI0p32bGyytqehTSCBnTr7HHkVBLIIaZrq4gYB6HeOqNzoxK+H0zshjZqNwdrzCFUzEdwLnw1p7lqExOMGuOonEcgwPsdjZo4W5jWOvvYk1wS1IGP/oJMIQ5RzoUSREmmFMG5UINrv+Fq257RARQ7EiNoLy5bEmpBM+A+8MT4X8Tet+QIkvY/1B5BizVwenEqDk+cEzxaVo7G80kuBrF3TBo/VQK4Wq8N1tZ0eLzRJWQY3r4MFdpMf6icTsYdELQTsDSx5IS8vgGsofPIKXs3w+0U8nXdjl9JCwdVMyjWis+mVx/7B/BF/1dCsS8bHDwdNStywmjgFwX63Brill3i0u0k62k8+uVD6PRlfTnOcSexmLZq4tDkZvY1FPgHD3rNh1nWZkR/MGkFupMBOshjLIpTdIK8g9uZx67ZcR5q3baty5/OgY7VpJ1PeQT39btNQxqvN+DhkYMtabLIgKRpkH1+KlfyXcHuNJlCJByaEFwtHVxTGc6knvHR2qS7rTF1Z
 An9ix0ra
 hZkewBPk2xVfL42K/T2OmOlLMlQWoN3nrAUTT37YBEU43VBz/IPPGP59nOqzmtnCeeDZI3JgOOVI4P8RdHgWzGPiHHpINRUk1NnY3HiAQBMs3Dk9qJHsbWM5MldIgxkhxTzUuw0Vvj+L8T27LM5dplnrGk0YHY82wPH13o8nqR+9yNx/A5aieep6kqrpFXhUgYZ2FaLyHSwglFJqponPYiquLkqdAzlydByUqA9Ps9xgu+Yp25yUgLHfhJRiR7AJtXtX6QYXRbJ8OzMPm0soJLphJ8Lq8bW4frsrw3Dplb33caVYENvvgdJQqd0SMhbd1j2hHqNBu8vIQXaoRFB3VXGeIAZ4+OlG6ADdXrDdSL5hDXIQVKI4tavdhjAcogWBpHPeecVVNerAv/oeAdWFv7uy1rJyB6H1Rxiu26rg5MPBuR0/FpYSPMgd55hY0iKhk/sR7VqSsGzmOSjyh+jdUpXuqxTcpI5CQRHj/egoiDU8Cmn8xhKRrzLXM2f2jL/XjN2s9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory management (mm) subsystem is a fundamental low-level component
of the Linux kernel. Establishing const-correctness at this foundational
level enables higher-level subsystems, such as filesystems and drivers,
to also adopt const-correctness in their interfaces. This patch lays
the groundwork for broader const-correctness throughout the kernel
by starting with the core mm subsystem.

This patch adds const qualifiers to ptdesc and folio pointer parameters
in mm_types.h functions that do not modify the referenced memory,
improving type safety and enabling compiler optimizations.

Functions improved:
- ptdesc_pmd_pts_count()
- folio_get_private()

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d934a3a5b443..46e27ee14bcf 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -632,7 +632,7 @@ static inline void ptdesc_pmd_pts_dec(struct ptdesc *ptdesc)
 	atomic_dec(&ptdesc->pt_share_count);
 }
 
-static inline int ptdesc_pmd_pts_count(struct ptdesc *ptdesc)
+static inline int ptdesc_pmd_pts_count(const struct ptdesc *const ptdesc)
 {
 	return atomic_read(&ptdesc->pt_share_count);
 }
@@ -660,7 +660,7 @@ static inline void set_page_private(struct page *page, unsigned long private)
 	page->private = private;
 }
 
-static inline void *folio_get_private(struct folio *folio)
+static inline void *folio_get_private(const struct folio *const folio)
 {
 	return folio->private;
 }
-- 
2.47.2


