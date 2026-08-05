Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE7FEC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAA06B0099; Wed,  5 Aug 2026 12:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA2D66B009B; Wed,  5 Aug 2026 12:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB376B009D; Wed,  5 Aug 2026 12:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6648A6B0099
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:28:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF47440525
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:28:20 +0000 (UTC)
X-FDA: 85067748360.03.60ADA26
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 888A880013
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:28:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NvrxsbnM;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785947298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqeWOooPdYuReROZcXfuR4VBX+niOCOlUsiSFJa44l4=;
	b=AGn0KV33PkWkOjx7ali/LoxLnd2/ZIBYztdrxTr4NJCvKhac1t2E+4OieAYj3mm7ipAKsg
	DjnNqyv2YHBeD1KL/E+Nw7QkhtU8vpvODQdkkqKkAnXtdqjrUgLOmOqFVtE7NdihnW8P1f
	OzEQpI0aIuFlBsYFc0q14yx7hfO2FLE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785947298;
	b=E7xkB+ZIr+mOmIMpvdSyf3/5NMTYAGyXX+rs8jxZCUEdG3vp+cx620D+aDDU9RVbB1MDT5
	SRbJzQsVAG+W8MpSAasJDvk/F2GzUb+rJGICp2oT8L3+qDnT1xsVC8AJNpdGw2++vDH/6q
	IDHgUUAvXvMqh/1S4oIRmagXEJTtxoc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NvrxsbnM;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785947298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UqeWOooPdYuReROZcXfuR4VBX+niOCOlUsiSFJa44l4=;
	b=NvrxsbnMEh8qQQ0obw2rcl5YvuR2PNJ9a1DBnz/8C/dh2MInnfoIaGYzpn4ObOdn8onpT2
	FDp2xNLHkWoh2CS4YdUUpAKSXTxZjfZrpgr+ua+POhZB3MC5X26QMPzde99pHTLw7fpfUs
	8AKpQ4xgK7D9HM8ZbmKScNvI7l3DBgU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-jy8NhOTJNKusrrgDFQFUiw-1; Wed, 05 Aug 2026 12:28:16 -0400
X-MC-Unique: jy8NhOTJNKusrrgDFQFUiw-1
X-Mimecast-MFC-AGG-ID: jy8NhOTJNKusrrgDFQFUiw_1785947295
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-39f27a480bfso4115041fa.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 09:28:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785947295; x=1786552095;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UqeWOooPdYuReROZcXfuR4VBX+niOCOlUsiSFJa44l4=;
        b=bccTWvipriPPrXVn20EA/Dt+sDNAWd0IZdS7+SLN9cwd+XIj/Gz8Po/wjJwlaMU4p3
         yn6oweEqaYv6BQ+F2/2PMS6DREQIh+ylNZSmOoxvsWnBLF1Pie75VpMggt8bUP77QgBI
         8BYlE7Md3k0ltxDicdn9T2K2ErS7J9aoM0F4e1quf8vN3FcZsREVwZXiakc8J2PsaGb6
         /H94Gd5O22ap44qKhJUmcqIGA+5MFXiaXU5rbW4p1QLg0YpaycdQnnaTdr1LggHzeu9O
         Ibu6uhrHsEkrbybMOMh84PwlJNwZzNeV8DdKZtfX/ye8KzvhaS8V0SeNF/NimrY4v6hJ
         A5oA==
X-Forwarded-Encrypted: i=1; AHgh+Ronx0qxf/4ey4exJFXnCbrJSbyOFF/qrQzIrU/j9TkVQPLSXq7f/h1c5Eau973uBz7b4JZ+LSRGwg==@kvack.org
X-Gm-Message-State: AOJu0YzSrGFW463DtWRrfq90YsUIYegGMDuOOAu9qQ8D3MBBeuIYykt8
	+ns9zQL8fOz10xDTEmIBBszR4jL2HejsoKGBHdhdtt3vahvIT9TJ5PH/KtcLDYknnWyncqHwARK
	1wn5rhF/a8uXKsUgQeVx6D9ggA8hPhwV50Llrl5ip6/TM9gZzw5K23Tk299LEWCcr1Z0VI6L0/Y
	HoFPkKQb7VbSuehV25Yy0CzsHB+f0=
X-Gm-Gg: AR+sD10AtP+q5AuvdVvWxmp02ZRGfOuG1YLFHbQjA9ANMerOPO5LOIVVHehwPHBEEGJ
	zKqCw7szZAv0b/8XKNzsOk9CNFo+v0aihJbwAwAzmljRmzmhEk2uNB8hReu5B4cPIqZRzavtEad
	VVAzUsSWC1buTmm3nMtWZTfoLZXGtWOWF6oJcUUuwybsTka87PpiAOk3MhHQ==
X-Received: by 2002:a05:651c:b2a:b0:39b:3e32:4a58 with SMTP id 38308e7fff4ca-39fbb028adcmr10862941fa.10.1785947295187;
        Wed, 05 Aug 2026 09:28:15 -0700 (PDT)
X-Received: by 2002:a05:651c:b2a:b0:39b:3e32:4a58 with SMTP id
 38308e7fff4ca-39fbb028adcmr10862651fa.10.1785947294756; Wed, 05 Aug 2026
 09:28:14 -0700 (PDT)
MIME-Version: 1.0
References: <18102ABA-0D8E-4DA0-AC30-544E34E445D5@nvidia.com>
 <20260609172719.803537-1-usama.arif@linux.dev> <CAA1CXcA84BtQZxOpE0sWgb2ed6y3m0NLKkWD+5MfWS9eF5dqTQ@mail.gmail.com>
 <a464c20c-8b41-4264-b560-497ed91cbaaa@kernel.org> <CAA1CXcCsqkV2PrLicY5BnOMp+iJWJxsPn60g_3WXugWQqOFYpg@mail.gmail.com>
 <0b268070-95d2-45bd-aea3-56cefe01dc8c@kernel.org> <CAA1CXcCp0z0kw9pQtj55qNGOBJOpfDsrf1GJ+EhGZCfA+dhbKQ@mail.gmail.com>
 <004bdc87-8c8e-44f8-93c3-1ae0a47051a9@kernel.org>
In-Reply-To: <004bdc87-8c8e-44f8-93c3-1ae0a47051a9@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 5 Aug 2026 10:27:47 -0600
X-Gm-Features: AUfX_mwtMbUBmdEv3K1TYdqdC2fEraUik6X1jX4ZwPK0WFwbP4jLsLSd_ixYUuw
Message-ID: <CAA1CXcA50Lfeo+JkhhRc5b8TNzBETj8+z6iMVuqwUSJhyo2G8w@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, Zi Yan <ziy@nvidia.com>, ljs@kernel.org, 
	xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, yuzhao@google.com, aarcange@redhat.com, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: z2-kMfe947-boTIemjnTL1sJThVYlrvMdN69-YgzpLo_1785947295
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 888A880013
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: a4hdwkudnd5mjwje7zr8k16q4esih5ko
X-HE-Tag: 1785947298-809031
X-HE-Meta: U2FsdGVkX18CSytqiPsNGRSI1vM/HGui95t80Oln1DYv9TXuXsdWvfiswQ5oTzTod9nnUZZqewlowJ6PBulRGuzGZdVBSilgKipMyQMH5WWvsOuMLjUA/kXlsp0hnZ4xpUCpHmuqPh2cIYLoTJp0iMzZTF/8sOh+86+D5o+y+u5Fq/Lfa/uUJdq9Qq+Ji1VbO5I7IVi0ZBsFH6U4ne1GCtmn8jq1KSp5ZP9JBUhSRNkYry+I0RRtseTKvEt7KkIwhPgLNmWGo8zrNOh+1I7GuZ9JcMJYiDyMaQe0rbSnLt9u4TVR2psswY2CiWckj7DBfpT71RKrkKlPZJYJQQUMOQU2fbnq7EXDohw4E1Xa0UJTddsuVM0YVgR7UxaAZ/qB1PUQg2lf1FKq2VxPt2azzDUx4XT5vTE7t1fQzE4eHluo7+80Hjw2l0fZs/BVPxtRE4cEsqV++m+W/HIHFQTm4hhEmnnz1yx92YzbA7E2u5hBfaq9avulhjH1XFcMybUJ3qjj1oscY5iQRrDnHJ+/3uXLvQsq+11I+eEPFd1noWlJOuNdl5N65CMFtpiIGyULfC4n0P/Z+euW6YQ8AEJzKhMCB0AqZXfFiLQ75B+huiofMFTufEBxbDxCmrF09SFk0EFtY2GaQJ7RTNmgLusatw9ZZUFWm/KkLgdcCGG5aSbMXe+A1qENKmr5aE1GVunnKlYVDFs4SlMyiviSU41OeaEtZzOmKalWYob5b7ltufeLpXoA0cqZWkwIIMsu+PCMDvx2bgvF6SD8yoZDri3LSc/43esr+bwUi9sg/AYfeIfNYd7yeU6+53HsTgvY7BH3QsuJaeQeY8jlvkRE0q57rTV/7o36D4OM5E30JS/6HCCGs20InQfmmNEp8J405egArmY2/zycwbWTn8NEK9/sXBAq5eSpvUhocX5udiMHtntLSLaVidmkSLEc3QY3aH/S5reWduG22smreFp53Uh
 eiCNXPke
 8W+DjRmb/HQha46bx1ep4FwGVtX1yposyOnAiIvBT6pCHJ4Uefk+xFG/s5Jk4KK5gjIQqODGPETSttiIat1YpX2pRc8OE1F7n9PkyguVMsUfEv8ogoOmzPbCuSkHYikn35GK6OMZjCBd3gm8u/ROMtxj13+Dfp+LnXOMwqRZi61Ur4zk5ZDUfFnnr7TcMQCGc+NJcIclFaMlUdRzwgW8rNfuHQm2LTWVtlSPJxOnPVuzWMvczmKcCUuIVJ2AuFEyCQdcGknNk5qWfhkB177YbWR7M1+oEYpJuhSNS/V5A6/CqsTrfmktKd8Tz/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 2:34=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/29/26 18:54, Nico Pache wrote:
> > On Tue, Jul 21, 2026 at 8:02=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 7/20/26 17:28, Nico Pache wrote:
> >>> On Wed, Jul 15, 2026 at 3:30=E2=80=AFAM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> this series (v1) would be "dont scan VM_MERGEABLE entries when KSM is=
 running"
> >>>
> >>> It stops all VM_MEREABLE entries from being candidates, while the V2 =
I
> >>> would like to propose goes back to my RFC's alternative solution
> >>> a ) "skip zeropage remapping if the split comes from KSM"
> >>>
> >>> I think (a) is better than V1 as it doesnt indiscriminately target al=
l
> >>> VM_MERGEABLE mapping but rather those that are triggering the issue
> >>> (the split).
> >>
> >> Not sure. There could be anything else in the system triggering the sp=
lit before
> >> KSM comes around.
> >>
> >> So v1 just cleanly separates them, independent who triggers the split.
> >
> > Yes but now all VM_MERGEABLEs lose the underutilized shrinker
> > independent from weather KSM was the one who triggered it.
>
> Because KSM takes care of it?

KSM only takes care of it in the case of 'use_zero_pages' being set.
If we stop KSM splits from reclaiming, we regain the intended sysctl
behavior; otherwise, KSM splits and reclaims indiscriminately. The
secondary effect is that if we don't have this toggle set, the split
would still reclaim these pages. KSM then has to process those pages
(despite them already being freed), wasting cycles.

Your proposed solution works too, I just think its a more aggressive
approach (stop all VM_MERGEABLEs from split-reclaiming, not just those
that are currently being operated on by KSM).

-- Nico

>
> What am I missing?
>
> --
> Cheers,
>
> David
>


