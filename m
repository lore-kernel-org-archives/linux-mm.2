Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF063C5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26646B00A0; Fri,  7 Aug 2026 17:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CFFB6B00A2; Fri,  7 Aug 2026 17:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5C06B00A4; Fri,  7 Aug 2026 17:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 718F76B00A0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:38:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EECD51A0190
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:38:08 +0000 (UTC)
X-FDA: 85075786656.05.5593339
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DD7C840007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:38:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="fhtnW4u/";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786138687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=elZQKeikZzxWpyEMzJPkFz75IkgIrejtRCC8CUUdJfM=;
	b=J0aMWzWvVzeNbfh1oI+FkYJego7FJYeQsVhTde/WLaQbj+qXOfmJlL7zCTS5CIcs1DnAZS
	dzkfbuo0ZPl/szvomZdP/NmY3QCTynI+HXn8vmG1vbCfcQmYSx1pLVkpimxFKOjpqJ9mLc
	WDMVPhcJmmcL01UpEBHIE7Fs+QQ0ZhY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786138687;
	b=a+3Ot9QNKA+OOatBBLtXv9tg+0jEZ1Vmi37P86EcZ8d/5H2kf1ItcErFuIX2HTPbh3W9Ju
	fVnPC3EysQYoc74mIPSF/FEK0s0DUh+QAeAmvLTTAp9fNxuP9ddo8eX4ICW2P+UnxkLTx9
	0FYpPAz7d/b8qXVYYNLKRX489ZUJrUQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="fhtnW4u/";
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D646142A82;
	Fri,  7 Aug 2026 21:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E641F000E9;
	Fri,  7 Aug 2026 21:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786138685;
	bh=elZQKeikZzxWpyEMzJPkFz75IkgIrejtRCC8CUUdJfM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=fhtnW4u/UudPVV1QEdxmYzO3L3c6AyO1BChlBF42VEEm2BX114jT6VD/r/sYmJZWU
	 Oz2r/nIYV+HHHfV6HEUSTkM2+APMxr11seWvxJo3p+LPiEK1Z1YTE4KEaSWIW4zACG
	 CnuUaUh97dZrli8bxsybAZslGsEhZh1ws4vVC7Ng=
Date: Fri, 7 Aug 2026 14:38:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Su <sh_def@163.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, qiang1.zhang@intel.com,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] kasan: fix cache shrink race with CPU hotplug
Message-Id: <20260807143804.24cfd5710208d9a421b0e0e1@linux-foundation.org>
In-Reply-To: <20260807065038.2600949-1-sh_def@163.com>
References: <20260806121006.1642946-1-sh_def@163.com>
	<20260806135125.a444f867993cb3cd3122551e@linux-foundation.org>
	<20260807065038.2600949-1-sh_def@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DD7C840007
X-Stat-Signature: 1wgit1gj8f7wwk9e5qke4pp5y3ruo7fs
X-HE-Tag: 1786138686-184601
X-HE-Meta: U2FsdGVkX1+qDvTkNJJeU0phh3/ECWI/O9mHjL2g4P3t5BTabMbUGR7g6VWHtPH4/ILlAINjgtFS/HmXZrTZ1+zUzwXK1QwmZ1zPvaw3bMA/sy7lzS7V5yh7omTgl17A4YIh4ZnM5URfGeifD5PQZRQS7m4Zr1cvT8rdZ1CIRzqt3LbYAiWJyh0t+BV/7poP6nJOyi0EV3uP7do29vkVEMcm2T1T/HXpFdRmAV5dxoqyWnmu24hj0nlU9GnxzTqXn/GniLbW0BUPSplGYbcfHG1EgiLVoMbYlhAQCRjWAHd4NLFLV3IzzHt63ICMG6Noc8Y6DYAY/NWwBemDqeWY6dFU3i9uEL82m/97jBrhM7qSK+XZLpsJ8qrpMT3v5XHF4QLHF8/KMTAabuqtjF9kGmC0k+KSJmJdJ23oZ5KHbfQ9VgUtQhqq04ldJd07qMvPORy1mcviV2Q1SqbEWVUNd4U1k9twz+ytU28FCN0dx3Md8xWaYgn2fS/bY5SdLvz77Uz4XTRez8VTKFlr1F+uW1GTn/l2SRn5G3eIwGzGGDZZoY722WA7DP7LfZkuDVfh7YlU6XTpbnMnlHkh6wPiVgzOG+x/4PidHGqBAUIVWHLsNfh7m6rTH122uFopTQrA1tUkQznCqJccqbUrE3SlbHLL1nNjZUQn9FPEbDZS0rMqAGodPcqWJ5DY9jIAl7Ds+pQLUNCf1DEqdvKjB43qwFnHckJHuXIBif+nOXdoqAAKWatnA2WqvqQjqVBfnAyd9A1fGsvMcYISJvBIyigXkt+9v73qxZOCeMe/F8EXVJaKVkwN4Kzwskr8g6+D7C4GJ6rZJvszWYlcx9Y2Cbw4MvXU0vTlcaLMPavpuJ0QWsRewMqIDJms9Uro/ft5cwNB/UbZEtRSNxPSBB+Ho8+X3STtvKC0zggd7Iznvt2rnkwiOYbDop7OnqNHXHN/ZQuBGWA3M4pTLLOI8i0L9Um
 RDN7Sb77
 2rva7VNcec5gVX0TcLPgLsorFPiptxJveLJkP7vfVZ5FKYRjai1ZQ8zgOxoOGm3e92Y8mdy3nY8DGMQqhff1LkS4PcP4Am6qQeGKkDO3vJaXqY83q1vpdgFPuZc2b8kWRBqGuCP6c7Hshdl7Ts7c4eqmtEmokauXc7Yns7Jp8i3f50HyMDnKENvu5uATjHE/yFP2dvm+9y/6eJl4EU8XGhFcyG9EbX3dnoKS/Btepw/JgyHA7ih10CuFixzGYcuK5qn9N3Gvqk4oz5HZNlInW6MeWMoE1Zm6rhUFf5p8L9sfp/79+et0mtTTs4E+k1cQcCwA9EHNHcGVYHdhUEw3NVvbQKh9XM6X0rDbE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  7 Aug 2026 14:50:31 +0800 Hui Su <sh_def@163.com> wrote:

> > Especially when proposing a backport.  At present we've provided our
> > -stable recipients no reason to accept the patch.
> > 
> > Documentation/process/stable-kernel-rules.rst says "it must fix a real
> > bug that bothers people".
> > 
> 
> Yes, I agree. I did not include the real bug dmesg in the original
> changelog, which made the stable rationale unclear.
> 
> The 9p case above shows that this is a real bug: a userspace-triggered
> teardown path can leave objects in the 9p fcall cache and report the slab
> shutdown warning after umount.

OK, thanks.

> Should I keep Cc: stable in PATCH v2 with this dmesg and
> userspace-visible effect added to the changelog?

Yes please!

