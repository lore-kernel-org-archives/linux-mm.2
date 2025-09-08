Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72745CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24D68E0019; Mon,  8 Sep 2025 08:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5238E000F; Mon,  8 Sep 2025 08:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3B98E0019; Mon,  8 Sep 2025 08:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 868818E000F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:48:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 398D4B54B6
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:48:03 +0000 (UTC)
X-FDA: 83866060446.06.7BB432B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84EF910000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:48:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VplicdhT;
	spf=pass (imf05.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757335681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6vWpjrE0Rlrrkbvt+KoFLxj2HD6byoInImyP0llvmto=;
	b=RNOGc2wx4GqrKyYuLbaLP/f9DcsjQQIku/ChtuO8ODgDKW5tB807Zre0/OLa8Y3v2cZKn3
	orYtP2aD7MEZwBWvegmMBoFU1Xbq0o7FCG2L1fONMtNk77NwJCcKiI0oE/qG2nH1xguNB3
	2c/AC3Rfg9yE0KMdUxPIwjurt9BsS64=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VplicdhT;
	spf=pass (imf05.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757335681; a=rsa-sha256;
	cv=none;
	b=iJ5tV96PZRhD6X7/mzWRO4IQmosMzMfoULGkXm4pkF0k0yIpYSLKR+Zv7SGF4eqDkSATLg
	kA1S6BfJ0itw4AcoIL0xDC6MFDBZBRz0Xsao8zo7mz2bW/kI/axOb9dTC6fRv1TSrDxRrg
	VIzq59/yt6Hdtt6jk0VpI8RFIJHJXjo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757335680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6vWpjrE0Rlrrkbvt+KoFLxj2HD6byoInImyP0llvmto=;
	b=VplicdhTlylJKiK7x5vsMmqHKnhe9CN5/bWXPGUDI0HOMFpJusXIGSBoUj8kaSh3om0pQr
	gp55x5CVR2DtQVSWj6w9sjbErLE2RxaOxj5K/+4pXH/5GnzsSMVzWhivRUgVuR35Yzdz43
	LIMgXl3pmPXuQ4NIQceVmwMTLRf6t8c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-61-sZyIc_KXMIabhP0a0tqncg-1; Mon,
 08 Sep 2025 08:47:59 -0400
X-MC-Unique: sZyIc_KXMIabhP0a0tqncg-1
X-Mimecast-MFC-AGG-ID: sZyIc_KXMIabhP0a0tqncg_1757335677
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 447971800357;
	Mon,  8 Sep 2025 12:47:57 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76FFE300018D;
	Mon,  8 Sep 2025 12:47:51 +0000 (UTC)
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
Subject: [PATCH v2 1/3] selftests/mm: fix hugepages cleanup too early
Date: Mon,  8 Sep 2025 20:47:37 +0800
Message-ID: <20250908124740.2946005-2-chuhu@redhat.com>
In-Reply-To: <20250908124740.2946005-1-chuhu@redhat.com>
References: <20250908124740.2946005-1-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: kx64c51mc4rirzaph481irh4bt1bz8n8
X-Rspam-User: 
X-Rspamd-Queue-Id: 84EF910000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1757335681-317370
X-HE-Meta: U2FsdGVkX19cKWOlsIYw2/zAPTLYPaS38aqOw8Jw6G+EwKT3QnNGwIHduQLJanLUnkbxXQJTO2ZDOIdRbAwP9nnm/29M47eDXK9Qbn0SQZdrtBqPheRIGsM71zd6hbQTHyxNIZEGULUfusElW3vAX9TCyHOXy+BnHko8iieQhoVxHniSe/wsSKc0gRZ0+6qCot8ue0dKNJHTewcdMwatMnAR/qz/J+AYHXgbKdym4QLIgg4jDgyfCkzgfX9zH1kIbXMqrw4NSnxYFlxvj8dBLchwU2CTsMpJK/dlVg4gC1TleM4x1skZUO3Wx8mE4MFTAmnnqlmvpOnD6eystGpPIZUypKnBGqgckNWIRzhspnVREaKK5FOcq+SSqMR+2yL/P7XpeyV2RoIDQzshYqStg+aQb8IfV62nFMA7kFSxnPmPVqjnZVaKJMrq6BKae+ktfnbVFgkFa6QqPFNchxVNS1y7AFkPLsE8nPAtyJhpANkbKrdEDR665wqc6u63x0q4WmDiiCGMW24hPu/MNX0fahYFVE8kEdk4v4UUwC7u2HUHelP5SMKAT75hlqdOPaNXrppdNtJFV0X9GYa75EOCDeg+j8WGRJp34GOm/2G8XM/ibjPL9oYyPx0S2SFzVz1ZncFlrovH/7YNjxQ9WKIWNIfp+pag+dwn6cYITk2mNlXGe5ZfZNa9esKbQHempBGc7Ql75Ooqisypw7HWt8vFqYPUvAS5cPYHLbumA9aBrG3JNW8HbAFW2G6pMaHC2qcKv6A0MrYg4L/qYpfv5HPh8T3VNMwecAAlaOcEgqs5gvGEDr9WFFQyfl/OJ9VolGn2GPlQdxkNa4gKPUxmh3lAL2U3V33rEFcYrlm+bi4IzAjizIli7FX7IonRNljvBFWbWePVPOv7WNZ5+GPAfl2fMr2TM8oQcWqDA70G0PXH7X/JupUYwIitTFKt5J+cLuk9xMwnTb40/aMCq7XHjhu
 IV9qTL8L
 L8i9Q9EqntsCreWsFz6ikr6wBfoa2pqygJHMAORj1c/kDHY/x7psyYOy6uXUBoRsYcx1USaYQL7lqNsl33SsSH2azS0Ol2NjGdO+etLdg9ChQXaP7on33gGIOBg0wmOXEB9lN18x2pPZ82v2QkH6Y//z3rNjKscp3z1LQ8K+s8cNMU6NAlzCfNHpq7DBR7WXaYF1GUxC4rqncU0fmcF9lYGU/4svJHdOhA0DOJ6OjXs3zi/8h7lkHv2OmIt+xcNefa1ESjsaXjOhyQNAiWKv62Kkql6fu2e1lrVEPasNvx9glp/0fcutMQ4hOVpCEy7VjrLxN8qacpf+QqmQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nr_hugepgs variable is used to keep the original nr_hugepages at the
hugepage setup step at test beginning. After userfaultfd test, a cleaup is
executed, both /sys/kernel/mm/hugepages/hugepages-*/nr_hugepages and
/proc/sys//vm/nr_hugepages are reset to 'original' value before userfaultfd
test starts.

Issue here is the value used to restore /proc/sys/vm/nr_hugepages is
nr_hugepgs which is the initial value before the vm_runtests.sh runs, not
the value before userfaultfd test starts. 'va_high_addr_swith.sh' tests
runs after that will possibly see no hugepages available for test, and got
EINVAL when mmap(HUGETLB), making the result invalid.

And before pkey tests, nr_hugepgs is changed to be used as a temp variable
to save nr_hugepages before pkey test, and restore it after pkey tests
finish. The original nr_hugepages value is not tracked anymore, so no way
to restore it after all tests finish.

Add a new variable orig_nr_hugepgs to save the original nr_hugepages, and
and restore it to nr_hugepages after all tests finish. And change to use
the nr_hugepgs variable to save the /proc/sys/vm/nr_hugeages after hugepage
setup, it's also the value before userfaultfd test starts, and the correct
value to be restored after userfaultfd finishes. The va_high_addr_switch.sh
broken will be resolved.

Signed-off-by: Chunyu Hu <chuhu@redhat.com>

---
Changes in v2
 - rename nr_hugepgs_origin to orig_nr_hugepgs
---
 tools/testing/selftests/mm/run_vmtests.sh | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 471e539d82b8..9866e4221bc2 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -172,13 +172,13 @@ fi
 
 # set proper nr_hugepages
 if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
-	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+	orig_nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 	needpgs=$((needmem_KB / hpgsize_KB))
 	tries=2
 	while [ "$tries" -gt 0 ] && [ "$freepgs" -lt "$needpgs" ]; do
 		lackpgs=$((needpgs - freepgs))
 		echo 3 > /proc/sys/vm/drop_caches
-		if ! echo $((lackpgs + nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
+		if ! echo $((lackpgs + orig_nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
 			echo "Please run this test as root"
 			exit $ksft_skip
 		fi
@@ -189,6 +189,7 @@ if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
 		done < /proc/meminfo
 		tries=$((tries - 1))
 	done
+	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
 	if [ "$freepgs" -lt "$needpgs" ]; then
 		printf "Not enough huge pages available (%d < %d)\n" \
 		       "$freepgs" "$needpgs"
@@ -532,6 +533,10 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh aligned
 
 CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
 
+if [ "${HAVE_HUGEPAGES}" = 1 ]; then
+	echo "$orig_nr_hugepgs" > /proc/sys/vm/nr_hugepages
+fi
+
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
 
-- 
2.49.0


