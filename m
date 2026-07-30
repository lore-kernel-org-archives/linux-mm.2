Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D1E8C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:43:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2F46B0096; Thu, 30 Jul 2026 08:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73DA6B0098; Thu, 30 Jul 2026 08:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B2F6B0099; Thu, 30 Jul 2026 08:43:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3BE36B0096
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:43:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4A827140117
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:43:48 +0000 (UTC)
X-FDA: 85045409736.21.57ECE5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B302120007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:43:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xn9CZZ8q;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785415426;
	b=c6olobQXPGXhRfhZPXj4hpqc6XGqUec1/bK241jWStXfPTohFZ5T5OL+gv91LK7XltkKd/
	b8e6kFvF+yP77FDvpcsNB4zxploAr9a1YUHNmdnOfxcW3f6VRaD9N7upJX4Lkz0XiUQXfF
	ZGbQFROgtR7ivDCB6HLiCH0uhT+AA5E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xn9CZZ8q;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785415426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tv01v+1vmyL2V9Dx2V8kfjj44VgJjpaRsjpUKiXaIwo=;
	b=0WGJc66SEaJBdJSJvfEvGO134avIEaektNUjd8AHi2UXpQQ6EOuH24PMdD6+7hjA9PHmyr
	mPopi5JiTIXBVv71n3AqshQhQFtgKCuQ7rU0zcVua5WM5ZArhsO1u58OjUZSITT0CRmkAb
	1jJGeDZWzC4KI92c/LU0JAPVEjyVECs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D815B43C3F;
	Thu, 30 Jul 2026 12:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5C61F000E9;
	Thu, 30 Jul 2026 12:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785415425;
	bh=tv01v+1vmyL2V9Dx2V8kfjj44VgJjpaRsjpUKiXaIwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xn9CZZ8q4fyaTzyVghjcX4coSwOOVxWYub2DQbQTTQ/7S+qjSTdRqwH7KxQN8sA4G
	 KbeBl23oUkUtQxmG5FJgjXHQ5qvuwcrbqSNryM965phjrb42pbs17xhPT9Cipdn1sE
	 sG79Xp1VqF+sUGHLL4At+wPzmS6nTcw5zF8i2/BOpJmfOCZZcjmCiiBsM1reMlMYnw
	 cHp9h8IV3A5IENrcouFOw7G1c4VmJ04YWp6EXWzBFgMUQOqYkIy34herfhc4bamJVv
	 9i9uRpeu8Jw6sbmqXg04pzmRpAyFUZWoVzNkLhy3yKLRil3Izxoux3cLdlE9Qf9GzT
	 uq6CE9TWqI4nQ==
Date: Thu, 30 Jul 2026 13:43:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pratyush Mallick <pratmal@google.com>, akpm@linux-foundation.org, 
	vbabka@kernel.org, sj@kernel.org, corbet@lwn.net, skhan@linuxfoundation.org, 
	anshuman.khandual@arm.com, gthelen@google.com, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, liam@infradead.org, 
	rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms module
 parameter
Message-ID: <amtGydvlb2omM4WU@lucifer>
References: <20260727230545.262579-1-pratmal@google.com>
 <amiN82J8p5z9l_Rm@lucifer>
 <91b61f02-c533-41b9-b680-7de52a5c6918@kernel.org>
 <CALHaPKeOs25YNRg60+NxfS3E5RYLt5hJqFNX02ZCEBrjcDua0Q@mail.gmail.com>
 <amsYVFfJmOs-Hy90@lucifer>
 <1acb7ba0-6aff-4d30-9554-283ac8fbc93f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1acb7ba0-6aff-4d30-9554-283ac8fbc93f@kernel.org>
X-Stat-Signature: etk4gb6mhzzmorxzrdzixh9458hmn17k
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B302120007
X-Rspam-User: 
X-HE-Tag: 1785415426-249462
X-HE-Meta: U2FsdGVkX1/R1ZkfXQ4wL5DikRnNVj0+5C5sg5UV3NjWgbkfuzhGiwmeO74lK+bgksJkYywSrBpTzqdH9m871lv/VIobibg0boXQO7Um2A5ifEP598WSwE5rrQGUHXepwUkoQfT9sj+H5bpLOyOwyl936r4xof+llnyoxweSOwsgFbF+ZGBHR13d3Zlu34DWTYLmHC4HQnzvYGjzyJa+fE/w1QDaHF4/phZ7X9Q0eClRE/zmxELwIjqPd7J/Itbbeqz2D1Ysh/MlaE9z/fLuc+Akx9qF+Sid1qLiMzPfzfA1GRkQmy7qSBUnpq9do1pNVaeKSpMSI7Ol9oi1qj5iQSvSq890sOPfO2np+eayxQwgMv334Vp19N0qnSdA2Pw4NLjBAU08wWGFZDY+4Z28MRHKukEOVdRgNEzcV2tMCphZxdOSltciJ7Lp+zUneNexDz8VIj5fXfHI+7tSDwFXhguNT4uhv31cIPcS7Gcc7BJpJjf1+dDEK7M281o5KgORKlqqeA6tGM8DNvyNryJ7nbISUWHHIIHGaOaupN7fA6qh0S1zdtO20AWSY3XhJPjTAjtS5BVAv3b0x11PdkQFVKuirJgYeLVpTFvNvv+/zgLP26ttkkvyU+cTFcCLmQM+sLFhoEd2ctu+4rD0H3X81bP3k0dLoFEXdybPkDems1PldcgJbLLo9Iz37GX2kopw8EDIdgiGdHfh2rNinOlH0LuGbrhP6PEJWbQQGR4vfpRz8q+EAQhwL9OCy0UwHCBAFLfk2hKqlNFqa/+y6Njkt9PIxQdNsgacfri/GO7WgXDs2axY1+euEAFhOzMbS7+1kUzrTNMLuh9HsRHzyFjA0PrEzhF72PAAN94qVkA8IyYEsslC5V+ObGp+rkbC+b2InNI4+m/DGC7SpexRGtC++rTmWt5RqZO2P/aU9nX9ToweMHGlU1PStTI2WXuuAYHL7qI+zahabt9h71GZlO2
 8u7jCLLP
 /yI/aSsPSUhY+i/5Kk/IxaJIwZRuOKL5StRq5woyraJPz2+WadtfHm+tP4TLVzbpaOxiLEjo6a9EFqyoNsqr8oPdRzuag8p2qtPoqew/NNBM2YgnZxrLx6CC7yHACP0bDB8zEsVqdBWhpBkkizh/WXQvyrCyEUtmU8aXQjVaF9MCwgonuioAYEOAeHQ1d5X363Yc0FiV15t+HH/I+HCrowVmZsq3GphQkpyCp5QdXpx92rQGjsCK3d3hqCexISw0csxi1LbX3wdoFtp/8Sp/nqy5asiRHa6yOTJJRlWDixpkpsbA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 02:39:51PM +0200, David Hildenbrand (Arm) wrote:
> >>> With 2s, we wait 2s before we start reporting immediately by kicking the
> >>> workqueue immediately.
> >>>
> >>> So "0" does not mean "report all the time", rather "start reporting immediately
> >>> as we are notified about a pageblock to report".
> >
> > No, it's whenever pageblock_order is specified, defaulting to a pageblock.
> >
> > But I guess in practice fine.
> >
> > There's fun like this in virtio_balloon.c btw:
> >
> > 		/*
> > 		 * The default page reporting order is @pageblock_order, which
> > 		 * corresponds to 512MB in size on ARM64 when 64KB base page
> > 		 * size is used. The page reporting won't be triggered if the
> > 		 * freeing page can't come up with a free area like that huge.
> > 		 * So we specify the page reporting order to 5, corresponding
> > 		 * to 2MB. It helps to avoid THP splitting if 4KB base page
> > 		 * size is used by host.
> > 		 *
> > 		 * Ideally, the page reporting order is selected based on the
> > 		 * host's base page size. However, it needs more work to report
> > 		 * that value. The hard-coded order would be fine currently.
> > 		 */
> > #if defined(CONFIG_ARM64) && defined(CONFIG_ARM64_64K_PAGES)
> > 		vb->pr_dev_info.order = 5;
> > #endif
>
> Yes, it's really about "a large chunk of memory was freed". On 64k " a large
> chunk" is unfortunately order 5 == 2MiB (so the same as on 4k where a pageblock
> is 2M).

Yup :)

Yeah in general I'm fine then with the timeout being 0, the fact it's batched
like this makes that rather moot!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

