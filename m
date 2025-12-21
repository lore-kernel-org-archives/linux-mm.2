Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9723FD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93C86B00AE; Sun, 21 Dec 2025 04:30:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41566B00AF; Sun, 21 Dec 2025 04:30:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C23966B00B0; Sun, 21 Dec 2025 04:30:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B27CA6B00AE
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:30:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BC4B13B9F0
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:30:28 +0000 (UTC)
X-FDA: 84242957736.23.737A300
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 80A6A10000E
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:30:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aZt8jayi;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766309426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdDZF3/HSZmlH2rDLNptQ5LWR2buABlOXa4bjb4WrgE=;
	b=q/8Lr3QM++Bjwl+njIl0aI6qGvPBouUSUwDMRBD3pGHVCtJj/4YUTI4Exia20rn2mm1b5z
	6u/cVQmucArlp4SIVPZcI2W1EE5825K1UPhlrKDK70e0ysi1RuzhPg6MJWxqYC999doDuY
	Mb/X/dyp1vhA6ym+Xnn6DM7Oh1wyGHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766309426; a=rsa-sha256;
	cv=none;
	b=KaUnmntUFEijcEcVc8FDSTLmwz0QS/RpHbtvef5qmVykmS90/nLGFSNE6zx3Vnq7lilzKt
	ooEWuPRFpxiYNde8A3qBEpATKviv/IbWmm5TEa+WCC8f157qCLhi2jAAko7AtfUWfmIlkK
	I3J5E5GsKlfGluta1NxNJKI4x1RTWck=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aZt8jayi;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 44D78436EB;
	Sun, 21 Dec 2025 09:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84754C4CEFB;
	Sun, 21 Dec 2025 09:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766309425;
	bh=dynri6cO7Epp0o2N9qQ3cdoFscVQqJSuLqeok3MBBiM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aZt8jayi0KTKlYfeM8PXcjFeXS/nexnOlW7wp5qpXy8jeA90IS+dY96x2qy1rT5xO
	 FHl5hVlhatmZm8PdARiR984pcX5Xnvb/DN3H8anneFIS8urkPCN+tf5dstcWVRW0gb
	 MtpipYZ4/nTh4uvDJud/EwfAeYoY6eMvezzyrEHIwa4jQVN+kGDWFX9QlrkXMmlhHg
	 +/MzLZJiX1cgSGhR6cIHSoivnfh4RJpQU3BWUmReDCQIKKfO8emvBUqYksawYAEan6
	 IemtDz7JnMnQaHpRMNWXo27R+S6bUs2yHEAc+/muXldZEic5H52t16UN2Lx8FHINn3
	 pxRdGiibDmVHQ==
Message-ID: <4aecb94f-e283-4720-96e5-1837352c3329@kernel.org>
Date: Sun, 21 Dec 2025 10:30:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] arch/*: increase lowmem size to avoid highmem use
To: Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>,
 Arnd Bergmann <arnd@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Andreas Larsson <andreas@gaisler.com>, Christophe Leroy
 <chleroy@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Linus Walleij <linus.walleij@linaro.org>,
 Matthew Wilcox <willy@infradead.org>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 "H. Peter Anvin" <hpa@zytor.com>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Michal Simek <monstr@monstr.eu>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nishanth Menon <nm@ti.com>, Lucas Stach <l.stach@pengutronix.de>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-2-arnd@kernel.org>
 <a3f22579-13ee-4479-a5fd-81c29145c3f3@intel.com>
 <bad18ad8-93e8-4150-a85e-a2852e243363@app.fastmail.com>
 <a2ce2849-e572-404c-9713-9283a43c09fe@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <a2ce2849-e572-404c-9713-9283a43c09fe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ed5gcm8etq6ns5j13cmtwtn3gjsuasa8
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80A6A10000E
X-Rspam-User: 
X-HE-Tag: 1766309426-527531
X-HE-Meta: U2FsdGVkX18HXhAGfqDmbqGH/FBe0yS1QQq+QRcqvOspdW9DQDY73B8etOuFHuihtMc0gROf9lBpwDptfa6qDiacwt5Ja6K1ZS9eemYESaPS9FNDvatG++8NVyWgFz5AfMjHi1eUteW2dN4iyaNgMfOWEt7ipuLfg0v0DndzfBhz9tNW28tf09nMYiyTw2/UBcB5Y3C0jA8mxCv67W1WTCwT/3rNy95Ijd9wqephl/KJdyAtzKQGdr7oMNQggioK/9ac5FtkUW5TwRmxF+TKbKBVOGY1wfy+TCf9NtzsKiFJ4EkVWlXGNgELZml7ImNd5Hx/LR/c/ixAFctoOqi9jRfgSbgdKTKyh6sV5rd/+1OFkCAZPZiz5APC2EKY/poYp7mZFsrIwNLrvRRcu7bz35ZKFj92asYjwQeN+BWb2GRh1QQMzRIdka2IiQs8nAXXI9wkR/dnV/qzC7psdhGcc1qrfjQ4bWYtU4iGJ40qtHsOl9QGqmdE/xup19ckV/BKeDhBT4G/p1HNsQpDAAy5aRNZ8TRm6uJLF8GtQX3y4I1SdospCRSikfm9qS+2H4rRH3gOFoWPd1Bz0ZOXeEvGVGbSXxqcyLTouQYuluJXwRVZV0tS/kOsCixo3fCkOaR4/FFOI7klTlX9K8pCeggrYTu+j3vtx3zzr1vHF7ERTu4IiG3/oj43gVsSOzAGlNLB+AhrGUHN0sJ93Nd6hxluO1g1U01qu1XOkEDJimHMAkQ4qa5C8OaRMZ0YIWDm8tCruvWJEydXRyBTam9oC+ikMcRYQ2L65jb76glj0IF9Ec04xPflQzpWWHAP3R+W9P/4PEeBz83jZ2kWjyodoMP2fQ3GlqCcq8QLygwSFpLuHyiLpUAG4vV09IIfS0c+T7DdrGEaKUqIfs1IX4siRT9skCT0UMUPKt3hzoG9jLqYxr+4CHBmOZWMSnRRSlEk3saiGBJgC43dDU7Sbw6vU//
 RRA98Dbk
 AqmEb+ulHYhZZixClx5NJGKdNf3giVu/vpyb9+XsCKoBVqDkepCtk0lpLaaGwsbyDhfiy1qiGUye/u7e4yYDrvsMJ9XEepm1F5zXYqDMSTfqwj86Lu+bFd8VQ3O6toiPSiIwkPFa/sQKTQ/Sjihx7o2leN8LObuuTWqNkgeX2k0oz7yM6tvHnUXWpUcFey0iAFqpHUrv+9zAR2/PAMfhUjaNKOfSX5LtCTijEwg5Kk7Ztz9cjfwY72ch7cEmLeYS0xOPp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 21:52, Dave Hansen wrote:
> On 12/19/25 12:20, Arnd Bergmann wrote:
>>> For simplicity, I think this can just be:
>>>
>>> -	default VMSPLIT_3G
>>> +	default VMSPLIT_2G
>>>
>>> I doubt the 2G vs. 2G_OPT matters in very many cases. If it does, folks
>>> can just set it in their config manually.
>>>
>>> But, in the end, I don't this this matters all that much. If you think
>>> having x86 be consistent with ARM, for example, is more important and
>>> ARM really wants this complexity, I can live with it.
>> Yes, I think we do want the default of VMSPLIT_3G_OPT for
>> configs that have neither highmem nor lpae, otherwise the most
>> common embedded configs go from 3072 MiB to 1792 MiB of virtual
>> addressing, and that is much more likely to cause regressions
>> than the 2816 MiB default.
>>
>> It would be nice to not need the VMSPLIT_2G default for PAE/LPAE,
>> but that seems like a larger change.
> 
> The only thing we'd "regress" would be someone who is repeatedly
> starting from scratch with a defconfig and expecting defconfig to be the
> same all the time. I honestly think that's highly unlikely.
> 
> If folks are upgrading and _actually_ exposed to regressions, they've
> got an existing config and won't be hit by these defaults at *all*. They
> won't actually regress.
> 
> In other words, I think we can be a lot more aggressive about defaults
> than with the feature set we support. I'd much rather add complexity in
> here for solving a real problem, like if we have armies of 32-bit x86
> users constantly starting new projects from scratch and using defconfigs.
> 
> I'd _really_ like to keep the defaults as simple as possible.

I agree with that. In particular in areas where there is the chance that 
we could count the number of people that actually care about that with 
one hand (in binary ;) ).

-- 
Cheers

David

