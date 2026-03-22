Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982B3FC72AC
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 06:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0887A6B00A4; Sun, 22 Mar 2026 02:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0661D6B00A5; Sun, 22 Mar 2026 02:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDFB76B00A6; Sun, 22 Mar 2026 02:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFA666B00A4
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:11:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 941081A07B8
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:51 +0000 (UTC)
X-FDA: 84572678022.12.E0A0DE3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id B42FAC0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fTgAWcIQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774159909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lu5jwEEecEkDiX7ux2A/sS85AyKDVmY0PIrDjssqoFY=;
	b=cFlJHWvLBDQfvR8Dx0qijoXj9GSTvcbw9Xddh9e/kCEBIZtxynk1r7RueuIhr9aMOS9b1q
	NLo0lAzvX0/nHhiPV5ewiJ4xC00Y+BwttbR13ond5MsczcZqsf0cOArbng2AUZ46ee63GB
	W2ApHMYQF2N5yD2GQARL4YoYWYNaLfU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774159909; a=rsa-sha256;
	cv=none;
	b=f+1XfJFP+WC7Mwn9U5tKEZdQrgd/SG0DteLsOF31u66In9WynfoBicZewTXhrKDIiqg5ZB
	i2OuqyS4yYToRtXVoyofcmltSzVSZUMbgKdAsnqInebG9SIUJyaegeNqXVo/a5zmAhd5vy
	bUnYDbyGtNPjWFe9v7Gw1laRhkviics=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fTgAWcIQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774159909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lu5jwEEecEkDiX7ux2A/sS85AyKDVmY0PIrDjssqoFY=;
	b=fTgAWcIQXapGpaqZ7uCIH4o9MAGKUG7mup4SVlj6czUkgGWPrBuKPmY8ezZnTvk2aCV20C
	ixtNg5gwNaGXSNCHeQfXrnTk8tYMcipebonOP7V4X9VAZheeeUdgyLaKvUpXWD9vPo0MtS
	/oM+x4PxXqbc3K/5Ks39Ai03CjovHv0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-CPQcHYE-NIm0Lz_NxNd6ow-1; Sun,
 22 Mar 2026 02:11:42 -0400
X-MC-Unique: CPQcHYE-NIm0Lz_NxNd6ow-1
X-Mimecast-MFC-AGG-ID: CPQcHYE-NIm0Lz_NxNd6ow_1774159900
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55590180044D;
	Sun, 22 Mar 2026 06:11:40 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.34])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10C271955F21;
	Sun, 22 Mar 2026 06:11:33 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: longman@redhat.com,
	liwang@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 7/7] selftest/cgroup: fix zswap attempt_writeback() on 64K pagesize system
Date: Sun, 22 Mar 2026 14:10:38 +0800
Message-ID: <20260322061038.156146-8-liwang@redhat.com>
In-Reply-To: <20260322061038.156146-1-liwang@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 7ko1LpD06pRZ9tJzB9GRzadfjcT8O6GYb-MqAibriAw_1774159900
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B42FAC0005
X-Stat-Signature: i135pg13yu4tach6xiecrrkyntn6mmed
X-Rspam-User: 
X-HE-Tag: 1774159909-785301
X-HE-Meta: U2FsdGVkX182RNlg8Cb9Ooxr8Kt9wQf1E03x9wvnQIOREgOOyY2/RWEwalNb5BRSnG64BvN54lf1aZBRZb+8f4nku9/u4TNFd1aCt3Dsq3j7bVno6/kyHQ7YMBbOdsSg/Czknls4H3+HJa39nArPEB0qwnbzIG7wv3PI4gUiNoStfAmwFLHb3NhSPuyAj0uJwYLq0Vf2BonLQrLs80SZjFMmOAmAzSAAPWchE2azG5ab0BQBR9CJAZ3KaMuFGQGbhddWFSBySceQKr/+L7IToCgm/Hrlv98MJnHVuIzXylMowOlzWp3U3Lr5B73MJzDiN2jVE6WoD1DX6ysxeM9J6ZvVxtji4cfTGEG9xp0aILupQjqSnQ6al+bcM+dPbuocHC27RgtUe5SWrySCyrZ241havxm6XnIoINTJLg2QloaQIeImBcUBH/krDpUQW+axYmuIoscV8MUBiFjoK0/rd1GdE0CsyuplYzWex4jcyftWApw47LdMmXBZZQAvr8okBJ2P80/Fi5SVb8jInJHOWKIt/jDAw2DP0NuZD1kcbEts/w3EX65qDKjxeZ3hOBEmB1FycfO3oNwd2+l8rZVemdDP56kGaEBdP42EdEmtkZ3Tt1A+9xhN2Yo6cC07bVjcJcofRj3i4Q88+pRyz3L7pAWvI0WZRbyD7MmSba0OUk5Tf8RANwTTTeDczNynejOiQApy0D6oY5jLZG55YQzWMXwfL62N1I7ws+1ykoLS3esU0BAMHOO1zA9O9Mf+QeXRM6Y4lWJHjfs6OVGpEffEOBxxu7ZxCYubdPf7jVDgj6QzBluviZ2FJm+6jfqapVwRIrNSV4xxb1W087UoGCSjtO0dId04kdvGep4Z8U3i6DAYzLAGTdn3gwQclMHxPN4V/ahuhUp/NmcvPodQo6jMuaWhWzjRNBkosIf0SC0MedY3mnY3frGoYOPZvSe5QhmtH486asS6zcfqAOF13C3
 yploYGlK
 NdoDZhJPZz/rOnZaubSuiM8aqbUl0g1h3T6dPi/2juJh3geOq97eR5roYUxvYIy7gQfctanzjOq6T7VhO7AByRKbFBX3v6kpx8d2u6gBEJURudb1OiicokmtTaep5zhpoKPYVUPFxTvozYPIn95K8FTPD1ogOV7huKVj++zp67jSMiyzX0s7zKlRjNzHSzfO7uNSi8YR7mI4cFx5Svfl8EZIMUtosjmrlj55x3gcn1Te4YUmdOfDH7b3CxargbNmnu3p4Mgm7Fs7v7Mrd/LzxG3to2km967b7f60SvgW2O7J1H8h+BVKXFzChCM5uqJBWoIm32abJPzTTi+9J1U5ntVSv8Ag0C4PHO0uaZHDAOzTQKg7dIep78K5WbSna4NBXdCDoJnd6TbR6ZfOJa17N5BAjButyX8bYaycZtngshijkWPnTsYzven9r9KG5mcK78wD6q6Z5C+eBWbn5gYG+1rLfEj8BzYhhOoQIkMcwAOkiKiqhX4RdNB4gcs3evgrQmO5XKFVbTy1dD+RrZ0hIceU1zDbn8/l18MdBUvOMCnE45C9BEpty/yhk68g+Um8KH7rLV2PHXyKtchQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In attempt_writeback(), a memsize of 4M only covers 64 pages on 64K
page size systems. When memory.reclaim is called, the kernel prefers
reclaiming clean file pages (binary, libc, linker, etc.) over swapping
anonymous pages. With only 64 pages of anonymous memory, the reclaim
target can be largely or entirely satisfied by dropping file pages,
resulting in very few or zero anonymous pages being pushed into zswap.

This causes zswap_usage to be extremely small or zero, making
zswap_usage/2 insufficient to create meaningful writeback pressure.
The test then fails because no writeback is triggered.

On 4K page size systems this is not an issue because 4M covers 1024
pages, and file pages are a small fraction of the reclaim target.

Fix this by always allocating 1024 pages regardless of page size.
This ensures enough anonymous pages to reliably populate zswap and
trigger writeback, while keeping the original 4M allocation on 4K
page size systems.

=== Error Log ===
  # uname -rm
  6.12.0-211.el10.ppc64le ppc64le

  # getconf PAGESIZE
  65536

  # ./test_zswap
  TAP version 13
  1..7
  ok 1 test_zswap_usage
  ok 2 test_swapin_nozswap
  ok 3 test_zswapin
  not ok 4 test_zswap_writeback_enabled
  ...

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
---

Notes:
    v4, v3:
    	- No changes.
    v2:
    	- use pagesize * 1024 which clearly shows the page numbers.

 tools/testing/selftests/cgroup/test_zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index ec7f0bd515e1..107b20db2fec 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -269,7 +269,7 @@ static int test_zswapin(const char *root)
  */
 static int attempt_writeback(const char *cgroup, void *arg)
 {
-	size_t memsize = MB(4);
+	size_t memsize = pagesize * 1024;
 	char buf[pagesize];
 	long zswap_usage;
 	bool wb_enabled = *(bool *) arg;
-- 
2.53.0


