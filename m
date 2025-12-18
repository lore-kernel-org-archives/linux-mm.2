Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2481BD68BDD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F636B0088; Thu, 18 Dec 2025 02:06:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506DA6B0089; Thu, 18 Dec 2025 02:06:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409B16B008A; Thu, 18 Dec 2025 02:06:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4DA6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:06:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8C6D5D3DE
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:06:16 +0000 (UTC)
X-FDA: 84231707952.09.A0E00F4
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf07.hostedemail.com (Postfix) with ESMTP id 104054000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:06:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dti8gcpj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766041575; a=rsa-sha256;
	cv=none;
	b=BdPko7DLfQZ7h/iw1v0nMl+UGOIN0W0OJL5ZkmdV+yhQBqhDjNioDBM67+SqsCuxKexsP5
	CBPhWXsR0uIUlZH61i6r4Vhprw+pH07DiteHl64/S0WsDGdY3D+O3UOphuf9sYdw3TH/bR
	S5THdoUpdb602H7R07eRqn8ke7WWVeg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dti8gcpj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766041575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShqR0Po/yZ8Gc0qg1p2cGJbRhsAmg25rqfXMEOkojK4=;
	b=1hxzW066QKHfpVR4g7RBhXmqhl50gcc1Ny0DWm0L16dNgJ+8BdrfHgpApWrT1mEMP6unsx
	cjk9Iy59shhftY3gnYzeAht//vd4DKkNqOR3esKZD8UuTwHvtkKFLqQfMybN3IaDD9gkVo
	UvbiOwd69AJAVJvM138tJ9s1tARn/Ys=
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5599688d574so65242e0c.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766041574; x=1766646374; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ShqR0Po/yZ8Gc0qg1p2cGJbRhsAmg25rqfXMEOkojK4=;
        b=dti8gcpjL4aPGM0b+0Q+/862wSDO5tdd9fWiZ5hU2fBBrhZVKPtK5Yjv5vXMmsxsP4
         KgxlwgJ+ILqbjegA7Z9GhXJzaaOwKAL819uVXJZ/oTOIqGS6G0lWE+dGVB/0PcoxA3UN
         QKhGzs65kyhG9yD3Fbp11nZsORRHAqESmPTJKI7DlLEOTvfctzyw09w6JC75ojTJjKxs
         peloTPkTO3dYBOVvCBmSVm8HpZQPCNpsP8PSCtqygX3esOsp6NwIhUbNLFjOemseMFnj
         LAAIP2l0p2qnHOPICYVsAauNJa3YOMuZHdW6BLWyQFtsw2p8zNAQISop3IbxNJTYmk/P
         XP7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766041574; x=1766646374;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ShqR0Po/yZ8Gc0qg1p2cGJbRhsAmg25rqfXMEOkojK4=;
        b=FsShgcaOOafIku68z2mx3KP4Kxuk5+9SZXeBoKO7wJSP1Xl4otjgwTqAdsfpWFXsUz
         eFYZpnOq1jBgFxgSsFYz0QOCzRdNC0yUy3xLdFwWY0r313SdJ3T5dNXd4C4bg3yV9XMB
         MsoT064RIQrZPJrPKnYkVDxz5XYxBiic89FgmFbNI/LlX0devAQMgInCbNIl4nUjAdzp
         Fw+VQ8rvoaJi6kfaX5NrHvgkgJr3b/XUNRObfo5BwNT09NQ0CwBu0uDhUnBoWebQsXV4
         40YBeiuzNwaXDGpbRaLvVjdjy4vliNaDMLDqoD+Rvz019EE+W7xYgcCZ2+B2uL2gn52b
         3saA==
X-Forwarded-Encrypted: i=1; AJvYcCV9P4AqybGWRPdYttCSUkuXowtosEGfsXy+1/8EmN/Of40cpqr+VzoMWkB8PKW+gF9bGAdBKjohRA==@kvack.org
X-Gm-Message-State: AOJu0Yycx0dPTufeg6qtg1eMiPVh+wAuCZPapS7QQlkuLc9vwFSIFLbL
	eO4qp/3p0cr2hPN9htZH0sCLdQ2M8HKFjr8aHElC4pNOFKD4Kvx6QRwC6dZ4B3cJrFA4gaGYj/D
	7XJJ1HDW0pWmk6qHFobOy4WWrJuapaew=
X-Gm-Gg: AY/fxX6irzXG8S7OFM+HiuZYPlPH6q7C2eYKGG3qDz4LMGXELXzmZbu+mUCcaHRlxrP
	KSYI84gV7DEgeGNxxnfrRrRT+VcN1LKjwKFZ7/eCnNwoBVeAjYeOwzaX4a/i8dsmZPOfXLA0Cuf
	zGZv6H2DJ0kqRJwawJJ5UXlf+QefvtAEnFq1m/zvbJq1cw8TP+ltwIWJ0gw3ppe85kpCtOKhXEG
	7Yg/ko1DZMlkDd64RRotu2bzzQvpMJywjNVpxH9nNrPS6J0SbvMpP7pgDso3zBh+x48xWA=
X-Google-Smtp-Source: AGHT+IFE3A4o1KOZ69k8Ups+TCs7Lw534FjapuITsVEVCg62Fr9FuTyUc5DiZQPtAF4yXnjWXYBj9NzNs/OE3xlFuWk=
X-Received: by 2002:a05:6122:1788:b0:55b:305b:4e3c with SMTP id
 71dfb90a1353d-55fed668578mr6446108e0c.18.1766041574147; Wed, 17 Dec 2025
 23:06:14 -0800 (PST)
MIME-Version: 1.0
References: <20251215145419.3097-1-kdipendra88@gmail.com> <20251215204624.GE905277@cmpxchg.org>
In-Reply-To: <20251215204624.GE905277@cmpxchg.org>
From: Dipendra Khadka <kdipendra88@gmail.com>
Date: Thu, 18 Dec 2025 12:51:04 +0545
X-Gm-Features: AQt7F2rZTtgdYrtWJLe9qw_ojBDsW2a0MkCU_t-Twp7HrLsGCjcXznbdhQQIoRc
Message-ID: <CAEKBCKM5aB0JHvF-0-GWeCjwPk00SE+TjbL2x64w0xH5Gmf-aA@mail.gmail.com>
Subject: Re: [PATCH] mm/memcg: reorder retry checks for clarity in try_charge_memcg
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000af8b6d0646349891"
X-Rspamd-Queue-Id: 104054000F
X-Rspamd-Server: rspam03
X-Stat-Signature: r66jhs3u1xznk4imbz4gqs8k9io9ssuy
X-Rspam-User: 
X-HE-Tag: 1766041574-141843
X-HE-Meta: U2FsdGVkX1/tRN1JA+yHKZIyhBipLu9is7xSWiJZwc2dValplOsFy8zIQvxXBZnTKcKCNWRCTQAEpolH6m/ytH8wjD2qRwaWPVuK8B0huoj2X3GP4yWRGvDTH5cBkpCoS3+adRfhxaUsE51tBJwexhZArEULKzyC6S3SCnobeIymlz9Hj2DGW1XkTpZZYGZld/Atv44nEGfSXdc5LlJiCfjXQ56fofdUcWkFzVALB4fliiPIVI/cRhc8Ds9c5zJKtYtFn/UYW5lChk+g/qzQR9dFD9xbsELBIyMYaxwJJSeJCxGiONo3FC5O6loZj5QwBUt2TCNO3kx2Jmn5D+59vvhuxeyY6WEr/E2UN4yIYOuZW0Dx1UOnetAavRzgzN6IER3/LrluO8OCI9EZaGbdQkZqg7OLIUZb29Kcu7GeCLUmUv1MXKbU+ms3WaYe9LsNtu534A7ORx/MiuBclh/vHbzPzNmgAsNthCsV2y4ieorV6utz5l/di0dDmDSmH4m+Bagmt6M8kxGhxdW40yk+afCiGhsAphnFe6aB2aH6Qpa36iqHeBuX7UMwvfHy75QJelU1PbWD3ykxoPPmsjos94+lyfeQ22cOmaRM3+91UnxyavX8/qR92+Cy6kftpILHBPew4Umhipbc7h2KpeY7aVy/xCVE3D86Y1EAqDG+yrfiF0hG+Df4i0UzrsSVHaAeEVo/SBzzxNGjyKJYTRGYgwZEa6EH0Eje05vMWBZLuy16rWCxnrgxIwpA6HdC8L48GKznIUGGFqTMRNM6x7szULgpR012T2cVimA74igtehWTSbyYHC+4PAIJnoy1mmF3IBUPF/xtOfGhJbSg6sjcqrwL8kEiD+CkBrLCek7a7Y3O428Vk7VxBqdq6JRkDgyuBdoIuFhRMEMlTrkr4p6GYEzE822Ej/yG2rnWIPB38xEQQeK9MqZbFywPQUixhS8BRw4GqBWcjenUOWLxqsh
 N8eduQ8u
 WLcTmE6p5qSnsIQPti9HahVMJOyYRFy1JSE61vNEBPB+VMxDia5ZLnezyp3Bks598OTZjJ3WsmtNHQiPtmMXWdrF6IYDASpmbGF+D9sKMFBfXlCukfHmwZkE6NavCiU0Yu/u2jbsHMtWUKVYWrWk7KV8Wy4S3ps37MQ+MN9rnfqHcpMLkBC8TPxy46gAVTJ1WkQuf2boP3EocH1/hKKH4E05kfVcyl5nvI096TlbSfI9P8Std4wuUJYsR1iiW73V3hFFF+mZWpzLsjm1r1nC/31wJDOQ1FedjCoLd3N6EfcSeM7n4K95g8b/o0oXtL0SJGJnG872OzeHrWehyQbYfFDmuVGrmncdIfi19KM19GYjM66s4URvh+LqRVjVW2XCrxl40syGWXGPovLrkp+niA3rfk3qvLjZAo2HFFVErJp0A1T7NmvcXXiK4JPFE3TbwvbOBO1+yzER5DQhoIe1qNRP665m2x1m/FyIunRYP1Y/nb8nz+yKZyetv9gyH/Mve30AExBDRYytdyJ7uPN6gsglnd8SebLSH28eaBrUjScw9jGw0d8f8SDKcy+IMPXjFEy8w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000af8b6d0646349891
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Johannes,

Thank you for the feedback. Let me clarify the scenario this patch
addresses.

On Tue, 16 Dec 2025 at 02:31, Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Mon, Dec 15, 2025 at 02:54:19PM +0000, Dipendra Khadka wrote:
> > In try_charge_memcg(), reorder the retry logic checks to follow the
> > early-exit pattern by testing for dying task before decrementing the
> > retry counter:
> >
> > Before:
> >     if (nr_retries--)
> >         goto retry;
> >
> >     if (passed_oom && task_is_dying())
> >         goto nomem;
> >
> > After:
> >     if (passed_oom && task_is_dying())
> >         goto nomem;
> >
> >     if (nr_retries--)
> >         goto retry;
> >
> > This makes the control flow more obvious: check exit conditions first,
> > then decide whether to retry. When current task is dying (e.g., has
> > received SIGKILL or is exiting), we should exit immediately rather than
> > consuming a retry count first.
> >
> > No functional change for the common case where task is not dying.
>
> It's definitely a functional change, not just code clarification.
>
> The oom kill resets nr_retries. This means that currently, even an OOM
> victim is going to retry a full set of reclaims, even if they are
> hopeless. After your patch, it'll retry for other reasons but can bail
> much earlier as well. Check the other conditions.
>
> The dying task / OOM victim allocation path is tricky and it tends to
> fail us in the rarest and most difficult to debug scenarios. There
> should be a good reason to change it.

The task_is_dying() check in try_charge_memcg() identifies when the
CURRENT task (the caller) is the OOM victim - not when some other
process was killed.

Two scenarios:

1. Normal allocator triggers OOM:
  - Process A allocates =E2=86=92 triggers OOM
  - Process B is killed (victim)
  - Process A continues with reset retries - task_is_dying() =3D false for =
A
  =E2=86=92 Unchanged by my patch

2. Victim tries to allocate:
 - Process B (victim, TIF_MEMDIE set) tries to allocate
  - task_is_dying() =3D true
  - Current code: wastes retries on hopeless reclaims
  - My patch: exits immediately
  =E2=86=92 Optimization for this case

The victim has three safety mechanisms that make the retries unnecessary:
1. oom_reaper proactively frees its memory
2. __alloc_pages_slowpath() grants reserves via oom_reserves_allowed()
3. Critical allocations with __GFP_NOFAIL still reach force: label

The retry loop for a dying victim is futile because:
- Reclaim won't help (victim is being killed to free memory!)
- Victim will exit regardless
- Just wastes CPU cycles

Would you like me to provide evidence showing the unnecessary retries,
or run specific tests to verify the safety mechanisms are sufficient?

Best Regards,
Dipendra

--000000000000af8b6d0646349891
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Johannes,<br><br>Thank you for the feedback. Let me cla=
rify the scenario this patch addresses.<div><br>On Tue, 16 Dec 2025 at 02:3=
1, Johannes Weiner &lt;<a href=3D"mailto:hannes@cmpxchg.org">hannes@cmpxchg=
.org</a>&gt; wrote:<br>&gt;<br>&gt; On Mon, Dec 15, 2025 at 02:54:19PM +000=
0, Dipendra Khadka wrote:<br>&gt; &gt; In try_charge_memcg(), reorder the r=
etry logic checks to follow the<br>&gt; &gt; early-exit pattern by testing =
for dying task before decrementing the<br>&gt; &gt; retry counter:<br>&gt; =
&gt;<br>&gt; &gt; Before:<br>&gt; &gt; =C2=A0 =C2=A0 if (nr_retries--)<br>&=
gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto retry;<br>&gt; &gt; =C2=A0 =C2=A0=
<br>&gt; &gt; =C2=A0 =C2=A0 if (passed_oom &amp;&amp; task_is_dying())<br>&=
gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto nomem;<br>&gt; &gt;<br>&gt; &gt; =
After:<br>&gt; &gt; =C2=A0 =C2=A0 if (passed_oom &amp;&amp; task_is_dying()=
)<br>&gt; &gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto nomem;<br>&gt; &gt; =C2=A0 =
=C2=A0<br>&gt; &gt; =C2=A0 =C2=A0 if (nr_retries--)<br>&gt; &gt; =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 goto retry;<br>&gt; &gt;<br>&gt; &gt; This makes the cont=
rol flow more obvious: check exit conditions first,<br>&gt; &gt; then decid=
e whether to retry. When current task is dying (e.g., has<br>&gt; &gt; rece=
ived SIGKILL or is exiting), we should exit immediately rather than<br>&gt;=
 &gt; consuming a retry count first.<br>&gt; &gt;<br>&gt; &gt; No functiona=
l change for the common case where task is not dying.<br>&gt;<br>&gt; It&#3=
9;s definitely a functional change, not just code clarification.<br>&gt;<br=
>&gt; The oom kill resets nr_retries. This means that currently, even an OO=
M<br>&gt; victim is going to retry a full set of reclaims, even if they are=
<br>&gt; hopeless. After your patch, it&#39;ll retry for other reasons but =
can bail<br>&gt; much earlier as well. Check the other conditions.<br>&gt;<=
br>&gt; The dying task / OOM victim allocation path is tricky and it tends =
to<br>&gt; fail us in the rarest and most difficult to debug scenarios. The=
re<br>&gt; should be a good reason to change it.<br><br>The task_is_dying()=
 check in try_charge_memcg() identifies when the<br>CURRENT task (the calle=
r) is the OOM victim - not when some other=C2=A0</div><div>process was kill=
ed.</div><div><br>Two scenarios:<br><br>1. Normal allocator triggers OOM:<b=
r>=C2=A0 - Process A allocates =E2=86=92 triggers OOM<br>=C2=A0 - Process B=
 is killed (victim)<br>=C2=A0 - Process A continues with reset retries - ta=
sk_is_dying() =3D false for A<br>=C2=A0 =E2=86=92 Unchanged by my patch<br>=
<br>2. Victim tries to allocate:<br>=C2=A0- Process B (victim, TIF_MEMDIE s=
et) tries to allocate<br>=C2=A0 - task_is_dying() =3D true<br>=C2=A0 - Curr=
ent code: wastes retries on hopeless reclaims<br>=C2=A0 - My patch: exits i=
mmediately<br>=C2=A0 =E2=86=92 Optimization for this case<br><br>The victim=
 has three safety mechanisms that make the retries unnecessary:<br>1. oom_r=
eaper proactively frees its memory<br>2. __alloc_pages_slowpath() grants re=
serves via oom_reserves_allowed()<br>3. Critical allocations with __GFP_NOF=
AIL still reach force: label<br><br>The retry loop for a dying victim is fu=
tile because:<br>- Reclaim won&#39;t help (victim is being killed to free m=
emory!)<br>- Victim will exit regardless<br>- Just wastes CPU cycles<br><br=
>Would you like me to provide evidence showing the unnecessary retries,<div=
>or run specific tests to verify the safety mechanisms are sufficient? <br>=
<br>Best Regards,<br>Dipendra</div></div></div>

--000000000000af8b6d0646349891--

