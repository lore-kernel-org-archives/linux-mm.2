Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E913F3ED54
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 14:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5D86B0089; Sat, 11 Apr 2026 10:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A565E6B008A; Sat, 11 Apr 2026 10:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96C336B0092; Sat, 11 Apr 2026 10:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8585E6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 10:29:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 032281408E1
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 14:29:24 +0000 (UTC)
X-FDA: 84646507890.01.0AF3520
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6528820008
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 14:29:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ue5+mMr2;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ue5+mMr2;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775917763; a=rsa-sha256;
	cv=none;
	b=6qmFBpoN5lsVyZlNdLySQwKWfm0peVDjgJZmUElIOwLDlXAvsJzwIKwtFeylQ0sYJVYGbV
	vh+kQwQ6V0sfww7p98gIi+Howow/2kDcrC+j4M4h+u/T0f7bt4cVVFoxlqiT77CC3BI8dv
	gh7uxKp4sMHcLHDXeN/gHKeU5VgvNMs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775917763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAPo+F3jMH2I7xItiYLcaM+9S3+H5Eq1ikmT0n242L8=;
	b=56TCcH6ml4Im7Vgmcp74XyJXmvXD4lWKBzIfzDtNyrC3KK4olzet0glh4BbFObWzs6/JXW
	iRZKEVp3oXKTHEO8JeBXwNKVnlAFUCuNJDeOL8kdvturIBlx8lOb/9nVYIhU1SG9tol8em
	NzYadVZ/i2+U8XC0gFO9WrF8dB7eGE4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775917759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hAPo+F3jMH2I7xItiYLcaM+9S3+H5Eq1ikmT0n242L8=;
	b=ue5+mMr2JI6l0KzmB7iHuu/GYGrv20M/Byg9l+U66V9qTHBKJtg8HUDt8OBOibX0NXZp3X
	ep+l6RAyk7GaqNgsYrfe7SFqpn1CY9DvitpBQGYgg7hCn01OlXHsZYfzR7qWqyfFPtZCuE
	L1CSnGQir9/U6g7ZWPXgFyhlHUqTkcc=
From: Lance Yang <lance.yang@linux.dev>
To: lgs201920130244@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: thp: Fix refcount leak in thpsize_create() error path
Date: Sat, 11 Apr 2026 22:28:58 +0800
Message-Id: <20260411142858.85496-1-lance.yang@linux.dev>
In-Reply-To: <20260411062152.2092967-1-lgs201920130244@gmail.com>
References: <20260411062152.2092967-1-lgs201920130244@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6528820008
X-Stat-Signature: mkwrrupci6qnmj6d1ootzer3ph4iiqmd
X-Rspam-User: 
X-HE-Tag: 1775917761-479658
X-HE-Meta: U2FsdGVkX1/yGI6p7bsvcaRkbFS17ne9XWy+yOasD82CO8bHFDjbOIlIM2gU5WHgiCbWHsiqSjpDxdKSwxeE1du8FnzIh8hNufi/Clp/1lw2JxpZKsJsH5lNfYSo1YpMm7RjNvPi90xrWrRFJufav2mi7FSdF5cKGqT0syKFKklPsoCCsAMk23OSWhWRqZuVAmn5HF4mqCpeHcWpEyk4afbDFjtRQWlWg9UxHkmMwvOzXhDb3NcPdiCV10RdSO6YrOo0wH1llHFmh4BWgZoLlFUU2iSUGJNoO7F89kwWJBfoDwzIUnAm0jGxgtVy1DffD0nPtrRWhX2AiJx03V4te0uvABp+C9Mno36TGqkkLGGbBXn4T15260/AVmdFzD9yK8V93PRI6dHEWrDg9EeW4WgtEUrbYKBIUXpGHO++akp4UircNKGovPo+8dEjxmTVd69ToIZ5Z0pVpIGikgX6hwSJpQOOWfLOrz8p02Mfk69OteHQ9qYM15ITqM4lkVRLHsebgsY+T8XAwC32JL8Mo+rtUinaaslOuiXWttBVvkFbTb4zxuspgvV+kTCBoXlsAOzhZ+Tbl3duipJtxX1FaMORuxo2qZ0xK0ksgbQzdw62PbqMXMAt5qRaYGPLVyixkuZgehTpqZNALgILwk2abwDG8t38hvo8A84mJ7BeEg+QMZjGOOWaBNOihL1pbb0FnL5O8cWRC1TVaIehtT6TIY8XPna27LackXP+hSD8bY86gsZEDVJQMpUV1lKz3Vmp1teHg+SHO0E9B88baiwllTgmYy2+SonBWRE3rrrjVEAewwkC6nBFQ84rGHHu9JqlCGQhbrSuCJkWnWlAJci8AR5Rx6QCmEp7BlXKTH4ZK7Td3QD1/JS+HdDEAA5gUJ6EsjqaxdQY8UtRlQGKu3bhY/dxzWPsgM9umKfdqe3RxSNpHuSm1zYu/IsAhvyZxJ9b/GsgN1/2amcuksRgwqb
 DOFGrYLT
 /isxHSEV89ZizsrpOHt3RWqO5Y8Gua4XJ0+nRXldk4W+Z2UB5OgJwRvalLHrh+QWADCSgS8Mty5D+Y5TlTO9HR2f4bgl7p/8lIcBZ62WZKO4fF1BX+HAtw0Mznif4GAB5Pl1z0DEzFwCUaILaMPExpgyEjiHBYM3NAKzWoL2kho/TK1wUnZs7napLkpAhnA94Cx0MdTDffrawGxiNazUlT7OBZNtkz/AhXeHKuWoUazO/b8y1AFTS70fSZ53hJen3NMw0EK7ovHqnImIh8c0Zm+cjiz5w7tcE8ACy7LZP3LpLqER2gj72tx7dYpJwgk9hMyQgsr6I73czYstb4omUgloKiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, Apr 11, 2026 at 02:21:52PM +0800, Guangshuo Li wrote:
>After kobject_init_and_add(), the lifetime of the embedded struct
>kobject is expected to be managed through the kobject core reference
>counting.
>
>In thpsize_create(), if kobject_init_and_add() fails, thpsize is freed
>directly with kfree() rather than releasing the kobject reference with
>kobject_put(). This may leave the reference count of the embedded struct

Right. As documented for kobject_init_and_add(), once it has been
called, the error path should go through kobject_put():

/**
 * kobject_init_and_add() - Initialize a kobject structure and add it to
 *                          the kobject hierarchy.
...
 *
 * This function combines the call to kobject_init() and kobject_add().
 *
 * If this function returns an error, kobject_put() must be called to
 * properly clean up the memory associated with the object.  This is the
...
 */
int kobject_init_and_add(struct kobject *kobj, const struct kobj_type *ktype,
			 struct kobject *parent, const char *fmt, ...)

>kobject unbalanced, resulting in a refcount leak and potentially leading
>to a use-after-free.

IIUC, this looks more like wrong kobject lifetime handling and likely a
leak, not a clear UAF :)

>Fix this by using kobject_put(&thpsize->kobj) in the failure path and
>letting thpsize_release() handle the final cleanup.
>
>Fixes: 3485b88390b0 ("mm: thp: introduce multi-size THP sysfs interface")
>Cc: stable@vger.kernel.org
>Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
>---

Apart from that, LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

