Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3E72FD877F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135E56B009F; Tue, 17 Mar 2026 10:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E72D6B00A2; Tue, 17 Mar 2026 10:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0241F6B00A3; Tue, 17 Mar 2026 10:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E54FF6B009F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:47:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D50589885
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:47:30 +0000 (UTC)
X-FDA: 84555833460.12.93F4423
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 00E5914000E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:47:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZDq37969;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773758849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTYjSkXSseflRhA4pO4chunRfiS1yM3xejc0KOzPZCM=;
	b=cg6eOBlzQfr7tiVuWcpnWcTotHykHnU7g92sjKQUAQciQnL1G7mWgO+mMjjwTp1LzCCMGQ
	SscIVNVWhjT/dfGyjLqikUpxKnArn+J7jFJ4i3A6dSHqtg3PandGo/+NO9cfulKb+Iazzk
	xhe8L687R0X1+a7lKyp6ulv3Kov/oSc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773758849; a=rsa-sha256;
	cv=none;
	b=EuJzch9HgjUS8aMveLmELR8bOwuRnAPZSih6JKCcj4GrEB+r/o3fY5FgWIW1g3UnbE3pPx
	RxlpGdmcv0pdSmZYlFc7qBuCrB2+2I3y24aoMU0YeJThyx6H1F+JyaaoDXCA7UkupaapuU
	epYteYyFMSVOOr8SK17xK2JKvf13yUw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZDq37969;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F5C2600AD;
	Tue, 17 Mar 2026 14:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107F4C4CEF7;
	Tue, 17 Mar 2026 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773758848;
	bh=2ceXF7k1cz+eNiwIK9YtDL8+tk9HAHG9agGbAGaVGg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZDq37969ypAziqaAbBH+62/kfGuMDApezgt/9hRQLBa7ZwNhS+YeD7L8SItHdwu3U
	 EOEQF5ufrv51nIsUGFg6wFRphmBw4pmh+OWiShTo6Schi7yiimtok2F18vh+Tgn2fA
	 HeO4MEUcyVCUd7Ly/F3hhW5l2lwh5Pud2QOJtoQVbkQRxkKt4BFVd34vBj6vtNz/6C
	 sPgRBanJkw61FfXGycTXjtOwN7DteVEr3edS4adxl4xCgq6xnffQv9aBQ0D8HydX+Z
	 z7ToxdHjl/7GD+R+07URdiT9xIUxISPBGxTdWPfNbR85DUnM+YyTAidiZQN7gkWFNC
	 4t7r2t5XVjIvw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/5] mm/damon/core: support addr_unit on damon_find_biggest_system_ram()
Date: Tue, 17 Mar 2026 07:47:24 -0700
Message-ID: <20260317144725.88524-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311052927.93921-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 00E5914000E
X-Stat-Signature: 1z5qr5ecmjarrun5zef5dea4kt75tbxr
X-Rspam-User: 
X-HE-Tag: 1773758848-780560
X-HE-Meta: U2FsdGVkX1+buoY4+rfb2Kpotr9OMXFxT00JJgZ6Qb5bileMlssjdtZIvNug5icgp2zoaldRBbuJjxIgfCJm6k+2Rx3yqesRNq2wlpC+SZ05lTrAaFAFNYNzTLFz1yEfUHWY7cyJm0LIWUwDJVbcPwQ78UIhykqoOKk1sXXuWCysoWnXDsibrny6vpZ2XUHVB0I71m69rNJJB2t6HiydW54H/ijdC2C00rPtSlQltZdZXK7hjE4iHd44AiDkBMYMy+kxNrWhvCP1oacVarRmeclNbJh3ym9TauuTPkSXFT67UlzkH8QRntNG/u+Y5+aOJy08a6tpTmhjeX2DhCfDK108v4rKuX7+PIFO50ksr+RSIz7CNubN5OnNHCP1DwP7bHfCeiQy6cUHDAHXOBxW6IWzVZKbFHVBR1HOauPzQYJGrVvYAiPfcga5qu5Lrl/tugSlXjS81fnY6cX2aEo5Ku9mlGd2IzpE5o3QOHJE5QS2cvBj3SZjF0GqHErfD2y2zChKUbqDtt8PVMQMaFpz2zcPDeXlEapQQ0yZo5KEmo5NWnySqmx/0rwIJreF74FdSYNJIo2z+77O2q7XGsW7lYW2SIxaFzznbZGQHsNP1nDLIWawXBMyJSahqwn/oVGAjkFQ+wsdKSIwABOMQs3lgk5VePMM9dQ91ORm6lH+uvbLcQBo+nqjq3GtB5VyYyLlT+I1IvT7jWQzKKfmozw9sX51GZffk9yRUnzWeavamThE4TVWMtDmwQwsKzJ5cBI6M7lPDJcHOjTpcCmECmQgmP7nfGie+/1lKcOZ7MN0z7FaJJtNjBE+9ghptVJW6CkOeuuNOehFgUwJSmtiyfOn8i5LmWv/Q2c75ufBJRP7CYbc0BYNKGdX1RrXwzAogsNczK3REwSh6mWCLSEIt4vThMrSJ5qaHYf0c46DUSpw9EEtq3wgDWpiUHKGfsdaaS3q+GwACbXZ7X6/SCMJHQ4
 yUgogoe3
 ekBdee8yF9122QSRC3L7z8bvXKEXQ8XRlHplccBfIkcXmgTgmAGhdUdOkY4Dlbrj1vNgq8EGgMJEsyPaxFg6fYPXAbqHBTSvR/vyNkc6kUXLSLd55zZq8xJmaKAIzlzKiIL1A5sJla7DO2A8BWBHoyQPQ+xu+ZN+g0oZco1yZ3weZIgMn74DRK8zBRoCEKmN87c6JGqyNVEFJQErmdAIAy2X7uzCsVqyYEoOSdGLe54ycaXbH0/q+ytFHSCcXcQHos1u5qulSF9zM6Zjk74o6cnyTZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 10 Mar 2026 22:29:23 -0700 SeongJae Park <sj@kernel.org> wrote:

> damon_find_biggest_system_ram() sets an 'unsigned long' variable with
> 'resource_size_t' value.  This is fundamentally wrong.  On environments
> such as ARM 32 bit machines having LPAE (Large Physical Address
> Extensions), which DAMON supports, the size of 'unsigned long' may be
> smaller than that of 'resource_size_t'.  It is safe, though, since we
> restrict the walk to be done only up to ULONG_MAX.
> 
> DAMON supports the address size gap using 'addr_unit'.  We didn't add
> the support to the function, just to make the initial support change
> small.  Now the support is reasonably settled.  This kind of gap is only
> making the code inconsistent and easy to be confused.  Add the support
> of 'addr_unit' to the function, by letting callers pass the 'addr_unit'
> and handling it in the function.  All callers are passing 'addr_unit' 1,
> though, to keep the old behavior.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 3925720a172a6..aee61bf991baa 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3056,31 +3056,44 @@ static int kdamond_fn(void *data)
>  
>  static int walk_system_ram(struct resource *res, void *arg)
>  {
> -	struct damon_addr_range *a = arg;
> +	struct resource *a = arg;
>  
> -	if (a->end - a->start < resource_size(res)) {
> +	if (resource_size(a) < resource_size(res)) {
>  		a->start = res->start;
> -		a->end = res->end + 1;
> +		a->end = res->end;
>  	}
>  	return 0;
>  }
>  
> +static unsigned long damon_res_to_core_addr(resource_size_t ra,
> +		unsigned long addr_unit)
> +{
> +	/*
> +	 * Use div_u64() for avoiding linking errors related with __udivdi3,
> +	 * __aeabi_uldivmod, or similar problems.  This should also improve the
> +	 * performance optimization (read div_u64() comment for the detail).
> +	 */
> +	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
> +		return div_u64(ra, addr_unit);
> +	return ra / addr_unit;
> +}
> +
>  /*
>   * Find biggest 'System RAM' resource and store its start and end address in
>   * @start and @end, respectively.  If no System RAM is found, returns false.
>   */
>  static bool damon_find_biggest_system_ram(unsigned long *start,
> -						unsigned long *end)
> +		unsigned long *end, unsigned long addr_unit)
>  
>  {
> -	struct damon_addr_range arg = {};
> +	struct resource res = {};
>  
> -	walk_system_ram_res(0, ULONG_MAX, &arg, walk_system_ram);
> -	if (arg.end <= arg.start)
> +	walk_system_ram_res(0, -1, &res, walk_system_ram);
> +	if (res.end < res.start)
>  		return false;
>  
> -	*start = arg.start;
> -	*end = arg.end;
> +	*start = damon_res_to_core_addr(res.start, addr_unit);
> +	*end = damon_res_to_core_addr(res.end + 1, addr_unit);
>  	return true;

On 32 bit systems having PAE (>4 GiB physical memory address space), above
start and end address could be overflowed, resulting in making an invalid
address range (end <= start).  The range validity should be tested here, like
below attaching fixup patch.

Andrew, could you please add the fixup patch?


Thanks,
SJ

[...]
=== >8 ===
From d5654a6cce8a21ae100625ed54c0885556f89645 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Mon, 16 Mar 2026 23:32:48 -0700
Subject: [PATCH] mm/damon/core: verify found biggest system ram

On 32 bit systems having PAE (>4 GiB physical memory address sapce), the
final start and end address could overflow, resulting in returning an
invalid address range.  Verify the returning region.  Also remove the
resource validation after walk_system_ram_res(), since the validation
means not a lot.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f9854aedc42d1..339325e1096bc 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3089,11 +3089,10 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
 	struct resource res = {};
 
 	walk_system_ram_res(0, -1, &res, walk_system_ram);
-	if (res.end < res.start)
-		return false;
-
 	*start = damon_res_to_core_addr(res.start, addr_unit);
 	*end = damon_res_to_core_addr(res.end + 1, addr_unit);
+	if (*end <= *start)
+		return false;
 	return true;
 }
 
-- 
2.47.3


