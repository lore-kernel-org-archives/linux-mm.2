Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CEDFCFD2F6
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 00:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C584D6B000C; Sat, 29 Nov 2025 19:57:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C090F6B0012; Sat, 29 Nov 2025 19:57:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6E06B0022; Sat, 29 Nov 2025 19:57:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B26D6B000C
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 19:57:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2720F140281
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 00:57:39 +0000 (UTC)
X-FDA: 84165460638.28.7D1CE89
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2D2EC1C0007
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 00:57:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fuOjXVgz;
	spf=pass (imf21.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764464257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+g49Om8KV5+AE4pKbmfS5SsSZ6jAm9G/Fr+ete77Gs0=;
	b=F32ZSQ/LKZCUk/7XSpijlmdPU+n3yMvVlMcPtVLNcZc6ox15fjDM2QWRPSayLeZcDQIAWc
	PAQfEgzPyym33oaGtJA72y+F6rXqfwgT74yZrMtKEJXlBJ9hmuBNNvL3i8tQpoIrfZpDxH
	mumI2p/mDTJ/qKtq+NR20E28HPRbWWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764464257; a=rsa-sha256;
	cv=none;
	b=Wiy9KQrXODwWfdeeTh4ule8QKSUr5+WwfOzKb+IEbwfI1K5dZWoa+x4vi4zHqtV9X5byPv
	ZRq2TudHj9S+YC2l2ZWNs3vEcUSw8EcELt89Hd5hr5f7mJ1Ch8ioIbvN+r3qCbozMQGTSD
	FNrPRtzorbzGsmApH5B0ekBJ8Fhc4PU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fuOjXVgz;
	spf=pass (imf21.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-37b9d8122fdso27323601fa.3
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 16:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764464255; x=1765069055; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+g49Om8KV5+AE4pKbmfS5SsSZ6jAm9G/Fr+ete77Gs0=;
        b=fuOjXVgzLtWsL5jqdcsepwzvmfMfgczBz1YyO6WzirEut6bol6xiDESlit6RMG1pTl
         Nxt1G4FLqxZVmPX1qud4Cd1XhBt8IBYL+bE0Skv/yDXqR9zqjDugN8Mf7xzOYDwH3jNe
         F8ggxdOURjtJsabwi/FnRYFdTVCOpYoJ+JZaRuHYFbPMt2qm+oL9iSLTUKL5tA25reGH
         kPZC5KbnXBo4ATZatIVSotrFwM6a7KLV/Yw/mZFn3g2a25aPwVEPoSmI6RTHHR4S0mhX
         4JGFedEJYNXDKagUzByDEQGD7Hu4L8t3+C6WPAkUN1YuypyEoTzXHNGG5yA3o7p/SzFI
         60Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764464255; x=1765069055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+g49Om8KV5+AE4pKbmfS5SsSZ6jAm9G/Fr+ete77Gs0=;
        b=J+so6UK92pr0PIfyS/kB9EkkOHQ0HDzqosNW49HcwHnnFH334rzRQF1sSu2E2hsPZp
         VJLuLrXMOEhqzEOLiYSWDEToF7YJ1m4+raXe2puPGsNjqbQReIvCcAd7oP0vm0zoOzIQ
         WDlSDP5Ntvr8TYjTQKYv0mrS7ej2Vd8v7Gx+T+yB7tlhxhOqG4cy6mbpx5x2Qs6isOm9
         foLyd9HTIWFsqv8wA2U4kCc0NJNRE/epNRIy6WJjrNSY7iNyktnkig29fvNOSPj/y55+
         mVkJ5lmhWl/l0mQtiJGSk0oNDMcqzCFuYV2Yx4G+p0An++6C5GddeCamINjjhAjaAPHQ
         CzUA==
X-Forwarded-Encrypted: i=1; AJvYcCVQjSCGPakBod0j4ExK8tLHciABwmXPFJS7VMIOqRnoXtQrmEtkJzFWSAunLLEf4KAGXeWuCLRQtg==@kvack.org
X-Gm-Message-State: AOJu0YyckZDc+3cy9TiIfgZds9YQV2gWpZe8kC8FGCM5VfcUaLIWTKXB
	LpH2YtnedIw0fezUVxypB+EaHG1inG6WpuAR5ICXKXehCHUDx1LEti+/
X-Gm-Gg: ASbGncsaVitklxiKCNX+YcnT/cuaz8d3LSVurgD++OhbehneqQ9i8tmMxDZF74fBUnS
	KfcZlNhd+6VtRBaJAcu9LtMYOM0p0sX5qyttoeTP0wxq9b1C6OIf/mQZvVL2Yu2vZISkELxCoYj
	WJWmtLJheynjwsuYOCL5glctjtEjvJlDeUIp5lQUJBb5JEuXA8euQgUrB7394kE0s8B7Tva2n2Q
	Th3k+g0jYE1KgZxzsri3mwDgPg2w1FPRFTeAdtBZnqO5zzpAklS3pgRROMoebKNWNWt0wNOKNmG
	zdGnU/BA2AHnto0I364EDoBJeuPowDnycj+rzeMgsWVZvcliuq0RvYMq5S3AXXHgcnx0jcP0htB
	ljiUp47bPkesuHgsYzGSdgtRolEO6ZdrWMWfkXqDA5sp7CoQlUsWJUtHcKjOhbKo4rh/uh1Qaiy
	GF8KBRecg=
X-Google-Smtp-Source: AGHT+IHqqLvvP2sfFnTWOisjSIYIhy2i6Epx2GFFCPJmKULbpNgQPdTlRmyFokY5qYTyoqCENRLjrA==
X-Received: by 2002:a05:6512:ad0:b0:591:c3f1:474d with SMTP id 2adb3069b0e04-596a3eac18bmr9392825e87.15.1764464254932;
        Sat, 29 Nov 2025 16:57:34 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-596bfa440d8sm2303111e87.46.2025.11.29.16.57.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Nov 2025 16:57:33 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	rafael@kernel.org,
	Milan Broz <gmazyland@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Sun, 30 Nov 2025 03:56:56 +0300
Message-ID: <20251130005656.3644711-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
References: <b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2D2EC1C0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: aoqxx6nr6wza7z71313hp79cg7ugsnw7
X-HE-Tag: 1764464256-184373
X-HE-Meta: U2FsdGVkX1/QI5SZld5c/ib1bJx1yjgHowt0dMMBYWPC5ukth/sLGVOaFvqZSNgsVOoe8nOMcKfnuFyJubhMoV4b+Pviz9z7ERgRZtpej1ASQn+NrXrMWlv9pToQz3q9sFo4bnr/tR9E+fTH9vYgmEBUqEXn412NCVg3qV+VHVVD/f2X9yiGnPvNKO6M62QHzbZmclFfNGW/fKT0c9T5r2uBAx2El3oiTm+D6FSPFJh650zpuEkAY7bU1dvRhoRja8MtuG2Rods+S4HjLOyDWgkPJ1l2mdNGdqKoiCFUpDiYKgbagA/nPzDg+8lj/2fVWWv5Q5TdacQZoSEuoyQ2t/S3CB7hYXegzyLFy+nYLR7MsfOx8rNq369yK0e5Wutkb2QGpKlRgEXLRjx1EL/b/r7S5DjhYbkZ2HHXJnNXs+PDTxPpP7gWZW0JhOA+fE5xEX9hdua82+2u6UCaNy094rE+R2Sj33RlVOXLJ+NAcx5nP2EQ2CD9hv5YUeHck1/nzv8WucZuAi3nRo77S7TQgaiJVYO38iWMKbrjbOsEg6yVpRxRMY42ezgMUu7fzAWtQ2iOgc08eg7+LPyPqh4pqL44kh/pbs8z6gEKw779t4tjsYiJIus2F6KyL2V0LyYRRBdCgHQji/I0Ch38K2XFteOchrEXP0p4QksdQ95MAulcre+FCo7JgNiqiU0mDVxXXm+AgKe+QHYxnETvz9LxG/WrThM8OYKM/nYQ5agxXJf8Tvad8z8ZbtA1FqYHIMhpmYwPgQUGS4LHpkmuZ09pjmtG92tGWQG5RyCN/9ewhY+46eiwciMG/tRwhBIKtm2i3V1ewIVr8gRYwVE0XUEwe51gDTHaFvKqZlhDAlkcWXDVfMxHTrdHGT6ZDrN9evVIHdfYsmm2Swd3UPgUOjk8OsiSW1457epB8kvnMmtTo9lVg6Iq07KArDoiJlJX26sA/QbSsgJsh1h4qck2y3w
 Ey9LM/R/
 cJF+SUBFE/CHhdbTdtaacByq0pDeXz6NSwDMVKcgZwn4CenFdFdTL8G/kiCkC9TyWGSDu4OWl4TdG4fbMKQhsmCx21QhpP/x1UeEdORaCYK7Wsf1EJakPA9SpIWpTVhTC3NAD4Ajmqdc++zZ/eNuc1r4Qwi2NzHMxSNIBi20ZTC+r/XELnNYaxfn3ifZgmjFygCsYVhqgqaUQQcYTPpdDqCXRHb1qOKBN1PUO3V0D3udek9iDxhA6z9pOtHIbAzxtpQrpZFonenl8gKTy5xYL7KgMejmPuHSS0Odsszy4w3pUjA4U+ihdRgAPs9eH35PLRuWUYyMP1+pF+87riZ17i7W1iJN+5zTZcI6AqPh9L8eEvA9dhpY/r/TZCVqlhj3icXcPk8F51H8YwmBPSJzVwpJpUdDzI3dnXUgQjuuF5vpK2eEmsy1/gjO+sOs+yz6+uG4SWl7AFlMGQHDO8Kun3y92TD31iOofProJWoH6dxby7C1oB1qLOUzESr2IvHSoy6iqrfi7mkSUbAkejR7pKSAHTFqba9fxvh8J1z8rG9uWTb3irVl8HhISi5YJ1Ym8hadwrWI/3MYwrAh+adKD/P/FewfvkPDInq3o6I1Yhqq0uCBSbdLzgYWAQdtbYt2dsQoKHzKjSs3Hms3DUHIjf4RWVTwDHH21NpmN16HgHbGKaTov9rtwr+fCktVDoQUIxqSS7PlNcQWj/520PZHfJFFPCyHU/1ViXQW511jlg6os1d4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mikulas Patocka <mpatocka@redhat.com>:
https://lore.kernel.org/linux-pm/b32d0701-4399-9c5d-ecc8-071162df97a7@redhat.com/ :
> Askar Safin requires swap and hibernation on the dm-integrity device mapper
> target because he needs to protect his data.
> 
> This hits two problems:
> 1. The kernel doesn't send the flush bio to the hibernation device after
>    writing the image and before powering off - this is easy to fix
> 2. The dm-integrity target keeps parts of the device in-memory - it keeps
>    a journal and a dm-bufio cache in memory. If we hibernate and resume,
>    the content of memory no longer matches the data on the hibernate
>    partition and that may cause spurious errors - this is hard to fix

Let me add some more info on this patchset.

First of all, I already solved the problem for me personally:
I wrote hackish patch, which fixes the problem. My patch is tested on
my real hardware under load. I successfully use it for 2 weeks
(I hibernated a lot of times during this period.)
The patch is absolutely rock solid, and I absolutely sure it is correct.
Unfortunately, it is not generic, it is tied to my particular configuration,
it hard codes paths (!!!), and hence is non-upstreamable.

Here is this patch for your information:
https://zerobin.net/?ad6142bd67df015a#68Az6yBUxHA3AXB7jY1+clSRnR745olFHAByxwPGM08= .

Feel free to use code from it.

So I personally is not in hurry, I already have solution, which works for me.
(But I am still available for testing.)


Your patch has a problem: after "notify_swap_device" call, the pages can
still be swapped out. "pm_restrict_gfp_mask" call in "hibernation_snapshot"
prevents further swapping. Thus "notify_swap_device" should be called
after "pm_restrict_gfp_mask" (but read on).

I attempted to create test case, which would expose this problem. And I was
unable to do so. Still I believe this is a real problem.


Also, our problem is very similar to reason of introducing "filesystems_freeze"
( https://elixir.bootlin.com/linux/v6.18-rc7/source/kernel/power/hibernate.c#L824 ).

See problem description here:
https://lore.kernel.org/all/0a76e074ef262ca857c61175dd3d0dc06b67ec42.camel@HansenPartnership.com/ .

See also https://lwn.net/Articles/1018341/ .

(See also this huge thread
https://lore.kernel.org/all/20250327140613.25178-1-James.Bottomley@HansenPartnership.com/ .)

"filesystems_freeze" logic is already implemented in mainline. It is gated
behind /sys/power/freeze_filesystems .

As you can see, authors of "filesystems_freeze" attempted to solve similar
problem. Thus, we should probably flush buffers in "filesystems_freeze" call.
Ideally, flushing of dm-integrity should be correctly ordered with freezing of filesystems
to support complex storage hierarchies (i. e. swap on dm-integrity on loop
device on some filesystem, etc).

But... call to "filesystems_freeze" happens before "pm_restrict_gfp_mask" call.

So... in this point I gave up, and I don't know what to do (i. e. what the upstream
kernel should do).


Feel free to ask any questions.


I changed CCs for further exposure.

-- 
Askar Safin

