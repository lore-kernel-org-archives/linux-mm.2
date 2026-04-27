Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD788FF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2A96B008A; Mon, 27 Apr 2026 17:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3916B008C; Mon, 27 Apr 2026 17:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B90C6B0092; Mon, 27 Apr 2026 17:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F255A6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:12:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A50D7A02C5
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:12:44 +0000 (UTC)
X-FDA: 84705585048.23.5B4EA74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id F376E1C0007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:12:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=z+zzED3c;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777324363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=equJOQ0vdg5l+arNNzIA4HiHhJm87BuekAZGbqqIel4=;
	b=VJ6APsf7uAxX3clMjvkLBDNR2GEwwwv0/WInrdQxsGxbnaveQX5PT2MbSkYC9DCB0Dj8LL
	RsJ6FdIU6orTuNKfXUBWmmVrEmt84dYrq2dZE4bU5akUVGxNqMDGXfLaIIpBx4tJMixu2L
	vY8vVv+xJIdg6/JpZ3M0np3iWlnu3ns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777324363; a=rsa-sha256;
	cv=none;
	b=mt886CxwEI8aC9+9EQ68onKNT4ZTQnE1m5QNA9dm1I2HFHLV0MIw9X8r72Z5xSDOSOAxld
	bsoYMYbPQEkqLQoSwUbB7f9xygOsUgqj1v6W/uvlCaM6oKTaQFif0YVQBoPzD23QhzuPhs
	N3pG32P9156g+ueFOiIh62W1paFdEas=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=z+zzED3c;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D1DC60138;
	Mon, 27 Apr 2026 21:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA34BC2BCB5;
	Mon, 27 Apr 2026 21:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777324362;
	bh=u6C67Kw9adNNGEeAM1JS8iVy7lXopdEjpI80kouBaiU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=z+zzED3cbjR9ADW1kvtCE5VIDVhfyroGD1k9WUAH7hWopMwpHTUiMj+z0aCfbOatz
	 XeaXtTEBpnxcOLChc0EQIK6Ec8DKEErb+Qfswl/QLQfeBZEhz79LIo9YvNDeyxay6v
	 rZAU61VgQXfNzTSEx8+8fkRI4fVN/nee5QCwC4fI=
Date: Mon, 27 Apr 2026 14:12:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Catherine <enderaoelyther@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: fix subpool accounting after cgroup charge
 failure
Message-Id: <20260427141241.83dd1445d8ea973c3a5d54df@linux-foundation.org>
In-Reply-To: <20260427151934.88683-2-enderaoelyther@gmail.com>
References: <20260427145247.84157-2-enderaoelyther@gmail.com>
	<20260427081213.7935edd49d96622b08e81643@linux-foundation.org>
	<20260427151934.88683-2-enderaoelyther@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F376E1C0007
X-Rspam-User: 
X-Stat-Signature: hrqo9pnu7obgt4uwf6yruwxbo48qyfcx
X-HE-Tag: 1777324362-422447
X-HE-Meta: U2FsdGVkX18V46xY3QX1eqNwzZ5rPCkRVNx1N8VWtwzzuR0WpL+tUxzEeugxRpkW4rATYmvstlKwg4GG1iO1RZdBi2uKGyuAw7JdlsaoRo1qoX2t2oBCB6/OQJZsgdr1KjvFQyBI8A7i73BSXifGDi2jd9CI+pmqkCFwzhZ+Q66plVoV1EQuewPNIzwOhSUJqxG9bvMisCCna1TDuxJ1EBA+GUIZUiTw/Q63ACOjZOo+fUKvDlvzw6P08aS1Nl0CHrgmX0Wh3q3QuJs7NMDAAmiLvEjzM0oSN1xJBPL6xDnKds3FTz//SK73V6rIhOdP+rvdM5JsevNlHO3KLs09bzi89eCxNTE73c7EeDhfZJ2d9PVvY2NzEpk5p+hNWrISjPGvO7rZiy1U8BxF6HyQ5MthRVO0xCAvzD7651mDEn8rl2bO+sO0/iS0jrB2Jgxt0UoiRFEb33vqZBUrxbkmhRHKs8gYiSEre4z+9FuoM8/m78R/wyvzZlsYGIsI5KUp0q/M4wDtoQl5QkZBswVM2SKSLNfEpHEICCfsr11tnsPdwmuD/cljd3iVXS1asXQtv/hCkRqpivO3+T0dt03QgPByWloXs+Uu+vEP/WsCG5GM0g5H6PAPuelhoX9i2bpOx3wpqcHXaVsFnLdVm3F1gJdnjO00KKbyWNBDWBEBgfhVLsT6+WB3sHgm9fne0RWHTFb2XkqDmx7BtkvcjfgBOOSYdihJ4MSWW+LBvpuXRItgEZUnjomHkaP9vrr9dXImKFSUu2zmUhWp+LmVT91Z3WC6WYlLx0xJ09YiD3fj0wWUbEQzlGZvlSMHTM1V752jDWBDzXBmGDn3QLrJh8MLJD91Rdqq0bI5Y5b4zvfs+Shsm0RbD5d/XgCk5YP4ebqk7syE9Bv5m715Dg9iHv/mO6HtrlDgazShAhmgWk9MPiRZzk5rphIq0f5jVDh/8SnJATtcJmdhiQobCtIKopL
 eURAOUz3
 Su9i5llFCsdWL8nNpyh8RW1A/YQTw1wPCf0ERsXXMws7jcDlSldtTLVhOxc1JOwWE+cesEGJCUkj8lemE9LXNzvPqeGqkBiavLW+Sy1i4lQYqd8mHLCp4al2zX2KtbithYayTnJWZuRgLQNRb05E2tCxcEK7/XZPLxhLg7amRa+9cZtAQXAILmJq6VJaZebUrt5DUR89bsYTnZv54w+DmNtVjG1tpleAOj5hB+++4RWx1pf6Hkc5CP/VkPT5YVczDB3QRN+u9Dp2yp67eAUocH25Sqz9j2vL90dIEB3x429F5vEnJ0qusvU8ySqyVEVTAHc6/5ntrt0fpG21fM2EuttrGR2aQkCw1M9k9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 23:19:35 +0800 Catherine <enderaoelyther@gmail.com> wrote:

> Hi Andrew,
> 
> My real name is Zhao Li. Please use Zhao Li <enderaoelyther@gmail.com>
> for authorship and Signed-off-by.

Thanks.

AI review might have found an accounting imbalance:
	https://sashiko.dev/#/patchset/20260427145247.84157-2-enderaoelyther@gmail.com

