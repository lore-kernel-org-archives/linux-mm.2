Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 439B21099B25
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 17:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983206B0113; Fri, 20 Mar 2026 13:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933786B0116; Fri, 20 Mar 2026 13:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822C66B0118; Fri, 20 Mar 2026 13:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 70FE66B0113
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:11:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CF281A0279
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:11:55 +0000 (UTC)
X-FDA: 84567083790.11.9691F9D
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6FB3620008
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:11:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=tA6Z33F1;
	spf=pass (imf13.hostedemail.com: domain of r@hev.cc designates 209.85.216.44 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774026713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahNTPAefQMpYMnBF9fjbq40PKYiHzlPr//dFmraZ1KU=;
	b=zlAENJD2hQzmy+yE3LL9dXewqaU1wI/glrtZbC4WYRnDZW1pyu3xFfy5o0Y2yRXzxIS6UW
	FYx7P2hqB0xe90OZtXqFf+nVFAnR1uo5RgEXj+b8H4fACM+rXTjxmNq3L6+RWaWGphXjR4
	07qopxlJu7L/KF3jJqpRMEsP7RolFiQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=tA6Z33F1;
	spf=pass (imf13.hostedemail.com: domain of r@hev.cc designates 209.85.216.44 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774026713; a=rsa-sha256;
	cv=none;
	b=ee6jy/sgTk+nfPVLgVZZXmZ4/lqXovu7Zcu81jqRStns5ElzH47C9GqgOCIcyXjpnIAmgs
	MfI1JGEO2kHA7IvRjdSS5XcnOcoQ5WhhJ2UxP1kv+13ww1iiWk+1PAgFroLJzqXHgVh/iz
	INmmOyTlUhOV//uzJbhlGGHwNmzRuhU=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3591cc98871so943669a91.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1774026712; x=1774631512; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ahNTPAefQMpYMnBF9fjbq40PKYiHzlPr//dFmraZ1KU=;
        b=tA6Z33F1fE/2tp3oAIPpfmetLFyO1bloo2D4WjCGgGiWOYEIv76Q8A7kxanS/EvWCH
         GLQKJO+7xQad5Bi7IjeDR+GnYqz6HSBBhxIVsGuNRwTuJUXZojgGR2YGi5EvBUSjN4B+
         irx3SozUk5JDZ0G3l6TZDLrd9ytYViAdtr8Gvg4FnFl0pz1ht92kRCE8tBFRh1XAWOtN
         o9XZp4T1TEvHXvmD8wXExU4l1HDHGHYfyoMgcHsOVJarZCfaY9lZqVU3j0I67OPGtznY
         J7DDK/UtRmvT/0zqzCx6eXbAARZnmQXn21xPeVWtUi+nE7ZDXa+os2mxbnxYs5Nfdx60
         0P9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774026712; x=1774631512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ahNTPAefQMpYMnBF9fjbq40PKYiHzlPr//dFmraZ1KU=;
        b=KywOqlu/dxP1dDW+cG3Qs5c+xW2PdrX5nwKSOCCKxnW14IRCmvijOq4SfQTdFWenIl
         LvLTqYQtv0W89W/XPZzGWoD+TW/fYl8YJ0lBWpohKlGAbV3YCUGcxCG9vXqxmtmOlTwj
         CQhUxtzxj2Cfv3Slor3qWS8gtG2M7DYoaJlETfp/VEEy00i4dk5CQwa9rXX+uo6mrNDk
         DXa7XS1ZU8yElTN4Jg0b12GITNe9ZJwwNdGRY91nn8Oi4refOiPjavO0qHIFT9RaOWOv
         RuioVEJzFjYBb6TylpY6uCnhJQKP9TM3lj2kyzuqgTY5VDip7hY13/69s9jSlOTKNEOK
         XE6A==
X-Forwarded-Encrypted: i=1; AJvYcCUWONJGu/ilTJBRXRWl6j1T3g5aLyd3qj8pQ2hkn5yQPWtr4RDc2O4D/HwCBNf1xgttGTsEsY7ArQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0UIOUUT2551pVtNwNEivKg/XtfS2+Bw0LCvoYsDEZTsfToFVs
	GTTArphKkBB8wPM/pb9xn+oMFwLgLqRT/iUhq2cd6PEZm7PKn6RzN6dIi3bAKnn5Z60=
X-Gm-Gg: ATEYQzxNbmWqhOEjbGiA5qbV9Dr6JK0KlXOk2aq624Fbl4ACN9UWKUQhiEzH5Rxa58P
	xS/ADyxsriboiQ9y632MXoygB9w77jhgd3CRGMHzsmy2qop6JGO9nV11XzxVdqRnPJMuDZhsS42
	wC+kVhfenvTZifl1KF9JmcWFsuYFoXrE2yQTfvCg97zjl32469b0R0w9EzYQBOsCvJIVWNISZSQ
	XxTlZ0sWJTaREcofIeNUQeg+t9PK93atSCkO9fsZjnr9IfV53Lv9pCY9nq7EC7OUX0g9vfBkrw7
	RJflTv2VwAFaK2OBf/I24C0lRX38T/WFDwmLFGpsGrxmQR0Npx9XAacd1XlnJyShpqnuOzwtPBh
	PONheFIFwiIUNsrWgkTEvCHAkH6ePYdj3szIpZl+T76ZXGXQJMwkKJeFaOw54MMtFjpq2LsFrNP
	Er
X-Received: by 2002:a17:90b:5108:b0:35b:9cd5:232e with SMTP id 98e67ed59e1d1-35bd2ce4493mr3220503a91.29.1774026712038;
        Fri, 20 Mar 2026 10:11:52 -0700 (PDT)
Received: from gpc ([2400:8902:e002:ded5:78c1:8178:95c1:6ca3])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bc5ff7056sm6018617a91.4.2026.03.20.10.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 10:11:51 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: david@kernel.org,
	usama.arif@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	jack@suse.cz,
	kees@kernel.org,
	lance.yang@linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	r@hev.cc,
	ryan.roberts@arm.com,
	viro@zeniv.linux.org.uk,
	willy@infradead.org,
	Liam.Howlett@oracle.com,
	ajd@linux.ibm.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	baohua@kernel.org,
	catalin.marinas@arm.com,
	dev.jain@arm.com,
	kevin.brodsky@arm.com,
	linux-arm-kernel@lists.infradead.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	npache@redhat.com,
	pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v5] binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for THP
Date: Sat, 21 Mar 2026 01:11:14 +0800
Message-ID: <20260320171115.93235-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <024d2480-df23-4c2c-9f2a-1c4a130f71b1@kernel.org>
References: <024d2480-df23-4c2c-9f2a-1c4a130f71b1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6FB3620008
X-Stat-Signature: z7yq1xwzkca336snjj6refmc3np9at7t
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774026713-872743
X-HE-Meta: U2FsdGVkX1+mk83r8v0c6uxrY2zaa4EishbJD0w0cyYrfYUGs2toINxTzmQdctLJ0s0+edC4orOrw3RtGx0FXr4O1OSUXv9NTAUwmBOVRcl1kkNoux4vYOP+NV5ej303AZ3qO46OKaHoCqFJSQ0jCm9G1nIZbzmZ6blQLDdOBIZefRWAqssX7Dh5em+bs1y9iL9fgaKH30O/x5cTdg8ZRtww+1C4NBeh1c+0y+gDeTCAD5I0Tx/eyB/yivEO1x5h9JngXw1Cq6JT8tn/ba0X2L5Hg7MbVGIwNQ5CKTz1pCYBjHYy8uY+PS8LlxY7n7Jk/m5fwx58oOyyTQNIs0YuiohEVHYfxFDUCXPDvR6H3tS/hgXkEKWSBhjh7God/jlUx7yEeRTfotFysBViHlyiHPgRRyEkMrOJ258PHJDxJw+tDmt+xbCWh+COneNywDKJW5VjCVcoLFy3z30zIBifKrJvc0KPAd5ZURzbfbPmjuIDezFB5yhanEa6HJwn8MyR9CJMYfFSzQebYYVKibguy4OKSyyyqwFQdmZNWgLWl8QFjqyDDirkCUvdVYBFq9bEHMUDVnAWfMkb1kW8OeMHPwxshzOwWyG/GNcC8F+jcxX9Kst3rCoolWJKW185gWQG5SXTu6IG1WLBynBDNin/UzKpOJSEBxJGeKjHHj3j9Esq/ZOTYdZwxSknky5fJCkOpJvak4ILmCPrLAcU34JeFVbQ/vfvzoXq5kVYr3fQwB54We7pfYvNyGhwd/QbdPKNUI5waumRfFmEXaijgEt3trlSG7HE6YaH6W4FRK5UuUfCHhUzhSlSJyTMIRgzUQEvcCARwfLeUlDXQimh3GLFr/HxzASjQ4OHNxA4AmzvxRjBRo9WTNbXk1CSGKL4RL1mPqah1GzdSoutdsSNBEkyf/rSVCN0QopvzIUzz89QsrddXygT2/XGxu2x7q80YjQKszyHKdBnwPtGaCf6ZFL
 D6uqLNeO
 XiCqgkwjf1OUVkldp4zb9sje6Urp88RI9/lZY2oWs0kdZ4cnr2yWQY8lypw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> Thanks! Also adding Ryan who did the exec_folio_order() work for ARM,
>> and also raised good concerns in [1]
>>
>> The problem is not just alignment for elf, we need to fix more things like
>> mmap heuristics [2] and how unmapped areas are gotten [3].
>
> I agree, ideally, that would all be tackled in one go.

From Usama’s v2 [1], it looks like we may be operating under slightly
different assumptions. His approach seems to key off page cache
characteristics when deciding segment alignment, while my patch is more
about proactively making things THP-friendly so that more code can end
up backed by large mappings. That helps in cases where a segment size is
just over a large mapping boundary.

Maybe what we really need here is to make sure the virtual address is
properly aligned, while avoiding overly aggressive alignment (e.g. capping
it at something like 32M, which is fairly common across architectures).
Beyond that, we can just leave it to THP in “always” mode. THP already has
its own heuristics to decide whether collapsing into large pages makes sense.

It also looks like this approach would work fine with Usama’s cont-pte
mappings. If so, would it make sense to implement [1] along these lines
instead?

[1] https://lore.kernel.org/linux-fsdevel/20260320140315.979307-4-usama.arif@linux.dev

Thanks,
Rui

