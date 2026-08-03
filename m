Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 445C0C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE8A6B009B; Mon,  3 Aug 2026 09:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29EAE6B009F; Mon,  3 Aug 2026 09:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5C46B00A0; Mon,  3 Aug 2026 09:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE08E6B009B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:47:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83E81806EE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:47:38 +0000 (UTC)
X-FDA: 85060085796.18.5F97A08
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id CA28012000E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:47:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JYalJtLF;
	spf=pass (imf29.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAKVtID1+xnccXINfe4QJMdmATK4hGK2KcE0oA0hH3s=;
	b=y4ZKg/9YBZQ52GrKqjM/+L2UCCkTAnGCMnqQ7Vix1H/WOOYCjRykTwKSruTjQSLxHibcWd
	BU2LUVOKHXJw/Q+DYf73i2YNtkLzaVsAiagdsi1cG+sNsDkP2DHVpvWnVY9mON8vxta1DX
	lYsNZcqd8Zx0K95VLiXptfNong2SO+k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764857;
	b=g9oJvUsKBxhtbedSOQ4GGm8eg5hfY0HhcD+ddtfdCIA2V3xnxIN07oQ+36m9LnTRI4h6rC
	cOKbFvtsUlQXsO7rppK6RLFkPpWWTar2+VREt8sy+RX512mVap+nzEAwVe7f+C/CSGcHEv
	Uhi4sri94B6QU/ZPz8qUYkomBkf8650=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JYalJtLF;
	spf=pass (imf29.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C60B21476;
	Mon,  3 Aug 2026 06:47:31 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 42F223FAF5;
	Mon,  3 Aug 2026 06:47:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764855; bh=hhXsfn/zKWmJn+exhaR5yAw9rWiZOEgRl4BokkeuAis=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JYalJtLFKsdTul5C+eXgLl5h/r+HoLJG8PCPUQtIj1di2hvliwdGTq4hy7X+HeTIM
	 Y+jp53IxJk4UAXoaSZkMwRRoMpR2sER4qpgcji7R/nmCaoMxDTVCFOSk1YaBHI59D9
	 ZrPAJpKpZp0808LmmYXfAv/KttwYh+PiL97FvXzo=
Date: Mon, 3 Aug 2026 14:47:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/3] mm: kmemleak: default min_unref_scans to 2 for
 verbose auto-scan
Message-ID: <anCb8tz8KTwe9f6u@arm.com>
References: <20260731-kmemleak_hardened-v2-0-7b9689ac77cb@debian.org>
 <20260731-kmemleak_hardened-v2-1-7b9689ac77cb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731-kmemleak_hardened-v2-1-7b9689ac77cb@debian.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CA28012000E
X-Stat-Signature: y71b6umm97r6fq9rgceam7rzurgye3t4
X-Rspam-User: 
X-HE-Tag: 1785764856-447845
X-HE-Meta: U2FsdGVkX19pggBvku/6GNyKoqMrs1pyExvGSdKFzZ2N+GvPB4qDWZopbYnf65c/pw7v9jAiuyi2XbqgJ3xQe31+JCSVdzS1norBnhoz5sg6sWcGsubf1NbGbLHrQyh8+XCruoVrA0TZi3eJvGsK6MhnwiPSwaLiB4ElhB587N1obodgZMWMtHMGCbrGgB+yUfdpyOFKl2bU1ylponWlEj5i99m5Dh3k14G3Bdfq6fveItyKYHwBG2igRPRsFz4QIk37lgr9yIv4MZ7bcnGeohsxsK4+B4XdM3KxEFa/Iu11CwMlM2TXQYgbSALmbbIYcJX//osKT2au8xWyt6DWTprfffaVZkS5ubaV1948BvdYKQ4Q+MI8AFF55KObhUedplOb2I+iiylCFWCvw0tPbWhxRsmKye+CrDgP3+zwygkitVqGzV8LcSwdVALdg1c9vH/6rZrthb8eUvc0uljfvsGusTso5IGg2HjVjQ0eCUEdqG1ohMf8uBeuLMSeA6hX+7XuUjrdfCK6HMGWfF+fdVYUuSBICh9W8XuZyd/CJ6RVWoF1/A+CSTD86sXPpwRNtxpKHve+HILbFmSMHwNGfL76CekoBUgc+GtnFbVbBuKJDXuSMyjA3eHu5cQqbE/mD42ywxanzz0xwbkEHAfwe579hgMPxddgExLO9S+bdsn83jH79FEMAIBBBICZsx510uxT3GlFUUIkz1CWHU26KUn6nhL06sno7kcRAo7rqYVztx+peH7kuunXPS9MXGyN3c+RIpUUUZ40GVCIMQtBcbKOEG5ci222cmeDjH7cDtyuHZvzMHCWMz5zlEtXILUduarw5pFIxkaCa5Uzf6YTjk8bltV6c8yMV9qln95SgivgbOSrSAsFYAEvRCLmf93qri9WgdJ6l6N1NUZQQ9MwaOmJZeXatn5zXW8v7yBELbZTTuMEThbSDq3Ni26+Wf0AWcrP7eKi7IxWpssaWEL
 ccgX6wSr
 AyowSBfXI9y8FwSsutxIBQaVe1kXYriNpJN8Ih2Y8NvhBBBThIMURLVS6OomjbDc992J57s+H5oJg6yonjYMMpcdkBZWUifsZ42eVBgBhCQ5dZz2jDPkMRY8MGLTmOZlzSgIul/4snbe8opUNXYkf73ktDGQZU9t08whFEoB9TIzlDadCIitPew67gbiJDbKEDfODTy1oneGqY5GtezX5o5g/nBo1MD/R0qlOY7j47ZpJ3Q6fyE7skl8hRSn6kmvyBEoTZrqFxIGThX6fRl01w40kgi30VTbTBV/uQ3VALYJtkj9V67z2OMwffONHtyjN0oorXZz3w/+lGKV7aPK3XDbvYs36vVoxnanyxDVqHTjpqWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 03:13:04AM -0700, Breno Leitao wrote:
> min_unref_scans defers reporting an object as leaked until it has stayed
> unreferenced for that many consecutive scans, filtering out objects that
> are only transiently unreferenced during a scan.
> 
> It defaults to 1, which reports on the first unreferenced scan.
> 
> CONFIG_DEBUG_KMEMLEAK_VERBOSE depends on CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN,
> so a kernel built with it runs the scan thread periodically and the user
> has opted into detailed leak reporting. A second confirming scan then
> happens on its own.
> 
> Default min_unref_scans to 2 there to suppress transient false positives,
> and keep it at 1 otherwise, where a manually triggered scan is expected to
> report immediately. The value stays writable through the module parameter.
> 
> CONFIG_DEBUG_KMEMLEAK_VERBOSE defaults to n, so this does not change the
> default for kernels that do not opt in.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

