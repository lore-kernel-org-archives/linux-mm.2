Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 141B8C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08EB6B008A; Mon,  7 Sep 2026 14:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB95B6B008C; Mon,  7 Sep 2026 14:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9C36B0092; Mon,  7 Sep 2026 14:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A20C16B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:08:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E700C01E6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:08:33 +0000 (UTC)
X-FDA: 85187751306.27.93B1B43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E542AC000B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:08:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ox99Oq+E;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804510;
	b=OOgnCHahUaejlpvAqlRhTFLszkYQcC8xTTZ5HlhTz0wjSZRDsw9S2wHVa0SWK2vOCU45O5
	tH8WyNSML0kyt6xGUaPlXesAdjtH+Yd7PI2ya6XrtuRONaRk/mXY9c3mp/q7356MHKkrGl
	ECcV2VsR+c98B9Hud4UNWKCsl8iqPQ4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ox99Oq+E;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuZcYPh1omkK8HEZAXjbGNcKNlLfSUT4dmGoKmWIVI4=;
	b=cqHofYILkfkIigFE4joeY6ddpBGm74EA8XwOh2bSw3RDHCyypUNSeW2iu13MfOopMM4pt7
	c3frAApdgXFtRZjtKIeH/qgW8HiR7ykx+Hv5vBOGuztPrd4y7KTq48htsFe4vpvlrtDXmg
	G6U6rZyd0ziCoschK7rRnZyMP4Sj3K0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26C5B601DB;
	Mon,  7 Sep 2026 18:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AEAE1F00A3A;
	Mon,  7 Sep 2026 18:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788804508;
	bh=MuZcYPh1omkK8HEZAXjbGNcKNlLfSUT4dmGoKmWIVI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ox99Oq+E1x0aCR9QfZaBIpMRK10/Kaz+mG8KeuckNkgLWjCTRzhtUq9JVB0EC7Kk4
	 GyF6+w9CgAafQfKNTcgK+OP8NtRg9l+qZXkBt2D6yc2VcjVIY2v2tPr3FvBO7hZ+u9
	 HOw9PmMgwLbMYu2z5RcvdsT/8Q/SeNDZA8eNY9EC3VrtEtjnrn+VC1Yd6iGZlxDZW0
	 dkcwA/ZsTTylD0Mw6FVLZYdzk5AdR37rXI8Ztz/474zp65yfHdeSBoT7iPhimRqcL+
	 KpFijJmccHuhawmLpX4haPNle7le9+KNYH8p/p3WO10Ba3uBmEmtMOHTHyJYRb4YcB
	 QBSh6NQgvMcvQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/vaddr: avoid hw-driven pte updates during damon_hugetlb_mkold()
Date: Mon,  7 Sep 2026 11:08:20 -0700
Message-ID: <20260907180821.102875-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907170358.100168-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E542AC000B
X-Stat-Signature: mfrhjakkyfzzr7howt1t7p4a88mmo3ux
X-HE-Tag: 1788804510-150541
X-HE-Meta: U2FsdGVkX18mvNim+cRKVHPeFyVwsk2q2A+mo0AqBf/HBjgzZCQ8UkdBCjlHj2KvEM4wEt1mNECPZjmNSryddi6Hkb4m9l3pQFxEzKkmRWuDoLvdrIiIfcGr4d7pwV7HjujAlarnP2ARNvRa42eFdHp54n9demBoFCVfnFt1hTaGg7/mHN1ANem0kR5SrhvtJKz9CWE3Lejto0JbYac1HzZYNWatZycGshVj4zsPkwU79yNxIayleDrr8QJ5Jz3iNGqkDEuQQoq4G60QuiyajOZQcugSwE1gA2IKE+ixwQ93kT0+ShKnotIMJcs1yS3gibt/LFm8xJtuaqVOifpSl2DYyJBgKGXO5JOYgHqHMmHBJAvuctK3XWBQN+K4tGSZnSbbJP5t+JEzBMcKkKKRcfXyd5lLgU/Bqpe+tNWwRy237k9jVzHngCgGnlcqbUPGUkBhJGusKUzPfuySQt1SF/ea/HQ6PDb3waE0Gv0CpQqn4ptldj5sCZWGUWyBfKVyGxTM4bv/60nAdkB2mCkVJwhXMC2Ed3blPvPytMtqJ/VPL3OmL4br106jPmpD4EKGQ4KqEctSmR217ItOAxn0mTJ1Ml3UdeV25uNZDRd7dyL2xqGwKn4ofzBv3wuLVkenJKMhqxk5X+2XMcA8SRw9Fguvxs3Ozi9LuVxdt4nxLAjUnbGN99VKodAIC7Nenn6fIPyDPEGlkf5iJPVWCLCpqEcnLtSP/g9IeuR93ePFT5Nedm/8acbpg0pU60oN1earxmVA3Ft8KrxB2+6LU7pcI2Q4fWhSxPF51U7if/W+bsLAiHx5F/JIYuHPEfFY4ygG3jgppH1vl05lwk0SMYM7eHE1vYl3eb67SoKxaEQvOEhzxviPR91GjjGJAukcl8QBYhdi1jBqH6DsXOg8VZKaihWbwQJSlUXUVgiDcidwtfyKOpGMBZ2ifKe2scGFTlRjZc1sBLUUw7OiQt9N/SH
 8jWmkQbF
 r1x2OCRKsux/r2gysHNk0YL/oknGe/2+89F2Kpmfva2hFHFuOYpTTyM9qxaS7VzK8nElF7x7SY+T0tdR5YlwRdokh9L2nfLHgLNZmL+YTyWDYHwS4HgbF7dOSSN22TQqDkY3Rc+I+ooENFhD6FCSqKFKUlVPsvck/SzIT/iXiL3NsKjrRl7lnBg3hjv0Rw+EGNT6av++NAwRtzScq7EYPHpY5/54kEhmFyUSh3k9eXvyjRx9E++PzDQmtfRqC7cMRe8fezV+QfcJYehUOtCLNu4u1Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 10:03:56 -0700 SJ Park <sj@kernel.org> wrote:

[...]
> +static bool damon_hugetlb_ptep_mkold(pte_t *pte, struct mm_struct *mm,
> +		struct vm_area_struct *vma, unsigned long addr, pte_t *entry)
> +{
> +	unsigned long psize = huge_page_size(hstate_vma(vma));
> +
> +	if (!pte_young(*entry))
> +		return false;
> +	*entry = huge_ptep_get_and_clear(mm, addr, pte, psize);
> +	*entry = pte_mkold(*entry);
> +	set_huge_pte_at(mm, addr, pte, *entry, psize);
> +	return true;

Sashiko says [1] this might violate BBM.  But this is only for accessed bit
change.  So I don't think BBM is required here.  Also, we intentionally do not
flush TLB because this is just a best-effort monitoring.  Please correct me if
I'm wrong.

[1] https://lore.kernel.org/20260907171613.A09B11F00A3A@smtp.kernel.org


Thanks,
SJ

[...]

