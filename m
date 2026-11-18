Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2950B606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 06:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=eDdeS7wX
Received: by kanga.kvack.org (Postfix)
	id 316896B05B0; Wed, 18 Nov 2026 01:04:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C78C6B05B5; Wed, 18 Nov 2026 01:04:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B92E6B05B6; Wed, 18 Nov 2026 01:04:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECB236B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:04:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F941C0443
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:04:28 +0000 (UTC)
X-FDA: 85447200216.25.D99688B
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7396640003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:04:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=eDdeS7wX;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of wangxuewen_ky@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794981866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=50UO4spYDICj4mi3ZdEnXll2Arr6GI+je5ElQT9Qz3E=;
	b=Yzbnww9mLTQIKdDjp74sBY7+YheQctjjaMtTWhG6NADofMA+ag+YBSUwhv54gWCNwLDVAU
	J/duEJJP0YEvkXnVJ0KaXo3OUpJ+leJPR43CHmFJu0ltLzOSXXVtFAadz72rTtwuIRr7N6
	3QSXdqHWmVzFJuqgwe3Ty+S/nJaAnxA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=eDdeS7wX;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf01.hostedemail.com: domain of wangxuewen_ky@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=wangxuewen_ky@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794981866;
	b=OINhJ7qOWG776HOUJy/LznhJro8qZuAmLrwPXgu+r0bgpEUsXsUcsJ8cq/e+zOMtBtaKKB
	NC8MH6lo+bhiGF1707Y1bxCnfZkMtobH0jNCd6kXFldMHVzYunzzbnkHm/NB/pYaIw5SJE
	FlvS1o+2oA5fTNM91XEAdZkCDZyrOR8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=50
	UO4spYDICj4mi3ZdEnXll2Arr6GI+je5ElQT9Qz3E=; b=eDdeS7wXUAFpBLXrBb
	yKsK4gq0d8phNCG45nQzHS2uQBaxX4YcBESGkEoXbLRjU/q/Hctxinct6a1jwcCe
	OHL3WOC2c7/1z2/Gvo4BMP73t5SybZJEBxzjhx4kdemmasPsDPo8XCPIhPhrF5zs
	MKcEAViMvaq5i11hMkgur7Yic=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wD3HwjJP_1qmvfEIw--.16665S2;
	Wed, 18 Nov 2026 14:03:54 +0800 (CST)
From: Xuewen Wang <wangxuewen_ky@163.com>
To: vbabka@kernel.org,
	harry@kernel.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	rppt@kernel.org,
	mhocko@suse.com,
	surenb@google.com,
	sj@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH v1 0/2] tools/mm: slabinfo: fix inverted sorting and totals
Date: Wed, 18 Nov 2026 14:03:15 +0800
Message-Id: <20261118060317.1802620-1-wangxuewen_ky@163.com>
X-Mailer: git-send-email 2.25.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3HwjJP_1qmvfEIw--.16665S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF4xGryUGF1xZFy5ZFW8WFg_yoWDuwb_Wr
	Z7Xw1Igws2vr4xtwn7ZFsxXr4fWa4akFW8A34qq343Gw15CwnYvFn2y343tF1F9FZ5Xr4a
	9rn0qryayw43CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUnk9N7UUUUU==
X-CM-SenderInfo: pzdqw5pxhzv0xbn1qiywtou0bp/xtbCzgocBWr9P8ri1AAA3J
X-Stat-Signature: h8zzy3znt47iqnw8bqar79dxbqyhoqdx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7396640003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794981865-229999
X-HE-Meta: U2FsdGVkX1/t+b3I4jFafvSsAKPH9m6qnUPQeGDGhs9ppiKwafNXGCD2Uv0zoaTSDlAnoxypsjokxba9pFm7m/fFn5Yo3jctjC8V+SZDcNLd1CZ7oZ1Ja1PNk5RXOvvioP06M4J44R+1gAypCQl8aj4wBZh8gHT0TgqbESh6dz9ofjkWNWWLV3xUoydEMlZq4jpWPNQIDq7nhHB7qDEME0i2df1zgeDVgTJHzUuwohFv9agJCeAYXOfV0vP55Dlgn1UcPE60gUXqow4c3CU1kxhQaLbrCKg2WaaLgTPfhBNyMrf1Wm+6capnbFm3mgdkYdNSMB37FCSWN98SlznVUgyfha75hAUdeB1Jdv1Ia/2vcdhZ5/vAGJP3vDM+CyPKxwdZ/fxXumVmctq8BccSFzgIF9gmOXDyP1wVRX2YCdDuM8xNq4/1QIygO6GnKcwJaZKOETJzvCISrp4W73RZWLljbup1EL/0xNsJggXW3qajoWr0dgUO1l1RDc0h5HJoYBwWBdc4zccH4WfjcFfUv/MKCPqPhpFop0s4N8uc5KF4CjeLOYSCVTX7YAO62sZ+tAe3UBfoX8kSIl11KcGiRJalZ1F1Xw9h+BMwz05iAtrdvZoNt0HAHxVG1GQzyOnWpWeDxfi9jxNlBxAf3Aqve0Sfo7oYIvgdV3erD75SxHszJEqpB8g6hnY8m+Upu7A0dZ4J8aZFaYiNLbxC0egHYG3kgR8R/hrvuDjt6vJ4WughXTcPDbjjLFy2cwaaE71H1+G/4PDY+tuJfG6yw/gfaaLWej85I/P8bdRi+O5UB6ceJkVr6bxI0Ef+gw53ODotbZKgqVI0X8wxqdo74NDmzi6dQ1ajqDzGRf0KdK/kXEB/3AItil4P+2T3goc3ISJ8wYraxKeVAjoB2PpQdGgjyMHd19qzjhHEAvc1JfpduZGGXoBhoPuGMBxgZC0vKv9dWd93kno95Nk5+UfUxE0
 DqJqBGkA
 xoyvNCDH4cg0x3QGRnDFHzfAruNgqiekp7fKbj4J6YqjePqURcLjhrpdOC1DGXeNMFrh8zsdQwswVaAo6rc0crr6/ZqotyAvy34Uh+Jclvm+orF7p5mNDkKCFNhOZvWDvuJWNLduTY9AY/zlgU0dj9q44ngjuPZigTOO0D89wW778vB+d7kZF7VvE5Hw5QTmYI0xdy4ei3quxbv/W616e3WHuicXP/kLgPj+PMdCn7z/gOsriibtWi2mLOIoGPPqXirKfIDOJdYK0apFJJSNl9CsYAAE6s/TXfs5fDC8tW4VYEqEH9ZwzsZFux9VOXCsjdCCagcywFgpaoBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xuewen Wang <wangxuewen@kylinos.cn>

This series fixes two independent bugs in slabinfo:

  1. Return signed comparison results for unequal numeric sort keys so
     that -i correctly reverses size, activity, loss and partial sorting.
  2. Keep the per-cache partial-object average instead of overwriting it
     with a percentage before printing the PartObjs row.

Validation:

The sorting and totals fixes were additionally verified on live kernels
(v5.10 and v6.6) with root access: "slabinfo -l -S -i" is unsorted before
the sorting fix and ascending after it, with descending output unchanged;
"slabinfo -B -T" reports the PartObjs Average as a percentage (8 and 67)
before the totals fix and as the correct per-cache average
(2362 = 262202/111 and 48867 = 10897410/223) after it. No kernel slab
settings were modified.

Xuewen Wang (2):
  tools/mm: slabinfo: fix inverted numeric sorting
  tools/mm: slabinfo: preserve the average partial object count

 tools/mm/slabinfo.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

-- 
2.25.1


