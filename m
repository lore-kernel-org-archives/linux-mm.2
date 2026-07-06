Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6618C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57926B0005; Mon,  6 Jul 2026 04:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2FDE6B0088; Mon,  6 Jul 2026 04:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45A26B008A; Mon,  6 Jul 2026 04:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 766F46B0005
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:50:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEB32A0327
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:50:40 +0000 (UTC)
X-FDA: 84957731040.28.D09CC9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 206FF20002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:50:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ANrs69qg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8H3wDGn6Io2auw5Dq74h7CwVRzPBSpUoio1EButPo5M=;
	b=QYTkX7a0QW8pS/aJefOaCtXBgGG3OIrRycGDLtaGkqzkBfAz+iKj+Ubedc0GRGalL+KViG
	LGiy8tIM0vfFz0CCQms5Wk2PnKhsK/wRvHS5FPKwu345ObyUUCgsuWDFb6wiqCUMiIog2E
	P4QTKZDDe4uXazpZu052ckQiENTAYA4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ANrs69qg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327839;
	b=fKMGY7xZAdu3tkHYLI70WflVZeMKD+tGphN9v27f/pUlo9qc6Y1A9ML+RpROAKsc0GH3cj
	rBeGbnC83xqpIiUmkJaEL4sAauaROpi4fXYFSDubCpitBf5sVasp1kvdnHB+YZ04J6idpl
	/zfx9Y/crxwrl5CZ9uREYbu183dxFu4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 515524193F;
	Mon,  6 Jul 2026 08:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249C11F000E9;
	Mon,  6 Jul 2026 08:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783327838;
	bh=8H3wDGn6Io2auw5Dq74h7CwVRzPBSpUoio1EButPo5M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ANrs69qg8B3upFzmzz1q7UCws+ttEpVdzpUaimTCvD+uOwRkVwPhWXcUho7F/IFpN
	 4/3l6+TGqMN52tbb57MIGpQrKX+d+7eT7XIjWnp06L7ElnOXaFdHJrztZchHeiwsBA
	 ZrVqHR0tM0wRs2N487lJriz3Or9FEzWLT3uM2LvA/o93I3Di5DLHOlV6ohvF/Z++c6
	 51PaDGH0EWETai89/+uekM80tJN5ttLsg3Lss2ODsuwWqsQtTqbmIL6giAN+VByDkT
	 oshZumLA9dxRPcpU2kbrWB+QtgnBmbMFJe9l/ZB2TSu/9Zs90Z0cusfmVjzt7LM4Al
	 lveYFOyQ64FXQ==
Message-ID: <67c96fa1-9e9d-45fc-94fe-1e67253f5270@kernel.org>
Date: Mon, 6 Jul 2026 10:50:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] mm: rename swap.c to folio.c
To: Jianyue Wu <wujianyue000@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
 <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-2-a028e8b5fc3d@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-2-a028e8b5fc3d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fduwh3merxwmgqjiy154brwuzna7qxxr
X-Rspamd-Queue-Id: 206FF20002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783327838-414472
X-HE-Meta: U2FsdGVkX1+AROA2WLo60ubbKtDoT0xu5Cx6E9e/wzPYwZbPr1/NsYBGRAe7dTzA9QhSyENwepj+fY6szS29e0E3VFPjORemvrxSaPE8xPlCkYC5z/t2A1RFr6ACLY7ZvLwqX4ZhIwaBfKwzL27ir7ZgwWA2VH5ljsvM01J4MTAF2cxbwEUHw12RhKwbmysqNdwyuxsQESFOpa9RC075F86UU4W5dRf65w4lk8QESxI+mhLIBe62PiS6njcH95YxRWdeD9pjg77XX/gUCAZMwYodJkAdiSd+gsdsevL67ofL1YNamNgR3oH9tTmjPH3K4pyAx0UUYfo4ZnKrjU03Uncvr3FTtSYEz8ZMkHDgJk5sA4y48+gNOMAMdjaSE27J/UQHXUNvixDhhsEzns98lvRMcnYPKvGo2S9XMnafdp85hEtX/Zrl4hg1JroeuqT42bmYDaZ8fOaeW3rpBXqLuzqiw4kg2M8+hvbQj8r/c9Ii0c24uW9XKnLls95UiIBl7phRnN6gInbHb55+GxZHARmEHDvfy1ATrE4yzIh3mn0YvNfGZdlDnHlr7hSGQyxduWJykBAvdnJblhd+U/HKJOcM994eXqTH+tIwIK0LGZJ3sk6zgp5pCBPV8IDBCRsECRDVBJXbjYWdGo8iEij/Gz2euoPmFCOpnTKhCsWkdMJt6p8uvedGduKe53oJHBZQWzmngWcNNrN1j92bT+fjlO3g2c6qqOSj6ZM5O8rU84mi0lQ0VGZ0VCt7U0gMqK1byJo++KrbaiuF0GftDQpVkgovI3EDFKYPnfM69/bxK4fAoubtUTghM7JJ0b3UxTH9ao7ozgS3flhJxeONfpL7AEUG0ZOo0Ygvz2Uc+Z/fJG+BCrk3s3JXYpaTSQCFUdznn2qdd7FIBCLXl3zGwphR8vWyi78ytn3i058qknsaUwjLfk02LfdQpPuraayb6twiLPT/y6iRp1efzU4R53u
 As/tzfsF
 bPQdfzeERGd6c3Lihk9Y0K/HDoSrbzv25HFKyUZlv6unZ62uN4+cBViiXRRh4QA2mCAg09iPSir0G2iACrbdjm0NxW23R9pYjPrFtIAU1htjteqB9xULBssDTYk/FQhaszwlcZqzHV9TDlSDDARoHJohRRq/ntGPaF9YDDe/Go6MyWyKbrptt8Bok4Qki/oE3uHcJ65CpDKaD/CoS2DVr7GuJkiikGczUX1q3CzSBROJQRI2wUkiB2iW8HZxxRqbOorbFrtUgiDwWZHM/X4M4f1z4nINOtT2Yyd6i3YuXtbPf100zan1rEddlQ2LwR0PuKjsytZRA4XkKZ6ajlYAURXbiKDLv6zy5yklgqI/vqxCXqki80zXfAyj05Z7h/qmrGyRwNp7urYD1LwVDF/DibgTX0WFO2PP3Ny+YbLUoSlUR3WeO40BfcdgOY+4/lOgamOC8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/5/26 16:12, Jianyue Wu wrote:
> Rename mm/swap.c to mm/folio.c so the filename better matches
> the code's main responsibility.
> 
> This keeps the implementation split from swap-specific code without
> changing the published LRU helper interfaces.
> 
> Update MAINTAINERS and the remaining mm/swap.c documentation references
> after the rename.
> 
> Suggested-by: Baoquan He <bhe@redhat.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

