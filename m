Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DE6606A881
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Y/AJAEOg
Received: by kanga.kvack.org (Postfix)
	id 578976B05B3; Wed, 11 Nov 2026 16:04:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503076B05B4; Wed, 11 Nov 2026 16:04:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA7A6B05B5; Wed, 11 Nov 2026 16:04:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10A0B6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:04:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E0591603F2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:04:09 +0000 (UTC)
X-FDA: 85424065818.07.7AE1CC5
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7FA4C16000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:04:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Y/AJAEOg";
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794431047;
	b=OqNkFmk/Y6fTE7PkSp+X2+tivZTLwckN7oEibE7Kg1EHYaqE5VK3L6DRqow/9JQDLg4Tw2
	PMr62gggqRu437EriD9R850sR5rYUhprTybWpIouEHX3eniVdMVyHFHUAoU9zRrqusHj1h
	K2i/wEjz5AU5yeLcplZWVDVOmSV0UeQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Y/AJAEOg";
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794431047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jfAi01Q4CRlBo14NA8JUFvh8yBOtjDMjluJPzC/jYk=;
	b=0CkxLOpGaOFZ9fMH8/1V+VGIhY4oiUWOy+A/FKZtl4ij7Y8XjSpLGXKOThpcyZy1zfBPX5
	G2AmX9ANQ5DcdHMc+oyLAatPLRNz5eUq1ouanapfEzS7bl8Q9lyRXOSX+DrgZnED3Dj4fo
	PLOOTMwb8f1Vc4B5a1CWvgejyW2PGUw=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-533202fe429so9041cf.0
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:04:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794431046; cv=none;
        d=google.com; s=arc-20260327;
        b=IIrUgbQ33kEl5bE49KulO86H4V7bHtpvpgDWTgUKECCv4We2h6l56nQHiI7j4/OVcS
         n8uhJAg2oapibrln1ALK1RKs52snCrAZFpDjA7liUH5FnglcRBshit7ZKX5s/Mk/ZeqV
         vdQfRh9YinQxV8yC3faWsmWj/ya4zI/EBAa/dfsKFFTdokCEKOS3GOi70NB2MhJssGv7
         ai9JztSsT+u9JLEEJVJNd9zOXwxYXBLuLE5o5nR0oKFDHvkUepdSKoGoaRZzxNrN+CTy
         O2s5S9i2nCwQJzAHxYPDyB8J7o+tFX31axEfywPBdGs+J4H0sQ5sNPXl5qq1E9VIVLhd
         sgYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7jfAi01Q4CRlBo14NA8JUFvh8yBOtjDMjluJPzC/jYk=;
        fh=1bLU26zYwUhkeSwgnI16BwudINYLtoVa81Abcvq+A8o=;
        b=GYjb+K3Mf81h8mJ4agri1qBeJS/Ft7x3/GBbcbAj3RiWkWj7er2il0g39QqEkjc1b4
         fiJ/ViORDXNYDIuzQBZ28tSgCOJ8MTRpr2artHOEF25SeEMoqV+rxPg3/W4lVf8Zwi/B
         I4ESiwLdL5QUxGyqQczFG5vFJybO1pikj2Mn6ZiOVaHsgeVPmwRA0KyQ9uC/EcNNEDPK
         v/YfU+3aBa5WLBE2Rk6OoHke8Kgpk/ce0g70umDhPb/H0C+ExSlinEpFS/kaF0EPXbNW
         btovX7ZbNr729OjEyYoAEXLkrCDwFrQPALxqD83+qlcREK/WdfQ4GQ3KdqfTbONp76kC
         W3JQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794431046; x=1795035846; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7jfAi01Q4CRlBo14NA8JUFvh8yBOtjDMjluJPzC/jYk=;
        b=Y/AJAEOgymE68NjyrGyMGPZevuN7MEFGBrwhKODhCCS47EpfNipu1pkIC3W50Em2e6
         z6y3NL3OGSLQr6QI1GkBcum8aWW9NOZRe5VXeag4sGD1Ic11qTQMv6fhGxEX8tqMjSVa
         YynRzAXfULTBLxuV8Rq4qe2XhfwVsF2ZQyrY/08lC7swpbVIjKOSwNh4L9sAjKTopRz2
         LLSOxndS09Ed4anpJMcfhtcIyp3+V6ZL4Kg/pyZ1zL2LSfOG6Q3F6bR6155D7Pyn8D6E
         rMxuvT2jY8M2xakt4Hl66kny/9X897WG+aBP3MWnRvhmN9X8+zJZpxcgVyXHFK0RaaQy
         Pnbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794431046; x=1795035846;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7jfAi01Q4CRlBo14NA8JUFvh8yBOtjDMjluJPzC/jYk=;
        b=m8marMWq6eNn/Oxtr3bvkqZW15Y5cMbq0Owky+TczK9A/GZdFuMJcAHiDRho+F7xdf
         Hvmej8WBjwoc2IVGTkX/CzioQ4TdIcGuEg43Ryycd6TcC+wQM3hP8bSyOcTnC4OvOSXI
         IW+Nzp2xtUnESZWTnO5MuNREChYZ57yhu4l9R1RPYk052LlcFBc4+p6lZtYjRDftUW/f
         LYUs8eZwJoT8kd59lbokFIFweFr/OAPkiLODu5YR6UB8wBSgjKkJr9+ZYbreDgdJmohE
         MJpqTAojGyQOTJovtpzZosz+mJ9D1NiCxQBJvkFhPmH5CAluWlt/hZvOEIwmh/DacQj4
         5hQA==
X-Forwarded-Encrypted: i=1; AL+hErFzAmPZMpCxdsK9WSPoFG+Be9M1GexHEtG8yk6SbAS6zBrzmGkrASBbRTPmjq0BpOY47rOBNIKjjQ==@kvack.org
X-Gm-Message-State: APuU4Z9VhRI3R1qTMC2/E7SizExSasjA8cPMshHVN9iol1rbgmp6P+TU
	PE3mSi6oo/4j3JZ2kRBfZ6QpUFruHTm5q3jqKjRiRjOQ1W2q016tSBT6elap9Cu0Xjbm7gOBdmG
	4fIFqawxOi3OuCKBT1YmJv50FVpRd7E2OjZf2pGqi
X-Gm-Gg: AYBFou0O0JnQQrz+AxoWK2HgMxU/+Dxmwz3FaMH3smOuR6GUSNwXEOtNQ8lBJSfqKHe
	8Vxtdt2YCpL1NFuoJQVpfcIUieTv6IMAnvVCGq+tboGQb6YqHw3zUqq5ZI13yDoMK+AGPL/VPhB
	Vk8sxpu3ifBFbHwzqmCPadUmxoAz/ZrkX12Zy0BR0bGXf5Yqj8LHXi+FzQ/lV5LJ3jtYc2+YRXY
	+DIMcLQ0zslF2cgvZDOCC0AK3zY8ooXBseLzHqCeJuD7aWYMiVPAEcLlsICN3BPdTdbmVYD9LGI
	rOa4vcECqRs0TYQp8pf6U6BvogxUVyxylB5Viuu/6PGD4i317DHnWG1RzmviaLw6qfq4MdPUeEy
	Bbef3b3DA/4S5FfnML6h4mQrc9pxsZnFIggEoo0M4KPybbUxs7p53AfpW/wFb3GVwVXwwnKAubk
	yCKpMsBBj2AYELDFnXRYXjsvth
X-Received: by 2002:a05:622a:2612:b0:530:e00f:7768 with SMTP id
 d75a77b69052e-559670434c8mr4152141cf.0.1794431045881; Wed, 11 Nov 2026
 13:04:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110112546.261415-1-hao.ge@linux.dev> <20261110112546.261415-2-hao.ge@linux.dev>
In-Reply-To: <20261110112546.261415-2-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 11 Nov 2026 21:03:53 +0000
X-Gm-Features: AclHuK9dy2sCAhDvi6AKjzXMWgnJES78GwGzZ1LsZZk9UkuHFg5q24wLvar7eig
Message-ID: <CAJuCfpHjSZhPPpRudAdrDPzz8dGK=Mx62CYCNoO4MC9OhnGd=A@mail.gmail.com>
Subject: Re: [PATCH v4 1/9] mm/kmsan: undo the shadow mapping when the origin
 mapping fails
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: intpqmmu7urnsj4doewkid7xzrzh1zo5
X-Rspamd-Queue-Id: 7FA4C16000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794431047-198337
X-HE-Meta: U2FsdGVkX1/6WDfmB0OTjkPKy3LJenl9/CMSjJ29/DnwJTBTvAIBARf1jt++1d4vWSX5ZDFYMwHZB1iKmte4UsR5tCxoqHByjnj8VBC6OOnX/7eJjZBeowFbR1ZE3hpQ66WsqitijQ/fy6TWZjbjF3MoI6fk7ZQafRdRZRWAJLt933KfC5+ZgGaUT/utHox23Ufb3nIRPRYm5e3SaOipb5X0XhyqqkSTq/Pw5FGUg0s27tohwNpWefj14F+3/Yh66+xo6QgWDEJKT2c5w4Rtu9iwfJRMY+8BnM1de2pGmDKrXNsg00LnRysbT3+GznZ4P+mh7J9S5W2nUiLrsbzlzuh8/rKgWNCley00UgIBj7rXSF9nQB0o7FuMgDB3OHF9QqWnD3Af+LaxP4BWredH6QVstt6rhIoE20kIyKzKLcH+z/xGkeLq/98wo32hdPm8wr1u1yBZFt+IRwEN0QjeKrUvtsQwmvX9jvbtXKZKMPNKySZ6ubXgkrXE0AnC6wLhOR/DpLlLVtR2E1UBjfMy/67+mHr+fTCXYaHdOXA3xb5Mt13pFrGjqdfk81aqqx2nVA2/c1m01KSl9uxXcZniRT1FTgGbHSbpkmK/4LEThfYFcQKIOINbbu7C1rgTmwGq708dUMvvgv0Ijm42WIEcRlLUhTrz7sNG5DQaNUn+ZU/3VIlpb1smHsoJdZDnQh8GhkuJuhA5UCBB2XVNls+o/KkuAouh8rGQsJBCCkikdnXnVpGTV+w2nRGUK/2DUf4fixRL366cFlQKd7jfFHeWCWggvgfRkbxEgc8IXVeOsbrahoKevdY5MK70dOS71ZbFWQhnqaPi0a00+ZgJRj+QY2c/KqUfIorli+jmxFsH/LC2CTi0XR0qFNJwASSQ3G9W7WH+fWNcYq+9AkmbXH7+ltf3jbiqm/JbpP6KOliIr46uHBGTPEFnoTdApShLQvbQ9QzV9OqmJOHoP2vPgoa
 EgYtul9l
 PidfFwn5pA2V1EbW8zCQSpqvN7ExXGNMn3q/4NKVKFJfbL1ALPKtomxiS1ooMQRRy7LQCQ2LvXaDHwLEzpEgS+f2ZBvj3+u6PdnlE+rHxr8H0lyoCT1zzy7PPQdCjJoIiHcdd1iWS7OzOYo2p2DC/T2RCdPc8upHJP2xaTYLWmvZ+agJZl8Rsbq+0HCI5FRYydIq8Bbub4b1hay+U0XM2nfg7++w74mZC+gqdpAfyNkuYTlv6enayCaWqOdd/uddf/i/giuJk1FGlPqGH7y+ivuV03hZ81JjdD6XZA+6WXHmI4sUw55WP0w1CaS8EzXRfpnVNDla5uBK8BQhfhXEcgP8zsqolCL6MByFz7If+ZbkuQOPVYCufc0SgVyuijJIFWuFili7nKj41mYWFRI1KE5SlUODPe+85BBYJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:24=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
> the origin pages. If the second mapping fails, the first one is left
> mapped, and the callers do not roll it back. The next vmap of the
> same metadata range hits the stale PTEs again and fails with a
> WARN_ON() and -EBUSY in vmap_pages_pte_range().
>
> Undo the shadow mapping on that error path, the same way
> kmsan_ioremap_page_range() cleans up after a partial failure.
> __vunmap_range_noflush() only clears the PTEs; nothing has touched
> the shadow mapping, so no TLB flush is needed.
>
> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_page=
s_range_noflush()")
> Cc: stable@vger.kernel.org
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/kmsan/shadow.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
> index 0c88d89bf0d6..2166086d3dc3 100644
> --- a/mm/kmsan/shadow.c
> +++ b/mm/kmsan/shadow.c
> @@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long sta=
rt, unsigned long end,
>                                             o_pages, page_shift);
>         kmsan_leave_runtime();
>         if (mapped) {
> +               /* Undo the shadow mapping set up above. */
> +               kmsan_enter_runtime();
> +               __vunmap_range_noflush(shadow_start, shadow_end);

Sorry, there is a problem here. You introduce "can_resched" check to
avoid calling cond_resched() later in the series (in patch #7), but at
this point __vunmap_range_noflush() can be called with GFP flags which
do not allow blocking. Before recent Ulad's change called "kmsan:
remove hard-coded GFP_KERNEL flags" this function was called only with
GPF_KERNEL but now that's not the case. I think you can move
introduction of can_resched flag into this patch.

> +               kmsan_leave_runtime();
>                 err =3D mapped;
>                 goto ret;
>         }
> --
> 2.25.1
>

