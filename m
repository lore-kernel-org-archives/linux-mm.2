Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A91DDCA0FF6
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 07:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66698E0128; Wed, 27 Aug 2025 03:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1278E0105; Wed, 27 Aug 2025 03:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A058E0128; Wed, 27 Aug 2025 03:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72EAF8E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:52:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30789B9DAD
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:52:35 +0000 (UTC)
X-FDA: 83821770270.18.7D6AEC8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4F7891C0006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:52:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cmrg/0v1";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756281153; a=rsa-sha256;
	cv=none;
	b=iJRhVbrkNd2QL4S0XlGwNuxpTu8qVT1xXyO4dy8EutjUNbZ2NqhJGgqgy+ZcFY2/2ZX4Dh
	d+H2K2mYuQb4nigxJ0McPNzgFrBm/fnI9gBsP3sKRYobBxa4ckTY0O5TZDqA36ELW+ZSBj
	oiwltTzxkRvXB61ej/1G+Y0f9e6hBYE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cmrg/0v1";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf18.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756281153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=setaN7UuCRHebEKosEpjDVQatSVNSFpocE9Z9Esxu08=;
	b=OzuCfU0IK0TrDEWA8ziLwaqnm5VX+DeraV65ooOj/jjMU7CyfVfhymhWoH2tL856N2TLPx
	c9RWVP5784adtj7hUyhw61gRjGMOb3qwDMpBvg+Qo4mtEn7XVM0/8rqg/OGvlGv4MccjoU
	x6G9aAfQP2EVOnTAJJgmCr9qrVQB668=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756281152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=setaN7UuCRHebEKosEpjDVQatSVNSFpocE9Z9Esxu08=;
	b=cmrg/0v12tMnV6CG8pGsNSPw0S3t0SVe+6wgJ4CX7DntKVJDNBtk+TE1nowx0DjwQzQEWw
	FOICpdmCQF+7W+Kj9A4AWR1kVoUMf6hToQ7I1vBO8qtiHmuLRlVEHQMqjhGsz8ANko5PAS
	tjHAnqSB9FQT6YTmiZqJUj6ifVmRrP0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-dWY_aDrQNrWEH9T31cU6tg-1; Wed,
 27 Aug 2025 03:52:29 -0400
X-MC-Unique: dWY_aDrQNrWEH9T31cU6tg-1
X-Mimecast-MFC-AGG-ID: dWY_aDrQNrWEH9T31cU6tg_1756281147
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0489819541A0;
	Wed, 27 Aug 2025 07:52:27 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1DEF2180044F;
	Wed, 27 Aug 2025 07:52:20 +0000 (UTC)
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
Subject: [PATCH 1/2] selftests/mm: fix hugepages cleanup too early
Date: Wed, 27 Aug 2025 15:52:08 +0800
Message-ID: <20250827075209.2347015-2-chuhu@redhat.com>
In-Reply-To: <20250827075209.2347015-1-chuhu@redhat.com>
References: <20250827075209.2347015-1-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F7891C0006
X-Stat-Signature: dukjst3cs7z36r7auz4ga14m4y1rss8d
X-HE-Tag: 1756281153-409223
X-HE-Meta: U2FsdGVkX1+feZmFojGII+pAHtOwlWtjAWRoyGOWuwamgOFnQtcJibMdHf7oFuHHvbgC9Clzb3UIBjBlz95XiyMjdSRmU6Su+f+f2DtD9nHFxodmZBo2mpS7bDFeVzHopoAi0svxKCiMNWXLFjEQIwsIe8rFm7tzhf7vkS+E9lNpNFSfk0RyKVez8Xahc6m3xZUhKE6ipWSmIXhC67tQwCoBE2RvYtwzqYLrIqh556esU1HqKTxKfVqO9nYtc8yfydDA0gr+8QmgYg+ShgJbgyP8y7NS09oCM1qFQpsC/6a1ypOOKsfBq70wn1ybyqhqaP7IbBbuYiiiQHiIkev+f61SrEN75/T9Uuirs2b29vPB3sOWmIJQFWGcooYI1ug1iB1fzt8q41v1+mol6GFLsbN+O2Ftaf2Jy94yeFT6e90jxUlpYqXpH7HinalP1bV+v6xQiTq9mJtCJwK88qror5gXEgYA2rVbi+7T1bB7ne9JO6Bn3gpx+MUZMyAG7NxRtdKEBvFEgvm0TbeOiNWI6gQBZXnZSL1lHE6J4aPO1skPdMimIHBPsXRXTK4HfZ8XTEFwhsXW1wXRBKwdyZnUP/zMY4J/G+31pmKgec0rIutN2/R+5pw2tPG2HRqf6UZXCGItbKvKCGFmV7hugXNIQd+CXrJk79GqdCN1qzIbxegkXtSfwyAde395ounJhdR8s91CEfYKfWO9OowIKjRxTdbVFzc0iXmH/dGDA0cVt4/BLSfXwYtcqaETE7nOuH5SEVutTEbd6LK6khy7eESicWsd6IDUITnBATF35Eq+yhYLFKRrGfMa9dwki4wr/j1z+i3el2T/RLkizVT+RPSuQem8vXVv9irSiFTeQWkDIWeTBdDH3U8logKrRrqxR1ixv+XIAurldsUu5mxCzNJYWocWs2MaoseYxjg6GpyqEWOfbk21oUPbjzzezrSpPZFJqSzgtJWhdLqqhhDAgg9
 9RZv9gRo
 AEjnt5cxgvb6j3a2r1M7mEyp6l1uBOJWRk7pwksXGJGbBE9jRMBVIawRlh+08wDCaHGgZ1+nr91HK99UnwkTG5qQKOIyLkL1mX9LDY3IWT7sfko/b/a47rFOGTrKRVDuiFwB/Xh86taG03K9HrZeuKndUv1SBy/HWRtpIXNtTGY3Nicp9kJHn0Ao000TE/pnycz4cVmRgVbn01QhGs2v/16luIYHrRvZ/FhzZCHOkfupvC8eNjOKilRLx32MM56Plc1TxY5XHe/qs35t+BtJBFphkkZ2ZoET5MdVhSMDV90yxkIDCK+ASniKCk91H38NrvaW13du638d1KrI=
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

Add a new variable nr_hugepgs_origin to save the original nr_hugepages, and
and restore it to nr_hugepages after all tests finish. And change to use
the nr_hugepgs variable to save the /proc/sys/vm/nr_hugeages after hugepage
setup, it's also the value before userfaultfd test starts, and the correct
value to be restored after userfaultfd finishes. The va_high_addr_switch.sh
broken will be resolved.

Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 471e539d82b8..f1a7ad3ec6a7 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -172,13 +172,13 @@ fi
 
 # set proper nr_hugepages
 if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
-	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+	nr_hugepgs_origin=$(cat /proc/sys/vm/nr_hugepages)
 	needpgs=$((needmem_KB / hpgsize_KB))
 	tries=2
 	while [ "$tries" -gt 0 ] && [ "$freepgs" -lt "$needpgs" ]; do
 		lackpgs=$((needpgs - freepgs))
 		echo 3 > /proc/sys/vm/drop_caches
-		if ! echo $((lackpgs + nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
+		if ! echo $((lackpgs + nr_hugepgs_origin)) > /proc/sys/vm/nr_hugepages; then
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
+	echo "$nr_hugepgs_origin" > /proc/sys/vm/nr_hugepages
+fi
+
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
 
-- 
2.49.0


