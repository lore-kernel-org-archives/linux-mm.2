Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CD3DFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5ED66B0088; Tue, 28 Apr 2026 03:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35EE6B008A; Tue, 28 Apr 2026 03:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72FD6B0096; Tue, 28 Apr 2026 03:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C77156B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:19:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C83D1C0814
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:19:02 +0000 (UTC)
X-FDA: 84707112924.21.5E8EC07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7BE15A000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:19:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YFtMVKnP;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777360740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QaAEDE4karRiLhj6T5smg7SeDy6M3hgvKR6dHn0tccg=;
	b=MQpDxOWzMU4JG+qpnJhiti+Tl0QiUABFHhreKZ/K9Br1zU1FaRLNH2rXfwIT3C/+YmVEzm
	atFk86+lbd0vRCkyaoteoecXg+a7bMSuq7Cc1wjFbhhKbhoRAGQcmc/kkAR07RJsd/J7XK
	3sUYzRJkrnBYRwa+N0hBme54Y8iKiXY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YFtMVKnP;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777360740; a=rsa-sha256;
	cv=none;
	b=fFuMhqqePmtlw4GAiaYhkSbMjf3hOctAAl7FZxTzLY3UwT7hvICVuUm8VT1BaGbDFGmYgo
	Y1H8Au+I8lJ7IfynXfGP4XBV4WIIulTsN3WvwGOxxmWivsFFfiSLJyaZAXYpwVmdI8Db9O
	MgWDXfRliit7Esonct4yCsvUqKqrFGs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C389460142;
	Tue, 28 Apr 2026 07:18:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFBBC2BCAF;
	Tue, 28 Apr 2026 07:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777360739;
	bh=JWWk+ejNBKAE57oeYaLCSn1Yap7+NFRPWRTEBQ3yAmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YFtMVKnPM3cs5jFOwUhJVQjUEfE2Z5FFuhoJNast+eFJkUriDYYuGiXmCPH5ogowG
	 1yU8ZKpdRXZm+/pQWowDXe/g/UhXlGCOILIufrF5JDmqaUFguksSabcnP8/QdtV2x9
	 3NMESfK/Uhy23GkKjTts0AmQZQ9aPYgf5kiQ4l+8ZgZ+w9N9uzsa47w/E5mwvPb1wm
	 xJ8AZMTYHMkDSoP+jA+vGFFjkLVO3h5zJP0nKEFHkue8v2/TX1zZRrIFsZTijggN/2
	 07A1OfhxAMhFgv6+mp28+fNb1iWsaqXw5rOiFYAprfiMNhaEoHaXuuyisUMKPjCK/j
	 hqOKFlXAE9auA==
Date: Tue, 28 Apr 2026 09:18:49 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/49] mm: integrate sparse_vmemmap_init_nid_late() into
 sparse_init_nid()
Message-ID: <afBfWfwWs7hDU9qS@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-14-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405125240.2558577-14-songmuchun@bytedance.com>
X-Stat-Signature: 68rkpzaxfpuqycoyhz9nfwqw93r3xfte
X-Rspamd-Queue-Id: 7BE15A000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777360740-239531
X-HE-Meta: U2FsdGVkX1/H7YfHFYTWbJLWvnAoxZTWMh/gyW1hRuWl5m4oSSdtzT1uN4r4c4tnR2QMrfv/mAG3JUxOcrpdNaSfvIXJ/TaflhgpG89Wyi3VCkAUIFua7HHtuDEsYb5Zh0JV4FeEYDEdhinqZ2XO/5PTlMD4LpAsoE4OIH4IDCxoBMFQBDYQ55o0qWX2k7CCT2k+0Z13HXrXUcmZjRYsIiNIkPvfAOFh7T0v1WPfrj7GOOMT8nNiCV1CpFK5+08mftZq731uUJpmd7ngqCEwspOXbBWkL4nDSaRlTlc/zRMiYdDHPMcnZTCQujWRXRHDy8wVmaVxHv85Jd7ry56pRUp8xdn/O2S/bZELPJdi5U8lkczwoiViWX9bblpKhCdm9IF5y8PdmHm7NkjGb4vUi/1IvST9NG3Rc2vpvlHc+9efMAxrmFNZ4b09nX1MQtbZP+SJIyDo4W+/+LbgsbEWB4c40T48uNt+tdWwHt9hanJ7LurW7wCzNroNq5cH/fv5krcYUUoAkjy+N4BW9dqD0uWXCSmuN1QAPAiANnC7xFL9ZbjBQ0XBY+6GQ6UicKqZ8Gsq7ILthG/zy1Phi2XhAZBLGYHOuiOKUbg6ey+fho7zquxeCGWcabb/l78gugOwOud3hGwwudiNWSEzwek6lN0ouQBYkcv8n8wSgB9WVu3tTrgIcXfjWgVhPgDnFfcbY229pfVRv1854kzJDMSwqfeP/mWUO+gR9J2Q4Eq/qxXfjoO7yktb/8oYqPrvqalzKBmwIHxPtAMUAs7OCF2+lFGg0NUsJ88qFcZFfZ26n1T55kZkiJhTyYGj0zBhhNeJjWBGZzj3W6mYRWJTVimDgsgDObz2LOslp4f4/iQR3fTMOLRGCO7dxtXaExUAbfF04PxwsqAg64Fuh5ZeypWCo/TeE3MJ5BE+qzNYQEddzhapTLWMimylagxXSdP8S2+BIETb0A6t82cPdjt6hG/
 u/7EgV54
 19TDGR3IMadIDe5hfolQGeQrQ3Wb6mhUginE/TmUe/HQB+FS4Ie1qF4HVxMMY6dTCkE5xYtQbfaltLwL/dDcDYGv6T8WydgPy/lmkCSXsFSumaYRqzF1ZPMYQTNU0M/arIcq2Z17+qjw95juVBAlUqkhu2Nt9BGddDrxzTNDLPLRKkkinW3l+8nHuX61izxtSxf1kvKf7q3my+CpXZMEjKXu8M8aNxegCsb0+DR4UoXFH/pc0XyWfdpi5woq6+cR/+FmrRIsfelHg0WUec5uMgcR/Zr/Mp5XJesJ4usaUO8jMo9BX5MJsRdMMuMnGG41xdMX4jHNpbQSqlWp3FdJflSkyBrq49hmFC8bW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 08:52:04PM +0800, Muchun Song wrote:
> Move the call to sparse_vmemmap_init_nid_late() from mm_core_init_early()
> into sparse_init_nid().
> 
> Since sparse_init() has been deferred until after zone initialization,
> the zone data structures are now available during sparse_init(). This
> satisfies the requirements of sparse_vmemmap_init_nid_late(), allowing
> it to be moved safely.
> 
> This change unifies the vmemmap initialization steps by placing both
> sparse_vmemmap_init_nid_early() and sparse_vmemmap_init_nid_late()
> within the sparse memory initialization logic, making the code structure
> clearer.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/mm_init.c | 4 ----
>  mm/sparse.c  | 2 ++
>  2 files changed, 2 insertions(+), 4 deletions(-)

-- 
Sincerely yours,
Mike.

