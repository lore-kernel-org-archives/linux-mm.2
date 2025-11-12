Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70ECCCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 14:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6418E0003; Wed, 12 Nov 2025 09:02:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87FE8E0014; Wed, 12 Nov 2025 09:02:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28278E0003; Wed, 12 Nov 2025 09:02:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9928E0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:02:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FE6E5908A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:02:18 +0000 (UTC)
X-FDA: 84102119556.18.D213172
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2918018001A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:02:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WWrQhBS7;
	spf=pass (imf16.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762956136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97+x+h8dQ4e8GUTjDZqoRrL1FA9+Qvtg5x2caP/F8R8=;
	b=mRZiF7YDTBdgj6x5gzJl6JSAHSuPzmjn2IPEbF3S1gDd3ALNFgzNmX99A5KXaq+Ueb6oXZ
	CSv3p3MQYfV+z/Tp1zlj0zixJeX8wuX/L5k8083j4f+QoA419yNr/b6nyD1sS0MGTubVGh
	hy2uekETRJDWs7ItGYmFUgtP/tbYJpw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WWrQhBS7;
	spf=pass (imf16.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762956136; a=rsa-sha256;
	cv=none;
	b=0IdxYPaNnSeACGm+lpe8okocvrdwBsTCT7mRRQ0TgYsgctJ0W6wiNaNq6Z1zR08KY/DnvM
	5zMh8NLqHVCZxAPzHgVzad3Niee7x+ihUy0D8qSGK8y6qu4ptOna9yE95FRKdfPS8wP5Rv
	IEvTYrRS4P05dBzBXMFNT86CHsklvxY=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-429c48e05aeso452568f8f.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762956135; x=1763560935; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=97+x+h8dQ4e8GUTjDZqoRrL1FA9+Qvtg5x2caP/F8R8=;
        b=WWrQhBS7LgwRPBi89XyEGvTiNujn50XNmQtJmohfD/PGEqKvSu8xdfKO/tenA5GXdg
         yYMuhS4BqW6VkrIbtW5NXBz810MMa4vi/5CRavNp68/2doSQLfB5qF3W6XYJI60auP/W
         AzP/uu/GnCFWbgsPSfjOz50gImS8M8nHw8LGPenCRxOcElippW9ECoo5zG4bP5tbs+O3
         Zz6yY24e0FGovRJnG+4Y79WhYcrNC+zUWJulvZBIKLNXVKgRZZimcEO/Zjmx60kkDmPK
         93SgQZFiMk2SnqGDJp/ZtRXLkPBHW+T9gN60eauO7aUREb7oeBE8o0QejJaeYprW7dvS
         LMhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762956135; x=1763560935;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=97+x+h8dQ4e8GUTjDZqoRrL1FA9+Qvtg5x2caP/F8R8=;
        b=MjRzUCSZ05BLOZADg90v6LGBkkoxJDF91igKoH4GCtoymiw/BOFl5EtjGVkYAJpbmb
         YZ6kQO5RVMwmUgscDBYFNo1r1MTfWT5PzhXuNEHsyqQuhmiD41UJvJiVU7zK8HSdJzsK
         GKkjmldj/r4uVvMjlnjljzIfluY514r2MN2LhyPQMMpifmGUuK0H5jhBnnnopuEwKxBW
         Vfvzno5gS2V2cPzWNS8l7XvNjyi3PwVkAGAjGmx3Ur8fabF9n1i+4n0ksgTjfwhTBF4w
         P3+PuVCIv94MgddeE1ta/yjij21eOUY+WQ/gmDzIa5dRkc2vMkFhMIGtPjsWtN/MM9Rp
         YE1g==
X-Forwarded-Encrypted: i=1; AJvYcCX/Xes93L6kBz+BVtTmzpT80tDoYl3btf+ON+2QX+mu07P4Sl627cGN6iPb1iRH9c2jCsjKAQDzyw==@kvack.org
X-Gm-Message-State: AOJu0YynI+4tpi3Y9FtEgEbFAKgL9SR8f/rMjCq/xzVhHnvVbm09qXRw
	ir0DjEYbgBEOCjDMx4+czgoGGn/kRFcE4uv/Psh8U5G8jKVmpl+cKkQH3T6f49MXPaA=
X-Gm-Gg: ASbGncvilxZHoCdDpXDGKPow8IlVkMT27DB0CA4GRMkRmFD4i6gNgonetQbpG3JtXfI
	Q4ov2Rb/skBaWpJhPNaRPfdJaWAzbJBYiHK8HSEsdGluIJSaBKSplbyWcaYLtGaC4nBJIZ4KYB9
	l3NRnBg3AX99lKFPPQ/nVEMZItpISBAB0NELlIb65F2RIN39Yx/CXzC1JetMiQCvrkZThAdtugc
	c3FbNlo2PXvpJEHQH0MH1ejaRq1tPOPogL7im5X62Ajf/ShU1nOtSRITVS2wLgByOdawjc4pTQK
	1GWMaOvFh3EVwogsZiB8ikQHir4Qj/H1OFrrx2sRR2F6+mYePa7BilyU+qsl2ZgLTvoBee6+f28
	XCj7weG2C6LmITlmMIhMTQKv9BV5wxaMi7bARraFz2Chcz5KPYuA3gyjjrNe8vKnC1a8NLFRolE
	YtXQxOwDJU3+jozz+IxfIe
X-Google-Smtp-Source: AGHT+IF+oB8mjrQRe5QSu7EfBjAysEQG22PZLyD/6924dtA5Ki8nSfNI1qTwkRcog78mpQsXY/aLvQ==
X-Received: by 2002:a05:6000:615:b0:426:f9d3:2feb with SMTP id ffacd0b85a97d-42b4ba81c5fmr3242633f8f.23.1762956134571;
        Wed, 12 Nov 2025 06:02:14 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac679c5dcsm38723673f8f.44.2025.11.12.06.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 06:02:14 -0800 (PST)
Date: Wed, 12 Nov 2025 15:02:12 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: Leon Huang Fu <leon.huangfu@shopee.com>, akpm@linux-foundation.org, 
	cgroups@vger.kernel.org, corbet@lwn.net, hannes@cmpxchg.org, jack@suse.cz, 
	joel.granados@kernel.org, kyle.meyer@hpe.com, lance.yang@linux.dev, laoar.shao@gmail.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mclapinski@google.com, mhocko@kernel.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, tj@kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
Message-ID: <chffrjnr5ebky6aytx6va4lptu7mbxclmzqvzdnjwa6hrb7fzw@ewpebokeqfzs>
References: <7d46ef17-684b-4603-be7a-a9428149da05@huaweicloud.com>
 <20251111064415.75290-1-leon.huangfu@shopee.com>
 <2f43bdf7-5ce0-4835-9e60-39d91f637152@huaweicloud.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qrv7ktcycf6a43eq"
Content-Disposition: inline
In-Reply-To: <2f43bdf7-5ce0-4835-9e60-39d91f637152@huaweicloud.com>
X-Rspamd-Queue-Id: 2918018001A
X-Stat-Signature: 4mqt5fy95middrnszs6iiozn7ok53igo
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762956135-545240
X-HE-Meta: U2FsdGVkX19w1VtpkkChR0gczWH2GLSMpaf5/vQK79aS46kwKZ9JkZvZmE34URYA2LbnW0NNwCCyTXY7EU5jIUWuV4nt5e/ezkZdUDtxrkIxuxchKUN2A/TqZV23uSzldneGgTZ8kzHPmi5m37sDQXFshTqFDK71WGU0u8GTIMVVL8e0yeGSQN9ebgBaOQ1L4wt7WtL7JuU4YXkirGdEz4E9XPH4ah3kLUwvETA+zphto4nYM50SsXl0IIbKfzgVNpNm4BK6Tt5iAO9YzK9pZFqNTx5wxSvYSW7S+yeqUNjOXCFNDPHs/lnm56HaQrqbB1EHs5RaiWHS2CEQMvjdECqGD6t09ct0zRWo9CawWUQPOtu04aARpvV49+GhMcVFGmu+azEQxz16rte31eriiUPxg6Igr4WXs9Iu2fW1zm8UVnylvuk4xTb5f7ZaZRqqBvuxCxjEgVo5VJO42Jih5bSyBZ28V64Gg+l0jwXAUCWVwbFCne/acXkvTOaGZA9ue5l9SW2ysczqqyFmA8EVBMdZFRe8LZCJCFsFeDEstPP1p5gKWJlCyFX4T2a3X+kbrNiX+3mAMBTOFGhPSfZqA8jew2LIRmFozMzIHx/OsIsOC11KUQbT+2/LgJESyIOqbkq9LtHTL87MMiUoN6IfxoeprS79RAyxe3LGCKd3bGpKHYEuP7DxR7mTGViewCDD/V4oERkE5EMRPCEDZ2UYOFIQivkUNTArvsZ19tBWLRYOb8OIymBhod/DxHx65bU4CHJFpFDXKK25sEMyC7hwmaWTCbqhlMetpcdNdfwYhcJxi+/eyGZN65msH4qyYDzd9I+8Ngdm9+ZYDAEa4fcRoGce4PjIJW8Vt5dTqEfy0LFiF0GOsuew40P3CDPTmdmcybqjyIstqCKHWr8gq4TaLZ4I+4GhW8SKn/dj1Ozx2e5vb/nWT6kS0gAHycq1T7ezUUAoGJ+wfS4kDM5BICn
 cyVTqFUR
 vHfNtcnmRQXuFbYeUMWt7Ljx5yZv1yjXcDUIedTDwYebXucrSxC7Mh3HA0eNdrWabLVE2W7+yIFTicGsZmGuYCm8k9joOb8mSQT1RvdSoXYIL1r7N+uW6NPES0PC/Z8Qqm994ot2C0iYkOmbcs5kjw9jt77l5MpLZLpRk7np0Q2C/PJoi6bGHID92WaYWF4vB+PviWoH5v2yOLNgW7tkmJhxWwVl7cbum3XrBD+QhXf8Hb6N0qgBK9nqCaqyDof2VrgdVieUWZtLazm6f/FadyLHRhS/ryJj2K/iJsbMWwpmjEPuGsSxJYoHM0IkFcGv/r3ZfPDVXUmyDo4hd5cbUg2QrkljsKcUzEJ8/0S6YhrbRMIrzlT13tfamyaJnISoF8DMNSQVeK7IA9YuysNZ5GiI5zAOWjfXq+p75PRyZUuHYZ4IGCSYyyz7b+wUw3EKnCvojz1hB2RbOdOuXE59SypkDOvTmJskmfWVR8gG+SsRhcsvrn/78Z+8VWeTcSe8Y1CQxU6nl+kgVBWirqDOF+m4/tU0LTA0hXjVU+ab9Bf12jn193ovneyDqYzAWGOmLozQ/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--qrv7ktcycf6a43eq
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
MIME-Version: 1.0

On Wed, Nov 12, 2025 at 08:56:28AM +0800, Chen Ridong <chenridong@huaweiclo=
ud.com> wrote:
> However, this fails the LTP test quite easily. The error logs come direct=
ly from LTP. The issue
> occurs because the threshold isn=E2=80=99t reached, resulting in an RSS v=
alue of 0. We tried increasing the
> memory allocated by the LTP case, but that wasn=E2=80=99t the right solut=
ion.

You touched on a slightly different cause (other than  async flushing)
-- there are other fields/stats that are quantified by (basic) page
size. I.e. I think that might need different/more central solution, e.g.
working with absolute (not relative to pagesize) thresholds if absolute
precision is needed.


Thanks,
Michal

--qrv7ktcycf6a43eq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaRSTYhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AiSagD/WULk3YU+JZ1RgyrGtBcK
Rk5AScqXYcflK31hxM9Cw9UA/3e8l571U4YVUYXkPQ44w97Y1nTKbxU0rJ7BHri1
sywP
=pSJv
-----END PGP SIGNATURE-----

--qrv7ktcycf6a43eq--

