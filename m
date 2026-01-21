Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 691E4D262B2
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 05:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A396B0005; Wed, 21 Jan 2026 00:51:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17B96B0088; Wed, 21 Jan 2026 00:51:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF686B0089; Wed, 21 Jan 2026 00:51:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A82D6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 00:51:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D8085AD8B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:51:23 +0000 (UTC)
X-FDA: 84354898446.06.FFC5FE0
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25B5DA0007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 05:51:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="JXiKx0z/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768974681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6vdWFdg0sDT5jGzlnooDJHQGt6SwRkysCk75zY2WxtU=;
	b=QjQUFX/Qk8GGv+WVeYuIS9h0PxhP89UqT5u8lHjCLJZiXVN2hY6biMC6U2LTwK3jHs4gwr
	AN8K0kc810RRohNZ/DJpMaKdSND0fiCM2u71D++TQyWlcAEXrARLZWdvF5F7wYG0jqN/uP
	1eCfZi0/7O/Htzc8+eOh9Lf6lTpdpkQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768974681; a=rsa-sha256;
	cv=pass;
	b=quwhbGSfcrvt5YTYLJ7KbohVEhx/mgOd61Nrg2zADlMtW01thaVxx/qgxsgsLOzag+F493
	4iqKbaR1v/e4E2GjIIG49B7sCSbF+LRt2u+RykaN0GA+v3ycH5mY5mT9j6aQFkWilHFkmw
	K5eV44Wu3GaM5QLdn0x2O1adJYJGzLA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="JXiKx0z/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47a95a96d42so30645e9.1
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:51:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768974679; cv=none;
        d=google.com; s=arc-20240605;
        b=Hp7uCMg3Fk3uWiArTmxyITcovgTmzTxXiQYgRJLSvb1fOjFhwUdesKznJgWmkx5ujR
         FMoeOYd0RQBB817nq0ZHE+VdLXvFv1HC5NyUB+AxAtM8XrmiMuVaOplg0krapiGKszyx
         sZIX3NiASUEIELkpVwX2txcfRLmAqHISfGjTq0EXpiP9/EdRZa3RTLtAUPEOtNoUa/1f
         +XudvmU+HIEbKJjVHcaJDXfx4aLyfinZJUgW+hrNu0/lUmajTus5cmxdzA+K2L033Cxc
         RiSxZhaah8YHkb/zkylaq/Qs2VptHUYCrTu1KI+GxML7vWHo9tedlsE2XIwavn915div
         amAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6vdWFdg0sDT5jGzlnooDJHQGt6SwRkysCk75zY2WxtU=;
        fh=MudwYk2pk2TGjhcylV8S1ViVeV0nd8CUz3ZRuUDsgOo=;
        b=YOK1Bw+lqfSPQFrcamsTOraIyjEVBOHz8GohDvmZZhIvkqsVwequlTTzhUgGTZGUUA
         cng9l0067ZnG8gt0FM99f9NKID+0FYkoI8cninYUD/jALC05JX45njSQ4DJ0vaWms8kH
         UXbRNSh7CfnJ9rTH0I2oQoSNtPWWp2/VtL2OF6gKTfJBJMBzpTMFTPEGFpKRHaRaQcpH
         SHs2Hj0ZOVQQe/bGmGXbvQJB97vub9PrKs/YnRzomyxyHQ5ehlsddNsp0CXx+r3bbAJQ
         pJqLbHe8bY1NX6qePMkzJIfLE5XjkV3sCuihQE1eJuFaLmp0zfQqMqKCo0cuWY7qBW1L
         iKZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768974679; x=1769579479; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6vdWFdg0sDT5jGzlnooDJHQGt6SwRkysCk75zY2WxtU=;
        b=JXiKx0z/otabJOVEw3AV0cuj/KUJgJWWsT7UxJYv/VGekI2bFX75IGt8Uc46OcexL9
         mw0uU0AmjNnGycPrBtFNwPuiUESpRq8bTe9fRQLDtccAixLW9nzVJN0nfdHzprzdhG7p
         ZJ5wKgKSeq+WGeixDz72mVQxnq/tFWUGUYXU9b76Y0spQY3eSQsTZ7wJwLDMDmLCOP9O
         ormYynrTxY/5eLKIIn5QlFxNdbhkAXGtBjXqPIHrmV9CXwhTQnYDavkLtWldsvX7h9mh
         cGX3d99laRsLkqoF2joyqKtllB2Xh+811fZXC+vySAzMa2kA0WGKYEoG7HKmyR4+dNwu
         NqTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768974679; x=1769579479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6vdWFdg0sDT5jGzlnooDJHQGt6SwRkysCk75zY2WxtU=;
        b=Ljn+Yj1on2YxumPteZ4d6kmpEA+NhSKF/8b8kFSfM2+I2Ox3nm6crVs6VvAgll9hEs
         N0ZL8jgAZMZ9VzB8eUFH7KaEkzW2P7gjkKxx3kUi92+Huo4vboVHztgVkMJRAOjSJkFE
         X4lwT9hi0Vu7+ewOhdhwGmVBYKiYOuQo9TbTIn7zgt/qb3VpTQ4JoXxYLrL00J/hg7s3
         gqgOPCF2ahy51atzrm5WkxNjrWRWCIUhh6l43wp1x0jMDpMfmStWz2phau6tzmNAn2nC
         c1nMtL7tVQhwmJJ1j9bPM8Be1CfoP4QPJsyVIkleqLbAYegCCu93cGdghEyMfLKowF8q
         9cfg==
X-Forwarded-Encrypted: i=1; AJvYcCUczZHrploTJgs7ul2RgGx042qFMCeS/pKsHcX5FhRQR5gwQ8bc9o5BIfOqRsBgwnAsJ8pzPsixaA==@kvack.org
X-Gm-Message-State: AOJu0Yz0AzhnsnetS9o+My6Vx/TK2HH2C/nA9h7QYxbO94MYhvDn7uq5
	xy9CGJaSs2FmFzybmAr4QPSNapSJfiQL4fKHfu4eo4hjj7b3FCnv0FkObCczgxTMbVk0r6KqnCa
	4XK3DrIrQqUO4aJ+lKjY8KglOqxy2K1NBFnifXWR3
X-Gm-Gg: AZuq6aIri8Fytvsa+s7bmCLlyMbzjMrZUMt6U4Q2v9Lpf8BsU3CuWoG8Vkudop6hJL0
	GpZh4+LikLH9s7ZkWyIke86bZZMr1RzI/yYUHwatP1Hc5Ktp+S5gzXnIFe55jm3obE6e440RaVs
	z6+AQvBbWy90vszECopqsEoNUdGyhnkZ0qhT9cpwTkGOupmfXzTVbXHvaL67iC70Ie8SZ0s/pBg
	BwRYc2rQJvAUHP0FrRLE7Jbl8PKxiXWfiy98vMyNhD1i//XEgV8eHnnivOo+PKs3jgL/q8zvUOE
	HjjssdLsUSece5DnrtU1n4xVpD++
X-Received: by 2002:a05:600c:3d97:b0:475:da0c:38a8 with SMTP id
 5b1f17b1804b1-480425622f1mr695955e9.4.1768974679127; Tue, 20 Jan 2026
 21:51:19 -0800 (PST)
MIME-Version: 1.0
References: <20251102184434.2406-1-ankita@nvidia.com> <CACw3F51k=sFtXB1JE3HCcXP6EA0Tt4Yf44VUi3JLz0bgW-aArQ@mail.gmail.com>
 <SA1PR12MB71997E2E101E55CDE65EA6B3B08AA@SA1PR12MB7199.namprd12.prod.outlook.com>
 <CACw3F51qrBXnN370Btk7=bcKU7s44nmQYfN=EAfq25MondRUNA@mail.gmail.com>
In-Reply-To: <CACw3F51qrBXnN370Btk7=bcKU7s44nmQYfN=EAfq25MondRUNA@mail.gmail.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Tue, 20 Jan 2026 21:51:07 -0800
X-Gm-Features: AZwV_QgaTupq6DBMCeoCVM1hXfaRoAYoBx_XZxcQfdu6RhES7vwnX4BR3BC4bEE
Message-ID: <CACw3F53n1ieCfP7Dye96S1WPpein+x6wTVUhE4aVkRG=VppC-g@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct page
To: Ankit Agrawal <ankita@nvidia.com>
Cc: Aniket Agashe <aniketa@nvidia.com>, Vikram Sethi <vsethi@nvidia.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Matt Ochs <mochs@nvidia.com>, 
	Shameer Kolothum <skolothumtho@nvidia.com>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, 
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>, 
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"tony.luck@intel.com" <tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"rafael@kernel.org" <rafael@kernel.org>, "guohanjun@huawei.com" <guohanjun@huawei.com>, 
	"mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org" <lenb@kernel.org>, 
	"kevin.tian@intel.com" <kevin.tian@intel.com>, "alex@shazbot.org" <alex@shazbot.org>, Neo Jia <cjia@nvidia.com>, 
	Kirti Wankhede <kwankhede@nvidia.com>, "Tarun Gupta (SW-GPU)" <targupta@nvidia.com>, Zhi Wang <zhiw@nvidia.com>, 
	Dheeraj Nigam <dnigam@nvidia.com>, Krishnakant Jaju <kjaju@nvidia.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, 
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>, "ira.weiny@intel.com" <ira.weiny@intel.com>, 
	"Smita.KoralahalliChannabasappa@amd.com" <Smita.KoralahalliChannabasappa@amd.com>, 
	"u.kleine-koenig@baylibre.com" <u.kleine-koenig@baylibre.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, 
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 25B5DA0007
X-Rspamd-Server: rspam12
X-Stat-Signature: 49armej4jp551rumb8mskweuc3hyf53i
X-HE-Tag: 1768974680-912144
X-HE-Meta: U2FsdGVkX18FNyUPRzUSfcmVusGkQgWOAlLj+ux9nEmyyUMzaFJbreEWt+VSpHeal936gQjgpIfqRqoz45N2UtkPCoCHPsAgb5txUNBqSp3/rNLRUzDZM5YD6msnjXdTahQ8c0Ev9FbDzKy2K7GPGZlYso/Q7MwxNk75CseeIcxwTuLaMed7x/7DX/HiFQFDSe0mtCgYLPTe4o5WeJ+Pz1PZN3iR+0PeY0vf5ZNcVGP7OjFB/jb5svvL7ZXlGEB39mB431t8dJDsfGEdlMRH2pEbZHCQQIK821DhpuMOlxGiYfwmYR1Xg4ilBi7hcfQebiEuCRExzmedlaPg/6yp+kFk8859ZN8roX/JsnNyylcGHqY6R5q3DXwBmzcJzeIcxr388ZD/foUdi5X5qxvXgYCdwjObfRUum9N/jQDPeSF5lXg4bYmKkscRjTdXVs2qBrdGuB3rTO1bmLtTs9i3FcIolf5xA1kbc0Ze0tY7hMv4yH0479oBSa7tGqmpC9qlmSfxWaHR/jgyI8Dbkx5VEXmWQNeJzy6iN6OOCtXHhZZIbDOn0o4RS8cpeQDPvTG6FVXLq0MsWI/dHxf3n++j+g1aUEcENa5Ul3sWG+HTU9/Qj6lwS4RPOLhME8FP0MavoyvuBG+MbNL8tgoIjQKt9W8vvZgGTHmwPUVoSH32wRj8TvKPeWVR7KTG2bP0Hrt7y1phLG0mPxrp49IEeih3zfvBzkwE8Pt1oaeipxybWsFokjLlTZLckOMcXiIyHQHT5GK7mmuvTcpiWa/SJulOIxcU7e3+HCwVhDH3Q3bPT4+atoxVD1NSmUvVpPP76XYJwuvTdwdFfhmTeHFQxGFCMo9AWIrvkY20uflTTJh7c/uiyLYg/KEMUFfOEoGTSMsAGT8rBNzPJUm7MvKtjM/EhfPcV+/HMII5LaQWM0FO+MZIwsErhDOpx60JjLVbEWG/J4Fm6bUO2CNJqqQyrAo
 QPQT1C9e
 VsAa51PfYiEr9e2rxa61TT3fspynvN/h7cW0a3URCdCBO4AxWfo5b174YrAF+aigEtJNfT+51kOcQIIz1G8VPBL2HTWm5ps2sfa1VGjC2r0nAo1qzeHkYXvsw8s3boWbrrwnh/trKoyMitEMk65T9Hzfcs0xDa/iVzPWdjEwi/SYIKpcG9ClNk8XVOyZaaA07a30ePjyUjL6qlK/YZpUDC0xfW1BDLGzizEF8uGxwuMvpBF5n5T6ii80aZlePWNi6X2g49pUUCOD8x+2/P9lgk5y0+d3V11HcpH2YYgO/kYZX5PEJTG/W8Blfp+Ws6CEVCUNPWVUKxmrBgpNUhlkL/f1l71XUtnndHu+EdluUJilSqyDEzhoCnnqGYrriBPyBVxgRWfABHwDXByddCyjKkKG/iv+KGhN9jTbXmLaFo1mIOeRd5B5BzpEJtGo3XJlj0Zuc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 8:28=E2=80=AFAM Jiaqi Yan <jiaqiyan@google.com> wro=
te:
>
> On Fri, Jan 16, 2026 at 9:36=E2=80=AFPM Ankit Agrawal <ankita@nvidia.com>=
 wrote:
> >
> > >>
> > >> v2 -> v3
> > >> - Rebased to v6.17-rc7.
> > >> - Skipped the unmapping of PFNMAP during reception of poison. Sugges=
ted by
> > >> Jason Gunthorpe, Jiaqi Yan, Vikram Sethi (Thanks!)
> > >> - Updated the check to prevent multiple registration to the same PFN
> > >> range using interval_tree_iter_first. Thanks Shameer Kolothum for th=
e
> > >> suggestion.
> > >> - Removed the callback function in the nvgrace-gpu requiring trackin=
g of
> > >> poisoned PFN as it isn't required anymore.
> > >
> > > Hi Ankit,
> > >
> > >
> > > I get that for nvgrace-gpu driver, you removed pfn_address_space_ops
> > > because there is no need to unmap poisoned HBM page.
> > >
> > > What about the nvgrace-egm driver? Now that you removed the
> > > pfn_address_space_ops callback from pfn_address_space in [1], how can
> > > nvgrace-egm driver know the poisoned EGM pages at runtime?
> > >
> > > I expect the functionality to return retired pages should also includ=
e
> > > runtime poisoned pages, which are not in the list queried from
> > > egm-retired-pages-data-base during initialization. Or maybe my
> > > expection is wrong/obsolete?
> >
> > Hi Jiaqi, yes the EGM code will include consideration for runtime
> > poisoned pages as well. It will now instead make use of the
> > pfn_to_vma_pgoff callback merged through https://github.com/torvalds/li=
nux/commit/e6dbcb7c0e7b508d443a9aa6f77f63a2f83b1ae4
>
> Thank you! Sorry I wasn't following that thread closely and missed it.

Sorry, one more quesiton. I saw [3] implemented pfn_to_vma_pgoff
callback in nvgrace gpu driver. Is EGM driver's callback posted
somewhere?

[3] https://lore.kernel.org/all/20251211070603.338701-2-ankita@nvidia.com/T=
/#mcc9ccec90b1ca755ad9af0a821f5ce524fed0ffc


>
> >
> > > [1] https://lore.kernel.org/linux-mm/20230920140210.12663-2-ankita@nv=
idia.com
> > > [2] https://lore.kernel.org/kvm/20250904040828.319452-12-ankita@nvidi=
a.com
> >

