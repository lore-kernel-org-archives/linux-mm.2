Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D02CD7789C
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 18:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7346B052E; Fri, 23 Jan 2026 13:17:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991A56B0530; Fri, 23 Jan 2026 13:17:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875CA6B0531; Fri, 23 Jan 2026 13:17:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7175C6B052E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 13:17:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 306D5B6612
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:17:53 +0000 (UTC)
X-FDA: 84364037226.14.FF6BA42
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1C3A540016
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 18:17:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MxarTmbn;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769192271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Njop685CDtDYAHuiepzZeOimPgVGEih4T1bD9GMBYQ=;
	b=Vws+4W0UOTzUjMkSy1PEveuOy/837Aiq86AYWi0wX6mnbFwIjXcxdsyFtieYpD0Lm9u1mT
	RtU6WupVeji3jWdDl48OLFS4n2XjqzTfyMlkz5Xtblr6L8PfE6NIZ1KhUBXcoWpecMkj3a
	huEzm6i8KoaxKsBXPTJPPssx4UJPXg8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MxarTmbn;
	spf=pass (imf27.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769192271; a=rsa-sha256;
	cv=pass;
	b=igJknTUGehgLXRHyaqDPlMLSOB3te3Q8IYzWw4T+IsE/rRlxuLRge5clvDP0NbKicR47qX
	p5D4vaULycj9SOsJ5TBNGkK33Jzes9cD+oY5T8lstikZp0qCu+cOWS0tzB6eSXgQjyzZ3b
	6kKYGNNZVznHyEXJvPsBtmN1o+IIeGA=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so29392815e9.1
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:17:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769192270; cv=none;
        d=google.com; s=arc-20240605;
        b=bUHeI4eOXINSEkYRp/xrd+tmCualAC494lA5K4gd0nCI2GnifTyde4FUjLyO231d5+
         Voqj1PDVhqMP1CQ1LgEWquMbtFTqWzP6krv1sROsTEv6Po9jrMVGWemRykcmbo7LH8Zv
         0X82jPM1vH7NG6CaP/5OuXQ/C27+f6oazminooDceYFh43rjkb2hbHIGu7PfvCw5VVru
         1Fq/zz1CvW+Stx0SdJqtflvc5jTpCPTxH4WyuCLN+nre9JvEuq9HJUiC5tes11mKlcDm
         Gr+g1fembVH7PRVIGeINqzEZBGy7JKh++4W6KOsybOu0UDMeIxFiz2ZsGQWN3tPWqGWv
         MZtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8Njop685CDtDYAHuiepzZeOimPgVGEih4T1bD9GMBYQ=;
        fh=cd2MIP7ELmZz4rDfhxgqR72SQhvh+eccviZJ5UOoz8E=;
        b=AhLckVPBRMvnhrrcXfSpbnCvMVLoVUvrKpahJkeUun2462qsmr26jtUtHPIJJY0HBQ
         fqqRXd9WumYmkgThUpXarEnvOQzF7wE2Lyq9eLFOK2o4fc0gzXk+IUkrUif/cHFnAY7C
         rNrSvXH7TsyMvxABv/71CGRVo72Ss4vNadUsUDvn5m/S6IbSS+I31xY8HRLEVorKyRe2
         GljwtFKfUb/WCzUk79t3qLOeUQNtzpO0/q2NHyzG3643y/Bf7+AA9x6o4UmwXl8o5rQD
         mpD8d9jS0nJRmrGOXiEXpFTSPyHBChR+KrFmHN+IfyjOyXrs1wXr1yGZPAwWLCK5Fqlw
         RP4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769192270; x=1769797070; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Njop685CDtDYAHuiepzZeOimPgVGEih4T1bD9GMBYQ=;
        b=MxarTmbnEVEoqwOxJpB8r+8uA749Hu/5DCBHlAQUj3HnjNeV5e6ziWpus/WNEKen//
         yCgYYpRByXBYBUN/CFl718E7FC9T7IGUFxBPAK8OCihmGhvYIfEB3VtSw8En2+tq75I0
         8rCNXa71VCXHwrvyuU02G7NyBNGhsDwByAZC0JWgf7ortVL5r7ZK45E/d/Za393X/mT/
         9CKQYpp1Ae6HafVTBrGvxrbqJ48RttV21RbI/Z/VbARGZ3WEALPFwvHeGwMv5vj1gb0e
         3WyPmWUITlHoZm3XoL+8K6LiTXm2N1Cm+fJrBe8sZklcoB2e6MtBVc2C75ZfCGmJ6bw/
         5eFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769192270; x=1769797070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8Njop685CDtDYAHuiepzZeOimPgVGEih4T1bD9GMBYQ=;
        b=PfSnlYPqk0wUJgixFaRtWLmfOIODB3kshxIsWU6M/v6tpv+dZdTzyP2vlJrf/ESrT5
         o+1XtpTfYykN/eaj5llV19jnA94jWNmcCWRDC3Pv2vv/cxWgz8v/cDz3b7hKXOd4pdDK
         0gpTEp3iZd+MkEmo4sCvFtSL6+Ln8ZjqUvP1gQdXKSECpmFxsKQrt/X3PiGyTlYes6Pp
         254tyXpDoFy4yweVQ8nD6JVM0gERbHZsiil8JD7dhIPFlzdWczLpmh81Nn5Hyqiyv10p
         eRFpmBER7SYs1/SSKPGORnhs/Tf8UPvHVp5mu7q670Q8eq0uitrAkVfPJF/lVL3YKQ9S
         qoUA==
X-Forwarded-Encrypted: i=1; AJvYcCUVbnpZnkVICNnDlftul+740DEArjq2NhnkGBLlyjc9uMZLgGfH/rQ1jrVg5lptX9l0Xd+SO2OGSg==@kvack.org
X-Gm-Message-State: AOJu0Yx0KctZRh3qks56lnFjiW3Ca96esnLakis3Zft9k09W1+P5AhEO
	NbGbViXLtPGwG2GZelEcMucVEmibiwWjp3MgTMKfdkg2QA6lX0ydHGNQS8oFRWjPXtTruw77/Zr
	0EsSPSn3Y64+ULWJhBxChYfFfDur6Lsg=
X-Gm-Gg: AZuq6aJSRIiTL1J+vEzXjiac4WUXKhi+RJXFzIet3yANep48nvlNz65H2LbrH0zQdcs
	hjIF7VHascBJQy9pgh/PKFFie723c5HlgxenQ99b6mIaC8kuVgxoadeTpGRFWbNZy1msSxxZX21
	UGkRF3c9Gx8QgnVFtYwKtWunnjAoYow7XuZfs+09VWl756cbF1Bo0MH9/dsGIdeH3WoCibtrpxr
	c/3QQcvtuf2kYUBczI/lz3Tv7RT9tx4zDX0PTBpGEnug9fiGMXfdxlon4kMEEEk2ls5YuDgrdhy
	470qNNFkUXI/Whki62dpm7VpxVgXxjQ3vvGcWOd9ZnWn0kWA9Po7zNsjxNyy9eQ4JHPz+mP6
X-Received: by 2002:a05:6000:2dc8:b0:435:a83e:88e with SMTP id
 ffacd0b85a97d-435b1587c9bmr6392632f8f.2.1769192269543; Fri, 23 Jan 2026
 10:17:49 -0800 (PST)
MIME-Version: 1.0
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz> <20260123-sheaves-for-all-v4-11-041323d506f7@suse.cz>
In-Reply-To: <20260123-sheaves-for-all-v4-11-041323d506f7@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 23 Jan 2026 10:17:37 -0800
X-Gm-Features: AZwV_QhM-NYlnccFIjcj9RRt6cZ2UOQ2HcV0ateutcQQrobA-XAbfYILlKDwm8s
Message-ID: <CAADnVQKbuLD=gaC1W9gtXrj9VdwQCqt2f_rtYwF1Tc1RcUOjKg@mail.gmail.com>
Subject: Re: [PATCH v4 11/22] slab: remove cpu (partial) slabs usage from
 allocation paths
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	"open list:Real-time Linux (PREEMPT_RT):Keyword:PREEMPT_RT" <linux-rt-devel@lists.linux.dev>, bpf <bpf@vger.kernel.org>, 
	kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C3A540016
X-Rspamd-Server: rspam07
X-Stat-Signature: xjwk5uqt3oe55bgwsocaz4tcap68qtoe
X-HE-Tag: 1769192270-29295
X-HE-Meta: U2FsdGVkX1/F2W1ql1c2aveYXnZWRQaqd16uYpprt2m59p0dl0i+BMtDbegP1NQoK+pg/bGw3uIWEkDJkUpIAcN/gO0G6iHUd+DVz18S23HuBNbIZAiKXFjoHq0QEIAF4giabGWz2ERr4LGABinmvHlmuBnvfOVIW1mU9pffS8UNULF6BG2Cer++HxKH7bXqA1XgKTc1vNjwuor8hEKBLaZ0Nhn+NmpXZVQbigTmFLsvMicyFsCO/sB5tC6qcS0zOgLb4MCN+XEqgvaUCeO/OOCVxx/TT0vJDSGJaY0Lzsp8PpUZ4kuZ/G5p8GzSNFTDOLcQAAnZ7dMMe8NHG29J8MdmLSSbf56y8VKGT8enPp9b8xSAVZIoLv+nLn/SL5A0VyQwOXtHsrP9n5z5Gf0Om0p2KJhA31bmt6Qj6a0QYb2UyYI/ehYYKiePjwxYyrjMbQfHmaWH+ammTABcTFAytrsBtulqN0tkKNjsr15x73OyiUIwYiFynxyZ0KAGx0zdBxewztjRSNqidCC/VQjOkVnNJlr2pVnen1SCE4MA/sDleqAC0Xi674pqU4+g/9ojorxS4Zjyv1iwiDR1mO+PwU4PqG5x+xUbYw3sLpYBws6syatFo82U0nV/1/p10wA1vxcHXGqpeybVJhiU3r1lSNX/R7wLkQZfCC5JmvOMjApAPczLgFfpY0EQkcdRoT3hf6PrYAJACslTboYVksSmqE6chMunyb2C8M2K8VuACysoTRjqEMqPSEMtVloLzkLQl4O2H1ecnAK3R8xbgUDfZoe66AnP4hqNK85AZ1kRgjGv4isMlaUPo+w7lkhajMIqdKhcP9lVQU6HIlWQAr48y7zrHzpxWkpv3EOgSOS8BTuSJLZHCJPHnOiSPuBiiQ+MGSizMnpbaeQiRO6yAoTwO/asxaS/8/yPNlQ1bryhJAgW+/y/z4p57Ifxcq+nWATkCL8GjQnoHOnCdZWysJ9
 74wWqYBn
 p+EiU2JpvTywCf8q44nag60dSIzVFfhRhTkfkE1jMIoTBQa+sd4oysQV+ATA0lt8796K9q1Q0HACoVnkvmoozW0mXtt1/xzEB6AYvstM/VEazu1VazJTyoKxMhecsnvOTmn7Fy2O3aVFf3w/hS1yNNFvq90EfziP3Etx988yKEWrdFbzzzqZZMfol8m0Zn5OcZFQIKcOYfMiHrWvy7SzvKVpVkss/LFaGWVxtZGYl4oo94ZSlxkPUkcFdbcHdkk+VCLfDkuvZ4MRdlGEWn7QfbZ0O/zkkQflNNyqSJw490dR93P8x4IKh4y3F8h1ypkcmpI8+d7OjdZoG/l5aFjeYWsQGaGc/cu4UviWEtz4NLZVidobqA8H3nYDId+iag2Sfw/nMPLUr8yKK2aNVmMuH91uDvQ8SKBdiMbBUhXa4Zm6MLXeBuC9mUOBkpIrsjjmTtT0XvEk/OCl842PXIoZW78w3fxBq/XzYAY3vEkxU7AfXpU+u8l66pIcs5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 10:54=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> We now rely on sheaves as the percpu caching layer and can refill them
> directly from partial or newly allocated slabs. Start removing the cpu
> (partial) slabs code, first from allocation paths.
>
> This means that any allocation not satisfied from percpu sheaves will
> end up in ___slab_alloc(), where we remove the usage of cpu (partial)
> slabs, so it will only perform get_partial() or new_slab(). In the
> latter case we reuse alloc_from_new_slab() (when we don't use
> the debug/tiny alloc_single_from_new_slab() variant).
>
> In get_partial_node() we used to return a slab for freezing as the cpu
> slab and to refill the partial slab. Now we only want to return a single
> object and leave the slab on the list (unless it became full). We can't
> simply reuse alloc_single_from_partial() as that assumes freeing uses
> free_to_partial_list(). Instead we need to use __slab_update_freelist()
> to work properly against a racing __slab_free().
>
> To reflect the new purpose of get_partial() functions, rename them to
> get_from_partial(), get_from_partial_node(), and get_from_any_partial().
>
> The rest of the changes is removing functions that no longer have any
> callers.
>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 628 +++++++++-----------------------------------------------=
------
>  1 file changed, 87 insertions(+), 541 deletions(-)

so much simpler. love the red diff.

Acked-by: Alexei Starovoitov <ast@kernel.org>

