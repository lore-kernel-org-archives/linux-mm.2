Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1309C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19146B007B; Wed, 22 Jul 2026 09:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF06C6B0088; Wed, 22 Jul 2026 09:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C061F6B008C; Wed, 22 Jul 2026 09:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AE3A6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:06:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B03D40194
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:06:38 +0000 (UTC)
X-FDA: 85016436876.11.2E3125C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id E5A35A0015
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:06:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=e69MtbyR;
	spf=none (imf25.hostedemail.com: domain of BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784725594;
	b=q+qpK5s/xwLfzrdpEOIMAiQs4xNAGAiAbLEPeQ3sRa0Rz92hYcSd06UxEIVKM2s/7x73xo
	b1B5w9Xlr2b8thL4htIgkEHEIWU1e/J76HSCvgt9g2wy/SxAIafwmumcgwxUVuuj5gQ9Rz
	Jv2SxKUTjoVFzHGy7Ujnc/68xe/lzXk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=e69MtbyR;
	spf=none (imf25.hostedemail.com: domain of BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784725594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w9J71KcjBFQYW/1N38JVknjcGogLRlYxpuulQBMBO5o=;
	b=3wDfixrE4qyN3ubnFv/bKjuIhD+FAQRFViiTSdknPtW+3qHSYS7FwtC+MIV2QqQ+l2PYaD
	m8DzTLMniWJGi0Q/z208bZHvbORaVfTEqOCIjat6OSDMCd6YsIuzu14a2yYzkLjIgAn8Y1
	zOCJVgs0Pv/sIWW7RtemT8B4S2OYbYA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=w9J71KcjBFQYW/1N38JVknjcGogLRlYxpuulQBMBO5o=; b=e69MtbyRHRNH+rCKPI2zWDZbP3
	bBueOpsET7/VzIvU66KYLPQOsMQ3Cse/U28q7q/kVAPImaxFh03cAGdjitzODe7N7sfrpsw4DPllQ
	90SBBoLQHDS6loLD+AU2uVdAV77YXDXTuwW9pbWqHKohtfXRQl9VT3LideQjl8MNVpzJNltAseov6
	Sad1tqlOeUw82VPcsV8vyIzfGWI8JWwrV9Xs0VIKYBgCGn2wWTn2SRvtpV3faUhCD3qD0sul2wP/f
	BgGJLp5z8yYLEioQE5egPd4Ohrjha+MaCLuWbGXgQR5Erz8FARAQrL1hGpp626P7mxijcYsgE2UnF
	pAw6xRfw==;
Received: from [2001:4bb8:2d6:3a78:eb21:714c:af4c:ee7d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmWeU-0000000Bpnc-2qsA;
	Wed, 22 Jul 2026 13:06:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	ryncsn@gmail.com,
	trondmy@kernel.org,
	anna@kernel.org,
	sfrench@samba.org,
	linux-mm@kvack.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: swap_ops updates
Date: Wed, 22 Jul 2026 15:06:06 +0200
Message-ID: <20260722130615.3163560-1-hch@lst.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E5A35A0015
X-Stat-Signature: 8cegn54jchab6i7ofuthp9kg898cuow6
X-Rspam-User: 
X-HE-Tag: 1784725593-304010
X-HE-Meta: U2FsdGVkX18tq9XI5nIUPkCQWJBTdLiWtilFj+vbO/NfJFhdXsUE8azkGE9DPbC7zCEtBog58RoBDkXLh6azZiu0hhUFF91PbzUxHTaV6R1wOAI1eREnlCqbKoF+7gsa+KduFMouwn0hOPs4DLk1QQoyQmODZkidQ2X/IufU0Wvov+EW1zm9VZpuVdbcGAAjvxhXNMChw1octBJ18dpLG1o3eVxY93CNUFy1XcBACQSfaysN2/M5fj5XI2ECxG+zvOIAprOWpzJRDwKll1wYS+rcbgw5JTNxZlfELpI3arnxBnlxI1Uknd1CfQD6iBfnbtDaMj2KqNCoRKplob9POAeSBqikPIitGQqOD3+fQzulyLr7SPhMIK4XPbAB4fwcEKU0LAZjZcWx83R6iDKqmWxivTwnuYIWhBg0IfLaneeTkTsx99J8MQhJhe/os3GyZEJCc5K/nO0i5K5wz/MN0Kqpfv+LLlxIfgERMrcnwOoMxkPUd6wd0Vo++ugKEe+2jABnce2NdviUulyhJRIeYdfC5n+wR+FS3NVOargYqhZ3jCVf1HC2W/7RDzhkZ/erJ/r7a3LWT0AG1DEu4O3BdLzkN1alxtr8ocEnOh2pthIxBO1sHyICSkvuqLb8e7n5gBHkcV8pOXRi66KWkzUR9DoRhg8Q2PD+AQFqh7/GQiAAhY0A7u7rawokny11po4wsEyZH+6rIY7AnWWnn9Hv/kdP+fE7SXODsquJw9vIPJdQWXq9UEIU0/Tq3PtHe1viJRKcEYjvzKOr91afyjq8by6UlSvodNOGFnJ0kFWACWtZ/053PTJr1DT9TgYAzd8ZCyPzuaGho81XZmFw887iPhN0fe31GH1VCxPaU3a2wrQhGANEi2VtQu6UbPNxzF8FVx/DWzP5JXJYr/I5vIgB7gmsk45VVU3ew5PpGgaKkfde5/TZs6vJXFJ+SJnUwrqIGD1OiXopt7v2jE44iqh
 TgguItdq
 hywr5XkA8p552Fhtcz4iv6jPoHeWQdl1mEXEw6C1YnCIIHmOIgcjERmH6+BI6S8hf1hdu0jbV0V6VJAxu/CI/VbJXPD2cNmh43lCaXty1ZFkPfDG13mVOFgkYAzR3pj/7wXzCE7eMQHtFxomn+9l2S6nXSyrpGnbhiAC6Syzw24XdJZc3E3ezH/+8rwvxrRT7Sv4PRonaLlmH8+nNo7/JOrvXw+A7s3rXjLnjsV9BGkqH2zSNAu+3TaBHEZrLPzcOMh1/iPFcDv0kgmK6w4PFrIgEy7n5TGWbNtNOCa4PhwFXaS4Aijqx/UWWEilhayUUbcefbf0crIBcAHgtPFfYR3E3dMCQxC2otvkaEywV+8eIt6lcBY/5bInUfj9pzA58hfSfD34bzGsbjsTNa/GxCS35WVbf32lmOIS03PCQ52A47Yl13sOH05s+5PtjNmsl3sPYj6LhPcOASQhMZK6G/TmvpI/SYWAdL04VtP954EudjDs2vb174pG9IDjFuFUTP0vZHf/FXp/p/9frivaJj10ZtTG+KphE2Ec+2HZ3fDTcD5TPA/p3chhYWvAUsbqHT5g9txG+EAqpwmT+bzalMONU6ePSeCcPa1oNd8aejl4XHov44mOp7yHBqDcciYWdHUSF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

this series is a follow on to the swap ops series now in mm-unstable.

The first patch reintroduces direct folio writes for synchronous
swap files, the other two remove the double indirect for file
system based swap.


