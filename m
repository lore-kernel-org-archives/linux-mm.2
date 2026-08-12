Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C234EC5AC67
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 03:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E996B008A; Tue, 11 Aug 2026 23:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9016B0092; Tue, 11 Aug 2026 23:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5901B6B0093; Tue, 11 Aug 2026 23:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6BD6B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 23:00:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 908141401DC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:00:02 +0000 (UTC)
X-FDA: 85091113044.13.6E1FEA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id EC35EC0003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:00:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ejYuQmuJ;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786503600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DsrGZHknKt51D/hWKw/9nQGs0Ea4a5vFpuH13+ofAQ=;
	b=GHQnuRXz5Unnz8S45iwbgxSIUuKJd65bgx5V4u+ZGh0dtYOb6Bu8OEhdtcAExxsuFRMx5r
	KkKD4Q/xff35Po4tRLFUggYsKsZ4kGsmO6qFrMoEGcNXzIQI/AdjeeLDgGS7qPsqO+5a2J
	MahpsQvHbd1NO9KDysssu8lyQ/buJLw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ejYuQmuJ;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786503600;
	b=sIaLE15R6JgkDSu5HfdqCI8rbTYvzLCJM2H/aJN77nAIvhHil/hnXvpRsWBKHjZiCzVn7s
	htoKSAszk9hv70Dv6MQ5qAw4CxJ1i/GlNAhAF5ZO+71B17sD4Qym/JOC+QJPTPmtPx8Muz
	PRrYTxxlSTl7WuiErDGhSW6VhTVJ2NI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65A25600E2;
	Wed, 12 Aug 2026 03:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3091F000E9;
	Wed, 12 Aug 2026 02:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786503600;
	bh=3DsrGZHknKt51D/hWKw/9nQGs0Ea4a5vFpuH13+ofAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejYuQmuJDMxlxoi6RHEuINerf9JR2b21IkE/uXiYBpwO0d6PRlbnYMj4ZVfYKGrLm
	 tiV2PeATT4h1vyyBmo8d8uIVP++xPuF00IihAzT9JMsEhm5a2mZ11cNtQ33XbzrQUW
	 OBehH06vcqEsUXiyelyFZ/6LwaHo1h7PXd8Hllt28Oo5FCSGT2RS4DHhxdc82RRwxL
	 wleohzN3oX2nYPFCQWLYiq4qEPB8IqWGOV9jcMiRv5w/7bKyoGKhW8ukhSkAMHFx2/
	 iFJ0HozGzKRDwn5XFBhIE01eHdvejvHEfiQux8SWed3+ir+SzHd1MIMPXd4BhKTvbo
	 KSVkK3VFm1Feg==
From: SJ Park <sj@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/page_alloc: replace custom bad page ratelimiting logic
Date: Tue, 11 Aug 2026 19:59:51 -0700
Message-ID: <20260812025952.8854-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260811172156.356053-3-pfalcato@suse.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC35EC0003
X-Stat-Signature: ziqjknc9rw7a4ufazthnjmh7o4688pjr
X-Rspam-User: 
X-HE-Tag: 1786503600-17133
X-HE-Meta: U2FsdGVkX1+J3kG5OAeCBik7TR1q8Ks/4iwFDUpnbhgCwQ0OwAFLLL0HyZirK+5Fcmdiy5TYyn+m8/zHndAixDldKUfonEos8lgSfx42rK3to2d3S8OYhUP8rXT7vzjcC1WlI6R9c0kfNJyQD9PXT5XkTDpuOu4+SKRqnQ7YYi3sjWUMgnCarug4lmKyz02Gbm6z0B7j0wAtOuPFMvHUtbvmRmGNRSys5KE1yyAnCcO6PA2KsFhjVtHKGx12zYle7n2qm14oGnbUlJ25rzOlc0WsZxw4uSFRkBZwtm6NNADSb9XbtpTaGdD2SZEHYXB3wlXiUKCiBIGstPnD32gSg+p7W9XBl0H2XyEXtLEZFQhx6/u4BXbd0p10PnurGlgxczLR1z1UjxC6kMTqxflYwYQ6SWR2CIkcpGnfFBaa8oyxAqsdnO4Kv2lP5z7IDFm4sEOhjuiTPxayCHYK0y4ofHiIFLlDwZ0cqYXdnprbBflZakPxO3ywUCIWNI0OrRKp4wgmxoISVi1Uv88RCcD34Lp2xAkyD8YMMPcZCQOjpsxBgKNdASBaPzftRIzNJSNEQ4q9fzNaahmo0CiASKk/QtDeNl8TgXtUiShhDpd/L5toL2NGTJgjcKa5bSfFKWqveF0KyG9LcS3WdB8xDQ2ZBKE7dD8GAHs2kdqNdhKt11cyKBkJaLq7qP+1me2aQh1V/exMEfGpBMyOZcrZwuAYs/wbLLMp3NmcvuBDvnvbxn/TwNKsybCfteDSgD1+sKrTfeOnONOqlAFwgww1pDsEoKQ7PD8Ds08x6332n6KYhGIeEYV2VvApUpVHtf8UKIfkZ8x1XD3yCiDwRuNNG/NyWDW6+p56f3cptTJ8+Q9uVB3gtf7ZA/YYm1Q9TFMrsPs92svRUy8sxBjQ1snA+wz3AMEA1O7my7RVjNOuDeFoUq2LNpFr7t/lzpD7RVaVw+Uqt9vbgH4wR2cWuQcvmkC
 TA3aKV38
 vjd7Niz8zj5QzmBUT515mbV+oPziyH/Q34UP5+vPEBZPU/HlkWVvrSXKIgmBOzbxQuHcSK6xZihHN4cgZpjL/6skGaTFSyb7k1SkvYRGMiJvvSz97ndl7RcsI/HNNVjikVNqACK8snMl9mufNajrhHuX6N/4wgttsvo00gadc+ELlpIO0Wib/GuhQpyyDbXQCx8dTIMfnQiGMXQB7yTBp4iiZvCgzahOEV92FtZUOvrH150OK36a+CkhWp6kSeBf4gYb6CZMq0My3Puo1Y2AGRS91Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 18:21:56 +0100 Pedro Falcato <pfalcato@suse.de> wrote:

> The current logic (allow up to $BURST prints per minute) can be entirely
> replaced by the generic version in lib/ratelimit.c, used around the kernel.
> 
> Do so. The only functional difference should be that the new logs will
> read something like:
> 
> KERN_WARNING "bad_page: %d callbacks suppressed\n", ...
> 
> But that should be fine enough.

I agree that should be fine.  This looks good cleanup to me.

> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

