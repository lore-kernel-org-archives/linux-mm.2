Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 315DBF588C5
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 13:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A806B00A3; Mon, 20 Apr 2026 09:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FC1E6B00A4; Mon, 20 Apr 2026 09:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611526B00A5; Mon, 20 Apr 2026 09:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EAD66B00A3
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 09:21:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0677E1B8EA8
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:21:31 +0000 (UTC)
X-FDA: 84678995982.20.AC24B86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 624A8160008
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:21:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aUSKQCb5;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776691289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0HK7frwjARxKhVL8GqaPdpDlZEZUSrYdIdZd63/Aus=;
	b=PvTfDoWktqxfZBs+fwTOI3gbKiHjcndRQM07tBh3cu7pPZjdk54gZ1D+wXXZcGVmZuBxg3
	MfYwQXkXMZvTOrGnSThlBcpF3quFvcjItjAZBY2OGrI96czCqeG/uLWBr4oEEbVegiGo+X
	/UfeMaCTPQtv9qsrnkbHKgpQZS3i9ko=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aUSKQCb5;
	spf=pass (imf08.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776691289; a=rsa-sha256;
	cv=none;
	b=Z6MtNjlggbOBk5Ns8SEKgoe/hm1spSoU/IXuiC6CJ62R8/umLH0Vz8oaSQVaFDknnY3tAm
	QxSpY+fzKm3FFjNLPTIpEz270/HJFohxMY6k3giBlDDG4vuu+seoySrH+rkbBjOUvatsm9
	jdw9YkvJylmNzie7PCFOI2KJ8Fe9zuk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BE3D16012B;
	Mon, 20 Apr 2026 13:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C624CC19425;
	Mon, 20 Apr 2026 13:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691288;
	bh=P0HK7frwjARxKhVL8GqaPdpDlZEZUSrYdIdZd63/Aus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUSKQCb5lzYnc5y9bqT1KdajP7aocbNePFf2Rubb/EhLLP/zYRibCoKU1Z+URFKbr
	 yYK8uAtOa2Zfsc0aIqb6mS9Ing7BVgUtdlNoIWhnT08JPiJ+FKM5vrcOGR3q0bzc6h
	 W4hCSFm1rClWBOD0hWSUED19kmU5WgJZhN19/8QPxCisPJihlWfrqs82r42Spw3Rs2
	 QOmizNrn/o/inREltCzUBPypHsUhPghM+PHkINe7bZcb4nSc3aB9oSoRzsAV2gr9D8
	 wTWQ1u4HnMgXuDlF5HKEwC/gFzKXDv95AK+rrDuXiSxoqxuWn7JhC7+BfHSwFrmlW0
	 py+WGwfZLMVgQ==
From: Sasha Levin <sashal@kernel.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	Oleg Nesterov <oleg@redhat.com>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 6.12.y] kernel: be more careful about dup_mmap() failures and uprobe registering
Date: Mon, 20 Apr 2026 09:21:09 -0400
Message-ID: <20260420-stable-reply-dup-mmap-uprobe-6-12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260415180623.199818-1-heiko@sntech.de>
References: <20260415180623.199818-1-heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 624A8160008
X-Stat-Signature: 3tu6qbg8s3s99tyhyioarjqqk8qiguaq
X-Rspam-User: 
X-HE-Tag: 1776691289-944064
X-HE-Meta: U2FsdGVkX1/zKvNMdgWUbvxWIfw7e6sEl3nkX9ROn7seeNbt0hJ8uWYhdf4Hjy83izxfyEYICIHO8jWqXYXNQkIC0LsRXtNYBYMtJjTcGc0/bcqdFiC6cSjwa68Twye8zRsg0Z11O6yA4lZyltV6a16r7u8tr4xY+uBPp5Hb6slacal2JyvaTVtwOWI6QF+87sCIncPCpU7LUUpjHkZr3gsTuc62X0YBiUbzu2w49C1NcUFfo5SppxgRBqYECdc3HOH3ZGZlH7XxmE4hM0aWCvjohnsIE8N9o2u/WJJ4s/5KpomXstOShk1Y0HrdoEPSv17YiT39nx6V4qckqT3RKtdYS4rIUvbPKpmO+ubQg2Gw1yXZu9c62izjMqRe3JgCe4v2QuPcEdrZXdeNZ6GbbJQ8aAgsNizPkHGj4HkCEagFkqYfgSvEhKTyJNmEYCIai6aXxtH46vWV1ie3TDV8Xs8JCMcbQBPU/0XurvIcQnOMdge/INhhoPVZfj96b5tyFI9RDVt9OWm/lpyMEHPdUm5zxPPDzk/eygAcEyUHQBwYpP1nFlc5AxZLE/lW0EkTS0CaAhrMlwT1kprV3mcYo6FY1JY21oerDCTLgVKbJ6Ry/9+AjDeFvTZsqMuEBbKndlq2U4YvehdOHz3jUQIwt7/UVYzwdyGB7OziEMGdAnJ6RsUvQAjcTmJNS5sX5r6HmW/IvweXoihQPPZtNTBsjg3tv99stKHi8sa7PQtxMFcLlIMRwhLta9ZXmMeniOk8tgXWiBAc6w54TQ68j/5gfgQYqa1JGMTUOhQ6kmj0LGm5ncK/VoZuxpe1DPpu51IRT/Z/veriNfWa7EdNk6nOgS3hE3idWieX7ug0u50xjzNb0enobSaNcYkwHPd/lE/ugRRlLgvHrlc4autE+zf8Bf284xLuw7uv/8D6h+1R0bQtZGnbI0Wsf0R/QuL1P4FcufMg/Lgz/LLea/Vsk5t
 tzT1Bo1u
 bOOqIXo0/6uMSRvBt16VSXIYQJXqEwTkNEP1oY/I0KUzLzd4/Hh375fdFe0RHH/gu8rOzG3xrZQQezmKHYlj7ryVKaXNCsiWYTnaSEtGP0XP50V+Vova/L64M9AmUKhaeJrC7loZNo1zKK2Hy1C5mZM4qR+81b7bGEgpwnWtfs0f/1nTG8fnMPiz8+ZuJ0VPzUCtF2eEHDS9K7EM1+oxAaxr7jXnkSPhwEGM5tqkvXgvMCm3WJODMZcn2K9bAU6qVzQkK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026, Heiko Stuebner wrote:
> Backport of 64c37e134b12 ("kernel: be more careful about dup_mmap()
> failures and uprobe registering") to 6.12.y.

Queued for 6.12, thanks.

--
Thanks,
Sasha

