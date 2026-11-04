Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA98A606D811
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=K45Ue0xI
Received: by kanga.kvack.org (Postfix)
	id CA2556B05B3; Wed,  4 Nov 2026 17:28:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C575E6B05B5; Wed,  4 Nov 2026 17:28:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B419E6B05B6; Wed,  4 Nov 2026 17:28:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3CC6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:28:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D119E1C3EE3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:28:35 +0000 (UTC)
X-FDA: 85398876990.25.7B02588
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0EB311C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:28:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=K45Ue0xI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793831314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngSI9f0kiDWl+YO8rRXsU2IRSVNvxIMeC8SrK3o9F8Q=;
	b=yFpurvKd/n3MiUFwWuIn/ncfzV2iEeXsK2xGz/+acSG3fVmkVJcqbFsKinJjS58Zzrb1DG
	ADKXc+3On/I5hoGgtfmnx6yoWYOtnhBuqSG9v/262IAjglltASYFKv61XENClZKh5S/5dc
	K2T3DWUJtkZ/60ToOoNJx5/ltewGsNo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=K45Ue0xI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793831314;
	b=VsPGWtCVa/ACgavKEoW1ZfOF75WBjjlVSIDu4aaWVgPZ7WRi8+ZiErn0G/GceBJYXJf6fM
	80fyo73ksUAXCK9UxSWDeBfzI/OnR9LRa8rJtpBbqMHA2uxBe1cF4c7sYpvXeKGZhGPS2F
	wgjVdoK+meA9TCf7FG3KxjBgRDj6OP0=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3acb512a7a0so844959a91.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793831313; x=1794436113; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ngSI9f0kiDWl+YO8rRXsU2IRSVNvxIMeC8SrK3o9F8Q=;
        b=K45Ue0xIc19NUalphcbzdP3QUp6yBttN6UwSu8RXWmuOd2k63iXIW2JqKFpnQ+RDrv
         JidptiS/OOwFk8flr0Y/jUmT1k3ztjhQfnIwJ8v1UXTbXgnN59JUEi8yZ85HAzTZtdIg
         VSYjXAr9rsBrlS/2bTtKQKaH59z1PwF6TD3eGEaD5htAHU3uuKd6Bn0o1ljHjab3WDg3
         giJV4iEiqcHAJ9FREWUTESGv5M+JIbngB3GrFtJzW72LqARI/ir8v5EBzovlPTLrocJ3
         aXvKN2etMxTarHio50GK5w/QB2/YI8xh2EgoJt8wOAdKUHdystsZbyHAUI2755GW3jqK
         jOww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793831313; x=1794436113;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ngSI9f0kiDWl+YO8rRXsU2IRSVNvxIMeC8SrK3o9F8Q=;
        b=ieEvNus12qkicR7iVFUbj0bCySdnP3OPyZUY2/aeZUrCIN4dug+1wwyNB3vElmlOKo
         cR9tT8P3VqbKknlkqatj71O2YxZZV8/SwFwyYEbi/iSS6kE538XHLImXuYyMfJQ3T1sr
         /+o1aZpwQWiv2CqQL7y4PjSDwTh208AZwku2/B0P/1lt4r7yt8dSmGR3KPUMSYdjWgsN
         77PqWnLw7ImGyL6XjUoKM/9fLv+d3Hfw6workxS0GyKPP+boE6P04CYvGviZLsoW4kiZ
         xgEIHCHkmOVkffWHKUr4IqqhANKC94pVZQr29TSsf5NOmyQVGVkwj5a+axwMCjnAMEkb
         rVTA==
X-Forwarded-Encrypted: i=1; AKwUvBzVvA71UYEcOeB0EwU3SfbKybokcQ7HiRtlKwa0O/iluZPLL14mF44/3+CQar+FZezQGXhwmrYKIw==@kvack.org
X-Gm-Message-State: APuU4Z+On3kJo4gYiDpgMwN5TVTkDhPuw3nbGTl8LI0ZtQdXAQxh9OPN
	NBXmNu4XeDKeG0N1BB/DC2UwUIUuaudI5IxqWXvhH68XpLrZf5Iq6GeunFnyxe+0Jg==
X-Gm-Gg: AYBFou3Xlx/ItEszsTf58rKKOWP+siVkbYXbyRvVqRTmnto/zRiVHjd1gW5FruDAs5a
	T6ECQ5p8ucsGWaeM5KiDq5OwhOSS8XLiiGz7FLynvDp/oQVqxEubs2NV8xjQR3ddjXECY+pXmwk
	rJaGVRqXEDyfpkIlZiPiuI6vV3yrkCfTwECn/fZuUiKGSsrZPPGs+8nXgnCiVpbrDF2Mxiba882
	9YnZ+vJDUXpkUZ5gVyXEsi7C2g4un0TOzmW4NkhHaWFYJQcjhZi4/gcIkxlUKhn9xLS/oLo5v7S
	8RKFhDXWsn7j1IJ9hwqnHzcZGcl/R3oU/Sr3xwm6LXJ2HqjpoF4UQC3jrI4ZKyZXJDvpcXk+AG+
	/F8rlFZ0ZuxnRP5SGdxGuOqURQU8VT7ndnbwQWSNAqvDP6LDEEIyEgbS2XVDuU5XT/haLfDxUjL
	DW29hbTn8Md27Omv570gxB1Q0ZINXBpC8SSu+x8t0iJxIRgxIWz6etMJ7iuBfpY+qcEuIpEIpdN
	tnB/dF+KGVnr6CNgiOVdwwrPv0P2lMpZK8Oh1zz36Ivw7eqchpA9IotXz8toNo/1PzGB0GMYA09
	JZ9wTyCVPjGE8NXuVTSygNscAuqbY+rUiB+tQoSfVhBGEvQ8xTvDhC5rWkX3yzS0
X-Received: by 2002:a17:90b:4c04:b0:3ad:8a14:bc73 with SMTP id 98e67ed59e1d1-3ae897b519bmr13057533a91.50.1793831312185;
        Wed, 04 Nov 2026 14:28:32 -0800 (PST)
Received: from google.com (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b31cf4b6sm710454a91.14.2026.11.04.14.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 14:28:31 -0800 (PST)
Date: Wed, 4 Nov 2026 22:28:27 +0000
From: David Matlack <dmatlack@google.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 06/10] mm/shmem_luo: Don't make early retrieve
 failures permanent
Message-ID: <auuxi10mmCQrq-y2@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-7-dmatlack@google.com>
 <2vxzik2ck5dp.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzik2ck5dp.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0EB311C0004
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ityd6aq9c6319d414ahcgy744jczt9pe
X-HE-Tag: 1793831313-811900
X-HE-Meta: U2FsdGVkX1+87kedzRtbhMM3yclKHbtLov3a7zyX1ChofxHQXYDWHWymnyFi5z9x9/iytEQgTxBwAs5CPWGMOumje1BTS95E6Y/KfLTBPwkEnyxiu4A5lDwGnOn1ZIQZrJiAmGSYwQp885xOokt1jWpb8ftsfwhiAp4lXscM1uhh5zQVZA/1iAsUtbJrBsH3Xy4So81yF3AoeMBHA33VozgrsYNkVIjR1RQeMHqfMvCRGzT9UFBRaT1LsCk2isAghthJsd5LYGzmW0Pa7V36tkC7+tsUsmXwHlj1tQ46Idx6PyqPnMgAl63+Hd1N6p3QXXe1meotqPrC7zMaTNHKxRcTev41IlfIMQKmeyFkO4nkWeOgNFraWGMgxUC7mfEiCyVtVkr8r4pyeRpJqf43OeM62zm6S2KEGN1B3/pOI1sZFDn1HjZdQNeS8RW/OsxTN3rtLlLPKNsMTa5XUl2fqVzcjTm9KKJ3YG/HabOtNgDKR8lbCBDrPaAvNJcqk9Q9+sQlBjtUryr0KDSQt2dMvx8O5maKsVS31gaN1Iu6ETFVbV26qQWB6wmJS0JT9Diooz78Jw0IRjvd53XGcghC+azK7nU9HKMcQ2gcBqsNCPwcSH1eX/PwA2kmg9MS4a4Vl/aujyKrd9sjdt+g0KkUsfRNAcxtF+xbffX7s8urJjwu5DVdx8Q7Xk/5mYilDa/o4rualoWK5WYipf4iF3mUXqBm298merqpsKFWwLDSSAljCemy+dZATJfr0MlYx5Bw2uRidv1lT0FKDnTtUC6LCvSAoV1hh/Fl69UA3kykpPTuRf62lQNV9XWmwijXkCw5UcMq7rtRlehrVqOADJifApWgk50jQ6Pq/nXmecG9kijuMsy054Z+SpEtdXMJ7YLW1uYpxr0xo/RSO0BCQYoZQKR/jrnWZU6KKlIOcNYN0nFSgRT7gpOKN/E/UPflR3sC4BGcp8ZdIcGg3pnK1gd
 eC17ZKuS
 p99ACUFXhFcqkuZw09Hdl/DD9Ox7EnwhkWKg1q2iWWlgM5VgGrfWTBXVqIOxIcy64eLffhUJu5KsIk9hrt3wQ5eloJ4W9pRXcFzz7OkorL/07t7A9dco02jtctIJ+c+VfLE0e8pdBQojO68B7dxUnhwhZY0OZQKUw/2iRUdl9u1EsE5XPWR5luCGyBuj/GUTmavBRhFtb+mR3owexteucTLkRKGhSpz+R0PTgE0/13bVUnBLivYEFQvUx2+345ojdZV+30IcwP87qZI7OS+RcoiPmHDkk9cBhX7hFRQC2Vlj50p5D6hnMs1j9byqNDtEwivfUO6tSkuJ2b0ITwa5HjqiHvEIHNSgnSYviyPcEud6NBGWTAR9OuDeZBQdGhPVm57u9kBwYk6rXLku4ha5cU2HkU8Xx32Nqqs5f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-04 04:01 PM, Pratyush Yadav wrote:
> On Tue, Nov 03 2026, David Matlack wrote:
> 
> > Mark failures in shmem_luo_retrieve() before it starts restoring the
> > folios as retryable, and return the error without freeing the serialized
> > state. If no retrieve succeeds, finish() frees the preserved folios,
> > like it does for a file that was never retrieved.
> >
> > Nothing has consumed the preserved state before the folios are
> > restored, so the retrieve can be tried again.
> >
> > This also fixes leaking the preserved folios when one of these early
> > steps fails, e.g. because the file has seals that this kernel doesn't
> > support. The retrieve freed the serialized state but not the folios, and
> > finish() then skipped the file because its retrieve had failed. There is
> > no Fixes tag, since the fix relies on args->retryable, which was only
> > added earlier in this series.
> 
> If the seals don't match, the retrieve is not retryable. It will always
> fail.
> 
> I think the only retriable part is memfd_alloc_file(), although even
> that is quite unlikely to fail. But I think that also fits pretty well
> with the most important type of error you want to retry on, which is bad
> arguments. In later patches, you check the argument on
> shmem_luo_create_tmpfs_file() or shmem_luo_create_memfd(), so perhaps
> set retriable in those functions?

When retryable is set, LUO leaves the file unretrieved and finish()
frees the preserved folios. If the seal failure did not set retryable,
finish() would skip the file and the folios would leak.

In v4 I can move the seal checks into shmem_luo_create_memfd() and
shmem_luo_create_tmpfs_file(), since the valid seals differ between the
two, and reword the commit message so it doesn't suggest that a bad seal
can be fixed by retrying.

