Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C1A4EB595D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 03:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89EF26B0089; Tue, 10 Feb 2026 22:29:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FD616B008C; Tue, 10 Feb 2026 22:29:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B63F6B0089; Tue, 10 Feb 2026 22:29:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55B106B0089
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 22:29:59 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1569E1A01E8
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:29:59 +0000 (UTC)
X-FDA: 84430746918.17.847209B
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD7722000C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:29:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=cvzJ3MJ+;
	spf=pass (imf13.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770780597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DlxKDEX9Ctkf0ydS0qNB4rwbKcVtPfAX274yJ3VsAXk=;
	b=DkjhXb/O88UG/V6qheTqoku/6MteJ+jbVKtBZpREIa6Vz262/ZgLNf7Br+XtQpLi9/Uecu
	7mohqcf/Xy9C/DxSTGvbWhTisd/BkT8yn3M1MlQ1dxb6xcd9/GFLOwdm5Sy8RBSrC7Gr2J
	G4ckPIYZkGG7iPTmoSTgxxRuu41mhjQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=cvzJ3MJ+;
	spf=pass (imf13.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770780597; a=rsa-sha256;
	cv=none;
	b=vSQ9W8YdEIT4r0Jn9hUicF9KQChw6NPys6AqXSE8TFJGxtO4IyrV/QoQgF41waaEW32SoC
	Ah9dz0frPNbS6Oog6Jeo52lN8rMoQkbtohdnT7FoSY388G5zyUl6ilhoS4nhA6s1vfdq1P
	y7NRrwAtcZRitwV4kBT8+5gNQrVnPVQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Dl
	xKDEX9Ctkf0ydS0qNB4rwbKcVtPfAX274yJ3VsAXk=; b=cvzJ3MJ+YOEPmUlHfA
	KOHspA5h8LCAicPdcvUEdYV18aaeGrO3E19tTcpfRbhyz+0FpPt/Q88gXXsitx+m
	iShjgzO1T5xxdtdVWCoRG1dHMeoS0PSNUT51VDxIUJoHIXn1kin+mswPDpDhd/7N
	wnPJMtuu9EA75lXxErsC3AsiA=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgC3f96j94tpMZp0RA--.2981S2;
	Wed, 11 Feb 2026 11:29:40 +0800 (CST)
From: ranxiaokai627@163.com
To: graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	akpm@linux-foundation.org
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v2 0/2] two fixes in kho_populate()
Date: Wed, 11 Feb 2026 03:29:35 +0000
Message-ID: <20260211032937.208353-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgC3f96j94tpMZp0RA--.2981S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4Rf9N-UUUUU
X-Originating-IP: [117.176.243.201]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxgRksGmL96TACQAA3u
X-Stat-Signature: aqt4cgutwm1rh6o5aaxbnqjeaxiyc335
X-Rspamd-Queue-Id: AD7722000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770780596-738800
X-HE-Meta: U2FsdGVkX192YEP5sUIqDt1Lir8PEsuRlAUTPHyeZXmtAqkvDkSS+fAlDQMjhua10hvkPG+3HNbNXJen/f/vXyKAuGEuai2HmXDZ/P7DZKy1uFE+wPisK6uPq1ixnx5Y6b6ypNk93inMR1g8LsOy1WAPTa9ySEkEGa4pyrOU5OZzoMEMxfTcwI2zXFjf5TxoV36FjxREPtIYA1jQfSvmEUqYEMvO1nR0jPjlyLaNVV7DLCe4c+8zEsUj2JwCNPF4W6qQMrG0nfRcKGeR2o69s5N3/BGlUNJcHAXAOwEVZXGJOrFJCR10O9hH1hnk09l32VLEXWa9ypaCbR3xvpBq3dx3oSqmqlG57tTE1mJYkJfmo58AfZUbEIY90XWK4TtITxf9PQft5hPTRCDGfkriJQq2eWKcDHuqkPmps+mCQhawtgWPZiskmGgHy4e4Bv0oIZIHhG2XoX4wblrUJJuRpqKeU5RGqWndJYGVfKnVCJDgfaBT5Va4ucEvRhXKHktoKS7TVcaxVIeclf7OaMSRjfVaob0C+KpG9xyBZWMCST5qoWfZbo3Zj4NWhE1z0MaaXQylATvA/VGykF8Bi0Kt1Zn4toTZWvnABU42YqZaYY073hzD9KdK5To+vS1tRf6WZ/OFauvR12TKB27xDu6L5RCMdHv/f5r/tiSNxBDregX15jj/kWyJTGQUMxgtr0uyju2m5kBvpF1fULDSTuLk1xthV3HpRw9F90QE64Spj1heAlou/b8r7hfguyAxsuyWmyByYQVgvelDoTHPSpqBlMx9cD4mFe335AoKf4LR9f3G7NF+OOEq/Da6g0kvrja3JtlFqgWbKvHllERpejHkknR4U+ENg0R+BQW8lnnGWBxrlIyQn6++ymFBguceXyJjeoa7dJaUwahTRcKqUGI/Bvb+q3TAXT12dOS7NVkhOIvu4rXFeO1f9JoPhWcSPhURJkaTd8eYhU65WTmMsAU
 884MMfVC
 SDcyRkPDDKMsY6G0tGM3SvbrgWgNo+K+UYrOZhaUz6CTqaeoRlGFg+qrJaJGU10y28KdTVqdMweXtniYFF1XDRX56ThQllKfp4VxqKOVeyQvkanBm4WOXZS7YZTn6myH5K3IHgB2t0p+L7hcY3LB7uy2zaCW8rrgdUnIGnTGfYzWNWQ4cbqHMtITeCcClGPp5c3uoUoNsTirh8WJWiweormGZ7Uei9F5glSlt9DvCX3U95wD0YkB2bhnrmclXpRBOGXR5ifyXFFlp5g8n4mYySz+7annyqUZl+eP/1r2gomMd24CA3ivT09UeuFKnzo8R8ouPjsdZ9Q8qqN85brWuCLESyEWiZHE02Zbr9Mn2NJBcVenHUDml0vF1IHWEnBaG81NzXE+ifYnfZ5SnE0EXZnPkz88a7L4HzKdQHKSUJjUXpCIiMUBDCvunANwbj1jPXU8+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000013, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Patch1 fixes unpaired call of early_memmap()/early_memunmap()
Patch2 cleans up unnecessary call of WARN_ON()

v2
 - Improve code readability suggested by Pratyush
 - collect reviewed-by

Ran Xiaokai (2):
  kho: fix missing early_memunmap() call in kho_populate()
  kho: remove unnecessary WARN_ON(err) in kho_populate()

 kernel/liveupdate/kexec_handover.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

-- 
2.25.1



