Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D09A0FAD3E1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 00:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 077436B0005; Wed, 22 Apr 2026 20:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027A16B008A; Wed, 22 Apr 2026 20:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FCF6B008C; Wed, 22 Apr 2026 20:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D9D396B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 20:32:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CB0E4020B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:32:32 +0000 (UTC)
X-FDA: 84687944544.24.4E1830A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B375814000F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:32:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s5ak8vLb;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776904350; a=rsa-sha256;
	cv=none;
	b=IZ1Ee8V1+LfUUYNrzJEy5ZKjU9xIRBmJDC2AXgxU3KiBFlmVf972zcTTAFEnwm5dBNCfnc
	sDCHu6wiZIAoqN0Zn8mz1sNQkf6Np9mN0s1u1dZy2DHnjnXz5L02UrK43cUmwt2MS41+PM
	G76a7ciLETe6X72GxjueC0FoZ8S/Nso=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s5ak8vLb;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776904350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pReuSQ2TOsTNuyVp0dQwPvCCrn7Thf2LBpWYUhNw4kU=;
	b=a5TRILwkarknG43xAG81IC5XNE/j9SR/FeWfbPvopaoOU4JpMPG8P4WoX+OYneV9744QiQ
	lSMjCOLgYLQZ8GkmindWllLKG4Ce3GJV9SOvYEE7dBUuEK8Ncb775rXqSNv7ah6PzaDpbs
	fRTHK7/Qd/OB7wkwIszOE57fHKwU1cM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD355416C0;
	Thu, 23 Apr 2026 00:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEDFC19425;
	Thu, 23 Apr 2026 00:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776904349;
	bh=BN4M8EG5SSvTFj6ABhC5jhLKeYrnpaiSbsJJkMVx7XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5ak8vLbH8qo7OaYvpdHtHCR/hrCdUbOEAEKeVJmftKIn9wM6pnK4//4FJTqY9bXo
	 Y1oed1v6Ic4ED4PfF0oe245i6NVPVWDnntX5sCp1PzAXEFDE+arcrsJnbSwU1mT9By
	 J78wjmSdKt9kdE3MYGX+DPaWG6+lq1MTuChHZPbXSSPwf2JvCSjBtPcWLdL6rw1Y7A
	 G3gu81wdWws9XDgbP+OBCCynwESostLYjOa+gvy3YSYSi4QkXnjnVstZhiexaKFpFv
	 b45w7wCuR7ML4nKMAjkemz3uWqLL7BEWLt+YJ/tneCScWxWNY9xnHMSRdSUDIyYY7L
	 4OhwxdKQxdnSQ==
From: SeongJae Park <sj@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: Re: [PATCH] MAINTAINERS: fix regex pattern in CORE MM category
Date: Wed, 22 Apr 2026 17:32:26 -0700
Message-ID: <20260423003227.74498-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260422123726.517220-1-pfalcato@suse.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B375814000F
X-Stat-Signature: dhswgkxwydqbaxjex55w1f7gmxprhuxi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776904350-530716
X-HE-Meta: U2FsdGVkX18W9TXwWOR3DG51ucdmoR2qRgXypzLKw+bDVAbUPsEx8XQ298qYes2fHXYegmVZy0srHQmzUAAh1q2ivj/UZInWv9kAqrDHgLkLD+6O3HXv6arEvb7VfzStsLjwedfkP4Mu5ynznnLHVMEYvzabAHkaTmFFHxp9JXPb+d/WFnHEPUgJ2RcqCFWSK1TMg0WB/yc8vVdq5EpdJzYrzF7zL7zlswM9FXy9Po2ndTsaLnR4SfcOMaLm93lD0RNCRQaVW06uB++mqmLblvdk/ahKwDtQn+/9mLnKAwHKvsUpgG4zedoVwlHO4SDgERSdaCkwzGAYF3hz20PMy7hhB23bO8vlkeQZS17rx1BZUW29fF3S/SYsg0AeI5+8EjoLR/vtdrVkickS7wMCajOcTlvFHnG77ORMd/NtahDq2RCk72TgkzWt3RXYrBDlGD2CsLRfql7nWJfQMU197mAssfJT9cslAxuhuXGsRI+dwyDubyGAgVv25EjbyCNwJz9z7hBqrODx4f1U3988xoBSRB2nQDDdBdqDEa/Il4S4aV/8k5Z0QifypjJUIEkXZZS6oycSxsaoRearCgk451Y3BsbapniEltPmmOzfjbvGb7FA89h9vjIj3F45J8b/wEEYniXWKI6IM1Wjq31Evl021JLbXSs9OgsXXJ1BhkqZkDufCYaqCgZ6GVIqtwQHjhelgMyHfz+LJ4VcErH+069mja0Zfq9kDsY6r31gdjteFFuuZ1FVDbnbPLYbmQhqffeBIzT9/vrJCjEVRH+/UwgwsECnfPYt+jq9F2fTnVOyQyJovwDmiOll0+pgeVkK9Pl+GkruFFAMhCatjQu8YmnjaP5T4GSvm5gPOCmnUUZiI2Wo/eQpLSGbxF4TKbvpdLz8bta4skKvpTzfw5Wckfkv1XC5fzxBi1sg0r3xJeoqSfBRtF4cLwBlosEDmmydkeUw1q7unywpRjsXGRm
 VYWisrVS
 QNOuOxL8E5PesH776XumeAHyPA8QAT6DOpIM5aVjD2H9XkX3di4G2kXC4B7ByWxnZtQoOmdhthAOhXaWWLtGVToR7flnGmRfJ4A1QadrLU6Jo1kVMyPBZrq/ArrwiVb+cdqUzY6QaZnb7pYzzSx39ELeYk0JCk2CapDWpcFSoj/E7yhZNNEAgv+jsXS6hwqSGIhc3vwTNXhhXFnowNKkWpfiYrSZO7MKp68fOscb1T6/6NbsTJiRrSG/amktJlBxbQHuB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Apr 2026 13:37:26 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> The pattern "include/linux/page[-_]*" matches every file that starts with
> "page", because it's a regex and not a glob (so it has the meaning of
> include/linux/page + match [-_] 0+ times).
> 
> Fix it up into a more regex-correct expression. Doing so reduces CC's
> drastically in patches that touch pagemap.h (which is maintained as part of
> PAGE CACHE).
> 
> As a side-effect, move linux/pageblock-flags.h explicitly under PAGE
> ALLOCATOR.
> 
> Link: https://lore.kernel.org/linux-mm/20260422005608.342028-1-fmayle@google.com/

Just thinking loud.  I was initially wondering the purpose of this link.  Seems
this was added to show the example of pagemap.h touching patch that can
dmonstrate how many CC can be reduced.  I once thought about suggesting to add
the number or the context on the description, but realize it is too trivial.
So just thinking loud.

$ # Without this patch
$ ./scripts/get_maintainer.pl ./0001-mm-limit-filemap-fault-readahead-to-vma-boundaries.patch | wc -l
13
$ # With this patch
$ ./scripts/get_maintainer.pl ./0001-mm-limit-filemap-fault-readahead-to-vma-boundaries.patch | wc -l
6

> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

