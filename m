Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4DAFD1BDFF
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 22:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A2FB6B0005; Wed,  3 Dec 2025 17:12:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12CE06B002C; Wed,  3 Dec 2025 17:12:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01B4C6B002D; Wed,  3 Dec 2025 17:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0D7F6B0005
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 17:12:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A6FF1A0841
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 22:12:29 +0000 (UTC)
X-FDA: 84179559618.25.94AE5FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E39B140004
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 22:12:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bR5C6IUD;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764799947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ztoSSQzWgbODP0xpBNQjN//zURr/hrdvYpRvkdpH7M=;
	b=dG+PYFBnw23lWp/5zeKv5tojszJUtQC8hwGm4PRRqm2IcPlGdEKER0TKEHjTsQVb6hyK1k
	cuR0SYwZCa6sZyO6fIQmP9pz3jAXZU/Jm5G5yV069cblWXH94dyTu5xAKvMWUcISygI/HT
	RGXrIu3RU7P/pdsNpUcMeHEkR+wKRzw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764799947; a=rsa-sha256;
	cv=none;
	b=gtFTWLxbHpbMFUWfVU84vAYXJZtNWIG7ta8+bfyl5AI7lVJ8mjH7/qobBTavvymyXTkZ4B
	a4SnetSV5H+i2Jg9XNECjPP419z0Soi/Cu7ZEeV7YXr5YOR6hT/FdXFiXpURrKcRyxZLmq
	vvwLsDcw7r2FhRZLLot3iMkpllmrLx0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bR5C6IUD;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4847F6016F;
	Wed,  3 Dec 2025 22:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DDFC4CEF5;
	Wed,  3 Dec 2025 22:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764799946;
	bh=XMMklp2gsR1KYDQ43BzEdbB0rqVc/EYnOi34Qxei7gg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bR5C6IUDydU8BxDAOier7L1L3BU9KCoyyb7Iz92pj96qG0FNaVXMjZoHcFJ8k7DpW
	 vMDvEdRjJBNnIcqHRUeN8zt1OogtMGwQ979Dn9L3shaKqhatP/AUulNJMCADThP6O8
	 UMOc2gcXlHOJ9hmg8rlHvctCdIUHkMHLUS7mplXant/PQHpyiJXgWSUmu934YMWkEY
	 5hcpip0p7YkWGi2gIellyHRv5Dc3LMB+Y7MDWaL6oBcWFtcjD3oj/RnGof8FEXW57t
	 MUh4JZLfztq0X0M0Q1qgZbZJdjzL8TLK2HydfirNWW+V02VWp8lIEjgKQ2EOFTpej2
	 g49UE1WE9s8sw==
Message-ID: <ac78e666-6c59-4faa-ab87-8b1c7caaeb9e@kernel.org>
Date: Wed, 3 Dec 2025 23:12:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Calls to do_swap_page() from handle_pte_fault() on a system where
 swap is not configured
To: Gregory Price <gourry@gourry.net>, Jayaraj Rajappan <jayarajpr@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com
References: <CAEJW1wECyPh-wbgnnoOGY460ido=U2A3rPhF1FQAv7txed1-Rw@mail.gmail.com>
 <aS_ycQQh5n1cVIRk@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aS_ycQQh5n1cVIRk@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E39B140004
X-Stat-Signature: x1m4org6b6rxux4pfdoqe8bgh3pmuqac
X-Rspam-User: 
X-HE-Tag: 1764799947-140034
X-HE-Meta: U2FsdGVkX1/qZ88CFSIsOblYp9ywfGBUBm8KxVzo6bJ3UzucAXzIt+HNWdRQPtDFSHM6DYYSz5ALtN/w10YEpgiGXLgb0vSFN0n1RHoDgfLjqaT5ma29FwsZQSkiyhQaDyEJr3NWqlpJt3PBUmWJpb4k3ozJAR+vAKWT3ImrQKgytDri2ekK+zHXMMgiQKjQNv7WAdkbNadczqUi/JQIgYgYFaBnoq8WL3ThFUxXq/kmhpQyIRCegfAYvO9zEG0dbo08zzHfCB+pJevoRGqVLKcyyLnyn05WkeWvLrXlJBrOz416oNsXehb2lrdtZ7FSgLQYnE8/nBH68N1yMcE4uOLnItufhcY5b/3dNaC8HwOFmPZ9q38BugNTKmdIQonqeBvqe/Jy0KzOQe6BGA4MTcFU/1K8SnJxUaNPTKLez2s45pQzinEX1LXr17m28RBa/ZXhkPcXlEkY4xqmAW0PyWDc4DFr2ZPIBxAnugvjfK2+5Sc5tBCjSt7ImgJylAh0FFji9BJg/hDA/9sKQMsLu+gimNAZ/rq/CqZtagYksf5JERBoIy5NKBpCi17pxzKboZMwC3lJ+rOpfqkaay3nreWJMO0v3PH9CdeCOfbj8Iwn0Xoh+O8GN60cWScBZa7q1yKcSgGY/44yI77DqmA1jg5K8n+N5Y8y38eKrKeDX9TZefqaGkzsSaC3c6GQp1FvtTyNXUAp/Bj7U8UY1c2CSiKwL2F24JmtTqBAh9cgyqcjcFkLTAA4e/ZujERuzzhz+cvx7xWR3TodwPHl5+Q6AKjKH5sBlQcURTjn5mflG/Uk4mOS+ukbgN4XQFWswTKycP6nusQoLluok1BH91DefmhURWcAQwtXa6Y9h90RHwigLmmbjKnSlfWmd9Ld9hDxBwMl+H1QQQGV8cA1fvxSGb+Xx4jX+H4WK11MNDHK8g7Y7mnaz0I0wGJ4QNxcAoZHIWoIwzbljNuO4T3CY1i
 0R9gdMjJ
 k7s3CpkylmKuCqkrCnCQomAOxY6bj+pk/jF6i1PT1VXJVk3LbJ4ju07/1t1VO7Aj7hW3n7RncTtmh1GLNeJ66P58MvpcHLHw1mGF9OOT3lG2lKXsLQv+GVDDZ5F9RM6KEPTaVSJRot1nbkIt2vHxt1MBVFCiunK90nT0Zv/5G6/+W7/BBzE4NLbet3U13pjuu2neC2OKNbfPpZpdPp7iItwhWKPoIRGG3KHMq5AyFPUpDrq+sNd5fmEsX35i6L3cTTLV/CI24WgEWyPUGqe7K4Fyz++1O2KkoQWj/HLwHaQ69wWj//egyZ7j8zBNIpZBefFLcUCOAx4j9Y+q2y+XaQL27Kfc5K8y2Mki5XxdBFzWlGQbznmFFfxi4kHbb26V8UxlS1iib27XRApY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000105, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
>  From 92de7131f74b9300ea711ceae98bbe137cf0058f Mon Sep 17 00:00:00 2001
> From: Gregory Price <gourry@gourry.net>
> Date: Wed, 3 Dec 2025 03:12:44 -0500
> Subject: [PATCH] mm: rename do_swap_page to do_softleaf_page
> 
> do_swap_page is a stale function name with introductio of softleaf.

The "page" in "softleaf_page" is weird.

In general, the "do_*" is weird as well.

fault_handle_softleaf? Something like that?

-- 
Cheers

David

