Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DBC5C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 23:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB7966B00A6; Thu,  9 Jul 2026 19:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D68B86B00AC; Thu,  9 Jul 2026 19:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59AB6B00AD; Thu,  9 Jul 2026 19:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DB626B00A6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 19:08:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 209D41C7EDD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:08:09 +0000 (UTC)
X-FDA: 84970778298.08.5DF1DE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5901E4000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:08:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XMPYVnzp;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783638487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrvsWTz435qSeuQ7MkXJncgr8HSB0tXcJQzesUwSVlc=;
	b=fYytyizu8Zc89hHPpcMcWjjCbRIdT3A7tKBUrwnRoRjZA5O5ysHMmSdQ0HkXyNpogVW1CJ
	uAW3eq3AGRVhGkUcncURNNQJLeEvk+09glCgoPzR6kg/Ec9ZqjTgdgv9bY6k+M9On3g6gk
	QMY67Fi+IACvaeLc94qcJ5FOmvG5jvg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XMPYVnzp;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783638487;
	b=hf0Gf4RDx9FHq5CfG7Nme+rfB7ye6wb1KKNcNOXCdMb7VxuUg9JnvPVc0VSvVNwc2Fd9r0
	3pvdMiZSiPtkaVO+Nt3Xv9MPrdx6Wju9qaxhe+u8XPYbZRC+vHe+DLEvTYVCCeQG+TE4/R
	l3POD4xDY8tUCAOaQo7n4+xkkAt+Vk0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F72E600C3;
	Thu,  9 Jul 2026 23:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8CA1F000E9;
	Thu,  9 Jul 2026 23:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783638486;
	bh=hrvsWTz435qSeuQ7MkXJncgr8HSB0tXcJQzesUwSVlc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XMPYVnzpEX9f0UBhMb0AFQua5Zx3cNbDm/B0AFFGcRpVZo/yG6lGdx3nzh+bEGn0y
	 KMWgSup9nsqlEPWYR2X1uctCeeM780oiZRdBOGYFd5DtKJ9ZVQy9HKFOO00F9eidpa
	 gqV1qO3aZSx61RYVPs9rirVw1GLd9Vl90ebf8tgU=
Date: Thu, 9 Jul 2026 16:08:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
 anshuman.khandual@arm.com, david@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com, Wen Jiang
 <jiangwen6@xiaomi.com>
Subject: Re: [PATCH v6 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
Message-Id: <20260709160805.26e63bae89dd03cf2951104e@linux-foundation.org>
In-Reply-To: <20260709073823.6643-1-jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5901E4000A
X-Stat-Signature: 7sz4ys3dg4smezdm65i3zeatru16jif4
X-HE-Tag: 1783638487-181024
X-HE-Meta: U2FsdGVkX1+mnA/mfONTaISbJrNJsS6jQJYVeyWe8PgUGiygTf29z/Oj0epGf953veM1O8dZc93BziwK2Sk1m908lUhTR7XgVlwORkgussMEDk6P/3J/uAh/XX9t+MbhbWqr0jJd/Y1H9LB9A/dSdq6OwavCMZwWaOdZF8OHl/maDTfCP9t+7QOrKJVHnkJMQ+DnSX3fy6xsUj7JD3yL1NqXuJ5ZAE6MQ2gjYR3q2Oesx577qO6QAZWIzPaqMt0nvJcPb9PQNuW8vHSQ3HHHsPsObqBFy9UOPRU44GSDfWO1lvQ+qzrLk/+tsUpbdAu7GCOsOhdUT9Q2o5/4hf2podNDUscKJ5/vHU6PI29RxTH9mNU+dYMva6OiixzxOH4xXuFh4RqnzWBs7x9zRX9VWh8voXgaBXb39KDWM7L7Y/OJVqKYX+NmUH9sWKye7m5q/ewutd16z/zFG1Y54cUvN5XnVL0mtKemSI4eY84soCmUTdpEOl5E04BHCNrUy5AOXb5o1FFHwePUc6uTUX98ZervrBaFZffLxCL/h/9a6LQLKUSxMFF4+rw7NRWuVw7Q5PmrlC9HXpQcvRB1oDO6rSlqZ+o1rHRt/hqn9MOCTziKYRN9+TSOssCInGcIYrv6FF3e48pqT2C2DInXwdnU05pwLVvYNeU6e004y0QB5H/JYGzFfPJxE2mak2gFN7Y8dY20Vz4XNVM+JI4Mcmin+Ggimh2vcm1Ei1oFTdpSRXDEFeWpcWvWfr/EmzewcybbtFlK2MukciWl37NI1MWgtwcvgM8YHc9xwfHPkQB1bdJ9f7l/em3Nq/KzUt8NNqSFlN3tmzHPgUo2wISwVvzdJkx+szFnopz55FCKzyKwv+2fd61HpHPfVPxiOP/ARGUUsV0H+mLUIBqZJ74ZOUziZeF1LpUIN72RMQsRg5lVvdw6F5PyXStrRr+NVQDgfMuUQjTqiNDWdwYe62/m8o9
 Xzftwz2S
 F0xwSqTd+Enbx0cK49xb5RpusCaMkM2ntIH/kr4Gp8rsClOkKoamoFd+TP9uXoITNFjhZcddZOArZrRzYxPo4OrU/1RImj2UPBSUU7Qvj+JK/T0eRCi//pri1H2n5af+2viLG2lpg4MXccG/gxmjll3QC4AWM7yx1LYvyDve8H0OuTNhunpfaNODW4H0x4mIvL4KUEXcrfNAsmHxbxHvmHtd68C9FQRn+6B5+dEWaV3o2x0kideBQd6PWoxLGHtkzn6Bm0fn9vsKmXWzlXYFvDVG4Jg/LNl11ZA0Z/xTMHBAL/GKUAFizKyOF3tG/0eF/nMgBGaITtLU7NgK6eTDeFHmOt9CiSiKCMdwdFUDZjqVTSz9Jxcz378fII65SLOqPj9Z5YMbT7NQ1S7CZ6iPRKEaITXpHKYzlYo5XYEE6sSTf0oP76K8lDk8BIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 15:38:17 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:

> This patchset accelerates ioremap, vmalloc, and vmap when the memory
> is physically fully or partially contiguous.

Thanks, I added this to mm.git's mm-new branch for wider testing.

AI review asked some questions, and some of them are new since the v5
series:
	https://sashiko.dev/#/patchset/20260709073823.6643-1-jiangwen6@xiaomi.com

