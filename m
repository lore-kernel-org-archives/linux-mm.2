Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34762C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:56:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FBFB6B009D; Tue,  8 Sep 2026 05:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485D46B009E; Tue,  8 Sep 2026 05:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375166B009F; Tue,  8 Sep 2026 05:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 187B66B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:56:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4A49404EA
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:56:09 +0000 (UTC)
X-FDA: 85190139258.10.4C314EA
Received: from out-2z4y-a139.jellyfish.systems (out-2z4y-a139.jellyfish.systems [198.54.127.139])
	by imf23.hostedemail.com (Postfix) with ESMTP id CBE8814000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:56:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=R63crrGc;
	spf=pass (imf23.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.139 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861368;
	b=bkc/ZNiaXDjStL10x4bSsNpxIfrSVI4DwZT0myHlKe8GjKkDpL4y6fUtzlYQLW9XxgxCsw
	l/L0nmplc2LPQLY1YISpPkUdB9wKdYyp2Gyx5RZtBP2dRh/EtZJgxCROUSZ0C1GT6BQFkC
	reX/F+1F0QrE+Z+MrxywGomptk7Aqys=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=R63crrGc;
	spf=pass (imf23.hostedemail.com: domain of hi@tychen.cc designates 198.54.127.139 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYyjaZaYZ0ulE8KGtDF0yY+jHdpZ4CwTPAi26ZHz6sA=;
	b=0BbvbN7WlnWhl77vvdh6LyvTPFPR7o7/WAjUQFRTu7XXf1kTiYGe1FDWYXVW+CfbaQ2njP
	xZ0QSx2x+YOgE1U9QROsxXdU79/sSgrd+j1FRU8IAIPPbsXoPPSQMnemtB6HYrt/vkdn49
	klZxf+I9fIiF4C6Iqapt8zbittWMSRc=
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hfK7w4gBbz2xMb;
	Tue, 08 Sep 2026 09:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788861361;
	bh=QYyjaZaYZ0ulE8KGtDF0yY+jHdpZ4CwTPAi26ZHz6sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R63crrGcCdkrcwXgLHdaG7kwwuC5O0uz1h6frkTokYuRe5xFYw6zJucYF/YYS/ftN
	 kzWyjwF4DfLa9Pfzp+w3I0AWRtAslwmkHOjfoyKtl4ZIRbyO92d13DXdJ4vAe61yD9
	 mLBg+AzvRQcuotLnRq0LYy9EH1xH005O4aqYZhTIEsCv2Z/HQQpxPLg+RdkHMu5dI8
	 fUgwEFBpSEpNkUdmLbRL6wned7RO5MYjU9IRDv1LWb78bWs78Bshzm+97QT8oatrx2
	 sbb4vs3pL14/jU+970eaH3l3iQ2+wzPq5SGAd7E41aXRVPTu/UAe95BrLpD1xEV5KM
	 PuaOFQ8EMFG6w==
From: Tianyi Chen <hi@tychen.cc>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jsavitz@redhat.com,
	hi@tychen.cc
Subject: [PATCH v2 2/2] selftests/mm: Only prepare ptrace_scope when memfd_secret is selected
Date: Tue,  8 Sep 2026 17:55:33 +0800
Message-ID: <178886112560.138404.8930658836608223518.mm-cli-v2-2@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc>
References: <20260906135444.749144-1-hi@tychen.cc> <178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CBE8814000B
X-Stat-Signature: 5khmyn6ypygy3k1ey8sc8ai7jxttk5z3
X-Rspam-User: 
X-HE-Tag: 1788861367-291701
X-HE-Meta: U2FsdGVkX18ziBGhP1uybVR4VDnR3EOrZSUqQPVKUIDsnWzwgFmkM2oQI8+dxcWM3HL5K+aN9ywuRD1GonPwRN1pZY01kbgPf0S5w8WEIPSF/bvBtwpGC7OjT2oTa7ay3vNhbUFMqIB/tFiFKpYbDKd7XJCmaTY1vQPnN4GFX7kfnonMCtZq9JeASWbc3V3NyGNmp0KJpEhAEejkJ4X+HiYTXEU4FE3OzVCbz5bf7vWkg2pbHKAUntUej9bTugV5s3D7rB/6uApx/yKrTrMhxA7KGm0FJNzKgMjCX+h5nkK5wHjbbQdqhiz6oxBgJxrW7f6pIY9zT03DNtPOtif8RJB447QV+v6NnkxUTE/BF4MZOM7lRi3cUxwTsw6KeZkLzy6eQmn4Ed9Rt9sg3Xv1E9IxcSntBLlOAh4C68uhrstCrrVst5C0n8XPm+sGaZxqkdWe9TYmXxr0TGPh7axOboaW8mlqUwoFrR26FWJ/Ni5us3AHw82Jmskv0QfFfKMwv3BNuEBNc6Cr09id9fo0QK834mmSrGCufFlSawJ5d9JdCVzb62OAIQ9wfYiH+N8s7zDvZTHwqI+NVHEVvOVD9A6HG9fw6pGpIydnUvamUwN2mbTNLgiR5cKxMBIwut7vwvhc3MqneI4ylWbfr1eOBw7JZvc2oHVUgqj1+jf80jUnDkIBqgzj5z+nziK5ylkht+QWvJdluaFHXJWo4vtLBo1oMAy9CmLz2FADRP55d7h9yxNH32r5HWJ3T1K8Zf/Bw1MUkhuSfjg+KOuSU1Fq0Lwocbxej/CR+1gq9+x7aAYN1YTKzD+DBx1xxxCNDXu123VoDRI/kCkV2UWEhgBwvA5MjyEuJVN3kEFQSfqH8omj4o/pvfyDo7Ws41Z/vaFUwekXfEa25RsVe6hNt2oApn4z+9ce6addNFmXeSQ1ZacwIyR/Mu/Tswi7uIzGHQvxPXSYO23AoJNKfGUtNyM
 0XKlcT8U
 ux/FF0GjkeAXs5Vc5uQaQaMn/eadkm0CvjCeAyol+vWQ4RlJAVL9FYKnU+HpaHRgdXO79WOijJRuN4HRzzBXu2AlsOy6PMwFv4/RkVue/hgvYQDNu+Tr5VNgjLn9ZVSdiP45vNY9oooraA8g/czO9spRFDrearSZTAL3d5GV/qqgtyxYxfQcDHtfFFJtE2KDByyiTE2gTha5PlVc724sgJap/FugbiiWaNti2mMYC/iTemF6IYKO1InbY1KkrE5mpvX7ycFI7cgXTvYTSqGa05jWkG87YKHq8edvXTbGt+OAJoUHwhLbzR3eQkA3XQD1Ulk85JS/apD7TLGJ/NlRbzY5XLl4nfrKmlzvcef0cjPyKCGhdN2db8+95+FBlg8NMmShZ
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

Assisted-by: Codex:GPT-6
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/selftests/mm/run_vmtests.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 836c7454cba..9932df252f4 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -371,7 +371,7 @@ CATEGORY="process_madv" run_test ./process_madv
 
 CATEGORY="vma_merge" run_test ./merge
 
-if [ -x ./memfd_secret ]
+if test_selected "memfd_secret" && [ -x ./memfd_secret ]
 then
 if [ -f /proc/sys/kernel/yama/ptrace_scope ]; then
 	(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
-- 
2.55.0


