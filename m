Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 553F4FD9E34
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 04:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D796B0005; Thu, 26 Feb 2026 23:31:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9D26B0088; Thu, 26 Feb 2026 23:31:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8756B0089; Thu, 26 Feb 2026 23:31:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 089816B0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:31:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D7CD1404AA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:31:49 +0000 (UTC)
X-FDA: 84488963538.21.FE0FD86
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id E995F1C0004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 04:31:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RrZMENkT;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772166708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=55YZDGQMTCK7GTP+VSa2Zmv9jAEStT9QvPaozvGJSiI=;
	b=F7qW3DYpU21AETMcDp262e5zpHW6ZQw45WT/NxmhRe+5PC7QjTcRCbN6qQnf++/D894nae
	KvgcYUXvss2h63HkD75xxdoX39pjTEop93a9jV43jZk6ilLNvzk1Ct0JeeGS/ahxFwc5FP
	qsH+ZG1ZqMyU3EoLR0KC3uZfVTSeCEc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RrZMENkT;
	spf=pass (imf21.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772166708; a=rsa-sha256;
	cv=none;
	b=5/1b8Kns2jeSHJeCXKgIK+IK5VIC0+2R7GPYQ8q93Nn2ZaWc0TiahQ3gT/n8a3JKkhCmpi
	2uaNrqN5EUpJDpeDU3t8SQMFLkvWGTFTyAS7y0USQcLAhAhh2GccLkMjDifIH849SjrnKr
	2FREbPi9YgwN71s1FR2M0yffSKsI/dQ=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ade574f05eso11197215ad.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772166707; x=1772771507; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=55YZDGQMTCK7GTP+VSa2Zmv9jAEStT9QvPaozvGJSiI=;
        b=RrZMENkTuS4shx18mU4wlS16JdamhsOM7OUSJbpBoB+lqqbuFikaanVt8P1PT7+3SL
         xNg3VX8sPMw3KybVoJCq4ij/szg/j18n67a+3mY4B43iSsmSntq83U3naVe6wNzcWe+b
         k0YqIIM0o4O7oIJ6UkmYbLGQewVA3ghk8P/zvoeMWmVEH/PGoe1P4V05ge1LrKkccYKT
         vtzqT6AzmKaXdgd2dnAtx1lm8yAW0d6G39Wfqrvd8EG+bYrwiPoIZor+jXIArmI+zWDA
         MPaf0VvvABSWbQmIWqkH8fOr8ZjQXKIq/olXnuV4INRpsANSWwfDe/Ju/0Im4qzNiAOO
         vurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772166707; x=1772771507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=55YZDGQMTCK7GTP+VSa2Zmv9jAEStT9QvPaozvGJSiI=;
        b=eIN5ieYAU7koPicBEJNyUhgFuF/nuR5IO4FdEl46xfQ9We5yl9mTaawhL/gYBATH7k
         hjf8NvwiTioc1yxO3QxuIvlLRA5slm/D/8t5btF9riCRRNbIL5n5uuRM9/GrSlfNlps1
         UlEwkBNNh4fzSOxBsahO/eSvXSsa6FqoLlGTJ8XulAwTxZ1enx5Iu6A8oS6qIzI4ekea
         uzCrQaw4puS5gr75o/vEXIYndzEfMH3GCQ743o1y0rBmSbHIqAcZ2TaiU5VcuYRzrmiK
         cINAZxSMsxo7k6spzytrPo8824aF0ptnOB1eRqa+yTVu1GjiDDjpth/cOOi7SAr283hk
         te5w==
X-Forwarded-Encrypted: i=1; AJvYcCVlOPw3P+qt9B8Mh27X1Flt+N6DOtKAqVJpch1Gnq3v9G1rYh0+/y91syHsLNQQdB0mTDV8yTBJ7A==@kvack.org
X-Gm-Message-State: AOJu0YyCh1bzrguwQw+b1xTtoBcfUbUvX3/KqOBrEjD1RYKmlrDTS4Hc
	TM75kEKMLLj+ATDqE7ZPhPomYK9um7Y5j33fgM2b0Ilo/t05M8WSYjan
X-Gm-Gg: ATEYQzx916iiee+d8qqVk+JILnGSzizDUdbY4uYME1r+oa6Aep+vMJSlMAI+C6yDjPI
	nZ5u/dz4EO+hVWt4wP/Rt1WjouphIaYqRr2cEW7cdw+971uTlQV4f1uDwaOwyEumTrEyURkAwb8
	kW7/DR6i47Sls5SyPGkfadrwGRvuS78ofMPXG1/Mwgy9q65V4fvIF4OYiuNMS1Ula+IIJ9GsppM
	bqm0+79NbKeBWtSLiDBPbtKnP/lopKSrMCeHAr5sDZZSVCEJy8WiWp4f25O+zIuRlXRAenXbiCx
	TR3DyRImAW1VoUNQO9/WMmNo7GwK0YZrANS5ooI7ofXN6m2X6KnBO4HGLHsnBCD+cFpiAcfsi7W
	CZQXYoVOJm+uiusE6nncSoK9jxVl0xpu1sAl6TFvge68NQbVA5chrGfZhFSHNDtjmR+U3/BuR/s
	6wdMX7Sug+op1VgaGPphR57eqBEnENNBOHcuvJ
X-Received: by 2002:a17:903:2283:b0:2ad:f7a4:af96 with SMTP id d9443c01a7336-2ae2e4b55ebmr16150475ad.42.1772166706662;
        Thu, 26 Feb 2026 20:31:46 -0800 (PST)
Received: from Barrys-MBP.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b1035sm57973225ad.7.2026.02.26.20.31.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Feb 2026 20:31:46 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: willy@infradead.org
Cc: axelrasmussen@google.com,
	linux-mm@kvack.org,
	lsf-pc@lists.linux-foundation.org,
	ryncsn@gmail.com,
	weixugc@google.com,
	yuanchu@google.com
Subject: Re: [LSF/MM/BPF] Improving MGLRU
Date: Fri, 27 Feb 2026 12:31:39 +0800
Message-Id: <20260227043139.95115-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <aaBsrrmV25FTIkVX@casper.infradead.org>
References: <aaBsrrmV25FTIkVX@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E995F1C0004
X-Stat-Signature: o6cq74ongnufhzdn6bfsfhsx7dn175gw
X-Rspam-User: 
X-HE-Tag: 1772166707-696904
X-HE-Meta: U2FsdGVkX1+pJX2lF+GCN21cHPydAK60hgHbjq4cllC/sO6MW79dJJAflZrSdCVIp8KxaY6VSUHtwsSH/o865tWct4JRf4cTrbgoly9uEszLuEoUVD9mDIkciwDXJ+KW+LeGPzUR8IRZP4c/cBNCCimGxgpvp54Af7mCx0YYZ3xdalf8vgJDM/xiZCWoC//9FuFK/eAra01QJX1nc1f0G7aUnuCsrN6vLX4IEDD/RcKYlxhopdpek+BJH0dy8M5ZMxTZiFX/eZfO9GjQrEuwkb0+/Wu0Y9Vn91bwK1IFBIDnxZmh+3M3gjZ1Gb8lzxOU6PhCULEz/Qfh8IHV8SiaQKHaNsqydOcU4y+AJPeQTS+WtRgliwN1bdMZ0XoltPjcHaNEwhFEiufMuUXmZUb8tnWOBMuux9fQUC2nyc+Xlrmc4M1ERA+qepbcY6CA5nEBIgRKNGrUc6qBqnmdZjCHCFc2bVhpi9474YIf245IArS5sZUc4nqawBn3xR50/2EyTJIh5x7tWL+SxeSWVetnREzoU0ITYbT59WvA6aoDio+uCWzunaCLgPWYG7R2b/Vd9MDwg1mEDjjN3fNJQqyxiuGHh9KECFh/WkjcEtNOYvJ39UA0T+VJEYb5CV9HNaG2Zj8IoUJsV9hpXI+2NR+V54BmFGmwBhi9dugrR6r2Y2lo5wHJ7zem+EOki3ZVJkMt9VEIf5cqgC2RkyeU76cyyghadp3hf6AKhHqUoqZtLTWNtrhMD1Sp2Bxyt0pXXX5w7EACI888dIVG0nABHS6GR0/qJbJZWRnGLN9/ErCnaxJ30GiSKB5EpZzkUr875bjxNPuowytFQE5XqVPCNArMaVtZTbr61XXQB484ptoXjxgsYRawZqkvPU1+47y7x5N2aQq1uVzAoIYMt3/MDzupx25TF4GViBufNme596jao6K48F3ofOtuuynS/A3IgUVljY/wN76yPEbZi5G+QcE
 dedxUC9j
 o7xozIBFnimzf6Ts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> MGLRU has been introduced in the mainline for years, but we still have two LRUs
>> today. There are many reasons MGLRU is still not the only LRU implementation in
>> the kernel.

> To my mind, the biggest problem with MGLRU is that Google dumped it on us
> and ran away.  Commit 44958000bada claimed that it was now maintained and
> added three people as maintainers.  In the six months since that commit,
> none of those three people have any commits in mm/!  This is a shameful
> state of affairs.
> 
> I say rip it out.

Hi Matthew,  
Can we keep it for now? Kairui, Zicheng, and I are working on it.

From what I’ve seen, it performs much better than the active/inactive  
approach after applying a few vendor hooks on Android, such as forced  
aging and avoiding direct activation of read-ahead folios during page  
faults, among others. To be honest, performance was worse than  
active/inactive without those hooks, which are still not in mainline.  

It just needs more work. MGLRU has many strong design aspects, including  
using more generations to differentiate cold from hot, the look-around  
mechanism to reduce scanning overhead by leveraging cache locality,  
and data structure designs that minimize lock holding.

Best regards
Barry

