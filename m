Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DE8ACA0EE8
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 14:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50F338E0007; Sun, 14 Sep 2025 10:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7508E0001; Sun, 14 Sep 2025 10:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423BF8E0007; Sun, 14 Sep 2025 10:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EE4F8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:38:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD63D1A0367
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:38:04 +0000 (UTC)
X-FDA: 83888110488.12.C1A86C2
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id EDDA1160003
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:38:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757860683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=RmvHTqHdaE7BmVovCvT1+fW6WEaXEbDVIul7sfnvtOY=;
	b=PvsCsTWtWvgpXLxUSg1IJyNvE8qYJXL4CyaFySWDgr5MFQ0YHPMuXoxZD9ZIhQrRuXUG4U
	6ofLQx4vre7Xdp6t4e6/tm9eQfTfcOy6GBfp4Jw9/WN9IggoSD6SEUKgzXYTe9vW0WCqT3
	C33QRiKd4664X4S2SQvh++btOOIOvB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757860683; a=rsa-sha256;
	cv=none;
	b=iPyptOixGHuUmkDB2a0nTZ85KiPga+mAXumAIu0O4BnoCmg17wexgoRvSXlnIyTp0n/4e5
	WzpFQvni08VCM3vpLWwZN80sZPGrd0DuJ+Lb4XQTWgwgvKpCF/+tj+0IOH5emXQNYDraQR
	g6K9ZAfpvkxAmjIfCm4ul1dd6K8ZRmU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-26685d63201so685585ad.0
        for <linux-mm@kvack.org>; Sun, 14 Sep 2025 07:38:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757860682; x=1758465482;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RmvHTqHdaE7BmVovCvT1+fW6WEaXEbDVIul7sfnvtOY=;
        b=e8IdVQ4V16p8/nsZ/t508v9ckUlQWMQOkMikYUhdcI4S4Yl0nfMQOtgQjaEZJxQ1j4
         eYtN39u+p/wLtpsjfl9y8Z3/XHR51vDfL5pTr7rdobrFdFe8R8luH2tS8AHM/sEvdd3m
         7T4x7GlOW4K+K94f4fj+2mD4Xb1rMcvL2qf/miLXuJ14yXi6WFkj3r/dtJHqGm58Z3GL
         OQP157ozuzf7In4AifT2sGzP7A6A7pqu3g+nSwFsl78n89l3mfXXeJxmLUfmv0wRSiyv
         v5qLiPOKuuB8M+TM2fWmOALeJMUwKVAJe/Bk+8DmuETJZLk4RM7H8s+/WMr/rUmq0bFb
         HYIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXd2Q5AXwsCpsrCgURP+Ak0TQjCY92oRC+heUwFKfcwvVD/qLyPic0Bl9jW8Jt5J94p9XZOKBdJw==@kvack.org
X-Gm-Message-State: AOJu0Yy6OfR4ZgGOB9RY6QlNVSFjohjT3aiZdwctBMJibo2xdQR3SgJa
	N1kz/6qdxpQ15xigH0pirBdEmW7GPUZjRz2N3nnsRK6enVlp5HAHwvuc
X-Gm-Gg: ASbGnctYorqzgpnz+i1XWy5DHe1kloKhvVXeUvV5nZmm04LjiZPFTeWVwhMTjzXP6g9
	ipCafK0WdiaDgmX2+RloRfMVmyyEJGrheGIyVb7MGE3FP1m3SH4Jxv6ekL9x/Ch43qwadw49Bsg
	907KyyNxZjVoOc54x2ySeuqdB45y1ZMc0scAeJfClt1pGzMG8fAJgP3DpkiUl4VlItvB/XifPRK
	jJTl/ktkoR6aLAtI5/Bw0gGo0H3+DAm1VAwIW3P5jxt4yyiascH59w1dGVLs3go0ZaL3HA5f8Ua
	9m7+GPD6QAqS7zGEagnqeE16G5003U9XjHOcoh+FnB6Oa7XqQWFLTo6AjYwUrfygXfoa5bRbZMi
	SOS3Pp00oNxSMiR4dLWISV4YJp5O/C+Cz
X-Google-Smtp-Source: AGHT+IEgy5aUMGrcJq0MScnJLtTMl7Y1Ye9tOVXxymZvMtyMYqBE1aPfDaPaJfRGuGgTJYfRp2tS2w==
X-Received: by 2002:a17:902:e78f:b0:25c:8005:3efb with SMTP id d9443c01a7336-25d2703b924mr119351345ad.54.1757860681783;
        Sun, 14 Sep 2025 07:38:01 -0700 (PDT)
Received: from localhost.localdomain ([2a11:3:200::10b2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c3b0219f9sm102571545ad.123.2025.09.14.07.37.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 14 Sep 2025 07:38:01 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-new 0/3] mm/khugepaged: optimize collapse candidate detection
Date: Sun, 14 Sep 2025 22:35:44 +0800
Message-ID: <20250914143547.27687-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EDDA1160003
X-Stat-Signature: xjroq41jbttesib3d91r3skase6r8uza
X-Rspam-User: 
X-HE-Tag: 1757860682-241908
X-HE-Meta: U2FsdGVkX196S1NB4aHFyRoZb3Jjdc0WbTuagVoj2GGG4WKBmHLGr2SqS3jQQwTodTb/ptO3tbVM1Kh/izlYKQQtCRkz8JtHN5CbuRUjpE46DprlbYmVPwiveYSd8fEKfVlllexfvEljvAXxRjohVOMjzHRsJzfEsKgBV3Mb79a2xUoYFrLW2s/bC5XR71NfNErkDDQus+lPdxyQlnmGYs2mauL9r99aZnJo2DEHCen5namIJCVX1n1pYjhqf94HNz6R6hLMqBJ67HcIuG1FcU9QgL4Bmj03p8xqQzZmoLr55oakMAi7/q54XfP6TVZoIhbKB1K+FLvEgi3EBWmPxT2opSHQHxiJ9cTqlJdrPWyF2ib2iE1OGVM1ZeX6qBkOH8mNlcMTujPdYCKg3v1FCQZfsZkeG0G1l0JqzyebMFLD9e4Jcu/Qep1odLndvnkWBSJoVG3/ByRQshnj9awcmmBWS8VWMfT5FK17JMVqVz7PTja+B9UCevxZ1+ox8hktXpJNjf/hMFWn29gpVyisN0XZKmmmVA7Vd+ioX1a7TgGpRIqEmpiY6kx+vYF+ywiNG3MkPZfDcg3fGw/r9X4LwofEd4rqIR9pvFhF7Y4jeyipc7zKifuXhgeYI1gCMnZQPfJoqcgmKkCQ8aD272o71tKCVG3oBV5zpwsClstvCgSV4nNfuffvjLXKMHMTm4+MbEw0QgdYRgatWCWJCkOK7nPTtzGqQdns+ZGQ/Y7PDeD/QtN81TodQyVBYkaZIwGZvqIscwqMKqeUz/myAo1gYQGoKNMpO95QsanFT6ptC7bGKTHgdPuFoJDcZfkqRCIzlEyudRTsanniVzNKfH7WWNj1J/77l4+H/p16eJaa3RfGYnvDq5IncprZ0HppEPBJhzaxYplDClhbbthuiTha+NI9Afn5OSHMZuL5/1JZzpPA0uPQVJFRzpe+VXhWJBoOCR4Rjt4iPk9WgUsoZ8f
 F9b5ajyB
 4DYfiaK+ERa93uL2J/W6DDY53EvZMRYxr3p1R/I3t0haoI5eu9vkg8eUoQJxYIil/M+VvLXyCYOM69iF1ANkbFiXZaEOHhiJzU3lMymdBgWX2Stkj2A0btgNj2HFVKeNHUJh6MB6hf37aDfUHTKtf9l+KbkJTDme812SHNL+atHbKJ+hkPpKjNYgtsYqi0t1/LIJn6bG9Sc8Lj9afTXm+dVlkFzkVE//8SfQPX8MEL1AELjoroIYLOHuCutHp9VG5zCERrdW+Khqd1bCOxXiG3i/4JGqqs26JBmDQXie+n0FFndb7AAac8bknqekfjAZBPW2OUV12amI1vW5a8se5nvRrSSDQdCnOSJME70uI/mL38Ws+5cmZc6q9I+cFEtw2ml/CPQER8p5MdFJBSQSyWbp8C8OFpoubTM0NF4gcOKnaCdJKEnnmSWQbBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series contains a couple of small optimizations for the scanner. The
idea is to detect unsuitable collapse candidates, like mlocked VMAs or
guard PTEs, earlier in the scan and bail out to avoid wasted work ;)

Thanks,
Lance

Lance Yang (3):
  mm/khugepaged: skip unsuitable VMAs earlier in
    khugepaged_scan_mm_slot()
  mm: clean up and expose is_guard_pte_marker()
  mm/khugepaged: abort collapse scan on guard PTEs

 include/linux/mm.h      |  6 +++++-
 include/linux/swapops.h |  6 ++++++
 mm/huge_memory.c        |  2 +-
 mm/khugepaged.c         | 26 +++++++++++++++++++++++++-
 mm/madvise.c            |  6 ------
 5 files changed, 37 insertions(+), 9 deletions(-)

-- 
2.49.0


