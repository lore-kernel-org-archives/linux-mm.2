Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86FE7C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78ADB6B00B5; Mon,  7 Sep 2026 12:53:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762246B00B6; Mon,  7 Sep 2026 12:53:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651076B00B7; Mon,  7 Sep 2026 12:53:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 342CF6B00B5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B37CA1C1155
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:58 +0000 (UTC)
X-FDA: 85187563356.15.2A389E0
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf11.hostedemail.com (Postfix) with ESMTP id D0F8840005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uDHxSLk7;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788800036;
	b=fLHsAg4WZsTUJfSjbUgCMoKXcZYEiG4+Bl/KfH/aReYthFIsZxoPXS+N2gaVj8FYhRiUzP
	etZTC8beRnB6KXve6zco+CpIkeAAkWg84PYvkec6/f6A8DBS1utyx0LZ2DebDQWmfincS1
	WPZ6ETxvopn0d5k4Clrf6vVYotXQapE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uDHxSLk7;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788800036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOgo3zFXzbtiQDjz57z5HXaLiQwAncd9HG4Gw1Bp/lg=;
	b=OX4bNJ9a0yZBOMK5knbRB1Y5H440VJz8PVrM0v3SitL+N1/ZVivd2nmqu81+ikj3eCEe6z
	0V49BGL+gQ0/kESDFqbw2PovCEsA7LCuaHEZ9+XxLmWNtHMkcZZj5xoeYxObCJo7wlo6+p
	JdOSPeaGDqqD3hJ97/rTPj0QtSMWHD0=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530411c7ee1so368511cf.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 09:53:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788800036; cv=none;
        d=google.com; s=arc-20260327;
        b=O/03aB+8Axz91B0ALKT2fzjzANXCehWr6QMLyjaYWQ4MIh2zyYXocN6X4vW80kolQJ
         N3anmhXUxXIoiDzJTPqXhhyEGSfw4y5YhRYiTMS/PV/69SzFiggc1IpNbfr1jUC3boTK
         WCzgFvCOt3Cpn6quaiUfaEWoLsidMa35DFRYdlnW54Nz+dJZP0eD+hE3ebwi896vM+YY
         kVHTFjglRMVRe52c5XGjq+IWrpWIzRsV2nTKwkhlc652dS0eCGuqbvsxaT9fa7JyM19V
         LYPQ73avM6uYYZ5E3vGPKe+dDIcASEdwWB9xI3FMK/feaWzN0W/ye3LighQ8KlYwf7Iu
         uVMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WOgo3zFXzbtiQDjz57z5HXaLiQwAncd9HG4Gw1Bp/lg=;
        fh=k74OSU8kuSTh+64UWd3+EkK+5F/BQtOGKKQimOnNab8=;
        b=ZB23HYnWAVzL9fWerx+jNgCi39B2uEiv+b0opd7BrfXwyuwAMeqh711s4V5CU8LObJ
         /VWb/5XAGxkeGp9QDz9v9QeqDSKhMAPa2T6Hg2WFf8DLhT5bLhFf3pfpD6xFMOwEUsyD
         ZbuObIpmsUtbbXozCV0GGmyisyH+OymgbZO8ciG2FT1G+l4Yi1zC43596C4A5KswHVaE
         Z3lkGobPoP6G9i5jNJdyRMmkhtsmfqPhF9GLlKGk8ZUHKwKPOLYUdoPBB2ozDer1TWGd
         meSFuHsGxuorGLgGYdZtAdBYj4RdDtbVl3rYRx6cY9gjIQXmXtplxXjdLj0Y4na/X70l
         heTA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788800036; x=1789404836; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WOgo3zFXzbtiQDjz57z5HXaLiQwAncd9HG4Gw1Bp/lg=;
        b=uDHxSLk7+02iV00pllHZplC5gp6R02ULejOcobFZZx3KFSNXe34+FLAFia4WNk1s9a
         UDbM5iEtEGq2RHQvKs7qEQ2VMNsmJCPefBy8Q6zaGXiLBJqs5iNcB4fVluelSB5lqxND
         ZV9d/ydZ5UD8N7m5quYTmVFuTxoLSclJBf29Ux8+IWUkH+ODy1PpC9SuWSeIDO0smDP0
         bmQqZUt2h1fS7mzUszmYHrZ0GPZq799ArYccR6ZuCnS2a6G+o0tSMfpwaSeKv/PQRFox
         5P6S9wb45Mx/qarDQXqeQMf+TfcOzkWq5LEjSEob9vigA6HYKg4Bq3FCbtO5jrQCsAUB
         ajXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788800036; x=1789404836;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WOgo3zFXzbtiQDjz57z5HXaLiQwAncd9HG4Gw1Bp/lg=;
        b=Hj8veZVeife4nX0dm/EKU3NfV8shKo4v2TtXkVACqwF3SDNx3f+FP8/x8phZLLUbUX
         hXTGIiMsbblJHsyl44OKdLK0pAqbnVr2ZzXesX1PppPK83Dmz7PsWJcJVfcSH5+zG7hZ
         JWMDkwt8PuG7tZwEm/u0tCZ9Ce0wHMuNiaeRzngOFmb8QUd0+YWiYcMoEKde4Z8+l9pw
         OX/sJ3BVzpPsB+LEp1nXbrJql/tZSUWdmmW2OYDtHh2+XORy2Cs64d2BpaGYzFHwFwoD
         gmYKtcreAkmNeCabWUzL2OPFiZ6MSOavXu1ajjK62kIi8r2Y+JWGZYy0t0vJvVZ6iSIL
         1kpg==
X-Forwarded-Encrypted: i=1; AKwUvBxyXUS2tX/jchDDrpbSckzfR2GFvs05awbbm+dCPrzDITMuQI8n42qGMmZVI0poDd8U5GwAoGA9zw==@kvack.org
X-Gm-Message-State: AFuF++lWU9BBTxOtQhXzzqW6WD79ovAPTLoLS+Essr17cngi5kgw59D/
	I50dhC4ZM6rqrOTCFjuhUa/j9D+eLG8hWs4PnOME1npBx9Up2Pc1q1jj3BmLWXcRXCZT13AgExL
	zlWzD9lDXAvfe9Ux50iXpQp0usGgno5T831hSCU0n
X-Gm-Gg: AYBFou15Xz5uB4GBo/4xC2/296oFiFFdav8vNGlDUz0jkfduckyyv74+6VobIci9e1O
	Om/xAEHnkwt8qO6PUhNmcJlyaI9m9VZD4j01QYXi1ex0qZvd7j5YrTQcTcgiF415vZYYh0j3I5O
	gRFDSA/BBfBkUJsRZtmerefC93OMyJRjRidHCOzSpfaVLG7GZdLDCxd+AMKg+bv3wLeqpjHW6TZ
	HF9SDmZkhFaXmwNPdHvqJ2vQHnxC+lM/yTv34cZMTY0S2NVzKAa1vABCYcdc6amxhQE2c/0bj8I
	URf2sP85o6cI5z1gSDinxvroMO4vH+8mPDW97Y2a0GU=
X-Received: by 2002:a05:622a:28e:b0:52f:8389:29e0 with SMTP id
 d75a77b69052e-530920caba6mr3560401cf.0.1788800035234; Mon, 07 Sep 2026
 09:53:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
 <20260901-rcu-pagetable-freeing-v1-12-5456a81c8212@kernel.org>
 <apbUpMDJglS99_yK@thinkstation> <apbfzUwBQyxe3P9R@gremlin>
 <apcH74QsR5I-DIbL@thinkstation> <apcJhtvnd45EkjJI@gremlin>
In-Reply-To: <apcJhtvnd45EkjJI@gremlin>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 7 Sep 2026 09:53:43 -0700
X-Gm-Features: AcwNN1WRGdFWOzxEbOcmfkztqDuQQAGpor7Xm60pdWlD2DjKNo1Y7S4S7DNXdgs
Message-ID: <CAJuCfpH_v4YU+hsQDU_yQ4HZDf-2C6DuiJU5PGL+uVAsTwkZug@mail.gmail.com>
Subject: Re: [PATCH 12/12] mm: change the contract for free_pgtables(), update docs
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, Jonas Bonn <jonas@southpole.se>, 
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, Stafford Horne <shorne@gmail.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>, 
	Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>, 
	Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	"David S. Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Magnus Lindholm <linmag7@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-snps-arc@lists.infradead.org, linux-arch@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-alpha@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, 
	Hugh Dickins <hughd@google.com>, Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D0F8840005
X-Stat-Signature: f98an7xzbkjq18fsiexo7wj74i1csskh
X-Rspam-User: 
X-HE-Tag: 1788800036-505663
X-HE-Meta: U2FsdGVkX1/zVMUiXXCHDJO2Y0nF8TCxyXX8AxPchPAnDeH2GX5nUWICqdILsbwvnZOHUkLk3XHN3f5V27akSyUoHwYxqH9zLKkxtnL/0E67eAF3QwrR8fz9kgrMi8rwCEF4tZDQA66sJxt9qgupxCuMmGfsXum5ZRlvb9SpywcpMOoa1HUws+qCYDM94xyEFdS8o7zalbMrcHEQKR/gwNKrRHdo3YZf+0KRLuRQ7GByhNWriHwDJQWo6pMTkrKgESyE4qP2AcoLfQoRocHcqoHAbnD98JPnjaTbjiYP/oS3mI/QIqVrDEd+GqaTLqkKrIuHWhCvNXXPZ66PpiAVIgcQe54UMev7o58wA6mroZ9x+9n8GU/WNuBBNhqRmqL7W+MTDSH44RJ9KzBvbMYbKScWKVnbButpn4TOMivZ3O8Q8kKSidhLNNEaIpZaKXXMTsDhhOtN1etJSqaMEu13IqyxFwrmxnhYSvbFHQ49L9UXHaLXcy8b/i8mSALbX5vBtIgj0vKfmjFRqeHerlGznBqJYPNwQGCn4fKWVu+tenOfJMxFViuZewcf6vbsH7MkOkCJHbrz+l3bYqs8z3VM87nrjz+EXw/oNdxHw9RpC3D5PvYc6tX+IHGXCMo0Q2JFDU2ddj13VybS8pMPdkpV34tKdbjPv1wZb2rMybKNZ0OSYpKyWO9npdTfsn1ubAKVDfN93mmVa2QGUXxUcJgvtv7GZnMhtLOKcFBkKCJEBdvnX74jOKi7LY6JKGMlUhVpoDwlkNh7u9b8Aoi2iyNo1tWihDlIQbtUomLcjE6/gIg8toZcW0KJoYDIsxT7+4cCqpb+swnOELCCeuNtiDiNLzZ97TRjW24ut/iKjhfZ3OLctO9VutIJfCra7dEqgcedz9lCebNJHPrPEnfG5AwnOzstg9bXhaGmv6xm1icesgUYZQHTsbPIGCzrRDfmv31fmSMrFKSbIXe3VWy782Y
 Lcchp8Dt
 zqcq3sLt8Rnx0QzM110I+uEkFoDfI1gG2a0bFYDWIt7UUpAU6lhRcIZUHpRAFA9IyiCgVWLcIFe8jcW7LVaoYsWmpNnLk3h2tEFjaByrq4VWAnrhsMiFzzuQmYKBRTRfZvOg/eFrDRjCb0Ns6DtTPLQSvmWPKKM7PfbeSgX/v0TK3nJVRljkjQK+AmsTNVsbW1Uap3vTlO/oQ26JOFyW4Eik5A1biJspFB2SsJXoknuIWymNW4GdWiHToXqHc39KqEMHDwP/D9wHdf726krlv5C6aIs4y+h8Qih4MVJvAe5Rikk7fU2qXDhiLXH1tEje8olC3/zLg2u1cU7J2mWgEY/ZkQ8T/nCRqvIVLH2YbL+bmOKcc4XOj51fPNYnqbc7xo55gOsCa8ixjMrO5E6i5D2Y+R2tIR4J2GgAu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 10:25=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Tue, Sep 01, 2026 at 06:15:17PM +0100, Kiryl Shutsemau wrote:
> > On Tue, Sep 01, 2026 at 03:31:26PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Tue, Sep 01, 2026 at 02:57:13PM +0100, Kiryl Shutsemau wrote:
> > > > On Tue, Sep 01, 2026 at 12:01:32PM +0100, Lorenzo Stoakes (ARM) wro=
te:
> > > > > diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> > > > > index b91b1a98029c..ff8ff3706485 100644
> > > > > --- a/mm/pgtable-generic.c
> > > > > +++ b/mm/pgtable-generic.c
> > > > > @@ -386,9 +386,21 @@ pte_t *pte_offset_map_rw_nolock(struct mm_st=
ruct *mm, pmd_t *pmd,
> > > > >   * be read-only/read-write protected.
> > > > >   *
> > > > >   * Note that free_pgtables(), used after unmapping detached vmas=
, or when
> > > > > - * exiting the whole mm, does not take page table lock before fr=
eeing a page
> > > > > - * table, and may not use RCU at all: "outsiders" like khugepage=
d should avoid
> > > > > - * pte_offset_map() and co once the vma is detached from mm or m=
m_users is zero.
> > > > > + * exiting the whole mm, does not take the page table lock befor=
e freeing a
> > > > > + * table.
> > > > > + *
> > > > > + * However, the PMD entry is cleared first, and the table freed =
only after
> > > > > + * an RCU grace period, so a walker that mapped the table under
> > > > > + * rcu_read_lock() stays safe, and the pmd_same() recheck in
> > > > > + * pte_offset_map_lock() detects the teardown.
> > > > > + *
> > > > > + * Therefore it is safe for "outsiders" like khugepaged to use
> > > > > + * pte_offset_map() and co. for VMAs that might be undergoing pa=
ge table
> > > > > + * teardown.
> > > >
> > > > Is it strictly true?
> > > >
> > > > free_pte_range() clears the pmd without taking the PTL, so the
> > > > pmd_same() recheck in pte_offset_map_lock() can pass and the pmd ge=
ts
> > > > cleared right after.
> > > >
> > > > Readers are fine -- __pte_offset_map() holds rcu_read_lock() until
> > > > pte_unmap(), so the table cannot go away.
> > > >
> > > > khugepaged is an odd example here. collapse_pte_mapped_thp() and
> > > > retract_page_tables() don't rely on this recheck -- they take pmd_l=
ock()
> > > > plus the ptl and do their own pmd_same() under both.
> > > >
> > > > Can we say walks are safe and leave the write rule where it is?
> > >
> > > Hmm yeah, ah page tables, what a rabbit hole of horror :)
> > >
> > > I guess this is effectively a reflection of the 'write lock on write,=
 RCU load
> > > on read' pattern in RCU itself generally.
> > >
> > > So, maybe something like:
> > >
> > >  * Note that free_pgtables(), used after unampping detached vmas, or =
when
> > >  * exiting the whoel mm, does not take a page table lock before freei=
ng a page
> > >  * table.
> > >  *
> > >  * As page table freeing itself is RCU-safe, page table readers can s=
afely run
> > >  * concurrently with page table teardown. However, writers cannot, as=
 without
> > >  * a lock nothing prevents concurrent teardown.
> > >  */
> > >
> > > Instead? What do you think?
> >
> > s/whoel/whole/
>
> Haha yup the inevitable typo...

Also s/unampping/unmapping please.
>
> >
> > Otherwise, LGTM.
>
> Thanks! :)
>
> >
> > --
> >   Kiryl Shutsemau / Kirill A. Shutemov
>
> --
> Cheers, Lorenzo

