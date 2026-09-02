Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E35AC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1976B0096; Wed,  2 Sep 2026 17:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471316B00B9; Wed,  2 Sep 2026 17:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388DE6B00BD; Wed,  2 Sep 2026 17:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 169036B0096
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:37:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4350160388
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:37:31 +0000 (UTC)
X-FDA: 85170133902.29.4571F69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E97A7180003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:37:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iMUZ04go;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788385050;
	b=edYXXcDY4+qhN/K0pKEJ7ppyoJ8wBex2QvTwRPuPC11UT0FcX7Kx7zxLaAPJesFoHnnrcA
	RJQnFG1nlXMMBb+W4WPHU624zaWNvyskeRqi/SOjYGA+19mPviT81FZDbA9V/O/uFIruCY
	yl6jXo6lvaKMpeLArYgQPmXDbJidmfc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=iMUZ04go;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788385050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7u5Q20xGyFYF2besHwZ8IoTF1MLoqQdi7RED5WWdQM=;
	b=SKzZy+jvfiExv/KSGRTek+zIFzHDtmegrYFvATYn/TiyFuJMqAwkl38P37sSsWv4fII387
	CilIXp/Fwcw5G/ooVqhJqN50rj+u6unU9Jp6Gk/9gJBkFpfUigFKyA0Ercm0rAONo0JgGU
	nZLHIwktQQ8cMaPFNG6mNUN9xiuAqD0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0BBE41AF9;
	Wed,  2 Sep 2026 21:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BCD1F000E9;
	Wed,  2 Sep 2026 21:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788385048;
	bh=M7u5Q20xGyFYF2besHwZ8IoTF1MLoqQdi7RED5WWdQM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iMUZ04goHcmhR2afGPKLKU7mt9PyuPEB59ToEmoY0nBpsPAvxYnLWxHRHe7ZR/qVK
	 BA639Y9uIzZvZl8tULj65jtds3hAeshlx5dTM6EnAJzktqLVhzNImnwdy2kaAdMLIK
	 YjXdPWzxCh5Kw6eFRQ8eVxrl1glREH3F748Dpzgo=
Date: Wed, 2 Sep 2026 14:37:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hui Zhu" <hui.zhu@linux.dev>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, David
 Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu
 <zhuhui@kylinos.cn>
Subject: Re: [PATCH RESEND mm-stable v5 0/2] mm/vmscan: fix NR_ISOLATED
 accounting and throttle MGLRU eviction
Message-Id: <20260902143727.776d04e71eac0e4b1fea6260@linux-foundation.org>
In-Reply-To: <cover.1788339549.git.zhuhui@kylinos.cn>
References: <cover.1788339549.git.zhuhui@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: tunaxw7oh8a83pwqkgh43bed3p9tph9y
X-Rspamd-Queue-Id: E97A7180003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788385049-210332
X-HE-Meta: U2FsdGVkX18mrp3X3Ns7ms1a7hXe+t0S7lTsSYoXO+0roMypV1ILET1rDktohl6sw7njlPvKpwuJQOHjtbr5UHTpgnPTqLbXRoGjVVtgA11rYt+dZ9v/IJWH/HIxc8N90PFkDBWrSa2SV/QLWKZveEgTam9g4w2iD8P1GRjXllHyS0A5p0972xi4tVjfQPzfaOKbF0nZ+QK6VzN4ri+iWHgcfMq21wP9X/gYaG+iNx0eJCey+Sdmh0NTXpdba9xURybBh7Nhb4UhXqnp7YmhvM6wjAJlkZt6vRjIFrrTa9S1sEPo/htXr6AtMNBJMUUO5fDAxagFxpiBcRVEa14GsTzDqUgW4YTew8ERYbe7Wd9BfwnzDgtspwh1QcvzlkNJ5YylNkyNtqqMPpwTjCI/109VACdFruvY30B6VzOuCUB6wlO0Mp3ljxw+B4cQ8Oweh2nrSyDy50QZiM7ydha5zQJUurAbkRg30V/gY07hqSqnwadPaB8RTXwz8SxYm4sl2nKpPcmSk1Q+uDVoMhMEV8IiuJX16u6Vc2vztHbvKAdDqsowbyzpEZKDquPhMVnbSeXjKHdgfld69yz8mYcKaLUxqIkLpD6NIDm17WUDGkNQBNUGuoOwRBnojH3lvFSOyy59Qg/wiIvnk3g1FQa7Ag9+N1l3Iex1rFTLoe6e/IOyq+68JO03hDHI8tNuuigiNolgXXo9uaWkjEnk5PZumtfDzcAY2eXRCOCpIQLTdU37APr5G+cn1HzF6Y4K++KnKh1bmdQQ56ukXWBjNGn2FCkP40QzWqiKzAl3ueOf/fmXum2j9dsKJWOZAyGuYVSptSuhCADlPzda+XbIBuXOD2lLkyQkKVZKcaYCMpWM20CWZWazZxbbzyCjprajlcyycRO4lJBiSW3ZQTo54RkfG2rQz06QsgqEGVnhlRoi4Mi7adawVk4u3mje5MJ+3AH+MjkvCeBCM5sWdFhtQMG
 26OJF+KS
 g+ie+N+Rmym3uLU/4/Wy9GReZjVYnGdFSja7Gi8GwG4xuesmAW/l/ZzYp3UVxAfR3RRmQf+IOnjF0nQEFCP+2TbZ1o9tf2HVhX9Qt0MaYlrLi9L2Brzl3boQxt+MIiPO6nTz+2VEV62y3z9M/b9X1aA6yt0MyNsGGbpLVQjKgVq9utxDXICrv9nDCnrlzD5hJlJxM2hZ3QNnBksnZD9tQGWUXZ58TMafF2t340acbAR5llkTz9pBLxAddY2YyJarhS4zt/PFqdOzEZ7HjNuryA1Rda5iazsoogNadXORAOpCe3qNCvzNZ75kKJlrQXIVv7vCDVTgPoiw6HggclxTaU7YTJ+iBxjx82Emb+83albbLu7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 17:11:24 +0800 "Hui Zhu" <hui.zhu@linux.dev> wrote:

> Previously the patch was based on mm-unstable, which caused issues during
> Sashiko apply.
> So I rebased it onto mm-stable and resend.

Sorry, things are moving at a million mph at this stage of the cycle. 
mm-new's isolate_folios() has changed a lot.

So please redo on latest mm-new and let's retry?  That'll be a few
hours after I hit "send" on this!

Also, Sashiko isn't done yet.

	https://sashiko.dev/#/patchset/cover.1788339549.git.zhuhui@kylinos.cn

If that's all too painful then I suggest waiting a week or so - I'm close to
completing processing the backlog (I've got it down to early July).

