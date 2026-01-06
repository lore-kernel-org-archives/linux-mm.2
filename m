Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A68C6CD0432
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 03:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1C306B008A; Mon,  5 Jan 2026 22:10:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC3C6B0093; Mon,  5 Jan 2026 22:10:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE8D46B0095; Mon,  5 Jan 2026 22:10:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABED46B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 22:10:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4EF6A58742
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:10:58 +0000 (UTC)
X-FDA: 84300062196.29.488C8C3
Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7950580003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:10:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767669056; a=rsa-sha256;
	cv=none;
	b=btdZ+AGcbOKUSMgShGBIbifS4+VhND6eCFeTEYBz0mIAYzjN/C95Van3KVTl14NG6/Molp
	waRnugH2ohdNgoq1mqcNq4s3CN2UULumZGs/E23IScLg1knMXAbDG42ClpmWqp/knI7WRW
	mLCZoCVBjis/T7QLcbU6WphTSCC6+HI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 129.150.39.64 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767669056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=jTLtCCaYurJil8YqoH+5MOsohAzzrJ5v4M6c1ZSHKHM=;
	b=JErp2L0ql4DwW/GlwrLuCq22WsRI3MdKvve+eexRadZwt9ms+v+KIRgBmrz73E/Rrm+u2R
	AmNw3hgZ1YXk7F34/tb+j+1ifUpgeybSvZlFbSh2GPplQFONd8azsM2g9LYdYnyQpIMU0V
	4yOMv8JnVagUJIf3YTfqs2bouaBV+F8=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with SMTP id AQAAfwCHjJg4fVxp0tlnBQ--.5211S2;
	Tue, 06 Jan 2026 11:10:48 +0800 (CST)
Received: from localhost.localdomain (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAfwCX7eozfVxpE1ARAA--.16517S2;
	Tue, 06 Jan 2026 11:10:44 +0800 (CST)
From: Cui Chao <cuichao1753@phytium.com.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mike Rapoport <rppt@kernel.org>
Cc: Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/1] Identify the accurate NUMA ID of CFMW
Date: Tue,  6 Jan 2026 11:10:41 +0800
Message-Id: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwCX7eozfVxpE1ARAA--.16517S2
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQAHAGlcG0AAvgADsV
X-Coremail-Antispam: 1Uk129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7
	ZEXasCq-sGcSsGvfJ3UbIjqfuFe4nvWSU8nxnvy29KBjDU0xBIdaVrnUUvcSsGvfC2Kfnx
	nUUI43ZEXa7xR_UUUUUUUUU==
X-Rspam-User: 
X-Rspamd-Queue-Id: 7950580003
X-Rspamd-Server: rspam10
X-Stat-Signature: bm3hxqcy5ohnre16ybrk66cqzdwxwoqp
X-HE-Tag: 1767669054-824861
X-HE-Meta: U2FsdGVkX18OtTWRxLrHpHODI9Yl5XcwftKyHrMa0sbdmkdeepMt4UZBFIBo8GWmZPWBz6BwLZkTcX1NY/Cy9WyBBaVTtgSOP55Im4aBzqxmL/JKMEjEuq3UT0QnfhxEQrkG2ZxjIl0/sOGSiw6Wht8j1Zf9gLLcI79vq+yLz2jGPgCTjcdIV60SX91HPMXUlURk3z0M4g9bFHMWxxzjAgksPF9ckiriJ8IiL/3l4TSsKKpJRm5J82+5SwAuMMcJcme1ANUg5eHxO7q4xeDJevvM6Qqq1ececW2JVERwveNBSkSngKsfx/aD4iyQtOqjwbTwSEpv8Y5uzdE0rwukyTRGsFu9Bi0csEQ6oYXYjDqM0/nQAq/DAKA4Q8MZoVvVoB94PrVdMihwbtqWo66+7YYu39A6bwSqQXYLsZ9SwTPBK0aJp5p0XltNmKAawhpD/yPmhmc1a/MwlyuIfAq2VNRhFv/oG5vlw6aYAohrJZ1oTRnonmxiBvgZ4Nh0Gwpf7GtnfRXd3XKoXKHHNwKw8JnTd5swBPDkCWx54+vHRgTNpCGGDTkN9I+jiRIzLubH46wF+W6hdWfQGGbNICqxLZsfLj30jmnwKl8eFb29RHmbm/av8AIsYNNUROXuTPPn9xc/FtYGSCGkR1h1ZG+cs3uGiII4c/m1iJoKBLz8a03s94BuwNQAXjMA5Z716uCFcmBrLBs9UyWUBtd6IcsxTfSRgXlp1CfK4/oPJSnMxFCGmz1iy7dDdbU7oZV8P5QnfaDE9XBoMIbL/nvIObOsBcdOuJd3oBKxkR9TdjCaH0p5IKRpoyUq6F7ifSqR46CwLyX4+8PRMFTqyqlG+SkeXl0vMrqMzhHPNPkTbKGH8bDTyVqv0+v0o5vGgNftAwL8zisyTBYYXQ4tRCa8b/Pvnf4kJClNpcfppNeNXQjIrQ27sySfn0OZc4suK0GQy38+3iue8MnhM8X4VeuF/x8
 uVK2L2tX
 owD1Shtu+qhzw2clFE/+M3Oaxzm6/lw+oRJUC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v2:
- Added an example memory layout to changelog.
- Added linux-cxl@vger.kernel.org to CC list.
- Assigned the result of meminfo_to_nid(&numa_reserved_meminfo, start)
  to a local variable.

Cui Chao (1):
  mm: numa_memblks: Identify the accurate NUMA ID of CFMW

 mm/numa_memblks.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.33.0


