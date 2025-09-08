Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EAE6CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3EC8E001A; Mon,  8 Sep 2025 08:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB558E000F; Mon,  8 Sep 2025 08:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8F78E001A; Mon,  8 Sep 2025 08:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BED0D8E000F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:48:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DE4316011D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:48:11 +0000 (UTC)
X-FDA: 83866060782.09.2650BB9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id B880F1C0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:48:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B20qYeC3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757335689; a=rsa-sha256;
	cv=none;
	b=GPnLkNzeTrI1vBop6Vsmj2hS2jWatEej0H57YWdNSDvz+Qg5iMmEvaxF/yhLwMZuyAONEO
	Kc1IPPvxQ/FE8gZf+yKqLWlENiEgkgXr22AP/rjhk3gO7FGqI50R0B2PCHIt8jKq5jtQSn
	D6jo7PnHaRMiTsdMuuA+M1AtcYlJwMc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B20qYeC3;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757335689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLbuXhCNUOaSCGuiLR8P48OXtpr7aN3m52JVUEWvATc=;
	b=m4UHH32bnEHgsxyc2C9U9UUL2YOySvA2girMrEKUBuUtwUpVJEPLO52OTitibRM4cLhXgw
	Deu3RzSk+CuKuihOjeF51qG6Ehuf/0wHNhkTtlud9fvyHBKrWANmYooSC/INxXE6lX49E+
	+C9BtpUZhBXQGBhOE2XjxzsaxGVAg3g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757335689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MLbuXhCNUOaSCGuiLR8P48OXtpr7aN3m52JVUEWvATc=;
	b=B20qYeC3NWH0YBRG16r4CjGtFIOITX8wmoVB7CeYOlaai8iFakNXK9QgYP8+sb+0jnponU
	kFLbkkZNdDTjwc1N6oIUa0DJK3O5WbfPNxhFdlkqjjgr0JQvdQpUBRau7tCUC/IrFPnY+B
	iJNBSXzTjSJDiCHkiOVUvutiq03FsZE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-312-Mj6eiP3BNKKdj_HKkAuYjA-1; Mon,
 08 Sep 2025 08:48:05 -0400
X-MC-Unique: Mj6eiP3BNKKdj_HKkAuYjA-1
X-Mimecast-MFC-AGG-ID: Mj6eiP3BNKKdj_HKkAuYjA_1757335684
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05677180057E;
	Mon,  8 Sep 2025 12:48:04 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31F3830001B5;
	Mon,  8 Sep 2025 12:47:57 +0000 (UTC)
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
Subject: [PATCH v2 2/3] selftests/mm: alloc hugepages in va_high_addr_switch test
Date: Mon,  8 Sep 2025 20:47:38 +0800
Message-ID: <20250908124740.2946005-3-chuhu@redhat.com>
In-Reply-To: <20250908124740.2946005-2-chuhu@redhat.com>
References: <20250908124740.2946005-1-chuhu@redhat.com>
 <20250908124740.2946005-2-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B880F1C0003
X-Stat-Signature: srwyfiwdt55stof6ci5azxz9jfwy6a4z
X-HE-Tag: 1757335689-954553
X-HE-Meta: U2FsdGVkX19fkYci1ZGyvi9/4sr7xGgxjaKd5yGAJCat7EeCVPczEVfwAIs1jsBRRuBIhmeYl/MwP4HjeAR/AplSJxVuq6mEhlBzoS5Nko8Zto5uS0oiW9CVOCbtB1dE5GqXQbjbq0Z839JTpaBeJE58uG90gIYCxG8hrf7/Z4oq5oftd+jHeSim/pwC731xXdNB+X+JDR44lZd1HKO3UttExLXOmkm8UbSPh6dz8xHQEbVpdz4hiq6ewQuudHaMa3SQepX1DKXJxt03IJ2oESXQxdPyId3WM5l5SMKwC1k8aQ8ONRY1vE5ZPFX+5PXhOw3Xon1HCA7AzWot/n8DAZHLEQbZS/0fNhXegx5pqXqkoReMBiMw1aYaRh4FccfsYbHL7aG5His7zW5t7ijUDalZn9GrVIpT0QLO93ztNFFAKMfUqxTlzcIQjYmIcmD57pY9mpsyvc9ZLsvEnXNKsWjzW35rYRNsYwdBD+JF73cucMckkVHoc/G6EFOM0K5iXWKjkAhuzjhpsvhZRzNb2JSt+Fikx+cPstHGBLffGOeQfqKNiJFNAS5DqIUaH99X75je2m4I50edbpre/Tml1L3qWJ2oxtjQC4cioFcqcMAQGPVNRmSI7Pr2SK83fUk301U6ZVwMnZ9uc+ZGvZt2pfAOkVHXfetTJytQxiRgZfp8XmfcpnN6lmjGjsJh+wPPSposT0Uc6AiTtqnuwgr5VhtT/G3mkekBg8AH/Uqr2RFi9tYnszTC0LEIOsL29u9aCZqquuRhlpuk6CiycgZ+HLsGWNvzuARaBmpvCsNbDdLjbi+uNoHyHNkk0jVmeThUAEFsQriSYxs9RuR/n2xeO31HjPPluovZp846nQWJ6hINVwD3FeIGvdktO7aV4IFvDlZzpX/XS2P6Zn3PwHWxJ0Gveibn/3guJovocSv5iD94XpAcIHYitfqKAwUcLaEoUliSc8mciLB397PSkZV
 cFofICVL
 GqM7Y/DSJlaPkpJGaTaGo90C39G6S9OPwrkT1h4ZxJqKU6V89S9O//MUm94eqO54B8V9WINCwhRQb8n8kWWuu3mFpbLo69W6yBMfkLgJtkZCc8GGA3sTBxdI8I0m6I0s7Kl1abp+zhNhKMLK/FZ1MxuCdiq1S1daOrQ/rpSnxKKzkJ51rVRAhio7Aja0oX6lLfGcNaI2FPyfpky7mocoo/nRLKwUWTobCLGCbfW5HwUIi37C2WVfzHxN8Di87aWKdezaze5qcce9OTyReN7xoHhh5HTSsztJSaqF//DDbMaNW04hKSmPB/s/Wu/XLqPwFwcgz5cc0C+BsUBAGE7j+ff9UsSnxR8cfQWPS0Mz18bG6iPTb05vPzla7fFmdKIsAQATAYTzP1ywZFCOKTpkvS1NsoX3PQYiofhkY
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


