Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5DB6CD5BAB
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 19:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB2A6B0092; Sun, 24 May 2026 15:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5825B6B0095; Sun, 24 May 2026 15:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449F36B0096; Sun, 24 May 2026 15:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6356B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 15:30:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D126E1C239D
	for <linux-mm@kvack.org>; Sun, 24 May 2026 19:30:08 +0000 (UTC)
X-FDA: 84803304096.11.EF93074
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id CA465C0002
	for <linux-mm@kvack.org>; Sun, 24 May 2026 19:30:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WkjBIf8X;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779651006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2O5KlEC2t9M0+jfHVWIzaoKqlzPNLTk1amblrHW2ig0=;
	b=fwIKWjtc4NeXMRmEiJrCDMIj24kfKHwjdpGq6wHi08duPsAU97EA3+ymkTbkI3nZMeAuRF
	euuIQgGDRvKB59fm5CWorMgy8BHHwGEhu16UXluqMz1kH43otKlzsfsJQlDo7/vNjZAQ0p
	lu1DnylquuvTEch5pHpi4Xy5xbZfkHc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WkjBIf8X;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779651006; a=rsa-sha256;
	cv=none;
	b=rwfBy40szUdAeGkcIBT88lpJAMtqZwtgYDWXqO7nHO+q5WBEZwZXH6BEBmiUihdYf//rY5
	4v33Qeq4yOMONPWvz4ebCUHkEBkue4fvFFcCTsJpvMNgO+Y0P+EL3nEK8RFmYNQZsdS6pZ
	nfuk+JoD4WY6wskVYkQEPejc7lNm/H0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779651006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2O5KlEC2t9M0+jfHVWIzaoKqlzPNLTk1amblrHW2ig0=;
	b=WkjBIf8XqFgqU5jnstVeKzv9qiia5+lePekU8GooO8G6yjbKVLd3Yw0ChBEWKmLsLVUvEd
	b5OiwsWJ2C9KRrHPKY/TqDfuGH+TCpGrn269XzZ8OvtUEdt2bOzk81ppgxmgkCIfqNEMDh
	vDLkhovaV3uDQ+2tz1mchy/ABLjvH6w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-AmgiIsc3NVyhP51YaBpajA-1; Sun,
 24 May 2026 15:30:00 -0400
X-MC-Unique: AmgiIsc3NVyhP51YaBpajA-1
X-Mimecast-MFC-AGG-ID: AmgiIsc3NVyhP51YaBpajA_1779650998
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F6A61800343;
	Sun, 24 May 2026 19:29:57 +0000 (UTC)
Received: from fedora (unknown [10.44.48.14])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 42E77300019F;
	Sun, 24 May 2026 19:29:51 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 24 May 2026 21:29:57 +0200 (CEST)
Date: Sun, 24 May 2026 21:29:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
Cc: Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] mm/mempolicy: kernel_migrate_pages: fix race between
 security checks and suid exec
Message-ID: <ahNRrgSaDa3Tbws0@redhat.com>
References: <ahMt6xyUNnacZU8-@redhat.com>
MIME-Version: 1.0
In-Reply-To: <ahMt6xyUNnacZU8-@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 4nAXvIHrnYNIQtnU-8tIax3Q3vmgt3j7iraIXiYvDcg_1779650998
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: b8oya9wxmebqp4bcoiqs94x5xrjd7mtw
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CA465C0002
X-Rspam-User: 
X-HE-Tag: 1779651006-433669
X-HE-Meta: U2FsdGVkX18j/+0gGOECXwrwQvrPGFgp4gOkRj1jshtz+dtY3bjanwOSIItVDkL5hngMay+ysCn8ksegKjG/LHd/NMXkJjPq1B+Z+Kq+M5g2Qzprx5K7Zi0CNyyMz1nk1JTa+6p/52qU5fgYTMvvcfnfPyGakvZqakZqF3AFSZ3reVB8r5UDrVSrOvxB0wvUI6mH6FLItQ8TBA5g68B0Lxiid1peyWHGyM6BSEaCQFcguF4pqHyU5rP9baYv68IWKN8Uf9YYo9yx6eFl5Sxh+ZJ3r521jV+OC2casQyxSvu30MPGvPpsbYYUqhDbWlCe22CTMJxWS+Sw/ZAp9tQKQQ7QLZvelXpRZafy77JpUb80S7fN8Tqrhx/+sR0Wku6Jr496DOaRBBFoipC9H/PFPtbQ6+4vYROO5gtlGYeDPcicObWSaCzYCdskvzMxEnppzFnEMZIUzgFs1+8rsmNlcZEBtkFkNH9mIU/uTRTHBakydjJkOa0TdQMFE853GsBcDY4tH1M/q1PAURyHHTsPDLhK1SKgGz/JIZLANvQQeEOgiUGennh6ZuvHTr03ELwAi/4+NEGjeB3jYvKyYQHHsv/FWIhybQCPGMblVX6NTrexOCYAgQts0Ut1HPV65v2SvKxANm8WuibYup39IxZNl/MSJEB0ywkvoOlj5ueGaFKeNrN1Vzx5uqARSbfsUqG3T6Fp/N4JOABkNpnCa/1hOss785ikxTmidIK9Yg8ejSdaNS4IJ2q1A+a2TXPvauJcgA36OCHrlStoxhDJQT/+3PU/3eyCrWxjHmNvpdXiLrpwe1zFkPNmG7kE0ulrtSH24vGh5Q3HsE/d4gpmq/Sl2yO4QW5rvQ46OE5lbZSC02+5TuVGvirCeSfHq/v8XVUFPwfA96Diqmr1nPgHdm9X/G9FBFa4b+0D0GlanOJWXbi/ya6/2XqImJYyOtxuHrYyJOD2lP6fyxkx+abwDDZ
 95smcw87
 0eOF7K15dFtKUjq09Synas11hcynBsr8MrmkMoV81yGygf8+54VEM+DN+jPvp+guD8InP9pAB+8EGWNKQIb4CAXne+fs9UiESpHNtjjdbqwmOpSw/04LswmyctS8ridheaFvGI8DXNl48Snb00FmgQzObhj4DqMN5W5QeKKW5EIWT5DaCyXK1C0VZznAFc+6Qm9pK2ve+9Keuz0xrulPPnsx8wyRYrYCbQ/jawKBaGjUO+SC7EbsF1ht0yULdx/LDgVzzpXK9CTvyl7EmOqMVPl8qBHu2ksx6nLGkuoh6/QXkcAnYfKX7SRbyxYQ0QDwFNSTerkMXLF8swSg+84vKW+9+LWimS1Ib5DxcTEQe/1CyRi9lpoEEwW4BXmF7JM7huQXBCfSiK1wRwmZ5+Uq49Qis7fjp6ZtAYEMW3cw6iljhSX6AlxWaLatgJMge6V0+tJoR/a8LKrnYPTudkaGe4kUUpcOc48VYTHpIpNmehxUQUGsRR1PLvIEpm6x7XfTQjR7axmokLmooiHuVL0FrW+Y+dGrDbJX6Vi4Ce7D1xq+bbrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/24, Oleg Nesterov wrote:
>
> Hopefully sashiko.dev will take a look too ;)

See https://sashiko.dev/#/patchset/ahMt6xyUNnacZU8-%40redhat.com
Thanks Sashiko, let me reply.

As for reply to 3/4:

	I honestly think this is not a problem... but a) I will think
	again, and b) I rely on review from mm experts anyway.

	The main motivation for this patch is that we can create a common
	helper for find_mm_struct() and kernel_migrate_pages(), but it is
	not strictly necessary.

As for reply to 4/4:

	Yes! And I have already mentioned this in 0/4 and in the previous
	discussions.

	Plus (say) proc_coredump_filter_write() which relies on the open-time
	checks and don't use ptrace_may_access() at all. This looks wrong.

	But this need other changes/discussions, so I think we can ignore this
	comment.

Oleg.


