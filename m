Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0506EFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 00:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490286B008A; Wed, 29 Apr 2026 20:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441166B008C; Wed, 29 Apr 2026 20:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3570C6B0092; Wed, 29 Apr 2026 20:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26DC46B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 20:53:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8BFD120356
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:53:38 +0000 (UTC)
X-FDA: 84713399316.22.32F0B65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 335D014000F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:53:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qpj3Qm0W;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777510417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lluSXE3vvfV526rFQpqQ7b1j1RKq38N7BBtS5egvuqs=;
	b=o4pdfYgUO0hNdhScV8CeaXJhv9RqhUAd9gO8o0t/6S9Hez8zz7b/MaVKJaR8ken2pNEWHD
	piipilJmPPEYAf7UFJyXFiYxNfpXst+L3urzdw15TtPVzbDfGY2QJKyUSY8dtf3eXwiMz2
	fPrUWsQl171gLKEOSzSBoqa2rS9hEPc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777510417; a=rsa-sha256;
	cv=none;
	b=8N7SB0myggf+xy+4HtOYU9/Xm3RT93RJmVdeN83+Ufn03oELDhLAINxbcJ05hpA39L4k+Q
	wcmFLGmkdzEuvr4PcMwye8jqkKxcR4An0OQ/81UC/MRtjJWAbFdgFaouQnu0SS4m+AvW8M
	4rjMWavm5RyrlSn8NETdDhoiGyCmoVk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qpj3Qm0W;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 012614368E;
	Thu, 30 Apr 2026 00:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A759C19425;
	Thu, 30 Apr 2026 00:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777510415;
	bh=zjCoBFwYSmjGFkHi/Pxcq/dfA8Mbal7PpAw+Jp2oKko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpj3Qm0Wzn2hcQstA8JGWaprxISvZUM8AAu14+3bt2qhRgD8n6juV6/vNXPkVkBkk
	 kZDJ4H+aKjZf+o55CixvCLSMYV6IEDl5kj09gJs/bH/72ASNq6OGI30PRX+sLFVCDg
	 ohW+ZRr6QBHWRYRRkypg/1GHW1JtUwBvGYtqo0iodkPolOX/ETKSriP6lXSBlTT6mR
	 bsUqfgwMbL6r0co6X2lmiEiLSQZskYN/ycTKc6YW33cdEnP3iIjkbwC8zD0B8bqVAw
	 +RFONzK2h50YB0Rq3AaOeIkfl4APevD6ZuVMlPk30pl41TuqQkcFpwYVQwJ7Ke5ISG
	 L3i9nf6gEmjaQ==
From: SeongJae Park <sj@kernel.org>
To: Manuel Ebner <manuelebner@mailbox.org>
Cc: SeongJae Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 1/3] Documentation: adopt new coding style of type-aware kmalloc-family
Date: Wed, 29 Apr 2026 17:53:33 -0700
Message-ID: <20260430005333.113698-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429071445.309733-2-manuelebner@mailbox.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 335D014000F
X-Stat-Signature: w7fraifn3tikbbbok9xb88q5rtxa4fhx
X-Rspam-User: 
X-HE-Tag: 1777510416-796784
X-HE-Meta: U2FsdGVkX1++ZqhTVTohws7iH5HBOE8MJjOjma/6QBKxgTRqT5goccmTfa/HLsWU9LzF+7fXDzR4PKwm6iTZYwL07SMzh3eyclUNoasm2yjdCW9juD1TZBDTug7Na8xpIEXQX0LlsX+dg2RQg3c2g/Tj865gHx4gvj2L9iCj0GCxvTjcVDYxMBAv8g5KNXPgs5gIdH2puLN/US5dydqV6AypxfVmD+bIulvkfU6g42+51/Vx8BVYe9hheArpj1vFkOn2yvfJufqmIet1ljzwzsvThSdRuXfBc/mAOw3A679a22DAdZkgKJd7Yzp0vk/ZF76HAl6ITRT/8YBTCfTldKIc4/jhvVux5t5Q/Do4q7Z49iw9Uu82amfVAPhb4WYGBI3qbadEwoslke1qwU3siQEBQSX2WncDqWqJEpXbkB0dQpH6TwOj4+JBm4LMicRHYWzwYZb/qV/aJgi5RHKbdUOk96uzboORLcB4BINoXNYI/ZcBcs/uWEDLsxezqOIL5QL5PPNUGbiftsLr1RBwRfujtEr0k3iQr4Ef1zFfJzVCvclA2IMFUU3XNLaKjRKMpewgfvLwnoKU/l1ITyBJ96VEt4LWwD5KIgjZH1ZvGIrhdl10s4fvdoCZ7PBpqBvB7wuVkmnhsJ9bwc5IkddSMU0TOd0CzMDR7h/8slCpbaO1/ymlv3pUZl0X9k2XJUzmeYR/N+HOKtRl1WVunkugkW8tqX16msPP0Z5vYJnNHmo8b/AUA2f/fBP8uVJSSdS5f6kSSk28wLYOkvO/wzO2MvqpUzGFoxvZG6ILDrp/HmRlYsukAKZw0FQfdQvp7wGs7JJ6orCYMGRIO/HHLSD4E85v9TbYzVc9AduK/PC7whjUKPsw+0veAvZnstmM/y23G0PP4rhsp+7g6Za3wxpLJU93Rl/mcoWQ9JAw+Sw27KpO1652GD6dsF24Eb38vz9D89tCcjTRTGIeacXniCx
 zMiGcYgF
 emgj8UTbLGPDzuSN/Bx0N+v1vcLv/FIEDhOyj1KCqGZRUyYyQXqAz18oOpbRZV9iu1QKFsFAMo+lqperwGvcGJqxtUupZQ0iCg8MXs7TXg4V6IBmmXbKJEkOWAtgGLBZ0c8p8N9MrrKeGvRicNwUBC7qMGFgzbrYCQacIiV8RABLXKTOCSKcR6JBv6+lyDT8WSarKuHM7RlmSHRklkoQKaRCpS+PRkSb4mvx4pbZhXAUGdF2E7vogRK8xsZY2Eys466vhM5qVWMNAtu4OKfS1FClnAe02ld3trz5l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026 09:14:44 +0200 Manuel Ebner <manuelebner@mailbox.org> wrote:

> Update the documentation to reflect new type-aware kmalloc-family as
> suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
> and family")
> 
> ptr = kmalloc(sizeof(*ptr), gfp);
>  -> ptr = kmalloc_obj(*ptr);
> ptr = kmalloc(sizeof(struct some_obj_name), gfp);
>  -> ptr = kmalloc_obj(*ptr);
> ptr = kzalloc(sizeof(*ptr), gfp);
>  -> ptr = kzalloc_obj(*ptr);
> ptr = kmalloc_array(count, sizeof(*ptr), gfp);
>  -> ptr = kmalloc_objs(*ptr, count);
> ptr = kcalloc(count, sizeof(*ptr), gfp);
>  -> ptr = kzalloc_objs(*ptr, count);
> 
> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

