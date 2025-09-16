Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A233ACAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 00:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7A98E0008; Mon, 15 Sep 2025 20:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF368E0001; Mon, 15 Sep 2025 20:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC068E0008; Mon, 15 Sep 2025 20:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA5D8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:05:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBC9187285
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:05:55 +0000 (UTC)
X-FDA: 83893170270.29.C8FE022
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2C169160003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:05:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Iczv0H88;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757981154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQp4jRks7xCRbdMH62HvMOA2apHYM74ZPv44U9cHEsE=;
	b=X/UcuzrkgMm19o6EAPY+mDJaF0IU29Mn/VoFPpYyKZHuc0/t/8E8VW/lt2P4eGrQWym7ZZ
	bn1q31zGnwpoEmeNKP+pnNYts9iwiR+lGCpoHOnjUj5Bgg1ZFj2kAS0Qet5axSkBXsSgmr
	ODWSVjp+ddrVknzOyX7mnj7O+VsYumQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757981154; a=rsa-sha256;
	cv=none;
	b=D6DuIlPAZtLI5W9Wmw5pw1Xo3ceb37aRxsoDARzVFQ+6SdfKVxBlm7D0VoMt1HbvxHpBTV
	GpdOteLMn6fXa8aXh4POeTJtPkAQzC7PRiB98IpDf3bvBNlyHvs6qWoXt8pok01dNDLLXF
	VUQ4qKQzOzPCTKJVCZEkDtcCT+Bmn10=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Iczv0H88;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5334433CD;
	Tue, 16 Sep 2025 00:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B8CC4CEF1;
	Tue, 16 Sep 2025 00:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757981152;
	bh=OrGMt8ZJZs6DqpGv5H4cRS8nHNx4Zw/bJfWF3GfNAOE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Iczv0H888igvWGUByqVbrWfrf6G3GY2J4VQsxfEn4SpHTrABJNatZiX460FGXwyu9
	 UThpMkOFY+oL8O5ygbc6eeVd02t4JQWS8lvFzQaSNEkWe9gYW7FfidDfrUFqbvKe/R
	 9CSRdsVBjB/BpTMY+Ju4lnmK9fKSoI3p38HtCCeg=
Date: Mon, 15 Sep 2025 17:05:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de,
 kernel-team@android.com, android-mm@google.com, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Kees Cook <kees@kernel.org>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan
 <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 0/7] vma count: fixes, test and improvements
Message-Id: <20250915170550.f24bfb96514835154e8d1633@linux-foundation.org>
In-Reply-To: <CAC_TJvd=zwhRZcXTvDPfuzdjYV7j_jvZKZ--eKDRTsE+LBmASA@mail.gmail.com>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915153401.61cbd5120871ee7a4e5b9cae@linux-foundation.org>
	<CAC_TJvd=zwhRZcXTvDPfuzdjYV7j_jvZKZ--eKDRTsE+LBmASA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2C169160003
X-Stat-Signature: fcscysbnt5i96cg13ucqxfgyecnefixo
X-Rspam-User: 
X-HE-Tag: 1757981153-377817
X-HE-Meta: U2FsdGVkX18qQFomS2Y3X0vBWbW9dMDUGiMv9BSaT3V1oMSYKgapHs1RahXoe6S1yryx0P7WM2Yead3I4m75M65KTVu2dJw6R/vTXWxSllqki01jSJ636pKgNu3E5ADDBHtZGHaDvOOIcq5x5PHPDa3tSiSq9TCblyRx4hmFha7TNjR+33jdv1fRnYsUS6+c0Egl6jtF1VWAcmW5vXtecF6ynLzZlRjNQ4tOOe+3R/zuVLYPJ92VYuAIDTWRAphN3f5ixpx606cXEpY+uoEuAYxgywgHgxoYQ8v/m/2yLjSBwIF0Q00f4stwBa7d+MqmQ37TKtHyMhxV9gUJNJw2B0KNQ94FcFqM6s2qKzQ2npcAJ4SzC3vF7ay5JRPARQw1xg1CReodIHbKEwiBFOK6xodkLCOz1Zm/qY9bTNxB1Zs4z2iTDj3/MWf/fY2pslhLSBOV+qgpHtXoHww1pk8lViYl81NRHyl18jzxebhiO53wbai3B4wBMLEbSTEKjRMtHwy7qx4GHhnxsCgxpxFN724VCDif9jFNCdkuNcF3Nf9FBx6ZrGVs8gYOsmc9OFDFg+0KvC5DBmymsT6tuwBw39plhVOR/xxR60G86U2YR6uCb7/fcra831B8c3ms2olRyuVw/yYeGUFwOt5N/KE720EqtEUrCT/WpVekasWQKYQRkpfL8OzEm2eguZCykS5KN27BU9Jv8XTWyok9pr6Qi1nIdRbFFs//UJ28csOGeNbbESaCucOFD4/ozCAUm8LmOi3z/8ILOroLNpJA7KAPsX1G4LdjLtpdkWABCPan+IzLURNqrSZNAUlDUxu+8ngUjauFRKKsT6XzrSXzuN4Sz4BOgwNmczXTl9EPZY6EIHJQI/41W13Y4uN9P0DdCuOAahb2VpUUYK3TySzLLs3dbCQSCzCVZb0gwL67OOAHBhuWuz/YhUTL5BbGPbP7HfU9VRUiCVA8PTYao3SZ+em
 IQgp8UQH
 0OMgJDQLw4MfYTHQN03AHF+/hVqn23gxF5pgDJtuqy0nVy9YY+r1Dg3Tb77MBz7kn1lsONoH940sXFc/afnFmoUOaBusdX1VhRYnfA3HOH9mkvZuihNtyL/u6IHCZciolaAnHXNTOljMKal0ngIOWyijR3DlSwnqMPJ5doCXorHWSLu18dWNMixn+XP63S1Zp3NRznvTReNCP8YEXYCebaw8FgFkvneSXD5nbl8cBkd3w8GI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 16:10:55 -0700 Kalesh Singh <kaleshsingh@google.com> wrote:

> > fwiw, there's nothing in the above which is usable in a [0/N] overview.
> >
> > While useful, the "what changed since the previous version" info isn't
> > a suitable thing to carry in the permanent kernel record - it's
> > short-term treansient stuff, not helpful to someone who is looking at
> > the patchset in 2029.
> >
> > Similarly, the "how it was tested" material is also useful, but it
> > becomes irrelevant as soon as the code hits linux-next and mainline.
> 
> Hi Andrew,
> 
> Thanks for the feedback. Do you mean the cover letter was not needed
> in this case or that it lacked enough context?

The latter.  As I've split up the series, please put together some
words to describe the remaining 6 patches if/when resending.

Thanks.

