Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D389C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D2D6B00AC; Tue, 21 Jul 2026 04:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645446B00AD; Tue, 21 Jul 2026 04:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50EE26B00B2; Tue, 21 Jul 2026 04:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2ABE96B00AC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:39:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85B3CC03E3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:39:29 +0000 (UTC)
X-FDA: 85012134858.07.27367C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id A513D4000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:39:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQol5GY7;
	spf=pass (imf01.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784623167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8d6b/fNRAVaLb/L3bgdgypqz8iTx4qcpmz29xYpDH2Q=;
	b=I48LOlzyHN3VhJnBEKsXOlhtPcE7ntLNAXEg8o8TKh4wJgkAkCKHIU6h+MfvZLzCm0Kw4+
	3kiJ2MNXOrJO1EBkPX9Y5iSgjLISNziAxp5Wo5fw500zJMWMvA4BrgqMQA1qv0yejM1QOh
	KgGIk8qjvjnybQXcxnmk6sQ20YjrL/c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784623167;
	b=LgflpGLT26TpIGbS50vlSp6oc0PRYY1jJWH9bcSU2ydwLL+n/GNOJbpSXK8SS+j9lvYFrK
	q384QRT7bqn3tXaLsMCWokG6E9cl+o+VOYkd2Oa29rikEbEXtcixb73WmjC2+iIaiwrwA0
	gEPsF0i2DPNZeffUNH3A+oqQw7vVAPQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQol5GY7;
	spf=pass (imf01.hostedemail.com: domain of linusw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BDE244E79
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503191F01558
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784623166;
	bh=8d6b/fNRAVaLb/L3bgdgypqz8iTx4qcpmz29xYpDH2Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RQol5GY7dw3mf/3qmFKPRgYp49U/pocxHZlua+sKWiNCieOxxsxJb72anONsL6mXc
	 jktT0jHdpsiSq9hznr9t4bXWV/Rp0UYN23KppMrK/SjFMIJ8b/KxgTvVgUZoKjqGLI
	 YzLwvScHLnGW8HaMBNNWkl8ztBD9WcXcwVGyiYbmTrlz5o+johQtrdiVusi7cyFJhG
	 hmMWcSqtvHwrcw2k0d9w5he7Y2zKMZCM601eQ7YOWT3uZDT1OHQ9ZSSL4aVPfp2aTe
	 XBzW+y/HqXvWdBqw2WuoCb/ywC55w1WLoRtezyLo7NoIK/NRiogAMRY7K+Zq2Wp0Z4
	 Jj7jFhiTtyYdg==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b013084dc2so6618585e87.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:39:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoC3OoKSruapSRKWhhttR8+Oeuvaxv99XeEeHnqfkR5DqgOeO9pATrXMzIybER50QTpsNxXV65N2Q==@kvack.org
X-Gm-Message-State: AOJu0Yyjd6Klq3ls2SzdIzajq6QVoigKV+wCqERYRguDr9CsqC1ezb8d
	Pejo3I3WhmHxkFfFFfTEOe2etSSZchr30hbdbO4ZirYUXJR53kC7MC2yDDCDA71oPKpOttSHwmI
	w7scYpL8vh++vV8DERXWhtgNonMoWLsw=
X-Received: by 2002:a05:6512:607:10b0:5ae:ba28:a56e with SMTP id
 2adb3069b0e04-5b28f9aa422mr2369081e87.35.1784623165029; Tue, 21 Jul 2026
 01:39:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260721081858.1169276-1-ruanjinjie@huawei.com> <20260721081858.1169276-5-ruanjinjie@huawei.com>
In-Reply-To: <20260721081858.1169276-5-ruanjinjie@huawei.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 21 Jul 2026 10:39:12 +0200
X-Gmail-Original-Message-ID: <CAD++jLmY6H1PeQdpLZP6=m1xEPKWdUmmmAkM_Ncy_WxL9mKYRg@mail.gmail.com>
X-Gm-Features: AUfX_mz4M5Zam7PLq9pt0g3Mh8c9Fbd9QZYGzQZFZyZm2-OUu94zNvOVUQ1YcEY
Message-ID: <CAD++jLmY6H1PeQdpLZP6=m1xEPKWdUmmmAkM_Ncy_WxL9mKYRg@mail.gmail.com>
Subject: Re: [PATCH v17 04/15] arm64: ptrace: Rename and clean up syscall_trace_enter()
To: Jinjie Ruan <ruanjinjie@huawei.com>
Cc: catalin.marinas@arm.com, will@kernel.org, kees@kernel.org, oleg@redhat.com, 
	luto@amacapital.net, wad@chromium.org, thuth@redhat.com, peterz@infradead.org, 
	mark.rutland@arm.com, ada.coupriediaz@arm.com, kevin.brodsky@arm.com, 
	yeoreum.yun@arm.com, anshuman.khandual@arm.com, james.morse@arm.com, 
	tglx@kernel.org, broonie@kernel.org, pengcan@kylinos.cn, ryan.roberts@arm.com, 
	liqiang01@kylinos.cn, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A513D4000C
X-Stat-Signature: u7x18tmkqrhqqkpsq6tf8nse1wcot87e
X-Rspam-User: 
X-HE-Tag: 1784623167-266811
X-HE-Meta: U2FsdGVkX19+e7bEcy/swR7/pcdf1388h3tdKxGkbYUje57on0Ifn5djhqytPpR9XSTosODb1gDH+fZM147zlDrKrhub4g+SHvmHB3+qxG560ubelQmJZkhOcmM4Q0oaDC5RPOcMtOa/jL2fi8g/HNpPN1gMgqBtcoHHAfJcxCKb/mV9/epp9ez+n0Ic2LfDhKZLlMu+9dYCWHMX3Sll0XophP3sfoNNPj8nOD47nAvVVNT1a21D3OGWgpAhBfBTWW3gPMApMjwkd5w4MrCXRaCC5ZqiYaGJ1bIqKDKXAth+R7gJ4kpVkFfjp2bRkXvyQNIrOFvF6BrVqpE1ERzUTM9zD0IU3Ku11XIw4WFzxXaEJ+riQrsdCEAuYKkLXlOIogfbwUTfBZpHLVt1lg5EregU6BoSgd50Qraz2Uk4M87VuDYrdViyfKYSb+w7fDrcdDICs39Jbqgjxd5vqS2GHFkoObj9+MQsqJC8FnAtqSzvC22jrRKvQxUJABqi/3x4TPdkVVjBK8zeVewkpgL2lw6C5JF2UV7q+cE7HL2Hb9l7fP9I2F3N82nZEuU3YCyb2C6U2VBFKcONSmfsaHZ90IBqRwhb3rBjbQn9/s9U7NlLpIyQBg4Ufep1VxtHlukPMdUR6xXW8TWHrjb8GEvfayt40cAsq+7JE/LnqhLidaM33AxkKr/EgjKqydK5rfwJg9SdpNHJvTrpdxKCaKf2pHvjVtyY9TdaoS/DcblYNbcYgG6CdPVZMi0A9dhcNUKDHQ0vA4CkS7FgTlI7sstomxWQ7LU+02l5i2ijFasrniAkhIopgw52vp+HXTybyZINDnMn0tteIUBs7eUusxhx5Y8Cpz8Kpq3kkAyle+KqIXQ1Xo1NQEEtmWPQm0WTN8hQql/IQ0GmO10NMnQ6PlqvvtWbqjUk/dz5z9C/YyHJxlZ0TWRcKCppMqnVQEiQOOKl+I2tImaCeQjfvog7pSu
 f6AsyVcy
 NVi2+OW09ExSBlFPF+ndloFAjZvOWFGr4uKrDS+wH5kCnhIGM3inQ5+UTSj+myZ/8ayYDP+vMYwYdlVS5N3Umadm1z5NMTGeFAqJtg5j/6HvURu11E0p+q65bRGD7Io4Wa74key6mLzGWceycCp5laO68uYT9wR1ZY0X2xrhkAZZf11YuBdk47kc5B1KZqhiqyjzMDX99qScjcNAYSEA9yhIFuCtypeaLVrHXQKhS3tUlIznEDim/PbxV4tell7pYoJIvHyMzOtyzYJW/bu02F2CbuMwbJ4swPBudQn3Cl2BV/jk2h6khBxMYCgsOsxooOSrtPBAT/q8cYeSQK+sEzbD89a6oMLucOdWFSNAu56SioX86STYm9Cdu8hoiHVktzy6B/um9cfoRa2L45fXuuH8qjfVDnQp5sFRwtgr6Uf/62k2JE9hYWOluV1yzMksqaXsW5zV3lthxlifiuzUdDUTxjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:19=E2=80=AFAM Jinjie Ruan <ruanjinjie@huawei.com=
> wrote:

> Rename syscall_trace_enter() to arm64_syscall_trace_enter() to avoid
> name collisions and clarify the boundary when arm64 eventually switches
> to the generic entry infrastructure.
>
> In addition, replace direct accesses to regs->syscallno with the standard
> syscall_get_nr() helper for both trace_sys_enter() and the return value.
> This decouples the tracing logic from architecture-specific struct pt_reg=
s
> layouts, aligning the implementation with the generic entry pattern.
>
> No functional changes intended; this is a preparation step for
> converting arm64 to the generic entry infrastructure.
>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij

