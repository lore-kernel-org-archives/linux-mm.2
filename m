Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DED5CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 19:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7A4F8E003C; Wed,  8 Oct 2025 15:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B523C8E0002; Wed,  8 Oct 2025 15:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FB78E003C; Wed,  8 Oct 2025 15:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 97E648E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:57:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43BDF13BA2B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:57:09 +0000 (UTC)
X-FDA: 83976005778.15.02B15F0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id DCB8780017
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 19:57:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p7Qh7IUt
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759953427; a=rsa-sha256;
	cv=none;
	b=hpz3R8AiuyFva+MASc7SWUgLUdiGxr7tLN29xJWZdr3G72turS+an/FgHZ/EJhOjxJ1IG5
	jjfbffiypP/S+9rLP9vEJyAgiQL3P/4YjYuZbcUUzvCdNRHcwlMIWiCNClK7dtzo1H2eVb
	ZK89uU32al03lrx+uFrSKI7lLU0xucQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=p7Qh7IUt;
	dmarc=none;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759953427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGaoS/61gkMrgKWFTNNh8sJ3cDZ7GISkiMTek91mBGo=;
	b=lT0A53s7VybFcAO4KlkFjzZ7HVghTdv6Xc4EUwcsLB0D6QGnGY00PV3MibU1tz59qiY47a
	0zDT1AkSl8lVeVSMQ9BFzg18JPgRLvOlmzAEsMC7lW6gSh5AE+cQ6hJ2PAjQGaum/oonlD
	LrDhXEuuOIFIqqEyuwjyCeYGHRPUuls=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GGaoS/61gkMrgKWFTNNh8sJ3cDZ7GISkiMTek91mBGo=; b=p7Qh7IUtTzlFf784v86b9RAkZ9
	w3NpwpZfygMr8JVNcnR/sJBi3jipjlhqK8abdzeRo7tlRUqTKm4FoR0OQLAGZYthiGIJ0WmKuBcFC
	KbgCT4u4YQD+3CYM4U0ZML/k40/ZBAZ2xM3rf1q1uRoq4QFFHtPeCKnpwsIZUr5kCjSSpa8cMe3AL
	zJJFHn3omQWuVeVrDdTcBgGeYY1+XCphcWGhNCm6v3w2zbNu1kbPZEVvTrzMpYjZ2VNUJyvy6ujQa
	mgejra8dSceGA8U6lAGrnXuJESBDEbkNtEgevAgVwTca3AB9HkPsMeJBPhrVMfTuDg7WwdmxFjliT
	QIwPf4xg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v6aHL-0000000BzdY-2SAf;
	Wed, 08 Oct 2025 19:56:51 +0000
Date: Wed, 8 Oct 2025 20:56:51 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
	iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v5 1/8] mm: Add a ptdesc flag to mark kernel page tables
Message-ID: <aObCAwbf1-Sxepni@casper.infradead.org>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-2-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919054007.472493-2-baolu.lu@linux.intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCB8780017
X-Stat-Signature: dzbfkz4swrui6z7r71kknnuk3qjsa9g4
X-HE-Tag: 1759953426-472232
X-HE-Meta: U2FsdGVkX1+cx7Jh/N9uPrPPtC+ZJcG3Bj5yHFKsbUtP86FZ9itWSiUQG1dwu/IUNwsXIaiiAkmWpEZh56TNBMcIlhnEoC3cySdNiZmm8/IveKMlsgyDrelUgd5p8Unn1rlMI5GEOqoxq9Y7SaMl843e+zQHOhzcngjc0Ul9xSL/lfF7aYgXAWZhoBYQhZ5RoKc83ILRFTBon0hWpXM7x+zgubsmWWxSS8cWeGtv13sQEuQQ+wouGVG+KyY2idAD1eHPVM8RDn28FGGxhUXH/zhsaJk75L7DEg5OX6Cwz26vIZGrY9QOzUJZOWwIzlY5N7ZQ+fyafMZtdG3htdvoIsq5uz1Viz6fXSG06YW6Rtxn0yE9DTkuqjVU+dlHS8PtXpmVUz5XtqsCFKqNI8ky+fSNuZXFuAoAD7FmPklACX8KguDAFfClvaSJbTnfxRbASVWCFDr0iZxpS+l7BdkWuksjLBGWC9OnWXHT6Q8UxViVKh3xHM/wV/0TLm+FBNx4eY9TpEknZOTF9sFgQRT9wKchnDUJKyV3J1pN37fXhvZH/B9UfkZ3sH0zHJEdjaM6jZnR2na1EEZNUo+5LUJ9fz98TEuUr/s2PGtvnI9Fz0PBCBCNs8wY4PVJf9bZV7O266RLYrElNi+hQVRWTpRazJ1SQg655lHPaMA8N4OAFqQ7o5/4qsspux6wyAnXc3P6bVihHdQCRafTat0kM6AutazqIhufO+aMuaVYK0k7vVm5nO3k2M5I0MumrGDFlg6Y2MPUfLDl4P7ls7mNRf9gdaTXtQm5EuRcur+PsA/ZSKIwM+aMqT9dk616w7Beujs39ZElpn7QCcmRKuomjPN1mhx0vcyBY0QsE+c3q5czSamI0q5gukykYy4+51YnU+rkoJ+Ick6qLowqqJ1xF14Hm9xlXOd6qP2bM6OlHvb+jVlqAoHQo7UO9eK5U6Oqs+NboZJcHOH1Zr3+caQno19
 uc9F8dfb
 vtDzfRvsAHCEDG/nftJjsqMFBkoryx3SCmcOyZXrzyoVV2KZpXbNpAEFg4SQo8wFcZGaJx3vksKgFHARZY3vtlD9lW35p3oyi/G4zA3tPxR527LCQ03nvlK8YfubLOYpsR7Ti+9lyE7XUzAJZob/nFtjDqxNmSn3t4kL1QQgNiorYq0g9V2gQulx9u5zy2Wh1vY5V6f7nZvO3AOTnw1Fp9rCsjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:39:59PM +0800, Lu Baolu wrote:
> +static inline void ptdesc_set_kernel(struct ptdesc *ptdesc)
> +{
> +	struct folio *folio = ptdesc_folio(ptdesc);
> +
> +	folio_set_referenced(folio);
> +}

So this was the right way to do this at the time.  However, if you look
at commit 522abd92279a this should now be ...

 enum pt_flags {
 	PT_reserved = PG_reserved,
+	PT_kernel = PG_referenced,
 	/* High bits are used for zone/node/section */
 };
[...]

+static inline void ptdesc_set_kernel(struct ptdesc *ptdesc)
+{
+	set_bit(PT_kernel, &pt->pt_flags.f);
+}

(etc)

