Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC83CCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AFC16B00BA; Tue, 26 May 2026 07:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160F06B00BC; Tue, 26 May 2026 07:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04FA26B00C7; Tue, 26 May 2026 07:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E78746B00BA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:58:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 943F9403C2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:58:42 +0000 (UTC)
X-FDA: 84809424084.07.0E5D293
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 724281C000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:58:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b1duc5Wb;
	spf=pass (imf20.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779796720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c8InDZeEQH/9HBeQRvyUgXxDbI86LGatUfZo1HBEXB0=;
	b=0dCjEvTj5l2ecx0iyO8YcgPSBC/L5Lu/SnsK3yy11jb1vCOpVG9GPIDJdmhSBM/64I/aE7
	BvHkAp9V3wQR512CyxJzvCyzfoIOXWqiOs1OAlgm23RQvWDzY/6nTw8xlem6yrD2CiZQos
	jYP3M6ytv0gDJi/4nLW0KkOCCllBJKk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=b1duc5Wb;
	spf=pass (imf20.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779796720; a=rsa-sha256;
	cv=none;
	b=AWAmaNAEGzlXNTnhfZoLrPLpGoW7JnohaRtizSb+gTRloDB5+UetMAP4Tjd1gNpdP1YAGO
	A+Qb3jsnlLVtfHCeVmMaHkIEa65BqsxFIBdq/N7GIjrJBwBe2b7T356R86V2yUMzEm+dKO
	3a+B2afL9YHgnvTzmbHQnOKrzQsu0p8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779796719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c8InDZeEQH/9HBeQRvyUgXxDbI86LGatUfZo1HBEXB0=;
	b=b1duc5WbnZnjNV5mKWEMBUlnu8Iqip2DfYV42VxYPGTnagFk8otZsSXkR1mKAm2d2Vw4wK
	0OHxcxetNy9p9oMnJ8BhFyKwOWWPQkAJkwLrPM/ljRxhGCldbMG9qtBKtFdk0pYDSyp8sj
	UvFHh39fPV311P63nreWS+1C71QJitM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-vxoasVHjMy-G0E_g8gdP2g-1; Tue, 26 May 2026 07:58:36 -0400
X-MC-Unique: vxoasVHjMy-G0E_g8gdP2g-1
X-Mimecast-MFC-AGG-ID: vxoasVHjMy-G0E_g8gdP2g_1779796715
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48ff0eb77b5so15404345e9.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:58:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779796715; x=1780401515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c8InDZeEQH/9HBeQRvyUgXxDbI86LGatUfZo1HBEXB0=;
        b=dlcM6vdMyng9sL7eMgurM9bNig2i+R/ot6Z8x5xB0GeRdR2X0PV7xCNUVT9krlDF8l
         dHhDBx+KDnJMKcIWasPDTTIuneGOAGOQgY/71yzndmnaioOOzVHrXbCMBPXk6l3KcfRL
         w2uAOjV1KicDVeLZUjTa9JGUck4P2pwAFY397/12LReQbSgB8mfNOwAj1q4Zj3B32T4y
         gczUcMI8BuEJegyyQMGTO7PIZ1QpCK/p/mwzEkPi1aOiYIQEWo96fzcIom/U2mW4/ki+
         wyeBCJzsdlG3D64yvpNj5mvzkmK2NM/mb+qjFjS/a05CMit9t7svXhdxJFy9cpIXAZSD
         u9Tg==
X-Gm-Message-State: AOJu0Yz+LslWBJYGXVQAtYG+vcACYLT9t85RTZcwki/4haeemburpHgz
	Ml+EglZ5sepC0yoozUNCCJjouFRmeC+z3anXkHHbOrjfphyHVDM4sFAiM+zhuq5nPzeYqCMWM0R
	fbkK9lYJUFLsg6GW+uYM3tehwRAox5o5FEwzVi8WixaZq1E/GqTSI
X-Gm-Gg: Acq92OHWOPW0n75UJmY2bYC4WIQ2p7UOaWtcehIcAOqrbKn13ZyLgzDE7Pn0aepv/r9
	9iA4xDLvsl7FASXQpj52urbspWWIoEUc5XEvJwDgwjKg4p2wSKHTRY44b0yRyLIGo+Xi/tycXwB
	+3DlIFZZeD0ixu1Fq0lRvxxy+y+klaBvI3v7j8uquZtJXbrOB0R0jFdgHAHh0XCKsjz63l2ZfNk
	1odIo2slv44ELhW54t4tSNRAxKT2npMqJqXLvDvV14VFFIW5egxWe1rEffat1wxI1KUXiDM/7uP
	QZpzqm72qFXWkiaU2W5zj/EHBAVD8vkrE+1jQA3DFbcrtGPwjUNcY7Zm80X7wLnehipXZPWJTY9
	vpv9JUsxBP+ieqv0SKvbGKCS96+M0DDaA6rMTsaZBIwVt8pJCTqboQZWSB4NBCsSKD0Mt+jJEdk
	iO9iDc5QwECfc=
X-Received: by 2002:a05:600c:4510:b0:48f:d5d7:df63 with SMTP id 5b1f17b1804b1-490428dfd36mr290533255e9.27.1779796715273;
        Tue, 26 May 2026 04:58:35 -0700 (PDT)
X-Received: by 2002:a05:600c:4510:b0:48f:d5d7:df63 with SMTP id 5b1f17b1804b1-490428dfd36mr290532915e9.27.1779796714895;
        Tue, 26 May 2026 04:58:34 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (78-131-46-194.pool.digikabel.hu. [78.131.46.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490428d4d8asm110335325e9.16.2026.05.26.04.58.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 04:58:34 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 1/2] simpe_xattr: fix rcu'd union in struct simple_xattr
Date: Tue, 26 May 2026 13:58:29 +0200
Message-ID: <20260526115832.1294821-2-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526115832.1294821-1-mszeredi@redhat.com>
References: <20260526115832.1294821-1-mszeredi@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _hM77Do3FoPt1IWBMxwQt34pWq4phFdlmdo49BTBsWw_1779796715
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: obkig9mw4kmdyn17wjnp3hqjbrm1h1ox
X-Rspamd-Queue-Id: 724281C000C
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779796720-313133
X-HE-Meta: U2FsdGVkX199ePYif06BiXpe68lYjj4O6kPwi6ZenJ+ToSdfvTLu67tR+jLNvVrOeOrEMIihWjphDyDk++1kg/8BCQBeYYe+4Rj66xaYT2qO/CZuhr//g3DUDHzTDBZ87ekPp7NZhWIGl/ojNP0VDZDmHCz12DOqJlN93JshcNKG4cshHlD6YNLid73Zfn72PSTtgok0x/286UjTY0cWu5bpXpUN+PtZXwsTm7L55SWxu+lFNINgL8ZQuQKhYBY2IQTL8uATA8/G39ZD+C4a/Dhl172UlC/CRWcyQSRGxpwjb+tcVaXxL3W+YNsIzJzP50rAGv0CwGAfa11fTg1zQf/k8s18SEyyNf1zRg5J6mwRSA0dk3UpQHOT0cOfEfBchUA7tR4aazvSu3c5JohP8SWoeUvs+4foNuKF7KVpdUGT5McX1hiRxUAy8ltMWgDdbDJ6wAHD+JT2awKWN5OvRTDLqvSFp9enI2p4aboKxSZzIFhBbmUf2YbIZKpa6FsBcA+LXPwC77n1WH4HtGNyG/EU7juWL/aVXrIYjCwQTJ/vdTzsDUC8Kgc2kro3PGYnBpS1rPLtdbZ/w+SggtnrieZW61+Ssc2fdvSHOX5/JayXQLsJ0cbJzK/yz/e4PsolvCGyvXp4mS3AKKuzBNbjMeaxpy0kC6Y5ZKyFg1K6yh7idqx19ee8B2CFVomhBHAoANenL3QqVRjHmSJ1GTdagwgga6YxTsq6C2wv5SCvfsgJnhI39gHBpNxraZl+jI2YPqbIw5OK3QdL8fgofd+VWkW+RmZhvHZTZBEGQVc16SIFqU+h8saHw20QekMs9klugY4Yuedk5Q/S1D4AnjffQMunQMHM/KWYzbKxYuu6OI2BE/Ko8zfe0k66rGAT3dtPglFZaqb6x5VViZyO1cZ+a6ZTjNJ4miWxQKIr3wDKZfrMghK0o9q8uhLM6MI1Lk2ulKTZB8ucI+N6v3hTlIQ
 zafGVkFF
 GvunDi4m3h39vCjwUyj+rd81V5TsolDQEBqKzTs+nL6XSgUAU/tA5pXvVHAEwBaUPJCpKVCxgUqcGLjkeGTmYEawQD9y7NAZ+ZkD/QUV1iTCqkR/D2sldQMtLsr81LOXdqwqkM469eAiRCoJFg6TUh8I7CaygfTcqWMqUzsSSinsM7tFq0aq/UiuksGuoVNbBElYJpDaWtiqSR/juLv78ohdDTqPIWl8YIY9WpvVESECg+duvxf+t+F+i+86XdBZeZxifwO2rr+4etGSyv8QaB3YlYLML7+MaMUxF+CzXFlMtackzb1JvIBqy3BOfhjl0QLkGPK+p8By4SHQ5FnkqVgYWSe9hLbwmJw6sbvCFyZcjfC8t8/3sdhHEPepyg6y3CjjmWO8LWVZL4PyI8/lc5RfWozKA8iNxFon+XwInGHw54yWpZ+8rBAeuWO79YT6m5BIpuiqshToPenc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'node' can't be in union with 'rcu' because simple_xattr_list() uses 'node'
to walk the list of xattrs with just rcu protection.

call_rcu() on the freed xattr would corrupt the forward chaining that is
used in this situation.

Removing from the union results in a 16 byte increase in the size of
simple_xattr.  New measurements:

v7.0 (no rhashtable):
  File creation: 993.40 bytes/file
  Xattr addition: 79.99 bytes/file

v7.1-rc2 (per-inode rhashtable):
  File creation: 939.73 bytes/file
  Xattr addition: 1296.08 bytes/file

v7.1-rc2 + this patch (per-sb rhashtable)
  File creation: 946.84 bytes/file
  Xattr addition: 111.86 bytes/file

The overhead of a single xattr is reduced to nearly v7.0 levels.  The per
xattr overhead is slightly larger due to the addition of three pointers to
struct simple_xattr.

Fixes: 12e9e3cd03b5 ("simpe_xattr: use per-sb cache")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 include/linux/xattr.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index a75b99eb1f04..7aaaf4f8aff5 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -112,11 +112,9 @@ struct simple_xattr_cache {
 
 struct simple_xattr {
 	struct rhash_head hash_node;
-	union {
-		struct list_head node;
-		struct rcu_head rcu;
-	};
 	struct list_head *parent;
+	struct list_head node;
+	struct rcu_head rcu;
 	char *name;
 	size_t size;
 	char value[] __counted_by(size);
-- 
2.54.0


