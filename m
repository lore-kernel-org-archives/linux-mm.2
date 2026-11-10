Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483FF606A323
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dxV2frsI
Received: by kanga.kvack.org (Postfix)
	id 670AC6B05B0; Tue, 10 Nov 2026 11:23:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6481B6B05B5; Tue, 10 Nov 2026 11:23:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538266B05B7; Tue, 10 Nov 2026 11:23:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31D6C6B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:23:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3B1612078B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:23:58 +0000 (UTC)
X-FDA: 85419730956.01.9F6357A
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id D891740003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:23:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dxV2frsI;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794327837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mw9iOCkEBWkvxdLSgoJVCB6jT3T4ThA8jIPRTFH0lnY=;
	b=R9qf1+Sqn4MRd6INwFURUHwulOPuiX1I24mrjA5+k/ZmdTPAw3nBeGJ0IHWF7GVBz7YANw
	vUuhKR61NAHl19o0qCr8Zv0TCkbnNx3wvwB8YOMVUQs1JOD1nQQ7RlR5ASb3iI7bEN3zIR
	xQOmhGvbZP+AdXWbS9ryndVJ7u/678I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dxV2frsI;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794327837;
	b=dFnlx6TC1ayhFWttW5BfFMjC94Z+J2rrsAngb/sCIwpQIklpWDAUTLllNJ5koV2a1EKEXY
	dauUvuLekgWxN4ZcUPD2+KzHBjNsnQnCLjXcJdsO8tE2O6ICbo0mU/3fHV1VnTtoOuE0dI
	VAcerXOZS5XBeKGrGWLTKXRwnnYwWks=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso13222845ad.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794327835; x=1794932635; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Mw9iOCkEBWkvxdLSgoJVCB6jT3T4ThA8jIPRTFH0lnY=;
        b=dxV2frsImmwMXd5Gggk5zAHVaVOHhwafh9966fX1+mPzPidk7gh57+NF0qY3N3oUT6
         /8/VdhNwoxKvCBmwzyMKy930a1BWZxMeNAwTfanS4KyARqDcyo+HpCTaaYt6r3369FSP
         PZqtn4ypDqMxBPHpvTSpifYHdB+87Io12m3lL2AHOdmqkMMV0zxBSRFZ5tqBLx9e31Q3
         jrSPgXfXE7jt1PqFjh4s8Y/ZR8FAcmMcoJ8jKICh9u5tAit1Hr45lQy6kQDsyzLL97BD
         f1MzzuZNxtv1STJcgfbNvB0BU5Qejzwcb1+rJpp8Z6a3qguYXIbL+DDKNvJh3m6EZtur
         vW2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794327835; x=1794932635;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mw9iOCkEBWkvxdLSgoJVCB6jT3T4ThA8jIPRTFH0lnY=;
        b=lm7o/xH3t9n+oYoW7tDZ9/ucoVttldm/kE/PN8vNRY0h0Ba7Yz9MvJ8UbwLGmohVkk
         65u79DGf/AtlzObOm09K6bc7mW8l3tO8fUYRRLKdOqFV/ghtnosc+aQuA3RFwyNemp39
         ODJ5Ol9wOhOom9fVx9j7Mxygvti39XpHf85GClZj82qW0PjiMrVSLRsonhx3yCy+D33g
         inWoQvf7cu24YsKj3jOckCHoljeGoPCNKPg7QqDeUBFtYg5RMVLFsum/9lVQ1ruCbLl2
         RrMfGVt/50X20eXjUq2nlWxSbZskYUsbbXtj7+UTDkcYLBOyD06/ru6y48TkkLRJVqIx
         d9tw==
X-Forwarded-Encrypted: i=1; AL+hErFy1jVblsm2xlv30NFJX5/EOiHedrBpWFUxJlWZwfAZ+fo1ivq1ADpn6Wkrl2NeV27yz6WS0jwj5A==@kvack.org
X-Gm-Message-State: APuU4Z9Ld3BdLAwNgEJ2hp2K5IALmuAzJqwZP6VTcO6GABPw9yzwAvs8
	CrLfUi3TVTNdUImtDxVgq8LrsY+oPjsyKRJ481sKsAdHkW64p4AqzOmdZ0W7Kj0FLg==
X-Gm-Gg: AYBFou2tP3XWzqOJBUjZqadFDIPuI3RtU4++b8qX9ELr/ghIoeegFQnVL+Z9Ij/4c7g
	L4Tomrwf9S99VSdyXGZSM4hnmsSWQgrTpRyGgzqdLbiZcYv1SttYioDwfW7ifupmlgEzpnssfuo
	htVWgXB6wd2aDHXyWFutg4j8CV11aQzehlxPPbA0gayD5iVSJBDaaevI3VSglKn1Jbsffffyjre
	koY5gvXNvEV2m3Y8yakaf1KqOYP8bZS3azGxW1KuT5wKmnngbyxmTLACJu5MJ4mOSV0wfxa0JCs
	fk2sM/JUtz7V7SHFX4yGMXXRex2VHSZZQgfH4RjO9GWFXBjJiNshMXpJVUzqXUHlPXpIW6c3kWa
	7yb0cuH4C0NOkZ9vSZGurgKLcizyPdWIuVfiKlmB85rQjPk3+elS1to1rrRl3i4J6mEiKwyD/ZB
	MhWRTbwvu475YfxX/iSSGzjAA7PHASYkdmGyHsDc1MBNog+8zEWOAlhsKNFkS0FQ03MTYloweML
	kxH8fBNHK3KXoY5XpWBiM4p5sMRMsQA8ah2J7B5iQTBt2RXOnlYuPlwNOHPtQsjxLfIND3WrDbj
	a9LetmeBIEntpFdedPOP/FEobG4fZoATF6doze+WQQ3wbqVYnYcoDF6FLVRLMILA
X-Received: by 2002:a17:902:d4cc:b0:2e8:18ca:5f46 with SMTP id d9443c01a7336-2edb9146ba8mr28990585ad.14.1794327834955;
        Tue, 10 Nov 2026 08:23:54 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6d7d964sm11306915ad.32.2026.11.10.08.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 08:23:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 16:23:53 +0000
Message-Id: <DMRO4QXXB8H4.127C1CPT3RZ18@google.com>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 16/19] PCI: liveupdate: Add feature header to struct
 pci_dev_ser
From: "David Matlack" <dmatlack@google.com>
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>,
 <seanjc@google.com>, <jgg@nvidia.com>, <loganodell@google.com>,
 <arnd@arndb.de>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, <oupton@kernel.org>, <alex@shazbot.org>,
 <gle.com@google.com>, <pbonzini@redhat.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <kevin.tian@intel.com>, <joro@8bytes.org>
X-Mailer: aerc 0.21.0
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-17-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-17-tarunsahu@google.com>
X-Stat-Signature: cr69myhung8ytk65p54ue4kun3inih1n
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D891740003
X-HE-Tag: 1794327836-755300
X-HE-Meta: U2FsdGVkX1+F9FpnsGIgonONYasEWdsP8syz/z5PDrF4w2IoBTbujzVBSrQe/hL9LC/UNTebz/msd+NqugaG8M0TbKB3E0zizHgsALxxVLfKcduhQNAsh2vxXb/q0q/YTe7K1EdBtBLLe4yOnURRLuGZLGPbLJtor/I5QtJcDXKeL4qARWdli+LdT+36Vaowdm6G/zVBV8bDRB3sMa4m+O1YBd9YBEyXIVjRKTqloV0sMMLTkL8/eEqFLPu/eyPI7n9tvkYWCjnfEnMtT2kgWoDVmXonNlP22a72V+19kf+6uCtlmJ0z4nYGXANktSEyKbEp7N81ozcY6mxtYyk8uhkJXb861r0CWtvRKnhwcYXjrX8oziDyqktM9l9TFIqKUmb5Eod/hv5zpt/eaxjF3lNuFNyRLP6fTqsHd7y4I6TS7pxsY+6C2GKbo6vRMaJvEsJSGH0MGynap1vClUeRutxhNN1KokBuE9vz5TaGl11EXD/EuTUZX/47+iNKTbPOQkC188tWA42LaXA0rJIe3s2AVpJi767K5ee6tvQRFrlI9oRAtI0hdPLqjIIIdCSqhNvFq+g8HbCV5dl8c9n6YsTAqNHiSV1QhX6E2fcKFOmbRtiP9PD0g/Kl84AehH65VflLrVL5AdeSWh7TNc2A2BgGhSUPtrum/rZAMZGERjzpv8zol65jKWtW8oSAxq9r9qJyseGQgkoaWJzetiXPi/oExs4LDfLGaKr+YXqe3Yl9cAmoG+IkJ01A4hlrGc3MbZLh4F/V4N8Z+HlRpuL6QWHPv4M9lr9Z9lXS4uWcpu30NqDmUXKWDhdcRcfSwukgluQ/CUqP12FB+UCAUZR37TN2KHBz5VGuYorOV7veATzZIKcaHfcdLp2w5MXYRsaGkTV+hExPqdCnbPBVEeFr/YLt34AMsESSpEEkkqmGHc0FvBcPWTaXo0sXAQ7AR59gv8snAogWGX1rl/sQEFr
 ZpIcQvO9
 GDOlVH624Ktmhmv+XZnzBoSTUHL/CFdc/J92bkAm14qOZPZkAu8vdUOvxH8doFYfxBj2BZg0qW59u8I7RBr+fx5YPvHSMtS2o3f//Jvv6NRf9n7LvCohL3r/r797vf7xklJBdIRRh9S98UnyFgGoD/GBxCwtFdaZz9yEa4V1C8iN+QBjbp3r0K6BKiA2QtrGoPoqeIibEIR15bdaHvGTZSbQlzKBsbj7UyXmvkyAfXCZWCFMYY/MG4A3xEi8bPRVIveh2omc80MFOaaSZm1n8Yd4v+efhMA7/3AyYMj3538dd5xJ0I3aK+h6GmCONaT8XjED4QhqMf0uk163n4T2f9vfJNzhCpo6ODvVDiLhQVZNTjNMxerTiKYLOaSu1DsN0JVArNXhKPn5gU6h8B8fDR1TRK/SG8tejvDcVYqN+FRI45eceAXv3hlKccsO2eINJkPsfQr0dFiFpyEY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
> Precede each serialized PCI device entry in the PCI Live Update KHO block
> set with struct kho_ser_hdr via DECLARE_KHO_SER so future per-device PCI
> Live Update features can append fields to struct pci_dev_ser without
> breaking compatibility between adjacent kernels.

Elements of a collection should not have their own feature headers. This
applies to patches 10, 12, 14, 16 and 18. I raised this during the v2
discussion [1][2], but I don't think it was addressed.

All entries in a KHO block set are written by the same kernel using the
same struct, and the block set has a single entry_size, so every entry
header is necessarily identical. They don't convey anything that the
header of the struct that owns the collection can't. In this case,
struct pci_ser's header can define features that describe fields in
struct pci_dev_ser, and the PCI core checks them once before iterating.
If a feature only applies to some devices, the field's value in each
entry says whether that device uses it.

Per-entry headers also cost a lot for small entries. struct pci_dev_ser
goes from 8 to 16 bytes, and to 24 bytes once the first feature is
added. Patch 18 does the same for every preserved memfd folio, which for
a large guest backed by 4K pages adds gigabytes of preserved metadata.

They also add new ways to read out of bounds. kho_ser_payload() trusts
nr_required/nr_optional in each entry, and nothing checks that the entry
header plus payload fit within entry_size. In patches 14 and 18 the walk
uses each entry's fhdr->size to find the next entry, so one bad header
throws off every entry after it.

Instead I would keep struct pci_dev_ser as a plain struct, take the
entry size from the KHO block header (patch 2), and in pci_flb_retrieve()
check once that the entry size covers the base fields, plus the fields
of any features set in struct pci_ser's header, e.g.:

	entry_size =3D kho_block_set_entry_size(&incoming->block_set);
	if (entry_size < offsetofend(struct pci_dev_ser, refcount))
		panic(...);

That also restores the minimum entry size check that the v10 PCI series
had with PCI_DEV_SER_MIN_SIZE, which this version drops.

[...]

> -	kho_block_set_init(&incoming->block_set, sizeof(struct pci_dev_ser));
> +	kho_block_set_init(&incoming->block_set, kho_ser_size(pci_dev_ser));

This size is never used. kho_block_set_restore() overwrites it with the
entry size recorded by the previous kernel. Passing this kernel's size
here is misleading: pci_flb_retrieve() (and the LUO session/file restore
paths) read as if they iterate incoming entries with the outgoing entry
size, which would be a bug.

Incoming block sets should not take an entry size at all.
kho_block_set_restore() should initialize the block set itself from the
incoming block headers, and the incoming paths should drop the
kho_block_set_init() call.

[1] https://lore.kernel.org/kexec/atl6K2Juy6Bh29lh@google.com/
[2] https://lore.kernel.org/kexec/at-8vkVpN2SF3XgB@google.com/


