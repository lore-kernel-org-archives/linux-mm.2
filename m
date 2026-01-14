Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231AED31A09
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 02:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9066B008A; Tue, 13 Jan 2026 21:57:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5E26B008C; Tue, 13 Jan 2026 21:57:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D30F6B0092; Tue, 13 Jan 2026 21:57:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9446B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:57:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B9C48B541
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:57:44 +0000 (UTC)
X-FDA: 84329059248.13.095DCBB
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 504E840009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:57:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eaWnbgca;
	spf=pass (imf07.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768359462; a=rsa-sha256;
	cv=none;
	b=6LqyFC8sg2GQ2ETKVyBjClitSGZT6x4rqDJuO0BEtAPAusWqOvzyOa1WEtcrQMZcSaaIb+
	ppntv/ISxH2mFEdYhUNTzx9J0B2Wuli9A6Bmn5CWKcwSir+6KY32wQw458hNKqP+DI8ON7
	tPvo/6XOT8EIsrpHnwlmdqcMAXtoh4Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eaWnbgca;
	spf=pass (imf07.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768359462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9n4lu83n7QsMPkx8T9eR/O8D9ERtP+wzP4k4ZYRQXk=;
	b=AuavOrtaLzFiqhkU5NJfuPgceLf/UtxV5kRz6w0e0T0mHLmffrHiyNnhHczbyABUarrOig
	FTFQ8lQJhXTISDHNZFKWhvAqv2GZ7L1TpPI4v/0Ap9+XlkMac2EiqN8hD27qlEPUUOB3pO
	BpxSfxzoZUOIekiv3L/S0JFmrh0KuNY=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-121b14d0089so9288687c88.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768359461; x=1768964261; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/9n4lu83n7QsMPkx8T9eR/O8D9ERtP+wzP4k4ZYRQXk=;
        b=eaWnbgcaeHW0Kk/fK5KfiosVrmKaPLQ+QumNhuQBnYoFh6nR1yCoNCd9xUqEyM/vDT
         UBAPIm84x1fJNZdiUMyGqRJu1zWAdLeGEk1QqWto2g8G7Zlj18lPhMEZht98NC9ypyEl
         tBUz8aeUKrx6EZN3gDkeh08r/bX2TAIndVomC4AXIWbricvvh3jI/64pwVEsbrD2c/Xj
         mQ4H1B2GDIHl5EQdUpfgwkGo0LsEZRNjE8Hohx3vEmLA8KZaRKzf+Iqes995aJ2yiugo
         dBNl1mrprXxUyyIKTJ/E+zGjmYEyPxd0x2thjOpEfTIqjnNMgnpt63NZNVn1Q2ci5MMr
         t90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768359461; x=1768964261;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/9n4lu83n7QsMPkx8T9eR/O8D9ERtP+wzP4k4ZYRQXk=;
        b=bXp6pvR9sr8fTOuIDz8motSeZj7MrpG9Q2xVNPQjIty0fJ7vfzaa7lTM0n8nnfwfvd
         Ttgb38Pa8fHtHUtOR2dtcsB7uEPHzGqacKrVxVLjxYmVI4+XGDLO6WUcqua11em74+s3
         6RYel8kbNizpSqX9SUjgokSNEXQLNhobC88ifyskwitCAeWlsC4NlANNfLrtlv5NRTVL
         6oxoy1XaLm9rhMacA2Zyfavu+9P5X28Jq4/BAf0IRKafUsbGsun9/CBVxv+LeWE+Lszb
         vdEuPqxWMLRMSV1PU/IK08L6++Wuk7EJCqo8NbSnqTozeGR/lFgZaHTeMsU1Y6d5dtfP
         IdsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTxToKBjs7uSY8kvuoFOVBJyhqjpOc/sharmXEkoWxnVZlCOwvUwWMpha0SnRSwbAu3Rjq8WGpQA==@kvack.org
X-Gm-Message-State: AOJu0YxP9sZ4PdEsM0ICOgNARMWKff55sA+Cy+1Oe8qgMGXLdcPtiZWp
	Zy8BktorF7WGfsFMFNmnUdEmSksh2cl7O50Z49WK1dcYT4JmbGe9TL70
X-Gm-Gg: AY/fxX6Ig9UiLOrb6zUGmKGjH0riHL3hJ9taGswFYsmj3VYd2Vv9IhDRKlqOWstJKMz
	+eJZl7mpQFeg9x1qiYNK+mgPLIra3NV7SdQHjhHyJgd97qkPb/vEe5D/uymC9etgjN6MD9jFvVS
	HngeFOgKmfYTgNNW5Bx6m+Ykp+hJTW2G+qGd88aFSnsvgq2S1tz1reitdHiO6t6622OfXbIP6Ht
	CdXkPsQjHDQB67sNV1UEJ77ipHByFKkztNsfA9nWTlel/HtzLN77+vtYKEE0/RGPceSeKaxEKMN
	N6Z1Za6CPyp/uOaAgVLdCK71UvPqDQcY0hKoBn1j0WHowMY7e/sbqIwfMqTpU3rZz9BGvgZ1e3q
	39uDKgN7INGQMAxz39PaJV5WxN3Ug8IHWBW6+mrvq8boi4CHZyfDsttLZn6pHivraaKLg/r3+hP
	jI
X-Received: by 2002:a05:7023:88c:b0:119:e56b:98b9 with SMTP id a92af1059eb24-12336a678f2mr1141773c88.32.1768359460751;
        Tue, 13 Jan 2026 18:57:40 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-123370a051esm847751c88.15.2026.01.13.18.57.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 18:57:40 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH 02/11] mm/damon/sysfs-schemes: support DAMOS_QUOTA_[IN]ACTIVE_MEM_BP
Date: Wed, 14 Jan 2026 10:57:25 +0800
Message-ID: <20260114025725.81738-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113152717.70459-3-sj@kernel.org>
References: <20260113152717.70459-3-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3i6dncchihp4xseqmqe77wcndp15rq5u
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 504E840009
X-Rspam-User: 
X-HE-Tag: 1768359462-453445
X-HE-Meta: U2FsdGVkX1/uPI+Qzpv7e8gzVYk212K3PINIi0YntBYUqPT8qiV2WutYoIv1EK+jALXepjgPLzg9Nts08PsU8hdcxUnI5cp05iKta5ZAx2ZkfEZhdJWTaTAivj3ZwVzItAcKvkVM5QVUUktyCFJ2aHPyibA+zwK4lK+Dp2iupjWwOjYWNg37TmHcFV642wbm/mq8UPhBCzd5F/o0Yt7bx9vEZYOBdwJEh3qiXQC6RSpChmdVtYf2ftlCQODEll7RwjDc/Qr94Vs8JeR9wiyml3BZpRIxEN+P1ExyHJFBv/3iBHVAw2mW5SAQU6l03mamOYRsVO/XtqjwCmrD2n0XN6Y5XuVfCP0cRM3fVgUEuWRv6zoO2NkJUomoA7v2gV8RKjV+lzixK16orvDhyOWfPComVUXDBkE06U7iLA5V0W615+GkTBDGqUdpjuopXuZAtCcbYGx+xN67ZED1XieIUF63gXtDYUfHPfJIKJ6ZyxwCX4sNyHeixP+XKvNWLOUhkeHoUpPXMJLTG+/sbn8GMAxi+EBe8U3My3YQL/7owQ6xftg/WAljHaEOSjwg3Qn62TGHLlqkv+uH4+PFxF/+LEk66uiW4ek4OT59rJllY7tde0EFLdHgx6kb82VyvqsiLcy/4E0NWAK6m7WcyPlZCWSerylTrcCwwNydFcJk98aINa73vC+dNOLigg8BjThFSrXc2EE0PZpJbISc7wReu9TJUFp7ieymotmIN9ZG0kcQWkUBiggNfEJs7LXMrdRnqkFIiFRZjIao/P80NVraeCn1Ld78ijYpwuPzC5Ofjb0nnNmFDz5yyQw/mGhGFfPBLkGZT238Mk29Md+8J5tIzfEzwbrfeTKI2L3y3xue4xmA0TxK/wxc5DpcSNSIbN2xN/rz+0L5V19ouCJQvWocD2v+F+3qi2eUFIh9kPeCnztsWh0PVxHqngIoZCOMtN3FCh5W4H1fE3ICEvmWllN
 bf4oTImN
 QdhuB8bQaLvP5asJLKZcuTcP1tSikzL9JQVY0mQ3FBdcabiF5rbvx/oQdlfLob5HH00NKz/76uPU3RDfAOep0Ze7hE65ru6nekMRyeGkfrXQEoepjygVzwc1PyNTGWZZeVzLZNo7LRXAb6sQy1ayxugR1YmkhpicrrDTq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.001032, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Add support of DAMOS_QUOTA_[IN]ACTIVE_MEM_BP on DAMON sysfs interface.
> Users can use [in]active_mem_bp keyword input to the target_metric sysfs
> file to use the new DAMOS quota auto-tune target metrics.

> Signed-off-by: SeongJae Park <sj@kernel.org>

Hi SeongJae,

The sysfs interface updates look correct

Acked-by: wang lian <lianux.mm@gmail.com>

--
Best Regards,
wang lian

