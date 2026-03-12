Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56516103E2FC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 02:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7896C6B0088; Wed, 11 Mar 2026 22:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 737516B0089; Wed, 11 Mar 2026 22:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618A26B008A; Wed, 11 Mar 2026 22:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 505A26B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:21:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08C40C2506
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:21:57 +0000 (UTC)
X-FDA: 84535810674.04.A90582D
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2DAB280009
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:21:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mi6dYRoK;
	spf=pass (imf02.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773282115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52Lg7qw8T1QJxUiD3IufUGfuGlRBj6hgMCa1F6Q/zI4=;
	b=iGuJZTOFCutvjRwaSGIdJm3KP5a4aeBCVS/zVzRQ1T3wxZmH9dqHxutBmoMNyh6yt7B938
	4de/6uA813nEceUyuwnke99Tb4PCrJBptTAXJY26+BHxgRDLNqWOPDh2jkoSyBRmFIi3C3
	cjl5bNJP8wZo3cUegjl+XDE+dZiAqbw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mi6dYRoK;
	spf=pass (imf02.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773282115; a=rsa-sha256;
	cv=none;
	b=aHQQfz+4ddrgIu4tCXUbkXCp8qT6uW95j31QPlvjCdyXK23P8gnHmfM9ndCNSWPEhvbkq5
	+I0NTVw1ea1Fz38oGwyCKPwTuyDwcDjXQShVYJ91EIvlrwlfHTYf6yh9+xnhXDkYXDN7Zg
	8oxze0NKniDUMLkaGSbvsWkn+G6CCag=
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-439a89b6fd0so426777f8f.2
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773282114; x=1773886914; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=52Lg7qw8T1QJxUiD3IufUGfuGlRBj6hgMCa1F6Q/zI4=;
        b=Mi6dYRoKf+IEgbSHNL8UR/vCE10gynKq5hu1dQEBOpiCox4v+OzuJ9OpB7pSjBkg5Z
         NloScgXNzYJ+4sDUz+p5hbVmd/pSIo5nFle8x1l9P3XhHdo2C5RPQbQtC3JE4y1si2HW
         cN9/UXv4m0AZuE//r3bZaSAMX0V6lEv6RSTAwkSkqKBWp/0lgfpMSHXhkl/OwsC6wb5q
         ah7jHXKspLBCMMFrU3ytzPPXKcENvkljZORnG0A/2MYZzwFQMd37BuBb0p0rujf5hcef
         6fLpfbCYME9ZDz5Ka+SGOsrXROoOIUJTnEL6qpI8SPDiaUUUbXuVpJvguMPc3G9dXcX2
         ZmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773282114; x=1773886914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=52Lg7qw8T1QJxUiD3IufUGfuGlRBj6hgMCa1F6Q/zI4=;
        b=E3wefhyz4+DgUw/um6esL0vkNgrzBDqRqPeDPBNetzjVe4FrLSWPTrsiQO5yE2wVh/
         TigIFR4HJIXHAr4/9LccOzhVoGXKd+gVPX/lwgZ2yS0Vh2bpvNxzYkLugfbWAd8F+0u/
         q+COaCKoiGC7OgEQgM3NcVe58THN9iu8JFKBwznF2wFzJFbqzkJsVU7Fq62FuIyQui8G
         2XiJM5olBIbdS/xSFNzazTTx7fIhNJYfCJC7BYUHl0hmCAHRvIM6Jb1xP46HyHp8rZ5u
         zW0xb4d4gG2IA4wZbpgHYc/oQMd174muQrXNxHgf4DBxirBvuuEkSBAxfkvDEzTnOU1e
         5pkA==
X-Forwarded-Encrypted: i=1; AJvYcCVcDr9hsUFA90xJv/GyFqXjntQaA52Qn9N5x0HWoZtWFWnnR7tURpu+cngT0L8du0I8jJEzDnjN7w==@kvack.org
X-Gm-Message-State: AOJu0YwnU1s8DhMdqEyZkrGd0z3uXFZgPj+4KNXOUA/dzAkRrQ1QjXNM
	392kmTpZ6mwRBSIsU3SwIwxwIPpbvYqPhT2Yr1zPa0A4JNj5sSUQ+Jr+
X-Gm-Gg: ATEYQzznjMJ7jA3MdtMf3icmokDVjq/qcOIzYmqISsanRW/SwfXjzhqb9Rz4I95RiAe
	8oLd2xvfIX2KJyUZSOl8eYAbxXEN5tJfhgBdNyK4gh8w6VB3/H7Y3DO5jT2PZiG4szc4MnzIQdA
	5dL5zS0oyvGu0ZX2AUxd+0eZ9QNEhJVP7e7g+ZLx8zupiJjYtB2q+bpKH4HqsuH+SvlvBDlSWfv
	3R9lBaigyAAuFt8dyhPgIEWBluq1kdxs599BCdH2n8O7U/epYQ6VPn7eECcRbIHShxv8LYm0ocp
	MZ5ONuHZ/QsOUXzMPiM7quTavcZyrNItEt88bfGv5s2Ns3mwiWuPSFBi+e5fdPqr4uH4xVZxfmK
	McAS86y2Mf3o1tIipPmnc7G5l2SIJl6USjxyaegUMaeeZ5nGgIwz5z1E1ijnD2ucV9+m36NIYsj
	V5XgKEMLG0Jm9crbOEIOrwkAGz16MXQDNROLDzbXukOdc8+M0qgw==
X-Received: by 2002:a5d:588e:0:b0:439:5c75:dc08 with SMTP id ffacd0b85a97d-439f81bc54dmr8741962f8f.10.1773282113408;
        Wed, 11 Mar 2026 19:21:53 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe2273e8sm4179134f8f.33.2026.03.11.19.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 19:21:52 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: harry.yoo@oracle.com
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	hao.li@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	wangqing7171@gmail.com
Subject: Re: [PATCH] slab: fix memory leak when refill_sheaf() fails
Date: Thu, 12 Mar 2026 10:21:42 +0800
Message-Id: <20260312022142.528493-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <abFWmVU6hgqiNn25@hyeyoo>
References: <abFWmVU6hgqiNn25@hyeyoo>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2DAB280009
X-Rspamd-Server: rspam07
X-Stat-Signature: bqctej88nmdp5yop473y8zfh7zoo7kp8
X-Rspam-User: 
X-HE-Tag: 1773282114-728961
X-HE-Meta: U2FsdGVkX19Uu/i8T0cZZMhfsFUfWzwRCX8+deye/0MkhI8/aBO9ZfjBSn2WuSm0u4sxofjLjs+2rfeBAHodWYsRl14CxT1GHFZ2W0gQGYPmjbODVesshX0fXhAGpmeTzrC0/h0zcalshZH7GiMihYXvi4pS1tKg/PKtHlTPqVkYFNHhBrFBfsHTmeL3slM1ZaJOVBFhlM8HcFacyoI4fQeUhLiW+yZHYLf/dcwUipPD99sZK2R4teb6FtCiXuyW/6yCIACAo3lyq5QVBXbb3t3m4Q54/vxAPOBdCClRjE95lzwY5y/WF6PyQ18c2LZoBB2HnXX9TUIKuecCxO6PxUCIagB1zL1UI+WHTYVnb6oKtiWcabQEK841u3jkeH8G1L2N8HcgptE/W/Wc+CTGNNVuWu4+NJdgXd5MLufTjCoVuXtIw7cpPgKqpfKpu+ED8mcDYFB4usuLosyYNhq2hFemK8OwWcJnKvtKspXyITtQloXzYlRQsIa0V0EVwe9TqVV/dpvotOZ7Oz6EsjnRu5NoxMO5CyfPVPOSXQhdgkB3b+Tm2RM1VnDx0quEMlTQ8EsQ9vmRofHuU8/AonAuXYGsj71hP9VNgkd5RMJCgSSDz52BiUeJ3jOx4n3uAACoCVVXQFadMM+0UZVY/YtxlAX3M2o5TVH3R3twOQZBSVV5mE/vvMtFYiKvcrEqFRhRmDQ91gNDSVTeUAyQL8ie/GxFk2LdZZ8BSoaxBz87uMBNvjinRWztQWqdfcguJ5htjs5O5eQvnmn1dE+EF8XniQble5zCYlr3Arw8nWnR6yoEQUfZftZrGLdur9MuLRwdAe9MLPhVDO5xOTfi8q6GwSyqXQQLM6B9W1LzMCYUSntXAKcNspKmt9beiI8q9ZQue7hLPOT2nC26GXQC79dy0sz985LeQuvYpniojnz65xgSZVcqj1X3fOeVRpLi5CBJogrWrRsaEfCeRa1ZARK
 +NaYYOuq
 /55VMfPi3hYCOLLrUF0ouesijd3LQmc4woTEAB7oMBwLW+AielxokbBJQ2ouRTzoRNKP/60JGTZ69OCcySTqPD++QKpkbtYJe2bFxAc1mMrc+V7ysF6THflZhEn18fSfsYcJFEzUtsGNFf5sCKrdW3S+3Vy7Nqedijy84NF5bAmgH6YPg+5ZEUFPjbNcBuSG2pYbj1jlMqjBWGfrI9yGZDMiJ+gA+GSQtW5CEGhSgpOYfi8WJ6Cuqth/Gfm/YfwvMh6n0Wb58XCQYB6NaW9E/acKJzWpnGp/M1020TuMl+wwCuK6ScJtkp7MQpWzP0EkvlkaTbVZz0MuDU+Ve6uIuKN+cNkjs/R2rV4udP3ufQDNwQjJfqMpGpAxgvaSWloEQ2+I5Zq6SRj3OanLBVax3J65Qx2j4TFaJIhfzeq/p4FG8RbktXcgGiOPR1nbGbpyDMA6eMNfEg66CFJkyBuqZGmbv+2Gp/erz961vtOU49C1XzW8I9LeewgNChhZ/pvu1r2Op50In/0HAY4F++arZVrQZ4OAzHuXJCP6kUxkhbq1VAoE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 at 19:48, Harry Yoo <harry.yoo@oracle.com> wrote:
> Just out of curiosity, could you please tell us how you discovered
> this and confirmed that it's fixed, given that kmemleak won't detect it?

Just discovered it by code reading (while learing this featch):). And there
is no good way to reproduce it, so confirmed it by code logic.

--
cheers,
Qing

