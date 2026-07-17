Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7CFFC44512
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 00:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E7906B00A3; Thu, 16 Jul 2026 20:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE886B00A4; Thu, 16 Jul 2026 20:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE536B00A5; Thu, 16 Jul 2026 20:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA0F6B00A3
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 20:17:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB0721A0397
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:17:09 +0000 (UTC)
X-FDA: 84996353778.11.5D56D4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 40E9240008
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 00:17:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Fn/UdO/L";
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784247428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+q9Sl6qva88415XBmVWr9R8yQ07HCrxjpADZtebEU4=;
	b=Tc1sEtGUEJYjsc+BEmZW32JuuSEVNWsfFOBg3vgtPvcXBrI0AV1o08Cn57wJit+8rD53Od
	E/gRe51qHxyWEymQmR0TBe3XxU96swEb0ai69TbmBGCFu8OPaoJkgCMvVCN6ZOo75U7ynN
	jRIaC2rBGnHpULA/wVceXRwuFZe20W8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="Fn/UdO/L";
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784247428;
	b=3nog2QKJUcthd2oiDUd+LkcBcGPXiPCobl6uSeJIUGozQVshI/1l4Kq7hNSb7uq5VQav39
	g1558olOSjzIycHdqgzJe2Z4+EJmxclRN7zpVSX47bA3gsxk5fE/5sbONcysCJczaOhxqi
	s+zsThtB8Bftljh45haihafs6m2MFvQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68DBD42A2A;
	Fri, 17 Jul 2026 00:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D76F1F000E9;
	Fri, 17 Jul 2026 00:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784247427;
	bh=8+q9Sl6qva88415XBmVWr9R8yQ07HCrxjpADZtebEU4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Fn/UdO/LlxgAmHmJYH36kyVLsalSjozqWnBal9NP8ujp+v4K9rfNB+Jdn/rKceB8f
	 hnLgTxlSahJA1mZ0vCixZkrEkij8lsC6WtSESPN6WqK7vrBKfD3zPOxtrmuHiP8WK2
	 Qn4zNkKudXV7a/vbY4IrS5F8ZhDU2JVQjt3y2LTo=
Date: Thu, 16 Jul 2026 17:17:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RESEND PATCH] pid: cosmetic changes to alloc_pid()
Message-Id: <20260716171706.eb0960e36bfc2a8ceb044933@linux-foundation.org>
In-Reply-To: <20260716141130.2573188-1-mjguzik@gmail.com>
References: <20260716141130.2573188-1-mjguzik@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cuoussrpggu31jggxtcwqtpdkjn9rmun
X-Rspamd-Queue-Id: 40E9240008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784247428-234919
X-HE-Meta: U2FsdGVkX1+CuGKeGYJFkw7oLeZtGM2uFViDROj6zoiQX2LNprDrMZNcPTOarKQplxWCAznmIDWy87ENFfSfIpkR/guNsltFHDT1Bwcst2/jgM31NJIPU/3DbkfOAKm17zfx75WVIIrmv3M6zryrNaZwf3FfddSyKVPnL5vTsg51hKb0O6y8JfAoVAIGdrS1XG4laEQ4D+TFW6LQqXNNXrqCaNM0bCgSOQp13En/1aduhhIFUxNVg8vQqMkSiJUl3GQdmGlmDupAxp+O7M2dxVN6zSNIyEPavdzcHSvFgnFplfsvb/coIDhclKjJQT1ONeGprQv6umM8jbg10VpU5VYumNn9nDccark5gpLkGKbwR0QsNcOY4rJfb0evAg6Zlz156gf8iZY0H8rVkgY1o/o+S4SXSSaxoiCgaAY5ZtVE9KB4lq2fUEzTGJC5BvqRpCEr/GZOLbcDYla2zYf0f4WwjTBfSia3bKA74+V2PuJnrl2L3tI6vYK2h/09hg3fxNqifR4YPWaJ2wLRhsytJBgNRlPX+LBR0RfX6A2WlPBKkjdQE7Ec/WWWTqg3pnCPINTGD/+ES+8h6YlwddPR8FLOzivYFJUzOEHEa0IuV27IqgMmAKzx4RyZYcTXRbco2hjnC+aZzsNAZ0prhAD6BZbDY2EYgTmVyuw6D00sYODiDJ4l91bBOQTIeNmVsmoIoYyLHcgQhcZk16Pb2u8yVHJysDd8OaY2UEK5916LUJbnXQfUhYNpYHnaEhNv4D8yG7nI+ldj+9RoSw7lHFc72+LNVPxSefkipOKOTJk0XqkJV2V3D0FVQw4y6UdIJ+1C2pqhJa+5AwV8cOCEW4pjPQxueMNQPKBFi2LV1jmw+BhpCMfXd42iAHiY5AwPErqY3nbmc9UzYoOEPG7N8qNCfFr6ervm/WQW7bmsdzEQTua+QRCyohwgnbMrIXprH3vsYjt9Mdhog4aeQCisYJb
 97j1i4vp
 nPP5/bGz97S6Fhr26EjRjf6kmuRuJF3Ivv7Z5fyDPai9SxmVUpai4erPxntfnO2z2Vzj+QukycyGTq6Ho5/UCIOquf1X5XjXtbrgtmfJeO43IwNlXt+isZPjopHcs30Z6kDW+PJ6v6qjjN5nbijM7hE1DdRsItXVCWSICaFzeLHRugZKhHiqqa+NLbcOH6rTtaZ6Xa1fAM8BYGY+4mVm2Vmn35j0ZZnYs+OJ01ZLEy/excIB4xs7yc2bMedHAXo67T9bDx81zIu1QHYgsnS2vrPdyn+a+Y3oo43Mv26aCWf4tmpBHkn8tMpNK3D+inTh2o9nS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Jul 2026 16:11:30 +0200 Mateusz Guzik <mjguzik@gmail.com> wrote:

> Commit 6d864a1b182532e7 ("pid: only take pidmap_lock once on alloc")
> landed v2 of the patch instead of v3. This patch remedies the problem.
> 
> No functional changes.

Oh.

> 
> this is an old & uncontroversial patch which fell through the cracks.
> Would you mind picking it up?

Please prepare a changelog for this patch then resend with a cc to Oleg
and Christian?


