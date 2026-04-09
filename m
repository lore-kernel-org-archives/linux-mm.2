Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 071BAF31E22
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:10:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF0B6B0005; Thu,  9 Apr 2026 10:10:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A00A6B0089; Thu,  9 Apr 2026 10:10:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38EF46B008A; Thu,  9 Apr 2026 10:10:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 272546B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:10:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C85A41A0833
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:10:57 +0000 (UTC)
X-FDA: 84639203754.20.F801992
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id DFED2140009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:10:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W8DPL9xk;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775743856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DKBJ+IO8Lwrv7Ar+fdmkyOV0YR2H4q+x5+ZupyiskY=;
	b=oJnvKz3lhIYVurwfxm/LtZCnWHio0ueY+hHcaOT4bB/nzSeQDWZ4eWu0uQ5THrkcoyOqES
	je3ow7cgbjT8KfregVIHaJSV8KtxHon6DVaNG83wpvSJdaBkiHYI39Wml92XhU2fYa6FgF
	maO7e1iPZy5NASqRAS68i9NmCTJSe/I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W8DPL9xk;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775743856; a=rsa-sha256;
	cv=none;
	b=IcP9cL+gZZGR4MTXEWhdVNI3D5anchBQ0Td+hTeqYlq/xgirrQqmaY9DgJN/Ep4Xv8WfLL
	VrmMc71GHkQUaHRtmiNtUjAyvrSG2RGeb6T81VXCQIMpVZnqEiyx9BFd0wvkoZbeAK0BWG
	Lg+Gcl9wY8uv3GbefRHjEj/YWR6pQ44=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8c70b5594f4so86584685a.1
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 07:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1775743855; x=1776348655; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2DKBJ+IO8Lwrv7Ar+fdmkyOV0YR2H4q+x5+ZupyiskY=;
        b=W8DPL9xkxCb1fdn8hCoEpUreCQHwLbQfLwyo6ED5JRJgi7OW7abkknIxfOjkqg9DCq
         3CZs1YFXXlKhweWCnl0Wd/nO2kDPojKQo2Kuz8E6UeLWcPSjYSKuJxxsDAevxd6DcP0P
         dDsWJ6CnsIiQQv3i176dDul2EDfpn+Z4IcIxMQmESUPB+Q0m+NaMinzeegryx4vfSnk0
         +2sf9tVjRanixRLjJcmNCEVghW5HyXDz4i7L+YGqTB84FY+785eZA4kQxan8qlD/DHVJ
         JPrkicf10iLQ+wwOvhOsHx/t7o8d2GL1WRXf0KDixlO3r3sMpVculXrDXJp/8nCSBy6E
         Eyyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775743855; x=1776348655;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2DKBJ+IO8Lwrv7Ar+fdmkyOV0YR2H4q+x5+ZupyiskY=;
        b=jQXuL3hiO/8Si+wsE0qagKjrXRo4mkLS9aeKi9t+7booCvgwH1bXpssLdbT6gxB2FJ
         tM2e6+eGQPih3/xQcuO+zAZVaqVcWjmSP6aImwr2ckF0vbLU/HzHmn1rIZkKLiO9RiAp
         loeb/lajz4+XM1WCsLKN2h413aTDQ+ChDOIeGc9s0MXTU1/TwmQ5jCybea3zuLq7j4Ph
         P9xjstkK//J/+ADLj+F3xiFw42SOXAKa1z1uXX3BAmMyAVPyBmRYiXg5YGF/44nY3QgS
         DDeYnsyTsB37nkpRs+WHLXiQ443pU68y43mxQQYjz+YWyNjYw+gaA6QC8b6xNv7bGEHa
         mwCA==
X-Forwarded-Encrypted: i=1; AJvYcCWViOYlJo+GhNOFrn9t9PUIebs1scbPFmTzOqnJdYs0ONt7OIUGwZ+OtY20eeL60BJPcUTGo4s+wA==@kvack.org
X-Gm-Message-State: AOJu0Yx/sHkAvew4T22l12omn9uggRRyxo4ASoxAzobgt9wcjRzJWWyZ
	+gw/u93dQ6cGZ3O5pIxe0qawTa22C+7u1vnjVVpuWLDTASa6c0/9P7ORAv2ZmZEabPk=
X-Gm-Gg: AeBDievw322At/YsYIS7+21l2nadJSHPQ2lh89s5KHNjnPlM1vBQgUZDpoHHcdwxvFf
	PGvrsMliWZSCC72cLQkeGU6YkOKSgVdnYcJF2wxFMYeQ38CKdxiScJjJw8ZhdWVded8u+9cbZ1p
	XkVS68yszKsGLFbMio8ozbMm10iU0DlCFqS7i/odc+ej0Ulnx6sSy6zxB2OOeW7kxd8MnUP/z6I
	AHAuMAypRL1xoo7t/4gF/fZH8e986a32wBa+nY+GBKGxA706ISkTAOT/4QmCx5ItB/BvopD2RE2
	ef3d5TUB18QQ9ZLtsI4hLYAiTuddqzEpvIai1JsC6saIc/83qWEMyuhiMdrw+ggo8VMskYn4/vZ
	YSjcxgT/l+w2TY4Z0L6JGDPMCUPRq/1hR96CjqZ3CJ09VzkV/f5Nv94uMZRskrTcOdqkJsysBdO
	7KLlctAbF0/6UlonNKfN8Yj5xCxFdtyHKWRMkZmaF5T1ac3qvanACsCJXAMtjYm87j9Wu/lYgUR
	NWHi7p7jvfA
X-Received: by 2002:a05:620a:4892:b0:8d1:b71e:10a0 with SMTP id af79cd13be357-8dc440c9f39mr456066185a.5.1775743854719;
        Thu, 09 Apr 2026 07:10:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8db0d85a237sm391985285a.5.2026.04.09.07.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 07:10:54 -0700 (PDT)
Date: Thu, 9 Apr 2026 10:10:52 -0400
From: Gregory Price <gourry@gourry.net>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
	Donet Tom <donettom@linux.ibm.com>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] memory tiering: Do not allow promotion if
 NUMA_BALANCING_MEMORY_TIERING is disabled
Message-ID: <adezbGO3qQMbMEP8@gourry-fedora-PF4VCD3F>
References: <20260323094849.3903-1-donettom@linux.ibm.com>
 <87wlyqt52m.fsf@DESKTOP-5N7EMDA>
 <c571bb69-82f2-4346-9f99-6a7258e28a27@linux.ibm.com>
 <87o6k1ubg4.fsf@DESKTOP-5N7EMDA>
 <bd78aaa2-888e-4c27-964b-09f085161224@linux.ibm.com>
 <877bqgvs4k.fsf@DESKTOP-5N7EMDA>
 <se94lry7.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <se94lry7.ritesh.list@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: DFED2140009
X-Stat-Signature: f3zd8e4x7p55xncam9j837ai3nqyaatc
X-Rspamd-Server: rspam06
X-HE-Tag: 1775743855-226658
X-HE-Meta: U2FsdGVkX1/ZiIT/t0y9Tfx/32n2E6fQa44S0um9uB8uJYhskTE6lcwdqHTBAQ+lnuyI+nGRI5U3XA7uctURLtpqL3OCOzXxdmtlPUgyObNhzzQyKEzEwrkMgGlejJOZEWXhiIjQS47dn8n/1C+EHXHGkvgXvoLTp8RZkwE1a2q9aGsJiYV+GxukrzvoO8/psChMZcKBgvaoWm88dTfsiaxOxEu0ew6UmqkfU6DYKaN2cpBf+pAwXujHIr/bsErNkZxm0K8gtGbuh3w7jaSl/naoThhVNRBT/yqP2TRPDo+axamyLcd3b1Vi1d9zZfTmPc7R4LBlrYsHMzIxU6krG4EzUVkOGk4BwM/XOnnqcyWxvwpFWan7JccvzuSMqiw8tbEU1KNIm+CWlzK6DtOB26M42atGSCXNZdFiSlu9vo5A7uMf7xojTiXdSZtMEnWOhrEy2QSdIt9cHASsE17ByqPCrTcW1WyskJ6ArtD9edfNxoO08UgNu5P8y1bswnK9WkOf8VJIZyuoZCeqaY8mOtu75vp8W24JPqrVh3ga5MMQ39uzriW2YbDYrCf5Yf/TRMNdv9FJBe8OxlMJqVGXmEzw+JRAAF3a2Ar01DBy65MMWFxCkk6rx1V/xZeUgNWssdjkXO2Y7hz1iNwTd1SMQ1MGyQsoRAwciMj2gecCM5EfAIgc6Ka2aeRa23C4vHHWTC5TSglFtU93uDS6SpNoX0ult7r0Q64Dd0yBHv5KJzEo+1236Lu8o+tCqce5zQa8GlGyWHfTLyBinqgkIFHuZSL9tLYxpDU2aGZBv3RpDvBqfTAaj6qDnKTTHNq5aWsr8eZqWusN8eau5/kYtUO6tUMdVyy1Xh12kJB84exyTyX9lXfE068PaCVfRNmSnCAXk1PzMF9vaJzyBGOuuc6LPpHFsEUCVYA/QsZ1vLRn+aCkTQGqfGa/u8YMThbZuKcPpvyjP/kWjekLd14EHSf
 STv4zOhK
 e8eeUmrWTjY0mwLX3f3+XAZHtva+nG4MKKqPi8cFozLJJkSIBYkB0x7aYPhw1Z1lmt/uZtKuD3Vn3bxsHBVe+8Y4geeo9zGBN1TUFeVg2sfSfg+kiICj7p7ziYbf4RYUcXuXfH2zwlQEqXx7Z6/iIQmQqI+qha2mELs84g5WHVz/+AKNQSFFaZROrR7MOiirjFHRG4dhchimF8roAWFGlPb8/rIQvHp0e83rbRCj9mVHGezDPyqI9GYo4N/OyUux28c8E0B/vcZPwA8cYf7GC4UEbYD0w1KHp+6j0n3di8gUyeEPI3NblnA8veZlIGLC5xpK05nTyAlVQoX9IGETi22Sty8oB3X047ZEHOxBBvNx2TwukuUQ1nOpaKuzQxRDf0nJxArpB1HVvBgp3CZf+c7rmaMmi8QOQfNcW35Md/Amdhce2sqsdAwa3HH1KqJh743YFQjGqlVVi0rr2lzbikTBTzGFnwSMQeayWSbIfdB2fFbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 09:12:56AM +0530, Ritesh Harjani wrote:
> "Huang, Ying" <ying.huang@linux.alibaba.com> writes:
> 
> >>>>> Donet Tom <donettom@linux.ibm.com> writes:
> >>
> >>
> >> Thanks for the clarification. I was running some experiments where I
> >> only required migration, not promotion. However, I observed that
> >> promotion was still occurring even when NUMA_BALANCING_MEMORY_TIERING
> >> was disabled, which led me to believe it might be a bug, so I reported
> >> it.
> >>
> >> As I understand it, enabling both NUMA_BALANCING_MEMORY_TIERING and
> >> NUMA_BALANCING_NORMAL results in both promotion and migration. Given
> >> this, do you see any concerns with modifying the behavior of
> >> NUMA_BALANCING_NORMAL?
> >>
> >> With this patch, we would have better control over enabling and
> >> disabling promotion independently. I would appreciate your thoughts on
> >> this.
> >
> > IIUC, we change the existing user visible behavior only with strong
> > enough practical reason.
> 
> So what I understood from this discussion so far is, we don't have any
> mechanism to do auto-numa base page migration between DRAM -to- DRAM w/o
> triggering promotions too from a lower tiers to higher tiers.
> 
> ... This to me sounds more like a broken interface.
> 

It only seems that way because the naming suggests tiering did not exist
prior to _TIERING - instead _NORMAL just operates in a suboptimal manner
when multiple tiers exist.

_NORMAL migrates a page when it detects the node it's on is not the
local node of the task doing the work.

_TIERING takes into account the liveliness of the pages with a
timestamp.

Going to agree with Ying here - this change should be dropped without
additional data.  If you can show _NORMAL would be better off not moving
low-tier pages for at least a handful of common benchmarks, or that
_NORMAL is causes incorrect placement - then I think this change is
warranted.

But as it is, this would just be a behavioral change without supporting
data to justify it.

~Gregory

