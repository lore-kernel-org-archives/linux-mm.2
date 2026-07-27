Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B98BC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 07:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32A0A6B007B; Mon, 27 Jul 2026 03:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B40E6B0088; Mon, 27 Jul 2026 03:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C006B008A; Mon, 27 Jul 2026 03:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF3166B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:35:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 512CA140663
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:35:52 +0000 (UTC)
X-FDA: 85033747344.02.8506EF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7BEE0A0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:35:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJZ0SJaw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785137750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXAaHU+bO6CqmNP8GeiPSG4IKFMie3KJhHcvrJtgBf8=;
	b=5Cra/AKs0gqMG3LuQ+hKsxneeD7aSusDUPTvN8BqwF3KaKvyPnVPiwcSyfekSOBiwbKtVL
	x67GgzlF1taWx74eVbGJo1tPSlclk5EZTC452Ck3q98+vOtuWrkhsfRmtFYTDIOzfWgOOD
	rUIDVErzOkgKBTYodQqh9jaH2aspXAE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XJZ0SJaw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785137750;
	b=Mri8HbFpwN9cRkFx2VlUF7aFqXcrpmAv/HYdfDMgCjXU80H8riCfs8PVAFAmHFaKxIit24
	wbjpKmh8yda9mwxeVEoPh77y5GL8GbmF4CAenu7CLeSHpLKLxcHvg/IY4KKBaUEPa0lXs5
	eVWZc4qcJAZ9MOvRQDoyOhdRxgyCSzA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6084640B68;
	Mon, 27 Jul 2026 07:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542191F000E9;
	Mon, 27 Jul 2026 07:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785137749;
	bh=nXAaHU+bO6CqmNP8GeiPSG4IKFMie3KJhHcvrJtgBf8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=XJZ0SJawpx7JWMu6jmEZyrR6huQ8VXg+Gaf4eQiG6O6mjvZG1+GoTJp2vzvcd8c7L
	 IO/dD+BEnswYisCreq+7xCU3q4F+QUK3WFao5q19Zl83WOGpMPuPUQpg79ICgW8Oyf
	 PPg+7FMUKocG51WRn8PJbHn0EpF+pvdYNV7WcQvbkJQA/3xWs0rGAt2DPsalEXHMMk
	 PhIHFnTQo4lNlEafTWj8SBuRGZp0eWhYolBHK3LZdg9eeIAFikGr6YBBLYloU1DJK0
	 ZvKOD066ZHxQ+mUEX2sJ5SeSb0VAG7sCQx8z3VHjZPaGdCY/YLdmGxDlUVi8Rsyy1K
	 mZOtpObISlPvQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 03/24] binfmt_misc: reject a flag character as the
 field delimiter
From: Christian Brauner <brauner@kernel.org>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com, stable@vger.kernel.org
In-Reply-To: <amTXwUK2FXu2sHI2@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-3-a162f7cb58d6@kernel.org>
 <amTXwUK2FXu2sHI2@lt-jori.localdomain>
Date: Mon, 27 Jul 2026 09:35:45 +0200
Message-Id: <20260727-lauthals-peitschen-aufopfern-1bfd12376820@brauner>
X-Mailer: b4 0.16-dev-09492
X-Developer-Signature: v=1; a=openpgp-sha256; l=2346; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/imp7y+7vcd/kYaRoEG5SbixDtIxcsGnlRjvU2AD95Q=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSlcwXd5Y31n7zpd/dXhb1Xzml89quJ+iNfHhb0XSVbL
 dr8xZTijlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlEb2D4p5W/Zs00pXf3Y2ds
 fN7veVSRTWgO284/Ey//OqSZVpRpJszw3+/LobkLTh5e7vieJ16fpft1EUtqqMhKwaWLFKzfnHu
 8nwMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7BEE0A0009
X-Rspam-User: 
X-Stat-Signature: eozkr38netp45abcw33oi7sdbdyt68xs
X-HE-Tag: 1785137750-717195
X-HE-Meta: U2FsdGVkX18CiLzDWVJl1g9e5yl+VPvbpAkvs/5CCs9EUdKsUvJzXUYlg1WyHUcMDJeUssbZYVisqm7r0AQ3Sw7GENTx2Nn4QJXHd0eBu3IN3abYb9f+5ym5rPLkuWg38UZk9EhLB7Rnvxo9k2/QUxAx1QcwnxqH247X+7ETxpVTAIvfZyYzfMofhKLW0P32VgKHyZjFIoejWaujfCAA18tUD3Ej3NsBGHekaQsO3iQXyHOus/6j0vGzBxWmBp6M1Svb+TY4fpQwrU2AAlTxsWFGQWNBMDCTj7/2ZK4y3vQA2xVSjA/q1RkEI7GQ4HCWUBZAR6qO6NHCbne0y+Jr/YnLjKgv0TYxUoQP81Zy5mAvgSvyteEwTRowTZ+lQD4kgchZq8CyPLcH8gO6tCF1HgfHhsKZ3V8SU/32YOCeuGYMPQfCoWjPAAwpHGdHKDJ8WA1wPOfvK6VRgmJLo7hXGNlL9/5Df0N8zlVEjAIYMGKVXqdKGQp1g815V7msm0MIv30HnR8uaqll9IOPOtBtBt9V0SIjVn7dxbfGjP3v7fL7qEMnBQ0KMjOy0Dc1D3Mbk+YEHmrODAgqktir0T7XK0ovLd9FXMy8/aE+sGh4PhfHAEYExXoIz+aC5nP5S6nxpfOYL0vY1ISq47Vcvzr6HQlf/NEgvul0shzQX90MWzjYhTXewf6cUldUYYUArDU+odETigYAqvpHd5BO8M9xRY/2zYsq8aDsGYyuauYGKRsNHlS2wxRHB0W6Bu1tQqDOZKzcUtgfJseV2fdGuGk3EnEZ4YbA8h9qHxoln8+IrAw4qf9/CpUgT19dX2s1EFMO5wdcfKSMgdgix/ojdXujTaP+sH3f2QxHejf2e76h0OQAmS60mw2nFnvvc19tluaDVve3qmdTQw374MB3LGgHffbwn+kowWJKT3mXqAFvuR6qpWAAFKBPHKbOOHnPaFT6ZivXdAU9KQrECkjy7b+
 O2SLiwxW
 lmuSz64Gckz+xD2A5FgsLENhhip6I0rds9cKM/2x4uDFHF6uh5+6ZnpBOnC69XZ4mITmmyBRLdfUrMKo4Hc/wiMmtu+9QAHyB2va4DBQfePf9FMIfsSyYhO5kd7IQrNSdg0yvudZib2Ll96/BXG1gDVHiKzZgIDXgLbFxaxS3LWcyxY0fnK0e1FDK5/p8saaad5laZilRgZBWCeMCPQYIWc0rdiZaFNWbUof6R9yvmacKgw7VhnqlAGpkcEZ9f8ZGjTK7x/9OxtpKsPWH156mXOUHA/jn05YhPXSwu1yJ+67v0dieCuD3v8JRmpGrQLGVCvAD5ONId6HyuDnND1KolmbY9J3+OxdZ4p17K9ZSoQBwvj+/erfAJoklL5IjFeYnYpYmzdsc0qtm63E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-25 17:37 +0200, Jori Koolstra wrote:
> On Fri, Jul 10, 2026 at 11:33:04AM +0200, Christian Brauner wrote:
> > The registration string starts with a user chosen delimiter that
> > separates the individual fields. So that the field parsers terminate
> > even on a truncated string create_entry() pads the buffer with that
> > same delimiter:
> > 
> > 	memset(buf + count, del, 8);
> > 
> > Most fields are scanned for the delimiter with strchr()/scanarg() and
> > happily stop on the padding. The flags field is different: instead of
> > scanning for the delimiter check_special_flags() consumes the flag
> > characters 'P', 'O', 'C' and 'F' and stops at the first byte that is
> > none of them, relying on the trailing delimiter to end the scan.
> > 
> > If the delimiter is itself a flag character the padding no longer acts
> > as a terminator. The scan swallows all eight padding bytes and keeps
> > reading past the end of the allocation until it hits a byte that is
> > not a flag character. For example registering
> > 
> > 	PaPEPPxPPiP
> > 
> > with 'P' as the delimiter (name "a", type extension, magic "x",
> > interpreter "i", empty flags) leaves the flag scan running off the end
> > of the buffer. The registration is rejected in the end because the
> > parser does not stop exactly at buf + count, but only after the out of
> > bounds read has already happened. With an unlucky allocation layout the
> > scan can walk into an unmapped page; under KASAN it is reported as a
> > slab out of bounds read. binfmt_misc mounts are available to
> > unprivileged users in a user namespace so the read is reachable without
> > privileges.
> > 
> > Reject a delimiter that is one of the flag characters up front. Such a
> > registration was always rejected anyway, only after the out of bounds
> > read, so no valid registration string changes meaning.
> 
> 
> Looks good, I see no user visible changes.
> 
> Can't we support a less arcane and impenetrable format, like JSON
> or YAML?

Adding a json parser into the kernel is something I had played with but
that has a bunch of very subtle pitfalls as the spec is underspecified
in various ways. Also, having the kernel produce json is one thing.
Having it _consume_ json is a whole other discussion. Ideally it would
be done in Rust.


