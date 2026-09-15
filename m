Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7053C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2EAB6B0088; Tue, 15 Sep 2026 19:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8D06B008C; Tue, 15 Sep 2026 19:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F5A6B0092; Tue, 15 Sep 2026 19:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5EC6E6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:01:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EEAA120598
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:01:54 +0000 (UTC)
X-FDA: 85217520948.24.CBCBF07
Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	by imf08.hostedemail.com (Postfix) with ESMTP id 22689160007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:01:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=IRvtUagb;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.229.205 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=IRvtUagb;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of torvalds@linuxfoundation.org designates 74.125.229.205 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789513312;
	b=rlmvMbM9bOFQQsMb2+xaULppFv9t8eZb/123Okou8Xu9kbh5Cmmrh8b7z0EHVrRk/mmWkr
	nEtYbnluLMMkgnNY9/ShK1Y6As0celK5CFl+oI4rF8S1DQ/asQX0C7voea7AwMuREHbg5Y
	F+JTuq8MIVbnY8JvXztzXJMEyUuz71E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789513312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7NEEN5klK6sYQ7k8fj+V0z2WeSFVNwjy5fJJIdfiMPQ=;
	b=IHpSKsoAobs1L5IkOrxYMywaryeUEt/+6NRBR4V3YQZNdgtvXcF0j1QKg6v6PY7Yk/9anW
	pjorVKMWTVjE/NIN6k1RyVxy9dg3HHYeIgkgd30uqmeT9f5Bu5TY8U0EQ476uS09jn3fhy
	qEkj+JDlyXZ8JLZXrHdVlEq4xXotSCE=
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f1744eso258499e87.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1789513310; x=1790118110; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7NEEN5klK6sYQ7k8fj+V0z2WeSFVNwjy5fJJIdfiMPQ=;
        b=IRvtUagbIWuFp0u7CJkgPpp47Gb/Nu1O6DOvmv6d6HQJsH5zHdAOgo+2DdHRFCiC/u
         vvChOBSsfXqeqrP1wlE6tVGnHcL3veRpyF2O8rETEbvoFffk8OvyWZI4A5qVkmBLmvWT
         E90sVUwPl3g5x//VqA4RRRrzeYBJ7UQCC+YBc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789513310; x=1790118110;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7NEEN5klK6sYQ7k8fj+V0z2WeSFVNwjy5fJJIdfiMPQ=;
        b=LUZNkPVEDONjVeEe3Ada9slpRq6dDsF7Ob5V7nrWG/8CNF2eAxn3uklgXkIlzhxjpe
         rbNn5gc4ZafDfnnhRNZP76qJSLraCML3gy6k5Pz4tlahJzLkCGTjdBaKjJTqv9304xva
         wArWEhXSQRe1cIc7PgAR2ff1FVGxG5pltrM9f4sj/G3UuHwQOdeKz16kpGEnozHQW0yA
         KiGP/3kFQWRw1StEru5eyGUdDoXs9bmEWEq4y2GQyuNhKPqMcPvua/nlrc1j8M1GnQCI
         G1vBPQT31JvcGGpHLUnntb8KaUp4b46Phf9NXG8YK4JGXZCrLNeA+yG3JK5DvO1LGB4v
         x18Q==
X-Forwarded-Encrypted: i=1; AKwUvBw5FgrxyCMAWqSVrTHL/Pt4gaFdhVlGZr7jsbs7dgr+gUVGXMuQLlrxhRT0BNcXaOBRqsK2D/VNdQ==@kvack.org
X-Gm-Message-State: AFuF++nh32dbueDbCxdX+K/TR4IYx1qjkYUCbPUyo3ex9sHQ1I9piGZG
	aQ7f9HZcI7sdmPmZwIV7EAVsvCuI5iPlEA7Z63cxcjsbSGIjlyCr/TqLxCaemrFzOwvynD8NP9h
	hc7JhLC9KKQ==
X-Gm-Gg: AYBFou0vjytnRMDCkO8niISPknuw9HeYD9Ik4J8E/dfNx8cs0Xu9r6RzExxMDK8/pgS
	rRjHziRY1Pc2TXy/2i+bgVQ8hnFynukAOyaaLRVy+jrJAYji9Qjir6uTkR0OKmS//Zo6SAEVLU9
	McbpB1/RNrhDXg4d9Wedw83HIzLKwKXyoZU8FKPPOvi6G/7QdoSBDmUYM6JghjQ8O/8ro4BAoO8
	2v/8ULXafohQdkmmKoocTRc+DnQB/N+p7xJSxfTle1/88bCIsFvg2aEoYQcexeXetjuymig/hUm
	yBoK0Ui+rm78Exl2KPn5SZAYCArgfZcSyk+rg0bdQAr29WutD/+9XuAk3CIJlEtVIjsDRIBxnRm
	ShrZHcPpByo0E5xNW8+HYS5s2xNcjzyJSRtxZk6YiQDv2QBgt88L+2HbMZKG+yAIuNekiImqbBT
	/zvUw8dWx9r40fLDkPDPweVYt+Lm6giAFdFuYjw6PqhneDi6Re9/k2q2stcXeDQohjHAR8LjYrg
	DVP4sqM6Wty3//k/7Y6uQb2ykuavOuTWC8iIFlai6gvKFvQJw==
X-Received: by 2002:a05:6512:3985:b0:5b6:183c:5ca4 with SMTP id 2adb3069b0e04-5b8b665fcc5mr33302e87.66.1789513309965;
        Tue, 15 Sep 2026 16:01:49 -0700 (PDT)
Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com. [74.125.229.205])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8b5789885sm312233e87.12.2026.09.15.16.01.49
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 16:01:49 -0700 (PDT)
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b5e4f1744eso258479e87.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:01:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByURawiU0SHoaQQWnx5Q80WZhhaqZeSuY9bNBElYOYWJ1I9SrJrN6CYa13AcNYL1Tiuk48Y6/1OLw==@kvack.org
X-Received: by 2002:a05:6402:5d1:b0:6a9:a6c0:e5ef with SMTP id
 4fb4d7f45d1cf-6aa2244ef06mr218172a12.37.1789512913950; Tue, 15 Sep 2026
 15:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
 <CAHk-=wjeamU=_RYT9cR3dZJ2N-Teo-N1+aYh7jwhrB=iWXD0cg@mail.gmail.com> <CACSVV028AdnTYa6OKDeoJYCau58uTkKMgEdqTn7crNSV8QZxOA@mail.gmail.com>
In-Reply-To: <CACSVV028AdnTYa6OKDeoJYCau58uTkKMgEdqTn7crNSV8QZxOA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Sep 2026 15:54:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjhJF91TCO0Zqeuf+caG2tQZ4AzbLr2qFmRmnMM4dbh4g@mail.gmail.com>
X-Gm-Features: AcwNN1Wx2MaYDtFtmeOlL6MnzYY7doY_FEPpziKatTBWbLOeKsjmritQ5JuAL3M
Message-ID: <CAHk-=wjhJF91TCO0Zqeuf+caG2tQZ4AzbLr2qFmRmnMM4dbh4g@mail.gmail.com>
Subject: Re: [PATCH RFC POC 00/50] file: handle files on syscall exit
To: rob.clark@oss.qualcomm.com
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jann Horn <jannh@google.com>, Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-gpio@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, 
	David Airlie <airlied@redhat.com>, virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	kexec@lists.infradead.org, linux-hyperv@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 22689160007
X-Stat-Signature: inwqz4kfmmns3ntqgpu6oc85qnrfjk31
X-Rspamd-Server: rspam01
X-HE-Tag: 1789513311-429236
X-HE-Meta: U2FsdGVkX1+Xqv5NQRlrE1Sm+xF+0mIAfue9fPZ/KQxZ35ax6/bkoh8EQ8kZQ34iQy1+WJ2OrGAYqHTfox6g1xrg58nU1qUlcQ6zGNaFKJdJ+0mFFNwewhjPVKYfa5hGhMFGWdV+65RL38ucHlJBMCvIJtDUxNlwW53khdFd2cw3bXDk9SLZawdN4dUms/tN7bkeDMGiGmi+URkVfZwphkKE2kcbGqQ3YNpl87Y8/Lzp5fzm+lNFwdjKUzarBJBlw0IFR5JEZmQZT6fQEHvtrht4VCUl7BkNh+/u3Ya0fvvdcvdKfIIKK/XcJQsnyha2zfkwu6whqY4TI0kxMh1mLmjGtgGL7pUtJ9Hf3r2JaFt6cKG8pkbRlVZY4zHVJMFAW+E05GoJ7OtLeIeb6qkFtZNzCNu4XLACTQwJqh0SKaF0ADIPlLhOILa1qbMX+gSG52tw0Jq99ibmHa2R8JMz608ILgrLbPEDzeuWvnUyXCiYKnOI3de72sJEaJZUqNCBOdI5RNHcn79sMDP3TkMRnv9Z3ypacW/svfx1EVA6G9JWxa+0EDb+AkBWi3lGpQULqqWv9f8qe0FTXMK7ExOZ8MPw1mD9kNDhhCz6n8kC7goTz3CTBlfHy7Q3UFeLrrfgFlTeT31s3OkY/IBNEFGoP+XpjFU2nYQGBjO3W7j4jnmeYQRo/caldg067ih2cThlH4SB/TrjkQ5FUPl9M14dFX2aHGtPM5NbWLdsPOU9awlWhQ8xqGsLogxUFmOeL/3Q4eH/ks/IvQXw6PLSXmQiH1aId3RshtoZxY1pepDZupvkgSEPPn16OFHQDJDdv+7k0tdAx+cs6/UKW7+SjmAL/8MPdc+/cEJAMoB0p5F246AFgGvn40MRA8z0Ulm8kNBGGzc0RVyDAlpc3biaDl4XD6jfQiId5200dO3k8tw2cFQ5nSlBN9mAm8QYBYuiQVpBSe8wfg/CLtIVUbEGjZY
 cMToCfIG
 DqjwwB4A5p63wB4TllYDwZl0+ozVTURQXfvgkYNtnm66THLlET6AzjfjXGNG7yUu/xcNBBjgaWXcIqgLIA9EHD2XRIMrVl8UwrTLvYBn8nI361P/OBoixZwHK9ozPFgBL4kySLvvy57r/W3tRtYG70ZVHTbgZDCDLpJjFhXBn1D96l+LiIqTzV/ONfdEkX9dSO5ldsuNo3Xn6lrJseCHlvs8aeKJQUlBQIEPI/FRRewbUY3nu4SLG/1x3ZUhOhSEFQED9N7Fut5bEdG6PlI3LUuewBsf+9q20V+3STizRs9MWGHXHqiIB3PFM/TG6BSftU7Rqxbu5wyGH/oIANZ5ERUsC1rIEUgmPMSelZu4E7jYQyPDOyQxZHPiU56BYO975v+dejlShO43HArgdYOTLGUgQXuSeaDx1XzMWJywUzVdvIo5ajyNb4hJcj+XCoS5iET4J39Esn6111W4uFiaUuGWIPM1J4WAdJvtC1DAZKzzChDgfaVv3RfVWifMfbZsKk0b+8LkgoL/gKXYG+8V67cuii4r/Ecbt3ohxtxCur4eaVSuyolJlSImrk/ABESSvU5PDAnsMVLVKF2i8V+9t4qaqEBAZQWKbp7WffvF1ubPGqv/T6Pyq1/v9gTg4Qk7FF8L4IYlQpe0vF3iVphyRUfKsD6NqeZkAzc/a+mJVQLWqYTHjhnUXq5P+3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sept 2026 at 15:21, Rob Clark <rob.clark@oss.qualcomm.com> wrote:
>
> With fd's it is more than just about error rollback.. exposing an fd
> to userspace mid-way thru an ioctl is an easy security bug to write..

That isn't very common code. It's something that is done by a few
strange cases, and yes, those cases should just do it right.

But "those few cases should do it right" does not mean "make a whole
new subsystem for this thing that makes a simple "open" actually be
slower and stranger".

             Linus

