Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC03560A2639
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=LgpdDc68
Received: by kanga.kvack.org (Postfix)
	id EF48E6B00EF; Tue, 10 Nov 2026 10:12:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E772A6B05B1; Tue, 10 Nov 2026 10:12:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66066B05B9; Tue, 10 Nov 2026 10:12:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4E796B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:12:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 580EDA095E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:12:27 +0000 (UTC)
X-FDA: 85419550734.16.75D1C28
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4916AC0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:12:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LgpdDc68;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323545;
	b=Q79kN+tkF7FwI2MmcV/buEvH8EuYzRF2UJL9NZVDGOUIx9Fxvb4FFnfkykwbynGs92P9ju
	xSIc3aPCRMzO1MOecDOR5RmmT5bIb/y0mjpYugMJzUBUXwy9bzXnXWlze9uf6Gyif/So/s
	F/bQvzLds/HFleNq2RyhB8eRN3YPKWQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LgpdDc68;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpEwWty65XIKqwE7JeJ6p16oyvStp8N2eZzOQMIZadI=;
	b=8MsyKUu7jZPUCaxfIgpgKgUur/6Hrac+mgYAPkipLFq3No0UQEEKaTUkHdUJEzXbsVmsPA
	gUQVKoQbEcsieBgJ67r2jGjD84Wj3DLojCqxQco8ODoe3AQBt8V4skGxtdo9OONx5OnTw6
	dGDCdlxbSibfPSqNhfZMN3SKZqYV0PQ=
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5eafaeb8684so673007e0c.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794323544; x=1794928344; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KpEwWty65XIKqwE7JeJ6p16oyvStp8N2eZzOQMIZadI=;
        b=LgpdDc68V38v25H+7qXHABbjAvcJxHtQu80KZjrCydlz0hWgF8SaSUy0AtZQLHp/6h
         Kny/oOPwcStbkoLQSsFMfHirIbKZRupliTslet3Krw/7t9kEAVf96fNd88eujuhdEQ7D
         uhsVMmkwcnT0u0O3Hdhz7BDuHN7nVhy7mVfdGuz01DpwjVicT2328+6SGvKnwJ9BsMjC
         dsrnDVouV+7NL9P+yxDEXv3Y5mCFh1b9GDkw03KlBSRSktIBFt7hY6D9tpvub6NDDSFO
         1/QF2Er5fRkzRLVrJWggAHENMaF1JQBeYP4YL5rmqIKX4nbeTyNqb40gjeOsXuJOoYlk
         7uhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323544; x=1794928344;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KpEwWty65XIKqwE7JeJ6p16oyvStp8N2eZzOQMIZadI=;
        b=OXGCPnUVw30+nXYzzO5jaU/YpDT9Pq8U2A2Rf+zYZIteLquX/njfOtPdugXQUYC6oi
         8xagqQozae3FsKrKgjN0rbch1bgdavrs1gZitgS+MYQLjYUdeh3e/qMOU6uczWyEV2CZ
         /i3uQ21m3ke6lIqBcy1d/26fBJV1AKfcZolvgstZR5EWf6hpWYQMIci3jJ++D5f1kip7
         R/vFCuW1Kon58KwViP0/A+25ZGXE2D4dMESu5wCoZBqGVL6sSEjrz43MDa1+IGf8LP/I
         LwIZtOI0NrLzK9SRGZm3J5lmkVxK0IIbUkRQg7t3c968mWIneQ1Ah3sl4ySZr9HUkmTw
         neUQ==
X-Forwarded-Encrypted: i=1; AL+hErEnekWnwVVlXX2qZBN+Iu6/GGi2uGfHpI2v4cOSb/kjPV0wSsn2AcQPmIqARYmsTsl7R5O9Jl/Pxg==@kvack.org
X-Gm-Message-State: APuU4Z+J7Sifll5P/IfSEZGZ52qS9cwc/MTQz6RSdNzF5/7wrlREPFiV
	rL623RUk+baho8ae6+2dw7rVFUiBrC0tk4ZA4Eqq4Y3qXdYH2Uouj5qyFvMucyMM1rE=
X-Gm-Gg: AYBFou1wUXfMRSHIXiGfbEn/TpQlbG5fJ1ofj34wfberTa+p5W6+N/3nq+mDqEsWssm
	zQanCdnYTSOgRSCtXY2LRQC2KV7sa0ehiFI/HoU22PjsYVqoUfsbRQxR09LQlgrwqEF9WKn7SjB
	C4wLXK1XCrD/52xfP2gsdHW+jg2Nn6twSzhDomZ6wmCLm4Ht4r/tR/vgnL0R/r46AuKua7lQOaP
	rHiSPWQ9l69TzvWSf6sqJQC2gaqDHw6eR91Z5FFy8xhpykkfddrz8sPcdJqUb1xGkrbM9ubZtw0
	4G0OiWPweSD/ev/kWgOXAQ+b8BsN3QkYUBrntzx1ULLMtukBtVPZ+PvfWW0wzMyMOGe4GrDBPPL
	PxBuIACfPGJsc+IbGTxq72lXCv05P4Hir80ulTOlFEsD9ISf73TwJAcT7Hzl4C8WPyjJUlr+FT0
	Y50h2k8dFmiesdaPXY0U7nLtW3ddD4E4e1ehS9W+Qo8FpcdbmiZxLjBmh+dTv22KdGwdgU2WD2I
	hf19NTuzOLPMUQI+TM9k7ZBAAwz3tMnWoUpImnfPpvP5MmjrqqzkX0zYKfKU1Mz2q+kAbN7Ea5T
	oEIVDhbnl+RLvy7d1mEmlLQyk9/5Nz87zH3ATzb0yCws2TDHj4u8MsPTYCeb8YN8UYCfYL8dSra
	v4JJEbaiTZU2mZ9Yx+wSuFtj3Teqn
X-Received: by 2002:a05:6122:5313:b0:5ea:a0f0:192f with SMTP id 71dfb90a1353d-5ee0d0cd07bmr947867e0c.10.1794323544266;
        Tue, 10 Nov 2026 07:12:24 -0800 (PST)
Received: from localhost (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee0c45a110sm2039560e0c.2.2026.11.10.07.12.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 07:12:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 10:12:22 -0500
Message-Id: <DMRMLZSZ0LAZ.D4P70QWX0IHB@soleen.com>
Cc: <kvmarm@lists.linux.dev>, <linux-pci@vger.kernel.org>, "Pratyush Yadav"
 <pratyush@kernel.org>, <kexec@lists.infradead.org>, <kvm@vger.kernel.org>,
 <iommu@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <skhawaja@google.com>, <sagis@google.com>, <linux-arch@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
 compatibility
From: "Pasha Tatashin" <pasha.tatashin@soleen.com>
To: "Tarun Sahu" <tarunsahu@google.com>, "Pasha Tatashin"
 <pasha.tatashin@soleen.com>, "Mike Rapoport" <rppt@kernel.org>,
 <robin.murphy@arm.com>, <maz@kernel.org>, <will@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Alexander Graf" <graf@amazon.com>,
 <seanjc@google.com>, <jgg@nvidia.com>, <loganodell@google.com>,
 <arnd@arndb.de>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, <oupton@kernel.org>, <alex@shazbot.org>,
 <gle.com@google.com>, <pbonzini@redhat.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, <kevin.tian@intel.com>, <joro@8bytes.org>
X-Mailer: aerc 0.22.0-39-g5d7784875be2
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-6-tarunsahu@google.com>
In-Reply-To: <20261110050202.529473-6-tarunsahu@google.com>
X-Stat-Signature: pem945swzyrxgicrs95eyq6bow4id7hg
X-Rspamd-Queue-Id: 4916AC0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794323545-966805
X-HE-Meta: U2FsdGVkX191sirjISVV4d4VoOS0zl1gFm8nNC/fXaT4tV/iAbfEl6a0F1YXiZpSa17gpoQBKjxZtr/g8PY0j6lpdE/QATqnPXd4qg0AO7kuso0N7eGPcHR0TlPdIJgj4QlY0LeJZRlyf1qjKTfn8oguk/y9r7X1cuhTLEnLNJCTb9PoxMoYYoPkWkZzdcOfuJRlZ4pK3Ar+U8zYrWGmlsgoT+364Hw9hhyroJJsQED8FmsY6rDL2F6fKRz311CNQ39r1laP3OGMJrfslUxMb82WgyjkvKGBrD6opWsJQMI5zDNACZFfOHnw0rLp7mSSJk79H5/lfIzibz/jVUdZ1IAZR/RkPdJQQCEEYUxwVkoofsbBpiPYwputYtHvQLSsEwAblkPJV2qvZeoIwIIR/HWhljvvF3DcW4WNgKZj8n+Onrq6zLE52v459+9uIekudncTgFLkMx+LcgCFruCsfFnyjz3fRvSjyn+QGny4TfZAqDfT0c6NkE9h+YuR+J7uPY8kQKoT0exhUlZUjugcOth/hSd8WoLV3x7okzNvYoxhc1PC+DcKFkhgZA9kUtv1j/cpNb/oD58M8iqvIIyZxNNQ9XBJ5R7mYgouxjQjtWlIR1cF4jRt7hfTdhSaYDSqbAb1czVKbesyiBBe50IszR5mwShNQTfv/EDj/6hvoOKiaUMMFXjIYX3dDlGvBuYejX/NPYONoRNchsx0WBeeQocl78ZiQHlrrZ5sz2seWKkRx75vqVvTYPJ6tozLwXmb0Zr4vuWWRCvyvOkqfwBq0eR3I9I5dxUzoW5BIfks2HSFdYNtiXnL6s++dOsAagGX6vnKKOeqrMlpm16EapnPzcWbT1vF7GYYWq01SkMNTQ8zlHktFwUZg/ZGk9FdPC+G5AzaueeBttzAF+Dy9KtbnVYVsk0wPCokFRXv7YzmEcBFAssXWXueTUfKrNUukYRF7G2bW5ivfTtVj/EKVJi
 FYcnrPuE
 x0D6ljPrE3fsjO8n7ohc6kokE0c63WKA6dV/cgcdCagCjsVLSmrpB73BNUyNitXpCe8fvpPpzDgKc3gMeNHgQNTNY3fnEziC5CfTrlCQym5wFuwa8zpje9nH/0VlWyJvYYYPVb2GonsfGXA6WXPfrAmq0uYrfnl4XyzbEugo0hUle5Tv08icWTA0fZu3GbgtKbsEt8ZyVfoEwjX034bkwiK4DrjUKOSeQAgdx/whYFVP2K7i6WBpjFag3j5yrEPwPvMe97UnvOqhHYdsvKrf1UQz09jzsiarZzqc8WVn88qOJeO/FfJw9gt/XelTLYyamACTsPPN1LfrvfXl+Dvhd0T20HH76IbvbSHst
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 10, 2026 at 12:01 AM EST, Tarun Sahu wrote:

> +/**
> + * DECLARE_KHO_SER - Register a serialized payload structure with KHO.
> + * @name:         Structure tag name (e.g. luo_ser).
> + * @payload_size: Compile-time expected size of struct @name in bytes.
> + * @nr_required:  Total number of defined required features.
> + * @nr_optional:  Total number of defined optional features.
> + *
> + * Size and 8-byte alignment are asserted under CONFIG_64BIT: KHO and LU=
O are
> + * 64-bit only, while !CONFIG_KEXEC_HANDOVER stubs pull ABI headers into
> + * 32-bit builds where u64 has 4-byte or 2-byte alignment.
> + */
> +#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional)	\
> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
> +		      sizeof(struct name) =3D=3D (payload_size),		\
> +		      "struct " #name " size mismatch");		\
> +	static_assert(!IS_ENABLED(CONFIG_64BIT) ||			\
> +		      __alignof__(struct name) =3D=3D 8,			\
> +		      "struct " #name " must be 8-byte aligned");	\
> +	extern struct kho_ser_hdr __kho_ser_hdr_##name;			\

Remove this extern.

> +	enum {								\
> +		__KHO_SER_SIZE_##name =3D (payload_size),			\
> +		__KHO_SER_NR_REQUIRED_##name =3D (nr_required),		\
> +		__KHO_SER_NR_OPTIONAL_##name =3D (nr_optional),		\
> +	}
> +
> +/**
> + * DECLARE_KHO_SER_HDR - Declare a feature header variable, field, or pa=
rameter.
> + * @name: Structure tag name registered with DECLARE_KHO_SER().
> + * @decl: Declarator (e.g. *fhdr, **out_fhdr, or * inside DECLARE_KHOSER=
_PTR).
> + *
> + * Declares @decl with type struct kho_ser_hdr while checking at compile=
 time
> + * that @name was registered with DECLARE_KHO_SER(), documenting which
> + * serialized payload structure a feature header pointer belongs to.
> + */
> +#define DECLARE_KHO_SER_HDR(name, decl)	typeof(__kho_ser_hdr_##name) dec=
l

Remove DECLARE_KHO_SER_HDR, use kho_ser_hdr directly.

--=20
Pasha


