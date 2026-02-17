Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2BE6E9A031
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3726D6B0088; Tue, 17 Feb 2026 13:38:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31FF96B0089; Tue, 17 Feb 2026 13:38:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8016B008A; Tue, 17 Feb 2026 13:38:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA196B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:38:17 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABE1AB7C09
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:38:16 +0000 (UTC)
X-FDA: 84454808592.23.5480262
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 93576160004
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:38:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fif4pXJN;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771353494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0kfgHuKL0CgrURLYBZypVOq8WTafDbOBreYdMsaND8=;
	b=qrLp8bT7X2eJz6vDHkzs2505oAbnBhPsG1d4mRGuhFnTrvaCasOURk6fC0PDqnj8L7buYX
	dW4hZaUe2C55GOH/fu+H8iokCR+U5Bh59AaqlwTUyT0fwktkp1RAeMQ8e13+7mCwaeAcjn
	Y+U5oyt3ospm64KiK2GF5famDt01vI4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771353494; a=rsa-sha256;
	cv=pass;
	b=I5wkc+nfbzcFc6gCaFXINV5KCIKYywxq/EQ0SP5z2vy4BgIlEd2Ms6wFxKPHRHT15Uqiik
	RegkEvyJlt8qkR2IspF79wR2I2PsXIql8WOxzWYKcixyqDadEfaQxi0ENEdgg4L6ECppAu
	L7OKmC+jBeXj3kQe0JQ/fLsGlAh0PJA=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Fif4pXJN;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b884d5c787bso605147166b.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:38:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771353493; cv=none;
        d=google.com; s=arc-20240605;
        b=GSq21fdXKb+FfNSuOv50AkJry2h8WyIEiLsTrlCF4tCk2QDT2kjsfh9CF9zGwyvOsK
         072/+/pBJLXe8dw9cIR1l2pPOXmQuhv85UkWBjKAbhqq/WEyBX1VPxSICv5p/lGH6h0+
         TP4iOUEVbOM0TFui8U8b+jURQ9qgq0K8F+LOv7BInDbymfcHgKcsS90Hjx+yBj7FNRUv
         JaSL5MgYIc6b+UVm6OIbQkyjKGUhI7fGlKyMxDZfbp9v2CCXc+IFx/vErWkuWSp2oIrs
         TAnLVwUUSg2sXdCHV1G+uIvscyCYSZkp8BgKS8ca/VpzOa2VtmluWW0DVPHK/epQpi2j
         KDHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L0kfgHuKL0CgrURLYBZypVOq8WTafDbOBreYdMsaND8=;
        fh=OEFU7DDsVCzw3FBPLAaqLodugVU0YUb9xzO+F+ymxxs=;
        b=g632iTqr7ys4MN0DlUGg0cIBNIVFrKLUJoS+itFETuvC9una3NNzfATP7z8JUCeSeI
         CgiLc/HcwKvUfE36YnQ+5LByLQ8GipAszbUm1myxnTwGF4erqKGfFyEbw/RPlQZD49qF
         9yuZ77j6Qvk5ykyf27zyF8YbvJ8Gjjj36t4u9jLsr6F8uSfIIBhM5xxePy9sVZigKv3T
         YH29B86+n4RhS8313urzFmP+Z+9hzVxVkKzaefm3Kzdym7hZB0G+sSsTwOzejnG+a6ww
         h595zh+30IWhwuDVceBjyHqhN6IbJ/jrSlKFU0r7brVIvllkXiBrpXgiIsbKosI6mhcu
         SDmw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771353493; x=1771958293; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L0kfgHuKL0CgrURLYBZypVOq8WTafDbOBreYdMsaND8=;
        b=Fif4pXJNQYUNMzJJlYiy4jO+/wHl+xVxX/bQ58Mcm7IPX+HeaOFFWNBsF+E+8SQ0IA
         yBhodtUkkCtrT55IVWl3+I6Gq/Bkl0sr3bPJj9zo1cfeFMfKl1yENRTjb//Sm3xiyBGy
         09CIcmfPe8DoeXF9WvBYMSoYBZh6nIwdXZv2LHZhKJh2zKkVfLiGyTXVoiSYcoYDhAUH
         N/lFDmKFTPMpSRs8MDljFVCYtn6h9A2M04dyerqbRFomLz0NndFNWNdPGsk1L1Q4gIRx
         v8yG58WOgVDwVXYG+R83fU2Gy53FJxR8m0QqSUVAOA5jHxpuDMSumBC2KT4c7HRBPlTX
         mhWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771353493; x=1771958293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L0kfgHuKL0CgrURLYBZypVOq8WTafDbOBreYdMsaND8=;
        b=Sjt28CX2r+4YAGvWfZ8lB4DomIb9h8ZegwK0eKv+cYGGj/QPXA901hK6/FK7vIPaba
         XuBwx9uMZFMwfCRPlHCAE01FOlTlX5aI0OGu/Wx9urbJcYQRq6EjVzYYUA+hFpnYwl/J
         7ZLiiv0He0S5QL/7DeDG3tDFHUaVHimznTq1XCD74BrV61agxiiW8Y3cmdD+6jV+8VZt
         jVmC4mNyftOcjNqrs/8goxdLBJrn0lt6XdsVuKW3GGV2MZGmiDhwkp6FjOlaFzq5TXYa
         qfweHYkf8vZV6sZyM4+mMBAUX1zyMGTQyZCQxrU0k6Gtf+aXaduDGUKg9mED7WG5k3Ao
         KmSg==
X-Forwarded-Encrypted: i=1; AJvYcCX6KJANlMSP+nBAESeiXPR8/uZJiFAaND5byqy7W4zt+jjoPm+A19UDYHTX6d2po8ou657uPyymSw==@kvack.org
X-Gm-Message-State: AOJu0YyzZFox2WtxxDwXzeNX0IFtuSD8Jptasqf+xmlYWrgKpN/poPmp
	sfb6RYQ525J1Z4MyAgwZZHHKc7RtKNKGwczCQXhtmiq4n5Ca++Ahml/lFp+jGPcAPnreHwb7yU6
	DZRrf4UnKVhwiKq2Zs0qaXDoMkWMv3EU=
X-Gm-Gg: AZuq6aIcdkhTvx51FdP2avwL8DLseCmMNoJ5X9E/O66BbBv35Ngl2e2wql1biBQ0Bv7
	1IARbXGA7sJcqiyuW3rHc2qLNTgrQrUnwFh5hsv4et/N2yT1JiNZ66657wIdtzBkFhKhZDr9hP3
	EzNZwdbvvi0xun5OnxZ1PBn788gEX4cm/dhuGqaNX+e75e+GJA+0cPHoDtpMn+ec0V46DmStIwl
	6pJCxdGXIpCJ8jyb0JFXvGoeyxdwEBr1RUjQZXhJwReS18qXDnLkSRjGq8ZZjpjLo4Tx8CC1PXE
	/WHdB/SMCViNInVcGcinH9cq28W1K4hA60YQ9RRX
X-Received: by 2002:a17:907:3d0b:b0:b7d:1cbb:5deb with SMTP id
 a640c23a62f3a-b8fc3b5abf0mr768614566b.27.1771353492689; Tue, 17 Feb 2026
 10:38:12 -0800 (PST)
MIME-Version: 1.0
References: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
 <20260216-hibernate-perf-v4-1-1ba9f0bf1ec9@tencent.com> <20260216134222.5ec936d6503e72348227c58d@linux-foundation.org>
In-Reply-To: <20260216134222.5ec936d6503e72348227c58d@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 18 Feb 2026 02:37:36 +0800
X-Gm-Features: AaiRm51x0f9h4WRnSrAyvxbfHlB_6iU_mFxctjVNumteF3OZtK_Fw9fGifvYBbo
Message-ID: <CAMgjq7BGAk45oYCcZymNUcRWU-T5k4AdzgAhk6mr+xPJyD3-uQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mm, swap: speed up hibernation allocation and writeout
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Carsten Grohmann <mail@carstengrohmann.de>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-kernel@vger.kernel.org, 
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, Carsten Grohmann <carstengrohmann@gmx.de>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: inb41ysemn8teffatjiaopfa5mrztde1
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 93576160004
X-HE-Tag: 1771353494-791137
X-HE-Meta: U2FsdGVkX1/g1WwBUdVP05SEHcaK/9wVVeMQPw/IedqajdDuMD/J/L0KmOfU3m2bwMBSFecZ5ZObPTS3GSYaQ3EeYHFdV6UTCkXMTgYn2OtZjku0NmyIECPsI9jJuc5DwWbUZg9JgW0p2NAjW0C+/6FBG66eA5zD+e5cHcLYNDKrwF0IXXOSE8iDZO2bGl/XI6v22hwFj/gO4WNsLquBy30VAnJAYE134TJVDmmUlzPJ7b5v8JIUwx6hVfo6sjejrTURjnXJtUO3r67SBzaM+EUe/vNvk3UvFSmGV7xyG4GizWkYAVqkP4nQP8G1nZSbWyuwwR9+AYRSMuV+GVKDrarrGocC8bwfcJ+UHDyj6KVvh6lygBi3Bi3seIw3h3IwJTOeN2ep3/fGYbg32JWp9v5eywinl3NNC6xq332bbX+yC5L41fMHdSdgVcqjiTlTt6q6O2+si0m0vn0crJZle7YPW743h3xyvlVXQ3wLCUAhAfHnRv6Jaz4DOo3c6/0ACJUEantNjIOChKIVvsZT/oGIOqmmEDCuIxxyunXQ0WV8Emt2NODw0qHNp1SSfPTfwU0yjww7pT8ea8B5tJ8njctDl9KcUpP+CFwhpo8pxP/AUeKL0qcHkMG0qVHynFbeHL+HdKeWqnImk1fOOiNnEPaJd1lG0SihOQilOo2zI5p1E/AWebJ2B5GbtiKR55vs3DZcuxTPTcGKQAl+3OvSVZI0yIyUZ3RniNJ2ij9IHr36rQE9/zsYZR6mJcmhDcRbg95mbyD+rLqoSiAcDL9uduiw/H++XyygU5tPFxo75SUl/MKUBZol1SwQy4gF6Ur21OgNfzqMuaoqWY86cvQwvIgRjn49QHYnkQVZ5R04o37VdLml6iZdQvVHarG939DtrT7nHzsobvbD5+Lf++sAO39+sEpCEx/6VUS29N7CqGq7LOD3LLDNg6smtiGpGdIsMSx+HX4BJ5zPat0YqED
 JGGYLiQI
 xyH4AcrNB0lLz221yfrgCf6ioGAIgUcdqStQbATCgz98HvfEZSbEqkumpgbUkI3UcNwgL/mIyZTRN7BqzKd6BWZVCqQA/iCo5ETZ0PR6+nfsC/w/2hie1sxZwGpnOoW7KhzL4OIoi2UKgVnZjE9GibZWRVDguyni8bifc4XyXtg3d954cTBrcsPv8+sAW31P3441TfXY4NzNKAGFpv3yZkBo2mOhCuvME71KBdgf0Sha7VfvXo0/qDDiqr4z2OdUfZPR1FuzQlHAW20qzC06v3GIy86DPLN7Ksn6kEQyvRcXrH4nGdpnNSrmZhKmWuNs7Bzbei3fAl2/Cw6AyIO0V8RjDd+2zQohGPEIhmo0uLmimP/prqRoi+xEvBEDmWtYYrACsr6GoYuvCbPeUUsKxea0J+c10434k5KFqCE/FlV7k4ySaM7dvPjPSenChVOBaq1ntm4W6kaCyCmKIJ6w6zP9nOG5ymDCPTtKflc2DtlJqOsLZhyq3mu8sO9SqZ4SUipJVRd0P47AhfmtbmWYgfGTZhCGvtWI7+iNh/lrj8DQ3uBquIuGQtRYm5z2rT6+V2P9ExfqjMMb5uJ0bxQa98Gf5EHJga40dlO1/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 5:42=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Mon, 16 Feb 2026 22:58:02 +0800 Kairui Song via B4 Relay <devnull+kaso=
ng.tencent.com@kernel.org> wrote:
>
> > From: Kairui Song <kasong@tencent.com>
> >
> > Since commit 0ff67f990bd4 ("mm, swap: remove swap slot cache"),
> > hibernation has been using the swap slot slow allocation path for
> > simplification, which turns out might cause regression for some
> > devices because the allocator now rotates clusters too often, leading t=
o
> > slower allocation and more random distribution of data.
> >
> > Fast allocation is not complex, so implement hibernation support as
> > well.
> >
> > Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) shows the
> > performance is several times better [1]:
> > 6.19:               324 seconds
> > After this series:  35 seconds
>
> Thanks.
>
> I'll merge only [1/3] at this time, into mm-unstable at this time (I'll
> move it to mm-unstable after resyncing mm.git with upstream).
>
> We don't want the other two patches present during testing of this
> backportable fix because doing so partially invalidates that testing -
> [2/3] and[3/3] might accidentally fix issues which [1/3] added.  It happe=
ns,
> occasionally.

Sounds good to me. I'll send the cleanup separately sometime later again.

>
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1926,8 +1926,9 @@ void swap_put_entries_direct(swp_entry_t entry, i=
nt nr)
> >  /* Allocate a slot for hibernation */
> >  swp_entry_t swap_alloc_hibernation_slot(int type)
> >  {
> > -     struct swap_info_struct *si =3D swap_type_to_info(type);
> > -     unsigned long offset;
> > +     struct swap_info_struct *pcp_si, *si =3D swap_type_to_info(type);
> > +     unsigned long pcp_offset, offset =3D SWAP_ENTRY_INVALID;
> > +     struct swap_cluster_info *ci;
> >       swp_entry_t entry =3D {0};
> >
> >       if (!si)
> > @@ -1937,11 +1938,21 @@ swp_entry_t swap_alloc_hibernation_slot(int typ=
e)
> >       if (get_swap_device_info(si)) {
> >               if (si->flags & SWP_WRITEOK) {
> >                       /*
> > -                      * Grab the local lock to be compliant
> > -                      * with swap table allocation.
> > +                      * Try the local cluster first if it matches the =
device. If
> > +                      * not, try grab a new cluster and override local=
 cluster.
> >                        */
>
> nanonit, worrying about 80-cols is rather old fashioned but there's no
> reason to overflow 80 in a block comment!

I'll be more careful about this, thanks.

