Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E978ECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 07:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2F86B02AA; Mon,  1 Jun 2026 03:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CAEE6B02AB; Mon,  1 Jun 2026 03:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207936B02AC; Mon,  1 Jun 2026 03:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12A436B02AA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:49:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2B62161A85
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:49:14 +0000 (UTC)
X-FDA: 84830568228.15.87E6DA2
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by imf05.hostedemail.com (Postfix) with ESMTP id DB8F8100009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:49:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=iJWubnZu;
	spf=pass (imf05.hostedemail.com: domain of niecheng1@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780300152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ea62rNturdRY4XhPqvTtukJW98iV/DZwMOLJ/F5D8vs=;
	b=BjyPsu6r5VaX7dtqgszv13DPE6aynGK6xLKRSK1Y5zmAvCoOlKbqK9cxqw56mftzsBjlrp
	yH3emosOYp16hEpWADcRF7nMTOhMwm4AnReUQOp8IBsygIYWGjTBQjBfS7KbxkYjBZNw3l
	UKFosjoGCVlgTA6lDvOFLSPzoJcchU0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=iJWubnZu;
	spf=pass (imf05.hostedemail.com: domain of niecheng1@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=niecheng1@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780300152; a=rsa-sha256;
	cv=none;
	b=0h5P7xU7hgkZDL0neVxgnCUmhZgdDU0Vj6QpEUbtVwNrxWg9O+BG3C62chwHyvnaF+jgoE
	1bsy30FuruItXmAkZ8pZeUCtGEaHXZa9E0mNp9Mm0QENmSv86O4bQ7xSm+E31wdqpGdAM2
	92z1xA7hzckN45Rr42XO4Br/QpMnaB8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1780300139;
	bh=ea62rNturdRY4XhPqvTtukJW98iV/DZwMOLJ/F5D8vs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=iJWubnZun/6JXwWwyKBES70kPEdA2PDRD+Gpj9FJDKg45hNtZXNimTAdIcoPupW7x
	 Jl6CSkS1AlKd4qKs3sWJaOxAtibmuQQOmoTOmpy32nMKTQEWdiHExehV8C7Gr2LcVJ
	 QJofNlsZfGvPJxGvcMgFGXYyVskrYZGy/iJWKYBA=
X-QQ-mid: esmtpgz12t1780300133t483c7627
X-QQ-Originating-IP: AuBRQDf+rRPjo7dNJJXoqZJl3lWoOPaEZfnf7IeH34E=
Received: from PEN1097 ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 01 Jun 2026 15:48:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15829220135844779042
EX-QQ-RecipientCnt: 7
From: Cheng Nie <niecheng1@uniontech.com>
To: niecheng1@uniontech.com
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	shuah@kernel.org,
	sj@kernel.org
Subject: [PATCH v3 1/2] selftests/damon/_damon_sysfs.py: fix memcg_path assignment
Date: Mon,  1 Jun 2026 15:48:39 +0800
Message-ID: <13D41964888D2DAC+20260601074839.208530-1-niecheng1@uniontech.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <D4787203018006D6+20260601073635.200015-1-niecheng1@uniontech.com>
References: <D4787203018006D6+20260601073635.200015-1-niecheng1@uniontech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: N+Pc87eOxrZlcuhRfieXgWE8Lf/Xf4ufFbYsZEzZIQ9CD4fKJVhLS2Bc
	BHU6ZQO3e33IFmdOFL9EOu9r06AF66/HfDFRoO7XqD716eOP9uOWU4PYVYrzpbyBZtQe+5A
	IEMfPTs2b3ojERoS+PwWTh/bIbbPn6+5z6FgJnQlbQ37ArTuvpT0wAgr2ZlZzetVeYKPAKs
	TjPhy0Fm/1JkOOmDfOvYf3BUzp5qv1auucyqnRtVBqE4NomrX9nVSNq4h9woIBBgCbNycTD
	HfS3rdoBAczzRRcwNlkRnDEruvDiQjq8BvTGjWVXi1gC3T396EEX0f/PG9DbBIAd9/UiHzc
	6qikehy/UUua4hXqDe4z8QgknOWyuaxzRKjq2Nm97C3wLld2QvUYhMvERm/ozQfGy26/BBv
	m+zgK0RLQ+uyR9QcPLTcorH6b2m17gSIcOxJ1pWMxXoS5/5cbMcFm9Qpd34yfj0x9mpFnKR
	+Jqml2KdKXsonywl+ZMDqKCDmO1r781t1DIegrchdPErxucIoCTn6SgyhqeV9bDqwMO8J99
	sTCUfWbJCb8BEHRJTmsUlTR8lbrp3vkOaBWwpQOfk8Yl/NaxLvODlS0/ynWnLxEiFTsUzb6
	XbPlT4WpHwPSiDZEhbNvgtHZennKMv8E5lkMPbkFOKUegt4L01oghlrIxKk9CFwO9BPlhw0
	vDmsXvdz26aOt0Ixa3wznszD/+shCvQYSMae2nztTlSMb4XVbQBlZ6/LyyY7r99C2vXe+7o
	BJh7QriLr9gDBPl/0tOgcWV1JUBqJ3HDTH3fR7OazMkSzBzp6EplwqgzCsz4xpN/tHnFBIV
	nMds/rHB3814o79t7/vbFMS5A5iDklHeQnXS1BbzApF2PwRT3xJAeRlgGOb39+8Tmwo+Mxb
	SrRfJEOza0DWZJIUZlq96QD2LyjEVqaEOr1r72xqnl7EUJyXxYbS7zYxDFknmg9EHNVr8Cr
	wF343etjbXwmY9wuApir/+onS/i/gjN0/d0ZSQamEMywTpH2xEgG4VP9BCZ+Ad2pzcBmGJz
	vyNzeCLrheQ3GvUBtL6GIZpvKXif0A16ndVWGaaLqYq79pnXYwXWsmKQEjsl7vS3vYUuhtj
	YZEdeSPgb+LjLlX6YJBzU/LBoHNqcl2bLPLWhSQuArTvrsicR+vlqoVJsvHdIv3IdSq6eek
	TaDC/2MelKeSP0PMmHGCQnDtF8Whitd/8S/8
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: 8ge7suu1fxmno9hfnxrjq6giassibf85
X-Rspamd-Queue-Id: DB8F8100009
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780300150-411787
X-HE-Meta: U2FsdGVkX19dta+oF0lFs3aMprRIbKsgaWBCfom4s3QEehAQKbXBKb9hkiDROFLS57K5Dxc4ASjpSZ+kB+wpUo4L6NxH7ZdQ/VpnBtD0jedtlig/b18gK5CAk+m7pnPlWwuAT5Mq3DsbKds+nMdIo1c5+iGsehdmHM5chxTGLKUpo+G51wXG8TLW5JVEp6Rlz9aCQLe1VdiKDsF2lstkh6yLDXyfx/p6yV9y32ReexMWvBrtPY1MJZe2KU/r+mfAjpz7I7TzVesDtgHlD7bCGwGwdtOhlJeNATlQ/Ie7lhhQAGbpmnzHPU2uhaLSIZzGE3aul/pEC6t1i37hNufG7j2kgz47o+AHXst3QK4Xaj8DgKEiqqIbx5lrnrVIwcny2qL74do6X/PeT8W75qLte9OMrq80mSgUm5wxtxcrNEJR3R6OqY/PECxiYAU/3Icn5j1VnMhEFDhBDriCQc+fu81Aaq++ePedUceSZMVUi0VQ+t0OUdH0j8mm7Etp3uKoGm07IynJyPuku1w6B8RqueMdpM4c3Ueash4TrzBzzGwxSo4+s7+BbDaetdSKpmTR9U6PW/CnXoTJnn0EhVFg5VGRVwp0bplHOVfbWKexTFu1cqsUIKZeI/jS1nbEIZ2AImqOTN+szItP5eLzUw30CyG8VVA50qD/jWYbb6HADuIkbd1TCM8xq4SoFCQzLW9EzEdwOXnEDjU6j8LOSdg+rOZhq6gfrtNWeBfifarbH0atj01SOJHb277AnTKO3njlf8Bl7664OERAS1WnBuwBr7NsvZaADfiZ8EUdqzAYfuy9C1h48cKKBV6q6YImPFsgo2zFMX2wu/bH8Mml1jybVv0w+2nzOsz9r84SuAuKI6XxO51yfaNPBYOPiCIGiIi2pBFF7EgvFaBC1EGsMVuKArsgzolij6u3bPg67PLuetlhwP3tTEfE9h5LjtRI0RwMHy3yHjVVgT3OcKEhZe/
 OWzWdRK8
 yebLGaMWNKMSHAczQBc0ekqZtLvpllh5rAFWeO06Sc81i4appHD5y6I5JHMsMU7KLNlDvcddr+m+XDPiwqAn3gHpVOQk6njIM/yark7itI2kT8v/4sQ2rpRLv6HelNjHlqCCKLrzONfDJfYtZJr/n/trWB9IYWpLaejwE1sFFFMCHDpjTrEw3xT1afE2+J5AIARjO5SaWs5zGU8lEvs4gStB5dliYWbGMUV/4MPbaH84fBrc8pcj7zkjxhPijjbMOx8v26NDqsmqZrSYoP+W5PYRAl9g0cyfsmE8NG3ZeKBbEe9NZc/jBNkTws6cUc8jepMjFzeMIYJw8zphG74pSAN4Dkb5RXlSAD84y6ySYNjravTjbr3h+0ePdCe6u0CnQlspHZ2qw3cvp+Vr0mErMOw9FmMeHT+KcAdGx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DamosFilter stores memcg_path for sysfs staging, but the constructor
assigns it with a trailing comma and therefore turns it into a tuple.

Fix the assignment so memcg_path is stored as the intended string.
This makes memcg filter staging and follow-up validation use the
written path correctly.

Signed-off-by: Cheng Nie <niecheng1@uniontech.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 8b12cc048440..43075892215e 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -271,7 +271,7 @@ class DamosFilter:
         self.type_ = type_
         self.matching = matching
         self.allow = allow
-        self.memcg_path = memcg_path,
+        self.memcg_path = memcg_path
         self.addr_start = addr_start
         self.addr_end = addr_end
         self.target_idx = target_idx
-- 
2.51.0


