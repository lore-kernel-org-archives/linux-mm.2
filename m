Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A024DE6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 01:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11E466B0089; Mon, 22 Dec 2025 20:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8736B008A; Mon, 22 Dec 2025 20:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F23716B008C; Mon, 22 Dec 2025 20:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E423F6B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 20:41:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95FB91A047D
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:41:31 +0000 (UTC)
X-FDA: 84249033582.26.EDFBC8F
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id A53F6100002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 01:41:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hAkLy2ZZ;
	spf=pass (imf05.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766454089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uzc2azkAT7+UZs63CJT4nkeSpZYqRpvq+hUurVd9/nU=;
	b=OAc2s0Sr23e6cY4kkRGbVLDoXuwhcLYmBKuVgLtMcvjprK81cnxWP4BVsKzOw+toJfCUU2
	H7hBWxMvmGpCtn3RjycziOWaf9viBywnaKu+NB8LBNp9zYpvEMcD/C3mBr0J0bnuCs7xv5
	ZgAnoSojk8I8lPwTQIPS37lB2k61pQE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hAkLy2ZZ;
	spf=pass (imf05.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766454089; a=rsa-sha256;
	cv=none;
	b=sLTVUh6GOg68LLmwSjQUJYwhUQ86Jl+ugLHrBHjMGxLI1OorAsTmstZXajMjzgvOB6fH2O
	F+sCoEC1e/pkt+erEaUvPsCtvoANz5Vhcru6Up/wqrFhfdwg5bTHaAjiW38A1HfIQy02iV
	A2nqYvnmtGOgy+8qR2QLcteDPLu7hbU=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-594270ec7f9so5340028e87.3
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766454088; x=1767058888; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uzc2azkAT7+UZs63CJT4nkeSpZYqRpvq+hUurVd9/nU=;
        b=hAkLy2ZZIpWhlbkoxJ+NwkJ/auho/d5DTegW89lunqq0ncNrw8esD/xNzClFT+ZD/j
         AkUjNZCsMwX564I24VhFZ+pW/3dQ7DSngU2yDgnZ9HXWQLl3aQuGdtPYtEb2qQg3JNaS
         tQ7qqsKE1rS1sEL/1F0VQUXI/Evra/DfrJ6MvN6Fh9ZnmOMVRUZogr/4M7Y5E1sEqAXM
         KprLuRVb6phpD6hJFsioxJls/UnbhwUhNpXwewJMLsTZ/ESIC+bQBGRnKm46lBeDntDQ
         n0ttUMIjkKDeQzdpn019ehHC61BH7Z5CPHTeMWRDNy67CBt0dXBpkyuYcDHoNm+pzL+Q
         CTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766454088; x=1767058888;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Uzc2azkAT7+UZs63CJT4nkeSpZYqRpvq+hUurVd9/nU=;
        b=q4B0i1/f/LuzEhNMORLz+Q1Se0azZtN52Cg8C7jcIKwbX0/0Jj5zeF3eIcUWMSJ0Xs
         P5zPPTH1FIiSYtWqg4YqjxnHBvXdo702YfnbNGxaTUgchc1loCHEEnDMRGmbDKKSQd4c
         cZ5HqWT8w2vCqsaKiNFyMAyhp6fAOWOzTYK6m/LPc8gKKoKYN59SL8Q23Ic+MuYq6/gT
         Xdmq8RGSKPIjmFDax+7vg/2I/XkQxMYNIy0S0fOtChNlW5ppVRcnSnAI5NQJhmbQer6N
         geFAJ6aRsoFnL4b0yiFUJmrcYZkM8rl8dn79LvajXvUVknInaMvGcpKZsXcinuNwnsny
         A+BA==
X-Forwarded-Encrypted: i=1; AJvYcCXSE1BzTuG8lh9SsyUIhvK8jme5o5Yz0Ip4OZ5ZWZZfMfMK4zTGlDN0K2Wq5Sd3iGa9mIjeP53HaQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8MqC1/b71/KTJt+z7oXO3xkoicnbBiaxejiEFgUvD91Oj57sI
	7GwA0RmseO3sj14N8hC3rcSN8EIoPWWl5bPM0b4pPBAaTm70IyGcYFy53KOu4Zz9
X-Gm-Gg: AY/fxX5Q0bSkHaDMksm0E72AaBYyRUcNmVvjwnw5J4d65nltNPaTv5gek4kM1sNvwXj
	IW+Miasr5zKREABwXRXrCLHk3EM5/yfjGDjcSyAuHa4+AAnM7AmiRFpWP2NetCaLxh8j+UWLTzH
	KAPyGjkvZNigc8LrWs560aq4rMFMmvnIac65Kl4ZEvSv2//3pBM8Gv9aXW6eHLx9wXjm8Mtk4nj
	hyD16WtorHcrknnFXBF6uxEBKAMnjZuG9XklJ412LaK7fRQF4+9GMpspTkhTMQZYZWuzXawjUOj
	U69+6c+YMpz5UdVoKpIVlr1QG4egYjBqx42hYVdKIXZiY9KK2y07BXo3kfJes5XyFlWO+ztW6vI
	+vvOzFYndbAEoj8xnZsyh+Quek5pEj6RE0n1wSwbb9dcsKSlWEpbEI0jbM0nNrjlVFV5YBBQhLc
	mmq0EmtZZM
X-Google-Smtp-Source: AGHT+IHWUix04V1tUMjJhj8LmwIJFsrYjMJ2eegt/yizChdKwHOARh8H0MmDtl7KvKnzF0od4dTcxA==
X-Received: by 2002:a05:6512:234b:b0:59a:123e:69ab with SMTP id 2adb3069b0e04-59a17d08c20mr4858078e87.10.1766454087534;
        Mon, 22 Dec 2025 17:41:27 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-59a185d5ea6sm3600776e87.5.2025.12.22.17.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 17:41:27 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	pavel@ucw.cz,
	rafael@kernel.org
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Tue, 23 Dec 2025 04:41:14 +0300
Message-ID: <20251223014114.2193668-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
References: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A53F6100002
X-Stat-Signature: ms4z6mfa7urzhyrc6wm6t7bqh5e9qrm1
X-HE-Tag: 1766454089-724335
X-HE-Meta: U2FsdGVkX19qeUyTf0pPZR+S/+bxdD89U3KHYCSNUDPpRaqWjteCSm12hZeDvinR7SlnRzxg97w28F1gJqyN4ilpEkX4UewswSw5u8A0sRRTOexIJ+9JPBDXvf144yJWRLSb9+4SjFF2nZwNG5kQUfs8GBhE2uDyf/bgOchQMMh2HmtH04kBUO7jegPy7p9D3+g1sZTUycj+TPR0G46np1lyWCDkdK4xMjjwi5Htho2ZMrH6sx6li63TQz/sKa6fi+0ze7cBb+pufgno8FzCL6TC9zruMxe1Brw6PcuLaA4CGNcPhDNqQlkhhPOupXRC8ozWrwQ8JSShLKE2lFOQAcXBRLGOT2U+7cU/tfUBTh/aeG+IlzPJfwdqxuPBvOn8ca45ak8kVJt4BZdgWXfeNHteaPyEYDUeRoF5uk3KZzGRPic4XQYadTDyQbrJsWSjYcMFfa00XS95bor1G25DC37kw+jkxWnotqtv1XHNDpIw9HFv5DapHjiPHU5FH1twu01CXx1ZNkNywyHS8vH5rUK5744+EnlDa0Ng+3J5pfy2riXzWCiVjIg+hfbPpM2c037Nryjieaz+YlRlWVToKpJVn87OPvir6v24GhnviYoswdn5XCO7JpeqfG6J/rLBZ3xYCZC4mWmt+JHvO/np2CiDDGlePRISzv7CqqseTk76vcoWQg0sSQYvb+UurRTuxMLFO5pC/ZdX6CPBbuFyIpk642TPdrWUBeADO1YHQ4rMloI30UJfoJHn3XFBDlf5CYQqTGyAy5f5pBEgKYQ/Ew9NTXWkIZk3Vv6ewrNJIX59s7Ku52ULjsILPysnVLcfCM9LdYdrU+gCy2QGKiwYaDJR+JNqGcQ+/WDTJHtMiJ5qugpXbzEF4I09Gl0QvxyqFACRLlLSx4yZtr43qlnioCPH1dh2jeFx7qIsMMjKkgv0JuH9C5UMvtu7RUQBRzG4wM9QPw1RmJvs1ObUMuF
 +5KPKS3J
 kisH2AgVek/xHdhtpXI3v524KnzuCl2iqX20xrlMnTHwmTT3H5tulxEopJ8GKRICOGEiTz9pl5WkNRGY6UvmfZQep3TraDfhSz9ldWGdVSAtsXDrcoLWH5oujLjuoMz0zOhgTwnvQ2YzkVWKR3KRDeJgHT9bMu99ApBa0wwLM6sfxd8w808imtzJvSYwQmbrGHw/m7ObSi5O75C8DaTsjC7XY4rF4DIoeBZLjxFs6xduS7mS14EHxeXDw1sRAv+4PSkuzYojy6pj0+mp2dH0qS3an3GMOpzk3TX5yoyhYMvdGu6gijT3p0o0sdIcxyV8PI1ON19KhpFxaq62f9PDVYmG8OS17Fq7W8SXjv/mJPoBSshfNDI2n3rYrdidzFbQEvIAGy/oH31pn+OWCJMAo20r4Yy+mdL8yEXIhizshVGdn5p/n0n5NUtguTUe79iBBbMrg7xIxW2v7uYHvttFSOQvgw1zjKFiRS0viHIXcq+rTbVDG8Q8luVgnUedZRa52L2Ls
X-Bogosity: Ham, tests=bogofilter, spamicity=0.011560, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Milan Broz <gmazyland@gmail.com>:
> Anyway, my understanding is that all device-mapper targets use mempools,
> which should ensure that they can process even under memory pressure.

Also, I don't understand how mempools help here.

As well as I understand, allocation from mempool is still real allocation
if mempool's own reserve is over.

-- 
Askar Safin

