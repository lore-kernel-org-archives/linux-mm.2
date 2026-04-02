Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58BE9CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4A646B0092; Thu,  2 Apr 2026 02:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFAEA6B0093; Thu,  2 Apr 2026 02:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9C06B0095; Thu,  2 Apr 2026 02:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F50A6B0092
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:38:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42FE3590BF
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:04 +0000 (UTC)
X-FDA: 84612660888.09.99CDFFA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5D439100005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EfiIKYCn;
	spf=pass (imf05.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775111882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5U9ZvN1zto4I+eOsqlOo20LYK4uAdfElmrPhMe08Tc=;
	b=tcWJmNwUx5mkhcBhzTN8PU6rrZYlKUiIVwjq89taMruG9FJDPgvPUpiJm7kDsoxTdbV+gG
	2PpAfPH0NdPA2J7wPdVGK9JVszeQXYni2AiHTck0eL4L4OUuc/nJSgX7XymVjjC8TxO0/H
	f9z8/PxwvXSoMIplG4l3u8ffNar5H6A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EfiIKYCn;
	spf=pass (imf05.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775111882; a=rsa-sha256;
	cv=none;
	b=zZ6vF3AnMd8kxBxaz6hIzI3D88hFTDx/3EMs1BmfUu/t/Bv5yAVcSvXO4hAkfWi8uHVDDo
	I1y/MfGgUGtDNaIi/YkYDUWh9KkvmaShgHWmKd0w4lwpi4bYxR1/B4aWwIjckHvGPf2UsA
	5UEcoHpWQAVlZov8j+CAKyLlJ8gJOfw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775111881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X5U9ZvN1zto4I+eOsqlOo20LYK4uAdfElmrPhMe08Tc=;
	b=EfiIKYCneEJL/nDkgDG6Kfp6AUi66TN5ghdrYJp60f09SZkxcljArV+2wIQzNMmJTLoWgE
	HZqeeRAzqqSQmhpXC6ERJZjvVx75aENUeEkmTTH96PGRiMiXZGnennpG3UK0/NvqKgyx6i
	5lUJNdPYCvPwjRVldLFbLHBIutQAr/8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-132-bEp42vKHO1aKWY3Kdwl7AA-1; Thu,
 02 Apr 2026 02:37:58 -0400
X-MC-Unique: bEp42vKHO1aKWY3Kdwl7AA-1
X-Mimecast-MFC-AGG-ID: bEp42vKHO1aKWY3Kdwl7AA_1775111875
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8D506180034E;
	Thu,  2 Apr 2026 06:37:55 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B3EC21800351;
	Thu,  2 Apr 2026 06:37:46 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	mhocko@suse.com,
	shuah@kernel.org,
	chengming.zhou@linux.dev,
	longman@redhat.com,
	nphamcs@gmail.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v6 3/8] selftests/cgroup: use runtime page size for zswpin check
Date: Thu,  2 Apr 2026 14:37:09 +0800
Message-ID: <20260402063714.55124-4-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-1-liwang@redhat.com>
References: <20260402063714.55124-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: xmBZsPH2JxwP-2xdAQmaNW6zFL0FTHm8KvhYOo4U1n0_1775111875
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D439100005
X-Stat-Signature: rh86xahuhom4nfuaw7g84pqc7m93nrbz
X-Rspamd-Server: rspam06
X-HE-Tag: 1775111882-254176
X-HE-Meta: U2FsdGVkX1/NCE9da41flx0QVK07QkCGkOY7iziskFCo2sDG3Id6nYaaDqFnNObMXt/VRQ8lb/Xxaza2WxbSBTznj7iYoVdmna3iWCf0y/a6iZJ2NJ0uYU9QSIssg9I7In842KaCsfOTwMSNxaGuF6ww5ANcpcQ78+5gZ2TYisjEeGCES/WwuO5m1THx7QYyijVxgay5pWUT4dEDjFT6fKXO1RtGLKWauRK9nYmZwXiXFdXXi5Zk7Dg/usudXi7WyS/yqC++DGglVIORtlF6fNbzV3vizITEYLCrqIs5YWJgT+CrkpyEj77BB0wfZ46wXx55bL30pCnVgZOCUMEIVp/seIw8BqyslLtHoi2QTGZMioM2CwnF9VF43AzRtlkvu6MzbVn5utT0XsQ8bHr1Bb+0WyuEjO48usZTA6TDvqoRE5jmptoKF16+KnBovKmMORHf3DCop3BBEROvysrJB1PTALBdxC8fR0eFiVKDW7OhocL7vCkfxQwTHHHOUq0aOU/1G49slECYJj3FWuQS9rBSzo2IGJ83n35klGpUfMNTDqEc+kxeAXL97FUj2f6h1zU93OSyc7VLunIUF/P28XyXWCvbR82uxI3TeIVASI9N6QA4kDWhkbKtLpOPv/AE/gspAOky0fwMt/4pG7Klncch+GXwUZRZDjGncyWo0FJyyF1Y4dHW/lrpH+0Yb8lC1XPFUuOFlb2fzU2St7wlVYmM2AWNkqVWTAY6bCnzzS1f59iV7p2xZY8WbrYiuBUarO5PPtwoHiP8JiICARD2EWRj9ItphaX2cc6Zmd7tsTiA1KS2jxbkRfPJUdui6ClPjgdxw15mxRQslRqWriHw4JzASZmL2aMYe5+cR3EbUOok3tEux0+OCeTBmL4K09V2tE2I1qvp2GEOY+2qbNHrp6CtO1+fx1bY4MUf+3g/873NJ5Cbk5yh2KWOffrUizlYItqznWkAZjJXjxTmnty
 pDDtT3Ww
 zX7wA54k7643MKlUrojDewUTW0zGNWxOJvf1HFg6O6cBConTTQVhSnjnjEIRJaVXtt2Huim/1/bZk4D+m+ynmBlNoQa44aj9JAGHjgqb4BGwH695G/UrdaFZBqlnVsGDFwcLzZ7kcTgJWnrZl1/VwMf8vpp8KnT8Jyim7plA0p4YySAFrbkG7OeSddvorbWYYfeXzTVc9FVw6KOr3RvQB5H4RNHZI2+sYwHl6Sa5ilxc0e2UVHWZOLrs3oxwB4OTAZpcAW3QpeUC0Hqa7fwhkV9elKBr6InNG3VxMMuMpjbNa1wDNsO4Qh1DtQLGAm+r5p1TgJbqiaPdntdklOzH4cPlkJNYlrFW7dGbYVGxbgM4RrBTMdXHt9wGygRzTHGquXzX3tzG+kKYAtn/8RwF5GaXUFhoRUmcFPsDpOm1pUAzo8XLIBrZ+X3G04vuapGG5PL5+0yV2V7t5PIxkDZ3YYp9ZB4n1+TYmMROXb2t1VkYp5R031KMPPfTMVlajIEVFjmcCnWs5ED+NWGrlSxKX15+w+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_zswapin compares memory.stat:zswpin (counted in pages) against a
byte threshold converted with PAGE_SIZE. In cgroup selftests, PAGE_SIZE
is hardcoded to 4096, which makes the conversion wrong on systems with
non-4K base pages (e.g. 64K).

As a result, the test requires too many pages to pass and fails
spuriously even when zswap is working.

Use sysconf(_SC_PAGESIZE) for the zswpin threshold conversion so the
check matches the actual system page size.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index ed257d464bd6..516da5d52bfd 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -243,7 +243,7 @@ static int test_zswapin(const char *root)
 		goto out;
 	}
 
-	if (zswpin < MB(24) / PAGE_SIZE) {
+	if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
 		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
-- 
2.53.0


