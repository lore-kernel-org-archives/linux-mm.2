Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38EBEFCA187
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 20:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76AA66B0088; Mon,  9 Mar 2026 16:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718076B0089; Mon,  9 Mar 2026 16:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0046B008A; Mon,  9 Mar 2026 16:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BCE16B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:43:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07280160358
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:43:03 +0000 (UTC)
X-FDA: 84527699046.03.5E38A5B
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id F30491C0002
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 20:43:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I2Odv9T8;
	spf=pass (imf21.hostedemail.com: domain of tytanick@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773088981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+r0FB7pxd1iFuthkg+A1pC8Uj7cCzRHZ5DeqqpGHm4=;
	b=YfmXYPStVFsD7Q8zEAkyziLbxpgBR6iRfrUckIksyHL7szbuPYxft6sPwlZdenMufpraBq
	kNdqRTIu3V4HWnZV4o5mN5tjjleJ50uGjfNG6ayfifzUQ6qkEPo4Kge0P8/BPXhG2h6Qbb
	dOWN2hykW67BGWNmZ6xTtXEtwJQWDig=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773088981; a=rsa-sha256;
	cv=pass;
	b=c3UDklKyeYcSnjd67YNSY5VYoaM5X6vCpAyVcrH9/5ss7iqTLXRi7NSdMmusnyPN7ge3uJ
	iuEUMovM5wds9CylXf4LODtrUTTcDtNZUl4dwH69yxbMNuGGbbndafgvSlVNus3o9dN96W
	wBKO+RK6izQDFESrk0H6hN344JRlrgo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I2Odv9T8;
	spf=pass (imf21.hostedemail.com: domain of tytanick@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=tytanick@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a1282bc6aaso4876579e87.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 13:43:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773088979; cv=none;
        d=google.com; s=arc-20240605;
        b=RhPnfXBgASk580UetMlDBfR5YyZ8Sfq3KB5xRZc7y/yOy1vW2CEyQ3f/apN7ohACAi
         S98KVV1aXuIylOyEq74F5qRYFznXg7HHTX2oT1zMWcw4I2WWMtACfCEHiz50J16CbWc+
         5YkZ2FMCCoRG7BGC6WBwSnt6aZed1TyZeyi/8WrhGuyhbg8LCsSkIS9ETCVw6XTS/nh3
         IkW5LQ4PUX/iHLGoy6jYZ4x+SylBpFXxDLdzOcMIlIWRAmPS3MGNxGpOXeFOAgR+PbeN
         Yh5ZcqczINwruighAtuOV0LwSEXzaWAs0IEi1xciSTA486dve0bNaTeYszCYQxLWM017
         sgyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/+r0FB7pxd1iFuthkg+A1pC8Uj7cCzRHZ5DeqqpGHm4=;
        fh=kyW0xutFlYxYFoDQVssd9/I5tYG5xp9dlVzXsPR5j6U=;
        b=S5HW7by9r7tVjJlmC2DbNfitrLGakPz+C8vYKC6o9AffNuR3Dmm9PQJJEHoAyhlep7
         cV9BU9X+F1bgLg9ClfGJDjwOqg3e0ItMP8UarVZFDmBx7XYRjItTilamvyRDcbr1QOWI
         cMAVDoyIr7GZ61d+YYWAlLjPHAvC+cbupE710FTV9wFDX2zMWLA1A9sH4m8CWd5uEvIo
         tXSt8BhATYbDlxNp1/iQ94J+wkWLRlZuYVdhUPj2vtIZnq8mwZLz8DeRJwVTkrkVm7Wx
         wEMXYGqREjFcHGh6ZVS7PWxmPQ4Y7LpkgpBmpyxHdXhy0gm8Mpue+ZNYoUKoJK8vOH/S
         i2tQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773088979; x=1773693779; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/+r0FB7pxd1iFuthkg+A1pC8Uj7cCzRHZ5DeqqpGHm4=;
        b=I2Odv9T8ejGVmV4Dzzp8fN1HZ0wZ5FLvhyHTyejCm4L5sa/EfX0pEBpWpwiC9LYpw+
         orflfCUtsJUl8H+1ebQA4eFH9cs2dDeT9V9PJ2tgUu1rePDLb2k5EZRg8wOvQdef789k
         8JyUfjqoZLg/pjzMHqCgQIR6iMxyNIyAAqbhb6HBIAnLdIDxdrZnTTc0vdHEAIsg00lF
         NJbCNcUrSaANAV8CbvoVM83yKqdjc44Mbx7QJAh7N4xh5bfRuHyyZLl80BOY+mGP5jya
         gS6WwMbsy2DGJ9mMracv1fSNaJmw20J+yIqHXSe/6jrtML0UU9B9BZfJnTBGP7MSUxyH
         fGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773088979; x=1773693779;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/+r0FB7pxd1iFuthkg+A1pC8Uj7cCzRHZ5DeqqpGHm4=;
        b=YFnhJey/ecqB6XQ1grtwCFzcSlRhUDMClVFRm+HX+XuCsyre5palQe6FD9IzsEc3yW
         d/2Adz2+CS3e8wxT0TTV/EusLEHBCs9tV931gDz9HA2ROO/TzmF3xiKDLcTnqq8fafY4
         HCPjhdFChUY7IXrxl04QDTPypfoWnq/SYyABHRmoNlhKbplXPcUJCtrfifi1zdhjMemR
         1qft2Mc+6sRjmi96dcIDzgQdimrdRmo0/uC9RNtUxWD4xLl6IiOCxMR7wIR3ZkxrpsHK
         tnRh30nzjmTpqRSXePh/nqOWFFXN1rdrVtJRCohESrSvOZp+CgdjsfB4W4PUifx4m1+Q
         wKRQ==
X-Gm-Message-State: AOJu0YyGQq1zGiFPXBUJoM2UHzQwUtICzSzwQ2qKu1xslJYoKFMpAOlE
	jUcB6NeAjbLmZp/WLOvKjLyMKxpsSkDsh01SiZqOr1UgA5JHOB4ajCSCbVuKIDIa2NwhrMOQcxS
	EYd5eqQ2+YQZf/dgPOrndICoBgiy0DR0=
X-Gm-Gg: ATEYQzy7hHPug0LUItjVDYmsQ1yYYTZi8yYFOnzj6Th05X5zgFk8sSqmeK2FYl75vt0
	SSTgGhm7UupDZSVFCFDL6+nd9OrPlaCduVK1SUaRYEVZe0mzrslCLmRqEBmGszx9ZmFWCJxY/Rh
	RLIUkT8DU6nWTPpErZBuEykOfVUDSKkigLwgziT6izecebXywSQvevN4nc3MWQwCyNNlfUK9ycW
	Ihnqz3nEX3UNoBoP3hfz3DAnfIhcXBVAS6M+ihOj+urmx/V3fzmsrhhCO9uFpBmDmEFSxW1IjgL
	ifrXnRy03SCwLrkYNegsCc3D5Gs1s5NdaDbgBZZmqv8lpNI/FId/azA+K1pkgKyAUUsmWRPc6X1
	/M8cTTVk0980eG8XfbhiPmz0nPfQ=
X-Received: by 2002:a05:6512:378c:20b0:5a1:2f9e:ec8f with SMTP id
 2adb3069b0e04-5a13cac1253mr2717979e87.10.1773088978640; Mon, 09 Mar 2026
 13:42:58 -0700 (PDT)
MIME-Version: 1.0
References: <CANfXJzt4P+FCkdL_=FfmG80_bY8FkzSocJSPeksSQ_vXObRNOQ@mail.gmail.com>
 <5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org> <CANfXJzsWFyKXJKsESM+7JXoGkDSeQt+Qaimy3FV1-neyXiHZBg@mail.gmail.com>
 <CANfXJztYakHdsY0757+ssQf0WYtnrWdGd8mFegp6PLKZ_SKnCg@mail.gmail.com>
 <e21e21c8-e28f-45b8-8ee8-7e74d6607b73@kernel.org> <CANfXJzto6Ewoj2qDQ5OJEMAuxVcfFcvuxbtKChentqvb2r+jGQ@mail.gmail.com>
 <e2ce4df6-ef2e-4a0c-aee4-86d9614017cc@kernel.org> <CANfXJzt7yGZZcuBjmazU9n7V8vupMSLNm+qCiZxcrmtUZicR1g@mail.gmail.com>
 <CANfXJzthDnrQJoCQWrfZwK1Mrw4QZv92ZEzsOy6WGqq3zCYzHw@mail.gmail.com>
 <0dfd588c-3284-4310-b1cd-aab54567f0c0@kernel.org> <CANfXJzs29Zv7Qw7cAiEzDLdTJpQEbm6mPeLTpuZkErV5GsDKfQ@mail.gmail.com>
 <ed3eecfa-a8d7-46fc-bbcd-025fd73e5511@kernel.org> <CANfXJzsh9m1xHszB3vdSUxfOHpxV6zNDs_0DU=kjjFJ6szEpJg@mail.gmail.com>
 <05a26f9d-e7eb-4aa4-b5a3-d485945f81c6@kernel.org> <CANfXJztyrv3Bc-YtTWX64+tEWNGQE3cOdjs6PkAvR-aGYta-ng@mail.gmail.com>
 <5f4d8780-55f1-4b60-840a-056da7401848@kernel.org> <ca6248a2-c442-4fe1-bf4d-9b9f6ba2de85@kernel.org>
In-Reply-To: <ca6248a2-c442-4fe1-bf4d-9b9f6ba2de85@kernel.org>
From: Tytus Rogalewski <tytanick@gmail.com>
Date: Mon, 9 Mar 2026 21:42:45 +0100
X-Gm-Features: AaiRm53pnBJFpu-WBS7SFotS4oseLbxWp-M9sxR5VJ49647nQCUgPzGZVTJWVSY
Message-ID: <CANfXJztnmhn8AU66EjQ+G=vx_0VQKu8w8O-wYrTjHxBD_OaaFA@mail.gmail.com>
Subject: Re: walk_pgd_range BUG: unable to handle page fault
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: multipart/alternative; boundary="000000000000ba2660064c9d7236"
X-Stat-Signature: kg9qb4yif11u3wiemrtpacehe6x6761s
X-Rspam-User: 
X-Rspamd-Queue-Id: F30491C0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1773088980-268053
X-HE-Meta: U2FsdGVkX18rwzp65tD4iacNSwtmS5h9N3j/GUFBO/zaA/XTYoxfRV5cMGybsIjpbw9OA5yVhTAfaqciOY+dprNcQG6kQP90PyJTUu0sBbi6qwr9qK2/kBkZ6nbbbgNzisIKNCjDOpBAyw/Q43MWPeTVfqPsQV8PvEEvmXRd5SemO+XmV79g+tIOgSey+2Mk4MjZlrV3RIxceCQTJ8aw9jzfC0kwd0abRXB2McWm5UsD7pyCevGvZakx2AgAPJABfX/7F7E8lhcmA8em8pgSlEnp37G6DstxMH0z20BaB0rYBF54ufI7Bt6UYVmvjrOPQ8XZFsANMsizJymgUp0RWbVdCCrhzY2Rkkup0bzg/oVTUr4ABbFb/10Li9NZaf2jOkz1hjr8kRunsN1jANhbBINNfC0ZThb+gSMZ1XjCqdu4hv22/WmHsCvcWAGryS9fB70dEEtXCvC29UgtwE2zvTylMWsOOEYFc2/4j5oLs4Qt7gauFZnc3iUmvDxT4jMmwshZvAXGC6wMyLZ22f746kqJbNYf0rIy/qc7Xuai4BHwfsiIbClVdBe+aRA86/gfS767ioWu1LvStuz7zPty8srGokGIAlgQWnfmcRKlGimxz3kIS1dU/zUPw/xBr4GGR3IosL2sc5tptMljHJeO+dEIHx7+B9mAdl0o7UxySG69GR2IIE8LQIm8TeAfN4cQJegCKYgzCHPFMdjTVdlhUQ0cVdBDXFspy8DleqZcjwmPQDpmy7YmMasS0JjTs8hdiE0pL1fb9xUsYjjr9Q8dVedDr3++rDPj/3flZ8GaVEhd6v2V6VyHvWi+h+k0vNgUZYr3Bdd6QVG2fPXRUrErflUI19QDgHri7tpi3+COQ3JQSnbN5x2IkTnQcy/vgvRO0oE1bVHwKGayPhioO310OqeJPEfUT8K2qgZjgbGvkNCHG6gaTli2GNLK5vZJbWFu5TOA8w6roaYscbrj3sQ
 /p1kr00R
 +XGAolILqtCE6vDCvy3iQUY9JIt5IrTgPKa5kVRnSydHN227XJo746/Ea6ub8Rjwx4c/3P2eL7lDYMszuc/Y+9g1hiZoqR7oGv+BdxUY9MhotfaZdSD3Rt124jOc0ZeKL0ckylt1J8Fj4N8p5Z0ZeOoVhznvzgcqfuokQFSlDBlup631iwDlXd018+8jIbW1CsCBfTYL63J4+4vemQFjkDcT4yKTL1fUaxPIIYfEf4kVVcZhVaKDdZ802dMK2Z4bbgOvr9ag6VPbYbitphiZIlJkCt5X0X5TC5N+RjDksPXCujvrX6f6LTDt8b/MbjAIX/1lj3IOgkRvWZWjVj2FMq3ejxPO2fX5uEY6tUK6oQbvbDIi4I0LmilvjZ3oNFUXt2ZaZbKHImO/dfw6gi1hK/Sm04WNYtEyROxtIjCvcuRNFKNo1HPvEXeESo80eNc48vrzfxuR02MtootutGpqp0ZI6l9/7R973ZWOGBulqTcM3JT0pN2jHkscgOrzjN1s5I+Py19cjy/0m/NsuWMQY11DvCqfP/ApvGmLmVMxcdwXsLllDRPldZYU+Fq8b8zZoJNrWDzvjzoI270wiXRiOeojvMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000ba2660064c9d7236
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Well it seemed "like mem leak" but honestly it was my bad assumption i
guess.

And does it correlate with io_uring somehow ?
Because i have no such issues when using threads mode in proxmox with
network drive that is on fuse.
Could be that triggered perhaps when someone was writing hard to his disk
and that would cause other fuse drives to hung for few secs and that would
trigger that BUG ?
And using threads somehow fixes that issue ? Does that make any sense ? I
am not familiar with low level memory management and io_uring too.



--

tel. 790 202 300

*Tytus Rogalewski*

Dolina Krzemowa 6A

83-010 Jagatowo

NIP: 9570976234


pon., 9 mar 2026 o 21:27 David Hildenbrand (Arm) <david@kernel.org>
napisa=C5=82(a):

> On 3/5/26 12:40, David Hildenbrand (Arm) wrote:
> > On 3/5/26 12:39, Tytus Rogalewski wrote:
> >> I had this problem on 6.19-rc4 yes. I saw it. But i cant reproduce it
> >> NOW - this is what i ment  :)
> >
> > Ah, thanks for clarifying, makes sense!
> >
>
> The following issue might explain the problem:
>
> https://lore.kernel.org/r/20260309174949.2514565-1-mboone@akamai.com
>
> It would be related to what I recently said: "vfio recently gained
> support for installing huge mappings into user page tables."
>
> smaps_walk_ops() does not have a pud_entry() callback, so we'd try to
> split (unmap). If that happens concurrently with a refault, we might be
> able to trigger a BUG.
>
>
> But it wouldn't explain any memory leak.
>
> --
> Cheers,
>
> David
>

--000000000000ba2660064c9d7236
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi,</div><div><br></div><div>Well it seemed &quot;lik=
e mem leak&quot; but honestly it was my bad assumption=C2=A0i guess.</div><=
div><br></div><div>And does it correlate=C2=A0with io_uring somehow ?</div>=
<div>Because=C2=A0i have no such issues when using threads mode in proxmox =
with network=C2=A0drive that is on fuse.<br>Could be that triggered perhaps=
 when someone was writing hard to his disk and that would cause other fuse =
drives to hung for few secs and that would trigger that BUG ?</div><div>And=
 using threads somehow fixes that issue ? Does that make any sense ? I am n=
ot familiar with low level memory management and io_uring too.</div><div><b=
r></div><div><br></div><div><br></div><div><div dir=3D"ltr" class=3D"gmail_=
signature" data-smartmail=3D"gmail_signature"><div dir=3D"ltr"><div dir=3D"=
ltr"><div dir=3D"ltr"><div dir=3D"ltr">







<p style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-fami=
ly:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">--</font></p><p =
style=3D"font-stretch:normal;font-size:12px;line-height:normal;font-family:=
&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1">tel. 790 202 300</f=
ont></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal;f=
ont-family:&quot;Helvetica Neue&quot;;margin:0px"><b style=3D"color:rgb(68,=
68,68);font-size:x-small">Tytus Rogalewski</b><br></p><p style=3D"font-stre=
tch:normal;font-size:12px;line-height:normal;font-family:&quot;Helvetica Ne=
ue&quot;;margin:0px"><font size=3D"1" color=3D"#999999">Dolina Krzemowa 6A<=
/font></p><p style=3D"font-stretch:normal;font-size:12px;line-height:normal=
;font-family:&quot;Helvetica Neue&quot;;margin:0px"><font size=3D"1" color=
=3D"#999999">83-010 Jagatowo</font></p><p style=3D"font-stretch:normal;font=
-size:12px;line-height:normal;font-family:&quot;Helvetica Neue&quot;;margin=
:0px"><font size=3D"1" color=3D"#999999">NIP: 9570976234</font></p></div></=
div></div></div></div></div><br></div><br><div class=3D"gmail_quote gmail_q=
uote_container"><div dir=3D"ltr" class=3D"gmail_attr">pon., 9 mar 2026 o 21=
:27=C2=A0David Hildenbrand (Arm) &lt;<a href=3D"mailto:david@kernel.org">da=
vid@kernel.org</a>&gt; napisa=C5=82(a):<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204=
,204);padding-left:1ex">On 3/5/26 12:40, David Hildenbrand (Arm) wrote:<br>
&gt; On 3/5/26 12:39, Tytus Rogalewski wrote:<br>
&gt;&gt; I had this problem on 6.19-rc4 yes. I saw it. But i cant=C2=A0repr=
oduce it<br>
&gt;&gt; NOW - this is what i ment=C2=A0 :)<br>
&gt; <br>
&gt; Ah, thanks for clarifying, makes sense!<br>
&gt; <br>
<br>
The following issue might explain the problem:<br>
<br>
<a href=3D"https://lore.kernel.org/r/20260309174949.2514565-1-mboone@akamai=
.com" rel=3D"noreferrer" target=3D"_blank">https://lore.kernel.org/r/202603=
09174949.2514565-1-mboone@akamai.com</a><br>
<br>
It would be related to what I recently said: &quot;vfio recently gained<br>
support for installing huge mappings into user page tables.&quot;<br>
<br>
smaps_walk_ops() does not have a pud_entry() callback, so we&#39;d try to<b=
r>
split (unmap). If that happens concurrently with a refault, we might be<br>
able to trigger a BUG.<br>
<br>
<br>
But it wouldn&#39;t explain any memory leak.<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div>

--000000000000ba2660064c9d7236--

