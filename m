Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E426310F3DCB
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 04:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32D2F6B0005; Sat, 28 Mar 2026 00:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE146B0095; Sat, 28 Mar 2026 00:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21ACC6B0098; Sat, 28 Mar 2026 00:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA296B0095
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:09:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0C721B8CBA
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:09:38 +0000 (UTC)
X-FDA: 84594142836.11.56DA8D8
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id F2632A0006
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 04:09:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cZHIRaKd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774670977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYR1gJ6M/Z6ak/fzYuriJiVP1fqhOV2XtXnkDDYeAFI=;
	b=S+kkSA5ROw5dkANExChcP/u3v5kMc3AkuvciJac4Yqx5sHvrfVcN8xI/DG9QKUgcQ8OWV7
	Yshapym2AaSJpfEHFT/+4O4DYdL5jLUxsFND2goANAKJqk7K83VGqA/Rx5JOiEt5K4BRUa
	El199+Ls+2Rpn7sqAwVRv+DrAGIIuKQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774670977; a=rsa-sha256;
	cv=none;
	b=NPeh4OFOq1IZk7f06flgPjKd7OSGX65McOlY74sVIgHoYc0xCUgMrZQE+Y40pG/oW3iTgx
	SjuEprge7shHVdVxU+P3Wkqk71lYQmfVMW4rmHu5+7CRJwmsXZNj1fUwGI6MYkIhGSGyq2
	8eylgzNyudx+oir+7h1iIP3xfworrGQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cZHIRaKd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
Date: Sat, 28 Mar 2026 12:09:24 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774670975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tYR1gJ6M/Z6ak/fzYuriJiVP1fqhOV2XtXnkDDYeAFI=;
	b=cZHIRaKdYHylWzqRzuEVjgXCIT34HtCUlx16WpIdv9ZQ7ZHGq+GByTN6sAO55DZI5pCmv2
	Qa31Rs/b+mTyU8BN3sUi2ZgFnIq3y35Ju/kczSm0e5ScYB5mMT3C3jHNJqhluni060tuiw
	HEHugFthSEkmOatsPcOGxqOpdD2Bh3M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, osalvador@suse.de, akpm@linux-foundation.org, vbabka@suse.cz, 
	harry.yoo@oracle.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Message-ID: <5omwfganlhwbmllrmab6f2v473rrgirvbtqrcouj6tz4karzjb@xiheplfxwap5>
References: <20260327143823.3063541-1-joshua.hahnjy@gmail.com>
 <2356614e-d9b8-4639-8e2a-96c5e4eaef61@kernel.org>
 <c3b10a9b-d3a8-4e5a-8cf9-3ddb172d2c0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3b10a9b-d3a8-4e5a-8cf9-3ddb172d2c0e@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: F2632A0006
X-Stat-Signature: wb7ocfbpku5ddmfsoecox8tg4d4atpmc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774670976-417387
X-HE-Meta: U2FsdGVkX19ul+Iu+/tGrNNxeznNVFKNXM0c4VdXQjpPwJXBddRpOMAhVSkhKy2lqV10wNv82I6e3yojOw4Upqd6dqTNUDZKklwlq6Yl0oma8dxVkGjVGRqvQbvPU0ixyL5auuRGm/l4C/5GJaG3B3cLYB9rpyu7pu/53QSZ4XdFazCArr2Svgsp6nF6AF4zlKZ10dN4Ro94VTRd9JDQS1ghQRzTXFfDurn2JV+1PmMo8p2+UBx0FxE3iH+9dbihmm+mp8Pid6GuEYmlGPGNSf9WFfosgLdAJV6CcxgJxoaF1uzEaegXG9mga2K+eyL6h91FF4n9apAOqkqmPuWe4REG71lLKoT3wn0gFDdxetpqW1WyxoPH0C5MwlrdH49xUj7Z1mbjOJmPek0kRyFkXXr4NNpf7+4/x/i/Wpa8F67RDKEpQSq4ZD7dt+cddhDXiO+UVqhJnWh7YaasMQj4nBb0WUKmkBMnq49YBHdDsSh4/RZ/I3RLmr1MsoNfeFZHPBTmq9aGzj0LvPbwF+8hWl1+zJ1/Df4GH6tg4/y8iJ7W4v3swEtEU0mIyscTCVIJNx0PmjMOB76jvVvTR3h39AvLfKXaciF79qsoGgkulebxwFls7xLhqWbOIW/hn7QrwwcrvkBrGamUl2fijH/7T/1zih2SamHZ/FKfMNS4x2+eQYV3yfTKUdGAnAECmyippOdO+Vim2vlBUifxUKys6uRhi8BnvExVfyoZScFTXQupEobXbfK6/3bG2GjPlDXUo9F7TGbKxhR2UA77TyFUTpcjD9Kj0P8Y7QnknLfpDMgdmlVFEBX/gP1jErKWFmJkoCLGOelta9dk46WegUm4MFZEpIoHhiFXWIsViDpJlobudcc98tRlj3OZ12Cgfm/Nzp5GBgiFqnvXwCoa60MuvqMLu0VeuzbOwj9IA/kjdIFeiBiB/oe9W7CjzWtq3tKzxVZyf5JWIzwq1s0rh3A
 ElTQFp/F
 0nx6kL46AlR9UlnBGB/0GL412V+EOGoCMae2Zz4VwBAEsxNGLLvx5fbtwixP1ObooRd5tMF1Gk5cYS+8pactl2z6yLvoA5wQtkXjTzcJ8hOTrFymP2/0AvYDY5N8wJlfAtIeWvjubtcuwlC90Bjbv8LOzk6uasyc7oc3PSPfl+fk3jozLCpuyxj5CVyjeBl8krv3M3eYJ68JsSPq/92BR5EWsYjmYHiK1dw7GrwPSXdPdNnJorlT+wpRz1h4QFpo1Hn6XURX58V8SrvIKLAYmk3IyeYpUlF+rLz2n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 04:22:52PM +0100, David Hildenbrand (Arm) wrote:
> On 3/27/26 15:44, Vlastimil Babka (SUSE) wrote:
> > On 3/27/26 15:38, Joshua Hahn wrote:
> >> On Fri, 27 Mar 2026 20:42:47 +0800 Hao Li <hao.li@linux.dev> wrote:
> >>
> >> Hello Hao,
> >>
> >> I hope you are doing well, thank you for the patch!
> >>
> >>> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> >>> hotplug currently only updates N_MEMORY. As a result, a node that gains
> >>> normal memory via hotplug can remain invisible to users iterating over
> >>> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> >>> incorrectly marked as such.
> >>
> >> The second part feels more important than the second part, doing a quick
> >> glance through the code I can see a few N_NORMAL_MEMORY iterators that
> > 
> > Note in practice it's unlikely that a node would hotplug normal memory,
> > start using it, and then manage to successfully hotremove it, due to
> > unmovable allocations. Most likely only ZONE_MOVABLE memory can get hotremoved.
> 
> Yes, hotunplug of all normal memory of a node is unlikely. Possible, but
> nothing to optimize for.

Yes, I agree that fully hot-unplugging the last normal-memory node is probably
uncommon.

That said, once we restore the set side, clearing it feels like the symmetric
counterpart as well. If we leave the clear side as-is, it seems like it could
be a bit confusing for others later on.

-- 
Thanks,
Hao

