Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3386FD45FA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:39:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69746B0089; Wed, 25 Feb 2026 17:39:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB206B008A; Wed, 25 Feb 2026 17:39:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABE46B008C; Wed, 25 Feb 2026 17:39:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8408F6B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:39:06 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3703313B9DA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:39:06 +0000 (UTC)
X-FDA: 84484445892.17.3970B30
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6E3FC180004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:39:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IAAj98YS;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772059144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o965ljUc5sj5Dk15lV3ScaKwdf6iFJtEKkC95QIQfpk=;
	b=QC2v8PT3KC8gGl4LlcP2eeGzaz9Kr2MXuGtcg4+CdD2OqB0L4icTS8iUo3OFCBUYBARuhe
	guGGYn1+jzwYNTUt15FjTJXsyE+OoyoJgoONdsVYEIhM+jRROtKjMwEanro/ZGu9NAMH/2
	x4L/FOyztxOiQCjcvW/Mlo2iwYrmQbM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IAAj98YS;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772059144; a=rsa-sha256;
	cv=none;
	b=yuBTjO6Kb8TGwn3RDFRDq54cdW2NXY0VRtHW30m1T6cSHhQ/VOnlfIUlrwLEc64OHBWYBp
	b4oDSaWDEibFUl9gKxKZ/mprUwOW1YFxLUNtbe/jEQK1HyKR3dO8I8AJn0892DuvTex4fq
	Qrf0MCx2bL7lFEzQL1PivSTg5Ao3G/g=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-79801df3e42so3330757b3.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1772059143; x=1772663943; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o965ljUc5sj5Dk15lV3ScaKwdf6iFJtEKkC95QIQfpk=;
        b=IAAj98YSAVN9YHI6GszTCtphmxrBHud5sdvml1Wj2GAztWvgBz909USCFOYaPyB9eT
         xpyJoB/U3eP1VeNy9c/vXfaRJgO+E9227QgKuCfvvQQ0HqDXpxC1k6KXkB8N3GILjd1y
         4mZ00/TDGWjnIXuoK/ikBcXLtFUkVnyCEAlPI2FvnKr4Y0NT4x/bbMrSx/4H3R1T0YPx
         McQOazCuiFEAsisURPcoHxMS0JjHmQnZONGuRmgF/8zpoUEqcstpXJI2ugvx+czCLaN4
         IJOYktRVyVZcuY2zqgb6RebG1TKJ4Kizaedb+zcNUnWF0fZqBJaYM3OUZvm8lv5qPjg0
         PTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772059143; x=1772663943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o965ljUc5sj5Dk15lV3ScaKwdf6iFJtEKkC95QIQfpk=;
        b=T7AKXOxJPYvlH+6zwUTOYsTJXNy+KOhiNJyGuG5HAhYX/S8S+6RFyPocgOvWsexNTj
         ZU1aosZsIzv9I7NGXh0TzyY1s33I10OtjOSXfXMFLu6nO3MtprO26fkHhvKZr2x1rAXv
         7zjna0fuNMUU3d73nJiNJdWWHgtXoqGPo8d0FIQPoQWjWI/lP9siYSdrXQQynQucXocZ
         cVzI9mEjFikvgCI1XGFTSLMemJM2K/VZpid60qBEV+Zx1dwLjbhpnPcs2EJs/2+UqHys
         817RBl7D2fax8agYeBEyYWIFv28HcmcA/y7AoKhhazIGS1e4yYRUxRXzPfcDhibQ1YMU
         pm6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVE0g/4ElnrtFOrTTfqIc3ImRXiPKmPYNVsljed6vgF8eRAjB7/RgHaTikU/EJOh9zEQ2xIMX85og==@kvack.org
X-Gm-Message-State: AOJu0YxfSE4C5hfm7ROgyEPhYqkZZkKDVdsJRV/A6DAtpQ/uCII/Vmcq
	yTsNxcipcx3hnO4+60zHTRTkxt5MfSNe3jcv4AT4PV/AbI6cqhgduoJxxB/fqmvI8Jo=
X-Gm-Gg: ATEYQzwzA6s5jjfFw4Ajel0/D1rQWldzkF73z3aOz06dzeuV9G8tsO81UF2WlAv4FhO
	hk6nDaqkiKQ3aV0cBJRlBqSZaZm/Q3le/D+cFt+XGf3t5xsGS9VTEYe4iROIceyCJhnygxtzNX8
	V/Wj6DKw9H7xI0OkDFU200O+5aPhe4XBOoIbD1lKIHAz4vqLfirWvzHn8EVKkHKFRhCVIHr+2WO
	yyBUBIAnh5Clu4xqnfZwLWY3FrIBPOzuJfhvPh7Bnc4zdkDWwH3kqXX3LoqzMI8wf96IFNxgo5J
	EPpJOT9GhHlOYTDZZDZ3imdWVfJno3WcsYLg/y7sTA77RK99re1eV1yC047LZBpC+0YY5FJmyF7
	ZBaBJfMK2HRldkJ918K46bR+DeqzDRbsR+XH+b2kwb6sUvhl9K6RgHVc228ai1O6fgZH1D1SjZy
	Q6Jy/S1bxQ1qWDYJ9YCMLL4PyRsC2t3wp564wh7XIb8oP8BOus23NPAa7clutR3ZjCiJNu/3qbV
	Gc9+AY/sZZ+zTAbRImTzIZ3u8fwZRmdKGk4WCUAx9gH3l7jI+Ubeh9Pwl+T
X-Received: by 2002:a05:690c:6e81:b0:796:30e1:3245 with SMTP id 00721157ae682-79874d8540emr6020577b3.32.1772059143526;
        Wed, 25 Feb 2026 14:39:03 -0800 (PST)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79876c992b9sm918297b3.50.2026.02.25.14.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:39:03 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	urezki@gmail.com
Subject: [PATCH v1 1/2] mm/vmalloc: export clear_vm_uninitialized_flag()
Date: Wed, 25 Feb 2026 17:38:56 -0500
Message-ID: <20260225223857.1714801-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
In-Reply-To: <20260225223857.1714801-1-pasha.tatashin@soleen.com>
References: <20260225223857.1714801-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c5mwd6yubhwgqrf74xyd9io4fk1brqq9
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E3FC180004
X-HE-Tag: 1772059144-991065
X-HE-Meta: U2FsdGVkX1/59lBDH6g6ECzu6x+aY/67La/RCHDMCnOd/tncaXd2ISsvV3kLamqPoCU/htSJWwrsRDMW2YbvELi/SHWWxuHol4O57GharYWtStBLGJ954RuKfbdAWLxfnpAiozkX1VD5NAwZ2bg36VKSEEY5udtNSK5Yb+sSNIE7HhFFTHxdQ37KZemAYoHA1P4bgHFy/UnOzJsXI3Ev0p5ZDQMYX7+TCPirqzXVkYs7Q5BlNMJNX8VtsK8ldJD29YjhmVTptiy1dyArzkG7QuRk7LRtpUAFrUAvMVjuevakqpqztZYjN8Y1wIh7pjxrVcJ7aQJMskh7AqmRgSkzPxHJjDibpECgu9bMt3o50RaRiNDVGRYuSkwPBpneZKna8A+WYeXQPdGSUnm0xhhEp7xmJ1jMNym0sRfipfVqKIKJ+n6RY1AOsV5kzUduwuZH18+oeYKFgAoW60fJqFxCaUlJ1im1ndc1M6vy35BPR+sxmvyuLd5t7NFtmUfYZP0jOVd7MMzEsjJPwKwzqEyrkUwIB5b3Qrqr/bbFcWclvnqMkG8aNCnbR0+8eDkx03wtKXt2sFb6srUe1iNDiL/nfsBRQbeXrV9lVEjvSo+FEdFXr0KGzK5Rvoy+6sKZkiQHi4Jb4QUZgehUh0QMM4Y/dF67FqIyMONyjK8omDJDxe+SfYVkLSMlW8W8UnfjBKGPqTQCARMmpvXCFf4F+/EmmrZsujJXc12hZqWdkXJoxxxRukA7gIkQmBSVGuwe7qwZwy/te205vnI0Af+t4OGEsm0lu6qDyT/3BH8r2SAi+zdYvX3H7xFscJTD2eVJTdtNEvnakZhRiOnixR4AN4aU7DX0lbe1jn0X/UWfXGYCZfPq5ZxM2y3b4AixKNZipP8zPpRg+FQ8OmPa7ZWDCs3ZYSYnhZKf80OUR6zhRdXe9jsIh/sI2OctALWI9KyA/vPZu/zOSwA3u5M8jpwyGKz
 5igE3OWG
 Igu2x53/KiA16puAPRqJik7Rwll6RhlqQLDEzFbS8yJSsdaM2oN0ENX9i9TLIvRI3iEavhHlm0MG9+uW1iQN+PmbAwTQBRhxs5XF3Yc8m8drZsmRBZPhw4i5BLO8dtw1DOsCpbYpDfXQBRQ7cWGQ0blRfk7skubYCmaQdc9E/p2nF5eHYiokNPWSfOu3uNBrq4/IfZorY7wNQBROzmuYwwYh2OLOoi4Hu2XNr+vdzP+3J7/20RyjXt4bHiKrIhaULbggSCLoyKbvcj22FGXQ9PVnyvxgJlUN7iZnngsZZ6Fyk4e2AQ6gncpB1xy72CkAJzrMqkn5fNj4zg/xNc9gAKZ0yeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make clear_vm_uninitialized_flag() available to other parts of the
kernel that need to manage vmalloc areas manually, such as KHO for
restoring vmallocs.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/internal.h | 2 ++
 mm/vmalloc.c  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 39ab37bb0e1d..2daa6a744172 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1469,6 +1469,8 @@ int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 }
 #endif
 
+void clear_vm_uninitialized_flag(struct vm_struct *vm);
+
 int __must_check __vmap_pages_range_noflush(unsigned long addr,
 			       unsigned long end, pgprot_t prot,
 			       struct page **pages, unsigned int page_shift);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 56e3611c562a..33216b3c15de 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3189,7 +3189,7 @@ void __init vm_area_register_early(struct vm_struct *vm, size_t align)
 	kasan_populate_early_vm_area_shadow(vm->addr, vm->size);
 }
 
-static void clear_vm_uninitialized_flag(struct vm_struct *vm)
+void clear_vm_uninitialized_flag(struct vm_struct *vm)
 {
 	/*
 	 * Before removing VM_UNINITIALIZED,
-- 
2.53.0.414.gf7e9f6c205-goog


