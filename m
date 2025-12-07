Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1CC2D2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 12:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043B96B0005; Sun,  7 Dec 2025 07:22:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36DD6B0006; Sun,  7 Dec 2025 07:22:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C166B0008; Sun,  7 Dec 2025 07:22:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D480F6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:22:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D1F1BA913
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:22:58 +0000 (UTC)
X-FDA: 84192589236.28.7078193
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 966E540003
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:22:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YASaU66R;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765110176; a=rsa-sha256;
	cv=none;
	b=TTo51VuaIgHgd38OCwcYbUGhag6iKlT50xbRmW+bNErkK6Abc8AtcJHReOEhRasezOMIwQ
	mtoOyRfI/65zsgVSPsGOPhU3HKwUXJe8bmozgw+tHd91FKr+kGqyrewPVz/Q2L0UikuWqe
	oTKRfd0QNZZFXgtDOm+CpJgDtpUfw3U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YASaU66R;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765110176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MfotD+6H+6J4066EQ9hPObSWyDy2leAU4Sg4BgVcv1k=;
	b=5/WPYHn89+9lxj0udR6cOkG1MErANBi4+TifXwo/fwZt9AutKoV273j7PqbOrhyw2hSaXi
	9P6/dRcJspX9cOAn3uFWrT+MnpJhOVGXVfj72seAUx5W1rXKrK/nOhMo1q0KEBzcTx0gXZ
	n+9H58Lrosf63Ne+jyEz1ogNdKeYZXM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765110175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MfotD+6H+6J4066EQ9hPObSWyDy2leAU4Sg4BgVcv1k=;
	b=YASaU66RVEvMSth+i5o0PfQ4TPgXAHI2CdB4n+i7VK8DZuS6JWsUeFeS+3jR7U3bYRTVmJ
	VoqI9ElmBMWQZ3HdyNA3Pmcr/D1M03S/ygAr0E5SRqC3QFbbefWAQpgZ9i/kszGNhBjbU4
	5pXv+dzhOrHlYfoCOqGOtTNpj1MZMps=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515-q4QCS8LQPhqac6KU_IASdg-1; Sun,
 07 Dec 2025 07:22:52 -0500
X-MC-Unique: q4QCS8LQPhqac6KU_IASdg-1
X-Mimecast-MFC-AGG-ID: q4QCS8LQPhqac6KU_IASdg_1765110170
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FD2A1956052;
	Sun,  7 Dec 2025 12:22:50 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2DD6A1953986;
	Sun,  7 Dec 2025 12:22:43 +0000 (UTC)
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
Subject: [PATCH v1 1/3] selftests/mm: fix va_high_addr_switch.sh return value
Date: Sun,  7 Dec 2025 20:22:37 +0800
Message-ID: <20251207122239.3228920-1-chuhu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 966E540003
X-Stat-Signature: g8s5hs3jd6npkxwt9ndrt76xd3tem8kt
X-Rspam-User: 
X-HE-Tag: 1765110176-827383
X-HE-Meta: U2FsdGVkX18QSWIH6Y1rmsjQdneKIrRxjF2/BG/DkS2jmVL6wmfrTyak/2yjsxMeVJI++bgpkfPa+N1C7m6AsWojV8jQw5G1kVfI95QlzxM162q4ZC1FchfVzqTPAguaAWxRbhjzqry3HdynBOnOd3r5R6KAGtr64dCappURpDKOc/fHBp06yX5XrRDi843n5uBlXDKg5TT8USd9dYZoD6XxSXHQ6TK9HAmv0kIDsKI4+CCgmC66SWbwB2XQR68VeoCeHWDTn9tXd94EwtOkS4NtOz4JfGzmD7w7jCiez7q4jh7tgKk62XOUOzIcCGyDnnfHbzhr24XWa05a15Amdar6z8wGq/w1dTlF4+KYnm9T7qn+kwN+Ou++ckui53E+8+3gnuVmVYxY9G0A8rIRfUsaOvG5+OAo0sLqk0MGVeM2IGDLDQ+F6Jh3Lpf4yHcgiDCOdHnSz9jI1YON7JFj5Hpvbn9xEhvm/0vm0LhkzFpDH4QgHASzvDe4QJb6nhb4vYjqTRw0APYTe9DdIOKPKIrf3qaZEom0EFevj46sL4W2ZzLOgqbL+eJdNToDUteyRsW1PV9hE0ePapE2on0g6F52Ubvj8jJtg9X/rvV7EYRjXGMRI7qATjEWWC+EWeWpWFcXLEmSLrUEk1LmlaL8DmXTHFs/dxX+PQbZDqoLPYnjSoq+QOOrQAr9l/jn4RU4vDt0PiXTIloo1nwwsQLdK2++9CZpOjblo5TfqT202yxu7e7pvV3bveysLC9EeMEqiHr/dWeNWKKRlEtl44joDfdzHjn/oVQdN1DGx353Xu4jZJ7n7/xRtf8+ah77bgfo0OJ8N9cg1Rhqy80dKqpeVsrAvi2fFNZR3o+QSeg26MXayd0Wfqab0qG+DJpcqeQd+oF7QlgGCGU7Ja1luP+i5znqMt5WoTdW6qZN5QO2cbn83AYbEvdbpz5sYvgvtIVgdfUIfLByeESIhvnashB
 06ABidg1
 QFJv6zWZa4URgS+wo/mcEOejklaj3ZzeZ+9DpNtsgrk1UV3MCJjhSK15VQlXvquCL3fUZl3i5FL00OnCfZONMjWkjYxzy3gYrKLLhLWBp9gLkR+tAHtJgzQ0yTaOTFIcU+6YF0pyWLLfrO5+ScZDPi9EzxufbmGO8OGfIUDmhcm+Z37CrGgSi6op1vh8/waSHOXA5PHWjynp4kqEmzFzVg7AurilH2qhFESCr2/4jfhZjos3s2Y8S/7/NJo9Ljse+HRjW3j4nBRvZnUyBUEgParFG9FyvU5cet2ghLJDGVhMvYOJnjytWTmH/Gk2Mqvg3cppG2/2v7Hw+k7raB3Lg4Y93Yy/v5JzcddYiGkKLcveFhr9sNpl1j+Lb34fzP48VrDmb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Patch series "Fix va_high_addr_switch.sh test failure - again", v1.

There are two issues exist for the  va_high_addr_switch test. One issue is
the test return value is ignored in va_high_addr_switch.sh. The second is
the va_high_addr_switch requires 6 hugepages but it requires 5.

Besides that, the nr_hugepages setup in run_vmtests.sh for arm64 can be
done in va_high_addr_switch.sh too.

This patch: (of 3)

The return value should be return value of va_high_addr_switch, otherwise
a test failure would be silently ignored.

Fixes: d9d957bd7b61 ("selftests/mm: alloc hugepages in va_high_addr_switch test")
CC: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
 tools/testing/selftests/mm/va_high_addr_switch.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/mm/va_high_addr_switch.sh b/tools/testing/selftests/mm/va_high_addr_switch.sh
index a7d4b02b21dd..f89fe078a8e6 100755
--- a/tools/testing/selftests/mm/va_high_addr_switch.sh
+++ b/tools/testing/selftests/mm/va_high_addr_switch.sh
@@ -114,4 +114,6 @@ save_nr_hugepages
 # 4 keep_mapped pages, and one for tmp usage
 setup_nr_hugepages 5
 ./va_high_addr_switch --run-hugetlb
+retcode=$?
 restore_nr_hugepages
+exit $retcode
-- 
2.49.0


