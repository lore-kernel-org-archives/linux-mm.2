Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBE4DF436B4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 14:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27FF6B0116; Fri, 17 Apr 2026 10:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00166B0117; Fri, 17 Apr 2026 10:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E14F86B0118; Fri, 17 Apr 2026 10:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB3F86B0116
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:53:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95CAD1B711C
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:53:10 +0000 (UTC)
X-FDA: 84668340540.16.B62B795
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9AEBD1C0005
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:53:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4R7wPxq;
	spf=pass (imf21.hostedemail.com: domain of tamird@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tamird@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776437588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6KihdDRx6by1Vu2nrUFjFUosglOHD4iIZXI2okMrjg=;
	b=pOxa8QiSVk5muVh+desxH/0P95QqNIOxbADq7iqOJphjnEm3EtupX9Bw8oajqXCW2dgcDl
	lduVPpTDbaeIFuNGt7MpqV612SlFcbnQdhgwwUV+jqKvmFso0AszJ0Z/3VwCFRCsU9X7nm
	lvrCsK9Ul7ANtMD7UbbwvgTNhIzVmo4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4R7wPxq;
	spf=pass (imf21.hostedemail.com: domain of tamird@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tamird@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776437588; a=rsa-sha256;
	cv=none;
	b=mX2COaX48rpcu5co8YMB9fx2VC1uBRP4emCrcCJNrr4R26Vvzp4XCHLUbb7m2AJvj9xNYX
	uqKbNlMTpjYQCoVcqIiC0ZNKZRDTOaAomPyYMTlV8ex+BlrprkJ8mx1V51fDFl7/x1Iw02
	72rIbwycInFFSteKoMVnN8YtRWtqcLU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ADA5760008
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646DFC4AF09
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 14:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776437587;
	bh=w+jEvMypu34TxF/HMTYPqndABSSFqf1i1DK8TmibBdc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=i4R7wPxq9/JsFzD/V4qumCZo9S+IeAasGjRd+0deehlV6gvGpRIE+U88TlosADVYp
	 W4Lh1STVbOYq4Aror5X0NlawCH0v/OH6W19pU9dz6xNMYQW57dOrmqIqsWJwboK58k
	 uIu6eBkelwx3m9Yjd09KHG46cDXUyvECYDIpyzmFP4iEFX10PD+yyPvdzri5MScz5F
	 bSMe5HsucmsRPfW5i/zKYoOJchoBixixfTfaB9gE5xhpYUuQ+1Z0ASYe3eUGjpbjPt
	 YlRMnNBcoKH1gzkSFHIDizSIji6rPTUaUIgK2Fz6q5wdkPxIvTxeMEWE46xfqgqYHd
	 5tAfbOh0i9gQQ==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38e7b8e3f38so6245781fa.3
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:53:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/slGR4qVG3BefNW509q6GkdRMpIVU6ZGtXCbcLaFeyhMKkB8ueMOqNbgFK2dxDRydOxDUOlWkiYA==@kvack.org
X-Gm-Message-State: AOJu0YxZDO41DxALogFlpw65VzUpa/DtgUyl3RIb6E5siZg/Rrny5Vwz
	7B7guADnSljAUQYfmA857BiHTXHXJ0ULBMapUJ/e7MfSJno6CTaWPu57CSJhEAjVX6e3QfvBISK
	ir1rXF2tO1e08tPTLKZi7EBG9gp1ywRE=
X-Received: by 2002:a05:651c:1114:b0:38e:83a6:d4c with SMTP id
 38308e7fff4ca-38ec77f67a1mr10636321fa.7.1776437586121; Fri, 17 Apr 2026
 07:53:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev> <aeGKTIRFgBqHNI9S@casper.infradead.org>
 <df183bfe-21b9-4393-902d-18835e0bcf48@linux.dev>
In-Reply-To: <df183bfe-21b9-4393-902d-18835e0bcf48@linux.dev>
From: Tamir Duberstein <tamird@kernel.org>
Date: Fri, 17 Apr 2026 10:52:29 -0400
X-Gmail-Original-Message-ID: <CAJ-ks9=veRG_8SZ7CyzqdR2RhtJ6QZWozyo8oc-xnwoqpCdg6g@mail.gmail.com>
X-Gm-Features: AQROBzAPLPhYX_Clre1Isbc9aIHCBVWmh5wlFLJ8mxNzXW6XYYnQq98hgG8ihFk
Message-ID: <CAJ-ks9=veRG_8SZ7CyzqdR2RhtJ6QZWozyo8oc-xnwoqpCdg6g@mail.gmail.com>
Subject: Re: [PATCH 4/4] rust: xarray: Add Guard::find() helper
To: Alvin Sun <alvin.sun@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8fqy56u4wj9na1gjpusywgkbgp1bg1a1
X-Rspamd-Queue-Id: 9AEBD1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776437588-318058
X-HE-Meta: U2FsdGVkX1+b+64eCfGfU104xFZBfc3tVfYMqUWKO2rXzPkiumSY6G0hF+0vK0W6mJjRTXfi6XJYAyZN5wzc7qGLW1n5WTBexYgi/kWWabBPaImSJu2ej6NKYKBlEWdTClM5zRnb3QQF4rathyv/L+xVmDAtc2npamJO4EtXwFg+Y58SyWG62ibkeb0d1n8Y+zrdC6vP1j6gblsn+Eg7uTSvCfdbWDxWNgrVUAx/RgEL69McJ4WquxniAXa+NbOl34ef1hkd4UJb7iycIb5HBtRUCkNUCQxGRA7QvFwS/5ka6o1v9QfqudZcC2S/++mbl4dsurv2lWDylivdK16xIAqdWXXla/ETE/1AEqGdq1nROUTCxfMe0MFB3wEvQfC73V16FEZzPblOmiQRD8vd/2KIQblmsWbhCefR9qUrCDfVgO5VRBCD6wXrhPx7nLrbs0KvuSOHj2HpB5NL/FWRLWnbjAE6sacDAAaf13uhsiQkNah7Hyfk2DSQaqSWIrqOYfXrbnxZTP5cPC3X43QLi/x6CTAeGZpQyhSk5MHNws2jqUT5dKUbnuL6n+h63EstfwEt/ATDLban7n+3Wt2vNbb6wtbLt7jnfcpYUyZowzKImfF7qdYfka2CAold3JmDxyon4PduC8AhxifAogIZmvAq1+LkOeHQspGe45eNv9fyqYByLB7yBCMEMR2M9p0blYzFANjtiNQx2KWOnobj4g/p1jyhOcFHzNyw3tbgA2wq5nwfgcvgme3dOpI5wVQCoQEMyrYqq0wgtq7R+c6Eekog0vpyOR5uCpuO7u89rD8RUiNwDWqxv9eZfmmGUeoO18+97WAm7mfs1W1RwXPFpf55orzBNlU1PvTbwBMXporcyJvhQIELVY9hulv975iTjItlBBEe7fyYxMh7tsnLUpwSVzbYidOunyggREn5CpP5hVNNVVlPn94pjmdtDEkKQsnuDjtRxPDW3gpPhJe
 ibe50zVI
 0FyCSCZurpCVhHSSB9wkphHqxo3BSG3bFz+4AceXZTq+/iJmeZO6csFtM/hjD/lNwJJDjtBOSSX07ii2btNpQ8jwAae1MRm6j52lpLyXF/gqZgHKzHfSUUnWgc0Z6DwdvhUTPrNOMbhMHlCrCdtTtVimvLW6otJq4dFgcIMihgT3GJHrYLoJj3QnIEO83lXQS/oK4gF9IMUZHIL2Uie0NJV9dGjrGns9n2MeZjQ3RATSWJvN+4PbWecMbX3d5J2DzmRUGXTzdyd35+dNfZlNT3DChK5U9HNkZX7mkYiFA0oL9Szu1BdWLxzMy4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 10:17=E2=80=AFPM Alvin Sun <alvin.sun@linux.dev> wr=
ote:
>
>
> On 4/17/26 09:18, Matthew Wilcox wrote:
> > On Fri, Apr 17, 2026 at 09:05:54AM +0800, Alvin Sun wrote:
> >> Add a helper to find the first present entry in the XArray.
> > Why would you expose a function which does striclty less than the
> > underlying C implementation, rather than exposing all the functionality
> > that xa_find does?
> >
> >> Returns the index of the first present entry, or None if the array
> >> is empty.
> > Why not return the value found, like xa_find() does?
>
> Hi Matthew,
>
> Thanks for the feedback! I had considered both returning a tuple (key,
> &value)
> and an Entry struct, but only returned the key since that's all Tyr
> currently
> needs. I'll look at other Rust code to see which approach fits better, th=
en
> implement it properly in v2.
>
> Best regards,
> Alvin
>
> >
> > This is all very troubling.  I don't think Rust should depart from
> > what C has without good reason.
> >

More complete wrappers around the C APIs exist in Andreas'
https://lore.kernel.org/all/20260209-xarray-entry-send-v3-0-f777c65b8ae2@ke=
rnel.org/.
Perhaps we can borrow from that series?

