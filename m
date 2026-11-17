Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76446606A891
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Ps0umPtb
Received: by kanga.kvack.org (Postfix)
	id 9EFC26B00EF; Tue, 17 Nov 2026 03:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6596B05B4; Tue, 17 Nov 2026 03:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD106B05B5; Tue, 17 Nov 2026 03:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 678A46B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:25:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0D7EC0349
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:25:42 +0000 (UTC)
X-FDA: 85443927324.07.C465776
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC6EB140003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:25:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=Ps0umPtb;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of alex@amutable.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794903941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
	b=8BqudTIxEzbmCbmoQ3W/6rgnvhLrmLckWJw3e6Qn2214hwad/HEp9ilCWtH72/rQrylVFb
	NI9tJsMP3RVfwnceucnbkSrvac5715KpzsSRB1IKBBP7NpWZoUhx7SWOvZJ9IK6BiQMvvs
	6UT/m0AdeYPZCAUlVEWgY2AUcP0nRF8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=Ps0umPtb;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of alex@amutable.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794903941;
	b=Mj1nIkiMbz5iwV09PQek7RPdgOp7oTxlaFiBafRXGI63dEnvZRy5GFTwhCaR1GQvtYNKtH
	cyyv/QOoKade8yF4BC4EV2B6LbNFdH9B6imVm29UzqdZqY4iaA3lOmXhun7LL+M83LLmVL
	efqBSJa+uxxwR+ghK4gKwn8SEavbEzA=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48dee593f18so4521688f8f.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794903939; x=1795508739; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=Ps0umPtbDSakHzXcn0extszK+msGo0xfo+xGNV71pDqYswjzk5aV2ub94FrTQDDuj6
         Mh+gA0MWYnoabocDiFKioN9foWIursguHOWi+Nf+pazhYbLAnDFpRw2niSFIyeIPA2FA
         1HZvcqPoaYijyy0+bhufiLSqsAmAcEJD1MET9NtHmgJZaDuw7WcxWFfl0oo7o/GBc2fx
         e1bWYCwh1+7Vbw1lW6345ffl1ekwZeGPv6LAFWb3flxt+/8WaQx0T7MWqWTDdvMvJ6Ek
         MVkm2BtJEmOb12sPEN2JA4DYOLOEMdC1PBPfrc6MVBMOCps91P5pmnoUV6vjnhbr45wk
         K7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794903939; x=1795508739;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UGlayfD5Z/El6cdpm6ie0HDMH84kD107OWGXScU9uXE=;
        b=nSJBKOBtOH3zzptaM++E0qziDhqT2COhSgPq7QjNspXFH8JmdfgC2zXeI3xi/LqjJa
         zEGOAnuod6BNN+h59SggboivF7OidtsXDwL9/WVksPqYOcSgrVPOYPMkxsWQHYPLMbYu
         egbwcucmrmeMQOz1bVO9z9zqbN3qZ7RX0FyP3GsnGKNKSCsvGji3EhfdrHe6AHnYiPVe
         HPaxB8TwqqS55yrSBPX4Y25DdQSPitPLAwIghZB+s2afViuB4BzYdRfCUTEFtsw6z2kt
         NNuXdo879Z3CLyuPlYh+lWt1dTgI6O/FGS4x2e6jOqLYChMW8DH9rIDjFSr09mPXKkfW
         OQqA==
X-Forwarded-Encrypted: i=1; AL+hErEuT1LwraBPFlBn8iSesvJs00/FY6U2say+KECex/XjoUQ/2E7KCOI+kIaPUJYVZL3mt/boUIQVjw==@kvack.org
X-Gm-Message-State: APuU4Z9x7d5WdnjCnERWQxDDT6L6LypDUkRQ4HZgSSinvbpfaZywxhy7
	lf1O4Lwx9/aw4s4befzl4sA25WwkZn59tUfymNcJobDbQfu7lEPoydOj2ZhQS4LfZ0hstOiGoF7
	ZAFRI08iB
X-Gm-Gg: AZFdTZfC6P2AcbMCcKcI8Bap3gUSZ8r4dU06A23/cLaVklr2LnBQtdWRez7hIEO8TMG
	KStemBMrpZU6mkOeSkRBBXpczEHiCtVPkTOIBu43GNv0yV71JYeu03Xd0XLeSXA9qLdVG8MpyE4
	O57rC585evnqTTz7+4yj9rrzeL8L55K1VrcQzROBMuKmdqSnEOPRpqj0Gev7nEfWN2BUMva6ysM
	pAyWN+Ged3Y0wPSFq5PYbnxsTQGqa4TshD2DZ69uzSmPmowMGuYjbv2XnegJDnyUEgS4XX2AvsG
	/gYwX/KSmG1FdZPSsoEiX0BjpBPhCyKN0ZVLkmmazxmlkaBGiy8QpfKV+uFl0pc1gVLwE77p/4o
	swWe1LS2rnHgh6SgpdvkMaklE8JfNK4gcEWdiqR/oEnUObR7WssORIgFepT+m3ZWqEFofsGeigC
	20y/+L5h+IGxy9mDufbHo+A1meRwqHKOMy2rdb0JkO/s8oESP1MPmNHog9ZUqDPOer5ZFu6Eesy
	xv6lbegvL+ZCMM4KLXVtBYRtKAhajd2RC04c8jTDk1hZD/sG0vDPevG7yPlFjfcPLXdyIXEOUMX
	EjWvegElehTfB8CTESIPZ/DxR8x9G5Pt/Tw8r9K7Gu+9YAq85Q3A8INUGr3UdT19qqZ5NFiZ/HT
	9ec+ORcjX2Q1Qj3Mvob0Jt//gqpbS6S05/Ml7gtXF0oYPSKNikAaRNFo79pwtLLASUATY8Tuf+w
	h67Q==
X-Received: by 2002:a05:6000:2084:b0:492:46e:d4ce with SMTP id ffacd0b85a97d-49c6fd932c8mr25238543f8f.13.1794903938925;
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5ff2be55sm26907832f8f.28.2026.11.17.00.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:25:38 -0800 (PST)
Message-ID: <a9124bf1c858cef3e8ac06b1b2396dcb0e19e2a5.camel@amutable.com>
Subject: Re: [PATCH RFC v3 02/44] nvmet: check that the file backend
 supports ->{read,write}_iter
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
 linux-kselftest@vger.kernel.org, Chris Down	 <chris@chrisdown.name>
Date: Tue, 17 Nov 2026 09:25:36 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-2-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: EC6EB140003
X-Stat-Signature: 865s8wgmn11gmz5qauwe6nwoy7w3g4se
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794903940-384645
X-HE-Meta: U2FsdGVkX1+zKh0AM9PFTEBHv8SzBwj+IENEDX+UC0DMuPBk8c8TSvt65pwv3Oou/FCaQSQZrhSKVA4hUWT6sKVlXRuwGgk+U/68bpOiSw11p6+FaFUTIi0dXgCt+7Ntlt/FsfuI7cUDatsXUHcPYuL9xQyQZsv5lbO4eM3bEViHIOAsD+hU0KlMbR9lOe5rYBZ0sPRXwCRdf3ASk4cnXz3XfxMqCGLh/Wgs5eOBcepMcPYFRgYEsO73xq0Pdd6ghNvGT4AOlCRxMYqNVnu+ZBDq4h1YfY6p+M9JFuKsQS8ftZdKkHZ0STqk72zXGKyFBsPXvJA9Zct8vECVuzJvRLH/HC30RpvqwZAjvD3+VDqqvMm6Xi7fKrcM/6O879BFD/HLPnnYTAczumhtC0YjiGbPaFsv/nN5WMnZlGyNxenCJTAUS1da4n2uN8gIW4Qtww7sl79rgfz7CXqfoEiUk4m3K+CeTGZpFLQrToz4e8FlYewQ9pke6A5ec254ASGdG8bNZEa9Pqmr1TwhLnFPpmwwHCKTUtv3p+iVCXpiNzRvvpcjR7EMzdaW5gAx0JOC46ed4IDEeyoQINYb9I0iqN/RMq00ckUksnXFteSodKyIR4mLdZjthrcGWJuf7Oh/edgGieEGNoWW7Ac7zpHH/0wvh/HCsIA2+0O7V3ypfIa6yJ/0MfQVXZHjLFqxBonc9Rh1zbv26+xUWHOhVpZKGF1rp3mfK6z/N7baU1ZeDQKn9i0Ij5ncTIWiVf/e8Uo2OUKHYFIt0W1Km9PBRQT1Az7NncICNJJBfG4R2v6Lgu/gqSA08QWPNZyN+O2TonTMqSpaoJwRp2f0LMUoaK8vd8C8BeEVNYZMhwbxoum6/AeUpyX4sx6aKbmD9KA6ECNFcWmMGTYC4kD65B+5AU6eVF/DyiY4FvzHG4h5dtYjuGF2H2zQeWJ3vtu8EKmtIzEg37TDW3+4dPvjSjJ+hel
 sx0qfL17
 BuifgrPx+Bg5OKfnEkvVP46DWaDky6/+FFsuJ5+IAG/h53yH0A3Un/QVjQ5R3dg+P4ri5TNNsxW4ZufoumsEmlbcd5apk0xiSS7LWJ2qYF9NS7uITZdgO54kNODtZpNWlXgNO076OcCWk4GtZLEx8CqNIjtxLix1mCbAkp9CGaZCZZPUB7UqNGOeCZIi9mhtm0Z4C06gufNMnBvw9FipylqDOa0knlcJJvN0yUY3TEF6Fe/6/YNmGLO8PS5lN0DQI3UC3cpBMk7oPbVkH+Yc8QXiwsUvXz2m0E7vlzaQiFrp4cQdao5FAs6BuH1oIdISCYcFcQBmLKPeKsheT9F9OV74OdkgI/f4lunBhGHwBvQeneEFlE1F0kO/SFF4RfXLzFT5WxIP0Ko/hxe4Dwiae52cMq0w1Mzv76mDsjU3v1W4+31NvwBX9+OxmrRO7+LCuGcUwqhH6ys44B4RfyQQ99Wo2F0w1F8vbTKD0U7DG42DzNVgpUhnnLPtR8g3/HQtQ8KjUht2LtAazvPEXC81z8Rng+Vk/kqwteLjr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> The file backend calls ->read_iter() and ->write_iter() of the
> backing
> file directly but never checks that they exist. Everything that isn't
> a
> block device ends up in the file backend. So a namespace pointing to
> a
> file without them calls a NULL pointer on its first I/O. Only
> buffered_io=3D1 gets that far as the O_DIRECT open fails for such
> files.
>=20
> Refuse them when the namespace is enabled the same way zloop does
> since
> commit 0c10f8a1a7ae ("zloop: check that the zone backing file support
> ->{read,write}_iter").
>=20
> Fixes: d5eff33ee6f8 ("nvmet: add simple file backed ns support")
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0drivers/nvme/target/io-cmd-file.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/nvme/target/io-cmd-file.c
> b/drivers/nvme/target/io-cmd-file.c
> index 695963dd932ee..dfa8aa46188c8 100644
> --- a/drivers/nvme/target/io-cmd-file.c
> +++ b/drivers/nvme/target/io-cmd-file.c
> @@ -47,6 +47,11 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
> =C2=A0		return ret;
> =C2=A0	}
> =C2=A0
> +	if (!ns->file->f_op->read_iter || !ns->file->f_op-
> >write_iter) {
> +		ret =3D -EINVAL;
> +		goto err;
> +	}
> +
> =C2=A0	nvmet_file_ns_revalidate(ns);
> =C2=A0
> =C2=A0	/*

