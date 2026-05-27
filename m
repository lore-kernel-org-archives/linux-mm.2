Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4065CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161896B0115; Wed, 27 May 2026 11:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ECEC6B0116; Wed, 27 May 2026 11:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C8A6B0117; Wed, 27 May 2026 11:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE6946B0115
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:37:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A183D8D762
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:37:41 +0000 (UTC)
X-FDA: 84813604722.04.C49C1C8
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB230180009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:37:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hLwarNtq;
	spf=pass (imf24.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779896259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BrsL21RjbuMM3T2X5Mk11zBR+jvjayaUF3bi078MKuY=;
	b=RjrVVmBc/bgD11UjFzKWMEXIbt9wUsXJiWFr+knNlRX0Qt5ZPGTjZARjoqkf2Ag10sYmhe
	+8cVYMBsuf84FGM+5OgtNIsiAr/S+AIV6WHvgkmmZ/hIIWmP3D6o89/V/u6RQpIeS9Fwoj
	ZysT5wy/A8/MeI2AS6HdvR3toS+SLNg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779896260; a=rsa-sha256;
	cv=none;
	b=TTpY/t36B0GgxfvWxQpZTL4wM6PeCFdvqyf6CELRAY859LWoH7RXj0O0BnMkmMxLJRhnFg
	il/Nzo4krW8yCsUlFtj0ayjltRteEIh1q29YhYRTUcnZwoHLsN4Fo99uCwBQuuIOs7lLji
	T8fPXgFmnapmaBspuIbJL0mQH1SsHH0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hLwarNtq;
	spf=pass (imf24.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49048e043e5so42696435e9.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 08:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779896258; x=1780501058; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BrsL21RjbuMM3T2X5Mk11zBR+jvjayaUF3bi078MKuY=;
        b=hLwarNtqkPmRLy4SdcUs0bqoXcA1Gg/+wGVt8Nw16ULRbX+sNw3x0rJi9IAuUFuMGw
         0W70+yG/JdFCcZTU4K4HpIV0ueG3WybS6Z4+K7JQGKb+pQhX9jVuVtr9UxJH0VJJLyJh
         5jJguqYlABYlqYUz9iJ7yJVR17xJbmTMLmekRyJ+PgIRiYHhMZcAy5iqOVkw+x2ZAEO8
         b1Md5paZUfrvCC8PPq1rAm9OKEbhMk6Cw7qhcbfuYzcavsu5xNM5iNWweBB7XM5OVySm
         zC0f1ATWDOV8PzqbkV+NSYVB6NXbtUHsv4GbIjOKd9eQMjpvLEUmnk1awCdPIB4EpcaQ
         uDXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779896258; x=1780501058;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BrsL21RjbuMM3T2X5Mk11zBR+jvjayaUF3bi078MKuY=;
        b=YrN4bkRlYQNP0ys/oVG39vvdcEufhEkuy23aqCH7MPICEN47gwyELLf2MZVlvCnG8Q
         qZ0Uhen7t3xP74SmEESVO+bhNYNTQ5WeihR7xaaoFtZJB09QdE2Q5cSmP0DTL2mzpokk
         KunGRjigp/yiuRbcboxF8Ydyf6I9pUhUtZUwBZr7B7FX2U7Z78U48YxY7C8yrGw+eleC
         QIxQOi/Z+vJN8ZxD8pjBTRAzxbmhOtQodPsiW8fc0V4+GZlh/i4jt+x0yFUkMxRldvIH
         Ek9FNqd4LSUTIWLjMD8AzUgo7uN0FiL1yrd0jAqloToEdYYqZN3gqQGgU8iuMyeFavzj
         njAA==
X-Gm-Message-State: AOJu0YwsB1Ic++teBYfy3Df0053mzPhWaYKOWjvu0c2dw1gRgIynYuYs
	6w8PBeU1mgheuyOX1URLyY6lcPqIjE9rKTU5DjFlYSJksKrfWpUBSjI3
X-Gm-Gg: Acq92OEB4nGpJd3kfGpXSsGfzo1i7CWUiWT9PKtmB5FTNClaUKva21FNjKQOL+0BlPk
	OjV4YMTZ85yCXgN2K+Yt0B1xYQk/dV+oQ2jDBhh8ZDLE9bzd7nwkiFRPh6GWlNWiZVdvsk6J3Zk
	06eftjsfOhlBbcBvFozBygeBoPqv/fI9ytEbW8WjwxjeCckUfXRRHGTVsM/oDwgwzvqJstVyzjc
	SnyxmRNzS/PkEhXNBrjHKG+fiApwPViIxyu4+7yLgXUVqHoNrQim5RyEbr1C7YQ6W72h0U4uMb5
	1cfllpEqgLH4y9pS5stRIC3SJFdknrlGx1DIVqu8PgNshYzV5rgY48cnxG2TDdIwuaQTqo3hFS5
	5WVQpN18zwG1/d0hyXIX9EGMp+2L7EsQEa6oYD2X3rKbCP7LJO26vYUQ/WjXVwaBUQeSfe4a/uu
	6InN1GJAHzCOLHaGlJxVESfmxv7v8l
X-Received: by 2002:a05:600c:138c:b0:490:60cb:55f0 with SMTP id 5b1f17b1804b1-49060cb56femr268982935e9.21.1779896258063;
        Wed, 27 May 2026 08:37:38 -0700 (PDT)
Received: from localhost ([2a01:4b00:d036:ae00:1c16:588e:9e26:6aeb])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4904561a33dsm370360215e9.11.2026.05.27.08.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 08:37:37 -0700 (PDT)
From: luca.boccassi@gmail.com
To: kexec@lists.infradead.org
Cc: linux-mm@kvack.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	linux-kernel@vger.kernel.org,
	Luca Boccassi <luca.boccassi@gmail.com>
Subject: [PATCH] liveupdate: document current compatibility status
Date: Wed, 27 May 2026 16:37:12 +0100
Message-ID: <20260527153725.1770394-1-luca.boccassi@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DB230180009
X-Stat-Signature: 5tokx8zaqz7pdg3q3y9xx9dn15bagp5h
X-Rspamd-Server: rspam06
X-HE-Tag: 1779896259-783796
X-HE-Meta: U2FsdGVkX18qQjN0vuwiL6M53ElCexXdDtDlEZ9dZ0h+DCZ1VxXe6b0pmk8wbYwJF7/y0EJNJbAI0OD6n6mGHT3OihGV5HdakClKRCzVfPAOQ+4vziF/BH7wIM8n12KP8OGxIFkZGxLV/MwmSxh7nEJ5tnsqNdi5Eo7wlMzQBbsb5agV4/Pbb8M7+bqlrYxLT4UR5/e8macI7e12yxefiNuM050pHYcyl/t80z8wT3n681izKJPblwks/O86F5y1wu/Y0d0EH8qWuNtuYULW157OhHonsRG6nQZtyFKF6wXFEZGA0mUR9MySZWqcu2FPk7H8znw3Cb32qa67B5ZfqCi7M0VQMxM/dbnhF7Ob7u1/t7Xfdm+nWmMNEdqpdtTGDZJpotOi2T2KpR4ABgRWdDD8TejTXeE1A2A4qOEth33L8q1RHB/JVxEzl9+1cLsQFMdIFn3s99kVOTL06rM7auInyjhPAzIUWAaFBzDVmndTS5QtE5JaH0fPirE4dDwT6njDQkGS5PvYydwxbREWWZbkffNYO7wpZ5N+LeQ/px2IJI/22FUHK4jDkySK3nTk5kmudvVwt7OmRmh7oc66OCt4L/IoqzkSisnqsJmLEEOA1xFjeAa/Ed4OQNvZ4uFwcP7+4NjLvcSMaQufjS1ul0dfqVxKTTkFkVnGqtNztLxgnjdQcFxt5EBz7l8mT6HS/DJ/OaVjxNaejZLcivgApHDQwtzpDC9jJSpvQuMFItIOYyId2IYy+qRm9jW1yjT4X1OLTQnoww6l8DfCi0GGxfyox/So7Kp49eKOzQH3g+7Ykr/KbVQaNHAu4VFFS+TB4dXuhFEuULkpspKyQdM1Ia0z949HdyxIagoMi3LbLJJS6JWlZTC0f/s88CFQg3h516jfA0anngqaidQqx12uOKczd+CtUDrBq7dQOM39dQPFX/lvIeI8/xpEhaoA+m58PUosC0prTfa5NkmV3sW
 CfZygDIl
 nQtRqxRxSfSfpZnw1dvizA7wrrA3jbB5w8txBONO4DLZCVQicvIbXSP/cpZc2ojOXdg8QXY310Il4nwIHgYeihFkgibPgvdUab40YR+HDikGyCHF4G8Gm9htEQwiHoa0aXv3sl+hauszU1Qh13cjwtuFjYpWcYyqMnLXwqS8LoVoKPF7/OIkcrkcsZbb9HjjlBfGPj3zc7xTK98W0SKBzeKSYgFJ5cXaq0NlnDPHBZotQngQSsNJ5dHPJMipUeYt3LgZypgzJL2+JF3tqbqR5d27DOp70ZG2wXSJu5a/aXsWZ5s+Uv69JIUxJkKRLqC7cFrFDbiMUYlSmYDYE4h/fbvXZpU5fzbb8gJStt+zkQBXb/n41r0arBxtcIF/3SuaBXj1KhuT0feRYxAkYQGBhJr73Qfc77b0KXhH95VF+He5P3rKatijWbsYEe7e5C9R+OkEtJhbuHyPVThMzGzmYGQdcZfINJaHA0NyxlAZplwGg/J3fdA5GpA1t2op9HiwB+nNlZHD5cFE8LBxb5W7KW4wtrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luca Boccassi <luca.boccassi@gmail.com>

We currently do not guarantee compatibility due to ongoing
development, so mention this explicitly in the user-facing
documentation.

Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
---
 Documentation/userspace-api/liveupdate.rst | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
index f6efc32fb40b..cdd74627ab75 100644
--- a/Documentation/userspace-api/liveupdate.rst
+++ b/Documentation/userspace-api/liveupdate.rst
@@ -14,6 +14,14 @@ ioctl uAPI
 ===========
 .. kernel-doc:: include/uapi/linux/liveupdate.h
 
+Note on Compatibility
+=====================
+
+Note that the Live Update feature is still under development and subject to
+change, so compatibility is not guaranteed when kexec rebooting between
+different kernel versions. This is expected to change and stabilize in a future
+version.
+
 Userspace Integration
 =====================
 
-- 
2.47.3


