Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC3B606A510
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YN29lo+k
Received: by kanga.kvack.org (Postfix)
	id 7CCB26B05B1; Fri, 20 Nov 2026 01:04:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D586B05B2; Fri, 20 Nov 2026 01:04:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693746B05B3; Fri, 20 Nov 2026 01:04:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AEC96B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:04:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CFFFA0D5E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:04:32 +0000 (UTC)
X-FDA: 85454457984.01.A0F77B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9C452140007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:04:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YN29lo+k;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795154670;
	b=C/UqU9hQPioCQ66Bej9lPz6QETsRc/06nb3Z5cgpcGvbxN1Ye9Lx3BXTag8qdocQYEznHZ
	i9ZRZbJ9qyL3MJfgV0UxQ8XHvpB8EuMykyrazgeglPSgNphGdEUZEvylGnbInSHJ8xbK9P
	+BauLCDyLyrjJkNgsRbSRmuAulYTNQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795154670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNo8yliNdouUktBX46FmLDoA4S8B6QiUkCM4qwHf0Vk=;
	b=acKqk0IdF6V287xV8BnYwnFfGYfBkoj/ALX+toZlS0oZVDfI6iQMOj4tfHLLy+Y4uM/MAM
	FS1MwBX3gi6BZwiuBVCwMbjK60jEAKqFvzZMg62rbgmy7INUxKM5qrY5CKhAv7F2aZyPoe
	NN9LGyX8IuHj3CUp2BsvvUUVogF6bZk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YN29lo+k;
	spf=pass (imf09.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C3DD40770;
	Fri, 20 Nov 2026 06:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D471F000CA;
	Fri, 20 Nov 2026 06:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795154669;
	bh=iNo8yliNdouUktBX46FmLDoA4S8B6QiUkCM4qwHf0Vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YN29lo+kKvCpoPcXXBE51pZ9MlGx2ZtxPeJM06PUnMQAI8HJaZzBCnhs1XDRrHg9+
	 ufcJhGmSiExYJqKlDrC6ulxKS2Pa0b0ytUlbjrtFzj/kD4NPD+E/Li9qN0UY3w1K8t
	 nHz3NmYRZeqg1LSzYRqnT2zlo6b0C70PGUtgdth4dK6iRYbmhuhmxF0SuxGLr2H+v+
	 ordNpuCkrhex/7u9TtQZXHdeopEndlAbDO5clsBP8XDREHcj7rTibmIRid61FkMg/R
	 cO5zPr04/STnhssCv6obIWuetp4cavUttZx5SKxSkB/5JdvIA8t2fz0nhlP7iefaZ3
	 VjTDdJLk1xvxg==
Date: Fri, 20 Nov 2026 07:04:22 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Usama Arif <usama.arif@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/memory: don't map hardware-poisoned pages in
 finish_fault()
Message-ID: <av_i5hZYLZAbkPgZ@localhost.localdomain>
References: <20261119134236.3745231-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119134236.3745231-1-kas@kernel.org>
X-Stat-Signature: bwhjsgn7genzr1scpemoym4tfaj16niw
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9C452140007
X-HE-Tag: 1795154670-468980
X-HE-Meta: U2FsdGVkX18Pl0CgvzIYIWEnOMOXM2KyEZ48DFqprlUj76l9qZvH7Kzm7pC08/fV7xZcQQim6rVjURubrFLayWtZ81CMsFyuW85WxnVhf6NVrXKMzxuPOZcBTs8KQjz/DlugE46qP6rpQcOAPzmAg0yfm/2ls7pAA6MZBXfgZHClssbznJ9SwAM8iJVjwLSeGTAR0WA7q+V7TggGRlz3HlriPNejpqK/7TVbY3LRt981Gx2ygzDJ0iaorZPMsQoAynkoeeOSc1LMbvliq1NkSBo0856op3vPGiMrR/TJMa171fOZljUTC/LmCCCjQ6g+6FOvc/3QJL1fQC5ldgb+EQhylicqk3tSMOmJn9T3+9LSdyJ8YtEWQOpj7qBLEUTXePLu6DqkkyXzmde4R361HX3W1QNSA2NjcX6HCM0s0fjfTMcqSZlHl8L08GQUKsvqrL4fRB0TQxmRSclz6pqrPXW5NzV38DH3Anelmki7aLzGjvCFEhusSACWglEZHCwkiEeKhbJp4mGGDTI908DD4yv3cLO66HCsF2ZfbwXtC4GRYXdjHwh+ndWHkERbb/sx/BDPcwz7cvu1jVyrvzydNXME1DDMS6cNJH62eDYnuqd3IGp6gi/Qc8LiaQmVWs1lkPeuH3obGxCG3jyc1lzYZH/yUTY+IBrVjIJP0NLm7LWGJY3QgiSAIZBVuhbzpiWXHiDj4nBXNkvbloPumMW4e7Kh3mDAM4w9JGRq4nN2EuqKi/jhQjAXzojDmllw5zl1LgzRRzc/2fX4aZ/+wLj31+oUzvtKF8IvrrQUbslzY1VPz4/7Kt4OrSBZuxTsOiudC704gR4OPM41B5J5YYv6ecZOXL+sPJhJNH4uJ5sQrIYGnhTsMevFHTz2+Olm0/m7T7FZscuZ+9T5f+l6ygLoVpi1+1502sUUKiXXI9O1S7ny4CMNW7F3YPPD5bFLv6nE0SbdxLvPJwbqjWncx5c
 mEM5S0dt
 sNQATg+YcK3NwKcqSEAB3CLN0vpigVpj08xcE67E9tkzqNXrpUJFGdM23CiRFgY5as8/kE8lluqgrNBU4DuUzrscmyunLXdine6jGokrzGkrFMWdGwb3EFV2MgXqhQu7DmCis0lXGN3ExHA4mAyWQPB+EXYfB3pvrn3KvJV6LO+aJQs4aiYZZXRZZpTL4EnbUlVQvwBTJbZj7Fh91ixo09Vh6SM1pKotQxZDSWSLiUmnXahEcyc+A4OpckNvgSCVmWbO+LeVgLrE4r7yBo+PMs3zZDgOwL+7GvQ8MOt/WuD+QUAkgjJURHHsfqr0hptae3xmolUI95UrW8HFHHq9dmFfvbs9oFq9yibOcz3L5+1846zbHlBib5dudx1bMXJRZ4ttvvOt1aWC6/QB+AddSZM5QeG543zPS/UEnGoJs6VCR3eoYgrHkWS7lpNcLmdAA31yMnFISDP5ysGqQTmt4fFzxhjESny9u9w4yst685zS9C922SvRe1p9W+0ESLUa1xducVKdePk1DrV6CDEIhcWFqsuRz2LJAdQjhkb1SJqz7nPl/jzletN4/hTdODzwFoUZ9j+FmnWYjQDrZzjVI5SvH4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 01:42:31PM +0000, Kiryl Shutsemau (Meta) wrote:
> When memory_failure() cannot split a large file folio, the folio stays in
> the page cache with the poisoned page in it. do_set_pmd() refuses to map
> such a folio with a PMD, so that the poisoned page gets its own fault and
> SIGBUS. finish_fault() then falls back to PTEs, but maps the whole folio:
> 
>     do_shared_fault()
>       __do_fault()
>         PageHWPoison(vmf->page)
>           // the faulting page only
>       finish_fault()
>         do_set_pmd()
>           // backs off on has_hwpoisoned
>         set_pte_range(vmf, folio, &folio->page, folio_nr_pages(folio), ...)
>           // maps the poisoned page as well
> 
> A process that touches the poisoned page takes a machine check instead
> of SIGBUS from the fault.
> 
> Map a folio with a poisoned page one page at a time. The poisoned page
> then takes its own fault, which __do_fault() turns into SIGBUS.
> 
> Fixes: 43e027e41423 ("mm: memory: extend finish_fault() to support large folio")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

