Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE2CCEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 13:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107F18E0003; Mon, 17 Nov 2025 08:31:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B80A8E0002; Mon, 17 Nov 2025 08:31:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9A48E0003; Mon, 17 Nov 2025 08:31:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8BD78E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:31:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B24552B46
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:31:03 +0000 (UTC)
X-FDA: 84120184806.23.69D3686
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 68A081C000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:31:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YSl6RqoW;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763386261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PaWyh0QzcwKqBgx0baGTRcI+URglOSNILMpQRbc2ndI=;
	b=G3y8QVSoElb9/Q56sVGJI3NhvRE5EKNCll0VEEqlEZdxlM5GQ/K9iUiZpLhzNSIb1yUomB
	Dywbiqd8x3y86VzBWW7VKJDcpsQPQTQ7ifYy+eOlRvFUip9m4W+K1GYayrnHyk5s4FSZIX
	yOHrbhlmbD+sl1kD+r6I0PK6K4uvXtw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763386261; a=rsa-sha256;
	cv=none;
	b=wc1La48PWVfnPLy6UtwKDt3Ddsaw1Q9Os3F66wL2Lx9ugSON4T0ttj7ZLKKLvf2wDa68TZ
	MIGBRn6RNBVk1Y57QUsKtrbuEgwC3HAJiDqxgc46DC3SnC8yIrtxVHbKyuCro/Y/y6QZJM
	DNKFxTYJFq+LuiDDGFO+XBQ0WtSc7cY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YSl6RqoW;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64180bd67b7so5951574a12.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763386260; x=1763991060; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PaWyh0QzcwKqBgx0baGTRcI+URglOSNILMpQRbc2ndI=;
        b=YSl6RqoW3tVvtLlOlact1krvMRANB4xOpI6QJw7ikVPG908Mu2Ug6wbS/3286a7wJq
         mD17oE23j9hcZEAWhTxicjQn9Z/3Qcr68FjTSlzo9ZfrPGkZg0oPMm83Of3EpbfyAm6l
         T2R4ZIhaF3wpqh51oa1PQNHfXDyzv42PK98mdC082kAEldqUunx8Ph4hixx7WjABYU/u
         Nh3iEtXM2xIR/t651B/t6Is6VRw45iRvWzK/zSbOEAW/8S0j+SdwdCYH2RFKkrMl6+2s
         LA7zgz9y/Cx2Gw4Tc8rxTSxgxUfhpPOI0TlVdV5Ylht8U38Hmux0Qh2i6i9cj9cn+HyB
         B5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763386260; x=1763991060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PaWyh0QzcwKqBgx0baGTRcI+URglOSNILMpQRbc2ndI=;
        b=cGYm/Q6drKUO7ghs01fS2fMEStVriF04gickG8yuAtp/6NbRSPjXronVjaAufb2avd
         VgRPW8vK4/FI8LVCP83IGw5YR/WOdTxj1Eb+r+9YMwMe9obSLxvHuMP+TU5NXV9+Tl7M
         yT+V+eXtgL02gAnDsFkTID92xHg2H8uUqHZsmVKL9JJyQIxEif1qBBiD9yJwTAfgFV8Q
         LgWYZFpboPcn2VE120IN4qmIPa65XZ/l9u1Y7jI1+ZOHpOw84Zczf9nE5fpCaN9uSimQ
         3tRxxKLddkg9jp9i7KsuspyDIW0NTajtF8Wket/F2dziYZvAmG/yYXBES6Zz7qtfuW/f
         CJSg==
X-Gm-Message-State: AOJu0Yz7JXs0Br0WsC541kVhUZnMrZ2u2jVDG5AHC9J1FeDcihzM1HZU
	lZolBh+Yx+F/XUQUjGVEHjXKnQCON+q7nRRczuE0t1syFA6CTCx5V4C/GWYbpLEq3Z4vYhkhN+Y
	rRdTshT6hAC1hRxIKcpAMbrcncw+PjwtDUh1lCmQGaQ==
X-Gm-Gg: ASbGncssSqqeHVZNSqtDf4iBi70xkUkeCrRdyHscDTOwrN+JYLId6eu6mbZNHOZB/r4
	0FZMLSUiTZCRa+BweO0LU3zYIGlmnw/KBFnR4exie0MNrnQwpPo/j08HnWooMQ2OZv5BQvxdD23
	4Ce3C2vDKEoBqIWZu1p0eMN70bohgeNGBbQvst1y7bJvoY2M9+Q9IUi0a1RuQhcqqfaVagUvLGQ
	L8F9BOYaOLS5ciTt+hfhdd5PW0E45A0z+J6/b/AMXDgaZhUywifABBndz2NH87UIb/l07PjvGWE
	BeaxxAUanYIb9KFdYNpLyK4qexwvlX629gM5a3xFXw==
X-Google-Smtp-Source: AGHT+IE2q9cxzQ11eFckik+jwI+m8CZlnmGQQBueLgQqdoDLrH76cSm/7gOLaMpuIbhqOlMuKvvP+9chgs8sOX9SjVQ=
X-Received: by 2002:a05:6402:3507:b0:640:fb00:9b0b with SMTP id
 4fb4d7f45d1cf-64350ec2ff9mr12960547a12.32.1763386259350; Mon, 17 Nov 2025
 05:30:59 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-18-37730e6ea6d5@tencent.com> <202511171912.yMOEajkV-lkp@intel.com>
In-Reply-To: <202511171912.yMOEajkV-lkp@intel.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 21:30:22 +0800
X-Gm-Features: AWmQ_bn6RSoBiaqmn6kqmtyhsS-hftve9ZnkvXr-GPymXU6BoQ87Qrz5mZ6aFLk
Message-ID: <CAMgjq7BbvKUjZprvP+nOgkF59+KnX5PZwuvcfSUChu4pci_i3g@mail.gmail.com>
Subject: Re: [PATCH v2 18/19] mm, swap: drop the SWAP_HAS_CACHE flag
To: linux-mm@kvack.org
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 68A081C000A
X-Stat-Signature: jpuy3bdo8dfxb3zgagb3ddc8mhs1hyzb
X-HE-Tag: 1763386261-551942
X-HE-Meta: U2FsdGVkX18ZVUhksuzOoDVl2EM1Alo5zBdTPOPiP8hIcUCQktckrLd9/fHXCFtD7mTW8VPY3NPR1KWJCynxRGKNi6PS3QXa+NwFh9c0CTFJ4omFEGBm6aLF3aShiLI+tKlX3PE2v8VOEycKrE4wJRd6uF3y9oCC2zQ+iPRuJqNI1Ooe6gLSGHTECUJZhPQcS4fHIWcPs3I4etQ4yQ2xmZzkOW4gGb5AfF7KozdPSkl3PwN7+JrqCgOSYDyyDPkQXj/6FuS7mg1QcYZj9Es6ilzOWoZIw6/12BNyZQcpv0JHUro6zSIFQgMwt02rS2CoW75ApCk8OTxjrLeDdbZh4dN/K2d/gkfH+SwGPWR5WLnAlCnVp9mBNAbxTAsTg85UyGoGLw3EBSnQ2mhbmmmyYQE+PckdARzpahjIKoq/bwBuPn1eGJvdrZFQlztmnVBpr/Yyj//6kMe/dimXILTj72keY3IHTKqXpZvG4/sFbJaKAaiJMAzsY42DT76hEILGa3SAWg3UuHWimfm5eVizy61tqPG/85iSw7F+Ga5sHsR1nC+7kqk+Ozke8LIoRnzR89FIvD4tgiqK1FLQJ9t04INVV3BWS40aNagEVIHO1rtP++jpZihXDC5h4YGRgY0e7yfW8wvk/fQWyIcIDW0pzHQ4R2GzPnGnyaASJHuLWsPUjuQ0nwOVKC3Y7+MwVY/7W/kRp7PaPZEVZlIY6t2UYR36K73mBxj72FQiajn0LXd1BH2cSfjbf0Ecg489eHxBABGjCt4dMStFYvNK5pDV10wLNDJWI+H62TBMXCSL3ajY7kKW0Yeqo4Sv4Hw3ztd/gopOOvYk8KCHdo+G2ptVngmx609gWaKEBfOFrny2LXKtRAl934bPTQPDlE0myVQeNDEpbR4O9JrfgGpdWc/fdZ/DzrAswYEs161g8KaNt0kPzO+QFSOJMfIREN4q3kB/PFQQRv0HUxrPdygdASz
 xbWXosJd
 A7OLT5RLBskQS6LGeXY1CdeALkv3Da6PYkG7u3MYErKFIc71nkGzXiIS/3VcA9jzUtnpOcDKXsIRXHOaevg0FCtPJ6Kh20EWirFhdpLJntnlhp2YQKPQkuRRPSeZ/ciSfwLjHNj9Evtf8qZsIP0Vyqu7+7aXPulNnxWwSYch5DeuySJvs/33MpH14xroqJtAwVs2XmQdftVORjD90638boIMn1QAvND9AHrO/wrAAdMPTc5e2JpR7b3DaJySvotFr60tFcBGVkPw81dGYbI+YfvBo03q5vJApwy4lW+EhnMRxddgzMT3tuDD+M6IB5er7j6mIpCD6Jqaos6I+hJxjuUMjCEDDb9o7RTL5tBU5S0cYg/RXxDWAo4Vfeag1lNstU4X8isdu194/rxns2Wf7BveKVEUQjR1eLVB9NCf9HyZDaBtgI7YYWmPUsTXHDzA8Cz11CA9GJt/ex11E+C3lXuT1VHAU1gYkre3fleMCW806pWKadTWLkZjy8cJXJNqIqAkScXQKBkz9Q1j7693aLYYfv6YuZ9t/FoJ8yKTGe8B9XUokkm0F0/7SVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 7:23=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Kairui,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on 41218ede767f6b218185af65ce919d0cade75f6b]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swa=
p-rename-__read_swap_cache_async-to-swap_cache_alloc_folio/20251117-021532
> base:   41218ede767f6b218185af65ce919d0cade75f6b
> patch link:    https://lore.kernel.org/r/20251117-swap-table-p2-v2-18-377=
30e6ea6d5%40tencent.com
> patch subject: [PATCH v2 18/19] mm, swap: drop the SWAP_HAS_CACHE flag
> config: riscv-defconfig (https://download.01.org/0day-ci/archive/20251117=
/202511171912.yMOEajkV-lkp@intel.com/config)
> compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0=
bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251117/202511171912.yMOEajkV-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511171912.yMOEajkV-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
> >> mm/swapfile.c:88:19: warning: unused variable 'Unused_offset' [-Wunuse=
d-const-variable]
>       88 | static const char Unused_offset[] =3D "Unused swap offset entr=
y ";
>          |                   ^~~~~~~~~~~~~
>    1 warning generated.
>
>
> vim +/Unused_offset +88 mm/swapfile.c
>
> ^1da177e4c3f41 Linus Torvalds 2005-04-16  84
> ^1da177e4c3f41 Linus Torvalds 2005-04-16  85  static const char Bad_file[=
] =3D "Bad swap file entry ";
> ^1da177e4c3f41 Linus Torvalds 2005-04-16  86  static const char Unused_fi=
le[] =3D "Unused swap file entry ";
> ^1da177e4c3f41 Linus Torvalds 2005-04-16  87  static const char Bad_offse=
t[] =3D "Bad swap offset entry ";
> ^1da177e4c3f41 Linus Torvalds 2005-04-16 @88  static const char Unused_of=
fset[] =3D "Unused swap offset entry ";
> ^1da177e4c3f41 Linus Torvalds 2005-04-16  89
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

My bad, should move the `Unused_offset` related change to the next
commit, and remove it by then. It's just an unused variable so it can
be dropped easily.

