Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E8E10FC45F
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 23:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41C196B0089; Wed,  8 Apr 2026 19:09:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4140C6B0088; Wed,  8 Apr 2026 19:09:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6C36B008A; Wed,  8 Apr 2026 19:09:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 081726B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 19:09:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 29533E1B7E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:09:11 +0000 (UTC)
X-FDA: 84636931302.01.A926562
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id B286E100005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 23:09:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VqbPU0RZ;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775689748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PWaV4qCR/WGGXD8PVteuM8/cl19CMqRooAS/C+4Q208=;
	b=GTmeUFqnRyqYk64NdE/pu2NWdJA9UFxaDxmW8cOUDF+GMiHZREQ2a0/EpmXSUgU2yqLmLz
	/oY45VXPZKURJtxpJT7ZDrCsca+48RIsCxAZJYdcTPO7dWKraveHoy5uBO9PLDzr6F0vfl
	xQ2Fdkcr7gjn5ebU3bUbnUDWwfotoFE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775689748; a=rsa-sha256;
	cv=none;
	b=PxNc0+4XDU74Hoc7nR28NU0QQh5+U8Yi8COxOY9ks2tCpxwf2Vh+QzzEfvDbmD9f8JSguE
	mGYf/SJnEEuA0Jf1OWy16g/rv9zAKUrgzI+zb+8+zdwx8xeifsndGmdfsVlYSPqzrsa7gX
	K0Rmy75ktmf2JxjlTLidY3e+YAShnNE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=VqbPU0RZ;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638MuEKe2688628
	for <linux-mm@kvack.org>; Wed, 8 Apr 2026 19:09:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=PWaV4qCR/WGGXD8PVteuM8/cl1
	9CMqRooAS/C+4Q208=; b=VqbPU0RZujwiTAEJPIBnECXVe7ODtgxPEJo66qu1VD
	0/Xa9xK3Oc6vEndNQ/p/ZuDOOL1bEstmtnZgEOpGkNzTVfanRqeT014axtc6VlTx
	EDffkx+F394AfXYf7/6+JCUlR1y0ZqThIpvXWa4YD6B9zk4e7NRQEXyu5MxJh73t
	YlW7N9GxmjO6QVyr0GSIFwuRxsy+S5HJwMCOsQNJvwV599WLcM2JE6qTKGc3IWHu
	4SNTTegj+V/RwXMjCiqmfBoR74Zn7dkl9kRdM0s4sZCeQQ11mMkAB0YL+58nPJSV
	1O09q4eBrFZpCl84ZtIJK6FcyAMznJ8Afhr7p/QHtAbA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4dda3n8v58-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 08 Apr 2026 19:09:07 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cb706313beso21996285a.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 16:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775689747; x=1776294547;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PWaV4qCR/WGGXD8PVteuM8/cl19CMqRooAS/C+4Q208=;
        b=tEaRnVaME99RJ+GLBDDI57bPYhsd4zs/7Wt619nn7S1OuUQkeWzN5TBS8YtfwRiLod
         oC3UzCalWDFBW3vwf5eY8gcl2JcT3oGJ9DzlvyFirL1xzvHZkrtbc9QAcBe1M3NP5ggB
         7AGmGbCJVjMUa98U0qJ5u8m2XRhpGQzNPmGGNcc5MCqizw0L8hbeVBuZUOuV5uV6zXO5
         bRVF0iJoO8WQHLuOFCZHnwLwxscTjYQArIZ/pCP06YMhYsty3zTmLkiWjoS5eievESLI
         zH6TpDwk9/mCYPF0wRPOVicV7eb76fQ2/T/j4opUA1WH6BLd01gs+OqnMpHQOd5PZr6C
         DCtA==
X-Forwarded-Encrypted: i=1; AJvYcCU2qRXBS5sNIFHKrzC/mvRwbAA5KwvNWGlGENpyf7WR5TbbUIeRJti/yPzhxjNfOnOryE4xCeiCfA==@kvack.org
X-Gm-Message-State: AOJu0YyiSO2dBhI6Svw6V38ryDMGtmcy4ikMIUzt6Vlf4mlPf4C+ihnB
	+Rgmv32locXfjrIxwub2NXmSquLbY9bVpgAWQdBid6C/ZX/jgKfmSM3+DvJKTGKuSTnf6N0F+Hz
	xA6bIuuWomT8480d8nqZOd79aAQpHfcJpXg71pl1607aRBCdg
X-Gm-Gg: AeBDiev4gBHdgpiwzhKHPWBawdmtA9w8FLqcu/DgC/v0/pqpwxNrBBSmcAURVJgel//
	kCpPpMyrlcNlMaU5KHBNCzMEbAVON889W3gg9ffaANsxmjoJ1b/JYimlclR5nucvbZrtOKnOG8H
	gSV6aSsKezhED9gA/6zjvqMa06O/naLOj0EUM+z5AwYR6EXwpKoRS4J1k/i9UddWTeJ/k9ZfmOX
	oLI9HTYtR9Su+WGIhpAl8yzjZ+StmlkyBV80YJz+1ef8DC2snYOb+kPY/TJEzntG50BXplUjwSU
	YozgK8Of/cbxLha5OKedgi2dIHBx3PnOfgFCDlhOpFwQ8yX0ajVoPdBB7vE4h/V46xi7dE54GRM
	uQV6IE/DboNbDYHlSD3yghy+JxrpBWcVQ
X-Received: by 2002:a05:620a:8812:b0:8d6:255d:877a with SMTP id af79cd13be357-8d6255d91c8mr2446190885a.15.1775689746878;
        Wed, 08 Apr 2026 16:09:06 -0700 (PDT)
X-Received: by 2002:a05:620a:8812:b0:8d6:255d:877a with SMTP id af79cd13be357-8d6255d91c8mr2446183485a.15.1775689746248;
        Wed, 08 Apr 2026 16:09:06 -0700 (PDT)
Received: from [127.0.1.1] ([216.158.158.246])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8dc1514d382sm125665485a.4.2026.04.08.16.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 16:09:05 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH RFC v5 0/3] block: enable RWF_DONTCACHE for block devices
Date: Wed, 08 Apr 2026 19:08:48 -0400
Message-Id: <20260408-blk-dontcache-v5-0-0f080c20a96f@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAADg1mkC/3XOy07EMAwF0F8ZZT1BSZxHhxUSEh/AFrFIY4dGU
 1rUl0BV/53QzVSdsry27rFn1lOXqGePp5l1NKU+tU0O5nxiofLNB/GEOTMllBVKFrysrxzbZgg
 +VMQBCgmAKLQhljtfHcX0vXpv7PXlmb3nYZX6oe1+1huTXFf/cJPkkkeP1jpD0cn4FNp6/CyTf
 yAcV2xSG0CZPaC44E6Q80HnvigOANgCbg9ABgKCuISAprBHgL4BcP+B/gN0aSyWGqLVO2BZll/
 hJmQrdQEAAA==
X-Change-ID: 20260218-blk-dontcache-338133dd045e
To: Jens Axboe <axboe@kernel.dk>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <dgc@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775689745; l=5327;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=eNN6J7KwolysQ9oupsl6H8UQYb2MhLRSQ3CeNcukCUQ=;
 b=bHlGuFQrrz6YhG5yOASexdE8c208+vSdTnDa69D9htKWSJqGlq3xd+2vFNoibaB4KXVVHi6Gf
 O+kgQh51awBAp3IkBP15pRJ2W7MKUTTcyJZMZ40qWyf4cXW7q7Hj++4
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDIxNCBTYWx0ZWRfX2FPb4qa4qCOx
 DsZoTxIsDEhHZfVXCQUQZ7Z8mLzmUtp9LLUl+QvE0brvNH+G2h+/ucGfgCSSpr7HiRpe3PNoMkj
 vhXw33yI940IF5fErPuDluJaBrtX5KqlyS+928XqME5UYH5gd//WPlKixBPGy2TgDmAvaNtInzo
 7Qt0ptJQ1ZqYcVSEyE3yYJVKjj8jkawzEyahaGFePw2FmzZjGU/mYd3rc+XpVm7tvFAuDnUFmI9
 rvJQX/spUULN620dd420nUQcluoMZTnskw6aWtFWfwTSQS2XhV0jmu+HQM0nOxqFjtX8ndi+3L/
 u9X67FvMskga60tZlFIF96yC5Gdg3A+3sob1qT+jAvsCMtNfx76/2REJdUPFzRTimLWXlUpl8O/
 BqeHeLC5xiUaRClb9ux8S8hybiMUMDofPS7EwGfLMmlkI2cl2W2EIhNmLRRiQkVAO6nAeT18Vjp
 jKiTEd+jJfvTAP0mI0w==
X-Proofpoint-GUID: 6TuaB1vHHRr0EzyAtwsihPAqFBQRz_sd
X-Proofpoint-ORIG-GUID: 6TuaB1vHHRr0EzyAtwsihPAqFBQRz_sd
X-Authority-Analysis: v=2.4 cv=N9AZ0W9B c=1 sm=1 tr=0 ts=69d6e013 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=mD05b5UW6KhLIDvowZ5dSQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=VwQbUJbxAAAA:8 a=jj9FZi3_KS3zrj8-0pEA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11753
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=10 bulkscore=10 priorityscore=1501 clxscore=1015
 phishscore=0 impostorscore=10 suspectscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080214
X-Rspamd-Queue-Id: B286E100005
X-Stat-Signature: zopdgc38heyczscdqn1u14s7x8p97h6f
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775689748-19996
X-HE-Meta: U2FsdGVkX1/SBakRuSGBcNQfi96DNu3asIfqnIE1zpH84nRBPsZnbe+z1Ya+aAk4+azpAaaK+0iJ4WFM8t37f5PZctTPn4lZLEzzhqvNe9mYM33IoCOsWYRNupAA8aFmylHbclWOW/QYatbC3T7edtGNxUkI6jBHFhgB/AjYgIk2JHsdgwVtMeZuvPcSxLtFSy4nFmaFnTyOyaXWdpu9TdYvFZlyZUFZ/cbOSssI4g4FnLERmZA4xwAfuifGeduT/zF8Yb/v9AP62rda90XR58gA/19/GEn6yOrxoXaZw4iV+Euq9zwTb6fC11JMIEBd1kaRXoGagEogfygbfsiW6HUOWAt9H+1k7yYpu8xy6McDVk2ybOa4rdkxgMqd6zX8wUC8ZmXLYSuhrhzlcMFzFzW1tiiST4MGAa59KTAbSbuEZfS/W+oSQngKoUbZm0DWAbz++xS89BcfxBz+we7/sBiN8ojNqONu8ueRJH26jGRXZxJt0izy/HxrYuRbL+eAI5VM51v1OiiKdlKWTpq9khznoCeK3MVDYWbm0ILG8QlqTI+oC0T1mE7tAf1abC2xfjFiK52baIzuoZG7czRKg/ksFK1lilzjiny3DKc7Jy74y4HaI9jnaWzwQ/CuX9xFlSsyIq/piAF0h+sCxsix838JeDYQ6zvBCv2ngrVL2/3tItSlY5ElO0Ya5oJAjy3/eLO1H2+JL3gaW1kXmtuDe0VSWq91uOibR4ycDM/N7IANNhiWs7MhKE35cuJ/UzP1opLuVM5WuPwKG2JSS+jZJTmpUO1mv15wStjAFy4QDZy7YueiNPzIPzR3ErpwCY7nLzSTPUxQgbhp7g9RH9K4cmSqPCCMmYXynJXvXR1VtVELaHtJDyLuVp4irJQoKua7lpXhgTY5ODPaljJ5xrbKrhosqWTPbQ6unn+VKTpaH3mLuWdFHjLOH18NtQ43U/TCoPPdFnG3OFwGKimpsjf
 pyXZCZTQ
 PfjLtGOfp3LgJm0Ivw8pRy4AQXVyXET5GT+eNN5TjPrgO8N7YFFqyMyWSst6SlErbeOAjPjF7HUWze5MX6BPLDQm9Axzwg8cV1Gp73IDj5dKqDS6+2HAfK4LHQ5IAqRpqyXI7QP4Tn12drP1LOCEYkhhCqcY5VdVaTBklNJkCln52pCn1qCja/F1Tv+4DyYV8ETsmsgHW6JxUF1ID9S2nZ4nar4DXvhK7iCXKqo+LmcjdrIkFCyexVMSzKqPap83lOfGIJqalYPzPNDOVu3RaewhMPlbZUEFPryHud7cQeboBmef08mtUiGiFC5GPQoeSodxH47p5DLO1eUoaR5/2g3hq4Tw4PsJAZTRentEP6cuDzljLi2eucx0yFaSh22O9ijHA70SB0mKoxWXKf7ERoUJzjXXG0mSC/WC1JFDZ9dwDYHGgbP/u4Y6VTp81C2EidBWXJlYbcOagwUhLyV9FkJbNE3/bNrOsrauNIoshSABhzMRFXJEko8wZPLktlw7q5e/e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for using RWF_DONTCACHE with block devices.

Dropbehind pruning needs to be done in non-IRQ context, but block
devices complete writeback in IRQ context.

To fix this, we can defer dropbehind invalidation to task context. We
introduce a new BIO_COMPLETE_IN_TASK flag that allows the bio submitter
to request task-context completion of bi_end_io. When bio_endio() sees
this flag in non-task context, it queues the bio to a per-CPU lockless
list and schedules a delayed work item to do bio completion.

Patch 1 adds the BIO_COMPLETE_IN_TASK infrastructure in the block
layer.

Patch 2 wires BIO_COMPLETE_IN_TASK into iomap writeback for dropbehind
folios, removes IOMAP_IOEND_DONTCACHE, and removes the DONTCACHE
workqueue deferral from XFS.

Patch 3 enables RWF_DONTCACHE for block devices, setting
BIO_COMPLETE_IN_TASK in submit_bh_wbc() for the CONFIG_BUFFER_HEAD
path.

This support is useful for databases that operate on raw block devices,
among other userspace applications.

I tested this (with CONFIG_BUFFER_HEAD=y) for reads and writes on a
single block device on a VM, so results may be noisy.

Reads were tested on the root partition with a 45GB range (~2x RAM).
Writes were tested on a disabled swap parition (~1GB) in a memcg of size
244MB to force reclaim pressure.

Results:

===== READS (/dev/nvme0n1p2) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1        1098.6          1609.0
   2        1270.3          1506.6
   3        1093.3          1576.5
   4        1141.8          2393.9
   5        1365.3          2793.8
   6        1324.6          2065.9
   7         879.6          1920.7
   8        1434.1          1662.4
   9        1184.9          1857.9
  10        1166.4          1702.8
  11        1161.4          1653.4
  12        1086.9          1555.4
  13        1198.5          1718.9
  14        1111.9          1752.2
----  ------------  --------------
 avg        1173.7          1828.8  (+56%)

==== WRITES (/dev/nvme0n1p3) =====
 sec   normal MB/s  dontcache MB/s
----  ------------  --------------
   1         692.4          9297.7
   2        4810.8          9342.8
   3        5221.7          2955.2
   4         396.7          8488.3
   5        7249.2          9249.3
   6        6695.4          1376.2
   7         122.9          9125.8
   8        5486.5          9414.7
   9        6921.5          8743.5
  10          27.9          8997.8
----  ------------  --------------
 avg        3762.5          7699.1  (+105%)

---
Changes in v5:
- 1/3: Replace local_lock + bio_list with struct llist, per Dave.
- 1/3: Use delayed_work with 1-jiffie delay, per Dave.
- 1/3: Add dedicated workqueue to avoid deadlocks, per Christoph.
- 1/3: Restructure work function as do/while loop and only schedule work
  originally when the list was previously empty, per Jens.
- 2/3: Delete IOMAP_IOEND_DONTCACHE and its NOMERGE entry, per Matthew
  and Christoph.
- Link to v4: https://lore.kernel.org/r/20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu

Changes in v4:
- 1/3: Move dropbehind deferral from folio-level to bio-level using
  BIO_COMPLETE_IN_TASK, per Matthew and Jan.
- 1/3: Work function yields on need_resched() to avoid hogging the CPU,
  per Jan.
- 2/3: New patch. Set BIO_COMPLETE_IN_TASK on iomap writeback bios for
  DONTCACHE folios, removing the need for XFS-specific workqueue
  deferral.
- 3/3: Set BIO_COMPLETE_IN_TASK in submit_bh_wbc() for buffer_head
  path.
- 3/3: Update commit message to mention CONFIG_BUFFER_HEAD=n path.
- Link to v3: https://lore.kernel.org/r/20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu

Changes in v3:
- 1/2: Convert dropbehind deferral to per-CPU folio_batches protected by
  local_lock using per-CPU work items, to reduce contention, per Jens.
- 1/2: Call folio_end_dropbehind_irq() directly from
  folio_end_writeback(), per Jens.
- 1/2: Add CPU hotplug dead callback to drain the departing CPU's folio
  batch.
- 2/2: Introduce block_write_begin_iocb(), per Christoph.
- 2/2: Dropped R-b due to changes.
- Link to v2: https://lore.kernel.org/r/20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu

Changes in v2:
- Add R-b from Jan Kara for 2/2.
- Add patch to defer dropbehind completion from IRQ context via a work
  item (1/2).
- Add initial performance numbers to cover letter.
- Link to v1: https://lore.kernel.org/r/20260218-blk-dontcache-v1-1-fad6675ef71f@columbia.edu

---
Tal Zussman (3):
      block: add BIO_COMPLETE_IN_TASK for task-context completion
      iomap: use BIO_COMPLETE_IN_TASK for dropbehind writeback
      block: enable RWF_DONTCACHE for block devices

 block/bio.c                 | 83 ++++++++++++++++++++++++++++++++++++++++++++-
 block/fops.c                |  5 +--
 fs/buffer.c                 | 22 ++++++++++--
 fs/iomap/ioend.c            |  5 +--
 fs/xfs/xfs_aops.c           |  4 ---
 include/linux/blk_types.h   |  7 +++-
 include/linux/buffer_head.h |  3 ++
 include/linux/iomap.h       |  6 +---
 8 files changed, 117 insertions(+), 18 deletions(-)
---
base-commit: f384d0b7710d3edaab718c02bbae46a4d3fd09de
change-id: 20260218-blk-dontcache-338133dd045e

Best regards,
-- 
Tal Zussman <tz2294@columbia.edu>


