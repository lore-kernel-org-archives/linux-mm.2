Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CC71CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 09:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61DC8E0019; Mon, 13 Oct 2025 05:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39678E0007; Mon, 13 Oct 2025 05:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C28998E0019; Mon, 13 Oct 2025 05:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABD7E8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 05:33:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B5CA1DE329
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:33:46 +0000 (UTC)
X-FDA: 83992578852.23.81C226F
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8B622A000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:33:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sswrsizu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760348024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tKlhmybHatxRpg5IBkl5HmNvsZrEn5pX6moYVoKC+FI=;
	b=IXxzr/Y60mmJo1lDKya2nh7fujeFMETwMfwFyQ3tbSTlM86zBNKo/RAFNSnWuJt1vPLco6
	3FYHVL2hueitgalwQgSD/ClCq3Re999Yx2Vm/QNhA6DvzThreuqp5B++cuLxe+435MzJEO
	Ifc6cUTp/PWQ2HfGwacrNt/vdREZY8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760348024; a=rsa-sha256;
	cv=none;
	b=zgfYkLGDt1JawGg8iO8KDtVeeJzKu8H/jMBe/qtcyIpxoV2OB3roSWkkVxAXlskWlG4nnn
	xiRhFVBm51J0uFW7pbJIGDNJrV034lJJ8vux+1sJ1nHF8JeGKaQmbtQVV1HlQ050S1aQmX
	VG2M7mrRITQUG46J4Zkt0RHgJGsGHDQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Sswrsizu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7835321bc98so3818896b3a.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 02:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760348023; x=1760952823; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tKlhmybHatxRpg5IBkl5HmNvsZrEn5pX6moYVoKC+FI=;
        b=SswrsizuUzAe8JwQz7+bAaG8X2riGTN3H4FTK9OpbPUv8leQB+0xDo2rg0pEeECnkE
         KBgdGeyWZPmWTpMLgGv2sCP7sA/6KPZ0qu2GKWNapi9rUpO7oHF7wjRCgReWqUmwupEH
         rfjS/iWNr2eW6OA3vLjgrhJxpvxGriibcz78pAyUruqxFqYR51JYl6xzP35kcH77SSXh
         zVhFNtc+5k8EkzKqlwBkSjcheXaSEkTqbb7NTpMiD5Vp7WLOssBkTnnLazaNPvNPIGEu
         RiIWFI3m1hlLByCXgGafVa7UfQlxKP97WcVixqY2uZAZkQuZUJ75x3GxL1KCaUtOkOjC
         auRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760348023; x=1760952823;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tKlhmybHatxRpg5IBkl5HmNvsZrEn5pX6moYVoKC+FI=;
        b=gy215/L+f1YZjNhL7PZPq0FsXc2BcsboHwJAGvPTV+8/2K7/Vk7ZMvpwsKzh97TEv1
         nv6WqGAuJTZTnnEWrbrBSCAfFTnzxlEOaymRYpGIKJpydUqSlt0eCHyBQtauVCt57sgX
         QUoljib07yiw9MhVW+ii2hIjLN529QfPR86//g7JKP/K+YecNazqMZxBKEsg4WCgEZZi
         OCeyFaZTn83/R1ENwbaho2UvjOEdZxcZGOtVkhQPmGEsU1c4+BtrGxKeHwrcPErsC5uR
         2h+blU5rmy57mAR/SCAYwTE5aAKZtXZBf7vJbc2aF21a0SeD7GQMm9hPD2NH8+BA0VFA
         zp0g==
X-Gm-Message-State: AOJu0YzArFDhlbWDX4PA6o1EiCiq7BY50HaRWVRIckIA8ORsI1BfjXSK
	Iqa36jm4CYoOam2BK1mGPeIa8juYrJALXal0gbAG0815C0dhIF6IRPqW
X-Gm-Gg: ASbGncsgrSGA1EKgXuDDnuQY2qKN6QjKHnPpFW06n3hkobv0lRmc6OmSLsMuctMx7KC
	vWM3E5ypW+gQIhpgxVSGZUW0DfjBWlwt2WpicW5CgSwTima4lHXDkdTwy+AzFvA0VLRUnUeqhnA
	/I/YRFXxZyYro9ycqUq+Gu1MewSUWCMyPpYHkN17kVqQTQwVZ5ho6uboU1RzOO2EOsxG3P3Q7X9
	KzJBKOQ8TCNrpEkMJGKA+NSc+BSzPFSdJOH8myWDQWS4s8Nvuqs2sCw9LIwzgUS30JEWu+VhIEn
	lpMo2WjM4DqsLokaGDfYpek4iwX+qCH+5Lgldg1tLr2rucVgb+mmmREMJaABvLOosKfUuz5GYD6
	uWO9WfIgYHThrD7xCCHdb7Gp16L5HDAJEvKi6WrNArjac59YKfOjpSQjOlxFk8cmOTdEPXgHXd0
	xE6Mpbnw74B9pjiUNUoNvPqA==
X-Google-Smtp-Source: AGHT+IEW3HkbeSrrSoLDwpd5ubdGIbiRspp08NgqYs5rFKr4nONDZ+iJCdPKEl7AfbxqHcH/3OzBiA==
X-Received: by 2002:a05:6a00:194d:b0:78a:f45f:8740 with SMTP id d2e1a72fcca58-79387630b96mr24925771b3a.19.1760348023324;
        Mon, 13 Oct 2025 02:33:43 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:abb9:ca1f:244b:3697])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b63a03dsm10905642b3a.19.2025.10.13.02.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 02:33:42 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	david@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Subject: Re: [PATCH v4] hugetlbfs: check for shareable lock before calling huge_pmd_unshare()
Date: Mon, 13 Oct 2025 15:03:36 +0530
Message-ID: <20251013093337.4432-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: k56igefgecm38z349oyoq547iyncimmj
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B622A000A
X-HE-Tag: 1760348024-80685
X-HE-Meta: U2FsdGVkX1/F6GqLVsAl5BN2lO00TR1+OX5+ucfCDlbq7yXUlxXgrH4ps6RaGgRi/3E+xzDIYlzkummnSce9yB5latdYd4EK4E1D9Hebu66iP+nhhQiYu54tpvS6pWPz416AhKEjKyb/GyVq2+ii9MNcST/9NIq2x8mahYdG/NoR7JFaIKKUzuFdt1sXfn6jrXqn3puCBZwjHN8ik+MOm1syZvIOTh7QcfmnyMGtMGdktEmxTpBQbuo/CsRiXTZSqWbEuUGQn6ouupHvJdFp2Ll4RR7bI49AsPJG3tclsDuY0v6n325z0ttotK2epZG5uTCUKTO6TpvDXhljWVcyAAc/EKZtZ+EVcj8W1bGE3xBDiwPu8gA0DWMXlZba/fZkUfYxYWaGp2R5R4YWsjZzqiznguzd6X5NV9rco/ouF4ywJ0TRuK/iaKFdu7G/7JTilcWYaMrkCve6EJw13xLHMuTtZZhLGnWTcZZETTrXXpV9VG5ZiOL1IS9mZnA6LZKpCpkd0/xGv8v7L3YCVoGQWyhXXdpDe+R3DtXHJMvVY6fcN7p3gkt9hpcWyLmZqA3HcV2iRKphyLHFK6B9ohYS6lOGMstiOBJVfj2vQGzpTCTTdWVbvxyeYjVHuI2uL/NjBtRXaR/CglavJ6wdVNbx7ufNmELvmUOJm5ZBSpweXCG05tiUgxW1+FSX1UGPiuwadbCv9VtQxbJIbEQM/z+LKNeB4IUTMyBxlOfiez3uOaEuDvfJGfyzdXwtlJRNr+quS6tI9ttCOvltHZPkp+iikMKezqXdn5e1IsqPy+FnLH2SWOOlS1H1TL3/J3eMELWGfTY0FugTYXf/DRQ5OaCXjdwi5vqEMX7JHnBAG0AEJucL79zPzydb1xSAbVuLn5tWzKN18ZvsNru3phfLtnVJaapTho8YK1lWT2s/++2XjorXapEFint7AIrtdCGZovEB+1ghYPTGP5uVZqLQ3Kk
 VDEmH2zV
 dK4c1SwRKF8j9WiMiworVqw5d2yPB3pzHqs66CbTki5W3mtSHDQOIR9SY1weaJizd5qjiJzg30sEqvq3NIdEvyf5qtC7nQ0fNrjjW/EYw2rsFFuwgmUkq8IvsADxF/W+umpDi4hNyyCienyQlarTVbQ36WxYOsLMCNDBXrd3bWmwCEillHLyvginREV2ItxzSMymxGIfbQ5bmN5moJ18sECBVh09gwngZt8sgFwjiiO4fk7mp/bkY82L3FIaz6ZH8CuAdyjo5FqqkwhIIGAVcJbfieO4R7rXBmnGUR5vHew5yao4N0F9Xd76baGwtTJmecq0IHbpVbGKcLf6pxY799DiV0iy4Xq5l4mCWAKQPEX12c/Zr1fwsw7T4YSjCY0YVJZUwfCSF+2XvZNFvxDn180TceqlEKYpmxoKC9FVMcIhx/hzzH8iGxjmHlo4u+m5F0KlHEpZXIBzYejPPAXpzCudYDYYSQh/xRJ/7UPN5gnQW3z/PHrzQFzXma8hEGknbxmU0Z1g44Xju96QgCvnf4tChh3FypAMAwBSAQen00eA7EdgongxbkoHNjWjcBFCcAB5ISGEzzL8kxoRCYzzwfDwZIUIjexreSybEP5UGG6v3/glDyutK/JQ4P1DVN4m/+ky2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

That makes a lot of sense - moving the assertions after the early return 
checks is cleaner since the locks are only needed when actual unsharing 
work happens.

Should I send a v5 with your suggested change?

Thanks,
Deepanshu

