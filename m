Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20988CCA472
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 12:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842078E0011; Tue,  7 Oct 2025 08:20:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB058E0005; Tue,  7 Oct 2025 08:20:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644A18E0011; Tue,  7 Oct 2025 08:20:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1528E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 08:20:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15B5D55D98
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:45 +0000 (UTC)
X-FDA: 83971226850.20.BDDBEF9
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1F3E5A0008
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 12:20:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QDR8IEcf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759839643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4jfcSPGUvol/n8ObJSFwltbXIiILhsqpfoN+DLL7zw=;
	b=fT7EK7bmpeQ8db4ayCAyWky7J3CbJ/aI7VQFTWdSQ+arku0qItCRdyyDrQCbxGayaolsbD
	y9flxwJ2e+6qvO4M7/2+BSLQ1uwuL+kdEnwfVbhhP7Ovgul7TUXaQJaapVJEWtGcisw0x3
	GBLAtt8GSrJVgEDrjiPKFo1Z8khlA/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759839643; a=rsa-sha256;
	cv=none;
	b=hxqwg6jqYqxiG2urTNtGrEQ4rzZvS5Kol8jNKroHha0fZG6ZsfJ4mv3Y1oh7B/tp+zYVhh
	XxSE4oYRQ4PlKXCwUlzK/T+mz91nV5zRfhvfnJPf+ty//kH5eTrFmQ2HTDPZ0vIJ2utbQu
	R1zgyATheShdav93uZ8yR4f+A42aoaU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QDR8IEcf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-57bd04f2e84so6992286e87.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 05:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759839641; x=1760444441; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d4jfcSPGUvol/n8ObJSFwltbXIiILhsqpfoN+DLL7zw=;
        b=QDR8IEcfXL/0VBtn01oEXRCGj5Fos7Ffm56p9QM5fXAQvDx1vSmGW97rWltUl9Igj2
         Xhb97e35pDYXy1yUP9QpHMCP2Gxjy03N2KnctIJZ3a7JwQGmiA8iXCVat1GeX+itqwjz
         97tV2pe/Ff7Rf4HdqvYm2Vv6ENmt3N47i87IOwFviuMnPR9Y7SGyJB/l61ZQxzu1m6y5
         oFu4XcPeMTCOpB+Ss/d9UfZUdLP0+8iE82uMNrT+oJjfBn2ztOa9e97idrP5xEPbQm1W
         FlLks1zdArkArAGZ3YVcYqOIW83qEMXRZfknGHkgWF3T2wZ9IvTmI2W6szI0gG4VDL/+
         nmQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759839641; x=1760444441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d4jfcSPGUvol/n8ObJSFwltbXIiILhsqpfoN+DLL7zw=;
        b=lvyFjkP9e7bHdUXItM0FLA4zV0UA53t6iD4S+WwY2LlPgaCRxplOMfqcyuEc5OTlLm
         UEpoyiRoFK5PWYvR47KwfuIOV+7FdeCuXpu/78k1gJyL9LinMRM+Quhkn6wA+Pwfdui1
         Jos7hfKfcHwgfA5NsA93UXAjnpuwzeian/IMILisMY/aLhBnXftE5dg1c5pYv+MHi71q
         p0fJpNWs9JLllPaqrYEFUeHgeP8W4+szn0YNDF0zcQ7ZZGhVTQ7B/P7te/MGvfUyjqgR
         q2Oi4Xo1b3JVZKNR1EMGvojzFfKJVcHWpVP687cCjK6D3SaukYdDK0OIx44aWug/Kqvh
         t99Q==
X-Gm-Message-State: AOJu0YxSxIMywALepkV6CQr5RR0GrIyD0PgpN7wYsxTwvlxeOZNCryF7
	MpzvhGyvnazrmnnWyBcj1v3FrMmmTS+l7Gh3xPYeg8adIaBJWL/w/BRgmVvzLgkW
X-Gm-Gg: ASbGncvrvPeRZ2bNhT46QCM142MnH2K3CzaTBTlr0WLv2HLxs53cqfbx+IgsbhV2GxP
	umH8/OPIFL5Xvx6OMSQOtedixQPb2I5LViDNO3u1zf7ENxcNxeftIMGG5zhJYdAO6I+hzR7/TnL
	Vdwa3LN2TmAIfqbAZo8dSMwFEz/Lhaf3Y9DZKGgpCBGwNN7JvR+5wasZLJ4wFnRmjDRGMSaD245
	rywzRxx+OisjNVdNPzqNxO+ENfv2NLd1IN4k/EvzNzutAXtZtmbJIaAG+fG++HYcZLjW3LOpyxU
	LBbWGGGigTuI1XtXd99+W99G4S0oFnvo1cJGd42hgzMfXLkKYhtMG9WaRBQMlfKGZXYqLeo0GDc
	QhX849NIve6GOHy9fJ1g4CtNZYATrNBD1iDhRuQpD
X-Google-Smtp-Source: AGHT+IEQc2WJmMkAe6iyXzpSe8lZAqYIAKitVP6umZ8/QxBxHKvKILqVKMjkHlA4N1ux2dZmJgZAQA==
X-Received: by 2002:a05:6512:230c:b0:56c:386b:9bc with SMTP id 2adb3069b0e04-58cb956bb11mr4722043e87.5.1759839641188;
        Tue, 07 Oct 2025 05:20:41 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b01141151sm6061947e87.59.2025.10.07.05.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 05:20:40 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH v4 02/10] lib/test_vmalloc: Remove xfail condition check
Date: Tue,  7 Oct 2025 14:20:27 +0200
Message-ID: <20251007122035.56347-3-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251007122035.56347-1-urezki@gmail.com>
References: <20251007122035.56347-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: rttcsiqwq8pkp4bnkggtib8kfsnkx1oq
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F3E5A0008
X-HE-Tag: 1759839642-166337
X-HE-Meta: U2FsdGVkX18/sYbREzIijtjcTkGv071n00h1Haj+xySezJineXlSUsde+BDWlQOnZ3nnYGFnsVVQ4nQiQ+CGQefcFS6G+YUxnahpda7L/6alrfNcnFyqmDusXnDWVPqDwC7ydFUaCeCqU6BquAg3S8LED7vJtvF6qcNEHF/6r3lcJ94MlP95L05afJAlDrRxNGpj2JF/flYYxHwJyywKl2ZmqOdber3n5LXl5yztUQrpsD3NpuLrp3G5gB1t4AQzLK3yDI9rE8reVlDdFURk6tZL8tPYawUMPG8YBRxTuCRijlbhNiVpwbGfhw5cRKRWfkvbQa8e0VCxwmF35HTC+GzuUzT2EKpQ60TA17UgcD0QOGueJXWmy7Bm43EcH/Dk5XyvnkAueKoUnw7UxeQCoUqiPoSKpRPzfYytUHMudWuGjnlq9uexw3GuS0JOjRNrH7Xv4WZrZWjVr+gUfFMLJqvhxR2v/rw1luF8vDm+LFYy1P3EisWE3+Nx6Hw8BHQ+ojLuhkpLZ0eXi2ncvqrK1DeGA1en3TmVLVQYET+BRm6QixFZQNeMhQf1rBWDrOiAMVzMx0AAhQJ9qTkqKcHtuiX996VEKmxb41++43KvkRGcziSZnNB0eXjQ/TO9K3VzIrHhR/mYePupYXMH82qvIcNO1Evk36IseR+LMx1ZMhO7u5ho0brYL8jvW/Zkm4r7TRKdnSjoyLS8K3rPBF7gh+ES1CBjeg8MjT6c3GrCmIjftDuQ5OG65L+odWY5oHUWTzdvh9ge6DSCGR9O9i5nMTKy6NYrr2W9McXQuPG3ySMqtH4OgyS//l8hnEKfVahh25sTrs8b0FG55qRe+4Pwot9lm+uszA632EnyQCVPzTnPvNY6KrR00H4XP/B1SZX7zoeOJGzrvbrvfJ0Ve6GzSvYyWX6NiWV8X2X2n0mXS5RUFkjoW+qyvdruMlL2g0eru6lbVkcGLf2iveXFw7g
 fE8vZcyz
 pepmIWpSdtiBABZtgXHBOzhysWFgroxrWN7DDJ6s+HXIEML9LwZGJ/atHtBbhh+m2ewD6da2yd0gwGX6pSyQG2Xxm4LULOKDuUvuyGMV+OfJxkjAeUHNWftnv8mmtD8QSSC2axsiM0HXgkxzdahXvqilTsfOqUIHqbvH+g1pHs4cK/5fy2uCWQb28iumUXuJaIbjVv3DB0El4fk3sNtwbYlqRINnP2YOUyoiKu0hbT4/WSU27hZY5eCgckuzSscMuqBa8AX3kE/7QCHvQV/7dsCQFFmxsuOJnNOt8G88NtBKNoZunviH3vOtVXU004pu1S1HxegVL6ZqgI2OEc/PrKnjytvsWmR746Ms+u9S7bNkHXkfJXP2kiez+oyahxMz0XbaeWpNvV0boNOsrwGzRBhETQRCG7AU1cWrdDZsoqEHDMCWjEXObsYFZ6RdayiiTyKPgNB+6p/Eggujt1HeJT3BiCVJwpWiAWLwPWO8as96sTzhLow5Qna1Hhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A test marked with "xfail = true" is expected to fail but that
does not mean it is predetermined to fail. Remove "xfail" condition
check for tests which pass successfully.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 lib/test_vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index aae5f4910aff..6521c05c7816 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -500,7 +500,7 @@ static int test_func(void *private)
 		for (j = 0; j < test_repeat_count; j++) {
 			ret = test_case_array[index].test_func();
 
-			if (!ret && !test_case_array[index].xfail)
+			if (!ret)
 				t->data[index].test_passed++;
 			else if (ret && test_case_array[index].xfail)
 				t->data[index].test_xfailed++;
-- 
2.47.3


