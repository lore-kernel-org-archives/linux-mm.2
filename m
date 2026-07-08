Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43121C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 19:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9C7D6B008C; Wed,  8 Jul 2026 15:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E106B0092; Wed,  8 Jul 2026 15:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67B46B0093; Wed,  8 Jul 2026 15:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95CF36B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:08:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01465402AB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:08:15 +0000 (UTC)
X-FDA: 84966544992.17.AB08A51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2633C120015
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:08:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JX1w5xxl;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783537694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yiBkA9xQHooEcgjjRAQRu3aK1yHlnq/UeMyE5vEXoEM=;
	b=pPDAEE3msSeoOA1mVxEF/OcJvxMFGHxK8MDyFAJffQsqrA8G7w/ufU9r97Uf9sB3t2tipP
	wZc/XNtl8BjvrIyZd+GMUUzHjaPfjEXFbpEP/9WIBdVwl9j6iHNX4t7zLm8DXQnXUnRBSM
	FliByF14xF1zFNjNs+d77blTC22TaEg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783537694;
	b=55fsYrycOUQaBIdUU3jFmcAVJzhHHx53FjEJrOxPJPHcQyBBgPkPR7jkCkGqawUI4sonAH
	a9CMyBplk16eytMTx7HKl6t27d+1TBDRYgzOYjHy+399FI/LK4TsWp8L6k8mj+/6eQy65g
	gixsWhOx5euUCPw2ei76dwdFFotBgcI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JX1w5xxl;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CEAB6001A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AFF1F00A3A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783537693;
	bh=yiBkA9xQHooEcgjjRAQRu3aK1yHlnq/UeMyE5vEXoEM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JX1w5xxlZ7d0rlN3bIaPU9Yb1jxSFKZfedoZtGcsE+sngcvCXrnoGwvc6MLooVNXE
	 4lA6rIFmchXAe7hNCyBX8Q5pkx1k4Nfaf1+47IOHiUfIvJl+FlMRueQE3BgIddpBXR
	 LiJn90bD6okxSyv2Sss453Tad72ouC/YgBsBIMGAYNhI9ZFC2jmFEZkjY8nZMoH1VY
	 OekxpQz7JVsB95w2OJHIuUxinRS8BEEGD2hr2FQ8StOUHpJGvJRg1zt/F0dkPpkHge
	 K1yY/II+hKH8H8S905VbpHaHmTCtKTFlhoIr+CIzH/VFfsRfzDldCEexOA4S485F9v
	 9b1fy5gC18gbQ==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-691c5776f95so148267a12.3
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 12:08:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrxWf7Vw4bFv7iZBVe1VJgp6FKmJNfaNcKnWr3kkMdFPFsW9z7db79KMbk30ET84N8SrRzpV7m06A==@kvack.org
X-Gm-Message-State: AOJu0YyijvVe0VhbufGAjbtoDMfpcYWKcvtwx1tfzPbFMz9XIfbrUdLY
	5Y72kZEyTzt+3PhyfNZcz/NVKo2Fxpbu8SZ+iet0vVWapeYgji37dF5fYXmMtRC0K1optrJWGiV
	5SAD1NbsqQWAFjKe8Nq88dcW2WhTbPFc=
X-Received: by 2002:a17:906:c14a:b0:c05:b9db:68cc with SMTP id
 a640c23a62f3a-c15cdc8ac7amr170635966b.0.1783537692118; Wed, 08 Jul 2026
 12:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <c0970cee-42c2-4844-b88e-229853f08e90@linux.dev>
 <CAO9r8zNJh65SZzdW8Cc8_8N5Wr+ORuRtU3kuaAX_DhLaESFYTA@mail.gmail.com>
 <CAKEwX=MMXdq7KTzcEgXfNt2L-eTmAVa+nijdyiujVOAhXQsHSg@mail.gmail.com>
 <CAO9r8zO-nAys0PJfXVRwLgAzwJLa9KxpMXKQKXJR7cnYKgmhRQ@mail.gmail.com>
 <CAKEwX=M7axSs2FJDq0KF3GBDpd6G0J=gP_2boUJraNf8M2n3Bw@mail.gmail.com>
 <CAO9r8zM8qk9g6+B6GiCV3oytjViMTEhbr0KjrccU+bF4+PMfTA@mail.gmail.com> <ak6c2TaOlcGxZ2Ih@localhost.localdomain>
In-Reply-To: <ak6c2TaOlcGxZ2Ih@localhost.localdomain>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 8 Jul 2026 12:08:00 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPiOyri2wVxRvB0bwEXf9bCKoPsQmRzOpj01XozA8hqUw@mail.gmail.com>
X-Gm-Features: AVVi8Ce2aMsGuquiDYnmvYMN9gnK32qIskLfiFxzN_JVMoIyoVCs7MHxGrMZ-QE
Message-ID: <CAO9r8zPiOyri2wVxRvB0bwEXf9bCKoPsQmRzOpj01XozA8hqUw@mail.gmail.com>
Subject: Re: cgroup/test_zswap failed with "zswpout does not increase after
 test program"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	tj@kernel.org, Shuah Khan <shuah@kernel.org>, mhocko@kernel.org, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2633C120015
X-Stat-Signature: hfsht6j81muj9gens6wtk9w6pt4x5zw4
X-HE-Tag: 1783537693-284148
X-HE-Meta: U2FsdGVkX19SKPUEn5hnOfqwEZtFAZU1VXTEQRthNdzl1L5gANn08mWBSFsy7CCMY4JAeZgs3kLADR1P1NaBFyMB7a5YUDR5n6vt/fNhuMainDO1n+zce78RYH/Iq19+fD0jRBfdTUlCaukzelgHe4OKLVCHyFw2bw8UZMilFaOT3VKcjxCfjZy72VOUXrqo218XvJcxMPVce8KNE1TBXnbionEYGISjqIubhAB+uo2NfPtD6USDbByIx1VyPMYgi+ePZH0uJvv79Rp6+sURyJolSrNrn0O/49nACD9iW1uuw9oJTv61v5zgKmvHTHbHCOihG/i01RvU2ySrBxityVF2P0uXyPobFGsINYlbw+i1uyAT4bvQGKpUjTOg4tEkrBDANybXZSYEImphPrN35uz2GY+9t7Mb6mRFvt1LT9njNWokYnA9trYrV96glO7ElrP7bFOE4AYjyS5FR1xEaG6Pc5sOSr4UV5gtsmTEKlHZeQX1wmJxZih/VM4XI7cxaEW7vvyDEp7cRYGd68MryWJE0WEKGmhRCGbTaKmVh3b6lYBa8IGpf6p7Vv9wKnO141eEeIgitrzbsCcBsUhdP5s7xAAxf/3QeLorx2hTWQWq11wcTQwAcuujpyHZKm3t3W/0fREtaRLzyCCxZNLIxNk9kiszg5OZ/J6wk8s4RvRCLBvUhIEeS+Pu3QvePsYtDavuRz8kmBefbd3xZQ1zN2owAiVquIvYehOy4G1iClfOh+m1jYvypjrYMf/01WyvRs6WWwHezzZkRovSeVNhoC509ZnEsntk0dLC0Fr8ydpP6WDnUI1IeDEIWiVQa6WQNsPg5vjDjSThdabOy8/WwqDPdGz9RnxDqhu71s3w9XART7LrXrFCxJJbvdtjF2BHobVNi2f1VS47+FmIpHmAhP+4rPIdVmQC8MvyEDZr4ezD6apLmVeWEISq3TE+60QmVXzEBMRZuVAuxjhpQE8
 QILzyUDw
 5hsYzruWxq8aoNW/GoFHESuxNWxUn5h9lcxF0aAn3SKzyVitxqnBHHanN6Sq7eaG/6CP10Ig+ThYpHBmWfzy7PN3DtA5/M1ldABA4dHBttxlJ9pjb0zFJLI4r88ykVTOINayN4DEDttLxjU+a6crJutqooQ2jH3n9CKK+KFdm3QVHVE9eSZYpSSyGeKFr7U4Gt6pJxAj8ro3bedhlW4kF16ciURp53Z+UL3rr9ge1nimOq3bGvHCa2nda4uapLG/MgTqv9og4MJnRyeejC04+HTeemeFZDNcqRhcGWlvtJyEm8/l1Q1PDNwmLM/THvYYvhstip+UreJqp4lXzVTid3Dz2Cn28zfwkMq5UZYGG2i35eGWCwYP/C99GFidJFJZYcEsHDkgY2OkaVZXMWup3hfahBGgRB0j/D0Pl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 12:00=E2=80=AFPM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Tue, Jul 07, 2026 at 02:49:56PM -0700, Yosry Ahmed <yosry@kernel.org> =
wrote:
> > I would honestly rather use more memory. I think there might be cases
> > where the flusher is delayed. The flush being slightly delayed is not
> > technically a bug that we want to see a failure for, but if a large
> > stats change is not visible that's a user-noticeable behavior that we
> > want a failure for.
> >
> > WDYT?
>
> There's already the (recent) page size-based scaling, so the idea with
> nr_cpus scaling could make the selftest useful on wider range of setups
> (even page size can be considered as a slight implementation detail
> leak, thus the justification of nr_cpus dependency).
>
> Also, I still think that internally the threshold should be changed to
> the "harmonic" formula [1] but the selftest can go with the linear
> dependency for more pronounced effects.

Yeah I agree the threshold formula can be improved, but we need to
make sure performance doesn't regress.

