Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4AF7FD8FF6
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 255176B01F4; Thu, 26 Feb 2026 13:25:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F83C6B01F5; Thu, 26 Feb 2026 13:25:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ADA36B01F6; Thu, 26 Feb 2026 13:25:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E88A56B01F4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:25:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9AC9DC1904
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:25:04 +0000 (UTC)
X-FDA: 84487434528.05.846DF57
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id A6164A000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:25:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dAnDdDmr;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772130302; a=rsa-sha256;
	cv=pass;
	b=26VLbLN/LKAlG0HWRDBdVSeAo6mcVMAwQEKwDIkNPsXdHYNxfN0xqJ214+quMS9FYRWy2u
	5msEYa0qihCFkb3z1KeSsguF1OdO6rnUuwAFUP7IuzGGzDp2oZewHAjaeZvYzcKhBIRQuL
	DYJ/Y1lE1t+ndnIYO6SvD1MrBMSK2jY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dAnDdDmr;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772130302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/PYRcOeI7C9TjyeqdENicil+1+DTaWkY4tVXR58gDo0=;
	b=WwnVamA3WmWdGI/xU0MCyradb4b2EMHVFDHMEULrsEF9wJ69R2RSiTSqC3dqXclOOzQfD0
	WmKoiVxnBirPjRlaR5fo2qZlsXaLKjpcqP+lGqh3p3H8kCG9drc6vB/gaSZ2RshIdVXNRR
	xN7fQkkEWRB2Nkptl/omtJoomKgxdvk=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-505d3baf1a7so30001cf.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:25:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772130302; cv=none;
        d=google.com; s=arc-20240605;
        b=H0r7/KKyt4zBq2iyD5WI1jtUmKSvl2X3Tl8nakyNVa79ZSMbRyTlbPSgtfaFeoaMOU
         82fpRAKJv8pQK/40RdT9zT91Jr0HQttA49B9Q6bvaqxnKNyZKihc1ZQGXSNBr9M4XkGI
         kNwR190RqtVImuydAPox/ENdCeDtAeMZibyE980u/2dUVbVLBMXSR3dhLn3qY1iLzhoT
         6Uv6GQ0/JlYZCPEy1czRy1bfR23V5yY20ceyvQVIYILDXyyIsa9KWOoU2b4zUQN/LqeU
         2vO3xU4hW0MG8J2VC74388F5YmNXhyaqwfwpFJrnngJ19iTo4KBkx4oPO0VbCOu9Jjd9
         UfPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/PYRcOeI7C9TjyeqdENicil+1+DTaWkY4tVXR58gDo0=;
        fh=5arHNjxBgq1EzuohHk7ZP9+/wQR+VV6IDnQh/iQvmjM=;
        b=FJFY+IA6ZvwasAgQ5rV4LHJbXRBgT/WlsSmwUhMoaa+FsxSZPA7AUAOMNbyIalj+4I
         qHIu/2YtO0a+w9orNeG1SWWuRxLMur02QuWM+jc/u64GsKpqv4Uo88ep8Nd28MWEfttL
         ZUb2/qexzaR/CQbTGWayvaAEksMnwwMUjTTbGq0/2tgFTcehJMExLA4Qkl4aM+gjYS9r
         K45wCX8CRqyDWuvoUzUIcgP4nWNmfK6FJuIU0/ZOV7/G51YuBQGkcOMn7f6oq0Qb5Sl8
         bE5zdz/dYT3Oxbsa3oiwSMRWlL+pjgmE9q+ntELpKnuj1z9G+Pk+HfeP24rRJB3v0XB7
         UloQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772130302; x=1772735102; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/PYRcOeI7C9TjyeqdENicil+1+DTaWkY4tVXR58gDo0=;
        b=dAnDdDmromXM4ygYuAv5JS1Tju8eYabk4r+AKw0/KX5HvhUB2fgzB3fQR/h1A9WJcd
         CxX7jF8uR5eRKrtMAKsKxHcX3Y4vVojCE9wDI6ANKHhfan3Kq91UuU7eV7TQ5nmNs7SM
         iqhhZ07QAYFnjErDnOajxjj6no4fu48Nhr0n/9CD1DtjLdcf0kwkQdA5dRdi5Q1eBWMV
         NtUAnL66q9XOhgCQ1mkVZl0TGgqjJEJpnJllwv4CFcpvRTKJLfmzoPGkBuqymLVbl9Ql
         EqWTt2nieZDhRzZyc557hJ3f1kfUEXbcR59RGH8uqYbN4jiIi4g2f4+Gd7i4jVxlBdFo
         ksIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772130302; x=1772735102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/PYRcOeI7C9TjyeqdENicil+1+DTaWkY4tVXR58gDo0=;
        b=T+vyAja43gMI5F5sAMlcBL5oDoqlNjszN7VHWw2K3bx42JJRpFat/hnop6zJ3keP0f
         BPqbTBj2X0pj2/jUt3PvFztVRAkcB+7w+7w/oy7Qg7HcWV8Z8NNLbrOM+AlBECW6MqW+
         mqJtMasi91soWCrbE9cr6D+C8GQmFZZcKJfHmrOQI3qZ8+XIoy1bHcxL3oP8p+FNueru
         lU3i368F8NG4dp6msXXVLYEWVtd9qVQ8XQNAOHhyiWgEt++G7fXGVmXmhEWmcn4mJrko
         MX7O5fP3kCN374CJnX37docU9xU0Dc/A6o1+ZSEacbwvvTSsuOc4fm+Sat1LPqxpOUlM
         KaXA==
X-Forwarded-Encrypted: i=1; AJvYcCUSbg8Ivh7gLVeMNNps37jjJe7Tc/YwRJT/CY8T+tpaC2RuAPx+p4gfCDdOobG3e41ZwR5islHqDA==@kvack.org
X-Gm-Message-State: AOJu0YwacJL1tpTtE4AebbU+BQEpKNeSAOAVx1lw1SkhGRyuZYpT2PSY
	j0vLKXpojdNFXJz82OlHGRfFpOZl/5iiOhUf1Va8SiJWhT+1OdRi5BaKZUM9PIvo6ocfsvgDXrY
	yOVjKcSBWd3dTyWnPMzhplJ4PWNfbK2kfQ6HRJHNv
X-Gm-Gg: ATEYQzy+i9Ckb9CCIjS6WLBsu1X0rNnva9rx47l/01qMEFpmIfaBxLjOvIPMQ6bjqZm
	MtuhD8BV7BdWwOp+eA1l5wf2MiOmpQGSBPUK8+Mh9ZzsQCgBLkvvAde70rH/+UHhkiCegcZlMYN
	zWFthhxqPOFin8kjT0MqboW1sEZHQqLFY16cxhm/uOnlAfoeRQ4QHabBMSx55jm53XoeMOhkJBY
	XyEkUqV79HZ9lqdzebUoUgXJ/bfdwqOdXy3j2PxwTfTEzJ4ezANnCyc1ZfmHoCglYDSUsgMHXuW
	ikJCX4FA8vVLzebir3blao5hVWYMqOeOqx0rTa3od4nqTUH0
X-Received: by 2002:a05:622a:15d1:b0:501:4eae:dbfc with SMTP id
 d75a77b69052e-507454fc6c1mr12936811cf.5.1772130300634; Thu, 26 Feb 2026
 10:25:00 -0800 (PST)
MIME-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com> <20260226070609.3072570-4-surenb@google.com>
 <20260226191007.409a7a21@p-imbrenda>
In-Reply-To: <20260226191007.409a7a21@p-imbrenda>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Feb 2026 10:24:49 -0800
X-Gm-Features: AaiRm52wFdTJC6YvOb26vvaOOFR294VpLCUuG2iciIW7CwkMabryiSXuJJdbEug
Message-ID: <CAJuCfpEk_VPqwpqtAiCJSR5bkvHuzvC8ooXrB4jKTYnQB2D4YA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A6164A000A
X-Stat-Signature: huwrsg4ufdf16d14iou1g89apmrbioab
X-Rspam-User: 
X-HE-Tag: 1772130302-454783
X-HE-Meta: U2FsdGVkX1+Edjkpu3E3JOM2GPRKCNXKxWTiznkxLgMSLwgN8M1MiWvJpRowMA+m2L93b4wiyKtKyXQ81bTS2lTAxUQjGz+G2kRGo8sX7lkC+xCKZP6bi6sct5dW3EFeqC16EmIgOAsYVENPV2vnAwC9kHuJ8wtKqBcMFpQD/jZWUXWCw1JE47H6adw/nD8tgF99p8JmJDuOfiDgxJSDksOry54Os1SqzLeO38KC7BfscUvgCikjfIV9MecNb0aXqxr5fMpgPSrICCtnEzyZ5xk2cwz4cdcoWIvwwwXOTrMIwh1DfuEs5p9ev7zRungawsAuojlUq3U59ETsrAcfZibNLowSJvS6iT3QbIp2HCHoO6oMC3c3MEePgkLej2qRNwltlJLTn7kD7RUg2+RPGEZ+MRXeJCUwQ1uQcVMdvukGXKggHEUs+zrmMHQAVacuqE+h+fj665xFz6TK/7HDBhum0TUt5QAcUDdq1Efrn6NEz4xxIh+5VSIVDw8XVVYBVtY4pHrLyMhKXLM+sh6SUwRvXSX5eiACDTQqFmjFmp5+Dv0dORRAD2hkp4YSC2dwF5Yzif6cCcCJaWYzIT7nWnqcDCDyhIlE9XhHGHkbhhmG1ZF86M0w/GyvSyoRZkpkzP5oxmCLmLEK+HvZMN3l1Hr2eCQlKR9eZyn6eSf2O+oBiTAYv+1u5Zhr+EDtMFGLpIw2YOBgPSJjiNz+5w0yORh2+SAlqtqd363QJaQX4dEb+egoXQ4gDHECQytdLcVHV9VBlYb20Z9gavJuM0CDJ5b97hHseOqRe+h0D2u2rh3GQ38IcPzcGXB260ZLwpeery+Dzx2fYjEmn/FRGQhcD30rAPz4kgaC9HXA8mAAjDHobN/arcgyg15IAPNp33gDuAfOyiIFULmvmumzP05lQdBXjpToZ2IGbIEOVKUSJQ1u5NDuYklnrWIt+zGjRf3MdJfg+vgpFpSG6X19HRA
 kvCfI3NT
 gjSFT/D61B+g4rN8qpw0YuS/Z2iegLII9Brg9X2SGvBmNcpfKNx3APxj8d8rJeXEOFO2WpOQ/+gkorAe/JOFVXrQnRfpQ2K/TW+CfM/3beqPm3+eUsdwEXbQdl0VLWmNun31IPFLMq3gaXanHp559dIKRxQyF87kXEgvvnd4O0DkG8aMfy4ntjRzgHrpSj7fCiDOoXR7f7dRj5cjJcztEkdKEsxFWqPvNAY66DIyZc17EsZrTY1VzcRoDsGifRguLfTpV1eJIYe3lDEPTsfVG20tFEBXUuHDcF6xwXkVD2akpGjuLiav4YAFCpURbYEkVP5cliVCTo3ktJc1cqlGXdikGMZluLTqWzgES9SKxZ4Y8dxwK5QdxDrQYC8SeyQ7H78cEmrvnczh6PQi41CFBSqmG2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 10:10=E2=80=AFAM Claudio Imbrenda
<imbrenda@linux.ibm.com> wrote:
>
> On Wed, 25 Feb 2026 23:06:09 -0800
> Suren Baghdasaryan <surenb@google.com> wrote:
>
> > Replace vma_start_write() with vma_start_write_killable() when
> > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > Adjust its direct and indirect users to check for a possible error
> > and handle it. Ensure users handle EINTR correctly and do not ignore
> > it.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  arch/s390/kvm/kvm-s390.c |  2 +-
> >  fs/proc/task_mmu.c       |  5 ++++-
> >  mm/mempolicy.c           | 14 +++++++++++---
> >  mm/pagewalk.c            | 20 ++++++++++++++------
> >  mm/vma.c                 | 22 ++++++++++++++--------
> >  mm/vma.h                 |  6 ++++++
> >  6 files changed, 50 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 7a175d86cef0..337e4f7db63a 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned=
 int ioctl, unsigned long arg)
> >               }
> >               /* must be called without kvm->lock */
> >               r =3D kvm_s390_handle_pv(kvm, &args);
> > -             if (copy_to_user(argp, &args, sizeof(args))) {
> > +             if (r !=3D -EINTR && copy_to_user(argp, &args, sizeof(arg=
s))) {
> >                       r =3D -EFAULT;
> >                       break;
> >               }
>
> can you very briefly explain how we can end up with -EINTR here?
>
> do I understand correctly that -EINTR is possible here only if the
> process is being killed?

Correct, it would happen if the process has a pending fatal signal
(like SIGKILL) in its signal queue.

>
> [...]

