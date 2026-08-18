Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E61C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060AB6B01F3; Tue, 18 Aug 2026 03:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011B56B07E9; Tue, 18 Aug 2026 03:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69006B08BF; Tue, 18 Aug 2026 03:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3B906B01F3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:00:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41F811C1F9B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:00:29 +0000 (UTC)
X-FDA: 85113491778.27.73EE6D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A3BCC1A0010
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:00:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OE4I8Vjx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787036427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eLkCtMfElj3TBbhOnqAE7roUGQ5xLxxaMf/iSBaGdec=;
	b=0l1qSdShXGuPco+dtbMYc1Nciq9Fx3KljGgUe58KZwapOvskMiZ2nxJygFcKokw9c0k1xn
	e2oqa52IYZ89+irxdu6uEFLNsd2OfalxH6BtJI9lcgtklOGVtLGP7f+XZAVdZKBKcUMql8
	nlspiwvq2hqK9H1deT6J/Us0qo3phqY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OE4I8Vjx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787036427;
	b=U6v1pbUgEwc88eZYms9qjCihmiFpXYjAeD8rKg82Fz3kumL3H4LOE+F9h04T2cPTYihnqD
	O4myD5MVIRDhnF9b/j0DJclz9idjMjTEFxigvCEG1IMpKC2IYp1SUl2SHlXz2dOkYWJ0SG
	dr47It2zv/poxV/Z/5XaqTp4nD8FP4I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73388406FB;
	Tue, 18 Aug 2026 07:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0FB1F000E9;
	Tue, 18 Aug 2026 07:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787036426;
	bh=eLkCtMfElj3TBbhOnqAE7roUGQ5xLxxaMf/iSBaGdec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OE4I8Vjx95n8znDxHW+u9FRfXy8EgQy3a3KN7JbsZ2DwzPrM2YozWbad13thW4cU2
	 BMOgwcALvQQU7jmC/dcnWs3R/YgiONJji781fNCWIMjnQJD9C67DwIDetOVVeiV2IA
	 bgnbB77DlSlkDpuqn1KBk1gb37XhKMb/1C3lsuGkBOeXCDpSTV4hAI3cE11F/vC/Ua
	 o/y0NmcIo2JX8jLhixj+tl4Gxb5OUbA22RirFO28mWTzvZWamEg3mqvwihGjkjSUQ+
	 AuWkIgg006Axbqy/5PskV9T30X6ileS9fKAFl78eTSVbm3OOz7/BAJd+pCZWEF81k8
	 nRWr5HRJKQdfA==
Date: Tue, 18 Aug 2026 08:00:04 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	"David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, James Bottomley <James.Bottomley@hansenpartnership.com>, 
	Hagen Paul Pfeifer <hagen@jauu.net>, Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, netdev@vger.kernel.org, 
	bpf@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: properly account locked pages
Message-ID: <aoQBQWH1zWgC5f3A@lucifer>
References: <20260814-secretmem-accounting-v1-1-d2f8c677980b@kernel.org>
 <20260818052006.2387242-1-4ncienth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818052006.2387242-1-4ncienth@gmail.com>
X-Stat-Signature: 1htu831jkyuocx7jqotobhhfcfb4pxk8
X-Rspamd-Queue-Id: A3BCC1A0010
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787036427-742205
X-HE-Meta: U2FsdGVkX1+R2XZn+TvAwIUHPovNGlndh0ZfRNg5hBUyPEK3pZjVRsj+HbVt+LHIvl6Vk2jlvumpl1wQGlDFB71fL5LvL85r0NuxnDx4Tsoe/bz82SrQfc8DP9wSmfPENCjP1UxC4yB/xHiv72UHXiKjZZzjSnkoIRSNM0k5K/wqHeigyQ93faBajTnz5RlQBODTAk5z54hGtyP7sJz79UF+540BswSxlIkUhx4gyJxjL6UXJDFjhCzRLpOsCyI+DAC4vBDs3tEGOKAO/k443tg8k2DRKuod/iwufjSkz1lK36iIyl7VuDD+Hip/4UBDp26tP2Nfo6YJylCsFVA3p87N+9RliyMEFQbi6HlSlsmsQY4sMGhUjTbudFY/sR3LRqlGvIWMPngHdZ/H8FznbrtcKnRyPSxjf2CCFaLc7pWPZyhLQv9YzX/up6zJxcB/K5VKNZicd71WGml50sZHFgNs3OeBrlD8pSKQs6HFyH8JgibhsQFfPiEHyaQTbOgoIMV2tKK0OljyU4Zstg+y230lDZUbyEDRgGTtrZWEzBw7gdynNeaPk0v4iQkme/07POG0wFMVxXjrsDOz7vjU4iI1ankCI8TE/Vb6n1pNZzRoj8sGJuagISAgcJH3as2cjjMd7+YyMCNePLNCYQtqloVynVILsC+BXy8oIW+nqZqH0m5KpGNsPAL50aHJfcGayoA2QJ1midb+HWxMXkn+cU5HIAvi1MdZm3/Mhnh4HP6iZtGWd90cGg5LFSnSSWGAHR8lVuSxjUw9ycs60+NaQVCoq2sN5W/mmKzngV/lMpwDAdnYZmXQGtZE5eJPpD/JilZ4gneefLB0wUTl8uljHC0dJMPcFIBSgGgsfzAx02IMjYaPzcoyFlhWbyg2JXQiMDIKrJPY4Z7hSw8nmotkUCmLfkhY9i3J/dW42HiyR45ESxkQ4pCWXNFnAgbABm+pwXrxdRILJp0gxyrzlaO
 5LR9iMc4
 IQr2mGuKQLFuMHQEPuWmZXeP9VKdXXlaFX5VKeJ4djgY5PHia6G/JyroE7cy3RcNyWbG7cin6ZWNiz8JV9EgF4WCwzhVX7JlLpz2T6lGZPzoU9tXM8HT/et7EXni4+NRPRpcerJ+YwLsvHlwYoANqHxme4yO3qLi+OaxHJd6ZUiaw9unMOelJjxVxBYr5xzxaNucASX+cz+ccH0FGVpCThkxcQ7GIV+ETPbjPJx17RHW9EOMzJR0u+Z43JZKwnVWJNjZYWCL67dHQ8EgJyNnLKG4vZASnhcSQjdsJKV3wz3L42IkEtmuYxY91Q7PSKQzQnizkUIOM4gFlBUFUDw2eoHfm6hmj37gTaQRV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 02:20:06PM +0900, Daehyeon Ko wrote:
> Thanks for the patch.
>
> I tested this v1 on its stated base with an x86_64 KASAN kernel. The supplied
> selftest passed 6/6 in three boots. Additional fork/unmap and inherited-VMA
> mremap tests also passed.
>
> One question: the inode stores the creator's user_struct, but the fault path
> uses the current task's RLIMIT_MEMLOCK.
>
>   secretmem_init_inode_priv():
>     state->user = get_uid(current_user());
>   __secretmem_account_pages():
>     page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
>
> With A limited to one page and B to four, A created the fd and passed it to B.
> B faulted four pages, after which A got SIGBUS faulting one page on a new fd:
>
>   CROSS_PRINCIPAL receiver_pages=4 creator_fresh_page=0
>
> This seems to charge A's locked_vm using B's limit. Is that intended?

Yup, it's a per-process limit even if the accounting spans multiple
processes.

It'd be incredibly involved to track each resource individually and this is
a trade-off.

In practice people aren't typically varying the limits like this and in any
case, the least surprising behaviour is to adhere to the current process's
limit.

And this is the same solution used everywhere else by io_uring, etc.

>
> Thanks,
> Daehyeon

--
Cheers, Lorenzo

