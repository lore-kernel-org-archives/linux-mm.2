Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 205D9C44507
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E17156B00B4; Fri, 10 Jul 2026 17:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC81B6B00B6; Fri, 10 Jul 2026 17:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB75C6B00B7; Fri, 10 Jul 2026 17:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A44076B00B4
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:00:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 331751C8AF1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:00:55 +0000 (UTC)
X-FDA: 84974086470.12.4DD98BC
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2938F18000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:00:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=OPXT3iHA;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783717253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqzV29M/TfqY8poEDBrz7krImCgB8mIlNT5MO3ZgoJ8=;
	b=fQr5SxffBbcKyqg3F7Fir9vzD9tyRqtBo1a+ieDhQJkPTLVcoUngXqv+gH5BmMClv/zfu8
	SsZ/6Mj3ow6kUHEMolAqZcMN84Q+erBnBa1YpQfABdkR1tyAO9xr7yl7/eV632r0AZLldJ
	6e0DWRwlJ4QWabGl5W9rH5Ulsv+iQzw=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=OPXT3iHA;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783717253;
	b=WuJjPoqmNbcOiE8ngaKov/EC60dEgHzlsw1Adqz6joEHKNDD/z05sYS/Jv3nbBKPowOgca
	jr/7Hjtr8BwrwEgUfYzXR0BHagyj+IUheSVKkZf4YxAmB8U6uOL3WOyEIOyAXhJ80DQU6U
	sa72gSoQZ1q7klsFN8h+86Hs14nOL3U=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2caced6038eso16468455ad.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:00:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783717252; cv=none;
        d=google.com; s=arc-20260327;
        b=JqcNbMfSL84UVCG0cTeniqNOa/jOAwxk4UP+W6SzQq9VEDwkSAXe7JbmRClx9Cxstc
         7leXOYHfa0U//KYYq0tQ5KGaQCATbu30TTJhDs7xhLNx3MWvxZTo/OHHrWZ/rnY+sRJ1
         FKx+Ozdn5qOYuvg7aS8Z/OBfIKUcMO7+oy/WYFJPKPbBADI4+slsZo6s7v31W3cD+kbO
         LW/qStpVEcniLxeU3c2zoBak3kcCUEzJtZXj45iBNI5joOiJQDgP64KN4AW6VF4M4D7b
         UvgmF4FWRX17hJg4YdJ/UryLh4JWGwM54r6fp8v17n+ibkmeCw6VWxrSqIpIYDPz+MYw
         sQkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rqzV29M/TfqY8poEDBrz7krImCgB8mIlNT5MO3ZgoJ8=;
        fh=s5C5JXIj+7XKx/XuRrDLHEj3N5Iw9K3SphbMBY6SxpA=;
        b=EmBXmVIBpGT1ZOLUeHu2KaU//T4v++A1LeHrOEW+5vA3bNupILH+DcNDRsd29z5VOo
         HJo39x+sGmdmMkwNx1x2u+KolLBfReskzUQCfqAOmSAeORo4ZnSITmKALmxGZKJgX20+
         oVUNuZCVQgG6cJcVMGlA1UWehJDDhVBkC0wSsO9/8NUJM6FQ1i4/n5LYmq0hetpTvEns
         D1iNIEPC2GHo8FdxPsjb6IisoOZSy9DBliNG+B2UEmjRzgSoZMRQqAYFQM9/9hrkVcBM
         tFAOvhpLl0K+nab5fIeNJwXxtVpnodH250hxNKZs99vq9/9w1FkSlowF0J2xGpFxBGIv
         dvvQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1783717252; x=1784322052; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rqzV29M/TfqY8poEDBrz7krImCgB8mIlNT5MO3ZgoJ8=;
        b=OPXT3iHAHZJkOVmvppoNoQehQYcGw81IKqf3/nFp4FNMcaObREnHFELsjGIe153Dwo
         5ecF+qcIp5qmYsxlYkcYj/8WchfheKuCNsUuAyfRtGCPnuXa6jWCpT2/1k19MYEXDkqf
         EDkowoZT6LpaTHmv1Lft9y9OJq9h+lIoNnGHWFGxqmOmsjLYM1elZFgkJmbx9PPI/eSa
         KAcnZlEyvaJuMrJuTBPu7Lgl0mgXTIOtOwLFf3FbJpVBdWzHYZPKSti9NBzZCC3fdfF1
         nLnnxz4UYScAuvQWollbkwhiiCUq3bBuJgWtCnzZlToK9iAP+FIvxxAEgL/IT/QjTOAR
         1ekQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783717252; x=1784322052;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rqzV29M/TfqY8poEDBrz7krImCgB8mIlNT5MO3ZgoJ8=;
        b=fApgta6Eko2iPyWYn2t8vJZNBVrSbHC3B1hi5wvMFt5LLeh4wqzTatshEAQmYOPpoJ
         7X+2f4oc23MtRbsPz1iWl33HJBZXA7gXPyiGiIWIkTRTYTTdin20/uHkHALW06P41PH6
         aUvMAJHFKoOLUax4GaAWB4/HO0xOodnbOzGgxOwH9t4LJFchGwHdbKIsYnJV89N++H2R
         5b5CjiU9tnpmXYK1/XmaoMazwug6oyIxt4Ulh+Qirn1uC6dU5OcS+auC9A3LO2QvCvWQ
         Z42YHoWCtUy2JEXX9mgpFrhYzTNSBKA4KBjtrFE6eJEjL4FkEs86XrOYCxz+VQ5gbMSx
         M45w==
X-Forwarded-Encrypted: i=1; AHgh+RrLn9kk8Db6Y2o5Ta6vlC9QtnA3hAJr7TsJKJxlYqFbtabmIv5kYWpCwOstHQjqnrS868gQyfkOyg==@kvack.org
X-Gm-Message-State: AOJu0YzzSLk0WkCNVW4+lY/fhHA4dh5sPLigyzRQ2SVhAUP8ALdwfzbs
	lBWwO/AVVnWD/0akzKocFvf4hHMZLwav5U2EsFEMFnU2G/7pIShTPahuiSHQVds0v+QsG5Zoku7
	9c0roSuG6FRHGe9U6QOgjYXrXhF8IT1PU3+G1s5Sk
X-Gm-Gg: AfdE7cmQ39j0QH0qBBLxWteYSlQoDXw1sLpTOXQGgb7zx/ZkcpA93Z3jqI13v7UP5hH
	h3HNXJCTimlM75r/AeYEVGadKlQ5U77S+SZq3xVcFUeW2k00d3+DIFVdZoZEsYcxzIdiKTFj0lz
	pueNedmDzsXR7k6q74qvyIRWnR94UWym1i+SvUtBIWsr3NrVw9D3SjH3H/fXERMW3gW9GVOY8lR
	xGeWanVZNc8ejSu3Bmk1o/92JdPGCQ3SUwpmrdk1UN9yKx9RrJQrxPl9rWCuW9LgCWDF7FW
X-Received: by 2002:a17:903:2f82:b0:2ca:16:c169 with SMTP id
 d9443c01a7336-2ce828a0820mr40343645ad.12.1783717251507; Fri, 10 Jul 2026
 14:00:51 -0700 (PDT)
MIME-Version: 1.0
References: <MZlCECz5s73hPgQxtqWZ2VbXNTCZnItnwMHu2iZQlRC6ba0B9GuqxT2EhvhwQ-uanBDsNn7Bg09nGVynBHdmSsiRjhyI1udkYbqOoPfpe6w=@proton.me>
In-Reply-To: <MZlCECz5s73hPgQxtqWZ2VbXNTCZnItnwMHu2iZQlRC6ba0B9GuqxT2EhvhwQ-uanBDsNn7Bg09nGVynBHdmSsiRjhyI1udkYbqOoPfpe6w=@proton.me>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 10 Jul 2026 17:00:37 -0400
X-Gm-Features: AVVi8CelOVkwsnAMfu5Dx1B7_PEB-pnfELgYLYT_dts7Hvyr4wbqu6SLxvOLeqA
Message-ID: <CAHC9VhSWs4=-BN09XWUsJXh+9HB5zeYa0oiRsRNGb4s_sTW2HQ@mail.gmail.com>
Subject: Re: [RESEND][RFC/discuss] memfd_secret(): opt-in visibility for
 security monitoring (eBPF/audit)
To: BoxStrikesTeam <BoxStrikesTeam@proton.me>
Cc: "rppt@kernel.org" <rppt@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, 
	"jmorris@namei.org" <jmorris@namei.org>, "serge@hallyn.com" <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2938F18000D
X-Stat-Signature: b7tei6h6395zut84xaowu77uckjsc5ip
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783717252-527994
X-HE-Meta: U2FsdGVkX18Tt6O8KGaufVOiUQtNC71pPSk83fKRJDcwgRSzaLt/M9hKynYzvNXP7Zn/3OiiJ1GUJN544KUsWsD7NdzZqEJPo64bcUsCgJqtL8M+K05ScXjz4YoKL6HnR30DD6VeQ0q5VQ97LxoF0aFSx6KgwAVLYiXjS1ODBPC5jazxJkosJvrzQiBtZbTTryow7wcS/7BTwAmKMMrVtnaE3VUpa6QdaqniEd6FxspjjV6+UZcx7edB/vNcRTZcS/Q/IZJQDHIn10amosEaS0DHv+ARxYXbhm4/SfEcMyGDa7tCFDrFROZb4tz9z/iOs25pq/JityLUs3DGQvEaDKbR5w9Pt1rXvZTz+K1P7cQ2FQRYxs+fhN/L9zVnxkR+DD1OaTWDdFlswJxr+nTTpSprNIwEl8J8ofWHkp8PqeNkkIZ/yQYylknBcSyRNnY5wnjZ5hm7v7AJGzSaQ8utmNI0DQTzELTsFyzNDR+JfIy4VLyJDmuqvxwol5Qtx/8RIQIcYV9g0fZobJZim5cEsrjtRkc7B+ahikY7Uvn4FduMzgsV8SNBiwYm6D0V32+xkUJUQ9CESh/KX0ydhZD1J0DVaPDwa+L4tMvKwWRJI9q1vVWqdyvHqfMW+8VM4ZcmWmnXrwgVThO+wgsaBPymeRR9t1MMW1nZnY3EqMTqhZq/nEfz5P5QE8E61uMAY90DinWWrTFckjrbfXTlR5SVFgawjsNBoy+IuzICyWww1onAgNoO0u7278nwZqzc4nrTLRLUK9QoIYTlq7rvuf65BKDp1r6yu5oYC1LNAOmZSGouP1ygsOlW2rtXsEvfEnjdY3pO/qtTKO8BCmWHKrFHd99V8RYJIDlEhG3cTaI6Ib8NbT+SwFKC2iOF5CDEF+Frr1QTq4mTwccouhgY0hboYrDJ3QGmGq2XIJjQW9hAnYQP6WCU4DIfY5BeZsXf5356sn/OZMTYoP4jEBaitZl
 hC4488G0
 dL8Zbgl0X/4WmWYXNccbxhaLfpFQ6bsg4qSLP+bQNDgpFD8+YkDa7mIgQ0yEs86+Qq7dELchcxCJT35zt7nTF7S1kWxTCVNLkeA7FxDoyzOjyNhWYf/ltc5ZahQlIoCyyEWrUREdJY4mvzGCFcKHeLpWqYSzbewyrvBs64xLGrqZl5qCQOMpMwZllr9YFWq7wvBzq4iwqp2w+HCLlVMDgSVD+tYKiXDkhXiNdVfmzUE9OdTqCRbrKYLOhw1vmSYrlHURKmNl05Df+vmhLWzw7kV6CG2SFwsC25uzQCPr5y8gHuTSOznNc+tWKjDaGcIfRX9ilb4vZns5UIEEDzUOrWFMx7Gy31oxy5201ML6uR2bdE7p18cbKYzHVoHeITKXr/Li8s0f8KByC3/NQFM6skY2CNJBWvNW8xUcIp9P7FJAdFU85MKmKx8GmpW9Ia5UXOGvrEA+OK9wL/BsgKMy+2ZOGig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 9, 2026 at 1:14=E2=80=AFAM BoxStrikesTeam <BoxStrikesTeam@proto=
n.me> wrote:
> Paul,
>
> Thanks - I found the Gottsche/inode_init_security_anon() thread and can s=
ee it landed. That answers (a) cleanly: labeling exists, policy can be laye=
red on top via SELinux/AppArmor if a site wants alerting on memfd_secret() =
creation. Good to have that confirmed as already solved.
>
> On (b), let me push on it a bit further, because I think it's worth spell=
ing out explicitly rather than dropping it.
>
> My concern: as it stands, an unprivileged process can populate a memfd_se=
cret() region and mseal() the mapping, producing memory that is (a) unreada=
ble by any kernel-side introspection path, including root-owned eBPF tracin=
g programs, and (b) can't be coerced back into an inspectable state via mpr=
otect/munmap. From a host-based detection standpoint that's a blind spot an=
 attacker can use to park a payload where a CAP_BPF-privileged monitoring a=
gent - something that in most other respects can inspect any process on the=
 box - simply cannot look, no matter what capabilities it holds.
>
> I understand the objection this invites, and I want to address it directl=
y rather than pretend it isn't there: the memfd_secret() man page is explic=
it that its ROP protection rests on the absence of any in-kernel primitive =
for reading this memory. If I'm reading that right, the objection to (b) is=
 that adding any such primitive - however capability-gated - re-creates exa=
ctly the artifact a ROP chain would want to call, undermining the "no primi=
tive exists" property regardless of who's nominally allowed to invoke it.
>
> I don't think that objection is wrong, but I'm not sure it's fully dispos=
itive either, and I'd like to hear the maintainers' take on the tradeoff ex=
plicitly:
>
> - The ROP threat model assumes an attacker who already has arbitrary kern=
el code execution (they're calling kernel functions directly). If they have=
 that, they can likely already walk page tables and reconstruct the mapping=
 by hand - the primitive removal raises the bar, but per the design's own c=
aveat ("no 100% guarantee"), it was never advertised as absolute.
> - The (b) scenario I'm raising is a different actor: a legitimate, privil=
eged, kernel-mediated monitoring agent (eBPF LSM/tracing program) operating=
 through the normal verifier-checked helper path, not an attacker executing=
 arbitrary kernel code via a ROP chain. Conflating "any code path that can =
read this memory" with "a gadget a ROP chain can call" may be overly conser=
vative if the new path is narrowly scoped (e.g., a new bpf_probe_read_secre=
tmem() helper, verifier-restricted to CAP_PERFMON|CAP_BPF programs, opt-in =
per region via a memfd_secret() flag the owning process must set at creatio=
n time).
>
> If that distinction doesn't hold up - if any additional kernel-callable r=
ead path is considered equally exploitable regardless of gating - I'd genui=
nely like to understand why, since it would mean the confidentiality guaran=
tee is fundamentally incompatible with any form of authorized introspection=
, which seems worth stating plainly in the documentation for anyone buildin=
g EDR/monitoring tooling around eBPF.
>
> Even if (b) is rejected, I believe explicitly documenting that memfd_secr=
et()+mseal() creates an introspection-proof region would be valuable for th=
e security community, so EDR vendors can adjust their threat models accordi=
ngly.

To be very honest, I'm not too concerned about out-of-tree, security
products; I'm focused on the in-tree kernel code.  If you are
concerned about userspace making use of memfd_secret(), you could
block the operation on a per-process/domain basis using either seccomp
or SELinux (other LSMs may have similar functionality, that's an
exercise left to the reader).

Also, it is important to note that if you find the kernel
documentation lacking in a particular area, I would encourage you to
submit a patch to address the shortcomings.

--=20
paul-moore.com

