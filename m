Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23D6E606F203
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NJepjJ7A
Received: by kanga.kvack.org (Postfix)
	id 409046B05B6; Mon,  2 Nov 2026 12:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E1CF6B05B7; Mon,  2 Nov 2026 12:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CFC76B05B8; Mon,  2 Nov 2026 12:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09AE46B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:33:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B4611401F3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:33:09 +0000 (UTC)
X-FDA: 85390874898.28.97CCFE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6E40F40003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:33:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJepjJ7A;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793640787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epdlsZktym6bgZ7kYPnBVEf6UOlrLLIvoDDyPEFmjN0=;
	b=TVjsfoaSf19G2M86/zC+iwCPW9VcSh4VlOHM6dec05mJ9TsZZSVdsmSpcBR5yGq3lRGctg
	uroYe+9clejFX+OTjcPo5MD8txAifEuKcPpm6X4IPeQhMCtbRNd/kL6NKf1pDg6eex+Ry6
	C996Clo969cpWYaQyHuHnSBF8lcBV9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793640787;
	b=vEK0sTCnw2/1/8ABmGZtQAlwHtpiQL2mqXfJvqSldUj6JULeZ6CRHKxjAv+fpebf3x8hx7
	rMaVhfEJ/8VgYZZVWcHXh3BbHyhPKJ0lyQp0XTTovz+iBBTANfVX55sBcR4xLAkhscEEe8
	qbS/27Nm3oID8zKQt5Juru49AG+XrHU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NJepjJ7A;
	spf=pass (imf27.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 52283439DD;
	Mon,  2 Nov 2026 17:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456581F00A25;
	Mon,  2 Nov 2026 17:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793640785;
	bh=epdlsZktym6bgZ7kYPnBVEf6UOlrLLIvoDDyPEFmjN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NJepjJ7Aptb9aNpo1t57arEDaKYEjm1ZwYvb9ARC/DXddgD04PrPAt0kt+8ThNvJ6
	 XZjAZ36fJIdOmTSiLq7Wzm0DaMfkDb+pojLHWkpwpE1FiARcLS61JqyxA3dj7770cQ
	 uiII5NCnNAVbEjQQX/JEoK40cu8b0p//ocu10bQL6ZlhgiDYgZpe3YoV/0vTa2BRVn
	 7jRg8s5m03qeTvxeM/SFQPfriWXknxUlx8DaB0U2KDlDy9Bp7o0UkjnytZzPLLVfKw
	 PdLtyt0PQ0gkArIvaToLYew4lSgyafyEc34MGrj4Tq+cq+gOzdkcrdELpDWLdhUGyu
	 StYifvGnC85hQ==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id 4F7931980058;
	Mon,  2 Nov 2026 12:32:59 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Mon, 02 Nov 2026 12:33:02 -0500
X-ME-Sender: <xms:SsnoaqzB3Su62LyHncMQ0lnCfOg8771QTcA-bgDligf_JW_6rQ72cg>
    <xme:Ssnoat8UnY5i56wTk40g9Vyb74-qaw0sNLMfqdOt3mZlcBLGgMZ031ExjxSIUNbFw
    Vh6mUyv2-oUIDV1MC28KZB3nkH71VO4SXoPVgFiTHlt9MHkZQoTbfLl>
X-ME-Received: <xmr:SsnoauhM5NvIIuqFqqMUlc-89g-bt8XgxUHViYb1YTDQ0jQ3aG2XUt8nYsU>
X-ME-Proxy-Cause: dmFkZTE6fQTv86jMCHXBGciyhn4W+FrbKyLnJx8PbAtZy4PALRsriBTpj/HnQ40J9WaHHk
    Lr2ReFUWNCH5qJLtK2pZUlhwL9yi4sDB4RY1skbJwzjGD8KPbz+HSRvy4vR2qhHnSAcVnw
    endG2YbK23eETUVyqnhbIW0+UTWGaylBbPufprYXoX8qsUDgIwGPBIlgCjEb6bZbBBUP8h
    uIM+PgtyB6djpGMZVRt4NxbvBc/JYsj6evJ2PVFkJ9UN6cq872K7MMfkVkbdidVVzQUwgj
    BGQRqoUsQjuObq2TudnVUJfoXtD+SGg85RuKmhlYArUQwe3x24r0lvahP8r+xdH94fqre+
    CJPu3DW88+cK89yUBDmN8B4qMiGGdySMrWiz/+2mXUnDBOs8llcJ+dt95Db4/KxrwxHsXk
    jKv2dDABu9Prc4ClyM6Golsjmhay247FDMa7gP4dHhymxM5x8Vten7hnVAnjP/2GsTHpes
    NeTy7aRgSePvKBQRPhL60ChMd/+AHJl91X5QpFfXRueDGj4EkQXfdQ6OLeeSJLb+n8f7tf
    4jZDl7ijMUN+MgKCOPyvLIrehdQeLeSclNAM3wwfVLZj8bP0ntZQ3x2yqWHz4oxYgufeSy
    EQ8qW4hEYD3pPUizyUE5ElDXLFnodUec9/C2FFPSQt2BiUxf8teGmLuLTC5Q
X-ME-Proxy: <xmx:SsnoavOz1ps7CWvLYlT_c1potug5wjX5N-zzahU33RGnCp_XhxT22A>
    <xmx:SsnoavlZugqpGK0REVgdq0fDzlQPyBgwBSebIoqifiUY2E9aCc7dow>
    <xmx:SsnoamW6kRMms_IOEXyT5V9JjnIYC-4-Uda4L2gmVlHZWkF1GdwEpg>
    <xmx:Ssnoasb17vt5X0o0YBAOOgCssTblV6Jrc19EH7Qb51A6R7WHwIZldQ>
    <xmx:Ssnoal2G2Q_WUba20ZfiWDMwFltUFxWKpGnqvATrUApasIEJMzZ8NkQ7>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 12:32:58 -0500 (EST)
Date: Mon, 2 Nov 2026 17:32:56 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>, 
	"luto@kernel.org" <luto@kernel.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"andrew+kernel@donnellan.id.au" <andrew+kernel@donnellan.id.au>, "rppt@kernel.org" <rppt@kernel.org>, 
	"pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>, "kernel-team@meta.com" <kernel-team@meta.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"peterx@redhat.com" <peterx@redhat.com>, "tj@kernel.org" <tj@kernel.org>, 
	"azpijr@gmail.com" <azpijr@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, 
	"tglx@kernel.org" <tglx@kernel.org>, "rmclure@linux.ibm.com" <rmclure@linux.ibm.com>, 
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86/mm: Define the zapped-entry checks only with
 CONFIG_DEBUG_VM
Message-ID: <aujIo3W5yVZdZaf7@thinkstation>
References: <20261102144001.342837-1-kas@kernel.org>
 <f20b6d4f4e9368885e187e208453f21a9b0a2140.camel@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f20b6d4f4e9368885e187e208453f21a9b0a2140.camel@intel.com>
X-Stat-Signature: w96ww7j83ihsppk43bztw4wkjfer4477
X-Rspamd-Queue-Id: 6E40F40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793640787-367574
X-HE-Meta: U2FsdGVkX1/dBPyToUTs9QFX4vHWQO9iEwJ6EMwINOGdLWdi94K/C4ej7hGcS5v0dK1JWYVShCa1rBnWKqGe9UV2aFXlWJ1r5/OG88NUjRw2nqANaT6w4YTB78oMeZBebkkWhfvkvGTFs6dicY19wXFIy4MNNoL/2ZVg0hLvPw0y1GjNN7wBhzdJUS8M/U09dE8OsmAL8ha2yaYBSyF96h1SCtWtEO8yI/JlBo4pBTOfaeS2e6N04w1vtl/RFkfH1OAT8WTcYwWQqCYxsS3ZT+KyUeZoTYjjFVt8mDJN/HGroRKEfTM3XP3k20XwwjuDU/J0oIqz4AhGbwmpIKQreyrwKCPFj4L7FjtrNhy/HzIVj/CHKa5aTFm2KqxEVBgxYWfWfiJMQ9Zsl+ElSsB1Ftfqj0T3sq8gjemDKS6JoTqx9cIQf793ys3rZ+TmVAUJCaKWh+8UHZG2dNy3nGSscx7NLu1pvoYC45gT5scl/WUUHZQw0Ydt3GkruqdTo9IIHGOj0l9pcUMttBU1Cl/rt5F70DxT8UTSF8MZgWDiRr2hkF6X8IuOFrcCubWMyA2Ux5eh82Df+V7lOX2dLeGYxQGL3WTb8gzL01jdYs53dcIJ/DgIg4tnDeIHdZMlDEIfE4M7DJnZkBCnt/OCvwd8Ss++k0gRxSmZlQEtCA/PM+xcj+60Ap1mpcvNVIheBMw8Vufgvz3FGYXK2CvVaakWgymKA5MwGHgAUrExsTOTOh3IU1e0VCWqWDdcIwlMMyUVPfUR5yZQtrlvrnZRwzpJHwzMkBquOYaOkU8yQgEc9tQD8lWKN9wngjaj+IEvZpPsx4KDUSz2s5IIEKqRubtxLmkFStS610VfluFF1KxaYrAwgipqG6Cfo+IQ587bb3CmX89acvr/X2LlY19x9uDnjdI9bVKW0H6J7cu2+I6RX9yZ3tUYvkZfVuv+/yyNK+auzZvrc6t/U70V4bHYCjV
 km8rqFAa
 XQH2q5dQrJO2MVCL3FQUpSRmFDiP1aDwKMYoZJIgBECHCWTjusg12aFzJkIfpQLmVHBW5S1Ixo/s0gFQwjiTDKt7z2KVNDpqO1vvbud8Kh9ySQCcsZKMXWaaIFKuQ40iFjdN/iAwS4co90RAjyMjLO2H+aLuiUuK2hMx79txDSBOGVI/8PA0a2HaYfioqLYsBiuAUw0qQFZxQukH/hJ1WDK6rDRZeBxSIW9Jrgtidu50bfJjUAnQzMXgj7QEMP3e5y5KxwStsnlm6luNhLOxiiilxp4kef0DA9ZWOiHucDev8hIBefZthc4nuG5aNi8KEGgnQsE0WG3DNSTTEd/IHueeE1RmyRQTDemYDlGCDwui260VLFCulWfFEqX+vDCzHoDHQl6tcHbjcI3xbQEkg20bqhX9z/l9p1bwqMXJdGyRwUvhHSstKuK4zo2J0+zvoPQnSFs37d83c066+bs6dPOOrTUWG5/aUtF7ax6BjSTMqSAX1j238q4PbgYTaTIo521oi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 04:53:17PM +0000, Edgecombe, Rick P wrote:
> Do you happen to know if this performance impact is relevant at all in the non
> Safe RET case?

Yes, both sides of the comparison are the same kernel with Safe RET on,
with and without the patch.

Without Safe RET (spec_rstack_overflow=off, same two kernels) the call
and return predict fine: branch misses are the same with and without the
patch, and the gain is under 2%, within noise.

> > diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> > index 4a105f283cfb..3352bc6904f3 100644
> > --- a/arch/x86/mm/pgtable.c
> > +++ b/arch/x86/mm/pgtable.c
> > @@ -798,6 +798,7 @@ pmd_t pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
> >  	return pmd_clear_saveddirty(pmd);
> >  }
> >  
> > +#ifdef CONFIG_DEBUG_VM
> >  void arch_check_zapped_pte(struct vm_area_struct *vma, pte_t pte)
> >  {
> >  	/*
> > @@ -823,3 +824,4 @@ void arch_check_zapped_pud(struct vm_area_struct *vma,
> > pud_t pud)
> >  	/* See note in arch_check_zapped_pte() */
> >  	VM_WARN_ON_ONCE(!(vma->vm_flags & VM_SHADOW_STACK) &&
> > pud_shstk(pud));
> 
> I guess all of these don't need to be the "VM_WARN_" varieties if they are
> compiled out in the other case.

I can do either way. It is functionally equivalent.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

