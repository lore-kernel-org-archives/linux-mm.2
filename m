Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39619D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 01:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15136B0005; Mon,  8 Dec 2025 20:50:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6556B0007; Mon,  8 Dec 2025 20:50:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC3A6B0008; Mon,  8 Dec 2025 20:50:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9CF6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 20:50:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FDFB12CC6
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:50:22 +0000 (UTC)
X-FDA: 84198252684.17.C39CD03
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2DC561C0004
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:50:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xi2n69Nh;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765245020; a=rsa-sha256;
	cv=none;
	b=eaK+yd5ZUqIVr27TyzJo/nY5VYfmPlysQB5gZt3zCRaXkOVYZKXTceaFlqz41E/Fjhz4i/
	MtvsCfwtg8fnMSbzYDdHRPd62AphIp4vnFEdjkkUnK0PCvSbNg2B+H7u6gxVh9N3/UEpgj
	DnBPCovX/O6xykRjvD56RKA6roRFogM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xi2n69Nh;
	spf=pass (imf21.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765245020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxfMIuOKyfe8bmObUhS5t43dMnDHqQLX9eXqaAzAfm4=;
	b=6p/j2fECU3qkbWiGIfIxNpmAr1bPsDTODwOX2j3NPzs9oxvkRAQbtjroxKnArKeD/rW6Gi
	xLpyOXBg09ya9FRv0kmYjsI1WlqKpYVdnDCc1MMJEjRYWVHJ6aEyzt03kY+fqlPTHU6TKE
	ukm2H70dAzJbdk4HIepKEuf3E0MN7TU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765245016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kxfMIuOKyfe8bmObUhS5t43dMnDHqQLX9eXqaAzAfm4=;
	b=xi2n69NhA9UUpc69ygoXYVKF83VuBUmVTPKU3Yp4M00JtdFEZBtQP2alKZOjckFkjX106J
	2g2gQp7o7exkpimIsJzGs61RKtYjg+HdvdP6wxRjlhVI9m8fCBo+26EY6PnU6INl3ocnm9
	YXxlgfy6p/LkmEa9rJ8VqKmWUNuyvvA=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: hui.zhu@linux.dev
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  "Alexei Starovoitov" <ast@kernel.org>,
  "Suren Baghdasaryan" <surenb@google.com>,  "Michal Hocko"
 <mhocko@kernel.org>,  "Shakeel Butt" <shakeel.butt@linux.dev>,  "Johannes
 Weiner" <hannes@cmpxchg.org>,  "Andrii Nakryiko" <andrii@kernel.org>,  "JP
 Kobryn" <inwardvessel@gmail.com>,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  "Martin KaFai Lau"
 <martin.lau@kernel.org>,  "Song Liu" <song@kernel.org>,  "Kumar Kartikeya
 Dwivedi" <memxor@gmail.com>,  "Tejun Heo" <tj@kernel.org>
Subject: Re: [PATCH v2 21/23] sched: psi: implement bpf_psi_create_trigger()
  kfunc
In-Reply-To: <1d9a162605a3f32ac215430131f7745488deaa34@linux.dev> (hui zhu's
	message of "Mon, 08 Dec 2025 08:49:34 +0000")
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
	<20251027232206.473085-11-roman.gushchin@linux.dev>
	<1d9a162605a3f32ac215430131f7745488deaa34@linux.dev>
Date: Mon, 08 Dec 2025 17:49:22 -0800
Message-ID: <87cy4otof1.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2DC561C0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: xdnnqrmhmcdgcs3x8bj38pjgyjnyisqg
X-HE-Tag: 1765245019-78530
X-HE-Meta: U2FsdGVkX18k6GM7zmMaosOWy6gPmIUp58Ko+x0Bkw9MynhQBVyFITeE0e39NjRQ2qLtzDsrW+x5BhFXiwiPh7/LyImOfrBWqcDcCTITmFns8p4av15kMLbtGejUvn2/TKWlRInzcKtUrBXYdjLiwCHU89LSDMcWqOPL+fVcwNAA+bYVosAKP546dcl99kdOsYL8bDFmfVsUE6GHMz7JriEslLC/MIuOvXjwQn0AVRDqFo2vXuDax7QCwj9PS6BcRH1lk1j86a2eNpep+gtuug7LbUUFHA1FBiFoJYD6n487FD9tOfGS1SYh6I7mNQeAJrP4c2uYv994P0muxJ3xhlYg+16BGqJMx6QVwMY0knKk4lNG1jkqUM0mRW5PPxddXrmw3DyXivKV3U7igFISqckxvjOQANYwYHj+VZTHsNePF8vnHWig/ASc3HllA4AKV1E4ep27bWlRf0okFVowZwp1NLSWYVN0khVISgmAiVLuA7PR8Ei6Rw/xqeCX1DMSJPHvtQbXqXtO+sM/Rx6x3l505hO1YAwPrzbPtGC6JJn+ZQ/uJA0EAv+3OyldJ3ODO2wHM7mNfWi3meGq/vow7KJcIrTBD7Z0cnD/wW/O3sl1A22rHPoonV4ixYBbXB9VEiYRJkYzpm1W1/6WFf8U/Nk9Gmw8Bn3NTOEpnyZ+EFi/cPImzs2PDDBsbUAkddiByd1ZCfrHbX0eddaocd4bLGkzVcIiyM1tfe1+KsNBWMvRDA56ZpeCDHm/Wv/7wtE0P0UFb7NF6Z/ToHYB4gZjSin72RPYjbw+6k/I4c5vC2MjGuNI7lx9XXfTbzOW3Vij1kPTuEob/B59LAG7XVUSxLwpCqVAW/ZLmsdUjLDVaraTyBmehtf0FYuTjJDAa/MlZ3B+Lcytz6BVGM47fwotZUajf4r19MrWa1ZsDuqVti107K9B6Uet+oNsXps7XliVALr4BFPqVEmQX1iJAfU
 4XbhRnJ/
 tRlGlY9+NV7fNIN12ZvvVL00QOo80FTQdCe3t7Tq2zbNJDYX7bOsTn7IleelWIMi9xAMsgaDhGHD4VHmm10ocUISDQ/ebdXJr1yj29MvxFOoR9/wrNEp6Zp5qePMQS482iz2f0zr3vVtjUBYZdcOa/WeKBX0RlbpPqi29RXE02FDIT2Fp9+PRKOLNhmWjdsJB4D9gZEq3OPdBJulh3SKE6B5tOFONiWiuBtVT5id4H+G9F2omVye+0Ji5/s2v4RpNm1kAtN5CqEJXnCuZNA8cmj+ywUn10LrQJA4A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hui.zhu@linux.dev writes:

> 2025=E5=B9=B410=E6=9C=8828=E6=97=A5 07:22, "Roman Gushchin" <roman.gushch=
in@linux.dev
> mailto:roman.gushchin@linux.dev?to=3D%22Roman%20Gushchin%22%20%3Croman.gu=
shchin%40linux.dev%3E
>> =E5=86=99=E5=88=B0:
>
>
>>=20
>> Implement a new bpf_psi_create_trigger() BPF kfunc, which allows
>> to create new PSI triggers and attach them to cgroups or be
>> system-wide.
>>=20
>> Created triggers will exist until the struct ops is loaded and
>> if they are attached to a cgroup until the cgroup exists.
>>=20
>> Due to a limitation of 5 arguments, the resource type and the "full"
>> bit are squeezed into a single u32.
>>=20
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>
> Hi Roman,
>
> I wrote an eBPF program attempting to use bpf_psi struct ops and
> bpf_psi_create_trigger to continuously receive memory-related PSI
> events, but I only received one event.
>
> Looking at the code implementation, when an event occurs:
> if (cmpxchg(&t->event, 0, 1) =3D=3D 0) {
>
> However, in eBPF there appears to be no way to call the equivalent
> of this code from psi_trigger_poll:
> if (cmpxchg(&t->event, 1, 0) =3D=3D 1)
> to reset the event back to 0.
>
> Would it be possible to add an additional BPF helper function to
> handle this? Without a way to acknowledge/reset the event flag,
> the trigger only fires once and cannot be reused for continuous
> monitoring.

Hi Hui,

Good point. I'll add something in v3, which I'm working on, if I'm going
to preserve the bpf psi infrastructure in the current form. An
alternative approach suggested by Tejun was to use a simple tracepoint
and implement the rest in BPF - something I'm exploring right now.

Thanks!

