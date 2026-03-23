Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE854F46122
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38E216B008C; Mon, 23 Mar 2026 10:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318106B0092; Mon, 23 Mar 2026 10:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206B86B0093; Mon, 23 Mar 2026 10:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC3C6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:10:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA51F8CE8D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:10:46 +0000 (UTC)
X-FDA: 84577513692.17.10B3B74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E4D6240014
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:10:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KXNW41KL;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774275045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEQ5NGg1fo7PB7w2vO0Wl5c7KDOqKgo+fn0xkYeHn7Q=;
	b=r66gvA6VpKSgNdrOZolam7SoqbyV3YAqSVcASlbrJNjJAOIKL4eK1bAa1XwyepOf26+iI3
	ToKPQ4g2q6UaSa8uXGRL1x2oySCLkGGdm25hXEblqkNob/MWxcHxoCa7cnpej6VqfDkBit
	r6n6n/6ntKxoyW4YNiSXVhSSS63hQ6M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KXNW41KL;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774275045; a=rsa-sha256;
	cv=none;
	b=VAnAZkstsVxyqq26/JBRstWCmgUHxWSxGA5Xf0E4rRFzD+dWZ+LMSzd4f5J22bnXZQqXrQ
	SkEoo68FD7iBjPQMZ0IuWmMaS8DP/D7UU8LvEYYS1UqI3eTD6o7G/AoImae1hrrHjS6P/Y
	qeHZpdMrgBQw1XwhPimysCrv3XjlWwI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFCCE40976;
	Mon, 23 Mar 2026 14:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F8DC4CEF7;
	Mon, 23 Mar 2026 14:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774275043;
	bh=TuTrUVWqHjE6YuwxBi0DHWoX6gX3ScTAzVK+DmaN/Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXNW41KLzQ1yC6X9sBVothBySUpd3PSXV4JllhANSOalEfcpiwo6d5L0T8AZr7dEs
	 TrjheJfwildl4CcMFu95Dxp0GqYTZ13gp6N2ZVDI3gKLfI9E5k+mRnp7LfI9xV+B5p
	 F/mFAF80BasobGaeOMy1/9b4HtfluEtl0rqk39aBo5jzS09pu+yLS1ayQOBeXt/gv4
	 rylHAXIPR9aqK38aeizkcBCVzai9NpqSfrDVP+jbkYEFw8S3xPMEfjA631WONK0gch
	 7T6/mLPfYzI28GJAexJA4kEdCwj6lE2Uwnre3ov2sLvxjIkLZ2agG4pZgjb+SH21AV
	 pFFl8SDa5I8+Q==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
Date: Mon, 23 Mar 2026 07:10:36 -0700
Message-ID: <20260323141037.80243-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322214325.260007-3-objecting@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E4D6240014
X-Stat-Signature: ig3xejw46rbbaisbgr1py1sis479zirw
X-Rspam-User: 
X-HE-Tag: 1774275044-467629
X-HE-Meta: U2FsdGVkX19ZSWiCjUDSHq8hCHfAM1uMz2pqoLGPqdkKQ3U9W0OItIDerxy40M62aQ9tAxhEIhWqXyyencKnt2LtITUMDYgt9L9l+8Zh6a+tVDBNepzKkCIPMJ1Q8IciCcXm5LNAIwRy7pWUPgGygOpXKXH89nUy7tcMg9fLIYyETx3a+imIL5Oq0Hn2FjGPrOUEot/C4KTbIew4ysTMV0N2hUNbnEWhDlzUWRpemVpFoNL74Om/hDJ+tZeOdBjxY0127cveq/BcBDKMK9hEVhsu/0jwUGfDYmIdWil5K+aAwedaCNZq+2ZN4FMe2L9yhgcZyfS/xLsQIFJejr/6VsI/GAtNP6bJgBCtMPFlgtluNQSRN5rmrVIp6ok87zvSPLTz36PZ9gUSNTnrrZG91QU+tViJjfxEboPOXaBYM3uWwMD466khL+Tw9XGK9XK41Sn+023eeXsv2loqrM+bDBiqZLLL61S3AZgCS/m9CpEW2kNw9oj6Vn6g45sF+ElK/ONXKKxp3vsiqySkdeFzw7Sn/vE5eJaj18T5k7PjX4bS0Ou9yPEGYK6LLDsjq2zEMw+SNP1c30hK9UOwavc2KcyfouvkBnPILuReK+GA/jfJ8TZjv/0gVMVgINHOo9cYeDjymI2RbbPPFg1aVBds6TtwEjakq0OqzMYnzRo5WVpipvwMs/hK1USYBEd4E1xhi4YeAbznmAAyHWQKkfEokhCI/x+c4zAptrLWz/RZbOEcsRUKgZXJnwEHDnKu31xs2W4ZUidFPSootENMvF+61jTH0CvYOqFgDcMHRMTW4vZQKjVzuzlj7CWk64MOnaAbqTORdLk0QB6Xk9J9a2FwR5qLGyiXQtQOB6j714cwS4Uh6lFszqDzIvt4Sg+o91OH+qb29Dv4KZBXSJVmmHDl3eMb6VOutp7ovlNdqPKqdpDGpf+Vz+RG57h23hGcfM0ntJodCezNWFaJoS9Hb4r
 z7UkSKMD
 sT/qhkLNIhP++ADMHOTaZULS2pK0/HVxUw/M6ELBvph6KmDA3aPFLCdXZ8qAeKEOgNZUIFq40t1OiE/x9J5mIQVrhNKv223GU8mHMgKbHYSnha4z9X2RD9G1T4Zkt7LkAJb5jiIVpW9G3ldCvZZtwgEN+SF6CuHfQTT5WwDxQhXDbWP+QaptvolbTs1VU1TgXSGOh8FMID0ufCJWGvAVSS80rb60YCMupMcl6VlKUYTX86r8kaQzS7z+qbl65orYD0eoohdsJc+CLsp4/5npn8AaAteQoye2m27Qn4kPK0JicVQJ9wyD4iGRDyZiP62zyT/inPgxnq4Vrc1ht/kb7rcFzcIiNqgfhRWY4wVgEUb6YicU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 21:43:25 +0000 Josh Law <objecting@objecting.org> wrote:

> Hardware integer division is slow. The function damon_max_nr_accesses(),
> which is called very frequently (e.g., once per region per sample
> interval inside damon_update_region_access_rate), performs an integer
> division: attrs->aggr_interval / attrs->sample_interval.
> 
> However, the struct damon_attrs already caches this exact ratio in the
> internal field aggr_samples (since earlier commits). We can eliminate
> the hardware division in the hot path by simply returning aggr_samples.
> 
> This significantly reduces the CPU cycle overhead of updating the access
> rates for thousands of regions.
> 
> Signed-off-by: Josh Law <objecting@objecting.org>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

