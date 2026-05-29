Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB03ACD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 01:26:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A6B6B0005; Thu, 28 May 2026 21:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9ED6B0088; Thu, 28 May 2026 21:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF1E6B008A; Thu, 28 May 2026 21:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7686B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:26:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 245661C26E2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:26:22 +0000 (UTC)
X-FDA: 84818717004.16.5A8C9A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 73634C000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:26:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZ0PZeR7;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780017980; a=rsa-sha256;
	cv=none;
	b=l0YtX+TlPUnZJGBAusoztsnF8Zh5TB4Y2h3dVd+jtgQAc0hInppr1KmMoKZYiVPgDYvWRN
	5GTw2wdblDXQxs0ByR527rbzAcpewakI1xFL2xT8Gxnk/2y/EQbfvnr5OjAKSNZL00NFdR
	v/+PWXoPUGaTQ/hkLDc5pUOfWUvkM1c=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZ0PZeR7;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780017980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fR0iSISNGo6Jq+jXpakAdJqfeIknPVsI985rMOxNdrQ=;
	b=fdl+M9SjGML7csw9ynz58WqNddzbjjg544akG09A+vcm3R71Vf4QrNi8RQIYUABl+Iqd6k
	RYp1C80uKrSl2a9nQU4HYkFDReLHY57KTA9/FMPAPjnZV6/oLbtSHi7PaUnH3xQxKgmxCl
	DY2qgIGR/VeR2aYBwSbl7f01pvZQGfI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E40044372;
	Fri, 29 May 2026 01:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5251F000E9;
	Fri, 29 May 2026 01:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780017979;
	bh=fR0iSISNGo6Jq+jXpakAdJqfeIknPVsI985rMOxNdrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZ0PZeR7SKEeZ/tojrXVox8QY/4rtENkXOgA/QmpJelh6VpsDLNqbebR2dlWN9zN1
	 F65D8A1aGY7VXoSvdM9itDvb0LGJX36+hWHNFxlBrTJ3FQUW/FqCCLvGgEK5oDG96l
	 YcFVZOqCrqpgnJ3+fQcQy/rgvmTpW5Y4XEnvOBAjRKQkG36tjrfe3NTiI+AmS+cXcV
	 4GK16qOaE1UGwMx7gB/VPqMrcZMRkat5+CzyYG2C7El37ch32yM7oGRoRZ1HLcUmZ0
	 pQTZ90Fat8EqBfd4dU9Q5OlKDRWsUDs7mfFRKfhEaWHF6OQfBpDc72d+w6XEhmVavv
	 FFEk+Eb/H9zaw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Brian Masney <bmasney@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add vm.rst to memory management core
Date: Thu, 28 May 2026 18:26:10 -0700
Message-ID: <20260529012611.8578-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260529002525.7939-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 73634C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: yzm7nkeddzqru3qggk4td38p95f3z3ka
X-HE-Tag: 1780017980-180604
X-HE-Meta: U2FsdGVkX1/m1u4ZdTmhvlPU+nbGYKMP2Ias6Gc10b7/5a/fjCuRtZems2K0HPGEpdPSb7uiR36NlrJP7O93Qj0VOBxWqjcefYCOPbiu+2APz7DkdlwqdBxq6VHGmjlL/ctp0zfH0+dihgMpVt3OJujgfguFxvs0VvfbsyJHALpTxO/EJzIHElPl84lKxC6z3Rr1cmxSSjP3PVS2WwUzXsOpeSd2D3NsB0aj0xqQLTNoIzkku+NLndAV9ayY5CP/R8/y9GMKKteam9+eIBPgjm8neH9UuIreeSZ4Hyt0uaf1NKFct7ddq/m1o5dpRdKUEGKmNYfAops6ZdGPUMRLdhjegZq7ezG28K3SYHy5Qw7aZ+45MkgStlv9M2up+l3vNS0mREEVj8GhgQ2CbaztHFw/4wWlFJVIo3Mza3xPxgg6Dc4Eas0iPlpLZ/h1TqBEABBk/x+QsByNAN6f/5wCtTyHPiUKEkVu8XeM93WSyBwSWNRleniROU1msUNvlSO9IcUR3Sd3k6tAFycyPMTQEX7tWWyQrnsBkHxtUY8gVL3hJZBW5JweYuWpx+Skpm5Oc0neLGgiUHNAC/lZTQJJEUENnSn1iNIvcpCDSJdUXopDOdgbhryX2EknzXbNoKLQsL9ZyWZKIoC9uNrgRQsLKzcYS2nr8sJcJ6sujxRHlUOiR7asmLHPyCqEbhp+1YwXcwWfuIOiCYXWsppHL3H0OHOqQXvmVF8kJ5XnlSE6oK04Jip7E3EcHn7vldMuo1YvMdC+ut1oMNO+hpgbTvJOr6fV6W5VnRqZrD1iuWldwEC8AAfY879MwcKbc/nzSf9Rkj2aOB4Ty1/wZpc9SyLlnGhcK5l2gH4iun8C8uqHmRQy7UZp8XWqNOEa3hG0kFxM3MegjGsgcRoECSHNC++Wl3JeoqwjV4+Dz6XHIQdD1Ztge07cmkceD0DJjsrRnoVPBP7mdBkUuEzH7rPjiYG
 EDUAUjBx
 2jS+WFtAV8XZqI14nNLU1PrOnCmJqq/VpaX6mj6bgqcM0Lwmx2D9gQFNascTcRQyA+9yrPINF6AiFHbiXF7/0+XdE9TA0nSYKrT+xbhKbNMQsgh90ApLmSxoGU+6DC4jNy3vYUpnQmqN/hFUt25UhDFASZm8q3etNUNrJ0sSrMDGNHXMjSRnYgagzPH0wF1WRFSRYdofQe02GVwdMuIQiLpayBCy06vVWlnsN6B8KGWvdqUyX1HrtGm5U6LbOl2L8WALa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 17:25:24 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 28 May 2026 09:56:14 -0400 Brian Masney <bmasney@redhat.com> wrote:
> 
> > The vm.rst file is currently not listed in the MAINTAINERS file, so
> > let's go ahead and add to the MM core subsystem so that the maintainers
> > are CCed when changes to the documentation are proposed.
> 
> Makes sense to me.
> 
> Probably out of the scope of this patch, but would it make sense to also rename
> it to mm.rst, like we replaced many 'vm' parts of file names to 'mm', e.g.,
> commit ee65728e103b ("docs: rename Documentation/vm to Documentation/mm") in
> future?

Reading above again, I think I wrote it in a confusing way, sorry.

I mean, it is "definitely" out of the scope of this patch.  I'm not asking
Brian to do such renaming.  I'm just loudly wondering if such renaming is
somewhat worthy to do in future.


Thanks,
SJ

[...]

