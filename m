Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B3C9606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uaLCeXAe
Received: by kanga.kvack.org (Postfix)
	id 6F05C6B0799; Tue, 24 Nov 2026 10:59:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678756B079B; Tue, 24 Nov 2026 10:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567636B079C; Tue, 24 Nov 2026 10:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6956B0799
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:59:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F941120BEA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:59:10 +0000 (UTC)
X-FDA: 85470471660.20.79C6DB9
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 080574000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:59:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uaLCeXAe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795535948;
	b=xKu1u26DDQ0RjuE8y7n5N6m6kBA0rJBEVYpiQehRE39sL7ACt9aAUegFarHkTScCdVHJ/E
	aEMTFIM3HRiADFmiYev1fTeUcJM5VLhmrC/wRXHTSo0XPcI8zprCeNiT8eN3nHN7+LSzNC
	e+lkJ7rqmZBsOWEbW4duPmSuv3SEl8E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795535948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/74Ri30W6oVFNU4eqK6RxVx2Up+VW7ByxGiC/VStVG4=;
	b=mFDbt7IMVEhWeeOEDfLpJ4cyJ39enA02kn/OACMexr522LO6LiZONNHcx68NazHXiPI3IX
	zMjJX7e9Qc2xXaBpOidsCeNVoov/0tA1gN7GG7lNn64yehfns/R5QLZYnVsmYEOcTmL0vJ
	Q/wSLLBM06PS6CKYYGX2TH1/VY55HWs=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=uaLCeXAe;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so37765975e9.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:59:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795535946; cv=none;
        d=google.com; s=arc-20260327;
        b=UWS3/BMfxBTS5D+w5H3qojXL6GekWY3V1DmYiVjXU8U2seNLnfyr4+Dn/AlMU1e2XQ
         QZ3xFqrjPUTv6XfNWTQVTosml3z8Oq7gvvT+6Ew13hI+jzusze5GebZ5wtjR7Ilrugk3
         biSF8R+RbbyIDpvx4Jt2Kq8u06mxTSWUommaNRrp3yrBCOhEAaLzDoNhhR3UGyRrnS2R
         azhRmomWXpgFTriWDL6GRBqzLiVgkh7mB/ZnjIyOwdt9MSR3JIU8H4L9PvJtB/Qtn1N0
         6BzVfRAWixTO0Bf3mDh7nRr2nC29TMFUO4hVkywViK06JUyIZWD/t2PQ3k8kWHika1su
         d+Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/74Ri30W6oVFNU4eqK6RxVx2Up+VW7ByxGiC/VStVG4=;
        fh=OA2F8qMwfzTgXs3gxhkLWWtrcRBDb6RGAZm++tvjRXM=;
        b=eo0E+HRuemB2xwYrQaG9V8s+iLUn1y3S7BUi9TM++WeBmcPnHYysvtg2d85AGenQu5
         rf86b/OD13+ok691WAXp+NfN/x9Mzv421tZxgV+/I9mPVg9aXfXti8P9FOPwNMqzoxDE
         Mjox/sEdrR/9umFQSEa0GGo835wfAAM6drxhVeVCJkiM5mzcHG0qqb5qooP/4Izdx20e
         v/ug1HYskyl7sGeRyrQWgOUtnGU3rkNCD1IXi8oFrFFhVk6TuRwbf7RJSkhKaVPSisNC
         pfFHKnDETnjQJfK5WGPN5Da8vuJL+KUNkECJeeBkyfRtrbABns/mvbrwIzHaR+YHQwVy
         pswQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795535946; x=1796140746; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/74Ri30W6oVFNU4eqK6RxVx2Up+VW7ByxGiC/VStVG4=;
        b=uaLCeXAet85rJRX4ia9ZBZfhC+U7RmnhZn8V3Y2aBo4UiWOh6Are3Wm903k92TIxWq
         V4zR/ZYjmpyi/ZNpikUm0s09lYqnsUYO+tNpLEM2Tt9SHBscqtHoloOvEPB59kYZFMZR
         Sl3wFTUo0G3TO+YuSQpngsbKZ+ghBHKGMAQTuLH4rMO6KltZFfxPZO1miGlU79k4Ox8H
         9NFRMP0P07RxxLYB/Bs846m1PFfnfFFBdRbL3eSMh/XUT3kxU63LjWLmCzt1RgORMW/J
         7MHlF1BXGdl992vXWGA+zv99VivxKe3qL92w3FumU/A3qgQDIC8Dn6K60MwyjHrDFIkj
         LFKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795535946; x=1796140746;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/74Ri30W6oVFNU4eqK6RxVx2Up+VW7ByxGiC/VStVG4=;
        b=lZjing60As2FISB/HxNZm1cBoS4wgdtPxzqsmcrQDrjOxSrfkjTcZ1awpQfgCutBIn
         H8RRHYU3A868Lo1OxxbI+r4h+AX8ABW4TGJqiot9Ye54V9jWS2sEqp5Lua4VOijaveaj
         HjWky+snRRDeATueKzUn9IQshHRXCocWa7+9tXLHiR6KJ7gxi1OUbK/tNeTFRk3OLnpM
         2x33pDYTeFGsxvfDYY+jOp0sn3G/ZZmDSLHAtQCN9x8vBovL+X7pdQ894dVb2kdCQKRx
         mI3uN52MRlEn9fx18wFE1QaNGloB+GBe6JtlhgFWIlREBnDMeDAFTavp3x86uTaVHSzc
         PKZA==
X-Forwarded-Encrypted: i=1; AL+hErHyEdiq8IyX6Zhrb7UqI1gHQY8kbACw7PMpbBoSzX2h9a8AbnUYU6KwQKntnWr+8HwIxas12elVPw==@kvack.org
X-Gm-Message-State: APuU4Z8340kqJtjNslnmBYzi+WqAfpWs+StpSKCMniLS1Wj+tZXtLFlm
	o0O0QWOxnKtLB1tHPExX4sGBeioIxaH4J4jx8bcWoiYOw9z/uzGE/sPB94bLILxufngO1IRUlve
	H1WuWSZJJ8jp78gFg6dF1A5Jf0GdLI1U=
X-Gm-Gg: AZFdTZd6i2YqJeuYI/9Pb+nhGoBmbZQIyOybhLG85Ygj+O5rt5BVlOfEbWsWrISEoRO
	NGUWZPJ4F/+tRELCwUa7h7eB/bTvcRopc6Jh189XY/6tikdxeXOzypZ3OFQoQesnFnyGMI3nbhn
	7DWhaJVhe7b8+FlS29etyal6ZR70IfgtC7j53u/OAYa9pgBKZ95BkcflpqyOBwKEyGE0rIcEqV2
	Q/p7faQIxcjC9Rh9oM0cawP2afbqyDM8I84fqASvlZ2vtUvIpdaZEbM66Tfkjgrbx3bWReHZpgW
	HNrb6y76YzXecqt3D7C/7z4r5YsEkbgoEJICgJQxzc/Nd1HsgBhkfSrhoc8KeuP2xmudUDlaU8T
	PWHtAyi4dt4TDCTxPxJSF14VDLFVnC7I6cAjiDrvGP1hjtmEHNuRHB04ubttbVErNxmiogIE7e9
	3/jkS6fuN2YyvMdFTJeuETH9+XI0e7BIezD/5EoRI9bapJkB1330z1
X-Received: by 2002:a05:600c:83c3:b0:4a1:7e77:c382 with SMTP id
 5b1f17b1804b1-4bb8880ad68mr297552635e9.5.1795535946309; Tue, 24 Nov 2026
 07:59:06 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261123030014.3116755-1-bsdhenrymartin@gmail.com> <lh4cnpy2kw3tdtmhubwhhvim25kxpqxo6xttt7sihyx7x5hqdf@3tvivew2qh7m>
In-Reply-To: <lh4cnpy2kw3tdtmhubwhhvim25kxpqxo6xttt7sihyx7x5hqdf@3tvivew2qh7m>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 24 Nov 2026 08:58:55 -0700
X-Gm-Features: Aa3M54pAoXL7yvOyF5JJv7RxaB2ypj1vzahwa9xON4kuYDyLqPQLjNR71spFULE
Message-ID: <CAKEwX=Py7W0vOwxKdWMCZu3d=BbF2OkgDt6Tu_AHhEJZ06w0ew@mail.gmail.com>
Subject: Re: [PATCH] mm: fix cachestat NULL pgdat dereference on DAX mappings
To: Jan Kara <jack@suse.cz>
Cc: Henry Martin <bsdhenrymartin@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 080574000A
X-Stat-Signature: mtw5i4t86y4x3s3e58i4h3a1bsbtt8r4
X-Rspam-User:
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795535947-827895
X-HE-Meta: U2FsdGVkX18CkLFA9w8gcCzig28QRSaEsou3xZHcMzL0rP6503yFcoYRxkd602cbOIJ3Q5/4kXUqpB1ty2ziDwd/FHdEmAY9s1nzMK8cUujp6HtPgHVYmrN+gVoEk49wXNE6YZEXXzx3HHP3cOFG5lIr8zDEPBNunBnX2UjUM14qX3pG7T3r+I4Ez2cF//KXNSFTnVGwLdmb09jjhSTfBYcXQBXCay6uqcGJXMKImaV42DeWNo3X2IXQ7gNlYped75jYO6sSMhjOlJ6AIK+goyeurHYCV6VG3/36sRMuF+PdhpisFuYbKCsnsOfk6yTxi672sa8kMcPn0X1lop1HfBRaPvxgIHfEAI5CWF6r2qX9Agy8J/9J7gGxnLFTOi4BeMpzzzjzDsBd5EsXRIjBcx3ZaNu1lsw6v9poSdEadkLtJZ5Wj8YlSq9l1agOrh7pZpM94i/8t4kaPGYI1YQ60oVdKeY712NvT0QIVyDAghIJYQnFE15+CjwIXxK9Kyua7yi+KHM0LGwOb8G4OgcGp5nyIjDIYN09kfFD64NLURdXrNQwJ1OWRAU9v9ay8f6O+KK+rwPecGEcIphMtnoeSW9xAQgrCVslqTg4yu9zU59dEgEzeFySvY2mph7HqPESnYOQ9fdgdcIbdmcQC4AHYOzmNibU/4RVRE3IuI37zP3x9xupxcfKy4klKV8V4IalzLUR5vHPJ52EAn/nw/VOXMoD2yw/4jcAHXV6QjvofTz3rKGsyWvWbWC69AtAQnxZmcCCKkGWrloWJbd3RhxlR52B5WYd7/z3cwFBeYyt5JVAjRNF0NzAwWO19RJ5IGtmNIBkm6bGZxmWBinm1DC6LfK0RPQVAYq3zSgj9otlZx9Y3s1fDz4uNX7IEh6zwYWl3pD+T1FnNjZsJCtfDw8xBXAX8o4Rg3iKL49Y3cNuzP55/dHsLN3a4L+gaaHGktQ30//BedBS+rnQ43UcRTd
 i7FMy7Zn
 B8AlwuihdaQ22mtwAnLxdPbAcDPk8Fa1FoHdN/kTvb45xxDFH4kUhG7742rt0N+0SF4bTSJSVNLXIuTSjP3mIIfUf4Wg0QVY3c1Xg9aA80S3iP9HyKm2eVXyvI+ikiPSUbyIna1SM5aaAMuPPmwG1V/iNRjes0mWOMCI0AzeyogPifXH3EhyIUpjkWq0w/Yzge6/Y4D2YUhFM2eiJ91HkpEgHvM+XPSwVN3YHn0BValaYTMlpJX9juit2qT+o6cIq0IEkpTzcf9sZYGu9JtI/ziZ6+s9/I4chBhQMkSrq2cEkokGwqMUSO8qvcmJFU0iduHgQ1Fn1QF3xNW0/cHLP8pun9ebLaO1AfbWONCNjxrAxrmJNShuPg9hVs9m1HU8F4gylY1Rli8SznKpViyZ1iD3plBvMeXPUsOYA7XJ+DahwXzFQTWg5vY/cu/HJjAScxyiLaDIH4BWeCVRT6yk2EKgy8vrHBeaK209x7wfQeJffGvk3/AqtRgKJWzCRpIp3TqT5Vh3Nwg4RREsRns3v1ciR9lsH3bZPjYNu4XmE5G14y5Q1qfBRtJTPbCo/JplhW1xlQsiRujGPFxmaW+UwONzmx6f4PEebdcqvezooMr87xV0EJHG1c5L+Ousu86dXBUupbmx1w/b3T4LThaxyTqHb4jwB5HEL5yAs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 5:42=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Mon 23-11-26 11:00:14, Henry Martin wrote:
> > filemap_cachestat() treats every xarray value entry as a workingset
> > shadow.  On DAX mappings, value entries are DAX exceptional entries:
> > same value bit, different bit layout (flags in the low bits, pfn
> > above).  Decoded as a shadow, a DAX entry yields a bogus node id;
> > NODE_DATA() for it can be NULL, and lru_gen_test_recent() then
> > dereferences it:
> >
> >   Oops: general protection fault
> >   RIP: 0010:lru_gen_test_recent+0xde/0x300
> >   Call Trace:
> >    workingset_test_recent
> >    filemap_cachestat
> >    __x64_sys_cachestat
> >
> > Any writable file on a DAX mount triggers this once an mmap write
> > fault has populated entries.
> >
> > DAX entries track present pages, not evicted folios.  Count them as
> > cached and skip the workingset decode, mirroring the dax_mapping()
> > split in the invalidation paths in mm/truncate.c.  PMD-order entries
> > are counted as one page, as value entries carry no order information.
> >
> > This issue was discovered by Tencent CodeBuddy Security.
> > Cc: stable@vger.kernel.org
> > Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> > Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
>
> I think that for DAX mappings, cachestat should just return all zeros
> because none of the fields really make sense there. There's simply no pag=
e
> cache for DAX mappings.
>
>                                                                 Honza

+1. This sounds good to me.

Henry, would you mind sending v2 along this line?

(and maybe add some documentation).

