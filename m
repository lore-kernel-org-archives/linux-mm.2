Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B6DBC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924EA6B00C5; Tue,  7 Jul 2026 04:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AE636B00C4; Tue,  7 Jul 2026 04:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA166B00C5; Tue,  7 Jul 2026 04:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BC9B6B00C1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:28:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD0088D656
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:28:48 +0000 (UTC)
X-FDA: 84961304736.26.AE5C18A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 182671C000C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:28:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZPndqliw;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412927;
	b=pzSfoVD5P0BmSxvlcsVjfJ4rJIiGN5clKOcQFu81sfnN3ZIZkJItP9SPmwwEIFW64vXOeq
	5reWOPkMtXoCExouccIEf3oG01ZpVCixRjGZvbF5phu32BqgX1j1Ja0LrbYthjGeV2CkVl
	InS1Arzb9mIykGCCPlb2IaOHilGIRcQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZPndqliw;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zFGbMiPIQbORKlXAvmb1zQCk6r/kZuhJn/PPaYuiAsg=;
	b=0iv01N4ZJD8kL90SL8tb1XxJX2u6/wNZmAYLgeTWx5Ck0GY4z62clSv/XpbGnYaw+tnVf1
	pcZ0kp4+lsdhmLUtBRCSm7kFMoLfQfefWCBUcHZomU3tLk4nI+2cJ4OOocot7ROOjxJqyq
	CWTM+88KpG6qBvtlWebQQkgzjfCoTcM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ACD5A618AE;
	Tue,  7 Jul 2026 08:28:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C821F000E9;
	Tue,  7 Jul 2026 08:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783412926;
	bh=zFGbMiPIQbORKlXAvmb1zQCk6r/kZuhJn/PPaYuiAsg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ZPndqliwgmXu5kmh+bJz4fuHhudb3ocCu8zmLAbMuL9PVvQEPh6SQu/jJ6Qh4/LfM
	 Lpq1L0SIRqwvbTEkVMa8DrKCTtdkpGXD+aLresfXY4/E2iZsSEXH05ccH5lTqF4X1k
	 TwGGeDcxqfRYyaXMfROP55Ai6+4xE5cb9KGQWoxQ2KBIra44VvLd0nSBm+XFJ/u2ho
	 I8tXZJZw1rHSnOj1MDJJEGkoGXTYGxV9+eHldyXUMT5nFDPQwiKO02IzTG7/cSmIWt
	 +OH6P4J/L5rjqLxObllhoMUrqO2KxYegM8rFQC3o+1evYoG+bJCJZxAM1lQxgW/ojr
	 4S85VUgSSvivA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 4/4] kho: Introduce kho_split_preserved_pages()
 helper
From: Mike Rapoport <rppt@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260703020832.1731864-5-praan@google.com>
References: <20260703020832.1731864-1-praan@google.com>
 <20260703020832.1731864-5-praan@google.com>
Date: Tue, 07 Jul 2026 11:28:28 +0300
Message-Id: <178341290877.3292146.993563652569119942.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 182671C000C
X-Stat-Signature: i7pwo1qrjf9ui61ncr8wwara366qxh6f
X-HE-Tag: 1783412926-600922
X-HE-Meta: U2FsdGVkX19EIk/maliyDkGw9EqPAggcbDuh4Twu/innCcz5CDZ4kaYGRStqsDKj1izfmtLYaIg0QWoE9etBroQ/5s39fc4Aw6VZmZjXFS5wF+igR7rxS3KEbKhtj+sAlkWCIe78lAjKcDYY24BeDj/lpM2SZfgMnBmdou6yemjemqOwDKt3dAwe1suSR1CQMjhsq6B4VX7EIFBeK8XVN0t2npX/iZXtoZH4+bNwnb5CSl9B5vKvC6NJVvAsqPQvjHCsM6AhblWdYQAu/H1ka9i5BrP49MBgT+pCariTogi22z5V3SOviB++mYgAG6gsKNG5giiYjhgxdyiJGjkLdjBD1LgZgMAMe/LacZ5gs629lUM9CAxfFK500xUTbsWSrHAvWL88QFEVUvtLXZef5T4s0n7KDRpRnI21pjQjEg0BgMl/nAlsN2feQ5qGNxN3J38iZHeoITmuOtZ8KEH+Fxf//8TyoHyoPhFnHQqy8rKAgsZF8wJ0IRKZqlhqr/zfjKLU5YQHM+IQUK2zy4YaYzQPZmqKFQ3T7ThN9mddSO2uqZ684BtxgpQmNcUSgvCFBLvaH3wB8MCZpZVWdtx/nGFVCa9fNaz8DM/8YU0F3znpIQrCs5j61z8/o18ijqQIz8bTKVXJoMi6XNBn5WGbDzAdwtqDqN/yU2Yo1/wYFsbV47aHfig3DkvlVClDE/sp1PGMGWsOvplIYEublI3xhOlSB2KFcPRggozcE5vgn4PLPurgc8e+PXdjXz3qkwIuJz03ePGJMCCNAgS9BDBMWztkG152hbgIHA1c8r1R88Ixrn6hhmL8XGjV/iR/2Lks+LfksHxEgSLJTnbPPFjetQCJDH2VDBF6ZfZGfNYFmZpv2egQROSUyVofWQstaNdu8RElKccB9y9hExr9GA6KpohUQfmWX3do5zi/wv+nKpGwQZbkUuc0oUBFxbSIyvGFtqKKi1f129q8OclJiAP
 Uxxft1RW
 8vufA0G9dLHt9rUR5UWMr+t54ksSK5x/uncKlP7eXOXlnRK1HEtB04HWaIX86Qw5l04/Tjoz1vQ39atXdtfKBc7syLzX3ef29HtNbKZmKCv4T04I5gbKU3aRJVd0CV/PvkbMC93ztLbs+KThVwVIL6LPaZCn1RkvspJ+dlN1I/KcnHB8HZBIWD5wK8ziSaQYPZCkZOg+oBnEPnQwJmk7WJZj+3WO66uaoe6xxm8tCrnyn/TZSX2YMRjWFVp8AEYkOgh7D3F9c0XJKRecyeY/D8dzqoBl6j5nBF62N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> A driver may need to split a high-order allocation that has already
> been preserved. If the pages are split using split_page() manually,

Why?
Are there particular examples?

> the refcounts would change but KHO won't record the change in the
> preserved page-type, resulting in a metadata mismatch during
> restoration in the new kernel.
> 
> Introduce kho_split_preserved_pages() to handle splitting of preserved
> pages. The helper follows an unpreserve -> split -> re-preserve sequence,
> while ensuring that the KHO radix tree is updated with the correct
> KHO_PAGE_SPLIT type bits.
> 
> The helper returns 0 on success, or a negative error code if the
> re-preservation fails. Callers must ensure the provided order matches
> the original allocation and that the operation is serialized against
> other preservation API calls.

Let's put this on hold until there are actual users.

-- 
Sincerely yours,
Mike.


