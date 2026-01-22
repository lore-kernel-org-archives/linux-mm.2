Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 015FDD6CFBE
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5724A6B0399; Thu, 22 Jan 2026 23:21:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D676B039A; Thu, 22 Jan 2026 23:21:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474456B039B; Thu, 22 Jan 2026 23:21:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC426B0399
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:21:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 464F0B9B46
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:21:16 +0000 (UTC)
X-FDA: 84361172952.30.C7CC89F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A13E2140005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:21:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EDLiiCYl;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769124074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0iozt8Us1Rhozyr7WEg9CFZCa93jzm5F1W9w70UUil4=;
	b=o3ekl0hvOJna8fuXqG7z96Y6rgc8xMKUI1Ms/WtLsa5olvaVKvtqmhqVi4tVEQ9aN+9ytv
	mP/uiGff+xJHCHskJectoZa3+7CmVIsObHvO7tVDJeBxccc1cLCfjAP/StcK4wUBrW3CUM
	vv/FJbQFfCBkds29SFNIp26++cQ/5vk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EDLiiCYl;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769124074; a=rsa-sha256;
	cv=none;
	b=YIjb+LSoKuVVonT47uDms9uYwiaXGdKODwn/Ty/adTzul09/Q/Q6AMR//BWVjVpZwpFyIA
	VlcRv5gGTpBmlk+sA++SOQ+JcKx3GYI3Y6RSmPKtOU1sSu279qP/m6n42vkKvVTDHR726/
	0TaNx/I7HQsxwU7tbDx0BLjynv9E8Vo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 054A2601D0;
	Thu, 22 Jan 2026 23:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D9EC116C6;
	Thu, 22 Jan 2026 23:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769124073;
	bh=FQSbPcWqMsCprYFwJmBz3VE+4rqivk3gkSSozBLvfkI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EDLiiCYlAOXiX2hksK+ejbN30bffeiS9x2mgFIdx/DnZKX7QrEZGQ69DKgTiRWOGh
	 RsXKpcqtgdEgrWVvBsn2b3xRnJyaXy987VYsCb6uoR63/DBiWd93QaDoRlvb7AIVBC
	 pTMdXz9lwP3LI6MfPe+taT8DT9kUK/oEZhA7O7JI=
Date: Thu, 22 Jan 2026 15:21:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
 "Alexander Graf" <graf@amazon.com>, Jason Miu <jasonmiu@google.com>,
 <linux-kernel@vger.kernel.org>, <kexec@lists.infradead.org>,
 <linux-mm@kvack.org>, <nh-open-source@amazon.com>
Subject: Re: [PATCH v2] kho: skip memoryless NUMA nodes when reserving
 scratch areas
Message-Id: <20260122152112.1a8be8e7bdab72631234cd69@linux-foundation.org>
In-Reply-To: <20260120175913.34368-1-epetron@amazon.de>
References: <20260120175913.34368-1-epetron@amazon.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A13E2140005
X-Stat-Signature: u6fjqsbioqursq4azcbzgbfsztapnysz
X-Rspam-User: 
X-HE-Tag: 1769124074-654081
X-HE-Meta: U2FsdGVkX1+W6PijHGf0HMig5LOt1LChRdgxIjs4neJOQKu//0sLqGZb/6RhVdbYr1jHZ0JhhNIHmKRtqZkwVAOPT0ZMpUg0InRw3XVALo4AnWEnfWo3uijcNN451dphiYX8IncXZb3xXryTYgLUQk2BqXGvQUIz4n+DcAJUN75AePrKNI5j8Q8+pkw9rtfK54l9jed4ro8r/tGKl5YFAWjlA8EcLGOOn7ezfl8LV6Na4JSmlr/hh+Lg06vEgYv2PlbpRCfSNpTYt3k8b8KmoyHB4wOA3lZO723DuzYOPC6cfjDtTyeU7LDP0ek968tFCSyk4r9tLR9n3SZpHgpJv5aDCTjSAHWDcA/rO8VxZ4FU5tGn9wVlBhEJTUAcokvSTjPLuOLkpQWoCFVJq77s8nYDlujG11IAFlTbrnjz+R8U+FTk2bpoZ8mjPXCZihkTzOVKkmuIwkuwpfuwZ3MLegcz7xh0I7KdFRvzsvStjPZ/WTpynO5907E0EEdFwfxEQZ7/NPsR1VY0P0qIdYYPTLB1vNHfsCIlo3oDnol4WJvkX8UT6QIMeSCiDv+NKGXkVNCAR3+7hFxwKvZSE8GF1G39K95l6h1vsBNdq6F7vXeR+6rosrEVgFuQvj4owaPHlC8EDifszIQ0lgfh9ybmJnjlBXtOokBY2U/4lmHg8mhV3ydXrADltxSCiNGn0dtl0RXKOim0Q8HCZBLvV5cIH/ENYLVfaNBh29Iqq53E03YT9XXGi1GUj2RTcQix1glqBpIj3QRlXkqtVxtbXy/5wlKzAgIl7GpV5zg+DeDBo4R1jEDGumENljuJOPCeopMnrPGluLFT7J5b6ETOvC4KIwFGCVyu9BPB+pQs2y+kXa/ho6WehsbvN3f/rluaADboR6usQbgCNNibX63raYtCH+BYoTccdz2K0FMiMDWJDOLw90/JYFByNWI/79IyI8NLzJdxjxeiXKP3HSr7LKK
 rwGwcEp0
 uUcdTDCcmfulv85XZdNKwxl2Lt4GrDQD4URjsriesXH0BxohV9hSvEOwPyVD03fHCaLotu62z3/x4rcwE70/Sy+AvOsUBzWOp9P5UF15CQlWpiWwWuCHu/Pz1heEcDd/GwcwlvpE7sKkAmI/XddHDzhMeK40tOLpPDKbtwlHFRzv3MJWH1dP8O/gxe8VrZwUD6ivaDI+io4SPTFFunr/ROZ9VkKxLwkMIL1FiWVLZjoNbsEsuTTmwHZuiQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026 17:59:11 +0000 Evangelos Petrongonas <epetron@amazon.de> wrote:

> kho_reserve_scratch() iterates over all online NUMA nodes to allocate
> per-node scratch memory. On systems with memoryless NUMA nodes (nodes
> that have CPUs but no memory), memblock_alloc_range_nid() fails because
> there is no memory available on that node. This causes KHO initialization
> to fail and kho_enable to be set to false.
> 
> Some ARM64 systems have NUMA topologies where certain nodes contain only
> CPUs without any associated memory. These configurations are valid and
> should not prevent KHO from functioning.
> 
> Fix this by only counting nodes that have memory (N_MEMORY state) and
> skip memoryless nodes in the per-node scratch allocation loop.
> 

So kho is unusable on such machines.

Should we backport this?  I'm thinking

Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers").


