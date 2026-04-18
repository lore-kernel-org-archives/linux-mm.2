Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F36DBF99C9B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 22:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3A46B02EF; Sat, 18 Apr 2026 18:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374676B02F0; Sat, 18 Apr 2026 18:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C416B02F1; Sat, 18 Apr 2026 18:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7FB6B02EF
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 18:43:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 984ED5952C
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 22:43:48 +0000 (UTC)
X-FDA: 84673155336.06.D5ADF62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B0CC91C0006
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 22:43:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k7cyKKxh;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776552226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjLPSQVl2LxydgcTJc90za+GrLftjKH2c+oZI30XsQU=;
	b=xzBzOTQ7axmjDebMw0lzOzhfKEs8QM/Y7IiGMat00Tr7px5RsG8Yitjtz75pb2plo2d8Pm
	fcB6XUj7DWJVROr3BVqSyB0ULcA25X7PFnsFmW4BfiVSOsbBBr3wCtlgNUroovXanQ65gq
	8B4kyMD7vBet4B1IFerkJe5iQBHXw/s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k7cyKKxh;
	spf=pass (imf20.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776552226; a=rsa-sha256;
	cv=none;
	b=iFimGdHT0EFjf9XfnoU116TFcZ1eFKyoLYNpQzj8Pvyp3f/fJZUPVQSPTxZRtIGmzL7BnA
	PRePrQ5fYVAHkiEBsqD1LrcH8nbigxp98y3z8H8lEd4XeiGaugGAcP4ngkaYJ8ONfhqu5J
	UnKDsGIMuH8L/hx6xa/bs2HP8z7t/bY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 85ACD42AED;
	Sat, 18 Apr 2026 22:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A71C19424;
	Sat, 18 Apr 2026 22:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776552225;
	bh=vjLPSQVl2LxydgcTJc90za+GrLftjKH2c+oZI30XsQU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=k7cyKKxho//9f3eaqLRfH8iM67nvnfqR8Y4s4IkdKfuPjJRrYRR3L9Yx/gORvowsX
	 yLX83zM3lO2cXZedZt2x3xkaInrZPrSv+VkIBwBsOtzraeEyG8aWaWIOos2PZDuUXA
	 h1nHJljq0ULF6aFkmOMJx9n3EhiYN4ljnbKt3RtLIqOydArn19zOWNjzAKKFICstyL
	 Rfvb00O3qJ3xBZY+Yme5nDcCsWhRn0ab2hOly4FS9uPcv7nRVpvxN2bsQSf1MVT7kb
	 gLJstKn95Rj4FwHbTylEdljaT6Xhe8skWzJ0pT3dGw4SCgIXVYzaVhpH8biMBpmkRh
	 7izYjeC5+OgRw==
Message-ID: <49f9b0f41ed690c0e9c62f893a9199ad9b857251.camel@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] Filesystem inode reclaim
From: Jeff Layton <jlayton@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, 
	lsf-pc@lists.linux-foundation.org
Date: Sat, 18 Apr 2026 18:43:42 -0400
In-Reply-To: <vpgymg4vq7fv2iebfjebxbufjvo2yre64lcwjgsbyivu2pxmpp@zhjplhrjayc5>
References: 
	<m5v2s4fc6od2y2en5m62sr6fx57fdkhtqrn2kv47ngpcb65ump@4cfu4os3x5yy>
	 <20260409161258.GU6202@frogsfrogsfrogs>
	 <c18f8189b755c13064f51d93bfcaddb15300f9f8.camel@kernel.org>
	 <vpgymg4vq7fv2iebfjebxbufjvo2yre64lcwjgsbyivu2pxmpp@zhjplhrjayc5>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=mQINBE6V0TwBEADXhJg7s8wFDwBMEvn0qyhAnzFLTOCHooMZyx7XO7dAiIhDSi7G1NPxw
 n8jdFUQMCR/GlpozMFlSFiZXiObE7sef9rTtM68ukUyZM4pJ9l0KjQNgDJ6Fr342Htkjxu/kFV1Wv
 egyjnSsFt7EGoDjdKqr1TS9syJYFjagYtvWk/UfHlW09X+jOh4vYtfX7iYSx/NfqV3W1D7EDi0PqV
 T2h6v8i8YqsATFPwO4nuiTmL6I40ZofxVd+9wdRI4Db8yUNA4ZSP2nqLcLtFjClYRBoJvRWvsv4lm
 0OX6MYPtv76hka8lW4mnRmZqqx3UtfHX/hF/zH24Gj7A6sYKYLCU3YrI2Ogiu7/ksKcl7goQjpvtV
 YrOOI5VGLHge0awt7bhMCTM9KAfPc+xL/ZxAMVWd3NCk5SamL2cE99UWgtvNOIYU8m6EjTLhsj8sn
 VluJH0/RcxEeFbnSaswVChNSGa7mXJrTR22lRL6ZPjdMgS2Km90haWPRc8Wolcz07Y2se0xpGVLEQ
 cDEsvv5IMmeMe1/qLZ6NaVkNuL3WOXvxaVT9USW1+/SGipO2IpKJjeDZfehlB/kpfF24+RrK+seQf
 CBYyUE8QJpvTZyfUHNYldXlrjO6n5MdOempLqWpfOmcGkwnyNRBR46g/jf8KnPRwXs509yAqDB6sE
 LZH+yWr9LQZEwARAQABtCVKZWZmIExheXRvbiA8amxheXRvbkBwb29jaGllcmVkcy5uZXQ+iQI7BB
 MBAgAlAhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAUCTpXWPAIZAQAKCRAADmhBGVaCFc65D/4
 gBLNMHopQYgG/9RIM3kgFCCQV0pLv0hcg1cjr+bPI5f1PzJoOVi9s0wBDHwp8+vtHgYhM54yt43uI
 7Htij0RHFL5eFqoVT4TSfAg2qlvNemJEOY0e4daljjmZM7UtmpGs9NN0r9r50W82eb5Kw5bc/r0km
 R/arUS2st+ecRsCnwAOj6HiURwIgfDMHGPtSkoPpu3DDp/cjcYUg3HaOJuTjtGHFH963B+f+hyQ2B
 rQZBBE76ErgTDJ2Db9Ey0kw7VEZ4I2nnVUY9B5dE2pJFVO5HJBMp30fUGKvwaKqYCU2iAKxdmJXRI
 ONb7dSde8LqZahuunPDMZyMA5+mkQl7kpIpR6kVDIiqmxzRuPeiMP7O2FCUlS2DnJnRVrHmCljLkZ
 Wf7ZUA22wJpepBligemtSRSbqCyZ3B48zJ8g5B8xLEntPo/NknSJaYRvfEQqGxgk5kkNWMIMDkfQO
 lDSXZvoxqU9wFH/9jTv1/6p8dHeGM0BsbBLMqQaqnWiVt5mG92E1zkOW69LnoozE6Le+12DsNW7Rj
 iR5K+27MObjXEYIW7FIvNN/TQ6U1EOsdxwB8o//Yfc3p2QqPr5uS93SDDan5ehH59BnHpguTc27Xi
 QQZ9EGiieCUx6Zh2ze3X2UW9YNzE15uKwkkuEIj60NvQRmEDfweYfOfPVOueC+iFifbQgSmVmZiBM
 YXl0b24gPGpsYXl0b25AcmVkaGF0LmNvbT6JAjgEEwECACIFAk6V0q0CGwMGCwkIBwMCBhUIAgkKC
 wQWAgMBAh4BAheAAAoJEAAOaEEZVoIViKUQALpvsacTMWWOd7SlPFzIYy2/fjvKlfB/Xs4YdNcf9q
 LqF+lk2RBUHdR/dGwZpvw/OLmnZ8TryDo2zXVJNWEEUFNc7wQpl3i78r6UU/GUY/RQmOgPhs3epQC
 3PMJj4xFx+VuVcf/MXgDDdBUHaCTT793hyBeDbQuciARDJAW24Q1RCmjcwWIV/pgrlFa4lAXsmhoa
 c8UPc82Ijrs6ivlTweFf16VBc4nSLX5FB3ls7S5noRhm5/Zsd4PGPgIHgCZcPgkAnU1S/A/rSqf3F
 LpU+CbVBDvlVAnOq9gfNF+QiTlOHdZVIe4gEYAU3CUjbleywQqV02BKxPVM0C5/oVjMVx3bri75n1
 TkBYGmqAXy9usCkHIsG5CBHmphv9MHmqMZQVsxvCzfnI5IO1+7MoloeeW/lxuyd0pU88dZsV/riHw
 87i2GJUJtVlMl5IGBNFpqoNUoqmvRfEMeXhy/kUX4Xc03I1coZIgmwLmCSXwx9MaCPFzV/dOOrju2
 xjO+2sYyB5BNtxRqUEyXglpujFZqJxxau7E0eXoYgoY9gtFGsspzFkVNntamVXEWVVgzJJr/EWW0y
 +jNd54MfPRqH+eCGuqlnNLktSAVz1MvVRY1dxUltSlDZT7P2bUoMorIPu8p7ZCg9dyX1+9T6Muc5d
 Hxf/BBP/ir+3e8JTFQBFOiLNdFtB9KZWZmIExheXRvbiA8amxheXRvbkBzYW1iYS5vcmc+iQI4BBM
 BAgAiBQJOldK9AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRAADmhBGVaCFWgWD/0ZRi4h
 N9FK2BdQs9RwNnFZUr7JidAWfCrs37XrA/56olQl3ojn0fQtrP4DbTmCuh0SfMijB24psy1GnkPep
 naQ6VRf7Dxg/Y8muZELSOtsv2CKt3/02J1BBitrkkqmHyni5fLLYYg6fub0T/8Kwo1qGPdu1hx2BQ
 RERYtQ/S5d/T0cACdlzi6w8rs5f09hU9Tu4qV1JLKmBTgUWKN969HPRkxiojLQziHVyM/weR5Reu6
 FZVNuVBGqBD+sfk/c98VJHjsQhYJijcsmgMb1NohAzwrBKcSGKOWJToGEO/1RkIN8tqGnYNp2G+aR
 685D0chgTl1WzPRM6mFG1+n2b2RR95DxumKVpwBwdLPoCkI24JkeDJ7lXSe3uFWISstFGt0HL8Eew
 P8RuGC8s5h7Ct91HMNQTbjgA+Vi1foWUVXpEintAKgoywaIDlJfTZIl6Ew8ETN/7DLy8bXYgq0Xzh
 aKg3CnOUuGQV5/nl4OAX/3jocT5Cz/OtAiNYj5mLPeL5z2ZszjoCAH6caqsF2oLyAnLqRgDgR+wTQ
 T6gMhr2IRsl+cp8gPHBwQ4uZMb+X00c/Amm9VfviT+BI7B66cnC7Zv6Gvmtu2rEjWDGWPqUgccB7h
 dMKnKDthkA227/82tYoFiFMb/NwtgGrn5n2vwJyKN6SEoygGrNt0SI84y6hEVbQlSmVmZiBMYXl0b
 24gPGpsYXl0b25AcHJpbWFyeWRhdGEuY29tPokCOQQTAQIAIwUCU4xmKQIbAwcLCQgHAwIBBhUIAg
 kKCwQWAgMBAh4BAheAAAoJEAAOaEEZVoIV1H0P/j4OUTwFd7BBbpoSp695qb6HqCzWMuExsp8nZjr
 uymMaeZbGr3OWMNEXRI1FWNHMtcMHWLP/RaDqCJil28proO+PQ/yPhsr2QqJcW4nr91tBrv/MqItu
 AXLYlsgXqp4BxLP67bzRJ1Bd2x0bWXurpEXY//VBOLnODqThGEcL7jouwjmnRh9FTKZfBDpFRaEfD
 FOXIfAkMKBa/c9TQwRpx2DPsl3eFWVCNuNGKeGsirLqCxUg5kWTxEorROppz9oU4HPicL6rRH22Ce
 6nOAON2vHvhkUuO3GbffhrcsPD4DaYup4ic+DxWm+DaSSRJ+e1yJvwi6NmQ9P9UAuLG93S2MdNNbo
 sZ9P8k2mTOVKMc+GooI9Ve/vH8unwitwo7ORMVXhJeU6Q0X7zf3SjwDq2lBhn1DSuTsn2DbsNTiDv
 qrAaCvbsTsw+SZRwF85eG67eAwouYk+dnKmp1q57LDKMyzysij2oDKbcBlwB/TeX16p8+LxECv51a
 sjS9TInnipssssUDrHIvoTTXWcz7Y5wIngxDFwT8rPY3EggzLGfK5Zx2Q5S/N0FfmADmKknG/D8qG
 IcJE574D956tiUDKN4I+/g125ORR1v7bP+OIaayAvq17RP+qcAqkxc0x8iCYVCYDouDyNvWPGRhbL
 UO7mlBpjW9jK9e2fvZY9iw3QzIPGKtClKZWZmIExheXRvbiA8amVmZi5sYXl0b25AcHJpbWFyeWRh
 dGEuY29tPokCOQQTAQIAIwUCU4xmUAIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEAAOa
 EEZVoIVzJoQALFCS6n/FHQS+hIzHIb56JbokhK0AFqoLVzLKzrnaeXhE5isWcVg0eoV2oTScIwUSU
 apy94if69tnUo4Q7YNt8/6yFM6hwZAxFjOXR0ciGE3Q+Z1zi49Ox51yjGMQGxlakV9ep4sV/d5a50
 M+LFTmYSAFp6HY23JN9PkjVJC4PUv5DYRbOZ6Y1+TfXKBAewMVqtwT1Y+LPlfmI8dbbbuUX/kKZ5d
 dhV2736fgyfpslvJKYl0YifUOVy4D1G/oSycyHkJG78OvX4JKcf2kKzVvg7/Rnv+AueCfFQ6nGwPn
 0P91I7TEOC4XfZ6a1K3uTp4fPPs1Wn75X7K8lzJP/p8lme40uqwAyBjk+IA5VGd+CVRiyJTpGZwA0
 jwSYLyXboX+Dqm9pSYzmC9+/AE7lIgpWj+3iNisp1SWtHc4pdtQ5EU2SEz8yKvDbD0lNDbv4ljI7e
 flPsvN6vOrxz24mCliEco5DwhpaaSnzWnbAPXhQDWb/lUgs/JNk8dtwmvWnqCwRqElMLVisAbJmC0
 BhZ/Ab4sph3EaiZfdXKhiQqSGdK4La3OTJOJYZphPdGgnkvDV9Pl1QZ0ijXQrVIy3zd6VCNaKYq7B
 AKidn5g/2Q8oio9Tf4XfdZ9dtwcB+bwDJFgvvDYaZ5bI3ln4V3EyW5i2NfXazz/GA/I/ZtbsigCFc
 8ftCBKZWZmIExheXRvbiA8amxheXRvbkBrZXJuZWwub3JnPokCOAQTAQIAIgUCWe8u6AIbAwYLCQg
 HAwIGFQgCCQoLBBYCAwECHgECF4AACgkQAA5oQRlWghUuCg/+Lb/xGxZD2Q1oJVAE37uW308UpVSD
 2tAMJUvFTdDbfe3zKlPDTuVsyNsALBGclPLagJ5ZTP+Vp2irAN9uwBuacBOTtmOdz4ZN2tdvNgozz
 uxp4CHBDVzAslUi2idy+xpsp47DWPxYFIRP3M8QG/aNW052LaPc0cedYxp8+9eiVUNpxF4SiU4i9J
 DfX/sn9XcfoVZIxMpCRE750zvJvcCUz9HojsrMQ1NFc7MFT1z3MOW2/RlzPcog7xvR5ENPH19ojRD
 CHqumUHRry+RF0lH00clzX/W8OrQJZtoBPXv9ahka/Vp7kEulcBJr1cH5Wz/WprhsIM7U9pse1f1g
 Yy9YbXtWctUz8uvDR7shsQxAhX3qO7DilMtuGo1v97I/Kx4gXQ52syh/w6EBny71CZrOgD6kJwPVV
 AaM1LRC28muq91WCFhs/nzHozpbzcheyGtMUI2Ao4K6mnY+3zIuXPygZMFr9KXE6fF7HzKxKuZMJO
 aEZCiDOq0anx6FmOzs5E6Jqdpo/mtI8beK+BE7Va6ni7YrQlnT0i3vaTVMTiCThbqsB20VrbMjlhp
 f8lfK1XVNbRq/R7GZ9zHESlsa35ha60yd/j3pu5hT2xyy8krV8vGhHvnJ1XRMJBAB/UYb6FyC7S+m
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B0CC91C0006
X-Stat-Signature: 5j3ctnurtj3awik1ru5nkz7rox7b3hbn
X-Rspam-User: 
X-HE-Tag: 1776552226-317396
X-HE-Meta: U2FsdGVkX18ArglDRQnEwGkecobPq1C3C7vo5umpLLWrimReC25zFZMYQe2ki6eHuwZRYbqurUBRy2H+Dg/tJvNXap9lQcxYt2tWuMZrF0Azw6a3/TUt7qyzirS9STDkAhogsSFAhAAPZBa3p5GKGs+m0qYTzajc5i5X/J/kjFGdDHHa6KxgccE6xFgF4sBW1XrfOq263RwoMjUJFksWW1pOYJkVoN9wvv+Av+TcLmZUQ2bvijxAZxCcjtw5H6g3JiVC8k8NT/nsScWRdfCs7XzqNLrcWVfcztoJJutMh6paG/8H3NpenflysEl/DkXVSilPAOcQQjnBo8S7OiYXSS6IqzoJCcrXJoDNtAW1vjqMPZdaG/XxBtIi5SNKem+8C5QZ1dlULt2fCBhxQYIuVGGo8MQ410NEC1cLkRRTlOZLaey1Tv4D+ldgffNGc+S0jMJ/RJcfmYU3mW9G8pjYjLZ1a7TDkkjYzB9Lnq8vw8HTl6i+t+tuyu+BjMzsDc1gqNX/128Ez6OEN1AlquWxUeGl+hV5us71O+ZwJ4VOKNYn38F1NNF+xK1mpqoADOU3w11FMDol+79eHd6PzwH2F/KAlHaFN+IyDFjbWyyDr0ZVzUJfc1LdWHDBoHZbu3MmohEfEeE3mB7rR6/g4CqhU5l0I9y8uatB2nOplXLjKSX2rmnXlMlZjGghZx36ZRXWRwA7ryG1eUqprQiwopIZcOJ7aIFAAnLCpmpN5GBxgz7t3H8mFQTh35PRB5lMotcPnTWDEpge0nxpDpy/3rC8No2Etge4OWVURFllrv1sSbEa7iqZvS3/37Cr2i2NY6R8lvhIOv2QVLGmJzsPnypgjwk+rKPuiBNJqADUSw3d11IIg3TV6YN9k1I2Hm2fQy1dUy3xiHkgQSQL1t8MFK0HhX5wor02szFdniHviXtTYa0GyjNG7/HsekBgGa3gh+Xt4bryC23JkWv28VM8Wmo
 QPp0YGUW
 hmJ5AsTm6TQL+cTH+Soil/pPabsL0J62oNgUKm5VUc1wfb+ETj2i+zIYIl2ornsTL1kvwcHzSQSRKOtkUMI+XxZ73ytLK8ivwPbVJvSaOgjhSChQfvPJV9uRPR+bLn4YnEo+GFQxGGwBAkoglFlK06/xUb+rHWxfPSqlzSqhwxK7/o3CzgpXJfmM1cTmZ/oMZxjFJxWFLvQnktQcbcjN8Xs+72ePMNVuQYnouf/ssFJg+Cgwyo7nD9hFTvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-04-10 at 11:43 +0200, Jan Kara wrote:
> On Thu 09-04-26 13:37:17, Jeff Layton wrote:
> > On Thu, 2026-04-09 at 09:12 -0700, Darrick J. Wong wrote:
> > > On Thu, Apr 09, 2026 at 11:16:44AM +0200, Jan Kara wrote:
> > > > Hello!
> > > >=20
> > > > This is a recurring topic Matthew has been kicking forward for the =
last
> > > > year so let me maybe offer a fs-person point of view on the problem=
 and
> > > > possible solutions. The problem is very simple: When a filesystem (=
ext4,
> > > > btrfs, vfat) is about to reclaim an inode, it sometimes needs to pe=
rform a
> > > > complex cleanup - like trimming of preallocated blocks beyond end o=
f file,
> > > > making sure journalling machinery is done with the inode, etc.. Thi=
s may
> > > > require reading metadata into memory which requires memory allocati=
ons and
> > > > as inode eviction cannot fail, these are effectively GFP_NOFAIL
> > > > allocations (and there are other reasons why it would be very diffi=
cult to
> > > > make some of these required allocations in the filesystems failable=
).
> > > >=20
> > > > GFP_NOFAIL allocation from reclaim context (be it kswapd or direct =
reclaim)
> > > > trigger warnings - and for a good reason as forward progress isn't
> > > > guaranteed. Also it leaves a bad taste that we are performing somet=
imes
> > > > rather long running operations blocking on IO from reclaim context =
thus
> > > > stalling reclaim for substantial amount of time to free 1k worth of=
 slab
> > > > cache.
> > > >=20
> > > > I have been mulling over possible solutions since I don't think eac=
h
> > > > filesystem should be inventing a complex inode lifetime management =
scheme
> > > > as XFS has invented to solve these issues. Here's what I think we c=
ould do:
> > > >=20
> > > > 1) Filesystems will be required to mark inodes that have non-trivia=
l
> > > > cleanup work to do on reclaim with an inode flag I_RECLAIM_HARD (or
> > > > whatever :)). Usually I expect this to happen on first inode modifi=
cation
> > > > or so. This will require some per-fs work but it shouldn't be that
> > > > difficult and filesystems can be adapted one-by-one as they decide =
to
> > > > address these warnings from reclaim.
> > > >=20
> > > > 2) Inodes without I_RECLAIM_HARD will be reclaimed as usual directl=
y from
> > > > kswapd / direct reclaim. I'm keeping this variant of inode reclaim =
for
> > > > performance reasons. I expect this to be a significant portion of i=
nodes
> > > > on average and in particular for some workloads which scan a lot of=
 inodes
> > > > (find through the whole fs or similar) the efficiency of inode recl=
aim is
> > > > one of the determining factors for their performance.
> > > >=20
> > > > 3) Inodes with I_RECLAIM_HARD will be moved by the shrinker to a se=
parate
> > > > per-sb list s_hard_reclaim_inodes and we'll queue work (per-sb work=
 struct)
> > > > to process them.
> > > >=20
> > > > 4) The work will walk s_hard_reclaim_inodes list and call evict() f=
or each
> > > > inode, doing the hard work.
> > > >=20
> > > > This way, kswapd / direct reclaim doesn't wait for hard to reclaim =
inodes
> > > > and they can work on freeing memory needed for freeing of hard to r=
eclaim
> > > > inodes. So warnings about GFP_NOFAIL allocations aren't only papere=
d over,
> > > > they should really be addressed.
> > >=20
> > > This more or less sounds fine to me.
> > >=20
> > > > One possible concern is that s_hard_reclaim_inodes list could grow =
out of
> > > > control for some workloads (in particular because there could be mu=
ltiple
> > > > CPUs generating hard to reclaim inodes while the cleanup would be
> > > > single-threaded). This could be addressed by tracking number of ino=
des in
> > > > that list and if it grows over some limit, we could start throttlin=
g
> > > > processes when setting I_RECLAIM_HARD inode flag.
> > >=20
> > > <nod> XFS does that, see xfs_inodegc_want_flush_work in
> > > xfs_inodegc_queue.
> > >=20
> > > > There's also a simpler approach to this problem but with more radic=
al
> > > > changes to behavior. For example getting rid of inode LRU completel=
y -
> > > > inodes without dentries referencing them anymore should be rare and=
 it
> > > > isn't very useful to cache them. So we can always drop inodes on la=
st
> > > > iput() (as we currently do for example for unlinked inodes). But I =
have a
> > > > nagging feeling that somebody is depending on inode LRU somewhere -=
 I'd
> > > > like poll the collective knowledge of what could possibly go wrong =
here :)
> > >=20
> > > NFS, possibly? ;)
> > >=20
> >=20
> > NFS indeed.
> >=20
> > Bear in mind that the NFS may fail d_revalidate checks on child
> > dentries when a parent directory is changed on the server. I imagine
> > some workloads might see a performance hit if a large file's dentry has
> > to be discarded and looked back up because we suddenly threw away a
> > bunch of useful data in the pagecache.
>=20
> Thanks for filling in details! I was having vague memories that NFS was
> relying on inodes with 0 refcount not getting immediately evicted. I'll
> keep that in mind when thinking about solutions.
>=20

In my mind, there are two classes of filesystems when it comes to the
dcache: ones where the kernel has perfect knowledge of the directory
tree, and ones where it does not. In general, in-memory and local
filesystems are the former, and distributed/network filesystems are the
latter.

It might make sense to allow filesystems to declare that they are of
the type where the kernel has perfect knowledge, and use that to do
this kind of optimization. It wouldn't get rid of the LRU entirely, but
could allow you to reduce the size significantly.
--=20
Jeff Layton <jlayton@kernel.org>

