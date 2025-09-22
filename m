Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40878CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 21:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA088E000D; Mon, 22 Sep 2025 17:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972C98E0001; Mon, 22 Sep 2025 17:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861C18E000D; Mon, 22 Sep 2025 17:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD268E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:23:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16A2A851D3
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:23:53 +0000 (UTC)
X-FDA: 83918163546.10.A576CD3
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 396D216000B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:23:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GF5holo2;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758576231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lnFxC2hCuopFwp+eEpKVut/RzTPbk9nhoGROWJ2SSw=;
	b=FLeAiSGD7eU4VpW5l/5jbzolBdVvSab/yEbLUdLsUAHAft8aDn3SMbIwDN92wgoi9tlCqx
	fQ0PjnlPGeXLpaMCy8VBYeDaVao4No4WsAtnj7lSvq53t8fSiXfGo8Rt0QWte+9ErqQjNi
	j728XSBJrYro7Oo01f5PnKvNzCZBYc8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758576231; a=rsa-sha256;
	cv=none;
	b=EyYEyrDcaVF9dtoCHCGUtrR+COFKoPrHge2KvBkC+k7stMg4wfhho5rvZ7m/RuKjYzDC1D
	PYkpr+Ewm600fgEQPUVzqmrsoE2AihERIKXQCC0V4WGFZQdJVbT2dWVzrZXP26a41PvfDv
	QAgNEqDwuFkhyA9o/Bn1Q2mMhk/ehT0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GF5holo2;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-85059d52039so53996885a.1
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758576230; x=1759181030; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2lnFxC2hCuopFwp+eEpKVut/RzTPbk9nhoGROWJ2SSw=;
        b=GF5holo2u/AoGvb8668Nooy9esa1JCh7lGgv/18nhh4Xr1p9KKiaS6m23o+mWYyAXm
         wz5YC1zAFYk9L9luVS+NUgP58wlf7n2yCj4Y6gtIWsPvIeBbIx7F0e1HpJyv1OeTzBOx
         ACf4I1J2Su4N7a40xbvzgOdx7EpGnxcEN4uS4rVu4JoUHmfrvGETtATOg0FGpqqDDcoP
         QIsQgCNBFuU0GlgIjf+kx9Tx4ffAQldIZDMgPIn8wqYRdrBAMcdveAxolCe3vv5dTah1
         BPVCKMX/ILvSBtCx7ge7o5d5O8ipdUVxfxiR1WHL4tyu5SDGfVnBN/FT6rhIevJQnPW7
         QI7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758576230; x=1759181030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2lnFxC2hCuopFwp+eEpKVut/RzTPbk9nhoGROWJ2SSw=;
        b=PICDKvcBpQACVpO4apLjC26xRrfSW/eXXtuYjANmsCeMG/3Lhreh28qgR3cRRgw3Z+
         8mrVHLbHcGcFlmCFP1fQbxpO3KYo7qwLjeXgKea204J8i9+oZ36zfoiZzPYWPwNh/8ST
         B/6wLjsQ+cjPeltcN3SfCUsz3KmTZBhsTUibwGNhCbcUBUW/zggE5xSrPp/Lz/ll7bgO
         AXiop+8RG10bN6rlvpNOtYLzyFM0/DEz6ARrp5iv0uVUN3KnvPMJX/PG7L2lYJn6AKOb
         J1h23IvAc601csde85SNFPR4YIZ8Fpmognr35VBkV2TMvvxiTUm3o9FlnqiSaPjKpzd8
         1L/A==
X-Forwarded-Encrypted: i=1; AJvYcCVKCf8d2NGV8wvfe/DSG+miB8NeHNpgfv/5zsclEgRaOSd/R8X3ac7COj2xINRWcyDVou432USlFA==@kvack.org
X-Gm-Message-State: AOJu0YzpPDf8dMtnKC8GUjUZE9cIczGTGbgefiSS+CnVuHMrX1vmtII+
	2I07SrJw3sf6neLnqYk9EI3hRfdetTN9GFqsQBZVqi5u1ciEDktRoYubABEPmNxZZ0ulU0Yh0Mu
	8tWW+xOnwccqH0miMkkchWM4sdFVae2CJayF/FJvAqw==
X-Gm-Gg: ASbGncvtg+Zj8Q5ylGkfzXE/RfK5ynNGxRkyY4kz5kP+yr5g2PpyE4IYutrBscD+Mqz
	Zo/ktt5o9seIPUidMWqHH87t/Tr5YZFnDLNnJN+/bjk07ur/893wQSNCjgWdXk2QRHyi6FUzQJ3
	5WPLF1vdMX5g9lUfLJ0OFSTKELCY09uDMzspuHG0rp19EmvCeWii3/L72mk0agRTusTr8U9FQzS
	+p2
X-Google-Smtp-Source: AGHT+IGQ9mQPiN/GEI3fU0tJWSP0koWA24hj8YVPEmzR9zP1Ams6poNzbT8y3Id+rBzzR1NASM7cdvLBk2yOzooAwSM=
X-Received: by 2002:a05:620a:4724:b0:815:630d:2cbd with SMTP id
 af79cd13be357-8516aedb8cfmr51934685a.34.1758576230071; Mon, 22 Sep 2025
 14:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-18-pasha.tatashin@soleen.com> <mafs07byoye0q.fsf@kernel.org>
In-Reply-To: <mafs07byoye0q.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 22 Sep 2025 17:23:11 -0400
X-Gm-Features: AS18NWDQlfdhKL59fadbKNdAGgk8Zbp4-SjH2QD1Po4tMMREBwUluD3-7f8OR8s
Message-ID: <CA+CK2bD_-xwwUBnF4TBCBuX33uL6+V_1nN=0Q8_NXwhubTc8yA@mail.gmail.com>
Subject: Re: [PATCH v3 17/30] liveupdate: luo_files: luo_ioctl: Unregister all
 FDs on device close
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 396D216000B
X-Stat-Signature: yy74yoe4i71meeyqqoccfkp51q7ufnqi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758576231-423193
X-HE-Meta: U2FsdGVkX1/4nVZN9/1AN/fPBf91I+/mcByegY4EpnXjDSPXJsb3yLs2YneWsbSY0SIq+Sci7QLfYN8YMneeALqWbLqffplnk+Le1Z02Ci/zUgrRIpIW4vvJijDTDFNQ8xc2AM0FL/vypT4GCk/FefqsOoEriNNpA4ZZ+jTt6diRKQRyxNlZGifO1oiSyTKtmSIxj3m4YBVzStvy1AXwfrE3LKOtJJHTPQ/S7jDFlsTI8MvtlJ9X/Q0h0lgsP/ELTwjmDXo3KnSoOsSrrAj1hDOyCly62qWMpT+2BjqSYprnp/vbZWswZPcxB0JjAO9WtJ23MxYvFkI04669jyv83YCtVvwsRxVt8TIITw0GZ+koSQR9H3ofCeQ+a4XHtg3UacZmaVmi29onCRtHQKasC6h1ikczGfAs0nqvSO9REE3B+FbvDxo/EnhmAVZnL183OtP/L/Vrh+e051rZj8D5qHSX4VFTp8ge1jisW7V+En0416h59T2bu5w5kfGKL3ERHQoR7LwOdqYlayC8PdcIwxDviUySfc1NDvshZUEzHPb6bNPjANQxcKnyH5j6hMqsUxo3Nmr3a7fHDDfrAWL1mWPp3Bc0L3YxCAoXLqhqyJKf/2yqeGCIlc6rZrC71ynzP8M3j8w+ZcfH7AUMmlabJ9eA4oCTP9dvIlV51AECz7tOZ+eifZic8rlwzQOjXqDWMNvxQ+UfHfs9VQDWbF9w8mJ2fYdMAJqKWqXFata4tklERsDmLEuSQUoGpEJ0EwlCa6vMpt/DQS3KkHI6oTDJRBHsIxqYg0P4t4DQN4tNQ1Y/UOFKM6QV8da1TTwlyGugo0IIQDhlJn3z0JpQvb7ZzRstoGuxgbJC39iZ8D9SuUdZ1E/9bnlGpggun0miph8yv466TvXeA+Fob6HWIBXaT3rLqna6mtdSChN47WCCNCN0VQx8tKLgQVkMjHl6qg09zbkao75v0bs9ro+R1UX
 rjWVww9W
 E7zye1fQOkh7fvB02DGL7sdGGN4P1SBlZ7qjJbua5F4rzzme3Zap7+QzZ1MQkprYh6yRRh60r0abQ9RuPiSdH6KVdvmNnYX7+y5HtxmpPq3cEcFFQJptK639GKSZvqPJJ1dAaTOHc4UhVRSufuQEqml2j7C6DoON4TIwN6o8v8ohIE92y+RkujvabAyp8/+RTTjevqg00IqweQAmBbH868XlEybbyCqE0IUif+4bxp2dXXh6fEQBIVgQEBtOyTgcIvcFjMXuFYhqpPqcZ+oPboOtqkWHJxrh6MR94t/mILbRoZU9+LRUNxGyo/5pnq72hPE4hL4Wbe3ZaxCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:34=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> Hi Pasha,
>
> On Thu, Aug 07 2025, Pasha Tatashin wrote:
>
> > Currently, a file descriptor registered for preservation via the remain=
s
> > globally registered with LUO until it is explicitly unregistered. This
> > creates a potential for resource leaks into the next kernel if the
> > userspace agent crashes or exits without proper cleanup before a live
> > update is fully initiated.
> >
> > This patch ties the lifetime of FD preservation requests to the lifetim=
e
> > of the open file descriptor for /dev/liveupdate, creating an implicit
> > "session".
> >
> > When the /dev/liveupdate file descriptor is closed (either explicitly
> > via close() or implicitly on process exit/crash), the .release
> > handler, luo_release(), is now called. This handler invokes the new
> > function luo_unregister_all_files(), which iterates through all FDs
> > that were preserved through that session and unregisters them.
>
> Why special case files here? Shouldn't you undo all the serialization
> done for all the subsystems?

Good point, subsystems should also be cancelled, and system should be
brought back to normal state. However, with session support, we will
be dropping only FDs that belong to a specific session when its FD is
closed, or all FDs+subsystems when closing /dev/liveupdate.

> Anyway, this is buggy. I found this when testing the memfd patches. If
> you preserve a memfd and close the /dev/liveupdate FD before reboot,
> luo_unregister_all_files() calls the cancel callback, which calls
> kho_unpreserve_folio(). But kho_unpreserve_folio() fails because KHO is
> still in finalized state. This doesn't happen when cancelling explicitly
> because luo_cancel() calls kho_abort().

Yes, KHO still has its states, that break the LUO logic. I think,
there is going to be some limitations until "stateless" kho patches
land.

> I think you should just make the release go through the cancel flow,
> since the operation is essentially a cancel anyway. There are subtle
> differences here though, since the release might be called before
> prepare, so we need to be careful of that.

Makes sense.

Thank you,
Pasha

