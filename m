Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CB7CCC6B0F
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25B596B0099; Tue, 13 Oct 2026 07:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5236B009B; Tue, 13 Oct 2026 07:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4156B009D; Tue, 13 Oct 2026 07:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D46156B0099
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:46:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C9BB803F5
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:46:58 +0000 (UTC)
X-FDA: 85317426516.22.A4F90D5
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 652FF180008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:46:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="BowY/KEc";
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791892016;
	b=NU2pEWqbnX/ClgXDvBWyiLFLMPSVQ+UyOeH+/eFO1mCE7z/T1/1TT3TnIzwOB8fWYHydJd
	y/QHiut1q1IJ/CBQTQ0Zt4pwBmg2EleVtUTI1fYsEKFGdRPVT0vjpBmAz5nft31kodBs8W
	TjWHhU+yqHVBaDc8aqrlVRMKbJPOUbM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="BowY/KEc";
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791892016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e50qtwOpKMO/U4AtjtJKqyhM36icTenN92VD9AuVD+g=;
	b=UzNbKJ9BvxEqTxXyXUwATYKubsfokBA99B/W1iWnjIc22Wwz4BQo3yHvGVmdO6mN1/eVAR
	tgKnyEWJUQnuGJbFMsvYIvS/GuqWRdcCYTyMucaWdwkYbe+cmpP7AFdkeucmSRMMqTSGdJ
	H40tjVHMsyvZfX4FZ1JVeNOczhLE4kE=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-535f598d126so93281cf.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 04:46:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791892015; cv=none;
        d=google.com; s=arc-20260327;
        b=ZJHaQbqO67D9hCPKtpto9F4ma1LI48bSw5aT4JsLsah5uDT3MBScwxUwg4yIWhOehx
         iH4mhNLx93tlj4WDYELTBjbdj8ih/OWmBPsJFZYSU0eKHTfMndbNRjiEWY4Th9ofFCs4
         zG5zLnMlGTRLIySRn9hSXaC0VXUJm1WGDyCsGQZcJ4DyvhNDNa6RQXB1ZI1mw8hNB8ru
         /sI/9lxduevfFVEmhZ7l7Y4IjTnE7f2EpYU2RxXRj+kU+wG2LnPd+2/uX4Na5WYjRYBy
         ATCl3tFUVoBl2qZX3mqC+eMXLZwkPTjp4bVh++iP+LNvl1xr2K//P/h6Wq1n7Qtk2o0U
         zCvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e50qtwOpKMO/U4AtjtJKqyhM36icTenN92VD9AuVD+g=;
        fh=SJWLKwLZCVU22Mmqyak0Xnc0TGnwdcrnMmNcwBhA72o=;
        b=R6HpppisBk79Wv6S/jLYcgUVr/+LLklEgsrETwaT+led+7Q5CqVGSaJIVBZrdkqzdw
         g+O96GypyrNTwVWYeso/f0rb40ZFew5BcTbibS5edpGNhpG0jhUa4P7kWWIOvgW0pmwI
         PN1wpCWWFsqt5O+oFmS1QqRyhMkGQOQ6cK5cJAthoL+lI1QQsiYu63IFWin4CAkmwINJ
         ZP4nk7GYzYUVhx85b6kdYVx+b/BnAXhWW+NCAmzneZ31c+YGQjAkOy/duutrYJTEL6/S
         p2ty26lQZDEuggpi+rriEJgm6nVbVazv3b8Y7ukyXA0ywvP+aGCx84tjXb9TgjXgOq5+
         fQgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791892015; x=1792496815; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e50qtwOpKMO/U4AtjtJKqyhM36icTenN92VD9AuVD+g=;
        b=BowY/KEc/SKnEWvkUwy212KQc+F6pTLuwyl1RCFk4y46Cd0OqnR0gbo6wjpCSYEneX
         5AkPZNp64N0MT9by8yRJjsvAAZQbFCYiIZ0zChTjT+0I/qXitvKj2ADhAYdj5nImNKml
         A3cLAbrnin+II1LSCrPvzExeq0/iFj8n/xs12Lzyk6c/TPSe1DPxIaMcMMJh9YIR/wDD
         r6ZvEWruWo5qHQDGXlVs22uL96OpsB3jjKTKXbmfVf0SrqwXm/8tHjI5dUHwHpV4+k5v
         92ygtMxGFwEV1rY+YRlYQIFDfrgoGeA9nTBgwPDbCMjtLhevxTqpDg8oKwhStBwLoLKW
         LH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791892015; x=1792496815;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e50qtwOpKMO/U4AtjtJKqyhM36icTenN92VD9AuVD+g=;
        b=i6H08OyPtS4FD7HiqKhyAOJ5ScXDKcCk64CjXQUFOvtTDC2SfcmFiID58hXOguoT6x
         8yzGuZLItbSMuKkBydkIqguHjatcJ3aupVKoDeleOhSXc8uOf9r/lHkTLWhgrcE/aBC7
         fqWVX/Z0SEHQ2wKZedAv4FZg9tVdMCMlvLRQqsONqfhm0VYW+HwAIDAoGaLAh/lGLOKj
         jvcWMkt0uyG0O4LjSunFG8BBP7utNl2V2IFEtk9WpvWiMdOqclXpvVePL4PwmpmVqRZI
         YSK49O61xaCB/Aliubs+0I4ItG9cS4arSc/BKfxQqJAzYp6kVDjb/xAT3hUzqboKwt6O
         5r6A==
X-Forwarded-Encrypted: i=1; AKwUvByYNi1WkNhghz2dvue31ovsaMn1Ywqy7sz+cptiaiS3PjWdIR9ELlf6gkLspXa8Z5gjgdpKaLnWwg==@kvack.org
X-Gm-Message-State: AFq9FYLPVDt1yVRRmMAKwpDKONmlOS7jZ/3FT0zZ8tjiDh3nnQudKg43
	ZjMziznZJ4hUVQOhSKcCYQSGzcdHaDraZ5505TmRVoop9EgbOXnWSJZ01e143FMQ8s+55IXEbiW
	o3I/VztIja/J8m5h2fFoElY7uljq1TAXcgpY66Bij
X-Gm-Gg: AYBFou03HnK2MTvL2JxA4aufOjxkLkPA9WteDlW4e0CPWY9VLRdorkwgMG4efVoRzgc
	jcke2LVdwAUv6rp/KnD2ZRVgksenAQZIaYgRH2XTjBaVg6hFKvBw8Ub2bpcRXRGutiwQkaAxc1X
	vHn0kZd3T5MJCdYbo/Vp4bRJDKS85g8Vc7oSZgLbqNp3ErP6m8lTO850FhuTx1q7QZNgb5lPMXw
	wkiVFx0nklxF+B537wJIsHT0nLcOz8rsfh5OXVDGPumOFK3qfQ81RYDLBjJmjtBdFTP10emv/zv
	YCEhbnmENa2bid86bALpdhuT4LZ39V2vUtYwn72HZMJgBF+yy7MwtHsaKH5+0qDoNK8=
X-Received: by 2002:a05:622a:345:b0:532:eff8:3491 with SMTP id
 d75a77b69052e-535b4f9b8d1mr44577431cf.14.1791892014742; Tue, 13 Oct 2026
 04:46:54 -0700 (PDT)
MIME-Version: 1.0
References: <20261009063619.112313-1-hao.ge@linux.dev> <20261009063619.112313-5-hao.ge@linux.dev>
In-Reply-To: <20261009063619.112313-5-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 13 Oct 2026 15:46:43 +0400
X-Gm-Features: AclHuK-C9Oa0XUvUff-bHIAvSup9whOwQ_UowMIbXZJ1HaUMoBUz_0yhskfwzJI
Message-ID: <CAJuCfpGEgTocqrdpOtkOfks-geU0vVMZudNEG5+XWi3sxQdymQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] mm/percpu: stop unmapping the CPU that failed to map
To: Hao Ge <hao.ge@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Uladzislau Rezki <urezki@gmail.com>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 652FF180008
X-Rspam-User: 
X-Stat-Signature: fzj9qgt1kdzoeh8owxf5wbt59yf3bj3z
X-HE-Tag: 1791892016-10655
X-HE-Meta: U2FsdGVkX19kKgSYNxXro9TPow1qQng9LAQEw+xfRnroBlxDwumF3zNJQ9PUg8yVH7+/2wb3c4XGo3gOkMLKpayXpwii4spSCXHiX3YLN5MB845Zp7l6fsBfYQfm1cAmUJlm8PQbBmrrFmvPZS/L+YjZzwCd88TA1SHCb5l69ksU8hvQ3tcVe8RSVSWdSGvvjbBtfgDemI0vrgCLwHpUceoLghxzPNhZb1lWqrDWpIa/baRvFICfNlPPRhFXaOUklMML5t2G16P38Nh4f2+3PRrQAsBnIFT8DARDYgyYumU6PW9zSbYl4tbCRgbi6y7DAMQXw8uXhALZb0KYH+egZW0z8vyOBfAD/2KAh5CXcAAyoRmTFenXCnXaxPTxMdb2uvvNwnMIHmiluL+UQJWGRjLyBotyaj0x2aSt4+wsO5ZkiI6qUVfM/jxsLjhz2xxom++qo0ny6vxSeoc0qbp+j90Yvas/r7uXjN9m1VktjoTDN32UCoDiqvnU2LXBsxYaed3zwMZyLICpFm+h3Qis2ROqmlUyq4YLipbWC0RUYKjFMMwGPaSXWZ+1PIPPqJbJvTSlj9GhfE/Q91kdrM1iUg2x8X3eTQ1uDz2ABcsc7LARYjk2z2qc38VQUJaZ3b2RWTMPCEoRyOy3vbqmSLp/dzWVAwCUnUrmG2RSyFtEEAWTyBdyR0xUWihGqFfNPw4Ob2GEaOnNTWRsuGnBSLIcQQj0JkDtMIpd/iuz3FXcbdgQiMUEIQDp9bim2o44IVmrYHSmSHuXYrrRQqQjV4jd4c9/dOoLBZ5iOMLBaPWr2j4EBuR0opRJmpe0Urpli0mrKaAUALhuC6imG+1JLPJYraMnXohv+SeUrxKttXdom0FgYI91MoHDwrei5QANnHm2xZaQU4VeNWxD/X7F00GcU5ZeanH0dAZdTd/U+yzQ2h+YwhJIpbyj5h91ZmatVHytZbw1+gqqKk4AdHUZpNz
 hvXJA3sz
 cn2f5SBVjwdd++IY/fz+f4DfLJA1kxaN2O0IErBchT8QKMddLEcLZmDRTdRnRq+5u/si1oo5wfUGPlWgMjGKypSO5Pl07guVbXlg8itu9/Yob3b+VftBk1fDyryLfLJ0gjYVJnT3QM2jTL/jo5arrPcKgZH5EkDABmec/XFNe8C37HFlDu2+S87WJS7KjFVl5b9rUit83mhH5q1oK1nQQS5opDCmBZfJZMANjsuOvqHl/dOC0CX+0ATu0WT/StV96E5bQr6Pc//FoC4aGSmI/qSs+evOHHBGO8tytsZ6IpKIdQgPrkELmTj41aZUCCYHqs6bguZ2RAJ3p8cgj5MXB9EXotw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 9, 2026 at 10:36=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> __pcpu_map_pages() clears the PTEs it installed when it fails, so
> pcpu_map_pages() only has to tear down the CPUs it mapped before
> the failing one.
>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  mm/percpu-vm.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> index 509d8901835c..59d3a336a6bd 100644
> --- a/mm/percpu-vm.c
> +++ b/mm/percpu-vm.c
> @@ -252,10 +252,11 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,=
 struct page **pages,
>         return 0;
>  err:
>         for_each_possible_cpu(tcpu) {
> -               __pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_star=
t),
> -                                  page_end - page_start);
> +               /* The failing CPU's partial mapping undoes itself */
>                 if (tcpu =3D=3D cpu)
>                         break;
> +               __pcpu_unmap_pages(pcpu_chunk_addr(chunk, tcpu, page_star=
t),
> +                                  page_end - page_start);
>         }
>         pcpu_post_unmap_tlb_flush(chunk, page_start, page_end);
>         return err;
> --
> 2.25.1
>

