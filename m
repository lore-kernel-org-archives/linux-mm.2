Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18AABFD0651
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 14:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30E776B0089; Wed, 11 Mar 2026 10:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D3A96B008A; Wed, 11 Mar 2026 10:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF1B6B008C; Wed, 11 Mar 2026 10:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EEC3A6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:18:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8105B139CB9
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:18:05 +0000 (UTC)
X-FDA: 84533986530.09.EEE13C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id B70784000B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:18:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aJcweLKm;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773238683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AC2U3mmRonwdJEe9Za0niCObP4jB8XCHVibzx8Qg188=;
	b=pugLHdAY9B1PXubLotBNal90AcuPBiKpoRo0DxJO5TbSR/R7Oy4GR+r3UCZvhlrzlh/OA1
	Qqbas48tEK5Kw25uqZvwocu2kpdckSevOqF003Fn0q5q29fgx/K2Qh8zZda8gMQFmLUqZ1
	J0illtp1OxqMlxRyUsj5VhwYfY9Qdmo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aJcweLKm;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773238683; a=rsa-sha256;
	cv=none;
	b=jPCqnY6KoQ4ESU8Chu/ezr9KpDeVrNuXztWF1lgAdBxviW7A47gJqLBT+sB2+5/LUWnhqs
	DnbWhHypkwJqlGbvejFZ6w/nP3AzGAb1GLcq0hB5Eai0sP7CvWnwEtkL+GyBms6/Ho60PM
	Dg4SCA5CZvmpyXQ0wIW9OjWEuNNjib8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C0438400FB;
	Wed, 11 Mar 2026 14:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C25EC4CEF7;
	Wed, 11 Mar 2026 14:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773238682;
	bh=thMAcRBBlSWiPQMxkurkltMdIsa+zjOuygZaQbtIy1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJcweLKm9pp8NQp9VuqHN9g8KhPIAgSKYkkfrCK91Dse76Jy5LNRsMJfgggHjy0WJ
	 n+GgtNlQX1XEejWmDfSv4eh5QAFpi4qDOdZgkNn01QVPdoFDAc1K9wx5kBji1fRo1d
	 zDe10WErzLLJjshSAEyqrIcJVt57pk7/pHxMJk0JnJ+69U44Uw7Q1oSM6fPCb/dlUo
	 /Og7UF/JioKTYZ3ynhkxgylF0e631eLBsIeWimgQytJWU5CGOEcvuCLC2Mt1ETLSoF
	 kN9hZihzKQlvGBFKRqJiSs6zCWZPbBx8I2mTPKzPr5PhV3hrIqOQUci0OCL3YBhHrd
	 qV0POmeC7KNxA==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] mm/damon: Support for synchrounous huge pages collapse
Date: Wed, 11 Mar 2026 07:17:53 -0700
Message-ID: <20260311141753.96543-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <0c3068da-4dcb-4bc7-a762-2f529cb5abc2@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B70784000B
X-Stat-Signature: io7faqnmm3mea5sdiigzkgj6wz17stax
X-Rspam-User: 
X-HE-Tag: 1773238683-415981
X-HE-Meta: U2FsdGVkX1/11p+GluvgrOuhGRnpR3QTNDGisDRpSUc4pe7cVsD7S3u3Llmp4qsdzK+YdI+RNijbNUYYMTnGyGRGd/QE/Wf0kQQby+ezUTWDdPGoarUOH8pIUQWDCVgyWX68uFeI4ayDWW+vx9wPY9Djq1mmNq2HCL2cwyFhgbINw8le7YBJWzj2bD+sexGD0FolZNnL86JhOcw7E4bBF1VTSGU1mnthSZvAuw0+jERwp0ez6FNqxfne7emtRoQYNMG78BK0vD5DrwXV0f/Gm4rNHeIr4TlLBIHDF0WehExFIumf3fGaWeMh+AYfltpytE+M0XDGJVyeEzWgYtdWRIbBzPu9K2jkHaLm52aWEXEmNMEGwju06/q1jthDWn6nQcnuan1k6oIMDb6cBamDiLsEO/hXWsW6tj8QzDJs+PJ/CHJFRpqouCLaNCMVfG1edhA3q01gKYqn6NlirKAOL0R5/k8Gh1NEyV/t12y4wqiuBYCqhtjAFgPFZSo1jHdyYS4cqjE3V2p1k6VWSsS8Kl7QeVOnAJ9KG5wWVd8DgtgRvd1/gaFznNSLXi7ceDETFvlGixhn1Hc/06mpCxNOfO7DoN4gW4fTNdzaNi8PsA25gmC35IMPkomxWuxMuTcZiyUcDnBML3ZDqzradlmIzh5oHMFzp1VOm5xZQofc5o8AZPIWhBNoou+BZdpdIouPSaHx2QtZ/nNZWdNqwMymGogkawxSkHymErGNNgpVeVMC52GI7YSzjzjnW4m0mMCBJVRqTq7yoGtufZG+J/HFDrN96XJw866O0aX/9Az2blvAmfp9rS9KNFFSk7+OiJ9+La6VLK06S5DihI3RrH9dTvtgIdPlNdRXi9Wtb74bU/Zwsrzebep0tAc53zHFnWUwHIAmMZOolcKkCgRkGfox5l6KO7R1GqMmygXH0L8Apswmdyu7aKTxKmCBY5EYy74Zdgvog18UgLDPNwOX80d
 5X16oaRD
 A8Vui4ThhrZrURtwdCv8XUMOYh7G2RPY92aWW8ty37ILvUU36cTW8JnIM1yPp/CkaXo6BzqZD0rgaQlBbqy47n1e9RMLxOUyN6TFYbj6xjGAezanrAfIReJ61lgdQpmkAL2Rp4bOBieR3G3tLj5h0c9hrKAifHWMp3j00SwZMHzTEpn3zHdE3lmy7NklvegldHGnyyUgDTMLuqaz+DmOPqsBrhlh2JMTgA2fDgsnOmh7Xnxf/ah8Ocxtz2EbdanF5tD2TP0yF6uBcFu94Ns0ifaeKqJZbcnIESHQaWVo1oRDc3X5ui4GvKlpnHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 16:11:12 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 3/11/2026 4:02 AM, SeongJae Park wrote:
> > On Tue, 10 Mar 2026 16:24:18 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> > 
> > Please add more descriptions of the change, including the motivation.
> > 
> > I assume the motivation is similar to MADV_COLLAPSE that aims to make
> > synchronous and therefore faster huge page collapsing impacts copared to
> > MADV_HUGEPAGE?  It would be nice to make it clear here.  Also, if my assumption
> > is not wrong, adding a test results showing the benefit of DAMOS_COLLAPSE over
> > DAMOS_HUGEPAGE here would be nice.
> 
> You are right. I will make it more clear in the cover letter for the next
> version.

Sounds good.  But please add a brief commit message in addition to the subject
here, too.  Some people complains blank commit message looks odd.


Thanks,
SJ

[...]

