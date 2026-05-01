Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3267CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2155A6B008A; Fri,  1 May 2026 14:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ED2A6B008C; Fri,  1 May 2026 14:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 103DB6B0092; Fri,  1 May 2026 14:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3F0F6B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:00:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 913341C0102
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:00:50 +0000 (UTC)
X-FDA: 84719616660.26.F138AEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7FFD914000D
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:00:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qfqVsyse;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777658448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QY9SBsO0aFkqmlo110KXmu29UfwCog51UeWsg1/+EU=;
	b=MAd5+hJcL7204VjKdaJ4sT0l2ieJqatW0+F7MfVJ6xTbi2aiZ5fuK6sjY17rdotnz+Kf/T
	I1Afq4yyUOnawD3BF3LGcfZfo1dL0mFIhJYbR9KQ+B2YiZsvC5gQ+or+4Q/pc3ZyjIuNUt
	y/1aB0G3zCCv48sYearzncnFxrzRnJY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777658448; a=rsa-sha256;
	cv=none;
	b=s2KhvKKDQ7Y0+6535bfkWzWpyd72PThEmqn+sXNb+JqkN9mg+zQCpmI70qhzYyflHaR3iT
	b2PrwK2/pZ2fkgKTz+RKtQvniBxC7KYZ5hbU4Xomtz7AoWrOEwJ49RpbvVYiXHFoeSZxtB
	OkT+3cU5j14vtgk0RDPH10zpNAVYGm8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qfqVsyse;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D587460125;
	Fri,  1 May 2026 18:00:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075E6C2BCB4;
	Fri,  1 May 2026 18:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777658447;
	bh=ecInGWQ1trcTaP7yWJ2tHlKkLKFxveMb9c1g25SV4ko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qfqVsysebcVmMgHpD8BdVnP8JO82GIYOyJQ+7KZWvyHW8kdLuHqcibegrTq2MzMoC
	 Mlc5wccqAHbb3ARNJyL6N01RiTVqtgkXX7vWKts/QK/vkl8q8r1Cb9tFkqIzH39lWv
	 V9u6+s5oUfm18G7gE3mYpzHbi1mHrEXvgVT1Vmb+PBpbc30E6Y+qpTts1+ZUcdm/Qe
	 WRIDqXVhb49+oki2CAF1n+dsENVe5CmLoCi6Q/Kz2d4IQgUT7k5XlgTz73CuaFV0gC
	 GeVWUdcQ5D5Ne+kTZOIu/NFkSnZBcpumCIQYujkE3f/6uQEnRlci1jNZiH6Fk8rXNV
	 /JcyGUYdScMpw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0BD8FF4007D;
	Fri,  1 May 2026 14:00:46 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 01 May 2026 14:00:46 -0400
X-ME-Sender: <xms:Ter0aUjZIH87uTvGJ6qK2i8rFlC3RFAH-2AFe6b2YFczDJMbJ9nE9g>
    <xme:Ter0afXXjP8yplcDhsDiDibVWbxRVBrhyc0vJ1x2ydhrPEorINyzKcTh_IXOr_s3E
    2DXbw4zf3iQ8qZeVjUMyszBrRk2B9sD84E5RdHegQH7uO6QEdR54ek>
X-ME-Received: <xmr:Ter0aaxurQEPV09-sPZVTHt3PuOoCzgaia_kmivHEa6x0jb3Zrut5HURpx4VBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeltdekiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeffffekgeffjefgkedvjeeggedttdeljeekhffhudeiudfhiefgudeugffhheffuden
    ucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvg
    hrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfedv
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlshhfqdhptgeslhhishhtshdrlh
    hinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhm
    sehkvhgrtghkrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtph
    htthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieslhhi
    nhhuthhrohhnihigrdguvgdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtghomh
    dprhgtphhtthhopegsphesrghlihgvnhekrdguvg
X-ME-Proxy: <xmx:Ter0aSO9AzBiVMM8wxTXNdngEUOeEF5IHcQf_8N-P30u-YXYvFEb1w>
    <xmx:Tur0afYWWiHrFwlTficBnry-eTi_GCG5-QAWDINeqWJ-YbSg-oEh1w>
    <xmx:Tur0ab56lNLEKHjYEvBQlwUiaowt65pZiDxpPKivQXm8IsdNeYnRpQ>
    <xmx:Tur0aeAMHAVBKG1PWjlHgRvN5at7jEjHdqj06ntX8FzHfsXKtRELEQ>
    <xmx:Tur0aS6jcx2ZLDGsPWPSKjHZlZBiGly7nYpE8erDokkvtXEqmDrtpV8P>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 May 2026 14:00:44 -0400 (EDT)
Date: Fri, 1 May 2026 19:00:39 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <afTjKnO66Hl-XmfW@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZcmlIF4bmG0twkp@thinkstation>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7FFD914000D
X-Stat-Signature: i5aiuznraejunjziuo3zny1mo7yer8ho
X-Rspam-User: 
X-HE-Tag: 1777658448-270708
X-HE-Meta: U2FsdGVkX1+ahnlkACc4yO2op69sWRIXLwM8QbGUpzjcwI94cOvwLGFBopO+Zb9ZWLiqwNTWoJrLiTm7wURaVdVVC940pAADOtXQsQROuXmed9c2z4rCWi6c/B/88ICofAFgs41COAZFPulQLHYxUG9GQPxerxQfHRuuJu98SV9VtEy4hGY7Cak/hroBg+2wgigeYM1TcotHn8kJhuU9fM8U4wy39+am79eK1GaYzB4masJNAK7gT4db+sNFSbjGm1d1wmtW2Vx3iZOIBDGgJY8lLEsb1fT/MBOYWIfQrbCm/WvVAoVCYzowmiNhbnpigrNiXJBNdjb2830modXRDYLrDumgVxLYDyFxQng/2rCIGVWF+Ns8bKqXaPWwxcHAeQPqAYTmHME2tW6golKRW3o5ucqyhaIT+c93nPHWN03rWJ9jGRYd0eOUoNLGa+piJjgzBO2Wzz4ChpXEgIZFIsZVD94WG2VhQc2Egsiyh+R161timoyPRL51EIqJPDhF59YDErO5AEyk0Xz9kVPHv8P2Fji0KN/1OH6lrmuFtwzcSS8K4oJso2LREftSbkyQdVgtpP1GaW3HkA2eKQQdfFV7ai55IErncXJ96dEZmKOkx3NNlWuocUypk8pc9gV7sbgvsqW6qz8rG8QiuMpLh3NgFNKdftzJGEceCH54aDZWrNYpAbOwWERTynsbS9rxyOQ6vC560a8FnW8wB+osYrzP6hY0pUTe4vI/j7kDF+5vJ20K6g9nwBYUn/eRkqBA1ddz81giC6Ps9vYLfgJNdEgUgiZrPOHJRfoIaSHFtgEeVCHnK3mXFdH/F3LS1vOP1yqstrW/tKr3LEawD5cqI6vSJNWvT/xDWfAMPc0wMMt9MFDXYBREJZs9ocIlSz5hDRkBXFPIeCymPANC62UKH26SVXu07z6I4eGN6AVocRxQIo4wvOc2WjGgaKi73A1fJNlYb/cpbJJtVf0po7N
 xxlviuui
 EYTwHZ9DD7lfmKXainZYuNs8TFMwBgDN2+CO6cCZgPjKR2yZuchullFofsFW10zAHW/XDAsSkzlE+MkMXEusxUf+RwcE6sPP+z6qFrB++d1QfAE3A5HoryRjwbprE2MDQrx4TOAZvpL1OAFicyLVIY234aNJ2rOkTmGCnjo4I82ahU1JazYhbXPUA807RskwObcQ9KeQd03yUiKyq/hdtlrRuR0ka3dGhWVyd/NvRPX9lPRMyt4roj+kpzGNcdNRPs/v1OZXuUaTHP+06HMIaSXvsQC+XHTDdAeHfn/j+cqTS100=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:08:58PM +0000, Kiryl Shutsemau wrote:
> == Status ==
> 
> I have a POC implementation on top of v6.17:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git pte_size

Just a heads up.

I've updated the tree. It is on top of v7.0 now.

I can boot my VM fully (not only to shell as before) on all three page
size 4k, 16k and 64k. And it doesn't crash immediately.

Page fault handler is the most challenging part of the design. I wanted
to flash it out to RFC quality before the summit, but it is not there
yet. But it started getting a shape.

Volume of the code changes makes it hard to deal with the patchset:

 1530 files changed, 12675 insertions(+), 8669 deletions(-)

Most of it mechanical, but still.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

