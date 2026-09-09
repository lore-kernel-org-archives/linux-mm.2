Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E5CC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E03B6B0099; Wed,  9 Sep 2026 10:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004246B00A3; Wed,  9 Sep 2026 10:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8A76B00A3; Wed,  9 Sep 2026 10:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A06936B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:54:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0124160210
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:54:26 +0000 (UTC)
X-FDA: 85194519732.23.8A4CDB6
Received: from mail-qk2-f1.google.com (mail-qk2-f1.google.com [74.125.230.193])
	by imf17.hostedemail.com (Postfix) with ESMTP id E64F040006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:54:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=epj09oEL;
	spf=pass (imf17.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.193 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788965664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+87EHy1co2pXlM7ySnDj2tBNxv7Gw6474K+toJRCPIc=;
	b=yaGZd0mR8Q4JCDm97iUqS5/MHkh8RhWUL9ehBPlOVvbgwYwg8QTVdYT+tMbVB9/fQPDTRj
	K/fpHa2odZIJsxlNDJKLDPgJC96zeimd+r8J5PsSZ4btmQ5lMSrAVpnH9ZHZJTJUiYI+61
	Suq7hTKQn5DZCRUzUF+Ne7JJNnkZNNk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788965664;
	b=lGeY05ZimOiDsF3v5GqLCQoJO5DX7QatTIwl6BTLf0R9aTuX+uLVFLKaXgadVaxzIKu80c
	L3rP6zv6QOsaGS2xfb4PX7BQzdLm8vCSsBl41gs2IyGEP5dFnZoC2HmAY8CbbeYiciFvnn
	LLDWVCEfQq0ucyKqWqIbxERuTAjbFlU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=epj09oEL;
	spf=pass (imf17.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.193 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f1.google.com with SMTP id d75a77b69052e-53096696963so14330551cf.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 07:54:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788965664; cv=none;
        d=google.com; s=arc-20260327;
        b=ot0ksPP4IsJ1lGuZBE1r2jmXA6rhhVXTA/Uf5aaLheCXxiOa5mqvtV9YGKYYvdfSqt
         qzcqzLajVwPC/0sXcnI1Gr1O4SKA8YAjYPPtjebXtJxjy/ZOGy449h+ml6uKRRA+uBqG
         vrGeiIq2sIvc4AumwNlSj/yONK2BzDRYqgsjBRdYHIQXfcigvA5Anskyw5rVE0lqZQgV
         DKGVkeo+/yx4ExQiLxwrYkKeqykmMGQWKDIYHxzokdqalgDTGoGUHnshKRvy0ToQat14
         KVwh8qRVRqFfzVDVfA+4TQ2Ey+qco3iHIPRIzs0oN1oXSq4clXmoh0c0Fzc2j+CsTcFF
         AZUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=+87EHy1co2pXlM7ySnDj2tBNxv7Gw6474K+toJRCPIc=;
        fh=vXcRDT4P/6GxFEm68NG0wH13fINcoCJgKPw+z7wVBVU=;
        b=Oy4Uuu/xZug1ES5hFiInn/aMX2kNwIL73o6B6sX7vtzJwfkYMKBcHQ8cCS9/dbbjM0
         8taLExrJWE01NnXb4C4CtvtH71zoEM9Ct+UyVJHMP3R4T26xiXe91OXH/Jp9gfsdy8vj
         zqsqPbGD7gomGEkwAVsn3t2AF+INjfBi4xGbZ0mNNJBF22RoGDMFMc/8Zd4cHPKwia3Q
         cgcA0ggDnv3tFm5OshhKcxYZdbS3DeNDYUjLa2sLgY26C2cv4I9lxGponRZkfDS0DCnN
         VgK3zfggEq6dCupNb3mL7MBpNIINrOyznkCOAHuqW1X0eLUQhmqUAcp+YCC1x1FUDXhk
         DV+g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788965664; x=1789570464; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+87EHy1co2pXlM7ySnDj2tBNxv7Gw6474K+toJRCPIc=;
        b=epj09oELnn21X8o9Y02f9nxHtXzR0HMiP+QyyIHQlp3EkJqPRitxHhS7o6A29Ln7gb
         JB4nD6L1UrP5rWPlvUK9Dyu79JPOwn31DS1fe++RpIfOz9nCJF81aUvS4OrtyaQWF+BN
         9mz2N+jOUi+M2Gog0/6o35JjpXKBGTB5a0N03BewD/QM7zxNhIwiEgOyOJdlYhEKMD0+
         XCAefVZrRUI69N8M3e9+aJiICekEdtpDHyeQni+7cN9W6GYI6W1hEXfcnk1swyoFDhHj
         AQ2m+sX8yb7DbsBljYTqrcNEX94xsMtrtWnnwlum+wq12ecDSwoDtExG1kVXhcrj9lp3
         kNHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788965664; x=1789570464;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+87EHy1co2pXlM7ySnDj2tBNxv7Gw6474K+toJRCPIc=;
        b=GxRs0XuNZRUFrJw/i0vqkYVcHIBvjLVZ91V93PNZa5CkgstfQxdDY6LV8KQl////9Z
         R3LKw5BTTu6jtbvsKcdvXTegePioPQ9qhpeP6+N+7bLYzDNhBVbOw8raZDp3RfPLv7Kl
         c5LBq/ectgUMxa+Vxi/NboEA9lajd3Z9XagzGpRGIL/MfUxYeo5nrn38iE3oU/GS2dKH
         zYcfODoEgQraiA7armi8oNR/TrjuxZjqCIYFmkxRDAF5D7nYbmcTPKDxq0Q+LBA/K9/w
         koH1zEKI6Uy6cEN36w7qINZYtGJOODwvUdEikWP2UIwifJmpgi5dVjy4iHZZQGvUC2IZ
         iZuw==
X-Forwarded-Encrypted: i=1; AKwUvBwfY4oamGooWU0Vi7jdVCeBT/2hTqZb209Yjdk3ROP7C/hjFrVwmXBvfBlIa2LOex7GFzeEIPPlTg==@kvack.org
X-Gm-Message-State: AFuF++nVdyAwLDp7Cq7+D3+8PDRgQuLPBloQllK5cZjOlQ42KvYYfeUP
	la1b1I9TK4EabY/CoR461ZQUo9Kk/HT51BEIte4g9A1VK3s+iJGYPbLgA4HVXkDeUENl5sI7YC6
	bc+rLGWZuOxNdsQ6M4fS4qvGd32ra6Eo=
X-Gm-Gg: AYBFou3zdv/xa/GBangcYAcTkk8SVCEFKdMb8T8P6iYT4xu5TRINEKw10vLcDGiOUeq
	owpyuXypdeyv+aeio1wigD5kHC8vFKW6MwotkJihxDSKyZUgef7wSLQoBu6q9uFfmSVJtQqHnXf
	gqf36oVUJz83JXdpPP+Pm0mAStq1Yu4VbPRqPxVTLD+PpoVRq/lxq7avWvaPFqobQHPuayyDpVT
	9nXvDXcYtboCNfOoF2odAeCBqvm9IyLFG6sPNSydaV64FlBKm8bBcDZMgNFjs4/9fTXIX9TuRsB
	rp31UXe+mGAQeJG6HZyHGce6DGQCQhLbbiXKLm9rDTQqilfj1GflkA==
X-Received: by 2002:a05:6214:3bc6:b0:8f3:cf36:15ca with SMTP id
 6a1803df08f44-910c8552de2mr28530296d6.9.1788965663921; Wed, 09 Sep 2026
 07:54:23 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 10:54:23 -0400
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 10:54:23 -0400
MIME-Version: 1.0
From: Tianyi Chen <diannaaav@gmail.com>
In-Reply-To: <CACGbirSdR30=YTPQGN-=202jZqiF8gBSewhq+K_fTSNpq=DMhQ@mail.gmail.com>
References: <CACGbirSdR30=YTPQGN-=202jZqiF8gBSewhq+K_fTSNpq=DMhQ@mail.gmail.com>
Date: Wed, 9 Sep 2026 10:54:23 -0400
X-Gm-Features: AcwNN1WLFkJxZiXjMeZLR_cyAMBfiX7lh_2ngWCAdTCfWBnsc8DM_11bZhuFLIg
Message-ID: <CACGbirSVuuwVFKOtdSh63s5ktbBwkC2hdkD3FBG7ndaAuFyWbw@mail.gmail.com>
Subject: [PATCH v3 RESEND 2/2] selftests/mm: Only prepare ptrace_scope when
 memfd_secret is selected
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joel Savitz <jsavitz@redhat.com>, 
	Tianyi Chen <diannaaav@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ih6snooketb5s986m43dmhe6a5r61g5w
X-Rspamd-Queue-Id: E64F040006
X-HE-Tag: 1788965664-206245
X-HE-Meta: U2FsdGVkX19Lj/k4+jUw4XHNNg5GeH8vxiCLPybDFHjjed8EGHYCUtvsPg1CiZN2KUR6h9ZSfP9fKYwqbsrBNI6fZZM/ybgDoPCmfPx3NjxCl6kZIIhNGsB0ajYtJvrjfwABxFSxCOY+0eA4Mrc8ZaOmuVhU/DKf/9amHCNVuuS3wGoZgYGqPYNYS58FyiMBno2sCnhvc54FQfj7UutsxIIGSbnUqtMJg1CgG2vGnHBDUf0vnIxt5R2czYibcVR0zkdQc14wG0ZPs6KvW6eK75BSiZCHmpfuRdoKqxEz0l+3D5t9Z3fLV60iG7qB51Qar7EQJgaxq4WLYklUUczy9t6R0QkGsl186Nt+R8a82tJ3p1Uhdz1kD4yvne+ZtKkJyfqA0R3PyaV4+kFbm3E/dilbGxlJ1G5gVbaP3DipvhnuhyKNa0e32Lh8jZqvQRqQUnl4thJUbsYfrsxGH0XqqNzJPUpOKb2V6hMoc1PaLRDP6BpgjBzAlqGeZQj5A54weXh77phcoMWceok7Q0K6sIC37Gvp0vEz26RYwFgx61vtOdCDuIuTuxQYVfcZZbdwTEuigb6aV1Z9UWVwYex4L4pMduZ9WvvHCHLS23a0ApXroipRHmtLkSGajYeHXFajTPggc5924JUytF7oC79SZUbvmPMAz7Z6mh9iHJLOcVaQjowmxFG4cXFVJuukvxpzJNG/jfSKyCheQHmgULvupI1k0LgZayLRlDCKZDS8CGKl/lICW+l7d557CyFd5M27dbDGzAe1RIi21br0zw5a62PRBX8MrJ66NPoSrozyGEhBRjadioEocwxH/4usXwL8E5j3Jz0OS0tBv1rqt4wjauv4052Z5aeZWfhEeKYbzXpvM6nJVrSdhLRrNAoJpr8p9Ay6Sg1JRw3sbEYbRzr7CU7mAFCnDVhpz//R3COjbbLTbS9z4goGXRBuySEpCPviLKkd5BNfACU2vEG+NHV
 P7qbqywp
 wIYXCLdLqLfgzaBdpCWWqslJ4fznUN9UzJoLbaYf8/jvnMnypHPJEeqdY4/Xmhv84scvjIbJkRE6BJfZp9oUJS2R/oQOPN9wNRQ5jlM5txRH/qEboq5pSU7/CBbSDnlBPK1QaviJyqtB+lPHdNRpQFgj+T4hX5/e6YHvc2Z3CL6g1yPyNAnnII+KmkDU5QvebsHDB0NlB52jnKUK17qEpDFi8R7pEqtvPHppZBZp7Erbi1G3Tnu31lbyAMCrctlnfH8NouUDax0eUbaKAAKufhlXATnDnjq6qJnliPWdC+WrI6awiOwZFQD1j1InXSZ9fAXUAsn271aMSch/EoFU3NMfpl20mhTy9WvErguFjsi6nd/WPl64Aal5MMzcxpGvzCxE63ewxHPKjvJ4jY7LtT3nbnLo3ExmJHPOlJ96xcOvYhimrchGwAxnXkECXVet/wWWi9R6hx+d5N0e4OgmTy+Gav/meypwaqJI5RIDpjOvmECJf5jW+WuGGb12cvQCVaNh+vgiABHPAP/GjxN8GlUN9zw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tianyi Chen <hi@tychen.cc>
Date: Tue, 08 Sep 2026 11:21:50 +0800

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

diff --git a/tools/testing/selftests/mm/run_vmtests.sh
b/tools/testing/selftests/mm/run_vmtests.sh
index 9e62ab4c6775..9bbef9410ccc 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -370,7 +370,7 @@ CATEGORY="process_madv" run_test ./process_madv

 CATEGORY="vma_merge" run_test ./merge

-if [ -x ./memfd_secret ]
+if test_selected "memfd_secret" && [ -x ./memfd_secret ]
 then
 if [ -f /proc/sys/kernel/yama/ptrace_scope ]; then
 	(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix

