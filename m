Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 085E6C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 20:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25DBF6B008C; Sat, 19 Sep 2026 16:16:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2351A6B0092; Sat, 19 Sep 2026 16:16:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D1D6B0093; Sat, 19 Sep 2026 16:16:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E88576B008C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 16:16:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 579CEA030C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 20:16:30 +0000 (UTC)
X-FDA: 85231619340.25.F40B23A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C113480003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 20:16:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SU+VN3tT;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789848988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tW8vBAHwxwtxJeHMsSnCySRPT4zVEQwFq00zoQu2nR8=;
	b=CBrPV+Z+wthgpmiuh0nmKBANhfCN4iOERTs6S3h+zM8tBsU3c2/xsSzk+itJWYbQkHWtyM
	WJM5nJjn5PneM6csZ2etyQbobANumwCwFLnJYCv0P7bMYJNS25Rbym6D5sA2gWlRuBZ+mm
	Lz5tZi1q0kxf6yAXTdxAB3VcgT5f1f8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789848988;
	b=hPXriks9gnHycvnktZq0sbklkRq5+hwuelL0A81C+QrdL/G70NjJCvMJHKpnS15EiRkUJx
	JhdpVkOlxiDxnF+13uDc5B4GZb6/P0Hr72IDgpF3SeK5cEfajUH3JC61Cwf/BPwEEeSYeu
	TtTr6b1e1HoIAWU+WN0m7/AUQW85dDU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SU+VN3tT;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AF1C601FB;
	Sat, 19 Sep 2026 20:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8481F000FF;
	Sat, 19 Sep 2026 20:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789848987;
	bh=tW8vBAHwxwtxJeHMsSnCySRPT4zVEQwFq00zoQu2nR8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=SU+VN3tTeoH7EWi8Cani1Ea2Bbsf5ZakAGoL6b06c817iYymfM1KIYEcJSq0nbued
	 llEjaLBL1rUh9yNfqvLjRFAT6YRXFqXdW3SZAc2eJaDybRtf/CRuWp09GsFA8u0WOj
	 MVFljGlRTehNwupUjCb1SNyO6O1laDpcoVsUZ2/LCnSjAYdHCwPfs/O1S0U3h0Tkfc
	 T6ZEAtW3anFtW8OTKhNhqF1vN9do8oyyNId+f5P+zhXNOHQeWI7F6QbULE5cbEVUFh
	 iuknLKavjbpf8HTqKM27c996Vrg4ly6S5ZaGD56nWvOBphKuY3zq8iuV0PdRRpgofa
	 Q23JnRiU6HZhw==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260915102524.125758-1-sarthak.sharma@arm.com>
References: <20260915102524.125758-1-sarthak.sharma@arm.com>
Subject: Re: [PATCH v5] mm/gup_test: safely calculate GUP batch size
Message-Id: <178984898740.1919879.11324251625191252500.b4-ty@b4>
Date: Sat, 19 Sep 2026 20:16:27 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: hm9euh4pag8k78brnzjyxdj4ij55p5g8
X-Rspam-User: 
X-Rspamd-Queue-Id: C113480003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789848988-840860
X-HE-Meta: U2FsdGVkX19YRiuK7r2pow6E0+6EiPGBLii3V3LRr683SPJkwGR35x31DL7y1GzhLe0v16xeY4kgO+Zpw1AbYW1t+wHmNix0oMzRHcFLajk6tJ1WVd0mc+QGWfG+EwNSmVUxmaRWq8kQpKT313iY8vDfVzga08M1zEhL3iROD9lp2QSeE9V7uQcK12VNHMvzvlRI23VGVh0IxOWHVB9T+hZcOc3HDsHmC5f7MOgcPxpgQr4M9SkZWG2dMWEsxyfZJj8m0M4yYLGJtnVDnUXN91+NE9y0zwL+cPedTh1WS6MIK4yeurnUa2+PRq4OgIUn3lPnW47GfbdZXykylTAhSw6A2+eFscC2G4qVqnQsmmGXVdii5E509exk148uIF9RDxGVDxQUrnwTLMxGmqOQut618qq5tpYfZoBqVEbY3+bfyRT4tFOwTDg667ugdhpee7PTbIy+dqmrTr+2CVnCYV6lAX8+SXSWjwiuC3/ZLFonbsHLN8eF1CqX1hv9SB6BKISlASBR1y0Lb4MiY85fztApzVV3bCAjKxwd4ZQafRh9Kz0tp5lEOCHVKEPvExsefiVIzT/Vjp+F9WFReMymTPaY7x0Cb4U6BrdKdskscn5W3L2U3WpHn3WCV1lzDBBtnuJ3Ye5NhVKMbRq4Mv60kNWD0O82FkRFusucLpBB5TlZHQwjX+ERc2DsOMu4ky4LC+7LjDsJK+7UQZu1UortuEOtWlTBueHiZMEegddHMWb9oDCr5jZuzjVZGciTQljMIBgdE+e8WPgAyCtuxj3ecUF3Pz/1C2V+OyCqOWGqfR3aWZyafYmBWslUOdrRsSz1YcrAmIBpdg4QfQJwapilIZDxN5WD+dJzvcOsnht+TSK6+pUhpFF/Rkuxwefq7gBOOIGqrhX616TJibrUHpwH2ThohGFid1J72ggoponBLKZ2JeiYrsbr5cpSoPUaxEhGSsmlnZlfjB6a9NRRkF6
 4RU+d6OL
 epjJCwrrkAfl8k/2F/JiDKmIFwlFbzYip/7Fg2grOhagHRsz15oA/Ou4ZhUzRGinv6ffaRLNxFIel18XqI67nItCgodZTFTEfA45BvEG7zhMd3fEMqmKShBQY5p0KgV6AQI0TAGyX+IeMRUkEZXHFZ39k+SHgIYVJOo2qSPbA5az4YIwVSBO14UtnJeVSH28JtTYlYY6DLOyyPjVM7JGkCK/drg6i3H4r/gBWX4dYN2+o1gwmA05a6tswKbpNp8aHr2pvA1T60JyDjqh4Sw6m4qYEDGBMQu2gPlET
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 15:55:24 +0530, Sarthak Sharma wrote:
> __gup_test_ioctl() calculates the end of a GUP batch using:
> 
> next = addr + nr * PAGE_SIZE;
> 
> If nr is too large, it can cause next to overflow and wrap around.
> If it wraps, the next > end check is bypassed and a large value
> of nr is passed to the GUP call, even though the pages array was
> allocated according to gup->size. This can lead to out of bounds writes.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: gup-7.4.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/gup_test: safely calculate GUP batch size
      https://git.kernel.org/mm/core/c/44817a53

-- 
Cheers,

David


