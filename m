Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB5D1C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 21:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 525406B0088; Mon, 28 Jul 2025 17:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FD496B0089; Mon, 28 Jul 2025 17:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ED086B008A; Mon, 28 Jul 2025 17:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC1A6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:59:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 661EC160477
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:59:38 +0000 (UTC)
X-FDA: 83715040836.18.95A8E77
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5CFCC1C0009
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:59:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kowalczyk-ws.20230601.gappssmtp.com header.s=20230601 header.b="bpjIPqe/";
	spf=pass (imf21.hostedemail.com: domain of patryk@kowalczyk.ws designates 209.85.208.44 as permitted sender) smtp.mailfrom=patryk@kowalczyk.ws;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753739976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFQq9BS1AZDnONWjFjq6WhnDJjmdicQEDZuU+ciJV44=;
	b=M0L8K+qf4tH2eOVnjj8q33kWhBvo5JwOaDVA6Xv5LM9FvTWUUwQXmeH+dvAb97sEqh5lIL
	WGUv/G9NR5zX7/Ha7ocb7tF9KaOI2RktAW8eUb3i8Ei55SzXaSFT2920H2vfAw7kak9s3f
	xH7M8dmWEDfXYFXeWZcATr7giVmJkmE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kowalczyk-ws.20230601.gappssmtp.com header.s=20230601 header.b="bpjIPqe/";
	spf=pass (imf21.hostedemail.com: domain of patryk@kowalczyk.ws designates 209.85.208.44 as permitted sender) smtp.mailfrom=patryk@kowalczyk.ws;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753739976; a=rsa-sha256;
	cv=none;
	b=csKNE70VJaBa1Ccj/awNVyIjqKa//yQuJ4aSrf0rIJ1KOqhlG3nVRIcIchA8VTeJ1DG85+
	pVRQo3/GJ0ZhG6e8GUEujsZr/djoTm+paGSgChQIQniYR+cPAHICivQum/irp+8odptPBl
	pMqoszQKAPkELYpCZD9EkErFQLFcLcc=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6153a19dddfso2580408a12.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kowalczyk-ws.20230601.gappssmtp.com; s=20230601; t=1753739974; x=1754344774; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFQq9BS1AZDnONWjFjq6WhnDJjmdicQEDZuU+ciJV44=;
        b=bpjIPqe/zr+Wu6zs+sKqLl8SxBm+Z/8q82sN1p4SdYdQFmzVuVuF7UCCd19nife+IK
         T6DiMywXbhfwDT0FxElelAgF6Pa98x+Dfb0L3qogBAodc2buECAYgs7JOOgT9S7rqbkw
         poeUMh7SxfQAjLUjPtg3rMMdpcCcl44avQ+wpsvylTF/l8vwsnuy6qZqUhLNs+j3XWUb
         bJ4CTxhESNf1Xa6iLHYUnvU5pWQQ8o9mEy6wkPEqLb2E/MupRCyYpUgYf8SK86HMraZg
         cLWz638DJgybBjMZ01dPm1fTDRE5RkI/2d3xIfoldkKnBX7hrvqK1RnnQmCwUUx47Zkf
         96SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753739974; x=1754344774;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZFQq9BS1AZDnONWjFjq6WhnDJjmdicQEDZuU+ciJV44=;
        b=jojHs5LvXet+wG+ql58tu55KmxwAinRx+ApQvHHQfpLQd2YUnXYeV3N/N0vnr9KJMy
         dJ60MLWEuaxXgWl7LXZqMgvjmRnJaGS72IG7mz2VJXMvwjqje8fqmkjSqbjvMxk9sRPH
         tNxqORGyk/1g7GMwJKF15Oqof/qrejHAJ89v0zqOdM9PKdHRQl/0KHMgrJw5hTBXgk+L
         NUWIOqkb3jsOx6r+L5OiolZtdO7Zq9VV34IxUMryEPBVOiAFCzUl3/j+SaePARN13GGJ
         upF+XeoI7JHEX1gZ31/pTpeOQnJHg5Z/BcCMmAnZVaogdd9a7rogQFLtuH5MO4k1xJTb
         nvkw==
X-Forwarded-Encrypted: i=1; AJvYcCUhtxy7m2yxWDQ7nveDNLnQmaqrEOLl2kNHwaQHrangjtNAH90qLSx57FBe5gMcaFpktUIyFHmnjQ==@kvack.org
X-Gm-Message-State: AOJu0YzzlXKw5fBxsZ3gTL3leAK1K528T7P0SblRG37Sd9ZFIkTB5ANa
	e73sHWuxLuqdGLncLrdRj8tLXcsEiJhgoIN7qmmwAYfqWWo8rJTNZivd3KXO2mBIO+NPMqN57tn
	/MfGQC+gzIqdpIcvNVOjVZ93q1XY0WMfzBDCN19Pb
X-Gm-Gg: ASbGncvb8WCKiNbifLsmH1NGNIkxPZUMWBvVTosZQnZn51IuVgFBCX/yvKT+zZNpylZ
	iK3G0pfK+l2VkqQHRZrreiRv6dznQVAjez9xmfBm8wQcVGnm1HdFE4WYgrEwzUnQ6s1TCeFKBBs
	32d3Rh5hoJ7HYGZcxlB0dxzlgC7AqXKL0MI6b32yp6l8rtnurtfhmlce+5DrpzdOnE79fGJ0+W1
	YXl
X-Google-Smtp-Source: AGHT+IEceYjA6cxsSRdCMNyewOG3XPoHrKBCUR9gGBeKUYS35hxGkLKlNk7w2IS6opzkPla6j9Fi8GgCrh0dEXg1zB0=
X-Received: by 2002:a05:6402:4602:20b0:615:539b:7adc with SMTP id
 4fb4d7f45d1cf-615539b93d1mr2691395a12.27.1753739974395; Mon, 28 Jul 2025
 14:59:34 -0700 (PDT)
MIME-Version: 1.0
References: <0d734549d5ed073c80b11601da3abdd5223e1889.1753689802.git.baolin.wang@linux.alibaba.com>
 <20250728144424.208d58d5a95057ee7081ccd8@linux-foundation.org>
In-Reply-To: <20250728144424.208d58d5a95057ee7081ccd8@linux-foundation.org>
From: Patryk Kowalczyk <patryk@kowalczyk.ws>
Date: Mon, 28 Jul 2025 23:59:22 +0200
X-Gm-Features: Ac12FXwwsiS4JI_-ICJdYNU4HPVvMiegzl4Qe4w16nBmZCl8pKBLj0t9-vRLQHg
Message-ID: <CAJCW39+AS5poKu3A4Y88pH2y6CWbE0WnGZfe3kL99W3sJZjreA@mail.gmail.com>
Subject: Re: [PATCH] mm: shmem: fix the shmem large folio allocation for the
 i915 driver
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, hughd@google.com, 
	ville.syrjala@linux.intel.com, david@redhat.com, willy@infradead.org, 
	maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de, 
	airlied@gmail.com, simona@ffwll.ch, jani.nikula@linux.intel.com, 
	joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com, tursulin@ursulin.net, 
	christian.koenig@amd.com, ray.huang@amd.com, matthew.auld@intel.com, 
	matthew.brost@intel.com, dri-devel@lists.freedesktop.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="00000000000033d963063b0468cf"
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CFCC1C0009
X-Rspamd-Server: rspam06
X-Stat-Signature: jxwsxkte1wm8r36umayk3xc5zhfcdfhh
X-HE-Tag: 1753739976-693123
X-HE-Meta: U2FsdGVkX1/CN6p0l6r4Dkm6cz5RlkF0fjRXbNJAgH6W3sM2JVCQDn8On5o0Muqe1NCUZ6e9FvaglRelVusxNYFC+y1KEQBUpmyj5HG66ir+vVRn3L2BEitRsE5Lgpi9QQaU8yV7wnWNoK6LwgyhTFludiBXWUa+NIsu2zmddgYADCULBN6f2PHkRzZMJrPAxiIL3jScs/O5F6S4/aroG/1+b+Zch4j85DilNwoYRUeK2R5G3mzzvmpjsud5pAhxa1wjAjUZnxgmpIEFC+yaUBKlOsSeWxzr76+dILNGKZpuU5J9QEJqKaCcxeBoO6oiv7O0C57rWpVhl+GZaOZPfqmI1KGSRQdOWBMrYw7T5J84tAxOzHDuk9kw0ueSrmBaFDbKRyFJGUnkcfZ+7QH+fuBJuUin25kqBmhuQVsylrFYdyMjZMF9hcyHz2QaEanKTVKnN9Ah3Ld/EXbousuK529bGbyIVj7R5NBipDwGaP64KA6MHSb7iWT0lmkjbd3yWC7CHJi3Yige6ETaK8gj9M6rHE8kWQBQYxcBcwvBw+Ud8cMYxXrYMprV5RB9Fx0UeDQiSKswWYdZslP1eZ7Olc4xyVplZNwDYoRJPaQQlYIDZgFnLopP9PnzSflfhmgivLxwpDihsd08TRf7DyqXAtUBmKxIftq1LZeK19H2zHCndpXxgbB9AIp2dknspu04UPYz9bcIzUDBPWVfI4oPoqqQ5dIn9EnOcbcqfPFHaAteDqiwE3ob1n36wAu5YVOaTX8809T+m/5tv3wHqcdxSZBtbhqcDiRKPpNFmgsqlHqIC+xllMQSLMgj4HmUyoEGhK72vk4VLkLwR08G8UTmHjItP2giTNMVMVjRZkl25fyr4NwRKfDqJ9LMdF6f5gUd6+uScuw/8W5xiTdWNTaazTolQEJNIB17STikigUCjwWYGBJmAV3YZbTa5x+ItS/XN9RZCubWj5AzMG6tvsk
 P55vGezk
 6e88oP3myUeWD/fKa9rK6WrhIJTqr6DXr8YGD1tjS6O9AgL7YybJS4qKYt66XFWr4WbHvyxw6IHJ/hvzhFv5dsRtoSWU/YiQcbjyjEPknmLdD3KK0O26UIuSlm9uSWylKwrYl/zRNs056MeDbVyPKyU4qvskfEvPefQymvy40rCyNL6JJCoaqwndiDEA/mPVJFs75s0kUJ2lCEYUcrclBnVVcKcDOMYnEPWBy5nfV1acuL+wNJhKpIf0tis0CoKm9b5jODi3sriA+7FXwbtzv98/EZ/2GCN111pajkPFTM2iO8XxCdEu7+d8k9cH79ogqvFN5d8UL1C3HnYi+gh8zXOoGJuBTfpr8OtjlokhUcdcpGYf+WnYg2yN89keo+37QSyBQgiRWiks5wurbaImjKXLRu+G5b2IGQtWy6PqSzHhmh3ZlscXMO4qr6RlFjP8W3yzQAplAM0udqTJKLEvSOSpH6oI5YzF0Cj/Wpf9OtV62ZlCO9cCFY9qcKbn6wF3xVCJkVVj7SfaRQho9KmKBJfTZkdzM++oN1siASQwU4mMG70VUz61Hlk3aVD2V3PRHZkfRmWhNlYEMwcyGFrmVqVY4gi0CRlHEcZ4V+mu2ciml22zlanMZaDeGmUTE+ozA65h13LQey/5ISbG+tJyDZjzR0sdao4mQNnV1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000033d963063b0468cf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,
In my tests, the performance drop ranges from a few percent up to 13% in
Unigine Superposition
under heavy memory usage on the CPU Core Ultra 155H with the Xe 128 EU GPU.
Other users have reported performance impact up to 30% on certain workloads=
.
Please find more  in the regressions reports:
https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14645
https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845

I believe the change should be backported to all active kernel branches
after version 6.12.

best regards,
Patryk


pon., 28 lip 2025 o 23:44 Andrew Morton <akpm@linux-foundation.org>
napisa=C5=82(a):

> On Mon, 28 Jul 2025 16:03:53 +0800 Baolin Wang <
> baolin.wang@linux.alibaba.com> wrote:
>
> > After commit acd7ccb284b8 ("mm: shmem: add large folio support for
> tmpfs"),
> > we extend the 'huge=3D' option to allow any sized large folios for tmpf=
s,
> > which means tmpfs will allow getting a highest order hint based on the
> size
> > of write() and fallocate() paths, and then will try each allowable larg=
e
> order.
> >
> > However, when the i915 driver allocates shmem memory, it doesn't provid=
e
> hint
> > information about the size of the large folio to be allocated, resultin=
g
> in
> > the inability to allocate PMD-sized shmem, which in turn affects GPU
> performance.
> >
> > To fix this issue, add the 'end' information for shmem_read_folio_gfp()
> to help
> > allocate PMD-sized large folios. Additionally, use the maximum
> allocation chunk
> > (via mapping_max_folio_size()) to determine the size of the large folio=
s
> to
> > allocate in the i915 driver.
>
> What is the magnitude of the performance change?
>
> > Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> > Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> > Reported-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
>
> This isn't a regression fix, is it?  acd7ccb284b8 adds a new feature
> and we have now found a flaw in it.
>
> Still, we could bend the rules a little bit and backport this, depends
> on how significant the runtime effect is.
>

--00000000000033d963063b0468cf
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,=C2=A0</div><div>In my tests, the performance drop=
 ranges from a few percent up to 13% in Unigine Superposition</div><div>und=
er heavy memory usage on the CPU Core Ultra 155H with the Xe 128 EU GPU.=C2=
=A0</div><div>Other users have reported performance impact up to 30% on cer=
tain workloads.</div><div>Please find more=C2=A0 in the regressions reports=
:</div><div><a href=3D"https://gitlab.freedesktop.org/drm/i915/kernel/-/iss=
ues/14645">https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14645</a=
></div><div><a href=3D"https://gitlab.freedesktop.org/drm/i915/kernel/-/iss=
ues/13845">https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845</a=
><br><br></div><div>I believe the change should be backported to all active=
 kernel branches after version 6.12.</div><div><br></div><div>best regards,=
</div><div>Patryk</div><div><br></div><br><div class=3D"gmail_quote gmail_q=
uote_container"><div dir=3D"ltr" class=3D"gmail_attr">pon., 28 lip 2025 o 2=
3:44=C2=A0Andrew Morton &lt;<a href=3D"mailto:akpm@linux-foundation.org">ak=
pm@linux-foundation.org</a>&gt; napisa=C5=82(a):<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">On Mon, 28 Jul 2025 16:03:53 +0800 Baolin =
Wang &lt;<a href=3D"mailto:baolin.wang@linux.alibaba.com" target=3D"_blank"=
>baolin.wang@linux.alibaba.com</a>&gt; wrote:<br>
<br>
&gt; After commit acd7ccb284b8 (&quot;mm: shmem: add large folio support fo=
r tmpfs&quot;),<br>
&gt; we extend the &#39;huge=3D&#39; option to allow any sized large folios=
 for tmpfs,<br>
&gt; which means tmpfs will allow getting a highest order hint based on the=
 size<br>
&gt; of write() and fallocate() paths, and then will try each allowable lar=
ge order.<br>
&gt; <br>
&gt; However, when the i915 driver allocates shmem memory, it doesn&#39;t p=
rovide hint<br>
&gt; information about the size of the large folio to be allocated, resulti=
ng in<br>
&gt; the inability to allocate PMD-sized shmem, which in turn affects GPU p=
erformance.<br>
&gt; <br>
&gt; To fix this issue, add the &#39;end&#39; information for shmem_read_fo=
lio_gfp()=C2=A0 to help<br>
&gt; allocate PMD-sized large folios. Additionally, use the maximum allocat=
ion chunk<br>
&gt; (via mapping_max_folio_size()) to determine the size of the large foli=
os to<br>
&gt; allocate in the i915 driver.<br>
<br>
What is the magnitude of the performance change?<br>
<br>
&gt; Fixes: acd7ccb284b8 (&quot;mm: shmem: add large folio support for tmpf=
s&quot;)<br>
&gt; Reported-by: Patryk Kowalczyk &lt;<a href=3D"mailto:patryk@kowalczyk.w=
s" target=3D"_blank">patryk@kowalczyk.ws</a>&gt;<br>
&gt; Reported-by: Ville Syrj=C3=A4l=C3=A4 &lt;<a href=3D"mailto:ville.syrja=
la@linux.intel.com" target=3D"_blank">ville.syrjala@linux.intel.com</a>&gt;=
<br>
&gt; Tested-by: Patryk Kowalczyk &lt;<a href=3D"mailto:patryk@kowalczyk.ws"=
 target=3D"_blank">patryk@kowalczyk.ws</a>&gt;<br>
<br>
This isn&#39;t a regression fix, is it?=C2=A0 acd7ccb284b8 adds a new featu=
re<br>
and we have now found a flaw in it.<br>
<br>
Still, we could bend the rules a little bit and backport this, depends<br>
on how significant the runtime effect is.<br>
</blockquote></div></div>

--00000000000033d963063b0468cf--

