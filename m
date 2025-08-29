Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 954F4CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E216B002C; Fri, 29 Aug 2025 14:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197776B002D; Fri, 29 Aug 2025 14:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00FEB6B002E; Fri, 29 Aug 2025 14:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E11A86B002C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A09BC1DEBDC
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:18 +0000 (UTC)
X-FDA: 83830639956.07.F933103
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id B6FBCC000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="Asd94ZO/";
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf10.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YptetONu60ua7xKiQIttVSTb9jDe2/acm4my/H0afc4=;
	b=k7Yg6dwQZoNMAxhfY74sqy9NCPPVAk9mxIy2roAwav64XF+giB8GwA0oH9scIkQsun0GXF
	hy6sCWf1jb1mCMwDr93DQ8p3CQ8mdw48+OU2T+7Ruaecxo02uMGtrbsC6VnziU9YaFZd+D
	w5gr5guL91DF1WQJvWePHl7SB5ceNwo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="Asd94ZO/";
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf10.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492336; a=rsa-sha256;
	cv=none;
	b=4CCwKgYIwX+SQR5VlSlHNhtcoIkm1spLJjvbwtJl4W59HLEF77N3thUgQkE4/leY4eQAws
	2MtscsjEX/n4foxD15AMoxHc83X+kIysQ9i3+tEftTEDpLaGsLpC81dX5JasYrNpCbL6wr
	YQS0V8N626CUp7raSNk7ZjNysuJr5X4=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afeec747e60so302033666b.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492335; x=1757097135; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YptetONu60ua7xKiQIttVSTb9jDe2/acm4my/H0afc4=;
        b=Asd94ZO/WmImEY+ivsDcP6ge+1Rk2OI9hBQBXjZPVURC19aqPK0PIGcxh4dx+QqVZ/
         zzrMT/7Ocfr0Aq+a/oz4tuCkbqm4TcFvL/CZItJow63lmlZMRBK2DtXNl2n5BKVuVcqv
         2txwb1sgtITdY8EOVOpaKYPalCSOALZmy0pYXYehB3zCTmVM2HmGNx696/N6QM1h4drG
         IqHRwcp5I/ehFz3kGbWSl4sYJnnu1gDSg8f0dlyJe/1cUv855YQjSq5HYYvDct1zzrnd
         xy66b+q7HW5bb/pos45SGWxix0yc4jxgjEp2Yshafrl2UHfEdfi2B6RMSpcsT666LPkN
         w7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492335; x=1757097135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YptetONu60ua7xKiQIttVSTb9jDe2/acm4my/H0afc4=;
        b=jIiwqUMNdlALW70NzCwrZTWNbThbtHqMbVXzTrh/lC6ySC4SCaJdHeFJRq3bSNC/vo
         L/XPQAPD2ADqf+NU3sHLBx8Sc4fRWO1RCiEl6wvIBcyvWcVV0WkRk3a39oz0UdHtMLxa
         z0El/8dzrPwGfjYoD5kxKKWEUeyBoqQRLrwUk9GZaOhZ0C3iLv4zN8w3CXtFqsGMy70v
         QEplwQa/V6xts0hIJAXBItKHQwYClWhPZ1a2ANuo4BhnPgWKVY4hgmncK616qHlPjZTK
         Y2MoivnTXfb0zvHK+lADpN0y41W8paRNgGvLzP0D0zkLFwAiYa99B9etKpIMPGAlfXz7
         y4xA==
X-Forwarded-Encrypted: i=1; AJvYcCWVYZEDRZwVQoDTMaS1lBwiV6SKgYL1w4VAGEGUR7xb47fWHwbQAkgVrC2S0tuuLJNLgjzBjxRR2Q==@kvack.org
X-Gm-Message-State: AOJu0YyrHzjg4SbY/pxd8u4IXnpvw/hh/Gsw7YhFKO3HOCYjLJh3PyCF
	OWHj+zviCcrNHNTBb8J00IeRjxDE0ZzTMV2KXa4zfyqYlx4MfI12eXJ//yZAyLW+Ylc=
X-Gm-Gg: ASbGncvKTUrNf35rjYK02SooiUrwPz/obi1ySFgGO1oPH2cehIdvITyKz9eBWr147xO
	GCt/jYOiC80uqDfkOo6C3/Ra5MuxnqWzQemKANBNIEdtqoPAAOAztZVFmYAw/me4G6rPwh0TZTm
	wmzwy3KvfKZ2qbfFOgTs1E9xLoFGwKXkaaKMGE3WufiWtoRM3XWPYQKHj9mNnCRq2yqtw3/KCmC
	PZre0MGgEizLpMjUYMy0b05oUUOPpqvexW+ePBGZe76aIwIFnWSsiesMiLRd9mOH0ff9Vqv1RAI
	nzoVd5VYTOlcRVV+iOOa/xBvQVdn3sB8UB4xuPWU62IXdBKanvxFpc0R1dZUrHH1gIXMF8HMv7o
	j7Er6iSWOEu+1AWDUO8e3akT6/SPQARD6GMYX4SkXTyfvhZJ2OBFy6G8j/5AcCXHzN/AQ9SfWue
	jwLKem5IZG79DhWxfS41ZzUpShBv8owCIS
X-Google-Smtp-Source: AGHT+IH+NuMFRsuGd4PF0q6uCIHQQAJ7dt/ECx++1eqEWlkBezyQqdi5BEB6pNrdcyXSk7s4aAAuHg==
X-Received: by 2002:a17:907:2d21:b0:afe:f7ae:112e with SMTP id a640c23a62f3a-afef7ae11fbmr572057966b.41.1756492335238;
        Fri, 29 Aug 2025 11:32:15 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:14 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 09/12] include/mm_types.h: add `const` to several pointer parameters
Date: Fri, 29 Aug 2025 20:31:56 +0200
Message-ID: <20250829183159.2223948-10-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B6FBCC000E
X-Stat-Signature: rn6q8o1gqttwto5wrcpycdm9yy5ra7pw
X-Rspam-User: 
X-HE-Tag: 1756492336-44127
X-HE-Meta: U2FsdGVkX1/3ICula+9yDjBEINis5WusNZVwkLxjSzGgz2xZzq7PZgeK932PoJr32FfSGDHxvrIMalCugUdQGI7FNKD4C+b17ceC2H+4f/NMKiJHQzObcyNN8KdQJ26fdZ8TvZphJdmKAVyzZ5+Ev4D8sz6qKNBbF+UdK+g7RdwaleCBq4XDWm+ehN2MQBBknCvxdVe98ndxXERyyWVY6fLwv9MDCdW6eaciW3cUACjNaeeriUw4MT5iyxnQTQboeq6Ojw6Yp07QANHSsSQtn02PUGXrtDAzbTrR66pLW7yO9a265VYBjPUNrrGVBAVZsmznD4bkuaYYMnRY8HEhvMCfIg95C+GhjvRfw++pWoCeJp/l3g2pstik9uq8HGuhx3tCv1zbh3Gpcm5fOMxspQpJ2UAAZe3yEBDgvLF6rscNHLhL6LRYNoaN1hNJqgeAgIQTI2V0CtkezQCInkxNlu3tTUjT3Ce4xcJX0Wc06nKcLV/QFxRP0OkGpgQNs9/NYdXrnZ8jo3MkhOowY5Waz8wIfluzh1jCF8ym9DxzJoCzWjiVeccqQh67cC9LBJrUM3IQwOMrQ9ZSHp9qdgNUThB4NmQTUbI9QS0SH5GOfJj03YymRHdIZlqnIFyQxz0O8UcjDIwvo/vmNAPgBqU4GrSyq1+RBBtOJy/gA9MD7B8cq+zeFRjVqIPgPb7PXECiY06a683tNiD1l2xCfXqdfRTG1WdGAmIx/q5SDRH4hluLzpOPiLAxPbrTR1fGtwCu6czL2DxN28V87Jh2maQCEzKcff3iq/RP9RCjd3wV0kEU+ADbnx9z7KD9haFsm1+glKPwovspmR1h2twP27Of/OtH1+MQnSugFi23hyAzMlH6qAeYX6g4Mb2N7ehB6iemqLd0TOxowS9QCwi8TAXDDGgPUEPWq7DZoK8mEl/rxhhkD4StkmKHWcqhmmaLpkE6xr89h7XEUheM9q6TE2Q
 Ca8yGb36
 G4GWbMcEPY4VsNz3InM8WrJdV6n/qadYkttK176vLVxl0JEAHq8MWtSwjtEQtRmRyrQEAdaWEKlQHGBOt7UoI0633kaLktJOLaxsQaqZViCNOB4LJHocx3HXK4NDXWWzBAVuDMN6jt5w0Ilqoy2881ElVggv7Dovd+Wu3jgIGL16YTwNoxCAipxcHFQfhUUNsJ5o/Ye5+ny9A4QSrmPtyJzWXKfP3+4DtJbCWXXdSlCx5EInE/fePylvpW9WDfvhmmTDds1pXd31cTiXuqS8q+WkrnBi88U5NtPDfkTMyGT4mESfHH0RP50FCZoj6RiSrXKfu0lr9/V7RrzcZSuGtelPwzOJ2ESvzPaOhkGbC+xLTaKl3JcRGT0wUqYMdFgrJbmHOF9fL9ZaT0rma+UaekPU8fovT5WurhNhK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 include/linux/mm_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index d934a3a5b443..275e8060d918 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -632,7 +632,7 @@ static inline void ptdesc_pmd_pts_dec(struct ptdesc *ptdesc)
 	atomic_dec(&ptdesc->pt_share_count);
 }
 
-static inline int ptdesc_pmd_pts_count(struct ptdesc *ptdesc)
+static inline int ptdesc_pmd_pts_count(const struct ptdesc *ptdesc)
 {
 	return atomic_read(&ptdesc->pt_share_count);
 }
@@ -660,7 +660,7 @@ static inline void set_page_private(struct page *page, unsigned long private)
 	page->private = private;
 }
 
-static inline void *folio_get_private(struct folio *folio)
+static inline void *folio_get_private(const struct folio *folio)
 {
 	return folio->private;
 }
-- 
2.47.2


