Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77850CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 07:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8DA8E0050; Thu,  9 Oct 2025 03:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62828E0002; Thu,  9 Oct 2025 03:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B517B8E0050; Thu,  9 Oct 2025 03:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A021B8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:04:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 604FB46368
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:04:01 +0000 (UTC)
X-FDA: 83977686282.04.C1F5CCC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8B8A114000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:03:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="p4/Q/AZe";
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759993439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jbck5rY2XAH60XmLiNcpv7eh89oTr0riSsnXLegdKv8=;
	b=1XSJggBnPi6/IH2xtbGAOJ5BHSGS/W5/pPhneBD+8Gvd542PoYm1/Z4oEYZuZ5Jv1oxJbC
	e9c3PgShpV0nQ3uwrf8i8O6/s/v/hWduEjrOqnGE4aAmg/XFUFMCeXUUll7u826odfZxuf
	J06T8oKOqg8rnrNw65tCpImBQIF3iHs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="p4/Q/AZe";
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759993439; a=rsa-sha256;
	cv=none;
	b=gSxF2cdQoJ0hV1fTJthkmX2v0qgdmpxTAZW8H1B6zFxeuJdwi9458bSa7q5f++QafCRYuG
	6SdtiUiB9Qkhc/zpy7dhS5W8d7ZacCDsbW7hFsNKcXa0MABmPz6T1z796pNbssJVbt46GJ
	5WCmy4fdJOIhSc5t6JH7YEaErAKygYE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C73C4367E;
	Thu,  9 Oct 2025 07:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F42C4CEF9;
	Thu,  9 Oct 2025 07:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759993437;
	bh=vq6Gude3pLvvZ45iIJ5I0tbxMA5VkZHO2gu4zBXFz/4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=p4/Q/AZeJWLhcmoXzwBCHZU9JLSuW3AKsQ74uJG+T6HaqlZarJrn8F10CR+jDPrVw
	 pW0o00gG2arQqn4mAc7b2+YDdvsJ0zgf9PyXz03VFK2hZvQlJYqGglC/JEgJGEzYAC
	 r0w/GN/d46xB0uaG3uI/YB/chd8An3eXhQLx3mTI=
Date: Thu, 9 Oct 2025 00:03:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Yadong Qi <yadong.qi@linux.alibaba.com>, urezki@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmalloc: WARN_ON if mapping size is not
 PAGE_SIZE aligned
Message-Id: <20251009000356.8e18395dd9979045e0c66de2@linux-foundation.org>
In-Reply-To: <87zfa0tw9o.fsf@DESKTOP-5N7EMDA>
References: <20251009061410.820-1-yadong.qi@linux.alibaba.com>
	<87zfa0tw9o.fsf@DESKTOP-5N7EMDA>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hrdfx99g5mhtgb7bxp8s94g5955phwyx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8B8A114000C
X-HE-Tag: 1759993439-833066
X-HE-Meta: U2FsdGVkX197ZfDUu/pyWpICWDSncZFI4eCpYnvaskrwa1HgINnIWkBTWF7FXzdbZUCqKIGj8N8o/DUzAXV4lTvVuR4lfUlDgEJ+ueqBoYDf9HoYjemzxcsA6aBFlFz3EKmZ4PA2ZsdcrMVn0DHBHxmn+/w5SrwYiQo5xeUFgeJATbMFPBNdr9ZIcopMq8cOPHYYAacYY76RGDAscnp0SyZCnGUlSNCMpKPx9ASdVaD3CLzn6Vi63tTLZhrLiwnO+LKVm8VDyne8pQugBaDOBp2Ud/fvtMXN6OD9UcbgQaCrC2KBNguSdtP9eUM3CQnnyiDtGCs3DrpxIFwo6nseeCiVpn8oyA9sid1d2Ecdwm7NH2itQnYbqduVh32JAJ4QJQgt5eJ8s62FYLhAjoNwteWJ9e8t0JbGhpBrtXT18Rk8VuL7zX1lklHsDw9GUCcKfiL89l2fXlEFy1Uwetv3az0TnusB4mhcDMEZ1RoxUSoxXTmJsxi5yeIc2g5WhQNvseTxJNp/0xJwYdtHK2DFQ/VB7NkGVUB36uhXli2T91INBGImJGDYqFEFnICMmQ4Pkw95AzsTDHsUhK4PkVl9mNRC8aeSm48FZx7lRYjPBCiU/tgovwe/XnUBo5fJ1qGoEDxsu6K0u6pyQ1y4TiPUonRSfUuZXMAJNB8cEJRCk+fhmKV50+40vZjER3sdpUuWu5jW8nx+mO7qAPnpnyvW8RXKEQGDXckdLv3PwglmxkxVDNsHuiNFbLZMLedJMQG1MeaZtTlxk63kJaPD9yr5SvY0LfwUGv/ZodDLKRTR9L91Xkms/COTaecOq3I23GNU9Wd/PZOmrNhx+YzL0VaoYbkQFaX41YRNdz1Ot6IhQ4G4bSry4D6OHdWiSAcBj4KSZ09m1q0AKarFyABS2TFOhfGh7Ki3kjmqKl/J2eCF7eT16YkDCT2za3pZdnZp6RkR2AhWCW1TP7kaX27xtTv
 SCUeROOC
 WSz/vQKikKuEcIfepfGIPh4L5aak8MbrNkuxXSJXr9cIsJ+R0ZqKJ9MN4cFUTvVC2GHmqgoftTZ84/kr3rTIX3zuasLwzqWTvkwCUC2SQumlya9bqoQvanXQYJU8VRiK6lQlQqPQQTEAU8EuNpMZV7ws4tYO+PxuOncTpoLR2QZhNMHJsD4uYBh19PcbB91aW9Nfhp1umuh6/orXjCHkc9Cv8YY3Qn0SJfKwfbSlZefEKrPAnOMullpks/O1li2c61Lz150YofYTfwasrnWqv9FVna1DG/K9dGriOPTo1C8G7/jRnQyZ8BdXmBNYSFk7kgnUfDDTdP8F/7ETuvFfPQweB8iTi14u9ZJJN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 09 Oct 2025 14:38:27 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:

> Yadong Qi <yadong.qi@linux.alibaba.com> writes:
> 
> > In mm/vmalloc.c, the function vmap_pte_range() assumes that the
> > mapping size is aligned to PAGE_SIZE. If this assumption is
> > violated, the loop will become infinite because the termination
> > condition (`addr != end`) will never be met. This can lead to
> > overwriting other VA ranges and/or random pages physically follow
> > the page table.
> >
> > It's the caller's responsibility to ensure that the mapping size
> > is aligned to PAGE_SIZE. However, the memory corruption is hard
> > to root cause. To identify the programming error in the caller
> > easier, check whether the mapping size is PAGE_SIZE aligned with
> > WARN_ON().
> >
> > Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
> > Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> > ---
> > v1 -> v2:
> >   * Use WARN_ON instead of BUG_ON
> > ---
> >  mm/vmalloc.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 5edd536ba9d2..2cad593e4677 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -100,6 +100,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
> >  	struct page *page;
> >  	unsigned long size = PAGE_SIZE;
> >  
> > +	if (WARN_ON(!PAGE_ALIGNED(end - addr)))
> > +		return -ENOMEM;
> > +
> 
> EINVAL?
> 

If this errno gets returned to userspace somehow, programmer is going
to wonder what was invalid about the arguments which the program passed
to the kernel.

But either way, the callers of vmap_pte_range() should be audited, to
verify that they take appropriate action when this happens.


