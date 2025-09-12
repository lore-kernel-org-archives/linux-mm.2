Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B718CAC587
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 01:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53BFD8E0001; Thu, 11 Sep 2025 21:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED096B0011; Thu, 11 Sep 2025 21:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DBE38E0001; Thu, 11 Sep 2025 21:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2718B6B0010
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:37:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6C3B13B6E3
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:37:42 +0000 (UTC)
X-FDA: 83878886364.19.CAD68FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id A972C180004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:37:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JDDxuRCn;
	spf=pass (imf24.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757641060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5xVT+DP3d5xsBvfGpUvEkXmr3BNbIxY0gg2qMRV1Cc=;
	b=YcIIio4zIBwv6D6yNZlPU0ZIy/ng+4uUgE6UJtvo1sjSHngcU6dO52QpAqhVkkxKqeCMzC
	m76efyVeGBZKNL8SchQy4cBgOQ2ETxdpGwzzsU8bmO6yFBqnGje+2pTaOk/nLGHEmSRW3G
	Jq51q4OPE70Paf5xQnB/BikHP54NsrQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JDDxuRCn;
	spf=pass (imf24.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757641060; a=rsa-sha256;
	cv=none;
	b=b6FBYxxXEavLQT0oZJTNvmCM3h/1SgdlGBWN32qlmJlttm4+cqANDlm711wTAEret4pKyF
	G2s8sRzO0ouCLaGu9bxnc5214gP+31CIoh2Dw2TBWRLgOtNiaFMLlxGM/LP5krHNlkkR3O
	mMfxZvFwvCQOC/NBmVksGs1HUobbd28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757641058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j5xVT+DP3d5xsBvfGpUvEkXmr3BNbIxY0gg2qMRV1Cc=;
	b=JDDxuRCnYDBN+iY+KYDBlHyiZyx1sswyB9RwCoKNG1ZSrCJ1YD0rypmIL0xgp/QxZmOuBj
	hYIW99f1eC6i8pRjBZZhpibHU8+aWL/MviBSQ1Ma63ZVvckfETMU7UJp7tFVDSL1b6t1cW
	V5rqyt7SinH9/uVj+xlFwSWa2TGkQZI=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-VSqiy1hoP32g2QuHsqAzrQ-1; Thu,
 11 Sep 2025 21:37:34 -0400
X-MC-Unique: VSqiy1hoP32g2QuHsqAzrQ-1
X-Mimecast-MFC-AGG-ID: VSqiy1hoP32g2QuHsqAzrQ_1757641049
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 283EB1800562;
	Fri, 12 Sep 2025 01:37:29 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A72E1800452;
	Fri, 12 Sep 2025 01:37:22 +0000 (UTC)
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
Subject: [PATCH v3 1/3] selftests/mm: fix hugepages cleanup too early
Date: Fri, 12 Sep 2025 09:37:09 +0800
Message-ID: <20250912013711.3002969-2-chuhu@redhat.com>
In-Reply-To: <20250912013711.3002969-1-chuhu@redhat.com>
References: <20250912013711.3002969-1-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: A972C180004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9pxnt1hkkzx8c3nx5fy7cxyimwzbcrbq
X-HE-Tag: 1757641060-571295
X-HE-Meta: U2FsdGVkX1/xhaPWHbWvSz3X2Gj2JIEBnByzoeUa7UrZlEkh6ZKj7yTQqXzT0wG6zZUskCFiJEIbTw7KGvGnpTyl0yg1LOPQkQtd4yk5k57S7fOT+M1y6S/ivgidYZ2rfIbMDxPqXApUE7wfGXkaL//KBGEcjO1f/JulLKXcfgfZRZsydNoHAO0r4n2C+IjOLD7nRRforDgeoiqXVDUnonXkPS1lhcvF7FD7GfYdTo+bjxLHhDJtzqcJkvmvCsBWx83IJcIMY9XUAuUMy4ObqLoFm5Fq2XdwRJbx8lu9RrWo/pMm0+UnyLEnlSkN1LYQfzFn7ZIQeIP/xz5YDAjgJx47P1E+6idyLFJEDicflU2lAC8N62EwlYv+I0WJC8AI+3hdpJOosBXbCHu+Ncb1JhzpfS+rb4gJoLj0oJaYcaoOcog8hp4RAkv10UQ3TA79GgiodKG5zku2qzJUW7bxpp/7/ppKl1TJp3hWf3Ox5+qYfrXokiZtiRF7k7HQbEzBHFRiS85dJ/FSjtJEnJtrehe1xxvKAnYGCaIhV8+nSiPxjkGtn4Z6IlybKfNKoVXswe2N+78Y9c/f3ws2IdDTB+A4dQzdJZ8oJs1xc01bCCY4jVwm/aGEo6mivmG2vtyRIDJd+Kb0DnlhcJeioFDKybDIrxQlQJg46YJGGIGfSxibPk0Br9wdtzi9OZ6jxVPOh7Z8j8HImlgpZVA3OXwKmo4zcI3PTOWIP/YLsLyoJWj2/knMuUb2ZQQNLExfFGPoT2L5Qq0FKpz6ElrV1aUv3+oX3knJ859SmqLLSQPdZe4pBELuTpneF14c/mDQSderVMpUPYsYbTguSV2iMi5q6NZcl8GgJ0znqnnbfNSymXBS5ttnb2+cgE8U3k1pKnq2rrH0mS2kbR8MryQKSdr7fahlWXOIEn/m71KODhA6yl+3pKihXG6nZb1tqtZkD+GZgquwZSYxDIpji1Ng1Wz
 PbhsPlY3
 9koOyBf3JnrxooSMGQc4U18nGVX6/SwMyuKpQrJrwjy3KIfmP6TqCv4IOsUWcU0CYPSDKP3dCvma96gwWlyrd2CFMXEAE8CcvHlDDjoY76MdVkNSxLTUB93MzQCW7TuUOymlHopSTGyn2nTjUJEAvrhEpsITtSq9jawWrWGONDieQR9rDH4woR9YZttoHvxM+DisU3q0dW0nGuvyfiWdxBamT+14n1Raip2Az+wAH+IhqeCoP9lOCwW0PQAvwpVJlHKDb9gPIrq38mbGvJZneykknbeZfEhowES3H9pBt0yVDyUUN7k71efL8zA1bOqZSb//SEv1S0wBNEgM=
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

Acked-by: David Hildenbrand <david@redhat.com>
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


