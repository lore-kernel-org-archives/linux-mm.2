Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E84C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56DAB6B0099; Tue,  8 Sep 2026 07:37:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545AA6B009B; Tue,  8 Sep 2026 07:37:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482926B009D; Tue,  8 Sep 2026 07:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 309056B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:37:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE8E7160520
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:37:13 +0000 (UTC)
X-FDA: 85190393946.23.6C5E8A6
Received: from out-2uec-a106.jellyfish.systems (out-2uec-a106.jellyfish.systems [63.250.43.106])
	by imf29.hostedemail.com (Postfix) with ESMTP id E6B0D12000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:37:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=MYNjIXu3;
	spf=pass (imf29.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.106 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788867432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRvvmexcLC9U4oyQUgotQAUOEliANOxb4IH5Ub7AjEg=;
	b=L8vh49mqmnLvY0V4Uzab2dIG7sqsPZd1F0rLcgr6rmKC2VTjZgvGel636BdfOl7xNLoH9w
	sV0vHqCedzmVxFyCJUbnkawgnEQwD8vbMxrvsVbLRP51JVutJeCon3ghfS9FEHZ4U+0kq5
	b62o9QRxzSds67B9KSoLEJ5egxswymY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=MYNjIXu3;
	spf=pass (imf29.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.106 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788867432;
	b=oCV29+mY35G0vCBUxT/d8S4wd+ybrJgw3gGFllQtaBJOuSgSm8DAseUuYpwd0PtOn1O3ed
	4Z6e8MIS7h3v8zl8Et4dsvkA2GRqo0hBdyVR3NueA7vaZ+RcWuiP3uD1iFZnkOiq2WBL1k
	MWyHv5MniqsfBkbPaWPbmEozXpCpENQ=
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hfMNL1KPSz8sWc;
	Tue, 08 Sep 2026 11:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788867414;
	bh=jRvvmexcLC9U4oyQUgotQAUOEliANOxb4IH5Ub7AjEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYNjIXu3nY0KXDW4O0xSWFuul+fvjRH/6MpIdtKU4Pq/t7EWZDktRA6Lw25iimfW4
	 GQbqUng6ER2SANhkO7laKZFLacaG3y2SSqO9Cl3iqv8jncGZhuiQIz0ikiwBfSPHCd
	 37Ftw563vb42MT1TMs5SZ83Jkmf5HtgU29HgSUJPj4CeG/95P4ONQ4tWreHyOAJC6t
	 hFFgzuqP3MOjpCqipaX627MiiTKLGUpTTAmUyIKgtemczB+FBEx8mplKl2gR9zjPxk
	 WY5wCjl4GN/nn59Mn1b8ZBSd+xDxOX6qIedq/q4ICjgI66v1Xi4Wxyw4+MCDLno2lY
	 mKorCMbQJ3jRA==
From: Tianyi Chen <hi@tychen.cc>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jsavitz@redhat.com,
	hi@tychen.cc
Subject: [PATCH v3 2/2] selftests/mm: Only prepare ptrace_scope when memfd_secret is selected
Date: Tue,  8 Sep 2026 19:36:39 +0800
Message-ID: <178886723357.170332.8077272218290758342.mm-cli-v3-2@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <178886714088.169611.14957244271354428473.mm-cli-v3-0@tychen.cc>
References: <178886714088.169611.14957244271354428473.mm-cli-v3-0@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E6B0D12000C
X-Stat-Signature: cnd15rier3p57uwfws94zwsmkp7huq69
X-Rspam-User: 
X-HE-Tag: 1788867431-913410
X-HE-Meta: U2FsdGVkX1/ibij3B2wXPGwROxNzTN2u5XXB3KSCbClHPsH+PENKCIRaBTQzi5JaJI+HikajZpZh59TClWbbyWveub6MZs24Kw4++pBBGJ4s5T35rt/rwv9M3H7lAU2DSPCnZ1Mluw0MEkkDXGXZr7luW6zIsLRr17fNWqq3r1zopT9DYyJjaIIptKbN9TV1YOe5mzyh1i/EysuNQR3nCDU6CnM6WIern6zfpSFzFjvgh3XMf7T8i8phlxsiJ5Uxh3Wqyjsu276qE7ExymQg1UDh7q3YwAbJ/Q6u8hNHmuFHZ5GVhLcBrNzgYiQf9xQVioriCppXP9sZKHaWD3PFoRITqqm5eEc7IWt6VB8wzFo8bmAUBkxZoi4Lu7iqEPI13hPRL/bLC+o+EJV6Iy6rzOMr2G9muF98TViYf0ucd4oaxtPrbI502Fgw56KDe2LXKfV2jNdxTt7B8waXbd1ge6rYjyxILVuvAGuW1vhhlhMPjROdOR6SkLx9ZAGRVV5116T7qiN4/FZyJinMztm2W1sZNDB2/rttvfoU58l+3vzb/TwAmAVxUVaXiw741u+y8s3rFBFh9WPT/+xjbnngtDu6q5Yz5pOOJ3o1fc+QugD4Srnk5o2/qCgGXVxjnQAntmS1QiLqOYWqhXBXNjgyLvGdLUGhDmCyjDn639L84rty5J9yr7U1jjDIR5df8Ze4TAhuFNig3UKMcRGv7AqTaz7fX+RhPPn3/eKPWXFwDTAyDRWo7mA1IHcx5f6KuowF4CXFuv9aP2feBWX/+2IBZH/6lxNfCX5nze3BVm+VDQC4qb7+9vrbBD9RrP+zEcSchnTFVT2lijypVgubW8mZOzhBzrU8JDJ4nOdPBoH9ioN/HXIP5yTTVt8wIB5NbfONCR2NNYGzrg4WWgi2IRQ++mqgXdHoUk0aE4kWNv/6uOdF9ucz/MdJWLaTR694YafKQMTVE/D5KX3W9gvJirg
 A3bYZ+ZL
 2uXDo07L7+iAPuQv6MzIgswPyN8sJH8dDe8IIG7TC6fhbHsPg8EdlVDxbwxB+NY+pvUwarXfkKojcc7C4i1z4xyScsAIPZMYUPCJmSS9ZMdKt/xN5jY7sk6usT30YzwF1c7/psayE6p8aJLZ4+1+zSXUEhatDZPUZ9D/2EtcBIpK6LUTWolYJeMzlSWsfXqDyLfFCUURp9j4s7ga6mXV9oWe2mCUwuGgg3YK9Zs6XU5F/QCrKjQ7wYbQZY7I5O0bij5T42pOBZFBBTrOM2duh3QEYkZipaCg/1XxTdLGg6av2a4Tx8mBBrSnbIMX8GnbG+rRUR7QOF0t5UeWX54XA5nBWt/sXFhGvkz9ms/N/x9ktCM7plTGqzD3ddZ/weiYMcMWoqSYNq294sSwNDwVK19wthw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memfd_secret setup clears ptrace_scope whenever its test binary is
executable, even when a different category was selected. run_test() filters
the test invocation, but it does not protect the preceding setup.

Check the category selection before entering the memfd_secret block so
running unrelated categories does not change ptrace_scope. Keep the
existing executable check and the behavior when memfd_secret is selected.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/selftests/mm/run_vmtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 9e62ab4c677..9bbef9410cc 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -370,7 +370,7 @@ CATEGORY="process_madv" run_test ./process_madv
 
 CATEGORY="vma_merge" run_test ./merge
 
-if [ -x ./memfd_secret ]
+if test_selected "memfd_secret" && [ -x ./memfd_secret ]
 then
 if [ -f /proc/sys/kernel/yama/ptrace_scope ]; then
 	(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
-- 
2.55.0


