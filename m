Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B943D606A328
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 05:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=RxnNNCYL
Received: by kanga.kvack.org (Postfix)
	id D81536B087E; Thu, 22 Oct 2026 01:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58836B0880; Thu, 22 Oct 2026 01:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DFD6B0881; Thu, 22 Oct 2026 01:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A44816B087E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:23:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 213471605E0
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:23:00 +0000 (UTC)
X-FDA: 85349118120.29.4B26A8B
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CE9F40002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:22:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RxnNNCYL;
	spf=pass (imf27.hostedemail.com: domain of 3sJ3ZagkKCK8RWXWhWTcVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--chihsheng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3sJ3ZagkKCK8RWXWhWTcVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--chihsheng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792646578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3L/lDtmSjNcVzmRigKEhrofpE79lZ1IJN11/qW4zHvM=;
	b=RxllZWy+S+WPAKdc18KzsRHdtz2p1C21+97jm+MVmQEYmVvtyetMNgxQj4fPrvCMOK64Rc
	8Llp4M7UrL+pq/oWztgFSAbB6kLFoIZORtp4xPY1G7NDPKfQ6qlZUH09FlZ74UWnn1ALKt
	i/TdG5ZHB1b3qXuIKuoMnHMdvUEh7vs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792646578;
	b=CF+34HQCBpewYmOR84DwU4D3LbDpbU78xBJ6z0e94i2B6i6O1Yd58Bxuczkf9fCYwRgHEA
	c24IMuJaJzj30T0KSSR1rxwwI6V8DhXRsnhj2+eEQWz96SiH7VRF3xGYoNc5FZBrCdSQ9o
	qSqzXrKDP4izM0vLCc3DJFbwTXvPsIY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RxnNNCYL;
	spf=pass (imf27.hostedemail.com: domain of 3sJ3ZagkKCK8RWXWhWTcVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--chihsheng.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3sJ3ZagkKCK8RWXWhWTcVVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--chihsheng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd6532dbd7bso952544a12.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792646577; x=1793251377; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3L/lDtmSjNcVzmRigKEhrofpE79lZ1IJN11/qW4zHvM=;
        b=RxnNNCYLUsQfOZ6zVOqINz6GLB3mMlgb7RosxYIdhJoDSbIduNJTUj8pjfGes4mT2r
         t5ZcCi+zxGCzDt8FKePe9XFoL0Bm2w/rwLp8irGx0rpbn8DmoT/7yE4jZVI1BMVLx/Ac
         RZ+nv7jtWDsHiMKWmAvcsECQfwl8oOsNZrus4FG/9EJggg0+/P0kScg0/tNqqJvOONrT
         P92H+5Nf9KvVxP0l+ruqd5sk5VukMfRbA+HfU7t0BDwn0+FFqgUi0kYeM9jKOvtv+qkD
         MqHdDLCVw+4+EBCWj9dujZTsj8HcfsfKPu08ay0axmUTKZAsEO/a7IgHlCEwj+42Z7Uf
         OikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792646577; x=1793251377;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3L/lDtmSjNcVzmRigKEhrofpE79lZ1IJN11/qW4zHvM=;
        b=eQpa5MEek57/Plw3wobucsXwSCwnwMv4MmMEZCyvKhCXMnqmGf9SbnjO0PQasnltke
         dulu6q38sqD2uE9zrwn/TH8Ytoa0PvbsMVADc89IojT0DHj5s/ooypJKGmrGHMyf2B51
         SSg97quYuItRzhLqp9z68+O+CJ2KP/WqYxk53t35pK1cs++wRdfvWvRlKTIHYwOApV1i
         GFvP7VRdqbsRezY9PRvKJfXlXxULR9pV/FvzAZq2ZE/0l//jW3BZp90iJklPWpizwQL+
         MqMiUspAxH1pHn7DuW2Bvy9+vU/TqGQpnEoZzvMYHmJUQpmPJXPzGUDagrB5QhW40NZ/
         Ok+g==
X-Forwarded-Encrypted: i=1; AKwUvByWGE5xKRN+GWQtEMm4xZ+8b4S4MEb625HMgFm7wJRgYS0YUxgniHYtPRNt5PLbUUKVScsg/m/BjQ==@kvack.org
X-Gm-Message-State: AFq9FYL9G0aBixDC0w9pXgNjaotOTAa1/GH9DdD+44XTQLI5ZcyaW5Hd
	dtW55yCwlGZu1aBYYAnTBygkFpbOt3sDnzTGi8i+EKuIhlfXPqVmvKE6LLJtqDivnoy3o0I4Lwv
	MyjNYm3hxGDzU7EVTVQ==
X-Received: from pgme24-n1.prod.google.com ([2002:a05:6a02:6c98:10b0:cc7:4919:5ed9])
 (user=chihsheng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6e86:b0:3de:b120:bb88 with SMTP id adf61e73a8af0-3e287b9dddamr2850752637.2.1792646576926;
 Wed, 21 Oct 2026 22:22:56 -0700 (PDT)
Date: Thu, 22 Oct 2026 05:22:45 +0000
In-Reply-To: <20261022052245.1138709-1-chihsheng@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261022052245.1138709-1-chihsheng@google.com>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261022052245.1138709-2-chihsheng@google.com>
Subject: [PATCH 2/2] selftests/memory-hotplug: Use $(id -u) instead of $UID
 for root check
From: Darren Chang <chihsheng@google.com>
To: shuah@kernel.org, david@kernel.org, osalvador@suse.de
Cc: linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Darren Chang <chihsheng@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5CE9F40002
X-Stat-Signature: te4f5ir7k5x7r1nm7xyborx6dyaszkgc
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792646578-552063
X-HE-Meta: U2FsdGVkX1/Xo8a5QViCdCCSfoN0NqXBjYrAfpMogsmNigGCYUpweMp5jTfJ3owcyA4v1uZ3F0FdPnK1Y4oJpx7r+ipqpgeYptJNNsWxUw58Av95/5MnJ01Szf2x4gHP07ZmKRwq9P7qYlrwCiEGCycsowG2MwABVOLMI1C2g358RlppesfMeBggtMfKlksMIzAqrdVV4+OvTTmsSkGa/L857lXNywFwcvjVSjh+uCIRcUrdnmB+03B3RXGaFvuuSEEcyf3LAB3b8X/FwZGxgo6YOJcPkkOD0pWTtqKwy/2EAIFk299DaQuzltq7urhQJod8J/HtfavAbRS4I4nbbiW1U91osW/I+Pt/2q2kapC4inPaQluMZwmlDCqjgKvkDQF376W5S2eBiaAC2h0bsfSOUgAOAxdY6/GNLwZ1wv23D+bk9G4YMu4K6oP0b1CNA4MHNj9s8iSO0l2PTv0OLZdWgQVbgx5qu8XeuV6jpwAtfcCNaIRGrwzYLz+GIbFxJ2AGJgUpLzDRAWSxKpzNsSnu7aqJP2WDpkyXyQG6I9rvhrzbfFi+ZWpeyrX4iSvl+kN7CU+5C2lh0Zrpz7E1ng7oirdmGbWtGEHzit1l3d6MDVfNsehvds+KlYGR/LyYDDrFmFBWa5lxozGaH1j+6p9YuifoBGvWi/gbb3xpvgWKmN7N5tQE/5c7o/kyqZzaq3fMP4qHkuMI3GKxcA/TXmQfnFZWDI5eST5honMYSJ0p8ZQ3Tq13MN4JJ1qOETs7fI4uOsdLAc5awM9oxdNbKbQ/USTLGzg+hjJuMQdo4jTsXz28GOu0mmG8JmeUtRg6KZl7Bw4Y3rJKjQ/bNhZtMi9K1bATULBQy/SepRjE0qg4oWZtnJbBx3oOi/NDm8NSInMBedeIRdVwWwg73jkRFEHFfVVCutULqkjUZEiVanmODm3aGdupfZtTdUHRYqNcN1s5YQZEZhoLEmPted2
 WPJkdyqE
 wyeooT5KhnI5EfofordpafMMVsH3/SoNrrGaVg2xayPzeiXTyMDcrsFjJj7evkcF3tM63d5JMMEdQzm2Qzk1O+c21q7ClU1wgDKI14Z+TLXaTJHXX6arzI6kLh95kDVt+jST3KapNH8vsLlllRDTcTShBmwJmQFGfP/ZZw76EZJSjW7/shPxc+yf4nx7dV1hum5kfzZQa0pZMzT1b9nQB1rxsJ+YoCZgcRiCEh9FEVQYAs7nYBlCAKGOtHbkL/e4aNGO/jhd3mJmcUCvrRgn6tfBxIMmq9TbNn1sQ06+5v+rnWseM5h4oCJNLnLO54KtsnzIS3dYPGJoxSWcummD2xnUNA/i5jNj0n7ss8t8+Pqm63gh55x6nrwWWPVkrZNM/82vFsIBIUZXFhC7dQSeZvPFnWTLyyuEg7a+2Gr1+Xss+doJziYT4GFFc7oVnJt34bl3tcNFKj1vAlDQafsj/pFGFJnt+pj64UTYIUZ3dtUpD2qVMN+R9O6lrElWmpGCX60FeVSE6GhaA1ztC4hK01zfSt0yQXgFpSKbYDGQApCBGloSP3BJVHFn4bUR9s/lfcQeoQIQcrfQuMB5ocW5IooGjTNQJ9rHocVJnIiVytCZopk5r8a8cSY11+IplrDzojNY8MSoZt7Efebk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

$UID is a bash-specific variable and is not defined in other shells such
as Android's /system/bin/sh (mksh) or POSIX sh. When running this test
on environments without bash (e.g. Android), $UID is unset and
'[ $UID != 0 ]' expands to '[ != 0 ]', causing a syntax error.

Replace $UID with "$(id -u)" so the root privilege check works across
different shells.

Signed-off-by: Darren Chang <chihsheng@google.com>
---
 tools/testing/selftests/memory-hotplug/mem-on-off-test.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/memory-hotplug/mem-on-off-test.sh b/tools/testing/selftests/memory-hotplug/mem-on-off-test.sh
index 611be86eaf3d..11fb70bf1833 100755
--- a/tools/testing/selftests/memory-hotplug/mem-on-off-test.sh
+++ b/tools/testing/selftests/memory-hotplug/mem-on-off-test.sh
@@ -10,7 +10,7 @@ prerequisite()
 {
 	msg="skip all tests:"
 
-	if [ $UID != 0 ]; then
+	if [ "$(id -u)" -ne 0 ]; then
 		echo $msg must be run as root >&2
 		exit $ksft_skip
 	fi
-- 
2.56.0.257.gf7497c7d27-goog


