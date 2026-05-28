Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A33ECD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 11:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 261586B0005; Thu, 28 May 2026 07:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238CF6B0088; Thu, 28 May 2026 07:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176C06B008A; Thu, 28 May 2026 07:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08C376B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:03:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8FC4C1407AD
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:03:03 +0000 (UTC)
X-FDA: 84816541446.01.EC35E0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id EF23120009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:03:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIcGObyH;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779966182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKOsaV5agj5ZF2LCn9OwHL3I/NXH5DsoLdW7z8XfuWM=;
	b=F6FkGIpz/GTWfgLPivHbyu/56YHYjoXi9j53bg4KDN8YkIkcsCd5GvTKgdhVKGMZrFqH3U
	KWoj5rPFKqCE+6QXrUx6IsSRwiyKU8WCmGyqKNXTiE6tTZ7NcyQDlWCBiic3CjCQPYqaOP
	1pALWs/Yxy0CJNJb8mt8rWs2ETwFkc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779966182; a=rsa-sha256;
	cv=none;
	b=FcznyjHiUaFQS7floKb6ftrZePoLE6PRi6sATRLxCZDQJ/h6P7VQTR1dQ/gnGayYV6BBQi
	EKXclTV1ZAX4XDypqGJ6+F9oqHnvqwYkSUc1uN4d2HWlsHlAY7NhJ9y9yrU5zNApfOtuBW
	p00IXKYuFk0ZzHPk8l8CTBsjE0lB7yA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EIcGObyH;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 62C1660123;
	Thu, 28 May 2026 11:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579601F000E9;
	Thu, 28 May 2026 11:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779966181;
	bh=XKOsaV5agj5ZF2LCn9OwHL3I/NXH5DsoLdW7z8XfuWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EIcGObyHg7KH6/938ojTjdYoGEZyqrONHwbJhnbwGWZaJMDw6xN0Z/glfoVyHnwOE
	 ZCCSlqEfgIXhctCmLa0/xITHftUSreWpMfdv1Q42RozcuCUKx4PbiO0uFYolQojqSb
	 seL4tph1nhw2S9eVIXMuXYQDoopecAQ6gteYQ/L2zGLwH2UfjoAACdubIzxQZLVLgU
	 ExaQBMwEPj1a27vzps0J8nGRuMkIiXpIJKB0S1YdVu/Av1l1OAVJ5W2W9zb/AyHCpl
	 NV8KZTOtlCbu0EX4R+lUH3PwRuyCzOJpQA4rKvVo4YDn9wsH6VA1fUbuD/Iz8qy5N6
	 OdNyxAOE/Gu4Q==
Date: Thu, 28 May 2026 13:02:53 +0200
From: Christian Brauner <brauner@kernel.org>
To: Li Chen <me@linux.beauty>
Cc: Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
Message-ID: <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
X-Rspamd-Server: rspam11
X-Stat-Signature: ixn93zta9tctp96uijjx4h3zy4r91a1r
X-Rspamd-Queue-Id: EF23120009
X-Rspam-User: 
X-HE-Tag: 1779966181-750469
X-HE-Meta: U2FsdGVkX1/JAGR5Mf1gDRJFrErXLGmDevbG5P3gBh0xNLmUPx1+hUcknzyR14CQd6LmI32gfuCB1GpBcfJ/uhiOJCyiNhWrlW5hf1oWxPnjEm4GyK9n3vf7xqZTQH6v6tUKW+XRrBqJYEBg9a7MoreceMWIO+HpSAm1B6wmpOHw0tV3r7VOO0fa3u51kCNfLFifTFUQtOz5RJFRK1cJzzTfjFGXu7v8b6DvlCqXTS5LXcM7Z8/obSh39f62b+dFRak+I4xKOTpRCfh6a68SmC9Sylm8O4FaJlneYOakr/DesRCeZQDHRTOJVzfiBHcsqgjujVqe7GJ95n189uNMZ/p2Z7t2NJbsmAoBqX1yrReqM+us0biyd7RwrsduZ5EkFzg9A8LQk/GGXiunFMcL459rFt+hWr5l094mpOq9o5EneG7LV7E0MoAQoTXs5IweEQ1Rw5DFAaDxGGCBvIR7R7nnrWidB4WIuiC0ItUIpMhLJ6SIXdR6FvF+Fq94OnOB5ZdsxJP4xXjxhX6DBDrsoewcYFbilXbnc0OtJzFP7wyB1WtwT0gYSG9txyzqGlfnSqnJYcWNCGZ3qC6zU2l9iElOUpLwhZPYoZ5dexEoeSdfDvcLjdZo6MxQePZ7wnCeas0Po8pLx/qC7h4pDUz4LtYEVruV/RQmmCkkITbM1gkzF/k2/GKt+s4OMT5YFoUC64BoFEEm6J0E8WY0DgsgR+kD+tcJeNJsg6YaCBBjKLtlm1PmYF9R9TQsnjCNV4ptNoluOlqT2wEF40/YSF9/T08Qvp1+VH3rFk9gc2VDXMX3gNdbpHj7nPITRJLMhLVAT/YkhFUHt6XGAm+WX2Dw7RNQrrGsjK8FL9SVhH5NBcdQU1OQEl5abfZ6IYm8POWpYOuPTTAt7Hgo5ilG/PCz5QBz7sSE/m6ijASPNvKXLchawUWX0rU4J0WR/UELuvWWCHc1aKsXfV0bDIyAgY7
 IAFqgXzU
 eBp8Ts6pW0JpXcfaOzjkHoP/W3yTE58MEK2YMubsYTZoa5lUgZL188Z/dSSReM9rz8CV3lWHaRXsk/eW+NPwGgDTB3ZpCVr7ZGBJaCgrbVJ2tGllX+TuKTVLKSAKWR7VuNipO5F347YTFknN0s0en+UJ1B7oKRPfyjHews5gBNJ1hrA72aLNMNb0yPoLRZSgYp9vYsozxBLqT6XIJHFPtpxq6hV7wQM9X5AG5ZGOtco0K7qprlyxx/vnY/HvsXi7NAFud99WSOvqFrJN189c4YiLE/HLwXqQLIIim2p2EIslAbMI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 05:52:21PM +0800, Li Chen wrote:
> Hi,
> 
> This is an early RFC for an idea that is probably still rough in both the
> UAPI and implementation details. Sorry for the rough edges; I am sending
> it now to check whether this direction is worth pursuing and to get
> feedback on the kernel/userspace boundary.

The idea of having a builder api for exec isn't all that crazy. But it
should simply be built on top of pidfds and thus pidfs itself instead.
It has all the basic infrastructure in place already. Any implementation
should also allow userspace to implement posix_spawn() on top of it.

fd = pidfd_open(0, PIDFD_EMPTY /* or better name */)

pidfd_config(fd, ...) // modeled similar to fsconfig()

