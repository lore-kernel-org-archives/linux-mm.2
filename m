Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16410C44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 17:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D8566B0089; Wed, 21 Jan 2026 12:12:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686D96B008C; Wed, 21 Jan 2026 12:12:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55E026B0095; Wed, 21 Jan 2026 12:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 43D4F6B0089
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:12:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4FD88C751
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:12:07 +0000 (UTC)
X-FDA: 84356613894.11.EBB2D52
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id BFF964000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:12:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nztVYumN;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769015525; a=rsa-sha256;
	cv=pass;
	b=X/PxrqRPVkT0o/jHclOapCD0scoHTh2eT8VEDMeiH/n+vOLUC+svJS46JMdnyw7Z3416jK
	OPUebhYu5/E9Rcxo9zUJ8D2X6C5SQiTsSXcycPkkDuZt7mEe+NKj+68UBkxUFqYorsL2sH
	w+NV8NVXyRqhBjl6tFq9t8U/U9SWpdg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nztVYumN;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769015525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wxe8ja7BPp0xudXZUtfCAF8pkuXAFux2AU5rIUV3nM4=;
	b=fF25BlhGtDFNE13ofvBJfSBHAyO5AywsezNmTHHlAih9CgafJ2sVhwgXE55Q9jHCT+WnDL
	8BJvuHdF+bodPHACnTDLJpShw5QvEntOBflv4GWcP7twMVNMIXAypPVwGREnENhHbbNGPW
	MfBydxwa3SjrNcYOqDFbozBYPcpUD30=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5014acad6f2so128781cf.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:12:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769015525; cv=none;
        d=google.com; s=arc-20240605;
        b=e+lRqf0N8WOHyIsH6uuv6ZIRaKfi/c6lVpOSpsJTjTuKvqPJsbdRZev1v8anycsA/e
         aNVwwFNxId91Q0uPduFPumJXScVFZQsYYHF7iayLmqpvQqRGZor+3okRrBN4WGO0M6QI
         cSR7v9AYoF7rNL9qsY/lWLJUP+SeBsZfYJ9Im8Y3oOezIh1zGnlI7JfenUhZDdd+YdpJ
         5iQXuX7Uerrntf3yyUCmPbt5eB38O5ZWhroWdm5VRJVmNYt9BzhE5dNv35NFV6Asb3a9
         sD8jVDmdFao1eUxi6gwhO5bOmRkSGRvJdQH1nXdU7lXNl6UneLTfWheidjSFLf5pG7ve
         1Kbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wxe8ja7BPp0xudXZUtfCAF8pkuXAFux2AU5rIUV3nM4=;
        fh=jh6Z6ITNy7nLYQFhrgXbzOP1LwSbPFNm/f4UuFJM7R0=;
        b=btIgQlaS5ttlPLBhSrtFpXY7AHd/Fi9gOvELnJDJo+Uafu2PXfj2oZOuXCN49jtMvU
         jbCI9whVr4Fm1q5W6srN/XuIUx/TXNpQbL0iT2W7ALgTqWBDDXUPR9IQ45gCuTfAVmU2
         YfC5HpE8avB15mrFeIwRWqI72q6NUKvEIH+TcCZ118GnB9NKk/aLXX69L2mN+E7fpNg8
         UKKki6oCat/JsUw2fCPKsqBXRzcbFplqdT796b+rxKjxG2kkpLzKOED6SRP70snqsSy+
         hvZ2F2H9xFyKDmXxbd5Sym7KbGl1nhJrtfF92sYNhIIMyXQn9O7zo+SlZIVfXKukuw7K
         CH0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769015525; x=1769620325; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wxe8ja7BPp0xudXZUtfCAF8pkuXAFux2AU5rIUV3nM4=;
        b=nztVYumNh+nwv8prbuzd6f4PU9QMtMI+VSbgOXt1PY5TgcGqj03189mjTvqVLABjP+
         5qeJV8Co1H3F7s/ceVHAufnyY3Wpc+UpYwMzo2+ofwAPB2narStD59DJpMhBZv0P0hj1
         T1roeBC+xLS36By1EJFUZGML/YqTsZqHbwav5LJDgP5j6T/QSYOtAANA2MTI3OajKpJ5
         Eo7HR2WagjTZOSHfg/WbWakXeYdNs/AI9TXFx2ABcmbqzYitcjKV/F3yaslSuVkL+quL
         TPr4EhYUPn3qqeMsm4Z+G+Akm3OLand6+J9jhpxkmexe0WWhw/F2Y2Pk+BoHlWWunN/S
         MICg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769015525; x=1769620325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wxe8ja7BPp0xudXZUtfCAF8pkuXAFux2AU5rIUV3nM4=;
        b=VXF5inDYSbrhY7OZY0S57cWMcqv5+WhtfcMNICDpTKw187Rj2azDI0TvqVZtzVOCAs
         hoIKg8pcEhiG3jxAvuUJfUr34AOBuPYTTNypC3febODNvhna9ZC04wJt/RN9zAor5jiw
         OYfBhe0KZZkZnnhI5nEGugtJQSe/sCFLg9nDPSImXV0ySedKVY8VXupTKpRmkYoIRPvQ
         eMl5vqkeycQeYMFVS8ieoqsVx7gc5crp+9plY+d+8Ey0SlJcVBjrum5n3cJ+WBLO2qHO
         8nQ9DEk0DPy8OTIRWEpWSBVe5I/wilAMksmX/FtZ/4Bjvd/rhk8yyatFUdwNJ90UATs4
         sapg==
X-Forwarded-Encrypted: i=1; AJvYcCWaCbnkzrpGyGppcNbhQQw6jECgNqb1OwCWfVF/PC0rty5Ev4ST38qIPqfyckx3z+RkQO6dBfGVCg==@kvack.org
X-Gm-Message-State: AOJu0Yz/I7EShKV8UvORtHus7ZTu/zzvfUzTAbppxGCXVkYYR6xO5a/U
	B18yACOgfIy3nKgzwtQ6tsZPRnEKdwvvlVdO+BWfIezHicP53HILffnusJeqQV9EbJFRusumIJC
	1wqfoy0qYr6FQT6CrAhQA18+YKBjoLjdqkV3nr2iM
X-Gm-Gg: AZuq6aKtJTUT3G1MGvzfXYPdz7ZIHWoYbM0Fx/ajRicHlaDRsRn9zhN/QRlWOvOuhmX
	hQAPvbY+KJXmSw5eJTOZ1agP7UHlqwxHmEa0nhn/YhsUY9sSuesjAJtcfRzLI6ojMpF5ef9YIMg
	DCV5hIzY8yC81NA5vkw63ILyI3KmFGarknMGkSR3OEChTgPflvOwphOPIkQkkQvARs0zIx3JHkw
	2MtZ2LClO9so6HoEmOTnTJPbt7GJ0Q7QPrTYkgfOKgsUCTNsoLus4INro2Zrf7y87GaBXGPKFOG
	xo6hPzD4GWCWtpxBv3pMBx0=
X-Received: by 2002:ac8:7e8c:0:b0:4e8:aa24:80ec with SMTP id
 d75a77b69052e-502e0c62ce0mr14559311cf.14.1769015518740; Wed, 21 Jan 2026
 09:11:58 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-13-5595cb000772@suse.cz> <veqtpod2liqsi4mgcxndgaiyqlhupnymmj4pquueqziqyakmnk@fzympoan5pds>
In-Reply-To: <veqtpod2liqsi4mgcxndgaiyqlhupnymmj4pquueqziqyakmnk@fzympoan5pds>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 21 Jan 2026 17:11:47 +0000
X-Gm-Features: AZwV_Qi9FJEvRsSrApnNVXPgEwKn9hYifa6IChzrQfzwFnpFd6X3lSwIuICSEss
Message-ID: <CAJuCfpH3DVwK7FqfKb3WChWyz_ZJvECBf57Ehxr7qCzS=Ym_8g@mail.gmail.com>
Subject: Re: [PATCH v3 13/21] slab: remove defer_deactivate_slab()
To: Hao Li <hao.li@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	bpf@vger.kernel.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BFF964000B
X-Stat-Signature: zcfgw5wf3r8ftuqj69bw1ndcos1pm485
X-HE-Tag: 1769015525-258948
X-HE-Meta: U2FsdGVkX19SsuK3ve8SBXuXS6wlCVqFKop0JniwPhZV/9S/qjcAYwN06hnmiYhI7kNb2KGvRK5wutVte3B5H1AI0G4wxzsvanXEyaNeExASLgY63QgLP8K8/90lBh2jGu+UJ6o6tzo+W1QvT+YZPa642GArEDXginbgLFcmF1MKsM6Ba7rkZWFCxPPZ+28Qt1lBN6BOr2pDaB4FEz+chsYfNiBymQG1hT6COmwT5/JMk7fXgDrx9s+IfcMXQRT6eDjQhNP+T8poYIQd5w+djLMNxLraJ5ixiXCwH/jcw0U2XDPSGzF7LE8HNRyhSeNX+4+legQPafi1QfQ2h9B/6NzuLt8RV3W2Px9jSQSIJkWXOMTILCZpB++9iA2YCEtzzmgyWC7aluMWJCV+VSK66JDW80tq8nELvfk6blf6RfZyS2/atrv9CPQg9UQzeAlDgsrtfmnXiJDSroEHj/9FN8qt8zomE6KbmqKtVe3Vd+Xq5k8amgFdWRjbRiGDLwAUYqnpfBbYepeM7uzLLO5alvUIKPadlReVoNMLy3RiORNOE59NoPfPxtVLmIGRsBSgS7BCgNHihUWiJoMhfR81fsf3myZXzQ5UvfaBQnts0c82edDS49P80Q2u7jO1qrO4QwalvLMcYe41ft9lzgum5ykD9IK7sRd2Iv5i56l0aMs1oEfWYBg7SVkIk3rejPKVN/PGspEMd5JPsVF98SoJ2ApZUFBnnApN+Dds1JqOyUfFyNEOdjMWCHVtinrppUdIBcTqdTDEElMveSrLQ+mPO+geIpHmVd76SEpJul7/ybgLYHJ2ebcJWU9tmNiURRv1/+iQ2h9y4PQH3uJNhY6a9LsrjP1IKdxsdKp6+DZ1OBAMGlksWjrZW1OcqhWc0TLQVm1usXTDB11w4gVuoJlaQcvWuW+hopqPNdHjEqYYh2sstA53BkJkAxlMxy+xNJutZTv+pS8c7a/oxryS98X
 IqMoINbc
 P2BfR5YIgjVdvCMHMgL3sDmIHnITWEleTZACsFwp6TLcmRA9p+oZ1+HJNw8XAinK2HfzHhkHH+zpy/+8WVhgygKMbSwlDMAb4PUOPQCVOQHuqlP6CsVlkoHoh+w8blS04WNpjMQXAGpPFtW4WZ+/bmtS5mjsAUS1vDSxGlVJEKwNRVCGuIYmcYP3pDbCr8kZAd87rmKoioppcs2HNtGSRbZ85vVWyRrMTaFZmj4f8Fn2asWMKc0l+MsBmCJvjshujlKD/N6gfHcLCyyVx5AGQ7BDMsWM6xlGag1vewIeHP94ttfDeHyCG8rMRxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 9:35=E2=80=AFAM Hao Li <hao.li@linux.dev> wrote:
>
> On Fri, Jan 16, 2026 at 03:40:33PM +0100, Vlastimil Babka wrote:
> > There are no more cpu slabs so we don't need their deferred
> > deactivation. The function is now only used from places where we
> > allocate a new slab but then can't spin on node list_lock to put it on
> > the partial list. Instead of the deferred action we can free it directl=
y
> > via __free_slab(), we just need to tell it to use _nolock() freeing of
> > the underlying pages and take care of the accounting.
> >
> > Since free_frozen_pages_nolock() variant does not yet exist for code
> > outside of the page allocator, create it as a trivial wrapper for
> > __free_frozen_pages(..., FPI_TRYLOCK).
> >
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> >  mm/internal.h   |  1 +
> >  mm/page_alloc.c |  5 +++++
> >  mm/slab.h       |  8 +-------
> >  mm/slub.c       | 56 ++++++++++++++++++++-----------------------------=
-------
> >  4 files changed, 27 insertions(+), 43 deletions(-)
> >
>
> Looks good to me.
> Reviewed-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Thanks,
> Hao

