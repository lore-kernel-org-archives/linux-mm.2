Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A13F01825
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE6F6B008C; Fri,  6 Mar 2026 06:12:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 968F06B0092; Fri,  6 Mar 2026 06:12:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841C26B0093; Fri,  6 Mar 2026 06:12:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6FDBD6B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:12:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F51259312
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:12:05 +0000 (UTC)
X-FDA: 84515373810.07.6B9C8CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 750B71A000B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:12:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L1xVmcrj;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772795523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wl2tJoX9jibHX/UMVQo+WSBvQlBet4fwxgPPN7jHsIc=;
	b=hKIyZolXeJxfZPw17eFvKkIcTOH/AagCSc2uBK6ztFqHl4fqQaQfDIlbRDd0SsXYaSZ7LA
	l76koJMCpx3IoV/ScH74eCF3DxxuMY2T3KOY2/Mnp5oTD7spv79VQdBYj+MSzkthsu6nzq
	64jL9zsA5Nvq3p0hGCRdzgGFKGuWxyI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L1xVmcrj;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772795523; a=rsa-sha256;
	cv=none;
	b=d5aAdIA+oL3h0XS/qERx7t8Vw4iWMyTt7rqa55d7aspttdqBwFx0Rg1jJ6msb8fdZkChON
	j9i2QQEK7/+obv88ItvI3Ke4plONCXi7Gzi9MSd0Y4OoBUyq2Hy9g+JynEhnYpUJ99acAF
	8xcCSsDTm4WuMR4piWvpVV/WhWJYTRA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DDC6C6012A;
	Fri,  6 Mar 2026 11:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B95C4CEF7;
	Fri,  6 Mar 2026 11:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772795522;
	bh=bGQPv3hoIx+/WP2tckqxP1wfRPx3+N82EsJdtp7ro1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L1xVmcrjSvLrgHkDWnFdpLhM5EkUuQo+JVlT0s5xnLp0DAhNsaITOZnaG4LxedWQr
	 fCKye6WWvwjQVW5XxY+wXSRq71hWJ4Oa3nCqtZeOj3UhoHL9vVHdGltdaXAYIQ1gv0
	 nA3yeBt7hhdB5fBjhdof3Z89/pRwfjrW90qye5BkLJsXf64Clz7q85jQLUcgK1yFSJ
	 pZ+vLH5YL3wNFQq41/bYDmXr6vRVp4nErnsgvEtbJE2EIXYb/Xa667KN40IUeuNTOP
	 651FUjIHAXOlu6nk/elNWoGXSeoXUFvEC8dSMcL0jWA2bxXhZCOZA51MVNvylkSvRe
	 MnglMHCg34Nwg==
Date: Fri, 6 Mar 2026 11:11:59 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Subject: Re: [PATCH v1 3/4] KVM: remove hugetlb.h inclusion
Message-ID: <305a98f5-0a28-4eb9-a647-a30716e61cb4@lucifer.local>
References: <20260306101600.57355-1-david@kernel.org>
 <20260306101600.57355-4-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306101600.57355-4-david@kernel.org>
X-Rspamd-Queue-Id: 750B71A000B
X-Stat-Signature: dzqij3kprefr1rixfzcydx174w6oa9ik
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772795523-509248
X-HE-Meta: U2FsdGVkX19GINwtbpKxpgUm8rEeOQXysIgQM9dvM9J2KBIBqh3M5X83IzfcWSasOGaLriWHBReWDdJhhymJ9Gy2rl+UFMVrZTeidi4acQ49bptHqthGKl4uJNanWeFpXXxOxMv8WTbnRaJTqAIWkYsX/sO2m2ut5HGR+p4jrq753/x2weaYwZznE0lSZIo9+dO7Mj+if5QTqJJH5gOOGCTQJkOc7JcqoWFGeOlmgc5YCEZtA/MsdIHm41Nt0XP3XE7yFrT6EEWNy9iUq4YOOW2ogbKvvCM+r1p4S+M65Kh2+Hh9GztixX0UT5TxCRqlLJaZzIlEiILrp/te7R4vXDM0fJ52Ee2h3urqIDlilk4ifhEUEEJ4pW2ku+Dn+cOfE11fmMfnB4n/90oYnjGQ8Mnh4X8aNdNQYcifg3sHg27saM7aPjps2Z/RMVpkmpHNqwc+BOxh2dNd3bxrA3z2TIcUOKOQJEhiAqVVPmtDk/+i/J6tUTKo2t6t0ZHKV1AD1ku3eayHZpOxXk57L5aoGs/c3K8Ws/12bp7Bu832UC/0IEgH5Qwsk02P4CVx8xO/x5FQqYDgaXgH2mUeoKb8iKx4WcTIQ9Jxh6qmlWZK6UGnigAWH4/LHggQBjDiUXnUzHjwWvfcbVvJREo8gvUukg92ROlZpMDMct8aSyEdkiX9hbqR2etjoYmNX5n7doWytQlh9dZVlwCgwx724d1C5OSRptuFEtsj+PNgpAafAQzGhgSxmRnNHuWERGBCzzLJJtWz43Pc/4/6gixli0cFO4WXQ2UjsorbMY6bLfO/CZujNKx8Awc68tjiURsOXT4n+dA0hNesp5XxH1W6QfT690YhdBJ9Gl/fVNp2bDHD3WumsPs2ImTy7NOVZu1k/Fbe3sXYXqzI7MMH2SWsnDyHz40OnqpzSObXgxIy0kGq6aLW4zDId5Njlho9oPlBlfoQfGrg4UpyqjoE1ejJR1R
 3caY2yAm
 dphnBv9lSJgXk/Y4oNRhFZtVMU66+aXxkCXj2nFQjCM9ZM1436iecbXOPh6slW87HNudKbwbdnvm4aMrOZxR+B2uiP+biIcDZuJgrfH5owXw74YSPbJ7V31ryqbH2GA/7HxEslukc2Xx8Fdt2blPOjEJvwvq1UsdmGsjgHH+5ze5wuLzWVETHqnG0nSRduAqiZ+vJwGKcfBHZAjxSFBpTq+eQEhbzrf4CPQa2jYGR5MZOypCT/Yo663chQoVVbRaUllzMFnZEDogVZPeYdJ1YPJ88LqYWU/tNjLzirsDLD6A19Vk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 11:15:59AM +0100, David Hildenbrand (Arm) wrote:
> hugetlb.h is no longer required now that we moved vma_kernel_pagesize()
> to mm.h.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Aww this is the tiniest cutest patch evah!

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  virt/kvm/kvm_main.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 22f8a672e1fd..58059648b881 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -41,7 +41,6 @@
>  #include <linux/spinlock.h>
>  #include <linux/compat.h>
>  #include <linux/srcu.h>
> -#include <linux/hugetlb.h>
>  #include <linux/slab.h>
>  #include <linux/sort.h>
>  #include <linux/bsearch.h>
> --
> 2.43.0
>

Cheers, Lorenzo

