Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8802ACD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DECE56B009F; Wed, 27 May 2026 07:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DAA6B00A0; Wed, 27 May 2026 07:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA646B00A1; Wed, 27 May 2026 07:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF53C6B009F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:28:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A7BF120573
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:28:36 +0000 (UTC)
X-FDA: 84812977032.02.DF50DF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C2BD0180005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:28:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MeV9Y1G0;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779881314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkbLuAJPJrT06BBu89RuXsT41mMoQgDPpRgE2ayU82E=;
	b=hL8Qs3VZFtsx0yOAHS9bKjLozsw0oL7j8Jnp7AEvffedXJ5OEc0SSxf6mIBB1lALV2o19m
	+0r9Aahe6P4gGcWnH0kQ5PIjcNFfF3rPU3kmBWGF4WCtAmWf7lTKDm4xVkFNmAFXmfctwD
	tXP7YzaueClr1o+ZGsmeYzdAR9R1KOE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MeV9Y1G0;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779881314; a=rsa-sha256;
	cv=none;
	b=WTrzyj1bKxkIyqVdvgqaRnZdxXAO1SSq1mM7vbfVtIh02Fg3uu+PuRT/3r7XRBrJcIPd88
	bntcjJhiGGoG3BpwTcac6gQUYc0AIVpo6lst3SgI17FAAMQ7jrvhYhEKZtVar8E2Zp7xaV
	AdQ0rGsN3ui8dJafnlaIG7TWgoHEB8U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29622600C3;
	Wed, 27 May 2026 11:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DDF1F000E9;
	Wed, 27 May 2026 11:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779881313;
	bh=qkbLuAJPJrT06BBu89RuXsT41mMoQgDPpRgE2ayU82E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MeV9Y1G0LN5n4Jz8wW3a4vKTtvObpLFQ0aHJZNV1TRbD9wUQhBbTKEIxuiW/8wRyo
	 i6VbKz1/SUzUlEkll7Q9rxIYRW21rAdLHe+Xot+Z8eSkzaMxP7890+hTiatGkpLJmY
	 3wEtWvsKqO6yUS2LoQ3mzGZdROpbdHze2OiV7QTWfALAZhyDUsVRoxinUCnI5PmcuX
	 1g1wc1BPDYqnGu6W9hSOkrttkc4v0CtWpPwQK2WFxAYk8o0k3GFGxXqJEpCSQnLDEq
	 60HNzLTeki4QAdzxp2hrtncKUfrjk89ez53g5LK6eLG6gO0lhN7yxE4CJomYYfP6gH
	 P/XLXzUWLq+wA==
Date: Wed, 27 May 2026 14:28:26 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>, Li Nan <linan122@huawei.com>,
	Xiao Ni <xiao@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 2/2] lib/raid6: use kvmalloc() in raid6_select_algo()
Message-ID: <ahbVWp9L7ASV6zOL@kernel.org>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org>
 <20260526-lib-v2-2-ca3f0fc24b14@kernel.org>
 <20260526103424.0d884374dee8cbc4f9f17c3a@linux-foundation.org>
 <20260527063814.GA17042@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527063814.GA17042@lst.de>
X-Rspamd-Server: rspam12
X-Stat-Signature: j9xwpffqm7dcrmfuih1mdogd9u5pitj4
X-Rspam-User: 
X-Rspamd-Queue-Id: C2BD0180005
X-HE-Tag: 1779881314-56463
X-HE-Meta: U2FsdGVkX19elYPlkmclaGlNfuWX/UP++usKavnp83m5UJC7pzRyU4qG7B9uelxYJlL1esalFuQfM9vw1wmb6oF9aYixV+HeWY4p5XnOPOhx8eSK0QG5GfwzXcSbwoy2C0Wkt97kfGxvap2V5fXDQu7+/jEAePGpuqjg6iQfQsNKnWPF0j6Y9GsMz22A0PH7DmLA9wR/vQqYizUL/aD4S3+dc4OToKkwiEw0Ip5l33hnblYQmyJMW0QwDeN0m48RCDOGDqsUnZR+xNBoTje/xYwnczsAAuAzCKuImzNB9iTUD+13yUUxIxwJuHblVU+0Gms4o9CvbYhAwa1KERTgEQEbT8LotZlqLpszZQmW0gv/H2y5Sz+iC7S+EDURCOF6yoZqlRcZd3EhIVIaVvtPGeq2kWgjai21wD4yGfnM9XpQRs16q6qpCfBtNNwDgSowkVdXU95DWyr9G7BCw4Lmg2Wx6JXa2PmHXvYhOjYbe775ejv1vG1oDjJ2dnszoeZ+Ypk+hsp87Yiy4uTwCy9tNP1RKsqCkYYhESkK82JgZIy1BeG8TuGUR7InB4cjVMZIEwqF14lnf/PadxtQ0YZkMmyqUo64+GJP+50p591F4WVh9RDwNWDWh4O+wMhseRN9nk48zEBwHI4263VDu/Fkn2FasMNFjLLaCShIwPzUEe+nMBNg8i4CVwt+UQqG/B+VCkqPkeFNrWGiGq8/cRuHeG00x7xPSkMrpZetuPysuKc05OfPEUmeZjw8bs4k7SWyOyDO9WPxTMysp2l7ug22kcbE5GYJebfkNX8VE2GL0lhXGr7nz894Ja97zFBk28S3JE88KlT/RSg60tTjHhw4caq7vtOwH1P9RMQxoLL/waLbn0AakEewWUJkKricsPXESNNVaanERCmtDkz2kH7Qg/UO7K7zVJmvc0skulbRH8Q1ZVANrsBsGAMFy9487p7H/PKYSxREQEA6G86Xbm7
 wPwr6lrQ
 DVEgBl+AJPJfHi93aovECltyqRFq/ExCeKATKL4rFDQJbPIBGVGMIoKU3iBEsfNYZjC/GIxug7EQPEQFtLI2vBgDLuVLWIFAaE0aCNtB1eIviM+TV9ehcXnxj8Kf4Z1x0vIzSGNaj52TfjgBgUp4R2AylxJJ83JU9zf8OKxd+yvxsl0JKCXSRkYVwyiI+U49Tm5+0Dt5hPF2n0OS+ss9vgGkvQ5U7WvCw8EWxS8TcT3PYhaSMLErC81AniosZixS0hVznYjZ1M3X9BzwGxq60Vl3Z0PNsy9ubCcafjkeNnfOZcV1/FOZL3JmiiZsL+beWj54mNczSH3OhJfbtADCS20ulKZ8R5ME55Wq9yzq0qvWI4IKjY98FvnD+Y0tQ5gCNRqcA4QET9oRgQCcGwxGPTCKShFvHtB0Ls139
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 08:38:14AM +0200, Christoph Hellwig wrote:
> On Tue, May 26, 2026 at 10:34:24AM -0700, Andrew Morton wrote:
> >  	/* prepare the buffer and fill it circularly with gfmul table */
> > -	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
> > +	disk_ptr = kvmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
> 
> This changes to vmalloc for no good reason.  It also doesn't use

TBH, I didn't look around and just presumed that order-3 allocation is a
good candidate for vmalloc(). 
But given this runs early on boot, there's no real reason for vmalloc().

> the _array version for overflow-safe multiplying (not that it matters
> much here..)
 
Can do _array if you'd like, no strong feelings here.

-- 
Sincerely yours,
Mike.

