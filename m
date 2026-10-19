Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4727606A319
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 19:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=gL/NncMX
Received: by kanga.kvack.org (Postfix)
	id C76BF6B034C; Mon, 19 Oct 2026 15:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27E06B034E; Mon, 19 Oct 2026 15:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B174A6B034F; Mon, 19 Oct 2026 15:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 827F26B034C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:12:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75A1B407B1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:12:15 +0000 (UTC)
X-FDA: 85340321430.01.1C53C96
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id 82EF51C0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:12:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="gL/NncMX";
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792437133;
	b=D/Lg3k23DUKXrYT0f0Uck5rvQWyy+g0pqa9VxOK69l1qFruI954OKQcjxwGWtiitXfF6Zw
	0INk7pxgMw2ENUp+QbeMi4eElG3+vkWYxmOOrE+qROGWNb+DeMRV4nKULxneozjSleTn3C
	6fGoXlhBmsXfNFY5jrWf6LuIR8n2AXc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="gL/NncMX";
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792437133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brXSmDy6U/oRKvH40grJe8uDEK1S7rGaavMW9jk3fYA=;
	b=l3neJWAYIM5ZHkVNvtytthYhG6fEHW4T4VveJ2hLyljSFue/L8wZf+aTRzprtxDrLhoXJF
	vFnzkCH4bqPYTKHaFNLsdvOYAipXFuKIxn/B3OxtYV6xPN3Dbco/kWWTjLGttg+BwK7JSG
	AkGfwFjKL2ppxb/k2XPhGwjdQf1tAcg=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b3dd83e779so1052453a12.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:12:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792437132; cv=none;
        d=google.com; s=arc-20260327;
        b=se40p6PKCrlQ3mrrEipkCkRgDTwM3wGAgyPNkw4AGyGLZpsnmRovyldQ9BsZglbwRm
         tcfnShxaFDYur2m0zYJem7wZyr2AmDd/mLq83pnRACb+IUIc29cdZdaTWFJ0uucvHNmv
         VO+O2F4CwsNAI0Btcy47UOKgU9Z2umGIRld+YjacCExBbzgAtWk5gr8D3sr7Mhkt22Kv
         E1uqXkOpROBBLbEwjjNtLsmutBpVw8+Oh6lJB/8dEKLypCQHlyGp0le1z9JpIQpl8SHj
         JcBjf77P6NZoDn68Ts60Nif8KDWQdIEDMkvImU7OhNh/ggi3i9gB52vZ7CC9HIijFxxG
         rCTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=brXSmDy6U/oRKvH40grJe8uDEK1S7rGaavMW9jk3fYA=;
        fh=IH5K+FKy518sPqA5tgctPxDh4IOI7NizXjGXR8eOM/o=;
        b=fCkf9emCW6egGD1pfxXukxMztqr3DMToJK/nQrYfSGRTcy3amFL2V3m2zSImc7vTXn
         EDGkUJFUVTuWIs2lIw41prWW0Ik6pIEqmctEwABmX0q13ruHeTb6g1ZIWNplGKcv6GYN
         JCZCbPdjr+mYScz2el/Jr3eZtEUZ6hTtxu5s+iol+VLsNFXzC6nRnBZMPIDCCD6FcLJU
         5CEMM9n2GDhMavmzSgkxywnoAFGC3HZdyzGAkCFz4+wJ3jFxbul5WC3s6iROGN9Z+2yT
         GCtF3rcpqrsMR+DOzJy0S+3B73MWp52uyvjPhUXZQ8z8KnlPlN66kFMl6LxOif/5Ef+I
         LbNQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792437132; x=1793041932; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=brXSmDy6U/oRKvH40grJe8uDEK1S7rGaavMW9jk3fYA=;
        b=gL/NncMXxNfRRpv5Z37QgDpq/S2biCd+ffkvfZuLVzs0Pc5DUUOpjNImlLrwWRAC80
         UMjVApmxpwyoa80irdtCpVoZeXLA/4nQFbRsDZ33PBYvUsATG940nE7HVIC4Bs/p1Vjb
         afaLQ8BE8wclIAghqpfUl+30JLkcHquRHE5qkAeedc6Kvz7S9Ln3tnSJ7acqjs9LzT5R
         VCU3f4l6osFrikXmpnL3tkUKHQgcNCbXPAXNq7kNiHfHlJC/QpPipmsvOG72qX9RWlZI
         OHfuf/z7SOqS+jKSGhfDGl9wo/rprkYeCd5gKQG6YFGXqo+8m6zzrgiUPeqs5cFyIVgP
         MHhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792437132; x=1793041932;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=brXSmDy6U/oRKvH40grJe8uDEK1S7rGaavMW9jk3fYA=;
        b=NprBPqpsLfr2pJ192LhcE7hj+DJiWNrjS9zaAHFI6IPGJxGJlaXoykrdDJjvo8BQrl
         i70firnp4c0q+c9jOLpHmY3rkuJgmNSHhQrgSUVRMhxzNbGRaQecckDUsOJcUewHuA0D
         hI16enlj+KO8z0KsdzHmJz71E6OdyCrWkCooUqczpuHLdV1iOP3GZDtcj7iqagtuMZXX
         Ja/gKzXnui9WqCkPdsKdjcdiWGeuCb72Pf4h80Kuw3Jhc6RFLJce6u6aOZLyklpNmN0M
         22NsUspfGAKKBXAMLhSvSIwEjXOwPA7v/5ddk6cXRhqjiTFR7DLtEIj4GM8TMKMegaDc
         jTAg==
X-Forwarded-Encrypted: i=1; AKwUvBy86ABSDv45FX9r2Byw9t48Cd3xLd1G6EwDY5/pK6b/Dr+F5nY2XRxOQga3GPZbvTe7PwULdXJItA==@kvack.org
X-Gm-Message-State: AFq9FYKR4zQEuRJOqKKo+KyImk1vdtmq67TKoeZ+T3Cv1k0/9la8isrk
	BGBIPiP3ok1lZaXadgbi0AxcrBKQriUTeerdJZUDLLX4pWl6YbLH7dFitTWdpBkM878FLqZrx/U
	in127rG6robncp+U75Um8xi1l6Ey83QsSol4AxahVaQ==
X-Gm-Gg: AYBFou3HpOuKI11CZjLJMoRQPWDW17tjJehdFHnTYDyGfhDK72FNwz64xe9Mu2M4VYq
	FNrcjWwNVNUfRD3HhYpZJRU1B8NKLYxG8k+/SA3Y1gfa/HgN8TDSKOwgzpURIv8MNVnNeEr7rJ9
	Z1fmx8D8wAuzAN9RSvip2y3158RB/YUsJEUPu8Kx/EazF1aja7pMfSy/44aZESbF705p8RFHCQm
	Idk9HzA81bawqGHFOlzRkx6o2m6kSPsvnpD1lxDTgMnNpBQ10pWNuoANTEYoihWwgkPjit2LHeo
	2n4LEawRFZIsBkGGXbjSBEQLahGI5dDJ3s037iAlRH6MgVR4eKRYp5dAz8cplTLfWJJ4KXXDEpW
	aPhS4jekEDl0JE4cjxWHN+Ejk6k/LiScP+51T2fe4wUpLo6ozHsRS8BDcOyVcd+3ij5bst5MyIC
	ZvcUqmwDV2ExMV
X-Received: by 2002:a05:6402:a295:20b0:6b1:c6ad:ae3f with SMTP id
 4fb4d7f45d1cf-6b3a8199b12mr3606189a12.35.1792437131823; Mon, 19 Oct 2026
 12:12:11 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019011446.834487-1-pasha.tatashin@soleen.com> <SJ1PR11MB608365E406C4DA7CB91858A4FC982@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB608365E406C4DA7CB91858A4FC982@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 19 Oct 2026 15:11:32 -0400
X-Gm-Features: AclHuK81i0D--1zvoLFLDSEjKdb8OtLyg3_R_Omdu6BLSuefBq3mveb_0VEz-04
Message-ID: <CA+CK2bAQr=Ak1u-Aiwbw=DZ22Nk8oRDqnC2AnRaez7nOyJj0-w@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] x86, sched, mm: Speed up CPU hotplug on large systems
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "kees@kernel.org" <kees@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"juri.lelli@redhat.com" <juri.lelli@redhat.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"tglx@kernel.org" <tglx@kernel.org>, "vschneid@redhat.com" <vschneid@redhat.com>, 
	"kprateek.nayak@amd.com" <kprateek.nayak@amd.com>, 
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>, "bp@alien8.de" <bp@alien8.de>, 
	"jpoimboe@kernel.org" <jpoimboe@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, 
	"david@kernel.org" <david@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"seanjc@google.com" <seanjc@google.com>, "ljs@kernel.org" <ljs@kernel.org>, 
	"zhangguopeng@kylinos.cn" <zhangguopeng@kylinos.cn>, 
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"Gomes, Vinicius" <vinicius.gomes@intel.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"peterz@infradead.org" <peterz@infradead.org>, "surenb@google.com" <surenb@google.com>, 
	"hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, 
	"dmatlack@google.com" <dmatlack@google.com>, 
	"tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>, 
	"kexec@lists.infradead.org" <kexec@lists.infradead.org>, "pratyush@kernel.org" <pratyush@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, 
	"gmonaco@redhat.com" <gmonaco@redhat.com>, "jgross@suse.com" <jgross@suse.com>, 
	"mgorman@suse.de" <mgorman@suse.de>, "Graf, Alexander" <graf@amazon.com>, 
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, "liam@infradead.org" <liam@infradead.org>, 
	"ridong.chen@linux.dev" <ridong.chen@linux.dev>, "blum@kernel.org" <blum@kernel.org>, 
	"longman@redhat.com" <longman@redhat.com>, "bsegall@google.com" <bsegall@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 82EF51C0003
X-Stat-Signature: skwwmgfthjisjk68otdf4ng8fqkfk4t9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792437133-802857
X-HE-Meta: U2FsdGVkX1+w93WIHDUySxkjvqjmi7hLjRDWFOH3l3hK5orgJQAOwHZpZsaA4xMrAR3pXIg9T3irF0XqJGBNuTHiaYUz2cKQVT87RgJAXCT1z6J2RTLyvePWB+NY8TrN0Wp/pa4Hy5RzT8oEw9J57yF87l9iGh1enftzSQaVsxagRsLiiswcwnIT7lyl0iCls0wNI2ma5G6OnTCU4i06ZWwdNYfxUnPDxgU1syqo/oBdQHH7aK/DMs3it6zZ/oJ7TXQG5y68ngGHT5lCwXyfOLxKq+SDd+FqfC+vUv8vkqAOq5rgPoZzN3KTycAXqrXi+sPgo6DXhKz2vLqBxsg6WJxwrWUpdWt7HtxNWKXL0VBaNpHj/q6EZlFvVeXuHz2yA3RnkRpXDfavG3ICScewWhhJ+L0LbERnvQ2BqKEE36OYvChspmFPNZ7GatkqwjZGDYqcr+VjaK5W/015df1Q7k4zHhGySBkPdt69oeHZ6grYR6wXijOArvpgGG0LFyHoWUGgUUpLXuOEvH8KDNHSHrPqW/qAJqyb6ZQ0Q3jqHJMBY5xMJiIQiOwN6WvZjJEYLtjGrJAy3T2cWOnN85vJs0+HaKIYnOVWH+IEheIvvh55J6tfZhzmERs0y9p80B1XMs02NF/8uTN7xwC6dgZ4+Opm9C6veqLdQNrgM9QWK06LZFY8Uw5/9KQ2A+IDVeqyPtDdyEJdZ2ALDV4gq3NcdYwMLy+YT7P0eRcMxsyObS/D+A/pJG+RdfwRgl0amQjtBNIB4arsV5y3siE8AIcBiKVeMt+k1FMTdmcq5mvAunAe2WBnvQAXwh2bYjTwfvjYvuCwiUgDxDe31wdZK+vJbtfEO58rrT1KwZ4/ma3BwTE+ZzI4+pgCXb770JD3zdV7o/rVFrKvQsRuxq8+ORBdBNX032xIX79iiF8uy7nmXmdJwRy9R77l5Jp4kJCYNWEXpl4QIHUEWEBBgLiTyCg
 ZbId6JiO
 bb1ktc2/pWcdBus+KODLVbbbmfgFsyUV5SGlb/lrw9Bt67KLK3D/CKzWvs5x6Ll5WVO82J/PGl3+UofijzQL4VAwtjQKidpCUsjixawnKPjjURoyMGYrhn3DR9HeZQwDaWPd/9lqQAkP5R2efF6vP2hWIT0eZcPifwL5Knrd2tzxM1vG9luYP8edTfBKWY3LuYZAqgXqk1fbHL2jfIDTNXe/N7qkONnpxpgftnfxCQVTFU1oBaAk6rPDCkmqHiVi8yoLJMST8MO20+xzoxyJ7J9fpisfUYbLAiGgYfdOk2uEuRFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 2:22=E2=80=AFPM Luck, Tony <tony.luck@intel.com> wr=
ote:
>
> > Benchmark workload (mean of 10 runs per step):
> >
> >  # echo 1 > /sys/kernel/rcu_expedited
> >  # for i in {1..N}; do echo 0 > /sys/devices/system/cpu/cpu$i/online; d=
one
>
> Side question. Have you had issues with this step failing on large system=
s with "smart" I/O
> devices that support many interrupt vectors?
>
> Some validation folks inside Intel had some tests that looped taking all =
CPUs offline and
> bringing them back. They complained starting around Sapphire Rapids this =
their test
> would get down to just CPU 0 and CPU 1 and fail to take CPU 1 offline bec=
ause there
> were too many interrupts to fit into just a single CPUs available vectors=
.
>
> It was a while ago, so maybe something changed in interrupt code to handl=
e this.

Hi Tony,

I didn't encounter that issue while collecting the benchmark data.

For the Live Update work I'm currently doing, I leave 8 CPUs on the
host to perform kexec while the AP CPUs are removed from the
scheduler. In the future, I plan to leave only one host CPU and have
the remaining CPUs manage the VMs in Caretaker mode.

Best,
Pasha

>
> -Tony
>
>
>

