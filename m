Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F15CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4CB6B0005; Thu, 28 May 2026 09:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37CA46B0088; Thu, 28 May 2026 09:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292636B008A; Thu, 28 May 2026 09:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4B96B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:45:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC01114080A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:45:45 +0000 (UTC)
X-FDA: 84816951450.04.9D20258
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 39773C0002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:45:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dFusR6oE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of bmasney@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bmasney@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779975943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nFh87XciuXKGHbtJRS+GMwtnVHJ+GuXgjN5PHapSR6o=;
	b=twdbNerRk1zlrThUZblTNpop+6HOCgqtc5Wtvb8Wv8x4RXPFDiMR9/GzqK++XffTNTFWwx
	qkPDsbJwUstoMzbvZtNJkdUI7Pmt/2Z8c0nZFCxEuwnFkZJeMCnr9u1NDr8dCabWngk57q
	xbLlesDTRHdZHRATjsnQAGESGdLW8Kw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dFusR6oE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of bmasney@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bmasney@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779975943; a=rsa-sha256;
	cv=none;
	b=S9o2UhFEMUHjVuf1U7FwPHW6dLS9IYFF4ZGatW5WRDBN4t39tHWBBWTumrovhXeQZsD+J0
	xg5VMrnU/oAiH2f9AhK7DG8y0Bs8gEIkXPd2hnK2xBb1J6XW29eFi+MXPNs1/Bc1Zwm08+
	v1n6zauywEDmCLT366L4rkrmq2mDU+E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779975942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nFh87XciuXKGHbtJRS+GMwtnVHJ+GuXgjN5PHapSR6o=;
	b=dFusR6oE+odbepH00T92YZjLQuk3JD3a0fJctml2xKYdBCQjNddF70YWj1sRr+hy1lEKpQ
	ABhji/qR2602C+DyI7dRke/5OACbJsyShShN40keMQ5FLfc5Elre+u02psOjjDfwa8Wf5D
	eGidVPmFCWrKaPi5ci855dwFX5aFqRk=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-AwF64ao-P3a0H5Cw6UJFXg-1; Thu, 28 May 2026 09:45:41 -0400
X-MC-Unique: AwF64ao-P3a0H5Cw6UJFXg-1
X-Mimecast-MFC-AGG-ID: AwF64ao-P3a0H5Cw6UJFXg_1779975941
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-914aa174c3aso1246694185a.2
        for <linux-mm@kvack.org>; Thu, 28 May 2026 06:45:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779975941; x=1780580741;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFh87XciuXKGHbtJRS+GMwtnVHJ+GuXgjN5PHapSR6o=;
        b=rbBIerBFW6X0+AjTHSU8Vs+ayok5Gq9xL1uf0jP6B5h1iVSqbR0OQduPniilbb4cih
         jkcluPeIi3AZ8zfCbYMeuwtOCRTuSY4dDCGda199F+3834WzNO4WDQekPbfsJsVIH7Ww
         z277qg791juTCYfI2Qt/t3l7QZ3vKKz2QuMl6oGKG/mFc3g7QYKPGc470R2OIPxe8cny
         iERExvTa3f0uUMD4c3YHjtuGJWP4Zoz7Mz2NQA+c+XnpF3Yql0n2wRFoE20FcwG7bTuz
         tNvF4LPj++D+bGR1JzBMglX0+YhGhUTKAjhmliMWwK7PoHuoxhf8spx6e5u4vP22sBHW
         DPJw==
X-Gm-Message-State: AOJu0YwJfvSMyQUVtEWX+ri1z0n2G/5XT9hF/+josd/+9twO1D5gMKFB
	NxLwtMJ0iIJXkZcKWKbZy4t5c3ULpgAxQ+UMRBawKLbq/auvSCi++TTC3o/4XQ31M+XO9dlXbZe
	AvVbluNpm+RZUEcfoN8PtYPffdLLRdni8y6UciPQ7f9F3TLyeuVA2
X-Gm-Gg: Acq92OEt5l+JmAEnykvTwxyoAb22pO53Xq1p/AmA6ySAV21NqfHeHK8Nqx6RQLjCUpR
	XRwgtukQD4wmJr+2DEZZecgtpJIOVrnTCCh6UCyfmSpzTAYGXD+spKbC2bjUsr0HsvPqX0LqIdC
	XvNkYqv2/6uvZ5DXjJ/VTXKRnzN8aE3yf/IywoIkKfIqiZECfrGQsKxLoEErJvQ6hpvFky8GN9i
	qahA4yue/6n31FYFL+BP1cosmcjvr9zos+j79UuqH3UxzSf2u3uh8whmLo9u/hmdlu16wh+8ozF
	Ck9UwH0m9cLK/uUuvLzF9RZaXJeTv7MKkUw8zTzgbRoC/0iyzwSwtvbYn2ZssEnqeqfxCTHonrJ
	ALT4C7Q5zEhQ5kD1J6Xhm11aqxJ/k/jUoYHb54A2c1P4Rpabl0Dx1W2qYOoFBDJgUKPBUXDc=
X-Received: by 2002:a05:620a:4802:b0:915:213d:837 with SMTP id af79cd13be357-915213d0e12mr240400685a.57.1779975940613;
        Thu, 28 May 2026 06:45:40 -0700 (PDT)
X-Received: by 2002:a05:620a:4802:b0:915:213d:837 with SMTP id af79cd13be357-915213d0e12mr240392885a.57.1779975940161;
        Thu, 28 May 2026 06:45:40 -0700 (PDT)
Received: from [192.168.1.3] (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f86ff80esm825920285a.13.2026.05.28.06.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 06:45:39 -0700 (PDT)
From: Brian Masney <bmasney@redhat.com>
Date: Thu, 28 May 2026 09:45:10 -0400
Subject: [PATCH] docs: mm: clarify that user_reserve_kbytes has no effect
 when overcommit_memory is set to 0 or 1
MIME-Version: 1.0
Message-Id: <20260528-mm-clarify-docs-v1-1-aa88e83b4bfd@redhat.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQqAIBBA0avErBuogUy6SrQwHWsgKxSikO6et
 HyL/zMkjsIJhipD5EuSHHtBW1dgV7MvjOKKgRpSTUcaQ0C7mSj+QXfYhL0ys/aaNCkHpToje7n
 /4zi97wffbkU/YQAAAA==
X-Change-ID: 20260528-mm-clarify-docs-76ab8f82826d
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Matthew Storr <mstorr@redhat.com>, 
 Brian Masney <bmasney@redhat.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1365; i=bmasney@redhat.com;
 s=20250903; h=from:subject:message-id;
 bh=nhsyimBQ315HBr0MkYf5dXK4pQhhIUcYzbD+bgi/3No=;
 b=owGbwMvMwCW2/dJd9di6A+2Mp9WSGLIk3P7+dlx5slO2ew+X+KooNZ7Fgf4L31/bE8KWtin3l
 +qGqcv9O0pYGMS4GGTFFFmW5BoVRKSusr13R5MFZg4rE8gQBi5OAZjIgUqG/0nX9onfjnuV7KJz
 X/jm/tC+7DmPpetWv7kc3FNxJ/JUxmaG7+6f9O9VyuszvjTNrjvvOZunt0HjbFRHSvukvWKKdtW
 sAA==
X-Developer-Key: i=bmasney@redhat.com; a=openpgp;
 fpr=A46D32705865AA3DDEDC2904B7D2DD275D7EC087
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p1GZC_dXyj7cAlsUVwb-slNXjAM2XlbUkocqnMeEBM4_1779975941
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7jun4onx91muds1tay6rpimn9pd5dffa
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 39773C0002
X-Rspam-User: 
X-HE-Tag: 1779975943-417016
X-HE-Meta: U2FsdGVkX19F4NYUs5+0tCU8uSdDOd5X2yHIL2enb7ppYkOuqAuBKrywKzP9oKYfUBwqKOYrurCs8o2W3VibLNdWs/rU52mfxRov3JqSQFPCgplylMhNwYGu1Kn2ddWgaQtvD10J6JF2OuYAAQgrBi4Ghk94RV+FOr4OZwKp4/k9xwJBJ46gfEaHiiXl/deK0BRFTVowTS94cCYqfINj7mQYV9jwqpv8OBR+eQbnaiE4YTNK+WvX/4nDGHs3j98ZLCUC1Ma5H0z+X6U5yQQzBcD4io6APV0ZHaxqgHT63sEWZsThX1nvkqVncSmtK4NNIJdBDvOC4dJJOD4IK5666srXIp3kA+XyQtMPFtWvARTI5nFtd+6VDl9S6SmKfmZsOP508HeD83JOONDPHTKjt4sK4nETtmEAr8JpwP8J2ytRYGLknUMSuZtT7qAmYriKr4tLzHH2lgdbYyw/xUwQ9g7jb3WD1zYyD+TEkjTF/s8L+Q4ZKezsg2Oi41/SxDq8S75ADnMhwik6hW/GocjqppdCJqHZC9igHzgsQu0jIIIo2LYeFIyEuIy4QHPLOjYW3droBordtWt1VVAygNc8RaeHBiWCIemz6Iweg2bYK/c1DoiLrJ+WAB9iLIIjGThdCVs6a/YhqwsJ2k6Kjt7+FOle5+litg4mPzZpBChz3RKDb4ieRmLbAqbV2Jf7/PUPRzZNQ62CRE/NaFy8ROIcvNZA9zfopQN4epj6iZITwST68YLplcUM/h8CliWck+VTCY+pfF1DcJqkZ6uwvncAFXCuPSgq1USZtgaEtdfa+HD42NH8ugPNp1fJ8hchCY+7MCMr9JQY4YDgMAQ4pIUFzCbEv37mhV/hLhWst4JLwOmV4+yqbp82G55e4+4WbdZ4R2w0B60t1JQHVlTlpGMUOQ4FyU7vecU9HGIq15Bn3BXsfwJ/v4ddLl1nEOUhVj8Cx0IswRXHSosXwETt259
 9CW8R7iK
 jL/RrHnqaoGX1OtFlK4PmTmhE4Ayk9bif1hPYc9KkrtwnnsfVsyZySWP0JIQaJYpdCbwLzf8x+OcWGoQdnqBk63FyfTuIhFpNkeC+kEQh3z8csIGP4ebOUQJohTfg4cYFD2V1dFbWZF04PjuPGJgWS01WQouVfnKdRvDHO1w8KMxYSZoFu7JG0f4ED1A9FNN61dTTpTFl9oWYjt7GiQb0KWFQLSZ2Hj11tXkR7v/qsfQuz6XncrL5c99tC4iQ51D9ohT0WjbYwhTLNX57umThcvESKjJESaKjJSjVZTY+fQBzgmu/EUzCR1yvEpg6g1tNp2czlVAhEjvfrTIkZZTqFNeHr00a3R701g8ReinqFbWJYUD4skzGGMnUYbnj5IrPlmcgkE62N2PKQWXulWugDYzobuB1+62lKzgfCz1sUEP5/7kgTboN3OLxT74hKIY9XXdsHnRQWtb4SBtxnr4sSnz1zMge+q7FbfZZoUE/bLGcQlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looking at __vm_enough_memory() in mm/util.c, user_reserve_kbytes has no
effect when overcommit_memory is set to 0 or 1. The documentation for
overcommit_memory already references user_reserve_kbytes when the flag
is set to 2.

Let's go ahead and add a clarification to user_reserve_kbytes in vm.rst
that it has no effect when overcommit_memory is set to 0 or 1.

Signed-off-by: Brian Masney <bmasney@redhat.com>
---
 Documentation/admin-guide/sysctl/vm.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c..b9b0c218bfb4 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -1034,6 +1034,8 @@ min(3% of current process size, user_reserve_kbytes) of free memory.
 This is intended to prevent a user from starting a single memory hogging
 process, such that they cannot recover (kill the hog).
 
+This setting has no effect when overcommit_memory is set to 0 or 1.
+
 user_reserve_kbytes defaults to min(3% of the current process size, 128MB).
 
 If this is reduced to zero, then the user will be allowed to allocate

---
base-commit: e7d700e14934e68f86338c5610cf2ae76798b663
change-id: 20260528-mm-clarify-docs-76ab8f82826d

Best regards,
-- 
Brian Masney <bmasney@redhat.com>


