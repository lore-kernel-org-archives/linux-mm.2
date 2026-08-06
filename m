Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C98C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9CB6B0096; Thu,  6 Aug 2026 09:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7B186B0098; Thu,  6 Aug 2026 09:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D44366B0099; Thu,  6 Aug 2026 09:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B305D6B0096
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:45:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 534BAA257D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:45:06 +0000 (UTC)
X-FDA: 85070965812.16.59F68C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A73EA100006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:45:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPfFCCBO;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786023904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7plmgpUxJvwksEh8FUJ/sRkic2TYWNvyMqFTY9YhqyE=;
	b=2gYD8ArR+0yzAJ9eiOdwq1NSXe4jw53t1rwDPJ9F8hPUrQPurn+b7mLcIyYxado3fphhLb
	GC9ZbDkX0JfsMC+z+pEWoyxJ+tilVjStG6JrmnHd38Wx7RTe/Dmi6RNekhFLqX+oA5Cd/I
	Rqp9tN7jXCRPFmDPrI+n7TYZwI9VOIM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786023904;
	b=RhOY1XDfsAKDPtqcSzpLTu2Wz692JceElR2s4x6KRq5xHYv7XXH6b94NUx63eU/cWHiMSS
	v1j5bmRDFS0UwZ7bWdK7pK/vwAmkk/wPIebui13H5ESLncD4mVv8eYSekcbCNQ4XaA+F7b
	15FHdRxsFctbSPjP/wr+zmwyDIih+HE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPfFCCBO;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C13E540B09;
	Thu,  6 Aug 2026 13:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C6C1F000E9;
	Thu,  6 Aug 2026 13:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786023903;
	bh=7plmgpUxJvwksEh8FUJ/sRkic2TYWNvyMqFTY9YhqyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPfFCCBOQrCyjuhtIU81C7x3UyxX/24ttDZ7zGx377z73lyiTsCPdcPhzZRXrt43j
	 vDKGnS31T+/GRX7W8F7gcTkVZG5udXjJ8fXTunnp9EX9mT2pm3FGwUjvlU/23A8S3h
	 W1cwQpa3CKcPL83SbV8IiJkOWtSMkoUSO/AnMJkYSdK/4bS6Wx5vPsCT4U+eFK75lc
	 wBsTEdpKWZGW5SdTk7nCkbIM5utUfSZIMKNH8+0+a180Y7KxNmy3TPoUGM4Nk8GZYT
	 qJyITddIu5c+c13RFS/EfptQcHNMgEl56OStwNZPTVajvjR+/JtUVCf8n/uxc6iMil
	 DPKNH45PQPZ9g==
From: SJ Park <sj@kernel.org>
To: Bharata B Rao <bharata@amd.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com,
	gourry@gourry.net,
	mgorman@techsingularity.net,
	mingo@redhat.com,
	peterz@infradead.org,
	raghavendra.kt@amd.com,
	riel@surriel.com,
	rientjes@google.com,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	dave@stgolabs.net,
	nifan.cxl@gmail.com,
	xuezhengchu@huawei.com,
	yiannis@zptcorp.com,
	david@kernel.org,
	byungchul@sk.com,
	kinseyho@google.com,
	joshua.hahnjy@gmail.com,
	yuanchu@google.com,
	balbirs@nvidia.com,
	alok.rathore@samsung.com,
	shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Date: Thu,  6 Aug 2026 06:44:53 -0700
Message-ID: <20260806134454.96428-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <d2a84790-16a0-488c-854a-e135feb2f65c@amd.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A73EA100006
X-Stat-Signature: dq31t5896amqnb9ofuq6ibrawbtyduip
X-HE-Tag: 1786023904-404671
X-HE-Meta: U2FsdGVkX1+yYt0T1WDXytlmO3wXA78hJaXlGCuD0JwpOfizOBhoLU0/AC0NpPkeCNaqDDYbfAgznTQrAZ7U3pVO9JAwkZKojgW+vxpnZEhetWUqd0szp5PKsEkbuIp3Yo219wj51NIbunCrg46WXO91Wq84haXe07X90X+eWJro44Zd0iJZSoo5IwU3dbxid00g7+q+8lTba9r5l7TkbeZHyOK3PzLgBPuNEWNHZsjitHsBaZR2rrggx0Fypo/80xU6RCpSeCKhLRxfoesIJ1YnEDzqblXxHc64b4QaeXyv4VfEkhUPS5kuZP+0ueXobQCkPUg5hikrvDaV67buQfvExxkYWRkygBleN3odZwDDHJ7PKoTBJ+KMfYmrJbJ0XZgRf7K7LNtzF5vYrF701w2cq+DdPn9/5iz1/5CGHrmyGAOd5LV48AKqW596UmuwHWmbGzsktprfzPkEw3FRCTOAEXtfmh8sWPJeCcE0fa+jDQZXBKeQ9ew8RMjw9CrqPuzZa5C8njNqKfdUxHeRWcAMhAzmcovTaMYq2b+fG+D8ADoH+sz+/POifRdj+qTqkAuxkgkXz1Av/qF5Hh6DHTX5AJCOSHMQgEkCovpNGL9PIT3OcxOyUq5KEYT4OpOs0qmlJBag/Ghs3TogiHsbQdOWscxug6wlKwLRNUSIAkAcodkWzwUacg7Lyvv2vzrm9FwLCN8MmGjN51mBPGC91wqkv6VB0TIkAE6QAUKFTvr1z7xg3HwY3+4QFAE/C8cD6dZSwytOGyXw1yXhCrXVkKmVlyEaaYA8QA6GZmZwP8EE2xMhUyW1h/vZJ91Y+P/SngSbFP0Ul0h3JWA1U+ZoX/vtZ1j8A+52gmib4GqEpiYxPiT6EhAnOTLg037fQjab6/8kRLQ+ICtk9I7AI3ylxFGphSg9tsGvbU5ONiopZ5Fz11Aqr7ghVCMTtnREtBO+HQsVyvV8hA+KSzY6qQk
 6rWYtvIW
 C4MCOP5G4zc5vJgF21ZAhhCPCRrbxvfqcXpbe/IcucjE7sDlsDZrXMjM5vKGhIsYps0eHRkdFotExyr9tbjupcfiRK2Me9Ttpbu0Z1Embohr4GX+4Ti3K4uAjx2VdzjpcTaYmHF9aRZrrrsSkH7m7D8r/1axqTp3Gf7byrcv/qm9fQ7SJHhZ/rEKD0bxQ74bdrLY2t9EH7lm2yMS824QdE86Af/9Zt8ZGl47YKZ9rXtL2MXvd7a7KNRIKWBNfvytLhiRXQh5SuMX28kDzKdRxXde4a1/RD5wABj9BYu8XEOCRPER9EyczhCjgFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 6 Aug 2026 11:19:22 +0530 Bharata B Rao <bharata@amd.com> wrote:

> On 28-Jul-26 11:44 PM, Andrew Morton wrote:
> > On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:
> > 
> >> This patchset introduces pghot, a subsystem for hot page tracking and
> >> promotion.
> > 
> > Can DAMON be used to do this sort of thing adequately?
> 
> Hi SJ,
> 
> I started comparing hot page detection and promotion aspects of DAMON
> and pghot through benchmark runs. Here is the first set of results from
> pointer chase workload.
> 
> Since I wasn't very familiar with DAMON tunables and settings, I let the
> AI to chose some default followed by other combinations. The test harness
> is developed and run by AI. Request you to go through this and let me know
> you feedback about the combinations and configurations tried here. Based on
> that I can adapt the settings for the future runs.

This sounds like you asked AI to do the comparison because you don't know
DAMON.  And you still don't know DAMON, so you cannot really explain the
results.  So asking me to review what your AI did and guide your AI.  Sigh.

Correct me if I'm wrong.  If I'm not wrong, no, I'm not an AI slop reviewer.  I
will not review that until this is clarified.  I call it AI slop regardless of
the output when it is something that generated and shared without full
understanding from the human user.

If you want me to review something, please send me what you really understand.
To compare/discuss DAMON, please learn it first.  Spend time and ask question.
I will be more than happy to help that.


Thanks,
SJ

[...]

