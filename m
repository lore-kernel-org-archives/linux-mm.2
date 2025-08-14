Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B06ACA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06240900153; Thu, 14 Aug 2025 08:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A04900023; Thu, 14 Aug 2025 08:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9233900153; Thu, 14 Aug 2025 08:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D27FD900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:30:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8A4BDBA72E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:30:28 +0000 (UTC)
X-FDA: 83775296136.06.3FA8F76
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5EA104001A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:30:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZbaQn2tj;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755174626; a=rsa-sha256;
	cv=none;
	b=P3T4ncOanYLQfTkunWLolJ4PG71bZ+zF9OFC+QvPLwZKJkPp2c645AtqNtzRmAaLHkD3QC
	F0tNlUM1HTOuNmXPpGet+JE+mpMJoD8jBBJ6GXhhqj4Uyn3fxOfdaBHvm2PZ78XRUZE5Op
	OJYLIUBY0ajjtuNVDkjIffs/7zvTjnY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZbaQn2tj;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf11.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755174626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJ1w1vX016HZnhf51EVaJqwNMCPhdOvsodT4l6hbFIE=;
	b=2Hvvd9ssRAkH0Ohy4Q98811Q2XnnupDsTpkFpxyHxaEtfyc1mYRtN4WtHKyKAmmJvqqTsu
	nvOwIWDEIQW30Cvjrrca8O5YB659L6HW4QD5BZaJ6GEM0AUf+PXCNYDsS2ZprvigxWsqxr
	4caBG0Ggg78zF/qJvu1N8+JuEngdTj0=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b9d41c1964so499749f8f.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1755174625; x=1755779425; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fJ1w1vX016HZnhf51EVaJqwNMCPhdOvsodT4l6hbFIE=;
        b=ZbaQn2tjeXEtkpAqXQPBQVyO6Y0UNicmkGsaXsfSY1GekHzwwT6E1rX7SSl4HWk1ee
         O0RzWsAXxyiMM/8sLCwJ68rO3JtTqmyvlc1jDHirlFJ5ia7zE3ApWHhwOq/5f0nFCraI
         i+qEjLna8QbARmNntPS6/rBotsJEFyTYKhxUXeDn7huNjb9xKyJ3qw+SQd0a4IoNLVrP
         slqRgxRfN4nPWNB8lKWUjsk+yNlq16Dsok7BCvEgsdO1HwLSfmivX/EGoS6HjfPITfJC
         6F6liAgDFDAtey+fZJDxJbfO2z4zRI3VKBhlKxk+oLBfqBmqhoS/T58f3/i2i4DK2Yps
         bc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755174625; x=1755779425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fJ1w1vX016HZnhf51EVaJqwNMCPhdOvsodT4l6hbFIE=;
        b=alty5XGykgC6VFCETOmgzU0TRZ049FN0p0vVw8PibMI5GmbmJz+3XOJgpVfH6p3csq
         zz6Hysl/xo/0GtM3TqkIqhAsl1LzPZw2cQSLw+D3jktJ8HnANvS2CNjJHu05Ej57YFRe
         /DfZ2Y2VWa67fjMtHYYP6F4iAzbyttD0JRWNwRnMAwjZmRm1NRIK/ElLV/O1smD9xR5T
         rD543djC2sfE3Jz6GD6mlNAZeZSd28YdgnrIERk0WSLHP8cJm9z+Mn1ES5H2z2+t6sEJ
         t2/HQW4jM3wqZABfbT9ILTg+I5rrY5AxQafsfcsgJZ6r8Voj/xZal27tSe/t4yAil7Up
         4Qiw==
X-Forwarded-Encrypted: i=1; AJvYcCU2avvSRaPRbUfc1dkftRbb3G/dzEBhVoUp17y0UTjs3AwBPagRNsWn6V0UgoUoptZ4tl0m6XqA+A==@kvack.org
X-Gm-Message-State: AOJu0YyEj1dO+OgY/x85UpLAVRRB+/iLGcz7XXibdj89JXKF/SRlhdpU
	u/5Zm+Ug+57e4w55x+blatNg05jO/MDHSgtSPuUzDO/mnPqRXklquNvFy3sK2oVHJbIpfeOU32M
	bYRIM
X-Gm-Gg: ASbGncvFxahWxg1UwUoRvCisIm1hH11FWGO9QVBQe2V7DF3Wuj69PXcZCpQMtFOmGJE
	CyFlw/Cifeh7+CUpyFUk4VK2F0fz4mqTR2Ml9BjiOyFv6gHLtFnirnOjutFBRmvaN+rsDUeKzQX
	91w04i/B90+i07y0MJQGku6KE7WtHZdyoJ1P1KJfUvPlIyiDjVFt/tiUN9kjizLrQgUQCUMu6VD
	YJEQ/+Ec8Y7I0PKqjCLyQHF89xVGZGkNmZ/MVv47MBHyxiGqjpMv+MgmQRfgTp4/581b63lkys1
	g9Z3WUzshPgNVkvqlbDdfSPWl0PZbee2lOYTx4u2kHnOdXgTHikZ+gG9UfjDScOednz4/7d7QYy
	mJnl1UXr9HiHkQVBRiPy+GXACuxf11w0tVwYiOU519A==
X-Google-Smtp-Source: AGHT+IEcamlanLgHj4e3UiHXnuoZFx6EM5i/6/BHJ22GOTsUGejY8ezIfKRRmd/gWCi23iogf+4+lg==
X-Received: by 2002:a05:6000:3111:b0:3b7:974d:5359 with SMTP id ffacd0b85a97d-3b9fc359a99mr2276811f8f.32.1755174624685;
        Thu, 14 Aug 2025 05:30:24 -0700 (PDT)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1f0fb4asm348329055ad.60.2025.08.14.05.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 05:30:23 -0700 (PDT)
Date: Thu, 14 Aug 2025 14:30:05 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Mina Almasry <almasrymina@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 net-next 01/12] mptcp: Fix up subflow's memcg when
 CONFIG_SOCK_CGROUP_DATA=n.
Message-ID: <ukfrq6ybrbb2yds5duyj2ms6i7xgssjsywzgknxctfgkpzupor@tjxbuiil5ptt>
References: <20250812175848.512446-1-kuniyu@google.com>
 <20250812175848.512446-2-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xhbunld2ijovocqb"
Content-Disposition: inline
In-Reply-To: <20250812175848.512446-2-kuniyu@google.com>
X-Rspamd-Queue-Id: 5EA104001A
X-Stat-Signature: nh97hp66epqkjch499fsi8t33k6yxnat
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755174626-480551
X-HE-Meta: U2FsdGVkX1+llF3R+WdAy6zj/E96mQcx8tyLriYEenOR214DAmFS12iVCLwxW9XkygrMKE9JvXxkGhrbfTZNhgK0cevgd2pTGYNnKcfcCLVKJpmbJ1ijTScR2Ck+IbMVs2c1GaL+a37iwULGp4agx3FGAKpllNxP4zIkju8uGHZbKZb482faBFyvVOcstMiOZ4SrwJsyPECQBQ3cPQWKQWoMb6ylj5zK8eCIoj8sqkS1eUHY4uSk39fOC896zriEPo0NIvBSm4lzaIbW3gcNlSHb7knBCYk07IP1miMBDdN/v9yIG8fiONRws1n73cXnypgPgDWWFshhnWVImzhDLe4PCYnnGEI4Upv0PeRyogr2ytlwvfTONN3cWOAo/OdMjb33f9nwLWze7BcIsdU5iU/rMWwPMDW84kfi0WQO2gwQO96C53PeJ3+eTizeyh4Ex/zN5/AtfHq9EgPRbAzB11OdWN0BWL48ZqZxGa8QXgiCMI1ugxrQCPpkvmEBA+abuM2Ky9J1LXIE1zrFehw8XZs59bu0BxkzPssnmu37Arc5KHI6nug72aQE9Wk0ePr5xQENljoi6uPtQsXnZffqWOT16fjGBXSvbfjhFZ4sGujllSh7vzykBzica3JGpTonr7I5pEbGsMndbff+NqGTi6Cb8Z85k6+7p3bBhnr27w54iIFhf+1NTKIrTED52urtCaOAdWAw+3WfGqLxFLcqjN6dObH2V6CXlM0Kzw4FNrQ0Yg2qBAJyWCkGudYOCIBB1eVaFJP2G75sHSyJjKfn3vXnxswVZ2oGCOgu8x/gFWfpA3v+dpYflfa1xnizNKgwEZx2kpO4j8ZdwRySkdcxNRYgf6xMLQVC6Jb1a8BagDa2W/Imnq8uV4tRKMNHJP/Eu6ee9wmbOHBi8mFsAfgtlfBVb5joQy+3aZzYP3vqbK0LXSm1GSgICiT08BfhTImcOzCLcehOfD1HcBOCKyE
 IgosERqi
 fTEshJ4KP8zNjdqZJCwkBOJTiC194oqJRKCi7jv+9uVLEiRB7Jju03hr7rQWSBejHIFsviowZWjfiS3/nY93ge++ev/cGwHaM3GCpy9008QQdY7pdAPD8JeClAvt18/9E+7bOj0qEuQzE8p3Hw7xzGB+Yaa2pfBgo6kOO5XIjytkMimdBWPw3frjiERTM4eDAiAX57yopVVo1IkdrmDf05g03HpayoH6J8ZcynT7F3bpglqr/kXq5Yrc7KrLi5gRqO3l3LjbZVIXxaRRnau7MtBgTCorFQS1LooZYm0boULmoz0Tgv8WV5sbOSxLwYYkdlFu9ImHE8xKcvNyqHpmQgMwZYAE12SHC0jPN2FWBNgD2u2CXn2TiNNiUepbmFsLLAmTKNjku3Z+VTsk2K8GvryQ7wjLyZNNLTUejQ8wo2DTEPpqda76Wzb5vB64kY/50mBTAIiHuDnaZpwqX1g3Ib7/LFVwYYeN7IiEL76kJK0kG+eLtmTHGxw1itN5Ew9xXgcG0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xhbunld2ijovocqb
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 net-next 01/12] mptcp: Fix up subflow's memcg when
 CONFIG_SOCK_CGROUP_DATA=n.
MIME-Version: 1.0

Hello.

On Tue, Aug 12, 2025 at 05:58:19PM +0000, Kuniyuki Iwashima <kuniyu@google.=
com> wrote:
> When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
> sk->sk_memcg based on the current task.
>=20
> MPTCP subflow socket creation is triggered from userspace or
> an in-kernel worker.

I somewhat remembered
d752a4986532c ("net: memcg: late association of sock to memcg")

but IIUC this MPTCP codepath, the socket would never be visible to
userspace nor manipulated from a proper process context, so there is no
option to defer the association in similar fashion, correct?

Then, I wonder whether this isn't a scenario for
	o =3D set_active_memcg(sk->sk_memcg);
	newsk =3D  sk_alloc();
	...
	set_active_memcg(o);

i.e. utilize the existing remote charging infra instead of introducing
specific mem_cgroup_sk_inherit() helper.

Regards,
Michal

--xhbunld2ijovocqb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaJ3WwQAKCRB+PQLnlNv4
CAoVAQCrDITNqluusq0b12YFFhfY1gKK4Q8uAHs/KsISm9RelwD+JxaqxOrcmstY
zyqaWiykc0r7xJAjUUU3so6cKm+/lQg=
=6bNw
-----END PGP SIGNATURE-----

--xhbunld2ijovocqb--

