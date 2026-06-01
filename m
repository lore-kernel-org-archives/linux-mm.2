Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E73ACD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860556B03B7; Mon,  1 Jun 2026 10:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837976B03B9; Mon,  1 Jun 2026 10:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E3A6B03BA; Mon,  1 Jun 2026 10:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 632A16B03B7
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:06:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2FF641C0866
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:06:52 +0000 (UTC)
X-FDA: 84831519864.28.C4F86F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6516CC000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:06:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LePpvk5w;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780322810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJwJn86rCEPxRH3q2y/J9E5EpPT8fgMUG0uqqux+hwI=;
	b=GdWiY0eNdUoheu+nFZRrrvtoTzBM3H1roSaVgBPfHuT/rNQTvswOKtZzbPhohwwfvGv0uh
	qOVu0rOXH/Kny8ppiOE910enZj5AXWCgzK4pw3tWkIIxnNNIhn9902RKw9bzk7gJ9BGbmf
	rcaBOWfZYBaGbD9p7KahU4h/JYUCSLU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LePpvk5w;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780322810; a=rsa-sha256;
	cv=none;
	b=NzaMl0ZZPUHkbDPrUT9tTICVYSJkSP9tL6FDP5ZwrQBcXBxmipUkaqbmmZZJsIA1d1HDwc
	H6hSyXQxnOkDoS3nf1f4cTni6JHFSzH1SPDKyk7VSRlwB7iiArqZF0TXR7rBY3frz0h7MK
	2Cd+pnVINjVm5qU976X+LPzKkp1kfXQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EEE8B600AA;
	Mon,  1 Jun 2026 14:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646F81F00893;
	Mon,  1 Jun 2026 14:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780322809;
	bh=gJwJn86rCEPxRH3q2y/J9E5EpPT8fgMUG0uqqux+hwI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LePpvk5wT0QV9RwdgdWdarE8lsKdKmlldXHY/vsYTbBQpRh7qaCWdBD26tSDBjlCL
	 k1xstAWFE7L52SVefYDU3xN8rQmVYQIXXS6MlawqBrIldZj2/xXqP1mNrn27Aa4fYx
	 J1ymX9QNxU4tt9id+IWx417HXF0LubTVOzQxUfLAIGpM3F5OzJ8GuLZAhq1xZ53QkO
	 iAlV95Ump/O8pJV8ZsNm5yWpQIjYaPobrOtrlgR8edEJzf8W+f679aLlKURkaTDpeS
	 gflYU/ULXlWwLSoTk875nQbT3/T/p+sie6qshKhPVqKG+BIFjNUnfAzFxyaUAgte8u
	 FQAUjrn85hO4w==
Message-ID: <a891fe99-0059-4247-8ebb-0363b4055d2a@kernel.org>
Date: Mon, 1 Jun 2026 16:06:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
To: Yury Norov <ynorov@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Farhad Alemi <farhad.alemi@berkeley.edu>, Waiman Long
 <longman@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
 cgroups@vger.kernel.org
References: <20260528190337.878027-1-ynorov@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260528190337.878027-1-ynorov@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kep5hrpr9jkpmq8uxh6751f1aamqcp17
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6516CC000E
X-HE-Tag: 1780322810-557109
X-HE-Meta: U2FsdGVkX1+YETW5Aw2Le66mrXF9Qy1ML3kiX/pvY1H2Mf8zdXW7XdIclHB1IYppQV9nPCXZxnx/7+De4YSd5ybmFa+RzF9iNVOsElyzvteCgnv+mPX3ZEA8FT4AENLD/0h3JvZ6G8kdkIGhKyPREcleeuX5m9rVp29prGGJ9isC2To5QLFSWy3kvjo+XjqnCQHW61Bji9h9CaWbG8K+Vpvs2bjgq2tYoGXQMbQ9YZ8ZcP5nFngUS8v9n8UosQnfb4FIadL6iCAoMJaAEV27ccv0WKtFigm2PzO9ox44BTm0u6gQK9hiRW1SoGzWCmnkDHC/yRBjChR8n/UKb0tIyvlH9gdY6JC44CzZKW3jXnYaLIHmXXHSpzS7dVKJsnPFEs0rSQ2iAE9Pb6S3kOrVECOiAgMn9kCage4N0klSsTelBw+ZTuVXEx3zsm2Ioo26U9XcSD9NOyYEi2VSHR3zUh8v+BaOGF8/gQ93igaJLBuwE550UxcxNnf7U+he3EJ4hjahkVfRahtIytCcPFueOr3Ll56q+Rg2sW96E6wMMjwArwkTj1UQaBtlWTMKvYq72wdsJ7MUqyh3kgMnGqRz7Ooz36WGMpff1inVzjYLMi0FopHamxUsVUxoXQHFFrv9bKNgAjXcAleKyVcZd2J7SaG8mqbMV8sXRinfCAUEzJ01q09nofUwgUdh7iOpmUTwPlqpqNo1TWRCpiGBKKigggPMt4ipQmxoJ4uM4v85XogwL06ZPqXUIiU4uqKAgrcSPfyTq/M12psf2au9QatS4OoyHELrTbORD0qC2A0w0Wup45MRdQkAyJKBQ6vGLKJy/bohe+D0eZEYRJkbabBBbhM2ihe7PiT979NTiX6PmmCAKdfMGkrmEiZL6z8zRTnyjG9uTY+EYMlVVJ0nFBIVZ3Hifq/jH+ii2bljEi3DKzBMtATy7M/azLMWZjDw2mlB5A6yJClU8gUoYCbLWfd
 E9urnF7J
 s0F9e0dxwS0u5XSsthpEFlEBo5G6gBbr36mze+rCyc/XdAECZzjsr5Hyu5Wox8RCzkDmL8pXBKw7N80L4gkvo5bc8QRkCOTL6Wmg32xHJSSGBkqE3L6FLkPnldbOI/kniNKKC5OkeUImAjBkJlZtF1GNtfbv21zhEGcM91lcqsNfZ7Slya9aBn3gNaFgk2ys/R6B/8gFBZsHta3I+VSF4CVt71oqXUaYrVVGPCtEYIm3tsLq1vH6NHevKa8M3FyYrF7elJMrggrwLDC+SCXvnlvzohPHggp4KllJp4fwarZfLAvIjC8dLmRBuW/33IUsDqGLXYnscKiiBYWqwCrE1h8zh2961P2oYO+h26eCh0bjxJgWQnOLTXtbg1cB6gnCF3HQWoemYlRb7n2JkCBuQvau2ZSfpY26is1WFApldzlJHmnT4Yvv9Jvlqw7c+y1XaK1fB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 21:03, Yury Norov wrote:
> Reassigning nodes relative an empty user-provided nodemask is useless,
> and triggers divide-by-zero in the function.
> 
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/

Likely this should be a

	Closes:

And be accompanied by a Fixes: and Cc stable.

> Signed-off-by: Yury Norov <ynorov@nvidia.com>
> ---
>  mm/mempolicy.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 4e4421b22b59..cd961fa1eb33 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -370,8 +370,13 @@ static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
>  static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
>  				   const nodemask_t *rel)
>  {


Continuing the discussion of the context in the other thread :)


-- 
Cheers,

David

