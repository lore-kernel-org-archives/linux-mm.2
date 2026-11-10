Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8A95606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=OHmvt/Dt
Received: by kanga.kvack.org (Postfix)
	id B0C9D6B05D1; Tue, 10 Nov 2026 00:17:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD7E6B05DF; Tue, 10 Nov 2026 00:17:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA446B05E4; Tue, 10 Nov 2026 00:17:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB576B05D1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:17:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F0A42408CF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:17:12 +0000 (UTC)
X-FDA: 85418050704.09.A026CD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 324D420002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:17:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="OHmvt/Dt";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794287831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hJUKVOXw+rsYg0Fl10Dji6GuiYtz/4hFo7JB2GRgOYo=;
	b=DJEk9jKUx9oEhynt7pA67jpzXIW2lfiZRjydNDe3Sx+J7nPRyzJFj0PdjCPpAPUQsXLFQN
	35hNa3m9/N2Y5ZChTSCreVXaRj+IgsgmaL2etK4q/dS+3m7Ll3ZGIepRF1iX92eCa9TyOB
	Nr3eaAh9uSC7ia0LjedSaYEznfDSaH8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="OHmvt/Dt";
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794287831;
	b=qi8VNO47Bqi8FUP6aXUllBgZrjtGRpouBETSK45yZgaPfJwHTd6nbzym4Mn6Kc/PBj1ReA
	TcWElyu1Fm50hU4yQ4y++RhiN+55zgtEAGQ4S2DKudcX7qHzt61kTpZ9osCPQ/ga4rP6Cf
	Qg0rkuWyxAkEqnI0C8dtuALntKDP7Bg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 682BC61154;
	Tue, 10 Nov 2026 05:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019051F0089F;
	Tue, 10 Nov 2026 05:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794287830;
	bh=hJUKVOXw+rsYg0Fl10Dji6GuiYtz/4hFo7JB2GRgOYo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OHmvt/DtePgbTU+VOoheC8pijLTPtihzRe2VU2S7xY68oADyVHeSJ0+6zjB5vuhRk
	 gNZrALJn6f8nyM+4RwDQMibH4qvZC+jQE3kTRXpnJp/0QbRtOA1peLP4M+RTC+Fa6U
	 RYRAVYwpzMaR/9fTcpx2vv43kiBRNr+TOvtpCh6A=
Date: Mon, 9 Nov 2026 21:17:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Weilin Tong <tongweilin@linux.alibaba.com>
Cc: catalin.marinas@arm.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: kmemleak: avoid long RCU read-side sections in
 reports
Message-Id: <20261109211709.133122f9f10091f06c4acbc1@linux-foundation.org>
In-Reply-To: <cover.1793871596.git.tongweilin@linux.alibaba.com>
References: <cover.1793871596.git.tongweilin@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yk33qydcbomngt3s5eycq1fuouu79kxy
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 324D420002
X-HE-Tag: 1794287831-872193
X-HE-Meta: U2FsdGVkX1/7AwegDOAogZJRh96QQIT5b78WzSk0aGTdqHuZa8J9QhHJGybWik9x6ZyRFiN0z0yl6unGDH5jx+U45rL6RYHeJCno0+e6rAd8M1Ed1BvhwaKKMR5OYabU91bCGdryvMyqQ7kp+31XvKKOWM9kQ29sYtUux7rgjDkdwo7Vpv6FXxC5LNKa6juoI3K2IeqGEtsBZQLKMUEGB887yLgArL5X4q6ZVgyPjr/MTCeXYJbd9ufaMeOjhf1a2sHfE/XU/HFhohX2eVnbx5Xy2czCjygL6EAbOtT3u4cjI+TyLggNzQkoBjuwYGalg+IUft4SRLS6j0S7naWuG2whuS+4Yhe8CfGTLIl+JxoSJlk+YBdFGf0gy+i0S4LL+CQbTmIU+kR9OhCKss2S5UOH12UPjHMI8Oy0Ejrw0ldVxTxPESFPIlx8LI4v8kn2EJcjdzYbuhTrNyra/ewrcAsJZmoe+Pq9a429nfMs0LK5XHgSRWeRkrGF0IOeKOCC6vIETp7zSlDTp/cSB3yD/uN10uKFuc6YX9rCQ0NSAPgvc5WP1JzN12eXFfHi0QYKM4hQAjqEnfJa+aTkUlLWcB7kWXqNZ/xfyWA0yX76kLn/5ZsnNnElzbG7Y1BazwU+PjrwlugKEkFTOVkXIlwjTkg/q2hSvqSReIN4RdgIXahbqZiJirY7Y1gdkl9EdMhJxaHIFdi5WcxvIg0t56ndZi9etXxVwFZI8LQYsET5Gu1VXTEZ2AYYAxOBhN7TuC/bNiDxSHgGdT4NdhCH5T83JvJflIqv+o7T7p4TE82Phj/RG8SFI3UZDGy9WLVmWcxgQ3gALO6fcS/gluZ16l0TrN9mztBzE2GMhIUYVSJYdwmJdkspR70jN3j+ZqxEBWo+NVeEiElQ6GDBwGyM3nOMXKFubwOIQaD/9BcQXwbi8Bi0oBPsydGlCnja0NhrtXR378bHPsE7axIBdgCdtK8
 dr+GeWAU
 Puc/mZBSpZWVqvVg2oQo8HPJrJR2DaJIcXwTJQBP9UjKc6sfeJHUKgD4/raly5RgNbLo5jIXMFhowtLkvZyo4f7GQUN71A0JXEo7SYSjO2Zby/5HbYL8imOkOqErve/3Ijuld8hXDS/VPKdatJ6QoTgh8T/KjUEA3xdjjGetTGvONl8nhqV3TNRvRRoVajads0pf4uZeLk32F475w0Y2idvsrW17CQlytnHZWGec6/L7aeMo42ZkmrPSf0maWdUo5+BH4MjgRBBpHD2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu,  5 Nov 2026 17:52:48 +0800 Weilin Tong <tongweilin@linux.alibaba.com> wrote:

> Reading a kmemleak report can traverse all tracked objects in one
> RCU read-side section and cause a stall.
> 
> Serialize disable-time cleanup with clear operations and report readers,
> then use kmemleak_cond_resched() in both report traversal loops to let RCU
> progress safely during long reads.

Thanks.  Has this been demonstrated?  Are there real-world reports?  Or
is this a theoretical thing from (LLM assisted) code inspection? 
Please do share such details, they matter.

In [2/2], *pos does not advance while kmemleak_seq_next() skips objects
whose get_object() fails.  If *pos isn't aligned to the 256 boundary
and preemption clears need_resched(), a long deleted chain gets no
periodic RCU break.  Seems the code could tighten and simplify the "once
per 256 operations" logic?


