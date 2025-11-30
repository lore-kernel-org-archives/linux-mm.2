Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 549F2CFD376
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 15:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7220C6B000E; Sun, 30 Nov 2025 10:45:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2ED6B0010; Sun, 30 Nov 2025 10:45:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B1A6B0011; Sun, 30 Nov 2025 10:45:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4547C6B000E
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 10:45:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E53838A982
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 15:45:57 +0000 (UTC)
X-FDA: 84167699154.18.2F844A1
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2EA3C40005
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 15:45:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=As3u82Wh;
	spf=pass (imf01.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764517556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3bD5hwDyiZXTOqEegQ5/2gV6Tl1/ARNpKkACTj7uK0=;
	b=sUvbjiffqnrbyeAXtyj90+QThXDbDKgbSlalqY7mIn8V0cUjTLjwg0if4nymnuTt333was
	236XZl11wfk6qsCgSkVDU2XOirmL1Q2pAVJC4ASqzGMKA/o9hlAcJ9FiaQPKnPOeeaETNa
	IpuYfRKKUA+dQqzblUOFYssAnHV19/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764517556; a=rsa-sha256;
	cv=none;
	b=nITxiDE1uqhGFh+nM4/RIdGQzKn+CnKg1L94hfYfCqcDL8qLAAvUWUaYcPN2L3ezqR30r1
	BGRaYJCmHOX8s/7DCj0Cshc/3Bhjb1Ku1SsxRrumAVEeKelHCY2cKLUbaSu5mT9XCqv81u
	OXZp6LuLP5DDYwyyHw4zuaxC/QHWeyI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=As3u82Wh;
	spf=pass (imf01.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7ba92341f83so5283382b3a.0
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 07:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764517555; x=1765122355; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l3bD5hwDyiZXTOqEegQ5/2gV6Tl1/ARNpKkACTj7uK0=;
        b=As3u82WhGZ+ASr2eIMfQf5uMtkyaFkIpbPW8aEXxusNDaPLMFzCpMGl3+S6mN3SBP6
         LXlbFcpfuNYUJGCPcaJ4tTUR8rZv7pZnLab4SNfAMHWQjyVbvCXmAM7AS2CigUAB8d2V
         SU6gnHw+CvzXEPtw8/guew3xbNQ5udV9j44dm+6yA8XY23NN4/BSKbFweXGABfnyXNlt
         ul50CzWMWk+xtoQy8p7wkDoAyWjHit6OH5wJZbMhW9oawFoRyXn/lh2h4dhcHZ6KTpY7
         K4IK2qHo3xNbaZuOjmbVx/HiEexLthkW/GTB8wyV7Y3jFRFjir2UZoXftxkFtExRifuY
         El5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764517555; x=1765122355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l3bD5hwDyiZXTOqEegQ5/2gV6Tl1/ARNpKkACTj7uK0=;
        b=m2cAsHSTeNFOM7Sxj7eSVMwYNm51gP+rCxWB2I1JgsL+A3R7QAEvW1dwf+OyPu3bwJ
         6Z9+Jr72hxZu3tNBjQHMf1r74EdcYD/SeWTycdMlAtT1b+I3Eko0gjb421O/szySOZH/
         faU8bOoH5BX9oElckY8UbQkmt5WiUhZJXohEN0JXVGFK06RE67/JHxka2LO4qTOEoFLT
         kbgvjmxiNXpLoRayHtYkTeXM71qcTM6oaBlpJ6IKgQYei706gkAGdjovZFMI3oHp+RBz
         ChRI8OBIg2e7+Gp4C2ensG+3MNiftK2KreeSE73o5EfHTLhQmscLbth8Ti3PGMAIBG5S
         HwRg==
X-Forwarded-Encrypted: i=1; AJvYcCXWxVQWLQIxoMBsrX3zKf4WjimHqJB986mNCb9F6OVCikgZ8xQzKyI2q4ggH9agyIbaY9i1HxfQQg==@kvack.org
X-Gm-Message-State: AOJu0Yyw80RdmTY8RhOdn37p468s4ay0Uh8F1/SU5TZ0iZL8EiheseCo
	Sl3MabisBusbbHk7TmNiBSOEVMV7aMggH1qsxjYSdQPT1HOuRfd2+6QB
X-Gm-Gg: ASbGnctG326VQPAgxvgCq5ie+4jKPCDdWOdbixxJ82B8P6KluXjDf+4wC170UBJSgm+
	cx1STRx4g3dC4A0QzxrO79SSfdb/6O475bXSoTG/BOfZADbK/LuzS83aNmSyDBXIrZpKw9DwTG4
	TtdJWpk/jqQG4DuODk1HjAHjbyu6hc1EYJbTfSjLXi0LctES88+8vaVminETX9uWmrl6GXIJibt
	YIP8Tst/h4Fkho/XpLmt5nXjolQMh1LcSVLtq0aVzqOdUQ2tYki3CcatHTFpcvHCs6H4fAkxMze
	0voBWHe7wce70IqbiMwnzS68TIzDzxWts0dp635OZB3CPWs9aIXZHaf31f6nAa4bmvuQr9jzUyM
	Slfv5bxuQ57ITw4j1NthhRYKAPgZbmaaSJknyHS7JjzaP/wx8SKInUKrrMFojdUhSbpfYUvKHY+
	cObWraA8D7a88gLIFcmTw=
X-Google-Smtp-Source: AGHT+IF+bs5BX30pSD7FzSWNiunaucUSvQT8H7QuBBS86/QjKuHELK+z0pPo8/WZbCTMUy8lORgUKg==
X-Received: by 2002:a05:7022:41a3:b0:119:e56b:c755 with SMTP id a92af1059eb24-11cb6835c7bmr16124579c88.26.1764517554776;
        Sun, 30 Nov 2025 07:45:54 -0800 (PST)
Received: from LilGuy ([2409:40c2:1165:4907:48d2:1e37:4c68:acd9])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11dcb03cc7dsm49812432c88.5.2025.11.30.07.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Nov 2025 07:45:54 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: rppt@kernel.org
Cc: akpm@linux-foundation.org,
	david.hunter.linux@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	swarajgaikwad1925@gmail.com
Subject: Re: [PATCH RFC] mm/memblock: Fix reserve_mem allocation overlapping KHO scratch regions
Date: Sun, 30 Nov 2025 21:15:39 +0000
Message-ID: <20251130211540.582343-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <aSxcs-jCnkrm8o0M@kernel.org>
References: <aSxcs-jCnkrm8o0M@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2EA3C40005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: za3zk1gc46g59qwde1rgi3obj5x5gq47
X-HE-Tag: 1764517556-853940
X-HE-Meta: U2FsdGVkX1/cmZ7TMnUzBWc1gOp72kFyn8vewPOCL+QT6KSiFbI+wtDEfGO3CwIAjj4FaqTWLxaJ7805dS34VykEAQ/5D2e8iS0oUlXamZH4A49qHwFyRw6eT9JzwHulfhhE7vc+urU5eeKJ26rPQHFXP+rN0ZyH298GuFPrlQ/76VnGlyyYjFT7IuovBikWu3T2wzoeLNvc9PVVq6IGJsEB6nZehqAK+OaTB2uE8S1lGHmHKoDeayoC3KFgpy6+1qWkmPawJnfrKj7DWwq1VaxYk76ticS83BQPTJ1SeOnjL5dCgklxL9yNx7y1rZVflUezyaBNNnncSx0R6/Ss9BPHVa5NPJ2AUKAS4b07wpB1oKG2aSrEz+kkQElpjN18ZBi/Bmrc932reS8HHfSzetSUz9JLP8/xGOFLZApco6jmkZ5IwM8hAMzupT7liP9wBBYC0bIHKCLqNdrlK/eC5IydfazXQwlhP+0qjotrC4X32CnC7jhIKpsTc5RARWf5Impfv5X32L/UCOGyMP8N+II2e8Jmf1UiliHUmwwdOek6E20iZVToSlsUv8znLAUgT2BCdMCObj1t4LjPp6xhZyKnJ+OBHcvAUIhy2nhew/btnl1ccDC1MxtBgLwxXHI8RdzYrSTP2c2iLSV48cjaCbIobt9zDtapA1PCE7eiwWKcFzHMXuxkO1Ry5nej427EsVVPiS+BGKAJFXDWHPF21LMeyV5+7P2MivUGOasBNOVhacOp8KfZjx9ebeodxomoZ3ktDdeqSlKS939e0x0iwWrCqX1q9He1uzVslUk5D4ebA8ZkQ6D8pH1jpfCjePaqsixnxD5gzcIDMUsmXolZ4kbZC8Kc8g+2pOeJJ00VNcmblMSjH4QNSncv+Ne4Sb3W7jYKrvrncDtf867dZ3TNX+sXNrML/eh2kSSt/dLCdboH1LquJ6B6TmUHa8h6Q05xNu/O16QZmEHv7C8fI+B
 7J8ERDqa
 jJ+lkl2dJL7j1O1x8fB3emcoNoiorK6PQ6Lr1FJdxHjpfOj8MCQOw+tVIX23RoPa/Kstj0/stU/+b/WiIoB6Ux7A7ikql8xz4BsiafuLVvOBAlU2sJWI+SnygYY+6izdYtgi5JH3LFSmUK03dlwZIuFS8Wa2mEBi4PIgkmzshisL93sE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000007, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Thanks for the feedback.

This patch was sent as an RFC because I wanted to confirm whether the
overall approach is acceptable before preparing a fully tested version.
I will send a properly tested patch once I get confirmation that this
direction makes sense.

I’m reviewing how reserve_mem= paths are exercised so I can build an
appropriate test setup. Any guidance on recommended testing for this
area is appreciated.

Thanks,
Swaraj

