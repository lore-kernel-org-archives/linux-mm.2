Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C5CCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 05:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6082D6B0088; Wed,  3 Jun 2026 01:02:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DEEC6B008A; Wed,  3 Jun 2026 01:02:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B9A6B008C; Wed,  3 Jun 2026 01:02:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40CEA6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 01:02:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D17961A0241
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:02:30 +0000 (UTC)
X-FDA: 84837405660.23.BA53BEC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3C15B4000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:02:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+RKWqMk;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780462949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4sJhmtviZHBbmBaKNClEQj/V4FOUrUEB3D970WV899Q=;
	b=NUBYz46V4NJb9TCELKS6IQ72VHORda4OYjFMytBqH+5Pyre894gI4a6h+Z6udiSm7qIUCO
	J18mBcs3Q9SVSDhAiCrPY7U8GRVpOuyfHi212kq99bhIm1IkK/qBR5ym53sLz76TLwL+5p
	PIs7Dmtr77AiA5eWJEBGHt87nJTuoGM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K+RKWqMk;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780462949;
	b=2BrkCv21mYN2+YJwsKY2p6kc8ZdZfc6hcSqyvTj4OPDpIG6KRnQ3+vcEVuyepD/1STZTLb
	fasBQ02UCa5RumrSpd/76JnPj3oFEMRqT9+OSESj4cSKRHuKBE6lK2oGZUu2ON4sMq7ZEb
	uPp98HrvNqz1vaEQZoTC2lqWQEGF+bM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A68F760216;
	Wed,  3 Jun 2026 05:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9C51F00893;
	Wed,  3 Jun 2026 05:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780462948;
	bh=4sJhmtviZHBbmBaKNClEQj/V4FOUrUEB3D970WV899Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K+RKWqMk+jTeJ5BUw1Mjx/ggb49btY5HQA5mm+Sh/UIoiRQI6hiU7QUvIr5C+FGRi
	 GNFosr3VGPP5K7hgIweNsn36xIsrAXTrUwsEAFuHJemOSJTYT8S8BQmC+dvpknLScT
	 rVYB95PUEr02nDW/Q2ZzauN1yu+KtpJM+nrA8hjWo5MWaPzEi/cN0swbcqgCn79SKz
	 GE6Mhy+qGaO9aNpPOGcEC4j7DOQ5llS+vQjsTHLmoDMt2D4ZOYF+iQr642n9cGLk4C
	 E9W9oAxe0mI1Y8QA4JSWbUYWDUu0lwEbWM+Y5TepMcAK0h1sFQv6l6e3a8Z63wMsAY
	 sjDrtMoCpIyMw==
From: SeongJae Park <sj@kernel.org>
To: "Kunwu Chan" <kunwu.chan@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	shuah@kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	"Kunwu Chan" <chentao@kylinos.cn>,
	"Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 0/3] selftests/damon: misc fixes for test bugs
Date: Tue,  2 Jun 2026 22:02:17 -0700
Message-ID: <20260603050219.91743-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <38c4d77974349f9783478a04c46df6f975d41c84@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3C15B4000E
X-Stat-Signature: 451yad497y46ai96wzjwyfu1b9prr898
X-Rspam-User: 
X-HE-Tag: 1780462949-795592
X-HE-Meta: U2FsdGVkX19eLtFv2Zad6L9oFDXybUX1AEzDUQM+SQ4BUu4bbZxWHgtZxowOiHu2tpJZvW2udlnP9XFzAZBl7JHTfIUELMcAJck3VmU5BwMfKgpCwFIrG4iDYyqW/6IYMdwvpX8wDTzq8Kr+pBN56FI+IVXbIxOhVis8AHb3Mq483Bl+o29F3GcaqGC0SU6wkVtxr/srMR2fsDwoQJKAU6wrwiMmRvtocMB/AmEUsalY0vWNQ/o9ztZRl8ARJWw6T7yZxuB1FGwKvj0miabrq6lteeuSBDvOfqaYZkMHYv7AIOgcCWuLDse3CvRkQNXWbfk78j9M+JlswsVGKkYk6m9yZNdt63N3NPz162fxiollEnrh/Q2KoKRQm4pevhasaGOlpETAZ/TRj/vVB1q0OySFoC3JY6Te33waH3ceGjoXH6gk8fIA7cyiSqKfPKYu49xZPTzaSLj2PWMtjS7mP0/gtI2QIiMn/GFKFSLCnPS/skAEI46ntkAthKUP35cca6keQLWhSrzA3I1sHP+Nrr/vr3tJKW7kIpWz2cyhprdEJO1kHi81OFagH4F+mwVK4o9Hdkw3dzzIi+GaagxlOJlOUIiTQn1oJV/p8/GFXJ73hXUS4eB7jqzwgSLHWk+Avq6YCTqswtjKQXQvYxlIQB5ffKJP7mWSgn3eHHK2bebj2XPpyxJxXGQv6Hr+f6RGx4LRIxcMFWVquSMyjc7BsDZumOatAFOAHHELYvXppek0fIRtIWK4A0jr01bi6WRC/ckMq0pjB/Ir3zaGExNBONzff/rgQaoT1WOPrU9WGmDUDF/6POsv9tjdVmjmCzqVCZYGEv6OQRusfE5V/4Q+Ey6QrmZMxL/HSdz68N8m1lsT2u9eVzUQUYlgwH9cKKaufg0Up5Rm0nN8b0aZJny42P8pkhv67fHKFjrI3fWJMKGmnr/qHo/YNg8AHJcoi70bppL0XlP2MBfSTvuC+kc
 lO5C8+Fq
 F7yfZ3id4wltSSjkyUhOIBnRJMS+XMbioB/Q5SGDkOH/oJFSWZgsEkWWCVTTC+h8ZT10l8micRIM0fW9jF2fkQZJOaXKD0Z/LwNtFz52Ijb6CiEXTE6lQFfWcvEFlbR42El8sxoSmfl4PaQHrO22vDk7eIg1LiuLJpX9kHN5cff+s5E5x2pId170jdcJ3q7KxsOP0Ec5Rz/cXRqAtJWzEk2H4S+uDYtsmheugl8g8uf9FDxOqUQv8ThpcrWYAxG3q9YXS+P+qwgOF3ITdlOwD/VAzyfXVevwbEyMrYsFkT8bW3jwAzCfDeAq6iwfz/8fTjA+sRHSZt7zZsto=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 03 Jun 2026 02:11:33 +0000 "Kunwu Chan" <kunwu.chan@linux.dev> wrote:

> 2026年6月1日 22:22, "SeongJae Park" <sj@kernel.org mailto:sj@kernel.org?to=%22SeongJae%20Park%22%20%3Csj%40kernel.org%3E > 写到:
> 
> 
> > 
> > On Mon, 1 Jun 2026 11:23:11 +0800 Kunwu Chan <kunwu.chan@linux.dev> wrote:
> > 
> > > 
> > > From: Kunwu Chan <chentao@kylinos.cn>
> > >  
> > >  This series fixes several bugs in the DAMON selftests. Most are
> > >  trivial but cause tests to silently pass when they shouldn't, or
> > >  fail prematurely on slow machines.
> > > 
> > Nit. Only patch 3 fixes a fake test pass for "avail_operations" file existence
> > test, and the series is not doing something for slow machines, right? I think
> > the last sentence should be updated, for example:
> > 
> > '''
> > Most are trivial but makes test output wrong or even silently pass the one for
> > 'avail_operation' file existence check.
> > '''
> > 
> > Other than that, all look good to me, and already have my Reviewed-by: tag.
> > 
> > Asssuming you are ok with the above change, I applied this series to damon/next
> > [1] tree with the above change. If this series is not added to mm.git in short
> > term (~1 week?), I will ask mm.git maintainer (Andrew Morton) to pick this.

FYI, we are now quite close to next merge window.  We want to focus on making
mm.git more stabilized and therefore ready for the next merge window, rather
than adding more changes that no really urgent.  I understand this series is
not really urgent.  Hence, I will request adding this to mm.git after next -rc1
release.  Let me know if you think this is really  urgent.

> > So, no action from your side is needed for now. If it seems I also forgot
> > doing that or you cannot wait for my action, please feel free to directly ask
> > that to Andrew.
> > 
> > [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
> > 
> Hi SJ,
> 
> The updated cover letter looks good to me, thanks for fixing it.  
> Thanks also for applying to damon/next.  
> No further action needed on my side.

Thank you for confirming!


Thanks,
SJ

[...]

