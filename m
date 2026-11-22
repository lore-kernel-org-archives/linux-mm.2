Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D067C606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 03:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hhmZDAQe
Received: by kanga.kvack.org (Postfix)
	id BAB7B6B05B3; Sat, 21 Nov 2026 22:27:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AF36B05B4; Sat, 21 Nov 2026 22:27:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73346B05B5; Sat, 21 Nov 2026 22:27:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66D5D6B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:27:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF24A1C1137
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:27:41 +0000 (UTC)
X-FDA: 85461320322.26.40B5ABB
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id D9F79140005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:27:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hhmZDAQe;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795318060;
	b=YqysM6mzHU+IFfyv3Tim9PdM4tbhQyEwNTAhgAlv5xeAuZyL/X/d+ZcPq8UfJjIZ78JC3m
	c2tZDkJQfCE+6gvSZelcz2IIsYDFA658NNNT/pUFhQAZstEyvz3O+9qm5VtAByDFHDYY15
	pQAhfb4Lh8nmQPtEtyxbrHBybPqVapE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795318060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQuu64Lnrpq9I3PH64EXbxDYmc8Cf7fUiyLVTDHPmr4=;
	b=c0JPZsnOwy5xld7lV5762+7oeFURXxAjAx+6pp2Aq4edRIWxZZRjRud5kuMtdJTbcBnrZa
	upUPk5TRb/CRCr4M7K9oed5nipmYRjVpIuKthE179N4k5gk4hdvkXvIaLwLdzKcxFVEEyv
	94dpTDjUl+jPSawDm4leaxCPgom4J3I=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=hhmZDAQe;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-533202fe429so206711cf.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:27:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795318059; cv=none;
        d=google.com; s=arc-20260327;
        b=ftw/w70i6uwFOHQQa6KW2jlaZSvNkzJkFegaPNpuBsW1+fjmDBTqsG8YD+l0eHsVLS
         Zo0mliOtJA3wyIBsvssfBMe0/JQ8XVGvdA5XJxNMCL+9FP8Ye0TGQb0RsYLDHN2BGD4V
         F0CbyAtzR0mF+cBWe1dyOriWvfkHRHoWnqizAGRmiqgRyko2UrtlmzL9s7XVh+XyOx4n
         0i+AX5GDZvcrxK0GiRUJAspgCdHZtJmXH6CvJCAZ8vNX2oPObDhJsbRIKEpDOzvHarYY
         OXywUiK6ZeOR5PXLw7vipKbR44OM7bDPWjsPiHK6cwZnkg1LaJ049HERNgtlXzmATBh9
         90Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aQuu64Lnrpq9I3PH64EXbxDYmc8Cf7fUiyLVTDHPmr4=;
        fh=doLqsDUzHy3sPRQ13dWSfHaP6chuhkurMnR47bo8ZYk=;
        b=FcIIHij214RSMnMWOUc1biWiKyWeTO+ogNS28+ne25JTB/H+oyzVJLLGwWMnpj+5/J
         W1HSimLtV3GNnM7s+LebIOki7NlM9/CgASUSRita8dm0byh0RDIScv8AePtd4C/SZePk
         BTSuF32CScqD0TllxLKBFR8LCtnQczS44CIrWXtpG7hkPl+/vDeeAj2EPb7N7cOQRr5Z
         0laN7+t+qqdmRzE5y2QP320zZDjGWMGgIPYLav2tR4L0KQ8tlLflCcDVpgghbq+o38cS
         FJR7Z6X1Z3EdNPkInvwNkeXbS2rdZrzYnoXz4lYAGohtyoARnXcKemHb5QriJqwgauXj
         GaMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795318059; x=1795922859; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aQuu64Lnrpq9I3PH64EXbxDYmc8Cf7fUiyLVTDHPmr4=;
        b=hhmZDAQeAcBgUF+E6QN+eAGPhdCAQqGjtDkeYtTvri3lb1MyRnpHINUyLqX7/dXqq3
         23qkQ4klwDU4RHLPmZHeydcUs4Tf9LdJTHQ5fNylA0RFl2fLZslY8ky2e+k1OEl3oNNK
         MGlz2x5hv1x6iiP0WPcKuhnbi38jwKkdcqcJOKtUYEmQAuTBluXoXR0nGe5xeIVvyNnz
         qIeleX0WWY7tKzQ5oITKdzUPjFxQVOxKzVTfY/Cz6DbMC2baKMrhlVyAXoNLyE+QCc5R
         q/VoqfiGz1XmwCmzG19ZCKo2g/alAkL+gAokKwu7+cCBCz1ZCTA+pJTFWr6D50/w5rEB
         onGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795318059; x=1795922859;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aQuu64Lnrpq9I3PH64EXbxDYmc8Cf7fUiyLVTDHPmr4=;
        b=XvHnB1C6Ftoqbb+j1DYz1rYT1sGlXAF69OFkHrmQbxqb/2q+I0St65w6kYP20MA0EM
         gLI+ffC3neuO64l0UFeco0CoNzDn3LNPPQVlTypzplGU9kc8qm/x3jTwT5NRs28nj5Py
         pjRT6kVvbQcXXkbRQ+0zFLYEhwPsU5kVwpFLnHDS1Oq/fq6JVDokgI4vU7HOg4aDrdKP
         Q4QPPEuV4tuNRJhAHagdJKkHHA4/YG7tCjOPvyZPOCZ328vt2N/3xlIOlYh11E71MUDl
         2bpWQdvi7xnhPfm3ENDYViB8vacc8Q1pqZarWj1OMcEJZ4Bbs5WqkRN2dnlF18lS3qkH
         OCpw==
X-Forwarded-Encrypted: i=1; AL+hErEIF4ipIdTktqTWHCALOP00OZAfDglf5aVUFjUvKingN0QkdJv0ALMlnV83WeOy4mTHyJFhXJaqNA==@kvack.org
X-Gm-Message-State: APuU4Z8BFZUQhEAOH2tp8xp/V7nuYSNXbrEcE6z+rTN/ZBmbLQ65mBD8
	w1Sgby8LCEl+TkDNrb4j8UzOfx3OWqPAnzjuxhnZJQKZHIrwzyW6KxMK1YWOfw+VI/grLARQV53
	SH70GMW6DUNbYGupnBP/x0TUDGrOANK9htFoGsLss
X-Gm-Gg: AZFdTZeQxJRF24PEXngbAsRuwoXc5LODuMwJ4zpwtxIEoD3JacA/1ql+krKa0/DMAYe
	ORbO3BlYY4SHHYY9vKgdyyBZZs7x+z98pyBzrFoLjOLNBDyVHEG2KheNyrbocOdeJhvC+1nt9Bs
	esAKBQtRd59Rl6gBdS3nvx0ZDkuCTM5bQvuQrq9+W9t8db548AekQYQaG1tWNBRuNN9CE1pJ4N2
	kKs+jWrmqhpUn8iqfSOpBYK8Ao9kY//lyjS2ysN2+9iPz6NPh7S7t7zNmkWrkNa4Ti1einYp2mh
	K8o/gowH0xDeBzEI5vFjzkUJi3vpwyxIznlro/kkEWk7XiMhNWn3F5uuyFOLAqWsou9jyXfXSEF
	KRSFZbjqjL9LZk3GVnhrS0NB4XOP/IAmjzxT90TzsFKJtYCIplT0u1rGS0Xhv2blbdGwsfEw=
X-Received: by 2002:a05:622a:5594:b0:534:d386:c3f1 with SMTP id
 d75a77b69052e-55d8900c88cmr12803541cf.9.1795318058238; Sat, 21 Nov 2026
 19:27:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org> <20261121-some-more-ai-fixes-v1-3-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-3-236e925d9b64@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 21 Nov 2026 19:27:27 -0800
X-Gm-Features: Aa3M54pbSuLu1xqUqKb1UsA0ciFH-QHE34ZIs3C9DZaD8srMEy0uzBAMlfeJdPI
Message-ID: <CAJuCfpHipq2N9xHwj+Uc4M=Xxw2fe8yJgKnayYvC3H9uZc-uyA@mail.gmail.com>
Subject: Re: [PATCH 3/7] mm/ksm: only interrupt unmerging on a fatal signal
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Ollie Wild <aaw@google.com>, 
	Adrian Bunk <bunk@stusta.de>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ufadn6of8hxqmniurbjktprkfuuoqseg
X-Rspamd-Queue-Id: D9F79140005
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795318059-486138
X-HE-Meta: U2FsdGVkX1+aYXFmc8oETT3fcABXvH1w7ZZ2m2E0qU+9XlziBEJvUId0fw7QBqq5kXSezhnhjxitPK1z8j1u3YFW+0S4C9qsZCwP1+ieZt/ScsSpv4qCXQ8P6Ho5odCHuVcal7afVawz6DGU7fZL2RBzhuCgdyLafS02ua+IlA6Db5aZrTO2XYFDzi0WYLV2jTY5ThIQAYv16OxL+GZ0ntNJTs7VciZqnTrfAkfbzu22ZceIgNzdpOZidlfD2T62NUFFxPVE/4DwDUPDfAcb5KFuRwMOXzipcnOos6UMoN0KhFvMRJhNJcMpZu9rQ4xppOx8rrjzVpOmOYLKXdcWFF69c8INuizdeLM9PxOJLqw1D8KlLF+iXIk5H5+DfBrVej7E+3BUHe0RSzUigYI4mFiNzLxe1vYvMR3tLMkytQ1Wv2ukLtJ8ySQk8cz5HoI0Eib8wFd+YvYde4blceCKURCf6UXzySuUAKHa7WvRSxXjOd+ENPRhozNZa22tpeocmEkEusuZH+bAJNhtNUl8z8+yGEY7wErhMNh21XxBox9kKklMuMNjrv/cQaJEeKe6Qil4Npf8uYMUKEplYj4nqyAyVJpOC4YbgxFoO4m8DLpHblD1nYiyVwKyXwihAz/qshPNWUx/1hrlj6HvvsiLRo/js0TQkKMD+1IhNyKD0tSyTx1AoobEW6qGIW+eGBWZzGUQjdVtII3B1Q+wWn+X8rAMct2buvhfMtFD2JzRbv+8VYLeXU99VXQHL00qFMPD2WdxrEAvMcT5jZk2b1hQV46isNv12jMSkhHr6EngJc3tjmGagoZ8juWmMAxrAMXAM9T6eGkDj5lI+HSAMx2FpoUIzXpeGcoIG2V3i4UiA/X5zoguzdZFFgpxidNN3YcefnJVj7n5uxpk+1erAB10zm1kOP78SzT6j8zZaDh009i5Kz42yhWXtx7+Gz4nB7Ihpfmb4ZVuzvRqmE4Vd8T
 8Wtl+MyL
 XFzzux0YMW8up6dDj6HPizk5BdlwZXTz9dPemxkuH/5BZ4B3uqGzJROXZxdTWtNqMFeKUOYBLOB1s4r3I4w9uNWAf5ZlTPA9Dvii5dRYjdDQsfmy/gtKZJvBFwK4TfODpCZRw12bo3p2bdBfmKTs+EaobFiil6dIuRtZzD2EjVdRFTkjl3V5kX0gfb3Udm3s6JpguJxQI0G5W4xyfMphkduGe2NcMu25kRS0aKuQFohnACyGiazit3cBD2sU80OIEkoqkSd0oDiVeGdu7S2LJmGaeF0CxCvkdN+M90zzRegz5P3VFykmwLsI6FTyP9H1+XpvIN9KJ83R7DeKdLmWMEfl+8V8VH/kl3WqneVmUeUn6Q/wuVuywXlgbjE8URAuHpBmv4yEWuNTsfFuzJaUNxpfJ+oTnJiWp4ERTEPOHPxegzRdAhl5kCjVx6UzuyXsBc0T/9TyhQp1aWuVfjnBe8fCEWRLbt4G3fCFDwfXifip4/eFWYLVNElG4gLhYKnsj8YLk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 8:03=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> Commit d952b79136a6 ("ksm: fix endless loop on oom") added a check for
> pending signals on KSM break, so that a lengthy unmerge could be
> interrupted, with the system call then restarted via -ERESTARTSYS.
>
> However, it assumes that the callers can always restart whatever system
> call started it in the first place (the commit message questions whether
> this was wise).
>
> Well, it turns out that it was not wise, as this baked in an implicit
> assumption about system call restartability, and it was and is not safe f=
or
> mremap().
>
> mremap() holds an mmap write lock over the operation, which an -ERESTARTS=
YS
> drops, meaning that the restart is not in a consistent state.
>
> This was made considerably worse with commit d23cb648e365 ("mm/mremap:
> permit mremap() move of multiple VMAs"), which can result in data loss if
> you encounter this issue.
>
> Consider an mremap() specifying MREMAP_FIXED | MREMAP_DONTUNMAP of two
> KSM-mergeable VMAs, where a signal becomes pending part way through:
>
>     first pass                          restart
>     =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D                          =3D=3D=3D=3D=
=3D=3D=3D
>     unmap tgt1 range
>     copy src1 to tgt1, move page tables
>     unmap tgt2 range
>     break_ksm(src2) =3D -ERESTARTSYS
>                                         unmap tgt1 range, which now
>                                           holds the data from src1
>                                         copy the now-empty src1 to tgt1
>
> This results in the user observing a successful mremap() but with src1's
> data missing.
>
> Without MREMAP_DONTUNMAP, remap_move() would find a gap at the start of t=
he
> range on restart and fail with -EFAULT there instead.
>
> Fix the issue by only breaking out of an unmerge if a fatal signal is
> pending, returning -EINTR when we do. This makes KSM unmerging consistent
> with many other signal checks in mm.
>
> Target commit d23cb648e365 ("mm/mremap: permit mremap() move of multiple
> VMAs") for the fix as this made the issue significantly more impactful.
>
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: d23cb648e365 ("mm/mremap: permit mremap() move of multiple VMAs")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/ksm.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 623a2cdb3924..5d320a200951 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -627,8 +627,8 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned =
long addr, unsigned long en
>
>         if (ksm_test_exit(walk->mm))
>                 return 0;
> -       if (signal_pending(current))
> -               return -ERESTARTSYS;
> +       if (fatal_signal_pending(current))
> +               return -EINTR;
>
>         start_ptep =3D pte_offset_map_lock(mm, pmdp, addr, &ptl);
>         if (!start_ptep)
>
> --
> 2.56.0
>

