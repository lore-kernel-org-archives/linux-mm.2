Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09CFDE9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 18:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA72C6B0088; Wed, 18 Feb 2026 13:42:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2AD66B0089; Wed, 18 Feb 2026 13:42:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37F46B008A; Wed, 18 Feb 2026 13:42:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF346B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:42:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5E861C1D7
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:42:25 +0000 (UTC)
X-FDA: 84458447850.08.7D29014
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 12AE6140004
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 18:42:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=blFrZgRP;
	spf=pass (imf09.hostedemail.com: domain of audra@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771440144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=frAMfRqoE2ZGmeGzlkELRXqzdLMkM54op2gu3LYMHtI=;
	b=c0uy2o68izZRR16HGb2IG0LBwFTXXaq4RnPxb+qD8S96NbcX1hY7R61xRNNeUbdnwDXRtj
	IPvP0wvkt6PfLNI+9PyAEpjfXVipgx6N/VIsJKYQrV5u9HfhfY4erDRUIe1ZPbLat0wGQb
	/LgAs4ZNq+musErl8Q20tK2YHWwDk6g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=blFrZgRP;
	spf=pass (imf09.hostedemail.com: domain of audra@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771440144; a=rsa-sha256;
	cv=none;
	b=O/l7E72igy/4PTNwKWV/6UON8In/PTTM1xC2QA2GwLZYBY32Tqn4riD8KyxWvLavE5HWmL
	5EMjoxs1aYouWLIh//SalZvdlXUhiIfk6Nr99bet4XUlW2m+XiACWWBquVbFnEH/6EQ+wi
	w9r5T9BEyUDZvd6lJmaJJqlN4EVsoQw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771440143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=frAMfRqoE2ZGmeGzlkELRXqzdLMkM54op2gu3LYMHtI=;
	b=blFrZgRPHUypdNBTbq0rHd/fC5tK0piBKhblmRAHqHFEGzWQxi/cBl+fPt4oik7w6EF1zC
	Qri0ylTdi7cXE/qkMLmKHO8MZVE6lQTmRSx6wt4q9WIOT88VAhnUZmYUoUY3Ifbhgovf/E
	IRA/fkM2RjYiKcsTyxEw+NUWE8L9InI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-c-abKhYvNRmNVmLPT-aNBg-1; Wed,
 18 Feb 2026 13:42:16 -0500
X-MC-Unique: c-abKhYvNRmNVmLPT-aNBg-1
X-Mimecast-MFC-AGG-ID: c-abKhYvNRmNVmLPT-aNBg_1771440135
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C47241800465;
	Wed, 18 Feb 2026 18:42:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.81.6])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D0DDC30001BF;
	Wed, 18 Feb 2026 18:42:12 +0000 (UTC)
From: Audra Mitchell <audra@redhat.com>
To: linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Date: Wed, 18 Feb 2026 13:42:10 -0500
Message-ID: <20260218184210.206466-1-audra@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 8m4wZ56EfqAtFeYhpzLFERpubdMr-2U4njtEUOSXtGE_1771440135
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 12AE6140004
X-Stat-Signature: 6cwqen3ts7kr9qwh7x68bm51xyoexyux
X-Rspam-User: 
X-HE-Tag: 1771440143-127634
X-HE-Meta: U2FsdGVkX181ju5gh76CYj7J6Kz+OScJE/3Es6TPWasV01RwA/lhnGBYsml2LEfW9HMHeRi4V74homSv5zEwm5m924lx86kGrNvmI5p4f6gi85Kh+v78VWx3Rr4gp8MsE9Zouq2Om7Qxc6EOIUe2ZD5zgpx6nnCnGLcLqj2eJ5cbiUaFh1IqyfXdCV40CawDH1db/GHXEnRIiRBKPlMAW0PLw5h4fdfRxHiCAFIUYSG847AwlfXUmqpMjc7mc3Mv4Lmx7PLE5MRCX9FSm/kfJ79vqW5+iHRzPuoIy+m/lfiWMzMjtSs2BekLN4452oXqDcNX4LxYFTDFK0G2NxCdvhhr4IdDVCDaPs3OnRMP56eFOCMsNd8r3SWKHiPQ5vkEUO5/Ymsk+5HPkWqU2hbDYQmnELDbg2fZLoGS3hwrMFmcZLkvnunxWlLxlIlUt7wsPdApgrZs91qjf8tf8yMIk01Mf8byFxPAgOTVYid2jUafQdnXoGnHFn/3/EnWSk+pLUe8LXXXLgdC8nUOP+ofZGpt+4kMwuNpDDEb4Zzcsn7edawXIoggSvzGGM8SENT3maKmY9EBkWqPv/nh7T2wYmBxD425d3atsTF8ueHEM12v9L5UM7W1fbIu53nz/VKx9qimyAMXoro38Ie+WOdBuox6GUi6rfWP3RO7YVOK4RhSrPuzex0W7ZKpsryPW7GVTitaHOPoro/7dwhmV3l0lj/X/DrIs7Au8ZrMnPduI2Cz6IZR2nBslcUxU1zy3oqVJjcBd5fpRnjYKaM87GY2Mz7bmuN2zTri+aZCx1DCUgxJ+fE4w81JKTFe33cHmKOo+lVP518kn9QFEEF9AbKgLcK9y72LwA3+TXoF03GX23IgMePaw+5D4mDscfrglZqOAX4crxJx8ibLOA1ZhHMT0Mtfjc3fmQ17UY/VkagcKEBKH+7F5W80IhAgqK2dnvAdy8KLHh1csx7uuBi+Lph
 XEYHvbZT
 gV3RHGg9KE7coPSAnPCL+wCBW5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On architectures with separate user address space, such as s390 or
those without an MMU, the call to __access_ok will return true.
The soft-dirty test attempts to check if the PAGEMAP_SCAN feature
is supported by providing an invalid address and expecting
__access_ok to return false, thus throwing an EFAULT error on return.
Because of this assumption, this check will always fail for the
architectures aforementioned. Update the supported check to handle
the return being zero for these types of cases.

Signed-off-by: Audra Mitchell <audra@redhat.com>
---
 tools/testing/selftests/mm/vm_util.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index d954bf91afd5..3bb7d322101c 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -77,10 +77,8 @@ static bool pagemap_scan_supported(int fd, char *start)
 
 	/* Provide an invalid address in order to trigger EFAULT. */
 	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
-	if (ret == 0)
-		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
 
-	supported = errno == EFAULT;
+	supported = (ret == 0) || (errno == EFAULT);
 
 	return supported;
 }
-- 
2.52.0


