Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2588106ACD6
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 18:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F26156B0005; Thu, 12 Mar 2026 14:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3146B0088; Thu, 12 Mar 2026 14:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB54D6B0089; Thu, 12 Mar 2026 14:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8D5A6B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 14:40:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49CFC140340
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:40:58 +0000 (UTC)
X-FDA: 84538277796.26.8626429
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id 946DD80013
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 18:40:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DOAISSab;
	spf=pass (imf30.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773340856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iVF+V61HcxXBp09WnQGFviGUtIXBpfX2/BfWvNDxbH4=;
	b=B4IOgnUxKapQ332j4mn6PoHw2vDCAT44Bz6bB1kdZz7vyPkYDvZcjMOGEGiU+o/R9AXWSj
	r5VJ2W0BsQRMmljAjLo1YkAv7NseQdjfoKSrUNyreMInlIRRftA4YQSBVKd4+YlIDZev7T
	wiiMHgrotl1YfFdT3hhVc3ZL8vyf7jk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773340856; a=rsa-sha256;
	cv=none;
	b=ajYCFugHHhrOnX61P/VzvtL2yArn5SyePnbf2JCp07rJRsd/NHyPgzsSjIyOBdPpkKLhOd
	BO7JPvvIZ2GmvQo8EcXRNgd9qYEx0EtgdFyv7pYmbKBia8IG67bQVHX4t8pI0L60yk6LrS
	c6+3HFrEuKnJA4uXE97KSdAvytG2pK4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DOAISSab;
	spf=pass (imf30.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-59e4a04f059so1495233e87.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773340855; x=1773945655; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iVF+V61HcxXBp09WnQGFviGUtIXBpfX2/BfWvNDxbH4=;
        b=DOAISSabcqv1QpEawdtpEEs3RIfgOSbA5Srio299i1B98C/FnrGeonbf9CDtqzYQbG
         MEHi73UiCoynSHHaOoGT5widdfAIXSgMCEi2+DA+fN7+2e5cSnsij2I5W9dsR2k7Auzw
         IU0m0B05mA6wrYwOzRV+I1gV/H3yEMwUAXHyFrL3W/a34SZ0pIFlG6dn0s25uLYtnZsO
         DfK0166/v2XmxxVl/vc/mSGcbMsYSn3dodrZOZHQrKskPZDZsEpPbVjYiOXIHgRgYpCE
         f+i1PI8sS6gvaV4f7fBEUSf6DdHoKrJuDnIuxhQ3DBF8t7RvGL6hbtqMu0raDwUCLQRA
         2QNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773340855; x=1773945655;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVF+V61HcxXBp09WnQGFviGUtIXBpfX2/BfWvNDxbH4=;
        b=aSZJW5srxr/WA3Cu7XDAFfDDkK502uhOWj8slerWW1AFWVxfpTq2/BTsQoFNDR2s8d
         GpmET+XwgK73FjcICmk2SrPLVDnC01XF7Ws5JcJwnOHJ2XLk7fEaCmNDQx9lYZWPG+fM
         8Vk9H6cn5QnSnaUsmf/00Tyw/WGlx3qzO6O1lV1QfL4vYNud6MyzgHA0QWKc3THg+mAH
         +mA6QDjsfertc2Xjy2vfQFe864gk2o3BIbvBJN44TNpRp1S1vc+s8CbLbVgQsz/CJ1v9
         nTk7UDKLlUZREb5ICX4B7PxkG1kjCVVOaAh4MayqZoCC4k8N+52hjgAuwegiNA0c1XeY
         xBWg==
X-Forwarded-Encrypted: i=1; AJvYcCXfIKsV3109PLg9xC/egAmTEuuJSR8vjxMEAiWT3dMjAuwt3fJOyEwPWlbO/Py2s7osgdto+tpjmQ==@kvack.org
X-Gm-Message-State: AOJu0YzbENEOweUYNYJC+bSnJeCgP5KrzmAnu7jrbmS5qWgBlbAwbBb1
	uiMBnU5YDG4zw+bHJEqC2rpSN44e0Pk6fcMon8MuM6r+dBoheTQzD9r9
X-Gm-Gg: ATEYQzwFx+I3PQVhfWee1By65xEjhmKNk0ryNu3GqAMvWKWOgOfkcUMsbfhaaE2CyL4
	LL0GECvMU5h96GADt9lAmTHTSvfD7L+AxnpC/ipLUdNpnK7C6bJ5f/7/T7cKjJUklHs5j1ju6YH
	sdmZcoLQpAoj/XqJ9ZVVlBWRUwDstlcUxdmBB/5b2HpZpUJ6lRNVNb/aWvdavHE8lXTVh4TYXbl
	cXa6w8mrsle2SQGJjo6Df9qjFpjByTXZKuiTL45dINzftpB8ylnXItlMJWwsF5ObRj6nS4/npFy
	Yu/d+SHF7Ew0qV4DEX86gOmaBo/ElhVTDiRAWg21LTLwGZSaUxGY3TFZNVEl8zQK/E0ufjuwONo
	vIrQObThG1ATy9SOkBHd48jZ4tCToOrYOSh4Yi/3vyGH6yBwmWKxA9hD94kSpllvRPAhgcfeQ3S
	LZrf9U53iJELQCMxoXkgMchddkPO/1HG9cHjEjczRfj3y51T0G/FLq/QEDFmm6dUzNvn9yP8Q=
X-Received: by 2002:a05:6512:3baa:b0:5a1:4497:88e7 with SMTP id 2adb3069b0e04-5a162b1a9c6mr172336e87.41.1773340854599;
        Thu, 12 Mar 2026 11:40:54 -0700 (PDT)
Received: from ubuntu.. (static.159.107.27.37.clients.your-server.de. [37.27.107.159])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15636b69dsm1107694e87.82.2026.03.12.11.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 11:40:54 -0700 (PDT)
From: Josh Law <hlcj1234567@gmail.com>
X-Google-Original-From: Josh Law <objecting@objecting.org>
To: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Josh Law <objecting@objecting.org>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] lib/maple_tree: fix potential NULL dereference in mas_pop_node()
Date: Thu, 12 Mar 2026 18:40:53 +0000
Message-Id: <20260312184054.23481-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6umtw3bewpxenkp1o7fmduijjhaxbkgy
X-Rspam-User: 
X-Rspamd-Queue-Id: 946DD80013
X-Rspamd-Server: rspam12
X-HE-Tag: 1773340856-28589
X-HE-Meta: U2FsdGVkX18kxPG9TYdxn+fTWwdOv+iQCz5YNv3ZXgyt/b4p6V3QrpF801uduRGGyJPU1FYnubKJlgw2CO9bKbO4aXOSiJNI8ZCxereZxjpn2vl90LgoLJanniCfDc7dc9w/WxcPSALDafwqkXHFX/+IJcUpCpQ7XHSZtJ4pPnJ3NgyopQh+n5u8iPutp6GORBS/oJU1dSwasYI5QRMkiFo/nbIv3BkVddm8WxpS3XQabVLWTjujSCbvq6l4si6dUTGU8nkczkVdn9q2TFE8S1hWtAXn5J0B8rPdZLiQYPbP7JKInQgGyVF0uQoznYUbwZlBEw8LZNAd32qxzzetvSSRG3NGzxKZBipPVtBLgdikk2f9OQ/ra9Zn4m7XZNKIzE/SVb7kMNZN8TBrYHIVPqiYeFpZXXYlYqCZVviwmdWiDKryVj17DZvxAEDc1qB2+zRU4yvzuf6QhzUnhk/ARH+OZSqy3tOFEb8h77cIpEYOa8+hO6RpybkqVAcJNeQF0pS1J1gsxAeFk0TbHKFq75QzIJ12yo5MegttrcgUFifLaBLi2NW3VobpaHOzYAnk1SjZJ90CJq+W5OYRrGnZpXtqBFpG6kN55+RFaM2G885r6gOHFEZ0zvWaSS5IBrpkYmFQNvBWQDvKva1mx8MtY1X3Q+mDfe8h6P3srUj/nx9lT/D9PP/UsHa8fiVX6QIvctiTlE700NrRACTJbFWRd28Fupge/tqVgaT5wRAHQE7gEvYmDWVt+P2QNzPozKEdUdFPqG8FtKmHxlpUw6Rjp8aZHQ2wKZuTzFOCtVfxEP3+peLSDBToVE/t53PhMUMYLpdyFsHVqnBoiNuWNEFvjBvYdPRRqT4WmjDNOnDBEKOQ9bpsOPDypjgD77pYVsXXDfm1sBjfW2UK+fDsMv1JYQIs30+LV69sjcTgeKpribM2szCrXbDg12/2tiOqC4teoRbz13pzmm9EXkNx0t9
 4R9BanBm
 j1CFSnidPk4k8cs+kONb+XfYumEmzqECcW7Szf/+NITxsQPU+AljdT52m3E1WeajdB3Ur
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If kmem_cache_alloc_from_sheaf() returns NULL (possible under
GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).

Add a WARN_ON_ONCE NULL check after the sheaf allocation to bail out
early, matching the existing pattern for the !mas->sheaf case above.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 lib/maple_tree.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 739918e859e5..87a2ba6468ca 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1063,6 +1063,8 @@ static __always_inline struct maple_node *mas_pop_node(struct ma_state *mas)
 		return NULL;
 
 	ret = kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOWAIT, mas->sheaf);
+	if (WARN_ON_ONCE(!ret))
+		return NULL;
 
 out:
 	memset(ret, 0, sizeof(*ret));
-- 
2.34.1


