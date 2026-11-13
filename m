Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82A260A2600
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=fjs2nbqX
Received: by kanga.kvack.org (Postfix)
	id BC2D16B069C; Fri, 13 Nov 2026 05:17:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73DB6B069D; Fri, 13 Nov 2026 05:17:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89E76B069E; Fri, 13 Nov 2026 05:17:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 862F76B069C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:17:55 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19C6240282
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:17:55 +0000 (UTC)
X-FDA: 85429694910.24.C762003
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2F125C0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:17:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=fjs2nbqX;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of alex@amutable.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794565073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
	b=J6yxNmUPRx/vyDBCXy3vFDy6KeUFGbAh/fSRdnBZaoDrCUBJXBkDuYMu9DQGp9EMa29xB6
	LTBlVUU+sEX8glYgwqxJs+WT73+I0Rfu3/Dp9QG33Kgcqagd4FoZImoBJxYJ3WGDvSwlyr
	I5E8FJPwgh58g/d3Y9wGgKaIV3vjBQM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=fjs2nbqX;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of alex@amutable.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794565073;
	b=25KpIAUX4k3ulPt1kdkqww8S7HQF9GrOCW3Tqj7+hZPBVYukPQNun3yb6zb3VpLSlYNb5W
	1JNTeWLTKtXOyq4mvnJS3PRW2iEr3BACQKOlhDkwQDkHBe6FxMXPpJO7eqqqKJBU1fZZrZ
	GJZFny/PhzF5/vKtYuxzkcOI9iVyBKQ=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso10701195e9.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794565072; x=1795169872; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=fjs2nbqXJbWwsSBLdj6G7rOOPz90yEuerAXEDjFpeubcy9BZF8Q0WlTLWRvBz1WLvi
         L/PH8zugbeeuyLcVdMmQh5HPccIf5JpnYKYkpJdFB8u5np58b0MY7b0851blQR/OVpzM
         u0MdoubEIAHEk8GpN95tWLvl4QksrgMdrPL3WlVU3mPHXaU1SmKmQ0An6DXHBz15KH4i
         Lo7dmfZ2jpzaSniS33itrNDjJ7T08TbHRhobPLaPnkbdEQuwn9wwXy9ePKhwSIg29sbH
         tQT0o1mgtYHlSb3/tIBhvMV309ePKnVauxrmkhh58P6gqu6zOclHGYJcFB7KjW3dtoZQ
         qy4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794565072; x=1795169872;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zqPqkCGOaO5RL/5NE1UeXRxAO7AqEHmUDDsiHSGxDsA=;
        b=RRRjqjPpn5uffPakeAEP2uBBUQoGA6Q4/wSMb6iCZIs3MCzCI6MTQqV3X0J8sdto4o
         lvZ9RXmh7okhdwNinGggLhot51LbsVgbLbFb5QcKLPGM4X5WZiAYxml7p4VaamK5ZZ8I
         0tw4S2prCVIbo2CrXV7IA7FxDCZLsFdYsaKBfXc4cX8wrDlPDrnMzD+8ovyzV8v0HyCj
         27N7w43SctN7ZS7nywQGloI0xSwpWB1x4iszX6iiSnZwq7KgB3XPIlDj2o3BEXoN08nY
         wW4wO2MeLHPEu7uGH13C/EwUszj93JrDNDkF1/fhiAAD+zQJOhldhL7Ztsd5PVqmSP+J
         GaDg==
X-Forwarded-Encrypted: i=1; AL+hErGwRWSmAv5/fzfmWDvrhJPngD32ym6GHB3W8JZc2dwrz9OOf8cEzOHrlkuRa8m+nxpqMkjkhvQDYA==@kvack.org
X-Gm-Message-State: APuU4Z9NsDtpFu7pbp+lA1Q3f0Bdp6N7EW7EGRGQQFqjPX0euPntRF1m
	eWHSC6/06GoUQ85Jov6r4VjYcBmm4t0VMsDZSI7mFoQIn8VPlWunjNE/J8XFl4EElH1l
X-Gm-Gg: AYBFou1arbpQ6ll+dujHO4+i7Y2+oNei4pPmrXBq+1jm3J/AtcgPi45tznnbOYisfaw
	2JnUJKqM0ZKn+0lw+vSBNNHjU7cakM6bsX/lYQ8ZqEU8ZEtrK2t2nR4oZ3msMEZoleSEG4uxomF
	PUn6AIc223SwzCIu4lRPQI9MdnZIAAh0/ySVFromCExfTekiNHUEK2swx/MTMhO+cNfUe0VXwAd
	V1OJVXjSamBUeAWT3K0iZwa5IqYxWACY1MWPrtiVsRDzVqL40/IQR2XDAkLAXbO3Vx8DHP94Knj
	QafF/zw7Zq7N5fXcbdaZIYEYqstUiPhNP4sGTsuacHtG1ezdwKLrLW5j/otOt5GfvaM3Df4TNfm
	cbzFZmhj5ph/UTWz0HM6CuSZ+hJjgBbt+CI9jTY4UvNEMEu0zFrKDViIGwqwnMkfd8RsELVE9lO
	N05d+pkZVAlpOICDHWaGSucjYuEHOCcdaDz+xegNiAeZ5GunaMid14myFryIxhwj4gRZIKHyEK+
	RrmPRJAOIzENQyyx4rLAWQcJmVmgNOdTUHtgQjKTs24ihvhI6ueBABXGY9gkARNGMa3bw6nWniT
	RWW++JYtQ8HVeP2c6ms0SZTrQobtU2MMA0Gw4GK6WbZ6AgTsGaTudxA0E14Tj9w=
X-Received: by 2002:a05:600c:45d4:b0:4a0:23f:8b0d with SMTP id 5b1f17b1804b1-4bb559f6f31mr43851425e9.2.1794565071804;
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c7da37b19sm3937770f8f.5.2026.11.13.02.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:17:51 -0800 (PST)
Message-ID: <7cde6f3091f9d90593e4a6441723b6b889cc4024.camel@amutable.com>
Subject: Re: [PATCH RFC 35/41] zloop: refuse zone files on pseudo filesystems
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, Josef
 Bacik	 <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, 	driver-core@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
	apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org,
 netdev@vger.kernel.org, 	fuse-devel@lists.linux.dev,
 linux-efi@vger.kernel.org, 	xen-devel@lists.xenproject.org,
 ocfs2-devel@lists.linux.dev, 	linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, 	linux-usb@vger.kernel.org, Amir Goldstein
 <amir73il@gmail.com>, 	linux-erofs@lists.ozlabs.org,
 linux-kselftest@vger.kernel.org
Date: Fri, 13 Nov 2026 11:17:48 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-35-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2F125C0003
X-Stat-Signature: ooseymehy1ia14o7x1r6a3cue1ncsqs9
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794565073-756913
X-HE-Meta: U2FsdGVkX18soh+O0Ly+SOEFEvJ8w0G9/TVcABBNjdMDk7m5kv9V/s4CENjW1wsaonfslLVFm8TMw1lxfXj3z+ZaoUEgM7+UFw+m/R8zFabesjdTbXHK/+rUQC9IfsaJlr7LwV+JDVHQdegrzOU1IzcBLfAYzB9UbFp73Q9v/JCdSUTk6LshyUwx2hCaJnx7p6HMMFbu9Y7P0cv8+lI8s5c7WUCmhR3RFivYZkk3e6iHH++9c/auOcx/Fszr8oLeaCQkzzx+3JHZ7Hb6Tb9vC0+yAC/NzzUWycBnkM748Iq+W/elk3bep/aPaaOUETBt8mzgVLkJO3uHIcK3MeRKfaY3kWeJAT/8gTHwWqu65VWHymYrhuWqVr7y9TNC+nb9py+3Hd6RImp4K+6WHZOWnTWKxIW7BsgYFu28NTw4Xb3OU3xs3zmeDRlLFEfvUstFHix6AaDXFh2TzKw24qUl/DV25n5oPhFkgMOeVApNapA7Jyl8uvbNkntX/DzS976yrwgO5nSPEg/1+Hn4X9RUTcRvTf2fSBDd1LEsNQ2BOInnz72FJYaaDkZBVSaKY8QLJnu0wOo6KPPswuaysStDW+m9Tn2brS+nU6du1pJTpX99kZTDeMYsvELHQM/IvDar32YHR5Sskbe8W1t0TJaOwFp7hE2jZLhtwhAnCOJc9QgPglpsjG/L8cd1wZNRVu9Xb2JwUWa9GM5n69GoRo/UHvhE5IR9U163A+gTSRbAyKw2Sf76kUKr1dSOdsUWQlbQ87umujSE4p8Ow2JjDlZxU9RcojGXtfbBesx9uVlU6cP2g2hZ9MbaytePVsAw3IuCkeh+e7uETaIoBZpwptnJr9FFcmx0agCjx+QRxMuBPFlptSJfRcdzZUF3vAqkQA32OmExFTvpvLoJjJeOEBslwvIYqj6olbwKJBfpGi/CvoMp/mlOVjqDkaaZpMwhew6TKsiYAfK03uFCO0iqgM9
 BtTJqQ3z
 fzJEo2Btb5sfL+YClDFRKN2ooVy/XROCsfyMdQqW1gzpwjZwwicvAlaL0EyZbov/0aBViUkKHzpCdefpy+zJdPCpuEuRS/edBQYnfoegafxM0l9g2HUuGRsVCERCpPkDU1KOyJzP9pO2+V2EVFfxT6mUxdVi6MrEG6J2GlgW3xWTw1+2vXKhKLtp4WgSo3nN8S216QEW7rvUE1uc41oZ+Rm9aC21Ewqrg/2Q3iu8swxBf0ZDn2UdpcM0QTJMgMVYuOFZvzKAlyWgTMVzzjxcIy8h08wp5fZ2lXT25JXJDadecj5+STkZlFjAJAyk8P13U6AGvz393XNLXyIAUw/IvgXtGww5XDpLUHDro1yBl1W3S+d6FrGSssP5pndDU6F1uabrSMytzwClk1c9QZF8xryiUKGbRAmyDUauDXJTIECNgLieFZNrXxX62znL5qN6TeMqz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> zloop opens its zone files by name below the base directory but a
> bind
> mount can put any file there, including a procfs or sysfs file.
> Refuse
> files on pseudo filesystems as zone files just like loop does.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/zloop.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
> index 65634a39b0bf..dcc06dd47b04 100644
> --- a/drivers/block/zloop.c
> +++ b/drivers/block/zloop.c
> @@ -1137,6 +1137,11 @@ static int zloop_init_zone(struct zloop_device
> *zlo, struct zloop_options *opts,
> =C2=A0		goto out_fput;
> =C2=A0	}
> =C2=A0
> +	if (file_is_pseudo(zone->file)) {
> +		ret =3D -EINVAL;
> +		goto out_fput;
> +	}
> +
> =C2=A0	if (zlo->block_size) {
> =C2=A0		ret =3D zloop_get_block_size(zlo, zone);
> =C2=A0		if (ret)

