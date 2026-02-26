Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59AC6FD8FF5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D91D6B014F; Thu, 26 Feb 2026 14:10:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0AA6B0152; Thu, 26 Feb 2026 14:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 907406B0153; Thu, 26 Feb 2026 14:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF056B014F
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:10:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2FECAC01AB
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:10:09 +0000 (UTC)
X-FDA: 84487548138.17.E2474B4
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8617480003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:10:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mCE72nMn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772133007; a=rsa-sha256;
	cv=none;
	b=tDuyVuSEZzVkt+cqjDDLVor0WvInlpWM+BHu8BMVStTLL4K1HYJh7BTVBB6/AFjDU7QHtB
	038+5vT36UQDrsvffPegV7gt/CcYqoaPmqaOaDtpX1UCBx6Gf4Rg0LlrkVlo15WGJb09vE
	Eug8xkDtWjEtIhI+HjwMvuWdoqPSCXg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mCE72nMn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772133007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0HVRRuTL2YHGXqmEhOuxE5ZpZN9MWjJ25A+GvPVlGI=;
	b=7Kp6tDN4Q0c3+r8oHkCUz0MMOfAsct84+n5Ms+jCqIFfmdkGY6ejDA/aURc+r9CmqltyqL
	YTzunEsE3XenAGAGIoQIdyjlJVsD/QyrNFOHRO7OtHfX4m9SYJ6ZRLnQuD1WWnU2b/lFQd
	lHZMP6yUZpvNZUlS84fVsz3izWtY1E8=
Date: Thu, 26 Feb 2026 11:09:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772133005;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K0HVRRuTL2YHGXqmEhOuxE5ZpZN9MWjJ25A+GvPVlGI=;
	b=mCE72nMnTsSWbcn0ozkeFmQefohkVGICbEOU6C8Ptn00ccOi7CLXHLxxnP6inRb+oE0J2H
	bSWmt6dvPi0fQKBSIlbNcN39yaYT0XJRe/ZGe+GOsnJcjCAtJKLqRIqw/xqFwvPuDXw8sX
	YgbX7Kvqo2leZ8InqpXIUktlGxkkyqk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, kernel-team@meta.com, 
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 4/5] mm: rename zone->lock to zone->_lock
Message-ID: <aaCacJZDka_cp9KO@linux.dev>
References: <cover.1772129168.git.d@ilvokhin.com>
 <1221b8e7fa9f5694f3c4e411f01581b5aba9bc63.1772129168.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221b8e7fa9f5694f3c4e411f01581b5aba9bc63.1772129168.git.d@ilvokhin.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8617480003
X-Stat-Signature: 8yn6h68jij4bt5qbjr8q4ajxs7xesrsj
X-HE-Tag: 1772133007-525433
X-HE-Meta: U2FsdGVkX18A4oHeHa/TLxv7wPBVilS39jJFhlPzArH8l8wvEhGfxONKDIXQ/48A+PylKmYMRf03JR4MoI9i7Od4TX4gaMD1qaPxH2owP//1dhKemNuCaDwTjS6mT3NVcQ1yZvigYa6xXRRbW3m3+pSEhUW7NosqLYJVrFWud+IvoLGLQOq01Wrf2o220yUraYeEwVMiyR7yt1WH6ffT5XL858M8Q6D5a8sDHZyMJpeKvRfPnLVbcHwStuZqdmY2alUPey28rK0QOAQDYbunNgpy+GsqzCjLkiXcjQqbY4PgZnHhFm8Ft//BXqkHlFS4hDO3DVSh/pmC0RopUG0gXGmghsJEcx4UJelKZcLBA8FMYyKS+RCzGFfqLutfvrCHQfJoVzc8DjwtvgeOiIZOlF1C5A+V1TxeXy0Dj5fqE+fKGlHhGhb6q31Su6gKe3CzYKBmk2aqftBVTUlG0BmozjGBglGxxNkJ0iLdYou4DjkpSZQ0pBbCO01tl3jwGYfjmx5ZjkLxTuKUhuD+TZwcI0L4KRObLTeY+CwICUvf82WiM36QiaNJ1soC+cCFjJ29O+7qGfDIWovG57wN/gp8lGTLqKl0W9+VL4bOgta1Eszq8sMw6i1Cf5kcgJUKkbdhCJveirQJlwPb52bMAzAIl+/rTRrEICYDIUd+EKZ2d4clSvi7lNXF4clSTeeh1dZ1lOSpiJM3h2xvSwQ8KcspboqzO0UALG9kvitnT2cJFDf8zBfD2wGrJj3DuXumdED3TXnFkF191ZgasGnPLvAgfnxHBNqiPNIL2m4KvnbcEZkFGYsYBBGG339qQ92b6yWc6jYcOLMSaxOFi+sPQLFHT24Nqh43s0UC3mkWy+cWldOrOWvEMaSL+KPA6yljq5FKcM1n0ZK3R1f7XKHL8tw3FWr9t/eflq4FdLZK62xA52s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 06:26:21PM +0000, Dmitry Ilvokhin wrote:
> This intentionally breaks direct users of zone->lock at compile time so
> all call sites are converted to the zone lock wrappers. Without the
> rename, present and future out-of-tree code could continue using
> spin_lock(&zone->lock) and bypass the wrappers and tracing
> infrastructure.
> 
> No functional change intended.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

