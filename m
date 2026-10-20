Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB3E606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 10:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=G6q8CYHn
Received: by kanga.kvack.org (Postfix)
	id F3A856B014E; Tue, 20 Oct 2026 06:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE196B0151; Tue, 20 Oct 2026 06:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8E66B0152; Tue, 20 Oct 2026 06:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B32AA6B014E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 06:06:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 587461C0025
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:06:40 +0000 (UTC)
X-FDA: 85342575360.16.FF79AC7
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 838EE180007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:06:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G6q8CYHn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of puranjay12@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=puranjay12@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792490798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjLEZjKc1UC8sxA1BoAn5ZhOr52xZdZQzKhwFC7bfbg=;
	b=tZcfSx6mYU3y72va3ztKRvR5V/MnbHOm3yr10N1mw1Buoj2Wz7rjiv7pViRrBn3aER4JRl
	2/4vZPMuAUjSQzgDDE7oQp/v3zmsqpDlqkD4keVDCBXOUSoXoEk4PYuYeEGLr+uchO4Sey
	MtwyyTKlgtnTnRLma6Ut6BvBLk60S2Y=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G6q8CYHn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of puranjay12@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=puranjay12@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792490798;
	b=AR17bUogKtycFuvSHavtQcyaDili2Qqr2BXOiYXFFUXvNGnXeN2/SkfU/2r8IqLlrWV4py
	R5Y4ZN5CZz6wLa7g+g3xbA3na+kg0OW5Xz89RjN7WcDXNogBRi01x7oW+JUvVFcjN8A1AV
	IGBzo+uZh7Bvc4yBg0VqVmVMPzMXSA4=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c445c95d553so233092266b.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:06:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792490797; cv=none;
        d=google.com; s=arc-20260327;
        b=qLNp0Vyb/tIvHxjAzGmxrSVmhTIkInL+RiSg+nAM/bsT/vgE24Mac5ypJlXbx5IyfC
         Xy6SScxREBpFWFu0ws4Ir9f/vwJIi2raeiowxFpknpYJI9td+++Z2Cto2xCQ1fNCxhjd
         HeWNKWpef+8f8G0NbWrPe6xtYH04BWJJoGpshSMSwDPHR0wsvNcnwCyEPAxl2bnEvT6Y
         qSgR/+wE2LsOgWJvUtH8gTzLT/5cOm2smlNIoD9jwRHLAZ6clJ/FtXIUcnayd6w+w3w+
         kl0XlKSnN6MdEDFG+lz/VqmjN2yDJuAZLMkIRoFSzxWCjt3FhXGSh1EBPhI+cXErp2yC
         yzwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hjLEZjKc1UC8sxA1BoAn5ZhOr52xZdZQzKhwFC7bfbg=;
        fh=E1wIhMbIwlbShZ/8H2I+gWcHUHJwCACRm8ipUdDkMR0=;
        b=mE8w2XNqw7DQY9Dj3Id991d4t0oPcun/p/f4xLkt81Zz5kNktme9p9xS+p2xUgW/7P
         bgMThQTgOAzKC3x96r9SoyXxO4FukBzuHy+hfZ7GkRLRDGapNtuHlhCCUT08BmYIAAkB
         xJ46H7ONAu6G49h2AXQ+fKopgkfmJfCibtr3CRFe3+Q1S+xJ5V4qqVX9sMsvmmBs5zI+
         I1fG0s2W/+NDb82MGSFu5z5JRtPbS9tpGY5+s56uBn3dO5A3XP7Q9SHCGINDyxPaPOVw
         fA048+QjfU66lBoy1E3qbGjO1ybTbple7svV3OJtfzI8garhUuVIt1QjNsviIcZR5+3a
         J/cA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792490797; x=1793095597; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hjLEZjKc1UC8sxA1BoAn5ZhOr52xZdZQzKhwFC7bfbg=;
        b=G6q8CYHnEsFq/d+equu4njO7V8lBQAKyRWNoDrx0wbjAUyYlGAy/i8GHTOohiCbpWj
         1fBjQav6fbw1/XrRpGDuY2HjUmW1lFlB9IOFWoTXpG3NFCxy806hszppivrM4twFHa7J
         nbBk9CZ2iY4wYfR39tjdp39uCIQRsA1L+GARHOtoRoAu2pFUCKcNQqqcf2/CjfDUJO+X
         ArTpaPCbd9Y8DZ7U9xdnb9xOR7kTG1KIWrSh2wJ315E7X5D2sTf3Gfg6nXSxXtiaG0lE
         wAl6hssFTNsDWhVwBZ6DRSa7Ukvum8neML33HBwqEem8oMKqb4qw2Lbt2H7Wu23pzfgS
         GouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792490797; x=1793095597;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hjLEZjKc1UC8sxA1BoAn5ZhOr52xZdZQzKhwFC7bfbg=;
        b=skcmTmhaiaS1U6aKRV/xaiFiLhLT1tiWLlehC1pphP+ckP7sFbU8Z7+d0/qL0Jy3p5
         PEMP7ZqM/pywizGdKQjfgSAgdLeZFBIDZtWOo13SUSF2ab0UrP9upbGCLPSnzE2vOYAl
         IonR/ddoDXxILjcxFT52v3FElho1+3XzgPRU28KdDrVqb87W0SJRLs++Dg3HqvEnmUFX
         tJvwRlY7ySe19y+Uhci9EOgs8o51wV9Ub6LPOrsepGBHzaUh/JMb9pPeONcOepstFLlo
         uJhbHWkSEV+nNmanq3aLvLlOzPle9HiuRDe6TbU+btNzLQ9B1EnejZ1sE0Eb/K403GPB
         znUw==
X-Gm-Message-State: AFq9FYKain658vyxcwnLG+lrXbUM9n2SLImtoX4ncnZwowoch2m2s5+M
	KaZPENzgVk031NIqL0YEw+5sINFllDlJmJk61ugcncg8O5forsPbNDn0lA63QCGXxDpV1QNAhzn
	fZ1/XjU2cHupYgjgiV1T2hnBB3xS5EuE=
X-Gm-Gg: AYBFou1zPH6cM+meQVJkj3SHNC2KeCx7boPQe+TVT7ReQBGI7kK5hCpg/ngr9XfFh0h
	k9zU16N735rPVBdRGJ5CAcDL0EqU1EX+DwpDCbKaylMqOKEzHsdPLBB3BYsQcasp7BIgGE7bqEe
	4nYaoJd+O2xpjuErxip2Hdo0d2uo39NVVuVRPdctCcatykOh07FvptVOeNSocSHmdmkfBdwF051
	ieZCV716R/vEaZ9wGFuVAwTZ4iCpdCO67kKYGjy70zqsxFcMmUCyuL/s+mB3bKFd/5isqnix9WJ
	9o8GVCpRfqKE3BE/3knln+NDIvOdz4Q9oxKgHv+6js0lVfYFYC4KtKQPtelQ8h3jfd/N6WE=
X-Received: by 2002:a17:907:c642:20b0:c41:a5da:1511 with SMTP id
 a640c23a62f3a-c41a5da279bmr487551566b.25.1792490796791; Tue, 20 Oct 2026
 03:06:36 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016155340.3304319-1-puranjay@kernel.org> <3225a379-a959-44b2-a2e8-02ca93759316@kernel.org>
In-Reply-To: <3225a379-a959-44b2-a2e8-02ca93759316@kernel.org>
From: Puranjay Mohan <puranjay12@gmail.com>
Date: Tue, 20 Oct 2026 11:06:23 +0100
X-Gm-Features: AclHuK-7_TwiedmUSuWVG98rjYO2MVoSPsgDN58DF5W8SXtLU45kxTKTy_DTVHE
Message-ID: <CANk7y0jHbggDHB_68MjZNq4h=Gu_N_G-Ytf0YLrKM_B8A=qsoA@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: Call call_rcu() directly from
 __kfree_rcu_sheaf() in any context
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: linux-mm@kvack.org, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, RCU <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 838EE180007
X-Stat-Signature: yw7u79xjrnufkygjm6o5kjhpkxrr6331
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792490798-959564
X-HE-Meta: U2FsdGVkX18zqsz5ND4ZhH3C1wsM+KZyZCN2OYZS2nAgsrEtGciDqruzhxkin9BEt1Puo/9e4xfqx1P1VmuiPuZ55hCACYClPcCs89/usAesXIfSlpAwlUa86P1KZPiv86n+LdIaZ33emHm8yqb4lt4zFBbSUoUhzh1fCyiZ4pFkQcvyHIm0NvIcE0GqKfm4upV0F/chO8EbrEdGvPNEXbzKY0WQEMtmebQLqYMb/ouYR2HT91nt1morDn0NGYOU3czgglkrfj0XdAT7wnsAp4KYNLH2jPQRLzoUSjQinRHXOosEvby6Lx6IvTtiMNnSPe1yFlqdpT/kqf9m3QqNp3YjBs1dC24756XzqEPf+87yg5wQc4puRS/tkhSTajCdzjnxRWkSY6uy0UvQKaAfuKfkVDH3eaGp4xd4z8cayDhmw9vu1E76fNHS4G5ZFlhErXxBTFRwExG8sAA5LzU4Th+IStHPdWUC28QB2HbWo3CliBUXw/uMmKXY+tvUdWYLvfp81x4fVYXuxprYLehyxaEbXt1aMMofi1Umr7VElbgtmGUIzSvu3kDb9DI4EqOolo3zaHBkg7GmQkP0sZWX+5qV2HByKW99dYNte76712BghTCF2XDLayA7cBiGuEpo4bf8hBU1wLJ7KbyiNfkSAuYNVgZEd7omuabt9DfDgjZlEG5anEu9+EVXTYc3DBxH7zq+IR8iRWBjH35n10eYwAFLCUAaXAz8+DUDj7XDlFKwMwO7plEgdBbVYZkGxPDMctiCu1iIRvGtKHCrkjdzpn+UG9edS0zXgKv6yUWtWrVHZE4rhRd4JZWtGHp4aNwtN1BrmQhJNRCfMLTDqkTc9R5/0jv8+h7ICFLDa8dAfbJ/vblpzuvfl/DK/+gygoYitZOWmVadL6DL+oMiLpiI0ScWvZ+qUHxPY1N+D8AaPIa6leA0+3GawrUdElu4vXyV+Fh+OnmcZ8Wg8z6apMl
 v//Ez6lg
 177U4YA3/DH1xtZaMRmd3Z4sK+hxbWk0Ofv0lhY+Dj4H7FXjiwPeOJaIg3z9rc7uPupjCRENDuOtcHAAVxIQZm67HbmtqJIX1+DbaAWETDBH1tYM9x9q52piW6AosbcJsHGrtu9I5+1LikBNNTk7qCvzdI5exG5/xBLgtztnyR2d5Us16A1cdj41fHlyxu9AcWIvvxtzFoDrMmzGJwDMLPsxdCa9nubXXtuJF3i56/4F+5y5zE/65fHQfJMWZSpYdFv/qIB9K37KgUhrZj2wHmBd2jgKL+GlZ1DSDxxQRORdJTyvhNcnDsrWT1gKQypp41aetYHgjUT2RwYJA4quo0Hb3x5iP7Gnwg7XwszDGrLT47U8B/2RBh346zFj+IYxGQLiUzG2E9jOHsYIB+bz5s2h6+vGGmk1bPtYy21iI1R+KFmaqFAAGCSh6pIFPgqPWN+S9pxtgBtpbAa4M8aW2a7+3Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 10:23=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 10/16/26 17:53, Puranjay Mohan wrote:
> > __kfree_rcu_sheaf() can run with allow_spin =3D=3D false, e.g. from
> > kfree_rcu_nolock(), where it may interrupt call_rcu() itself on the sam=
e
> > CPU. call_rcu() was not reentrant, so commit 69abda97a09b2 ("mm/slab:
> > extend deferred free mechanism to handle rcu sheaves") added a fallback=
:
> > when !allow_spin and IRQs are disabled, the full rcu sheaf is put on a
> > per-CPU llist and submitted to call_rcu() later from irq_work.
> >
> > call_rcu() now handles this itself. When it is called with IRQs disable=
d
>
> That's great! can you reference which commit does that? I assume it will =
be
> merged in this 7.4 merge window?

It is part of the RCU pull request for 7.4:
https://lore.kernel.org/all/720d335d-17f1-48e7-b5e6-49352712cdca@paulmck-la=
ptop/

Thanks,
Puranjay

