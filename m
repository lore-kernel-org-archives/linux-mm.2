Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E45F2606A333
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J5JKrpeR
Received: by kanga.kvack.org (Postfix)
	id 0C6196B05B0; Sun, 22 Nov 2026 10:45:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04E6C6B05B4; Sun, 22 Nov 2026 10:45:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDF36B05C2; Sun, 22 Nov 2026 10:45:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE6FC6B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44119A818D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:49 +0000 (UTC)
X-FDA: 85463180418.24.4DC3327
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9E610180003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5JKrpeR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362347;
	b=ONSjEttYYZJ04+1CMzYou5OxFa1u84xasYcchZ8r8Za2riFXj0skiuVub1IWO4SZWHZ818
	+YFigVd+NqcUttm8nbLrBb5z0cWT4ijWGgvtIfI9r1K43l5GnPsOhcWyRjX3OqxaXAYkLg
	J1zQCk/WW26HxY0Pg6K81tJiLhj+uyw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R06u0i6qVr/ExIhOD9ayL8/TTOc1DfJVloR61DvdyBE=;
	b=4amm1MyxnKRADLCaLNVqrVggemRkBYuUaCSJ9hrjRWuEakLunkaERk1SWaQ3ze6OIsQ6zv
	yK6dbU+VWwoiRNpf9sW4QJurvkFaAvnXmg/MaUkH2oz8dP0E4JDLTEQBXNYmb/o2Q56J7e
	G607ACE3dMRtEKVanTou6ALkbmnoNHA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J5JKrpeR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4124F6188A;
	Sun, 22 Nov 2026 15:45:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C111F000D1;
	Sun, 22 Nov 2026 15:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362346;
	bh=R06u0i6qVr/ExIhOD9ayL8/TTOc1DfJVloR61DvdyBE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=J5JKrpeRbv3KoXb/fFkbQiJT8oCObVmV5YI2MMz1JdmXiwwwcf+/s+uTQ1zrBptSK
	 P9grABDegn8ECnf4qHT3ppteLub+cZLns+sZRMnkn1GVRRR6M0ZjguTQRLj0qiOZ0s
	 l/57wwWJ3IutPARuYrKlEDJmsdLGhHJ4O/Nqae2TTw18CppXkhChCaU7vnPnz/OtO4
	 4FH3M5g499Alom3DtZ7KnbEMnjWkoRdLlGgLPfG1Ixpgap0O4yYaCS0uFVAO/Ou9tF
	 8m0e5XWPpQXrBNJkR++PNgBdVIdrcHul/KLJXCxw1E8iSX/Nk8jqsib3TegYWzoBh+
	 ee4lyl7ihv+zA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 09/11] mm/cma: centralize CMA pageblock
 initialization
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261120100856.16929-10-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-10-songmuchun@bytedance.com>
Date: Sun, 22 Nov 2026 17:45:01 +0200
Message-Id: <179536230138.3933282.17513671725421744205.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9E610180003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6e5o7ipzbu3pj9t7ejqj8k7q88njormy
X-HE-Tag: 1795362347-777980
X-HE-Meta: U2FsdGVkX1/JzGLm6y2d8mR7V5885WSPbd6HKu2DR+NuTHUeLw+KTSgzqdoxZIDD6w4O6N2i9J9ij7M809ShO3RFSAZrBpO56IEfgQvfCmPwWYbKIaFE2BEiNV8vmV8XHuc7Ttn1QFk1JN8IEdm4h2/jS9hysPJ9YRLGWOqmiqpjEgGhse4difKOPpIp1a81Zx2g64GokMrhz7R8C9KHdMUtIdx0T1MNjZz6jryLtEx8A58QzXylo9jkGyDzPyNJsPwaABG9z8CX6ygTdSWMkjivyA4eF2K7OmDHDJTco7cTY6BLNm3WZ2OEjlK5zJdO08pv+iUZdoqRcpSWyeEqFRSQhvymj7XLbPym0kdT0yoiseP9WiDsxX6kg8q70IMo/NkLyf+0vRdsuvGO3EWi/029InIrEVn4drvbgj6MjLdXvPnk6Lp6y/s0r34xw2eWwY5RR4ydSt5pMWopmLrWhQ2Kuo0LtY035U3y9/h0as1nWEq+i6UANTkXJk/iPvIs7Aj+J4izzEBu+JwwYzA+VeTZE550bB/JZh7xenPyV3OG1jnoiQwT/1DwLfIxHppt/4tXePAyIbbEaz2rjhcNKvlgqZX6UKNkGlPbrk58pMcB7T9JOA91gKJkzpCtFn3rk8XVi9ZCrg+QJCa7HG5f9CYuHC/1ZtYToOKoyiagCtCFzrhlV4AMm1r3azyX95Me8df4jWOsTQxUwFyI0JxF1nH23H4/K8kNiWJtt8aQu/RQTpz6mfoK/fswTojkCzOq8TRV6Txw9YQNySekPHnoJUS3x36EVneJotTZACWoJkt7gL2q/A9SIZhDs9coCwoBfdg8ggvjox8BJjQDtRZ33Iw88rMsN+hfxoBqzkXyix+UN4yb8OWyS5k7jekl1DNHkrYo7i7gJbZ3sSRUgwCorVYD9HVyexwqQiozUXr4CxUpUqtLddAC0l3XPeEY/AH8y6LLgX/ZLTtjNAcNQYX
 W6z1c6n8
 7dA/9TpF2w0vwxcSQwKYXPSsCJIFWJOgiysXA6iA+ruRwVL0qx4D2PhHLfURRisptP7fywcAl0O0h2U+l+D4vIXoZgkWg/rPOCIB2WkAV+oWg0r4ErFfrNXBY8rQ2uGddp1yTtHVEnmSUQuW0yBhOszo1ed/3PvX5er2G6fEKL8CX3mRuJMidRYwlimvzdP2bDiL1EAnjyZK5Rid//s+YEmKx1v+hqfMrkcs5XGM3FO4u1SGCi1aBo2pSBCzDrTnPMmjYl43SgSlZHy/mOw2ZwFQmr71ejUzzsNKHcJjsUPG4n9IH3MzhpfNye+sMvjHfDmZfsC4E5U+qsVASJ3kmDWGiDStzXgKC1fbMpMrBUIzkS+YnSGJyDm4MWkjqJ1I92ukhK/lBA/eTxj69+oOCgXk7aQk9bR6V3/kAeY6H6OsKms7RAlc3QIAUi6UIzHpUOjXRg/Yog/CPoxXf+eDeaogPa47CjEDXNBvwExaveKByaOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Early CMA reservations currently require callers to maintain CMA state.
> This exposes internal bookkeeping requirements and splits responsibility
> for the same area between CMA and its users.
> 
> Make CMA fully responsible for the state of early reservations. Pages
> already handed to a caller remain owned by that caller if activation
> fails, so keep their managed-page accounting intact regardless of whether
> CMA retains the rest of the area.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


