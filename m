Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF15CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 18:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 153896B000D; Fri,  5 Sep 2025 14:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DD626B000E; Fri,  5 Sep 2025 14:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0DF56B0011; Fri,  5 Sep 2025 14:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D9BE96B000D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:23:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F1F01601B0
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:23:31 +0000 (UTC)
X-FDA: 83856019422.26.4891315
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8A26480006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:23:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bvT5OV5Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=yepeilin@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757096609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rgWOc0h7T/LwTAxHfFQtzP5pqZV8FThPEz2kt4MSq5E=;
	b=m4mnH9RIceW5VAd/qp/4WP2eEYau6wUqr6WdV9DYBu+q/9bluNsXC2ZC0vwAAWX4gDxd7k
	Pk6ADazzlLvJ5cyp8ge/rcz3ISbUX6zWNwjkSnMuOuYSJmJNfI6y3hUacz5ay4us8WBSaV
	LdOAuZn4Eou5HjJe8dwgY+UmKIncKPc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bvT5OV5Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of yepeilin@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=yepeilin@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757096609; a=rsa-sha256;
	cv=none;
	b=0EHPLB+2TOwtVOQCIYjYqfavyshz0u9qgYE+8f0TKO9/fc+B/6FqGOafqvSghGsNZJMfnX
	j1pg/66tQaNHGs3cqUbby8upqKkLYQa8KKDyQy+8w70P5AE4Khuf/32O2Ee0zlBPGF3l6k
	Cpk1fVIZ3nJjJ9BEApadwXcqZt+LX+M=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24b2d018f92so23545ad.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 11:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757096608; x=1757701408; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rgWOc0h7T/LwTAxHfFQtzP5pqZV8FThPEz2kt4MSq5E=;
        b=bvT5OV5YTpoN/Vj2qpFFB8jkDTOsqVajCa5OxSPi6vezsaw388EG6u1ZCXIrhvVLqn
         9PraC6KUa6Gd73EcWzm/YihnlOfo2YY1s+PPAyFIkeAPlDsmfg9jGJGW2QEFELS2ZR2J
         t7UqPxQpIXX38OMaskO7ppkVE2dcaaNsHdFoABJ0OPeoJ8NU+oBt9CL2pLUcvjszgJfv
         peHfiFvvlB5LnXzSry178+QEP9+5SxTeu4m6kmNbnheECb6wW4Mfg7Fhhe/7OcSSmEP3
         x8x7wCj37CktrAqGMGGSQ7/2nsCSPIcEYpLx6VEkfKPrfqUUElWUGHqBKRkgYDHu6XN7
         qvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757096608; x=1757701408;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rgWOc0h7T/LwTAxHfFQtzP5pqZV8FThPEz2kt4MSq5E=;
        b=Zh/WW6xk9jg7AcB14+qDkHDi385foPgjBs0G8obLkq0Hl7jKdczQkOO5LPrKh6ZMyV
         AH4IuEBuK0DI6bo/p7ju5UH7ABqBjyIxkMEAJTwGv1GbUOv986abIkZpJ2cT4NALkymp
         FjGOSpPdGQOz7Gs7GVP/OZ4Oo8R4IUdPEregSSFXbCoUVmcqAcv1Ouqa5wsk2gSt3OfY
         YIdC8ny80ZH1JW+qaARexiDn9WdUeLQCQfmMTBmfW5J1W1itRgbOo2e52ONGfc25FYhx
         EgH/UkQnyHdgWHVTihY6dMbD9HEOYW7qAVm1u05uBekgi9m/PVlu6vNpz5APDazL58r3
         y3fg==
X-Forwarded-Encrypted: i=1; AJvYcCVNv9u7T50UyNIf/Uxsp7fQBjUhjeObYaj3vKIoT1ck/A6hjxytpOt8Cag2hNdo7wHXPm+eqm/c3g==@kvack.org
X-Gm-Message-State: AOJu0Yx5S5jmdh2f04MHAsQL8h02ihXJgo+83Z8/hpRmB1+tbTKvZqsN
	pNv2gxsDPVySHc6yPqDVkYar+NxKR+qsJcU4EcM0AYkLGAuejcAt22vs+fXv3zKF9g==
X-Gm-Gg: ASbGncvvkBI3O8ke+pfjAo11EU9DFm/8Q3AeYaVOw+q+p+4B/QquBWWoQEOIMr+hRPW
	FWTD90/YTJmh9Ha65v8ZMiKhggF9WN4+Or6MzlL06maY+cFYomRaJYOd1Zp84nKp2p/yEfbXadm
	H4v3ThoYVc7T0Mkebr01jWn10I8LTTlOVvYAcBFhL+4idzuVxNg8tvQAhJx7kguQp9lzD+wMxi6
	yhWWj24a5ABnXink0REbtGecpu6OPRwEDmLWvGk8NtW5nQPnTlqOdGKhEg83mWN3pgJzSdLHipo
	2QHXwH/iwemBgcOGxKOIJXpi3jAkf2kVflwVjY6FUvPxumdj4mTqTpHWWyMsHolsHS3nV++lHbS
	lLiYDwvzamZbEdaD3nXH2+J+8bn3ng8KVQbMh3L711MEpMcN8itrvm2AeJJxR7yoFwzc=
X-Google-Smtp-Source: AGHT+IHIHCT/LHWg3smHhUZvr7cjK1B8dD2CGV1dFWXEglBs03iMs0n2W9jj0hS//Dye90GLARpV1A==
X-Received: by 2002:a17:902:f550:b0:249:2caa:d5c9 with SMTP id d9443c01a7336-25123db6d69mr166865ad.17.1757096607758;
        Fri, 05 Sep 2025 11:23:27 -0700 (PDT)
Received: from google.com (132.192.16.34.bc.googleusercontent.com. [34.16.192.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24c7d2dcd2csm87587595ad.145.2025.09.05.11.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 11:23:27 -0700 (PDT)
Date: Fri, 5 Sep 2025 18:23:22 +0000
From: Peilin Ye <yepeilin@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
	bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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
Subject: Re: [PATCH bpf] bpf/helpers: Skip memcg accounting in
 __bpf_async_init()
Message-ID: <aLsqmno0KJqrXFot@google.com>
References: <20250905061919.439648-1-yepeilin@google.com>
 <CAADnVQKAd-jubdQ9ja=xhTqahs+2bk2a+8VUTj1bnLpueow0Lg@mail.gmail.com>
 <qwrl5ivlaou2qqbrj4wh2vi4uqmeny2zyfidkjizkyyzta3uo3@z6bjemb7om6y>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <qwrl5ivlaou2qqbrj4wh2vi4uqmeny2zyfidkjizkyyzta3uo3@z6bjemb7om6y>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8A26480006
X-Stat-Signature: q4eszp3kpcopjbr9bhsxr1yezp7zufk5
X-Rspam-User: 
X-HE-Tag: 1757096609-894340
X-HE-Meta: U2FsdGVkX18RmwgXyAyg4M9n80/c83GyhNwzp9Ia3//gAaKdfIVhoV7DTeQUOxt1d+JEnER3R9ytL7hRMm+6VVqgDk64cNunZIXx89VY7xB0SFhTWyvG7hb80ssnsllnlDFx4kdqh4sHu8od/VFTagTgJPL8mi5oqNlzEUI7UrjMEFnI0jWuJJw5sUIfOvaj1NxCyhw9NesxGS0sROuvxSAFTGSNUQhr6656gfG2MaXw1b+FkrSTfEHsbQcoMQr2wpsVUBOEoK+pdqXuRzXV7vFWZpFpFhxd123tDAzkUblViQVq7L46MLdi5Sm7qrft/3eafEQel2O9r7RD8rWyRsVY6BjKNEcjla4I1mO/A6CQWCscyMzhsOTMwyv5tOuZfEMNDD7eJXy7pGm1puZnRTsydMMUwlB0xckC8pQXrDkpMYJyFC8hFchieK1xj6woJSy6ww8UXz7Cok1s05nN+dlLR2ufUT5e75e32F3nVFkrCukvvKWODXIOyMygLKzfC+0YLqlqL+1ZfUXNefruYCOvVaw/PyV4hwtYT+7MREAp9OUUO/HK48izrH1HAVe0tAx/T6lng3Pq96u1g7ZsfI4YaqTZMB1opHvptoiNlDYM2b29jwxmmmciygV4oBkVZr3R1fCC0xkv/qTEiFdNqWdaTOlucT2HbjsKB1/S/1vPPc8IaIFTIJgWo3c5vK6p0qNODYbVRqE/zB/ySYhnq5uV5J76Wm7k5thgUDJcv1ln+wK4z2I2s6XFRJpvcrH6LZ9O4TEblGRTUUdIEJ3TDefthGdIdqKDSJrqrWpFdFpnJMkOI46Uwd0GOqDDqLeRKk9XWtezDHj5nsyQgC/E0lbo3mfU/wKtSgZtHxy4y5O/cqHSZoAbEaxZMk9TjTHas7Gk8z5Dxe2mipTxHzH/O8r3olBcFexCYi8SYSFtViJylh+RRsvIb7Xw/kHa8GjWmLceCPU4A78yb4O734k
 gj4GiwbA
 8PAJHKligTD5n/J+LGbF7ZQxT/JHC71sGd0d6inPmPohDC2MKfDqrj6e0Y66geBqB10akG9/612f71MPyuY4Xp58AusGpgwSU/QSnOpLQupg7vvLjSTii24450T19OcMDDs2Y4m1j/av/SWE05GgRj9jIeo3GG3Z+SEJuOUqHhvTfk2jE9qQ74wIkBRPnlhRRBSQNAYC71FtLoV/HTqqTFUZ4RFtuSec0+OWs31aWmJ4By3NAUQmWG07nG+K6i2fxXGdOPZV4CwGnr/LT+uCVeE7n8vb/WS7eti2rnuNQ0OQL6OvQV/dO0RasEBSb5lS5MMyUSeqEsekeoYVvIQyYeZwXnp5VF9+I5k3UvB0iTtRXbmjfEDiIdH8Q4giXqz77NR7yetXNGbKy3nfGnXjl6OJ4wjEKxKZPWsX8016/2AZ5ef2AWcUN2kuFB4dqf841FAYoyr4ygqaO56uC39ABQ1yHmRTiRzaVHsrcxUVrcyQoN1AdfMW2lURiCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 10:31:07AM -0700, Shakeel Butt wrote:
> On Fri, Sep 05, 2025 at 08:18:25AM -0700, Alexei Starovoitov wrote:
> > On Thu, Sep 4, 2025 at 11:20 PM Peilin Ye <yepeilin@google.com> wrote:
> > > As pointed out by Kumar, we can use bpf_mem_alloc() and friends for
> > > bpf_hrtimer and bpf_work, to skip memcg accounting.
> > 
> > This is a short term workaround that we shouldn't take.
> > Long term bpf_mem_alloc() will use kmalloc_nolock() and
> > memcg accounting that was already made to work from any context
> > except that the path of memcg_memory_event() wasn't converted.
> > 
> > Shakeel,
> > 
> > Any suggestions how memcg_memory_event()->cgroup_file_notify()
> > can be fixed?
> > Can we just trylock and skip the event?
> 
> Will !gfpflags_allow_spinning(gfp_mask) be able to detect such call
> chains? If yes, then we can change memcg_memory_event() to skip calls to
> cgroup_file_notify() if spinning is not allowed.

Thanks!  I'll try this.

Peilin Ye


