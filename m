Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F588CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 22:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5D68E000E; Mon, 15 Sep 2025 18:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AD718E0001; Mon, 15 Sep 2025 18:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA748E000E; Mon, 15 Sep 2025 18:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 811BF8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:36:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44833C0793
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:36:47 +0000 (UTC)
X-FDA: 83892945654.25.36DF07C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A42F24000A
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 22:36:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XD41Em6O;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757975805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ylWCf7mn++QEdplcms6pMXryBGpylSj+eyDc/Pa9P1s=;
	b=TLoTEoUjJFrBRcUqQHAq2PoQbVkDpoClz/mOg429do4tXaCgd22qA4r69FzLOQzr7+J8Ej
	VHP6o3fPuO/u98mcH3lO4qBArfFASpbH7LgprgmXtI5E8PSKpyXcMLQJa1w1mtOq1P7nFv
	YaMR3RaUntVvdkXt3QbTMAHw8bL2hb4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XD41Em6O;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757975805; a=rsa-sha256;
	cv=none;
	b=kyy622LZH6SOCMhPsiRvleUEhMB/cNllbxlvKSlkZRwTw0sGcgXqrb1042g1gfPIXUf/rP
	P+eiwmyo1GmfdzWoPAj2IMnznsRrUs7q1lFonYyAyz7bIJxhfbE8TYkVlkF3j2yj2VT1wT
	mR9T6ahf+1i+9pR17Hdb1Y73f+n5fwA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06AEA600AC;
	Mon, 15 Sep 2025 22:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39092C4CEF1;
	Mon, 15 Sep 2025 22:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757975804;
	bh=ylWCf7mn++QEdplcms6pMXryBGpylSj+eyDc/Pa9P1s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XD41Em6OmVs/HoC8kKF4blvfGChKvN0hV2kHafNbdfw7lxTmLwGmw/DqpX6A5BsrR
	 HUDbr829kBnmqQtUMiyeZGsD9I3AGTqn13vd4Lod1ocker4JYMSk1Z/HoSLo4sATDE
	 MZ77dRrPipxfDZKn4KoHAdPIpv1J26ShiMCw8YHs=
Date: Mon, 15 Sep 2025 15:36:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de,
 kernel-team@android.com, android-mm@google.com, stable@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jann Horn
 <jannh@google.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/7] mm: fix off-by-one error in VMA count limit
 checks
Message-Id: <20250915153642.7f46974a536a3af635f49a89@linux-foundation.org>
In-Reply-To: <20250915163838.631445-2-kaleshsingh@google.com>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915163838.631445-2-kaleshsingh@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A42F24000A
X-Stat-Signature: s6rju5w89ojeaggp6nekymhcw9gxbxbf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757975805-43287
X-HE-Meta: U2FsdGVkX19atstTEe0WNX2M1135Ml9+hYLR+2BkjqQLPlj9yOKdSuOZPHs1RS7ZEuQEkpNYDzHXsLBJcTBipLFXdmgyUaHqm1fLfR87O1c9reaIlWUYwMvezpV+jrVcUuBaMuF9SC7bWQ0tCzJe6WFWIcPTOEn4s/HKFh7L5ye2iqU0If7knzEfNK7KrhKD4VwAfXuCtJiR+pRWk8xto94pzZQUpg+AHwHOpSUjzfof3COB6pyWWX+SSivn6+XFj+NEw2Zi1ome8Lx5JrznFQiSG/CJtS2Bf1jeskLqWhLhtSfrro97xishf7ceNYojgWUz3Kg+FM23ZC5jZFTNbQaee1yOvHy/2AyFf1uNb6cKIUq2ne/Zjd8budc082Z1h2GfQOx4sVYgOiIKsFvf7UQSUVvWacywogZknktCasMRcjpm3/v3EwX7Xsge/ri/fz8tFJDLM+/bCerdgVDjzVvgI1OMX97mrVgkdUrUSftAUUTYFCDufyewls6CO8mVHsWvxtoL1mADa34BseNXhbyDjz8eeuo5rerA+GRyaHONczkIBZ9E7FlTBx2Nn5gI7gvhTo5fOCezvZcMYEI8y39bZftENmpotKrVyhhMLXFkYJR6ns7d1oC6zfB19k4dGmiJoo10+Ha6dxNSwPg9eze1L7AR84Sf27efxW2QA5m9HHMjjoe+I1YCyT3r1fQu3RGt571TEeg+mvuiBZTP+dhwWPdDKSOQIFaasaE7RVYcHNQsQrLcqGeaBhdEycbklNKsM6QusUNQlpnSHXKzeCGOsJlwTQbGurvj6oMLurRqPam5xaepps1yrzkEDrqTpMAK6dFcv5LyHj9YEVh7CJ5D30evrcz1CCmt6DXT0Ul1ei60cHlGVxLjp1m4bgkF0FEZplHEisLUccPPV9ykh5ryH15xxBoPYbAv2bt0jAZbQpMxt3Qf97aUKiHr4R8sPwtLoZsN3ztd+yUCsQD
 3Q9pby0V
 09tF9Eg+KRnSsnl6PN+LKtS5Gq+lftNhi3XfPgIMn3xBfjwGxtBe0LGUG1AeEgMsSrnyQbu1bNdXjhhSH5Ma6+LtknaiTxEXnlaSPqkOdvYbnsGZRW28iB3Uje3y2lAzGwtYxoHoWf2zvlkGUXI3xn/k0/PEaoEdis8d8QSqNAdbDmue+bjyz7Dn+1CJIAW95vwf1AB4TjyUcZzTMOZ5zic5d8DEwOnHhnNlDm2+WJjBm+8XwZ+dtjDhGH7u0cIznWdew
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 09:36:32 -0700 Kalesh Singh <kaleshsingh@google.com> wrote:

> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

lol.

x1:/usr/src/25> grep "Fixes.*1da177e4c3f4" ../gitlog|wc -l
661

we really blew it that time!


