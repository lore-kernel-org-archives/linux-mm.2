Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF14760A5BDD
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=BBW1f6SO
Received: by kanga.kvack.org (Postfix)
	id F267A6B05B7; Mon, 16 Nov 2026 18:06:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED89C6B05B8; Mon, 16 Nov 2026 18:06:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D299D6B05B9; Mon, 16 Nov 2026 18:06:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A60BD6B05B7
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:06:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F3B71602A5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:56 +0000 (UTC)
X-FDA: 85442519232.08.4B344D4
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 57DBC80002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:06:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=BBW1f6SO;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AjhVL/tzJIhPQa9pnWiA/Lzn5A7WcpHhkbmWbBd9Z/A=;
	b=YrZFw6lgKHvvVmJ7h0zexd5t7USsiv0CKwOunlAHq9+J9/FNuKi9cY9aXWNBCWP1N5N1bv
	8byI8YMuatiA3+kqB0z1Y+H7m3D7hHhWajr1XpNyu+oaKL+9gAwl3rgibTmjrmvGTO7vuj
	WGWlbmrEO149XRGTvV+1b0DGEg6g/7c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=BBW1f6SO;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870414;
	b=uWUfoO9ErYnGPf2+e6JnWQw619M6oZ4vfOMhD9Sd+efTBuZkiRJeNeUMbV6triMlsiFOkl
	+GsvPTUJiBc6/XPtnZa3IcfM2KMV99ebrcHYkqs76Wz/hOrmlzZ/O+lpCNm6XQeIKWIWQ6
	3Ud9jj5oJsMrGPJPuq6lA0pspOsAmMc=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3b147e50af1so508755a91.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870413; x=1795475213; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AjhVL/tzJIhPQa9pnWiA/Lzn5A7WcpHhkbmWbBd9Z/A=;
        b=BBW1f6SO4j57b7tww8KcGP5zt/sj0H37loGSPPN8M4Yptp7OyJNJmxCEOBRTDITt3W
         JX8TP8o002LLFKAlAp3dlLiePjbrdh9sz8HibYRg2UzZvpFAL9UbDWRNIfr/ivHfeByM
         FeRSm0ZJB2YhLeGU/lWFl/EWp+j7CI9oROKvs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870413; x=1795475213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AjhVL/tzJIhPQa9pnWiA/Lzn5A7WcpHhkbmWbBd9Z/A=;
        b=ANMw2op7Gm/RMboqAxNeVz2+zTnZD+Vjpo0SGURJbJbrAOWUVS6QpXtgymEJzVVXC4
         QGVcQrbLDN3lSSQzGx19STMEyXzCrpSiMtq5wa2fkoUxkBX4URu9eMSBVDzDOIDU+f11
         7PgKW0W0eC0pZkN3iUfHt3hYqAx2kNEnPfQarTjbCb0pmkrwmKtYe7rTVWV0xTbRvC9k
         TSwUWsaKP2ebIBLC9lpxX5ZO5PqytkoL5MOa/UgXjx6R2NwClraqZhyMG44xXTIztmgg
         Hz7bdmTvfzcsl5JorXaIbkJ8UgHLbNSVGQ5NLMB4c4ZYCnY1Pdx2rTMS1H6HKQiJpEs9
         D8pg==
X-Forwarded-Encrypted: i=1; AL+hErFh0GHdwBSEkQho9DSSut+HPzTy9Nuos/IA9SlRqYsizqVaQqKDQ+IQjf4LAHtcCa5+2ZwUBLor6A==@kvack.org
X-Gm-Message-State: APuU4Z8XwCDbrjSobNnLrKHBkpheuKciN62kPTc/dZCDdk4hMg9KVI6n
	a2cOfvkYrp3JkKNqNs9lVTiuGblVpNZeC5YyRuaIfIPdcdD3y37k4N/ocOFgV2O41A==
X-Gm-Gg: AZFdTZf5U9Hl9Vhoq6il1PhxIJSp1vaeCLm9sWhe76handGMIGXt6SkM+cRKVlaQazs
	y8BoEDvpSCsISyC+y9wEPEhSiXF5PMrSOeM5v4eazuaVByIT3PBlZQBZzUwZlgXCcvVU4cgSUzr
	GDsw4xSbgkXUBh5gfCQDG03ITd5zvSBjpT8uUsGn94O2syUpFJYASTj4figLocWPFif3uzAbsR4
	CA9o09Xsuh0Oq5QC3n9Oc9qD0vX65cVRxsTM8kw1NSHemalFl+ZNxl/e2DKzxGZlg3ksNHmBERL
	8+WJLrF4lWoO//alLKih1yodvQqEcM0uJfG5F52dCWU4LlJRLkX1lQBPzssho4oBPusyCcMMZQe
	LOz4B2InKdGqH3UO8wy7S/MQT1YW8Ktd9uEWEgEGbjC5t9sjhpJDGLojAMv4QAYpCIiYzXk+HDZ
	eS60eSlH6MQABjGM20+9Qf4SmFPThofriBL7YbIejgjZ6cGOk+sYstcG/N7uzss2/rwlGajKVDZ
	J7imYKGhhVN6HLesX981LPomRnbama04WmedU0+3NOVXxBGUgrvlWE4NIJSaNpD5woGzIsTCEX4
	Tf3Bffp7H+i7RaS1esR40LQHL8QyxZLnoZ7DrS9QFqmp8T3TTBru0t7+td/7wnst6OJfiVA=
X-Received: by 2002:a17:90a:9f98:b0:3b3:b15f:eb89 with SMTP id 98e67ed59e1d1-3b3b15feeb1mr322004a91.1.1794870413060;
        Mon, 16 Nov 2026 15:06:53 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3b3abe8b263sm1120450a91.13.2026.11.16.15.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:06:52 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Evgenii Stepanov <eugenis@google.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/7] kexec: use GFP_HIGHUSER_KASAN for segment pages
Date: Mon, 16 Nov 2026 15:06:23 -0800
Message-ID: <20261116230627.3537051-4-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
In-Reply-To: <20261116230627.3537051-1-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 57DBC80002
X-Rspam-User: 
X-Stat-Signature: x1bqckxohe4guh8stkjabnsqexcp813k
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794870414-266261
X-HE-Meta: U2FsdGVkX1/lHLiKLV83lobSt3ldOYqi3huiL8wb1U5mi8c5YTZdd0c8KY0v65VLib0ncrnohmLI8SGUEbO+c4EhY33BHmb4kc9G2d7VNlPF4x25MBIZNEAQav1eHg6YfMIfYQPwG+dguY+RW1OxCqu736Zcon+BCZwPHuQ5w/NIIe93sB4S1Fug/5sCMYDPtr7ukVJjB7aKH587GmlPa6SOSWuSPDujjY9mw3WcFAHtJ/T6Z1OHLiliVpunXwpBmJb2P7TrdbQ7RYBV7y8MOIrmufvIqkwLzaYGoO8tUaGGcUleGj2vLwh1+GvGLR1dZcmm3YakwYYsra/pKlsMC/2ChzilnuY99GWJTjXiEbEqW+SBeW43ID40NQby/6hk4zkQU+Dj/pIcxH9i4yHg8TCT3aJmYxAzEGroaMDtHA2ukJoJjOqbt1TfAWN81/q5cc2OpgRhv1kJ3Vuchf+onIAAHyYKuUcuaB5IP4Uyb7yGpkHO0TnRmvXrJEfXNxj2WsaQfH62G4A6GTaoj8iupRHc2zrdKQaoaY0qm+EFtnCWPMEbdaK/fvzrVrbSkrOgU67YktLfB8kBtuA/00LWl4AI0j39anqXyvih58W5f2eerZViOcXiIJtjOmFV1CoegN/61zGsP97tYwARew4EBRPTuLsg1H9OSVc3oh/zcyIaa5joMIlpV1ZNVN4T0CRBzRVR5IqlMHUSG4+QrlU16GD3Fap9YrwXHoWuI7xGpxi1s5OoOy8Iccun5NL6VNg1iktavSDqfyL6xkxr7wPFLOUjgOd7Idas7yf9PjdPsR1uDHc6trbBJs2ONcuGDFJT1uNtYk/vVr9Y6qjdHmfgsjHDBRCLg/rlOtJGVhN7/WOLeOshONELLm/aUz6WlhjZ2x4JgCjGv1qMejpMAtWncz9QwxQtuEmh4E2pkDlm1VjkvxkYjPTpz87qaN2plysPjCoKY1VsxUV9+eFjxfi
 NVB5ETGO
 tnbhurnbKRxJBb35KsYX+YG5CRLFn1m9BKVO9xRxyYUST8UgO9/YzXTwQG1od3ip0uFSqhKl1FWabqMPhO9Pir/t5mS/KDyxXrOUn1USul8mORwRyT+ivSDYC24AW9jcwQJ2Fk5XZk3jLJE4kk2u2nRLhqIQSPIeMbWlAowq1s7zpp3f2uC1BMLTqsLYZVdoEN8M2WfIjyiypayZAU2VeZd8I3bLUPER3DB9xktf6S7P/B6dbUI4zusudcnryniYJc2suSwbQSGqMgba+pOs1nmAcsWCycCI9z2lXJ4gmLc5AcwZzXFQcqjPlxSu1nnNdSgPp1Drxle4tx48Eu3fGUaKKLFZs+ojAoB17eNRhM0OjQLAMD/x93G9P6oDJt9oY0DrrLHRhWR6byTifbKlRgiY0ES3/GWyTvleRmJInUTbzk3uRXFnbU6RJnffkQAJHq5Wtlny3NHXcDLRVrM/pWEVGE48u10TPF1C2VgZCxL1PdCwi/f+SEJHbKqQkxdG6keMG5kPewppsV2A/1qgKaJbV//5Uz77y56Hyp95dEddFvZTML7l7fU22Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kimage_load_normal_segment() allocates the pages that hold the segments
of the next kernel. The kernel clears and fills them through
kmap_local_page(), and they are never mapped into userspace.

Allocate them with GFP_HIGHUSER_KASAN, so that they keep their KASAN
tagging when GFP_HIGHUSER starts to skip it later in this series.

No functional change: GFP_HIGHUSER_KASAN has the same value as
GFP_HIGHUSER at this point. Build tested only.

Assisted-by: LLM
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 kernel/kexec_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index f4a31565c447..a3abbb6a2d75 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -839,7 +839,7 @@ static int kimage_load_normal_segment(struct kimage *image, int idx)
 		char *ptr;
 		size_t uchunk, mchunk;
 
-		page = kimage_alloc_page(image, GFP_HIGHUSER, maddr);
+		page = kimage_alloc_page(image, GFP_HIGHUSER_KASAN, maddr);
 		if (!page) {
 			result  = -ENOMEM;
 			goto out;
-- 
2.56.0.611.g1030f0b940-goog


