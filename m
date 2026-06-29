Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0079AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 01:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A68B6B0005; Sun, 28 Jun 2026 21:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957EA6B0088; Sun, 28 Jun 2026 21:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 846DB6B008A; Sun, 28 Jun 2026 21:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF166B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:43:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAF6C14051E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:43:46 +0000 (UTC)
X-FDA: 84931253652.16.C532E2E
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by imf02.hostedemail.com (Postfix) with ESMTP id 68F4F80003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:43:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=cPDXtC5z;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf02.hostedemail.com: domain of chenyichong@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782697424;
	b=SX5GR1e4iWRYOxumiet6Ua8JCwP1A1yFeVn+PRn9fJQJz/EISLIiWDWfGnbMDuGdY0nQTs
	f8RutY3b4FTnsORusmnDrrSNYXNbMEHJPjNCxIEqa8N65gs0hB8xNfNkcavN3a8mfAdJf1
	I4b/5icQo5Ak8Kj83JBVwO1G6XuwVyc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782697424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Uc1Ld065hr1gRHTkui+Guns6DTSEmDDj1S30yTITQzM=;
	b=u6EgEd22C2Rny7WRwte4kNPOWhxQQieGK/XXBnrAgk2KbMVLiINwyBM2q7S/Gs9HG64/+y
	cTZsX2iQi964ptnvI8i+s+Xf+Xzw0p66//lmB7BYespQ9OSM/AxVyrW8qMkJhjmzK8/OhR
	bCPj2xy0r74be7c+qtDJ76PHomrn7VM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=cPDXtC5z;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf02.hostedemail.com: domain of chenyichong@uniontech.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1782697407;
	bh=Uc1Ld065hr1gRHTkui+Guns6DTSEmDDj1S30yTITQzM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=cPDXtC5zcw2PHo1qkk0RqdpZVm6/iFIkCJoWmmoBVgHkmrk+ET7+b1tFXm7OdA6py
	 Tmw6ylJnABtnQZ3tLW3AIkqazJPgiTSJx3IqbPeuQ0OO960Gg9EqPy71RIZFZURqmC
	 psHD/v/Bd/DHFh29NeA+hh104eGeBMVG28r3/wDM=
X-QQ-mid: zesmtpsz7t1782697402t391bf88b
X-QQ-Originating-IP: hxYqzIMZWgQ7Q3tSJr+siWYgsBO9R7FinesGjRAZvb8=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 29 Jun 2026 09:43:19 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12751322897713847131
EX-QQ-RecipientCnt: 7
From: Yichong Chen <chenyichong@uniontech.com>
To: akpm@linux-foundation.org
Cc: vishal.moola@gmail.com,
	ye.liu@linux.dev,
	zhen.ni@easystack.cn,
	chenyichong@uniontech.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/3] tools/mm/page_owner_sort: fix filtering and cleanup issues
Date: Mon, 29 Jun 2026 09:43:13 +0800
Message-Id: <20260629014316.130307-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MFW1oUNkf1TffUmHRn97ag5mNlU2Xj45OYa0AjbZ9mTkb/NJoAfKt+Bq
	sEYK4a+VufDgCpNuZ6v/lh7rbi1sLb16oCVkIqQ524lFAhX3S4In5nwiopULGj5TY3sGAoU
	XLunoqT2N8zS7Avz9c60NHFnaStCmQN1/9Uo+6XZgfUG9+AtoHc9XSZXmwpxlLxfF3vbjcP
	PNJNhONGADFutrTofMpUn1WQwWwjukeVwlsnFwgrj//xBq8nQ4+x9YuAWHr1Cc/yaYe0AUx
	KdBJ9id91fmsZbz8QLbYRrb9hj7CRkYDNxEvkyVrZU4puKFoNY5XxD/3JGrGxyTh/e/HBey
	D46sh2Bn5O/nsSEsopDXYUU+A7PHLZh3JPTnL16LKzcIN7ieEUCtKZrlKsioEIP9ViylknA
	xeknHKr+sx0qvu+lA0jkxzH1WdZ0ccOLcZL73kakAhKq6rPpQAyUdiLXwFitMP1nj5+9EJR
	lTzaVS0E0IMgSR8oOXkE718hX0ndePx7knOYure3eFLUWZzVtuI5TYPz/45j+tS99WS2blX
	9mhhr7Qv2d9UvB/8iFMmX72nmoTZ7QD0cdz2KtVm6G+bjPm0royc/gSEbeyX7H8qgw0sOC3
	XmVsr2bquhuyIE9IwpIJFAlIaB7W5W14GdGV08lU6bILrmfhDm0hr0MIKPIWpiuDujgKD0i
	kZxEgqnspbXGeaI3SAgSfkYM9Qpk7Lzh4aFAdnDLeDbFmHZGHlyDadYEAkhNHKKPbWXkpBo
	PUuncQg6scJvbbwWFLayeLYdlwh5/MMZST5fZ3yvvcWLmjh8hhayE0y+ZG5hAnm2zRGKu8n
	rwLf5snmapWTuvsqi6nu17mDds3c0DWbmNAm6NiO+F3YyfmptymBORDRoAE6tbt5sCECHxQ
	QGW5JkijQW1YHfPwPztncizMZS8r3LpCtOP132L0UvguePs43ZKhW/mp3+RYMkNq1t8ljVr
	Sz0Olm8RVlWbAEL3j53iXibemGod8pvec776y8u3jyjxv4oYrd+pIUm2TyHfxntU7Q2yprv
	UtTlLXrLi0QqJ09w5hygoaVjF/jgg=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68F4F80003
X-Stat-Signature: gzgpcd34xa7crptqsszexsw5zsi55txu
X-HE-Tag: 1782697422-614782
X-HE-Meta: U2FsdGVkX18H7JMDV0RwdZrpm/29TlYSO24S0wA4Ju1tGIDg0hwh6JK+0BVQYz9+EbhLHY2UHKs6YpZcNnKQaQj0Chj8YuNVNjUhlYrqH0Tqx0ehmrLEodjc9vTRRE0rfU1OGGGqqjBFS7DrikCfsVsW9iqyIkdUC4hjhWLTvtsP7SInaDrEyO5BP1enSdTdGw7DuTsZUp+SXPl0xSdjZP4IpMZ+m7XocewoGLUVcwpqvMNgA7mxaKGuQWu9pkbS9nB9mjaKxKDLTmna0R6fND6IAPcEAVhfylcf54WHcybo81qk2gFdV+s3MIK4KUyqYE6m7eBWNtwV/DEW6o1zgtiQl52jSNtci0ZVQCQxZ0Verl7Ayb6Aep4RyDpE/EKAtB8bnsfCGUra4i5oiPgDwp9iieybLGLNM44eihpnhZlMfi6O9a+C/JIbylS/ybRj+vbAOhcEkGMlyzz6RopV9g2QOBi2NjyamCr8Zqyaa2GNGrUreDE5ODUr9NdLky9mgXzu1o72spkkgpLHZ9x30C4+ZeMEE+PrTqUC2H2qoEgWEEhLW2sEzhK1TTPZ53XdjVCs1uw495j7tT/VW//UFuOghIdXHmR8Z1y2rGPZSxCXtfI/mtttvaBvwtkbrXCapxFqhjMpbJ8Sk75VjCMnn2ffaFKehoqhFKL+Oqmj7Gn9CF96l8O9tYQ45RRiaGQCiNSEVpk7e12LFBEUhysHGMZwPlGn2joetKSTBpJgvkuSppgLfBRdimJrMLEVTBYNCa4KkYh7OC1MtN6CXkxFvRnCDCrTN2K+6qIp+4mw8mC47Dd9YtsKviA8sCiF6o0Iw8V5KUrZepKsoGXYHI3/jBYqmUX3L8Sqcs4UVJZlQUAK6RU6JDvnKxu32WVZJoQ0MFbY9bRsnvefPY2QG0vLApWA1yHm1/zO2PAjVkXoCuHyaBXzJaNpEWIvI/A3SIFk8XWZWUYGX6nzJfmFZX0
 biVatX4M
 zQYyzHG4BaUtXU5YS0gbsAuhZZ7so5Zu4GLwQtr2TR8a4tuGjOPIvz3MVCx1VnidsZXPJAf/eIrzNQsWRrCJ4zTf1xnRPBfWmZhSLzltfDE5cWuo+GiB8wiQ+s9TcwG5nxDwkpDEVWFtRr8qIA9UaJC3gabpf2FiwszSmNzdlH/33BwNizQjX07jSmYT280aAiaR7B9y4+cBDNV/M9+1BAc9V26YjgC3FU01H1y1Jvvk+bp8P9Lrt4TjX/LbjWQsSPHjffcNOrHz96Hk70nUgQMalN9Uct8AZzHoAnWP20SoeNEEQPH7gjvfVwA/AGBq26oaRmFTDzjQkm13jkkulAe5yvluhHKQpnuqZOvKFYYJBHrzNv8NvqsRYmdy6OSeSD1MdMmu9U0/wtqDtRH1PXmWnCDn+m2X3QNse
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Resend the page_owner_sort cleanup series with corrected threading.

This version replaces the single patch currently queued in mm-new by
splitting the cleanup into smaller patches and adding the search_pattern()
bounds fix.

Patch 1 renames is_need() to filter_record() and makes the filter path
return explicit results. Patch 2 fixes the per-record allocation leaks.
Patch 3 bounds search_pattern() output copies, addressing the pre-existing
issue reported by Sashiko/AI review.

Changes in v5:
- Resend the series with corrected threading.
- Keep Ye Liu and Zhen Ni copied, as Andrew requested.
- Add patch 3 to bound search_pattern() output copies.

Changes in v4:
- Split the filter_record() cleanup into a separate patch.
- Mention the is_need() to filter_record() rename in the commit log.
- Add Reviewed-by from Vishal.

Changes in v3:
- Keep the free in add_list(), since incomplete records are not included
  in list_size and cannot be reached by the common cleanup path.
- Return explicit error, skip, and match results from filter_record() to
  handle a NULL return from get_comm().

Changes in v2:
- Wrap commit message lines to approximately 75 columns.
- Use "Yichong Chen" as the author name.

Yichong Chen (3):
  tools/mm/page_owner_sort: return explicit filter results
  tools/mm/page_owner_sort: free per-record allocations
  tools/mm/page_owner_sort: bound pattern output copies

 tools/mm/page_owner_sort.c | 86 ++++++++++++++++++++++++++++++--------
 1 file changed, 69 insertions(+), 17 deletions(-)

-- 
2.51.0


