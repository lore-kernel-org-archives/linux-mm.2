Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D164C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 18:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01F306B008C; Sun, 27 Sep 2026 14:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F122F6B0092; Sun, 27 Sep 2026 14:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E02186B0093; Sun, 27 Sep 2026 14:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF5326B008C
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 14:43:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 198341C38BC
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:43:06 +0000 (UTC)
X-FDA: 85260414372.27.3467588
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 29B81C0002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:43:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ARQ2iMMK;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790534584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wz8k7MO9Giwzl9skRoyGRr6OliqXNHM85ABcpkEfXSA=;
	b=Vj/B0U3ywxMaqtCLYBqL0lW2R4/Um/JrM3n6Qo+wTPYgGMgCYA3QI/FiULsk6A2Z0g/izM
	6n1i4cT/nYzOPhbLvCppAzA4dr14iB0KnxPXGUYa+rS8K1VoYjCfISXHLmSKyKnMSu7Tqc
	mVButxceUf20b5YJ2qkH3B94p4ZyNwQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790534584;
	b=nhpgmlEAYJTr8j8zxNwWmy9WL8USLXsiC3TK8pBq1r3McLCauttHBR2cYhUXiu4KMtNXqL
	Q5eYCziRnAPPX+tk20bgQLg4IzvjzfWsqecoA9mzrxfWwLDdfB+MNGxzIisnSpAlnY4m33
	cJGViadV1lMSoV7mgodPuRP/58aTIZw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ARQ2iMMK;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5333401e359so92371cf.1
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 11:43:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790534583; cv=none;
        d=google.com; s=arc-20260327;
        b=T9ZAJKO5IzxR7y4278Wc+SyD+RlivpNUsXtI+40uqtd7KUGygseZzkzwKKexH+Cci5
         klz2JbK6RSNSh/mXLX2EdH6LeGo8kJQfRINdxLdKuTGBCGKMVGE6CcXxkQUH6Jbj2nQ4
         oy4r9RAbNlw2U3IiV9tUK9gM6ELKOXDAnTFpJVLERJK6P8scoU9xjAAlUn9hxljeC83K
         HFoPmyVXx4/oIDV8b8UJKVsrWynaqmPu4FEhxV7t+1YhCS4Sk4FkpIzlI8oAxnN3e4Wq
         9ifS8FDicsHYz1CVWJQClyVWmOI2MbJQLPM6fWokckQi71jLopHwOSDTAUkjt8ArYKGE
         OAkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wz8k7MO9Giwzl9skRoyGRr6OliqXNHM85ABcpkEfXSA=;
        fh=bKogFgKiuFjEe2iKIgLQYEhGe6vxaMT2a2vvbrIgZ5U=;
        b=cTORdMLSwIV3tkI43KaQaJQko8zIV6uMajEe2dfMK16VlNfcUR5jx47TrAi4xtS+V5
         cosLti4whwL0+RgjgoMDxdsIUvyGkiPgZzgPmWef1NWS1xsH95A1GsKh9J3sZAPrDQff
         9nzzjXo1LlRPpMy4AybcO9rv8OgCPv2Ayv7ze9c6bEsy0DwaOhm/IzeWvPcsnH35d7Am
         jE8SIPgThUbfgdbuzAAsekPs5HTzfKoMoj5BGi6Dh0x+HO1LSzMAdUkrD8P7jwR+kT89
         jc5PkHIsjzCu/zKxK6AxeA1U2kpfI5tdIWa6D5AbfcSfH+XiMVpKYWGKnYfkqpuGb8LI
         939w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790534583; x=1791139383; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wz8k7MO9Giwzl9skRoyGRr6OliqXNHM85ABcpkEfXSA=;
        b=ARQ2iMMKnF4uBxsMmkDbNarKtpyX6VmWUdCfv3fR6masI5gk+4MZW0LiavyFkfXYfI
         pvllKs/VdYbUXXQ37oos/HBrp5J7AoDMscs75mXRwwUE5XYecQ6BoGsIOSAIw5ovn41T
         KA8xdOHn1il5FZT+WwTgleN5VJ2BslJ5gG1AelpKXQvN61NlRso+hz060nimu+9j5okg
         wgeiKq9i5/YBe6Sr9p6W40lNNkKq7UAjJakEtHUxdIFd+qMPe3WoEbZCQdMzjhgu7adf
         YDd+AUr96pSlgM047pAvruiZSfQgc3yNzO//vjivJAVNjT2iKmgjIMXa3yoLzhhp23GR
         SMRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790534583; x=1791139383;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wz8k7MO9Giwzl9skRoyGRr6OliqXNHM85ABcpkEfXSA=;
        b=T4vtubhxeOQ+I6GimpNvlICC7vfwVZKtoGWzIrd+uWcYO9CXSjFHKF297TKdRSAVb4
         72E8IuqZJC17ZifSvU6ufj/ygd+UH553cHmGa8zNGx92hGR6KWu9f9+s9rDfOh5D/iga
         qrouaCHYVpldGg1wy8ALQ1OCUv6MM3kOWnE4aF4vvMP2ZxFgEKTevP5D2BxZnPf7TWVY
         Bgnx+DiKmq6HL5C2/zGFAm67KynCg4IVaoZ/ka+zxqxj1Zn3igOAM2iECPaH8Afb6qAv
         3Iu7d72F+QSfgOO0ShSft40Q4Bgj67S8kXQfurtdNW6yswKmPDOeLpwE7G9j5aLjtIxg
         fYVA==
X-Forwarded-Encrypted: i=1; AKwUvBxrwTX9SXZ3eAnVyzr9rgUdtK5zuQog5MYNV80qwRkXl7SqiTIxJcCGSuziwANlpVH4vxYETKIZeg==@kvack.org
X-Gm-Message-State: AFuF++lK3y3v10D4FF7wGwlM/vfALNNC9t9sp/lqtYbgxW3vU6cRdXTW
	D1igylEYrpTTSYYdTOkp1a3A/QphPvamKXorVtxS6XPlEnCjr1+FwD1DK64cNIMw5s8wRyAwA6S
	TXOjrgGb7rFoGNhBKLNXlMdm8m008gBgED2GFOrxK
X-Gm-Gg: AYBFou2kMKPc5692ZQhSoXItfzin+F7NX/FO2AY5+OHksBtrvg+jYwigMYKGtliw33h
	EEQuaqPLAyku1ENx2law0zxR1dw/kus5EQ0xbvw3jZKwTBSr8aS4Zl6bVvQdPIY6bGvUB1CTG4g
	NFB++jXxLOqI+eu5RLjkl1ElkbjLRffx4yRv56nZu1dOIAcNYtupckg5PqskgaO07T2wzBJXKLB
	nswz51kmyy6y49+tehyG2cKxZK7Yh7rzTlRy7RZQbvIhD4R+XHculvPj5Y4s693H7tJlmIoYV/u
	J8dfSgMx87Dw6tb7q2Xkvkpf/xCk1ZvSw8DBWmmSxGOumwF+ooDaKs458xVh6AIQSBlPoA8YvZX
	Nbr6e4SP/504=
X-Received: by 2002:ac8:5c95:0:b0:532:eff9:ca08 with SMTP id
 d75a77b69052e-53320176517mr17828151cf.12.1790534582640; Sun, 27 Sep 2026
 11:43:02 -0700 (PDT)
MIME-Version: 1.0
References: <202609271644.eX9EFdJw-lkp@intel.com> <20260927110407.8641fb46613365094f4d32ff@linux-foundation.org>
In-Reply-To: <20260927110407.8641fb46613365094f4d32ff@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 27 Sep 2026 11:42:51 -0700
X-Gm-Features: AclHuK-6Kh0494iLphiRrsts5maQH8XA-Kq7q8l8Cfb9ycF_Brcsonq-LTJ1WjQ
Message-ID: <CAJuCfpEyW=rM7T2iP3pv3fbAzH410twAmxUbMHzKDfD4gF_F-g@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION b4fc90c82982d98959af08b4320420bcfc01303b
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: m6oc8133rr4umwqbfqm1hotudsksxac7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 29B81C0002
X-HE-Tag: 1790534584-295798
X-HE-Meta: U2FsdGVkX19GLNYa7ohG+4Di9/CZFsZMEfUJpbbQC3ftX1tdacxcwp/lt7PmT8TajQWYxLc0G321UCni2zxOQ4J1QIt+EpIwja8g7FuK3RU+0mXDmlMiRWHlsLH/OxXTCnY6iNSuxZFTvWYRlYUwrC6cCzCK8bDTi3FoWQRGCvk4vu/VvMiJlGzVEdncJhNKZfNwBCixD/CZ7ltt/aHPR70TcP55dvehnFk2X151FZlQJMLuTisYqZezHsogjZDaihrr0yMc2LzjHVW3uhWM/7uV3qtdEmWfq8WcJs5nRuqlknl8H/DDlaQCjBpVKodYSY5oetUghTwF90x70ZA9l0CTKI1o74ezgqlj5RpRZRfscLCFAymwI/fjDj8bfdXBwXkNiX42bOQmRKHwX8zVevTcuS6XGGw9sK/HDLQXOc4Qaol0EDS4SOGCLIvbKRSHE+jkWoaeQCtNAe/rUfdPTylvzaYgm2cBNkoGrgzumfHtCzA8abb4Icaw/uW8Za3V87zNZJ1XLanG00j1cRYAdFRLIUMo+79/REPg/tHFH/y/1KcwRGSNQqVByK6NZ5mrVFmxi9K48CLVlRO/0qdy/QTom47CUbATYaFbRCGvXiPKMZNuWZfkq+vUUgviClDWOzq92Uz/VNAjMioxlHquKArXHwOphiyiIXiHlax3C+C9xNXyJyOUjU5NOF4hgcX3Qy43pDzKOgB81Wftgyq7Zl33NgxhDgL7+8rldeVoTx6trPU2nzITamMMS7bxJEi8vYZxwhj4AZson0dSbo6U8Wj1me1/lJAxTNuUal7VTJPoN3FdoF0Ekq6m2KIif+0WSVjzngklrfPpeLBi+0Pa3S50OFoLcY4/tjWgMy4+7CKcSZ96vIgZaklnjQC5L2cS89DTcyLLeH8klQQFDBdVJxWJfWdNi0fau+VY73C7fYLt/QtV9TD57huQp9xtKl6bANWAOB8SXa+ZvnFLAdu
 I0C2Qg/K
 rpdiRAJ9up8TapmL55QXpV3BQO2QvNRX+1r09g+GBdVdiNPhm6HHLY9XrMCoByVcyIUWbRUwzHilNB1FBC/H/LG8k8DPtFJ4h1sXD25QJ1mMN0Vk1KQR85EoqmSw4ucd31j6WfKBvVyO8aL6ttDy3GJ02l+e6ZuHNbN5pgiNBOsnLc8EZ7Lazt7lRBemz22zO/NhNmLDKfTMfYjqREdVI3ftK7qFiTwlfxJKAQJWsZuN4NiKPhzFsenet8ScCNZwyFq/nw1n3nScbTvH8gYYUGsW3xxesBV4LMrbVc/F3Lsi+MRAJMm+ohr/8RzxgV5pPAmRgDqq8Wf2QMNE7DUPEV09DxK+Iet4jPD4gvaqoXzG6hyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 27, 2026 at 11:04=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Sun, 27 Sep 2026 16:00:49 +0800 kernel test robot <lkp@intel.com> wrot=
e:
>
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.gi=
t mm-new
> > branch HEAD: b4fc90c82982d98959af08b4320420bcfc01303b  mm/swap, PM: hib=
ernate: atomically replace hibernation pin
> >
> > Error/Warning (recently discovered and may have been fixed):
> >
> >     https://lore.kernel.org/oe-kbuild-all/202609160337.WJiD9BqX-lkp@int=
el.com
> >     https://lore.kernel.org/oe-kbuild-all/202609171159.oaB1OaSG-lkp@int=
el.com
> >     https://lore.kernel.org/oe-kbuild-all/202609270030.Y0QVBPmK-lkp@int=
el.com
> >
> >     aarch64-linux-ld: Unexpected GOT/PLT entries detected!
> >     aarch64-linux-ld: Unexpected run-time procedure linkages detected!
> >     arena.c:(.text+0x11fc): undefined reference to `__check_safe_pte_up=
date'
> >     fs/proc/task_mmu.c:3450:17: error: implicit declaration of function=
 'drop_rcu' [-Werror=3Dimplicit-function-declaration]
> >     fs/proc/task_mmu.c:3450:3: error: call to undeclared function 'drop=
_rcu'; ISO C99 and later do not support implicit function declarations [-Wi=
mplicit-function-declaration]
> >     fs/proc/task_mmu.c:3450:3: error: implicit declaration of function =
'drop_rcu'; did you mean 'drop_slab'? [-Werror=3Dimplicit-function-declarat=
ion]
> >     fs/proc/task_mmu.c:3452:17: error: implicit declaration of function=
 'reacquire_rcu' [-Werror=3Dimplicit-function-declaration]
> >     fs/proc/task_mmu.c:3452:3: error: call to undeclared function 'reac=
quire_rcu'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
> >     fs/proc/task_mmu.c:3452:3: error: implicit declaration of function =
'reacquire_rcu'; did you mean 'get_file_rcu'? [-Werror=3Dimplicit-function-=
declaration]
> >     gup.c:(.text+0x2b48): undefined reference to `__check_safe_pte_upda=
te'
> >     hugetlbpage.c:(.text+0x1a8): undefined reference to `__check_safe_p=
te_update'
> >     memory.c:(.text+0x3418): undefined reference to `__check_safe_pte_u=
pdate'
> >     mmu.c:(.text+0x9a8): undefined reference to `__check_safe_pte_updat=
e'
>
> Thanks.  Against "proc/task_mmu: remove unnecessary inlines in function
> definitions":

Thanks! LGTM.

>
>
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions=
-fix
> Date: Sun Sep 27 10:59:53 AM PDT 2026
>
> fix CONFIG_NUMA=3Dy && CONFIG_PROC_PAGE_MONITOR=3Dn build
>
> show_numa_map() uses drop_rcu() and reacquire_rcu(), but those helpers ar=
e
> currently built only when CONFIG_PROC_PAGE_MONITOR is enabled.  A kernel
> with CONFIG_NUMA=3Dy and CONFIG_PROC_PAGE_MONITOR=3Dn therefore fails to =
build
> with implicit declarations for both helpers.
>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/proc/task_mmu.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-func=
tion-definitions-fix
> +++ a/fs/proc/task_mmu.c
> @@ -196,7 +196,7 @@ static bool fallback_to_mmap_lock(struct
>         return true;
>  }
>
> -#ifdef CONFIG_PROC_PAGE_MONITOR
> +#if defined(CONFIG_PROC_PAGE_MONITOR) || defined(CONFIG_NUMA)
>  static void drop_rcu(struct proc_maps_private *priv)
>  {
>         if (priv->lock_ctx.mmap_locked)
> _
>

