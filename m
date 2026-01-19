Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE852C9830C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 01:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D31E6B00E2; Sun, 18 Jan 2026 20:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AAE66B00E3; Sun, 18 Jan 2026 20:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7CB6B00E4; Sun, 18 Jan 2026 20:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59E0C6B00E2
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 20:30:40 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0214213B59A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 01:30:39 +0000 (UTC)
X-FDA: 84346983840.01.C36281D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5CD1E160008
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 01:30:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=upRzQ3CB;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768786238; a=rsa-sha256;
	cv=none;
	b=pr2J4WasuXvlSM7OfMuenNwo2NDz0SZjb1GurQIgfgi0JQtVYJDhIzJO5Qq9oxH1aafv5c
	PqxR76bNpisAcpknz7KE0ZvDtnN7j5U9Tu1y+axphxisHlSo0QaX17fW/bDN0c0ybyoY3a
	WHWEiD9+bid1VktZG3T2ZFcHmVLtuwk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=upRzQ3CB;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768786238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqBAupqvJ/KVdORf5wX3J0cp3C6wmOBbPfwDNe90TEs=;
	b=UJOMjDxP2i9vHwuRXtNUOoZE0c0vEePxQwXw9tZu9lGoMTVlMCf1ksJSXxK9wha/qEGhUw
	SJXbxEpBebsqpLmOoedZOjlK6ukNZa+7JOqlY5FelBsgoi8T8WjdxOtsJbONCQvzhgK7je
	Gu9GzYFb/F/MlHOuTOoMkAD3xXxbVpk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F331600C3;
	Mon, 19 Jan 2026 01:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA87FC116D0;
	Mon, 19 Jan 2026 01:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768786237;
	bh=4uWXsuttBNCCVFU/RvHSwM0N/8EI42SlOaD2L6KzBZY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=upRzQ3CBNEWVQpnwzgRd2DT0N26414EOrztmfEEIg1EZbKQsU2sYUPNN3J03IPGTM
	 ykbUbKR9HuQ2HvJhxMlKn5Eo095h0w6Ufy+uKQG7swHiJFqzO8O/XPeNXQk+o0iGpJ
	 2Lpy0wLLWA5c30Q5hhcvjykzQ68Mv3g+bJIRl6VU=
Date: Sun, 18 Jan 2026 17:30:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Audra Mitchell <audra@redhat.com>
Cc: shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 surenb@google.com, rppt@kernel.org, vbabka@suse.cz,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@kernel.org,
 urezki@gmail.com, raquini@redhat.com
Subject: Re: [PATCH] lib/test_vmalloc.c: Minor fixes to test_vmalloc.c
Message-Id: <20260118173036.fd0784f59848303024065b9b@linux-foundation.org>
In-Reply-To: <20251201181848.1216197-1-audra@redhat.com>
References: <20251201181848.1216197-1-audra@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5CD1E160008
X-Rspamd-Server: rspam06
X-Stat-Signature: h7dggccw1sc3g3ipw1xxdc5t1ndi4hgz
X-Rspam-User: 
X-HE-Tag: 1768786238-167990
X-HE-Meta: U2FsdGVkX1+aeJJfyIDgewL1A0Rp+SdVziLpieDKz9z8jpN1fxR5wG5gCuZZlogStrOJxRbItUcwMBlwJ/DOyVJsqiYTqu0JL9ODTaWCqM2joLxCoW1sTLTUzqG4D/1UlEfjrY2qqRWKRpFuw7gAKaQsZyTQVPtLy6BR0+zVgAgWIGeK4S7QSh8UBo+iw4k2XuowK9mt9O+ZyEqWtmqf/tDs1WIrP6A2e5BvPxls0/sqtzO/Y6m9sLp214ak5ghrJZTZucCyDeA4QjmkNOvz9vQ1nuLY2rhHpCav46POpOIyVFk5ij13sNrv4IJweaTPpxsMDFcO2tiQSJ8OgAjHZn3IejecgI2c58/SisPx47GZBySyEtrGp3KmQX8LkL5LzDLzV2m/LFcvzsau0EqbXH86T3I4YQvpQ49AtWtWRJ0c4ruhQcjkFlPiyNhHSc4AHKTElJCfPIwNRCCWx8EPx6kS/oA2UFSoc49Za+nYl5fyA0ZFypn95izsoy2Ks8tvIXHPDJloyikCtMBKQA1LV+/RF6OCFvF5OgZBovo5yJPrt2TeQ0bIHmDISCPNqJsKD3Vuzr9DNvaym/7P3ZLWryEb0OhYNyAfZKk4LI+U5lB941MmomnOyzR1sESNeMP40qH5RkhTo38g4kbI+HnHMQ3+UILtFBRwyOPVswZAoH8Bx5IyjvhNlcwyWxN7SgvYIt0NpKkXxIEW6BoZYRNuaPW2C56Dx6Zg/3yoYrfx+ihB/DJLlwycqeNN5eecY+BWROwTPgVRf6bZI/QV70JgC/vQHmROhG4CFEz9kTo4L6zDASqF6FzhIoWQxmG20flaYhYyP2Z+lgW1Zncu8yeon4JXM4Hp4xsdYkewO8uCvaSp4bb/XrUC9XNOZI7g/9NtviN3bF4OTW2bnXj9qrXMTUfXpEqSq7c+2oJftOmUkDa0j8HP/H1McOOBAte+xk5pqK3F7pB9Qes4oixYqCZ
 vJY0oaoo
 g7kapR+F581j2TrVlx34ooNsJMgPCkr5uVatyniOjBp3clpQI19bOYyY6ZCWifjTHP109XI2oEl0TO2zPK5U1N6/RmAucrZubGwZNkgALeRQQkHbKaf/XJ9AoOi0//bxwlF+QQTRa4+MrBTKiya5p/TTNb5uOMzEk3zfGpPwEWcC7sViRln8lhd45YAi+wylptDCBr0fqGEFegRr7Txt5Eo7tkRrobJELbO3Pbf3zJg9G84Ed6gO82Jd2eZekzFYTPDtVr3VJUo9LTiT1i0oeXPixAvSLSJhOtfB96LgQlHTCmzk2jcFxk/i4c54ERa+KGCYV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Dec 2025 13:18:48 -0500 Audra Mitchell <audra@redhat.com> wrote:

> If PAGE_SIZE is larger than 4k and if you have a system with a
> large number of CPUs, this test can require a very large amount
> of memory leading to oom-killer firing. Given the type of allocation,
> the kernel won't have anything to kill, causing the system to
> stall. Add a parameter to the test_vmalloc driver to represent the
> number of times a percpu object will be allocated. Calculate this
> in test_vmalloc.sh to be 90% of available memory or the current
> default of 35000, whichever is smaller.
> 
> ...
>
> --- a/lib/test_vmalloc.c
> +++ b/lib/test_vmalloc.c
> @@ -57,6 +57,9 @@ __param(int, run_test_mask, 7,
>  		/* Add a new test case description here. */
>  );
>  
> +__param(int, nr_pcpu_objects, 35000,
> +	"Number of pcpu objects to allocate for pcpu_alloc_test");
> +
>  /*
>   * This is for synchronization of setup phase.
>   */
> @@ -292,24 +295,24 @@ pcpu_alloc_test(void)
>  	size_t size, align;
>  	int i;
>  
> -	pcpu = vmalloc(sizeof(void __percpu *) * 35000);
> +	pcpu = vmalloc(sizeof(void __percpu *) * nr_pcpu_objects);

Could have used vmalloc_array() here.  Otherwise lgtm, thanks.



