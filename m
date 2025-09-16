Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C140CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 04:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90CB8E0007; Tue, 16 Sep 2025 00:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41098E0003; Tue, 16 Sep 2025 00:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2FC48E0007; Tue, 16 Sep 2025 00:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A0C848E0003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:21:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5025EBB81D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:21:37 +0000 (UTC)
X-FDA: 83893814634.23.A72C442
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BE0B81A000D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 04:21:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Cb7MFG2o;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757996495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YpGdD2dm/MTTI24lvga4DtubiWO1qLAeq5QqDc7uSfg=;
	b=4YhyL5jmiDOSdx8ONmTozstXcdGiAT7Xdp9YsicBb3jJ53rfWTpcc0Lr3R4enR4UMGm2E2
	xrtyjoG3aaCiI6mBVUEcrFZxvgL8N1pPvzP9yIapfWwcu7kNAT4u0usKISEw0hqJ+j9mdW
	2LFpSSNztOPvJ8O0bvxwZSuGAiyqiNc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757996495; a=rsa-sha256;
	cv=none;
	b=x3+UuXXlD6CSUcxI4R2DInOTFZurvmVY4yf/FQd02xuWScIGrFYnRSk6eHCj2trZ2NMy4l
	JgD22ttNlQYCcp/hB8ekeg9QJvhDRWHD082+ap1An7Y/4OdSouSB1Tx+VTXC4eMckAaQ3S
	gUbm7oQ790KATk8ydtqPW86gFQZNvcQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Cb7MFG2o;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D2D0D60054;
	Tue, 16 Sep 2025 04:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F7DC4CEEB;
	Tue, 16 Sep 2025 04:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757996494;
	bh=G/Z5ifHDwolGtsQspjGTyjUZxMgScdgLSVhJoHQXb5A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Cb7MFG2o22DQBwP+aWgNGe/EYSb85/ZZVoydPgU3NyYefQiJvxaC4xxYFqmzVMewh
	 V71N/6ZuskZwVup/KRcrJs5OChrQNNvBFFavU6CvRMCFmDgxX8IVapTe5/6DekT/xc
	 +vybv7bdd7UKZorLXUN6e6f1cEuc4aSrJUkhP8hY=
Date: Mon, 15 Sep 2025 21:21:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org,
 usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com,
 pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters
 in /proc/allocinfo output
Message-Id: <20250915212133.de5b8522137a5ed30efe956e@linux-foundation.org>
In-Reply-To: <CAJuCfpH1JW8vwOFF2H2SOxZqoJHadXsTc6C=LUS_=twcf=k9qQ@mail.gmail.com>
References: <20250915230224.4115531-1-surenb@google.com>
	<20250915171112.f71a7606a7f9fd3054662bed@linux-foundation.org>
	<CAJuCfpFQCgQLSrzfVjV+J4tkYbOx_W9v-kWmoo-rmh5hs9gEXA@mail.gmail.com>
	<20250915195633.96236cecebd8777243a770bc@linux-foundation.org>
	<CAJuCfpH1JW8vwOFF2H2SOxZqoJHadXsTc6C=LUS_=twcf=k9qQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jdauokxqh7a3o6dz6py4x6ffsz7xq6xi
X-Rspamd-Queue-Id: BE0B81A000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757996495-761082
X-HE-Meta: U2FsdGVkX18l6DjXW2D9y+8Vd60N6p1aATqWG6Yq+ztZhhxySlxJCVmrABraKP6wG/JAuljpCAChl2ITgGvU5aurpTs8MeZh+Cxqi4vcwoTykqLDnl85QKfDh1nFRX1gUkkRu6ampgOCJHC9tNVlL7yCUmWW+V6Pe2CtHINpOoxv+I3cNT5Zaatp0wP1uf9cyJh5Ap+DwWA5Uc27HeNb5utl3LUhe1aSAAIaFafzJNiU/vw1u1iS3JJ0+oN+i+F+hGW6xjkxhDQY5ttya5fZrY5G1XWxPak1uEptPqFFv29ux3jhMrl85OS0vSjwLqzsHKVOf2ObjJa1FCCHILDaZuYoPdBN5BMo4KqlFmk4nkQ1WNwQvteQQPZ9eSxO/9/tRdImozOrh2J6E1uA9u+aqyMC7V0uTVUm1TM47D15XfXwPbO13ng8bEhJkg2m7Fp+kSKj23sQYlH3WGo8npU1+aAHcqxwQv7b0lnWHCwroxoq8kavgabIp1dccTv13+FwNqWOZlvb8Fo/GbNbMFb9T6AwjruuVd1vHxBtutymevIrP9EIyZbfNpDLVOgbd+gkEABmeTHJB6jc/e2mq3SQNq/LXDEjpx7OwEKPI/y5OQUcEc+xHs0ZdiwOLWECOGzE12DTpkB52tOFBvzU1U6X5eToEifjxV7ivEzhrD053UbBSQnt276NgB0rRfsoCw0PdwMnHhxqebC70wlbs0k51QeGV+J6CH2D/vgGv4L6CQW4cvXuq6ujgHeJQYeSEMTX0PXWiKGo2vgejlVXrWpScgx7+EJIGZ9QJdi2B2R5H9iigsBTAWbs3uXDjcOGlkkZZ292skLQcZx+vCioIasMbnpBqixUblL8sKeCf+x6ekETl2DHyXDTDiI0jas+5ON1B9DpCGATdJFTTixZ/fq+lPSF972cwG8Ujgc71w/s3blLm7p/q1FxCFxdyfjSMdzYUiZmDytZ5BV2QwK36OR
 fKHWq1MV
 2wF6G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 20:34:33 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> >
> > > could you fold it into the existing patch or
> > > should I respin?
> >
> > A little fixlet would be preferred (by me, at least).
> 
> Ok, should I post a fixup patch or you will do that in-place?

I think the former, please.  Your intent is preferable to my
interpretation of your intent and we get all the nice patch metadata to
track everything.


