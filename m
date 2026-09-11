Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74E5FC88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 01:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE946B008A; Thu, 10 Sep 2026 21:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FB16B008C; Thu, 10 Sep 2026 21:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091996B0092; Thu, 10 Sep 2026 21:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D16E46B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 21:59:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F06C1A06F2
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:59:45 +0000 (UTC)
X-FDA: 85199825130.12.5819CA4
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf14.hostedemail.com (Postfix) with ESMTP id 771E8100007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 01:59:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Ucyt/dbu";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Ucyt/dbu";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789091983;
	b=F1T2AT7XSeb2GSnDKM62sxesDHpQL333IwRW+2zJHCclQqUraOkksrFIhyrjFxsnMlq24m
	AnbUpkOwU8pG+GULp7lWt99rjoludjIY92noRvDMF9Th6P2bFWPOZtW74VIn0OkN13NYoz
	B0V4BdqmKM/6HxxqtQvmSYOwrnF7dgE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789091983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWwhsyhtDrdmnn0DmmaTBqIJjC9gQOjB5CQ4+dpEieY=;
	b=31ZYBczl4WsrrFx2db/rINUbEFFYTkjgkfpD6S4HzrUPOZABsNaHK4Nq9T7LKRM9QNQ2Kk
	rbuCe6VJshlgTc1rqH54U7PSqAtB3rGjMBtsyaDUZotY0TUfKqa3dvU22KwuCkgvJRrzfd
	EAXaHru/fksIi/aG9otQyP0gMVbjRGY=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4bdf8abaaso438901a12.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 18:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789091982; x=1789696782; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EWwhsyhtDrdmnn0DmmaTBqIJjC9gQOjB5CQ4+dpEieY=;
        b=Ucyt/dbunQd2UDoCe0OMMrlbCcSgOWnihAbwPsoIRDiTN+SZIejVMoj6HmLLo7X4Tp
         fqFhme+96Eoc73jbc1qijs8xN+9eNy0NvnS3LR2ZmvvNpTMfNWNYjhjZof3t82rxPRA4
         etLxfNDqJQpSLElgLlGYeLaUD/p/c8nGXTvLCYMQlGuIljQ/XQislZ2kbxoM1d9GHZCb
         v0yPfTE9oHb/BwptF0fdBRdbNzokgTIgX3WsutoaeWyPFAPgn97olbwnjW1bfOAlRqRm
         PE5ARXB2jM+mQeihGVudCVsS4MYWi2YmzCfQdOdF0X+V4vz3x2SxjTB9sHhr5NyYTunx
         mTBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789091982; x=1789696782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EWwhsyhtDrdmnn0DmmaTBqIJjC9gQOjB5CQ4+dpEieY=;
        b=J+cVQmBtwa+x4FIU6a18CDZd+OjaMous8/tAZ+Xk0a63ShFSKiH7Ls+lbD5qjL1Wx+
         1MLBKRyOkv0OT1fC7NhoJxMklXId3bPVN0AIC9snXduOWTbXwotDyJN6+E4G+iPhw8u6
         WGfc8iQZncoJMiRNzbygbLzRtSVmKHA8OsYThiW1mTmTftDf1qmRBu+0HDSotklgJg/h
         yiOxBFtx3vZOA6IClLfQhrIzhQdKGs31LPXG6InObKghJZlcZl6G64txrWXgmwWzWXok
         YJAYXUW/ZBp0RzUl7DqNdvXYrXGlTRwYAAK5eGQCOjn+0BwyP7b6+98C4ZGrlmDqVM9/
         hNmQ==
X-Forwarded-Encrypted: i=1; AKwUvBzVRDmIxKUpG8tt6HFTfYkd7fVBMaANRO2NnXta45v1uDqBBx3Nt/gSDspDyMOxi9e+fDLrf+FW5Q==@kvack.org
X-Gm-Message-State: AFuF++nhvApHpnHF7xVnx2CCU0MIarwsGJunjxh4Xn9ZR3t1Ijutn0IT
	ZxL3kbKXpPk+Ch+kM0m2VqMeI2mj37/pxHF662/LmJ8tRi61jj9eRNjU
X-Gm-Gg: AYBFou1XJh88yuYmwwMSmKm9sdNmoYDF150zU/eaGWrWrhIMKIoL6wlnZwz3f1UrFM/
	5u9S67gTFfJVVhweyf/8wxhaNKf8GpN/M+DHYX/4MTmz7+bZMZB/j6Lk+bjw74tZyjiR/9OTIvc
	fsy5EQBnR6HuxLRZWyfTxACYm12LocqbIC57nhFyrjjFZv6Dnubuj+qoYOCNR7qPaPHyDOvFhQb
	5KTBoHhFksup+paCMAVQGSeC5ZgMKXF8OJ5WQk60pX7Kyw6olNufuG7EibdlBRXpb/xv39dBwYf
	2JuRJitAtbLa1ro2fR+Ch5efrHkJLEHpayjvtRxRnaM4aG/UTePL3Ez6bEkUwzWZ4vHzhzwrdUS
	muVwABtt6RCPIenYLFaXa0M6jvm26jA57h+iqV8p8zAfBc+iyytcWJZkOYebNeztLpchZzY1L4G
	SfP65am4aKnbbOBXB5ReNyUL77qazEZve6XgHUMHODciTdvuW6ASJpOu1wJedZ/eUp7AbgBRvlJ
	s4wFCPnJO9KC1eci9CiNSdVK25rEYrHBhjVMwcbfoFZCiYOxYA=
X-Received: by 2002:a17:90b:4486:b0:39b:61f1:8032 with SMTP id 98e67ed59e1d1-39d9c2346b9mr2602488a91.16.1789091981922;
        Thu, 10 Sep 2026 18:59:41 -0700 (PDT)
Received: from localhost.localdomain (vmi2317697.contaboserver.net. [85.239.239.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d994872e0sm1777738a91.8.2026.09.10.18.59.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 10 Sep 2026 18:59:41 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH REPOST 1/5] mm/damon/vaddr: support prep_probes
Date: Fri, 11 Sep 2026 09:59:20 +0800
Message-ID: <20260911015927.37424-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909140408.104699-2-sj@kernel.org>
References: <20260909140408.104699-1-sj@kernel.org> <20260909140408.104699-2-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 771E8100007
X-Stat-Signature: sgdzbnrm8s787q9un74wbe3f8qpn4j1i
X-Rspamd-Server: rspam01
X-HE-Tag: 1789091983-442940
X-HE-Meta: U2FsdGVkX1/kmeth1wMTHciRIBf8tECE2Obknwv3xc2surY/f9IwiEqeCdT5gVabcoRGg6BM5CHf2vxBLNJyrZko0dEldpgKnLJ24ht1CTXlr1w0TgaSMFxM6prea9508kpWrDM1bPrqVFadBbey/3skuuEHuL7egK3CVpq9ZkCdPi+I/fu9qaLPnF9ws5fBH4ixRoQJ+7oYd5tsZ5bl3FR659WZZcNI0FJaTi84KxAm6swRrIA8PLIzSHw+TDfK7Ejh1YdEVEndqbaCJXVhE/IB0SWEFtzpvB5or6nW5StDkZKOjbCk1QLEQiu/tWexUWtYKTe+Daeo48OuYpXTkUh75MKkG3pP6cHys/k5qum0LWGNXPQkZIYrsN+k24LF+fjbUJNq2K5A22pV5EhM/fqBlGPo9wxmev9vMsJ3ldOl6vfpNF9fO297BsAQzL6J5SQHMtSYDF/oC1qvk3yILPKKPpdzdt1AF/l1pY2c/Rd4yR5GqaYmgEGgvf/ckDtGa9puRdt2yisPNlMrBM3ih1AjeRxlZlX46vAvbRkdLlZ7kVyOd9Q0BzfYrNF8bfdnohPdqnMXwPqjagzgB8OadTxR3wLBpzFOBVjzPh8yROdVtcOoY+Ogb4RR0uGt0jQA1QvAQtM98BUbU4SmzYUCtXK53p8PWgmuDDTaPVrhkSm2x3emBNlef7PE53KlLhIdDQ675AbsldMyRFa/utTlcmaKHNtERBWGE0dn2AFMvro9uWJcoP4tINoRs5J2N9Kcd4BGvhAgz/ISigCAipb+SB0Xk7fMChPvyL1h3DbCYcA5N1caw4Bai4HlFye2QMLjHGPDgx8mZZFS8Ql6nLznZl9KywMGX96ATKUgcWP2/AYR+G45sRFHVC9Hp/Ve/rSvHAIf20aaIAfOSzn0YPmud74JqIooZ1yXNA+8wHiov9L0KwwqqIxlhXSFCZlq6oyscMnVYK7V4NvGJAjRomq
 94fJa2oP
 grEDeFTJ3zDsIbLjuebAQNbSLk09GKvtNkPwFNq+dQ2p3jVT4w+4B45BbX4CB/2OOaktfcxt0eSvrvKyF85k3G/vOUCRNqOjR+gHZl3orJJTkA51apSjtGjS3otCGKlotu1Rj+lAny+KqtbDxg98EdMMQaUy36qz3x71kOSDD/Sr6qBR5df1rLlJu59JuiX7F09znGrE7w+Y31XFB3swdPEKGw0vkrBnYQPUb8zNxGYrzQ4w8IzS67CizDyku9DaBe5eDxL74apguvnmfLtMfRq+9UGjUs4Rh5SB6uycAm7l4IAds8xVX7ez1rlhDnXoHg98/8p0QnhJstLZDtdHK4q9/8nQGfJt87B2xWo16ZcZEDOywpCLlK1r+IyA0I8ZnWDyIz5RQ1Gl3hFL5viXjSW08vnZMef8j8iZRMVMZp0nm7Dd+LQO3RczX5SF0rCNmOkemUlyofMSBIXlLNYMRCQ0yb1OoTNk+AlvvzW7Dyqj30NqK9OrVSwUUvLqyQQoZ4RPRZBEBQY4GQBA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 9 Sep 2026 07:04:03 -0700, SJ Park wrote:
> DAMON virtual address space operation set (vaddr) is not supporting
> prep_probes.  Add the support.

This looks good to me.  Reusing the region's sampling address and the
existing damon_va_mkold() path keeps probe preparation consistent with
vaddr access monitoring.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Thanks,
Lian

