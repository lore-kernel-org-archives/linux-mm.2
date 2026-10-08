Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ECE5CA600C
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 18:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6531D6B008A; Thu,  8 Oct 2026 14:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCAD6B008C; Thu,  8 Oct 2026 14:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D5F6B0092; Thu,  8 Oct 2026 14:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 196BE6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 14:50:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AF68EA7EFA
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:50:22 +0000 (UTC)
X-FDA: 85300349484.23.342D6B0
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id B44E480005
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 18:50:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YGmlba91;
	spf=pass (imf30.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791485420;
	b=aWKMRRLTO6uCCe5R9yGkzOL+jLkXJBxa2fmyV5ZRQKjmAt+uTRLWbFRtO/e/ErF5R7gHkW
	cfv3AQGdBwQBkuIv0KerXpt5qwZiPp3myGj3Cv8JQR7A6obkRWo+hFOktdx2R+nqDbmORb
	BrfsPsuWxcDLjmnqSohU+rhiPDgzC6I=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YGmlba91;
	spf=pass (imf30.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.48 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791485420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUuHUTe3yEqV1MPJyew4xZgwaSUycY+L6akjTIcM0eo=;
	b=NFsgffsLjGyhdTAVAIMMRZJ6zwOPGz2rGFjiN9VD1b3pznOGMakmNJ+I8zdUTUVZti5bgL
	G7DEBRh/LgB0CbNQuKFeY1u1K/p+y+gdHifFVPJYcIZi/4d65Z74Z/AGRiyWBez2h64ZhQ
	p2+uPfL4LpvtSxP+4QKZeUnVDunrlB4=
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-82503732024so1517268a34.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 11:50:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791485420; cv=none;
        d=google.com; s=arc-20260327;
        b=XJu06kUclG6XlkRu5WYfZVd7/wO5kdsCXpqvRNUtC8kEAS26qiFlrZdp1dnrcerC98
         15/UVL860yrtFZMGKE/97pBZp+7asJMAKTzK998QD8I6M+xqDRk8eZ8NOgSYB/RsbKhu
         Mml/yzei8qDPEErJ1lv8CG5yZV8rt5Gm90BM6pomD9I4vKEGUQxqwlNRIDP5JdvL713p
         eLT4K6ObjklQiwtHh8VXkOABTxm5qJLaU/kaf3/Vi4NFPkThbudiYX8rPKh/SvsxrymY
         ha06KhlI4fLpNBF1aH9WobXf7Y7XH9+tDV+5fH/8XHa1Usrpf4EpO/u9vUpOkVMygBS9
         DFGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HUuHUTe3yEqV1MPJyew4xZgwaSUycY+L6akjTIcM0eo=;
        fh=5gmMzzwvniHrwRUaIA9P6eM7Ok8GrKfVDNv+PywIRjw=;
        b=EHotGVeQtAj6RCMT7Rsa4IUDKcDRL4p6n9Mo19vc19s6hkJehk0D/DL2xqGViTTWtR
         08eV09GNjJzpri3QXhz3s+i5F5nScQDXWU0V4u59tnvnIOS1aX/SU8owdwzVUic79nLU
         fqAg8m8MH2jtMgTv6mEL65F14KkScV7YCWOUBlFTWgHtE7a7/wKWiV2GAKUC06llqxl8
         LrSzPolcbFXRotZ207Ct2gAOS/as7a05OsinaSw4kGIhujS4KJAni++NmdelpacXDWjv
         rAAM+HjUa9FgsHXG9eYX/Li1SpWa5VoxR5qirj74Dwxp3OMC4QbFmvGRs4ZqVGXTQYhm
         Ae9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791485420; x=1792090220; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HUuHUTe3yEqV1MPJyew4xZgwaSUycY+L6akjTIcM0eo=;
        b=YGmlba91T+8Hpf+FdZkomtAyyzRQ5sXr122WTj6XtcM/JTmqBjA33KccX+oYd40hTB
         0coHkNBvNQjZXNslpxSc8OcbL0W5ieJqOYlEPuL0oQBHrLzvHAphqMuK1Vd4C/8yXApw
         6K5GWpzRMrjoUz1XdvLxN2pvL9O8eAag/pPZgoNuuL2LTrNta0bD0HE4uWqIiSqxqgvn
         5tCxQ7oSOFMjKPKepLoaFCnw/ZHjTIDDgYy/JhwvOFZ2a6rZDNfAScC2sOB9ubII+aa9
         gQlX4pWcP9q3kkwdj2zawq6teNnPyZ3GD0MceAudz1h+NUU25qZzPRazoJs6H6HhYWYq
         c4ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791485420; x=1792090220;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HUuHUTe3yEqV1MPJyew4xZgwaSUycY+L6akjTIcM0eo=;
        b=vymZhAZG/mN2ZL31XGqursb8ACQWrseVeNYLPVYXFVRXeOeDWsP3MgixkjKdrGdYzR
         f0rNHfxWo2VYbo85un827MdprIba62XdUAPUPoc0rbRYHPfAqckKwn82dKesQeeGovAA
         fZM+IhYjQok/Y6bqm6fDPvSGXJz9sGCbvdHfht9orSP1TAKRls7GZU3JnqSt/Gy1SNBM
         1sYzJDmFxonlkrwObb1cLzlOrVaTsSoO/qJjgnCTyhaYxe3upUEf5dI2ys/BrC8TR854
         PBNvgLD1dKsVJ2Cs3mHgLCipIVEPk43Cx2nqFAWPAnVBgrZkuNYLylseGyLDcB+K9Ny5
         23IQ==
X-Forwarded-Encrypted: i=1; AKwUvBzLARa39KsPNInFPRVOuP1qzV+tv6nVyyE+iZjQ9j4xn8/fzzRAvQwR+vg6sKf2Ah2UOcu9RF1eXg==@kvack.org
X-Gm-Message-State: AFuF++lGvg3ZvNR68uz+p0YKiWbbdW4S6rTXqforNvcv1BL5wTZ45Ut5
	/VRYDa7FZ1/ng2UCl700jaDn5FuIktqfIBB5a+byxCuGx6B0ZR7fr5zS4VvDCYrz1d5qHCsIS0S
	OtfHn7UZk5tklcIv3mvEm4uj8jEaejug=
X-Gm-Gg: AYBFou1QgaUEdTDzc8JS1xFvfzSj1G8f4AIlHyD5ZnPvcwazXTJWyYjCPfI8yEPp2Go
	QISEwHLtENltTqNyPM4Ug+EE26RNY06hurxir4dFzE2gLbY0HkReBa0TYosLgLMT/1PEXhGdIVb
	NiQt1d8Pplk3LaKjgxp2OOYfAgkfdOasfXVerVHnPzo/0nVqSWCp4wYuLH+u6LWLmdIjZDwqCHm
	1sVGJub5C/OwPpPhej9pKyeuwPEKwZWeqo4a/B9+qFdutKoacdtMXnsZPQl+UV1me6aaTpunE65
	K+FAnhJxuTTKTA5ZlKpGuqM5butZrLsXMtcmGVYuz3IDwwAJlEs0d/E=
X-Received: by 2002:a05:6830:398e:b0:829:2af1:a07e with SMTP id
 46e09a7af769-82acce646e4mr6427817a34.3.1791485419594; Thu, 08 Oct 2026
 11:50:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-2-shijujose2008@gmail.com> <20261005235021.GBasQ3vXTivT3NLbBq@fat_crate.local>
 <asU7svV8g2Hb5DZl@hu-ashoraj-lv.qualcomm.com> <20261008030603.GAascImzt4cv8Gz49p@fat_crate.local>
 <CAG4KcRLhN9=6xeT4qfqKLFdukiZLUc7akGcWwXJUU1-qrfxTUQ@mail.gmail.com> <20261008174114.GAasfVutvsmAk8JGsD@fat_crate.local>
In-Reply-To: <20261008174114.GAasfVutvsmAk8JGsD@fat_crate.local>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Thu, 8 Oct 2026 19:50:07 +0100
X-Gm-Features: AclHuK-7nYIEHIpgx3dw55yERdZIxrZ2s_no432HghoTK3RqssmmaR0vXdDXvqQ
Message-ID: <CAG4KcRLx69BK+aw+exUzPe+BW8exFM2LLvN9pEr-+1BoGVhFXg@mail.gmail.com>
Subject: Re: [PATCH v23 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
To: Borislav Petkov <bp@alien8.de>
Cc: Ashok Raj <ashok.raj@oss.qualcomm.com>, rafael@kernel.org, 
	akpm@linux-foundation.org, rppt@kernel.org, dferguson@amperecomputing.com, 
	linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org, 
	Yazen.Ghannam@amd.com, mchehab@kernel.org, jic23@kernel.org, 
	linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com, 
	Jon.Grimm@amd.com, dave.hansen@linux.intel.com, naoya.horiguchi@nec.com, 
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com, 
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com, 
	gthelen@google.com, wschwartz@amperecomputing.com, wbs@os.amperecomputing.com, 
	nifan.cxl@gmail.com, tanxiaofei@huawei.com, prime.zeng@hisilicon.com, 
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com, 
	wanghuiqiang@huawei.com, ashoraj@qti.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B44E480005
X-Stat-Signature: ew758fw6ei5o5ewd34t8ffqmdetfrh5h
X-HE-Tag: 1791485420-505122
X-HE-Meta: U2FsdGVkX19agLJKaW34xc86VI48R7nKVb/NHFYWc3SDY9dgQbNNMdRApjZCtdmnRSJ1u8zZN8pRVG/vO9S4dW8RYDWm8Co/uOkAtFR3ZhseJGso5nMMgTkgqJFDsEy0B/ZAUWDZ+EACZ46MPz2OnJRfsxwYZ+vNiMKD4zrDc9afpT3Aie1qEgGaFSuSLVkUM94Ag9OARlfu9oM/7sC6maXa5+ch+L4mdKF8iJRXArHNJOGOMitkKiTAxRiVa54Os4UUqhnqHybri1TDuWWGJd9ABHQvi87IflZ8X0N9+ZqB0zZvyxQ9fwWvgmLKnteib9wH+PVzw3/+vzdeGByxo6XwGQIj4/LULNrFeoeVQzH1qvbf3pnUQzTm5Lrxp7W9qjkv12m6kVV5tLpHrv4qSphYI97tAjomGnjEM3mruCKUnqy/ZS0oHYMpgYy4APFJAjgb6ob0F1lbQVt6H32W6xYXCr87itGzEAW6MAU1MJEBYiHrsDQSPEozO5k05masvQ0RxfmC1x9wUJ05HABkj9lNbkl4Uh+Di1mRGNdTfHAixjK+K8t4qII++x4I2UOBZI8Tb+OeYK94LdN4iZFl1tm3Ry8wcGKDjOb2h8JMGAp+4bYpIDeh4EsOomgqqjZJxM7ls6YI0qqDwTz3tKCbsQVhm8PWTWWaSd11WyT2MyKPbps6B+DwX9FhQ5HzvJJnUJB9+JYMWqZLQrkh9kyCryHnFUsdrMo4SaIMk9K6+akj9qqC+bOMPb2/i2EQ3LmGEJAg29bYbDDlYWdRMS+geozwBE6l8xgWL2GNWre68IpJMSlWLUt0G2oUEkHnbTJNHDVT4zSbrKizJ0fS6TJ2+dR42kJ/RJ6A3s0Ce78GcnsXfqENL4eJ0LBZofabdzhTOjpczrNT0BBl6eYNqmL62mdrPSDh5jsK8hQmC4FWm9eZUarKKZKuHeYUfXKACZOLTgN5CIrSSvKFTgnKcf7
 0UmDj3lg
 49Mp2bK6y9ja8jspO67nVvty32zv2jpw2I5srUEjgqxGUfHRT5Q+GZF+uztAJu7lRcpB2PfCChC5lYNVD02ej9dHxQl8JmF3FquXNycaqD2mg4V4NYbHan7LveInpIcEfb8do3SKW4kAa0FwHyi1v9ddQBAmNjjcEsx+kk6XFBwOKqMJ1dYIkAoGKl4PlTKjI1j14ALgGb2XIUM8vjtZ2BczoBNyr1jtiWJHI8pA2TwFsKq3rxFUaXkBx1xdE/E9s1qOKStBGK+itXBzNkintn/TRAou0GOS1DY+Cry2wGeR9zNczyTehGphkRC6kIO5E3g5Z/LiM4/5Ij31NZcLt8lFFBRagjfjiMhJisK6gvE8sevjhi5hqO82/HDGy4KUdinzn1vRNEBJNa8EXyBU9HZk0NCPaUvBBsnPtYP6FuzFed6STROz4kF/Qr6I2ZKzKiGxXwzAdvmXsD3tjN2nVR/722gS3f/Gg8Ej9nMHbOG0UYOIt+FCSG65Tqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 8, 2026 at 6:42=E2=80=AFPM Borislav Petkov <bp@alien8.de> wrote=
:
>
> Shiju,
>
> On Thu, Oct 08, 2026 at 08:18:14AM +0100, Shiju Jose wrote:
> > Thanks Ashok for reporting this issue.
> >
> > I debug this. nows_txdone used to set before requesting the channel
> > until v16 and was changed in v17
> > following a review comment by claude.
> > Found this issue occurs when txdone_poll set and  setting nows_txdone
> > before requesting the channel, solved.
> > In my test setup,  I missed this issue, because txdone_irq was set in
> > pcc_mbox_probe()
> > with the acpi pcct flag set to ACPI_PCCT_DOORBELL by the firmware.
>
> What?!? I can barely understand what you're writing here.
>
> And tell me, how many times do I need to remind you not to top-post on pu=
blic
> mailing lists?
>
> Geez.

Sorry. I meant the issue occurred when setting the PCC signalling mode
as polling for the RAS2 PCC
(In include/acpi/actbl2.h struct acpi_table_pcct: flags).

Regards,
Shiju
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

