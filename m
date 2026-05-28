Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 698F6CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 22:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8A46B008A; Thu, 28 May 2026 18:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0726B008C; Thu, 28 May 2026 18:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE566B0092; Thu, 28 May 2026 18:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9E76B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:03:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 568FA1C0891
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:03:30 +0000 (UTC)
X-FDA: 84818205780.08.E431A11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A7369120012
	for <linux-mm@kvack.org>; Thu, 28 May 2026 22:03:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=McJgGw4z;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780005808; a=rsa-sha256;
	cv=none;
	b=kXYP9Ih2AWaxQUdgGu6wghr+Bpny0B53E+KFHFJOK5ZGMh2Mg3F2oDhmJGXI4l/8nA+leE
	JKZv1vPJlbSBGUGDdX2vePXzATwD7zLROcLvrcMUVPeHMAdZp4VELd9fe90Xbx+K8SolPF
	GVsjcg4ymj6dRE6s++E6CfZ5q/UpglY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=McJgGw4z;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780005808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0Hze0ky4/rNG6F8+M77htSvxrrhvd586dvH2Pb8gIQ=;
	b=c8MGQj1waNd7g/uhhr7opcSVaK3WHy+9x7oOLkQPX3Q6Q3oS/YBGrGQ+ZzkSFr+ZYYYJ6d
	B65umlzpl0+Opw7LN0vP5ArYEnUZ2BqDBAyWp8zbM3HWDKDMRQBCsPSHZ+xDRmak0KmxBx
	JmtDRjTMgrxhq83McHUq4X1vhe4LVEM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E546A6020A;
	Thu, 28 May 2026 22:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3601F000E9;
	Thu, 28 May 2026 22:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780005807;
	bh=O0Hze0ky4/rNG6F8+M77htSvxrrhvd586dvH2Pb8gIQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=McJgGw4zRF6gJlFeTdF498Qz8KZT55LAlMMBBckJUC0xCc+ktkmAHgYqHvtksG0hC
	 wYIKmjnLLJ639scoceOX0Mi025vTVQXjvHPDXjQoeRnb415bZBsbt8mxSTP5y23YGO
	 gnTTvu2WZuFKY4pxfLZvQ5hoQd9g0dIwGYsQ8XO0=
Date: Thu, 28 May 2026 15:03:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, David Laight
 <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>, Song Liu
 <song@kernel.org>, Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 0/2] lib/raid: replace __get_free_pages() call with
 kvmalloc()
Message-Id: <20260528150326.b238f9ab223c76fe8da6907a@linux-foundation.org>
In-Reply-To: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
References: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A7369120012
X-Rspamd-Server: rspam03
X-Stat-Signature: 433oynzjkr96e3snwe69ucmrondshxw5
X-HE-Tag: 1780005808-332856
X-HE-Meta: U2FsdGVkX19qMCLdIbjPTvMoRQviPKufHm0PPUadkAGCEdszFdrBSvlXU7icjG1Yg+qaOO/5mcwVhDicnvWMglJYaDTa8FBCtqhOP5zmw0WPIYoAR+kRLo4WEaqCLaF56VqgclySdADGp3zlylDicD1dOYO6QNriCIph65XbqFGksDcVgTWNcTFXokhpNJTWYjD2p/cm4O9/Vgwe6yQmXyZEKg5DhfWSOfkJ82dvONdPYd3nD90Li/ZS53RDR1RVgoSld4tydcfmvm2sfldX7Y0cBXi7f7Tt578q2+ymJzlQGynQqF2JO8oqzMDAACaOWSyqt34ywCCiN/UKCAigWUCQU7bZmDxotAEl4+JDAQGPgjP0mpiMHV3SYGMEZofwH7JU+6LIjzm45NcUEn08EtIELgniSe0DGpfz6/83/kaLKruHFyC3i+LwTMzuPThr2Upd7DJqQf6fb2sVwn0hQG5kzd9yYm68MIlQCuUvAIQbRJBk7Pa8YRQLfwyFceAkNkjLX3fmqGnONpbeLowQxwoipeQPs+BcWLXeCQppliVq6hpxMGEdvfSAzaC+FxBoA0G2E/+Z7b99F4zerxtjHd74Pt459s0q5xqIxRZLLxRlR7AhXH5R+oyjM7ccPbcEM0EilpbDusDYWzSpbGcaaeLDE+pycJXltK2EpsT8PHaT4PHtGPRCFD8O+TuQ/ItUrfAHXfyQHgNnokKjblSJgb4rs9jc/QCNqYkMt3wb9fWGhdZlq9kj+YuCAMU9cJe6FSWYAvl1PU2ImCaX/5dfLZvc/1RR28gYMaOmbZaCc76UGda4cR5UvAjbYOJjm5DoANYeHe6ESMopLdZuZXQPEh55Xt/RP9mSnW0E2Q2OWbt/e992x6IuFD29sJ8OyEBwnGsShqJ9icf035KSN939on28u+Yni7RzOH1Kf7s5ntk3Dtkqq/VDswydaLkUeew2wdW/sI7Hh9V0VnOWFL+
 doc/YkXy
 c1S8ZWcsE9+96A3oCkODHpqlnoOwXdIh9GLi1tRTva4WrZUd74OB3x+h0M1bPAF/GhGXu04H3jf1+Xmuu+X7PDz0wccoorD2wjhggBJgFF6LbskZpdfPbR3acKIiuL2UKHA0GZgDWE5Mp5riQgBiU0zUjy9p9rQmkrZF/RU8FQKE3ej+1VKIYxe95fv9eVIHxnqw8TDQIO9EtLbciDoDH5iN1YYb6sQbJCLwv/R297zKngvvc9oQHgaktIRmjriC4gMpTbi6TAJjRn0Dt19N6ToJewLAbfcZitrd6dCKoAf/a654A8D7WK36Lzh4VTzy15tLtsW58rDMDPzwDR/jQ9weWlaLHFlJ4LZOAN1v+2F7seDYTzzhJt6vrJjt/EJC2ikXpV2jFw1Rm9qYOgXRqFsWh46LCN6y81DlP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 12:52:59 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> Subject: [PATCH v4 0/2] lib/raid: replace __get_free_pages() call with kvmalloc()

I'll rewrite this to "... kmalloc()"

