Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84178CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 14:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7517C8E014C; Sat, 25 Oct 2025 10:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702128E0135; Sat, 25 Oct 2025 10:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63F488E014C; Sat, 25 Oct 2025 10:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 523C08E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 10:59:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B5245567BA
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 14:59:53 +0000 (UTC)
X-FDA: 84036946266.05.EE429EF
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf08.hostedemail.com (Postfix) with ESMTP id EE5F0160002
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 14:59:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761404392; a=rsa-sha256;
	cv=none;
	b=OXWj7dslJKbXob0pL8WhqIF4YTsBxDTLvkiRQ6aLjKYcHKydgoo9sfjG9E3rOCE4DpFHH6
	GCqJVqzmBV3X2IyUXO2f3vNOtM27ABIislhE3YJPEiJC+357aYCds5ekfM0aOUCd7R/ysq
	6mKoXYsdK8gq9By5D0klxPyp881jhZQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761404392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6FRfzUfCG3VSQEpWDCjBiww7L8OtoVH4NKmdivzdhm0=;
	b=GZHMJOFSBg0IdK1HrkxS/QmgnnDBvIgO5QNJAZfhviCix8P4yxPLGsR1KKWidbrqlaLe5d
	JIdCX6Hvnlyz/nqyj8yBB8DVMyHVFqOYqUt4uu9SjFfHmbkYTyumr8JM3IprjNju11F3GX
	NXR/oUmk2YHqHSWHexKdoxw9YggwIeI=
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A92C56348;
	Sat, 25 Oct 2025 14:59:49 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id 6111E20026;
	Sat, 25 Oct 2025 14:59:44 +0000 (UTC)
Date: Sat, 25 Oct 2025 10:59:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Alex Markuze <amarkuze@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com,
 idryomov@gmail.com, mingo@redhat.com, juri.lelli@redhat.com,
 kees@kernel.org, lorenzo.stoakes@oracle.com, mgorman@suse.de,
 mhocko@suse.com, rppt@kernel.org, peterz@infradead.org, surenb@google.com,
 vschneid@redhat.com, vincent.guittot@linaro.org, vbabka@suse.cz,
 xiubli@redhat.com, Slava.Dubeyko@ibm.com
Subject: Re: [RFC PATCH 0/5] BLOG: per-task logging contexts with Ceph
 consumer
Message-ID: <20251025105944.1a04e518@batman.local.home>
In-Reply-To: <CAO8a2ShRVUAFOc7HECWbuR7aZV0Va3eZs=zxSsxtu0cMvJmb5g@mail.gmail.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
	<20251024135301.0ed4b57d@gandalf.local.home>
	<CAO8a2ShRVUAFOc7HECWbuR7aZV0Va3eZs=zxSsxtu0cMvJmb5g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18nBZUO/jhduNiWRSKvYzbdBO98QxDlMpA=
X-HE-Meta: U2FsdGVkX1+4lKsGaA7TKsVLzBxuvMoWhjOFNULKRM5Mg0jsoYWD1a6mSIKQSnfaBR1DcTcfFpjvTbAMWYdymXTSdrSlXJdDkC3RM+lJ9uDjCpgSdxpk2ZxqRN11r1TPLtIVgMvSOdISCn0CFXKrE8tZ9SSWJagKo/U0ktmYl1lsN4n/M1if5zi06ycFz7Avb5aPvoUU9WaNalGOu6WGpUMPlpULHnk5g1BcY7RNnuNHnrTdZJSHT8TnDmxXQ13NCZAMIjzV0EXdr2FEBN9TBuvgBR8R77k6XtR/24SGMAy/GckjuLyBujCgzeWdfxKzmrP4UdmfShDq+dNV5a4mDdcPqo29q1dr
X-Rspam-User: 
X-Stat-Signature: qbm6phw639s34wz9jzczhz1q9fdn1eew
X-Rspamd-Queue-Id: EE5F0160002
X-Rspamd-Server: rspam09
X-HE-Tag-Orig: 1761404384-373123
X-HE-Tag: 1761404391-54053
X-HE-Meta: U2FsdGVkX18ZScqN0cUuEFkadRJEyN2GonrQfrRlO9gQek+0qnCoPvlesCiryoPMvrk+ye6sYuw+0UV5pHcvb24KfT4JKxgR3N9CKe9NG5JPbj4z7Mpg6cVs702bkpvQ3GxQj3MXDiqeFJyb+Z5u+x7JPcglTCFO8CJERjcKZOkzo75ZT2Y6OKxC9zFPHnQgrp7myJ8+7pzeOIxkmU2R5uKYn8x+jmCBX8pwAPqytPfm6/Nj/F4j/Q7C61t36vitUBS1uQ/N0IPg5gA0JoRGIzZgsFMPO+Tqc0ePyiMDMgslo4ZgCFAWOskttSypr0V6/bBWj5wQujDulw4WC5VonYaBo0iFC9O+X3b19ol0yZYlWokgqKj0C6bmfbBccfwJgci3kV9WH6KSedEKHpQenEVCfVed3cF6KGs6pLeR8CyDAx+3FnO3ulWKzbbgfFt3dEWpx4iBsWJWHYkCIJlC/7nDuZ/wNTQOmnNqWnHm3GgudCR7qsiFcnKfN7Y6i+Ccd6G3IbIG+b3aGuBPGqQZPxrQ2369pJ/fJTatHrFjqRcWQb4JklZkhSWqPF+2HiykUXdc7VNQkakr/76tGGNUTus+AGUuvjqA9LOWKHt7XTxkPikq3fCe1ASgirvYzErtCRZsZNF1e4UHKfeo6a/xdsmSDGGDjTRIF5xiP/6Yjt8sKF4Co4SrvnkdzWt+T2l/cMNyzO9OD2XW5ssWpUGiJi+TNzFhBrj+FxTuWyi64DeIF0qXf1HFFIlJMDyqZR0zzRJJeRJYbNDNna3u0j6Wi/BndaI1OeI0DibJdLobpULi7aJACPuuPM3HVHZp0RdeK3rrbqOarqDz1q5+VmeejZVayTbEs0H1Ud60mLhSFLdKQfyN61WloZqnpl0Kns5kAOsBFakCYSwfG1h1xvkgG9ivK95xr4kLtssDJEDbOWujM5hfqzqqTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Oct 2025 13:50:39 +0300
Alex Markuze <amarkuze@redhat.com> wrote:

> First of all, Ftrace is for debugging and development; you won't see
> components or kernel modules run in production with ftrace enabled.
> The main motivation is to have verbose logging that is usable for
> production systems.

That is totally untrue. Several production environments use ftrace. We
have it enabled and used in Chromebooks and in Android. Google servers
also have it enabled.


> The second improvement is that the logs have a struct task hook which
> facilitates better logging association between the kernel log and the
> user process.
> It's especially handy when debugging FS systems.

So this is for use with debugging too?

> 
> Specifically we had several bugs reported from the field that we could
> not make progress on without additional logs.

This still doesn't answer my question about not using ftrace. Heck,
when I worked for Red Hat, we used ftrace to debug production
environments. Did that change?

-- Steve

