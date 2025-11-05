Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F12ACCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 10:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0338E0005; Wed,  5 Nov 2025 05:06:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C81B8E0003; Wed,  5 Nov 2025 05:06:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604E88E0005; Wed,  5 Nov 2025 05:06:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6B78E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 05:06:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D99A1140266
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:06:18 +0000 (UTC)
X-FDA: 84076123236.07.A3D320B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 36D3E140003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:06:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XEEheCSj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762337177; a=rsa-sha256;
	cv=none;
	b=z/u6k0rsavzFYn3zoyBBWrupUuXBuqVjxQZAQ9LBNlmGbK8b0O7w+mZqB6yhgqNjH9zbNO
	XMvUDXWwPtVTiHDvsbVwImdwz8JCBM/yAzVSBVO0SjfkSzBSrkf6iU37ePlBNA1s2lKmCT
	y7rbvd9OH0Y+Z7DT3IdZI57fXESthjA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XEEheCSj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762337177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZfwxojZOFFcOo9hnRHu2r7AMzIR991JVWKMGHEYB6Wc=;
	b=zNKhrtQJKEmoNMYJpM7UQIg0lTrg/h6x+H8zg3RU2xy3BrBKMKg94Rg8p+8m3Oy7X7W+g2
	wmIXQW1T5aUEPhodc05akETvSeiT/2+A6bqYJLfxa+w43gQQ4Gi8n3ZWBWwJskBxkMctQB
	vqwpPIIycztvXQIsScWwmoV1UB7gChs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 33C3A44197;
	Wed,  5 Nov 2025 10:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F501C116D0;
	Wed,  5 Nov 2025 10:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762337176;
	bh=7xelL80uD+mmTJR2hN24e9Ymu3C2gxHRvhahEaLbF7Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XEEheCSjZlHYcaoorplt0rQp5cepQJdG9XPrkjpeRyZZNwsZTULh6DAKX/St3FlgR
	 05qjxYR5hoyxzpKI0tkyeXyoPLZOrMLelfjfvga4J+Wqzgw9+cKAso7+9avEAGSqEo
	 KwP5hf+BMCbGBeTb8892UAId7TL283+yLGI68VNqK/1GeUG4WGOWlqf9LDaY04j6sM
	 CvUJKAjPFgu0qIvUzjbO/q0itD0EEx29Z/BxgZED0mPeUpbmjzPQFhZYsEphXtB1if
	 qoWBeQ6ISiFlZQMOvlya8ylHlu4VKKSo1zn5sT4Q6NX2PB4OAbv9nx4dPoCIIqvRrU
	 Ie9jRbkH4fySg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Baoquan He <bhe@redhat.com>,
  Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] kho: misc fixes
In-Reply-To: <20251103172321.689294e48c2fae795e114ce6@linux-foundation.org>
	(Andrew Morton's message of "Mon, 3 Nov 2025 17:23:21 -0800")
References: <20251103180235.71409-1-pratyush@kernel.org>
	<20251103162020.ac696dbc695f9341e7a267f7@linux-foundation.org>
	<20251103172321.689294e48c2fae795e114ce6@linux-foundation.org>
Date: Wed, 05 Nov 2025 11:06:13 +0100
Message-ID: <mafs0tsz8bxpm.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36D3E140003
X-Stat-Signature: zw16g8aimqqz6jafwm58wmhswarmd67g
X-HE-Tag: 1762337177-675355
X-HE-Meta: U2FsdGVkX19gFdBHjNFUT1A5CuocUFAe2uMvi6jeLojC3L7VjfmcTJTCr8qsVqFEPWzHReNRzC2aJgPzz1AcFLihoIlsaAOc46ejpJ7E2IuiVn8p5sOnrj3GEbO7PwhIpuVsAfzPUSBFZsbVzD7K9VIdCmL/+kq7Wzj6xt1nj0nzjuoYj+k/hYjNMmjJVCXbbN0O/txlj9MTNZ4xR8dcij2v3R4kSj/VEcgCHwsEMH8wY5RvzVxLBjq/DB1SEzCfIiQCTMzegq5RrBK6E3Ut9aRmn/H1VL9NfHqHu1BVKLe8RhjRjEC8TLvCZUL8mDBCxRbLBw3r4rHBpe2/Yx/9jd292GGdS+yr7b8gQfv2XFQ01OhyPefU2ehyq0LTv/ZJPJsHcUkg8I06Tq2IbwRKx4zD0TpHePnKm0qUP/QY6WtF0K829+Y62ROtHMESumOsAjkmFZlxQC8mLb3M0DZxLH6TkfaCNz5boxTL3Z64xp14Z8WVhvShauwRXOkSW2rLyXDFf6MDQ8mub7W4pB6+sNdmDMerHGTqiXVpmVtpvjp+Gd0DqbrigUnr+1HuKbkxqe2P+UjR3Fv2iAEfxjjQvJGC9fyF9FSi13ZiZDR1i9vCr/z2OYgpkBcIXGBI5WAvMbtgkNzsNGUowdsKo0xUW4FR6larR1mSoQdrZu+ayb11Juf2Vtr9f8kyEsqVVR9tNLPAV4GkZ/kBS6/UVUhT0m9aWIyVinxrOFScg0GajZdqJXZejjfu/RvJ3ejbEd4cweaTuzfVoP6qAD70jh1S0ssP4sDw43iItqM/nm6zVOvctBwkondBWY9+lEsgiP/2/pasxQnHXXwrkYRFnYDx7jlW+1cf230tyeq0/Bql8KTLGQrBDCHlG9H/NplM0vOK8sj9D08uqVSe+sVENqWmqj+dMl5SCMKsj2cDG8LGbHJfiYbVAvebpymF4WOLP1mX8MN2XuU3ueALsj8Sfmx
 qUsQu+s8
 SfWateP/l9D5nUMF+jtYKAwgSJVpKYCfGgnaK6DTCdRdE7g9a0bYG5WZOq5id6xw99s7ebtWCYiyL9dxiCHNj0vYhWVYHxVwOLKMg0DW1BGsblaCuW6xliufwSht+nbuC8aC+9ilUNC7x4CFWSm0isb6DqtPnZbUap5oYWiN6LxU0C4sjvyaqIJ1k3xhGrZA/AXKKqsJJJ2MoHiSzRNxWTKyFcxIppOYGwKveUjwtbPjSjXrUE/ZBCRvuTJCQYIYGC5Hy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03 2025, Andrew Morton wrote:

> On Mon, 3 Nov 2025 16:20:20 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> On Mon,  3 Nov 2025 19:02:30 +0100 Pratyush Yadav <pratyush@kernel.org> wrote:
>> 
>> > This series has a couple of misc fixes for KHO I discovered during code
>> > review and testing.
>> > 
>> > The series is based on top of [0] which has another fix for the function
>> > touched by patch 1. I spotted these two after sending the patch. If that
>> > one needs a reroll, I can combine the three into a series.
>> >
>> 
>> Things appear to be misordered here.
>> 
>> [1/2] "kho: fix unpreservation of higher-order vmalloc preservations"
>> 	fixes a667300bd53f2, so it's wanted in 6.18-rcX
>> 
>> [2/2] "kho: warn and exit when unpreserved page wasn't preserved"
>> 	fixes fc33e4b44b271, so it's wanted in 6.16+
>> 
>> So can we please have [2/2] as a standalone fix against latest -linus,
>> with a cc:stable?
>> 
>> And then [1/2] as a standalone fix against latest -linus without a
>> cc:stable.
>> 
>
> OK, I think I figured it out.
>
> In mm-hotfixes-unstable I have
>
> kho-fix-out-of-bounds-access-of-vmalloc-chunk.patch
> kho-fix-unpreservation-of-higher-order-vmalloc-preservations.patch
> kho-warn-and-exit-when-unpreserved-page-wasnt-preserved.patch
>
> The first two are applicable to 6.18-rcX and the third is applicable to
> 6.18-rcX, with a cc:stable for backporting.

Right. Sorry for the confusion. I see that on mm-hotfixes-unstable you
already updated the third patch with Cc: stable. Thanks.

-- 
Regards,
Pratyush Yadav

