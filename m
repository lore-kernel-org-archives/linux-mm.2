Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15C2910F6FBF
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C2D6B0005; Wed,  1 Apr 2026 11:31:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C9F6B008C; Wed,  1 Apr 2026 11:31:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3948F6B0092; Wed,  1 Apr 2026 11:31:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 267E46B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:31:51 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B41328B682
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:31:50 +0000 (UTC)
X-FDA: 84610377180.14.8E9DD9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D027514000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:31:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I+La/TOm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775057508; a=rsa-sha256;
	cv=none;
	b=BXjjK9SZkyLD5JT7F7jamT4Ph7pVJHQrvpf9JH3OjjVowXdPRpPn3ZctutIy6WtNtuRgd5
	/WtD2STZo2C5OVGqeyBwd2WO/y5l9U36jK37azUFN4Gx9VYy4mz5QbqaYvVRwLne5Qw2bW
	jw2hpPW2WNCDGyD3iEM49dLo/U+olaM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I+La/TOm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775057508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0qBMogEgvda4rUX53arUcObwx1Bbd+00FOXvzZzOdo=;
	b=S52P7iid71u6DC95Lqlru0e6EQmrZSoOvfGAlRsRzWlss7m3qhvnWFsR9URqzySEyfUf16
	fzAnPdFpJnGdVdbFt0z2ry+g/AUgJkU0qS3qpvdgwjGn9hPMexrPUEgYVxjELdVLwbf6HX
	Xwzx8ebMJHUb8OxuJ32epzf6DSjXhLk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4509360120;
	Wed,  1 Apr 2026 15:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA898C4CEF7;
	Wed,  1 Apr 2026 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775057508;
	bh=o+X/UpULPauJmbUmMn0NcofFdnbXOdBoW6xeYvzSfH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+La/TOm1FMdV52EzdorO7pP6ryywcpltXbYeDY9anbRQsc4hqJ2CXu/U+2WM8MQY
	 m4ADwOI6nBGC7QAmHrjxSDerhTLVHqzJAk6wfIQ72LqDpYHWIKk8oEIpGvu9u7xtPi
	 j36l5DWhFRBTqMsB6toA2NxWD55eiQUZ4nZJg6lXAtOByj1PhK6HZmJ3BgVwYF239H
	 YeZxspMQK/t35pzkRZG1zRVZsgRHgJsJY4QqRoSCXDgSX3PZn+CXoWi05WADwOC25p
	 x3B2rh5WWvtiirPrzo5mcnLwb5PPmf+eUFuC79lDWXOyyUGiDo0zb/EWqgNU4YEgKa
	 wRr7BmCGx6evA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate min_region_size to be power of 2
Date: Wed,  1 Apr 2026 08:31:46 -0700
Message-ID: <20260401153146.67711-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401084045.15473-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D027514000A
X-Stat-Signature: 34barxgqxfxz4trp6tmd1rc8sxjebhss
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775057508-87497
X-HE-Meta: U2FsdGVkX1+xjewKXob8nTdiatYpLewQKh3TWncOvAdAPVPUAZXKkcrU7tUZXLDiK3Ba8oO3kRtlAsYfsk/z1QHi6yV/voOxtfeRAO3mmjhJpEaVjc+UZFrg3X99YVIYpKbLiMReib5evLCIbRoygXuKqEj1SrZtKs9ytBBYqDufBuYkoOvarawcPAbqKcdR8G0OAELVkTne22dMQz7UZEjA+guQ5qW+qHggkIpRBRDBB6v6qvN5HTCrCmG4MEzDAC5Jb/Eiv66G9admbZ63Ze9xXQaXyNwRx+5/d1v8xqxT/uk0ow1wev6XccXRMdjk8WpJ5DPc79RtGmiD0Ywom71t5smkvkKEbisbXqcmIbocYBQo8GJzMUfOyWfeSiouDzpFrjxTuhpdIbhGBMkT0kY8flg10IPy1Yj027CNVVKz4jzkPwd/hNvIUEnEduS6UQxgYXZz8KwooMpH84DZ/hIps2VdDWJLFn62LWQhFByfWvXAMF14mjcMVMGiupPS4OpWE5QHn1Nyhg1mGxxUH0M2YNVqzK+MjWGRR2F2n4xIIlFKzurDoFqqeyirYNentw1ZSknHWkZsxACCDQyHMdY80HmKW+ECzTFPRZcyMfjNs5yw5UaXFB63uaeHi5WXLxdqWd7MkOuhjQLYm0i78E9JHOLFAHB7N3UOQ5AwXvugbgThBtfnqmaf+NCpB6rdvU2c8lua/Go7913C0DD6wG3T3e2G2Wzis7LeV4INPdeyQOH6NHaNQKbskCUDHrX5ye4GxKuv6b2nbw3v2OHk/UvKAkWeRVl+XQ3DhZ/mIp89y8wPxYX1hhj6XJR89KD2Cc3nSAg1qLxWgFpaZlcLMkK0KNA0bqXwiFobSK6M+QtEfzON+Pgsqt+Oz7nlC6nm+hu2Sv3+6o7RrC70c5MoAuz0lqk1D0TPjaDETNA2O337ciI+pjP1KttbXI6NNXpIr/JK3bKBsyLPdqt4Qxx
 sHcqvLP0
 GcI999AC8jBqg/Bmn5t+uLGqwPNIyNSoW604gEOWZhsACEeCSVqX4CEgdEBkxaATqP4c9OLIjMV3CCGTvxBX99hrCOtoh6q9KjAn1kOpBjCV3CYpPkhFSXImrFy31A6iXtnqLgvl2eS/F7Pbth6YtbZrJtdz9ceUQ0CoXxD9h3fuMyvLygsTkVknHca8krBM6qgJrAC//QhPei2nhC3Px1pBpc5E62+ZOVzfBM536wXR1HSQisQhorvsc0jxSPG+2tpkDACGHC/v2e0qVp0tMPkIFuBHfAGJVNi3n/uWHXgLR5qI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 16:40:45 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Tue, 31 Mar 2026 18:01:56 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Tue, 31 Mar 2026 15:32:31 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > >
> > > [...]
> > Seems sashiko found an issue, and you are preparing the next revision, right?
> > Assuming so, I will skip code review of this version.
> 
> Yes, I'm preparing the next revision.
> 
> > > 
> > > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> > > ---
> > 
> > Weren't there previous versions of this patch?  Could you please add changelog
> > here, from the next version?
> 
> Thank you for reminding me. I will add a changelog at the comment area,
> and add this to the commit messages.
> 
>     This patch is a follow-up to the discussion in [1], where we agreed
>     that the validation should be done on min_region_sz rather than
>     addr_unit.
> 
>     [1] https://lore.kernel.org/20260330233343.4083-1-sj@kernel.org

Sounds good.  I appreciate your continued grateful contributions to DAMON,
Liew.


Thanks,
SJ

[...]

