Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00133F94CC2
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 03:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1CF6B0088; Tue, 21 Apr 2026 23:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8C86B008A; Tue, 21 Apr 2026 23:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF9B6B008C; Tue, 21 Apr 2026 23:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 288076B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:37:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B01CC8CC17
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:37:53 +0000 (UTC)
X-FDA: 84684782826.26.D32886F
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id CB7A116000C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:37:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="WvG/FN72";
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776829071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxPqWuBU2oFFyikxF8LUvXvxrcVBiFKCu6t827VR+oQ=;
	b=zIv4vA1wgJuVgxVQ3+Y+42hW3iWUA0QhtUKUBUGqTmV3dvcqT4d9OJJvwobxAtm3WpGKln
	ro8k6HNjWYqLdxx4d8KnqDWU8C6y1sYGNuUxvK5PcBrgaspCkXpUQ5rK8LYCyFV/gm1mWQ
	OTirvgUqjedv7tl245O275FoRldDuz0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776829071; a=rsa-sha256;
	cv=none;
	b=sc+XgMXjxLY+fX0UNtHcN/wpshf32wmDEEcUVnoR8yn/xqzKELv7H4cY9ccoSyvgdfh5MB
	VwppZUefzi3DtxFye7FfSQ5BSo/NonOid4jXwutQwXCJCr8q4Vdeehjup8URbaaOZbKwV0
	x3gl9HKuOnOe2lGhHIcZUqkueZBxJHU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="WvG/FN72";
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8c70b5594f4so545119485a.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776829071; x=1777433871; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pxPqWuBU2oFFyikxF8LUvXvxrcVBiFKCu6t827VR+oQ=;
        b=WvG/FN727v2+kIQXol+fmsIB+LeUfz8px1d6nJLPRwW8BBNSC8wL6khtX8a9aDrtYb
         ZFU0eLDJhHcHWj85W7aqGsVnuX9ZcxYttVUauJ34Hfwy8ciq63FUbGJ70U5hNSigJi4x
         PQn/w+gEkqNhLSCN2gv6VZtTvbxaevVdyRjsoO/jJiB45Igs6SykneUGq5mbZLXzsnCv
         UQfJ4R4JCOWQxD9uBdP+Gx2fwW9DlApTWgbakzPWtKIfXSM2UrUC9O3U0lKUqmSRADSC
         t3w5Jr/H1biZDP2lWXkBSzL1ZerufEYRTP56Siytl6HkXGscV6Cd/NPltFtkQ0rSBUS0
         1btQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776829071; x=1777433871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pxPqWuBU2oFFyikxF8LUvXvxrcVBiFKCu6t827VR+oQ=;
        b=cJL2yo5PZlADGMJpk1wNkIhDbAuAX8y0f1mfOK6wtE/eQJfn8bLI5QGVFxUgmeqgTV
         7XmLTF8AyDMDdfv7kurerElyVk2SixY1lwoS4ohnnKpcyIl21+cDwM44Jal035HwWXue
         3LN9IUrOIIu8pIClXsV/XNCaJa5/dgNuBeVRByQHX7g3JefRhAR0R1x3LkLwRASjdyqp
         j4kZkUHyDDyGY0+01UYEJ/i+13OViiNge0EPMtYxMxT45EsKsDWAn/tw1XxbYzySQ5Yh
         pshnflfm21FNGWargkX+j4f9tRXYWHQJuj/wfz7DxIHYwDY1KnJ/6zfQNPM/vbrvpy0E
         Bj8A==
X-Forwarded-Encrypted: i=1; AFNElJ/y+V3IdOzS36vxGkd7YNYS3iIuWrcRgC5+Ob83GX9iL7JEtNXNiTx4QAHlMfvvG18FdI26s20Y4g==@kvack.org
X-Gm-Message-State: AOJu0YxqIzuPcN+Lw1q0rf/IrZkwvgoVEzxpBvihtmLEvA0nnahqNYLZ
	znTmSQB2/Qt+AVOpZBMx4lsW0CwRg93NYtMiN9450g1pSx3Hihe5hwptg/eIVvaSH7s=
X-Gm-Gg: AeBDies+6PBURD4gj2Dbi2Zs5lJQKBEMHYOaAFo5e1X7eGcAqK8pkzitCi91iRi21Ax
	pgK2J5vuPxUkdhxlAUugyn9BNsVgxmmUbVNoeXbADHw9yx/OLnvaAV5qyD31JOQ+8XcJmTOe/VR
	Uu+jQM8dsjXNye5ITFHNuSkO4Z0ker7XziwSHNxAB8N9SWs6cgO99eVZR4M89UHSN9Xe7VKttsy
	chmHIKflEU1hZ5eRhZNVQg6mpbZ1KsGgalsmRzva+OsX+zf3t0hzE/RYvehwokxhstYSjI+2E8a
	51D1l3zUCHZWLND9ufNfnQTlhqHz+2PeTJ4WWYNiBSI2rFsPaQWcK65IMU3NXXrcWg7ExLUk5gM
	6iUMMl32Ts75d71q11ru/3ZxRhZ3H4OdjMvmgc6UPSjdej9577y+0kbG7386fwaw4HBu+r+AQo6
	2vJna8yR1RjKTuwnvkjf9XTqGDjQ3hpwdtbKm9C1X1jiJEwrdQWBAKjqbyV6hh7fjS5hqL/vIv1
	HGEkrCVkriaNWXC+VUj5V/mOcnQtzg=
X-Received: by 2002:a05:620a:170c:b0:8ef:6b87:5c4e with SMTP id af79cd13be357-8ef6b96ab82mr327111185a.20.1776829070854;
        Tue, 21 Apr 2026 20:37:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-246-228-50.washdc.fios.verizon.net. [71.246.228.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d8edb789sm1331917885a.31.2026.04.21.20.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 20:37:50 -0700 (PDT)
Date: Tue, 21 Apr 2026 23:37:48 -0400
From: Gregory Price <gourry@gourry.net>
To: Bharata B Rao <bharata@amd.com>
Cc: Donet Tom <donettom@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com, mgorman@techsingularity.net,
	mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com,
	riel@surriel.com, rientjes@google.com, sj@kernel.org,
	weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
Subject: Re: [RFC PATCH v6 2/5] mm: migrate: Add
 migrate_misplaced_folios_batch()
Message-ID: <aehCjOtPtt_wrQlv@gourry-fedora-PF4VCD3F>
References: <20260323095104.238982-1-bharata@amd.com>
 <20260323095104.238982-3-bharata@amd.com>
 <24cd6a95-1304-4732-9273-43c73ea858b2@linux.ibm.com>
 <aeegL2ltmCTfuJiw@gourry-fedora-PF4VCD3F>
 <bed91b49-4053-4d9a-a6cf-6d3a4654fbc3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bed91b49-4053-4d9a-a6cf-6d3a4654fbc3@amd.com>
X-Stat-Signature: yeinfebdmcmq6b4gq8phwospuk1cm9ux
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CB7A116000C
X-Rspam-User: 
X-HE-Tag: 1776829071-169118
X-HE-Meta: U2FsdGVkX1/Z4uEPvGnJocfRSqxaFmYU3Sgye/hQt7QWCF6xTDD1vZazGR1iCA9ah31e5rc6Hl8XWW1WBJfoWW17bn+e6ul9sV7XdaXLjf4NmnorTUOviX0YFgP+cdAzt02Kq0YJECAKKFGiQATc3g2qUXl+xbVVDkQLGEz6PC0EZ1C7D6aWNvmS76PFOvSrlVhAcVW+0I/2MV3rb1myFLYpO22SefT29Qc3k8uZWO0emAs9BpQp4/B3zFDOk40Vs3B0OTBZZjSnRo3MKswIZ1azHe2EiEUzAWzX/7MC56dw3Np/a2iUBIdbjj0lmwRNJXdKvVI1arCdWUwUhKHzrbgSjyOM7ovP1NZgWwFlSQi2E5yKISN4nKu0ESnqCnNSv/YDeXvFpgLHMGU4JGIEMF9EO8r6nA19CaPnYx5i6EbAr+fgVj8Jr6MQrANSJaI4rxDshlFIK8B9wmoioZTynOh0OpDzj5wL61j9+NQ+UoL6K7JkDCwjhRNCDGeWHOy32I8oJhlTzz4CxRst4ffipANiUzx7ZsolnxPcPxchX5pJ/AQs6IK4om9L5BIstHXoYuaJklmOz7m+udZcClSdAwoiCw4OgGQejbX1plxgcFDPx7mtRqLm7Rz6MY8zXCe7y8DaGsi4GXwLjIEXRbWRfBnbemQuIuzQGtBD54F+aRaQfikz7N2PKZXDQjFISRSmTt9F76Ev6xjCJwOVOCOchLF/2IxGfAz6Sd92xVlwiVwGzrTKGauvfoFrR25wb1wzExyWLr2VmkxT6duUrFJl4s0QUfT27wBPhVGRqqTpbu+Dtj/V0/egqSLc5C+yWLRM13snGEOlBIxvSmg8SM60zMG328lFGxlqHfbvryoJho+uoi1F4QGK7JpKfG0Fh9ImzZkm36gmL0RDcKC1rzXjDv2yNt0QODR5TR+5q9yYC4mOtFE3FhvydKmGwZ91PjjGW5BIXTI+dqXH55aww0t
 UIv1ogRS
 bnlkr/p9U4ZrVJ77soqmMhAXUwYvs5DGAoT2tUZ5v7RcWLBhJ4Lm8wf+BS+mAioxDX5ws5wpZufXZa5or4lfb+2pdYBY8FxcVkdb9/haQC2Zid9NzYgeAYMn6arMhvlcWy2lXle4wx5exHKtUPwW9g4CNJLYBqo4HmCnaqqHLHJiobWJFB3MTNV7yiCrKKYgf4ayyVAw4rmnzCM2lf0DdEpeq2AO0vBaYZP99JP2KTZeQFAin6tbbc6ObzFhVrsUAuMXHsLhDZ0e/44JgAHMwGIvwA7ic9RRgKZWTJsn6goRq50a9WNIXGk06QeOgEi0Br38+4gpMkZL14XlHI21UhEQA2hhOxaQtcaGFTKTPfWff6+DQRtcJkCyBpL1sG2B2uwLtm1qED73fndu/E72YARlvvPoucpvuLXa+a5HEdZHDfdrh+zzE8hTzgu6cD4BY6aaF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 08:56:59AM +0530, Bharata B Rao wrote:
> On 21-Apr-26 9:35 PM, Gregory Price wrote:
> > On Tue, Apr 21, 2026 at 08:55:02PM +0530, Donet Tom wrote:
> >>> +/**
> >>> + * migrate_misplaced_folios_batch() - Batch variant of migrate_misplaced_folio
> >>> + * Attempts to migrate a folio list to the specified destination.
> >>> + * @folio_list: Isolated list of folios to be batch-migrated.
> >>> + * @node: The NUMA node ID to where the folios should be migrated.
> >>> + *
> >>> + * Caller is expected to have isolated the folios by calling
> >>> + * migrate_misplaced_folio_prepare(), which will result in an
> >>> + * elevated reference count on the folio. All the isolated folios
> >>> + * in the list must belong to the same memcg so that NUMA_PAGE_MIGRATE
> >>> + * stat can be attributed correctly to the memcg.
> 
> ^ This is the expectation from the caller. pghot caller ensures this.
> I could add a debug check in this routine to verify if that is indeed so.
> 

Wondering if the interface name should somehow reflect this as well, to
make it a bit clearer.

~Gregory

