Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D7FAECD9BC
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 03:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36FE6B008A; Thu,  5 Feb 2026 22:15:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABABE6B0092; Thu,  5 Feb 2026 22:15:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6A66B0093; Thu,  5 Feb 2026 22:15:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 889396B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:15:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0AE1D1B2BF2
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:15:21 +0000 (UTC)
X-FDA: 84412566042.26.138ADEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 63A1640011
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:15:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OdmgRg3q;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770347719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhXaQen6a9EVArYZZOaT/FuxRzbwOvXvKdJaf2cR7dI=;
	b=a2rmV/iC305qNXahyz0y7yq7eiBwU97KbIIepBfFZ7lNHLL5GNII0RE6HvddkTGwhFguvR
	0KR+lTcFXrt30MZZCQ60DKHQ8bN407X5BcCqm24nk03MlOgJjhWcBCTY6fNlHqLvRpRsi/
	+JV7VG3Mon9bxgci/KfUc4vMwCK32XY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770347719; a=rsa-sha256;
	cv=none;
	b=C91QSm2E13LzXe/iNOeuFYc7CXjnDGqkfUdZSEvt7pf9+OBUX/AvXH4/Xt147y0ZE2V+Gw
	+HzYO4HwVc2gJIXz50BcdsPlN2t13DzVEAWLf+vmE5SN0FLek5vucjprGmQ1L7I01sNZRk
	i8wTt3vgkpaaOXMO0HlXO1v7qnBbPzQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OdmgRg3q;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50D33429E5;
	Fri,  6 Feb 2026 03:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F98C4CEF7;
	Fri,  6 Feb 2026 03:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770347718;
	bh=uPXDqLDLtK0pqdFOgCp+rr9C19DDhLskCTGooJBdwTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdmgRg3qyn6J8aDsbqLaGp0YTTaluhiZhWbkHR3umhSBbE8aYtGUlHk/e/adSV9hW
	 VkRWFb1ddniw7FTb+jOja5JusVe1kt63cNiVsMwknLtRRCRQ6apiwHp9HbeZivqfzV
	 QHwRU4m05XBFBFW5uCuhh/x1oXdDQ2NMe9sF8BI7ax9S3W7rp944KLlnBccq4blXhZ
	 ecX2zxqDsd403YnagGtHitK2eKdvWjCspHuoe1tSeiTulxdmSgVwhYpkTimAyqlV7u
	 s+RU+pd7A4bcugMnk7Fjfk851NxzpT0KnjHdPWRO451TyVqifObRGPnCkAaxAJKjQo
	 74KzFLtsloFbQ==
From: SeongJae Park <sj@kernel.org>
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	"Jiayuan Chen" <jiayuan.chen@shopee.com>,
	"Johannes Weiner" <hannes@cmpxchg.org>,
	"Michal Hocko" <mhocko@kernel.org>,
	"Roman Gushchin" <roman.gushchin@linux.dev>,
	"Shakeel Butt" <shakeel.butt@linux.dev>,
	"Muchun Song" <muchun.song@linux.dev>,
	"Yosry Ahmed" <yosry.ahmed@linux.dev>,
	"Nhat Pham" <nphamcs@gmail.com>,
	"Chengming Zhou" <chengming.zhou@linux.dev>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Nick Terrell" <terrelln@fb.com>,
	"David Sterba" <dsterba@suse.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible pages
Date: Thu,  5 Feb 2026 19:15:09 -0800
Message-ID: <20260206031509.68313-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <e155ad8af874f10baaed91f1d12fde222b82036b@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 63A1640011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: c7t9uecrs6ohk81ktmox1ut89iafa9zh
X-HE-Tag: 1770347719-634987
X-HE-Meta: U2FsdGVkX189RdYgrmvw4zRzY4aFXA7pcv2B3+aa776ziw06urXmDI/14CtLNF1SJGYeDZBfx1jVAhpJk/X63JjoBjzrk3SNykAWvesLqWmz0CpF8887wyiPSeJzYSvp9AfZ7ihez96hmS33IS3SV+rf2cbSSmoU+0pKqOFyalJk0dtSjG41mhfi9wJuhKzqKNKxotb93I4YQI6IN2+N6GGINSesrXhPP4otiy7/Sso2FMGeU7016z8LbmMRIGfJjP2uTJzzvZE1Z4Hi2FKtHLTB/53h3LXAhcyjyJSrQu5Oo80d7u4wL+cZo2k9hewWrgZMzgDoav/8xIQZER7qZxxtDOIUGl2NGCE44SWR73grq9hb1LTjnEvwKMKh6RuVLRKLVgUHBdYO7BQM1N5BYFBmiwUt/4CDXDHvuN0XBU08puS72mekI4XNhlarmc0c/RnxPlBNvE1Bt5Xx1nZxUjSIrcpFIbMvAqX2vs1tvMfx7tTRsqtl+6QYOCKxBlE672FoifyMHylKIiaP63wz/CRF3UgC1HpqkVSpOzJo8rPDnL/Muqty8PeIOmiEIRwaadEIiquIXJ6HkzI8kTt0VIiCucDpih59qxXwSUTaCMPPPkqUCOpbWHC8YeGY8V1jPd2JYveLIbXeysm5oI5hfgExfbEUy8lNqQbNRJR5gIJYSrp5Hnu2CcRlG5pYe2vqVIaSZpng4mMxbckkJNTbUpOB6MlevCfIE43CNesyMvoqnDw4kMLdkBcv1C15KbZygRWytvZj7ge9ZWNY2FPlMPPbjk4NKWAHMuk1aYadkl0JwgW+UsjNoeNLT4X1Dl7U0Rf38fODyLr2Xog9PjsJpUASMAwRcnvL5RCcMHXmGQ5UDgtX9aarXjoJVQ6WrgcYSde/dfg/ljoj239aL6LjUF9pHqWRqHRgaBhPA+159Nt0UOdGjclIeQKLr7poZc15skvYlpyjCZgd+7Baqsl
 uEo5zpxa
 9utATTHvnWF0KtuTIJGtIyrNjOw85LVWiACnOrpXRHtXzlSImSRZ1UGzgkJv2tgdsPBg1y8cG+s0CBhhp/WAnGAoFsS6/LOxRAl9I+YUm7siKEqjPJXGIvoLlsDdYup2P1HT7fJQfITsi4LQkOeddid1Mt9B7l0d0t9LczzPNU1i0XO6pOepz07vdkoUJOACCpFemwIZH4WTm8JjDfzOQoa8Hscb6v1j8ikHNUlWOzFK1dpf3liftmpuxlBgl1sCcRyZ0yrnybyyyuXk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 06 Feb 2026 02:47:58 +0000 "Jiayuan Chen" <jiayuan.chen@linux.dev> wrote:

> February 6, 2026 at 10:21, "SeongJae Park" <sj@kernel.org mailto:sj@kernel.org?to=%22SeongJae%20Park%22%20%3Csj%40kernel.org%3E > wrote:
> 
> 
> > 
> > On Thu, 5 Feb 2026 13:30:12 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
[...]
> > >  @@ -941,7 +941,7 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
> > >  zs_obj_read_sg_begin(pool->zs_pool, entry->handle, input, entry->length);
> > >  
> > >  /* zswap entries of length PAGE_SIZE are not compressed. */
> > >  - if (entry->length = PAGE_SIZE) {
> > >  + if (zswap_is_raw(entry->length)) {
> > >  WARN_ON_ONCE(input->length != PAGE_SIZE);
> > >  memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
> > >  dlen = PAGE_SIZE;
> > > 
> > Below this part, I show 'dlen = PAGE_SIZE'. Should it also be converted to
> > use the helper function?
> > 
> 
> The dlen variable represents the decompressed (plaintext) size.
> Since we compress individual pages, the decompressed output should
> always be PAGE_SIZE in normal cases.
> 
> This check validates whether decompression produced the expected result, not whether the entry is incompressible.
> 
> Using zswap_is_incomp() here would be semantically incorrect - the helper is meant to check if an
> entry was stored without compression (i.e., compression failed to reduce size), while dlen = PAGE_SIZE
> verifies the output of decompression is valid.

You are right.  Thank you for kindly correcting me.


Thanks,
SJ

