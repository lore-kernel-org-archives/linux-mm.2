Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE7D4CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 08:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C43D96B008A; Fri,  9 Oct 2026 04:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4AC6B008C; Fri,  9 Oct 2026 04:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0A7B6B0092; Fri,  9 Oct 2026 04:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA066B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:18:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BA611A02AE
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:18:25 +0000 (UTC)
X-FDA: 85302385770.23.2BDEAF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 654BC40008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:18:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qh2aiK8f;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791533903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHhA7f6V65XQBZlA+M5P12SyKfroOAmYrTWgXRy7NBM=;
	b=oGVLWi/17HBZSuPQNczlIV5zD+zcR3fqEWtAzAJ9N7c7SNZCtt0EehHUAIg0LwvPjZSrg7
	ySS4OmmUMWX9S3jY/7g1Nnp5WJL/0uKMnzmEvsMtIQMemGBICCNbIYqe4JORgX9nThYCjy
	Hs5fLU99R0Ko2lHjJMgJwtjvSGYjDKA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791533903;
	b=hBj11yTD3i3TQsF0DsJvO3cSjGQtwPGwNW95TpQ5b4njCJF7YSNa5YLzJZipXw9NiZAs4o
	BSG6NKfsBZFe0amh9A9bcoWhNekV7bjy25sRj3uC+XqTXp/muqaNw+Hl3aU28aPi437vT7
	4ySk/AyzFPUZp/zjHVClFcgecC+NoAQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qh2aiK8f;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 91409436E7;
	Fri,  9 Oct 2026 08:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AFF1F000FF;
	Fri,  9 Oct 2026 08:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791533902;
	bh=QHhA7f6V65XQBZlA+M5P12SyKfroOAmYrTWgXRy7NBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qh2aiK8feprPn0+LiLNLX+i4kAHkS5xWpbXECCGTLaCQubPIBLGNCSEZ8GTYqlR7z
	 6RxLRLtNYj2IZN5XSK5+ydKgKnx64u+6OoX9zNsiTIXarxVBFBjulBkrEEGh3sUDQh
	 pSOwEbXQTGeOxMwqWxRIhUMI+cF3OLRdNI2W+zAGnEgkWAMN/R7Ad/uVhaAfAyvHbC
	 jKv3La3n39rIrTxv3eEN6013Zdk+Zg7TokL1rf52VXCOnU7qT/qFjtu3Duueppr/AW
	 0CFxzepM1S7vloIDvueeVgOhcQFI328iRnKa3/6zBIz1n1TOr5WtGK38RNniyWySgG
	 ybl07iXhcYWxQ==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: fix typo and grammar
Date: Fri,  9 Oct 2026 01:18:16 -0700
Message-ID: <20261009081816.41705-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261008162010.4010682-2-manuelebnerli@mailbox.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 654BC40008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 81udc455t5a9qahs8sbw4ufws8tx6zrm
X-HE-Tag: 1791533903-478819
X-HE-Meta: U2FsdGVkX1+PK0QbQARmTyry1GZyfznUUolb11JXHxnUeIIKeHKuwlbbbSR8/9VPOhbJHf0/Uh6VFG71naJamhV3+R3OjGVmqwc3EkgMUyEUrNvq9vaqhVWDEttnjQbixhjiqUD8QURZ7SotEkN/c7mp1rQM9YFO+OPeU9F1rquCiWLfE7imxU5/g/PiKltQM4VXTsQrB4ga+sFtaI7pSbnJ74KlvN/ng9KgcqRnqWtyS7h9oQGxJwPt0/SpDcX9biNSTAYrzj+TmVx1VHh/7hkgPFV2fCE9Jqajzu9ztRfoo17Q0X5c1EpONRx1/Dm3bRRU+qvLefTUPhUl5z4/U2+L11o7wBef/ytPa1E7wuTe3t2lgD2mTT71YuIy2H8/he0sY1yi2Qmea+D7S2/T+ECCp699sc+6GtEX+5RzT2rFAw2xRKXN2bUXa5KRGraHkP0sFbY2yM2NpaL0gOLSRSMYn9ukkOtws8XAH50ykTjmrbwjH57YGlZ4g+fYO1/GmVsNMdwM4jua+VrXl33Uuywmu0P5oqbr0HFtr6HaNhAmgXRMvQh/dzPRRoOSFMK6Cwmp2OyvK2g3h4Td50Sl27OIXhS62e9Ikw8s/QjKlicisgS53lfwV6JGf0DUbokLJEDj+tZ6B5ZVOO7MMHEzaESwnbpnmEe5Su1WfkDc57TRj1UvRMau2v24YHy8Z+vlv9U/0lmZxJPVVGienyaED9Hv+9c5Tu9I63vAcsbrosLPqxz0H40T4ja14N1ZUneB/Eawy9tLs6qeN0uF9MS82LSBQedzCahxyYxl//tmRxhWLH6GZFuD3/gpInMwnwK62LHym6wXiFiz7/eEgs764XuR4kIb6ldc3Zzrz2HOOA50pcdgZ1OhgO3WfRkR26zsfFrSurfx8dN/av/ElMJ0Mr1ASwa3wTBHqoimHNnD31avC49R2AM+95TMoxTGjC2Sae77nTGIwlOrs81YfGe
 skvMJlVi
 1M7MzztnDrDLa2vy4GrVj3+g3yQNIxezQjSVikSjFP78iJCeqFU+QE4OQ+y0NmJHICXNQAgccqS/Wn3W7Yq5qitNRniLhhhG3Bp9OoMyYst445ZTpr/4CUUijN2lsoL2WNDxzmoKOE6VEh9HxLQBXfSmucBRR6jQww6kz+37L1A5xvKBJxUiCOZwreXyNIrRxhrVhT7EhhPqVjNUcljlJP155MZxXjyPe/Ixo96hMQZYo7MsCoowHweuSXqPTkwlDFr679ROOt7ahZMDXhul3Wd0tef+UQG2GrHL12icNxmRd/ddhVJvWtovnR8dk7i2jLE+YzqePIHxsxED/B1Cmgym7Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Manuel,


Let's use "mm/damon/reclaim:" as the subject prefix.

On Thu,  8 Oct 2026 18:20:10 +0200 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> DAMON_RCLAIM -> DAMON_RECLAIM
> set as -> set to
> 
> Signed-off-by: Manuel Ebner <manuelebnerli@mailbox.org>
> CC: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

Other than the subject prefix,

Reviewed-by: SJ Park <sj@kernel.org>

> ---
> I hope I got the right git-tree. somehow there's 'damon/next'
> and 'damon/next/damon/next'
> The other patches will take a couple more days.

mm-new is the recommended baseline for now.  It might change in future.  Please
refer to this document [1] for more details.

I applied  this patch to damon/next [1] tree after changing the subject prefix
to what I suggested.  We are now quite close to next merge window.  It may
better to focus on making mm.git more stabilized and therefore ready for the
next merge window, rather than adding more changes that are not really urgent.
I understand this series is not really urgent.  Hence, Andrew might not add
this patch until next -rc1 release.  In the case, I will request adding this to
mm.git after next -rc1 release.  So, no action from your side is needed for
now.  Let me know if you think this is really  urgent.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

