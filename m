Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D245C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 09:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 342A56B0088; Fri, 21 Aug 2026 05:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3946B00A2; Fri, 21 Aug 2026 05:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209896B00A4; Fri, 21 Aug 2026 05:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E794D6B0088
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:55:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 797E8A2E69
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:55:28 +0000 (UTC)
X-FDA: 85124819136.24.9E6F227
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8BA4240003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:55:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L8fZKjF+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787306126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BebempJ9dvkwz+WZ53hR+1ZE+ffzaH6TRYMnpDAc13M=;
	b=DTSUmAd+4fNnKoZa5VKgHr43HYJ2QfahdFq2lOqF1WDCve8j9tQ+aLRhUaiH2QEcRpfXWS
	3fQRTydce2qA7I/FM6YiH+dVV1A6kjQONJpj1e7r/io67UIaTuQsG7cV8SoJPp161QadJw
	eG9ZIrA8bO60pFU/wvCDKUI7A5JQ+Wk=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L8fZKjF+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787306126;
	b=WCd44005QdCQiD7yuo5kNz2T2vzYUlLWvc5ZnQ3/rxkCRvJ+MfxYZd/gFgO1J0AzvRxrWq
	paOI5pNCGdfsSFQsGoA0Ch09tu6nFXKuaP7gVASvLVbP1xfoUtvX0lMWKO2tz8BBZzdzb4
	iweDbsF81SsT8jCY4Fb7xz0XkF2KyXs=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4813ea321cdso1343660f8f.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:55:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787306125; cv=none;
        d=google.com; s=arc-20260327;
        b=B6KdvR/WipVlwHOw4WWnlmAAfEYaxOtI4yL9Dz06qYgDST3kue1ZfPj1OzFIMFg5m4
         u3dj3V5gxWP1Eg7/T1XvzJe+OwVQCzdLssCaXJiyP+iGkH9KcuQ5nhiXJgxf2Sbip8EM
         xfbrRo61RnM1pTnwljTT/tb0L+Xs3F17VbmxAotdbRx+Zto296K+EyC5VQMP5V5wYCsh
         95vCYMKQanDK2FbK/yB1Z8HnY51c7NIP+g+5RTuNLtZc0/kYQvSR9XTknZiV2vXt88V5
         k9tK1Z3m2HOfQe6pQ2looES+H1hzOMZfNwN/kiEpfWHRfID1fEIrVWw8x35rVI2OMKVT
         ip1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BebempJ9dvkwz+WZ53hR+1ZE+ffzaH6TRYMnpDAc13M=;
        fh=eIErd3hLSvGBd9sCvOpInCK1DzwB0VRDJdlApt0dUF0=;
        b=YowClXTt8L5HrRmg2LAjaMSpbRsplEvsSeykf32Ly2DNaRGxxObCANLuN5MeaM/74f
         /FQPYOnkLai4OCd28bRsNEBxBA6q+8Pu1UCz9U3PTYIWpknX7ACqtrV0VzdNKRuHy23O
         EQKiA2astu7crMOzv4527bz5SKoh3ZzFpL6XaIrIquE8pw6GCi+6N/Pce7shZz2+/3TE
         y78qaw7MnesdG1nbsAK3vw/auv9V6+uQkIwh5tC9RfSPqrYwr5pjbnjYylVOegbzWvuY
         kL2YnksojqnCk9H06T/KR1fg7gTPpTsE1e8THf6FasaUGFm5Gvw/GX0VWNSInSDW7A0Z
         EBXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787306125; x=1787910925; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BebempJ9dvkwz+WZ53hR+1ZE+ffzaH6TRYMnpDAc13M=;
        b=L8fZKjF+aK9ZqUmFoZADFi5AkHf4pGzC44rX4E2DhBm7DhFl5gpoOc+VCLAzykbYLq
         QFGxpkKgGJGMIgmv3hYFuTnXZnz2jpxAcZvat71iamfuNKI/rDHery6FO3MYfu+1Rdda
         YfV4uzfweQ6EQwH0PQZjnTq/zw2VsMgtO/VoKSnceGkyCWY5n96FuItbJTj/xictCh5F
         57O2Fd7QCF52DVE2OrBNOiDHB5qv8N5kkg6399o0pdGK3spXv0Ta/yPTsa9r6WXMqy4X
         qoEz+Up1OBqeXHHzgw7GQTj9RH399yBb1Nq8HFfCieMy/kfpmwc20037nf86f6CUPQqr
         pTgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787306125; x=1787910925;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BebempJ9dvkwz+WZ53hR+1ZE+ffzaH6TRYMnpDAc13M=;
        b=s+m/1LsMtZ8EJU8AGPvIOZIwMaMbFSiIpMjMXyAEnuQcVKRELHt0WRBNnUNM3UFQup
         E5PZsrjUJJJHyJjySQPTXCgAx+8lwvCUHJ5Ps/oKzUiGJ2Dh4DVBGi8T1ntJwo/ZMRF7
         OfeR3csoQeUkYChSxk3ltjNgMO1pC0VJobLx6PcISYgc/tHxgu56XCs9BqEDHg0WzMp8
         kuErzDbIg28CTxSSPljSrItRpYDojhHnnmcd6AKhohZdpcCIvRgAfbYq17xkukyQNbjo
         XGbK26f+XMTjAArqoPFFWTBblnk+jIYGi2jc5VVpzNVlMBBldFMjR+FLGhSho+M8rH6p
         /kxQ==
X-Forwarded-Encrypted: i=1; AHgh+RoV5uc9hDIdFgFGy3lMtL0V59M1U/7R5Dzq7OaNI7V69gLaEIjER2Vt4Lf7EoV7b31GFbJXMorbLA==@kvack.org
X-Gm-Message-State: AOJu0YzU2u0CGnuFPF6LEGX12H+5jxosFhG3xFovawkNnfhITX+chm8v
	7mKmXYa7hVDTu6pFIKCEJ5VA8OYLcoAqEUSfThx9yKusnKK5p2jF1nsnKHjUaT6TFmmj5Kw87/I
	YYjLSa5ThIIraJE6CP5EHLwGiTkYMAyg=
X-Gm-Gg: AR+sD11ZY2UPMHQU5YIC0er95SdXLzTjEpV9gH7OUQ+FEr4RxFKe/aNDhbezyqwUxgz
	4yVeVLmv9NOkK9i8+Kmxlqc6fH3/KfpD+xI6RcBaJfaU5xMyc4hOa+96uubtBmyq8OXljjwlUca
	bzJC0RzSY4e5Ed4QhMKBXi+66Q2eFX4SSbkIDWpQIZGyFwuwJkElNLHL+ENfrHQysnvmGIzvqbX
	wxswrTYxKquGjqHG8aoCivpW7BlcAt+THPQMr7A7r6bl+kYzpN4gp2mPo/x4PZeips9E3LHmRYR
	9M04zFRbO8/Wvli2TdvPVfX/kB1WS8r2feCDmpCu+YBtdZ3wm+dzTGHwQYr1XG2UpOSELtuWuW/
	Buw==
X-Received: by 2002:a05:600c:4688:b0:499:5f80:83ac with SMTP id
 5b1f17b1804b1-499b91ad940mr38916495e9.7.1787306124204; Fri, 21 Aug 2026
 02:55:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260529165640.820-1-ravis.opensrc@gmail.com> <20260818073546.832476-1-kunwu.chan@linux.dev>
 <CALa+Y16xODsaFZDfh7ZeP3gWbycK92gvP5N8_NFpOvW=R2BWbg@mail.gmail.com>
In-Reply-To: <CALa+Y16xODsaFZDfh7ZeP3gWbycK92gvP5N8_NFpOvW=R2BWbg@mail.gmail.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 21 Aug 2026 17:55:12 +0800
X-Gm-Features: AcwNN1XF81EEMAI-2sCN9DpjO0D8fvVc3wuFNPsACQIR2_DkOmL8KEG1jq8ABI0
Message-ID: <CAN_Opa_h2W1hRimy2YXPC4EgueCi2UNwnZ5gSYV=cr8M7yfCmA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>, sj@kernel.org, akinobu.mita@gmail.com, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: r7ck66ik59kdfgeor5b4n6io8ma37fob
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8BA4240003
X-HE-Tag: 1787306126-609743
X-HE-Meta: U2FsdGVkX1+cTp2oxwkO/TEW/I0qvcBQVZ6Rr5RjoltD3ObublL4IeFfBaEbSARplsvyf4oM1BS7fTiqrJNxzAzq7n0/ZKsxIN4IwCDanc4rdWu+K9exj6JEe8KufcwpngkxVKKb3lNB0xEQT/JpnoNNsGL3z3QZmuGh7sWmcFoaSMgaZqrDM1hsYxqRE4vJqrc8lAW1k3aV0I9iwfhngmNruDc81MKfCv6pqeNe9zUoHKBW9tFF8aZLqhuvZvisWI1QinNeJiblEIl52OaSp5hfLfdYmHFJGbRjf/ZfAjm3dj5VwFgmTKmKZpc6iLv4WFIvEjWLfjxdpdEUNWoKmd8NzWPQPI5BbL8pp88F+TOC4ziu884BhUUB5e6HXPauxDegruSOHHDQF9JSFzrXpMZdRCR+iEP2CpSwvgJ1uaqnyfXENr+MhjwWwqNWLuqryhEN3rY1dLWMawL6vM+sAV+/f3Wg+hQVTlX/a5m+941hAgC6rzv5fnEdf0pTZf721h7WhPhM7cf8J2jfoXI7DaJl8+ek3N3mWtN3RKoF3qsvIVS4NiJpFRzJ35Z+znN/Wr8gQ61Sa2EOM9p7L5u5PCCe4owH7t6cZxl3jOAuRfEvsw7xDa/g9mfeR10TJugLBgz0qKMwOwOD+cCJzSA/dID6BVCE2L+mCrM3LPLNvXYk3hyf4icoWlVjciiox6NdEY/KwTAfhS+mFChsb5VFER45H6XwMlFUNLv7yJWSxuKjeXsZi+zFqBSLWW80ZdGUkyhXMSDy2qrJmC44jGSDpI+/fB0C8BS332cSKZCLPJkXPh56Q6/v2IZwxkh+fa/S9KXh9axaVpguLItIrEQ5zbcOiszzfz0yNNheUN4FgUDoENchvvRbhG3K5nNz/yu0eWWqhxxhDCQDvLwAshOrv9tFPMX3GeCcU+Ba4IMwW8tMAh/416hZT8LlKwsUgRm5ik/FWcfGwbE8EaRIDho
 gY5yVHnc
 9xbRKmK3Y0yhCkqUytHIZ6E+A+ovS+34vFZeRd7htK084z+W5/FJODJFosdWggCxKBX0ld8VybvSXtltRI76ywptr8kAtrZFXYOQLKCQ4Z7c/YWNPLf3HuBwduMEXIK8l4i10q+HYF1Fvc4yAnDldsjzEFIx8qDLDb4Xfp1sLNMfmjdiPUbKF5vmshyLZSObiii3O5N7OLdE6YFfJpO1nAq2279c/xpIHWFCraJScM/okt6P/VYXvDc/DQyRERLBVixk31noWCEBp/Ndgz6OKQ3ccVzkO5pEGugPaKUgnqNPaPJYBea0TWsg5B2Kti0CFuIFBDPZ8ckOxdJTdbgEKI1UyeHYgrs9Z6+wPOKFVB69beDCG35gtg57Vd+vNOVKLrjdhUZulyBf9hW2Uf0AaYH/QU/MrJ8Z8QnmSF/ZcgxRAI8l4xb4jczSwJGtKy5hODig4/s78bW8wYW1CfGf5Ylt1Nu7zg4HGNpUi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ravi,

Thanks for the detailed reply.  The fan-in diagnosis makes perfect sense.

> Your series is based on the v1 substrate, and the way an event is
> configured is the part that moves most.
>
> [...]

Glad to hear v2 is on the way.  The probe-based model is actually
something I encountered while building the AUX backend. When multiple
sources can feed the same region (e.g. PTE scanning + SPE/IBS), the
question of how to combine their reports becomes interesting.

For example, CXL tiering may care about physical-address locality, while
per-process monitoring may need virtual-address attribution.  How do you
see probe weights being determined =E2=80=94 is that expected to be
scenario-specific, or is there a more general principle behind the
weighting?

> 2. The 67.9% drop rate is fan-in, not sizing
>
> ---
>
> [...]

I completely missed this.  The observability framework showed the
symptom (67.9% drop) but got the root cause wrong =E2=80=94 it's not a ring
sizing issue, it's a fan-in problem.  With a single kdamond thread
draining the per-CPU sources, the samples effectively get funneled
into a single ring, which explains the numbers.

The per-CPU drain approach using `system_percpu_wq` and `queue_work_on()`
looks like the right fix.  Our AUX backend already carries a CPU argument
through the ops, so adapting it should be straightforward.  I'll take a
look at your v2 branch and re-test with the per-CPU drain.

Two questions:
1. Is `damon/perf-rfc-v2-08-20-26` ready for me to rebase the
   AUX backend and observability framework on top of it?  I'd like to
   validate the per-CPU drain fix with real SPE hardware.

2. For the probe-based configuration, does the `prep_action =3D "perf_event=
"`
   model preserve the same event lifecycle?  Our AUX path needs to create
   and bind the event during apply, keep it disabled initially, and enable
   it when kdamond starts.

Thanks,
KunWu

