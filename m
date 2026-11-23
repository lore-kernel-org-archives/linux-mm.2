Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D802A606A337
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 01:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iyho16XO
Received: by kanga.kvack.org (Postfix)
	id E03086B00EF; Sun, 22 Nov 2026 20:00:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C206B05B0; Sun, 22 Nov 2026 20:00:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7BBF6B05B1; Sun, 22 Nov 2026 20:00:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C5516B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:00:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10ADCA8026
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:00:03 +0000 (UTC)
X-FDA: 85464577086.15.F9EC2D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6C7A6C0003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:00:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyho16XO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795395601;
	b=S/XTVq4zmmlW92ZFoE97chD5+fDeyYaQAdkXbpy6ssYM1Hl29+lQqsybhoho/u1gzc9KUx
	T8N4XZjm//aK/J1hnwLPbGZJD/Ne37ZrqeScjNOlydYN6MyTp9g3/zfzlKi5EX4uQYSoYs
	pACT0BBneBEUxExhqwFdgeySSWGbxXE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795395601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IH6s3imrOjkSSzYR6/sWOdEeFGUNdEc0JcOzWkitMX4=;
	b=ftcf5etNQNbuEi6Txr29iAScXYS8h4fQbYUWNNqayCBLq6CcF81ZKk0EFlhtkGW0AoPk7W
	+mq8etY7CacIQgx06Gk3RHD2rWZ9hbIZsSEZszT2Shkp+3MB4+BasoUodOZ/AVvVfCurlK
	v6XhUkqK2lvPEEY53bEpTJMTO3UnTRI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iyho16XO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 9B3D9439E8;
	Mon, 23 Nov 2026 01:00:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 48E061F000E0;
	Mon, 23 Nov 2026 00:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795395600;
	bh=IH6s3imrOjkSSzYR6/sWOdEeFGUNdEc0JcOzWkitMX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iyho16XOD66JQTO4jubhBZ0x5ppfRmDr3yr5LFUtdo1H0PSKcslH+DafW6vC8Cnkz
	 DPsyD3bvouIDFeYEgKwGdpN/x9aZcvEM35W8B92UZaq+O0Ce9W9F5NdKyNliOOR8gx
	 lAtWhb0jQMl38Fx9T01rCfo4aSLPmXHsFlJD+cX0T/6PozwKbSgIWKunHlXCgqZoo6
	 eTyKYKU7VwfDLK3zD48tZrYgoFjQB95Bh9oATJp4kQjSeGHm1qTq0zgah8HiSlkFSg
	 pfKe4QtlaYIeRD+rXH6/DNBqw1HpWFM/EnHiiQXg0y7lEwCuZlUww7ZIsj542/TaQr
	 XDucFZ57yBeBg==
Date: Mon, 23 Nov 2026 02:59:56 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org,
	containers@lists.linux.dev, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awOQDOel_72Xwjm7@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DN25ST0D5K1J.1NI5236BF2BPY@gmail.com>
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6C7A6C0003
X-Stat-Signature: pw9ssqyw59fi4dspw6mfsb7y8sw3bjbg
X-HE-Tag: 1795395601-737922
X-HE-Meta: U2FsdGVkX1+2FU7gxh9E8ywRpia8WlDKJp3d+eyfiP52zsf1otsLoy9cDLZdUx+fB5mATrknB5x+0H3j1OIbYckip1VW2rGsVi3e+XLB4Hs/5IZNVXrcfnOHosAJ0HXXB2S1/DPOkXB1LBN1heyewKd7iDRuwQ0ADBNHTq5L8H4Zm8buVrh2RxGFgyQp+nfk2QlVTxc+Rx2PvZsZOV54Ze/SjpEWnljKGku4hPfSav09+m5ybYrQPrUHbRpvFTLSzVXZfc0Gj0WxLPW2gK1q2zSohMkQQSmqPdYafKYEYDCPX055Etr9fAVv0a0HFGHel9zwr79N1oyN8ZoOr4abToFPVdKkxZx3IhML6TXGAtdApxHYJTgyNRddW7tcgIlr741G+mdNYVEfpxffxcI6b98sH0YwplkdMl2F/RsBPfWbXcwOzpujJ8UJYEfmVPVedNygQGcdQnmL1P8Qs2IGcW+wl+Gvew7XETSBQG6pKjl+9n6rVWvrYoZ0ojBPtxz5/NF8h7QYSsmpXUzqig2+MiWG9+6E3lyFXJLQHZyHyhdA35Bgfrl4+6I6ODZqrZIVjCpWozMW7ROsKk/3asm+LKia4WgPxyKwQBcXkzE0U0pYwhvJRQU0QSiGK2x+vN75obkjsSYIv+j4Wquio/02ZEsh8BYz1ORTQF++eW5pcoi+fvItFeXSES6VHp83Rh8Enxdvu4Ngg0XkoY99xlaRu6q9rGBt1SwuR2TfzJwS1/FZSBzzBHxBFWgOB43iwNzZ4QWG24rRBVRePZGs5jCDQFv00cN6HI4bGa+1UHReDaB7N8f0tmRiPm4xx8JwSWODFj/a6eyaiwPimdlyUmAEBbxT5pOgR/5w8Z48uG9X7kDnIfSV4blyloJqndJtr+tZgtq/qsLVv6ux9fwoQWtt7Mi67+a0ZKqLoFpJlzyN9GqOY6kWwvl3hkduDQGPggUo4TGbyiKbggpHA1egAOO
 mEIiT4P+
 JBCRr+pSooBL/F7xAjp7JFmJHEIgBTfirgBM21KAGue0ySSAZx/HveC5/YKGITcBBKdNACu0Z7OfBAeMSa+gvfmZuUcPW+/w9+lI1qM1Ssm93kNC5G9yW3EGUeFbum6M5HyKRRSVFU0dgvqEEfAKoVqawXZb74g9I2tS7BdIKPmLM5/BSMSplI9ft/uQEvVHZZsccwTTuWkcUriol/23iPTiJ2kCoDgFcWKoBo3uXAzBaM3YGiyfTLsLH2FpxeGPWvdEGDAnqRheJqMrgWuR4o/K4vtgEtBJBWD5rVP/VhEjHIpXEqBKZXLePR4NCLYblhdxCHCUDfiwxDCBsK4W682YBVIpdddxYmead+Nf/G5Knp3cPQaBTdeSuoz6AtJZHmPOgJ0/LIak41jqbapg125MCc3cf8tGx3wryRimj5jkJ1RPNFsgtZCvjSdeeiwrNK//Bw9H29BpyTQFiCiNBCxdk1sOWI7yg/7GbqcWjlRH9O7508IG2a87Ov3WvpiJ51OWby31Jg5r41AbtHjUH2jfhxxoSABCZIi9l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 12:21:16AM +0000, Alexei Starovoitov wrote:
> On Sun, Nov 22, 2026 at 11:35 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> > v6: https://lore.kernel.org/linux-fsdevel/20261122011809.2667684-1-jarkko@kernel.org/
> 
> v7 was sent 18 hours after v6. v6 got replies from the bots only.
> v1 was +2559 lines. v7 is +5782.
> All six findings of sashiko on v6 are still in v7.
> None of the seven versions got a reply from the vfs or LSM maintainers.

Apologies, I started testing this with bare metal as a result of
hotplug, and things just started to roll out as I got a better touch on
its use as a result.  The growth is by majority in kselftest. The
feature has not really grown but API has shrunk along the way. Still,
demonstrating that full detachment from syscall API is important,
because it sets a bar for any approach trying to do this.

I had no idea that e.g., that  quality would be even possible but
one thing led to another this went a bit out of hands.

I also wanted this to as good form as possible before going on
holiday, which I'll be starting tomorrow but this was not a
motivative reason.

So yeah, again, apologies.

> 
> The way you're spamming people you're only reducing chances of anything going in.

I personally think that "getting in" should not be a goal in the first
place. I care more about that whaever gets in has a high bar of
quality enough. It can be something different than this but
when I read the LWN article about Cells I was alarmed enough
so that I had to do this and prove my point.

Br, Jarkko

