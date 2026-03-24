Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F364F532C3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915926B0098; Mon, 23 Mar 2026 21:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F656B0099; Mon, 23 Mar 2026 21:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E796B009B; Mon, 23 Mar 2026 21:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 630B76B0098
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:34:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 152CE5DBC7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:34:16 +0000 (UTC)
X-FDA: 84579236112.15.A7C251F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 16EEF160004
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:34:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KoLYj4/3";
	spf=pass (imf08.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774316054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJOvGvWQBsJ5OmjH5/2vBPufG9+TCfOtvRt9JkSbV1w=;
	b=YNxJnonihUjgzDOZoSmoTMuRJQEXiVhL60R8oiNEDobzvU0Q9QIPEhVf39oyaDDAiZeoWb
	T4kftEuaiDFMLA2XxPHMoUWZiYCo7m5+SlUVDWpTQagy0od3/rnYOvXYWaU+txq2EugBK+
	lCSsUL0I4JqtOU5rhRAUtK5SQ0d2dus=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="KoLYj4/3";
	spf=pass (imf08.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774316054; a=rsa-sha256;
	cv=none;
	b=MxuEDiHPB+8UGbMubJjXiIvDBRmjmP6mYuwfAQgIFTxqLPJ9qm7HQtsAwmjoz7n7O8fQcd
	JfeFN3fFReVMXAfyNXK8cLlB8ZZPy4xxgJXPHzdar4gxAIZbovPDR77Ne/aZPX95/eNdfJ
	kP+WF7umMJAoWH436ALkgSa39DjJ+nM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774316053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IJOvGvWQBsJ5OmjH5/2vBPufG9+TCfOtvRt9JkSbV1w=;
	b=KoLYj4/3d0qUCFsPbpDvl3kvNgfeWRkmh5ULv7Y/rHmiOgb2QS8w5rAzQaaIwm3b5mWP/j
	xRtWEZFgGFeU7JcvFJRT+bhE31IBjPqYERbtcUk0gruUhDmfG5APKRbTKwaBQItD9xcRey
	NbweS7DDgmNhdHn+CPRnFSmLVW336Qk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-nYK0TxiRNN-9Z1p2rIIC1w-1; Mon,
 23 Mar 2026 21:34:08 -0400
X-MC-Unique: nYK0TxiRNN-9Z1p2rIIC1w-1
X-Mimecast-MFC-AGG-ID: nYK0TxiRNN-9Z1p2rIIC1w_1774316046
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 042201955EAC;
	Tue, 24 Mar 2026 01:34:06 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 504F2180058C;
	Tue, 24 Mar 2026 01:33:57 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	chuhu@redhat.com
Subject: [PATCH v6 4/6] selftests/mm/vm_util: robust write_file()
Date: Tue, 24 Mar 2026 09:33:14 +0800
Message-ID: <20260324013316.2590422-5-chuhu@redhat.com>
In-Reply-To: <20260324013316.2590422-1-chuhu@redhat.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 1SwgxddjPX6KgmS67O4xt3SlCqyMli4tH55ued8QPeA_1774316046
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 16EEF160004
X-Stat-Signature: 8y1ww7b6ctrh1fbydjnuh43bo739y9u5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774316053-929217
X-HE-Meta: U2FsdGVkX1+fdtHdCxuoG18lRk5juP/8qMuVW8gZbWqZP+w/Rc+g5Bbe0Ukaoa2V/QhPl2Ww+GGRKv5xNgwQR3WfNGMDjxllzPaQNEkTst66axuZmen4quca40mGJroJvPTfKi0obg30HvDQ7puH27F3v0ef8Qbj0dZaWUC0I0eYrtbx1md1THFzbVsos7MvN+F620ehH9hqcF31y1FgZn7DlPqDbAr/wrat/i1wlXvsY4ZsHec7uTGlhf1U4KWOLA1nys+gyA/eRJRjGXGU2Ig/K2KvK5/fKLJULmYpiC1vZjkpYm6/L/Ara8+TgreE9w5CpeNouNP52SyTvwpUOdeztsYHOfIOUJK4435f03WD146xp10VCF2e6vvJV8BvT4vvRoeLqZc7Y3z7Rw1tac6rE5Aorybs6s1ybxP8/62nsoV5RM4Plgk0gG3KSDhzz4qYhBhhzuDhMClZRswK4E1cfCFSeUkp726+XuQ8ImljbfZUsBNqkogeI2TTcfSn7FpBGZsZRIWSn59LP+SJUN4M4NSdTZg+sDDjefnaCkgHNsyGzKcg+FiMJM81YQbot8hz56fKcpZszXAi+jNYwc6ryRle/DpRAQFq014TBLHyERb2XdcV1leIE4VhDqxfdfsZRkWEuXiJuoeH0zY2uw3TqO4BOBvF5H4cqihLscF04UgivXMia7t9wKt88y2Ack4f52S3U1AF0J16si1X5Zi1SG05Dg5FoStfbjZ10Jdmb9H2KcOfRf4nDDojoQ8ylRfveNz0RuSXPzjSebmU8ISq3zS19uC7KPMwPe4xPG6Wl96YnLyevrbAGmJqY+eSed/BjpJjdQVKy28/fAuoQecngjcUie7W9hwexYRDGq3jNuL3DD7PUO6ldGzEcvMWCMQgC6MxfRk8Ffdc14BeFYTtxX2PvKWcryV2Tj8LGZbWTKzlvQRm6Ed5NLYdnfgPi60/HqZdTIvjvodRw4v
 U7qwyfes
 +S8bUvF9E1pEpuZbnK6Pk/9wLPfS5t6lyGiKind/ggzXRBm26nY80i/f2QmCQdOb7TMoidxRu8alAVKx1qZhTNWgj/PNCuXkglsq0MuJODBRKXNpSEnWIkVyJYIrd9XOowkIp9vbu1OtxD9E1CVu1JC2NWLZPUg0BMJpAEoQR8IML5FetUaxT7gyxXINLNUWIsd5lML+KA51huIHSDy8ITZDHDgx2SspkcFW2OEj+0EaK46DWMdO2rJyRQX/2zgtdBoDMUpaD0ACC0+iXx27t2267woEPsrIXxFoejlTRgjqHGebfBFgnHTiskonr/LVB4E29prPxMqtBQ3zX5Ei+WOkx6bEpmztKa+35IAx9FdJ61KINIVsMo012iyD1ItZCxnLkF3cb9pfnINY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add two more checks for buflen and numwritten. The buflen should be at
least one, otherwise the 'buflen - 1' could underflow and cause trouble.
The numwritten should be equal to 'buflen - 1'. The test will exit if
any of these conditions aren't met.

Additionally, add more print information when a write failure occurs or
a truncated write happens, providing clearer diagnostics.

Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v6:
  - save/restore errno before and after the close(), so the log could show
    the correct error info on failure. Suggested by AI.
Chagnes in v5:
  - new patch for making improve on write_file. Add more safety checks and
    diagnostics info in log
---
 tools/testing/selftests/mm/vm_util.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index ad96d19d1b85..572ccb99de8e 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -767,15 +767,23 @@ int unpoison_memory(unsigned long pfn)
 
 void write_file(const char *path, const char *buf, size_t buflen)
 {
-	int fd;
+	int fd, saved_errno;
 	ssize_t numwritten;
+	if (buflen < 1)
+		ksft_exit_fail_msg("Incorrect buffer len: %zu\n", buflen);
 
 	fd = open(path, O_WRONLY);
 	if (fd == -1)
 		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
 
 	numwritten = write(fd, buf, buflen - 1);
+	saved_errno = errno;
 	close(fd);
+	errno = saved_errno;
 	if (numwritten < 1)
-		ksft_exit_fail_msg("Write failed\n");
+		ksft_exit_fail_msg("%s write(%s) failed: %s\n", path, buf,
+				strerror(errno));
+	if (numwritten != buflen - 1)
+		ksft_exit_fail_msg("%s write(%s) is truncated, expected %zu bytes, got %zd bytes\n",
+				path, buf, buflen - 1, numwritten);
 }
-- 
2.53.0


