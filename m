Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66797CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 22:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9111D8E0006; Wed, 10 Sep 2025 18:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1D88E0001; Wed, 10 Sep 2025 18:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF1E8E0006; Wed, 10 Sep 2025 18:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7DC8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:12:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FA5B856A0
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:12:01 +0000 (UTC)
X-FDA: 83874739242.16.1270615
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6692518000B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:11:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=HN7NMBmH;
	spf=pass (imf06.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757542319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2XfMsn/kQvxkkwbZCPxAw0S6mIFheDFpKhQTDF5Tm4M=;
	b=FiiUgJYdBO+ernn1t/nibxFsSyP1a3UQsufS4Vm0W5SuhuvCC8jYUbPN3ZNhnzRURoZPRK
	IxSnEdHw9dnTWd8mdQ1mqVhyaFJvBY3WaSfsTXrbAv9cE2MIh2ouTiJ5gTCoQ01hA05hQH
	gL63MNK6BCTGXs+6AXYXoS2wCiItIT0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757542319; a=rsa-sha256;
	cv=none;
	b=z7fpTcnnBn5C3oK0yhD4P1DW64gUYuM15J08QEjtMPRaXQqNkmyXt2v95AjN05RNvljrXg
	SWOQayVKGYAI7qJnglh2x1JJlXWenjqE6pvKiOghWDXtqLTnPXxdFPy9k1ZiEiR4bn5CeV
	WQ56GQDz/fTJDoTqS5STz+tai3ExjpM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=HN7NMBmH;
	spf=pass (imf06.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1757542318;
	bh=2XfMsn/kQvxkkwbZCPxAw0S6mIFheDFpKhQTDF5Tm4M=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=HN7NMBmHvd2erkyFV2sQEgV614/x95jLSjGzEuMcYY8shi4HtOAsJhiJ6pSrMZOV4
	 jzK7Mua2YTdUFBIg5WqWi15n1PAzVhLWFXz3xY2uSblQp9r5bh+y7TAjfV77m0StOn
	 FDCgiQcf5b8HaHo5NiWHvXaTPVykh/va9zVvugss=
Received: by gentwo.org (Postfix, from userid 1003)
	id 0D83F4033E; Wed, 10 Sep 2025 15:11:58 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 0B23F4033A;
	Wed, 10 Sep 2025 15:11:58 -0700 (PDT)
Date: Wed, 10 Sep 2025 15:11:58 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Matthew Wilcox <willy@infradead.org>, Harry Yoo <harry.yoo@oracle.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH 03/22] slab: Remove dead code in check_slab()
In-Reply-To: <d82c935e-1569-4ba7-9e9e-13b22dc2e4e5@suse.cz>
Message-ID: <10360dad-e168-8e95-4ea0-9071702a540d@gentwo.org>
References: <20250829154728.3397606-1-willy@infradead.org> <20250829154728.3397606-4-willy@infradead.org> <aMFfLqkXcZTNv_p5@hyeyoo> <aMFjYbaUaQq1GA4c@casper.infradead.org> <d82c935e-1569-4ba7-9e9e-13b22dc2e4e5@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6692518000B
X-Stat-Signature: r4y71ghqsetfxet3ip8by56485se8rwu
X-Rspam-User: 
X-HE-Tag: 1757542319-706291
X-HE-Meta: U2FsdGVkX18pxSL6v6XOsNtOQm3hyBmwYZ2VFr2p3JRPyGEGSo4xXcUHiY0UsUU3TBGME04s9gIHeVV7iaX3ZWPCS+eMLcKiUzABxGNsQCGPIOGz2bucmAFJl67OZ4mYKxHmRaDmHcHGqTJqOinP6sBtUC2Pkr1+oW6su8KgFGPMurTBbrVo8XS7FOFR0WqaBSqdOgjEIq6ALkEtbDqUJQxoDiOPABiq6D/ej8AvacBxfV+j6ATf6U8SlXSL5A4OcKvRjcup2EQ+uJeF0snUnqvOu70Q8DTjjy0etIg9zULfE0uM/IzV0WSMa8X8QWDGS5Ha3TuHeEyppj9O15oDndS4CyjPY75XTc/R1pF6ZFltk2CwB0GicT1wSneRSm23SLupyncWyL1KnSdrHmIw5Oh6CuLizxnaWn+sFNyqpJcKEM+rZeh055zFeleDOsPvoGoHTAUrU6LKjbmQgTuA44sU7vD656m+ax4DRUDIc3qYYFpyznaY80UYRdpBumhNHqiqFRurx/TjGesA4eu6UlMCWsdImbz90kfMe3CLVZH9e4deyurZzBM5CxVFrN5NigGy7iyGzlHPAQ9HRDv+Yx3wg9w3jnz6yXdn//pxXU4vVF9073OtfKQ4Oo0wHvrjAVwgWYvsJexpuZdsOAxya1Do7mz6rnIFqSimy3WEhz60hTL6Ds94GujaB04Wx0s1BDofN5+DEpvmCydVOUFL6HnXcNUMwSxj2YxycbudhI7MGzdnRh+WHx2QiBomSYe1y3L77ewjDf0XMjAeRwQ4zYQbHMLbF0plqMptFsmYDmfmWfp26FktxltukmrbFbxlvaBoOFjeuGeBqBUfsxLFyDpoej3GKKo93ukH2Vvy7pM54ZBX9mN/LJidE27FTqsfjeXn3XpOsRe+OQ/GpZS1/jm3HmAqLzsO0G6QVsPVrvFJDW4Yl0YAOfxWlwXIQIceXeTKNfsqcJy3ZeI4BSQ
 WA2psdQS
 /xwU9WL1791I4YAMQWhQ4NePJ3PqQ74A9f6ABoTWfw8TP0Z/rKIn3ukDbtF2QitPV4zvjQnNtwiLIJ31fpv4dS479cmvf+fpBn6bimKOV310NujG29mxqaLyyemUUk6C3RaiX31T4YIqC0jd/xmFQvL/eWx7UQFII3Rs5Rs+LcyRHiphUAiwUSi5adUc695VeU0U2jrfCR8yQUE57+tiX36gKwAZQzES9iWpeYdAxE2Qn8x0/VSes5+WxKKqiqTUllnMxx/lQHkoD1SL7BojgB/KdTWVSaHuUsGDC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025, Vlastimil Babka wrote:

> However once struct slab stop overlaying struct page/folio then we simply
> can't have this validation via page/folio flag anymore, so it's fine to
> remove it. Maybe there will be a different way to reintroduce something
> similar in the memdesc world.

Why not? The partial list will continue to exist and the metadata of the
slab pages needs to be in order regardless of where the struct slab or
struct page has been allocated.

validate_slab() checks the freelist of slabs, and the metadata of each
object in thoses slabs and does print a list of inconsistencies. It fixes
issues with individual objects and freelists in those slabs but does not
remove the slab from the partial list.



