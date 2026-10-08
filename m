Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E42A3CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 15:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD856B0096; Thu,  8 Oct 2026 11:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAECD6B0098; Thu,  8 Oct 2026 11:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4D46B0099; Thu,  8 Oct 2026 11:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A86E6B0096
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:24:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21320A09F1
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:24:54 +0000 (UTC)
X-FDA: 85299831708.16.98318F9
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf19.hostedemail.com (Postfix) with ESMTP id 90D761A0004
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:24:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Q+cFc2Bv;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791473092;
	b=5X7OD9W4fwwiPX1oW0X+vGLk7BdyZIaJZHF9AVQtVIlxJBy52YXL+2cGKuhldv5cP5O/zt
	arMsSNh5rCJkylFyLDtDL8+CPKWEtgIsWjMjJLiRXZyIVhck+iVo51nWedw8zu+0YThHXq
	w3ByTdRQbI5+hB/3CKxmYFayrscTMus=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Q+cFc2Bv;
	spf=pass (imf19.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791473092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=axdWlSF8iVBum9thK6VZopslDZXT2NtsjnEhYF++jeE=;
	b=3hEXjV4ql0bJG29lJjmtUgJjoGQBvnXAxFKB2Jfv8dFJTs/UYIsSxyC0+lxEDwxOqabSrl
	M5CSlLQJxa1xf1twEszQ2qkwwRMhqaYXAV4WMd4Zydw1tMxtTTrbeObujL0CR2oY6xyNi5
	g5BjSBsXt8Cg/5SNO5hMhqIJ2uWkZRI=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20261008152449euoutp012ea15825cc73032344637d08b5a70ef4~cl0iTT52h1734317343euoutp01y
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:24:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20261008152449euoutp012ea15825cc73032344637d08b5a70ef4~cl0iTT52h1734317343euoutp01y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791473089;
	bh=axdWlSF8iVBum9thK6VZopslDZXT2NtsjnEhYF++jeE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Q+cFc2BvfAM6hq8BNBVUUGEJpLtazPQXVAyigshd+9gBPaXqou6aJyXlWskX/fV9m
	 NbT7TK0KANRA7mvHXcTSe7avEDlvsp0umXP08TMlD+4tsO0xOd8St9ZeroU+hWmLIh
	 t2ZpTNyQruGKU8Zfgua74G+f7qBRuzR+kiVC2Lec=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261008152449eucas1p29758be26c325084093c14cfa9b8b2d04~cl0iBiRnX2366123661eucas1p2o;
	Thu,  8 Oct 2026 15:24:49 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261008152448eusmtip229196db7cd15a42beeda51a2f89401c1~cl0hjR3uw3039130391eusmtip2O;
	Thu,  8 Oct 2026 15:24:48 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Mike Rapoport
	<rppt@kernel.org>, Rob Herring <robh@kernel.org>, Saravana Kannan
	<saravanak@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Wandun <chenwandun1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/2] of: reserved_mem: use dynamically allocated
 reserved_mem array
Date: Thu,  8 Oct 2026 17:23:59 +0200
Message-ID: <20261008152403.766439-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20261008152449eucas1p29758be26c325084093c14cfa9b8b2d04
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261008152449eucas1p29758be26c325084093c14cfa9b8b2d04
X-EPHeader: CA
X-CMS-RootMailID: 20261008152449eucas1p29758be26c325084093c14cfa9b8b2d04
References: <CGME20261008152449eucas1p29758be26c325084093c14cfa9b8b2d04@eucas1p2.samsung.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 90D761A0004
X-Rspam-User: 
X-Stat-Signature: skrsekakqrkzsyoiw4rfambyanm5s7fw
X-HE-Tag: 1791473091-44401
X-HE-Meta: U2FsdGVkX18ML6o8mtoN19n1GD9Ce4C6Xc2r05RYwtGypiggBkoOT5SFr5FRNoF5PtlRSJ6XmDVk4SuaBtJoKmelkzj9zjrDXmQwf8++F90hGu8QkKia+GHGyK6MTGdXS9L8KMhLyJUi4IpOpENvOM6wDgKl3C8qiZAXCfcC5UohtCKneQqQUYgamsm0xJjSGm375pa45U38PeiQQ6tIYCR7F8uQwImeWaa6NJXd9QD5L5gjSTRZWy5U0zpiKzf9t1h6UjtKjaIcuPbIADDZqARxLWqG7L+fFigFjSo1bf3d8rwqwbexdEiPhXDKqWrJPg4X8XFSwDOUNUhxYYEA5VvXhVb+D8xfIjcrsvPMnw8kRLu1RQT3lawr7YOaP3GwuJftxxBDCGJM27WJDhFlFUM7eqHFrq9gvr3NmMZZoaOF3eg8HrQC2BmkMZqn4a5hvzdpgjhhLDnsZUVPqnLnKEPD1k62b6oD2vf+tHO4KBDiYvxYV7nrm8mwn7e8+jFb3DQRZLI5zWHfWTv8zsxP2ITkszQFIUWkZtTWaBRq1zyau7F21glR4T1Wq4hkCQOGab8KCFqVmv/4ZPpkgDa40CWYF22Jtpe9B9f4anvwcRgq6IAKkqDJGK7yQfkCXmKuoNYNvkWuzFPLHzVKVaYr08MqLMX0UyMT3EvslR43BCZXanXPWHorN0oOw4OO4QGBTvTJSfz+Jo/KhIfy8WZeeA6JCk3IEuxnSaofkvFYOfoyHej1j4VzEAQP451Kx0D4I2DkHlj96oMlevKPFK+5o+HdnhA6ZY3gR2TPVpwdADxY4zd7ftC0bIpaJC8+v7701PSr0vX8mbtOYfJXh3vT5OoOj/I2poazeBsWAOES/+1dsjNSKrXwX/Ccekm0hfS3MoOpq4cVsCP50pVzNAQegPC9XFhAHF3JSVGUoZjw7XvgtNpXTP1HeoBS5HJXhkIDs9wiGJeNsqSNvUud+xC
 rJ+iVGgc
 mbMHbKJXf183rF5h6PjJSx+6FYQPBrPNnSIx5O3zH0NrTQ8bG+lwpu9eCbcdKR9CpVrtVBGcFGxKA1QhPQ755WjmSQ98gMVpR/L6qi+s3d3iKkiYwcl61EiOPKsh/Yi+dxolNa0Y2+kdb50o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport suggested [1] how to properly use dynamically allocated
arrays during early boot.

Use this approach for reserved_mem array during early scan of the
reserved regions. Having all the reserved regions in a single array
removes the need of the two pass initialization introduced by commit
8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved memory
regions are processed"), so implement it to make the code simpler,
easier to understand and ready for adding proper error checking.

Tested on ARM32, ARM64 and RiscV64 based boards.

[1] https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/


Best regards
Marek Szyprowski, PhD
Samsung R&D Institute Poland


Changelog:

v2:
- removed superfluous ifdefs

v1: https://lore.kernel.org/all/20261008094125.3197971-1-m.szyprowski@samsung.com/
- initial version


Patch summary:

Marek Szyprowski (2):
  of: reserved_mem: group allocation helpers together
  of: reserved_mem: allocate and map the reserved_mem array early

 drivers/of/fdt.c             |   3 -
 drivers/of/of_private.h      |   2 -
 drivers/of/of_reserved_mem.c | 455 +++++++++++++++--------------------
 3 files changed, 195 insertions(+), 265 deletions(-)

-- 
2.43.0


