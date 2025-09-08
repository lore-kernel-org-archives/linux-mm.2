Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B25CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 661368E0015; Mon,  8 Sep 2025 16:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EABE8E0014; Mon,  8 Sep 2025 16:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9B08E0015; Mon,  8 Sep 2025 16:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 376B68E0014
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:30:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B27321DB8D1
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:30:10 +0000 (UTC)
X-FDA: 83867224980.06.7853991
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1AA1C0011
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:30:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wV5Ktmdv;
	spf=pass (imf22.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=yepeilin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757363408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Xh08NSX4A9iDLxHadhJ28F/iw7t67A2KAZWkf6OgAY=;
	b=5prOCc3xfP1F18NpeUhBUB26q5ohUOPbG5YURDJvGG3e0SRtyohGSmACqm8taNF3GHQRGG
	C7S2430zJXeOB0UrM1tKMEcu+uYmLghmCWa/IyNxE3T4/zcZqaN1B3YxUSRMOkR/0YJy8v
	3RxQaAZPxIdFMc38AcaiOMi6/7TawXs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757363408; a=rsa-sha256;
	cv=none;
	b=pHXdAkbwtt5d8HBS9JyqXKlD4ccbaUN4BeoSEnOtrtVkgOw7qGyfYLHlx2T1eb+O4gBnnM
	tAAOvi9aUjr3bIbZxEn8pqREbKKrjwb7r8OVStKiWNLc5RKMXv65rlAg57dr/gt8tBUACt
	hswqD5eUnxlJOpEwt2zKWQjs/p0kojQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wV5Ktmdv;
	spf=pass (imf22.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=yepeilin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-24b2d018f92so488865ad.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 13:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757363407; x=1757968207; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Xh08NSX4A9iDLxHadhJ28F/iw7t67A2KAZWkf6OgAY=;
        b=wV5KtmdvgGg12dULy2jNs6YuKKMGi4L7E7tSdNng3ycOLZ3vUVQxLgMNlPDMOuZVri
         +g4OQrjN1WagHSjJlfuMNTXfhe00tMnqv8LfqwurDUiBBiB7BSmbVcNkexrbuy0Y2mbb
         grG2lHUQJVHBYEMjl08WPefJlv97RiznWjbIoNPPcbDdin1q1KSLupwoRexPsP6qGpkv
         4yOLiBNJiE7/6j2HJX8mQ7OelJ2NeP3cW48QFHVmVOYOqMC89F8JmqV3az04OTYT8AkP
         xwKKU+1ILNubqRuhPwO6ToWo+fSDgl/o0Nb5RuSftWakxOGP5O9YionqNZrFE2WSGC4v
         z7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757363407; x=1757968207;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Xh08NSX4A9iDLxHadhJ28F/iw7t67A2KAZWkf6OgAY=;
        b=IZG82v7cPgXgwUhmlaw1j5xtKTjhjtGateWpDDayned1oCGD+9KP9823x0KC7nXMMA
         /atrj6KWLPTdMDm6nmLT00RlqVTcjb2n1MC5/PAN8ZddpSzhpQqDpXtPOwPQr+HItgfh
         a8cdPLemsovXIZeHaoJgFlwhFdT6jwjDGtyK2Zt/96WkGfvLPnkl+gnNpm3M1uPAcULG
         oqTmx8/YK5Ja2hn5wZqax4yZEy/hK/Z8UPDHWs+O5mGA+56FX+GKljmlpxUv02MCX/rm
         myQ/2bf4nTkapeo1qVPW0Ij7niphSXDzccRhgPTtjjSceXiDVFv5lP62pMWLkIsc8Fuq
         MYlA==
X-Forwarded-Encrypted: i=1; AJvYcCXteEBzrohQCz4nqZCETTY4K4hq6pzOFwha6qaPMljolO3er9Jhfn24Pwd5beOA4S7TlX3yY/27cQ==@kvack.org
X-Gm-Message-State: AOJu0YyY0mocjK9P1d2tdgji3gDQJAcMsgjKWAHqpwmqr7oMC4UdfykF
	qbKL69N/IDHCl2CRkrzbWHfUflcKJOex+9CEe9sidtKW9efqUD5eFX1MVUqpWo1ByA==
X-Gm-Gg: ASbGncusS5dkRKR+vmJy3+nW+0bbkjBZRarEjIaF+vS9ilqeQHvESdQpP6GkgdC3fke
	qkYoulPzAsJ2xO2Su73jRUWUQegdTTnsU5dxGwYwPSHmsfaa46KdAA2EoDc5dR0R1W3ls6oXKWU
	+lgIPbAsUthBPcx9bVBigbYAH8uq4lfS4vGM14Mp1mHyMuvv4j2Hn3/xUUq+Jyn1XGJDPu/VBTr
	F4I7jZijGeVrjevVJKwwzYMez5oean7KcQM43/1Z1jfCEaQ1UndJtYID2p8T+hFams3v21sxlRS
	Yc4iU6m21/sfhiOqx0rRbifDPrSoWE6O1TTy8h3Z8xBLzHG0dl2QP76e7BYK3l0vORr/rYRXD3S
	eyZbCheMidY7/Ywb5Fgp4C9gZpbflMLrTk+KY45jKKTRnxRpyK8s4zsGU44YX
X-Google-Smtp-Source: AGHT+IGAWt4InVNzIi+WTQd6F+c7wQ1SHfRY8vuJuaoIGxDjMz6TdxO28y6tB5fzmWEprBGtBzvINA==
X-Received: by 2002:a17:903:186:b0:24c:863a:4ccc with SMTP id d9443c01a7336-25114efbaaamr7841185ad.4.1757363407285;
        Mon, 08 Sep 2025 13:30:07 -0700 (PDT)
Received: from google.com (132.192.16.34.bc.googleusercontent.com. [34.16.192.132])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32b9be55c1esm13070183a91.9.2025.09.08.13.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 13:30:06 -0700 (PDT)
Date: Mon, 8 Sep 2025 20:30:01 +0000
From: Peilin Ye <yepeilin@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Josh Don <joshdon@google.com>, Barret Rhoden <brho@google.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH bpf] bpf/helpers: Use __GFP_HIGH instead of GFP_ATOMIC in
 __bpf_async_init()
Message-ID: <aL88ydkqeVpLKeRz@google.com>
References: <20250905234547.862249-1-yepeilin@google.com>
 <b634rejnvxqu6knjqlijosxrcnxbbpagt4de4pl6env6dwldz2@hoofqufparh5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b634rejnvxqu6knjqlijosxrcnxbbpagt4de4pl6env6dwldz2@hoofqufparh5>
X-Stat-Signature: dr84hrtnbygxa7bbdru79w999bdowpus
X-Rspamd-Queue-Id: C1AA1C0011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757363408-784733
X-HE-Meta: U2FsdGVkX19Q5yRdgRVScc3qUo/q/CV4jHyBWkPXyUBUidnTYuAynk+LXk/RqLj+XVHoMMM4nDv385b9J6b9/JcFE9CVanuoxmuKfyJE1dAnN7gxYB0NcjYN0gwhiVArTruhBkdqmhyA9PsxJGeUno6viMD8ay+f8e/wy9Lm7D2MKXdrK7+MPz8i3vYSVzOXJ1D5ANOFcHE/UVdwB9h6OFIApZmsP8yIjhYK0f8d2MtVOgLGdW9hk0sZFoJDlvtMA2CkwaIivdOQapf33heB68f7r47OvJXRlQSEyUtGgTLcIW87aTc2fBsD1GKKorCbvEYYm/AVTrkVYV2IsvmLRchXCTKnbQ1Bigsda3LGcF7xq/0YfLtin13db+s/vP6ITuvCxiS+MqU2obnLi9akYMlQIzrsr9r0WchWkrU2Svg0R/82nWPf1cgRB+KTuV+fRDFiKVVVogqc3cm1HK1PHBDxZYxCRga6I4OkLeRCnx410c/377+r83JJM0hUYPzmtlaxIOasqkdRTPvaQ4vkyxTZ9wcmjYStCnGYlBJwY1N2wSuOD4/2U20lFVCv4PTtg956I4a8+3G+UCFjXEBweRS8VAalz7XEsT0SiseI6PvpoB7I/uuGxaWOE9zbaG6hj/eDiM9dZBE8vN6GY5wC4JW+JSCLe4uNdleAI7jc5d9neqDQwqqPJfaOm3z62bDml+WwVkfI9CPssu+x4t2wdaFwsMUQmo6aG1yEq5ECQiuX62122i/5A1m9e5ntjEYInr3SR0OBf3vf0waT1b43vnDaSEBsxgiZ6JkaUq+KLAVrnguyJ5aDSdnlr8ErlzFS1TqddnRIMQxGNC/obnyjkjtBw1pxIfdLMabmXxHNh6F7IMul8Ptuo6eXSbTzrkkeJ/3M5ld55NzHM9rR1CL4rgqKsPdfJQQA1BGWcIEs/kN8XngzvFNuc5VoRvg1iVmrLfzPfhrxQRyz+i/B+Od
 3CxeZCet
 2RZv2l8jY+Kra6nqe9yRkFIPjCq2UUE2Ps5g8V0mE6/ErlSh+Z2nXsD/nHm2OFHnkcAyRnFiIRD8sOhbRxcbzZoUCfUgu3JYCWHOSplLmdQSLrRpctGetuRy0iNSgsQnBA20mXwcpSCPBobtWf/SP/kyo2+wtTy6jR1ubc1ilVvPfvcLGhbEhED487PrDfBnMtiL/VNDv0YzQ0HhdRZan2CdwLfE59iLPBurPaN/DYMBl8sBKVeqV57KRchLaTHh69q84VcVUIYC7hmDPxKViTzeuN7jnfubmm07GxEsgOFYCr0yZP5h4lReLQXXifPjjal3PuSrL91J313Ahi7V1ZYMWgCY8ubge1IFVXv54BM/YyCUPY9pcfL2JW5+cPsvOc+aUR+MojknLR6qyIFgrX9cs/kx4E2shLMWNaqDI8kz7nIOmacw7qT1taUTV2a3tl6novfCykqp4DglH8PY+JHu46JcEyxMdK3Qy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 10:32:29AM -0700, Shakeel Butt wrote:
> On Fri, Sep 05, 2025 at 11:45:46PM +0000, Peilin Ye wrote:
> > diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> > index b9b0c5fe33f6..508b13c24778 100644
> > --- a/kernel/bpf/helpers.c
> > +++ b/kernel/bpf/helpers.c
> > @@ -1274,8 +1274,14 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
> >  		goto out;
> >  	}
> >  
> > -	/* allocate hrtimer via map_kmalloc to use memcg accounting */
> > -	cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
> > +	/* Allocate via bpf_map_kmalloc_node() for memcg accounting. Use
> > +	 * __GFP_HIGH instead of GFP_ATOMIC to avoid calling
> > +	 * cgroup_file_notify() if an MEMCG_MAX event is raised by
> > +	 * try_charge_memcg(). This prevents various locking issues, including
> > +	 * double-acquiring locks that may already be held here (e.g.,
> > +	 * cgroup_file_kn_lock, rq_lock).
> 
> Too much unnecessary information in the comment. Just mention that we
> want nolock allocations and for that we need to remove __GFP_RECLAIM
> flags until nolock allocation interfaces are available.

Got it - I'll reword in v2.

Thanks,
Peilin Ye


