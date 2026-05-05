Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6314CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 22:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5CF46B0005; Tue,  5 May 2026 18:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0DF26B0088; Tue,  5 May 2026 18:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFB796B008A; Tue,  5 May 2026 18:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABBE26B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:36:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D089BC20B8
	for <linux-mm@kvack.org>; Tue,  5 May 2026 22:36:29 +0000 (UTC)
X-FDA: 84734826498.19.E79440A
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id D142340005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 22:36:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BZ3Lrm1v;
	spf=pass (imf27.hostedemail.com: domain of rosenp@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=rosenp@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778020588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rzqbw/nypFqS+4DSh/aG9WhAbZfgykDJtFsgi1ul23I=;
	b=C/m3/k16LsnbvRTKsVkqRqT1MTErkQ2HD2yJOdmp4v8zgGxDFgAZ8vVpBn/WuWopfiIQWJ
	K6bfGi3Jci0atmDMmco3v30MKKQeqMTM1haZR8d0wi6ZRFwNuxY4DbneXYf5UDynpfXX6X
	2dnTSiaygHDKSkmZkvHZSWhc2EChW30=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BZ3Lrm1v;
	spf=pass (imf27.hostedemail.com: domain of rosenp@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=rosenp@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778020588; a=rsa-sha256;
	cv=pass;
	b=sUtwDwvVCiL9L2Os49HqYQozlaEzD6sJW2JtmI1fZvXa9lTPQB+SDhpwckdFN+T+XmSZOs
	V8bcwsan375r3xsZNe80NC3ewmT9WG6cvLC6n8AKfcdgisMmRgWNpg8Tz+ig6YEWKhG689
	DXEwU4g8BAScUpq10cTEo/QSuVqlGeE=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5a887ebb416so145369e87.2
        for <linux-mm@kvack.org>; Tue, 05 May 2026 15:36:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778020586; cv=none;
        d=google.com; s=arc-20240605;
        b=NKwrEnnKGBh2M3Xvq2wMnKpY717bmo6nCtwYllfmbviWHjv2rNvCelbs9S3UYCWt3E
         KLh+f0lhDQELfkKlWEqmkLI0jbOtIhvoofWKwhTiaPo8sznZPQ14SZKUshoeel2fshRm
         c9iYs/dtZSM8Bu4jWQaSzE0qZR9K3y15ruoQVz3eBvpbupT+YjHr7Wc8CvjlNwhHE94r
         Y+BZgo8MuTHTCuerYDjcwm9U/9cB9I8wrFWVGCNOh+u3cFPOP0i0oiLDHB+eRpFIymmw
         tGa45y1okDCSa+O3MBqPq3FPQyJ19wFk+5lz1/azup9xoYnZWiVepdzwk2KqvifuNALN
         qKcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rzqbw/nypFqS+4DSh/aG9WhAbZfgykDJtFsgi1ul23I=;
        fh=+7l5ZePh2uEOQeb0jUJlb70iGG82g54gV+LCEjmmdBU=;
        b=A/JJ9C8JJE3Z4l47nRu01AMkzPSgX8Xq4AnNeaWiq1nMw5Jau4db78aBLHNdKk6VPE
         IOHqKBX+Bg1vbVPXITD5Bb/+LPUYj9yHBMa9W48zFOSPHs6qKu+DplmO4hd40rNYkMUK
         QHtn4bNzXnwwrO+wp+mY8r7NuEZgexlqS5XmclpCnTs5PZOuIjEaCWUTC/bOaP5EFtD+
         cBv4O7c4lphVpG/fkzKNdcXD9BBTauDwyBSx7YhVE7HoPnH0s4UuSM7vhPw9w7d/Wv2j
         XdcTDAFQs2Uh8FYcUEElDUDPSTRRHkYgf1j0n/Hz74/TmV30jWdJcHahRtBjovtk+NB0
         X5+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778020586; x=1778625386; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rzqbw/nypFqS+4DSh/aG9WhAbZfgykDJtFsgi1ul23I=;
        b=BZ3Lrm1vYSP86KgrGoS3jfBGVYaiTCW3rpUL/IeyatatiGkE7ZYCX9FLYhHmLv8LNe
         P7ZdecdUY60+3l5XXXNyZIEU4azQWR6dIHenKMQzMA/mRZFqk0NCAi78xNv7W9/ZgyqJ
         jkj9anaGV2bImgLK0bvqZ+TFIZII/RLHzg0OKwR1rFogGOegxMg4jGS6DhyGVWSY1Cym
         mEEHkX1Xk8LHXAl7AZiknG1ahHroDhQQvappjnOS/K4Nh8RtXuhXN/SzHYdOhaVXL6PH
         vznu/YmllqRz8jTp52BPijh5md41PV/KV9rFj0RD4LG+1oqPQk9p7PpL9GQuXDAlR2g7
         E01g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778020586; x=1778625386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rzqbw/nypFqS+4DSh/aG9WhAbZfgykDJtFsgi1ul23I=;
        b=m+TE/T3mbl7CVX+6WbFQjWZF/0JZq0O01/tsGciktyAYOjW3PXcdTPZxqakQAHhWTq
         P5Khp3/z1XL7QQKqNd8gAHENr0n9mlpftCtTMHJ1b+CwME/1an1/Sm4EyGe7DVQhDJUP
         gqLfBtNx6ZN9roxgSHiio6yOXKtIOTTd2docfAkJojsjxRxJ02zQsmEjbjuxHvv55gxJ
         siKnLFZ502l9kvUbDL4ccCabo8bBNrrVAHNXopqlQObDsT17v7UqczuyzxN4rWEdBDjm
         kMpYK8XAjSgowq7j+NAQi4gtfUgHCLNwyG7BC6KcOBzE9phEXtpFd6n0SDMTYqdKmsT1
         3Wmg==
X-Gm-Message-State: AOJu0Yy8PWXsZz27NCcygKlPtwNUoqbWj06ZskSN/vIzs04lba7dmO/2
	zpDOgPkgzMXYtrLwGuRf/PP6GbjGsoh0dOIHNvirz5sPygwIhxzG0lBCHePVN7l/VOjRlKX4Kkb
	rkFQpZ6yFZ/ruxiWLyWiTIy4lAoV7U4M=
X-Gm-Gg: AeBDieuh7bXkWCQObU4EAxE4+HZB5Cg9I7DdXqtaxFnvFElupQZZlEnb5hdLxHE1p11
	lhsmgWfu+xQ0VxpChkFlXo0pEHfHCdC5t7cq3If8X2Eq/6LlncbIX9k7oeBqJYGrPFxdYpTKC3k
	xOzxkW1sZfD8cXQD17R/U8aGWi20aBNM9AsEvYTy+pNaYxf+P4ogzsFspDvQuHY8eKOsG059fWx
	2wuyW4uZhikwuzOwuoNxcHo4AZ70GFhACeTRVXfWLTtN/ryaeaoGNLpMSWDYVQd2h+TfM6V/1iC
	7MGNlRtEK1lBJhUDp/OlXARNywq7Cd2WX0D3zrbVAj3JfH4jjQ9g4FSChn4CFtD2FSO0GoWy9fW
	Wbk7XnvKbyRtaGXPgnIeTDO2mWHvkugUMDezJeIHjnwVNHz74tbtzAHKgRYkhyb4j5XOr
X-Received: by 2002:a05:6512:3195:b0:5a2:c4f1:2635 with SMTP id
 2adb3069b0e04-5a887cec51cmr208911e87.41.1778020585718; Tue, 05 May 2026
 15:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260505010112.645361-1-rosenp@gmail.com> <0f11390f-e8bd-4f8d-aea8-59ef545b2c32@app.fastmail.com>
 <CAKxU2N92s06-L0+e=KZ7EbtU50tCpaCk2MYJD2xTFEHEsAhXUg@mail.gmail.com>
 <df3e889d-ac8c-4d11-a5fe-8ed2769953f0@app.fastmail.com> <CAKxU2N_moR8bs=NLUcW054a=oHB--4i+M5XKCBNF9LskYcjAhA@mail.gmail.com>
 <add152a5-09bb-4c6b-a17f-da3d817b93e9@app.fastmail.com>
In-Reply-To: <add152a5-09bb-4c6b-a17f-da3d817b93e9@app.fastmail.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Tue, 5 May 2026 15:36:13 -0700
X-Gm-Features: AVHnY4KmhUVE_Ek1NBAQLUwefKU2Vsdr5nkeVFvJ1HuHAbomEgHQB-nmVguGnIg
Message-ID: <CAKxU2N8E=s3==64xYGHGGCV80cw-c88vjRHk0ery6LzBhuit4Q@mail.gmail.com>
Subject: Re: [PATCH] mm: move phys_mem_access_prot_allowed to header
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:CLANG/LLVM BUILD SUPPORT:Keyword:b(?i:clang|llvm)b" <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D142340005
X-Stat-Signature: 9kita1widtqb18m6zq3r4px4sfsbh47o
X-HE-Tag: 1778020587-935216
X-HE-Meta: U2FsdGVkX1/vHemSiVOM71uqdbonYnwQWaf+7+xvylCY0NC0oVJSDT+DRSigXKi4EZ4dSI+c4oSArJDUPoyC1UUBdBjm67eEaRl+xo9SUxa2eGBaRDuyDy9X1OL0L93VU4jUKDv5CZguIWaMDe6cKgsxb8ek7GDZRT808u3+NxG728q4CBHDdp3TXt/O49gxvJXFRDYaYFmlOwRfMUiZw+a3+dsfhXM4RzLrMPy3kcFLImpQ6eivjZ81eowehKeQBpFlcDWMSW+kCzExo+Dw/s+e1f3uUUgsKx/wVpdTog2CJ5UQHKjqVLhsEYVKWYBaI111O/emgW4/PogIlHYrow+0Mye7adVj6MfZNLs/xSt2l31NbNjO0XueKLpzqRZFdXB5jaCHtHU4in6NCmiL9rhDVdbu0+C/n0ed28VBAq1hPcxMzqxLXKgl8Wm0FyOojV7iPJknQL8xRlIm9YwT+UaQABpQUXDkRpiuew+HqUdD8cXFD2lupw1gYOkPp79zytBuwP7YsQpSvKHMzKAirVB38jg9AvFMn2tSWGwwTGptL3z2h0RprZ5DlVUvF/6OLgT8Bt9WP8jSBnsvPvMOEw8VhcfQmWy3PWos7oIUDXEuKQAIKEY+Bi5YYViBY5yvjjhZWxl/pdsdOrnu/Xq8wK1qnBUnK13kbdRRA5tbcVKZ0fpW10stJB+dY6Sd8W3gz6+EhJX4u2Hg5UD+bOGe0JbqQ7fua3m1XlAsHkiWrnYRZns8HzNs8+VturY6OW9pRk7pWs4fjJXTMAIj5EADiazm1JV94T1E37WgVcLVcU2lm5WUsQCJH3W1ET28y/95oxBXvLgBR4mYD1kGx98b8UZ7N7mzH/byNE+ns6IZ7nY28f9MEpZ621H+zuy2+PFR8AIbjo1zXE6aSRm+GXvdE5gDYCFJ999sZ4qDNwE672ZJxfopa/vSukEEPCWaqVbg25ixSK4ouiVkn8TxFt7
 0i+KJ2kY
 V458xy/FcJWrZXbdVSWY/h3/hJfmEslV0sn6QZuhNki+rATG4cglL5Z3pWRsivrywwbv3+EWVBaxH2az4a25loTpeTqpdPkn7uK2uWgSO95Z7f8VGirIc8vNbVQMxcQ10N1Y7vbRy8Zi3WbQNOXuP9cmyAcK3owNUSXjWLxCAlWN6dA1INv0XY62dnDeSnBE13RVrfAaQhCBpClAX2781R9CFbYLn/UO/DsKXJIH1ewm7XsJSv9cdqjU+X0XjfpPSL4ifBMXU7xtwVAFxnImmwd88VkxAqUmzOOXWsAUQpuI5lzz0QwbEpxC53JgMU2nZBiwk1hNM3IibzbaQBStlliBKfAt/R0DCokPln3hyLlMTsThcUd2b2JV9MP7sbN1FDUcyXo68w3cbDjG6kfF03aW54PaH27+l0zqnn5JUFyvdbSmH7fsG7coSxKZuWyIk/aFhP1JT17bZKXWCV9/tSYXWikzgIeZZ8xzcLJX9jMOLIuWyRrwUZ6GwnLlj/fc+ME07gml8NRSVmIHisZDZVlsXiuacQpdcxoym21Opz92a9Rg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 5, 2026 at 2:23=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, May 5, 2026, at 10:54, Rosen Penev wrote:
> > On Tue, May 5, 2026 at 1:29=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> wr=
ote:
> >>
> >> Does this happen with both ld.bfd and ld.lld? Which version of clang
> >> and lld are you using?
> > clang version 22.1.3
> > Target: x86_64-pc-linux-gnu
> > Thread model: posix
> > InstalledDir: /usr/bin
> >
> > lld the same.
>
> Ok. I've tried to reproduce this with Nathan's llvm-22.1.3 build
> from https://mirrors.edge.kernel.org/pub/tools/llvm/, but don't
> see this problem on mips defconfig. Are you using a particular
> configuration, or do you see this on every build?
I use allmodconfig. And yes, every build. I'm using a fully updated Arch Li=
nux.
>
> > I don't specify lld explicitly. I assume LLVM=3D1 does that.
>
> Yes, by default it will use ld.lld. For cross-checking, you
> can try passing LD=3Dmips-linux-ld.bfd (or whereever you have
> installed your cross or multiarch binutils), which should
> still work just fine.
Arch seems to not provide such a thing.
>
>        Arnd

