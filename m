Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E845FD9E26
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9997E6B0161; Thu, 26 Feb 2026 19:49:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9478E6B0276; Thu, 26 Feb 2026 19:49:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83C636B0288; Thu, 26 Feb 2026 19:49:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 71D126B0161
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:49:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 002411A03EF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:49:29 +0000 (UTC)
X-FDA: 84488403258.17.B588789
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6E3B9C0003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:49:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dW5VLMc4;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772153368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2KlksqtDqDPZMdMNp2MdT1X4G1xoh049uiXqGS1sLU=;
	b=7OuXF2UqhxDYbuN8bO82WvcRf/9OneNlYFGQynMmFBOt/iP8k57xP0Xzy9YLrw0eIGh1SE
	/YqGVN8d5Wln4pHqJRiV/IqY5UOoerTW6J4kRZ+zcs2V+GyeaaITdLl7r2s+tKpGrKKgUZ
	z84AF7SJ39kPO8Uo0JR/3ZMPCiVeqL8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772153368; a=rsa-sha256;
	cv=none;
	b=vFO0aqSf9NP2MaVXCTljIr7A5bYzlhs6V2Ckle2RkC2DqbOi70BiCO+tpCaCNCQWfGMpxM
	TJFuHcaNL0TqD7g/6T7bWPCkmD9T7nJXEY2ZMBB2G+hpI2at5BcJFeAREd8Mwch6ZVqoDX
	Ef42wLbQ7Rp2EsQcjn9cQvgbCdYwPik=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dW5VLMc4;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6F0960054;
	Fri, 27 Feb 2026 00:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905B0C116C6;
	Fri, 27 Feb 2026 00:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772153367;
	bh=0ei8WZJE2FrdZHn/eCwJkCgGu/fralSeuheP3WYhs8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dW5VLMc41+6wsYn1fqjBm5Z2dUQzsrLIbMzBUCUJdNzLWkt+tAliZNJIqTJnGoZiw
	 YZcBpJQwV0umiTacTFuaTGPnJpiWNkDjtQ67O0D4xvd2HmOIoQ383C1NJZg6x0hTWl
	 m9zMc8BqIYuIqA+2QC7M6Z7mAWWV0MIHAGQmg4fIDG/AFlCe8SM4+pyGsHQSuTmmOK
	 WSZzOC+Ss3jHGxwo98vclmX6SceFPgJdF2AiwULvTinadsNnKEqAtfzrcN1Iu6oWZR
	 VR1I//fmXR0l3+taU9//5+KG33gAyIHnLuySx+efG/BhDRB+2aE05s7mh14xOdHFi4
	 JrOhqSjrBIMMA==
From: SeongJae Park <sj@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 4/5] mm: rename zone->lock to zone->_lock
Date: Thu, 26 Feb 2026 16:49:23 -0800
Message-ID: <20260227004924.83661-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <1221b8e7fa9f5694f3c4e411f01581b5aba9bc63.1772129168.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6E3B9C0003
X-Stat-Signature: xwmresquc9in1eh3h6pqmkaqmrd87jdi
X-Rspam-User: 
X-HE-Tag: 1772153368-867794
X-HE-Meta: U2FsdGVkX1+Kbwovl0KN9WrlCovdWOMgtr2hU3sfOwsUjcZUcYzH04gIRVKTG2SZnucTvkUqMhYvW0g5PuhGxQKcNSNLxfWQHWKW3gRAqstOftSsrhbDOOM6oebFI+c/E4aRZ656HG5mVy45X6NwpxB8umAdMznjkTmgMLdbBl72xuvgYThBoxUZksGWcOtBy0vpr88SfQ/qEGZ3lEKnPqzdGGn5C3YGPEoLTrS2E7NjQx2+CwrKDVntwQNrlJ7JCrlyvMfcL4yffvxfax3RSHJJ6d0DMzNp73+T4BzVg+gy2CL7lzisaxGDsqvXhNLtE0ey57M7P/Ov3zf0pRJKRURJnM6m82x0Qo0F0YHGoL2q7po9eLyPQU6qbo7sx4r0bQNtBtm79yT7x+DHBhLJhmB9x6p1Kl4gAaLuaE1brRpF5/YWL/DUsAWolOlNAOLZmxaGikn3fL+1VniFDBWX3veE0ySvUY4khGhITf0fjq2aEcmCqIdUZGp6epzy3vcb7AIk/NEnlSsCgYCPL/TuojmzNhH6jEGYm0uUx+WjXMb7nSYBuBN59B4ksrVuHiNKgU0T9ggP7lVmkXFAduw3QcB+2y9banv8aogv7ZIf8NZsIwRS7uDgdXGwD26iurEFpR6Nl9eed44oEXgKkuNLkbpw1JteWLnCsaRMg2KFl88SDavD20ObtYVDb/GSGfVXhhWiwvh7R/pVSMxq1LCgsfoKWLW9DXf4yvQhUHrY7HUQHyAPv4q15ASLK6jBRz0Dh1R1U+RVpn6Ku3JxqtThd4nVetqTMZt87RzwubvkbZa8U+W4/RYg4CXnhIa4D33I0DKYEyDr4Daeuh1IGYuBcjkctJaXsB3LfHu5ui7mSzYU9Vs6VsfIgR61PQUDyvyzdgyO1FAautnBA69EqdZxdjumRs6J9xXzu7UWALnTzQqnzrA4KEMilI5GJgGOgi/qu+i4vPc2hANUjDE99wD
 JEt76xg+
 ztRaqIbRq5/W2VHDAq0haerGiSC8/AkUXiBg84qTnkwJkA/3sHEvSUGW2v+tvMk3hQ+5iiCRGos/uxiqffR+imLYXB50EdMKk53qKs2efguq9JCimZOpAj23yR3r5rsqUk1mqwaV2mFl0EIx7kRKp3DIjY6X+l2DmEnzn17axTs4NBm0pMSdX89FuWZLP6WXkallXVMX4jk5uwH9xUoMfGsKJu1zhY3FsiO2JH8Qq0rGB1Ot4xfubXE+gWcxLSWaw92+butL2b9QwUEcqHLWCMmyCw9f4t7u0MGl9rJ/ixXLRkkCfyu8WsRBt5kxJciF/0BsvIu1EC5ffIZUw3ZQYBFy1n14qqyMJCle4EyuWfo0fclwUojwfR4/VMKfbsmZCWXhmddMPBUQHKaA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 18:26:21 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> This intentionally breaks direct users of zone->lock at compile time so
> all call sites are converted to the zone lock wrappers. Without the
> rename, present and future out-of-tree code could continue using
> spin_lock(&zone->lock) and bypass the wrappers and tracing
> infrastructure.
> 
> No functional change intended.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

