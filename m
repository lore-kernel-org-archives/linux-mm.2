Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C25DCEA7188
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 04:12:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91F76B02F6; Sun, 19 Apr 2026 00:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF4DA6B02F8; Sun, 19 Apr 2026 00:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FAF56B02F9; Sun, 19 Apr 2026 00:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8706E6B02F6
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 00:12:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20EB659B47
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 04:12:00 +0000 (UTC)
X-FDA: 84673982400.25.A0353F5
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1C48D40009
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 04:11:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DsW+5991;
	spf=pass (imf04.hostedemail.com: domain of thecharlesjenkins@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=thecharlesjenkins@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776571918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nvHv9jwSE0jszVR+8lSNwcWk7t4hLfdkLVMWS5L8+Q=;
	b=o6rES2ehwKGX0YQFbPQs63j7mYjoz4K7nO1M/5Edh7KNNGrjeqGZrY7IiI8cKNC555w7Bn
	NPUkwqpznd2G0KOHxW45NXaGVDqo0mmppr4KqdPzuazbbqn8L7dZAp93sdFnQCLf5ztf+U
	ZUKqwSOvrTb+OmgH7z27rdun0cTStVg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776571918; a=rsa-sha256;
	cv=none;
	b=eb0SB2UJC14Mzb8hBjemfWJd04htxJZDcpprcoyb58o+3OivXc7lZGSOA+JZrAo5vz9Acj
	xj99shB1bBrxKTaGlfVCWlrIYirD3X/jRmVBpfALWeiW47/EjyP2HPZc463USNyzMPtSKJ
	+yvytq/jkAWb+sWRQz8YcjfiBOzqmvQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DsW+5991;
	spf=pass (imf04.hostedemail.com: domain of thecharlesjenkins@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=thecharlesjenkins@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8cb38e86cf2so188388285a.1
        for <linux-mm@kvack.org>; Sat, 18 Apr 2026 21:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776571917; x=1777176717; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2nvHv9jwSE0jszVR+8lSNwcWk7t4hLfdkLVMWS5L8+Q=;
        b=DsW+5991R2wDg5fUd4UNc2Y9I0AQdMomfweErNrYEM2JZgWYUZkwvNgVGMn/SppauG
         HnaviDIjc8XJ/EZ9CtFbghl3nrxh2jhavt24z3uSLwsDoRHu+FrkX7yVFw7GzvdFzHbG
         GHm9opVRuZjmilTwG+mrGl10GRI9gAbzHzm/YTRyczBffsV/00p/qIVFjO0fuggxCkGS
         fKV1ahdroKrA3HdyJQSAV8Xb9m5jrDowE13P6oiKMpQcOQfKzBHBLU7tZNaeaLKs2Qk+
         55b38/CoUjxwUwc5LRq9rxTHpjMWU2KAUX/stHdXUMTgSgeiAOHkr1lNNeMEK92yglnn
         0P7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776571917; x=1777176717;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2nvHv9jwSE0jszVR+8lSNwcWk7t4hLfdkLVMWS5L8+Q=;
        b=RKoZAReWZkTsA1piRdH/Tzrl/C4LjNBB1fKnjfoFEF0ubehIXKNYhEkTmWsCWeYi5v
         25/w8vSWtPcBYc43J8WIgtGAIcpEMDbtLrw1iayFICWn4HD1tnifypq6wW9LYZeOY8Rt
         K6D8cB6u52xkhlaQcDvmuWqL6vWr0To/dVFnRCalR+8GO+QaMwWvQl9V0weOd1TGU6cb
         z5j0rQJL/qrckLgbhKo68XxH029PGxQ6Q4gCg4+2rehQ9hIbyfRUbdeoQDcBT3pOfN8p
         2iEeoJG8nsLw6rYBRHbjHULrviD6aCyZq3zDKMw0PDrf0EaWn0yJ6b36X5bYjZZdObim
         jCLQ==
X-Forwarded-Encrypted: i=1; AFNElJ85NUwL4NlS8Oegpn5NX5PqIkw1d6vIpTOzsoniVdNigpyPMBAjeogPNm0FHId4tGVQIT55QkUNuA==@kvack.org
X-Gm-Message-State: AOJu0YzZUZd8U+pVN1P80bg49iEOpXgmcjhH8NAcM3mNk8HHE6pf+V0K
	UHSJEUa43oXYp7GkeIFIQr/GoDDbn43/G5zeuEoWLbVsyYXVIYLPS1IJ
X-Gm-Gg: AeBDietFdnTsjhXkBOzPcDxj09Y6yuNLRp15t7sIesTyErEuMrQwFIgbQ+QkL2gv/0N
	4KSaAU2R3Agt+pbgni2ukCjGpW4KBCrOwnL0vQkakEOGBOVXjU40zpb7aUgCddu62VMuIaqaWjp
	5kFTgaw36Jcg8SnaT4DyNTaa4nzThj8DVwkGwpcmAuOYm9avR9O47yzAlXLYZD7cSSI/x5Gvgag
	Gk6na0+8WablwUfI2Wib0VC+P+mW8tm90W6ZcZCdznVnCAQML36ULvyedJ76KJt5FgQm7TpUvcf
	WCBtzpuGDF7aGYlZLAQPQLPc+9b9h4XCxuJJCs6Ta+jy/mkKNUVkDajXlxqi08tGF/UOxD7BZCb
	O47rDW0yUB49zj5T17IoMYNsADIrAJbMmxKaS9QB0o1NuJKVQzZYV9Bst8l5DLutJuEVSKYX0i6
	Itcby8VqtIfLo194t9XESozyxMDU1rc6MqMgHpPOE1m30x4pRgU9DS
X-Received: by 2002:a05:620a:7102:b0:8d3:d13e:8ed with SMTP id af79cd13be357-8e791c8e81fmr1234467485a.52.1776571917191;
        Sat, 18 Apr 2026 21:11:57 -0700 (PDT)
Received: from inky.localdomain ([2607:fb91:4c8b:380b:91a:9dec:26e7:3d7e])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d5fe98dcsm508388385a.7.2026.04.18.21.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 21:11:56 -0700 (PDT)
From: Charlie Jenkins <thecharlesjenkins@gmail.com>
Date: Sun, 19 Apr 2026 00:11:03 -0400
Subject: [PATCH 2/2] Documenation/binfmt-misc.rst: Make "P" flag path desc
 more precise
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260419-binfmt_misc_doc_update_p-v1-2-757c12f33cc2@gmail.com>
References: <20260419-binfmt_misc_doc_update_p-v1-0-757c12f33cc2@gmail.com>
In-Reply-To: <20260419-binfmt_misc_doc_update_p-v1-0-757c12f33cc2@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Kees Cook <kees@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Charlie Jenkins <thecharlesjenkins@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776571911; l=2657;
 i=thecharlesjenkins@gmail.com; s=2026030; h=from:subject:message-id;
 bh=1J5HfoqMCRzodR4Puf6pKmINNdR110Co/q3KXdwFaYs=;
 b=501vNHBhe3+OspE3Q3Cs8UcA5hXy5KFIkKEwHNX/2W4VCemBfhGg/KIpAPUMFqarz4q02X0DT
 nVoFX9WlA2lAXlrjaDWV4n3Teb0QBImhSDyVda/6Z6KsXYzhZJse4Sr
X-Developer-Key: i=thecharlesjenkins@gmail.com; a=ed25519;
 pk=vpF2USrG+aB6CTbSt34rzJKsAVe/l+GAXo1IomCMETk=
X-Stat-Signature: sya5tj43q9mcq86imn31rnh1moe11ix8
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1C48D40009
X-Rspam-User: 
X-HE-Tag: 1776571917-489376
X-HE-Meta: U2FsdGVkX1+y6SFAO9FujuFfojEnkZ1wLZDhLcQV/9PF00vzr8GgnvVwhUM0RNcfWmYounn0nh46OKy3IjDtZr2x6j2fFc7f/0a50rNaz5a5WpaYQfPV8zd5XSwn/U589yx8nf5K3GyWo+sv4SAWo0tZ9sqoBICj9Y+FRkOIKJJ+IheYwbDN7IGzOSoqsQcbKXWhoss8sLsko+PvoPg1kpOAmYHf6euiS5sMy4nv46m1tkvdHD+pQowy2GomsMg6O71g/N9ECMNOujAsCdiI5L6GLAMJ0L5FLwcd1Vehtl/h5TKt3UThrRBJPQzWS3G7nYP/GORXSbjJkj8XxxiPCFeQw+F6/XBccoPoOwWe2Bbbbzx/w7WxOuGno7R9EIWOuTyfymVlr8iJRYrn6ybNbS71BgO2PgKZ+74iyPsewGxkLdzGuPBYgUCt/9HuG/v9SJM/+IRlFPKtwrT1OuFxUFWI5F4SAlFa1fq2c40S4eY5ao5iE3+yLFkXDIH2+VqriokXD42I8V8g2+EpfF3qJCY96gdvZ4oaGrsqu3grjnDjS7h+oO8YT6tYEXkNc00JcRD6PNDC6jFVU10ogIORbqGa4LXpjJ6FI031x3rQDN+rtX9/cAKjXSVBbRmPCtWOHT5q+S7tbad4nKIcxXOpd9EFSQGu0kv+fhcyhBYqUdzvRYTmaRXZBGPUcxGy6P8EfS0+K/+95XsLhtn5d133/2/8ZTNC59W0voaulQ+uGR1JrQjMK2jtAIAKz+umnf+i89evlITMOnx9T5pOlc4eK8renEZrgRlKfDVcvy5fPMQMf1y0OcrgcYiM94ZD4FHRABX+ykvpveZ3qZugTV3mMjvubGEAcaUJlaDWyjEHYEzTOpga6SiCEMgsb6jTOT5KJTRV77adtnF6K0X+GdAr05ZIBXS7iZa/zJm+RAYKrCw/TAmmRupbbq1cL1IHO7o4s1g7viCfnFE8yVqthMY
 HO3E1Pi8
 Qq6fN9cha8usbVjOuh3GzvW6Oo0Y4rdk5Y0SXmz7yqwFyMF4FY9q5q08ehuDmGhDwRaesKiweYdcnoMGhBr0nzyhp7TqTM/oEBrIcLycFmcTWReuptGwIwL1zq6V54zBzhYo1OOt0zznvsyTQAzdapCDh9vihS25M3CW3N5aNNJDJxqY47sffNu1EMr9VZJfVfQByE9NgQ23iHy7IQUxiE79/tB2dUpfwhTfs6QTKSoA9Qet3kP8f6c8NLmNpm9odrmPE3yo82vDZtOEVAJyoU89TC/S3Nn11gIbQGcUPQyBIga9nld/UId1H3/6goid+eGOQg0ScTsWK4P7jb/XrJUEVjeEbc6FBYdatigTO+eRhuyb7EdJFy6jdaL6v2tzSX0V0ZRsHBXU9dBIcP8aclv0JwJRU00DqqIYRgcmTdeF+5WDcAOFHQSEVHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The "full path" is not passed through to the interpreter, but rather
whatever path was passed to execve. The user's shell is the mechanism
that is converting the executable name "blah" into the full path name of
"/usr/local/bin/blah" instead of the kernel. Clarify this in the
documentation by noting that the path is found in execve and including
"shell" in the conversation for locating "blah".

Signed-off-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
---
 Documentation/admin-guide/binfmt-misc.rst | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 2e2be2922ba6..aabf6599ac49 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -56,16 +56,16 @@ Here is what the fields mean:
 
       ``P`` - preserve-argv[0]
             Legacy behavior of binfmt_misc is to overwrite
-            the original argv[0] with the full path to the binary. When this
-            flag is included, binfmt_misc will add an argument to the argument
-            vector for this purpose, thus preserving the original ``argv[0]``.
-            e.g. If your interp is set to ``/bin/foo`` and you run ``blah``
-            (which is in ``/usr/local/bin``), then the kernel will execute
-            ``/bin/foo`` with ``argv[]`` set to ``["/bin/foo",
-            "/usr/local/bin/blah", "blah"]``.  The interp can be aware of this
-            by checking if bit 0 in AT_FLAGS in the auxilary vector is set to 1
-            so it can execute ``/usr/local/bin/blah`` with ``argv[]`` set to
-            ``["blah"]``.
+            the original argv[0] with the path to the binary found in execve.
+            When this flag is included, binfmt_misc will add an argument to the
+            argument vector for this purpose, thus preserving the original
+            ``argv[0]``. e.g. If your interp is set to ``/bin/foo`` and you run
+            ``blah`` (which your shell finds in ``/usr/local/bin``), then the
+            kernel will execute ``/bin/foo`` with ``argv[]`` set to
+            ``["/bin/foo", "/usr/local/bin/blah", "blah"]``.  The interp can be
+            aware of this by checking if bit 0 in AT_FLAGS in the auxilary
+            vector is set to 1 so it can execute ``/usr/local/bin/blah`` with
+            ``argv[]`` set to ``["blah"]``.
       ``O`` - open-binary
 	    Legacy behavior of binfmt_misc is to pass the full path
             of the binary to the interpreter as an argument. When this flag is

-- 
2.53.0


