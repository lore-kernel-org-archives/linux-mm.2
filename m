Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88DA7606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dlC55e67
Received: by kanga.kvack.org (Postfix)
	id 751EA6B05B1; Tue, 10 Nov 2026 16:50:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729D56B05B2; Tue, 10 Nov 2026 16:50:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63F726B05B3; Tue, 10 Nov 2026 16:50:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 362DE6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:50:44 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA2484013D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:50:43 +0000 (UTC)
X-FDA: 85420554366.24.AC9FD59
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1661A000E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:50:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dlC55e67;
	spf=pass (imf15.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794347441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3u20IW39Ayj138ZJ7povoBycZBaxSeSoBrzGBgSB34=;
	b=KRSQubhKdtKE7B4ROzBgyrC0r6tOYA35gzofcu1vY0TK6hc0WMP2j1cX1zBaORICJY9reM
	x8ncbDn0HQeRfaGnjdV7fItVVhJ8TBYASgfCyBQWAUX9u75vPAGzYVSyP8yDtf9sYi8Jpk
	JWDx8/qLFCPm8oO30hP+KjIuYAV74vo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794347441;
	b=5DiRxECXrEhJKJdorZUdYVzA2sfhIR9P/kY413nvAwm7yNac5995JYW6ELsWFXGYVdou3N
	ERN9h4axn2OZ3EW8AzTowkBpdeTGG3mAfexMf/K8Aqj3WbPfC7L7+NBoluLpvJqZcyTWo6
	VcXdi6A79GoS0jg6dt04RHbiPw5/kqU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dlC55e67;
	spf=pass (imf15.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso369978466b.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:50:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794347440; cv=none;
        d=google.com; s=arc-20260327;
        b=YW3f2E//KSj51Z/b9ekJp29wxwRI4qhDePB9WbgPjZk9u//PyuCbxLZtl3ULHeIjQZ
         ICko8DXb1QaBNwzs8EAfj5UlahlgUlh704SpwQO/jMkHwm3EzSttVWmm0e01W8a3C0Ed
         PIX9nZfjHOpJQ4RZLnobdPFr0z9BhOC0fH3DzrF/bqf1iAJAEHblCk8VYeNwvNEdws9g
         6QvMJ8pk8bRqx5VJC8RnkOOUDu20/QZeM35Hw+VuMDrCmtY4gaPpQOigUeTXBzZ4NjWg
         9jPHhX3aoIhYW1hGnRI/LnHzdn/n66gcOHB8s/KqCRfFRGie2Byy2VAqAoy8dI8LFUb+
         d5PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D3u20IW39Ayj138ZJ7povoBycZBaxSeSoBrzGBgSB34=;
        fh=ozuXoEePzvkJg/BroG6iwoqPJmgz/TBDtqIPJ6pe2fc=;
        b=oXXYSah/T4w42AvAmvzBWxCtLP/koaDREBQi6j3BkQnap+BPfVoTq7X1hieQClWhTf
         nU34CXhHrpZNGmgCugWuSUE5WRDyHg6krXXnLEC/Tzgu0bfXNTAtgYkXEL+nI1J4VOyG
         HKpCmNQxcrpD7r5Uz2PYRC1EUqndVu5xAe+fA/R5XUIiyU1EsiWRIADuwioCkEDp43WJ
         pGkA0sVT+glTO4GDhrUFrxmwGrDL3P0OvAhKZSDP6by3iHU+SrLVSJkaD/fv6mET7paO
         TwsIJQXTM7B+SQ80NBNubOpmTo79Xn++kFq8n5zMeESkC1x0G7iWPAeJYGSnBTslVgfG
         D/TQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794347440; x=1794952240; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D3u20IW39Ayj138ZJ7povoBycZBaxSeSoBrzGBgSB34=;
        b=dlC55e67Hn1rXNHSPTNqPbjFrnYLg/XHLkTeK0t7P8fXnM7hO/5N7lgjGJc4NKjw6V
         gJgGyfW3lF74b00qadVxViek43qkxwlTjXwrOdZiWcoiMRKe0KYTWrtacNckrFftmNkq
         D4bpIGnRdIpxJgVSt0ApKrui1K/TY4vAZSHfho7DZBf75QozZfIiV8C021rr2YVUA3iZ
         lonkuXM4jwPlNHg32b6Q4SdfItksAVioFYpeAfgD6Sq91nEY2WgAg1nl9o24SvG0aB5d
         jM1nVrGrXty00x/IQD0pHIpnExYBU85gjzcoKlSz/mAQumqiRcvo6kIog+xySv+poyvZ
         +QQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794347440; x=1794952240;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D3u20IW39Ayj138ZJ7povoBycZBaxSeSoBrzGBgSB34=;
        b=NN8XsAyJMk/HvhuR17YZosWFc1J2u8tmvla1P6efMSUc1m/9ZVA3nTm9ZqSm4zvDDM
         hR2BRuA1i6jBstEMUagu2ehzUb2LCMlhuKxJ1JD3fxYaem3oBm3ysftuYe2hFxEtd5UU
         18cNfPJL6LwmEQNVSnKgwuUicH0G5gc4x6KpvsM37znOIjEDlJHDUkNUkRmBHuuGn7td
         M2ZzVmmbMZjWQ7/S7z8rncCHx9nC8ipjyZZ58X1ABw2U+Mx97WTITErgtHBGc4VMpjah
         vT7IzfL5fcqZyOiUPvfN1oKeD7Q/VIhcCXLWGA+i8q4idLsI64TkgLoFL+J47vxZAr75
         wnKA==
X-Forwarded-Encrypted: i=1; AL+hErGnEHnnJJIXR/7qe8KhSMnrkPg3cPqHvGGVhl3KfBhRIEgAWlkwY4jm6XDbwc/zmejS2bE7C26C9w==@kvack.org
X-Gm-Message-State: APuU4Z9ZtGjomZGAGxDGesfR8SKWEwlMjqnEd8wF7gW7qmnZor/nkvpQ
	LWSKvugTNhGpXja8mEmRFaie2yzl7OGWbceK/73I1cr1lKSOWf9Sb9Bd+dTGgNxKsmboFv7+Xzi
	hTlHB0udy2d7WxrZ1YH49dP5B/0CErgI0Ac8c5/rt
X-Gm-Gg: AYBFou1FL9VGZ3e/WBMCOcABuO6Y4CFfZPLBQQ6W51FD9yMy/DItLtzpaJPNPHJzS9V
	mj2OdBA6CReQoVwPOqW15cMEHRMl8Be2m+TNsuj5wVqaA+p9znxlZFkjYbiuraWwzFueNIGleXb
	Bb9FB/jly4Vo8mBBfykFFnOvueap6PaN27ohnMpnWlt87JN2OUQVrHwRx1F0tUS2CswyRbYMH6k
	vHPqj+wmnwDn/RzVI2Maz4wLmgTkGtfETMtTT3jOoM1W3NrIx1umsmBzG4zfeSKtmQoUj50uOsV
	OLYmY4aoTbwLgqHEa0I6vg+rnLZJkUZPKlKQGvUWlKi0+qubkDh2onFFo0RHPmSPWCZ2TYrp4XO
	DuGGIFKPivYuX7RawR3qiMSIY8ehqgzACyaw10/1D1XrMrm90662UK8Iltwvx0mwHVPI/+fRglG
	A7ACW8i628yS+YV0pDUh5tbDg+XAzttv6eTPEvuUhf+GNjP8+N3Paha6iZwRuDjvb+d1D/BmE12
	eA6BE3mXm+Xakx6udNFQOZYZIrOng==
X-Received: by 2002:a17:907:a805:b0:c40:36ca:9d1b with SMTP id
 a640c23a62f3a-c5066d6ae19mr29991866b.40.1794347439526; Tue, 10 Nov 2026
 13:50:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-8-jthoughton@google.com> <2122761A-45AD-4AEC-AE88-B51E92E2CA40@linux.dev>
In-Reply-To: <2122761A-45AD-4AEC-AE88-B51E92E2CA40@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Tue, 10 Nov 2026 13:50:00 -0800
X-Gm-Features: AclHuK_v1agZ1dKpXc45zZ0c0gP5C_c2fyQg4NGg-Zs5GxvQBSCvkFuzEUTM21I
Message-ID: <CADrL8HWOPP6PLUVvL+v0-UA6YMG-o4p7dY6UmWif1aDCDgscoA@mail.gmail.com>
Subject: Re: [PATCH v2 07/20] hugetlb_vmemmap: Disable HVO sysctl if arch
 doesn't support HVO
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A1661A000E
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: c5eupaqxbrkpqqce1gnwq1a7uoyy4irq
X-Rspam-User: 
X-HE-Tag: 1794347441-400622
X-HE-Meta: U2FsdGVkX18jwkX+9DTaOKs9ArqSWqlorbesNHY0/gbqlWRXC3OLn/nUQNe66Yyr4M4oU01Od+B5hD6iu64xRvaNx/RAW71fjPggHz0JKT2UgrtE1QtZY3S8Y7bFeLeR9Jh4lr4RZoe2XYoE9nOMIgfoT56yPXN6NwndCsWk2ydOhvyf+lXOlnYVZQy66pRwMQFZ/azAqeLRQiD94wGfqFsP088+OKdXWsHSJOWSZSJs1+Fswl12+xDWIKr6dIlpWZaURqZKuNuodYP7qzmf7zNMWQXJZR+1YzlPVhysrwvSpO0eXVDek7vgLYbKpo8CE735pSrHKhI0i6SIKQ3gelurnz+5a+gEj2xfYlKMmAYm5w7gmGeDBgZy5cU86bur08Ow/8I6AIDHMqaM85XuPyRX7n6dTvnX+DG4xtUYyLpsXqr9y8xaSoffDU/ppdOAYJkBdgmr0AjHQiNgxlxmhs8+P+GPOMiDJoYIqbbbkC7w7CVd3oEs41EJBZMTia/N3RUxeOF9CqxGf0IuTt0bvmfTfglsKy10xe7RLahxMcfCpH/Z1hcfqcuyyhyRAuNlDkVdHUtaGWMNkJwlgiX/Azt7vc006MbQjefLeuCEBVVYjxHBUvkairAC2Hx6m5Y0zpcj70NTwGBRyeZDFIJyrxakIreKV4DZm2+0IvgRIrgu5vmmkIJe6QeAElQ+RlJ/Y6QBIwE7y4htjTsodCgFBTkj8oNVp/39RnNokW/3wDzhwWnfR6K3T9c3wmPdMRTtUnd2INejex4jqL5hXuDi5LbRYcvjdJUw5SPWQj/Sy7hPSZ5JtN+od3RY67jL8KvWo4NBlELboKvy6rilwSQhC8tNzPL9O9ko28zm8vh0pwHoMOyM17Ryp7+TqQ4ukEXNJgnN7B7xsL007tfZKStEcdpInPZYwx23xsNXcvWbfBUrRi0p98sAE0tYr3RBxS8QfvaUk6/rs1IA1rSigBY
 P2JRY0TP
 9Ir+l5/STZe6n8ihrop374HgMzc3adz5Vcotc9Dno8BMxjf/nPu68KXW7PUC1IT/5XHCWohAtpDTG0i2/PAu+Ngs1Z1XgkEhnPlxR0R9zNO7cUfqCPVx4pTyTq1ebkGwNclgj7jYzY0y6siHGMfXfrzWFzcHqUGk0eche5MtdXZ8iYH2LV310idwmVA38KnNY5sUt+dMtvx7XTE+5lCj8Xt8iQPzSoRoW/qsyGfAsVdSTE3TkN+Atr7nvc7vTVbhK/xBev7Em9QxSupdc3tvrM5eLwRwQeCVGv8zU/syJ+A0XzJbX6/aMYaoj1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 11:02=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> wrote:
> >
> > Do not create the vm.hugetlb_optimize_vmemmap sysctl when the
> > architecture lacks support. This serves only to avoid confusion for
> > users.
> >
> > arm64 support for HVO is conditional on certain hardware features being
> > enabled for all online CPUs. By the time hugetlb_vmemmap_init() runs,
> > all secondary CPUs will have started, and the system feature set will
> > have stabilized, including HVO-through-BBM, which
> > arch_hugetlb_vmemmap_optimization_supported() checks for.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > mm/hugetlb_vmemmap.c | 15 +++++++++++++++
> > 1 file changed, 15 insertions(+)
> >
> > diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> > index 8596a462fee6..817ce39d4cf3 100644
> > --- a/mm/hugetlb_vmemmap.c
> > +++ b/mm/hugetlb_vmemmap.c
> > @@ -763,6 +763,21 @@ static int __init hugetlb_vmemmap_init(void)
> >       /* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct page=
s */
> >       BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
> >
> > +     /*
> > +      * Architectures that need to probe CPU support for HVO have done
> > +      * such probing now. arch_hugetlb_vmemmap_optimization_supported(=
)
> > +      * will return the correct value.
> > +      */
> > +     if (!arch_hugetlb_vmemmap_optimization_supported()) {
>
> I'm wondering if we could put this architectural check into hugetlb_vmemm=
ap_optimizable(),
>
>
> > +             if (vmemmap_optimize_enabled)
> > +                     pr_info("vmemmap optimization not supported by ha=
rdware\n");
>
> then, we do not need those code. If the current kernel does not support H=
VO,
> then the sysctl does not exist. It's already a common case when the size =
of
> struct page is not power of two. If users really want to know whether HVO
> is enabled, they can check via this sysctl file. Therefore, we don't need=
 to
> print a log line.

Yeah, I can put arch_hugetlb_vmemmap_optimization_supported() into
hugetlb_vmemmap_optimizable(), that will make the diffs slightly
smaller. And yeah I can remove the print. I put it there mostly
because it can be confusing. A command line that gets you HVO on one
arm64 host might not give you HVO on another arm64 host, and the print
would give a user a clue as to why.

