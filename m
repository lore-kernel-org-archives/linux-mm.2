Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96554D3CC8A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 07:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E661C6B0088; Thu, 15 Jan 2026 02:34:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13BA6B0089; Thu, 15 Jan 2026 02:34:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D12EC6B008A; Thu, 15 Jan 2026 02:34:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE8816B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:34:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7114B1AF6A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:34:34 +0000 (UTC)
X-FDA: 84333385668.04.425A500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf07.hostedemail.com (Postfix) with ESMTP id E6A1140005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:34:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of yang.yang29@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=yang.yang29@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768462471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=ouswLoMRHwrdqIO4vVsUUcvYO4uLCICCwY2Q/c0HtX8=;
	b=NBNiEJulVB0e5uyG7JLHFvGB/69IVkKRWeGq12pW7EBeTia0Txgig/YbjDY8Rwx4dVA05X
	tnZyCHxzfJzJHIYYln/NCrBN2a+iit6pR5J9ny+wAtgRE0E40WFctwAuwNZicnjE1i85/b
	MGDHIwevA/8r2a3ViDiyOcj9jjkGPqo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of yang.yang29@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=yang.yang29@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768462471; a=rsa-sha256;
	cv=none;
	b=GLHTNUSSX/40JOMzpNgRd8Vid63snFhR6aBPok36W1UDXW+Khr/OTgKWn6ARizb+A9GqEE
	GwKXadzjPk0mvVIdIvc1PMev3O4gPc25vIBL2Hugpmk+u1tDSMKSqnHnlQgqQIc9O6cyDS
	DI2TjX/28RQo/wrZls4BcLUa/fMY1Ok=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4dsF9Z2LpVz8Xs79;
	Thu, 15 Jan 2026 15:34:26 +0800 (CST)
Received: from szxl2zmapp05.zte.com.cn ([10.1.32.37])
	by mse-fl1.zte.com.cn with SMTP id 60F7YBkC091884;
	Thu, 15 Jan 2026 15:34:11 +0800 (+08)
	(envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxl2zmapp07[null])
	by mapi (Zmail) with MAPI id mid14;
	Thu, 15 Jan 2026 15:34:13 +0800 (CST)
X-Zmail-TransId: 2b09696898758d7-1afe3
X-Mailer: Zmail v1.0
Message-ID: <20260115153413416ZHFvu9Uuv-HbyU9UKguyW@zte.com.cn>
Date: Thu, 15 Jan 2026 15:34:13 +0800 (CST)
Mime-Version: 1.0
From: <yang.yang29@zte.com.cn>
To: <xu.xin16@zte.com.cn>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAyLzJdIGtzbTogT3B0aW1pemUgcm1hcF93YWxrX2tzbSBieSBwYXNzaW5nIGEgc3VpdGFibGUgYWRkcmVzc8KgwqByYW5nZQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 60F7YBkC091884
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: yang.yang29@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Thu, 15 Jan 2026 15:34:26 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69689882.000/4dsF9Z2LpVz8Xs79
X-Rspamd-Queue-Id: E6A1140005
X-Stat-Signature: axyfkipzh8ngyp3jb1ea9reqaf3mowwa
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768462470-405421
X-HE-Meta: U2FsdGVkX19J+I6hPWLLb/K35Ufg8Hkf47z1G1Fj8Vx44ENnGwihiDJMVf62bwUOvAvcxSvgLcvubbMJ8mgOMhxH8Ud0AcsIbkiAYTgfVL9ENimoBY2PS9FuCfTZznihpJSQAKRS2Xjrv0m3PflDX2ETzhB82Nl8CPGtoUXIOwZ4lXXODwwjMFiZKCfw1omwRpoOkKR6XxKTtb9f5YBF3Ie0uCAcqu8BbfZgHqaQCr1qbLxtvtTLT+I1g0hNGGEsxmTetYOxJefZI/JmkHSIAoyvFCQAvQWP/cLxZFwMXUlJGqj0/nmA7twEfDRbpeUT3lC8EtiIHN83Eoh+/9kJYU6wPLTau21uUM2qRRmcXoAzxwxhlNU8+9QNaS/3M6/XmbnlQWYjZTATeHC/Y/OzF7+v7ne9VNyscKp/qA3cV/QJsgn1wF6dYp6woRTx8gUkT/ZeUdL+UshJ8g41qdfI2kS04ssC/Ou1IWWWJbEavvUechslA2cHS5Yg98VHUXOmENjH2vX5klBVSz2XUfwnkS3q3P4HRbJ8McXTStAVW5wXofZpphbdE+E4LFvYPlTCMBV6r704zDox42NtJ1ito1ZckMIWW6uhcvBcjXr5GvtACF3oLv4n4NR7ROXwQNBv9MOEsJKiNBoOdy8MjkyRbLtLE9jJCtmB1CWbgaW436pkLxJF/wGJvBuIVGfZf2qSzcSkG1wHUjplOM003B/f0nDadtM/eGdClYy3qWN8AztuN4EUVKju4Bx6j/VQ+QXcasBboknwxviZ0hbHohmj0gWqakFAq7cqUtU9DI/7WPbhPEHmiDYOJqKdGGyV27feqqIcVTuUN4Ffir33O8gpewhzku8BzeBTdw1a1SwYhne9sQwP7BaiYYjNKs84IBR73ua//Pq+oY9Rf/h2VBxwXs3hKkLlZ6AFaF4S4zL+yPuelp8XOFmRrWJ1NvPi1cEuqPWgC2ij7wuYvVmub1V
 2luZHHyH
 BhMbnCrH6k65wrHHKp96vVA92hBzXQVTVd9jZg5odiTrkPnpe6eEks+0GfIcJoW0FXE4zvhnDR+fu+mUvjy7Fj2cjCHPZkMMiWB5U4lDImfGaWaG2RPfyt0XyzUH+Je0vbkU+7F59PJN8vzcfbIpQ7yRvB3d8eBMC+Kg82/A+J8tAbZU0bp6wDvqAIBdzaH499GCK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000008, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> + pgoff_start = rmap_item->address >> PAGE_SHIFT;
> + pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
> +
> anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> - 0, ULONG_MAX) {
> + pgoff_start, pgoff_end) {

Good job.
I see there is another similar situations in collect_procs_ksm().
We can simulate memory errors by calling the memory_failure().

