Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6807AC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8EC6B012A; Wed, 23 Jul 2025 10:47:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98306B012B; Wed, 23 Jul 2025 10:47:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939CF6B012C; Wed, 23 Jul 2025 10:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFFC6B012A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48FC2160699
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:46 +0000 (UTC)
X-FDA: 83695808532.05.3E7DB26
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 75C96100005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=DsXOahKN;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vA7LYlc82x3WwgY57zmotOihPt8s/pKmtJ2MhRkxfkk=;
	b=KDs3Ps1h/nttjMuAhuXE8F5lhnL8ahIsfi/8Obv/51pyNYMml6dnB6uQOLxajQu80UJA+J
	DWTEq4KuAxxsrwMkdGSCL1WIplr6fvhHdTmbYk38OPvm/CdBCFksmglUDqTO1jXjaa5noS
	1iJVjT50q/Lt3wSWyO0b4S14/zhSyQI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282064; a=rsa-sha256;
	cv=none;
	b=ZVjd8S5kxZNlN6PGV/Jx2c7slua373xMvbq6aYxl+Y4E3l8iFKmHXPZbp864R/siMcg6XK
	YclLpWq5o+sAPEgQ0w92t4P8FQegGEGpNA4MS0zFdJ+fYWCAmK11M+Zti7JJ1rW1O8uE+2
	L5Qnsk4bUHcKBvz6k+0/DfS20s9ll9Y=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=DsXOahKN;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-71840959355so25947b3.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282063; x=1753886863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vA7LYlc82x3WwgY57zmotOihPt8s/pKmtJ2MhRkxfkk=;
        b=DsXOahKNej+wUKIFWmlZsmwMlJVHfhT4i8eseb5mN+vqlcwjGfGsiBNAjJNTkt3zJZ
         uwEYvMT4Ow7gZMf4apLz+aVsmdHkoFwP2Pyuv3+ywkwLujz5iRkM6Rq8cTSnEO0RxyHH
         jjuM9H0Y4uft8ZOkr1vUF7IySPkUirrF9P3RYgnKcIKk0ktBp+CR9KnkqyF0fYrWOzr0
         iVRWEi7rYWX2e6jSdFt3EfbNVw+0/t7T0dwqbw4d/eAJoB03LZbKbUoLpxzwKwl9Y9gV
         0nXnt8IDLlYk7aH5xFkXrivoqwy3BJayJ97ULbwZ+ZEMANik2nXKnnbN1KiBtbGhTxwM
         udUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282063; x=1753886863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vA7LYlc82x3WwgY57zmotOihPt8s/pKmtJ2MhRkxfkk=;
        b=gEkHf69idfXq97M9IQt+/VUflEdhsmgXpyga0p8fQ2K7zN/RJEj2dYqPgSN0pjDd54
         vtGmdHQXYjQmHe0h7gHdTwpLBEndFLA9HHyrNdxl5QxVpjKGFuqFcxd6rep74or+HB6x
         Nu8MiLeQa0CEywlGfisn1MZb/2XomUHnROzNYALbgOjYWOmNrUqdaUOWi3N26DC6cwDP
         cKsRVd8NadN2Mx7bXjK58918aSHmeT4HBfh6IKaIbj5yShEHb3tpGLQSjYPPJBSjbRM0
         8JpztN4bWD8Lq1FOzTlVkI2za5k3R28PBZZa5KJXlv5R5LiTkIVwb/un9YLJH9e7MWSd
         Lw3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXOdeDWdS0YQvopzJq2VEybPm7JMHPxkhKP8PVhXwMqBaSzKvA8qX7P//9E7rsIUwy7Vef4Gmu7Ww==@kvack.org
X-Gm-Message-State: AOJu0YzG9ITIWD8ls8N+dQuqNpFVZ1pk39X/Gj6msXNJgXaCymRcU6yh
	2D+lBRfAcpOP7tVwHmKLEJ+vwZORMdaY5mcgUN3y3EER8tn6vWrDtVFljqPXuJvH4I4=
X-Gm-Gg: ASbGnctgDWQemVK3eRS8pZyGwwiYpA8g1vzcxdwtiw+h6bxeikqQ0yOvqIfWBw4/Hnw
	ORqieDDojV0fpgChrxa4IGe9nB+GNcA1t2LO2jHgbY01JAnHkiVWb/BDFXV1Ia2viWg2CW6n9NF
	HS5wlNSPSVVqXaf6vmfj3B2zLPRQ4/dlnLwjuNrz397k90h9XXUzGEqOgtWrJzWuxr0g9KG0dv2
	JcDCqkIaRIE2LsoeXOTZ+iKRdLLr4F84XdSYmKaGwFRK9Q19ZcrGI+C+X+WqkJxnDLiLquutIXd
	sSlXBt9L5AWLcCtdrbqzpsjn06BKXtSYkCH7UiW5jaaKUpPj4JUouluAo728iO3Of+Xf0arKQW0
	YvmHe7ue4nmzMYa+ZlATiqsxRFXzBX67FgE6HryZmr1MtD8a2D+rh2XOU/uJgUMcqqXzj8PSoEf
	vNEYn1Z/Lg7HpFfw==
X-Google-Smtp-Source: AGHT+IHqS70M03S5he3NvWDhoQuPFBoBKoEYJVBTcn9mZuJ/zrlY+6jXwnz4jOOosBMr5/pOQwUPow==
X-Received: by 2002:a05:690c:480b:b0:719:4c68:a713 with SMTP id 00721157ae682-719b4b26117mr35918287b3.2.1753282063460;
        Wed, 23 Jul 2025 07:47:43 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:42 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v2 24/32] MAINTAINERS: add liveupdate entry
Date: Wed, 23 Jul 2025 14:46:37 +0000
Message-ID: <20250723144649.1696299-25-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 75C96100005
X-Stat-Signature: 4xnrumfn4hn9skmekeuuaxsxxfz437dr
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753282064-16844
X-HE-Meta: U2FsdGVkX197zJWtwDvBbOUAEQppEy1EAk+PewRpitVT1k1K1lHAYiBqXY0Oe3LRKedjxT3guehHzLkRfieC+PaE4xPxSexiVRKjtehSTI98GidGOJLHo6LMTGMukINiNnCbcjR4mA54ib5bIm3DcJ2/plcHbCYX4NkB7Wh3jyEwKnQPgDHRduKaGQDvY/uGgxroT21MjNqGybnV6tkSJbl2DUxNcxAZ5oxveiQ5F0nClp6+DQspmRyiI2wFTGLOH32XzljRrXwtqfSDUrG8h2ApA7PBjiiXS3I1nNqX9bd+SSt4pk3WZfP0YhpVXPJDIbOU0wxQJXbT9UPQCuTH4stGJJsvqTMlAYiNxtgFCtBqU00btH4Pwy0yl0sHkMGmnG97j5caEgU578HPvX5UymzwrJRUaWXm2LApQfS+Zt6zmkz1vA0aPSzAmJ4wxkdBoF3lVGlpPfZKB80dh76DWZ1ctoqXKkwAKfQjbL3uRWKX2CXr2B3+RO3wAkMegRrzLTJ8lUDq72oybRxpH+BgwYWNMWyXR8uLZpeYCdZmrggXsP1oyA6d6NCstOOk6GljmxFDwhZqaWibCFVZYpw7lzj8OIv++tI+IFrMAir41HmiZYKnFt/aD4LkkbV8Bxkfb6pGgUmLE3jkeI0N5hXWQf62YZNlw3lCLWmRcWj61y/x4y8EX8RH03Z4Jjlk+6FYLZ5gsXgkiT6JEWPQ4uZ+dnqzuft0RtgMGog1Adj5I2TP8seK9W1oxPkoW/bZVZLHw1pZ+nxEvuEDo8FPBDX8oZXcuuGfzyOY5QqwOiDapkV7swRktOQ9vL3UZw2Jafu409KKrQuK4F/hqsd9Ua6g8RZqnlPUocpPkHh7CzZ1QW3BlXzscYpezL6Rdca+qg1OTvMVCLQN499Xsb2o0QEnTawIgL6RFe0mVjOy4xziusEWz1lsisUbE81kDkncpE0y6x4dLVKMbX1jh+inwfa
 UBz6vm+0
 wi8IfyDdSiFuWZ7ru7AjxFabw2eQ43CH1OED7CQrlriutQxLFVGKtMNeqJjHgTrCYDZuG5b4bESz36wRmhRqrQZxizt1QNtK51Qj1ZhNMm13gn09992QWq83D4WxNBi5XlMq/n2KKOgq2pbMcYlas9luzR9oMaNRgqT6wVvUBjZsZapnJ8VHE3+Y1v9I5OLQNVbCFvX7e4NfZdHFs6XV5tOBkL+GVwGNstC+eWi/woXJRWqEu/bhDNWqwXRkmlaU1RoTFtWIFNCbMMmZukr6LNlF9dRZO1X1tpFGQ9LQflYQaf8M/rLlqDfC+op9Ar2GiO3a7qV6HNE+se3acL8/Y2+rkGFJEO353/4kJizAU0ePdz+jS0b6JnLsJCjrZd0Z7Chd+8WWJuVV5c+pLAndd+Lk0/Pu7rIypvXk7ztqmc9adc4jSw72oTNdxizN+5tW2YXVQQPdDeCaDidOWpP8ChWlLnSIsN4OE56VkdYwYB021uii58CygDYWmbzBC7KzJuqhKidHIHO/5Bh8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a MAINTAINERS file entry for the new Live Update Orchestrator
introduced in previous patches.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 MAINTAINERS | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b276cfeb038..711cf25d283d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14012,6 +14012,19 @@ F:	kernel/module/livepatch.c
 F:	samples/livepatch/
 F:	tools/testing/selftests/livepatch/
 
+LIVE UPDATE
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/ABI/testing/sysfs-kernel-liveupdate
+F:	Documentation/admin-guide/liveupdate.rst
+F:	Documentation/core-api/liveupdate.rst
+F:	Documentation/userspace-api/liveupdate.rst
+F:	include/linux/liveupdate.h
+F:	include/uapi/linux/liveupdate.h
+F:	kernel/liveupdate/
+F:	tools/testing/selftests/liveupdate/
+
 LLC (802.2)
 L:	netdev@vger.kernel.org
 S:	Odd fixes
-- 
2.50.0.727.gbf7dc18ff4-goog


