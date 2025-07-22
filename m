Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C604AC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639D76B009B; Tue, 22 Jul 2025 10:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611176B00A4; Tue, 22 Jul 2025 10:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54E596B00B2; Tue, 22 Jul 2025 10:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4525C6B009B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:33:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CAD1258E1F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:33:51 +0000 (UTC)
X-FDA: 83692144662.04.8066310
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id E98CD180019
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:33:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IWDk9ccg;
	spf=pass (imf16.hostedemail.com: domain of edumazet@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753194829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XuOmXMmaaWqnvpqCFWTGZCIySJ+eeucJi/seDLbNI8=;
	b=npcEkQWcAX21BgAILBUhCOijX8SaK5MOaE8+CzBAjZ/FyL9ahcKGGNEsq3Odny50d8woWS
	vV+cvwEb+FlY2lKqA9FqS6q0EglagHdZlRbW3o6nyVlpwWs78y2EjXJv5qv0moXhlA6+oT
	8p0K5Ov7H5bhEVMIwtTTZ4jc2SRMbbA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IWDk9ccg;
	spf=pass (imf16.hostedemail.com: domain of edumazet@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753194830; a=rsa-sha256;
	cv=none;
	b=wCJOCa5GX8q0FPPbCoz9K6k/aPaZeLngyFmYAibrBcOXu6vUbcKa66kH+l1FsKARxB6Br1
	B4zk7GuIJG4PIEp4bwCSViUQrpOM1ClqP9y+XBRnca9xM7y2QghpiRILYVb0fcW5MGhOp/
	R65xRqCPbn11MvyBmhAIQXv90cYJWKE=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4aba1bc7f44so38369151cf.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753194829; x=1753799629; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1XuOmXMmaaWqnvpqCFWTGZCIySJ+eeucJi/seDLbNI8=;
        b=IWDk9ccgpsN8qBJaPKYP4IG+fticvFB7pHAePkGW1B4shXYlKXTH1LpDhfYQeH4WaS
         kn1Jk8F55w38U64SCTTCR7nnT0bfGhiCrp3G1NGjZJ5q81M1N0Ow16oS77eABWBVkapi
         UFddUWIWXhCNr1KorOOGgsLTMqfSq1WVhDabceZYVczB84xOh9DAom2VOVdgaiUofDVD
         /w0CQnnfUrH3dqK8AkIukojxa/stUSM8RA1/3PF8XCFvw/APflVe7hV3wT7YD0Ww0GNI
         CsruEjRyNtN4S7d9LZtfuptIDpSOhcXCQGxMtUA1vYfxysEwVVVGSbIvy0mWJb4s89q/
         UMGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753194829; x=1753799629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1XuOmXMmaaWqnvpqCFWTGZCIySJ+eeucJi/seDLbNI8=;
        b=o3FvVWqXFBqhVp1C7DiaWZaJUU+Rq9EMaMhp/gtv0Zp9+t5Q/gs17P60JXUVe33VU0
         ErEslqjSDG/WnorHJv4DeJGuSCiWlXHtk4/2yQzBg/Ds4T3RHA4gSyOXoLx/IWjZodcQ
         Q9zIFGbZYXG1GKQ0nllYqUlLaOo1J6ARiLNvki2wwInX4zDjRZfXmmH4pPuFt0HWME/h
         27W8JZmJU8o316XdlvcEQC9s1LBbcTCTMqBgwv74jZDgilm2tOv9SDB3TDeWSastMn7r
         rfRPmUFG/4hbDvVDoQcIMz4QhNynj9OkLOJS41ZMtQGOyPTThN9jEqZxsO1wB20uYs+X
         SSDw==
X-Forwarded-Encrypted: i=1; AJvYcCUcuzXnk5c1fQcwmNwCr4itwmAnGPKrKoDNhEh42jV8PU/iJiQbynJSxkHTkKoJNlFp83zZZTd4fw==@kvack.org
X-Gm-Message-State: AOJu0Yy8y3DM+2pwhiJYMN3Twx3Kav19akaX26R7VcpXydnG8qOJUQog
	jA6jkfpiY0V9U+olN9mBED0uyWkal8VA/VJ9C0OvfezlM9POuHUyUUMf573gkVD111myo8Er351
	efOyZr2s6cpRAzhBsJ/4h63BLCTYJUnQkp3k5jKCH
X-Gm-Gg: ASbGnctS0qnZrdbxKZskK7xx2fhUsb5qvPHP16d+FxGgEN7xAeUQQFZzLuagBh+dA3K
	Vbi95amIkThKYKYXNbf+Mk0NAFElbir3pw2zUtLLPuODU+kuWsJ3qIldK8VX8GPSEoYvfZTTMu2
	SVsTp8rOwZ4NKeOVRRXFDaTBkT36yE+YyCX3g6kIJVfnK1j+wi3M3iA2LAOlR/iJviB72TQFlRH
	bcOPw==
X-Google-Smtp-Source: AGHT+IE5/xC629Z41/ewG1rGRd/vRIyn4/fPdY4AoJKCJUc80AhvNP/9QCPniM9G42/4UNQXgbiL4QSwJejVESK33OU=
X-Received: by 2002:a05:622a:248e:b0:4aa:105c:a0d5 with SMTP id
 d75a77b69052e-4ae5b8c53e8mr53665791cf.16.1753194828653; Tue, 22 Jul 2025
 07:33:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-3-kuniyu@google.com>
In-Reply-To: <20250721203624.3807041-3-kuniyu@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 07:33:36 -0700
X-Gm-Features: Ac12FXxIYBSQCB7BH6twTSCxBz7O9cZS9s2CNGBOnfVcy_wDobXLwLt6phukhSA
Message-ID: <CANn89i+ju=N_JNoCqSMaa7eG-70aXk6ZuNGdjc39cpUFQVvhEQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 02/13] mptcp: Use tcp_under_memory_pressure()
 in mptcp_epollin_ready().
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 11m3mezsq4m3kj3jeqk1apnjq77p7c4c
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E98CD180019
X-Rspam-User: 
X-HE-Tag: 1753194829-116182
X-HE-Meta: U2FsdGVkX1+47emH08bSsZ+e8SFZSGIrhBFsx73ZuZ3rRgUOQMG/RAiuk5lKGkLHmun+uJv1K5jlvHr0Hf5xG6/Oq+b2O6yJcwUpzXAIT0eE8YcqLGU7jZF9sEAwX0ivQRQz6VrBjQ/zcRhWJ8dL4K98Ohm+kSHvetXAI5W6A//kx5Lolw/SHG4xeWsRfmEWXECHW27dXspZsNwDGu6pvND4BsZPHLdZ/V6TOnCOmME8C0oI02Sp64Px2jK5WaJiTgCfntTg9I2qW7kZKFv5hzAC6o8w5KPpTC2wpfvucN9/8nnfIlE63pYHH1yUqxc8/Zz8xe7mNVgF7ww8gyLTlA/2pJSHpTPVxnxlY7K14+0wDiZGAHyp7vAFA7tu1S8Ht5kllsuNW16cKJNZalpHxa8DD/yGOglXFhUq0dxTpL6LL9X8lGz3mR+f3hgOffr+l0h6su4k9HuHNvpVXzqec4wCv82UsT9Imn3guRUBjuCQvbKVwQ39D02w/Qoqo3sR65VXx21b77GvT08wD4CEegztA4QjNf8r8XrSF+HjivGQDOgLapS7tGlFUgg7cRhikNWA6HbM54kBZIDjbXEL/dR8idenhXaS3Xf1ewOh+3BfM0IMltzL7EHuHfqcfJSwtljhn8v9v/pYYB0TUWZ11IbiJjLH6BgsBkRA1/74/M1suBnR8TzLlgFXd2Z5Y9zhVl91fm5P0AnMLEo1Hbj+NxD1kIsSws2/ACKkQHU9uFMTm1iKUN+e6jdKEyq7VkVlEkwRKcLi0l6idGDlPRV6uOzJMQgb2epeKMnlCRUcUcpiU3bcp2X6kBZCuS9jhxvKOh4Ju6IQlXpJa1J5w3g+oQ0Thj7VzP+rtdphSWfSMhS5C10MZob2mzL808x7IHJSoIHudFUm2JiCB4XFLFfsdbUT00ia59B6/0ZsRpDC3lJqocGmVizfgCDf25vi+RqukaehnfzSFbppiAONYFj
 oeNlA260
 tQ0Lgx31TCwdcx0CPb7tn8yzAJi8r5o03vsB/SALs+KCDHdzHWeTuRF8w5CiRSxeTqOAOGIx9EDYD8oPpaw6tJ0ButC6ZlQp1PIXAOFg54NndZNqQ+zmh3UwD3PceYLScQfzgtdErXB48SYTS0SBlgxYNL0zZZN6WemUmzeCJh30v/9BB89YDmZZwgzeMD/RWtlmtBA2a5o/+2ilZrVQVwomY5fttgW0JpZ/EdT4GZd1bRV7yoZbLjhTM41lkChb9fIFGWeBJKt+3kns=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 1:36=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.co=
m> wrote:
>
> Some conditions used in mptcp_epollin_ready() are the same as
> tcp_under_memory_pressure().
>
> We will modify tcp_under_memory_pressure() in the later patch.
>
> Let's use tcp_under_memory_pressure() instead.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

