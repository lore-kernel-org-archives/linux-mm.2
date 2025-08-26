Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E292CA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 06:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CD718E00A4; Tue, 26 Aug 2025 02:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656838E0090; Tue, 26 Aug 2025 02:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A1A8E00A4; Tue, 26 Aug 2025 02:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0238E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 02:23:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 049F1118D42
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:23:33 +0000 (UTC)
X-FDA: 83817917148.01.53773B2
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2CE7140004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:23:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NyAIxpR+;
	spf=pass (imf07.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756189412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIkwDyhxeRC9KaW10KQxZAmgX/lJ0Jk/lOkmMojQenc=;
	b=oak/UL9flAIjgzdsXvWTixEm8zBvzHlbciKi1w9vSH8Qn1TC0LZhUwmOULmfwHilt4tzLj
	41Oyc8u/tdY7mq91j+7zFPS1KxLBIIZsFlA8/mtrgRmejtD3Q6wmi0BGJq6MFMu9BdsPvn
	jmKr4OmVTUn09lpyXYdNr3vvx5npvU4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NyAIxpR+;
	spf=pass (imf07.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756189412; a=rsa-sha256;
	cv=none;
	b=jTnXvUExMLAK/MxfowkLax7jThR7KkzO1kYX06+W/l9IYf0E91ckeusP7O4yhbaEEi2G84
	/NEnTvgDBPXgvRg3KrcseAdIDCqhDe2mmfT9BArfb7x73t34FcpQeL4SY5Z3PZFLqaXwqS
	a+cNcl+0Et2fADEOBpb5F0E9wecWPtw=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-76e2ea6ccb7so3998852b3a.2
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 23:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756189411; x=1756794211; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OIkwDyhxeRC9KaW10KQxZAmgX/lJ0Jk/lOkmMojQenc=;
        b=NyAIxpR+NehKc9AL9wh0HK+3YWnlQbmVSDTs3nkwuKl/EvHCYsKTluzhdFDXve8i4N
         DOaLjWXPCh+sIHcFsg1xlX/e92XwzSUEM6mwdRjyFWq29i1V7Bs8LZakwGaZKXemKJtm
         0DSSz0yXT5fy9UVTTBB2+BfFAt3aUWS4LDK4fl8F6/WA76mBsDJe5bDz0njANiZPAaq0
         YVWTwZNmb7R80co9VRjhsOfUz25voPxAWmDLCqKJ80T9FOMgEmYkbp/zQNSFA14MJj92
         cYA72Ghnj5j+d7r3Aqpk8TgE0/D8aAcn9aJgIQNak3wYz9VTCLSgzYGmFFgEWVqvJuff
         D5yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756189411; x=1756794211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OIkwDyhxeRC9KaW10KQxZAmgX/lJ0Jk/lOkmMojQenc=;
        b=H5XrOUgRyxZr+R7LZwMpanojuarQM6GpncRasN3rcF6940h5i8p/gbTeMvW99lss95
         xRLZlJgahRkr5HEpIno9FiKcroC0gcfrMoCEgk7LPykDZts2tTvgUgm7JpRtw+EmzCZN
         OGY98TYG9skNbUtFjoJp6zRJatQhkDIH5dW8DvNxKQXeq5UDFiXKl1Z2r6aRvsA7Lft9
         Llnx5N2+8ADomgRV92fI78V10+UcO0IuTgjqiuao6mn7hktYecTeTpr7x6VdecIgaywt
         OnoJN6Dpt8NQLCdUj/fbIZYvqBOfTlEutGmSBKweykYEmKx7pTRVJWBImpZ1hWp1iSLA
         aWJA==
X-Forwarded-Encrypted: i=1; AJvYcCVkVgO2vTRU6YIKoTLOA0Xq33NRnMt1hbCyzvLWzzMEc+j2eDwVAbo/kF/AMlxLsjRRLOvUO4ipzw==@kvack.org
X-Gm-Message-State: AOJu0Yxmdj+dl7hcduWzny1CKhHI99J2I13AZlmWOzG/p+Rh5KnqMboA
	lg/b6wMjQ4fpfAngoxASEP5RXw00BrK5UfgTgY+cET/n0IDOpYIiicMN
X-Gm-Gg: ASbGnctD03Xq39qnUoZJof2ExHtYdqXlpgbRhsh6UK2Uu9TJMKEPbWhWqwU/X/RD1RQ
	PspZssLlOJI09dKUHrZx2kcdQ1MJXCmg8S4U5UHzYnBlj5236kUOr4oxRHHGausXQDFkqxBeZA/
	/fYgqa/PQ+C50C+EDijJ0HUp0Ji5ZeMBoUMwC72FNwh2nuNLCsUbjjVHGLtMxslikH31WFMWwBC
	gWV6tDU25KSTknynVAsWe4CMvZWTWtuP3OPfTtGldTVVlMA2UyIWARXF56UNcXw/T65fGU0yOu3
	orvIDZmTKMT5RKpdKzDG3BupUUcGTD3oNj5PIC/NbAaods/WyHjltwQ+yp364mQX10w7gh+cqds
	yl8HFBhGVb+7TADvv5+ih1TY+8qH9r6n6SaN/h12S69n+Euug4aCDshFARy/BiBw=
X-Google-Smtp-Source: AGHT+IEVmakc1sTT/jj4NROLgnG5GSB/qkE6B1uuzuSzoJh9ZET6//lRRxrnhGh2veVhZQOgT7nbwg==
X-Received: by 2002:a05:6a00:2d0c:b0:771:f393:ceb3 with SMTP id d2e1a72fcca58-771f3a31abcmr3337714b3a.16.1756189410887;
        Mon, 25 Aug 2025 23:23:30 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-771fbbc3bb0sm492535b3a.66.2025.08.25.23.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 23:23:30 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: vbabka@suse.cz,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	glittao@gmail.com,
	jserv@ccns.ncku.edu.tw,
	chuang@cs.nycu.edu.tw,
	cfmc.cs13@nycu.edu.tw,
	jhcheng.cs13@nycu.edu.tw,
	c.yuanhaur@wustl.edu,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH v2 2/2] mm/slub: Replace sort_r() with sort() for debugfs stack trace sorting
Date: Tue, 26 Aug 2025 14:23:15 +0800
Message-Id: <20250826062315.644520-3-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250826062315.644520-1-visitorckw@gmail.com>
References: <20250826062315.644520-1-visitorckw@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2CE7140004
X-Stat-Signature: nzf8pd6h1egncwac37mqgttw1k1racya
X-Rspam-User: 
X-HE-Tag: 1756189411-472359
X-HE-Meta: U2FsdGVkX1+mzAQHRe6t5grrD+GWLQ+OlAVuYPj/PwF6STnxJjrORMh6fw07oE35RHOc2FX8zwxJHsUc521qGW47iVRGM11a5U3GlUbOeoDmCaGslgcz6yVFBZ6dmymQwtFJcGRFgafBuqzZgnkenmbUkpN79R+YHtKwXLWrpG2KfOt5taBEY8E8cT9KUIisH5RjWOXd/jIZK+eRdTMnysSOlcjE4USjoPFOql3pndY71zzSRUo5opx2GObS3JuT/TrelCWhBha+FuXRNVc+JYmZQ+4KmymPdeOu9NcnAPyjr/9NS66ixukvuVKfl8eDaOAkHA3InAaf8jkj/fBvYxVJow4phWPylI+2RpWO0xJ3od8fb/ETPI7S6+5/DQYELhCO5JLKbO8qMO1TqjCLS3Qi3hd2PdZ4PC20gGX/+2cA2BLbcNSlh3Qpx5o+mTioPS+ljl8teyLRLPw3zaZnautBELC6+x6FYFJLBkdJq0ZuiEmOVspAfqJ2GKY4hDY6pNSJ5DoH/WroMMlZX8l4XGticgLqMeUuGxmSdKtPlYfwdK9FkV2dZi6TxvxUjf+fMpBQ5rOfe6yCvm7uU8FG5ldA8F0jYHYLj6jbQ6E2OTsvEkNmaWPE02RXvBVvAbWff0zNzwS86/c7n729P9obf7vnA04jMaLOpijRdWZiXDG/W1OKFVriUTsg47xtNuhftuXaPLTmioo/hP9fU+mxnQD5dazv56YAAwKe+Ej2TEvM0lOI8rVs18+bVmvCPg45uViKtXofwFWuKnJMaFY9vLQNDkmOmZttPjwMiwobb/PFhaFfXLRm5JNzqVZvy+qhb9tPMJT10zcH1uM61YSo0PeXaBK0eX0se3U4qmQk7D7ubd5JWrIh6x/c1HKuy2H4TtneT6Z/0Bcp5pM1GSGooBuCsLAP66upnBEaJQSCyxsSCabAPdc/Gu8qYhsWsa3zPxvG39RrQFAT5H2zfRi
 ZRiBMhg3
 CyHQRdUGrFi/Kql55zYzPQWSJ+6FsoDmNJyHjtq8+CabE30ASKsgm7r34W7alc6soyLCMqUm1sYEVHzTM31VXWTfrPhJEbA21qIgYi5VrGo+pAg90OTgSy11HnukzZxaAdfRBONl/IRFGveRY1QGAlebn0d0YRvII15zQBinYT09CuIkgpBXqjG2xYACAex+cAyKyPfTpptmgAxCvk02nDW+MhxahPK23stAN92Y3Luz055WXra58cCdtSXyZ+YP02S8MoGXjvwMjN2skVK/qvabltreKRZr/kW+sz/ulbumjmy/t3SAmHzI0nAfjHQMZpZDLGkT2BeLvDV6dG+PqXbgPYw6mMI4TVGc4VT63Ha4GhZoQl+7SY67iUc3pYqU839NAVtXnACL/kLtxKPr+pESAVJ2u5+YqP5RHRfxQHHbvSwtkwA/QMmaW+nMHtg6UIgTOsraTF37zNm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comparison function used to sort stack trace locations in debugfs
never relied on the third argument. Therefore, sort_r() is unnecessary.
Switch to sort() with a two-argument comparison function to keep the
code simple and aligned with the intended usage.

Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
---
 mm/slub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 081816ff89ab..39a238384892 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7711,7 +7711,7 @@ static void *slab_debugfs_next(struct seq_file *seq, void *v, loff_t *ppos)
 	return NULL;
 }
 
-static int cmp_loc_by_count(const void *a, const void *b, const void *data)
+static int cmp_loc_by_count(const void *a, const void *b)
 {
 	struct location *loc1 = (struct location *)a;
 	struct location *loc2 = (struct location *)b;
@@ -7778,8 +7778,8 @@ static int slab_debug_trace_open(struct inode *inode, struct file *filep)
 	}
 
 	/* Sort locations by count */
-	sort_r(t->loc, t->count, sizeof(struct location),
-		cmp_loc_by_count, NULL, NULL);
+	sort(t->loc, t->count, sizeof(struct location),
+	     cmp_loc_by_count, NULL);
 
 	bitmap_free(obj_map);
 	return 0;
-- 
2.34.1


