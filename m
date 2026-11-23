Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86493606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KR9rjURx
Received: by kanga.kvack.org (Postfix)
	id AA7E46B05C5; Mon, 23 Nov 2026 12:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A583D6B05C6; Mon, 23 Nov 2026 12:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 948476B05C7; Mon, 23 Nov 2026 12:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB846B05C5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:37:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27B7E1A0975
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:34 +0000 (UTC)
X-FDA: 85467090828.17.8809D53
Received: from mail-dy2-f9.google.com (mail-dy2-f9.google.com [74.125.229.9])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3B3661A000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KR9rjURx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.9 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455452;
	b=6tRA29l7LXmIzli86BozxvhPv7zwOzFLmZsC5gQG8/mikMqE2lgtNg1k9OSmmffOqM/qNZ
	UdAobrzJFFvYofxoNJefoZdNL3s3aBb0AtbE3Ngc7b1MhrygPWwVfdKrGm0K1O26YD7hmK
	Inb8SjEwd9JS9ZPFaWrX+1VBMSBVLsM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ltZNAhIvh92aCC2n2MQF/osOH2UAWT9vx20uHoniKkw=;
	b=1q7B+INYby+kmB+oXVhKs+oNMDTb4T29aZZk/RntKUOgxDE5SPdDVToQN9zcAM/NOPHAZb
	P1EzcQqMcTdlcLJSeaPrpdPwepVnNv0fsN7mng9xpRM+1M/XDj9uAk/utpYHBiAym0Sico
	KwUQIgSH+m5D3nk00g2hhCnsNqgaVD8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KR9rjURx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.9 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f9.google.com with SMTP id 5a478bee46e88-3678f64d078so4259895eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455451; x=1796060251; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ltZNAhIvh92aCC2n2MQF/osOH2UAWT9vx20uHoniKkw=;
        b=KR9rjURxVjRuC/IaH/eLCdHqYf+JxVhxDI2ZzEwINwab5lwEg4OBaLW6VTRJoQBGcD
         x87U7vSRMITg8cQNWWQlsQMWFCG0A7FCK0MrN/8A+hRmLVkJIc+SFduMcykQTSXwKwJx
         jR8z2I7M2uu4fPEHtNxhg1v2quMHoyE/uY1MOJqWVPPsD2EzK4N2DNpQx2QNtDT4OeoA
         hH5vr/XzJW+FkoG6zJ+mdSNjUD6PpGHZqVkc6u2F/LmpaC+1woaXPkFm3d1K2uHKwLn5
         teaAGQBb3M7dBTMl5mu5ncwpGYa3gnXo06O3S3ngX/cAUxaRla8uZHiLfuy7mhgt1S5N
         nibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455451; x=1796060251;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ltZNAhIvh92aCC2n2MQF/osOH2UAWT9vx20uHoniKkw=;
        b=gNWccJ3U6j3+9TmQFBjyNUdG/vn/urK7ULTWXnZirzrbXEdMb94gMnVGIDyDnPlmk5
         kC+jGAZ1PdJagCO2RZojZfIWO7dI4T+w8qitxQTVeOA0gj1KK9ItPp/+g8aen/+2EPlJ
         gWE7oe5ae8X9x7ImRCpJfYXTc2/84n1Upsyv2HvpAJy/QqIVlogm1pmilQXRf4vCKQ24
         kkosAcb3rKvMeMkFgp1SdGlXRabH5Sw6EympBRh6YB5GD914L+T+gpgZxRZw+4GC6zgU
         R1h1z3UCp/Zdr7woudR2LjE2MsrP2aQ9vNTJhdgqlsw+cWmWXCG4UnsOw4RXYOJwtvOU
         cMcg==
X-Forwarded-Encrypted: i=1; AL+hErHPh8lNyoBbyWx79yhzMQAcIJb79Rk16qTSXSfBFmOKwzmtwmjlxdR18m9fNOwQZD5WXRUovZhH2Q==@kvack.org
X-Gm-Message-State: APuU4Z/v+NM6fDyfyvLbVxCnkD7cCWk75GjHiU3IqeerDXXMvE4SQ75g
	TtQmik/BeWPq5hmGXoQZktbzdGLiGnjSaERuuyWI5pjwyl+y5ukFhaRl
X-Gm-Gg: AZFdTZdDeSyB8EA/kZ8alYugH3vjJoNxPUpFWzM1aNkXZMdMypm/IuQBJ+BU1t5S8h6
	JkatPlRm8x4uG0rE2hXRr2VY4L1lRo53Q1jf/gcPAKFBf03aqkEn9dJo/9L8EQtueNrdTWiXuLU
	eMn/H1Cc/pNK9BPXifkFumxspMAeuiqcDh53AHRF+HKu9+JDxMAIooL6gQKJ7GOCKKjvSKnZTRo
	D2Wwr3ia4w1ecCYrsvXKFmE9VN/JRiTEHmawlIr1OckH0XXh5JpmjsKtipTmBd131jdJR1H4n6u
	lEeQUxBUGrO3apGavhEhyWqoLK81zR3JUXxZ0hTlfpUaI/WGxYiNbXPaHco4qOU9FQOJsc2ALLt
	f5fWOfABlgehi11H58Rce5vaNWbVbrNirRtPHi5hgAhvmfZJxwAKkLkMRVR1apJ+GgJv7f8s1PW
	Cv1IS6onDTt7bFdT9L/7PCXut9NcH74U61djZbfCgYb71f86of5Ao5egbWBLWPtCHbPQfVXwD26
	RUCnNfYZOJxiBiarKagqbVhDniRm+Vj272JStEGD7UhgRmza02raRTxfjUBo4G3xpjvxGduqCH5
	dhF5J1bqOg2MCd07x/ITNa3fi+uXo8gTaF5/2KGMIvp3vwE9Zgq2+T7EBac6rla9jtZU0mRfacH
	F+GXMTh1afM/IHV0iQ9+zRzcaNo5CMd26vnjGtHRIJTQiM2Eath/WvQrWAeeLnbg=
X-Received: by 2002:a05:7301:4710:b0:378:314:4042 with SMTP id 5a478bee46e88-385702587c5mr11930215eec.14.1795455450833;
        Mon, 23 Nov 2026 09:37:30 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:37:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 16/27] mm/damon/sysfs: support REPORT_MADE type probe
 filter setup
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 04:16:19 +1100
Message-Id: <179545417951.5.1330697247346580936.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-17-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-17-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 3B3661A000F
X-Stat-Signature: 83amdprhby1caibt9gtmsc7d78gx8d4k
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795455452-37528
X-HE-Meta: U2FsdGVkX19ll6RLqxW2hwNcEii93PWzDLnbyQmSGXU0wLB/EjS+Tg20zkF/BSicvktLqpYgm7jhBs7CFQoKc2PJMJWoIGZXc5fb7cx2Ax8G/9i3msooyjy/wRY/zgUl9uhSRYXU4QriVqUzVVWUa5w3Z/kxR06gyLBmIrxlKHLCMC7lofRKvtQHR0og66hAN/xVJHoYK2tS6TG24sTBD6F1AiML3Qtu6FY4MMaTJsjuzUqNHhDBhRJ9eqGEGEkj0Xf35QdHGvgr/jtOxAcntzf5WF2chTxfQs5Lr/pqlP9wPiN/RS5d4CMi7O7ZXdNqBUYutHKflR0wjR0fk4l7B9inf9O6zoI74OhJnlwz80+0v9Vx+6mEwrxZlGFG2d9YKdj/tkHCfVJywJnqdFh548nhBBXQMYrjh997nkf2VU3Rg0hA9Ut+E7pYjkpURUoYYLEWnkVxeONDJn1E2IcoaBwCjzgbCTJslHixH31VJTDlsyyJa8aBBVlNCULoNwEfUy96yc61cXaLiTJA6heKwMI+MbJ5s7OPQWhQsTcj3T1pVcfi60N+WM5oPu3Pvl1AWX208nJQwY9l4YUHHPaf2rghcvwKX+GmcZ+pGLv51Qac6Y4WoqH0qgXlC5cJedkoPdBiUH3ZHTbdE93+kecw6bU6I5cl3+1NfQHT3cg72x7eHXV0Efn3yicpK47PXfuUgRgrn0bjOOx+G7gAoaf9Ipb5uwIRVDsBG9IEOESFS/cpKLyEpt7QJWxJZcCmNxb8EXgC8ry5VuL9k9kQ0huzolSvHGQXlCN5ToEdue1kA8TsoxkuPVCgSAW9MNSxWz1PTXjFYhfuPOjfA3jVJ7+gZpX6w8UVMQDrprWLKLFix7wF8Z1k3T6X9AdlBzcTE68vUxds827iqCliCaaNRqM2h2WskTztnMI9Ps/EsJaBrEFXrmABNchw+8ZDredGjPiQETQbx02xlAD6IGAvCNn
 MlkwNHAi
 WmR1/wLNJDEEruBwiZaaBzX8x9R2cKhCTO37BHBbKXkTdBcfZOMIKCc0mb32b1fSD98AH8qS8NQ04Pw5tmpJo8hJTE+gfLPClA7lVDf/4GDcZZRpeBo79wQV3RKYgXpgnP7Lo4MmzOsAnZUkby4BQ/ZAVTxWsgJRzROhm+CRWey0PU2M4EpZDSp6LDw8a4Iodh8ESlnEagZ4rvWKQEtl4MyAJYtJCIMfzUzsb2/7+kJ1TYxKNbSObZdVDkagJhJJQhQm2P8R/xg8jloTmQbz9ocJmQKFRQcP55kHiZ+ANocO+3QRveTNtjNdM1Nn1PYh+YaVLHEyrRic6sNU8B3zsM6yKzBYTjFtWYCQlYg8nAjUzo/HhqO/ZBzfURIPp+qtplhZH+a+n/wit+bVJzcVhExWXbbrmdCI1eNTGF7ymbbimJX/3HFuSCn+Lu/Kn1Y42UtJEIBSUWJ+fWRjlW5mGXch5azHBNqF6ORAu7ChBMR+XS5HgDileh7cXRHMxdtTKDd3d5b4++lRiWo7zpZX/3Qg784nF1L8bfMDVd0O7BKQquSIyKJN1BpfCFaH9axHGIvY38iQ60/Bk0nKDIKcurJIqzLx7LB3814p8rd2mvnI0mFTnAUI6rA7nsAC7g5PLKFeTi0FDzetMEcoY/m3RgsjXjJyrM1FlHHFEL7qUZaTTSyu4ehF8kw71JBcTROFKXrqLeHxsinHlRfjxm4aRQ+dT5u/5YEIK1xDwf8JP1sjLFF3P2qYKyulyYVX5q5anQGGbt9nvOSg+LKlmoSZsTun8TQGojm5K3ko2z+9T4RBYX+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 13:00:00 -0800 SJ Park wrote:

> Accept user keyword "report_made" to probe filter type file.  Set the
> damon_filter->type as REPORT_MADE for the input.  Setup
> damon_filter->report_type with the filter_report_type user input.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

