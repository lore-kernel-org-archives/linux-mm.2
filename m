Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C667CCF9EB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:25:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED728E0090; Fri, 24 Oct 2025 09:25:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C5438E0042; Fri, 24 Oct 2025 09:25:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB068E0090; Fri, 24 Oct 2025 09:25:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0DF8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:25:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B18F8943A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:25:15 +0000 (UTC)
X-FDA: 84033078990.15.69C2434
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 11F7610000C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:25:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="G/sWVEso";
	spf=pass (imf14.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761312313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Aj0SeoWC7WJCm+N08s/eNnhLHbhk/Wyc57uRWO4wNWo=;
	b=uAGBCS08rB8xUrsRTjPEwgq/yGLL/04Ty5e8gusD7O+ob28pQvBJjOImetbJ2K/uIOznkF
	pEskSh7AtnOlSuXD01F+ln50M3QooxNTIfyNmJd8cKqacJLV02z4YGJLMBTl7PLGvFRCiJ
	k3fBO+W0Xwtekly8ZzMYexTvUdYzF9M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="G/sWVEso";
	spf=pass (imf14.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761312313; a=rsa-sha256;
	cv=none;
	b=VXaMwSt3bkrpykGIloRMyb7IWmfFCk0Zs06X3mr6wiI2+KRWaUTiWSLqHZxSdrhJGuFIVQ
	1e1G6GkUmy3+ACcVlnpH8en/WiyNdbQta7w4uPUJk2n3PbxhVNUhAlrMc0kVsUjgXVLi02
	Bde0mqMrr1cEVgWE+QDtBXhjti0c7G0=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8901a7d171bso203977085a.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761312312; x=1761917112; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Aj0SeoWC7WJCm+N08s/eNnhLHbhk/Wyc57uRWO4wNWo=;
        b=G/sWVEso+XZtccXKecKw9or2muK+KKfSLEgwWs3YDGmEXX9yg2N00/MlMhaF5CCKh/
         NZMcboFXkU4pxyi07sC/5AiR4YbI3mfYxVSfpplsebaoQ1i1cuswIsaGDPnfkjwwRXxk
         SRMssh8oTdlhxPhAZhy8kHEWrLWJcsT9kZ2RZyAugoeipUQTzUhqC02gOrHSkxtBulKy
         Jx7kPQQgsHYBLZVAhgQ49yXjN5MmsGf9fxTHigYdqIZm7zU66bBROtBdkJJWyncFLVnv
         heLXnuWTK57Lf+9OHPPkpnQZ+MZ2LNkNYeazeLqQTwlxzg6IzD99o8KasLK9H+c/uAMz
         pvWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761312312; x=1761917112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Aj0SeoWC7WJCm+N08s/eNnhLHbhk/Wyc57uRWO4wNWo=;
        b=dHJxSGae2f79BTud1VqLvirwnBoSdCZzxvEL5AWJpnIpef954XkI+CP01LS6bpqQmy
         P4VAYrKurlRuI9lWcWFxvD71a9x20Hvn2rNMtJpi3Fk3ezkAiqG6tWumGw6BOVGLbKG7
         A/0ak2EJR+75OixQDt+mXn5xVWUGvGF0MraWA+gTs3+jYCrHYV4Te3keAhCdLuuMQXvg
         mPOPapS2EASjldGQ0y1Nt73P52w221px2ZFMecNACA6JsODUj6f7zsLEPTUk15XV+DNH
         Meo5LyCicgK6NFcIncJaMh/8/aUGPAf3OBQK4hnD6U92g4AsUafGH+JYrEMDv7FtsUJi
         1X2w==
X-Forwarded-Encrypted: i=1; AJvYcCUXyiPacBsKWzljsIY7gUFSIbEGjp9jNwirymnXF0eC6qMjm1ANJxcoP5Rr0KHS/aNJ3aZSgOS3zw==@kvack.org
X-Gm-Message-State: AOJu0Yxq1yY4kVFhSSPEKcqvepKj4IXxHOr2hAMc7KDeJpLb7Uj7kQE0
	CVyM4/nNooHPTeQjcAG3SH0gHQDiOJZCD6tU6nXiysMc0sOAyZfc+LXJPL5YR+xpqJ4=
X-Gm-Gg: ASbGncsbtI71yf/mHAbx4xqpdEkSqJoSxaR8+7OaOAzshROeOr4XiXeJEFkfESejIh7
	IiSRJfWhtQrgiQUrZ+AGI/NXUOgwUGJLY31GrP+kTBp/1lxm09NTVH5zRm/GLxFbcstuWUu49x+
	OWy7sZLvgrGzWFpDpjHSs8ozhhST3/neEqHoZ5wZJV0/TP0dKHdhXyFgiogroWlIZY8/WdGH/wm
	uAP9yBC9YHcK5BL5Tw1Ux1tQ4Bv9MT2KDDWhyjJLKm2ZU4b6N7LIOSeNRFWHQ8UQU9kFhwG50p4
	1l5ZU2SOoEpcfGgGDaLOrc34r+Num+TxjFIh2pmSNXnXxR0UptCfKb959BsuRSXCWffy8uaymFo
	J0pxsGemVYqtcR9rE8sPOgC/g0oFo+Ov4dszj7AUkZw+xIyg76OzJTonZnP9s6lWynCuwu6bhGp
	OLA+Mq0S1i0ClmsSXFT9HgPJ7E1AAQlyJ+PKFUaz29ZCUzbDdOCp4PAu7g
X-Google-Smtp-Source: AGHT+IEGAyhhTF+yO14yTGLloo3cDyt5954pwwnLoAEIBQQ3wHdpsngyLyG6oHWxHD+JOdW4oxag0w==
X-Received: by 2002:a05:620a:178c:b0:892:eb85:53cd with SMTP id af79cd13be357-892eb855743mr2323365185a.42.1761312310446;
        Fri, 24 Oct 2025 06:25:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89c12352ec2sm381880185a.52.2025.10.24.06.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 06:25:09 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vCHn3-00000003hrr-0bw7;
	Fri, 24 Oct 2025 10:25:09 -0300
Date: Fri, 24 Oct 2025 10:25:09 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org,
	brauner@kernel.org, corbet@lwn.net, graf@amazon.com,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
	rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org,
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com,
	glider@google.com, elver@google.com
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
Message-ID: <20251024132509.GB760669@ziepe.ca>
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com>
 <mafs0v7kgjoxq.fsf@kernel.org>
 <CA+CK2bCG011xf7v9nGMq4WQAUta9wDt05+W8KmRuc-JE7ZTwqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bCG011xf7v9nGMq4WQAUta9wDt05+W8KmRuc-JE7ZTwqg@mail.gmail.com>
X-Rspamd-Queue-Id: 11F7610000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6zjk7qrym9n445ejd3mjerzs4ugspcmn
X-HE-Tag: 1761312312-90542
X-HE-Meta: U2FsdGVkX1/689MrHV7yySwG+pZS2gSk0F9z16E1Qpv734ei0IkijrdIIabV7u1f8iZPfBnEQdEwlBMXzTJS6IsUbTs7+RJ7wWLgBiOwtLJHQKjphckOinSj0EWpeKU4zp2JS+Y8mWUBrXlWKtheauMQdyOA4XxULWiy6jOZT2ouT5Aw0YWRGNUAdsp3/TkQyQMTTkoiejOoCIk2+B74I0LbJYUIGBwbRCErMlzDhyNlnAW+mJ968IgpNl/McIwSYaIdV88UVQCjrD864H6NKJhVJub7obiM5Cw3Y2H4mxUkDruP3cGA1vDzAN09xqVYzXBkn05Go9U6SCkx0pO5dh1whppMqb6R1jlwwLfW1zN3rnDesz2nrC8Z3GpqbgtpOzvjaQHqsmdLlNgepEl61gt3W0mKamrt4eITXtYnJk8RnHeQOQwDm0xFFeGFOHRpXrv7t/KdAF3dN6Z/WcFiZVvNUiWl4PvULndPYW7wfGWrxHqL7ahINJZ9w05wRK680MfXzLLNcaqnKS5s86MVWoIaR2kaaEh53aDWcuOtFg07FseL9KRKSwsn47xwmztrQxVuxwWC3re6KAvo9FWmOiYuakAvq4TpG7FaOj2n78WN8pKjwcXEb0ElNKJ/eUMnEECn4H5FSF+0pqq19jmimwP0C7bTcxtMINbDnoCH53RD4k0BTF0EtyiyRTmtUsUve7lCfFNwhv37EnUmuSzjAX14/7F7+xrxr4mgxC1o6+F5MCELFEzlVY2RJlvXkC5LQYCIoXMYsrOhPtdeLFZ1h/GOhCdSSunTS9sjvQyZU7obiUt+n0TXafcULlHAAYTsUtlWhhSjDt6XjvY8aVCWTS2AhiRIzdELCNRhtv3qGbHzhsg2X6j3a+S8F/Wi7t6+YrJ3W3c0DGz3c0RIqc7shLHAMqdpL9CBlBliyIFihlIWrl4apzsOSYPNLdT93oKnrsJ/jGDbHi/RakpiyZi
 LfdeILxB
 jtJflEIR7Rsq52ybSOJJy5WYatZ22oLHfh2LLBoNIAWm9YEZqn0n6brq2tfHo32ZOmpfCRPr4M+pkzRqJalu4T/Ax6R2WOdxNchH2NyFz6vpD/aVWM8ZGs2s5Daej/apUQuA+DN8hDN6zfTynIyGD8QgkI36gZPRlUOWjHNWr9shRsl0eE3zN2/xfONu38JO84TT0+ylElrOovRDKkg1RuG9pCW1sFa6oalW58OJhNn+cY5t0rgVB7qBmDDF8qgy7S0/OM05n+gUSDMkRKkc2whZHAJkm5yc7JIuqcfe1AqVdx9c0j1RQbuTdSxdd6XmylOhYJuAfk4tbDqk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 10:19:08AM -0400, Pasha Tatashin wrote:
> On Wed, Oct 15, 2025 at 9:05 AM Pratyush Yadav <pratyush@kernel.org> wrote:
> >
> > +Cc Marco, Alexander
> >
> > On Wed, Oct 15 2025, Pasha Tatashin wrote:
> >
> > > KHO allocates metadata for its preserved memory map using the SLUB
> > > allocator via kzalloc(). This metadata is temporary and is used by the
> > > next kernel during early boot to find preserved memory.
> > >
> > > A problem arises when KFENCE is enabled. kzalloc() calls can be
> > > randomly intercepted by kfence_alloc(), which services the allocation
> > > from a dedicated KFENCE memory pool. This pool is allocated early in
> > > boot via memblock.
> >
> > At some point, we'd probably want to add support for preserving slab
> > objects using KHO. That wouldn't work if the objects can land in scratch
> > memory. Right now, the kfence pools are allocated right before KHO goes
> > out of scratch-only and memblock frees pages to buddy.
> 
> If we do that, most likely we will add a GFP flag that goes with it,
> so the slab can use a special pool of pages that are preservable.
> Otherwise, we are going to be leaking memory from the old kernel in
> the unpreserved parts of the pages. 

That isn't an issue. If we make slab preservable then we'd have to
preserve the page and then somehow record what order is stored in that
page and a bit map of which parts are allocated to restore the slab
state on recovery.

So long as the non-preserved memory comes back as freed on the
sucessor kernel it doesn't matter what was in it in the preceeding
kernel. The new kernel will eventually zero it. So it isn't a 'leak'.

Jason

