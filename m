Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6804BC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:52:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D79F6B008A; Tue, 21 Jul 2026 04:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488BE6B008C; Tue, 21 Jul 2026 04:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 352A16B0096; Tue, 21 Jul 2026 04:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6316B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:52:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89FE11C02D0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:52:45 +0000 (UTC)
X-FDA: 85012168290.13.4AC441F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id BC9E010000F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:52:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QaQQN6Li;
	spf=pass (imf05.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784623963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HycQ/24U0Dvfa9rYEhTzBVd4Z8wFBY/G9IvJddSNUb4=;
	b=Hp8S97gFfIJ1uNcNEVbZqdmFIK7WBWQn6nV4ZdCqHe9TMzyUg4SgBrseV0SDYxoepCrj7h
	v6LCMPi7nV6BsTTrIFInA/0QAYMO5MCmW3RSYUg29LPU+9Q8+aZCKMEO+lZuBUR1l29rPE
	TIZ/KYL64hFMSDEKoEtF44axe7xa+Pk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QaQQN6Li;
	spf=pass (imf05.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784623963;
	b=AjAgTVJvmCTTtpQ09hfZBsC7HH2VXN6RND88we4T/EHVuJCqd7hpIxo/OoQNWMoCh2oiPg
	dvIUsqvog5s9IUCw+QT2j1JCXVCggAyyaEiY1LNbnK5MceKPuqriqt7VuCYA+saaZSkL9A
	6XZwnsFGfErM32XhCMZirxOyCAjpbno=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5284960A95
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CB51F000E9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784623963;
	bh=HycQ/24U0Dvfa9rYEhTzBVd4Z8wFBY/G9IvJddSNUb4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QaQQN6Li5L+AU8DEPefyXXdMjMHBY1IHVUIvzBV4pRo5eDe25VfkYoTpgY0hEt29u
	 pkVvZgCkfLlMgUBDDeccY9j6JHmCdSkYohdi8H6+5uACEV+fNLRL4OD30huuP8VgIu
	 loAv7Cg+9XkloP3Pb8ehYPWpHXYqK2PlEg4djUVbOq6hTNjFzzC1yfW7ZQr9HDUdOI
	 bgtDXDm+e2kNK5IAx1QXAH334yFbGYDqxRhXPJWZu7YqG3crVrYoolh6nyIwx3JFQ8
	 jwBH9cYXlUHOEYu3vikybPanfqZ4HHPdz8wrxWhRW6JPMY1Ht9da3keTiQ/14K9hI9
	 PN7BQxmb7zNag==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b015b2d792so12676929e87.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:52:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqoTo36vqDhiuWa6GiJKLchWyEenv47Ho1UV+2wKiHYMcEoudftPgeJsbsmAcPd791++tv2c44QrA==@kvack.org
X-Gm-Message-State: AOJu0YxV+waHtGtWnUyVDnrVfiwVpdWxMkHbScYd6BKHOYUVuPYUU3pe
	YrNI1RJVyYzrJTUgPtTF4IUFTDVoWYGRIyhun9W7dp3plxSJh50/V9I8wsnT4J/K/fDUTngbBAn
	xfVXU7l6Y1yM0QQlG2CC301JK1wuJb0Q=
X-Received: by 2002:a05:6512:1156:b0:5b0:ce5:a04f with SMTP id
 2adb3069b0e04-5b28face409mr4587541e87.61.1784623961856; Tue, 21 Jul 2026
 01:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260721081858.1169276-1-ruanjinjie@huawei.com> <20260721081858.1169276-13-ruanjinjie@huawei.com>
In-Reply-To: <20260721081858.1169276-13-ruanjinjie@huawei.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 21 Jul 2026 10:52:29 +0200
X-Gmail-Original-Message-ID: <CAD++jLn7ogMvgUdQA+yCjzj2OJDj_v7JDO=mPnWxqNUE7oY6yA@mail.gmail.com>
X-Gm-Features: AUfX_mzXSUvYI-AiEHstTcYri4vC5EAAtQ9xFqLJkpR6sHINZPIFjmFDc1Yxrj4
Message-ID: <CAD++jLn7ogMvgUdQA+yCjzj2OJDj_v7JDO=mPnWxqNUE7oY6yA@mail.gmail.com>
Subject: Re: [PATCH v17 12/15] arm64: ptrace: Make return type of
 arm64_syscall_trace_enter() bool
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, kees@kernel.org, oleg@redhat.com, 
	luto@amacapital.net, wad@chromium.org, thuth@redhat.com, peterz@infradead.org, 
	mark.rutland@arm.com, ada.coupriediaz@arm.com, kevin.brodsky@arm.com, 
	yeoreum.yun@arm.com, anshuman.khandual@arm.com, james.morse@arm.com, 
	tglx@kernel.org, broonie@kernel.org, pengcan@kylinos.cn, ryan.roberts@arm.com, 
	liqiang01@kylinos.cn, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BC9E010000F
X-Stat-Signature: b1iio1woumm7uhyr38stbinfiju9sjza
X-HE-Tag: 1784623963-786162
X-HE-Meta: U2FsdGVkX186BYTPGllk1eMthgqsxBFNg7GNNl0oueNPiNcVJNtjMLFrbHC2ZPtCV7zrFydOCiuDzmoKGySWbwxhwN43Ico7BfoIcr2Kv5hvvi+5OOSeB26d18+XtYpSY4iCuKLd8edb7D6LTdDIiMJB5n5o6NQH4h696QQIFfSj1NIat3oUvsglCrzJScZbHMqtC0e4pXjqU/xCFeRwrX2uTgnSHq7QMWszOG68r8bz+B6dpfWK1Y2u0MTYXLUXhzkddwXRhJG7BMN02+u4KDFkavRuGLIt4iVu7NdUX6a+Am6MBoKjwQ1Aqnb3O/mZCUE3QpRjCSjyRW79kYGC3zfNWcQ6//fvKRGjvRJ4GSvrvBEMkn0rSQkRUsOcGKE1sK64BcrQyNZhDhHzq/cYrKxvPnVGvsrkZBBnZ2f2Gm2OqOn+LRD1YlO+HM7xAFvSMofNjYLVUUBJIRuMR7FV3EaJFWxRrACsd7rBRewPepVLR4qirNOHo/HsYwFMIEHovdF0JlEJt5K4cYZDJI/hLXSQTVzXAwazmtm+aMjaDpTGbYsA6Xb4jqLggEvScSXdgEWIqJOIFQYFBrr/PHQYCqFhXyA/68BRT8ODT5EhDUyN77ZcGACqEF1XroVxLgCydxgFY+evj4aGcxlcXrmfRbwDIZQc7XvVqdEiOwJV7d/er2/wFnOYuDMlVxNlOVeoypzEYS6o8L8hFnhd5HkGHII/Pf68XB+C+QVj0TeAzFgwPZAqtg2w3gSwMaZ1bGdBUdSbiTJO4qhXt63N//jWjb5igieEOV0Vq7hZBBmQFQj9nOTFXjOqaCcw3YiC9d2oaU/qKHDyaXw+xwc92z4al785/M6BnC3m15TkOLtrckvsEcaHlsTvVryVJp0tKu3dxgukN0vd4cICYNk0kzBIbx8wPz3RuBWeWh5UwgGJ7iYHbm2srILBNorcUJ5djUR9PJfbAiYT+N27AfsmPPY
 /5+KfEZP
 isa5QgtFT2G719hhTrH/eRJRTCizhSYXn5SlvF68m1lXti/L3j1GFuqJcV8s47bGdZjh8/99mDHaXNgzWO1ixx2Ex13UeM5NMz1NFKr9VHt2v5seOS7BIDKA8wUtdN+9j+rVN+puHW1aYSztRfa97A4xywDvmIh2SxY9dRaRy1eIrhzAEZHIA9xlqcPsaZ8gJ4XkC/E/95N+fjLGE7gfHseTIf6zzKayB3Of/2va1w0re1ZJg+VKOHYZUKVB7XHskK2VM72MdhfSA5I7n9s2JWKJvcANpj2VGZf2S71fweSa8BZmJLuuUM38x+bngQFnaS1OyEHIhPubgcqBHRTZyioxNFZbDDvrwOziRmFnXVwQ/dxLDSWpPiXx+yUf1yLxhxUh7Fg1uKy9wb6FDdaqPzJs5ujd1yAYA5PkhkTDJFzbuRCf0HxDHf6rQyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:19=E2=80=AFAM Jinjie Ruan <ruanjinjie@huawei.com=
> wrote:

> In preparation for migrating arm64 to the generic entry infrastructure,
> decouple the decision to execute the syscall from the syscall number
> itself. The ptrace and seccomp now returns a boolean flag rather than
> overloading NO_SYSCALL (-1).
>
> Changes:
> - arm64_syscall_trace_enter() returns bool:
>   - false: abort syscall execution
>   - true: proceed, with syscall number reread from regs
> - If we decide to execute the syscall, reread the syscall number
>   and check if it is NO_SYSCALL again. Because when a tracer sets
>   the syscall number to -1 and provides a custom return value in x0,
>   this avoids calling invoke_syscall() which would overwrite the custom
>   value with -ENOSYS by sys_ni_syscall().
>
> Behavioral impact (unchanged):
> - User-issued syscall(-1): unchanged, returns -ENOSYS.
> - Tracer skip with custom x0: unchanged, returns custom x0
> - Tracer skip without setting x0: unchanged, returns original
>   argument (garbage)
> - Normal syscalls and seccomp rejects: unaffected
>
> No functional changes.
>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

