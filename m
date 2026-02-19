Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA345E9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 22:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B7F6B0088; Thu, 19 Feb 2026 17:05:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7194F6B0089; Thu, 19 Feb 2026 17:05:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB236B008A; Thu, 19 Feb 2026 17:05:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4BDD16B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:05:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC6FA1CB27
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:05:48 +0000 (UTC)
X-FDA: 84462589176.13.6BD0189
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 105F6A000D
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 22:05:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PvNxMWWx;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771538747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFwW5t4oULKDy33XbEoyiBS2u6210hrDJsVpjlLWV/A=;
	b=Ks/ZiULcHj47Rw7vArlZO7H5x+xTF04VYWCF7d664swRF1r89oZpjribzXq1bem95MSRV4
	RO5OH98WC+HdgOztXv79kpd0QQGUTVP+Hou4OJfSa5S5VAq3mdMImHJSLdHqvbS246JcKM
	cH+8uibefbuL1FJQutbQ/OvtRoCz+AI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771538747; a=rsa-sha256;
	cv=none;
	b=DB+csuiOGGACuDFHHcIQFSX5tlH7sWIhTC5vtpI3KBCdXTFJeMQHXqev0JV8mJ3YmSUBGi
	9eGTF+GpIrTC4sZVXnBTu7XYZCKPBAz+7Wx6IdMgoFTjWFT8ynAqbRJRwoGPuG9J/+mD1u
	qkdAEIAvMAbpzjt1qaCJkakTMNlT4Vk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PvNxMWWx;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED6E843F40;
	Thu, 19 Feb 2026 22:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B865C4CEF7;
	Thu, 19 Feb 2026 22:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771538740;
	bh=jYFpoALfLCa4OWxliBejf6Dwu4SVOgXvW3YiZ+bEXpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PvNxMWWxtjPfkY5rVfiF/3jNb07aCbWYDzFbFowGzg7fod8MHf+9y+X13VVx+eGZ2
	 ++9gGq2nSZRc37dolcXpEhN6wZ5pt5u4K5RRaNBx2vXNZU6JhYgrilupKG7D+G/SOd
	 gW27vIKTo4wVhOyBx98qBDeTLfORWt8p3/qcio34nTbVZ9ABSNAb1jOx4ch9nNUBdL
	 ajosyy3ugTM7fCTgQ0Vci858hyQdgqU5TLL6A0+uKLGJcLKpGGvjkWOja74ogcThXl
	 GKTfVBDRgzo4sV+sAewe3tU8rXOpCSKjmu+EGKh0v2CZdtknqkTsTUKfRCyuy5gBvN
	 hlNL6cP1+5N0w==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id E2C5FF40068;
	Thu, 19 Feb 2026 17:05:38 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 19 Feb 2026 17:05:38 -0500
X-ME-Sender: <xms:MomXabZzRI8saiJzVIp5ixHntwojZLZD4_WeHSiCobOSW4AB7FeCRQ>
    <xme:MomXaankN70Fyp2yFl5crU93VM2jcF1Wx3m3aNDmfGJDh90-gLTFkF00Gmq31VAQW
    aPMddAg5h45R45Y7hjKf6UbNAt60qLQEFQXkFAfw6gy40x_E39nlC8>
X-ME-Received: <xmr:MomXaQmX63VJtB7OUQc92wBHUwLQX4c_ScOSpSxltP-JCQZ4BeSHPWxjdio55g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdeiieelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhrtghpthhtoheplhhsfh
    dqphgtsehlihhsthhsrdhlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphht
    thhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopeigkeeisehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhk
    vghrnhgvlhdrohhrghdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrth
    hiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepthhglhigsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepmhhinhhgoh
    esrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:MomXadNbzT91tL50PAkeXYXMy6NPNuIxq6aUEoqPNLxeE_fOyYaFPQ>
    <xmx:MomXaaqfVSAz5P-xPysQz7oZ11bnUHFd5EX0bDQWorHGwq244blE3A>
    <xmx:MomXaQQ6avArNOa2LK3YGWJ_nDfbhFxkSkTjxXDVWh7Jehy4lj8Wkg>
    <xmx:MomXaaaXpv1_9fjLZhIVD7C3AG_61kiY17OZ_RBDT4_QP2MnVFqlJg>
    <xmx:MomXaUMbVhEeblKoMaH5Uf2AI-7Dv8lLUSb0oHy0oX7VQyejcAo-9KRJ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Feb 2026 17:05:38 -0500 (EST)
Date: Thu, 19 Feb 2026 22:05:37 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZeFeAP9Zh-9q7pH@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <46817fe5-7166-4734-bad3-3109cc7feb1e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46817fe5-7166-4734-bad3-3109cc7feb1e@intel.com>
X-Rspam-User: 
X-Stat-Signature: o1u7cc9pdufw37x6td4dcbzm3ke5qsma
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 105F6A000D
X-HE-Tag: 1771538746-534320
X-HE-Meta: U2FsdGVkX18akWOSLITWHpYLZeCTl7Vm6G/ns3G9Q66VXBNk5ErKfJ0IoGddM3LrCpLX7hfttUdvtp7GUvetZq4Lyik1D8RD+QDM3S7HDDkV9oBWrdg5ywJjzA1dkkLHNFIN2aK0lkZWevKVuru5MQhbUxRjeGWFjCpLGOBu/dL/1QJU/S0T/AcbENEnyBhbPGAuSMTRlWw7HTzJur6LjyNCvwHGFOGPHKBm4GbA8OTz52gpnS8iBqwj3i0SRxI9S8CAjkapXCS/hMeREOhEE7z/OqlRkvyTP3V/O/FS28Vs4WtZhFye06fPI/xpo/fqiecom/OYwQcocWTkJCqA3r6S2cyNeyUQjSIE10OnJCd0ihc6+VQ3QrgstLnQopSUd4colOqXIlGN8y2Xe2v0WdRWrnMFl7mSh8p8YpkhhWzLdQJ9HjN5pwfMXVCKWtndrt5OMeSr4x+xqsJ+hj/DRUUXXNbrZlMfOoaYd6cmt0swWMMHYu4mzExOpyC60lDxrJINGVeEhTOjwooUV+wVqIdC2jTB57UjNZBiCFDqy7NXNiIREJSOMthKYfhr7266vdfKIXhrC56F35ZJNa2u9t0Xbn6GY+wibirD8O574L219GstyysnE/IBGnBju84JWSIlqNc2eEBLRp6VRLaFgjDKK48W4EFBOv929VqiU1U+2qmFIOVp+9EwiWePFIhcoMi8wEGAWDJVEpdk+CRJVpU9m9/zVGqwrK9nVxsvYpcDWYBU5w3uONgO8gXDb7ix/MxwtrcLlAgHYDA7FyvdCPtmzw7JElV8F9X/B9UvDJXMclH+jb8xG830eVlEiAqvDZ7A8jxWpPSnq4vkYx8SIFQuaH7e31lFNQv6mx278KDuEl9g/s4nzQa14OuJ0mkoHdMoYki6ds9t1lZNEJ70x/640US/k0cVlFlJZli0v58+GfeYj6fHQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 09:08:57AM -0800, Dave Hansen wrote:
> On 2/19/26 07:08, Kiryl Shutsemau wrote:
> >   - The order-0 page size cuts struct page overhead by a factor of 16. From
> >     ~1.6% of RAM to ~0.1%;
> ...
> But, it will mostly be getting better performance at the _cost_ of
> consuming more RAM, not saving RAM.

That's fair.

The problem with struct page memory consumption is that it is static and
cannot be reclaimed. You pay the struct page tax no matter what.

Page cache rounding overhead can be large, but a motivated userspace can
keep it under control by avoiding splitting a dataset into many small
files. And this memory is reclaimable.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

