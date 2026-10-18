Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 445D8CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 15:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5C56B0088; Sun, 18 Oct 2026 11:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95C26B008C; Sun, 18 Oct 2026 11:15:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAACF6B0092; Sun, 18 Oct 2026 11:15:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2CF66B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 11:15:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2238E140511
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 15:15:38 +0000 (UTC)
X-FDA: 85336096356.06.6969DED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 925E21C0006
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 15:15:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kg/pB2aB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792336536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4ZdaKOa4IeEE7Qn1NSkxriefna/c4NwZmzjW2wTlb4=;
	b=ZUUYS3exWfv2Tn4qysdNw/a5Ko4mwbDI2HY0NWe8/FPAyCUaHu+oLm4pg/6RX6lKSoriZI
	v77Fa843hLxkXA1dm24m1Z47pJdd/Z5Sde8Lkl68+4Alha9AeByl9VpzUvI+quXCAthrPK
	SAygLS5pvCXgUTyYcsBxrRqkUuWp/Dw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792336536;
	b=tcj7QBbBJRW9dCDsKYlop5zUlmtFfpifT/OinT0sXoVTRDE55M9dVn56054Vcfh/0cBwPs
	bEuVonRpSJQ9nu4pVEMmp9/Ps7vGcSKicz0UKM/s2Yy/dZ968BdPXTcQoCPYc36Fz/G3bJ
	PCiKAYujmrVu9Jm/JoZg2Iqff/Erq5k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kg/pB2aB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51236600D1;
	Sun, 18 Oct 2026 15:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772461F000C4;
	Sun, 18 Oct 2026 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792336534;
	bh=u4ZdaKOa4IeEE7Qn1NSkxriefna/c4NwZmzjW2wTlb4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kg/pB2aBSXSjXYjNeMCoZ1GtVRuNUlE0AybD39s3I0MES0EpyGEaud12EwzwIqEZt
	 MaRWAs11SZZhTk2Pn4tgBmXWodV3GLeW3gFjey8oF0/CD7W72LEuq59u69DKTB5wrF
	 VmJijJesqYSLQglhZeqb4mx3J1lAv2AWX1PxsKEAyMjXwH6Y58WNNbWvYxln+WYX1Q
	 zmQRQi1NhhE3YUM2g67DySqbUnhCep7MR5c332ZOFFD2+7IdGbcyHt83OHWFYm9Thq
	 nd2ney8UF4dMvpdGBO17asuKl7gUy4vbFhrCsEy99JGX54ZIM2GX0FQfnxS0raiuTk
	 4I2YAqMvK3IwQ==
Date: Sun, 18 Oct 2026 16:15:32 +0100
From: Harry Yoo <harry@kernel.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: akpm@linux-foundation.org, cl@gentwo.org, hao.li@linux.dev, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickolai@csail.mit.edu, rientjes@google.com, 
	roman.gushchin@linux.dev, vbabka@kernel.org, vitaly.vul@partner.samsung.com
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array
 after concurrent resizes
Message-ID: <atTh-yyVIPQ-zNWJ@thinkstation>
References: <atJBK6hWYh2AqXwK@thinkstation>
 <20261018150152.1464225-1-vitaly.wool@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261018150152.1464225-1-vitaly.wool@konsulko.se>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 925E21C0006
X-Stat-Signature: mfejr478gc986usf4xw3c8dopiog5o7h
X-Rspam-User: 
X-HE-Tag: 1792336536-41469
X-HE-Meta: U2FsdGVkX1/3WFXIE4HCU3FToy+MJYN/Zli3yyBwKzWUmpe0C2eqCozS1de/sqarLr+g48NSoznfyeijFOkNglr4fuBznnyFrZUI7bRCILX+rDpLPkI0C0eXrTFLfzXfaE7bgpGFFjHgagFbny2wGsGHnfKMjGWuwZaxjbeY8a2CaloJPvM1bnFAUD1qX85oWm2K84Fzj6E9uiym7HfjwM5VMwpBB9FBFDMTHdfhN2/RUZeSeOe5rq+SHlAtuMSm6oIxHBCdd6KwCIKQYsAgFP2tAK4DDZxhvre6zKGQVU/VssJYZLIeDaOseBYPXQq7+5yE5iBcXvl4XtJ4UNz9aYfS1ehYxL8iclTrF2Cj6JZqK5rA+aJ5GCbJDROBiyy56OZYDvqUgaIrlETE5akxryd+Qtdv+2i6P+um6DSaa4Cf4EKTh+zHEPXpCop3ZwOubplXFaYKCwdm/RcDJ4IvspQw5fpc3qNEXREJXT9F9MYAkNNdxFhUt+CyM0swC9utEJCc1YNhac/cqV0Ex6TmQs6OeWulSsrmlhfGPFrwt6MSNTBp4phDIuTG4KmUQSudqTbVldkioZQQLOmXbdTfx3pug2l1uI8S7+m32z+4MmgHvtqPny1JWDkZ4d0VnpOiXLi5VCZ/FbKGHmylskPiNKWepdivfedZWyaFAiCkZt3dfnOtEABVJOy5eBrLuJ5kKsQAtIITX38RQcynuHHsr8i5fVhjEIb7PNPe8gfiHeNGWPfKFWQ9AL5PC4OHrzT81+W4NPT3Aj9fwa9h0vkm3xPi6I5h4cy9RjUbwAQc3HQdGQZ2uChw0UXHrw0qtRcGNz+/jMNyVMM5M8ycBEX0X8hMzAseqkIayGwH92PMuSgjWXDbyAL4YaoLluyEfFjmZM1+vP7koq1PL1tgqffcPA7Ts0Rj040YCBxmhtoj5DfSvxcTmq+EXjA+eI6XEkKIEVaeRyUWnRZebCqE+cV
 VdnuC83K
 H2QqEb1zx3dqgPWKJYuas9WxOJRO4eYTj57epBe1VLQAvrPpHQCz8aRbpy3yLYBDKtn0dDvYxJJ6g1qDY/m8ngzvY5C6WCyCZd+VoqPgKRHnyPXFifY18u7Wm8IpmZpx5WRjCrvClIimyzUSOLUuTxFG3GyHakAHhSj1WP9JKlqz1Ut6l2Qc5eNHHNVIIVHIB8MY+m0wS/cHIQGS68XTazB6AgPdMGzvM6N9mxlZe12g64jt8m1hFq6iXYbGneJjwvT9Uxw4YVnP/sqczCCYAwiq7mMK7J7yKB1L6lWqj+0DyH4qakNjtvX2TPSDBcvtyTpGm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 18, 2026 at 05:01:52PM +0200, Vitaly Wool wrote:
> > [+Cc Christoph Hellwig and Vitaly Wool ]
> 
> Thanks for CC'ing me on this.

No problem.

> How about we take my patch [1] instead since
> it isn't prone to this bug and is a nice optimization to the existing
> mempool_resize() at the same time?

It is not a good idea to squeeze a bug fix and an optimization
into one patch.

> [1] https://lore.kernel.org/linux-mm/20261013091408.1231786-1-vitaly.wool@konsulko.se/
> 
> ~Vitaly
> 

-- 
Cheers,
Harry / Hyeonggon

