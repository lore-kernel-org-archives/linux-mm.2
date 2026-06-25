Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01CE6CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE45D6B008A; Thu, 25 Jun 2026 00:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E95046B0092; Thu, 25 Jun 2026 00:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84316B0095; Thu, 25 Jun 2026 00:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B057D6B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:50:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A5E51C5D3F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:50:48 +0000 (UTC)
X-FDA: 84917209776.06.CE79DC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 77DDD1C000C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:50:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=utUUSNLD;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782363046;
	b=i/bBjAuCI1fLlASZ/mx816UdTtrIjekojz7TlTI+5FEHCIZnIZ1sXFdTwvnNCNpD+M7qtV
	WCjSMp8UeeQweYbZpg8kITgY25Bs81I9d3COC3xGKwOSHrbMEonaCohPSVaNyAbuq8dSCe
	8kpekPx4bSO9hqwtcHj0dfF7eSndUYM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782363046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LT6pHrg3af4k7uTIITLPROZsR12hFEV0K3QASvFYsY=;
	b=Z532xFLllEPtDxXplwW0tINdLD1xZoTSdezndsj5XauLrEdNmCpsjD6mmLvPfuRHFjm4Qn
	/cOXljd5GP/rskPldCGi5ro0srSV/CvFNsByp8rq2V8jXYegewJtMip+thD6mfiy8sTVYO
	0nAuW/ZqsXeqKhJ15j6N5PGP8ItnUIA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=utUUSNLD;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 457DB4338B;
	Thu, 25 Jun 2026 04:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B777D1F000E9;
	Thu, 25 Jun 2026 04:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782363045;
	bh=9LT6pHrg3af4k7uTIITLPROZsR12hFEV0K3QASvFYsY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=utUUSNLDHyEwcP1q4AAVrRwCjU0+vKgggmUUitgvb2u1qZsgvDWsmmmCGPCfacpN6
	 qmFGbnRKptNnbtpGFTO6PfkBK2LQyznW0rd1n0CKPfftiQYBkaohf2asHgJRv6Fu/C
	 e1ElUQqrAvEnJErEVIT/nULYAp+o6jALFOSChfmw=
Date: Wed, 24 Jun 2026 21:50:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 3/4] tools/mm: add page_owner_filter userspace tool
Message-Id: <20260624215044.1c50c765a240f50fdf49189a@linux-foundation.org>
In-Reply-To: <20260625043101.338794-4-zhen.ni@easystack.cn>
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
	<20260625043101.338794-4-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 77DDD1C000C
X-Stat-Signature: 7jt15t534dawfckkjhrq3cc9pj1773nf
X-HE-Tag: 1782363046-392109
X-HE-Meta: U2FsdGVkX19D7bQhfLXzGE3608Lfi4esjruhx9lOIm15mRgKimk+QwlKGBUWaS6rcXIkhsAjpgdU2VrYOdUuVf1YoeilC2BZTM7xL8OaozDW7mFFLOOgF1WEwYM2nqXaVlh1/FbNx3EGJWr+OhZaf1GZFc0OK2OSIdNPJJBWN53iSX62uNob4oyJ0gqTkavGRGPozk1pUvtLlajkcwFtCIfgq9FeUQhFgbsy0IIOBF2F7G7EXphpGRgBBGne/M+GS4iGXh40vrf4VVQ2XG5wYa9NaPOq/DEYkiHgdukRPdLmLZuf72TFvsZm9csWykI4AC++4o8k9mREtss3oebHKW7kPkXN+il5UqYRpAmOdLLCdfvyOUswcyPT4ZzMVymhJHOTEG3M5LufUuwvjwseOSOtGSQ7ecF+eoq7kpfnW51+qxkBpL7W1+/bRjkf0d4ZfWKqq5cObS89htK2MD0wKWIDlMSIFPc394WH7hvzLkr/6/M/cuX6Q/Zmk6IS7JLlAQgCAci1hr5gszi8sMK30KIYz5zD90kw+SpJqr2Z6rIRyZI/bnJGNBFmeJFEmZB1x67nmHxVSidSJSGrNgtxAMonSwJiS76+PgNpJtnqy+5G0BplGwJnB2eldMay2UgjmX1JHlzCr+hFQk/g6S4mtAr5MEIvguJ/NiBjMwD81A7xwWhIcCcAj2cfXFH1ph+CwjXa3vGRTwQP60FjcvWSgnSYz2PbAAqqtmUSicWroi4jzNRjAk7A9iUz14jRtiojVzQwsCrw71ALxo5NOIkV9LGs5jMWCsDw2lwXB7OqjXCmJmsdbcsEvAhcPa+K1uuiWhSb59i/U1lsiq/WBxKs4Eau+r+7BO7F68l2wfGXN0R1p8UTXPKONr7nRkNiVe1I4s9SklND78VKyqeeRCbFShakH3CvzJ0027qbpkvMg3rCw+a5SdpN+UMrXJKLGkEoMAxj0123U15gT/5IEMb
 3iqfZM7W
 GlsULUGQjrCGzdvrIXYWoM5AA9DzZ5AOdbnti0hhz0Aitlc5hNJYcP8FCywJnZ9bHYYjRMQdSssIIJB7fQTQ3OFO9x/u72w+7pYbGX7idXadWkzyuwX/4iz0qwwhpDVyZuhTs8TDfpldfH6hqqpi+cLgoBGtd3vsFc2tVuyBnsksB9VlSUBgQ7JtRqAy+ENSdW6NHUFqurPxUd/gnYnh0orgzVrgi/GUDWYQiwzuEQWxodGGI7zzRYkGcmLvOrtdk2ZBeaxx65/XPQDlN1Xbcmzy+zgpuOqqUlF4izhm0EpAlK9VtkBtEXdPzpKLfpG1HgyjFmqcp+5uNnRSbT0yfDlFl28A8FoNAbPfBQheuorJMc41dhLFECJCw3KhHY5DYA/bdOMAmTNJq4VA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 12:31:00 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> Add a userspace filtering tool for page_owner that supports per-fd
> filtering with print_mode and NUMA node filters.

Could this functionality have been built into page_owner_sort.c, or
does that not make any sense?


