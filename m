Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9433DC61CE3
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980DC6B0099; Mon, 24 Aug 2026 12:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9321D6B009B; Mon, 24 Aug 2026 12:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 820806B009D; Mon, 24 Aug 2026 12:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 578696B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:46:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B55051601DA
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:46:35 +0000 (UTC)
X-FDA: 85136741550.15.DD614F6
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id C82B4A0009
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:46:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ginPKNQ1;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787589993;
	b=P/6ndlu3eS/CsLzg4esstVoaNA3c9/q1wxKzt5MdAxDSrQsL/JODG89xdIysRfov50Pk2u
	OwL2EFUl9GPl3mwqMLBp8ycPVjPvjQwBqZo5G2W1JEUzsM/Oqkz6IL6v2CezF79zikklzI
	FeIhUGMjvjq1BcbeV1TKLwr+n9Wbop4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ginPKNQ1;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787589993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aBhTc82nB66e/4NpNewHf6JJYCPf4dCSCUGVU1FeI6w=;
	b=32qf36w8n0cszkgzb9a1ppW0VBYoRhgjlrRiCQuJtAehiMB5T70p2ujFIXoHfeb2ZjLzkY
	p5KITuVOjTC9gp8FDwQbF52OR34hRSa4TS83FLxfEra702kOKgF+5OXmS4sWWu6yIbYNer
	vnkMJc2jtlANOOB2h6NsW7b9SkHVAZo=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c01c79467so593531cf.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:46:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787589993; cv=none;
        d=google.com; s=arc-20260327;
        b=OIofUiJ3bY8i+AFV3NR02QYW+7FdJy5qybKEoN2lGZ05/G4E4qFIH4KDmzeia4LX8A
         RShzXQA+GRFdDKvvjOeqhWkDjRptPaXetCCuxOduHmy9UZnPMGP9xfypN8sFaon6VX7j
         t61gDv79WzIhP2NTg9Gadgmds1KTAp0lwxtqGueY0g/+0yRITFWhNi2oSSg1gEyGEesR
         XgxtyZh9LYAMwlJwJNuanQr7RXusGwSvSzkMT1SYuuXF3IVnX2mI1XWANi9vEFPsEDOb
         aD294cjHTef+w0IREIH9xIwMZwbRRFXb6WOjkWLKsKSH3nBC8w+LtH5Qn9j3Yo/80yDt
         BkSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aBhTc82nB66e/4NpNewHf6JJYCPf4dCSCUGVU1FeI6w=;
        fh=/gZYPMrvxkfcXhxEZFy7U82zxs/0nReE7F7DeltSuX0=;
        b=BW+wV+VpFsBXxzTvmfAxllUgTCmwZ0eieU+2eOoEuhUxdwIJ3R6linfSfQeNh8GJwe
         zuZ9IHvOm1t7lJ2WYGjYi/osCJfzqy51kDLylsvXF+jn0pauIILCO+n30R4g5tK50iM0
         rFZ/F+sW/3jgaYOfLztQwRtxfdvLRvOqmwq/w24xU1B9OD9jSPGhbPagyfccj+WfIiDT
         iBqE+t/rFWocnFGpz63Ddli9+lPGbzY7QDkPiu22NcwcXW32nch3AQ6kTsY/VRX3bpPG
         i4CpPlNqIOgVxxLFIjccGEXOXUEk1nDo+nxMPGHnsGQJ2G0Xa9PtAFS/apGQDT/CNEbz
         kVhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787589993; x=1788194793; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aBhTc82nB66e/4NpNewHf6JJYCPf4dCSCUGVU1FeI6w=;
        b=ginPKNQ1Qo+QjlfLnAICsCY97rgNBLzu+7CHs/hDu3hfhW5EyOZredbw/mSGEdjUWH
         gU+ENWuVlkoNq4xWRYZyA8xW3hHraapUZw8/GLcmXPhD5VfPVhwPW7bsB1iBOTCeYt42
         RyY/mOwvmWlrQmXZPaEgyT6JfHzgei6HHAJmPNeAaZW6eXGiCSWyR5dVAdBMQrSRTapP
         sWsj6URIQ4unRjyvXat/UQUOum9nEWRQybE3RSZ8c58XZslaXRwvmKkawEcZql9AnXyx
         2fhMJ8DbwgRZg6R5/6uZBo9gRiU9e3Xhw0fUEUdmIN+gZmhnmpSIfdDNB3J9LmdpRdUZ
         9uZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787589993; x=1788194793;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aBhTc82nB66e/4NpNewHf6JJYCPf4dCSCUGVU1FeI6w=;
        b=YXqDT2UhqRJPXnwzZmrIpvMUiWAJdcZVUTptOiV0SXeWq7t0anR1TZInNVozAvMmLe
         YXpkc8CjEC5vzbGRhlwWmbHMfBBCiIpi7Sb5u+hLfNO/aae8H6tTY32WE7yfkC534WZp
         QEoBUE5peqF3T18Nmm6LdIBYE+lEN+VATDXmMq1kdwHyucc668UfLGdItuYpsHA8qmzG
         JcR0dWaZiw8yiLcrnAXiay6N/fbjK4eBbjzB7OvBuxVcxPD+Kncc047KIm4jjmDBwPFB
         KL5no5jEtmFUyJGBhhl48/SIHZo/fA6CeIKcPe0zWVwcDFUIPy0B+jJXHZNa8pqUvnwR
         YFHg==
X-Forwarded-Encrypted: i=1; AHgh+RoDh55n38g/SGKIaqloymJYuVOWwDxMGY8VVSeHKJU49fCiqmwMw70Y7HR7LtNqRYcCI//ee8WLiw==@kvack.org
X-Gm-Message-State: AFuF++kQw9+48FCFeFGpmd8/Ab1gDIKS6pLpMA7tV+AQRmM8QxBGwlXU
	OxyPgU4An/U1Dn3yO1UpsjAN6zLcZvPuh3lanv/IephT7j94t5NcZJ6h1TZGUeKCOoO5H0vjsNZ
	NlKqLLWi25RM5mbOTcu7Kjf9fOljTCh7AxN+8cn3L
X-Gm-Gg: AR+sD13ZgUhi0n/Nl3knLwdY75VuVfJpXgKrnbLzjRQWDnmfiAv846fXq3LkO4JuuC3
	M8rd/mFyfdtg+OGsftqcurdQaQ2mNZzioFSylIYJznRiWC8PCYc3RN4HQTuN/df5+5D1v357sf7
	ayc1ln79x3R0auZGPWiYAA1Qzm6fPADSJ3ckmddL0hJgDpdgz1VG4wmzppd8INiW+0b4EG2WbSJ
	KTzHnRfBpAvJI9Tg9/2I/gv6Wmnef+FfUryPdOEDAEmHPxImZXC8CjiCJi3TSYXMIDZXNOBdZfQ
	d4hJFfrIlN89kWeLKJZyD9Cdu32UExBTxUgOvKXPYDY=
X-Received: by 2002:ac8:7fcb:0:b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-52e0a7e35c9mr33329621cf.7.1787589992298; Mon, 24 Aug 2026
 09:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260817062726.106511-1-hao.ge@linux.dev> <20260817062726.106511-3-hao.ge@linux.dev>
In-Reply-To: <20260817062726.106511-3-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 24 Aug 2026 09:46:21 -0700
X-Gm-Features: AcwNN1VCYimyRCvoNVNxz7vlNo-ZiPjIZDP5jBXv4SzlMbFF259OhbReYGQYLZM
Message-ID: <CAJuCfpGRh4ZNR1fRQ+d7f87W8xO5SCTmABmxt6w3Jz2bEu2fXA@mail.gmail.com>
Subject: Re: [PATCH 2/2] alloc_tag: remove /proc/allocinfo outside of mod_lock
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C82B4A0009
X-Rspam-User: 
X-Stat-Signature: 9szc9n4rki9gc5ft9qdzcgyihex3g97u
X-Rspamd-Server: rspam06
X-HE-Tag: 1787589993-843124
X-HE-Meta: U2FsdGVkX18WWc0p5QZh4HIgFprynWjteBOqjXMjqW4sBvQQZCLNdtMVbhpJZNC1wBznSRxsobwGiD+gSvRhp9EdxC/5hQPFgsKwxd5dxPpKWD82hVFjjlh24xemB4a9U866xxwn4MMDs+djVzeoojWpCPHKMYai5DLwrHQguJ7FvIA9xV2yxWOP74/Ws9vvBkmBHssC71kiehcuOgNKB1joUtboUAERUrdMluWaCeJ78GeY9TnObooaMvES8FZk8y87fEfTbGXkcDODesnSy2YJtud+J8hAPIGiyG+WjnoIEh+h8N3wIpXqvqFCF3Ks6YX6Z66mxGs9A7npycBPC02Nlt3ubse41a+Xh4aH7W3EXipuutvdzo02AeJJf7bZjrk3wjU9serIHNGhgnyTTiHGzbXEuCKQSscjIt2A0hLKekjRQj7rx4C774bQmh0KQMpNhtxGvg36HzNniMLRy/mgMBiE1nEEuhYANnkrdhAKRWk50yEd08FTkMGgp7wuEM63fOoTExxxlO2bnTaBYlSFiw76EizE2n8Xv4zpDf5HrKl8WpRCsTGEDr+fYxK9SaXEfHCPPY9/amkNn5n8mkl9ngtQQ4hcY0rfmBWEtF8p56RACneqtgQBQn3iAgkduqHWr1MdDpRTdUozjPl01Le4bQiHE2UN+79z1ZBXGdCn72EyY6dOAAbYrCFylGyldC+7Ob3aBQQtGiJTJa9ha4WrNHGpbrU9WeitRx44116S48PxtpnPLTsGFOiYKw8WBu/Fuugiurf6h31is3c2fg2EsWw5gwGZjy1VQ2gexXlxi7iXLRpBm9gaGrq0AGuDhkcT+pD/JLSm8qJHdLVup1XxhW85X7AakE5EIodmRV3rqqW0O/yUd1PL4ldw14eXMAqqZXdOj4wTN/4q3SktAKuvH0Vm8U42ub3yWZmf13LxWBfkn9bblVVEe1b6l+LTkpNjGiVTIbyQLgoJsKg
 bSO7kKyT
 O0pBpIKx8YK45HvM5aEy15NZUlfZGxPfEC91Mp4zGCvf3gEIJja3YAQR7Ama1t6yB0c4a1trIfn2k6U5G0oZRUdPkSM5BkW/McYhOYvhVNWdkZfwvyVMD1EhfvnHPjhuVDSQLRntiLUcietfA9TDmbGoOaPIllOeqhV7jJsK3xt+t/hZFJGCMjNwOdkrlERd1l6z7yseVoZ6UAAvhRTfxXgPiwP9E2sHCrtgCgl1pPyB+hiG9BWkM/f3oLe+4VO491EWq8lpdG6bR8e/xCE5HRtU0BLLX80JVQeh8Xrowh6E0/xkkSy+JRpZMbkCkxCrWwhQSaseec9OCXzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 11:27=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> shutdown_mem_profiling() calls remove_proc_entry() from
> reserve_module_tags(), which runs under mod_lock held for write.
> remove_proc_entry() waits for readers, and a reader takes mod_lock for
> read in allocinfo_start():
>
>   CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
>   ----------------                   ----------------------------
>   reserve_module_tags()
>     down_write(&mod_lock)  [held]
>                                      use_pde()            [in_use++]
>                                      allocinfo_start()
>                                        down_read(&mod_lock)  <- blocks
>     shutdown_mem_profiling()
>       remove_proc_entry()
>         wait for in_use =3D=3D 0         <- blocks
>
> Move remove_proc_entry() to a workqueue.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/alloc_tag.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 80eccaca665a..b1d48532a25a 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -15,6 +15,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/string_choices.h>
>  #include <linux/vmalloc.h>
> +#include <linux/workqueue.h>
>  #include <linux/kmemleak.h>
>  #include <uapi/linux/alloc_tag.h>
>
> @@ -591,6 +592,13 @@ void pgalloc_tag_swap(struct folio *new, struct foli=
o *old)
>         put_page_tag_ref(handle_new);
>  }
>
> +static void remove_allocinfo_file(struct work_struct *work)
> +{
> +       remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +}
> +
> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
> +
>  static void shutdown_mem_profiling(bool remove_file)
>  {
>         if (mem_alloc_profiling_enabled())
> @@ -600,7 +608,7 @@ static void shutdown_mem_profiling(bool remove_file)
>                 return;
>
>         if (remove_file)
> -               remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +               schedule_work(&remove_allocinfo_work);
>         mem_profiling_support =3D false;
>  }
>
> --
> 2.25.1
>

