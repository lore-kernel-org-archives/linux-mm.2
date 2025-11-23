Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C175CFD312
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 03:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26856B00B2; Sat, 22 Nov 2025 22:05:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6976B00B3; Sat, 22 Nov 2025 22:05:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC51D6B00B4; Sat, 22 Nov 2025 22:05:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A725D6B00B2
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:05:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5693E140A98
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:05:11 +0000 (UTC)
X-FDA: 84140380422.03.01128A0
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7698318000B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 03:05:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XtLWa+AP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763867109; a=rsa-sha256;
	cv=none;
	b=pqTFSvep7x/pV8BXQB08RSB+gvj7m2YJgvhsrqpfq84ypOozEsZZEXMzFvMSJWvzO+2QQV
	K53bq7MV2UYrTWhYyvDP7z9SvQVEorOU/xrP30ZM45zpMRUBkbdaLo1N4cI3XZ8VRL/tq0
	oyoMOgnmpGs4m4w6yIm1zjs3FkzBm6U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XtLWa+AP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763867109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PnnYqS1Gva2iq8RVemeTHL95j/HsRMm9CNrwh4z6Zcs=;
	b=g/raqcamO//GqKuTHHduVb+Sa1wkcUMm4MYEtDx8hAfoeqzxpYHnsKonKjmHkkiyarzMZs
	qL+PrM1DTJ71Rk7r1bM0ow7X1OsTh68OsC3zHX37pG1moDLDKKkzt1+KzEpghNJlwkzOaA
	H1by9U61o1yQoKNPFtSGzH+BiSegh6A=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7bf0ad0cb87so3006127b3a.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 19:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763867108; x=1764471908; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PnnYqS1Gva2iq8RVemeTHL95j/HsRMm9CNrwh4z6Zcs=;
        b=XtLWa+AP6r+MD4HSztjAT2NAIELUAAL5mdp2LUld0+iRNw0jsG+1vGbZZgRM+N6wyH
         VBoC6KOaxqkFB+acZAIbrNA/zQo4RcV0qt8D+VwGev3qibsXQywD5QOoriG0IiOMtG/D
         CDzAtUxfoezrw2383H0bOaq+TE2OB0ISFBdhl3NqBHhoXDw8Qc34PDrizpEVVP/KsRpd
         Fklry7LzaN4kFNxL3s6bIvz21u00zaVXkoQxN441lelY7DAFvrQumlonvurLPx8olQAO
         yPS0Q2z7mWDUuOHesN8QYeqIYXflYM3xU9J5y39GD8enG6awZ92P1ZGs8ao31jC8lSkX
         1m9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763867108; x=1764471908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PnnYqS1Gva2iq8RVemeTHL95j/HsRMm9CNrwh4z6Zcs=;
        b=jW59v3DX2JgPVRAMtqg/dag6UAjfzz4CeMD3yDoQByB/CeHxMP/hzjO2dh7TE5VCZ/
         GMwdMn+P37B31aYLeQLcC1aJmZyMHkdlNqHPg8C/LW2lBeN17G2RbOH/I4b4GtgQO96y
         gBq/UP/BOogawkxev4HvO0uk/H1QUEBflZ9R4BdxTNT/JXxOUegMUcmv9+gMCW5xN0U+
         56smstQwOsf2ZqudN45RtX/fYA5JI1/8oU95Jb0IvlSmiwQj6SMtbfsDl4Wz6xh9gjBl
         FEo3t1UoQDJOkJzUy5inLX3T/JfO9MR5PljGYX7ZHebt2ynUD9/EwTv9/ewe9+Vfef3S
         hlrw==
X-Forwarded-Encrypted: i=1; AJvYcCWgDA2reb4YQVn8ZePzhnKBh8QJCoYs8pDuFAGxfNVxPFeYk16aLT6750I8CEK4oyf4lFQ09WSlIg==@kvack.org
X-Gm-Message-State: AOJu0Yxolnt0AJsJWCTu4U4wwuURe7Uky4RGZq3HfAJfmETVzQ2AjqKI
	2fk7EQeRo8zHy8Y6eiQKXrlvQ4ZAlyw+zPCqGpoIWub+mOynjEs5alHx
X-Gm-Gg: ASbGncscQiBAOiuosw+O3XJBh3fITN0TOXrY9seCpBOe5SsQzeIoF+ZiEljwUwotJi0
	+yKqn+j52z9D0lDE4wEQNybHTLRBCFzW5+q8tNLY8EFy2ekR+b6hnNCsu/+BM/VvzK2Jv1oxcHa
	eg3Sy97BblAvZ3jUPLvPCpFSZzoiUjHrzmdz4lM5VJG60Kr0z9+nLIN77Hnhb3xXgWjPt8IjxET
	IWS9cRcEh9coWyFgX9k4gCgCXhz6PJQkgH8Z1YvtazedWKJn3yBJDqLdEz+g1QBGCgM5XRoPVnC
	5IBIdWKSj4kYwbkrajxJbLuer8XLKZOt7tWIfycO8RAitXCR6jsqwleA4Z9IZvvkNLZcfxqIFED
	on3xiCxAAeX9THvjdiqFjLW48AjdepXSafpv8pbEPCXVWPGsqlTicBVYBJmdu90R9STy56ddpbU
	P97o754Gx9bWZul9O7iK1+dZy3CQ==
X-Google-Smtp-Source: AGHT+IFHuK7TqumMxHSpEjVPwsTdd0AYETlkSpyKy7kt0aWPWip9dphCpyMx2hcuSl0hHQG5gU/VzQ==
X-Received: by 2002:a05:6a00:13a4:b0:7ab:8583:9cc7 with SMTP id d2e1a72fcca58-7c58db2cb6cmr7367436b3a.16.1763867108241;
        Sat, 22 Nov 2025 19:05:08 -0800 (PST)
Received: from chandna.localdomain ([106.222.235.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f024adcfsm10386095b3a.31.2025.11.22.19.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 19:05:07 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v2 3/3] mm/zswap: use %pe to print error pointers
Date: Sun, 23 Nov 2025 08:34:18 +0530
Message-ID: <0c00ceedce6e0d9aed35cee5faf15fd9126a1f70.1763796152.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1763796152.git.chandna.sahil@gmail.com>
References: <cover.1763796152.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7698318000B
X-Stat-Signature: fkdxk6tros3rxx5o4tgq8qqw4hs1zxg1
X-HE-Tag: 1763867109-510779
X-HE-Meta: U2FsdGVkX1+7GY9muhouug5r2T5N5AUUaPcCY1E3YX9XaRuhM26sUGaPH4XXqB1scX61xspn44FZPeoRwoGx2LrwZwBjvpj/ArXj+x/vvVlgdLKsIYVimdmkZeDrXWsZkoKlNVv5elgL7ryrlpm8nBcEySWWKB/8k6VXI7wV5UmF9oJTb0WlUNS+pgKnhP22J8zBj6sG4aLLL1XBjZrd1If6dxV0enA8quX0YbIE2x8L3w5s1iGy7zxlzkFZxQdw5f5wb7PczV12K0bKAZMdoz4ad0Nh9FVMVnQR4uUUcjuv2eZzAtfw51QwclAIyn2gdPTmNi3nQs8/L9tjyRRCZBW8kG5a3VG83hr5cyHWC2Ui5hGo7cugnDtDorZ0EmsBY5ABoKu7PR4RT3aXj6WuaDJUyqkn1yBdfJI2mDYnI6Y0tdhgkfqXT9u7vr8YyzLlZYi9/pG8BWm+w+89Gl4oC7gWsRkkLNXoZeuVTUReofw5AEvrSosiceFLi7tMyfacvJp4ZRrjSANcUZ6T0jMlt+UiWHq/1HNw7E66bi0JwRMXm2zxZzVB///9FGDwJB8Bfcc2egdLIvLeSNvU93wytHJLcrLWLiKgcWOHUeZxUaXj+vhgGavytdkz5UzIicdjrw/WsHnG4FYbv/PO7dJfwjz7olDWVPt73WU8rpW5/cSW9mQDbp6H1T8erYxFk/OxD/UOaKdiegNg/Yt3homsXMCcWNvNmCXut4uPjH9juVUO1obVCQ92YotEexCQt7GdYNZ5eeskPJcGk42RRCUpDbsmqzHhDF1tvsM1X4DqmR8fgzEYQQtCKIwDOoupon2lXLgXqeJ5zIMT1oJr/2E474IPHdKIEJmpfohWUL4p9gG+/qw90YcK0iXp8QFjSzBPoMJ2ygp3sNl6SGwZCTBa0sZQ4DVpkZkhcryfor5wUPO4ww5uWPEtB/7ZyJubVzyNYRIb5I7fNP1BqCZGgRF
 jjyEHB9g
 NgKSjDgEaNGZhDqHyssrrkTtNyHoi7t+e6ZlZy6yCRSbjIKpanttf0WljzSE7fqFf9+FYWnXANU5rpJFDsnHw1/bVqV12bIIZtfsp9uFszYybH+KkI9mhcsg5yDsGU5IvwAfJAe0uWsvlLzshW/bwmkoPaqDtMmYaO+l+GQOfw8D7ce4TkW9rwFWB5msjJ3m7pIM6b0nF+qjrPJiRqAA7imXWW+DOKQN85ALfLeKxhhd5OJ+8swMDpHyRa+rdJ39+S/RVzBgWK8vuX1i1XUxfvpNhErahAjqbyH0Q0jUJ5BbFWWpq7Gl+sQDHc1PBmrodxtkOj3z+2QjdMfw0ApfSf66pYSfO3BOVXYS7Pw9UJbq63zFIK6V/UP24zqcX5SJbkHZkLpU0NSngSgJSbaFhiu1bHDmYgTpn98DLTU6OTtEQ9PrrEZXFhwJLy1RL1CjUib80XnLLg1Vz10IDfKM9nB7Uu0Dw7CKm1g3SNYv5q2x59qRAR6WRhB3cPOKWJIaYMVewY1EMhDuDE2E9O0Z/DagMmSX5EHA3Mrj3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value. This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
 mm/zswap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index c1af782e54ec..c35604db32ad 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -749,8 +749,8 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
-		pr_err("could not alloc crypto acomp %s : %ld\n",
-				pool->tfm_name, PTR_ERR(acomp));
+		pr_err("could not alloc crypto acomp %s : %pe\n",
+				pool->tfm_name, acomp);
 		ret = PTR_ERR(acomp);
 		goto fail;
 	}
-- 
2.50.1


