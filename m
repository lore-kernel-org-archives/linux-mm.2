Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A87310706ED
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 16:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26F46B02AE; Wed, 18 Mar 2026 12:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB11B6B02B0; Wed, 18 Mar 2026 12:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B519B6B02B1; Wed, 18 Mar 2026 12:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A02AE6B02AE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:02:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A72513BAF1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:02:21 +0000 (UTC)
X-FDA: 84559650882.24.9D18666
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6056110001F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:02:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Q1/EHq35";
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBf0X4ZI8hrueKElVjOm/fdCiPNUuzJRpv2jzIUCVLI=;
	b=vDEgyXiSAT7PJ/O77oQ09MLFc7e8/y2J5sV1kUjCcCmLaIGmv/zaB+ttHViBDzyA5BKl7m
	9qXc1qDsFskp63FL9f3jJWj9+wdyVdrpl6RhacCuqGt/EgHYjsvmVx3gqVwN71x/TvmQFL
	LebUKI75bjBD525qkoJqh1npCEyVdWk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Q1/EHq35";
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773849739; a=rsa-sha256;
	cv=pass;
	b=1Dxq5gB177CKiTBNgE2baBrhHoRwAeEvEj1lMaiRCZE/rrmU1IV6MhDOwGorLb3ivJ+jyK
	t59KT63D/kTMzY1Hl5BmE2RdjnBx+MXJBXuYQPPL1nWWjkxcGtngKTnhHRIEWlmIACqAUL
	KmCZOv30Y3lYp7J3rJKqZaMg2DzL+O0=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-509062d829dso620721cf.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:02:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773849738; cv=none;
        d=google.com; s=arc-20240605;
        b=kJdubilioNjnBhZWrs2A9GTRn+cidY5V0HJQUokCTmE4TdF05N1GMZoU4AHBoFABrO
         VmGf3T4szX1hHKqKKw1W/n0IRofzS1SgB8jQlM8YovQQmjrbWHGLayx7PQrgLeVvtHu5
         iLrC3wWDvIDmQHZ/ysxjXLp2gzCJpNH1Fj2qFuoY4l9+jzoIEg/adZMI4ydKz3+Qed8T
         D+zuokYm40JtwJAZeFOhTWWzM/V3NL9L89cwUOlswxiEseyw3dypOphk+fBc+D45KJ5y
         nO2yg+KVNufCV6Msleibp5vVAXsNSCwKqFqzAh9MLguDYPTXgdWOwuKPGvGgvSR4G3pH
         jjFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bBf0X4ZI8hrueKElVjOm/fdCiPNUuzJRpv2jzIUCVLI=;
        fh=ZKJvTbXCseCJyxdBB8h4vDj6EQf3Iy76S2icofg/Mq8=;
        b=hQpnCEujxqHoX91k+jKwOlw/cm9eJpiEJfWYxJnKEto8GoBtd1XPGAjL5C7xR9zE6o
         RGYu1brXFSDgGwLAMGAoDWk1EGonTX7+XwZin/M7N2mjE+06m1esYc1cwDPntzWV325x
         pDf3bmj5kezTz1o6rdJlEo8dppep4QkH8+K2Ed3jSDpWYIM8Nxl2XkrR02wPtR+0GEHq
         UP0UZRXNC/hubT0D0fxoIvqlJek4/VXlucCjuaZz0I5VTj6T+7J1rsQZ32cnNqB/sM0A
         yNn7fNpPgFMnTsZ1+NfbqO/jFvibPvpe6aHBDEqW2DSFUV0gWrABjxL9ID0BqVzTYDsP
         gybA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773849738; x=1774454538; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBf0X4ZI8hrueKElVjOm/fdCiPNUuzJRpv2jzIUCVLI=;
        b=Q1/EHq35VmDOyqpYy22UaS2BK8BmcXChbvO9zF2IXnA3EwTDZ0buLUQyyJO8oSUUlR
         HzCQxTJfydJZWK6DFSARIFs36LZ+N3sUPMZ6pj/kD4c3tRqm1qsiTr4Ha8ouyVzdEE1j
         wg7l2ABAauDVYoBpgk6qO5S4VVyBzoH1IljUusTvGRTG8Ny5Mq40qBvK4rsbeOSyCC24
         eh/hCsGXuhiwxJOiC6xFsDGeRraNpWh0aT1byWMizib393+acsb+Uwouzl2MpEkuBm6u
         lv5zh8LLBjbWto01nDsyuFXb4TgLT5amXml+9X4le5N3a5wW4oZ6CrQifQxyAxe78cGZ
         H2TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773849738; x=1774454538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bBf0X4ZI8hrueKElVjOm/fdCiPNUuzJRpv2jzIUCVLI=;
        b=roiwZeMgW8kOD7ORAyLO8bbqqgM2e+LQyubB7e8FWJnn54X9Hk0e7t2ibBem3rirr3
         9TRO/0YyYDMnQuQFaesYuKQiEk8b519yx3x3kfu8nIOqokNMfVAaIoJprImXKIsn+COP
         VeyST9g07nT5TsFaO1P2A+xXe6pJxGE7rWS+RHS2PEEfoqqpYa3hWmwS1O0AIjbp9tzH
         0N76rhYWi/rHO0oqWeKtQ/QyicXq2cJY4KMG/k6mNgnPt2onffILHwocSWiXMIaiCbad
         qHq/uUJxx3vYK/YtdzIFq+aI2uVBL1ZQUxOuZlCKg22nn9wp5z8G1+YKH04EHhHHYID+
         prOg==
X-Forwarded-Encrypted: i=1; AJvYcCX5B7GgurtLpTnGid5KCI/qIPMMb5YF8ZnqiLswhaoFzQUoY/LT9Rbpza/S78ttzK18CzFJd3ddSw==@kvack.org
X-Gm-Message-State: AOJu0Yw7xDhNij+JK2J+PQj/aAnLmD49HvaJqn5tIHm15NdSlKmPv45I
	Rw0JQ1nfiH1WwpzCTPl4ZVQy1Z7j9NU34P4/Li/xBAimlbGtXqoNknZ/g5GnoaCWXDvhxdQo4cb
	bQaeSBDLyOJjpkvt4yIDhEj5/bNXZodU7fTFQmd+x
X-Gm-Gg: ATEYQzzQuVqlLuWIb/mWad1xXxnMM4I98lAqwJhg9imfoFoK9dzkr4w1p/a889YN+E3
	gXTM8CZSbkuVIRTIKNQE814AHY7VKIS/p71MMp8bQHVl2Io5xdTc/73SuW1mmP48Zf2Dr2bD05V
	WCEaKtptnXa45QwsBf8ME0VXx54ismCSIypKz4hsUu9MO/oQOL28Yp9tXw09HgvnZLiOWvWtH1c
	k3EhL+DHUWtYnY87tU4Rm5Dgm2k5gU+Hr0dKxNhU19oZ6gSWB4/ZVJfmKfMEpY7Py2j3+RDSezA
	xj3xiE6ZhbYoIHJPc6j03lU4dOk8E73a2PjZnotCwuZ2f+a6
X-Received: by 2002:ac8:5d4e:0:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-50b1462cacfmr16816931cf.0.1773849737454; Wed, 18 Mar 2026
 09:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <4e152e7b8e1a93baf0777628eef9409d031cf8f6.1773695307.git.ljs@kernel.org>
In-Reply-To: <4e152e7b8e1a93baf0777628eef9409d031cf8f6.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 18 Mar 2026 09:02:04 -0700
X-Gm-Features: AaiRm52kf0p9Fxu6EolM9nhc_2BIDOLEzyHhrKwtGPKlzkXo42y6XvhNDeOCJ6g
Message-ID: <CAJuCfpFd-d-E24d5-G6=dSYDpyHkwS=aXzGd6+SzyMkgssyPAw@mail.gmail.com>
Subject: Re: [PATCH v2 16/16] mm: on remap assert that input range within the
 proposed VMA
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6056110001F
X-Stat-Signature: ofeczf334osu5dwa5s3g765h966mept1
X-Rspam-User: 
X-HE-Tag: 1773849739-335833
X-HE-Meta: U2FsdGVkX184R60XJ4NKacOr0jwnC38zuAnbKzDI/MOnnpKNuXVGqTiNXvS25Rkn57cd42GoL6StNSlkZvLY0VukA5/qjGa0u8nc7TKGfvcA0lDJ3ur+BF15eSOnRlDx740eDKVxeKGPyuaIbrnrimKrC9ls/AnEamK9Rzfrco0dwjcImFwj0Hi8CuMKh/ffecd9upvtdHUexMs+ffkdGupB/p981J4khVRFbQeuZevR4nhlRl6RGr0FFR+LVvXfUClurNEpFUZ7nuYKXCCkb8aQuA5zuAqSLedudvu450oMJQC/zrpu7qoZycz9FPUdGcxKfHQIPd9Ga5+Zt75WebA5DWQbFHPQ9vWJq9gqVXgBN7DhUDED5U5uvNJklz+5QLexhd58XC04LpHnTofLtWgpPQjQxhpO/lMt9TGi3Z1qBb6dtDhXlv1CGer4ttfsUb/TEG+k2+XBkLHSFFkWrb1lneWvng+uLAAYTA/8O6ZAE5evj+IfoaaL4zQ0XeRZ80JrP6wbJIuXP9ObvTW5dbMqIeAuC/93gI6uWYgoxQfjpHIaPzf1XJck9EjjXCGxuODq12+V3Kzk8nCU5kRP+ZR6Jd+rmac1JVdgp6IoDH3Fl4NOzCG4sDCCN0Ro1ZMiqsa+djRdVoNBwAtdmevH7UGVhAVK7zix2Dd52v5FoUwmrT+Aoa53BxSFa52owCiWBGV2RV21hFcMBAkB7F+FzP7ash97Fh8DA8qNhHehIb3iQJ9ws3knNVZ5+u72ZvkayU3rhYy61SdhD77FOayu58+Y4L83zZGuEKyMQ+fNZagNA95c/hEP1BKbMHsOGqNui8O6B2wZSxfVzqmC3/44W35n0D4uj2KJFHczs0IyzHlfP6SdqKcEbyNyBchhXuB8RyGbAk5pXrM6ZtOpPIxwMwROSsoDMsWxtK70E3PKaaEEPlBnB0/U0v9NIBNdjyAj3eAuIiCfukmDjksJj1C
 Eaf9GmAh
 LNlj9NXA3FVa8PRWnb5n/Eyf24cK6YpJtAJgwm7NdO46DTkULOUaNupM/k+kzLjmQcegriYDHjU0OijInnzCk5BV5g2C3pTCZbcCJfHSXbUcqRXTUWQucfef2r+rQ2ebn9Zr9Ghkr4j/ojYj1s+azWB3E2uAk/WeEFPtEsbgrMMAi5FG9EHaSwNitsWE7V71HQxiqWRFxNB0Ha2dbwvZUUlTrui7BkWKk4KXX6nsAKM+tbQxYIN2Lcj6PYNdBuk4L6dAwi8GJUlrpBenMzk+17tUkH1h3hn43m0zEzLpVmuK720NIi0WkoDG1v5gx7MwB0HD3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> Now we have range_in_vma_desc(), update remap_pfn_range_prepare() to chec=
k
> whether the input range in contained within the specified VMA, so we can

s/in contained/is contained

> fail at prepare time if an invalid range is specified.
>
> This covers the I/O remap mmap actions also which ultimately call into th=
is
> function, and other mmap action types either already span the full VMA or
> check this already.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/memory.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 849d5d9eeb83..de0dd17759e2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3142,6 +3142,9 @@ int remap_pfn_range_prepare(struct vm_area_desc *de=
sc)
>         const bool is_cow =3D vma_desc_is_cow_mapping(desc);
>         int err;
>
> +       if (!range_in_vma_desc(desc, start, end))
> +               return -EFAULT;
> +
>         err =3D get_remap_pgoff(is_cow, start, end, desc->start, desc->en=
d, pfn,
>                               &desc->pgoff);
>         if (err)
> --
> 2.53.0
>

