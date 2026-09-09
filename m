Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E6E9C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D19D6B0099; Wed,  9 Sep 2026 13:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7825E6B009B; Wed,  9 Sep 2026 13:49:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF9C6B009D; Wed,  9 Sep 2026 13:49:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9476B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:49:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34FE8402D9
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:49:43 +0000 (UTC)
X-FDA: 85194961446.01.15471BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 685F240009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:49:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bEJ25p44;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788976181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMFr2pRrz4NizZpYlauR0A2ajuMYpA9flP2EenlgMtg=;
	b=Q6qYyOk9rCIh/5QuCysASrK1sR7dVsAURR/TftgA/gVwguCaPssm5Rq+2OzaJaINX6WB1T
	7WbIZ+yskv7uIbjjP61QIHeIYEfs7x6d5Y8JkLasTJ/kxcP3Ny/HQmhdRkW+4NEYf3Akcn
	p6vh479o45EtlNP1WF7VkHSnXFbvFGQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788976181;
	b=CLCtbMdvFinWtgXpTC7FUIVw/dOGJ++gIr0j4tSY1FWdVsoq4X5VrANRgKt2ksciR8wbSv
	UtTqw5HA53kOr6kRMPiPFYJOyAG+HLn5km0Uy8N6DCpSfteMOdBqv29e5hL5hnA+rOFz5p
	ffwOYU5enFqfBvN4EgoJv91pPP+BfHY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bEJ25p44;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF8B4601F0;
	Wed,  9 Sep 2026 17:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4C01F000FF;
	Wed,  9 Sep 2026 17:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788976180;
	bh=xMFr2pRrz4NizZpYlauR0A2ajuMYpA9flP2EenlgMtg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bEJ25p44SexVsQl7zqgMU25xKTQUuw+NitGL8u3/G2PvC5JIz5916GmDjwDOSHENL
	 U9eSqIO9ctB6EGOS/YBh/0p6bBvBJOPVtGCzZhXOEp1AHonBa318jyx77Byweb3nNO
	 RFmy9gcW+3H3YD6a09ojeqj3kscTifU8gkWQy6wA=
Date: Wed, 9 Sep 2026 10:49:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 her0gyugyu@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] mm/swap: skip empty clusters in the swapoff scan
Message-Id: <20260909104939.5203c02695fcfd7a95f4b26c@linux-foundation.org>
In-Reply-To: <20260909161552.2335971-1-youngjun.park@lge.com>
References: <20260909161552.2335971-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 685F240009
X-Stat-Signature: t6pii5x3k5ix4n9fiitaruadwjps9jpf
X-HE-Tag: 1788976181-217133
X-HE-Meta: U2FsdGVkX1+ulD2T6eL/s2dRy5FVpsIr5pGe1NnW3+uWbW0TfyE8isTX6CfcM8saWsIiPUGYQgOG9vkHMyM0LZBZDxFxNUcUHke5WAfFfU1qtIz/0GIgE3CEKkC9w7YCsxEVOS5YUPMJhog1zKPIxSx6Sqxrn83RRTGIrROTakaNhgiwi9TzjxjWhEKuuDARV/LvzzUX5qcQyqBWnM0AyP2fw94YGo32D0dm6TdGNG0huzI7blQi3PdFIENjXhMXIbYQhCcV6kuA2MyXAoRAdlIi8hxsMAaSU3Qn+8+WmYRl3m+rr9x9OVa9st9kZJBAOLXPVdHqJIBj7Os6+AUvHSizMjk41ddGtMhGeo86L267KXlBVK5vcDW69KTctTtZVgmAStfEZpAFU8nO/5QHms48mpDQtHs3y2sIcwFLpp27jQjYTfNQmzfv9bkRrq4owU30AX2kkjT1VHzWXHJLslByodmsTbz6RtoRkX/lxMLOyFBkBxmJvrWy167xIV3XXiBpnb2nLErzT6wSm/0jH761A+FJO0ZZL4D8Qu0g7jcz57cGKdBsrgQww1n7ZxKdiVso74TkW1ujq4sufJQ3yxDlPN33w90TEcj1KjNnKdkGgzZcnB8tWmK7NNte4yyQTbwiO587kzUp+YHF1FlztiH/EfQJdE0oWb8FgsMwIjvpNaSZ9gP6KOMzDkxFla0yfSgvEHZrNMZb1f2XClY129EK0RuNB4vynEXZE4GJrDi1GRSYia4RjS0N3ECzczXlzf2dOOXEDygySiZC6xT3/R2jO+IxwmuihVLGGcMvN3PfUvHQF4aAB24nlKoX4pKgfTuDjEcH84pJsCFzVv3Je66wN5DDAg05mf4Kv9h1dvbk4w174Xwjh2FuGgUR7fftUZS5ZmKX5tvKn47JflqR6//xCv2XdWwmG9MT98Y0fRRC8J2Mv4kqZf0v5mLIY0F4RiGGYDxpb/aGmzdjL07
 uB2BkKOt
 1W5KYklNUvicTYh/y/blUpLSY6Y4qF1J4hbvwhY8b29OGWlw3xMiWG+z9BoxX+qGKkBqOYQC0U3KhqpWUO5+XI9DLaeYS12KGgir1Pp/IiZbDPqDDxWsJVc6gxU13rKYimknIw15niBc42JD69G5TRDq7d0cU6nFJgYqyaSVXgbnm6EvIpAfDrIBg5IGTYwOogjDI7ZIgcOtLqNwRsW3T6kFgb5es4l8xtAVO0mGqmda32ZiuTNMEduRwEoWNXSTJfqMeuXKc0c+U0e7cRugjOBaliw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 01:15:50 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> find_next_to_unuse() walks a swap device one offset at a time.  Slot
> state now lives in a per cluster swap table, so patch 2 dismisses an
> empty cluster with one counter read instead of SWAPFILE_CLUSTER table
> reads.
> 
> Patch 1 is an unrelated one line comment fix noticed on the way.
> 
> A debug test confirmed the skip path runs, and swapoff completed
> under load with no DEBUG_VM or lockdep splats.

Please let's try to make the [0/N] words provide a summary of the
patchset's effects.  The above didn't even tell people that this is a
swapoff optimization!

I asked an LLM for this summary and we came up with

:  Speed up swapoff and reduce scanning stalls on large, mostly empty
:  swap devices by skipping empty clusters.  Reduce swapoff time on a 1
:  TiB device from 158 ms to 94 ms after filling 128 GiB, and from 392
:  ms to 73 ms after filling 512 GiB; expect little benefit when
:  substantial swap data remains.

Does that sound OK?

