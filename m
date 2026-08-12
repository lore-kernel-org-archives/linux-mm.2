Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7CACC5B567
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 06:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8806B0088; Wed, 12 Aug 2026 02:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8FA6B008A; Wed, 12 Aug 2026 02:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498276B0092; Wed, 12 Aug 2026 02:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F10A6B0088
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 02:59:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8DC8F1602E1
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:26 +0000 (UTC)
X-FDA: 85091716332.29.07EE5D5
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id D2D01A000E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:59:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j4ssQwCp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786517964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jYLC+//as5WkDB9Cfqs3UoupJV7njGedAREDeXd0kB8=;
	b=aV1HFC+joXxCJmxAtn+/nzLpObFtclYS4BF4yQkloDF6wiKSO6uI2qqKiJjX7bs15PNWo+
	XUHWau+McpAtw9go7zw9hehs+Shac8wSJjvnh8SC3hvHIJn1LpFfCnzZJ8gQX26sgw/z5U
	dYKmiKbpXKaksPZVf/YRWWxr50LkAiY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j4ssQwCp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of doehyunbaek@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=doehyunbaek@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786517964;
	b=oOwgN+gMZphT9nTRrTYWQBhYNDc9blQDi8u9/y3Z468VHqg3g6RrBaKJsVNvFlQVrIDVeP
	eaDLSGReQ35LTEJOUWfx95/Lfh3/AFodj+iWL7yk3Dakj1EmtrRtfOMJ7oYxJqUi8wGF2E
	r30bmpP7LRTFHpfTDJ7g3lZXy1VuLfg=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4994d41ceb9so176915e9.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786517963; x=1787122763; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jYLC+//as5WkDB9Cfqs3UoupJV7njGedAREDeXd0kB8=;
        b=j4ssQwCpeEbwlUJ8SHna1EmMxRVfFFBiUnEEc2WeVcu0LvLISRpZbaalLfayNQQQHt
         BmLWqxFgWzFJCpS/gUuLarWB4UnB1dIx3Lqs+HQPGwXrxxDTXjMptBEI0B3Rqi32qMUn
         pdPX0ARyAQyqFxPpNfbSdnJrA2dkaIqlKB7Ezs8VifxxV4T5wzqZ4QJ1T2IvtZMjzCYx
         frZ94JkqtzXTNwyKnRmR4mOzehaVoGRTFeTUqcWTks79FwAGUmuAFkcU2ULJDb6/T8kr
         CAVkJm/KuSVeIqNDGuZiYwi0jKIEnY/Ek6pf8B7rHPXzGHF5alQLyRuxLiyY2LY3SkKF
         RGTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786517963; x=1787122763;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jYLC+//as5WkDB9Cfqs3UoupJV7njGedAREDeXd0kB8=;
        b=Cu+kFU6gO9HXmKMu01bFFaBSmcZkwEykalCd9lWhjlt6I1CaaIVPdknT7Vf6nvycVN
         NDSwYcFUiPcaGkzW8/UFl9v998yxz3SV5y1jYOCx+tOxM1Dg55zrbVnwgrO/4oAPNd+2
         EU0KS34LHeDKlFco2Sf/0SVTBWxEEqmY39Zz/BloBMfYFdnr/wXnV7DcWeLWXNizTdW1
         9vaaVEIGcqcIvHUCNmazLnt290c+irq/FhI4bRsHhlz/lGMBc425I9ej/wwXjRycoVdf
         8GFCPsTvG2ncE7Xr7lNsFAe3LEQYspzh/MKQ0w9DoONm2lTWVnsbZBCW1Pom65dX9gts
         +gaQ==
X-Forwarded-Encrypted: i=1; AHgh+RrTgZb76X9wJAfXy60LL7hMqYhJTXFMiq6DM16RlWwiMbhWZxLtsVs+4Jvem9z7JJ5dxCe4sTtH5g==@kvack.org
X-Gm-Message-State: AOJu0YwEendcFLS5UEmVJ0sAGsHRgkNKgOGrF/V3QBfQHx2gDLqb/dOc
	NXmisC4KRGkTvietKXNcu91hAivEqIE0MYXPlpT16nLRCdjaoqr5K2kJ
X-Gm-Gg: AR+sD129S5vDFYVdcIz7VM9oj8zVSJrguT8fkdl+ajjal2I2XcAPxP1eaJu2L1khNUy
	NJmV58A+KpP7sTVq306sLYIe86+8DNUmE0VQ2UKIRpykXP+MUGdJAcxfDN/+2KTHSVHkHScA1PJ
	dvLrSVwewuY5ARpHFTX8B5HTYhMP0o01AfQWl3jgxC+SCCoL8DGwrEFJVZqQBfQ5iIYU+sWxnzS
	oJEPYkMNa50W7Fu+a+W3uFBxM1DmSjE4dCQPzWSb1et0mP9gEBJx/G30NkA9sg1gZLOSotR/0R7
	89usURXBzsmKVPZFNNlrgbN+ATthxh3igG2I5ykTnAn+2zy26dZcg5uoE6R8NomK132oJazE5nk
	Y8smMo0gVjPNxZgU1lq6lvu+3VRk+yFKcQMW0RjyqWyWifcZjM2FVQt7YB4OkgulD617YeelRTG
	Hd/RNEW9+77TDqK8PC8VTZtqxyr7Y1Qgk8i+qBptWNip9lmNFLh6dVJ1MFOgF/TNPoUYPxVFIgL
	NUSyEhD0utYBMI/gbM+KBgFcr7EaX1BXaxVur1BFIoe+uGp4izb3Yk2Ld9l8bHmkdkqoKvouLb7
	uPj+3JBtL6VwsR7DI9EnaYlfmuWc8ANvhX9IpahKL9rx4g==
X-Received: by 2002:a05:600c:1f82:b0:496:bbce:ef with SMTP id 5b1f17b1804b1-4997c15bc31mr16199015e9.3.1786517963083;
        Tue, 11 Aug 2026 23:59:23 -0700 (PDT)
Received: from doehyun-dev.pradel.rg.cispa.de (x06.xlate.fw.cispa.de. [195.37.157.6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997b15b807sm73628005e9.7.2026.08.11.23.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 23:59:22 -0700 (PDT)
From: Doehyun Baek <doehyunbaek@gmail.com>
To: Alex Shi <alexs@kernel.org>,
	Yanteng Si <si.yanteng@linux.dev>
Cc: Doehyun Baek <doehyunbaek@gmail.com>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/7] docs/zh_CN: update DAMON documentation translation
Date: Wed, 12 Aug 2026 06:59:04 +0000
Message-ID: <20260812065914.3071433-1-doehyunbaek@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d8xejzk7bz7krjdbzn78cup4cyucnn5n
X-Rspamd-Queue-Id: D2D01A000E
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786517964-427735
X-HE-Meta: U2FsdGVkX19mcPpvo51ovdsFo6nCN8Dd3l8Dl4PCN3yYI+trfIfqNtcunYcyYuTTB223M0M7JuCucvjyBC9YBif8xIGd7wDagBaZHr8NSFa63kp7yc7iK46K47ogOYMUrLYGs+dllwhLtg05SVT/ECo1lByiXCZeq0t9b6I+hrGEKtibGt0UncB2vsVj4YPpE4hX5obU92w8Z30dvzY/SSo9JXPvXCmTmJcjgexlOvk1ljK0do/WAocgj51nE/F+E+SU7DQLbXzI+LeWoNeWAcckVKQsy/AKGU6GfD3/hJqcgiPKiPFsAtWhNoEkqRpLEIlzY/YVamSkPIhlzZ7n4DwPUYOw4fxHft/PeZvy8TnvofrlqOOJH8iqHkk4AQNbi1UAw6wIcubA2WopMl+8VWIDoenL4WtWB1ShLIJT0YiLw7oXXWjTjMZzxvueYcH3MFyjtB80RWOgoD7tJAGkYIgXhWwG6Xm4IY4Io6MgWfKNA0rCrgXVe8Xp7NQi/TfxhOgyl5VbQQKbtRgaNxWx8oci43HKWh4orECjX4WWMQAodU4Hiw2lY7elcP1bkyvPMk2EMSgHBEcO1X0wyPymYPsOz7TU1Xqj9RKqlLB/S08quedJkR15O4fgqTLdkRv4sJBV8W9N9tQRSC+3vEbbSZNvXvterIhSxFITurcLyuW9m+m0482eF4BLBLaaW7AfuxESq6Q29zkBUewL+JIYTC4fd1Dtbx0ssZcwZquXew6XnJtlkJ4lN4JBXomttXHc2tloWLjN8+UGPB6SUeo2LFAlMeZuHejO0fkCIvkUZnH2DbYBvK0nBzBItqSrPUbS2+oPTCli3fiSWANLWHqnmCJn88mHJ+nA+Eni2UIMklFp3u1xylPxg9IxnQ/vAu5BFmxdpIHj6GEYT5a+5tlmWrIIrXNZFC5QOqYNUm0/zJ/ru7zHHq1BB0ni8MNdInl2XcvyzLFqFlVR6lSRboE
 OvG7osa3
 bOdxB2CYdSZOtGsuyMyCJuI8dO7TQzUH9M4ynjoDjGY5VR3a++W5BWr58YOmCt3h53HLzUjQE4d2ZK/g+6HVzpIo3F95QSU0mB/AHcdWCxVxXSmrTzO26YLnCH58tyc0xoa2Y6FcAs8QZFDLXS75nXbdhbTh9t7FvTPNfWasbFDr6hvFpphwb44ggErmu8FZwzrmQf2JuCTAGJElqA7uqi+X8ZKFaILVH+SJz0TX5Sl6W2/z45q1P0JGP9/VxHPYc37YzAY3/tAn9FVKJm0spoHwNJV329zdjexz/BiqlXMeqzZE1R6uY4G4Pv3ymW7nuV8m8wNXzU2uw3pRxaioW/6KVSj7u3LyifODAymuA1ayQrLbxUZEbM0uG9rQZ5FIUL1+VhmjoIxZy0Jblopl1fl4x/zO7NKGdmsf+w5/n+1whl1F2nc/yxzYARy/Hu9Sz+SOWc2IuvczJ8+mHyOYsfgzDC+zg8gTrneLu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bring the Chinese DAMON documentation translations up to date.  Update the
DAMON design and administration-guide translations, and add the DAMON_STAT
usage translation.

Changes from v6:
- Clarify the DAMOS quota goal descriptions for the optional ``nid`` and
  ``path`` parameters.
- Improve the translation of "offload" and fix the duplicated character in
  the non-access-pattern filter description.
- Consistently translate "tracepoint" as "跟踪点" throughout the series.
- Consistently use "监测上下文" and "聚集间隔" for DAMON terms.

The changes were suggested and clarified by Dongliang Mu.

Doehyun Baek (7):
  docs/zh_CN: update DAMON design translation
  docs/zh_CN: add DAMON_STAT usage translation
  docs/zh_CN: update DAMON index translation
  docs/zh_CN: update DAMON start translation
  docs/zh_CN: update DAMON usage translation
  docs/zh_CN: update DAMON reclaim translation
  docs/zh_CN: update DAMON LRU sort translation

 .../zh_CN/admin-guide/mm/damon/index.rst      |  15 +-
 .../zh_CN/admin-guide/mm/damon/lru_sort.rst   |  68 +-
 .../zh_CN/admin-guide/mm/damon/reclaim.rst    |  82 ++-
 .../zh_CN/admin-guide/mm/damon/start.rst      |  63 +-
 .../zh_CN/admin-guide/mm/damon/stat.rst       |  94 +++
 .../zh_CN/admin-guide/mm/damon/usage.rst      | 523 +++++++++++---
 .../translations/zh_CN/mm/damon/design.rst    | 667 +++++++++++++++++-
 7 files changed, 1346 insertions(+), 166 deletions(-)
 create mode 100644 Documentation/translations/zh_CN/admin-guide/mm/damon/stat.rst


base-commit: db6ed2a3d31068ca5577466591b2521dee0508ca
-- 
2.43.0


