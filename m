Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E31CAC5B8
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 00:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9D2E8E0003; Fri, 26 Sep 2025 20:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D228E0001; Fri, 26 Sep 2025 20:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C118E0003; Fri, 26 Sep 2025 20:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AE3818E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:05:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 522E71A07AF
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:05:33 +0000 (UTC)
X-FDA: 83933086146.27.96E5283
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F2FE180007
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:05:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gHB54boo;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758931531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJcApcxweyRM5qb8q+BHO4zpFu1pgF/83cKbiJmqjlQ=;
	b=O1aO+Gf/92avrqY6LkzC4GSKFBlSoQ/0/51QtcGccO7nOUEDU4XjWXSdw/aC9zaVWfNGs/
	vN1WUGhvLeh9wlYbu0cGjv1IjuaGQ2W64cW1eGeDD/tgfLuS23OKTIywmygQUbq+88LqU4
	1BQxFtp5BQxcyRBYM/IIe9kHX20BoI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758931531; a=rsa-sha256;
	cv=none;
	b=3C7CKXia8AjGFOe0tLSLmUhdAY6DSyiGoVXvKhUFKFtNbOKJ/VTKUjJSkYWMfwJ0oMiVmH
	UPXSapaMuDSPyv0upeumeLL5f7VSLQ4CSRLUQlEo9t5LyXQnG+lpRUhfs+UDTkHTNUAQii
	ACZA7bpOyzM/l/6aO64QPI2uFrg77/Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=gHB54boo;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4de66881569so146831cf.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758931530; x=1759536330; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJcApcxweyRM5qb8q+BHO4zpFu1pgF/83cKbiJmqjlQ=;
        b=gHB54boogVVVAH0lifUyPwkf1va2/swLTSdYFldu4aYL+/bWkQYSwQlYP8N5WpLpFJ
         3nc2v1E/MrqUKJ6tl1hW4zHVvDArgFrXBSccdebx5EhQC1U6SJT70np52Mv8ifWlmr9L
         ONZVswpBeQM5k1bUxuI/7x7lJ1gJP4fpYQTUS0Hm/2JEqCMGoR8DvZkM+EIad85FvdcH
         E7IGS+ufhiPPwcTrKeDVnUqX28DZOij6aqL7ZUspd2i/WQGiRjrpTwDDxntY+1tn1+2T
         9CSHdgLPT1klXQ6wX4I06mAlHa6rxrQ8Hfg16wegGv+T2E+wzSpuKwDtsgWPwM+SFF97
         iBvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758931530; x=1759536330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZJcApcxweyRM5qb8q+BHO4zpFu1pgF/83cKbiJmqjlQ=;
        b=oJ9PNuwW6tJzhGro4QrK7k2yh7Jy28evB+nyMFcjrZGSu1U0Z+IBNG96Z6IXrzV3yu
         oBdbJWsFJ44kMJJjiy7yC+SmqsT1l75Z8uqWEN7nV2ply47j85SDFnE3SOA3a6MVsjE9
         24H3r2td4JVTbJICx0Yn1w6t+RXoEKPiaxen9bfPzcL5LYp6RWLie+J5KHfKmBxVj7TH
         /Ku7G3ZqcrUrAKG0qoSqC/ocijol3SD4ZG088I287kIdYJqJ8ttMZT29ZAwM+2o03mb3
         Hnm3dnzY87oTNAR2wnnN+w5TJthcuNmKkW6w3YO3Wj1WZKXn+RS4IJhI/Ik+XfWdE/0T
         I+HA==
X-Forwarded-Encrypted: i=1; AJvYcCU0QxOUZ/+6ryiBNug56nkP5dJQcOt1C/wqu574r2XXB+xnQ/RFS8cFOz/3dg19o/helaRhMLgbOA==@kvack.org
X-Gm-Message-State: AOJu0YzXIqiTCtrMeWPfNxVvUtyoXb498qGB60al5doZ1K988J5B20Lc
	szM0WRD4RMwFrD3KELfOEzaYNtRnXS1xKWA49qCjlNhsqt6mpqYSkw0IVO8yBwcWvySfjdqF6Mb
	uKk/eg0wNfeiE/xtou0GPj7Ex3PWZt/VLCNgy75Rh
X-Gm-Gg: ASbGncvcYahuMZ+USy2r0Bp4PFWjm8XBNnCwUfVKI5ANqAt1wapa8L+dWw5fQxoHn80
	TEGPwG75UZeeH0kqNyXlglm+OIA7JN8Qt9cv5LUIZQyRQgizQCAtWxgyue+o+2tkrjS8CQiPd1i
	UIovjquTKfFp1zP+u1u5JpBmK/gdMX5ItayRj76bVQK9sEuYcjzUkN4QrF2mUtU45ibl0WvAwkf
	cIwPkQCSTVoCDtt0xOq6lE=
X-Google-Smtp-Source: AGHT+IHLCDngHaqm1d35Zq76dt69sq1Eb8/W3LhpZr4vmuXG3Ed3TJ7vkp6zVFZA5hFCJnDSxn7t311TgnkpSyfh7dk=
X-Received: by 2002:ac8:7c4b:0:b0:4cf:dc5c:8c76 with SMTP id
 d75a77b69052e-4dec6c15531mr2551671cf.11.1758931530143; Fri, 26 Sep 2025
 17:05:30 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-18-ca3099d8352c@suse.cz> <aMqfmzwCu1N_L1qp@hyeyoo>
In-Reply-To: <aMqfmzwCu1N_L1qp@hyeyoo>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 26 Sep 2025 17:05:19 -0700
X-Gm-Features: AS18NWAQPijqIrQ4xFfoBcVJ2l0qQApTG79Ewx2_B0nlbyTUd16bMIuKaNKF2Mc
Message-ID: <CAJuCfpF52wCCrddQizzsMHF3myuD7JsH6p8DZJgN8J+DGHx2WA@mail.gmail.com>
Subject: Re: [PATCH v8 18/23] maple_tree: Use kfree_rcu in ma_free_rcu
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, Pedro Falcato <pfalcato@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F2FE180007
X-Stat-Signature: qwfc8bcdfh4ibqmr1ty1dyo1xs6kya9m
X-Rspam-User: 
X-HE-Tag: 1758931531-276893
X-HE-Meta: U2FsdGVkX1979WzC433rnmRiEavkmhcIXMts4ZqeIBRjs5zYZmbmKW9snZzni85rpQGanlV4pbXCQwLAFTAvQhNSdOhTfkB0neD9pyqzz6sr/K75Ad/AeRgvye7GceCTZo6uyiMrvyxO84NNoGYnnUnHnvgQMeVVJdEcgOm+urKW6A3Mby7PYUv2ufZSwIP8+ydTrNcJeNHn905phgevX4JETMakVVVWsFQw53ESkFTrf7C/VYO3ft73I0wG6W1OI0IOdiwFqGc76/CEN4T2zsYCQ+kyLA8PaXwNH8nKDTLKfhepN7QWWyamTlFPMCD3CHuxKXPcMG4X42LG8FqrjrDC3ISm5eucc83CIxbiX+fJgilMJtB14K0sfBEQxNCqnu4tmkx5ghTOlPPJu+pKr1VK0cithRCllPzuymCnTj5sgvYQT/V9niSRL6EUaiIFpPdWPEuQhb/WameyxDGskSWImo07OixY5c0tYGV1KdvZiY/gGJAbXEDgbt/Zcnie6Kcd4/KRnl7O6OIb4W030vpXYTMOv+yK4e2jXTEwiqw04DwjHhs8ccGqnnK+qFQL3gkDvR/Pp+hQZCqfdn/zYChCMNqFXXgE40MFYySot0FnLB3+5fAZTmjm2+kmozfBvwcGRX6Z5b2un1ClePrk98yZnC5vJdl4DjQRoOFlwR5Mv6nvV7yaSWE+H6ntpF3wVnYoIC40x3LdnYJ2DMCL9/R9SguzO4m2irrTbrJog5v7JsozkR/afuGTEx3tkOMntwEXbgz4YSbYMq5kgtDpkscsxYcKToPNHXAhynSDOM45kKbwazSjUpraaaTqonxDV92LLU5JBbG1uH8tA+naVUvnXb78hlKVM9zAKoZJISOJflGln9wJRqM3tYijJDj6CngS3MUVGbWgOpirF8zpiToVSKX0Ajx8oaAJ9BjplHaQ8sjOmedfxIl7mZrHXoCiWtZx93V5muGbmyTTv6l
 ynTtnOiQ
 L0JciKOfQbvethU1OngP6jFPc/U5JVo1KdkkP/qboAYOsRYSxSB6QEKJPcDHDXxAf1ZcDeQwVDMvHOiRxbW5TF79U1ifo2KUqwSlvPTmDBRXH1/jdClJPSfdQNKQ19Sr9HWnFLv9LttR6OkCsTNYrKiIlTPmjTy1NzQhVyz5AUsOZI1WEaiZcbkRCsGSzMfXea0C0zna807a3i3PcAlL5yU3nHcMOW+kof/dWQpL/uqBgJYPTF6zOEOLVEkot+I9xiy8PQp68FnMsm8Qczak7sxBfbFlKVlx/AU+n
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 4:46=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Wed, Sep 10, 2025 at 10:01:20AM +0200, Vlastimil Babka wrote:
> > From: Pedro Falcato <pfalcato@suse.de>
> >
> > kfree_rcu is an optimized version of call_rcu + kfree. It used to not b=
e
> > possible to call it on non-kmalloc objects, but this restriction was
> > lifted ever since SLOB was dropped from the kernel, and since commit
> > 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_dest=
roy()").
> >
> > Thus, replace call_rcu + mt_free_rcu with kfree_rcu.
> >
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
>
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Cheers,
> Harry / Hyeonggon

