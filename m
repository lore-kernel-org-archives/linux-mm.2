Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3211F606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=P5R1fUec
Received: by kanga.kvack.org (Postfix)
	id 5BC926B05B1; Mon, 23 Nov 2026 12:32:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545A26B05B2; Mon, 23 Nov 2026 12:32:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4342A6B05B3; Mon, 23 Nov 2026 12:32:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9746B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:32:24 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0C371409A1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:32:23 +0000 (UTC)
X-FDA: 85467077766.04.978211A
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id BCB24A000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:32:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=P5R1fUec;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455141;
	b=LEnrvSOupYVQNUxxz0Ntq2IMQyGp9bqo4iS/+C02KigJThnQWW1U3s9SNAos022khybfFf
	4pyA9SrcvN0P41f73VDSvdihksUYmzg8rvM1nzj+fLKpaHWI9yzB4Dfs1qsxuELCDQLJ5o
	hoGLCfHQcwKrDTCLIYJm6FfKvO8IA6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+l/VRR07HqPbgm9tEPK7SVr6Tlf5vY5XKwCiYVXpnE=;
	b=RPudh8zQdsotzbZOSFFXqGEGni9fHW0rYLLESoJmfemgb+y9OqDlIaNvl66rQrehtT5aoK
	rxd6HnMQvjbkktJaOEm7ue7Ty0/IVQVmQx43CztlSSiMkwk2bU3/mDFDt8xoK8+IVZH/u+
	JO8bb9X2GocQR2++8cxkZ1+fIL7M6K8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=P5R1fUec;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2f04244c3d0so29819365ad.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795455140; x=1796059940; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=P+l/VRR07HqPbgm9tEPK7SVr6Tlf5vY5XKwCiYVXpnE=;
        b=P5R1fUecfTRR3yN8r6PtvvYoe/MqqH6JUFRK3SEZz0NgZleRrtFll2FsG+nHvNPR+3
         OFvIs1Fjh4Ir7Qg1ot99UAGMPVFHLRTFcAb6FRxu25P4AGKj7yqBoDALERF9jX+wYVH3
         bkDgSgZNiZpxfHlLku5syzRiWhGDc/s27n9cBvU44Ko7pMwG3HIZrulym2eOOuK674S6
         v6REJPnScWHIm2y4RYLRVftG0UFN1eyhtn533TJXEObJ+RhNheuI1S5SBCRbKRo/qz0v
         GdWcNqoyldTD8KLC0K+gg2VootSE1uJhZ8LJng3bbX03L07P7PsIc51lBOJfR9nySSGU
         WYgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455140; x=1796059940;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P+l/VRR07HqPbgm9tEPK7SVr6Tlf5vY5XKwCiYVXpnE=;
        b=WGIeOOCONZB/FLfIa7D280IlJRKZwY7RdktrQ9d8/Y+RBUDcGehCZ7biSVDCzb9DDB
         lxXJgN71npp3Br0CHxPdq2MudNINTTwHQ2CMxkLZZMbZYykzlKT84upcfVyALwpgYxMj
         zmhZGB+EMQsm7rzMI4br++XyUaO9F6UqrUAi9j/yrH93DL0nhEkwMEzq3Ewh2DEC8C8O
         Yl7TjOpHP6GUtOBpc3Tod1NK3A/sRJZq23J0Lnfk6nbqLZLkYF7nsfAJxuFDOZj5/iMC
         ppG3j52bunE/TX5nKT7m7xfb/DTHhftLnJq61iA0325wbBXQpJQQqE1v2axK/Ng6V/We
         w6PA==
X-Forwarded-Encrypted: i=1; AL+hErG078mrxjzSZ+6wHy1n2UvmEjh37zYdxg73+BS0wgyoWrfON9xOsrJ6Vevv/vx/GFnNAnfUy2LFRg==@kvack.org
X-Gm-Message-State: APuU4Z+oKN+M3upBVaqlIdpxN1ZYvEicgg38wOyLxrpGfidRQbf0+eCk
	H2s1h0NyI/qephYkuvr/hKU804okMooT1M7p1DtRo6gqySx4/1blgFp0+Ywz/UlUtw==
X-Gm-Gg: AZFdTZcnqyoCxyvlQt87Mgv9BwrNw4rojCB31Ofog40pHiAMGA9+Qz+KNnuOHzlPNK8
	RnZURyM/CfneAg3NJodjnq55Kh/M4R9GTq/oJg9DjXS3YaZ51Q3usKjZfe6Wmjw5db1jbVWHuCq
	A/RLu+UeDvpsXIWGybr3m50iWu/m299Wvwhzsdqz6X0mpvYw1rOJFaR0GFWvzsrmHwMsUnOpU1n
	U7ctfY05d02kGqU5oXWTu1JpNfHpIG/4LiACaIEkyqwhjlDSNQIfTEg8ATh00xlOvUAOFY/mXJp
	etsaAP0UPr7JBmGtBR/SJkdGwbe5ApiwzVlJvA/iyWv5+oJp7KOb5cDkL0XMh1P9KFJLXWGD3Cg
	tvRYIBLsDTYvVi8OxDrQSzcqLFWKE100lKs/YerYOgiFL2CffWOnPxRC5WwT6vz+srRwuwAccOQ
	RwCPJrLW+ar9ef7/lek4d8klUwtKO9Z1F4BIPiMV+Fdvp4wTebijnniKl2NFkJ6qOhklZwdsV6F
	iOkWs+9FFV6nzPPf+I9eiQTRmeBYYfPLHYiXARYkOebcpmpw7wT3OkCmiEXMi27gYL2WIdudZq5
	YXIJLKBOc50clR7wv7MmHHQWm47TEqQXWrvbNGq1+iPg7hTjQ0KnHwMkVKOY9Qkp
X-Received: by 2002:a17:902:e807:b0:2ee:1fab:158f with SMTP id d9443c01a7336-2f03f167d4emr115089865ad.43.1795455139780;
        Mon, 23 Nov 2026 09:32:19 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f051a566f7sm45650825ad.41.2026.11.23.09.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 09:32:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 09:32:17 -0800
Message-Id: <DN2RQ7LGX224.3W3PSQ2PBHTJZ@google.com>
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "Tarun Sahu"
 <tarunsahu@google.com>
Cc: "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike Rapoport"
 <rppt@kernel.org>, <robin.murphy@arm.com>, <maz@kernel.org>,
 <will@kernel.org>, "David Matlack" <dmatlack@google.com>, "Alexander Graf"
 <graf@amazon.com>, <seanjc@google.com>, <jgg@nvidia.com>,
 <loganodell@google.com>, <arnd@arndb.de>, <dwmw2@infradead.org>,
 <baolu.lu@linux.intel.com>, "Bjorn Helgaas" <bhelgaas@google.com>,
 <oupton@kernel.org>, <alex@shazbot.org>, <gle.com@google.com>,
 <pbonzini@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 <kevin.tian@intel.com>, <joro@8bytes.org>, <kvmarm@lists.linux.dev>,
 <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
 <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
 <linux-arm-kernel@lists.infradead.org>, <skhawaja@google.com>,
 <sagis@google.com>, <linux-arch@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-6-tarunsahu@google.com>
 <2vxzse0rzjdn.fsf@kernel.org>
In-Reply-To: <2vxzse0rzjdn.fsf@kernel.org>
X-Rspamd-Queue-Id: BCB24A000E
X-Stat-Signature: c85yzngipc8s8h54hgkurd5qrfsfq68p
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795455141-762375
X-HE-Meta: U2FsdGVkX1/d48+rbc0G50zEqW0PblOLkpxLAaPYrDsbL41IxLHHbfbRQGL2GcDShpAJT4XQsyllsSHD3kKSXXOP6bK01uVFkfGbe2+590qn6cVXf/8R0eO2PaJ6FVQSYjIIDg7BQSS56dOcVvgsaiiezpwYSzeENRPTpMeNDpKLVkR8ZbCL98SlOyYZGOuOpChhJsik69fBD2ZRp4CH71pq3FEurouAq8pLzv+j480toc/MN8rKKvU1BdTAI69gt6wMVb4p5srs580hsw0k1H1CPW//RzZhjcG83grlGSbxC9pGGMQTWv6jqvXJA0h+tqiylrDDcTL+xjSM2VQBXVSc5QezsJ48X8PubIEoDggi8cEzZlJDwGjp2QH8TmDkIR7a1JRJj1kfBM0y2LSBCXjinX6ygOc2Eb/MHNk0mwwx3aX1cXzozE3jkO7Ibb83ijCVopHiM2XMfDD2qIFczuqvJYpk7aHlMxiGsyJtjA6zNJief+0/MZyvKHRlcRThxjxwJUEB5qOyeW/1k+g53eH5EJs/Xs/OaBbY2T04aEPnkGr9MDdp+6pvlHY57ULzZiVPaUlijxTCthsK7rMtvXMXHL1DwONXqTgB89pP9siBL5WZQjvN/EnPVRKzvX5cS4/3+FylJSFIQfSO6sLQ02e5Ws5tyWmcocrUCqEDKuDyQlwsWwvRio7yOfHU9veAEhAhBDTs/E+zRqtIgY0a8oin68rk2/Z3XLq38EcXYV5Y0lXNji6WnJJRpl9w1yDjboq3YHyY+o2HWI8PKW/MqemxamzKQDmrRxqN5SuevEdFcT8gY6qsqEBtoTIphx4j+z+5ANHK5m3TDVbT1btl6Mxh6Ju3TjFetz1nIOGsFvEH+K2kqNtASrtTjLrsgrggCJ3tlp2sM/FKX5mayoHO+C/hUrPwV0lPZdG47Gojzg/++UJV9XPaFsh0o6o+Br1KTdtCQmqqwubvVBFRKQ/
 CTsBPIzu
 8xOgi28OujKT6j6A/8+JGhv7iDZI3IuE+6bOx686BW8GwbLy6a2EjfeVyelUObdfWUzwdbPEUhWN+/i1jXKHwSroEaSO8xDJeVrIkCmcTeyctdP7vUjuWZItJeVuXVyfhy3p3OP3W6vGur/fIvRN7pXB0FjD4lmqYzdxsty/bCdxFUwriNSfzGTQPf6h433pTNGcyuYmGk+QWYDAsBPrfyjwQCJ05i5eOlgwiM4bhhseNAk0nQ5nRvistZrHaswSqp2knSRUtHBTffECwmxaiH1s2ZINWSPHg2S/ecJswKGCLpE118gMNQ1T/xG6t/XOUzz4ErGfIVgVMS+uL9Bva7wjcPgpj1Pa6HQ3KSx0aHy91cguDpSb22TOHxoOonKcWd6W94DK3rPLuLu0iieUbfYbP/pozRCGmfvyOB6j+LtwJ+ARgbZJlFSXj8QglZItrcsOPt7e6aJ5HQFAX/+aBknKz8s29XS/MHWTjs+QFVy2fnxVM0KEozwhauxiTsaFZKU2gzKBYKUF1dNNT+U8jzMYO/5DDXE8Io21UXTD6wbgXpoFFMCg201J0VEGj6pmrpEsgAimP7T7wsktFSGV1iOzzOPHjbq5BcmEJW9UfnP7N2DZzjyuGGZ1gng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon Nov 23, 2026 at 6:56 AM PST, Pratyush Yadav wrote:
[...]

> When we have all this available, I don't see the point in
> differentiating between optional and required features at the ABI level.
> At the ABI level, all that matters is what the incoming kernel
> understands. If the incoming kernel does not understand a specific
> field, the outgoing kernel should just not use it. There's no point.
> Best case, it gets ignored.

I pretty strongly disagree.

An optional feature is one that the next kernel does not need to
understand to correctly restore the object. A required feature is one
that the next kernel must understand to correctly restore the object.
Optional features can be enabled without any compatibility concerns.
Required features must be enabled carefully (IMO via uAPI) to avoid
breaking Live Update.

I agree it's a good idea for the outgoing kernel to check that the next
kernel supports all of the required features it is using, so the Live
Update can be stopped before the kexec. But that doesn't remove the
need for the distinction. The next kernel still has to decide what to
do when it sees a feature bit it doesn't understand, e.g. because no
spec was provided, the spec was wrong, or we kexec'd into a different
kernel than planned. Without the distinction it can only:

 A. Treat all features as optional, which risks misinterpreting state
    and corrupting memory if the previous kernel did not properly
    validate the next kernel's capabilities.

 B. Treat all features as required, which means no new feature can be
    enabled until every kernel it might Live Update to (including
    rollback targets) understands it, even when those kernels could
    safely ignore it.

Neither of those is a good outcome.

> The semantics of required or optional then become "can I describe this
> object with the capabilities I can use?". If the answer is yes,
> serialization succeeds, if the answer is no, serialization fails. So
> with this, KHO_MAP_F_MULTI_INDEX or KHO_MAP_F_DYN_DEPTH are indeed
> optional. All memfds can be described without these, they just will be
> less efficient.

I think this is a different meaning of "optional". Whether the outgoing
kernel can choose not to use a feature is a decision for the serializer.
Whether the next kernel can safely ignore a feature's data is a property
of the ABI. KHO_MAP_F_MULTI_INDEX is optional in the first sense, but
required in the second: a kernel that doesn't understand it will
misinterpret the map. The header needs to convey the second.

So I see the spec and required bits as complementary: the spec lets the
outgoing kernel avoid features the next kernel doesn't support and fail
before kexec, and required bits let the next kernel fail safely if that
check was skipped or wrong.

