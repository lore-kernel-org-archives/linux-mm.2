Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FB5ACE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 01:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919F78E000F; Mon, 17 Nov 2025 20:02:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1A58E0002; Mon, 17 Nov 2025 20:02:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8078A8E000F; Mon, 17 Nov 2025 20:02:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 717578E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:02:27 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C5BAC02FA
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:02:27 +0000 (UTC)
X-FDA: 84121927134.24.5F5F483
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2D44F1C000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:02:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VbdTvpD9;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763427745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+cw+/Wg2GGP58Te+av5x0rFdkRrTQIR2igB2FJ9iW7w=;
	b=Tmmkmb75j8HFyiPqInkl7Oln6UNiTtPqyw+w97D7j/6ZQWKBMoS4xD4weytJwmmN+JGm0w
	A70IbFip4jRi3kjplsnOuS5kE6GO4jRIlDRNLPp+Ujar7xSsWiI8xYtHnscyeEJfL/cM0X
	EH1sci/xB6598Bg06JPNyAKKt449N/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763427745; a=rsa-sha256;
	cv=none;
	b=7qCJayE4nFihELVK6vlIpgPpy0KRk8ocUO/ekSmbVVNvmLmnAk2C70hHFSnoLy3sq5nxSi
	NUz0maCdBt9soSWD7oiv0SiPwC56NbyEptta9iTgCtlvXEUX9jFs76Q7J8FlV0FZYT6xHK
	xLF0p/elnUkW6Xbuw8M+1sstvTehrXk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VbdTvpD9;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64165cd689eso9207370a12.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763427743; x=1764032543; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+cw+/Wg2GGP58Te+av5x0rFdkRrTQIR2igB2FJ9iW7w=;
        b=VbdTvpD9QPmLvJdHgk9vRvE1DNMtZ+E69Uwm8ZAtNgjf4rx/9QysuRu2yuMikmJrk0
         PJkQtkvvm4QyNce5WGayXIxfaamwlv/KhoA/Uiv2mEvcHa7v1vvXNliMxJFoQYoqP6E/
         TtAijcpKYmPsyUl6rYFx7X2k0tv/fu7Kqv/jK3ViU/OwHiEuQCOGoy9lyD1NOZr7UxNa
         o+t6HLTCT69nDKCtCe1EjYwlAkShk2b3MRUdZwYz/c90grgEGCFvlYUGiIeu70WtjHMR
         NxVP2jAAiabb4Tj3Z6jN/obT4bj/JrBTx3+RuDRqNoZrI5nFHHqQcyzKu0z7qLQ9R1SC
         tTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763427743; x=1764032543;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+cw+/Wg2GGP58Te+av5x0rFdkRrTQIR2igB2FJ9iW7w=;
        b=qtliU9v8WjjdHUYyvhut6xWGY3sggGPxQIbZcmL8uxNdGwEo/f/9xXCjGPu/L73WWa
         a3QtBGkvQSYse6/PcaqXOAT/uK/dRxuYOfr/yMyc5ji3IasezkhVfGY1pb1fADkj0iih
         R1xXFTI1f3sXDF6axYthbpLTuriTsMyYYdX+WThEoDK5BpRLXcyDu0CJxo3LL79LuhLP
         m1GITZuxOy7a4BxZ9aphlfCZJU/VQQbo39FYm3nmniaHTnyEo1RIu2V3ELoLUEAWKtbB
         zC5gPp+nIPjnxkqQix5nTRXOX0nxEckOIwecmMCF/AXQZ0/eCzEUQ/dsy33ygJKLc8wM
         N+tg==
X-Forwarded-Encrypted: i=1; AJvYcCWgTc4qWlNWI222QiK8ja7qQM2gxPJPdWVmIRPNEmTKEc4KQMfuvqmiSW9e2euk4rp6LqKPtxR3MA==@kvack.org
X-Gm-Message-State: AOJu0Yz+QLOspMg0gjZ5uHx0r987iqhImCX27PTYKdIz4+WC8O2EH9X/
	WXy0JGyU9Y60mvaxnBzP/S9pBuOnc4EEzJTnaAhAzLqSsJoEdI4fsvU8tXA1Ma8wsJ7QQVhSifZ
	sGrLPwT1kmEiAdb4DxeF5G7Qv24obOWsOF1JUI5zkCg==
X-Gm-Gg: ASbGncvuAhsaVWGqOLdIlEvyt94u7aDVyUQax9qpuFAhXhDoLIuY0xraGOMtZ1E0kUW
	OSX4vEJxlM6Mw2gk/l8vYuFWmEDmviM7Oqz3CAVXOa/rIRk1wQYT9aNXdqaZU9SHoLTB+MfLTjn
	Yx5iDTOXYnTpXcKXLO5GJCssE2nXG+xMEpeFbka8mHxU3A3eYAQdgTIKLD268JuyQtiPnWlq1ln
	DdNCxA4ERQKH8IEKeC7RJrxyWS2f+fKLrQQ4UjZauuunoW2vp+3Zx+gFNDlQQciOh9c
X-Google-Smtp-Source: AGHT+IEFucR6Z0lEuhSbJuwGX3vRvxY860i7bZcpqu5KZQIcl4X/kvFT9wlEbXjqZjCXA8pyp+lFBWxPEEnLN4BIodw=
X-Received: by 2002:a17:906:7953:b0:b70:d1ea:2748 with SMTP id
 a640c23a62f3a-b758bb55399mr152503266b.11.1763427743312; Mon, 17 Nov 2025
 17:02:23 -0800 (PST)
MIME-Version: 1.0
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-19-pasha.tatashin@soleen.com> <CALzav=edxTsa7uO7XxiUSx+DZiX169T4WL39vYsn3_WcUuVKrg@mail.gmail.com>
 <CALzav=f+6hQ-UYBpwmAyKHPmtvEq-Q=mOL20_rZmAcTyd87+Vg@mail.gmail.com> <CALzav=ekHM8a3yYHHUJNgtYVwLYf1hFhEmrXJjHUXRt=xrSy4A@mail.gmail.com>
In-Reply-To: <CALzav=ekHM8a3yYHHUJNgtYVwLYf1hFhEmrXJjHUXRt=xrSy4A@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 17 Nov 2025 20:01:45 -0500
X-Gm-Features: AWmQ_blONNqJhD4RUEUKi4TjsBuu-Py_fKb6YYrA1AzgX3PH5Kzk_E-GtwNe-iI
Message-ID: <CA+CK2bCfuewEA858nG7WTkBG-hSPpAHP6JRgCRSGmyRTL24oNQ@mail.gmail.com>
Subject: Re: [PATCH v6 18/20] selftests/liveupdate: Add kexec-based selftest
 for session lifecycle
To: David Matlack <dmatlack@google.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com, rppt@kernel.org, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, rafael@kernel.org, 
	dakr@kernel.org, bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com, skhawaja@google.com, 
	chrisl@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D44F1C000D
X-Stat-Signature: tk8io13wfog1n3rfmtehnmbncqp8uqa9
X-HE-Tag: 1763427744-443057
X-HE-Meta: U2FsdGVkX1+NwMhCwIRDxO1qaJIEVug177qnD/G1yVl3blnLKCHdq1dxp8sfNYjXY0kVPtPgN4qkktjTAdbpSj0+1dQ6QKiYKQmcd3htUn4/DpeVP9YxEbaKaJPL19VC+Y6uhjGOezNVgTUod7EGo9t5ImHVp97wPE1lZHc9k769NF0XQv8ylvF03Y9fWykbYwBB43e1M6pfFuL44lZvKTQ3Levzyj2bpvBECLbjjvibShHab/ouOf2Vck93MJqAAhfovNaxknKcoSkmnz8RO2Oimc1sn+CXe24UvtGyPi2WTcRY8n6whO0opMbldsC3qPp23N6RTZ5Lrpd/L9hLPvUKwqpEjJ/YVKYkcG1RygbPWtqdIBLJKGIF9BXXuyqJZn/1PR2+AjIzqJ7d9obats0JoSqaNEMf25M8LXFKSRa11vA5NyMTc7/D5HujOWCzDBrWMVBSXEQuD51u+8ItiaiavOWJJKgjbFzu/sM37QfAALxu1hAaTZDCb6UudlPtP3XTJdOcQYF2LQWN5vwiAh94/O/FnJPTph33TDjhKEmCjjxa4S69lKDUs13dlm7tEOnSBin/lJhQvOv2hOo87e/LpTOQn9Zo6vhGe44zhtUe4dwYjMf+nDfYPq6QQN7JOWffv+mlCruDAVntfEIEmCUrQxOuSl3r+PnT4M+sGwKNYNpDHvHt1wh7ou+GUmUeMgIu1bTX5lhTyGkZP7BSO5r5Vx69OwFTRXoRlO2cqHINwMI+P8HFE7tnn52jG5+8tcqIhkTzLnOSdc6WScHHgzKz4vN+z11d+0ytI2m1WfeYCPX+wcToGyf7vdWQcb9fljYQD6ro8VKCOkk4yaj6g5nhle6oNx7Kt7z/4BbczUyFLe9Z0FxbakDA9F/69ej+dEqzOIXTsClQJhueFYVVn4NQa9bm7JCIA+PVyO8Z8q2hfw+gYC1JrEl1N0r/jkybuivw4tIXkIBTaMb/toZ
 SIje2WFO
 OyYZvcq2wXtEkJByau6l4z1FoThqpnyaUjZtUP/1PVFO1Y562bSIvER/xvwVDJq0snPF4AmhsSvw2hjQSjxZP8DQSd6H4zXNbtuuZB7W4C5wK5rfE0emE4rCHBijWak2qDNw/LlLqQEzOsYg9C90DuiGUdDPdLphz1ACqz78lhCX7wg/DEIqAOS3uvPNRTnG3tJ1FksKC3zDX5cz58vaHqiFcS0zl2QRA/bhnpRFl7Lim/QXdvHbyzLtL90fbOX8YE7L0ozd556NgLFkjOqeZ3PI/ncpYzU8oJpO0YEIuWP5YJA/JaN5j+Rbz1PakkTQY64h4t5xof6NviSMUp8DBUhA8T/4dUkdYFsuJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > TEST_PROGS_O := $(patsubst %, %.o, $(TEST_PROGS))
> >
> > TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBLIVEUPDATE_O))
> > TEST_DEP_FILES += $(patsubst %.o, %.d, $(TEST_PROGS_O))
> > -include $(TEST_DEP_FILES)
> >
> > $(LIBLIVEUPDATE_O): $(OUTPUT)/%.o: %.c
> >         $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> >
> > $(TEST_PROGS): %: %.o $(LIBLIVEUPDATE_O)
> >         $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $<
> > $(LIBLIVEUPDATE_O) $(LDLIBS) -o $@
> >
> > EXTRA_CLEAN += $(LIBLIVEUPDATE_O)
> > EXTRA_CLEAN += $(TEST_PROGS_O)
> > EXTRA_CLEAN += $(TEST_DEP_FILES)

Took your suggestion, thank you!

