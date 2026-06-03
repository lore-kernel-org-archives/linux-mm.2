Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2683ACD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 04:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B24E6B0088; Wed,  3 Jun 2026 00:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1635F6B008A; Wed,  3 Jun 2026 00:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051D16B008C; Wed,  3 Jun 2026 00:26:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E72646B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 00:26:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8352E8C828
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:26:54 +0000 (UTC)
X-FDA: 84837315948.29.A060675
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5DC49140006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:26:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="Mg/6LVrl";
	spf=pass (imf23.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780460812;
	b=Va7CAWosDkxH9sp4De/mO8NCI/XTFcGij0t0iPl2iIHq1bbcqLYMTtrv2TsrW+hVMd/GWS
	F5sHgslgRQo7gC81kNSFzWoN2QrLKavsJk5PJb2CI4DN5tKNlXmo0+qnVKGGZGBgMWQSVp
	qkBoDolQ7yJas4UO1u0XMqTL9quwOVo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="Mg/6LVrl";
	spf=pass (imf23.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.54 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780460812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3SJtr+8Mfjo1TPz3VKjCaH7CMP6KY0W4WXb69Cl5TnE=;
	b=NTjBnqWV56P0MUdMz62UQptc9TmgfzoVTSojuTagfiV2P9qc1NXc33pW1YvlMWOeDLnjmo
	O6SKOnJTqoZmQwWZQ/y8+r+VMBFK6uNAHX1fc6Pev1Lc2ayRY4ByWctLzEE6bPgBi9XuDr
	O+T/agysVUyAEknTYMLlNPNeK5xxgsg=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6886be3d39bso18689176a12.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 21:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780460811; x=1781065611; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3SJtr+8Mfjo1TPz3VKjCaH7CMP6KY0W4WXb69Cl5TnE=;
        b=Mg/6LVrlHcxnwLshp5+m8Bepapd6+9P0Bol5VW2p3cZlt+9zGIcV8Zqaduggw25OIx
         o0CgnCUWMstQB8hIs1PVCow8wAASySRniX4ktDJ7apJss613wNwe/OTcNjxQ4euxttwc
         tfOHd5PPL0UKquGTVbdtI8xRpa4pz0JIg4+PA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780460811; x=1781065611;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SJtr+8Mfjo1TPz3VKjCaH7CMP6KY0W4WXb69Cl5TnE=;
        b=MgOyTmCfgl7JJnRoIJasCA+gu4kK6e/futzfWkqG9lpLhypSmzAbo/IRQ3DzZ+YB/7
         oQ745jhJGJLU4HE8I2VM+L0YkD+2LCfcq8kt/p7SYsaYAi20G0Pu/sRuTeJwZutuBaph
         C8yTNEPOxoqCZU5W/G8bOFGdicEvddAEtKnq15g0Kk1Hrb0y5YioqkL8/exBOewR8A5I
         tusHRnxFmXjU5gYIm7Rbq1kDFlZVkwcblPArtQZmRDXLcZvcHTX0Rqx9uxDLqj1BrZrw
         +2aCxBbBhwlg7O7bLCnfh7klTgFOxRU1xfrX/0mvxXbtyuUGHYoGb/lXzZIjv6SnQ3NZ
         pxtg==
X-Forwarded-Encrypted: i=1; AFNElJ949QeSD5j/YNSgn6p7+NXWweDy3uzVKOxN2xsRHR9fkaLGM7kMP8Q9xyCzrny7LyBOAR+ISUdhFg==@kvack.org
X-Gm-Message-State: AOJu0YyBMuUMywCBozf1ca/yQxymxeutFcW+lPGBgiucGSB9540CXDHC
	68fJneHMENX7372Klq6Cje1WAi65oapW3wiR1faiKCmRBexP+9Nk+z/tyiqiSK610KCLDETl6TM
	wVaAK+/uejQ==
X-Gm-Gg: Acq92OHb09oS/LcoM1/pwH+AvOJnIJOAJR25YSGCXdpDnA1eHbfmR9pj7poeX2CERQI
	tTR38iGPzIUWnY9GnxIeC/Nq8C4xGJKHmUg/dYxWNIWTBncChNQ99Sy28eGDVPW3B68q+5fzkBg
	hHYhQV9W/fvP5Xyda7eyQV2a6X/6PIRxGiqkZ0xIY+89VP+i9jo02kEa8zwEwgI7DQdOyLXXZp1
	MAkGP94xBA317JXqdAyO6kiB0pSqZ4G+CDP7sCuJSjZkGji1tR00zQLyDl6PyX5YKvTslPGQiU/
	d5isd/A0ByNEGloY2d2xV0JvkY6g8kYX+XcxRK1uvrKBIjRJ7hh35kfx/AwiXB+V4L2tuG8cxW1
	8w2yZ6qrEr76kpOaHOB3HCyCKuQQ0I9vpR3ykeZjkf4oWgcA6a/odcEYNWaKh3SE/FWBladZvTI
	M1Uk6Jd/hNLi7SWpCG3WzrhzwjXsYrVKSspdcQUfEffbV2UWSUc4a7161uZ/76fkCzYDxzk72FB
	c96ZfTziNzYWbvKheSvLw==
X-Received: by 2002:a05:6402:3212:b0:689:c099:ef99 with SMTP id 4fb4d7f45d1cf-68e725493b4mr616986a12.22.1780460810803;
        Tue, 02 Jun 2026 21:26:50 -0700 (PDT)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68e64e2d2bcsm429743a12.10.2026.06.02.21.26.50
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 21:26:50 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490b8a97b11so1810745e9.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 21:26:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+bAadztjQucP80ZkvfhgD6urK77SnCMXoTRBRHnB2PMHokX6HkM2JYJVLSBjUnAnlf3In0wIe4Cg==@kvack.org
X-Received: by 2002:a17:906:8a48:b0:bea:4a9b:27e3 with SMTP id
 a640c23a62f3a-bf0ac20eef3mr38881066b.2.1780460431308; Tue, 02 Jun 2026
 21:20:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
In-Reply-To: <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 2 Jun 2026 21:20:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
X-Gm-Features: AVHnY4IJxv2Bq-ytG67gbyDgK2Xm9CPUNF4PNLBHu-2R4s_ONl3Jl_5fsF1zxk4
Message-ID: <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5DC49140006
X-Rspam-User: 
X-Stat-Signature: 8pnzkwydhzpqgjhucikuatrbeadffxdc
X-HE-Tag: 1780460812-489338
X-HE-Meta: U2FsdGVkX19ItsKdZGYLFuNwKrBAKtrea/jNX1r+tRMoEjx2DJHx1aKB5Jm9fvYX7ZyjjE/YgRUzcdMcDGAMZ0fUWANiQsPyEuNKHmpDXk4DJSvZCREPNViqxLoPIukCpGy7J39hf0ORJgMrULmFYmNxqO7loO70yXdnxHZE9Msft/6qsaaQXbLOXoiWCgoeYbHt7S3fbNL1+fu0vhMgvU7js8wnhxNakBUjxsn+7UKs6KE0NkxnGzIkP1nNFGZuO4OKUcCKCK6TwAEufBaL9XPxIh6xW35H5gAD1oQXQbKJ/oGjsIAAzKS15E58fhN9DAoHBj+WEeyTiQcrovHhytooAIbJl+14hrFguk8OGlLbuUvYEOnq8iqHd3QFXn/Lctj0wIAyhvMkXlEQ/ID/5JDDCUyWP/kx5w2hBNpW/owLIgu5lIiyDscm7mreE5lS/Pw+TJpXTzrO23WIuUcWkdZe7EI9uLOTSwerE0QW6rXzEPiAH3FV7T7naLSZJNHoQ6wZpmf7cxNKLg4FkdJw1juEq0DXKpN68X/2Yl7NpkZ4kK8kIPQzmwfn20LwD1E9HZ5w/tE5VbdRWXkFKScUgZYtF5nBHjiurq5skdu8U1UFCl2+Ykdbj2J+qqR35YpkMUu+VQOuPLJoOxxgIgAcAd7mkXteq6ubaTshY/gNC+DA0/g4A7pNHUsUnUJQXv3F326WP+3DxTImLlE05QjIeqSjfMFV+1APYNs+Z1GAzdugzggw061Px14/szcLvqswkUkD98je5WQojfU3eCe88pgfSM4mjAvCEjiU9a5cdc89xM75Jq/xhtYh4ISdu1KNoD9lgEpoowZ67pCoL0Fby7vvPwzYYIwaGcDcq0HVr2NCIJMll3eZWMaaEeNtX7/ni7UFOzPHbkki+4RUm4BpkTikdS6NCp7Rmzv2tBSJiXcGBLSPbi/HvXNH9+Uc9a46VaZ5S7+7wd5RCWnj8v6
 zaVGma2k
 f0XpCvKG0w4wc11i9kzldn+SCslE9rnZHWj73ox2WpLaodgRUhM28U7he2Gp4dPI+c/XiBngXxvg1VtIYMJhAAfsVoJ+7YT/2Wq8ERE1gZe1Al4j6fanynZ2sRDlgsaBLP+UIlhR8k06RyV/7//I2o6LjKRYmART139IDaN21y8Bv1L4Bu0s8914PouePEA/o3D7FA9VQtl1znH1Na+3dR3TyosHEpLc998GmOhKV4tKxNvn6eBdqhM0yhT3VePvrCiblyxPm78zKkVWzU8po96HOchE0cRPa5kG3F77C3qcfFrPur4jNZ5NzrVtCLrhF5bCuiMV+DYGi+fRbKu3eoV9UYtwrsR04z1sDJ0YPZybJEC9mQDd2wbiwa6JwjxWvdBHVmm85qML8k6bCDqX0ug67d7GfyUBWybyw6W8jtY+gul7BLxzMklSa3h2Fo/79Ao1J2bRSuGW3VVfpyUWuI/JZBQkBvFAqNq6As0zBti/P17gMa+BmUzpUoR7jsWYxdxgYt4A3EqsbTNyLIdDu8ni/3Fo4Kz4pGzpTKjfvZXsYj95z0udz6W5BSWvwzC8Fn8u3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Jun 2026 at 20:51, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Am I understanding correctly that this will completely break zerocopy
> sendfile?

Very much, yes.

And it's worth making it very very clear that ABSOLUTELY NONE of the
recent big security bugs were in splice.

They were all in the networking and crypto code that just didn't deal
with shared data correctly.

So in that sense, it's a bit sad to discuss castrating splice.

But it's probably still the right thing to at least try.

I've seen very impressive benchmark numbers over the years, but
they've often smelled more like benchmarketing than actual real work.

There's also a real possibility that a lot of the sendfile / splice
advantage has little to do with zero-copy, and more to do with the
cost of mapping and maintaining buffers in user space.

If you are sending file data using plain reads and writes, it's not
just the "copy from user space to socket data structures".

There's also the cost of populating user space in the first place:
page faults for mmap made *that* historical copy avoidance basically a
fairy tale.

And not using mmap means that you have the cost of double caching in
the kernel _and_ user space etc.

So sendfile() as a concept (whether you use combinations of splice()
system calls or the sendfile system call itsefl) isn't necessarily
only about the zero-copy, it's really also about avoiding the user
space memory management.

But yes, there's a very real question of performance.

I just suspect we'll never get real answers without going the "let's
just see what happens" route...

                Linus

