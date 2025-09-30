Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8470CCA468
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 11:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5218E0005; Tue, 30 Sep 2025 07:04:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096058E0002; Tue, 30 Sep 2025 07:04:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDEA8E0005; Tue, 30 Sep 2025 07:04:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB89C8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:04:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E1601DFB2A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:04:26 +0000 (UTC)
X-FDA: 83945632932.07.87276DD
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 93BB116000E
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:04:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IurQxxbo;
	spf=pass (imf08.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759230264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLG2shrEUT3PEsVD2MKX4WEwp+11f9/xRUTGis7fAKM=;
	b=YY5S5bnz5enj3pWWROr9wsJaS/SHGpJICI+mRImJgdpC84zA9M2BBV2NUcUNcg9kqUFbte
	tgXBMb9QacO88+3BC7Y3uGJRK37QEYhy4LjkF+9tVgaz09ifXN/vu2AehDguz6gdJucEZU
	GrR8/B2ABrGR2m58GlcTXUXwu9e9bEw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IurQxxbo;
	spf=pass (imf08.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759230264; a=rsa-sha256;
	cv=none;
	b=1nS45R96aCZyJltFLGC8taljyjr7z6fh5PcEO3UvrZ6QYGRacEHXWiW+CJ/AiNP32Zb4MB
	ua54lF+hUOGRTDR5deOMFszWSiQMz+/nY/iOTPct34+cUXUYLqCN1fnmDcFDMzS1uD0k13
	EQqvi6eek9EuDdGKymDRSR9W64DPPu0=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3fa528f127fso4545011f8f.1
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759230263; x=1759835063; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DLG2shrEUT3PEsVD2MKX4WEwp+11f9/xRUTGis7fAKM=;
        b=IurQxxbooSy0fbShINdj2JTGwLjjFPXsSTHgIOGuv7DnXya34UE2t16/2QkWYKlV0a
         dEOZW3Pwe/VAzjEj6OSg2qDtyXFes8r7ikOLZaxEG97xbWc3bTdSc3K4iCKs+0bEXzwR
         Xz+xYwdkYwyBXowT7ig1rGFHfyVVufvOkc5FHx9suOrcSKONx+pl1CJWsm0OWf7+M+3m
         cCHptMP5XKnDn2b1Z/0zvqTILL/fx3n49yZgcfizkZdJHvZXL/Ghfo5wO52dR6eKkKkK
         Usb/bJQc7UBV54zPSueGD9vyRTIhoHw7vUtYyCJBuMiHuyFRWZF3pGVW7RlZsqsP3Oxz
         dqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759230263; x=1759835063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DLG2shrEUT3PEsVD2MKX4WEwp+11f9/xRUTGis7fAKM=;
        b=aYXnhrXWA1BUnF6/fT/L/kJ7CZ/x1ntbY30LV7I0O/xkrd1Y4qdQnd52jWmO/PZIQd
         yBHg1AdTW92rR6SLV1p7YFe8Bum+MssebcWIAkp+SZGHEiBsXbqPOop0qiw+vstp08WG
         DErll8EymoaXl7aQr1HRc9dBy0v0ByoEwli6QUmwe1tVH8k7GU7Z9vQlai/47Lmx3pPb
         E+MpAbBkkvnBRdcAhTv0+AJTuxUMsGFbaTNI6vHl+55SLXQCgBM0XqsiHPd3DCV/iswI
         cHeKgwbIBxevvCJ95s8FRIEcgkf2bpB5n8cVNzpm3LUDzhxwDHa3nPUw5fRy/TZYTdos
         Mq9A==
X-Forwarded-Encrypted: i=1; AJvYcCVWOYMIgHkNgnPQG8UDyM+hLXRHZv1wpkx43pkpfHeZnVwpiGHhI7x77fTRjldBxWnktzRqqP3TLw==@kvack.org
X-Gm-Message-State: AOJu0YypwxxgeGvbf5AIT3b5eskOLkQIqPiHQ+UoGMDGg/Csom0j0pbr
	/urstEMASBH77jLCWSkTUCs65eSeYdbeke2PB2s2X2e53g1HCcu/p9n9cWuBnSBxhcy7gMK3PWc
	tuUuIAlwCo7UetKZHH+SavKl8gcXzwNQ=
X-Gm-Gg: ASbGncvSzwVAGji5uzNk1w2MuTZmSwy8I8SjscNH4jbEFeznDcEKT0ky0M2agSRB6UX
	kCXjOVpv4QFfIruvwoi2xG8fbPdwy+unJYu/1XWS0aAkI853W5zoXSbUfkxP/msM3B5uJY59Cuo
	W/u3YDm9N1JWPWWCc9J/qPB3w9j3RVCtBk6YoMnBAr0eFAxAkp9wJguh9y66rhTA5MWxcsK4FaU
	I+/nSLvLiDf6Tib3CXMXUGVl0QRQ+jX
X-Google-Smtp-Source: AGHT+IE1Is0PTQDKNr+NSF+nZuh/e1voDJCc644MliK0X/icVb+Svhcvwsj2c4aXKUHdH9O9YMauBVY1JShn7PqSgKk=
X-Received: by 2002:a5d:64e4:0:b0:3eb:ad27:9802 with SMTP id
 ffacd0b85a97d-4240f26156amr3686758f8f.2.1759230262708; Tue, 30 Sep 2025
 04:04:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250930063831.782815-1-ranxiaokai627@163.com> <aNuX9wZHjOZgJdTm@hyeyoo>
In-Reply-To: <aNuX9wZHjOZgJdTm@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 30 Sep 2025 13:04:11 +0200
X-Gm-Features: AS18NWDWMUL9dtXKS3ofmjeGZtpVuVjezBxx8spaAodkJfgXXqDAB7u70llrrXM
Message-ID: <CAADnVQKkFFxSMBi5EnsQ9-ZwcNqMrUvFM14fV8ehExSEbgY69A@mail.gmail.com>
Subject: Re: [PATCH] slab: Add allow_spin check to eliminate kmemleak warnings
To: Harry Yoo <harry.yoo@oracle.com>
Cc: ranxiaokai627@163.com, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, cl@gentwo.org, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 93BB116000E
X-Stat-Signature: zdopffn3groq4p8qdaf968fc3uhu7jrk
X-HE-Tag: 1759230264-530082
X-HE-Meta: U2FsdGVkX1+d/O+hxbDC1cb5rdlBuafevItnmcxxGwBfXH/bADqxQ7W1pXzb7lMDK0p6yslEXRD62cTQbb8OEVeCAwUzg/z3zi3xssvrNo2j+7LRpgt3jcf/GpUBmJfwE6ha95fbYR31vg21Z8CS3L2tdQ5mUTtAvsYsEtmwjcaAgnd+yYdVQQpKJMAtA2Ax0e+Ac0KLiXu2YIrX8N/1dJPDZLdw44Yp6OU94lSZvj0mTBTdgGjDueLkZZpGraw7rxyby7CjIyePAOLOtTPwVZAUAZo/g3IcPEUCpCTUGVrUb1RDaAwQacKJGRuUChxXPw0xeKknTel+3h8IIejuxRVW61g6JP1x4AIdSRn6jqq8He/a8Q0kN7Fl+myA6L0ZQpTOGZxOpacYGvAfXLUZIkX2x3wYky/+AfANzXuxDSFb43C9p+MAfRMukZrtO4Xw0w2Q8gjP421AanZbWnZKL85UJ5ORiDKkXnhtKKzAqRO/RYN6bW7edIk6CXW1vykG3jBqU1ovn3nNRA4Y9QCZZbIFo7lr/A6gI5r3AmH/n31UVvz3b9bVcII54kS/98HFTalaimQy7FzNA2ZTLp8Gb30wZ6jjgRSxU5b6EIdq4lrgBUskUvKdzjeobhcKuLR8tricrxbpdZFLaVhfCIek3Z5AZ5fPawOGjM2UyNMCMgg/hLTKjn88ZKxNKHSi3slppqiScVNkXr68CF6DPZN2j0myZj8gf1CkoN2n7enEyAUU/+Vt1xkqZmYwsQGpavSem4DmyTYmKzprMwAxQb91r9oM/pROi+qj3DWxO5Oy9cO2GL5kdgKqHF+zuttazybqq7YwZDCetNwAwfM/7dGoivRCu9ATS17Qwxq9e6surUwkp6Hw/Wh0stsOBJNGC1E8X/cx0RHYqUJPxc1HaOHSV5Xuy0cqhYb7FWWih0m+l46ykNlgSbFObxGQaT1kAnCrF4vyxATkvWP5JpaCG/q
 rkfWLgZe
 CBiiPkEKZHAfi3DHx1fE+7GHG8pKJWxQj1PkV0aeWs39E7kWKC1RPkNKZgCYZ49sQDJUsL3gMTCY7afWQwi/mF1dE8jMJGljlnsiM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 10:43=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> w=
rote:
>
> On Tue, Sep 30, 2025 at 06:38:31AM +0000, ranxiaokai627@163.com wrote:
> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> >
> > In slab_post_alloc_hook(), kmemleak check is skipped when
> > gfpflags_allow_spinning() returns false since commit 13d872ade8be
> > ("slab: Introduce kmalloc_nolock() and kfree_nolock().").
> > Therefore, unconditionally calling kmemleak_not_leak() in
> > alloc_slab_obj_exts() would trigger the following warning:
>
> Good catch.
>
> > kmemleak: Trying to color unknown object at 0xffff8881057f5000 as Grey
> > Call Trace:
> >  alloc_slab_obj_exts+0x1b5/0x370
> >  __alloc_tagging_slab_alloc_hook+0x9f/0x2d0
> >  __kmalloc_cache_noprof+0x1c4/0x5c0
> >  __set_page_owner+0x10d/0x1c0
> >  post_alloc_hook+0x84/0xf0
> >  get_page_from_freelist+0x73b/0x1380
> >  __alloc_frozen_pages_noprof+0x110/0x2c0
> >  alloc_pages_mpol+0x44/0x140
> >  alloc_slab_page+0xac/0x150
> >  allocate_slab+0x78/0x3a0
> >  ___slab_alloc+0x76b/0xed0
> >  __slab_alloc.constprop.0+0x5a/0xb0
> >
> > Add the allow_spin check in alloc_slab_obj_exts() to
> > eliminate the above warning.
> >
> > Fixes: 13d872ade8be ("slab: Introduce kmalloc_nolock() and kfree_nolock=
().")
>
> The commit hash in the tag and commit message will be adjusted after -rc1
> when picking up this patch.
>
> > Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> > ---
>
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Makes sense to me as well:
Acked-by: Alexei Starovoitov <ast@kernel.org>

