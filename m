Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DC7C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD036B0098; Tue, 15 Sep 2026 10:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4AF6B0099; Tue, 15 Sep 2026 10:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAF56B009B; Tue, 15 Sep 2026 10:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75FE26B0098
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:03:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B512640439
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:03:49 +0000 (UTC)
X-FDA: 85216164978.11.78454BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 00E8F4000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:03:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IDyqTQ0n;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789481028;
	b=U/IOrEYOwgTA/Ci3fxM5lFMb5m7yTZF4pLVqtzwLdyogI1r/80+Opfq1lFNpjvWFdbqFPd
	vQFsqlg7TQ2Dq50+HZg8e1+Pay9zgE4u2blBBEdr+qnL1Vzf3sPxLBS/UyZKaJBY1OFcwu
	M6GdYw411UVbLVpyZwS+clP8lGjBlMg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IDyqTQ0n;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789481028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gv/bqhdmN/biMpSAbp688ZKSp8EdnUfEmzsl0+WmCX0=;
	b=F/zdnEINK42vk7FDIrNdRruwJr6WBfK8t+AOqoh1CvATmTDC48UWG7u5QCd9vT7ofG4xzp
	qHqJoeUhkP9pc90Pp8gtD+g/ekp6+hKpCy9YfhLB9vy6gZd7mBrxNMpHKs9RH5+dw0oqQQ
	JSVSIDb3bbqN8bWeKcgMeihr7gIQBpo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D75B600D1;
	Tue, 15 Sep 2026 14:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 387871F000FF;
	Tue, 15 Sep 2026 14:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789481027;
	bh=Gv/bqhdmN/biMpSAbp688ZKSp8EdnUfEmzsl0+WmCX0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=IDyqTQ0nh47BnNdcxRDkAbq3EAqDUGPcy8+gRkq6/1azKIdkDvKDRZOupNmtHwJXW
	 y59IzIEE+kgrjw28QhD7Cx3730NqFCU9/n1n1R9UMnlhoY2rc19rseR6Z3WhDv1J/N
	 Dmh2+Xuv59OnU9eZxPJscH7SX0PpIc/VJjfl6v9Jbcw8yZvJzlTfPFBM5zXCTSvwq7
	 yAT0kGbFlSh6D7H+D4njjqeyGDPa0Gs1N7gdoddAeFqQyx6+By2qims4AMU7YImIAJ
	 nTu0XWNAJwHuXJ5hx7DczeJwQT1kPLje4S5jKkpUOZYMw4Jv+YKzI4s2cuisIXG1vm
	 87cTMOVx3+c1A==
From: Mike Rapoport <rppt@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260915124641.2498280-1-chenwandun1@gmail.com>
References: <20260915124641.2498280-1-chenwandun1@gmail.com>
Subject: Re: [PATCH v2] mm: memblock: add missing HugeTLB flag name
Message-Id: <178948102264.1481367.14761342723749555732.b4-ty@b4>
Date: Tue, 15 Sep 2026 17:03:42 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 00E8F4000A
X-Rspam-User: 
X-Stat-Signature: jw1zw9fhq88hfew1iyeyk63tg7uksrbx
X-HE-Tag: 1789481027-168598
X-HE-Meta: U2FsdGVkX19XHWoy+aBXg/rFUCL6QAZ+/FkyqaluURx4cvwUcR+jpiyRm13FKCNJTSN7JFx5eqtFKnfsJWROX2xQrl2p6qN0WMG+XGxjcwhOlNGbEb/ji/vUGJdhV3+6h7bfF30LZIMjeMEISDrJRji2WzaCwuKeBfASbio8rHMCV3yocVzY02NRqk6crKtdWTpDNU79lgimc9g6TJCQy2tnTjsmik/uaQ3tORCdxBGQyhzOUT3AgOlo63ndx4snd/xsXM0N+aUdY5eTPVOrjg0K/ZJo5g8uJGqgtE6duaSev+/AMXo8s7f/W74eY8NsXYXGfPMJzdq1N2ogrqLwv2zlo1UaPaDm2T0k9Te5hxM0P4iT+RS+eIYmS53dTO6wwQCSPK25Om7G5+73h9+lXqyUFf04jSZbbkDDdW8KYT6d5ghTqyrmbeHn1HgrnH0Q1JTku+bGSOkh4ADDnPOc9s6mOXhsRlZRMjxKRQDZ52Ah51kT3Hw42NshrJZMgIwTKmi6RJjBfYscMd8sghaVEE6ZD8ytN2mBq4uXneOPhjJnuHJLhJOtRTzR48vsv9l+DaGFF+dsNTwF/GI8/0HghGXZkMLvpy4X5Yu5B9EzbDYJDebxWFxpTG1ghvpjIEm8Ri8rsnf4cjtpYlglo4/xxutd2hhb02znOnYgC6KpcdKa9jv72ppbTvfRASMJTRimRv5b1VSlclU7CWt1zj1/kL6TiH4Trkb0zM/ULzIe56W/mmfCMv4+Jh5ZiOKi7Kyz3DrTKReV8K1XylqMUm0EzGH8jmyeAR3x5M7LsuclRjsoaNX/F7tFK15WqydU/YbvcP0/8J5QAjQJ9SFafn2G1G9/MkCUCIZCe/Wlk68swUG/EOdwx8F5NThd9AJs9JQRg1UeFGqheiSNunYVVZ/3Pjbo934h2Td62uKleoX5fsfGPdijwgiz5TOEGZe2if3IKxOZokY9guZXiIe15QA
 jtjNC+UX
 zMCk83vZT5lYWu1uYJwNsdX9mVsQj+z+9OiviKBLGzx8NdeA3yV1GG+y0cKDhsanwZ2iig/hUq2ahFvA9j/0/YV/ZLrYtY57p4ECwPCyJ5p/SnNx3SSlRVfzBsG1EH7zJMbF0DFmO5SoW7BjDM46bJM4nqo59CzI1HBkJThJFINkvd6BOkUUY4mfbnw/Vjj7rqC+12kE4I6T5hmEXO6AsxNeucXB54aQDwBmzC2tG3vj0asA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 20:46:41 +0800, Wandun Chen wrote:
> mm: memblock: add missing HugeTLB flag name

Applied to fixes branch of memblock.git tree, thanks!

[1/1] mm: memblock: add missing HugeTLB flag name
      commit: ba13f1f32d96d7ce9069ae4f32404ecde8da89c4

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: fixes

--
Sincerely yours,
Mike.



