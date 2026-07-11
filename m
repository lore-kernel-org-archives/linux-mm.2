Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E284C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 12:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1886B0005; Sat, 11 Jul 2026 08:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6BD06B0088; Sat, 11 Jul 2026 08:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C6D6B008A; Sat, 11 Jul 2026 08:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88CAC6B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 08:13:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2461A1C3F57
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 12:13:22 +0000 (UTC)
X-FDA: 84976385844.20.7F5C591
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 28E0B4000A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 12:13:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nKJsKYI9;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783772000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=80vo3JIjnCsKn8zo158HX4vkfRXd32w7uPzzJAtLaF0=;
	b=FxG/72WKZl4Me1XiJ7JACVNskK8UbdnqR5LxOPSPHeL5Tha67UzH6QVuwoKxCVcETTz/9d
	wJM6D8s1NPpI4xfHcuPFHe6yZonySNBzCp0WpYmfP2+GJoenDMGEtH6fsIPQJMqZnl7SFI
	XorNMAao6f/mKZRTAEzkiM3F0Mq9yps=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nKJsKYI9;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783772000;
	b=dRh2YCOPXkt9ODo2Gls3czS2+3NTRb9vpg4n6I17z535fjO9xMJRt5VQnwX6a7nIvR/oGq
	8meZe8S7tE7VYYGqhD+XJNClHQPuhZKoZT5Sg8IHnKFqk4CHv+4mnKDNHRsN9TLN94TyTV
	V+g8yz2/wa2t9etcrBLgvsALShqOZ20=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3860f32307bso304535a91.0
        for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:13:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783771999; cv=none;
        d=google.com; s=arc-20260327;
        b=cTHSUpFpAprFq0/wNYDtUF5pzG4xQpE83WlueoQTBqx43XZ6ihReIE0cgurZLO3s+h
         cYVb7RAhLR+MRmj4BKgUl/U+xl5Qnf56kHtEqlVFR+T8VHMOnHAUFr9NVgPvy0FTklXS
         OLwF1X21vAemQ9PTtSDzigxYGT7aEtbBh7JHjvXoOiQm1RpObPPBTFGDbCArNs1lZ32f
         u0bgMlLxSOzMqD2segVh4XllZH4dWeixli+X0zdXT5ARHnlAYzD+MiKDp2uSWzSXN0Ey
         pOBsWhC6uDB4pqwvR3xaE/sNAzkmyxtSrnZEkUX7hOUfqc5lJTwBIGh/Bp8CfVmp3dYY
         7M8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=80vo3JIjnCsKn8zo158HX4vkfRXd32w7uPzzJAtLaF0=;
        fh=nuV1JHpJzeEji+K6XYwylfFSbruT2+k/U8eJU2XWreM=;
        b=WCnb16SRR7Ij//hlTsZWu5du2cHdi/qSZ4OeQdjMxpf0vBj+LhtxBOG3sRUFB9R0Kq
         XP7MKheo43pBZdeiJsuewU4qTveM2peDnjIwiwZFm12kqR8lIbsAVn/bCvZyyNtaWL7z
         +8Dg1zG7YB8jJpO2JO98UG/Ts5yz3OIxZUMKdWcx16IYNLnem6Vw7njA2ecxHv2b2lIK
         yON647uT6D4ogZwOV50dwd1EgRzS/85MZsNWfVpKVVJz3Gw9UiBEkA5jm/Dz/JlsYiX5
         ncwEPtMqGywXreE/sQd5qk9lsFIutLI5+zlXIcZoRZP6mMyxIOmyl4x+Ac+1jf3efj1m
         0Tcw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783771999; x=1784376799; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=80vo3JIjnCsKn8zo158HX4vkfRXd32w7uPzzJAtLaF0=;
        b=nKJsKYI9takVLhKvLjQz3SJe7/uz0cKcigbxkqdssp5E6SWuSr7f7SjtUlsY1xSt+F
         W/OUWEHDBzjam84qKvBACf2sIlHXz0fMR4wXnV99WprJnh5/JBPO0omL8hWQ9yyfBmwZ
         Vvs6HPVZU0C+GhhDxZM0IB7dxczURAXRxiqvEHO2zcnRBOy+7vQ1tM3P1XZFMd47TZ7d
         0y5t5N2KUNqX0DvBFe0yrFKL3qkxIn8yg+fe0Fgscs4yBRJXrz9uzZSlSqnWdthKVeAk
         wySJVtni5tTEwJpBqwkR4c+32XLy6UZ6FJNLUkKMDO9Lg+OnbDtF191Ln1Bbjr22rsqp
         A9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783771999; x=1784376799;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=80vo3JIjnCsKn8zo158HX4vkfRXd32w7uPzzJAtLaF0=;
        b=I1uX8LnB5/Akm9EyUbhv810O2mfsMQ8T0rV/fhvoS6egsKDMoSOmzaswO/czp0/DE8
         l87NLu5mfB9D0h1hUWOB7F9nS3TNoAduPL8yRtWIGCtRHVKnY6Zexs7J5tuhvUp52HJy
         fBJu9QVS6fKDuxpcCKCbtNSyViwpBEqcrqO7w5MKyvZXc1YnGDHkXY/N4/tHqNVLW0Rw
         wghIIM64g5ieLva6QDb1IlaoA92bq5IUrsMx4uLaQYqu4SFDIVcMcn30Qs9Cf1BaNMqd
         rkFrwlwDWcxwoOThlJRx9jbOG9CKR/P9nLDFk1gQVo5JfbMCCvxV6iebYV7sADJVuZNz
         I8/g==
X-Forwarded-Encrypted: i=1; AHgh+RoIDb8IV18BMJCU3Zbw+j6gZBl8Y60LHmbfj62VpT1An4ukFRgDeAp7FuB4/QIbJYyPN+WGT3XSoQ==@kvack.org
X-Gm-Message-State: AOJu0YxVfE8NRUfvU3vVFrfjmNkUutwIXaQR6eXlpjXIqNxl0xh33Y+Q
	UZ9SVVFW8++Q0k2lQf3w50ik6JElRaw45KbWnIHBwSd/mdEpD4DApJipHVCA6dAEZwobqCdUn35
	hVWvniUxZDMEdS5IKRyj91ZntQHCJLnQ=
X-Gm-Gg: AfdE7ckMr6heznw3vb6hI+/BzFC6gS6jtVLjqA07EPaJ+f2CdiOvtzSvVejb5cNH8+u
	Utjqn6vZcL7T28o5vfr0o5wngW523iZXHroutTSk4NaGjaBZ05DsLOGyAs9QThtKkr0C558yWT1
	g+B+zAaKCmaLxul0vPJfMYMqgIpoIh9Y9W0Au2AVmvIxJuD9dIzSWZYCD4WUK6KXDCvovx4dQBj
	LN32Id4m6jGpWQgrWKQQrHxfmGuoROia6PbL8P3voDYJv038538sdnVGD4f0SbzgAFy96Fi5v9p
	cGs5DKaOw8OwYWHa+cdLh/gGWoa0TJdzLAzU0NPkW2/tbie6ZjMLsDRzoEjjcWX/hNeLN96ygRr
	EyXx8Px3T35kf
X-Received: by 2002:a17:90b:4984:b0:380:9cd1:d985 with SMTP id
 98e67ed59e1d1-38dc7c111a8mr1909664a91.6.1783771998816; Sat, 11 Jul 2026
 05:13:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260706061928.66713-1-byungchul@sk.com> <20260706061928.66713-40-byungchul@sk.com>
In-Reply-To: <20260706061928.66713-40-byungchul@sk.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sat, 11 Jul 2026 14:13:05 +0200
X-Gm-Features: AUfX_mwWK6GqFCLIKCx9ivosmcno3i0b64L6R15FyNFXSSwj0HKdZlNefQKWcgc
Message-ID: <CANiq72kEo=bGcHNaSA9JZhv4iuE+YDvu0kN+Z7aopVp3=2C+Wg@mail.gmail.com>
Subject: Re: [PATCH v19 39/40] rust: completion: Add __rust_helper to rust_helper_wait_for_completion()
To: Byungchul Park <byungchul@sk.com>, Gary Guo <gary@garyguo.net>
Cc: linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com, 
	kernel_team@skhynix.com, torvalds@linux-foundation.org, 
	damien.lemoal@opensource.wdc.com, linux-ide@vger.kernel.org, 
	adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, mingo@redhat.com, 
	peterz@infradead.org, will@kernel.org, tglx@linutronix.de, 
	rostedt@goodmis.org, joel@joelfernandes.org, sashal@kernel.org, 
	daniel.vetter@ffwll.ch, duyuyang@gmail.com, johannes.berg@intel.com, 
	tj@kernel.org, tytso@mit.edu, willy@infradead.org, david@fromorbit.com, 
	amir73il@gmail.com, gregkh@linuxfoundation.org, kernel-team@lge.com, 
	linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@kernel.org, 
	minchan@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, sj@kernel.org, 
	jglisse@redhat.com, dennis@kernel.org, cl@linux.com, penberg@kernel.org, 
	rientjes@google.com, vbabka@suse.cz, ngupta@vflare.org, 
	linux-block@vger.kernel.org, josef@toxicpanda.com, 
	linux-fsdevel@vger.kernel.org, jack@suse.cz, jlayton@kernel.org, 
	dan.j.williams@intel.com, hch@infradead.org, djwong@kernel.org, 
	dri-devel@lists.freedesktop.org, rodrigosiqueiramelo@gmail.com, 
	melissa.srw@gmail.com, hamohammed.sa@gmail.com, harry.yoo@oracle.com, 
	chris.p.wilson@intel.com, gwan-gyeong.mun@intel.com, boqun.feng@gmail.com, 
	longman@redhat.com, yunseong.kim@ericsson.com, ysk@kzalloc.com, 
	yeoreum.yun@arm.com, netdev@vger.kernel.org, matthew.brost@intel.com, 
	her0gyugyu@gmail.com, corbet@lwn.net, catalin.marinas@arm.com, bp@alien8.de, 
	x86@kernel.org, hpa@zytor.com, luto@kernel.org, sumit.semwal@linaro.org, 
	gustavo@padovan.org, christian.koenig@amd.com, andi.shyti@kernel.org, 
	arnd@arndb.de, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org, surenb@google.com, mcgrof@kernel.org, petr.pavlu@suse.com, 
	da.gomez@kernel.org, samitolvanen@google.com, paulmck@kernel.org, 
	frederic@kernel.org, neeraj.upadhyay@kernel.org, joelagnelf@nvidia.com, 
	josh@joshtriplett.org, urezki@gmail.com, mathieu.desnoyers@efficios.com, 
	jiangshanlai@gmail.com, qiang.zhang@linux.dev, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, chuck.lever@oracle.com, neil@brown.name, 
	okorniev@redhat.com, Dai.Ngo@oracle.com, tom@talpey.com, trondmy@kernel.org, 
	anna@kernel.org, kees@kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org, 
	mark.rutland@arm.com, ada.coupriediaz@arm.com, kristina.martsenko@arm.com, 
	wangkefeng.wang@huawei.com, broonie@kernel.org, kevin.brodsky@arm.com, 
	dwmw@amazon.co.uk, shakeel.butt@linux.dev, ast@kernel.org, ziy@nvidia.com, 
	yuzhao@google.com, baolin.wang@linux.alibaba.com, usamaarif642@gmail.com, 
	joel.granados@kernel.org, richard.weiyang@gmail.com, geert+renesas@glider.be, 
	tim.c.chen@linux.intel.com, linux@treblig.org, 
	alexander.shishkin@linux.intel.com, lillian@star-ark.net, 
	chenhuacai@kernel.org, francesco@valla.it, guoweikang.kernel@gmail.com, 
	link@vivo.com, jpoimboe@kernel.org, masahiroy@kernel.org, brauner@kernel.org, 
	thomas.weissschuh@linutronix.de, oleg@redhat.com, mjguzik@gmail.com, 
	andrii@kernel.org, wangfushuai@baidu.com, linux-doc@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-i2c@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-modules@vger.kernel.org, 
	rcu@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, 2407018371@qq.com, dakr@kernel.org, 
	neilb@ownmail.net, bagasdotme@gmail.com, wsa+renesas@sang-engineering.com, 
	dave.hansen@intel.com, geert@linux-m68k.org, ojeda@kernel.org, 
	alex.gaynor@gmail.com, bjorn3_gh@protonmail.com, lossin@kernel.org, 
	a.hindborg@kernel.org, aliceryhl@google.com, tmgross@umich.edu, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 28E0B4000A
X-Stat-Signature: fc6cpudnn9okiib9oqrqrsk6wdqdo51q
X-HE-Tag: 1783771999-413302
X-HE-Meta: U2FsdGVkX19EMnLNpjp/mxoXC7r3yTPlIp0hEXvHJubNGGtdLCYwNTh8miyNDb/PUCYH/YhoPdr4uTRtL7DIg7e4KE/daYzqXZtl7oEAJsWq+axR2htIKYWTIsi+1Ju2aetaJMj320ZpMpIVHy9dT7ODFsdjmL1t5XfyFG3EYNGumxCjXT/f2Q1hbKgZY/F1YTSdvBZJirUj7c3yaxcQZ0fqJwKFXV/hL8Oe57iHAwL4+N8YpP+kwReWg0h1qWjf/m0ofcahvPzKWNMqJrD1Is9QSgt86gUKjfqLsEX7D0WUp5bnN4SyvcnC4/PzL14w/JSKQkty8kZBt/LN+yEMmXnF3kI5MtN9bRkqTAVyq4WpCefj6MdhSRaue6sbFR9Y+KGTT9l6KD/MDy/QRKUF8ure30QyKx838AMwNOOlj/xqoTWBikiDyPsUUcYW1cX5FSdbJRCq6LUsYrCb33wCJmTv+9qYomkNzFKVXKOhELGax8iMdEhJIX+gNGy1AkYQbPgfTUj6R9vHgmjzdH5tr9w+LX4kYiPc3leh+ASid8gOjpzjvzPi+527NgXRUZSF+gixaESpKFJPhdPJGid8bLcIVT3tcnGHoMzsTSimBuoeI9NljGBsVZzd7y12UCHzYG6e2QDSc5kCl3fOoX7K/T4xm49OS5UOwE9ft6s38MlJTxJ7HlEZZqowh/WOCE4r9wVyKOk05s78aAkz2/5SL+plCTanOUN9J7Bg1ZFbx06e5Xzhk0m9HcJBCMNHcUmYq6ZVKtRZ6cjXKDkUH+JDm6Wa32N+u5DJb54PvVuy7fpoOWh9XHxgMdVJnARnK/KmHwLZzwmEx2CZ1vqF+4pg1EyWv3HvK5FHsu323UJgGhfOlQk7q5DJr3OtwYwBd/6XVFnq6Pgv8zw6jrap0XcX728q8bWZ5eJGjX7FdVgmpbtrFCr6f77Sshb68fXB4gK1lDY3SuXE+RgtNZ/TkKm
 w1L8YCv9
 dDAq5u3gyhVFijYE/lCkjPxqSHFMBTxw4kyMYbPG+ZujEBx6gD2cHyTxkGgrfUp3w7xfg/WJXgsk+zvxJ4ls72gyvKqu97CGecIwdC50wW01uC15fk4MevIs2KaW1+viCl94T82y2NeybAzJb24xgqCvq7tvsvT1WlnWkbyymH3noQrnY0bC5fDxhywj2i0L+8GHey6GSJr7AJvXzv7+tNKKFcealeyrisvcEM61SLnCUfC61BzWu3u7FTefoYH+la8sy2ifcu1425OER4bmkv1V5ZKAmp4ZiXTCVhy+iIsDC+zfTbXb3WiDZQvtwUxYnw7rMjHiO7iPnslcsI4wX3rFhRD3aEQ0qCmyZqCitVs8R1mJP77zkHUtzqx5hJtOPJXxC9tSYejq8FzwSIsRDyLTbTWTiPibWWovBmeJEwvZ5f8K/H0Zk2E/3PRBWUwzMAdfvd1HM3MPO10rQJ6N922SCtaTtOsMygGSRRr3YV33q8ylnA/gXNeU73hIMFQwmhTO/shoz3DHyVN1wzf2lEruahsur2kyCIfRNSiZOtEpXo+JAG3zZfqYKV4CmHyyl3xMmTYX7GspDFLWba7MnsuCwzssQ6r1LPIRKCMIQEiP3QQcQXNrzeyQgXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 8:22=E2=80=AFAM Byungchul Park <byungchul@sk.com> wr=
ote:
>
> This is needed to inline these helpers into Rust code, which is required
> for DEPT to play with wait_for_completion().
>
> Signed-off-by: Byungchul Park <byungchul@sk.com>

Apart from what Gary said -- why did you need to do this in a separate
patch in the same series?

Cheers,
Miguel

