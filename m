Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91DCB60A3825
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tGk+OIUq
Received: by kanga.kvack.org (Postfix)
	id 869836B0694; Fri, 13 Nov 2026 05:14:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811B96B0695; Fri, 13 Nov 2026 05:14:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726A76B0696; Fri, 13 Nov 2026 05:14:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 522696B0694
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:14:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4A3B120656
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:14:01 +0000 (UTC)
X-FDA: 85429685082.06.5DCA727
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 01FB9140004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:13:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=tGk+OIUq;
	spf=pass (imf26.hostedemail.com: domain of alex@amutable.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564840;
	b=aJ5r2lVDSUSabcQ4OlyO4KVLvUHJ3csU4BsK2XC3fUSq9bpEBx0EXnKiSqLyycCQYUzHZm
	DGPeFXIZHatG8sjL+uXWPvQDwkO3R5BI29FwT+flcIh1ZmPPSdXKAq+azTvVQwy6aryyYX
	/MNePnUYWzyziwoHsAGQ/n+11yHUos4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=tGk+OIUq;
	spf=pass (imf26.hostedemail.com: domain of alex@amutable.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
	b=diVOBxtEz5+qo5rZc6tbOBhGxXB46oe2ck4dwflYMtgIb+eB4B04AcAeJjB7g1ZyNrQ72Q
	XIJRHltXXe+qrZREAQdTwdxNZpsi4tRkmK3YRpodkgaFIFvqwOGTFApZ7vAJceXhs/P+ra
	8djAdbUIqyEh/Ms00bpGEC2lzkbynAc=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-491d1f66968so207276f8f.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564839; x=1795169639; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
        b=tGk+OIUq2fG+tjPn7gwx+sYttnO2vIgRlVgRnQmjmmIKLCSQwyZW8EkzbHETn7RbzS
         7RZM0Zo9jn+MaIflhjci1/pP7rrqLiv2Tfp0YUJXY7OVoqTGTHsIy7hWXtMUw+9m0bcm
         cqvuPQp4HbxucMiktMbKHBCBiTH/EhjWBnrvC2LFZbR6RUNSbN3tXHSJxr26RETYfbLr
         rXuKk5HvNDSe680qWcqoCggp1xwth2i1QpHBZglT2GVba7kAGo1q+biWgRMxWudfm4r8
         ezXNkI8tVNpa4c5mdp4aZRzshuUk8pD2MU7nEMSCieIOyqB7HoROMYPJTtDMyOSkWEhA
         wBBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564839; x=1795169639;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LWRhkHq/o14g3eGvU8PB/2eVsiZ8AcgjQiitoPu4Uko=;
        b=VZSgAgIbRn4MhE7zUgD9mAK9epaH0L35t9xBNOROaHVJ4MYqH1qUBG+b85OYd3XOqI
         UCIQotUZ7e+UEkX5udDZB/O5trb5+eKuUdkffR1KWcfakLx01STSXx+vRZiSqBwr6UdE
         1OiWKMniWAFCSa4LmdySEUDgWwjNuHcBl7V/MbooVOPcmCBnYjZG2hGVYIluJlXUVIzd
         STasJyap+m6puEhCnoxW4yekNrxEAYSu7bYnD9GaNqjI1ThanvaA/6Mz8z4stEpSOZjp
         s36PKCwujsYR7Akd7BXrU4G5HmfgBR/VrHdnNAHvsGpTQSE1+Hjko3daMghUI3+u8mJp
         +TaQ==
X-Forwarded-Encrypted: i=1; AL+hErEZ0Xe70pKKOvVFhcK4lY97OkSiYXbgslUHiIR6eOM01/mrNcTUzRwl86rFDUgtcTe2UNWD8rmQrg==@kvack.org
X-Gm-Message-State: APuU4Z+5UDTQLlA8zSzVjqAj1vRKbCZBZrIDy2ZA4glAtDUXFxBRCpP7
	5PktbsUujdZNoVUuHfA9GrqYG/k2Ztb1UTKwbkQu8j38MtCwWMp5IkSx2L0Xg5eZM/rR
X-Gm-Gg: AYBFou1kDsxLoj2y6AhInhXZdqyYZeKcq6h2c5ro58sAjds6lc3XST90F12UbdFgJ0a
	GemiztsdCgOzaKhHpEoCKAkHSC0OSfo7mHwQDBay//v97LO6Be0lKuME0krtwBKmS5z26OVDYUX
	Y8LFbO1IMomBlaKtPSvZU+cNgsISOBEO4/LD0aFNkbyfD0Dn9SN2LeRHHQpWsg/HgJHmtvO622Y
	0Zpcsf4a1rL2rfBpyA898UfhQJTm+slJ+PmXq8TJ7up4TJA4a+EXrJMPKedVsfEEzXSwF2UcUFX
	JajQCPj53DyBwsrt4iOImNItal6JfSfSN2kFcdmbneNayLjLMa0cr83jhowIXYjhrrNG1UakSxT
	3TUYQns8dV9fJKO+1ff7y7waXKz/VrigRzx31a3iyNPP4zsPzXlFaohup8MUtubNdS8FLEfFePd
	cXtu4EoN9CkF1guc6KhQtrUwtbxiksM770pdUOx1aa98Ig39Yc7MgyeC069gMOm/WlAnt4eY4zo
	agslEQ1l1bBQYYfDvEKgIXnpRxJusqf3sqUdWD0dm0lbkgCVfs2r273r1RISJFablE/pCeTI4a1
	S7D8S668sritD1sfksqQhmWEK32p9fDVOp0zZO+Wk0sPl9LCd3UbXi78SZvmKy8=
X-Received: by 2002:a05:6000:993:b0:48f:bc59:ab9c with SMTP id ffacd0b85a97d-49c6fd932f0mr4358101f8f.12.1794564838578;
        Fri, 13 Nov 2026 02:13:58 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49d673ce75fsm190118f8f.55.2026.11.13.02.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:13:58 -0800 (PST)
Message-ID: <77855be3fb9f0e1888c6dddc56d73a1683c820f0.camel@amutable.com>
Subject: Re: [PATCH RFC 25/41] pstore: use fc_init_pseudo()
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
Date: Fri, 13 Nov 2026 11:13:56 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-25-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: thuixmrsk7otjbjb9ts9ys553tcq7xjd
X-Rspamd-Queue-Id: 01FB9140004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794564839-186893
X-HE-Meta: U2FsdGVkX1/RsmarBIgeAi2xarU+etONTe7++zqW7uoH/uyjoRlhhsWGLSvQfHZVawuoIF0cR9AJdJcOBfiI8aPSKxoUklMjAovUYptJTdSRnRUXmD0Vkf6GPFsmmx633jg75KM8NrSteYOw04Dl5bwp+PjRK7GwIGGN+WCdYdFXY5V8P0SrtVj0IGoh4mKlocZj0ceypJbygvYzuD7FaOs+WD9oLF53F9C6YZ5XOP7q5md/oQGnHA+C1VkS8k9r8i8hmNw+fv3bRyyaKOxOCZgyDOJztMOWtDi7I8NYh0c36ngL11oVyY7kZYQhWyBtIxPREwe37PSDIxnvufMT4pp6ZJWHSB4yZgtCnioYqcEAKeyNkgz1iZE2yy33b8UxrwJkCO3uwp8vYZWIGWIz5VG729Fx7CD7HaqrtA9tf1aqL2CRdkvFE/HFZrsvh6sm7rQ7TPMbfaR8uF7YE33DNAhcFHLEoIWhYguzVZHXX7dnERq2sDQLWuP52VKbiKr3HEXCD9/2TQGvJonWJNvvx1B+UUTeIY3fEHzK3itUit4cTeDCCG4kpXpRYpn9FYcZhySHEjZLtcVDFvFsiY9TgX+L2BCX82EXMk1s/k6gM59V+vapOh0odVShfCjqmVQeZKNHFxBzKEZSRHrMtr2fDa+vl2fAT4/FQ6IMHBKZjK5jZPinbW4N9m0fvjj8oRRqtnNLdqqHRoZtnJQrwrSqIGqW61h6EX5OGjHsv5GZZwPgE+YB+Vef7ytWRINKxCgrmeSONblGLBbHR56CgqHOt3Hb3JC+b7qX6y5ubIdZTJyOJsNrjd9CD59kaW1459LmPnvWXH1CRMh3iOq6OpwRPPFhnMCnl9yxMrarW9oGmH1+A1krX04juS81cg0si+kupVBly5FSqOTgpKZWyw73kHTNibA9halCuCtqPvipjNuLGrePknnX+ZGShQUaW6X9xV32dTysoU0Xbx0ACc8
 2zfEDHBm
 /AGHGqPUIZs8kuws+M1vt49kB3h6/b2evqmaxpaN+S2+TRu2wb3a48rGMobc+VWkzWMG9zkFZ+DLStuqbuuiL8pUKT5m6dLZea4/Igc5LHZy+k4bf/a7tJ2rJxvWsWPhmzBdU3oSN09MJE6PjK3kIEkFlvtDY8msJ7T+csIe5u+PA4tpXfKSkC45Bf8M7frP8hy0EmNGMafX9i4tO0Xirb3ruFa8eCh9z6HPlJykqcmYZcVyLZTCIj5Fdvde5lkt+3P7jqFZXUdDHn5NtKukGm2plg7IGE5Wx2mYwn1drmaqwbh1eJ0Ps8Sj8Ui0TxU1sDlH1PH7pLPsY1sfAo+uVdgsVKs9UIMlLz4VpewjrHdr21pjIG9krTvfqmcetSPoiUaMYlWOtc7TZs1sjmWq64zJ9iQOa1iYw5WOKT7zKnJ9j/cgOsXiez6c6EfZD3+FJJYuBOoGQEm7LHlxbtVK9zsMmg3UUdGDWJ2lhJOkZpF8epa0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize pstore as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. pstore never holds executables or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/pstore/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index cf499ba72702..4658561cf90b 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/ramfs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/sched.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/pstore.h>
> @@ -491,6 +492,7 @@ static int pstore_init_fs_context(struct
> fs_context *fc)
> =C2=A0	ctx->kmsg_bytes =3D kmsg_bytes;
> =C2=A0
> =C2=A0	fc->fs_private =3D ctx;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &pstore_context_ops;
> =C2=A0
> =C2=A0	return 0;

