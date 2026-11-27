Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1EF606A331
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KrFsNWtn
Received: by kanga.kvack.org (Postfix)
	id E23C16B05B0; Fri, 27 Nov 2026 03:12:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA996B05B6; Fri, 27 Nov 2026 03:12:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37276B05B7; Fri, 27 Nov 2026 03:12:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F0556B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:12:31 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14B16C025B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:12:31 +0000 (UTC)
X-FDA: 85480182102.13.23D5B19
Received: from mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
	by imf31.hostedemail.com (Postfix) with ESMTP id D61F720003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:12:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KrFsNWtn;
	spf=pass (imf31.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=enze.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795767149;
	b=uNnMrIiQi5o/JJnMATenALdmZNSsvH/YtlcyNpto/5T1bJ5YCECk6HkGZJmc0V53CVid7L
	h56+RmgJtyuBjcsYjBg775PxsR7uLMFnz01bkZm5bp92+ImwycfTEdb/1Z6NK6YiG4TzKw
	PtKthrB4KevAbn4em1S1W0sNrwlhKY4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795767149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKKPNPLKpRqOdHZX9CBl2LnHoQAUNh2byiuZ6R/mwr0=;
	b=tYVtMG36VQiV4DyovPUJxnmg8OJrE0niWTzcHPF+slQEcGXZtZXqhknG8op6tt3aYHMQb5
	yW2h3fUvuU2gMDRDvR+KqUOgDXfTYpOt7U19+DanT+JwBY9NTg8Xo+O4NrAgun520VERfr
	FZt3tBrqun3574S/57YJ+8oV7582oNw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KrFsNWtn;
	spf=pass (imf31.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=enze.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bTo0HVCZsJtjo3Aj6QH51oiIvjtPLz4cTFfCiO2IgAc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795767147; v=1; x=1796371947;
 b=KrFsNWtnvbe8g/TlPxajZs7/LLx1UDaX0Mn0hlEw00IDTp8UmUOuydCfX8gpP3UBRcg97lUH
 OreHB+Allxc1cmphz8i6LGqzoK8xSHY+ATIdalmfLQuq+tSN4jjgmvOH0kppIU8sXOjPWbSRxRI
 bAueUvlKxq5Uhk+7eA9eXB08=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a467588598b3f257;
	Fri, 27 Nov 2026 08:12:27 +0000
X-Mizu-Trace-ID: a467588598b3f257
X-Migadu-Flow: FLOW_OUT
Message-ID: <dc1c8f12-76c9-4866-9217-a2a1b5d25a9e@linux.dev>
Date: Fri, 27 Nov 2026 16:12:23 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/27] mm/damon/core: introduce damon_report_exist()
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-14-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-14-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: D61F720003
X-Stat-Signature: oaccgatukx3aatpognpxiu6ifuh1os48
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795767148-47039
X-HE-Meta: U2FsdGVkX1+FZyRw/LS18KFIZE2/cHkiUz9x5ky0SxBwoeBEtWvW17g6kl0H6leYjAysR8x0MwuogoGVJ4+jnH1MQ0ZW/IYmSoPIT9hAirtSxJMW4CKKbCyai+YCJuwzdAGWFh2dyRvOfKcOjhCZaIQD7WGU/tp4F1DSD8F4s/npPz0NqEa0Z/UjDueM2XMgQHnHRv3zScG/rDKBUEkSXsE3FM0wZsw8BU4dczRiEt5lPo00mBzsVrsInjRhVF/VnR22G1F4H+O90vxlCSplxIn+V6sKB4U1bS/xG+R1dZKq9SstphI6jX+kMbxYEt9uM8rgb1bdpGk9eO/KtHnpR0USK5/5DunmqkoyV6h/+oTGvYrN+m6nsbT2zlirMJVOeP7mFLqzT8K051Z31uE2zDGbcqX/mvEMh/HRa5ex0+OaAgrfnbm60jdnFl2sBE5PMxwKHGpvtmnjq47AWk13Xf+c3cwajVC/cB7XbJM3XZvt2Gm3/FY/86tF78iluRT8AhwfH+Jc7uMunpSxlvg3tjQ/R5DA9ei1eN18OoRgvgeTL1wWawVqKa5Vr4Xywuimow9SqPyXEPScucidAsuSxEsoL6P5I4PHOGyvuvaBrnB9dOuMLMCwx1kRJdQzYTTu3lum0jKAwdPN2Txkj946kqtlxiP+5YFPPFv2tNw1+XgQ8rcexa96r+Y7VQ/MIOlF2dxUDWqa/pNr+YecGUDG9HAxhKbQluxr6VoWXISO/aJpJ+9S+1h1SrVcQ6Qgdh6VUVLCxc24kzfsnpyWJqHfbhtoTg89GfPfinmMvaJdCxY+KRbpghUIZeGqhMsnYsrVZSUepEUgkcqWhBLv3prMXEs/ho1Ah8Ijtp6mPAKWbzOpWq4hjLwhqxViCRAEB6EBiK27uNDiQ2/0jWx38MP74X9DrFgV0vznpWxDj+gdZ9BPuYNTnl1OxuL1L3cM3jjxOK/OzhQ9w0iYNimj7/s
 0JzL+xTF
 5/t4sXl4NEMQzvCWjUIBAlhdYnEJppnEIN/Ok1rmkyhboSLnEnIV6CBLyGrrwQzbXTGSAG5rn4e9tj8Uv/SngAUnxfIiOJlQ512yr9HdKXl59P/CIoXyECz8K8gzq0Hcwz+Gc11pHdwLrs5ocLaLukNZUGVAtNBrAa/POsa3MMxAhX+y0f5AqAG3k33O1J9sKe5Vb27KVyhMk1Dx7o3oToX4Ip81+vxDl05OkM+ZAX5jW20u7nUiQeXctn8wW3MsoXnbYuoZE+Gm2S7CzCHgqxz7sZHHfy+w82R8t1CCioMu52uC69HcHlnMH3auxhPQlC9BnLDsn8oGejSmE8LEA0Z2bqGJ49tVt86d1khtj4Gkdkp9rKZHZXEMgl9N+oStkyZGEHsiYs8mFAvpwHswIi+JxuaoB/O6OMfLBiqhXi4czXG7dNjVMIcvESlkxzwq2j11WPb5oqzN1VTE2yT5n2Bk+707tZdUw8N5aptBf4bBcURi5oolgp4hWotsEAknyNKQTNNCyhnFghAmTGYj33QZEatsm85+7LlPpPHeR/gFaVFeVNtTGl4UJbdS7KJC43V4e3dFajgvtT/AeV7CIilVnSHYRdCeSbGCA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Implement and expose a new DAMON API function for searching data
> attribute reports from the report queue.  The purpose is to let
> operation sets use it for supporting the REPORT_MADE type probe filters.
> 
> The caller can specify the type, associated memory address range, and
> the creation time range of reports to search.
> 
> The function uses CAS-based try-locking for the mutual-exclusive
> synchronization.  If any parallel access to the queue is detected, it
> forgives searching.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

LGTM, thank you.

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

