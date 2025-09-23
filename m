Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D8ACAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 16:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8675E8E000A; Tue, 23 Sep 2025 12:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F178E0001; Tue, 23 Sep 2025 12:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C268E000A; Tue, 23 Sep 2025 12:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66E638E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 12:15:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13827C01D0
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:15:04 +0000 (UTC)
X-FDA: 83921014128.22.72D7327
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 39BD98000C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:15:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758644102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=od3W27UP2d4Dd91dUdUX5opiLkersdSVw2Akopacp7A=;
	b=MXSUIwJyXbeRJxOg7X7XW50o+xMwmFEwERKKC+YQvweEafFxcBwn8RQGZingWo0XeCP0jo
	xv7eaDvj0p4Z3cF5zxVfPlgHubRtyT+3L2aP/kpmU+ZFDJ4doTNcYUvdjkcR+zUQ69wf9l
	aV9n5awbkAdQAecICpBmQLSzeiXjMZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758644102; a=rsa-sha256;
	cv=none;
	b=bL6z8QXmVYWylneXZ9a1WKdDwMs3I6oi1sEsShsIVASjHbf32XkgeDjA/Tmyvruz92zFNo
	z6/6K8K/I13KkXOb8gAvpRJavACH4GZtL6lQgVc5Vjo3RYwC4thiVIeS4gOxU34VOXjsTM
	gW3uJLxl354ozPjkaLmBQadTrc/M/+I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9747844A33;
	Tue, 23 Sep 2025 16:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DEEC4CEF5;
	Tue, 23 Sep 2025 16:14:53 +0000 (UTC)
Date: Tue, 23 Sep 2025 17:14:51 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, usamaarif642@gmail.com,
	yuzhao@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	baohua@kernel.org, voidice@gmail.com, Liam.Howlett@oracle.com,
	cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
	kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
	dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
	surenb@google.com, hughd@google.com, willy@infradead.org,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, qun-wei.lin@mediatek.com,
	Andrew.Yang@mediatek.com, casper.li@mediatek.com,
	chinwen.chang@mediatek.com, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
	linux-mm@kvack.org, ioworker0@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
Message-ID: <aNLHexcNI53HQ46A@arm.com>
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com>
 <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
 <aNKJ5glToE4hMhWA@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNKJ5glToE4hMhWA@arm.com>
X-Stat-Signature: 6apa4tfb9ez9rd36cmcwkzreipwgp3mp
X-Rspam-User: 
X-Rspamd-Queue-Id: 39BD98000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1758644102-936611
X-HE-Meta: U2FsdGVkX1+b2v7V868aGka+Cqtf8bx6m46cZtliSNYPVegw7de/4jY34SLcAwweAadgDv0t9dXQtdyBqvyZgMXAaJVZonoZs9NmhdWqBst4dp2N36e37xjmNCB10wk1GzzOZlgJ0WTsBS/gk9FCdhzu+3dGpSmrWjBmrAj++tB6PPCEbrJpvMcChwRppaJVdUGJCZoeKRy2caCTCNMpCp+0lWYfM3zNuS7Joee5wkK8ccNZMsExuD3cztS53VS4UlC8hXw+KlT9npHc7lciIvjObbVkUQUq+6ikQP164NuSQjw3DCg9jWFQvR4NfONoZYK/NgHnhDiqWj9EoB8UAfOR4hbs3AEMRU9g/vG/S5g7ZV4+bvxOXdu88vXR0vTtBFDNrcSybZTHt35V1jIz5TlpF71aQ0QmdfF/eOgl/+nLQXKuioAhxJDRV48TzGXfbYL1kREIyq8nbWNylrvP6j2o9EX1vdb2hZp9+EINbrMzZkXQhdIgh2s3gxqOLaPpB5qprpWL1hxJz4lbK/YJNC500HoAxfTwTC7e9F6afWfrp9Wp436wRsemwS9+mGt5JcCSTIWdKCfJDWyhsTJq5dLXFeNqW1aZm+aeN7Rwg+L+d7CY/YFWAGgEu4Pws5nJHCuIBbd43nffqDkpnXdAcby8Cp2gbKb6mBvd1aobM6JJMgygpwgsNzgVLsZzSP0JsM+rg0uuXwEFyqYOMcppeBvKki2cvSE7CK4mIMg2yol7ExfXWK1bEyBG3nUWDQrcgyBs3se+f5k4Se+OqvGQXNSCNEsfSYRRe+IIypNL2fcISJ7WmZP+9tQuuFIlQk/F5BJqLhH6fINwmYFiNX1p493raxMM93CuO40CseQdZuYc5+wkHI9cv5uVjqNnNT/qS8FJhCn+yJKrxx7K+AmEffDGF/UEuusyMjFKsiWfpvvhXflQGQCh+1ZtXngqH04khtDKCwOoed8++vadcQ+
 W89NHqOw
 9Fbx7pJYOoaY3dO5rPYvMQDufsuHlMWrTbYwmKKbr3xjCL9WD++eqVJxiSEfPuNhGJAqfkK+3Q2iV/tfPbIO2VW6Ekh93HrC1KKpDR3+O+KIK51vlY4wt8BU27XxE/zkqynmZHGRJMaorJVJ0ubbqt3wSQV6Wqlqf9/vVhfFu5aFJA1lPySCZz8V3YaV3DTH616ZSCO3dBVFuV8HultMxBI92VRn9CNIMxeZ86OZTax4i6l8IvuDBR4s466QdfbtddDwuOCSNuIwWHSj0lzGtya8uJJeND4G3pVLbbuawR+fmsplWL9sMrgW279MPNH9Eg62Xlu0DqLhDhvDRd4s4ifIANgBbWgWSbmsk2A2pZG9Wxs9rqW01Bc8nNs4oocclWK+rvjR80d6M/ZD//SWxzmVnRk3Ts6Pn/90O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 12:52:06PM +0100, Catalin Marinas wrote:
> I just realised that on arm64 with MTE we won't get any merging with the
> zero page even if the user page isn't mapped with PROT_MTE. In
> cpu_enable_mte() we zero the tags in the zero page and set
> PG_mte_tagged. The reason is that we want to use the zero page with
> PROT_MTE mappings (until tag setting causes CoW). Hmm, the arm64
> memcmp_pages() messed up KSM merging with the zero page even before this
> patch.
[...]
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index e5e773844889..72a1dfc54659 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -73,6 +73,8 @@ int memcmp_pages(struct page *page1, struct page *page2)
>  {
>  	char *addr1, *addr2;
>  	int ret;
> +	bool page1_tagged = page_mte_tagged(page1) && !is_zero_page(page1);
> +	bool page2_tagged = page_mte_tagged(page2) && !is_zero_page(page2);
>  
>  	addr1 = page_address(page1);
>  	addr2 = page_address(page2);
> @@ -83,11 +85,10 @@ int memcmp_pages(struct page *page1, struct page *page2)
>  
>  	/*
>  	 * If the page content is identical but at least one of the pages is
> -	 * tagged, return non-zero to avoid KSM merging. If only one of the
> -	 * pages is tagged, __set_ptes() may zero or change the tags of the
> -	 * other page via mte_sync_tags().
> +	 * tagged, return non-zero to avoid KSM merging. Ignore the zero page
> +	 * since it is always tagged with the tags cleared.
>  	 */
> -	if (page_mte_tagged(page1) || page_mte_tagged(page2))
> +	if (page1_tagged || page2_tagged)
>  		return addr1 != addr2;
>  
>  	return ret;

Unrelated to this discussion, I got an internal report that Linux hangs
during boot with CONFIG_DEFERRED_STRUCT_PAGE_INIT because
try_page_mte_tagging() locks up on uninitialised page flags.

Since we (always?) map the zero page as pte_special(), set_pte_at()
won't check if the tags have to be initialised, so we can skip the
PG_mte_tagged altogether. We actually had this code for some time until
we introduced the pte_special() check in set_pte_at().

So alternative patch that also fixes the deferred struct page init (on
the assumptions that the zero page is always mapped as pte_special():

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7b78c95a9017..e325ba34f45c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2419,17 +2419,21 @@ static void bti_enable(const struct arm64_cpu_capabilities *__unused)
 #ifdef CONFIG_ARM64_MTE
 static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 {
+	static bool cleared_zero_page = false;
+
 	sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_ATA | SCTLR_EL1_ATA0);
 
 	mte_cpu_setup();
 
 	/*
 	 * Clear the tags in the zero page. This needs to be done via the
-	 * linear map which has the Tagged attribute.
+	 * linear map which has the Tagged attribute. Since this page is
+	 * always mapped as pte_special(), set_pte_at() will not attempt to
+	 * clear the tags or set PG_mte_tagged.
 	 */
-	if (try_page_mte_tagging(ZERO_PAGE(0))) {
+	if (!cleared_zero_page) {
+		cleared_zero_page = true;
 		mte_clear_page_tags(lm_alias(empty_zero_page));
-		set_page_mte_tagged(ZERO_PAGE(0));
 	}
 
 	kasan_init_hw_tags_cpu();

-- 
Catalin

