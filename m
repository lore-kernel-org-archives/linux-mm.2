Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40212FC72C2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 13:20:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0516B00A4; Sun, 22 Mar 2026 09:20:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A82A6B00A8; Sun, 22 Mar 2026 09:20:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BDFB6B00C5; Sun, 22 Mar 2026 09:20:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 562696B00A4
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 09:20:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 105011602A9
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:20:34 +0000 (UTC)
X-FDA: 84573758388.11.93CC318
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 41FE1100005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:20:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SwgI43B6;
	spf=pass (imf05.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774185632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JO8s6CvPJ60AKkie9O7leqHw9KEgz3znAI24wdcudkI=;
	b=iYnvuddG3BKdpnFiK8nJGFn+9qAnfP1kcZFd8easy3cgsodHgwuyK6EAzpbWoqT0Vdl0tJ
	jsHvWzwWNGjRhOxPJK35g8Nyw8jICxvlXhXaDjeVKrn84M3qDue2NtOHehdb0M3DM3mRmi
	4TMvjGT1+RS5TOn1KCQ++uIiMc/UvB0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774185632; a=rsa-sha256;
	cv=none;
	b=WyQ4cZ0zw6OaK3phKCE/p1wtrt17IPqwjsTEyfvAbTQaiuXZ6E1jCmkj5pV3bkrIOoGMiI
	CL1crDBboivYMtpwDvjEqYZoefPh5I8w31kbDaTUWtUu6XWVFj0VTc/GjiPUxbbnXPOMsx
	DgjRqSeGKVCf9+PJYZ78RwWv70gLnDE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SwgI43B6;
	spf=pass (imf05.hostedemail.com: domain of chmh0624@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=chmh0624@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35a1230c60eso909519a91.3
        for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774185631; x=1774790431; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JO8s6CvPJ60AKkie9O7leqHw9KEgz3znAI24wdcudkI=;
        b=SwgI43B6iIao+Zl05a0h7n/377l1ujPhyrNL9Kt1OWUslBzuKorbKPzFbIf0wSUG9c
         kME4mLl7GklYT3Zh/TkSrynSUClB/jvsWBb7bpe61FEhOyYvBBjBwuHwwqWVq6R9i2bI
         UQgFez07ebr4cl6UmpLnPauwroKb99s8NbItaGMk8TRSgEU/2yyQgdtINdBOu5LaCgwn
         iiOOgIyvzOJT4C2OUjzxSJwvSbYRO74pbLEJgxRQLHbgi1E0qfuZco3CXVKhCZdbf6kZ
         7xaN8I/maY4wSER9S9e2HyfTXYLADzvdH0Xa/GBVvdApmNUy0pUOyqCEFb3r886FDwfP
         6zmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774185631; x=1774790431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JO8s6CvPJ60AKkie9O7leqHw9KEgz3znAI24wdcudkI=;
        b=kVSb1qvo9t5hckp1m8d/zEOwHqEsFFWIgKA8M5BJV1zcNI7Ks4qBO83GggdLqJfnk4
         w2nThtTYNbtz9UTSSuFGnrOZBbnUV2ebO4wgC8QL/5XFEDI/VhJMg78kwUZ08nxwpRtA
         B6HO9mB3AWBo22recn6wMbbutqpecjEYnPVUZkwdbZbPe9i/sLhuA99AHWIn5mk1OleS
         V9NP4c8hn98sUUuhLrlaX2X+8GKBTGnjutivNxRk5nnazw3C+MODtV7kN44LilLxMqwp
         szydY3KbZYx0LOxlY9ejlqwJo69cipDwWbbjwTJnAsM87PXmNmydS9ezgAdExO+fY9nR
         yUxw==
X-Forwarded-Encrypted: i=1; AJvYcCW9GkS18ImTzP8o9s7AvrH7pbAEkqzUiImiVfslhCyx8yfxgDKGxYyRC/NNYyFcGF94vpJQ1jdXsw==@kvack.org
X-Gm-Message-State: AOJu0YwdRIs64akDNtoaPO0ItHHFyagUJxndjRsORL3d2AD/JXgV9AC6
	ozQF845DARwKnC9ggY1FTERWjyFKISC7Lr+ZYN0WYC8fC/4VMokBD9eG
X-Gm-Gg: ATEYQzwj16zobhLJhmkH+8cESsWwX1/oPAD7kYGxLf14npq4yNAv7bGBK6/IeU8Gifs
	CZZlMUPbsQdHkdQC2P5fwH7J2wkY/Dsz6HSD2M97xBr8u+a8YDAX+SvmPCINqYClyTfjvkY6mEb
	4f2mpqY8D3vAFYZlzoCfobTnjimBmKifxiJ4tE9JdUOA/xLeEMv5vE9sv257aQeDoB+0u12QSQ5
	lvNRMCew6aWmpzNfF8yGggUAWWOmbUt7DDw6B2bq2O5c/hoLfwdxF4oSAftxYgQsZrCGER9cfT5
	GqgqT/NGMNIQGotrhYDdqKDtU2qQpWVcOBapL09EomdNpGboVkKAspjqkY+f2uKYP5uTF/Tsjr9
	gouDvowWNa99T3T4PI2UZkL/+hUBMuSqBuq/0aro7PIENkvqhenNvFtTeL0gXVVdp4gwCtRC8DI
	06Tbx297M17KmnMgy8eKycPBHb04Vky23W4EVc0LhUlKLLb7boQqH8km0xxqGBY8yPG9OjyqTWm
	kTjOk7+YUkoOA==
X-Received: by 2002:a17:902:ef45:b0:2b0:9aa7:9494 with SMTP id d9443c01a7336-2b09aa795c0mr4010775ad.28.1774185631131;
        Sun, 22 Mar 2026 06:20:31 -0700 (PDT)
Received: from localhost.localdomain (123-194-188-82.dynamic.kbronet.com.tw. [123.194.188.82])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083527f84sm76607375ad.18.2026.03.22.06.20.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Mar 2026 06:20:30 -0700 (PDT)
From: Min-Hsun Chang <chmh0624@gmail.com>
To: arnd@arndb.de
Cc: msalter@redhat.com,
	akpm@linux-foundation.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	chmh0624@gmail.com
Subject: Re: [PATCH] asm-generic: replace ________addr with __UNIQUE_ID(addr)
Date: Sun, 22 Mar 2026 21:20:26 +0800
Message-ID: <20260322132026.13485-1-chmh0624@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260307092119.20733-1-chmh0624@gmail.com>
References: <20260307092119.20733-1-chmh0624@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41FE1100005
X-Stat-Signature: wcjtzgni8bsw5t68rabxfc6mhno8xnpb
X-HE-Tag: 1774185632-155546
X-HE-Meta: U2FsdGVkX198dNmGyqPbnL4Xxp3pum6byQPBZ8TWWAsQPQWOHPs/GT/dZ3pV9Py7jxavBf+/OJQIS0fm2mWLQl8YyS3jby9/IYu70kITbKHq9jl6F/jJu77OLf6P6PhNeJ0ctHCeIVO9QK045Y+sxBUidA4QJJZAzNtafwBxilFaFpqiIFij6ytmnCvUOAXcms1R4H6fEnULf6+PkC5NNrhWqDN6dw7CPdNUQU+ATJBDCBa7FfOjMluWDUk0B7FtPytTkY3xbH9Rz60vAearIEuvdclgCWQQ8bZ89YJ+b86AA9VkGhfUSz3MvaPnlo/yPnW7RjWhoSwRrCEY1ODBa5cOx/0gjOtC9pJcHyjUoc5PHa15BMWyqNRx4pC4iCTlflriDBVPBjl0ATuoHf1SdB+W1LBJJKKtCfz5x8l2AQ0bsMgosXE7D2I7jqP8DkNcEVAATYREGrlotlC6iJoLqVC/iUdQ5s4zXZjRP3KJr2ablM53hBP+sqlUhsudhd99lzfmTca3XfmvtacYgRS98p07R7gKpGnjICZlET+imAaP7iSnAQEorryQifbRWAFyqlGE7NPQmk5u3Lo+PXPIQvNpq9RRPNMFZLP7qTlCaqQswyQ4ltFhpiz7rSKcz0ls4vheXdUVSbHD+SvqFTgiPtmpn27j645VsY81Ch/MqYZonSGmq9Sk2nE/QrjYz+Qj5mvnIwxUiPpwbKqIBDilz3EgOI821JzfufCEdsmF+GpIa7ZC0sTHVxn2d0J7IXSIumkDj7bP1T5qPbX7tl7PwFtPM4N5mF7rM1SOEAcrBYl42qatccmlSemMNyvJ1vjKIYSaUtygwgjZEg0IVZNAYZLLlnG10RJ/h/9JwGZ5bWUIIZCNXBEKH81pouC8Suxt7x9lZrZ/igKRoo0O5xL0DU4nGuwckc7+6zYc9ckQSa48Goh5iatbl+HzvnUQnHSIjCY9qoKQFZURR4UvMJz
 LyGVmgPn
 whLkjun0i38eIupCY400Eyr86b4RIc/1PItEDdSI2GrYmUd5dciZKuTSaU2P1fy01SbW1uonkuqOsjOQJecCY44qo67ImZcqvE6IW/QkNRScbPFc+W47c2KnUoWX0qGAJonlpymlBv4JbIgwoUEGGUvrTOtIMN3YyI8rFh5yQqC0/ld9vdOD4U8oDP1mWzUiapz1UZMaoeHn9lLhCK735vh0I178VJpYh+oPD12fLrAV8yQxjzkWYvokiHGBhngD4UCsOgT1F8ixKEukzpx5m3gHDcoR55gPetNAHCEVE5JM7KHktIIAMukkt2lUTgQM+N5wnPwyUxm81aexIBzl4W4m6tNXwyf+IpNY0h8F0OHjz41UxzbiwLasEbGSkoJI1MGzthPHdhv+2Kr7DcPAFJzY++lX0jjI3r+4z1aAuXfdTqiHBJQNgtcc1Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Arnd,

I'm sending a gentle ping regarding this patch to replace the hardcoded
identifier in __set_fixmap_offset with __UNIQUE_ID(addr).

Please let me know if any changes are needed.

Thanks.

Min-Hsun Chang

