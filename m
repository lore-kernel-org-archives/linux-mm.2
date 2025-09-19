Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37A0ECA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 03:49:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AAD68E00C3; Thu, 18 Sep 2025 23:49:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D178E0008; Thu, 18 Sep 2025 23:49:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A5A8E00C3; Thu, 18 Sep 2025 23:49:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EEC38E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 23:49:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84F911DF7FD
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:49:39 +0000 (UTC)
X-FDA: 83904620478.15.ABAF249
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 075F740007
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:49:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lYapPqFV;
	spf=pass (imf01.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758253777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PGM0+isxbI6kMyFpnlWoNKQkP4z9jauAjmwEBTcg+6o=;
	b=ki7oZatzkEB8YDLR3cAjb+YpCASutIMe0IiFMGSL8oqlBCJAcO6ONs8A9Npuo5Vx3xdYGv
	Nu6go88EBtaZ1CCfnNUUTdMxMqDuzJt1Nul03jne8ROMcd1eGOHyzHF4EWpGEurD+CJSmx
	jUjqXkhafzakqE9J+Yj8cYkiSLFKjo4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lYapPqFV;
	spf=pass (imf01.hostedemail.com: domain of zhengqi.arch@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=zhengqi.arch@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758253777; a=rsa-sha256;
	cv=none;
	b=KWb6rZitNsb5gvAZRvhRamKM70AxnjbQSeiU+Xiz8mAecdK6mHshOC2WXQHWJgefP08/rr
	anWflElQ3ywO/phHS4ss3lhyIIbu459py+OykGWfvJm8sGuW9CBnB134IyLEAPWhXpZv2r
	0EeLdm7Vv/fZfaQG7ZXK9OQuo9r2Dss=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b54a588ad96so1229026a12.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 20:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758253776; x=1758858576; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PGM0+isxbI6kMyFpnlWoNKQkP4z9jauAjmwEBTcg+6o=;
        b=lYapPqFVORNinooKLhLumOmwiXtYwy1NymYOTOsIZgYOmJ5qqmJQ/34HN0p6Alehvu
         ECvQAIOka2Gd3HiBGKXiAKqyCCmDxUdgT+1p4fwsDqgaNXoGOeQ7Qbmuh/4rR991CXvj
         o4bJpV7MhLPnbGffmHLiYrGCnog08S9RZm0gXBrEWGTLeC/kTjTK1m2F0x8fA458PIp2
         hBHsJfJxOU8HZX6zUMMLAk6MbM/4ElTz7OsRtafW5KvQ0u1hdVgsl4I2IsqvPjA0nmTg
         ehO8jydFqqWQ6uRoiAqKU3KLRYhMl8rxmaPmNc+GO5TLxmGtjxe3D7PdZej4UAd/+LFx
         ae+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758253776; x=1758858576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PGM0+isxbI6kMyFpnlWoNKQkP4z9jauAjmwEBTcg+6o=;
        b=QdR1BObRtGL7uZRmFeL6wibhdJPg8BLPef9xCOZYf/rXcGIy1hBt8RveMQmhF6Qy2f
         jdijLOktPlOBX+zWsvR9YBBt2Y9X/pxRiOtxkNpiCWRDUej9kOZTeVYimIBNHQ2jtEsz
         flfcjgD9PnIMc53jbCnjDSzLmPKdQC8pthKe1XYvOM3SnmqpfNeihjhbUgtYOzN2ihRV
         CAQWd6zr6GRrf7w4FT+ZNLWm0znvEC/wzXMb9a8S3Ca1dJxMrd43lOifOK+D2vtUtVr+
         zBZxjB49CV/+yp6aA2qPi5GGrFpQ1OcjR8yX4WnCaA/BdCGDQlgWmMUC2sGS/digeCHk
         JcfQ==
X-Gm-Message-State: AOJu0Yx0AaiSFWQABmMYX24xwCRLSiCZIJkYDfXJr0pw19i27y2e3fPZ
	OTJDN5VFXcZ7T+zf5gXMDKHzM8U9IY3q+9F0+w+i36PpkZN5JDWCdpi4AdlQU6WxU/M=
X-Gm-Gg: ASbGncv1fe/MDX1FdMob1VgaPa4FGWRdIcjfD3iCB1jt5RvHdRvbe65mg68bgDmjwh/
	PTQokADIpARfGdGJei9YM6H/rt0x97WuCKicjlL5jRwv5TZ8x1Iw/j7I0OHPBI6aAExlEn+lOTb
	7CPL4y5zhXl+woo3S7HJUDuDcSAce07qPHm7WzR0h2NLGUcAWNdYfnozhVO2IPMxS8pR324PWzG
	rQwcwSF+59FWii+cFKKnR2OGjW4gP4sYEXiiri7TmvOT/U5vf3A3MURMAMzBtiraMXOqQa4wBsz
	BLwrr/NHqQw+MpmDCSbMPxayAgnI+S/Xzqhg46524qKsCzJWgFyxIksOuz233mU34nXSUDzyLrd
	PYgraue1/OiJKm+5gxucymeeLI3RyiWLyI0v8AjQ6e4/MK2zKzZHh0jtudsxy4SHaDtzMaVs=
X-Google-Smtp-Source: AGHT+IGuwTI3Ff3KyrTQt6yBvN/VUnCQGF+jEJoWLIuvf5BD8t6+lT04UMxsOFQpcGmAFNec/IUGuA==
X-Received: by 2002:a17:902:e543:b0:269:8eba:e9b2 with SMTP id d9443c01a7336-269b9fd1020mr24752775ad.29.1758253775679;
        Thu, 18 Sep 2025 20:49:35 -0700 (PDT)
Received: from G7HT0H2MK4.bytedance.net ([63.216.146.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802de5e9sm39629235ad.72.2025.09.18.20.49.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Sep 2025 20:49:34 -0700 (PDT)
From: Qi Zheng <zhengqi.arch@bytedance.com>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 0/4] reparent the THP split queue
Date: Fri, 19 Sep 2025 11:46:31 +0800
Message-ID: <cover.1758253018.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 075F740007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gd3fjq5s61i5yg4t7jchb4xqmw14789j
X-HE-Tag: 1758253776-824063
X-HE-Meta: U2FsdGVkX1+U/0QL56lrpZjKR0iu9Xy9AQGy9vymsUY884YxGlgf1v+DJ8Wa8axgZ0OMwQhMzWJz8kdotLOaWtaFt1BAT/syQjbQF/7rs5nekzkGgoSwFfH9B9r6hny958pdNSvYdQuw2GTXuEbg/4/njKDnQxPmxJk3oTd06nGLNR3eO7myv0eIvcHK3cxlN+LfTRy9UPyj2JlKRKDOoC2v/igsI75LBYtwurV+UZ1jrpo61nCYjvmL/UfwQAIrrM5tAdi6otwURlbvSdMjehFePgoVUBJMt0cSzUx9B905mGFJz39wx2R1RMbMbHvWBshkH87l3aOgKEkaXnCDcSJmGlC2dtG1dZnM+RnaWGiQjVPnAlNHYwSvzqA4l99GkOF6jyNuu6932Kj5gk0iQSiICLeF1zgER1NiFsZ+IQYEIiQkiZtcKDaFiLQ39BsigJWwd38i6kTtwvr/HODZv1YtLAD09vyXcD9xdszdyXdAiSnxRt/dZ9sOoa665K3/NhehDGpGfmQHB8yJn4daSaKXGDgaoZy+kXt0iVvnqgTyTTZaHgUJs5gvZiLUVkPMtln2on3oZ+WXaeErP9zLnE+a7pJlfbZeDJrOhKIlpvxPTVQexjdjtgYYUQWoE0P6luHB4eDyotIq5ECmojrZZa6dl3TaF+W6e6T5YLp0QPE2l+zWDWFglnncazk1SA+hmZIUUEVzAHNr+a8qwtpyrrtXjlJzyVSKveO/O2Bbt9nvyJ5tyhDU9T/y7w7Xjq/ulGWQDZrmmojJhwBsR/crL538cFO8ECBOSUre56UOUaoRhZBLSxGsjvJIPQgkHB4av7zg0yA6hwbT0EIEXX4i11DzTxSQ+cCDQyBQPHhaURZbGuBiv009KhFRc+JjdQ9eBl2lE5G4goj50jt8wWQrQmaBWrHCMQxWOdAwVifY23eV1YdYXpt0bgaBq/gM8mxBlT1uecFzc7/x3dlxNNP
 OxgJD4sG
 B7S4N9X7x0ll2P9u61l/AWZiuXw/jz0eLfGwjt/7tybUf49WTek+PiVktUIKOloEbAIirzXGfD6im4ZAnCf645a/K3USGIU49/h8YhbErdaMTjrFYavHuMFJPaoVW+8ryUSmLlaELE4vVDA12vt5FP/3SR1aGnnRWs8roCUt/S1sCHrGixQqe/N016xRmKGQ/bEo3YPbxrMfs03iNb/Iqu0Hd1vNSJwpjb14l0urcOL8eJt8t9tZhtf4oM/qDtYCwfA1bpG7oUZX8XRm6Qu8mLqcjpXYC8xDakLxqDvO9L8wbs1RGFUQZJYv6mYaJOtoHEXWDbgMa8SSYzf8smMKtMBaeXe8XU83hD3lpKDjmhocOQrRY+BOpG6HW9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

In the future, we will reparent LRU folios during memcg offline to eliminate
dying memory cgroups, which requires reparenting the THP split queue to its
parent memcg.

Similar to list_lru, the split queue is relatively independent and does not need
to be reparented along with objcg and LRU folios (holding objcg lock and lru
lock). Therefore, we can apply the same mechanism as list_lru to reparent the
split queue first when memcg is offine.

The first three patches in this series are separated from the series
"Eliminate Dying Memory Cgroup" [1], mainly to do some cleanup and preparatory
work. The changes to them are as follows:
 - fix bad unlock balance in [PATCH RFC 06/28]
 - fix the missing cleanup of partially_mapped state and counter in
   [PATCH RFC 07/28]
 - collect Acked-bys

The last patch reparents the THP split queue to its parent memcg during memcg
offline.

This series is based on the next-20250917.

Comments and suggestions are welcome!

Thanks,
Qi

[1]. https://lore.kernel.org/all/20250415024532.26632-1-songmuchun@bytedance.com/

Muchun Song (3):
  mm: thp: replace folio_memcg() with folio_memcg_charged()
  mm: thp: introduce folio_split_queue_lock and its variants
  mm: thp: use folio_batch to handle THP splitting in
    deferred_split_scan()

Qi Zheng (1):
  mm: thp: reparent the split queue during memcg offline

 include/linux/huge_mm.h    |   1 +
 include/linux/memcontrol.h |  10 ++
 include/linux/mmzone.h     |   1 +
 mm/huge_memory.c           | 218 ++++++++++++++++++++++++-------------
 mm/memcontrol.c            |   1 +
 mm/mm_init.c               |   1 +
 6 files changed, 157 insertions(+), 75 deletions(-)

-- 
2.20.1


