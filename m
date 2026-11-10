Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE136606BAC5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JH2Mkk8y
Received: by kanga.kvack.org (Postfix)
	id CD0726B05B6; Tue, 10 Nov 2026 11:39:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C81536B05B7; Tue, 10 Nov 2026 11:39:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49416B05B8; Tue, 10 Nov 2026 11:39:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8607A6B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:39:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2AA29C0921
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:39:37 +0000 (UTC)
X-FDA: 85419770394.03.EA7E6A6
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 45A78A0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:39:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JH2Mkk8y;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794328775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KprtAoIZUPQy03e7SCEXrO4BhVdW6Lml6VdK8wkVG2w=;
	b=vdz+IlO0KpdvkHMPH01CFc8Pk1kIwof0IH+hDO4jDR4+jsONfuE8oZutA/IQh/xpycIrx0
	p8RwDMokF0l762BhURm57LwDEXtmCNBMz3MnKfKi5cOyqYE1LfYIzYWeK5SzVm38yy1GZR
	WaF2376AGnNzbT7YsOh5LcwcUPMvXDk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794328775;
	b=urOhw/J6NYtSjMo9GN1tG4s3BPikR968+xTOo2ajdhGxrGQp+tcfxj/PIwYBUBI0FIfPM9
	ujGQkmmjssp9oAgVa78B2ATgqllKz9OyEJSoYoMh0hmmo37G5KBcaCf5cZhOU8bOZqcsv2
	yDenvbUVWQ85zr0S9Z0SSqEsKPivvC8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JH2Mkk8y;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b0d0b80fb9so1364225a91.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794328774; x=1794933574; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KprtAoIZUPQy03e7SCEXrO4BhVdW6Lml6VdK8wkVG2w=;
        b=JH2Mkk8yK1xwBl6fazIbKifgOyu7RYWrKjMJwjptzJqbFspCUJL4ygKdzJPXgt/1RL
         7mjj15HtdaGRLL8t4fAWkKPFPO2laz3vGT3qPAcMhAI6TSnTyGHayoQrnicvxuNkGlL8
         18BdO//GvLL5w7OD0uCXiEFmOtX90EJEqo3rnHhi0zIKNJjf8LKC98bYFk6p2CCsm/QF
         RXoNAKGy/ELpEs/AEBo6S/BpNcnkHCuJJIpL5oFpI6hNKq1hS2FufReANk0+3F/eGs66
         PwVmlFb1cyBuXhHF+M/lp8K6qmSeiD1jBIMP9u/nsxgB8sOpJgSniOdIUBcEOe91h1r4
         0gDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794328774; x=1794933574;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KprtAoIZUPQy03e7SCEXrO4BhVdW6Lml6VdK8wkVG2w=;
        b=tX2rfsHJJBtDo5p5acOS71h5FV+3sgPfGXwP1SrOPRw08iVK5HiVxBVaalJHbFaUnU
         iUnUdZszXltN3ohKVaZqfDKi5/K5SyMi2HqQtsMYaga0w9MSVPTojpfLHFtxo+fXoV2l
         MOpigaFSUKoVoBsDufKYBJjuctAZFWvQ0zHoc9ICd0K5h1Hms0nc7Qty6d2McsyYZiCS
         vr/ckijsEwvpfEGUlnI03iWy4xag6/enApxkyXNOTcQ2wSTxqH9rH6buc4cybqBk4XP7
         hPWAnn1m8rEQmxhlz4Oy+jr5raLTyNvRP7pIzw/Wrha237yg0EnJ8EtIFsD1+isA0YCc
         YZkg==
X-Forwarded-Encrypted: i=1; AL+hErGlFDBEpQ5SGFJmCvr9uHvaO4LIXzhsdSeuVorxZKNNswREM4LxzL2EL+Gajj8wgUDlDzipzw1dDg==@kvack.org
X-Gm-Message-State: APuU4Z9nj0Kk7bMTQDc7bzvYI1jQg9Zs8mDVcrsb1nXwIOc1iJ4Q2QxT
	WFw2s/YFRRtiQjlg7nOyx8ueHbCRBEBf8wlmJhJ5sTcvgwHNXPqwN8gIFEL/lHARXQ==
X-Gm-Gg: AYBFou1/ujHaLAtBN5N3moGuVK8r1pdNXxUsM3QfR1AOZKjJ59XGVXilHI9SYNTflnn
	ZEIiqhrGN3l+yS1h6DvvjIWSkgnXO3oI7pTn7kGqjGlOX56sec5lI6aISxHN6vhu7RCFkZ/sVkS
	yLKsNUejNOZXFu6s2WgkhVqD7ZpsOnw9mfOdInd+RnxtCCu0yLXOX40nsC02XXOu7NOwesy5Zf3
	iM4eSkStoGZSdrSON7ygoNrj2ERIx7Vgvss6bd1bA94bQtQrLKJEBvoTdFxPFD2PCTczGe2IsMe
	B3tRKlyBzC3AJKldAoRMWXp019XyDE02eJKgUkS65G5cJsEzn1Vm9ZIphtzIz5Sjmbs1ZywxFBP
	E+W41vDEskdHdeveUWNseR+uWLokIBotALcGAK2zrUKk7l9aFRnhOOYfCEkpBT0xOzKv3E0XA+q
	X60McTWKYY8vvGMH/zBoNUmG/o4SiGQs1VzfIBLw0s8dtKOhqK2EOh3mg+BU61R1EvQa9JCTSKq
	M9r1IG+3rn8nhuoV2+MgfpyPb6myMArr/SdptVub28rQ/pqaZPldk6VdE/sbf+wddSsYsTqqYsn
	/uek3tRlcLdTCZnqY2OGI+oGZ4LFDSgTqAEYAA9+T3C0VLmDES8ZGlFpJYRqFWj3
X-Received: by 2002:a17:90a:d444:b0:3ac:9d83:8861 with SMTP id 98e67ed59e1d1-3b166e3c924mr3152630a91.67.1794328773194;
        Tue, 10 Nov 2026 08:39:33 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b168a8de09sm2418499a91.0.2026.11.10.08.39.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 08:39:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 16:39:31 +0000
Message-Id: <DMROGPTP93G4.13PA42UFKZJNJ@google.com>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 15/19] PCI: liveupdate: Add feature header to struct
 pci_ser
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
 <20261110050202.529473-16-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-16-tarunsahu@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 45A78A0003
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ymhijcsw7jgzo9ku79yzy69f1fbqbtsx
X-Rspam-User: 
X-HE-Tag: 1794328775-417477
X-HE-Meta: U2FsdGVkX1/+srPsDUn/hhNkMnosF9rBDkkfqgd2vAjy0ybBy5unIetKXoI2OO4ERqcQkDsdgAl+VC2RgWVI9e5oZt4E0IJ8azITDrPCnMwLUwh0o1fXbSuwEYbSOWrw75qNHklQly5TFXUFo7wRI19lcuzKNjngjt3NsZnDYOlILjxRU45K9USXgPEzrVDjvvabtdWlGAHUVyRbmcmQzYPx9qEcrXcuTab5rq6T3zoKoAd+uVUtTPh9xALdSieBQny0j6KmGj0AsCDvikHZP8noctNKPP74P7X5Rq3vP/6rUS3JcMzCpVJyZWI242kI7sTNHzWsJ9humL4OkdzqgpY6wvk6SiQDOKO1RJJQDK17lQVCjhMpjlef8Yq6OKJeDocEzjnehCZPoYhwT5vzqTqimHoozUncb4i2vVSI8HjhKo/iFM69HpZRdjHEVqJE6tErmR5Wx5fLXmMrlUxhB2Ok8xrmGH6+BKdKISkP0G1+uYbVyIx1BEUpxkcnVN8Jn7y+VU18Kvb0cTW+iWsfUcC+0lkSFYyL2TJS5JfhwpqHIi/iF4rECATYcRQzqrKaPa0hoI9jSIbALJZsTwO8vryqT07YgQT4wDTowBYMdwLyTf6/m5x4gYEUZZ4C2S/w+7ZNtnd/PHF1wp5r53NNQ0PVJy3dfXilaWy/j35CoauD7bnO2z+RfUTXJ2vMmIjnLjfs6l817vt7PSEOCnzD5EW6nO3gUwWuHKywtHC6zYpj+gZt7MDDQb/HsVeBB54Fci+vAyK04GA2DOQcA78tUFNLxlQjwjWSZuSbRfDDLLZRCShjDT/htToVEjRUK40FoPY9t2zGXVZRCEgrfSXQnI1SAqzxdrhARb7EXLIdvxwWo7t8uSVllsI/lP5IrCs/u7ICQkgklZCGkXsJAxz8KLydJo0RsGENXBrPlJ3J3z52+jQpR1no4FfZcrtM3d0UzPQD3R0SHSKJLfSC6is
 usgku+C8
 rx1G4H9j85FIuJlK6WijppBpTSIOVS/yBFK8sBsqr3ibuodq2KSCn/Pbw6k2luQc+OO+5ZwM46xiXce05IBCFf25e65nLIcG6IwGMI910d6hTS0pl1zTWw3xvR5aGJ7jnXu/K+Rax8+GMXJV0mzyyZpMXAU1cJisWgHBCH+Y+kUEPBGY4wSjkDovrBtco8NqrPjCguUsKeXzKSFX3lrI+0yQ9o8GHzibN6RIiRYyPnr0EuhyvUCoHvnjtD4HqDxDUzSlQN5elNCqickRNdIlwU+IMi7BWJCuT6FSdavthsk6Kp/bbN/qnLd9uqnGFvtj7lEfleuOkWU+gFV5nxYA81Cf6fHxt06Nwuw27qkC+5Q4Nbn/uSnZ7t+zGgWix22iOa9GbmmUA5tTEMWKFO19InlnZjuIRiIvuED2o1FVm1T7xya+upPTGxOIWSLmNk4V//2P+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 10, 2026 at 5:01 AM UTC, Tarun Sahu wrote:
> PCI_SER_REQUIRED_FLAGS_SUPPORTED. Remove dev_ser_size and
> PCI_DEV_SER_MIN_SIZE so restoration derives the struct pci_dev_ser stride
> from the KHO block header entry_size. Drop __packed from struct pci_ser

Taking the stride from the block header is good, but dropping
PCI_DEV_SER_MIN_SIZE removes the only check that incoming entries are
large enough to hold the fields this kernel reads.
kho_block_set_restore() only rejects an entry_size of 0, so
pci_flb_retrieve() will now read past the end of entries smaller than
offsetofend(struct pci_dev_ser, refcount) instead of panicking. Please
keep an equivalent check against the incoming entry size.

> from the KHO block header entry_size. Drop __packed from struct pci_ser
> and struct pci_dev_ser, adding an explicit u32 reserved field to struct
> pci_ser for 8-byte alignment, and bump PCI_LUO_FLB_COMPATIBLE from pci to

Please move this to patch 1, which drops __packed from the other ABI
structs.

> pci_ser for 8-byte alignment, and bump PCI_LUO_FLB_COMPATIBLE from pci to
> pci-v2.

The PCI Live Update ABI hasn't been in a release yet, so maybe we don't
need a version bump?

[...]

> - *  * The size of each struct pci_dev_ser is recorded in
> - *    ``pci_ser.dev_ser_size`` and is never smaller than
> - *    ``PCI_DEV_SER_MIN_SIZE``. The next kernel ignores any fields beyon=
d the
> - *    ones it knows about, and must handle entries that are smaller than=
 its
> - *    own struct pci_dev_ser.
> + * Preserved devices are serialized as struct pci_dev_ser entries stored=
 in
> + * a KHO block set. The block header records the entry size, allowing th=
e
> + * next kernel to step through entries using the source kernel's stride
> + * even if fields are added in later versions.

Please keep the rules for extending struct pci_dev_ser. I'd say
something like: fields appended to struct pci_dev_ser must be gated by
a feature in struct pci_ser's header, entries are never smaller than
PCI_DEV_SER_MIN_SIZE, and the next kernel must not read fields beyond
the incoming entry size.

[...]

>  struct pci_flb_outgoing {
> -	struct pci_ser *ser;
> +	DECLARE_KHO_SER_HDR(pci_ser, *fhdr);
>  	struct kho_block_set block_set;
>  };

I'd keep the ser pointer here (and in struct pci_flb_incoming) and add
the header pointer alongside it. The header is only needed to free the
allocation and for args->data, and keeping ser avoids sprinkling
kho_ser_payload(outgoing->fhdr, pci_ser)-> throughout the file.

Also, please call it header rather than fhdr, here and throughout the
series. fhdr isn't obvious to someone reading this code for the first
time, whereas header is very obvious and clear.

[...]

> + * @reserved: Reserved for alignment.

Please document that this must be zero, so it can be used by a future
feature.

