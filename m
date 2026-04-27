Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A050AFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E767D6B008C; Mon, 27 Apr 2026 06:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E279E6B0092; Mon, 27 Apr 2026 06:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64786B0093; Mon, 27 Apr 2026 06:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0A5D6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:46:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 799DE140156
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:46:57 +0000 (UTC)
X-FDA: 84704008074.22.57DF574
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9B934C0006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:46:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="sNpO9h/9";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777286815; a=rsa-sha256;
	cv=none;
	b=fq4Ry7D6nxNtbVprlTW3nlH8gNgCAzPelhjxyf0Iw3DVRKNb861uMWUYdbuND8gXp02ldz
	1KMqb0qXX3Wg4TPL4sGUHDHT/U0o0LMzCvd24jQ7uHW0CtmVr4nqxSX53/68ZwSr/3sYlT
	B4bQF6V6+VJjmI0gL2SfdGUxNVi2Y8Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="sNpO9h/9";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777286815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qkqd5577qOWVmFs855Rri+PBuTTAC7A+V7gxCc1dWAU=;
	b=2U5DMaVYvq84ix6r72ww8uw5KLm39JRKjy9CnfJhlUkhk5X2EX2149JFLZ/MBZjj9aYU9A
	NcWyeyBGPodj5s9Jazt0EYchKK1r50Iwfx+hhLVjSMBDwhP2+oPbYIYLTSMcKl2RU8VWNA
	bg8Ue+unpKuviVxww7feEpdc+yLYONc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00BA81684;
	Mon, 27 Apr 2026 03:46:49 -0700 (PDT)
Received: from [10.57.90.199] (unknown [10.57.90.199])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9946F3F62B;
	Mon, 27 Apr 2026 03:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777286814; bh=yHwZa5L0DExubL5EkNpSY80h3M2317iQ9ov4eqkDKo0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sNpO9h/9vTxRiecbOJcx8vEpR6HT9QaasP/dwA6TjUdcIyMk018OVFzOcpRPsQbmC
	 VjzHUUMtPe6m2MeIItp4MNHvTsWSnXjN6aDmwOlteftMoGhCdTowDe9r83dwokHfam
	 rUUjflPHU0Kkl6BL6mtX/276uoVvCCDcoOv8GXuU=
Message-ID: <6cc83a53-4392-4925-9187-d682b60edea8@arm.com>
Date: Mon, 27 Apr 2026 11:46:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large memory allocations at LSF/MM
Content-Language: en-GB
To: Matthew Wilcox <willy@infradead.org>, Kiryl Shutsemau <kas@kernel.org>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org
References: <aepANOFKoA4jn8NN@casper.infradead.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aepANOFKoA4jn8NN@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w6gibbgpe374bu7ydonx9118ec8zzitq
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B934C0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777286815-874078
X-HE-Meta: U2FsdGVkX18JO/YPiL6f4c8VLnyxTHHF1wf2FX6KToOB3rc5HJWpZfW01klLRwz5q7nSoYbNA909ijoLSdD8JWzWWinz87uSP1gFEkd2FHeMiyF78h8GX1wJibQQp5rpjS+768QTEeEZavX3CX+8IIJF85Hqmxd7hwRuwLNCxgDRR1gSbWgLUIIuLNaZzDSK0TFQJUL3WmhK3LEFbm72k3/p2br1XLu8TW/js6Ab6sVMqX/BjOOKfiJY0jN9PYpNdFWranpUVSZTjnbrXES4+I9+TCIK7h/ykQVG29x634Tz7yuMpW8I2+hsecTseafilzfJsPPZBFyafbleBP9n9Dxc5czXEYQorGjYKA+cn+NDSdZSDFs/F/W+e0ko/ieupxVDntefu73gvZNA/cS/aF6C+GTc7sMZYspdoDsrAJuj1tyyz0jGwBV4hKah9WBex+oPXMWnplizYLWpG/URMIWJwaEJ+zPS/kwfgq0qwwR7ULE98OU1E2nzKmuxmlXP2bycU42w5u37a8Jc4Uris8aBqfYq8h1vkPosP/ZOnOLHznJzG2xPPeDZTj1XssL4uKg1TQDH3J/leCNCqgx1/qnpXoEjW7rVOEjvqbglp+qVb3bmc65+J0xKgUIG1uxmlue5ntQII3o34oQkM5RvZq+jG6N2TC6o3AVVc23EJyuqdFPQev8LNd2htsrY36XEofTTAI8e4Wd2q8V7m2NgNe7tfylTCYbnIgs2rXv9gPUyuzle3g7WLTBSyb5u914CMM7zXMGQUYjJB0J4SAs95slirWFpd33Mb4DjMly5JCwofCZKHNFSzHbi4yYbPcH99SEvbp6KcUqThEjih0mdNbpY5LC1cB+3I3RBJZjguXLlVdGQ4rowhPGRDGhLxGgLK+WUW1uprrKRryMkIqdFcFf/dG5KIn3wLe3eClZaIxt+Uz0+lenyLLvFn2Kg3zCgPduAiS7A5Kc1VVnh8cH
 TjwaHlmO
 ya91fqZJHmPKV0YzpSf1tKfOV7xc3cKKfROlwkXq9gEBWcOrNewL2p+Y4pOKM6PO2SHlsIbXLGgGogQtBApJVVUtl8TPRm9jHGnkN1kowEjW9kRVbty6v3gS9YRhB3EgjUCMehcusDFD18YWlvieR8xnItgLU6iFrRta0kco3iuGFISaXwzlzbjINto7y2N8KPXl3OdLQXRTU/ywVo3/MOjwSzE9BZxKPOFL5lgDDwFM2W8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23/04/2026 16:52, Matthew Wilcox wrote:
> We've had far too many proposals for the MM track this year.  In an
> effort to squeeze in as many topics as possible, I've currently
> scheduled your three talks into a 1 hour timeslot.  I think there's a
> fair amount of overlap between the topics and we probably can get a
> decent amount of conversation going here.
> 
> If you feel you need the full half hour each, let me know and I'll
> try to come up with some other way to squeeze something in.
> 

Thanks for squeezing this in and sorry for the slow response. Yes I can make it
work in 20 mins.

Thanks,
Ryan


