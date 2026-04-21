Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFC8F8FA9C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 16:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB656B0005; Tue, 21 Apr 2026 12:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2526B0089; Tue, 21 Apr 2026 12:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C86B6B008A; Tue, 21 Apr 2026 12:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C06F6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:51:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD63D161018
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:51:05 +0000 (UTC)
X-FDA: 84683152890.28.BFB3DE1
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 105251C000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:51:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ocRVBGVN;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776790264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kRy357BEYeRJOQyV21O6a1nlzehotRQ1w1skfD7cr0=;
	b=uj01VPvQR2M7do6b/11lPANkS/6+9AIeC8FaiZDQ0g/uPKPNod2F0nIF0ynHUfoUuq8X+S
	Muvt+RA3vFajsphUmLGP91GMD9ab3hj1RGBp+OfforBH+C4PGILh+hai2HUTW+dYFmKIXX
	TIFT78S7rAB/+PmM6r4SKiIG2qzGDbg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ocRVBGVN;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776790264; a=rsa-sha256;
	cv=none;
	b=Foq+L19OWbNhY6Yapu4Jw+cM9C2SFIs/hARXHGzogMFDScc1NGfev6EqWM1DPstmmKS2dN
	NzDTPL7gFqVTUvKoLmhMLxefOnYnZrhWEraXZCqhKe4HSr0QpUeY7sr5IDvMSL0YjJJux8
	3AcaLNRq1N6vmUaEM8P7fCROFnb/C0g=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8eae9229110so361145585a.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776790263; x=1777395063; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7kRy357BEYeRJOQyV21O6a1nlzehotRQ1w1skfD7cr0=;
        b=ocRVBGVNa5roaIr1R0VYIj4IKVb4FYn4nGbCwmHos12OZBGlyuccvXPo+Paz48KVDt
         tlbBMqWqpC0979X5h4BsWfMg0uw2W7i/6zeE9ZJRZZi7IpG6Wc7FkwXqVre5IvNJtGrU
         rhTOy+9LBLKi/vpbYUrRyqKfLcN3NZQ7R9wp3skSIcw3aYhxyVQrXuOsxRARmrBey5an
         xwhK/i+37u0/qGFda1yWx8k4FrLVVeGzMWyY3FmAoKHrMYz6mR1e25jbATMS2hQzBbzQ
         QX2bGCO+uARGr51J3q9HSuJukS6b3l3VyORlro0xQGH/BAwqqXC23OLxAa/E+rNhac+Y
         p5zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776790263; x=1777395063;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7kRy357BEYeRJOQyV21O6a1nlzehotRQ1w1skfD7cr0=;
        b=P9q5qbtdpbmCG5Y2n3EtH2nAYfWzNPOh8CHkAzUArbilyWyLH4472PSTJFDtsQM0iw
         IoERxtbWetNlA3OC7kcVlrHYR2DXNAlytnPz5H2PCME3JKPj+I5k83Ddwj0vYEU9IcT1
         euCFVo/uVESChb2V6TLJJlsc4ceJAYFvKU9kb6YWbdDLpxud2JqoOXGH4jyqgg9fopDc
         YSnG7XHeXubSI/B/Sd7zgamDnwu6L6jvdyt0JvbXoWpeKohh9IDhS83ohUR1M7zy5EnB
         CB+ZO9EuzQZC20/ghh1g5ZoZrLFvP/wOQtwtIUsoJCdRrJkuWbEFqZZKXQUApVF9c4Y2
         L9vQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Ca34yBbOB+vTB8Q5HvELNE2FGD36+nE2wy7TmKqj2b1QOkZmVHppB3TNQe+UoFacyBWUQsmDOAg==@kvack.org
X-Gm-Message-State: AOJu0Yx3JzB0Kt2fTivltemMIT+agANadOLQ4KS6G7EigrKUYLXtgX6m
	T5rxWKGw/YRDzpBSuv5fdpRBxFa6znr7/9by6Lf5JYj8VH5Ffm/TPgFZI79FApegEtQ=
X-Gm-Gg: AeBDieufqMpd07v51GHDPLiL4doj1pS0eT87oNRULWTYt4hr9BVO0UlkUj9tv9VZpsI
	7AmmYid8XwZrhjD1lq4zwg5XR/xmELN1/ZRcYXBWNTvkcD3WnIaUxrPGtnf2LJs1T0ERkcpBX1q
	SKeiHB8VGNxX+maPAEs0SjzGMksjqfe8M/iLp6nF8L4o3qZdA4RqEIloXrCr+zJukc7wF3+QJQz
	XETELiErEbJfW3XfcnN/LXYJEI+oiIv6G69Z9m7v+/RK8YMUhQxKcGf4nyEYXOOpAZxOLSdq/pH
	KRkSDuHf6aEVAT/c2mjnKhxLtPWk66zDuAyJyjONy+r+e+cYa1Xemfcu4A0dYnUTTuTuyRTpfoS
	t2psrNHY+BUQ4xIrw/rTV+qeEDy8HVX2HU10YAXjeHzI6tI/eyfis+Lkn9R8irVLEf70OaXK8Ak
	Eh8M5N7XqiHsJiKYhD1Xae8ZVGbQ9s932YUXqljSEdaLw1QHwUXiAG0edw6gAeasKPp/1+t3po1
	1pFKFZJTA/SPM7BMaYTc1KWcBkG9gE=
X-Received: by 2002:a05:620a:40d2:b0:8c6:b247:4c with SMTP id af79cd13be357-8e78f059609mr2654868085a.2.1776790262990;
        Tue, 21 Apr 2026 09:51:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-246-228-50.washdc.fios.verizon.net. [71.246.228.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d93c2fffsm1070867785a.36.2026.04.21.09.51.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 09:51:02 -0700 (PDT)
Date: Tue, 21 Apr 2026 12:51:00 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH RFC v2 00/18] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <aeeq9MUrqL6f47Y-@gourry-fedora-PF4VCD3F>
References: <cover.1776689093.git.mst@redhat.com>
 <c199e47d-b2fd-42f3-9e50-c47c848dc72f@kernel.org>
 <20260420192037-mutt-send-email-mst@kernel.org>
 <aebjG-qMLr0joG61@gourry-fedora-PF4VCD3F>
 <20260421090341-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421090341-mutt-send-email-mst@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 105251C000E
X-Stat-Signature: 8rsob3uz9psphj9hjrpqe1a9ese5wib6
X-Rspam-User: 
X-HE-Tag: 1776790263-715520
X-HE-Meta: U2FsdGVkX1/eQpufS4QwM1w5Di1TqvL5rDVtEZ39oqDdhsilKv3ix9LUKmKPEL32omm7lbOlQQbShHlNtJCodp5J8Xw/+Sm8uCyTf82242a+Ygzc+Yfs4zSiDlc9db2aa4bJC/PMCwpVKcSDbVYFOwvhyFLcwMidCLDMK4iRM7+P3bXGiwPS5mFnEAumQXXW5vOnigi0QCkXeaPhTEgRxYZ/YTkpJ0cEUnbDV3dnT93Qyy1qmCVt8KopbHOTpKYGJoLW1fB5xNffB5/At+bgscTRUY6nXyk13EjXuJQP5qiz6VzhPkcJqu0VLlYgLkqptY5sX6tygLC/EQ3P0L3rTauC0WsXeA74fR0vLf2Ub6rxiZd/LXcETR34Yjsqq1GvBneis/FYkUZp7zZEZPaDRgdhO5mHiH3DnHxH3US1Ep2+BEoHHo3xlA3v7ydUMOPGVgcMJ5jtRY2hmTw6j3Ea4JAC5+j6TgLxYupOgyybCrmeycbiifkymGZ38ZgClsC5CBLJ7vcf4oDWdhdsUI8jjc5J1sG89+DmVpQQojcD1tMqzSqgb2RfTG6BfyTpGS8Hll5x3u5IEJaGwDtOb9vTHPxOmYOHy9blUJ3tdoOlvJ22834JPnzAmKc3SME/aqTYSq9ZrV39zDSE0lLHzYKMM1rXL37vpcYReMC7lNG2frea++bUHp6B/7uRqX3zULBAQyaa395Ed0/d9PCMQZyyacnPIB9w5cClIFBoUrgTl0nw0klIsR+Qm62vKdrDourrgtB9D4j4z5KW45s3TU1zT/n3E8KooPGV2JqcnculsTtifcMqxoWM9u9kMDn2g2YEvM95cFiSCUAUMkOBfWT6O0DOHaIoB31WIQkJDo41iO+HRg11Xv1Ma8ujVAXCsWzPTWat3rJCIzv+w8+QAq5HPDoe5Qg1wAIaLbtED+7bXB+KJPwW8OcN6VEqEZgL47gQ0HCB/yck0RskymxT9j2
 UQttNfrY
 uCVccKIa8nRc5aiL72bDT3cSTLs/Ty4kCLANPbz2OZuWYZYQKfO+MdO7vc1l+N4rtUeXYn1Jch9YdGJSyAudr8Hda2jzFRUyUstn45Z/or8KtoVrob9xuvC4bJsd9Ds1zTXJkKMOj8rVx9xA0jNqHCJD0q7kv4E4MOYTxyip+LXrHk2Lvk6VFiInHDSEN/Vt0rnqTzorboP/MUX9Nyu5JeFONrznLZnh/HtRcpD31KOAo52bh0b0OIDUFlbOWlpEH1ft8m0oM4Vweqgp7aYCRMU3Q66e61c6joZIa6ad0dBkMwCLS8ITtNxpHtnFHnmSceU3t97AriTgDtZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 09:06:00AM -0400, Michael S. Tsirkin wrote:
> On Mon, Apr 20, 2026 at 10:38:19PM -0400, Gregory Price wrote:
> > 
> > Can we leave folio_zero_user() callers the same, but add a PG_zeroed
> > check in folio_zero_user() that skips the zeroing (but not the cache
> > flush) and clear the PG_zeroed bit?
> > 
> > Is this feasible?
> 
> I do not see how - this would require leaking the page flag out of the
> buddy allocator.
>

Right, but you're leaking that bit of information out one way or another
- whether it's a page-flag or something else (pghint_t) you have the
same lifecycle problems (when does it become invalidated? how long can
it be trusted for?).

I suppose at least with (pghint_t) the data (in theory) falls out of
scope and doesn't live with the page - but guaranteed it just ends up
polluting more and more interfaces.

I'm seeing why David's suggest to plumb __GFP_ZERO correctly makes
sense, it's really the only feasible approach here that doesn't generate
a staleness problem with whatever information you try to leak out.

~Gregory

