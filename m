Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19149D2ECFB
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 01:14:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5918E6B033E; Mon, 19 Jan 2026 20:14:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569F16B033F; Mon, 19 Jan 2026 20:14:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496226B0340; Mon, 19 Jan 2026 20:14:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 356576B033E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 20:14:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC626140397
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:14:46 +0000 (UTC)
X-FDA: 84350572572.25.7BAA111
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf19.hostedemail.com (Postfix) with ESMTP id AFA011A0004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:14:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fOeJeogK;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768871685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sTNJ8nv6nedS8JYyGztyJ0SAQBjqXgQhXAwMPBxZICQ=;
	b=G7yCPyVcciw5HgwnCewblMUJfuTDRr9hIswusminC/19eUCN/BueLyXpKrN+5BTWG3hTqG
	wuuxu+4MKP592cNt8oBkmgqDg//C2c56yv0cc6UpVkH92ykfqKTtYS+CYwrJ5NRncBtF/j
	MLu4V0DOk4UyH5HRyRB1H/q8S32izVk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fOeJeogK;
	spf=pass (imf19.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768871685; a=rsa-sha256;
	cv=none;
	b=oIQXtIC3AzyN8uEst97MKOl0Q9SvVF+3ZZqWlq4LDnmUAknvqhS8wgF1AOnHtvVHOg1kfE
	yDmdAsFlAnPvw4o5uF0n1KJgOlhNlraXxpp7mmmCuimEp/nIn4ZOhmfzXSAhqbw19yxNFG
	fIOnP5UF+NPJFMYMJh9nj4Ah9xY9mj8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sTNJ8nv6nedS8JYyGztyJ0SAQBjqXgQhXAwMPBxZICQ=;
	b=fOeJeogKNeFv54cw74AmCMgSSpr/+aaua2z9SVrLJjp1bv8ppbPr3gAyIeDZ4LoFHspHwM4zJ
	TWQi9R5hJVIBQ39GXSm1d+XAgfOHjgmBgRaP1NNt11TTV0fOnTOIhnnWTslyCcspyBoqMrGOVlX
	B35HXz4mM9pL7nuC22jf/PU=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dw8R74Hbpz1cySX;
	Tue, 20 Jan 2026 09:11:15 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 1709540539;
	Tue, 20 Jan 2026 09:14:38 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 20 Jan
 2026 09:14:37 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <akpm@linuxfoundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <mgorman@suse.de>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH v4] mm/mempolicy: fix mpol_rebind_nodemask() for MPOL_F_NUMA_BALANCING
Date: Tue, 20 Jan 2026 09:10:18 +0800
Message-ID: <20260120011018.1256654-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: pn9ebagbtjdt5xmcqggh4318xx6gai1r
X-Rspamd-Queue-Id: AFA011A0004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768871683-757003
X-HE-Meta: U2FsdGVkX1/bCOg+WXLYp+LdY1CHsu4bhfrGZh7mS6it+orFvvejsc0LkhzgmuxDyrZu5Mjk7aQMSNzxLJ23o+E9Pdy52oCiBhcGAANo+WuCIhH9jqrGl1B+Y1xOKGSLmV6TpPbhtDlcsYmBxEbY30O4eYN3t548TqHK7Kjwe2pqfpYfcwf5619M83HECkrOL/PgI5Chao4pMRua4OaE9njEITMU8OfAPqt9GjZRUzGfHxcLfCq75a3TB5S5jjHWQl1oazGevaGznSYpNnN85evIK9OSRZeO2SWz33FmcnAIqIWEbHOxZRMETYtgZFdISbH8w4sJwKe6sxTM/ZKxKlw1OEx7xj/ooT85AC2w4FIhT4vvk06XhlBHjpBfCefk4n77iSWIgRhoEq3tzei5+TJqFnZl5k0pNdEx1MM0t1hp/5JkW+w/pcKJ8KoPY6UIq66Bdfd1rL3ZlwO3n43dx+Lelk4xxswPMFClFmfSYu66X3fWjvI3gbbgPP9xRconsofm9P/rscP157Ibz0xxCoQlQJcKmO+U7gIGrG083iOo6t2myz336f1WlbX1jhIJGx3BqZYgQp/i56u3bdAn4rGOYqtBy5GtYfvCXYlfzDzuHoBFbX4x/xfrl+EHjTR635VN8T6IO3FkLzTihJIBCbDzZ1nAXTlNWDoCJ8OqYNXcD3AsAdsRosG4DUtH4hZjkqKKa+s1HXjp2lxDA7ruDRyC8ao3VUz/XxV9pk5G41BzNfNXwfzoZOOnI5u0TEp2RbsOlbAwrCGUALHf2bzuR6RxZ2Ax27FHJee3xtKOqXgprwetQBOV+XfWFmZ8MFCEHrxWHDPsxieTrD1M5ILpNecAgNRkVYpDD6olOR3S3jr2c3J+aCmfKdMWrFYh2CxwmapN/uo3mOxeva+g2r+8Z7HdTAuYwDbUke3FsXp7T3Hko3hKu7khkwYiF3zJ4XQYX5ls1VoVqyjauDMdhuj
 IZL50EgG
 G5w+DajUHu1mMgPLFfBItYFBPk+872M97gxNtbgoyHmVcxtCBdU9tGY8pWGQflx3GYKst95LN9l5G+RQPBK8zCvF0WuUKYqD88LMVzQ6P6jOtN2LZ8cgdfwJk++05N7doOComW5lUKLTo6G3tMPibEHjbbUb7vSC6xyUv94RnNb9KZ4fYFYO4wXb1onEZm5Lj3KrEZorKwCZ/DadyY2FQwFTvoPSETbieVAjSpNS32U6FCPvcGmAzV/G1MBojsUcuB/b0qPycmojaMPYSlXzeQwJm0q6yNMPZvdQaHsG1uwWPUAoknEiNw6YYs9nWHj0QMCN4Js2m0qq+qxcK0yP4fgNO+WcW3f4knyaXNoiaseAnHjd7+XOCjS7EwjY+y3/8E9f26L4GI6sFkqsaLxHLQSCLT2c8zEFDXwbnPK0QP8AqhV80aWaCKosKHozjHKkFNq/TseLELsFJ/cZ6DO/g5XdaKZA2KpBvKAYmwJwFOnbLNy1z3PdQh6or23gN0q/duXFhxN+qWSanKuY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit bda420b98505 ("numa balancing: migrate on fault among multiple
bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
for MPOL_BIND memory policy.

When the cpuset of tasks changes, the mempolicy of the task is rebound by
mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES
are both not set, the behaviour of rebinding should be same whenever
MPOL_F_NUMA_BALANCING is set or not. So, when an application calls
set_mempolicy() with MPOL_F_NUMA_BALANCING set but both MPOL_F_STATIC_NODES
and MPOL_F_RELATIVE_NODES cleared, mempolicy.w.cpuset_mems_allowed should
be set to cpuset_current_mems_allowed nodemask. However, in current
implementation, mpol_store_user_nodemask() wrongly returns true, causing
mempolicy->w.user_nodemask to be incorrectly set to the user-specified
nodemask. Later, when the cpuset of the application changes,
mpol_rebind_nodemask() ends up rebinding based on the user-specified
nodemask rather than the cpuset_mems_allowed nodemask as intended.

I can reproduce with the following steps in qemu with 4 NUMA nodes:
1. echo '+cpuset' > /sys/fs/cgroup/cgroup.subtree_control
2. mkdir /sys/fs/cgroup/test
3. ./reproducer &
4. cat /proc/$pid/numa_maps, the task is bound to NUMA 1
5. echo $pid > /sys/fs/cgroup/test/cgroup.procs
6. cat /proc/$pid/numa_maps, the task is bound to NUMA 0 now.

The reproducer code:

int main()
{
        struct bitmask *bmp;
        int ret;

        bmp = numa_parse_nodestring("1");
        ret = set_mempolicy(MPOL_BIND | MPOL_F_NUMA_BALANCING,
                bmp->maskp, bmp->size + 1);
        if (ret < 0) {
                perror("Failed to call set_mempolicy");
                exit(-1);
        }

        while (1);
        return 0;
}

If I call set_mempolicy() without MPOL_F_NUMA_BALANCING in the reproducer
code. After step 5, the task is still bound to NUMA 1.

To fix this, only set mempolicy->w.user_nodemask to the user-specified
nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.

Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---

Change in v4:
 * add reproducer into changelog
 * collect Acked-by from David

 include/uapi/linux/mempolicy.h | 3 +++
 mm/mempolicy.c                 | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 8fbbe613611a..6c962d866e86 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -39,6 +39,9 @@ enum {
 #define MPOL_MODE_FLAGS							\
 	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES | MPOL_F_NUMA_BALANCING)
 
+/* Whether the nodemask is specified by users */
+#define MPOL_USER_NODEMASK_FLAGS (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
+
 /* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
 #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68a98ba57882..76da50425712 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -365,7 +365,7 @@ static const struct mempolicy_operations {
 
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
 {
-	return pol->flags & MPOL_MODE_FLAGS;
+	return pol->flags & MPOL_USER_NODEMASK_FLAGS;
 }
 
 static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
-- 
2.43.0


