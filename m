Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F268CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28C56B0095; Thu, 14 May 2026 05:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDCD46B0096; Thu, 14 May 2026 05:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8636B0098; Thu, 14 May 2026 05:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B8DB56B0095
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:27:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 682831A025E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:27:29 +0000 (UTC)
X-FDA: 84765497418.07.636A5B1
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 75C8F160004
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:27:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XC3x8tu9;
	spf=pass (imf08.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778750847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f1z6Ptp6JO7QpTlrnbVxjJzSMQUUI/Zv45K/tjblfUI=;
	b=f6eF1x5sXhn79mnYJypszDnHq46Dp4sOQFkTIYCndQgB0WMuOcturQ/4B/7NsjOIjFU9V4
	MgeUb1BRuRCaygg9YhJpynchmCzix/azvyfNQxncz+AF5ra50cI82vUosNkkCTOfI/9Q9Y
	HZcG+H8ai3B18YotBZ309uhevfsXIR8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778750847; a=rsa-sha256;
	cv=none;
	b=W3cbNOM4Zkui2Rti6G0YmlObgroohue0T+MOjiG7la6EK8pXUgfjWOiYH03OfG2quROpkv
	Ii4h7TlvEpFHWyNqPyz5AlehZFMhyaZuQ3GvZ8DhS2p7FiShEFZoJZjdDlrrZiXT/g2t5/
	89DGkrJuu8x2L20IIrdqCJC2BYjcXhM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=XC3x8tu9;
	spf=pass (imf08.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=f1
	z6Ptp6JO7QpTlrnbVxjJzSMQUUI/Zv45K/tjblfUI=; b=XC3x8tu9vBeH6Gg6AS
	y7Lcz40YD2KVXhZw2AZRNt2U2G+mvHBRf90QiZMFk1Oq897xnJpa7MQCgqJPIquk
	f385IYdLmQ9D7uMq+iiUKImED9OgXj2MtBxpAPcZeNwdSCefmmdbz4f3SFiUpMvD
	JyZDP/bsPrn+Fh/EowiLrxbS4=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCXmzdPlQVqpNpCBQ--.10930S2;
	Thu, 14 May 2026 17:26:40 +0800 (CST)
From: ranxiaokai627@163.com
To: leitao@debian.org
Cc: akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: Re: [PATCH v2 1/2] mm: huge_memory: refactor thpsize_shmem_enabled_store() with sysfs_match_string()
Date: Thu, 14 May 2026 09:26:39 +0000
Message-ID: <20260514092639.52043-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <agWIbTDCoLYmuszC@gmail.com>
References: <agWIbTDCoLYmuszC@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCXmzdPlQVqpNpCBQ--.10930S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JryrAFW5JrWrZFyfZr17Awb_yoWktrX_X3
	y0vF42vrs8JF4kJan5trW8XrW5CrWDJayqqr1xXFnFya4ftanrAFsxX39Iva1SqrW2krZr
	GF1FvryYq347GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7VUbE4EPUUUUU==
X-Originating-IP: [117.176.243.1]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7hBVoWoFlVBdJwAA3a
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 75C8F160004
X-Rspam-User: 
X-Stat-Signature: 6yh9mh33uxqjk3jhkbkeoofo39szrwe1
X-HE-Tag: 1778750846-178650
X-HE-Meta: U2FsdGVkX19IX1rG8iwKftouK47wtwCL59cra4LrH1z2tCngE0RWlFUyFhPmf8yyQLdYQq6uHBd90wzoad0m6EE8jrZA5JFP9xsqvEAMfGWkCvm4PH0IVxt6V+/6hmEHYs271if67okmUl1EWxDQaKUFfEcyP9fvLZ/JiGQ8u0EQNwQyE+wa7/vVUKfXaHrdd16uyBb+bBHLYsTWBIiHnO6q0Z/x3cOw7cRnXeLhEBvRjyMbf2GshFoHuRT31rjsSJt/QQRR5Qay1u+yZbyzF/hpiD10doUEKJ4JMqVzk1SGpSRsZVGQNj5P3m7ZM33Yol5LOWheZSKTAbOPSeq0NvE1ser0jIzMo+9vrUsOd7oSohpNp84kmWt73zRN3XU4CoVLrgRTnhgv41vaj2zpbyGDB+vEJM00dpwqCNZY2Eis/DaQN04dfOMEsrxnznIoTbWmMRmtlSolD55jDHD5CiBTAsC0bNUEl21igU7LbAWRJ2Zx5fcjG4eyDgGHDaO10X8mqFTOdteu/KW8oaPXIcqB/6CWsaAr1bFqzrmC8Y9YC2Kj10OXc5O+AL6lcexXfQKwQjcx1XXs1SwaSuUjP3qD4SyCHtypN4NdQmkmayi3TIcmBora5Iv/zRFVbejxt0qw4NmxTRxrPq/Rhx8p5PdUDOC4mm+L8/wNEpnjXsHJ4KGq03lRpbsmEYJpFnaxWSFV8akFO5RqzNJZ/qvSb4BEJo282mpw4mgXMalv7GZshJbgIaqjNtIWu7VuULW4+ta7QFO9od9IY0vwbk99+9FZAHb73Mf1SoRaJeYxf2S/bbl8ude6hXoAOm55QM9ehNOOQRtoapYTQJauaEz8+FGxtuq1H1WrRCvLta3iV5gXz9gEE2ZLoWGpixLUgcT6l0bwnjpyPFkrGlf2PKk7VfCnavreJcE5lPn1v4EIeYvoQsr5diN0tnaUzjazZXsxQl8fnr6pJZueYxq7NIW
 iNs/gsJ2
 upuztatVesQB+GUoNoH+1Ytzjlh5NdVd5lDJUlVlCHu4LDToBAyh8NIjsW6NFH9A0jJVMKeQiUJufEDcGWc43E1q+wcmzOCNlFeiqdxveX2jduuCQztU2J8h43eYcjVVDGD/mBbariLs06tGVoIHJz79jZfBZIyVAyGh9Zml0xJyOsQHOQWjDUL+FdFJ8V6jQQcy/2a7oj922t26/DdALc3A2+CiyCNPgHT2AbbirAALN8udJz0cWb1C+BI+eswOKBjPM98fYz83uLDzuEfRatBup4x9wwECjmmxANTWNndrh2sDhNV/bz5cPJwExRYlHU/5OJohModLG/RWAvUS07p9p5COBwafrvakHmOma9HChtW6RE1A9PaE77Y5oqmlHmFDSONYz0kqn1ed8MfVbl3sA2XR4Ib71VI5oX4YFi+RGy+F955/S47NFuShP3aPngwRyabQCeGTJMZjTDTK6QK7M2NVXW/kgKS3k4bLiarNdGiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On Wed, May 13, 2026 at 09:45:07AM +0000, ranxiaokai627@163.com wrote:
>> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> 
>> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
>> anon_enabled_store() with set_anon_enabled_mode()"), refactor
>> thpsize_shmem_enabled_store() using sysfs_match_string().
>> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
>> calls across all branches, reducing code duplication.
>> 
>> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
>> all test cases passed.
>> 
>> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
>Reviewed-by: Breno Leitao <leitao@debian.org>
>
>> +	/* Do not override huge allocation policy with non-PMD sized mTHP */
>> +	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
>> +		shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
>> +		return -EINVAL;
>
>This identation seems a bit broken. You probably want something like:
>
>	if (mode == HUGE_SHMEM_ENABLED_INHERIT &&
>	    shmem_huge == SHMEM_HUGE_FORCE && !is_pmd_order(order))
>		return -EINVAL;

Thanks for the detailed and thoughtful review! I'll fix this as 
suggested in the next version.


