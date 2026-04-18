Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BADEF99C89
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 21:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E18B6B02E5; Sat, 18 Apr 2026 17:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490A76B02E6; Sat, 18 Apr 2026 17:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6C36B02E7; Sat, 18 Apr 2026 17:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 280636B02E5
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 17:09:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4171B9D85
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 21:09:03 +0000 (UTC)
X-FDA: 84672916566.11.F143B0C
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6A3CC000B
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 21:09:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Gu/XaZnv";
	spf=pass (imf28.hostedemail.com: domain of thecharlesjenkins@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=thecharlesjenkins@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776546541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RWsCREaaQXHmkT2rQHbpRYta5YCd5PFt0VNHNR6AeEo=;
	b=MMSWb3MN2HMGpX3UDpP/Jt8tUKkIVwHudvjYXE1KUcGkUTIXvjcMbm3FOhAsxvyW8SvSz1
	ikhcEeMWaVJReEPt/zsrawFI2CqY0WcvvUxij5fQGxvLZAkbDfaibJxR6c89jaux4Fs5ug
	niHWmjmR8sZ/eWvoMIB4cYUYUgDJIS4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Gu/XaZnv";
	spf=pass (imf28.hostedemail.com: domain of thecharlesjenkins@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=thecharlesjenkins@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776546541; a=rsa-sha256;
	cv=none;
	b=ThHvfUwZxPKYUlPZBzmgtRlxACzQctjALMi3VjW69TE/fiQo+i7DP9YOlijXSCPkWY9ppI
	/HMzI21gBp7BmnIfsNzmWbhXabikNv9LVWuEZh1f8gV0PWDDjIKP3LGWaZM9lNxNDcJuoH
	RcUcda+mQzEQPBbcK25C7K3lAUW8ORc=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cb5c9ba82bso343352285a.2
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 14:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776546541; x=1777151341; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RWsCREaaQXHmkT2rQHbpRYta5YCd5PFt0VNHNR6AeEo=;
        b=Gu/XaZnvoDsgigSDyCgNHdqhkZYUKwD2bPII39RZi+BC3FmKl1RBgNRlNFOTFJrTZ/
         81+qeyFC2B5Tu5/QLrPb31AwN2dmRopcpqRy5a82HiVn7dw2OzxCZU4nTaUtnkDKLg9a
         R/+7yYl8smrWNqk/OWekN6E/FvUguU++fpQlwYf1853pcxte/znOYlpHmfWZG6y9VLgZ
         qwHATyW76uz5MzTEYtJ3/MbSGIw5c/nGj4800h8wruCNGJ9p4ZGwFT92pdceEn6Q87/T
         p9QGob+s86f42jLsT/JrDp5r5rmvbcCECiDlhkN5+mkP2Z1UH5UzRflUpwWFiDPWJ+4a
         mtoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776546541; x=1777151341;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RWsCREaaQXHmkT2rQHbpRYta5YCd5PFt0VNHNR6AeEo=;
        b=G5k5iwIi2QZ2hQO1xOlv1ixABR8yMDL/s5dEZDzok4v8+NTGab2kkEyLjU0wFWA6+3
         FMjf5gk3xMPwZfc5JWE926ZtCNp7eX/D5tvACxAndgm5KSd445iiKJWKOrJy5jMDu1b4
         mf3wuCuZqcqtgt9GlPF8unaUjhKFJXAi2o5vWGYVbQqm8UhuOKQMxOQ4h45kAAs5qVik
         b3b9Kr4THDUfJ6UgwYRZ4dVo4Vh29tSNp7pSpMKRxdkcxfmrQUrKHRakmLz4SZRTRvuf
         c9U0gtqlFGRB91q+CWz8Bk0y14GqMRjPknclO/cce1VkUpbQNZOHAgiYH+4kp/uyKl+C
         GzlA==
X-Forwarded-Encrypted: i=1; AFNElJ+7h4/o0QGPqrVuXFBNrsARCS9fTEf7yottmc13fOvaH9FwLjeCt6lWFc1GlWrBII0aohkbwwYQug==@kvack.org
X-Gm-Message-State: AOJu0YxgWh4NVvA6Cn9NWVv1+YYSqDoAX5Bfl4upky+9EV16ZkWmQwvz
	B5OEzh8E8TvCbCRDs/dL2W2W0DRDxx+G+9pS3sZRdYHj47OwBHBggtjl
X-Gm-Gg: AeBDiesujlWcSIxxLYw0T5NjHeffjzJnwUQ1aUJzvc9FDqEsXat2vpiGwLvrBEXtHzS
	gT2oU8VUWJz6YBsBX9TcrFXoZleJCWXPwPvrisepQggcEYHxmqLu9tr2fYGSJxJP57vvUFAC8OJ
	1b63DIK8he+8nsFc1rRHI+aeeBHSIv2fL0KNhI1vdPFu+5K6VKwe2wOs2lIO9BsrzbA3nq7czTg
	FExSwWA2bubxQWll96mjD72o/PsnrUPkjYyaoBU6KuJqTZnquXooTnT95ifgsX3PzHEBxAmL8TH
	viQCFNHvMj4+3b1O0I9W2YSX2KCxU8uWBfU7g54Y2FiP6S3Cmk65Vurj82mZxEyNB8ecw9TjuWM
	Riizgcczypg3T1G4MsjShBWc7/NH6HuqsaOMP3fI42b6yY9APR89qZUctBZ15Y4wsIbqsASMBYa
	lCF5lQnZh/7P4AHxA9c3y2CRm7DjzOcL3y0/z153vd0WdTeQ==
X-Received: by 2002:a05:620a:4086:b0:8cf:df8b:1e51 with SMTP id af79cd13be357-8e7916b1d26mr1081316885a.28.1776546540876;
        Sat, 18 Apr 2026 14:09:00 -0700 (PDT)
Received: from inky.localdomain ([2607:fb91:4c8b:380b::5f0a])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d8edb789sm454851985a.31.2026.04.18.14.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 14:09:00 -0700 (PDT)
From: Charlie Jenkins <thecharlesjenkins@gmail.com>
Date: Sat, 18 Apr 2026 17:08:49 -0400
Subject: [PATCH] Documentation/binfmt-misc.rst: Specify aux vector for "O"
 flag description
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260418-binfmt_misc_doc_update-v1-1-c2e9601ab868@gmail.com>
X-B4-Tracking: v=1; b=H4sIAODy42kC/x3MSwqAMAwA0atI1hZU/F9FpNQkahZWaasI4t0tL
 t9i5gHPTthDnzzg+BIvu43I0wRwNXZhJRQNRVbUWZm3ahI7b0Fv4lHTjvo8yARWtSEiROrKpoI
 YH45nuf/xML7vB3TRgFloAAAA
X-Change-ID: 20260418-binfmt_misc_doc_update-6adddccd9475
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Charlie Jenkins <thecharlesjenkins@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776546539; l=1815;
 i=thecharlesjenkins@gmail.com; s=2026030; h=from:subject:message-id;
 bh=KKcmkeUM4z+EcMuy0Yw8cx3ZbSSAkBr89XldtPJwLiU=;
 b=zyJK4ZfrkTxgQec+F55cwfQj0VNFTl5OtIIkEkLyMTixglWlA0VNImSbagI/CJSeJAcOBFWmM
 ZduS/nCwAe6DcVKn8kUGyISYLARK6isqB8WUg8ifHrYfUGZeZFx/7qF
X-Developer-Key: i=thecharlesjenkins@gmail.com; a=ed25519;
 pk=vpF2USrG+aB6CTbSt34rzJKsAVe/l+GAXo1IomCMETk=
X-Stat-Signature: ep84ju8ioa6xxdoxgo18pn1cp4xso865
X-Rspamd-Queue-Id: C6A3CC000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776546541-44508
X-HE-Meta: U2FsdGVkX1+TW4YLAO0zqpk6K9bMCeSUtow9ZQfN7cpU/N593Ehqi7SWuZWisv9UWIY/swDtPrkdcQFirY63GsZL6gf1IrJg4Rg0L3ueQb9RBSo/4eL3pTiHebD3rn6RLyJD26UyHpWZXqDdhFQwF0sb/Jb6fchKzVggESlHVSmEljEwqPmIMqGWz5qT6dNQF2lDHSIIox6FwJMp8BQeoZgF+gulVa9+2HD7B3fA7RcIL0Vi/7g3UjcB12u3mMTadvROMj7aIRmHxEHIiVc64yoNyf1R++rsYXnN99kVBnHhlDWX2zfIoc/1k7Uy7lSo/DM8pylPLxETG4mlJFwgnVKexyFdhvJ/rcexk/4cCEF4NCJRAe/XkvDbNh+uIT2WBgaqA8ocNaR+z9ruLPy1Wnfwf2JGKblqbuuiG7xPp3/qWV0ygas9F2LKsO3VPd/KFlR4zkJ4wsjFHfjA+JKhvum2COPjHBwcTy5H4HcT9PZKhZk+zigMHOyi98K7dwYE2aUartZZCXC3SVrjw+0aoPeCFKIZANffqyQ9fF9B+yRT8145ZYMVVVyRG83hVaSPWeIzJ+4ovyY+isogf4gvyg0xdtYCjxNaYIzvr13Th7e7+to2+Yvpqb0GOk2AgEZED03jS0H3HbucEq1UQ01NxzvkaDK5XhfD8f9tjB3tQaM1UKx7kVS7WemYi7dtK//I27nArFBR3AlsbC0a6wlur5Lu0q9XOJFA04rbHD9g5VQSLy3PDfXK2y5jbW4Ea8XWwDNgwv1mnpnYP7QlsJwjkkg8OXypSQJM3FHjfU810bz89C8QgH31VYR0kfAVyIHJ9JDxA2R6Js9ocaMaluUW9hDFwFTdojVDyS+RR/5FIY32cwRMnZAQYm5dD8gVSPByQT0jlF6LYYrTInvdYHFanEgWwmuHh7ZEXGw45iHxBVXUrcbzYRqdml+iz6LMW9xXHyR8e23csuVDnUXbl6J
 ykORx74G
 hUfh5CuvAsRcYBmvSF/rIkHn2/QuUBKIT8tsMOBBBeOju7iW2YHzVk4dvHlEoeULFeC3/MyGDdSTzgOAKmTBBnR31dsx8MTtuDj/5i7wQlWBQytFLULWEHdGOCvBwUx4/tXEWt4BjleWXK0hkb5ejAGI3LLdY5k7oGyvYzYIA9bb2yZzDw1Nt99+grANRgUMhKaJC7fFMQqGhpbcrnnZc+WW2mieMbpgC2KY1iw1N12mw/Ufpi7QGuGNPNerCqI8qtAIsAdZWLl4T5sLD9GU1MH6hveRA+PNA+cHJg/2zMKLZ7VxbOqLCbvNtK2R8XyeKjWhsW0VtJovuqUE4Fhln+HOcEVjZloDyJ11AUzqD+Im4XT2n3hEOTfpQ/0o/3Tl/s9uAhOr18Qep2xORQc2q8KrTSRy64JdFLDWvXC8tVRVA8c8OdJ8vq9owOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of replacing the file path in the argument vector, the file
descriptor is passed as AT_EXECFD in the auxilary vector. This appears
to have been the case at least since the git port, update the
documentation to reflect this.

Signed-off-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
---
 Documentation/admin-guide/binfmt-misc.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 59cd902e3549..c0a34fbf8022 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -68,10 +68,10 @@ Here is what the fields mean:
 	    Legacy behavior of binfmt_misc is to pass the full path
             of the binary to the interpreter as an argument. When this flag is
             included, binfmt_misc will open the file for reading and pass its
-            descriptor as an argument, instead of the full path, thus allowing
-            the interpreter to execute non-readable binaries. This feature
-            should be used with care - the interpreter has to be trusted not to
-            emit the contents of the non-readable binary.
+            descriptor into the auxilary vector with the key "AT_EXECFD", thus
+            allowing the interpreter to execute non-readable binaries. This
+            feature should be used with care - the interpreter has to be trusted
+            not to emit the contents of the non-readable binary.
       ``C`` - credentials
             Currently, the behavior of binfmt_misc is to calculate
             the credentials and security token of the new process according to

---
base-commit: 028ef9c96e96197026887c0f092424679298aae8
change-id: ${change-id}

- Charlie


