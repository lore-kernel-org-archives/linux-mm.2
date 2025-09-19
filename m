Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A8B7CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 15:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 696308E001C; Fri, 19 Sep 2025 11:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 646B68E0019; Fri, 19 Sep 2025 11:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583198E001C; Fri, 19 Sep 2025 11:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 44E168E0019
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:05:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02F2814060B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:05:06 +0000 (UTC)
X-FDA: 83906322654.06.EBA0D5B
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1240940006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:05:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q7cQTy5W;
	spf=pass (imf12.hostedemail.com: domain of glider@google.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758294305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGxC493IbjEEger8hKnkve1PTNTnnMKtNGhHQrFJ6n4=;
	b=1c+SsuGPDBebLOk1f6OxGejGIx9Gxb2CTTo2jUDXtR2cO/njEsdj/UpNyEVtlERhmS7tdx
	GoN0/1nM9fOhk88ppe59OEUe6xzSrmTt7n6ha0INMKcJM3jv33FMoSXpUVPER2j3+6gzvh
	N005PwN3wcOa0/HNjeHjZybB6R6r0J0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758294305; a=rsa-sha256;
	cv=none;
	b=4BNGQS3YdNUY2T40l0rNH3JdDlp4P107Y0jgFX67i+zhzm1skk6pxx0lOprzLb0pF0vNND
	4TZJ8Un7V253Wsl/lMyVAhLGxx9TYbFFMTvuosCtSyFRq11Boi+K54sDXlMCXZzFwnHomO
	5wL99fFB0lViSNjT438j62GETGslgY8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q7cQTy5W;
	spf=pass (imf12.hostedemail.com: domain of glider@google.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-795773ac2a2so16728436d6.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294304; x=1758899104; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGxC493IbjEEger8hKnkve1PTNTnnMKtNGhHQrFJ6n4=;
        b=Q7cQTy5W+XY3pjO43MJQsxlogPvpvuVUbAuTuO4c9DU5hyigiF3iqZ15ZSNfDYT+gC
         /EkH7C2DVYGqtXW3g9gN/+SDHFhDBWaxHWKtpIho+5DBYcXwByhWtpyPQgKkTThLYtQS
         JmxhnHWpg00yfuvuKAUxU9t/YQmtK+LEBQPZRrf8GHPYJY9EHpeAvfCcwEhgQBh0EzUQ
         YYP2eX6G7GOw4S38dci9Y9xKrM6p0bqJemQj0o7+zg3zde53FLcMLXs56uFzX7WWe7dE
         rQ43meWn2Sl7Cfk0ePD01OUGagz49IBsb/jXDGRrf0dJhOfXuZxuaItLeV6qTMJWpfzq
         PmZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294304; x=1758899104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RGxC493IbjEEger8hKnkve1PTNTnnMKtNGhHQrFJ6n4=;
        b=pwu9sLBL/4WQTTG39hRs0v4vkOhxa9YW2U1TwuvhcqNaJzWMHSukyDQTxddN82ySuM
         oXuJUEXb023B8qRvtem7kbeW3shUAI5OKrlMhvGrkLSLeLOPcWmV29t1SzZUGTHCqcrG
         iBGSA3KJkuVUWvOHnPAdFc+nsVmasAdA3N7zivk2g1OSQEgD/wzdKUNK0WwDtxF+Y8f7
         nKFcYkxduTaCmMyFHHOWVXXV1xnRTM6kctXKHm36JE9ZbfpJOp2MbJ91wG7OUH8/X3nf
         GfbViK21qaj79U3T3gwTgK70NK97Wl2CTTbK1NO5ywXkMaxoCFgHBdorfFvpy1PA/5Ef
         cxwg==
X-Forwarded-Encrypted: i=1; AJvYcCXgAkC7jALWMrISW2K3yGxjrJ4hi6FUSRRYYWiDrceYESm1hLLcia8ekZSpYUDESy3UjzqbLSG+iw==@kvack.org
X-Gm-Message-State: AOJu0YzU9O6Olf0vUw8DwgdJmUzzSeFOutJP7g+8tMw1qH0gmaxkZFdm
	nohVhfLmvVA4c5nG2fegC/s8yRgjWGzz/X3ygoorLtCIxMzWsJXLpErCHLPY6O8K/M2VaGuy00F
	78TAGok58UIsjI+g+bu/z2YzWpmeaR5lMGKZsCvgN
X-Gm-Gg: ASbGnctqoz4kmw6rPhSw+YyjtkU+HdlQXrNH4V/Q77ZQ6zW+HfBausfc+/qiaceCKTT
	EB3ZHH9JaNvX7TxXSn08f47dxKcnEuZ+jlq1OYvvYHXsvuIfmvRMh7R6v34QxrdWe+x7dfMBDiV
	KV9Ws0GlIEoV/KSYAoZlriYKn0P+CE59nWnYgpoLnt0JLUC5WZpmIKOJCexON2kek1CBr4cSkAY
	By7nxvfFwvUGuV7ld+2NNzEt06UhQunbT/DMA==
X-Google-Smtp-Source: AGHT+IF48Qn9P8ThM/E5RZW+mTL5SaGErQDzvl4ZKUA9/53oJ7O4E+LJZwUwDw3pueAy5SweS7Sy91A5mlwWtXOr9SM=
X-Received: by 2002:a05:6214:e6a:b0:747:b0b8:307 with SMTP id
 6a1803df08f44-79912a7799bmr34142706d6.26.1758294303181; Fri, 19 Sep 2025
 08:05:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:04:26 +0200
X-Gm-Features: AS18NWDNOJ80ZgwJUanMmHMdQpo3tLnLB0-s453y8IuyYBCYAQcCDLNYEOTyu6E
Message-ID: <CAG_fn=XXvk-okceUAnpwkk5W5kFLecyoNJcVU9Rb3g=M9qA8ig@mail.gmail.com>
Subject: Re: [PATCH v2 0/10] KFuzzTest: a new kernel fuzzing framework
To: Ethan Graham <ethan.w.s.graham@gmail.com>, shuah@kernel.org
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ckw4w6zbngndtfrn1ipbbnbrpxsyquht
X-Rspamd-Queue-Id: 1240940006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758294304-624861
X-HE-Meta: U2FsdGVkX19V7Qmko0m7kq+xPxAQ9BL0JI+VTmx1lvWmVt6CNAHkCp43hfytAabKksAUFywhlUoZ1CISQ2PUrEZlLNIEhgi8dV0SJ2YxccsMWl0Tb6SOmzLgOisDUxdsPQmtbQ+dU+KUqCgUIDYxAYK36OEw9tL78L5nSVWERcbV+mwgEE1Se+czl8JBM7le/R+wipiVZcZc5kmgM4SXW6eakeoIOTBdekrGogxErzBHiUlZSzfy/o7s75eQk6C7flORC0zzRGriNkti1kiyjtoxu7b+DpoH3YEjF+ObvvZRMWwhNO79gdnWS788qao5g/bb4rxPp08kPxAnT2yobwVSMxiW2SJjN9Zpdwn7NvFsVwBW+wOrT4FI6wqX2LBjBR1CrbhU0GJWBQwjeX8z5oDUBnoHUml5HHKWB/BrlJYibVvjqI51Q/CTV4kDg5wJ4Cb12/MWysRUXjbFeP6bFqd+sC0ar4c3TdZAvhMrsp5K2OnOZ/neGT34pQkQY/gbIc6fFCeNQzgDwqnq+8TMphknkU7gtTDD+T78oy7kiv03Gm880tZ1TniU2g3pMMqApLRS9ws76Yx7zbZQfZq+8oG2YOCrGtVOQEZuFeZdKwqeluRL37PiYaH3nPDVW9M7MxuxFVzjteJjj3Ba9ofoTc81czypTDqUhtyX1BFwhmePgo+OVKqJuofkOMDXrsHgAXzxRUa+1swJoX3wSfS3LBQGds6osbtRx/dVL+c+52TzXwgYXOsaBnLb+JGgVZPVzBmGJJSog8awXhwG0kID19z5GPTGRPcaKP6Fs+vK+iNZmDD4eq+JZZjXsnV7IzbYhls6maabdL/WGTNOgNpk0tuwFD1qr0jG11pyxGMTXBqwbJQrVFB3TI2HwjpvZkxqdOQsIoR1d+uFy+2vEMPQHygZQxdWSSOa4mLh5IKsVJBhyJxRf0Bw/VuY/B/eXAW8mZz95O95JTKWZDGm3pZ
 MEh5LHaj
 C/o5MZ+gCkPSeNunuVsh0sA/qAT2ZrR501v9+cEp5zNIK75WPhSFupW/Kf7kuXhXz/YM8igQDEGWwvRH93ywGlnSrMdeV3qgTi1P1wLkKxAGKv6awXSekHcyzvxS9CO4rV9FQZmVMoMbXiyiBfXA4Izxrhwa3T4cMNFYVNEYHI92W8HbpkymzNL1nxK5En22PyyJePjQyrCtsF8JYcdwA76ukpAGsdTzrQB74RG+NLCqgDEu+V7vITtki+4gflUYdGIYG3QP2HNHQg8FzAE4czTOnPzhTmjdkjcOJpmOKsFEyQy6Ps5/AdEKPGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> This patch series introduces KFuzzTest, a lightweight framework for
> creating in-kernel fuzz targets for internal kernel functions.

Hi Shuah,
Since these are all fundamentally test code, I was wondering if the
selftests tree would be the appropriate path for merging them?

If you agree, would you be open to picking them up once the review is done?

Thank you!

