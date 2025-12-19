Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB8A8D711D5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 01:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4EF6B008C; Thu, 18 Dec 2025 20:40:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77FDC6B0092; Thu, 18 Dec 2025 20:40:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61AAF6B0093; Thu, 18 Dec 2025 20:40:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4B53F6B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 20:40:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCD2113AABB
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:40:28 +0000 (UTC)
X-FDA: 84234515736.25.D07D48E
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id D5304120015
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:40:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L6ywkN8v;
	spf=pass (imf29.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766108426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nd7dLSH/2LNPg9M+6OkqNEaj91DJZUUxPtMRLObk/CU=;
	b=2KSYB0QPZE2Ik6PPLbjoB1HfTRRt7qRVv4exzhNoBWdJLmoRVvG+w1WXUv2kvTXcsWYILq
	qyP3tBxZOeHuXVb6eDP0T7FaCpGqXChWwnLWreU2SJbLIJcFUsrVPP890c1LRxIy7toxUD
	oXB0ixbRHjr9UBuj5aXA9RZRKQNCNYc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L6ywkN8v;
	spf=pass (imf29.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766108426; a=rsa-sha256;
	cv=none;
	b=KCwPAfVest0JGzuaRf3gkOZ9Pg1qKmoMsJuu4C1V9HYs6u8G2TuZJpNHR5MBDEmCxmj3Bx
	r9SA+vsiQA0ymi8qQZVtOzm9Kcz7OWmcn8xM6iM+RpxF4ml4W1jP9VvVsq8x1mRB/uvv4J
	sX9pcqJIkXkMO5LAvmEUNEMRuve+CiQ=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-787da30c53dso12814607b3.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766108426; x=1766713226; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nd7dLSH/2LNPg9M+6OkqNEaj91DJZUUxPtMRLObk/CU=;
        b=L6ywkN8vgLOWVSbHG1Plos5QzoBJMPaZixJxRJBLvTW8KQ1NLg9IHdk9poAGD1Mzxx
         J64Z3b/JdYhTzU+lZFLMFSo1bicstS47Sw5lLmznn0J6e65uQszUMS+ebttR8Ft7lP65
         qhvpDDWjcqfVM06Z7llBiERFQGYHauCg9qqFgI6dkbvhtDH3NE8KfWThHJj2u+laqO0p
         SD+CAaAPggWT6VRxnjreLUx3LfJMJ5sWdjOj1bpNM56HBq6XGdWNoSnSNrKTL3rD13bp
         PY/Awo3Wly/zZWCO8iS0LE2f1GVNWBzmCMwxmJMT8VUmxMXDLG8QlHtViVujDzv9720M
         xm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766108426; x=1766713226;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nd7dLSH/2LNPg9M+6OkqNEaj91DJZUUxPtMRLObk/CU=;
        b=CzK5YWGBNAPZgx8CVYjcqTY/TUwhuj5M/4hN9vqeQRuLgZn/aQeenjOaLIK0oL8NTD
         +CxXouq1IjM3dHat2xWy8bs3Y8p9ef8lMWvPewFB1bD2PoiNU0R5vJmsSiZJ1opDJT4K
         vUTMui8pF61PiDs/LD9WSOeQAwltGmz3jS+L2m6+gs0XQoZdVckULmu89m0egXaGwJE8
         62DapSUzBUJxfhFZM97UWKvZPufGwoX4h4BkxGkbLi3OOC0+kULykZ4k21ozl7sNG0JV
         1OkHF/971mALGuF+TAlc2ENHA1UHHUirXCcIggpl/wa27K8ZvYQe4VVUu2Kc34m04W1v
         FRuw==
X-Forwarded-Encrypted: i=1; AJvYcCWlBroV0zYixuvklytIPMjUQOV/dbdAug27+9YaqPRdFOxMArVo9fXcAGHySWpF0BBp2qkz2PMHUA==@kvack.org
X-Gm-Message-State: AOJu0YyGi+mycYj1PZDkrToZeurikECztMCiVheqdGBJKNVE98tK8HzR
	Q7AylOu3/O/B7LeJ/xsYzTMVr95aAw6vr5+jXS6KTmxjaZCWO86A0gOG
X-Gm-Gg: AY/fxX5V8vA3kzuaZKhZaD6m5QhBK+Vmk5vanIYnIPVBHI82Se0yCm9vOdz/r01lJkn
	W4btLrgU2sKrSFJ4WMrfw/MKQ9j/MZnrRlsWhW8n/cDUvxtNENw6yeoDhZSTKgLY8Yqj8jf9r8v
	OjOGLTQsXzn4QC8OJfwr1uwPJ3NV4/J8QqctcWBgL/qZ5KpflX/8yizwsszaYrL+mQ+rDpwqEaw
	8irY6uJ7DHh4M8c3AG4IHC2JZ6hswEmJbndq9q8tNIC5iQnTaBnc/9E2JxxVRFpavmbV/UEHoNy
	k0Kbfz1Z5C5Do0ZRu8+aglmZw184lv7R8blwIIQx80btVg2Y1qoSa8WaxvNx4Po1cBFDbr0Vwyc
	nlJUXj6ZA4LoUNNA6PIvLsVBLCdo3UiF8jJfZWLHqj8J1YIzwqZygVaSrilWg1DDVsjndH0k2AH
	aVPdmeclGHbWA=
X-Google-Smtp-Source: AGHT+IGj4vErXkivNcPDaKm/hE3vqzn7Jv2EbveO2FMxfRHgUcrVUKUl63HP3M4rW9y9FyxrhRxuhQ==
X-Received: by 2002:a05:690c:a8e:b0:788:182b:a79c with SMTP id 00721157ae682-78fb41309d4mr10702687b3.35.1766108425857;
        Thu, 18 Dec 2025 17:40:25 -0800 (PST)
Received: from archie.me ([210.87.74.117])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb4376692sm4362217b3.10.2025.12.18.17.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 17:40:22 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id BE85043916EF; Fri, 19 Dec 2025 08:40:18 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Media <linux-media@vger.kernel.org>,
	Linux DRI Development <dri-devel@lists.freedesktop.org>,
	linaro-mm-sig@lists.linaro.org
Cc: Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Max Kellermann <max.kellermann@ionos.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Nysal Jan K.A." <nysal@linux.ibm.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Harry Yoo <harry.yoo@oracle.com>,
	Mao Zhu <zhumao001@208suo.com>,
	Shaomin Deng <dengshaomin@cdjrlc.com>,
	Charles Han <hanchunchao@inspur.com>,
	Jilin Yuan <yuanjilin@cdjrlc.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	George Anthony Vernon <contact@gvernon.com>
Subject: [PATCH mm-hotfixes 0/4] mm kernel-doc fixes
Date: Fri, 19 Dec 2025 08:40:03 +0700
Message-ID: <20251219014006.16328-2-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1015; i=bagasdotme@gmail.com; s=Zp7juWIhw0R1; h=from:subject; bh=RJRIAcyQjDA0Y8yZ/8Tu6N5h+KfYiqNdzVSLTNcjx6Q=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDJkuq+f5OYcHL0jrEuTKWuQ97emSvy6qUm0BRWeMGLrcl J5vdHXqKGVhEONikBVTZJmUyNd0epeRyIX2tY4wc1iZQIYwcHEKwESybBn+Gdbv7z63/Pnd28sP njM2YHx0zOL4JEkuEzeHcytM7BWSJjAy7D8We+uuyDHrtsBjHzMXb9rMJcEdymbdyWQWkGkSsmk BCwA=
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D5304120015
X-Stat-Signature: 1gfzorfzxgwxhage5cnkzhn6pmmtnini
X-HE-Tag: 1766108426-212092
X-HE-Meta: U2FsdGVkX19lwNRPwvN/TQxd9UodHEJwI2HmrIUE1SHMUof0DLyFvtb3RThvGgJKtS0/ycbIb/U8ZEoczfRP8fpQPV71gPFkP8aRhFSfyWvKQoVbAuz23WSVN0ElUKcqwVvTczf6AxL1sYr59erlHpqxjhbs2a1i4ftpmfiHObGr7S3fAFXSinyQ+FyY9SJmPpeiHq9hyWsLtJaeXVMn/LBkY66c1e6k6PqjQ9de/qAuW5oGROn+/Cp3c07G2CCVFDfL5FurPENo33DEQ6l+NeTdNGmZUsEhJWz9BjcUcCh7FATFSY8WeKnAn9Q4AQfPa3ffkmeNzBwIxGdwijWRb4R0YUjDCv8cdQhx5icy6m8sEQcKV7JwGHAT8DTJqvUPSU7QmNKLxZiW+U8sIvcoSHlFAXKAntmxu2QLoDs34V7AAR5sIKV4oxcd3bWjcG3z0Qtne69MmpgB0EFkesciClVmOQlemUu7KBlugo3rvUPOIm2OoraHPADKZl9p3aBcND7qL6reKBb6mGIuM4Dc8JZDJHuaIH19pQSHcGHLfybQDh2b5BdIJJf/afKxdUL4sF9P5nbp3GCmoVFwMkzMMmARwylUZL5hPQES/mDCREUa0KdwLDQ53nGtNWbd1MJ4PJ1mi52R5iWm+XjKWvHF69MQVY2wJY+vsrldOvoKxNNzKgNN2NeL8ArerMsj+ill7Ye+MBftvHEliJpRoajpizcT2s5q7m6BOr1orLlDrA483QBUaiHmsqHsLrll0R5WBqTNsCQm+88ZcATpOD0aGWQBERUKZwiJXPOJVfYl8p3tUgl+h/FQRX9zZhm/ZEdL3dbOECBss53AWeXkj5HSdMs5Ze3l16y6I3ZDOF/wPrTxs3p4ZDLy+Bp/vryhLtEEj5q6iE7m3tjnkGCp8N+Bwxe3AjJBpq7/yaceg4CwTHhjY/+r3LA2Yq8ukbhb+MCamQ0PUxDbhI5H3289UzJ
 8YnLc0ty
 1cm2RVYo1ifavotvvI55HYH48F6ZMSXomdppWi4LiSeTYFHOYec3TUB24Zvkv4aXmEXoniFIl/pTLL5GzAk8GupWy63Dc3lqWYejvRi3ezXh6wv1plaBF7nJg9G+hplKmQoXKPDyvkvAcL9aPH570X3kP/HevqSjsHG5vMTB/HnVucDky85AMODCen4MmZsisW1KlJ8Nm5DiJriBEmb5bsUTV/Mt129a5kspIxm7sHmW+3nXacq7Yam5fgFDLRv2Czc9ZxtPSaAWgNxVTXQEcO8gsz4iaA637xzca6CMYgss4hDu7nskdAAI2YTiIt7pPUg8G8jrD0E+eyDfii25btZIZFk/DsiVzfHLXPhK7cLfTE9L2M+pVeARzN6Y3dOhtHboqggc/yUxkHK4xC1/Y6PJ3yCDf5+QeZV8ycWpdEGBZY1BBeKDyyB36hPOtCGgz3bR8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Here are kernel-doc fixes for mm subsystem, based on mm-hotfixes-unstable
branch. This series is split from previous assorted kernel-doc fixes series
[1] with review trailers applied.

I'm also including textsearch fix since there's currently no maintainer
for include/linux/textsearch.h (get_maintainer.pl only shows LKML).

Enjoy!

[1]: https://lore.kernel.org/linux-fsdevel/20251215113903.46555-1-bagasdotme@gmail.com/

Bagas Sanjaya (4):
  mm: Describe @flags parameter in memalloc_flags_save()
  textsearch: Describe @list member in ts_ops search
  mm: vmalloc: Fix up vrealloc_node_align() kernel-doc macro name
  mm, kfence: Describe @slab parameter in __kfence_obj_info()

 include/linux/kfence.h     | 1 +
 include/linux/sched/mm.h   | 1 +
 include/linux/textsearch.h | 1 +
 mm/vmalloc.c               | 2 +-
 4 files changed, 4 insertions(+), 1 deletion(-)


base-commit: 980dbceadd50af9437257d8095d4a3606818e8c4
-- 
An old man doll... just what I always wanted! - Clara


