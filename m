Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81488CA0EFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 08:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7774B6B0025; Sat, 30 Aug 2025 04:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EF36B0026; Sat, 30 Aug 2025 04:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68C5C6B0029; Sat, 30 Aug 2025 04:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 588866B0025
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 04:51:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C213311A040
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:51:15 +0000 (UTC)
X-FDA: 83832804510.05.8FA4C46
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf19.hostedemail.com (Postfix) with ESMTP id 496771A0002
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 08:51:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=GuMcrSCS;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf19.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756543874; a=rsa-sha256;
	cv=none;
	b=VlO9IOe/JaKhb6yrhx/QMkwtziaWBbBsMfaXMVWJpo+M3Y99V3YwjFtASaT0GzhaPAbTsI
	knieXTZgVrCDJgTsmgYjHs4ky+KCEtQObJPkx4GJRwXvZtN4RsVidhpGwLBF71wwUHIxYw
	rokmTWq9U5i7L8yO1hGXRKhnoAzDlLI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=GuMcrSCS;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf19.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756543874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvJAs0oWctTv+IZjXYqOb/DT/digU3gWo9ZFZvSPVF4=;
	b=60huBMLBHyKlDEg71qOQYL3FMRD+dHY6KOv4G/jlVQff9/EJ0iV1/1vHVYVzXaFTdeZCNg
	9BpDiEkCed4HwajfKQFm+ZlzmvyMeSGz17PCYiNkh2YpQRKAiNdjxUe94MYRBWN8Ac0XvB
	WPg+mCBUcMkbI1pxiXOFDMcr4p+959c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=XvJAs0oWctTv+IZjXYqOb/DT/digU3gWo9ZFZvSPVF4=; b=GuMcrSCSc2h6K85gbh7d/Dq9GZ
	qdyNHDeRuMDOrQKt7Bo9CsxZu4fhi8uxonjr50DYybHV+WdJ7DHOoy71QzTrH5fU3B4gS3MrLLeJZ
	1yb0tB9r6ZBYeK/9cTotchZKYSs9UNaevFwWoiFaYrA1kDvZB73V07IEjWM7icXmel06ejOyu5tRM
	WEVmUV2x3M+JWaNqJjuInd5prsC/KbA4Dm0FGrf3ZmC4vszTKkk+/5RVJ8rZbwzjF/v6sclO9TSJ8
	zA89ssT/UNPKwDgfBFykggaqbG5N2LfCnIeOoYXu2AZxIIqU3jrjVfeakPWp8OpxRJWoq6dq/+xUB
	J8hgQp0Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1usH32-0017AV-0k;
	Sat, 30 Aug 2025 16:50:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 30 Aug 2025 16:50:52 +0800
Date: Sat, 30 Aug 2025 16:50:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 32/36] crypto: remove nth_page() usage within SG entry
Message-ID: <aLK7bP285OO83efR@gondor.apana.org.au>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-33-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-33-david@redhat.com>
X-Rspamd-Queue-Id: 496771A0002
X-Stat-Signature: 8zk4xwm3bx139hbogpnopfwickq6qnjn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756543872-261874
X-HE-Meta: U2FsdGVkX1/K2rbvaHRtlW2+3bpDzcQm0dvWTW3TfmDA/XhEhhrmQrjfV5i+kO9oMEK1jYhuK2kA7Vv+mig9RftDFM/G/Ex7e+tr80e8uPj1bGXe6vixUf6pmYa2V79Bww6CbuSYV+6JqLhr/DTQB93lbFp3RJAHZBs4OV+RCMV3gs7lP+rHa7FnTzIeowCdB2nh2o3fzA+TqyF13twsgD/g1zSpu/EmexgIYsJkgLHYSxwP/+UhHn2aHr8nJdxcWk+wPFc8vyYgYAWM1VtTqEdA7rp/I2v2mV9dHm5gMpUEZjJthYC31S8fByPBG65b8P2S4ezKfMwrO8m0RPYWH4KJ0hq4CgJRfJaQCsaWF8vTQHeu2cmMu2tUEKtuBI1wiKIs4WRMBBwfh9rn+6TWhGmjLnxGvgIYieLrCskO/rvPhZ53CdlCFXw96FvBa9AqpCWK7UiMewV7YLiOvfMgDUzzSfA480fmpsFaQLrJ7wonjGPhITRSSneiglpUMl4y4NBRTh6WWjku/Bl9tGqkq8uU/qZyh38njtnvg0cPjXSJk1F8Kx3KW21H/8lQmDXph9VnFwD6mwhjwTHgz8V+qm/zum+2XUqdnTTveE6jInvbJKecqoP+CD3nu24n6ibK8p3yNS2GiBeQKn8hwokDKuQc9uYfG36cq6M9Y6w+vwqbN0H7eM9/WzbPPzFGmvIDTURYb+1biAQCbJ7NJHMFZBqjmZnRDM6skcYZ1fVYmDBXsMUvxGJBaVuzHWFexoR0CQla4h1sCV/y6Xsrg4hnlkkmTjWCW9ZepMGOMGizz65/jtXV1OVpEQ+u+OntjyoCh7AIQYD/zH8q/Mva/ZqCGzaDp5WemoAgPuR78Jrm51X4EXBF4aZ4GYwM8vgNrN6zkCZ3qMVXUYSLDyZ3OCeetSkYBuowMHfRJbaj6Z7LVghAEtqneZ8hU/dymaLFX8krldcRHV7KY9c4i0Hyus/
 tt5LL0oq
 DFdrdDEqxtK5A2kxd8kKcrcJlu6VjHf4OTcGCrUlWTMzG2L05tEN9ZliktjQqDK9RwUnK2wgTkms+DJT6d0sSdJ56VKZaa4QUYbKXFVoeUlZIo8jKmmpY+mtB1SPoM0QT4eB5O/wdiFR9GqHRGn7w8+8qXWJhQyUF1R/6GBXedtiFjHwsuufw2cVo943c9JbGzyxtvCy3KEVFZ8wZwd6JS1Mi6y2awiX5zfRRXp9TC4oHaPUMAvw1WirXNOtm8qvhPLmlMYBBT9sldP0gitLWfTrYFD1d5xYUe2JcFQ6vS1QQEcCOHpb/gZiFuq0ouzSaqhFJWobsYzi4IGW5MNKs+8bDxjwWhoT/oWLfN4D4xOnOE2uDa23dxT9WZ80E7wJFgNARYOdZwJSVYIw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:36AM +0200, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  crypto/ahash.c               | 4 ++--
>  crypto/scompress.c           | 8 ++++----
>  include/crypto/scatterwalk.h | 4 ++--
>  3 files changed, 8 insertions(+), 8 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

