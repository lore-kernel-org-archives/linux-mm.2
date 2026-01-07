Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA9DCF6BE2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 03:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E614C6B0092; Tue,  6 Jan 2026 22:03:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0E706B0093; Tue,  6 Jan 2026 22:03:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE69B6B0095; Tue,  6 Jan 2026 22:03:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF8AC6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 22:03:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E8308EDFF
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:03:45 +0000 (UTC)
X-FDA: 84303672810.21.2AE1937
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6BAC6160005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:03:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fN65JB14;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767755023; a=rsa-sha256;
	cv=none;
	b=wCq+faQL9N2QYde3i964a9P8KdGpvUVfq4vEo1ISfoJrDPcAtdNQtTBWf8eVIgj8GUyTOe
	KGxFp6lj1Vb2QX4XHCyGANy1lwffZwC8/oYUhHQUrwN3lbRz0b4CAWOs3ltzVAok7JLxrt
	R9c6M40B4cxcgYq8YC2FA65F9gX3ZaA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fN65JB14;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767755023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFm+TF1fSwD6gkJ17GG1izhQnu21Fs82H/iuM6aPKB4=;
	b=i+Te5J0CDsVDP3FLAIbnsdXzfQXmFGORXUtfdohxN/Wy5bz7B7NM2pZg8YiyDIV4qzo7oL
	IU9HazCQSijaHOj/mEd9tJA0+3fZ+P7J2UhBW9DfzQRoZ89RmDH+hYJUmlJ4CypTAB7JGp
	HkaFJV+GpiFiDp+6aj0h2Qw7SAOXZuk=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b553412a19bso984769a12.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 19:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767755022; x=1768359822; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oFm+TF1fSwD6gkJ17GG1izhQnu21Fs82H/iuM6aPKB4=;
        b=fN65JB14j3icOSJ94+7glTLRLLTi+5MKcN+hKLOK700bu3NvGP4sefWHl5r8agE7M2
         JPuwKOumfAYXoUfLge3L27YbQCrStL5X4ifkyKPiAR9farYcD5Jr41xGRvHEaBGGDXrc
         sURvurvVyKqDKbA0Ovpg/qRybJgkgon0i8Qs0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767755022; x=1768359822;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oFm+TF1fSwD6gkJ17GG1izhQnu21Fs82H/iuM6aPKB4=;
        b=uc5goNtxaQXz/71XXFNQ0FzOEJlEZqYNgHwil7M9sUVIq49N6fUFTWbE503QAP6BA7
         SFFxwonh+0A0EsMk2GUwh0+bofbc0hHuzAaSRt/+Ta39ZN2oysp0Wi/h8CSZJI/oSbxn
         JqYdX1qlJCZHZw5H+WfFZ3RGLq+29tWWWmvJEJOGOACrzntg5f8rZcDpjaoO8CFVfW+q
         p3ypPeF8vNK5iv+zrlaL+ufFUZhfv8dCABFcTR3nn+br/F98r438h/x1FpK5YFGPRMN1
         J24QSDlhk5UyTW6n8qRMhQQS6/HGsIusM23UiiBPsAeR13g8dQVqL6W1ZUuRT99FffGi
         5hyg==
X-Forwarded-Encrypted: i=1; AJvYcCVHgiWqtNpV8YAr5acXeYKpEzhIgITkg7sKql9r7NyckHztA37ADj2RYNLjpqcv72zxxcQ9UzDBtQ==@kvack.org
X-Gm-Message-State: AOJu0Ywzvh72N8KcD4zsSy0WzmAdoH39uDDKfVxgJC5gzBnIOBQX4Q38
	Dy7JJNjDTPDPXHrJiD92UmF0cZCiRAnKSU9FyIAB7SCe4wmKS521rF4hbvbSIEYA1A==
X-Gm-Gg: AY/fxX6kbSAjjridMeWTrg7iFiG3Q1E1S1z1l+WfaSwQloaYSMhY1oTA4yOEJ/VadaS
	pw+Uvb69+L7IDdSGHS9fgUfWijN/7gY90tDY5w4gtXP3ZKduRoHp6GQ2X/QF3WQiJNsF6RUG0im
	eWPVWdqb+ybL9OpKs1CudONRi723+Q0m7bgJKE1ZSyYmm0RCZLc/YF74si7pTj9HBRI2TlLtk7V
	ox9bkuHDcVEc2Vbwgsvm/hD0f0SU7eEEynXZEquQ0vwJ9U3GMVSCA5NAfBfiiOHTd6WybLBNMEm
	80TXhndqRW4oTlHGFH9NYeNrHm7fjR3DH4SDEraRPttZ5kZ2bwTGNYo53Ehr5fE2pgCQMTsY4lV
	mQirT59tc584fCn/l7xJ7Lz/BT0aJmuOpcQTWWpsgtQZSpLW+OkwE+q53wq5RsStOv8yLBX+/Cz
	Xc1OBNGUH4lkBBCcuxDGuvFy7FnoO4UP4Olzi2UEbTxxf/YXSdMwqUzeiUF96nLQ==
X-Google-Smtp-Source: AGHT+IFslC2wQrpaZjhs5gM2B/O2qMiajQgy0AcpounjmfjOvsvIjwo9ikquH6OU3ptcRz+G9un0kg==
X-Received: by 2002:a05:6a20:4320:b0:371:5a31:e486 with SMTP id adf61e73a8af0-3898f8f5575mr934721637.6.1767755022155;
        Tue, 06 Jan 2026 19:03:42 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c59e83bcsm3375258b3a.56.2026.01.06.19.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 19:03:41 -0800 (PST)
Date: Wed, 7 Jan 2026 12:03:37 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <3xsreqvvclcuqyllgdz5avxwdvhc3rqri4565xj2hbwk6r6uol@6mnhvdgaxfrl>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
 <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
 <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
 <5smqbald5bollibqjsvqw2tfngdoiiucurikdgqtz6xjb7u7vz@7p6hskoixaak>
 <lupjar4x2wz25knuntywor5oyx3ksyhh7g7yv4apmztn47ayep@sncrwg4gjlut>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lupjar4x2wz25knuntywor5oyx3ksyhh7g7yv4apmztn47ayep@sncrwg4gjlut>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6BAC6160005
X-Stat-Signature: 7q443sctmgjwb6bjbt79kc7m7s6umuoh
X-Rspam-User: 
X-HE-Tag: 1767755023-941751
X-HE-Meta: U2FsdGVkX18eo3tO5brApuXqJGYDiAbL19Py5Uirj0lk+QH6X3I8bhkkA8bMrsm0kLH9QTMgCxaeLhav/Ck8+I2yoyM7ob6GKjdsgPpESw1S/Bc54/ZQHlv7znNrKpBEd/UKLKUgSRVqMBR3nqfx+pW53lQ1HC2B6QoEjTGlSRZVaWV9XV+STUVPyrd/Ji+ApkkmqEhbjfCEgSOKzZm8uqNJpqy5APsdizGvqND9895YJZDnDUewO1znRwpOR1YZLLM9U0dO7k0P9eOP99Zht5xZ+F0jmKfZaJPMbjy30ZP9QhVvgHYc0LbT6GD+lIHryMMV5PpI4xoiSTiwOimuX1HWXK/GrlGWJ5hAF0UnuELYJSIuppa6H6rC1Zk6WI/mdOHeA3xXBmaIDaw0mxqP1agcGbc1prjLGibJuQfVq0c0ggYarnyyjdlxy+8ssiDQUW3w9clAIaswNxGW64U4PnMn+aaCO0KUTayHpRHKu4g5iNq+kxqjPNUhGWsCVsXHfoZvenkGQxsNpfaqH0BAfnEd+hkLBfWvfuxCHiShqnVdtR8RvpUn83Byr6LuB2nNAhM2xjvPLU+lmps1YGeZP87I+qTEawcb2LQBCA+oFUK6TIVQqSyt6gEac9VQE85+ohotn4PD33wi4AxQrL42miTQ69SgRjhuwaBGtbmed8tTm/bH3eOFVVJjT/HSjDRvOOH4NBHgGQwboCkWAvtR2Pk+2AtTB1S9vBUnY4ORl7iasiTu01RNAG+hnUhkY4gGV5Q7a7srPGTQ7D6YQ9tFISHYSTSuiiTHxpeecK/5Kzt6wdmBNz9nDBpLDlPN1BmrTINe9Ka+iy6G4XgPs8bgXzrFcMUyzypbYyObqpI1lIUYkeQQodUIqlWlBAiiKmjTCc+lZ9knWUV8GD2pjsjeddyjCDpWk8mEOLZxRB9nX3kLkMC6/o9JaqZ4auX1/xtqJNR/vwWHQEIWYMIAnMj
 +3GDuJpJ
 9Ao3jxIk3FSznzESqMGnG9ljaav+MdCB/RmbWEeG5kpLXmP7WuAsMuvIwSy2kZ7Dsr3Nq+RR76sjtLKOwcHu9HaFJ5oxCsAanuBtVkDcmBsm0YrwTDG+TiwNO0lycRcE9YhfDRRRAH60RQcNk1TmvbxJS5xc6LreIj2ZbZxa0t1GJt0zKa+o24SUvQaWv7o3oLwLhJK8IjBuQFcSWTLxnR/u3wWESuT6MPKyRq7b6EIL/mndAhUuV0QC43h7anjqnqFGjS/kET6F7aJD++8lZ9ErQWKkVaV+AAIQMPhIJCWjvmkaHKsYsVj/EtB7gIfuC4c7ey8/D5NPHlWuwFFnCwWJgRAk6JP7J/5ExD6M3+2a1c7I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 02:10), Yosry Ahmed wrote:
> I think the changes need to be shuffled around to avoid this, or just
> have a combined patch, which would be less pretty.

Dunno.  Do we want to completely separate HugePage handling
and make it a fast path?  Then it seems things begin to work.

---

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index cb449acc8809..9b067853b6c2 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1077,6 +1077,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
        unsigned long obj, off;
        unsigned int obj_idx;
        struct size_class *class;
+       size_t sizes[2];
        void *addr;
 
        /* Guarantee we can get zspage from handle safely */
@@ -1089,35 +1090,27 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
        zspage_read_lock(zspage);
        read_unlock(&pool->lock);
 
+       /* Fast path for huge size class */
+       if (ZsHugePage(zspage))
+               return kmap_local_zpdesc(zpdesc);
+
        class = zspage_class(pool, zspage);
        off = offset_in_page(class->size * obj_idx);
 
-       /* Normal classes have inlined handle */
-       if (!ZsHugePage(zspage))
-               mem_len += ZS_HANDLE_SIZE;
-
+       off += ZS_HANDLE_SIZE;
        if (off + mem_len <= PAGE_SIZE) {
                /* this object is contained entirely within a page */
-               addr = kmap_local_zpdesc(zpdesc);
-               addr += off;
-       } else {
-               size_t sizes[2];
-
-               /* this object spans two pages */
-               sizes[0] = PAGE_SIZE - off;
-               sizes[1] = mem_len - sizes[0];
-               addr = local_copy;
-
-               memcpy_from_page(addr, zpdesc_page(zpdesc),
-                                off, sizes[0]);
-               zpdesc = get_next_zpdesc(zpdesc);
-               memcpy_from_page(addr + sizes[0],
-                                zpdesc_page(zpdesc),
-                                0, sizes[1]);
+               return kmap_local_zpdesc(zpdesc) + off;
        }
 
-       if (!ZsHugePage(zspage))
-               addr += ZS_HANDLE_SIZE;
+       /* this object spans two pages */
+       sizes[0] = PAGE_SIZE - off;
+       sizes[1] = mem_len - sizes[0];
+       addr = local_copy;
+
+       memcpy_from_page(addr, zpdesc_page(zpdesc), off, sizes[0]);
+       zpdesc = get_next_zpdesc(zpdesc);
+       memcpy_from_page(addr + sizes[0], zpdesc_page(zpdesc), 0, sizes[1]);
 
        return addr;
 }
@@ -1135,20 +1128,21 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
        obj = handle_to_obj(handle);
        obj_to_location(obj, &zpdesc, &obj_idx);
        zspage = get_zspage(zpdesc);
+
+       /* Fast path for huge size class */
+       if (ZsHugePage(zspage)) {
+               kunmap_local(handle_mem);
+               goto unlock;
+       }
+
        class = zspage_class(pool, zspage);
        off = offset_in_page(class->size * obj_idx);
 
-       /* Normal classes have inlined handle */
-       if (!ZsHugePage(zspage))
-               mem_len += ZS_HANDLE_SIZE;
-
-       if (off + mem_len <= PAGE_SIZE) {
-               if (!ZsHugePage(zspage))
-                       off += ZS_HANDLE_SIZE;
-               handle_mem -= off;
+       off += ZS_HANDLE_SIZE;
+       if (off + mem_len <= PAGE_SIZE)
                kunmap_local(handle_mem);
-       }
 
+unlock:
        zspage_read_unlock(zspage);
 }
 EXPORT_SYMBOL_GPL(zs_obj_read_end);

