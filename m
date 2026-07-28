Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8265C531D0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 01:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C54B6B0088; Mon, 27 Jul 2026 21:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876116B008A; Mon, 27 Jul 2026 21:17:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766566B008C; Mon, 27 Jul 2026 21:17:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39B686B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:17:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 86DE11401B7
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:17:18 +0000 (UTC)
X-FDA: 85036422156.18.C3AFA15
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9C586A0006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:17:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lBRGqnkM;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785201436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPQx8MjSRT+qPOzIlQlIAVe0liiWzhutfFSZ/q0j3k4=;
	b=nAPOQ9D/MzDVub2cTI3ydkqTQikqxj3m5tDfB7iEHGiY3rfauDuOHxTRKyiHXXUXc+tWCa
	1hWuOP318+Sbgi9R2aehtqDActOFYjMDGKTGcAgArqBnxbyiGbNmLmAnX4hJ0Vc8W3pDqR
	3QYcpP6DdjFuAUFkBy6QEP402gvq6sE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lBRGqnkM;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785201436;
	b=Sq6PHZeP6dM1KWCjpY2b8bE6ljNZcCcbgJxuM/DucKxkDvRrXKL8VONOseFYFzVqyutAYu
	S5SRhpkMtjR++1LQ2WoAB9xw9i3Bz1EYEh4KhOHCRLA3sEWuLnyURYOdN1dnORxlXpSUXG
	3ttzAS98w9DIVXjj6NDwhdZ13lotJ3g=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5b2a22c52c1so3782409e87.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:17:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785201435; cv=none;
        d=google.com; s=arc-20260327;
        b=VhByzkpycbMf/V+k4XCcN0uB21ZoM8R+4t0B+fCxK0CnvQAjwVeeazO636ulNZzbRc
         Lr2JMzKZzwcXO+EjeBWNQHRjr0oDyB6xdM8O0M8pCIeqRU+eyeHM4DxR8HhCNzf7PViR
         4bml9DBRYcX97FWALHjx8xgYPDPPW0KBQlDBw3o1FAq1NxuoMXJMv+WIMt1wL3TSSHEU
         CdOOLIai2Am2alowZkIaLGXjrkOcmndqJIR2OjQnE6F+bP5w8yGqdtikQGP0yypoie2P
         c34YOROuHtqLrroDMZTmbPMLZLbbWBQD/xrZPgO0XfdUZXGiBtPU17zH+3fvkiL31o6j
         14BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dPQx8MjSRT+qPOzIlQlIAVe0liiWzhutfFSZ/q0j3k4=;
        fh=Jiwdvdk9vCZffytvvJ773XJ/w/kY6nLs0W2y7B3tox8=;
        b=XEGaheU6ym0OWEiTs2qznjAft+dI4h8gyxhi3btcQrirzI11RjThsM6XhSUO8ZvGbI
         2noaI+eMTwJhgawjRNVvWDvOg3p4BV5dLanvkvQAzlRBkpBTEyj8Yh0iroGGnNEZ4WpO
         vvhwT/WHf8eqGatShwB5Eiu+P5FKGP0e7A8noQgn6fsrePBe0C4pfmUI3T9IqK49Mbzr
         Aws/uyOfeY9NciaJF8s2+iPoqchl5JNOgQwacLz8VdpFytcTYxE44AXkcZ5n9GpcVX72
         XXp9M/NyHh0pNL27jr1leaF3MB60TpUqrR2mHfDDjvOYAYHPrZPidvDXlj0l6tQaVy0f
         5Nlg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785201435; x=1785806235; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dPQx8MjSRT+qPOzIlQlIAVe0liiWzhutfFSZ/q0j3k4=;
        b=lBRGqnkM33jD1SV7hmJCz7XFKcOJ6iPiVeeARgiBEvpidgZVsrhPdRd7Kqhi6XlltY
         vSTQeZRvBQoKw6BvtDZToNQ3J75T5L1/gzXpFCPU/UkAumeZA76qM+LOw3GnI2lZFyv6
         duB7tV/77V5c1ai/+bjgAb+T1pZ6GZEcPvE3yEnPcWHdWDSN2KmcMURQHe7IY+0uWk+Q
         iBDs4Gf79nbg6bseoN292cmrTa61lDX7ErxknZ8z0+3AI5/HX6k9nh/78ZFG9Xy859wB
         Ffln2gcf6OqSgAH8HPTJtrINs1mGSVGljHrQFo59J6RgFL9u1/lJv3CmtK21HnVAHSBR
         IySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785201435; x=1785806235;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dPQx8MjSRT+qPOzIlQlIAVe0liiWzhutfFSZ/q0j3k4=;
        b=XiG7UuZUuLLhGyr2Qhc5D7jvTYoWZCTbNU67/RJi843MDDAaUV0vpPEd60zMqFNXx2
         3DusuRTjy2vtT7gpmA31WoIVmiutbJMVfcG8D8FxJxsN9VZUowPsDZqqAOQqJ+T9i8ZE
         bdO2iOPAAEdSOjy1gn1MDJ5o5NYKt7Q/78V57QzJLPNJDVL3HfTCUvdLtBhXHs7D1d/J
         kVV6pB7Y5K6VLoPJlizM1jIN4BOhlG3HusjoZa1tOoCs0KPpjqzzv/H0kBstDHZtWPcj
         JWdqRbv14tM8Fk0BOpw48fivXgeCdYRmEAGd35uw/TtKOs2jdUKoej+p+yeDoKw0+M+o
         E4hQ==
X-Forwarded-Encrypted: i=1; AHgh+RoziLykaYZgoU3IuVxwvPM1bTwq1AR9kiPPTTkacmhl/bO9SjYaC57zKqeZ4yFM2t3cN4q7Cj8Kcw==@kvack.org
X-Gm-Message-State: AOJu0Yz4xe9gXnIsKr43wSX0R+gE0iOEeecI15kewmOOHYuraRJMj5MK
	/rKLedjydDfeW3v2Ia2IrvdsS8chCGhX6dpnf2CVEAYQEvLySvVzz+RdjZfp5hN+4UU/xqcyLSc
	HqXL5b8SWahp/HZsfc2nARDC3/6lb+L8=
X-Gm-Gg: AR+sD12/PyA2Ydz8YxJJ6tHQdnVBFzDqg38Ha7vXKLsiTNrcjfq9SGqDH0A4jPyBRFu
	KvfL9lQOMD+7p1m1WKtZIc7Rm6ULgLrdXZsceYVf1Ex+Lx1IiCsOinfXHUbtqXSBaJ/ct0SdJvl
	wiQ8e1g/QN9Lcnic7rWylj7AcPJ3Usw0ML+EOGwByhd68DMRNyUnTJXPQYAFQRMLS7EDYUT7zNa
	RR0kdjq7oTDtfD0d7iBWw3vCndl4HINDWslFSdiC5TJYRnIsd93sEvMIsnPH2QZ9uthqpCxyItj
	L+YDFkeVquHDlRM=
X-Received: by 2002:a05:6512:3e0c:b0:5b1:5a31:85fa with SMTP id
 2adb3069b0e04-5b2d0223f08mr46277e87.16.1785201434639; Mon, 27 Jul 2026
 18:17:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com>
 <CAKEwX=NLEmRKbgf7e4mQ8ynwGLhe8d3orc_2U8n-K_W6VjOAoA@mail.gmail.com>
 <CAO9r8zNbw4T4O-TtFsd9NMJh2RKRDuXTqfSKgMbe6o05MZxebg@mail.gmail.com>
 <CAKEwX=MwhU74Ak01kEa7VL_mKNY1gO_hX_aAPvMkXo-72MB52g@mail.gmail.com> <CAO9r8zPsQ6rzhuRopvepxmrXg6q2r+ixRvL2vdG2FVmxBcUn=A@mail.gmail.com>
In-Reply-To: <CAO9r8zPsQ6rzhuRopvepxmrXg6q2r+ixRvL2vdG2FVmxBcUn=A@mail.gmail.com>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Tue, 28 Jul 2026 09:17:02 +0800
X-Gm-Features: AUfX_mwceDvz7i9PD7vS4FWOHfiWbQ9xk9jzIiLYLIDCVmSjH-4xpYG2e1NywoE
Message-ID: <CAJxJ_jhvyMukPLThpgcdCMHwbp3b3bFvc4Va1cK79_3z6ubhwQ@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/zswap: reference the pool by index to shrink
 struct zswap_entry
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9C586A0006
X-Rspam-User: 
X-Stat-Signature: y3twst5swf1gkkrqs6jxa4fzfq891qu9
X-HE-Tag: 1785201436-417409
X-HE-Meta: U2FsdGVkX187uyWrEi+BwmaT/fixGyzBwWiehMNsnLUoHIJwaI8Ed/aCuBH9VfK6b3Y8iHRe5aw7diA7rJwOLQ3W8fHrWSwiHHJXvGobmpFK/xGyLgaOqkdMqhSCM4X5OB91AqUksA6X1Zb9DIk9SedH6RvnEsEAy3MQkCw3AhSjFXSLlwktvCPHFxn7keCcypGeNBTt1V9SvfW/hKI8K9t3QOKLga5UMgN/RJVPvRCu8Mohg5FB/Az2w7lBUvptpmjuIa4Qs6YByRz9PTNv4seMKA21z79jGMOVmRD3EZMq/JHmYAiJoGOcM0x/xJewVLLmvp5E6wBp9eMnc9V4Ro904ohzbc71VRB8DeyfjtzPFoIqgE52UFnSPwe9GRFyU6t3dVe2EnJn/I8XzJvx27g3sVXTxEbiu6dBdHipgrPg79KBdgByxmWAEzO+JfUqhEqGR99geeLSay4i/CB8AlnutDeIymw8vjp5M+mHh4FNsH0dal6W3kwJ3xrC6gEnEN6d6H+rUsNBZyif76FLNj6/yKL6j312uJc+CAUrHCLTP7XgQVv1KONnHHlXSdBA6RxsB4725U4XWAHb7pvyMkXV4dFrhOpCH28vAgCdCYTao+8+2aE/cg6AZORDglqJkiyTK1Mz2Y/vpsB3eOVot9XH4xwT5D53eT4yqIyHkPqnkdMYs8uWmGTicVMeaqp3++Kp4ww2xprlC6FqkNtXv8ddy/ODSB51fo6Dx8414wHjQVkVcSPoTdaDn556fwdfBilN1GoZDM8Ue51XnjP2IdC77hyfkJLfKl1D8a3tdz8JC6P700Vs8MkUCEO235P8aXvsSUtYGY6zjavBidAeIaA7QoOi+ir46d0FSBBE/GfN4S7J8l/ITjG+3K8DyZsttdaMHvxfbTW+ZMoHRcjdMjhefKhiQqANLP76cY7NXmGtd7elgzt6kVn57JBtkkIHvikvwuReUu2CK3HiB8S
 oM8pNTZH
 eb6ED+c099tn/iXcsFzwK1UrhNp78cn2qNdsxXN3D2hoTLG4xif1An8roDtjekzGu9z20lcLs5R5YhDD60EKAEogp+1VSpCNR1jKiZCY7m8NfA6rOs80J0gcIHfUgH/ILZ8EDF0z9QdqTdu0NU0XFIsfS1p5vIq/by1YTq6k8excO+emNIyyEBwpzzdfDmRZXv0HWLmxDPSNPi3MODSXc6ScZ+gkXwi5/jybuMc756OWoKpqYAUrkOSoyxwzhAIw2bHMLPpk7/yVr1Fvg2mNjxSczcu3CAo5WsM80NNoI1pDNmUaB1+cSahAjwnwb72elcJAfcdh7JG/vHntv52zLyr2shP0MHnJJpZQoE4sh/orhO5U8LK6l6hynIGJAHy349XM9L/jxvUW1+fdKeGUV/pZCh+MDiMKQqG5rFhsSxW7vNNVvhYiRjKLjPawxVGJg8Oif+ezzdisCwM0nNPUZ0NmbfDUt+X2V0FaO7li/EjJJWr6hhqARpQ9NQFSXEhmmbZhNnRFU2ufc5i4gz0uMtexJAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 1:07=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:

Thanks Yosry and Nhat for the review.

> Technically we are introducing a new limit on the number of pools, so
> let's mention that.

That's good, can simplify a lot, will do in v2.

> Did you try to benchmark it? I doubt the indirection would actually
> show up as most use cases should have a single pool.

I ran zswap e2e benchmark comparing baseline vs this RFC and did not
observe a measurable performance regression.
BTW, it seems zswap crypto-sg zstd and lzo are slower than zcomp.
Throughput in MB/s:
 alg      | acomp store | zcomp store | acomp load | zcomp load
----------+-------------+-------------+------------+-----------
 lzo      |        1140 |        1710 |       1070 |       1070
 lzo-rle  |        1490 |        1320 |       2030 |       2070
 lz4      |        1520 |        1600 |       1710 |       1870
 lz4hc    |         640 |         680 |       1770 |       1850
 zstd     |         740 |        1190 |        980 |       1720
 deflate  |         180 |         180 |        665 |        660
But that's another topic.

> No need to document the function name here, most probably will be
> stale at some point.

Ack.

> This seems like the only user of zswap_pool_by_index(), just open-code
> the xa_load() here.
>
> Let's add a NULL check here to avoid blowing up if something goes wrong.
>
> We need a NULL check here as well.

Ack on all of these.

> Maybe just add a fixed array and call it a day? :) Seems like we can
> probably get away with, say a fixed array 16 elements.
>
> If we want to be really conservative we can use an array of 256
> elements indexed by a u8. That's 1KB of memory, probably mostly wasted.

I prefer dropping the xarray and go with 16 entries indexed by a u8,
keeping runtime compressor switching, which can increase when needed.

> 2. Note that the zswap pools are also organized into a list. If you're
> adding a new data structure, maybe remove that.
>
> Also a good point, I think we may be able to drop the list, and I
> think that's ultimately more valuable than the memory savings.

Agreed, the list looks like unneeded complexity, will have a try to drop it=
.
Looks obj_cgroup pointer can also be dropped on !MEMCG, but zswap usually u=
se
in server with cgroup, maybe not worth pursuing.

Best regards,
Jianyue

