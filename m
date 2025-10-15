Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6F6ACCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 20:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A398E0090; Wed, 15 Oct 2025 16:48:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D125A8E0057; Wed, 15 Oct 2025 16:48:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4E588E0090; Wed, 15 Oct 2025 16:48:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B582E8E0057
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:48:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 77441B86AB
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:48:35 +0000 (UTC)
X-FDA: 84001536990.20.6620021
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9B67D40007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:48:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a6BsS5Fd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760561313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xTg3aQAK9KE0ay1Gvrf5jH48h+FMnrhgYNSbvhy7rOY=;
	b=LxLS8HpD+srVfsRCWSn1/lINLX/jPSyp250a6iL3hxmL5uLFBePA9MranoBmC/q7apTBAo
	2aG2WJPkY2gFpk7Ly1NekH1E+YWhyjwZqfwcpKZAP+SFzNv94oSee+HY8F1ESV+Hlbdylm
	qWztYzfPvWM+XLzLlyRZhem115mAyJ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760561313; a=rsa-sha256;
	cv=none;
	b=E0Iev0KhxtAYug06ZPPRSOXkgKQkKXL/lj6gY07MrJfg5PC+3SqKsmSZGx4Ej80voDzRns
	IM/t9A9Igvnpkmp+5mJxFNqIgfwY4Pwt1OiLqMMd6xvNjbO78xLVrj+FSXTot+ygfDqWC4
	EHwDTZyhAz5OQGC3rbOzOwrnVzsW410=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a6BsS5Fd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Wed, 15 Oct 2025 13:48:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760561311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xTg3aQAK9KE0ay1Gvrf5jH48h+FMnrhgYNSbvhy7rOY=;
	b=a6BsS5FdHz6RDbryN+6dOyxrbx+19JpYAD2FU+Bz9hIV3U1mR9cUXZ+IUDxxmEIjE+zDE5
	UAwpBAQQRAnIOOV7ho4+lKTN8qTC9NdDDgWDxSPmVZ3ODYhxF/IpCutyEG2hemWcdfLTrK
	v3P1wrEgxYIrFFDPcIKVTO48g3VA2ZY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: andrii@kernel.org, ast@kernel.org, mkoutny@suse.com, 
	yosryahmed@google.com, hannes@cmpxchg.org, tj@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] memcg: introduce kfuncs for fetching memcg stats
Message-ID: <sw2zbwvfadqxi7pvlwhyt4xlbfujonckowovvie53kejqzup5a@3w2dmlkblm3g>
References: <20251015190813.80163-1-inwardvessel@gmail.com>
 <20251015190813.80163-2-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015190813.80163-2-inwardvessel@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: z437i1rsfp9n4djhrocou3ruko7kdnnr
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B67D40007
X-HE-Tag: 1760561313-257821
X-HE-Meta: U2FsdGVkX18S26izTkcFJLp0S10jXoAC1FSn2/eXGJjDDcpWMZRfKYQidRvDIn/a+ubkvpO6Qg84Fixgpdj4dxM5DvsGBTWipRsPTDKJthKuxdfpFgzT6zYfwUtu7HeC7AP8rT+vUIhgasTc8TLjTXrctMf6lWjgNr6NODLMVZXpAxbocNWKfMhNZR6J4B5DCmqVnCMeJsyLypW2XYvvBvT5GBc8Sg1vccIiccf+mL48hvRljnkah6S5IFZLNHINItQGb8Cule7qyvYhNnbFTHpj7vRjowSELlLp8UJOOCaN7+vm5opDeYtQ7mfXZa6Xk+pPt1rzWApwqrY4af1qc79rtzuuOWnSNet+2yhX5RVyxUF14ezMjoBRFrjsvZZ92lkFGEJ/IH+3pKZpf1RpkuKTOpPWL6w29nYH7OBTAJKsrRcpTcApQZwZ1h9TJtbh5iPbc0tbT7FnOOdLPnr51cyHySLS9SPcfUK4FmdV+IBo4U6Ojd8FdCONiMM6m02YQTmGHx18VVqgQJiMRPLW8SJr+b9aehuGMYv69VYyYd5W6iNXiT9hYlSmQHa0+K6HOPK+eBBYESntuYz5nTFcZ7cWAKIEeHzArUeam5iY+pnaZ8pTF4fyHV/oO6IvC6IJrFpSNjY79xoLHOIU3y+RmI0gWk/5Yp0oYCjFVKKGbgKNBn1QcHb0ZWic2/2IETcDjH3p9nmf3QfF/RARLZF3bwerYUT5r706LVCHXx3NpXZm7SWbk91GWmJnBpKMZxGe/Q3mHo0lS9EBQIykK39stm26DAO00HY5Rxpy3oXVV0MlJ18mcFPfEpR4ZKRKUYY2huDdvkjjKXLQrXg2tnfnEYJyB/jfpN8SIZ3QS+FrfFBLqHt1Hyzo4vhX5l4XUBwAfSVVLrgeYpqQuoXUfNdV2QxtjaHllzJGvOTbvOWuKNmlTzipvW1WTuu25Ygo9xtiy4UkD5ftNeO4YaBQ66S
 zTjiztBi
 7K8eWYowKd2IhSlgBpTyeeoXzl6+ejp51Aj8lBS8QarIf93bcYmtrS/n46DaqhkDWhqSFpY+j2WEix0biHP3DuFtj+XfkZVNeVjlfwvRlCe1bujhcNzj91wvPDDeTAbSwmGT4YMU+qm7a3+SpD0Xp8FXyufM8jOsKq0tGf/d/FDtLHkVC7h4EjwfNJl9HbZxqC8wUFlZFbpZoNPP/8VlLhIhgwSUXPnS5W9QpnDdDNKL9IAA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 12:08:12PM -0700, JP Kobryn wrote:
> Reading from the memory.stat file can be expensive because of the string
> encoding/decoding and text filtering involved. Introduce three kfuncs for
> fetching each type of memcg stat from a bpf program. This allows data to be
> transferred directly to userspace, eliminating the need for string
> encoding/decoding. It also removes the need for text filtering since it
> allows for fetching specific stats.
> 
> The patch also includes a kfunc for flushing stats in order to read the
> latest values. Note that this is not required for fetching stats, since the
> kernel periodically flushes memcg stats. It is left up to the programmer
> whether they want more recent stats or not.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

