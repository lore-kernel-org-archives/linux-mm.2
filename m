Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98754CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 02:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E27B68E0008; Mon, 10 Nov 2025 21:40:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8578E0002; Mon, 10 Nov 2025 21:40:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14CB8E0008; Mon, 10 Nov 2025 21:40:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE2D08E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:40:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50DDC58884
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:40:08 +0000 (UTC)
X-FDA: 84096771696.02.DC2DD3C
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id DF09E14000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:40:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fO8JImOw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762828805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xSYbGmkOLF0vBeTr/9wqYidF3L9zQmGvCy8e3mct3rU=;
	b=5xPFP2xYSnANKCmLWrPawku7Xy/GLVmZdQLj6jgeMz7Juz638mp3LmIeq52+yMYaUozc4L
	hf1T1fYKanvtYBgPU0+y0lUh+5pkOmmdNQYTCIgZjA/UPJcdb2rn2bJAaz+waFRSKfq4x1
	n4JpF2TbfXvnB/NIGXn/NOAjFLNHjyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762828805; a=rsa-sha256;
	cv=none;
	b=RdeSCypw0xCaGLXRhqYWj65q+UD6icTzd9z+wFTK+3GmtMePgyWHA/yef3HvgXH2X1+B+7
	n3de0eKHE5W2jGIdpV8lMUFtW8fqNf2spZfmEheA1IBO+5ABmKLaUPRAIl9A56CGd7JBIi
	HEQn0sRkI0Y7dlRb/JbfzazYs6y6DKw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fO8JImOw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Mon, 10 Nov 2025 18:39:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762828802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSYbGmkOLF0vBeTr/9wqYidF3L9zQmGvCy8e3mct3rU=;
	b=fO8JImOw2Fpc9qau/X9P8HeEr6rVexPfWTom4x3QUUYiTSGb0SZlbRJCFcQkfBPt7HnyQl
	detdX0w26+D2kqf7jhpwxFNQcoZqXSuXxJ4/aDfmWZPA9wpCwhSd3w6b+MenkiBDSDhoZL
	3emc2QN6Ju3/dLKeippexg4lLGwLMgM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
Message-ID: <gsew67sciieqxbcczp5mzx4lj6pvvclfrxn6or3pzjqmj7eeic@7bxuwqgnqaum>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <aRKKfdN3B68wxFvN@hyeyoo>
 <24969292-7543-456f-8b80-09c4521507e2@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <24969292-7543-456f-8b80-09c4521507e2@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xfxpkc7bg6q9ht7n8q5zzp4br8wxq88p
X-Rspam-User: 
X-Rspamd-Queue-Id: DF09E14000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1762828804-585673
X-HE-Meta: U2FsdGVkX1/qioVHiqbSTCRG5VBDC6V8wphJXqHFO/qzFfWLiP1xy0K3z8FfphGXvyksTv2+pqfaDpqvMBjtmFmlyl2r85W3PX7+eZXvNv85+nRqKdwp/dmYAf12hFquY4d917v4tt0C2XrfkrGNmORFWGWHtbKA/j3J4Cd55cDMoLGabTJ51nIVlj3m+E5Mmreomuvk2HSTTd/VHXwNEKcI+jDt0gbVH2rs5lyMsh8/uAVpNuiNGHcfku/C+vjwOJfxobiz+o5jWB8JO4boi2RMp6tmPxwBV/m3ATszadBOQAFrxG/xhfeVbfxJnpx+R5gJnDdz872mVXwzXJbTdexDJD1GEjZts2FGsZPX+JnV4xrmRvAlYQGF55QyEBJJXe2A4AekBCjdP7+2stpl/lM0uXn6srlEVtJI4jCwu3yFQTe3QOE79Yl6pkB1OX7efcv7t0DQhF3FXenhAjQYsYKTZ5A9kjTuR/g6amdkeamGyTZgAnXk14gc4uHFEU460vXleI9BUz0dYStFv9RWUaQ+6GUX2x3zbeI5y5h5eL1jDj+XUOwrk56il9mS3TtNxUcrLoLZ4wv3EQDmk0gkfjxc/yD8wF8Xc7e1gvFl/lAGSmZU1gT2BlwUw2XEFiJA/LJ1xhB7Io/9uCW3BemQv4tVZ68/584HOP9XM0ig+ce3rsBaY00Wxu5NhwwM8pwV+S9VZ94C57EjnWvH4+22rLKATW3WeULZG1GLofXd6LV9jtuZTKvsEFnKvZQ1RO7qpnj7eKxo6Xvrw49v1BrTFb0iTnwFfSCKZv0ETKMD2hB/c5ZqkQVHzgs40vuODsEaAtr0HtWcfPVXWBp3GxO4+tPFpGjaGpXUpUVuCPCIP3T7jwGLMhZIvlNzDJzDvRHLrDZD+5rpCOliQEzVH9nv2beiTylk/5e38Kt+kgG57Iv3q3vBX8R7/JknyyiX/E6UGjX6TMZyW82fkbjiZ9i
 +0ASnSkY
 TnEIT52GTC/cOa6Y9wCT9fXvJjfUJrS5RuKjZPCRaP3hTly2mFTiPxfbjJqxwJG8UVMLh0hmk8didDzHSNFybt9YJgJXgdFV3uIMvxEeDihRnRBcnBpsvlWH8m67MID3JZh0Zbgzm40R4AcjlSBU99x3ZH4TC4i8vMnJyZIbOMWwWVQ8rFIYbt0xhgyeyOAnwZynFsVgjEwuXd+6/EjQHj2nPouPWYVRqtpDBx9p5Gga+UKc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 10:23:15AM +0800, Qi Zheng wrote:
> Hi,
> 
[...]
> > 
> > Are you or Qi planning a follow-up that converts spin_lock_irq() to
> > spin_lock() in places where they disabled IRQs was just to update vmstat?
> 
> Perhaps this change could be implemented together in [PATCH 1/4]?
> 
> Of course, it's also reasonable to make it a separate patch. If we
> choose this method, I’m fine with either me or Shakeel doing it.
> 

Let's do it separately as I wanted to keep the memcg related changes
self-contained.

Qi, can you please take a stab at that?

> > 
> > Qi's zombie memcg series will depends on that work I guess..
> 
> Yes, and there are other places that also need to be converted, such as
> __folio_migrate_mapping().

I see __mod_zone_page_state() usage in __folio_migrate_mapping() and
using the same reasoning we can convert it to use mod_zone_page_state().
Where else do you need to do these conversions (other than
__folio_migrate_mapping)?

