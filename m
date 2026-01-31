Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1414BD49C9E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 17:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5E406B0005; Sat, 31 Jan 2026 12:29:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1CC6B0088; Sat, 31 Jan 2026 12:29:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EDB06B008A; Sat, 31 Jan 2026 12:29:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A67C6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 12:29:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E57471A037E
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 17:29:03 +0000 (UTC)
X-FDA: 84392944566.02.CA5F7DE
Received: from cvsmtppost105.wmail.worksmobile.com (cvsmtppost105.wmail.worksmobile.com [125.209.209.75])
	by imf05.hostedemail.com (Postfix) with ESMTP id B4172100009
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 17:29:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=worksmobile.com header.s=s20171120 header.b=t99Ppe5M;
	dkim=pass header.d=korea.ac.kr header.s=naverworks header.b=JIEzisgH;
	spf=pass (imf05.hostedemail.com: domain of ingyujang25@korea.ac.kr designates 125.209.209.75 as permitted sender) smtp.mailfrom=ingyujang25@korea.ac.kr;
	dmarc=pass (policy=none) header.from=korea.ac.kr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769880542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YG4ly5XkBm7xH0RH1Wx27oM70Xf9pgUF0+jNK/Xq1W4=;
	b=NA9XUD+vqLKALLJryNwlFicVW0oYY4DjqmLJIH/kQLLxnbSL1h/1iQdCxNE0pwodJdNYM6
	fUFb7W+yxdQO4OW+624kC6dpTWBhgVuT0dVR79WU5ejy+mHer7gP3gqxv3WDCHSrC3SFaP
	X8k/ju/4v7dh3LS0SwyPlHQgkzsAnX0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769880542; a=rsa-sha256;
	cv=none;
	b=e19+3FZ8QoD6qzTbbDJ7yujkNCQBrCNh+A/GyOVsLtW9zkV+kR6cAnqagrweGvyLo/UAae
	bUPzf0t0QH4c8LE7pLW8UBOYq2AXrsvW/LvJsudMou+rStyyeCZxbGyGQGKVAPyQO8QHUv
	bsMcAuxi5HyTS5A5u0xgZbkZZjfNiWg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=worksmobile.com header.s=s20171120 header.b=t99Ppe5M;
	dkim=pass header.d=korea.ac.kr header.s=naverworks header.b=JIEzisgH;
	spf=pass (imf05.hostedemail.com: domain of ingyujang25@korea.ac.kr designates 125.209.209.75 as permitted sender) smtp.mailfrom=ingyujang25@korea.ac.kr;
	dmarc=pass (policy=none) header.from=korea.ac.kr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=worksmobile.com;
	s=s20171120; t=1769880536;
	bh=xLdOzvJThZW5sBs7HVwMvfK8GTU5iAi2zlBS65q5Jrg=;
	h=From:To:Subject:Date:Message-Id:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=t99Ppe5Mvj8Sdqs/7W79q3UMcRMhlMrZlidlHFUMWJYxa+hEs0e1DmBHoIdxOQ2Tn
	 biCgYBpKbvfIvtvaJRBN/sen5CabeAeXz2e9N/yr3/ffNAxlg+qEaNHnJ1102WxeWn
	 yoE8a9ju4fcDbuShN4/DvBwSwKFe/f0ruOIvyjsjSv6uaMjkz/y+Ko35qqZllbVKjC
	 +2JpTsr6AOqYa3B8D0gcozKuEVuXiow/Wuxby0w6xQaOPV7VDF9aZxo0/F1GDgLOmx
	 BmDiEOs2o6lSnP8lyxp01dU6PzWe5TT3UBuuKvU60IbR7ZoxAbGWjykjlIm4S1DDuy
	 AmFynLp4cbTBg==
X-Originating-IP: 163.152.163.130
Received: from cvsendbo004.wmail ([10.113.20.173])
  by cvsmtppost105.wmail.worksmobile.com with ESMTP id DocsLqBlTVOoLPlysr7fZg
  for <linux-mm@kvack.org>;
  Sat, 31 Jan 2026 17:28:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=korea.ac.kr;
	s=naverworks; t=1769880536;
	bh=xLdOzvJThZW5sBs7HVwMvfK8GTU5iAi2zlBS65q5Jrg=;
	h=From:To:Subject:Date:Message-Id:From:Subject:Feedback-ID:
	 X-Works-Security;
	b=JIEzisgHXU72ifYP4yf5mJWAkn4OdPaF3kd+vF6N8926ff2wc+moHS4ytFQwFWtdd
	 IvF3VJ7tatDF4fsKdud9d8Rsx3rgDwIqbfDMMm5qdpRRD4HAXoZHl7tjQ+kssjYZml
	 spccO314otHOzgrOLssP6+7YInPb0GdnoyqNAdGE=
X-Session-ID: GogdYXx2SUC-hottws6UZg
X-Originating-IP: 163.152.163.130
X-Works-Send-Opt: EenqjAJYjHm/FqM9FqJYFxMqFNwYjAg=
X-Works-Smtp-Source: AqndaAvrFqJZ+HmrKqu/+6E=
Received: from s2lab05.. ([163.152.163.130])
  by jvnsmtp401.gwmail.worksmobile.com with ESMTP id GogdYXx2SUC-hottws6UZg
  for <multiple recipients>
  (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
  Sat, 31 Jan 2026 17:28:56 -0000
From: Ingyu Jang <ingyujang25@korea.ac.kr>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	Ingyu Jang <ingyujang25@korea.ac.kr>
Subject: [Question] Dead code in copy_pud_range() for copy_huge_pud() error check?
Date: Sun,  1 Feb 2026 02:28:54 +0900
Message-Id: <20260131172854.3370590-1-ingyujang25@korea.ac.kr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B4172100009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4qcsnw4qxrd1booiaxfnbbiwyxsumrqk
X-HE-Tag: 1769880540-520224
X-HE-Meta: U2FsdGVkX19HLv2gL30yr+iKZSKPLTPlBQIZ8+jXACMcUva2y8xe7tePVJDTT9tLss5KMFGkUXfC8qRBmyOCOTDxf9cqpt24oYC5vdvilTT09g9fyqVBezbUQ/ot85INS7ZBgMAYTTA1l/XnNxVgsTYcbfRmzBXZi+JGW2QmREhjjOV2kzYI7GEOLbZqtwfkv159IoeGPRo9ScB/fIaEc2LECgGdsWEJYrpxMYGjdFgUh/N/573M1I/GA3FELK6hGw7cs+mcJVqi+MmYne0gux/PgHPhqq16E/i7IOytw+i+rus3fpvFWQsxhywPwDjG8wEGOUH66hsTrsaT1VpZpZFgg3aQKvkLMxY2ueKaQ5y+gmx1dn3ThDQ48wk/vrhEN6yI/PHGCGgNnKyW3KQlSZfl0TT7vBSNLkQMmCBjw0HBF3gCsYii9xNQo8Ob9Xwk8z5HDIWP3oBgJl2gzU3Q1+8FQ2yi4YoqLuk+Nbm8r/mPFbtrjbTphWqwmRWAzkoG+dtGvDIGtCGUezBGujMAtHwS/611d3aHwwRB/UlXOG9I9gtnYfky6zw+eWFcjyVGGLgzEqu38Igq5XUkk5C/Ljp4OaAAPC50uEg8hhwv1Z6Dp84cJklvXswcawRpUCDMhB9f6YZfQR0nuznPWlbi8kdfiW92jvWO2uNoxCilzugkBcjv5BOsCmiR7hzojD9Pe7+55swgL/VTVJ4q87vFQhaUQf6wUY3KK1n5oyLYAsIavAF3eY98IsFgOfDj8yKc8pEeXKzS848mVJhN76LKREEZ1w1rcBq+fiX0YwaBBuxIvLkIpWWEGwkBRr+R+DtkK+4XhhoeiNjuvsP6nd21m+r49FcGaMoO60qOvY1FIErR7iSY6xzeJ0PXl5W9Kj0Se6Tj2wKl/AjjzCpV0sBbzjAp3fZ0o3fCDm0w/7tRVf+t6MRcgfH6PxtxMqjiSZPhMz6KUlQRRNc57YspEZ/
 Hyg4+rdr
 9rBDqJWoWHUcE0UurFbc6ygXLCbAiUuJkdVXtHxTzqoO6CLKIm00D+ofn//p9C9IQ7l4Ean5jZk4pnLnKRNWp9aZ0fUlGkzOmb9BeqYRQvvAw4yq3fm3vTMxNk7eJXyxbALCGG+RGSZNSqRFYuHXuBvne6h8CE2UfUgrBA8nuxTFViQ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.245724, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I noticed that in mm/memory.c, the function copy_pud_range() checks
if copy_huge_pud() returns -ENOMEM (at line 1421):

    err = copy_huge_pud(dst_mm, src_mm,
                        dst_pud, src_pud, addr, src_vma);
    if (err == -ENOMEM)
        return -ENOMEM;

However, looking at copy_huge_pud() in mm/huge_memory.c (line 1966),
it only returns two values:
  - 0 on success (line 1994)
  - -EAGAIN when !pud_trans_huge(pud) (line 1978)

There is no code path that returns -ENOMEM, which means the check
"if (err == -ENOMEM)" at line 1421 is unreachable dead code.

Is this intentional defensive coding for potential future changes,
or could this unreachable error check be cleaned up?

Thanks,
Ingyu Jang

