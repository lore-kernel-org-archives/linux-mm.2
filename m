Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12DB5C531D0
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 03:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1DF6B007B; Sat, 25 Jul 2026 23:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30CE6B0088; Sat, 25 Jul 2026 23:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5D96B008A; Sat, 25 Jul 2026 23:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84B646B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 23:26:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D86BCA1494
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:26:36 +0000 (UTC)
X-FDA: 85029490392.08.AFA81BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id C1A74180005
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:26:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C5hXFeas;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785036394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujoywRATcrbjMYNELLJctilgrlUcGvbj5yO2i928VnY=;
	b=EJ8Bl4VxrLwbipUnpgn2lXuTD62Ol6+5gVRiQ0skWkvpV6cXpIKSxC3DMIuoyStr9cPCJ1
	ZPTlN7/T6hamyTifBln/TpVH2obENHo6PXFZbUtikc/kMTQuFA0ZAVnEY98UjI/d9SvtK0
	an3PsR9mCWUc4GTf5mAn3vxpyzZro/8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785036394;
	b=XS4Yg0/vqSfU6YesxjOUQdaiuyVdhmRBagsdpGCi29IslZncO1myqfqh81GXEZc1fMeVlx
	czlZ0fNnIWsJzkINu1rROmScaMBM/DLRT+RF+i1QPHrYqe6gfsoSpvWPbt0MNV8wYgZR0B
	3EzlAbp3kbpfET/CKDbDHMjGoUztIN8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=C5hXFeas;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96EC56011F;
	Sun, 26 Jul 2026 03:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FE51F000E9;
	Sun, 26 Jul 2026 03:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785036393;
	bh=ujoywRATcrbjMYNELLJctilgrlUcGvbj5yO2i928VnY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=C5hXFeasm97leSm2ZFfgZdr5aKD+zPJYh6c32nLRB1bv6kA4jy/H7lC8P2kfLh68z
	 hpzsypaqVIG8c0DNYMPxTwYHqTO3Zwx0j7wz5lFUlc7HCG17VugyR3yUSar6eLk5qo
	 hyEtqM+UNXtcBuSoDm6nCAbM8QzwSd9ylJaeAjqA=
Date: Sat, 25 Jul 2026 20:26:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gou Hao <gouhao@uniontech.com>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 chleroy@kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org,
 tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch,
 bharat@chelsio.com, jgg@ziepe.ca, leon@kernel.org, namcao@linutronix.de,
 ynorov@nvidia.com, sshegde@linux.ibm.com, nilay@linux.ibm.com,
 clg@kaod.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
Subject: Re: [PATCH v2 0/6] remove dead NULL checks after GFP_NOFAIL
 allocations and fix xive use-after-free
Message-Id: <20260725202632.dcb325658896a470df91cf57@linux-foundation.org>
In-Reply-To: <20260724022851.466017-1-gouhao@uniontech.com>
References: <20260724022851.466017-1-gouhao@uniontech.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1A74180005
X-Stat-Signature: wec9p8jer6e3ipnj1csre7itehttt1te
X-Rspam-User: 
X-HE-Tag: 1785036394-546216
X-HE-Meta: U2FsdGVkX1/B4qwxuO8KnhMLSuvxBjDze4eUNJLS1fi9Ru6IUUj3uuSd+vHqY5bFTkjNG8Rpf1DAhi+OCMzKH45ffMhFm1PTeS2KhT1TnMr6kN1+uyOR5qGgopXIajmigzZPCwjXzd4sdM7cpybqYKeGepOZq6YA/PmRlvwin4cTF2od8Av0o8KIGl4jQMGzUQUNZ4EfXH2cMm/jcnSx/+pagl2SQTQ2HAwr3kQslDnBDXE/ELmRAGJ7z7QuBZvs8Z9nOsjbeOCFbzGQ+GfL4nSYOrNhA0+MWcJxRbq9XzOFJGADPK61EWYXbOMcxA0+b352WFNa6vQmuKyzGYLXrIxDfiSX7P6piwYj0laz9oK58rrOr+VYUYOiWu7zduhyYQdav7egmsuX5i71pSVcZyOaZ8ksrklC1BIjgDDuMy6sz6fRiTQ63ZZnX9lXduKVH3mNrPhe35olHe02Bf/hJLwgKISgm3/BtIVph1grtew11/Mr366OEMoRJ5dpmyhGg7fQoX3n0Ly9kK8Kuh2aXuu9jcCVq/jPGoJB9qi2jjtfK/FDTNxrBfbZqZ1xMZq4gNUQawc7crGhRu6ioqfyRNUZjUB4Megt/CNLJ93655ZZEJEoUzLYN1EhriDCWRgfupD6AhgyCQwRta2IN4xHO/CiTWTF4J+g4EVrxd5o+QZFhonvKU4sIrWgopq6iyEDt08XG2WWaJMAzL9Eps1wBFUMnp5CQddvrl9KKnm7QuSj1Y6Y3cJKcZOHNgYo82wJlxM86JKAO4qcVpCFXOOCYWaJCpxrz/1fMlBspPu0AE11c5TBYzEEgOxxWfSaAid4lmsKh9aceZGSgeVRndwE/CBD06pxpVEhhTo/W6TBrF7pwX29a8hy9TWWE/SIanDsCxFaVoJRoa7cMCsV/YU7uXMJXnxPamr8ni0nVFMp5xdbW3LU68beaafy/wxemv+t8v2wsf7/YXiuydewiRU
 dnYCtvEe
 8+CbUaSjfoB5X1Gyk6fxR6sJbEy4OWbz4v2z79x56hL3r/DTk/7i3rzF7sv6AsqhanbegZvUzQwSuW/Uuadcd57GiTwZ01T7YjcNg2uUBfCIZ0PpyL8n6QLO4BCQ5TNOMT61qEmUMyNOxq+CXzBvAF06GnhLpOoFuxztw1g5TBr2WjSZfjv+BQqbuebVHUdnaP7frqQ3OgvjSB/2KRr4drDNGXVgalnIuQdMVS06Hizzo+TCiT43UlA7weS/uH8FnSERsdsClqe6fjsevuZcH8hNWLpOlhVHZjYIIK4oTp9VQ5yky/iwF7Qe1DlElCmLDDUSWtoUFKMJJng64TwlNf1/kQeCEnUZ+Y4S7UH51SNpsLh9X4FmKED9c+UOZTlFMe9agz7NXpAc0ZVHDdqaUdLlAqzcUhOgFGV/V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Jul 2026 10:28:45 +0800 Gou Hao <gouhao@uniontech.com> wrote:

> This is a code cleanup series that removes unreachable
> NULL checks (and associated error handling) that follow allocations
> using __GFP_NOFAIL, which guarantees non-NULL return.

Sigh.

Back when Linux ran on an abacus, I added __GFP_NOFAIL because four or
five sites (file systems) were infinitely looping on alloc_pages until
it succeeded.  I figured we should move this operation into the page
allocator so we could easily find those sites and fix them to Not Do
That.

I made it very clear (changelog and code comments) that no new code
should use __GFP_NOFAIL.  How did that work out?

hp2:/usr/src/linux-7.2-rc4> grep -r __GFP_NOFAIL | wc -l
241

So much lameness!   My immediate reaction to your patchset is "No.  Fix
the damn code instead".  But I've resoundingly lost that fight.


Thanks, I'll scoop up the entire series.  If individual patches pop up
in linux-next then I'll drop the mm.git copies.



AI review has a shower of possible pre-existing issues.  I'm seeing
use-after-free, double-free, leak, system hang, NULL pointer
dereference, usual stuff :(

They're in powerpc and cxgb4, if maintainers are interested.

	https://sashiko.dev/#/patchset/20260724022851.466017-1-gouhao@uniontech.com

