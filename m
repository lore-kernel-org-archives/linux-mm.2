Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9281C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 12:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8707B6B008A; Wed, 22 Jul 2026 08:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9D96B008C; Wed, 22 Jul 2026 08:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A296B0092; Wed, 22 Jul 2026 08:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38DC06B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:13:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA3A514013E
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:13:23 +0000 (UTC)
X-FDA: 85016302686.18.AAAE31A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 085C32000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:13:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aouxyucj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784722402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCttxdAeMIsroKhcP8cJtajan0gS6ZcUhOF0G0ErDv8=;
	b=laY8E7REmZy/ZcHBp3xlBHTnPoLz+kpQM6cS169gmYrniG/vePW2DBxudGQq99uXxjou3t
	Hhqtkcboe8cFpKQtiFe2/4E1DRq2gnZAIITq84agJZMP8TfePV92auKafqmQoC26fWPZBJ
	WD8BsY8y6auyLpYNkQDHMRG01g8kzNE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aouxyucj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784722402;
	b=KuHLOvpEqnpZnB7AmUFL9mQIpfRxd0uFuMBeuh75idO911sukfeqIeeglSI4+I8s4Tqbbf
	P7BQahIBloGWrE9sGpRhwa1DhZ48dSa3dJnLI1FwxmZmR18XVhSYl7h6giJ6h2sI4v4Xco
	gxmBn8VuijsvwTUxATvS/fsAzgUhpv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84BBD600AB;
	Wed, 22 Jul 2026 12:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4939E1F00A3A;
	Wed, 22 Jul 2026 12:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784722401;
	bh=vCttxdAeMIsroKhcP8cJtajan0gS6ZcUhOF0G0ErDv8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=aouxyucjS74fzbW1XeRtBu20kceV/YlDeEuU3d6x5pkQKaldA9GyS3MjMtdCPMDVV
	 fpfhETFhkX+GD6zhMPgZyulHnTRKg4E2111/684LGGpxO9MQygy3IMQjZKy1wbng7v
	 IxAw7lOUCSel26k13/EaSAP4LEOGdLf2+FrDY5TZzRte1uzfEOweLqoFXMWUcyDnl4
	 Z+vXpG5EN+VHs6tBE+hkJ/tvIHSHKfNcRuDxBwQHzjb2Feq8kWBvbsgmXXhD/uukUc
	 jFUV/nwbb6SJtPOlJiUlt3AN43KHOqYm0StoFYIrdL3bz32hR06dNVNfX94MLEarQk
	 +Mxxur5uQucUQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 05/24] binfmt_misc: use RCU for the handler lookup
From: Christian Brauner <brauner@kernel.org>
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
In-Reply-To: <alKzv9cAGT0yqSW6@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-5-a162f7cb58d6@kernel.org>
 <alKzv9cAGT0yqSW6@lt-jori.localdomain>
Date: Wed, 22 Jul 2026 14:13:16 +0200
Message-Id: <20260722-appetit-nordufer-echtheit-d08a5965ce78@brauner>
X-Mailer: b4 0.16-dev-9dec3
X-Developer-Signature: v=1; a=openpgp-sha256; l=296; i=brauner@kernel.org;
 h=from:subject:message-id; bh=vCttxdAeMIsroKhcP8cJtajan0gS6ZcUhOF0G0ErDv8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlbL7XuPai8qXFxyYd1eWY/sX66OwbIY4HZ/KXXNfff
 aNNU3BBZ0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE7j5j+B9z+FvYWsXL7N9c
 L+kXMVRneb3zFnj3SuWTtPTDK71dW28zMhxvVk2ckhxQeOZK4g+WkLNP/pa5xc5ulrjln7k5/mw
 dFysA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 085C32000D
X-Rspam-User: 
X-Stat-Signature: 9uwo43k3z4eqkza98s8coaj9m7mqo6p9
X-HE-Tag: 1784722401-572589
X-HE-Meta: U2FsdGVkX19tjxyihiI3Z78i1qOSF/nBpJEc1+IPZjDwSkeDr3m6R2rAWDXoNox8Sjo0PpGX5q3ghmwHDCSMg48MA33g5xzgLfJyTO7nz1lP11HGGWF1VsrI0r1ElrCTD8/Zf7UjmwWSaTYJvM1GfiYcM/lJsZt+VMq+0x0oO1Zv0dRjUpJiBK5w1TON95liufpgoVCOo63SgFXH7Qrh/VGnc9ZqeUekDwiAHu2d9fAwhBfEcrkKDi4wSYkOV2LhvVnJmkOYnId6Cas/9e378efu8huucfXuUPSmdy24uM3XVrZ6Gzog8ngAeG1r4M8HrZu+Zt/+OkQOekVlpNDlCEOOjBhoup+FqxGplc9/EMvIqQu03kzVl6W4ppR7uoMFwEfaQI7368hXcGCnzSutteGJ1LR6+128d2KUqQ7lL5L2LIie+zF/mb1bMsI3zMET+hbtG5Cgb9GpWOLREqJu+ef0skE1XZZpRcY/H1lvC02ECKOB+6+kIFWITAVCKV+tedxPiutPE6PlTThAGjtBVUz9hv/MC76VltiTzh6c6CROXx6iohFIKZGG4eJkM9iVXly1dO/y4XNsSAN59GGGqMbQu2Xtl1/OCUKiyGAPC70MZGUauAAiEGMlTEK3lhOiGcCWuHSxebC+E8Z4HC1iKoMQ7jhZ5L68EcibID8pxQSIP3gn5cvdscZkBFGv1u3bpoT1nRrDpRjzvCPDWQwHjW+d+8bQuqYYhACcv7rxmDJCt/G4Ffq2YPnaVtpUnCrDYW5HQ/EM3fJwWYWygkKdLnFzAroUDaxyf7JeHBixi4M2bA4KCnbDOgVQUgg05vL8om3CNTH/YHln9IJogq2i3j6RFrkZwdDR0VfscNIDUtpYOH3+dEALCtsaqDc5CBhGprSjV+ieJOdxqGxUcp/JVIAcaP8wru61EVBeazDfqZwEskO7YXfAVkThnkpLERnJmsXo7JdL2WidvjQU+9D
 XWg8dZsn
 6IMqm/ZYovj8P0GPng7xNK/jyI+N51HXco6KpFnpTYwOWC82AROHUP8GepNNGfmGsdzhpzvtSxJrzkU5RGLSj7XtrLMAT9Ym9cXoGxnHZLK0SQ5PG81vuxE4TN1D7u7kk4XPojVH5dlFqwtcF7+AAmNS3/vXgexvvO/vo8p4hZO1CVxL0gaoJL5O0jeeF84RfI9Jrs5MGvTx2oR9TVHgxv7CPcLM4HJ200c/gbH3wnRmG1Ve/oFO7pvFbGRSITf1BXzht3ZcttwXQpm8wPdimpT4krk8auoruP/O75RQ+ozyQvLDsOIxra7zbdNgMFqwYMI0z9zZom9GI3QTUkbWVkIRmy1sYAN+rRlS1BgT4N1a3SlM0ThCAc0QSXeq2kHzCV+IE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> instead of just for clarity. Unmount cannot happen while we are holding
> a struct file into that mount, correct?

Yes.

> PS. Let me know if me reviewing is welcomed or not. Obviously I can't

In general, review is always welcome when it is in good faith and
targeted at the code. :)


