Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43E88D34088
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870AE6B0089; Tue, 27 Jan 2026 10:32:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EC66B008A; Tue, 27 Jan 2026 10:32:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D736B008C; Tue, 27 Jan 2026 10:32:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9686B0089
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:32:26 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D9DCD56ECE
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:32:25 +0000 (UTC)
X-FDA: 84378135450.21.CF7E174
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id F20CF1C0004
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:32:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MZE2Foms;
	spf=pass (imf20.hostedemail.com: domain of cheng20011202@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=cheng20011202@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769527944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f/d5KvztXzl954ECo1DrNWpBs2JGa4DcABvJH++iUvc=;
	b=knHQvgonItOzG5NwYAY5G4W5lSw6bh/S8DILiGE4fHh6G9+a6Ciz1FfEhTIfw8Aucf3N9R
	E2dwnbhhzIVcwkuKVmKkyRYaiViqOLnAbZJ0zi/Jr5RTKnZRtgRh/uScq1P/ajSkXySJbZ
	CwRLP4g5Ni1diSL8ko2an/ISfRK/WWU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MZE2Foms;
	spf=pass (imf20.hostedemail.com: domain of cheng20011202@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=cheng20011202@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769527944; a=rsa-sha256;
	cv=none;
	b=AvWxF7TYZKhbeNcO4amaiYsv65cdhPT/GwLMCgc5RtbSXJODAsGJHMTb+45uduebVkURKB
	XO7TuwBAYpuGkRw9MyzPPImvFq1G03Mq2J1nwP+V4vY8CrPgg12sGcTHIMDOjg9qsPbPv9
	AAxg+AO77ZOqynweLFNYQ7/26UdkVaE=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-350fe1f8ea3so2804235a91.2
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769527943; x=1770132743; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f/d5KvztXzl954ECo1DrNWpBs2JGa4DcABvJH++iUvc=;
        b=MZE2Fomsgvon4z3KmV+sE1eljtAysAsdYorDujEQvhQAp1lebwJdQGxXjPLsjLb4Ox
         RqhPvGcijmwfqcY6uIoQim9okupMjjvf2YVXYOp/cRae5cuA/fCvNlswCvsTusa+JuLS
         Q6rNLhqru4KpHtg2VGV4857Fbwj5InF0+P2v5Ft5Ur35drt5cuPYCrBMlEZxLR4PQTyD
         q8FzDHBwSySlq1lxruE1jbWro49JnncEPC3AFESvBvMSNkuVcaw7sgudPVl2MloeFExo
         IzAz6fq9bN+YpYLYTxHFhC+cfbWS1J4K4moYzvvjxg15ccGyDpqpCi9OuF2uduvAqcoj
         yqzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769527943; x=1770132743;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/d5KvztXzl954ECo1DrNWpBs2JGa4DcABvJH++iUvc=;
        b=mRhTPKzmUGvPqE1gzTnFceTzGQfUVOblDrI4anzGq1zneJZ9N2KpRXkQs0KZPaS5kk
         9LOWnyH+q8wuezOdHKEjbF+MywaxMZQGL45eMyDQ8Dt6PNLxAWJKljzrjIus/2GVLAOc
         jzHBIL/6q8tc6WDO5bl4HDvjyyyzvcGadNvGgKQpTuJzsc/6Lu5v2wxn7Qslhj3+82Tv
         4t3AQKIF8UwU+BjeHu4yQKm4ZPohdS1jEqHxBKyN4nHMBiN2V0fIHgwLKtASiUueMcUO
         aYaACvIxIatUoWcW6wcBu/4oSxKP0R4Yr/QDZI9LFsOFWVHhwNxJ121oaljAoWngOPdJ
         JbhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXitLKW6hC+62iSsP5HgA8Exy8EVsNAR3lGebOSjF71A2yYlz+SdPSiGrHucJeHHcwawptrEalmgA==@kvack.org
X-Gm-Message-State: AOJu0YzwdIrOiHQUr9yr/nbGYcoCNRIRXzeUP8bgeQjnWoJKIQqYmHjX
	tQayfmg1q+YhQLtsMkz1DDd6gNHOA+wzRtTPBsJCTow4u4TFlUxUX9cA
X-Gm-Gg: AZuq6aKgtI9xrE8gYgyVbS/KhF7WN3hV5qoJHg0LhIKVbfTlKud9FoNk35clkOSDgAB
	FOaV7ZhBdwt4mtCvxlH3kwqg+xrV9i3YgBumZw7KFxknxZ3tw4b+Bx7vr5HtdYJXrFKmluSR9Ap
	ZxqsUo8mTfZMH7g8fHbo0UXKE3ncQ7+U0mMT95v+g8QUWM4jZuXAII6iRxnGNcjmCBQMR19M2lW
	xiFWZ+t7EllLD/LN8O4OrBsZkyrCt5H9G0s8SxiaFmS1A3s/yD0ALzTkt4n1vy4TUYFpO1Ub9MB
	8rjJ9BTfOJzY3YL/AA12g+fyxdMs2R+Vd6AXFd+m8h0R25VVXs4fHVE4gCvRaMMX/wDPn6NFzRR
	eJAXXE6UuTfNsMjmak780TrtJdaZngaW6RnQjwoPp4/bFLJZepAGhRrurlOblnAh6xxZsfUPSIR
	uHblTBdjjDt1s0DCzW5OzhBoDop6yPvw==
X-Received: by 2002:a17:90b:3dcc:b0:32e:5646:d448 with SMTP id 98e67ed59e1d1-353fed70cbdmr1716221a91.21.1769527942596;
        Tue, 27 Jan 2026 07:32:22 -0800 (PST)
Received: from oslab.tail046eca.ts.net ([140.123.97.72])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-353f6128942sm2921231a91.5.2026.01.27.07.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 07:32:22 -0800 (PST)
From: Wilson Zeng <cheng20011202@gmail.com>
To: willy@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wilson Zeng <cheng20011202@gmail.com>
Subject: [PATCH] mm/readahead: fix typo in comment
Date: Tue, 27 Jan 2026 23:25:35 +0800
Message-ID: <20260127152535.321951-1-cheng20011202@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s8kpxch5sypkgkmcikxezbcz1qmgd579
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F20CF1C0004
X-HE-Tag: 1769527943-355155
X-HE-Meta: U2FsdGVkX1++xQUglUrL40GnTQLSMlsU+hZCxod62a97LVYywRuXj9R1OFnxT9PA8bPMKg0aZwtUr8SKUCb7E07U7P2OE8JVJa8Bk45lEC+HHxNZR8qVN/c9GBxGfCWudXeqdA0AoQ1s6CAcXIJLqTu+iSBY6dgz5uo44NC5K6X8UvdOh+GHbELcpyGwwGDhcJe9gUOn95AMVCKDtoypHg2cz8DOt8lDboVje4oUaeEVi4ZONi/rYs+VNoZxC2sDHz0BNPiVDxkBiT+Nv/n9Cr+j5dBKWYbFzfrmHAlRppn3XY5ZvzUbSUEXuFFEXVFgQ3SSKLp+lZeL1JLDhjrVgO59aee7YCj2jw54SezIEXGgGr9Wj2xbJIcPMX5IZd3Eroz4o+pGY7HDirBj/prTN/BbvWmqrfbemeDlfFNA1TtfVpD/Yvw0ZsNBdr53MDllkso1JWM0flVS/wXYxjjqwDF+lb7pyflX2BMtNwbOGaBYZIeLY8VKaKc6sOkOGn4PlTwQ65sX47zvkqhHtSo+icdYdOpH+jiA8poIvoS6RzMFBO3c6uzK9OgfAaz7c5IOiIfm07EFcR/zXF8ZIX0aYTHFO+mLifoRpPqVoe9kybkUkFTrm6mJTeCfYD6KgKOPKRpmTzc6yg9FpS1eyLgTgn6T3OwVXrIkwYA4KGO/UVFQPjCV9AzA5YzLUtKcMBaa0wRTWNgAcoPnPLBQBkpCxvTzcXS//oB0e0YnmlDMeiMI43Nzs+LHLM6eb9AR5rkDuagrlvOSekMsKgeL3NcaNCBp8tFD23WSLtIaJ3CukLhqyyCM+FQxBrBwXXd0mcWyM+CnI2I3KYL1uH0CrOKZwsM2LyPAUIsAPgpxR8FbFvo1V6Ml+QFE0DldYSDUVX77/fdvVR+VYzUIbcpD/2VqyQF1g1PrtOGV+Fz1XBtcBcbRBOqr1OfPKgz/sMQVsjjmpHvOcXQwI1Tybc28RkH
 FKOCckQJ
 y1zRHvHnRT+9q4iQUSRvVrYzwAF9PdFn2GDK6F3due6ygwNxhgpTwIT6/ygWrxJ8Slw1OzCPu3IrJihBj2s3Y7op6zy1JvByAIpl7zGvV8Etaux4EnStIVX2K2BwjSstCWdP05QooxJ7CM4BvMfsswjxIbu8Ysb/DoutG5fxcVzhSClVN3Zjb8eFyl8Oo1BQbF5EKdoC6UByWK2gJRcC7sNgQT8dZniroCk5r1DbaALLoHukSzW8WHw/KmDiL/4yvBq/frDhNvpJlZAn/j6Nv9Mye2QpAmMt118JjRyhK0JfoH8hYBiNty8g+TgYL0itMylf1sjiFMyq/JQeBMkIFHjjfqruFoaTpLZ17jmp+CK3XmWpXoUIopwlfbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000006, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix a typo in a comment: max_readhead -> max_readahead.

Signed-off-by: Wilson Zeng <cheng20011202@gmail.com>
---
 mm/readahead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index b415c9969176..6f231a283f89 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -436,7 +436,7 @@ static unsigned long get_next_ra_size(struct file_ra_state *ra,
  * based on I/O request size and the max_readahead.
  *
  * The code ramps up the readahead size aggressively at first, but slow down as
- * it approaches max_readhead.
+ * it approaches max_readahead.
  */
 
 static inline int ra_alloc_folio(struct readahead_control *ractl, pgoff_t index,
-- 
2.43.0


