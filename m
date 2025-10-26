Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 919EFCCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 16:32:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBAE78E0173; Sun, 26 Oct 2025 12:32:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92568E0150; Sun, 26 Oct 2025 12:32:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCF218E0173; Sun, 26 Oct 2025 12:32:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDC108E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 12:32:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69C6E13A64B
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:32:56 +0000 (UTC)
X-FDA: 84040809552.25.571256E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB683A0003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:32:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FReRi25K;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761496374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+k1Lu5V6QrT/P4aS99VtQvPgEs7LNb9hfLAM9UimpM=;
	b=te7Dl1OD4LuNBUzoQuUPuCMkGZ/gQCQZb1fTOxFZ0Odltlp9f7rSsJoIlWfZFznfzWamzk
	+CzkLDI5x6T3/dtwBI0PVuVuzFVYE+qlHlgHQWuoa7D5zR/t1xkEtKvmbwjYq6KUkI9xuX
	ZJi1LZWc9tHL2DuRgP5O2eC8p6ipwcA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FReRi25K;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761496374; a=rsa-sha256;
	cv=none;
	b=Omv0Qr1vdMZ8XlMquqIcAK0eQxhJZWSfO2rZ1Be3okPmQSRBWgVeMaeb+gO1XcLdBhuOuG
	qwIBrXFCRExX+ID99jvPlEVVnSOzOo5u1CS7gafuObo7CqM9Ewq9nOtMDQmE0FfV6mSo3s
	1TQ59rfdRrVCA+pGUjkR/3EfHlXG5pk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71C2F44799;
	Sun, 26 Oct 2025 16:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99F3C4CEE7;
	Sun, 26 Oct 2025 16:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761496373;
	bh=TLoSRzFkmVrwgpjKLeey5fVAXkXkjkmPb8voffDY+HI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FReRi25K/f+KSaosgYM1ay6UWpxX7lF5Eq8dVT8Mm1vZxatuQeSSSKe46o2h4C5P8
	 kvWdFVgRG/3MRT47JjoBJGaVd8hyr81OlcauaNfdu4oA2j9sFcQq7iaD6b7lRNrM4C
	 h7213YEZiH2wch9bQQcTzN2Ulx2wWpcaSLxmA88IYW76wGzBCS59YnuiyXyPLszMdz
	 53Zl2pgwsiHxbX7F3bLrgImltnHnZsqo9b+afYNwa6cH2oGtQm83Mgyl9vP4eHAqyC
	 6vuxdaNLuO3tV1AOgi+zrJIrtX9WiNvsSCd9tk6HMpdIlwhBh27Jgd4oppcInZfMnz
	 Smi3cPsUAKppA==
Date: Sun, 26 Oct 2025 18:32:44 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCH v8 7/8] liveupdate: kho: move kho debugfs directory to
 liveupdate
Message-ID: <aP5NLJoSfKTVnsQV@kernel.org>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
 <20251024161002.747372-8-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024161002.747372-8-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BB683A0003
X-Stat-Signature: si7izj6nm8kkqdfey864s3pgsdcaat69
X-Rspam-User: 
X-HE-Tag: 1761496374-149683
X-HE-Meta: U2FsdGVkX1+wzLPOCD8fex+OZRWq7+6/OULYvVKv2qmr4fV2Zg1PrlyOuTDBVtfaNReXAFidG3UBiJjrnQiYNwoCfqs/+AB/Q/BUW4amQiB52XwH/ow5D42HWYC4N2cs2p8j36eMMhLHnwaUzkVvAMZwtT3iiix6hgFUQuof4g9wKIyJT0mL/zRya0W/7cDQGNql3tn465mmgeCsy5NDjSTPSR0dlPqRVtatYFdeojR8jcfeYCdUpi/qFv+W1D4q4XiWZyjCoRCLnEObQmcYII+V0nWDhg54z2IdKJKwbQpIGSXr5+GcOcILEsyuVIH6VkzTW2DPkylD7BwUHs+Awwu8yysKm6diCBVedBhsHCx0t1UiNMPPB5wMe3p753yP5l2lujc52Oifh0NP6TyAGoSr26mCbizXxovQgAyScJhzeZdf+a4fwnRM5SynGZws1FHShM106I7ELbz1pvOGTZHHBAQPYLjtmFke3QnDJkTC68zHBmiCCFlJToCNQ5v7+WBysHWaVkUw5cHof9Welr6JbLeUs2WhyIU11d0P1jA4jK5ZNA7hv6W0ZSH4dlQYe0Ij/5nRwQU3oY1PQLYMl+soH3VC+n4ZA77GYOJaiKe5WCCoL4XYdglnzhn/UEf9dQJo9m1GOw3yqAeAYjAIdaLxxvUPc4zp+Y2Od3B7Qn97j/XZo1yO2Rm9fHNaEifKtPOoIznwszHJC2Gjn20pJgKz4Q09hPAeBJqyr7RnB2C9Bal9aXeWekT0FWc7LGuzAznYK4GaNmTPBq6Hv2G41n8qfQ9qiRhW/7I6PUA9DM3nvpbawA865i2pPIjvdkOoXjMhdGKc5ZbuoRaaQJ1x4hzGmQuk1gW6I+k/aZef1Ujmeo0KEXxaGlSpg6j6IT8NRcxsLESBva5BAyDpTQc6ebO10DA9xue8HSGd1VWaGNUioZLYf4iUljhEwm4FM0SG2E477fuv+i0D/XIdfS0
 ieIBQuLZ
 b+VDhgPrFposvzKEZ8SqgZG6LNxInsGL79+Tq6iiAtyhj49kuPn3+WBwz3C1GG6cVqIht2K+ghSQ+7b7n1Gsn2KMQpJ6xKYmw0X+N2N4vY06B+B3Fdhs+QQHlACqnouf908EEIb98/1cyAFI8V55GEnQ4uLVc7EysPRenUgcs6mk+eXhWsgWV39EYcKzhITzYiryzyGdoNIVQ6avRLU/1BE/dsJfRomLumiPJt0NSgYrKVSWR1mFbKWJrR8YDOLlr99Am
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 12:10:01PM -0400, Pasha Tatashin wrote:
> Now, that LUO and KHO both live under kernel/liveupdate, it makes

And they still don't :/

> sense to also move the kho debugfs files to liveupdate/ in order to
> keep current and upcoming LUO/KHO features organized.
> 
> The old names:
> /sys/kernel/debug/kho/out/
> /sys/kernel/debug/kho/in/
> 
> The new names:
> /sys/kernel/debug/liveupdate/kho_out/
> /sys/kernel/debug/liveupdate/kho_in/
> 
> Also, export the liveupdate_debufs_root, so future LUO selftests,
> kexec telemtry, and other users could use it as well.

No, this is backwards. If anything it will be kho_debugfs_root.
But I don't see why we can't have /sys/kernel/debug/liveupdate alongside
/sys/kernel/debug/kho.
 
@Andrew, please drop this patch for now.

-- 
Sincerely yours,
Mike.

