Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE34C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F4F86B00EE; Mon,  3 Aug 2026 09:44:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC9C6B00EF; Mon,  3 Aug 2026 09:44:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3756B00F0; Mon,  3 Aug 2026 09:44:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2310A6B00EE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:44:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93A91A06EE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:44:32 +0000 (UTC)
X-FDA: 85060077984.22.4751EC0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id B037880010
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:44:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Hy3P94XF;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hFSLVl3vqMdmpwvvARJ3ktsvhZjh5uM2PCOjkzWMtqk=;
	b=hX3zDUl6IX84lvzROTto5K+C6y6J+o3IER3c4dxAZWe1XsOBUezn2xpsFW9qFnTHZ9OhtJ
	CXc+z8H0//60x5GaHR3JKTxowTlLkVQt1ngOEAxoOWDagc90O4xpZaqlLKEurMh7fT09vB
	0deDdeRpBoLB/vysfrxRThIDc0Q9qIY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764671;
	b=7h2guHjf30tQgvo22Ra2+PszRv6LVvnBMDtd+cNRy6iItgyp6dGB30mXL+jg4W4q/ziUxW
	w4q06Vn66cYGA/N3S1QNk1UUJNM8e3GbA8jjjJrrIYS1qu5cVACFnN51z6O/jhefNULdIC
	VMwsipfc39Xywf8Fqffh0LdIJdqx0ao=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Hy3P94XF;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E20CE1596;
	Mon,  3 Aug 2026 06:44:25 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 145D63FAF5;
	Mon,  3 Aug 2026 06:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764669; bh=FbJxtBRUzaq14tEYegaKum4NxMdFUr/7vbSSHB92jDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hy3P94XFDUXk6tU9GNq5CIL9vpL5JIYIqJxo5Dddl4Lyni2Z2dqfmtSz7120G69az
	 jYGFL76aKiodXvYN3OVrzPyfesEB+Um0xxKOQeANvgv19bpPIw6aRwaOOF9SzjT9kJ
	 ijB/52AFaeXBreAiDELLWQHFMElZ1lGk/T3KkQD4=
Date: Mon, 3 Aug 2026 14:44:22 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: kmemleak: default min_unref_scans to 2 for verbose
 auto-scan
Message-ID: <anCbNtFjv9B16gcG@arm.com>
References: <20260730-kmemleak_hardened-v1-1-b0b20033b4bb@debian.org>
 <anCagP6JDQG9w71j@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anCagP6JDQG9w71j@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B037880010
X-Stat-Signature: qhnudkxmj1rk4u1ysc7rfxoma63kjdor
X-HE-Tag: 1785764670-12013
X-HE-Meta: U2FsdGVkX1/KczEiuS40XaZRvSBDminQxC9r91yt+Uj2AS54Bf/m2dqf3HvFw6TUefYAqYxpFPiy/EPGMFtjV0eTwbksFZ+9cBExCdOuyY7E9xIIwfzg78N/Il7EfGVWhuQ+kD5Fy/kCbGYC0dbqro7nef4MOpv9MiQ4bzc8KYuW9W3CIYW4l3X7tmNHkW6ORxCxsmUiZkOoHNon+UNnlxBXal0MQ7t4px/AGiQRZ7lSE1jnO240/8Fj27CFvT+DCIgsnMqdXgTUzA5k7OEwKB1xdoa1RXKssFPFm9yqT8B9wPzqr5992SgIxL+YLjC7pEp4zZ5ST7hPmIatx1G8a2KKLs/pVCivjwe1bytHy8VzIkzS6mVFnSDOaHac8ngqloPQzIg3p/vI1cUsloOfkh3ZE6R7yyi008u5XTeHUmnRigIELNiLezQPWovrFlLRoNoyp0xDXdm/1Mi1bOsohxt54CoKBU8pUWiK3tVCwU54H4INyS27qMUcq7lP5X6vqDdyAGbV+TjPI31A7XYF4wXbRK4Ar2b0b6ktCSobVWae/Ib8pl9zsOAzwcnZ8PXr11zQK838EKIzNhj279iYYkpQ8xr/S8pNxHvyCGEkBd7x2J9sWA/wwJwpWty8uFvWovrhbYV8iER+xcRZopBiqGFeSKTKSgMJgT//7nkeYUUuLQkTA42IKHIAUtyh0grO5gcDwaLpZJx2oe/qrQzhhtxJ2z8qopUBWmACKDUn9C4fL8UYCGEQuwFwyf6p57cehSYmBfepXRKh9q3clfL3jGNpAmeL4RUxBwhiTcCmIZRg6PaKevME/Q0vhcvfqD41ABhqqb+XDeOwoE+0X34NKW3KJQCKOLF2tvNS3xL1x44R7BnVQaMB+3h16HEnnAdzViL1zFF5lPvBN5ioBPaaF/e12kD+QtT90EIAOQUiuy1i/b+qE9FV7xcVV6kWNvDXjLL+AFJeRgvdIHyW7T+
 I+mKWA35
 3p1nhrJZ53IfFXbeEII31KZKIl4yapMypEWAlpmi90KVT79VODhu3z8ia4ds0yj3A1/g26EWiu42WIb1p2+kDLIvAvM5zlzfZRCjnbKWOSRf+YXO7jzOrZ5JKwG26V4gMXG2Fgg9mY5+ZNXwRsWj2E2cvP/ZuXQLr+cdCvBWeuYGdTY8Ru5JnIL6TA+zVedmSOBUcxwp40Fly8lAFl1CBqsXFuwfCs1sBvsIRcH9IiUPJ+C/amIPnBT/RCs5qWb7gcQhlnFgu8utCk7hY00KWloWxoxzprNHXQyXhXNPblTZwfGydAIq39eYDQvPjGKd+GX5JkFexsvSR0i6rIwnZKwe0qjrNR/Vnr5zIw6ewQXBuhOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 02:41:20PM +0100, Catalin Marinas wrote:
> On Thu, Jul 30, 2026 at 07:31:21AM -0700, Breno Leitao wrote:
> > min_unref_scans defers reporting an object as leaked until it has stayed
> > unreferenced for that many consecutive scans, filtering out objects that
> > are only transiently unreferenced during a scan.
> > 
> > It defaults to 1, which reports on the first unreferenced scan.
> > 
> > When CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN and CONFIG_DEBUG_KMEMLEAK_VERBOSE are
> > both enabled, the scan thread runs periodically and the user has opted into
> > detailed leak reporting, so a second confirming scan happens on its own.
> > 
> > Default min_unref_scans to 2 in that configuration to suppress transient
> > false positives.
> > 
> > Keep the default at 1 otherwise, where a manually triggered scan is
> > expected to report immediately. The value stays writable through the module
> > parameter.
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

Ah, I noticed there's a v2. Ignore this one.

-- 
Catalin

