Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE92F33806
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 06:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4726B0005; Tue, 17 Mar 2026 02:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56376B0088; Tue, 17 Mar 2026 02:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C446E6B0089; Tue, 17 Mar 2026 02:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A98FD6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:44:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD780C2023
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:44:01 +0000 (UTC)
X-FDA: 84554615082.21.291FC99
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id B8ADCA000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:43:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fnsxDOMN;
	spf=pass (imf15.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773729839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GxQBVRRKByq6v33EyBsLpkYv5kgyt0VBov8tr6iRv2M=;
	b=TOpUfbwwFVzqO8esEgv5T4EIv1X26jw/DhYa8u690Hp4m73pGr65huB+lD84IJiRukEDgV
	S/YcQpS/ptUfuX+2+G2Xt23kf6vkny5ISkM64Mv17LFcZGEdvWrVkl75h7YTdF1fTuow7o
	htPQ52SjSRFWWDRWs2TrgsGPGBC/z5c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773729839; a=rsa-sha256;
	cv=pass;
	b=lqZfAKihauNNuLuTxfc7yGZYUo5WHLKSn22HOsBYkLKRdrF+XRFW0i0CbkiSfu92wbalLM
	H/Fj+LPFkOnK9r0j583qIM4wPLA6ecrPKu1HpQOPQGtybdbKmKkqb0yN0AWrX1XxQVXn5W
	zQWqSeDvw8gzoCt569YxThrv+WHbjZg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fnsxDOMN;
	spf=pass (imf15.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-38a2fb8ad36so3436291fa.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 23:43:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773729838; cv=none;
        d=google.com; s=arc-20240605;
        b=KCjO5TTze6SQ+qxJVPTJe7m5ojwWaJaJMYlmIq8ODNfY0yf6JEPP3cEewK3GghXLew
         099rEJxYZaRI9wp+vHzEHzGAbs6h4DBe25Fo3/k8uOE7qW/B0zYqKFSaC/ig29zGNv6J
         yUmd4yiYSKCF6+gcjpndh2GwTrfJiLRJwmjR5daW05la42dNam+fiZcPkftzHFzBARvx
         Wasgx1nQaCOfjqtoNlWY4RvaMKswi5mc1FDEsgaVdJOYbb2YuUZ2XeO62K39oDRqPdYo
         IMwdFWu7Wd3Tdx1FcQ5vnRS3ZEoxNDVNGLlZxrMLE2IiKZQumHpqCapCvjkK9V4nPAia
         olOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GxQBVRRKByq6v33EyBsLpkYv5kgyt0VBov8tr6iRv2M=;
        fh=XKOQgFSc7AXj0jSbnWSmVWKUlbysX8MXDbnhqy3nytg=;
        b=YIliLbsR4KhM28NfRWfLu6Qef244tnGtfdf5+8HkoavkPlxizE3n5fCRP78ZbumGLC
         rVNgmTZg/25wrITDLlR4VeDNbhM/g3RTSgrvM8gAovDlWcRbNJTDgG+VZNumXOXdv1x2
         OW7sPcpOY1P6p9tbpgbMuaDeBULPRh0X09f09wKen+xx+AH3DfV0tyF0A5PF+iu4CZmE
         3IbiNPo8m5dvzE/WOzPT09YKBnhOB1VhPzgSQSjUWzvUgqNdFDCnJokMPncaPC5vc1iV
         Z7EjsbA0C+e99eQYztitTvmZgwjqSQfATtNAXx7JIhcF0Ba4+eywRlpXT13cskughr4j
         VHjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773729838; x=1774334638; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxQBVRRKByq6v33EyBsLpkYv5kgyt0VBov8tr6iRv2M=;
        b=fnsxDOMNS8PZudKFcAtVydSXUy4YWEY1KodnMX7c72ImF3K7Q5uN/8APuaH7Fj4II0
         3eqz+ZMM+80hvJYvd5RzCvnBW88nlo/7yHDGi0VASel1YEE/DGQAo9+fzP7XWzXXYSSD
         olYxSYWU70ppnHnK33zGdrITk3nRL4YQ/aRIvYY70pH6wpLhZ0rHIHmHencoHPuPcI3d
         S6O0Qp33TFa4Ks2EyjmiYgfol7e+QySOn7PTu8LA1MsM2qp4naIm0vExx7moToRO1VdA
         9jdBeGdcpTtf12QuJfrJ3gKNlHwC7fk75RNr9nm0Me5kraSa8H5Pv6xbCsD6MUgOSxdd
         1CpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773729838; x=1774334638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GxQBVRRKByq6v33EyBsLpkYv5kgyt0VBov8tr6iRv2M=;
        b=R+9ggza3ZqB//YMV6C/FI0zw3gNgnMBSz0hDQAIK0Ob0NEFal0MYqUQiTV4sQrFR04
         g3j6TESMEdsoDlYKGhSvvkr9J6jQ695nWkyIDo3LzInLEqTGMjfe62j4Vd2royXnPAWX
         kRa9Hy6hT/vImF8GdhxVi++/GedhHkFIUSjYwQhcet2dyQjcT5q+K+nPgy6EgqETi7iq
         VUXIk/wo0xjV0WNuMvYTeGr37AEOah0i9uEnN+CZ5B9boMRD4Xt+vPorUnyLcz1JGtl8
         ERLocHqKjWF0YZMxjbKuzft1pYqoJ22MncsS9rsdyOgqx5P7MswmPnSjjNUw/cO6zA0O
         R3Sg==
X-Forwarded-Encrypted: i=1; AJvYcCVIq/qKdbkaMIewrnyV5haLBIZMHGy3GoUdKIT90iqkBA8OK2x6irJeQDzekvZV9KSd67GI8kWZug==@kvack.org
X-Gm-Message-State: AOJu0YyhecpC/vrWblrU+QrlmvumbBrNShs9nFiNp1iM9rBZb759rmun
	FI/49HbFPpTLiTiXmHGgB6O9nklTgsce2j66qaWltqNW5dgoWYjmT8nFq6TFDGCnG3aTb4w1hKq
	c+fUMBvg/n7pfAOhPD54TtEVFFi/7jNk=
X-Gm-Gg: ATEYQzyKU9Ee1hv+6oKxpuKI6aN5sKI4thubpCKl6q+J7ssMQk70OsgQyxBO2oP0jrO
	pdN5/McwfImIY7BXpUl16pBzWNS1gEvuDjLHrNpF2EYksCxhq7o7cKva/huLqne9tU6BFgx4ijf
	vgR2vDCQx9xUL+2Fr4WXGuqcr3BO7Ivt4XUZ3apw6RTz1UMGzEHkgXQB+Ye5BPu3s16oG8IMJfP
	PLbduFb01lDvUTEliEqWPDtZQ6qwtpW7DfCdI0IiVrGfpuQG2oAklEekHkTnUVxD7Gwmpvh9dpI
	z/0GZLNa
X-Received: by 2002:a05:651c:3242:b0:389:edbb:55d4 with SMTP id
 38308e7fff4ca-38a892dbef7mr28117211fa.0.1773729837495; Mon, 16 Mar 2026
 23:43:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260212032111.408865-1-zhaoyang.huang@unisoc.com> <abhh3lKb6med1LSp@tiehlicka>
In-Reply-To: <abhh3lKb6med1LSp@tiehlicka>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Tue, 17 Mar 2026 14:43:44 +0800
X-Gm-Features: AaiRm52oJTkxxmbVNJeLnvy0ukOwr6sw2jvdR8OFbzaHZ9S21OAnw5ueFBsmmx4
Message-ID: <CAGWkznF1oVLvY6UwCGZShfoikmAQ27juuDeowiHLvv8acR4cZw@mail.gmail.com>
Subject: Re: [PATCH] mm: remove '!root_reclaim' checking in should_abort_scan()
To: Michal Hocko <mhocko@suse.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Yu Zhao <yuzhao@google.com>, Rik van Riel <riel@surriel.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, "T . J . Mercier" <tjmercier@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8ADCA000E
X-Stat-Signature: 8whud8j58bd6gsyyri7ttz5r7zgecyff
X-HE-Tag: 1773729839-654961
X-HE-Meta: U2FsdGVkX19lh65NXd7WmzO9ppuwJI19viDzRuGluPCN9NqY10hoZ/REH6e2h0uUkNECRTvY6bS76f1laFkJrNtny+/dlhsEyOS4m/13nG3HOW5uwtKHFq+V1f9e1sZWuukvJrVg93oCo77/455kzCDZsltyFOaYGJUN/QLVH7aFRY+NT42UWc7xE3IhCKuGVoK2bHv3f8hLd9W+c4OItZjSp7K5/IjS/XxZfxS/YagG8Znsbc7B8PmOzsqdy8OtWxyOrm7eUM1Nqe0zZytuZomHpicfG5smzTm0cn60ycnEsEtOWS1pUSJQ6JelxlX5kUOqIH8OoNxSN+4gU7bddGT81eii15YLgifba7rdyR3Jo2n84xVfFAxN0gOZNaDmxjw1nbaIu+YNzUeJ5w+ghZCjtRbhg2/aKd04JEt0E5evQWJGcNRYpaNWAkF+ALV6Dp5xnV9e1iw/o2s5Hu2P6BElmOTetDkBJDtVXkkWjBLmObYOnrlLcA6xKBlwsPK8dKi6jWSmMszqNtBy3uoZlmJMzEfKTm/QhhwUkxph2fH+hKUpvDNaxqyyWmCezU8wN0XcmjYULPmrbPI51PvdMrCFMvoqiM8NJ1K1nH3ZOGt7zqlJ2NBuRGo0eZfcWJwNNcQt2LfWVzpyZ8ELbiFLZcQ1UiS08n0CVSgWmxA/G5KRRKKnj7rOKTOIpsopaeDZjY1nkiXZ+7+eiQ8MTuJ86I0cODi4hF1mC49L77EXt0hJiEsR9o7jICvBRg5BmBecna2uW5/pykCvJn04AVU5M8qetuBxzzHMGxjTv7AmWtDsyY7jgDHy5l0mMh2IPEqMDuGnXWtCTUvSI2hiffnaw50XnMfObn/DNQKZl7GzlvNShPE90sM15UORUEGugsop0cLERbCEt6EcofWjFLpNvmsjBbOza1rE8/o8x/2LrNrmNfwVqUqLYU0d8tEA1OShOFOg7iPIqxs8zdNbE3N
 0KQua8D4
 IIjS1ONsswIXEGGrhMzJ7APLZWMhjuTNDmikriWIahNKMLyAGaqBid78m2WK5UKyhyc5sQ3ADxLeOannTNVvtd+GkTMogjnBq8pk02vUqFK+9EKZ2sy/heCi+9sWfzC5ykkyCxUdVPUo1Ss2oWE6e7uNoDrGnU54EVdXCzoBypJ4IPHWTe3onbrpTWUAr1dzJK+LvCWysMjGJ7tnz/srt7XHkiGnjC+Z8xJ/GZgwrruLuEaw2+NDmobzAtjO6XprRv8gDNJ6xHOOAkg2lRgBg/xZtHHD8NsQTqIQUH2n8H+TjrOqi+tbeNmLH3dfiVPqqXpgbJxmcuxJPiRkaNaflhLtfTGSC6G1jZNTRM0CNuTXMcrY1efJEQPVV4K8RHNAK+1rd6a1CL9t6vjlUg3vsKWJFUikDoORwnbXeMVppVleISvAWMYE4rRR/+eTbtPM+38UyrlsCnCgmLvMhJ/KoqIZ8eaCwT9uE3NmG0M8HPdGFOnKOHlH0IEGwJYjwE1N5FvI/dDtUmFNjBcD0OuAAnLfMA9UyoJ91/Bls5eLGcBUUtTNWcvybdmTIGP6FiLqUkzNsoJxcn34kPiiGY8KQOZKh4h6mbzOtRndj9heQa2B4qhvCdhqcSwzxB7ZrV+G4s1rW2LE6PxDKYMzAteegtTAbGrr/8CnS9WgsHzE4UvFBtlF2zrbHl7AzuUixRk1vHKuKvW7wHj42z1qldSLKoBdojA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 4:02=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Thu 12-02-26 11:21:11, zhaoyang.huang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > Nowadays, ANDROID system replaces madivse with memory.reclaim to implem=
ent
> > user space memory management which desires to reclaim a certain amount =
of
> > memcg's memory. However, oversized reclaiming and high latency are obse=
rved
> > as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
> > when MGLRU enabled. Besides, this could also affect all none root_recla=
im
> > such as reclaim_high etc.
> > Since the commit 'b82b530740b9' ("mm: vmscan: restore incremental cgrou=
p
> > iteration") introduces sc->memcg_full_walk to limit the walk range of
> > mem_cgroup_iter and keep the fairness among the descendants of one memc=
g.
> > This commit would like to make single memcg's scanning more precised by
> > removing the criteria of 'if (!root_reclaim)' inside
> > should_abort_scan().
>
> This changelog, similar to its previous version is lacking details on
> what exactly is going on. How much over-reclaim are we talking about
> here? Is this MGLRU specific? Why doesn't our standard over-reclaim
> protection work?
Here is a previous test log which shows a nr_to_reclaim=3D32 pages
proactive reclaim ended with nr_reclaimed=3D394. T.J has explained the
reason for no limit over nr_reclaimed when !root_reclaim happens.

[  485.100981] sc ffffffc08b963ba8 memcg iter ffffff8086535a00
nr_to_reclaim 32 nr_reclaimed 0
[  485.106927] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff8086535a00 nr_to_reclaim 32 nr_reclaimed 127
[  485.109652] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff80744e1400 nr_to_reclaim 32 nr_reclaimed 127
[  485.112255] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff80744e4600 nr_to_reclaim 32 nr_reclaimed 127
[  485.115766] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff8150306e00 nr_to_reclaim 32 nr_reclaimed 191
[  485.125635] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff8157608a00 nr_to_reclaim 32 nr_reclaimed 191
[  485.131366] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff8157754600 nr_to_reclaim 32 nr_reclaimed 216
[  485.136688] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff8157752800 nr_to_reclaim 32 nr_reclaimed 216
[  485.140495] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff8157755000 nr_to_reclaim 32 nr_reclaimed 216
[  485.147322] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff8159461400 nr_to_reclaim 32 nr_reclaimed 216
[  485.150605] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff8159466400 nr_to_reclaim 32 nr_reclaimed 216
[  485.158260] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff8159460a00 nr_to_reclaim 32 nr_reclaimed 216
[  485.160819] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff8159460000 nr_to_reclaim 32 nr_reclaimed 216
[  485.163200] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff8159463c00 nr_to_reclaim 32 nr_reclaimed 216
[  485.171778] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff808912ee00 nr_to_reclaim 32 nr_reclaimed 216
[  485.174156] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff808912a800 nr_to_reclaim 32 nr_reclaimed 216
[  485.179110] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff814bd3a800 nr_to_reclaim 32 nr_reclaimed 216
[  485.181537] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff814bd39e00 nr_to_reclaim 32 nr_reclaimed 216
[  485.184877] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff814bd3da00 nr_to_reclaim 32 nr_reclaimed 219
[  485.187245] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff814bd38a00 nr_to_reclaim 32 nr_reclaimed 219
[  485.189654] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff814bd38000 nr_to_reclaim 32 nr_reclaimed 219
[  485.192029] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff814bd3bc00 nr_to_reclaim 32 nr_reclaimed 219
[  485.194509] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff814bd39400 nr_to_reclaim 32 nr_reclaimed 283
[  485.197107] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff814bd3c600 nr_to_reclaim 32 nr_reclaimed 330
[  485.201361] sc ffffffc08b963ba8 target_memcg ffffff8086535a00 memcg
iter ffffff814bd3ee00 nr_to_reclaim 32 nr_reclaimed 394

>
> > Suggested-by: T.J.Mercier <tjmercier@google.com>
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > ---
> >  mm/vmscan.c | 4 ----
> >  1 file changed, 4 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 670fe9fae5ba..9d900be478ea 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4832,10 +4832,6 @@ static bool should_abort_scan(struct lruvec *lru=
vec, struct scan_control *sc)
> >       int i;
> >       enum zone_watermarks mark;
> >
> > -     /* don't abort memcg reclaim to ensure fairness */
> > -     if (!root_reclaim(sc))
> > -             return false;
> > -
> >       if (sc->nr_reclaimed >=3D max(sc->nr_to_reclaim, compact_gap(sc->=
order)))
> >               return true;
> >
> > --
> > 2.25.1
> >
>
> --
> Michal Hocko
> SUSE Labs

