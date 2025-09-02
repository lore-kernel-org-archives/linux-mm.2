Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA2CCCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78168E0016; Tue,  2 Sep 2025 11:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964508E0002; Tue,  2 Sep 2025 11:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F1F8E0016; Tue,  2 Sep 2025 11:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6540E8E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:57:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E894118E88
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:57:57 +0000 (UTC)
X-FDA: 83844766194.20.4B1630D
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 68C9A140006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:57:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KN4fCSAi;
	spf=pass (imf23.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WazHtu/C+Ki5N7AOy13THFKawYgRh4R/pKoB6roqKlg=;
	b=1RYW5zzyuM1PXUAUx89stqQBk2OStMMZXsOlKgt52Ra3F8lmcD5u7V/+VuYSW9rf3+MOWn
	mj/eYM16piqZsWbjSyJQ+Krp8lh5ZJ1DGOz4zO6gjsFreLaqbA5aWhVDxl19YWXwSL506n
	nfkJ7ubRD+mF1NnRKfXnF1pIql6lr14=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828675; a=rsa-sha256;
	cv=none;
	b=hNB1jqZzjrW/kyyiLTNLyfjBpRFQyR9FAA2w5ZivK0H0nOo0rVq4MoSUwnqnSrHGiEO+qN
	segps4rh8KY5UPTEuO5yE3Z4R3LFS1IpwM4hUZcJmOcmKb8ZG7IvFypP7RNX47tRQmLZ6x
	pe6hUMYHcxW/RPiWAqA35JLrVjlg2YE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KN4fCSAi;
	spf=pass (imf23.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3cf48ec9fa4so3028328f8f.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756828674; x=1757433474; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WazHtu/C+Ki5N7AOy13THFKawYgRh4R/pKoB6roqKlg=;
        b=KN4fCSAiiuuFtCLib3I63si/kmkQVBvFF7ywV1ZWnPAsd1GpOlfdqzOtreJszcTodB
         Y6ohlxqGx01qlKjmiO4yxpD2wy9RCHFsspNzV+buLp09Fva6wwhpDxuh/XtkntfJk7EZ
         hYZz+Y5cCasaNDRXmWMDiI8rH2VHkhaGJjM85MtNrVSgSot7zukD8yUfbxQe60yiBc2j
         mpFPD22CFRtmruElj+fn372e1JT0sQj1ePmPYA6D4q+hWgn8WDuqrLxfHWHjPSSoPGDG
         hS+5iA6y9JVlVzTXRcKVsQS5LpcdIh1LyiRWaKcVCjiMTwgQTEFn8qA8qFCh4/djg0E7
         1/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828674; x=1757433474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WazHtu/C+Ki5N7AOy13THFKawYgRh4R/pKoB6roqKlg=;
        b=diwZtxfbqQd6erH0hyDS8NpQup9q/d3TCpUIpayr72GwkZwu3z1L26Grg3GumagrY+
         JM0qaPfy3NR4Frn8FXoPZnsANqvAlzJKnhDbsJHZy/lrjKe0HYTK8DMlmNPV2MAhttKV
         MPP0xxvfuUW4UBv/PL+fi1YxiRkk2RbRvioiLKodMjHr/ScQA9BpDL24HAdsmarg+m9r
         i+si8f0Va/4FLJ3Xk2xYb06rz3glDitMAOJHpnjMAyxntFxVraYx8VwYM6XkmRNCE896
         I9KeDTqnAyLnGyQAlmNqHs8KirTKhmCf0QJam7fjJ4HikKxd7V2wx4M5elk8RMylnY/p
         +Mjg==
X-Gm-Message-State: AOJu0YzU6LQT9kGPK+CooH6gWCpYqAU3NsLYzhSWDwodIWBil0dUl4Rv
	mNgMeVXevU2SPld1JY6F1l5M8ICKS3tYC9pxCfqgy3wBntGpL2PUPGjJ
X-Gm-Gg: ASbGnctckzoLLW0hbMQyrUXQScqKeGFQsY4p47XQiMW5zqXJhYBGaK8pnT6Sjtkr3BW
	OYABwtwFnpv9d3YbFjQAoXBO8jynYii7Aqy/2vKwjThSXDlYVM98BbO7+HVsL+d63VPULwVqkDI
	ZQEAe2LtMU3azoJ1uWhNXj2pjTAjE6+SDz0zJ95ENKufAgw9A41rQppBVXKHFu5kGQ9majJyepn
	1uLkzgkT0A5N+KxYqO+6ZAXHhLyeXXhHZDwSya9TCxICYxRK/dfczHFKWpH0fjhOdtbrIxeGbRm
	C+ryHSXEarrPu/6yvua9EMVGcK1o8OI58NhWj+hugefkUEFl9ISLESkwJuKUNah41vb57/zo+9H
	ga6NeRdZ9+Lspvw==
X-Google-Smtp-Source: AGHT+IHcOAzz8VVG5t22jgn5zsII5Ivg87fvqkT+HcIozssVkQ/DPJiq41qWcCUdZRNBTyTiCd9XHg==
X-Received: by 2002:a05:6000:2811:b0:3d2:25ba:e7f9 with SMTP id ffacd0b85a97d-3d225bae9femr6067898f8f.46.1756828673800;
        Tue, 02 Sep 2025 08:57:53 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:8::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf3458a67esm20193336f8f.62.2025.09.02.08.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:57:53 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm/show_mem: Dump the status of the mem alloc profiling  before printing
Date: Tue,  2 Sep 2025 08:57:50 -0700
Message-ID: <8dc71d31de53afa4c0bb25234807b1e6ead5ba55.1756827906.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1756827906.git.pyyjason@gmail.com>
References: <cover.1756827906.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 68C9A140006
X-Stat-Signature: qdckeg9u47iyj34i5438iqsouozsw44h
X-Rspam-User: 
X-HE-Tag: 1756828675-361889
X-HE-Meta: U2FsdGVkX1/jzM0kBvEZnv7BYqL2IBp2LFoR4yL0Fgo5jNjN16Botpys/xqzJ6y9cI3RQfsH4hq3cz6Grlt0X0m/oNeKcjVQ6lzQiazbezRegieUypR/GJilXSlnZA6i1s9+i4rBMFaUnk6r5VOTvX0s8DTlcsIqtspfnLgDLrVfuZYOuqfgC03e4boaGb62p4maur0ymvc2uV/jqUjVc+aL+ZGUoZPQx5NrmKx8pQ/vL3S+M+xPj+0cwM5qbpxs4p8FVmdJxZfUN7Eta1+J/NahhulgwBMIknli8UnteqTg0bttl0OKW+0RqPA0O0SPq4KBq80+xmotOw2OxQSfV5Eqbt1YawF7l3gYyRSsh3Yb2S1MWI1kEMDqf+C992ZCTUkJ/OjO4P+d0axIU1Ndu+EFSpLmswmUspqO/KSu8nsNfH0qNxHoFTFHLTrMEx6yYn5aTh5jpR5fm+YTFeRCzqT3v4P+eMUoYJSaRzXz/Zco8n2wI2i8VzOmw9AVgN8Xrud+TcmwiIYfcqkWFWsGUjgEKsXKAIfBX/0RLQkhhKQn3L2Euiojyh2syit+3yfO7sHOcfiiF0JFetlHtgE8ajHM0UUpi3LHWr6spAFNPWaaRcJU9pUSse9clfnwbnzSgzPHjWfmCUmNFoSiL2Eo2aY6EIYjzoFFMYsPSdyqPY+7aSET9l2ob3h5RO7VTJibqY0LBGNvgjw4LGHUd1UjNhA5B0xvCgm/HGKiGQpqacBGh4Nctiof0tahPm+dbmELcooJmwA9RBH5PUDC9Wohv/vRQ0QMshJGAwlt5gkoroj/mMeiXlBfMW2qV+lfAp4oMQ3EI0LfSYRebF8MhiJNV8a3owZie10EOjTQAy07Flmx/8HpdpmUn2TiQg/k83QMLBYGXFs2qOAw2zgUsUohhGnossv5VJeYmISXfB+MORxmT9JF8qBL7feTTtLkF/GoQJDziUJyImvxzrrqbPM
 mHOeyAjn
 HaoxgdTE8pebt0hj1FKZc1oOBJ8Oc9tYRyppl9XMn042VMbqw25yClGN24AkmzKmQ07HZ1wK/6DX/0UtVTWnrClsgvrqsq1/q/k+2Hq2Qfb4v+G0kYKdmVUjZIbMKHOpMv/cQrLxoPcZSAdLn8NI2Jj3Kl7aPTlsGfHzd/8CIJj1WsqoQOw3dH4/dQJpMvdcFbYvztZvdTyZSr2mFXdt7L4K5ReCWRMtt3hHd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch prints the status of the memory allocation profiling
before __show_mem actually prints the detailed allocation info.
This way will let us know the `0B` we saw in allocation info is
because the profiling is disabled or the allocation is actually
0B.

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/show_mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index ecf20a93ea54..51892ce2efc4 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -427,6 +427,8 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 
 		nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
 		if (nr) {
+			pr_notice("Memory alloction profiling is turned %s\n",
+				mem_alloc_profiling_enabled() ? "on" : "off");
 			pr_notice("Memory allocations:\n");
 			for (i = 0; i < nr; i++) {
 				struct codetag *ct = tags[i].ct;
-- 
2.47.3


