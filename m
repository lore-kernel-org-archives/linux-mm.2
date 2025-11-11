Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14258CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 21:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7074A8E0003; Tue, 11 Nov 2025 16:01:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DEAA8E0002; Tue, 11 Nov 2025 16:01:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61BD08E0003; Tue, 11 Nov 2025 16:01:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 512708E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 16:01:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EBE9A875C5
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:01:42 +0000 (UTC)
X-FDA: 84099547644.16.A85047C
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id BE9674000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:01:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YQHKKnet;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762894901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOtZbxVqz3T0EH1q1J5hisXUupKcXN5oOYovjWYI2BY=;
	b=ejH6L3bqSUVb2S2ZW2BzO6WQazVqk/whuutIDTy7SDkvOC/lhYo4cmvFnw7IJ8vymrLmTA
	oC3RvZAp5eT4dr3cwcQqyWEnemw/2/+QSoJv5XdL/sr/laCvEDu3I8lfXy6myjp7p0REcV
	2O6Fbi6aK0S9osVBSmayvR73vidKRvo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YQHKKnet;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762894901; a=rsa-sha256;
	cv=none;
	b=Y8VJYZCJOUon0aTKDEUYW/PXQfzFYj08JK37G12ZVEtp7hEwRHWVFxXyLabpgCfvIjEGvD
	13+CRipeOaTrfoLcfgM4WrfsZLgkPqvTKRFeQvphn9GAYoblJexMCUedKEL8/s6ZnHOSz+
	NJ7nWuuFdRZ3e7S7XnxIlqsTmZVraCE=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so162513a12.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762894899; x=1763499699; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AOtZbxVqz3T0EH1q1J5hisXUupKcXN5oOYovjWYI2BY=;
        b=YQHKKnet3FjFijwLGXTrIfNLlOo5gemP9c3fGD4zpwcm7J3AL+yN/I9jNlFowsA0q3
         OThi/TlykT3Iv9QgoQRHqlaD4z0x+P+SGHSnlMSLJ64DjjPYO4AuzTX4SlKwfhZTF2Zg
         FfVjTdJdkkCC7XhX1V2oGINb5BjVOKV0xKVECtOam30qf7CZ8/W7yTQdrATOPlxnUWLm
         2P9IlK+ZKS08A6PPpIvrpH/VbY721zn5TDe40FoDTiqsgVDdGa6jk3/pJqP406DrjrK/
         CVHeS2hFMuFIdzeWKgyCcRutiaraYgQb4pFQj/eVUokHRZwcTygHawTjBvV05ALymtKC
         P5Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762894899; x=1763499699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AOtZbxVqz3T0EH1q1J5hisXUupKcXN5oOYovjWYI2BY=;
        b=U6gGQC8oU7sQJJ/1y3BuIMIqMBycQuI4SA4R7QQV+fM0nOBfwajjshkSlsYq1ibNAs
         U0D1hTyBBufAkRPUtUvM62/9RT4y7/Xv5HHX3HkpucTKKvPZKjPkbi9btPArPUMNqxM2
         DR1qFhUkPuxvvVq6oQLnRZAZCtkiNbobQSQTUIUUcII3UkYj6/5EMV9HyM4X0nU5FfRr
         C7tJ25x9zf4MH3ixSSx6nNDByK/2K7naz3qMkwAdm75X28GOiJ4+/O8K4uRBCvv6Cx09
         Il/cOQCgAxFMQHdyndhJPMBhVUetYMMp9cHLyp6F+DA4928CQbrP+I3gGTIMGKKbr0W0
         aHGw==
X-Forwarded-Encrypted: i=1; AJvYcCV15jqFj35ahJZWy1bxIi2kbhDqPp1i8KYn0pZzUjl3IxoWmUYpBKYOlwRpzmXRH58U0j8ywggQuw==@kvack.org
X-Gm-Message-State: AOJu0YyNnuTz70is7+TweBTylzIanQLJmW5m78LawbGcOeK2k8Jt/dxo
	WR78FC/z78lgj4apC5CYf6R0KEOdP8cKpxJo0D3A/Rg5uI4CPnr+D9JmpMHl0hAXQs4=
X-Gm-Gg: ASbGncuXbX06ua1r5PB6y7iEy75e36VU1nxcGYCJW/H/xy5B7Cqo4W0wxL4OldwSB0u
	0ZIV/neDmtKXLztrovOdJy0FeAmsIWKk61U3+GEj9vLWURfm8uOScbQ2GMbRZUTdA+m2wsQe+wu
	g0SW4QmCnZ9/x/63GSI3fmYxHACuV/7J/F8TjqHhFAe4qB9/NAg4LOzJNktUIFClFMPV5E+pl2c
	8Ls4OIbsyY0S9c7s/jL5UgK9oQdSX03XUPK8BrgMvy2fbTK+by3hoD86D9dxbJ3+fM5fSEQIvhz
	3cKKpkVT1AkgCb+0635YlPjV894wTvl2z7LfSTsg8pZieEygRyjJZh4ZU6y0x9qM2+IhIQW/C3L
	+kApHi3eegEY36GARJfrQ0Ygq+d6fb1GnHRQEDQ8Av5T5flDEuQx/5AMOH+tMVlYZ1fK/NOSFyt
	Ne+2+Eaxmmx8HPaFVz0vo/qYA/
X-Google-Smtp-Source: AGHT+IFHxQR5RsZZYuu15UkFc5wCGawdUUh/83F65t7RT/bR8gwY77ILDOKtOxH1D+cIwgNbNyoHRA==
X-Received: by 2002:a05:6402:42cf:b0:640:9d8f:3c73 with SMTP id 4fb4d7f45d1cf-6431a577ae9mr518057a12.32.1762894899315;
        Tue, 11 Nov 2025 13:01:39 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f86e12fsm14093400a12.34.2025.11.11.13.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 13:01:38 -0800 (PST)
Date: Tue, 11 Nov 2025 22:01:37 +0100
From: Michal Hocko <mhocko@suse.com>
To: Waiman Long <llong@redhat.com>
Cc: Leon Huang Fu <leon.huangfu@shopee.com>, linux-mm@kvack.org,
	tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	joel.granados@kernel.org, jack@suse.cz, laoar.shao@gmail.com,
	mclapinski@google.com, kyle.meyer@hpe.com, corbet@lwn.net,
	lance.yang@linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
Message-ID: <aROkMU-OFAmYPBgo@tiehlicka>
References: <20251110101948.19277-1-leon.huangfu@shopee.com>
 <9a9a2ede-af6e-413a-97a0-800993072b22@redhat.com>
 <aROS7yxDU6qFAWzp@tiehlicka>
 <061cdd9e-a70b-4d45-909a-6d50f4da8ef3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <061cdd9e-a70b-4d45-909a-6d50f4da8ef3@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BE9674000C
X-Stat-Signature: 5zmy7pjzsmbpdn1d17jh5cudexqid5h6
X-Rspam-User: 
X-HE-Tag: 1762894900-507949
X-HE-Meta: U2FsdGVkX1/VEAN0tUh5lMQSt2iwEH3v3/97uYPSMl2WdyUjCt9AdBuzk6Ieq6xLDsD3RpbBV1umYaahZWvqB17AQNuTQAojwk8WxELwUkCmMjnjqRoN7Jtl0fZ7lDjWrwL4wajn1E/5i0i+0S88sWJd8edp3ej6ukOpt8L2y55xmzPyfVl6cn91fTQXCHLBbL3jAgGmNvickQZXbP+kP+O9Cuk3XfNNnsWH/90caUqNXnQsA/oKEu256AlbS27KVlmFO1m8dWiFPCvIWf+PiZ5kOvWtgo/ObveI3yz07ckTbP5GfDs+8xF0cqhR2fCvPfqmyu+WiSDs9mSq7E3QW/MLHqEQZx7Yqidwp/9CNWXYDUe5Z+8ogoCY0uthU8l+6IfX2z6h6+XfM+mXMswo74v382i3RhScVnTOLH3uqDds0tmxJ3UqjH7w+FzhBFo86dYR1+p1hFEtU/Y8/aQ+F53xCLV9pMJ4VcsqOAQv3TguW9arBkmJcrL+A1zP8nm8YpPDe8fx2fvWPfemjXdCiZn1nDbbxl80hwPmL0vO9jNT5X4XkQeEfPGgOGn+h4BLEsd2Dn8020tWzTcxUurQs0AHpKrvrZL4bQH1z1O3AZl8sgGIvzD1fdQR+TyefBMXLeWQqa9jghhQFfy6/MYBnIM3mkpSuJBZQ/2V9eQrXh+rXKhXF2LOpSHA7ZyoPg2OAcqAsv83QaEPPcd9NSupzo6QLKUPEnGcfHyvRKDAbzutU8xP+ah4QfS/DYbQAqq2uxpDZ0aI1jXMlrwMQMuLdKNj75gnwCZJVyRTVbZGgAs4CRhdj/odj1JEaTJsAbfSNhvgx4oMuEpg+omA8vVEE8fEgrzpHEvip2Br4ksYg59XU7zzKNYz9Jt9NKvFSdpvNP799KfHJVieSbvwsc47Qr1pp1p9aSB6qycfVZWGNyRnakVcPWY/jXduwyZpqU6Duad1NUlcTowHh+UbG3n
 hqapcUL+
 On97YFkJIyHZLb2GqqN3amzpfEXSLJYttz76RfoESexmA2rLS/Hsg5JbSXlI0e3Gi6aEUVunZEXQ6WEOwhAK9wT3yJubrP2YzDlqqdyHyRsulUkqUM6x0vkYsD92I5RmxUxIX9Z6SMYUj8Q16xNiHsrbXRVH6QOyKE6SWhrxO/XAkE335RmJVuHZwvV3TXeIXG4BNgD7fd86NeVqfK9nzsewZeDE0kcZ25/Dbu8CuDMQ/O593/UlYy9UIovMtHpXsNhk9X6M1kLDjqvOxuUjX699YU+abQ/El3STJxbwYA8j+eofKG0ujluZ1c1dSYV9o5xlZXo6TVW2npgjPYm0aX129xwYd0aJYSJVWPNNu9ougs4e7nBMHDjZ73RKxhZ21mboXI4Nxi/Nq7+iQfRA995ywQz0XwMV9eBYdutdyHiMUO0eJJgPnyDtkjSdjIsWjSRezJ7DgOpx03veSSXAR1xqLawWPgSWNV6af
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-11-25 15:44:07, Waiman Long wrote:
> 
> On 11/11/25 2:47 PM, Michal Hocko wrote:
> > On Tue 11-11-25 14:10:28, Waiman Long wrote:
> > [...]
> > > > +static void memcg_flush_stats(struct mem_cgroup *memcg, bool force)
> > > > +{
> > > > +	if (mem_cgroup_disabled())
> > > > +		return;
> > > > +
> > > > +	memcg = memcg ?: root_mem_cgroup;
> > > > +	__mem_cgroup_flush_stats(memcg, force);
> > > > +}
> > > Shouldn't we impose a limit in term of how frequently this
> > > memcg_flush_stats() function can be called like at most a few times per
> > This effectivelly invalidates the primary purpose of the interface to
> > provide a method to get as-fresh-as-possible value AFAICS.
> > 
> > > second to prevent abuse from user space as stat flushing is expensive? We
> > > should prevent some kind of user space DoS attack by using this new API if
> > > we decide to implement it.
> > What exactly would be an attack vector?
> 
> just repeatedly write a string to the new cgroup file. It will then call
> css_rstat_flush() repeatedly. It is not a real DoS attack, but it can still
> consume a lot of cpu time and slow down other tasks.

How does that differ from writing a limit that would cause a constant
memory reclaim from a worklad that you craft and cause a constant CPU
activity and even worse lock contention?

I guess the answer is that you do not let untrusted entities to create
cgroup hierarchies and allow to modify or generally have a write access
to control files. Or am I missing something?
-- 
Michal Hocko
SUSE Labs

