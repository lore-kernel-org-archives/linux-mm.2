Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36BBACFD352
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 20:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591086B00A5; Mon, 24 Nov 2025 15:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568E86B00A7; Mon, 24 Nov 2025 15:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47EA76B00A8; Mon, 24 Nov 2025 15:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 381D36B00A5
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:16:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E8145970C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:16:16 +0000 (UTC)
X-FDA: 84146607552.17.9E982DF
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0F27F4000F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:16:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ExINyeqd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of morbo@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=morbo@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764015374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z06KotmtsfB1UWZ1tUPQjTnpS7Gb0kLa+slh5Hjs72I=;
	b=VXNeDA89FPJDdnpELjIP2y/VbdnaPsohmzW/ij2hJMJGqj++56Pw0ydAZFbWNZcfFlylZ0
	7rH4WRJHp7mxo9UmWQ9rU709KYprZ/niElX7WHplg0gSiLBN0eMS0E+w7wwQouVRzf9QPQ
	q25XnWuwC+iyQzzO7TUbEASjCMQUhQ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764015374; a=rsa-sha256;
	cv=none;
	b=t+ZHY+E4riTRigMfeSw0dYOPSC4WWgnimt7DdXuPiymSqi0Zd382U4QUEp3w94NEPyGouk
	EUR33UBYv684Q4in5JG+NGt9ANJ0BTGQcl4G7VaoJCvQtT9upWhOUaASF3lxCw0xPtc8wI
	MZIKT83uF5cOia63i66fbXUeZztMWSE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ExINyeqd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of morbo@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=morbo@google.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b725ead5800so601911766b.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764015372; x=1764620172; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z06KotmtsfB1UWZ1tUPQjTnpS7Gb0kLa+slh5Hjs72I=;
        b=ExINyeqdAw7bS18OHjymSkchIAv/j8NP4Fv527o41cCo0DMP5YmraG+WE3aYBQp2uz
         eY5EcBU1tEqk9XozkaM+zNQMOgZIKqN4HAJpMNeuLSBmBTlM1635er5pBC9qx6ciYI87
         BXYoTmWyfgKVNHbslWGFcMjpLFGI+e7+NPWt1GffvNggAjaCNe2SdYeFwy4cPpBQ7QCq
         WFk+pw+eqjBVzxk1OuEbiHSm8y64Gq/H0EMEHgZlGYa9ux1V7hH2hWtkwUgeC00V4Fkd
         n80Pkah0rZJig60Guv3JGOg96pZC+FY50l5cNp7HZ29stVvJ/VQ5Y0vp050U3DuhRZoM
         J4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764015372; x=1764620172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z06KotmtsfB1UWZ1tUPQjTnpS7Gb0kLa+slh5Hjs72I=;
        b=meIvbAjU8eREDZ0PRidItRdYW8i1T0mJQ6ygw53fwegqCJCs4VZiFbcX6OfIBOMI84
         jSwpEMPlUnArOJ5EI6GE1YPbeV2ISZMKWNNBRWDDnDj49AEAlSvB9qwHxx2+0Cq9daBG
         rLQOhNZulGJjLY6d1BySmEZOiLyP4GZAGQrfvOVXQ+79eUGcmOzBuRe2TslB34+ucApR
         NNnfPDiRhAPBta7+IDj2IyPzGWRZiG4oa0xhSdx5mjW1bQ0KB4uXXv1Gvpa3khVseBuv
         0dsMvc8EWCy+sB+sl2qo1CYzqDBjWRfEu6rAoOEj/2T1KUvHq2qzwYV3cEwX9uakJNpv
         N9Wg==
X-Forwarded-Encrypted: i=1; AJvYcCXLrQfoe35Gox60y9qHF87KDoZ2zRdjpNEVOmp3aAO2W9/+UA6DJqSH6GQJepVwugIuh/TXmJC/bA==@kvack.org
X-Gm-Message-State: AOJu0YxoMF3UbK8BjsiWNBUNEtYlxQ+oD7/EwQvCUgdcE7Me9eZ7l5aH
	ySbBl6x1GbRhT5cHGvUKk1jXoGWd9z+uDgz5qApc7YBdwGiK4ZdEg54sMf54fHnh0be4bA0FeOa
	4DYiUAV5frb1JQv2IfadOJ13CbleKrPhKz8a8Cbo=
X-Gm-Gg: ASbGncvlBw81T9PTUNiHS+ZUN0OdObH90EiJwS4tn2BNPERbEezbfdigK7KMEme3dLZ
	PW6hfVtoKF5sALszi8Z05u5jXOQSNzzoRUEY97lDc9gCi/dpqQMG46Wh7ZkNBMv0ytap5r/0lbp
	R4Je/AtkW8vSgZVi3jYzsa2zls0uzcWPwBta3A3AqAckpjrKjdtmt70Q9UyiPUmtGBoVm7nBuSc
	D1eRapUdQkcKESVf5XwUGC4sMcymyWQtycao+8zLM/br8pA53g5d0pTgACwCd/vk+8QJokXQOds
	IYs=
X-Google-Smtp-Source: AGHT+IH8BTSWpESlDk+bVNYpCBTYerkjXtzYduYOQ1ee5rVed6iH0r8+tbGf7UdNFGD02PcNrfkSjNuIBLo4OJtxfSA=
X-Received: by 2002:a17:907:7e96:b0:b6d:7b77:ff33 with SMTP id
 a640c23a62f3a-b76c53c0a57mr10512666b.19.1764015372261; Mon, 24 Nov 2025
 12:16:12 -0800 (PST)
MIME-Version: 1.0
References: <20251121193957.1655580-1-morbo@google.com> <20251121193957.1655580-3-morbo@google.com>
 <202511211525.05CB7E1AEC@keescook> <20251122141614.80f1a845cd694b1b470107ca@linux-foundation.org>
 <202511241117.CBE8ADC2@keescook>
In-Reply-To: <202511241117.CBE8ADC2@keescook>
From: Bill Wendling <morbo@google.com>
Date: Mon, 24 Nov 2025 12:15:54 -0800
X-Gm-Features: AWmQ_bmKteXP34og9YzGqC2nViwRnhBfRt6gIUL5VMXxuRtXI7wduxj48bhexM4
Message-ID: <CAGG=3QVwhA8yca4hQD1q7c6TgPL0dT5RODpdpBHSw2yuh1x7oQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] memblock: annotate struct memblock_type with __counted_by_ptr
To: Kees Cook <kees@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Justin Stitt <justinstitt@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Marc Herbert <Marc.Herbert@linux.intel.com>, 
	Uros Bizjak <ubizjak@gmail.com>, Tejun Heo <tj@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	John Stultz <jstultz@google.com>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Brian Gerst <brgerst@gmail.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: y1o1se38qtm8rz1747mzaog8z3ny5q3d
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F27F4000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1764015373-657316
X-HE-Meta: U2FsdGVkX1/EK694yq+taoVXBp0pGfQoLpm0fVFb403zYLmySJPHAXY7T5x1DHeQMamH88YMX+JqzT43Cuq+23kD0aVO9JiB2PPF3vHwDbReHBHwzsaBPbGyTV7gc0Q6gF+omU5VrQpRszjhmiEcHhv06vLXkmXfmzd5a+5ij27hLwyDemLZAtRhuOTzVH3GnMkWmo/4iHXHCQAS2FzPupgQpmVb+VUOyRSKm5puXcBE28CiswUxucaEJTu55qcHDO1nX6Q/1I8QYw3P8adlMvyek1/77vqBY3uYZJVaTsKoS8matU1c9hvaF5JpI7pyKIqv4BRznnK1blu+Ag4VMiCHNZruf2KMjck2qZjOTXsmbw0fs0TY3aq3z230WOQE/6ZSl9G8WYDrHL462rBwpvONSpqjnRuspMaN2PVHE/czu++Z+ComqmO3BaYYWqFF4rWpO5KzU9FM6Xz/UoEoJC6H0NT0jAXK/GjejhFgQV1kZBIrokdsiXIoapNLrakRACRloKvdAxhqH6MBtRmcqMd26c4+2MippZUfYoi/lX+9rov9lZF7H50c4ldgK/kUDqhZjQdZa2datjIf85OMWmEuSnQbwDS5XkW3KHOKiOZ5s2/8p1SLimS5VvgFbwkU1fNChdYNa7vVwDD+cT0vuuaynG0XguFl42iQutBZ36oW9G1vLaNe2IhHTCqRWuh6sr+UdSGnm5uFH30BZIBruA/YCi5m0ThchPBep2fHZpyEnWM5+VQv/p2I/Rvtg5sfkdCwcJslUcDPC9k3mAYBZ6Evk1n1rSUCLwN8OI7nvGlRXaIy6ADjispE2DOUAF2Sqi696AsN7WtwjkvFlpOMTmBiqRjQMZp51+5+ByBrKfiSmj5DiU6mU/a64FLk1mVk7lNq2Yzs/aane/0wvclUVhDd8SYAsoV3Mrm7EO5PoBXJgS+RpLmx5emEt41s5ljo8mkZ8x9s5O7k2HgVQrA
 s7HAT5YI
 Os5Eh8mwG5AEXFl2SaQYbQAwnUCspQqakQ71GELM8xUWlvuF6Vtm1NKMKi0wIz3rlIC0EWTmVUC21fg2hS2TtjG3o+hJ9lyWMKeoMaIqEUXq7lFI+/Pux0dQMu5uX3DXW6mgRnN+lBVCUPQJq6AG59IlnQjdK5C26VCMDboZvAjQe5woJYCza7pfQ+O6iH7q2DIUHcPFztE8erFoDqwOAbKSGCw+XDTf5QCHpiEZtOcHKhKPIYQoPywNgod77KlxOYbM/xQW9WdwUA+J6OPMSBoddDdc1gZF0qLGLQxvxytf9zjWXMhTRb20ihXfBk+DtkbQhWdOp/ij+wper5QpBT8l0GA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 11:19=E2=80=AFAM Kees Cook <kees@kernel.org> wrote:
>
> On Sat, Nov 22, 2025 at 02:16:14PM -0800, Andrew Morton wrote:
> > On Fri, 21 Nov 2025 16:30:43 -0800 Kees Cook <kees@kernel.org> wrote:
> >
> > > On Fri, Nov 21, 2025 at 07:39:44PM +0000, Bill Wendling wrote:
> > > > Add the '__counted_by_ptr' attribute to the 'regions' field of 'str=
uct
> > > > memblock_type'. The 'regions' field is an array of 'struct
> > > > memblock_region' and its size is tracked by the 'max' field, which
> > > > represents the total number of allocated regions.
> > >
> > > As part of any counted_by annotation patch, there needs to be discuss=
ion
> > > in the commit log about how it's been shown to be a safe annotation
> > > to make. e.g. in this case, if all allocations of "regions" have a
> > > corresponding "max" assignment, etc. If just "git grep" can't find th=
em
> > > all, using something like Coccinelle or CodeQL to search for struct
> > > memblock_type::regions assignments can work.
> >
> > How is anyone to know these things?  I can't find anything about this
> > in include/ or Documentation/ or in the relevant commits.
> >
> > There should be a comment at the __counted_by() definition site, please=
.
> >
> > And possibly write a Documentation/ file then change checkpatch to
> > direct people to that file if they add a counted_by?
>
> This is a fair point, yes. The documentation and discussions around
> counted_by are very big in my mind (and for Bill), so it was mostly a
> consolidation/reminder and some extra detail on prior solutions, but
> for anyone new to that annotation, we should have collected common
> guidance. I will write something up.
>
Good point. I'll add documentation for these attributes both in
Documentation/ and at the macro site. The frustrating thing is that
we're likely to have at least one other macro flavor (something like
"__counted_by_expr"), though that's the only foreseeable one. All of
these macros are wrappers around the same attribute because of
compiler skew.

-bw

