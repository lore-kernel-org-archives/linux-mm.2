Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B2A606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vmgNu9+v
Received: by kanga.kvack.org (Postfix)
	id C7E236B05B2; Mon, 23 Nov 2026 06:58:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F0A6B05B9; Mon, 23 Nov 2026 06:58:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44B96B05BA; Mon, 23 Nov 2026 06:58:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9190F6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:58:59 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10554A8527
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:58:59 +0000 (UTC)
X-FDA: 85466237598.11.B62AC57
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4294BA000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:58:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vmgNu9+v;
	spf=pass (imf25.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435137;
	b=cxL8lOByYyIECTlYcUWH3OHKdAC0KOu9jhldolk9aQ2g5NXTAc4m96l2K+aQoFNOQ16aa/
	uOf6Z82BgqO795+jos3PNtKkrISm4Sga0JmF6VG4PR4BR/DHkfQhf3L4sqwZUkLnoqe94I
	LcYe/bNVOgFWAO2FL05nFCz/macp3bA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6js7ztezthXpHZzjGx/lwzyYsi8HVANsbsOCwVJ7Sg=;
	b=lU9hzMGz91zqojxMBkzDl5H8IgcAbcwfrP419jckbMcPSSNBNfSjGpijXSLhyCopMRgllg
	Pw0s8brMV6YkrTtt4ksEjupfCGsxxZgV8htNf5KLQpd5LKYhSVQXBpjynL2DVSujaPh457
	xHfI/moKefjzOeHXAHIBabuFc5suffw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vmgNu9+v;
	spf=pass (imf25.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1b3b4944a0eso2153314c88.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435136; x=1796039936; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B6js7ztezthXpHZzjGx/lwzyYsi8HVANsbsOCwVJ7Sg=;
        b=vmgNu9+vZbf7tdGO267/EBaLL+2kQGTNAoYEr+zMt8pqZ7WbZiXnYlNNmiwwOLMYwD
         H2RydtBSCK3t94VZBjJec2KZXZN3Nl1QPciJ0YgFkjcN7DXJQTrQ+6AKXSuEJGPmqIis
         u1x2B1h+oDXB6HcttEASgia1IBEi0f4baEOEvqSxlNCu4a+/PDZEcK2YoHXGQE/QvytR
         Kb68+CeJnkSYHKqXKjhUNIoasH3dX0gKQiasw5FP5wX+RzFs835l2Mz/0UVZD97i3naZ
         gs/ybcmBq+RbKcF5QWL1xA3yTqBK22FtsqW0dBHRrC60o/xFClLxqTM1f9s5/i3m6bgp
         5T9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435136; x=1796039936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=B6js7ztezthXpHZzjGx/lwzyYsi8HVANsbsOCwVJ7Sg=;
        b=jVDv1R5MrXJMtRMWLvTexMkNr6arl7di/QNDMAi65yo/8egi78QZfLPpyx09siDiDE
         aWf0ctIJRJkIY+Y4MYtCSYNGoa797+L6sA1X62aG6+AzADNhOch8f9pLfQhwEWmZJevb
         iWANrGXQPutBcLNOwjdlkg19cmZSAiE6kXWPTUbs+czZVmJ4BUwSzDhxpFp2lTNQIoWN
         4d6sjU0B4ezsJlnp9dDLx2p7yRYVynhuDiKYBt8nZZdi/v1y3aB8Yyl5vmsY5IJ876Na
         nIYjCiwJlqp8po9hOACuA7fscb4SIztRKLb1aTvTfjz1Xb960S6zKZzy+1Vo9ulhr8HU
         c0gQ==
X-Forwarded-Encrypted: i=1; AL+hErE4EjDgrGcDuc4vrxWpKwt2rcTmqGdHfTe3xYXcLEQKxtsZ1MaUIuQNiE/b79HuOcasMzS9CeQxZA==@kvack.org
X-Gm-Message-State: APuU4Z/OeGau/myCFTf7yKFG9eqBBVYY01lqPEvWzhKnjaw8EU1sspv8
	16k17Ja+jj5plioRp7f4gN5/fxu9ivt6zl7ZiiBTelbs2XuJYpnYG17l
X-Gm-Gg: AZFdTZdMDcObiOS6nfcmRNKA3tSnzxYjtUQyXmI2e+/j3aO5VdjNkOkA5116h3HwhmY
	yElFwnT4yEmu6MCCecNifDBYh2XaYozY6YFq9mAhKSIX9jURb3/OYujgaSUqYok/vdmELJqR9vV
	hAjEcSuni2NxMxBFajMUD0Kl8tKPQAy2PM2kc5QQW8ZTDZV3Goc5OxxlrsotzLbu3LZrxL1P3vq
	e2zPAkV0YvVn4u5N3Q5UxF2yZ2mLI1H5qfUuDL4+mpZ0fZOW74GXF321QaQ6x+u+fSVXQCt2QLK
	E5JroyCbpy9+vxE6GQNnaf5NMAfRfNrfhyt9m1RqzAgZ7RQkpDtek0h0z0jJuz4F/64+GLK9knP
	rMLFLzdICKo6IUwC8oPckJibCchqB9BltCEdew3MrIHW6WLbEiWvmXYsxMI3FfcxqAl1uihDFsS
	yyuUKq6FeBCerb6BvdFJBhhhHTfk/zY3eiMYtoYLIJeoM1utywo2hYFm9dsedC39bSaTFFLHVHR
	SUur8XQScMqH4adggK+Ln5DbXj/w3s5cTviPjo4CPPR5YMb6EK9wvuPZcoIHxXqZQy5B+nVGJbs
	yJbHRXO/l8hV+Q9rz67/ks46KFPTdipEL4gC6neaNyF48j2qvkVRY3aSa4gA4P050d6n
X-Received: by 2002:a05:701b:4291:10b0:1b3:af3a:e78f with SMTP id a92af1059eb24-1b5568e10ecmr11698042c88.27.1795435135970;
        Mon, 23 Nov 2026 03:58:55 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b55682d301sm27972005c88.10.2026.11.23.03.58.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:58:55 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 10/27] Docs/admin-guide/mm/damon/usage: update for report producer sysfs
Date: Mon, 23 Nov 2026 19:58:40 +0800
Message-ID: <20261123115847.8976-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-11-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-11-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 4294BA000B
X-Stat-Signature: ppa5qsxsi8ug8jxz44mwgm7zxuqkd7es
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795435137-441761
X-HE-Meta: U2FsdGVkX1+Cr1/El2UCY9geUkVJY6w2hjjolHzip9LNxvhiFVmQ+QxMcblWu0fULhJ4BWNEmVOit34qOWH0nfR7Bi7sV7hUZALBqQE929CGGYfO1rg0zlkePqkH2VokNMpLxwjpwbGf8tTrKB68XeuUlkxph6x0QCsf87WN60uddQXeo74AZuqKLiINSDKXcmX6+nH8lqhHmIO/3po5koZxyalA8cTg12b3kG1EV6hUvmszor+xzQ675fjq9NzpEJtpETFLZd0O6nL3yf92EhTHYltcmcFNE/AsRvqN9aJxLhQSKVQLVpAuSPDMW8yJChayd+tEiAYferkd3282e10J+NPwZjaBuazK+QJz1lWiusmd4CzMdiSlvYduK76RSmg7yCrtq+2Jy1HS5XDcyoO9Tb945pNGBpMI5hmuK3vxwrL0EtLrlpkZK1LOLJ+RfDRa+g0hfhtm5KHQuzaJlrWgpC40d7W7vUa9JtRSxL66300S9ROggYx0kWkVOH9cupbsJheeBSUfywEEJjSQGs3FXZqL5AXceUGbo/C6yldrs89jHhgUrZSCV/HzxXoOExdk9ekRP0nMCj2rpifGzUrfAXUewr6yB0LHBm7qEIy4Re39o1nO/WtldUMV8DFFPa01MWxkvuojU6zucCJ1oI/7XW6j6LRZ+OgTOSwzQ5yrKHDDL2SS0cM0gKkZ4wm8+kVn2wHUcUbwgfxHOSUukGK/Bl6eU9Dqh6FblM/MMwFeXrNJkibay314xfc3nlur1Nm6Pj7AV1HZ7b6IEHtnpbSP/wxXUe06TfU+QZpNZMFXcyCrgdrPNA3dec4ALc9E+scgWO31j7il8aAicefSegJSMQxaS/399FPNGxnuHS7vIwVqPE4qtRKsDG63trSHskFmVzxFzh3kednmW6w80hYBq7mxRdZLcf26aMHEWD+sveTFpn5bmGp9GfPDasdFUxKYUIT0C95UDj4LaKX
 t/KYT65R
 +A+D5V+ufSmdLf3rYaAF4phUEZY/+5PWHi96+u2SaiCsjNYND0t2YLlHytoxMTh3QHfIunwtM37ak+Xj1XH1p4kjupkxyK7f3L1ZMCLTKVrb+5kN7ux2aJJe23jrpm8xDj7+n+WOUIb0G6klojg/S0QTOLUFMbZTl8U47D0Xtxb/AWBaL1yV/US493h08/a4vaR7yfPIlcnyHRAiSDJPnmOBAC0KPb8d/eM7zRVjl9GG/n4vRO6sQAyaomrgyeMdd0B0tvkpCciAhqRjHNMeI+WCTbGvcMDYFmDX12DG7ZmC9MWNNRKzM3DeCf8NAQOag4xUsSzW+6jXJ9BlgJqBxEOHulKg3GriHutYZ3TCbm7eMDBQ8w8rGgQCkt/u1iV126c3sf4qjrEa9I37l0rI75qjqSURfq/O4WDknADryeBDDvrfLWU2dSmnyOjAxIh/Ar6SdK7GpF79XLDe521DggeatdaR4H2sFTxZ4pXcaGMXXOsIyLzdd3vyzAYyUil9iqpXNxpDFbzefoG/Y2NTWop8LyXZ9y/Y38LkUXbRmMazBQhELGQiotGIrUIrY6T7RBhU7oF9f0S9ETO8BvpVjDiZTALvJ+QOb+R/uVvOSjOvZZyEigwPee8xBcCN4ZzuauRDsyUDlUDh1YvTmv479zOAV2Au6wZaW+Fu6X3tXpbqapmdTwP9HTcHmDariKZR091YI0wdbQEJiVJ0P9sRPtsl5DVqgEJuWzQA3pMQijyxDXgO8kX3Xjsm6rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:54 -0800 SJ Park <sj@kernel.org> wrote:

> Update DAMON usage document for the newly added report producer control
> sysfs files.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

