Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFDEACA5FC4
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 19:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4526B008C; Wed, 30 Sep 2026 15:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B543E6B0092; Wed, 30 Sep 2026 15:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A2A6B0093; Wed, 30 Sep 2026 15:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B8D06B008C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:10:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86F304016F
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:10:33 +0000 (UTC)
X-FDA: 85271369946.12.CAACFC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id E1AA4140003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:10:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jryTlAE1;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790795431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JltDv8XdbdpSf/by89RR6xP1PJpm2X1XeEWjzJovhas=;
	b=QiahLqzUnwT5qrkX/+1ldKigicKNsW9hTZ5ee+KidnxhNSRfRLYx5UTJYAHuaz/WieD2Cs
	kh+SusgvIvabo94eYIVHw2Ne5NHIYcXKpvZdWsyjTRJ/drCB9fVJ8+Vgl01bhU4vt5ABbE
	WI8NgheVgUE1BrZFWUUyII7+fZlSHlY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790795432;
	b=n9EtnM3S2sfJNQpqk3Ze57jCmQGyvfFKrgRyR6CczmeJin49Mo2rEvFVhbdPN6V7WXSYvF
	iF2ulzWftHVYQZMlqTZMHZN+GXodG8pqjlHSqIwMtMBBKuWVZ4Dh3Z2T7g/3Y3p1UcW5zR
	Cn+yann3+Y82wm+0+I32j/qEdBQoXTk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jryTlAE1;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20D7A41B2A;
	Wed, 30 Sep 2026 19:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7437F1F000FF;
	Wed, 30 Sep 2026 19:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790795431;
	bh=JltDv8XdbdpSf/by89RR6xP1PJpm2X1XeEWjzJovhas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jryTlAE1+zr+dk2a+fn6zp9Z9z/lRA/9fbZ8VZgRfxSj+fJ+CqLidMng10tmNNQSX
	 iYAFCfCHEf+F27CU4Tl2ZYAgstIijr+wKO4it13eS5FogF5wdFFAP5Zq2DCGtbIb4b
	 gk47IJMc1WlZLudHU/+fy+Q7qwwXbB3j/WIqtUSTCvIDvvnVu98S1QqOXzsuA2X6PW
	 oxggy1/V73zYIDXSs8mpdyGWCGEn8Opu2eFQbBsQI6xaHq15RGWTHLDxEHrvj3xYdY
	 wqISdq7usq4bjFFHFxxz+2GZBTR5c4D5Z//5vuJ5X8q7l73DgaBEHTQmztTfbB5UHt
	 poI0r0+gHOOVA==
From: SJ Park <sj@kernel.org>
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/ops-common: fix age_in_sec overflow on 32-bit
Date: Wed, 30 Sep 2026 12:10:25 -0700
Message-ID: <20260930191025.63561-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260930115812.138864-1-jaeyeon.lee.dev@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E1AA4140003
X-Stat-Signature: gkys6mjep9fdhb9gyds5y7xqyama8q4r
X-Rspam-User: 
X-HE-Tag: 1790795431-742667
X-HE-Meta: U2FsdGVkX18DqZpEBzwFDWFAaoJtlg9dMj9e9bdMDJC+OBI9QA0JStGImQuBCcfhxZGI+GypgWKnFs7qfTIwMqph3yOSgFa5aIYWPjLIFcwAZKBxK+AOOCvXnrwAH3fccZn0+Yf0SmCCBR4q3+OaDNrCwydevUDiHtErfUr0Qi/2ubtFzHlOWh8AXh69D8915YqX+pwl5GF4lq5amNsDsolew6/WZ6GkPqo38TKuFDIdBtY2sGQ/Qme/dVBc13ZnGB8OD5BGZ953L0FMvjiKm4sAHh6Vd2VGKvPJSPFzV+mbT8gf21kUNgINKYxbGUIkvhoE0Yy5DLgSW7L9WZ7xrbaEdBrNI66RX35wCw+qPf2FNZDEyElKPixW7h92sFhYR0OWrB7k1zlpsWddQzxYSNDJ4CwC1K/2bVCHOjqU5dAEQWA0LqwFUxAARldT1imkgep9xDWWyHwg8ECgjDSwgZHEmxB0OOUD/hEPdqV7x0SUn79KTi2oKrESCHqpjRcFAXy0KUgsO7LRLHvWq9XHY1rlOlTU9P33f33K5J+GLHPfi85wr4gH0DtfJ33AmhO0PPkLe7umV4soIL7Pc64DOLy52bBSR0NIgr6pEHC9XSkx083bWVyyqqNp8U3hr0w0veLVqrLjnT9n+ef+NuKO8+2otdwniJm6oCCzm/2DFPP9j05j0HLf6AuzGqSdT6iQpbhOGuO+uPUY26JiVG5CgrK2+DZZFEvzVMKfBeNe2VNM5MCBCJGD/IPINV3+TPwSfHzof0wSY+st0n9pcRiQolLySN2y4PcdSm2wuhIcmvVx0pSKoGzBKmDJhy18FQrjk9O+L8pBiEkmgqgbq0jWAlL0kagJAk1ZcjCeQWLJMm1O3rCtzzvV/hl/WASIYiQl0kyDER1fIEpzHT4hWc1Yh3FZcGLoiOP13+xtZTBFWjD/Rxx7VCvhS/6TXnFvw2zJR+waIqIAdY7T6eESDND
 0O1YvD69
 rBUOFOVMLhlsAFLbauoqEJhOvb68mFszOhs9+7xAnZYu4tglRCBgq2E1+0FpPY28dy+xauDDoyyh+SXsOj4OqxjoZ92/xjZWDmTMcq1HdqI14rmFuC07PNapiliGhAS7wyOZBUtKLHzRCXfy+EDq6XFMIV62O/wctolNdYE4vY9W5GJ/cs4TT0ABXewNhhzcXUthcpKQhtig1Jnjk0ghIFFqi8P80FHGbq22FvVfxjPjER0Wd8jU6UYnVYXb78uIvTXaNy32njY4KEUg/g+B1C4EfI8mGonnYfHsdtCnQgU17J410g9H28vOkXDmDp6wj1qCDTg7iMFFGs8exW4X6FgWc93uoS/BCf3YBh+rql72pP66LzT2UEWn28dJb/k7KcP2OMbn6bBSOf5RRHikylF+8AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jaeyeon,

On Wed, 30 Sep 2026 13:58:12 +0200 Jaeyeon Lee <jaeyeon.lee.dev@gmail.com> wrote:

> damon_hot_score() calculates the age of a region by multiplying r->age
> and the aggregation interval.  On 32-bit architectures, unsigned long
> is 32 bits, so the multiplication overflows once the age exceeds about
> 4295 seconds.  Then old regions are scored as if they were young.
> 
> Fix it by doing the calculation in 64-bit arithmetic using div_u64().
> Also make age_in_sec u64, so the result is not truncated back to 32
> bits.

Looks reasonable to me.  Thank you for this patch.  I'm thinking about if there
is a simpler and more complete way to fix whole possible 32bit overflow issues,
but that shouldn't be a blocker of this patch.

> 
> The issue was discovered [1] by Sashiko.
> 
> [1] https://lore.kernel.org/20260623011652.1354-1-sj@kernel.org
> 
> Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
> Assisted-by: LLM
> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
ping me or Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

