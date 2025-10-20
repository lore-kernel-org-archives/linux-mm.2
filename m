Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DCD2CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 08:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A431A8E0007; Mon, 20 Oct 2025 04:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B318E0002; Mon, 20 Oct 2025 04:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957DC8E0007; Mon, 20 Oct 2025 04:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 811C68E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 04:34:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 464901407A5
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:34:12 +0000 (UTC)
X-FDA: 84017830344.21.163D414
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 86810C0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:34:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ir95mbod;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760949250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfEYBAs8ifsra+HoOek37qFBoL/xL2+EXDbIfb3EcM4=;
	b=5TRX4s1u3K37xQCWnsKqfoNheVIZUuPhNR6XmRbyJMJtIRhAMd3ZsTUsva4LFRrDp5J87L
	ZnXFtvBIjFhYxs48ojcn467dqjmRvfK+S1KD0XybCgfDKAi9OGVYFsXeCAnDFPLvm5Wh9D
	/fcq+EO2jZCW9cilI6c4V3UEqB3YdHI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760949250; a=rsa-sha256;
	cv=none;
	b=2qZSzEwnYQkMuWBaOnSpTxUDrDlH4QeTVTb4LoSAVRc49DGgJtWIt9z9mdAHZb53mw3jz+
	+XGuNMK7gMe50a6JSntkZIGqwYIRAamIKLa0EiuEWf+6gC+w/0ANwO6bsb0cuhzC+Q//j1
	509OTGVIiUk4itYCazeqfzSIJsBi3Ac=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ir95mbod;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5067D4545C;
	Mon, 20 Oct 2025 08:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BCEC4CEF9;
	Mon, 20 Oct 2025 08:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760949249;
	bh=Xvry6+L+zYDKF402OGrEL2Sp57xE5MGQjq5jn1pdWmo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ir95mbodFzEwdGgwaKAzCgUv1XVRzdu9N9eZyzDR/WCkVPnpeeIjeoz9Le4z5eQbY
	 0WwGobTOrVlGgvWyVLGTJB7rbHA0OAe0s620+sG/9uCOWGIxujoIrKxY9K59KUBDCU
	 btD4n4yf1TIDPeec7eQ4wHImOmHQRsh3hlAY/+qlElIsCAXNRvyWyR9LLESWSDrpaV
	 RkUcMIzUHHcFGOCi1IR2vUdSJyyFxdRpxIozSjdaE2mDfhAfhnqDXLddsrBuqytJ3S
	 7HC7RiSk7Qr7XxXRTX2jFQDIUi6ZF2zZ3JNQt3SEdvPRf87wcSh/fdCZLEvfAl/RTH
	 nCrftv2oclFEQ==
Date: Mon, 20 Oct 2025 11:34:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org, jasonmiu@google.com,
	dmatlack@google.com, skhawaja@google.com
Subject: Re: [PATCH v6 00/10] liveupdate: Rework KHO for in-kernel users &
 Fix memory corruption
Message-ID: <aPXz-IPDRniMHN0u@kernel.org>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: hheexkwiw78ot1suk6emxjp8wco6f6xs
X-Rspam-User: 
X-Rspamd-Queue-Id: 86810C0007
X-HE-Tag: 1760949250-726606
X-HE-Meta: U2FsdGVkX18pY0swfXtQ3OO1vzE0zqRD+irYRKEv/OdZ4soDJagJcpXUxifJXcm5PXzjYQO5M6cA5xaH8cAR54qYE+k3zSaZKjxpwWBMrndvnFCZV/nZ4pt9PIc7adL+Xiv4nxP3jCDIg7vkCn5VokHjs2jG2UC1/Gy47WIoMOZbuV+azNAObGUhrlldS3tmO3uUw79NVkfuP3ErIdoO0RPzkVUM6U52rKfSVDm82/HGBTt1YD6fxCiiewH/BoxNHEpApLJ2HxkZWDvPriiREHK6+6deVIL6+2G9wWq8vU3+Q1rzjXlLvp9npmu+7Fcx1103vqcoB5m+hsEwtOoHhU/4kehxwr08uWxzC7x3HuAwytDvJeJBQdPGYQlJ8vifwwKI/SgUYejGuqpcNA5ij8l9upmN643aTryTnRLkoMhE+AmSm/MB3tQ+tWAQiJh+TuBuUtxr4QYaHRJ5hJs7TzLAUvc5KCSu6VfEathnl/o9ZEgTasenps70dPPBuoLCQGDHgZG0U6kdCmNJl9Wzyjsu/LSB1XtKiZwSvRJKAae7ojhhQc3AV56xUavKYJHDeVASm1opOtwYq/wZ/mbXvcAKILUdLiA0jJA/HvCW1u7fAp7DthYCOHw823feo1Zze8Qsxoeok5D/KggRMmjdKrTEx4G/duDqpx/hLrxpN/256XiUkcqpXLmHEsYl2beVobUkqYvcpV0t54cvzGs4h9l1XhZYXPzoa4eWESOYqQ1L4bu/XIMu8WVGEiyZdug8bInuYbRnO9himqDJ0/VKi5Yms/rLa9YG7ZABd1E/BTs6UMCV8YnSZwys1T55F/4PUtXP4etVQ45QKnjhYGi8s39ylbUsNNnH8SYM4eor5Ky+Af1t75O41hRJXRJl7t2rN+7cixgOxwc3PqWwUVt8NajhJylF8tNGK60uTV50EonMqaHctjTx9exhfYI2IPEFp0NJNXQsmK1wVizyuf2
 j3GzzPnA
 RPTgaXdpFTESeEYO/dRoy5eELmMJMIys7XkAN9/+5Lhy4JkBR/w840rbSd0j/dkumHkjmrXTwVtrmJtWHeZkzXMczBSjTtMLVqyMqpkKwNU41GQ42KixrlO5b4x5bf5QB2KPXv8JRsRY24SmC/0mn+djQ6qfBNqA4douD1swWOHId3jXwywEUWAzFTuXu6Hv7HwLMXv9jdzmHShfielb9dcMBbBDIAmjVC6U2tKQZtsWyXmCNB3z/iye8+BsK+dxi4jFArXXKbs2lVnnoGrOwSZvW49tYgfn9qAWUQlxygGK94InZuMhu7FZhXDkRJjpAw6T+cr217TxlGwdG278Ks9PGsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 18, 2025 at 01:17:46PM -0400, Pasha Tatashin wrote:
> This series addresses comments and combines into one the two
> series [1] and [2], and adds review-bys.
> 
> This series refactors the KHO framework to better support in-kernel
> users like the upcoming LUO. The current design, which relies on a
> notifier chain and debugfs for control, is too restrictive for direct
> programmatic use.
> 
> The core of this rework is the removal of the notifier chain in favor of
> a direct registration API. This decouples clients from the shutdown-time
> finalization sequence, allowing them to manage their preserved state
> more flexibly and at any time.
> 
> Also, this series fixes a memory corruption bug in KHO that occurs when
> KFENCE is enabled.
> 
> The root cause is that KHO metadata, allocated via kzalloc(), can be
> randomly serviced by kfence_alloc(). When a kernel boots via KHO, the
> early memblock allocator is restricted to a "scratch area". This forces
> the KFENCE pool to be allocated within this scratch area, creating a
> conflict. If KHO metadata is subsequently placed in this pool, it gets
> corrupted during the next kexec operation.
> 
> [1] https://lore.kernel.org/all/20251007033100.836886-1-pasha.tatashin@soleen.com
> [2] https://lore.kernel.org/all/20251015053121.3978358-1-pasha.tatashin@soleen.com
> 
> Mike Rapoport (Microsoft) (1):
>   kho: drop notifiers
> 
> Pasha Tatashin (9):
>   kho: allow to drive kho from within kernel
>   kho: make debugfs interface optional
>   kho: add interfaces to unpreserve folios and page ranes
>   kho: don't unpreserve memory during abort
>   liveupdate: kho: move to kernel/liveupdate
>   kho: move kho debugfs directory to liveupdate
>   liveupdate: kho: warn and fail on metadata or preserved memory in scratch area
>   liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
>   liveupdate: kho: allocate metadata directly from the buddy allocator

The fixes should go before the preparation for LUO or even better as a
separate series.

I've reread the LUO preparation patches and I don't think they are useful
on their own. They introduce a couple of unused interfaces and I think it's
better to have them along with the rest of LUO patches.

-- 
Sincerely yours,
Mike.

