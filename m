Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 342E5CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57B28E000E; Fri,  7 Nov 2025 16:05:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FD78E000D; Fri,  7 Nov 2025 16:05:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0A58E000E; Fri,  7 Nov 2025 16:05:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC52B8E000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:05:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C7F512CDCB
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:42 +0000 (UTC)
X-FDA: 84085042524.05.FA2331D
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id B3A541C0011
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HQVmsKP5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549540; a=rsa-sha256;
	cv=none;
	b=69Hq4F59OTsSd6YZzUy9OtziGjdyEu9YFKZJ1j1SRjcqfvzcjjIBHS39IjIBkRAKDkoBoT
	s1nxYxvHCAJcl8PbDan9+NpZI230DRve6k5RUhKfNA9Xj41QgpJCovOCAXRZTIOa0vodaQ
	IAeOgfMdF1x4ciqgnAf2OlmeprEmGrU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HQVmsKP5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eG3KZj/IJ+feH5LNOQCm1I/xQEDt38CQ/0swaPI9wVw=;
	b=wN7/1vpPPWnGh35JxZ6SXu5sTM0aBthedvdVrJ2zIfdbYZTBgooFByBieQrf0mrSJetfGz
	j4jbaPYAJ7FtS6Y6p4HeqFFyyGBg9N4buArV6HaPbq+D80uxHyZkEP8LBXnT7uaTV2pC1S
	P9QQfOoouC6oIXZDD5WZkdvbSVDmjVE=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-63fbed0f71aso1051446d50.0
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:05:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549540; x=1763154340; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eG3KZj/IJ+feH5LNOQCm1I/xQEDt38CQ/0swaPI9wVw=;
        b=HQVmsKP588PkIqAYPCHGLMv3QbwB+tuxVf3E7hjriaW64LVAEJGC2KpOoIH38uPoRR
         oLmVzDSRUKszo+jUf0PqK6WkVj7epzrV0xXW59ChvOXFzXO5y/SP0ZtpQPy+Wlk8jEjp
         qjW7HNY7nJg6oWxSY00XFX/VaLnW3FuIO1LK8EVtylf7qPkgeSI6Cedfoa3LcJraMrxB
         InTwjb86yPJu11HucQhDy1KKmwAt3TuvL1xLNB1N0hih4yWvPcCymll4vXJTy5QoXTo0
         HdIeAK0A8TRfImzC84PIee2rcpBoo5o8Ey5osZN+zWtv3Kp8g9WlJ8Gfj+s6EGXyoqw9
         Dq5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549540; x=1763154340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eG3KZj/IJ+feH5LNOQCm1I/xQEDt38CQ/0swaPI9wVw=;
        b=dwsvNByg2HdX4iZ65oqowv94cgPSFvIJxzVs+ov/4S5wF1a1xc5rk5fd84MHE0x4L6
         B5CfeOY88IloXMs9jBJoQ+Y+w6vKhzqOmwpwFR7ptHFbz86jAJ0hi16XU7l/asAnVY3C
         ciit+dbsIZ7pT4ny2OOrxMMkTMzmoI+bd8F5Dou4WU25kUJk8O0lUyDbTvHXr9Q0B/6N
         PoC+aLtyRkfp33fC2mkUmDhLgLENXKPAA4+bX5POHmgyoNSW/zzT7shR+8Z6NKyFxQdy
         RRbOOABCFItqGujMevuMKEJXFLaRudawOZlvb8DBAxP/qYsGbiaBsU4KxzslOs7CGEMQ
         Ujkg==
X-Forwarded-Encrypted: i=1; AJvYcCU4HhSEVVzrTsOLg9YvBwekIE010+OQ4OH3YlLbJRuHHhyEvC3/h3SxYtCdqbSIW8vIGoAzkabRHA==@kvack.org
X-Gm-Message-State: AOJu0YzbASrhdF9jSKZZpb/2x8n6WZhDi/IxlVvvUBaot5xL5F6F2Rwr
	UkHqWrCzUgGxL2Sz8liKQGB75haS7gHFfD+cPhNPILO/WwSvsvA3ZC9czT8KRFycJx0=
X-Gm-Gg: ASbGncttUFoJcdvtLXU4dtYao7pvT0QvIuSE5Y6t2gDGqza/T7pAGDpPxXxwp8hwK6E
	B4HII8ISiPG6354EQlVX6fZ7p73OLdGWhOPg87s0U0gEGoyoOvEzflQ7seigCfeF+Nff15XPDBy
	g/KG8DcWkBpzYOGnQFUO6bAll5UJmg9s0YOMt/VehtpVu50Zc9jzR/dgzdFYCPZ0myY1GFA+jD6
	nfId/OI27CUXm95v9/xA9WyXFuHvF7E9KH0/gqd9zXH92ruet1GeoVqFfG/igt8J1GThM9FrBOT
	Sxf4/7wyyUNk3Fy7f/kW7k+VizOheLAfk5GNd1oiXnYOiTdapcfr/p2ROhst0ddqMopUI2hvA3Y
	50xg/UPUHKEftlIIaYT9kKpcAlXIUe9RBfKoF4WOjSQmrchDpPqTw82JsY7183Na1MmrzTyXlYn
	KUhTQFpJwAlzp6RHRfEQLE5tl5VewWWFsToYGaFIi6q4aFuGcEPMoJjS7WwWEyb0k=
X-Google-Smtp-Source: AGHT+IGgi833lso4oL9ECYqCcFQNiRqXoYUWKz1MoKHjJMaptGXdg+WJ5uxd88A3KFV7TB/Wv9G8Zg==
X-Received: by 2002:a05:690e:431b:b0:63f:a524:1f93 with SMTP id 956f58d0204a3-640d45ff3e1mr344048d50.68.1762549539784;
        Fri, 07 Nov 2025 13:05:39 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:05:39 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
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
	chrisl@kernel.org
Subject: [PATCH v5 04/22] liveupdate: Kconfig: Make debugfs optional
Date: Fri,  7 Nov 2025 16:03:02 -0500
Message-ID: <20251107210526.257742-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B3A541C0011
X-Stat-Signature: qf989zi8ics4jw7ubuw8h5n5zh7x4sag
X-HE-Tag: 1762549540-98304
X-HE-Meta: U2FsdGVkX19hjJ3wZQn9s4ssezu7stnv7OYyqJ7ttkprkFY/JzjtABK8ZbFAhjt4RJjhPX8Mik2rqfU4woZrmE5py2/Lc1/Puwq2htOstkkg4/cMb6rnv4MnlIjjzEneCtF0hnA7/N5JoQ3Oyd4rGdD+Gt2WaptDN9gCVOzNl9fPtqiQBxNfSJnMgNVQ3L+nqUcV35XleKAbEe8T7M3xl8ChKAxm5iz5EKDN5KW93qnHyNgEgvKBZSuaBFbgo9C84JHPU898Nwb8pf53jyiWGHkn6g1fjtidgJpRcEJrViHuPrvsoMOYn5ZZeWGngz3WoiuyM6JDHGouQjTDzievL9VamVCC3r/No2vgglacuZQ3ZNfz1elE03XA9mlQsTnYAl4rZsm0kTkYDMML6Wx3dyBIQF+KO6exUPFJxPUSRsdNypC0n6a831YgNayjcV0sVE76EmJG010BRQpZQ6LOjY5FX8G3mftPMgg6Q19ENNmHVzwEXQ+GponZpa7fAqG4H2QLTT5K7gZ6tVbLMv13pZAokW/R3Cds7kfqubuvtk0OwBEyo8uvb+XcJU7qtbxX2L/Py+YpDNePjvsUkBwCHE/PB9Tyi0fKXU2eQ5sbk8jH5PFvDd9meTn6RbU10GVV1wDtzYDIS1yjksCS5Ebv396mkysAHs12dUP06BUO7nWwgllbhYLOIIaYgwsojJK7hTnOFvfU79LgtrFAPiIeFH0xtDLA3PUQBOOSykYxO9tZAOaA8xKq2jgtMSY3YWFS/t8JSLsOdBAR+U5UMFnZ7OicZeFBAwUkofFIGWsqS2n4FevLiSjj/C+2NNLLCg0y3ThOQzcgBpRgac3ZPF6xUYpY2PULd6/F0PsDNDWinTYNK0KBFMlOpYINW3L+6UTK8gAGz0APcFD32OvduFvZHMUxFUANO43sfk5eUKYeHR7KA4NIgPXZw3DPb7ZTeT575VKdH8l6jw6gnBwjLhe
 V/pvlmsZ
 488upLsHFbibGCuBZhEla7D0w/EMltJoh+9GKYrfE+bGB+DfKvlRdgrG2AHRzSLYyw7vNgBWuWbWXXjUfGkl62vl2iPAxnl7c8tTItDJQ3xqspJva8dOTJiDvvAavjIqXMCcroN6WsT9kpOjL//6nb6510Tt6waPgUzx7ji3FN0qL03T17NTaRaCHdOpijSFEoyasDZXFAacn33bYuOJ4cpfu8dtXRWHBrxi0xQh/44kOX/hbUKt6gZnjp2Laa3jBhA6LBGbGHcHjERZUodk6285NbOZBtKuBeNjympo7frh56zX1Jsey2HyURHqmZwCIe5/1u0mRDHNflTyohOLTnxECNEqP7VAR04uEIYtMIPE+dqJQw9mc1NPah9UpCQavB64LvOW28opp4OY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now, that LUO can drive KHO state internally, the debugfs API became
optional, so remove the default config.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index e1fdcf7f57f3..054f6375a7af 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -54,7 +54,6 @@ config KEXEC_HANDOVER_DEBUG
 
 config KEXEC_HANDOVER_DEBUGFS
 	bool "kexec handover debugfs interface"
-	default KEXEC_HANDOVER
 	depends on KEXEC_HANDOVER
 	select DEBUG_FS
 	help
-- 
2.51.2.1041.gc1ab5b90ca-goog


