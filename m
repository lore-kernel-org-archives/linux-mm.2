Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3929E9B258
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 13:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083056B0088; Tue, 24 Feb 2026 08:37:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030556B0089; Tue, 24 Feb 2026 08:37:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7EDD6B008A; Tue, 24 Feb 2026 08:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF9F66B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:37:36 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5FB5EB3C13
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:37:36 +0000 (UTC)
X-FDA: 84479452512.27.A4DB389
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3D9A4C0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 13:37:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=hansenpartnership.com header.s=20151216 header.b=NGlk9KXQ;
	dmarc=pass (policy=quarantine) header.from=hansenpartnership.com;
	spf=pass (imf22.hostedemail.com: domain of James.Bottomley@HansenPartnership.com designates 198.37.111.173 as permitted sender) smtp.mailfrom=James.Bottomley@HansenPartnership.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771940254; a=rsa-sha256;
	cv=none;
	b=M5cWOtBinS+MM7yVLlU4htdOLoeIU+q7ZgvpzdEDlmKmAZb9T2UAiaJMnY4EdtyA9AxqjY
	5YUsGzwl/LgQtG/ZZDCvUDL011wYl8GCMRd4DzphxBU5YzXR0sQG4QdCPSu4BPkz2El/D7
	o0mrBPpc/WZcmjj4uomUTrRxY0eihVs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=hansenpartnership.com header.s=20151216 header.b=NGlk9KXQ;
	dmarc=pass (policy=quarantine) header.from=hansenpartnership.com;
	spf=pass (imf22.hostedemail.com: domain of James.Bottomley@HansenPartnership.com designates 198.37.111.173 as permitted sender) smtp.mailfrom=James.Bottomley@HansenPartnership.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771940254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0L3OiG/Bshj5QulCb3i7BYzyJry8ZHoOhbOX2vPl4Y=;
	b=a5l7VjnCTGT/Zool8TkWxwjc7iv6nP6nx76O1CeqM4FVVpxuluTiEnxuHfvJfd5zJULUBJ
	2DZy7Kgzfi7NjLfvkW5hbwSfw6mBnMYVo1SnsO8FgBgGYKE5N3qVYmYgKPtFyrbYs5F6jG
	+VuqOCU/K9T2kHiZZR7FDD6jdogX1V8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1771940252;
	bh=N+y9fema4fxMIXCGy9yuAezozfWEywSX0IbLhPWbQXk=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=NGlk9KXQNPaoBvbjaF6D5At679PxdxNFUxH7x9mNGOShwMMH8lmGNd1cOx20OC7Ob
	 08ABzVn8Fb4pPl+yaBi6SgsLuCcJgcK0O6QQz9O7BTly4IE47dMUasgXnBXxa1jIUJ
	 IjUSIe2pGLbSTOuEkRPpsvBUMgk2icZB57FiKIrk=
Received: from [IPv6:2601:5c4:4300:d341::a774] (unknown [IPv6:2601:5c4:4300:d341::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 8BB401C033A;
	Tue, 24 Feb 2026 08:37:32 -0500 (EST)
Message-ID: <72f731b8153106fd32ee991da10f847a3a8d768a.camel@HansenPartnership.com>
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
  linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
 bpf@vger.kernel.org,  lwn@lwn.net
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Feb 2026 08:37:31 -0500
In-Reply-To: <20260224-sangen-aufatmen-06ba16719f33@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
	 <20260119-bagger-desaster-e11c27458c49@brauner>
	 <20260129-beidseitig-unwohl-9ae543e9f9f5@brauner>
	 <20260216-ruhelosigkeit-umlegen-548e2a107686@brauner>
	 <20260224-sangen-aufatmen-06ba16719f33@brauner>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3D9A4C0005
X-Stat-Signature: egt6djciur7zzm3jn9ixz4q5d86sejbx
X-HE-Tag: 1771940254-10327
X-HE-Meta: U2FsdGVkX1/bjNO2VLfl48lRi4dk4IhvfFW1bvdVXItEqCXEfLYNBEwEgMIhwOev1oEp8z3Yby1Xev0JASypGSkhg9AY6Kd1uGUd7yYEpOE2XQF0a7yT6Em9K53dhAIXvvWG7zNAmcCB9KmQy0Uxwk9wT0SouIvGD2wcm+u+e2qirswan9P+4DG5QoQdUkt8fGvbYtzfI3mhYJbouKig/x7FcJG1PHgY6tVew9hpXJtKUtfe0Pkgc+/yNE0zakWZmuztvnLW/7bt8ENzVA1Gn+I24B0jaCN9B355XoScRrPIlRlIu3i0+smVFyZtapL5UFCQx1iTxkIFOUFWf8vemUZDd//hjsCMdOE0ho+ZN7jxDOlFHHCimlhF5sHU+ylFHk73zzJo1Fn1slmat1h50HYxcTv1kHa9ZtTrUPPB2sK3Aojd6Kzc4EDhK8UvrZIzeqJuqEDSXlOXGLfZAc8iUinJPr7UZhaydyEmgQJ46+6ihMrpw2njdHMaxKNCTnxIZvdpMg/l05kf1XxvxwQQterQn0kHJALu0X7mDp8H3DDXZBEyYWROG6UNRUv43PzzOpz1gmurM4mZ7gp5Q7JZYNAN4sWg0L9kZDf9czSY1scomIK4EncyO2kIpmMhYDuJTyFZyrNp9tWqoYRvK+3QJAwqv+41wW0Qr0Cdg4qDPY+E9ZeqLyoqLBIbuTCdRj35SxW2C53JJ0t2hAm+4tQSnyk8vwu4YXHGymR9LzpIR/Tx9qN0X4k3kVW2ItUOf9zsVtImW7WGO0IMMxq0171bXzf67JIlAvlfIeh6VR7GEUOl2An6ScFuWPvu5J8PWknVFc2+Jf/I/Q5eu0qIh53o+VF7sDoW99eqQtE53sRWnGc1uZI/b6Cn0CHWqA1OWqGcXamoGWPkN5pBhciORMu7oNynOwP6/oNMnnQiTlFEaDTgkjiBKn2mR+lVxIbsisq6FyIyZR0hSUJZQAYOOjf
 NJv2DMRR
 NTqr0edmG/3kqfXxuUfj0WDxYebAnSCf7nhQaZWJKrz3q/wYMm0VbLme3hPKiU7M+tASccPCaNPbEXpT3s7IZY0CKWnivxZn+Y7TPx3B3pVV34AR8v5l30v+HjVZU+ggbxffhE6K38UwlSxK53NPlT7+6SmoB3BWtpuxJoluoFzio0e4FqSf/FrTWAz1HC5Ce0acc3N1sSnDyPfoeewseKO8zmkzUIUmEESIPYDpXPLNxHLcPdQJhi4+NbOnHmj+xIOYP3J0I4l/Aj0x9yooXmt2RX+oOHcNspjxfmwoCJ66w/232o4EiXKj+QOCmUeB3X4v07bbjPxRgQ33+taIi/nivaBdEdrGB6JMWUqhsOhn7Tnh9VFdlALWwlTB8CI76IF1smy8aO3jrm/GFfai3RoJ7Bnh5/N9L9ZKS9e65aSPhWd7ThzZ1m7tFi/wbEsUl6u+4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-02-24 at 10:53 +0100, Christian Brauner wrote:
> > Don't forget to pester^wask^wremind your respective organizations
> > to sponsor LSF/MM/BPF 2026! If it helps, you can tell them that
> > we're considering renaming it LSF/MM/BPF/AI.
>=20
> I have just looked at the sponsorship site for LSF/MM/BPF/AI again
> and we all really need to go out and go steal some of that AI funding
> money and funnel it into one of the conferences that really drives
> development of the operating system that drives the compute for all
> of this.
>=20
> Please go and remind your organizations to sponsor. They should know
> how to get in touch with the Linux Foundation. Just going by the
> sponsorship page we're missing a bunch of large organizations that we
> would appreciate if they decided to pitch in. :)

Just on this point, at least for Linux Plumbers Conference, we've found
that increasingly OSPOs (which usually hold the LF contacts) are
aligned with Marketing organizations and don't see as much value in
sponsoring pure engineering events (like LSF and LPC).  We've thus
started getting our money from the Engineering organizations themselves
(where you are all better placed to wield influence).  To convince your
engineering management chain (who may never have done this before) you
need to articulate the value (it's the place where Linux features
you're working on get presented, discussed and decided so a good
showing by your engineers can drastically shorten the time to
acceptance of something, or actually set direction better than a
mailing list discussion, which provides more roadmap certainty for VPs)
and provide the details, so the sponsor prospectus is here:

http://events.linuxfoundation.org/sponsor-lsfmm-bp-f26

You have to go high enough in your organization to find someone with an
actual budget, which can be a bit daunting, so if you need outside
help, the PC (lsf-pc@lists.linuxfoundation.org) will be able to help
articulate the value once you've found the person to convince.

If you manage to convince them to sponsor, the address to request a
contract and a PO is

sponsorships@linuxfoundation.org

Regards,

James


