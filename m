Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12924CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 05:23:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9057A9000F0; Thu, 14 Aug 2025 01:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AEF7900088; Thu, 14 Aug 2025 01:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79DA39000F0; Thu, 14 Aug 2025 01:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 64A1B900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 01:23:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D21F8830F9
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:23:15 +0000 (UTC)
X-FDA: 83774219550.05.46866D4
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf08.hostedemail.com (Postfix) with ESMTP id EF42916000C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:23:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TEZcLb/o";
	spf=pass (imf08.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755148994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LSoCl56fyWME0v8PiSkctUuL3gtGDTjl3bz0icHfT8=;
	b=1T4OiWlyNd15MXsopUw9i6IeiTJalmIEpTtSom58ccEBvwOTage77ilqjtAsrnEQzHh1KN
	r9U+kD6kiMJRx7QSIo5HJNhEoymBFR0EcLuu3xzWt2BqmNoyfiZaEAH109VMxDVdVicE/N
	6psHB96qctM7hg3YBJ9uc5P0PUqUt8A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TEZcLb/o";
	spf=pass (imf08.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755148994; a=rsa-sha256;
	cv=none;
	b=nwnJo+9DsZFVE5UAQrvjlfDZLkOkq8iVTu4rG9AdB5On3LeHATp/rufb9mhxMYJRpzsvFZ
	m1hN5te7ktLWCwK/bRrQmIHWZKT3rD326QLs5Wf0vqSwPFxb0DI8pEeJgtnCTvseKFxiUl
	8We2kefb3Te4tJ/9pHn6EVMFaNOxn4w=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3b9e415a68fso444814f8f.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755148992; x=1755753792; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3LSoCl56fyWME0v8PiSkctUuL3gtGDTjl3bz0icHfT8=;
        b=TEZcLb/oD9g/jLFeEEiP9O2HtE1HcAp6JqlNGpBJxiA6hXik6wc2BkY2dsDKB33892
         S4CEY7NoX8Srg/3Zk66AdpDt4EQ5TMVGlIg0rjhg3DU+TGU0GQN7y3y0TUeqbSl5K9XS
         jq7l7HNEZXnr+rSM1R+ezI/HDovXieIw+xZic+AGIYXbs3pGvLN8e8OeXmF3UHi1wqqQ
         BczsXN/qKbixNx6QQd/WQkkCL+WsnEqbcgKBGHaUpQD7EniUxV71FxXin+OL5ZWeoES9
         Y9Xm+PszpgZaGXTRPuu6QghNTJTBX8g6U9XP0+q+ENt/gCzjTbTMg8J2bEGableCAQud
         uJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755148992; x=1755753792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3LSoCl56fyWME0v8PiSkctUuL3gtGDTjl3bz0icHfT8=;
        b=O6Hpqmp4eA7mtIKhcE3bcAY4EeXDzLF4tm44PpbJzhRajeoRYb3cI6tTPjLICdTq+Z
         O159btXnx0I6OPlAUSemF8ni1UlTDM10tcgHEzzMD0mDp9pkE3ZFhliRlFi2n16kPngw
         PWIp3RxzJy72CrEMloGewos8iu+yuyLpZLMZxwHuRVq0DCLYCNMaILt3vQjGuETl2bhk
         zFkcabK6lSXsbcqZKqgjxOTW7hX/1epsi4uNljYTC0Z3WK24Ytg6FxU5LVDyzi8auu0q
         v4plXrXmq/px+07YEcgjV4JmHXrGoDelepTodxvp87zquEBcf0exr39lOGSafLloHGyC
         WzwA==
X-Gm-Message-State: AOJu0Ywp1AUjyr60sWSh+GRsDL+Uof/SyuGbURp2o8mwmbu5bmjlZo9y
	GL/qK4/XWCkIgMNagGFHzvaQBNWlRkOSgLkl36dUvaUPVM0yYT2nybEDzguIrKBsExf0Vvw1ySh
	l8GotrwUK5dn5iqaY44fpWsbY1jZ/Xco=
X-Gm-Gg: ASbGnctmQ7v5rSXLxSkKN+fS+j4nUIhzK7rsGH5Y4EgmBcmT4RbzTVI9MQANDZgysfr
	kxByhNYyaKCIsU8j1tp0UkVGUoYTz+CIIMJXLsVUIWmPfYsDPsqX9RfeYIab74yhmtPfD+D9/lE
	zNL0PTeitbZ0FOYpx6//BzW9gmf/PZ+kyZsxQiwxKiloHMBsZSCa25/UiQ6/TwxlLrkEuWhaMkY
	5cJxhOcnw==
X-Google-Smtp-Source: AGHT+IG3JLfHafFtVhrpyJJQVLI+yi2yjJjHCa2aqw39VKsfuinwVVPCl+kdFo32hMLPEgR8b1e3VmqLD+4/eg8BBs4=
X-Received: by 2002:a5d:5d88:0:b0:3b6:8acb:a9d2 with SMTP id
 ffacd0b85a97d-3b9edfcd141mr1235453f8f.7.1755148992352; Wed, 13 Aug 2025
 22:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250812124941.69508-1-bhe@redhat.com> <CA+fCnZcAa62uXqnUwxFmDYh1xPqKBOQqOT55kU8iY_pgQg2+NA@mail.gmail.com>
 <CA+fCnZdKy-AQr+L3w=gfaw9EnFvKd0Gz4LtAZciYDP_SiWrL2A@mail.gmail.com> <aJxzehJYKez5Q1v2@MiWiFi-R3L-srv>
In-Reply-To: <aJxzehJYKez5Q1v2@MiWiFi-R3L-srv>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 14 Aug 2025 07:23:01 +0200
X-Gm-Features: Ac12FXxjjLGYLRyCaqd7TSTNKQmFZtITu9sph-q46cifbE2W4uXByRYl8-gsmGA
Message-ID: <CA+fCnZfv9sbHuRVy8G9QdbKaaeO-Vguf7b2Atc5WXEs+uJx0YQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, sj@kernel.org, lorenzo.stoakes@oracle.com, 
	elver@google.com, snovitoll@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EF42916000C
X-Rspam-User: 
X-Stat-Signature: 5g59y5f5u5bqbws6955hka587i1ep3s8
X-Rspamd-Server: rspam09
X-HE-Tag: 1755148993-121081
X-HE-Meta: U2FsdGVkX19kazM7P5QdATx/ukkWNpOLCZKy8wt5i0/HqhfkXEzqsM2JeJMN9UXQutD28HNYxAS0IzGYtyykmkcJrRelBXeDd5wBXtKdn8GaRf1qBeGaChEoOOxjR1kneaepsbcJQCgybQ2MaQxn2HlF/g1ZZECiGywRU/OMHsna8qi+PoKmzy0gzymqzAz50IBJP/RhFTwU9uvFdwdi2xyGOwgVDZtmBUIcwWi8gP1himsvYu1uGixZTnp93XymNCwob9vfz/pHxSYz8zaHxTKHbg9qCnzXkz+N85BJ3y5PKB3f4TWR/HDEhULolkOlsy6ws11Gef2ycfU1aJ6pyJ55sbz9x1FUEVaQYLZ5q9inNbLPPMkB+LiOjvC3LQ0s0xo8Zb1ETnjir11f22IWZrMC/Y5ROdAzi7sb3A1MfOimFMtD3McMRKLrSIjkSpSCpFrux3jnScFvCCmH9JeHcMkSZYTtZOS1C1BIBC5rebEMbsFXPu9AM4YBByr+f+4HYprJ5ERagjM10LCvCixsJhfoSCBFE8Wpj2sFT4W5hpk562A5BXTQkNBuuiBBA04yvXkZ/Hne3DsRVMUCXHmnrRg0Z+rDVC3+qIpsrs7D8w1Vbh58KMaC7aJrgJi4QKNVfWgYlmoQFn3R3siznQBbFhxRcwfUmDqkM08KK3e1ZMQ+MadvBIS/cJzMBOSNEicovPedwXGXU8yHK+GZ/xj8HrdCUnSRQv0WErHLCdA+a8yv53QRmRYjgSV0X0OTpeyS2C79j9bF7m6Lyc4ObJ8A3OjU6OGx+8xdHdxtKBc+kSqaVuXU2uvTYi47GtXovIx9q/OVM2dhfu2kFldrxvu2D9m/1oefn1R+NvyQq+1XcE+mC62t1EAnAcSMZ1CSr/EZ3DA/1pityCqQxM/TdGk2O3skqWuugFld7MOGIZUK+XP+rjSgD+AXGeZcTQuR+OaYm9MG5hp879tQv1pZ0Lk
 zOajbvgG
 r8Bpe98B8YaprPE3zzciSzkX25IFdQIXOzbPt2QQEHAWy93Mv27mmyqm7gG5n6i0n8W7MXZP/ozDcCZCkzpEjfnv+3iYJ7nLbTSwbOf/heXdezX1A9C+L7QzvcKbKXqF9z8oz6n5/K34BSD/3oTj7zzceAmeg8OeKjZuyrs9e0rR0ddYYPmclypHVs8BCLDrWGe6xMrBwKye+DuOAT7rstI9r4NMN/4rA/ZRk55Y/sxtkXtmsizfHuZ913tWcIJBz9gGQtftT6C87PtTYos9Y0Zjhboue1JkL/0qudPdE2+3PLzqM2mUO3/H+dFTSGxJnPXUKIUR1uZXKPs8hQO9BTbA+2o+WJSFfguhq6lzMhmQrSwUk97UL51G4lsV0Ik+GKQpXn+GNvab0NWhoJXN8uuWtCzaQrw+0kWKQprcjRbSCoo7aEIKTe5HWsdI10Wl7dCn5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 1:14=E2=80=AFPM 'Baoquan He' via kasan-dev
<kasan-dev@googlegroups.com> wrote:
>
> > I'm not familiar with the internals of kdump, but would it be
> > possible/reasonable to teach kdump to ignore the KASAN shadow region?
>
> Yes, we can teach kdump to do that. Then people may hate those conditiona=
l
> check "if (is_kdump_kernel())" being added in kasan code. E.g even
> though we skip kasan_init(), we still need to check is_kdump_kernel()
> in kasan_populate_vmalloc(), right?
>
> Combined with the existing kasan_arch_is_ready(), it will make kasan code
> ugly. I planned to add kasan_enabled() via static key
> kasan_flag_enabled, then it can also easily remove kasan_arch_is_ready()
> cleanly.

What I had in mind was something different: into the kdump code, we
add a check whether the region of memory it's trying to dump is the
KASAN shadow, and make kdump not to dump this region.

Would this work? Would this help with the issue you have?

(I assume the problem is with the virtual region that is the shadow
memory, as kdump would dump all RAM either way? If not, please clarify
what how does the "heavy burden" that the shadow memory causes
manifests.)

Thank you!

