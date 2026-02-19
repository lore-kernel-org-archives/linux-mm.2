Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA6BE9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF85B6B0089; Thu, 19 Feb 2026 10:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2546B008A; Thu, 19 Feb 2026 10:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99BC26B008C; Thu, 19 Feb 2026 10:01:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 878276B0089
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:01:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E2AA1C6A8
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:01:04 +0000 (UTC)
X-FDA: 84461518848.19.2D95CA2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2F07240017
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:00:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sZCLI2iw;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771513257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mP4ZC0TEh8C+GrS8QKMlO+6aITosKr4Nbnd175LCzeQ=;
	b=p15ETh9hyJ0zZKratiAfX9FzD91XVL5B59T0T+c5guY8zx7t9rDkxFtMyT9RK5Huzpu4If
	RetGUNpWlo/xMMu5V3vyMgAjjosMWxSEg7+2e3t/qbDHLYBtFtptIDZlw/Z13vM3FHdBoG
	NfAuF81MAfyhRZi0oJctRFTplw1DW5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771513257; a=rsa-sha256;
	cv=none;
	b=sj6Lxbi7jqvDRzY3+ypR8cD7JyWCNm6KGAXvQ67cGuIA2ZCYa+8VIH5hVtr28JTLHHK2wS
	15eHv5AGYF8dmX6eZI6PGvHfBjaBvo8wGte+QJ5SyDtXCY7TUYzgvpCf9awfmiL+uChQl6
	kb+1B3NukPiesepgeJlHU5fxQEaWr0g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sZCLI2iw;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mP4ZC0TEh8C+GrS8QKMlO+6aITosKr4Nbnd175LCzeQ=; b=sZCLI2iwwtDfv00ulHbwZN08JS
	TG+1RH2RthzkUqgNN3LdKJHRV3O9/7TFc3cpinGW4bWdeq7CYbRKtkueZoVdj+Up7Rs38+ep+1i+Z
	5hIeas+id064CMRlUo7sS6M36RAekYqpHKTzCZhGm7hNJBWOzbvMfV7uXHHpewouWOGE6pC2YEF1n
	JfdVeuc+Tc+On2OpMsWmvb6GiQpa07Q/Blyb2FrKdWGSW45CIaCKszXUX5wKIkXwvoBX3WrIVy7Tc
	QYGRXMmIa97PF2633C1GJfvVDb3SJaPZUSb67gYcj0N86jsPD/BkaK8MqgdkHJFobr7stM+99RX7T
	Gq97demg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vt5WL-00000007lC1-3YKs;
	Thu, 19 Feb 2026 15:00:49 +0000
Date: Thu, 19 Feb 2026 15:00:49 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>,
	lsf-pc <lsf-pc@lists.linux-foundation.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] Memory fragmentation with large block sizes
Message-ID: <aZclobp0vgE2YKRK@casper.infradead.org>
References: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
 <e2733d9f-823d-433b-9bfd-24df20b98b7d@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2733d9f-823d-433b-9bfd-24df20b98b7d@acm.org>
X-Rspam-User: 
X-Stat-Signature: f7g1fyk7bdpen5yasnmuix8m4r9s9kts
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2F07240017
X-HE-Tag: 1771513253-308943
X-HE-Meta: U2FsdGVkX1/G9T5mMRijOPaHzVBSv7I1npfwfcnNuvJVKapug9G/8pJsRYUMWuAUACFw/uW9REV8CNZgU7nLKzmVhR9L1QS0+ZcU3LmRKq0Afx9q2z4nvOw6wHIkm0s7qksVBPbYGmmsQ2wpDVS5kTCnzI7hnO2cvLX1JvYvvTlTYQ3wX0Ahc9M/hznmbzQhPuHvaidepEcmC9NL8S1kuV+3um2/zUFUMU/EZqhtQr6rtJDe9ruDCUvRP/VO3vTL0y2aNO/1R4TOKp4enW5OpUuoXV9Y//dl5fJHZ1uiqYmEu8ZuNaPGitgcITYmafZHepg/K953Fwp/q28lf6agixQdZIVKoYRK+u2utOnYG65oi2MkUOoDCjY51DiCVQz5mZH/0+c4pF6EpJy8zIN2UwbGVCe99LtWofHfh0NOxcwu6Zky9zykE7CRYEUzTjZrPffo16rr/UZZaU8Ieh9y7xV8BZ6tpn60hnmHYqwA0oE4kU32R/Fj8ZQzQk1TDpI81wI41mcJZhF7zV+VBE7jsiDajfv3P7MiFQHSt9HcIhmN++vRbO5LIM0+AezxDVSpL5u5cPEjEazEEBFX2D67VxaIhqol5LARTsmp86rBT7XPPihHbxGAp1LnFjXFt10/OiEv6W+TEmrKJX6HxSVDafInfWcNnAEBqGJlMIFPkis2lsoWeX0/1X2oZHuYnqO6Cm+sJftR1b3KZA2+xQrWSM+F/47eI03Uw5FLuPTFrVCGQgkhmlUwqIgtbO0tI/BqljEoKckOd561VzIDjCr/Il74avaA6rJx1iP6OfT4ZQfmaOcGF/5e9XR0rojEvWJ9vBKgD4/pVsN3AGAHvBu39eapT21CyIIEjXcuCqWKdUvNC1qhbF++87lDYsETisIP6JxAwvxYeKkaKzhmNdpd8mBz/g4bGvem3n+KO+f4ALFMZQgsK3iFHrc8ot4xb52DA8+t5VUky2YE4Ab8o0C
 kkM5hTwe
 IBj/FvP96zQ8C/cdwle5t7X12XM9ezMYgJZF24FJreTsmnLMHHPqE8L4Ll6BvZ5wJtMt3kytuthrF6ISAU557woeEXgMiD0NFleGFJ/9KwO5J1dG1Jt3srC8iHvHIHaodIZajDxbxWQoqOQiY+seVf26scZuBH4iRoMLarIGKUAO5khLJpDbrqxG9rBCdbWHwyIYYhInK2H3MbVCAPOxTq51iFnLUlJL+9BJX2Ro7FhTQsU20HEEni9NgM5ubv1oeUQPU58zsv/CYozGaNw3wzeneOOde6v1Ur4StiMx3vKqzcQCbMV7ahZViYHZuhw/qATrQRKp9yz52WFbw3Or4woINWlq2/36VWAZVIxuoD26fs/fwH8uGPQOh5NBM/kblpKNnWXrIfuL9S7LOFJjiT3Kw3u5Sq3cRdL4QjV4M8G9tTz7fT1jDfTrY3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 06:53:28AM -0800, Bart Van Assche wrote:
> Additionally, why is contiguous memory required for block sizes
> larger than the page size? Does this perhaps come from the VFS layer?
> If so, is this something that can be fixed?

No.

