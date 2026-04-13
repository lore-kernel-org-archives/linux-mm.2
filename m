Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83375F34C63
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 16:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C596B0088; Mon, 13 Apr 2026 12:44:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D536B008A; Mon, 13 Apr 2026 12:44:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0C356B0092; Mon, 13 Apr 2026 12:44:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A03366B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:44:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3777C160274
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:44:04 +0000 (UTC)
X-FDA: 84654104808.29.D717886
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 08BE6C000C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:44:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ADlImyw6;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776098642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlHNgLffJ2tQMJ/F/kC00Gk0yT34jNt7ArfhtQjZiOI=;
	b=jWFAMuTIZntBpAw8jZyB/whEpDamDNWr+chyvw+4ehIojjaInRDyNAr/qwcyREBVQ2CP0u
	qDFVt5T1/xSXGrzuAepX4rkP6MYHyeQBZTAZA5nj6W4HJ1eIpu7ZIEwezEm1aZN9g/ubVD
	QfMfDQwX9dCu8II3hI/L5qHmKPMMrgw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776098642; a=rsa-sha256;
	cv=pass;
	b=XOHppKBOl7HrfuaVh17FTbZoNHQp7Odt4Uo9za48/uyFHLuQMA+X7Qz9Ch2YmZO0HohN2R
	BasVyvJqB8jHg1xQocu/yu1rjA396q/a7WfM/vmsJ2iBiKySO/Brm+QQwfV1IaQ7Eq6ONm
	dkRFHvb4YU31OgXybjrgwPWlz3pLfRg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ADlImyw6;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-66ba9898ae8so6974330a12.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:44:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776098640; cv=none;
        d=google.com; s=arc-20240605;
        b=i7GjAvx9ouAGYr6PwoKaGtx0ByucRgCDJIKZuJ6cdvhlyNwZxu0lSSGve9v4fMP3KX
         UAxHC8znfx6n8EGFAKIHN7FJwkCo3W/4VTwoWRIsTqXTiGYR3EK/uhYldgcHwb5YtgOk
         UNkL/kSDISPMvQGiXFMXYd4plAxwRzB6Vru8tr8QnAtlT0MtuzuFCpQ8447p6JnUq7J4
         I/FSDS2xI6LybGEW+Do0vkSZsMEv5mpOusicjvp7uFV3B3bQl2CW3A105OIFytClvkYW
         FWBp7841prFTToscVQo/oC5uxiU4GPa3XdhKqla7p49COuwoapyrNJfJg/FygEr3I9Eq
         R5rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zlHNgLffJ2tQMJ/F/kC00Gk0yT34jNt7ArfhtQjZiOI=;
        fh=pAU5w+RZdib/FoGgz7/UkwX+1irqqdv9RO7Seu/16Ro=;
        b=LCHjIP2aqzvYIuXoi2KDwKV2lut5mHIRsernB9JkMOqvOGY31xu2jCC9hruCOJCrol
         ssU0VP9WB1b92TxvmrFlkX9E+6cpzZCvJ21Ge7+9234pQFEVu0c/jdj4x4gTfRIHFF16
         xHrmh/cBXRM9T4jJiFClm3263USRkOEn/LouDlXiUJyoaVR2flW40PU3iJBC5ZcWlsGQ
         fxf5MW/2uuyyIXzH3UcnVU8Zzr+kHRqaF8xa2lo5asa29tgua36M/ND3DkCEw26qBGb8
         xUdHfIgZc/M9WMvi8tU19Ph4o2gLyaX/qn2Mr0X4S6ZLEZuPSwv7ItHQt/PniUFiqcgG
         +gxg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776098640; x=1776703440; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zlHNgLffJ2tQMJ/F/kC00Gk0yT34jNt7ArfhtQjZiOI=;
        b=ADlImyw6SXrvGrZnzaktvJkWPllCyEXKlROCgEZP95a8npYeRL1lgXgFjOWXm5WBvi
         7UKBZ2sWSi9UDXix/KWbVzkeeVnjK3imAS+q7SdgBfgffTglw1OEMO6BOcJBQMQ+SqUK
         TrpBXXHtDwj9QmNqRFvX25cNQSh8C7F/Km7P7phx0C0n7aiHNhSeFe4ydn6sDIo8JaYx
         cTnzfAiZfj1W04Ytx2WJXl8Xe8z736eo9gEjEP1rA3snc1G1sQdLuS4adKAVi7ogGQ29
         YeeP9Pv47rOuoejON/WQqeRvV99VZDfXxlYP/lkTXfpxjJu3RkqiFxR53ZpB5P+L6t6j
         7XVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776098640; x=1776703440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zlHNgLffJ2tQMJ/F/kC00Gk0yT34jNt7ArfhtQjZiOI=;
        b=m5Lf6Ourh1AomhO6c6LOqmUx7pL1lSwfNqZO7H8bjPaBETv9IdesgP+lHnSbZwt/mo
         OB2+0ibxWIt/f+hgETWX9iQsjsnpH7ynmUT29NYmW5XPVpfDgOi1jRuAjGtEqJ6sUInd
         qWZG1L8ggABcoz8XZXV9O6xTh8kz6qsF1zsRu1nMP52HIUNVLb0ux7MV+bYK31bqZy43
         8FybrGAAAE297Uq3jt0TpHkSuhevEH1JvqkGIgONhc87UDm4wanMjv3mefKBQad69NdT
         zm1aTO76GgXeFVl24+Tj7gohMtFklFggUpvNzx+eeTsSCAW2q7IHusYxMEj8YKmCuuFI
         1E/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+ruUKrJKxtbGyyTOhOzjgA2TFILJ2RYOKcdybMMb3YFg6o+rN3hevIPaKGjCFNxEx7OJQbQXIcgg==@kvack.org
X-Gm-Message-State: AOJu0YxgaJLg6As74pZ0lK+Gv5Xy5sor5Tnh7H8F+7tlAhHDK96b/m9A
	zraQvuOWn9atj6rKQHAaLqEkFVxsbb1q/gB3ilVReRte+eKRPSqqFjXHBboOWjV3zTZy/bSVX/N
	bGEzI8jTZ/FwdN1c9Z8zyixrgeybgjb8zqds07ASQZA==
X-Gm-Gg: AeBDievDWUQw2Mblf/dCU6F/QGV+QoGabP3jaPk2Fx+vP9DjP7k9Knfb6/mDV/SoSYJ
	kLcdG5nSloLPqtuRlHTXNFuVj4kyEFDS4PMOhWbWtur+cqqLdCXg/mMgFci+ehOZwpNa3LHXuui
	q4zww1zr6APrvuRkkNe94qGt0chiBjSDW5zcv+Ny2ivNwPqPwl2uGax3eqMhtdYuSdU7Oia30GZ
	EsKSJyJUmk/ufgPpcJNb0bpzSn5QfL5LGBhRV5XBAGYGgIbKMZFuk31SnsjMIwmt/G2fIp3zF5w
	Tx0r4BD0VEy0wkmBJgRBNHR9AKnrbLJ+Pao5Pg==
X-Received: by 2002:a17:907:60cf:b0:b98:14e:32c0 with SMTP id
 a640c23a62f3a-b9d4607f442mr898214866b.14.1776098639840; Mon, 13 Apr 2026
 09:43:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
 <20260327033335.696621-2-pasha.tatashin@soleen.com> <CA+CK2bDJJ2exSz4i3by3QLX1xvLAyqG5L+UipraiQw3Ytmx2=w@mail.gmail.com>
 <2vxzmrzoibg5.fsf@kernel.org>
In-Reply-To: <2vxzmrzoibg5.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 13 Apr 2026 12:43:23 -0400
X-Gm-Features: AQROBzBkWoxxUDMSeuXbW15jN88Cl4Pwajhy1nr9vDJodPEGqFbGCdJx4yM5nhs
Message-ID: <CA+CK2bB114_szAQNg1yZ5YZx-p5R2DqO75UP1-KP1X8huDsUVw@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] liveupdate: Safely print untrusted strings
To: Pratyush Yadav <pratyush@kernel.org>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 977rr8xgsprztadfjbsxejfh4mhbjhdu
X-Rspamd-Queue-Id: 08BE6C000C
X-Rspam-User: 
X-HE-Tag: 1776098641-254467
X-HE-Meta: U2FsdGVkX1/4CcHRMRAF8tZBHCDOLsfRGt47I2Mfa5OlrFOp5k5/0oYcvaTV4wg16b42UBhdU21YWgqAQpNd7qRPVeej+mOmdZkAA7K4cU0w31wCw7jwXj74ZrOwatwahHV4ac38pOjFc9u4NUeKE1gf3PMqqmFwrORi11iTvMLak2eKDzdOThtUA1n6zwe9SYnlOZTks/MUsQ8GGIm7et7w4j4+XcklTgbmvqwRSsqRQHQjOrtivl4LON9X/8v5jb2jhoN/AMe8Q8o1r62TniHxENJveuXP2T/72VCBdfRQFOpFdy++MhRpW/tF3zeOo/jgoT6re873zi0//ysx8FkPPjvOd9WF62cJxNjRQdxammTx9upKsVGTjIJ6EeYxBREIVTqKURw1fkS2qqCt5XkKDnAwaFHLWK0NAQGmMPOB8fx7PAlilTcZC3bQA3gic3wg8/odELoJdP4aQtMBwf7gh2+0hNAR/JHoV8+AePm4ppmWx4n9DY+8xkSQZxAl0QPMjECt9TZl/aSATbkRFNzFOdPXS3qQgefFcgNe4YoNmHGXCVCTGWTwVliCTXRktyRNmk/jQitz+Etcp1T/Hje9CwN8U8f8cgLnOCslbTW00SRyd7D2TYrxT8zfwvmoYGMbcJuC4EmB9dwR4vGUGUwLthGx668m/ssgvOwnz6CtAgFKkq0IA2KQRErkbvN6GOS8p4MRSnm9qgUJKG3eJleFh6FrerYg/cY2M8vduchL7ElPsDwgBfj2VVQbH886WHONfNtgGsQEPzLevzSuV2BrR+cW8YnjGSdlqtp1QyyRGrj3AJANaVMBycwgZQcQHSBw1soaf8wA/THNHk42rmh3rXpFtgnb1St66+LVyU461fD1SRlyNbmk5GJUu8Mx0s0m3XP3MsVP7LRpGNGTapYmtqhDdtC/pg25FV13DIiU8cozJeyWq9ATDe1iMLMry91EVt+3SJHidutL/Ju
 JP+uGjX9
 Tu0Uc9u/ksVqJjjMHcWAHDK2VsT9hDWNcQsGYtE7v2+yJ4/W0vKJonw1WNPE9NkV+3mDcOqVaHwv8Kh75rDCoR95YT+6kOf85c104h5dw62KJn7XZAHJGgnu/1pcCtUEZn9UGZ3tBP9Kaz7kG/wrwO0xmA6vwCVxXzBzyX0l/JzDtv2gkDH1fLrzyHSs7vutl+SZQffjjnB2HCPBZJNMLUZ+g95pSA0DVYfZsPix+20izOZ0V2kGnCVmKBptwzCnXDNncGnBBrq/E+dToKAWGsd0RvZA9GpEMR73btsHE6CgfDmyH9NLrZ03wbZR1dhicjqqp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 5:40=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> Hi Pasha,
>
> On Fri, Mar 27 2026, Pasha Tatashin wrote:
>
> > On Thu, Mar 26, 2026 at 11:33=E2=80=AFPM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> >>
> >> Deserialized strings from KHO data (such as file handler compatible
> >> strings and session names) are provided by the previous kernel and
> >> might not be null-terminated if the data is corrupted or maliciously
> >> crafted.
> >>
> >> When printing these strings in error messages, use the %.*s format
> >> specifier with the maximum buffer size to prevent out-of-bounds reads
> >> into adjacent kernel memory.
> >>
> >> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> >> ---
> >>  kernel/liveupdate/luo_file.c    | 3 ++-
> >>  kernel/liveupdate/luo_session.c | 3 ++-
> >>  2 files changed, 4 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file=
.c
> >> index 5acee4174bf0..a6d98fc75d25 100644
> >> --- a/kernel/liveupdate/luo_file.c
> >> +++ b/kernel/liveupdate/luo_file.c
> >> @@ -785,7 +785,8 @@ int luo_file_deserialize(struct luo_file_set *file=
_set,
> >>                 }
> >>
> >>                 if (!handler_found) {
> >> -                       pr_warn("No registered handler for compatible =
'%s'\n",
> >> +                       pr_warn("No registered handler for compatible =
'%.*s'\n",
> >> +                               (int)sizeof(file_ser[i].compatible),
> >>                                 file_ser[i].compatible);
> >>                         return -ENOENT;
> >>                 }
> >> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_s=
ession.c
> >> index 25ae704d7787..8c76dece679b 100644
> >> --- a/kernel/liveupdate/luo_session.c
> >> +++ b/kernel/liveupdate/luo_session.c
> >> @@ -544,7 +544,8 @@ int luo_session_deserialize(void)
> >>
> >>                 session =3D luo_session_alloc(sh->ser[i].name);
> >>                 if (IS_ERR(session)) {
> >> -                       pr_warn("Failed to allocate session [%s] durin=
g deserialization %pe\n",
> >> +                       pr_warn("Failed to allocate session [%.*s] dur=
ing deserialization %pe\n",
> >> +                               (int)sizeof(sh->ser[i].name),
> >>                                 sh->ser[i].name, session);
> >>                         return PTR_ERR(session);
> >>                 }
> >
> > Lol, Sashiko went a little overboard and gave this patch two
> > "Critical" findings:
> >
> > 1. If a registered file handler uses a compatible string equal to or lo=
nger than
> > the buffer, and the untrusted string matches it without a null terminat=
or,
> > strcmp() could read past the bounds of file_ser[i].compatible.
> >
> > B.S.: The length of the string is ABI, and fh->compatible is a
> > NULL-terminated string provided by the current kernel. In the future,
> > we can replace strcmp() with strncmp(), but it is not a high-priority
> > issue.
> >
> > 2. By returning PTR_ERR(session) directly without updating the static e=
rr
> > variable, subsequent calls will see is_deserialized as true and return =
0.
> >
> > This is regarding luo_session_deserialize(), that is the intended
> > behavior. We attempt deserialization exactly once, and if it fails,
> > some resources stay "leaked" and inaccessible to the user until the
> > next reboot. This is the safest approach to avoid data leaks.
>
> I think you misunderstood. Sashiko brings up a very good point. The
> problem is not that we don't attempt the deserialization again, the
> problem is that this code path doesn't set err.
>
> So this results in is_deserialized =3D=3D true, but err =3D=3D 0 even tho=
ugh
> deserialization failed. So the next attempt to open /dev/liveupdate will
> succeed since
>
>         if (is_deserialized)
>                 return err;
>
> will return 0. So I think you need to do:
>
>         err =3D PTR_ERR(session);
>         return err;
>
> To make sure this error code gets recorded and the next open of
> /dev/liveupdate also fails.
>
> Anyway, this isn't directly related to this patch but it is a real bug
> that should be fixed in a separate patch.

It is one line change, I am going to add as well. Thanks.

>
> --
> Regards,
> Pratyush Yadav

