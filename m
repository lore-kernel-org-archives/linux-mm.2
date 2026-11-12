Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3CBD606A883
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 06:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=uH44zN5a
Received: by kanga.kvack.org (Postfix)
	id B37AF6B00EF; Thu, 12 Nov 2026 01:18:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8A86B05B0; Thu, 12 Nov 2026 01:18:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7616B05B7; Thu, 12 Nov 2026 01:18:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 768EF6B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:18:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01C3D1204E8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:18:34 +0000 (UTC)
X-FDA: 85425462990.14.9477759
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0BDEA40003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:18:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uH44zN5a;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794464313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frWgCQavZg1gYLROomjbuAoHzdPP/chBAMQ9opw+pCg=;
	b=dz6gEBM0nsXcx9ZKe1F2XZz8TD009DYPZNPV1BrGhmLw1+BZ4/UpXX3YIISvZ+5bwP7x1h
	OaCCRae4DXm6/9Kpv3nEIbhjRxhMuKA4vwmdoyBRT816jniqgOjXaJeZcKXMWUIp+qcXvS
	EJwidAyS/MOk4m8OS3uUM4BA05rMYsI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uH44zN5a;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794464313;
	b=rxZrQe1m9su+HzO5z8vPfaIeNIGUEaQPKaeGOKYBNDhAqe3UXmZXu1b2myLmLqgQSwn95C
	Xg27qyLVUIhTkP7GD2fbpaACQ5R6x5cNgIgDnvtApmMBnOkmyG9dRs8lg3Yt8+9Fex9tgs
	NSDIUhsP9Zk7Z9xVmYOC6tg/I6A+c+U=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-53397554beaso36829141cf.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794464312; x=1795069112; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=frWgCQavZg1gYLROomjbuAoHzdPP/chBAMQ9opw+pCg=;
        b=uH44zN5aH4Narzj2jLNkJbmJBPLXUZahFItUcSUm1ACcPM63UvDEj+bjDImfLAOTpI
         dS8R6EyTHkVaKV2QnpQUarAT78PYM1RmSsiA1ZVj8bx+cPm2qctEE2GnExzkbltBjaEh
         L8qIYBd7thtelFlaZt2sCc+o/V5FYITxi/A+oHqcfvsNVLizJ3f444a1YByQdbP1V6eo
         yIoYSzzUswGrsN+wT5O5FVrNKuam+9qEwO4AUZ6HWjZu8KZbDBq9B2YPGpMBxLk6/NFZ
         n61xO1DqbU3pmN77lIAcsK1ST2prSsTaQvmDHBVs0dXDznQuM9J2XoSvqOB/RqlXQx7+
         tdFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794464312; x=1795069112;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=frWgCQavZg1gYLROomjbuAoHzdPP/chBAMQ9opw+pCg=;
        b=yDr0E65jVYd11UAbblKCQMeW6edrClG0ZLK4L3fI5Go68W5cM13Uwnw01YFg9Ek2xQ
         Oj/KWPqStYBWQRbeRRxpN7jw98xoOYgDHKYcd5w52EnHV9BpmrHBob7PwElRxn8ZsZst
         Xdyl5nWgmeS89aRbp12HhzmIv7N5O9rMiZhgKtc3ABJziwvvIHw08qSvH7fWGt5vuwGk
         SiFdm0b8F8hwnG3HNJ15qEZDhYAeO235j3ft8PU54Ewi0wjqzX1MxnCZAuUSNAKLsuWs
         M6TCwiqHmh3PPhd+/N12djKiCrvrWs5ueVlUzw3v3fibnR6hj5+jdPTpdr5CT0oeepmr
         DMqw==
X-Forwarded-Encrypted: i=1; AL+hErE6R52aM8PTS6gJwqz+BKIBt2VjTrzlMA/kHG5bY/UKVf6S5lUjv1WFVbM6KRaiH2IeVG8KBOy1Ow==@kvack.org
X-Gm-Message-State: APuU4Z/7FKv3uxBjBhb5DXJ+LECZti1/EHPXTchbsTSVSW+Xns9WvDDp
	sUn8nda6M6+/dZjkN+47SHj95iYTfzHDHO7RN8MNkuH4Qqrs8hSI6Cb5A72yG1tiFv8=
X-Gm-Gg: AYBFou35W2BMVIyOnFlCJH0l4mQh9uVRsB8Bo51+fP7oeW9cisMg479Nv60kEIyv3dN
	p+WELK0ecix8JAkB4+JJ8HABT5+a7srTDppABrDYSUAz/kaUfT0IGO9v7KIoCfEVjmq5j3iX0qM
	SllzLQwhV0eZlVj6pVy3yHRx2KykNCh1nt3JGuIayo9NTx22UVgzZv54zJzbSryEbIDD3XAFzk5
	yOZW5AILCaD8HBl9qVlqKX4ZmdU6xk4howEffU+ay23RlEffG3P7xZV9WUxMG1NWjiitdgtyP+R
	Spxo6uSGOqYtmg82kGl17X3sf5WPnAZw1nPESlTpTLhB/37IoqInJ7PE5VQdFUK7ngyqSiDtxMy
	9zzwWkDpbytcFGTiKnM/tONVST/cEfjnn/RokaFhFGHx1/eId5gqMIwGOzcVkV6+8OYVjf560Wb
	9QI+1GQNOWYIBi7PDL7ZUHNBuGgtDXmBcrK7fddos3CPetgHcYUgyZADw9uXxlP5qrvduhFqb5q
	8/tfeO3A3ZMJYtTsNcuy8aVWOPf9H1sh2vLcxrdunNzL+/VNpCEVqajRnSCzGSCTzBpNTBCa9HC
	hphjX41odDyQgnm4xav7CETkIxrjFPZLGxXc5SCLZqLBjsc/XNihFOqPszRvUUQN1Ysmn3Urj6l
	uPEJO2Jg=
X-Received: by 2002:a05:622a:1b10:b0:545:bab0:e666 with SMTP id d75a77b69052e-556c196316bmr78478321cf.70.1794464312165;
        Wed, 11 Nov 2026 22:18:32 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f0177ce21sm42181036d6.6.2026.11.11.22.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 22:18:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Gregory Price <gourry@gourry.net>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
References: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
Date: Thu, 12 Nov 2026 01:18:30 -0500
Message-Id: <179446431092.482102.12227242887844422381.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 8edhbc8w3yqfrsiqrpejp3y516id6ri7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0BDEA40003
X-HE-Tag: 1794464312-21214
X-HE-Meta: U2FsdGVkX1+ZIsw/t3Nkw6E256+dblJ7Vd/Rq4klwXifvPQZDHx5YaToat8MLmj/VY4FdNPsdWUvoLb6+6J2OsfpUN4Vr8tLfts/91uMkBNIIptvP5ErKw3TIftE65q1yF8f7nn6CsHeqBwA/KdXvfqOdG77XF25bNei0YCcUb6CldnMnMOWGcyUJIW+Ei4BOn0AtT0I7ph50YXZcMlUSvwdALYd29D5RmHY9jqvH1+qmtH3i2Yj3T9MFR8mZ9xGvVFicAhId/BJb2jqCCMyPvw3WbJNQCP7oZlJnfEe8cxfVhxyn8ZE0aReIdK+O7qUdELhmBWUjpkcsP1DTmAevXrCD5IA2Sy5N3UfJnIqGx2JGl1mWTUaMdkcwHgGD/+bpRHZaWiE6BJCLN/+26H2TX8IZ/qXoOMXcqfmrinWIG1+gI+n9lrz1rw3JAYEME+Ld5YP+lbAjwXgnImOlB1pN+Ye8cbDiRi/3lHtldXclZ3Oiim7Z4M2DPZ49coXVhoENVeP7niaGAqrz0e+o8kwPFkOIxyWA3Xg4xMUlj3YculgZ9mLouShMczqeKAGD0Yp7s5z8d9o1uhUUOzmozmODyr8mQEOgGZLFm3pvIcwI37dMYADPfopSeG43PgYVtFZqnOtRSUAx5DRqDesE7VL/bRR4d59uqAnps7EEOe4FRem1L26+xG8L+emjYKQMk5CbaQWLFIhsXHtF6+fAb7dvQGpRo2dSqFdevm9gGGrbUnVUe5+P94KyLUxlGLI8jFGMSnQiEOg6J5Au1I8toZNYz4Rp70N5c6MgM17xOYkdxm7NlSPPNEbqZ6R3bJyAM8lxvS5YGjeTw4ArOQfFWzx5HI34mSUcMzr3JKkFaDbIqSekI/rhJhwolZggl89cctL9v/YrvLVKj1fkopzRgKwtxlS+W3tCgoe/4TXK5Ml8lxuefNFi08Vi84xwJj3OIjjZmjwq77h4gI2cbGMrJK
 3oz8jLQ8
 To3/y4whpGvIRFzaeUUBqLjxj1PU2136oCxacrsANriSs7KQgs7cNXqGstqoU17+oRvnBGVRssJbMKsrBHqLANB3IYnWIESonlDQV3+RD3XAhudBVw8VN1R1I/bhQBfG5meLVMMuLSqHF3N5FQ1/+bF9oG3X569MwDfSBmMpaFR3A3Vc1n6Jnfeoayf2DfruDeJburSYgcmDn8OwG/jxUw219q3Emc3z1tGcpUcXDNbkP6hEN0GvI574as8uLKkXsG6dvRG54OSHRO6QnJksGgUv0iXWZ5AP/Bws519D69OWLzDzGXS4dW04vLm1nBRpC5VekNyywt9MLEZgUBjg8TqKhRWUX5/FYnwRc6ThufM/ks7Akg7FraY0lAQtU5wQthqswFtCQMcNOnYczf/o+EgT9jQKCUhjYjZire5ztCihiXk8x4KvFE8u9yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-10 14:44 -0800, Joshua Hahn wrote:
> Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> NUMA restrictions") makes get_page_from_freelist() skip any node with an
> active kswapd on the first pass through the zonelist, so unrestricted
> allocations don't immediately consume the memory kswapd is freeing.
> 
> But kswapd is also woken for high-order requests. With THP defrag set to
> defer, each THP fault that fails on a fragmented node wakes kswapd at
> PMD order. kswapd reclaims a batch, wakes kcompactd, and sleeps until
> the next failed fault, so it stays awake much of the time even on a node
> with plenty of free order-0 memory. This means those order-0 allocations
> get directed elsewhere.
> 
> This was observed on some Meta production workloads running on 2-NUMA
> systems, where processes with a preference for node0 allocations
> continuously allocated order-0 pages on node1, despite node0 having
> hundreds of GB of free memory.
> 
> Only skip a zone with an active kswapd if it is also below kswapd's
> target watermark.
>

I feel this commit message could have been simplified further.
Brevity is the soul of wit.

  patch (details) skips any node with kswapd running - assuming that
  this means memory is low, but kswapd is woken for other reasons (e.g.
  order-N allocation failures).

  This results in fallback allocations under X conditions, which leads
  to xyz performance isues.

  Only skip nodes with kswap running if the node is under the relevant
  low-memory watermark.

  (test details)


Otherwise this looks good to me.  Looking forward to the watermark
cleanup afterwards - i agree the change here is a bit ugly, but
probably preferable for the backport.

Acked-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


