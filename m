Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B30A7CA0EFF
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 01:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003656B009F; Sun, 24 Aug 2025 21:34:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6026B00A0; Sun, 24 Aug 2025 21:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBE306B00A1; Sun, 24 Aug 2025 21:34:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C82D36B009F
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 21:34:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E62216013A
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:34:34 +0000 (UTC)
X-FDA: 83813560068.08.8025FAA
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7477B20002
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 01:34:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F+WQZRkW;
	spf=pass (imf03.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756085672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7WGdMD7pS4V9asD7LoLkSW2uvY5b3XN5ChMyE9HGl8=;
	b=mux6r0+c49xmK7i7ENUirqasl++o6504XQqJjgGnQHpAqFxWDxHagV+k1BPB3Ny6hnCvBW
	MJGxP3F57DGyBHwuiNr/DgKs6gYHg5wvVGbRQqqD0LmolUyxECCaXYA758puLha2PSQIb4
	2RSA+KPdOuul6Rl99JSpc3EHZq4mgdQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F+WQZRkW;
	spf=pass (imf03.hostedemail.com: domain of visitorckw@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=visitorckw@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756085672; a=rsa-sha256;
	cv=none;
	b=Aa/1kYYz2/gIghhX+FHegLQM3CdzgqfWIMZBNNmswSve7i8wKUy+ENLQ6JzKVIOIwmZ8fL
	EdsQgTwPrLTzMdeLHqm6qM5OYu2UU37onUoakfeQWxP0vlG4QXT8JhRv41eVg0555lD/92
	SCy99ZtcPVI0TkJWh6n+o2r+fSZz31U=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2460757107bso34407745ad.2
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 18:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756085671; x=1756690471; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7WGdMD7pS4V9asD7LoLkSW2uvY5b3XN5ChMyE9HGl8=;
        b=F+WQZRkW4dbht+ZR8vRjk5fQfL3EGltw6Kw6s1Uo+r96a+WQZyuR7BexTSQkoZF3yh
         CTYxKk0SdKYsiymddEvET3RqJgEmnrzKypuLjIiQcPhUGRHCjRDeNSVTU5M4o+avKT2A
         zQM4HMMVN1mY1b6yeFog/QKUNP7GwKLjTj0jSm5iLWFFKPTOjKZ9XYXhsiGcV0rFxbb+
         i7xVBDnmMBLVVbelvkthgo/xclZ7/nSSdGygdoVsLgA2osfIJWacNjfhlylcOZB4VEXf
         +x0N8mYPDgPj6054bgTYfhajZpWIGMsR3TOPXTxs4eqHB8SY92wCd3lKEkusbULbD7Fj
         E+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756085671; x=1756690471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7WGdMD7pS4V9asD7LoLkSW2uvY5b3XN5ChMyE9HGl8=;
        b=wki4k2LXl3OquLHa9H+QQkZKWbQNw1P84QVXsmusfqNyOnGxT9KQDwqKFkTZt+DIlT
         k2e0C3Jf6WxuDmwYhhG7r6aqf7hftQIHu9zN4+/ZVX/Bw5L/z2w/cgPBmf5zKQdGRTfG
         1vRhB32sLu2g9IRFZLc2VfEE/jR1oiAwRK9lYEB+7KkmkZyaK/O9QMccxh7AmtN2tzbF
         w35zpqvZb3xvswd1Q62d38SaurBhryLzAfKj5W39QVzrpMqTRLIC87xweVG4TULezOcT
         reUOE3+TRw9eV4SpG0Q2fdRybaTtd2zq5ogiOHpaL2nrE+WvRBoNheXSAV1qk2uYFryF
         B14A==
X-Forwarded-Encrypted: i=1; AJvYcCUDaiSjELec81Ay6UP+UYaZd9r3gXyzgKFHmKM/1FCIv1YYhNyuRgjnSy17fcDxXTgKm4NeHut8pQ==@kvack.org
X-Gm-Message-State: AOJu0YyNT6JsVIOWYfWgYOr4OADhXDNBJoXijkE22Id36hqO+mBQ3DnS
	XxrNB4KrJPkEvRmPh/j01rvjm56+q3d7yzjWa6Fe7mSvdYn/CjCB16Uw
X-Gm-Gg: ASbGncvRDIK5vxat4dTMDTgag9G19y7NAFny8BJHtkqmLX0UrY8MQUTx2Llxsr6QcLW
	cCQEDbLZtmOonPKWVdv/I3++RGP84rm8S3g6vrC7Im2I+1mvIhGj7VdQcMCGWXJuogbMR58icqg
	E1H786efbwA0pa9W0p1N5SdIi7E1c6rDjNFMbhgbKttwrqSVogvAZ3QANICpisIT28QOmVu5A8l
	0bFALymvLft3L0JUnGivmrkt8S4z1094aDnbW1W33oca6UCEJMo1TgCifRrba2OWkaZQYtJ087x
	3kkeP5AbDbunquPE7/37Yi6Negc06XajJOO7nE0tt/cBJ+G2HuOH0nH2Opw8ZXojxztkm9NnVI1
	urZoNfS0EymUlqlfwYRSYe27Y/UuFum4knxDlZHhpXkUhbw2/bOwgC41CzmJnK4FZ5KGziaGTcQ
	==
X-Google-Smtp-Source: AGHT+IFHr2kZ+775zp3IFYdEzoyHV6hkPMxZ/zxmEszseN9VFqHSaX4x/YJAyQmWz2RlTyng40GOOQ==
X-Received: by 2002:a17:903:1b6d:b0:246:b1fd:298c with SMTP id d9443c01a7336-246b1fd2fc8mr42463345ad.1.1756085671109;
        Sun, 24 Aug 2025 18:34:31 -0700 (PDT)
Received: from visitorckw-System-Product-Name.. ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24668880a99sm52425995ad.121.2025.08.24.18.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 18:34:30 -0700 (PDT)
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: vbabka@suse.cz,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	glittao@gmail.com,
	jserv@ccns.ncku.edu.tw,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kuan-Wei Chiu <visitorckw@gmail.com>
Subject: [PATCH 2/2] mm/slub: Replace sort_r() with sort() for debugfs stack trace sorting
Date: Mon, 25 Aug 2025 09:34:19 +0800
Message-Id: <20250825013419.240278-3-visitorckw@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250825013419.240278-1-visitorckw@gmail.com>
References: <20250825013419.240278-1-visitorckw@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zsxhf1s8n7nngmsdfn5m1uz8km7kw7dw
X-Rspam-User: 
X-Rspamd-Queue-Id: 7477B20002
X-Rspamd-Server: rspam05
X-HE-Tag: 1756085672-962130
X-HE-Meta: U2FsdGVkX19IZ/g3pi6ZrjlB4KNuL4J1tRjByBpdDvMqtd2rPYDD4D13hxv2tkGrkNMcwKCh39Ay7TGMgrKeXU4Be0Yj4XJY3ZTu0e5xw/XNTozCeTY0ULIL08ill2y5vn8dbvmf5PLayxHmbkRjdQM4nIMe2K0kPjaQpp7OrzcT0Vz8t11aUE2oP3RNvRb31p31MPzRlAjgqJ604v5JNRLxDhQDca6kDReJs/kCCJtUn1S0GSRxoze0sNNeJthZ6G9KSnnt3t7lsp+lUpKkNOnfaEUtTiSAJ2KnLcN1ZyHi4XKLHjlG/ZfXFQvI50QWNYkCfPZKsnxrOoCEQeK0qnyswAPpxPKra6FQ+G3WKMinMXfxISpEEo8ID7NEjqDm/VDjH4xfk3En6z4Kedozf0XpilQLytiqO8E8koJZPHX3uodZVLCezubmPAJUkSKVsYxdHwF2VTSSOwhO5g9LyRtV2jhvgFE5ZM5Mzexoc+g2EvCi8rIjCdK20lqBUAYZl4mnB6htCV+s4zdPKn7ggh4b425BCAxuLvVShQ44E9pttuRw76AuKGMp7BudfMpkJ9SS/nukAbq+hZmlWv49hY4iaUCsaOrjT84Kk3a6UmtfKxcaqo4HgolFRDTs9LCBN6AyvdinivaOD7BOQJdiBxQ6mCt5rwVkdtfyDBElNqyIyl2aej24tKhRzpCtyS351d4AKuU6LC3yKqtU21g05kgVT8NnWvq0TJkPBGHheufDWLpvISNUa/gsSgICd5D/joxLUqdliZo5cWbLMECWXMsOve4K3D8Fszwvhe1E4reVl1GyqqQAbM68VN3rDAwN3v4O4qGRtlZqovJ40/xHBdyJm/d0f1Tpauj64zk+3vMSgn3gwjUgF6pO+sLnblPwdhHv2ZkCw8Gn3/yjlQh1nnFFRthmi5c7c6rG9YGSJjWcWnPmX0hqfUtBb8UU7t/k5ewWHEGlq+MndlnVQYP
 s1bCs1KZ
 ckuKwUmnGGzJp8+wlWwdJWVDIn7ENl7QPwjFXj2eWrpuf2wnXly+kXw/tqBfsfK4PSHrXaCfh2BqkDX8xPxSXeRN4qVi+BZuXTKT9pXmRlKbQ0wwqbM69Ou6+KL0FjVDW0tM9yuuNa52yiLGCA1nryKZzg3eCdVaJioNH4zobr/C8txdbCjQEfqRLCrnTm9VyfsLPgpxdKlP7EBQlKSW+zIRkwMTrIc608ZYFLSOUY+BKQV3604v2meV8qyjVY2CdKR+NruAp0m2rMD3B4N8bmgy3qgyWCrvmg3ILkPSWGVqF1vXq8taF+WtWroeeHr9K50V3EVY0nEG1MPpBq2V6grCwmbrvOcejqMPeVgrDpbV+wFsMzv148tc9Xgix0mhwpXtHnfI11wxfRT72k+FC7qrWkJBRfbmWHlnGKdYf/uO5Ei2LJtlDShhFYA6WjKJjPEA9CpmQLeJ6kl0=
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
index c91b3744adbc..67b68f132f84 100644
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
@@ -7782,8 +7782,8 @@ static int slab_debug_trace_open(struct inode *inode, struct file *filep)
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


