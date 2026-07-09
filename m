Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D7CC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 12:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5666B0088; Thu,  9 Jul 2026 08:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B85196B008A; Thu,  9 Jul 2026 08:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74136B008C; Thu,  9 Jul 2026 08:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 887916B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:53:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 137901A016B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:53:29 +0000 (UTC)
X-FDA: 84969229338.16.B8C83AA
Received: from mxout5.mail.janestreet.com (mxout5.mail.janestreet.com [64.215.233.18])
	by imf06.hostedemail.com (Postfix) with ESMTP id E45D5180009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:53:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=janestreet.com header.s=google header.b=J+cNeiVA;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=L8B4qYgx;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of gleventhal@janestreet.com designates 64.215.233.18 as permitted sender) smtp.mailfrom=gleventhal@janestreet.com;
	dmarc=pass (policy=quarantine) header.from=janestreet.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783601607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZoKSxbcJVeP9SlvTpbB1P+sU86PjyJO8+MnplbnKPs=;
	b=KGpMhnV+lrYaCOcqRm7GI98I0HgFUUxjT1az9SSsiSL6egYZ0dQ/ClxnC88VV0Xo7/Xm90
	3WF8zOrqiy11FJMhXTzbAn3ihTc4+US8soWChUSwjmsROFESr0pRbg8+5oIdXyeyWTUG8G
	O/SbFmJk0c1Uj5Db2D6A/ObMCS6buWg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=janestreet.com header.s=google header.b=J+cNeiVA;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=L8B4qYgx;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf06.hostedemail.com: domain of gleventhal@janestreet.com designates 64.215.233.18 as permitted sender) smtp.mailfrom=gleventhal@janestreet.com;
	dmarc=pass (policy=quarantine) header.from=janestreet.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1783601607;
	b=gBi+oQa3ILC+iO/wZe6j0pIz3nXURIq8uLpwZX37iparM2v/ht8KITSG2pT3pQXUUvjvgq
	9voqdgkVdZ7aepRMybqaL7UaThkiHIUSPvJ9YNjsoQDVpUq+lOMFy826NCwC+KAIl8NpTQ
	ZzCbT5v5V3qvHD5tnJ2DYZ3QMVITzeM=
Received: from mail-lf1-f71.google.com ([209.85.167.71])
 	by mxgoog2.mail.janestreet.com with esmtps (TLS1.3:TLS_AES_128_GCM_SHA256:128)
 	(Exim 4.99.4)
 	id 1whoFp-0000000BVg3-2N4l
 	for linux-mm@kvack.org;
 	Thu, 09 Jul 2026 08:53:26 -0400
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5aeb8c3f9ceso350575e87.2
         for <linux-mm@kvack.org>; Thu, 09 Jul 2026 05:53:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783601605; cv=none;
         d=google.com; s=arc-20260327;
         b=nKQF6JiRtB5XN9WIXqymlqUc9MnZHZ8kK9U9t1YoBgjUX36MVbPdFm242MlXDs+Wvg
          mwv13CxIkVNNP6I0XzB9xrRAlxp9/Z/SjqhAdcBu4wXJ/4/3LNmCpoMdJYZP3zeFR5yA
          CEbesQwYvEFCwHS8IoRvF4wB6HayduC3jMWM2o+34M0GmJRoxyjw7zudDSk1b0S/8wAm
          BNYgZQvZKECzP2DPWPaRl8z9ndToXwVUhU+RvM8OBNt2cddk6WFXeYxEOdxQeMhL1FlZ
          xf9QlHhXh7dIGHGNv7ci4yG3MT3HAJRBtwsUFVDBg77VrxRVNad4I3R2uScX9djg5IZm
          HYsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
         h=content-transfer-encoding:cc:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:dkim-signature;
         bh=CZoKSxbcJVeP9SlvTpbB1P+sU86PjyJO8+MnplbnKPs=;
         fh=98oVKz3cWon6Lw34O4SeIKE21qH2mCjsZykPBVA71tY=;
         b=WiAb0Njm3iNhTXM2IdDzklHbjhAqw02L5z81Gk5NhyKj3aNSgUu80NGhlTDl4A8WuG
          xnX7w7sb2/R7wZB2kc9pcoPCTAyzLt9NAYmczHhn8biDObYLYwxpIQQ3yUcpWivFZ4Ih
          6EtTvzdsiAruTpIGsOAWis7CyVrE+mlC1JzsA65ruOv3eNn8vH4m8/S7iC9tFQZyxcBW
          xDhN1ipWt4US3rG3MTzp/dUmErJhdESqUBqwlIlsSdwYuQae/w8c37VlsQFcbIq4WhT9
          yDOK7TIU+oenCkm4ecHWye/bXJQFc+SrocETxWvMN2DlbrakN9oWRoaL01FyTBqxSwaW
          b95A==;
         darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=janestreet.com; s=google; t=1783601605; x=1784206405; darn=kvack.org;
         h=content-transfer-encoding:content-type:cc:to:subject:message-id
          :date:from:in-reply-to:references:mime-version:from:to:cc:subject
          :date:message-id:reply-to:content-type;
         bh=CZoKSxbcJVeP9SlvTpbB1P+sU86PjyJO8+MnplbnKPs=;
         b=J+cNeiVA9U4LY9Kf4I+FfSvP7px7pEfYbS1fInX+NLAPRPHdPKT5wRNskKnWNWQWlw
          6rw69GnOY6BoX4LEoenb9NODsRZ5i7Oj080Oz25gQWgC9y9MT14Ar3EK6BJG1ilkpHuy
          trBxHRyTPnTgK2pC+msa4qlk/IlsicStv1xs8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1783601606;
  bh=CZoKSxbcJVeP9SlvTpbB1P+sU86PjyJO8+MnplbnKPs=;
  h=References:In-Reply-To:From:Date:Subject:To:Cc;
  b=L8B4qYgx/650Ad0m94x+Rcj2z/H2Kfyj6P2kl+b6SzjNWCtK2t+pDTKCgWwChdb/H
  RV4QL3tWySnXSUzw/Ehox9UQ0jbf4zHzCtPz+KP4zJpqSA2ecPTJBqzE17/mrwGK7v
  VHfHpIBGSmEX8DNOVAQMzVX0aQmqlwLw+ONA6TcQUK9M06tOq4I7Iq6WUMLRjgXJxF
  TjZboAl0DlkQxSVjH169u3unDoqYycPFzW7CPrSLKdvZ7wTLZAxJWyjEHo4ZF4XIgc
  OCueJ2rMrvDdEArS+rzbLeGR62n7vE+9bpdYMV9A970qq8kF6Q6XPaBTunxjvYuQWw
  fqKcG9JEIFDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=1e100.net; s=20251104; t=1783601605; x=1784206405;
         h=content-transfer-encoding:content-type:cc:to:subject:message-id
          :date:from:in-reply-to:references:mime-version:x-gm-gg
          :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
          :content-type;
         bh=CZoKSxbcJVeP9SlvTpbB1P+sU86PjyJO8+MnplbnKPs=;
         b=DOC7H4XxpQy7LRrHVKlhLii/dM5A0y/xbg0EyhtG0eD8935Kdi8JW0uV1jIOC0Fb8a
          G3S7H0CtO8dn/OYLnBsQikXbA6/R7g6Yz4bSdHN5tLd0isy9A4xVGaiNeFQuBIkienhW
          pOD/6XVUV+TFjL4+zV2N2usY5hudGHmDIwviLW3OvOzbRljkc+g6/FwNSy8D/fiH7DEc
          6dDcIuiJTT0osdV8BKzXuSlbwHhVahP3kKwbrDHk41UOuM0CCnNp79RIl2gfXmNfh0rX
          h4DBbAunVQojz6Jp1CVvCqjpPccdLcWD1WGC2jF3wXV+oVkQUQtbumtrZ+ogXDcV/Aqv
          Hv6w==
X-Forwarded-Encrypted: i=1; AHgh+RpRizrlyUt0u4ZMaZjBTNthoB1DwhRuJ66tYwI96uyAbxYmS+IuCL3t0ZzeGa6ZFlRu/zFJKyGM2Q==@kvack.org
X-Gm-Message-State: AOJu0YyaMfsSCFUkOzE6Dk+WjS4LjzeoVIhCB23JCVj2ddTOgsf/IltN
 	1VsHZDwRikIwBUub6t0Fko56ZcpE84TySMxxNrC0ki/XdU5D1wEmlT0QmYoUYTeCiL2yU6aFt0F
 	4v00RITsmEjXCwhs+IsCqEwouTLl1Mv1tMUSNcYLag9dipWX1VwQB6ugKcai41sIv7bg1mNdb3U
 	bm88ewIYy52JXRo1cxkLz9ot2IXg==
X-Gm-Gg: AfdE7clrS/R/DwjT7cM7xaig8RDmc1EHkeZa19OAu7sr+1U2cK6Lp6qaHYd0YPtbqyb
 	ka/vNw/k1Xg/KUMIpHWn2L3WVpDsAmRBtimg1dB11w7t9SdPXYFeIXmnkKzNJSCVat/M3x7C9I3
 	vYifAx016VTsZ51z7cZBQBpfq1JouKTsjcRVJ5LgvzWUVBP9aluaJZBR8GYQrgIzA+ARY=
X-Received: by 2002:a05:6512:4384:b0:5b0:14a5:372e with SMTP id 2adb3069b0e04-5b014a53b08mr833271e87.27.1783601604997;
         Thu, 09 Jul 2026 05:53:24 -0700 (PDT)
X-Received: by 2002:a05:6512:4384:b0:5b0:14a5:372e with SMTP id
  2adb3069b0e04-5b014a53b08mr833263e87.27.1783601604634; Thu, 09 Jul 2026
  05:53:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260702165409.164568-1-pfalcato@suse.de> <akhYu66GmjyM8l6a@casper.infradead.org>
  <CAFN_u7HkJry=iFLbZ2vjzv5C=HnrptHfFJBLOqRq2m4LyhqV_w@mail.gmail.com> <ak5g9h3FuVn3bZ1G@pedro-suse>
In-Reply-To: <ak5g9h3FuVn3bZ1G@pedro-suse>
From: Gregg Leventhal <gleventhal@janestreet.com>
Date: Thu, 9 Jul 2026 08:52:47 -0400
X-Gm-Features: AUfX_myfsaz2CNj6SYVdToPKTm3sV3q-2qQKmWB5EgGOqp9HxGlKza-X6yxVsEA
Message-ID: <CAFN_u7ExSnVo=QQBuZvRJkLR3rHo8qN96rDKYu+KNiSjk0FCHQ@mail.gmail.com>
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when collapsing
To: Pedro Falcato <pfalcato@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
 	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
 	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
 	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 	stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Song Liu <song@kernel.org>, 
 	Eric Hagberg <ehagberg@janestreet.com>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E45D5180009
X-Stat-Signature: h5ekacmd5o7wd6ygdk9j3n36k3b8s41d
X-HE-Tag: 1783601606-851075
X-HE-Meta: U2FsdGVkX19sY4Mx2PVPNW0cFl7JU6aNO/Ncrwil1XDV1icK9AnUaXsGiV+sWdTxG15CNQ7YUtuLeBp20HkjXEdhzwfB68nUQd9PMieyL7KgZL8cHGW49jKmsxXkvFbrSLo1GK0BKaYt1pAQRQD6UvsJFOmF2GcMomDM/NibfoUAG3k+c80admHfc98wQPPvhEk7dC/pksV9e2UDLADkogUVm4fxXyNo1Yf/8MUpLyPqngrybNCUFFMkDH7z/usk8Pe5Q2dx9MuzFZv6qKaLxfO2akG+HYjoPnH51FmZpwrcD2PVRTFk/BCRBafbsf5UxVnuiFVw74jzMVzGXcsuLGWJBF0vgB9b2SA34oyCbczGDM6am5oZRy6kLywgnpz7t96C8Usj775Vhd+CqaE/vqanRfhTzXiDzxa8NfKdBGiOwweoiWHoJHpw10EZFIU6d7+RZYoQOogmspX9+VvAAzKefr9igh7hWDS7sYG2jr1yfpWl4y3F7+iOA2ourDv1XQ5g4Jo4oqsTnwJkllLJnxj28ZiTGAbjLqaPoflhBbqXFSviFNA2AVCdpO9dOnc42ZPZhVBEph/VVOEXOUi2Z1g0einJnwC0xXTPAYNEclbfRxUeLVrP0XpymPFGooJOKoLhfVg30b/jlU12RMYx+xnyyiz7CpARrC3A9VhN6RuCw9uXUIswtGhJe9a1Is4SLBJYKPpwGxiSc8MLRw6W7QDK6vFCasbVoF8+3eL2bOAI5/E6EOuQ8/+7AwTEwRzHX6QREKLAydhdmWtAA0Gsm2a94M2GiMzw2PSZ1kp8C/FIrSE1QkEY92QNg9tiMH8x38veW5GVMGQ12PvpmN5V0OBaILJzDozJQrE+qMXYUkzmEF4U1zySPZlr7Df6w0gGoDiCE6SBPBaI0hcglaSbzo1PSqJXtHe0cNyDhZKCUDrlr/wLi3bipmpqyf3IvBG76FaPtxOln/YRaWEx45s
 5StESHKe
 Sx5rLjecRNN71HJNrm8QcqD8zoE9eGI531ldqLEJBCh4kGFHwSoMoGn9jNsA16yeOEbc7F/k0JnBLBsV8j0gZviT+u/hluaOCn4Xvgq5iAs0gySciP4zc+mcneNj5A+LKJ112pNi5LhN4uOHVIgXZEdlrjumUdTB80DgdXQXs6WHInumXaDJjVkt5aUhlG3zAorgRP9s/Zd004/auJhLHLa+I2ZzzEbQCnYjktFQRvPsLrb3pKYz/6KT32sur0HAtcuusfk38fhKue+azU+KdAWe+nvCZEOhr343CrmCC1cJ32InpxYSyN/i3lQm2QtrMRW5+/gZ6JwWMV5jg3iTysyNqiVlGqrJIko5OCwY7WjNuh//4+dNgaNU3VlmJDXiefR+tolgF+GFzmRs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ack thanks for the update and all of your help with this!
Obrigado pra vc (Meu esposa e Brasileira e achei que vc estava
Portugues da sua nome/sobrenome)!

On Wed, Jul 8, 2026 at 10:40=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Wed, Jul 08, 2026 at 10:05:43AM -0400, Gregg Leventhal wrote:
> > Hi there, just checking on the next steps here.
> >
> > @Pedro Falcato Are you currently working on this patch (mentioned
> > above, re: holding invalidate lock), or are we perhaps stalled on
> > something?
>
> I was waiting for some actual tags from people, but given the comments an=
d
> no tags, I'll respin a v2 before sending to Greg KH.
>
> --
> Pedro

