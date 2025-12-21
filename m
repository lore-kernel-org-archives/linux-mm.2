Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B260E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 04:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85A386B008A; Sat, 20 Dec 2025 23:00:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8043E6B008C; Sat, 20 Dec 2025 23:00:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73E5F6B0092; Sat, 20 Dec 2025 23:00:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66A526B008A
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 23:00:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BE75BB2E4
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:00:57 +0000 (UTC)
X-FDA: 84242127354.26.E58ED03
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 45AE8140012
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:00:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i42Kym5c;
	spf=pass (imf26.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766289655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OuTqlXVm7Xbaoka1UUOwUzXkQyIXMABwtwnWJk5BYmc=;
	b=kikf5Q1JyBchiV9LtiBrtk7OTD61XLMwXx5Qk9z1qJt4Yt/rPShujLWXMLSjYoSNkZmjKl
	gAgxjUY6zDeZLmlx4l38ESlakiEfeRkG1+6Wd163YhnsdgpcRk6pVYtOhsxoe6L2FICK6R
	GzGtsGEX1qvw6Sle9ESvzz32EsYlq6M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i42Kym5c;
	spf=pass (imf26.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766289655; a=rsa-sha256;
	cv=none;
	b=fwKHEA6p9jFY5dfhRvi1BFXCJ0tt8esPcPnOZQbIKVT/++yMcblJmLX4JZ7DijvGms1ddj
	NWb7mDepSPrhjpIOFYnOCA4AKXeIOstnUIA27lwAg/Xe+3/vAwURd/97Tsk7+EJBBrL3sN
	rNjZTwJ+tCzY6KDsDqRWJksKFcLnsj8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766289654;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OuTqlXVm7Xbaoka1UUOwUzXkQyIXMABwtwnWJk5BYmc=;
	b=i42Kym5c4I7u4MR1DzW6e4XoXzqGUj/+VYkQZTaP/TryxR9f8sXwQ3lOgADMyTr+g421dq
	y5P7ap9/HhnBaKDBNaI/KljyOZ8WwnqwexSNavrlZ6XVw5Luza530Su2g4XTGtXKXyg3d/
	pFvZkfnYaSeEXzluLzDxF/s72GZC7yo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-EzY6I9wwP4KywXe6B8qxeg-1; Sat,
 20 Dec 2025 23:00:51 -0500
X-MC-Unique: EzY6I9wwP4KywXe6B8qxeg-1
X-Mimecast-MFC-AGG-ID: EzY6I9wwP4KywXe6B8qxeg_1766289649
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6EBFD1956088;
	Sun, 21 Dec 2025 04:00:49 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA32019560B4;
	Sun, 21 Dec 2025 04:00:43 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chuhu@redhat.com,
	Luiz Capitulino <luizcap@redhat.com>
Subject: [PATCH v2 3/5] selftests/mm: remove arm64 nr_hugepages setup for va_high_addr_switch test
Date: Sun, 21 Dec 2025 12:00:23 +0800
Message-ID: <20251221040025.3159990-3-chuhu@redhat.com>
In-Reply-To: <20251221040025.3159990-2-chuhu@redhat.com>
References: <20251221040025.3159990-1-chuhu@redhat.com>
 <20251221040025.3159990-2-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: 1fawcktieeb9zd7outkethcys8ym4dcc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 45AE8140012
X-HE-Tag: 1766289655-855088
X-HE-Meta: U2FsdGVkX19SusphWvURkcDFIztJlbS3BajwArzqTz1yzK0i6IkL5ulmGj5efJwa4uXqNZxWIp2Q1ty97HYdNAdh8EFgV/ccS+mMJgP9gyqhhfqpaX/qblDFEj4+YykRQELwkDUpz2XNqOtM+HhIcpWKlTyTzlBfy1cMC/jqrk2ONCcqUFD6DgVKUDGYVfFB/nbdfHhicsFDXN64cks9MN5817+2qSUaWyOGtRJtemxwheit//4nc3jyNoKHlSkI7wFBxb3uV8q3USwPkdWrB0afQUlVgA6/rsURgW9lLy2wu0r06FDKCKZfhEGGi76rn6PVWwr7tBzEvZKQB0f+n3ututZfU8LJDIxVNhCBOdy0dnflA2sP+gnWnaK5MpiR7zfk6phEWXWUrAc5v2O9WeLeNPKwtLiLmOTeWhSR5Cdz0LrDORHDkYIFTSLafpIMmTwcA+1+QptykzqBrjCMRQf67lNl4OjVC/9IPJtZdQZb2BrJXRRzQDanUl+LQfEv5xTKEFk2u+BsJ4mDYUS7WyEBMyeFJEbEWCTBthlPkRVmSh4UMZdPjBwWPiUWMPz7r03W4pFZK5gmveFBZMzL2dJhVs796eUVfc6psjmICj1O+RtnoGhpirEjkN8KDC9C5V9mbGTlBQJHXPwxNyEiisBPnUCsXI/GBW2VaHsboxozsqgoW77FQlNgzslQNqIL/qVqpNdEX7Foy7o4Y4YXDPqslFGRavBnIvBsL8y8x/aQ7tPVIOvy3Htd6I4USNkOpZyNCpFlfJUO3EXTcuiE7fnT9vA2dQkNXun9K5j/PR/Iksu6JIzBRn+1gzyY/c82yLXNcdWfp0+seWbPeQH91f3MVaG0pwtssTLoD/SCxbljszFOtn4RezTRb/S6va7Y5A5LRHIgYMK1IVb5J0w3fRYAlxZUc5lk11QpIyGSSB338jfqMRLtnaH6aTc5vAfru8UD8eNzewkFdPClU0c
 O3FvWjys
 88gSz6vDChU7sNXOsPT78jtjOE/vvH0V63WjiYgewUcZdWrzu4H4ZSjIHT607uI2Y6F/6FUN3VvxpkTX3xX/RG02y3yDqqJDlar+qtp0v5CvSLAjfp4srpbIKShLhnLgAkHPSilT8J1sGBPX/B2XGFl95oI642kCQmwkSu3FnsT2pFaakKMACJ4QkoJ8axogMNyKskFOOQ0QAFHvRHn1hGl3/9Gioq55sZ3pXTSO8KHq9mQ+FNTNCDBHuGQawejPmrSwVApNTAeyW2OfSzPzoyyqJFg2PHXQDtVXUlciD+4+ac919Cvt2KzD5m0wo5yyapkWR+a2V3bcYfsHIIt876O0EreCoK2VM1eupqW5DTOYoq3Egb0QGTcxSEZnugATD1+E+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arm64 and x86_64 has the same nr_hugepages requriement for running the
va_high_addr_switch test. Since commit d9d957bd7b61 ("selftests/mm: alloc
hugepages in va_high_addr_switch test"), the setup can be done in
va_high_addr_switch.sh. So remove the duplicated setup.

Reviewed-by: Luiz Capitulino <luizcap@redhat.com>
CC: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d9173f2312b7..2dadbfc6e535 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -412,15 +412,7 @@ if [ $VADDR64 -ne 0 ]; then
 	fi
 
 	# va high address boundary switch test
-	ARCH_ARM64="arm64"
-	prev_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
-	if [ "$ARCH" == "$ARCH_ARM64" ]; then
-		echo 6 > /proc/sys/vm/nr_hugepages
-	fi
 	CATEGORY="hugevm" run_test bash ./va_high_addr_switch.sh
-	if [ "$ARCH" == "$ARCH_ARM64" ]; then
-		echo $prev_nr_hugepages > /proc/sys/vm/nr_hugepages
-	fi
 fi # VADDR64
 
 # vmalloc stability smoke test
-- 
2.49.0


