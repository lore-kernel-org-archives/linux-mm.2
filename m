Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36EAFC79FA0
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 19:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFFAD6B008C; Sun,  6 Sep 2026 15:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB0AE6B0092; Sun,  6 Sep 2026 15:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEE606B0095; Sun,  6 Sep 2026 15:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A98836B008C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 15:05:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3FF440588
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 19:05:22 +0000 (UTC)
X-FDA: 85184265684.23.8782EE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6739B12000A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 19:05:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0DSUdFT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788721521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtAM+2bE0Rt5IW1MUTCf8ImDEJDLu+CH2iU80hmdl/4=;
	b=skZlTpqTWiituCkQYsTtoCQeEqJj4fWn3My0h/e+XO08N4UXXMsGYGiTbPFWu3CRB5T+fC
	6oY9Rac2Y8VAfDiOmqP5EAvzOPZ5xC+JqQfVuPfwaGNixMUs4eAmKt6uYiV83+60i/3mLU
	dqKW/B7qqS/rMmIfK/v3GDM6z4NQAOA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0DSUdFT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788721521;
	b=wB73ElaXh9SvLAZ4Ysgcudu+lC0mQlAFC9FsIh7lG5KoJNO4ay5zn0s0H961Mxg4bE/M7s
	PVqfSGbccrBCS5DynsrUvSoZiaj2oU0OGwFoS0miMz3P/+Itp7d1MehtuV0qkGM8g9miwz
	iffAaFYLlchd7IiuuET3EJIJSJkxtWE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 630804067C;
	Sun,  6 Sep 2026 19:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF241F00A3A;
	Sun,  6 Sep 2026 19:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788721520;
	bh=dtAM+2bE0Rt5IW1MUTCf8ImDEJDLu+CH2iU80hmdl/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i0DSUdFT3c6tYVS+//GqcD97I/17wah1Ryw8N2s1nkwwrEScYCZKdLGfnZvC/WTpF
	 53Q8JEqP+DoBDKx+ywlx4UIAinCp+Ze68MJkbvkMD5wq6UKf+iNSkvPrtv17YGBv4x
	 wVoqXaJ1SGuXL/znhrd/UgapwfNetF8hSRMEOJjvU+fyljxPYw/JyepxHblzox9Z6K
	 hEXF4WjHCWn+iQRcIKp/sI0IFWMUp+ySZoDSNrrst07GS6pGZNTI/HEyJd8bDOcDmo
	 G5y7wjqgWvuLGQ11XWo4vqq1broom0+UUDt2bUoPl2X5Fz+vQ5D43wFZ+wDDxDIcGW
	 7dr1AoJoszn5Q==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm/damon/vaddr: support {prep,apply}_probes
Date: Sun,  6 Sep 2026 12:05:12 -0700
Message-ID: <20260906190513.98247-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906184417.96621-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 68k9waxzdqp449eu5p7md9oueymmgipf
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6739B12000A
X-Rspam-User: 
X-HE-Tag: 1788721521-183905
X-HE-Meta: U2FsdGVkX1/ncVJzvT3CWSHh55CmFbaFeMei2gOfJ85e9CsHbtEk04JREzTVU0+R93q8fFABsp0xtoVSJ1dF63fBMa+OWrGKCYBfXhqgcGJVoRMarZwHDMl2vym/4r5OL/n0SVrCdQkXKkWIiOT8vwdd3vy1WDsrU6futatJDjL+dvfwnQOVYQ0Oqw2/o0pDNtJAInG2iCSbEzcyynIHIKBqHK/YhuJ9/mr8qXhC4AW8I12cMtpt9nNdIMpJaZF4s5k91MBSl9fx9FUCaN7ELFQ3NCskQ77r0rmi+ltXuR/ytsA7vFg0n+nCG1EBO9S+v4o+kgmu/E+nEIzO/VfQTNVv9uWxR8cXT9DhRKLj64dfu0g7iOd97BRDLhB25fF1YZBRvKoQY7ADRcsG00YF6cJPBGa+MmQX6rkzdOmpcRfD8wing+rv04wo2zhUlqV4Z2jzlcjn8KFSbVZTW3dmvZ2A4gnOPARZ0rqrnJquxZRz8d7ND1OPbaSjZ2foEcFflDO0bcw4ATF67PXIGAE7Y9jsfvZR4ePB7h6ZsrPuce8AVpxLxDAzYdfzWLiELvXxMjYMX7FHEdpsZtgZDcYAan9Gb3u6xd+kdKG06bclLwspp2YmrqqQujp0Ae/YMK35yOG2WqFFhNkpEiP3p63AcR507h8Ks9cWxq1Hl4bWtbRyrcURpCQm2wcvVEcEaaMlMoyBKpKMl/gTCPpClPoKiiff6R6BNIQx1SfOUUSfS5iH52hcF++0ZYRR7Veq8RZB/Qf/6N3ymssHbR2VxLY5T87AtepOL+d+/B/WF1e3P60i2UQU1eYFKTfoqUVUWkNNHUPfh00X2eeEd7PiirXLrXca3N8knu4RuPtey/9XUGL2y3QdtHItBq2I0XZACgyQ43z3g2GTdrcaPNGCUQUpGBw/2o8LkgISEMlhqu4A8SIuONDhe9fNMuhywC1glV6yokYz6pvgsdq+x7GNygt
 Kof9tVe4
 okoPiD/5x4HQCOmvsNVmpDxK0n5GK1l0CNx6uZGtxs8BIHYRz4VfRPATbTL7cAMHnKjWS4TV2owP3gWaeqlwhoRJSu76m4NBUwZ+FXvDQ2Had58hsGe3fK/VWehYNroJirkM7tTvZL5CjQhBE733SGGkDLpGnfEXYLcr04fCu3Lu37CJgFOqj6vB0ohIvqNxcAB9f0InmJCLFOz8edAQXmrEdM0KVpYnWdvFcevWi5tCoqkHap+x+MJcAAI/wr47ilDF19hxY1rfgNL9o0LQQ3Paa6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  6 Sep 2026 11:44:10 -0700 SJ Park <sj@kernel.org> wrote:

> DAMON supports data attributes monitoring.  However, only the physical
> address space operation set (paddr) is supporting it.  Add the support
> to the virtual address space operation set (vaddr).

Sashiko found no blocker for this series.  Sashiko send its findings to damon@
mailing list [1], and I reply those if anything needs to be clarified.  Please
refer to those for details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

