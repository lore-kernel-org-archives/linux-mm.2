Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9485FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 11:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6F96B0088; Tue, 28 Apr 2026 07:41:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277EC6B008A; Tue, 28 Apr 2026 07:41:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18DD66B008C; Tue, 28 Apr 2026 07:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 093BB6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:41:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52F93A05F9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:41:37 +0000 (UTC)
X-FDA: 84707774634.05.38DE09B
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 778014000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:41:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I8PYwWn0;
	spf=pass (imf04.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777376495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4a/Yep8opuJO2xxXBuxlaVSwKZwZQ+8NCglGaJ0GMk=;
	b=8Zbocj8X9VH0DgKS/Qc1d6mjKz+Zr+DNCFf7RlnwlBBXOTXQSBS/r8+EPEay+uBuupxb1b
	Dv6JHU1NH3spgtIItJNVG5Za3HAKdXgBKFA+ekA4SvBBa9P/kVmnJAohIsR68/+2yoNC9U
	U2bR8cABrwmba2cVUIvjq65mtJCA5Mw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I8PYwWn0;
	spf=pass (imf04.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777376495; a=rsa-sha256;
	cv=none;
	b=cXpPdU3aVJOB5N5LVhfVvPOWiXi4tGnXQTHNm7kS/FxO8i8VOcbaJdgB94uSa4sRufRHq4
	FBhAjMpKSE35Atv3kSXXTPmYYpuCaBPCtk/Tq+IuwT7ZkyGO9RNLxxpoLTsodndZkEPImn
	mpdj+jZNxspjSgAbZoTemFo6CWcNecA=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-362e50b4641so2976217a91.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777376494; x=1777981294; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w4a/Yep8opuJO2xxXBuxlaVSwKZwZQ+8NCglGaJ0GMk=;
        b=I8PYwWn0+l0O6F/ezxtuWOzfAi3Di93Pj6dhiAJolCbMYoDGtn6OVdv6MraZ0OJ8N4
         Vcb2VB/uImFFFK3U+slZAzNAVkrm25qsNwkiMvN12zsAs+T35v9ZyKlnARPjCQxBS8lG
         aTulGVrKIFR5BJYLFqfhis5j9GkUWcKjABtMdO62BAOH9TcvAnMd6x5x0Siny9UjNn72
         JhS/and6eWA8NbQxnbmeM3cRM+nH9J2mFbEacezWB3Y6neeUEiixEx7AMPcN8O+fwLFv
         HGTtSYyFd8Fkoj1KKAskL09MfrvbV8w1Pfa3gUMb6ZB/VyYroKSZbDad3j63+MhC2PII
         ckIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777376494; x=1777981294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w4a/Yep8opuJO2xxXBuxlaVSwKZwZQ+8NCglGaJ0GMk=;
        b=RZR07PMT/XdUnvyvdW5NihUewRxFHv0tG8Il0WjvtK+WZYJO/sYii/L/3A9kSQadPU
         J1lUjAxMXqJS/floTHV1cC/uAPMZr/7/uQxuqtqyh4MVRFJVQPiEMzjoIAXK2SdKwEGv
         Ls1CCqpCx1RAs509L8JWW7OXCkq0LUf5fapxjFjyE30r9eRhQclusZQW9PGH0UtwbBEk
         VxWgxoZ1nNzBbcCo3FJpFAci5v//9Chi+286+rhB314M3AJb2jp6dmKQnXWmuKZ1+Wf9
         dUHyWW6sCxGGKJl6seb3i/bmqXn0VuRWq07DfCQg2pyPLNLgpniwoQBouu9gi2EUtrWX
         jBBg==
X-Forwarded-Encrypted: i=1; AFNElJ/KcdWgF0I+uvRDsGLOAp6jHRh07+WCzygePYwRxz70C0OZ/wO/v7WH0KVTknc4M7qPE3kMTtTLaA==@kvack.org
X-Gm-Message-State: AOJu0Yz97snFjj+b5OPQc5EGjlhKLcgni2z+bHAdtmemeFkK8Cp7xg9O
	HwDtGcM73qOpS84o4zEy2bkRd2KhzWDbQMl97XfsJSHQEYU42FLQn512
X-Gm-Gg: AeBDiesQFi5TV5vsKx8YiqG05mV4i+X4mWJSNlDdGxfwZdEscDv0R+5dDarrZdDxKIO
	JdBCwUZ20Tzkzf4aSIaLcyOj1UpzE5bACfKFOVMijm80cYGu6Ftlvdpz/pHuH96EGaDtHjFyNF5
	Ddsdezfvb3+sGgV84gdPuvKIa+OA+oTdYka63xaEIbj6bCWeTFfzx2rJ5yRVmBxOnfTFunjp0xg
	7PzhkKObcpIGBnzvaOLPxr5JlB1mj7wP2lhQqFMKzZE/hJTeoH7UNVTJNpWPyTvQ/oSl6TefmoM
	CqkN4QoxY9XdgEOm0AEd5aiS2Lty3SlHuvssQADirDjv0QobmXuQx2o9TxUTYFSnPw//+CqZnBY
	Nggzog9HeIuHyYr/H5QBNHSW76f8hcqyPKr1lAL+Rbc+WxsMtLlGLHzR7bF60kswjMHKzCxxS9O
	FM2hrlj04Su5h8Dr++U8HSn0IL+KMwSrdoZ8j80sgO2fVUhKjyYgC+wdy2ydxSbTupS1E=
X-Received: by 2002:a17:90a:da87:b0:35c:30a8:32a with SMTP id 98e67ed59e1d1-36491fbc576mr2900484a91.9.1777376494263;
        Tue, 28 Apr 2026 04:41:34 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.10])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3648fd6f625sm3488762a91.0.2026.04.28.04.41.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Apr 2026 04:41:33 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: Oscar Salvador <osalvador@suse.de>
Cc: Zhao Li <enderaoelyther@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix subpool accounting after cgroup charge failure
Date: Tue, 28 Apr 2026 19:41:27 +0800
Message-ID: <20260428114126.92091-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <afB49BIqmLL2RKHM@localhost.localdomain>
References: <20260427145247.84157-2-enderaoelyther@gmail.com> <20260428030712.66256-2-enderaoelyther@gmail.com> <afB49BIqmLL2RKHM@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 778014000E
X-Rspam-User: 
X-Stat-Signature: 9hqznhp98kc4jdjitrjqmgtaji6wuggj
X-HE-Tag: 1777376495-526341
X-HE-Meta: U2FsdGVkX1+gXi+Fy44ZP5q4N9YvewFdj11rvaPrN+7T/sYMDpN0ejzWZPgZO1qrUTDbMHIMnvl6851SFQZRj1cW4/gu5FO3OXXvHa1m9o9DN+gcqUlm/4RTmEFTZM8q7dzPR2OJPnjGcWWshuCrk1PpXn/lYtnpMyVbaevi1jPU5SZ60LYE5LpCQJ904QrwmzZsMyqkSvi1Z8McOcCDDO2VESPe5w7K7Ujm/EcV9lPeVkrTRcOGd4QqocgEm3A7k6H5UG4QMsUa4du/b5tZrz9yjRNtVGMw1hJWgNF6L9Rmr97yBIHYDmkBi8etS1CuQXIhWJwytp7m+YCOrIckIz+4pqCwFwWbd6yXo8xg/b49aCJFRB+C/EuWGhxO/7V2k0U/d/Bj60FNnU9LGg7E01vIQqgqpxddAoM/bq8JMp+n7fDxH/Mjdw6BsBQ76X96S5U0wDBRW6svI387KnqAT0odC4/w7Aze59ASsGAluhLO086vRKlEEco0cqOL+7nLl5oFjCRccl+uG/Fdl4lH6lTleloVYdYwaMN5P6rXd+RmWQRwrByXAriaRpyuilwsSWHvnYHVjUBfTlcSb1uY9tff1MkVYq/fHyPjCtYjPhboNFH6M6Kx/4OJ5RcGcn2dCBVj98N2ZrU4dFO9ED9FQG2H9KUxhU3BkvKWXQA8tmd6oypVXJzhdlHb4R1ocBRU8M/+YzgTVmefH5L57IO/IwJ3tEWVCBi/rkCOCRTcw8RBmbOy0c0a36Dq1ZgBPHDCHa0spl2IMlkI2yxBESi+Ji3h2zLmLbRUglUEFk2Pyd6LbFflKvcPlmRU1ETfu3Elltgm2ForjOQCZCAgWl556eFta7+ImfDMZfb/oIn2h5NT+rZmlCCk/DxVFbe85ij76QpI5oSw/+eHLwp9Avnm81BnystInt7TZO+eyu15ocS7YmWvk3L06XNI2mm37uhwNhizJGOeOkSNSJwbEdF
 vGpxhLlA
 lSdbpZKhMRxUwODa9IGlToH+sfB4lY1N452DYjqeDfZumIhgv/ajnIwtm0scmZ9GPKwTNk9qkWs4eM2RvkzjYYFqasUphCzDhKtoM+P++qxzibr7HbWz+R3GmBh8ct3MbbChLr9BompuQttiWMmqkkP1CKSVGlH/oELZDOvcFeYi1/5rDNBgAwzQ9tNpz0t8F4q//jsZaE8nGiKWrdLMaWEVh5w37Q1kLA27I8ohYvlzMKSo8Nt1Xorq9/BRdGH0ZfrOzgWTj5JWIEE3ASIRqFpl6YPRI61fFFBbZdS+cXS6k8ZFnG1HEQF6W7k5AQLGLjHhfDNE/LkVrpTqgiQfw0VRLGL4UArFXy5kqzZ0RE4iXxXN0WuoNCu/jGlHEojTzN721gSOa+d0hLJZex+PuFE6TbR4BGU3PbRtFR+wem+Ejl4vKg8bpEhQ1Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 11:08:04AM +0200, Oscar Salvador wrote:
> I found that last sentence misleading, because we do not really
> care about hugetlb cgroup charge/uncharge (besides that being of
> the reasons we end up on error path) but rather the fact that we
> fiddle with subpool->used_hpages and we need to undo that when we
> rollback.

Agreed - reframed in v3.  The commit body now states the bug as
the unwind missing the used_hpages rollback, without pinning it to
the cgroup-charge case, and the subject is narrowed to "fix
max-only subpool accounting on alloc_hugetlb_folio failure".

> Well, that does not quite explain the problem I think, at least
> not clear enough?  [...]

Fair - that explanation got tangled because v2's design itself was
trying to compensate for racing min crossings.  v3 sidesteps it
entirely: the gbl_chg > 0 cleanup is now restricted to
(max_hpages != -1, min_hpages == -1).  In that configuration
hugepage_subpool_put_pages()'s min-restoration branch is dead, so a
direct used_hpages-- under spool->lock is the exact inverse of the
speculative bump - no h->resv_huge_pages++ needed, no rsv_hpages
publication, no racing-put reasoning.

Mounts with min_hpages != -1 are left at v1 behaviour for now.
That quadrant has an inherited race that also exists at
hugetlb_reserve_pages()'s out_put_pages cleanup, so a coordinated
fix belongs in a separate RFC rather than this stable backport.

> I would split the comment in two parts and place them within the
> block they belong, otherwise it sounds confusing.
>
> Subpools, reservations and hugetlb make a very head-spinning
> situation, so let us make our life easier.

Done - one short comment per branch placed inside the relevant
code block in v3.  Hopefully easier to follow now.

v3:
  https://lore.kernel.org/linux-mm/20260428113037.88766-2-enderaoelyther@gmail.com/

Thanks for the review.

--
Zhao Li

