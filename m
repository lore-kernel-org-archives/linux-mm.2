Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0454CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 19:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54EEE8E0063; Mon,  3 Nov 2025 14:04:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8208E0060; Mon,  3 Nov 2025 14:04:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FB78E0063; Mon,  3 Nov 2025 14:04:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25C538E0060
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:04:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 976EDC02AC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:04:43 +0000 (UTC)
X-FDA: 84070222446.26.FF65A24
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id BDACB2001A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:04:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D+isGUmD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762196681; a=rsa-sha256;
	cv=none;
	b=Es/SUywJk4qjaEY63jVNxK9SuxBwLIZvlKkw4bg0CQC2BVL/5z7XQPQ5ZTP9P7gnK8un2E
	JQIqsJ8LyIxh22uMzXEOb9+vf/p/PTwTLv2VcJDXxDOayw6tsxi1Qqmy/qhrrNlzveFJl/
	y9/KNFHcpYB7cU2Vr5Okxh9QSKZbeTU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D+isGUmD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762196681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fexCSefmQslz1ffdDiamddZkpHXIYvXyJ6JNPYg30cY=;
	b=k3JWLH021+QnS44IuBmCZRLyjS8abqpbvI56jwdvFLR0Zv6Fkq/7fr0Bpm+04To4RUyqGw
	mXSW2L6cBYjM6YcqEaWsk84G+SlZx1ehccFJ1yzh6gNLyZPsPjl01yAE/v8HTLFTNQ1ALI
	JdB9K0UfXdZeKMjVFQCy5dn6IDXpCI4=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-429c82bf86bso2258792f8f.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 11:04:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762196680; x=1762801480; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fexCSefmQslz1ffdDiamddZkpHXIYvXyJ6JNPYg30cY=;
        b=D+isGUmDNCYuUz+9qQXEMz/thXWVpNtLMvcvyTz6rR/4fG+jJSr4aEzLP9ogRUAwcO
         snW0TWPP2P/1N5s24+L6cafay51V5zGrKybljXkxpOoupMSQ07pyh5FT/uXR/yoqQgu1
         /OKXAMrQYxW3vQpMvUeM/2mFiqgoyLJMBZrWyS03BkyVCKGv6nMnbrfgJEqeKIO2n965
         YOHkBhe26p/Qq4FrmxpuaN5f7S/ueBVQdGXVEkipf9eSR06V4fucIeZQhEj/J5Z55ts/
         5JerJX6vlhWsmJZ1FPyClQYdYMB36z66+zn7+EHHyj/9JAvbAyXA9FHXes8Pg+8BXXk/
         HZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762196680; x=1762801480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fexCSefmQslz1ffdDiamddZkpHXIYvXyJ6JNPYg30cY=;
        b=v23+QqsHcJPADlJQxmN86l8pEHjFyuNqejmeUpRUR2CtDdxq1Lg3xELiK0RIcjnJGD
         KeRB/Vg89gCH0jNtDaJqVQxKgGpOfC6Y6YCuEExC2a5yPCSOOT56wA1nxmx3AadGpYed
         62neaWQCXOJDmXouKVGgoxakGin633h1jB8ot9yadZln+3rPc+w2xHCpeq/41gFHOz6m
         Do+rbU0fGBuXiAG5YDheg9qR5IXt3gwSm3eauVrdx37Tz6jcojdjRJQ8+zDaf6NMQ+lP
         aQXIjBEd48yOihOCzXYVR4vL+pgccx2DKngAFPf/yTOSf2Yi14C3BEshrty7WHUjKVgg
         zc2A==
X-Forwarded-Encrypted: i=1; AJvYcCViLiRBRw3i5vYaFBq+0/RtFlFbeAXf5ZobiF7dGl93r7JOHInZwJ3C3VzS4C1ZlySwXtitzRqHbA==@kvack.org
X-Gm-Message-State: AOJu0YyPAMd2Pg3KbkdJXKYgaf4ntpRCRsrB74E0zBvHYFijMgziMhoa
	qal/vNKq5QaiCjGVLWdtvV/9wWDmi4ZhhP5t2tDME9SkJht/3q8esZrVnBroGhI1
X-Gm-Gg: ASbGncuLHbVubcL4HUb3XrGWEcRytBfugFG+InGqIV0j23CItucG31ee8Mk0EuzV5UY
	HJ4LFfD9YNuJPEna31Of+znPE4BHNaOjdNoAIwJZTK/hgwR8ZTuL1Gsy9JllXcHRUJKnp6bH0iN
	W0cgSfYx2mTKjeh6/RAkWQlQYj6kxW57tB5mkne31dRNNAmCNpQC+otOLde0t6eAQHIexvz15St
	0peZ6XG1nU2MvpCPMJDO3NRW8UTJw9E8V3GyMaKMFKOMUkeoCEzw+bHUlj6Jbd3BmZmZFV9V1nY
	0RRSpeFB/SHDaCfxSSc5KoFPZav98qVHhuYR8l4om01ro60GLmhLLJAg6dLUBBKjMy7hfUbtwg4
	HmtT4BIWPEwp/RoT/zMqFbzwBKOE6eQ8duuLgJwkjFWRnVCt5iy4zOb38xvTxN0Kdw8dMQdZ9Kr
	QgOxoXI3a7gYM9DjPTearQZgrjnSk9gctZi1HCSPKgXwph8OzzNpSCSARqogpDpA==
X-Google-Smtp-Source: AGHT+IG2fVh1qN85r1cd+mUxA1KUwJ+pMLth8UL6voFWjtFCEOmLBM0dU0z1uJI3EhqKm0/d2PfG+g==
X-Received: by 2002:a05:6000:2383:b0:429:d495:7c8 with SMTP id ffacd0b85a97d-429d4950a5bmr3272773f8f.37.1762196680030;
        Mon, 03 Nov 2025 11:04:40 -0800 (PST)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-429dc192ac4sm327407f8f.17.2025.11.03.11.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 11:04:39 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RFC PATCH v2 0/4] make vmalloc gfp flags usage more apparent
Date: Mon,  3 Nov 2025 11:04:25 -0800
Message-ID: <20251103190429.104747-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BDACB2001A
X-Rspamd-Server: rspam07
X-Stat-Signature: x4idh7er3ij19bzmwpnqu889cbekq67x
X-Rspam-User: 
X-HE-Tag: 1762196681-720318
X-HE-Meta: U2FsdGVkX1+n5eOsc7dPbuC545NVOpBhFdPOE9fJ2l5UFuj2TULQhfWXuyMumop/9mhMUYw2Ga4bdg/2OR9Msp5faxn31bQ7hzqwE4ztdG2L4AoEyAV5jvh2Gmsgy0SYQDfyNBV30NJExAGKrn/nZGplVv4/RYx+VhEtNg+bSM56YZ9kwPMAzgbmQgtpxG0dR9jM8AuRjrSry8CicAWAd7RhpP8+TRTPBHaADF7sPm627IvfZqjdWwnDYUtqFOHxk5XWFjfbXP7Bkp0teH1o8ySOscsf1GmxOR0uf7jUGdvKejRBc6SvFTYlu5T9PIKHWLh9HaAnc8iVwI3oypvhc1rk+P9xVbTxDFkY+oZvQKa9vBDfoApvOy3ntiMcQQDJCY55m9blExss85ItzsmUObG/rUPHllNpwbrOZybRjt+7oAwqTcvr8NPLLcPLCyy1UZdpRfs8aH58LTppNTXMxR1aK+mfaKHqIUdkRGWPc4XCY904yAdNrIqP1chK3GI0d41+tPvS0bu6XOi72b5aTeS9SahIloEIKRT/52fYNkMYZxGf1nk3qjdcnuGb5RZ339LvOFhfYMBOw3nQFyjQgPK/rzCs3WOUeC78k2ka9IEw1dE70hwhnJcXCaL5odqdYbNkwEoeCnqxXeeBl1GDs6hs0L1/BBtXuHOcVfXHmuzK+WOXR3RsX1z9+6DEjzw8JlkDATpQG83xAS6DGRdhPy1QNynHt4OB85w4ULKoFVliCPWQPaSpOSL06vwvgD7DOqo67lxPP/EW9LFYX37VWo8P4jp3MhgRn+vuR/huVjIynDYUQR6BKWkg54yqO2BjPBySI8LTKsX7xTNHAEmYr3UXK0WhX0t4VncScuhVYt+dXiPVjxu9jr2+wUR5GPpGdgioJaZSQ0v0eMK0wf6jWHTizlZSvG3kQP7Ziusc3t0/VQpGzXbkRzcx/r7GdY5PF+VnOBkSSect3FPWeEg
 DZhpproS
 GKBpgIcyux1C/7cwnaYfO7CjhEVo4HHdQOlwg2KEgNX9ZZRNc9zyBrhRa/H5CK2+uiPDNH+TXN7V32teyjM407lJffQhEc/QMIxt4X+B38Xkh0HZj6bH+MFzpMnClfPM5JgF83dY3a+48SgBg9lG5dZ21o4guIokkdcWKt8Y9Ga9vdDvq/tEedvoGikPW00ZwKDYYtdSwjXQYkXtXCIxRKmaCJNIuP/gK1v7I/iEu3JOewGFWpRQb8dNBMFIPLZUitVxzW4u07jQGdsXa2RGh+SeP9425QShs8EnesOT89EO5QRTN7pe39oD2RsIlqmzD8imVz0pQSk91Vr57jgFM0WmpiCDdrzNXfPBmO2nt5AkUM2ksOA0tMsUY0O0fqJ8IhuxlSwrp7+Gj/dMvff4yuY+7ElBimVYtIiFnmDtpySG04z2Vzj9pz9RhIgcDie5j+0tn8+ARMjukpRY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We should do a better job at enforcing gfp flags for vmalloc. Right now, we
have a kernel-doc for __vmalloc_node_range(), and hope callers pass in
supported flags. If a caller were to pass in an unsupported flag, we may
BUG, silently clear it, or completely ignore it.

If we are more proactive about enforcing gfp flags, we can making sure
callers know when they may be asking for unsupported behavior.

This patchset lets vmalloc control the incoming gfp flags, and cleans up
some hard to read gfp code.

---
Based on mm-new.

v2:
  - Whitelist supported gfp flags instead of blacklisting the unsupported
  - Move the flags check up to the only exported functions that accept
    flags:
	__vmalloc_noprof() and vmalloc_huge_node_prof

Vishal Moola (Oracle) (4):
  mm/vmalloc: warn on invalid vmalloc gfp flags
  mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
  mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
  mm/vmalloc: cleanup gfp flag use in new_vmap_block()

 mm/vmalloc.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 8 deletions(-)

-- 
2.51.1


