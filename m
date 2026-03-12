Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE68106ACC9
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 16:12:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9EB6B0089; Thu, 12 Mar 2026 12:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283BE6B008A; Thu, 12 Mar 2026 12:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7A56B008C; Thu, 12 Mar 2026 12:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1D86B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:12:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C03CE1A02D0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:12:47 +0000 (UTC)
X-FDA: 84537904374.28.05F7D0D
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id C449E1C0015
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:12:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=ZuBCaR5g;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of r@hev.cc designates 74.125.224.42 as permitted sender) smtp.mailfrom=r@hev.cc;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773331965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtV4pVssyyOMA/08yV/BNeq7V/A7TdhzmOy4bj+LB2w=;
	b=fRVoNO9CCgaFERXc2MJYV0Knft58prxelcAb1vjMpRntthFnrCW7QOZ2hQtDUD8jC8fKb0
	HE1DGzb5rpMxp+PwPQZTEpyUUjlIX215YWPh6IuxFkOs5+q/kkvANaxBN+E8FhAWOINMEo
	ypq4RS4HEr5me9j71uP++/cyrVYMcPk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773331965; a=rsa-sha256;
	cv=pass;
	b=VzfpvtVz8vYDmkOOHIk413dRKsYgKWefEJVscYg60NCNRmpi6wIIKmbUkadpJYcMsUP70d
	MPdebttPSTfvQITHPuGaGwZXmLeXSYz+3spED1nuTOVdOo7fMWVRXxjMDhE8ifEG9rlFZh
	E7I+Bm6H7WUF66+go7V/jG3V/LgUw3k=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=ZuBCaR5g;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of r@hev.cc designates 74.125.224.42 as permitted sender) smtp.mailfrom=r@hev.cc;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-64ad8435f46so1471290d50.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:12:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773331965; cv=none;
        d=google.com; s=arc-20240605;
        b=cfn6KIe8QiMyHRJBFsa8h8ZZCT9rnzA6K5nFt19wKxUBLtdXizx2zXnF7nT3t7VNBJ
         Y9dhDpS4jLzBZTBmiiycXf43hP+jDlq1fkOGpySvwkEnz5qhI87r2DbsGZGv+kIBCVm3
         ZwHDLRIImbGFISkSfZFelSFcWhsoOKspb4wCWeBneX5PRazcoyQvfxvVGwFDWqeYZ894
         UBSfSLrU4FOx+q0i+0wZSiZMaNn8cy8p11JxV4cEJ7UhMmkCfUPzdAcOvoQNoqm3lgbd
         KE09v0o2/NfdbSSWGv7pRsa5/hNIjQ7DDVrNr2fpQjr726Lfs0tlwELLC0dBLKvoC+sw
         KBDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dtV4pVssyyOMA/08yV/BNeq7V/A7TdhzmOy4bj+LB2w=;
        fh=EkrDFultonUtYm/jCMpWTVfdMsbqY5g7vir3nyaURJw=;
        b=lN+i6rB5NsbUz5CYoNVQCyMNATxAzitxOT3FPhRO2+5OPS3QBul6bHekaNPwfN/Bl3
         vlTV+udnlx1+cyVNSWMbbpHBvBcMLR74io6/Ttw/Pk0NMGoPVZ+LtYf7NyEixDjeat5m
         lDLWOpMydr6V7/+HWuTwOs1dkf7TgT7EWJspNPCltkCDSiIWwe4pcehOFRu/sRMTe0bk
         bRXOkGhJFybXty9iCbUyEq5rrN2E3Jj0iR9Aw8+qYkGmKptDaN4epkHkY79EeU+e1ed8
         bDrdQG6tpz+ujeou0RiD9R2HSq4f+W8dn8xYELjYdIfWZEUuYadaEfGvz9+tORxrjo2c
         /Fkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773331965; x=1773936765; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtV4pVssyyOMA/08yV/BNeq7V/A7TdhzmOy4bj+LB2w=;
        b=ZuBCaR5gAZBcIqfSeE6gkyayzBtF8ZtroTD+mMIVYWidIPrnT8i+80fWgEX3PzmVhB
         zDR9STcLVM+sTq5Qr6pV68NC4bZbyZzl5J6xccdBa4BCTvxqwN5XkdTYe7crRw99s6ES
         uIkMLEn4pNn4fo3to7IxDyl3sLspypoAmQ5HCZveZsM6uyZAHyZwd/fsX2N9BB93kazo
         eg8k4iKzquVTc3SRUZ4gIZ68DO0WT+Z4ss4lz/ZhiV3PPapMEqSvEZ6eKaPWjUPFMaR2
         FgdYefTQk7DV5nZ9gVwTDD9O+WPlp2wMb/dXYja9VmYV9RTyvUK68FeiRIzBKenhCmGo
         OL8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773331965; x=1773936765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dtV4pVssyyOMA/08yV/BNeq7V/A7TdhzmOy4bj+LB2w=;
        b=vROIxCsLu7OFKhSLMUON+AYLRI6lX6Tjatc/k9SC3AiHYlmvMjNvQrpVWFHpTDXkgg
         u9yTOllFlR7HctRTmAJSi1wHZXjLqAiwzjkRsBc2cWtBwv8KJ7gWK+Jst3urLtsvjnne
         zSnbuRUtzWQKEWAxNUHtqwobR5WLHhSEdbViKl7T5JdTU2qyhlYu6mU3r8D5fAvPQTqW
         +bGiT/AagN5/nHZGIe9Xp+gSSanAyee87lWvEJuUW62EKbb1Uj0L+Rse6dEIENEvX/lV
         g6NdVE/wv8xjD8BhgWD6YUUPw91lg9TZDgj6YJCAFEpN9sPbwhz65kNWohLO+DpJny6I
         q8Ew==
X-Forwarded-Encrypted: i=1; AJvYcCUhoOeRE/6sjIkOsTDOpdk6W9Lt3PkUHssriVn/Jhs/Wmz3YI8OaGwDzHrgAvf+wHM4ydc0GXZx/Q==@kvack.org
X-Gm-Message-State: AOJu0YzCmEnWzbo3VPvmpCCefvcDTcIYuZTcRdKzHFgPlvUm8CXGpHIj
	lFYcuoTKJj4Le+eqoeEfZS26ATjHBTeb3egblrFrWpzRV9+wuRNP2X5H876OmpE8eX3GRlaYrk2
	aKaeUH9b8ql3FGQU7Zp9cOpe5pcuumcQJeAYTUIxZ8w==
X-Gm-Gg: ATEYQzw4O9FX41HKp7mjOOcOwl+WCvnZXjRfvbRQFjXQSnaL5OSuNXk3EWOHIxR7SNB
	p9diKYZR9lN/0rVLAphf+pW8KDb3IR598P1Um61GoDdEzfJ7FNL/D5Dq7Que9n3IdZPfKRq4yeW
	GicfT+hLI348i60EznNu9CyZYjJDutEQNQMLGkOMe+/YmifcNcls/jr1XJdNpUNr+vKEO9mYdlG
	aXaIBSzD4watyIaMIu3KkgykMn3TkxhObUdEuypMrwWMraqdFdoihfCy8DvO6u/wgxy9GWo3w2Z
	yaWMbZ5k8GvDWRskD/7vFNyw2KXqV8ubaYqwRQYiNQ==
X-Received: by 2002:a05:690e:23c4:b0:64a:fe95:2ba7 with SMTP id
 956f58d0204a3-64e62fa66bfmr100462d50.31.1773331964675; Thu, 12 Mar 2026
 09:12:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260310031138.509730-1-r@hev.cc> <20260310031138.509730-2-r@hev.cc>
 <bca4ea00-3052-425b-8f39-729d504fd4db@kernel.org> <7937d789-539f-47db-838f-c153ca6cfc50@kernel.org>
In-Reply-To: <7937d789-539f-47db-838f-c153ca6cfc50@kernel.org>
From: hev <r@hev.cc>
Date: Fri, 13 Mar 2026 00:12:32 +0800
X-Gm-Features: AaiRm51siSCEAkZ-ba-2YedtaHq7E4-85jHPxVQW2_x0EqyQuvL291b70026mMs
Message-ID: <CAHirt9gpZ98HQCXStEQMMfe6TEnSzmD04BM313h2LJGJ1K-hJw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] huge_mm: add stubs for THP-disabled configs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Dev Jain <dev.jain@arm.com>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C449E1C0015
X-Stat-Signature: mbm4gjhud6ne8aetm1ambwzfqki1wa85
X-Rspam-User: 
X-HE-Tag: 1773331965-860667
X-HE-Meta: U2FsdGVkX18uJ6YZG9k02Ekh9Pgw7GS6O85+Mn/yaZbaRU0OEi0jEuedr+w8QQPIvb2VD6NoFq6eXG2xlQIDgA4xxSiL3S4fN66WXGSfibj5aQtwvdRyLVAO2RDM+DS2tHtzsaBxZS/bfUdT4zP9IEBdsmNgmRVE1pdwGo3mPg1xWj/zqFb3N6VW5vRaOFL5O9RTAH4HdKKDTAFDK4sRToanQN5h4XksXeZH6TXYsiXmbgIEW6TXGdHNDm4y4TOjtn9upMKykfoLZ7Iaeyei23MWRacl5nyocJLqNFcyRYTDXa6SPzBE0mXwajW0ycLPlGlrL1LULa9Ah/HuIvysG2peTSlqXSUyxez2if2yCoprbZ4w4Y94s5XWOoqx6Oevemo6mB9jNwtPTd6a6gCEZCIiIKpuQLDqDazbVIa2wOREYLZomwJ3O+erNqiLFIUtShcRD7f5pkAaP3IhiOdIb+9v9mVhcAonPeVbmpXfYWvb/3MVaSxN+99rVEdV/DDkN2D69Ksa2wKQnUtnQ7kRdA8Nelueu5HB2WEsfRsqWJMQ0qXISpaN5eA4dncHaxBA2KuXXnxcuqnyOBVdDKodUoNCWQZ4SV9F7PzwRT7hvPfmbVDs4o6Fc1X8T/BC8tOZNPdARNntg50Ba+cStTBJCX2sMBagZTbEDQIByjKPHC5jAjqkqxFhugU+VnkCPguqOWnV01v7rJHnGKwNC5zJLA9POxdQRzKpdezRIUXagerWJ7nQRxkCbFXUwpAZNxQFminB7+FweDEMdMr9zJKl6BY+t0QIkNbUjyyNJsjfk4LHmeJxLYCqcGgXi+1Hsivgyr49m1B1r87cDuEsC9Pb7Dlu0BwB5oU+FJSoj5kUqmTFa9jd91Hi/LjR5utkImYgeN2cush1CzqfGtdsF4UT5aGde77GTeIPq4hwOimjBDIPGeKuLlsRHGHxUyLVZMBxJcH+5g0sC/bBJPDXaJD
 9Mg2kUCC
 VYO6jmLQpu4ZZBR7Ov7Z34/KaeQbRdzXcFZch6lKZH2H5EXox4jMZiX2Q5o/ijcHQQV1wItFMu8LbLRcobsgfPzszoyJLQxibLTZbu0rH1Awg9LUAgNcoDDMyQZaVihBGtL6iz7WkUHq3Z/GiBKcKx0La8zQRBfo8VMwe3Qse8ji8+Op6qfAp3q45yUonpl1FlAbRDx3036GOe1n/LVNN9qO1ZUWsnraYD0EuI5qdhJsuRF0ol/v4UaPL3d8EFXBZGkYaN+KRxDn6A2YI6UOrSCCXa8QFXGiF581rbVL+GeyvWYqdvxhkCIZZhKnGcALWKs3K9mMAbzxFP6hbXsDF5GObMmf47KB6SORHsS6JAJuvcxh6E+Nf9bEMguSRcZO5yGkA4sqKTCL4JwLt2TYGGcdAn26yJKsYYpey+FzMI5a0EYQDfMabOaFQCwGvWR9C2N2lnrR43OjV8V0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Thu, Mar 12, 2026 at 11:57=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 3/12/26 16:53, David Hildenbrand (Arm) wrote:
> > On 3/10/26 04:11, WANG Rui wrote:
> >> hugepage_global_enabled() and hugepage_global_always() only exist
> >> when CONFIG_TRANSPARENT_HUGEPAGE is set.  Add inline stubs that
> >> return false to let code compile when THP is disabled.
> >>
> >> Signed-off-by: WANG Rui <r@hev.cc>
> >> ---
> >>  include/linux/huge_mm.h | 10 ++++++++++
> >>  1 file changed, 10 insertions(+)
> >>
> >> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> >> index a4d9f964dfde..badeebd4ea98 100644
> >> --- a/include/linux/huge_mm.h
> >> +++ b/include/linux/huge_mm.h
> >> @@ -570,6 +570,16 @@ void map_anon_folio_pmd_nopf(struct folio *folio,=
 pmd_t *pmd,
> >>
> >>  #else /* CONFIG_TRANSPARENT_HUGEPAGE */
> >>
> >> +static inline bool hugepage_global_enabled(void)
> >> +{
> >> +    return false;
> >> +}
> >> +
> >> +static inline bool hugepage_global_always(void)
> >> +{
> >> +    return false;
> >> +}
> >> +
> >>  static inline bool folio_test_pmd_mappable(struct folio *folio)
> >>  {
> >>      return false;
> >
> > There are other ways to enable PMD THP. So I don't quite think this is
> > the right tool for the job.
>
> Ah, you care about file THPs ... gah.
>
> Why can't we simply do the alignment without considering the current
> setting?

The main motivation of raising the alignment here is to increase the
chance of getting PMD-sized THPs for executable mappings.

If THP is not in "always" mode, the kernel will not automatically
collapse file-backed mappings into THPs, so the increased alignment
would not actually improve THP usage.

In that case we would only be introducing additional padding in the
virtual address layout, which slightly reduces ASLR entropy without
providing a practical benefit.

That's why the current code limits this to the "always" mode.

Thanks,
Rui

