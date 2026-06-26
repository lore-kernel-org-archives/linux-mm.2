Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E9AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EC7A6B00FE; Fri, 26 Jun 2026 12:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2EB6B0100; Fri, 26 Jun 2026 12:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB8F6B0101; Fri, 26 Jun 2026 12:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1715D6B00FE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:36:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90F2DA04FD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:36:27 +0000 (UTC)
X-FDA: 84922616814.27.AD6352D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id DA0131C0012
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:36:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8CxjkH3;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782491785;
	b=bgsko54GcUOD2OtBBeZOKzS3oAxPkaf86OgeVBOnVcCuqgmQ+O5kO1m5yv02yx8K3qeiOK
	5fWuL+Ta9KUgj21483QtGfupP22gTWXDRlnAkxnfgZcQUKy+CvT1alILtkm7enNDFa7jSj
	OFkHMBe4O8N8jK0KwfU+R2lYynUBtms=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782491785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWXwstKwR7T4B+isY2gd34eASpg2WAQcyW3ClbX83tc=;
	b=FRJU+PJPO9EoK1mvT2GcDbvcDV07wzO7atoid6SKlteEw71E5Hf+0Zp49ShUjZsKuy98Vm
	RfRXD0EKHmBNk8NM4EmzjC2Bxi8BLqV1A4VnKZHx7kKopKC/OE6CW2jkzaH3Wgo064QZGR
	D3ewAFtp7bAvqUYyhjk8Pi8lPsfaw1o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A8CxjkH3;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 663FC600C8;
	Fri, 26 Jun 2026 16:36:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40321F000E9;
	Fri, 26 Jun 2026 16:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782491785;
	bh=UWXwstKwR7T4B+isY2gd34eASpg2WAQcyW3ClbX83tc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A8CxjkH3KCK7ULO3qCW/SbKEYvKnd9iDkk3bHiydC9AXmQmYLKoVpKIn9MoxWCtGo
	 F9GPd+DkETFu+8fQQVxxX42e4UTKuUH+hsXo0B/z/ljyWOmSbIXPvd/mPQn7bYhH/E
	 drcocTtQd/My5UELtaw5w6GCP2+BVnoGiIxOWijKHNHa8FA3ziEbtCnvHBapwzr+7p
	 lOkQdwPtq27GqX0elZbPnR5oimwoA7qwCSCPpy7gXcvy18DeQlwJcuQ10fFioYjq1K
	 x1YZqh4T/DQO1RUKMB128T/BOQ9HjTRpz4wDmiMVd2ut08jy1ox2yDg2+GumOECTQg
	 z/FKNKtD+WAWQ==
Message-ID: <2a121639-3df1-4fe7-a6ef-d29a3f5f5b8f@kernel.org>
Date: Fri, 26 Jun 2026 18:36:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] docs: pagemap: fix flags location, member name and
 sample code
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 corbet@lwn.net, skhan@linuxfoundation.org, sj@kernel.org
References: <20260626162710.25844-1-zenghui.yu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260626162710.25844-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ebi8bnnjt77cyai6s8oo9z1h1ykwb4y6
X-Rspam-User: 
X-Rspamd-Queue-Id: DA0131C0012
X-Rspamd-Server: rspam02
X-HE-Tag: 1782491785-668910
X-HE-Meta: U2FsdGVkX199qnKCbsQxFJwRa1yWVkqJauP3O7JjXg/fLmxiYp9A82FCx+yX4lcn8BxgAuAitwMFJboia6dP9llgLU/s+r9CwQvUi3BsWgxQS7iUoo8okBmZZ0wCpN6Vb/CBuO+3E4BzhK6wece2J1eaQMAOUAJjrveE7eJDC0wuJTIoIaq90oYh0X+RqI8IWGDv/BIOcN7cN5CfIilokwkHZnCyGarUcxFCgxBlMF6ZqVqQbpiOA9hXHK2Uw3oRz1hJgO2/JpdKanJrNGy2kcjH33A5o3a1+Sx3mSyH3H0fFVeXYM/suoz6KAxFHjVhC7UmNZYzAF7UlcYQNd+jATQ1DMYsTvf8z1TGXhcjdyleMxtYp2PZ8YScm1D3KuyEqGONjwVO5QZlOXcFddYRqydy8cmprhpuLBfLMtzPASp5pY1/wQZm9LSL6MuPSXXHZsUWAPVGVhFFqYUU1oENv/xpyHJhXSLs7fafdfW+bB3UbueNBH7NByKdpHFmlGe7X/BJznVzKqM/tWAgBw3PRt/0s71EK/5OhruXna0TRvrYkIo007OG2FO6UXccJCvPsRiw/1XP8xb7MooCc0fUmaKe3x8Cn5gJNM+PEKic3dolYWhiiT+QmDQb/Cv5Z9aM3jcIaQ5OSLJJpYDqhLomPouK/mR1F7yoLn6suvA0j6Kqzz0f7FVDbu4dsNUhiWlSzu8h0MCYtR/LL/E1B+BTGheuYo4oA5R1knd8MkoTvEg8xdNbg/o0c/LJOtWwWkfvFn5Gl7ognWVC6WBjobIj1wQJiKC32kBlLtjxq0iaMEGChptWHxvcbfSPIhHP2CZ2N078cKrfaXNHdYsAor5yllo56UkEpvlR0TWz0qs0ZumLPb+XUHRgFHORjM7DZX6kITPdWiRVnVONtdTihe8M+X3SlC3Bf/lum+7u4jolMNrBNU6HvaBtE31pbz4zwPuTuR/dM2P2Ygv8LQtTXMa
 v3eTIfQM
 KIyHl3pbUbyiWtIzSQob/BJmtWlfWYwWjZe8CNXNPt8pWyVMackSw9CYa2d6ekurNx7cWS+J305vN3sXaL3ODq5HOsLsBb5G4tpMsbPADv9fJoipMFxLR8/4yqJwRFZYF1an04pMxAEY75mQ4CHTepnkeFZFYU2DitBCK9NmyIH8Tij7BnGNgA956yMH+15m+oGylasUSLYKv5hEnI+2AfgM7tL3X6FB8IMW8x9IPwxOMJAP+E609Zkykg87T8W2J8KgoVQoXdSTriGtk5SxB6Yo5YVMVGdwMVVhi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 18:27, Zenghui Yu wrote:
> The userland visible page flags (KPF_*) were initially moved to
> include/linux/kernel-page-flags.h in commit 1a9b5b7fe0c5 ("mm: export
> stable page flags"), and later moved to
> include/uapi/linux/kernel-page-flags.h in commit 607ca46e97a1 ("UAPI:
> (Scripted) Disintegrate include/linux").  Update the doc to reflect the
> current location of these flags.
> 
> The member @walk_end of struct pm_scan_arg {} was wrongly written as
> "end_walk".
> 
> The first sample code of the PAGEMAP_SCAN ioctl wrongly used the
> PM_SCAN_CHECK_WPASYNC flag twice, instead of the PM_SCAN_WP_MATCHING flag.
> The second one included the wrong category in the required mask -
> PAGE_IS_FILE should be used instead of PAGE_IS_SWAPPED as per the
> intention.
> 
> Fix them all together.
> 
> Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

