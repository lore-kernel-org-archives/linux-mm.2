Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2625F606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 04:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=h2NarzBu
Received: by kanga.kvack.org (Postfix)
	id 444586B05B3; Thu,  5 Nov 2026 23:38:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6936B05B4; Thu,  5 Nov 2026 23:38:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26FC16B05B5; Thu,  5 Nov 2026 23:38:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 01D246B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 23:38:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 880571A0CF8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:38:18 +0000 (UTC)
X-FDA: 85403437476.28.40BFA9B
Received: from mta1.migadu.com (out-116.mta1.migadu.com [95.215.58.116])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8075C20003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 04:38:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h2NarzBu;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.116 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793939896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Yx3i1zeQ5pe4eBI/JzCvDsEdxLLepzecCOmB7O2Y5Q=;
	b=L3mut0haQPtS/0b6t/PEQTxJFLGKRqqgabRaw7R1pyBGhtWVgUrzmBI7uiJSj7IWCYuhDD
	CK0BHk7yLfSI/L/Hd57FnYB6ucaSmUl1DTGudsrNKwEQkClp+jBY+TE2pJQrvjNS40rXPz
	rn3iyY9WTXp64cFTqnYHIMInMm1vq7g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793939896;
	b=nCv6o3fYpeIb79deojULdu5whGtjDtni80rC3gXbveE+Uod3abbGd7Rry35F/hz+RBMyC9
	ALOu8jcIkra+J73Lk7ui6cESdaebCBCGDwKRVslSqyj9JxO0wVlj4JhXdA2RJIIXri2z0O
	rCfZS58/drnrY0wh9FcPe5qJ/sE4O94=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h2NarzBu;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.116 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/Yx3i1zeQ5pe4eBI/JzCvDsEdxLLepzecCOmB7O2Y5Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793939893; v=1; x=1794544693;
 b=h2NarzBu5wSfv3HGLjDaliK2QJozxMk1T8AWSAyQrfXgHTDTPCv+ZGuVrnREakda/ZEx8QA1
 8oHdr4LZFwNJAxqLIVYaUXa8CPvRrYRT1iKnDBFCbx5htEVpTCoeBhb92BY4AQ1xCcuyadvcBnR
 1nSZlm5DlYnhXsdFYvkrWORw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9188c1b74d12ac2b;
	Fri, 06 Nov 2026 04:38:13 +0000
X-Mizu-Trace-ID: 9188c1b74d12ac2b
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: david@kernel.org,
	maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	lance.yang@linux.dev,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	osalvador@suse.de,
	qi.zheng@linux.dev,
	muchun.song@linux.dev,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 1/5] powerpc/mm: make vmemmap_populate_compound_pages() static
Date: Fri,  6 Nov 2026 12:38:07 +0800
Message-ID: <20261106043807.32969-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105061217.13302-2-songmuchun@bytedance.com>
References: <20261105061217.13302-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8075C20003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hekn31uykbywbhz1s59owhts5qs7dqrh
X-Rspam-User: 
X-HE-Tag: 1793939896-623708
X-HE-Meta: U2FsdGVkX1+Vdm6Q0rU0FoVrUDWgGpTp2dIwlOaVZl1HeYHACcu+rT1wQwsiIkod7CfmPwkK7gN+zJ7hDMdHzgjiCCqFGHNp3qsxOjwWjowBs+Tndi/LF4U5P0ZLjjsiqGZZcmVsfpHxZhRl8W0tlaqogjZ8RMGzFKxa9OlXSyP3+9YJLHiDdf1GcxVoNJtClS7OLZm+qPjF/MOg1tXjvk+pQzseaRcya/Eb53G2ld6wydvdvBGJ9RM4uIhQ/w6H3yZ8h9Zc/KAVr601OIsA57NAo1Tpjncce59nqt6WlbAOzw1U6wRmP1MLiTRVNuJ6yoRchgU/FJ85KdduEMgfjAKCph4GpyD9iEf9EdO4aEEaT7NuVKcJQYr0k8nYNikOkA5XEFNszz2j2q+avyTD0WYQV5FArMlR0v9AGspQ+muj2UKZ1yy/wBZb6CLKRVgC1Lz3wjmIc6+ewzA4fvUqfIIdElNWm++mlnzaKVexl5+VN9t0ULl+BBy7ISMtgMdiXvFxKrO6Q0dBHd6TxcYTmGzniwauS7UqguEkpXv2Z52JS5Vh/2kVFD6swC9LiAEDYsvr4Ga/hbvxzDyg0BUGdKpuLLfthHGspxgOfs5vaNH180ZaFGG8iuCWerb6Fku8e4AYHa/Mo9Ch8Y+ZJ6uPGaPnWJiwQmTkSgenEClxd8w0GRAjad14EzPQ9N7okRZw5XbK/Ude9lUODliSSpTBxkkPnTsBCZOGBohNW+p/lJ+CFqXXAD6P0ODd7ef3L68BhJZ4KU1RY8A86jkCr3OXz9lbMT5Nz3aCH1OoMytjsQUBEpOG3AufHP5KIGqKdWRZhHSqvzApHh9BCV8CtlmrubvYCGEOMkxEuORJoY9opJfbkR2j0gBZneZk9jxIAX6RTyDahgYX52UiHKcsKQj9aD6Mq9xTHrqSVSGGW6HR5hbCRehq0lFl7CkokBZSci/9jy1HLk1oETqq0ISjP4J
 oMM2+AaL
 uezyCO3qlvU/3/IGSNEZaYj4I3mpwDPQx6RbrVxXOh85TWucPvSeJBXVfxWvUODslbKTj3rkmQaAgyQ9NgcBD4fgaLLZOMVeV3VtKmyghRvDyiBe9jNR5pwTY0yWEITbWm4M2WDRql/zTImSRng80PfzE8jkwpuoz3XiOrcCDuprWCgAI0DeWc8C1Ek/BsYi2l/P+HH+BDU7V2M8nYqpdLAh865FmT3cNv/YwwBH9yKpO7/BgifjzITwyC4D9AH5/qNNkgWoWTj9LdezPNA2nw2bAZPinJTnZEBKPBwSIKA96yuk31XPEmDmvB4Qf0UVjSLYIlJT3IV9PcwvKYYfsNgSz5fmtxcGsXrMNOUTzDe2AEr/eq0yB0mMDMnJvfrV9abn7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 02:12:13PM +0800, Muchun Song wrote:
>vmemmap_populate_compound_pages() is no longer used outside
>radix_pgtable.c.
>
>Make it static and drop the unused dev_pagemap argument from
>its only remaining caller to simplify the code.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Acked-by: Qi Zheng <qi.zheng@linux.dev>
>---

Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

