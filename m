Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C56F1D3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 18:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF416B0005; Mon,  8 Dec 2025 13:11:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49AE6B0007; Mon,  8 Dec 2025 13:11:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910E86B0008; Mon,  8 Dec 2025 13:11:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A85B6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 13:11:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29FFBB61DD
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:11:37 +0000 (UTC)
X-FDA: 84197096634.27.835B478
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id 21D1F4000B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 18:11:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JvPIYM2H;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765217495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAVxCtgsHDTISHvy9/P05UNsVuYDEFlartNvwhkv40M=;
	b=qmYbMDaFW/Y7BWmV8iRUqujx5nilGJkIKYOQOtfA9Ar1Twem8pte8J7ZYDR2dM+U+lBl1K
	3EL63GeexnVabq8VTFgTvuZqAy4IcbrDk7QwAyeCuZoeein8NxyBX0KaVz8VNizuedzl7z
	c0TMIq2tHZd6WSBf2+su4xsrlVdcvG8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JvPIYM2H;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765217495; a=rsa-sha256;
	cv=none;
	b=3tbXjHmsEr2xsh8PThx1dGREyIQKCt5L7fnajdtCA1cDrr8uJNLcXhjLIlUP17zAVxwGw4
	Un3FKFocxC5mVhcAANiQ1hfDFJe1s0Yworv1+rCuUmWkB/zlF2r4wyqblhNIlc3uBHQinB
	Tt8h0yBQfwbWXQzZzbeFTkxCCdkArnY=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42f8e39cf89so828095f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 10:11:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765217493; x=1765822293; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lAVxCtgsHDTISHvy9/P05UNsVuYDEFlartNvwhkv40M=;
        b=JvPIYM2Hla1xnaSI9N0q1rHT6GM9k6Sj2lzxcJ1G48j6moYIVemA/rgguL7oOw2QjI
         pfA2Eh/H1udPCJPhigEDRh35hR6jQizZyjWmRd+22PWIYKLjGPNG3lgSBG+P3gayReim
         HSO/cRMMowfpwhp9wi3ogW55M89pHktWIwY5viTySh82Qfn4YvqXivUIpcf3W5g4GmCW
         vV9zpit+7fMC/jlyc9Dq8Bx/Al4ZxlGzgh45qjihtlJ8pJzZPIqcsBnbyQhc06MA9EzZ
         BOM9SzCdXUmvJIHJe13gXLLgtQsu0ViG0WBBMD/3XI57e/Kl79LxkY0paAW2z1ib75z6
         UnnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765217493; x=1765822293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lAVxCtgsHDTISHvy9/P05UNsVuYDEFlartNvwhkv40M=;
        b=HeERtQtECX3F3OblUQ0Xs6MQWISxEzDgrQVZ5yY6Eqo/V2BjtJ2B3DOl2cBbj1T8Hy
         itgvpxpwVvtOpCK16yjJVUP7iFAb5ny0LIlwxEDboVad+Su2+xU+Inx/qO5liJih5Wlr
         faKWSgF68P7nhQ3p75RyILBhPt882zqX3k9zfwQXB05vva8mkYIl0b4tyy6p7Hkr1+b6
         9zHtQ2ix2bNSqUHgDowNDEGHhi7i8Ed0gzhPY2B2jHdfmr9kbUqV04bkwXMD/KhFSMvQ
         fgqQ2jMN66ulkKLGIDR6bJzA79D2GSbx8Y8sWxBHMmsj/7MQoaIbkVDvTrFk8+5D5akT
         AVlA==
X-Forwarded-Encrypted: i=1; AJvYcCXFi3uPHLttR/4n4usXy24AzWbMOw1CsgSaTGGz1k+TpmJTxcn+oBtjhefM5eg/Y/71WEYaiV+9+g==@kvack.org
X-Gm-Message-State: AOJu0YwyHc2vo5Qox4qMuX76T8/S3y2kPgDbHw5RQt1X8F3ORIU9IQaJ
	9uDvPExbkxQZvX3iVTZBxAUxf8ENnymsBU0VrgAlYiS86r2EFWVYt9aWEpC4fw7bQXc=
X-Gm-Gg: ASbGncu9mfRacjKpxb0gz3SGwVrDlJ6CsTi7EI+rknf9NdIc5Dfcetq4en5kXoJWU3P
	ebck6ZYnlMuBH0tFjc06bJJIcf5uJn4tW8LO2jirSqRjo4l6gNMQ2dC4q+gLga4mjXU9SoLK0nQ
	tl2U2aFrWlf2Hg3xy8/IHnNCfR1BysQY6LsYYPNhngjwj8WONLDm2qtdAt+y7JPshXtxeGa/080
	Xkzvh/z/lWrdFPYDBz5FYiwSOyy/4yAnClW5QlFfwYtDkB7aBZzJnvxiseCl0onkak9JCtjPh/T
	oyMttBD6eUFVLZJ0AyM+H1p3r+S9jKC2TauFy8nlhB5VfwtJNGPDbkNmaifspnanRTSmrftmFJE
	UuLdvKmT86RYjarZ6E+5Ai0xZxhYPmg+xDPE68ckBWT26us4/31mUPtpn8zUBBFwQxkhezd/7aJ
	b1IiixYSrwky5xwp2+/ntRoT8xFNTn3ko=
X-Google-Smtp-Source: AGHT+IE+2cVlYAMMuUHrQ6cEon/NMQFTDjniz+P5clfRxxL6UeMGxUZ/BfmxJjmjGXBtngb+pB63Gw==
X-Received: by 2002:a05:6000:430d:b0:42b:55a1:2174 with SMTP id ffacd0b85a97d-42f89f70f4emr9230131f8f.59.1765217493354;
        Mon, 08 Dec 2025 10:11:33 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbff352sm26981207f8f.17.2025.12.08.10.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 10:11:32 -0800 (PST)
Date: Mon, 8 Dec 2025 19:11:31 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	"Paul E . McKenney" <paulmck@kernel.org>, JP Kobryn <inwardvessel@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH v2] cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated
Message-ID: <rrpswcxeciypobup7rdwvjknnsjkcnov2xdabbfng7se5yihk5@4wayqftotykw>
References: <20251205200106.3909330-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xxdwkhj7rhflr6ss"
Content-Disposition: inline
In-Reply-To: <20251205200106.3909330-1-shakeel.butt@linux.dev>
X-Stat-Signature: ss3qg718g78cr777g3hxzu3dtf8fgfkf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 21D1F4000B
X-HE-Tag: 1765217494-578919
X-HE-Meta: U2FsdGVkX19vBuwg8vzT4ffdBKSvWDpCyLm48lIejP91jr1ktvuiokIPtMuGiSqzR+H9FhZ9zlX7l+QKGB3OqFoOmmQ/bLJlogVcRS6ZZ+jX+vPHCkkw4RhwrGi7five9avDzs2N8g2UKbRIwx15zFnlPB7kbLuoEAyZsVYdyvC9TBTiJQRPOErIV1cHFmohIA1sYfXnPstWAoSZTRpILYuMXy2mZ3CVAiV8Y931zCA+gN/JOJ/9MSaXWtW62aKamvsHX+RK2Q4WsvBloJiwzHTykwNvX4GgB97Yixu7uQhNYxSpVLZ/itr0ivZ7zxolQziqVghGsXtKmxUfFC20aOz58QM7hUh1HXGThr3T+BnAbSkllFrvErt0CBb9nKSn9UakiG8gjiRaFhAc+VBOk7xuwdvnLDFtx8ix6hLZ4/XDzVb3gR/Gy3xV1/7QKSREhtfBBzaszQpSug46ediIkM3dmZt4GkffPP1wyTh6h0B2bxYDSwbcLZBYF2bjvGhzDYeGfC8AtKIvoldijxLjLiopqw/Y3zrJdkF3oth9qp188ggDocrdWUOj9HnN0zyBznp+TsoB431Owb3PMfr1ehh7ICswj4pGYaisbhl++HsnM2Vk8BFLQeOue22yZ0i5hkSFaYns1xWvqvYfXxJ9PY5viloHRxzKVZzyj75uvECz11Z1hoDVRETs5n9br9lGtkf8Ed54pmrAuqG7yGiwXKLi9wNTr3L8hsO4DwIs0htV4BxIk/8ZwsbH5tYa/eBZkBYggGo6k/EOWsG7FrS5YfgsS4iXllhaWd2iAji5sri1GTFxaOoaDpG9Il0GxXGWo6ymMzKwU3PvzEFZfkXRR+7LPIVaQi3my6rRHX3pcQRBm4ypMqnrvhuJ5kHWponWWPQqQC6ZA0RUV5zqJOezd8lLFlQDZtkrZqYOsgYbMEW0lG/LNpZMlOrcVneU8DOAntgK0s0BAZiR5y7B1qA
 OMJoiai2
 d5gFgKwVMRjzi2eXCDB1dTOC35zdOXLOmtXK1HM7Gzq6UPcEuSMXUQi3OWeHFxfbe4t6HAMJ9NeOf9hP7b6TaZM8tNDfe3J6zEAM97Q+junCFOIj9nJmyuMNlE7I1o4ipAtQDQNdCXvuPLRjdsMYdZjn9HQDpEoMldlpIPvGPtdsE6AlzT7L3WECdO28VfSDK9ki9yY0dwsWCDPlyZepNzBwyi7Nd+7nyYAkEWn12f/fZrbijCGyeX8EIz0npGbF01TXdOGTMYlU1Blx3IBhAaL1WfwCUYTIIWsE1vknRQ0tXGAHMyxXjCffkpm9cP7a372BbHzsNevoUhd5xBL7J2taghNprk0xk8J9QKNScDsB7HzDgshsVghyblYeTNmomybjHMvVx9401mTWoZ7ac/Io9y99/VQ81+9yKGnsvw9C4yUf+aijDIpxd9YHpO2ocnO/LCpPtBBJCqqYJL8NXuJzOTACQWnPQ+8Ur
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xxdwkhj7rhflr6ss
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2] cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated
MIME-Version: 1.0

On Fri, Dec 05, 2025 at 12:01:06PM -0800, Shakeel Butt <shakeel.butt@linux.=
dev> wrote:
> On x86-64, this_cpu_cmpxchg() uses CMPXCHG without LOCK prefix which
> means it is only safe for the local CPU and not for multiple CPUs.
=2E..
> The CMPXCNG without LOCK on CPU A is not safe and thus we need LOCK
> prefix.

Does it mean that this_cpu_cmpxchg() is generally useless? (It appears
so from your analysis.)

> Now concurrently CPU B is running the flusher and it calls
> llist_del_first_init() for CPU A and got rstatc_pcpu->lnode of cgroup C
> which was added by the IRQ/NMI updater.

Or it's rather the case where rstat code combines both this_cpu_* and
remote access from the flusher.

Documentation/core-api/this_cpu_ops.rst washes its hands with:
| Please note that accesses by remote processors to a per cpu area are
| exceptional situations and may impact performance and/or correctness
| (remote write operations) of local RMW operations via this_cpu_*.

I see there's currently only one other user of that in kernel/scs.c
(__scs_alloc() vs scs_cleanup() without even WRITE_ONCE, but the race
would involve CPU hotplug, so its impact may be limited(?)).

I think your learnt-the-hard-way discovery should not only be in
cgroup.c but also in this this_cpu_ops.rst document to be wary
especially with this_cpu_cmpxchg (when dealing with pointers and not
more tolerable counters).


> Consider this scenario: Updater for cgroup stat C on CPU A in process
> context is after llist_on_list() check and before this_cpu_cmpxchg() in
> css_rstat_updated() where it get interrupted by IRQ/NMI. In the IRQ/NMI
> context, a new updater calls css_rstat_updated() for same cgroup C and
> successfully inserts rstatc_pcpu->lnode.
>=20
> Now imagine CPU B calling init_llist_node() on cgroup C's
> rstatc_pcpu->lnode of CPU A and on CPU A, the process context updater
> calling this_cpu_cmpxchg(rstatc_pcpu->lnode) concurrently.

Sounds feasible to me.

Thanks,
Michal

--xxdwkhj7rhflr6ss
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaTcU0RsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+Ah/WgD+KoG41+NA0shwqndSMfLf
NKaf3TLNxpT5rbMR72AmSkIA/0gUzIXL2v+ADYvYPkK/71qUo+l1A7Ki6u8nCkZi
f5gN
=Aghw
-----END PGP SIGNATURE-----

--xxdwkhj7rhflr6ss--

