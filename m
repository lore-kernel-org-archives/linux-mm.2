Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF77D60A3822
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=S+LHX7xY
Received: by kanga.kvack.org (Postfix)
	id D87406B05C7; Tue, 10 Nov 2026 09:47:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37EF6B05C8; Tue, 10 Nov 2026 09:47:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27E46B05C9; Tue, 10 Nov 2026 09:47:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB546B05C7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:47:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38770140903
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:47:44 +0000 (UTC)
X-FDA: 85419488448.25.02DA300
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1A8FD140009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:47:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=S+LHX7xY;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794322062;
	b=kOEGFrB5KHPBOH1qtbCe5d9dq2OwTy0RhpIuoxNM0jnEzkihiQFzoQp63aIWngNXdIHtra
	0XjPSikvwT6ORJX3XlBOwheQVPZWoY+b5Nb3kVKjppIBCA/UxBt8Q9PmCxVGlYojF8D5lA
	9K0YtkVn5KiOHMtuzQd1L5Ty7uvyDRs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=S+LHX7xY;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794322062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFEAJe5RSOFhQbOQqwNvxFPxejburOXhpBzwnwwZqdo=;
	b=F7pbSgDqMkBQwpPWDGKC1EgPfKSa88L9jCRWkamCBWW9CPg/5SA+p4fR36Sz0HZA8M/bm2
	aYFeodfaYi+dT7QXIBM7WUME/ZIuC0oyUBgpyjdl48wAZrU7KRt24ZPXdmTA3hhsBIj7JJ
	Uue1taVITe48qzHdLV0pka+L+KT5DvE=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7d2f4cc314eso947098137.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:47:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794322061; x=1794926861; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ZFEAJe5RSOFhQbOQqwNvxFPxejburOXhpBzwnwwZqdo=;
        b=S+LHX7xYJ7z/36XBdzsp4NmjMAQG5jECGX90yw29moWg2mEmpNaIeeYc3iAnd/872j
         2Lozz64ZpyUyozwo/TV1efCVzWGDP3Nt6tm8cZvZGe3bL9B1z5L0SdOw8b1sUrUurMb/
         XKJL9/nb3g7IpZY1ijAj6sfrdRc2NGcYHvhmi8y5AboC5NASWwMA7VNMgCLUxsKgkQQr
         y3eSS/H4wzT8PWpXtqUHsgzFyzcEgiQo9nw6t8GuISKHauPmzG71xZmDHIkvUJv146fW
         Sez7AgE+5zG49xZxLJHFrRlrHffD7mFNeMj5yEJNaP3Eo/ZV1Qa/4lFyNXJtD8HJ5Ow+
         UcVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794322061; x=1794926861;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZFEAJe5RSOFhQbOQqwNvxFPxejburOXhpBzwnwwZqdo=;
        b=lvNip+uIncAspkmrktNbhNUCHQ8VbDquE27ksL2JOIfOsN7MRdJJyJOO4kZ9L60gkx
         m0r0t4+hT12wzj72X/eO4JZyFPjKtvqNp/vdpTBOWWv42Ngl9QNpyb/QYE54IyseqPRW
         G+AQfZWNGSGlqEF/UUIgESb1st/uS3+azm0Ono3SDIvm8k+NVKIxLU64UNlliwjnXXdq
         O8AVrNmf64AR9qj4qeas6D3jU9tfOwwMwybbPmCSlYsFufk1IoqhL2cQFWfMIAjzhVCe
         Q7NziqVbbspOWkEXYBWIQsQNpD13cqN5ekZhJrcPb5hY+IZ0X6twua7X/Z8GVSjVGSVd
         TqTQ==
X-Forwarded-Encrypted: i=1; AL+hErG2JkH9U3wLFEp42OkVCtynhnPJPVZTE6GVYFCa5dWZP9BdLVtsTFLAg9hiqMFDf43k05aOYU3bVQ==@kvack.org
X-Gm-Message-State: APuU4Z9x0lQxcY1a2IftA5V5dXxn94Xafxx4LPmkV2NDhwFxAN30w1XU
	4sH1AwXoqRT5q0bCQvYbRrTlROENZVN+aWrtqpd9PqXa0AXduIClammsPfgVfNGpsQk=
X-Gm-Gg: AYBFou1o31qvTAiOLCWV4VFR7pvkwkaCjzs3t7GxVZg1T81QXwStvysKbONzxwnG6sp
	Vi3/lAvX3qSUzpGqgcZqZD2ed8RRppZFp93yxREzDGaz9/iC5De4bMqOuDT6ftL72JQC6zo+p4c
	pde6NhHseIt/UeUcXIceH6EpvfsFsd5uCm12qcrtwB61aa8ZmqDjnqKMdCom4yqFDYgrf/Hxsyh
	wH6n1ABAwtZsFROymLO3EGZ1F543TU9MVZMaWfRC7olKUpKgHQ9Y/nwJnj/CffDWK6tJLJ8I4gk
	jLmTdoGJZ7jGNOXE2lN/wTgYfJUInFP/kIVEAnEtBbXeDhwaWcWMqlbBbXU+N8cKnqZRq+nAaNQ
	pdPG8v0i06y0F+w8alZZl9Ne3n0zv8HTzBBHHDahOoLPy90LIcTtEfj358nlgK2c/KCgyF5u1nh
	HnjGXnjzYX0MHZFW+GNpJh1k/ggx+fSZIrdJr56DO/P6fV1IMLk30snRRD4op0KTg+uyHFilGyo
	VfNJrKssMkqM452hlZVgrzp4A7NHPwKJ38LxSeS0nKPleyMz0/JigbJLxmuAlSwVr1zxz+Y08SU
	tN9vj5c9pn0o+lP1HPwd8V9rZ5uoD6nWqSyWu+AW2NcbBedxN3itHs4THjcWkMjXnE3GppPzl/3
	YkDzquB3eex7FP1zSdD9n3pPpDhTM0BbOsKprpTSQ8Lc0K18=
X-Received: by 2002:a67:e706:0:b0:7cc:26a8:e716 with SMTP id ada2fe7eead31-7d301c2b6b9mr1064638137.18.1794322061210;
        Tue, 10 Nov 2026 06:47:41 -0800 (PST)
Received: from soleen.c.googlers.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99c2003b37csm1895903241.6.2026.11.10.06.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 06:47:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 04/19] liveupdate: Reference struct luo_file_set_ser
 via serialized pointer
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, maz@kernel.org, 
 will@kernel.org, David Matlack <dmatlack@google.com>, 
 Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, 
 loganodell@google.com, arnd@arndb.de, dwmw2@infradead.org, 
 baolu.lu@linux.intel.com, Bjorn Helgaas <bhelgaas@google.com>, 
 oupton@kernel.org, alex@shazbot.org, gle.com@google.com, 
 pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>, 
 kevin.tian@intel.com, joro@8bytes.org, kvmarm@lists.linux.dev, 
 linux-pci@vger.kernel.org, Pratyush Yadav <pratyush@kernel.org>, 
 kexec@lists.infradead.org, kvm@vger.kernel.org, iommu@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, skhawaja@google.com, sagis@google.com, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261110050202.529473-5-tarunsahu@google.com>
References: <20261110050202.529473-1-tarunsahu@google.com>
 <20261110050202.529473-5-tarunsahu@google.com>
Date: Tue, 10 Nov 2026 09:47:35 -0500
Message-Id: <179432205559.2329176.7688399969919556416.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=791;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=qYrWWLSjrMyi3btEEyRhgD14ybrNmyQeqN8ETOUOvP4=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq8y6LmPCnN2SrnZCSda58BBnTZsMnjk7g+kA/g
 6Wo/AVJiseJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCavMuiwAKCRC7dyhM23N6
 3qrED/9liUyRUpQr+Sv1ioZ2pUvLcetyB+2JoLxaB/0UYYNHqDXpwWtEHhSP3eAYwEET2WAzSzb
 cINjQ0UdR20OJBBxpWT+3R6jrxl6smFx5lA1+CtzCdBONdl5NiW3+NITRy2Ip//vGFZKdNjWFk/
 5Y0ii3L7iz6hVXT9R9y6mqGOo2TBCSa84xWnOGrVJ8ijAnCqgOeAMhmqVN+rkl/dWCvzMcCFZZP
 AYRuSxmCQaOa9GxsOttPL5pX10r/UbwioXQZu/aJ6RcG+ql2liIZFv1+3mcSyInleN3SlnUZOVi
 inOQM3Yp2D1a6ekPH7F6Uzb45X4qnnJ8DSfO2LkVSWgmzzpsKuXUePJ8Pe0a7FfO9mUYj5Fp9wg
 IxfJUyigWzzPN0aOcgePZcZBT4fLUlw+zQV3UGnfTiTzevMagmFWU2+B/s0Zt7u6TidXvFQsMFI
 6ZlD5aySuQGLYM3+UdGdp96SY6FEGgvqmSCG63zPbq7Y2WqSBl153diBep17zLt4CJ8n3Fd+YrU
 E2rPF9GR7k6MT1Qc2tSSvCCk+cTjcDt4Fm3op7Z6LrxP3BQDFa0Fh2afBgG5mCHbK8fSxd2uggj
 NuHbXeBNgQpe1vKYQQd97AUSoFlymseer2cfqgpdkxtIZwGdPAYPchrVuPHKx6mZDNkSz6VZZ49
 k5DwAzPXt9kz4Og==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1A8FD140009
X-Stat-Signature: df4f6dyus7ik89n4g6nz9in9gfd6ufyo
X-Rspam-User: 
X-HE-Tag: 1794322061-32359
X-HE-Meta: U2FsdGVkX19z4bgqj3OyCOe8NHBzW3IyXiL89xhFZPm4j39dljdILS5yxYNAYDpZu7G9RGqEtoZKGuhdEtNBAhUBxRR2YmuG11SIgmU31EjDWaFgVHRLlSVxTdkofKkU38CSQpg0KGe6lZpoRkB0vqBX64EIIr4SFbpVoYQJ6Zbyp96e/Xx56cO404pBCooaOJBfi48BwJrHxv/6FIXgmAinV6+wl/rWf2ee0jkh9u2ZNfQqNuAjY+u/4YRFi/BQ+VbLR8B3BRoS5HynQMmz8HsOo25SKTl3DrofyEd/yEa7+U3zN2CjW+bo1tPGfqHg0ERqQL9YOEX/ArSfNsE5XOSPgQtw1qAXgx9Z4POfi3rCdJ862SX8EeiCD++hsIu/ImJgD99dabbBc840v6j9NuZ2mFu/QY+rDVzIY6QdTM2ZHpsmGSAJ/kvcLauMM9QQtbq4aJ0woaWY11lFthHjHejHM8BL6cPc5/fdhby0UqP9U+xYHp3b4fw9MwWi9up9otbQ+W6SX3uMp/exoqmTTodwOx4Pq20Fu+svPNyMj4oTRRvQJYEUVGoL3FAkcgipijg2keeRjQbsqpMgpev2v4ENF9VIbbwmagi2FFcLGHjt+glMYZTsAHzylHuKFuM2gQdASiSKh6VqjFHBzJRSVAKn3wyGDU79Qn1kvbZjibtrjOl9TWqkR/vgfAwZIx5FEHzkMq33CPwhbKGQdaucuf5yoTMRIoA8z8PVrGkEdQWQ4HEQno6X1re6lZt7lUAKzDNaicYRlh3Qe0rjgH+UwB4Xna/a00XW2DsZGCl6cCPPNI2A8DEl6lQ4gX/y5b86In2e7ZPgbMCVQkyECkKOAePa5ieXqoEmbU4mN9E30JXOZwC/1u1ajOtAoGUaAYg/dmYc+xSCoYBBAIxCZXOYUfHvbaJDwdLN1m3sLMTPGJAKhnToqlB5Zbsi0NWCU5q5Iigfx2i3uMXaVReQWEa
 tsc5P9op
 nXDjPby+AA89tnfkXuVucwfNN7Y65yzMj7iNjbo2m5HVhFqVDCIQaTWg+a7T/5Sgu2bTT2kEAskYMAXfq7+R5BdjrM2ORlGXWjXgOZZvAlWmKvtl/Pi+GgIoad5hlpBRMWoLDHYWoT8JLHKEiMeIlMO/bT+JPeo4RtcP7Q3A9JADWeYHZM2pFHSqzkX1W7NWBPV0tun0Aw7LtbTbjlyBu69LCJvfq5JjiAKCCisiBzW902p5Iai+/L7LmQW43Wkl52zRkDzbXSkDahJgY6Q8eNLU1Y96/LzkfMo3UnEvLuCxrRyFeKMzRiw88oRFz0lcU6j9LRB+D6QdrWZ2i7Au+xHXjYfOxOXlQZCuT/5PNNEnhGHrN6vqv5U2ESBceJqVv2B9uuwwVx7RbF5pXbQxiU5VikJbQCYUlnsJ02YY+opYMOwgf8grCThcgfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 05:01:47 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
> struct luo_session_ser currently embeds struct luo_file_set_ser directly
> by value. Embedding struct luo_file_set_ser couples the session layout's
> size and field offsets to struct luo_file_set_ser, preventing either
> structure from appending fields independently across kexec.
> 
> Convert struct luo_session_ser to hold a DECLARE_KHOSER_PTR pointer to
> struct luo_file_set_ser instead of embedding it by value. Reserve space
> for both structures in each session block-set entry, placing struct
> luo_file_set_ser immediately after struct luo_session_ser, and bump
> LUO_ABI_COMPATIBLE from luo-v5 to luo-v6.
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


