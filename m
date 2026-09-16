Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA153C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16B66B0088; Wed, 16 Sep 2026 02:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC78F6B008C; Wed, 16 Sep 2026 02:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE166B0095; Wed, 16 Sep 2026 02:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E57F6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:58:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A66A4C064F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:58:37 +0000 (UTC)
X-FDA: 85218722274.13.D7B2BEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 32C4AC0006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:58:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVUMtqgc;
	spf=pass (imf28.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541916;
	b=4jByNltNiL588YUmzfMVVF/98UvUFIPmcTN4BU7kJNMh4PCprxY1MzLUpzKCEQGBwxjimC
	8sLF2AUUy8pHo59VmwAi3a8n/uRkV61PAjO5f6xIYzxP1t6aPqSLfPa5FZEQYTeCqhfmic
	9h26uZ8BkcYC4ql/s1GSv/C9X8RprT8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVUMtqgc;
	spf=pass (imf28.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Cp85D4AzAHwPfiXaKoj27DkJMB/iUIWmXYjVvJsP5+c=;
	b=EFSoV4enNucUnhUTDEVN7t3W4/cFYxkmXKqXj1LcoxoJk/65DzN+HrHdwqRTI21x+YDKcz
	sbPo15aUf7GmGeoei20wEj+jil3oTWZs3G22AtFTk1qUddS6szAZ8UhAgXXVdg116WA9h2
	sCEG3bpew8iM9+yGdXoxwGGdy5/4aYQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22A5140BDC;
	Wed, 16 Sep 2026 06:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA7B1F000FF;
	Wed, 16 Sep 2026 06:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789541915;
	bh=Cp85D4AzAHwPfiXaKoj27DkJMB/iUIWmXYjVvJsP5+c=;
	h=From:To:Cc:Subject:Date;
	b=RVUMtqgcx/GYIMfERvbfvHFUob5TOHN3L6i/cSv+a6l17eT4+mvpRZk6MsI5Iutjk
	 7DQeqF7qq0dlp6nICfz/70Z8ul0NpPQgPYF57qSXRbw78o8WCsHX/wxzlsZ1/3vFAd
	 Z7/2IV0Vx58ixi8WdmLnYBu23dS4C3SxDwmFbBBgxfjN833QXrfjaPLESIL233Ry8a
	 MqhKkif8p1YrHjwWNLfO6IBrYJ1LxDtYmiAJyyypdXh+a8hAHW9Eu/Jc6sz+SmI3Qq
	 R4HTrphCyzhvgiksUK8ZFhAI2O0i1T8LxnTJCVJgLTS8q/qptl9vjyXtswi2zAkTz1
	 HdEjmIZKBit0A==
From: Arnd Bergmann <arnd@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>,
	Abhishek Bapat <abhishekbapat@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Ge <hao.ge@linux.dev>
Cc: Arnd Bergmann <arnd@arndb.de>,
	SJ Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] alloc_tag: avoid implicit padding in uapi
Date: Wed, 16 Sep 2026 08:58:20 +0200
Message-ID: <20260916065830.1619425-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 32C4AC0006
X-Stat-Signature: ehhsg4dkjkwzw3t1zjo4e7k5kuqaer9h
X-HE-Tag: 1789541916-642934
X-HE-Meta: U2FsdGVkX1/c9ru4EiBT0zI4V/QT6I2SCpgom38WtmQ5z2lTOnTjqtogmQn1x1JHPQMCXOjuviZ2GWEG1N+Q2Z3WExNiMfYnEME33yB/FZMphtw2nLINS3mO8V7UonxVXSNY1YMkt0tACZ6Xu+zk3sdqJ16Mm3/0jkXYt1CJ2/mBzaGrxJoYCQqLrPwjK5UqqwW/kwihpawXLnohwj9sHvfQq5DXej+Z50Hd2TLKbd8VkJSlKnvuoAoeD8wIgvzQCKq6yClpT0SywzylPK2ZnMq08nlgdRJCJaPe1/cBw4QZRcDRRc4kzQ5lprptsWYwXA7S4jMAkOj9JSM8qozRidiGKIbtWC//98lTrN5BZpBBWX/n6gcCvU1FgpWz2ERkR4D1RDtckimvzgcBEREV7Mwa0k4uSrOHTnY0jWq1kIHFBlRd49JkPS2pmBX5/PHSKdk3xzGV48Z6pkAJc7pknPfgor+24r27RmD1+Dg5jh/2Wm0hPUYAYK+w2FYuQ8kcRfkxgvYFyTP4G0L7MqCIrkVQyb1C0LE5N8xTup2XIA5Px9J7i/1dILuuW77LCtgoFuX4yL0o1z/nJBo6XOG3pu3wtXDkzt28wbVkm0lVJsMUuUcQ650mMzItlSTYmvZUgvGv3/nb9iwUIiQvSJqS3XsmIX+L+LwlXKubflb3JnhS2Vm4YYc6+lngpHdCfEZaeVFf0IM2ewfxkHu/0CSs4Jpqru2QEvwJgWii+f5//pHwmz2ECvdR3qdH5bUERBZy3XHUqNSHhqG+IuHvFB+PDzm8o1JTldTrXk3iloSdNRGl6Gpbg45a9Tz8Q72viVYoaDUdyzGc3WJDgp9QX+KlwqtMePPHyvE/+5d8rxSeC+8KhImQD0EuNW/KHpBjo5SetVIqOoFIOIf/CQNntHzneVdRV1LGhPkRKOWywAUdSP+i5rwp0zRPnAQEZP7R3xyXlc+7YbsNC3/cMKbIy+Y
 DBLf18bO
 a36UmFoHENYaTg8aioC5bkrP6vwey7Xfoa/GGWLLC/FDFJ3p4CK8hJZJlFzUyc8mVBqAgEZz77+vx8y0oDWZoKU+IdyW6AN6U9aw3abMDU7XsRysFQloHum8PHqXIBHlkYkfzU6Z99hZkq9E9QjtL9Wt/M9Mnz9y3w/VFXe4SsSmZywyFc4vt+s23sobmc+hrVwHKhUAhudKIcYDyerXsjt7L48CFaKMCKgrE6Hx3oDseWMGnLL4ZNspOKNLsLkqHgMkIpCwGdizlR3psjJV1NoyrRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

The implied padding causes a harmless warning when testing the uapi
headers with -Wpadded that could in theory indicate incompatibilities
or data leaks:

./usr/include/linux/alloc_tag.h:41:1: error: padding struct size to alignment boundary with 7 bytes [-Werror=padded]

The code here is fine, but it's better to make the padding explicit
and avoid the warning here.

Acked-by: SJ Park <sj@kernel.org>
Acked-by: Hao Ge <hao.ge@linux.dev>
Fixes: 1d581ab2348c ("alloc_tag: add ioctl to /proc/allocinfo")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2; fix changelog typos
---
 include/uapi/linux/alloc_tag.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index e3ad94444864..7d4618bea043 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -38,6 +38,7 @@ struct allocinfo_counter {
 	__u64 bytes;
 	__u64 calls;
 	__u8 accurate;
+	__u8 pad[7];
 } __attribute__((aligned(8)));
 
 struct allocinfo_tag_data {
-- 
2.53.0


