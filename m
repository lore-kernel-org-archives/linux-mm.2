Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7389DCAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 01:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6F2D6B0011; Thu, 11 Sep 2025 21:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1DDA6B0010; Thu, 11 Sep 2025 21:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6AEE6B0012; Thu, 11 Sep 2025 21:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 88F336B0010
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:37:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 578C41A0619
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:37:43 +0000 (UTC)
X-FDA: 83878886406.28.C235B3C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id A73E7A0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:37:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PpDYoJYl;
	spf=pass (imf25.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757641061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLbuXhCNUOaSCGuiLR8P48OXtpr7aN3m52JVUEWvATc=;
	b=25kbit6TEn0Bqa+b1wa0tSjX7ySb+n2ANJKztmvzQsLjPwK1qMf+obm12JxEDWAXunHYPg
	U3x3vDA0PLPQIguJNnz4l6vaUsqOBC63ZwIILhEfWCDSMntF/IBiJqNm4eIap2jNkamN8i
	vo2YxTl5bdRi5Y639J1bbXlxscrhLcI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757641061; a=rsa-sha256;
	cv=none;
	b=2y4g+IbITy+WvrGFQaSeubxnRJtB+dbDsK0y1t4wEsDZ8xAhN9YOv0wSeGe/GqDFcv76pY
	aXzCHGPOfRNhEyQNw3vVyFk6M3i3AQICI7/DWeyDBoWB/9eVE87j2wfoaICIm5vw0HvX+Z
	5t2jEVn2s/r/wowhuej5fz4jwM46p7M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PpDYoJYl;
	spf=pass (imf25.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757641061;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MLbuXhCNUOaSCGuiLR8P48OXtpr7aN3m52JVUEWvATc=;
	b=PpDYoJYlHs4ezVakjmad7JvTCeeCNeqqpG1c9OJceBxDnQ/IujaVOnlARM1BO/UTbRh106
	LfPQt4vJ9tVS39NsTZOKYAtDPCYEj0h+ZiLuyilY+WNE5tTObmBgnCyDZv9YZwnQ8C9S0J
	sul80TNyRMcXksIvR/59GnW9tfLv4Bg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-CIga5bGjOuq_NhGaIzdmDw-1; Thu,
 11 Sep 2025 21:37:37 -0400
X-MC-Unique: CIga5bGjOuq_NhGaIzdmDw-1
X-Mimecast-MFC-AGG-ID: CIga5bGjOuq_NhGaIzdmDw_1757641056
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E05641956087;
	Fri, 12 Sep 2025 01:37:35 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 18FDD1800452;
	Fri, 12 Sep 2025 01:37:29 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
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
	chuhu@redhat.com
Subject: [PATCH v3 2/3] selftests/mm: alloc hugepages in va_high_addr_switch test
Date: Fri, 12 Sep 2025 09:37:10 +0800
Message-ID: <20250912013711.3002969-3-chuhu@redhat.com>
In-Reply-To: <20250912013711.3002969-2-chuhu@redhat.com>
References: <20250912013711.3002969-1-chuhu@redhat.com>
 <20250912013711.3002969-2-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A73E7A0006
X-Stat-Signature: ccxb7qkncnqpnzghqjszq1oga74tirs1
X-Rspam-User: 
X-HE-Tag: 1757641061-780957
X-HE-Meta: U2FsdGVkX1+KDpi0Wcy0YkY/wUaWVuqUq0Xh4H9RjiiaOQXXIDc97tSlIAxLIYDh+rQVQ/2Sl1eIomklYWXcYQoATbw3OwKgqiRR5obDWbgIFlm46hj28Pr8l1q1oj15TWDSq8aC/bf7efi7cmV4rT2Xbv/soZurJ6yJXDpRU35KmBJeVK/qxoxKH5fWoi3Eo1of7fzYxQ2yK4GwYpdrAESzc6zl7bmknZ7LYpU3BBElE1EjKPKe3Yl2Zxa2gu06S4CzEftqWKdDkL3t4K5Gw2O4xomX+xGPpQpr5jX2sstmZH5u7ovhkl4MRdzArmFqwRfTG8YZ1iro0xUDURBOzshU8+jjAQBsjVe12o0KbnRukMC7uXLAi5LOOhc0Ipsfl1SpJy4XpMgfKOL49o7bGlFaMTzRIYs8GsQx14ZRjSTNojB3hsvC1F+4gLtupTpTtME9u5rPH8XKg0vv5VNchF50Wb73LPqR9c2ysJ7lPyNGb2afIGwDVUL+jtALptQ6lBv2I/LL8kgVpx1VKLk/RaayO0dIvn1PP1QASYoesHBAVvgqccW6pUT3qpdwMqbk1rcAMW5wnmtIE30bihj+CFj6HMmL/bSSYFidcoPh7g45cxuRd07MZg5aBpa+NHLBeI9+xSzc8oX3C96bjeDl5qBQhtQ/S5qccq7GVB6nVrfxq7bkMQOniuJ+Wm+WT2h0PCPNLoKQEArRN0835Qi7h2aWQZIuXC2bZvOxTBj1y3PkLntIjNRjf8ncabqr4pge8dJGWvTPglZ1oZQTDE4ckHqBTpeHKcGfolqKRovrINlj4pPu1iga1S7nanIfX9krz/CrZPX+4zmsHJVrvBa6OmzY5Nc4UIVLtbrMAyzJpeHAwZ0cYyyH7YNv1WPCU+k2niV/WyaifKBWqK4YMc8qwtcAuuZjb0yB1r6X4Wj7KdHipa/I/xbo5AopRnEEnJTOz4vhpW3LMiDs7MxpvH0
 o3K7LGRw
 UMctdkUX3ExkS+sZzfuxxhmyTmQQNDZyyqHEouTzWjB67oPcm8aw02I/S24D9oYvv+QDWQmtE16Sq9Cp5Egilkh5Ie4G4NCziNAoyyhQMh9TTB+yQhEobxSyhqynQ/RLZxon66gUBXdamlWuzs1Hp9AhgEL9kHE6c+25ud5Mrd/3mOdOmoVPFpasnOSCw0tRNnjE4C2MjGHSQWbofBEbg/v4D1AuQNNRBreGOLlTCu4+EmkTP8Cy3mmPYgt5a1ELjm2yIWBgAYJOZdJUqPg7vjB+1krKCI/2oktLGNXkls0WjWBh96CCaZXnHrpArUZLOk7HJ06/nFwLsh2o6pqMAfnbmrUpaxNZZZmhtQmWWe2tliGXqzAMvSY29J1Dkk/g1OnsBglcT13xat8zpez2G3D9lCU6QJDCqCubW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alloc hugepages in the test internally, so we don't fully rely on the
run_vmtests.sh. If run_vmtests.sh does that great, free hugepages is
enough for being used to run the test, leave it as it is, otherwise setup
the hugepages in the test.

Save the original nr_hugepages value and restore it after test finish, so
leave a stable test envronment.

Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 .../selftests/mm/va_high_addr_switch.sh       | 37 +++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
index 325de53966b6..a7d4b02b21dd 100755
--- a/tools/testing/selftests/mm/va_high_addr_switch.sh
+++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -9,6 +9,7 @@
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
+orig_nr_hugepages=0
 
 skip()
 {
@@ -76,5 +77,41 @@ check_test_requirements()
 	esac
 }
 
+save_nr_hugepages()
+{
+	orig_nr_hugepages=$(cat /proc/sys/vm/nr_hugepages)
+}
+
+restore_nr_hugepages()
+{
+	echo "$orig_nr_hugepages" > /proc/sys/vm/nr_hugepages
+}
+
+setup_nr_hugepages()
+{
+	local needpgs=$1
+	while read -r name size unit; do
+		if [ "$name" = "HugePages_Free:" ]; then
+			freepgs="$size"
+			break
+		fi
+	done < /proc/meminfo
+	if [ "$freepgs" -ge "$needpgs" ]; then
+		return
+	fi
+	local hpgs=$((orig_nr_hugepages + needpgs))
+	echo $hpgs > /proc/sys/vm/nr_hugepages
+
+	local nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+	if [ "$nr_hugepgs" != "$hpgs" ]; then
+		restore_nr_hugepages
+		skip "$0: no enough hugepages for testing"
+	fi
+}
+
 check_test_requirements
+save_nr_hugepages
+# 4 keep_mapped pages, and one for tmp usage
+setup_nr_hugepages 5
 ./va_high_addr_switch --run-hugetlb
+restore_nr_hugepages
-- 
2.49.0


