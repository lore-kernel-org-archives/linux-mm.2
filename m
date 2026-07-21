Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CECEDC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D3E6B00B3; Tue, 21 Jul 2026 04:47:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B35806B00B7; Tue, 21 Jul 2026 04:47:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4B236B00B8; Tue, 21 Jul 2026 04:47:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6896B00B3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:47:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA84F1A0405
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:46:59 +0000 (UTC)
X-FDA: 85012153758.24.5B54F35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0382A12000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:46:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EO9LsbGe;
	spf=pass (imf29.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784623618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hWIbARItOS3O0oMuhodwOx5tag/hEshRFM6Dtys9CZU=;
	b=ynweeDHf+wp+AbfmuHwvAFzt/X2rKsKYHCQngsVAtrimRlAgq0vIiwBJqooO/k8uxAl/DK
	fvrNsLz/7hXzl7dT8Q5D+YbqdY28k9jV5XiVuqNSV/ssti42DqRY0KBYdKA/JwqDUocKUW
	fi+qs68HrPyJKQn3hFQPqmhAPiFLB+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784623618;
	b=rC6GwGQ9VxYbmzpao36tgKxdZN2iElP+/pVIYkwzX50RrbSawoGZbGLDrKZBKIT5lkAZlb
	hOu4wH+mMnYh45LfuLaBECzbaOs7QR8FnBP3/suXMfxpmr3vQQD6LLYSm2ORPgK+tyk4x0
	Zf72F8ullPS/O6Mg+KbpTvojvDBCPdc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EO9LsbGe;
	spf=pass (imf29.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5975843FB7
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B771F01558
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784623617;
	bh=hWIbARItOS3O0oMuhodwOx5tag/hEshRFM6Dtys9CZU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EO9LsbGe51ZavfNcIoKtu9CfyoMnAKXKWFgcDMLjK8Cg1mbhooqzWs7bcmqMCwD3L
	 7hOOTZ80szuOIMBDVlg5SK7mGPZNfia4vmgZyGgjbv//52DZzeyatZIrv7otvzm6Al
	 wyP01HqSm+J+oeomDlKqgf25grFDxZfNJ+gU4Q0+SYOtv5sFrIX8A1gEtPeGZPNTa3
	 7QpzM8EcqGDQgvPEvOs1vR93djgwVkwAsMETW77pS8XhhTozLUdXvEklIdKr+1cUzR
	 3/IgTifLJHg94ybJxbdNc4++tvCewrzt7Po4v3KbSOVR/7nKzTbKxSuql+cu7bjhOl
	 q8+yDqHiQ9Yzw==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aeb59d54b1so6852390e87.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:46:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RowIpLWnmae0QlJRZOGxnRd5HDyGw3rfan/DvWb6H0LigoRwZJOzDiHh2ljOeTj3mmCxFnU2TLIfA==@kvack.org
X-Gm-Message-State: AOJu0Yxrc/e9zE/s80jNm816pEed3AmWAlIwfmUo2FCAIs2mBr5bdAzx
	x9FJQSmK8RlBBqIGnmay8Nr2Rjz3bQUCQLyjtb9kimqrO4nr183oY4xyDiW7VbZjjQqp4Ledf3p
	IQ5/IVl7+xi0T8Pw1tKm6UbZd3WXOk9w=
X-Received: by 2002:a05:6512:31cb:b0:5ae:bd65:9e04 with SMTP id
 2adb3069b0e04-5b28f84a486mr3730624e87.8.1784623615766; Tue, 21 Jul 2026
 01:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260721081858.1169276-1-ruanjinjie@huawei.com> <20260721081858.1169276-10-ruanjinjie@huawei.com>
In-Reply-To: <20260721081858.1169276-10-ruanjinjie@huawei.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 21 Jul 2026 10:46:43 +0200
X-Gmail-Original-Message-ID: <CAD++jLnwHt=-WJDbzXxOcfpit4YTuXkvCHKiDhpc3DnPuvMrrA@mail.gmail.com>
X-Gm-Features: AUfX_mwYERH4uDindMiYg6vMc3HQe1SCH5T84GPvgdsU-QjZmsXF2WrTxoMaVYQ
Message-ID: <CAD++jLnwHt=-WJDbzXxOcfpit4YTuXkvCHKiDhpc3DnPuvMrrA@mail.gmail.com>
Subject: Re: [PATCH v17 09/15] arm64: ptrace: Align syscall exit work
 semantics with generic entry
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0382A12000A
X-Stat-Signature: 79hmh9s7fzgzph8qukx16ngmqb4hmhab
X-Rspam-User: 
X-HE-Tag: 1784623617-611359
X-HE-Meta: U2FsdGVkX188rlPBmtbuv5VBXL/SzPSVySVeg6oyXWpztZdlou9mf9GCy+Yk3W4KNf7PCkf7BTwiETDfHUxUWhdr7umZ2tA1TGQGC1uiUVS1sDs07ZNbDvZxnDhjOc4dba1yBw3f7DVJX500CKq1WZnWdfPDMA9CoDfNj5wuBQpHeAch45lRDKi1RYTW9WAmnZGofI7zBv+hCYSepIfuqib1X60uMp81eREH5s5RbdCO2Le1fg4x+X4LBJzRwEjUMthSAqndgEqwVDP5JWA273AuOcB6XSqqJbpvdywU1j3NzGN+yw1dwIxGvoug6Zg4gZSm8Pkfv8tO794u7Jur1/edrgBpKASNMUlSxhAzWNwAFS6GeDh5xi6nLHxYIeMhOYaoXTObsw/dZuNyIjt6IBBQaf3jORXRu3+LQt8tZuu0GPIvfZObYh3Dklo0mFdlYSalHkrfubnfup/c5+eW+Q54bzOB/q3XTL8KvnUXMy1I04+BtUQWnbi2G3OoTro5Jf9IfsJJgYq2vbC3033jIglYJJhvGZWWCzNG/ihOm++Ndz3zXtzV3vIjHk8DyIZsBqwf4RAyIMdUvW93ltnoH7nvWUvml0XBLpSUdW3nzxr2ShgYNHWvSnK3m1LxuwI1YX+dSPXK1ld28khtq2HwdpZjI5qbDZUq3iF+e3MZZc7WN6P1mxjkbcEgHfmXQACM6f/5NNJEzILCno/lYhl/JHXhr4dq5eaHZJSr5wQFSzgWqehaBLIDdc+jh/h4ERJjjtDz6NWMj22dFpBT1+8RSft3M1FSvP+qlzPO6eW2aKklprPfsVsb08/0Fge8QYEtkPd4k/s5HLRiAnyT5/M3MXZbwCpOr6AGAAyQnB/S3aJL5cKznY+e3sO6XU27OkHQZxct4pLNWQoQODEXoMVUngaDIm8s+Uz+KN7kfO/WaQ6ZfVHmSRBkf1Gz42u/7uZXDpw7ZQVcd8+BeFg47YL
 UAHPddn0
 rnw6ZJk2tosMw2hnBuWOY0HMmAyAoMCupES7qd1Wp2OjD0ZoFpq/7rU7IMtbrzNDBMbVyBpoZ2qULC9epxUmyO5UrY0fvQ0gO8AgJHDx39ia/8Y0PpTCHow7LvUhDA5kW/X6C+WCCBNmt2OkS7y4MgU/a7eeMLGVzNL0jwldAaB8P6rsvPmV12zypJeb+l7eLYXiiwzqeAQK79Cs2RTTcYCNtEHlhitGnRrBv3fHMvtASo9UT9iyd/JsTv76EAkIVQhFnvGuHX8iZUTRAGzEZ3bFXtu8W4QoOkrVGZyWWJPlGxywcFXtC3ChZ/VslGdZaf+OrLkWfjfdwJtMG8YPX4ce11Mn4Cs+v5FFndWoDBnkFr5rTDJPtZlYZs+4etG5yO9su4q3q+cMtX4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:19=E2=80=AFAM Jinjie Ruan <ruanjinjie@huawei.com=
> wrote:

> Refactor the syscall exit path to better match the generic entry
> framework. Specifically:
>
> - Introduce `_TIF_SYSCALL_EXIT_WORK` to aggregate exit-time thread
>   flags (trace, audit, tracepoint).
>
> - Rename `syscall_trace_exit()` to `arm64_syscall_exit_work()` to
>   better reflect its role.
>
> - Move `rseq_syscall()` out of `arm64_syscall_exit_work()` and into
>   `arm64_syscall_exit_to_user_mode_work()` so that it runs
>   unconditionally on all exits, consistent with generic entry.
>
> - Gate `arm64_syscall_exit_work()` behind the new flag check,
>   mirroring the generic entry exit's pattern.
>
> Gating audit on `_TIF_SYSCALL_AUDIT` is equivalent to the previous
> `audit_context()` check: the audit context and flag are statically
> allocated at fork and freed at exit, remaining stable throughout
> syscall execution.
>
> No functional changes intended.
>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

It does indeed align to generic entry AFAICT.
Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

