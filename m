Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6529AC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 08:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397E56B0092; Fri, 25 Sep 2026 04:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347E66B0093; Fri, 25 Sep 2026 04:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25EA06B0095; Fri, 25 Sep 2026 04:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7806B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:39:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9741A6AFA
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:39:00 +0000 (UTC)
X-FDA: 85251634440.03.BCD0B76
Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6BE0C40002
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:38:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eJSzp0FG;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790325538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsBjw1qninqQiDUSvcGvngsX3qUwaUajU7R7jUyn3zE=;
	b=0qhoYRgVRtIj1ePUWyykdQARZt4/FFXvN0hy0EyPww5TK61JeKabNwfSWJILWK6Mx3IuEq
	GtJ6floInTMzgR5UqTT75scAArkREIKSaAAO/dchPsTutNX7ljGFpBnX7Pc9uq93+HEduq
	S5UAYFbxZr9gukNqcoNjp4Lgo7S8n+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790325538;
	b=ueDqjnMcFxPjo6IAPZxRJzJrkWCSOH2rmGlSkO1j1lteotPeMy8bvXjbzCeQ8xkNo4FxDW
	ftCpNejQObPGZP0eOumAkKvfd4+reW4fKG/byu7S0kjJ5fiJ14e3xKyMDAz2ZLB6FiPSRa
	1do0VN9cRuCjVXCJUDZ0pBxmZkXIsoI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eJSzp0FG;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=T10y4ASlATCQTgkrEor1JdynVWZNOpt5kzchNql5gDE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790325536; v=1; x=1790930336;
 b=eJSzp0FGzwcDzCSTjLlKyhjHW/VxPOrrcqOQ+lxJL8eLkhsfIp/tMoFm0KTBpcC99k7+HyYK
 6E36iuBoJgG7F5QtOIzy8zxANN68OKeTqzVAR/oj0sRSakEoCpD4+uZ31R0otRvR4bNXLR+aubZ
 bklFo74igl1e36K4McADgXHM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 399a8e667ef4d0d5;
	Fri, 25 Sep 2026 08:38:56 +0000
X-Mizu-Trace-ID: 399a8e667ef4d0d5
X-Migadu-Flow: FLOW_OUT
Date: Fri, 25 Sep 2026 16:38:45 +0800
From: Hao Li <hao.li@linux.dev>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Pedro Falcato <pfalcato@suse.de>, Kuniyuki Iwashima <kuniyu@google.com>, 
	linux-hardening@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Willem de Bruijn <willemb@google.com>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/7] mm/slab: Mark the kmem_buckets_create() context
 as a Context: section
Message-ID: <arYy9z0_ehaVd7Iu@fedora>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-1-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921075820.1718334-1-kees@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6BE0C40002
X-Stat-Signature: 884ytt1jciqfq9p3mfzbbtfusshqpdku
X-HE-Tag: 1790325538-573405
X-HE-Meta: U2FsdGVkX19msRLCULIYbd68erl65IFlmozT1w40g6W9pXFjj8LV9ZIdCgugM9Ql3gSBZx34fZQwUOVsW25kuw2eO/1BKhEBs2lPEQRkpbxbpLwt5iPJejWh2fV13qbGqaxmB1hN+jyFN3o0R74FUGeqBtUkweixBlnZSNfzxojQaBXRouLlQrtpQ9r4PjY/lQfN3IAfMXN4VzNr2/gxOvemCZyIhiJNSe9lUpfBrb9lNiKgnqeVVcFAFUu116PnKOKCthibjgGuVHgjTMEOX8DWwdLyETlQVIFLGBopuSyyFCHzO3Ap32CToGTRfA3+G5C7ybAmlUO0Dfle+PpFEqWX+nWZZAyjVR+gPloah2v3mAtn0K8Xx13J5G4KbGDqGOLCB4lxDJCFmbaOZC5To2/Ft0C5bBZLvEOw0XRSQwEm0s6mPyUMi7Gv6XpDAXpn7Kk28v8fHSTuf5URHxnk1KsUuPNkkIo7YWvoIPBnDskGPdruDwwz9uxw3r8tr9KSVuGq9gC3SEGNfWD6GMd8xf/8k/QVDlg1kA37ECI6OrMXD8gSsL8YrBJHBP04RUsSJL2b2G/KxRfTFWNkMfK1dtIazh6NS1FkxPy8OieKSypg6pgTr3U90UXhbGfroSl03Xx/U453SNyXzo44iNI4p+D5E0TfQlbXFAg8yrdOz20HRbAs1mfNRyKY3h0U12Jwp7DZcbe5Xf3WFqiJSrpapIPKt0juxV0DGBrPu1DlbIfTiBH88BV/r30ND5A0WheuAlJjbChb2gxECqA+iC2P+Tf0apDrd46l+MhYOT1+r8JYxBsdu6bJkRTdTqcPpmQgDzkGxqKMrt0d+DF3OlAqyqqYYAXTq+vfCY3SiCaHXckFPq88JixmlvN5d4BKIyHUHl3PD0KM5K7Ap7zBlcvistJx3wzlnOJJPMPiSY2CUPwFcnxMDSkqfkUbwC+mtA3Ef698L+m60LjekITh+7G
 6VamZyR0
 dFcPbaJyOXoVTkdKi6dM77FSh+RI4a2bZnoIYl/lQ2dDwtx65ylCVq+qNih6uXbJgwK+MhDMM/KR+4KEkjFIFGgvlJv9AVZuqIpEVaGQdZ8xYn8BavmG8eUtjsGOImCn/RN2hX/QRXSSk5ZUBjg3lsu+nWZ8rVTvDSCqfvyySLDGYC8qktv84MSdSGszgYcYXh0/MmZ1XOKxaao3mcX11YrGNjOIkF7dNx96r6ZrKzfI6usxDbqaQn8BF7lS2TJp8qenifUQdqCROpEhEZa+Ky8ibt1bODRxC5VLHIHX7SizfD1e0HCAN8v5ymjOmeIKXXraRJ697z6liGiL8JpRMCf7cqPhnPItQ80mEW+eZJZnbe+82vl70D8/yPQKxIZHORHCGmA1/63RvbWIFYIJx1IcCab5KpTERcRP2BEc0ubVE0XctjcBa8kLt+MSfbNqS9dz9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:58:12AM -0700, Kees Cook wrote:
> kmem_buckets_create() had the same sentence about calling context as
> kmem_cache_create(), but lacked the "Context:" prefix, so kernel-doc
> rendered in the body instead of as a "context" section.
> 
> Give it the missing prefix. Additionally fix the "a interrupt" typo
> __kmem_cache_create_args() had.
> 
> Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

