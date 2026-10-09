Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87318CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:09:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1B66B008C; Fri,  9 Oct 2026 13:09:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8366B0096; Fri,  9 Oct 2026 13:09:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9656B0098; Fri,  9 Oct 2026 13:09:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 47DD16B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:09:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34D9DC048B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:09:47 +0000 (UTC)
X-FDA: 85303724814.04.873DBD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8C0B100002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:09:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYIr18xk;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791565785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCni05apCN4AGczMKeaXj5fPa7qrOY0NPOadW6AQ6ss=;
	b=j1r1a8+dIwx5OZOY/IdlhyATxuYdln0Edf5XmE6JoIj9AipKITZ31jbHu3YSpwtNmzmsMA
	jyuqQPaciFt8ZCGEiXu0kHekRwnJyAgsF0YQ8N04QJUpeGhPube9+unCMB5DFj92uKxy8Q
	3WHh30/hHiEeWqn7SRpuN3CoWyHUluw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYIr18xk;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791565785;
	b=T7cOCIZ1xCqzA3P3Ju7WxjR7OidJJw7xpG/SpTwqIydrYZ3SDqDEVOx7z1D1TqJlaHVjqk
	A53d5kQgIF+pTxv3Q/aBx6oVBhvtj1yzCvtWoWK2JbmQPrZxIP4oQXiCxtP1DD59+RH+g9
	2Mq4HCOQht/zOUMceUOKU0WREISC0LY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 44B0960267;
	Fri,  9 Oct 2026 17:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765921F000FF;
	Fri,  9 Oct 2026 17:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791565785;
	bh=ZCni05apCN4AGczMKeaXj5fPa7qrOY0NPOadW6AQ6ss=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XYIr18xk/PfHlCiJ9uVydxG+LXkusM11uyVcteF+bHxB9w/ilw6rPRDbCeyVjbPx0
	 BvmfcTfqOVz+ZaWe5ws3WvvsV5Mqn3A/WZVrsCudMK4Knvvy9oAnK9e+6vWVo7p8gC
	 Fnrt+bw2Rwfbc1GFoYiGclga1LYr1uotDrB3j1JpFeBdwVpr1UTjii086tPjt/MON2
	 pfrmUrlNq75UDN19OUlB1Z5OLWsTvdpYrnlpEvEqS3kni+e4aBOVEG4Jyspy1Qk2/j
	 xgZJHSPYncdERMClrK1e1V6qSIb2PiBDDOcfdKBIUmDSxEEvawt14muDNX922jcbC6
	 vV103NQsAgrdw==
Date: Fri, 9 Oct 2026 19:09:35 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce size_to_shift() helper
Message-ID: <askfz-q4KLY7QMKW@kernel.org>
References: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
 <20261009-fix_hpage_macro-v5-3-54378ae45add@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009-fix_hpage_macro-v5-3-54378ae45add@arm.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A8C0B100002
X-Rspam-User: 
X-Stat-Signature: metqqpdipmygjqddjfguthtonp96qxa8
X-HE-Tag: 1791565785-240865
X-HE-Meta: U2FsdGVkX1/sLyjeETp/+zG+ibzi1KhwCJIv5Q/xthw2UbVdMhjh0oX0VoJ7+RquONbCmujWQUwPgA2X+nF/DjBPmk8OLQA3w51oJz+oHsjLatnbEy1YQvyZL+ECxKC0dvOE+oqCx5JRqQqIAPBQviWxVorYboG3mp5pMBa7FkhDPVf+J1edf5sbYtbkTh6pIp7f4v24flc5rdZRIrty1RKxDG44cb4cLhInvbN3RkGtksJY9O/Jg0PExBATR9Am/JWufjdiA2ngyeTMJ6o/kX+K/CYAJNaDNOjL+yrXJ/5t/n4kIH6YbWoMT43R4KTMYCUwAj4BJhxO8a0oPpb/KzZJeqAOo0+KlAIIZaRxChrYuP2fPVKcRHSAlIFOoZ4C1fHqiOgxmQQFBJUnJqp75FLFKUD6wkBhF2MOFVH9Xy7o0GCCQ1fHRWOaPYrV082BLVwRQIKjWfUFPE8vs/r1vR+f2vgrfsp4x1EBCPNEZPTg6PEs4BcR99C/ptCAc5ST9EtNttjQAIGD6TOOVx09pTKALLhrQCAePKOgJpeatwFwiDRQ4vq83/UZGOgH94yTCjQYHuwXgGws+XqAqHx3Dp/kTtP7KdGMOFzPJ7nRYhF327KNejNm76FMkRR3dT1+qw+aJnAVDiJGpG9+xLscYJ3yczPmSfIjxu8hZOruh7ts6GkesogoNqN6VKTEdq5VSlp3cjzPyqVohO8u3jJbYy8q9YHIhAqAlm79pNalr3QIIDi/q/Yb/Vbx0bY1buPZOobgDLxOPVqaUdXPk3RMf6OcSzhAGP3GgwcqgDTUCaCco6Gcufet68IkiEy6lN3FXNIUjrVg2Tml1bD/VS0JLFCI1Nm8Q+BkrQW9uC+NFZrdxbNwG5l0bezK/YFCXv1PSRk3rEnuzioSwaA6cv9l27sVNeOuSnToNJPbOgfIkKPDdRCZdz90+qkeaOCqPJg52wk5Mqy5pfTyxMLGBDT
 UPdt65lm
 xK4LhDnhks6Dm4tha+tqFgjlp8hsoG1J0eVnRGxmuP688AF0S09JCosmuJF5inXxqL12ArrkwrtnWRdjR/RsNvnid+1Jn8pbSRnDP7ufxRnq7qtfBP/5cYvbg4he43+cKxcOWNMgXPcS6DnKKPiWyFB9HRCu3/MglEcEIcTOBa7VvMvC89IH2Va4ZCmqOjxH78rvgf2ncPbaBoBYbtd0HLyvyCPRignuAzGAm9T0qC0JOQSbw9+kqo30mdRidtKrJ5gAqF8raFHvU8WnmZlJ9YZk+SNU715Dnl6wBcwTsYWynrvmOuZ/nb+b4HPjZ3CZ8JHfq60KEbSEnQWPZFHWvTAT/pSz+x8Z4qNDYGT06SVgV+8wtIKPnvbG6OhUkWd1CSHVy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 02:27:34AM +0100, Yeoreum Yun wrote:
> Introduce size_to_shift() for future users that need to
> obtain shift of a huge-page which is other than pmd_psize().
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/vm_util.c |  2 +-
>  tools/testing/selftests/mm/vm_util.h | 12 ++++++++++++
>  2 files changed, 13 insertions(+), 1 deletion(-)

-- 
Sincerely yours,
Mike.

