Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D06CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 23:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A191D8E011E; Fri, 24 Oct 2025 19:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0388E0112; Fri, 24 Oct 2025 19:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92CE78E011E; Fri, 24 Oct 2025 19:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD318E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:57:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31EBEBE810
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:57:33 +0000 (UTC)
X-FDA: 84034672386.05.5374248
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4E61BA000D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:57:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FZelkvxj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761350251; a=rsa-sha256;
	cv=none;
	b=8H0GOuyFYcywZdMW2ux8ZFaHeCR/5CvW43zNpddxuDzArNSZdnNACTqhzv+u839CJ1AKUo
	zOQgVZsFRpN8Okyn7Bkkci2BH5mSved7Zvo1Q903de5mThWuJhcqqMORQ1XKw0maprVZ9C
	Hwc+pqjIKfje/AoWPbueBKNouUBTVQ4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FZelkvxj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761350251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNKLlMrwd1/HZexcmyJUATq+vFaKLMO+fNIoDoZR3Os=;
	b=LG7thPYyReA4pNf/oWUJ6H+6sUY2Dl56CGUltFfJe2lktk5eJB+KcNnse5IRDBDNdjQZ/Y
	9c5p9iNWipxkn+zzHHbpnC0CFBdBkFlS9gAr9US0gJ3dV1jdm4DIGJnq3N1+pZ+sTy+3m7
	DKiZRvF11y/WSsdv8YLJbiXoBfZLVvY=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ee130237a8so1807452f8f.0
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761350250; x=1761955050; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dNKLlMrwd1/HZexcmyJUATq+vFaKLMO+fNIoDoZR3Os=;
        b=FZelkvxjlu66amJLrBLJZ5yHSc2B2s3t+CHr2AXXjRr0IlOPJxzgQbyDBMwt4+i6Lx
         IvyT8idoxqXTnmeRKX78iD9lf8mIQNQjUEpOnSA5pk7xEXtwbIPxFgjbA1PEwdN39/IF
         6FoBHgloMSfQN/CDtDIWaSNF6PAE4ATUtHskGdy/o4XbXkptzYUdjiHb6pRWW2u+JYnD
         lYxUylYOYUaX2rgHkAPztziGc7iQIpqDHjQf406CyhJ2aQKODg3nbcJCpJRFXZZaLVRv
         sUSqE/h5c2p2WraMYnbWcO/kvIAPGGWY4NDXHrQOZWLQ2PCci02e4Y5xVGB4u/oPVZsY
         9aYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761350250; x=1761955050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dNKLlMrwd1/HZexcmyJUATq+vFaKLMO+fNIoDoZR3Os=;
        b=aszKXBsC16MLs8aZNmJh9/9rlcWi+jixoLgtHPg/DspJP8RM98E4+6PCPsEfZmfe8E
         X3wVamnobosqiD1RsWdgzU3KwETn+ayOPEio/Os+m7P7Bn2RdhI6f0+V22nEGvj+NZXc
         UEm8pmTTNUCXFg3YvKZ3FHb+6J04sewy/Rn8NJAsg9YTdPUAi2PeVkcao7E6QfBf35DI
         ftORK+oBfXVir5nHotnfyyAYXMe9shqQvtmpb404gTjW6+630t7orzTIzB3qUXPxjhLi
         4RgMkqgOQ2I7e6SqzUUK4KlByWI1BOewsxi5UQG6GWQ0ZQJgtxNcnjLLe/5ooPkI3YmX
         4sKA==
X-Forwarded-Encrypted: i=1; AJvYcCUFi1DdX7geKVt2giu8JIu/g4D6oyqUxKNSXrqPWJG60TOf4Q++JVDuZcmAeiwe3GuhylJl0h1O3A==@kvack.org
X-Gm-Message-State: AOJu0Yys699pNJxeUC6iG3VF73BHYrKFPZVqeKBf5TVxV7NqwLr/oBOl
	4y64hIZMkFCCyr0pmLSWeMzPViK/IRjZQRHSqcmhy6ZpWixZpJ5LE4h/M/KzA1ljlkBm3hTaXTy
	+VU8NkuugF5G31EMJAw2BF0xbxrrxqpI=
X-Gm-Gg: ASbGncu3WPfP7j3fw0CjghJKUn5QOXgkhw7fju2f8+4B2B/gcNslUdG/3AZ0eAYiKud
	lsHADmyLXSBh+mov82eOqF2MgQPaholHVEQxluFnRZDUklVg27mnWr3MuaWeOdiFh3FPnKF+/Qo
	hkwrCV293MlLJxcVkZE3XLljqP1k33l9qp4CEBJqX3w8SeKY96/E6/uX3qG/rLEB8+f7DD+/+8c
	cCaXlO1ditWIVv4a4DiGnkGyItjXTzjqscmL9gDMDcK9RqwuYthPH3Tj49BNvhmWHUHkJG8boE3
	HP1aeHj/Jt0oyJsxY+nAKK6XW/i7
X-Google-Smtp-Source: AGHT+IF8HoLxCsbxFn0Q05QHNEFaH5LN/KgcQUuwi/NFCX+hm+nzFT1ZjELINl1AgyfVOFTyiPf1ZTpt2LmAPKbOJ38=
X-Received: by 2002:a5d:5f55:0:b0:427:5ed:296d with SMTP id
 ffacd0b85a97d-42990712615mr3163617f8f.28.1761350249591; Fri, 24 Oct 2025
 16:57:29 -0700 (PDT)
MIME-Version: 1.0
References: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
In-Reply-To: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Fri, 24 Oct 2025 16:57:18 -0700
X-Gm-Features: AWmQ_bltQWl9Zt65mlT3O0wfqqWroGd-22lI3adDJdCXk0hQ4ymeHmC7hV8Eb1Q
Message-ID: <CAADnVQKYDgwgAQ+geFrY=xDxNoe2YuEYVQU+d3V3nMhkMBg1zw@mail.gmail.com>
Subject: Re: [PATCH RFC 00/19] slab: replace cpu (partial) slabs with sheaves
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	LKML <linux-kernel@vger.kernel.org>, linux-rt-devel@lists.linux.dev, 
	bpf <bpf@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4E61BA000D
X-Stat-Signature: 8157kuipdt7kfakihc7miwucw5ky6b8x
X-HE-Tag: 1761350251-517007
X-HE-Meta: U2FsdGVkX19CnJp3IMPPXK+cn4cdMI6CCC1efH3VhOeMDt+kquZT7O+PhnDI0pvNX65oXJpNvIQCUztS5xvsca9fi54N4C98OFPJc8DMGdNOej13zXrONIlZVvZywzrWwFzYWQ2LcZYdLjolFq2+mQnY6HjyiU0prnJiSmG/V8m0vZ02Mm+eHSzC9fJVvFCow0l3max92QrVTihe2ceF+cMeRIuPX8qX0zY06NV3Re7qMkjarojD6dUDKiyAuIM5EOfgMMKmk1SX10uPrIL1XUCgtq1nBmpNvsJ1vLNQ6klArm5X8VeBdKLNliT0KE2EEWMUPxoFTCOZoYtNFgwswR1XOWlSLFazNJu0myFGYp0AFNLeRm50CJc01EwLy4ogTdTGvLCYBNLtc5ibq7Q/ViQdAfyyMfzO5r3QHnrvSfhAVODSdabp0P1mhutlNNMnyZkHGmDBNcWT32D3NjOFmkw3BeSxEHRt1SalSYdSoh42fxlKGFlhapZkivNixaJq9bDR8xTllTkeECx+8AvBxYvhUlM9qKjBmW7MmEHiKvDXG8N5Tg5KZalp5zHnrcDMqHKqkUnNhBSZFo6XcGnLiBRS2Jb9DxELTRqal8XBTp8+KVJoryk086JFULuqi9Y594HoOSiS0xK0sukO4YOFRFIjifrXJrzqq8eM8rvJpF8IQsHdcV8QxbccPkgtUqiIUn+G6EP1MyJCykIC1KpenLLrZTi08V9fdACF6NwfEI5Cpo79CCBQsYVc5NQZYNvo6+N8C/ECVidURROtdJ0oVGv+J2SxsXLLXhOywlO7fZfJGWiaF1d/warWfURsMQs0wdhrAMAtAodid719Z+DiRFOQt9iQU4gQKEe1AjZMCW2zc091LqW+yJinHljJ/ecjgZgVvdcbhLr+laC24smX0kJLDK5bsxA3GqwLmtUokdF589dpA5KZjAhUH31ZDNRCpvx2QGi5PW1THHPyC7D
 +eeFyzV3
 FPyd8z96X49+VFoy23cVYKB4n9MIEohRuHnn/ssyTxuxE5HZcTJIDJlHXFVN0/EIBBpOluQhpQVl+tUXC+enBoFIL+E29s5+NVV62wAUAUpW1d5Qkck6ZUz0reBODcEkFiNWWGK1NHOmp+Nwdi19wY/JspiAnazYyRGmtKqbOUz5IeXlMHenSRGK9/5WNLA3XXjx0o9aQ1Zj5tqqyZzMIZ6WG0n3K/qMrhPVjqtkSfXrPCWH90xk7j6Nc0vy02pKj4onqYML3R5d99hk0wxR+gUAP+Nq+JxZ7a9cMWFqC3KMn0LNK8RDx17oH0zU2B4jF6hruPaldd45itpO/gXaMIKi05oRGtQcONYkHhzGG7bu5WlEONOpMz0PZa5vp+ETYdfc9RLiiNhz27uc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 6:53=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Percpu sheaves caching was introduced as opt-in but the goal was to
> eventually move all caches to them. This is the next step, enabling
> sheaves for all caches (except the two bootstrap ones) and then removing
> the per cpu (partial) slabs and lots of associated code.
>
> Besides (hopefully) improved performance, this removes the rather
> complicated code related to the lockless fastpaths (using
> this_cpu_try_cmpxchg128/64) and its complications with PREEMPT_RT or
> kmalloc_nolock().
>
> The lockless slab freelist+counters update operation using
> try_cmpxchg128/64 remains and is crucial for freeing remote NUMA objects
> without repeating the "alien" array flushing of SLUB, and to allow
> flushing objects from sheaves to slabs mostly without the node
> list_lock.
>
> This is the first RFC to get feedback. Biggest TODOs are:
>
> - cleanup of stat counters to fit the new scheme
> - integration of rcu sheaves handling with kfree_rcu batching

The whole thing looks good, and imo these two are lower priority.

> - performance evaluation

The performance results will be the key.
What kind of benchmarks do you have in mind?

