Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778F5606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 14:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WImNA200
Received: by kanga.kvack.org (Postfix)
	id 51FB56B00EF; Sun, 22 Nov 2026 09:53:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D03B6B05B0; Sun, 22 Nov 2026 09:53:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0206B05B1; Sun, 22 Nov 2026 09:53:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0716A6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 09:53:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66CDAC070F
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:53:45 +0000 (UTC)
X-FDA: 85463049210.10.DF0058E
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7706C1C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:53:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WImNA200;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795359223;
	b=7QXO6+4PpQGOkAkQj+pbWTDSk6SxlTMeyRxTqs4WzmNraXv2v0JP3e3V3g/tW7YyHl45pD
	40gXm+uloPiVUTiZYbHfjhb3ab6ZLuDhBOVesUzAt8p+CLHnQPkfUnUoBW8pca/0dmVmpe
	H/nnizLCw19VzSuLMXT1xnN2CrDSBno=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795359223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMgj1FiPWOfcno2Rg3daraUU1yDv6jWsUnElDClVHG0=;
	b=Czq2HqFqF7aW3Cafzx+v6XjAm4p2OOw69gPJ2wjdYAO/RzPm+0bKemfVdx2uKpSnTOUrWn
	envNoGH6TunL8oD2Am+lgRvS1lgZsv3Kn4lQLltOUxxjnG/UQdWr5dhL1DToiAdrkxGxvI
	EDE4PRPkTxM7hdGJNLF3kVo9YVYm5QQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=WImNA200;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-pj2-f9.google.com with SMTP id 98e67ed59e1d1-3b196fefa1fso1310999a91.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 06:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795359222; x=1795964022; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=RMgj1FiPWOfcno2Rg3daraUU1yDv6jWsUnElDClVHG0=;
        b=WImNA200Y/hf7P8fbzE75e6vf+aDGUVU8lWGWSvIZOakTiQyHSz5HkTp+AfYSsfn7k
         AUli/U4raS2S4XMaz02qnb3oEbmt5ArX1XsG173yNx/YC0wE1f3aKQ9cm/dfk6gh8leJ
         3/gUBmkwf0jL6lF7TU0CcJANGnILjwsAuGYX6s089Nw9VE6+o98dsLGkvpsSTQkvx2w0
         cWXaXUZQvcaiFjqhkPckAwHP8UwylLkf5q1Ju6un3CWpCw1mUOArlZpCX4hLs2ftwuG4
         EpI40TBxakJ/SCUYIqIPFqGyaBILiTX4z6rBiVYEyPYJrHVkowl1uuOmzBEGI1aE6xd9
         lPSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795359222; x=1795964022;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RMgj1FiPWOfcno2Rg3daraUU1yDv6jWsUnElDClVHG0=;
        b=n5pyhcqlW4TZYq3M6DguR8GW0iH+dEd3ICW++dbvV0XGrpBgyixvpzidBZldEU7Dhv
         yzBJYJRESU5IqiyLcZiOJbWQzjqehxQF0LhTqf/zbjEueDOJak8FoH1DGh3zU6Q2Te2Z
         RX4ZfXi128HTSqlbn57J5v095BOWkdyRDjfemkiO6bN7X1MiOh2tnVmulkz2W33Xc6H0
         WsZUXdY8e4Hatk4K3fzfxoXXhh9fnP/yfjHzYISeuZd5Z2IOpzSWSni2F/YQKOnaKjCq
         EutiT596NZh7R9TB6amrPrLPitAoo3CZl2O0Nw0tUVM4I5iZU83nBfn9HzXo1qxZVhpc
         +lXA==
X-Forwarded-Encrypted: i=1; AL+hErE5Z9Es/EMZYUoMdZKzFgQHKpmHQZWDDsJCHEzPQro0OeVR2jeOzeg58ik5zgBvPEghObxv1zVt8A==@kvack.org
X-Gm-Message-State: APuU4Z+3pq8ZCOuaZ+hJDssEuLBi0/xHGftMkiCGF9bWXH/tHHTKVGTU
	S7g7qmSuCxXTiFdb8dw2Sa6kTjW923DR5/0lVsjzr83HxAZPNq2xbWJ8
X-Gm-Gg: AZFdTZdmEgCgO5O11MPIEhRmzt+VMVxETdiKp4BClwLZL9Ibp9PvLahcvSyQUsT6YnL
	v1XLP5FlAIbHhTS4WtLdWyMkNh5xGVn0Wi6ZD9jz5ZTUZoaah0Bhlh4mDMm9lz520zi8xvsOmLu
	uPhVYqUKDe+rAPwrvuVVj/6NiVq2FDPQ+oevdkqpQsYZb5+NGywf4Pc8aNsUIDPX9FmW2115CFC
	Afq/9JlL5VuJBQrHlGbGLQ8JqdFA0pLvxP1kGrLoBjy/TTnTsbpi3UaJ3UL/8EmCl94BryHX7OB
	5iKl+iyDMDqoiWbqpXnKWhKcJJF6XjF4NhFr3UQLzNiqTK5+gX4w37FfULQjBiCZ3Q4WGphVizL
	Z6CgrhVPjG6sL0zeDQ3wrv7o5zP+oyKnk1N4HrC1gRIskOh4XrjTJs4ARhnJ4C+WyiOmJGFi1It
	0GG1sE7umR+ZcC+/UqxlOcBGhIZSrKAbKZa9cPXQFMufydhbZb8kuIgbiJQhFEogjpECvmj8+Uz
	JNhFtabp/vdsyJoVjIOUfUkPordzfFoOZaXosQnkmH93vlMpM8ecgQjE6XFGsXkLH3DvotKWSl2
	74TBdxlAo57lkEyvRTuJhO620JEOBwxHMY+yC5w1yQIQzqpPiaI+qpH7JiUXKYsmtCe9unZ3EvA
	Kh2gWbKtGYIogrkzobuAfZ1kectB6Za8w8dXcKUggb1VHbvohQOtd1p9Jl/hVkd7CS3Jffyc=
X-Received: by 2002:a17:90b:3d4d:b0:3ab:36c4:b502 with SMTP id 98e67ed59e1d1-3b41c90329emr8542890a91.30.1795359222086;
        Sun, 22 Nov 2026 06:53:42 -0800 (PST)
Received: from [10.131.38.181] (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b44b75f2a4sm4545959a91.2.2026.11.22.06.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 06:53:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/hmm: account for subpage offsets in device-private
 PMDs
From: Aveline Noir <jm5905938@gmail.com>
Date: Mon, 23 Nov 2026 01:45:21 +1100
Message-Id: <179535872126.34.4789080961796247940.b4-reply@b4>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, apopple@nvidia.com, balbirs@nvidia.com, 
 christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
 Francois Dugast <francois.dugast@intel.com>, intel-xe@lists.freedesktop.org, 
 jgg@nvidia.com, jgg@ziepe.ca, leon@kernel.org, leonro@nvidia.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Matthew Brost <matthew.brost@intel.com>, mm-commits@vger.kernel.org, 
 =?utf-8?q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>, 
 Patchwork <patchwork@emeril.freedesktop.org>, Shuah Khan <shuah@kernel.org>, 
 SeongJae Park <sj@kernel.org>, thomas.hellstrom@linux.intel.com, 
 Vlastimil Babka <vbabka@suse.cz>, ziy@nvidia.com
In-Reply-To: <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
References: <179342234355.4.16705453209886955762@gmail.com>
 <20261121160037.1a479f3c8b4e860bc23c106d@linux-foundation.org>
 <36be0904-168d-4813-82ff-27ecced464e3@redhat.com>
 <20261122015246.d8b6b98ff5a8157168156339@linux-foundation.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7706C1C0005
X-Rspam-User:
X-Stat-Signature: xuw89c8np4soqeamq679qusiq4fwy8b8
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795359223-556184
X-HE-Meta: U2FsdGVkX19TmuvUMTdzOiSk20T7DokdylVzzhEpxYYZUklIjOnhLL+s6YuB26rLVWdsjuFF1jnI6PjNvpmQUcJtneqWjZL0MCzjy8iBHMalDotvaNHipSTuOMM25rciFJKfAfZqPIudza8mmuPpw8dYm8YdiYm2k3ieoGLLdehWbu9z2W6Voqm0NtcUmeg6qk7w06gq2sWIFpJ9Ika8gtUlIumJIZ3Keuh/O868fDdYKrGpuFvpdYr7Vv5IkMJfkNlRvhSwFEY4JIAk/346LR4v2FCM1uVTq8EESttTTMGsoRDzvY0/43C17U6g2DyRQ9C6FdShoy7XI/+8GiieoAn2HTOwzf7uQXftSDMKU8gg8ieiK2RzkPMQyMsfMcq7dZLBBIpKrGHPX6zfBAiOZdxRWedMmHYtiK8lFUImiEkCBMVb5rr6peByI4JRjDaYEecmHUam8qrtV2OqirOXOBT1hqCw+CKmTFVaBMlEDNXQhKpXGHYxMrGlg7GazuieE2tKnzXP0Q0qcBIwGeuti2xdcPaXk/u4ZAZoqJ6CnrjRDfqToZGXF4JRR/+LgdjSRoUYDq40CyQvNNgx/+HjGeGSt+6QYWfxaZdn7J+5IATkj7xeeOwHIMNGPFgmQZIlxzIOTlUrp/vvNwRODLqg31gvSryKblK1oqfjMX1+n+xAE3KsPlu8Re2CUEnSqUsmL04LlpmssGHg8Qdmlf1RIG8MXVU2teB/PnkgENLH9WWZjQLPeVI7AlHgPPQ0l1VLRfPjJ/oteiTcC0ZLXylgLRn+N4av2TNlBwrSGUDxZL5oisk9O8CLjZQyAKJwQZp73NatlvhNzpOtWyXUjX+dhU83cHFa8qB+H+Z409x1qNcimL44JDrs8EHYKRcKfM5222doTQYlnKgnfDLO+b9QDObMK/jR31yP44bnSThGcuTLG/duJ/1U1LEq5e20ugYBmb9Wpje+Krn7lVa5vYz
 +KPIyCoD
 CGc3EnKHATrFln32nHZIn/zEF5YAwz8y5PtY9g2bBUt6ULk/aZ8EQCbWDthc/vg4rcckl8vfBoY4iiV0I7uQKzLXfx2h8hoh6LOBnr4yZJ4jVhSkqbdjh9yeziBn+93a2jiwyO8xZqYXrCCWTm4QJXmOxRuEU8m9Kgod0980LYat0BGBK1vjqGXK5wlysI+hh/6PyPggzOlwLlqh4+7TgUaj5AJrTaFM+DmfFhKjjAgsI9J4ahQ14+joguViajb+/8Rxg8I7a+6QVAu+rQ4mqqmzXbH+cVu3NbX2Wf3scwbEreqt+mDfMHkl8FEfHYqC9BoZTIk6QqsQNEJdfXDIhoMCbzTnto0N9vIK8J8DrGeKNo2RO21l31CZVUc3TDSLmuSMa4+4iN1x7AxLjomp2HarE/k+RaXUKHZ7BrkhJY/HkmQbVVrr8fPG2briCzcSB64zkir8juAlXNWnZOMaZXHdyOLtH4qSgcJkNlCHP67etMGjcH8ovEa86mCDDOhApXAxaQhyLRpm8niyVnq1moLHcmI07rmsT15AHBvmie64Q5fpB3ACO4TgJqFMJstjAMy4YAdUIGIhUyot2ReKpNukoG0fvY9WhupCyV3ZWziSbPTHzydLzCWBqQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

On Sun, 22 Nov 2026 01:52:46 -0800 Andrew Morton wrote:

> Store the corresponding RAM backing page instead.

This avoids the oops on the first read through the second descriptor,
but leaves a stale backing page pointer after CPU faultback.

Since the mirror XArray entries don't take a page reference, they rely
on invalidation.  When the CPU later faults the page back to RAM,
dmirror_interval_invalidate() skips MMU_NOTIFY_MIGRATE for the same
mdevice, and dmirror_devmem_fault_alloc_and_copy() only clears the
migrating descriptor's entry before the backing folio is freed.  The
second descriptor still points to that freed backing page.

Reading the same page again through the second descriptor in QEMU
triggers a KASAN use-after-free in dmirror_do_read(), and the read
returns the stale data instead of what the CPU wrote.

The second descriptor's entry probably needs to be invalidated before
the backing page is freed, and it'd be nice to cover a second read
after faultback in the selftest too.

Thanks,
Aveline Noir

