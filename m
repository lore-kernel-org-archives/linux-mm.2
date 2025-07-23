Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B740C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 051F66B0089; Wed, 23 Jul 2025 05:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029736B0095; Wed, 23 Jul 2025 05:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8246B0096; Wed, 23 Jul 2025 05:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA4916B0089
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:08:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90A5D1DB25B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:08:45 +0000 (UTC)
X-FDA: 83694954210.23.FFB51A1
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id CCB27C0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:08:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=u6gZzA5G;
	spf=pass (imf10.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753261724; a=rsa-sha256;
	cv=none;
	b=BF6dyqIQZlm69+OKg3OFNkFPs8oH2HiFtlzJuB0/zAm3CpQbpKGsF53bfWOnAuF7hJaDca
	mwWRkOW+bmF4j7PjYpJ3Z3jIHp4Ib7xwg12BGHirYztqpAUKrafwwwPyS5NQNqL93zo7QX
	mGL9RaasT1tRQicVlAE7KsWdw/L1hHY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=u6gZzA5G;
	spf=pass (imf10.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753261724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOKShWyoy6jXvtzkZANxNISGUx+8cVqAN/UfQ1f8cYY=;
	b=A/E6phG4pJPKoXZ/E2PoxRBjbXDMQTHSWPiSMsWADduaRyLF5wCAAxsZLmybN22MTJDS6s
	plVfuiq9IWVpLF9AvI+YxWbk8LaiuYdSnZTl28l7GWpm/cFnTgsApvAl7IiAGOsm4rg54Z
	Azt/lYivgipdFC7mXXEveZUePbzmrDM=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4bn7bW451Pz9t8S;
	Wed, 23 Jul 2025 11:08:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1753261719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oOKShWyoy6jXvtzkZANxNISGUx+8cVqAN/UfQ1f8cYY=;
	b=u6gZzA5GksvaoP9cxb48nlrs5FpzaMj2hPOcyVcmBc8EuIohxGTkhBQXTKG56Op47pBC48
	7oz+I7hsf/5RDixMmvJVA/p0LAnpsP7+ejws+6mTe3h22Vl4U2mXAB/UPTWLgMONAas2Aw
	7N4+p+P1awZLT3fdaFBZ9t+3YXqQYDXqzw3Skz+rGH1jQIqLRPrLua+sTvaHMFcrNN9Gns
	n5aoWmp6B+USvzhS0fjCdvrKXj65/jvJWIkngC1gyFZyyZq4QFoizpEI3E6nu2n2jLMTEX
	KMGUTHsMyxtqKoBFbeugz7JNoRvEfhHxhUFrx9I8gatwbK6qeb0r5fL4qEG7wA==
Date: Wed, 23 Jul 2025 11:08:23 +0200
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: David Hildenbrand <david@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	willy@infradead.org, x86@kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, 
	gost.dev@samsung.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [RFC 0/4] add static huge zero folio support
Message-ID: <vocblxknnal2t4756bkqcdajt2gkctp2wdjhfg3xkp66j47qk3@saj77wmrflqz>
References: <20250722094215.448132-1-kernel@pankajraghav.com>
 <e6648680-da88-4f01-9811-00229da858e6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6648680-da88-4f01-9811-00229da858e6@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CCB27C0002
X-Stat-Signature: dt7g3r6yahw6b7igmpdsxxq6is48hi45
X-HE-Tag: 1753261723-115696
X-HE-Meta: U2FsdGVkX1/7JdWplrQeeNytgl7a+uBgtQ5Z3CcxQBTwsSdNSRhdjhxiLvloiAAMRODRqcs7cfRhmL1gLW9QApRXIYj45lUMsNCVDD5pwxk8EgrTPh5lMtA65u6kKz3X53Ei5FW6XCPEXxkRcDHwoVLyx9U9ConPstxN0iYAd1OANGUYwzehAIXLI5xhYplGs9W2YvJ1fCBQRKj36MFVvXnU7OYdK2Vchwsm9Art3k9rqOBg/ce9ZAQqi3t/bKaKm3oASHSOSs01Qv3AYDibra/cq1btdBri8pBA3Dx+lBi6ZdrSWACJ0qimv9cMBrC3bVj3PRsW33n0ixa0uMWQlmhZQbBW6SoHQbh0nCQER/WmVbJ5JdrFAz9INhnTMNwOo/cj5iWh/lkA3Jd7SVvp48WA5iaOV+45LxwxpDlIqrn+jn2BAbjTNJdKOjaCS6qTcV6SAymOl2uB3RGLxryBZiDsJJUah6LkFj6c/YNK3p9KRpbbjZFFOcOFGATNRyKibc7V4G7BXC7JnnTgJK1HdU+rTbhpM2NrDB9zO8Cah1RYHPLoc2UQ15e3tpVxNO4p5ikbvYF5LmGETyJQmzsGe3otaPNF7vZCX68gc4AHkySKCGq12Kgh0A8r1/0mtTNgf6h0cFM2nV0bO7kfn7waqIZIefOqAL3f/03lnKyTYEw8JjyXm2suK2hgcvQMyp+DPV4vx/AyJkNXm83LRRXxJPECF24zrBwdHcS211ISrH617IZYeLlH7LXJGXZJ/FkS0Xofo6yjvkGagTmXXS3ZvDH+UfrzvjV6G0zh11zsBMML3djdjpGF3J3DGTJOo7KSTAtTwnWM9YEEW0ca8XKnEcQ+drAmcujXUVeekbAg9atzqumJDBYWaWvOXSZobIQ7qm1SDO4CV5LfP/0qwr2QocW0qgz4uFPs+XT2Qx+ELAFjW7XkE10901bSjAcOqQxCC7vfoVFJnNlSBIFhkZt
 PJpNqwLg
 3ywlgEZEPHfXVAbKkK8vHlPS4rM2Jxjl8MenANeo/CExYiSlrIf8lq978TaX+MFdM+7Cei3e6KX/PSdu26bOofCp+viZuF2lZGpv6gsq6r3Cqmz2inXsmFr34cc8elhRm2mMItcsLyuzsg8HLWlqF408D2sR4+c+Cm7XL+a2SicvODsibRJJMLdPF8rDeITPWvvOQXXnmkzQPig771uMdj7yMolT1MWJZV8LoyKMbQolV5Qu9dTdte/ax5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > 
> > I will send patches to individual subsystems using the huge_zero_folio
> > once this gets upstreamed.
> > 
> > Looking forward to some feedback.
> 
> Please run scripts/checkpatch.pl on your patches.
> 
> There are quite some warning for patch #2 and #3, in particular, around
> using spaces vs. tabs.

Ah, you are right. I usually run it as a post-commit hook but I forgot
to add it when I changed my workflow.

Thanks for pointing it out. I also got a unused variable warning for huge_zero_static_fail_count
as we don't use it when CONFIG_STATIC_HUGE_ZERO_FOLIO is disabled.

I will change them in the new version.

--
Pankaj

