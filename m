Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4AA4C982F0
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 18:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0484E6B0005; Fri, 16 Jan 2026 13:45:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0087F6B0088; Fri, 16 Jan 2026 13:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E61106B0089; Fri, 16 Jan 2026 13:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6E1D6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:45:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C2248A859
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:45:44 +0000 (UTC)
X-FDA: 84338705808.28.5FB9939
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 95CE0A0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:45:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="FaG/sGt1";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768589142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6bLqjwmicKmcvJcfCMzcrC4HuJd8fUxKurXeY12ItM=;
	b=pkjFWDchOou5xpfdm+LcTWDSxsR6if/2EYq2AAwj+SrJL3WxwTfLMEhGGTXaSXvl7b4T0E
	iVpzIkRTP6XlCQ1BquQWiW6eCKgB7PtsV9XFiHGrXeTha80nEHlK8C9Xrwg4FeVmr2WVe0
	tRXiIWuZB/dChIr7TjCRhdBDBrwi8FY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="FaG/sGt1";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768589142; a=rsa-sha256;
	cv=pass;
	b=F72hdor1WUzY1VCLFBBCT3SooD9yvDr2RjEf9m+L8iHToZeKQmbmsRhYVsOtO1dquiKzZr
	NARAr1GGQKyleO7iwkghJjj/MK3pc8ubLX45yfPPU/GVFIBao5ud3aYf18TqDhS9RaZj4G
	HTKWXsAYJiNg1bBziLm0jMp9EpSrZ6c=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-501511aa012so30671cf.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:45:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768589142; cv=none;
        d=google.com; s=arc-20240605;
        b=CHlc144Ct/JVHf+MMQFFHakEKLJz/gtVoAvJjnFlnn6REkJfxjVbVKNkzpbq8JeRti
         FPXACrz3U8p5vrPHivQLXL9Vs5cZU8Yk/r5rtyz9iJcOebjhRMC/09EK5bcCyQT+p1BF
         vIi9s4iYowPFth81llubBlGZ1RIxPcH401T/qz1XVsIPutH7tNBEHRWO5eygiCCElwtN
         M69yXwtj8WoYmKEedqYTqJhfNRUt4MX1TubR3NtuXAmHTyCrxcstpLQ5UQ21jGV9tOAy
         ayGMl77MedYDxpVGZ2E9eneZE4HpfYV30RQ0KWC9ktGBT0FqQV5ophu8kECWDEEISOCJ
         Xngg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N6bLqjwmicKmcvJcfCMzcrC4HuJd8fUxKurXeY12ItM=;
        fh=Y+C9dKJ5QavkoWniXi3F9I3MW6PLXat5wrAmO3vgmT0=;
        b=SsyVxOB2IfhMmBRvJbx0aMjRBnzwZBiWJPK+OatdSM6MtrA5BC/x1YliEgGYSITQiu
         eBNS7Lr0YapofVAuiJrfKKDGDbgZ6Ehh1vQvKAWZSO+eqiBshZzb8aRyCUT7OSOFe4d+
         7op2TcMxo/cwpLWx+fD3KPEoATpNU6QjJ1rXHKRe2BiIH0oEc0ZL76JpIGyBS0lu2L4P
         nE5cbIM7W75x7UcPW68kIiMTxmCyqIxblXz0+kV8tBQM6l1FpjcyFZcHUs5QLKn+frfo
         m4Hq7ASz3EMOfFeczIK98Y4xBnJCXpUfx9ILxWO7J3/iEJNGlWimh7QefUnqQDgeCVVY
         pUHQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768589142; x=1769193942; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6bLqjwmicKmcvJcfCMzcrC4HuJd8fUxKurXeY12ItM=;
        b=FaG/sGt1Pg95drRh/fA0vsJ40+scD4EHppjNaEDEoZ27JGfuOva4LAeNCyJsc1Fiqo
         oAH3d2HpNViY6elxHbkyrd1o7cf1OmiColCULWs+h6NwDqVuG/H25dVsWQr2rntXJeOD
         fFJCxM+cBY86KcDi2hXGVE0mk2lGaUA0t9X5Tn2GrmXlrP/ajEIY3//e17xYkpPr2CFq
         R0caNld9oH8sfqm650HiUS9s/qxhAtoXZ4/F2UV3qeM3cMSxxLzKPScp18ouFI9I+mRp
         5G8pZnTzm+oVaZVRoxjogy3NiYznBlItmXO6v3y/pLcOX/OA3OoSmfmnCPj3Ve8n5QgY
         ZqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768589142; x=1769193942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N6bLqjwmicKmcvJcfCMzcrC4HuJd8fUxKurXeY12ItM=;
        b=pUYT9F+L5o+jfgK+1eUT0kWFNMl/uUizwN8vWUiD4npqFQ6yqIQIRRL9qEoMHs5jzP
         8FTCb/Aw8POKSeCv96NVYBMI9K70aIJLWtcIeGHqgkPFN8D3ygLu5RLf2+HRvpPLm1kX
         RAy4mYiQWBYKwNRiXnRyzzMTWv/iS6h9qNY0OzpBmD5TgyggY6HOvEXboandD6Yn9jnp
         xiZsyMpKEOMu5q0cfDHO088hYfZgf+QYC/5n+VpJfKg+JxIrxeuKaJ3XEVaBT+GmSUav
         ykaEdIuNsuyhlYTX6ezSKsY/DCl8EhZG1EkcrPrrhX9FRW3hCYNnNPPud72y7KPUso1V
         d4ow==
X-Forwarded-Encrypted: i=1; AJvYcCWbICUZwWxCzgQvrFaHsIV3YtzZyquYJ6zNQPLFAEd9q9Fj0fS7LPdZgBfWMThzwTNL/4ZLyIVwlg==@kvack.org
X-Gm-Message-State: AOJu0YwtZ4vx5B6InP+8XVoR9J8I8mZIGmUHNfCsaGj2ht3DO/KBSDdR
	etFDBOO/C2UYMh/vX3VTyu0xsrCs92JCCHl5mpe+acAfQaLgFKpNIxhvPNFcA2Kt+8VYh+YpOwE
	GPJb66loHazmGZogM6OMKU9W6jTWYQ/iW8UzR8+/z
X-Gm-Gg: AY/fxX78rCbpQKhxjV46nXbWwC2sLg6W9/B2DeYWEU5TJ/jHO6CdBBSowiX7TeHctxK
	KUUTWBY8d8mmiEK9wWPUKZ3kMf1nq1Z50giqTJNtpRO1G7hdJBKGt7o/kg7Q2Joq+eF6OjKsiDf
	//u8iMZl36bCF2zlKaU5gZJyKXVTngvW1vK7qW2bwtaKUcgZoRgWqmpOOY2pniBz7a+Bfek+5to
	Uy9h3UcqGITHl9H50PZE2w7+h2ZPvT3rCe7N2+Uknf8pzLgW0jAlJtSF4ccTVu+AiLsOA==
X-Received: by 2002:ac8:5a08:0:b0:4ff:c0e7:be9c with SMTP id
 d75a77b69052e-502af8fc780mr566291cf.0.1768589139933; Fri, 16 Jan 2026
 10:45:39 -0800 (PST)
MIME-Version: 1.0
References: <CAJuCfpEQZMVCz0WUQ9SOP6TBKxaT3ajpHi24Aqdd73RCsmi8rg@mail.gmail.com>
 <20260116021835.71770-1-sj@kernel.org> <CAJuCfpFevUwXxwOrpH3+VOibjJw0rBw3=QL-nqeKreNEky7_Gg@mail.gmail.com>
In-Reply-To: <CAJuCfpFevUwXxwOrpH3+VOibjJw0rBw3=QL-nqeKreNEky7_Gg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 16 Jan 2026 10:45:28 -0800
X-Gm-Features: AZwV_QhozlK7uakvTFIi3gMT5z1ESm9uu7kKs6NCK1JEMKW6K3c69hS_mesSIW4
Message-ID: <CAJuCfpGS_Kw7O1tTWAVs_6dHMPjewh9NLSB2TNRTKXTcwbq0xw@mail.gmail.com>
Subject: Re: [PATCH 1/1] Docs/mm/allocation-profiling: describe sysctrl
 limitations in debug mode
To: SeongJae Park <sj@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	kent.overstreet@linux.dev, corbet@lwn.net, ranxiaokai627@163.com, 
	ran.xiaokai@zte.com.cn, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 8p667ayypsgipfwhwtufd1rmunsiiniw
X-Rspamd-Queue-Id: 95CE0A0005
X-Rspamd-Server: rspam04
X-HE-Tag: 1768589142-118165
X-HE-Meta: U2FsdGVkX18isJM5jDV0OO6KDJIpuaJkFMg2i5gUi8hR2UKOW35QfoGh3Ti1CfwNsQvhTvO7s2hRpcT3cUcdGMT6qhh1AbhSdEt3fcDSEnuhvZapQTsRQbNCHjcya0FFUUe9+mkb2/aHT9PmhKJVBqUvAPJnrRsjqUmvIWi8U59NAeQuSBIh9WXKt5Utqy2ZQ/HyolEXQkyEBbIGWLg3xkwbuZYMEqs+hJWyr5oFrzRxh/oGRMvGiFWLLnEO5NkWYFUDhT/mz2EFwYgLqAsw2gqFIU7I118NkQwSq7vF4rQwamep+Aj5b5y++jOCRolNvCxMVCGQiipyf1tw/WU4MdxlEsp5ylJLXArwUEECt2Y4+fiXQ5NY6OKzCWf83BzA6OhJ5LzhmHTBTM7Hlp8vpjGCCnsmMhfujH2Dbn2ekxR/elyi67I4cuXk1u3tEl8uaHprCGikDAJdT3LQSeljfT//ZoQo0tE2r/CX+oMxXR3ex63qn3xw3Ud43r9chUOqsPaQpEMhu/yRYCFNE5vaQu+xOovP3TWivvVp1t5gAoGEoGGHpHqipeDs43B7kD0N2CS4ucnXri/zFX2SB8SgAqwPpS+J1NDZDdiHPpOD3X73a00o37K5SUQT6owoENVMizpRjqwJEgxPyYJXfWEXUVGGBgE9mnFCu5HI/h6COtrXTKuOJIbPz+y6Lxjfcl12nxEH2D+uZbhI9VKwvtRij+P0R3rcwfrpm/RCfMm1LGyFJvEzjkiYdThXGfczfJv3FWNkFzg0iNUjVnqZvz1b/xAGbhmPUzHjjQmvLkTq5hghk7ygMRKGHWe1OR8kRPvDteyORXMVSypwMbwkyrvIhkWfI+9syWG03ZOk3xVmsh9QRcEV2FeKjkICn/mn6CIab03cjO7DXZBRmXjLsgG2rsBEkkFFCIr8AlE1ZSKfcAGOpVdFtJYnsMTz8/Pdzxvzd3mAF1qiBrQNSIGJOkF
 sPpD3yjj
 dNBrtzBLUsjcIS/p1jWQsVehHgtufpLdv2hcU8GAU9fs0+XDc3cIedqTE/8x7+hmNcEm1OFEVG4MKHZ6JcK1lgLGOIjZSoTkW6HRIQPfgh22LTcdID4qbSbN+rnoyGHBGWVlRESEua+PIwSgiijMCLwibTpHhaKaeFmE8bDr4H+vfSWf7Q/5bDjjN10sCGb2ulYZzF5c1uEA7iVGJ/49u0AFRrKJzm5BkG3YTmv3j1Ftt34GJ5As3X0M/grs2R+N4UTAqqQA3N/bP5EwImPvoO4Ji7IpQeTBfUb6AEDCaL5058huS86icf4OF2R3PglVWWu4GA4XxwH3BwYw42oJjBtMSWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 10:30=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Thu, Jan 15, 2026 at 6:18=E2=80=AFPM SeongJae Park <sj@kernel.org> wro=
te:
> >
> > On Thu, 15 Jan 2026 09:05:25 -0800 Suren Baghdasaryan <surenb@google.co=
m> wrote:
> >
> > > On Wed, Jan 14, 2026 at 9:57=E2=80=AFPM Matthew Wilcox <willy@infrade=
ad.org> wrote:
> > > >
> > > > On Wed, Jan 14, 2026 at 09:45:57PM -0800, Suren Baghdasaryan wrote:
> > > > > +  warnings produces by allocations made while profiling is disab=
led and freed
> > > >
> > > > "produced"
> > >
> > > Thanks! I'll wait for a day and if there are no other objections, I
> > > will post a fixed version.
> >
> > Assuming Matthiew's good finding will be fixed,
> >
> > Acked-by: SeongJae Park <sj@kernel.org>
>
> Thanks!
>
> >
> > Fwiw, the typo is also on the .../sysctl/vm.rst part.
>
> Correct, I'll fix in both places.

v2 is posted at
https://lore.kernel.org/all/20260116184423.2708363-1-surenb@google.com/

>
> > And from the finding, I
> > was wondering if it is better to put the description only one of two do=
cuments
> > rather than having the duplication, and further if the 'Usage:' part of
> > allocation-profiling.rst is better to be moved to
> > 'Documentation/admin-guide/mm/'.  But I ended up thinking those are too=
 trivial
> > and small things.
>
> Yes, I didn't want to complicate reader's life by adding a reference
> for a couple of sentences.
>
> >
> >
> > Thanks,
> > SJ

