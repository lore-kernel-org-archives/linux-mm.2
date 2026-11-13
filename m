Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 376FC60A262A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 09:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=KgS0W1+6
Received: by kanga.kvack.org (Postfix)
	id 46DCA6B0655; Fri, 13 Nov 2026 04:55:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 444E96B0657; Fri, 13 Nov 2026 04:55:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3346D6B0659; Fri, 13 Nov 2026 04:55:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 083FE6B0655
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:55:03 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04DC1A0181
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:55:01 +0000 (UTC)
X-FDA: 85429637244.09.67C7431
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1FF4840006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:54:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=KgS0W1+6;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of alex@amutable.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794563700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
	b=8NfPNM6bL6UMvXcqfnVcQbulPC5AzlNp+HqLky6qiEETdt5AQILfvp+Qs1Pv+/sDi5+441
	OlJmBPB6UEDWMs/gcoUjv7XTlZQU5/yz/Zsmt+RRN/WcJuZQxZ693SiKkvkO4N0LwYxkNB
	8KBnlLOZfyYIJaBEGzQd5UDC5N7V6qI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794563700;
	b=i67JiAyITCnhePlO2RyHu7sZXYu/2vxGDu8D2w2lSGDJYGvrIa4/2iWlJmTe0Z7ORxZmWp
	gttYSKYHI8BZcTrwJFWW1qrGyjwygFPFZIuN9+0l5HdTn7Ys7Q/2tDQiUPAVY1cuAa+JzU
	x2Z8b4p2GdZc1iFQQIyKvyyyTHf6+W4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=KgS0W1+6;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of alex@amutable.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=alex@amutable.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso169260366b.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:54:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794563698; x=1795168498; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
        b=KgS0W1+6GLJ53mA7l/yOwzWQkUZBNPMKYhhgmymEKm2nDY4PivzMjjezvMIXjnvUgy
         iyoWBARXiHpBl5awgf4TVjbOpZ4QlL/oEm/yLgQ3xS/YW4QzpHDjl1i1onIyQ4Cs/S/d
         ErO8LpQAiM6zjsB9gm9bO7J2zdDUGVj5ZEBiZQiyBfKO7kDQEd/hFOUiorEHx4UOC+LW
         rwf8DdQHuOXrauEBGrQ2m95JzbKjaClM4d64YnSV5Cfuqcfuj28YdQ+4ttJlZ/wM7HtG
         sIxIWTasuAqvvtHzWRobABSdySvQ9S7ThhhdzzSZbgDu9/DLnLr9SEjQ2Hg8pWIBngrY
         KmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794563698; x=1795168498;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G8DmFU4pJwAPCJlqHBF8SKasEEThxtJNlC1sg/CSkLw=;
        b=zjZE+CFCR0FGI8JScv2YisoP2CLdLmttrRh+VO6eqUjQL8S0/9eIayzeVwJU1Ed0ZN
         Kv1xBxzDPi4D34ohGVqNUlYjljtetip/18BCH7ezE/c5QqF0EOlzLYa0Mn5u2pdd4gE8
         Nhx6GnJ9GY/2qPfLqIzdH2yxA3lLpAMcHIvZ1X1gIrFvnP8I9VcMZYJchV25oyEqSza/
         ft+V8VZRMl4YLT0tHpxVp+BmHCTzvGTkvsBZoU6zTXo5kwy98Chn1CNUYIhRi/EK0N1Q
         7ABjpC1854Jjhq6EApH3CjDOIsvntgdeJzEUG4gKPiRzjlFEVnah/XyeVmbpYzrLAk/R
         kbZg==
X-Forwarded-Encrypted: i=1; AL+hErGFUT2klHl0jT4gcH37f25HJdO5b6CjR3WLH7rC4Gf7KeIWV/DNzvu6TbeV5iQcl6y2Fnmc6Y/PZg==@kvack.org
X-Gm-Message-State: APuU4Z80GaRItr0zHM9sAJVV8h/t5F7GpLEhoYFQWxmaAoVxHc686tUa
	m4KzIsRsbPu9uWzqKwCyHrDtLyH82y/9Efv18+m1qfTC0Wf3vVJN7D8KWDeydrNRlQHD
X-Gm-Gg: AYBFou1Wlb/u2GpzeEAcVPFYLmaqay57U677x/uuu6uvuaOLvDJ67jW0DEOMgwKnUr4
	XwtTJ9ARi8un7Zl6abUU73s3DQhPJBwt2JSTl2hscIWCCnRLdg2GzsJkLOd/H2pnsJFz2fH56Ud
	oxTzqBQRs0PFDpprbJkrbw++86FVpY8t18oEap7L/DpP2+BsZIxArzn7pedf6XA4p7y79uUGjOF
	hx4ivamj6KIbvZzKaikUubkIe6TSldOaX4cW2Yl1r4pi28GRLh+kxwz2/07L474prRHlH9PDN6Y
	O7oAr+4efVCB28NAbSnJuka2gL0uiKPhW2WxGvpyExkDF+c9zTdjbC8pwJZFwgDcvS/gJEu3e2J
	AYSPQuBeJMfBMJ0b/DK4U6UqxHv65FFWSCNILFImQd2L53mD0lezttPm8l47TAKTpVDLGh7VXwF
	EKlt6K0hBzL3xWexypFrSEqxvdnF9H2APnPp3Cz9EwRmbdLIH8cAhx+XEoirdogX2nHjsqjq9NH
	OWEXm0ks6XGH+mtxMHjFI3MWChwn+WeYMXKCVJL12LNe4YgZjV1gNPVInu7nU1C7YESLtRYoSR0
	bJi8PO8LBFs/NjPH+5f+YF3yxEuf84RU5R2CpFU6h7geP+bn4Oj0CtRMgUjqef0=
X-Received: by 2002:a17:907:ea93:b0:c41:4c20:5a80 with SMTP id a640c23a62f3a-c50963bdb9bmr198299566b.44.1794563698514;
        Fri, 13 Nov 2026 01:54:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c50957c6c1fsm75151566b.0.2026.11.13.01.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 01:54:58 -0800 (PST)
Message-ID: <b42c9f4d29a9cbea66929c95cc8f736f12703c72.camel@amutable.com>
Subject: Re: [PATCH RFC 01/41] loop: refuse backing files that aren't open
 for reading
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
 linux-kselftest@vger.kernel.org, 	stable@vger.kernel.org
Date: Fri, 13 Nov 2026 10:54:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-1-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: qp8s86g6yyhu3nzc4wn6ya38uxoaw445
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1FF4840006
X-HE-Tag: 1794563699-757792
X-HE-Meta: U2FsdGVkX18PT5ZT0Q+4AaZV4SXVELsTea3DOdvc7LY2nXTWHwFkKJm9Zu00B/EaeozKe1qqBGqJSDOyveKxVjlmFNrA3Bv7LVMC9DSaFvpZqzkOw+5jLB6Hf8n3cpAkJft0zWrgvPbd8m+AEUucHO9RD1nguQMYEY+P0X/27NsJAeEV6GdyTL3mXZRf1Dl+98J3DBSjHa0Taz9jcPkntLFxd1Fobb/gix9rMCyofA3To7G8U6Jpidlf7x0Vpy5trweV0wDoG5oaHqbuj1n5b96+7YsBzGQAU8q296iOqVtZe1RDyPjTGm8c7yJDdwNRegWYPC77ypoN7sMuLP7h6FSdvIrN00m4CdXTv8wOr6sVpOeeURXdSSLGCLPeb0X2M+HUQwqeVI2j3r7E7LfmzXdKMIMIaHrnrltLqwsrH1q+ulX2u3/FqYgOYC1nHeVkVZwG9CFQvc0TtxhWRukcZ+YBtgARUF30iJiqr5WJzpi0X3EIfPMI0K40ImPQnpnsVR96EJjOd4JigicE88uKW8hiybToMjoehNYO2eFeqFzT0la6ozYOaLUqX/2xh4RaZ+hkggWKuP86sIKzJi3bNbErb+E8E1M4jL0FiQdu2X5NuDPNvYrCAkuRe+YvIevOQiulQc6UPdO8X/14lZKw4LMUVVv2I5CQRR5NgAYapAK44/YLYdeOtuvA60Wndqglbhjb6VuNrozjrh/GXE2vNSmvzcF55UzOs0i3aVQZLyMyIY2esdmTAPcxAYmhRSjuNWDxNvPY2b1w7W6tY6zzUDKwQFuD6mdTea2UZLYa7GLVV6qH+mrIuBllm0Cjca9gV4wve4jY48mlSVoZO4bIe+VBfHcg6ofIdCMwdiJcgjhS3D11UJLv/ockUurWzLNYewoJEnCec85MuXQfHxo6fRSVN4G7InYlb3YlT0lF33rIFO7Ngpu28G4g+ndwkhyCROfsjkqd5st3gdr9xIt
 V1dLqL7Z
 +Ce0sqVTVaqFJGKNnji2Wd9RUPsJ/GPVseK88JQMWFQjxTtGiOxFO2HpnTGoJXYgghFV9mCP83PWxFLbvJnnmqV8E6zY4Fni3FqAHWGMgEl3tSQPHrLDayEzMhk5JAvHwV3ucnCuh/UHwLOzCbyMdKdnwo3w1fefuHCyw7OFCET4c1G5Orx0Ddu0+9deMTcHIDI0yO3Eu3Mf7+vBlmbeCgcLgBop2yMlARF18+tqNnqBVl0AdRpza2Kw0TeNjoMKiuQqGAsWRTulb76cxQ/4qnN486PZ1v0jXVjYr19aKmtzmn+mCYydsMWmX8rviwwxOHEWYJOmCrJreJPiglqmvImgmxB/VFLXym5dNgGPNLHdWeKXiYuJNh3U+QaCZlxP/TB18o7DafhLcdkFR+pBNm9QuDjtDMEJdMf3f47QRV98MdYSV+a0n+QvL3iIZGZNj4r4b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> loop_configure() takes any file as long as it implements -
> >read_iter().
> Loop itself never checked whether the file was actually opened for
> reading. Buffered I/O went through vfs_iter_read() which refuses
> files
> without FMODE_READ. Direct I/O has called ->read_iter() of the
> backing
> file directly ever since loop grew support for it.
>=20
> Since commit f2fed441c69b ("loop: stop using vfs_iter_{read,write}
> for
> buffered I/O") buffered I/O calls ->read_iter() directly as well.
> That
> commit was about O_DIRECT handling and the FMODE_READ check went away
> as a side effect.
>=20
> So whoever can set up a loop device can read a file it was only
> allowed
> to open for writing. Open the file O_WRONLY, configure a loop device
> with it and read the contents through the loop device.
>=20
> Refuse backing files that aren't open for reading. Loop always reads
> from its backing file so a write-only backing file never made sense
> in
> the first place.
>=20
> Fixes: bc07c10a3603 ("block: loop: support DIO & AIO")
> Fixes: f2fed441c69b ("loop: stop using vfs_iter_{read,write} for
> buffered I/O")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0drivers/block/loop.c | 3 +++
> =C2=A01 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c
> index a3325ceab484..c96e35c3ef42 100644
> --- a/drivers/block/loop.c
> +++ b/drivers/block/loop.c
> @@ -528,6 +528,9 @@ static void loop_assign_backing_file(struct
> loop_device *lo, struct file *file)
> =C2=A0
> =C2=A0static int loop_check_backing_file(struct file *file)
> =C2=A0{
> +	if (!(file->f_mode & FMODE_READ))
> +		return -EBADF;
> +
> =C2=A0	if (!file->f_op->read_iter)
> =C2=A0		return -EINVAL;
> =C2=A0

