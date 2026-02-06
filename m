Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AFEBE9129F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 04:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA266B0089; Thu,  5 Feb 2026 23:31:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97F96B0092; Thu,  5 Feb 2026 23:31:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3E66B0093; Thu,  5 Feb 2026 23:31:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B07A6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 23:31:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 22D3D1A06ED
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:31:40 +0000 (UTC)
X-FDA: 84412758360.21.E4EEE22
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf16.hostedemail.com (Postfix) with ESMTP id 87775180008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:31:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=emJrfbxG;
	spf=pass (imf16.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770352298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=p5g6IpqTgwpM4i/ryonxaLfvkbirbYDZGuESb01JV4s=;
	b=gXLAvpaQ0FhX1a6fqw1SZirSRXoWzJpiGaRZ9s1AoHcOgSrXDtsbZH2WjRiJk2NivvoChO
	NKAj7LnfEdAViPqZlnhAEjA/mOwRuNKY7K27k/SF5y3VfoAm2H1W0oScdTs1hgKyx5MoHH
	ghHB8MlN826N7ABapltMU+zKxOjcfIE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=emJrfbxG;
	spf=pass (imf16.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770352298; a=rsa-sha256;
	cv=none;
	b=XhrbYZykzJqGjlRp+bMdjAWhCp+tAkeqfssSokYCnS+SkuZdTkWZUfYmlM9Oqn9ZGBUxil
	HtMWKMII0zFBlslBx4E/JYXOG9AD5gc4ra2DYfRCEyNpn2WE7gg6HAClGWUhDnwh+edJdn
	PkJgdW6gHlawwbWdxhPfMeWeXrrUCwY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=p5
	g6IpqTgwpM4i/ryonxaLfvkbirbYDZGuESb01JV4s=; b=emJrfbxG1koGmgJPUZ
	o+srUSmbV47kHC0YLIkT1S4RPwS5fTS1qVLPGEU44q8wtCAa0ibiZ5BSwFvu6l3B
	OjuNQJN//qiUHlnSJ0wy8T9Y8TLcww7OZ5ufeD/u40gptVl77I/cHqfY7I3dWRxa
	vRGuYo3PWFQBg5blR+QTfmVw0=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgC3sLWbboVpASh5QQ--.27597S2;
	Fri, 06 Feb 2026 12:31:24 +0800 (CST)
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
Subject: [PATCH -next 0/2] two fixes in kho_populate()
Date: Fri,  6 Feb 2026 04:31:19 +0000
Message-ID: <20260206043121.197564-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgC3sLWbboVpASh5QQ--.27597S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RfpndDUUUU
X-Originating-IP: [117.176.242.230]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxhx+ymmFbpx-RAAA3L
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 87775180008
X-Stat-Signature: 8doz8z699sy3wyu7bzyy6b98e8q7zshn
X-Rspam-User: 
X-HE-Tag: 1770352297-644858
X-HE-Meta: U2FsdGVkX1+8sTF0t6N+ZUn0W30CcEurw+Z/uARcrhltifcuoYFefOO9RGJ4nhtq5OJ+EBd1hsYp2tYrI/TCtagKiqFj/WvWv/HeWKgj9fYyL+Lt3gUgFk2Qai3+f28lJFXRHB9PTrkMEkRwH+M8MfVgJbhGPQNXKAW28PaBgfxauNyyqEhJdtOHgjs1AGsHqG2uhoDlSYdvZdiHvd/34LnDdeU9qQnHoDozaB+XsED9ggJp+2dhzXCwcZU1yARz3HP5o5PKP/iBfAMUgIvvU/gTFn/vgELlhSnn67GxDMsCgs1dMg/098Jttgm2U6KJ89iS64DFcClzWexEIX0gYpspPTBdz26kpWAb1M0zUcTCHVzdU58vS224X7AGZNoKMJ7p9FsdX2GuQnkLyT3T6G5RhgNJWyPXljyYPnOnr8VlMRG3JZZTmqVIzefECokFSuH+VBXF8Tj8xate7nb30Yt8i+Fsju2eQ4j9NEUkN1wAX2/khVaF715h3wVlHE8+ilKn9QJFIsKBLyOKup53IPGq/91njEzLwdtGz8VWkk9hTtKJCrLatxANo/RXUxlJ6yR7HXj/R6m6gUQ9QMtRLG5I3itcbmeHKbJTFdgl1hbFrdacCu2yLagf6DpkJPja4ZOPQjYMq5fbNMmhJ0TO3OtzsyJCZhrozAeSqk9eBhcn9vAN0KnZduXJgBMhdty28GmPhHG6D7M8uY1U0k16zVvhvffupLpVjJwaZqzCOPK96vrxjOH/ii+y97SIXJHze5g7jEuS1lrT0za+LOxB8L+CfRrxnVpwP2POQXXGKY8rYwwCewDa30qPrOoYhv8zoXHrC43YVuc0Wiqp0vePm4wK8ulsJ2gG5g1hpZTVJnoW4lbCeLa4FKLcQ2N3R8+Rj74vEPx7/M0P3OFjgR+RwqWUho+DN4lD/WaclZV2Hosr50fnftZ9zW3bJ0uwdn1bU5A+vNQDjapnlTlccsC
 SoX+hx4L
 kPtLx+wKF2gWr3mZgSH3FWYcEF2i7GU8GLTI3IPJKYWuAo/dQ1lecOnrhBzEEIhAN2gRTBdbxggOER0saYmRcN2Z59P5B8Rpr+VZFDwy/GWcAevjMDTR42iwgLrZQFtoNvIyvucHGPGRI15rQIBiVu/8qxQLX0R64yxvOYGgXFiYgBirD8D0WKvwtFdPbVE5NyRvqvzX5KUMvmBbLfLtAESe19XGBQ5ORA7qe5PbF06TrsJaSxe0JSNSFVXEAMOsMyRCFhC51P43tSB2uFmm84Z8qgW2APMWVprkD8Z9OeIGjozCOFd+nXD6HTjeXSkTKMdeYWxN5X1wJ5Nz8C1THWO8DNkExU/FBeVEKCrFvH3k278uZIxZzOmzxZ6PyYO8bGJuOqhvQlfwOZyttqyVkpGCdGKtvT1AE87b1DnI3W4JwJpUNiC/+PRMVtxQh8iJVhIXc
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

Ran Xiaokai (2):
  kho: fix missing early_memunmap() call in kho_populate()
  kho: remove unnecessary WARN_ON(err) in kho_populate()

 kernel/liveupdate/kexec_handover.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

-- 
2.25.1



