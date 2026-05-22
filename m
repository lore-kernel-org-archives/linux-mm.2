Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB39CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:19:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D62AA6B0096; Fri, 22 May 2026 04:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38186B0098; Fri, 22 May 2026 04:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DF86B0099; Fri, 22 May 2026 04:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B53606B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:19:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 768291407A5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:19:22 +0000 (UTC)
X-FDA: 84794356164.27.2E8A591
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id A14F81C000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:19:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="DO/eaVuH";
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779437960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQjdyFA3zMVN8xrvWkSk7MeeUm/hFE7TcsbJtkRO6lw=;
	b=4bGypVL+PgHnimWTlihFFPq6wAqzNDwB8vO0Zy2qoqPWURV7SVZ98n1sYeIokvQaI7qJds
	Ax+NmIFS8+o0G8n+c6PErkJCzHpqYplYGanLv2qnTZCD6EQEKSERFuFTFsWTrkklcpBodP
	jn7iWwZzDO3BPTeyS9kP9/ge+SNxvbo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="DO/eaVuH";
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779437960; a=rsa-sha256;
	cv=none;
	b=1n1exsZAf+4TDYUly6uNASUCdCA1K9ctIujQKj+9yBXXa69uLrNLeezIQYAzajQWqhK8A+
	2y5vOt9hS/QiW269sPOU04DNNzG0r/gs4fbsW2Wvlyj3HJlEpwAdEklOHntWVzkhks0b2r
	nNNHhdJdfe6sKlYdmINz8ywly/IWGno=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso91032185e9.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 01:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779437959; x=1780042759; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SQjdyFA3zMVN8xrvWkSk7MeeUm/hFE7TcsbJtkRO6lw=;
        b=DO/eaVuH4bX48UZWhznRYMh+xU8JPEetprMMk+9B1kLv257dtjBg5AtL8C1iyed0ZH
         scdLzJXXG/hu6ImjfUhl61ykEp8gIJSpgdiMQI8F5VMjgjgSnU47ybdA+Ytj47zbT2B1
         1CrXPZ9OHy+IwXLY+1h8IdLMHIlCmgq1VLmWr56fzNiNMHfFjzXr2leeNOzLTrXgTPAb
         GloWrYQR41bRLxsDBDCnu0E8RpecgUtcyY90nYRck6WN/xY8ADsvi1vKiwHFWPOsiyWd
         N/GwIkqDNgiMbRDhH+xQpWsmmuXWU1DAldpjdin+v5VL+g0XKSl4UlWtdV4Z+72zW4ws
         DSIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779437959; x=1780042759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQjdyFA3zMVN8xrvWkSk7MeeUm/hFE7TcsbJtkRO6lw=;
        b=sPaS0MGYqp2SVe83btU46Uvd2FJ/UlD80pGQrSr/ddymAs5spBwXIDBvsn/2a+CI4v
         zVZ/vdj2VWLFG9Z6qN9yUbK5OMCeI7VGYpK2xn6XjfkcU3upNbpxcUG7XMnuu4MCYCvp
         MTef0Z6LRJg1HMu/aOuET796o900wYDEzrUm1+ILulVdJ4pCCapI/Ov8teDmbwIZkxD1
         jyeCUa8Fo+viNTean/4DqyDXz1EsmC5VdnLK/L47/IClPzW2NyUqgVkG2MwafLJBxVyS
         Gteq2DMPSh+WCCtIQPqREbZg6U+UMN9OZsysPHDGgo4izK1wRTDE12lBpv46tZIa2dZ1
         FhLQ==
X-Forwarded-Encrypted: i=1; AFNElJ8QLDSe5p3pTygZFlgCcJRO1JHukyyn6nNtjCaWrmYV0jjctET3+Aa6HZ4fcIio3U9IfWVvt3//ag==@kvack.org
X-Gm-Message-State: AOJu0Yy4s6ozPoZOM5s+WU3lhHhZ/2EbjXRVe3FF9fAF8qBO9x3yFeTP
	jGLzd21avXbuPPIxoX7tqe2epdjytMAt8neurxhA4saZAVZccQJkNJcx
X-Gm-Gg: Acq92OHoPUfJx5P8Muh0ykWUdwQu+Uwcfseue+f8ABCMEoy9Z5L4d2/ntGSAgSGBnpf
	mbl0xE8wNgdc4hLdGAKIYPVvHMpjNbHuHbMQvuLmPVVupAfrwB6E9U4fP2XSYKvV4NcRtl66me9
	z1VL7jg7hsXNRxUbgAv8qIxn7xN3Xf00UHwiD5S+aYHPL0vZvZKcJLjbPbXVEnd8WCKGlrfo2EA
	dpfrvDF2xx+NV3jYSlXjArkvgfUGbqXlQE1zWfPQGHZa/GFnQgVvh81zngrvkjulp00D14kAGsC
	ZTujY1OJ4lg6cEfamhPNsP4yzaSZivp8RyFb86ujA9c33VG3PVBD/SQdV3ca6vg2bUpib+Q9Tmu
	WgPwiOFMyryAdSNNQxZdLqvT8Va5wrPVvNOTHhrqNs08ZRF4j8LKu1oEy2SVYPFsPKdroxz2oY+
	rZxRSGLOrUBVYdL6fWXUctHG83nr5JqNOeuC1JX8aV61J9IbPyIz8zxORD4zvY6pP+YRc95K/Xg
	M8m+GitVnaevnbbhQdg3XAFZupD1la0Cg==
X-Received: by 2002:a05:600c:530e:b0:490:18cb:e820 with SMTP id 5b1f17b1804b1-490426d1a33mr30905905e9.21.1779437958781;
        Fri, 22 May 2026 01:19:18 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49044775266sm9567105e9.33.2026.05.22.01.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 01:19:18 -0700 (PDT)
Date: Fri, 22 May 2026 09:19:16 +0100
From: Vishal Moola <vishal.moola@gmail.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: drop a misleading __always_inline
Message-ID: <ahARhHVw-NSdXjQA@fedora>
References: <20260517-b4-drop-always-inline-v1-1-97b90930e8b8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517-b4-drop-always-inline-v1-1-97b90930e8b8@google.com>
X-Stat-Signature: 9ajywbbdb4ne7zz3wjssi6rnc9s1uax8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A14F81C000B
X-HE-Tag: 1779437960-709483
X-HE-Meta: U2FsdGVkX1/DflXn6tiuTxp7g9WY/fZEYQom0DePPA31G65JEsU7Sr1coAOECMiUE/rcf7qS7YhZYwn7+NRVHW9nzez3x+vk8T0b8VEdfUoSN2Q0TdJDTEchnuh24UnJSmkiwHqApHrHfI9LcFXZodqSo1sCgWhGvAD1HyGA9uDpbaH8/kF8NSs3dxMxqpb/t6iasaNxEVOBwqi/zmMLROkAzfVVmNxSGx5alUdrq+IkMu4wEAGxsraW9p0O5u2/MrfNVvB04lK1cXrSZLCAAC4VHhg5YN3OygeecVq4JuWYrw1j2iqRctEXQN9w8y+w+JwUmmsgFJzPOheFttBsCvThHY6YCwc3bdvZyzyurhlSlp33hExuwPAbgvadCFzKde6eGiC0BGmPGH8V6S9TlqnqvT40q4D4STQ4aw5qpFuMquK9BYxFkQUGu6Qy4vBkClDen1reOl3M6h+pwld3cQ8s8t/fuHuYhjExexX5hyGdlWVEbF8hCJhYX7hmhDHrXngUdR7nzCIoMZ5LUY2zfAK3h3D8/KS6HfGX7SAutlsOb1U9jfvbPejU7WCJfezt96ePTTpbQbKjl0Z8CHWvRoY7J4zHMUQMk8fIVbTlU4/OSYC6croiysTLw+gh2eVaOflIR5wj4rM9gRrnpnC1RuYIUKyfBWHOi3RQY5iPMB37vlcCuWtvJnHYby2Y5BS/8HlimoMLDd4oN5NGYZYP32PnO75aptsTnyBkwJ3DdzMy6VofMEqGyT5xJ1h9uWDHIdURAanv5niLrkJo1DyAIbnSinaeIToii/cxJwu3GY/OocRW7bD0xseio9KvzAqbB4ipCOmFwiT+ulCFHyCTmJCuXxiJAasVNThIlRVGh9b3/YQF1oq3OhX8UkItRFkINSHBHWVQ7BFduDqguQGo1/9wqNtnRqol6jsOxkg8CCHdE9RcAk7aLS9kaRCF4IzciMnRyIdwzx0wB+lraaG
 MlbuAzUD
 LQRtY+rlCnDZkpIoWs8P0L8DaKdVbIx0nA3ptkxSO62NIxmSZvCPykM67MwtzoXpthss2Ka4zEKrIslEdSchjeem5+1QLnLCCXPx+9swdLUShSSS6vD3+o0l1cmS5JN2ReoIbhkUPGwDW2azTCL8PAzCQY99O0+4FWjx5eyy0ZlcLzWAoix6dVNAfkh+IvbTGrHjgVNQ4oKLaIJfwKogDlLyRCa+MIQvS0cMP//5+v0Kw7ss03ACyG2e5w56oochlWZ8jLQv98SDKaB3noL4r5k2e+wr/ULNj2zRGnqfq8fpHQ6Ga31OZSUNlkSDOoHz2gj0qNVg8k7b9UDxCVfGExr06gN3y8AB6JsIWEudAeEzzU+HLXY5sQW8BjgS4pNzokhLOhDlQImGDaR3BGVC6CiFdxHoJL0uG5NFapX2RATe61X8h3AoJBzv+YJJvaZVRXYr58sEU2FIVamjG1kabk8vMKHFYDE0sUdWzQWQ6/Rm694bM6FhEritDXqber4aRmxuKoM7VP6RtQ8brtC0y1ZLK3SQDJs4E8hBUQUVqT7GVB0ODqhXRQ3+2L4k0+OsknLkq2+1DSk2sJt5QU/JSjoPsxb4Dg3dZ6Fuj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 11:37:05PM +0000, Brendan Jackman wrote:
> get_pfnblock_migratetype() is called from outside page_alloc.c, so it
> cannot always be inlined. Remove the annotation to avoid misleading
> readers.
> 
> At least in my minimal config, with GCC, this doesn't change
> mm/page_alloc.o at all.
> 
> Suggested-by: Vlastimil Babka <vbabka@kernel.org>
> Link: https://lore.kernel.org/all/016c8bef-57ef-44ef-bf60-86dbfd368dcd@kernel.org/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---

Reviewed-by: Vishal Moola <vishal.moola@gmail.com>

