Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40321C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 22:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 401516B0093; Thu, 10 Sep 2026 18:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6BC6B0095; Thu, 10 Sep 2026 18:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED2E6B0096; Thu, 10 Sep 2026 18:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07B476B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:20:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B99FE140443
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:20:30 +0000 (UTC)
X-FDA: 85199272620.15.44C0D28
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E61FC140002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 22:20:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pQOpyQ3d;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789078829;
	b=ldiQG9zawnJoWCg3YogENgSV655nD7rute4PrGcQvN3ImBazrF3kvgXtwrRqRgwgt+1N0j
	Z8fkOJpLr5U+yMdpIu7KJBZP9vE5E0rNCC4gd3V7yZBvZs7XebuFxeMQf9w96eRRPgFxtb
	gxTINSBJJdE5lV6oRmL+mF40oodG3ow=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pQOpyQ3d;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789078829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9UFIgb3ZBn2494arYukIHix4iVeSBcOZDdAUi4RKeIU=;
	b=xmVxd5TvryRmmo/ceYah8yAYvmD2FuCEH7HeXgqzuYhdCmTIRXUEcNsKCeqnVNcVAUhsIo
	rrtvmGMNkIPmJ4vdTVnTkyt4lDkwMI37uLIuSRaU9AaF7TEDlA7wHACKZ74l1WZeawJ5Ri
	e8cA9HMcVhQsS1aAM/1/kjO6EVJvpME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66E1C41A61;
	Thu, 10 Sep 2026 22:20:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD921F000FF;
	Thu, 10 Sep 2026 22:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789078827;
	bh=9UFIgb3ZBn2494arYukIHix4iVeSBcOZDdAUi4RKeIU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pQOpyQ3ddtUYYsx/DIuFxpsJn9+J96AkQOaBNmO9PT/xEkAEiqCrXDIlDti8ey0U5
	 JlcDqbX8cBHb27zkk6p8U7C+RWhZVDLSxYHMmm3CO9x7a1yIwuMYKDGYeJ5FJPeSUR
	 SOeWmMcY71fqg7yvSLQcT+9YgtLckriBFImj+6EM=
Date: Thu, 10 Sep 2026 15:20:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Huaisheng Ye <yehuaisheng@open-hieco.net>, osalvador@suse.de,
 linux-mm@kvack.org, david@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: account for allowed nodes when gathering
 surplus pages
Message-Id: <20260910152026.5bcf5c5d7f1ecdcb0147ceaf@linux-foundation.org>
In-Reply-To: <8A0F6014-4E2C-4F07-9732-2DF32418B986@linux.dev>
References: <20260909074642.7308-1-yehuaisheng@open-hieco.net>
	<8A0F6014-4E2C-4F07-9732-2DF32418B986@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E61FC140002
X-Stat-Signature: ji3mr3bbpe5bb4om13njkf9octxzurfj
X-HE-Tag: 1789078828-584838
X-HE-Meta: U2FsdGVkX18N9wq6EqF1PJKZZ4+lAeH8d253v22HnpYcWFadKtmpKOI6ksgQ9kS/htgWEH7WFa/yqPkA5nR1KQOCdwHSO3/3H+IRT5Q7RT/3K2f+5upNTqf4L4K2uOiqWBzvS8Sn4bTRRlJAskFu5gPIWOhCpEWq25/K2/hWbtAtpbVe6WOfbDATjKXSH1GArjBUOvl2U2a+4qO83moCNXmvqEnq6tOLqglq7g7MWno8QDptbPTfhhnvGLJfn8vsdWvD1sbzD4iKgwJJnWk2GT8m8Q23f+AVLqxtMftWnJpyN9RsRM5aNSppXiZ/hv2tHH5brIviCpdbvOMlDxKVlQCvBb9qVpOI6znUT5Glbpbvf9tHgFdH8nP7/heErVxtDGeIRpZx1ODschzzLurlRfW9sek96JnuWbXzuVnbfNEi8V/4g3j+cYzg3NAFgkY2TQjmGIY34is5zGVm6rXEU5p/zDklZxX8Ivj+3vGHhVuPXz7nHeips1vozbUp1oYUf5w9ixPc/kmduQUj8opvcT+w2a1o5WFLfZfXwr7LrvMQcTgHULoDJ2dO6bpX+d6p5oaIet/W0ZDrnBaqhQXsjnTlX/6LqN58+ADDMnPexYy/OmaXimXY8FpyOk5Ju7f+AceFFiTuNL8AcUQlN5+HUPJOrbliNfLyRnB7dFcY4GtL6T1a7IHeYeMec0EySWQWWjmGvO3VT30JW5JtZC4Tpmp1H0X4Xw2tYxJ5l92q41ixSc4Paxweau76i5zH/Zh352q+lWgZM944xXg5bYoDL0SvV+wl5CJDxJJjSMGGe47yn44Ry+h6Z7Iui/cL0chPSVwd9Sv8Y95Slqa4aN3c+C7fudHPhY+LXEQZiEboDLcswNzXuFgUp/pah6Kgw1U6NW9cC5RBuSwbKRv5kWChdPQWKbfU9CnVymrCSRgo1+Trmll998STSMJCvOi2iELMQO5Ben4y4kntoEDyHIX
 6TP4hE+L
 5S3/rVrPEhqd8PTQBN5/zyHLmLKsWna7PwPp1WFnUmIcZP1ukNImfzKEvwTbyY0n+VWJkWVNZkywFmx8NN0mq3h8JVpFVc3TZZW9kBM4x+cbJPFXDiDWQoA1Vs/kqlPDAVQNU198O/MHDkP2yCRDenPcWeEkdkVkYc0OrK+re5UblRAZMrcQIGhDPc13w+BlVhN3PkEg+tbakZsU3sSKNtIewleSX8w+12J0OsY/fuH8oY9N7KAQK39PP++hHZo1hc7UM8EDaZwpjMOqLP/ygg5x/wLMkEk7qMyDUZ7ZESynZx59QI3M0VITx4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 16:48:56 +0800 Muchun Song <muchun.song@linux.dev> wrote:

> > This fixes hugetlb mappings when, for example, a task runs with
> > MPOL_BIND on Node 1 while the existing free huge pages are on Node 0.
> > 
> > Similar issue also could be found in ltp if the free pages of global pool
> > reside outside the nodes allowed by the application.
> >  # cd ltp/testcases/kernel/mem/hugetlb/hugemmap/
> >  # numactl --cpunodebind=0 --membind=1 ./hugemmap10
> > 
> > Signed-off-by: Huaisheng Ye <yehuaisheng@open-hieco.net>
> 
> Acked-by: Muchun Song <muchun.song@linux.dev>

Should we backport this?

If so, a Fixes: target would be helpful.

