Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA43D0E6EC
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 14:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120656B0005; Tue, 25 Nov 2025 09:09:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D1E76B0008; Tue, 25 Nov 2025 09:09:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F293F6B0093; Tue, 25 Nov 2025 09:09:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DAD466B0005
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:09:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A56A5603E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:09:48 +0000 (UTC)
X-FDA: 84149312856.28.5C10A25
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B1A440013
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:09:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="O MPvzKl";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=YLka3iJJ;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764079786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bMvsZSIiVU3pUA1Q96vlRsnQkJ+zVUPQsOHI7GHg2U=;
	b=SMOth90tP1AhQMJSXavFzfcH7FTpwIwrCtpZQsA4iBDcot1cd/rvgUtYIFOatrqAoZbV6O
	DBdcIavaAvtKROxDS8t5/xlpQFNETvd3in+JV/JKQcP+msTd5fBcjB5WbUMBVbWvEYhhXF
	2E3rAL5hQBqtgYD+U5oYxYJAYRu2Nko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764079786; a=rsa-sha256;
	cv=none;
	b=GDWDvjvq7Myi1U66ZVxaixYmEo7sWDlF/Z/Q+TJNuOSo7e3aZQaUy/6dhLjLXO8sliZ2VQ
	zA21O4aXG/b9gRAjjaU++uCL0Hg3K8ST9COsYASPgYCQy5fZYn+Fy9pk/fRXPs6dM7HjTe
	tcTF8nWwJblrdWc1a74UruBQQntsFxo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="O MPvzKl";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=YLka3iJJ;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailflow.phl.internal (Postfix) with ESMTP id 809B21380546;
	Tue, 25 Nov 2025 09:09:45 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 25 Nov 2025 09:09:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1764079785; x=
	1764086985; bh=3bMvsZSIiVU3pUA1Q96vlRsnQkJ+zVUPQsOHI7GHg2U=; b=O
	MPvzKlFHkHMEkgAvO1Uyss+96M/hGKj5YsQfHejRjOSc4qcoxmXMj4hhXg44W1Ef
	f+2FZmek/Vp7VMAcKSWKu5vw2ELUh/4TKqh05W+XH3fqT/kg0gRDs1cSTZFEzwsY
	lfUK/XstLQ/GgwvHNBGpiPsihS3C907bycj46mTcTPjPWBcIFuNO2mkJK87dq41v
	nEaYF+SW/r9n3rXEn7zZvJvhaqJKngqjJVqgYKouNkyWaY7csAolp+xbmx+7XCc6
	NTnu6vEK2LnrusXBylHkCIdYJU8Qwx8yLU37YVnlHB1bRfm2yV73RrmEmaeu/OnY
	zVRksTDa34siBV1sEgVBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1764079785; x=1764086985; bh=3bMvsZSIiVU3pUA1Q96vlRsnQkJ+zVUPQsO
	HI7GHg2U=; b=YLka3iJJS4uHYf+RVmsIhTYDXpAvrL5WrL9BPBFcYF8nsukYggb
	QHO6tT2dwT3h9TcJys0ZthsLNKdLgkuGaDv5MkN8DaRBDYOvSDFB76gBeKNn5W0/
	CVCemM3ZxiBVvJLvrV/KsXaaVnrH/XSHm5BR36zUS10Fj/JaEk3C0JUVf4tBZhI1
	rwv6nH1MsGZq8Rx4O9829S+HBuzkXZM4K4wcZY5iTTS7mIR4Fo1mVU9WkuJ1CMd2
	uD6szhHUcKTSLnb6TESaW5TxAiS8SqYaev0d0D3FkzA2naE3DgHaXS1hUhvkgcn9
	odS/eCQqz0+KbMLRtjqc8IUq4qTlSRV2bug==
X-ME-Sender: <xms:pbglaWvKN1DJZAzYSwKMRx9-OgT3rdfcTgkjojWPEw8KNW7Cx0AEAw>
    <xme:pbglaTXf9w3AHkCR2Fi9l8wIxJHg69s8vY_NmbLplbMAS7ZPJhAxU4ZyvP7W59tRY
    6tYZ94S8k6_dYSWuO2CmKlawxLgNFJRUNzUYh5ghix47LoIvHqcJ3E>
X-ME-Received: <xmr:pbglaTVq6gxwgmVLYbKwhZEo3Ue8V3Yipkq04ow2rgFUWOH-1wlLy2M77sQWTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeduieejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfhfgggtuggjsehttdfstd
    dttddvnecuhfhrohhmpefmihhrhihlucfuhhhuthhsvghmrghuuceokhhirhhilhhlsehs
    hhhuthgvmhhovhdrnhgrmhgvqeenucggtffrrghtthgvrhhnpeejheeufeduvdfgjeekie
    dvjedvgeejgfefieetveffhfdtvddtleduhfeffeffudenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepudefiedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepghhouhhrrhihsehgohhurhhrhidrnhgvthdprhgtphhtthhopehlihhnuhigqd
    hmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehkvghrnhgvlhdqthgvrghmsehmvght
    rgdrtghomhdprhgtphhtthhopehlihhnuhigqdgtgihlsehvghgvrhdrkhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtohepnhhvughimhhmsehlihhsthhsrdhlihhnuhigrdguvghvpd
    hrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopegtghhrohhuphhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtohepuggrvhgvsehsthhgohhlrggsshdrnhgvth
X-ME-Proxy: <xmx:pbglaW_0cXMtMthUHN5H-fE7CGn6DIwBKbPochRZeWCN8gj92pgAfQ>
    <xmx:pbglab-e-8tK-jGoWZSTzd4htoSykssNFuRJIH-N3luEajg_qhcROg>
    <xmx:pbglaS8xVJOZqKo-Vsq3I59doGzt7pGvGwt-1UuY4j1VdvVF-sGV3A>
    <xmx:pbglabLAvm1PrWnHzKLnOzKQUK7tS39E5pLPz3qn6MaXu68uj2z1VA>
    <xmx:qbglaXODIQJ_Tp6UtA9zcmakBUdCO8tVHH50Z00bPS2jBHC-6eFUxFQ4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Nov 2025 09:09:40 -0500 (EST)
Date: Tue, 25 Nov 2025 14:09:39 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-cxl@vger.kernel.org,
 	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, 	cgroups@vger.kernel.org,
 dave@stgolabs.net, jonathan.cameron@huawei.com, 	dave.jiang@intel.com,
 alison.schofield@intel.com, vishal.l.verma@intel.com,
 	ira.weiny@intel.com, dan.j.williams@intel.com, longman@redhat.com,
 	akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, 	mhocko@suse.com, osalvador@suse.de, ziy@nvidia.com,
 matthew.brost@intel.com, 	joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, 	apopple@nvidia.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 	vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, 	bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, tj@kernel.org, 	hannes@cmpxchg.org,
 mkoutny@suse.com, kees@kernel.org, muchun.song@linux.dev,
 	roman.gushchin@linux.dev, shakeel.butt@linux.dev, rientjes@google.com,
 jackmanb@google.com, 	cl@gentwo.org, harry.yoo@oracle.com,
 axelrasmussen@google.com, 	yuanchu@google.com, weixugc@google.com,
 zhengqi.arch@bytedance.com, 	yosry.ahmed@linux.dev, nphamcs@gmail.com,
 chengming.zhou@linux.dev, 	fabio.m.de.francesco@linux.intel.com,
 rrichter@amd.com, ming.li@zohomail.com, usamaarif642@gmail.com,
 	brauner@kernel.org, oleg@redhat.com, namcao@linutronix.de,
 escape@linux.alibaba.com, 	dongjoo.seo1@samsung.com
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Message-ID: <h7vt26ek4wzrls6twsveinxz7aarwqtkhydbgvihsm7xzsjiuz@yk2dltuf2eoh>
References: <20251112192936.2574429-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
X-Stat-Signature: gz7uskso8ojbsswj8g4xkn3gzte4fxb5
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B1A440013
X-Rspamd-Server: rspam01
X-HE-Tag: 1764079786-57746
X-HE-Meta: U2FsdGVkX197uuYOef/NzhypGHaqJvGe/AFFJrviDBrdlUuO/aOTJoCncGNqrg97uQedMgxT1qYvlGQiFPTYNzdo4WkHRo8cbxqs3+EPoKIyAeMzUERBsO0/xL8XrWl65R2UbcBmgne/Ws/MKmf7uG0UphvfYZzujJ8NXQ/IZkfKHoOGD1RbN80yxyYge29NvMHQAIe7HH4z0GxVifnwmTRK6+h+1XmVjex/WytMV6ivKyZz82fB/bOOE13j8kaJKW11aDyeWSQ+TQy8i+hIN7vgw6kdcdgJx8KxsmLK5SijfB9veXvWZ3vMaWZ4I6U6bORWdoNbpNKSpvADJVG3yfZK2PIVuGJmwTR9Q5r+FGJHIaPMsJAZCMKkzIhYGhkQNyx586Pe7o269otWo3nhSzzu8bmsnXBqX6rPuUe6eWydHREpnxOqGEdzF+7A60gYi5vUAX0R3MktVIBxmQfab6MP0YSqTKdyxSARzOMkSjHyoraBpLxG6Uuyptrp4aZFZ5y24Lwa6FMmgUZg1GBMtOzPkqwhSMzZe+hHvAv6OKONQHExCQKKAKgzEtRanHYhUDvp1naduYJfiDAF3EJLbnlwxW7tH5BV03RFot6ZSGxtD2ouEBH3P6SiBO4vldV2JyXTxqiFJrYqbjg1Gk5qscF+QK5tdpdnYva46NpOp41m0kku804fYzzEDccZkKodidXGWDZMhMnymcJZ5GzxOfVUKCZ1Bv9S5jOnUo2K7BNF6jchWfG5b0g9zx6MKv95qo0p0xskmDK/Y9z4t12rsaRcz0kpDAZ4irqjH9B4S8boPN21+hqJNE+rd+fIYWfHdLOLIsTfucd2nAv29HL66tP/FMlgT08I/yxUQx7WLHIMr/QD+pK0es8jd+Jsg1gYb2dgDiqOi12gIsuHdakxhftH490vmH+esz+K568x2s+dWXvAJTBhkj2bgr3DhZAuu5Jf29B+jsE44YkCQb7
 Y1DcogOa
 jnm8HH1VsAnx4i5YTCtKVzs3ziOUE7fzRUkoR8UrdtSHnSreiGO1vrFVoBlWBYziXBe1Rmoy/CRD8Q0OJLWKcLDDNbpxLLGWqZbHrDpqBowPA8UutFRFrb+2exN6R34YiVwAqd4cSwbvscwV//prEsIYRqrk2uoE3IM/nedHhyT3xIOJnlwFSXUpsQAtIyzu4nwTq/OXKj2MYyAHLZQ0s8j1oMs8sZF2uN0ahTrJunjBkCwKkLo6xAYTCSHuvXjSehlFjc2f8deIUxUDGkjy03LfLHlFUXv6Dap1Ezs2WkuzyGSrgxdQmSidKd+ymdk31Dr4pJANV0Kjh7sobeuZhIHCLro8LxSXmM3PCc4Lt4RfBynJZ3z05rhe1ARxblKMRJuY3tBkbv0eLIYZBtwSNh/0SFM9sqEvFdpdobLItNXDhJ6Pth5v20hC3Y1qNsRF5v1rNEM/EyupDBKg3X5loutdorafAUcwDMJloGq9vHmeFsIWOu2wl5OSvaFjLnpKubQWh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 02:29:16PM -0500, Gregory Price wrote:
> With this set, we aim to enable allocation of "special purpose memory"
> with the page allocator (mm/page_alloc.c) without exposing the same
> memory as "System RAM".  Unless a non-userland component, and does so
> with the GFP_SPM_NODE flag, memory on these nodes cannot be allocated.

How special is "special purpose memory"? If the only difference is a
latency/bandwidth discrepancy compared to "System RAM", I don't believe
it deserves this designation.

I am not in favor of the new GFP flag approach. To me, this indicates
that our infrastructure surrounding nodemasks is lacking. I believe we
would benefit more by improving it rather than simply adding a GFP flag
on top.

While I am not an expert in NUMA, it appears that the approach with
default and opt-in NUMA nodes could be generally useful. Like,
introduce a system-wide default NUMA nodemask that is a subset of all
possible nodes. This way, users can request the "special" nodes by using
a wider mask than the default.

cpusets should allow to set both default and possible masks in a
hierarchical manner where a child's default/possible mask cannot be
wider than the parent's possible mask and default is not wider that
own possible.

> Userspace-driven allocations are restricted by the sysram_nodes mask,
> nothing in userspace can explicitly request memory from SPM nodes.
> 
> Instead, the intent is to create new components which understand memory
> features and register those nodes with those components. This abstracts
> the hardware complexity away from userland while also not requiring new
> memory innovations to carry entirely new allocators.

I don't see how it is a positive. It seems to be negative side-effect of
GFP being a leaky abstraction.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

