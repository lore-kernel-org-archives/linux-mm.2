Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDA8BCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 19:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD73E6B0005; Thu, 11 Jun 2026 15:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D882D6B0088; Thu, 11 Jun 2026 15:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E1C6B008C; Thu, 11 Jun 2026 15:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD5B46B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:16:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66BCCA06EC
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:16:04 +0000 (UTC)
X-FDA: 84868587048.20.5EB26C5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id E4DC640012
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:16:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DjhVC2O3;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781205362;
	b=henFX4KZOhd9MHOIOgw/qucJIhfrO1NHH1AWNXgiHtUFCJ+K904yWSBCZvlBKRFPIPtQi/
	WtKHdRUTTMJAFv3aA6+qUokr6e9ZAPzTO8Q3ghsMr4GenaPaI0MMAXTaa+FpNDamXXU4+e
	UukOE+udr4GgfqKxfxigLptg+EEnTCE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DjhVC2O3;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781205362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZd4WLjqq4XvQwHB47ThdrCyV6Re/i6LgV+u2yu9EGA=;
	b=NC0OSnS3PRNyRqtKCe8dD1PBsHKElS3eNugbhGN52ZciPr8xdjPMKG1JCiqkdWDyt/R1WZ
	R1LwIPF+Yp6VFeXud74FViMOGf4EJl8mcir7b7axgkJxFWSLNVLru0YY4royJ6n1lbdCsw
	xJPARwdQ1lJQZ9Q2w+p6Hnh+HdmEsZM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rZd4WLjqq4XvQwHB47ThdrCyV6Re/i6LgV+u2yu9EGA=; b=DjhVC2O3x2oTgn/xwo1dHD8O76
	yREnZrPW3PKdThR4vYr/3TZle42hkbSQDwk507HmsgtNWQbHG+SmAMQogfrUq6FQK6NPe3Bg28K/k
	5nfCDnlYa8uHKllJ7gswJjxhDCyy8avOiX83lqv2wbvaZZaTlWFyN0fd6QhRMmMjSwYAO4notbPs9
	L1tr9+hkWAeGKwJc8EPFH5IhO40P3igMiFM/FqFfsZG4460RJwLFjRqZ8qpCjmT3pgMe0jd6fD9+Q
	lhO6cvnWgF0E5PXRr+0w4C4jxu72ApfALVtT/+ldjp0n/H1XtVw93sD/VwRFZAgonMnjMvYDaGa4v
	80OhGT7w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXksf-00000002S6h-3zk7;
	Thu, 11 Jun 2026 19:15:57 +0000
Date: Thu, 11 Jun 2026 20:15:57 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [RFC V2 0/3] lib/vsprintf: Add support for pgtable entries
Message-ID: <aisJbeVVxxNuYxQ6@casper.infradead.org>
References: <20260610043545.3725735-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610043545.3725735-1-anshuman.khandual@arm.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4DC640012
X-Rspam-User: 
X-Stat-Signature: nusrsfj4hbmwcsifsmm476zzeg44fdmo
X-HE-Tag: 1781205361-209864
X-HE-Meta: U2FsdGVkX1/jAK+W14rtQyHFJkmJ424zE18nnKSg0CdjUKte+wWglVbDue9bmFk/XTnYSOS5aUlw6dLYEKdQrApO9OqnNWP3HFiQ9YY+6iyc7P3vI0jr4ZhzKsshlA2qUNbpymRm7daPpeCn0Pdd2TKjgJqtUsdoHxl4JCAHmz9LwvYqfcVcEb2gJWxaAgk0yZZzxpHGB4IMK1b9e1xyhulWyEigfnLDIvtZ271TGZy50OanvqpefDOhji4mK6BEZ+pGe/IQEBYUwz9W11W3nOSOtek+jvOWKbc0PZ3cWSAVXtNK1xPu4O90nVEcxxTCyzWiZb27XHeZIv9U4KrwxDkmLCRIBeEDq8Z6MTm2ZUEbQw6OoDxKF30W2bPKClzLybwD8f/WGop0m+5St9lGB8kmDjQ3eP+dvIB5GW6RCd+DuosG8L/SN8YaKvCeFOmuwr2fa2aWLmnqh3Wq4G/mnHZPIneZRbR2UO7UYtLb2gGHWYSE3U0JA4LXQSPD2mSFogZVgIynxcFHfAHnOTT1+aCZycmgU3uNaPd9TjhVIGZ/pbTeeXBOihDk5EZUVEqBBoKssUbut3r5xfSGckc4Onn23NYYiqT8UnZRkAbzgYMWYy/TfwPlgC/hz3rOLnYEnqRhu7c15uuPuhUGTR6sfVjFGGMBm1MxNBEdgX0ZbyfTKoIokSWcck0oAralWQmV9+5y+rPPIjnJg9rdAvce1ON0946K324j+Do6BEf1zJY3ZcMWW2v+aNpJQKnS9gz9azzoQhGMAMkMUJpi1KCHtmYJggYVtlUKdCxmaCF/tK5D89djlkKgCT1ptyUcxESZUnoe9W+iK4fuTzmzQh+RPHLRqMcie9VNOy50FsG9R7qJ8ohFg5Gc25OGflGx3oJWTOxS8rnW5jJEFGj4sTC+MvflmtPlQrSSMomeif/AToHNeXSA/eQ4adWQTh9R1uNpJ+P3rFRo90T09aeDusy
 JKRCJ69/
 WpccR5WcyXcqINSy9jGo4qkwbedQFQPUtbtHD85P7emyEZ83trh3+Ng3qb3hlgdjwZJ2+QhDvFSAE96qXXn8m42u8yCnAsVklu1vDcswuT1x+vMxLldHvLBJXGmVKmaHxYQmuH5mGyPvB3VR4ojd7rPL7U4PwIR1kDa+WNHknohqCGbCHJUBZJ/JIqsSAipJ0BIQlusEdMZ3nL7W1N6N1Q0RkJkKbv2UU47lytOO3c+uInclVNLAAqq0GLs5b+m2zjJlcVHPgi9Ll1aCTibY0GOVTb6QyoO6XwyaIwbSIu87W72Z2vsJO3TyG7/iksr4KcOSlB8ZGloTPVHUy8W/NXPmgUkCiNZkd/UGpwuz3WBcOtME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:35:42AM +0100, Anshuman Khandual wrote:
> Printing page table entries has been a common requirement both in generic
> and platform memory management for various purposes. Hence let's create a
> dedicated printk format for such entries which will also help standardize
> pgtable printing across different platforms.

You didn't address my objection here:

https://lore.kernel.org/linux-mm/aFQP8LzVMctf6XH5@casper.infradead.org/

ie there is now no typechecking possible.  So you've made it more
dangerous.  I reiterate my NACK to the concept, not to the implementation.

