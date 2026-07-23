Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4882BC531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 22:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE056B008A; Thu, 23 Jul 2026 18:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267EA6B008C; Thu, 23 Jul 2026 18:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12FD06B0092; Thu, 23 Jul 2026 18:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF9C96B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:21:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D6ACA021E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:21:10 +0000 (UTC)
X-FDA: 85021463100.07.5C49C40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id CB465100003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:21:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6oI+1Wv;
	spf=pass (imf14.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784845268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=jt33XZg6IakrXoUrAEnJIibUYgZUlDskKhuW4fOU1xM=;
	b=LkCN0t1M+EYJmToonCgAU4Lqm8Aypwz/Vi3ZXDRfZskE4C9lDhh3HzPIskZ2WWx7KsGKs7
	gGOrY4Sjy9kuqX+QBlsTGU5yldT99mUvNqE0B/mMIAXZRBV56OIl+fWusn9ZWBNKvXQ0BJ
	oF4fb2uKI2Mivo6j0qKB89gN0jQcYd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784845268;
	b=w9dr7sAxfH88aK6e8mQtdGyPbfrADJwy9bKh8ToO4WVqg7loTxFFdHjoYgtYyjkLNkT/FY
	ZdawTskZl+NqR4ERIYzLKUTr7n6qu2eBSOotRhT6Ky79NW/hs+tbgHOKNT7QZW11kt9AnI
	zgtVf26y929vYkW1641lLvM81D4kMoI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I6oI+1Wv;
	spf=pass (imf14.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A50043C2D;
	Thu, 23 Jul 2026 22:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CD81F000E9;
	Thu, 23 Jul 2026 22:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784845267;
	bh=jt33XZg6IakrXoUrAEnJIibUYgZUlDskKhuW4fOU1xM=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=I6oI+1WvIphSqo2SuYZlr+Z760iGzSCqCOqo1O52QXp0AQt4DpnWOjisJa4Dl9+HO
	 JERVpACfEtCncGeO3ANxpi2GaBQ94g9U/b+m2LChVg+v8C7Jj96R4FEHQemOqnV1df
	 gF8XJ3qDVMf4/f1lRpAYBfHrtjAtaYNxjerhzzJQ9O35DZ+nmDJ7bEIxwhEUUJN7Ye
	 Tt6/NS51u9fLd+CCzUdwtSjR+JsoOWluKNMUvl38CPvbY5NrDPcKPsKklnoXAfp0Hc
	 LJ8hgorhXMMGA5x79fdAR7IgtS9Ri1F8IjDr++NQof3NE313yZRqh3C/6dYKWCte5P
	 +i2kBcAGvHzwA==
Date: Thu, 23 Jul 2026 17:21:06 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <20260723222106.GA867236@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710212616.1351130-2-dmatlack@google.com>
X-Stat-Signature: uk39uq4xw7kjg5wwwm8j66d3h54idm13
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB465100003
X-HE-Tag: 1784845268-887776
X-HE-Meta: U2FsdGVkX1+DCIE97LziWoKHZttUShsfP1Gs18AmucLzk7c8HpzBdnrLlgupZpMChOmoLPpk56pNlz6GUMebR1dbY9Ni9fogmiNxkSTc7EYVhvoj2sIO6eeRT3ZTeEsMCFRPfdMIlE7YwO91Ls61hU6tboi3UYpQstB7mQahsukvE5PBEt+GKkES3S1n6QORp1jvL1CP+Nytlu3ci7k9ggLZWZ7WBisxSda2UU8GN4STGaV6iltJC8rccePQwax2VxQOTsJtgZbf/H1uXV55rtKtu6QbD/vIwtJ8QRq+U4z2F1dsl/y/UeUwCMzojjqOTPuZEC0Ya8EyGWiLyH59+7B/+E+75ANaoONLcf4jBt5DQ9xRBmgfBqeePLkY6U4gnDFQZRuXqdVwLc3SMlaNBJs4ZcXo738noxsSk1ed5lQhQIBBumkTFDTi3WyMhYOYg8d49jvqz+NgfHCCG4qXwyhQEzHj73/wtjajCfCEHEwk4wMSxlCm9XHGu7JhE09jX0RCY1MS80fTX5n+gMPxHdmmRY/PDWZ4tcAcTalCzSMQoqo37XSc7B3s2JxYjtOHLQn5UPcefwLaOkWZ1dV0Be0zK8lyvgLkl05Bx9zT6JZZ+2Oqj960rjQ7EacPOtrmtgFf8RE2n+6x98qOeqaXDmjEAvkxPp/aLWzwtqt72ouhHfoZv+MVtJ/YAiwxKNlu5k6vygSrblBUjfkr7UgSUZeG0U1WJa8lPJvy3HQV9CBtOoV/oG19xKI4E4BHJhm5DbUQm8GY5oyHBsfJBWX+mj63DjOgE8fvUQe0SQZoq1Fx5589tiTQfCoQ4oXgzLaXS8ZFhQUPTZPZww3SDo+sN8eeyiVBByQOhM70TYWiul4gIXU+nP4ubFAEdGTpX0HjjpWp913tXzpDXox9Wc+nzmQArxXV4N1XTTDbnVJfncrGszXu2hcoQHPUIH3LPkzc3TeYUtvDq/WRhRQPYyS
 eqU+q7Wv
 Fvbq8+s+glQWEXwLF+937XQHydMC97M3X8an2qo7BkUn53sdWnuVu2j53vx0AIqVI9KLhvU6j1DoWQM/KSfAnlAx3SolDZk+gZ/PTHQd+EvkXhxAYAk6MFfy+B4H6WtwJbngr8X4+qW0O2WiI9MED2KS1yqe6lQUniNKKermkLUGsDsWO4zoqFPRuqkx+wiUj9wvDNKUuNdifZDPfGziN+AQJFSb9RjixWLWByxBWMuebVf0ccInYDppFmW+ngOW0QR0x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 09:26:04PM +0000, David Matlack wrote:
> Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
> it to participate in the preservation of PCI devices across Live Update.
> Essentially, this commit enables the PCI core to allocate a struct
> (struct pci_ser) and preserve it across a Live Update whenever at least
> one device is preserved.
> ...

> +#define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt

Is KBUILD_BASENAME buying us something important here?  Just from
code-reading perspective, it's more work because without some digging
I don't know what it will end up looking like in a dmesg log.

> +static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
> +{
> +	struct pci_flb_outgoing *outgoing = args->obj;
> +
> +	WARN_ON(outgoing->ser->nr_devices);
> +	kho_block_set_destroy(&outgoing->block_set);
> +	kho_unpreserve_free(outgoing->ser);
> +	kfree(outgoing);
> +	pr_debug("Unpreserved struct pci_ser\n");

If this pr_debug() is useful, maybe it should include an address and
there should be a corresponding pr_debug() on the preserve side so we
could find things in a crashdump?

> +int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
> +{
> +	pr_debug("Registering file handler \"%s\"\n", fh->compatible);

Is fh->compatible enough to identify a driver?

