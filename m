Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D277B606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 13:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ydIS3rB3
Received: by kanga.kvack.org (Postfix)
	id B524F6B05B2; Sun, 22 Nov 2026 08:23:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02B86B05B4; Sun, 22 Nov 2026 08:23:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19EC6B05B5; Sun, 22 Nov 2026 08:23:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE076B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:23:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B08B1406D9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:23:08 +0000 (UTC)
X-FDA: 85462820856.07.48C013D
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 382D610000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:23:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ydIS3rB3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795353786;
	b=ws6zTE09ORfJJLE2QlnumBMp0lJfDZRO2c2dCMnbbt3L9vrlEN6CDRh95/2RbIIKR82Q4D
	ziuwlpPceEl/mPtKlgT5bxRvXmUYlNaeodYzLl2E75tXoCdiOs73aNemHWwdrZzKQYBOug
	LbcjISvPeWjeyhT0B0xq0sSe+B2INxo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795353786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbyPzks2HSto2dy3vHKwWbemcbPgmqWR617Ql6FivbQ=;
	b=ARnpnHbdEPz2s7+0ecbHBm5D8cbJUZ5eZEKPIBkf1U/xlCVyCOc8FSYsnemRmgfac6c3TO
	LwqrwtsFUaFKXCbenxhvVSqFPJUzAUjnIpbLtoZ/yXw3oOvUcTr0KMfWRclFFWoOHBgno3
	dWvGbELiESbQcs/B49dFuRoKS+CF8jk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ydIS3rB3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-36a315ed211so3061549eec.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 05:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795353785; x=1795958585; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qbyPzks2HSto2dy3vHKwWbemcbPgmqWR617Ql6FivbQ=;
        b=ydIS3rB3G9fG1rVpPa14bt8NJm9QsbdSra6mLjPCSUUuS4xYYLVKN9XO9syCq7+D3S
         jTQA4kegD02FaefndaPgqqbKf2xx5PF78xaQ6/PVi2jVU8HZzXTgN97Bl8Omwjmpj8fR
         8pU8T/hWXG/OYXU5kKJt075jiTC8TIJHTwePUUZqJIDK6q1KiCV/hoY1QNTA7HOZ6JRT
         pDZ4L4aL+RQKpuz6vYo1ZeRbZCGx47K1Ax6SRMAB3lL9jwin7qXvavHZCNYy0d0cYCgM
         3PA+oygNLWvatNIPf8cOL65hVvvyZzB6gOKPFJGRBG9Uvz9HbLVdv1IQXvlKlK8WkaMb
         SDTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795353785; x=1795958585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qbyPzks2HSto2dy3vHKwWbemcbPgmqWR617Ql6FivbQ=;
        b=IzNXLu9KDVopyEcAkkm2Xot8aJXRCwK/RaQJf4OIdLLjScdp2yCXTXczqB5mE/4xWn
         U7D+qrsZpmvid7GYCpcWa4dIMpq4wsoD1UdlrfFe7XarbiSwCUFNn5EakheB4l9ONgAe
         zt3eOveiOfqb/fPhisSKven0YHkDgyuJNulE6sg6joNjnNTnu6Qgf5SapnE3w+Vbq7++
         zC6y3/zTsZrqXichVDfQ/tYdiQl6dWMlxJbhNbu0OCoKGLQCaO0u3M7t65Ynn1qRLmjR
         tS/TlBVYAfMkTXRxKE7Uqr1cj1jtE17JXM3svvQ2hMxkZmJSFQ1+XE3FVXdWepv3vZQ+
         1qXw==
X-Forwarded-Encrypted: i=1; AL+hErEccD+Oxi74Ei8DhmgIZbjb83otGKMprVqQGQQoN8WuoBHUVoH40ovRKPyKuwRkiqupLk8SQbmsjw==@kvack.org
X-Gm-Message-State: APuU4Z+xNVqUAy0XrLg+9beSVawNW4OyYqVDAW9jWP67ciUwJI31b4s8
	5bHSXus6odYRTZAKmtHoty22nX31GtJiSDnDy+qEaIrHb8HtOpKuLXlM
X-Gm-Gg: AZFdTZfPtt9MCLY9k6NOjAy4hCD2+3nlRtZngEeihhwJsXyKzDFBI8D5foa6EsPnq4p
	TyiWWqOi/0feBR0KXes5soYY7+qOes4BOk4q1YAZ58IFlECtkUHwjBADo4Quwg9olgTMGhI4pBi
	47JudCvcNIAn5sy8o2DkRezhUDOgMIl0wk1pQx6yOpplVlE2CJRPN2QSaWeewvXI/67tA/gJ98M
	3IP4bDZbvVnlmDaGOgRsTq9hK1ZCv1gAukY2oz2mG+Km7F5zaB8RkjK1BoOMtJ6WsdMgJRgT88J
	K8JUD55fk7+Z2xH1jbrLxgeE3nGJDuAeAbw1ni7EyVoy9Mb1XeWh7wBkH0hRzQnsLQIqRsWdgVx
	VyT+Hx9MhjfWxnugMBvcXy/fDyF0hyecX+HNqtZPAzW/hZecKvvTOJZvPVPvje2uryDaOstUYdr
	Zc61I4VXOTPNSVGqUE6lhlLVqE0HyYuWbHmv9xvEeqa6/EHfOMtsVAsDw161XRlsS00hAoGTDtg
	nfNfbwOqj2SBIUvZVg/jNDE8mVFnQ5/tWNSGrW20ssjGXEBrLLjZ02o3XIr3lQuROEkypuTkIuQ
	txb7HTjgIOEGOb53PftwaaNvU7mAn41YYMoSm3YfGOZy22VPboea7/jxUDvu8Xa4V1iH
X-Received: by 2002:a05:693c:25cc:b0:369:f17d:efb with SMTP id 5a478bee46e88-384b3e77699mr14832756eec.10.1795353784860;
        Sun, 22 Nov 2026 05:23:04 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c371esm26140224eec.23.2026.11.22.05.23.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 05:23:04 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 01/27] mm/damon/api: introduce struct damon_report
Date: Sun, 22 Nov 2026 21:22:18 +0800
Message-ID: <20261122132241.73734-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-2-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-2-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 382D610000A
X-Rspam-User:
X-Stat-Signature: mk34x9h8adxhemg8yr6tput9wzhosokr
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795353786-568857
X-HE-Meta: U2FsdGVkX19/TzJn6abQtDrX1FRfrkul3ksXVPD1TJwiqlvPBLZtJE+3xIJY91iGvABJesKtRqcvF/DxccG8N5y8G6KRwvUhmRBWJLJcXKxjt20hwCZRQXCpod+md7g5MdwIR5erTBVwvzLgpQMZU5b2yjP21dfKLZeQ08/D13txpnwbPfevcN3EoC1vJN/UCcCIOs0PAg+eYBFZCFsFRxXJsOAHsLgcZwPHmB8lma5GxtBXbXwbbWbW9Kci1CaLRPvkf2FcGL47TNzWdte1l8ZSPCjmVoVLKsbJCC6ny5WiC/dfYCJGZb+v3NAlVCIIckulpTURiIvOlDG2DBY1pgPGVEwb94fbcULv4vpIkqLetI9drVJsmHTogRwLlUD6rtDyQqap+8gp00nrCr1N+/Vt2YolvkPHTuwNP8oSQu8gSX25PwtFhdUnGwu8E6vHC4xsO418U/bMffqEsqd7KsQw5wOHptkG6eBjvs3c8bFRkSun1ZM9mGYpuUec3cVB80AmEPo24PeEJdZW/2/Q00DnQYP52b7ciSxNmH5NL5CB4JJgB6b67tyTsoHM1RoHPwLxy9fPbI6FANaHVUympK4LBd68aoHSY8DM1qzAw9QpFqwtkWSRFG77nqtJ++sH5jfD2Cd5bW9RtVN4h9xDPaH8kDJoOz6O7oIsXNB0Cl2pyD3ime4tvRq9/SVWdNDH7r7C25gNa2YAIau6S13Nzw17G6RzF0F1WQQfrR+Yg8rIrKivhoJY/pV+g6/NsG3STZu823ckBPtSUJCkWPli6cSUOLBXHCfUbpYtoWTFgni0sfXo3KukBFlWpCIiS9pB5jcZbF4k0TrcgTeLEujMODsG5K1epECnIJGlJsPUhRqQQkUp9Zzih2kQ4rkMasXVvgMmtdRu5E67G4QhXfgHBFzrosKSTIF912nTU7vFtrvgGf+DqJu0HnM2UczKEnfrnApfeZAmDg6o66mE3mK
 BKs1Wk+E
 WsYq621oibyo0XbGTWxtd8EMPpb2q/nigaVsw+dupoYw9SuY8IbqXUPY+aZdlLj+vHg8IZzfRrDpsIbCCIKZ1Gqh/2//piGye1Kz2gMUhZrCydnedEhU2m3U/Q/51bJZFuCmCuJpg7DCNnxLSsHXTumCuoPb/afgXEqZbmmNKeiyoGwjPNbVgW6XBf1SFpY+kezZ+oi8SUueU7U3R5m2WprwgswltmKioL5L9UU8Q6WjHFyx4w0NIW4U0WltG7qwHBG5aiCd78Pk+J5BiKDYrU6GfDeoXRwj1Z0VupYSNAIyW/EEbhYq6BdsMiRG7isnLowPwSXzZNH3Mtt+8JWAYNf5GDFQqOE9lXGd0PQ2c0UnXQVqMDmxmnmOLd/ZR7Ys0LWLNmc9PvUmWzoPSfFj0a3fVAMOmblSMFmaTIFx98Pyw7lBnWqKKLFTbv17iiz6q7ABzpkqWvuLfttKCD/T1xMIyEbcabLsBdrnOFBZJaZNywlPUYX5336I3vZiG867lY6aBkYCmb5cKygTKqdf7/jSJnrwhJx6nLHcFZVPLGEpCUjVqyFJHLmWccPi29eKc3KWwdOyw2fIWqXbQs2k2HuZ/ytDiUA0IK9vTGL2dyOup/dBpiebQKCWh12bZTRuRRjKr75GtC0rjilw7A5dwh/vhzHDaV6IynY4AjjHCstYiIGeEOeLMKHB7dsamUtYsUOfF2HDJV1VNXWLTrbmWDXPkFTHKHaRKKwYebiRgKVLb8AI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:45 -0800 SJ Park <sj@kernel.org> wrote:

> Define a struct for data attribute report.  The struct provides public
> fields for the type and the memory address range.  The type field
> represents the type of the report itself.  The address range is for the
> memory of the reporting data.  Data attribute producers can format their
> report using those fields.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

