Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C243ED111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 20:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E20F6B000C; Thu, 27 Nov 2025 15:55:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9F56B008A; Thu, 27 Nov 2025 15:55:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11056B008C; Thu, 27 Nov 2025 15:55:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E11936B000C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 15:55:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7741F13022B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:55:43 +0000 (UTC)
X-FDA: 84157593366.25.625DB97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B6CA740008
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 20:55:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h7KdYcYZ;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764276941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7x9FtxEYgF7vgwIiVk0YlyUW0PtE7Dp52qPQC2diGU=;
	b=dgzQn4Zr9OrorPhTX8iMh8NAgJ1swagk92p/WBICZ0MuVq0DNhUk16BR3hGwlETKSgYO46
	y/05En0+RwWWWZn1P6ZGCRQd+17+NkQIu9wAAZLUwVJWwtI6sPPNHmVYwt6fG4+FlWwDtD
	3rrN6ZOpj2b5POEw51DlSd0A1kwX5DE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h7KdYcYZ;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764276941; a=rsa-sha256;
	cv=none;
	b=eKpFNXnWHdy5KMAetIcYc389qe6AJrwTqvHWoE99O7viEdypqeyaBO6W/1aUGJC+bo5BwG
	OMD8RYIuv9Jj2zKPwy8VoPUDTGPJkc+Yb7OsFDG89azA6QO3Dg+AbuWr6S6t6VOuh5vR3O
	9QgAsFFQyg3jCMI8WOODC6Z6Mc953+o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D27D46024C;
	Thu, 27 Nov 2025 20:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD88C4CEF8;
	Thu, 27 Nov 2025 20:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764276940;
	bh=nBbha1Hg4kcAxAX2ukBFkZ6T2IVL+O9Lvml/KMHDqB8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h7KdYcYZ4TuJrTT9jdQuQQl1OLRj2Xne9zxcLYqOohZYz1j1dBAGVGbe7q3J1Bpdv
	 v7jCIZsl8PHuZG5EpHnuXqatbF+AOqG4GSdNAN4Y+ikB5K7S/3k88KgcRHrTma5RtC
	 YVyTej0OP9knbwCn5qxky/lVy9SQCIiEBEYCSkRY=
Date: Thu, 27 Nov 2025 12:55:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: rppt@kernel.org, kas@kernel.org, changyuanl@google.com, graf@amazon.com,
 leitao@debian.org, thevlad@meta.com, pratyush@kernel.org,
 dave.hansen@linux.intel.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/memblock: only mark/clear KHO scratch memory
 when needed
Message-Id: <20251127125539.98b2f148c6225f1cb7c9d045@linux-foundation.org>
In-Reply-To: <20251127203724.3177621-3-usamaarif642@gmail.com>
References: <20251127203724.3177621-1-usamaarif642@gmail.com>
	<20251127203724.3177621-3-usamaarif642@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B6CA740008
X-Stat-Signature: 4sqt3wn36beg6qnsks945685c6wqa8m9
X-Rspam-User: 
X-HE-Tag: 1764276941-183868
X-HE-Meta: U2FsdGVkX1+axCrRV8W1PQ/gfenybNwL62XjspVoraj4c5EhOfrC2Mn3K23ilzxhhBKlKzbv+dMBLx5ayeJrtNUi2V/5+H7WE3+LyyJcn4LWaax810TbnideAISD6R/jRqXPanI1mQWjB33K5XcFZ8NFD1htMlfJwVCWlkNDt5vp4AdFBL6z5L8dvq2O210IMPozAYryRaJELSiFaIA3E/m9yz04Js41/stexDEpSxycmy3Rj4j3uzcc3L30h9pcUhp8IKx1f+RTTeQOABl1+gIi53isxGQu4KJnA/oGqMrXyVKlGK6oqrTmKr+6duOFuyxlv48QAcQJYeyA4ASPCqPIr2jNbFt96pcusNUjCn+PaRBROsxjhQHiT0pXZ0EabChirvCLslfawdhyOi2a4GNmby07pb8GxIj+mcC/qqX3/BNVqofBrHpgokwZFWXRWlqYb7Rcx3AFtJVWL1m/gfHBgAJIy2NynFvp1A7xPIb2Z4vsUCr6Rx6Wp7hu66sEEVsm+0s0Uhyh7D3vUIkNuwNuJrXKrqCGaqRt/j85DCIzZ7AerOJ13xdnrRIXzEc4HGhtAnkElz2sBUQZKS/PgH6kIsCag+2XW/wsgqFj0ME+dEailmMRPTTqBkoHAMe3XGrHRgMESPCN/5pqWlYcUq8XMHMQKZx4dElEeHgvAcGuEVeC0XQUTkFi+Ukiam4d9I3mRm+nMpvdhLTVix1P388WL4CCiLeHx2ejRrBtCvISHKgYd/b01bd+vHAWtKZ8EGDi3KK3RKSXvmxKpkj5EHS+4/RdDQ98ApsdA5Xgu2AxyPCiD9Xz5H8lVStO+U49o9KGg1dwNp1QnHWCfI9PUaA318ZeL/+BYhFJZX6R8Yy+GO3Smi4OF20H9eguvtLg8uhxgL8vCTYhAG+BIJz4sXYSswyHIepZ/dCyehW64+8GAsTwGvWsdtfdMECRD7AcL8J06y3yr1qOqe9TV65
 i2KfBAdU
 KnXTyhRNt7kTdHQvVu5+FMwLu8DJYzAoP8DXWwjW1TsljVaL2e7neKGXcKTyNRLN1nVMHyvJAWxSXNmfW3vo1zWG+O1AX2aKX2rLGXUnGFdL2dIuC9ft8k43uSsvGxcF1OUbiALXNAt0JlRbX+gpgQf92ecqKCgVgE7Y7SZYwkvRj1ApWN25YIeRU7hq2esEfMg1tNDpjEeFr0ztPndYwYay0QJo0paw/pqPtfFqMjmsG2PmGwXn6yw3pMfTj6kzbdrYC2nIgQpQ/aEvwQf1EM+BavA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Nov 2025 20:33:20 +0000 Usama Arif <usamaarif642@gmail.com> wrote:

> The scratch memory for kexec handover is used to bootstrap the
> kexec'ed kernel. It is only needed when CONFIG_KEXEC_HANDOVER
> is enabled and only if it is a KHO boot. Add checks to prevent
> marking a KHO scratch region unless needed.

What effect does this change have?  Lessened memory consumption,
presumably.  Of what magnitude and for what time period?

