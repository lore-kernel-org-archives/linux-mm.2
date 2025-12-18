Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FD35D68BE3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 06:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D9F66B0089; Thu, 18 Dec 2025 01:55:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387516B008A; Thu, 18 Dec 2025 01:55:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268F36B008C; Thu, 18 Dec 2025 01:55:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 121526B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:55:58 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99737140D33
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:55:57 +0000 (UTC)
X-FDA: 84231681954.13.E2D543E
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id C1E8B4000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:55:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kl+IXhGS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766040955; a=rsa-sha256;
	cv=none;
	b=a1aTxQ6xjjp/fYnZb0FNEKebAD+U3xjMg+S6/q1MLDmkUOAmCXmoZ1u3xgAXmsjRJeS1AR
	SoORnAW6QU3R/w6jtaVy4aTxOrTslzzVvL6kSPFYpAsxfEuyrzgxR1dBzziNSzL+zwjaKD
	32FlP92D1pnShFE0DXZJaMDUraTDhX8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kl+IXhGS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766040955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yC7n9Z0OzYbxwInXF7xKv9suG/5p2FgSxK43erIupu4=;
	b=ed+VXhK+th3mybVWSGBo4Pmqw6YPwxDdaJT3m/QlwkbfzP8/yfntujCAfcCbG3LJ5OGfYK
	60KLasCk4b+CfX9iYQy85ZGvdZNXPGrm6jxdVotBP1acC0ZxY01xZvHgaVOvHWe3sbHq05
	aLsizFESLfr7WSuywA4S/OYo0Vu97xU=
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-55999cc2a87so59978e0c.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766040955; x=1766645755; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yC7n9Z0OzYbxwInXF7xKv9suG/5p2FgSxK43erIupu4=;
        b=kl+IXhGS4x+dpEYw9k+HJA1QMMDA3+BBTFWM+kAgLFrXJbnukhVpKgUx38M2v0yzd3
         IqAB9SBnvwkHdnkrz5w+8G+sbwgsc+BGvSjp2afSK79WuIPHoHtp/rh150gdqSJxJphQ
         /3VcWYjQbO6AlIiO+6jl4jTLz+eOrKV2zsaZ4ZHhoYMNEkNpvA0kXl08lU7qVhG+RT7U
         cMJDru0A7BNUI+5D54qtyEu4ta2UnmfsUo/OkYfyFCAXD290QzsHIhcAMpP4FlLArBZU
         l6cPWGORGeldYrCWgNVGdUWsBMaFOziH6ktjvRUmB2o5Pegh21EyoCiinjF9alu/VuEL
         jSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766040955; x=1766645755;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yC7n9Z0OzYbxwInXF7xKv9suG/5p2FgSxK43erIupu4=;
        b=fKFcJkhL/o8OK2pCMUKdIKLa/KfiaH2hY8rxcoyIybCKWrEs2d3qv7piqw1Zk/AKpj
         z+ut570oLJbeuchPSmYEq2Zon2uLGa2kboHyqfl3P2hNI0p1VCTGWJn1r5+uoqz2RBnX
         2IjmWo3JiL0igMPp7o37N+amw1nMiTU9JG2IIqadgvj1/E8XRLFMVx+0p5KYifdA9Esa
         IwXwg6CVF6vfUTXDVQ0aviJQ5AedYB9Iq0ej3MKEKEvnG8yQzmQE9dc/REFwckA2lVMr
         giYLtHjO4FA32xhszoUZYLlXXHbiQy2MyNLDKL0l6kUZwT6l7DYf5yt28ungWKdHC3Q9
         OYag==
X-Forwarded-Encrypted: i=1; AJvYcCVsu0tC6DoQ+PjO7mgCG7mq4Ft7nUOpqKVOXNJ7kl8NX1t7PLl2v34r/sNs2gRit1Z08gTPOWp85A==@kvack.org
X-Gm-Message-State: AOJu0Yx+99Mt5ZsoP4ieM70f5aeHJgNCidYle7zZ+k5u8mq+MWOUFbcP
	YEv7vVDSCoz+BVBKl2EPkijK/Y1UmK/V06d+AD9MPirW/pdgxXXzEPLuHhST1IINR4NfKFDFyAW
	EkQf7cACm0mxuS7f8AIXyHe+pdhJgubc=
X-Gm-Gg: AY/fxX6EvFd8wdKm6qBisEGEHsbJUHLDz5czNSFP/GUxPtfXRI+gUslja3YRTpSu5H7
	sWbBPS3QvF/+VCSXBSkZsrkC1oVc+eChSJUYE38YaLfRWO6JH+2OKfW1IRHCTscCWVCMb9rsokv
	W2loJt6sh0x+gZ4K1csjvLSHAxKtfKSMA86Z///WnLREo0bK1KJ2YfTLLgELPeS+RHDdXAi6mhj
	wnuX38Wx5z36BCf8ryNtw/VC41mFFg2F0HP5AkTht8T35hVKa4kvCX5uXJlFc7HZhLoqhg+tgpN
	ArFRew==
X-Google-Smtp-Source: AGHT+IHGfC1PW6ElJj42hBmYMvkBJBTPLHZU0nYuWISQSY5DPEpuUErQKpdAAKn/kt4MjBsfyYd7os0EWdEa3LQr6sE=
X-Received: by 2002:a05:6122:2205:b0:55b:305b:4e3f with SMTP id
 71dfb90a1353d-55fed6818c4mr7173545e0c.21.1766040954677; Wed, 17 Dec 2025
 22:55:54 -0800 (PST)
MIME-Version: 1.0
References: <20251215145419.3097-1-kdipendra88@gmail.com> <20251215204624.GE905277@cmpxchg.org>
In-Reply-To: <20251215204624.GE905277@cmpxchg.org>
From: Dipendra Khadka <kdipendra88@gmail.com>
Date: Thu, 18 Dec 2025 12:40:45 +0545
X-Gm-Features: AQt7F2o679XFZgDON1prz6S8WwlSLI1JYKT-mJ-iMhmtOGoRxRlJzEJuPCEHhro
Message-ID: <CAEKBCKMgQe-UopiWmxuQRoS8q511P+EY+X3Xj5FFJ1p1L6D4tw@mail.gmail.com>
Subject: Re: [PATCH] mm/memcg: reorder retry checks for clarity in try_charge_memcg
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000c32e250646347369"
X-Rspamd-Queue-Id: C1E8B4000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 3rz7kracz81pfesuonbm6cap4xjith87
X-Rspam-User: 
X-HE-Tag: 1766040955-471387
X-HE-Meta: U2FsdGVkX1+T64gRMWw5YwxNPV5rDHvA2xDGxhEvRUI04RJNsffh8d0nH7l+b7MSMbtgIxqGHbVVh82OLMZEMF+wzRIiLkkRDHF+8cP5MCQTqZzB678TOjvnvuWrBtuWk0xIUGdkZrW4iBaQ5YpNA4iZVnGeYoL45VpcbBigv/8rFQ/jdSs/aS8ePOx3Et9Oe+w2gjy5O0P1SuKMZLcQAk824cIJbPh5cXSwBnRW3QRQdOUBdJmZ5rkHQSgGUCk79QSavNTvB3ScIoDD/jsEd8En1rrgrFjMpDMrO8xdVbr/RDlmgjg9vyL13qFahY1nGFO7oq6rPVh1Yc5nPrcXJqBMWW+pp24pMXfeNwQ+pIXqMSijXvuoPUZtKfpDPZ5kS0GVlfNzYGY5cLF9Ym/bir4lyZsCpOz1ka/jTrfKCH9ct6hzl1qwrES7F9Auxhuz0XshQXU1+whtX1Q9x9SLh7D+gt87AbACTRRH1sB8xPKrKkgWJMoeJBYGZ0dqO8ZW7MjNjhZjIGGLM1MaAuaS3yUOQDYUoTiOQGSFkzYfhMxX9BWIewHFCjXiqv5sd/4kX+EQj6knbtO2C9clumCGLARbcHD4l59V3C7M0rnjmHKADcN3d5KAoNxCvok9XMKqoZIFd8U2QMcuR5KXYhdOhvJPCmahZ3B7G4VdqGbzC5MHq2VCScm6Uhq5UAbbKeBNULTLO/N9PIpMWGnSXbNCLToGumIU8em4f8gCGjo5TC/Ybwfe4AR+QneHpFHyzZGhzSGg07jNGWxEomPtjDlz7q0wRb4o/vVbMDqUi7h+32S6eQRj8vjO2qEi6oK0UwpIMuNhXWwqoQpqjRa46N09e/ncejGSo7gs/8bZkBjVtDuYQ5OwApmvX9b/+WLxYvfOjlAM4qvCbuOCiGr9crXTZUpCNTncbqSCip0GtHShtfLynYX+o0z8j+qaqwA9cpNOogfyUkZveKUzdWKjPTS
 ALcY0cxc
 COIDMHJZhblI9TVchIhfzXBv+4C8qBHjsU4NAefYoSUSI85sSK17wco1LzF9RE6j7JTPJY4wYJQpZZbzIysU7BWtjlme/+yTDpTxGIoWCl1jJqO94bsURla6P8oIH3TgHj1haWdLLsR67iLLJRJjVC01HIwGxYQa8ha7Kmc5iu9x7SFBQd4Yph0kHMIznKds0hIq+6MPSV+scZ14b8VkCLvS0Agfgr8FLo0ur1vcC2SwbAY4LHCOPbD2OWQRYgVva/ijXgS1/cUdV0g1/Yiigzqd8yqwfYeok2teTXWTsFmwtNkGgnxdOBgx1qxf/Cl3U56PiqzzPYldutTdYwiCHX0PN46aQW2q1gd0+5/hGOpNyMozY6S8cB4WbHO+2TpJyBKny+r1m8ZITRwaWJiLYoqiSww7g8ES/T1rtZupeJkPIIWwuQOiSFNNwzQgtRrWd1as+VbdD7fBKTNUGl1ePAeFadulZk1nUOJR9sDOeN6iyuGKUk4HltdB7FvRUiWoRV2Fq3OYQ9KG3tXXjY1aPyChPne0e+h/YTyEoLz5eEJrYGNFi4JSbsy1UMd+7VAcaRBAQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000c32e250646347369
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Johannes,


On Tue, 16 Dec 2025 at 02:31, Johannes Weiner <hannes@cmpxchg.org> wrote:

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



The oom kill resets nr_retries. This means that currently, even an OOM
> victim is going to retry a full set of reclaims, even if they are
> hopeless. After your patch, it'll retry for other reasons but can bail
> much earlier as well. Check the other conditions.


> The dying task / OOM victim allocation path is tricky and it tends to
> fail us in the rarest and most difficult to debug scenarios. There
> should be a good reason to change it.
>

Thank you for the feedback. Let me clarify the scenario this patch addresse=
s
:

The task_is_dying() check in try_charge_memcg() identifies when the
 CURRENT task (the caller) is the OOM victim - not when some other process
was killed.

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

 Best Regards,
 Dipendra

--000000000000c32e250646347369
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi Johannes,</div><table cellpadding=3D"0" class=3D"g=
mail-cf gmail-ix" style=3D"font-family:&quot;Google Sans&quot;,Roboto,Robot=
oDraft,Helvetica,Arial,sans-serif;font-size:14px;border-collapse:collapse;t=
able-layout:fixed;width:811.656px"><tbody></tbody></table><table cellpaddin=
g=3D"0" class=3D"gmail-cf gmail-gJ" style=3D"border-collapse:collapse;margi=
n-top:0px;width:auto;font-family:&quot;Google Sans&quot;,Roboto,RobotoDraft=
,Helvetica,Arial,sans-serif;font-size:14px;display:block"></table><br><br><=
div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"g=
mail_attr">On Tue, 16 Dec 2025 at 02:31, Johannes Weiner &lt;<a href=3D"mai=
lto:hannes@cmpxchg.org">hannes@cmpxchg.org</a>&gt; wrote:<br></div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px=
 solid rgb(204,204,204);padding-left:1ex">On Mon, Dec 15, 2025 at 02:54:19P=
M +0000, Dipendra Khadka wrote:<br>
&gt; In try_charge_memcg(), reorder the retry logic checks to follow the<br=
>
&gt; early-exit pattern by testing for dying task before decrementing the<b=
r>
&gt; retry counter:<br>
&gt; <br>
&gt; Before:<br>
&gt;=C2=A0 =C2=A0 =C2=A0if (nr_retries--)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto retry;<br>
&gt;=C2=A0 =C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0if (passed_oom &amp;&amp; task_is_dying())<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto nomem;<br>
&gt; <br>
&gt; After:<br>
&gt;=C2=A0 =C2=A0 =C2=A0if (passed_oom &amp;&amp; task_is_dying())<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto nomem;<br>
&gt;=C2=A0 =C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0if (nr_retries--)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto retry;<br>
&gt; <br>
&gt; This makes the control flow more obvious: check exit conditions first,=
<br>
&gt; then decide whether to retry. When current task is dying (e.g., has<br=
>
&gt; received SIGKILL or is exiting), we should exit immediately rather tha=
n<br>
&gt; consuming a retry count first.<br>
&gt; <br>
&gt; No functional change for the common case where task is not dying.<br>
<br>
It&#39;s definitely a functional change, not just code clarification.</bloc=
kquote><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;=
border-left:1px solid rgb(204,204,204);padding-left:1ex">=C2=A0</blockquote=
><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border=
-left:1px solid rgb(204,204,204);padding-left:1ex">
The oom kill resets nr_retries. This means that currently, even an OOM<br>
victim is going to retry a full set of reclaims, even if they are<br>
hopeless. After your patch, it&#39;ll retry for other reasons but can bail<=
br>
much earlier as well. Check the other conditions.</blockquote><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px soli=
d rgb(204,204,204);padding-left:1ex">
<br>
The dying task / OOM victim allocation path is tricky and it tends to<br>
fail us in the rarest and most difficult to debug scenarios. There<br>
should be a good reason to change it.<br></blockquote><div><br></div><div>T=
hank you <span class=3D"gmail-token" style=3D"color:rgb(198,120,221)">for</=
span> the feedback<span class=3D"gmail-token" style=3D"color:rgb(171,178,19=
1)">.</span> Let me clarify the scenario this patch=20
addresses<span class=3D"gmail-token" style=3D"color:rgb(97,175,239)">:</spa=
n>=C2=A0</div><div><br></div><div>The <span class=3D"gmail-token" style=3D"=
color:rgb(97,175,239)">task_is_dying</span><span class=3D"gmail-token" styl=
e=3D"color:rgb(171,178,191)">(</span><span class=3D"gmail-token" style=3D"c=
olor:rgb(171,178,191)">)</span> check in <span class=3D"gmail-token" style=
=3D"color:rgb(97,175,239)">try_charge_memcg</span><span class=3D"gmail-toke=
n" style=3D"color:rgb(171,178,191)">(</span><span class=3D"gmail-token" sty=
le=3D"color:rgb(171,178,191)">)</span> identifies when the=C2=A0</div><div>=
=C2=A0CURRENT <span class=3D"gmail-token" style=3D"color:rgb(97,175,239)">t=
ask</span> <span class=3D"gmail-token" style=3D"color:rgb(171,178,191)">(</=
span>the caller<span class=3D"gmail-token" style=3D"color:rgb(171,178,191)"=
>)</span> is the OOM victim <span class=3D"gmail-token" style=3D"color:rgb(=
97,175,239)">-</span> not when some other=20
process was killed<span class=3D"gmail-token" style=3D"color:rgb(171,178,19=
1)">.</span>=C2=A0</div><div><br></div><div>Two scenarios<span class=3D"gma=
il-token" style=3D"color:rgb(97,175,239)">:</span>=C2=A0</div><div><br></di=
v><div><span class=3D"gmail-token" style=3D"color:rgb(209,154,102)">1.</spa=
n> Normal allocator triggers OOM<span class=3D"gmail-token" style=3D"color:=
rgb(97,175,239)">:</span>=C2=A0</div><div>=C2=A0   <span class=3D"gmail-tok=
en" style=3D"color:rgb(97,175,239)">-</span> Process A allocates =E2=86=92 =
triggers OOM=C2=A0</div><div>=C2=A0 - Process B is <span class=3D"gmail-tok=
en" style=3D"color:rgb(97,175,239)">killed</span> <span class=3D"gmail-toke=
n" style=3D"color:rgb(171,178,191)">(</span>victim<span class=3D"gmail-toke=
n" style=3D"color:rgb(171,178,191)">)</span>=C2=A0</div><div>=C2=A0=C2=A0<s=
pan class=3D"gmail-token" style=3D"color:rgb(97,175,239)">-</span> Process =
A continues with reset retries
   <span class=3D"gmail-token" style=3D"color:rgb(97,175,239)">-</span> <sp=
an class=3D"gmail-token" style=3D"color:rgb(97,175,239)">task_is_dying</spa=
n><span class=3D"gmail-token" style=3D"color:rgb(171,178,191)">(</span><spa=
n class=3D"gmail-token" style=3D"color:rgb(171,178,191)">)</span> <span cla=
ss=3D"gmail-token" style=3D"color:rgb(97,175,239)">=3D</span> false <span c=
lass=3D"gmail-token" style=3D"color:rgb(198,120,221)">for</span> A=C2=A0</d=
iv><div>=C2=A0 =E2=86=92 Unchanged by my patch=C2=A0</div><div><br></div><d=
iv>=C2=A0<span class=3D"gmail-token" style=3D"color:rgb(209,154,102)">2.</s=
pan> Victim tries to allocate<span class=3D"gmail-token" style=3D"color:rgb=
(97,175,239)">:</span></div><div>
   <span class=3D"gmail-token" style=3D"color:rgb(97,175,239)">=C2=A0-</spa=
n> Process <span class=3D"gmail-token" style=3D"color:rgb(97,175,239)">B</s=
pan> <span class=3D"gmail-token" style=3D"color:rgb(171,178,191)">(</span>v=
ictim<span class=3D"gmail-token" style=3D"color:rgb(171,178,191)">,</span> =
TIF_MEMDIE set<span class=3D"gmail-token" style=3D"color:rgb(171,178,191)">=
)</span> tries to allocate=C2=A0</div><div>=C2=A0   <span class=3D"gmail-to=
ken" style=3D"color:rgb(97,175,239)">-</span> <span class=3D"gmail-token" s=
tyle=3D"color:rgb(97,175,239)">task_is_dying</span><span class=3D"gmail-tok=
en" style=3D"color:rgb(171,178,191)">(</span><span class=3D"gmail-token" st=
yle=3D"color:rgb(171,178,191)">)</span> <span class=3D"gmail-token" style=
=3D"color:rgb(97,175,239)">=3D</span> true=C2=A0</div><div>=C2=A0   <span c=
lass=3D"gmail-token" style=3D"color:rgb(97,175,239)">-</span> Current code<=
span class=3D"gmail-token" style=3D"color:rgb(97,175,239)">:</span> wastes =
retries on hopeless reclaims=C2=A0</div><div>=C2=A0   <span class=3D"gmail-=
token" style=3D"color:rgb(97,175,239)">-</span> My patch<span class=3D"gmai=
l-token" style=3D"color:rgb(97,175,239)">:</span> exits immediately=C2=A0</=
div><div>=C2=A0 =E2=86=92 Optimization <span class=3D"gmail-token" style=3D=
"color:rgb(198,120,221)">for</span> this <span class=3D"gmail-token" style=
=3D"color:rgb(198,120,221)">case</span>=C2=A0</div><div><br></div><div>=C2=
=A0The victim has three safety mechanisms that make the retries=20
unnecessary<span class=3D"gmail-token" style=3D"color:rgb(97,175,239)">:</s=
pan>=C2=A0</div><div><span class=3D"gmail-token" style=3D"color:rgb(209,154=
,102)">1.</span> oom_reaper proactively frees its memory=C2=A0</div><div><s=
pan class=3D"gmail-token" style=3D"color:rgb(209,154,102)">2.</span> <span =
class=3D"gmail-token" style=3D"color:rgb(97,175,239)">__alloc_pages_slowpat=
h</span><span class=3D"gmail-token" style=3D"color:rgb(171,178,191)">(</spa=
n><span class=3D"gmail-token" style=3D"color:rgb(171,178,191)">)</span> gra=
nts reserves via <span class=3D"gmail-token" style=3D"color:rgb(97,175,239)=
">oom_reserves_allowed</span><span class=3D"gmail-token" style=3D"color:rgb=
(171,178,191)">(</span><span class=3D"gmail-token" style=3D"color:rgb(171,1=
78,191)">)</span>=C2=A0</div><div><span class=3D"gmail-token" style=3D"colo=
r:rgb(209,154,102)">3.</span> Critical allocations with __GFP_NOFAIL still =
reach force<span class=3D"gmail-token" style=3D"color:rgb(97,175,239)">:</s=
pan> label=C2=A0</div><div><br></div><div>The retry loop <span class=3D"gma=
il-token" style=3D"color:rgb(198,120,221)">for</span> a dying victim is fut=
ile because<span class=3D"gmail-token" style=3D"color:rgb(97,175,239)">:</s=
pan>=C2=A0</div><div><span class=3D"gmail-token" style=3D"color:rgb(97,175,=
239)">-</span> Reclaim won&#39;t <span class=3D"gmail-token" style=3D"color=
:rgb(97,175,239)">help</span> <span class=3D"gmail-token" style=3D"color:rg=
b(171,178,191)">(</span>victim is being killed to free memory<span class=3D=
"gmail-token" style=3D"color:rgb(97,175,239)">!</span><span class=3D"gmail-=
token" style=3D"color:rgb(171,178,191)">)</span>=C2=A0</div><div><span clas=
s=3D"gmail-token" style=3D"color:rgb(97,175,239)">-</span> Victim will exit=
 regardless=C2=A0</div><div><span class=3D"gmail-token" style=3D"color:rgb(=
97,175,239)">-</span> Just wastes CPU cycles=C2=A0</div><div><br></div><div=
>=C2=A0Best Regards<span class=3D"gmail-token" style=3D"color:rgb(171,178,1=
91)">,</span></div><div>=C2=A0Dipendra</div></div></div>

--000000000000c32e250646347369--

