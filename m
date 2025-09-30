Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E3CDCCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 18:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93CEB8E000F; Tue, 30 Sep 2025 14:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ECBF8E0002; Tue, 30 Sep 2025 14:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 802BF8E000F; Tue, 30 Sep 2025 14:43:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7338E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:43:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BC661A07E4
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:43:15 +0000 (UTC)
X-FDA: 83946789150.28.1029318
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9722340013
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:43:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=fXL9i6lG;
	spf=pass (imf01.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759257793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LA1zHS4ppZRh5M6cwwSBzWIxCMB5psoEo4mhhfJ1HxM=;
	b=0cxCFxlk4S5FiSK5GHf8UAzMNH13rokJS9ZtKBNVt7X8V1fT+lDWy5SgPRsC8BDD1LyEt4
	gSAIknNsIrK5DFAl5VajEJIgmTIY59eazBGSQGsRzghlCXmcFpd6ko72Mbr+ieaHpcnp66
	XyOjUDtgkAVZBo335THj8+cDY4wI/04=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=fXL9i6lG;
	spf=pass (imf01.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759257793; a=rsa-sha256;
	cv=none;
	b=nZnaORKd17Inm3/RM3VOrwU7G5d9inR7kJ3ZImvtCxVIuEbKpvP9Npa7lfSkItYBti705+
	7vMKRCMnZgpmD6MFa9Sy1psqXwi4PeERWssYJH6Y2jWSdF/ADtGJN8q0kLB3i9FQshG1xo
	pzc9DUOZYvG5XJ5S88bxC12+HYA8AE0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1759257792;
	bh=LA1zHS4ppZRh5M6cwwSBzWIxCMB5psoEo4mhhfJ1HxM=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=fXL9i6lG8VWMAVmrXoaaX5p50VgGLRcXQoH4aAYQfRNXTYY+nt2g0u3Ak4P0aqcBj
	 ob8dpqIxXUZk7H0BciB5FbB6J+cUcBagNxkztKMJOSh1y2P5Ye9yiQsPAQKTu17I8J
	 ls4aot+054QGye8fUmxcqCd7tiXRHgN9iUJu35Sw=
Received: by gentwo.org (Postfix, from userid 1003)
	id 6CCDD402AD; Tue, 30 Sep 2025 11:43:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 6AEE04028E;
	Tue, 30 Sep 2025 11:43:12 -0700 (PDT)
Date: Tue, 30 Sep 2025 11:43:12 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Yang Shi <yang@os.amperecomputing.com>
cc: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de, 
    david@redhat.com, akpm@linux-foundation.org, catalin.marinas@arm.com, 
    will@kernel.org, anshuman.khandual@arm.com, carl@os.amperecomputing.com, 
    linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH] mm: hugetlb: avoid soft lockup when mprotect to large
 memory area
In-Reply-To: <6cde8290-3aa2-411c-bf29-eb91a99e33a5@os.amperecomputing.com>
Message-ID: <ef139940-5627-13a3-747a-b030b11e7544@gentwo.org>
References: <20250929202402.1663290-1-yang@os.amperecomputing.com> <cc40d827-3b98-4e15-ad45-5c2033e4ce20@arm.com> <6cde8290-3aa2-411c-bf29-eb91a99e33a5@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9722340013
X-Stat-Signature: jcbfnc3hgczdcwsimrhzpc33ez63dpx8
X-HE-Tag: 1759257793-508410
X-HE-Meta: U2FsdGVkX1+jbiLWWjbLFo4/VA1L4nCPx3pGZ0C+AOA3MB1EbFVYtVKMJepXw31zyisHIqqLxSqsWLafuBy9wMmIFxZZTtyhp2Xp5Z3Q7XPIdl/KpKKIaOlLseRxCSTLWSrUcxHq1eROeuuP/xEwu7civkajbwOZX+YqexAl0EwBJUgmuPDHwLYwW15k1n3ipQV2lAZzGzIy82O78EOrHv6A/jOarzGm/CSJfHTgOEGkB2Tkv/vXu/yZnBjUdhHgQpeFmEqRGB9qUUUaE+FQ2akDnabX5YXK9rZdOodhpkirHKdzR7s5Er5S0LtkffMY0RCvKrJtaMPFvct2u3JF3BB2ylC/crmbRhIBpTSHoQlu3GuT5+muQmS7bOpFpSGEy+QL+z27RFXQsd4pj7T8H9lH7fFlXYVrpMHq3seZDYnhocpObpiKHz1cag4nXksWtMtgvBMYObTqWGl7DWCLyul0J+oBBvwkVn/24w9ycL/BfP5KmQtTIsRLcNcbv2cDnKO+44VCPo/+Xvzl3iHgTRsumxaSq4tFiaXR0sOkzXolocYkVrka4tijgd1Sm42YP85qi5kp51XV9eiDXr2DR7rQvJp3tKCkScjJ8UK6BsPGxdSrbpMoTe9qL9Ou3EVUz8I0XZFgItxK+lSJzJ1vwDVBA3vleGGsP7K/CosHc8mDLAZoiOaxF1ViQeMJQPnfn6F1+dM16ZYA7R06/P2h2Yfa0nWz/3UvPHoFYT2QFKj8kes9PQqcEHLx0QD+APh6LFgzCZG9aaTp02btsWqZzBbhjJVcVQWNEnTzaayO3eflEW7CzZ+8Z95Jz1/EQNSbsvgTWRYSckl1dir4/It18LYYG2rZdQ3AisIXXE+0Ag78tnIQb3KmmextJkxwNwYC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Sep 2025, Yang Shi wrote:

> > Does it make sense to also do cond_resched() in the huge_pmd_unshare()
> > branch?
> > That also amounts to clearing a page. And I can see for example,
> > zap_huge_pmd()
> > and change_huge_pmd() consume a cond_resched().
>
> Thanks for raising this. I did think about it. But I didn't convince myself
> because shared pmd should be not that common IMHO (If I'm wrong, please feel
> free to correct me). At least PMD can't be shared if the memory is tagged
> IIRC. So I'd like to keep the patch minimal for now and defer adding
> cond_resched() until it is hit by some real life workload.

It would be good to send out a second path that covers the other cases
for discussion.


