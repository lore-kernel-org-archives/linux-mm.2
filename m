Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FCFBD31A3B
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 09:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3876B0005; Wed, 14 Jan 2026 04:56:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971326B0088; Wed, 14 Jan 2026 04:56:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87D226B0089; Wed, 14 Jan 2026 04:56:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 763DA6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:56:26 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB11F1BA93
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:56:25 +0000 (UTC)
X-FDA: 84330114330.30.376F767
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id A195740007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:56:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XF0qIbuU;
	spf=pass (imf12.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768384583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Rh0E6Gp2esSNQLEh23mThKotD32Snz3s+UKt6REioQ=;
	b=nn4Ufkb+PWYGCiCUmiAnAVdVj6QiskrmTLeyDDRsKghiVhtgGz+MMNGCCS7Ox8hO9A6e8A
	KxT0PWvHU9YEslZrwKIBntyQ7v33kLqrlMa8iFmWd9WAsCmeVMqhvbn2CtRFlqxnnu+k0J
	jkuzL0kqtpBSTK3UxV+cpS+aTdp+SJs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XF0qIbuU;
	spf=pass (imf12.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768384583; a=rsa-sha256;
	cv=none;
	b=uV5bIPuxMaGnqrBgakhwzmF3eKODXhoajEpjOPlZ00df29UcfsV7MErx5u7hqxkrUeGXWK
	ssGIbEV9XiQpbH3771B4AzYJnqxm4MLo7U++sg+uOldkpOhEXNPeLdVn+0mjO7AtPSHzHs
	edWg766eWQYfFMZKn/5E3D87UQ1V4Yc=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42fb0fc5aa4so6324954f8f.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768384582; x=1768989382; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Rh0E6Gp2esSNQLEh23mThKotD32Snz3s+UKt6REioQ=;
        b=XF0qIbuUkptagzPKgjue9XnfNO3SXSpXEMgJxlsKUjw8B3x0TY2MYQS4uaazdGkHHP
         zMKp2qR2d85+D4e2GKu/LGgTcGNYHsGfIfXZemE+Qv1p8X1DHGp11l1i2cP37ybQ6E0s
         QKhWUw6+5hlwj/5IgHAEJjRAYfi3EzxXNmXxHdH3ucyZMkV2qsuYNn9VBCVj6VmWply2
         8901EuhgYL74Hsb7oCukbi/0CHAmmJFppCCHuZ6fB47KdxE//9tsYMLx/RlHWAYOZRwO
         IAagNVz9HKH00cb2adkaphba8u0+NcYSog6f3x5WMvIenAL61g1RxrTy/50xn1E4OPGv
         BzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768384582; x=1768989382;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Rh0E6Gp2esSNQLEh23mThKotD32Snz3s+UKt6REioQ=;
        b=Aa1zhfk25vT4RA4KFjV3gJXnIXy1ybUov083ZBQR+5V9lmNsjz3aH9DUfmeeUivPvr
         PbplxJuOJZn9fXmItkwcEmjgne/mPsYHTITXdnW2iI9X2BqFrP+kMru8s1fLmQQul1fw
         /0OOZDglB6pZWbmWtcoL2cEAb4u15UY/XGDr/cN63V96jFHQv94Ct9tIShsh96I17nN/
         J356RXfaGVdvn17MUhv0rUPWz2CStE3TjeJU4uT3vjwNwrnXvSUG+YtggiYdvP1xUseu
         po2cYHAq4LboZjqBNQ+v8Jetlh5DqmY6kFqtMesnvLtX2tHuyg4krnDUhdaa3epjJwVW
         6CsA==
X-Forwarded-Encrypted: i=1; AJvYcCUi5Hxp/U1aDsls0DUPTbZvt88NdArTINE73q4Y65XrSkSnINerbvWWmFmfihzzZN3KYaKhBZJtUw==@kvack.org
X-Gm-Message-State: AOJu0YwUAOTDpN1X44KpkMvaV8uqcGACpslHjf5kBAtN/TUaxUE0VGfL
	r/yoXthw0joM+csR1nrZAfHkUdcc/PGc9CIRTJ/5h9kaNMTtW5DHC0fQqIbw6hWlAK8=
X-Gm-Gg: AY/fxX4WFs28feKwyILJ1YBYG0TlX+Fv0rCsCNoewr7EqNjsH42CR73TFfCA9k2gH1X
	CsTEH4iJlpPG7ceW6FSSwur2o439gZPy4iYqoLxJieb04FTnrfEXsiYLIi9yuKYgOW6BkTBV+By
	2YCcAvzURjXgWpJk4p8BmjO2MmKBoGJ0+4Ux6sdG+Dmo3XkbbmeO8wjbzvpO3FqvU6EHFW36SPi
	daWR4yvNIZV2iUjrPLMsYSBOtSe21u8vGymkCzAri1lkoWXUQTr0IzJESLOPI4ZGoHPi24/FUPU
	VEJb/9cA360K7AuLbjgpZZ/k6stql0K5Gus1wlCGjfOI/PiUTXM9Ud2BcRGYVOYnLazNMSO4DzW
	q1krQpAuploloPeO/0hKizKd/SLKzE133mbkOU36FXX7zAh2R3ll59UZ10jt8hhBxUrGylY9pQa
	0NhYDRSwNcVE2x327y6N2SIMfLqJif2Fk=
X-Received: by 2002:a05:600c:6992:b0:479:3a86:dc1a with SMTP id 5b1f17b1804b1-47ee33aa21amr21454545e9.36.1768384581898;
        Wed, 14 Jan 2026 01:56:21 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ee28144aasm16156295e9.11.2026.01.14.01.56.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 01:56:21 -0800 (PST)
Date: Wed, 14 Jan 2026 10:56:19 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: roman.gushchin@linux.dev, inwardvessel@gmail.com, 
	shakeel.butt@linux.dev, akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, yu.c.chen@intel.com, zhao1.liu@intel.com, bpf@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH bpf-next 2/3] mm: add support for bpf based numa
 balancing
Message-ID: <cfyq2n7igavmwwf5jv5uamiyhprgsf4ez7au6ssv3rw54vjh4w@nc43vkqhz5yq>
References: <20260113121238.11300-1-laoar.shao@gmail.com>
 <20260113121238.11300-3-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hlubd5uybwds24at"
Content-Disposition: inline
In-Reply-To: <20260113121238.11300-3-laoar.shao@gmail.com>
X-Stat-Signature: duacppi4b7cs3138rsw3weftbbtz8h3h
X-Rspamd-Queue-Id: A195740007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768384583-212651
X-HE-Meta: U2FsdGVkX1/Xc19pa6Rp3PwDrEwl6d/1qZ5MaAsEPd8QjCYEtUnXi2ljSsjpk6DBuyg0BuV2XbUT+Y7VdI8fHiU4QSMXd2iGiR3hDQge2U5Lk+iZJ/wsEyslACqPz284vSpveXtzgRR/RZjn6W4WPvF/yIUUNfz6BQimZDE//cuDeBQhvkEkxTU7htGv5PVxAGYxW36fvtn1cudgEbZJQfI47Stw/oxX5RPWk0ZjWDUZLPHwkmOc5ZRes0/ovIoqFSzVAFUX0HjqBTMjs93R87cB/pqmVcwI+2kKHaUbOAe8wp4+RtRPrXRTDjSVh0yq8W8CIcMzIwR/sWM0Snt6QuWLQDmMM72439Z/uNa6xYkVOql7ayzpC3esSV+koJGTIqI30tV/IEbkxhSpZMTNVEGeM0seDAybbATyBS9oK6w3NNItJDQs/TwYcpOa5So/nqqBubIN7CewxfEwJS0yFBTH8irl3K8XnmsKAJK69cY1a7NvSAtgzGK9k0rSqggvCvS+LvVeylWyxFZssN0PuPHRxDt+Uquh+4jv2UujjNofoYNoEqyPCNawxZuXOn0mjXqzlR/idD2cLoV1z8L8JA8QFitiRZG3CpuAe2aIBga58NikmuGPFLMs7dserEBLIRGtSsYmfH/QXNlt+AdqrktCPkDTdsVqyiwsjI9NCAleL/jnsRoYXX44POp2UecV0GAiOcC0GdyxEwuRcruQo1Yvt7BvgBFp3PM6vWcPHGaAqGrEPu0mwwqChjkduPhmiZu2wzSORx/sqRLrWFCs4GQs0htjX1uyAuaayLU/a5u8OT7ODKsv8nJOqgq7j0UraYJhRFmjX/Hd+v3mgWCCjVaTs9OPfGic1JPVPHnL1ox5wwHfz/A6OVUKIvWYIBisI+/jyzNLAD50Ucse7X2lL1ciSZXD2QsbdpEL+KWPctZO7x+8+I6TU860GievVFRLM0ijzvIqkGq1Rxmq/93
 /DAKXPnT
 TU5YgCwUU3GcqszfzJhMGoE2Gb/uTJ3snG1+YcJXswWduCpicFb5KfwAE//NWjjnE3RoDhruo67kGDUyxR0te8vorQAaCexA22bDVWHhX1oko9NHueEIguu71jSjc4WidpXaNwcf1Ut7QtO7pKlQoCEN71Mf9WSRorEwgHk8wkOGwVFQ/j+4ktgSXHgIfXZ+Y4evilC1zyMXaBPbNygieqWUi+NG0FG6z7dBX/2noQck2ZfjvpmaTWh6ocrILGNp/m5yv4MyIN8sA6Mwx9+Gb6Jc+NCAQrd6gcZBI3xxknlV9SxWSP/8I6Qr6IrHSZMM5t0DQVI9TEGq1oQgzc9fn3p5O0/brbnBYGZNYAa61tnmvfmc9kg8/YY6yb4QYLfx1l6iWk2wMdqQ7BzyXY8mfwhHhti2z5YEFIDHtXqcMagLtkHWPxmdLHhLhzeaaSw0nVBLIJSbPcVe4WtuY6GfVJM2BnhsoGyVdZYLP6/sqWfBRm0+aQ4TqPogfYtFJt/NJDPOsLP1av3BDhN5kPad3wXGXwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--hlubd5uybwds24at
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH bpf-next 2/3] mm: add support for bpf based numa
 balancing
MIME-Version: 1.0

On Tue, Jan 13, 2026 at 08:12:37PM +0800, Yafang Shao <laoar.shao@gmail.com=
> wrote:
> bpf_numab_ops enables NUMA balancing for tasks within a specific memcg,
> even when global NUMA balancing is disabled. This allows selective NUMA
> optimization for workloads that benefit from it, while avoiding potential
> latency spikes for other workloads.
>=20
> The policy must be attached to a leaf memory cgroup.

Why this restriction?
Do you envision how these extensions would apply hierarchically?
Regardless of that, being a "leaf memcg" is not a stationary condition
(mkdirs, writes to `cgroup.subtree_control`) so it should also be
prepared for that.

Also, I think (please correct me) that NUMA balancing doesn't need
memory controller (in contrast with OOM), so the attachment shouldn't be
through struct mem_cgroup but plain struct cgroup::bpf. If you could
consider this or add some details about this decision, it'd be great.


Thanks,
Michal

> To reduce lookup
> overhead, we can cache memcg::bpf_numab in the mm_struct of tasks within
> the memcg when it becomes a performance bottleneck.
>=20
> The cgroup ID is embedded in bpf_numab_ops as a compile-time constant,
> which restricts each instance to a single cgroup and prevents attachment
> to multiple cgroups. Roman is working on a solution to remove this
> limitation, after which we can migrate to the new approach.
>=20
> Currently only the normal mode is supported.
>=20
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

--hlubd5uybwds24at
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaWdoORsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AiIeAEAyE9SkoPTsyFkBRkyPBoC
pzkAGjkincYpSGguv87R/CYA/AjBG2txgb/mG2NlcFAsgUWYMsnoFANpNYkc1sUa
9lcE
=vIqs
-----END PGP SIGNATURE-----

--hlubd5uybwds24at--

