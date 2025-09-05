Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E225CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068148E000A; Fri,  5 Sep 2025 05:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F5B8E0006; Fri,  5 Sep 2025 05:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70858E000A; Fri,  5 Sep 2025 05:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D38238E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:44:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 845E516061C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:44:35 +0000 (UTC)
X-FDA: 83854711710.28.B14FB41
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id 95B9512000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:44:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=aisle.com header.s=google header.b="Y/eVRq/I";
	spf=pass (imf29.hostedemail.com: domain of stanislav.fort@aisle.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=stanislav.fort@aisle.com;
	dmarc=pass (policy=quarantine) header.from=aisle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757065473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RElUv6d6ZKdbX9YUWuQEPJnZdgmMS4xC3czLm/ptRu0=;
	b=kPl4B/vp6W/W0XVMZ8/vIw2GEfdDgXm3Vo9NUbV3q8Mi+aMB+T5mmcFpYS9I+MtmnUBhvT
	EU4scSDtkH8RN2e6eKZ4I1Zb+yNDPYb3zJoT87y6Bu1jaZ/E+F4Y9gUAfCKX4QXQEI8AGt
	JwvQdH34jpD0PW9bHRhoyjJaRr6d9QA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=aisle.com header.s=google header.b="Y/eVRq/I";
	spf=pass (imf29.hostedemail.com: domain of stanislav.fort@aisle.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=stanislav.fort@aisle.com;
	dmarc=pass (policy=quarantine) header.from=aisle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757065473; a=rsa-sha256;
	cv=none;
	b=gZwqSuf+M0PHNp1Rl7z5rpJr7cix5HwhKTNUdIn+H0L/fN5kt84PhvkCXAYMla5VGYGMlG
	2KAVIE0m9xGtCsFcbZqMhOf559u8U1ZBZHIHpmFBNFWBJHi3w6Z5G41QDgbjPHYV3gkNih
	mIPiMZvWWczc9uv6OFn4pKRdQQE5uWE=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61cf8280f02so2897318a12.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aisle.com; s=google; t=1757065472; x=1757670272; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RElUv6d6ZKdbX9YUWuQEPJnZdgmMS4xC3czLm/ptRu0=;
        b=Y/eVRq/IAwRYki54rJddGSzRJZptoeg6lQBsks7cMqxi3mxIe6ubonjL2BLoIrGo+O
         jrYvkH3JAl58Ncterec6HFiAse2MZM5VNDAO2WUX4VvAP39PYSGwECUTZPsXBtVjH+08
         0Gf/Z7Wn0E8BhrNoHojHB0PPwbZ/aqwmbePRXxJfpTpxmg63uKiji93a34jXo/edfXDI
         /McAPPeSHZGt/NLQCDiMOaVWGhS1icDz46YdJj684oZ56KWzCGGOUOBQaZezK+m5MIoZ
         DvT85sTMsaxAyfKx9QC+3jCvzlOGR08Msv4gsSmk/FuwIVNKh83yC8ikHrf6rOmO1euN
         F/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757065472; x=1757670272;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RElUv6d6ZKdbX9YUWuQEPJnZdgmMS4xC3czLm/ptRu0=;
        b=GsFJgJ55clQAV8eVBVklWzXt50QfdD6szexq+g8jFh5kcfU1zNcqnvzRIcK0Z1Zkm1
         hb6zUc/c2HgNWTve6y0tYQS1dWqKR2qfo7OOgs8ZPeqzzdy/ZRXWqVh7iMtFh++Xrvso
         SeD+Kh4I0ok8cL6lJYjvnYU0y1MlN9bwhyJlyhrr7UQKzhW7BNaOGN/wGlvRF0bcZw8w
         lZ43tQLaf9SXoqpL87+LuZirSS/aTKy2G3tub5Iy3lC0AccEZCecOE04urPebtTON1ki
         RmLj3PA7ijzuZ9mmidEXBznkGGY4UuAp5XBROwwpJiKd3zBJd8VK2EzF9w+j8vBT4REm
         UwrA==
X-Gm-Message-State: AOJu0Yx29ghtqBCNehPjxsKbm55LkMNuIPhVcO6sG4YWimpSZx9ykh0O
	cKhcK4WvBd0He2gOomSkOMhPlfb00/xvFjRXMhhfO84DfNTe9frk3utk5ATQcrZQmCOde+Wbe/h
	rkXOg89/AQyLHQMOI+HjMKk/rOChJ/PSlwoXeSzY/1A==
X-Gm-Gg: ASbGncsfLIpm4hsSR7dFsAb5GvkTIKMDt8xFJNPfBLZaFQaE6i+Wlwlk+PNw2qs9kRW
	EaK7wdh0URk9AjZGKfecMTmuQkJsrVzUBip1ssmEwonVUY5uItd/4xRKSL7zyJG0DSxTOEIuJcS
	IALy4SxQqslbV8zfp8sSl8Y5hSyWrGIt7sH2RKMInpvqS9en20/VqDLNgN6txgEjoqA9cKIteMI
	gLysHOogXFtLquLtzI=
X-Google-Smtp-Source: AGHT+IHZaRkabOxi9U4ocp/n0B85qNMDuksEzX4r1tCiG20H9U5BC6i2PuhhwN8R+ybZsm+aRg31k6GW1GmgCNUhcQo=
X-Received: by 2002:a05:6402:13cd:b0:61e:ee01:292a with SMTP id
 4fb4d7f45d1cf-61eee0130d9mr6564597a12.32.1757065472023; Fri, 05 Sep 2025
 02:44:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250904181248.5527-1-disclosure@aisle.com> <sa4mytppu6dfpquytx6jwdvak7bkyruztnr27vibbzhux2rjsl@pnrxdi5ecua3>
In-Reply-To: <sa4mytppu6dfpquytx6jwdvak7bkyruztnr27vibbzhux2rjsl@pnrxdi5ecua3>
From: Stanislav Fort <stanislav.fort@aisle.com>
Date: Fri, 5 Sep 2025 12:44:21 +0300
X-Gm-Features: Ac12FXyerNPuu-nXG3YLRZNwRrZtvQsuZQAbKDsg94s9SDim6d-29bX2iJoFPew
Message-ID: <CA+uRpKSm_u_RDrR8nP5DFFeV4vy5vT4tp1xX=rVNd-ehTCzkMw@mail.gmail.com>
Subject: Re: [PATCH] mm/memcg: v1: account event registrations and drop
 world-writable cgroup.event_control
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, stable@vger.kernel.org, 
	Stanislav Fort <disclosure@aisle.com>
Content-Type: multipart/alternative; boundary="0000000000004eaf24063e0aaffb"
X-Stat-Signature: irag9rro51i3zqbdzg8mhtsoqowgrqbr
X-Rspam-User: 
X-Rspamd-Queue-Id: 95B9512000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1757065473-605010
X-HE-Meta: U2FsdGVkX18XGQr792Nfe3UeMp+624tyMmnOArtYSLP5H/XsB5QWBH/RgeyG4EOmMllyPz8lkCc9JexDT5AFJ1rvR46gcZsK61KO2OkidCy8BgGtatjbikVZeMssxYAU3rnKiP35z9QBGl5pIS7AgLUFoPyAxF6oLD3PX3ILcRKhUk2r/aSYVpk43rWFX3EZm5dMqnhQ7aK4bPRQmTHu/idmk/hrIqAEzH543PAhRl8dw1oebdIBpVc4KuzppgwyI67zCOHGBfBuMYHmVQERe6lJMZgifod9ShlnzonKclX1WT4+QCdIR+QaiLdZ4sGjfwd55dzvvealaQF+dpbsdOM4ucTDcMdxSvSgheT4MiApQxLbd0Ws9tGqlv8VQZgweHHhYnCLae8sQN8E+Qu55ReYmk06udrK3I1J3HYE5voorokHnjlOaNz3PXBqi7s3TY2f75k/Ujp4LqN9KKDEQxOdmJqOUA3YpWYe82IfPUS6yoExEWUyEvghOMkn/JZ2jJqNcZgTA0z57eFc5oYd698KACgda64u30Sso2Uq3n16+F0DafuVmcDr3lvI34o4KTQwSanuthMf8EQmx/6xSN0fVAqW1mASJByAbZNjUzKb0vcVxPG7WZN4MSVfHxMvjdKwHx6ChwBwwVP83atfKwFSRJBUGtjwo+sgZYqLfBu1tABK4orgOM+dxFKd6mHVIrOcJSWq3CwN/OKjVa07WG/LT9VnNLWrfG5MphjR1BjhaAMLp7Afpj9ZjLSfkGlkWvSwT63pqy5IukfC7ZEXd5h0UYDmS0Q7hregokAXJDqXHRiXKa0P82w5G2UUPdvQru1Yr4t0By5p5/7vEE2Br6tJS4mpMc8aiYlOpvZxKQcU6YDUZNOeq4ZnVECq48RjbC41t0sf2M571jxxDB/mDzJ7ivJYmKmKQ6yPuZamTjNU6YgsffS9U6kqahs7kaLwnbcq687gkNY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000004eaf24063e0aaffb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Roman, Shakeel, Johannes, and all,

Thanks for the quick reviews and acks.

I=E2=80=99ve sent v2 switching to GFP_KERNEL_ACCOUNT in all three allocatio=
ns.
Otherwise unchanged.
Link: https://lore.kernel.org/all/aLqvzCiPCGzA5eYo@b7823f61de85/T/#t

If you=E2=80=99d like me to respin to restore any tags into the commit mess=
age
(e.g., Acked-by: Johannes, Reported-by, Cc: stable) instead of adding them
while applying, I=E2=80=99m happy to send a trivial v3.

Let me know if this looks good.

Best wishes,
Stanislav Fort
Aisle Research

On Fri, Sep 5, 2025 at 2:46=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.dev=
> wrote:

> On Thu, Sep 04, 2025 at 09:12:48PM +0300, Stanislav Fort wrote:
> > In cgroup v1, the legacy cgroup.event_control file is world-writable an=
d
> allows unprivileged users to register unbounded events and thresholds. Ea=
ch
> registration allocates kernel memory without capping or memcg charging,
> which can be abused to exhaust kernel memory in affected configurations.
> >
> > Make the following minimal changes:
> > - Account allocations with __GFP_ACCOUNT in event and threshold
> registration.
> > - Remove CFTYPE_WORLD_WRITABLE from cgroup.event_control to make it
> owner-writable.
> >
> > This does not affect cgroup v2. Allocations are still subject to kmem
> accounting being enabled, but this reduces unbounded global growth.
> >
> > Reported-by: Stanislav Fort <disclosure@aisle.com>
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Stanislav Fort <disclosure@aisle.com>
>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>

--0000000000004eaf24063e0aaffb
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hi Roman, Shakeel, Johannes, and all,<br>=
<br>Thanks for the quick reviews and acks.<br><br>I=E2=80=99ve sent v2 swit=
ching to GFP_KERNEL_ACCOUNT in all three allocations. Otherwise unchanged.<=
br>Link: <a href=3D"https://lore.kernel.org/all/aLqvzCiPCGzA5eYo@b7823f61de=
85/T/#t">https://lore.kernel.org/all/aLqvzCiPCGzA5eYo@b7823f61de85/T/#t</a>=
<br><br>If you=E2=80=99d like me to respin to restore any tags into the com=
mit message (e.g., Acked-by: Johannes, Reported-by, Cc: stable) instead of =
adding them while applying, I=E2=80=99m happy to send a trivial v3.<div><br=
></div><div>Let me know if this looks good.<br><br>Best wishes,<br>Stanisla=
v Fort<br>Aisle Research</div></div><br><div class=3D"gmail_quote gmail_quo=
te_container"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Sep 5, 2025 at =
2:46=E2=80=AFAM Shakeel Butt &lt;<a href=3D"mailto:shakeel.butt@linux.dev">=
shakeel.butt@linux.dev</a>&gt; wrote:<br></div><blockquote class=3D"gmail_q=
uote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,2=
04);padding-left:1ex">On Thu, Sep 04, 2025 at 09:12:48PM +0300, Stanislav F=
ort wrote:<br>
&gt; In cgroup v1, the legacy cgroup.event_control file is world-writable a=
nd allows unprivileged users to register unbounded events and thresholds. E=
ach registration allocates kernel memory without capping or memcg charging,=
 which can be abused to exhaust kernel memory in affected configurations.<b=
r>
&gt; <br>
&gt; Make the following minimal changes:<br>
&gt; - Account allocations with __GFP_ACCOUNT in event and threshold regist=
ration.<br>
&gt; - Remove CFTYPE_WORLD_WRITABLE from cgroup.event_control to make it ow=
ner-writable.<br>
&gt; <br>
&gt; This does not affect cgroup v2. Allocations are still subject to kmem =
accounting being enabled, but this reduces unbounded global growth.<br>
&gt; <br>
&gt; Reported-by: Stanislav Fort &lt;<a href=3D"mailto:disclosure@aisle.com=
" target=3D"_blank">disclosure@aisle.com</a>&gt;<br>
&gt; Acked-by: Johannes Weiner &lt;<a href=3D"mailto:hannes@cmpxchg.org" ta=
rget=3D"_blank">hannes@cmpxchg.org</a>&gt;<br>
&gt; Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable=
@vger.kernel.org</a><br>
&gt; Signed-off-by: Stanislav Fort &lt;<a href=3D"mailto:disclosure@aisle.c=
om" target=3D"_blank">disclosure@aisle.com</a>&gt;<br>
<br>
Acked-by: Shakeel Butt &lt;<a href=3D"mailto:shakeel.butt@linux.dev" target=
=3D"_blank">shakeel.butt@linux.dev</a>&gt;<br>
</blockquote></div></div>

--0000000000004eaf24063e0aaffb--

