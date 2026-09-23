Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D473C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FA866B00A9; Tue, 22 Sep 2026 22:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D22A6B00AA; Tue, 22 Sep 2026 22:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8B96B00AB; Tue, 22 Sep 2026 22:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 456F36B00A9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:32:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD2321A0675
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:32:57 +0000 (UTC)
X-FDA: 85243454394.14.A68C2E3
Received: from out-utut-a220.jellyfish.systems (out-utut-a220.jellyfish.systems [198.177.127.220])
	by imf30.hostedemail.com (Postfix) with ESMTP id F01D380002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:32:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=i1hlCY5N;
	spf=pass (imf30.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.220 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhQdABlylOEbaAhIq2fvadeIDgLzvHLyAFVEKqUhlP4=;
	b=0Ln5JvjUxgfTibq+yyK1x1zcmaFNkDRaac/egyLvHxRRk8Q1wfthIbToyP4y+dfkcgI82V
	gfkzhzF2Y6U87X6XXTpnfLTNeQBokPyYZKO6f4/y9PFE9vnDtK6NAo5WiSVNajVadukXmt
	R2pKsPXaHXkdb8MS38i24zSMziO899s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130776;
	b=Xy7URnQ45E9qVMZjMnwwFPdBjtxXD3redRP/iOudJUCvhs+B2RmrycCAxeyhartci7+JCP
	P7kxRfuuzAjZx4q5L4TLIOsPXMNnD/s5JCf/zYymW7xsKzFRxca/zlz5OMniM0MGGYhUNN
	N+ndZf57+bmFYPULMTuputJZF/r6WHk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=i1hlCY5N;
	spf=pass (imf30.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.220 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=pass (policy=none) header.from=tychen.cc
Received: from [10.18.116.108] (unknown [120.199.7.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hqLbn1Thyz8sZ1;
	Wed, 23 Sep 2026 02:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1790130774;
	bh=QhQdABlylOEbaAhIq2fvadeIDgLzvHLyAFVEKqUhlP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1hlCY5NgNFlNCgoXdHhCpD75lDhkozAfMmrWrvw3kEdi4U88oip1XEEBNuEXwrSr
	 pPmuVn4RA7Bt3TNUIH0BiZCabZZ0z/2sFgchhdYojlUiFxNd/jmVAgwoIDW/MOH8oc
	 Am0afPogrBPMxizTPbYAuH7B0j9ovWTMvtm1fLsaBIXSVSk/kc+0zN5UvyrxJoay/x
	 tXmtIVlXZK2ZKSgKWPpuQhMYI6wsNHXeKR6oOfDWUGMEdhbfIeIOnUP6Z/mBBz4d9J
	 tmEbAFoSEHujRV6w7NsBfX8YOR5NDVEdJTrCQ+8ZdHkyg5L6v0dvaZdpD3E6myC2SU
	 PkXmPHPkSkAGA==
From: Tianyi Chen <hi@tychen.cc>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] memblock tests: fix BUILD=32 address conversions
Date: Wed, 23 Sep 2026 11:32:49 +0900
Message-ID: <179013076994.1911052.6395482478037915192@tychen.cc>
In-Reply-To: <179007180279.508753.4595268983388589280.b4-review@b4>
References: <20260916161105.2548281-1-hi@tychen.cc>
 <179007180279.508753.4595268983388589280.b4-review@b4>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Stat-Signature: urhpmu6eqw756aryj5os9p4ufjdp1fg4
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F01D380002
X-HE-Tag: 1790130775-676758
X-HE-Meta: U2FsdGVkX1/mbE5qnrBu8eHtj08jBYU0BfnMFfz3Z88hAXKXoHJvOIPmooRjnt8458lSTEXUN8A/NsXEQpFHpS2spx9OnoECokTcL15pSv4mtUqLhBANx+N2tvieKWwJZ1r2V5ucDy4dKfzikyzzwSrmElj+YN964b7Ch/rqZNw6kGElOoQPNhFJLL3spPt9GMm6S4UN6IIP9e8ijRlTOgOiFFOPFdU2Ly7mof29vJgJfs75WvIQ3qzOhgXK3dXnf4H8FcvKvTBdH9UCT6W7C1NDSPo1q9Yz82SXoCz2+w32NaSEhvKFG5H4ND9TsIiFL4oGrJc3eTdtlEaqFUSkEqKdOlXcg9t3kdcEIaMBJ1IUzhbd59DyC44MBqGVwP0DpZ/7+tCs5vAdPQzp0QKPbIRC9EX0qqdW1XEYXJCxI6p/d43NKFjaYnLlzeOamUW7ihGHp/8CpEbuRcVWd8Mi8ZXV+0anb2AQdigswy1Dv4RxIYC+51l8oUuCn99P3j4Bvok7LaCwTbuXB9OHhjp5y0TVJJ0h3+xMN5SZp3ps/birdUp2Amt6OLo2qifyRP3rG8fyhOlCA/0eQTFoKmuSl6pV+iJAUrOMJUWyXs31pamxzIJpgA7lVoIrz9kIr2lqpdJAPcNfymVs1S/9xs5PxxeJT0JyDbDECdQuKAAypYKQZNkMCuc+N3YkB+Bm8AEXHm83eRJ0ngmatyXg6W/MHL1F2uizCTCNRK6s9aCvWHPe2J5bJg0I7w+H5CXxThxUij9JOKyqoJqhuD2kCG0ozW50VdGW5rYxScFy5PmBbfvMrsdQAqPffySlEsqEC6nF+TyW6bHzFQvj593OIQlIY5We9KMZetzR/R9jOhzM9ZB4vuzK8irjfywZrKeudSu5GuJQXg3O56l9PMjofg9arHxxNUsXXZxHtXOOyy15myk+fBWhOHmklTLSgks8f7Le64guEqmuy0zjTyvPnr1
 A8EzBq16
 fhZBTfF3J5fjZ73zQMapV3OfAP11J0R/Y5bUnZzUlOPHGKggpqrcaaius0A+LEyLx8NvIv/OnlP0L42WY5VtK/wbkuRdGxbrI7oXSUso1c4kWZ1uPX7TmJqO2HFkGPRzHsNVH3/vvfKjISjWAkgNrwTgtkvZOeEcFhKRMfL5oTEFa64nlrwOUqDJzB4YVe8/J/LcwCUsQVtn5+JjvKgb/t6DIMFY0VdvpPO1lbUd+tOPMRgPRQO79AwIgMCrH7zBTp53kfA0AwEG5fqjXhn1025adFsXMKQfV4/egvaOhuWeK0tY+lQpNxEtCAgXKu+t6tRTYikBvIWDSaiwyF5omsnpSBZwr4FJOgq1rajEB13JujUGq9t284PEzk5pM62pQnAaXgbZBA2RzlCtLFMlzuujZSWYalzMz6Hj9m6t0ZQXLlCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

> Does it mean BUILD=32 without NUMA does not pass with clang?

No. I reran v1 with Clang 18.1.3 and BUILD=32 without NUMA: all 189
checks pass. The previous cover letter only mentioned the NUMA-enabled
configuration tested then. Sorry for the ambiguity.

> I see a lot of warnings with gcc and BUILD=32. Do you mind fixing them
> as well?

Done in v2. I reproduced them with GCC 13.3.0 and removed the remaining
physical-address-to-pointer casts, used __pa() in tools virt_to_phys(),
and initialized end_rgn to address the maybe-uninitialized warning.
The latter is a false positive; each insertion already sets the index.

The virt_to_phys() cast also sign-extended 0x80000000 to
0xffffffff80000000 with GCC BUILD=32. A separate boundary check now
passes with both compilers in 32- and 64-bit builds.

GCC and Clang each pass seven configurations with -Werror and the default
ASan/UBSan flags, including BUILD=32 with and without NUMA. Details are
in the v2 cover letter, sent as a new thread:
https://lore.kernel.org/r/20260923023126.1910311-1-hi@tychen.cc

Thanks,
Tianyi

