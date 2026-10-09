Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60E34CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 12:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50DAB6B0095; Fri,  9 Oct 2026 08:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4A86B0096; Fri,  9 Oct 2026 08:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FA8D6B0098; Fri,  9 Oct 2026 08:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23B9C6B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:01:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB0311C37C3
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:01:01 +0000 (UTC)
X-FDA: 85302946722.11.6D064CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF2901C000F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:00:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WM8sWNy+;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791547260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtDg7zGOUdMGLv/ZahPOgjjgj8LdOaLD/DRMIGrkAVY=;
	b=fmviOFyqxCZzTJ0HmuVVCF7HWNnFw/tZElkWqYR6c5cDrdWoQx2g98aw+FWf0Uy4B22uZ6
	WVWDHrOfi8bV0c7IV9IyvcpVShamUHKpf3IJUAirR5UHZyX/2fG5eoChpuqsvw/BZFx7Z7
	rYW/5MA45jNT/VMqxRTLY9gyVoE6mV4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WM8sWNy+;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791547260;
	b=ulkUhl1IQrRBzEI2Sx1m6b3XeY2jW/KG13wYA6EsKk9ttvqHoApXRteG9435KawlcEw6mH
	kSPXkFi1Ip3pdQdLWC/ta6g6H6l2z4cYkKp2TAflvXl5+UEcyYoLdjuwSSB4gmy9YtVaE9
	B3Co14vwc/VyEKWL28E2Ss1PZPg78rU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7DC240454;
	Fri,  9 Oct 2026 12:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF821F000FF;
	Fri,  9 Oct 2026 12:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791547258;
	bh=PtDg7zGOUdMGLv/ZahPOgjjgj8LdOaLD/DRMIGrkAVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WM8sWNy+t/arfWSPsWRfTo7XmQhCgArwkS2Tc0vcFBAHtCEVSBQx05PqE8cKbCUB2
	 9KlAxBbJAMhG6YjFPas0TiXTYnEsCR/gplgrCn574V2HuRRIc7ZuJqDShLXNO+wfDh
	 c09VAoR7Ovm+PLntCBtUIDjzMy//IXKHrPw22nVVRi6q6UdJd+bzmBaU6KidkqZi2x
	 Lx6/6kFrhAJ2zDW874gAimMrfnAr3/D9d2zXDQKNbp5qLgCAJzk6qD/pgbZpl+WbyS
	 ctq9FUBYpbyfNrD7vY6DUeF2Fsb+kjFw5kaim5GSKtDm2c3s4EMQFoKqgfzVElbBbk
	 EHLHxVpsan3iQ==
Date: Fri, 9 Oct 2026 13:00:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	qi.zheng@linux.dev, jack@suse.cz, pfalcato@suse.de, ayushr@modal.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: memory: fix truncation removing mapped folios
Message-ID: <asjXJZap53yJWMYi@gremlin>
References: <0d2a1809fa1cfc22ad3df26ec28b2d30e5cdf3bd.1791540483.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d2a1809fa1cfc22ad3df26ec28b2d30e5cdf3bd.1791540483.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EF2901C000F
X-Rspam-User: 
X-Stat-Signature: 6woebrkp6uurfd1hmygiuiep3bqg7urc
X-HE-Tag: 1791547259-323978
X-HE-Meta: U2FsdGVkX1+4sna7jf2a4jThy8M5XbRUoZsdH7COLeeHszmrdnGcmIcQBYV4bzWN8kSQJrxMf6vguQso8GLGWi4obTTzuZf6Av0rmM9BDnNS73z1zHDh9WHUIVdwk3EZoyA1srgjx8FDY83mtjX/zjQGMZoAKW1atzxeg1meTQRPrAVcYtw1/LSMScojhZk8SA3clg85IdHpN91W35ESNcl0NLnKB+HTLwodZ9+g8T3O9iMhTEy/PpD22xqQgowezqGYT2q87t/bsoaTx9ZseYBgnTToGYcTxUF5uohIM6WMoNKw+Z9708N5fut9CRJEESYQiGvpCk+OsrkQr4D91dnfCsQ+4PZ8FUZQDMXwfwoVrLJLjspp21H6xXEyMtJ/9tCmPOJDMEM3R/vj1z5gUgWomJ+AHFriB0Vfm9s54UGMq+ZN1nZbPIsWVuDQlGcrjQpKYmw+Z/rjfIb6U9B3LhMrAK4ryETDg/LIMv2jAnwnfvS+x9DL1LQjJmS0TNSEBhSG+JCQyCl6C1IRr3a2vNMzE0DNGfLfS2qzZKWU4EJols9Jgf51IxQFXwebO8gJlr3/J0SSG3DiR8IGmYaR262oMZuHmKv9bUXZpUo2bnCzmDwHhHFIVgmYtgXlT59s39I91fs0SOa2q67CQWY/EWO3l8l9XrVjfF3+fDMVfgzQsGNYBzG1Idgo6ViigBZ3oLVS5wdszuG5NBGfCV/NpNC+Krvm6kw7vLjpWoopaI/Z9/4PE35NTNlU3BZQfAw0RLxGl59t7IyzWDG560tUzXxz71iUTRDmTyrdquNm5og/Oyif5BUouu0z9A+Kgcs7fi9zfoCOxoEYtYENddtrDDwMArkHXXUYm+UhumJ0gmfeOP4vbQLJZ+vWr/c4TabejjYpttrI++2WEjjFzb9irI9p53jZ7ws2EC67osLHrqXiO6pJrwjOQnOfOkAywQ7qLdAzW80fcIpLu/VL8fg
 sIYDkUeP
 0FAFvz4U8RslSbQ0vLcwySw8Qmozs9n8MK0ip0iTkesWPyK+SmbOvl4rzNUaP0BtulUjTgXMKBPP9MxYw40ftkJoH9LQ19VGKLKtQSooCGkRLKE001+rmrNm8nzPRuXDK6ev07BBGwWP+pAeQhSOggqvIwYMwhe4uddGn4f8dDlwn4czaNEloxQoACbe161sXC7tPDi6HYrWvu7uEBrVWvyCPSLNoLHxQkIoHPTbDoNFcKzFd/wU434nTxz6dQcDQR5ie
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 06:12:03PM +0800, Baolin Wang wrote:
> diff --git a/mm/memory.c b/mm/memory.c
> index 1f5d5f7d39cd..0272217ad7b0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c

> @@ -2044,16 +2053,10 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>  	 * to ensure they are still none, thereby preventing the pte entries
>  	 * from being repopulated by another thread.
>  	 */
> -	if (can_reclaim_pt && direct_reclaim && addr == end)
> +	if (can_reclaim_pt && direct_reclaim && addr == end) {
> +		/* rmap changes need to be observed before e.g PTEs get zapped. */
> +		smp_wmb();

What does this pair with? You should always say what in the comment.

rmb/wmb are generally not needed vs. acquire/release. Are you sure a wmb is
right here?

--
Cheers, Lorenzo

