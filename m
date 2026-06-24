Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D58CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 16:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F686B0088; Wed, 24 Jun 2026 12:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6946B008A; Wed, 24 Jun 2026 12:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20EED6B008C; Wed, 24 Jun 2026 12:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E98AB6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 12:30:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 561CC167301
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:30:13 +0000 (UTC)
X-FDA: 84915343506.10.AD90E07
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf02.hostedemail.com (Postfix) with ESMTP id 71DBE8000F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:30:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jqtuMaOL;
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782318611;
	b=eaXGGNRmA8NNKNlgpggqNoTd1BVdSk2yWjlwHaYXDF/XF0RbEg9Xzln4/QB7vSgDlHeA+R
	huNuSn/BqNWro4QU797fLpfPP2AzfuPSCWMuAiyA50KLt/9hhOJr0/Y9jQdedDM5Nx6q7V
	FNatd7sd2ISXGVPwF0xYy++iOYhed5c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782318611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4Q5tTzUw3dIHq5IKDitX92kWGt0Qu9vdWkJH7Q35Jk=;
	b=ud4OdHv/5IDbF3FGSJ3rglQzDsF3lLpeWW38OMDJtKAcH/ywWAJA9OcgABoKfUfWd40be6
	SU5ps8q6zJaCjeKH58aMdG++kBiz3Wy2ALt13ID9taIg4GIqE+ogg1Is9ValPyzDYl2fkO
	fqZ1JhyyaTTTk2rWgGZ1j++DB6YmNU8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jqtuMaOL;
	spf=pass (imf02.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-69e46524711so879904eaf.0
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782318610; x=1782923410; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f4Q5tTzUw3dIHq5IKDitX92kWGt0Qu9vdWkJH7Q35Jk=;
        b=jqtuMaOLKKAIKG4YhhX6+GbvUZ41x7wcq1Z582SNOhxw/f4R2WYUrSVZivrdDQsFKK
         pVhqzc5nwEVj2Sa+P6ykT1tl6XHpzBaBDX0TVSoIvGhiCSAGAOeUY5a8vfzHlNXr4Qso
         mdfTn0XaCay95rxNE8WbKgCBKeiQkTfezrpTHXAFlu31RRQvsqR6w4mdbealwitu390r
         h2Qt6QMTxfM/Rqh4T9zj1/WYKJ27sYz45m00YUe8oIIMq2uMOjG+Vq6mZEdUoao8c2Ko
         Utv9fEQeN4h9Iws6rbp2Ssj9ke4f02Hre/TykDUjYZHExM7e9/kC0N3S1EcKfCpJ4f4Q
         SZFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782318610; x=1782923410;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f4Q5tTzUw3dIHq5IKDitX92kWGt0Qu9vdWkJH7Q35Jk=;
        b=EymNHs8vLhpo5lq+paAH2sPTJe6zVY7K2qqr9P3JJVqCzUQlNqmJt7bn+rDkUShAZO
         Vf1Vrcco0+bRbCrbAXvQjmRf22yHSDTeChXQ5XhIIeLkD7tSoFKQQ+Nt2k/M36M2Jt02
         YuxJ1IIpwARcevV995cvFbWS2Xgj7O6y6oOj7zUiUrU0Buno125rfcGGKTOwKtvKIH5k
         PeZgKDdl9Qft2SBrZovSA07lpgLKoa6gaBrczqbucKkRT9rNi3DHfhWM5IdLUkPYlJ2r
         FuXk77ETOWVzqTdclCbOqvHW6mHxaU0G0L6a6L3J8qapDO0ArIRPKfMDqBf7roMNb1O7
         l37w==
X-Forwarded-Encrypted: i=1; AFNElJ8ta1Ka3OQQbVzuXBliekaKb3pPdufq+K4DwzmTWenMrWLRK0k9/5kZDqQYaUQA6uj1n6s4ayH7TA==@kvack.org
X-Gm-Message-State: AOJu0YwHjEHevHuT9xMor3AVwFKP06GpbgDRQqVlt9Wjld2SM3gLJqkE
	D6SY9pNyuCL/pv82HJrIcgcYv0z9Cmi7MXRmXk7K3L44O0raLXdEIcZI
X-Gm-Gg: AfdE7ckpib9gt+x3FjkrV5Dsk0b+rI4xmSJFp6CA4+p607ypNX0eG2NR9O6zZwRILsU
	dVdyMc5wr5/ejG9J2GYJvKZTuc7ndQVqvyfWVAH1fMTeuMg9XVjED/cWa0fNLcxGE3896LDd+yh
	PBos4wionfH3Q1vpEb6wRfyeFTkMKYRDrP9tyqG43NG/2PzmWraekogswdqg+QvAC2N4K3J3f+k
	daPu0AZsK0NKrV2KG5ybWuBYAvp5CgwcTKh5/S0TXXwR+oPWdS/hSVlLbxOpcrGgsSd0ZGAoqoJ
	+LdZc3tZNs5V4wWlOvXP+tG809c6K/UCy6phUcWy15bTrB9x2iheOmva3C/Ww3Gpnomqk59gegD
	SCLVa/qSimUfqznSrmJ1/BMzySanyp13t4OSddrpuUue5NS6iFU8rCvfbILOcx1DIJBx7fxSZ/k
	NG5oBDSdBuZ7AlAalKagEVfRVC//vG6wqueN6aGgZgSU469tjD7x4zBF5OTsr1CJ1HFyQZywWVS
	BqwXnA=
X-Received: by 2002:a05:6820:906:b0:696:1e45:9011 with SMTP id 006d021491bc7-6a1231f9adbmr2366325eaf.28.1782318610157;
        Wed, 24 Jun 2026 09:30:10 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6a0e9faf29asm9654118eaf.8.2026.06.24.09.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 09:30:08 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 24 Jun 2026 09:30:05 -0700
Message-Id: <DJHF7S039QNX.KNVMFISSMLMU@gmail.com>
Subject: Re: [PATCH RFC 0/4] memcg,slab: kmalloc_nolock() fixes
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Harry Yoo (Oracle)" <harry@kernel.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Muchun Song" <muchun.song@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Hao
 Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Alexei Starovoitov" <ast@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>
Cc: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
X-Mailer: aerc
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
In-Reply-To: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 71DBE8000F
X-Stat-Signature: zuy8ffocqw6mrnddbuo7zfwxqoxs6s18
X-HE-Tag: 1782318611-106414
X-HE-Meta: U2FsdGVkX1+OOFMMP+KhocjhhGm7OjFsKsiw7aDjZaDp9+/ML6WXc6gghbCdDXXKWQpcSuJUsOeS6AHmitT6BO/Q8NdUKNYzQuGXjjy0hsL4x48GqMTQmUfnFKLtYs3FNx+oMm4HQq3N2qpbZeG2PVHL7xyER3PBbBw26ZDX8Xg0xDdQenWDSNYyWH0rjCVFmg5+BUT3Z2E62PNwixeoGSTsbV6nY58bKKI1ntiKHq8kDMHJrjp0HlaEitdv2wpBWTXoLUGrgSwLXwxFSGmr2PH3cukuS46FKxlh0viPpopEFbI0tSTGiP5xx/WLbti2UQw+TUX9LUlh62U5af6rDJYLK3LTZnZlh2B5l+sLe7xmBhTssQvU+0S4NAy9H6kccOuP+vKtKji1xr8jokyiDxQqsu/NgeO2nSU75y1g780FfMr1LlEjBH09Yl+FJVi5QdZBiWhSnL5K3Ai78WGX9rkd1hG9QeFu9FI4zjeEazP7+lsJBkBHqr1d2eoivYzbchu9Xd+vI74bsL1ZoCYhjE367YPSxNT7YHwS+LNyz5XV8zlO2tbPutVG3axefBCSEKgyxsJl7Px+kdgMLcidQZiPuvVJDX7Imw9LREqfTcOR1X3XzuNqOAIQl4S4GVWdGaKdaKqE+PXgtPQJR7oODbCBfLtEZTy7rFT5iDJxwG2XK1yUHd0XTCwtJiWLm3SrdzZ+v4ONnHu6f5g46Mbe3hhKnwHhBUliz91Wc/Onk/hLx9vGXYMzlCrTyIdd6CnrSAqkuoA9+zbH8SFHgiozwmfoeDQ2AVVDtHe1RIR6/RZxPEnA4MUsda4SgNBSdNB9GpPcKzm/CZLhqcnge3wtaf2Q9NUkUo+F2qV1ptdH9KlrjXfESNcqhTYtfAm2cJpPKHTUGvRn/XKzJT4WYrxQTRZv5FzaHWJKXc9fK9ohlsBWjoD+8o3J9h1N5vINWRxJ6+zq0Cpta2S1e1AwueW
 tgVizJ4x
 QgDrkqc6LI4wMpTu/as259/+YrpSX0r2jSyhe2+fp//DprUhUY6343Hc5b6eZu2HWNEz+SwhHKNzsZ9yW1YTCNj+rvPJxaINPttyFNsCJDNopTTEg8/qqWFNmMl4kdWohgqCh+HW2WVRdG4OMAhaBASag6APqiPjGGZ9IBVqJxhDYcMKEiE7D+F4+cmCDjJ/RH3IMT/3gCa/pgh7/nehijc7/YTJo82b+F31T7osVgixFfQYxz6p/ljJFhj/AsBxPpPRSgdy5MlZDejs1AZN453GS1AzCqEEMgn/HEyYXsJmmYNRIt3L4hH//Aih+l6IZxKgD/fy1MJ/qhMs3ELWrjz+BocgvkF0b4v5Vl4KQdjnhbpG2ChpavrXwVQSIewYC+XceDBZqa14U/8SluuJPO9njsmQzYsinLUBvXCneQFvU64hUESOlTfHhzAC64BlIff4ZqXd4SsFB3qLo+MnIWT/taWEhzYHVLDO6wejW9PgBLye5rbD32a7TDHSxIv3OmzosolqQ/sEENkdsUMO7nDqRInnhMn+510t4rckmmHzz0k5EyfbRYT2cpcOHzkgEmH9cEysDu+QW161n90DcMjlHB8WXYRzr5lFZIkOMJOWnDK0cqp4iLhNZ+iNcSP2o8x+T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jun 24, 2026 at 6:11 AM PDT, Harry Yoo (Oracle) wrote:
>
> Bug 1 was reported by lockdep, and bugs 2 [2] and 3 [3] were
> reported by Sashiko.

... and in fixes for sashiko complains sashiko finds more issues.
I don't think it will ever end. I suggest to fix realistic scenarios
instead of one out of billion cases that sashiko think is plausible
but will never be hit in reality. The chance of server crashing
due to cosmic rays are higher than such bugs. Hence do not fix them.

> To BPF folks: do we need to backport kmalloc_nolock() support
> for architectures without __CMPXCHG_DOUBLE to v6.18?

nope.

> There are still few users in v6.18, but I can't tell whether it is
> necessary to backport it to v6.18 (hopefully not as urgent as other
> bugfixes).

imo none of these 'fixes' are necessary. Humans are not hitting them.


