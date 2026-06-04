Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17374CD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57E616B0005; Thu,  4 Jun 2026 08:53:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52EB26B0088; Thu,  4 Jun 2026 08:53:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4447C6B008A; Thu,  4 Jun 2026 08:53:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33F5C6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:53:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D87EB162B80
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:53:31 +0000 (UTC)
X-FDA: 84842221422.02.D8394D3
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id C881680005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:53:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hqknlAZb;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780577609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g69Tg8i+2AI/l9rLO/HBsvL7C8sDT3SBWBYRRkExyv4=;
	b=q5h0LgXSulDMHOyaiZlQCtgsCk6+LbomOBGlxmZHI0kd0CBhpT9sPeoB0JWA+k+yKhremo
	iLXVIDWH+XXN0b8wHDQe090sKwF02CcccdC+jFILt8ksZ34t2BxXvz3rnZo9YgohxJDXZB
	Hi/MLE1LuAUzOXCoPclxbzwkfgXrLfk=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hqknlAZb;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780577609;
	b=Nb4GXbRwPM3oZr6/dKGHx3BCw8NDQxCnBZG9JY9BKL29A/VnlAs3rLn72NvnQib6fM1Ft5
	uRrY/olhB2NwHdGfbZoKtTFvNfM/tvJMiODfrKgvxh1XNdXTAQI2ikbPFdwQYCiFmPfSS4
	NZn8BK6rOoZoJxiYMYeY79xuuCsXIb0=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6603b01758cso71593d50.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 05:53:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780577609; cv=none;
        d=google.com; s=arc-20240605;
        b=jpA/5sN03AVgsE87Ns78MOZQqI+k/4nvfdH98q0eCc8tJkDPvAIKDBDPfyP9CnMPy6
         D/gm2juRUIxETFAIJF7z7M2JYYqZc7KXsJ5iwPns+uuBxie5fFD5ThUEiWEyN0LyFeZh
         ujNdg5P2gNJAeObDNXaRVZFuj68vS+lln9gwpuOEFzHG/sgPVXoNYuaInqQZN96fZN9P
         LaL9oKxngTEm0GDKv41+KdAXh+1N8j9Czu9ImtEXoYIGrZ2rXpdAkH4gjXZz2mBTYizm
         tICjxJmvzwEXCkuyGW0s0Q1u3KNV3uVPk9u9y/8LEoo1D0TSsSiVYNKpkk3A0NvwgF95
         4M0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g69Tg8i+2AI/l9rLO/HBsvL7C8sDT3SBWBYRRkExyv4=;
        fh=1oMChL3bCWQDtQ9AfhD659unRuppM7NiMaF+/WZVAbM=;
        b=GM8aWkc4Dl4tm+403grbcPElW2waPAPtLbkjVK01WhIJy23rie/OysHSiRWI/J++Ni
         P3l0Q/eyDKv3ieuDH3uNYgVmY87OUcLfUjnxp32oS/ky1vx+OP4ef/MC5ll/JYeyuHNt
         fRo0i5KpT3shp4WWcwcDyIJZUyhI+gw++TPVpmPf10koXUSEkCgSBrQVrcn1gkYfUors
         RYhlalCUo9+txEvde8uNhvC7t66fCRGKRX+twiDnZgqyBAkSP3scE5IpNUykVhJzM04B
         XvN+UD//b/k4qJVEfL8wBKhRJ5sRYF0fNM/270U/FPN63nvBqb6Wf6LjrfhoCvuuamAq
         ZuFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780577609; x=1781182409; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g69Tg8i+2AI/l9rLO/HBsvL7C8sDT3SBWBYRRkExyv4=;
        b=hqknlAZbs/kfnpvfyhScI8L107CgzCsj38xe2phPqQQEeUEU47Ps631Ra+wcZLNqFy
         nroQswaRf4vTnVqR9xctFpKUP1/WepdingTYbr/kpeE5z4x3gUvoZWDdDp83WgEiOtKO
         PoexGSZKpd0hiM6rvhSXDBmQxnmCO2/GPkCvcP+cdGse/z5VniIMKX2b1Vqf67yyPZs3
         hiMRCCwvJmdxTbxC5e28wfDV6PBQtjGnYWkPz0IRjy7Gj8yBtxCRa+72B+TuX72WKOJ8
         cvZpKguHHeNxUQTuwREaqmponkK5p7Kriaqi5zDNnh4ejmKBcSJ9UYXO84wBkOPdxoXk
         1+Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780577609; x=1781182409;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g69Tg8i+2AI/l9rLO/HBsvL7C8sDT3SBWBYRRkExyv4=;
        b=q7wWr/Twij+irEStwbDoPToNMTuu9QMOKmBYKd5SdI20ErgAcmgB2Aju1bfHxnxGaq
         CA0ZCyFJ5FWE4uH67n/bmWyskbuQ5AQ60hX2MI6/Q3gVqD9arbe4DNwnPTWfMUI0Foem
         SB3X584mt+F+aS6ws4RUOy8RcNlIT1dofrAr8ebe7upb/l5X8hOyDh6e/iWFQ5vlPApN
         NZ9fUL0cvbwFEOm8XrNx0BHPVj6axglGPCc2zZSnsYmHR0w/me1LH3l4sRfF0O1i+tEL
         fmipJ6IpMR1wdhnxz5nGWdvBK864KoEFNExzQGXZOW72u9UrDrGhUk3icdesIl7BCRoE
         BPIA==
X-Forwarded-Encrypted: i=1; AFNElJ9nclRbkl8TuEyX39086pJ661kPcE8llsx2vkgTVH4J2hYJzSjxA+vw07essUxRy4daGvKFaQBIjA==@kvack.org
X-Gm-Message-State: AOJu0YycvSLP8AxmK1YUoT16krfTj5N3zyhzo4XG14SKbL9y9+i4I9/n
	FhB4l6Vtf0jQT9B3KUsNiMdC0sYRXeM6OoFUcQP5bnlWzJWll/F+6wHtrRJFYgkngo3lT+uXY2n
	dz4018JViB1Tl16vpU5GiDLvPILYMZB4=
X-Gm-Gg: Acq92OEYn8QEo7qdGTlBn+3NNxrh9HxZROF6ZQjCsCJzL+cD/9rUeDw7FaB8GrtCzIl
	FGhFe5kr79ePD06W/8uC5AFBLjC9v1apYn3c6SNOMkENlkVgaEU8WIMtYB7clBvqJHn3qCw3AUT
	fsHDN9VK66SmfkWOGtpv40TKYYvwwTduNqRO5tkkr5ZWIU387ogyCgNa0zt4ZI/KmSO/0kF4x7X
	iCLWj1rv2SIB48gsRyy7N0x4n7i/9IsTLvvNyRH30cBS6FtvxyZIiKsYNrNCxaB33O1EF0fC9Mt
	NNgoMTFTTQMCj8nTd+EiJFMvXhsBjlxKofjdjdfqkyYShcBxngQOtNZJJsvynDMZvnSLaIEOiDC
	zHAhq/fVyCXpg1yN+z83P7BP444zwW3J8
X-Received: by 2002:a05:690e:1915:b0:65d:6f14:9070 with SMTP id
 956f58d0204a3-660f45c9302mr1314879d50.4.1780577608699; Thu, 04 Jun 2026
 05:53:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260601133941.111989-2-giorgitchankvetadze1997@gmail.com> <20260601134427.dda82558dfb2da579d66cbb0@linux-foundation.org>
In-Reply-To: <20260601134427.dda82558dfb2da579d66cbb0@linux-foundation.org>
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
Date: Thu, 4 Jun 2026 16:53:17 +0400
X-Gm-Features: AVHnY4JPI5ZoHsj3kCakMzoQNU0ShVKpROBSnYaYX10AP5q-EBPKGug1lIOe_RM
Message-ID: <CAE7dp2ou3f8d0dAqyFQf8RQ1jgYtdsBxq70GF=OECAcvfA3UKA@mail.gmail.com>
Subject: Re: [PATCH] mm/compaction: guard move_freelist_head() against invalid freepage
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C881680005
X-Stat-Signature: pb17cke3qfpzc6jom7frun6r3zbfhzxr
X-Rspam-User: 
X-HE-Tag: 1780577609-84748
X-HE-Meta: U2FsdGVkX1/EZhBZAEEaQzKgxDA1LoGk/9iR5SNvII3cRPoEXr/zy2pLg5rfrfZoUyLlnkT2qwGBx2QGkwE3+sUiZXb7gsSmC5XaOFY9a3ALS1UEXU2QD6ihn0FvWkl9uin0/AsUlScj/+5HQduNGUN07iQ5jhqSu7l0mAZmj2hF8gYzZRBaaJsBspmIWabRGYNT80P5DnoFlHgDeeenAwdxapnjGU2jDOwXuoqYMlAWUPikaRyY3oTpXcxzXB6fWw2fR3zIxk2IfjneUUf1qk1R/1Dl9ujJHAHMDVApvtnFugcluwlLeXXSuvIAjILKRInFgDLGwm3TWK0JQsNSEQDiNL8kxq4eexvF1WNoDuJIh0NPx6SVoS9GGgC7ZP6lL6u9yYgWBUNsFEt8n0bjT9PsKVKqg5QSqRQlEHHFI6OQQEs0+tMNfqMUPamtpwqKF6LIfSNoxfb+64TKyKdzHpiUYOnmtFCCr9Xhiwxj3ljWYU+48n+b5FesTQRP4YVxKnf7fHpBXTcATl1c1Phtgw/prQ9fKxJWzDPa99q4GHvIWoGaQv53oSozolZfq4K/Dxq0tH1BN6fr0YsoQsuYCEd+kwsprgepNnPCXvfvlhMFIDiQeLvL7pddb8ju4bmcgR4/yimPRundTpUaMcCMcQrGb9KUEUGuVjQE1QW/7PON2BeABWNSsRQHNt7e8mR4tSlWyDkwYZIvnLutOFQ8UadQT8rXhkjFmmI9j3Ut29i45CQb/iVqV0PoBqqkd77V6mlSdYiDgrfjD5sqjs89FlweJ7G2or9xkKspClI9yE8xIxL7Ro6YlJ3CFJ1McfHPvZrLlBxcl7U4Xo7PX4Q7chyIRlVZ8Ix7rex+eArIeVrOvKq7Zhi3TQntSOSTY88zaALBIFmAq8u+wmrx9OAS9QilVNzelnttqU41J8GGehKDQmQsAXioMttCgOEezwnWgYou8rDDABsj42MaCT+
 35kSXygh
 EphlFVH18lHs95BIYs/qIAoaRJ5zJbzVONWJQB/0TYJ/jwp1DUVH2EqHa68pR7zoqQb1IwFejuPAZ+fUfxtAnNOw3ehJTn75Uf5m1lrWESwCChEMuoxiY4MunvGzRL9ohzZ9KJ6XX5su+NgZrChd13H2rGJVqLuwoMhT+IJYTkvnKAjeo2xLgHYQbPdwtHmzHdjepK59fj4YT7aPRwHmRp+d9I73jV3BUN/y+V1FjJMbVDCpLuSmEEtQUOp9HNfzAUduPp8GxUx5BaPgVn5CsQ4VdLZxMlsFAMsTeRLUWHq6C+AJQxczyN/4mzgF+zn5bbkEKivMiKnZ/IrfobKvaDLkkCMaSjpPkq6s/VbVTVj/D5iQEws49fRUQlL93iWARAAqTAM5rUsnAZyoRuAnQd4CsAzjGV9uV3tGFae4b0Yt4rryKsfa/QIeRP4DBnrbQF3FjQw87x7RIP1LAevAdgB/4do+DM7/mD62uO65HlvU2UKyyBftpsCU5dAu/5DxyyzHYCL0dTctlxLru1gHNBbIQEHmOI4bo3LBY3XO9ieU63Pkmr0awm46kkeGquTFqaVUAnvtkRpxyT3LrD1x0S4ZPDvlD0bhHNi0hzpdkz6EYruFPkRzUQ9mLTe8JN4xQNTA0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 12:44=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> Seems correct from my reading.  That code is rather twisty.
>
> > This issue was identified via Coccinelle (use_after_iter.cocci).
>
> But AI review is worried:
>         https://sashiko.dev/#/patchset/20260601133941.111989-2-giorgitcha=
nkvetadze1997@gmail.com
>
>

Hey Andrew. Thanks for the review. Yes, Sashiko is right. This seems
to be deeper than I initially thought.

My patch is too broad and skips the freelist rotation mechanism when
the scan reached the limit without finding a suitable page. In that
case page is NULL, but freepage still points to the last scanned real
entry, so the rotation should be preserved to avoid retrying the same
unsuitable tail entries.

I'm thinking of assigning freepage to NULL like this :
struct page *freepage =3D NULL;

and later checking:
if (freepage)
move_freelist_head(freelist, freepage);

