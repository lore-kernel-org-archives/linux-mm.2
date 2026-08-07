Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA05BC5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 12:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7837C6B0088; Fri,  7 Aug 2026 08:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7342B6B008A; Fri,  7 Aug 2026 08:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649EE6B0093; Fri,  7 Aug 2026 08:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 466256B0088
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 08:47:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5305B12033A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:47:49 +0000 (UTC)
X-FDA: 85074450258.09.7F30C60
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8CE328000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 12:47:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786106867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oB1g3U8oYZrBk+FyzlJRmF4DKw0WcyfhRDDb884GRkI=;
	b=1Kfw/0GKHDN1PK2qeHsb21eCtAiafWCOVZtRgMwv3IpLiQX/+rrzvjo24y+HUz4kdEITqx
	kqSjV/6TJQnxycLrfpRLHWzLNORmFGZvSYKjxD7B0pWFqWnmwSjAm3ki9tkgrD0X6JVylP
	LxUVHZe9WaKaurlz4wn3RlIPnJFLoIo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786106867;
	b=8CqFh8p8el2JuXrphro3tiKKI0UYbLAYxY1oA8SLD5xRuFPo5Nikm+0OjIjH8qHe9rpNKq
	mT7+1+f3lqaGh1OGTmT04dMN/csHVy7HH01CULiNDJqH5C9Xu8COreNyHJN2gDgo1MnJNk
	daUcFj5nsZxM0l7ZoXJ1Kxet2yHu2L4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	none
Received: from omf20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFF78C038A;
	Fri,  7 Aug 2026 12:47:44 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id 245AC20025;
	Fri,  7 Aug 2026 12:47:43 +0000 (UTC)
Date: Fri, 7 Aug 2026 08:47:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Meijing Zhao <zhaomeijing100@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/3] mm: trace: decode architecture-specific VMA
 flags
Message-ID: <20260807084745.5d96995e@gandalf.local.home>
In-Reply-To: <20260807031349.3119855-1-zhaomeijing100@gmail.com>
References: <20260723092905.761037-1-zhaomeijing100@gmail.com>
	<20260807031349.3119855-1-zhaomeijing100@gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX181hHT2nBucVmYFf8KtnO/F9MR9aIZ/VQ8=
X-HE-Meta: U2FsdGVkX1+DGLfRgjDbdG4UKHh8Gu55/3rIDNSaQyl2Xb1GYY78La1EEesiQjBRrHQg9Rhd+0/71lgcz4/v2rfh+zW6aglqTy44wpuxGQzdXV37eH/6VuGXT7D3XkaPgjSQe+VV+FIPH8AXSS9lq7ZeMU32m81oOpNWj3HSJZZk0VFzAhvmy7chWkLbb4l1Sj9+cAgpiNV+/KTQ+ksv81TY2/nT88V8uG3JCW2dDiXjessZkZ8JP4LcasniYxqjE5jnSLlOopohnKVyvZrBIulswfzu1a+TwjuNxJc9Zdl0kLT9llVgQx3nlurZPwgcGxHdzv2sr5Zc/Aye3pNtfb3H6XONtF0wrpb155mQcj6rVhiHfFtcZA==
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8CE328000F
X-HE-Tag-Orig: 1786106863-854382
X-Stat-Signature: 3wzurnwh57wptxt9o5yhhyndwwymxmuz
X-HE-Tag: 1786106867-678260
X-HE-Meta: U2FsdGVkX1+b1sFPs8YwdjTx7e69ppVw1tExTCeCpWIkT6utsmxsa8p/0alDjjRdaq/ajHRFlAzF/RPn9Od1xyqyN2Q51+PWalXX4gi8D3ZlHHWPN4J2hA9FPoZUKvIKxNlqE4TRZ3M5ootgamxUqHRciIRfVUNhVDTekcSptQ1YlBN1KzQEU8c57LmO3qjIaHW9SbBPybAF1fqTJT1feNX2xv8wXy33ssRsVo2F/PT5fgutqcv8Aohv5jb/CdKkGl7m2eNNm5wuTNM6iKefcGutDS9Ir4pDAQbePwCmKojFrcKRttSwEvcDc9tW+xSd3iyYEYEXOi7v+EpxN+NadU8ZMs9+aV5XMEWKAkmwMJNKhSD96FHUS+lSuSH+v0UrxSCH6we3VpryVxReKSXiRhc+9L1KC1A/wCyRs/UfOumVvehoeWgVf27d6pkduEBysl69NSZF2sD7zgDzgbiwMJZftiUvzGarW+VOQxzd18o/366USXwNX0p+3D++sZl6qW+E0Zxu8BgoP6I6On74JD62POb5oCjeiX1ZyUuWQGFkQg+l6I+hmvuSexTi9cukWh8tvNBHlspL7OcEfmwgXf0jH+IkhjWCe3spqUUFwLTQ3/y8woN0imvSwv0XLhsgb69km8evxseUCvMxCBA+CGDG12bSVDl9l64s3fsceu5dMTDQ63J7+ssa3eLOWnjZ8iPUZryAK6xFRZSKTHpmgRj2iUW29FPG3JoCmeksfRxSeyO+GDRGsA0aZgFMOhdR4OVy8QDaJD/NBc+hX/kl1j+9XqASEu7EPBb7NgMHEpd6bLgp4QfIM8kB5tnbxqHJg3YMoe8ZrLLoLlxu0e1HjT+5ksf625Lin/6p5rKqxyi6tchU1XszljmqIL4uzNdm4dJELOBtMAhYXAhYWRKLnUThBq7KMeeEKfI2WbIJ6C8f/TxBLMMxrYKpw9OoamvFM+yAHpcpR/vCV9eEICD
 q1pUefaQ
 mnj5OsyRgSetDxTg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  7 Aug 2026 11:13:49 +0800
Meijing Zhao <zhaomeijing100@gmail.com> wrote:

> Hi,
> 
> A gentle ping on this patch series. It has been about two weeks since
> it was posted, and I have not received any feedback yet.
> 
> Would you have a chance to take a look? Please let me know if I should
> rebase or resend the series.
> 
> For reference, the original thread is available here:
> https://lore.kernel.org/linux-mm/20260723092905.761037-1-zhaomeijing100@gmail.com/
> 

You may need to Cc the MM maintainers too. Not just linux-mm mailing list.
Modifications of tracepoints in subsystems belong to the subsystem
maintainer, not the tracing maintainers. We just maintain the
infrastructure, not the content.

-- Steve

