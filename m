Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA06CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C339B6B0095; Fri,  2 Oct 2026 10:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3F06B0096; Fri,  2 Oct 2026 10:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA366B0098; Fri,  2 Oct 2026 10:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FCFA6B0095
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:20:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20E464063A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:20:11 +0000 (UTC)
X-FDA: 85277895822.27.CFB9B2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 81508100002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:20:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eASxa3cA;
	spf=pass (imf05.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790950809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mNva0dZ+Y7yZHNv1JAHhXIkUHu7JycdybK6trLwdS9A=;
	b=GMhJvwZdbaDiSzWQzB5man+TirRehKGB4ymiJRMT5rr9dDKZ3gTjPxUxyn192CT8rKNxRd
	vKYBejtYX8kHDAA8cauFy7M7JhQrGJrKY22o/mJ4K52IHtwTEn7C39omVHWf2UWbW371MM
	dTA2Wtl/xdwB84YoKJFKxKcboaRzzng=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790950809;
	b=RIXCkGRbSqkYM5MR4eC+6Lg5cGx8ol6qFY2WgYc63C/lYDZzWfFORoOP+udI8P7zXftbh/
	95MXSWEsJ7zZSqJ7Z2pOcw48odLVFVcA5HUXY2W6bCoy3K4r5hx/xMZ6gZKW70Z/Q8vNPF
	LnCalcZvQ2YEtNjk40tfAYDY5SGK+Co=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eASxa3cA;
	spf=pass (imf05.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B2EF843F57;
	Fri,  2 Oct 2026 14:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03A21F00893;
	Fri,  2 Oct 2026 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790950808;
	bh=mNva0dZ+Y7yZHNv1JAHhXIkUHu7JycdybK6trLwdS9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eASxa3cAfHazHMoBvaaabN6IZ4d4+69FZ/3JnGlpx2vA+4cweLRyK7xdYvyeeShbE
	 YPbJjUoDGeMmV9p6laHmBPOblasPNea7u7yHXP9UwByAP4hzZY1rsuntvKzc9aD9dF
	 R091cWK70jQwPfqFAuPooGQiXokSnMe4+Yxl1IYYtDVyu+arOxwJebZhWddNhi8w6c
	 2iCfdePMEqjMt4fll8F8hEm0jFm8ssHJi34szAVLM/Zmcg6Eg10DtPY9HBN/zqasw2
	 msxvmk+W5RFMwyKN99POHkOKz5zxjVxrEHBc85VniLVEFXGH1gAivdbJ05Y7nqm0zk
	 O/PN9DLTsBNiQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	rppt@kernel.org,
	sayalip@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Luiz Capitulino <luizcap@redhat.com>
Subject: Re: [PATCH v6.18.y v3] selftests/mm: hugetlb-mremap: add setup of HugeTLB pages
Date: Fri,  2 Oct 2026 10:19:52 -0400
Message-ID: <2026-10-01-1-daily-reply-0008-re-hugetlb-mremap-setup-v3-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261001181330.684841-1-luizcap@redhat.com>
References: <20261001181330.684841-1-luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 81508100002
X-Stat-Signature: i1fnaurqoaay183q1hjz9mghc8jmf4s9
X-Rspam-User: 
X-HE-Tag: 1790950809-374174
X-HE-Meta: U2FsdGVkX18mSrE4oiEX1v145hxpsaHgRNhHYacWDQvp8C+8nViFrzzD/2KJ0JEd1zSQSJ2lTZfa4I25i4s40OIz06Z4Lr/00eU6XPFo6tfaqCOw55mi4orRvamMAH6YJ+2KTfkIJ7ecn5Mn427OgA65GRE2QIA9kj5Iv0N5VyyzlcL+UluZWmtmE/H3ikxzlxkRwkZMEbs3MqznufSY+dNWajt75TjTs2xRu4AIX6WvFg2TKW0ed+BATLt/dUw9EeP4MaArUZNwgUiWdvAQnpad8p+Exg493qFgPvHEwp8n44Vk5HQZhCOr1XELkDIf8TS2I6G0UPARaCIZ8Nj/Nk4HWmLOGvbyxxs/MXIZd21SKZtLuJLDYoxo7zEw2P2DF6dJNiAwqc15qh7OucuO8/CBApumA4imY/LMQ8JZ3XVUGg6NGchlj1gI+hlPpea5Cks4CbD67btnSIm0jwyOgmApmlhzyntsoKrcj7XBDX2UeNlnyV7SrIpQZfcJ4NxczyYdP3XVr13hp3lmA4hlPpgL/JWfSJf8PMQcSljmHct9Y4hGGuEbelwtiO8+OF9WgytdICmyfSz1sP6fjbR/5lWHEOCN0WWQEtfc/YXS6IuK3q+FoL82aWGx4XzUHFAQlUwEByLFquTyf5USFnNQ/ccderQ7mMUcPaCrHAoOMqhdYmbsBwQbq3gWmzfX7UjMcAp7XEzytR7nAEHr2NZa+urIQtoAdTILrMx9gWqbHVFzqY7dcPRcyrnBUyGihPwCy7UbZwP+Nwv7TLL/g0hsQRi+rYIAa9G8Lv3h+iJkXfgRywvf2k/PIoOaHy3Ga7iFUDC7ucnAgsJsvqw64oMYi+Ctj43sWpWXyrKreL2zVCMyK2hVsDBlCceJ7N/obOnF5nMloNo6q0V4H/dH/92g+YMl21k5sCacQN1A+erEwP+UkMXUkjpCF80qd7dYIk9sNZ7pLPcONR8CLiuuhWy
 oBNyQf8A
 ymkT/uq/EXDogRjBUExrypiC+Ls1G7LdtvCBqhD7EEBQ/CQlvA/ezpMXIgFDXneEcK+scmqmBZkhwFEEBnVrIdl3unpQWxxCh+lpyOpmIoTMRyClzlz3w+350NKR7NYn1SfVYCK9a+WTjHZQU3uX7lo8+gv6+6M82sX7Fivcx86JWCHFrd85WxtT5MJDVlpZPd0Z/4M6+8fUjQvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> [ Backport-notes: this is a partial backport containing only the aligning
> of 'length' to the hugepage size.

Queued for 6.18, thanks.

-- 
Thanks,
Sasha

