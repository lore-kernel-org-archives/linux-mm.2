Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49835D6ACD7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1AC66B0088; Thu, 18 Dec 2025 04:30:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5346B0089; Thu, 18 Dec 2025 04:30:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7D16B008A; Thu, 18 Dec 2025 04:30:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0756B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:30:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E7FB5D31C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:30:39 +0000 (UTC)
X-FDA: 84232071798.10.5C47EBD
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 25B3C1C000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:30:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NpuoX2PZ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766050237; a=rsa-sha256;
	cv=none;
	b=BKO2g+KBfbDDsKtYR16YH6UqV5YTCC+3M0QtZiw/YbNuxJfE2evsqbQ88E4CWPw4il+GSY
	uTl/hGcd/lEM+g1G9d2nlLDKqO9kBMqVMzkNyA4d4S+nScUzQojetA/DZkDger0X47r4if
	YE6WGcNxkMfy6+8r45XDiKHNHppqCrg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NpuoX2PZ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf21.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766050237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=auj72bQKfXEBr2u68dWzZijoBsCuhcqMu/4EXNR4iyc=;
	b=jxindrgKYd9pIDxuSssWY3gEkIAa0mUi4eAprS5uDlF2bro0aWQyLUPxIcQhQ073G++Mls
	myXnfnqee/VcGZypAlaoHVoZUwZFv4pKI6tUIG9yeld1OC7n+mTx6hGzrSdodkzTuzeUiw
	89eERUbvmf03Dlf80MlblIHhGwMGO8w=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-430f9ffd4e8so736128f8f.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766050235; x=1766655035; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=auj72bQKfXEBr2u68dWzZijoBsCuhcqMu/4EXNR4iyc=;
        b=NpuoX2PZzAY1sicfIaovp4FglXfVhWodHxH2oCU9bE6fRkMheGupJHGdibaYKkccSj
         E2sRFmxfY4xJyyMRwUTTWxay9tRkga7xiaN2aR5sWk0BRUnbInhRhSWAOHc7KXRA8fCZ
         aPB4xUb7n3r2PL4HUXfSs5u9YOrJcm3JBeOgQQQHVaFkrU36KhR64U3po1GeghfTiCTa
         rJkMJVtTNRB8oAUq5CmNEb9RB5YURiPDZsNsf+Gq3t8u2ZqThf7bSn6g/KNRSBc3l0iE
         Iasv2B0fhB4izPJ2NLSrki+9M3Uu7OhDaR5/DarQk6gKodaSQh+qFkWVdH2jMAnsHPlQ
         toKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766050235; x=1766655035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=auj72bQKfXEBr2u68dWzZijoBsCuhcqMu/4EXNR4iyc=;
        b=Xs9rI7j6hMXenHg01/QTqdye7MmqFdYCQ/g6cBkqnC6ctPC+qtkdrIL1WuhFk54QSn
         EWrpVfUObFMT1xFNwoaZjjW/nMuqvWFpT+aFhsSeKm0OmBScHAd6H7rFVp5Z3PQTzeDy
         fx45k2IuNnEwbj74T5fI9r4lWJJMBmLfbq8TAlLKpq1qdDU4KrThpMLwz66E9bfc0Kuc
         zMUABz/BiSo2k04hodnHmNkBfzL7JIbZgVVvJs1DbvYiqJ5Wsg7uWBnFOkEh2vagrTAr
         rhY/XzjpzYn3+rm7v5bQYUljew/mSob8EVWSNOOp2Y3w9MLGSl98A++IiUkxL7nfj7dx
         UBJA==
X-Forwarded-Encrypted: i=1; AJvYcCVHZEFZbl99aEQG49FsUILlGyQuPM7gBZbaIxZBKr7/J0dUgRnml9AMR8P/ajl2ipu66XW/2ePAOQ==@kvack.org
X-Gm-Message-State: AOJu0YyMYFhRJt8Hd7L5x6Pqh1Ob34ni/z1ZCLELq1GSFyx+0bxFRQPB
	4DmcNUayxlQRBgGPUDTMA+4jxDqtTp6tOliheAY/kHWM6hZH6wcRVKlgxt5ldoGiATo=
X-Gm-Gg: AY/fxX6bnLewtnACo4IjPIkKu+nRHmRBTedLw4ujEG2/iUT9KsyvEO4XWr1dHLumYRY
	ZRN7xlisjLnShKXCFxXmAxXQADDTIE6SEEc3On0L0WRWKKgXnJgjIOpZM9lN0d/7w1SwCBJJcYe
	Cn0Qxf2oLo0yUy2aw+8pzzlRUvzobRqnJ2Zf+kTKuu4Opjm5vQ7/0IWp4TUEBV1gaDE/TXPCVLb
	HuOQpNl/RtTUh/qcbZO1buDHaJvX0JGRJX76YLVg8trmsWoc3w5XdqbDqZvjXApiIg+KQg7hGGi
	aCYMKpjnvo/SDRBOh//aW21wqhEPIS8d2mwGB2RHwvLnWo+72hivGc3JKyYto8qmL51DWJIwP8x
	5VynbrQmWMKvvZzsuSwhUpEAgRJqftJ+4MZuPmqXj0IDSPOxboAxvDsyIUuo+LWRSdTHgExxFX/
	wwNDmxOBkr9kuXjIY8GSnCxdz/
X-Google-Smtp-Source: AGHT+IHyh7gnIimLVB/hVii5bUcInWlX+sJTJLBC1+RURn9zto3ffEvz7ijXdEVgop3qQY9DVJKifQ==
X-Received: by 2002:a05:6000:2407:b0:430:a803:e49f with SMTP id ffacd0b85a97d-432448b7f43mr2778068f8f.15.1766050235424;
        Thu, 18 Dec 2025 01:30:35 -0800 (PST)
Received: from localhost (109-81-80-251.rct.o2.cz. [109.81.80.251])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324493fe32sm4092572f8f.14.2025.12.18.01.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 01:30:34 -0800 (PST)
Date: Thu, 18 Dec 2025 10:30:33 +0100
From: Michal Hocko <mhocko@suse.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com,
	song@kernel.org, yonghong.song@linux.dev, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@fomichev.me, haoluo@google.com,
	jolsa@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
	rostedt@goodmis.org, catalin.marinas@arm.com, will@kernel.org,
	ryan.roberts@arm.com, kevin.brodsky@arm.com, dev.jain@arm.com,
	yang@os.amperecomputing.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while
 stop_machine()
Message-ID: <aUPJuZINNuNxddRX@tiehlicka>
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
 <20251212161832.2067134-3-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251212161832.2067134-3-yeoreum.yun@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25B3C1C000F
X-Stat-Signature: u4ccsjpdjp5uo3gnh1tbo4nhky7y18hu
X-HE-Tag: 1766050236-566686
X-HE-Meta: U2FsdGVkX18tgDJGADwxKH0MjPLuxa8MgjMTxYsC9Fa+anKkQtaIN1wcIQzSktcpjb63UJR8cUYp7d7htvhin590O8nOGYpCGiDOXKF3FJ8g27V4uzC+ELEocrksaZQhCPo2MYh+DaBut/B6Xj/5Xir+N1je3ZPydxWHPbqTIxWN33n0SwUizADY1SSdJa6YT9Skue966oTt0fV5SKv3WyvabPPVd06uI9P29CLofRv1xKnOwRltNGSl5KzA4PDZWXkhi/WmqvoHuD80uMU4Hxp5eUmtn+gNENKr6O3iAQv71VQ4J9aBrnqL9ObI2i/tMLbrudZ6+8gnYojgFAHZaJ7BqqPkx3iC773mZDWn+bdCYilK9mwNPxxcijk+kgWJiomcEhxDqEnNEhti087z/LGx3Nc79s1jSk/HRHlclWqGcI7C5dL111ztTz/XIRva6DBD4QSt9OUxzl1zo+jMiDNdC73CUMLjzqxPpJp4dQJz5GP7BmJ9w9ZNAoaMrTAkmLdzbq3hqZlR1cMyyA1I+iXRJDgi5MBhoh74zlKZCy8vs9z/pnUaQW2vc73RBxoLp2m1CvwJ4PVDOGr83eJxWbKC+AziCpbMmmuMJMfXtz9n2qw7T1N2rYrXRK8dbnqCR63pLECjPvR3T/mMR6ndJalINQef9v4wtpurz2dfFjfqrX+xc42a/c9Ezd2fzqFaY0XE8i7Hm4kpcHbqCs/sc6LvE65PO8Y3MvOEp37kvH+JfWogiNro5FVgV0921UQ7FrhP/EdEW92fGm7yt2AWpzrM9qVef62GNaFzZ4lyTd7Uc9H2UnANMT/wcO2+JHRg/BIJ1GFzDlPm7YFLUMGUgXUsuGF3fu0fcpVGIolFrsk+ps3SUy26LXCuijOWdXE9pwG+SqlvK9Uf7HNf2I0VozR5iYUvvC/7qI6rP88XMH1Mij8UGORxmIFke5BDX4CW83/znsV2yE96PJl0rfB
 VjZ8j1OZ
 Ez/V95OVgptXUT16jG/fNfmdx3lLLrFoFtLfOyBaaoozi7ajQOy2VinePiZM7SEkjHYQ7QeV9EWwjR/+wGQoDNhuzCiJkBBjY8IgRjegXstJnBBbwa/jtbEhY1zV3o5pKfrbYYoWxT+Qh7xTZ13OjWjSfQuQafHauwgu/dPND1018QisKDk8i+kjTqUB0WptSd0xC1sjgFYL5vq5wySemfAC28VISdR86yN1YSyIOSZCmFAcFFx7OaPKlTNGFK1Qn8t84UD/Rf261N1E0emrSqIQC5dB9OnM6KJPid3QEYEo37RAs31IwbPUfM3H6/FwxxCdgIQTrcZapxJJJOw3/gpWUWLDVCCGtW6FGj6JpewX7xCTGS0vrDJf+f2cfjyi5n1XYLT5X36RdtxAFUVB/g+y6lTAkjwe74PJr9vE4HGdQcJzeZ6C60dTvuGlcEc2y6ZVZ3y/1qjbhb4dfS9cTtOLGCUSPdf3brNtj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 12-12-25 16:18:32, Yeoreum Yun wrote:
> linear_map_split_to_ptes() and __kpti_install_ng_mappings()
> are called as callback of stop_machine().
> That means these functions context are preemption disabled.
> 
> Unfortunately, under PREEMPT_RT, the pagetable_alloc() or
> __get_free_pages() couldn't be called in this context
> since spin lock that becomes sleepable on RT,
> potentially causing a sleep during page allocation.
> 
> To address this, pagetable_alloc_nolock().

As you cannot tolerate allocation failure and this is pretty much
permanent allocation (AFAIU) why don't you use a static allocation?

-- 
Michal Hocko
SUSE Labs

