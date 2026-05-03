Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAA0BCD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 16:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06C286B0005; Sun,  3 May 2026 12:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D616B008A; Sun,  3 May 2026 12:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4DD86B008C; Sun,  3 May 2026 12:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D22CD6B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:04:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3310C12071B
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:04:48 +0000 (UTC)
X-FDA: 84726581856.28.14EED76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id E8C754000A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 16:04:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KmpMOD4K;
	spf=pass (imf07.hostedemail.com: domain of costa.shul@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=costa.shul@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777824286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=X+mJ3ULyyTKCXVslNnzkq+GlbrFoX1sf8l7wRqCeWDg=;
	b=6UfthQwJuh26SGogBoYwT4l+CIG6oOQU2YAGI8HNZfN1eJKESFj2Gqpvognpvotc9R7h5j
	FAEh2KeNtEdRdKDQnf1GZzS9ZgSboImcn25pxrUEjWnIrblWZsEZRd8sDdEqpO4Dk1b436
	3qIyi4ELaaY2y9Z3lmlNRX+4ND8NCDs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KmpMOD4K;
	spf=pass (imf07.hostedemail.com: domain of costa.shul@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=costa.shul@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777824286; a=rsa-sha256;
	cv=none;
	b=fgCtc8KviJH1uM8lsyNiQIoDEwsr54mY1P3ahP6h0YsycDSo+Sj3Ts3gFGvMCMwsApv+fl
	hrQ6077HPHYPxxjYvpFObuSAPiY4Z5EJPjPQZ3a0HI1FX7PS+AsDTsaPRrzT8wCmjIWvPm
	pMypaojcZG7QJNhYFCOM3SJjQEBtx+s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777824285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=X+mJ3ULyyTKCXVslNnzkq+GlbrFoX1sf8l7wRqCeWDg=;
	b=KmpMOD4KX3sRZri5OSVZliGRxcG11MBIeIDUjcSjrJrjbGZGFFUw4ev+an/epaJCKoB8aQ
	KP/1iu66EA/yxNkDxvMGRTn77WH55kdyKV4wx8L8xMB8BuzG966USsO9+nIVOWrJHFgB/1
	bMwayaQoT9rG4p2hiZrkGhkg3eNlQ34=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-xhmNT4KDMDCJIWw_5SIsMA-1; Sun, 03 May 2026 12:04:44 -0400
X-MC-Unique: xhmNT4KDMDCJIWw_5SIsMA-1
X-Mimecast-MFC-AGG-ID: xhmNT4KDMDCJIWw_5SIsMA_1777824283
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso1915525f8f.0
        for <linux-mm@kvack.org>; Sun, 03 May 2026 09:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777824282; x=1778429082;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X+mJ3ULyyTKCXVslNnzkq+GlbrFoX1sf8l7wRqCeWDg=;
        b=EaYvGqjbK4wmxw7WWVKBgZChrXQuVFXxr+exeFlujwtWjl+ntsbvfMxnE7D0oNZD9T
         1rQG6Tk9LKUjx5Vx53/HnMgkoy4i1uF6R4u9nl4Q7mtbFUJWc+fDKWABYZeIMODA3/P0
         eOm8oJbeg4Is+jOBQEkLkaectJ4YcW9sH1nJLQRf9ms8tz0nyWye6vWtVsYXA99Rm03X
         C1pjj5tc41HDSxiUbk6Fu9dIdg1sNG6k9QiK62qwY5DDCkl75a9HJAZyinB7l9Q91rJU
         GBzH6gNraTECYWakhZaC5rfry2oiocWLdUwG65YtLzqIai7K0HsfFRk2L5/rWRY7h8V/
         bFmg==
X-Forwarded-Encrypted: i=1; AFNElJ9KYL27ucMGta79ys0G+kvymWEptd0b3FTtaqnMFQQBxBm4upxu6iJDNquhRDtD6bdjtziZ0jD8Yw==@kvack.org
X-Gm-Message-State: AOJu0YyjaNPiqT2YVfoWL4QIKpxTs9qLLNYZUH4qlv72ozjo0yYhPUa2
	oTssElgficYlHjc4RX8g6DY6YtOFjFXUQIFIwzJgb5dpG/V3YzY78o0VOmdfdqt8Ztu/2A+uIJ/
	wNl4GzTRXnfGzUeREIDKlkwi3c/45kDaSrv4Soe9BWERGeeNGPq55
X-Gm-Gg: AeBDietfIAOUh4bVeuVWtLbwxVZpHRCDMC1bDPQbyyCo5xDnaPGP9Rf/Mq9tJzXeJZc
	zMgMLrk+7zhOBKlOMzWEuwMQ10H61H947DsB50Zx4vlSuDXk5mtYjBz+Hb4oO/aL45+W5Lky6GZ
	sNKn55uGBVqMj9+++VoBUkjhI39h0FiD5xAsWs6sACyX7h/IvaqQWKPLzZYcNkhKJridLZ3rkqd
	dray89hC+b6y5fcZSyZTnC3gmqfM/G+Txv2c4ObD7d1DVAGslZP3P0tkgeQc8xcwlagKqFLz8S6
	ri8VOi6oijd/0zOc9CRstm59LW1WhRmeXfkziMqiXiTTWzf7DlMqvTQ2RYyjj1KAn6Rm75wuLea
	RsLZl0asuwGX6vs+S8G6PxIpXGZBwQB90347778rarivZKAv0
X-Received: by 2002:a05:6000:613:b0:445:ed7f:ce84 with SMTP id ffacd0b85a97d-44bb34e71e3mr11488053f8f.10.1777824282488;
        Sun, 03 May 2026 09:04:42 -0700 (PDT)
X-Received: by 2002:a05:6000:613:b0:445:ed7f:ce84 with SMTP id ffacd0b85a97d-44bb34e71e3mr11488010f8f.10.1777824282049;
        Sun, 03 May 2026 09:04:42 -0700 (PDT)
Received: from costa-tp.redhat.com ([2a00:a041:e223:1b00:fe51:8bb:7986:c897])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a981ded99sm19800555f8f.18.2026.05.03.09.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2026 09:04:41 -0700 (PDT)
From: Costa Shulyupin <costa.shul@redhat.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Costa Shulyupin <costa.shul@redhat.com>
Subject: [PATCH v1] docs: locking: Fix stale dquot.c path
Date: Sun,  3 May 2026 19:02:22 +0300
Message-ID: <20260503160221.1594319-2-costa.shul@redhat.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zcoux8VqWa1vuR53wzuwvch1C4qEy5dhs9DToojYXWk_1777824283
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: gzxu755nqeqjfx74774wckr5zm73h3uh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E8C754000A
X-Rspam-User: 
X-HE-Tag: 1777824285-291152
X-HE-Meta: U2FsdGVkX184PpIulROWFh3OOhvXpNO39L3cbP0X7HlzqG81mPe13pc6uNsny4pb3L4MUjcv9/u72j3OgZBDNIXxD83V0vQ5ZsXM8hmkClgBpzjTQ8gPavtrV2WjRNUlFsckma43Cgcsai0n/mq0ktWWZTRFFWuBI0WVvj6h1P6/NKASImFj9SSz68xtE7bNpTlC9h81LFRwvJjJBgwNCJtItUMPyu7+h854odA0DTC6uIW55Etzs8an4/w/6YVV1RLB1uAKrRJC9EZU0MO7YD81iORnETVBxPQFPlONhKT7Sm+GdMKJrBp0KUH1J8STBEwR32ErqEbfIbaCvjoZVLmxAZlopJ2wlwz+vX5RNc4mCYf7ZJk0bftQUuQZfBx38ZU+wU+e/pOSrw3FYriybAc6eVgpEb2xN3zz6u34dX8VIz9TgxXOIe1MkZHe/McMoTqXqeUmvweokZUvBvd5VqN/sq1Bf+nQ4Jse4gToNUzFhekjRrKrlRQrlT7ZBMu+RKhoGsv3Vve4To+TQNA7vF3PXnIg5tXBxkTwI+0fBnDOTYaH52xCOvrcRTf8iwS0wnWgxw42xIHg6FOlKHUy7ngjPnWzKhUFokTTlw8FxIRpK790cbwvKoICx5II4rP1JL9a76KhXXqY8jo/isDSCyZGc9KVG+3XM7OGe46IOn1TPov4irj6902bRp0JLN4zOzlE7AsvI/mZ4922tEfbqFDsVmAlFVqXaTo6Jhemy7+nmtuP+oUQLfIWrfCeLGDtx35PkrNKvbkmLcHmFM36ZqtbRg5f1xNJTGslHvaHYBKeLRb5vU2l7JMnlty95o0WOh3fqtEkreUY7RbD13f2ZfoAb0QXlk/gyp4FWm1Qxxf+JRzcCm1DXbhI63+1px+UzK7e4eD2KhuT2Qru4FXHI0Yj/5atr/TqZ/Hzo4OWHzpGaKqxI3IxJTaiVYmnY3IaAkomYmkCoX5sZvnybQ2
 xf0p07mq
 hthQp+1h8WWzrcyYqKu8kabYun5S8cWatr+iUsXVr2ke/gSaaCWfKN1I24LY2D2Y8BwYZL9KrUWdRUoCcpZHut7iJUey5Ns7+vuhACbF3/h+pXUlQVw8oZZGY3/3uPcaewTkbTJHKoaXtrpJEmpYHAUWRtsyXKoQU2b2ocY4kQ1hOt796uspha6XUEXi3vkGS7O/hNtMr7mr+T7RVkRqDs0g+29LvsBiOnuBduobbPQUP/eT8zC0JnWluftw+5OpyHa05jGlIQRNYX/86vvNZTDCy0HtV14jQuX6vCcMmkdnFm7Lf5XONukxRNIr+LmsRPUVY/65HAhWJYvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The quota code was moved from fs/dquot.c to fs/quota/dquot.c
in commit 884d179dff3a ("quota: Move quota files into separate
directory"). Update the reference.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Costa Shulyupin <costa.shul@redhat.com>
---
 Documentation/filesystems/locking.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index 8421ea21bd35..277e49314d32 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -584,7 +584,7 @@ write_info:	yes		dqonoff_sem
 FS recursion means calling ->quota_read() and ->quota_write() from superblock
 operations.
 
-More details about quota locking can be found in fs/dquot.c.
+More details about quota locking can be found in fs/quota/dquot.c.
 
 vm_operations_struct
 ====================
-- 
2.53.0


