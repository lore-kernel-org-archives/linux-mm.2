Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03CBD1094489
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B516B00E7; Sat, 21 Mar 2026 13:40:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303B56B00E9; Sat, 21 Mar 2026 13:40:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23FB86B00EA; Sat, 21 Mar 2026 13:40:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16E026B00E7
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:40:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA7B28BFC7
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:40:25 +0000 (UTC)
X-FDA: 84570784410.21.B2EFA91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F394AC0004
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:40:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S+pDJMhX;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774114824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTzk02P3caLS0oWLofcLQuffQafE6F1eKgfjRgnCR78=;
	b=LEDJH5dS9/HgmOHAJzgsNBGzP06htLPlN1l+VkViQmzbbfCbnXdleRqFjvsUNqPbfokNYZ
	ZYY6j4Vnkli3y++OEteQvxulkUiKCm4+yTeQc0VfXLezB62/WlYC4gLzAoLfqA/u6CnyWC
	17c2eX5ek3P9qMLiR9Q8YxYs/XiHryE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774114824; a=rsa-sha256;
	cv=none;
	b=LnQP8IoPdQZd6vkPPt0xsXi2hsOQhps0C8vPcFzkKIOcPAtIaMNp9IlXdkXNDMizv2Ywzh
	AToSCSlDrVsPsuSVJuOyFvukHEsAO1XK13/E/DEid0KUo/K+dYviTcc+hBrGajNkRLjHom
	Za9UoD9dBhM1Trd1ji1XD6+f9Dx+CqE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S+pDJMhX;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 69F5460097;
	Sat, 21 Mar 2026 17:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931AEC19421;
	Sat, 21 Mar 2026 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774114823;
	bh=Ls3i/3Z4Mf14P1cnWkjQU7GQ+uXpXitTAoEU6mU1e/8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S+pDJMhXziAJr/dUnXYVT+7qiwwywkY5CGkhjVrlnbONIgUSo6UIBB7n874AHlQgI
	 CrlPMffuYtVHmc5Fdunv3viqL9xchhv9+KmM+9nGgzzWm/SCmvIzIaYr2r+CsTAGq4
	 HBupKmHMUR3DAXVWOqHmJK8HYr8SL4TqUUmWpKzY=
Date: Sat, 21 Mar 2026 10:40:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 david@kernel.org, osalvador@suse.de, dan.j.williams@intel.com,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
Message-Id: <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F394AC0004
X-Stat-Signature: wjykr4pq84aao3863dmdbhndaeaat1sd
X-Rspam-User: 
X-HE-Tag: 1774114823-657514
X-HE-Meta: U2FsdGVkX1+1OwU3ThxUhX3BVCzZ3iqlPlM9qaMWkn2X0RsIW8daLUtxdcHqjqEbrX0dCjU5LNfP0TtKZPUFT5g5YNMLjeYUbwHzgQw9+eQQOxuhbVmbtBokYrnnXrKjCrlBw4Ctv3GSxsqStMM2fa2AfXdQ1pEx+Bn7aovb8Wcot4dDPs71hwjDuWmZLcMbqX4C8W2tSeVsgnngWTVCERSA3FTu43o0u6I5suHQ4fS32Wmi3MBaMNU6ntHcAJUzy2EGr7k8DwWHmF35DWk9QdFTbVt2tb3NyqHfebrODA/9ltjW/rsVGeSR/eK9CiKLGBVc7Xj4RBLl5A4XA2bG/9WrJyRRLsAfx9T+oMxAulPAKBkXsHYckHTCdorvD429acjeSQKqmGziC2H0aFqaVG9091R+3BSNva38iuA1cgXoQNBlJgkRDa1T6g0JvWlNIwy612Ipxu06Hxr0OZuVGMuiwU6icqQPkBciDAzv1mL7W8j0Bb7jnf5L5eRh6VtmxAfXZXs9fK7Pl6KnzvdC5lZb8v1j8Y0q2P88BIFpZX+6zCIiBdFr2MPIMNrzZf7QYktYPSj1UDYwVxbNSmrZfLBRocUkm0yoFPMhxlmALbdgowi54YywCRc0suV3DgeEpoyeYzh109kN7VTS1DCeus9KYxG69liGlrRm4SbBc+N9vHUIViR+bTKnA7SDlwUihDTlLZCzqOj7yJuU3mBM7MpzI4f89S/h+v9plsSIIP2vKNGYkYw4MiJ38lOmVQXsdwzvKpeoHXw5hD6IONYovx9FbBE73xR8PVux2H5wIldykv1/9HVodaEu050513IyM1BRH32S7yPGpDygq9wcbc5UMuojEtKBuEUPfhFpOZgIn8WuZDDnweDPPaUyPcy94/xt0dJhxHHsq3WJU141MVgvqJKhXbta0/RhKjeckLkD+vTSTQgT03OeRLH7JF98GsQIRMKU+6zq8c+tgFA
 nPmiJa/t
 2L6daVJdsK4HkODgiwFg8T0tpBmMG07imNuJcwEhxdHhjgVtpXiegUX05qOMtWzt1Jr22/edFle/4TFSeQuXA9PKf3xQX+K4AiyD0vgWy7vPhSmURW9KHbJQ3UbQh78GKV252lWnaJNqS9gc7sykREeWHHTQl286cjtcXIUb9QfbAn3aiCUP+c+nSlW3904PMRvvqjzy3yvvKCzEPJASHNwNIKnyjW7j8//2jD/6hmoU0fL2Q81oeP0vjCLFFy2H3UFX6g0f8yZo/n+L9gCJj+pa5aheK3QvHDC/C8c2aJfcSmSO+cMm4GHvEpzRBPzb4Xhn/z15Z5Fx6Rj9N8/9PK9qV8Fw4HfimmpGvt8jMRDYmErCb5anLMNXV/Kjzam7zEASM16x15KLYfbvlQ5eZQsN0PpKR72YvrHHf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 11:03:56 -0400 Gregory Price <gourry@gourry.net> wrote:

> The dax kmem driver currently onlines memory during probe using the
> system default policy, with no way to control or query the region state
> at runtime - other than by inspecting the state of individual blocks.
> 
> Offlining and removing an entire region requires operating on individual
> memory blocks, creating race conditions where external entities can
> interfere between the offline and remove steps.
> 
> The problem was discussed specifically in the LPC2025 device memory
> sessions - https://lpc.events/event/19/contributions/2016/ - where
> it was discussed how the non-atomic interface for dax hotplug is causing
> issues in some distributions which have competing userland controllers
> that interfere with each other.
> 
> This series adds a sysfs "hotplug" attribute for atomic whole-device
> hotplug control, along with the mm and dax plumbing to support it.

AI review (which hasn't completed at this time) has a lot to say:
	https://sashiko.dev/#/patchset/20260321150404.3288786-1-gourry@gourry.net

