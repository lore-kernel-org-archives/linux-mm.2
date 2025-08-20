Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823C3CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 23:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD608E003E; Wed, 20 Aug 2025 19:53:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6DFF8E002F; Wed, 20 Aug 2025 19:53:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83BA8E003E; Wed, 20 Aug 2025 19:53:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5B438E002F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:53:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E4E51A018D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:53:18 +0000 (UTC)
X-FDA: 83798789676.13.37F7505
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 353F520008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:53:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jlWqCAUd;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755733996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hcMZ8t9IBgLGTLqUXyODk/78P2oc2QGoFTKM34aNlho=;
	b=ZY2EKnGkFyzQ2rQhlrNwQSRP2kS4U6PgT3OK5yFv/d9a7QWaPy7f72iCssjH5qoEoVylTl
	8Qra02apkGvJcA05kO75g1ZGQiZ2nhHsCx7DBTsDN1BXITkv9dh3KraHbGRVoUAkXjRAUe
	ZIQlY42W41MY0NDuzmsWzcW063hVPxw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jlWqCAUd;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755733996; a=rsa-sha256;
	cv=none;
	b=YaUbe2rOr2IBsJECNHT259noJIwrEn389Fz/55qmGi7H6zteXmG8CVOEqMyAUIZHoFvxDd
	lDuxfFGXKFGAtZRwG7Ejt8MFB4m0dU6CfOZMRVZJbyvi+m7DOy9Yx8i2ep3SPaBwifavFh
	XDorpgEHgGzE5j09UUoqwrjmfw+MVa4=
Date: Wed, 20 Aug 2025 16:53:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755733993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hcMZ8t9IBgLGTLqUXyODk/78P2oc2QGoFTKM34aNlho=;
	b=jlWqCAUd9IZ3Rl+kmMX8pDSpmgTwgtM23zERkinX2y8Egh7KSodjhRESED1ehHRXXR3pvB
	JOuKhp7JynCFXX1oFbMLVh6b8oGpDqt9Y8AVM/qtziEawyIff+VB3ULBvbpheSFcgsS2g0
	hqQ8wDLE1LsELx5NMndeXK2lnNx4Opw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Boris Burkov <boris@bur.io>
Cc: Klara Modin <klarasmodin@gmail.com>, akpm@linux-foundation.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@fb.com, wqu@suse.com, willy@infradead.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v3 1/4] mm/filemap: add AS_UNCHARGED
Message-ID: <p7uqfmtrl5duh4zekgtf3vtl4jsstbdefar5nramp4aflcn25t@7pmvft4zmsid>
References: <cover.1755562487.git.boris@bur.io>
 <43fed53d45910cd4fa7a71d2e92913e53eb28774.1755562487.git.boris@bur.io>
 <hbdekl37pkdsvdvzgsz5prg5nlmyr67zrkqgucq3gdtepqjilh@ovc6untybhbg>
 <20250820225222.GA4100662@zen.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820225222.GA4100662@zen.localdomain>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 353F520008
X-Rspam-User: 
X-Stat-Signature: 647fsepj8gdt3y44hkpcm3p4us8eaiga
X-Rspamd-Server: rspam09
X-HE-Tag: 1755733995-190288
X-HE-Meta: U2FsdGVkX18QXoUnbTiNf3gU+gaZA84BBcRpiDIRfk6H1krFRo0v78Zvz2EtP5R78Ylwn9fzvDiqtcnjr+5XsDTYQuj+s7WAboVRhbfDE+CiIc1aWRJWX+lCLYmkZj6Ilr/s5CnDoLyQP4LTb0+DKJkE31WvYtdJ+91RFIcMWong9P5FeRMt8LPwnofjZu+ZOAQ9xrhbRvfq+8UOkAX2X2+prBcYumOPIk+vl/fRDpc9lBwR8bwqN2qeSoQIsK/YeA5l7SpAsrzmq3dw9RJfW0ywEshaqrYeehq/fhBHgpot0jMNE+kCxCs7WYqAaqfHQbznzIpGfux5wmDk1IuaaCxCR9laOwnB3ovqxODDzOIcRs6LFE2Gyw+mVYzk7FMmWySgzgbdi+abznGeogmikhDGt+bELtARgELzDmbrrjP7M/TaP+QJjOxHxlX7zOdk0bCGB4WRad4RamCuqE1/wyhY1Oa1a48fnl+9DNL+KOQiLc3CwPS0YPDRUkVwEf6QIj9c+Z22qGtKv+Oc+TKD5YTRpUzKxiysIt1LHJ4hqj58vY25JGmk/tNa4lLxDXgACLKNMTVoChpERBz/hkbFP52O9wKTzSuo0etYn6A43AexNh3zcT6uAPXdbm0kwFdCkfk6u8MsSCEQF/jzAJA7afcSK6FxL0tIkPxKqZJHBA0GHToUp6fsRRRh26KCSH+3Bmo3Fzv10kvi5HvTpoiM8T8eOkTgiSu7StBOvpoMELtjAUrYHZ71Z9HxjHI5uuBhOQ5MIrxnZkbq8r/E6xM7M+QyvH4+G5VB9xXk5ShCwsdQTzmK9pf/H2bkkVQ+KN9gao+1MYmdiqm17mHO81BWXTRolp04mVylo1LOHNeebeE9G1HqiCBl6nDhd2an9ZifWynOal0LW0dU6IUN0n0S81sbG/tf+oG1VIxavJe0OCNcFqf/TPT4tYehMVZgxtDPG47+RyX+dAFzBrUsHI1
 7DYYDBgf
 d8rK9yJf5wPSk0FVAjUNH+12yeQMje3n/DpyBYI1boBE9nXcNCNZ9drzDVh2ocsekpRLsTQSAslG6v55gRVWpeNd4csbBpAw6XI8VzOrQ1TiSxxpgdNiZggj0LZ0I4dGHc0aJbVAXDyUpulP9us4in9BXWd/vnn+PFxQwFHL/uxmHtYIR3vSK+qlCld2An05U9VVICrPea0hvdGGnD0QV2TO4AF/VBebqA9jib1vq1JTVEVE9Vps3KY0HrZ3SH53kwQZG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 03:52:22PM -0700, Boris Burkov wrote:
[...]
> 
> Thanks so much for the report and fix! I fear there might be some other
> paths that try to get memcg from lruvec or folio or whatever without
> checking it. I feel like in this exact case, I would want to go to the
> first sign of trouble and fix it at lruvec_memcg(). But then who knows
> what else we've missed.

lruvec_memcg() is not an issue but folio_memcg() can be. I found
following instances of folio_memcg() which are problematic (on
next-20250819):

mm/memcontrol.c:3246:   css_get_many(&__folio_memcg(folio)->css, new_refs);

include/trace/events/writeback.h:269:           __entry->page_cgroup_ino = cgroup_ino(folio_memcg(folio)->css.cgroup);

mm/workingset.c:244:    struct mem_cgroup *memcg = folio_memcg(folio);

mm/huge_memory.c:4020:  WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg(folio));

> 
> May I ask what you were running to trigger this? My fstests run (clearly
> not exercising enough interesting memory paths) did not hit it.
> 
> This does make me wonder if the superior approach to the original patch
> isn't just to go back to the very first thing Qu did and account these
> to the root cgroup rather than do the whole uncharged thing.

I don't have any strong preference one way or the other.

