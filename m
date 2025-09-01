Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96105CA0FF2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 02:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9DAF6B000C; Sun, 31 Aug 2025 22:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4DF86B000D; Sun, 31 Aug 2025 22:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D63E36B000E; Sun, 31 Aug 2025 22:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C23806B000C
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 22:09:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57DB2140612
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:09:10 +0000 (UTC)
X-FDA: 83839048860.18.EA437FC
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 761DD80003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:09:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I+INxwal;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756692548; a=rsa-sha256;
	cv=none;
	b=zYXs9nsEOjLJ0Y/Z0KuTXxioRz2kDVgVkZf0Q+9aZsh5RVik3EsHtj2djCvu3knOqgihWm
	2J7+Sk9V037t2sPV5jen4B4S5Gbw4oB/JKRVHBCOSnDOUjSqYwdsGtXQ09FqtbR7Ba93J7
	AsSSgXeDEenKK4BCENJFcEIgwswU3zc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I+INxwal;
	spf=pass (imf30.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756692548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucEctInuZvUNa3JvowQkVMa4HblV4+0edJR4XUz791U=;
	b=mUIjplid7L0mBvH0pdQCs1Us59O6ov3oYWo4LP1riIKQxirjApAnyaemO2UiWFZDOfNITU
	ISVNeM/bG9vTDfCRFhNHu/w1XL79XgVZsh1y11vK9edGYAfcABpHR2YfrCdk8VYatXadRA
	HBwy4hssGcfiG7HcgN3yPmgD1dXaaaA=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-328015abe0bso1880857a91.0
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 19:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756692547; x=1757297347; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ucEctInuZvUNa3JvowQkVMa4HblV4+0edJR4XUz791U=;
        b=I+INxwal52tz1eVtB/P2/xUY6dIg7SiQc1M+l1fqp2LF1zIy8QYLhJn5SrTi/psvuQ
         MFPjrwEX8upFs1ssNNKH8US5Aj9EaVQBon9up6OEiJaVH0448G+Hh6JpOJcmS3goxhDY
         k8EAdMSLwNDPSLhBu8n7djL5ewdk2mRKYqRAbpY/M4IC/ZVkbq73KZ82rG8N1S9VaOkt
         c0Mljt36nIyU93vABzb0jCt5G8aUWlSbG0C6m3pCnGkcSsxj80lgLXs/gjNPZ+gx5VQo
         /RNpUyEnMAEy4OpZ9F1B/xKIrJ1aAKkUMELdKBOQsSH6Lbd+V6l3Wq3Vgl+BwK+x7HTL
         pRZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756692547; x=1757297347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ucEctInuZvUNa3JvowQkVMa4HblV4+0edJR4XUz791U=;
        b=mdfzLsY+GtUfuxHFxdDT9+9pC5rGIpcXWhFkw1afBsGG2s1e0t0e3ku1/Mat3hSQpk
         5y4KXMuB2kSGarCkcG7Qt8U8nU4VpxMYkaVROLVJZsvyHfbvEk178Tnts4U16X8ThdpD
         z6kuM0aYzecFUWPUP1HUTRsuza/AMr+yDnagapwvBxlHwJvSiGbNiWXpRN0kpp/Jw4CD
         gpwhCRd/xIoX9GK51rTnA6PM4+F0qM407l3WaIRvIFSBWOtrnKWVCsDBAI8f7Pyi31OD
         T14S4Nz9ZnHxIJ97M/Tv1koZISxuFuCfIOUwjdzvPtN1+qdmNtYl61KbMUbVz0Ytr5gO
         ee3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVm52B7SF2vk1S1jMtiHYQEB0a2Gl7AK4A5gJahPX2ZrGWA7FcM1RQOLAEGa77LxYcbZE7O/NNS+A==@kvack.org
X-Gm-Message-State: AOJu0YzO0zzoBa7F3DsCbLOmEB0DL9cw2iRcPMoKoO3clRrptt/3awj5
	H1kr8rVB/rsiu237Ti5WwCzD89ZzfCKUlsth2Fo16oYdC7NBSCH5YOSJ
X-Gm-Gg: ASbGncveEOKmmXLvZFrUyRb4jtwcwb+dlVd9OE8ra1+EB2XlRfYrkvdoMtROKtrC4Ro
	Wg04M301VlLZAvtE12hPDkihnc5047UAaLOPIzHeUG3VJQdyUrY8AFNLsaC9l9qC680zLkNcDKd
	Imv5I0PYxIHSGbq3qtV0ZBgHC5B3pFr3mT3+EOY9EY6tn7sTE/D9UKnfC8Q9CLLaYLo1zjTZuKN
	cvEmsYICGkuFOoV4Hdj3YCUodnGiH/b0GHzH+rGShNAjYT9sQPs8RiQmcaTLrNGslSEkzOcog9Y
	URrlgMsjC9ZM8tTYJW6CF0oVo5mS5+Py+k+gWBE0H44HRLGAStSwwmTFbGFKTgoQHwhkPRPZxL9
	1/1Uo88m3aKuP7WdL3ipKP2K4GJgARuUaPzAHcTX0fYZk9F+puU9WB0nibRkTDlVanrnxyA==
X-Google-Smtp-Source: AGHT+IGbZ6VmOvpDlTVFv+9h7OOgKudwCo2hDyGM86h5YZJ/r2KjDGMa80yS4pSyRQ55qeRqP1kbTA==
X-Received: by 2002:a17:90b:1e0f:b0:31f:14b:f397 with SMTP id 98e67ed59e1d1-3281541407emr8547594a91.1.1756692547177;
        Sun, 31 Aug 2025 19:09:07 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:3fe:4a4:e96c:b5d6:3ed4:22b6])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32741503367sm9392312a91.0.2025.08.31.19.09.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 31 Aug 2025 19:09:06 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: richard.weiyang@gmail.com
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [Patch v2] selftests/mm: check content to see whether mremap corrupt data
Date: Mon,  1 Sep 2025 10:08:55 +0800
Message-Id: <20250901020855.47218-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250831022701.2595-1-richard.weiyang@gmail.com>
References: <20250831022701.2595-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 761DD80003
X-Stat-Signature: p7xirep5oqa1jorbgnctxtg7nandwpnz
X-Rspam-User: 
X-HE-Tag: 1756692548-957346
X-HE-Meta: U2FsdGVkX18MCHWWWND4xr92VsostoJprtyQLc9Ad6F1R0URNMQGj3bxwv7nco+GcUcoh9WBESpaQ2HgtchLb6+4Zooqu9yklLKGPyft7xlFYm47dBGjw+0Lmx/B1qcxITdSJ0oYQOAhTzKe7NEFmDOscO61EFLZM3WVSGiEZgXzJtc3xFX1Lnq+p7u+s5wKMHAiSIcWgToZpTbC4Qyeu6EniVA06RRL39Y2DpV+zP0cn0JMDNcF7rOT8ze/87xBPgvXVMG/j0dVgXvQX5//wYwVxiElV7HfBHfcqPtPJQsmRJJ0Radq+HYlPPtJqwCeOXcQgM8/nlxMqdFHpxgS87bH/Nryu01iNZgKrykQ18EWfjtmCqxOi6s4AgLDDviJkoeIHKxRZakwAt/lGd3CG89OBaD/ON/iCPziKpaz+zqxl7k4JJ3oDCbYsT+kAULVi/dYmgvsDI9jEUyGSpcuDkQjtymtFV5PsjqU3k5kVKRC96kidG+/kth3U2BLICPf0aSIGg1PHZEDtachVGPuu2IxvFGH4tHroar2T7TiE1V7Oan6RJU7jMX7iVghUoobYc3cUvHfKKwmMhqCAUHLDNU+YIRktNaifCBOrNeMPLuySYv5B+38z5pVSIXfMCWiNQy6n4R97o/VHWNRx/8hk0E9OETymgioF03a3t3+/r0QbO9cV/hVXlhzomgsCF89PslaCUIwegFIL2/HJWRAsmiHrE+U8HeyeHDbiSdRIngikvZn8NyWRi9iJ6XdFt6VWUATvEMUdTDfKGjne6u92GG0criSd60YtxWMDvFEMBJImawpa81rINE0EAuGBCYqeiYWs2V7s0c+zhacfzMyirmZudBue5pQ8uiZoaJDQiuRCMy64WZ1f6NnElDHtqQp5hrK70/uhEQRh8/2xaC7lQsi2pYZ5u8TWw8hF9QvmrM2M39ZBr9vhawG4+ilgg497Ovj9/k4kghJrwXuG0F
 xUvKx9sz
 FUrox1w0zWic9Th1zImXaCCEqKKnGSnTuPiJiLyII0lH6NL70nSzkvHnU9e8fIU6KhI6fel0PE8Z6jGMFsimP/p2lThzA4BZO8WLo1Y4xl//x361boxbfGauc3yFqEMxWiWtyeugVRZqzjihsbWMZE8RcFtBhA4qPxTzsuc+o/Q432oMpCFJS8ayQI7pKl6hH09YJew0II4THuWoI4ZP3F5M62tOvcMQr1lkbf/jFAnQlbG9z47Q1T/W9vEH8R1y/HBxdooaLZUA8xYbSANCxj9WIi9y9tPmWOf+GJ3Ox/jYWp4pJ2N4sQzyFbfYk/mm/alYvcaPOon2P+aycU75WOAJZQiO4U/jIl13iKrw1NJh2AatuA1RqKhMgdTd+gLDps+nwvHpx9w6K7FGBlDalWOe8uuWjy/ZyWKAbkQVguQXtngDPs/zScHD7s17lWcAZzIiLx2xYJmB1KS2nXsMHA1QyUsfFKAjW/J6BiyLEcsbrZFSlOCjM6C8Zug/F+STbfK3sqZXJJMFRBCgXiDAZciyt1/JnVjzT3XKYv4D2CPskqu+2JK2x/MW15Yci3HCd56i13FhGePR4+L2l1qtTIpPJV0a5RVAkb3ayB9+kdpuPyio=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> After mremap(), add a check on content to see whether mremap corrupt
> data.

LGTM.
Reviewed-by: wang lian <lianux.mm@gmail.com>

Best regards,
wang lian

