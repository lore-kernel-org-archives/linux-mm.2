Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72A40C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 04:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B3186B00D1; Mon, 21 Sep 2026 00:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464216B00D9; Mon, 21 Sep 2026 00:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351AB6B00E5; Mon, 21 Sep 2026 00:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13BE56B00D1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 00:02:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 810EC120572
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:02:28 +0000 (UTC)
X-FDA: 85236422376.26.FB802C0
Received: from mail-wm2-f9.google.com (mail-wm2-f9.google.com [74.125.225.137])
	by imf21.hostedemail.com (Postfix) with ESMTP id ABE891C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:02:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lueUUEVS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.137 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789963346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0juRQzdf6nmFbDGjlJJGsvrFrjljT+sRU6VdT0gPqE8=;
	b=rNaN1bOxLAM663aCj5WhMBpIklQfoSwokG8TX0QDwj3r9y+EDP/HcPmEFB+KkZglOlSUFQ
	eaDdsza3c6qyKIWAKshkjTJM5P2LT7ybv3AcLTIiUErZcmb2NLU6lC5ux2mFhTCICBU0ZP
	qadEZdfou3dQNQurbZj7YxGopfuHkkE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789963346;
	b=yYUvQk9umPlEMaVas4hl4EBoSgJvjDyuFd0RuCsbDp4DyuuoUFhe+fipMlrc31+BS+jC2i
	zvNttXXVLGnZaUP9yVjn/YLTYueAzlnfcvhSPL9LaFnUUcuweGJhMJA+BltscRTnV6zJRW
	3ISZdCtRTyULYl7cBSquWQgjAaBDzok=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lueUUEVS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.137 as permitted sender) smtp.mailfrom=memxor@gmail.com
Received: by mail-wm2-f9.google.com with SMTP id 5b1f17b1804b1-49e6e43b9d8so9413605e9.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 21:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789963345; x=1790568145; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0juRQzdf6nmFbDGjlJJGsvrFrjljT+sRU6VdT0gPqE8=;
        b=lueUUEVSFngDFexqfEEjMyBrvH25f4j9UkrP5l+vWI0WW2PS+DXpDhXHk3vatYLyrF
         su55SJy+VKf9kKz+qoSwuvBPnH4lkJLnU0nzx1wUXm7L7dkW9LojQPRy2StzAN8za2QI
         dqXm9dIrLLD9qSO7ZB7K4IS+OU1H9CXhKWLduLblOjH/jVN3zxLOVkOPzWgaeLuqNXfN
         bHGHVt3Uq3y7ybuQG+7hjgTWxxTgz1XSkKQZCtFx6pUD9peNR36Vqbb//Vx0hJEUkEbK
         yPowHBDTYLZAVMV2RgD4q+3tZ/y7hAOwi6IxzFQ+hMvXV/lJQL7pquxItFG8vBo/aMzj
         l2dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789963345; x=1790568145;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0juRQzdf6nmFbDGjlJJGsvrFrjljT+sRU6VdT0gPqE8=;
        b=ZigyaK7PDybmGqgfDyWoy1SenKl2iX6RDoCpnmDPNtbpBnyDMyFCea+zp3H2MHqtW1
         MRwTjoCqSqjijqWbMrj/7JGT2wENGS4IWeTQb2nfOINkwmMus/jQNN9tvooAeNwtvqJ/
         ajL2k78p1SaVIm5bmqiYtHVjGKQTbakIIhbFoiGkZ9eYH0rEsAFuOCiApTwyHUe4b1DL
         T0/YHA6rr3hsgyY9yZZ6lnVKdHjfYS0HA71ycIMk11MxGV1dapMPWH6twHOwHknwPpEN
         8Jma8xbH+WguyCjDT0XqKV7EFXNiBVwT5cNprtEQY3x6FNb9j3RtoS2qfmlH//XLLkB4
         EdSQ==
X-Forwarded-Encrypted: i=1; AKwUvBzXoTAg2weNLGGvHhm7kt+TSAmG9CIok69sO/akXdIl1Bi551Gz/1MxxL2TWebJTLG+NeDHEGgqug==@kvack.org
X-Gm-Message-State: AFuF++l3fmv9MEnbfPEP5agCWu4P+gD7MJuul/KXXPX4RpgUgPFcAdba
	8SQAWuzXfIjvp7K+CWfu28vKHM+zBtj3tg2mDhsg8sWBfRONHx0rS2Qf
X-Gm-Gg: AYBFou1/z8un/AqXYnyIlzetIss0AOMvWcKlUfRWaFtI6AwOKeyLp+XKwpNHRnF1Sat
	j4q8U9BOw7+C99JoMG9Aq0+74Ds6Htm36PTO0cG5lMPVPmNlchF5goebI9vAocI6cY2HtE9smdT
	yPcUSqgJFe4RrSzGG3S4UWuR578J22XWXZR85ejQo7WbzCBZx1qkd9LzMmtFypDq70I075PBTuf
	REgL/AN2R0+LsIWgOvF6b2A2E8kAzmMQRIBbA2VKOOfRhaLOqOBiWs7+KrWLmg+9trVi6SQfWEL
	C+i8jRslhLALm9WQBMdwC4+X5gr3GsJebc5Pv/aGKWM/ogdzPqhlzgs2OcI1ShSknge5qtdJZJY
	dIL+yGZKiyFUpCdJouS2lHUlbmKDmTkpE1Q+hYzcPt+RxNwVZ9mZLHc6y5OyqK8Au8owEtc0xrU
	2ppWgCgz87s44iql5qodp1b0RX7PhxcCJzjRNDgEkU/XZq950e3MVuCURdP5ippYgyA3jDpwfqa
	Eo5uc5/rqYJ4pJvLougpX11Bw+UMac9ldaLlpK5qUAjRmBvOnceMDD4tlrYNLm0n+rD1OqvYYdD
	CG0roWBXVJFdcJuCax+t+H3dY6t4Z37U2t+qdCd4lixJdrVh
X-Received: by 2002:a05:600c:138b:b0:49c:f89b:f82 with SMTP id 5b1f17b1804b1-49fc568f8dcmr115799535e9.12.1789963345138;
        Sun, 20 Sep 2026 21:02:25 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc55cd8a8sm256725075e9.0.2026.09.20.21.02.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Sep 2026 21:02:24 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Sep 2026 06:02:24 +0200
Message-Id: <DLKP1SE3XQ41.2QNDF51ADS0ZT@gmail.com>
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH 0/2] binfmt: fixes for kres reports
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Christian Brauner" <brauner@kernel.org>, "Chris Mason"
 <mason@kernel.org>, <linux-fsdevel@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <20260918-work-binfmt_misc-fixes-v1-0-647b24bc1c46@kernel.org>
In-Reply-To: <20260918-work-binfmt_misc-fixes-v1-0-647b24bc1c46@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ABE891C0002
X-Stat-Signature: mkkqazqm95or8nbaifz16czniw9e9afs
X-HE-Tag: 1789963346-261353
X-HE-Meta: U2FsdGVkX1/QZVqOVgIyrHCXQoMz/uIFQE0p1kfQbqRi+HcRGQjNNXygtHXBZpRgWWkxpogljCylhmyrZldjawCMQB/i5PON8v8iHI+APG+cn8OemicD/yqovo8g0U+Rxu1dQnqABUyEuhZCQz4j6h8OnVLXH7Uwv2RbdLVtEA6NHcGTm4NrBtpDhtua6AFHvw5eGeUYHelSp5RYX6E8zeJ3CNO02/RhbrPm00ryQ4FWpemvlksfTRNP7UHu34lKU7DgPLKOSW1qjHjSU3DGOu7Wte9xH1KlVqOWtjnMiBx1MyUhd0P4U+oNOrvXaZ3bhYS4ybgG2Qe0BqI61YAJIracoInWs4+VYqprPv7cdHB4aPQl/J+20ykglaq2BZ/buoUknhKcGBZ4OSx2S1Aw0V2RW1UkHP4yWM3Zsd9iIDruEHxVDzEYrnnjIiMRH/5PHAwaBtLXmf0kr11tRv3mfy6Qoc3YYQu5q9U4msZcHyY3UXMBcuJ7RgqF0UIFUUCelZ9kmKlgRY51JFCoA+UTx8/5WxxcJ3v4Gpv/mi3WTVPEkgOmw8mOXUvkZDL3RxxWsDz/HkQi/jwp0cpb1ACd912R49wjHrUrnBN2s86ASzJSJI7KwpiVAh/FEwIu0geff5l9gVWQyyWv2+ryuAC9T1DkESJjcuhBh8Vdjs4EAQdNUI6hdnMY8Eo5FykbbMMKrKi1u8M8+MUlRhEbcu45Vd9BVSX64y5ayeqyvoIlVX/6jDpznd6RqBKEe4jATfzhYTlszb/FK9psrvXJVq4NEHVAR5SjKc097h5khj3ABTz98nAV14EYxX9wZpUH97Oz1oRxZNUqHBXwNoymDq1WNikEKHAS64BL3itnTnLwhwPvwC2izqpwNxkEEKjIA1fLmZwtbTefy7O5pNoqDA3qlRhce15I4aSwKkcBq1cTnn+Bdcy+zWgvQ9nalk6ovbOhJd8d9RPbeKfzOlQtM0J
 S1gKH7+N
 IfVH6WdrJKNNlqhoB24KVyNXgeux8g8wnd43eTW61bbNjDAe1aTBtWQhgjyZS5b/DYXVia6c45zD0Oz11NutyplmltSXpnPgohJlNznt8svJkGRkDKIGHAQ1CvSr+ePduqwHNjvNvJ/Ldkj4sUYUWJwQKoX/oT+XJJIvOOYcHBdi4sf6gLtnytbB/4Q4BR2nM7HVuUTxCZXLT2Uzkoj6LgI9G/k2N/ep0GS+6TCZUO42Z4A3iedMiq/hMXkMj0x8IdoX1gpiNKIQe6fu3PN7mNlYgwovqXZW3KgXMq2Y4kq+NfUDh/jlnBPhpLpm/NiJA4bJWjhQaKKHlWEyZ01Fok13FQyB3yh2f3cU3tGyZQsoueT9NdhQdkP+SUlyzGrBcE3ahx6AM7skeH/emmMsGcwwFdXq+Pi97uI5UxQGUiBsjblfcxokGJIs2+8hNiJ17EYw8Q06/Nxh3qX6lpA6iOJA72/GkdxE0LF1xQ7Y8m804K6bnAkQZfP7PCVuzA0+IY+sEKQ2adRcn0VU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Sep 18, 2026 at 11:19 AM CEST, Christian Brauner wrote:
> I asked Chris to run his kres tooling on the binfmt with bpf changes
> merged for this cycle. It found two issues that are fixed in this
> series. I reproduced both of them.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> Chris Mason (2):
>       binfmt_misc: fix OOB read in bpf_binprm_select_interp()
>       binfmt_misc: fix racy checks in bpf set_interp kfuncs
>
>  fs/binfmt_misc_bpf.c | 35 ++++++++++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 3 deletions(-)
> ---

For the set:
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

