Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EE63C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433D86B00EB; Wed, 12 Aug 2026 09:23:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40AF96B00ED; Wed, 12 Aug 2026 09:23:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 322336B00F0; Wed, 12 Aug 2026 09:23:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 026D06B00EB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80F01120362
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:19 +0000 (UTC)
X-FDA: 85092683718.29.0C777BD
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6984540008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="a iiosAO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="D1/ntZao";
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786540997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJbY/SFy75qdRi7w5cKO1mRNu7cIMLlux0wZ8SdfTcU=;
	b=G03QPH/Vr+h2M9tg/9RcsF7hdxuxCUQB6Yw9oFr0RC6CJiFb+Brp+DGPJF+wZL2Byho9I4
	FjLI8SgJDcWl6jMIN3mZIRQWRUfPvLmCUEy+IkoH2JctWO4NsUpnZjH/7BjGYYnNfEw9TU
	eIbWNEowbEfOYVd4TENAUVwD1u6tVZo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="a iiosAO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="D1/ntZao";
	spf=pass (imf04.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786540997;
	b=vle4dQQ9SwGVrLUqkPWL0fhRJRB6LOGXbZqtQdPkggEAI8DU94K9KJw8FZVR1+IlIhn3zG
	HmtHfgmCQZ3a+rsNEuceXN8DRoMgC0Rzi7oPRfhYbFf8/bq32Knyz6E9HZCplb2vCx1Qhz
	FhA5+3zer4ybrLrJO93lTJlzV+9w5Eo=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 478457A010C;
	Wed, 12 Aug 2026 09:23:16 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Wed, 12 Aug 2026 09:23:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786540996; x=
	1786627396; bh=MJbY/SFy75qdRi7w5cKO1mRNu7cIMLlux0wZ8SdfTcU=; b=a
	iiosAOa4lnIcQmGxw3xyoXiABW5LfDKUemJ8PwlNXaysVYmy1zfqoZSnDyQN+oAi
	W2V4GVNkMjAzEeNPyAzVb9uUuKKR17KLN8zV6V1BQFPDxNgJHbT6CTM9JNUcjVUQ
	K9KWplKuoY2m3pfrchow+I9upXOXfVg6kF+uz7KcOXP0H8I7vXtHeCkuDv7SzANi
	XDZpXth0IYOL7GY+P6qXA+JOT1DhRWS/eOwQTMvvmftcZ8EILT6qmA0w/8Bl0Ocy
	geaZg01+6Re1R4DUHmsIfiyP8+ufAvQC8ZZVsG24mzocC7AUCCj5qk51PC6uUfbv
	b779JmXqIqHrSy1ahwO4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786540996; x=1786627396; bh=M
	JbY/SFy75qdRi7w5cKO1mRNu7cIMLlux0wZ8SdfTcU=; b=D1/ntZaoXHDqQY25H
	Y2A5uM4Zy9Mfrz6K86Xnut4YEMMtHDV+hRovrpBJ4d/KFoVQPNxBogKLXJ4VjOyq
	kSS7udh0fK23gd41EaTftHSIJH4ze6kCo+bM0uvF5ipVRJbQNzf1GVAD8/N2uYAY
	7s3diYhQOxDuUtfQfOx3mmGUHA7YzF6jG6JBKsSb4/66sGJiAOSMgpoSOEdXsFS2
	Vuw3td++xfIWBweXiSER/q7hQPcmLZANQKO+tVd+hW290a+pFBaFrwDVag8JAkXX
	LkZkt3REhbSYkDmacPPVHWa/6ywQoHn9s/7og6CX+VtA3+focCjMxxMta4+DR9NF
	d7TxA==
X-ME-Sender: <xms:xHN8al5HqtzrXenCExcQaRJGsVmdflJl0EUeK32V24EuXCekjMX_gg>
    <xme:xHN8auwWBIjsbK8NKkB5OUyz2JqC5f-C4gtaiSRkQ7oNGynwYrR2OC9effzTVIRL8
    fb4CTzKEKk6nCRGCncSL1lYcqX12Wggu_aIa6UBXs3ikPkgleb1xnw>
X-ME-Received: <xmr:xHN8alTbwdHHYdW4Ta23l8oCOFJg3ERmN5CfZsWzT5TfGuXWw1yUXn3sjKg>
X-ME-Proxy-Cause: dmFkZTFzqtrNoSTXX2MRzKyN6p8XXqdjDSX08KYyJpXp82eYC1ae2GegaTOhbDzreYT/K0
    OAsc1zsfjWszwuQXvOMxV3FM9x50+HqAsA48u5Kq52QtHo+TJJPCEG+EOeKn5Il8AepNuY
    amkSO7LHncjzMJKy/SPUs50UUrTlzGP0ayf7b+h/q5NreZMQSrrfXSzcd6tsdBCg4Hhmbc
    7COQKDHpqWJD3HpoJ7/Bw0J3tcRV9tZIkmRGQ4nZ/O76iTBc+eN6GYtayu9aLLTJal0DNN
    hI5LqlugC7KhSFwlZIIFqKKnJB7XY7vZnEBEdRJ8Mvpq9sE5OflKN5J+H3ujbniJsnhlY7
    qvofwkhupd3+ldjSFNE07ZJ6AiypvcrGoG9bilNX/w56U6sBddmljfwCtBGcGBcJl6c1dK
    6LGhiz6rnHZc9AbDCNDPCZw4HgoNvPHpE0+SgOAZ1eLVGqCVgR/KwLxiC3cdzJfUHp6670
    se8/8fH+r0wC8pjS6JwIkHpLmpsNqcTEYrpHAj6zHkZ6FflNj9aLmG9tSF58bwKbKVAHEn
    O4OccZKzkSFnPJsLnotJOSRo3IRFIx//B5JtVWZLhX8tnh7KHfgOYrELZm7LsxWFEfS9xX
    AygVIV0KsKuBFx18VKm0EeWgSNMTbkyUC553L7qTZtO5Ehb/HBGxlMszaI/w
X-ME-Proxy: <xmx:xHN8am8t0FLVG_BdWk65Qkbsq7_pyggID-TXmpOrVraFFMz3Q4pL5A>
    <xmx:xHN8aiIkEm9RCDTOSurTNvRvnq6rE7u7fRUh5sgxSdQx5M2zlTOT9w>
    <xmx:xHN8aqsUebIeo12iGyG07Gbh8BGn0wPq6AWj_Gm5K0H9hhSP97k5-A>
    <xmx:xHN8armdZXbHt6strlMo6jp9j0pV4wHyMujRXasXgU2l94sYBsinmQ>
    <xmx:xHN8aoB6Hdtl88aLLX-oZTgYLAbWhu5sUJOqqyIi5bOMupKdCKtTwxM->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:15 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v3 03/18] selftests/mm: scale khugepaged's collapse wait with the PMD size
Date: Wed, 12 Aug 2026 14:22:49 +0100
Message-ID: <20260812132304.199287-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6984540008
X-Stat-Signature: 9cdgrxwp4b4gtbg89s8f4ega5gutjadd
X-Rspam-User: 
X-HE-Tag: 1786540997-798167
X-HE-Meta: U2FsdGVkX1+DDzLKqhJw+R5FBwqgCeCcHe6I/qipblJ16fG0RE+GJdwAQwP8wa2Y46ZJFxHxOstyx91Rmu7lgdf+fJ4NL2wEWn7q/UmQQbX0Sar3e/YrlcTPldDs1zYRwb0l2GdU88efa+EEsyfgLA4TmhSAJSACJyEPxOPD9CJ+i5G5AJLzOK7c8x74Zbfx48XFg9jlMCBAcWYgCECrh8o0wx7sdk+B1RYrFWnOc6Mpzo0mQ+mMd9ZHFyqj0nbwxCw/omQ5dPX7ZIdHBVQyIp6ijwDC6WIoAtBRZOooadHVmAi5hB3yUeQkXCLXkL5kfQKKLPpRWi/8cgy4Xvy+IoFJxueaWjyfdK2w0UZLgit6C4ZUyo65Rqm3MRc1Tq3JwbeWHnJD/WGF47DVgwvDGJeZt1Q5w7YW96VaRSeVxJstTQZjJaI/wOFeIscK5or4LpUXUlASb97CEV1Q41xFlFC+bC9VkY31FjZXu8OA0GBmUD7mq+TYetOlPsNhf5sSrRZFPFPNt3LYwbiF2SicpTSgErv1IwShogGfY6KbPicqMTgna5N8896ZkMA4i3uM+NP428I+AUZCEwOP8mPsIby9oq39O6u1RBijNV//BxD+mKnqZ8qGSF9OaKYhRi1bUZt7IHXdSR+ubJ5YbpdTJGDyb135GdSs2oh3Rsw3N9CSthAOwuCAA092Y42oxO4p2Mx5egibeAULACFtwrDeKaWz+E5ob7lqlA2XImz78t1g945uMB0xx1YFpGrGrm0PUZRmiFLXPOXgKj7O7jjtlUYIMjSQiIEzjqL4/Ll6ZMDMIeiilatd5hL8VbhttuobePLUqyytSFPB9Gn9B+NCoNK/XvC+OEDlrS3YfFVXNT5W5omz2vrPT+0lRzAokjiQhyotAEu3c8Mv9zGKx3dsJYeuA22z65WSeQtLcrMCfFIXFU4QFh+CaDLH/6Ahotm6ew1KXuQ5BGYdkrzaiVh
 fRfVC/i0
 xtJL5SCm+tNQklvvbV+PbRYqdFGbKGl670pGb2/yAdCO4Wi+2wwaiDMtm/EOPVZ3xruha9i45B8HIAUsmbnZxCgC1aMQB6zoMdmZxk7tc6yBfu182lgMPzrDZ35AVsRbIFvw87Cwqi8HKrn7hlWjVMaPdGEO/0LU4OxFczgvuWKO2K1h/yYPXra4x82cyXP07ML4B903ZFF1uF1UvzTS9WNl6WKlN8PHllDzh97d6AusxSYtgXzxYP9GfXpimShK7G+Wmpt06tzFEEipnY9nSmqOBTzLEp2TSnmgtd/02FsZmXxyz7qX7+r/BsmNMLGXeBD2rn9KeqIBZlQ+5J+hHzZgW3aayvhK10jzkRBPeOMbxCa1gSfB8UDDfBYVVATX/WmssBTWulXyckqtcwsMLmFPOhkEtclxoK53GItTAWXW/8rFPwE5oevssklTnBLbvSHZQuIHGyB18aP0gWDcQRkTjZnmPvpQduzCDh0oRY7gNf5awbZ4thcbIsVfthVTijDI0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

wait_for_scan() gives every case the same three seconds, whatever the huge
page costs to build.  collapse_full asks for four of them: 8M at a 2M PMD,
but 2G at a 512M PMD -- arm64 with 64K base pages.

Three seconds is thin at that size rather than generous.  Across 80 runs of
collapse_full on arm64 with 64K pages the wait was half a second in 73 of
them, with a tail to two seconds, and the case has timed out in a full
matrix run, reporting a failure for a collapse that was still going.

Keep three seconds as the floor and add a second per 128M to collapse.  A
2M PMD is unchanged.  A 512M PMD gets 19 seconds, which is headroom over
the observed tail rather than a measured requirement.  The budget bounds
how long a real failure takes to report, not how long a passing case
waits: wait_for_scan() returns as soon as the collapse turns up.

arm64/64K: khugepaged all:anon 21 pass/1 fail -> 22 pass/0 fail.  x86-64 is
unchanged.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 48eb74c255f6..a5ada78d90ee 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -583,8 +583,10 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
 		int nr_hpages, int collap_order, struct mem_ops *ops)
 {
 	unsigned long hpage_size = page_size << collap_order;
+	/* Three seconds as a floor, plus a second per 128M to collapse */
+	const unsigned long bytes = (unsigned long)nr_hpages * hpage_size;
+	int timeout = 6 + 2 * (bytes / (128UL << 20));
 	int full_scans;
-	int timeout = 6; /* 3 seconds */
 
 	/* Sanity check */
 	if (!ops->check_huge(p, len, 0, hpage_size))
-- 
2.54.0


