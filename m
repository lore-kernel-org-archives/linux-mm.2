Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B27CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 15:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A188E0002; Wed, 27 Aug 2025 11:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E294D8E0001; Wed, 27 Aug 2025 11:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D669C8E0002; Wed, 27 Aug 2025 11:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3BF08E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:07:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 695401406DE
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:07:07 +0000 (UTC)
X-FDA: 83822865294.05.FCF6098
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7754C1C0015
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 15:07:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U0rYzD8b;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3Fx-vaAgKCF4F68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Fx-vaAgKCF4F68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756307225; a=rsa-sha256;
	cv=none;
	b=OzidSIv7LZyH+HVFDmg28vMFU/jPRli4WE40Ybd2aGPN1H54nwyI+HDB+51eKsHHgeDECB
	qDFhmodhwErtFDeyTT3vfBYMeRogoSqfogXiJPaAj36ljJsBwIeFPqnGnyF7F3eAD7I5ed
	d9mzHaiNLiPXJuuMEXoejyYCPSVxcGo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U0rYzD8b;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3Fx-vaAgKCF4F68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3Fx-vaAgKCF4F68GI6J7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756307225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSqPdnAyxvNw1GymbN3dZ2C0dKLRA4fsaE5CsGKK670=;
	b=esSWKCz2ag6ncAABwYDdHq3MYYJ9YmGEgNhIyqNjDdQCxV6Jaa91yMLYzk+KYtXxLT4QL2
	UDzIQOTOXWALexDNLXtdXxwJb2JYgY1Swwyk0SkWGKL1rdvamLzFBinFvUXRIMG3NHxTTF
	nr51MYHHpThZHjMPt7UNKnfWhQ6nYDw=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0b14daso34786135e9.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756307224; x=1756912024; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DSqPdnAyxvNw1GymbN3dZ2C0dKLRA4fsaE5CsGKK670=;
        b=U0rYzD8bAx/02PR628bhlC6MJa5KHtqGDEtVki1q68DcDm+VK1iUw1CqwmMRrVA6Hl
         mqdqKdlEyqDcp4CQe0rOpsUMEbxNJihODSMRTOUWciDwfs4cUOSCFTtdtlIuKL3sednY
         q8qssvRLxpc/BGszv4olhnNXFQZkGxmtF2arD9asN8KS2BdWz5NQ3zjOek/YybEQgaBC
         o84RLivJjcvyWa6dHzhqISUkY9E+4+lL7TcRrnUiIgc9dB65pmSomzkVbCT48MM5xVAw
         RNbSsnHxC6bShUqt3+M2RY8eKVqnwG7keOSYC8VJNk98eYVb6ISrUNDRXvkgAW82B3rZ
         7psw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756307224; x=1756912024;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DSqPdnAyxvNw1GymbN3dZ2C0dKLRA4fsaE5CsGKK670=;
        b=GIyC+aqOE3IVlitmdxNwHUmDShIU0DVTBlTdKvKs8EGcD7+538S2PXEouDDr0fuTgq
         eBBtbFs+aC6GiAw75s8b7ONgOagCJ7BGOVhMf60ZYJXwvl2pE1V4kiDRgytVMtDVNQAj
         wOP3ihMEcT/lWj/ylpBizReC1uJymx7zASQxIvzMxkjiXziqbY+W1jyjie1SC4kUOSZO
         +0D9dYAZs9+naCIuUURyuLomSjtlsWN3bssyU+WFBBJXdl7vjyVlt63RQpRYtrAaljLZ
         KJKM7pHHoW4MOHW4ua0kaGe63o9u0Cb1MT7HOUGoQBP7Svsq37vOj96B267srl7O5KRC
         qQpA==
X-Forwarded-Encrypted: i=1; AJvYcCUYjjw+R/GpkNuqlRIrbh5yMXu4wIBUISh4O7hQif1u2N7RPkcVhMssO9P1h8zneXwTgPO49JMPlA==@kvack.org
X-Gm-Message-State: AOJu0YxVicA19PBrnEstgVERZyimPaYjIlTC9BpA91r6KIVgw91dEe4s
	0HTHbnwu1z+fIP8beSN4h/zYTQV5G99UOx47dMolGhh/HE33GbeWhO5ILGtYAs5KbGUoHzUiSHJ
	rpPn4VwWs0rydBQ==
X-Google-Smtp-Source: AGHT+IGRr05GsIRQMcF8EAluB3xZgaBgbSIfWdSJS171uI8/dhBlwR/KmE2p42NGR+iVV+ke1jAdt1Sm0vNRKw==
X-Received: from wmbdy5.prod.google.com ([2002:a05:600c:6585:b0:459:1810:bf51])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a46:b0:456:19be:5e8 with SMTP id 5b1f17b1804b1-45b517d459dmr170501745e9.20.1756307223741;
 Wed, 27 Aug 2025 08:07:03 -0700 (PDT)
Date: Wed, 27 Aug 2025 15:07:02 +0000
In-Reply-To: <j2vfxy4sr6wmuovlynvljvmy6as7esevp57hyqkhofxnxnjldf@ul6befrh7eqy>
Mime-Version: 1.0
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-1-5d3a94ae670f@google.com> <j2vfxy4sr6wmuovlynvljvmy6as7esevp57hyqkhofxnxnjldf@ul6befrh7eqy>
X-Mailer: aerc 0.20.1
Message-ID: <DCDAY7MCS3CS.2QJ54F8Z86WN6@google.com>
Subject: Re: [PATCH 1/3] tools: testing: Allow importing arch headers in shared.mk
From: Brendan Jackman <jackmanb@google.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, <linux-kernel@vger.kernel.org>, 
	<maple-tree@lists.infradead.org>, <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7754C1C0015
X-Stat-Signature: mboxhptwx83dp8gbm7oc8wub8xb9c7qe
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756307225-363676
X-HE-Meta: U2FsdGVkX19xtUdbBh26OHuNTX5107o+Rua4UO8lv7VykFO5jMD/vq7p2nN15+55huU38WMjcQlkMT8DbbtVv04d8Fq35dEwHfR0r407NnXTsJo4FLI1NT9IXXhccoMNMUh5H/+7sX5ixq+8TBtjNnwDw6subt41VVvLwuPLdKsL1gOEREMeW8dxtML/psrvxdNVFh2ENcBIMNBmSBvOEIOeO7B6qa2k/L6DBkKq00vlz+obq3p4IPD/4WYmY2AvxssrdnLiLnbI2P49/e5eQywJf39c4ku9m0zMWFgYsq7evRSvgnvAM7dDDnJZorgFr+xJfFW+XH5NYa7o9OplbrO38hsXMIoeZw07HAye1J1Q7J/fQwjQq9rfS26I62DkaWXWMVCsm+Hi0nz3TPKppwf+l8tnNUVTvXWs7l0WnRE1RWre1OC8wCmPnuT9OgHep4zJVla+BQd38GM/I7s5cI5KbmIKvXzJrtpdAtwn5y1COOqCWL+WDKihM5b2zzD7HyqmBBcnCVtu+zJER8IM2ciF1/kNhRLcRkMeTs59Pmj7sA79r7YcSoEk5/0BGd9xMHhDgHLrVclokmEH2NmrOFywQpsbzQSUbool2lLVWEh++F0wdC0+jxuQUtoepC3EWTFQUCV2XtQhtlvHvEjh98k7HVx4bRmschVVbRklzjUHIjAkSc3lHQ+RFUkVGmJNKdPcmYUKBZ2/a6hI2UaOfMSlFjp5FD0NIFd2hNeORG0V8IQMO9oUlXdQ4k3PdOhdJg1xYgBW0jd/QzNYUzMoraUDb8IXKFHm8SxPrAFVpB7XJ8n2PyhzJdV0PJ+3fbj0DYnmCDiuU2Kq7SFsw1103lkEAHnVyaNTsczj3WZ/+Z8jNGhULJNPAR8vartvujno84GsC84Sei0YCTb+8ijmB/R2Y/vQa+U95iYOofyKqBhcroO6lGoNXK3eOiHf2Q9yDOXBhLXlUMoL3nJiXiy
 BulsBDUY
 Z/GxjDzGStzyiZ7MPVPDkrxrtcLfCOEqeKIEERdHMxYKokybfso1Hz74e8OTxZSjO3ynyvAYSNJ/gDleRyLtihjE8+uPwBACWf6BCemA/ceKUhh8yzk5tzVUvUHEMlYTdSGghs3w2yvH2v1d6RamOI52fPcn2+h9onSCb8rBUsaonvOBpRuYBF2A2AmPM/WJaxf3Lywmb9rdvoD9n6F5tFFTgcid8YoKb2MCojR+FdEXvHZ/7RUtT582RVLEUmOfJP4oRkegD8+RgnYoupV99ae9QzvH+n2mDDV4x3i00Hw1KrVGE7OXrIpdHSspHJHkEcXhGpz7DNmem/RStNxPAJai9cpDnEY0zyyHiStvOJrSQ1DU6sBQSLHsUF2ay8AoQWReV041OUo8fuMET/YAfYAk4VZjBzm5w733Wqjo0Yafc4O3KPbw1wUQun/CpiIN10tqktjtvcnoD7Li54yw7+BZkQB0H1Jq5wBZc65huJLoWWE7uKIyKDOaHzdGIlDhIM7atSkqM9VYDV3a3EUvN5xoxsll6UMyyMHNeuJny1/jzf40lFBzyJDdXCjox2ETBDYLabNjCFyRC0AfBvtA0ymlt8ggjalDiL0UleS2tV7TBogOZUHXiQ7EP18Oi8md86qNh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 27, 2025 at 12:50 PM UTC, Pedro Falcato wrote:
> On Wed, Aug 27, 2025 at 11:04:41AM +0000, Brendan Jackman wrote:
>> There is an arch/ tree under tools. This contains some useful stuff, to
>> make that available, import the necessary Make helper file and then add
>> it to the -I flags.
>>=20
>> There still aren't that many headers so also just smush all of them into
>> SHARED_DEPS instead of starting to do any header dependency hocus pocus.
>>
>
> I was a little confused as to why this patchset was safe, and - yeah - i =
missed
> the arch/ under tools/.
>
> There are asm-generic headers so hopefully those fully take care of !x86?=
=20

[Confidently but wihout evidence] yep, without a doubt!

> Did you check?

Um, OK that's fair question. This doesn't support cross-compilation so
you actually need a non-x86 environment.

<begin verbose notes, tl;dr: yeah seems to work for arm64>

I have Nix set up to build aarch64 binaries via binfmt_misc though so I
tried using that...

=E2=9D=AF=E2=9D=AF  cat /etc/nix/nix.conf
# see https://nixos.org/manual/nix/stable/command-ref/conf-file

sandbox =3D true

max-jobs =3D 96

extra-platforms =3D aarch64-linux

So I dropped this into the root of the kernel repo (and `git add`ed it
otherwise Nix pretends it's not there):

=E2=9D=AF=E2=9D=AF  cat flake.nix=20
{
  inputs =3D {
    nixpkgs.url =3D "github:nixos/nixpkgs?ref=3Dnixos-25.05";
  };

  outputs =3D
    {
      self,
      nixpkgs,
    }:
    let
      system =3D "aarch64-linux";
      pkgs =3D import nixpkgs { inherit system; };
    in
    {
      formatter."${system}" =3D pkgs.nixfmt-tree;

      packages."${system}".vma-tests =3D pkgs.stdenv.mkDerivation {
        name =3D "vma-tests";
        src =3D ./.;
        # (Pretty sure this is not the correct way to do this, there must b=
e
        # some mkDerivation arg that's equivalent to make's -C flag)
        buildPhase =3D "make -C tools/testing/vma";
        nativeBuildInputs =3D [ pkgs.liburcu ];

        installPhase =3D ''
          mkdir $out
          cp tools/testing/vma/vma $out
        '';

	checkPhase =3D ''./tools/testing/vma'';
      };
    };
}

And, yeah at least it compiles, and that checkPhase should have run the
VMA tests:

=E2=9D=AF=E2=9D=AF  nix build .#packages.aarch64-linux.vma-tests
warning: Git tree '/usr/local/google/home/jackmanb/src/linux/linux' is dirt=
y

=E2=9D=AF=E2=9D=AF  file ./result/vma=20
./result/vma: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), dyn=
amically linked, interpreter /nix/store/r0pjdp81mmd7dvk5pv1ch75hrbbw60xb-gl=
ibc-2.40-66/lib/ld-linux-aarch64.so.1, for GNU/Linux 3.10.0, with debug_inf=
o, not stripped

So... that was easier than expected :)


