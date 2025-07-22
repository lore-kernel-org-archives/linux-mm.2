Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7395C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 08:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410D78E0002; Tue, 22 Jul 2025 04:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1408E0001; Tue, 22 Jul 2025 04:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B0248E0002; Tue, 22 Jul 2025 04:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 128658E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 04:41:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2F3C1402EA
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:41:26 +0000 (UTC)
X-FDA: 83691256572.03.BFDAA54
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id C86D94000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 08:41:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XqN9Tsvt;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mkoutny@suse.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753173684; a=rsa-sha256;
	cv=none;
	b=qvmGTjnOJDIQ08YSQVOdlkv0V9ypBqCUcFCiM4Lhd3n2mvfs3FFYPxH7mAWRxe4Eyl+L3x
	Ww5coEW132nSE2VajmMhzbvGqmXibGosY9LI4xcD7ud242S3TG5mhIZ7J/4PdPiT+eGNxu
	SrQ0PYeEVAKC7M7uNxfgbsr2pcVt4pA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XqN9Tsvt;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mkoutny@suse.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753173684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRjs2dB89iP5QPdZHpfO+IIDPv1Lm2vrEdP8oJ8jq4I=;
	b=PRBBc2jTMd9FZi+yn6FEmn1AFC/H/hZ+74GQGmFPMnIJZ++2Um7PtEnSeJzHkQg9FaS/uR
	9IeoGre83wkEz9sz1c4+PCT1DmtbMXRfzDu3Ila5Ej4UnS505s9I6ryyd730y8AE4tYilj
	Xa/oCvv9v5oKNfh/D2y3XOxPife8zww=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ae0dffaa8b2so1049448466b.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1753173683; x=1753778483; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bRjs2dB89iP5QPdZHpfO+IIDPv1Lm2vrEdP8oJ8jq4I=;
        b=XqN9Tsvt6s3cKXR4SRCKpEKggHQ0fGMq+dfnGwX0TRMxr3Ityi2tM0IGrLjqmI+f9W
         /qLD838EGeq3yJJoCx2bDlBWLTgeL3UFLGuLzUU2QW48uBR1KyYxyWpORs4wgwGrW7wf
         6b8wWHKqkjs6hhrOprOZE1KYPF1A5IGp25GPlxPBCBjEpveOtM4PIWklfiY+OJF1x4XT
         aixfV5tEuiAiWbT53J8mpx0+rLmf2b0zBu9o0mqWoGsPKJwSUefX0bRwEYBaLc64sJYA
         4eQKJdU7oAXmYDOtJ4BERFod6Y9vu0eCtLzzZUQfh1Go0VyblPK6ZRFUI83DvhZWqoeF
         hyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753173683; x=1753778483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bRjs2dB89iP5QPdZHpfO+IIDPv1Lm2vrEdP8oJ8jq4I=;
        b=s3vDa7xBZCMbNKej2Q3yakq4RNiVIRJ/yL6eJZ/WmyCUCS5P1Mf0SxOEf2DHNlymy8
         75k9QDpCLIGjAGWDyEQe37vYIvSm2hnf3Mzlj1t8Zl0sZo54gUuyBQiNMKHvBeFUY1WJ
         3MQ3tcntM2NiBNiaz0t0HdbNzUTkNUOy6CcyrL3fwjvKuOjYFQvWUk8+fIcxsXlNfBsW
         i4TlkwMZe0r8v84ZDYsBh0ELbfZVYuaRy+Hyf9YO6YQHTgk4i6RfutMoWBO/f/cmtTWp
         GJdsul6gZFEB5D2SDlv/QeM/QhvNbgLW4vLguEc6SBZYLCqrZwz3cJ5jSd31hL/JhVff
         FnyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnfPiF8loSCoGtKswEmaBOnmuB0RPragWw2CfkramJpZQPqEq/vOj2k1dIjZFWnU1qQUKz/O5pNg==@kvack.org
X-Gm-Message-State: AOJu0YylT7TjOZJPsyT3PGrtP1p0ybKhBNM8nibkcOaZQPKr4tEugVtM
	7qxKt0T9J1E21EvME/1T9IVHX3NngGFqmlbqsrCPIwTok2agkG6y7gdkN3oD8I5NOvc=
X-Gm-Gg: ASbGncsFHaLk6PDeAJ/gh7gk9ZGMgxnMrHMStQxEstrcF6s9SairK+kDKVPNJxDIrjO
	SRXhARgUfw0+2WmgV/zyreXQC4hGNqJYTUsPZZ5cu7EEK1tJ+2e6E5asPKniGfosOwrrlb+8eHH
	ciXiCj1FW6raT8w+tFRBIsuwJ/V9amLZ3KAU0y3pOPsaJcn5BzE5YTr1QCJ/tN7a4bVkHKcVN4H
	MY7UmuCycyiPDliiLCUby8ZbyzLgKmMWG9Hm9SWS+G29kilRGIkrh4JsGSCD7fPt1Vq4f52UYdU
	HzeQCqaQkzU/Joz2ZQHhOWVE5WcsRrgJ44t3SXVuMu0T2HMlLPrnuF/AP0iqMu+gku9gAYhZxc+
	MN/6sKM8jfy0Fi0FRfFw1nWBJUFGUCTLcGriVtkDd522CJ9gkcMYt
X-Google-Smtp-Source: AGHT+IGVTq5jQfcMBSU2EE35kS23f3MVVY0rKBzXyZk98SKg1l8+dLktQWM4sm1V77E9tsRIzM2T8Q==
X-Received: by 2002:a17:907:d89:b0:ad2:4b0c:ee8c with SMTP id a640c23a62f3a-aec4fbea8d9mr1823014466b.35.1753173683000;
        Tue, 22 Jul 2025 01:41:23 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6caf733fsm829032866b.159.2025.07.22.01.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 01:41:22 -0700 (PDT)
Date: Tue, 22 Jul 2025 10:41:20 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, chrisl@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, gunho.lee@lge.com, iamjoonsoo.kim@lge.com, taejoon.song@lge.com
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko>
References: <20250716202006.3640584-1-youngjun.park@lge.com>
 <20250716202006.3640584-2-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qlnvw6uygziqhfah"
Content-Disposition: inline
In-Reply-To: <20250716202006.3640584-2-youngjun.park@lge.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C86D94000B
X-Stat-Signature: ya561ec57zebon7x1c9kyefrr43capau
X-Rspam-User: 
X-HE-Tag: 1753173684-862332
X-HE-Meta: U2FsdGVkX19KXYrVYZinRrEV7a+FLcu/vjNiUuUJy/nSdaL2lKCPJ5R+KZEkafcjEDDfbjzdcrwDmLyAzj0Hjf/8r4WFHIzaiNBX7PhBzO/XyxDRxOSYm+mUetDlsNBoi/5V6+JCP88VzYe6tsvGgZ2wBbIjEBB9zZtprjJzlpFH2UOPOnGeSFj+pakbF0/le0DFIkT/ValJGxeG77uuF9VNqDHxZ5ROdcXu2gApa6jF4EVBXSeO8+rYkyCZXSIV70nyqifNftZnQZbEm77hU3Okj/U9sQSVrQMLGfC09i94pbkDpE/O9BpAWlVeDgxW1hd3ilPAidwXnAwd6kPHSDB+niByoqcQy2LvLtr7GLEapwx46IckvEIQPk/OvU9MYrwW07NnNrqD3K/y+zQLIJG2WB00DgWqvVSgsZEvmgCJMY2k4b8GZ4tzkxRHdV5XMdg42iNNEe4rjAUF9XhjYePx7TVX5IjsbHJSNxYkqr+3hYCBHTyZ43MdekuBeh3tFNIBGx1YO/fyFJljCDExfIHu8p63hfKAn2piQxNpFvEbxw5+xcZUlftMKN4zyzJD0g0CX+cPZbNYI5X1UpRr1XEWCo8z3/COIt8ppMJOZH/d0x8pkIQOmLTi7sNmczGm9Q+3J+nYTv9guS9G6ovBIQILovOXtNXdJ36p+BdevAJ34TsDj537r9S6oyj3uoaJJyTKRUsr/E9jwOg1L9Nw9CgAmcFZpf4WXQv3UkJJeH8DNK902ej2lC4D4RsRalgg0YzaOv30rCQXP46tcID9k9nePHSIT/U5n6bnd2LHq7JtbUTjd6xeRAQrAtpGJMqgEzdBJW8yc3JUFwKyEY/NAI1PLXE6euVS949r70iC7MrPmmAb70rG90WPnMx2hbWWFUn0JrxYdgMmwEcN9HoOqP5pFU2YnsONDJgzRW48Qu7KN5CeTh3tWtpGhllA11OE+a4shYzdCNSMi1BEhTR
 FOhX0Dos
 69+qAJZx78J5ACzDAw/7IVDltHRt+3qKSModTwmeHYfnmkK+XfPy2LI5wsizJQWsyyLiVXKTISrUHGEHIPeLW3XToUkEBr3jDBNvmdlVveAmWyfUNj1wSEdSZsawzLpMqYRcScNGow3fTQmEuhl3deahSSucb1rKdz90E7L6xI5jBvK3wWAmNBiHlCNXWqkZM8l+nOD7xeLgIiusdkS++Y/fSr1OT3z/oItwTo/eSkTO6dyZo4xmFf39AGUQ5sf0H/Pr28CP8dX1uFFwtu0V9O2JnGE8/IMMm2I90uPCctzQs/jxDKdlMh1cxtXDsVb2GtKfOQZSX8swwLgcUQVHcfXpXp7ilxfQIMbrdfeKrsVXpHMzgXauJjO++IXGGmKxr9FSOI2V5oVVFSvwup/jszg0GZ7UysAg967OTropIiH6TU72YrijxhZD7t3ukni8+dPJ5rp/TG7uvBcw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--qlnvw6uygziqhfah
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
MIME-Version: 1.0

On Thu, Jul 17, 2025 at 05:20:03AM +0900, Youngjun Park <youngjun.park@lge.=
com> wrote:
> +  memory.swap.priority
> +    A read-write flat-keyed file which exists on non-root cgroups.
> +    This interface allows you to set per-swap-device priorities for the =
current
> +    cgroup and to define how they differ from the global swap system.
> +
> +    To assign priorities or define specific behaviors for swap devices
> +    in the current cgroup, write one or more lines in the following
> +    formats:
> +
> +     - <swap_device_id> <priority>
> +     - <swap_device_id> disabled
> +     - <swap_device_id> none
> +     - default none
> +     - default disabled
> +
> +    Each <swap_device_id> refers to a unique swap device registered
> +    in the system. You can check the ID, device path, and current
> +    priority of active swap devices through the `/proc/swaps` file.

Do you mean row number as the ID? Or does this depend on some other
patches or API?


> +    This provides a clear mapping between swap devices and the IDs
> +    used in this interface.
> +
> +    The 'default' keyword sets the fallback priority behavior rule for
> +    this cgroup. If no specific entry matches a swap device, this default
> +    applies.
> +
> +    * 'default none': This is the default if no configuration
> +      is explicitly written. Swap devices follow the system-wide
> +      swap priorities.
> +
> +    * 'default disabled': All swap devices are excluded from this cgroup=
=E2=80=99s
> +      swap priority list and will not be used by this cgroup.

This duplicates memory.swap.max=3D0. I'm not sure it's thus necessary.
At the same time you don't accept 'default <priority>' (that's sane).


> +
> +    The priority semantics are consistent with the global swap system:
> +
> +      - Higher numerical values indicate higher preference.
> +      - See Documentation/admin-guide/mm/swap_numa.rst for details on
> +        swap NUMA autobinding and negative priority rules.
> +
> +    The handling of negative priorities in this cgroup interface
> +    has specific behaviors for assignment and restoration:
> +
> +    * Negative Priority Assignment

Even in Documentation/admin-guide/mm/swap_numa.rst it's part of "Implementa=
tion details".
I admit I'm daunted by this paragraphs. Is it important for this interface?


Thanks,
Michal

--qlnvw6uygziqhfah
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaH9OrgAKCRB+PQLnlNv4
CMRBAQDzCszk0ZJDxPwRBr0crrEo5Fn9310kn3KBAiLE3KInXgEA/or1joqEpYNt
8C29XY1pGwaogm1oWi9Qfn+sSCEoDQI=
=vEC+
-----END PGP SIGNATURE-----

--qlnvw6uygziqhfah--

