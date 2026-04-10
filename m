Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF550F459EE
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33BDF6B0088; Fri, 10 Apr 2026 11:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECE06B008A; Fri, 10 Apr 2026 11:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 229C16B0092; Fri, 10 Apr 2026 11:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 12B576B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:10:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B5803E294B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:10:47 +0000 (UTC)
X-FDA: 84642983334.22.E3550C4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 584D02000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:10:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jfogd4q3;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775833845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8stZD1NXshBl5ISaPS+qdCkgKdq+t5Tds8HTfykQxsM=;
	b=K1R6iCIVTLsST57ioZzPF41mVMQfc2wToTqvZDBvmSudlPos33SBB8Y/Pve7hsWI9KEgfO
	6pvMoPOAT9FDU7L8TJ9orRt5bROlWTfI45/6hvMSBvEwV5qVJ1k70/1RLw+hmgWuCKcdtT
	Z5IwqsNIiJx0DqyENHH+stOCgAW6e5s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775833845; a=rsa-sha256;
	cv=none;
	b=ko5wRWI0+2IPEnmVGsehoPjPFnUfVH7VbEdeR/2eR/oXyADJ0WW4g/D8CNaR0n/eWFTgb4
	/U9hDv02GpwKuapgBGrE63DMiW8mvjBDA0Y6LpLOdy2I98INZIYGfOI/rYLU61Yay9U2J0
	/tPkDveZfwnwCyUosFGgZO56V2ZBUbI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Jfogd4q3;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775833844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8stZD1NXshBl5ISaPS+qdCkgKdq+t5Tds8HTfykQxsM=;
	b=Jfogd4q3Fpx4e7tu40o8Kn86A6QITP4sua07Y+noBjuFoBzyc6XP8aYR+aBeZZ0CAn4RlR
	RLNqnljlUVz1IsL9M60o8Znpzj9lV40fM6B8mLwkBMOg3XIBpj+l2sQENUZMZbAqodvMK7
	K9demChJ9EPZsohZs4SepOtZOezQYjw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-1w-PbK5MNgO0wAfQzjSZ1w-1; Fri, 10 Apr 2026 11:10:43 -0400
X-MC-Unique: 1w-PbK5MNgO0wAfQzjSZ1w-1
X-Mimecast-MFC-AGG-ID: 1w-PbK5MNgO0wAfQzjSZ1w_1775833843
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50d8e8c47a3so4348291cf.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 08:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775833843; x=1776438643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8stZD1NXshBl5ISaPS+qdCkgKdq+t5Tds8HTfykQxsM=;
        b=r2mPnX92o8l1XD/T4mN0O+udUfMWRZPvEJmGPkeQOU+mw2dgsyUs3RAP1ruiRMrQ5F
         EQN929TGZTShJ+Jz5Z1vqEoey3LPEjR0GaHfQrShITi30EqrCgfTnw02vS7JyDpSveZX
         p7k1ydjp5rnIVezUbLDo8oAI3212Cw8/B1JZS2CnNbHCGhoCZ5prBLcfr9tbExrD6w8U
         IPPsLfwxmMTB731td5g1FiIaVfU+1XS/revtqW9RhKgq4kD8psMJHcLm3LxayT8RihNh
         TZl89wtZzyr4hjP+Ut/HY/Olfk77kWypd7o+liUal8LdakkAWA/RWXQYXTOzZzc+UBlW
         jkhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsVUnNMN1HclggRLfWxpt1RBjA35RvlBrpK4Vdx47Hvqwz3yzEw4vohG8RuXodPO2Q+8eaCaPotw==@kvack.org
X-Gm-Message-State: AOJu0YzyL2bsDA8mo2TjEYk8AHrcSL3SusN5kr/e0HK76QlpBGcz33CB
	OMFtx8ehudGxc++tDm2s2KVlf1dwlraRUl0i902S6mPlZuzhX6I4g2mBprRRfnLIJpJwO1hKRCr
	PEnxDUuiGmZ14u0fQo1acwx64vOk4XV9ANHzeMZjmX27f3kA2K7Lw
X-Gm-Gg: AeBDievtnKjcqbSarbzIXfaE03lzroi67hSPuD0Aa8rWBmV7SXabk6o5k8ZtkgdPiTk
	7kdfVR1nDOFO3EVfSdILTBmCFlNPhSbkfqEfRYG+FtROwZBjcCPka9fG5IW7L6N3IWdSwil0jLd
	OMw72+Dqwa09rqp2WreRBh24TtAvpZVBh62anTjZRJ1iAuJa4IO2azRDNa/Ymwy8QatiCyanntG
	sxLm52sTdFLzsfO4tjVJVxb33Ac8V94dHieYjW8KJK3AaUFeGAeUA1+OP1R2Nwq6qqylmDfJR9G
	yqwoX4VrN7vrUyyeIij+9jcfAowev3IrEpZv/HqHZk8j/iXmW1hrHegH8NhkE/Uq6ZHq4igbF4E
	yDPZH8GpX1+r3SmxPmgSsjfU/DFXv1eXNLnSHXcidUlDf9jU=
X-Received: by 2002:a05:622a:13c9:b0:50d:6f16:390a with SMTP id d75a77b69052e-50dd5bcdc2emr49687831cf.34.1775833842687;
        Fri, 10 Apr 2026 08:10:42 -0700 (PDT)
X-Received: by 2002:a05:622a:13c9:b0:50d:6f16:390a with SMTP id d75a77b69052e-50dd5bcdc2emr49687191cf.34.1775833842092;
        Fri, 10 Apr 2026 08:10:42 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50dd550036fsm22357601cf.21.2026.04.10.08.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 08:10:41 -0700 (PDT)
Date: Fri, 10 Apr 2026 11:10:40 -0400
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: David CARLIER <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <adkS8DkNZKHh3kmj@x1.local>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac04ZeFdz7yvByRp@x1.local>
 <CA+XhMqz083g8D5xQ5bWNrWguwdBhFv9miMooDhDf1+862ggzNg@mail.gmail.com>
 <ac1wW6LHzzkXBeSl@x1.local>
 <ac3qYA40OW29ibbq@kernel.org>
 <ac5vVFXgyqODXaab@x1.local>
 <adeLb5G3PgE_zuct@kernel.org>
MIME-Version: 1.0
In-Reply-To: <adeLb5G3PgE_zuct@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1BllqdbA9Hs-qYJT-ZkGhAv-8m6RQB3OSxwO1Hd0CVg_1775833843
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 584D02000A
X-Stat-Signature: cnrb5pzouorfsdgprk9y3gn15rgs1web
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775833845-698028
X-HE-Meta: U2FsdGVkX1877Q5A2Uwh/IPDA/8S5uJwpUhgg0qXzghfKty0idRdjASPzRXmVWQjm4XTwdDGgHnxPf/RA0eEThP/4geoNm55TT7ovVbYus/Hqb/bLKOodNYIwqkl6iCxFIMbpLNTAzwU23SFsHGbJNFHT3+iGwiohiymXarJui6po+VCDYE7+f7xezKOQzBqKKGYDjIGqdI48qf5CF3OeCEllaHCMpvkTqbvbmWrpze1Cc1ZXf+/74QvYK3J3cXL2EyKBN850PwZQc+fniIdZ74jkdvPuAuGdgIIOp30Q6vBm/ft7WUY74tXGVyBU0uTJyEPwkiAMYnnTvhzSZpJsjUuFGD+hxbIITQSYNfYBYcTRSrAfPwj4tpWRhCx/QQ8jJg1JJzoZtIEp64MVj6wve7TXYIPEKP9LNsW+khhp096QxnwIGWXkLhL7uL+XxjF7S+OTXs3WJgAv8W2EIx3U8JL51fAPdlvaMABDZobQeH/tXKfJlunrhudmAqFIiRc2hNcLnyDZol7WW9bRzgmchUIAv4MbgO/dWlHlFPb+9g/EPQPCgMRbzZShYRRBqoZNGBdbHAveIXEOQgJnVzLGxGeLAaZi/XfiWpKNQd40/3PyVCkm00Zgx+Lkngy1h0JmnGOn/4/l+QQf83t/zKsphZz78ecQsYqaR4sUmqKXzRIljNQK/lp37AJqA3ecaYB6eoxHmnxBQ674Fq9JSj/HODP9F9fku6iAKjnX5MTe4IZz2Xi2aGbjAJNCXSyUtRsaUAjq++O7fctFBzTGcSlI79dtgWdeziy2Dv8XKvr1wM4W+t2HwwpQe9bz+NGpxKhta8zCuAcUhWxvsN2jt/8xwtjgV55EH2iNk4GnjTHNsGdVi1YVg8HFaVXFNOiwSnDqqQuRyaSub//VpRlTgUeCdt+RdHW5/JC6Gm6OyR3xLcX38+JC9tXkGdKWpzOMh55iyO/J8eBoEVJU7Q87mc
 c8WE0ccj
 6NTQ9oJ2+77S0p1YA7H0+gEjb3HPMiy2qEYyJuWC0CZGKRvUkQMaQDYBnbN89iSPHXQdxyOs4t6kU2xcY86A3ANX3CVij/4VQNciJuasCMlTDrzMDhrssVJ+oQ1UjFVHM37vwKSmP6QnmmCAYTRO0vIzora11rwOslm0hJbw4OcKeyJrKNy1JtUFWrWExTRa8bwHuybxG3Uj8vN6CILL5iolmDDMinEurbr/Sv1F415VCDY2497zg3AXr+jVnt+bqqap6M154oXhhhZ3DxMJxoosTZ/nQUHo3BMF7gi31S3wDepfgq7F/bkR2W5k3QjLF0umaolVZQjlYAy2hgSWDv6kyX53Bn9zkFuN23TSfaPMvN6ysmGiIvEULlSWmwFpV1QDD8aqFxh9bYW9R+wS30FRtyZuLApAnkDzzf5bkAjLt5MlqoocBUobOhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 02:20:15PM +0300, Mike Rapoport wrote:
> On Thu, Apr 02, 2026 at 09:29:56AM -0400, Peter Xu wrote:
> > Hi, Mike,
> > 
> > On Thu, Apr 02, 2026 at 07:02:40AM +0300, Mike Rapoport wrote:
> > > On Wed, Apr 01, 2026 at 03:22:03PM -0400, Peter Xu wrote:
> > > >
> > > > The other thing is I just noticed the err code was changed to -EINVAL for
> > > > snapshot changed cases, sorry I didn't follow previously as closely on the
> > > > discussion.  I think it should be -EAGAIN.  It's because the userapp can't
> > > > resolve -EINVAL failures and app will crash.  In a VMA change use case, we
> > > > should return -EAGAIN to imply the app to retry, rather than crashing.
> > > 
> > > No. The return value should express that the VMA is invalid. -EINVAL could
> > > work, but looking now at the manual -ENOENT would be even better:
> > > 
> > >        ENOENT (since Linux 4.11)
> > >               The faulting process has changed its virtual memory layout
> > >               simultaneously with an outstanding UFFDIO_COPY operation.
> > 
> > The VMA changed, but it doesn't mean the UFFDIO_COPY becomes illegal, am I
> > right?
> 
> I don't think that "munmap + mmap + userfault_register"
> during an outstanding UFFDIO_COPY to the same range is, hmm, the smartest
> thing to do, and I think aborting the outstanding UFFDIO_COPY in such case
> is better than allowing it to continue.

It doesn't need to be unmap+map+register.  As mentioned below, I believe
writting 4 to clear_refs will already change VMA flags.  There're also many
other ways to change, IIUC, like mprotect() on top of uffd MISSING
registered ranges.

Meanwhile, I also don't think it's about whether it's a smart move.. I
agree most apps shouldn't do complex operations on VMAs when having
userfaultfd involved.  Said that, IMHO the whole point of kernel uAPI is to
make sure it works with every (even malicious) userapps, and it shouldn't
crash kernel.  So even if the reproducer will require complex VMA setups,
we should still close the gap.

>  
> > For example, I wonder if it's possible someone runs soft-dirty concurrently
> > with userfaultfd, we shouldn't fail the userapp if there's a concurrent
> > thread collecting dirty information, which IIUC can cause VMA flag changes,
> > and should be benign, and I think there can be other things causing the
> > interruption too.
> 
> Right, we shouldn't fail if some of the VMA flags changed, but we are
> talking about of complete change of the mapping, with potentially
> completely different backing store.

I don't know how to define "complete change of the mapping".  Here, IMHO
what we should do is to be strict on vma checks, either using the vma
snapshot or anything that can achieve the same goal, then returning -EAGAIN
is the safest because it won't crash a good citizen userapp.  The
re-evaluation will only be done later.

Thanks,

-- 
Peter Xu


