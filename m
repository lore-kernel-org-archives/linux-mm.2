Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA2A2606A8A2
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=FiNThKXp
Received: by kanga.kvack.org (Postfix)
	id 2582B6B00EF; Sun, 15 Nov 2026 22:59:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208846B05B0; Sun, 15 Nov 2026 22:59:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1200D6B05B1; Sun, 15 Nov 2026 22:59:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3B6F6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:59:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD6411405CD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:59:12 +0000 (UTC)
X-FDA: 85439626944.12.87A7242
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2BB1AC0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:59:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FiNThKXp;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794801551;
	b=ShnExmv4i/+E33aVZ+1bGtuPCvcnTjfh2f5O//+LkSfcB+sseQTTKHhuRRn8ERkN+UJgm+
	CTVdm+OQ9pkmkjduTXioYmHVM2pP+soGO9UIFBXHxGiZAw5Hs4gTTEimTGDbmi0E9UaM4a
	Osodt6LQ/GOEziz2OKR0H3/ChXRPdRA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FiNThKXp;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794801551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQMeTciaSvtzZf1tVwUK4oeeC0M0LiTFBkf8Fh1eAgY=;
	b=OYnyEkBMizPnKEeLf6v5gCiR2Z5GTzsLZleF1vif/TotEIzYwnlAxiUcrXlEtPPoDYix0R
	mtNSGQvxmI3lcNxtYXOrTdm5N9TiHktarszFOVYJqmCg0kABRjv3FuPVTMJHsNNP+yeGtd
	RQKIm/LZFbHnOhFa2hiRaUbZZDTYyDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BB6B605C4;
	Mon, 16 Nov 2026 03:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FA61F000C4;
	Mon, 16 Nov 2026 03:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794801550;
	bh=gQMeTciaSvtzZf1tVwUK4oeeC0M0LiTFBkf8Fh1eAgY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FiNThKXpbOTA7jl7KFxz3LJ0sP0PgD/jW1RF4aayD70XAnPUFJ2QNrDNjB5iFIlo1
	 M9AAsbRaBCEruyahEGesuQhgqCnzuEN8YUeZZ8vwOetkY2anSldYSYdfV9GmKPqw6+
	 ddMzBfhLFcDnQoX8jFdcGsPrx/xbjHz0D3KgUAPI=
Date: Sun, 15 Nov 2026 19:59:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: sashiko-reviews@lists.linux.dev
Cc: sashiko-bot@kernel.org, Matthew Wilcox (Oracle) <willy@infradead.org>,
 linux-mm@kvack.org, "Shardul Bankar" <shardul.b@mpiricsoftware.com>, David
 Hildenbrand (ARM) <david@kernel.org>, "Dev Jain" <dev.jain@arm.com>,
 janak@mpiricsoftware.com, "Jinjiang Tu" <tujinjiang@huawei.com>
Subject: Re: [PATCH 1/2] lib: xarray: free unused spare node in
 xas_create_range()
Message-Id: <20261115195909.b91edf975dee06ce566e3437@linux-foundation.org>
In-Reply-To: <sashiko-outbox-216113@kernel.org>
References: <2dfabfd9476542e39c7d5473a6597208.0@linux-foundation.org>
	<2dfabfd9476542e39c7d5473a6597208.1@linux-foundation.org>
	<sashiko-outbox-216113@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2BB1AC0005
X-Stat-Signature: cmmyr6st1fdjnye3sfutzwhpnertfsdp
X-Rspam-User: 
X-HE-Tag: 1794801551-946855
X-HE-Meta: U2FsdGVkX18bkHLJcQK0OLlyjBxYlVHEU8YCS6PsW6lYuDsxKegIrX+rIJ5++LNwq8TgkH0L1Oq4EaIEw/wQUm/0qAnOHkAx7MmkVZVRgFNCyP1vqO4CQAef5i/hf+068gIW1M72Lw0dUqg6Q/UTLdL4JDZP5HRgpKg4kJnYMUnRNH0KZsu+6gr0I2BjE754DQ+pbnCvZQEaZhg/bYYY1DVO5gtcKUNzbnkof3izlFBOu+YKssOO276rAMpx7PcWP89e8AyJhWlI36NgZk+rndwsYvcjctssF5dyDkpLG0SDgm68QzdDDN3UHIfmaHNke5jDv2WcB4vI8KJVskLljzUPdLu8B5IBTCtm+sFsup9H9Cu9daFvl+gTUSCHIRw30q184MOQH+6LJDZ5vFIE2saKaOSMLkP01ahBRDNpxLrR1Lroo+aguf9C1mdcG/Nn5qTVTnkRr9iyrlhaT5eGPVigbn+f/Au6yy4qF70Zh0PA/m7i+ttoS/RgwZjkoAEEjG0O7PSVHLSmVmkYSST5KpDH3YUTyaR6xd2UaKm6mQJknC8DfzhWCWjhi2uxhbHLAkrTKo4vbaEyF44INaSMNo852aWRf2vDx1YPULIIiKTRO9DnLOaFKlwBeXMwBb2aZeVPvqGs6JOjXHd7NIJdpfCWwVFzvqkenu4Si3U9mzbDgdryvy38u15rZinxSfKSZ5q77KkKBcPKOCXSMAtkMoms/oiuaB9MdRPhPmdnDRK0Fkmxc/d3phfv07T+r4oyvvSjI7Vby04L33IkdUdplFg7Y1OC1DH6fzhOhnoWbM+nRgjc943t8imaaQ6uCi3p8Y1ogvfXAEk5fznbNUZIVNWuq4LTjOJ0Z/aAPcK5wDv27+TZ3dcL0YxEKwf4XRcGm/JBzFrK/qb7YZRq1HKF3KDdoQBMoF0Ax2mKSGosxZcwqF6DQfOnXz+HJkaHBzR3glRFr5eHQHCCKB1Ogq+
 f0e6iF8q
 Yr30jvxVdrhPf6aQUs59vl8c1QR98YonUspcVMvnO/+/EWoHwVM1XFgaAb5Qs0yD4t7mB9B5uv7SXpoFdkNPwN11hIO/xBwsSbqDLm3L02R016ECphsPqTTzZe3wxyPDuYcVBBKYe7WVZRsRIYDMtd8DM7dUIrZYnOQyx+PFPs9NB5kMn6V2VjY8ptfdXyuJjGaOTL1Qnkp9yUjuU7V6FYaXBuRl56eQefpHEmRmVmQdWpNujoL91SWUzD4NbPZpGNAk2tsA98CrHvLljWxybO83R7QQrZqvhF3L1Wu9CsJN4UEtYdXPMh9qUyd9g3BdXOvQm49jBsIWL5PLvFBpGtyqg4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 03:17:13 +0000 sashiko-bot@kernel.org wrote:

> [ nag nag nag ]

bah.

> [Severity: Low]
> Is the Fixes tag pointing to the right commit?

OK, let's make it

	Fixes: 77da9389b9d5 ("mm: Convert collapse_shmem to XArray")

it doesn't have cc:stable anyway, but afaik lib/ is subject to
-stable's blanket "backport everything which has Fixes:" rule.

So I'll also add

	Cc: <stable+noautosel@kernel.org> # not harmful enough to bother

unless people disagree?

