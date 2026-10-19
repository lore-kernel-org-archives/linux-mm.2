Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E32FF606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 22:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m0tJ+dUt
Received: by kanga.kvack.org (Postfix)
	id 4BF8B6B0105; Mon, 19 Oct 2026 18:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471B16B0108; Mon, 19 Oct 2026 18:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33EAC6B0109; Mon, 19 Oct 2026 18:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 039F46B0105
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:50:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 619421A08C0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:50:48 +0000 (UTC)
X-FDA: 85340872176.15.E65A940
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id A199A180007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:50:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0tJ+dUt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792450246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jYVSE8MO06CVSpnqlpUP2cyOZO8mgxxOpK+L9HkhQk=;
	b=V/46jmELFJyCyG9LKfT6TsRqm3SbhEi5HQCGcUMcQpVuagMiq8diTQZAorpRQuJq3wwE69
	dE4nFXzj3bwAg6DLCAJzm3t8NU6R6XluatOTHYwCrASbKBpcodgTDlDCVX6Uni9Agrpm+7
	LGVd+Mjlb9ILH7+6rwKYV6PMWP2LZF0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m0tJ+dUt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792450246;
	b=wVxjmc0V2/fGgJ4anfkTmQ5BHagfnNRgc3mm23ETwMBXG7F0S4RRGeFEOTLv3qHoDUH0pU
	fVY1vC7uCgEZFK0HkouppLyZ10ybuz86rnD54c5R4b3IkVvZE1OLwjY+9NpXT3A11PlRIQ
	xEcip93DI5FnB/7e1qeTJLuz/DoeOL4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2076C4429B;
	Mon, 19 Oct 2026 22:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815001F000C4;
	Mon, 19 Oct 2026 22:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792450245;
	bh=3jYVSE8MO06CVSpnqlpUP2cyOZO8mgxxOpK+L9HkhQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m0tJ+dUtmJdEOPoct6ILnIhgcQXfh7pFaKvWN9ULzvJ/tTI3TG+B8SU0FCO86X/8g
	 AZGPNxaTlYewm8jdNOm2nMvbwzN43NLujX2XZk9K5WvfDg+3M0WFGffrA4HyK2D2Nq
	 NQ9aDUs/evNbojIkRgOSp60JxeBZAwMi8Ud7UwgQM8hvBfdfxyyqSYRu+BSBmMdk7o
	 Ml0mNsXrZt2/DCVcrNlrx+e8RFNK6iq8sqC9YD4j15U7Kx09XHgbGakxjlTqP06TMs
	 TeyBnKb5b0ayoW9gIMA8VgMAPmDxckm5I1ffXozTIHHxWP8/TPt3MWEgjTsokYZip2
	 67R4cMPD6VVnA==
Date: Mon, 19 Oct 2026 22:50:43 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atadE_kZz45KAeuE@google.com>
References: <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au>
 <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au>
 <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
 <atMCfhB63koot230@gondor.apana.org.au>
 <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACpmpocZGHpTTOq+xa2bTnS-=gdUa8+E_KKJm41H_dSfbGikYQ@mail.gmail.com>
X-Rspamd-Queue-Id: A199A180007
X-Stat-Signature: zhgctswitktbn83pf73r8rcots1epmbq
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792450246-412853
X-HE-Meta: U2FsdGVkX19hrU9JViu9wCWy2qL5w76CLLODydM7ZmfC4yksRT0fbVmYe6j6QozYYAjU407KdVbWqLC9rrXW7winuBPVoedDfxhsQvY9KthVBAONB3pM7DPfrSceMcgShMo6rHKHtPgc0ZfT79ZwZelWstIyeHMt1b07X4ZU5u6ZspnjprVjqmU1WXb6NM3+s3ej+awiFw1KVmBTL6gd0rHD9+tRPbzoXZj77/8/437zxkDSLL0ZK6j3QltDkgJCcEKCtkvgCsmg2Cl1Rz8WE67Y/cJEDIwWv/lpVj4lgh/apKffRu/biINem8/3UNe8jONsWgi+ByL/75jaOZNk0wi/Ge9uAACoy9JaOv0uOxFs4NIK5zo9k3wy5ZdmMMDFl0Rb4H4vqmDdj46OOB98U6C0haZzNG9VD1uphZZaHfcJVDL/guL3IJ/exnDMUPJ2YVCSB/UGqynTo6jvtp0UmJ2I5Z6li/PKnYoUg3GktEfn6jCF+YeuqgDioe6SyTdjxgs3SXlh87wgpEZAjrtT2jnP6iKLcZJffo/cP0DpAxuyYOncNy2U3nsHttDki1EU8qD0vRALReHAFBluy/0MCb5tY0lbAbTKbRo8rNrtAXmg2suW7hITdnaq8Mshhqx75GZ1evRx8MPJANjfex0ur8OJZAHuGCeQ0lMn6xRXtGca6dDaML0AT+N8SBhVQPnpj2K2DmxBiA8gFZsxvWlv/ao0jyK1Kx2K5BQnOzcAoDLBcPLzRTIAl5dsiS8adkZfk1liM30e08dCTkUkvD2oMk/Qfc3qtgPLmPxvlWVPKZQpYFzvd0kfyiVaePGlXPoxUaRtWoYgCT44kSPSiqBqRRT5zf7DVVnCmiQC0vac+7Sxfx++8yN+ybJTlHJZjrDyBgM4FF1c+H8ZpiisJO7Md317aZLBikSoNp3CBTuvrjhR/+n6Uhpijxfvd+QKbaV+0AbsLJYG1NI3FKtGl9f
 E2QAvnkf
 ZQRK/sWpbeo77qZl7S7pR8Ou06DiN9FTFTxkjDvakDBN/xW6OqOz9eFKBfukSrx5zDHIfaO7dB7exWZ01leRlWJ1Z5KbpCbJtLSX8ttu1OBwihwpfo7aoO/i59hcps2TKqkaHWKKYdLUTUHyWGu7mkVZdCI5LwXrBKx2fEaKoGJ5NN5HwbIu1cyIx5ATj6U19K7XUFUGZ5je5QngJGEfyP3fPk9NXz0We6vj8fL94QKLfMoIng+BlEPpZ69D511K5EoH9QUzW4kcY8JyD3396h/OYDGi/rESXI/vz7wqsABx9RZGPaRymjeQm0prFbdMxAGLtU2KBb139QDEQh9v0vWzS/Dj4nN6yhRNbufcke8G2rNRoTU2mvtDr+GYSLVx63j3p0rGAiwFyGFPBoyI+oIqcxEK9tFhtZ31tI5i1yNq/QAw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Oct 18, 2026 at 06:35:01PM -0700, Kanchana P. Sridhar wrote:
> On Fri, Oct 16, 2026 at 10:07 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Fri, Oct 16, 2026 at 10:02:13PM -0700, Kanchana P. Sridhar wrote:
> > [ .. ]
> >
> > That isn't quite right though.  We need to ensure that it really
> > is a singleton before taking the short-cut.  So you need at
> > least one conditional:
> >
> >         if (likely(req->unit_size == req->slen))
> >                 take short-cut
> 
> I added the check for the singleton req [2]. I hope this looks Ok.
> 
> With the latest crypto_acomp_compress(), the batch compress latency
> improves considerably:
> 
> usemem 10 iterations average throughput:
> 
>    patch 6 (store batching only): 19,119 KB/s
> patch 8 (+ compress batching): 24,076 KB/s (+25.93%)

This is exactly what I mean by the numbers varying too much to draw
any conclusions. I am not sure if it's the VM setup or the usemem test
itself, but previously it was argued that the short-circuit in
crypto_acomp_compress() was ~10% faster than the one in
acomp_do_req_chain() (20,946 vs 19,058 KB/s) due to avoiding a function
call and two conditionals, and now *adding* a conditional improves
performance by 15% (20,946 -> 24,076 KB/s)?

Moreover, for zswap with ZSTD the added check is always true: the batch
size is 1, so slen == unit_size == PAGE_SIZE for every request. The
previous version and this one execute the same code, so the 15%
difference can only be noise. With the stddev you reported (~5.4k KB/s
over 10 iterations), both differences are well within the noise.

I think something is wrong with the performance testing methodology
here. The results are self-contradicting and do not make much sense to
me. Did I miss something?

> 
> bpftrace measurement of zswap compress latency per-page:
> 
> Sequential_zswap_compress  nr_samples     p25     p50      p75
> p95       p99
> =================================================================================
> zswap_compress_ns_per_page  1,722,489  43,947  57,791   88,489
> 130,165   323,961
> 
> Batched_zswap_compress     nr_samples     p25     p50      p75
> p95       p99
> =================================================================================
> zswap_compress_ns_per_page    665,267  41,511  54,915   77,707
> 124,648   213,962
> =================================================================================
>  Latency saving (ns)                   -2,435  -2,876  -10,782
> -5,517  -109,999
> =================================================================================

I measured zswap_store() (not zswap_compress()), to get the per-folio
latency, and it didn't seem to change much beyond noise in my testing. I
also notice that the number of samples is very different between cases.


