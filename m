Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2C7D47CAB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 00:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F296B0005; Thu, 15 Jan 2026 19:06:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52CDE6B0095; Thu, 15 Jan 2026 19:06:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F546B0098; Thu, 15 Jan 2026 19:06:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31CCA6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:06:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE9811A04C0
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:06:31 +0000 (UTC)
X-FDA: 84335885382.29.C52B58B
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id DF91140003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:06:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ndmASu94;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768521990; a=rsa-sha256;
	cv=pass;
	b=Z3w0Q0zTggqCmFRe0Am5a3PfHYBrlpcrL4zLgKj++EJK6EnRPzZbfyjfywx7CdRblhJJKj
	T27mfVhQlVk+E5kBiSY11GpptvzY8NKNFZb4EF2dUAw7Zz0GCgmDosho2WYi+K6UlfokNc
	AB7oNsoAaar1L6feDX9InsyxreHptQo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ndmASu94;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768521990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=026F9tB9C4DnFMNAbwjqTuZTqI/FPwSez2fEDi6wXsM=;
	b=6Z35fnnvxKxe0zLZDqiJfVt8t21XyZ4ndWAv+uPWYVCAGaf8Ov8nId/FQU9nufW/nO79e/
	Es8tr06YHlVFd/K0VMM+IHAT4O3ld/iVwW5melpAxPItoF/tE4VKqxnjTY2X6lMB4SxNL0
	L2Y4pSC3cHsvcN9ykN8oE0HIyp2ptYQ=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-64baa44df99so4127a12.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:06:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768521988; cv=none;
        d=google.com; s=arc-20240605;
        b=jvM+t9BBc9i5q5NsO+VCZW+2OdAsxdX/XAHtPFDQtJI+AA40cm26OdbPXCUCRsxQNj
         pOQFm1X2bKkgVbADAVcn777GYoHfYtCAXGzX7ct3/Ozx7eIlrYG4VEgUxDFomKE520om
         18M9cqnE7/GEbeIfY1EDSPYs0wHsrUt/BY0uJDNt/L9ywFkeqr3Y0kdFXYxwrNlJGvLH
         S/OOJZJ1P/DEj1D3h9hre1Cn24bCDXNrdYo+ay/hWmTegM+p8/z/oQknUYbvOdhASuKg
         MOnwQzO/ebTpvdI6bkpTf+lMxRPmXhtyioWW+1PQuGXg+cTJ5kgFO8hoTQ9Zg6lXRJih
         cEiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=026F9tB9C4DnFMNAbwjqTuZTqI/FPwSez2fEDi6wXsM=;
        fh=5QVvR+GFGvqTSJc2sglPPFEQo8KrHo+bzq/pwaesz4Q=;
        b=hwfn9ncGxuFdP9nFh6RHNdbsXEaZZoSJOU+RDUbwgeVR8wul6ed3VDwI0iFpsY/8or
         ANVWpYHtATqoJPT5EKMJbm869BfhWWE45lZAkhC0diUtvM1WNHhvIb2kDu1etzy11qNF
         ef5HoD1mdMGaD7o5KFDl02YE6fd4C6tXY9aXqW9svUdvuQjsd4Ydl9fOZjCirSTLttFC
         WMzg93l4T3jbXl8uoq/P+kINztFl3DXKwTO1n5TulgyHv4YVzHOhhR+o5uvi6IXTn33l
         ltOaIx4HTjs3YfGInlY81yVlwMXdoJeai9F5pMCehmXRtSq9vTZMcLDsK0AZvo98orHe
         T/tw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768521988; x=1769126788; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=026F9tB9C4DnFMNAbwjqTuZTqI/FPwSez2fEDi6wXsM=;
        b=ndmASu947whgw5aNqoKZXzzZV75VedsGNzWy5Lie7zIx0+5L46hTHRdFcjE7urHKqv
         UUwaW9o+oNVBh1QPyUnW6ltCL4mTeON1RUVtEAuvxGRfydvPmbO4l0KoRY+NtZH0W3+9
         vNZvcopDEvPTG2xB5DtBxipyXyb7ejJn/kScfyueqGhqVf07q+WR6JNnwL/RJXwkXY8E
         oLFki9N6IafTjnrbXMn5WrQvttcPx89qJPEpwIRpYk5/Y36DOkZx4y8zO53737BbJ7+w
         0JjiGAucTLBndy4U9Tbozt5eoJrWtgB1O3xbaa0Z48bEmx8Kiof2ro8iK1DlMT3BNq15
         fMvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768521988; x=1769126788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=026F9tB9C4DnFMNAbwjqTuZTqI/FPwSez2fEDi6wXsM=;
        b=Haz5grbWPvb5iz84MQorADvalSFVnuXACScE9y5Pghxmxv5C2Z8s+ftmXzoTq+RPbV
         xL7VjUIkQnVuOU41UGVqa0lrjAJjng4b2WFJR8J9oSVQCqV7sPLKpTykQa3u+I3ynhiO
         rW5WnxxCsgOfA/xsevipZ33XZx+FX/fjPsLiRNh8/eFkxB/3pFiL0xje+hzL/oLryowN
         5gplvNhIzO+NAGvNYKvAZdJe2O2XYUXJa2fuixjlb+O7k+djRs1Zd2GVbLE3XzSb6aeL
         R4OrTAfT/FmJL2TilVhsyfdanh+hwqLCQi0JwbQD3onUKgZRvmkSLShk4fbc+4Y+5LJo
         cAyw==
X-Forwarded-Encrypted: i=1; AJvYcCWI8MZYgr1JlPLsq30bnJGmRZQBuLoO0Qw7rZjn21nQUjW0K+siiA7M6XVxJ3wHv9kz2FZQzowHIg==@kvack.org
X-Gm-Message-State: AOJu0Yx9iX6UakYNGu/fzigbYd3Tk/OGWLyRwziGzIXfh+5vVkBrsQHw
	Ko+HQdJrPCpSqh9tBJCKQR5UKzV9+yQgMetJtiR8z76F9LUwub7U3jT5r7njZu+L/afh0R2TygS
	tOkplB0oHEyV3pZMBpCpHpJ32RIIplNNdUm4srHXz
X-Gm-Gg: AY/fxX4U0m/BBwdteXekBJslA5moVDxlxmw0E3tJpKCWTn/y2FYpJXvMx9O1kPNLhws
	XWHhoo9b+1/kArBbJ3qTz2TbhE2fes0msQKN9bs0767QzD7OaX3XQTg57DkVyLGJcV98wgUXZhm
	0kxGvIb6IBf2004sDjTQ0dpD2CMGOwQQmnm/uIfArqTFC6Vdpgy6do5nn67+9/TYsgY06KSlAck
	ooD4DJU8VcWD5QNw5bNabRBfNde00jdX/UfnTmKHMZtP+aiG2nAFdi7UtCSeVoVzExF67oVAd1a
	HCErwkDHTyISoGE+x6p688w=
X-Received: by 2002:a05:6402:564a:b0:645:21c1:28f9 with SMTP id
 4fb4d7f45d1cf-655252e133fmr5226a12.17.1768521988035; Thu, 15 Jan 2026
 16:06:28 -0800 (PST)
MIME-Version: 1.0
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-2-98225cfb50cf@suse.cz> <aWXvAGA_GqQEJpB4@hyeyoo>
In-Reply-To: <aWXvAGA_GqQEJpB4@hyeyoo>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 16 Jan 2026 00:06:15 +0000
X-Gm-Features: AZwV_QiPFAF4oyordk9NHVKA3LxKDdMlmD4Vltq0PHkaKAiIFW6MRACIK30AxWk
Message-ID: <CAJuCfpE7ctb+AYEsmmDbW-3+DU-kDb2ApYWYXRur5FDtPP6zng@mail.gmail.com>
Subject: Re: [PATCH RFC v2 02/20] mm/slab: move and refactor __kmem_cache_alias()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF91140003
X-Stat-Signature: 3qfx4er6wwui6mi7ijrqrukd7rjxy3bu
X-Rspam-User: 
X-HE-Tag: 1768521989-354914
X-HE-Meta: U2FsdGVkX1/QzXUZ9d8lH5qjBXu6+Zb23e5g6XU/2JaqJslxwIa3fNz/SvG3ZpdYl964btzINaNYmyolCkZzD/crCSpt9Uwrpgvmy6duSi/EnuaQtavjAKiyV7em69yXwpjfVbW/bPRwMLdyOZrT/h0dc0X6qh8c0hILPOHSzkCQlVtzfb3h4OmbTABqduKnuu+zqIuxrgh0PS+EfHs5ldbnO7dLYLRusB2kHVxJZL6ci6MImnQ+gNtFlPZft3E3/HTt5Q7neJR5cY0v2aNa+DJS6AKso7OvlpyTSRezGxiGsAj98tk55+XYTzunllukMvs67+XtWt6t9AmvPcoWfDzJqBMsz+/FECj9dexxydjumAEyoBkXDC+6tVoyAh7eQmbKk8Y6IZo/zAO+GnE33XIkCb8mMKsVZWToZfvYA/yAOC/Pwp0FVPoSD/pdBMEofYANExeDK+dyOVPYaInHSZ4E42oXev0DucN0Hm1AuoXYCUTS48HZQv4qlWxNMQfd6/2Lnls5zNgX/tg8uxY42+ghHwxZLhP/eFinNFjNMvJGCxrYJlVcNFrBrLidNg2lDa/qPCw5j+Fm32cqlPrEuUWTL6gz+WbY3FL2U6NqXez3cmyCXkCkf0RP3LRBg1lEDbc/n0fIiimLpYVOG8IVsY5AgGfl9Cflz0cZhCjLVCoMXE+6dJNvSBOxommozIaOtWxCo3zb+iwdBHbcj14xQvxmQhZA1Kjre3tM3+ocxC1kxyVCn7Cdn9FyLAfn7EVLstn3TmOctYcbwZSDsBWzIzIQM/3OF++Y8nyKAnODxeTYZUHF/dJsUw/miqzZxBlKnmz9KY/8q4HpzApvsufQyjhaPcLPh6+TlOc01rcc/UcQrrfZ6hNHNhqhwO/cxjiX+OaMFzrnpWmbPihTHlPDs1W2GUgaE8b4EC8JAhxoJqyJHAr0YBqTCk14Z0P7Nuj895dc6ZmJjcZAgJbJF0w
 bYf4tcfj
 vSV+zodRv0+XS0E4wiyN+Ct/MPuCEWHk7um68sMp+0lwE2JaUKwv0vJe3BNCQ4+e43Vuf/q9Ft0xjhqi51xaDxYpLKFDA90t4MutAmP+Wl/5f6y0Aq2qWLaO6vkkktRtRmVsHSs5IdzH9lI2CaP9VRTb/5XgtrwkpcznZ8AULyamtvyaijIs+CnPEPZE7e63hR96ghEhky0/mllGfNwI4v230zWoL0uYIrOhsDEqorOqqQacd/DszYC7PKFW1lrDrMZN0bsa4gXQeCK7QM0RVJG1l3/SKbvE/kJaQ+u29wO6lvtxTHkjEeIbfOah8RG6+HveqThQeY7tdpOVVT4hVMhHj7X6vVtq6nzozWJyFpKfuh7OrKetGMoYTca7Wl7nEeYk7p0jBK7EUsHX/R6TqOFC4EldV8TEWVodo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 7:06=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Mon, Jan 12, 2026 at 04:16:56PM +0100, Vlastimil Babka wrote:
> > Move __kmem_cache_alias() to slab_common.c since it's called by
> > __kmem_cache_create_args() and calls find_mergeable() that both
> > are in this file. We can remove two slab.h declarations and make
> > them static. Instead declare sysfs_slab_alias() from slub.c so
> > that __kmem_cache_alias() can keep caling it.

nit: s/caling/calling

> >
> > Add args parameter to __kmem_cache_alias() and find_mergeable() instead
> > of align and ctor. With that we can also move the checks for usersize
> > and sheaf_capacity there from __kmem_cache_create_args() and make the
> > result more symmetric with slab_unmergeable().
> >
> > No functional changes intended.
> >
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>
> Looks good to me, so:
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Cheers,
> Harry / Hyeonggon

