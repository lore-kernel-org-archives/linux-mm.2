Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DE2C606A321
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 23:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RsKPsTZX
Received: by kanga.kvack.org (Postfix)
	id 81A3B6B05B1; Sun, 25 Oct 2026 19:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F19B6B05B2; Sun, 25 Oct 2026 19:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9EF6B05B3; Sun, 25 Oct 2026 19:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3303B6B05B1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 19:30:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 853DD4065C
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 23:30:13 +0000 (UTC)
X-FDA: 85362744306.08.35443AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id DD2A1140006
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 23:30:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RsKPsTZX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792971011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgHIB6FOcL0bCiYPaegMhdluu/k3cOQL1TguKu3CfbA=;
	b=2+qDsfO5XEHsBmRQWFnjXcw+21H+MPwUNStExAfxu9ZW8XjKXEt9gM4oHP5yFaI63guEif
	dC1HheNnpClYKpGdTfF8fvCzWrZ7f/i/OpRcafMuIeL5144sEpPFPwhSJ5oCoSl12Od/sV
	26w5nCzKNOxmQd0A7btT3nM5Y5FvYqE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RsKPsTZX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792971011;
	b=PNIazEGTNetu0ZNDa20h2i5gOYN8GBjsOgapBB62qE+hSUqc7mXaQswkQNCCQgK+J68XtZ
	ADV6GYndK/1EP86j6fUaroxgsBMuZmZVuzqSO3NFTnUzwMb48YhyAutQJNooR9BzWtX7gY
	yh0Mfk2Ijgs+MNOZLdHvj4gZaL6xi4I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 26E464195E;
	Sun, 25 Oct 2026 23:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452381F031E3;
	Sun, 25 Oct 2026 23:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792971011;
	bh=IgHIB6FOcL0bCiYPaegMhdluu/k3cOQL1TguKu3CfbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RsKPsTZXjG3XXKmYD9MfedxVJxvR1k+Bngrc8JlS7vFSfL05vAecigviHGlboP0fh
	 bWrvygLpdpuSlX1T4yW5JHZGUSn0nQm+uM+nxqdvo/AiyTLhOGoSpm+e/wI4VCUuOy
	 4J5+Plg/tB9Dr4QM8orhdzhNlkNS7FJ4BVrfPY2o1lslo7xZgWlpw+c5V9NQGD5DX2
	 JzjDJVqks/pk10gpOSQRNW3APUEx9JqBnkVPRKNEsx+uLTGI7iiYghuLaOL6OWHdTr
	 3x9uaxDSLSwfIzAVjLyfkCnjMWMBepRrweTG5+/4ccYJZNwaQM2FNiHIWNym7IWLuM
	 BjVrNu3BTHMLQ==
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 7.3.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Sun, 25 Oct 2026 19:29:57 -0400
Message-ID: <2026-10-25-1-daily-reply-0011-damon-zero-target-value-decline@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261025171526.157414-1-sj@kernel.org>
References: <20261025171526.157414-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DD2A1140006
X-Rspam-User: 
X-Stat-Signature: 9mmc8jknwgobjaiznayxus8ixrke1s8q
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792971011-950606
X-HE-Meta: U2FsdGVkX19ZxgQ9yUcfpP9ph6XFUfhUOt6qsMdeNdaorhrpbnRU8PIwEsQEBs921K32bjuvZ7xt//FIyGVG6klR8Vgcz4yQGx7fFyxYioh9ExNTQtQz2DQFYmfGRaYS36bIAdI4M1e0KR/i8Y/tD+5ciIoIACPi3nxBBkNqdrXixfDG8z3k12bbBa/osS8CruUOyvrEeaO5PJ5wOETiVg+Ki/lnwtxloSbAwC6/XryehdDxIH22hGnuZSHJMMjYYbf11MFrr9h+8rJTIKvqrhhZ5/1svGfj0cghMD2AgkyLRZPVE1XvsxxpPa+Z44AzqvG2wFr1J4otq0tXVXQ3yUNLV/MJHRXrlU9un7oql+nGTL/vEA095h3Bn7tmixjzIV5JaQt/wsur2LRiXjRohRUOQDadOzkDppePaq5BcUa74ECJvuvD2fA8Esf4GDW7/OttrsDPcaDDHnlTsXBvGkUjAHwECZgxHGZFk8FqlwVOoukl3geTIPALJeFt2fLjpXEuTgKWBg1CfS/+f9xWK7RX/yXmjjgN+VlSYqqMMd9Z8Jkg4HU4vwpzCDxWt81tvo/Dffg8odyXoLq6MYOyEhk1GogY9NUK7MmB93b7qwPl6gEa8+pD6Uz34LSOfplut5Jf7sr8wP3srQwGqzD0bzggzso10w1AnaGnf58zDx8/VextnI2YFWsKgwyyo9dJXT7VLABgOOikpZnKwciDAqNTb6e8Fus1MkVo/oGGH76w+MC0ZHpRR80vGT9dQy3q55trfKbklJnYRLWE2lAGAY8eAGj9yer3o+mQQ1ardrQTqUMSUyYia6akjRQupCSLfJGR5vh1hPFxSBHFt6UqeHSVFGo40GuP9rnoXgbO1TkpK8k0Kx2hsAlY6Z9y0Jyf/LhuIaLVXXm1bTC8e3tpGlvYXnBt2V5GR9RUt4IxgEc/LUt0lm7r7bHde6UJU7r3NNtYTI+6LE+YMsPc074
 1jd6PqL5
 vf3LHIsY8cqxKeP3P3Ux7F5HRavx0y82lxs8cqahSTgNyYU16q1cnv1cyPltVgwhxQqSAUnqJiwNlOMLoLEZoKdTmr1wGpHxM0/CjDqmLkv1VuDupWhDck+3pwwl1QNlHIYWygUMOG+/kA4LKnKN5bVl2IXrt5BW+Taur/tJorPQUWIfO68JuZ9ako9EdUci8CTt5bJ6c9M7TzOBUE6jOgbACgKsy2CXG0cKjFEg1dW/OvpqzoXSzr4obWbmNiki3uiCe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Notes for stable kernel porting.  The upstream commit doesn't have
> Fixes: and therefore not ported to stable kernels.  It turned out it
> fixes commit 8b549a4fd3c5 ("mm/damon/sysfs-schemes: commit damos quota
> goals user input to DAMOS") which was merged into v6.8.  The user impact
> is a race condition that can result in divide-by-zero.  Hence backport.

The older trees don't need this one. The callers in 7.2, 6.18 and 6.12
already reject a zero target_value (7.2 also has 06befa61c427
("mm/damon/lru_sort: error out for >10000 active_mem_bp") and a16fd3ad9d89
("samples/damon/mtier: error out for zero quota goal target values")), the
commit has no Fixes: or Cc: stable, and it is patch 1/3 of a series whose
patches 2 and 3 remove those caller-side checks.

-- 
Thanks,
Sasha

