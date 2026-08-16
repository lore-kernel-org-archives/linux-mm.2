Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58ECC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 12:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 773B56B034B; Sun, 16 Aug 2026 08:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B9F6B034F; Sun, 16 Aug 2026 08:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689776B0350; Sun, 16 Aug 2026 08:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8D2D6B034B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 08:04:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E68EC050C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:04:41 +0000 (UTC)
X-FDA: 85107000762.23.57CBCF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BB792C0009
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 12:04:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFI2AiJi;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786881879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBTO9gktMqs+YZN9m7Dn6lVtYTSuJ1+92QAeVWOhE/A=;
	b=t+wwYwIBKZpk7+EKcng4RpNHc1qg8N7QamXSgq9Ofiiexv67ktPQ2It73uL7TCZFEbEsvY
	+e6CKakR3ivtITTzjnTjY6K6MuJ1uQcsuJ2SYIP00vbedUxLTQsfN3fPCXhcPv7XhmLYQa
	dRb9FceVT171T3Ih2WT7hTiMmUX2xSo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786881879;
	b=eBdxEeCzQqyuWl1fHWeRQg5Tys4Im2gJXvDUff83/rVq4Eo/QMgpkmuUYQ2MRjZn1Nho7U
	cwltSDXNnMca2ecOVobA6g2dsz7zQTK6ZuzxWI/UOAXjiCJhD3vZ68Dz2nC+i3JfMK2T3b
	jp5hpSoXhKVshgeN6mcN19cteXhFlSU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFI2AiJi;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB57643DD6;
	Sun, 16 Aug 2026 12:04:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737541F000E9;
	Sun, 16 Aug 2026 12:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786881878;
	bh=dBTO9gktMqs+YZN9m7Dn6lVtYTSuJ1+92QAeVWOhE/A=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=EFI2AiJiBMVGTf8OKeIv62ILnMeLdQnOqX7XgKJOIuanIz5p72B8GmkX+Qq2y9izX
	 TXUvcNAoPP4qGtR3ierjyWaaFAkfBHeVBeMnnOEmp25skxCnD1k+o5A3KTBR9ClwGP
	 S6fibZYyGXmVG/RPuNg2NRZU8xfpsgzT+6fgH3Wsyhvl6yPol7fbBJXlRlGsUFZ4Cx
	 yHd/MsLv+kak8DVB2Qm1XV9wAhAMLolcGVQ/RNgamEUDINNETra6FefJKPnoVnMwg7
	 BEb/UMroBRkIDQyozzLBLaZcPdNB0YkVw91+u7Tm7nDnbtanz4fEKS71fR9IKCqg0W
	 ornYliEmDw1Tw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v10 1/8] mm: fix stale ZONE_DEVICE refcount comment
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, arnd@arndb.de, 
 balbirs@nvidia.com, bp@alien8.de, dave.hansen@linux.intel.com, 
 david@kernel.org, kees@kernel.org, mingo@redhat.com, muchun.song@linux.dev, 
 rppt@kernel.org, tglx@kernel.org, linux-arch@vger.kernel.org, 
 linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, x86@kernel.org
In-Reply-To: <20260810122057.30447-2-lizhe.67@bytedance.com>
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
 <20260810122057.30447-2-lizhe.67@bytedance.com>
Date: Sun, 16 Aug 2026 15:04:30 +0300
Message-Id: <178688187038.2799959.10744801601222444417.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: bbted3nao1ihjf3eeg1ekwrtb3zjpsfq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BB792C0009
X-HE-Tag: 1786881879-15674
X-HE-Meta: U2FsdGVkX18ZDZfhdWphCckk2gc5BHeQULjpfRjXy4EJVkijdiPGyr7N6U1alua+SC2FD3KL4SA80o5NO4XMwdWRbI5Ea053SyXkMasYpQTZVt+oi4bML8KVbLz/NGjheg2EooXDclfzBu12YZDW8rx5WDgj4Axp/xeIPdFjvciL6JTMzb2a39mcmvyNsU21ive7yPJE087UTy+EH2O2ZAGLiUij4cQkdV/YrbNgzL4n6VmzXF5sxo9NPUlUKPCEAasPWMLI2prrKKcZoNZ/iioWCcTS+iTvoO6UV2SLtzQby2FaSpiBWD8SEi2jHttN6deZJmoDpwqFYiSGTdDm95sneUBv3gCiKW2/eE3b6MQRfMPh3FEY6tnH9Hvn41bsuiKpR0Nu5X8CrNVdo0ymJo0yXTXbPHlGqB6RzCtItOgRlLD5A95G4j1EywT4Bib4TpK5CAyA2pvc99R5Jlw5BeqDdhlVxOyt38msE0MSRsie0brxETLbyJwVlVFkA66c25aTx58WbVIPwo3j5Sjz+8A4RhPBF6ZjUrDtPE4v8Rqzqst45KP9nm8I82nKwg3faQZHpiDAg9c8QLDzqR8FkinlO1XFSWxpW4g1CR2FWtEVuaKofA6i+cvVp26K2k8Uhm5nJV85KVChwGkrPz688ZPIaS+g7WVMIHletltQsKJ2bpAwn7c4bbaqcgpwIMkNA/x2NnVcSmLMvCTYfUxo3JutMzfgzHlshFt3xktrTKqOgp3YluOaXly2sCbnkqp/tLJJJw5WFIiUvGSHztU4ZkwW2fXe06T8WWRBTd1bDQVqfzVgnyHF5mLKEs0zELumhG6Uz3FWoxlcqGRcLB4jyTSQzfa+xw2dAVMxesoP1xDfT0UPPxiMvIDxOBoEW8jXXs6E+qmCkc7DdqNnDpBcmwz09jFXHJI5A1iv3UTj5SB6zDTJawqyYqQWxQVAE9d4U/yCjs3RggkS+KPdgr9
 MhR3JLOy
 x5/7gg8FupY1klRt8AqNhO+WinrCgToOhrHtsQvyW12V23INqq0iwnKUallUVRD9M+cbySZlmdRqmCiJhk3ekJCDjmlbhiDzQURpg/Occ1opd6Igoc8TaNI+AdKWWA8AeBh96D2eJ9q+yZQ87e+VKUIhj99h7bHEAkFd7sKGFmzwPmMSCYiYXehXetV50gvlozCkShDMZ51tHmTi9nxVKja0YNzmvjmOziR17439XOlGdz17ck9o3XSQNiVOLLa1+SHkByaneRw5brog44Xdf/QrmmMPdZh3xuZNja1Pdb5dRd4gnxPaPxW+n0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 20:20:50 +0800, Li Zhe <lizhe.67@bytedance.com> wrote:
> The comment in __init_zone_device_page() still uses the old
> MEMORY_TYPE_* names and implies that FS_DAX pages regain a
> refcount of 1 in the free path. That no longer matches the code.
> 
> Update the comment to describe the current policy correctly:
> MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path,
> while the remaining ZONE_DEVICE types start from 0 here and raise the
> count again when the allocator or driver hands the page out.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


