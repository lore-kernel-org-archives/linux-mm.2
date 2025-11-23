Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C14CFD312
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 03:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5CA6B009F; Sat, 22 Nov 2025 22:04:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D056B00A1; Sat, 22 Nov 2025 22:04:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B32E6B00AC; Sat, 22 Nov 2025 22:04:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06CE16B009F
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:04:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F8F1140A9D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:04:47 +0000 (UTC)
X-FDA: 84140379414.24.038E37E
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id C70C9C0003
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:04:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lV148cyw;
	spf=pass (imf28.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763867085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5iGtx0HcNH0TG9w67m1XZlwKS7/WXm26KwxBCmzMNiY=;
	b=HG6VMOHzd0lrdrGPVBxURTgWLUTqEpksFkZFwKmNpZLGzWS+Sv4Ivg0UKHmcawu21xSFg/
	zTg2qK1InVvxajBd7n8389DLnYJLKrhHSN7pWWk7jkVY9tqC8vGOSrSl3bt0NUvrxFwTMs
	GtFBt/y1XqVOLWgzVcty5GXVshvzB9c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lV148cyw;
	spf=pass (imf28.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763867085; a=rsa-sha256;
	cv=none;
	b=enmYdJUy+nnJePzGD/kyuVjf/yVaDg3+RUVOg+QcMY0MyLYw8BCS3ZQB+eQI13AfWk+Yno
	iZHWkiWPi2zj5B2QlC4V2/mtOQt/wUHOU9ZeLXgHDfLh1/dpL/28ReSFJVadWetIbNUCL3
	iOA7UzBQSDlz4c8T0CFQ33oQ0ksv/Fo=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7a9c64dfa8aso2447822b3a.3
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763867084; x=1764471884; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5iGtx0HcNH0TG9w67m1XZlwKS7/WXm26KwxBCmzMNiY=;
        b=lV148cywISD0rSZ1QiokTEQpAnfd6Lvua8q1LlMD/bDyB79sRLWErFeeO/s4Tj8Ffh
         LBhWH9dBDsYAH1IdsrIqX/fE/fKM3kwgm9dCOKMc+F91K6Zk/Q79FjnZa/sCTzyJ8TSe
         tapjtfWijXWaX0yY9ICNRA+7ynd7Di12PqMZs6dabLNI8eIaPfKVBqZPyAPOPpazdc8k
         lZpIcetOlULyRNoQswWIGaPIP3ifujGs9hYn2Oua0jiewFwNT9wqHKxQ8wgueRDpxM3I
         94U4HvvtbXueyOGwsW5FD7uLjiCy37iMR2vsfPMNIVZQo+7KiwV0bMWo6FbDWQQqrwyi
         7XDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763867084; x=1764471884;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iGtx0HcNH0TG9w67m1XZlwKS7/WXm26KwxBCmzMNiY=;
        b=tD6eNieSxPZtEWUsqsEu/px42zWDDRkUPYjIp4Iwo/H4IvBf14YIMLoD34A/FSboSH
         +Ve6XRuf68v3+kacfMBWQRdVnvAPCk+02eesHaEV2payKhlyTkRwlBz7vgQdLIFay4Za
         tfbPLjcRqtmGbT/pob7G9CrAVr+WyZf0YHclQjZ6r0hGYcXbERdoD25WkOswp12x/fdp
         aB9W9HRIg/Ki1Lz00g8Se50Op3KCTtvlt8QO/gGnBJRIFnRXVZAUhQLTCbDpyCwEGbNY
         +1CXyH1/RqPndxFdl1Bo2bXhicODF5KbqFfHH+44QDKk8jw+HnkSSxHO+IWHwtn/+gaQ
         m1fg==
X-Forwarded-Encrypted: i=1; AJvYcCX8s/9Cv6YY9VWVjyez3dd6KBQIayMObtcSH3KkmIlBQmOlQqZLpLF2689Uk9HN0alfwVod45QGdQ==@kvack.org
X-Gm-Message-State: AOJu0YwMa/Tl+A4/GoJtiKqGPr3sY/hvDle7LZILS/BUuE/rUzEzuXzU
	EbYZz2f2AC0tCLiQhcPeBlCNEMOlh2cKMX9xNsFzQOOkPK0oKiEo5Nlh
X-Gm-Gg: ASbGncs/kqbFtYBRW/xUu8Gg4qw+pYss6X93JmF5cvvwGUUuyVZO3kI2E/XM9B4pNmO
	B80RGS0ImxHFciT3bS5WNKYysTfUmejvtzPuSwtgZB/nBWyPOTW0rgzmZRNjSYLtS0txveu7BJH
	YKAg4exiV23U9BDmK9NI6ozhqrTVtJ8MmVfTNPPEI7AkUiTmq05NACL/TSVBFqv9Wp42PpnQwCS
	vittUHvo2EaR48qYRfPqqcN9p/Cp6tPPAwcNIbQLyyc8KD45MSlodA1JeWT0oWeUobC+xfv8bNy
	0FggonNb6dIoUnKprZ87cif6jnYXkWJsVnYA3aOk1GylmdRST7yTQvh6O4gU0IFeEglTeUNbXXh
	z3dtOxxcMfFMiOr7ekEdMQmBL5g6RUhrt/XuTHIrT617F3M8qMO0+ACI8+LrmlR8JOmCbsnP63h
	gtpNAW1oduOMPFNUxqXwD92dWv9Q==
X-Google-Smtp-Source: AGHT+IFmNg0etXsKyEZ8IXBLW4azMd1AHppOePaKt7bd8OcjR/lkEKRRSUYxpUqzT/UcoTyzVuhBjg==
X-Received: by 2002:aa7:88cf:0:b0:7a4:f552:b524 with SMTP id d2e1a72fcca58-7c58eafcd64mr8007782b3a.28.1763867084395;
        Sat, 22 Nov 2025 19:04:44 -0800 (PST)
Received: from chandna.localdomain ([106.222.235.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f024adcfsm10386095b3a.31.2025.11.22.19.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 19:04:43 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>
Subject: [PATCH v2 0/3] mm: Coccinelle-driven cleanups across memory management code
Date: Sun, 23 Nov 2025 08:34:15 +0530
Message-ID: <cover.1763796152.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C70C9C0003
X-Stat-Signature: ji7h8cz8nh37qu4r4f9it7arh51oqh6n
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763867085-907029
X-HE-Meta: U2FsdGVkX18sc6GEtXnUuROXxCOylk7mczp/mlqF9LfM0A3GQbbUgGfbcybfNNZEEcdC1861RuKfiJW+co9r5EA+spk6qWVxR/e4bYwfgwAE7gkD+vj66JOTELa0FGGenxvcoyPEvwxDnrW/eFxK8V6jXSaE09+mcP+bVIOHAUQHtt0jy4yeh03fjMcaV9H1Jq/pJVkAKGhIlCehGI3hfQmBBYXbPJRWIt3HvG4vZhjueKqiwun9s5Lj0kl+TLnbclx8Y4YJgkDDa3O0VGKz1UmMHCWIyIAqBNgpiAeLSD5zRzKkHctixuJ7ovDfsspo5pwdYXVLfS9MiMqbJJ9uJ7oJwAPDeCYDNpfEB5A6p2awQpi2dDz+erGu/lcLKjH0pY9CXYWGLYA3sHiO5d3kjgoVf9xYC+JUCOwr776A8VJRkdpWJR3b+GyNAWNGEcy8ItyAQ2lyXquFxEKP1N/HZG/gZGYYdoZr8eAzplyIQHXYeEULHI1fhMgpdP8p0PObwgyZL8jl6zieqpn1l8fwUoh7kxNT01fFn50JXozdWyGH1SmdcK9canDFFPKIg0ttDgQadIXqRhUxK2uEFUAPOVERfND+ohKpvmMJ0eJMTwrJOoeTeviiW6V/8jRWAX1abfEsGpDOLyFd71VJf8Z11zkelg+OKcEOK5T7nqTMpTupY2ViaXvsHNftLMJ2Y9POwQF9s27Dgsf32FyP/x9sN6speZsEHewNMkHOOGFsCSScPVxwjrNuQzQQRKxZ4W/7VRSku4mGTH2OIGf0xFG33F1X0A+/cKAWzrYFmuTd/kk3l6nWzrROv4QACDfTnNSqlELr3xxODLhm4IEOoRXJAUo6WVclbgL/zZR+xHZoSWXJR1lrgvgTTNnDgf1uW3zuR8cvlvXd1Ozx/iyCZ5B6ks5vlez1i7eQz03uuDrtH/TrJZPE3+hcP2079Bo/Ld4Ahfnr0SPGsywtYuvl+Mh
 uPxVDMw2
 72RN7vfxvP9LU1epDeWH7FjQIbt8YULUnnxOTdQ2HYlKykupEzAjPpgaCUcdDdlxkN42r10P1n62q5nvttN1og5gbEdan6g2Ir2peGkFK77niKTtQvtaDBjImnw5dldUbxMth9uWI/L5clLOuG3YfZ8+nkq9cVIKbFz0JrsMvrCGXdYG0BkXs1/M4RwaE10jWjLixerudxrHU+nFx+J1ffl2IWaap1vjOkm00a6E6EnISqKfAoMM7+kfNqRiY11R/7gBwWFq4KPMLzHdNhtgPFK7Lw/kB1lxhNeJoBkXdkhxxtZ7DvNdVccjc7pnnsTOTLACQnIT6Lx+fVNGxnstWmsRnobU4wiQMB8uekZyMzjHcOyaljx7HNG5+LZmcW1DgGncmLWsisaT8iExzcAbDTMjY3XkKIIoCUkYYjSMKJN2KvWVkNAJ2BnfMGqDIz9/JrzZ8m903ygRoBsbYvwr7GIiMqTzE6qqz3Lftws5pE1HgD7FJmUghyn1vjW/LHvZ4Y6wml6RWKl8jNFU+3pfq2V2ZumADjFbu6JKH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series contains three minor cleanups identified by
Coccinelle scripts under scripts/coccinelle/misc/:

  * Replace manual ternary expression with the min() macro in pagewalk.c
    and change return expression for clarity.
  * Use the %pe printk format specifier for PTR_ERR() reporting
    in vmscan.c and zswap.c
Found using:
  make coccicheck MODE=report M=mm/

changes in v2:
- Patch 1/3: update return value as per review comments.
- patch 2/3 and 3/3: Add Acked-by and Reviewed-by tags.

link to v1: https://lore.kernel.org/all/cover.1763227530.git.chandna.sahil@gmail.com/

Sahil Chandna (3):
  mm: pagewalk: simplify hugepage boundary calculation using min()
  mm/vmscan: use %pe to print error pointers
  mm/zswap: use %pe to print error pointers

 mm/pagewalk.c | 3 +--
 mm/vmscan.c   | 4 ++--
 mm/zswap.c    | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

-- 
2.50.1


