Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62C56C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7342B6B0005; Mon, 13 Jul 2026 08:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5196B009B; Mon, 13 Jul 2026 08:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FAEE6B009D; Mon, 13 Jul 2026 08:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 456B66B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:36:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C6206120147
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:36:48 +0000 (UTC)
X-FDA: 84983702496.05.A7707ED
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id BEBDA180004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:36:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783946206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t/6DNcSK6X/uGZ1IYS4q2R1Z6al9GC0dZL0uRll37ZA=;
	b=Zq39bzkrz9LpoSe2WJ2ByoCRVZ0r5jUtwgzq2KejDBiO7uoGNoPMYVHGb+SFNFWCqPrfsG
	U2Lp2eW98POJYJBMe6y17WrvIXKQGZOXaIb1N3UUj9CgRwLQOkf3CKMht9aMyUKlX65AZy
	+x5npoU/KfzKGWfoghzOD/a1J0cz974=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783946206;
	b=UkfIkIJsM6oSu2a8oOOzZotXKYujn8doan+bdIRxl8jjH/Fd8xIhrHVpsIZlI8V8F03xv1
	9/HRSHzY/SGIFPk66Kjylnr2i+71ZOIVjO+mewFXPStLhmZ5yURa+bb8gdtq5H3SwJlEdL
	R97415kkjfOSCTg40b696KlIhGOWa14=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6986578d8c0so4517912a12.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:36:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783946205; x=1784551005;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=t/6DNcSK6X/uGZ1IYS4q2R1Z6al9GC0dZL0uRll37ZA=;
        b=emiP+Z8sV2u9IyT1yeZ5AQx92e9lddg1ZE7r8tjl5nGjQVe0D/RJ/GWn+oI/KDh1IA
         QtGhLz+vAdN32bHqiNo60NQNCVu4/cWkcaRmv/NsaGbjFMPl28/fhxY+aYSoqJR1pjla
         BE8An8H4xmIiQXexBGV3YFFrA1absEar0rtErRqHRajYxN3xF41p/atQCMbtGcvDVzrE
         r0HA4pTzNg73Mrvw3EIwVxPy6XmfWHcty+NBJXQKc2rC/EmnHF0M01yZdQlgNa+x2PAV
         om01oirulbP/RiWf15wZfIknalcXmf4aDZP/e+/D2P0jsYN8jKfIrDRt2PpDy9uaU8lE
         jUyw==
X-Forwarded-Encrypted: i=1; AHgh+RqD9/uztnDdQXFKXKiUuR/BFzSz9shVRsARMc4lwHBhbLE4ZCfDHhIm7NU7vfdt/HF6D+0VBRTjsA==@kvack.org
X-Gm-Message-State: AOJu0Yx/SeHCGBSIJaJppq6xyshVivtDGOxXkEBCyDli1Ou0zcLavqEu
	HolmRHUNgenMt+26py28BDBkPQmrJP1VZVX42Pd183Fwa+54eB9tdgZ220xYXicLKMA=
X-Gm-Gg: AfdE7clkgTDnPD+UCm7o+qmkRNGjbI+tWkYxAvphoaSE1lo6NJYQAi28HdkmyLwDrba
	sRjxgdTniQN5XpE/0U/sUAodWc2X8gH6qCPvRiyYjFDdkWBjSjSvQmca7yOKr6z17h+vmHbyFKu
	wMN1tD5ojz1B527Ns+u05Z8x3VY5o9Im0Xrob+ERJLYWutmYmoK3Knc5Az0F3NhYkkUAP+zleFw
	nounUbwG+LYZ6Uayfem79iEfhOW3+sRcDGbYtM1+haW2Onb1oXz28dY4Ly+bP9RnYrG263gLXzs
	1DQIJ5wWv423vXnXSZmQKADs5u3JP+UB7lkHeCwoveTuXPZVEMCScFQBdacHNFbikbWKbB7RzrU
	C43ve/WcPfCo1KK0oTuFI3vvpZXKdISmTXiGt0SOzYSN4DQ+eaOmk2EBHut5IG3VZswawCnZBd0
	J/xT1N8npQ7A7cyBSSV6RnjG1b6NBh9gdk6nvQPwp565s4bXF1WQ==
X-Received: by 2002:a17:907:9814:b0:c15:f45d:d98b with SMTP id a640c23a62f3a-c161e8e83c2mr362942466b.10.1783946205246;
        Mon, 13 Jul 2026 05:36:45 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c15adb30f98sm1026193066b.55.2026.07.13.05.36.43
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 05:36:43 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6986578d8c0so4517744a12.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:36:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr13fGiN7ThAknWW6GQPXaIh+Fc/PHfMjCewL2nILyOFCGo6v5OYry+9VLTHe0bGkbINJMJrMLgWw==@kvack.org
X-Received: by 2002:a05:6402:a29c:20b0:69c:7ac7:c740 with SMTP id
 4fb4d7f45d1cf-69c7ac7c96dmr1680487a12.13.1783946203526; Mon, 13 Jul 2026
 05:36:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org> <20260713-catalin_pto-v1-1-5b93b1131089@debian.org>
In-Reply-To: <20260713-catalin_pto-v1-1-5b93b1131089@debian.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 13 Jul 2026 14:36:30 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWBQ-Vn4XzbrfV31adY7cEjLvmGuwu5_x7rn1NBkEC5mA@mail.gmail.com>
X-Gm-Features: AUfX_myop1qSR0uweNQ9TGaDUdl1iHj4R-fufo4jIbPM1JPRHa_hqCZvJROVzWA
Message-ID: <CAMuHMdWBQ-Vn4XzbrfV31adY7cEjLvmGuwu5_x7rn1NBkEC5mA@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm: kmemleak: confirm suspected leaks with a second scan
To: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BEBDA180004
X-Stat-Signature: e5udhjc8rhpzbeng1h67731gjqnipcff
X-HE-Tag: 1783946206-384413
X-HE-Meta: U2FsdGVkX1+4PEZWthTS/siu++Bkfp2GpCcumbhSroKF0TpAnE4Nh7rfclf8ihEW9xkHffllA4QUz8j72Pj6eM8dJZLy7BRUw3N6Kyi4K3NHB+RWQEyo8kVBVVvOgf+ycEIGhJYw+uFff5J9j752YtWDScVnycdSftwkyzbbINXL0VjD66JQKVlT0enevMo80r10awH2Kk0Q95JjVRK3itRz5Sm4iYwNcaqqvIUaKOeR0d3tfkwr8FMT+qBfyVfMZ0aNhhSrkLbic5HDDgbxJKOmTBXM66et4eLxaun/rX2gEn674rm6vd1TXBCPjQCvVGc+ZyOXhRLuorlF6ttXGJbXU6cHhBHcJrrGWCWBBVyB+iXfmh1HJLl+9ouCZudEtsn/kGTLKjW5zn8uueNBaMTy6HV9ZXfeLCTp2WzPgLIMkb3b79j5On5yjo4FqqDlREjqbp+QICmi14baFZyns5uO2R/FZZ3yWR4FU4Y+ttjBDY7fncMswFgXdkvk0W9/zYYceSfhm2W2XzDXP0jazL5ijtASA6GDzA/QmjR/o6zgUXltEalUw45r3mtSFWTm0FBvzsmtce6kjPOYrps8XrfAyALHDDhxdYxMj3QFyVofv1tBkltobnknigAXCetjavD+olR9AQGIkIazxM9Yktk02YlFPIdfX9OFsNKrfAg8RPjUFxBB05HcNRPl8KwszlgKlzofoEq868SnKOVLRCdEJcrkZgFk2f+YHn5fWB2dJ8Vcsn1/Qj+hP8Aqa4p/x3g6fKiFtWz2U6xBWcXzLS/k4iZxYr5lw5h918cHbm6rqdxp0LFMuw/ddvDs+itOL1uvHzJ/g+bL9Mvj6GCmjqqIYk39IFPaWnr6MIK7nE2SDO0Vt661CQ7XMPtY4l1LE5/pKVUZtbpbvezvcR58UsDeM1wj+/6y01/aBRrGyUSzcuYhRbuus1z4nnmatZdbAzR5LcpGw0De6zyjS93
 Bw8QNBZp
 LseMkMAirMe/mWT8usaOgg/ZhrxYNVD00KQukHYP/LEzfgSendvNuqIjIjiiNd0+g1QSl99LiR5BrRb3k1MuBQcS8OsjdEgUqyC63aGCHZaecA5kUMxY8sOYRpsxABp47E5XEw7zhw3VUS4KPpLuAKsTSFVdfmnSfDlCTx3dlZcVtnMNC9tQijrkP+dMNMR4+N01ATe6evT6IWuFJtg2tFubw6Uw2SE3wa1xP/q0BczYfS0ADX4Q8Q9B5VTKC8G7sCqMsqBidAvihzE6xf3P/CRytl/9BGIqmnGMegEPlFznVcUh2Wdggrfn2u5nqDJNlMKC9Q/mG1jRgcL0tZT/1ivynEqrFXoKvH+fGW5wjV1DxhBoKIkULCqcsEx2Xi5ieA4znlSH1xFA69flEPkT199nM9BUyOW/6bbR35rW9JqSwPAxxjZcSrwCQbARu5yXB7DKA04jzMx4G9n8QUnK48Xu8A4WkdTyjeQ6EyjF9YukI//pAreyLgSkQdQNyGsM6RbWzU/kFMF1GHJmTv7daM58/IFovOYJyUyF8SgBiR8o0W0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Mon, 13 Jul 2026 at 13:48, Breno Leitao <leitao@debian.org> wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
>
> The kmemleak marking phase is not atomic. While the object graph is
> traversed, the kernel can modify pointers, free objects or allocate new
> ones. If a reference to an object is moved from one location to another,
> kmemleak scanning may miss it. We have explicit annotations like
> kmemleak_transient_leak() but identifying and maintaining them is not
> trivial.
>
> Given that such transient leaks are short-lived, rather than just
> reporting such objects as leaks, do another scan to confirm the
> suspected objects. If no new leaks are found during the first scan, skip
> the confirmation one.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>

Thanks for your patch!

For how long does this postpone the reporting of a real leak?
I am asking, because I have a few known leaks in my local tree,
and it already takes a while before they are reported.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

