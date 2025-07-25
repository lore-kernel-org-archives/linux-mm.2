Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A58C83F26
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 08:36:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1F86B0089; Fri, 25 Jul 2025 04:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF156B008A; Fri, 25 Jul 2025 04:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DFCD6B008C; Fri, 25 Jul 2025 04:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1536B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:36:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2C2F1DB9A9
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:36:15 +0000 (UTC)
X-FDA: 83702129910.03.EA9E81B
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id D0F67100009
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 08:36:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kowalczyk-ws.20230601.gappssmtp.com header.s=20230601 header.b=IvbLXxSZ;
	spf=pass (imf14.hostedemail.com: domain of patryk@kowalczyk.ws designates 209.85.218.42 as permitted sender) smtp.mailfrom=patryk@kowalczyk.ws;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753432574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ys9sr9GADZ+/d8kZ/xwzdxAR3Im3uGxlJ75ufMR9KVM=;
	b=XsM/0FfAh1GWrWRwFH59T7TCz5w2sL4xfHhh0QSko0LZJ24mZ04NcwhiC/wlLsXGV0YyFH
	EsiMSGSZw2EeehibKuHNXYmmEEvWv5JJ+J/pr0qiKxh5+Gvu9pvdHjk7y45rlxcQ/KMKIz
	qUGSHtIUVOF52KKi9ouVzbWUNxr9+Ck=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753432574; a=rsa-sha256;
	cv=none;
	b=23dFFu13stO6FaPkmi7YEH6eQ03c/VlPOhbkPU7WL+/G9vOu6T0bCvtj2rV75pI1AXlpH+
	sMNcz72Pd07JkX/hKopYSP4i0XQNeRqmb6aVCLkE2BMsjix0PUsQL1lyufafxHGy6Lz+nM
	hlPFSJTisEGp4FnsxuF/7i7xU4B9RBA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kowalczyk-ws.20230601.gappssmtp.com header.s=20230601 header.b=IvbLXxSZ;
	spf=pass (imf14.hostedemail.com: domain of patryk@kowalczyk.ws designates 209.85.218.42 as permitted sender) smtp.mailfrom=patryk@kowalczyk.ws;
	dmarc=none
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ae0c571f137so391762366b.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 01:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kowalczyk-ws.20230601.gappssmtp.com; s=20230601; t=1753432572; x=1754037372; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ys9sr9GADZ+/d8kZ/xwzdxAR3Im3uGxlJ75ufMR9KVM=;
        b=IvbLXxSZ2C3i4WdM8qC8HKamTku5+FnWnPKlDJYCXdEAPNbR+yqBPGnKPMy6iUycuB
         8L/FgtbDw5e3d1BnwrddosLN5nE15tyzBCFNNrMOF7bfB+IrTKo3/jtbPqv+j85hhaD2
         s3wNrCOK7cbkazrxs1LRm6mtNy89bzaa9I1Y2jmIcJK6XQCAkTLpGXINyG2/4txJR59F
         jXViguyIvpIAAooMSV7X98A+baNFe0r4+k4L4BEFwtp+xA7owD2uQbm5YdOC13/NqgJE
         bEVB4rfSQ+f4tsQKbvP+oGtpCBJGw2E0gyxSu6DxqyAW7AEMpqaUe3pOHx0lAU2cN/7b
         yfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753432572; x=1754037372;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ys9sr9GADZ+/d8kZ/xwzdxAR3Im3uGxlJ75ufMR9KVM=;
        b=klUKXdgiwC8HPxuO/ApqGeWPcewIuJA0KcRs2s1d2u1ivq1scdGaRTPUdDWl6k8ZTA
         qrPXP9LmR2Kr4DMGpIE/OaGPdIP41qlZzSrLTvM3TUKjQvwOfehge/GPhVAK/pba1kIT
         78nXQ/pL9KZfpXVwNFj4zNFjzgYGjbjfKALth7LrywAeKwkTWMixdq01iDcPWauhDZaY
         eTtd3cdsoK7HcC4wTPaQagqjlf/YvSNxCLLItxMDRENLUKPhabtriGRz5kzut+BtRqQ/
         QXsLAisjkHT35kCQCBNM7trGRrc8OoVsIKhO5wWFqaFSFRHYPO9A/h4uq2gb0ntiax8I
         Kn5w==
X-Forwarded-Encrypted: i=1; AJvYcCUlvZPDg8vm/Ro3Juki0RktM/LUrjZWOmDhEg4XIR7H09mmrvlp/etNrMnEMoU+lMLFPzM3vNFJTg==@kvack.org
X-Gm-Message-State: AOJu0YxwHd9YveZMHxao36Kn8eZk8rM1Zzozr7hwUUdRIeFIAPL+3/nP
	HicvxS6ldkJMecmU7yNv9z9k7Na+ndjSv3Tf2ZvMVa8YViVU7/hNnUOUFAsljpxAkpUF6frlc1e
	Cmod3S5mXWiA2ne0+wdZoQZ48IQIVCKlaosAMYYbV
X-Gm-Gg: ASbGncuNovlBbFjgZatobxfdUN8K7q/MA2d7eAdXD1ZDDJ82I+zgsSemsbJkwzJHI4G
	PMkis9YPtv6kV/iCNQqSWeKIeOPm5J66gogQcAhq+OdUEtIz91mIs9NY/0EmQafbd8V3XEOokGP
	gA1wiheX3yW0X2dAOxm1wfyUmVMlOpLvrY9mrCR0Ko6XF6xtYXHYLfTenhPwMGNzt1GIKRTkBRK
	nBm
X-Google-Smtp-Source: AGHT+IFjZQuvzKeBvlB/9uZViervlLT3ZTJPzyA4uOAljciqK9zBJ1oNC2nFgYjzMrFfCeyV7tk6+d8rpqbKIiSeboc=
X-Received: by 2002:a17:907:9287:b0:ae9:bf58:4190 with SMTP id
 a640c23a62f3a-af616efc1ddmr152152566b.4.1753432571821; Fri, 25 Jul 2025
 01:36:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAJCW39JCDX6_S2Ojt1HMmX-h_qAKm2eBRzxX5kOHNJz60Zu=vw@mail.gmail.com>
 <d5c6ac93-1af0-4093-afea-94a29a387903@redhat.com> <63b69425-2fd1-2c77-06d6-e7ea25c92f34@google.com>
 <3f204974-26c8-4d5f-b7ae-4052cbfdf4ac@redhat.com> <a8ac7ec3-4cb3-4dd8-8d02-ede6905f322e@linux.alibaba.com>
 <da2ab844-98c9-4eb2-82ac-01d01bec30f3@linux.alibaba.com> <dab283bf-a9cf-30be-02ed-da0d7c8ffcf0@google.com>
 <0c9dc2fa-34c9-4db5-bea3-af4caf05ee6b@linux.alibaba.com>
In-Reply-To: <0c9dc2fa-34c9-4db5-bea3-af4caf05ee6b@linux.alibaba.com>
From: Patryk Kowalczyk <patryk@kowalczyk.ws>
Date: Fri, 25 Jul 2025 10:36:00 +0200
X-Gm-Features: Ac12FXyEKrtN_N7qJCcS398gnqUSs9IOulF0QK-vhDxlTYEsZ407N2rmXhUxFoE
Message-ID: <CAJCW39JmaJpFCgoSGf6tSYkwVgxyUdSDFeeoFmf6ODLfsh4Cag@mail.gmail.com>
Subject: Re: regression - mm: shmem: add large folio support for tmpfs affect
 GPU performance.
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@redhat.com>, da.gomez@samsung.com, 
	baohua@kernel.org, wangkefeng.wang@huawei.com, ioworker0@gmail.com, 
	willy@infradead.org, ryan.roberts@arm.com, akpm@linux-foundation.org, 
	eero.t.tamminen@intel.com, =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: multipart/alternative; boundary="00000000000094d5bd063abcd59d"
X-Rspamd-Queue-Id: D0F67100009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: ssag8bdkg83csitq6kbh8me71zba3ziz
X-HE-Tag: 1753432573-678337
X-HE-Meta: U2FsdGVkX19Wjffw+hnXd5qJ/n5ngf2aIBJdQPKuEhAdJ3l8VszgoGydp9LJhHbYEp6TiffqX631VmiKKxPIMJILoBg/BMVvQpVkuRh8XFtBX7vnwbnc5gU3oYJzBSlskMankVXThUCTo6gE+uxRacjl/pqh2AVeXcEJnc9UN/WDqvxd9JVSiXuzCBsmjWcevjFgDBUNlH2bdTDHTOxt73xLpk9u8e5sB742w5bEdRyKy6SRqK0jrzZ45wHPAVsTbrqzIEWVdbMh09GbUfDVp4TAzV64s1PnjU+/z9rY902Ex9fwKKHk3I5Q+71WPuL5ilhl/HOcWUmkGhg6iIclvGnZfLEuTFJY0B2twfsm4IT34dmxk7rUR8KOxHFt6drgjIjHabgEL2jX2mKO45rJQqzWf51+iWXKMDA7n93ePcmi++dlDgd8WXRDpukTYeEYb6r2RVP+wtTlFYP+hCEjCk7CZ7jLWHrecjnJUYY87CLjIpbhS38D3I5h08pF0F2WcRzt/WXNsZJLuPH4LBXkkwRwZAX41CFifAAkT2mJsQp6uztWvF6oOsxpjo9MeJTywf7ImWjqQpvQnaPiOy0AlXX+LxwJ+wjdTlSUpij8dxWw1oJpgWw+81mXX/nV9t31bA/yLn9Z31VMYELYpHlzTcqftQRnZCgvAMMQjJ66O/Ja5W6RXxctkA1afXLps1gYJc+lbq5saWD1v2yW8xqG6AJL9r1sDALvOfzH7Pw3iLCztgiWRXG+MxXSe++BSBb/hs4N5aLl37KxZIvq+92hNkl3UNUHmsQBAg/SmhEfQr1ZMt7KpGgIaA7QQlZ4XPW1POXhZQIKdE+9pS2MG8q7Xdj6yaLsyZsQRmiLFiuYFxOXw35EJ6eHzVLaS2lH7CqYknQQxeJ95BhbUD6LjntDKPCBIwQQNp2FUtr1i+0IiDGzuDZQMr24bQuTn0B+phHSMvhm4vRBnoWq6nOpSUO
 qEMMwYmo
 0k0USoI/3YOAche5K91vfm8KkyyC1yg83IFbNg4O6ya/x7ULyZ+whln4KTpNqrH+sy6BA+M3YyCFs0bwVC7DTnfD0ObWtHhisXw3Xk58aGisJtK6UF/yI1EmVysJORYgP4XuLKZ7u7/JULvroi+PUaN6tX3hzCCPlJAxcOrJB8Me7C8aljXXpgDzxnu8YNQSEPiKCOZSxYNYpNIJmftI+f76vQWPzyUt8JUR+vBbwvYBCt/lgv3css++/NbaXtcClvqiXasBvpCKGY87AxZn46EMs/6HkJ/Zz5NwSsxTghibhv0B8gg5kPZDmhP2LismIVzy2Iu4Bs5LzZ0ssOmzemuHcRnLXHGfPXMYZldR/jL7O24W/cXRcT1/oVf0m/S1HWJKnZLVdS7qBGaSFmMoDclMxCgG3UAnhorCZACjFfM3h7V/lazH4tysVBpmSbYWyZSkctTgRqJHUrxQihO5tTNZLeHmllK+8hCp6RIuLFVp9GDft2TGNFW4N4cjT91/hLO2l1qLvZO/hp97XbrCLaPmHGOaKVIYEGn6oYrYl4vW8OPZ2fDnq6FzzpP8jS/crYAZ3Kkp12lYDN10=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000094d5bd063abcd59d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I have tested the fix for the i915 driver with kernel 6.16-rc7 and intel
core ultra 155H.
The performance in several tests is on the kernel 6.12 level,
so from a functional standpoint, the issue has been resolved.
Additionally, I also see potential for further optimization of the Xe
driver.

regards,
Patryk
pt., 25 lip 2025 o 08:05 Baolin Wang <baolin.wang@linux.alibaba.com>
napisa=C5=82(a):

>
>
> On 2025/7/25 12:47, Hugh Dickins wrote:
> > On Fri, 25 Jul 2025, Baolin Wang wrote:
> >>>
> >>> I hope to correct the logic of i915 driver's shmem allocation, by
> extending
> >>> the shmem write length in the i915 driver to allocate PMD- sized THPs=
.
> IIUC,
> >>> some sample fix code is as follows (untested). Patryk, could you help
> test
> >>> it to see if this resolves your issue? Thanks.
> >
> > This patch cannot be the right fix.  It may be a very sensible workarou=
nd
> > for some in-kernel drivers (I've not looked or tried); but unless I
> > misunderstand, it does nothing to restore userspace behaviour on a
> > huge=3Dalways tmpfs.
>
> Yes. Initially, we wanted to maintain compatibility with the 'huge=3D'
> option, meaning that 'huge=3Dalways' tmpfs mount would still allocate
> PMD-sized THPs. However, the current implementation is the consensus we
> reached after much debate:
>
> 1. =E2=80=9CWhen using tmpfs as a filesystem, it should behave like other
> filesystems. No more special mount options.=E2=80=9D Per Matthew.
> 2. =E2=80=9CDo not let the 'huge=3D' mount option mean 'PMD-sized' when o=
ther
> sizes exist.=E2=80=9D Per David.
>
> At the time, we should have sought your advice, but we failed. The long
> historical discussion is in this thread[1]. So now the strategy for
> tmpfs supporting large folios is:
>
> "
> Considering that tmpfs already has the 'huge=3D' option to control the
> PMD-sized large folios allocation, we can extend the 'huge=3D' option to
> allow any sized large folios. The semantics of the 'huge=3D' mount option
> are:
> huge=3Dnever: no any sized large folios
> huge=3Dalways: any sized large folios
> huge=3Dwithin_size: like 'always' but respect i_size
> huge=3Dadvise: like 'always' if requested with madvise()
>
> Note: For tmpfs mmap() faults, due to the lack of a write size hint,
> still allocate the PMD-sized large folios if
> huge=3Dalways/within_size/advise is set.
>
> Moreover, the 'deny' and 'force' testing options controlled by
> '/sys/kernel/mm/transparent_hugepage/shmem_enabled' still retain the
> same semantics. The 'deny' can disable any sized large folios for tmpfs,
> while the 'force' can enable PMD sized large folios for tmpfs.
> "
>
> Currently, we have observed regression in the i915 driver but have not
> yet seen userspace regression on a huge=3Dalways tmpfs.
>
> If you have better suggestions, please feel free to point them out. Thank=
s.
>
> [1] https://lore.kernel.org/lkml/Zw_IT136rxW_KuhU@casper.infradead.org/
>
> > Please reread my comment earlier in the thread, in particular,
> > Passing a new SIGBUS xfstest does not excuse a regression: strict
> PAGE_SIZE
> > SIGBUS behaviour is fine for the newly-featured mTHPs or large folios,
> > but not for the long-established huge=3Dalways.
>
>

--00000000000094d5bd063abcd59d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">I have tested the fix for the i915 driver=
 with kernel 6.16-rc7 and intel core ultra 155H.=C2=A0<div>The performance =
in several tests is on the kernel 6.12 level,</div><div>so from a functiona=
l standpoint, the issue has been resolved.=C2=A0</div><div>Additionally, I =
also see potential for further optimization of the Xe driver.</div></div><d=
iv><br></div>regards,<div>Patryk<br><div class=3D"gmail_quote gmail_quote_c=
ontainer"><div dir=3D"ltr" class=3D"gmail_attr">pt., 25 lip 2025 o 08:05=C2=
=A0Baolin Wang &lt;<a href=3D"mailto:baolin.wang@linux.alibaba.com">baolin.=
wang@linux.alibaba.com</a>&gt; napisa=C5=82(a):<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex"><br>
<br>
On 2025/7/25 12:47, Hugh Dickins wrote:<br>
&gt; On Fri, 25 Jul 2025, Baolin Wang wrote:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I hope to correct the logic of i915 driver&#39;s shmem allocat=
ion, by extending<br>
&gt;&gt;&gt; the shmem write length in the i915 driver to allocate PMD- siz=
ed THPs. IIUC,<br>
&gt;&gt;&gt; some sample fix code is as follows (untested). Patryk, could y=
ou help test<br>
&gt;&gt;&gt; it to see if this resolves your issue? Thanks.<br>
&gt; <br>
&gt; This patch cannot be the right fix.=C2=A0 It may be a very sensible wo=
rkaround<br>
&gt; for some in-kernel drivers (I&#39;ve not looked or tried); but unless =
I<br>
&gt; misunderstand, it does nothing to restore userspace behaviour on a<br>
&gt; huge=3Dalways tmpfs.<br>
<br>
Yes. Initially, we wanted to maintain compatibility with the &#39;huge=3D&#=
39; <br>
option, meaning that &#39;huge=3Dalways&#39; tmpfs mount would still alloca=
te <br>
PMD-sized THPs. However, the current implementation is the consensus we <br=
>
reached after much debate:<br>
<br>
1. =E2=80=9CWhen using tmpfs as a filesystem, it should behave like other <=
br>
filesystems. No more special mount options.=E2=80=9D Per Matthew.<br>
2. =E2=80=9CDo not let the &#39;huge=3D&#39; mount option mean &#39;PMD-siz=
ed&#39; when other <br>
sizes exist.=E2=80=9D Per David.<br>
<br>
At the time, we should have sought your advice, but we failed. The long <br=
>
historical discussion is in this thread[1]. So now the strategy for <br>
tmpfs supporting large folios is:<br>
<br>
&quot;<br>
Considering that tmpfs already has the &#39;huge=3D&#39; option to control =
the <br>
PMD-sized large folios allocation, we can extend the &#39;huge=3D&#39; opti=
on to <br>
allow any sized large folios. The semantics of the &#39;huge=3D&#39; mount =
option are:<br>
huge=3Dnever: no any sized large folios<br>
huge=3Dalways: any sized large folios<br>
huge=3Dwithin_size: like &#39;always&#39; but respect i_size<br>
huge=3Dadvise: like &#39;always&#39; if requested with madvise()<br>
<br>
Note: For tmpfs mmap() faults, due to the lack of a write size hint, <br>
still allocate the PMD-sized large folios if <br>
huge=3Dalways/within_size/advise is set.<br>
<br>
Moreover, the &#39;deny&#39; and &#39;force&#39; testing options controlled=
 by <br>
&#39;/sys/kernel/mm/transparent_hugepage/shmem_enabled&#39; still retain th=
e <br>
same semantics. The &#39;deny&#39; can disable any sized large folios for t=
mpfs, <br>
while the &#39;force&#39; can enable PMD sized large folios for tmpfs.<br>
&quot;<br>
<br>
Currently, we have observed regression in the i915 driver but have not <br>
yet seen userspace regression on a huge=3Dalways tmpfs.<br>
<br>
If you have better suggestions, please feel free to point them out. Thanks.=
<br>
<br>
[1] <a href=3D"https://lore.kernel.org/lkml/Zw_IT136rxW_KuhU@casper.infrade=
ad.org/" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/lkml/=
Zw_IT136rxW_KuhU@casper.infradead.org/</a><br>
<br>
&gt; Please reread my comment earlier in the thread, in particular,<br>
&gt; Passing a new SIGBUS xfstest does not excuse a regression: strict PAGE=
_SIZE<br>
&gt; SIGBUS behaviour is fine for the newly-featured mTHPs or large folios,=
<br>
&gt; but not for the long-established huge=3Dalways.<br>
<br>
</blockquote></div></div></div>

--00000000000094d5bd063abcd59d--

