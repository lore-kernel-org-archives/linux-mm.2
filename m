Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31346C61DFD
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BA156B00DE; Mon, 31 Aug 2026 23:19:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3918B6B00DF; Mon, 31 Aug 2026 23:19:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7CC6B00E0; Mon, 31 Aug 2026 23:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00AF76B00DE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:19:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82B148022E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:19:53 +0000 (UTC)
X-FDA: 85163739066.01.D2FAF5F
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A28C100006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:19:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NLbPhNAJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uxfDC7P3hjzDwZfMMU4ZVm/zbG7/WqTWINl4wOrB0SA=;
	b=kPceTTyj5v9N3syNLEr5MU0+UFexu1fRJFdq7eoYsGbhybk9qdqw8UONqVlpwgrVC6RUwI
	VCVqJ9soPP4q64V9+0MlIricdyvxvAn1kpgeEINUs0Vj6wa72etQeEZRVFPUj9Z3Rkiz3J
	CImujCaaJxIFI2N/GBo6t0a2MXCEV08=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NLbPhNAJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788232791;
	b=n9FYkHIXnmjxrg2Zp2wAncEQvB6x2CyPpcz80Iev8g3I/meAl6W9p3bd1VBiIC567zIZf8
	JNN4gUemM2boC9wuYAtiTVOwlGtffTKNIJlfD79Y8kDgCanSPhUidKj9bhmLbLPgjHo/K4
	ysrwjvRskFPMXTGS7G235lNk7yv71tg=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-66e63c2c9e1so692704d50.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:19:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788232791; cv=none;
        d=google.com; s=arc-20260327;
        b=gUvKG6Nxdd+Up6miK/dcMEor1OWFEjICDqOILkvWmo/KSxt0vlSNyJxrq6uayCxo8v
         GIdmouj+NTdHMhHvOhx71XGvzWdhH70LUp9YzZ7KJLpI7pP61Tf3yJhJxBR+QSHKEe/P
         2tc+wA+7xTErTj3hQUNrSturNhIZh91f2crCPbUvhvfCL1F6etMk6ZsbTzYeaD7CYxVr
         HKyms6sY8R/HGA027fYiG0XESc6CY8E0pKGn8dozrhfkawI5hoT2pRQzgxlMgqJsJ5Jb
         ZeOIMyjsMRv+ES02517/VCllfv12CYHa6fOxZihG93IU50jv3PosWYsSZb1KekEDqjmO
         TgLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uxfDC7P3hjzDwZfMMU4ZVm/zbG7/WqTWINl4wOrB0SA=;
        fh=yhIP58BW5kMAXd+iiXpXTg7t1Si+ItEd8DrpeOGbyzA=;
        b=oNnSbPU2LQxNoVQHb2GOjNseDQeCImmB6wfJkY92LX1Sph7z4l2a4JW3Oz9Xe7Ed01
         OL9DhgJNb7ZFs+p7SmVIexYhE9+1dV9/euj68ER/bTskZMkCF/MHzMbTDk7lNASfrUPk
         N97oUrvJoDwfu6hhIIn7TFkKC2L0rJfG6MayEMgiZ9NJeikthgxp0+NSK3FZxqN6AY9E
         7mI1aHUWzlgEreOE4G/FBIAAREeGvutQZ1xCOCYL0lwebvwEk4BmtfviRGJOchI2WWlO
         Wh1hRzGM/cDUTbhX4xlWMEkAY2aIycUlBfoBw8XWtZSQQJjQDnJzb7nKIGSd8eiltdzv
         Kd2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788232791; x=1788837591; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uxfDC7P3hjzDwZfMMU4ZVm/zbG7/WqTWINl4wOrB0SA=;
        b=NLbPhNAJbVDzjEfnltvfFsSZZ2o6q6AcZT7nqKQ3/eDyugIaifoxTl1aQ/Rksx4CNh
         +wPcS0NigZHFxsKnRRciPMKLFnhdidlO2Ax3atmrarnq/QS/6GZrQbUbGCMhUwdYGm58
         OWBEoJXfIZu9utsYIWd0njVTKJ4sFOeQPBH1KfeQvH0ThkpoWKCx7B2e+3bVKNj75Wpn
         kI9E41elA0VIDfMx3uw572hAY3gq7h3tGbQSGfxBCZahOIFgJqxNGYaNoAZGuWgiIVKq
         +D0RYrOJc5u5V1mUsMH0ZDwy9wIBDB0asW7rqI/mfGyKQbxzTiAbFt9npGLdDGqbXVhc
         oCag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788232791; x=1788837591;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uxfDC7P3hjzDwZfMMU4ZVm/zbG7/WqTWINl4wOrB0SA=;
        b=fNnsI5KjSGaAv6Ys47tyVJZa4/ccZqdLblBvk6ByMOXJ9oHmalo6tomv7TvIIu34zA
         Begg6KLKLHFXppFPuKKhMpHUIRl+o0XHggT6PG1OPsMegq2zOzankvHiAPOLV8rZCACz
         nJXMxzKJY2cyi1+MVdZwnPdHEkLK2QCViBG2ul6VaATtD1usTJhlpcE6LtrTd1XGheAO
         Y/DCHmZDtPWKQobId+vT0PRh6WXc1v7JOtK/XugmDBlKKJ5WWvCIbLcTd+8mr3dpNoy8
         VWspd+W/pvMxusnYmq0Yvdpfca4nNeL2VMxAJzJici7Zm6kWKcM9bbGgL5JoMXW3CtGs
         hX8g==
X-Forwarded-Encrypted: i=1; AKwUvBwsIqva1Dn6PLHzv6HxbbAEF4VKA5jTB8ib1W7JDvTt+qnKmMWnOlPAnoTDwGKw7H1E4z9/7hFW2g==@kvack.org
X-Gm-Message-State: AFuF++nONc2rVEfgJseaB28H8xG03557JJjm/SVrv6cTOlGC1dJAm4H4
	V+fU65e5QpjgmAFlK2nkV6CKkx4xmivEGZMuZ9EV5XUB3hIsk6JI/wrs6RYGmXM3O5y6YOwbxn1
	pG1h/ZJL2WsosPB4ff0H646ET2zP8qAs=
X-Gm-Gg: AYBFou32GEZvGpRsfPFJle/5y6hTaecYeeLNHQ3Tr8Dnvq5hP31fuYkLSLzZ1mvbbPR
	lIpm8myXcywl2M3Fsq/RhhKIOkyuLQL3+4r/OwZmsnJlEBvTZvqJxT7tn8CLPRThSab0Rwz1pwk
	PZYPettkIkA5QCeTUS1oN16Lnr719AQnm+lEHYonMu124mq1cEjwcLk/SNTqBfuoU88uJjLS7qH
	Zi2hv4lRNIwL5Syjxgsik9LCOSr1exANQsXSO79iAa9XgJUzXxdJ7Y1spIQLoNivcjgQuuHuRm8
	F0C0hrEhnRszX1CbQX2zkzQqb3QCjGG4JHube4sIs233bMwy509/okC78vI37T1eW/7Xk0uFgQn
	Rg9J6DZ1nGNmR9yZTbIr3+Qt0E+pwZMYG1A==
X-Received: by 2002:a05:690e:419c:b0:668:43b7:acd with SMTP id
 956f58d0204a3-66f8a41a3c0mr853872d50.8.1788232790590; Mon, 31 Aug 2026
 20:19:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260831092305.42062-1-tasos.papagiannnis@gmail.com> <20260831092305.42062-4-tasos.papagiannnis@gmail.com>
In-Reply-To: <20260831092305.42062-4-tasos.papagiannnis@gmail.com>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Tue, 1 Sep 2026 11:19:45 +0800
X-Gm-Features: AcwNN1UzotP2OBEays5eiLg4A4d5qM5oPgXZ3iL75O9H0DWfs8MThC678FLuhRo
Message-ID: <CABFUUZFToRDtvewhqHOWjE1h+7o-cmb1D-z3Pe4oXTVXzt6Z_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/7] exec: Clear bprm->mm before dropping its reference
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, 
	kpsingh@kernel.org, matt@bobrowski.net, song@kernel.org, 
	utilityemal77@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5t8qjhf9ydwfdpbp5wm8ax46gr8dyqbs
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9A28C100006
X-Rspam-User: 
X-HE-Tag: 1788232791-196196
X-HE-Meta: U2FsdGVkX19OkUN/DibpCo+FeL706JmoVvar8I7qKJMxvcfOhi3p1spJoFmvQQjlXLhKOkuv2/oy1MZn0MN4EcNqkR2DtVv5YIB09AmriePmt9sN1y9Q+vVGV8n8GCHtkjOb/mx40IT2tkvgJg9hQt0YUKH+LEX92adOwQZEwuKANpgybL+8yFQhQ8OGNucnkqzj4hClDdXKZ9X0Ggdn3nRZ5rhL6QX+QpyZ5b9yZnLFxETMiLVKw1Nrm6BWDBb0/E9/g2+AtD4ouStbvFOEgBV4XkXc6TLcjMtIUR1g+tCF9XJgVBgl9y7XSl2goiH+4uBPg7AIMCkr/kMf+L1wGbGSAFK7UWWi5iGCjeb82Bd754ubQxXj69pm30NBlRKXQ5r8vInqKeSXmy+/K5aKPomEtAmAR9S0UPdg/8cQSR3ZB0hEQdSaUxDECGdj1R2RHl7S/sJOHRRLwrElZijTov8ucfG/u5eWnsgW0hTqBFSA5iuWOp2bXP0zwqkmhkvniFdCW+LCoyHAmLdkJyDDDbDsiaulpLA8nffOHfgcYMra7S94Dc9niE3QYVEAJjJ5BI1DJLU0g1IIi0Hmr12MBkGL36QwykHdZWuMssqfD5HAN9xnoN8GMQPhkXNbmD0kpIBltINH6lvT1m012wrvUM9UV8P+KTIMj8v84PCpCZQTZ964qlpemh3/+XwVZ+VuCRWCjpiqjHGvd4KuGV0xjW7uWZbISFteum/WUfDb2OhNfkFyWydYqtOiczHWoKC2DfRdOTw7BDBgLTbKM3q2LApGJCMzTfJyDMoV0lm2ZH406fyHr6i4tM9qe7OHIjL55GJlygjmSCuEslETP/LtCcl7p+49bmQMh56W9XwnvaHmnTZO09dSldkPni17PZacHnJQvKZhAolh9FfShT/Gy3DO3YtXbW9dUbAs3WGtk2//Y5GI05Y3EAvFvgsgmIQf9hNgoCJmxzJWCMx2N1S
 /P5hT3jV
 ci09o2eqU6BR+/Bn1CnZNABvdKRgo+zB4BcxX8W5UKSVnWI9RgtyeUGdnMoJzTD2S5mH8v8P7U2uSxMQIZ8R29uO7nLZD6SHZXV5plF87G9265fpR1j7QdKrXY63QReqB7k6JlObq9sWHcZ71oVPsoKWFUcbqdQIy80Yb88XBAhIrwU4qmapvJ5DAQkyfcimrEPMNFkF/5o4BJENfmm8JMoQIOFmYCNR+6N1JXg5dq6YAPpaOPYzGyA2KqnjoyCxaOn8DADRsiF+jh6vaqTTYgzaP6hABVvg9Zu9HV3i5buJtwKaCqbIJK3ZUVinyEu4PUzyl1y5o5edfHwi67KDc18M6gMmDKtFVDtRuxo1AINytGHtvmPPhN+x1zYS4PA9uXPiaZ+M6ROkKuhM4whAYBFbDgJssqun3VFoerGeaZ6MqgqBXLAkh12Jf+yMRcRZHuRwO7RakXWtTQmoaOxHTksv4/+WziJhTzfnHnP4tu8+dekCdOCHT1B3oJC30M9syZURMUqeJ6XWV7fRw/kDi9NDSxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 5:52=E2=80=AFPM Anastasios Papagiannis
<tasos.papagiannnis@gmail.com> wrote:
>
> Once mmput() drops the final reference to bprm->mm, the pointer must no
> longer remain accessible through struct linux_binprm.
>
> The successful exec path and the bprm initialization error path already
> clear bprm->mm when ownership is transferred or released. Do the same in
> free_bprm() before calling mmput().
>
> This is required for eBPF kfuncs where bprm->mm is either NULL or points
> to a live mm_struct to ensure safe access.
>
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> ---
>  fs/exec.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index a14f28b15607..4b4d8f0627a7 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1453,9 +1453,12 @@ void bprm_drop_loader(struct linux_binprm *bprm)
>
>  static void free_bprm(struct linux_binprm *bprm)
>  {
> -       if (bprm->mm) {
> +       struct mm_struct *mm =3D bprm->mm;
> +
> +       if (mm) {
>                 acct_arg_size(bprm, 0);
> -               mmput(bprm->mm);
> +               bprm->mm =3D NULL;
> +               mmput(mm);
>         }
>         if (bprm->user_ns)
>                 put_user_ns(bprm->user_ns);
> --
> 2.55.0
>
>
Reviewed-by: Sun Jian <sun.jian.kdev@gmail.com>

