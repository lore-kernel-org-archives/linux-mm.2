Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A6A1CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 05:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E268E0009; Wed, 12 Nov 2025 00:18:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965508E0002; Wed, 12 Nov 2025 00:18:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3728E0009; Wed, 12 Nov 2025 00:18:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76BF88E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:18:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 23DAD1A032C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:18:48 +0000 (UTC)
X-FDA: 84100800336.20.19ECAA5
Received: from mail-il1-f196.google.com (mail-il1-f196.google.com [209.85.166.196])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6795820005
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:18:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OOH1pNo1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of arraybolt3@gmail.com designates 209.85.166.196 as permitted sender) smtp.mailfrom=arraybolt3@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762924726; a=rsa-sha256;
	cv=none;
	b=N4kyeHG0w0P/YAAB8pfYWq3ChuEAW7R9xiltEu0pSn73ajcsrSLNJmvktAiSEckLwwXA0U
	5IGX4UABJvXc850dqWRh0RoSZKXUvJhUKOe9lLS5yilXc0zDk3B1ceCbhFJsoK/N32bRCl
	R6bwBsEgHbsTjnF8HXYvxsyF8h6PkJA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OOH1pNo1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of arraybolt3@gmail.com designates 209.85.166.196 as permitted sender) smtp.mailfrom=arraybolt3@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762924726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ezl4SSQLTdq74CW82/F96/qsFWv/FcEbMyqJZMgIA2A=;
	b=Hv8OtmrlQwvR6pndS6umn2KmkyGwD845jFRKnRlLfc+IeSpqb/rpKHjjoAcKLYdb9X6/GR
	2QomPeXpBq47bO074qz+7oySPU2TScLZz9OYhSju+PMiDPAxWTx1RIO+Pf5h3zw79jOH0l
	0Jsle6Hco0kTftAAgKF76jx/xwSdK10=
Received: by mail-il1-f196.google.com with SMTP id e9e14a558f8ab-4330f0a4846so125885ab.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:18:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762924725; x=1763529525; darn=kvack.org;
        h=mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ezl4SSQLTdq74CW82/F96/qsFWv/FcEbMyqJZMgIA2A=;
        b=OOH1pNo1L5wEA69mdJJr+BAzM8HUlt2rwXiZwBqnW4EREvewLIGHUBVwzlN1M95Pbc
         NSAFx3QfLLcx2htG1fwUH112HGVQEZmzsOfjSem/L7lEZmlt0p1r5px3TRO7U7aV6twD
         2NO54xR3a6MI2/DaSE0ylDXEQ5WQoE8+TLEnBAqy0DeubvmBo0fUoGMbNGSCJZ7a8HYG
         en39kG7n4ZxE0eyd1osBkBglaUIHtBAp8qgha9KntRlJHZOBejpiBxaJAmuBR98XOSTv
         FxQZdmYABZVkIG7V5PWrm5hbZJ5Ze0c0PoDcg5/0tpnHZlJqGADAnqsDjk/t6xowgxbN
         5Wbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762924725; x=1763529525;
        h=mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ezl4SSQLTdq74CW82/F96/qsFWv/FcEbMyqJZMgIA2A=;
        b=Lv99Sg/4zdSCuAgKtJMmNGzqU5PDIcGdVLhq9vDMRQy+IIGjpM3bo90deEna6dldqe
         eIJgr8sbqiHGlIYSmHTkpTS5focxzksd55pR80vKELSYPSISpq7t3XhtkRbAO/mZk2aJ
         wEGvIvbG9PcniqpUmgI3KjKgNTKuvaWmyTyrewKgDgkhr22EI6zG6cFmmoK9H5WIm06d
         1ImAG1eX+FC6d7zlzGUVIGjm3L3A+XH5bzmyXz1rnWJ7QXkB7260JhdhmFazw80m9ZgV
         VWCcfZWDzVcul4e3p82g0Z82z9onVLc9uSmprimrFTSytnvEgXKArqM+FUL9FDcnAKr/
         bjsQ==
X-Gm-Message-State: AOJu0YyWeU7BTHNQ4jzaEGd0uELgZN2cWmgZVJhPIZ1QvyWKo5Hofma3
	REkBhgJIMlyf6JmmRJEF9/d+pDY5dRX5rzI6oMnsfIiCa4w4/bVoy4xaawKzir9x
X-Gm-Gg: ASbGncv/lHoDZByjKiQvbIUqCEtt9vsnL9erpU/xNu4h1G16C/bmdTxO6C4TKb/gS7p
	FPK1sUtRcbp//IC5Wi8k+FwfhR2kKwtpMkARHhLwhL27LI41xGL7sU6AqVi5GlujSz2D5uMMsGX
	Or+ALY+IIFE9D/YNzMwDXaAvfsWMvDEc9wl2hUkXlF7Ns5jrlNfNilrZCg1wHjHjdxIZqMfsCsO
	GMLlS1RPAgOk5yPOVRf66okNRYjcwl3jDK5+OjAs2+etRfLzRn32291lkGuY3DcVEGE8zwgloHi
	cB/l+UAMNCnHOSkzQ4Ln8W2n7JhuXAeWZ6Vt/U10b40VFthPxmDUZ2MFEmqpjaMj0NuUUsU9RHg
	ADrZgRWGw3X5vmecHpqWvyjN/ujd1zu63eSr+Ag5Lf4y6Sx4RPscmnhMe3GrfpKe9hT9FIPE1N9
	MPqlcUIgOF
X-Google-Smtp-Source: AGHT+IG+CGWHKYLx/mgjt5y0vC6+WM/NIsUYelFqXQlQ4OGrBX/1QS3A/YpW77DPQRnBU2qp1nCKvA==
X-Received: by 2002:a05:6e02:3807:b0:433:2421:d752 with SMTP id e9e14a558f8ab-43473de377cmr8414505ab.7.1762924725169;
        Tue, 11 Nov 2025 21:18:45 -0800 (PST)
Received: from kf-m2g5 ([2607:fb90:cf2c:12ad:3e02:9a49:f465:3655])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4347338d4d7sm6753305ab.20.2025.11.11.21.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 21:18:44 -0800 (PST)
Date: Tue, 11 Nov 2025 23:18:35 -0600
From: Aaron Rainbolt <arraybolt3@gmail.com>
To: linux-mm@kvack.org, cryptsetup@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, adrelanos@whonix.org
Subject: Hard system lock-ups when using encrypted swap and RAM is exhausted
Message-ID: <20251111231835.1232ad8f@kf-m2g5>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.41; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Z4RQJJ68rzCF8i_e+DrlMou";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6795820005
X-Stat-Signature: ewnr47oeu7sp6en81gnh7tfuqjzqk15g
X-HE-Tag: 1762924726-570663
X-HE-Meta: U2FsdGVkX1/ukfWn6bp8oyz5GGYUijNp5yS77YuxkJSGziR/673oGkCOQTkfWDxu219dYXVI1kTlBZgzpBkVJ6sMsrGzxit48t3uYJI7X/A43483ZMb+2oYP+YYGHFexc3ohr2M9ALiIgyN4Jl/LAo8lG9xnyhP+dv2BThXWk/6qBXcEhMj8M6GaErXkZVXLgEDBw0jI36xnoT8eMQ55bJGRg/g61vb0C+fnKtIctkrzgkHhyq3fwMfiVgZrFPz3g5WxIKNrhFHp/lfeP9oA/NC15oLIc3co4icdloq4Fce+Rtt1oEgzUANZjYEcnSr091LQRKQ2gxpqs9bmHqWRJLTJqo7+GjS2CvNN2CSOhTxR+OCKKFZyXAOBOqfBNY8bDSKGdLTMBuzVIPMAL9+Hqz4KDoddF/Eo/Oj9hBWtezkusgO1KJ6z/UIqUa5Peqg9oYPfF82V2UAKGNf+LkYK7xcfFWIVhLKSbvm4uShbq3mfWx4lNzU5RQ9SBFesRCItC7jxIe3oQQjrVcUFtHcTtkcaWR8cBfobNibnrgMOtPB08YTTRjaf9VU6KuysSpaPI77c36KDp//XSJXyudd+X3Iforf1aMB5MHb64n/WQklYs0ry3ZCjaAM7aInCbn4KKWnXQNOQKU3TihTlVNNY0VpuchDwU0d+Uh42MO53iUAPCOF/uc3/ebz47BnwgWtshV2g1oXQvPYAknHre4ipyyHrX8fL4z0IkKUzChNoH1JiKU44RmJkecCJfrCZPzz+kJfUVnguSdSULanxxHEAj6vt5xZummlQjlb6NNPpAe0vKvFvYilQG9AWjNUSULCL4dJltQ7zC2lwYNf7j+BPN8hnTgkdrybf2I/54ninlfFMAc9/TppVJiJui8psGf4bCLJ8/Mtv/TZn97QWnMT4mk8wgD1wgBEkfkw3Rqca8ENHERUYfiZneNaAIZg+loNc6uK8GKFHlQasNWiDgMs
 P2t67nG7
 ZEwZpgF+DagHvGFJgy2ukI19oIe3xpRZeuYZCTMPZ6x4G4pYUSr5fAweeoS0W0z92frw9HEdWcXMK6TLK9I1ybyiRmMS7AjJLgKcAJ6hcKAfH502gXxVh/WGEem+bpVac4G5DuKs8OG+uB+Ws3QmYLr/bE6wcziEF8hO5mkqgoT1WhO+rv2Qzltx0tnQPHOnoloAGHNvXZV04t39l0J6Uyew7fKWeUjjmZao0VpDfDUPG5eDDsMgl/CrfVgkDA1shwRsaLwVp9nicbYcSbTAvvXJNb4RCQBx3SMc3xH0z2lqSuwoslpAOlrPO5LFS/83OiKXU8d2+ZSwKFK2DMZ4B+LFEz/8R+QRA3Pu6HoESU7qDCxey68hgrjaXflQA9DPQ3bXDDZsxOXs/cOIA/L4EnXas07f/8ZCoQFy2IHPELhkn9gTraO8mHmRjcwFD20VGOf6H0Z/l96hSVIIZJ2LqGyhTFYLH+iSX922PmA4gG4L993EN3F1BcSkd0QYZpaEKXA3PyO2PM8+Gx4nMUxt/LP5BZYy+bbyHsPDtSuF2tEKNGaXXOH/vE5G/5bsbPujGM5yIvyYHvaPSJLvw5aevqw1EKnCidYkIzni/e79fTe0D2viQnRB2ZPVTiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--Sig_/Z4RQJJ68rzCF8i_e+DrlMou
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Not sure if this is a memory management issue, a LUKS issue, or both,
so I wrote both mailing lists.

I'm seeing an issue with both the latest mainline kernel (6.18-rc5) and
Debian 13's 6.12 kernel package. When physical memory fills up, the
entire system locks up hard, as if it hit rather severe thrashing,
despite the fact that there appears to be disk cache that can still be
evicted, and there is ample amounts of swap space remaining (gigabytes
of it). This issue did not occur with the 6.1 kernel in Debian 12. I'm
seeing this occur in very low-memory Debian VMs, with between 512 and
900 MB RAM, running under VirtualBox and KVM. (I suspect, but have not
verified, that I'm seeing similar behavior under Xen as well.) These
VMs generally use a swappiness of 1, though I have seen a lockup occur
even with a swappiness of 60. The filesystem in use, in case it
matters, is ext4.

To reproduce on a system running Linux 6.18-rc5, with :

* Follow the steps from
  https://gitlab.com/cryptsetup/cryptsetup/-/wikis/FrequentlyAskedQuestions,
  section "2.3 How do I set up encrypted swap?", but creating a
  swapfile rather than a swap partition. I created an 8 GB swapfile
  with fallocate. Reboot the system when done.
* In a TTY, open a terminal multiplexer (or something you can abuse as
  one, Vim works well), and open two terminals. In one terminal, run
  `htop` so you can observe memory and swap usage.
* In the `htop` terminal, sort by M_RESIDENT.
* In the other terminal, create a new file `test.py`, that will
  gradually fill memory at a relatively fast pace and print an
  indicator that it's still alive. I used the following code for this:

    import time

    count =3D 0
    mem_list =3D []
    while True:
        mem_list.append([x for x in range(2048)])
        count +=3D 1
        time.sleep(0.002)
        print(count)

* Run the script with `python3 test.py`.
* While the script runs, observe the growing memory usage in `htop`.
  Swap usage should start at or near 0, RAM usage will gradually
  increase. Once RAM usage starts getting high, some data will start
  being swapped out as expected, but after a short while the whole VM
  will lock up despite there being gigabytes of swap left. (On my KVM
  VM, the last time htop updated its screen, it showed RAM usage of
  712M/846M, and swap usage of 328M/7.40G. The python3 process
  running the script was consuming 551M memory. The VM is entirely
  unresponsive. Incidentally, the python3 process also was in
  uninterruptible sleep when htop last updated its screen, but that
  could mean nothing since it might have come out of sleep between the
  last screen update and the VM lockup.)

Under Bookworm with Linux 6.1, the Python script would occasionally
freeze, but the VM would remain responsive, and the script would
eventually resume. Even with kernel 6.12, both unencrypted swapfiles and
swapfiles that are technically unencrypted but live on a LUKS volume
both behave as expected. It's only swapfiles that are themselves
encrypted that seem to trigger these lockups.

I haven't looked at the code at all, but it seems like maybe memory
LUKS needs available in order to operate is being consumed, thus
making it impossible to swap anything in and out of the swapfile? That
seems like it would cause these symptoms or similar, though I don't
know.

Let me know if I can provide any further information on the issue. I'm
happy to bisect the kernel if it will help.

--
Aaron

--Sig_/Z4RQJJ68rzCF8i_e+DrlMou
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEudh48PFXwyPDa0wGpwkWDXPHkQkFAmkUGKsACgkQpwkWDXPH
kQk4ARAAqk9d7FDHR97lXxeh1nY89u028mDQ/739cRtbBMzWbgbiEsNkgGPq+L+M
Umbu80ExIyDXuNEE2fxWsYvqguj4YI9nuOFHIX+PGIGagiYFlwWlnaQcrmO8PmA4
A9qXirRq+PxxBYMwsEcS++DafDtoH54fHMGjhKf8KCi/DmwES4bdbWkHRiYojmYE
CpjyvLuCXOiXMe/pAgzfp++EpBX1AiF948MFKf6/a4qagycypVrX8AWluIVwEjBw
w40yZjZ5t5Fwm6F86VfnalBf+YGFOeiLUbPe/+deYmhQUHSc8RXGq7SBaYJJhCpq
lE90ypvTOCRnhGSe8PaTOvekAJhCzVCFqyUmgsUHAkb7uOKcdiaNVKJdpS9q6ZWf
UF5vhWZ8AEe2qyISOQW4cFRsNF4MMxyJsDbi5XAJDii1UP+RoAJfcdvljVKfSfnD
A5VXJAMmtCUFak67VYp7Cr8787LOs84b1HtjLpGH+aWOx4csJWKyKwq8KBbxayon
DHW36A/8546cgHR2/P8ke8Hfi5QI+qq6v8M0ACCoYUsKXw/MSttNa4H7To0F+MW7
9XUYisaBv/h0NM38aVl1E6FnRM/9HlBzUYmGVJLGg02IIZkqM77l0eJHhz1wVnm7
+h7ExBaCaI57vjOkHGm2dH1XitrwKCjAWf4nVlzs+P8hOzLDSFM=
=xCmb
-----END PGP SIGNATURE-----

--Sig_/Z4RQJJ68rzCF8i_e+DrlMou--

