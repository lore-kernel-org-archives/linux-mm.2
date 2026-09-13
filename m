Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 024D9C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C3C6B0088; Sun, 13 Sep 2026 03:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D3D6B008C; Sun, 13 Sep 2026 03:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757CD6B0092; Sun, 13 Sep 2026 03:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 498EA6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:48:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51D9B12062B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:48:35 +0000 (UTC)
X-FDA: 85207961790.02.63975EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8A366C0003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:48:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AQUAf4uF;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285713;
	b=s5cY3w8g3sVXA7PD7jwtx3V8NrnzN8cc4lUBE1I7ItWKh64o3x6PbGtPB4+RZ/aPK+a93z
	XQHwIu7rxS56+ms2wtBgfBLUoKT4XHU9oBP1VhW+xSKa/4u3oOG0CYTmoNZDn00vjiIHE2
	8Sj97zsdAyNpuaYxW+8yOujsXFQGW8c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=AQUAf4uF;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbTN56aFJwoSV1zh3LBt3rCv31f9RqWhm969uraW4/k=;
	b=nkEmbPqVILO0m0SNBEeG+XMkZGErRmPKTOr3bOPMfulHBXJDnIUK86A1y2Khe9JvUTxtbI
	4lqjoQVxIoZSxDj1DHpvSQVB/L9T9gE7ahz9ZygcDqLq4E8erqgQewrB8GCexzLLoCXaj1
	RPweAoDIxzyjgp1MwWxiqDlyrW3+gNY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 00E8C60D8D;
	Sun, 13 Sep 2026 07:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527F81F000FF;
	Sun, 13 Sep 2026 07:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789285712;
	bh=qbTN56aFJwoSV1zh3LBt3rCv31f9RqWhm969uraW4/k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AQUAf4uFkNStZ1Tb45HwVwL+jD4BDOL1WJROlgROMNZxvnKJ+C58K3zQn90022Z22
	 5YKPPtJJ4vXOvkJPPwHpKa2lcbBb03d0cwLGDwnpOZwAwUjItS07Q3ueELNy/b7JNp
	 Ac3EM806qvU69cwSlSAGYkBY7fvEsup5fnuhlPig=
Date: Sun, 13 Sep 2026 00:48:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kasong@tencent.com, chrisl@kernel.org
Subject: Re: [PATCH] mm: zswap: return -ENOENT when the swap device is gone
Message-Id: <20260913004831.884d37afd92249d763b7f1da@linux-foundation.org>
In-Reply-To: <20260913063031.1689420-1-hebaoquan@kylinos.cn>
References: <20260913063031.1689420-1-hebaoquan@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8A366C0003
X-Stat-Signature: qyh57ecx7p717ituhrm3qgboiqdep96a
X-HE-Tag: 1789285713-227834
X-HE-Meta: U2FsdGVkX18FZRT0gevv+RkribYqRw0BrIrNorDJ6guA7VF/LxUf3wI4ucp7cU4iRf6pyvGlMc0/gIdT+6uebv+cjPa0V7I61xo4Q51/xptsZ9FCgsDHQuOBbj0Q6E9eKT0L/8s5bVyPBq131QFxXYqqOx0iQM4+LAMJBTR3HXx9Qb2/2aDmhG88I30f7xKODOsLwbU1glh8/r/Rz1JRn6VX17bWHGroNlhji6ANH8V+yQuwpGvisLi7xdolqc0ZyHbXCBN08uUOQ8dBQZRYm5Jj8GZdmq39VJZcTsR4Irs6nP8X5aKiDB36n57WnwMirJ/vdqBqrXexpeH13KqphIMwONkAapfhQVGGpIp1CEO3KxQYxUUkpT/CfWKPDXBSxNePDzmdhSwP/kiJK14j4cAU7cAmvAKyTBkGngf/knmeiEn6tAA6XxPFc7Uy0VLvLJ8rX1XrSRbVbI4//1yw/VevrxeSG3NQic63t1pqzyPW4q06KCjPbDtJyC+F/vZIxmMZtV5rvteWTKHL7HHKRq1LOY+VekPNUWwGa3v0zdfb4JIQsxK5CdzNw+xXxupPYFfIynG/umpMBLWOPWMPy7rK7wjrd8F/TdV/7KsgfheFFqx7Oe1d18pH9lfXi2XJTC+WoT5bK7YGFRcbYyDcQTi00EBjCwCdppDsIlMPjSRbCh2i7hdX3VXbp/Xnu/Kp8oW6HE2WB7zcWH+pw5YpilBSGvue0veKuBv1FVu8pVlsVynlllnl90tJvyi05D8TKFDMYlcEGruuX+qroY695fLMwSm8JDw020L+ETa7XSSJ/haqQ7Ycmj7e+Rc99xO0SDoMYf9CYZNyimeWKaHADpznfh+I99TZWMd0Q+usasnnZTibCn2u0rs6/GnIvZ5ujKDgShgrEPnzewbe/68agn8oBe6nX6TlIn4LIj73G0xqXNmBeEjkBcI1I3KBrwAPl3dW/lSuwSMxzsdu7+Y
 Y+i39NrN
 1QsagMvdavKvjyYXpgMV8NEIZpJIVDvkoI2gBT+hx1kRA90bjtBnvzEbq2HrjeUtr+A2eqADJBQQJPzWiEC+cn1+rGzJKwxk2WvFTPPm7IjUeDKq9SEwwioEFp1NlcQDk2OEW7BKDrK7FG7aFJvBXfltMHorySe2dKPY8pdsCScduXyXH+RSZuFhyxY4Xyv0LZm/8JCD1kLJtIReHuJHu8+JTcEM8DDMNDHm8vRIvFHOHSTTibbzCzXxEIkZ1Lhb05IX3nKLx1G/IYc7dF2jkGq20rHbTmueWl1mu5IfyV5iP7ao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 13 Sep 2026 14:30:31 +0800 Baoquan He <hebaoquan@kylinos.cn> wrote:

> zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
> device.  -EEXIST is the shrinker's "page already in swap cache" signal,
> which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
> get_swap_device() instead means the device is being swapped off, so the
> entry is simply stale.
> 
> Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
> Independent of xswap; affects all swap devices.

I'm struggling to understand the userspace-visible runtime effects of this.

I see that reclaim will prematurely abort, but is this a once-off thing
which will resolve on the next reclaim attempt, or will the reclaim
failure persist for a significant period?


