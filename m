Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A5EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 11:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382956B009D; Fri, 10 Jul 2026 07:01:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30C8C6B009E; Fri, 10 Jul 2026 07:01:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FAAE6B009F; Fri, 10 Jul 2026 07:01:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFE2A6B009D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:01:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66BA11A0401
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:01:32 +0000 (UTC)
X-FDA: 84972576024.10.8286956
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id A0FF31C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:01:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mZFaJN/r";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783681290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1in0J6DOoNo1KJyS0K46lG1NFXjsivGf2Yh7PbnBzU=;
	b=pAtF+ED0iMpKKWiS0qRqx2EQCn1mYFXk8f630Oqn3d/v8MoOEmMQ4z0Y/UmGYDsGQnl9mp
	VAX0dLaswq3d/4ht4tiX6J8kHAVN9sMbxJZS/EfqSxetE7Z+uF5iTw/TrC8fEGiRNmK0Lk
	pCNzAgZ8HpcP66TjVtnN5AlQv/alPUg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mZFaJN/r";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783681290;
	b=EFrf/arERSlxkP5PLdRaadczOVsK59fbN9XNIKR2DvYrsqKMSmPH3YYAwKNU83kH++uOI8
	t2tl+XCs4ZQXD/yWWjCmxo8kbBcETF5AJLsxD8Hq1E9t+lBkw8J82ss9m3RZnruvwD2a/O
	RQq5qyk7W+eu2aItTmu9F+Vz2z+YHRA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A338E42E7E;
	Fri, 10 Jul 2026 11:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5DC1F000E9;
	Fri, 10 Jul 2026 11:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783681289;
	bh=u1in0J6DOoNo1KJyS0K46lG1NFXjsivGf2Yh7PbnBzU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=mZFaJN/r2g8hweCNJ2/oa/yfwnFv5zbDApI8iMUpY+NUxNgiW/bsaO+kK+YQCW64z
	 PpaaHmSBJ3KX5fbgKV62ghk8ai+laPAHO70xaUO9vms4nDSieDvezlv/hcXvxFmtUX
	 Sb3mTwo8TGJ5qHoLpl6FwU+z8MBa07nPhprfiLUlUJp2c5+MwNCXkagCTBRcW/f2gE
	 qlbr9w7E/3nozUmz9Sq7E+/LnEUwKkvUZe8hrojnknH2jSFniKsuckcmkaLtWVIpXo
	 Bt6ScxK2RJiqXcPTJgjrwKzYWKNc3ve/vCBgit3SW+5V26w6V6c6AEJC0Jow8CE1hU
	 5Xw6vWJIEvOiA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] selftests/mm: remove obsolete hugetlb vmemmap test
From: Lorenzo Stoakes <ljs@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, muchun.song@linux.dev
In-Reply-To: <20260710092427.3459121-1-songmuchun@bytedance.com>
References: <20260710092427.3459121-1-songmuchun@bytedance.com>
Date: Fri, 10 Jul 2026 12:01:09 +0100
Message-Id: <178368126920.320109.18235623374053703699.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1342; i=ljs@kernel.org;
 h=from:subject:message-id; bh=8xi/0lhPSxQTlfJQ4w5thzHX9bGE+TZ3W7tHjzlAHxw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICLvz6eM1gm4Vs6ZQVSXu3S3BeDt95g01jl8z0J7Fnb
 x+U+3dRoqOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATubqG4Z/yr3V6yZrhaxQe
 KjvWhlz7efTn7OXXHH7GGakYnlMSPHSS4X/MBOO9t837V7KnFp64Lvf82uET7nzZkdw3uu3O3mp
 lb2UCAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A0FF31C0003
X-Stat-Signature: 5zrhdfmccn7pj6jw36n7zg54niu4karf
X-Rspam-User: 
X-HE-Tag: 1783681290-533054
X-HE-Meta: U2FsdGVkX1+glrtwdU8m9J4U+TSR8fsejN+ag3muhwpqyl1ug88DqqsSBwq3csulx1cyu9ugMu07RDFLaC88g5NXO+E5MgPY9AHzP7Sl0lqW1q33fmnhVs/vKtg1FlYJsJpxPHYvFaZFMqONaH7ZnDn+JHipMhwHY2vVdjQz2mrd39W8yyFokuXQPHFwDN5leb59S1Va757nqc0ENhJ6VKOxV/gGhUXrKbgdYqaxXs01gftWX1c82b9IJ137i8vQnLfMVI21IGe8Y1GQMFqk3EctnPT7W1Ctj3lY/+ElJgyViKd2Af5khAAr7Gwu5kEwgLvJUeyWYktiPJEWkYfj3MYUP3rT7XUbFf+jxMmGQ98bN1pPYhfi5cHQoRkhW83r7UclJ1Y9YgsNYaHmfUjG+WOtFJMx73McCZPxLTuOXEUotwnWq3KNdYjUnshTImqWJmBVgETW4HGAx2rr6QoeitO28ceATuNfBCQqVCn1vXZoSdNnln3530pb/4rlU+hsLt2xHj+zJfFK5ImJzR+6IkFvK7UxnO9M0r8f0bZus6fFhPBKr6OnR3dUb+/fl+eHdZfuUZPGkrPZiZ+bPNNS+DQs1IE5nm99n5p23qAWZozGopZeA6ZlHgQilo6litAFIepvJrj4q6tGFKSuGDtGMxZvr6pZTKmLmc+84JXAjMNFwC/iGhRflpG0Hmo/ozXkZ/x5yYZnCPt8erdd3NGpj46LnUWVoPg4Hn689FioupfD2Bq7HWUBPqoDZIgRFaxeiAx96piBwLqTMn7m71bZzcOioi3vbCbwafAZHvrBrpF0W66GGhYlLPNxBBgnjbuCvvRxM4KuMDqC7dtWPn42CMgYGiVQys43byqQPEtwjZYX+8VL4teuGpH9rXQBr3SWE5O0sOgMzIQ3KvZUuzyLmF5Bv/Um3LZ+8CJ+tUnSXfUJHM/bn4VUzn54zcWxSSUwnXJEGEK2HWwd4YGxXUr
 wJCR9Kw1
 qXcNyGWmCXlubXiBKEMQAYDxKOnQ32xRdNEEhSlOiHQhiHljDHb4kEeSUXDGOmhRAOszuOy2x/EwcdDQ1LMCm9u8bxe2qYpIOftTlV6iGnXp6fgRMZNTNgcxDYpsawhnvr3j7XMEXOGuLITiSN/mCoMip/U96oBW8tJfSVByuSg0Socb3ymxudNjYrHfzrnTOYjTHmHdzwQ+tfxY3C8zW4W8HfSr3TL4tWn21u4pO1Vh0PC+nv2mXfWqkqCxhPcMoR2zsoIkwmot6QFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 17:24:27 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> The hugetlb vmemmap selftest was added to check the old HVO
> layout where tail vmemmap pages reused the head page.  That
> assumption no longer matches the current HVO mapping layout.
> 
> HVO now keeps a private backing page for the head vmemmap page
> and remaps redundant tail vmemmap pages to a shared read-only
> backing page.  The old page flag check is therefore testing an
> obsolete implementation detail rather than the current ABI or
> behavior.
> 
> Remove the stale test and its build, run, and ignore entries.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

LGTM, always happy to see red in the diffstat! And we definitely do not want a
test testing something that isn't real (...!).

>
>
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
> index 9ccd9e1447e6..227476d8ff1f 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -3,11 +3,9 @@ cow
>  hugepage-mmap
>  hugepage-mremap
>  hugepage-shm
> -hugepage-vmemmap
>  hugetlb-mmap
>  hugetlb-mremap
>  hugetlb-shm
> -hugetlb-vmemmap

It was here twice :) wow.

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

-- 
Lorenzo Stoakes <ljs@kernel.org>

