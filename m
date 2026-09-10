Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F19AFC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9ED6B008A; Thu, 10 Sep 2026 08:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65AE86B008C; Thu, 10 Sep 2026 08:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570396B0092; Thu, 10 Sep 2026 08:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39E6C6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:46:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B747C1A04CF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:46:26 +0000 (UTC)
X-FDA: 85197825972.28.A192561
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 13D7640007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:46:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GSPF5uW/";
	spf=pass (imf07.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789044385;
	b=LoUmNibtrO5N4yfVE3etXnjr9wLecRcMz3KQIseDrMqJwPMaDogx8jFUpT0oa5gGbKQIGn
	edbj6SP90HudOXQ5/zmIgAcwG1RYzd1CmZSDSRSMzwz7apD1g9EBtkH1+yKoMy4Kp7uP1g
	tKOZdi48zigBQHB1Yima25JCi20HjAs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GSPF5uW/";
	spf=pass (imf07.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789044385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vc2ebuT/gZxQ583woO22IdxSOoPW7spjcm0Yx2PCB4w=;
	b=Kl28ZjVoROjE6o9B6tvnrwPb/85tiNQSEQTSq4bVTHtBLQEoUBQNUZWNKQmvpnzWRdV0fO
	MPRz6Tur1pKfToU8fFBD7I5A3tlasQ4bTePbSCZiTvUAkx8tQmV4+n/tCIgDzPau02DS9+
	mzgb4uC9h8uNS3pm5Ds+G4k6Jpzqsrs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23F6C414A7;
	Thu, 10 Sep 2026 12:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EAC1F000FF;
	Thu, 10 Sep 2026 12:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789044384;
	bh=Vc2ebuT/gZxQ583woO22IdxSOoPW7spjcm0Yx2PCB4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GSPF5uW/jcetUtIMNlVS4/iiup4wv+LENAgeuSiC0KorUy8ccvESxDyXvOEp0X+51
	 6ND97+J1Io5nJ+0fBkKkegM1k5CibfNyzbOnAJKOcwNZhFkwMk+GRYApqbVR5/GYA8
	 GEUg0nIBTWaeD0tY2uc54tVIUd8pIvKL4YwWS56gCVgU+PGswvwwn53c3vmsPhcbOF
	 ZJK8shPRYJAsonv3ggksT2wXlIF8ScpSNsIsXOMxKfDeH8vsu8aClNyNFQ4vnLqez1
	 Esjj7cHNaRCnXFV8zu6a1ui8wCRl3unnyaoBLDRQ6GojQgX/DMwaVVHgIX0O21Ffcz
	 8Dl+MwahL95Hg==
Date: Thu, 10 Sep 2026 14:46:13 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 11/12] fs/proc/page: clarify comment in get_max_dump_pfn()
Message-ID: <aqKmlYJDu7au3yWk@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-11-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-11-008fc8d579fe@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 13D7640007
X-Stat-Signature: poz34b47e91xcuxnippbwte5xzucaf6d
X-Rspam-User: 
X-HE-Tag: 1789044384-843050
X-HE-Meta: U2FsdGVkX189PBNBjwKN+E2pFu/IB3LD1KjFpkFg8Jm1SLN1mY+32P4dTcv42/E9q6pnNmgyBH7sTydjaBWRpkuwmtbIx5MJ1NvS286Ym/M4aFJk1hktbBTVp65VdM5FPriv+tBjKJdt2t7WnrpUMvrf/mRctVqyzfPDF1JOtzA7nJtBbsT7df5R0n7WWb0dsU0l1SXLzsy1KBclFSdOOojzYF9thLCtBlmfONA+1Ddei7TjFtDWPUjfpN5GbLxl/vEqEEJLeZgb+T20BKchgW6RRF+VMlFuHEEaKmPq7PvwAFKUxZfcVN5eekicorx+9sl7SjXRXb/f2NdKZUFfTOmAlbqlGaqdfLaECuZuyyNADMvITclHfldLSmUqmCf9DHLBeEadQYdi0O93AoXuZXO3g1LswZ+mHYrJhPiBc748JRSholl4RTg4Lc8no59O0/CQE1hCI4xQCC4rFwCEG2DGS3weSGrAqLJyQtd20h9VSHCiFZneDLVRntFgQmb07meJCzRini4fzbQrqbhyyzJEuPs9cg8GCZsxMMjx841QAM68uJO2iimtUd08AQSmW5IZ7GqCq9JZo3FAxNqX3WqJCMRgdUhR+ZAcxrnHbCWqwFKxop1mvNOOsKA01sdoJSTsOByYgSCqnoy0ORwpefxjZrTW7J1fb2npA0W60yKNBRBP6WUtw4GJKO43o1WWNDiVG0uI9yVUF5RL93klBJ0WhXekKTGbB4rC7aQm+nttkvEgMsAtOg7NzRgPqqxTtrfdb9GwyYKnxAlhfdGYkuSxd5Z+G86RuRotkyO7IuS8t7Q6tsESuQzCcp37+yiDwJuDfMSfTVcNRwaWJlY0e/UbTkxOBxGwzbqDENo6Z/MDFmZIjC97fksRWE1kdTF1IG3VOSxXuITEhGZv+aR3uru3KHosUhbKnVICoZrWkcDJwqKUlu91yY738GTtX+Z+R7po9Sl5Kno5TiH60CU
 jXIOrbN3
 G9YHrLtXf4GPh61MrQ4oePF0YthEVE5AsxEph736hAr7Uh9IJBNbnDE1YsjIlpmwQJxrfCrxPlK04zLZk+ziUz1Vw4ezYrvwcCqyu0BbQrJb0FRUAc7UUiFV6vXMnZQ9RUCXPTuVtcr2wih3iLk6SIWSlPWg0BMYHLXx/IR/sqN7piBvRfl83R8hPVACrUcH0MBAUbzKMOvzBiYTRYiBel86/H65ELIjKQPasYZ6YPGAUpWYLkVRib7jstk57k/19kZAvRaWk14fDe/Tm9dkr1Hf7aKw/86iwkhuze1qUHWvbvSu6euemCSPgC7jokFxGIcKv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:33:04PM +0200, David Hildenbrand (Arm) wrote:
> pfn_to_online_page() will only succeed on some PFNs within the same
> section, not necessarily all. Let's make that clearer.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

