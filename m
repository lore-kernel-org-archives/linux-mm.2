Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3866CC98304
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB786B00A2; Tue, 22 Sep 2026 01:34:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB4116B00A4; Tue, 22 Sep 2026 01:34:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9566B00A5; Tue, 22 Sep 2026 01:34:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1D9F6B00A2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:34:50 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46963803CB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:34:50 +0000 (UTC)
X-FDA: 85240283940.03.B883C54
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id D89DC40002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:34:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=co851yyU;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZqncuA8V9KN45lL/iPHOVqmTI1CzmtLR7XQjhWRrog=;
	b=FjFB88xs9QJyflUBdrKSGrGJ5FFrgYnyeNO5ZjajPVV01mIWrG3vkTVMwxQsbrGu8BWW9n
	f5AtcA0lTOjrvPk3vg+0cqvqxaOUoIstNyMcBSnJE52sqXJBoBLnYzbLSxdr2+VnSdal56
	zwXGNYO7UVUkd8/yR+0vEfwQJwspdRo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055288;
	b=yfwEplDuJ7y4/ZyMXbRd1WA4MOyfQ2DhptnrNHu+lkKhPY46aGTxb6N/ZXGUehEgmdd7X3
	OK9yBgSvR6KEHuCuXXwy5Mt5HLxR45c4PGoQVWgyU8FVMUXmZB2Fls0r2yEjWDXPsfDryk
	2UJgvJJD61ozIessRTaD4J/0VFyfhjs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=co851yyU;
	spf=pass (imf04.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RZqncuA8V9KN45lL/iPHOVqmTI1CzmtLR7XQjhWRrog=;
	b=co851yyUkSTByzK/aaOaom/mDlCBNWZPNAgeGvwy8nX3JwA2iENXmcF8Etuoonvkc5JKDd
	xXN6cC0YJFBrfrAei/6a+6qlrMj0C6bPwDkIkbIENVGmfQ+Fmg7zRdhOQjGbTEcL0CPjLS
	aGqSdGL42OstDOhAjn1/8tR9vQf6GVg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-yEWAHEy6PS6w5et5GYHNtw-1; Tue, 22 Sep 2026 01:34:45 -0400
X-MC-Unique: yEWAHEy6PS6w5et5GYHNtw-1
X-Mimecast-MFC-AGG-ID: yEWAHEy6PS6w5et5GYHNtw_1790055284
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3a59db0a722so5027331fa.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:34:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055284; x=1790660084;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RZqncuA8V9KN45lL/iPHOVqmTI1CzmtLR7XQjhWRrog=;
        b=DRQ4OUr4SU1KW8Kx4tan1YJTMYSof9zUpADtTHUTbmEptiZ9B9Xp6pCgBJfJBsE+Fe
         OxkDQoRCPSXAWpx3QR1puNWyu61MSdIEIhYOTaXe+J3QgoVehC30A9soMw0ydcAXjYY0
         TkQGHMrzaIbjq7vetSp2jo18fmhCIVaBBIlBFiAnD6zYbTDPUVi4QBNBGtXXghHSzsO1
         2JWPKljOXZplc6hjDkBqCxHKuzOwktGnfwCmkRYMKKVNBaXcznRsF3XK+tilHn48qd16
         njAdH163GXEU9gVEYY1vf3td3bcOAfZBAx0O6F6mT0wteDPMw2iWlzOfp2+HxCYmo26R
         R4pA==
X-Gm-Message-State: AFuF++lwo7FeKRlEYvDFB1z5NfWm4DCAgUOjQO6XFnqSDoBQ00SR6WY1
	ZQo0Akcvp33HDWZY84D3x+mwoztElT4Ge9Z6grwEr/Gi28woSqQZEddFsG1W332M5aePUBCkg8o
	d/INide64jH/vL+XKr2jJnj+CDHko7TlxjaUpt3DsX5UbMRJcIjovQWBpq3ishSv/z8IvoJ3UL7
	MP4bsD+rrCJwx9w2+gA2t2eufWZD1aA4zD3/WT5Q==
X-Gm-Gg: AYBFou1iTqPbvt5x7JoZQsECoWcnKs1Bfs8PdJhMWs3jRgwnv3FsD/fKqPEMG8UAKSQ
	iCMWNRDVPRvjpo9qsSNjdhHdaZMGRqfuFnEZwXS/lwOs9F+XYovS4fbDIWGQXG1kqnvhqK34edN
	l98gCG7i8e8BM6/y9TeC40yWTkbSv1hwB2jqJ6zEfsa+l1UexENQt9h3wm+LpJR7gSYomJWA54c
	NRw7bt4mxs8CsxmLN+D+SHE8vpQn4dmreCzq4ztI6JLSLTXkjVEauInjIhkejCALC59/FnNtwUz
	zLDA7domrWVHsN7PzXsPJAq1NhYiB54guPYRUvXSESgQjzu9mcomaRgcXVfloHS/Ek6iaRd0Biv
	tE+YyV4QLEzOaIzZtBT1c
X-Received: by 2002:a05:6512:3402:b0:5b8:b3e0:74af with SMTP id 2adb3069b0e04-5b8c195ea85mr3626254e87.59.1790055283634;
        Mon, 21 Sep 2026 22:34:43 -0700 (PDT)
X-Received: by 2002:a05:6512:3402:b0:5b8:b3e0:74af with SMTP id 2adb3069b0e04-5b8c195ea85mr3626231e87.59.1790055283051;
        Mon, 21 Sep 2026 22:34:43 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:34:42 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v14 01/12] mm/Kconfig: changes for migrate on fault for device pages
Date: Tue, 22 Sep 2026 08:34:10 +0300
Message-ID: <20260922053421.4092027-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l65Nip7QcSvn093p5UiZ_6e3w022fm6tAYTFbZ5Ojys_1790055284
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D89DC40002
X-Stat-Signature: n11xhtwap96yexpx54mpm6fz1s7to94m
X-Rspam-User: 
X-HE-Tag: 1790055287-411127
X-HE-Meta: U2FsdGVkX1/R1+7DVbZVTGnWvb2BTBF/EmtZHBn9OQQtB/vghXHmg8aPwC5dLrJeUndZP8X9ea1Q9PjeXnAiSXaXj5TWIoDwtwwJVWaRMgoBTlJH6Ai74UEMHuMnb732H5NrWoNXtuH1AG+cfelpbEEVpOmQlco35WWIXqcxUSiU8g3g1i/K/tuFr0bM+iW4YLoJT5wla2dAwJoFZeKAC1/3qzPx50Fd4TZxjkxSt34ySXKiQxImql5YF2ymmcRCus+TZPpbAWcIMJ4jmg3C1S5zjYD4y65HJerWk/dVI0dkxWaoamYLqiDxKogNJfNjAUrdiB269DwPo8SYH8W0v9Hbd+6P3HJvFqMMP4xvmD73RXLyg9mEk8rMGOksem/Bs8WT5kNhUdP1HrHLWdn5hj0Aq9zUkwujxkaf4Az7TV6Bxbvn8EpWm9M7r5kqpNbJHWjHXNu7qP3kOvRiL1AFzu/tkFfkM460AMfoFa1zwVMxiOShYRgX8jv4A3MuBUqjlyoh4M1Mep5DDCm5MTWd2bpBgxY64Q4cRmMI4ug2AM0QdwdMdmCUvj8RfBHeJVbfBe0/8I6lj45r0rcwzDDha7kmN0ZfzZU3LzfFdDmwW2pXYbo5JQrE164NI21bZtLHgOn56CW38+zNy1Gt52yrN03rhPEEww/7fUOzJeR65tmtXyRUmpJsKEtZ3brZF9ywjjpHl8fSK0Ff5F2OR59ZNuGUAn2Yloygqh/bN/Q8Jz3pOKEV3kq77PZJZT7xCScgFVZlKvLBlzOStVcmmwEjmFCXfCXB66FwTjdbVkSKjaEAZcP1msQdd+OomdC1RgXMp5T74TOgqKqwBc3m93VSLlJrC/nvLxR9+O3fSGMi2RC8Xo3lFM+w0XZKc7YReHmuk8zXtObWXXgGLML1dlALv0QviPTJFK5iM0OrLMNf6cj2MRzfxHB17kaqh5xR7HuLOZcrt/uukqaqSPg+Fzu
 XeV+dgSe
 HfqHv5rcxO2rKQvmbWFUbMwBeCYTsJSmIjcYwNipS5uAIaag1Rr+BvxL4MEwawUgR0FfcY/EbWynwIRh+88nS2FSJOe5YSaudmlYtpj3FBdmo6gDCmN3nMM5o+zFnJKRXP2YiLZEw2JAWqaLlQECWbpZNCnav2o9JdrCY1w32bkQwg4pihaXuxp8MOZXeY8BhrIiEgGAT4CVDa8R9WVBbIxFByMRc6kSQL0ITEayoeitIzYXVZmT1WGLmo2SO6rqwbNnviKGSAcOBxRVFbxK9AVgnTuVm9X9+RdXxS8nSxLddrm0LZyPrOreoGCTPuwO5ajaBblNYdRWjY9jrfZWkgNfLVNuJmKEluobr7cHzv6dsuzLfyKYLkEMnMIBNZ3OOVD9pQr6m0d0hoAhGvLnLzvxXJjzWRctCGd9uM6TaYJIowZUGlrm3KEkMXW/iY1M7yXEWGVaXRwtAi7bUA9YvmWRpiXW+CJO9tULiial7nkqC+M/lqf63+TiwOaOFQEtrY+X6d1J7jhKse3F1ZqTZLJcPGA38xWcgiXOVf8nMF5Yvs5DZk3ErFABaJ3nMrjvxZx16UKkkYmZSNcRkYIRUeodAspVML/vemBMTt6JnQZouy9TwMvOIGsLRm/MPeMGVs02l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

HMM depends on MMU notifiers. With the unified HMM/migrate_device
page table walk migrate_device needs HMM enabled.
Enable them explicitly to avoid breaking random configs.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..b7a485beb9a7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -687,6 +687,7 @@ config MIGRATION
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
+	select HMM_MIRROR
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
-- 
2.55.0


