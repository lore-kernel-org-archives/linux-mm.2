Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96EC9C79F85
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 13:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860BF6B0088; Sun,  6 Sep 2026 09:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838C06B008A; Sun,  6 Sep 2026 09:55:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74D746B008C; Sun,  6 Sep 2026 09:55:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 599596B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:55:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 338DC8052F
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:55:17 +0000 (UTC)
X-FDA: 85183484274.26.92CC33A
Received: from out-zbxj-a87.jellyfish.systems (out-zbxj-a87.jellyfish.systems [198.54.127.87])
	by imf30.hostedemail.com (Postfix) with ESMTP id 55E9080002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:55:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=k+nC8v9x;
	spf=pass (imf30.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.87 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788702915;
	b=RBD+6YZLfp2FZUV6xIqnB/cPIYkYpB6YHFLIWUviOQt1q33Iy/+kLZC6G8wgO+uVfQ3udd
	DPFw4B8JsgoubrqyxyhSZ38Ji1sVyAZsPJw3vs+3mWpOxihhUOY8y2lavTLlypnH5xSqN4
	cTa/WW2Bm3utcaUEUb2H+AdhAE/rHNQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=k+nC8v9x;
	spf=pass (imf30.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.87 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788702915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rdk1razVM4wzn8BYFk67V58kT1IZF+tiqXFv5msdJgM=;
	b=OIqafK5Nt6XbCb7JtTaTAZSU6mKcPoAVrHWdTZ7mw+bMFhDx51HOI3l1NtKSNEF5rPYSaz
	+fWQPNvQymR8azP78ofq2NwsGk2i5tot8tsLh3Pj3AHjFUwSpY3FJULeZGljLZCGgw0/BI
	r3Zbz2xyWWsgC1yCs/PD1BiEsG70xV0=
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hdBXW3m5Lz8sXQ;
	Sun, 06 Sep 2026 13:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788702894;
	bh=Rdk1razVM4wzn8BYFk67V58kT1IZF+tiqXFv5msdJgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+nC8v9xOCXuaxIACm5N2ea5tjPWOcyhsH/oWRcrxtfjOoADlBUKIuVFjLD4QNArL
	 khGdE484U8oj7VgnrYKk7v0Hbf2fb7ynvhVB1XOmdwpwqPdB8iMLQAy9bO3VXoP7su
	 l+HuOk+0uokc3WvgH5K0+i5JLGz6YmUVsNSIGobMbSyySAlj/MvonfXoiB5jbx09f4
	 8udyRITBcATAGCp2De26lgs1aSFvDjDLg5OjZ9f0xfN/yMILtukR3f8S5JKKQfX/Fr
	 v9X133n9AAOiPRv4GzB2Z1Be60WgN1eO5jcTqtIE2+dA1kLAqvaWONcYrDbzOECpPL
	 PqKG9AJZ7mqPw==
From: Tianyi Chen <hi@tychen.cc>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Tianyi Chen <hi@tychen.cc>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joel Savitz <jsavitz@redhat.com>
Subject: [PATCH RESEND] selftests/mm: Exit on invalid command-line options
Date: Sun,  6 Sep 2026 21:54:39 +0800
Message-ID: <20260906135444.749144-1-hi@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <ZTYJZT7Q8UU4.KPP9BUAAJVQO1@mailcore-89d674988-v7w7p>
References: <ZTYJZT7Q8UU4.KPP9BUAAJVQO1@mailcore-89d674988-v7w7p>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 55E9080002
X-Stat-Signature: er4wi93uddnw3fznq5tt77cjist4yspx
X-HE-Tag: 1788702915-5281
X-HE-Meta: U2FsdGVkX19BKuHblO0FIQzPLA9loiJGeIMNRVUef4Q5DCLGI1acSBoZ7jda2xstgyf/PgsL6dPq2MUtdiVtamM59fKLNI67HTAo424lRQiA07p9C5J/yRt0VXXGPAunIaVFasBUCPVo1ynt00i6wgikDvHorVKYRrCMheEHrfmcWgkUk5A3SoeGl0Cx1sHXWKg9wUYnwkh335+wm9K6DEwGwnzLoPDCtw6tHFmwdvjk8RhTGwtEQGFLAzeGFuR/pp0nIUFgmx+l2ZNG8VyWCyLSCxlWpph2KEfQVED+zqpLHokgrO27trnVSyNr5IWKQfid0Sa7ZrrZjsm84WiBPTdIFEBBxeKxPEaBnioZflQhPcfJbRNy0M89OoC7lcgcy7SR4drzuFWEsKBEmf69qM88R1yCcKdmjvNr44YXpEK5wqCj5vT7CRWDfWMPf9E6xF6qPk6ynW8VzbC1C/u+ApsQGtPRmgcwl2bPEhZCrCiZt6yaF3AYFpOi1ZKr/lsyIN8vcszxO7vU/9WpWGcnlwL7SafEL0S5VBFe0dHBPiJ9PX/m7aUS1bdC41IO5NuTg+WfN4Kky+JaDG381E3v4lPfUYlWepDVje/8oJYWzX8aeWDIDFsw1rxFJXDCu13oPA0sbQ63q1PcdtLZ7vt7TM2mM0KwhEaSZ9YpeEWOTGbS44aF4XuiPgDT+XZMkndyEcN0KdN9mgKm1rVHPQIRHq2OsoJjNghgo92NEQUHxZO57mD7jF/LcxDWTYjcohYMThQSsktje26JHXBVr6EOEOu4zIxogLCDtjuAeO5ckDSVD48/jRROPJxX70YdzGmdyr4gWNjdY2Vd7Kcf91Oiu6XFD1RTM9w1/e5kU+7qcjWBgo9G0QZ33l3M96zDLCwbXXi2cu0I2Emh11VwCzWYx7SQzw1wcUzBBVRnwdIIB4/sfr26g/U7aikxGuJiCbAqnRvwTGyFOwgotpquBPv
 WNdeoNzL
 ytelecrtnYOlTf7Ae7meYTDIoRDRZCHW8SaiNBQepkK6Sk1hmBgmnBGoSIZuv142mar2bKWuBnE9yM6tf19oR+nnqb3ohzaRDEFOSHcBrT3YHv133qqWvh6XPTK9aXYhiiOcWUoA7PyEwOWMkPJY3BD020AUE8+z4T9X+w99qriSIPkWe6lzY7spxriKTOrB3rP+/q9IZCxHB5gWNGQmfziTjYRkCj75YirNoX8efTuUcxZCKrMI8qRpLKAq6/hLRfaPRJTM1Ft2N9BtdSDQutVwTMn2pLjRnKY8q+lUT1EC0TxdY3PUxTh/zp1ZNCvE7Al9wKr2TvKdFkxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

getopts reports unknown options and missing option arguments, but
run_vmtests.sh ignores its error result and continues running tests.
For example, passing -z or omitting the argument to -t can run the
default test selection instead of rejecting the command.

Exit with failure when getopts reports an error, before any tests or
their setup run. Keep the diagnostic provided by getopts.

Verified that -z, -t and -t mmap -z exit with status 1, while -h still
exits with status 0. The mmap category's three test programs pass in
a VM running the kernel built from the same source tree.

Fixes: 85463321e726 ("selftests/vm: enable running select groups of tests")
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
Resending because the webmail editor damaged the whitespace in the
previous submission. The code change is unchanged.

 tools/testing/selftests/mm/run_vmtests.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384..189927f87e6 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -110,6 +110,7 @@ while getopts "aht:nd" OPT; do
 		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
 		"n") TAP_PREFIX= ;;
 		"d") RUN_DESTRUCTIVE=true ;;
+		"?") exit 1 ;;
 	esac
 done
 shift $((OPTIND -1))
-- 
2.55.0


