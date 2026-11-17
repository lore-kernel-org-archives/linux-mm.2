Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E316A60A260B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=HP2pd8yj
Received: by kanga.kvack.org (Postfix)
	id 0B4A46B00EF; Tue, 17 Nov 2026 03:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E416B05B0; Tue, 17 Nov 2026 03:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70B36B05B1; Tue, 17 Nov 2026 03:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8E446B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:36:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69242A0361
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:36:35 +0000 (UTC)
X-FDA: 85443954750.01.58DDFF6
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 867F420002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:36:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=HP2pd8yj;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904593;
	b=mM3EGNKmVqxCuSrsgTzPZPqoLeXhfkWXDBD63P0cACpvzZB9yziGJG6FBCHZDQvuhiq8h7
	zH2x2bozsDwU4eVlC3gKno/attlA394v2ZH6nEcGrdPgKuKL7Nw59/lm1ToQnNgzN2MA9M
	RJLToCoKjMDzfAeC9F2oXqaUFNMet0A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=HP2pd8yj;
	spf=pass (imf03.hostedemail.com: domain of alex@amutable.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
	b=up0CcLPsPLnJ3nU9DE0eFgHv1XLMOQIelRcps/P5J6+fPqW38V3fWRzvWOYGig2fDxjflb
	CAGGM3X2H3reGFiwUUXRs6rCzQT6bPM85uffkH/9ArGH9a5pv+8K1jVin2WfkKrfdDX602
	lIjPxojPEe3cSH/2JOS2uAKeFK1AuPc=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4b467581b98so39088895e9.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904592; x=1795509392; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
        b=HP2pd8yjvTJ1HBK2tvinAHG60QqTMRVn/LJ3h79N5gfO7luajXKIrQVQj2EENCdQ/n
         Aa/4d4YqwLDRDyuuNXayKnMy3vjqENHTVNjTscxihpEht8AlW1t5NfZb6OPGSkIYmVQO
         1O1pmh1hOBdyReK/qIKdTghmXugpWKR0UmdVKwzuz8ahtFEm81fu1MqaDlrIeZMotqUA
         fiaUWC3XRNd8F1y62qUzLRQt58gOKzh+G4mydH6HNBajZePZQnmnUTRW24knusB27kcI
         1MiDnMMHrx6cQVhv9OCkH0OlB6BIt/WaNcEc9Pb7Q7bt7CHkoYM5B60CCDwi7lU4c0Fg
         Akog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904592; x=1795509392;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=u/hxpfxH2Ygjpkkpn+gEQ4NFMpeA+YPAHTw9d0qdSc4=;
        b=z5Wat3HNhkxeF1Hxyi3GJLEn1v75TuwYd9Ytpua2YtpEJmUEG0beJcN0T3jxhoWhYn
         Z/dPfUz+xllsot12eBExRGltcUyiv2k1X98AO5gBRddCKU5AlfJwesQgQgKZFnoErjeC
         pzox7FJONMTwvfC1TlzxWDe578hwEDqGSxQNXiMEFFhVYdTYKP2ArwEFIoFedROk+3Qr
         +Z1rMW7yHwTLtcjopjQULpKHVMOtvAWmmkdtecVcmbrqKm7Q/pOYZ10BpRjjprFXpwBv
         OocNO6I0yJl5DCI0PK6UP4QB/leRkkqp0clUUPPYmiV7KsQjCHN4cPs+YXk23cE1IHiB
         sAfw==
X-Forwarded-Encrypted: i=1; AL+hErGHQ/hYFrwh3BAafid4RV5p84kRKiIee9OluJmw9S3fi10b+wtYNBjJeZSJIXGnB5On1+Oj9oXtXA==@kvack.org
X-Gm-Message-State: APuU4Z8KY9KKaOMAaExxPTyA2ur7LGP+ZLplPn0Qj3X9uwm2k0mfN8Yb
	9ni5MAzSiyv8Q8RAtpoDCiR4Kcfz+jP1QFmbCbvRudYsftpB05Shc7gXw410zWEzukLn
X-Gm-Gg: AYBFou1EuT3TIW5T1kYdQFkvORbk+s2Jqi084oHRAJyd9UJwoMrl1+mXxBUZxgIkwiJ
	gV22/bURRDXDtB4Ox/hCE46IEVaEqdhMkH/6kkfjkuTt5IxsRK8qG3MCHRJJmC8g0yoQQowzppm
	xYGfvRsEELsaL2dZPYaNIaUVMbakIz7uVab/MYB1+qcrApxlhIMYd3lEdU0cpe+BTnj43VopZQY
	RB3q7Qvzd9wKRz7GUMHEa8hGOhn0tlLjiOl26Xa5YSUcKJuDaCCITTuKKQBLHvFh/suZpnyu+9X
	uzx1Ibt0A33tfX2CM+MgjHou1CBK2bG4dhh4eUgDs3G/Qm7Lbm7H//huKCEgdmv8/QyjBt4AOKQ
	k89WJ5Bqe0OVd6eb0qWyNxgaQnpJMRdmWTmioccz5iu1gy25GOzAndglPjLntAqcUQ9SNcvAOor
	tdbIOyZ5YesYnkJnk7gmb/osPvFC/JUzxu4/VCPpXrI38GSMC0GJbxbxZWRx+xq1mNQVtw+I/4/
	CCVWYjARgRMiN1qPf2BSfX1BDZobGPXgwfRUiLjpZ1y0zeowHfo2o8lXldfTRysr3jWZlq8Valf
	yhGWfBBorKTxYIZJZbe0j6w+ZX/rlPvgliXtw6QsNMYHTHThvyfu6blBt/THjaKWdCN7nc1RT26
	etnDY/0EZNzgSxdYWTsqldebN5QhMeG5AHTI6WMuF40To7C0lkDPVh3eM
X-Received: by 2002:a05:600c:1f90:b0:4a7:76fa:87e9 with SMTP id 5b1f17b1804b1-4bb55ab281bmr266345525e9.21.1794904592167;
        Tue, 17 Nov 2026 00:36:32 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78430752sm52548565e9.12.2026.11.17.00.36.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:36:31 -0800 (PST)
Message-ID: <411502f9a4f940c223b2b88d7e19fafdce63172e.camel@amutable.com>
Subject: Re: [PATCH RFC v3 29/44] s390/hypfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:36:30 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-29-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-29-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 867F420002
X-Stat-Signature: uga4z8jduofnxa3uzt5o1cgmmi89mqor
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794904593-740050
X-HE-Meta: U2FsdGVkX1+6ch/2ZpSsHwvmychgT8StYCykWji+c+Xr7XE8p7UT4u2BplyXJGSCRkMawdJlkBOGgs0L86qe8fdmSC4LvViZSofnyPcLWQ4jZ2DMd0fstWkBlwaKZUVH7o+NjdfEcwmqV9NvjNQvmqSg/zfLjDUrSVD7o07Gc18j5nV9KnZkrkjjINOVwC68THwwQEEh2s4Akn0a53o4wBfSlHyFWEpkEMDIDChzU9g08piGb+/BBvX7L944LIGLTaH6DzJISu4GGYhOx2bgn82o1L8OHCcOM7ME/6E1lYw18SLIyt5I9xjbkFST0RtFWLo2R5ntYKifEKaH6daMnLERfFDFS4VCHsROjoTpsW+hR8MWJypxkRVez3QUbkpbeVD57m3jpuwQlfsEA9kifRsfa1yVrZEWVh1nuLjNlhwOI2D/ymlhhCX14eMWrpp9KVtDh0nrg9OMak33NmLIvu34tnFDYLZpzHStRhlvW3FXf1wjdI0Q+YAin+1Bc5Qi21/BFCc5y9eFlhvJ37yrUHhpuAlfM0nlMEuKBw8hGqAWR3AcVVAdEqX6aviWPzPuuSmPMWIWPplp8Id8QpmA15pxqvoV1BWTJHjDVN5x5HIJvIzgfB6/h00Gl7mmpvWYFL/MCUa49ZBcirVou9QLu6xkxF39yb4k1Cb0dP4hWrM8YTKKTqHT2ZXF/uwa0JSS2HuJ58eUjWi3MYW/wqxBIifueWMpqlRkxFUilVN7TioU8zU+Qo0jCCpWO7VTSBCOnKCTrYo/8gcne0pEbNBHL2T0ayCas6sOEicyPgxRv/wn0c2WZrB2Xp1+uA2aY66lSLbZbESLgVSxXosMITGxEhrhuYOMip88TjFe7wWiuRahD9xinpC5R8i0DzcrTXg0xHlZ7+7tz+zu0JW4j/hOLZBBnVedMtIA7zkYiEIR16jtjQeil3qZu4/gaPccodow4YQwhjNA7itVqU6R1ZA
 T+fuKB9J
 LWRoHnuM9cLHL9xH37grCYTkWWvSHBLU+m7nn7J+0r/m+sSkrw4Z0J+73BNxqzHDF97AXjABxMWLHcIlfnr0AU1tSgEpptiy+eD8PE4qjayPIkaOyyGwAkPO8zQqZnatuV8OC5iKnOseYhlPj9N9HImRkUUXyBD8DDKYxHXM8LYkHUGLxkb9K3fUNfaxiNvu4Vrt7gxWpj/avwxhkT0k47iQedgQSofiYyRmlmjHcNFah24gSMhfawR5nncWClI6XEIfXDK8FWqo2DDdgGiavBqoNNdBrsRZqPJm/elybZBeqk+y0leqoK3xdFz3ZWZguzMoXrmOWWhlJjAwlof4HYZhcVEtCclEzmuYb5cVM7tCbQyTOWTHcNIYcmgltCdBwpYn0AKeZx3RYXhfUnFtgfJnF3u9lWN++fBhlx+IQ/55xmm9Po8ZlPiGGqnjvqeJ85EwgYxmKHEvma/fM1PN2i0O5tQ3Lj6+TJ6tcgQrYa9s7WJEmeqxz83VCGPJIHzIVQNqa6CPdpFB219t17cA/oe7zYwkek8aVXq2qD0ou8eWny5BwQhW0rTCp0hel1z3//aKqhdMSW+ja6Ug/mU3YXUo/xu7VfmZMe9ls/CWisJSxUQ0jf793EVZXTXUaslxpmIskixAw0je7mQiJ0GJd/By6rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize hypfs as a pseudo filesystem. This raises SB_I_PSEUDO and
> also SB_I_NOEXEC and SB_I_NODEV. hypfs never holds executables or
> device nodes.
>=20

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0arch/s390/hypfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
> index 559b011e68800..8662169de477a 100644
> --- a/arch/s390/hypfs/inode.c
> +++ b/arch/s390/hypfs/inode.c
> @@ -12,6 +12,7 @@
> =C2=A0#include <linux/errno.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_parser.h>
> =C2=A0#include <linux/namei.h>
> =C2=A0#include <linux/vfs.h>
> @@ -301,6 +302,7 @@ static int hypfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	sbi->gid =3D current_gid();
> =C2=A0
> =C2=A0	fc->s_fs_info =3D sbi;
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &hypfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

