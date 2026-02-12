Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A210EEB4903
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 11:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17EFF6B0089; Thu, 12 Feb 2026 06:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 129F26B008A; Thu, 12 Feb 2026 06:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02BAC6B008C; Thu, 12 Feb 2026 06:12:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6E926B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:12:17 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C9805AD94
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:12:17 +0000 (UTC)
X-FDA: 84435540714.10.ABCA2E4
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf04.hostedemail.com (Postfix) with ESMTP id 21DBA40008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:12:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mqpPnjef;
	spf=pass (imf04.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770894735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TZclJqzGvqfgYgzuUOZlJDMXe+pR9LdrFyA+dktDiAc=;
	b=cq/vN1Bk47nmDFU9u8fEte3lgIBV7iTPI10m+FEoGZOr+5si6OoXtNNmlwhbj6EdHHpN9Z
	1eYbajHMiiQ6JUnBOt0xHjzGOPnfzIQYErkBRVln1C9nE7vfCbCL86YuyCqN7q8noWhCVl
	YBFp8hXEpnneQdCIFbh6w1HPjWtRmrs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mqpPnjef;
	spf=pass (imf04.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770894735; a=rsa-sha256;
	cv=none;
	b=oQZDb8dnx6Kyl441rKp4jiUEcQwRI6DqE4h2EMZPd2sr8flzsfN+zLxHgBMqBB6jIUPTVN
	N2j+IsvcrO7QXrY0ZonhSuyghhQ3LfpaQstqvbgcxVT2Yze8zjWfUAUZV5zaYrN08aboia
	xNktE91W300PtkvJodufkAfVxDU5fr8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=TZ
	clJqzGvqfgYgzuUOZlJDMXe+pR9LdrFyA+dktDiAc=; b=mqpPnjefSRBRJvFvQO
	sNaSMHpziZbsP/fk1cSv7Jwxyoui8d9CYPKBwA7e+2b93epwJ6PZ5HW1s81bEzj6
	MSLf+WxsToyix5Zd7HeUws++hsvIvdZFBIaS2vxq4RuMtbcNNxQrqsXPdvZgvnxR
	2QdAcVcEC9I7SalWJy8MJwSA0=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCHZLl0tY1ptkijLg--.48890S2;
	Thu, 12 Feb 2026 19:11:50 +0800 (CST)
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
Subject: [PATCH v3 0/2] two fixes in kho_populate()
Date: Thu, 12 Feb 2026 11:11:44 +0000
Message-ID: <20260212111146.210086-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHZLl0tY1ptkijLg--.48890S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4R3KsbUUUUU
X-Originating-IP: [218.203.227.87]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxRZIlGmNtXaS0gAA3o
X-Rspamd-Server: rspam12
X-Stat-Signature: 9pxyo3jzx7q3nx6bqy5gqddgys41k8iw
X-Rspamd-Queue-Id: 21DBA40008
X-Rspam-User: 
X-HE-Tag: 1770894734-443169
X-HE-Meta: U2FsdGVkX1/RzeANDxPY/1VYyHtnvPcg9wfGB5e4Owi+KstCskDFM3sTMvmKvny4o4AoVKHZJSLWkWhxDHPW6ynO9DnG2uk2Ofn4W6SFRl+vO85dHuN8UhZMqtnhrAM7WaXAV3wvYUrDudg/4dtJS3OgBg1fM7tFeSbmuQ2TTE6Q85gaO9o2J8phGNAL19g32w8stVa8SWPzVhGGjhqAMhgpeIA3cQlyfE4qJLhhXoIMOcpohkVNdfymDfWTpaGqM8eRTjzBRsG2M5sinp3QBhz07r7qD/1yKj+gq/U1FHAHkQna1NKGvmqC8F2mxsA5v1vhGDjNKyNZtXD78CcJz1+BThAgRxoIfS2kxiy1miYr+vfRMXzySFdJ4REBOFVUv9Rlih5fUGsrGTDuoNda8Rhq2ylcLmEzE4wlm4qSuDQEnjoklkeBn7Ei18AshWu8YJhOCZl9Z4ifvYrZ4N0V3e5c6RmynYqAycz75M2rsNooUj9LYHWbabBApA34Pl57s9u/8y9Cs8fwRE1jtl+XkByZ7rQog/Zv9FKhYwGMajnZMjX+6c4CLMHGh/cxbZP9R0oxq8kbLylTKF2dLBaw++LwztxtzOi3T7BQAS3skudsKyDUK3KKtNFdMOUpvtM1uNTdqVidYhfo6EIPGcKwmkJAjGpf1oxg8IjQiUzDHKgzFEXX1aHcTqIQ1hn6a0qG4cvOU03k7emBgwI/VS3+lmu/mkg+8w4w5uPiKpjaK4nPqBgKXws/ZzRlpdOHCkPi4FOVeVaVKOjaBVeOEjytucankhq23DY62qLh8tS7rZL2rDSreUwAt60BVuRyBR0Ulhpyf/xL65ndhKhAKB/42L2gd0yR7nWwFUlxV4EWxFvrN4g4utxcBkSgBKLrHRFgRNqUMV0eqorhCAByUSVPnt4EtGhjdrmuVoecvS12UdkDYjXvWYDwV5/gjvaTRj+2bInc2GxHp7cb3tvZ8TJ
 VqbHvYKR
 IG/xsRNU2aWYv/CMNoM7faBHDehTOJbEszEgNTNZjhw/h9PFPxL/t9mEnKt45L7WMzYwYnhRNXj9Neuixh9jw4pjrMFVlELIfDIQEX9xkq5er+jiuN/F2d5VoD+uWqlOe3il3HAZ9+L18vupNS5PQlHX1Tq9HouaAAguHTArkyYECICudwMqVc8g8zDPlv2WrFUSN9uvXLf7pgJhmV/4BD9Of2qHPE9w/eU/PJbk3y7cJQCjzTj2URijGk5Yod7Azl0A56i4R7Do+DEcsj/2U2hFr93jrKyWOLw0lNdROvzzvLM2TunoQ+7VDTAC8ek3cIt1Me6HxqC344Pq2R5D0PMXVYqhnKrXki5n4zTYWrJSoVWzBk0PIS6Ox9CpcrFDcJNATgbEcU8MOVIU6IN3V+HaT6IbNYQP8l8jERXukDLXq0YEV7ULBtZwAZThfWT4EfqRF51GocXzrL9Dh6XT4R7KV2qKrZYoklgV+7ZlprslX5EIxUIRgRmJvXZwNlhgoqa921n+M+NhQUoAn5ROvLsE6+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000005, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Patch1 fixes unpaired call of early_memmap()/early_memunmap()
Patch2 cleans up unnecessary call of WARN_ON()

v3
 - rename all the labels suggested by Pratyush

v2
 - Improve code readability suggested by Pratyush
 - collect reviewed-by
 
Ran Xiaokai (2):
  kho: fix missing early_memunmap() call in kho_populate()
  kho: remove unnecessary WARN_ON(err) in kho_populate()

 kernel/liveupdate/kexec_handover.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

-- 
2.25.1



