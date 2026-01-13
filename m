Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD91CF45CB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6526B008A; Mon, 12 Jan 2026 20:47:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 863DA6B008C; Mon, 12 Jan 2026 20:47:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738636B0092; Mon, 12 Jan 2026 20:47:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62A816B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:47:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0CDF16144D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:47:27 +0000 (UTC)
X-FDA: 84325253334.06.53DF4B2
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1428B40003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:47:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Doia0iYT;
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768268846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5Zya1QiiH1g15sa03C60PMdmscKG1ONGxgStc03n5E=;
	b=UPGOxcpL9WgVIrADsBd8HDMC/cOxByWvQgG0tECuzSc2KXAlhkeU0TOl3ERXgIBuH2I9ji
	nf2Y7Xa3hQvN0giDJrKQwoYSfBJ39njH3ZExqIjIwAk7PKxXECvbKBYO71K3oYU/6HAE0O
	xhePBNmcIMz0tJijHkPr4a/oKq8hS2Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Doia0iYT;
	spf=pass (imf01.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768268846; a=rsa-sha256;
	cv=none;
	b=4F+K2hR5Z/bpPyOuGfW5UPzVpcSH9OJphhqHxZ0aGmWqAom5RXlSVxc72X6xyV9C/vZBk7
	qaZYuezquAeVgjd8aNtcpDPYhFgZ3rZUZFbZ79VXrfly6l++fy9yDRTyxRui8yZEPNaTmy
	2VQI5hGYL41H05M97376/CzdQ8hXqWg=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-432d256c2e6so3560485f8f.3
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:47:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768268845; x=1768873645; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5Zya1QiiH1g15sa03C60PMdmscKG1ONGxgStc03n5E=;
        b=Doia0iYTuLPHfDNz6Bt2D4Bng/AzA95HpJqI0e2cegslA/0yRvvJGEgpTrVFaZ/B7e
         UsrVZZB7AOKhj6XLl9LyhcF0/ryuChRmmkI84YsZaBp90yjdhbf34QZsPj2JPaB8Lc6y
         6r6Mtdw5tUcriiWvieUZ6TgsT/0KLMUHBKDeJD+c04wDLa9rA+Qv12iGP/zOnkQ0HlE5
         TsycxK8Bwa59S295pyvqFXi4hVbkoWRUNjvhlwi4k0d1FKHfPhpZDj5qQi6W49RyQKQf
         yLOk4LrU079mkBRH3EF/0SYGyqqwXN8wCTnrB0WtC/6QDw9sX67VAW15gMlg0Ij8Dc8m
         kYyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768268845; x=1768873645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r5Zya1QiiH1g15sa03C60PMdmscKG1ONGxgStc03n5E=;
        b=wRW4EIb9cwjv9ZZozTAtw/tjH/uQT1agkDx42zrY7SPO/C4W1Ger6Q4apoKNB4V0Qi
         vJKhyNwmCbHZk32suDNBF2qNrGQ02P/b237mdG36FJ6NqzVNMluPVkB5GX3nvMXv4K8a
         sFw2q9bz/NDIkZGdRavvlXiZdQ4c16UfNqtBWmMtZU0JvnjTYR0M3dmbtn0zfl7B6+ER
         f8lKszze0S+twXXLR2U138aOC18D1TiZiIC0ckUYYGK/bVX2+Iddn+fY3Ba/WncHwxVx
         64y7iDAWUGlFcwDHee8ZdrSFZHgwpFD+GIAAY0pwxNpFDJ5IbTOfU9A/qLoBamuHzhNJ
         65Hw==
X-Forwarded-Encrypted: i=1; AJvYcCUrF70mzqCVvx0TfpZN7xmkpC7tGvsEwEOifVgp4TXCtSRruzWQxA+eAvtUxFHuxBZP7FIkpOrBQQ==@kvack.org
X-Gm-Message-State: AOJu0YzbDPMrh0eMNEmg3vVXtaTOqHOY91zUSJzvpi7VSERK3tfPeTeS
	QU9mOWmf2GsDdX3t2+gwODvAMB6t9Yoot7NBPcA7SHToI6/ObKR+aXsnY2okZIt/NOvx9EqxSRe
	iZqwpioci6aEZuwLMTwrnvvGKZHkVq6o=
X-Gm-Gg: AY/fxX6RuYPyr4Qb7ZPu51XOZZCoIA0r+tQCUEYFdQTUhYv0mrj++8vEsmbjejsjQCt
	66yknR5CVjkVZGujg+UTGXZdT8mEc/G92Qro3cUEIPb6dntzDrwdaTws3Q3c7mjb81ui6m0Zu0R
	/JSPAGYWr5Bv3qAu5LnVpJVxLBSbaRL73t0Em/KvYG5VeJ1ThtfcrNtYxwEv7YmdDVESBAmvLve
	gQV8jlokmFc7mTUXN3OMWHF+ena3ddcI3fkntKG8Otog6f/vUkmjV4p8RuzJKulDYlelNnK5B4F
	8uvKO4//fLiBCd/0WZLn6ZXkilgfTw==
X-Google-Smtp-Source: AGHT+IGLZPsHQZdYP+igQHFiHZwML+c/tx73CNXLiZEv1na3EZeREwCRzVBn7g5quI4ihevQAYTcxL8ulaKSY+q8K1Y=
X-Received: by 2002:a05:6000:1a89:b0:431:342:ad4e with SMTP id
 ffacd0b85a97d-432c37a9b5emr27240018f8f.62.1768268844511; Mon, 12 Jan 2026
 17:47:24 -0800 (PST)
MIME-Version: 1.0
References: <cover.1768233085.git.m.wieczorretman@pm.me> <20260112102957.359c8de904b11dc23cffd575@linux-foundation.org>
 <aWU-oL8oYS_PTwzc@maciej> <20260112125348.124d201ef2baf762561a43af@linux-foundation.org>
In-Reply-To: <20260112125348.124d201ef2baf762561a43af@linux-foundation.org>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 13 Jan 2026 02:47:13 +0100
X-Gm-Features: AZwV_QjCQ1fbtNH6MxAuTA9Y-OoKsLsk_NAIZlsBpLK13R0P_Z1v4NHXaV8E6rI
Message-ID: <CA+fCnZci8YK04PPMT7gkMrrNHbMB3Ks+D4xG-5XkEOaywyrGhw@mail.gmail.com>
Subject: Re: [PATCH v8 00/14] kasan: x86: arm64: KASAN tag-based mode for x86
To: Andrew Morton <akpm@linux-foundation.org>, 
	=?UTF-8?Q?Maciej_Wiecz=C3=B3r=2DRetman?= <m.wieczorretman@pm.me>
Cc: corbet@lwn.net, morbo@google.com, rppt@kernel.org, 
	lorenzo.stoakes@oracle.com, ubizjak@gmail.com, mingo@redhat.com, 
	vincenzo.frascino@arm.com, maciej.wieczor-retman@intel.com, maz@kernel.org, 
	catalin.marinas@arm.com, yeoreum.yun@arm.com, will@kernel.org, 
	jackmanb@google.com, samuel.holland@sifive.com, glider@google.com, 
	osandov@fb.com, nsc@kernel.org, luto@kernel.org, jpoimboe@kernel.org, 
	Liam.Howlett@oracle.com, kees@kernel.org, jan.kiszka@siemens.com, 
	thomas.lendacky@amd.com, jeremy.linton@arm.com, dvyukov@google.com, 
	axelrasmussen@google.com, leitao@debian.org, ryabinin.a.a@gmail.com, 
	bigeasy@linutronix.de, peterz@infradead.org, mark.rutland@arm.com, 
	urezki@gmail.com, brgerst@gmail.com, hpa@zytor.com, mhocko@suse.com, 
	weixugc@google.com, kbingham@kernel.org, vbabka@suse.cz, nathan@kernel.org, 
	trintaeoitogc@gmail.com, samitolvanen@google.com, tglx@kernel.org, 
	thuth@redhat.com, surenb@google.com, anshuman.khandual@arm.com, 
	smostafa@google.com, yuanchu@google.com, ada.coupriediaz@arm.com, 
	dave.hansen@linux.intel.com, kas@kernel.org, nick.desaulniers+lkml@gmail.com, 
	david@kernel.org, bp@alien8.de, ardb@kernel.org, justinstitt@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k7upwgat48eteob9mifmu1oeg9i151t3
X-Rspamd-Queue-Id: 1428B40003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768268845-803801
X-HE-Meta: U2FsdGVkX1/q9kiG5nDnZvJ5393IC1u1OGXt/5U4aDEGcb1KH85cqy3xA5/ufJXvzGttvKfknkLoOCWG0c9KaY7jDim+vdxWlICXTHpIOdxwTfwiGvyfFor07+p6/kKfhlo0MoS7TE6AR3ZRY6q/66Rv4XWwM4LpS5pdxIIaWZVknvp1eWZ4g8PGRoK2njD9jfI3CvrnvGyq8ysGhwQ0O+uZq8Qny2Cug5v44oluGzdRf6EGMIda/qcqgVWICwtHFC+l+bTbYEP5qVJg7eXyP/HbQTQatCPm2isMn5z5/1N4Aq87z5tRQiWJ43QnlZa27bMa/y27+JsYqGqB5OQozc1e/7TU2l1yPQ/dlm7m/Er5WE0TDidTflgsC3u1ukP/jwAn0frIXeI7nBbZp62+UTXv+fsumIlZmicDPLfNc3GaOnkG1IZCXVKTDO0gVFEbXIcJoZgzf4wzLbZuFCjEObKkSW2IeOoQDfs9lidZif6EzCst5UH/wBeMQstb6yGFIKhkXMw08ISVpuA6DIp7wR/Mir1f1isF3k9ScM5x54ZA+Z0dN0oMDhYyR29zhdoqzo049Mlt9lXyqfEgN59xZtcUEEdl1VX4qWgDctoCoLU1vYzu1r4vj6b27oADc2wU1TyYLvybpVRy2otvkDUftKiwYchqCcwvTK8r1Yg8huQpIcPTGewCi29sZMux9Y5g4Wzw7pXk3q7iiCum7OMGso+sM2aMD/sh4axMW5Br/BpN8ZXcwNVyBm/VUHvgEsr7YUR1l6p+WohhR0/NjwHfA2hx7LsmPuFvRu/fq8z6FFDeieWdwgeHN9BCJcvhKKRcfzHmiQu+JXaJgOBViiWBp+EhFTdyUL1uXrBsGMUywOg6jdJuJddgsinm1vztSZgoVnXVNuCPtgNPqxxRabnK9yYoJdkfVkiRSLOZHbOdC9+ApYf27jZ8ZGBux9Dekdm/HHUqagapyx+4tul5sZd
 h/15LXPB
 ePANM6sCIn5LFA+/bXAs2I2VI0KnlhbnSNe9jxm+vGgPcpHhX0IKSUfVaBI12SVb+iIz/EUGczwIMXVRXaySpqswTPuDzMH2Zu72NU/7vZsJxHiMURim0Ddw1ShkMLo6nX0+quRjsr9R2h8sHrzOWvMsLkSALqFnyFyVvT20YFarhQcmXB1D1sW+R39UBKdhwvywmew7ppdDRB4+Vr4JUyR9jyFh+7F/StbVoTGv3F49TZF8FUq16v3v8oBiW8+uEpkv7ofJyfFYwk4AUbJVeXX4eAWg83FYfMKyL7+OgStLMq/+TdCzbxoYw1JYZBb6hCQKJwTyccmbCYLdmcczFauoc6MRIyd16S4Rk89H3PKyTVNSWr4tROjsCvcFv9NM1JGD1payXzEc4pm9trY0Qc9O9AAffCSRoCUn7jgVOizXuoQ5vQMcrhFv1qV6RQNAaMh4Rb0ptYjmSfBqPaK2QwArn0qhCEsgDal9RGUl/687r1XjLJA/WzcjWjjExbhfIEWTSYngFCan0xPw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 9:53=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 12 Jan 2026 20:08:23 +0000 Maciej Wiecz=C3=B3r-Retman <m.wieczorr=
etman@pm.me> wrote:
>
> > >OK, known issues and they are understandable.  With this patchset is
> > >there any way in which our testers can encounter these things?  If so
> > >can we make changes to protect them from hitting known issues?
> >
> > The gcc documentation states that the -fsanitize=3Dkernel-hwaddress is
> > similar to -fsanitize=3Dhwaddress, which only works on AArch64. So that
> > hints that it shouldn't work.
> >
> > But while with KASAN sw_tags enabled the kernel compiles fine with gcc,
> > at least in my patched qemu it doesn't run. I remember Ada Couprie Diaz
> > mention that passing -march=3Darrowlake might help since the tag suppor=
t
> > seems to be based on arch.

FYI, there are some known GCC issues with arm64 SW_TAGS mode as well:
https://bugzilla.kernel.org/show_bug.cgi?id=3D218043#c3.

> >
> > I'll check if there's a non-hacky way to have gcc work too, but perhaps
> > to minimize hitting known issue, for now HAVE_ARCH_KASAN_SW_TAGS should
> > be locked behind both ADDRESS_MASKING and CC_IS_CLANG in the Kconfig?
>
> Yes please - my main concern is that we avoid causing any disruption to
> testers/buildbots/fuzzers/etc.

I left some comments, but from my/KASAN point of view, the series is
ready for linux-next (but this could wait for a week and maybe the
next version of the series).

I wouldn't think there would be disruption issues: one would need to
deliberately enable the SW_TAGS mode for x86 (as GENERIC is the
default mode when just enabling KASAN). But I don't mind locking down
x86 SW_TAGS to be Clang-only for now if GCC is known not to work at
all.

