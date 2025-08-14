Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8FFCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 04:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2599000EB; Thu, 14 Aug 2025 00:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29A38900088; Thu, 14 Aug 2025 00:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B06C9000EB; Thu, 14 Aug 2025 00:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06D2A900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:34:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 024E9BA002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:34:15 +0000 (UTC)
X-FDA: 83774096112.18.4B1D5A1
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2CC1016000C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:34:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uWS9e8Eu;
	spf=pass (imf08.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755146054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jpYMe9Rs3tolynO9B73W/0DpudggFG/LEClC4JR1AM=;
	b=x1qiqjxpA4GXOxrRND92+ZN8VMVm1dunzpGbR1HSaFkTeUP8qZyXb8zEzt1WBpAtIJj/CW
	QwKpv9do6QvLxKYtSPhevPTLKtpJSDVOHC9kvV9pdwFhVnldlOcOTN/KxM26ml6LdDfCVq
	E/hQLdXEJXZyIwq9KcFEg6JSG5xwKdU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755146054; a=rsa-sha256;
	cv=none;
	b=s8nz+Heceb9uxbeHM/SXVfxs48uX+z0aO5v9u8eC7HkHPMCppNCVtahco2FChtsM69/SCd
	M39PY8cIDsZAok9Nr5Btu8wrxktMYVSFodEt7/FoOgSTNCCTi6/nIQtouoB8KnTArOJTOZ
	eG52ZU2BrEvER76ThjhRmEohNB3KQEY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uWS9e8Eu;
	spf=pass (imf08.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-244581caca6so3602025ad.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755146053; x=1755750853; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jpYMe9Rs3tolynO9B73W/0DpudggFG/LEClC4JR1AM=;
        b=uWS9e8EuAgBOZGDmrlqjcPzogbuhCQA+WW1LLg9BWycrl/6+fdaYCLuZv0TN2NHP1m
         1sie2mlyYDWYtuvceUqwgLo9Musr5+3FBGL4d+vRgzxsqgQ9StyP/BEsp/dc/RMd8q8x
         unG2LwVNd/RFuGpvfSrAL0wiOtXYizIFar8IdvGdNBntRlWvUAPkcUzQ9w1yJJAj1/qY
         /jMAsWPeGrCN/a04mkaEu7BaYBrAHehlsLOJmiTxEORCQCxlpJ40bFsC9Wx9NxWqi+2E
         vzbsEClC45pybHR3ke5r27uopymRvuan40fFkqYV7bqSGVQ0UBS+F2AseB8qHpagwdgh
         NPSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755146053; x=1755750853;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1jpYMe9Rs3tolynO9B73W/0DpudggFG/LEClC4JR1AM=;
        b=G/jPflPzeDSgMD3c6NpSHM+G+8cJPFteG692vLAXY7WV2cWCB3NlK4zADJOSa/Rscy
         c3L9MVTNFlkAR0mdWv1sAqz6eC8bf+1dJtXXbM2Jzg+/ygyOaS1bFWTLfn7UbpyIwYxJ
         Si6YZI9ociwlieVIjrBTM04i2JjjsFsZhLm4S49D3AqYhpPMS5neLdKSX/WClIgjgV+q
         rvktr/FZD4GG9XrTCAUgKponVQjWDgqeuIjZXgH5TEXJrj5XX7HLVL5SCfE1R6FJyqUJ
         0/Bd/DwojLxdV/Y7kXQlQFsz8Zdn4ubUigap2xMDe1IE+mGuf18Ao8VQcBYlGQZmbbh9
         9sCQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2NEUrvj2vtxVx0D5obJAXT8WlZ/31sxMrXDcaiw8iwq7clfj1q58inso+A2TY5ZbjstKbIfXv4Q==@kvack.org
X-Gm-Message-State: AOJu0YwLHO49gi6AZi+aOxztXzNBLnc3W/KcI+ikqKo1DYYaW/IsNXIX
	2APFRa4+qlCekDYMKFR51+7vi1F0wC51m4kzI0i3VZgvAwyKSyN2PiwTz+W2zvxnLVRJ11i3noI
	N58VgCgoQiinI6jpfu8sqggIJVEx9pngEILtBDify
X-Gm-Gg: ASbGncu/Ow0fJD8MT5yiHV0+2gVH1Dwg8I6yIHF/45dN8P7Nqbif+51tANriG7h/SQk
	JE382c5ux7E5rZHQjzwAe7TFSeXVGagYFn20xez4smmOxTGdtKO0MtFS4WexscuI6aa4TLDXXnl
	qGlw8Gf7scvd2u8fGIpQXIV0uU47nk5Xgpegc+6tOmn367wriJc1BXuNiRa+YVb8PMIvCDsZ6d5
	3hUqc84Tf5bweV9MG8N0ePWy2FpDQ+q6+bZoDy5lD0QWBQLYUdygCzzBw==
X-Google-Smtp-Source: AGHT+IGwKj8+FeXsQR4WunSW0QBU4S01IHDhpLwKH7+wQspVHInHE5tXI45S3ELL33wWwQ08lPI1qcfPuEc+19ZHTWs=
X-Received: by 2002:a17:903:19cd:b0:240:5c38:7555 with SMTP id
 d9443c01a7336-244584ede2fmr22257795ad.5.1755146052777; Wed, 13 Aug 2025
 21:34:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com> <20250812175848.512446-13-kuniyu@google.com>
 <w6klr435a4rygmnifuujg6x4k77ch7cwoq6dspmyknqt24cpjz@bbz4wzmxjsfk>
 <CAAVpQUCU=VJxA6NKx+O1_zwzzZOxUEsG9mY+SNK+bzb=dj9s5w@mail.gmail.com>
 <oafk5om7v5vtxjmo5rtwy6ullprfaf6mk2lh4km7alj3dtainn@jql2rih5es4n> <e6c8fa06-c76c-49e7-a027-0a7b610f1e9c@linux.dev>
In-Reply-To: <e6c8fa06-c76c-49e7-a027-0a7b610f1e9c@linux.dev>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 13 Aug 2025 21:34:01 -0700
X-Gm-Features: Ac12FXwCislSz3BViv-OIQ8p6QupR93n7L2582VKpwYhsHhniE6ipCNyQvXHe4w
Message-ID: <CAAVpQUD6hCY2FDWKVnoiQ59RmovLizTPCC+ZNqB=oyP5B4-2Aw@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CC1016000C
X-Stat-Signature: fuzyttxxbrsg1z1ek8gy48ir14ojhm7s
X-Rspam-User: 
X-HE-Tag: 1755146053-764488
X-HE-Meta: U2FsdGVkX1+p110seATzsfDETqz46zgEhOezIB78vUx6HcmlP4RcFbsaVxvfd6lv/egiwmE3CaC/F0dqBNF/piQ/yOzlLagpGitmYWAWoGH1a4ycLSl7VjKqbtD0jbBKFMduixcEPTeGaBVzcLQEbCpvopbKD2TX2v9iiatskOJrKM6GVmGIDXJaPtK3itwdDuOaPSu/1J+O4748HtBOvhtyAXVYVA2uv7m7q27i+rligEA09l3m2Vhmb7o4JLy+P9Rf3v+fE4MGNyEBGqPSlD+nDaFGfNgoU7+AciBgBnES2RQYaqHO9OaTff1w2bbGOCPcCiX2K4reKSnQaLCR9+6u01iv6dLYtHDFMzquAlNY9flPHWPEMwmhIan8EnpmwB1HORQtK5NqcpcxdS6dq+7scJwK3T1utoYickpFiQIsxzAFypXOXjnQHxaKreBLUIni2VfACG324KNjQvOR8LVSU/Lmq7JQj3o5u7gAozM6tLjSWXg35QmETF0VdNJqk1wGTGxjt6lM9Qk8MpKeij4YI3xM3Xyprm2B3cz+ynZ27Gz6SPKHdaGvXV7i9LMK2jwLwKVLB+FhSoWmlpsTEif0fbtgVUAYf+gWI1VEsM8FUmVZ5A0sqadD5d6XFiicE37t96CVQIxdDdarrnibt7Qbt+qedjdBwef0Hw76ekN7KnHLDnIbzpIjt9d2Veauj8dKxxqLb525HJGf7RjEES3DbiRbQ8A1M+TVtHt+xnPZwVSHlnaUo2piL9ujYuuiIL6PkLR72YlcBFDfj15AaK2ZILqQY1kTVmJQ7fScxUD8bVFFwVbGWBm9lADGjyeAX9TMdCJpx0hwBHEMMEnh7P9QfiNfOMn3pu8xon0YIplDIuJQdDBUnDN81rYuBin8Unu5B7zSPyczdM26lLMKGNAhkEPoNcJP29BtEGp324OED/ZpNSTGKpXYhDPWohMUu/o/PfMVg5Wa5PEke+7
 eTquXPIl
 l+baEqvH9xrKSrRwEbdD/643UUimDrLgGG+FE+OEHGb/zwAEwkuAuqSKe3tp4cPW3q1rTSP4G9UpMMvPiiJwcaPCXAGG6hCXrRZpUyhdF5nrhsTrq/BjqKw4qJ2BHH/WnZUp2lJ3ncmwISzXTeghYkGYBI0lN/ONALh6YeiBV3ccgY6tACqGxNnYxNGxJi7htfW68
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 5:55=E2=80=AFPM Martin KaFai Lau <martin.lau@linux.=
dev> wrote:
>
> On 8/13/25 1:53 PM, Shakeel Butt wrote:
> > What I think is the right approach is to have BPF struct ops based
> > approach with possible callback 'is this socket under pressure' or mayb=
e
> > 'is this socket isolated' and then you can do whatever you want in thos=
e
> > callbacks. In this way your can follow the same approach of caching the
> > result in kernel (lower bits of sk->sk_memcg).
> >
> > I am CCing bpf list to get some suggestions or concerns on this
> > approach.
>
> I have quickly looked at the set. In patch 11, it sets a bit in sk->sk_me=
mcg.
>
> On the bpf side, there are already cgroup bpf progs that can do bpf_setso=
ckopt
> on a sk, so the same can be done here. The bpf_setsockopt does not have t=
o set
> option/knob that is only available in the uapi in case we don't want to e=
xpose
> this to the user space.
>
> The cgroup bpf prog (BPF_CGROUP_INET_SOCK_CREATE) can already be run when=
 a
> "inet" sock is created. This hook (i.e. attach_type) does not have access=
 to
> bpf_setsockopt but should be easy to add.

Okay, I will try the bpf_setsockopt() approach.
Should I post patch 1-10 to net-next separately ?
They are pure net material to gather memcg code under CONFIG_MEMCG.


>
> For more comprehensive mem charge policy that needs new bpf hook, that pr=
obably
> will need struct_ops instead of another cgroup attach_type but that will =
be
> implementation details.

