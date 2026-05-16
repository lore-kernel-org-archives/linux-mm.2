Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B137CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2D66B0005; Sat, 16 May 2026 14:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7AAA6B0088; Sat, 16 May 2026 14:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69FD6B008C; Sat, 16 May 2026 14:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 984196B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:03:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4468D1203A1
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:03:40 +0000 (UTC)
X-FDA: 84774055800.20.9632E8F
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 270A640015
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:03:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b="RuA9hPn/";
	spf=pass (imf04.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778954618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGwTJ4BAHlzloa9AqYm3GmL0/jhInuFYHO2ONjIcdOk=;
	b=IiSC7BVl5sTE9tK4w+QDQuOi0MXlnB/LZdzCeheLI4DAPt4Pvh+KLm7+MZKEuVnnMtz6ij
	mFF1Zv17W2EXYVsXUdXodhIx+3zE0zk2gIX5QBq0UK1tVmnBmBJUbcIs5wXtTRCYQTRExG
	XAlRQW3OqYb3K4Z1boMQbXvhrRoLnRk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b="RuA9hPn/";
	spf=pass (imf04.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.46 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778954618; a=rsa-sha256;
	cv=none;
	b=FWBeIAkd6k37uNfuPb8Ivt/b8ePoEBmj0W6SLjLMdxC5DtwvLzpyFVU13SHIAi5webFT8f
	na09VuGlY56Tmh3L+3Ti/vPRGAQeqiUWwkVlv09X0DCutuFHRvxvO6e8KqOmrLnX4MKycC
	eeRcm5DA/W4Mpft6WeWfhagfI4/caGA=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b9d9971d059so137187266b.2
        for <linux-mm@kvack.org>; Sat, 16 May 2026 11:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1778954616; x=1779559416; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yGwTJ4BAHlzloa9AqYm3GmL0/jhInuFYHO2ONjIcdOk=;
        b=RuA9hPn/YyHAhSAsraLeZdmWNQFqQT5TYuJuIQoDSOQyl0nTP13y/ioSv2Gg1O6EIp
         iiw1SzpoqcJqWy7Ni5QVJK4mNx0fuRLOHUSZGSzd1PPIVmvYgdOApyLlTDgyiQJoYnpL
         WbekGTfwtUEUjOGKRT8ev5Jkj5C5z64raD214=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778954616; x=1779559416;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yGwTJ4BAHlzloa9AqYm3GmL0/jhInuFYHO2ONjIcdOk=;
        b=crltyVvXaZ/QGwSG+9OuNDBS9vZ1LC4zQ0MQiu2n7Usgvt2lwP/qQgSL7fJNfkdlCT
         urUNZsn543Hhyry2oNxO9CMwaX+cY+IGSdcni1T7vIO7gx0jadsaxu2wJc1k2ER4g0fD
         3ytJezwifFqcjoYrNnb64gfQmVvSrVEvD0GFxxVOqnno4sY5OrTuYQPH2rYcaUOvg0y3
         YjN4MWBTlODIZM4hzhew9YrrkWqmXWAtfih2fOYgwqj6/atobCclxMzgRpRZBZqTXb2o
         c4OCDkw9VArsFHHusMaTQF2V47SZcQPrCgMxk7CxuG2abN93sDwx3LgSRglKKec05Hn7
         uvEQ==
X-Forwarded-Encrypted: i=1; AFNElJ81cTBRUkwb1boA5NMiTXRAmUeAs2dZw81z/+dA2c9XyVnhkGo5vUFz2Ttw/MiG68yENGXPHSc8iQ==@kvack.org
X-Gm-Message-State: AOJu0Ywp78GIBB4dHoddwfPhOF60fyNmhjDMW82oUne7rOCTbeM9sr4Z
	hPVepx2eyQC1zXLHO5ewpuC8P8QC4xfUaXFZApFIaNsgKqvxhvVhBMGINHf/ZLcAg3WL2WTMppq
	l8b4C7MaWYA==
X-Gm-Gg: Acq92OGpQp2BzauTbZyfQf14ahh9CFVqCq/orzEWhtg1Zqc2MwVAOQ2tK0XCVchSuxg
	T6DcyxMOVlqwmCYBk9Krv/NVOsu1bTKmuJKoGegS3h1ckHJISeL1Mx7ZIHZdn5CWLqTG/wCe8U1
	18JnW0QctxSMmqwmEvcThB3xhEf+n+q+q99BCM77AdR1PEwjVt6afgcIi1OwBb/H6mLf7U7ydSh
	LwNp2xJu3Tl2c55XmgTRaDTD3fmAQz5mCM1uFkSlH/FHxxDLbps56i2a8Gp4/S5TPrWi4umLJPu
	Mt+wK6GHv/Bt7RDnDnMTDgDpn3eC7zcTpLMA+tQPPsK9zul9wRgpgnR6T//E4dFev9LO/wbVKcT
	iJ6arJb6Qq8p5kKgsAk7qhl52l9f2qZvO9fLqZTWxaXpRr3Y47T28o+yeeBQxDTumKLDoUJzdUD
	TU5QzrlF8syceMICLJ84yAHRW00xSDa6KgbkNKDl/mKZBiwbiyuTISKkRwIuI20mxjnTOD6Y4B0
	qaDHtV8cwapZnh6faxe
X-Received: by 2002:a17:907:804:b0:bd3:6a05:459b with SMTP id a640c23a62f3a-bd517972394mr484611466b.34.1778954616392;
        Sat, 16 May 2026 11:03:36 -0700 (PDT)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bd4f4c2a68dsm377769466b.18.2026.05.16.11.03.36
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 May 2026 11:03:36 -0700 (PDT)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso10763185e9.0
        for <linux-mm@kvack.org>; Sat, 16 May 2026 11:03:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/RM9GTVoJ4SplVGqITzs5KfS1dahtt7Bth+rpnK26UMO85zD0ciPNUhAQaZFsB8x4e5fUQD2oajQ==@kvack.org
X-Received: by 2002:a05:6402:13c2:b0:683:1cc8:84a8 with SMTP id
 4fb4d7f45d1cf-683bd28ac44mr4486474a12.12.1778954312490; Sat, 16 May 2026
 10:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260516-work-exit_mm-v1-1-76bcc7c2439d@kernel.org> <CAHk-=wgvUW=1qtJxYcvbA_WaTom6n73nT7S_=7tZd0bo49BNOA@mail.gmail.com>
In-Reply-To: <CAHk-=wgvUW=1qtJxYcvbA_WaTom6n73nT7S_=7tZd0bo49BNOA@mail.gmail.com>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Sat, 16 May 2026 10:58:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi-5WSdzg_UxAFSRtjTUfscATJ8+1R3Pqvw8=-KKLmQCg@mail.gmail.com>
X-Gm-Features: AVHnY4K6Ktb_aIH9HBPMrhx2OrcbL7_dXcucaUZ04bAao-kOu4bqIibcgFQVmBw
Message-ID: <CAHk-=wi-5WSdzg_UxAFSRtjTUfscATJ8+1R3Pqvw8=-KKLmQCg@mail.gmail.com>
Subject: Re: [PATCH] ptrace: keep task's mm around in separate exit_mm field post-exit
To: Christian Brauner <brauner@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, 
	Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 270A640015
X-Stat-Signature: k1nsp1tgtms5h39s5ge1abdaahzfkd41
X-HE-Tag: 1778954617-885336
X-HE-Meta: U2FsdGVkX1/sGwD3eQ0R8W0UtIgHra6wntc9HCRKTs7juQ9Ei0k4CgpOlTK+C0Bx6o2Upoe+9wlxRey1rv7on77H6QbhCutwEecoQsS2tTBekE17m+PKY5ZJpxKzJJpmFBU1gzlylAAT1cY3kKWpnItJrPlAUWndnVdfJLndK9NmReuvuvEIb7jaGIbLuQFE2OGC352IAaPrYmi2jX6I/d1leqiWXMb8MZOAAJ5/ACYvltEiyS48QPSXvGyvTyIeGh+914H1aaDBbXlcWlrhA9duXKgJKemKda/bdeWdvLQ21aUYsqMeXBinoFAOi8xUBd10cI2w+1TV5n0KThhduPWM4yjTzXhquQMKinh94wGXWlE538QImGW7DHwL4pvRHknJA3Xw5vz+okOORuHaqmuoOAsNgBM47COLLBAy3uuN9G8EK08pAQH4CoDS9g4L8zxvD1eQfkFuty9wh3+pK7+h44TRQUCutdxz2CaNhJ7jjz2tMW2kG9Yy+84NzrjKgncSw5d77vTZF3TiDCZfvLfL6j9w7UAqpm5UANEWVbEBAAuQdTAiNaYZPxFuHtc48VpvtLP9YRXbBlfcpef75FyVjNyOJ8+gkDprv40TNl8pSBZ6gwTv/XSt+/pHzNzP+y0xCcMnpCleQjcdcE3SF+hGg9CQylhGyeQWuw8lsXmSvyyo36FArI0QeQvofFyY7JLFtwatLgI8mMUGFLtEh+KbYIUi62u9NtZwPyFBOJ2J5+++nqZQdSKAvjxmNeJw5jsby5mksgVbV0t2V5hEJeUpmtbgz7JqiH2IDNe5VpT4iasUoGiqCFZJscJmDaKZ3p4WpPPfqx4Sn6afW2jsKfppTJwsFKhBNErTGxtXifiangXqvRBAWmoB6/afuauKepzWjydjt3apEBGZDeSykfRU7AZgHcnSuhsZD6PZ9VA75KctRXd/CrM68RojfHVe9A/smko+IDzEMONgAg/
 i6hfdZLy
 yEVBCtGvlwwdi5abVws5sXTrYwqn9Ir4ODsjn63Aegkw4++TvzcPZIAe2YsFornRaVvpiFcIGLnsfI52bY5nMYp+u6BwNe40QDLWtqz3r1G5bocr1oj8r76urDrUJ6tiBZA8hlyPdM/fHGQymC3s7AbET9ZgGf+WOhvOBGG5Xc9VLqzMe3JTaZgz0M1ESV5KxQ+FnMW/PRQsjQCU9M9ewcz9wy9OhXSlS+2NqMQQQYMfSBNrllU1M4nlfwbgoUqReNikz/yZZj5AAWrNejjwcWxwaA1lnfHuqobRbiCLM+zqvmLpU6TOWjgKjRfofMMDo1Rq20DS4X5KTZgWW9GVFiU/N3Os8oYyYWYRJMzRIZ95CHkJAqI3znGAQz1DEgsPWVL6r/eq3kBKAUUyb173ZZAZL8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 16 May 2026 at 10:32, Linus Torvalds
<torvalds@linuxfoundation.org> wrote:
>
> That mode thing is already a bitmap, so one bit could be "require it
> to have a MM", but I think it should probably be done in a way that
> forces the callers to think about it a bit more.

The whole "fscreds or realcreds" bit is completely broken too. So I do
think that we really need to just fundamentally fix
ptrace_may_access(), and change the calling convention.

Just as an example, look at proc_pid_wchan(). It uses that

        if (!ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS))

thing, and that's pure and utter garbage. It's a very traditional bug,
but it's a bug.

Why?

Because the creds used for IO should *not* be the current creds. They
should be the *open-time* creds. That code shouldn't use
"current_cred->fsuid" AT ALL. It should use file->f_cred for
credential checking.

This is a classic mistake where you make a suid binary a file you
opened - open it as regular user, pass it in to a suid binary as
'stdin' or 'stdout'/ 'stderr', and get information (or overwrite
things) that way that you shouldn't have had permissions to do.

The user filesystem creds should be used for *open* time checking, not
for read/write time checking.

Now, this wchan thing is a case of "not really impotant enough to
worry about", but it's an example of how this ptrace_may_access()
interface is fundamentally broken.

So the problem really is ptrace_may_access(), and that thing needs
fundamental fixes. We should not add exit_mm to try to paper over the
real issues.

                  Linus

