Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F11606F90D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J4wnpmLT
Received: by kanga.kvack.org (Postfix)
	id 7AEE56B06EF; Fri, 13 Nov 2026 07:01:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75A5B6B06F1; Fri, 13 Nov 2026 07:01:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4116B06F2; Fri, 13 Nov 2026 07:01:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EDEA6B06EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:01:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D02D6401AD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:42 +0000 (UTC)
X-FDA: 85429956444.03.07B5712
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id F3040180003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:01:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=J4wnpmLT;
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kudVfvR8j8oKpMlnT4HRJXKZnsjg3IZPx8xqv9ln/aY=;
	b=zPAj5jf6OMc7zn22mVrCjhWX7d71bXEPgGs5Xi7N6IB8Rsvm7V+aedMkKrP/NOrlqLI00t
	Mge2rdUUDcLy4FneaX27BfO+ZOynrVAwI1bYxV7E5+8i3oihFihf8A/bOBQ0PdVGmd94vW
	TFyz2UP3SZ6j6vuvlv1ZqqUqzqPTMU0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571301;
	b=1/I8bD8V0WuQNVKNOb5VuqN1ENgCfnA47CR0Wu2mwfWFbjgKYT+FPONCQFtSUHn3RaTFby
	yK/+geOTCSVd59igEQIIRTNmGYq5Xrk12wOBHNxvyoJGkWPIAyLTOBLdbRtt3PgBDpGNJw
	nqZiRY6reS9v7q5/OK6oEz6qnJuI3Yk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=J4wnpmLT;
	spf=pass (imf24.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-372cba0ecf9so91916eec.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794571300; x=1795176100; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kudVfvR8j8oKpMlnT4HRJXKZnsjg3IZPx8xqv9ln/aY=;
        b=J4wnpmLTdb0l2QdlV1HUhZk7ubZQlGfN7ih2lB/5lFB8YC1OPlEjJSmY7tpcM7YEXG
         VuNcAC5gIxCZCB5ZcSaqTUfTu6nlAwsobeUAyvgk15jFAYjfg84dGznImduqa0AlJTmn
         V14KEq3dZEqvgCmBznJ6y4miF2cjhtd9/fs/x5O8k3SqQYy+8SZRT7qLnmR/GxGut/mP
         73RdqS1VbTZ6L/fXavEXMb69hZr1TEjIMKp1aIVYVvRfwLp6hSP0SssSuOUV6DIaqRxK
         vQxhGovS9Y/HgdJPt4GSdVRW56v/EKWXZXLJ+WcIO3kGNb/D3J63UY7WprtoER117jVW
         DKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794571300; x=1795176100;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kudVfvR8j8oKpMlnT4HRJXKZnsjg3IZPx8xqv9ln/aY=;
        b=q4nn/tF2JrJmv9FlKZHzpYhFNIYdfMiFBp73vkJg/Pg5/IqbmLfZtDPtYjgIzoBQpi
         xmIKNW7vG7H1/+qMWXCSZoeAgdJ2v5tF9eb/ymTb0lxfO+fpkRD5MTy07u2DmERyBA8e
         AKScfZVS9h6vU+yKjOd/1xljTr6URC7caSrAO90Wc+dNKLNiMk4OCLFU7rXD6K7VZ0CE
         k4H1tNZwRCr+sm3vXY8VBKEQ7beZfhlg4ZEQ0AtCalsDBKHfJOQ8Y0VlO9U4fYFjXKhh
         Be//xK2eW0l0Qp4fqp++WEBJ2EXb9HgbVyivMP7NrqSGHAmm0e0XBbTnM88mxicQBQrZ
         tq9w==
X-Forwarded-Encrypted: i=1; AL+hErE44fEDjyM1u9D/i2hEJ9Plegref9ctORO0stbA/GN+r8rtc3fGZ0wBRb7YZ6tugUCkafL8YoFvMA==@kvack.org
X-Gm-Message-State: APuU4Z94gOsO/XJDFQuXMFSd+9XXAOIBj9r46Tz7ohyegC28S3yqZeYG
	j2QtZT/m37sDI3pbdzAE6+QDhOAwLxm6ol+2/dWmIweUDqVcd8nCLkjp
X-Gm-Gg: AYBFou1djejvkPGSCc77Ud1GvK39kIEWSg9AuJqmA9EtSlFBEpkR9QGPU18gl4c+A6K
	QlgJ/QIg+pKd3Gsx3/aivG5uWhSaXUSbF3oKODEf7JsbJwCOTTJ9i61AcYvreFfyDPFDL7LCOYi
	mdCdjmnCGolYVgYhimSoq32CrKlAKVleK6twnQ8Dxm8pUifUywLGFcBGmLvKsf0BxPUCIQOD0+v
	PcRtdD9kP1htA5VsK18wDzbVN/qOUbqI4sWubVWqrIhoti/+bFJH7y5vxw3YBMEVpqZmJ60UAX/
	6WW7l96EKJcHKtdCl47EQbbJu3XVrRBF1WAmfI9suByMoy5eB5M0MFNI3cNYehP7+exGVLdfmzX
	3Wq5rBHN9GgJCBTHufYu7Sh0AGdhZ1dDvz5QsEYJe26Oc5rP4PuhHvTodloKpBMVKs7Sp6zAJu4
	iE8Mp63Lgxq/cdCATdg8XgXgbPhlegsKOLlkoegnfT8IIcehn1dH2OsevEQtrFlBMFDlMwjhBSB
	yBVqE5t+yEUfwNMF2w/UHkPK1XYK1+lJHHVica3lQ6lfFANpkuUvnrTH9/oy7gpX/Gf5lpgQBgA
	L9wPK0BMHeevjJGnsevo1tIrJGyaIA6nRXeAx4rpdt6rQr0CzhdeQOpLL2M6UAXSKnrOMoHgotK
	00y8P+bYGbD3T
X-Received: by 2002:a05:701b:290a:b0:127:def:dd72 with SMTP id a92af1059eb24-1b5030f8a7dmr3059602c88.2.1794571299135;
        Fri, 13 Nov 2026 04:01:39 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b50313d8f5sm11650418c88.3.2026.11.13.04.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:01:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3] mm/zsmalloc: remove CONFIG_ZSMALLOC_STAT
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Helen Koike <helen.fornazier@gmail.com>, 
 Vignesh Raman <vignesh.raman@collabora.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Nhat Pham <nphamcs@gmail.com>
In-Reply-To: <avZyo_hCRonuhXW6@google.com>
References: <20261111-zsmalloc_stat-v3-1-2d85ed51570e@gmail.com>
 <avZyo_hCRonuhXW6@google.com>
Date: Fri, 13 Nov 2026 20:01:28 +0800
Message-Id: <179457128804.2142163.14813125534208665209.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F3040180003
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7dyx53ywrpdz9qytkqis41g4er7kc5eb
X-Rspam-User: 
X-HE-Tag: 1794571300-285352
X-HE-Meta: U2FsdGVkX19GSxu0cl/gBjlCs0kCDy1TjblxSv9xdHB6Fjyk9p2uPtcwLajNyD013zJ2AyQRIErVAbuU5JFRDvX9cNITeBl6FFHQosWvk3Am8Un49nKReMi9g1S1MmyPk7hgn0FGmOp33qni0FQt1OM4DGjEf+RzUHVr412Uivw+ekNEPiipbkc4yTj5cqgprKsbhKOFNNyTzef49zGAXzgkZCHE3MRjyQ9trKuN/UGFgcALpLU3WEd+jpXt9tRqpHGdU/5zE2EIK87eNokgqwPzWJ5XWE2f+zQfTyUE8OnBUIJ01FGUiQo6Z8/5X31zkITGJ+Ks6cD8osk4YoWOBLzvgdfuUeE2mwNTn15nbradSuTKdkxpsYs65ROP4sZ51BsOgVfzTWrqwVgF3xzmtdU3Drtvpq3kQtdEcx/qpPU2N7ydNykAleqg3JRFcQzoBJcKPqKeqmarJ4ZEHdZeHstoHJJbuO3/SB758qoMkWL9TMpb3fSVYzQ4XY6mHkdS9vPCyKxD8YStPZo2hlmz9NMJuGSpqoZEUCykf4QgWjymnCd0DCybaD+8UKq1FkwXQCjWzrVh287V73IaKuSwscOvp2LGd+GmRJY1qqOWbb1GsmO6g2T0DOBKdz6qM3VbZNbcHDaN64tk/Np92ZFYWt49KUNExASu0KfuIKGMfElBQYhbTVGsVq6dzjtLDrkTSEkBCO6oN48XfzO2HatPHMA2rBZrdYSL2Ot279szK+SxusBMGfLx4/kJYuxx4D7oAd/9mJR28bJkS4qKicp5rF5ZmY/Qmbvr2hxyM96pykmxIGz5U8TsRrzVfrNp/JjunSIz4QEViM6rjXhBH71lTNADd3Po3lZHhLVlmDCYb5QT5I3+wuu+zYjW1CglHGEzzrWSztsD3EyEDpgPdYH4jIkVeE6cf10FiHJDwl7jPspivFGGyV1HnChROJrhs46BOlqjjOi7nXMJ3yxyNlh
 5mX+WrJs
 ckCAFUDfotRSYQm0bhB1JySCxpR7LwpYFg98akQJgFNGNf5A3w8IgrCqlkTek0a1bpRtpzIR3pjC8T7GWwmqN9qkelLGfi7JLuoSbtKABbCfQwA9uwlH4vUuIqiJno2PG/8S8Lbt1FuIQ3Md1Sikn/ssPUqh9L97rLkkz9kil4+ZltFtCw1+3pVK/SwRfyuqA0K1oeIzQpGB8fVX+hU9DuLr33okIvtHM1UtwgpKiKgGmzOndCiU2COv1KS/S1M6Vzgi5fnPNlip1LykC/lvPGNBk6ikdjxP/MZ9mpu4OOGMJSQLKq/eapqnL0/X19q/PlzgUmBhv3RiLUnpcBF0WUpk5ADB9uLh+5UalHqZNXZ2NbvC2oH+Z8s8jU5/5KhpjEggyqNcwKJunAzCl7khxLQxXbATc0jlepjFj0nE+P0JoOEppZQqs/FrNIav0Ky39YABkRSI1lUc9Tjcfd28+Ss6zoAPqF5nSdDZptxx6jilja55WMtPLpwpEo+hL0D7vudgEKKL4pBBJ4EyaBihWb5xQ7hqi1h7LMppS53BUWXfNsbx++Ph/bJqhqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 11:19 +0900, Sergey Senozhatsky wrote:
> On (26/11/11 20:41), Xueyuan Chen wrote:
> [..]
> > diff --git a/Documentation/mm/zsmalloc.rst b/Documentation/mm/zsmalloc.rst
> > index d2bbecd78e14..4c0786378dc3 100644
> > --- a/Documentation/mm/zsmalloc.rst
> > +++ b/Documentation/mm/zsmalloc.rst
> > @@ -33,8 +33,8 @@ proper handle-based APIs.
> >  stat
> >  ====
> >  
> > -With CONFIG_ZSMALLOC_STAT, we could see zsmalloc internal information via
> > -``/sys/kernel/debug/zsmalloc/<user name>``. Here is a sample of stat output::
> > +With CONFIG_DEBUG_FS, we could see zsmalloc internal information via
> > +``/sys/kernel/debug/zsmalloc/<pool-name>``. Here is a sample of stat output::
> 
> While we are at it,
> We use zramX throughout Documentation/admin-guide/blockdev/zram.rst
> and in some other files as well.  So let's just replace user/pool name
> with
> 
> 	/sys/kernel/debug/zsmalloc/zramX/classes
Zswap has its own zsmalloc pool too. How about this?

	/sys/kernel/debug/zsmalloc/{zramX,zswapX}/classes
> 
> Here and in the Chinese translation.
> 
> 



