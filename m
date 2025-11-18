Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B661CEE347
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 18:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D916B0010; Tue, 18 Nov 2025 13:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80E5D6B007B; Tue, 18 Nov 2025 13:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729306B00A3; Tue, 18 Nov 2025 13:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A29B6B0010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:32:27 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1E8C55EFD
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:32:26 +0000 (UTC)
X-FDA: 84124573092.06.B60250F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0DAB3140007
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 18:32:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J7WMpNXZ;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763490745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/RONuXXkpIxDnVTO1UEqsfFwf+Q8f/1ma+sG4qjb2M=;
	b=WxGGIbs49UrOAjhwaUGNPJ6KcL1FuunCWxslM6I1/w7PD1wlBs1fmBTO7CiMSUvc492+YM
	ogLjBNlAD/4hoSKs7+1sAcGdZOzhjV/KdgXuTXf1WEF0CSBfxpKMs7KN+fjNYU2nlBSBEn
	CDN1qhwpZ9O+RxRljkni2LPVR0tvqEM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=J7WMpNXZ;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763490745; a=rsa-sha256;
	cv=none;
	b=TcIVfK6DXV0x5LUaVSlUFx0oLbUVBgLZ6oa5YPSD6Fw+EI6vKvDGeLHz49NiZdWH/VYvh/
	3PAknYdonHgqKstrZisfzfWjn/9jsWSeZDsXrkWhq5H9zeS5EjPzxBJ8876bnwf/dPSHFD
	pJ1VFlnzeeS+oRteIPNFRjg/bJHOByo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D7B7B408E5;
	Tue, 18 Nov 2025 18:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A7CC4CEFB;
	Tue, 18 Nov 2025 18:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763490743;
	bh=DE0kcMePy2pJl8o3OcMbUqFeZaR9LzCeNHAMRPDJESc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=J7WMpNXZiK1uSc+yKSgk9wBVitQ/KMl+AQTrffAKnhkCMTLs6i5mWX/r3VlMj6WM3
	 OSDTtEdv+urqkTzYrbxk/IdJorvK/qdyxkbWE4KpC6yGoZ40kptD5tbnHk39gEAYqu
	 XfN/OIOMkf0e7l2cE+gdxeWaa1R+0S0qT+dKivvs=
Date: Tue, 18 Nov 2025 10:32:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org,
 lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Message-Id: <20251118103220.bd90932096d4e36f754de21b@linux-foundation.org>
In-Reply-To: <51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
	<20251106034155.21398-3-richard.weiyang@gmail.com>
	<20251117012239.lqm33uu4vl4y5zqc@master>
	<337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
	<20251118033339.7rukw7vvjvlbj5jb@master>
	<51358ABE-B0BE-48E1-95E3-C778D1F44622@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0DAB3140007
X-Stat-Signature: mcpnd8s7dqbkh76csddq4sb5z8nmy47a
X-Rspam-User: 
X-HE-Tag: 1763490744-583991
X-HE-Meta: U2FsdGVkX183e3A4+RS3N4SsKy952vzikiV3scbod+VKzPufLbOHN06NIInzwpawAc2dJ0j36V+ssQq+ZvPQlcDcpU8ZKevTOuVsDOaWBflR2UVvaKlwI8haHxar/uY2mYn4N+XhO+7QNCgNp6mePd07xFwyRCnSw0dJCnY+w2Ataqow04chIum6v4oQRYif8Ql0Eb5BTVyYm8iHPIbJtov3r90O26epcItiU1gjp2cPlt8PM07O4wIezokjGlHoU51197SwIOex+DS9FeCitQSIoPY7KGCq9KuIYaln4bPVj8retLHwm7bNlvtBFBvFnP95lLowpH2etqALrgD+qwT4sEOe/qenOxDJW5Pc9Myotz8+SZhKYIL7Ea+8zP6u9ecHHndMHhpUIj59BL9DNDSUZiWonh8YpeugidV8jwS6kEUxcLGVezF0USk9naJKc6RdfmvZxjWveVzXwB3QMWoSpUkJIcVwYGQiEVzq4en62Ej9IfOC15x+O4fmmCYrRFT6OrvE8TI57cM75MuTBBFmI69S0ZuAx7NHA5ww1RAuaBHNdNyTUv/VMcUNfjWdy0VqD8IfWMomfcgYny42jigB9VpbHDzBHj5J+0Lf7o30CGtny6OB98rAhosKY0KfKIoxXvBIyjRSSQZSsg074U5OYrYZNcQlyqgStYVhXVayGP2aOAkpEq8qjnWQKerymKQKNAm32wTh2TqCazwRwxTHR4JpUUHJMYNMQGBYll/fNn1nb2P2s2dFJHdnR3qbKjqmDA+S6Vu6AnEIXSuCcLCmArAyZNL4XWCBD0uyaRByWgCvfboD3GUaC/dxtldiDiuWzglCKIzZWnSjNSKAu3fR/AyQpdDnzNLoe+CMtaHGbwwlO4lULb4jnXdnpnjire/ZBQGVa9NSomoNm7ZOS5vkRijiIg3ApIQxFzvpmoqNz9hlLmbpujRM3Q6QfZqNYMOYqwaTpzcUA95zhY8
 ewXr1Wv7
 So50ttYi65Tdm6+eX95HAiOqCu6DSjW2qXBtZEZ+w7C/obhAY19tX3vbBwDi4NCp7NoqtffDWxQ37UTs3bTGQvJal7gxXKRzZv0RPpf2+scgktwXAgpaPMODzUGekRY4FMRwPssI4wtHwwmP9/h7bKOFd6TnPtkRozGMOEHz04/CcXCRODbvLcAqzys+cAlxk80LdmvyqNIBP90tSeQrAzgRzroJ/SteJxo4zblcdhM8LjiytUkv574Qi4rBS8k0SBmFwfgSurWUtVR7JPB5GiITqJ1zEoS1ZHH7DEsS1Zv/bKCh093K7xafH3g+cj0eCq6kQgxr/+Y8jrJzGcT8OgpVSbFj+OWnWmXcBQXKujOYQlnH1R4Uh8/LlJTBfPO8XPxGUjPx7TYk0CCfhX00g0CVytQFc5IAz1hxz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 23:10:26 -0500 Zi Yan <ziy@nvidia.com> wrote:

> > [4] commit 58729c04cf1092b87aeef0bf0998c9e2e4771133 (HEAD -> tmp)
> >     Author: Zi Yan <ziy@nvidia.com>
> >     Date:   Fri Mar 7 12:39:57 2025 -0500
> >
> >         mm/huge_memory: add buddy allocator like (non-uniform) folio_split()
> >
> > So I think the fix tag should be [1], right?
> 
> I think so.
> 
> >
> > And do we need cc stable?
> 
> Yes, please.

I added:

Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Cc: <stable@vger.kernel.org>

