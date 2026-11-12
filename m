Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F64606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 23:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=L1RMXo8I
Received: by kanga.kvack.org (Postfix)
	id 5044E6B0601; Thu, 12 Nov 2026 18:07:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B4F26B0609; Thu, 12 Nov 2026 18:07:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37DFE6B0611; Thu, 12 Nov 2026 18:07:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EBA376B0601
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:07:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E140840E0D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:07:04 +0000 (UTC)
X-FDA: 85428004368.21.4E51109
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id E1A9F40006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:07:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=L1RMXo8I;
	spf=pass (imf12.hostedemail.com: domain of nhuhuan@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=nhuhuan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794524823;
	b=hI0sVGvoYgjDvlEeFjoposSoFGF9w5I/2lf3Fyb3uq7RHb+I6b2ql2TNc5HzmLncUv2BHD
	rAVbo2ruUbqiphj9mU3OP8Apa/4LHQrhAi5EYq1Qi6uGIuNtkYoGY5hNkGOPbwhGVtjMRt
	gyjl/NZM4Bed23PbXDSNSzKmZvvTcm4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=L1RMXo8I;
	spf=pass (imf12.hostedemail.com: domain of nhuhuan@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=nhuhuan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794524823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iq7zuX4mescGycMYtdVsnHt3n8ea5BUsLeUaRpIODWM=;
	b=UUHRmUcp5UqaVsl3Q0DkOXdLpzuHEjysH3sopKD7JlCllBOUhLmMcRqKH3sui+Gf+zsW/E
	AMHSFHWjKod3XdMlSzWQgHznQX23g0Bu6ZprFoARVlKQ6NlWSPiMYjjUHqHDmLoufwPoUW
	ugKzt9zETy2bnzBVXhZo+A/frCuLmlA=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5383c97c8cfso10711cf.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:07:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794524822; cv=none;
        d=google.com; s=arc-20260327;
        b=gRvXCHJGuahoq2OZChIbOQpqAB3VGCezmd3Z1kOeJhwg7WQab4iCfGjJwUsxuBJZ9b
         yPSCY2GjIfx73qFQLrBVZPvZUkl3nBprDNZ3rAkrrrMNONA32Bsjyg8V5t66qx4RcaUq
         OAYFWRTQf3uxlN9XrW6JzpgxjsBXnTMiqW27RJbNVljWrDFwo17kdw2gOJK5+MKXZF4u
         ZyWErtRoB8x+0qwEvenjCTEwkS8+1m2cMoQuimoeolLdA2AY1n5ASYK2tNQo6Ki4st4v
         iQcWdBTSEEeS2l+KpwPqRgeTcqaJA1yMOe3m3hJA+svK8AECEmLA9T9NZQ1BBZ3znb6k
         WtwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iq7zuX4mescGycMYtdVsnHt3n8ea5BUsLeUaRpIODWM=;
        fh=9EUVKYIJvJDz7Nv40FuysxSf9PRjUrw9BwppnO3fHKM=;
        b=MwPbAIZvN1yXb6Ax1O8LOB7Eotjrt5Gd1rpgkhNYS74FMglDd+h9xMXBv6R19d3Ric
         CGhTaIBDwUlXfqqoFZnZ29XIRLq4XB3sabyVRYLBfYiOYEvCwblYf84Gs9ZlJRuWm6oC
         POlC/JNJRsEu4kyD506FBeHR2mTSGTfje6uCnaIpTQJgbCTLcvv0mafsqWvUxjiaR+BF
         G72M6bTVpTx7cGCdu5tJi3NGLE1FAP4wPmzZ2fOiEpocIhL6T4nYYZeKuruq8S53OpJJ
         DhTpSsohBT9bcHsGmerE8vpUiP4rfmqIEv4+2lcOj2Giz+mSZkhwgo2LiJT9DV/NfXB+
         9Cqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794524822; x=1795129622; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iq7zuX4mescGycMYtdVsnHt3n8ea5BUsLeUaRpIODWM=;
        b=L1RMXo8IdJKyOdpUoX5QK9JeOqzzGxLAl3gVUtJErxsLVGj0C/0BevtNknX5PQ3HLS
         o3iKUy3zKSJwnd7icR68cPZF3vkwoQFcnkd5VFU7PeTQJ42tCRsYHLSWoPot4vt8S/ZE
         YcTp1hsbGD4su4q5vnTpVhtbDEokNRPaH3j/nLp+X+1tHLWEwfk4KFFEwL1ytngDKpT2
         bsRZZ8n0YGkHVg8x8o4l8rPum0VtoJpXHL7bi39qUQ3YQ8PlpExQ9tIA0qY07pwbfr4e
         qQJ/E2N4x2k3Y5hSmuVx7heLOq5lqQKfLlFSgn54G9s+zInucmddIWqusMVZjdkaSMMm
         vY9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794524822; x=1795129622;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iq7zuX4mescGycMYtdVsnHt3n8ea5BUsLeUaRpIODWM=;
        b=wCHK47gVwYCwnOEFEx6wLE5DmgKHfYE/CZU7m/I/K/xYJtiTMmtxoQqFPB4a9qeQoD
         RcTS9BNA2EjGv6Cxp2owqQnk+YDKvXjydR9bMyLEWFh6S1J6fDU9KPbfenziDtqPYxn+
         64wxnKHj3x9pDxdG3umxUAK7gwVO62ODhOhI+q6mACsX8HpNp4duznYeR1NS6aJkI8CC
         lcheanVCgF2xSFPd7Hn3PAsLQ2PdCl9GlHcr3agErqwPakTUEnPD15/5M8GWtdPHhD/a
         oG3v6cVGnaTY7X+LA5cqRGfYXaUwlo4UulHrsXrRA0W6u0/y3WwBVURAtKDnWR249+Bz
         xVlw==
X-Forwarded-Encrypted: i=1; AL+hErEMHv1i6M34Jhij9GHNjMdjMpob1TQhOpfcJNdVF7kje3iuV8NLvqjOhLNvUAGpihCoHc9mT2Sv2A==@kvack.org
X-Gm-Message-State: APuU4Z99ookE9hyqVBUIXNkd1pkYU/a9NYnk9IFdaizADrQXNKBnYN7/
	ThObVjHG5v7Qh0yn2WAFDBxBEnAUvzApemEU0F2FIBRtI+meQSMfqYm/uuO15jeiqr53GmJtN2K
	t/1I1QgraKSCdqZ0yKDg7VpAkew1D2MltpWTONwMv
X-Gm-Gg: AYBFou318QaDmo3Mc7pMekAmH8VPyO7ub7ZHnrC/bihQUPQaLewa/TO9So+6ezykxyI
	If1roX+ONRT4nHGdPbhCQMHrtnibQ0HtBdcE/gJ/4FDGA7Zr3ByUwDQieLKRJe+qv/aa1rqq20R
	ARUndYei+XBxDyE/HALDg0D0zf4bL86867bdgMmo2y77SW6VYJp6qoIDHg7wrF9gLAyO/o1aVUo
	IVZsq5HyfGi0+KyOgpZj5edgf6SJGsnXwvJsfu0mMYCX/u0l11IPrAmSwj9rbPIOMgv+JJtJIk0
	tqai4v0dZsCva9Ze6NZazrKjUWcocBka1QgKmBi7fDJ/rmdDoEwuNIAIfW2KEyOTkrkUXy0umXr
	JLfzR2EHbvtk+FUZAOoZaZS9NKtGyn2EI2jAPpO5P5zdRVApPaU9999P69oLSYd0URu4e3QW7SN
	MHR7z8L0Q5eGbm
X-Received: by 2002:a05:622a:4885:b0:536:3ee4:81cd with SMTP id
 d75a77b69052e-55adb2a6457mr5607171cf.4.1794524821197; Thu, 12 Nov 2026
 15:07:01 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
 <20261103223025.2482227-1-nhuhuan@google.com> <7CF5AD15-B833-44E1-A9FE-C8E12F8C9E82@nvidia.com>
In-Reply-To: <7CF5AD15-B833-44E1-A9FE-C8E12F8C9E82@nvidia.com>
From: Huan Nguyen <nhuhuan@google.com>
Date: Thu, 12 Nov 2026 15:06:23 -0800
X-Gm-Features: AclHuK8R0WzJXR4yHYxHSMICSWxLr-x7bnN-BX27nSJiTtbJXgPCv-FYzS8TYcg
Message-ID: <CALwWd5vAtSSuFoex37AzDBcK0RaBP3fbbst_fy9BGBQ5jr-K1g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/3] mm: use non-temporal stores for demotion
To: Zi Yan <ziy@nvidia.com>
Cc: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, trondmy@kernel.org, anna@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, jackmanb@google.com, hannes@cmpxchg.org, 
	shivankg@amd.com, rientjes@google.com, dave@stgolabs.net, nifan.cxl@gmail.com, 
	fvdl@google.com, jic23@kernel.org, rkodsara@amd.com, bharata@amd.com, 
	sj@kernel.org, weixugc@google.com, xuezhengchu@huawei.com, 
	yiannis@zptcorp.com, yiannis.nikolakop@gmail.com, 
	dimitrios.palyvos@zptcorp.com, alirad.malek@zptcorp.com, ryan.roberts@arm.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E1A9F40006
X-Stat-Signature: au7j7ieho5xa51cfkb71indfbba6p7fw
X-Rspam-User: 
X-HE-Tag: 1794524822-93819
X-HE-Meta: U2FsdGVkX1+jriO6pYBGwb9HPU1Z34fdqeaxM3sT8cBVS7pSzylUaQWKtOSn1e6uepCeAgYlUMhujpMyjDrEMPbtjZSCZtIsLnNJIP0FyvaeyKoP6/S5Z5YPSfAfy1If3MEnr8aVPog23KYp41vCMH8x9LcM+Snf7fH8HgkEYsie8ECod+MZbJwsc7pQ196Eii0+gVZMUyBrdWcHnDUxHFsKNsfhwjDVCdHDeNAldR9C1jWUi6YMhbUvkxprwIt0p/DST+/wPRf07jydCiQ5Fyw0vOgOa010gV9a9RAt1YnmABijHIJz5MDCCqZP15WXM9Fu0ylAHmaIkA7EuNiUjqNssx5Zz221A8+fU990YmSqI4W9J97SICoNs9pzCsNAgpi5IB74qPfDsYDfXqScfmAQu9HxIsxPNInXROWFFasbSLILRHmtS48pFudxVGdxXRECRZinkyPFu+GeR5LqlS5Zt/HeY/nBHHZbufNvA0rypDZGfP8LQ2HXkwEj29zCQdiLZGzT7WN6vSh1BjaN0i1xfxcEPaCIHGIlLmXX5yCr91WIqDbqbXvLiDY4pk4YTWE/eHb/qkoi2cN5mKwKmRKMb3MDRc/G7Fe/h27y2EdFctj/BgKFDOhsJpeihk1R1mz3xAVsjpuDmb14oQYKBknEWx7qDaBsHYVcG+zGUH1mpCrUFi4YyWeLcbM7VdojI60viAb2yAraxbgcvEWuiyPM1jSx3A/GbW8a2fTN97zaxCerlKyxiCV7J3uR+cz1jAXpy5IoB/cTf1QxohA5Eh/Ia2ip5xFW7ruwmNoFefcxy/tI2dL6cJdClCwgExrTQdz1mIwbjOys9L610rkF5pUg9bLtXHCQo2FKrWsGMyjTJJVtsDHySY0NNCjS8wc92xj8YEHFVLF/63Hxbe7oy+NEpNI+fNAwvOp+0vOd/SmETLcGLrl0RKXaVaLEapQ+4j5SXJDaoyWNeHLVqVN
 CY1l5qm/
 koAwWEBihso6Vha0+KfgVy6L8YgDgM6Hbd5LMkMME3Te9WYJODiZCSh6Z+qEFw/VJ1D1/17JCSqb2M/eiAP8cO1wLCTRXEcjTe+AHdcd3XNGolS/Ckz1Dt9GjZh4RNfBoh/UuCJJnzdvNiMht8vL1qKQF2OabFDXciztVyd0AGT6sfQYD0c4penM98FT3erHZWL8voBzt3Io28eZCeL+CWDgUth4Yt99rJUoVeFX3Uvd6QcznQB4rFWvh3fLsvlFqG10nwIu9SPhJtai+x5ibQNreszzzsMN8+fXfSW+WD/M2K/rxXdOXkkpKIdJUYt32c0AySXhd7S13hVgIGvfDLiK7EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 4:09=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 3 Nov 2026, at 17:30, Huan Nguyen wrote:
>
> > This series continues the non-temporal demotion work originally posted
> > by Yiannis Nikolakopoulos [1].
> >
> > Motivation
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Memory tier demotion moves cold folios from local DRAM to slower memory
> > tiers, such as CXL or remote NUMA nodes. Standard store instructions
> > force the CPU to allocate cache lines for cold data that is unlikely to
> > be referenced in the near term.
> >
> > Using non-temporal stores and prefetching on x86 bypasses CPU cache
> > allocation, protecting active workload working sets and improving
> > demotion throughput.
> >
> > Changes in v3
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > - Unified MCE-safe NT copy (addressing v2 Open #1):
> >   Implement copy_mc_page_nt() in x86 assembly to provide machine-check
> >   safe copying using non-temporal stores (movnti) and prefetchnta.
> >
> > - Architecture abstraction (addressing v2 Open #2):
> >   v2 relied on memcpy_flushcache(), which lacks non-temporal stores on
> >   architectures like arm64. RFC v3 replaces this with a dedicated
> >   __HAVE_ARCH_COPY_PAGE_NT interface and generic fallback, enabling
> >   architectures to plug in native non-temporal routines independently.
> >
> > - Memory ordering:
> >   Add a wmb() barrier at the end of folio_mc_copy_nt() to ensure weakly
> >   ordered non-temporal stores are drained before page tables are update=
d.
> >
> > Discussions
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > 1. Migration mode vs. migration control refactoring:
> >    Currently, this series introduces MIGRATE_ASYNC_NONTEMPORAL into
> >    enum migrate_mode. In parallel, Shivank Garg's migration refactoring
> >    series [2] consolidates migration arguments into migrate_control.
> >    Once that lands, demotion can simply rely on the migration reason
> >    instead of adding a dedicated migration mode and helper.
>
> If that is the ultimate goal, why not do it in this series to avoid
> code churn? You probably can coordinate with Shivank on how to move
> the migration control refactoring code to this series.

Thanks for the suggestion. I reached out to Shivank and we are
coordinating on this.

Best,
Huan

