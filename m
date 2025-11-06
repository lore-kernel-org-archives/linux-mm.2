Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05E00CCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 03:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340E08E0003; Wed,  5 Nov 2025 22:42:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318B98E0002; Wed,  5 Nov 2025 22:42:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E198E0003; Wed,  5 Nov 2025 22:42:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1299B8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:42:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEB70160553
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:42:01 +0000 (UTC)
X-FDA: 84078783642.25.4B061C1
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1498AC0012
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:41:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dmp+qLrl;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762400520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=69VGn2emQKMNwciXwHJpHSNCMdWsKnTmrJEDYhLDAfc=;
	b=J6sVB1Yqg6kOJK5WgLs3wI6kUtnLaWeCEDLrcCvjnOXASudv1McbVlVDhrK5rlHSkegXx3
	5nopKDAZmLnuDrafp4t/9ctSwf4HruimkdbJDtwaxbwaB5x/hU9R+m96ZWypHv5z+pTYP9
	N06PqwXm1OYugdLeE99cwH8Ej9behfA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dmp+qLrl;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762400520; a=rsa-sha256;
	cv=none;
	b=1oBL6NZAJBwjKZ/jcKVdj6HNxtPzeRcDEsXJoZ98S4REHU2BZ1bR7P5QFG5r/bIFU0jB8O
	Agpj1U/Bi+VwCMPG41J6XnVrGQ1+kGPAsdMbIJo+3rcqxbW8fux58wQWyo4L2djvr9DbRF
	j3Yf8MeRLtp0xloayAK8iPwWzD1ouUI=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7260435287so63762366b.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 19:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762400518; x=1763005318; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69VGn2emQKMNwciXwHJpHSNCMdWsKnTmrJEDYhLDAfc=;
        b=Dmp+qLrljK2heEqOIcI+cgu2JLO6VCZViiiRRGcKiQc6jxEMeB8I+Wq62iPqr2FXyz
         0WoMtCyDdfsDwLNIF85sus1QFZpoV1MlJGWBiTnry82SVH8ZgY3FeaTcIdZ55jciOxSx
         jIX+80UJe7XRq2Xaaj1QYF9bqQcUuznF2ADBUEQm5SteTpuFA8BXO5xtJSBXk9dacjqG
         xeacJK9svbAbLDM7wlAXxUXH1SUyhUytGcv+crlWrJ0UNufTFvuxUL0aGqSfy0SshkdU
         3mr5n01bGi8Jx9b3vLzqyFEL2EGrkjlSZV+w7v3vc22ds5KEYRL1KLUHmClX+Qi+ecUM
         rFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762400518; x=1763005318;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=69VGn2emQKMNwciXwHJpHSNCMdWsKnTmrJEDYhLDAfc=;
        b=UmxVGFeJADPq+jr21IOgrXAVw6fUnA+/SN3IRo3Naq/U0v8LMocheqSitGbLcblmdH
         O0x3LHpB51qDtRwa4qOlxgw8/x1zMi3ibyjyouWbalbgo7Eh3W15cExnXnkvBPjoltAG
         UIR4x1QPIdI/9eRKIvFFQP1j1+b5MzYLwo0vynRkoEGuNxt2PoPlVRhu116qyXHUm6b7
         tiCn4BdFSl0z19YcdNi3gVAIXHm1t6DY/yK7L79Vdy0otwKvl7fgqRIh509Nz4Rz1X1K
         B7FSk/+CahpZU2BatGX3uk7hOW0TvcBpG2kgENoj40e6tlUpTXT7vnbptN64gmp9rY1a
         ELlg==
X-Gm-Message-State: AOJu0Yx7ODCo2Yspk3SlERYBKGL7QczM/oZqSvkvZc79bpWx4cgSU4D+
	uhbyMI5jzsloiGXewbZqFQ3/R9Gh4jQ1MLC+uWLevPtbkhdeXF4+uZgD
X-Gm-Gg: ASbGnct5CZGtbXo1Dp1ui7Ud5NC3FhA21iM41fH/eM/VIvHqupOZsqU50ZF+hffh65r
	QXct/apYX55FA5tMfLMVoZLsnlq6o3cezReOnuYaOsCheYvwmWKVWmUCpcY71ns8dlum32Xft7l
	+akLLUf5M94IKyGO2wtGGp3iBLSMX1Oo3kAg/P5/he2RbOk8bbicHv9S9Oi/MKC6WCoPrXTUYVO
	DmNgTG3qaE9vPzhNamH6SNicp+TUE3NDUGvhu/OS3WPL2Bk0mCbFIMyzpHuA3kPWOaZRQOl/stK
	53HEOYc766Be0drincy4r5P2vVbP4A+iitfraUP/RW2QuPRhtfasZtt79rmdSc0ZGnI+snFM57S
	B7Q1bx3UXy1BgSBQ8AJKSFEcQWjJ9T+dGGtAGPLbA08L+96vVhVSrkRmg64rVxcuH2tpYzbHL1I
	RdaM7cBuetzA==
X-Google-Smtp-Source: AGHT+IFVFphpq0AfC+J/LvGQ3FiSSxuHUgCjs8O4dHT0Yrgrw96Opgxfj7Uqx5dei0d6uKUisfIp7w==
X-Received: by 2002:a17:907:3daa:b0:b3f:33f6:fb57 with SMTP id a640c23a62f3a-b726519a2c8mr578907966b.9.1762400518175;
        Wed, 05 Nov 2025 19:41:58 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7289333303sm113722566b.2.2025.11.05.19.41.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Nov 2025 19:41:57 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v3 0/2] mm/huge_memory: Define split_type and consolidate split support checks
Date: Thu,  6 Nov 2025 03:41:53 +0000
Message-Id: <20251106034155.21398-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1498AC0012
X-Stat-Signature: 7cr8dqqxgbfhfhy8617o7z4fbjpheu9w
X-Rspam-User: 
X-HE-Tag: 1762400519-210032
X-HE-Meta: U2FsdGVkX18zByXrGmJepwHSGFQ8hugpYdXoP9BUY6cl3PLIn25CPZjf1fwvrokZHjgQaKohTuBKXfBndn/0FL5xDWUWJavg4cTGTzqvkZJhh9PBYigoVcMgg3lfZA/L0wpWY5gWoPccxT8xfGJ/jlk+BLWl7XkX0VzaS+Fdcs0EbLdvrReRNDo5LIoqtiVL4MvbbnQU5FO6n05pSAcaHMIpdwrcDHQsT1YoYfQqTxAG6SdU0uPoQfZJOjppdAZV40r5zsMYuSP6p8xgvbFZ1fNMHhq0jGYNbpU0BYA7ixUiywKxjqQikJdhKWw7QLqGbo1K+05mqj5hcRU3YIK+ZDRFy7jwWurare64AQlwIVnkp9+U/EZwrk4QtFA8lEy9rTeVSFGsvnNIOqDywTn8v1nfMcK/Oht5OXA4NsMkgVzE6eUZQOUzFmb3Ocy+DCO1dpTvMBdc9repgGv6rHK/ZUGuqT1VmoSizb2RnYi9ChUyT8wts5cd+qmcE+jNRIIR15bpWG0cu1T1OY/faOnfIoeqO+AQtMTYMVX/S/ZwzNbON2rFtdqiHruEzxrtdUIoOH4IE8FexV8jGLqb7zM8WIgrU9K+YPOHZqe8D/CYXMPMo9qwdpCBznl8UmTRPBUgPIXHBVtmHHinBKBAEekIUVoMZLFr/YP4diUvv/6tYOJ9TgRggNewWKDbm/n+ZnpogME1UZKt1FvfVuRkFVrO6JrQCdFWq8IXJE8ui1LbJwSDBmu57UfNP+KzWMLzsaLmx0gao+j+KdMHLookVQi6FJUTq/WsVaznFvjXmBG0jGX7Ir3MbM7CgsjUjWdagK+07wBxjkAcs+c7jNdLtFmyf5/MqdHHSw4K8Zv4gPcSOjO62UsmWWgJtoW0WRRhnO+HDXojN6UPi8q4sR0WhdQlTJwfo/0+sgTgkpAica5enCd7iXgIAu6K/ZsVP81TaylVhkI2EhWFWsNgdIX9UW3
 nMMxhItt
 bbdlKczLNnJJs8Xv4ZCv4pHNxG4+32KnTUAXYwv9RNxB39kMjwdLIKOsbSuza1be5UD4svuBSRqmtXfAM1hY3jVUaQwM2nGSBzPjC1hDiOk2zn3VYmdJnVu7hNlmtH0Ykl5G3/Z1QBA22+0uGA1HXBY0HRE8j0C/hCm9rkQMfCU6cWLRSMUDa0w/GIVQv/yoPBZzv8clpiKI0bitMpvo+L7RYnYtljIsAcVEAbtJ3c8i1ZJ5ZMDt1o9hf9aRIkZhJ+flh/KSDaH2RVROFXyKbPZNVO2BKSFolb+ENycuPQOPdOkXopx2DqMPOxPo90YPYy21WrAq4qNmFjsbIxgSyvZxGZfpmjDGRL4um1OU2MFQ1BL0U5GQzfssFAdUeO2CC4MBHCrFMB8kIIUNgFtfCt7TJlIA58FbHZO8kk/8sg+Gb8Nqf/f8lXI8l2OJng11d+NV9yjUDiHmc2qd5J/muUEsVu+bb+vX41bcPapGfV0R8X8FR+igsbzg6nNtxEjC/CP7H2+SjTGeD31QW1RwjiR65uRyEYybmdlTHokUCrNCphUVxEK4ibzdkZKWYCFdQmB03Eob4nZfWA0RHTh+km80IoDm/avjPXVcJ7v3RollT8ranaFpZe9M/PQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This two-patch series focuses on improving code clarity and removing
redundancy in the huge memory handling logic related to folio splitting.

The series is based on an original proposal to merge two significantly
identical functions that check folio split support[1]. During this process, we
found an opportunity to improve readability by explicitly defining the split
types. 

Patch 1: define split_type and use it
Patch 2: merge uniform_split_supported() and non_uniform_split_supported()

V3:
  * rebase on latest mm-new with Zi Yan fix [3]
  * introduce split_type to identify uniform/non-uniform split

V2: 
  * adjust comment
  * remove need_check

V1: [1]

[1]: lkml.kernel.org/r/20251101021145.3676-1-richard.weiyang@gmail.com
[2]: lkml.kernel.org/r/20251105072521.1505-1-richard.weiyang@gmail.com
[3]: lkml.kernel.org/r/20251105162910.752266-1-ziy@nvidia.com

Wei Yang (2):
  mm/huge_memory: introduce enum split_type for clarity
  mm/huge_memory: merge uniform_split_supported() and
    non_uniform_split_supported()

 include/linux/huge_mm.h | 13 +++---
 mm/huge_memory.c        | 97 ++++++++++++++++++-----------------------
 2 files changed, 51 insertions(+), 59 deletions(-)

-- 
2.34.1


