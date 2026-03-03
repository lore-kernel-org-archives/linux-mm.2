Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B502EDEBF0
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 20:49:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DB16B0096; Tue,  3 Mar 2026 15:49:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DCC76B0098; Tue,  3 Mar 2026 15:49:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693E66B0099; Tue,  3 Mar 2026 15:49:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 557CB6B0096
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:49:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0903C17C4
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:49:23 +0000 (UTC)
X-FDA: 84505942206.15.4EDD09E
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id DFC39140012
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:49:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nACZJOsA;
	spf=pass (imf26.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772570961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5K9TC0MkEO8By22h3GqX8xxcKLeF0UtxgZ/D1gjfh8=;
	b=SrUzNwvoUe0OpdDS5UM231Mt7H17/wARu2qKLVOrVs4Jre8gcX72qhzPovPXL6oqpoUrDC
	GwP564PGKRDNCmTepR3lJOK6rnzMf9TuqBUlCgtsGzW760fXd5oeJsTEIX2gZ5SN/xgI1O
	TBycOfmJIuqHj7T+MPdnBbcIsurC0uc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772570962; a=rsa-sha256;
	cv=pass;
	b=25AnHbUGCOp/28eyIGNLs68IRX5iRd0OV+btX1+R+msoEinx2SRRnAwHfSKswfNBm4hY/6
	SfToV+0OdjYiE/+RhubE1x0fw/qBGspymelqBWz9YVLy1VlA2mokYO7SJI/DiMQwpwUgtJ
	ryTyOmRBa0I84dciFFt+77cNFA17NTE=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nACZJOsA;
	spf=pass (imf26.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2bdff6c15a5so165090eec.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 12:49:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772570960; cv=none;
        d=google.com; s=arc-20240605;
        b=T/RYBAfliN5Y/1LAA51xfIJW1zwjvBsSg3wETij49Wt0wjFmgyU98UgOEcSsfK0+Xg
         d/g6dLFBaSpIBZf1bCQe7CcqaLg16OMyiGlYf43AJwYP8ZLZ8aCQRyPIvWk0GESw3b50
         GXOUg3DvymWrbXCqpsHT78F70tlKP14GXCHOOqpElLAIWbk6LRrBsFvw3jlBNKFDAsAj
         7PaMi+15nMCRLsdGEdHVZNXM+NZR3I46R9Z0Yfe0Q/dZTKqXQAXWJIgoTpDu/UotlCS2
         UYvIgaxkxsr4ZHjQz0V369OtLT7G7twim9HXsCbHw4vYy2MaxKYXNfZIf5i7Q25FjEsv
         aFxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z5K9TC0MkEO8By22h3GqX8xxcKLeF0UtxgZ/D1gjfh8=;
        fh=M/Cgp857LYGFDWUVEaS4n/kv8T76tybGBScGJALbjFc=;
        b=FYNa0nau0OvJz4sF2S8VbDOme7TFzYbN7ookVD/tFrfZb+WqvrkRXHtl3M868nog+o
         Wuj90095XcN2dFw0ufIH5rkKCnd3Wus4hQE81sBJHtsNyUuZXHvwy0gSU/PDV4CmF9nm
         hMNzfiWowSS/5YicuAFq4wu9Gy9+HOqqYEgLfAWN5lBKTmus/ASe/6tI+OO62t7SJ0jB
         6vRq3LGkSc1jcpPIotOvrQS5KYFeQaKdrHI3YQZE/wWwSO3HFMWdeNxybklrH7rSxtY4
         1JNWc5pVtQiKHxAppgSo7EcXNsYCuns3bYlH3qxIpeVo0TKqcsxvK2mEsrw/UF+P2BkR
         qh+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772570960; x=1773175760; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z5K9TC0MkEO8By22h3GqX8xxcKLeF0UtxgZ/D1gjfh8=;
        b=nACZJOsA7vM6HJHDLnp4DlXPOd65zjhlkMyArbQa7ulXFrFDhFw551KmK32zjVN/eX
         Ot5hbWaszCp048IDLSCOGzqU/M9uI2bCTKWEP/My49d/zZG7guTp3slnK33Lr9HiSxAJ
         xUDTyVk9J0ZZuaFHTBSFuws/krYZFCussebR/3HZ1bDDLiRw+Zr8uWPG7+tQ9fVuJcLj
         L3oJPOmGPN5cserehRZP39m9CdM/4fDiAEBJFl9TsU+dpErg3ezftfCEPSVk+AVe8ekL
         nQXIfqfChKlWJLBZqRKDcZ872RAcgZsMls7WdRRnb0gm3BBSQfIMqEu6urxdyqacwSuo
         zHfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772570960; x=1773175760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z5K9TC0MkEO8By22h3GqX8xxcKLeF0UtxgZ/D1gjfh8=;
        b=GtGD3ceR5jeI1yrNnLKWaAv593f+5YtI4gJwCHuvlx20GNwWzR3x01YU3Kb2x9cMpv
         C24lgw0fRD7qyQXlsIEZADC2EQEOGhEebHug3M1/MQrsNlIc79KuiV1KpK6PJ//QISCK
         4HCpOsXeG+rW8nFSH1H3U7RwaTUJrf1b4i266/E1LUAssUKcw7EEFBQxLGFuwUacWCGG
         zm8YAUASQ//5TNba8jkXedYoWqilACd5RZvXxmDKlbnJ6PV01Qtos56WP61pNQdprcD/
         aaddwCT7/BUuT+lZb+yd3thkbLDAjopS2kNhR4W0qPMGNIfTmxfahkZXZq+AxT1YAvo0
         eRaA==
X-Forwarded-Encrypted: i=1; AJvYcCUZVKMAfxPRj0oFHy3/VMLBadvgpFzQc44sdCIcXla54kSUsBCJBaS5rGqtWxsoIr+vM4ZExjB1Yg==@kvack.org
X-Gm-Message-State: AOJu0YwTwp45aWe23Q+1Wbu/e9xNK34W05MqiQuh46sCEyCQbxiqmEK8
	9fERvRk7lQxY2GqqvVyi/Q+c15q04lc6O4fdA4fVgY3RWt1x+r2XSLCY/Whc5n7dx2UkS2QL39j
	s1nrQ8gikWuBqFrrWbi19xB0ucld3KHs=
X-Gm-Gg: ATEYQzyh3MPENaUFUr77xxYSvlJTbcIe4xq+TZ8XfnjXi3YbZEezc0T1gKAwx/8dSFr
	pJR3bFVTTfpiecW0me5hlJBmdwUemPqwNPV3kCqxVcYN56IHjNyLARVx7STkx3Sg8HcNKfLTFHV
	9Top9DyEETSPHITOokvFUZHPPW1VmAVsmY2JbpigfLrV8/ss2cBNLA/ILHSLGmD0ELfV+wa55Pe
	Y2z3A3ugvgAH/mibxI8CCOPQe37CLvja59iD5GlUgFiWldp6UgRPVGNRyvKeLQe8v6v8BU8X/oE
	FJHzyKeEekqGcDDaEcjNkmMA4UDIfkbono02qQuhNnS8ebhAEov83D5G4ZFWGZ5ou/rL/9+6Kqx
	w2xRaQXgmpHV0lC+oAvJopD39
X-Received: by 2002:a05:7300:231e:b0:2b7:103a:7697 with SMTP id
 5a478bee46e88-2bde1d4bc79mr3350396eec.5.1772570960234; Tue, 03 Mar 2026
 12:49:20 -0800 (PST)
MIME-Version: 1.0
References: <20260227200848.114019-1-david@kernel.org> <20260227200848.114019-3-david@kernel.org>
 <aaLh2BxSgC9Jl5iS@google.com> <8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org>
 <aaVf5gv4XjV6Ddt-@google.com> <f2f3a8a1-3dbf-4ef9-a89a-a6ec20791d1c@kernel.org>
 <aaVnifbdxKhBddQp@google.com> <5f8dcb7f-9e4f-4484-b160-3a9ce541d63c@kernel.org>
 <aaWvtn48X8UizaaN@google.com>
In-Reply-To: <aaWvtn48X8UizaaN@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 3 Mar 2026 21:49:06 +0100
X-Gm-Features: AaiRm50lUTXkxHRxiLsKpWNGF1HIgeoo2SkrDpQfQSxM22wzlSiellk8rvn7q80
Message-ID: <CANiq72nK8P1rUYw=y3fMzWZR3f_mW2v0_LSLWR1i0dQTtOqu2w@mail.gmail.com>
Subject: Re: [PATCH v1 02/16] mm/memory: remove "zap_details" parameter from zap_page_range_single()
To: Alice Ryhl <aliceryhl@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DFC39140012
X-Stat-Signature: 3m4znyjtey3hys8j1wjk46a4ikpmdusr
X-HE-Tag: 1772570961-522164
X-HE-Meta: U2FsdGVkX1/282VHczBe5clkOUH7nHSezy292nT9fsGZFYIzmgONA7QWTIOoVv+W/18Q/38OvnVKtX7nwxfeHpJK5zmFv2newSrww5t5Uqc2DJDzbo0BYnRx3lCjibsehEy1SZvy98pkKkdmcNaveYvwCZ7Rt5K1fsI4YJ/HmAY0YZhv3NEvzlyw0ke2s6rPXr/PKMwy01AaNXQIW1H7I3XEUE8qNWZYZFHJ+cJ+wokPhZrioib1UZb32pvARzmuW9ANzVdlcLSCNUXFRy2/djDDvAzufYXX7Eyz78DzIokWV7+Xiyib0h1d3WqJ6UW/92yavcdMtjbH9SXNAO4iuarWaMzleIR37Bwm0bNEaloveQeR+Y2M4PIunySeJdmaKTiP8NAGLRAPxCVyvFBPd5l0HHM3D1h88w441YrR7fokrVNNcBeV2lOtqRc9xmcZwjdRze+xHTOkmwXWZMFpuoPpdLNOGgn67Fc2A0nbOTc93U6E5NeSK+J4F3ePXRKlG3udymS4Oz3BcYT7c56cCHXv/rXA1jTnXVUefhAFpmWKa7WSSCYlvYzxUlPluIUcZViA8lrv1suUKyQ3hvAOHYb39cSdgbQNBnrkjyOurqxOGzaIZgMdvgLgSRcOeCd5rfSYwBRECPXXXVG4b26hBXX8LVYoEAfUvqW6ZnKnX4vqPUKVwSLjxvChUfwfW6NBMihZfLQx2UZFjR5XR7BwOPJTxRsPJ2UwehTZU8zXbHHArewvjRSQm1mdBy+WaY9l0Mxiu6M+/gWW9GcayUuyT8XHmh0GSSCE200uHQjh2Fq41+bmWJFULeGBX6I6yxXWr/WTqspzKPI8QdKJeiIjU1fLWMxewuQVfSzOY6/n6r+7bdkErArlNwdHWOlqko/PBQnR29U3XegoFtuaIVkBy6QIxS0dBVfS31DLwFN7EEz4PemiJKjgbX5tY1NeWSblAMZtnqYJRS2chkCrg7R
 4o56kXKW
 W0XxG5yD0ydMV2TXlLJEmPMj62qC8bTJAovhkKLcQDhYxX2Ua4X0c2sAYMhCyWVUIOudi9sevC+JJ06o4c4DUMf3P8BufGVdiKJ21wwyyUMUZ4Sr0JjNDfvbtOQRMG0NjUbOTYXnvjUMZnSEoSmb/1U7WECcT8qCEBdxaMrbTCHi+POtqCvksL9m5v0unialh+j16po6NvfCyE13Kbt0irw6q2wKaTaPQppnEgYCNT93uCJguTPeaXJqQ4T+gLofFwVjMHANigefqypJxJapBvT2MTbG9mOkGndPdCINLqCHRnG00uyyZ6L4PnSRU4p4npREHmiXVe1Q1Ue8DJG4m0HrYiX9xkdmD9petWUSDIIBantKyU+AS2DvAFkdgPBvTTObWfSoU/sjsiLbjf17+nikQGc8cMPd7NIVvSN+TxNLXBljneTKSmHly+p+d0JjvIYni/EBl9ygmpXdEcE+io7vpYmdJZkd3SJRTp9FFsHJnJoxRayGcWpYjdta3ztxYxudQqZQDwYPf8x02aBMw7io1fj9AtCIgkgJHFfSxTz0cPl7mY4eBPHoP6nILup4HBxcpumgrpDKmFLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 4:41=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> It's not relevant in this patch, but another thing that may be useful is
> to add CLIPPY=3D1 to the make invocation when building normally. This
> causes additional warnings to be checked using a tool called clippy.

Yes, please do use `CLIPPY=3D1` -- the build should be Clippy clean
modulo exceptional cases that may slip through (and soon linux-next
will probably start reporting those warnings too).

Thanks!

Cheers,
Miguel

