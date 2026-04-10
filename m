Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A56A2F364CD
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD5E6B0089; Fri, 10 Apr 2026 06:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E416B008C; Fri, 10 Apr 2026 06:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C843F6B0092; Fri, 10 Apr 2026 06:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B303D6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:51:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65FDDB9A0E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:51:14 +0000 (UTC)
X-FDA: 84642329268.07.4CCA02A
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf29.hostedemail.com (Postfix) with ESMTP id C04A2120010
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:51:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=zkc9T6b4;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf29.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775818272; a=rsa-sha256;
	cv=none;
	b=NkNcdn3xhGcVFulihBFyL1o/lleho3f0r+KgJ4Zph2Sc7RqGxH/v5yY2bi/+x3jXSr02Rg
	85NbmsZUhO9bPtr4xOq2l4647iERcOeLNy4aqT+y69HqpYRSWfPIJx/ZHbeGXqH8skrkEH
	Utcilg+yGCvSG7fMbEJOttHhv1i8xQ4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=zkc9T6b4;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf29.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775818272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GrBsVEjNctRnodxgaE6XmiwO91zdT6jFmRl1mywmyDY=;
	b=18l3GTtQiHHEC9UJ6/nzROZ5Yh47DoWhTK0huNO02lpDUQdz0HKvr4gom8Ija2P1vIKuf1
	YpxkfVtHQDd7mw+8M7/t+ElBJQ1/QLshgl4SnahvdYvbxqfgJqzj3n8lKzx8Phm4Og6ULP
	EML1a28hAMER3iDXIhLwj7pZ9XU88Sw=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 1EFE1BE890;
	Fri, 10 Apr 2026 10:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775818271;
	bh=GrBsVEjNctRnodxgaE6XmiwO91zdT6jFmRl1mywmyDY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=zkc9T6b41/J2Y+aDNrMjlSTZdSE4B/pmJ3/nXN1P0pDq48TGbPBUIsMmplmGkxo/T
	 FLrHCyherHJsvCCQFT9w7nb8IESZR2kxfgB9PjTfsVhtfCp0an7BeQxNsydSzh9rV5
	 zvKagV/DiZeMO/DJlpDz2T107AFWQlTIFkRRagKs=
Date: Fri, 10 Apr 2026 10:51:07 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Breno Leitao <leitao@debian.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Christoph Lameter <cl@linux.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org,
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/vmstat: fix vmstat_shepherd double-scheduling
 vmstat_update
Message-ID: <adjWGyiVZ4neZRCw@shell.ilvokhin.com>
References: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
 <7cf39b82-ff21-4d9e-b2fd-1636c3e203ce@kernel.org>
 <adiuinlYfkIjuoOJ@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adiuinlYfkIjuoOJ@gmail.com>
X-Rspamd-Queue-Id: C04A2120010
X-Stat-Signature: au9yn68mp3kwbio7j47cmpjouzp85cg6
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775818272-412645
X-HE-Meta: U2FsdGVkX1/jKb0K8DohqkY+PSku58QZtfhwR45Eulh5h3eo1HSQ8KiHk6PzF2VY5O4PqGxkuwiE9fQLmu2L7YdMw2HhUeVmmbTi3FWRxENFd3AtsxeWm1FTe+lm+YHvyemEuUbM7cKz3IDCfbBo07Zx53TksgazhPVGqaSzo6YR01XHkC4vetvtbbT1fz+DrAOwHH9+TvO895mY25QDNU41kvOlI0kG4h8ZeginlH/VYfSlOYt0kijPUGPod3sBFoLDCyBmjxXiedDmyyYK635M/73/9JJVdYAf90ZAxV98Hg+eekDmCZgepk4PTHIiHVxiI8rZ7RAkxLJibcr/NB4wP/kEZviwjSPqchO/zTDniChT9FqtKWcwEBu5W0vstPl/uZUV14xVjD2tJuIKrQ8C70xc+NDBKy6QQflP/QylGOgdArhIVA+A3fsemoGXWEvf76lo336zWBtGMIYcSarsyH6OA00hWZoBXCRiF/brVH/M1Unv8udG1vLnV3WKZX/hjWgBwc4tnNtdaQbCoQnpC49r2kwOzYUAJoNiuqWeWIOeo3bmU5UDwVCVeXLiFa2ycLUvx+I6JMvv+s6jn6mT6hhz7tGS66S7zjux/u7TVhltnKmKiVsUZXFyGPyqMoxTtYUM43L8KCAsdHiDK1xK22Id2kWhBbqfD+UQE84ozhW+8mR7Fjyuxp4/VACaCb22Co4ObBdaONUSwzIfnNxIH5Ku08QejTz6PBEUzyVlOtOi0cp4yuFL/v/QXQLTKsSE1us68PHHzAK50JyAQDhspJsP89+hTsQE43pVV+92J2XlMSrkIZx+7RHmWn1J5CC7iXR+ESe8f+bimLsR+sR4hArPdxp5JJo9TMrfiKv+Q/oS123oFe2DvBZ9hBPst3hbk2FazODYCEsgHQmxPdxPVm2j372ocjS4kQCPXgEaGQNZUnl6WsHdfAhc2p6wkTITuwA3yI0YuTq6rAv
 N9XxV9C8
 VN5QabJj/caovLaG/KyYBCzpbZaTwvyjqFXhIMxARACicbrQB9Ip29pcOpX4+JpuLZSvDTO8wagC9s6KQ82SOT5/xO5/gwiA9awUzO6XrlKva4X1OlpLurbeOn/q5GDAt6ogyx9/ZLbmGmOfkDPsN3SHMHkObJSQ0tIBD5v3R274qRrE53UIifEWgYvnbFKMh5Fr2G2n626BPvF8WHhK7w+RnXQgPTzP91Sh0f912iulpp9nhSu6tiEGV3btik4xeE3Q7gN6Jvk7k7mkPtebfQ/3qzW+0tup1U6k6r8tn047MI9mAM6W3b1Vobg18uEmy/u9dP4MNK/jBoZJ4m4y/EEe2a7IjiU55ViyXYRsYsCDnDMO/Mh/+dx3QSJJTHV98VitF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 01:03:54AM -0700, Breno Leitao wrote:
> On Thu, Apr 09, 2026 at 07:01:01PM +0200, Vlastimil Babka (SUSE) wrote:
> > On 4/9/26 14:26, Breno Leitao wrote:
> > > Fixes: 7b8da4c7f07774 ("vmstat: get rid of the ugly cpu_stat_off variable")
> > > Signed-off-by: Breno Leitao <leitao@debian.org>
> > > Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >
> > Looks like v2 posting raced with Dmitry adding R-b tag to the posting in v1
> > thread:
> >
> > https://lore.kernel.org/all/adebKQaiAP4G3liv@shell.ilvokhin.com/
> 
> Dmitry, would you mind reviewing this version as well to keep the review
> trail complete?
> 
> This is essentially the same patch you already reviewed.

Andrew seems to have already picked up my Reviewed-by in mm-new.

There are also several other tags there, but most of them were given for
v1, while the current patch (v2) differs, so they may no longer apply.

I've added my Reviewed-by again for this version.

