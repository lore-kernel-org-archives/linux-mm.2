Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15BDEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 00:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D919B6B009B; Tue,  7 Jul 2026 20:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69176B009D; Tue,  7 Jul 2026 20:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F006B00A1; Tue,  7 Jul 2026 20:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 854D26B009B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:33:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0061F168DB2
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:33:53 +0000 (UTC)
X-FDA: 84963736746.13.B298378
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 31FC140002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:33:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RwrEaXIf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of eddyz87@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=eddyz87@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783470832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PPCHw1C4s9wB8+ak3IGBUi1NrCIfjVxm5EQeAbcpyE=;
	b=jvrYO+Ptl83Ae2QHS7VrcF/P9yKOJIJc9+Ve511DpKaZmh61DiVAsdqNsH0KcaMfcHnIqK
	BnqezBtyU7BVMFME+NCH8Sa93rt7tKvXFqSZQxV7sQRMJ6oj42uCGc8H7xEAln51v8Xm0v
	6ZvP30zTN1/dmldnomMkP/0B5jBYM8g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RwrEaXIf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of eddyz87@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=eddyz87@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783470832;
	b=Xc4Lkb46FCserz/B0XKDHm/d7gcH4qBTkiVNjZLkhXrR3KjGkI1XKrczMyqV/C4DttUE81
	PKy24A1ruzMBHVoXamxpp3xZiOY/qjjlOzg76zAohmi5J33Wp/HZXUvAD4TgastkunFvFi
	Zxtptma3moU7uFyiwIAw7lZut7bV9Ww=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cace91f112so1426815ad.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 17:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783470831; x=1784075631; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6PPCHw1C4s9wB8+ak3IGBUi1NrCIfjVxm5EQeAbcpyE=;
        b=RwrEaXIfnskEOBu3FyQezK8IE6zs8s/dBFdQfvibgVoH3S3752sUmjyIrYvzIu4Gnq
         4+PG6G5+YFGfjUySlOiVdU4efrVrGY2Sm/WYLs9RZnxtjY9/cy4Q9AzalUUPtBWXQT5W
         YlRAn/R+W7Bk/QhRy8nOSm1FaklIbI0zy+WCX4MFCzHMohVZ7QzqGo3DWZHmm7wlqzA0
         h3vY69dRjP2cB/vuteT19saS+DdEYHn1PwTRPpOFl45slJr3+6QrjegSJDzYtWcu0xRK
         eJ+heHTVZkP417aPoXe89H4a9+5ADiplYrbmCqCHPF6G52CyHLgg6aMJdPW4/2n8wjXn
         rfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783470831; x=1784075631;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6PPCHw1C4s9wB8+ak3IGBUi1NrCIfjVxm5EQeAbcpyE=;
        b=EuOwQoNP8ueiFf64W8b24TtGnuWGayGrYprpJvAEPzRO/hmKbTGZhcTpaJTfytKDK9
         DcpHEqvzUzAJtx1/B31bbf1l31b/RhrkUYhuEpjj3fc8Yb+73qens33dkVLdQQ4KR8l5
         XaDrywx6h3Tmc+DmQcGudmsUj6iO8+CXJr4vdIhwB/0td5S2hWQ1LRknLFLSEGvqxcMm
         JAvhTNtGFU4T5Q7dBWcoH3PSHdCS+mbOwGM2S35CUHLeC6O5Y3xfZYjr9aDuOts8n/ct
         pDdtD6ko1yynVXIXTutWkYaCN+Rnvr/j3Wmvx3if6liam5MxLOuukrd+x9HzIJqqHDQk
         hzIQ==
X-Forwarded-Encrypted: i=1; AHgh+RqNDl1LTwsLd3F64gR0WapeKtyW8d7HyKE2qRe+KCd/Pbky8VrF3WIxgObCAmL6qwsKdRru0ftpkA==@kvack.org
X-Gm-Message-State: AOJu0Yxp4NFYdekrU3WJtk4M2jBWDcZcexI37qzbNSpPnOm8INXX9TNO
	Tyu+PsIIuA1UPoHwmifysgNRIfy+6A7d1Zsjm0d9R4t3SQcIy9ZKYeQJ
X-Gm-Gg: AfdE7cnK5ljxOOP/QcdWqflGn5DjIf37WvoHr6XqP4ml5MsrvsqcdmlfIeUmUXIf2bH
	wEdOXTHscVYRA34DM1nmWd33rNb2obXLnz1tR0q0erbJi0Rm9l8E2RD00nLdVoMeQrZIoDk1Rz8
	GwXqTEjCqiSQ3D3I9rpdgmMEvySW05TzZDLatJ7KHbWiaZ4vqgcDyF0ujv6L96qXVpmPM2lGbQq
	F1j9J6Bz5pMWpqcoaJX+3laUJSk5ZMO9SK6nsLE61qltKJzrMDL5DdwobtRzMePT6hdNQymuHhz
	0LAd/7NczkbGR4FnV9gG6O6jLf3ve3fUrALRk1uSAr6hSVP9wRDvtAO555vu4tOMAfAHUYSQ1U/
	yZkE2qUwrAK1Rv9wpjSf/SsB2wc6cSXIke7cW74NgQk2pnNksSZOCElXSCud5S9dwZnhRYho9YW
	UbD6dREzIoHefvu810Xc8KMFVGH4IbV6N0jptXBeruNvutujtgppN7JX1xskOZFnQCgMGBUzde+
	7kptziG
X-Received: by 2002:a05:6a21:7706:b0:3b3:1c7b:ff7 with SMTP id adf61e73a8af0-3c08ef16b7emr8743089637.46.1783470830910;
        Tue, 07 Jul 2026 17:33:50 -0700 (PDT)
Received: from ?IPv6:2a03:83e0:115c:1:f2fe:14ed:44aa:14cf? ([2620:10d:c090:500::2:84e7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b659c865asm13266118c88.11.2026.07.07.17.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 17:33:50 -0700 (PDT)
Message-ID: <030dc01fa51430f4ac27d3f4eb4a6147322cb51d.camel@gmail.com>
Subject: Re: [PATCH 0/3] selftests/bpf: compare BPF and memory.stat memcg
 stat readers
From: Eduard Zingerman <eddyz87@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Ziyang Men <ziyang.meme@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
  Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Kumar Kartikeya Dwivedi	 <memxor@gmail.com>,
 bpf@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,  Song Liu
 <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa
 <jolsa@kernel.org>,  Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan
 <shuah@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	kernel-team@meta.com, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2026 17:33:48 -0700
In-Reply-To: <ak2Wpk6OnhTyon65@linux.dev>
References: <20260704045617.487664-1-ziyang.meme@gmail.com>
	 <bc12730fe6eccde10d36e6544607ae2464357e05.camel@gmail.com>
	 <akxW5dzvR9e2CfGq@linux.dev>
	 <eccfd9a8dd1af1668e142b9b866194333647b0d5.camel@gmail.com>
	 <ak2LXDWoPFSJL2Q9@devvm16600.scu0.facebook.com>
	 <bc47c75a00acab57e7fea72612e0f6f089ddecc9.camel@gmail.com>
	 <ak2Wpk6OnhTyon65@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
MIME-Version: 1.0
X-Stat-Signature: 4du19wr6of4ppsu97tst3y96xneg8qid
X-Rspamd-Queue-Id: 31FC140002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783470832-132119
X-HE-Meta: U2FsdGVkX1+kQ0/kT0LJNZ1gYb5XbrLHysIh02x0RMjb6p2iKAVKS5NGStc3VBqHn3FBMmKNcDfFkZP+VMdt8M4WgIQJukz88lUIBDbdS23HD4oCa5Pd9OhZkTnCmRZVjI2XuLcW7lMxxMhX2J/x5qMpWcQjYGYIfse7HJ4Ge9hxTvASjB8JyhfsNourrHpRp/4wCFCi2N0PUt/sJTQhARTujsWKgiSaaNUMrpy4Z7f8V38RGpRuBhzgFwp6kOU2yc3NhMZVo/Qkcj/rfr1aiZoVHnWR/42FwtSJgw5JEZ8VIysF6T0t4XxeqsNUXjib5oLmnIXQn5DMLDR9Iwm0K2J/NXTQPkLvoESVcmZcMYpjRSixFVLrhYcICxmvyqufYZsSGyxqga9q5Q5nWTifkE2LSWbeYstID8KG7SRgTXMXv7wtwE6bO3P4buSq2eJlTaeVmJiLylKqIGrc+s885cBs7VyCbaGR0Kgf67XoIw3k8aDkEnkQXBcE7EeEDv4WnPSP4ejczcHJeJtbAKISeuHr/3qrdpqzGbj8HyFHCuG0n147TP8kHG6imaOmhoMIa8A8djycKQ2UhHmYXEWpqJsF83B6M2k5K+ZG0y84cbcGBqFv236DPpMqr6PWT5mUeUOUu51+aYyZu+/8SkmdalDrorM+/qrReKcd0FomjKVQyPBhxL+EVsy1KN1xGcyw6jEwv8sd7X1Y30bsLSXUwp/r6DgjSdeI0kQqEAM+D/kCffDSTby9zfLplPpmAMvVXuGTPiE+Vp/MVjcSSmhvwND6G/yqnYdrtSD7CqhsnUh7jrtEVgtcpcRKy4KbCQxKYg9J4dkC1o1vH0F4lz7XvVfqaNWnCKa8hCkKLPRq099pVu2cMjBMSt27+lapykhDtOYlfkgVa+tr7i1KCdXMVkDJ1V5EHPUg1lIC61abneb5ub6nt9+eCeRop8v0y6v2CK+qd8EjXmav7mJw4oT
 4kC+XkB4
 PsR1vW/OoTRYIIpBYzSm5hBrVrTH3xt1fCWUnOqZy/YtZTQxjy9ornV3lMIs7Qnwvyf3JfXraLs+Xw7mrmcIEnxWBMeVw0TUF/7r8sj8DJZ/NSSKcazcZGAnJrPhKoY/95e+6U9HupWxFN9FNVEIAyy4IafaPw3IGXSjRizJ53kPG/H/tTtoIVfjtEM0eeThzx4ZjGavHQgT8e+78rAgcUZc9/4UMItV0kP5Tk1uAeORUliHY6pZbCB+gR3BwmqsCmQmESUAIW478jzrazVR8n+YHRsYvFIH3vg5AL6NddbqMj+WTPmi6v7y5iCrdvzNV80PLsbP0rz3erAMuKGcj0zY6SD9hSRT0GoObx1eAV/vvBLaIvK5g/WRiz2g5F5tLoaf6d9Mk/aYakmYOiqIkTEtmjfYkq9zTW6s/CJHIQxFJY4mYqwceGb6WS9NQFr3dArQOwliOis3rXsFYrE+fThlrZWyF3aPQz2eIdIa6CO0snvUpYQqdfA6Us+bkeXKbq/orJjhhmtZzwiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-07-07 at 17:31 -0700, Shakeel Butt wrote:
> On Tue, Jul 07, 2026 at 04:50:11PM -0700, Eduard Zingerman wrote:
> > On Tue, 2026-07-07 at 16:27 -0700, Ziyang Men wrote:
> > > But the patch also carries functional value: alongside that compariso=
n, it
> > > checks the correctness of the stats the kfuncs return.
> > >=20
> > > Let me first answer the main question -- what these tests add over wh=
at we
> > > already have -- and then lay out a plan.
> > >=20
> > > First, the static test (memcg_stat_reader) vs the existing cgroup_ite=
r_memcg.
> > >=20
> > > The existing test calls the kfuncs, but for each value it only checks=
 whether it
> > > is greater than zero. For example, in prog_tests/cgroup_iter_memcg.c:
> > >=20
> > >      memset(map, 1, len);                    /* dirty some anon */
> > >      if (!ASSERT_OK(read_stats(link), "read stats"))
> > >              goto cleanup;
> > >      ASSERT_GT(memcg_query->nr_anon_mapped, 0, "final anon mapped val=
");
> > >=20
> > > It never checks the value is actually correct -- i.e. compares it aga=
inst the
> > > value in cgroupfs -- only that it is non-zero.
> > >=20
> > > Besides, it also walks a single cgroup:
> > >=20
> > >      .cgroup.order =3D BPF_CGROUP_ITER_SELF_ONLY,
> > >=20
> > > and reads only five fields.
> >=20
> > Arguably one of the the cgroup_iter_memcg.c tests can be extended to
> > allocate some mem and check if the value is reflected in the stats.
> > But there is a line between MM tests and BPF tests.
> > All BPF kfuncs except iterator logic itself are thin wrappers on
> > top of the existing MM functionality. Hence, I don't think that
> > BPF selftests are a place to stress-test these things.
>=20
> That is actually a good discussion point. Where does such kind of tests (=
i.e.
> testing that bpf based memcg stats read functionality is equivalent to
> traditional memcg stats reading). As more subsystems are exposed to bpf, =
similar
> questions would arise more often.
>=20
> In this particular case, IIUC you want only tests for bpf related code (w=
rappers
> & iterator) to be present in bpf selftests, right?

Yes, I think this makes most sense.

> Personally I don't have strong opinion where this test should live.
> Functionality wise as it is testing rstat infra, I think cgroup selftests=
 might
> be better home for this.

