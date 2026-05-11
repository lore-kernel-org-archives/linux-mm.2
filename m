Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F244DCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B146B0142; Mon, 11 May 2026 12:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A9C6B0144; Mon, 11 May 2026 12:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A446B0145; Mon, 11 May 2026 12:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 401106B0142
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:35:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17C841C007E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:35:17 +0000 (UTC)
X-FDA: 84755689074.14.DE4D533
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A16D20017
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:35:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PCTqkxWL;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1buMrZnL5eF5p/xBeXqRPyloQLFILIM6omdsc97ttuw=;
	b=zq3+s2QZEKt8/gqpolO741ky1YVBngO/mQRhJrwdrrj7OkxGH5IJfc405XsMcbn0K9ilrJ
	jzCxM6oNLFhgZH8hAdPx6zVBthpuMkmTDbuhMOrKbte6MPVJDUggHh4WWGEcp9f7urTYYA
	mAak4lSvirqGW85mtYQc9wHJy82AcAQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778517315; a=rsa-sha256;
	cv=pass;
	b=BzurGnPuZaEbvpXSWkISPLgmOA31Gzwrb/3VA53xGRaY0ssTNCfrw24YFHF0fWhlu94RsI
	uPGrK03Fxcw8HazWKfiwV4zuBc+kjGpRMF3vJevZOVilzWaPYbhivufcHu1X90coGn+FJ9
	BFKVCTjqp6CbbhOseT4ByWNXX5IM/Yk=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PCTqkxWL;
	spf=pass (imf03.hostedemail.com: domain of elver@google.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12c8f9846c8so6388907c88.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:35:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778517314; cv=none;
        d=google.com; s=arc-20240605;
        b=GAlYsBQEg1JVMY8E90LykSgM2whL5WGQnAAXKJRC+9ZN+VXAOUThvRh/bb+t77Gc+U
         VFsg4y+ZDj8n4D07tOKpaNPZTv3wHxB95bUjbdGqAh30N0fU35FDXMDc6CnRiXD6HP0F
         JrLpsTajZmq+lXDlp6WH5XwtLhPSw7DHvnWKNvEI9TM70VYEGeXufEemzkdD4X9VKsX7
         jhZPrRw5OessBER8rX7ZYUwRV/53Ozl1F6PLIlvQU8Yo+enyJXhaETANUeNDOpfscFyN
         97yatscQyxKZxpmstwz7gqdkyoEZ+z5Qq3mw/16Nbjevk/nr2hzPree/CuU/fDjJdbHw
         JHqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=1buMrZnL5eF5p/xBeXqRPyloQLFILIM6omdsc97ttuw=;
        fh=F2VTWskj92KKN9+x/8PixmKR0qHO7FnsXkpeC+wo0Lk=;
        b=dkNUVQ7NOK93UVIl5anm8Eq2Id2ilJac7AR6tn9Chcp1BzM/D5MMGy29t+klwODUC4
         xCYN8nR1vPlO6Qlz/QLa8Ipd42WG00OG982zzSG37JcDPgtq1SD18y357m6Oa1kL2wKU
         NDRdC2BomSr5MPjMBi1HMYLd07lHoVLztnwxbbe3khlUZ84rwyG27EcFDAoSkZcrR/tt
         flHnEgteJygliODFJI2C881IjGhnemhJnIyyJGJ2ADNm2im41MHQj1YSXMWXMTCSt0CA
         oPS1KTNQqLzZQNMZ7o5YL9tluaXkpsybahC3EEOAZwa7oAu9a2lPs/gk3mPiqqHMkYov
         eN/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778517314; x=1779122114; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1buMrZnL5eF5p/xBeXqRPyloQLFILIM6omdsc97ttuw=;
        b=PCTqkxWLK8DpqUBbk9zuk6imLuLXHOI8C5O2LLQ1foi0mgLyr8awzJMOIiRHONL9jl
         5jFlcq7cEZ+nk9Tf6NpIRP55r+qnKgPH9VHJUJMAjfMaQtV6ii6SH0WmVw86V+khK6tX
         mMSLEp5AFu6zo97ln0NoYDqK+hq3Rrj2HvPbTs0Jct+SDRintEkccro8ZtjelDPMQguG
         dnpVB8YMzGAMkrlEEhnXz3FPkFa9I4qda9R7cJ9Q/GlYL7tRd2/MCG1/0cnuwD75Tm9F
         oXMVvidTr5Wmvg+HbBxHe9C60NBdzsFVEHdc8kA+0004c1Z8B4OaP2Ni0E7+L/+hZEsE
         uGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778517314; x=1779122114;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1buMrZnL5eF5p/xBeXqRPyloQLFILIM6omdsc97ttuw=;
        b=FTC3tWYcV8STM3FbJ3rI/2/XF7lIxnujgxJ+raoLivdA4ckuYuQAtvBFoKT9JslNlp
         NVExwYkuZsLHBAra+amrMvqAymA05iXWrNrr0kqxItOlrTS7En+rWZwBb+Ew+/jcnoXd
         SrBfvM8k9xXyP4w4ujGHIB6+9tOJXdUK1/FxxsMqhplE5Nm3D4Sn+QI6TDj4tfu7lC47
         GLJAoJbzSB0ShaTEbatWN8UAi87i0vJNJEPZUffkK8gY9n6oZ6RGk08IgrQGEv68zvFC
         BxoH+8wXczMQEqU9W0hR47K+cIKfOcJ01KAlXRn0FEEWAvHjnZbCX9o5KPWS87+qZQyO
         ekXw==
X-Forwarded-Encrypted: i=1; AFNElJ8X3uuG+6klrigNIXTp5A1ewXGE5kNMkO/Gaks6T3BeTKW/bc/BXvptS2gM5KtJr5uK20ApNzw28A==@kvack.org
X-Gm-Message-State: AOJu0Yydh8e5kg04fTp/Qc8ImKVZnd1AIqkKSDJjuSUKHMvzttw2L5vL
	IkHUICzkko39nu0DXwHhA1Lw704b7A+of9+00jJsRNKzFDDLHE0P2CKP/dFy3t7dq3Hto+eZ5NZ
	dl8yyBkSsuoLKTUqxF27dR1wj+xtbFK+a+VB368Ld
X-Gm-Gg: Acq92OG21ZUL3DIvOAV8K5HRYk1a9auhfFsFYO/iOOOpTeGwAa7sqgV32UQx+pq7J3T
	PBSwyo/gji6PFAzo7Oyv3bsIqouH1R6phcP3wXph9ECM/msw5FmfmSMjVBSWWaDwhkKGm1OZXAS
	ePSNIVKT9EAHuMqAjkBbbdopcZum/L42t60NSYkVJfeyoD8tyA4iDEWX8ebUh+lGfLPCZpcF9gv
	g3t9QgID84aayaYZRQOU+f4EtQrYXOYO4HBfR3JqrRvyZf0/0tf5evh9Hr3W3VD7A05Q/RK37nU
	M0dKf1QmivpYAmlc972AOAzixTRsW+gbwb+ZTcOPMOUJqiXz1rcx6nHRVNsR
X-Received: by 2002:a05:7022:699d:b0:133:39a6:2b8b with SMTP id
 a92af1059eb24-13339a62ddamr337498c88.44.1778517313279; Mon, 11 May 2026
 09:35:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260424132427.2703076-1-elver@google.com> <20260424132427.2703076-2-elver@google.com>
 <9c321184-9080-4d5c-bd1a-a16cd0bbaed3@kernel.org> <CANpmjNN_=g31Eoa+w1NrFALfp1dDBi5oHEZdr_bA_48-tS2M=Q@mail.gmail.com>
 <afi0nQ84k1oz5RyH@elver.google.com> <871pfiw343.fsf@trenco.lwn.net>
In-Reply-To: <871pfiw343.fsf@trenco.lwn.net>
From: Marco Elver <elver@google.com>
Date: Mon, 11 May 2026 18:34:36 +0200
X-Gm-Features: AVHnY4JXza1HWD1Ghv5ACGmGvnp1cOeRA6XD-S98uX5BfJA-pjXWKAfvxk-IzaE
Message-ID: <CANpmjNML=pbnv7QLf8Qi4wY2nDCk6oOw2T_Vs-MfMwWh=0m5Ag@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] slab: fix kernel-docs for mm-api
To: Jonathan Corbet <corbet@lwn.net>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, 
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2A16D20017
X-Stat-Signature: ubx5gbwe98t9qm74qkhiknt446871nwc
X-Rspam-User: 
X-HE-Tag: 1778517314-443999
X-HE-Meta: U2FsdGVkX1+PiseLgywpKMVfdnPRjpRDY7sArEW5qPqi4eo1cFj0nGY2oHq9BG3b4/ZKZo9eKCMYDJxawBYRQvH4gh3C2IwHITQoWx9zR9AfaG4O3hoykV0v/Wg8tmeyZE4F1u9J+GDaYDEh9Axam1peN0GxVJUzT5FS64I3t5puvlhTb8KMDEUpdAndOB16ZPHwTjcLLMQgiOM2S31JeJVZG09apSt+Du2dM2baaA0bpPmWts39sZM8AjX5Vmi3MfsrljXgwD/xcAaI7twEGswBAYnYwPK+vjOs0Gr07vAJLQEXC5MPY7mVBhFPWUh+itROTo3pSbDql3rlPqMMd1rYp7tM+KBtpBmSXDErtfCFqAbrJj6PI6ohhLmCJwtMwEw6SpuLjGl9r+K1tn+KE5RMnd98ZJNj8uZHU0q0q9nA/7PzLdPnfv+1rK9Dvr6UyeSL453IVTXe4FrmgoOrfnNO1zwBDg4lklZ8F2Y/upUIGYus8Db/SaQHK5lXdVwQJHqzrjTCKV5qb+R3jMg5CNj0g1+Gnm81pvC0yloCW+NQxJw65XztwWP2JfQxSMN1YB4aLBCqToWOjVxyqUH265LABx6iI9LurKIh+d6YRyYOm+OXMTLyDZa/Z1agy2/YXQFRs2hguhSh7s70NDohQj4xl0xq5bKxhZJzriBnaJsHnUcJK0Kdq4JckToiRFCdHKfb8NAW6VgEZh/ZxcwzoM3gWojZiJuwtOWPYRamfbm3EpTT9zI2B++HRD00UWSOnt9OwmEQ3Ha1HEiSGe2dm8+d1qKB3ZG6alNKLSbA2bekXfgFv+oEjB7ssc1OwsmNWKD587g19odK/CakEKJbU4oqdIx4ajDfALiDphIFt3fnR44kXjY3r1ss3v7aBBfGi7Si0HqAY3NwH02LsnhHi3+ICbxyMgHlYd/ldDvYpE/ecPWbtasTtCdRabs/QtTQiHBqcRyS1WZRZsXyfa5
 XphecR2a
 M6xDV9fpJkPMRcQ92iEUlC+twaOBY3iqnObLCOIS+H+v/6+yxGP6SgpOp7PNeQaUyuxrH96LXIGwPBKqNPU7NJLgA41uawrNsnjAca8n+TQREa07IqI+cnctVKDRwXEIbn++mcdkTbb1ygt4pX43hT/KaKvKC6AoJ4cjHlrtbnyJGJRVMRmGyFm6Ge5KiX4Czo3wOO4/4NR5uz2Of86NlKUcb8ELYm+TciCuE77D0r+Q1GlRisJQ0KapRNBg5mOVi8CgR78mwzBrxM9sFZyxT4BRhe16X+8VXQRsGS+iqTtrmUC9BLuy0AQv4MYBl7oD0kl022S/iOM5R3RZswtAD5DMT5zvtKRtcKVQpIcpHIgS3Q7jwUSvNxdmWkmg0Hnw92twpn+iqDLdzE2qj6frR0t/yGR3NcfhL08/IT2UEv8fJ/TGulwHQ3JYx1fSjHXw1mmDziLGy5XVtox5kuH6drGtfKq14OfPZ3Njqk8Ip/rKh+GSssbVBIJGUDjDHq7Mw5L3N3UC05kQCWv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 at 14:19, Jonathan Corbet <corbet@lwn.net> wrote:
>
> Marco Elver <elver@google.com> writes:
>
> > How about the below, i.e. adding type decls that only the kernel-doc
> > parser sees? One complication is also DECL_KMALLOC_PARAMS, and adding
> > kernel-doc parser hacks for that looks pretty awful, so this is a lot
> > cleaner.
>
> I'm going to be a while catching up with things, so this is just a first
> take.  I strongly suspect that the people who object so strongly to
> documentation markup in general would be less than fully thrilled by the
> addition of this kind of workaround.  I'd like to ponder a bit and see
> if I can some up with something better...but again, it won't happen
> right away.

Thanks, Jon.

The technical debt (hacks) that would accumulate in the kernel-doc
parser just for accommodating slab.h might be quite high; slab.h is
rather special, so the "#if 0" solution might be justified. Then
again, if there's a reasonable kernel-doc parser solution, that also
helps in other places, I won't object.

I tested the "#if 0" version and it works as expected. So to move
forward, we could consider it in the short term, and in the longer
term, see what new powers the kernel-doc parser can provide.

