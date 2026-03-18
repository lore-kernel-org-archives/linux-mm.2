Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB7EC107760E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5A656B0312; Wed, 18 Mar 2026 16:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B456B0314; Wed, 18 Mar 2026 16:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47C16B0315; Wed, 18 Mar 2026 16:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7C4F6B0312
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:22:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 987F416017D
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:22:51 +0000 (UTC)
X-FDA: 84560307342.23.E6622F7
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id C337116000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:22:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mz3pjj40;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773865370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VTOk/HwhDYPUV1Fg9ZS7U7rtMr0TqNQvrYgA9tKBIA0=;
	b=mFhcfY5wgpg85PUjd7lEN4z6bACgLdZQ0LjIBA/NZAK3moAi/MUF4B6scj7iqhUXEks1yl
	xPf3kviccGnbBa9vnrSsntVQXh+imRccVbR0EHpYiXUCuyHooSf2d6uj7UP8A3Sp1Mr4Y5
	q4/mYJaveVZjfng2eBL58Iae1b4ZJcY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773865370; a=rsa-sha256;
	cv=none;
	b=d8IG22KbldD2PgxYdI5JkY0BVytFOwqGZZCQl7wkmiIsWzzQgxvme1PwTTXcrFfHZg2LRA
	oOkTjMPHkdl8tUKM2jS5GljUHIaYlCJfL+1qRaf0bXipHPyS4TNELJ5i2T9g4cgTOv2DhV
	TTvQnbaTJf2ZGO2AbeMEcSPFaeCW3O0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mz3pjj40;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 18 Mar 2026 13:22:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773865368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VTOk/HwhDYPUV1Fg9ZS7U7rtMr0TqNQvrYgA9tKBIA0=;
	b=mz3pjj40DQYyDnViON8JVCrdkK9V89CCMjOgjh02MnBBb63UvdygTXgyi1UNy66u8fjXUb
	KB/jrNjvA6zIyMZPJm0Fw4grCFJmMkdVLRter3akLXC7ZTOhOy2jzrpD7xZ2omxqHnYYeN
	Ubv39vsRoDRP0d65j7NT3kZr+5hgj6U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] mm: list_lru: deduplicate lock_list_lru()
Message-ID: <absJf81ccwY7wLH4@linux.dev>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-5-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-5-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C337116000A
X-Stat-Signature: gkbfy4qdp65rg1xgasjzub4sdcik76bw
X-HE-Tag: 1773865369-452646
X-HE-Meta: U2FsdGVkX1/YwZopFOAMJvJEO4QooRPZwlI9TVFNF4TrOzWSIdtZnEMjJmohoKo1bC/TH5SnlabmwnQEMTyOnMd9RPo7R+lZgD6grv/W2uHtb+Bf/Pn+SFhPzKA0JmCWxUx2s7Y/53BIvNMLLmZIFPA8l6qoCnz8HPWRKzi5c5t9FbzOLPGmwAuUafjPnyIGaI90iyEYOrzy7bX6Vz5Tcf0xR/8ugUfTJkmKvHonetgWIQVR0rcySVdg1c/8lG90BPpMfWXiy1S/UXddBLchec6RiMC9zs3pzJrnDCyKC1GSfxcxqlM9ZlauMM/SR10GThyOj1yqBUuxpq7l2mcQNxoFBTwjq0RPpp6Myolm5PQ4Rpqrch9Y0oRoLFeH1P6kUcEy/h1leNgLuCZisI91/YjJ+5FP5A0sNfg5XIVX99tFIsUCg4PhmdEZF9fkC3GKAxOUoIF5jVN+YWszts5YpIL85gjFQToa3Bv94XNp89QwLKLEhtpm4JPuQMbggz7gicuDdW8BM4099OsrU1ouLmamOfl0bBbFOxxhmXvfyGjTB2az7xbgKMJz09gBafh9F1hDQjkQNcvJjkgpwASQVtVirw1V2HWGhFDaS+fS7PmMbTHY3YG2mJkobdn+BvPwygTaMk8CbpNiz2K7uIC+hJ/+wl4ewoLoAYt4yQaSkcaxX57CF7/0mB7b25czRCc/z0aVuDteok+cYDuOTw/cr4Ux4boTmEY9nHBqrGXvrqwgsqj0Z14AwR0t4u0TZKXl5wquOxFhbJEavq9W/AZtwBz2WCR1FTu9eULZHLOPR63haBRRKtCuXBQG4MUla+AsdacOE2ovqc/LaNdk5vzEGZpqeK7w4v/ZACRCa4Rn5Uk81FmBRoisxILkjYgFPHE4bNeCcBsA4Sh5nZu87r0IHw89lWe4Fa7cgf2JZXaGtIo5Sd7OrwevA6E/YHno8Z+9BBHVVvAcchttxW/NlTE
 G+qhJ5kx
 wzNLB7V6dxR2w8OGJlT8CO9Y4RCW7Zvfx01jBmbHkHaXod4VnbC/Y6lK+8AYpOG1YtSG7KJWl6iklxxFlkvqnOe4fWIxKRtI83/O0QF2GxjzXCFd9sXJBa6zaTcRaDC03ihT+OQo2D3XU2M0lmm8dS/lB7KTnU3m+H1KmSbFjh1eG8JZLJZjGX/G4jZJ87X9jLsM6DXoiLMOr3fMOg7pDho4nDCnyjimWQP64qr/AE7jSI03cg9AWB2/3osRQRvYkVTF44XIV+D+cvWmjVgQ63ls5sz9UU6VrvZtjKinMfz8JDTUm3/lsS00epQIakx2cMwXcfxr0Dd/ThNTw5NRC3nrD3dNuvEiLeP/DLo5exuNoEHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:22PM -0400, Johannes Weiner wrote:
> The MEMCG and !MEMCG paths have the same pattern. Share the code.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

