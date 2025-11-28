Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC852D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFBB16B002E; Fri, 28 Nov 2025 12:05:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3C96B002F; Fri, 28 Nov 2025 12:05:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC25E6B0030; Fri, 28 Nov 2025 12:05:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4E026B002E
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:05:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5299A5A72B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:05:16 +0000 (UTC)
X-FDA: 84160641432.28.199957B
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6A6CA140013
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:05:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OiI2Zifv;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764349514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5gHDOsFG83iDIKKsmQJJxjvLwkokZvWuQS7kXsZY8RE=;
	b=Bqqg1NFHARPhJplNCkfwjlpuri3ysN/E0AyWdXHgAXzQrNuzFfJgSqLvXFcF9CTPhX0AU/
	Lx8y49BFqN9eBP0QkZUyjqHfn4jSBDH6vuB1rPouc3ivTIZIgeNy4C7ZyPab5ey+D+eZwb
	jqCOHH6clFm7EG+jiVEmMrSiQq+tSIA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=OiI2Zifv;
	spf=pass (imf09.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764349514; a=rsa-sha256;
	cv=none;
	b=ZLcuUx6sR3t47S9bxZ1avBWwB+VrO+o/4aIbbTJUHozU8/W03k/rSLJK8ThQSohbkRyJpz
	/TaDtp6kUpMaX9t/42vFlpJvwY2qQOu3/UzAoVC1H3ECOmY1MiWWcCK6OPFFpxpSF5E8qg
	kG9LpXCk2LfZUoY1t5ZYHp8cEfHjjuU=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so1414498b3a.2
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1764349513; x=1764954313; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5gHDOsFG83iDIKKsmQJJxjvLwkokZvWuQS7kXsZY8RE=;
        b=OiI2Zifv6KFUXGK239xNviamyFIwfB6M+nTXgtduCecFctsplcGhQYcjcLAO00LEw1
         lWnIoCCIRdWcxstEQsFFMcAhlZyZ+7P8i9N6wJCWRLKM2FOEQ2CYOoW/KXT7swBw9l9r
         UBIeQYO/5FslTa27vOR6iJvAgBg/ER9LMUbWs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764349513; x=1764954313;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gHDOsFG83iDIKKsmQJJxjvLwkokZvWuQS7kXsZY8RE=;
        b=Bm/g9qE3K/qc0Ey3SC7qHJ/2UykniuqQWNIdByIRmi3WbZEHG7fc9MQC/2GpC1GFRX
         21CavBhPlaA9fehxfLx5ldMlsw/GW6zvR1VCtvjOlE9xtNR+l8adD96tF4crBCN51oLY
         3I+gTupRkO263zGXbTtqhvXxdWQsZweoTZBRX3LmGdcOqDIg0N1Or2ARuRSZBM56XNC5
         nLYEoB0yXTWvCvgYi8eo3wW1I+qv7VAZ7azvzQDmNK7mDrQ9ktsMTKzB9ozFV7dm6UsG
         k7HKATo3VA9sFF2a0eecwpbZE+AwYLZ+iaOOULqHQFeuK7YgGhk9wruADAQr+w/ZiP9K
         mf5w==
X-Forwarded-Encrypted: i=1; AJvYcCWRmPteTso46pt58dmQedPC6U/zqfwGe7veSxkV3eVBn1aInX0S3U9ukzaLACi0wOuMLv14D625Ig==@kvack.org
X-Gm-Message-State: AOJu0YxHT/V+fPodywUZg1YCz3+u9voU6v+iOdPGmXVy/SXlQQiPhbk7
	iro6SUSeWTJbByPasckHrAleqINFmY6+dHWhVKGcjuRAuv3xkU7k85IrgPx7yNwWoQ==
X-Gm-Gg: ASbGncuaAix2zEN4xjeXTbEIEMGTVvMqHdvPa0Mwe9aRfOq30qDkjVnBvDYOF0k5WIP
	NWsFClg1gr/eWvRLM1+3fdUew+0d7PIaBd5uts2S6nVk4XoeXygEwUoiA9MH9PCBwIt4J+EWj22
	AGFgH+T2M8xaNNrRGU3Gu5d45aXF1ptnsitrADZIcO4ygQfpBEmaT+PH2TOnouqXQs8ILDcueMg
	YyIDzEEzdOTON5p0ke0/RG0Gl7sk8Y6P4bbDHatCbtDCSOmb6Cup7sqc584dbw3jruYtcNvl611
	ql+oc7CH5aw4hcIxZRfLNXf7aFvpJmMWMMWZknXSCZJ3CgIqXn2f2d2tIsxtvzmnpcu8oODg7SE
	McdKBNsYX5oUHCzP+BnNUO3gyb657peaHjklda0orlrz+0YG1XOolIJgwK5pbo/SqCAS5Yo3+lR
	jwpYd2toSlkT+6J1erhjOrzRHaTuT0Etc9AXt3jC+4z4GIMVHBDnyX33TWd7Lcobi+iEbtSIkZg
	d/d1iusMdDS
X-Google-Smtp-Source: AGHT+IE6t6L5aaKbxaT3dZ25iRzUTepkjauFQFax/3eE7D/nAmf1/UU/2rIe75MhhwGWaFeuU3AClQ==
X-Received: by 2002:a05:6a20:e211:b0:35f:27d:2ded with SMTP id adf61e73a8af0-3637db539ecmr16627880637.25.1764349512883;
        Fri, 28 Nov 2025 09:05:12 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:5b9f:6c7b:4d09:6126])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7d150c5e611sm5568242b3a.6.2025.11.28.09.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 09:05:12 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 0/2] zram: introduce compressed data writeback
Date: Sat, 29 Nov 2025 02:04:40 +0900
Message-ID: <20251128170442.2988502-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.487.g5c8c507ade-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xg59nxfbi1wxwetm4exzzsr4bdwzwiqo
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A6CA140013
X-Rspamd-Server: rspam09
X-HE-Tag: 1764349514-312495
X-HE-Meta: U2FsdGVkX1+dTM+jEZJzyChu4mZzy9p2RPC4c/V/CGh+rD7/Lop7NpnlAXOoFSb5gv51n0f5mA1K5BPYMfYJGCq8j6Gle7OnG0gds6d2rw9gy7KAomxp4Yx7zEwcA/ec8zhH9iyQ9RdHd9nSfF8nJjYRY2eNmJuMA5m/OZaJkEAwooVdcGwU/+s9nmbDsPqmnrKNbsGjnW34rfzHsMv7079+QtBS54H+CaQjGZMLfXvH0/91Pgh/tSED/dt5gpB+et5s60FiLjo1itiKlod1XCakKyVg9JoyvB/lmrVEfY9Z/kr/+hgzAQBt9JK95w5sYbMSA1Wg0fB4JKipBUbj0EzpFQK8ijU6f9g8zpKOs0Q+VSUgXDmnoMPBUGWkwm/dT/GGxhnYMQYTikYEAtGit5dLKGpYX+Tyb8q4dLRAXw6we1TzI2/ua2me/6ipHZqQLcAtAX4f+xzqi8RoVLk+I27c3baUX2IyxExRk7MKdGoomE3jIxkk65HiKCy2qRmXtqdFB0YJ1gGzpQQsBcG1wLwrlOQ6eVMSPOhg4BohbXGO5fUjIGg9NBn2ogdL8SNAy+qlKSl6nLh/jw5+AQm2bI1MOOdGva+yej2JQgqDx8DpQXFjUfzLllbNgdVRDmCL13H7oVI1Lx43yJfmVk/hlUd6xi0fOm0C+1MKy/noQVl9E7ANDRLGMm/HgZlLVvv83icD1lmRQyUWvN0wAWTgxjWLS/pTZRRspY6fQylTZrovh/gbTYpaMpDgzCiOdhHH4JCfiGioorOQmA9R+P4dD4RRgg9xANglGWH0gjJrSR8UF19KUN2atAH1WfxLgCeX9kYqksMRVs0HDsXE6Ag2FLQ67WSBUMouvUdy55f+0PRkfInLpMYb2g7+4nPggtpl8K0xgexOXb11p2Xda71dgyPpWo30+5MH24ciLpYzd2PXSzNESMjJ//0hnO85zICpkXV6PbHn3ztUYibn4DW
 PiB917R1
 8Dd/AuvUUExDp1vqYMNzCCePyjdYDOIssjhBV6oTWB39Gn+useBXhQeJtyLhkw6gwQP6QhE05u1xcy4ob/0xkMu+cDZq/3fLfMRKxbXo2ba/2b7wOSKRBcQuzNJZ+3ymekxbK0rSLfLqekmG35b9tK8NADWwVuRSawTJiEhcBqemeOBVNx55O8lgg8fa/8jzufImX/H8+prD7iC84SQjJKPR/1uw1GdFiKI8VuRcoXQHSkRc/eArwU5+ZcnR7JJsjzW9O5yKhSE8dZOyNTq12Awuta1y692BJxD0eQupqpjO04RDlkMdp6JVGCNFi1lF1a48c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As writeback becomes more common there is another shortcoming
that needs to be addressed - compressed data writeback.  Currently
zram does uncompressed data writeback which is not optimal due to
potential CPU and battery wastage.  This series changes suboptimal
uncompressed writeback to a more optimal compressed data writeback.

Richard Chang (1):
  zram: introduce compressed data writeback

Sergey Senozhatsky (1):
  zram: rename zram_free_page()

 drivers/block/zram/zram_drv.c | 260 ++++++++++++++++++++++++++--------
 1 file changed, 202 insertions(+), 58 deletions(-)

-- 
2.52.0.487.g5c8c507ade-goog


