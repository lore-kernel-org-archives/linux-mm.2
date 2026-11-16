Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 979B8606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 04:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=NCRMRLFa
Received: by kanga.kvack.org (Postfix)
	id C0E616B05B1; Sun, 15 Nov 2026 23:34:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBED16B05B2; Sun, 15 Nov 2026 23:34:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD936B05B5; Sun, 15 Nov 2026 23:34:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2AA6B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:34:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 260F4808AB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:34:30 +0000 (UTC)
X-FDA: 85439715900.09.F8B5BB5
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4000D1C0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:34:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=NCRMRLFa;
	spf=pass (imf21.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794803668;
	b=winR5WtBEeAwKnzmHIcy51ckHzEfc7c39sXXGiFtWzHocwzVKuXPSUUxUUXOc4Gg2Q4WE5
	pCCacRIL8M+gfc7QHYhRp9eRMW5SqfKQvyMEcovrnNwoPAWsGwIMdpJGiR5ue9ljWquhI7
	hBHbppD1BQ2CgNKVu/TnHCIPWP7pytQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=NCRMRLFa;
	spf=pass (imf21.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794803668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yb0ouDgf9S/OdWev3vcVfqdIAaKZrYAoDUUyKNG3AEU=;
	b=1NHufwAmPQ0oQolhJ+ebBu/b08gEDfINfKaV5nUvBh1kJkL2UGT4JDRExAhowDVH3T77BQ
	RdQTKoGwQ/ALgqXI++JaI3/G2yTMwiPUSSswzl3yeiPA2ehsWq6Ratf/ljxoWiwQfLh/hx
	5iOv4K0Z004KNuzIvqgfyoJcfIwdb0Y=
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-18818daa3e7so1356316c88.0
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794803667; x=1795408467; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yb0ouDgf9S/OdWev3vcVfqdIAaKZrYAoDUUyKNG3AEU=;
        b=NCRMRLFaifete6hUFh1jt0kW/Vqmy7uRxb/3pWX4mHHEtLsc8MTIfjAkAp1xw1bzH6
         rxKwzxALauZOIJkxqGgc7KWOmgjvXjXrgd/98HLKeR490Othk3Q07ktqzult8F5qmyoT
         DZYF1zQzw5pIHKDJcNvbj0hqRoACnqUKmTitc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794803667; x=1795408467;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yb0ouDgf9S/OdWev3vcVfqdIAaKZrYAoDUUyKNG3AEU=;
        b=goWb7eO9z4IfQA85loUFgk+Y3hP/0fYztMURs9XFts5lnQR2dmu1PJ7Jpl33+K3pRt
         0GojcPF7aRyM13jj5T/NcyXhh8L+kpYS4bqbIEKd3yasgnDmeEI2n9zZ49+4CPG/NfP/
         VwoFNF8ksEbI6gO0V9G1kfvG6GpObpREKXio/zPkAP8wo5j9J+xwzw/g+jebgbaIZNCT
         2zCtlZ6z7o7YhZYkbhn1wbuWzzk/JpFcee0WwwJ5b9ogHFsyrBObSPr8htm1cuEDZjcl
         Hqy2Rs901TE6LjLT/LG43aMKUk0VEKU38SnTp2qfgzk9nwT1Ge2zBQb3QbGhCUPQ2Ysb
         5xeA==
X-Forwarded-Encrypted: i=1; AL+hErFlqcjtbCkQlbS9qwiBG4X9Zte5rcXLbCAMuTdZGDCorsxwZ+3DzGloR9FZi55ULbBGIi3iUS1H7A==@kvack.org
X-Gm-Message-State: APuU4Z+KDSGO45shBSZMpXrNnbBeZVN/d+nvFCySm74AORR0mTOI8ijH
	ePd0kzCRqxvNh9tEaAWHeVkOljrskQJUpwtiMKKxaqt1kvURCwYY/6LK7yusvmyJUzY=
X-Gm-Gg: AYBFou2IKbiwBz02mX87j+Jx4zgOIxLV8WZ/9bVjnRjbwk1TVIt28/dEkJKr2MNbuZY
	EIQ95z5qykJzywCSMZxspIkFQPeo5pxy5zdB+szM4AltCIL3m1GvtJPzjMoVf64RzmEQ+qDGydo
	7EiV9G9TIJNn6y5snYp+RqUgxtOfjnHVRdOxNp0WqChZgDO2KpOLQYmSMwBRGL1GIYvfwtVvuMX
	KeNUWC+rlwxn8FIxSmSRxzRzhoeW2aV/QDXZztU8oQOd4lWyeduEu1MSu+W9fHRV4xBkZhIxftc
	KmuTgWLABRcVT8p6zdWTDQwaWUKCVbBESK999noMxjKVoPQI9YnvGjWAjdbfJZpmMHnqB9A2boU
	Rhyjwhjkf3EXJjzpZuTr7meTHV0zA5UV+uDz3K5oOkIUoesbF78Giy1xq+WTVg1+lgqc3qddSRH
	784KIGubiZLsWMtbVsxrtlZhqPfz37EkGFVWrBHKrzLALUmsY9S49E9wUYZbY/YnZHYJz5xUMRH
	Gno+411KUC8ykWOdQ4BFOlv5GBrPrOOS8Py+NXugWjaxMcIqzK+fi3xrSpVn2KwV1wjl750KtNA
	zf3WfjSgoA6qc5DpbfjcTwS/SQLtu6X88Q27391w3ul9eifCsU7nj2qWxGrq3jbOzssvbYkNmUQ
	L5un+wCRk4zsgDD79tYBmjQ2Bg1BNESgU5VgTgeKIF2KXrZXQr4qemxxUh46DTtsg79WF09q409
	HzGh2jCEfhBiSvFsZ8snZVJK1G/C2gvRDl2vMorr2O6S47yH/SuSYh8yZUlQDgudtD
X-Received: by 2002:a05:7022:b0c5:b0:181:6b8:31f1 with SMTP id a92af1059eb24-1b4f5f3475fmr11110443c88.10.1794803667022;
        Sun, 15 Nov 2026 20:34:27 -0800 (PST)
Received: from [172.18.0.2] ([172.56.232.151])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm38362148c88.9.2026.11.15.20.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 20:34:26 -0800 (PST)
Date: Sun, 15 Nov 2026 20:34:21 -0800
From: Chris Down <chris@chrisdown.name>
To: tarunsahu@google.com
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org,
	will@kernel.org, David Matlack <dmatlack@google.com>,
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com,
	loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org,
	baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>,
	oupton@kernel.org, alex@shazbot.org, gle.com@google.com, pbonzini@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com,
	joro@8bytes.org, kvmarm@lists.linux.dev, linux-pci@vger.kernel.org,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, skhawaja@google.com, sagis@google.com,
	linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 05/19] kho: Add feature header for fine-grained ABI
	compatibility
In-Reply-To: <9huz5wy4tufo.fsf@tarunix.c.googlers.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
	<20261110050202.529473-6-tarunsahu@google.com>
	<DMRMLZSZ0LAZ.D4P70QWX0IHB@soleen.com>
	<9huz5wy4tufo.fsf@tarunix.c.googlers.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261115203421.38c206b35f5b12e6@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4000D1C0002
X-Stat-Signature: e8hgdsked8sq855f1u1rz6uc19zudbwy
X-Rspam-User: 
X-HE-Tag: 1794803668-660150
X-HE-Meta: U2FsdGVkX190+dEoUP49kGQLWFgYhMIg3MxFCcpjVH0eZty2hHYr5JoAoa85zqeiL/We9c19X/fcRc4B/lGvWkukBM5jRRsQFy9mCnwx59UERdZOX0Q5IJAehCarlR0CGHUbynY02+J/tU6UqTfUVK9X+sUJW0QHDLKm+ObJr14x/Cvs7Cc3y0Ugp6ULs4CTRwDbP4z9qXkdWlMm5ITzT7ZxT5M+9jLGKYJJdt5ctlOcJSQsyHBHk1UVRm8laoyVhR/8H7wae1eOUD8lTLGIph0GRNekj7RaTD8TGb/5g5VYsl0BacuDiyglU2uKouRPvB6EJC70vEGwjrsKzBZVdF5ic0FdmdHLuvV9NFXIrh40OrAVT2Xo93T3lRvxnkx3fSju15XnuGZLCoTmx/Vq0kkOHwuHyGZinRcNnglJHAgScydZebGc94VkDwS5mPFoeF3A77qKL2Ip2d/wk2h8pRZ6HbYz/s97KZbUziq+KacCU2/2oQhpD1dA+dzEkhyWEosnthuXnUJOruq9oZeK/BlRglQAxhuKkO3XVgdTj3N810p2GYLGi6KjGY7RjSNQE6gn0n+atdlfcWH5E4Phz9zNHxhrfAyhFHswg2L42NqGtk38eYO3yfza4Qk5NxbA6VT6tlAPi1bP75bWv3fZGcUCAgxZlaCW3MgvmEY2rmHE1V7VI9fGVwlHqbV6FUthuqbwLG2EPeYm8VfajXK1aKRH7kK3t9Hpb3tRwYREzlw19RPa4zTEFdXePHfCKtlLxLaUDKpC3RIewsaTLaBzlsi+oeMhftda5WFsZvVz3JnQqHJBd+NxpEqXfO2fpLmsa1aDBKzdCzP+5ASTZfXU2nA3JEtyTcC+PJEGVLb7RAezO3zgvUmOHS5TstIV/UacyD3xOFJ9NqWv9A9PuwM1U4Hqfwyvde3YgZSkbnkX8xJIps+Gs7Zn0mEeqxH9Vqs+KqITk0fcFZqUpoM8+Kh
 ioEOwhni
 KHzG70Xy5fatKIzWux9U0vx8inECNEdxjPaOS8L0ovqVKEZ6vuusN4wmIZ5qF/g+sn+aesZ42/8wghzzjJR4dmqOBwtVi4YJRXLec/Vz6nu0p50NjH63G79J0LFLQ62jA5INreNOfuJU5K+ni7GEBH6LeXGHwXIlsWpHOK2RPPYfTnUO6U7T04iA8XW7EFRzKftcyAioKtiKjOkULwBTFXcBPRQAVz3JYmXN4zlrTKL+wo3bFasc0YdqMDQdOOYbrhDdAR6+7asPxKU3BCZjjVyvQUa4ibhF2XVrQVP28HaG8vGokJ4OmSPF0O4GokWeMjzPJhCAPPwJTYCGRaNmImcpbDsUipwekofrVSXkItDgoFIuYaVvALVMX1ZuP/VV9u/PvFJybMtlqYv3F+TP5hwEIhujg7xnh3daCsa1TEHowumu+JOy0iq0QOBwI4lA/zcrs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Tarun,

tarunsahu@google.com writes:
>Techinically this is just for readability.
>
>WDYT?

It doesn't help readability in the generated docs, though. kernel-doc
splits the parameter list on the comma inside the macro, so
kho_preserve_vmalloc() comes out as

     int kho_preserve_vmalloc (void *ptr, DECLARE_KHO_SER_HDR(kho_vmalloc# *fhdr))

and the struct memfd_luo_ser and struct luo_session_ser definitions in the
ABI docs end up with a member like

     DECLARE_KHO_SER_HDR(kho_vmalloc folios_fhdr;

I'd go with Pasha's suggestion and use struct kho_ser_hdr directly. The
pointer can then say which payload follows it with a comment.

Chris

