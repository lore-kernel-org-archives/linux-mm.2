Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50C9BCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 16:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926696B0023; Mon,  8 Sep 2025 12:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6C86B0024; Mon,  8 Sep 2025 12:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E386B0026; Mon,  8 Sep 2025 12:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63DAE6B0023
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:48:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05455C01C9
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:48:28 +0000 (UTC)
X-FDA: 83866666296.09.B4BA0F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 026E61C0012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:48:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=zx2c4.com header.s=20210105 header.b=XK8UCkAO;
	spf=pass (imf20.hostedemail.com: domain of "SRS0=isGX=3T=zx2c4.com=Jason@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=isGX=3T=zx2c4.com=Jason@kernel.org";
	dmarc=pass (policy=quarantine) header.from=zx2c4.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757350106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uSnlDYAkih0wYrWYP/wGKkJTrA/JIOiBaO0koXzi78I=;
	b=cQ7kWG71KMWTxzT/0zXfwrWB9T7fL2vzinUvDFZDpWxlTIjNxgVB3/NUah34myAc7uLVH6
	ShtlYgeW+79UTN+XM/5yEyEYFgHgc87YVg74QwRqzJq6Z31DBGUnDX0cMGt8JLzxwuhk9K
	CYrKkhrf1W32nYqt1fSuuVhI6t4nEws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757350106; a=rsa-sha256;
	cv=none;
	b=IVCmjItBcjr/KSR67fYBmYgqIq3kl6BMoQ37j7/p5pRjY6aVAPrzClPSxxtNovRJD2y9LP
	ZL1ZkhhvJkD0AcK/nTLJBJ0amcYESWTxOg6VN5z2ekTV83Lrw81xlStlaIhDghHzYDMZ9h
	bVGdC1otEKFdy2ox0KV8qzGUrBucb9w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=zx2c4.com header.s=20210105 header.b=XK8UCkAO;
	spf=pass (imf20.hostedemail.com: domain of "SRS0=isGX=3T=zx2c4.com=Jason@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=isGX=3T=zx2c4.com=Jason@kernel.org";
	dmarc=pass (policy=quarantine) header.from=zx2c4.com
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D42D4358B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B27C4CEF9
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1757350098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uSnlDYAkih0wYrWYP/wGKkJTrA/JIOiBaO0koXzi78I=;
	b=XK8UCkAOFuRTAaMghbMkYhV8T2QJaLjrkIRbiSC744iVovTaic60Zp5rZ+bImztc351gHd
	RfVyIShQIvu7iaNMFAfleIQgTZHVZIHMKALN8K7z4nH5u5CE2QvEyp5Ifj4Cu887WIjTUu
	PPaVKxR6lJFHUjNXxFZY/txccNFdWt8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 510d70b8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <linux-mm@kvack.org>;
	Mon, 8 Sep 2025 16:48:18 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7452b1964f3so4285900a34.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 09:48:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXfN/mPx0LfSk/UoNI72ny/DM8aZEkQ2CnnGEfoNGZUdvYmpyrtqxjYCOvwE83Wf9qp5PNzHP83dw==@kvack.org
X-Gm-Message-State: AOJu0YySCZNuAGonKlbi/jY7+Tp6YsW7yFORQDH4o6d3AJ6DfgF6+Qh+
	azguqtL6tfX9HFHQYUe1PbWkpaqLSPmfwyKRZNa5UPpBk7DjkkkaGI21hf5TaPFxXfcmiBWxMtb
	YrwN0EGigleeqIAGaxriR43exIoiXs0g=
X-Google-Smtp-Source: AGHT+IHX8XF6+e0fkSbHw/Gno/Iv8TyBoDNhQdZJKrK/fMw8uizEVVlHqvT1474ZbZbBOA/u0TsCp2SBgWidGOb2gVE=
X-Received: by 2002:a05:6808:3447:b0:43b:2976:6080 with SMTP id
 5614622812f47-43b29b4b108mr4340525b6e.23.1757350096055; Mon, 08 Sep 2025
 09:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250901150359.867252-1-david@redhat.com> <20250901150359.867252-6-david@redhat.com>
In-Reply-To: <20250901150359.867252-6-david@redhat.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon, 8 Sep 2025 18:48:04 +0200
X-Gmail-Original-Message-ID: <CAHmME9okig=9NVGS_vSt525C-kR0mAyCnzSn9iypvu8uj0zA_Q@mail.gmail.com>
X-Gm-Features: AS18NWDEbovQfzN2Y035qma21yXmLeYwXyIh1FHAB52eeHDgW6bSgyj_MCTfArc
Message-ID: <CAHmME9okig=9NVGS_vSt525C-kR0mAyCnzSn9iypvu8uj0zA_Q@mail.gmail.com>
Subject: Re: [PATCH v2 05/37] wireguard: selftests: remove CONFIG_SPARSEMEM_VMEMMAP=y
 from qemu kernel config
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Shuah Khan <shuah@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org, 
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev, 
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, 
	kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org, 
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 026E61C0012
X-Stat-Signature: 7gatip95j5mrsacyrrwi1tsrcfe6s7ji
X-Rspam-User: 
X-HE-Tag: 1757350105-483805
X-HE-Meta: U2FsdGVkX19HPc/ou9en0EqCjHH7GyNNMIg+C3bqutBQkpNvV9mhBo/b2/jgCqcggsWeP6/R/5QmoOUAtyOgaEVjEBUdRdGcwjfWWcBQU5sJGxmGPbjBlOhlwT26wRj25HbmCA2KrEurY6FPo6XYGubKGEmQDYbnT5tlaUrgYgSUags0IUpmdWyhBOCiEo1zEXvxq7x+0IhuD7jw7WJEDb9A5HWhd83U+Q1EymwwOVy9TmjHpyqHkj0iTYx6s6S6r5yYwTAuo1B3selssID0hKIKu43unN9Gd2NoTyurc9nTK7tX2qrrmnWNNpxA5ArdeEVsP2WmqWzKgRIiugfSOUxJ6I4iz1v3eLxLe2z6OWUX0w1XNU/Fy+qeL7914Q/j3IMD/FjOiAAgKVsF1ca4yPoPWipGe3OTxIVxcHzmtqChbt2LmNr07nh+L9lIG+lsgCFB21FDkgxH8Oz+DQQdGMy+Uqz/qnxmjmipvHoggVjgP+onmzTS3P1k4p7DhBIytJZ9C5Pt18Z5eFyODfW4bE2H6kGNKzkw3+lXyq4pec6bwIeDpDf39dzuvV7stBVrVukkCnscRJsvljxQc0Ou+4olRdR1Wvbcv2xhvs0qvw6KemFJcpq6yrXtgsnxfFu/edHU2o0kI79AxV09zTBd1emrgFJNwkGBKTm5acHkFFZwW9KhayeEzgyxt69DUvmHQ2IBP8AmE/N41H2oPpCNQgBUq8EGXmc1ArNWs3meC0dvhsDm+sj8z4tz1Vc7dWRJCwLNfZDoDbk+PPZKOxPHFKDVmqAbiGANQWG/Mnqrmgbez6i+N0gNZsMDU02Gu4Lxp+o8Ao+HkPulqW6WabzaXy7LWPKx+Z+4EOxTRhStqIV/YEVa7tL4m20yPMhhjTqbA07FtS/j/nQZ9bDklys/ATzd0lsguiTYrz2oIst/HiCOSBboVyJWo4AftJOIkEBQjEkZ/iOTliCe4jEfKAW
 y2+QzRHh
 4Nh1P+9BB45VW65/ghvm/vyY5JL86OWLVI1GqorlaKGCavAl0fc2FdzX6OGK+EUof2ZYe8H35E1m4FDAvQUNqHY0p8S6QNYLd+6ZfmSW+QkvGnAGBCdl4tKQxqCRTIuXgQDKf1MktDovCL0blOOZswof5wOulpoMIN4PWhdLqh2mKncq8cHmfjjhJrS0IhzxE40kJynEAqk9Y2HbfuEdD8NCjvE3LG3NpAAbxIRimzNRwCrLbFMZEJ11RvyY8f0xEqpksfn9lmEjwb7KNYtl+Io+dQZIAGXptWCoAC7uTME9iIV1GE4YxDXcwpFLf7PJcd0cJD0j+O/YICXGlkdqGmWnE4mCHulQ2+cnqGNwwDpX1ou886mBfy6AzMgKlkNzCs/fLbSDIEZ5GtJa8onsp00DXy3LNFdLptic8Ii0FgTHH/URWhyoqQEn8if1QSQm77zrwrSr/967DlKBQnT/88HEGbM2skoD1g4veiokqEpJHqCp7B6pRpDXCqFuwNoBDuG7w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Applied this one, actually. Thank you.

