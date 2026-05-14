Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2673CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A21E6B0088; Wed, 13 May 2026 22:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352C16B008A; Wed, 13 May 2026 22:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241156B008C; Wed, 13 May 2026 22:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13AE56B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:03:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C1DC40261
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:03:52 +0000 (UTC)
X-FDA: 84764379504.07.2AB566B
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id A4AD080005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:03:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ga80YC++;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778724230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KEhYCJr0u1Oj4zece1Fu/d1VOUPZRM1XBT3HFSwlanU=;
	b=m80eEB/GVLYPBPqOtGJzB1Fu6i4mdjlI0N8z8VQRyNUnn7xyelUrZsLsnSzO1fXH7ldL7w
	PMZx67CaU+GEjJyz3UDBpwWhEoBnkzc3WkfMt150Y0lCiOlRks4jAi03Xc8aEP842gHF2k
	OZyhK0xhsBI2/kdxd6czQmOunZ2rpyA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778724230; a=rsa-sha256;
	cv=pass;
	b=fyp588n4fV9Z7neVGtBtFJVehyWjfCnHGfnf70fwcgxN730k8cxEDbwOASIm6qg3ZM+PKO
	l8/yjYtSiXHs+ItRLaSe+KZLzRd9E3IN49yUKxZLis1tFKZMD4mD4WW0wT0H5pPNA4v2SV
	Iys2ywWlOHxKYZlW5R3SMOfy3ohhT5A=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ga80YC++;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50d6b393d60so199251cf.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 19:03:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778724230; cv=none;
        d=google.com; s=arc-20240605;
        b=URQjKA2LHOsvEZ1O8Bv7VVpnaY6+VAsbOlcdN8mc4Fyb3Dh5qrhSt8xLpJKmJ8ouPB
         nMlrCP1KwU5oB/NNspJ79Gu2t4TpWHI49P4t12kKja3wUhHO/PrNYoftZ5MOJVHpfpWp
         F/wMAht0rAbRAQ716/bANBJxoPjw/JjGcbmpGBnOA1FnyVraajdyB6c98oNrU6JPxWSB
         Lwb4xRbHwxj4SZVsniZYhnpdreJ7Uoe7ofNNbscZYbUPA5V9LjOHDLmpSOwYOGrFMSNV
         paD5KnPKWOCmk5N5fhd/dZWSqNPTMAgT1IKDlKRs6t3hV+XPQmGeG46u3BylNj4fRTMd
         8NUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KEhYCJr0u1Oj4zece1Fu/d1VOUPZRM1XBT3HFSwlanU=;
        fh=2lafS0ZAMTlIhHrHo7Re310AwPS9fnAIjJYBxFX0Bsg=;
        b=LkUk5Y/b9FLOy7RJfidvA0RHJhV2LiHB/rdpBJ174zmBSTIMBwiNODG5XePpEk8WnA
         md9SmgcLpdshKbyC8f4AjsXjUdh3awMQadW4mU5YjMfLm8mSMpFfouJJdTY+PpEiWoXi
         C9FtgM51QL1nkiIJ5iPofvBUxIvf73LsIiMkWOwxjj0WQwoniHSDcNcoO+FYzZQU6jJY
         kjdvHWuXFFdq2VJA4m5wS+hV67wf6tZi38zeKYpt+8g0SysWL+4H3uVgKZsfJEKSdnaE
         lhOmE2VlPtZAcPUUp/x/H0qoR5dDE0Uy+7Jdq5f7qz1+zYJsN6MALVq81cPYpl2kRUar
         c/SA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778724230; x=1779329030; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEhYCJr0u1Oj4zece1Fu/d1VOUPZRM1XBT3HFSwlanU=;
        b=Ga80YC++XDgZu8xUW/xtpUPJuJG3z+xPm8f7X2AP3q52tdYyQGdT7puDDRzVfAmFMB
         damaZp9Ji8n5vM5Fze9jQZyV6r6oKkjG8yBYOfg5/dBfoyZtP/DQpu3mbpL8MRi6ohLJ
         irrOnJ11OuQSUx/fYfaNLjgp7LVyC3DuuDpa/jl3c4jeGhSKxUrlqRMQaCHvXeswSkmh
         Z/TLb/3zg0qXW2avYTi6Z6sN3GN0njA0baNcCeNvDapQwzYc7qShLfgGBaN8uV+Ti3YW
         zedhXGwskr+HBg82zDkiBGh+FeEOV1jkK4tTY6r+HjfklwYLMfxECZMH5bQDoaA0Qkqu
         Z47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778724230; x=1779329030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KEhYCJr0u1Oj4zece1Fu/d1VOUPZRM1XBT3HFSwlanU=;
        b=TTTpmOKlz9ZpHgXauG8UXxiSsc3H1cAYkkcrl/yU3Ji7QEppkXrFy1TRjKdAp+oNZ1
         EketkD8voIU86dX+S9+oMIEv9OUF1PLevCnUe+a/9PIdVC4RRuqEe1LbUJQ5oNnsGIHb
         OnJ2nSgYIZNka3nBjUerBkcQDaw2FINoR/F5kc/RqZTIRSP6FJuQrJVFxqXy50UWnFR1
         m2qQvzGXrsRxAcieq3e7U8OLtXIXla7hYuveCjMqHpNgrCoteXXv4oP+jYA0JWmTpn6o
         Qp2nP8MF5D4mS9pKFPxQhlEEsOMSBPOMt1YLCrzJnoxS+4UtsgL+fx7jurO9qPPRf5Jw
         kbQg==
X-Forwarded-Encrypted: i=1; AFNElJ/d1AzIVxrpJKejqgwmIYBDlin5b3H1Nries5EbFnpwWrYyrgGmMPQa64TwYLTVpCZBmgtUWppNhQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4OrjKRDNs4DYBOtT7E4cD+D0X9kFutEOSwO6xhY/X3JdAiNtv
	0D7ognr1hvpYzCq0xC7GeNhTcHLSRV5/3YlWmERx7/0qTgFG32sx/MDic17ig+V1coMQgE6oI5Q
	Kj+OfChRwRnT69NVRkElKR6OxJjYWYAFEOBPaGTIK
X-Gm-Gg: Acq92OGGH5bjtm2kGxQZjePJ9YU90T5H2TYj76c7KArWxUZv5c/ChfulYIQRuS4hgnM
	vFelpDGqmqBvcSEfOe1vSTN/9DEqaoCuDP7TISgZ7g/ohxCJiHeptt+OLtj/VCFnT4VdVY57rm2
	HmHl4CgmQW8efYGF/vkKZ/QENthA2q8qc0A0GclBhwv/KYBaZTDWisB2TnCqL+4DrQD03yUGCHL
	IrpovoP0atfC6IAGtCF31Sdtqa56rWXJJ761Q2hbh5c4Pp87qFGAOEP4808D5NsYcxCOBBCdVbK
	v2eF56hjB+Vciwp7
X-Received: by 2002:a05:622a:d1b:b0:509:15b6:f6a0 with SMTP id
 d75a77b69052e-516422f82bbmr8066771cf.6.1778724229263; Wed, 13 May 2026
 19:03:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
 <20260429182005.00BF70D8@davehans-spike.ostc.intel.com> <a46738ebd632ff046bc9b0d02a5382de5f2e9f2e.camel@intel.com>
 <7a82a652-f861-4d72-8bd7-4e082af482f2@intel.com> <CAJuCfpHBzYUNEe_LBpeERf68_fso=Hy+UZWtqejTUkm1O4NLfA@mail.gmail.com>
In-Reply-To: <CAJuCfpHBzYUNEe_LBpeERf68_fso=Hy+UZWtqejTUkm1O4NLfA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 13 May 2026 19:03:38 -0700
X-Gm-Features: AVHnY4LD9wYmk6iBd3VzP4SJfpW_QMOsBBskbs1WU4rSnfNd6ClwGwJw6DSJfww
Message-ID: <CAJuCfpEAgk_wXPMBGLZZY+wUJHbdz+j+=kEjnQHaYsY6xHFnrQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86/mm: Avoid mmap lock for shadow stack pop fast path
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"ljs@kernel.org" <ljs@kernel.org>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A4AD080005
X-Stat-Signature: 6en696go49hjx7ajicetoua435it1deu
X-Rspam-User: 
X-HE-Tag: 1778724230-471005
X-HE-Meta: U2FsdGVkX1879R523M39zUwoHmSWKFsTLV8ZSOmiNg+eo2Dm19SA+huNW/VNGCjaAsHq99pCTc3uT7CBJL1wU/gwZZmcmHGbXZdpAa6oxXFWiuFUxOxZWz0hdC+AegKXuSnN+7kfUMmqVxzE/Gmdz/SUM343I3ioyK42XiIuKTibsUfLYkctxzALwt7Cy7hUk8lVmU5laA4B4B5qWcXQ4RinY85oQJD6XjIWzclf8l1YxR7QBZd5UY20tlTc2zoagPffeSc7rl8t//iPWL4OUjcBGwY3IawUXJxi2NHXwVrObkulY1gRjzOIf+/ZeX+C9NYPgH5t6wY4IpGUrc+fTiozqUWuv8gxBdbKZkPUaVdiFMv9u/seZ1RGCc2NOq/Y8Ag94c38Buljq9d4OvvyNDDO34Hugn0V5/xMAgz3KKXTcqBRCoDZrir/Dfc+f9bgVYvm8Pw3tkUUEMlIunNnfRhIEX/JJCHATXKW6Q29nTrAtqdky04H40xAwfjUH02m+Et4bMoKXVmz9x5gd1XOOAOj2SwP+9QSy5mSqUGHawADEPjaYH6lKhRz+HDJKgaKJyk4XVRcOX1uN/HiWvp5jUOQz8sY+Y4VjMRSp25e6qFhDXSteDsq3wfPkc5B1C9/T2YpmlfCAH155Kfkh1SV9k3zLci4w8IyjCdm6pFpMWXJBx8jO0RUUkka2MDTCuJhaWUwkyKmfKfkxuLs0jkrgY23RWuuHfonFHYj8Obd2j3ZhiEpRuwgUYV0eZ867Bc0y/hX7a0ppnyAMRJ/F0FLeYW+T0o6aQlgUoWzkMCHA0/KbW4a8PPbrUCYwxMvH4vCdGLS2u1PODk4XKeOGEdOAmPqSDyHM2zCWSBAWzKZZd0V0evrgXIE/Z96kgHmqQLOsahbVe2M+FRwo39Vtptu2oOjRNpr4JGC38wcMD7vxzBrUy+dmNNZ81v5FUGy4/PeFWrTXVZqIO2DZnRgJcV
 yuo5Ac/l
 9oU3GbHbIQso3VeGbQbbFDsA0rBnXYYOgYH19Xgsdx4tVicTYd2+cvibJ42FwqRlojSWWLv4X11TZM4eQuAwm2rXiZlLtKbfpTICMMboV6JA0Ad8fvLlEhCGjaW77SjUiY/mG4K1VIz32S+txF2U3eL4H/TkPWZIkNx6TFT9CyEXtq7/AQ2cq0Xm7xDmygWg3j7LUsvLdhLgsC5rDuLFI3akEGci6XLwOW/p8hwqrE3sV5ER8N+n77RcQBU+h9OU5zKH1V50c9XUwSsOD78ZwKwoTbj76usNGWLZeM6Drms97538ExpHjmSZncNksEJWI3FlRu2rPT7++fYMl+vguA2xYKoZOq9klREd3pm1C5FF/E2QBuNbdaksivMV0MVnPlJfCAlyOhTRS1vj8SYJbcb30pFNLgB3Z9WuY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 6:44=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Tue, May 5, 2026 at 9:39=E2=80=AFAM Dave Hansen <dave.hansen@intel.com=
> wrote:
> >
> > On 5/4/26 16:15, Edgecombe, Rick P wrote:
> > >
> > > I guess the problem is the lock ordering. Not sure if there is any sl=
ow path
> > > avoidance details that could make this splat a false positive. But ho=
w about
> > > this simpler munmap() case:
> > >
> > > Shadow stack signal                          munmap()
> > > -------------------                          --------
> > > vma_start_read() (VM_SHADOW_STACK check)
> > >                                              mmap_write_lock()
> > > mmap_read_lock() (user fault) <- deadlock
> > >                                              vma_start_write() <-dead=
lock
> >
> > It's a little more complicated than that in practice, but I think you'r=
e
> > right.
> >
> > I'm not sure when this would happen in practice because the fault is
> > actually on the VMA that's being held for read. So I think another
> > writer would have had to sneak in there and zap the VMA.
>
> Not necessarily to zap the VMA but to modify it, which requires
> write-locking it (split, merge, remap, etc). Note that write-locking a
> VMA always involves mmap_write_lock() followed by vma_start_write(),
> IOW we end up write-locking both mmap and per-VMA locks in that order.
>
> The lock ordering when we take both mmap and per-VMA locks is to
> always take mmap_lock first, followed by the per-VMA lock. With this
> change we read-lock the VMA first and then call
> get_shstk_data()->get_user()->might_fault()->might_lock_read(mm->mmap_loc=
k).
> So, we take per-VMA read-lock and then mmap_read_lock and that's the
> problem.
>
> >
> > The funny thing is that the fault handler is really just trying to find
> > the VMA. The thing causing the fault *has* the VMA. So it's as simple a=
s
> > just passing the VMA down into the fault handler, right? How hard could
> > it be? ;)
> >
> > There are still games to play, but they all involve dropping locks and
> > retrying, like:
> >
> > retry:
> >         vma =3D lock_vma_under_rcu()
> >         // muck with VMA
> >         pagefault_disable() // avoid deadlock
> >         ret =3D copy_from_user()
> >         pagefault_enable()
> >         vma_end_read();
> >
> >         if (!ret)
> >                 return SUCCESS;
> >
> >         mmap_read_lock()
> >         vma =3D vma_lookup()
> >         mmap_read_unlock() // avoid deadlock before touching userspace
> >         // check for valid VMA to avoid looping when there is no VMA
> >         if (!vma)
> >                 return -ERRNO;
> >
> >         // uh oh, slow path, something faulted
> >         get_user_pages()??
> >         //or
> >         copy_from_user() without the VMA??
> >
> >         goto retry;
> >
> >
> > This also needs some very careful thought, but something like this
> > should work, where we avoid fault handling (and lock taking) in the
> > actual #PF and do it in a context where the VMA lock is held:
> >
> >         vma =3D lock_vma_under_rcu();
> >         pagefault_disable() // avoid deadlock
> >
> >         while (1) {
> >                 ret =3D copy_from_user()
> >                 if (!ret)
> >                         break;
> >                 handle_mm_fault(vma, address, FAULT_FLAG_VMA_LOCK...);
> >         };
> >
> >         pagefault_enable()
> >         vma_end_read();
> >
> > That's effectively just short-circuiting the #PF code which does the:
> >
> >         vma =3D lock_vma_under_rcu(mm, address);
> >         ...
> >         fault =3D handle_mm_fault(vma, address, ... FAULT_FLAG_VMA_LOCK=
)
> >
> > sequence _itself_.
>
> IMHO that looks more complex than the original speculation+retry solution=
 :)

Actually, after looking closer at the original code, I think we can do
this without taking the mmap_lock at all. Basically, we can have the
same speculation+retry loop without mmap_read_lock_killable().
mmap_lock_speculate_try_begin() does not require to be called with
mmap_lock held. So, we can find the VMA using lock_vma_under_rcu(), do
the valid_vma checks, call mmap_lock_speculate_try_begin() then drop
the per-VMA lock with vma_end_read() and proceed with
get_shstk_data(). I think that should work and would avoid taking
mmap_lock completely.

