Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD449C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 03:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6398F6B008A; Wed, 16 Sep 2026 23:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9B46B008C; Wed, 16 Sep 2026 23:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FFD96B0092; Wed, 16 Sep 2026 23:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 200D76B008A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:56:09 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73EF3160208
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:56:08 +0000 (UTC)
X-FDA: 85221891216.06.B9DBE70
Received: from mta0.migadu.com (out-226.mta0.migadu.com [91.218.175.226])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5A8F5180003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:56:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=riX5qEG3;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.226 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/xabJg4Ol2iNJDHCG0tJc4XliVb1hnab3wbN0yyc5w=;
	b=YeCQ6Z7Ucwnb0ClGT6EP1GfJIMTdizy3IX105YWAhXjOWrhaVX3FCWj4RbeFOmjXsKbeb2
	7DcJkW9TFXch7PCkRQAmVG9ofkm/I2+Ydurp0+LD8ZcBLrJBZJ/reh6mcm0FVDBHSnxdXL
	xvvyv9QJe1fv+QkWUJFxoS0NXxNtN64=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=riX5qEG3;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.226 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617366;
	b=sKag7RzsbKL2ImED02nDCnEJ2x0nD9jZYhGpZiZOqpoO9fJII8rPMWPpfd3Kw8FK14Nmp1
	IAmBwtmoATy6/prHvSb9oNKyrOkRaxREsMrpKkfNKuxfuIXo7IgOPlZFwQATqOk2iM2ITw
	8dPne74aCJ97KsS9JZ3GesiFweLSAfk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HUl8bRaU0gbRRqk2r/mBcfDPY8VXOzcdedIQhAftkok=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789617364; v=1; x=1790222164;
 b=riX5qEG3NAfL/qYOy2XvUhmnk0yL9gBz+Z+3bjqu5Rqfl43d2rrXgKhM7zol0bYkNTkYJ0fY
 Fi2BaEg+DnvrpX5g2/2Ijj9R4jL2e0VOMDaajzb198DyXFvFq/GB9wRFy1OcMl6Qz8sQwYnV55o
 jjjUPDgHlNWc34FKJL2cKb6I=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 2f3142f7717fb54d;
	Thu, 17 Sep 2026 03:56:04 +0000
X-Mizu-Trace-ID: 2f3142f7717fb54d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] mm: filemap: move lruvec accounting outside the xarray
 lock
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260916125122.2696271-1-usama.arif@linux.dev>
Date: Thu, 17 Sep 2026 11:55:47 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 jack@suse.cz,
 linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 willy@infradead.org,
 david@kernel.org,
 hannes@cmpxchg.org,
 mhocko@kernel.org,
 roman.gushchin@linux.dev,
 riel@surriel.com,
 shakeel.butt@linux.dev,
 kernel-team@meta.com
Content-Transfer-Encoding: 7bit
Message-Id: <E7CB9AC2-059E-447E-B248-DC383D346457@linux.dev>
References: <20260916125122.2696271-1-usama.arif@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A8F5180003
X-Stat-Signature: hx1xcjbbx6yi58pka7pisxb7uthh7trh
X-Rspam-User: 
X-HE-Tag: 1789617366-220717
X-HE-Meta: U2FsdGVkX1920cJPNEzlMgNh45m4S1ooue5/4GCwAWEe0RQTzZUkOLiEgBo6VANlgHNVBYB3l/KstHPunEivlc0IWDYLrHqCL+uO+Ic1MAZTTnJONUkc+1UoW6qScIwJWgPEM8Q+4MxBTovgQ69GHzaYj7Frw6hdjAaBoJe+Y5GWRnAaaffSj3mAZyHFA/Wo3hckv9mDTLBN54k9PpsMkynLds8B0k8R703Zgo2HzbBTkaDOlNQp6tuZjUWS2D/gOAUMkevtWmIOuMnVCYAKiJd7shJCctglVALnv1/mFklRNvsqDalvzBbsb/xd1QQTnb5u1ALidxiyTtBy6lD2NCg/RhXGPNKcyWOsIDBH1ZBhVRDVBV6fOfLpD/yqkyLXwQkORbAkt0CGm/uw81noLF9Oarm+oCwIQDGcyEUfEWAMuAJKFO+b4xbPtGhqX+Cf+0rCB5ZC68kO5mq5kjsTkmMgwBwsKGR5jQTVfBdWQHoVrV8/ae5nqyCd/G4cCdgtLUDyWbHhls0Y5ViQht0x+dpPanojdDgYe2UVkAY8RZqI21fx1jlOrDkUC0UaTnBzcP4t+hjkW5rO3QCE3qydOAraV/aJrX1uV1wErUVkkhEwyM5aUrRVfKMXt1hcyJrA5ZtHM6c8W30jSLhBFHGXBS39bamLID4Zn9CoHH7UI2GR47nv+uYnM4PMBMdjhtoVxTWBPnI/yncXCrqxTuYdgjYxkerEIEG9/SptOR7xUaCEdRVPLXLhZK06BdTmzAax2oijYd/LYBkoyIpAXmYsbvzOG4dkMkUnbkN3ci0gQt//LOn40jwJbUGOLbLj+TmO7As1HyDyLzlN76qAUac9+ZCEuMl6onk+ZLYoTQX0eeb0HJ3/DXEr2DUBHlD4iJK8ivfqZABY7Nek9p1kY0FxtzgDwp+MyDbguiBCmKxIPgDVBd1H+OIizleIAKWTe3EoLatNoqLwuMHNvP7r/+k
 j9IIdC2s
 ePill/2wkOVun6P6ZmrO/u6PxesDwukqAjbk4S8/zxrz5O2WWlnXEFlMGbnPejBVq3fqMF82co+gYEsIb2o7Kihq4sUU65cAl9H1RNY8TpyM2xZUytNIDJ3Dgb57SyS9Ge4dE9weAlMFz50uqVKjraoaxQqAlTyinkPmwM1BYAhnBpOIWOXmT5p1mw91IQe6XkcdRe+4PDB97hKzxE2mrpIBaYNkTOWFquLXAoyKZhIPInxJrnbqokdPE8EOlv37iLQiCs2E6+X+FVGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 16, 2026, at 20:51, Usama Arif <usama.arif@linux.dev> wrote:
> 
> __filemap_add_folio() inserts a folio and updates mapping->nrpages
> while holding mapping->i_pages.xa_lock with interrupts disabled. The
> XArray insertion and nrpages update require the lock, but the lruvec
> statistic updates do not. With CONFIG_MEMCG, those calls also update
> per-CPU memcg and lruvec counters and notify cgroup rstat, extending the
> critical section.
> 
> Move the lruvec accounting after a successful XArray insertion and
> after xas_unlock_irq(). The page-cache references pin the folio, while
> the folio lock keeps folio->mapping stable and prevents removal until
> accounting is complete. This moves one lruvec update for ordinary folios
> and a second for PMD-mappable folios out of the serialized section.
> 
> In a 30-second system-wide perf lock contention -ab capture on a
> production host, the hottest caller-stack record attributed to
> __filemap_add_folio() had 20,867 contentions and 557.930 ms total wait.
> That was 14% of the 3.998 seconds of aggregate lock wait in the
> capture. Moving lruvec accuting outside of critical section should
> help optimize it.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


