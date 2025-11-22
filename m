Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1731ECFD2F9
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5296B000C; Sat, 22 Nov 2025 17:47:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BC506B00B0; Sat, 22 Nov 2025 17:47:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D25C6B00B2; Sat, 22 Nov 2025 17:47:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3662E6B000C
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:47:58 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB89EC0A4D
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:47:57 +0000 (UTC)
X-FDA: 84139732194.02.024C3FA
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id DA3F5A0004
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:47:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X52JYNmY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763851676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mm9cJVhutkedd51ycbYwKmMqp19QwPFiX/ffFg8rVcg=;
	b=rBIQ74JYIFbcnaKJhHogw+GyIyAFec3FUITTlN/9yIbdnbyItVeBff1MAqyYhVWmBcTZT0
	YsA5gq4LMzPHBT0LsVR4G9cnyS8egX4xQLWhjoXngYhdyuVw6sqHAHxOHXdRZvO2C+CB4z
	oE9A+OrOaH+KnDgEcNTPs/iAdLneIL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763851676; a=rsa-sha256;
	cv=none;
	b=qRdp0hHkmSdKq+0SMFT2G1u4R+Tz9tp6bfs/Fet5PsZcjk1sNiHFeXnG8GPPJUdiYc76it
	NZZlzMRA80IDoF369L2jlQNG4TLOAtmgPyj4kIJ+6PryRCv7lzvM3IL31LPhy7Ykmfy2v1
	JwnJ7UN1rLn4/kPMJ2jffJqXJWPW5Tc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X52JYNmY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-595819064cdso4439231e87.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:47:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763851674; x=1764456474; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mm9cJVhutkedd51ycbYwKmMqp19QwPFiX/ffFg8rVcg=;
        b=X52JYNmYGrsMPUh9zVwQBTAenHaI4fHIjzK6h0NcIvt6XBVCFN7jzPRhglEnKOgXfs
         Pd/RBwE4BAm0xQOM7o2Z1pxqvumXsVLcSlejWVe3dtSqLiYExjTK5oE8TE1cF52CU5BT
         Y5yjqdgk2RU/XQa6PT4Yyr/eGuT7Ombh8fr+UbG/LI1NMYp2JmOOm3jTjDHubOcjfa9d
         a2NY9jRe+CBgoWCoKbZyfWPb87JZgpDRxiiALvcGCxKhvw3lVNCrMjJ71y0G03R1oa3G
         Bix96Fb8iafUwbCePy5qxgi2VHuPPhB/j8GjAl4qdaP2NOwN8zYfSX66z+BlASDM6NuK
         UAvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763851674; x=1764456474;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mm9cJVhutkedd51ycbYwKmMqp19QwPFiX/ffFg8rVcg=;
        b=bd9HJE3wZlGwQOjD+X7SP8yx0a0BqfcJDnMOZ/dbglM+YZvUfak0M4y5pa6ABmLbCJ
         Ub5zWKq/3EGLrsqeD6Y1U4XdToq5f09TCqoKhGHsFrKVNeUBKR/LKtWzr3PEdM4FYsjJ
         8cu5rvM95bo4HQHNDHuOBolFwMtcRm89zn9y3hxHeLrNFgpkrluPs8W5uK1Ht4cj2+v0
         rJC5Vk/QJfmio4MAR4BaFKvUoK7dgCu86sy+Kv17O6mb1vgJf4foN+XrMgmmgstvcdy6
         E0lAIWSfn+K/Ae9XCil8XyxvRmf/o8BMDMxSBEBlbaGYmT2GX2ofVB3klHZ+UYmITZ8f
         19iA==
X-Forwarded-Encrypted: i=1; AJvYcCWUW5AhnKB+FHk7wxu1lcdDXNoW70K3iFr52i13uohKOV/nHi/6PcP7GR9BA3UFs919k/EL6to3TA==@kvack.org
X-Gm-Message-State: AOJu0Ywi6gXC+nhhcetGyLzkKqsOVCnQq0L8V/H7cqTQrAuxdGwzA6Bz
	Vcq3Pz24gut3QsZ60IeEKG2HYe3DiSpxGzOMhm+z96FL2FBGSPhnb/d2
X-Gm-Gg: ASbGnct3IXWWKUyY8D9oO3ytTJcyDgiZMcQU/WcY2s1bC9/S19QEFHV5FM1EF0zIDSo
	DWuzKBaRHrx2tigtVO4TLuzw6ihdgn+MnvYXpCKiRnOOGicmd/VpW7GlA2UEbnPXYJIjptLtj2I
	kN0XreSwaUB2uvB9mNXzorr6NSxkfTaYltz4KivhYx878ogOCbNkaeG96BrQqp3l+8Trcpgryxy
	bwj/qEzCmj99PGjCCfaHon70KJcTJqlVIWGg0bR5PZOSj97oyOV3Qz/cgbyVFK81m4U5ryK3W1N
	wnoQpwedH4bqKiNEP63KtV78EXVq4gAmT2uCr9ey6ZzCt8qwziQ8feXUFzHR+GkMEJTS4ZL/h15
	BS1is6v6xPALi4lLKJHZCi1HyPFAn1oTZSfo/dcnCZjb7dyljO1vePBh/eyk6cuzc54Q7M8BnD4
	rF8DmmNw8R3g==
X-Google-Smtp-Source: AGHT+IG25dEQnHwaBToxpvBjTeZ/3RB3yCymIb0k9rzfOt31nS8ruDCrSu8IePguUMWt0EMXA9m5xw==
X-Received: by 2002:a05:6512:308c:b0:596:a000:596 with SMTP id 2adb3069b0e04-596a0000a2bmr3428587e87.10.1763851673743;
        Sat, 22 Nov 2025 14:47:53 -0800 (PST)
Received: from localhost ([109.167.240.218])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-5969dbc5988sm2742367e87.78.2025.11.22.14.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 14:47:52 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	agk@redhat.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	milan@mazyland.cz,
	msnitzer@redhat.com,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] pm-hibernate: flush disk cache when suspending
Date: Sun, 23 Nov 2025 01:47:48 +0300
Message-ID: <20251122224748.3724202-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
References: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rec5zg5gqg8g47ysjpdq7k61q6u3drt4
X-Rspam-User: 
X-Rspamd-Queue-Id: DA3F5A0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1763851675-942987
X-HE-Meta: U2FsdGVkX194rjEXOP0jh+YSbji76XuuEApoqi72MMbXMfWI0DXh/6iHtVC0c0e4XIrEeEopDJBHlbXAz3T7cCIKd4fb01okHKRIG73SV4xvnvpONIBCK5gkQS8HlqVtZI4xVo0zpTbCAjlzzFtdHOvJjcdKo6IXoC/o/jXZ2ByfLHLzq1thUeW0cPQpG1CqUff5YTdVCl8irNHbLmnckPdlieOJVUTyjTZ3ES08VdFXRcLiFt8Z5kpqdcNMerYjAen+Zl7oRuKGjgEboyjNqeRmM+nnAxi0tzX1wcCwW1JHUu1eWByvpxqvUT8qhRH/n9aztgRNsLrA9lOukII6LR4e7asjRL7cpPqqFkYNXREi30PPRmbH0RtsrIopQaKqWeyt17aGSGTPWO8JXioVJjlySpYDvjVe3tQJsJ1TFTFWg/mXqQlLsCpaEB7CdrK9UjSrQPUPmLMtAeTnEQNxtgRZECQ2zzkzXLUCQa0OgDziSBTmrnDc4qQDaQpYMBYlDD+Bgg5BFPTaW465t0Mv8LTD8tt+cFQKExBfXUOud6gwIAZqJfASVm7huKpEsTp7Lu1MW7NwyN13AHXH5ddttfUYBlbJ4qwWiRjJKY36R9k8sPn2wORw/YiwipkVI8xy8FEnm23U37IDWpAD9R0v/hWIlhex31IYrQ+Ai4mEP3uzJZvbtekVb51zRRfJqRJ2GI310zED0kgIA6TAFiGLcvs5EGs+bYX9E3ec3ikzcZXH7MwBpU1rDzF1Z0XHEGE9kYyOLSIl0hhbylsFu8Z8es7EiiCFW5etwZbG/IxJzqHbM6jPGa5yjPrCb7cfEPpGgI17bp1YhX2MGCqD7ilmFLgWsoJARImd9T79dsGZ5sMl9j7RxZkPBGv3sg4bhzyhfcZS5OIK6trZZt1JqVNZMTeIlsQZ89S39dXaNHnlmM7PaXveeRwk3Q+sSDB1TMLhHfynF71oyg63eg/eRnh
 vntuiTdh
 SOixRxYvAbXYDUKK1dhE4bBP6JP9MwHarvs+9ba7XX2VmYDI9SSyeHhVahc7DQ6IOS0dk8s1m/0HDw/b9sMD/F6bNMRA9lJ7aq6JgNuyWFMuJYmPHuXno79ntj6SHbpHrc6KzbiW31NfJUqmZOB1vGGZ2uWP5QCiBs0hgUHtTL0lK2HwWIiUvPBvgddOtqnDOr+P+9uFB15UQFSds/u9DLloZUAuUHMZVytRQ1Tygg/EvHiFE/GdoVadUy5aILaxuTQJYhuPO5BYIJUsIHXqopQC3q9JK6UoyCQQiIR5OaS5ash435v6pGwpCuriPys6HY4lKDw4E56WbNqz2H7k4gia2M65kn1TXQqOl1+FTIJ0WXiQaano468XM4Prh+Jx8oiE8gBbToU5QSjdGF0lh4LiXUbAQ0mJjRj3KiTssrO//F9/Y+Z5BbEUsbpVjhtsm6sd6i8jo53JXc8WxCdgK6TyyqPPrSz4N7j8AWFdmzlJ6sKAy1BtGl62Ff7fVeYmPqalztO3SDSYJ0iChjxQTpDuB/EVRHT2LjFKLzX7UkDNXYJdRczZ65Sxpcw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mikulas Patocka <mpatocka@redhat.com>:
> [PATCH 1/2] pm-hibernate: flush disk cache when suspending
> 
> There was reported failure that suspend doesn't work with dm-integrity.
> The reason for the failure is that the suspend code doesn't issue the
> FLUSH bio - the data still sits in the dm-integrity cache and they are
> lost when poweroff happens.

I tested this patchset (in Qemu). It works.

Here is script I used for testing:

https://zerobin.net/?66669be7d2404586#xWufhCq7zCoOk3LJcJCj7W4k3vYT3U4vhGutTN3p8m0=

Here are logs:

https://zerobin.net/?5d4a2abbad751890#WMcQl4FAZC9KqcAuJU3TSVr7wuVnPFwI7dlinA9QHOo=

Tested-By: Askar Safin <safinaskar@gmail.com>

There was no any reason to wait for me. You could easily test using script above.

Also: Linux shows this scary message when booting in Qemu:

[    0.512581] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

So, FUA is not supported? Does it mean that this patch is wrong, and works purely
by chance?

-- 
Askar Safin

