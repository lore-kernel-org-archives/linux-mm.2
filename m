Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D277FCA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 07:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E6848E023C; Sat, 16 Aug 2025 03:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697648E000B; Sat, 16 Aug 2025 03:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6628E023C; Sat, 16 Aug 2025 03:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46D638E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 03:34:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0899358A26
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:34:22 +0000 (UTC)
X-FDA: 83781807564.25.A60C082
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5B79A1C0003
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 07:34:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nycIx506;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755329660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uDw0oBL3Va0OnluBaQtZqi3/A0ErKLAzhvTzXPaxkTY=;
	b=HIIWtm1xwUVuBPefyt8kQxW0b9ad5Q1Ey1HIeJFCSlT5e0rUH6Za60J4a1qajKdcXkHjka
	IMhBLzc29ukkQNTGl6NogxBeOWC/nErIbpLI6lXzCAjHO4pdBgALFXw+wtNCFqVmf+/cse
	mdDAuywcnDDQidfUy7ktq+2EkZemb2w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nycIx506;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755329660; a=rsa-sha256;
	cv=none;
	b=luzW84qinMc/w2gw9/j3m+C4cJ9x5LhceFPaQdT7mPFjJLny/LjM5taugYJJ5nvkzUZKG1
	5eeXWnCJ9Kui+aB4mKbOIymkE7Rz/3neGHu7Z/0fPzOIZRCxiWLi9ou0UMLE7vTVoCWysM
	bbvMXRRBTV/0ePSU57N/Nk/CD2ywIiY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 64BB25C49B4;
	Sat, 16 Aug 2025 07:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B273EC4CEEF;
	Sat, 16 Aug 2025 07:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755329659;
	bh=RBllP1HyuurzngS1PYFclVqgZxQMsi/60lRopv0XgZs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nycIx506DjjSuPyBwZha4dR4dyULJn+oZM7AxMBlxDvtnotMOCCCtdejoR/8MEOND
	 +iwwu3/QA833OQNZvhpg01GPq5VHljkRvw8UeRkJA0hpM3D6wGzqGGMo4oe1WC6HfL
	 Cc82ObFNcUhvbo9BctYnSIjtatfuWm8qXsnYVHbQ=
Date: Sat, 16 Aug 2025 00:34:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Xiang Gao <gxxa03070307@gmail.com>, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH] mm/cma: print total and used pages in cma_alloc()
Message-Id: <20250816003418.b2a62f6ddbcf9468fde87a18@linux-foundation.org>
In-Reply-To: <701bfbb4-6c12-4614-a322-def3ca923c78@redhat.com>
References: <20250816042842.3959315-1-gxxa03070307@gmail.com>
	<ee29262a-911b-4a97-b619-0dea3b657252@redhat.com>
	<20250815234528.882ab58247cefc96e4137811@linux-foundation.org>
	<701bfbb4-6c12-4614-a322-def3ca923c78@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jfobsm5b18hfto71pci73orq5grtszpu
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B79A1C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755329660-466928
X-HE-Meta: U2FsdGVkX1+HRIA9JgisCoHLByxnIPcqHHobah0jY/wnE5o871pnTJbt54Uj6tbg4BZ8LjPuDNMC2I5j/nq/PLdcUWtA63LX5b2HY3hoE9e1UI59FaRv3hxTyZO9a1HHUFkZjH/UhI1dn7s/q5470go7B0bGFa7Au69zbW8sM67NHIZTC+kzKyJ+NUCsuKeZ1y8TgNwJzUaOIpTcEBQODNU8KzhhwPXfMROjx472j37VP6Y7z8u4NUHmhAWVA6ifRa25v3WsmR6Xg0+jKSUiCy+pfkm2EuU1nsHkdh00J8PCRS3ZjwKXRfhH18O4C8zuOZUvK1JJZh8hJRpe+NV8GtM5hw+lYLYpTjAagg7CgvM8HE7yqlUwgU7UDV/ZNct/SRxVEnpvM3DLjDDhYhe5rHX9YzaEivEA8bXkYdDkDAK7MGmCUS54ScNusoFBnnkH8MJLp7wlKhxqgzD1fJDST9fMnnTEnO1a/HO2wV3TiaLuQxNBIrAKWm6WtGkraZyvglOUIia2TSxpu1pNR/WZOpskCUMHFmk1f0tEe3EUgaysSOMbhL0CBMrv7GsSaMdXGtCLEr+RmRp6DKoNFnoCyDZJO/fo2Q7VEjnI6k4NdoGRDPvACj+GedkSA6iTexyzsHcX0SWKd3kyd/3XwIfJGZSdGJ6h0sw2ml8FeEU9NhRhMQT957+2E85ojGLH8EUvPoX+91eIwS87UXorlplkaLalIGv8D+mpCXdfNsAhbmIGOFVJ6INTyTyIgpJ+w6DgdDc/xTj3qyjlm75fUdd8vkQiax8FY3Jz5gunaBagBRzxaQZIo8d2xATRofzEsYo0zSc+TFsPD0+AkSXD5lHiiUxd7U8DwCA3oEMDQT8tFEqn0JaASkkbvvHV6gnNrruH+LNSC8xssK7UV4jXLMiuBIiCqXIK+5/T6a1y7P5V2egjj/5bM38v2/1GX1n9Qf+MKFWx02IjDCduZfWZDJ6
 feDTFOgr
 4LE8Gd3+xVgyN3nTeljLsxHreWkLOBc/0Qnwu7rUX81/Bt7hfxEZ8LTqMdfvoOex/w8zpMzNXOJFpBpi1dWMgytuhiTFhFU9aVZdCCjmLl5ACilQ9gu3YpOls//4tSgzMnR17oYviunq2FsosLGPlrssuWRtgCEy9GLxDf8ZlKuhNV+fsouTRew1lzNV8WSvLrI0pmI/xEPZQAtUvCoeOQksAUReplDDVx+VFLnGU+3sG6GgEA2Y1fQsEFOAzdypWv71De05vAdLD6UPDuMFkgLwyFYiy9nmbNpw6s3PFKJfQS3Qh/XvXrYofbXC/C2luNTYC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 16 Aug 2025 08:56:47 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 16.08.25 08:45, Andrew Morton wrote:
> > On Sat, 16 Aug 2025 08:27:39 +0200 David Hildenbrand <david@redhat.com> wrote:
> > 
> >>> @@ -858,8 +869,8 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
> >>>    	if (!cma || !cma->count)
> >>>    		return page;
> >>>    
> >>> -	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
> >>> -		(void *)cma, cma->name, count, align);
> >>> +	pr_debug("%s(cma %p, name: %s, total pages: %lu, used pages: %lu, request pages: %lu, align %d)\n",
> >>> +		__func__, (void *)cma, cma->name, cma->count, cma_get_used_pages(cma), count, align);
> >>
> >> 		^ one space missing for proper indentation.
> >>
> >> But doing another spinlock cycle just for debugging purposes? That does
> >> not feel right, sorry.
> > 
> > If we're calling pr_debug() frequently enough for this to matter, we
> > have other problems!
> 
> We call it for each and every actual CMA allocation? I really don't see 
> why we want to just randomly make CMA allocation latency worse.

pr_debug() is 12 million times more expensive than a spin_lock()!

> Is the existing pr_debug() a problem? Maybe. But who actually has debug 
> messages enabled in any sane setup?

Nobody, clearly.  If anyone enabled pr_debug() in here, they'd
immediately have to remove those statements to get any work done.  Kill
it.


