Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19566C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 11:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B18B6B007B; Tue, 28 Jul 2026 07:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B856B008A; Tue, 28 Jul 2026 07:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6EF06B008C; Tue, 28 Jul 2026 07:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF69F6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 07:20:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5073F80360
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:20:46 +0000 (UTC)
X-FDA: 85037942892.20.51906E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 64FDD140007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:20:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/IQbit6";
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785237644;
	b=O1xRZNfTE95+jryWjLQrjtaOgAKR4kXZC2L9wyt+SLiqv+tc59tBrSpOwN71rKya5y42Tg
	Y90TyS283i0c9fc1wmMoNaz/sgBk2RufXiMeoddMKLRmFJpq68sRQVMsyQyQSnng336KeV
	/WQFyA49o14N0QXk+bCiK1HCowxVmxY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j/IQbit6";
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785237644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydIMDQUh++e9z1W1tr7TzhH4ZhOQnWct+ip2+PoFcV8=;
	b=A2hOa8abjhpAt+UtmCa1tByXJU0T6SlGQAkO7/feY4gVPEmoJuL60cCl1Q++ufjD1vxWCJ
	Z6EaNBtCPzRWtQJraT+Icp7AXGXwDpVvDeLt4DPSGGcdhphpcRk0I0w371cGpf7ACLd4b9
	ryfhSHIExVuQpdAvtefPXd/GiKytmlM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23B7C43BFA
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071731F00A3D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785237643;
	bh=ydIMDQUh++e9z1W1tr7TzhH4ZhOQnWct+ip2+PoFcV8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=j/IQbit6QlDotohtR4c37MSMUkGCzIkDJ778gR5nRxXVP8GzDL1qHdF//iy/MMwwt
	 kTZgpMFGks3CPV2OtkfQtUnV7WHd/NcKCdCllltrJ98usoVSkM7qQY1BPmt8wM4JbC
	 py7Z0XrLSMug/y6BekDg14bfWgJprfD+idwP5ZIO8gjwif797c4F4Usizl7HCqdC5T
	 eHPrCL40z2UdLWWC6EZszETJIQT7yLvBI9OY8DMKwXyMQRcrN7Dr+BXm3bIPFJQZTu
	 KXVjaS1MFy+srgrYU/6g/yy5wLT5bbQzm+K2yZooMSJQqQNS+MaHX0wrI9fNpY6qje
	 io1Q9B83WJMhA==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e50979c71so373531885a.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:20:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpLsVmkN3Dz2aAurLmVQ3PMCaCE0pEeyyPjdYaJ0Q5KozSe8jZZs7AwK7DJ+T3H4ojVj/T25Cmrkw==@kvack.org
X-Gm-Message-State: AOJu0YzRdxlJu6/ArJzx8KQoWTSTGSgRNx56HqPmjO6y1vkrRB97lUeF
	kNXKINROl8AOqGhpolCW6T3pgdT1j0Ei6RVhkj6pmyVYL3J0delgeAYUOgm1bJdRpb4Dqj/4xPN
	C86MhZsxiCfL9wnlQwKl4sALZcoNM2Ac=
X-Received: by 2002:a05:620a:44d1:b0:92e:c117:9eb0 with SMTP id
 af79cd13be357-933027a5212mr148555185a.94.1785237642419; Tue, 28 Jul 2026
 04:20:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260726122123.7614-5-baohua@kernel.org> <20260728034633.3387845-1-wangzicheng@honor.com>
In-Reply-To: <20260728034633.3387845-1-wangzicheng@honor.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 28 Jul 2026 19:20:27 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w17+jKWJKkq9fdEyu6CtBtMpH-Sb4XPwdDUfqSkpkQyw@mail.gmail.com>
X-Gm-Features: AUfX_mwY-Ih_uqjf15ftSu4ifAfnyMqY4Pg-TOHeludcYFqKfPeUa3BPH_FmMdQ
Message-ID: <CAGsJ_4w17+jKWJKkq9fdEyu6CtBtMpH-Sb4XPwdDUfqSkpkQyw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/5] mm: mglru: run aging when pages are severely
 imbalanced across gens
To: Zicheng Wang <wangzicheng@honor.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, ljs@kernel.org, kasong@tencent.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	linux-kernel@vger.kernel.org, lyugaofei@xiaomi.com, stevensd@chromium.org, 
	linkunli@honor.com, tao.wangtao@honor.com, zhangji1@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 64FDD140007
X-Stat-Signature: 5qgzyqhs8id7pndhkdsoibh6bd6cm8hz
X-Rspam-User: 
X-HE-Tag: 1785237644-242672
X-HE-Meta: U2FsdGVkX1+JgmAJSPf9bAuQDcGrxEVDbYY801dqdlxnlKnCC7lTzoCoYk4CybAVIl3pIFSnZQ4Qe2T2cZxVnpoDOnKBEl5VBR+j5JYOsqONZBZI9w8THDPO5GBp9yDE1jyBCBoAyME5c2CYVB/8TAKhZmRIm+OYlJJ5bBlNKJ5FtAhcAqte6DpPY5KvaBlFDJRkmQt/f1ELTUdBc8c5VwAe+AOENB/0JfLVos8Pyfex2L0xn5cDo59O+FZ3Nijv65OuGzlZrg8MFX9nMpZlIliu6Xswarjxk/OiYfD7nL82xY9A+3+rgOl7kUEp4kMpsdrLEr4sfLhGiJNC7REV+aJbINMBXgwcarMhk3r2/al83QfUUkgimIrhMPewehsor3QpP1mguDbiBK7eMEr5Guw/w3kP76sp2YrBXLp8UmWpVQQWZM3zbDYqjNOMIGjwkcXVdv+vKTOERoOxWreSJeOvR74791faHlbShuIp3+VvXwGBPCaeTVo8E2KDwD/INdOoeUJKhun3p8jnBb0sWXJEO0w39kOM53N8H8+Cl0mQECRhA5ihg6+9m2AFxvlq4b+68r1vE1grAaCH4rTF0eC4fqtkhpamzyBaMP3CMHWH5bCZy9IsB1Zn/JK7m5041qpDrFq/D4c0K3TuQJXEWLM+c+YBR1M0zEbH8gHcmSHTBnYJlzrBEDlZWgRAC9K5mn0qOjvNXVqaQbRR6kjmpWTiUNGdBB2EYRgXdEKB9IobziuOd2HFBZaEmQBFC5uXWinViTmIy9vuvb2JdTczCF0CaNVd1SB/boFOlmBXviLRbITfxbi/S/RFQZKMx3qMeVbNN/dItI+o2uZ7h02m0fu0QUm+sMHgZ/O8HznqzN0ZyeRNqTusUgl+dCu19Iw/EtOaBM/7t7YGvaumYI870bAcbfKbHu8GQaO2jZDh0bXII6tEtdIWG82U0NElUKaIug51JoiYO7cj6cZDM5P
 UuBpKgU0
 GPma72D9HU3D/Ih0sS9hTLbEAv8mPqLU53pjkkSDe+Tj9cxQlDi7iwoAMCo0fgPjL7//L2ai5gFOuU1edoR7Ggj4mseSjs8g9V4a+zBFHXAru+lKhyuO3Vq8Cf6mfAAJmjOGolzuSg/zaN1IeR91Ogmdun4mVGp5zDuECaDYk0kiOFNc1zNo6Pnc7XwvBiTNmmjct3lGdiurBtIEQL5SQ3lRPp86SS56z6xiDmF0FBls04buNMKlX9g7aPDw/GK3+iJoUVz6HD0DDfo4euOsVen75DMei6jY43oPjZ5D8txPDmEn9lvO833QPi8DlHuVuXWXFDV9uN3SKxwKgn5FJmcqaM7Q25BAnZ/iEcVXT+oi6y8kYJqBoalfAEL0yX1jsnKzrIVrU4Y4TIv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 11:46=E2=80=AFAM Zicheng Wang <wangzicheng@honor.co=
m> wrote:
>
> Hi Barry, lyugaofei,
>
> The cover letter results look good.
>
> This change looks like it resolves the cross-type skew from 798c0330c2ca
> [1] (if I understand correctly).

Hi Zicheng,

I guess it somehow moves MGLRU back toward its original design
of maintaining some balance across generations.

>
> But:
>
>   removed (798c0330c2ca):  old * 4 < total
>   4/5:                     old * 4 < young
>
> Can a single type also skew, and does changing total to young have any
> downside?

The original code is a bit odd, as it compares a single young
generation and a single old generation against the total,
rather than comparing all young generations with all old
generations.
 if (seq =3D=3D max_seq)
         young +=3D size;
 else if (seq + MIN_NR_GENS =3D=3D max_seq)
        old +=3D size;

Also, for the swappiness bias, we care more about the preferred
type than the other type. So comparing a single type, rather
than the sum of both types, makes more sense.

>
> Nit: the old form derived the constant from (MIN_NR_GENS + 2).

By comparing all young generations against all old
generations, we no longer depend on the exact value of
MIN_NR_GENS. The idea is to emulate inactive_is_low().

>
> [1] https://lore.kernel.org/all/20241231043538.4075764-4-yuzhao@google.co=
m/
>

Thanks
Barry

