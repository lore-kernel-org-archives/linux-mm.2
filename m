Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6ED8CAC5BC
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22CD48E001C; Sun, 28 Sep 2025 21:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6248E0006; Sun, 28 Sep 2025 21:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87DD8E001C; Sun, 28 Sep 2025 21:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD3C08E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A4B2D1A0211
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:44 +0000 (UTC)
X-FDA: 83940492888.05.C3ECF26
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id DB1D14000E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SuqhmLjT;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7EcpRB2lXFP1cLCapL56dmZqGYeN55I/l6E6y0w+Pw=;
	b=xI+s7VhVMmwC9A/iO4Teqho7/Z/Bq/uBGvr6/SX50GFi7nEWYLQvyHbBTsWlIXsaquq1iQ
	Reo5SSTEwv01vluZ0oipYYGpNna95YP8QQh2Pdvv+d83iKQ784MFFqC8zvlkleBsXJSbXw
	HLVPDQDKWU6waHVn6y/JQgm2qX56iPQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107882; a=rsa-sha256;
	cv=none;
	b=ZQstGAtmkUdiUi4U5ckUAQXHN7GdciXTogeNAvdfb+3c/yqdSWjDlsNtAuCna55/e1EDe1
	kupp9qakeWP3YRmgSTDCzMHAkjrLQDFtaxl9qDUgOuj8Gsxmk/CDDpi4G6l/DAb36hDt4Y
	k1LzvE0qLB92FsASw1I0BIkZFSuQBB0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SuqhmLjT;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-85d5cd6fe9fso293012685a.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107882; x=1759712682; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g7EcpRB2lXFP1cLCapL56dmZqGYeN55I/l6E6y0w+Pw=;
        b=SuqhmLjTrc1HkxyaQgMpCWQS6K5FG8PU0eFYv9lYUxCR86+ysruFAHQ/uHB4qKO3gv
         nX90hcCgHeAjHqcjaedkzj46DExXKmchDlRhERKtnTJq1AHl2jz7ofdlSgcs99p4sR1U
         vQCYVRhZ9qSlGuDlMPxgmt6o8r6fs5OrQc1vxhhjxqA/+479Qhia7/vZ1vD1SKJ6Ainz
         v86ex0qe1VmgvcOVhpfxIJnBBsIl/djx1X4WB//LoEkj7Y/AQMvLzHboBkTGJFylXqMp
         1SxmavrcKNoyjKmkSTlixNlJXK032Z6p+Y2oEw8M/sHqn8ejhjxDVr0neDmCGP0aYwvh
         zdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107882; x=1759712682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g7EcpRB2lXFP1cLCapL56dmZqGYeN55I/l6E6y0w+Pw=;
        b=OoHnMJIobR9RtXcvL1IQVpa3BT4tdz/3a9yBU/MlZe1nEu1DMdyylVt6pIhZxAj1GY
         31sVX4i4VfnNj2jqM+CHibFi8LXLmOnIE1QeCXa1rFd/iHOEYmgfa1Zinyj/MCrSuAwl
         4niWNI7kwvFhqTlaufmyLREZD2R85Tf3aivykYLv1eq5FqY+nE4ylsM7XKS1vtrwLsDa
         ckSie6mgCJlKyGJ5xYELRlVvrQmSGBE/tyxb1+4Cq3lT8bYtuEcwh9VzX1TIQoM281FC
         nABSF7o2lm6EYHJxDcERmOdOWbF2TZ9zQghu+kjTMW0Fre6PzMM6mcNGrqFBUvaRYPGJ
         7LIw==
X-Forwarded-Encrypted: i=1; AJvYcCXOORiFYrFkNTH4rmvpdjCdkmmz8PEYehGLAxe3FUh+v712DWKXZMw7J/Hs/wwDQLMG5e+225wu4A==@kvack.org
X-Gm-Message-State: AOJu0YwUoUX6vaczhprpIbcixrRytSxUk04ne23NrlzLMgcJTiFD1sKf
	s+OGR5Tf3vLSUAtSeOkUZzspCkr/RaFtWJkj9KOmt6dio2KI1OwCuJRRr204DXjGjAU=
X-Gm-Gg: ASbGnctZDQYI3jkPV83OCG06aEmISthBN4aoIVdgY3tXC74M8Q7zb5Yq3x9JwxI603P
	u5RU/urN1E4EE1MQOaL3IQGQps/ny+YDcQU5Vz8cPAj71WyxvO0LIKG48DwE3fpwBdd86+ACpfZ
	QXbKdUmW9w5G2BjmzNjMHMDprupdiOz0Qtw0DLP7+UoeHA7gxNVFpMgB3BgklxSuDIavUnWtwgB
	PyRqHWiVuWfSnIKDS7zHCJ1zfUg+dirEp+BNCgec7e9drC2o21pdR6RSsJJshU79VGNWkePjg+o
	P/tuFrY0ohj0yYvhwuB8Rdv1v9nySBZ3lt+BpxmjZiUELWqtwpweV2WnxKJglYRwQiLDsbpKvXe
	iU51MJGNLRWCXEb6vQAAomElpdMaBxEJVMKoasY/UehtFjlQS1tMLXSp6QnTmBNISf6RsZfh114
	ip7JiHISqUK/jwCLDf8A==
X-Google-Smtp-Source: AGHT+IFiLMT68nSMNgBaSuSlJ+JLaJj7OJOpOwM9krl/tnM9X12Z1SJwMWK8EaN96FbQ1GWCyUBDww==
X-Received: by 2002:a05:620a:294a:b0:864:48eb:34e with SMTP id af79cd13be357-86448eb08f9mr880925585a.55.1759107881875;
        Sun, 28 Sep 2025 18:04:41 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:41 -0700 (PDT)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 20/30] MAINTAINERS: add liveupdate entry
Date: Mon, 29 Sep 2025 01:03:11 +0000
Message-ID: <20250929010321.3462457-21-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DB1D14000E
X-Stat-Signature: 7dpzwr3z5yi35tbxpk8dh4jwe6p1mmff
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759107882-21167
X-HE-Meta: U2FsdGVkX1+udhVbI2CCL5dqHFuJZF+V2H26cY+K13l/gsFGHGf5U2w+oGQcoPvZ0i+voHhEpZ21bwqYbQgRtyRXQjQ9wdW4mrLU/q0a97SnaR2KwgFeSGrMtSEZtA2UU3+LArI/KQSmeZy0U9E5bTt9/UYLASi+3TZPqedPyYsMH4tUi8gGpOUJx1e0hP50ofgCyyBHZQuMWl5/E5l+ryoN2GC9qGIN3U5wEAtQuS/SMRi64v6RSFhOpokSWTA8CVgLlgFH1OtL4E9IHS42f8LaK92YisgFWZirYcBNwHShQQfXhp9MSqc7A7zeb+Qzd6rPU1mSM2S+pOvl3MxTYJymWwVQNjwXh+pbRzyRt9GPq8hi7rf5e3B+G8zOLvj9xLdwbCoTCZ0ROyfTBXVdX++ciu02fSRV2prd9byZB/tsS0Fb+gGj3el2zb2efiZs9RjYGaRImEKhAG4CqwuzsQfvJpZzC69nKiRQHD4vlqE9+9GRsqDG8WUzmC5MYmrkG26vl7DjjNu78kSJK4iUioqeO976LUrql7CDwO/SGUUJnTScCPwWQUQCkaufJbqd2VYxM9LeclZq42e6hW0imcLOeGuyImBtraPjA3IYLvlDOxz3oKObWNBZOvZy93S/gv/CWhZtDwQF4YwRsJBW60oskR1VckHaAbtDQC4z64xAxuKMTglMZK2faTY94oQ9wLIXseXc8x7RLSNLR7m8T6Zc8FH2IBXIrFUMSoLshganr8GSfp7XIF6GcYNCvhn/fIKEyCi7LYyvucuz9JWnZ4cngbhThJFbiyto/PYsxtyBHPFGmsSCVK3WbgZwL4/1zi7bRL8mnhtI0QfUio3EvBZqWtbWZIbe/nFetxUPcACCMcoEE7Pt/1gje/3uchOK8ImaZH0KZYohpUQBVXdwxyfPiPZVP+KgehSuPAm3Jyojpv7Nw1RLI1Gw4pKkX8almprC1MhwK0R3s9wexkK
 6bxitDGo
 eUdbhSiRe0K1M9nEZbX2+83KuAeS2Dg0XgTr42nzrh6DjIr969XT2CF8rfinvVnWHZFz/+LsHL9SxODG8BAW++tHAqAlIgQy/bSsctwv9qA56Qglndh/rFBCPrrcbjhmAylhyrCb/ykP24YtkfUimuw09QyfoMruHnJOBOUGgAGJwIEmk/g4ODMdlC1JzoBFV7fnysk1U4SHiYKFjxeIlQof2mHp6a4GyCOkBAEXL+WhlV4L8cxS2Tlac7+Bh4pNJtfCIZmUyhp2XLjcEBKUg8//g89COqdZnZp+uuqGWJ2NnPXyoI4JXbnv7c9XqPBWyZzTr2d8N8D9M+VMgjB/NoN00T12Pt1SYYkTsVruy26PrdZKewX6bvuHkMCEuLVGFJ7wfiAITppiEEg3khOlHhcIE6ht+56EDGKCZvM2te08Dtk0=
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
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e5c800ed4819..e99af6101d3c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14431,6 +14431,18 @@ F:	kernel/module/livepatch.c
 F:	samples/livepatch/
 F:	tools/testing/selftests/livepatch/
 
+LIVE UPDATE
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/ABI/testing/sysfs-kernel-liveupdate
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
2.51.0.536.g15c5d4f767-goog


