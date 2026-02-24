Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84701F357C5
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E699B6B0088; Tue, 24 Feb 2026 12:08:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41566B0089; Tue, 24 Feb 2026 12:08:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D3B6B008A; Tue, 24 Feb 2026 12:08:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE2FB6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:08:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 605D313A025
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:08:20 +0000 (UTC)
X-FDA: 84479983560.23.A65E0DD
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 873D1100016
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:08:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=o0DXWEOz;
	spf=pass (imf05.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771952898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xJz4QDTcumvz9JVrQMb51pWWatd7LKwHk5h8C7Rf46E=;
	b=5Xq68rMarNj0oPCKpZ/TOfu5ays56rejiBZBd4kmNz88JRV1dVJzp64b6SO4Hc88xmSyyZ
	pNfR8CQ9iaD5m2gLrLflBGtSdyAnAzlI0D+1axZsmd29XnvJX6kJ22FyGYlEelhrc6oPfI
	5hvp4A+uD1N4HlZXCMfltaBsW2Axr6c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=o0DXWEOz;
	spf=pass (imf05.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771952898; a=rsa-sha256;
	cv=none;
	b=vW0S+Vb/VZd4kgUyQYME0SVcALG9aEWrnraN53gRF3LRvIyQanj1uyAgkWGI9+BgmxwemL
	+TuTa/qey3RGslkw4SM1bJZ309peVc58tAcfBy5fV7E2l2DTT9FFXHeYmDvmRlZoRClvAo
	lKhouJZDpJsXsNgnxqd3/lEHx7mo9Qo=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2adb1c1f9d4so13485ad.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771952897; x=1772557697; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xJz4QDTcumvz9JVrQMb51pWWatd7LKwHk5h8C7Rf46E=;
        b=o0DXWEOzGX2LsE8575g/Duf2z65hbF6AEoTCd3AHFI5kdyN80s4Wqu3V2U/4rB5gBd
         hUbvx48m3WnoW+9FcV4nmXMeQ+D+L3qkv16kjOB8PC7wkOQF4/nymxV5GJtApHzqVOuk
         pLFHenCTOmoiBQOzFxlHF1uyKWJW5GOdStk23cujV7l3it+EMkmbUmrT8iDGOFEVAtMk
         JvtUieVJhcH5UBbX3i6FM0aAeDktVuyxZcrlx1RHx7sM/9G9tlgE4+YNyMBohNrP3U8A
         EwFQFJP5Gaw9+GNfudpzjUQ/G7TvBJlKTveULl4qFbSeZGUiZTM8NSowDA0UR05g6WcY
         C8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771952897; x=1772557697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xJz4QDTcumvz9JVrQMb51pWWatd7LKwHk5h8C7Rf46E=;
        b=TIJrJB87Xce4waNG0Wq/wX3agS8twfhpk3bL7DxghzpT1uVjTq6d3eSjXEM6DXs75x
         0TkcioLsDQ5TYMWc+foiA5M1Kk3GJ5u6PSmN6qlDYMjxW7RPBPUTSfIJfANcLBy7Al4x
         3BP6ggauNSyIo5z7FYFqFZQ2hDcLtY/57ZRiwFVjsVgUXTQwo9OT9vta4pJENnNlKW9l
         0Mcv/w/4j0GxYAU/QhvP5n4fNLSHzMEhUrIDXr/y8+pP3MmVK5/ZPjupFWkbwOTE+eb1
         fzncavRMlB4X3mmbGJG7DARYf/51IOif7WA6Bv1BfkpbrLwMYI2ial7wVrTX5RqRPt1A
         1ylA==
X-Forwarded-Encrypted: i=1; AJvYcCXmI5I/a5hV+TDnyiQg75T1eXSDaOJv382HkzMbjPntsNXAU0dLAXsjYTtRSeLpX2XlDzCpKzkLdQ==@kvack.org
X-Gm-Message-State: AOJu0YxiyeTfIjjPnFd5EDv9G8SlGIEOYJfjySGnCrY1aOmvRfPt9wu2
	WBmG68l+VnJICDhtIa/qX1CAD+QMxcwp7mv2dOfBFu25vR0iWbenwaAaRDP2E0qM7Q==
X-Gm-Gg: ATEYQzwSzO88nahNNTVRSeF0wLkqLKeWCcGprZzklzKOzfKzN1j2Yt6i7GopbkLBtOO
	qfI1eJUGrRJHq5pOLMSt3PVAJThfDy7FJByMbRJ1N1QvqpbV2+I3IbzkfH6BCq3detcJcDj5tS6
	mWyeH5SKZg7Ga2YP0IK14JSrhlNmZGMaESKZW63NySNfs8fP7qNmS/0WVl254NWMSWrRco4wv9z
	nadqBORj1sHPR6E7H9/1u6r/KkiNwh71re1PvQW0dveJc0ZoMf+fdGyAmp8PjM4azbgzmgSTuN6
	tU0JeCCTdqngl9SktZr2XYIiNZq9++KELT0lBewrxE7zC+j8zGzTrxhIgi4kJ4CtslXhfj9ZY3K
	4RhQo+JilhiwWyMBtpAgKbWazl7bF4IqE6jL5mD5aPuToUfg5+D4jP66WGV7f1LqYn4+CKCBq/h
	/WVXUd60HjLKmJkEwMO444thASNOI/Ycd19dGebG75WfjTmkpmYw8pEbgWesDVKg==
X-Received: by 2002:a17:903:b87:b0:297:f2a0:e564 with SMTP id d9443c01a7336-2ada346b6c2mr1775335ad.11.1771952896593;
        Tue, 24 Feb 2026 09:08:16 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82719e7ed8asm1521995b3a.5.2026.02.24.09.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 09:08:15 -0800 (PST)
Date: Tue, 24 Feb 2026 17:08:11 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 01/22] liveupdate: Export symbols needed by modules
Message-ID: <rlftyyae4w4frzcpvyecda32vxod6uambsb7cja274lugs4nhy@3yk3oki2kwo5>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-2-dmatlack@google.com>
X-Stat-Signature: mtzo1kexmtn91bwy8n865hkhuafi7smu
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 873D1100016
X-HE-Tag: 1771952898-380360
X-HE-Meta: U2FsdGVkX1/b9DT+J2Mkzf8XBDRXKq3jLr4RIuRykDslZUOha3tpR3cVq1mFCcrg7dx5Lhc2ne7UpUow5icd01t8nyCE3qSAjKp8NvqCo+7Oyfft2Fh7vjp6350Nj7bR+aaB6E0UXAOT/qTtPquy0p6Pd5zeRWg3TbPnR3H3aP5jAr1IRkR3z/+zAWd+38ynCrWgOwiGznCCextmhN0fFtE+uboThHWqU0bLbkJBNjqxb9I/FerJl8n4SnDd75EGHJUDjCiLESc+GodKvINN90GbGKalO4shiVDorLTyqrmQZrBHyCKpgsuLrtsuMha4BN5v4RcPANKK2xvVQ6EHjUllS2bYcuCcgmmEo46c40YfYkgRza55COWeop1XeB/bVLD1h1i6jo2QpV2sNq8q4e2pDQezn8dm9dT4hREynwI/RAjrNiB5Yk6Q7KacyLjdqxh1d3uYzy+hwVdX5PTWTf0sd+qWbf8ECWSJ5WFSchuZ522uBrtTddMR/pOWd90UQ6p+tt/EYKi0W7X8VfGXMvOn+BIZ6NmLge0KAmnKe9kZlvfJMTfX2U9spANP8C5xnvDSmkYwYzG1WaXpzG8Ez6/hUM/1yXRYvZBUS8p9EGwdjPhL2yznehRu5X9ZpuNyCb1xHXdSbo+Z8+YDf9V6NetpR15YFQkTw8To3FldEK8xvYEfl1iNQjDGvyX2HjSVo3kdR7vfm+V7WMVReKB8SIuP7ophkkw63tHJGQrMy1vQ8iTFR7/4d4ZPxfNiTAg09jeXq09dAxT26ricfZsbDQFn6NgQNbxVpsVEitUuyo/A3Vnw1IGhjvBBuMXrUG3MLmdlI6rfFNL/xsVqf6XXtLoolXGiWvL9YJmXS36SjvlplhALShaHuef2PlMUBUcUUoqJtp+yzhu9dqAtt8sruTmypMLUFQ0rd6LmbtsFpXbakZERSWhbC5qwKjY+pWtAwkCETJuNnrv9/NxEMf1
 Nej4mGWG
 PCXAtvHfb1cLASB+bmtpS/Re6xMyVPmgRfL3J4447f7CwnNebulvu8Ah5thlvaMa4dz0MPExTBihhrkuMZFkDhHyJLpzz6LrYxEkiG22uwlRVd0Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:48PM +0000, David Matlack wrote:
>Export liveupdate_enabled(), liveupdate_register_file_handler(), and
>liveupdate_unregister_file_handler(). All of these will be used by
>vfio-pci in a subsequent commit, which can be built as a module.
>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> kernel/liveupdate/luo_core.c | 1 +
> kernel/liveupdate/luo_file.c | 2 ++
> 2 files changed, 3 insertions(+)
>
>diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
>index dda7bb57d421..59d7793d9444 100644
>--- a/kernel/liveupdate/luo_core.c
>+++ b/kernel/liveupdate/luo_core.c
>@@ -255,6 +255,7 @@ bool liveupdate_enabled(void)
> {
> 	return luo_global.enabled;
> }
>+EXPORT_SYMBOL_GPL(liveupdate_enabled);
>
> /**
>  * DOC: LUO ioctl Interface
>diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
>index 35d2a8b1a0df..32759e846bc9 100644
>--- a/kernel/liveupdate/luo_file.c
>+++ b/kernel/liveupdate/luo_file.c
>@@ -872,6 +872,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> 	luo_session_resume();
> 	return err;
> }
>+EXPORT_SYMBOL_GPL(liveupdate_register_file_handler);
>
> /**
>  * liveupdate_unregister_file_handler - Unregister a liveupdate file handler
>@@ -917,3 +918,4 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
> 	liveupdate_test_register(fh);
> 	return err;
> }
>+EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
>-- 
>2.53.0.rc1.225.gd81095ad13-goog
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

