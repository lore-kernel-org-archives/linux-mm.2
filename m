Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196DDCE8D4D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EFAD8E0014; Fri, 14 Nov 2025 11:35:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A02E8E0005; Fri, 14 Nov 2025 11:35:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567C88E0014; Fri, 14 Nov 2025 11:35:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE108E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:35:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18FAF140456
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:35:06 +0000 (UTC)
X-FDA: 84109762212.24.52BB98A
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	by imf27.hostedemail.com (Postfix) with ESMTP id 073F54000D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:35:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=AR3YdPu2;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763138104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LlxEA3NA0HAOLepjkYcqMX4f9qaGo/EYMxJVR02SMAE=;
	b=Jkx/pMa1c9FnXxGpnxGwz9EdGOnJfu1OUDR4bZkpldBvhUIoTKOr/4fFByaYJJ7TteGyLq
	KvdBOWl6/gMug23RgRlexoRKzdn8vKUzdMvtPqpILqsV5BI7pmg9I0K4XYJkdE9ejtawRz
	Vtn+4Gm2a99KGsAe+9DAH8i5D5wXnXA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763138104; a=rsa-sha256;
	cv=none;
	b=Ihjx7Amij4wwexMbHO2qsYnmj4KvflBsrH+oS2H90XyeBiZVa/VPmHwyL+wVJG28+LzZ4k
	XHBsNHF/Cnxqc9YQtlmSmKGn1g42ftF97Kmzy0A+AIzhXigwbNUmiYifnfdbrMTHTJQiw5
	BDALwNNqsvHgnmCd5jAXQ2r/pEwNcVg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=AR3YdPu2;
	spf=pass (imf27.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1763138098; bh=LlxEA3NA0HAOLepjkYcqMX4f9qaGo/EYMxJVR02SMAE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AR3YdPu2qiGKhuWuC+u7TqbFqt4ZbGQfYSC1b6hxXM10C/yiYiQxS6DCmZ+Mqo12c
	 WUaKLzjLP0ww8v67icHdaMeBfMsHG9zqgUg22v6GUNALpVdWXkZJWmUArVXxra6Bfc
	 MjiHx1DfIVeqwfFhsq2T6ztN0OdfCQlQfjkWtbrA=
Received: from [10.46.175.116] ([36.112.3.158])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 8B806648; Sat, 15 Nov 2025 00:34:56 +0800
X-QQ-mid: xmsmtpt1763138096t8d2hxzsg
Message-ID: <tencent_DFDA2D92B8F69FEF149FE7593DBC47B46E09@qq.com>
X-QQ-XMAILINFO: M2SvzgchpLqfEL90zePQbt5GZL2do3GXrz1Ba9+0CFJXDFKFtORXW6vOQ6kcqo
	 6FORzCN/oyOKc4y9WnO6hkLykuMWKjUXrZ5tcUqE71k5CNwEQj8mCYtsXPzhplWWkbeTkIOJ9HP/
	 langL1r/XwpuNUHup58wN/AlogUjw9DS9Dt6bnxk77iNnMMBbnzrsUNpy54NVQWgl3b7yKGDYNsc
	 5CVFQcjqB4uVXxO2VANE0HaqtmkjnPGcgjYiwO4LxR8pLI8TO3ylGKh1TWC6kBttkNquM3YiMr70
	 ceKxxHVpOxCl5rArQU4lddMG7qywr/1O+CPzGpd0SWEFWxiI9K0hCLKSDK6vUeLK6gR6J18jvjrF
	 L+c1SqqLRCp73+VuvEgZ9GwG0JhHk0GiTO84/qVQuCswvIgzybWH0VhIxz9xhTQfu9viqA/NsQo2
	 BrLKy1mV+yJYIAf8r6uJ1ywdsdaK85gaKGqwgHiAjxQ5rM3rb34drroqBjOFL0uyfWO+woPAmKz7
	 Rbrw+awoOzx028e1EWdLyygaz5t/4qws8SdKVlodGxQE1Fv983krXTDIP83IHcRODNNlD1IUsFB4
	 pkLEFY8tjT1M8c7/eoIu3FEPmH3AvXTIglKKCQnD4c1ClrbhRPXZVG5J9BIeGmwYmCuaZPHO2YZX
	 6rnBqAMTzTh5vM+iLNGjR5wwV5qGIE9t60+4LkZnYOki7jXyaOHyQj7lT7SZpsP6Zt0G/fxiv00I
	 jR3WJQZX9DVvBQDDzZmuu5B2p5hnKzg3EgsyeR6iDvFZfhCuLp9AJrEqgszIkfxmgkZPb6hJdm8u
	 cg02lAcBKgIECerihRXm4W+5KiKZj4pG8/FAazT+LJNJkziq5QpRwopk8SN3zFydIMO1F20NL7r5
	 SsTazkNRzQ5tCmi0oHQ51L8U9yFeU5nrlgQbjP1XiYkALNi0PcXsMjzxWwiwsmrFYzQVtXafg+tR
	 +zko64BFMOjhKwOnr75BxchK7r96zmS15Aguf12uv8iZijPGa/2IrmQQ6HpsN8qyKHAgRDVOFeHg
	 ngMMRHQQ8pgtV0Wdi3
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-OQ-MSGID: <89d29cb3-5813-441d-b643-734140f841a0@qq.com>
Date: Sat, 15 Nov 2025 00:34:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: optimize lowmem_reserve max lookup using
 monotonicity
To: Zi Yan <ziy@nvidia.com>, Brendan Jackman <jackmanb@google.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <tencent_ED235B379E160A5C2BCF688ADDF3921EC808@qq.com>
 <DE8F7PLNB92Q.1L2EKEK4C6TL5@google.com>
 <912CFDB8-6374-4428-A0F2-29FB00E6ECE2@nvidia.com>
From: Fujunjie <fujunjie1@qq.com>
In-Reply-To: <912CFDB8-6374-4428-A0F2-29FB00E6ECE2@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3z59c5rsw6dfw9umedraagdiob5q749x
X-Rspam-User: 
X-Rspamd-Queue-Id: 073F54000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1763138102-665507
X-HE-Meta: U2FsdGVkX1+otBC3osOmLgIToBEBwdnZ6dIejgUxN4p92nhyQwcidfg4cjx7rwcV46ktCMWCXor8sg8aFGFTXm0tgqiMQmNVt7nkmBVuPbfL5rAS0Q74Yxi7fFiBjfZtAmqiCkvhtdMlIhMEJqYBqy9SCynvbcj9HYjRjMGQZ1VaUQee7DnXB/vZNI96fAMct8F/LM8tHqAh7VRj2aqvaBaI66OoEJm4t8bITOfZ+At6DZeOdUHRK8f/q5HKHGtU+uz/TehbkJI83v1y2dq/+ku5D3uyCHk1Aw0Ym2BNWPgHJwOA4tbQEMq22yK3KYeMzTVsxPmcF31P2ITdNpROf7f9Mo9W1NniXkZRovvXoBb1tYLfEORbSF1dn7QSBrNNuRazDNC8/z0uXo5bx+hQI8Pe5hX5lgcZ8FzMf0Hudl4PJuson1bamXFCSrylWkGsvASaxAot+zdK0Dvwyl/W6Z+oiK8mwLkmQlZ/LizpuiPMUvTfcBD+rnIbMOrHvRchug3/Lp79ZQIxKB+OPLvWkSwW568OEAwSYlV5W3I621+u1hPpZmsuCHn4+edhU0LZuGDvLDEIuNe3rUDgCpxG/g4NG0nM28UqUcjzkgw2ya2y77LQpAfjPWAcc822zw4gz/gQuFpcM4EAzUoAowXCJjz5WSPKMWr1r7hVuXuJbgJJ3trpjgIE25yaMdlN5kXP/3cNEMoHbo0GIpaUyE3k4FTJgB0/sQ+Lwq0LCYAlGp+Kk0jApJgqwhtwIjgUTTUFtTYwPwWjLSP9awFcGLFWa+XltBf6pLmz++f+AZJ6/Cd7Sdp60iST0F2XPxzSPwF8/C8AaRuw/APvxhoOcuZSXeO3WzrQ6OnlItUyC3KMKCaDFVnWt5L/6fv7KsIHQwwdVh1e0O7bqK3kLSw725csChuF8cr+Qz5jsUQggbiGCxKYuWVxsfcO8a1tsxStYERY9PyFNTjptxVyY5mLltR
 mv9y3hJS
 UgrCeqUcea/kJmOfVK7Tn5E7Yo8YhjUbL8oK2dG4bBoaDhY1vLPd1kFeH84nynZskhsFJ5Z/luQ1Air7KcUnnQPocEVX6CTxr7moMjmXsCBWUVJlu9MeKroe/OIUECO2jC4ZWyWBKvZhEoILQAr6BSttTBoJZd3bZX5XXCbRtAAEHue7KxElDABVYxVcDXIHjgz67lrOuRK9JYmvNgG9Y1mXGmnycQpUoaa7p5UwwRmBQq8HWEFe88+3OuxAZPBGJ7Ql/69Pd/hFwOIuig//y/zVQ07GyTNtRo4P7uK2IjCoqn5cgpgcojgxbiiHjlMpADJ0Grbv/XSr4vvA/4msRqurzt8KVsP5A0XfihnFyXuPDQeZgC8vUSHDQGaQBHLVV0DtUOXfwijij9okLdNEXXFLehfwsr6bcZjpd54NgoTxpeiw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Sat Nov 15, 2025 at 00:12 AM UTC, Zi Yan wrote:

> My concern on this change is that the correctness of
> calculate_totalreserve_pages() now relies on the implementation of
> setup_per_zone_lowmem_reserve(). How can we make sure in the future
> this will not break when setup_per_zone_lowmem_reserve() is changed?
> Hoping people read the comment and do the right thing?
Thanks for raising this, Zi.

I agree it would be a real problem if calculate_totalreserve_pages()
were relying on a fragile detail of how setup_per_zone_lowmem_reserve()
happens to be written today.

What I intended to rely on is not an implementation detail, but the
semantics of zone->lowmem_reserve[j] for a given zone (with
zone_idx(zone) == i).

For such a zone "i", zone->lowmem_reserve[j] (j > i) represents how many
pages in zone "i" must effectively be kept in reserve when deciding
whether an allocation class that is allowed to allocate from zones up to
"j" may fall back into zone "i". The purpose of these reserves is to
protect allocation classes that cannot use higher zones and therefore
depend more heavily on this lower zone.

When viewed this way, the partial ordering in j comes from the meaning
of the field: as j increases, we are considering allocation classes that
can use a strictly larger set of fallback zones. Those more flexible
allocations should not be allowed to consume more low memory than the
less flexible ones. It would be quite unexpected—in terms of the reserve
semantics—if a higher-j allocation class were permitted to deplete zone
"i" more aggressively than a lower-j one.

So the “non-decreasing in j” property is really a data invariant implied
by the reserve semantics, rather than an assumption about how
setup_per_zone_lowmem_reserve() happens to be implemented today.

setup_per_zone_lowmem_reserve() currently encodes this meaning by
accumulating managed pages from higher zones and applying the configured
ratio. If some future change were to alter that implementation in a way
that breaks monotonicity, that would likely reflect a change in the
intended semantics of lowmem_reserve itself—at which point consumers
like calculate_totalreserve_pages() would naturally need to be updated
as well.

Best Regards,
Junjie,Fu


