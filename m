Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD5BDE81A29
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84A16B0005; Mon, 16 Feb 2026 09:28:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2EC06B0088; Mon, 16 Feb 2026 09:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1AB66B0089; Mon, 16 Feb 2026 09:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B92ED6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:28:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64761BE080
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:28:01 +0000 (UTC)
X-FDA: 84450549162.02.723C2F5
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6CCDBC0008
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:27:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=hansenpartnership.com header.s=20151216 header.b=Ur6I+4vu;
	dmarc=pass (policy=quarantine) header.from=hansenpartnership.com;
	spf=pass (imf28.hostedemail.com: domain of James.Bottomley@HansenPartnership.com designates 198.37.111.173 as permitted sender) smtp.mailfrom=James.Bottomley@HansenPartnership.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771252079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CC5ndQKI3+lrk7xVZULUXTuhJilco9CobjXvKQNVBDo=;
	b=dqrJz17ZlbV7hHj8R8AWEVMZw02njzK02LG3vj7OmHtVJHoWbNE1fSWz0LDqSkeE7/CI0d
	1nynCvxjzCurgiSBx+TsxZbAUe9Bl4XfG/cwmkN4rFrRBpA7QZ6MmZkAPToEBNXkZA3QJc
	QjVtgTvfpe09qkunlu2nSe9YizO42c0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771252079; a=rsa-sha256;
	cv=none;
	b=dFPQv4eGcl4dGr/hrApXUIEoO78Cp3WByncdzBki1JDflLC60orUmmXZBUmZJU0rD6kFHF
	zHxI1p8gEc3QI5CKBjIO+t8cqF+7uiLTciXWJ3zZ/F0Ly0RoMcklkUI1UU58Fit79Vy9S/
	MJQqVAYeYG3MvbjU72w0ih8hnxKMSuA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=hansenpartnership.com header.s=20151216 header.b=Ur6I+4vu;
	dmarc=pass (policy=quarantine) header.from=hansenpartnership.com;
	spf=pass (imf28.hostedemail.com: domain of James.Bottomley@HansenPartnership.com designates 198.37.111.173 as permitted sender) smtp.mailfrom=James.Bottomley@HansenPartnership.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1771252077;
	bh=MtcCq8Q/toF5+4G4R//eJ35djW28Qb2ZH37NsHcalK4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=Ur6I+4vuOPWcqzJ+oAJbrLtAGHkDhZ02/4Eolox4D/Qh5UlLW8LXzJGEbVyq58KRj
	 bmvDQbtxGXoy9yor/jDbiYa3FmM38OphVx8vx30BODPNZ97N15u4dc7iUF/hUuyXse
	 a0E4tytnj/61YCyaTFuapRARV8qjd9A4Uyy+p0m8=
Received: from [IPv6:2601:5c4:4300:d341::a774] (unknown [IPv6:2601:5c4:4300:d341::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 687611C02F6;
	Mon, 16 Feb 2026 09:27:57 -0500 (EST)
Message-ID: <9c7a5db754143f59bdb2129616d2a23495d4b3b9.camel@HansenPartnership.com>
Subject: Re: [LSF/MM/BPF TOPIC] eBPF isolation with pkeys
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Yeoreum Yun
	 <yeoreum.yun@arm.com>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>, linux-mm
 <linux-mm@kvack.org>,  bpf <bpf@vger.kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, david@kernel.org,  ryan.roberts@arm.com,
 kevin.brodsky@arm.com, sebastian.osterlund@intel.com,  Dave Hansen
 <dave.hansen@linux.intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Date: Mon, 16 Feb 2026 09:27:56 -0500
In-Reply-To: <CAADnVQKAv+MRNrK=2MmEFKcB0FkmtG2pchdp35xo1ya-ujqVHg@mail.gmail.com>
References: <aY3+Raf8eZqipCd6@e129823.arm.com>
	 <CAADnVQ+D7v+sGFFyTfSxFSEEcnGV111NeSaVtASYHfP-mDnV4w@mail.gmail.com>
	 <aY4Vipl+4rGa+u6D@e129823.arm.com>
	 <CAADnVQ+ad1Eu34hS21HNLgzA5eeFHMvQmoC33xKpP0z247MaHA@mail.gmail.com>
	 <aY74MqGV4A+kwsQM@e129823.arm.com>
	 <CAADnVQKAv+MRNrK=2MmEFKcB0FkmtG2pchdp35xo1ya-ujqVHg@mail.gmail.com>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=mQENBE58FlABCADPM714lRLxGmba4JFjkocqpj1/6/Cx+IXezcS22azZetzCXDpm2MfNElecY3qkFjfnoffQiw5rrOO0/oRSATOh8+2fmJ6el7naRbDuh+i8lVESfdlkoqX57H5R8h/UTIp6gn1mpNlxjQv6QSZbl551zQ1nmkSVRbA5TbEp4br5GZeJ58esmYDCBwxuFTsSsdzbOBNthLcudWpJZHURfMc0ew24By1nldL9F37AktNcCipKpC2U0NtGlJjYPNSVXrCd1izxKmO7te7BLP+7B4DNj1VRnaf8X9+VIApCi/l4Kdx+ZR3aLTqSuNsIMmXUJ3T8JRl+ag7kby/KBp+0OpotABEBAAG0N0phbWVzIEJvdHRvbWxleSA8SmFtZXMuQm90dG9tbGV5QEhhbnNlblBhcnRuZXJzaGlwLmNvbT6JAVgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAhkBFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBIFCS3GUMIACgkQgUrkfCFIVNZKjQf/deRzlXZClKxTC/Ee2yEPqqS7mm/INUA49KdQQ5oIhSxkUBy09J4qjMIo5F8ZFkFTqikBqeL35LKu7O7rn8WETfX8Bxvos3HUsl3jHo34DES4MUFIpoQPgtiLRGwLbK0cVCAArR2u2qj4ABmTRrs1I1kvdjEw6gatOuXtEe/j5O2fvfzTq9GBr0Q3n2IAsFXi4hLlx6VPE8tyWUZ8BWJKtih3JAeUiXFvASL3McV0rV9RnU0VbjEQEhSE7PMYhWpnDC9AyBb0lXJllQRvC3NSkUB8KVQgNNxRPss0WE/nBoZ4dFA42jTyzTz8lNylxZoAWV7WJb3QxVg4oCodRVrxxrQhSmFtZXMgQm90dG9tbGV5IDxqZWpiQGtlcm5lbC5vcmc+iQFVBBMBCAA/AhsDBgsJCAcDAgYVCAIJC
 gsEFgIDA
	QIeAQIXgBYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJpdmQTBQktxlDCAAoJEIFK5HwhSFTWUDYH/0VLi3FXXzg2duSRFBjEv2T+GojyX8UfFDejhGo52YHshpVbUE2loQg3ETn6LJq4UxmMZJYymRbe9BA3kSPS6NtFfnf90ssWgRMf7WYPMj98DOu5UlZpV2WMhvUfKI/gNfkeVW3dR7JNBZTQZv/1nNVFi/AWqf7ToEik8VcoyVuf+8Dlqyfer2xUM8QPV9XcZsu+PRSOdl8z3SH8+M9whspR1qqX7fABGSaOkZr/D3mDS8cr1ATdLbSxu8CMBMfMHbhOKoepTeXgQL/PnmZukrrFlnshJIWa7UVVrYB3qLVaujn8aP+yQqSHE7XXYku0+OWcpMa7fdjGwHKfPJnMeiO0LEphbWVzIEJvdHRvbWxleSA8amVqYkBoYW5zZW5wYXJ0bmVyc2hpcC5jb20+iQFXBBMBCABBAhsDBQsJCAcCAiICBhUKCQgLAgQWAgMBAh4HAheAFiEE1WBuc8i0YnG+rZrfgUrkfCFIVNYFAml2ZBQFCS3GUMIACgkQgUrkfCFIVNbpRAf8DEpytkSbT9Nm8Aifzm3j5TlrRUFZc0V1/U4VmB/lju2lU9ns8o/j1I0ZJ7uYjbZWK3pSRxb6IqZrOZGaERnLjjuJlzGvnk93+qaYGxiI2CMNNepgEBReBRxRnY5vznjmqNjbOWWgYdbb5WyypX/Yn3uVCQ0x00DQLByXEeCLDvK8Cqc+//krDSI44N/YQ0RMcAtVpHLSCXZbJ2igj9rqsJ7W0lcM8FCqyKhxPde9td0sQrKV8FbhzekHQfXpvOwS5KnKNGWE2opnYOh/vlX6z5uMm3AvIcWSib00Y3xgoc4PTOnCVFR2VieWqhtjadFKipYenA+KQ/St6c/F5ymo/LhSBFpntuYTCCqGSM49AwEHAgMEfgawiAvTJCKPlLkhINmaVH
 uoNA9xZT
	ExXHrNU+wCghN2MoWNoOZQBORL6XnOaIKtQFwnowFq8+JhDiSqfj/HBokBswQYAQgAJgIbAhYhBNVgbnPItGJxvq2a34FK5HwhSFTWBQJpdmSfBQkh2rC5AIF2IAQZEwgAHRYhBOdgQNt2yj0XZwj5qudCyUzumKyFBQJaZ7bmAAoJEOdCyUzumKyF2L0BAPI68tg4GTKUGqJOUmsycYIKxaAZnA+kqrd7ezslD/EEAQCXHb2k9jnPREvIgNSyN/2a2RI1Np5pDpMiMOsVr7xcfwkQgUrkfCFIVNbHmQgAk3WhtOC5ajSffgDF25vqZreQJPJS0HCRnHxvfLe2WnJvShmaexY6BFyYtLmamrBRYcefLZSZkgc8nWOdlA7kr94Hj8GMrX5hZQHi6zzN0g3v9B+YTUh1btDbIcuPQWKjKUhD9EGrH0XNhB8nRIeSfwb3mDHyQ1tcd2lso5GUaYPHIgO8VKkNAJHyurxuyTYJjQi2T0i656zCK8I9NBh7gs58BTbHMqBRI5Q4oDLgzXg6o5CUUmZhS7ON2Xb7J+twT6GXG+iRjE+uMa72fiZax5l0upKcYYkOS2q2lSVwgwsGBftya4CPWzMwmCI3NYPFO2XdAOVP9ouvFQSSK1Sm6LhWBFpntyUSCCqGSM49AwEHAgMEx+4y4T48QJs6hiOQPRN6ejtMNtyDEk2A9XtjaVBs0Gd7Ews4Rjr/EnNGLVeb+j2Y7Jn5UiPyHgblX95ZKe02TAMBCAeJATwEGAEIACYCGwwWIQTVYG5zyLRicb6tmt+BSuR8IUhU1gUCaXZkMwUJIdqwDgAKCRCBSuR8IUhU1pfLB/wLszTzsV2JYbCYLOdPF0dGcv+dSx8rLiydrJ/hgv4fcTJgXv45zzNCL/QqHAiKjnxXeSRsFBjyHf3gYXmhbP5eGCW81eZHOUDy7CoSyZRPzIPf1At8IFia3pPZ+xibcIz7JntKFWWw43YdtVghoGZ
 Ixa5PM4v
	ESQBwmRFUv0DF2TFKWHM7amrZAal162kknsH5gKQnFRdX1uLZHw51BzeW+Mzso3xcGi2iby9hcACv1L5TZTQpyD67B+znqj884Vgj4JKdInPQgxJ1yS7aR0ezRHqJYJrjHmzR4aSRFIEnw5azZlH/lsvKCee42fPGoZ956VcVZCagf29mjzDLXxGmuQINBFR2FpkBEACl4X2Bs1IEG51bzF4xAiIH8JnArhU4Q/ucYdmfdSxZ6ay8T2W+NsXNupwiRtSnZXoTEzm3ISDOKjYFq8t7VkkYdVoqQvdwosAGhiL/IEsSeiA8XPNh8rZ92KmbYb4aEtqp8PG0BDtypd6jVMKxktK+MP6QtVXVO8qVodLy1QKHahTJHt9Nu/pYeLkfwMvJHQ+du30T38ZyzWPXUlf4xYnuOx63YVUOwHlTUszvQCOFeIOJAK00nMpqop0x6LzNrNZLnSIwop6jib9p1YGMb/yV3d9Dv8dyPo6mSHzE9oKeaANmi9gZq/DgCba2NGoTobqs9ClLTB7kjqVKwo0E//YWEuYj1+ewGdkLWXU2sBJFJfUErTF/gtgHZbDd9hCZtsCkBQFtZn/VpChzYQIptIr2JbSB9nysOCB8zDyfOmYQQTGXSFTrC0kvKbINX5Aag/HkrBgr/qoBQ0lAidRjPzPYREz8c4jT1m7eOJq4UEO2i5Iitpf/YMO9N/st97X6KEBEVKWnriQQwCyMq600Era7miPgfuFDvMP4G9YsfEyDKw61hi3CCDB46sz+TdGd2xn/PeewaoXSCBy3VUu4fZ7OcOSwj4qRncGDRaKFDIntn2iaBpADJEMVy36Ocmy/YjNr7Ei896L5+lsY0DIW+PR75OxmhAZwLfj+KkbDN7rnVQARAQABiQEfBCgBAgAJBQJVPoFoAh0DAAoJEIFK5HwhSFTWnlAIALumCM4zXsfHCrP2aUYQuKViqPM09Shm3nGyVxMUbGP9BY3O7QryARA9
 4+dzl1N+
	6bNYvTvufGF0pi2irCbYLp86ZeIkFnHqSEF9Gpy1S83YOU4Hp0V/kj7VBP1NEG9x4bPDTUTgaLTGNYoAHo4ggwB2c9wNUXNpcl2UAAl2N+D+XIm0DLGJ9+Ubw2dcnd6XAaqgGyjzhcE1ZbNtzlUqZq3OFgs69e1/MOG7iY0+//PtLUdO1GC4jQ2UflFUHNK9/PJuKf2HKwTf/6vcLQcnbGI4fO5w0CYbTdrO3NlgMxNspBbhtCp4PkwnFPry8Fi7wy3N8h7jWVIulv+qXCrWqDSJASUEGAECAA8FAlR2FpkCGwwFCQDtTgAACgkQgUrkfCFIVNbdiAf8DIkvauUK8auQtxqz3g0P0+afRxSVWs+XvBUZwhX7ojievDq7j1PKo0yaxhqbZimN6u8kaBu8hszOgcUJESLpH1fJSzDnDsYJGhZ6DDZuVliLkDnbF7nTT79Gu4b/8wp861VSi27c367sVxdpgCD2Bth4Y1kJXvS8j5ycWCrQAQlF2OJ3N8JZUo+Np9OjuMd4XFftDbaRR9Y6QzPOGgNsWDSM+FVg2IRek3JcLCKvO8oDtu8XBk+VGRt+KFqJcMTtAohS1DXSLmTDgL2uoMrDHwXQ9pYNEX2AZop3v8gkYclppz85xInfrPGCQ2AuxVfkZSugnYZplxHtb1WmmPkf4LhSBGS5HJMTCCqGSM49AwEHAgME7JKiaexbZKQCle/XNQFoPfx0USPQtB4MQx1ITtubV+et2MBi3R/8K1tRSINo+h1CTap4fM4/rAD/YrquuPA0hYkBPQQYAQgAJwMbIAQWIQTVYG5zyLRicb6tmt+BSuR8IUhU1gUCaXZkiAUJF4lK9QAKCRCBSuR8IUhU1t6CCACFp/Wk55zQu2MQAvzXSexcBczROJSLUiNL8hRejgidulGRb/nvvxgsPQkdKxvxi02LFcU2jeFK5TuuRvebZozJ0LDJsECWJ0CHUoWzN+FZ/j0IG4qPgGSD1
 DIdfwGft
	AHBLpBdnl9SOe8ETkv6GqbZrXUED/dAbRVIT5vHP51zyYB8rAUjp3PnzxsXFG8eQaacEyKSl0DKDlgKuQ+k292LVGJhEva8z4cwg3JcrQWzbpTRskQRP624aQ7t0LKbNfXqfYT13TvZNTDdjQaCJRJ3EG8uXOszVKuc0guXunZPmmq6x1Y3bOfOezcFYoywwL3nKef+Z5sQrjG3/5NLeu+W
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 6CCDBC0008
X-Stat-Signature: cjimk4x55bn66y4gta4kzqw89nk3m1yr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771252079-969291
X-HE-Meta: U2FsdGVkX1/bA4Mt/CHNuKS7/Ntl4o2Nw3skO7UDzapw2ZH7jQ0ga/DEaODseyBsTmK1ofz3ddcFqqbg+ufHDOaS0de3iL9heQrbW9CLe0kA13qAX7Znvlsj+3lLnlpE9MsXwJFCFaUusYE+T3dLDnyamgCmLYSS5bJU7h2VrWcjdUBwRogj+yHqM1kxw15hfkXJPsBo9q2YMNyPnQ0RLTD8E+6ARVKrwZ0oFcWZ49hSdDlbeYx7Xy0nAjaDjWIp5PeqNtwDKmqC19/ZrHlsTvPEKe7fDUUMMsnd0F1xJFhgIzivGy7pG9YT1iD215p2pxirzIQGKDwQlxBKYoaAWlLxUjYOutAPdPdQRqttL9KLB0Z/GUpYKDIqYsBP8cvF3He2ufidd+j5Xg9OPKxsXVhRXlpiStslG3eqxvGcfoL/N1/Jq9O6Fmbf9BflHccnhFehu8FNoN/toI1uZ8cUYFalHinlA4N7DSgcXIJfaCkRKQyoao4Zhvd9KbuK+sRucJxGJ6PvQ6RCd0Y7Mwopc+vBLvBfPe8AC/qUEEFSmN1KM26Qg/wuFgFk3h5qk3F7X0VruWOoRqv8AtXt3y7Kl0iwJWQK3Vywf9w07VEE7cZlgptaih9VZh9vD934Wn5HrhO5gcPfcS3TraatgmaicYlfoDC+akPdKKD+V+ovfOK+HTRCvVmTkzcnzvSO0T8+XvKGY+KcgN7oXMUbIdKwtJyYkXWfItLbUdyv9PG15bDALWRL6aUqE9nvskBWhSyijW+hbztf5Lf4vxvKtEKkVcrm5e/zMK5x89ZYlBgDhV4qC+yaJCHDYtgNoM7vCvbhnUmAfuYnGeLKt40xiClB+PIbDwH/DPfZD+a5u3vvIUXMonPwjHiIutu8bMyXkdcfqdYeW4G1F+7dubtvbiURLiADMOYHIOgNPOuvFP3o6Og+/HMdviQ10D+Dgvuyag5Ukf0M8/Tl7N4leGSbJHs
 M8mqo3WF
 Qss7gcgSvUt0jaIluNZYuvPFrHJHoQKMAeP8AoifZVPKjjuIt+td7DyiiAO1syIw/X7WcuA69TaXyvsnCz5VAWTdVb/OkZrf4ZCotyAnuVFeWv6zC4zVKF0eBBSU9CLqqoLiy1IDPZfZ9QOyHTmwcvsB/TgGx2putGeIpD2QE3fl7OgK+TXs4rV9AbwRKUlIikLLun9A1RQTdv4h7IHQuZz25Wn4vV2FQK5StxAlR0a7FAXcfV9uQO+jnzY4Cjgo2WPbsPOyFnZ5LAf/P06qV5EYrHZnTg2S0EJzzCYFx+ocwNVbhUaLa10EDZyyNRed+a6BAZTbUIfbgxAgCHP3dciAKPgFldCv3Z+oflvKQ5xjSm6h38GDynO2IV7YAD6KaJuyTq/m9P+IUJRqHzZ7dIJyxlrEcucN4rc3fIVlbFjfVoB2OgGj4P2isrfGyXCYIMiQ8B9kA/ugsUDvuPp9aKbYCuenBbKRvycnTJYcKI7AJzU/GLR9DoNq4Miq8HzlDSaVN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-02-13 at 13:37 -0800, Alexei Starovoitov wrote:
> On Fri, Feb 13, 2026 at 2:10=E2=80=AFAM Yeoreum Yun <yeoreum.yun@arm.com>
> wrote:
> >=20
> > Hi Alexei,
> >=20
> > > On Thu, Feb 12, 2026 at 10:03=E2=80=AFAM Yeoreum Yun
> > > <yeoreum.yun@arm.com> wrote:
[...]
> > > > That is correct =E2=80=94 this is a verifier bug.
> > > > However, the concern is that such a bug can lead to a security
> > > > incident. Not only root, but also users with CAP_BPF who are
> > > > allowed to load eBPF programs could potentially trigger
> > > > additional security issues through such bugs.
> > >=20
> > > Again. They are not security issues. cap_bpf is effectively root.
> > > Just like cap_perfmon in tracing space is a root.
> >=20
> > The argument is not about whether the verifier bug is a security
> > issue per se.=C2=A0 The point is that relying solely on privilege
> > boundaries (e.g., root-only loading) does not eliminate the impact
> > of a verifier bug. Therefore, leveraging hardware isolation to
> > further constrain the blast radius is a defense-in-depth measure.
>=20
> I hate the reasoning that bpf somehow needs this hw feature.
> It's not. Look for other use cases for pkey.

That's a bit of a short sighted attitude and also you're looking at it
in the wrong way: hardware, correctly designed, should always be
looking at ways to help software.  eBPF may not "need" this in the same
way qemu doesn't need the VMX accelerations ... it's just more secure
and efficient when they're in use.  After all, if the kernel had said
"no" to VMX in 2006, KVM would never have existed, we'd have been stuck
with Xen paravirt and VMware would be laughing all the way to the bank.
So why not at least discuss whether this could prove useful?  I have my
own doubts about the complexity vs security tradeoffs of protection
keys but if it can actually prove useful, sticking your head in the
sand and ignoring it now would be a disservice to your users (and a
possible gift to Windows or MacOS).

Regards,

James


