Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04721C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 08:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6F456B00A7; Tue, 21 Jul 2026 04:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21246B00A9; Tue, 21 Jul 2026 04:45:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90F8D6B00AC; Tue, 21 Jul 2026 04:45:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 687EB6B00A7
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 04:45:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF29AC03E3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:45:36 +0000 (UTC)
X-FDA: 85012150272.23.FF217BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1621A20006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:45:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H8xOtLEB;
	spf=pass (imf03.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784623535;
	b=EZds7zy5paHyjRGAMz91sm3nq2GEplRWXzukVrypIA2IKdJMkhw10wq+V3v1QWP7nY/0mq
	R+G50JTByLKdKWqw/4MQi3Sk9rm9R95YZsjX/PpTegEsN8SyFF3SgVyLRYsRzm3gELYBjg
	ob4XdoqdaPYKzllplZWUSrKyuAr4zD8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H8xOtLEB;
	spf=pass (imf03.hostedemail.com: domain of linusw@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linusw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784623535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mda3/lxuFBmPENdZVts/4V3Xa5gfiA3vEnncLDtHU0U=;
	b=Kv0ilUuqANaWj94o3at2ODD9elLw21VToL9rzW3DwTIE5huBlzqeYud/NWeSpntmvybten
	E9WJTCuaqFeVPqa/ZuEAI6w28HNTFHDq3vMsIYUs2ptHtdAOtWqLPSL/QvGqBTDwsks+Es
	kdTwTnFwHI8642mDhE3LYgIwQy+hw1M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 549BB60AA4
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0812B1F00ACF
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784623534;
	bh=mda3/lxuFBmPENdZVts/4V3Xa5gfiA3vEnncLDtHU0U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=H8xOtLEBeHw3D1Mgo66uUN9jrIvmZoVrTyRkEQWKZAN3qUCvcP/QbUx0yA74H1hS2
	 eVKtvEz9rsTjo73YA70F3ZVLjsMgQOn/g4FCGg8TlSnbfx1U/W7ia8ycZV6kLIICrC
	 lVTx00//c+91oD+xNXWtzkymz8Av9vkrjM6w/XKDa5QAh1mUfl1CGYMcRhPR0Pp7pZ
	 3B6aVbbesGKmWyaH78to8ih9vBn1GneqU98QH6zWLMIp6E+iKtdCyz6lhQix8OrIEs
	 J5AEZ5bW1o1OxNkeFZQKJRuTkGoxDRaWOZzbZ9DCoVOBmafKp+9hBZMrJSuDDzZRNr
	 BGk0y3dNcn/Jw==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b0117d49dcso10205282e87.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:45:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rox8nHi/pD6SlQ7uEJh1sSkjVBHbuz1wlwZafJ5NomUi0JBsFiu2fVNjlITTq1J9cKQU6oXvsOdfA==@kvack.org
X-Gm-Message-State: AOJu0YyQGMJoU2saPFjmuS4by/QMLLmuysORFRVp3wUxflr4uPJ9v8Bx
	E6xfruqPhM9eqJTI7CSA2NWzEhMdZV3SlYyenbmD+bcC83sp/3ZqyIQEV5pZeKcwJrbPDAqDUng
	wUVvSL0DK5/s5NdbFxZR9glxi2lhZSjY=
X-Received: by 2002:a05:6512:39c7:b0:5b2:a328:cdd5 with SMTP id
 2adb3069b0e04-5b2a328cef0mr1147687e87.49.1784623532800; Tue, 21 Jul 2026
 01:45:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
 <20260721081858.1169276-7-ruanjinjie@huawei.com> <CAD++jLmHw3ccWQj-AWvgrj7z6iwPk=MC0-UMaUqLeNpsbxW54g@mail.gmail.com>
In-Reply-To: <CAD++jLmHw3ccWQj-AWvgrj7z6iwPk=MC0-UMaUqLeNpsbxW54g@mail.gmail.com>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 21 Jul 2026 10:45:20 +0200
X-Gmail-Original-Message-ID: <CAD++jLnEWP_Pf7VN86Hzb2MYTPJdisy3cET8vAf1AxBwh7sdyw@mail.gmail.com>
X-Gm-Features: AUfX_mxAPadijNGOw3KjbcQm4dql7ZsTZweXiQL_6HWNJOpSmXm_9tY3eS5UFxg
Message-ID: <CAD++jLnEWP_Pf7VN86Hzb2MYTPJdisy3cET8vAf1AxBwh7sdyw@mail.gmail.com>
Subject: Re: [PATCH v17 06/15] arm64: syscall: Rework the syscall exit path in el0_svc_common()
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1621A20006
X-Stat-Signature: o87cofp7ior6iuy7rcr8ajeu484mpfgi
X-Rspam-User: 
X-HE-Tag: 1784623534-312125
X-HE-Meta: U2FsdGVkX186uSilnmWcY3XkdxD5T7hS52cyhCT14eMUSnYOr+Zf2Ok5/gzMYT6XNMVRaw9nzdoS2eTDEf9SUY4ZGL/5Fm9e0SieVAJl34tdh0l4y5duqSQLSXYhutCluZ1VE3YvcHj7vIB0hO04pzJvvuHmJ8WdqK76fi2Gokv0aZRa9jO0dLXQT4MnyNyR6O/hAoVD0BEFNkwt6oQUL77NYO6A9sf760fKDttkBSVrtjbTdLgGg6eicQOaqKDq7N+qm3kEPD7y+qJA7/RLHZ7zFfG7tteq1T2qjAVDSyGORm6e6TIxuGE3Gu4yRNOhRs/xg18MSs/wawYpwF7nSmdCOpf16RGW6dmDNXy6gcCHIhnsMBWKtuXlRH1sV+kGsuVw6oJ3iOJY9P7+E1e4IZgwQ5GYQkQC3icwTFo8KCd7K+Q3VtpRp0gSaUTtvd/31lmva1ohqlEZCFO2C0lQkdr9a8XDGbDRZE4/uW7loL2v1oIOzTkW5PIwLOmmA5+IInfRscEyKgcfPi+DNE3ojgHSmiD8WJxwAT1FktOY4iFT30jFI671tYa8McS+64HNUXBJv4iGPhPos0zvJZa4dlG3emQzlJJufoh+EJOPtJ4r1OXbNfU5SStNFQrwstVNw5M/g/iSN/puhY0gPSQvtuwWmDVoEnB/fIJYKwM/pEAiSzUU83cgavTH/058Pb5F8A5vj3j36xNlQj3TrQcPiHVYssVMqGx00aLnPeKHUpLcey1a2lac64uXiC+IJ9y6jUdAhtdtCfyWo7WhulqtWPgdaTlcjjovabfKnDPkjEE2jfxkl63loXhvLQEEvKJD7K85N1T0m7KZyYQmWKHDzxa39/4H1giQo+LtCNX6zTYaBhqWgZrU55ltd9KqHVJxTjKQVUYTVqwW7resoGRKjSvuFlpUSVZhEOhpU2fXgzfFFLM5y8FqHeh1Vg0ygWP0s9rhXKRNlMagnn5CRVW
 prnYxlGE
 P187KhEFJQnGHCf5FTVS8VKc3lKjunKxH/swdi4js9uKXgBm+y4kAQB/UcehEN4/XPdcHLfrmZ3q9JDOkj1rB+EN2N28D7oaEJxmLcBnSw9tJonebAXn6InhiO9IixtO00j4Rl5IRhcatE7+wRPxfwgkA81vFE24wu9WERIgXLHXLhamChSvK1ghBQulxyDMXzvWojQY8VyyZju703S4uVRoy+VzF6xcinRzmimQcfvCuYkRKD/gpkEbuwnE3nI0tyZXHjontCdvt/U982OTnTBryn4/ZnsfpBeVVQxPUn4BaK7sZu+YlWa6D1F8osg9QojhVvle59FulR0glEMTVKUDLfHzBuMMsNlLuGrVNwckDEXhsDTe97vUSMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 10:43=E2=80=AFAM Linus Walleij <linusw@kernel.org> =
wrote:
> On Tue, Jul 21, 2026 at 10:19=E2=80=AFAM Jinjie Ruan <ruanjinjie@huawei.c=
om> wrote:
>
>
> > In preparation for moving arm64 over to the generic entry,
> > invert the nested conditional flags check within el0_svc_common().
> >
> > No functional changes.
> (...)
> >         if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ))=
 {
> >                 flags =3D read_thread_flags();
> > -               if (!has_syscall_work(flags) && !(flags & _TIF_SINGLEST=
EP))
> > -                       return;
> > +               if (has_syscall_work(flags) || flags & _TIF_SINGLESTEP)
> > +                       syscall_trace_exit(regs);
> > +               return;
>
> What about just:
>
> if (...)
>   goto trace_exit;
>
> This is easier to follow IMO.
>
> With that:
> Reviewed-by: Linus Walleij <linusw@kernel.org>

Aha I see you refactor it again in patch 8, no big deal then.
This is fine, add the Reviewed-by.

Yours,
Linus Walleij

