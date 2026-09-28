Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF061C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 07:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0315A6B0088; Mon, 28 Sep 2026 03:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F245A6B008A; Mon, 28 Sep 2026 03:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A1F6B008C; Mon, 28 Sep 2026 03:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA7AD6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:45:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B016C0111
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:45:00 +0000 (UTC)
X-FDA: 85262384760.25.C0D9983
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf03.hostedemail.com (Postfix) with ESMTP id 63DC720002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:44:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=kLJCbcN+;
	spf=pass (imf03.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790581498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9GuvQ9AZTHwGr6CKXhX5QxhIaXr7oa97M52F15fiUE=;
	b=ZPnWbKwgr71P3y7wtuzrGfGIRTzvx00jM+Hgph0sYwexoINIcN+kuQw6WHBYxz62swuYSd
	DDUAqR63ClFX6A6G56RLVCvxpcvHULanG0+y68i+pgBRMe06EJ1PtpG9NBA8wOYyv7/fgi
	wflGLh/Ew2eOR/ZVlz/jl9AnS1QZVzI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b=kLJCbcN+;
	spf=pass (imf03.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790581498;
	b=Va1ijVNZ5KZ3ivs3QOzzlypEoK+VdX02xcd1LPW7Byu7uWWURE2Y1abSp1agd2KD1J9J/p
	ZfMY8UEmslj8cHdVZUo8AxX3sWkrK3K9hjWkOEgfwxPZvLRX5Oxgdg36kwB6IwzuZnUX21
	sNLxZSkJ75rl8D+QtC0APKtpMtSmELQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=f9GuvQ9AZTHwGr6CKXhX5QxhIaXr7oa97M52F15fiUE=;
	t=1790581497; x=1791791097; b=kLJCbcN+Zmh4gLgkSUuLtAxhL/76PZm5LEIMMpR4Ia+xDnJ
	4ZWVpC8KNjgz5i/snqWNTxIIla/guWlpVOvZHuFncErHcMvM0zF1dmEVHteR+wHoC2QGwtX2LlxK2
	a44wnubCU7CHeUntWJCvqxkQDmHzYCZxQI9+fbFX4iM12vJbOiWOpqFZCfUYDXScGH+PmYce/JCJB
	6OcxT9NpnydVO0jtbNPq3A4DBQY+M2AcOXUATlnlJll2j6xSQCKZJXRenU1H6LDeVFQKiXkpYzRaC
	nyWGckhG3imdMsHEko/FbcA7thsVTl97JGEkFC9LwrtI1xG0L2CPArJi4vUjZg/Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xB62d-0000000DL9B-0Xwl;
	Mon, 28 Sep 2026 09:44:51 +0200
Message-ID: <04259a99ed91f8a527b255951a6f626310728170.camel@sipsolutions.net>
Subject: Re: [PATCH v3 2/3] selftests: run tests on nommu architecture
From: Johannes Berg <johannes@sipsolutions.net>
To: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org,
 liam@infradead.org, 	rbm@suse.com, akpm@linux-foundation.org,
 luto@amacapital.net, 	brendan.jackman@linux.dev, david@kernel.org,
 liuhangbin@gmail.com, corbet@lwn.net, 	kees@kernel.org, ljs@kernel.org,
 broonie@kernel.org, mhocko@suse.com, 	rppt@kernel.org, shuah@kernel.org,
 surenb@google.com, vbabka@kernel.org, 	wad@chromium.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-um@lists.infradead.org
Cc: geert@linux-m68k.org, daniel@thingy.jp
Date: Mon, 28 Sep 2026 09:44:49 +0200
In-Reply-To: <20260926010819.604346-3-thehajime@gmail.com>
References: <20260926010819.604346-1-thehajime@gmail.com>
	 <20260926010819.604346-3-thehajime@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Stat-Signature: h4ezkszsrzjq5ei59yaud88kpedug596
X-Rspamd-Queue-Id: 63DC720002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790581498-988296
X-HE-Meta: U2FsdGVkX1+e1IJvSEIHm2HTJpkS2FCqCPTDf94wB0qs69krP0e+ylceIy4inyHwDvXcFXMD/sbQ98DpCuH3LD9HD79wdDZy8bj5yB/CP745wiwhlLp7LOnQ8vw6qSfI/OBPThIn/yov6K/DryY2qLoGL3BHsCakBakv4We0bN9p1DBau+INou0xoj+KFdKBAV9bqvKm4CvVaInfFG7Ti0zNUaq92pDJQo/o2Bicp6BlLCDLklOo8nsMd8PX64qFzL/CQx6BmUYkGQs8CtTWbaP33jiR/ECd7EWK7QG6SJX3lPBIRR6nLpueUsueqQBpz7pnRY9V6961Xk/jVOr7B4GsuENZVRSiStE/fjni+S3S0yAzG7xxct4LD9nN68zxFNGEKOcesqamxf0G1TAaEhBjFkZ0xq/hscJvXhNjvBQmnaPwqztmZpRZ0SFRuwIuuYLZzeauy3IV+3GPIIzl3VvNFTSXDqkQ6v/vfQHSzXcVqH9WhYdWZCKvwOZElxTchBe4XVh28rYLKMYjp01NqPAtNRlfLiQWrs9nWgEsMtfetafecyakx4TfMfmuV5jC3JMCLpNTKV05Ywhc6Xmzwb68MXcOeUTMMUBl8ESwMByXYCbFp02jHl8+Sp8jnOPnfipv8wkabehVPdiO6uFZ8ZjzxedL10Enx2Bt4AUmTF8do1ndEUupHp3H/awxRAjvM1zwa66TImTkl+jws3Xo6NQCK+Hahw9lyDSXDSgBQax1MTeuBzTBwJz+gvANkBcJk62sgamTsefBJaUiL6/OgPTEvEQ5CJjKpQQaoklB+wVRFiYPRHvYLPsKvj34QyYiFeB37tb2kcv1rh3VxumTwFGqTKzGgpyv7v6hWV3osu6/PGBec/AzSvCjXAEWiXku+2HcjGt14PFNqBKzyK+3J5gnEG3xUzxKjssQTxMQe9QxGXYlHTlJ3Zs2L46L1iYY1IgyuIRlSkcs3LkFXLS
 qyBcueoG
 DsGx87M6sde8UCD1rhfLk9nB/TMqOYXkYViPjruwaEmvgQ4N7DHpbesdLf2aZAMikdGl+QRbHI865VA2GkA52dstg8I65Hq/iNfTi47WPP6TbDxuZJ1Rf3E42mjkir/ssAOJlojPL4fKKv9dDhyzc58Iilw8rpjKs0xa/BTpHP1Qu/efBf5RCw21PzCOJMI6YUsMVgKUB12kn+Xh5XmZcmvjvovcFLl33au8G2gEAFx7+y0v1aLcvFJJ7WxYZsJhmRAlj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-09-26 at 10:08 +0900, Hajime Tazaki wrote:
> Architectures lacks MMU doesn't support fork(2) syscall and only

nit: Architectures lacking MMU don't support the fork(2) syscall ...

Not sure where this should be merged? I guess selftests would make most
sense, but you can't actually test it out before the UML nommu changes,
so that doesn't work too well right now?

johannes

