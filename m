Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1D3606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 02:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160986B05B1; Thu, 26 Nov 2026 21:31:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138616B05B2; Thu, 26 Nov 2026 21:31:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0777F6B05B3; Thu, 26 Nov 2026 21:31:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D46246B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:31:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4378F8013E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:31:27 +0000 (UTC)
X-FDA: 85479322614.13.63B4E17
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	by imf17.hostedemail.com (Postfix) with ESMTP id C27BE40007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 02:31:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of jonaszhou-oc@zhaoxin.com designates 210.0.225.12 as permitted sender) smtp.mailfrom=jonaszhou-oc@zhaoxin.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795746685;
	b=t78CIEPb09Mr+AfSn46adbkIEZNUKSYvonskIesuvs8X6AYNhgsb/xfrOxn9gL1+JEQ70w
	o0lgCCKi52Evr5XoVUNB7kfwMkTuoDxFdtxtiFfQ/dTkJdpRAyVps5x2AcTo7YR7vMnWUR
	gtR72VD2iRjXtV5xy9yz5Qvkw6crrVQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795746685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dA87UcbQhmaj2fqLijX+wxuez2/12e/CLRHVZbI7N7w=;
	b=IofvYtygzCPFrjvcHDkFCPCNpktyoYpBgp9BBfUTmYLaXjJ2KQPMuKw5gkuUd/AiCDpg+F
	LQa2FH1q5ugKvPLRAsd7ZMHSrVD4ya2B5UJ7WGyRodXDMeBMPd6xYtwNG2BD4ajP7PnXP+
	13JXeWhKzZOUJyVjZTqijYP0eEofQec=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of jonaszhou-oc@zhaoxin.com designates 210.0.225.12 as permitted sender) smtp.mailfrom=jonaszhou-oc@zhaoxin.com;
	dmarc=none
Received: from zhaoxin.com (unknown [127.0.0.1])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4jbHTw60QbzbKS9L;
	Fri, 27 Nov 2026 10:31:16 +0800 (CST)
Received: from zhaoxin.com (unknown [10.28.140.201])
	by mx1.zhaoxin.com (MTA) with ESMTP id 4jbHTt5PwvzbKS9L;
	Fri, 27 Nov 2026 10:31:14 +0800 (CST)
Received: from zjh-os.zhaoxin.com (zjh-os.zhaoxin.com [10.28.44.129])
	by zhaoxin.com (8.30) with ESMTP4db20fd4ad44ca33462eecd045475130
	Fri, 27 Nov 2026 10:31:15 +0800
X-Eyou-Smtpauth: jonaszhou-oc@zhaoxin.com
X-Eyou-EnvelopeSender: jonaszhou-oc@zhaoxin.com
X-Eyou-From: jonaszhou-oc@zhaoxin.com
From: "=?UTF-8?B?Sm9uYXNaaG91LW9j?=" <jonaszhou-oc@zhaoxin.com>
To: anshuman.khandual@arm.com
Cc: jonaszhou-oc@zhaoxin.com,
	akpm@linux-foundation.org,
	urezki@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	jianhuizzzzz@gmail.com
Subject: Re: [PATCH] mm/vmalloc: avoid false sharing with drain_vmap_work
Date: Fri, 27 Nov 2026 10:31:03 +0800
Message-ID: <20261127023103.1833448-1-jonaszhou-oc@zhaoxin.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <gdy3cvqeppwda5zydfl3cq37gmihrbizbnio5bnandkl2brnt4@vw5s5wcbejoq>
References: <20260825104659.100134-1-jonaszhou-oc@zhaoxin.com> <gdy3cvqeppwda5zydfl3cq37gmihrbizbnio5bnandkl2brnt4@vw5s5wcbejoq>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-Eyou-Sender: <jonaszhou-oc@zhaoxin.com>
X-Rspam-User:
X-Rspamd-Queue-Id: C27BE40007
X-Stat-Signature: xkysxoept6dw73k9qfjxbfwg9mju57ry
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795746684-176117
X-HE-Meta: U2FsdGVkX19jXouYwXaaktrh0APtFEIj24YEZ0aB509opHDQ9Voz6T1Whaw0S/nTcwR31+TxutGkCPVx/Qfi0HDF9SK7nhXIcbztnIyCMmTTPoEWYs7Njf/lq9PFSMmbFXI9NXWgiGaSt0Xmzac8yOomF9/xshIL5zSbb2UuMhTY4L5FFWXIkbQLpYCsdalJRgOzoCPgxS6hUFgZDXLuVD55RfnBTrITbaJc2+aRJlId6BzlTim1COYIaYp5f9lJKfLu21H1Zlpa8nOJ5UVOl+dVNDNCPnQAkwE9egwsma51S0aSAYao8g+9BRbrB+gdOVkR3X3Vn1xqfpAnNFEATF+id+bclNrDAay3cfyG2G7sXxoKBQfKi/pe3IWwwPQdTrfIJgsI+WjfGlDr/5UpbV6ss6RyFHru4eMWGwjjxbTjBYnNAl75GUU3mRqOjn6z9bkanHWnKhKeSZPOlHmuMVzJhQtLQmHdwzcQbt3vB5HsQXebBFO2QccYQd6wlufWInajEtlzug7bYtPCnzoy6934yexDyB/4GkzzlkxcqByxCoaQVszDjo3sem2xQHZDcsWQS47n3QWBQExoxjpWsFpKlmzd+g0eL0ox0EO5rbyxmTgbNBqNzERyakW/tT/j6XrnPBiTgr/8QWQVffLNm4wjSCCST/IXvo/fuQW+moIL4XXQvfFXKAQowBUMr4IxBAROAwh76m5nIaPAK6xKTu2Lzlr90nRrbRPWxdy53W/Z5c+J0CdbBpEPn9SJ53I2IRsabcFNGVrGZechlPZuWmJWDH16UYfooXzwAQkekO9HYX/TwDae/uxsWCtcmv1TEWoqnOwi7tX/BJrdmBcAXH1/wwe76i176GBT576znzxu1grjizHsyo0+isHCVkmgzojfbwXkOLmvFmEGa/BCNSsqPEsiFN1kKHi43HEDqKVLOJrejgyR7r5CaLUYBl0ILULdPdKi0dHEZmvBBKJ
 2VaZYepO
 7gIq5NBNxzztNcRx8kzUsHXAahf0q0+QNZg5kAMgeaw1/uOJfrUBBQ791tIseiOSOGpX9rVaSyLfvadoO0c+5VWgMLePVseI1zegIKMZiDUog/tlu3006jtSFT7V35SuiKaWbkyTd4XJ6pqba+5PMhDAqRozLw0Pc1A++viHosMrNCSh4g/fr7fg/Fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Should the test be performed again on latest RC kernel ?

Yes. I retested on v7.4-rc4 (b6a9fa34ce41) on the same dual-socket
Xeon Silver 4208. In the unpatched x86-64 builds I tested, GCC placed
the two variables next to each other, with 32-byte alignment for
drain_vmap_work and 8-byte alignment for the vmap_nodes pointer.
Whether they share a 64-byte cache line depends on the kernel config.
After I set CONFIG_RSEQ=n, drain_vmap_work and vmap_nodes shared the
same cache line.

With 16 workers, SMT off and the CPUs fixed at 2.0 GHz, the mean
worker times over 10 runs were:

  test                  unpatched    patched    reduction
  fix_align_alloc_test    6.129 s    5.365 s       12.47%
  fix_size_alloc_test     4.836 s    3.850 s       20.39%
  no_block_alloc_test     4.840 s    3.882 s       19.79%

> s/away/cacheline away/ instead ?

Agreed. I'd make the cache-line separation and the reason for it
explicit in the comment:

  /*
   * Keep drain_vmap_work and vmap_nodes on separate cache lines.
   * CPUs queuing the work write its pending bit, while CPUs allocating
   * or freeing vmap areas read vmap_nodes.
   */


