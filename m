Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3530ECCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 14:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DF948E000C; Wed, 12 Nov 2025 09:02:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BC658E0003; Wed, 12 Nov 2025 09:02:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC2B8E000C; Wed, 12 Nov 2025 09:02:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59F378E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:02:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9374B9C89
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:02:15 +0000 (UTC)
X-FDA: 84102119430.27.6334565
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 854A5180021
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:02:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ddN0hy2F;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762956133; a=rsa-sha256;
	cv=none;
	b=aoLiQhlzNdu9Jk3T/9VxxCRRTStUWS5/SSbURXeIR2m9u5AAUMOXy2J4Ne+1yPfdjbQSo0
	Sm9IUwkybwlkystRP1nD9wGR4xDbQPFHhwKzEq92bVFTXnsAwqARblaQCx5dkePv0M6COD
	8WHdjjAJyifxqsjCwsrfmudBo8q3N7w=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ddN0hy2F;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762956133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOeUMdFLrARgOFLb1t2AnuzeStuy1JBycaUsDP/wyV8=;
	b=VZOadAPSuRJyPxBaKIYHnj05Mzu8PtLuePVlgULqww5TRrMjAu87Xma6S3HkUcPKNomT4k
	a22S09Pi2ZXTy0oQJ0sEt7QNLjWLysqvqK5WXFIsiBGkBxB36Yd8ETxy8fQmyiPZhKEbAJ
	KJNgFGxrpXX9bFOCso4xRjbhpgTxxk0=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47778b23f64so6299165e9.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762956132; x=1763560932; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WOeUMdFLrARgOFLb1t2AnuzeStuy1JBycaUsDP/wyV8=;
        b=ddN0hy2FIYLBfrGhxRORF8u98ByqyqN3Vc2w6JJLCNH3Ogg/yXWTT2KuuMElgaewLT
         UFwGnXoRAaC9BCJGoT+BU8VXxSMnC/TTWvj4ftcu0aJeihK4ve63Mrr3aluNB5diricL
         6UKFyPIRte7gONPm2PHHylI39kW7tj9ipYeJa+PFx9L920RoJD0/x/3fLZeEm61LsYC4
         57EOrYPIsh5ShuFDCuZNsg/3fN7muSjcJmFpmN2uQthHFIOdkI7LKJtwcahK99mOqw/1
         Oo4BfAqWYKmmby5fCnWOMPtKVEyY6IIfRSHXtauEH1zOjWTMiDO2SCGKJq+C7uQnqxDS
         NsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762956132; x=1763560932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WOeUMdFLrARgOFLb1t2AnuzeStuy1JBycaUsDP/wyV8=;
        b=WmM/SCSF3Tcr7Qkq9r4woy4Ra+G/Ewkw/8nEq8KCU96QK5VZEZdQXwLO/vpZK6cZlz
         4Q1aGQ76clbNrY10Rl+lAZ+uSN+fUk+EG9ulBYSp3ACY2wf8GlgPxLO3E82ttOyinlQl
         D3dEV/FzWuHkYxM83RUjr1DwlUu9NJ3sUEENJd3VnaTjgKDxvVNcuqWfVk8AGpP3hIqf
         qm7xOB7lobEZV5ZUwxI5PWTQGCf1Wz7caMmtCsMV/MEw8atIXAIsjjItbkyBm6ZTA+Kx
         x5qjLj4vf3EDTmFqZtBgsY0FYKir3LPdCb7sqVTiiiG7OF1ejKUa5xdsrkESyqcMHxwc
         ijGw==
X-Forwarded-Encrypted: i=1; AJvYcCWgs6NDC+33L00Ujjd4eVpuHVvscXZ6z5elRDiX0szlcXBQUEVdqCUAP4snMpvoUqPY3MVENh+ibQ==@kvack.org
X-Gm-Message-State: AOJu0YwDsED3IC1418/6hN81VOVh7dycoWbOBqkYN//VvVmiQqpLYxT0
	rr2zXGeFb23efUoj7DRWB/TWdo2+6ebiVyNk449Qy+5Nqnxd+k1FNyxokIOVkawFIyo=
X-Gm-Gg: ASbGncsQlIhRyexVKFA4OpUNNJswe8fym9gJePh8dPf/KmZJfa7tIIqVwiXsqmdBGvx
	VusOAZMea4g+iuZ6PuJEmJ84ihyL3fdeeD8KQiJyG94JBxIec+7GNNdrRRWf193YdYg2pyPvCyU
	pVMDBBmjvfaPZKx/+U2a2XdKn84iafYPSP//sVJd2H2AI8PkwsFYOqIpwFs+Uxyv56c3dLrskkN
	OL6eD2klET+E9MN9I0KqdybSBy3UGj/FoDVAqUXdzlBs0uOEIG0vnkTLFs9aLBpmjAp7HbbdU3t
	9NRbnERtLmx+YkX3BeOMB/dK+myaUbQORYrpenmnQRG4pN9nSQ98EtL8jJ4w2Ibiw6abPtWW+sM
	42KA+3fyEYvbe6EcqKNJ8iseAsoK+BC664J2JjppzxH79Drx0aA8li96qDFAV2jMRH33v99MuFi
	UQCJdbLb22WTQ4Mps2WLZu
X-Google-Smtp-Source: AGHT+IHr7c4ZnrhLQZ/bB6CXbwoEkep3GrU2Tc3liHlu3o2VJH0vMGReTx6XLb+PoXt92HxE5gNWUw==
X-Received: by 2002:a05:600c:3114:b0:477:1bb6:17e5 with SMTP id 5b1f17b1804b1-477871c4b45mr28509875e9.30.1762956130143;
        Wed, 12 Nov 2025 06:02:10 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e85a94sm37157975e9.13.2025.11.12.06.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 06:02:09 -0800 (PST)
Date: Wed, 12 Nov 2025 15:02:08 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Waiman Long <llong@redhat.com>, 
	Leon Huang Fu <leon.huangfu@shopee.com>, linux-mm@kvack.org, tj@kernel.org, hannes@cmpxchg.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	akpm@linux-foundation.org, joel.granados@kernel.org, jack@suse.cz, laoar.shao@gmail.com, 
	mclapinski@google.com, kyle.meyer@hpe.com, corbet@lwn.net, lance.yang@linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
Message-ID: <ew7opa4vqangjafwfthroe7d37ovvvmlekzc6clbqia7od4v6y@344cuiqiduc2>
References: <20251110101948.19277-1-leon.huangfu@shopee.com>
 <9a9a2ede-af6e-413a-97a0-800993072b22@redhat.com>
 <aROS7yxDU6qFAWzp@tiehlicka>
 <061cdd9e-a70b-4d45-909a-6d50f4da8ef3@redhat.com>
 <aROkMU-OFAmYPBgo@tiehlicka>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jtcwccftag6wk3eh"
Content-Disposition: inline
In-Reply-To: <aROkMU-OFAmYPBgo@tiehlicka>
X-Rspamd-Queue-Id: 854A5180021
X-Rspamd-Server: rspam07
X-Stat-Signature: 15sre6zc8gkzbskcdznnpmhfare3gxtd
X-Rspam-User: 
X-HE-Tag: 1762956133-309981
X-HE-Meta: U2FsdGVkX1/npBl3AKNoreSuCv7J6AVR46tD/OZ2V1fMe/fnp06a530UuCotdo3VhdSgjXdRIJhnOEqvgBq1tW4pWXizAgoL/cZyZntqulFQ5ojxbCRkbAjnuxlloBJP3b1LNBIaNm5AjEBMPnJVOW4JpYiCJETietpH5p4J9dzeDA+94rTnZdeghKFinErm61VLc3fZBb+bVfhnMka9j/O+m873Fg3Isu9QnFMFAUz53PoRku8pvX/NTfMBW/0eaA0kPA9Dnasg9Ys8xnc/EoQJi8ZntOcefMWKNG26wLU2/RPJaG2Pl0AMvYzccaPshAN7NscNhX6XuSGiz6XRStE6+GOrXDuIZnw0T3ubt2m3w1WpCP3KabKympV7EkZJOhSXTjz6Ce39GWyH/fJiccUz2ewHYT7VLElh9zjTyP4N3TouX3lwwcSavtx1UNIJgpgU33OBmMPvZyynIEFcCoYHyVzEmkyRiGETjKcbiDC7ZJ6gmeOByUZeoDFOcCcqrjrtHBHtpKYZ/pDaT/chqSWrk/QZtaM9naGbEr3MaEZn/3iMLAKMeJrE39iKniwjeqoUXKfod3KGbyPwayVuCCOWyI1fUWyNM+LwaEf0foW73lnyL53sk7pp4qSJGm0niSYctlps5lEugXHIjkYf/CZa1dkx/VcoDBuhioubhMy8Beu+/A3dTvWaQnywGbjCaqQwlKlKVOD6nAzaGJL09TjbtlColHIZTjd49ECR85IdXAuN4wjNFvHwEnUmS5PNQS998Q8yLmugKHkNxC7PTJj6fPpX1rdb7k/XhvNvppijisx2DioRKc+DSEKLUjQQYKljdGUfnIDMGCR0KRBMcvdUhgfiNAhtg5OZadfsfMngZ3FpCSpVlhrw5qQcDXCCUYHTn9dtnRWSbVujYwigiUdHgYlD3wOQAEWOlFn7296rKRzVPzJ+QS3j3naoutS30h/XuND8ELzF6jojuY7
 GB+zATmi
 56Al29uaN7s3cmCwUDY6lLFCCWTe0ZFTZqc4BC143yS/dpwgv0+S0YFh5UbbatwUkBJdPmlq2EzLUOeYJ2NOF91iAckYyvlejMfHLrQlOeHSXbMk87AyPamWdz1YTRvNpzVjemQEzVmDcG+rjpOiPR44o9frGRiI5OMlIen5HC6g4b1Ga3XVwQegXvpUFHY3hEjoIH6LF4DMPVP8R8i/qkEIGgJIYNUBSDGwhsp/KlIAWoXbiDFqojznQLKF4WJcRMYv9SLmheDpCIRE6c4KbWF94yjCDP9yU/itQ3Ft/k4brYkpchh11lDEjcaqzANCwlIXnxM3QE0JuI75eddRJFfaRRCadPkod7m0mg9N2pPZokfxJL1XBlsj1UiA8cG6sGWy+HpP0cKD98BmsLk0XyYWt9OhJVIheBPo7rSZMXenCXyKS0YbsNU0x8NLsIgPzq07DsOpxdLwjwOXtNxCcjNGLg+ozbQyhhWlVvUOsmcMW0/+88dHv2C+Xfie4L1h0W2MAD7JoMXMfngJljMRRgaUBTt0C3gbZWFpBL2zTOM5RZheff5y4rzp+wycIMNrm+9YC4fmJKZhHizoYv+tR+9bpqmimFFkVJ0YgehHAhFG59VU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--jtcwccftag6wk3eh
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
MIME-Version: 1.0

On Tue, Nov 11, 2025 at 10:01:37PM +0100, Michal Hocko <mhocko@suse.com> wr=
ote:
> How does that differ from writing a limit that would cause a constant
> memory reclaim from a worklad that you craft and cause a constant CPU
> activity and even worse lock contention?
>=20
> I guess the answer is that you do not let untrusted entities to create
> cgroup hierarchies and allow to modify or generally have a write access
> to control files. Or am I missing something?

This used to apply in cgroup v1 but the v2 controller APIs are meant to
be available to anyone (e.g. rootless containers).

So yes, if it turns out that the isolation may be substantially bypassed
by reclaim, I think it should be solved by some rework.

The memory.stat_refresh is different because it doesn't exist yet so its
impact on isolation needn't be even potentially solved :-p (not more
than memory.stat).

---

That's also why memory.stat_refresh is different from one global
vm/stat_refresh (easily constrained to root's monitoring tools).
And despite this precedent, I don't like the approach of two independent
invocations (write(2)+read(2)) when the intention [1] is to obtain
precise data (at least) at the time of the read(2).

Cheers,
Michal

[1] I guess. I'd still wait for what the actual usefulness besides
    fixing LTP here is.


--jtcwccftag6wk3eh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaRSTXRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AgYtAD/c+S8KG22icAY+D5u/Hw+
IaaTSOoxlnotS8mWtF9Q37kA/Rx/AJ5T2cm0Z5vyBpqCrcQhSgksn4AhdUXvWv8t
O8AL
=ff7K
-----END PGP SIGNATURE-----

--jtcwccftag6wk3eh--

