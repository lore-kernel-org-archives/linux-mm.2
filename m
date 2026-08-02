Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 861C1C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 08:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EAC56B007B; Sun,  2 Aug 2026 04:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174C26B0088; Sun,  2 Aug 2026 04:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03BA06B008A; Sun,  2 Aug 2026 04:49:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8F336B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 04:49:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55D05A0466
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 08:49:20 +0000 (UTC)
X-FDA: 85055705280.03.F66DE45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4EB5814000E
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 08:49:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dq3nO3rQ;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785660558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lt/WotSflPJ7SfOyz8ZoSm3HZ+oIFTYVnelZyMiFwPg=;
	b=TNCDXe+pMKIZd93kUV7TaJgQVsu3DNzOW63vkER4xU3XvYe1/kbTE+uy07vDZHCp7pS7F8
	QHRHt1wygch0pIOgrb32kge+5h3vXqKicebH6jiAtIlNkA0VbVOYGxFaZKu9tLmR89C1NO
	tKOBoVaX9O4scIhPvKhjosYrkim0x8Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dq3nO3rQ;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785660558;
	b=B3Xm0SocPONEr7LJPswWTbo55K6RnXsqYOhtesmHNcKKBRDXOV03D0V+iT1uZ/NiPHVSnX
	Q0AkDNeqnMSbETc9Dzd7eMQkxqswgFZ6D6Yg4IPfDvMvinTJNFGH83jvQWFfK4CPJL96YX
	YFpwt2IOC2cCS2kzUW5RTHOC5em/SD0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89DEA43EFA
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 08:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1241F0155B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 08:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785660556;
	bh=Lt/WotSflPJ7SfOyz8ZoSm3HZ+oIFTYVnelZyMiFwPg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Dq3nO3rQWlCrsB/MsrkWLhwP9IllERjg4H9AECGR4P78rEu4d0rg9G3Wl6BwGwvwM
	 W1BPgLMCKWgsIyUBV2v/aJZ4YLt4QV1dD6tR+61hX0grg83r68cg/y4k4g82Mu8KVE
	 9eFSieLjpPUQtFrWltKJifg7LMQtKG0i/jN5vIAFYtUuSk6aeeXCXcfJTG2XnMGzCU
	 UjGZ+/dDKrw+atKD6hrBzdJM7VB3ZN6GwvoYZhHJ2IoZy6elY+ypyUueEvd1ILaXPd
	 sPn+i/UBSXeV3+kEbTGY1C9E8R5D52MswUfR1Gz3WrwstE/yoF1wAlwlrihMIfa1dF
	 vdIeqJgMQhhTw==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e7c6ec9dbso111434685a.0
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 01:49:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr9WYeOhnTlpPVFxUr97/ZU3YMFxf7bTGUG3fwggHjikHejioyt6G/kVoKWou4BeRxMbDuJzn/7YQ==@kvack.org
X-Gm-Message-State: AOJu0YxbpJd6MCEtGoipY2rp+/hQO8Z8513JOu9Qqg5gdPUUBS9+1vY6
	99RgKvHfoHjHOsnyoCoynZ7rbV8VYQ8iyOQrRGhCSX5X1GG9v/ttGhp/6ewUdVqGvk+C8K/NSSQ
	01vsxxjJiUGNCA2RsvIbczPQkaiECGzw=
X-Received: by 2002:a05:620a:3987:b0:92e:e376:cf97 with SMTP id
 af79cd13be357-934a0acd7a9mr769036085a.44.1785660555581; Sun, 02 Aug 2026
 01:49:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260802074018.73887-1-baohua@kernel.org> <20260802074018.73887-3-baohua@kernel.org>
In-Reply-To: <20260802074018.73887-3-baohua@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Sun, 2 Aug 2026 16:49:04 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wLG77Y5r9Dy6QOqgmjNM5W1E5aGqKyJb7Bp3WGemNFmg@mail.gmail.com>
X-Gm-Features: AUfX_mx5OHWyntVSVER1sCMf_W6pihUsx09VgYnLvBQglt_q0gIbFInfOzX4OmQ
Message-ID: <CAGsJ_4wLG77Y5r9Dy6QOqgmjNM5W1E5aGqKyJb7Bp3WGemNFmg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/2] arm64/mm: use VMA lock for kernel faults on
 user addresses
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: x86@kernel.org, linux-arm-kernel@lists.infradead.org, surenb@google.com, 
	liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, shakeel.butt@linux.dev, 
	david@kernel.org, linux-kernel@vger.kernel.org, zhanghongru@xiaomi.com, 
	willy@infradead.org, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4EB5814000E
X-Stat-Signature: 3jb63sw5n3xq8ozqazgej7bzxg55h6mf
X-HE-Tag: 1785660558-299409
X-HE-Meta: U2FsdGVkX1+5mwozx1bqfHNO7Qn/x/tyXh95Vb2s3JHr6SenOnT9rAnMGkk4VZDZBjinFE8UeGrQCJ47+s+I9ulz5fIE8lWLqZEzSl6cBJs7WilBUChU6QxPMYhOjZLQlIR6/aYum3jRDFSSPcrY3g6XHXnFkKeUNNqx705r/3A9TtAKpvSOhr253Cz/xk6RZLVs1E8athYODqzyptojbD6nP4IhniHlOXHVbgZbGFC/TYgI/rBFiglsfGOiGUUJtPZp9Dt3UpCvFHVyH669WiRvH4t4hGk0FoPxicq+lin8ujmRNOeTZivHT0JoL2gqWTrddviLuKRVmJTNqy65D3EI4jccE9aMqNpLiW3Wj9ieP6bXwjLs8rw1MdiP/pxw6zqJ3O6jWMf916a8goqwKOnyK2fm/OUpgs+NO6EzQdN3kWhrIGwzJB8U+DDrLMrZTMW9GAHHzDhkD4wje2ioE+7LdbT0n5MoTWZk7kcf5qfe7jacmTQdeizPaAnACfJ994Q/9wTLvhbQ531VWytfccKN56CWF+Q56Em45ZAwO/LDlZCEUI9C3jLJ8CF7PLvc2qXAWX9uKG9DuaWUrZrILA9wBAdlL0Xdmzwj+2qpoDimnSnhi+a5TnKw4t+D/wbbRfb7bD/V0Z9+mmtOPrnlMkitC26KLrYSbJxeT6YDfWxXNq9V1BfQg1F/72JDbFVUGmE2ZpMNteQ/pW7ZXrLQTLNxrOulrFoZQnmXIujskTvaXfxI7UYryK0a6YYRQg4AU9AoDpUap44jeFtOO0Dbtcm+tU7On04wOm9Ea5XwPl1Yk6+NHQWZO9gSSmQKnAa9f/ew96xWv5hKRV8rpFgCWSR+MQmfg1f29cH92TuLGHCNfSC1oAn4iCuo33iizCZfzQ/p3YUIlwfxJcdSFAxMIUOKJCJrFjhXoxhrN6Ly3N5K+SDW/WC9BRqejEfzVeZbOqVfQGE5GeY2ZrthH/R
 xk4XIgaN
 mTnIardQq3lCOeAq/u/mOYK0vrCYS7W7NjI294yIAXwLMUFO/ncB6BHl0tXkPdW6y29xsZRL967EGks5Vz/F7ZixIfHhVrkGsakWWlQeeNAK4ACigU7QhWZoPON7nlQChy8UYLp+2Mp0IatWejfuHbZsBZlmUwc5WEgsX/w5Z2ZJ2lMDuLm4YBOcYp9+g+Httbhu3CcP05orGl/90PQe6mbqt/z0oDaxv7jVRCjpkiSGWrorB6lba0JRgBOBPBN5JjyYJwb9dgC4ypL63VeavzeMaH35x8vkmxC+PmoP5DT5POQwUjfczsOi+OG7UMlnV+N/8Vp4lkiVovwI66LI/S2PvEqttqfsulaeiJtdpGfRbhkYPNtkuJ7gIF5tVnxKXr5Svt8M21He9kkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 2, 2026 at 3:40=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.o=
rg> wrote:
>
> Use the VMA lock for kernel faults on user addresses. This also
> makes the existing code below meaningful:
>
> /* Quick path to respond to signals */
> if (fault_signal_pending(fault, regs)) {
>         if (!user_mode(regs))
>                 goto no_context;
>         return 0;
> }
>
> Right now, the code above is dead because !user_mode always
> takes the mmap_lock path.
>
> Co-developed-by: Bo Zhang <zhangbo56@xiaomi.com>
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  arch/arm64/mm/fault.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 85e23388f9bb..241f1ab07ab3 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -607,6 +607,7 @@ static int __kprobes do_page_fault(unsigned long far,=
 unsigned long esr,
>         unsigned int mm_flags =3D FAULT_FLAG_DEFAULT;
>         unsigned long addr =3D untagged_addr(far);
>         struct vm_area_struct *vma;
> +       bool uaccess =3D false;
>         int si_code;
>         int pkey =3D -1;
>
> @@ -663,6 +664,7 @@ static int __kprobes do_page_fault(unsigned long far,=
 unsigned long esr,
>                 if (!insn_may_access_user(regs->pc, esr))
>                         die_kernel_fault("access to user memory outside u=
access routines",
>                                          addr, esr, regs);
> +               uaccess =3D true;

https://sashiko.dev/#/patchset/20260802074018.73887-1-baohua%40kernel.org

"Does this conditional bypass translation faults? Because this block is
guarded by:
if (is_ttbr0_addr(addr) && is_el1_permission_fault(addr, esr, regs)) {
it appears uaccess is only set for permission faults like CoW or PAN
violations.
If a kernel uaccess routine accesses an unmapped user address, a translatio=
n
fault occurs, making is_el1_permission_fault() evaluate to false.
Would this cause demand paging in uaccess routines to fall back to the slow
lock_mmap path, missing the intended optimization?"

Good catch! I should have only modified a single line. Then
unmapped PTEs would also benefit from the VMA lock:

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 85e23388f9bb..e1b406d667aa 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -674,7 +674,7 @@ static int __kprobes do_page_fault(unsigned long
far, unsigned long esr,

        perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);

-       if (!(mm_flags & FAULT_FLAG_USER))
+       if (!(mm_flags & FAULT_FLAG_USER) && !is_ttbr0_addr(addr))
                goto lock_mmap;

        vma =3D lock_vma_under_rcu(mm, addr);

