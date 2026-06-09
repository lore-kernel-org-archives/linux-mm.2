Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD42CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53406B0088; Tue,  9 Jun 2026 03:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A296B008A; Tue,  9 Jun 2026 03:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967576B008C; Tue,  9 Jun 2026 03:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C06B6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:21:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D858404AC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:21:48 +0000 (UTC)
X-FDA: 84859529496.29.6F34070
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf19.hostedemail.com (Postfix) with ESMTP id F2D041A000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:21:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=BDmC1IqT;
	spf=pass (imf19.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de;
	dmarc=pass (policy=none) header.from=fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780989706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttaPCtrBc3STGwKMfR62Rge89sISRTtqGZK4dmGPG3c=;
	b=Bd98Jr5y2IxH29XtkzseazcT0hiyoGpezLLkndBYLiQ6vG83lht2w0Ga8/GzrhJ/3DBgR8
	ugQD5Y/bFGzvZ+CheArKH7RCZSShT7D+GOgJ+3rkQDDAfpEuI+oDJPJzk/tX+yTw75G6K0
	e6ZZzqTExSb8C2m1OU4TFvhnHJ38+YM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780989706;
	b=bypZXBdlXxYZzrJSXtVhfY6z5wVRoDyTis/3Xvr4TOBvRzsMP/iDNaJaa90wvVUag5msaq
	97CAQCr5U72Wu+OcWHweaywdjI975TOQhcHNUAzECaDF/cOQEhpSbEtdCNVqsA+Gt1wJKo
	6j0UaAYBi19sNGYvPuNRrydCAbEN1vs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=BDmC1IqT;
	spf=pass (imf19.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de;
	dmarc=pass (policy=none) header.from=fu-berlin.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=ttaPCtrBc3STGwKMfR62Rge89sISRTtqGZK4dmGPG3c=; t=1780989706;
	x=1781594506; b=BDmC1IqTnSPzEXDkt5q+s81c3ZtwBq1GaCDeFrV/+wNbhex2tUIqdYPQswLDC
	02pRpvOyvaMk63KfeRTA/w7V33IvxgP1niq+UyL/cMkkvgk2/I72+Gl7oap0K93ZM3DkKgYSqhkal
	ht9OB5g/TPdTHQJvy7zbEbYu/Q5QeWf/HLCWEdJqS8HhCqYRZF4uOnutrMgG5HkwnYUCCMeGJtPJM
	a5RC5eXRq6K1MvR5h7CNZk8cmupVeaqfDZDDLe6tSpuF5PLx+vbJRAuBXavmYym1CVSehPQwNxe6a
	BxSmQTNd/1mXhbH27yGY3R0nywd2/AE9x5QL8MVZvfFs2r58Tw==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.99)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1wWqmI-00000000PFR-3zui; Tue, 09 Jun 2026 09:21:38 +0200
Received: from p57bd94c1.dip0.t-ipconnect.de ([87.189.148.193] helo=[192.168.178.61])
          by inpost2.zedat.fu-berlin.de (Exim 4.99)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1wWqmI-00000000jAC-318T; Tue, 09 Jun 2026 09:21:38 +0200
Message-ID: <865aaa7aa64ab69ca9020d64d86baa8d9b700bcb.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v2 00/10] sh: remove NUMA and SPARSEMEM support
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-sh@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 Arnd Bergmann	 <arnd@arndb.de>, Rich Felker <dalias@libc.org>, Yoshinori
 Sato	 <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Date: Tue, 09 Jun 2026 09:21:37 +0200
In-Reply-To: <aiBI_QEmeVSBb2HY@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
	 <agr7XvoWn_-axX1-@kernel.org>
	 <adb1db8d1fbb9d219fa041776ae863aa2fc09270.camel@physik.fu-berlin.de>
	 <aiBI_QEmeVSBb2HY@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 87.189.148.193
X-ZEDAT-Hint: PO
X-Rspamd-Queue-Id: F2D041A000A
X-Rspam-User: 
X-Stat-Signature: dowa4ze9gwjmq3yh5qzj3gpnh9g6tsdf
X-Rspamd-Server: rspam08
X-HE-Tag: 1780989705-474147
X-HE-Meta: U2FsdGVkX19rk8scwa/CscoBldztL7d4T+/lv7+cdoHq9R8ABkK83KVBjD6zRtLo4OnpX4gbjEfsltmW3mcTGwHqfBpbg2HUeLx9VzA2cwFaOe3eHFjNg/RKbXNi5QVDy64IFm+QlLVELte7xnheR0vq4Vtr1O64H7gcMyAtN8Ima/N9OIN6i7M93G+XlTv5GxyLSFzUkn8juF9t72XbSMsWhF7TxJEfygjU4EUV8hcmrmDG+KZEKfAKC+wo/GO4ChJqaDxXuJxjwDzni1gVR05bvmBIzBnB6EEDd4gZyPeheyXx0KAzKlDgIQlqBHKBGFE+U+0hBJ2HRQoFbDzz5FLV8n0PByFhyhRMqDoYbwez5VRTp3KowS+b6yuE17txwsAAM61xFh7Tlyw+JgD0BXogRZDrSv80aR84fnm2CfEU0OpOU/d4GaCWpaOPcsKBfAcyKxpBdc6zGGTmCMHuCMR2PfrbvPmQLi2bxFWGJ9oG+vgsSJ4rUsSfbI6R+OENcXPdEMyVP87S2gRk7KuuFkyq1VAKYrua+JWXDFS6zvj16lfGJ5F9wdoYXA8oHcHcNQDH+9matG0GErQ9APl4IwALbr+Y7xMXSKtBUlPOSYnS8D/Egz7kxQjXxO1qKKCljOk3zX3XPorwPFOD/QFVtIvAvO1tfbKbih8oLhzkifiL4gDoJ1uAWAgx2eFOxffuKpp6FBDqs3WFOaiZtKXOYbXbELAgckxhT792UpSHcSxQgoHE6yZvmdKDIQcUnKMqOVVcT9T7yZyfi/35kIGI+cp/NiI9WVr1f369NYhtH19cfXvItzqzeNFXmtOlOKDno/uBjknyatkPLZdSRtnsZsJFQKQs34n+jUFEjB2LcqQz1x6N8wk65+ham83fdCPlaWMhobNp9M5hPjyuX7WcTPBT9BMKiLbCXQl2p0WTWfL2yWZs/92aHu0lZZt+4UZhO6DFyiaqMvCROzqayG6
 MNt2rr4d
 DaRqI9dtSMtuXuC2lBUh7BWhqDXBRyctfLD2TwplmH+XmajFV2IdMH2RgKw0LuCenOB3LitPRUW2osmvWbgCJ1A4WJcmq+SigcKaCtvo3Pb1H+0A+N0BnVl9KuzQgzrF8Vx6UsXJHBvwZPfT3PlONWX0oHWi+hqc8cpUVpNB9nChHm4VCQ3sjkb8/mny+WyOz/yaQ+aTGbXzAJYfbEEqDWlVAj3JULNJzXuwG2TLHXGGqG/FeWc6D5teU/CKGzO/u7IErvPqG8KOhGi0r6utAUkCUovJIlpca/P/pdUsm+BhZ+/1JOEltL9cI9IkV5c+rNq75c6S0DhYF/4GrI949Giczo/qnsanro8QfRSdkOjQaM6IEaIA0bJ5SCxbvs/2z6h46lgzTQcfRH/7vjb+R54SmN5BP3AbsXpuIz/f8cIrs5OnSaWZwTs2jNVGyiUr6pAT75Sib3fXCKKSjwEqKwoVGQBdcxgvYehlERRxKBAUCEXoVMoDaq9mCIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Wed, 2026-06-03 at 18:32 +0300, Mike Rapoport wrote:
> On Mon, May 18, 2026 at 02:05:39PM +0200, John Paul Adrian Glaubitz wrote=
:
> > Hi Mike,
> >=20
> > On Mon, 2026-05-18 at 14:43 +0300, Mike Rapoport wrote:
> > > Gentle ping?
> >=20
> > It's on my TODO list for this week!
>=20
> It's sad to see this being dragged since mid April (if we count v1 and
> there were really minor changes in v2).

I apologize. I am doing the maintenance as a hobby in my free time, it's
not my primary job and it can sometimes take me a bit longer to take up
changes.

> If you don't have time to take care of that, just say so and we'll take
> this via one of the mm trees in the next cycle.

It should be better this week. I've been recently busy with CVE fixes durin=
g
my dayjob and the workload was extremely high.

I am not going to let this slip, don't worry. It's just been a bit too much
stress the past weeks due to the AI CVE reporting.

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

