Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAC9C87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:46:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526056B00B5; Wed,  6 Aug 2025 21:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D62B6B00B6; Wed,  6 Aug 2025 21:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DB66B00B7; Wed,  6 Aug 2025 21:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23E686B00B5
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:45:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB394BB9AE
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:26 +0000 (UTC)
X-FDA: 83748269052.13.B32A048
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3F603A0002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:45:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iN1f8wK4;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531125; a=rsa-sha256;
	cv=none;
	b=hPZTHXOP91VgtFl5EI1V3Dk3ESNZsTdzIS2K2twr7VmCIY64DGlcxcTqi3Srp+S1YfkYmd
	YSAUUf/45z+p/NqD2DNN4m8nLmNOeW0AZooGA0JTdr3c1bSzpuxJalq19YEwAVhh6JQ1oh
	zxnQI3GPr0wdVovMHi48uyTBAmlZhrw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iN1f8wK4;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QA/vUYeCxNkI6poJfbjFNlz5+YRzYcbbQ+LvASsW6yI=;
	b=p9qjJDA5qeOQrhA+o7fFkyptdykmZUvcc4wUYsUqZLyXKpv0yES57o/vR0Hnxh8puW8Eic
	48KqGlwVQTnRJxFR0SF62C9pAKPR5aET2eiCwCNTm2Cd3l8I4VOfYSbXfYwK6sjchuagDw
	4TbamI8LG4X71GHNMo0/hvjjyxEkVjE=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-70739d1f07bso7249126d6.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531124; x=1755135924; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QA/vUYeCxNkI6poJfbjFNlz5+YRzYcbbQ+LvASsW6yI=;
        b=iN1f8wK49nnfDAN6XXGuiVdbZgBXldRPqQW2QGrQQ4DhGMIYO7iPiGgFTV2pK9BgQa
         26reu1Lpk0Tq7+Wz2A1MYKXdw4EQDCOIqCzvD3tStuZF3AFJGkUE9Xqk8crOtzAGvFFH
         xw6g5XfewsH/gDLwSA07SdJvMk3wh+HDaeGhwkr3VzdsTgCGSZ1TaNcrYsKGpyRXSFKQ
         ZEqH97ILUIOYXqK9A6b/1YBV6wEgu8ErMFrevMIFBS58rJ3y+FORkercob3bnj9Ae27t
         7VsD6BjpZOGVeRzOYUl4DkVUg7uw8sPAjDOf4SaMILHZBiL5Af1UfVjjUeR9oAFukkQ5
         y3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531124; x=1755135924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QA/vUYeCxNkI6poJfbjFNlz5+YRzYcbbQ+LvASsW6yI=;
        b=tOojKhcHQKQJhStuga3V6KzPXWVO7/Gsgz7oCpLT0HujGjEdLYyvvNLOOMWkHPA+OE
         drHZ7if6GxWHXtin+G/mYzL2mvlEyKXYWyKNHUBRdDsnW0xR1D3RXzISxf6BupQdcIBo
         Gu9m7a2bnApBIltLDFvHJ8vRPLnPyVdyTzSYJqfUTQoMd+qL4fQdIpvckdfqQhkALur5
         /MRSP3cN4qxCaZaMTbdfO9c1VPJOnk/Ji42IzZ1/+Hnv9JTVPx/6zhNWQ7Sv8ZWjIruQ
         W9PFnq0upHHT3cpeHQuvSb5OAp6meccgPMbGeaZeSfB/F+TcO+7FURTdfHQjprmEAbeH
         wziw==
X-Forwarded-Encrypted: i=1; AJvYcCURKyxfu6mMJb/rq43EZS6PiYXcBrBFTMBifQe20CSjY03eu9GqM3D6veogG6SsF5LVmCfJ9/xc+A==@kvack.org
X-Gm-Message-State: AOJu0YyQsv197U7lCNkFIQCxdsCj78fHInFNIgXjDEECJPtYv250B8JR
	aDA86+yEkq+auysXJl0rNVD71wcyq7yHt11yh5VLBtNaj8FfYpDdok63WIRkNOCLOT4=
X-Gm-Gg: ASbGncvd7h/g3qgaIwvIxOPZJSZs66vnchuyLU1UsFypObEXoQKoQuhnztw3THblFpk
	tJ35GHIKCcoRDx7C50HtEIJemNU9eODI6sl2V5Xce7XLOd37NGhnyI7K7VGrKA+YlizCBk2kbX1
	+XB+EzgTNYRaENCk8lOx6oe9txAkvrMCZqYczt4EVaSvan05B7q0Ezql2MElv9KK9VGF3WdJpfT
	2ZTnahNnKtB4duFEQ0kynXQj7tYDfPfLhD77I2nMLsuYeBTEF5B/UqMdCYr62Mg/0H9dvDvKvr/
	UXvKtO+HwiMeV68alXDilKBFykYmC4oHCg0UnWOhVlpVKDZXxF0BfpDgf/PL+QxLzKzbbicWZY9
	v1NTKuOeamALz1IXnkgA9vTVBYi/l3r0qSoLJHtR8NcwrHttnaNL1I2l6BdbSN+nL3lTtFIO92a
	NQ7B1T1s2xckjM3ztdrnwB8u8=
X-Google-Smtp-Source: AGHT+IEmxyIIEpF/zYXpWh7lst20k+6O+/3teCC6bRoX7mK0ce9gFr80XAlcr6QckhUk2jTkrcE1vA==
X-Received: by 2002:a05:6214:27ea:b0:707:3314:793d with SMTP id 6a1803df08f44-7097969ff73mr76803076d6.37.1754531124250;
        Wed, 06 Aug 2025 18:45:24 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:45:23 -0700 (PDT)
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
Subject: [PATCH v3 25/30] MAINTAINERS: add liveupdate entry
Date: Thu,  7 Aug 2025 01:44:31 +0000
Message-ID: <20250807014442.3829950-26-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F603A0002
X-Stat-Signature: 8ctis6zzn37rw5x6ncgmpaffyzucstzp
X-HE-Tag: 1754531125-914536
X-HE-Meta: U2FsdGVkX19rEnfXyaB+ja9ji7GtcCr2O1K0WAE8++wIIXRulJ8mq2XfLy6ed8UdTP1Uu8nIRaGEL44BW/jphjDd/h2UbDYd/SrIlc6bsy8JRgG/bVIhyQfM30wrvzPr7chZ4u3kcdn4i+Lp4niKGUEbgOTmwHu3LjvcGCVdlSYvedMjZYuPWB1JykvPKyrt2D5Ww7Rb7jXsS0SngYIMS8Uq5nwX0yoikM01y9qRjdQKZDeB1Bg+VuxzQ79iR9XYj2n1emt2rbeoZnXH2iyTXzyiZRKz1OTrHtj9ZnW/aRDf5ZSAmoPUFkCbCm9pII+hY7iKRIDDcOiuXbI1c7eEeWHiY3oeRZh3VRhmdQBttsc9z/3bwLCID5piTDnILN9jHXSxYJVC2IJ21X3YD19IdtP25fCmKIie7vWgQRBULuvSpwwIHuq/ZCN5C8ZOmhXv4v0ZHu3OVRwWmdbUbwA7f7oSb2mN60VCJBREuWT4i/n8BHjuWNBLQBCKO8f28a4NteGpMw50FHEozGeKn0zdshZgfEYWuchZfg6Zj2DK08D/VKcZztZYbdMS31KNZ4mGUi89u8OYgmTCYu2dbEPMiMHn6ag5huQYXFzWQPKYmNC6jj5hRZ1lsUr3dSvotSimdaE5OCsHYIVNWwe6HF4AFcYjjAvViKc5jKYRulyefQ0BSj9LthgFulIfe8CfRanDpQgHiPXXdgx+AyDxLGdAZHu+Nx30b+ohVI+77Bh4soQXv/sLpmmUSJiO8rCC3XoKfSqIcqQb1fPpwbCohCYm9dCTb8qCK0tCBSG3Um0tBZCs1eI0dqyfOAsJyM0JAT7frSKldYKX1knUqdQ9X3QNjP4IGnOcTjr9DyUAQEuAalnGXZh+rRJDJ2PZi1D/cRos2mlm8dhPCCbmHPxUCPwdyRgykM3kjcdno3NxceHk6fI1TR5jZGvSO8HY7Lgb4TxzdFRbauldEoYj1ED5SjE
 jUcanOD8
 gA7+ItHEuipyEY0rFUnO/NTlHRY3n26k+hqmgHD00MNLRBrnFqhK8cPscndfbrwD34IrAwHQQzmK4jWo+2XG3wL5ypGvqptCXoYrTVmqRNZjluOBCELP+ob5NddkZKWB7CIU/YiXf0GHWX/OjR19AZoCX4LDuCNl92106G0/XEsLcNVBS74M8w/ums/t4gm+lvf+sfvWkqI+DlYH/I96zaofEi4D+a9qTIrGsKxS7Uo6hFA5PnrSsq0PUog2jSuFusfJHxm/OV/gCEPH9bh+HyQ/XEIYBrBJeglGhWJrQ0+ObEdORuw6KDGVA+VLTvR8aUOygFaqvUrw7USs7GRohU1jDFB70NKj79X4pOhDvdtcErLkagatKYyJgHacgFMZZnN4tedgx7IbubRZjzj8sWbwPhr8shIJ/5TZ/gSoxo8JN9P7of+LZno+gvBAzHykJO1q4zghYqIj0694=
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
index 35cf4f95ed46..b88b77977649 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14207,6 +14207,19 @@ F:	kernel/module/livepatch.c
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
2.50.1.565.gc32cd1483b-goog


