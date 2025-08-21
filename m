Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01CA6CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 04:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C0B36B00D7; Thu, 21 Aug 2025 00:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1690D6B00D8; Thu, 21 Aug 2025 00:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F6A6B00D9; Thu, 21 Aug 2025 00:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8A406B00D7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:24:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 53AFE116FF9
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:24:27 +0000 (UTC)
X-FDA: 83799472974.07.EF0ADBB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7A9D81C0006
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:24:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f8fCfwFh;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755750265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8rnmsPSWmxS4qqEi5T5wWykmcbV6Cb4nyfG8QckWqeo=;
	b=IBAG8KFuGvrAIxy1bMVkaT+QwmFXhafTHz55sxOjSFKdgx1BXWnsgxJLziTSq3RHSGFyVP
	yKeTcY7qwqTwpSxpCpuAYbdbnSlQVFujUEZYAsVNhIAi2D0BUpn+2k0dvcU4oyA+SjPj/w
	dXGCYRSRXW9OOath4Ro2rdlLo3P9DQg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f8fCfwFh;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755750265; a=rsa-sha256;
	cv=none;
	b=x8z669LGy8XGVMWmtplfuiOLZS3qvaql7H/txoDW8FRKM7+XJfTZe1Z4KCGsCVoBRr9twX
	k5n0H4K/yp+VdkTGPxJJWN6kwDxwJnPntCeiFeA33a+3Db5hCDnHSB1p9pqto0rqr+kXiB
	iUhDE9By8ONcI4htadrx3gNdj2hHjfs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DE1143BC2;
	Thu, 21 Aug 2025 04:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09BEC113CF;
	Thu, 21 Aug 2025 04:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755750264;
	bh=yEbxrMCEYmcIooCbdM8kiby0WKYLYX/mSci3aAy4yVM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=f8fCfwFh4Z1og95qFf//8M53G5+NpB0yLPawo58P+nEJ33AB0QDoMmwRNquGqfk1S
	 tsu4nuflWvmc2k2+b/tD4Yo2VUE6pT7IUR7ZuBev1amEvdmaRaGakAhitSeYTBEzes
	 Yn3DvWs4xjELaW3Hr13oWRpJRwYQUcg2i4cxPTps=
Date: Wed, 20 Aug 2025 21:24:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sashal@kernel.org>
Cc: david@redhat.com, surenb@google.com, aarcange@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix kmap_local LIFO ordering for
 CONFIG_HIGHPTE
Message-Id: <20250820212423.fbac2b17eb4f6a9667a8c979@linux-foundation.org>
In-Reply-To: <aI04CQZZzgCDO2A5@lappy>
References: <20250731144431.773923-1-sashal@kernel.org>
	<20250801141101.9f3555a172609cb64fde7f71@linux-foundation.org>
	<aI04CQZZzgCDO2A5@lappy>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i9ixmsmz1uunz5uic39gyswuk6dr66kf
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A9D81C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755750265-987369
X-HE-Meta: U2FsdGVkX182t9cib/ekamod5TWSbDZJ54YdcLQ4maN1a25nRzEJL2BCVaygA9kEMSgpX4jH3ma/yg+9db7YKkMcOSwDX/6W4F3ZY8L/mGKaEPsKuOH3GWBvzAvWib0O5OhrbISo9o1bVP2A7fm16tBiIxNoNcWUVQxXJmgA+QJb2DUUxUzoFirDf9rcohCRpBdD4R+0R3CCVMy9EXBOc8dY+NR1vjH0ms5mVUVvo6SQGo8/n/0cnpK4s7S7aSNUg3dm7ypbWIsYh+tskYCihbHenyiPJGnGjX4k6kebiC2eTJXcXppxZQ4Y6KIo4saWWmW9ThaKqZhBhy2TvH9Tz0ifQmA+lNwEguHrxY47Ebs73JjGu1nZgYqLuaTjLGdo57UJI94QKGRA9aDtMGTnoZyuxi7YPRrAzfer14f+muL2/Ca0h4xDdUkNQnV1t2y0sBS74Gt3cGyretJ+yGE9TnFxYvsx9YV8IsfUjipOVx3aVSdAZAXGcRpIeS6lve0odbUd0nPpq6DBQTQxX+D/5HS6cKNbE6FrLopsbdu+K5e0YxQ+XWyYef94h/CoLkkPKhjJUrEmxvPzBPFawyn9iMVDpB+iCY/kC+6MpprE0dGFSW1FZrig7qqzZhN1UYfG+O9brISWB2tIwSNo1L0KZ10BM4cjJLPMDColQPXEmPLr02u9seR7y0LUjPZWii6JzGhyWFW3vAEs/R99l/3st0fqG4wP+mkDbrDOPDFZXJDz7QLwAiOvX60qkeUcX+yAVB6BtJH7wQW2orKn0iMhzeLrfcKVE5P+FQlvzJm6Eeo2tVptYn6NhXXXlxN1U/XPj27d3AmHNXXNM3scDe9pEYoRRqXSiCuYvToYIC1MRbQ81YKKBZrsYvaXCTa9/q7W5OSjPLLhaNfIeoCd/wgNIIfemBNvAWOb5CNy/3vRLiSe6OOspRI9jW6Zsk6mhcQvyHVuuhdMZXHTAaGJIF9
 Pt/pbsZK
 Jq4TztPH586nooSUoJW+2RbJDZf8NNx/UShM6JCdoYDLsX97b5E7uDlP3T8pep0AfGptt26tOgVPvhmgbG/lFBcLOeOm1xzjKcT0AW9+/CJtqJh88Go8X3ys5SBD194GAef7ZGG9E5d8XBNDE2eZL4PNQ6+yGFg0UpAcVooSBlNR6dgqaIoEJCDuYFugOsvldelfJCh8mdoxTiAtDTG/yhVHRsw0dmOe8qL6g5o1A8y+P/lglMFvEBRl8yzYDkC8DMPsap5UpujoO9R/8r2qTEhqNIqyZ0Ds3wQ5pz3jR9tzqDGHcrtrb0icKhxztOLK3XwL0tQxsGDsfFEFb0MZsBd3YUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 1 Aug 2025 17:56:25 -0400 Sasha Levin <sashal@kernel.org> wrote:

> >> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> >> Co-developed-by: Claude claude-opus-4-20250514
> >
> >Well this is innovative.  I doubt if Co-developed-by: is appropriate
> >for this (where's Claude's Signed-off-by:?)
> 
> Claude (or any other AI) can't legally sign off on code :)
> 
> >I'd support creating a new changelog tag for this case.
> 
> This is in the context of a proposal on workflows@:
> https://lore.kernel.org/workflows/20250728105634.GF787@pendragon.ideasonboard.com/T/#t
> 
> The Co-developed-by: usage wasn't my proposal, but it looked like the
> majority of folks were okay with it.
> 

I need to do something about this and the discussion over on
ksummit@lists.linux.dev has been as beer-addled as one would expect.

Oh well.  I guess for now we can welcome Claude to the kernel
development team.


