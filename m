Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA00EE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 06:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062B66B0088; Wed, 18 Feb 2026 01:53:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023E26B0089; Wed, 18 Feb 2026 01:53:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92376B008A; Wed, 18 Feb 2026 01:53:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D4D8B6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:53:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 662B957CAC
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:53:58 +0000 (UTC)
X-FDA: 84456662556.03.1367199
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf28.hostedemail.com (Postfix) with ESMTP id B97B6C0002
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:53:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771397636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7QIwF2iDLQncQte398TC7fGDvbTyJ4mvPFmZplgmEEE=;
	b=aC+B7JtMXv3G+k5czwzOmlgWplLZH5i+71NY4fUjkvmC3Dlh9pGaHyCTj4jc4TXqTTdyOX
	OWGhi+kLSx3EcDYwjAKxslxedf0gJlp4BtzAHkHaRj1NXprdgx+OhgKJK2Lu177U1aioNz
	nMS+zjn7bhAJmx7iT+HBmC77kMvX3eY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771397636; a=rsa-sha256;
	cv=none;
	b=dmrAW74JxZLg2pYmvc7xf//bsKyoRVyToxqAvYwXrDyF8rpTluy+ow8I8Hg07lie3TkY6y
	1G22cm3SVj5XY6cipe7e2B6DrVrzLS9vcd8vRC8ec9bDfoPUfa23YdALLIqiUNHJKs0wq1
	ScWk1eX+IttFgK+1Bd1bdYwlz9hfPAQ=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 946E068B05; Wed, 18 Feb 2026 07:53:53 +0100 (CET)
Date: Wed, 18 Feb 2026 07:53:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andres Freund <andres@anarazel.de>
Cc: Amir Goldstein <amir73il@gmail.com>, Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, ritesh.list@gmail.com,
	jack@suse.cz, ojaswin@linux.ibm.com,
	Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
	Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
	tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <20260218065353.GA9072@lst.de>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev> <20260217055103.GA6174@lst.de> <CAOQ4uxgdWvJPAi6QMWQjWJ2TnjO=JP84WCgQ+ShM3GiikF=bSw@mail.gmail.com> <ndwqem2mzymo6j3zw3mmxk2vh4mnun2fb2s5vrh4nthatlze3u@qjemcazy4agv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ndwqem2mzymo6j3zw3mmxk2vh4mnun2fb2s5vrh4nthatlze3u@qjemcazy4agv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: B97B6C0002
X-Stat-Signature: m1nkdwgu5srsrx8j1k9zsjpwshhprsps
X-HE-Tag: 1771397636-108611
X-HE-Meta: U2FsdGVkX18JdjPoWJUaQkrqkpeQ0Ctt8QGOCr+joIjZt0bCVSD8jsDysFIaP5+dkRR9Tg7gVHxcKTOFo2J9hywy6GYzBQEzx6cUIdqOn0O7G/tCfMSxpbwgLM2bWRXWyrQkgyufzE57twHW4O6zfsWIIHotYlhZ+5iIbg4GMLG838/w6+JTogrrPQvJ9LdiayJVLM127Hk9JDsKS2XtSq8VRDuBQshQ4s/6o6i66BJAFiRX8++Rh/4T1AOn/Ii0eKx5eLYbVirVQVFCZkh0CV7PqFd7GY65z2ZOzVXXJjlHnr1zDSikx8SHd62KSpakF58I7snMGl19pETw1mLRTXnew8uamXBQ/HvEcHwTbX+d57oN7Z41lqZJSOaPA868rcaWVeJ7onqjjgATKF71e8gFctfuL7PgKTsmnxuOk+PRV+ump+E+APudiZ4m+dlDvA75+ma5KisxrGaMZA/4VVHLCSKdzf/Sxbb5GKCtOi8XZGJoFvJNwZTmsjb+CFAVknHgx6Ive7f1EBKSbhDudeex1fcifFPvl/z2aaT2IWCAFpZixJTeGoe4j4lokpe8JQK88Pan5ox2zwViveUTPO4b6znvHp0xfltTzmEhg4mFPqEoLWmeO6IGqxJ8DXAdCWy94NFNLeEKZ0SC1gFUwZSGX38Hxmb9Vmx87BdhuZdqA2mcOQ92pLOED1V2PoHGZK688FXg8SL2rorjlaGuOVPYzD+O5Y681nHrTTrwWumLXuYvHly0DKpN1SbaiZfDPWV60BbOUnffooyYbxuh3ShJI6C1RCP3+BV+jiTdQKb5FwuPyHsOaNyo+EyMIPiMjm1M3Ba0y3w9nGYTbIMtO8QOER9yN/gqs5+QDk+1qPil1DAj73ofjJG5RcAwXUf/wR7WJ6TtpxrvytLmXDkpmSVnsKaLftvRYQOXgtrqsL1AN7cadKgV2jxf0APHqK0geimtPXjSg8RR25zjZ/w
 TBA/1l0f
 RN9ArHcFrsanps3KeG+IqXB/shqxVqXuWZY7cGOn2lvkQj/8oQJ+Kqnqb20V1F5LIUU7YUcQVCCFyhdeSXejw39H02glb+AwXVP4SPlrUfwmU6z1pG4ANFK5CnxHaOTHtV3KWR+PVR4G6i7ts8qmvo4y+PCMUiX+SmKKAnBU0ur70Ar8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:47:07AM -0500, Andres Freund wrote:
> Most prominently: With DIO concurrently extending multiple files leads to
> quite terrible fragmentation, at least with XFS. Forcing us to
> over-aggressively use fallocate(), truncating later if it turns out we need
> less space. The fallocate in turn triggers slowness in the write paths, as
> writing to uninitialized extents is a metadata operation.  It'd be great if
> the allocation behaviour with concurrent file extension could be improved and
> if we could have a fallocate mode that forces extents to be initialized.

As Dave already mentioned, if you do concurrent allocations (extension
or hole filling), setting an extent size hint is probably a good idea.
We could try to look into heuristics, but chances are that they would
degrade other use caes.  Details would be useful as a report on the
XFS list.

> 
> A secondary issue is that with the buffer pool sizes necessary for DIO use on
> bigger systems, creating the anonymous memory mapping becomes painfully slow
> if we use MAP_POPULATE - which we kinda need to do, as otherwise performance
> is very inconsistent initially (often iomap -> gup -> handle_mm_fault ->
> folio_zero_user uses the majority of the CPU). We've been experimenting with
> not using MAP_POPULATE and using multiple threads to populate the mapping in
> parallel, but that feels not like something that userspace ought to have to
> do.  It's easier to work around for us that the uninitialized extent
> conversion issue, but it still is something we IMO shouldn't have to do.

Please report this to linux-mm.


