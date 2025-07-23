Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FABDC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AD7C6B00B2; Wed, 23 Jul 2025 10:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010BD6B00B4; Wed, 23 Jul 2025 10:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC186B00F1; Wed, 23 Jul 2025 10:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C6E606B00B2
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D86E5AD14
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:01 +0000 (UTC)
X-FDA: 83695806642.21.7DB8B53
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id ACEC040007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:46:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=sJZdLFxZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282019; a=rsa-sha256;
	cv=none;
	b=e9TfIYxn1L5hhlepFMCCJZSpBdkmJOU79PAQ1E0IGWvMjQRkkDKVU23L/k1GHr5Sm5nF66
	ydZLC8/mEZXVcfHAkp8ht8Mpf2j44Zi3qreo/m99N7x84NlAumxwdmu7UGJOJ5JlxKpvaz
	tL/s/Y92FOl3pyWE9gdx92FJN4dHU1g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=sJZdLFxZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf01.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7cl1P/nffEHtPrwqwqBj2n/TmbnAXjnzD/OU22eOOo=;
	b=Qohd2Nttzok/s3zFR3R3Y+VvuxF82Kf9qkM15yKuM1NbSh5dIay0hNmqhaUu90Z5Vvkwzw
	Yr3dqblK76PKPaHNt73TbW4hU0NQdkMYxYfi22P/z3OwpQg9/W/E9HgEhmlVbcGHE5WENn
	nhjxNuGefO+pldhZXvJ9wFNEaHjZwA4=
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e8db917573dso1905877276.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282019; x=1753886819; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n7cl1P/nffEHtPrwqwqBj2n/TmbnAXjnzD/OU22eOOo=;
        b=sJZdLFxZLeG6NiAeii7u+mqb/1H1an7LPENmcpXh3kh94YhX7RharW9yuyefPUMBom
         9LvMCGqaTonpMqo2njg9cKb7+lj4O5zHcW7hjxM+3QDJGB+lUoiUmreT+vQNIYlhIgee
         EiAqCLEVXwtTb21p+6EFsUknuOZj5sVBCjDxJHO+jxV0EKOwVLA2C/z0we0ndZHwPerj
         kWU9rRVJ64fUF56kuORy81PTkNanI4044JT9qwo9zA27kY28TrmZyHdBIjd8Buas6di5
         lpfSGHFgbVxnh6zE2N2W/obBBELbtYnbZT9BSADi1atF4kcKWpgf5IGKUTWnUYz41S2L
         Rwuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282019; x=1753886819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7cl1P/nffEHtPrwqwqBj2n/TmbnAXjnzD/OU22eOOo=;
        b=J14cxGVkpLqZsD4b7V9UhSd/2HJlTpP1BiUOq+gd+i5a9EY61VHLd+agTCKoTqzhhb
         /ZrJseCmGBS3Sqcf97Nu7UdCz/axK42GMaiEKYWoYDfLJeCw7ieTdgT71Coxqv1baZdt
         4XAmvyfKa9v48rB8aFyQ5T/529fJM9L5fswEfCmf4rFj58Cz0dS+g2ozimbS1yOsShPe
         aRJIL1OJmjw8dNprP8zet5ta00T4e6IIgHWbK7K8DSy+kTTGWbbLYQLD5DuL1O14FNN7
         gCpdGb4Xj+Z5W4sEOsIHUo6MHyvIueBb/qDkjZzUF2GnE0SMzu8OKPAQ+QlqOFYLvUc6
         IuUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyektWmEKA0XN1mUnffRuMxS8x/4oiwNlcjBJcqmrc7yYt+o3AaD7+RxmM1elqpX8tBmUhg2Nqvw==@kvack.org
X-Gm-Message-State: AOJu0Yyoqo84esGsrGliDiqz+RyH9FZXMY019deWmg8qgNzo19EmqCWa
	bD4n8zgBBV9VhrpXUKAmZNi3cjkZq26OtUUPr5XXhLgchGMG4Swspm3xYACTdD00etw=
X-Gm-Gg: ASbGncu+WbNh8G46LAbS/lcIWp88L2oxvjdWXep/JNIQG+E3bmAv5PCuKTQZZiQ1cWm
	H6kcGm1DQWwY+N74YA8aOdzCZd8RXZ5q+O+ohwYSZVz7Hlv1ZTBCaQXmFXfCl/vis9LqyaP8mUD
	Gm9FqZFGc+kibugxhWAvjk4uFPmdRtONzlI4xYUW6PCT0IRYq2U6vISyYVZfpPPcqx/1fXFzzBX
	9DdL1xaAIFumif5hx9GkP5ko3hFGCLgw8iS3sz5ZsoPdc593TQoC79Ry1jlfg/422B5GJfDKzxF
	by/MHHmWPGGbP8ORchc1ljfEQLTnR65y958KUnjXRQw87P4VozzsStnMLM+Z/sAB2Q3ZUhA3dYv
	opyE94Nog+Kg0Fea93OlwEu0X+s4tyB1UPwk+gqc9Z8+YDfET9+/DgAWS63g4qJ+E/H/aBWtW7/
	CX1eZoV9B2QA6h0w==
X-Google-Smtp-Source: AGHT+IE6ehQOayyo1lb2cZBdo6W6rK2fNueePB1JRBmEV6kcBUnmTmWNn0MIzxo8F5fZ2uNGvf14yw==
X-Received: by 2002:a05:690c:490b:b0:719:4c68:a6f8 with SMTP id 00721157ae682-719b4258512mr43723377b3.32.1753282018494;
        Wed, 23 Jul 2025 07:46:58 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:46:57 -0700 (PDT)
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
Subject: [PATCH v2 02/32] kho: mm: Don't allow deferred struct page with KHO
Date: Wed, 23 Jul 2025 14:46:15 +0000
Message-ID: <20250723144649.1696299-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ACEC040007
X-Stat-Signature: canh4id5ywuxa98c7oue9dsxcd3wpt65
X-HE-Tag: 1753282019-460668
X-HE-Meta: U2FsdGVkX1/G/V5g4fW47C/msNYWXm0eBDNRDviONb+KgMWjpP8vWOXIm8DM4dZ1fEo0RMbE/6hMG1R3W/Aypqo3C3tzun9u/+EsX6ghyt07a64YszSYuwW7kDGghIXOusdYYEeqWB1ZVjH1F1BAg08kZJI//udEdlcQuPz2LQ34tkKPPzTEh1Y6JAGfjC/HbQZY73p0Nk8h14oa6inpcYWV89wyHeKYRwXmoHqOABgoUfsU6jHR0qpY7AnG70XEM34RKGBfPB+MCAtzhQpSbcONqJU04aurCvqrgNeko0H1796hvJ7uJUe3hTVc3N2ha/anLB1FPQQmZA2jIH0bFYdHNEtTvsgOl4hzX3OfWFRnZFLnzqhdxtujYQj9B7Uga4ti0cWPFlp7zVEzDZjD1BU2I0zM88ID02wHxBCpIrSIbbJYoEEM0x1YcFwPK6DsKZzQnKIqIX6pnhTI45xFIpHPubekGaxIzt+8W7sLfbTz0bBJakGtp8bhIVtrqDi5iClEZEWFOjXTFIhju1WW00mSbwK1yyQuwq56I2WEYVkbGD5S7YLG9vsR6Q+EqX4F7kh9nkfFJ/YkxT/8jY7+T0DGPSon+rbxL9/S2kA4dY207ypPQDhtngwZ9qQLalp+T4rE0xDOdeRdDoKC8+lNdasxLDQCw+dL9vTAY+VJAnCdKTiHIi4VCoF+eyh90dVYw1FQDJOcoMXoEufKRiVozwlOg38DqHbzdJKuJW9LL6P+sMVt0i6cjEvE+/3YL9GCQ5INXZlDzW+tjEMaHycrG9p4cAE96slHTcF004OlJTPNdPXY+9Ks62o3NDlNzGiCBqGB6JGl5D1WV5HUDnikkoyNWS7xdGW9N8PLyY8cy9ajPpcNvA5BSZwv70ngac7EAPqaWr8BBdoTJWdLe8hazLGnA7YyFPePKuGhPwWxH1yu5EBfN+22qP8k4DOlA+21Q3gN8P0ug2eTW/+su6G
 cR7DAAzs
 91aoZMNszHvXQshEZlx2HSAUpqgjvrJfK4t1xBfB31JQYQd2QLZ45blKGV/8G1cjW/NQvHcQNWBJ4f4K+JN5UZbPj/2+bh0V/89luSzpnlF1ftB6+RYfl2O0D8KQWj7pyoU10JL/UcTRXcGsPkqCZmTX2jLoyzsTp0OJIpnzbrtTeau5epUyQzxQGY3Z21NWA9VRqPFXoD//KEpyB6e2wBkQHeQnqPB/fH+gFBNh+lUuOkWXFuoPlq019hV+loRyq8UVjanyQGqQRbl3cK8pNhi2CBmonl8WpgDI7qo7h2gX3Xg2m8y3JHQpIP3bS4xi3jtevNJLa0vzcxiPgVwBSsGwqP/iOEWuxWnj5G1e1ZfLCfJjMgyDuVIGcXwfMTon8AGTCc05jO/KSuQTcGJxFQVsiMMi4YrUeOsTdTzjaPYZrDZ5MwIALzhf6EifUOKMEXvidnWBAHMU363WtA6A2BeCuk0NzEt07MeO56W+3OJvzVLrfm5JsnqCiNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO uses struct pages for the preserved memory early in boot, however,
with deferred struct page initialization, only a small portion of
memory has properly initialized struct pages.

This problem was detected where vmemmap is poisoned, and illegal flag
combinations are detected.

Don't allow them to be enabled together, and later we will have to
teach KHO to work properly with deferred struct page init kernel
feature.

Fixes: 990a950fe8fd ("kexec: add config option for KHO")

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/Kconfig.kexec | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 2ee603a98813..1224dd937df0 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -97,6 +97,7 @@ config KEXEC_JUMP
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
+	depends on !DEFERRED_STRUCT_PAGE_INIT
 	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select DEBUG_FS
-- 
2.50.0.727.gbf7dc18ff4-goog


