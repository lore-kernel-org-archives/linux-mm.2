Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D79C624CF
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 00:46:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3C26B008C; Mon, 31 Aug 2026 20:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C286B0092; Mon, 31 Aug 2026 20:46:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1756B0095; Mon, 31 Aug 2026 20:46:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55EB06B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:46:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92F9D140324
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:46:09 +0000 (UTC)
X-FDA: 85163351658.05.AC0E50F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id D7842140008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:46:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Hq5cMU1S;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788223567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfI4nJW4NZXTURLLniIaQtBfHGjWmn+gqY78i2JXq1g=;
	b=lptvQ4EBI054lx755NelZFCifA2KmaiGFYYg3BhAptLFmoyE/EwuvIV4M1vfrWnkAVRwsK
	TyMPK1F7CPKhBC4LgayOaDMtIRaTiul2yLfA64KJZ9irVeo0vc7H7ZHQ8drOnWVXtu8EMA
	tqu78zXbXxNA14PSTTb9a+vNfO8PWPQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788223567;
	b=3hXDTGF5eUoWPM/USdpVGacua3sptXWVu01tSEYckuyYABA30+jrZf7afeMFhekdG3bwDu
	RKl44KELFT15MlbgMezPzyGmFUNe8ES6sZqB34X6cM97e3m07rHUHN0D7eZ4UxD0kNaN9Q
	K6lwAXcQq7quEat2GC/35RdmLWMfVI4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Hq5cMU1S;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFF5E601DE;
	Tue,  1 Sep 2026 00:46:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973F31F000E9;
	Tue,  1 Sep 2026 00:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788223566;
	bh=wfI4nJW4NZXTURLLniIaQtBfHGjWmn+gqY78i2JXq1g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Hq5cMU1S8uQbYuvCrodD6jKmSm+wxowLUmyrGzsBsHCmq4D3xzPMTIi4Q/BnBxm80
	 JtL7GP8is89pIBLJGtMFrDDaxmAKdnDP8dQo/uLQhHxF+1yhsoB/wUgdYfuthBFmjk
	 tppIR+WsAf7ommFZeRL6lw0jdWpBKDxTpsuvCxks=
Date: Mon, 31 Aug 2026 17:46:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ziyang Men <ziyang.meme@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Johannes
 Weiner <hannes@cmpxchg.org>, Michal =?ISO-8859-1?Q?Koutn=FD?=
 <mkoutny@suse.com>, Jiri Kosina <jikos@kernel.org>, Benjamin Tissoires
 <bentiss@kernel.org>, David Vernet <void@manifault.com>, Eduard Zingerman
 <eddyz87@gmail.com>, Viktor Malik <vmalik@redhat.com>, Andrea Righi
 <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>, Michal Hocko
 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, JP
 Kobryn <inwardvessel@gmail.com>, Mykola Lysenko <mykolal@meta.com>, Nathan
 Chancellor <nathan@kernel.org>, kernel-team@meta.com,
 linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
 linux-input@vger.kernel.org, sched-ext@lists.linux.dev, linux-mm@kvack.org,
 bpf@vger.kernel.org, llvm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] selftests: shared lib.bpf.mk for building BPF
 progs and skeletons
Message-Id: <20260831174605.4f76fe0a643fac90fce740b5@linux-foundation.org>
In-Reply-To: <apX9zb+3awc99Pfh@devvm16600.scu0.facebook.com>
References: <20260814075054.507089-1-ziyang.meme@gmail.com>
	<apX9zb+3awc99Pfh@devvm16600.scu0.facebook.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zsnap4ixzindhfm65ftqpnb88z1bykny
X-Rspamd-Queue-Id: D7842140008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788223567-522144
X-HE-Meta: U2FsdGVkX18tc8xoQ/WeRSuZxnOfoyZRBxzEOPN2PFwoZ9AWQ+Jn9D4wIiLhDG4+mJOG25GuZ2X2dpLWfVjKyvR7TcLoR6BVGJvQLszZ20r5QqaR9X9dspDy9bBV/Zde+KtOrt+NEJp9A338AY2UIUXH528G6uJcSNn9wSMeNbG8fs3MKBksl/R6XA3YN6u7tPZeOwa5xxxhss4TAXt3eRwRz7RljOrnY8lblHaNgHpdcZuVVrSKEk5ZrVsYdoE1CfXt4+p771FO0tZ0Scfj8+lJ91UJqKUg483azSg61VOGpDKXr0nVS43mnavd6onsdfishvOxm2Wxznsoxw0e9fcVVlYEGMaMN8FwA2IC92ca+M5sPVFwllKWGjgl/L/nhxNuEsZMHZMjnLoUdMq++VYNnS2zFKE/KxWTrTZTcb3MtOG9EKGMS9LqdgmG6g7NoQznZhI825nNSmj/aqHIQ9N2EsQMjXfSjNMY0qGV0AalYIxkWJkOLhD7paEBsCMWVW3FMLRkA0AsMwiu2yr389Dx3ACJsIxqhMiFjiUnP3LM47O1Dhb+DIihy28+Jjydd6jl6cj/54nkLx6wDlVM5Y159UEzM/9JiA24djY2PVOKaYAV0hnoAQPZq4k0KEUFz4VulsT7gbdwCFdO69QFmlOfRGbxvCzcYaFL4pSAfHrxTvToxeJFXC/lPGJvZaJYn1LfKyiWJjGz+j+1EWBgroXqp0lIhnEHQnkp3g4mMT5I+OdCATedPNVohkz+PwSCVNPaXnxco0pbK/1jmGSqHesOIl8QjNHPfO7+HgO0+fuFT8Z9t8qrbtLHhtNnIuZlUYjAHlXzTwz6LNCdcxEy+4Ht9LUrwxfGM0qP9nH60OvJlK7plPXatNvrsy8V7c/51E9++Blfruuc1TPMvZx6OiBC5Aba0+nhst67dh9258azXM6SMJ9fh+ehiuCufdcPsYs95t2MzlJZVy5BZ98
 LLmRV1GM
 uc6z6fsDcVfF7kXo/0Vt9/AfrK9ZcUQPbs4jFsZW3ghlXB7LfjwPXPEFtDOJ275ZEGjXgwMnsHxTShBZwY7mE2qDPMEF5omQDzlIbsJOa4+228+gR/Q7F2SDFXllwpZifZaQIT8abT/Ck/efDT+Cfqs69O5sku8LjXHrQuuwXtSM+TJtYdPXLmwcpLcoRnZExSFGV1PXAx/UfwYdJ9LM/nuTssQKqiYdwvnoJfVWmyjC1Y/y0LnTmjPBvpHYq0eCHOU2Alu91PXwooQMqJIGvzDbFMl1CU52Mwl8caUolRX5VUFqjgGXrR63ww2T3KQhpSXUv51ImC6qjGVgg/DnEG5bJX8dVYTNsEKcLQMxqTwecberOeQ3yHk4EVshkbQbP1R+giQp7/wgUrD4Alo89oHwmUfZgNWZp7e/A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 15:18:53 -0700 Ziyang Men <ziyang.meme@gmail.com> wrote:

> Just want to follow-up on this patch series. Please let me know the possible
> issues and I will fix them.

It was sent two weeks ago, during the merge window and bpfbot said lots
of things and Sashiko said more:

	https://sashiko.dev/#/patchset/20260814075054.507089-1-ziyang.meme@gmail.com

Under these circumstances I expect most reviewers would choose to await
the next iteration!

