Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D43CCA490
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 03:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2AFC6B008C; Fri, 16 Oct 2026 23:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D021F6B0092; Fri, 16 Oct 2026 23:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3FA56B0095; Fri, 16 Oct 2026 23:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 979436B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 23:00:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DD9CA6BC0
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:00:41 +0000 (UTC)
X-FDA: 85330615482.07.9E77F6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 66862140005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 03:00:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlbgZHKk;
	spf=pass (imf09.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792206039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+r2mVM6exMXaeETVHquTVwr/XL/75xbpWlK6/Fp1U6o=;
	b=NSGyhsqpLyqxBnWLWQg4/Jr2v1MyyKuLBq+9A/HQulEdCWejH2yH6GsN98UTuQ+9YSl6+c
	dQVD1nycWxXo0RDsCWj4C+5bIx0SNuXMAt+oODoVdjsIU0tncHd3gihD77g1CNIIDhkrPs
	CLj/Xf6chVX9MVs+Lphfwj9FRi3vIuo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792206039;
	b=0WF+lXBJcA7iQGcNAcUEYYY6QPAqDN11jO5LNZHg674gdlxJEo8iFonwgV+zuUpmtW46dI
	PHkVDuJ1U/79Bpsi6Uyk0pHv57y9/W48ykoaeoB5PphQuhNGFGK5quGQ0ut43zuBGc0vXu
	I7TK0JqGPI6gOPo7ZBMJoBHDGpD0XTA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KlbgZHKk;
	spf=pass (imf09.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F5AB447E8;
	Sat, 17 Oct 2026 03:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F3B1F000C6;
	Sat, 17 Oct 2026 03:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792206038;
	bh=+r2mVM6exMXaeETVHquTVwr/XL/75xbpWlK6/Fp1U6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KlbgZHKkmbaTJwL+6F/M6ONkkTNMrG25zv2f+y14G34LFvkjzUzCHHjpa6Jk1ntUV
	 bA8zHcOP35QpKjiv1QKbl6GdCpms369F8YzDAOGrcw9dWmmSDNxzXgsN3SyYICyGp3
	 /1/igiAVVgr0JHSTFhnzVfBvXyu3pMxwVBqwUu2VB48tZ5B43oWUKu+xeTY6QJVu3q
	 Lkw9GLAOJvhR4Bp1jDZ/wxULhZa2K5grf3f8KmL/Wub5bSbp/QrKi7498RvHNABMb6
	 oyV9dylAXb5t8XRieL0vs4CYGFhMnrSK8ScLEemm7aALTzXxpln3Q1DA6G20vwPM3z
	 0QHyvlFH+ItFA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	nh-open-source@amazon.com,
	Federico Parola <fparola@amazon.de>
Subject: Re: [PATCH 6.18.y 2/2] kho: free phys_bits bitmaps using free_page() in __kho_abort()
Date: Fri, 16 Oct 2026 23:00:16 -0400
Message-ID: <2026-10-16-1-daily-reply-0011-kho-free-page-2of2-needs-ack-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261015144529.76911-3-fparola@amazon.de>
References: <20261015144529.76911-3-fparola@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s4wmfa6hc1dkts9n9rm6b7hty37as8te
X-Rspam-User: 
X-Rspamd-Queue-Id: 66862140005
X-Rspamd-Server: rspam10
X-HE-Tag: 1792206039-566836
X-HE-Meta: U2FsdGVkX19/bF4vVn4zX4STyfFzwWmtnaCWZQXmOEau4pNOVsPiYwY2KJnV+sMNzCKi47SgHEr4R/VTv6qYFBKKVJLWqVDIYuBc1qdj6Uib7vPfkpepMCo1Cv0PRR8PtNBSxqSn1mlu4JgMX1Oa9BaDbkUPxovmxU7to6uJMfj6d5KrmAc4aV0bqDVreYTm5fFMnHiYGTpDGeBSYTab01RACJYES+7HIHCZrnRQpLmZGH7MfIVd1dWUgPV7/SoEgdelWZ4zzR6CC6PqS5tyNUK7Ys2fr/OTDICLqebJxr/yMaoElxr1kNiLa+mLZgwjZ+wQLHfacugrnUVWOhiL6idCZ92W/RviuouV5t38FmhNqfcJcf3ULUKdbnlthu0tU34roa89HJIAXeAwSwvP9AcmbTD+/0yXoy5nu/BJCuAEDjyTJhNlctqjtQYSjJp8k6cKREHfb6PJqNsFzfKdkfaTecbmEG8OJSp3KOwHr2vWmNqKRkzveist3U/6ErIPjy6Lk909ecIlA9OgYFH14x/ZPciOslqubi/xizdZkIUpa1PbT+tHgiYWw3Ogqigx9xaJYGh3+2/ILNDabJXc69tCY5wtNY4WBfkZvbXWARzb4+qDjGtI/c9net+9LJhDtTBGPhwep1csuyF1/U+x2XSLypMpzLFiHkfcn+Hz3NElfQMYatXNnUP4u4/bDuHZHglEyIdlp+QhlVFozkE6zoUd9ZAklR/qo0bFUFE8Gl8Mw9Lwb02VnkV/jF/gFn/cpTA80IXkw5PNZXq93cW5anfbUGmufC/940qWb+oyFWdkVba86+X/FoVpWCTDvJafa+Qop1BiJF1hc3CVgWcf8tKEwLfQmw2DeQqUbfUKoPg6VsKFbmmFCPrnguuYu/QlEXhjrLa50UMQXxAm8sgXLtJu0AKpY/DBNJplqmfUg0Bp97IBpXwo1n3WfTF6zQxvd7lLLIYCbaSTkkYTgIJ
 RPjoXVxc
 Bs8O02Eh+XhS6DgSjDeG153ZRhKLcCmos3rqem7Wye6R1UfAgsel3SPavx/kxCCquEZ54DO+to7z+x/mhYnW0k4Z+PptbLChnOkuuFruRo9mX8ayOYo86bLOdfwZTeNJ8XNOPUl0asWCnmnuuXtkr0Pfwq9Ng811PxF2fYOXCIfVFWXhGEd5NsxZZdXN/+l0k9II3cnZcJ52MBHi2HbhT+tVlnxX8XhTe27y/DLkL9xnqXz9csmSDEK8NWCp3G96X1aZf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> This is a stable-only patch. Upstream fixed it as a side effect of
> commit 99cd2ffac697 ("kho: don't unpreserve memory during abort"), which
> removes the tracking teardown from __kho_abort() altogether. That change

Patch 1/2 is queued for 6.18. I'm holding this one until we have an Acked-by
or Reviewed-by from a KHO maintainer (Pratyush, Mike or Pasha). It is a
stable-only fix with no upstream equivalent, so I'd like one of you to look at
it first.

-- 
Thanks,
Sasha

