Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B989CCA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C4A6B0088; Thu,  1 Oct 2026 11:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB506B008A; Thu,  1 Oct 2026 11:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11B76B008C; Thu,  1 Oct 2026 11:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84F3A6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:10:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F03CA5D88
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:10:24 +0000 (UTC)
X-FDA: 85274393568.05.DAEE3B5
Received: from mta1.migadu.com (out-32.mta1.migadu.com [95.215.58.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 16C6F40012
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:10:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mpADEyj8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790867422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19fzsCobHrxn+R704cNeeLUdcI8tiMY4kZKgcePTcgE=;
	b=Q/EnDp5XRSi+lmNGwZw602Wd2AOJZ7OE/CCSzGodF0GwkFi/Jc/wcN9rV/tZjXunN35gDU
	Iemg198PJYtpx0SjHAWaD/zlFGjJPZ4/Nw0DSEgwQZY3PtlLBvmv3S4zK4/IJH68DBqtrS
	Enk1Jh5ovDResTw/HQn9yZ7MrlOyFLE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mpADEyj8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.32 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790867422;
	b=nM45aBeRyrzbvAEB4LZCVFRlAHV8WdnjReJbWwdkXTI2ViZjNnwevxA2djBHmvOlutmNGA
	u5NPg5hYoplC+Td7jI94TXfdOQmYlyiathNpNFvIBXyZc1r/y7fZPrG5j6wXinwxzxrrIU
	oEx1kWwiqnn2XkAiEAgjO/znafn5h/s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=L2y3LjuG7/C5nMxsLJdD+ZkujhPKk48juGG0sm2xrlQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790867420; v=1; x=1791472220;
 b=mpADEyj8uQNZVkfjC29GZiKu9JxBNUHoFUXB0DH8b8ZwPIBiiF5EyYwcOAxm6FFVjEZLtNLI
 iBxbtO8Ko1Zs5p1kT5o8XQxp43WKB9YaAXdt4iGdty9D8X/n9blTRcrKf4Mrp0lJmH3CpWnSmA+
 tjuZ1CwRSCiIN8urlLWZzNoo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e5f0bdfb081f1dba;
	Thu, 01 Oct 2026 15:10:12 +0000
X-Mizu-Trace-ID: e5f0bdfb081f1dba
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 5/6] mm/sparse-vmemmap: open-code vmemmap_populate_address()
Date: Thu,  1 Oct 2026 23:10:01 +0800
Message-ID: <20261001151001.20393-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260929053231.66085-6-songmuchun@bytedance.com>
References: <20260929053231.66085-6-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: abw86mopzqu718ymcp8wyijjcjisgwrn
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 16C6F40012
X-HE-Tag: 1790867421-340511
X-HE-Meta: U2FsdGVkX1+w2ysutC4/XnV8HkY4/HY/LtdNhzTpOpY7zj7BuduOhUgxDCPvkP+76q9buTiKAIsJXMrCV1d3uaeDJ4rFijFd699pYw26vZNyjl/auncE02nvcfTipkC78QKw7huoKyssXCHzVHSGo7+vFkzuf9dYXldZ5ehRY0Ce/zrMsY29Fewv7+ITCyjQCJjb3QXliVuWsz4WVL/PkMraGIbn0WqUEaxOOcVTlzW39CcbTTIK/ueoXJqr+frKSihfQ1Lgn+V93U7GVIUpiBlKPJNGaRTbTCqLDsdpaTkl3durxfb2taIQN7QZRDef4U7uYeSILB7252ePdAqwNMoPXftZ0p5Oqe+CzX9ge3Pbll+1yXLVPLDR/K1KDNpR+b2ifur8xgUoPLd/NlSL2LoyLZxYbq7kGHUiTBA2loYLzY7tkZyHsQA4BQXCtFp9NrXk8Fth905gU6BIQlKyP/5rSlUFdE2bVDmzr9oVMRJb/RgSAc0TUw98wIUow97/syYOuvbwy0fObY0QT43RLIOLAWjvEORLWxJdjPPXaHOO5BxiOCjqZDkHR+TVuu8NAHcOIzlkIlENAZXbMyGoxiGj9wQ6132MhUpJgYCK242d9Rt21kMnqO0pE3rdAhR3bJDjsQajmvwwbaBzuXIRvXAaxufSxfa03GQ0W52P+I6EF+WIC/k/xwNESdmVTd+Lv+1LgIRZujNhzsWGMfMb+zjBkxV8QOeQHMSZwi/4mLS03pFEKeLS5E2NiVKntoGeZMXpR760E5BqowpKuX39XjUiW2XOWUUMp62HdNit07GTFA7w3wfKvqrHSJgIj6nahssJUjfwnznSpeYR1mObumoyJ7GR6Y4DIVW70NBz+fd+EOyqNeGl7g62+8syhtHIuYWsAMZ2NxdQP8F0nf9ugnu8vUjvGifSl7QlIqt1RfOxzyLW0vsaKiK5f59AUTSp9EmlrZMNGq7xoMdLV6O
 Ts9SSgZ7
 O7GxeEwhk8uEanvPENOVkNt9RluUJHgy8wEf8AbgOeeAXKoTuTY3zIMHYcHXFn0GIvrwj4NHRLlqQbqmwp2amoAfukACwh9KIVcH0VtMDhgTulr3Zxvw/0Xb/M3kcrYRO5lbmEh7zEArxKe+nek5G5vB5pfxDs9BEQqlBnif8g9PCn0GG8sraZ3mnW5+CXvdpBe7SVnftdXQGd7Nb9CnxVKtprpAjB09Rad4FfRa0eaKnqb+AyFhC80VjiqOCdKOoln0gQgSGCmFMluPtban96Fv53nvJ++PWyIn03EA/9zObZbgbcDBwaNmhwYPRlARqEMTPzzIW9tyBgQ8l5tBvPdT3nbxEs5PgFD0qSENRnvyPdX7WVfMYIA+CG9769zrhksvV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 29, 2026 at 01:32:30PM +0800, Muchun Song wrote:
>vmemmap_populate_address() no longer has any callers that need the
>returned PTE.  Its only remaining user, vmemmap_populate_range(), only
>checks whether population succeeded.
>
>Open-code vmemmap_populate_address() directly in
>vmemmap_populate_basepages(), remove the now-redundant range helper,
>and return -ENOMEM directly on failure.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Acked-by: Qi Zheng <qi.zheng@linux.dev>
>---

Much simpler without the extra wrappers :)

Reviewed-by: Lance Yang <lance.yang@linux.dev>

