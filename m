Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD0CAC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 14:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19F16B0088; Sat,  5 Sep 2026 10:12:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAD36B008A; Sat,  5 Sep 2026 10:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB99E6B008C; Sat,  5 Sep 2026 10:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83BE96B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:12:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07E28A0364
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:12:37 +0000 (UTC)
X-FDA: 85179899154.12.23653B1
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38CD1A0008
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:12:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=HTIbmNJm;
	spf=pass (imf25.hostedemail.com: domain of weir@nebusec.ai designates 209.85.216.53 as permitted sender) smtp.mailfrom=weir@nebusec.ai;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788617555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lxDVcnnYjb5CDc8+vcFdroLASnmMD0O3N7V7TN5dAX0=;
	b=NHgne2ixM9XUeRxA3Cb1xlalMFEWg4Y0oAga4aODm63KC4QEXsCgv/YIN7wk+HllAirAxb
	xGQviNDoP4pXIkCLkQeTMhSqfnOt+LsHTRvbkXqJe8QNG0czVFqzKxNhWOfXlt5EnAb+uM
	/Rst78mWusi1geewSA+c4gkWz+uWQf4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788617555;
	b=Zj8Cpk/eHJ3LJump2QeVHe0Ia7IIE7+9+zvbTuooxSlZ+BH6aHySuGajLNM3aqLJgB5WaO
	Z4uPvPm0X13xZyQakQdarUy6NGGUFWf0iCjIWn9Nx0AU594gDXQ87mO8vj7liuHVSd9C2I
	GRVeROrYDZ1Amh5hdziAQy3ctW1i12k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b=HTIbmNJm;
	spf=pass (imf25.hostedemail.com: domain of weir@nebusec.ai designates 209.85.216.53 as permitted sender) smtp.mailfrom=weir@nebusec.ai;
	dmarc=pass (policy=quarantine) header.from=nebusec.ai
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-39682983a0fso2194049a91.3
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 07:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788617554; x=1789222354; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lxDVcnnYjb5CDc8+vcFdroLASnmMD0O3N7V7TN5dAX0=;
        b=HTIbmNJmQhds6W5es6qjqws02YSsfxjdJAskpoKgsF+689wXzmEqCUOfbhSg+cLn1i
         RpYtvR7/t760yQo39gDTixribC845ybv5u+0BA470FOw4mz7oDv9XFGV99RscfWckunC
         3s+ZmDMRHfYET+e/5Hklm8zV5Fkn3HjIoJSTRyK3Dmc40e00qYA7ksN8KupdY1tfd1XF
         +1GkjshzwUaXAe4xgopw9SurkD2PxHCJWcIbd8JG+4pONl5eTQtRhXDK2Mhl8YQLBesq
         FES6CRQcZ/avEs/TpPCuX1TS87Jq7phnYv6orgbxK9QCexlPsqqtEPHg373tkrp+fwcw
         zzzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788617554; x=1789222354;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lxDVcnnYjb5CDc8+vcFdroLASnmMD0O3N7V7TN5dAX0=;
        b=L1aDXMJAYPWS/trspsCpbjZlw0CXL3FaHcbNaOtZ5u1EF0fUZH+5PVBoTsZYtzZs+t
         iXts2zgZG+5CQ1rr5HGs2gULHJa6Lb5B0XI6XxSFOMn+YZEr7xFB9LnTSi0Z2OW+0wyV
         D1WPfZkgS0DmE8vq2Cpi7fmfYFZ24B5m2ROHTbESvFftIb+yTRDk7NW4/4Xl8yQhKMwG
         dFJx/n+xvLXI4llq9VS91kwqsq3X6fMzGMa3QiXkpICSxnlWxUxEOW6MzdojX74lFQj7
         +YvxbHOLRTAaAJjmkj/o/FZwW0sspggNVn39TtEdO3q0pKA8DjywcighGDhsmyDE21r5
         +vZA==
X-Gm-Message-State: AFuF++ko17LGe+PLzCt40UWx850mQ5ddZngITII665FtWjZGZMFUOekP
	XHq1tn+BVU8MEUgkHMWi8Q+m6WR+u22rotnqKbvO3Mfo8wDVlJSH2oIVnaLC29K2rXE5PzPGrsW
	gpKkCDQ==
X-Gm-Gg: AYBFou0WK646OXXqIT0tm1cbcm3WOEp3KMfex4Oygt2s0KG60Qej1zxhhpxQ5+BTZxp
	/1WBJtyT4ClNPKQ8oRTkhpFHhYst98BOJ2Q1uFHAnN3r2kfYb0NDYQsnjwcrPaw774VBhv79HEn
	OI0894puQmBicab80UsQOMirq47pwVjnB33jz7Na3f6d6Jc1iYAPMoVRIpf8uMqFW4WNXzcJMNK
	Szh0R5z/YCAnl6f2LpjMVTNBKdIlR2yRAJNzfNdzDOiaFqS/hp1EX87n5h2qEG3SkJTVOycx3Tw
	lNUR0vhv0yy2P2BOfia3lexTmy7oMUfcqSEBgsPt3MgaV00QTE/Qgsi2WXH8fgw9yZTUXQd++Ll
	B1Avi9N5f+o781sGhJ2Vhjv3+93Wgli9MsbVX8lqSrzml4d2zc8r7soPn62DM1tuo2XQI199czv
	kRO11RmUHF0+jApZSjyDY+VNpgkeQqzgJ9Nivo9495sZGvc50poHrhewxrDBCGI9OuU7Isaw==
X-Received: by 2002:a17:90a:e7d2:b0:381:1c96:829b with SMTP id 98e67ed59e1d1-39b260d296cmr17297604a91.3.1788617553835;
        Sat, 05 Sep 2026 07:12:33 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([165.232.167.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b07b197a9sm16454273a91.0.2026.09.05.07.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 07:12:33 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	notasas@gmail.com,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH v2 0/1] mm/memory: constrain generic_access_phys() to page boundary
Date: Sat,  5 Sep 2026 22:12:16 +0800
Message-ID: <cover.1788531737.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 38CD1A0008
X-Stat-Signature: y38tmhufznai3wkugn5qnsi48dm1s5qm
X-HE-Tag: 1788617555-940344
X-HE-Meta: U2FsdGVkX1/Sr4E7WYJs6QryidpS9RKoNb9fGY73MtbZltDDGe7SsYDmjAUxAbR4kqaTz75eR1whE03JoEYPs4GnlU96n2cap/kkxK4XtUC/CMDdXSzBTKnywOoOWRsvv7YwbolSeFPJOmYw9jWAaBSa9+JhJ5jCO6qBVSF5hZMUUyIR3XKmKvKLbMZ5RtVJ6RS2BxCAtq7jW6dcQpEQeuceZMs0SeEPo0E1wYBLUl75kHKvQGzD2fhj05A46+2ZfbUrqO+UOS4jMjFDTHutGaBqqCgFyzuS2G2ZC71Adm5nKCPfTSHbhst/zZf6RhDTRrEszNxnCjkArdizpsxakuOAjpK1LzB0uVXK6wFg2xjR3qoqKKwu7ND38TyjFW9aSNQYAYhMmzBby+NtEI+T5u86yiLVhMK+1z3PAYR9aZt3z7APsss2Zlx7R0Hc+Yd4ylxra2ejRG+gZBjki3TAzXpsm2XBJ2EsDI8LI2fg3hWkpOZFBLBe35/c7vDsJbLOfH4eCyAfWtOvVHM9xDXyY3m0JvMsxT+yYxJXd0gha3g0bPxCpYcceceTrYtshz1SRR42ugqYDRI+2RzkK9bIIkjlwZhIQU8omwYnoTL72cXsXPjMXCkzlPscQLtblb6d6e6epV8AJEPTy8uZVKMyYL1a+1HCSH1gOUb7JUs+kKvrouYjUytCvgzgarQ24rulIxaW7f8geIhZLu5G5brEXkEsoade0b8JsGDe4e3YNvhYpRV8e5LzyzCalNdWlOMvVChOyn5K152M7OsN8tPUNcyD9Q2tdya5N/zaluBb1R8VCgSmFN/qqrgH8Llv76IK8u7A2ipviYMFAOiznZRzP+9mSMEf3nCV6EQKngcCPhajxrp6y01WDvq52hxKYfJRVGgKGfb4Msbtu14vGYe/vIIFODTYSD6fijbH8wSc2F97VlxTsnkSuX0GDNbAXdA3bmIJ9al3fEGG4tkSlyC
 9DzSWKUm
 inIenp6oCFZFDThcnvGe4Z2i4A/dygO42/Ifjfj+LfBM6VTWUTpvXSOmke4oAEpWQCeaXBfURE43eOz4a2XVX1xylQkMorCoK4Fj66yHlIknhol4EgAtQKp9kmSwZwKSxY8FpXidfpyszXpm5WTF9ATInSiE8GQyzbObRzA7roO+EQsqI3HuGrP2jMgy2KfwoBxvf8r4Q6vACQ1rm2wxmgVo3TpPjFSFmGVuZI85bS5qROt2g/MWGSbljhnjgswvFqj/ETXHOqqx9v9n+uJTks9RgQX0hhhYXv8MbNwXrxDd3fGuZ5zXf2au2sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luxiao Xu <rakukuip@gmail.com>

Hi all,

This is v2 of the fix for generic_access_phys() out-of-bounds mapping.

In v1, we attempted to handle multi-page ranges by adding an internal
chunk loop inside generic_access_phys(). Following feedback from David
Hildenbrand, we realized that caller (__access_remote_vm) already has an
outer loop and handles normal pages chunk-by-chunk.

Instead of duplicating the loop logic in generic_access_phys(), v2
clamps the access length passed to ->access() in __access_remote_vm() to
not cross the page boundary (PAGE_SIZE - offset_in_page(addr)). Because
all VMAs are page-aligned, this also naturally ensures accesses never
cross VMA boundaries. Each page access is then driven by the outer loop,
looking up the VMA and resolving PFN/protections per page.

Additionally, we fixed the missing (resource_size_t) cast in PFN
comparison as pointed out by Andrew Morton.

Thanks,
Luxiao / Ren Wei

Luxiao Xu (1):
  mm/memory: constrain generic_access_phys() to page boundary

 mm/memory.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

-- 
2.43.0


