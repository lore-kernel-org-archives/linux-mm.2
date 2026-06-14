Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE043CD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 12:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8A46B00B6; Sun, 14 Jun 2026 08:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CFEA6B00B8; Sun, 14 Jun 2026 08:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6236B00B9; Sun, 14 Jun 2026 08:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9806B00B6
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:03:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DAF6BA06A3
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:03:01 +0000 (UTC)
X-FDA: 84878382162.16.C0171B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2FE6F14000D
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:03:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LksRWX1M;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781438580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8j7GYUuL2qMg/N1iU231lLW5+hnbXNtQC2/ZL4IkuJQ=;
	b=A3qIHo3+zh045PmA0ojYZCgiP49zt33OEs2QKAJ+L2LJ+MMqOdDAh69XE9qnKPcn7LBAoa
	opcNd6C2IGbtz2QjQ8MXmQMyMaPyCNAMexPPhtZ2Cbd4z2lsVF2VIotpH+B2eeoZFxUr5u
	HpSnookAd6j8HhU+Y2PZ4Mapmri/I3w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LksRWX1M;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781438580;
	b=7EQNw8lgbSAVEud+D1pQYG9PtyjfF8Ln4cSbcFCJbsnBM0mZG/XzlT3TbOpfSCwnyH+2LI
	w+Vn3AO5ZbJjL5TBcUXNM4zdTmqydlxMWTmOYCAewl5llcp/NJCWToGZkvbe4VNlSIfJt1
	p+a1qm88d6AZERaDUBL+h6WoMBAasUY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0FDF60132;
	Sun, 14 Jun 2026 12:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905231F00A3E;
	Sun, 14 Jun 2026 12:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781438579;
	bh=8j7GYUuL2qMg/N1iU231lLW5+hnbXNtQC2/ZL4IkuJQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=LksRWX1MPElWBZDiPqlUaZxR1aOerveBqLKzAlufmwBiZO6rbt79nA0DXZnELiG5w
	 U1+3SU/3/cgJcp/h3aowUy/de08VtPRQb7S8tDJCbkKKBYqCp2LSo7YOzc7hAU/9QQ
	 Pa0ufkJK54qwnsQoJKeUUgdc/J9pxAq63oNEj4Ut5nc7zYEQcGOvIknKzPdN7S9Bn0
	 Mz3dgF9BD7kI3I0eLEecLw4I4YBfCzZqtHvvcKzCXhas2NgkVqcTqZ7iFgSPtksg6N
	 GrbkpR8TIu1BnZKgvpDg41hvsArRTvFihGv0kVDx/we9PNv5KRM/QhltLpal+rhoGr
	 148fOZU0saLvg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 17/18] memblock: allow calculating reserved size by
 flags
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
 Jork Loeser <jloeser@linux.microsoft.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260605183501.3884950-18-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
 <20260605183501.3884950-18-pratyush@kernel.org>
Date: Sun, 14 Jun 2026 15:02:31 +0300
Message-Id: <178143855122.2123877.17100233420255303699.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2FE6F14000D
X-Stat-Signature: icpiwtcae94aq84db3tfw587gczgaho1
X-Rspam-User: 
X-HE-Tag: 1781438580-656994
X-HE-Meta: U2FsdGVkX19Q/WC5E3sC2wymwb9crTOtIH3v8MmLvNtv30menwMUQBfJJcOPi0dA1r9xjBXAJS8CvR/qOVfEuPU+4JmHk+VA06zOg6cLyu2fQ3DxaMZsEiNlJunFSmDVOuEnc+R29QYi0HOCWWJVHblJjyPOUYRSO5NPD/0QiA8f0bWwfQ5EX+rk80jZs7FjXvJ4N59jYKh3slNfM1yJXvGqp3bjujLa0LELbW5Nt+bm7L8+5kUN/YD5U6+g0WNv6lC0gpRRokDETsmpSwqH6HT9WhAIbNYKccIKgRIx7cQOSddAax4ImidUSmR03ZY767GbJVzU8+RCGOM2UKfLEnsQ1lZlWWCDu6yN3huGtWinkPQeUGw2zhPp8jULyu7d9U/pZyZL/Ses8x4xRokDQIOBvrs7xhulPnCmTNfKM9vAsvTzeN0GUpKyoBIMLge/qJdb6xTAX6cboMAyhbqrKPgz3kujBk5T1xKUC3j7g3D/Kvvoj/SSFuXhdp1lTGFGKwVaJihq3ujNo8fW93h1h/JCmPZKeBTs3+Em5NS8Tpuekh/yxnYzpcLLDlDe2nk/k09ROfYfNLUVGuLD/s5NCcZvobBTkSvPnixGkfg+kpSp81LU4BjYSTb6KvX3Nd+THbd1y2eHitKtnBCCKJKhOuDLFz3/NjzL9OrCtdBDUjLg0u5kaJvi1rYOzHelV3GwU7xlugjrtT5c4hOMp51MvhG8oLi1BwAi3BzxkhUzAmpITNxD1QMup02XzMfXd6/5Y5lY2WkeEc2algvh4HDoy65IhxcXtnwWPILsXAMLkdT84YlFUwxcXKslqAe/7+7HPoTIntYYnTUcvlKfKM6DQMJCmpEWZQZl0LxJC7BQGuHjk7j+8vQeo1NvYkrBkODUykNiR7E1i7Qf2PAlFzx5LPbl9uL6jbwJ/T2pfhEUJE+Je6KhEUYOWiVAl/crelYOg2b+mpG9329Xu1zbfSi
 LVbvYEAa
 f17clU9/5tJSC6vVO0tSZmP9V9QPQFu3qHAfvtnSyrcrli2QKTcP1to+tO5Zm7SpbsbslBih+RqijSSb0DA80KO57RiBYIK8QQa/52J91JC4YCiJKXad3ydYPFBOjZfJ+2Q1C/FrKaje6EkAHbCc1r/1GYKs3YJ+3DvV47gdGZ+7N8NyhqBJfLEdn8C832CzKqQ7BWcWvMZlt29gEyNNnGhiEKzP1v09MXD8qMi0RJPXR/XjUomaCbp4jLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 05 Jun 2026 20:34:50 +0200, Pratyush Yadav <pratyush@kernel.org> wrote:
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index b3b4a6145fad..a3b57066611d 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -487,7 +487,8 @@ static inline __init_memblock bool memblock_bottom_up(void)
>  
>  phys_addr_t memblock_phys_mem_size(void);
>  phys_addr_t memblock_reserved_size(void);
> -phys_addr_t memblock_reserved_kern_size(phys_addr_t limit, int nid);
> +phys_addr_t memblock_reserved_size_flags(phys_addr_t limit, int nid,
> +					 enum memblock_flags flags);

Ugh, I'd hate memblock_reserved_hugetlb_size() less ;-)

-- 
Sincerely yours,
Mike.


