Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0791CC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C446B009E; Wed, 23 Jul 2025 06:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876D56B00A1; Wed, 23 Jul 2025 06:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8AA6B00A0; Wed, 23 Jul 2025 06:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 510C36B009F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:19:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6A4E1A064B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:19:43 +0000 (UTC)
X-FDA: 83695133046.11.9F92BF9
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf30.hostedemail.com (Postfix) with ESMTP id 77D4C8000B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:19:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JXdiRJ8J;
	spf=pass (imf30.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753265982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=K8kZ7QCjEfRrt0lfLWJjwn+cjK4ybC+tSjT9DjTb4Jw=;
	b=6/hDI06yf+alfAy+8QeFFMaI8ga294SmyHnTVR4vtJlHKjlY+mf738kW6YUcmhdiCkEyD4
	snQRq4tpC65FDcdrUt7cG/C2wW6CmDZgGYf9561Nn05EnmmiKT81aWs6RFYxVdizxbyUsM
	iYhPshmPWRDE6pojzbFRjL/4m2Gxog4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753265982; a=rsa-sha256;
	cv=none;
	b=0Qiuj/j/hDtMM5KMH3IYfD5sgVbP0DJtkdQayrRZuEbMF9/rI/a1ZgX6w5iR2A5tI/fh2P
	EFfVrRbqAJXe0/JuGY6JuIWbVJswwhBigAUh7SY0yBNdCnf8p4OAMdIJSgz9FsucNvMMt4
	TKB+q8o3tI7xZfX4+otY0o1v8IZ1V+o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=JXdiRJ8J;
	spf=pass (imf30.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=K8
	kZ7QCjEfRrt0lfLWJjwn+cjK4ybC+tSjT9DjTb4Jw=; b=JXdiRJ8JWKBv41Ounv
	39syKmBUX6JIRdgm5Mox3ZlJeIfkpQmIgQcN3YqgqRT45bAps3qAgbbEU78JAkk6
	TwgUMkWjLISl5B9+rurjghNypLgW8jLkI0O7ek3Uf6+1ieWdN7m0ofKQWSH/2SDc
	IZFFeepb/J2T8gVBAjy5XRMIQ=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDXpNEAt4BoaJF8HA--.11729S2;
	Wed, 23 Jul 2025 18:18:40 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: akpm@linux-foundation.org,
	willy@infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [RFC PATCH 0/3] Tiny optimization for large read operations
Date: Wed, 23 Jul 2025 18:18:22 +0800
Message-ID: <20250723101825.607184-1-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXpNEAt4BoaJF8HA--.11729S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww48AFyDKFy7ur13Cr1Dtrb_yoW8GryxpF
	W3KwnIkwnrtry7CFn0ywnxCrWfWrZ3AF45G398tF1fAwn8XF92gry0vF15Kry7Gr1Uur1I
	qr48Ary8G3ZYv37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j8HUDUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/1tbiFBWTnWiAtsIFNQAAsj
X-Rspamd-Queue-Id: 77D4C8000B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: u1atjtmrnncxhacisqai1oi98sr6qxxr
X-HE-Tag: 1753265981-909428
X-HE-Meta: U2FsdGVkX1/FxbnR805nDUiWok3PEaud+NVyfuRM8u7vQK6yp33hzQuTTyXoxLFFpRNzvbfGwQlE2BA0r/RBBzz7iuGW74R3iLNGiUBsxhjAXpbv1GNM9zSHcx/Oo2+dvfI2xGda4Me3K/PBYNeg6iWehIZxrs9u9qLiBKziZLBK/nU45x4WznNYtRIccgFY3djCbd5D/iBlEJJk4EUqgzyCravC3XcIxAxlD9wwMMbJpFTlHOLXjOextvcEkqTs2oN3oSFXzz3o45DWTWfIPuWtAzD1mdDlM2nkTjbeWDiS5Sl5yzuTRT1T6QcSQArP10EWsIgfKBYliPG1wbkx0sUSZM6bClrhYZtEJ/txmQJsMQJeoYcHm4+3jGgdg9eG7EPt3FjMgSzAxwaERqxNEhd+xm5qcvbwQ45Z8nNcgY4zxVY1v6M32DOJ1z7N3e53c0AUFgOa00m0lDNvCM558F6sP0Wc4yd6OeEI0obTyLytInszFSYgd0oVdMkVGninFNUIHuAGLcr7hhtED4I4TKltTPoglr3OaKv9mjwXIbnEkkFmgzeztdeU444iTZUWmH37zk2pLbTSVUyjwASXhCyX1uthmW0rNdwK3ldrRK4ByfZbfbwixiDLsr8TpzVHfaNLDE7UnGyRC8IpkhIcT0C0AlWcTOUh+ENsetIGFpz9uhiCTV24Si2Vg/JvmsPcAaMjLu1qbS96roM+8szDpAFNk20kADW0c6ryi1zTzTimr7uRPq/QUp1tZ38tgalqCcknZNCMHi+l2E9utvOAhEVf7/tn1TuuPAhxUhPkkbXglLfhlEiQeNTYijVs+UzKUA7L8xIHv/Aq/lqNGCUDo0jogyegztFWYUm/gdQVETAT21/TFPkyzRP4xf57ThpxfSIIy56H/4CeiI26pt23IYzRKuWL4PONTdb/+AW9/KLsKKPHyEyMYbnRWdOnJOHbWF5QVUw59ex5AqrBxwS
 iQe1qb1C
 5YyYplIyfghvCksDgmWVhKvFdORoKk9jeTBeA4RUkmyEZSKyn6/4KONmBSMxRvK4BkfRw+U/9z20HbWmQWXAmva2bUnf4Qo5Hb26T30e2oHTYzjqRLLraJummxz36OOH6YUyUKYP27Giu5e0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000030, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

Fine-Tuned Optimization for Large IO Read Operations

When reading data exceeding the maximum IO size, the operation is split into multiple IO requests, but the data isn't immediately copied to user space after IO completion. 
For example, when reading 2560k data from a device with 1280k maximum IO size, the following sequence occurs:

1. read 1280k
2. copy 31 pages to user buffer
3. copy 10 pages and issue read ahead for next 1280k
4. copy 31 pages to user buffer
5. wait the next 1280k
6. copy 8 pages to user buffer
7. copy 20 folios(64k) to user buffer

The 8 pages in step 6 are copied after the second 1280k completes due to waiting for non-uptodate folio in filemap_update_page.
After applying the patch, these 8 pages will be copied before the next IO completes:

1. read 1280k
2. copy 31 pages to user buffer
3. copy 10 pages and issue read ahead for next 1280k
4. copy 31 pages to user buffer
5. copy 8 pages to user buffer
6. wait the next 1280k
7. copy 20 folios(64k) to user buffer

Chi Zhiling (3):
  mm/filemap: Do not use is_partially_uptodate for entire folio
  mm/filemap: Avoid modifying iocb->ki_flags for AIO in
    filemap_get_pages()
  mm/filemap: Skip non-uptodate folio when folios are available

 mm/filemap.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

-- 
2.43.0


