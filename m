Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F08BEC79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 23:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD8D6B008C; Mon,  7 Sep 2026 19:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E892F6B0092; Mon,  7 Sep 2026 19:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C7F6B0093; Mon,  7 Sep 2026 19:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8A4C6B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 19:25:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B860C031B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:25:38 +0000 (UTC)
X-FDA: 85188550356.27.EAFD9E8
Received: from mta1.migadu.com (out-199.mta1.migadu.com [95.215.58.199])
	by imf26.hostedemail.com (Postfix) with ESMTP id A5433140002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:25:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QRMHfJnI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788823536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtebkO6fHQqVEN+q6vEw0kJNHvFekDfGiYSLlcOjT4k=;
	b=5mF0eIRy/7nITIzMNl971GKY9X6QJwTlXf2CTRlqusdukUA7plLmR8vZG/Vt9G23XhQncx
	eZePAYH8cASIM1o9gu4AOG4Ie031BfEeCXMuEDHX5sDGKhl2XX/a9aOaen+z9inktztImm
	iDTxuwyNaFw+6vncacR1WWyH8JIO8cs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QRMHfJnI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.199 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788823536;
	b=vaovU9exkvv6Afmv3Mu8nPGXffd00WCMuLy88NaJj9KhgdeMtSOIOHxxOk3hOVR++iia3N
	g0gsEu66MdOUIMxIUIow+MrTX23JABryYRLa+JjNb+qB5yXhtOBWsAEY1mvSct3zn1NvMV
	6I1no3lJDX47CCzv2D91xe+xBsmLVOc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PtebkO6fHQqVEN+q6vEw0kJNHvFekDfGiYSLlcOjT4k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788823533; v=1; x=1789428333;
 b=QRMHfJnIOX0wn1+t3ROZQa/neKVPuqoeelwU6jZWwq8bkye/pufy39LaUF03aq9suHIFE+l0
 1Sj2BJ+QrCEM/tqpyVhxe0CYztCpiRTppqjbAMa808+ws7CmvGkcZOKk5vkwmut8iOgfvKRphfw
 SWfeemSixCUKHRdyEi/5BpFI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 096a1c17d24f69cc;
	Mon, 07 Sep 2026 23:25:33 +0000
X-Mizu-Trace-ID: 096a1c17d24f69cc
X-Migadu-Flow: FLOW_OUT
Date: Mon, 7 Sep 2026 16:25:31 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	dev@lankhorst.se, mripard@kernel.org, nat@pixelcluster.dev, tj@kernel.org, 
	mkoutny@suse.com, osalvador@suse.de, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kernel-team@meta.com
Subject: Re: [PATCH v5 5/7] mm/page_counter: introduce an asynchronous drainer
Message-ID: <ap9HiQv7_9cyIe2e@linux.dev>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-6-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163752.2193337-6-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A5433140002
X-Stat-Signature: ntemyct1qedbhy5axrrj1nsggj8rwznw
X-Rspam-User: 
X-HE-Tag: 1788823534-498083
X-HE-Meta: U2FsdGVkX1/Nwbz/osMQT7DsnIRAU2HBkLszLxGFeeVIlkU7LR99JV8mlHp97mh9RrdOqQRxAfJgxYbfGxUtmpuDr2W7uo19vEesaP+z/2FQNVwzlpCWE1Jdzqe/txj0UPguUYvYJv7nBVEPGmveZrtwyYmwT68Mvk2nmhXdQbbbaE6kkTa8/M9ls7+fDB3m6n9ICTlY6WHRujPtGBkGuSiHGD/pA1gPFR4v2eLLTu3LNwpPUEwv1xvyzpBlER8Ohl9fArYMeqhXE4jLCNqPmcv/NYkqC18HusxCvumK06ERXUO3oWbF6aK8+kflSrDeFa0I2zz3+QxrrHZ/VLcXi86aQPlhwhbgPqVJ3OnhY4kfbFQ4NQWQ9rI1YHv69W2tt+dc3ddh18QaxHBTXsgbmXjH5xkX9/aIU+oK33npUUM75+4IiyuLBbnerK6xDKBmM8MhoeBNLqPjVeezN4TCagmktcyuJESWGo5JzkvRNMWMJEGHOTg/LYWExlNrKu+qow/kb+X9EsCp2QrZdhPjFCs21XqSO8cJHkctGhIkTFoxXaWmAjrpzyg6f/XBaRS+Caw1kfIY4Z6C1oBpyn52JgGiMisdY+YMIf5+RJdUt/L7xcrnD4+3E6fAuFPLxAaLT/IgtsIoI13amj+SMpOJVhpCYkZBu7OdIzfW9+XlSndq5FrpHsoDHFCK8bNRL+UHPAAm2hcnvXKv6zEqt+Cueq9NSfZnJFrw2+/MhNNlQIREFXoc6aHyBVYfj9j6vfPKGFI6kXzhiofDZjxiFBi1owNI/NX/fIoMVJJ4SqCw8q9Ii6PxwYQvkS667EnhzgYdg00T9rHhdFNzhRcjI1aCgI2eyTgtRAv3SouP9fp7IKB53UmxQB3PRu2SHorQf2t34BVXq5YrWRO/tLenwpWOhd1xwClkfTRnSsywK87R9irSn91mQPIxAcb6/Ec6KW5KNrLaS2P3SXMeCbBumMG
 TPheEMFZ
 ZmfVTAcwrGrGw8gR66X1F9SCpNKbsIInzb7KjE1DaVQKVgRK+oWVxqb2jigrnv6Gwy3YQyR5106qwb/SBqa5BmaS2YEouG5Aj7mYcbWGJn8ujnWA5vcBfWcIyzIXFDMSdIIjkEIxZmxoSFx5qa8++mUgj1cL40fZJCAeY6pczn+ewQe32bmniIGKT05XlYbYpduiYMfvrMyk9MG25B3Q4XHG2IiM7Ey5th7K8mCd3gYVl+PxZCur5kEzdcC8qwMzaH4AxEPju2QrJJuZXl7HIB6kzbBNsinT79Y7uIqgErTGeelbcZm6Z9hfCBAKhW9XHjVR7NzOlngEEi2bKuX+W3EpZCVPRDyJebX/YXHhx3oRDIsJ49I5vc0FvZpDXrXfP7Yd0qcXCLkLp9MA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 09:37:49AM -0700, Joshua Hahn wrote:
> The existing percpu memcg stock drainer schedules a stock drain worker
> per-cpu, one for every CPU containing the target memcg's stock.

But you are introducing remote draining. Why do you need async drainer at all?
Just always drain synchronously.


