Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDB0E606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fO5uMrtc
Received: by kanga.kvack.org (Postfix)
	id F05C36B05B1; Wed, 28 Oct 2026 05:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDCE16B05B3; Wed, 28 Oct 2026 05:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8506B05B6; Wed, 28 Oct 2026 05:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C592E6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:17:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E326140C33
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:17:49 +0000 (UTC)
X-FDA: 85371482658.06.95308DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C61E100002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:17:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fO5uMrtc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793179068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJ1TYXbCKeNxi9hHVyccJEj3JOzfrMe3j2ahHPKeTPk=;
	b=iKVrL2aUnQwMIkCJ7pFSmdAv6Hy1c0v+2p+FC00Ja4KqAWLe2B1WfQWcH6jYiHuQ5tkkxn
	+72m9HBA92ytGoDUHmzGbY6H4ha7BccpJQs0hRwMxlWIv51oHlLaF2ijkVz7+KucM+GRkC
	X6UCGOE/yQy7JOp/+vWQZAza+Y/WZRI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fO5uMrtc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793179068;
	b=59nIWb/p+bYE5WlN0/iA7RZCBpkYV6HGh97EtGCZzhHATn+9B2CBCfurd65X6XkIxW33G7
	uPyfyI8C+7A98nzNK4W1I/fDRDVDlSlwG1U3JTBw2rqyBOChHS6aEVXo6c4Mv5C4ykHnBx
	39/3TeflGpYua1svc99Kv7Xph85A6tA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6789940D56;
	Wed, 28 Oct 2026 09:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FF21F01825;
	Wed, 28 Oct 2026 09:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793179067;
	bh=qJ1TYXbCKeNxi9hHVyccJEj3JOzfrMe3j2ahHPKeTPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fO5uMrtcIj11vj8Q7CN5JjGyl81WdLw89ZqifB+ey7GTJIaybnJK6Jtk5f5yPBg2G
	 PEXN0HY9CepPiXflll1WDK1nFxakKm+83x15zeJGIsiQT6iPKvZBYFbb0st8qqaHbx
	 tuUv4fupzJLUhk8azNAxFe9X6uFWZtc/lyWkR7S0wl+Kv/tvi73USzhGlmaxzML0Gp
	 mR4LkTqnUzhBOluy7VYLsiLyOLb5bXAd1nBwGIeFKpNZ47xMG/gUiUig46JsqIrDMb
	 AQ0kSmOO45bX0HKcS6V7C9e2bRA2iCParDCxl3s3QcfgEIuc0z0IPPKNOQZrZ++Mji
	 09h88neWQkXFg==
From: Imre Kaloz <kaloz@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Magnus Lindholm <linmag7@gmail.com>
Subject: Re: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
Date: Wed, 28 Oct 2026 10:16:29 +0100
Message-ID: <20261028091631.8072-1-kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <dfe06aef-540a-4450-88ba-300a460007b7@kernel.org>
References: <cover.1792609488.git.kaloz@kernel.org> <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org> <409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org> <20261027212610.6798-1-kaloz@kernel.org> <dfe06aef-540a-4450-88ba-300a460007b7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C61E100002
X-Stat-Signature: wcjnw13hggrrb35a8atp3b3iwquudbcm
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793179068-670908
X-HE-Meta: U2FsdGVkX19Kd4m1Wh/M2+0tgewRmWsLp7jqQDFo1UsvaVYgohR4KNbdgJ2Tm0iEwXn8uNsWwhhpqJ3S5QCj4cb7QoYViEvwaJT4jpS/Ljiw5C9gPddDkDaydSRJdSu3JcyJllMA3ihyPTHg5h59HcUcQ9fOVb+7QAoEdfLKaVIu1SM9SZWvLeU2TIQIQatJxtvEZP+Ck3VxEyDHZCY6RZahaio3lEzPF6yJ2juyWO9GzEwfG8PlbmVkwHCU1wZf/3AnLPgKZPfTxC/BQTTPCcUPEQhIfQznlNXOhj9HOk4o5myezjsgCKX5KjPykTY+R8sHfyUmDc3sVM32Qhmi/ylqipwjpd9dWP/SlxTfzuz26vplhvR3zFKsiZsKq8AaCfskdFuG9X3Js5TxMd+vjp3ggFN2pH/t8yMawwra908rqop9t7jqovA1W6tDRrfSMc7GYjBfRwqlusPuix3sdojsefTJM5InDPZrq5488sPAVeYaDgjoadVYEvlFlXT1igjbvs/0yd8ZVO15t2nKqd4gZqH1ge5Bq0UZ/VFlbgIk5MDEmNvmtGtxOzMpRSw+aAy6oqa6xg6ERJS1VGwdH0+ON8FcBw8Zz3AEt4CGyPf7voFkrtmGMDj5T16/PnWfwUI+QypUIM/KgFjgmKCK9Y2uYkhs9bLmoVEWDmlrPGkO+HpPzx+2U1gmkC36IWI68HbWW4DkGDD7ZgenHVGUDU8eEjSOWREgw79MWQ6FdQ+BVkQMMiCd1ZQrkPW2vG3NCaoDE4DSSIOQPPL2ARbwJHtfyDgqddu4h+iLJV05vzIq8G5wyys2ovI7PH2c70jl0fBnzYAQEu/brK5WYOGJoPqgauZDCVtJNapMnlNXRvhIpAG22wVxeKpGuKThw3ZnPvxxTDO+A8NPFIwGYzFwxN3umHhFT1ZcbTDsP90fkBorI1M2krNItmCzy0pbIoTT9xtjCg8YOunflAbk4dj
 NGAUvpoC
 ImuLmBS6oIFpdHI5310XJ7FgkLjGLcFGg8eJ5gxP28rftpns6Dv4j6IRkTi4FnQFGYqbXJT0lRgcGkQEo75cjDLgbehKt+C4AJBI1WFu6VUtjqKTsX6HN6BRGIVd8f2h71RSen7pEzhfRwOf4c3FzTPSg0+uXpLE1WleeWSP3dlP5lnDgtX5prLFlw8/9EK/5dFTK2lrKzmxL/Zztex24WbNCx1IbOcCMCYfe4cGiQQbpCUHcJSCJU/QYf48lSIjvDlWY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On 10/28/26 09:49, David Hildenbrand (Arm) wrote:
> But that's too complicated, requiring page table walks ....
> People running museum piece hardware and complaining about performance of mremap
> or memory reclaim should reconsider life choices.

I'm one of the museum folks myself, though more the kind who loves
running a modern kernel on old hardware than the kind who complains
about it :) A lot of these machines are still doing real work, and
these days not everyone can, or wants to, just buy a new computer.

Some of us spend our time keeping these platforms working, and I'm
not asking anyone else to carry that, which is why I tried to keep
all of it in sparc.

> So I'd say, make it as slow as you want while reducing core-MM complexity and
> not adding more arch complexity.

With C, move_pte() and __HAVE_ARCH_MOVE_PTE go away from
include/linux/pgtable.h and mm/mremap.c just like with A and B. The
walk lives in sparc's own flush_cache_range() and only runs on the
CPUs that need it.

B would be less sparc code, but every UltraSPARC I-IV machine would
pay 13-18% on reclaim for it, so I'd still lean towards C. If you feel
strongly about B, though, I'm happy to send that instead.


Best,
Imre

