Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACDEDC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985E16B00C6; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7CC6B00CA; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AFAA6B00CB; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45AA86B00C6
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:20:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DF271C873C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:02:39 +0000 (UTC)
X-FDA: 84984221238.07.22FE24A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 052D540006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:02:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQehlpuD;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783958557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnF2rMmUGV8L7v1RF+1L1vkaGxUAXkUdqFeLWeibpDI=;
	b=ntVpOu1qLlGt01Jx+r6VU1KArgmau2iDwshe5KSC1OUEd425qd06kZg5KVM34V4qBvITVJ
	IeRPbr+tvXwkf2ItN2FKkaOvc5MUY9EHbfDDqmkqkICpDpU7+14tFVGvMMQ3K7AgY1vp5T
	UOFU3D0srfvlYNG1eaAIQv/+zTtDpfI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bQehlpuD;
	spf=pass (imf27.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783958557;
	b=XAVbUcQLm/kKCfAXyqFDoe9rAPnvt+DDjar8gRDN6ei/X2ZOzZ2BJhw5Qy62H0DOevUmoI
	8E7OrhpSvecL3bksSkefhQvCgRSSczTqv32RqSMSM7ZOWuNyHJsRRr0WIHtcZfaVayMbAl
	La71W/5JLM2/8HUxeKydm98II9z0dE0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B74842B6B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8A51F0155C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783958556;
	bh=mnF2rMmUGV8L7v1RF+1L1vkaGxUAXkUdqFeLWeibpDI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bQehlpuD9RuPrcFuDeopOVnFYEh6hRnI2CILKAFvvQ7RV1qEXEtbrkIZoyV2ft2rH
	 E/Wqw2G4i7mej+8uW53eg8v+OQeMbeqz3XlLDGJ1eRDBIcu+EfaJE0/LHSX+Y16etO
	 +9S3kcXLXiRrEzYmMTxRUicnoW6pS33H/Cio4ywQCbiiKQzZ7OZMk0lsMzXim0PUUX
	 g9LeMsLpkbU6aiMzheXadOvTQjiI9ZAH2UXAydKSJXB+eFYgP1bbWQXHYro6QlpPLd
	 +79W1PTss5d28E2kDcycGoozH2edn8QshbVdsun1fdU13v3O5s1sECuu997537r+BX
	 GnNuSZtFSYrgg==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c15ea93028dso365700466b.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:02:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqEB8f2WK6f5ee1/7OJJvA8xw60XRZdJHbQgDrpagY5ztub5LMw7yhqDHXUlxR4gQ6Um8AmhQ1uKw==@kvack.org
X-Gm-Message-State: AOJu0Yw8LZiSzYnp7RfCnL144xJH0SDBXRSnAGizS9q2g+obyd9hRwUb
	S1EKXLdH6ZkcsbuETliCGHykK+ZBbfVUq851G/g4veMjB/yq5+x9SUqjcVjmeA3Zn8oF3Ta7zG1
	gO/O8LFzHAR/QYThBIkY2/P5okR1BhOY=
X-Received: by 2002:a17:907:f504:b0:c12:5e26:da50 with SMTP id
 a640c23a62f3a-c161f42bca2mr349764466b.65.1783958554928; Mon, 13 Jul 2026
 09:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260713133613.2707815-1-usama.arif@linux.dev> <20260713133613.2707815-5-usama.arif@linux.dev>
In-Reply-To: <20260713133613.2707815-5-usama.arif@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 13 Jul 2026 09:02:22 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNVnwAS-6jOQtGrcN_fq8C+6kRiiRX4=kp9h=fTC+XYNQ@mail.gmail.com>
X-Gm-Features: AVVi8CekHbp6MOwyNxSSAddXdK1LB04o7z4cKo3GHaSl4qxVUPWRBR6Wr6YS36Y
Message-ID: <CAO9r8zNVnwAS-6jOQtGrcN_fq8C+6kRiiRX4=kp9h=fTC+XYNQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/11] mm: zswap: add range lookup for large-folio swapin
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, 
	ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>, willy@infradead.org, 
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com, 
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	"Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com, 
	Alexandre Ghiti <alexghiti@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 052D540006
X-Stat-Signature: 39ppc6towfnzch8ukhdssejqh7wxo98x
X-HE-Tag: 1783958556-471188
X-HE-Meta: U2FsdGVkX19/uyz4hxVQkayzaJeV1s8jLe/LTGXYOwm65i/Q4FSwcOiduFgDhVDEaNPGssicwv5SWoeWYUzxBWuJBGUYPKA2Th+OVXgjq5vH1QOkTyaZuAY0CqbnoujmazGZ9ywU6v+b9XBvUD+BG8SFyk6cyFOuecitRE4yixJXFtXxxbn3QFN9hY9UibfyUYGnTFY69w3IurvvYxYwKVzghhthy4ggitIwqduyuAGvJsuLGlfY+BAnYFTtOu3jnqKPDQYMNApHgeUhb0WdAWA+bYUhFG7CJA3I9oO4cwV64WGdsbRN0TjWGMaHBYIlfBUqNODlas5sSu0+1I5uaLLBPUyRt6ElIx0IOc+jsXGgWy+ECnSdliuEAI8oK9yMzaiIx+I54QbzmssGOYys7jdUoLmhBjMBtpo/sCuarIgeinDlSlmXYz8rgc1hgBR8xmP9I1HzunzBft4QiYtkxYXk3KkWJ8ssRrKoBOAOrMdsvjpUUm86sN7t0WpfEmIyDSt9YXOieCRqMcRdLnU7ZGNXJ4rv7+687HqpMwmZsEk11WBGpqDbtBOqFv2MyeldCzaETIKZ2JRQ3QQ24fi7QZ+NE+ylF9hUfBC4qlfy2rqMNHFFXaKidNkcxPZ0qicv5vTm/sqYY6SxqoUKLbOQ6qDDP8gscvTltMK7UQMXyn6AqnaSSUtfv+kJzZK0wbID/PlC8hbFmFzW+gZGqOuHxohrpRFJ4MSz3Qb71VPNUtX/wK0WmtgvYRqas6MYkuCU2PhxL/F6CYEtICMaqXwl0xJtu1yvInEXEWlXfkozKkWDID55f50Hj+UM3gXlW4/KKSEkCSk1/6+hIYFgcRhEnt0z4Ll+uuxiwDpp6hdx52HTLxNMOlHen6g4C0n/wx2pn2TkY4AfTL0zu/QBeBirypgj/qAw4bZ+aV5nvYcx8EgMqivx85PDzJRXXIsLCDabvbGNmlLnc175X1fOxen
 IuzHMMUO
 t5Yn4jBsimE/Xu/bTv2CjQFRNiW5oXlP+a9o0u+HD+CxaxkBOdOBMWBPnWLC+nrAZiWq74HgYdwuJ/1m7j2PYthxZItUMTZQoDrepThhzOu0rovgWeh+yhc6DBArLz6n7XPQ4CaDTiUI94M760yfOJhw/i8LT8WBC3kuyGKptY9nba5PvwqIpmOJBeEyE06XWaVjrwhOjUiDeo+L5ogvQ17lME1XPQBdGalz+cW/2LHCvibvz99mrm4yPcR+lOnL6xqfNw2WBnUQYtiyjFQKH7ZDUXUCQy4SBLffV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  /**
>   * zswap_load() - load a folio from zswap
>   * @folio: folio to load
> @@ -1571,10 +1588,9 @@ bool zswap_store(struct folio *folio)
>   *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
>   *  will SIGBUS).
>   *
> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
> - *  do_swap_page() will SIGBUS).
> + *  -EIO: if a slot in a large-folio range is unexpectedly still in zswap.
> + *  The folio is unlocked, but NOT marked up-to-date, so that an IO
> + *  error is emitted (e.g. do_swap_page() will SIGBUS).

Just curious, why the change from -EINVAL to -EIO here? Does it matter
in practice or is it just a matter of personal taste? :)

>   *
>   *  -ENOENT: if the swapped out content was not in zswap. The folio remains
>   *  locked on return.
> @@ -1593,13 +1609,19 @@ int zswap_load(struct folio *folio)
>                 return -ENOENT;
>
>         /*
> -        * Large folios should not be swapped in while zswap is being used, as
> -        * they are not properly handled. Zswap does not properly load large
> -        * folios, and a large folio may only be partially in zswap.
> +        * A large folio reaches zswap_load() only when its whole range is
> +        * expected to be on disk: PMD swap-entry consumers split before
> +        * calling into PMD-order swapin whenever any slot is still in zswap.
> +        * Confirm the range is entirely absent from zswap and return -ENOENT
> +        * so the caller reads it from disk; if a slot is unexpectedly still in
> +        * zswap, fail the read rather than return partially-initialized data.
>          */
> -       if (WARN_ON_ONCE(folio_test_large(folio))) {
> -               folio_unlock(folio);
> -               return -EINVAL;
> +       if (folio_test_large(folio)) {
> +               if (zswap_is_present(swp, folio_nr_pages(folio))) {
> +                       folio_unlock(folio);
> +                       return -EIO;
> +               }
> +               return -ENOENT;
>         }
>
>         entry = xa_load(tree, offset);
> --
> 2.53.0-Meta
>

