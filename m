Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18194606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 04:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ME/E9smf
Received: by kanga.kvack.org (Postfix)
	id E18156B00EF; Sat, 31 Oct 2026 00:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8996B05B1; Sat, 31 Oct 2026 00:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8406B05B2; Sat, 31 Oct 2026 00:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6C256B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:01:30 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0DE788086D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:01:30 +0000 (UTC)
X-FDA: 85381571940.30.7DE3010
Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	by imf05.hostedemail.com (Postfix) with ESMTP id D6EAA10000D
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:01:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ME/E9smf";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.12 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793419288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVfa0gIfJ0mFFHTR1txtm9nrtHNlGhjBAfd3nh/ZFDo=;
	b=NOiuaayHFnqr53w0Ti6bgRz/0a1qz/etlIN/lTCXkrQ2mBk6HMAk/g+ZARhD9QRDrwBOyH
	0yg9H3IRlMQ2XHFMFfiMyo54JpgLp+5o8GSVIT8bXw7x/eJi3yR41TYqoSO1LLKDvKPABE
	Z7c3XjCTrO2N3ABN6CSbudhC9lr604k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ME/E9smf";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.12 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793419288;
	b=1fe8DFGmEna7JxCK+5Di9Ax+ZOqKltckwbtiED7zVloyhhkCO0wVy6LV72pSwDZg0cs0Mm
	WLLJCPdJma33vVu6CZ02zCxm9PceGswKiIGlKCHSM+I5+u6eJopwhzcSzZ6Rpimx8icQkQ
	gitqzbuFNUEyqkupKXP4NGmV6xGqu6A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XfEaAPgAHtnFtcCOsY1hz9YOxl0K/jzQz3+QJgV86BY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793419284; v=1; x=1794024084;
 b=ME/E9smfnqc3VhfPxpLpOIMFEZ9+HuzSrewiJmPQlI/Mrf7qI/IwjcHzcYxyHGXpBrMAHrgM
 lgOmzHNlCudQtntnDt/THr+8520JTCwJKoHS72MUnMoE5OATYa0fc/rbCKUtwx0PJlfl3LdhlVK
 UJUZTLll9FYApsN7tQwHcWls=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 31186c4904888d22;
	Sat, 31 Oct 2026 04:01:23 +0000
X-Mizu-Trace-ID: 31186c4904888d22
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	ziy@nvidia.com
Cc: apopple@nvidia.com,
	akpm@linux-foundation.org,
	aneesh.kumar@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	brendan.jackman@linux.dev,
	byungchul@sk.com,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	cl@gentwo.org,
	david@fromorbit.com,
	rientjes@google.com,
	dennis@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hao.li@linux.dev,
	harry@kernel.org,
	hughd@google.com,
	jannh@google.com,
	hannes@cmpxchg.org,
	jhubbard@nvidia.com,
	joshua.hahnjy@gmail.com,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	linmiaohe@huawei.com,
	mhocko@kernel.org,
	rppt@kernel.org,
	muchun.song@linux.dev,
	nao.horiguchi@gmail.com,
	nphamcs@gmail.com,
	npiggin@gmail.com,
	nico.pache@linux.dev,
	osalvador@suse.de,
	pfalcato@suse.de,
	peterx@redhat.com,
	peterz@infradead.org,
	qi.zheng@linux.dev,
	rakie.kim@sk.com,
	riel@surriel.com,
	roman.gushchin@linux.dev,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	tj@kernel.org,
	urezki@gmail.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	will@kernel.org,
	xu.xin@linux.dev,
	ying.huang@linux.alibaba.com,
	youngjun.park@lge.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/7] MAINTAINERS: add Zi Yan as co-maintainer for MEMORY MANAGEMENT - THP
Date: Sat, 31 Oct 2026 12:01:18 +0800
Message-ID: <20261031040118.53610-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
References: <20261030-maintainers-v1-3-97278f8a5f54@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D6EAA10000D
X-Stat-Signature: 1g3q6oa74zoq69gqsrzepysqj8cgr7nd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793419287-858173
X-HE-Meta: U2FsdGVkX18STeypvNXU+rhSmQhQ86HWhON2IKA7cv8NpqRQZkOEQpUa/yGqdgFagtfqhJ0DzBXuF7WhnuZUIlUwbnkBqg36DY6jQuc2OCXAFTdrysVJ7dQrYSMxNN5ZYE3n2EBJp55rhco0sigNtGcZZjFfLgU/CDYZl2RCbRpLomvdgm2eq0rHzi9Ah1Yz8gQ4ktIXTrXjxOjeA5+IykB/falcbKSIIc38zN1ccKo3SHXoJijlow9SW74aD5BPX71kROkywW0gA8HqCmuYCxdy6M7NVcWcCyrZ1TnD2P5aEgA+cmVeH55MWucToxeT/fjHpQHQgSNKd4OkN3rk/RpkrBr++bGWrS9vWAxdxGcxvbZHnpD0/j6q+aNO6alFCmk5VCm+6YpjV4knZkqyZ4F0r1gsmBF8FOOjHaPoNy5cjE/N6+tvCbou2U5Ez7wLY9KhzYnrf/nJSH9WEDucb5vCAlU4ueWTRCOZQmCA7WFEgVHZfdKSN1rdBq1XVQoObBWmeyRqLUePsIQQFncPFSvf89Mi+y2YH5iP8TmiDfAKIJKzVg7mNcoNtnZGpZODI8+hzt1p7fcujCnHIf0hB5t5fjXbQvjwQFK6FMOn9ooBNbd+6pNQ1GuPgsj8GCny8Qvhw33Gg/e/ZXX/Tn3x+aGnPayREu3zDrUOV9moAMssbOxGIO+VOBIrzWewnl2cGYURbt436++G1CFp3jp3/F9udAuqO1Spts4yCSQgzxZipmxqeNvJEk7OvbK/BKUGLC6lklqPAL99PKADUIvLHed7aO6aRv1gf2pqW++Md+AqQUwQx+yPHsHLus5MXzU4q9Xysirv6AOwS74vZvQEwDFI7zWZBlUzQkW06tBS4Kki+vQQ0v1MXL9I5M8q8+k8YrqpPoJyM7bLkzNQoBR2Or/TlYeHWv+FUbaeuNcjEOoAUxccQePv9a/i19mjGBHUE9+e1IyoR6rZpDIWGGg
 GpK0x6c6
 6T9ErnRVauU3YDEE+EfCa79pmJcJbVzLbYmE8RWZm3oS/d6Fj6B8X75QsqinGfHf9bh1MIcHrUTUQLFLNECT8dW0acwu24AjSLjYPWFhUX1ekUnlx+Jh/a1QpBxP19M4mXc1Z1xSFJCXhNhpmN/QbfhZKf8DMu46muuk2qq8dlnZ3PePukcBqQ0+reAF4D4LzJtpOFiLjn0GkCcuQSdPpZ/hxG2/ua6D0imbzr1BZe8tYuslr+WFMujZhxMIrIP17uuEuihXp78vhaK6f+PTih3ZYCMxbzUP5VKb1X74k1SPuUZgMwi7qFsg7P6P72SNHZfjEu627lo+g+nOgIMgCPIlQnAd9DmiH9Ta5uGwKHv6ql4TO/+JOkcXzMhNM73UvPbgFFP+B0AykKe9lpYFjpYHVt+LsuqTgiRW4C5/FiWTxRwqBFcLvqK7YUy7cY7+1PwxnL+pVQVpe8BkexAzs3Yz+9qU+dvHnbcd9HVkS4QdecDli41eQOfU0oQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Oct 30, 2026 at 10:34:27PM +0100, David Hildenbrand (Arm) wrote:
>Zi has been contributing to THP consistently and reliably over many
>years and is considered one of our most valuable THP experts. As THP is
>an especially active area lately, having a single dedicated THP maintainer
>is not sustainable.
>
>Fortunately, Zi volunteered to take on more responsibility by stepping
>up as a THP co-maintainer. So let's do exactly that.

Nice one!

Couldn't think of a better candidate to step up as co-maintainer.

>His placement in the MAINTAINERS entry is very convenient to perform
>this change :)
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> MAINTAINERS | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index 0baeb37b0dcdc..02b5b542f81ee 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -17817,7 +17817,7 @@ F:	mm/swapfile.c
> MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
> M:	Andrew Morton <akpm@linux-foundation.org>
> M:	David Hildenbrand <david@kernel.org>
>-R:	Zi Yan <ziy@nvidia.com>
>+M:	Zi Yan <ziy@nvidia.com>

Long haul, hard work, never quit. Fully deserved.

Acked-by: Lance Yang <lance.yang@linux.dev>

> R:	Baolin Wang <baolin.wang@linux.alibaba.com>
> R:	Liam R. Howlett <liam@infradead.org>
> R:	Nico Pache <nico.pache@linux.dev>
>
>-- 
>2.43.0
>
>

