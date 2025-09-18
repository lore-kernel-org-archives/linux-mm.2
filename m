Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65059CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B89A728003B; Thu, 18 Sep 2025 11:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B39648E00F6; Thu, 18 Sep 2025 11:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F5328003B; Thu, 18 Sep 2025 11:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93B338E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:44:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5337A576E3
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:44:06 +0000 (UTC)
X-FDA: 83902792092.11.4AB475C
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 56464140013
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:44:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K+veIzIX;
	spf=pass (imf23.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758210244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+D+JfJ/Jq0/jdAS21NjzfpdXlFqTr3y01BMsRdUEi8=;
	b=xqhf/vy/sz+VZHXFsCwxapxhWJrhxqjgh9SwrRy3A5eG1O1D11eYrrYCTFF4g8XuBJOWjp
	0um21oCgLqvlEonvD6e9+8kHgyZSXTHnltPHvRdvctDEdGg9QCFVYmYzwmiMvcWsmBLT5Z
	V1/MmpX3aEy8dmzpPNmpvVARHCfUX+A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=K+veIzIX;
	spf=pass (imf23.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758210244; a=rsa-sha256;
	cv=none;
	b=3Ro9TI0j3OTSNWF3+wpfjdVGLoXmLmCBPmiGlUct3JuUBNqS5SuMH7yZwmkICR78Xrt+Zx
	/S5fJjbBvl3LCKGyzZTAJ+IRzQ8Ib27VQ3m2y1u9IubiGtwJiu7PeznVNl79WM0qQ+XMzS
	KiNL84ATzBrEGM7xfR8X/UTBh9+3I20=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45f2d21cbabso73555e9.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758210243; x=1758815043; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+D+JfJ/Jq0/jdAS21NjzfpdXlFqTr3y01BMsRdUEi8=;
        b=K+veIzIXu2/22tDW2/TBvFcOPFfWmzr/90xQgh5r8+KItWGeI+oJ46b01JslrGFfBu
         nhQSY1jGIFDgjLuUByBc4t9RL9wWhaZRSiHF9eWYAEaOwTWg3j8tAeMNRgxLWyOC2dYu
         uPkdRCT12+XPoAb3fO5xkjnIKhson0hnhNqCxTFamCeJx9Iecxpivawx8OXRPwpkg26Y
         unsZeESqxC8IGLRE/DDIzREJjs0880zIAv3dN7c177a6V4pYrHscyhjXWiek88nm82Om
         1jUkHUMzpfulSbputD1WNKpLIjyM1+ThCPqJayONHvptcctetHcd9/TuEJmBz0e6k1q0
         4dKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758210243; x=1758815043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o+D+JfJ/Jq0/jdAS21NjzfpdXlFqTr3y01BMsRdUEi8=;
        b=Xk08O6WcJ99xLTDGkDb8Q4nwdo/ZOXtvFNhkytp4aM9n5MKB3Vr+3JTHjAnbteBvaj
         TGj0xDDPs3d6vVVN0yckrRH9qTqRH7Gcb46+C8r7aLxqqU7aiWZq6KJYWNxvYtWs+Gjp
         b99qtJDpWIejYfgf1xr3wc5baqximqFGyuT3sknLSjebE/UlBqE8v2axt9XDdTDK7B0A
         S/+dDfn9Au7beaI4OS6mesSLEncppI66aMiHdNpMt2dPZ1kRkIO6bskbHoVCxEH0eOhk
         enDV8BlrV67meWL7GaQAjtIXTRe6HkcWGLpeeQt6M/h9tge5zeTOOeYfgJSq8WGP9Oge
         hA4A==
X-Forwarded-Encrypted: i=1; AJvYcCWVmhvcI2mXsOYj0EsyLsLj7IazivDw0tj0uhJbzcwZAvLZWt8h28/QKJOw8VCDv4djBeWQ0lmiXw==@kvack.org
X-Gm-Message-State: AOJu0Yx10n2VtquNn0+Tl7C+iqFNozm+tWKbZSoCqZNRXOpLKSE3QWS8
	slgsermUX1Nsn6xh4YdzyAfn+MuM9smfX4r2vGwBJQa8bsNYWSuml6UsHivaoqCOK8jzKuftZLQ
	DnyMmFolptMs6XXfAVA9KkHSEDHVBZsS5qVdoD4rq
X-Gm-Gg: ASbGncv4cjDAKpirK/PiwVrohww82AVpbKFrJEJ4d/abezuS+kguMPsqiDkra7ufPPp
	+y0STxRat4aHcNsC49oGRZZoMRjksKhB2GsXP+5movSb7ejC7uYVLHSjAsRTeNGII63DVUOsgA8
	Zx57k2ylHIC/AduGGxGFUnD+hYA8L9egRWw/4bb0p/KikVANB0XbJxVX7Vd7dZWSSO4vNWZkSEk
	wh9TOWpUBzwBDbYfaq/oygk8GuG14ckGxUNxi4990qmOUehdQV7dpAiQ++qfsNJhg==
X-Google-Smtp-Source: AGHT+IGKDPhFW7QY2ThA23Eiqh7Jb4gB3IAedet7C/hbJyJis0arTM7d/07UQoRXJ2ALik0wfBJpwlDyK2X2eoThyyw=
X-Received: by 2002:a05:600c:621a:b0:453:672b:5b64 with SMTP id
 5b1f17b1804b1-4616dbbbb8fmr4089715e9.2.1758210242387; Thu, 18 Sep 2025
 08:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250904155720.22149-1-tony.luck@intel.com> <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
 <aLsHh70jI6BGHjaN@agluck-desk3> <bwu744g3qzbzylxvfgt7v4tnf2k2eosqbkg7alm6u5roa7j3bn@gmut2l5227kw>
 <aLspJ5Tpqp4qRDk2@agluck-desk3> <cf05bc8e-fc79-49e4-a90a-47e661b4ae69@oracle.com>
 <CACw3F538k+dshTs1_rxbpYoRdFyX3tLYzfaWj-_d7Lq5Dd2Jsg@mail.gmail.com>
 <aL8rIgSImDh7Nj7E@hpe.com> <7d3cc42c-f1ef-4f28-985e-3a5e4011c585@linux.alibaba.com>
In-Reply-To: <7d3cc42c-f1ef-4f28-985e-3a5e4011c585@linux.alibaba.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 18 Sep 2025 08:43:51 -0700
X-Gm-Features: AS18NWBE_Rh3aqLAP0Y0-SJP8rZCEq2FVPADSEjBbJ_MtsZw23_iRMOUp4qz4C8
Message-ID: <CACw3F50hU3BCP=A++Dx_V=U8PKvsTvTa1=krULxfQdeK2kVBrw@mail.gmail.com>
Subject: Re: PATCH v3 ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
To: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Kyle Meyer <kyle.meyer@hpe.com>, jane.chu@oracle.com, 
	"Luck, Tony" <tony.luck@intel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, surenb@google.com, 
	"Anderson, Russ" <russ.anderson@hpe.com>, rppt@kernel.org, osalvador@suse.de, 
	nao.horiguchi@gmail.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, 
	linmiaohe@huawei.com, david@redhat.com, bp@alien8.de, 
	akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz, 
	linux-acpi@vger.kernel.org, Shawn Fan <shawn.fan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 56464140013
X-Stat-Signature: 4wskycxqsbdfz9oqrw5apifjikypyotp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758210244-601740
X-HE-Meta: U2FsdGVkX19EPIzUAvqCgwenO7W0S2lk9BzPZ1Hda/Sgzt3H1+kWQ56/oVWyxJiCtAcruDTUoZ6SQnpjfw0eG4pWxL5H8urbg40X/4lXvHFSq47iHKzOjadjSXuJusxvBV9O8dLaJiTE4lFtoGsel+Nsp3CHzTtlIyBkSBAdkmbNk0AljI9zfHA8EUM4UKoypvVVs0DB8Y7M2usz1fymE9oENaqNH8FSNDdi4EMzVNM6c+a943XT2GmLyn3cx8PMAraQi6f32Cnc3u2pDFB58pzbpsMrJ32g0ks7jl5jlz6fYXVi7mk6gsK20pxu6oskmCMXOF68pRAbL2vjwIAbrSpCKG9bEEGuS8kG7hMls0ufft9s2+aBHamoBX8GsBra4W6N47SoLJBX78olUhu+ABYKD46GpvT1XPMezMoRGxNJR3USfTN4IbpJzvwxwuRcRZ8lMsGX9NmBDBeP5dLSW71S1q+u8qUsWYX02KsOvidfRjlexDcXGjXrCMigwBTeXeChO8kM3EBqXsjpFwbc1R+1uhLer8bH6wEUnuI+iOGiID1j3Q+s54R3d4rSEJqnbXM9TW785ebLShs12+ofv5hdDeQ/3Fe70pmkBQ5s+aPPkJB0yIrWtUDBpE4IqIMnfZhBGZC4R5/fRXh0K74d7YsBIxPtHCi6hMavkXCoKPblkYup317csjYU4l3fa9xhPsxDULV0owOAmyV+nXG1LZg6ayCG9j1YzmVLnFd9067AZxGY/ImGbSUQGL4oNu4zu49bkQFC2D/TF3zhzukU/njaOKVUC/VyjSpgpeXACB1WsxpWRBFq8HKv3EwoYdKfAeTFDIh4huvi3KjGOXCzwr0SoACan4S5IoyztaGfKzk3TWqAlrVz1ODLa8nCThHFqMqhGy5oqRMMT2L0Uqkt0DI5E4KeS4h6hAOwcvIVpXwc4i+OXvBvCuAlfD7tAnfYtpBX5XqWHDof6h7dolk
 oL9GUm5I
 urkFBArmcwrDmdg3ULNi8WMJ46bIaiKQdoYQlyck/X+gUtSkO7VaLgOIUR4x2uD7ukolxvJ3/tCq/JJ2vP5p7ChY3LGCi+M/J/JV/71v8yUYmuebHtrJNMptSHKffoctir1i9uWElrRUXOvyO7Y1CmFBzgnkS01GNoiA+NAAkjE/Fu1mb4KmPZdhMeHxftdCe/+iwz7icaF+M1bIetCSvyzdgisen+eHMfNxkx2Kn7HQa/jssxvZX/3dMztjOveDBS+OmrX4YoKn9udlkDjuxxE/QHFsGuSQ7xFj/mhBG2iZP0RfU02aB5OEXPpdfuuAcKUEnna70QazQU1VKuVu2PV2V1slI0auKkrfVQ6sspSfQgt1QYmvowoR6+9J+S+ZNMG4b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 8:39=E2=80=AFPM Shuai Xue <xueshuai@linux.alibaba.c=
om> wrote:
>
>
>
> =E5=9C=A8 2025/9/9 03:14, Kyle Meyer =E5=86=99=E9=81=93:> On Fri, Sep 05,=
 2025 at 12:59:00PM -0700, Jiaqi Yan wrote:
>  >> On Fri, Sep 5, 2025 at 12:39=E2=80=AFPM <jane.chu@oracle.com> wrote:
>  >>>
>  >>>
>  >>> On 9/5/2025 11:17 AM, Luck, Tony wrote:
>  >>>> BIOS can supply a GHES error record that reports that the corrected
>  >>>> error threshold has been exceeded. Linux will attempt to soft offli=
ne
>  >>>> the page in response.
>  >>>>
>  >>>> But "exceeded threshold" has many interpretations. Some BIOS versio=
ns
>  >>>> accumulate error counts per-rank, and then report threshold exceede=
d
>  >>>> when the number of errors crosses a threshold for the rank. Taking
>  >>>> a page offline in this case is unlikely to solve any problems. But
>  >>>> losing a 4KB page will have little impact on the overall system.
>
> Hi, Tony,
>
> Thank you for your detailed explanation. I believe this is exactly the pr=
oblem
> we're encountering in our production environment.
>
> As you mentioned, memory access is typically interleaved between channels=
. When
> the per-rank threshold is exceeded, soft-offlining the last accessed addr=
ess
> seems unreasonable - regardless of whether it's a 4KB page or a huge page=
. The
> error accumulation happens at the rank level, but the action is taken on =
a
> specific page that happened to trigger the threshold, which doesn't addre=
ss the
> underlying issue.
>
> I'm curious about the intended use case for the CPER_SEC_ERROR_THRESHOLD_=
EXCEEDED
> flag. What scenario was Intel BIOS expecting the OS to handle when this f=
lag is set?
> Is there a specific interpretation of "threshold exceeded" that would mak=
e
> page-level offline action meaningful? If not, how about disabling soft of=
fline from
> GHES and leave that to userspace tools like rasdaemon (mcelog) ?

The existing /proc/sys/vm/enable_soft_offline can already entirely
disable soft offline. GHES may still ask for soft offline to
memory-failure.c, but soft_offline_page will discard the ask as long
as userspace sets 0 to /proc/sys/vm/enable_soft_offline.

>
>  >>
>  >> Hi Tony,
>  >>
>  >> This is exactly the problem I encountered [1], and I agree with Jane
>  >> that disabling soft offline via /proc/sys/vm/enable_soft_offline
>  >> should work for your case.
>  >>
>  >> [1] https://lore.kernel.org/all/20240628205958.2845610-3-jiaqiyan@goo=
gle.com/T/#me8ff6bc901037e853d61d85d96aa3642cbd93b86
>  >
>  > If that doesn't work for your case, I just want to mention that hugepa=
ges might
>  > still be soft offlined with that check in ghes_handle_memory_failure()=
.
>  >
>  >>>>
>  >>>> On the other hand, taking a huge page offline will have significant
>  >>>> impact (and still not solve any problems).
>  >>>>
>  >>>> Check if the GHES record refers to a huge page. Skip the offline
>  >>>> process if the page is huge.
>  >
>  > AFAICT, we're still notifying the MCE decoder chain and CEC will soft =
offline
>  > the hugepage once the "action threshold" is reached.
>  >
>  > This could be moved to soft_offline_page(). That would prevent other s=
ources
>  > (/sys/devices/system/memory/soft_offline_page, CEC, etc.) from being a=
ble to
>  > soft offline hugepages, not just GHES.
>  >
>  >>>> Reported-by: Shawn Fan <shawn.fan@intel.com>
>  >>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>  >>>> ---
>  >>>>
>  >>>> Change since v2:
>  >>>>
>  >>>> Me: Add sanity check on the address (pfn) that BIOS provided. It mi=
ght
>  >>>> be in some reserved area that doesn't have a "struct page" which wo=
uld
>  >>>> likely result in an OOPs if fed to pfn_folio().
>  >>>>
>  >>>> The original code relied on sanity check of the pfn received from t=
he
>  >>>> BIOS when this eventually feeds into memory_failure(). That used to
>  >>>> result in:
>  >>>>        pr_err("%#lx: memory outside kernel control\n", pfn);
>  >>>> which won't happen with this change, since memory_failure is not
>  >>>> called. Was that a useful message? A Google search mostly shows
>  >>>> references to the code. There are few instances of people reporting
>  >>>> they saw this message.
>  >>>>
>  >>>>
>  >>>>    drivers/acpi/apei/ghes.c | 13 +++++++++++--
>  >>>>    1 file changed, 11 insertions(+), 2 deletions(-)
>  >>>>
>  >>>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>  >>>> index a0d54993edb3..c2fc1196438c 100644
>  >>>> --- a/drivers/acpi/apei/ghes.c
>  >>>> +++ b/drivers/acpi/apei/ghes.c
>  >>>> @@ -540,8 +540,17 @@ static bool ghes_handle_memory_failure(struct =
acpi_hest_generic_data *gdata,
>  >>>>
>  >>>>        /* iff following two events can be handled properly by now *=
/
>  >>>>        if (sec_sev =3D=3D GHES_SEV_CORRECTED &&
>  >>>> -         (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
>  >>>> -             flags =3D MF_SOFT_OFFLINE;
>  >>>> +         (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED)) {
>  >>>> +             unsigned long pfn =3D PHYS_PFN(mem_err->physical_addr=
);
>  >>>> +
>  >>>> +             if (pfn_valid(pfn)) {
>  >>>> +                     struct folio *folio =3D pfn_folio(pfn);
>  >>>> +
>  >>>> +                     /* Only try to offline non-huge pages */
>  >>>> +                     if (!folio_test_hugetlb(folio))
>  >>>> +                             flags =3D MF_SOFT_OFFLINE;
>  >>>> +             }
>  >>>> +     }
>  >>>>        if (sev =3D=3D GHES_SEV_RECOVERABLE && sec_sev =3D=3D GHES_S=
EV_RECOVERABLE)
>  >>>>                flags =3D sync ? MF_ACTION_REQUIRED : 0;
>  >>>>
>  >>>
>  >>> So the issue is the result of inaccurate MCA record about per rank C=
E
>  >>> threshold being crossed. If OS offline the indicted page, it might b=
e
>  >>> signaled to offline another 4K page in the same rank upon access.
>  >>>
>  >>> Both MCA and offline-op are performance hitter, and as argued by thi=
s
>  >>> patch, offline doesn't help except loosing a already corrected page.
>  >>>
>  >>> Here we choose to bypass hugetlb page simply because it's huge.  Is =
it
>  >>> possible to argue that because the page is huge, it's less likely to=
 get
>  >>> another MCA on another page from the same rank?
>  >>>
>  >>> A while back this patch
>  >>> 56374430c5dfc mm/memory-failure: userspace controls soft-offlining p=
ages
>  >>> has provided userspace control over whether to soft offline, could i=
t be
>  >>> a more preferable option?
>  >
>  > Optionally, a 3rd setting could be added to /proc/sys/vm/enable_soft_o=
ffline:
>  >
>  > 0: Soft offline is disabled.
>  > 1: Soft offline is enabled for normal pages (skip hugepages).
>  > 2: Soft offline is enabled for normal pages and hugepages.
>  >
>
> I prefer having soft-offline fully controlled by userspace, especially
> for DPDK-style applications. These applications use hugepage mappings and=
 maintain
> their own VA-to-PA mappings. When the kernel migrates a hugepage to a new=
 physical
> page during soft-offline, DPDK continues accessing the old physical addre=
ss,
> leading to data corruption or access errors.

Just curious, does the DPDK applications pin (pin_user_pages) the
VA-to-PA mappings? If so I would expect both soft offline and hard
offline will fail and become no-op.

>
> For such use cases, the application needs to be aware of and handle memor=
y errors
> itself. The kernel performing automatic page migration breaks the assumpt=
ions these
> applications make about stable physical addresses.
> Thanks.
> Shuai

