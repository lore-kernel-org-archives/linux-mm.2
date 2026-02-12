Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56CC1EDF04C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44386B008A; Thu, 12 Feb 2026 01:27:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25A06B0092; Thu, 12 Feb 2026 01:27:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927FB6B0095; Thu, 12 Feb 2026 01:27:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 826186B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:27:57 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20B2016016F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:27:57 +0000 (UTC)
X-FDA: 84434824194.15.8A07A73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A0F2620009
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:27:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTrL55GO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770877675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmkYDQ1+FjwnUkPwE613ZkkEVVb/Oxq+6EDKoRetKt0=;
	b=MJUBUlTLo1BZXSQhAahGcTi8j6wMbDFJjyNUOyxXhiRVY7fEo1Zjjz7xb9VTN9vdS29jWA
	n5XHZVGQw2n5Np2CXGRPgS8ktt2V2I5io7C6DL+xZfue1RHW4rKqTqvX7/WAg1bh/BxrzR
	BkOxwpvL34rjI4beg9p8ezy2L8r2sQ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770877675; a=rsa-sha256;
	cv=none;
	b=xbh7n7AEsTBMGYH7+ibV9xSsbZ8TqJQlOB3GpztTuXwZhi4Xp3P9Zj9d9P5Ktu9j8Uj942
	YXzU7duNXbBjENZyChbqBd8OSYUduAEeVH+cimPceJg4Ix/c0SltBSixfWdmG/UXJ+hx7P
	y3BzYZu1uyLn5Axt7hcAwxeomJZjXlA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTrL55GO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA02C43503;
	Thu, 12 Feb 2026 06:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7D1C4CEF7;
	Thu, 12 Feb 2026 06:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770877674;
	bh=xRTSeaOTTgMyO66UkzQ4P/Can2kfHXf/45m+O2x5X48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTrL55GOA6WSIMk2LGZGpq/envakKOJR8mq6Jzjt0WuoU3AZQTCa3ORPRNdhsn248
	 0ad8cHGlfx/I//RAd7PemtOcW/kffXjKkGbrGgmgIANhWMfvE06q9/69s2xU6AXi6R
	 xxcKW1/GRQ37wsabZkLpbBCNk8mmOCVpnGuWvvIAgjvqpxVVm8l5RB6S/uZZ5wzQYx
	 nV2zlQ5T5GNGFKDMvTJBBN81UFAmKsxQE9JHGVTFvN6exgAhvbxwYlLyAdPWqsleQf
	 rSRo3Q9OFX5Y8s5pXxzInZYyip1fBaoFxhP7UELoSdUaiGeWuUSh2P5+yXTpxlpEOc
	 fDeyilgDKIhgQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	Honggyu Kim <honggyu.kim@sk.com>,
	Yunjeong Mun <yunjeong.mun@sk.com>
Subject: Re: [RFC PATCH 0/5] mm/damon: Add node_sys_bp quota goal metric for PA-based migration control
Date: Wed, 11 Feb 2026 22:27:49 -0800
Message-ID: <20260212062750.70451-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128012539.72119-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A0F2620009
X-Stat-Signature: uthrmimrfy6cca49dm71qhjtghzzymeg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770877675-179658
X-HE-Meta: U2FsdGVkX1/Im7ZxeRD7wkMAALfhoHqkDK4J1MmzZfL0k49CNE8UID0+2AbCUG4Jlgchh7SIcYm8nNx0kX9vS52XST18NsL7YlwPYpviHrzaOSfZYcvYpyrWDZXZjM2oNWHEmktVqGXUejKt42NrRGZrW4e/kxVMjmCsBCwBYFqNLbv4n1EFFWAVqdliMXCE1OAu7B1zNCHUsy0UhjX0THhWbbWNOEpKZ2gL8z6MQcWPCOmgi/m+434SIAH1E6lqfYLrTsO86GBHtIp0VsOdeBp9Z/4JxTcT1O61knVvHkoKHJOCY27DqavwcV58HjU4keOYwjxhmS/rjO/ELiebR4LbfFi6VchPZuB1ozmPazM/x68dmYw3MkHVPmUS0Z3YjeTN30WUYtcOY2ZfQ2G1eRC7KaafRPJUWlRZuDVjNqOa1qrjUNveN+Fdspc+DgjPVGarlbTfi6XTM1VWMLqbk3xZnQfN3EEGNGqnjTWwp4H/4Dc4jrMVo4SE/V7/Gr4f2ftbYZhrMtKB0RWuZRWwI/2s3BOhQGB2xM2RvxBxYlNg0FiM9re4l7LSRmReB3pT00Z4sGoQVOezqhlraAbEvEQcQoTk5OLn1zeWh+z+40XI0t5ynWZQvNkEhcrOqjxDoqBW9Gz5rQjR9C0eck5N0kPAP0H4AE1RWLPrqO9aOxwstF15ywjT+SZX1Fs4t0L6NDnz3b75i+JSQ6m8YsOcYEdyQurCSICVBUeYTRrIBrB9hR17HSuJ5CEQ4aT+S4+DWRk/GXniyEMaIeoIBY68TDLuE8wl3WBuaWHftB/W4bSlsLjQ+ArScicshkG9Yu1Vjz/JlOuwQ9jMaizTsVsVfBFK5sB78Sf9Y2emdH/QN2YMNrAla9VCJbLdFX+OcnU/cyLdwHYNjKEwmu/VIYq7RWu1fp/G3OalieaMZUANgsHjWiU9idyCpRCLUQyY6KMT0kxS6afir2WBRK161HC
 rdOkv9jx
 UnDg1rhO36PXtmMIhAB0XE9WfXus+qMi+61Lxfu1ti2qTPd0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 27 Jan 2026 17:25:37 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 27 Jan 2026 10:52:53 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> 
[...]
> > An immediate-stop feature could still be useful for the broader community.
> 
> Thank you for the feedback.  I will take more time on thinking about how to
> implement this.

I just posted an RFC patch series for this:
https://lore.kernel.org/20260212062314.69961-1-sj@kernel.org


Thanks,
SJ

[...]

