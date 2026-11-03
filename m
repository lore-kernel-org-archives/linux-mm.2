Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94931606A332
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=MqroTrqI
Received: by kanga.kvack.org (Postfix)
	id ADFD16B05B1; Tue,  3 Nov 2026 01:16:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABAC76B05B2; Tue,  3 Nov 2026 01:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD286B05B3; Tue,  3 Nov 2026 01:16:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 833D66B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:16:56 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90113A04CB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:16:54 +0000 (UTC)
X-FDA: 85392799548.13.6CA5A17
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4DF81A0006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:16:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MqroTrqI;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793686611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxeQ7ppGYBKjK5meXlEqKGqekI9iSYV6fmFE9Pb4Uvo=;
	b=HRb3DtM2VTBoR1TaRJB8iUTgkYVRqsQDcCmTl0WFw9Dw+iC5UmSt6mvJguX6g0CZ1JoV0Y
	ZgqAnNrGtgQj1pfNSbv56lA/CXTUS94oYUt82JEDU9qxiPTBqD9lX1vjNqRScP89iQjC1Q
	j0XOsxQhZ1SLP0zRNXCPVXYF4Xjx/1w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793686611;
	b=pIoHhLjR48Q7seA6sKRionoFl26OMLotmP60wmtIoExerKCmnwpmuVyOvg6l2KB+5QAEgQ
	g/zQvJYBwKqP93v9Uan6UuphaatgHW/GyloA/bFYIdKQm8Jblr8hahnA6WekSYwVe/bt7a
	tMCeTk1MI98Cb4+a2VwSDG8zbK4ypmo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MqroTrqI;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793686610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oxeQ7ppGYBKjK5meXlEqKGqekI9iSYV6fmFE9Pb4Uvo=;
	b=MqroTrqIgjt84lnqIMOy2MlT2wzyvIElh+QdbKrpwvbKvmBFgaJNkwMTF4FpPhXA+mBu2b
	/JuPDLE4AGNL227KXTMkehzRWNTEuz4UncL1yAh8j28yYtKTUR/19UxFGzqiwl9yqzksBZ
	m95yUcXLICDcZrkKFkRCblOmxduRPxM=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-231-SF7p5R1xPvGzezLrupN3hQ-1; Tue, 03 Nov 2026 01:16:49 -0500
X-MC-Unique: SF7p5R1xPvGzezLrupN3hQ-1
X-Mimecast-MFC-AGG-ID: SF7p5R1xPvGzezLrupN3hQ_1793686608
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3ab32495d61so26542121fa.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 22:16:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686608; x=1794291408;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oxeQ7ppGYBKjK5meXlEqKGqekI9iSYV6fmFE9Pb4Uvo=;
        b=CRAkKlI8saYn4WEPwQZE8ykdGq1Ca/iFuB0FU5mAt4vGYUXDOrSgQzzpxVgS9TsPs7
         i9C4YEG+HHaWzf2O0GzIdKmbsrq8GFMgPgv3AbeZrK2HZx2jQLP42ex2swdy8SR7UHKE
         me7ZjQlZbiFO6kQ2FFfBAECS/SUjoOjQf4UUF3/u+0yX+tcbHqdlMxgFoERFgV6wFVif
         GhIGP0PDyZVRi5kMx63cTL8+0RQ49Cfk4acAtBAaekKrMMjshaZcwOI8qAa7+fULxfJQ
         lk/X1Ze/pWHD8b4HK0QC+YeL/9OKs8wX3NTjDUYc1gkQChaG/e6ZUVPztQwh7wcFS9Gj
         lC5g==
X-Gm-Message-State: APuU4Z/7Syz7JlkrfeDSAvO9DOCzGEeowv20w1E2UmQumggm2yuDLMAo
	Sh4SAfZ+K9MZ2/mwY2NRzZV4vEMVawhcP/ZidW7pPpoaOHVzqVo90N4we+st/pi8A4UNF6LMi04
	RYYtkrJ8m3k8IAcqAEdVZbrxtdRNYj3VmiEm7cFVYPQrAk8L5Vyux1Kj1XOgx0htwPqztLNocC+
	bKdMDkqBrAGhZ7SLnCatwAgFKiDtqn+nQswiZLoQ==
X-Gm-Gg: AYBFou0rfFmASqUG1xygY42shfeCZl7sdvImoaOEZrgoeVX6x5Y1uo69tspvRzU5CqV
	PENFXprrj6hJACCTI5rQpQfG1u8A7VnNUNLpQnlt46ibIkT1YSFYAHZvo0b1/HFIo8E4duJPjCB
	rcPVYXid2jvtTiqXzfWQYytvnKgE7ZlxmJMXvr+gYhnlNaO6TZRb2y2anUhbWsJS1Ggb7sB1hC+
	9vN1fGutEebJqB/HWPaT7bJGqQvl2AppqzPDl+J3WG1FclSa/0BGW5hqyeNa5M9Sv+ZvYRWXHjC
	PwKNVoOny34CUAro95xerjixBqxcLCQjuPR5H05Bki275yOU8jfJx5TMH83HDFmurv0DPNhskkr
	Gg8FdiCnCUfJTEbai1VqR/3zdXSE1UDrhdqOqDREqSEC0CiQotwYGEl2uDO32yAvNLBg4Mg==
X-Received: by 2002:a05:6512:1393:b0:5bf:cfc6:edb2 with SMTP id 2adb3069b0e04-5bfd951d540mr4443733e87.1.1793686607801;
        Mon, 02 Nov 2026 22:16:47 -0800 (PST)
X-Received: by 2002:a05:6512:1393:b0:5bf:cfc6:edb2 with SMTP id 2adb3069b0e04-5bfd951d540mr4443702e87.1.1793686607340;
        Mon, 02 Nov 2026 22:16:47 -0800 (PST)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe073e0f9sm1964634e87.54.2026.11.02.22.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:16:46 -0800 (PST)
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
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v17 01/12] mm/Kconfig: changes for migrate on fault for device pages
Date: Tue,  3 Nov 2026 08:16:18 +0200
Message-ID: <20261103061629.972669-2-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103061629.972669-1-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Zo2BI9Dyaerx1gu7AB6G84scul_BiwcP_qFLNrtRpJQ_1793686608
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4DF81A0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4inta8eix55aatt1k8n6wc3w5d5z4tzj
X-Rspam-User: 
X-HE-Tag: 1793686611-793373
X-HE-Meta: U2FsdGVkX1/YZmst1/rGoH2pbRvqnr5229Tw5hJeRmAyqfq+OQBeIHrewxidepQZL8qN/rua05FLgxfgKcyj+pSwweqPyal8y7S9h5/gmZugdNcowHXBY152qXZCqO3yrMxEX8DxLqUDbJN9nvPT+ZNBV4Rgg6Qj7UyDekWyt+XTvt0L45PodyQxwYfJmb6g9eZwuLVE8isdd3G4jlHcZjditaXh2J1ttSGRWyzyfkWMku6heG3UQhiGdZFnTh9VR6z0KKtTaDnK/7cqEiecOYnexBMV6zc35bEkrkXvZuvhqklnqRGvP8Yh4nBn7QsKpdpP1y3FfcuA9Mfc8s4+OIUlakRyLOPUynKsLby+bjsiSaOL2ftLRdSAnjwMItF6kM7ZtnV4apuOoXj9PniY6Zl72274+ug7Lo/zN2sksO1p4L4bYfhj2VBsZX+s7BzJD26Irt0kIwjDwUvUBsjCinc43ECnGgA9K4DyLKjSdkktl1eSpUPD+/DkZGJbV1D+ehORmHBVNI6vb7DXVnudqDJ/o/TH4UwvqjPfpiQReOpjsw2rUofrxEGxiNLo0gCwBgKAM8h/o3KrAW/LWE1lrIlBraHWyDH0btVK86jO+FOuqunOS1+lrNRCTwWZ/BgZ0BKSTkpGMJFD2/hEQJh7SSNj3lLoMdpFRP5k8fa17TWPmPxJwQeJL6DM8KTeLiPXYFYbXbIcIbPXPvCG+KI1unhPTjT4+/vLjwrHPVPwXS+bFK41tPvgVWr6+M/58z9b7MsJ6iQ++Ih8yNfd/DhMpzXD7i607n1yZO3Xi05Td99le5Brj2C/UT0dfShowLt0cJ4X2MwwfZ/jWft9wC1mSqZXjpVDhTBzr7SS5xbaF5I38sgmBxceDuFTOFj3GAWBjXoyALv/kc93Uk45tl5sAU74CaYm4TfdNGu/K+sZYvjm/OuGWvVeZ6mIaqZbt/PAWICRXOSNywQabkwyQ2Q
 ZJ+xHZxG
 ij3VHhLI6abERiQ9i++qYC27FdmRfJcuqLnZITYuWy+ek5NrPwpG/KBMuHc8dRyIyUxX5tLEGT5zMuYvWqvYq0vIr4VFenRQ8zNJ0zrNPJZ84etA9SicDqnZho5mBc99fEYmY5b4NAQ7jf5Rdi1K769oC+Tsz6rOZqAJHWxlXXIDKFwqAEuphh729qc5FMvtQu5U2bprf6AuuxFN+8ejeG0Gb7RxXVuCK7KnHieUqiV65aYqy6cyYIYtXyNGuD622qlsivqzDufDyGfJhA7KwmWMo7jzVdRdOdSyMoWkJoIPO9HTiFO8NNqKgJit4EGGGL0BwQMGK3qMLWGOylh67++XteGgzCxLB5zFp8ZxRdoEk+652z7tE9RVDP+coqgDfHkSSApkKX8kjbM9XuncSg26LjBV/7E13HrqZKDw/ornQDsV96awwMUZe3Og/YnOA486y4EaysB+xjV3W4ZBugl5Hy8cDwsLDQTYx8vQYTifYoGxRMM4fNsMknXFc5Ex/HvhyaA9ai7v/2Qb7zm05Wr+tIWlQc9ChHwxKN2Nnu4pF9fg3iSU8XXQfp6JwPnToc7SIBrr4f/hA6eLx7rtpPuWuTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

HMM depends on MMU notifiers. With the unified HMM/migrate_device
page table walk migrate_device needs HMM enabled.
Enable them explicitly to avoid breaking random configs.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Balbir Singh <balbirs@nvidia.com>
---
 mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index afff1b25b543..6fa03655b575 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -682,6 +682,7 @@ config MIGRATION
 
 config DEVICE_MIGRATION
 	def_bool MIGRATION && ZONE_DEVICE
+	select HMM_MIRROR
 
 config ARCH_ENABLE_HUGEPAGE_MIGRATION
 	bool
-- 
2.55.0


