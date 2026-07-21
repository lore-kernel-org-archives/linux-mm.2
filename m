Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0076C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D4E6B00B5; Tue, 21 Jul 2026 04:51:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04366B00B7; Tue, 21 Jul 2026 04:51:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A776B00B9; Tue, 21 Jul 2026 04:51:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B09D6B00B5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:51:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D497D1203D0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:51:55 +0000 (UTC)
X-FDA: 85012166190.10.8612F2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DD87A20006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:51:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+5IibKd;
	spf=pass (imf13.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784623913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDCGk+ASivZ9odKPg+TByC+zAWOdik9AGlI/d8GoOYg=;
	b=w2GUgKehNyQgdgQdbhNr/DCI5T1m0oWmD0M0r++IszcoyhsmgPDsqbhxOxp9kDIp+7kGB+
	RSZKx8xAnJ6KnqBVJxNGhKeS+66HawFlEMpOs7OcZlwYq0cUM00NR3+kDtnRfwJ/jvIRjP
	ubRGRQmKucrfZXk1uFVowGHSZd9I6hE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+5IibKd;
	spf=pass (imf13.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784623913;
	b=Iml31IwoExd3aZ0EDJNxYY80f3c27zPTtaBmrDlcftwky+8dl8KvckXwyVKbKNvsQr/qTj
	LggGch6W6X1AoGtKaTPHx8XGZDkq4wViD6loG98w+0034No0sFJaNzG+F9j/ddUoV38U8H
	xbhzEERkwgHg69KdaK7AHAxO5Qm0Oj8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B3CE60AA5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132D71F00A3E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784623913;
	bh=WDCGk+ASivZ9odKPg+TByC+zAWOdik9AGlI/d8GoOYg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G+5IibKdCPvRbPIW4UwVnN/zRqG1AqNn0eOnJc1gH9S0Jx6Md2Je86BSXQAPLQtFu
	 OVHHrtx3875C2JdzQwZop4lAnVQj5padUMaN3axIeDqbQY7ksogL8SSQ6IToqFuIqj
	 A+eedTBNR2KiCRUi2552YrUgOD2vHONbxnbj5DLDLGYEC2LW/+rsyDvK6GAxaCO52a
	 E5EgnPOGQblyAoRXWxF2jK/T8coyTK/6os6OK/Ha/krI/Rq43p426jILQFpe0PJ7By
	 szaGmC0OrgzWRxNXFiK03+2tM7Xa98pdnBPyeaTCKA21sVqSbD34ysFBMm3S2zzAk5
	 LLAJ7njkImplA==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b0117dda13so7357490e87.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:51:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqnb8uktbIYYteH/U1sB6t+0nFSSCvWwUs78HdgJwcjW758ubZuvrx294PC0Evgoc5qFnz8egaCyQ==@kvack.org
X-Gm-Message-State: AOJu0YyzcE3cCJioH3Zq7EzV9dN2XRGXdsBRka2jtB+ye8o4FE1Wx5Va
	NVj/Faj3Swzoposh0qNzfswpxbJ1NjznyQR3tbfhHKnJAABDqoLGgiXuGVc5afrJfvYWKbFj3Re
	EJAALua3s9tvinh1j6eEAPz3Tr02wdcs=
X-Received: by 2002:a05:6512:6092:b0:5b0:17e7:67cb with SMTP id
 2adb3069b0e04-5b28f85c96fmr3157205e87.17.1784623911848; Tue, 21 Jul 2026
 01:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260721081858.1169276-1-ruanjinjie@huawei.com> <20260721081858.1169276-12-ruanjinjie@huawei.com>
In-Reply-To: <20260721081858.1169276-12-ruanjinjie@huawei.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 21 Jul 2026 10:51:39 +0200
X-Gmail-Original-Message-ID: <CAD++jL=D1S7HE9dVwHeOyAmu-6g+BGq+f2=2=BUX-4tzp88NOQ@mail.gmail.com>
X-Gm-Features: AUfX_myXfFPmxzRpXer_m1f22Sl8KHAIsWBq-5Jvh6C6oAP82PJASvQuqp2AReY
Message-ID: <CAD++jL=D1S7HE9dVwHeOyAmu-6g+BGq+f2=2=BUX-4tzp88NOQ@mail.gmail.com>
Subject: Re: [PATCH v17 11/15] arm64: syscall: Simplify el0_svc_common()
 syscall exit path
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
X-Rspamd-Queue-Id: DD87A20006
X-Rspam-User: 
X-Stat-Signature: o5aaathy3oe84gfsootd3wt3x4z7tzcd
X-Rspamd-Server: rspam04
X-HE-Tag: 1784623913-344045
X-HE-Meta: U2FsdGVkX1/zm4eWWFoVM2rHxtBeq+GxHpZJ32UiDl+EatJxuhbj3pwFay1yvvuildrYssrwwqacKbyHKH9VXOoaGKg0uOqUXcWX2fMLcBXuHXEsGvUAwg09L3IyoCSKGlT1HiNGA+TVgjAzjA43mPgBtGXKQfrVPYJOdNJ6zwhj3vtKnhDGLeqJcF8FGVmDmQGwHsYStbajQJF/wFeGcemf/4pv8FbhhgkOedTXzc3SBJg/h5fjD+RZBooyZDV1i92USaKP0OQ6DOKhHDrjo4mjFZ5LPkb/vGG6PmywMINJVbmT4obVbF2zYX3ZODFk1gdwLHmRooF6UssVv7Qg/dLkO7+PkQrNy/h/3TPSkAgkNgfgCJtMRqGCBzxGMOj99l5/LfSAxGwmRa96UlfjoN0sWU3+RgGtxcTWzcajA1TvlFaxARuyvBXk/zKO6mY4dHKjDYCKp8/tkTJL69GXkd1odbN2+f6sfCXCuT2ww3xEFZb8T6Sogx4gyyA4AANs/q3lakFgJhmKaO5U+xJMi1HjA6PlUtTXxUUGv4TzwCb0DCBZuQsLnQVmcwkMOT9Qkei4d38rwQ1+Cqda4yb+8qOhVAkW353zAu5UTeGfVg8s3BkNgZoG1F8pUa1hwN43Qk9Pa59Od8qe4bM7hgBhYAWzf6eoFYHKzFXa1L6trcmGwJvcypXhFLcsNrdjh94Ovcmn90V6ig+qLqBpKKUiTh+rwNiE4ajX4eOgpJQbJKub2AbuZBOeY4G0gmUgrasVUdIlFwiqeEN6ON4RuVmHj1I0RKG/nN3wOIeDz2rL0DdUMqfkFmXY0yA96xe35QF1P/b1Znlz8qXFe4g4dCBfqnUv+zEB50AeMQBxeiuGsmOUNYULbx1pUPEGIovuXMLG0oYNMmHoCpgtdiqblBpwminO1l+tA+NJ/tEY8lTxPg0zLqI6YR/GGN5s1rfxBbB4HO1EeTfniWMwTXcKi+B
 DeoDfoKi
 vqR6RRyhIvzhJPfjaDrmhFpyfqsj4Qfz7kqGHY6suMpRy0NtMtNsmDXveVJjxU5fIH88NzdvVWBQTR13rXJRRXyUh4hI3hKUvfvOGrPs1KhKE4nlx0K4BJaP98htkdeLRvJ/NZQgSk+LQSTnDzrK8yQdO1EKok/26GQxzUOTtSVxtS9+VVwaBbBWk/tD5+98c9qBANQ9nP4UwrY4O5o8eDUasENt+rWSAxtMUOdPPJD00CxRFubjfHQqG5yaZPO4hTumZtffk06PrW0CJ3KcZJSQ7WonDkOlwocIqKJDeLwkjhg7rfqL1E/UUYA83PJ33XIrOLZVgxPnKweSDNNJSoeaDx3MDsLUxU4iR+qJK62ihEEy2MNJYF23AmSSARc8EufBeihCynq3BdwpVyU3yfJ1itHLISkTVYsLSFqJA/JZOPtfdESpZumvKhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:19=E2=80=AFAM Jinjie Ruan <ruanjinjie@huawei.com=
> wrote:

> Remove the redundant nested conditional check within the system call
> exit path of el0_svc_common() to streamline the exit sequence.
>
> When entering this fast-path block, CONFIG_DEBUG_RSEQ is guaranteed to be
> disabled so the call of rseq_syscall() is a no-op.

Please explain why this is guaranteed.

> Under this constraint,
> the code logic inside the block becomes completely identical to what
> the arm64_syscall_exit_to_user_mode_work() helper already does. Replace
> that nested logic with a direct invocation of the helper, eliminating
> redundant code.
>
> Before:
>
> | if (... && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
> |       flags =3D read_thread_flags();
> |       if (unlikely(flags & _TIF_SYSCALL_EXIT_WORK) || flags & _TIF_SING=
LESTEP)
> |               arm64_syscall_exit_to_user_mode_work(regs);
> |       return;
> | }
> | trace_exit:
> |       arm64_syscall_exit_to_user_mode_work(regs);
>
> After simplify:
>
> | if (... && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
> |       arm64_syscall_exit_to_user_mode_work(regs);
> |       return;
> | }
> | trace_exit:
> |       arm64_syscall_exit_to_user_mode_work(regs);
>
> Furthermore, Since both the conditional fast-path and the fallback
> slow-path now uniformly invoke arm64_syscall_exit_to_user_mode_work(),
> this explicit conditional branch is entirely redundant regardless of
> whether the evaluation is true or false. Removing it collapses
> the duplicated logic into a single, unconditional path.
>
> No functional changes.
>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

After looking at it for a while I conclude you are right, provided
the reasoning about !CONFIG_DEBUG_RSEQ holds. So with
that explained:
Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

