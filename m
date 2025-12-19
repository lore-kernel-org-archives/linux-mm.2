Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4188D7877B
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 13:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163C46B0089; Fri, 19 Dec 2025 08:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13AC76B008A; Fri, 19 Dec 2025 08:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047866B008C; Fri, 19 Dec 2025 08:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E893F6B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:51:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A41EE16021F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:51:57 +0000 (UTC)
X-FDA: 84236359074.10.89FBF58
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id DA0A11C001D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:51:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gc9Uga7n;
	spf=pass (imf20.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766152315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TxgXlnQdF+cSEGYxVmlOlYry6iRAaIH6LrCkKfjLYP0=;
	b=sdEcWVpjY/SG1vflg+F8+vJudQu7Ghy6P5Sw6tEplQnPvVYFH8gKqlsfQFtvI0arpQO4AK
	ZkJLJCx9SZAjdykDrix7991emrgZ/ru8mD4aRvzbtM6zKqQ+nOA76MuZVMF8tor8cnwmRC
	P1ZgLgSvBFWu2XNeVjsweyV1uvFuT1Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766152315; a=rsa-sha256;
	cv=none;
	b=p2N7mtelMzrp8dNoI86khfOXeebDmjhHzR0NeMELecBpMMQFxCSq1GykJnJa5iq9zVvHbB
	jVQeip2Ebslj8RAEPngiyXd1A0h2eJXNJmDeDIVOR/l5TlEysQPyEtHprgvZ/wO2WIk6Hv
	qz4WD5ZwTKDZcVYnsFei7mjKxW/iqYg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gc9Uga7n;
	spf=pass (imf20.hostedemail.com: domain of swarajgaikwad1925@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=swarajgaikwad1925@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a12ed4d205so15501675ad.0
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766152315; x=1766757115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TxgXlnQdF+cSEGYxVmlOlYry6iRAaIH6LrCkKfjLYP0=;
        b=Gc9Uga7npV0luINCHOyDctyzpsSuSjTKbIrlXRvNurrYrVwaJUqpm/yYzn3CMrt5AK
         4yWU8miSLwNFr8MaNaoNoEjbdPSXNZSaKJ8rmDY9QtIkTbff8TJXCQ8eKB2ES/wPoJpz
         Y2KKA2aBKNBqUAao8HoO6f2urdNWAPYYhwVlgj/Y1hRgRjNaJOrL/t+gB3BfOGmIcggp
         BG63yH91F7bqZ5MC+VD3i84Q3iKfjkTRzN7VYzd9ipmF9BgHaRL9GF8+aX6xKITluJ84
         76JBTQjDn2JAzdI4eXhw58lVorj+lwzMgUTi9y3B106r7pzfPwhE2j9+cs+0YnfeR+Rd
         iiFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766152315; x=1766757115;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TxgXlnQdF+cSEGYxVmlOlYry6iRAaIH6LrCkKfjLYP0=;
        b=a9V89wURZ4P3Tih222pC5xFk+wQqfE/YBn6GaErKjrSHD+vO7Wl7gNSgnd0n+0TY58
         ly/3lZWD5tbE/u8wO+vk9KIhku0nGMvg3X1p0PJa/jjVqUD7spgCMaonO1y9Ra94j6ww
         aH4MS/yUCXM8xfTdsmcyf2AzZNkda0s534WlNTAB57SMmDUTuXw7qW4aaEBTwfxfQivM
         zIsUvllBq/zYu7vBLpHKJAaQGHt79Fg9iG7KegJi2ucHjtaiqZ+32LWJ5Z409fO6LAiK
         fGpuzuNahUBX43Zx2dZbhv/7UoWtnhltFm2/GWgnVrUs/zffGoUeID9YvwIrnqgcvNts
         FFoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkW8D0UsXg1WHKlCmi5WnpXmbXou+5DJERZmI3biWk5EolrbfJpdoNo9E6SjBQBtJA15COJZCD9w==@kvack.org
X-Gm-Message-State: AOJu0YwdWMUGMansTy8K/mQdePVTo8+dDCtGuLXbpEia7suMp7T9VX0K
	oejvHtbxsF2wXVOparP8s5F9B7JlScNRx3HecUNC7nX48sO8OrGcwvmG
X-Gm-Gg: AY/fxX58XOkZGMB4gUtaWKSDU3r8Dp6rB0rLlMZQ+yDmJhh4UyFvhtGSbYjr/AaZr8O
	5LQXCnv3NumeeNLxzRmrAhzSOP/xahqxqdjB/lTu3EMljwIjKOuKqlLoZEnb5Ydq397awJNJ81W
	vIMu9Zezpl/5FalP4H8K3h4lXI30wZpnSBSRFtmoU5vnyIH8N7w/bvvfByWOQ5RE+zTOv/Y23bN
	xcxT1b/Se57JyLoNoAbfAWSxMmXckAcKARDAcvTB3fFDV/JTbVhA5psv4uIymSBRP0yAZ5x0rCd
	NgYYrQHsHvA3n6753QUCR19MXPVid9RvXbjeELrDGgNenHB3e9YOjFrJJJyMKsOyoEOdnIZ9pNO
	URiAONI2JvgKAYp/i5jv+dhTfmGhHbAZatDI4h50SayCKUTEuVnxeM3zspRNzKwuAQn3A+JQ3Q0
	B5Ngxm6O2FsgjUU+cNxxs=
X-Google-Smtp-Source: AGHT+IHjUG82LmuZwnH/oGWzPoXaTmIsKDM9p+CYDLUCdGZKybZEGn81EAxGcdYrlvsBkx8OQqUwiw==
X-Received: by 2002:a17:903:120b:b0:2a1:325d:8219 with SMTP id d9443c01a7336-2a2f2735237mr27124255ad.38.1766152314579;
        Fri, 19 Dec 2025 05:51:54 -0800 (PST)
Received: from LilGuy ([2409:40c2:1162:1559:f712:85ce:d14f:d48c])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a2f3d5f5dasm23367305ad.82.2025.12.19.05.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 05:51:54 -0800 (PST)
From: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
To: lgoncalv@redhat.com
Cc: akpm@linux-foundation.org,
	ast@kernel.org,
	bigeasy@linutronix.de,
	cl@gentwo.org,
	clrkwllms@kernel.org,
	david.hunter.linux@gmail.com,
	harry.yoo@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	rostedt@goodmis.org,
	skhan@linuxfoundation.org,
	swarajgaikwad1925@gmail.com,
	syzbot+b1546ad4a95331b2101e@syzkaller.appspotmail.com,
	vbabka@suse.cz
Subject: Re: [PATCH] slab: fix kmalloc_nolock() context check for PREEMPT_RT
Date: Fri, 19 Dec 2025 19:21:43 +0530
Message-ID: <20251219135143.7337-1-swarajgaikwad1925@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <aUVTJyd74OoCtSyN@redhat.com>
References: <aUVTJyd74OoCtSyN@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3wfnq8dhtkzcbs6og6uttnqecwrysisc
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DA0A11C001D
X-Rspam-User: 
X-HE-Tag: 1766152315-869599
X-HE-Meta: U2FsdGVkX18Leiv/DH3N3LjM3uB+lqxvE50/OoYAyNz/3Yzs9Pszb2trFcAZZvo8SXwi/A4LPSkG6ik/czAiRnmMyDguaFRUylG37Qa19lZ9mEafbKTNw7QF0MCBSGrYn6I04wsVajewcbrb9pTg7mYDeP0TwhtRtzkr78dD9u1Mvbk7qh6nFbLwfCtBdZbiss+KH5eh0lY8vhJF4ry3hjKgtI3/9GLg65MqozRFH322uQSGrkgACdfMU+FBvh33dehp78KCjIguEa+oKDZtWs8x1EDfBkYQVACXhxldnNtZ51ols1CFHOKtKZVbcULVoibRvgtr2qIqeBjq+oMr0135LwXU8CpVzq5d3I93DE6JhRdeFg+JE2rgh1dfcnkStj9fEj58ngbKkgKU9YLbMnJt9KDS2WDHFcjs17Be2WiG2JYY+dnWfK6QVaRBZIwk7oHBNMredenz54MlGfZ5xqq7WlU6ZRCWJ9uVPQLPpbCh+DCDewHfTfm3RrF+s/6imzvHkOP/JSO6nKX4qUF6vz0mo445e4msLsFzeoaEFcmssIIQ0pv7eZfYPvKpf1hsJNtMHqS9/93h6B/UqnAa/Pn0sCtt3hf+DIjjCUKLEQh4X/HZh4WlG1pjwrVOYpnzXChPZZ93FP/0pPnqXkc6zVt1gXOZQpqtQrKIiNNecogBYHVntDN2vhnokmnHs+xTFunMSeBxSOwMGVbqYwAzdUK2AublCNceQ9fh01utxn5tymR2A3vWmWn8ijqcePVipL13Knt6z9w2QAjEOTexe4+DxI8lHaPqdBnL+AFZJKGE7i1memmZqvWoUG3x0hNNOEtZNLYUx/bDWDvT8ROazOKwl5+lUB2OLuB8z0A74CKPpVn1vP//y7J9ZbbUaruKF0XQrBj7InVmIRwrbmWZmCQ3GgCsfQ4w0N1DMzDIUdD91QWd1B2/0nw6YXHd2nXis9+UVVCvEtt3oVHtCnC
 yW5ovPoZ
 7R5/p9vVXoIUBvotS/8WEEgKbk/nql+8adM5G5grAihr2YhJA/uWSqSzeuou4/K5AMTT/bvvM3x6Y9dlTDRCVyhJOFd1RJpCDhxptVHn3Dmst4aGWyDGVnAhmzlk20cq+AQAXGFdvU8AyozPFbzQQuNzliPfNNEnBndrU2mzLSB9UX1ww/o+Okl0/3woUFv4dgDpEsIyLlxZZtWo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I agree that we can simplify this. I think !preemptible() would be
the most descriptive choice here, as it directly expresses the
constraint, we cannot take a sleeping lock when preemption is
disabled.
The updated check would be:
    if (IS_ENABLED(CONFIG_PREEMPT_RT) && !preemptible())

I'll send a v2 with this change unless there are objections.

Swaraj

