Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCC12C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7796B0088; Thu, 27 Aug 2026 21:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67876B008C; Thu, 27 Aug 2026 21:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D656B0092; Thu, 27 Aug 2026 21:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 990196B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:01:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11336C0253
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:01:38 +0000 (UTC)
X-FDA: 85148875476.18.43F4E9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 74BE8180016
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:01:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROLCM3ct;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787878896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzFgSWthSn1we0Ma7fJwP6PBLxyvmi7fGeKff1V6Los=;
	b=nQFHVjcD3onWOody/cc43kPr4NJ2GJgViJmrDZZUuHg3f1aceaTVQSATs0vuNOjmWd21DD
	9h7MmgmTX9T8QokTNRX26Z3qdI/3dKs7vNCe2V1GhoKOPyjNyvBmE07EE7ZHoHT+gotFLb
	010Qtxi80Y7QJRBNZF+EtoPKAmQa7q8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ROLCM3ct;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787878896;
	b=HoLRNIFo7bBvQJsxZCOvWLN5LO4YTgT98LXV/zmJ9njjJUn+jH1qGJRhc9NOpFLBBfdP0d
	mIW6TpHur5TXxrcJCo5yKtKmqRIrD7/zwjuLiIFkwXwqCKaQwKgy+xnR1m12O7x7eu+YCH
	oE68OukIY0zdVKihI9dUU8pXpeLI7NI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA1CD601F6;
	Fri, 28 Aug 2026 01:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3701F000E9;
	Fri, 28 Aug 2026 01:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787878895;
	bh=BzFgSWthSn1we0Ma7fJwP6PBLxyvmi7fGeKff1V6Los=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROLCM3ctzr9S54PvfbDPBmzD8mjjLY72O3eOsMfJsQ/nhZhXPC+9Z4MVVnPG/zDq2
	 tFlleATzjb6DmQSCo5CalpJRxuTFj/pmqifkbROmWyVNRhxeBmpyXBizWuvHotYG1z
	 z35nfa86+GA9GugpezOcM4OottaxMzeuyUEO7wqVcvJcec8pnQGPsDGpkxwJ/FrNZC
	 YvGbP+kEUO8/S4stkjxfjOVahY6TkdxO4R9VL5WhFFjXIGed63FQ3YXsczxzWG46ix
	 UrGTE0FwZEUxLRjNh/qRDl4A58rymUHvbPcGThfwB5yfN6+HyWOKfvPtYuAgH7fvMm
	 afrQDO97oI6qw==
From: SJ Park <sj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] mm/damon/core: remove declaration of kdamond_fn()
Date: Thu, 27 Aug 2026 18:01:27 -0700
Message-ID: <20260828010128.10599-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <72252089-0405-441a-a7dc-0e1deeb2f802@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1hjgy1rz78ezapfigrmoofj3ep9wd7xx
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 74BE8180016
X-Rspam-User: 
X-HE-Tag: 1787878896-766157
X-HE-Meta: U2FsdGVkX1+cWQeSzPDQzuqBc7D/0fejg6t059Z53eRjSva5Vvd9Aqd+moZl5+9CNFz6x/rSGHdH2tqjUXIZQCym1fWNYtJSWUje08W81RwaRqkmWnY071I+P7ShU3KpD2WCLyej8aIq1w+M8Fe1B1oXSobGACFY6+PBJiQTvJidjEtXrrrxUyY7/n3ZZRQkxZRx1s704OquwYUcR8Y2Pqg2G1xJt4F76e7k3kqlAw2IzyUlQy3p28I0pT79pbpYceuMHAPUUS1rpiDWs2ZbF9tbUDiMm+zP3g1KnADcVESDWdHh+8f7H7ujuexSrgtdLrb5ljK0xlFt7MpjpYRccMA9bIMJezUF8lxL7zVPsY/PKWhJM4ZsEl6RmZ3wvwPsqm4ZCizoW+/JqhZV+gHjkavfNoabEsqsMe2x1sj3/dyVKwpWd1UFUxQ41XmGPDiAR4ObJM965q54O7AvGzsGMljqD/sJtaliLdzSb7gTDdBhEfyrdpubOWujXLGJIm2VmfWmQOMcNPD8UP2Aj9oY5InfttTxdTjH59btc5NcNAqig9yr1BWFi5i4cLQFc+pX7nW4aHaZKhFiX7F/yfEzpHIut+2t3E1206pAV/ccW4JNwZMOKfjwoGSq/jCm/mWLmF7JpR+XN4g1m9qzLAL69HzkXNl4n4f8iWTtSvF0F49AqKExFStSswCJnOj0fEp/Gj7LC/6S7D72OH17WHaAdEoW50IOojiB0q8Jl7alrIEHw34+30/YnZEiigFZKMtgXjP2JyEbLWrL5KgGlOGbQ4m+aEQ3hARwE56oNSvFY7oBjayUPydMqZx/cyUrU3AdKt3VD6sJyLLLgmViEVUL2vkQ7RGKdrajmg3eaqaELbaGoO53x1kE3xm8eAwzokIisAFeWj5TwHy7MuHCac2ZXS+MDUadQnrxMRu75dNCcOpO3ZT9zi51jb+GkzcY1k8t59iyrcJkOMX2Jbq+qn+
 Fp8F6/6r
 QpmIN67aeGMxe7VB2ngDWn7/6dCNJ/UPLnFumQFl7ENtrchGIyhYSHzCvzaD/7tP2db2gN75Zq/YsW5S16+sTD0MB9wzKTRKgrwKrweuR+G8Ral9XGME0bW7aaAevnLPxfzuRjzWqPF30jq3OiMlr0wOe4Cp2QENjm+EsI1FR8QxoOP97peXRFQcGI3C1xjCr0cD967t8xQyBK0YHuOO5wLmbRYwDtOGN5ijKdZNRHY2HHtE6cAp8Hn8r8u1uZPvGncbsWdGyyTU7MoHqAmD0eBbJFQKz7unqTsYJFbxpGP+u145m0oUdz3RxRGXXNzjape+dAhIYEOujgWV+bfuku6Lb5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 00:47:08 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> Please ignore this patch.  This is absolutely wrong.  Sorry for the noise..

No worry.  Thank you for the patch though!


Thanks,
SJ

[...]

