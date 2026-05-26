Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49381CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225F66B00BC; Tue, 26 May 2026 07:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150106B00CC; Tue, 26 May 2026 07:58:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7A46B00D0; Tue, 26 May 2026 07:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6B676B00BC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:58:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7218BC18DE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:58:43 +0000 (UTC)
X-FDA: 84809424126.28.5169C7E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5A3B6120008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:58:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HHAiBBaz;
	spf=pass (imf29.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779796721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sRBmHOp/Al1wa4/wsfR64tjuTAw7wufZULw8KgXYJhU=;
	b=Fp/xFCQcSMrF+5n7nbjgHcqCBAMop+9hXUp24GCBhNmzBrlP1/BKZDjkDqbF+Yju2jg6zh
	A60075v+AtwK6iA7OegfvxGtvcr2DQFMl4l1wz7mexfZgc3PFvcNSA9cyqISEy2n+8MKys
	JVBwQTcqtKlA8FrlUjSzgngF8ZyNN7Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HHAiBBaz;
	spf=pass (imf29.hostedemail.com: domain of mszeredi@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mszeredi@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779796721; a=rsa-sha256;
	cv=none;
	b=ZefdIABTs9gFNeUlBIWCZina4Pt16x1vTBOuachNFedx2t/6etRT5lwZXFSSSZSFvJ10EH
	CmGqWTUWTZyvQdwx/L41poeUrhA1XkxJ/mKI7H7pEmndmNJZCeb4K6kasE5HORYAvV6Aw+
	3yJ48q2pUcNpON2zxwkYbcjlwDnnnMY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779796720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=sRBmHOp/Al1wa4/wsfR64tjuTAw7wufZULw8KgXYJhU=;
	b=HHAiBBazBk7i+nKUzsNPFNKPTwvg10m39V3nVDTo4aLk56DZEX7T0BcfSe2b8g96/8cpVu
	+c2CoVKHwuDi0Z5qZ2a5Qv0RONJ4Stf5dAu2ewO2RsObb4mU9cvNxfMWSlVCseIh5dINxS
	+aYK+uXSXDHq0rtE3YSkNt7G9uHjMtg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-s7mYhl9XOs66lcLahlWP8w-1; Tue, 26 May 2026 07:58:38 -0400
X-MC-Unique: s7mYhl9XOs66lcLahlWP8w-1
X-Mimecast-MFC-AGG-ID: s7mYhl9XOs66lcLahlWP8w_1779796714
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45ea19f2564so5276884f8f.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779796714; x=1780401514;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRBmHOp/Al1wa4/wsfR64tjuTAw7wufZULw8KgXYJhU=;
        b=Upqg/UZGS6dXJb2/izs2XsnP2Bq/7EbsR10idGEChOuMUZ8coRantw0s8GQ7t9Z9ud
         HfcA26KmH3SNHjv0IauPLEyszMbBVQUSYQMWMg34S7HzyyVszIPMOt3i2UoRafGjDhhm
         tCmxJUX/8mcEX+UR54Zy8F10UbMvWg0gRBOfGC5Brr8B4qbUPC+mwdKXB8A7ul2ESI9E
         0hDWzlr0Es0E5PYagp3Py082INBTpG7yqRqakghpA50wrJn+bWPHrpSZLC1SXvbxeZOu
         XKFTxjTTAi9GnEFioTVSi8ZS9mbp5EIhZ8Qq6JSfT03Nc/A6BUBflqQ/rHyb4OODNnlM
         bNEQ==
X-Gm-Message-State: AOJu0YyKTBHZb7oVzH3EshjWhhnNg0WHBY7xfblKsNUWAky0hBJFvYLH
	kf4lAls3kAe9eN5RUThbIpM+GcatXpdapV3IOAkCHT1/HoC5swydDDuosXY385zw++4gvpVEjL8
	TrBEbfopeofApqVMh9XfU70RDStjskYRJSuyiicm6ON5z+C5xDDvzLptbrTYF
X-Gm-Gg: Acq92OEkPtihHiRNLjejbZtua9fbUETVwvetPmVJ2q0iGrri8laJt/LWG3UE9iW8kIP
	eqlFckvPnR99l2TBil19K5KyjbNgshmxMWijNneWByeErX9OVRjklBHx1C/zxeQNhl3VpBw0YnB
	5C1xVhDFz/zW965ydK4vdM7vPrlPG8JgJURxDIOyqioCYAV+JyjcbstIjAlkpoZYvMZ8b+ipC3x
	kYz6AbM02upE+LgRUNe0pZkX/41WKe53hGzQBLEIaNhXCEXrhVm8BvWXHhkeyn5OhvrdyiUyWom
	dMu6vwZjq/SqIcaHth7kOXPtcRwvjcLJqQjbiuU+T5JGGYfua6ctod+o41RN25nTvgHWZXpcNZ8
	npf90L2A6SRUYUSIu9OLjS2JetFlvnLPRC8lUUO5xA4Mo7uFaOKOdyjJfnIHiZmP7IYEo9JVte5
	lC
X-Received: by 2002:a05:600c:4511:b0:490:6869:46c3 with SMTP id 5b1f17b1804b1-490686947bemr112003385e9.30.1779796714266;
        Tue, 26 May 2026 04:58:34 -0700 (PDT)
X-Received: by 2002:a05:600c:4511:b0:490:6869:46c3 with SMTP id 5b1f17b1804b1-490686947bemr112003005e9.30.1779796713890;
        Tue, 26 May 2026 04:58:33 -0700 (PDT)
Received: from maszat.piliscsaba.szeredi.hu (78-131-46-194.pool.digikabel.hu. [78.131.46.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490428d4d8asm110335325e9.16.2026.05.26.04.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 04:58:33 -0700 (PDT)
From: Miklos Szeredi <mszeredi@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/2] simpe_xattr: fixes for per-sb cache
Date: Tue, 26 May 2026 13:58:28 +0200
Message-ID: <20260526115832.1294821-1-mszeredi@redhat.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6PWf_L2iLCEIeMkUqPVYZjBTatzi34AaAPx-RFtpw7A_1779796714
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5A3B6120008
X-Stat-Signature: uw5sidt4mr1t1gc9ax41frb3c979nxqm
X-HE-Tag: 1779796721-632081
X-HE-Meta: U2FsdGVkX19p9BDJjvCy4tBLbqtLRExCd1+625uqPFxaFCn1MhI3ieAW/Oz9fM26V/4F+cvjqoTVrwTuGPPFOnlFMeJppV9KGi49LB5zG/rrVF7/Dc8QZYVQpl3tuZJ5o1FOBh4hwWqoHwbKPxlLgTzAhf07ip6iSZBm70zctgXeT9hUT5OI4Y4OomiPhUNI9+ohlW6ie/r08P7rMZqQd+nMoAD+wiWxzsvRNsr/jDf+3HN3jch0JnlzlvEiaShgM6cuBY2G+HeLX94dCsAJnBm8BRU0cwYumOT8ThV8CpGw6BTDnjUCaO/00UeU5k/juffNNoaqj76LVROJAH9eoe6WiKwT5C8EdoAfEI/VJSLND/d/4UFQAHMsfhMhtL1Yz/IXJewoygdWLuFXR3SSI0VexoZDKFsJ+Z6hzScUhtcTYTnrT4gsLyav9/4QkqASscAE9AX/c1vwQyPFvFetunGM+0nByMFIDWwI+MEmuJtooza+tYEv7bcYu7R0S/WTVKdn7QUrlXAvqlxwCilqCseVly+2QZpwoLcRjr+HbEyfmb2rSDUwToBQzFp2W8ZdTRdiAAhHnPjFfLmWF+m1aWXCEt64f/NhJjH2AfDi38aSSUmQtQFaEcJYB3/Kyczmg/9E7Qag/n8lE42u4sry8ynBFL5EIleL8YDrEtuTGNgFUlHYpF7phvWgQdHhPKjYM/OI7IFAnaTPlkQmZuaHdX4UlgOoqmUJNWqPCZv28hSEWa5qro8Z1mKXUnJJHykwYVRqCEm+zdgUM8M9Ffy7sQ1i4KN83Am+Wlh8YgT9D24tudQKlq1HtAt7j19A7f1+iWPFA1jU9UyGxNGFfylWorcXZJMLRmlrmddcYYzL/L93pxgMinKuISPx+yEKQ0pdJvTOCe7g/7+43kfc8jtK1Atns85h7wfSXu4QrsbrG5QToKPwYMi4vExLEpRtSpNITo9H650TDL2G2HZu+TW
 glLd5HX5
 b/+nr4qsOzfZ006ZaUVcPvpLL51/VeuiDNkuDg9dPZppT6bhpfhYp6Bluq2Af4fFaGm7cdnO5yS6D2eUfMsCbm3qucO9MoKjOCZkYuJzIguClIKD6aE/KkzBaic8ZNT2qFBdstH0hTBruRIoT8ZXX6chvPGAcJUH3JHzOifcCKgz4pA0+k3zAkh1Qeyz+z2Ji2ypYhbGvtGHz6p/ZumR4YtlBkVD4qc0fmrgOnQiUgZOyd4WNIA1Gz8J3h5CKYHVYVTl/XdqeYS7K8xO1u+tFKSVcmPsJ2WAaU+s4V8R5QPyHpuXYik/1z0LRz4Fzzo2Xr0hijMYFenEZE5Co/Eq/ox/3Ab2kFPJo5hcC0bAFjLRNM6aPVXpakjaht5R8Nj0I+sc/u5XpSbe8nC9/TYj99CbGqvQpiaNInLLJSMlovo74ZpfuyJq3jPh/cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix two issues in commit 12e9e3cd03b5 ("simpe_xattr: use per-sb cache").

Please feel free to fold this (with updated memory use numbers).

---
Miklos Szeredi (2):
  simpe_xattr: fix rcu'd union in struct simple_xattr
  simpe_xattr: fix racing lazy allocation

 fs/xattr.c            | 19 ++++++++++++++-----
 include/linux/xattr.h |  6 ++----
 2 files changed, 16 insertions(+), 9 deletions(-)

-- 
2.54.0


