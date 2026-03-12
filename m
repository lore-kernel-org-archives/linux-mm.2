Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3ABD1067043
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 15:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC2C6B0005; Thu, 12 Mar 2026 11:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84956B0089; Thu, 12 Mar 2026 11:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAD586B008A; Thu, 12 Mar 2026 11:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C6CE56B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:32:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 819411B750B
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:32:43 +0000 (UTC)
X-FDA: 84537803406.02.863E28A
Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5F3B720004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:32:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=hansenpartnership.com header.s=20151216 header.b=pcvJZxMl;
	spf=pass (imf03.hostedemail.com: domain of James.Bottomley@HansenPartnership.com designates 198.37.111.173 as permitted sender) smtp.mailfrom=James.Bottomley@HansenPartnership.com;
	dmarc=pass (policy=quarantine) header.from=hansenpartnership.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773329561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eQe65zRbvRfUUTjQaiTy4y7ybT8nkDdQuy9ftpxsxQ=;
	b=GacKq0iDSfD6i45D8R0rVUw+WNCJd7HzfSdxm6ivOu7Tgx/RgInmIn2qkzi4G4vTRIbSuQ
	eNji7VBHiCk3bE2Mra1hd4hKXWm6ztUs2eCkdhoCaEImaleJzlJhg6F2Vthu8ndOq2Flgy
	LRgVK1cfXUUkHZLgewAdZCkXQ63Bq4s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=hansenpartnership.com header.s=20151216 header.b=pcvJZxMl;
	spf=pass (imf03.hostedemail.com: domain of James.Bottomley@HansenPartnership.com designates 198.37.111.173 as permitted sender) smtp.mailfrom=James.Bottomley@HansenPartnership.com;
	dmarc=pass (policy=quarantine) header.from=hansenpartnership.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773329561; a=rsa-sha256;
	cv=none;
	b=xPJz66lyVcwHUOcyIyHqxP73raoEc9AJJgBd3md58ux5CfM5gWkWhpcKM/wmY947Rg9gAi
	sUVOHM4Rey45+CJDXmTTB9ySE2da7jJVxUlRXCXxwLYz1DDPEFWylmedjCgyAqkhX9MY4e
	R2ICiYob1mf864b5kLhYU/MqlsSSz9Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1773329560;
	bh=zTDNMMg/o0AbpOakTawLJV8HRHueJx9lUWpbuHSD3BU=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=pcvJZxMlUnyDHCQWdoy7oBw4t3ApqjoLShbfu4EGfeRRF/0XvwrUC3nRWEDXXVQdM
	 hMwbriKe/NL1VZ4m3mEc/Q/oxiEwEcX/NNUV+xlSHstrQ2AykR2/lPVz8ssLEFKVvD
	 cNP4AXmMocQMY4pE83K1rY1dx5NyhQ9bJbZtUZWw=
Received: from [IPv6:2601:5c4:4300:d341::a774] (unknown [IPv6:2601:5c4:4300:d341::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 599341C02A4;
	Thu, 12 Mar 2026 11:32:38 -0400 (EDT)
Message-ID: <f5688b895eaebabae6545a0d9baf8f1404e8454e.camel@HansenPartnership.com>
Subject: Re: [PATCH 00/61] treewide: Use IS_ERR_OR_NULL over manual NULL
 check - refactor
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org, 
 apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org,
  cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
  gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev,
 kvm@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
 linux-block@vger.kernel.org,  linux-bluetooth@vger.kernel.org,
 linux-btrfs@vger.kernel.org,  linux-cifs@vger.kernel.org,
 linux-clk@vger.kernel.org,  linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
 linux-gpio@vger.kernel.org,  linux-hyperv@vger.kernel.org,
 linux-input@vger.kernel.org,  linux-kernel@vger.kernel.org,
 linux-leds@vger.kernel.org,  linux-media@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev,  samba-technical@lists.samba.org,
 sched-ext@lists.linux.dev,  target-devel@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net,  v9fs@lists.linux.dev
Date: Thu, 12 Mar 2026 11:32:37 -0400
In-Reply-To: <20260312125730.GI1469476@ziepe.ca>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
	 <abBlpGKO842B3yl9@google.com> <20260312125730.GI1469476@ziepe.ca>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F3B720004
X-Stat-Signature: pnwi1daaxjdqxkmbusbmyu8srutah7wo
X-Rspam-User: 
X-HE-Tag: 1773329561-967825
X-HE-Meta: U2FsdGVkX19PQvP2eZzRx4eugO0JQoNeleCyaIxfXU50vLeZYTxVsxO8p3FW53H2GF7NWC+WysTmFRFiZ8hRBE+SVP0UlXurii7ewwWr1q4dbMleNf68uaJfJTfDT1in5cmDKmGQeAGIfNfhNnTuZqHiiyPmPAqJ7/X44JiaXE/O3ldUWJ0gkiudsBYfroezj5EdTvxzRY+JTD4Mw6JHDnyzsDiIuu/sD950+7229+AwZgw26Oc2ESmGz2YgGkFGRQ3tr1LhAq/8/o72cfuA5tVvDMAp1BRwQLloKq6RAcnza4HbfXo9UaTxN1tbXmI8MjsSOV+8yk3lOmUaNQ02YVCP4NoMed7+QFO0TMHp5RFhfaUEEU4ZW4YqCVH7uryVn+aFKLsA8BPpVGbqJhrbEfy1Exiu4FD0FaS+HTyCcy1ORE6BB9NL1vbCBzNpqDnrZEl7S7ggOG4K0iv/Ar3jocM986d/UKtCE8fIhhBrhkd8senpWPKqSuJNfzPdmRx9tRUHytp8FTq0RCYtNp7J83cGf/DtN7XxHH7cAdbVcWS0bOpdVdBNxY2mVhGbL6VyezLwYAljTa/ZkhRurgZIJPmqS7rKzZlst3Bn/qMjPWaCO8VhAwoFJKIX4tmC/1oRiVmr8t5sjDIhD/ORuEIJ2OxS15PRg7Vk3FyI77153FSCDtdr5qB/Z9Kj5ipMjBcWMTGmOu+He7sd/yTvAiQVZEeJLgxkQkQ+2BaG/A8CBlqW1ZhwovkZCiNeJaYT0v2oDpooqJycFLxKIqgbjQz2V85g7Er8XYqauQb9J6uXMHVvRBHG+PXC8qcqGu5kJ1Dgz97E9klUEUb/jEC14UV5kx/1q2TWa0GKYpEqgsTLm3RVSofbYL7nx2MCt6R2gPNAaEBJt777WvyqxflS2N26yhL/QbHhzQu7TwT/raGW/rXPLHIlMXSmV195eh4tQipq1bD+lXDtmVUGf6Bi34/
 uwWIgDT8
 6KH0shMPjaq6TxhzZuiYkL/New1mI03/7kdDNXmmMlqT+UlbdR3PehjAiwtZt2BrzVmvOql6iMofvZXXaKrdQwn+OsWQfnTrCqou6R7wZkcCrqFEeL5008qT1ny9c1ncu0zwhdigWJRTF/Jql7QHqAlC4ZsdOqOLprIrGHLri1vNgn59Ptv+KVjFPiNlGkaDj/DRh1YDoBjBrWhLHlM5aKP9Z3899JBimNx4oDCVcww8fWAPruzn0i7EJn/OjPdBUDeGT35heduVi2y3HPmAEhUWu4PN2JDk3a9Xda+ER1bcLfz8w24dv2fFx3jdbV67m1WkPn14ojqYl+bjcCyW7mEJW7LhHByZEQEZojqmJDMVQLZ9hTg7pCpNwZVfNF6mc0MA+fNIvi5dqWSAb/Sj7PnZC/RZLjXFWcYZjRjLFFHo06iljXGsVHVWZ0t33sPvfDP2N042+bTAQXt1hIabdP5fdlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-03-12 at 09:57 -0300, Jason Gunthorpe wrote:
> On Wed, Mar 11, 2026 at 02:40:36AM +0800, Kuan-Wei Chiu wrote:
>=20
> > IMHO, the necessity of IS_ERR_OR_NULL() often highlights a
> > confusing or flawed API design. It usually implies that the caller
> > is unsure whether a failure results in an error pointer or a NULL
> > pointer.=20
>=20
> +1
>=20
> IS_ERR_OR_NULL() should always be looked on with suspicion. Very
> little should be returning some tri-state 'ERR' 'NULL' 'SUCCESS'
> pointer. What does the middle condition even mean? IS_ERR_OR_NULL()
> implies ERR and NULL are semanticly the same, so fix the things to
> always use ERR.

Not in any way supporting the original patch.  However, the pattern
ERR, NULL, PTR is used extensively in the dentry code of filesystems.=20
See the try_lookup..() set of functions in fs/namei.c

The meaning is

PTR - I found it
NULL - It definitely doesn't exist
ERR - something went wrong during the lookup.

So I don't think you can blanket say this pattern is wrong.

Regards,

James


