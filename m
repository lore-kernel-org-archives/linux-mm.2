Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB5B606A8A0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CPe6sEoD
Received: by kanga.kvack.org (Postfix)
	id 592566B05C1; Wed, 11 Nov 2026 10:22:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A806B05C6; Wed, 11 Nov 2026 10:22:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 481296B05C7; Wed, 11 Nov 2026 10:22:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD8F6B05C1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:22:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE95F402F8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:22:27 +0000 (UTC)
X-FDA: 85423204734.07.1F1B743
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id EB8E4140005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:22:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CPe6sEoD;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794410546;
	b=SnHr0T6YCMeWzZOGhM75cBnXMEXQDsZzBqOrLbmIYRR0ltthVQ8uaGYspD4eTwk9QgQ+nu
	MIUd8Mh9bEG2JXaVA65/A56yfBUaiva0p1H/XbktMRc6qkG/VXllM82cRgKup7DGB5QRRp
	/Q28RI1eumkozyge1BFz7v1ytiAJqLg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CPe6sEoD;
	spf=pass (imf26.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794410546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mBSo8+i91CrACZrxGkLXrZpH+5L8K8Z5H9NJzXzfrR4=;
	b=zYtNotGSp3ts4dNH3PnywEWlxoDR8QabmSgP4ZslTqxHf/4nbCi7JmusS7lCVsNFZfT51Q
	VWTg5pqfQ2VsZTntoB/qrJXyJM/LLYqPxtnWBMCDXiu51SHgo0mpwtfHX8KFFxTH4egw+r
	jXAEePIq2Sa+zNZ3S/gnIyGBy6UXxfg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1AC61576;
	Wed, 11 Nov 2026 07:22:21 -0800 (PST)
Received: from [10.43.20.72] (e126510-lin.lund.arm.com [10.43.20.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D2A903F632;
	Wed, 11 Nov 2026 07:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794410544; bh=mBSo8+i91CrACZrxGkLXrZpH+5L8K8Z5H9NJzXzfrR4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CPe6sEoDXEq0CUSjZ6jny/Hfzg7F0nl2TvWdHaTVM/Z8om2nXFrbUEHiNinOsLi3G
	 b+zM4dJw+QxdRaUrtNxakmzC6AiBkhYtoNt/T+Y94M/CGZNoMTkg+so51tIkMogts4
	 Zp7PhvG4gHcOkBuMpB9jhCJKm3Tc9Y9pOp0sQA68=
Message-ID: <0a48af69-d0a9-410e-9d10-389eed0827c9@arm.com>
Date: Wed, 11 Nov 2026 16:22:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 06/22] arm64: Disable EL2 trapping of POR_EL1
To: Mark Brown <broonie@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Ard Biesheuvel <ardb+git@google.com>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-6-aa6c4d9603bc@arm.com>
 <3500936b-4177-4ba0-a9df-7eb9d9d75b0a@sirena.org.uk>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <3500936b-4177-4ba0-a9df-7eb9d9d75b0a@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EB8E4140005
X-Stat-Signature: 195gjoc8yxz5wcnxqmwtjhrnyt3edphb
X-Rspam-User: 
X-HE-Tag: 1794410545-860118
X-HE-Meta: U2FsdGVkX1+yzgKoDIktQgwl2l1L5hxuhtg87dMgFZmiTAFbWXEfAe4V3sjpxprahhUimeZ+6WG64TklsDyQazzbcsUsptudue6knG8UihLvv8KuTaO+V0RG+DWcy7mewT0+NZJ4Ebn7x/8e3lWF9+SDiwoKxTt9WtB8oAieSv/qARTV70wh15X+5CPbFCk8ODVAb6FfZ7rRLZNXPEnOSVzO14aRCBYqzFeC0J4h/Wtxh4V39s9/6OB/Tc5oha+90tqpUi6q9WCPV3KLSJHiJW8m8Y4cPVFC3pN/P/yukUaF4Zob+jVD12Kw6iUmD2/BK9W2D3pz28t4PP8U1HtuZJmoJpqQNEfov6DoX6ItzWeTSyOsyJHcI+b6PHVGJJEWMr1YMEFDKiWqlRXufCVWt8Zo/f19tjExlpsw1minKqWRcg0o3ChmMFA7lWS+comg7BAE/LULAMetkGq105o5HE4zDFl/pq8mZ/LSZtSSlIy1KBvnr3xwVup4rdc1BWl8e/1vxefXOIm6YT6j0oLX8dbMCItpHPgcblgs9kL9rUiY0ypKjOpuRej+PIB+ojqjzShzklqAsYEPuUoOXmd/CEUkN5Es/xGXxxizTsu3KADMe7gUNpjwNMlVFND9U9z3cBgIht/g0/TQFDvALF4M7HkZMgIm/lFAJHB/c1m0lX0zkMxniWc+Pf+0eZh8ZCZ879NfOnITL9LmJjhodPDRAE5BjgmUkL/XY1GpqfW//E/6HQkuc8rmGebwvw1S2nGPNHEeTMgP+2G1vqbovyw9m6wSJnIWPhvLTQVOk8VrGaV3kPczKNbgtDqEe0OsWDbvGRLf0/YjfmWYwzsWre0LKJZWkGR4jL7RXjzAa3A2HdIgc0TwEEnNgY3/6f2L5dVOoYMaQKlko2v4mCDaTfu0KzuIoc1dqaUJSFqSeIwS2irEqmcyxxjWjZNnq0wWn5+Xu8BGhQkadi9JbfQgJTs
 mUijFeBV
 tfIycwdxGPLQhLlhvUydcYV5Op+cfouUTsmZjWDwRi9bfM1BcvoRpdi/cKyfRIk2t2T69z760f7zxuyDTbhEhqdXhOTX2Uh+JfeHMGhVXgQK/KBt3QTqesoDlwibXD8txfEDjbsLMruXW+SD+Wl5XHU/14CsEcsVmcIzS/WCZcAkHPvaY8T6g06Kf3ALx3013KAkzAk0HJxQLgwjKzI6iAwA7etfYT3uJ9/gZeU8hJKi0hYaWRlDz+YMePUJBGY91mVQUEdbAs2iLpDKtWT1FwJ/Iu2lpjvoxYX8c/651gcr36ALaBUIBlM+O4xHfM5kXU7pN5oBy4WyO7HV7NIA5AlFRk548d8WkZ8hhORDM6kJbjA+NnN8wUY19yTaZpfliCLXhffYgFKevtNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/2026 16:29, Mark Brown wrote:
> On Mon, Nov 09, 2026 at 03:58:31PM +0000, Kevin Brodsky wrote:
>
>> Make sure EL2 doesn't trap kernel accesses to POR_EL1 by setting the
>> nPOR_EL1 bit in HFGRT{R,W}_EL2.
> This wants a matching update in booting.rst as well for when the kernel
> is booted at EL1.

Good catch, in fact POE requirements are completely missing from
booting.rst. Will post a separate patch for what we already need
upstream (i.e. POE at EL0), and then expand the section in this patch.

- Kevin

