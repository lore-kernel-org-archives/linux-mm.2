Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D570C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 02:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796916B0386; Sun, 16 Aug 2026 22:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745B56B0389; Sun, 16 Aug 2026 22:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633BE6B038A; Sun, 16 Aug 2026 22:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AEAA6B0386
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:57:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E42F80621
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:57:24 +0000 (UTC)
X-FDA: 85109250408.13.5A9FA0B
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id ADA8940003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:57:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PxS9abpt;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786935442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3E9pfv5IoCCsu+3HPCYQctwF4eS0EkJccI7K/G2Hrfc=;
	b=VydiaiuI1VKEAnR1xkUW9W4OFxzhgpK0FPwYOIJLPSlV5LIpuEP6rv0pu6Z4IVVcpe4PcN
	Oa4gVGXV3Tklw8OzD6DyMyBT30ar6JSZ9+eqXyZR2gKjEbQ/UIESAss5SIPZjVZFJ3DLIa
	AsXmvgveuHTGp+WsfwLlEyIdfQEz5tA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PxS9abpt;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786935442;
	b=cqPdt6SPFcvo+GQhW7dbj9ZlFue1/bLOQJjZ68vQYasMolR+RcrZgaaKScIhtFCK4kkdR9
	aFH4ynWwK0aLBYuioRHlU2DHj9JULitF0gpM+hUBBVmq2AgQfj/2hzpz3j8v1ot8ICWy4F
	63XjZXAarVz/0ytP0qhTjQlHHvg79wk=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4954a2e73a9so20276585e9.3
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 19:57:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786935441; cv=none;
        d=google.com; s=arc-20260327;
        b=RdeeXl9YU4oQ+ZaGiAR4BdVwLYf17r62nxEp1EtSZEJEYG2P8LKxPtVA+vR4KtBjWi
         ov5c6eWK/vDvOD2WQXpe8uJY0pR3zFfFwWbl+7QwvI6eR0SxVhlbm1LQDFKJfz2/NkPw
         yVudgayEeK4SfNQVK+e2IE5FPCk0P0/iCQ9lGZYgMJmDeZZ2Wjl2Z9VC8vV8mHLcpkgK
         moanfXJm8JjarkXWRTqYsUJHgKjXmkpHstXNBzJTJ8Jp/kmP53KDk8/OV1WWLhmDWPar
         6fhc+YSqMAFE/gO7sfKOSn3n8rX+yiiDwoiBfaEksLtA7mPWES2ZjKLqOz1K6p7i6Z+K
         PzDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3E9pfv5IoCCsu+3HPCYQctwF4eS0EkJccI7K/G2Hrfc=;
        fh=Vz31jefDCUutXDFDSgOoXBe6gAWDzzEZBZfLTQT1IDQ=;
        b=LTNjBCRZiGhIKmjH0REIyhvmYYz/1VZ5/ocX+tyar2K4lMY8MturT+hhQhZkM5c5kw
         ZYcsjCzoxknaIG5KgQ6a2Nw7NqqE6qGFU6c7sjmZTbjb/ig79koLU2DwRGYshslt0Cih
         I2ks2comYuleo305qPktJtfCYp6ZF/ZnC3q+p/PcmanisSTvLafqnwoHgj03rwK2BoA0
         lpVngMTRlFq7skk+7aEnNGUYS3rEY3+DUyDlNVBvBmj+DKw5MpwFK6nLWSErSmLYegR5
         uHKiQx+yLN32IVLwelFq9tF70/7EEbyg0blrJYWnPwyonNLFzUgOK4qHXO6JCsUSk0FM
         zEhw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786935441; x=1787540241; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3E9pfv5IoCCsu+3HPCYQctwF4eS0EkJccI7K/G2Hrfc=;
        b=PxS9abptkpdxnKsGiUPGP17zku0+2SitO9cWJnf3rNwoI14clhvr0x0AO4qTnz2LMi
         ZOUkhqPcd9H30SojCD20tG4WLg4T0kNnCaBi77twkcVg4bIuE+McCy1i87FaVlCzDi8P
         kO6eswzweG7ts3Lskln1CZpLnnPYXemb6fQ3OcAP2vrjZzz2Ax3VuzK4HVxcyMhyy7To
         N7GUeXlNromDo66z5skVl/K5EEoQS2CMpwmwWc7idVw3bIfaMQOh4swtteF2FJBYawYq
         lUCGRmRuK8Sm0DWIe0xm74ystSyvQypIr1oH2ppqecoBW/g7rZG+clgJwqGK72JPDLK8
         ntYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786935441; x=1787540241;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3E9pfv5IoCCsu+3HPCYQctwF4eS0EkJccI7K/G2Hrfc=;
        b=JFEXoMaelL0CJ9wO46qbQbq5Rc7EQQ0Z+2FJkAz+dNN0iLUpNAjHoGKgOc43AVZqT7
         0TneVbmqABIUP2a5HZtJx2WKbBoiGIP2IYj+lP6cF57+ctnVZr8TB3riR8WUaaQhOiyp
         oTf0s1IEPfbBIzB+1x/0BiG5+/DnYPI6iGlXTWAGd9wtpcEUbOhdNPg0GStA32nMSwwN
         QY5R5raLYXkpy42oWUkLp+EYUh+CbjIVK8yQ+AGt1i14SNSfJZ23hhOGBTsa1N+DO9Mm
         kJT54mMVucKC/hj4JWKiF/pBfnJqXI7ZxBa8zQfjiXil/RvzRRg43a0fc81hmxd763TN
         PuHg==
X-Forwarded-Encrypted: i=1; AHgh+RrNzKtcZYGT/p7xspl31CQtyHFur9GRu7gPZlkXiO//sUr221KPrKdrzP99ynec6wKSApbfuABTIA==@kvack.org
X-Gm-Message-State: AOJu0Ywi+AzpiMgwpCU5o6iCoUzttZ74ChOgnvEDuGMWe8KE7wA5meBm
	t8kiKEgSBfkD/tI1J1V11QRZY2yXcDfP0RyrAwEPCwH8byyUgRcAcFewvYdwVGEh2pEj87Dd90Y
	qCb86zxh2WkD4Ov5LbY1C1bUAvfqd15o=
X-Gm-Gg: AR+sD11FzKcV/DkscRxnclD6Lscd0q1ORWo5pY3RsGuEznohXONvPZF3gu+HVQfLZ1Z
	H6eJt3yEpLSQOwiPh8DL94OasC0+wvNpCsifCb1bQSl3B6XwqQud3oHFCXm0xZOPFVZFTgiEfj6
	WKZjggonPklvLww7LFwn9iYx42V2ePmCJdyc+zpTWncEaj42n/8xGyfk1BNvzIKv1+eiVlFB4lJ
	ISA1RROHNkoyIvyMu11K+/tkRR3cLO30vznqzBK8ogZjJCepS7lReP/nwzahEuM5+iNVbPEPh44
	6oCGkH8QfLyB7FtAMv3dSF1aeEZyxVK4cQ3RDKd16mldZTGoav48cPn4G3waX0IvfVh6CaIzD5z
	hYQ==
X-Received: by 2002:a05:600c:4e13:b0:498:11b5:3ff7 with SMTP id
 5b1f17b1804b1-499879bd2e1mr332951265e9.18.1786935440695; Sun, 16 Aug 2026
 19:57:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260816142222.689624-1-kunwu.chan@linux.dev> <20260816165630.84808-1-sj@kernel.org>
In-Reply-To: <20260816165630.84808-1-sj@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Mon, 17 Aug 2026 10:57:09 +0800
X-Gm-Features: AcwNN1Wv4FilngBM7zb7KtysHXMyaR6NdUjrcCRsxZOtSQWQVLsk7gEZuLi0ywA
Message-ID: <CAN_Opa-aEvmx7Y0xPXHvhaOurt2-nnDMxLjGaHCdMXDsQC=2Xw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] mm/damon/perf: add ARM SPE AUX backend
To: SJ Park <sj@kernel.org>
Cc: will@kernel.org, mark.rutland@arm.com, akpm@linux-foundation.org, 
	shuah@kernel.org, kunwu.chan@linux.dev, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	lianux.mm@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eyyzfh75fsii4ykw7rzso4kecj1wnkg3
X-Rspamd-Queue-Id: ADA8940003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786935442-490057
X-HE-Meta: U2FsdGVkX18yjKx0zFKm0tGqsUJuXE/+1btkEn4iB3BAsSx81wNoOICD5fHJgWWRN29l4qJZDQcFG08ZEWxKK3+3lH5emBoUatQ1ZkCcz6yplerJEyyNO2B77VN7575gZpnvp71rL51mjjviHPvBroySNLhOgjoOxRaA8tEEUwHAU96XosG4JowS+ev0ZFYBtDBgHh2gNuMH6KDqHFJTNixlkG0o/ob5zaPda7aCVTIeNGATbGFeAhtgEUT7TQiDW1MANGInqulYwd7rxLbUr8z+aNJtzrY6pO8EK+c/rgI8CRhnrRrocquxUYW0dNOWNWznmuUAwQJqNo4gZkELc6FG/Q5y2Z2a6ZfYKhZ6Ooo/ZvHUHY3T26WyI4RcbjsrL9ShfFsW6K/1mgaRS/a/XAQg8Gv/0JK1s0/pSkdiw4nDncc/9qZvxnPiGAzSNZb1XCGGjxypi6+nX7gkRBbBMGVyH74eEk+4scZZZCJYkFNJ00IsxKK058La+fW6jRZryPvk2M64BGfmr9netQUFL6buN2wWQrI4nX0ta8pTzdQBHeKCcGzbZITXZIOzxIcZFmKEv6BHj+9OqAfiDly0U3K6C3bkDYjzuu2znQFDIQGxWLzrN0NeuPAW4H6lP8wNwkakB8YBf13YsMTP26otiZ9OlxoaCms3R8YAkAlt8CnYBltVd/nW3oLWeP3wXqg7RidkYgwSZQan2K84IDdY3aaAoiCcdY7stsPFq+e9mhi8m5pjMF8J+GuQW6nKRiO7v8WLNiGOM8qy4f7QzoRsEKtbYJhDRXVCMn84M6Eyrf2pSOLioTAn+slXx9jj/bdErjcG5R37Gyf+gzdTuBkidy04r9LCFA7jC+L+qQfHZZNWey5QlIn5xd/PBpk6Dq9fSLst5BLo2xhvsJQ/Uw/reiR2xMJ+M9E7urM2qKHMO9jMa0I/oIvugMjoHc/aRfa9jUpoQPf4w+Pdu8wQ7W2
 eiuFLvW2
 rZREqX8V4P9xN88Vl5t31jW+UTqYYA7gPcTvG0picDqbOzo4qxud4hnVRthf+1MwfjRi2Vo2+YNO+eM6F012H+NYqNWdaPnAfziXkY6fb54eUtdxGf2SFsofpGsrgton6LVh7ojT21o2xlgpO6G1sJ+7GhlTeEtln4+outipHD851O6ysOfytRoa1jkGk1DdBNcu1YgXey+8ySfS9aIVJQoIyQPdEY/b8RQfQgJDYiEFJK744Vx1PUFHlCJNIOvYvqIpFvrjw/z7rN6p+AHRBeEo/WSOtB9H0aoGsad71c+RelpdWnkiJqNW0fGfa8Ixj+ocw/ZwFiqYC56vUm7uVT4ULavT6adoo0vMbCNXHpI0lxR3HIi/6r/cQnft877f398I3o1+ojbpYqD6a8HCQFE5b9S4OxVbNRwhUc/EavqifrxjmPg1VIAx9JT6nzpcQnHnk0FNX3pQzgYtgYi1n5tj3fay5m6TB2rMXy9D3eoSagErbPE85X2lA9+uo5mC5rjO2//8HiKiZYB72u8KglPNd0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello SJ,

On Mon, Aug 17, 2026 at 12:56=E2=80=AFAM SJ Park <sj@kernel.org> wrote:
>
> Hello Kunwu,
>
> On Sun, 16 Aug 2026 22:22:17 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrot=
e:
>
> > From: Kunwu Chan <kunwu.chan@gmail.com>
> >
> > This series adds an AUX trace-buffer backend to the DAMON perf
> > observability framework, enabling ARM SPE (Statistical Profiling
> > Extension) to deliver hardware-sampled access reports into DAMON's
> > existing SPSC report ring.
>
> Awesome.  Thank you for making this.  This will make DAMON be more useful=
 on
> ARM machines.

Thanks for the feedback.

>
> >
> > Patch 2 touches drivers/perf/arm_spe_pmu.c to expose the PMU matcher.
> > This change is tightly coupled with the DAMON AUX backend.  ARM SPE
> > PMU driver maintainers only need to review patch 2.
> >
> > This series is based on the Ravi's hardware-sampled access reports
> > branch [1], and depends on the perf AUX kernel-consumer RFC series [2].
> > The dependencies is not upstream yet, so this series remains RFC.
>
> Unfortunately I haven't had a time to thoroughly read the dependent patch=
es.  I
> believe the basic idea of this patch series is aligned with the ongoing D=
AMON
> extension roadmap [1], though.  That is, this series is supposed to be a =
part
> of the milestone 3.  We are currently at the near end of milestone 1, and=
 aim
> to complete milestone 2 by the time around next year's LSFMMBPF.

One clarification on the architecture: the AUX backend is intended as a
transport/front-end for damon_report_access(), rather than a separate
reporting path. spe_submit() ultimately calls
damon_report_access(&report), and the AUX path shares the same SPSC
report ring and kdamond_check_reported_accesses() consumer with the
existing overflow-callback path. The main difference is the producer
context: the overflow path enqueues from NMI context, while the AUX path
enqueues from kdamond process context.

The perf AUX kernel-consumer API is still an upstream dependency, so there
is no specific part that needs your review right now. The implementation is
already functional and tested on Kunpeng 920, and I can rebase and resend
once the dependency chain is ready and the relevant DAMON infrastructure
has landed.

Separately, the DAMON perf observability framework
(CONFIG_DAMON_PERF_OBSERVE) was developed in parallel with the AUX backend
and is already implemented. It provides the observability infrastructure
used by both the existing overflow path and the new AUX path, including
per-CPU pipeline counters, debugfs statistics, and tracepoints. This work i=
s
independent of the AUX transport, and I will post it shortly as a standalon=
e
series.

Thanks,
Kunwu

>
> I will hold review of this series for now, and take more time on making
> milestones 1 and 2 for thier planned delivery timeline.  Sorry for being =
a
> bottleneck of your work, and thanks in advance for your patience.
>
> Please feel free to let me know if you have specific parts that need my r=
eview
> right now, though.  Otherwise, please make sure this is aligned with the
> roadmap until we finish the milestone 2.  I do want ARM SPE support of DA=
MON.
>
> [1] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/
>
>
> Thanks,
> SJ
>
> [...]

