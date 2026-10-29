Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9634606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=s21pyadU
Received: by kanga.kvack.org (Postfix)
	id 189056B05B3; Thu, 29 Oct 2026 10:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160AF6B05B9; Thu, 29 Oct 2026 10:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076E36B05BD; Thu, 29 Oct 2026 10:23:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB73D6B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:23:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C87DC0409
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:23:51 +0000 (UTC)
X-FDA: 85375882662.02.529922E
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id B943A40008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:23:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=s21pyadU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joasantonio108@gmail.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=joasantonio108@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793283829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJb2/HmhBTTuuyxE/cFYx3WSBj9uBlfuHJGXiko2698=;
	b=Iu2iyZc7EoYs7603vxkwBherpMLVD2lSPCl3ljGGrJt8bgYOFAKYnGvy6WxdSjGCow6bJq
	porrzLGBQD7DpQ08k4+TjnoMAp942NX9IELB9CgYoNhM06Q8NXXEgL0jwh+WCSm9Ywp0sh
	u0sp+p510kATkhjQn7kat1zriPmelv4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=s21pyadU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of joasantonio108@gmail.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=joasantonio108@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793283829;
	b=2oWMF4EwvFn+jbwd2qqOI6jyOLC+OQC7bTqnL/bijugGg7/rXNyEMjI651TuEWO/jOD7/n
	2h0Gv47TkVZzqyaF29baLJMtEnXjBmkgkia4YoJLIwXgBNkEXRjyE0cxPPyVJcfVgIqzkI
	ReOQHg1O/9t1r4flYAkYwBDp/TWmozI=
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5ec3561b07dso685750e0c.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793283829; x=1793888629; darn=kvack.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JJb2/HmhBTTuuyxE/cFYx3WSBj9uBlfuHJGXiko2698=;
        b=s21pyadUC71FohVsXeDLUXbQ6hQcNqg/EyxX1RmzFNRQBdtcx+NnvwC5kZLJGb3a0Z
         WVBa2ylZZqedXi87UOvJQwCNF4WWpp3ywR/XsGeK1q73UluaKX89IbzJ7SXy69JH5hLs
         +4LWlEAbPKpRloGe2aClgKFOp1f5LoPlyW/wFKySawKXZaUPekEYGW5UzPwcF1d0Hm/y
         nm0AQo1enjVfe9fNqNrr9HDcsjpGyhVO4X6mUSvY9bo4DgD9EAld5ybRenl640xeD+xp
         vayGwO1Soojav3cmAomnoLb5K38W3xKWziRb6Vuf9bFtDrJESpv8TwADVfmbLmChIFmF
         WBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793283829; x=1793888629;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JJb2/HmhBTTuuyxE/cFYx3WSBj9uBlfuHJGXiko2698=;
        b=SheIepxL+r/p9SQmyKbrNDqgs819Wh+nSkiwAnNiZufG/VW9nsvJ1skDv4q+hauz9M
         RaUtrwYNJGcy8NeFtByGFjcMXCQV2E3xTFGCqw4/rBTjUTl+QEIQnsJZFohLHFW0Rlk1
         5XkcOa0qVLRrkEz8t0/b17HcOl3soSQvz3+c9M0Y9fwuF3raf9M5f9ZG1erB0OGsxIc5
         php7b8jjG9f0wzvm+4IDGq86W9hYfxp7IYqV7p7dSfOFZ6jvJ1nfhhnhx5aSaAGE+sHw
         x3cczfVcGaCdnO9KyYU8S7pcZDHTgxUJaJdkNntmHi8y5EATXZfJTNoDcojIkc/mw+fI
         EcZA==
X-Forwarded-Encrypted: i=1; AKwUvBxh2Gi4vYt84pcK1tMziwwoWQNIyaDAHI6+nDm8AMsc9qNZ3hMIUM3ibM2e/6fYNWbNiBDum7gDCQ==@kvack.org
X-Gm-Message-State: AFq9FYLaLChI541AkHovY1HAB2eTHhv+WbUh7t+XfYgiLUXbEYoPx3PR
	nKzLt//gzydAoDFx2mtJsBDKo/sYz6ZsUAqu8LfoK7j4rmB6e5hmnIZ5
X-Gm-Gg: AYBFou2Sgf1mpts0fdDt7oJZr5eJRpCAlYcO1JSnanzbNeojyauDvNA9+R/PRp0bK7c
	PlrdjLeQj7pxVi/k3fBw+8Ukr5natuISdvOHLK8QFE8IYkEoYDF5fkF1KSCqWUqh2pLgeJ0syHf
	iEPoL5GXXBoFL36SOXje9EhssP966+w8mZqE0G8rq69e4JvvJUyWkQlm0SZ1u3xAtz4CRsrhmOQ
	cAtbA5HhQ9CAPPAj7E7M6i/20eGpogEWKm3NxCh/NGdqiIdgS8FYQXR0bEaeqJEqZqVovGFq3gj
	pBzolMZx5Lm02UeHLJjRy8hTMyzzsG6VUg6jXxlCTKvOGqGake3PUjeFijwl+jQKtM5L9+a4mpq
	QxYmN6lAAtxsohuoVF9iupHIkSLSFgjPwnm3RYky6XQU+rRMeFX9fzYFARJMOMsd/w++tygD2FR
	lxi451R9bEOX4VthxEX7oBRk61POaT8e7tkIaWy6XYJATmfFyxDfpPLNnQyfaNwPF20RuwXrL7F
	ZI+MDOWVvJkUTTTu4pwQ/P9szWIuoj/IputrjqeLuiypw5WtZybVRaw12aMvjrQ3sGHwyQ64Ylt
	mv2tuLKc7MceF1by6ARFCg5osP1NHwnP3wAYBKR4Xl3kd80O5q6hr7raPsVsjdOAd8mST2gUEVn
	GXE5ROvq2hq1h
X-Received: by 2002:a05:6122:e46a:b0:5ea:bf30:851d with SMTP id 71dfb90a1353d-5ec587ac1ecmr879502e0c.16.1793283828654;
        Thu, 29 Oct 2026 07:23:48 -0700 (PDT)
Received: from [192.168.15.16] ([2804:1b3:a2c1:77a1:5cd:8fee:f3c:4da7])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec4f92e3e3sm5524139e0c.9.2026.10.29.07.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 07:23:48 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:
 Re: [PATCH] hugetlbfs: emit hugetlbfs_free_inode from ->destroy_inode()
Date: Thu, 29 Oct 2026 11:23:37 -0300
Message-ID: <179328381770.67441.15785036410268577790@gmail.com>
In-Reply-To: <acfd9678-fa48-4610-ba90-278cab92ee9c@kernel.org>
References: <179324176522.32673.7602596908234555806@gmail.com>
 <acfd9678-fa48-4610-ba90-278cab92ee9c@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B943A40008
X-Stat-Signature: ketwkb7jr8irh4oq1ijc7zykejzswyo1
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793283829-307170
X-HE-Meta: U2FsdGVkX1/4qDTNOjPswK0f8tAP6DVP7rdUguLT2jO2uxLiXS7WA7ki2FEyD2O1POdwiIkvMrn5dLXas6d+2L+4Jxfp0LrJrKhA+6by6/+5yWoE9dhUJV/c17S9WicXuyYsfk13C2dRGgAAuAzfxqeLtDkIMmazd1LsMoKVzHWaKpyN+TJtVaKwFykSoG5+8TNQvhVAvBN0Oi1kWsnyvbNuQRxChmV3OH5oE0Qlnu1rW9kO+xoiKvL1LJ+N1TtoFjICbySMleHw1XYUE9AvUWDarFpyo79Zvb5wYdKetjr4e3lv3/RNBd5vXXZsuGw2cSJH633yTol/3fHSUUdrbnEzy1/vsW5O0p3A5IaFpMG51go2j0yQ04PmFp4UD41JSduFW9t+oOYjcAV7u91Gww1fqJoyXBTLQKPeUnnuwDGTfhJL14qmxVhngkQk92Dx4u1bxMlQc6kwVLQTjR5iRQ/kGKdUCUfxVI7mIrb2wXYJZcNNQsK2Olf8lz3i7K+WGNC5Mo4GLAj5fRMbEg3xyvjdbeKGuPuzYVGqY5u6DASYlWZYt6He1psH+Gx2b/bkWEql7msoP5IB71U1beT+dsB2Rs7WD+iOopVQ1D9d4E7kK5LDwBNqvLqcriQ0Z0qcwZcoOA061SRmsbJFp4H0RUfR/64PG2gP6uQgqOdXUjhJ8IUMAxvPsvbJ2prfTf5pnMKXIGl1uzAKd3bS0hgyrsVGWLu2Qz2zpGBextkAae4gzVjg7pn1ESDYaWUzF8GkF7tl0fUQAl/2F1WvP29JCtkdsEOsDj85bP+zxci3WFrdQh1u0aIaFmrip+MuAUuFYjZBqsB7UrGtGjoXuoE5SuLoxqNjL8f/rpeAYv0P5ykFzXTRpunuyOK8rka9UQuVpfkZxZqK+q/rxqilHcjXRG2wCMwqmhtgSFEPSDxmnMqurMirmv/KJ1A7Lm40X5safrN36sPmQalJkCWgkLm
 Ykikb9L4
 8UejQdgC1cRfq8t4H67HQqK/DWTM9+YZvDWeeSiepPagCN4olktv8osQ4nPO1v/jfoSItV9f494miz/5tgey9gLdppX8L1TjJnmzllmZzTay5NOhmfaNv7/Xz/p0Ycl0iN4sTi6mnyjlrviVMb51z4mjGpHIovhnG303APjHOu5/LZD9vgYNOaXB1XNtAtiJQdSQnQ+NhSxiuS/6wf/1tqswMNUjVHSuvC1qFVjoONoTwVF51VHURvtFLF3Dgky54SlBQl0nbzJCaM3W2oLQ/YucgVuPV/sJ93Uiq/3vWUnjr8VHixsDyKavSI1vYOOw0+fmN0M9nIwOGdxY4u18I7pUE6PITsbY0lxehlYvXcAZktGnOiR69VplzcNXZS6uKULJKGc0YkmS7Yzl1BHGRY3G1A6NmLazpAttwNazFjDREFW/+qwQayCgA5ggQUmBNV5dOR8GUbwzqm5eYROTKv49MN1LTMSxUSuXkM5eccJ69DaqNDRtxWbT1RhE+FHAgBHmEdP2xC9QO5AJVqU90eh7Y4PDo0YOCvWtxeq9qDWVRPZG/c/BpT/J37yBmUcF/62vUA5EEv/VD55HdP3eB8hY4dJF+Eu6QeDWhWS9ZXnRqO7kWouujymEJr5CUQVLFriJVGNSgynE3/fJqyHX/CfUdNyYvZDRz6xZIGYNqyk48+n8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/29/26 11:45, David Hildenbrand wrote:
> Should we rename the tracepoint then?

Fair point, "free_inode" no longer matches where it fires.

I'd keep this patch as is, though, since it is tagged for stable:
the event name is visible to users in tracefs
(events/hugetlbfs/hugetlbfs_free_inode), and renaming it in stable
kernels would break existing tracing setups there just to fix the
use-after-free.

I can send a follow-up on top of it for mm-unstable that renames the
event to hugetlbfs_destroy_inode, which also matches the
hugetlbfs_evict_inode name next to it. Would that work for you, or
would you prefer the rename folded into a v2?

Thanks,
Joas

