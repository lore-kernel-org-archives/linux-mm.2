Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D710E60A2636
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PeuPwMjp
Received: by kanga.kvack.org (Postfix)
	id 0066B6B064C; Fri, 13 Nov 2026 05:11:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEA126B065B; Fri, 13 Nov 2026 05:11:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB15F6B0689; Fri, 13 Nov 2026 05:11:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A25B56B0688
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:11:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BE6980379
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:11:46 +0000 (UTC)
X-FDA: 85429679412.26.446CC7E
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 543331C0005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:11:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=PeuPwMjp;
	spf=pass (imf20.hostedemail.com: domain of alex@amutable.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
	b=fxvCj/JYlXaE66mUdccwKcqj05GgN6rMmVFh76UJyLD3nrjKgwRpYoPlOhKBHTL4qGIi/x
	aYkhaj8G8nBi0UUCwXaB9DlP4Mkegw+XiNw2DXxvDon+w0Jc+29nKooId92xeGIa1xkRyY
	CpwbLgzdmqx10PHxIyANIB5+smiYY54=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564704;
	b=4zHtEe1Ych+f8N827FbdRmWFftd5IZgi2eV9+zC54ODujYMMizidCaWQPvBknGWFBKLpOw
	STUh1SVk/PVHwQuijpvV9twy/UwWsmu++vTcrAWFqkj4WmOa4QYFJgGrd1Td7OLU18EHrG
	ZsZ7lWJm/rRqzWPs+56GKCB0OiS0r/Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=PeuPwMjp;
	spf=pass (imf20.hostedemail.com: domain of alex@amutable.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4922523d1afso333866f8f.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:11:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564703; x=1795169503; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
        b=PeuPwMjpH7Kv7pZuwfH0J8i5rJgFEgdWo3KPZ91FtyRLkWAtBYtAKzpPO7d5nMW2O5
         futWY8DBPQNcU5brzoAo1QJBZl/YLPMjv9oC+2IN2YmIVoJtp9UqAoiaLRbuWGVKW9CO
         eYtmv8W8SprKYhN2FMhpMuX1+vseUgnUyuJO1M5lYSfh7FsBnyQidQCk/i09ZYSS3wdZ
         AyX5nmJeobodY9aEcSG/iFPT1ARE7PG4eTQpY61/EH9HSw8xHD/C76rAzBUEfIXPDZ+H
         +hfC5WzFx/1DQmJBJxE/+pkwWQ4FoO17DLIx8XFDGZl1QZ4zAv9qz9V7TV8i34qEuxpU
         xciQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564703; x=1795169503;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gXMsjTg9KyNTuX1cuQ9yr2iJq2/VClhNCtHhh+FL0ZU=;
        b=LY5zFBMWCQjg/fGtX9WiszN52QqNtoItbfYmDhLWBBVT91u1K2Rithn8SHD5LfwPYq
         QcemKgbCzF/1KjjM5bu+1OKJtIQqFKDt4wbqwtu7McJVSamkDb2aD/10q3xzMP7xPTbB
         BoqDoXaZ1n9P2J4ZyQuleJ5hSdR/ODo2TdJPVEMCDbdy5EQunTlYF8lXp6I5zcpl+7o8
         NAC4pokvAKl0buLLZTCSFi3UxudPzGZmldgbveMZgNRgQYJSKEG0NFwunzWLXF03sWvP
         9jSWy8sCO3HrffmoG/vk9GC15H0XW8+YqyqnPR6pkGtZcFxnIj8DMhBj3Gp7wIoHr1Gj
         fatw==
X-Forwarded-Encrypted: i=1; AL+hErE8Lo2dDUkQTQrlGMIdU4HgklvQWRzwyzdc/LV6h2lJbKdLyoqIsnFTJvyYXvOEMPlKdxDD+V9vdQ==@kvack.org
X-Gm-Message-State: APuU4Z8JAqF6WQXZaKeXP9fY79C0lstDcU7HR7INQiDbJ386M303/wBr
	KlpE0AOOfWl0iRXAd3qLDocFrptJCjCcbgfWUXnGCvYxTmQsre554Zs78O9MVJ6rl8hb
X-Gm-Gg: AYBFou3raAKg+Tqs0/7TmGqXy/2RQJm3m5DOC+kVvldQG3+MWbMeqhWsirkaGyafI2A
	kI4OB4XMFEMZFSBH617naTPc3gd4Xm8vK+lJZdiJrL5rP5WmrOXmNe4PmUsXPfL3TajFGTnUbgV
	wQciiOwMH0vEF0xJojAI92TFPOCj7+ndSFmhukP02a5xaqcM0M8W6/OCqBmxzV1U0KFJv5VYX+U
	zq9TBC6DB/sAxqce6DhoCvtaiG4hRK0rfFCqhAYrVMDr3P7aL/z0rjtpGdzcjzxijceU4hDSuAp
	W02dlXtvXco1EDvVWyPm9Yd3/L+BtAR6Jl/L1lSdFrrfROjMXpqu05qX2GsKQANuewAaQ9gXkfc
	Xk1fdZ/AOQklSt5G5v++TFTi0OiXOhFgR/yaRzC5CKopmEA35vAMH2AyqI6L7d3srF/1Rg+xq1o
	cP6xwh151sVYsd5E9Ufns35d2TglJJSi5dOmfNxjdnIW0CQ7vnt9WJ1FntfwID7Djk3VMZik2SZ
	PkBoM3tmtblUkHTtkrqXXVE5T4kDGm5lAd1G+QN95mmXVj4i3as90zzz3g9KwKHXIGogIFPD3KM
	uKwEWua0mLZFM+e665EKjl7kwGLmk9jTcP1Z7VGrm1iwnN+TnPwpeR4N7gpHyBA=
X-Received: by 2002:a05:6000:2501:b0:488:88ec:59c3 with SMTP id ffacd0b85a97d-49c73259cc3mr5012611f8f.14.1794564703010;
        Fri, 13 Nov 2026 02:11:43 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f1c1797sm4931434f8f.11.2026.11.13.02.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:11:42 -0800 (PST)
Message-ID: <ff6d2a8c8623f5476d5c352dac1ad98ab3da303c.camel@amutable.com>
Subject: Re: [PATCH RFC 18/41] selinux: use fc_init_pseudo() for selinuxfs
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
Date: Fri, 13 Nov 2026 11:11:40 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-18-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-18-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 543331C0005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: tnswta8mfwg17tr6nhen5y4rxa6bt1jg
X-Rspam-User: 
X-HE-Tag: 1794564704-822561
X-HE-Meta: U2FsdGVkX1//qx/PNs8umINYWpfKXIYsDuOi41yBk1b9qEjwl6+Q7TNxNGZ3KEodn8VohcoK/sH3QxDzux944HTDzLpscwMqZthSVaycTRBCSaNpmmXmd4PeDBUGcnSiXro7SM2v79zjnr633A9/nAzZ+zk0Dx3DPqqIJ9xYI0m5+jSOk+5l/0qhqmvquoBZNxCfkYrG7DQP8zgsG7NiQ3qDhy8h3EDqkjPoEnhtIFrAAtkSVQkHG4E1KqmAj3qn8u7Pwyp3SEwdHM/YKbrg6+5vJDwRUWtLS1zN2sx9gZl7ubXnmqS/xQ+U7pudVXZ4cd3OKR+DZKNCjG3iSiGCkXLwXmoLarj5MZ2r3XshQOvH2/lQF3DYH2667Ziu9XYJ1o59WjS0zfO5Ue0iCxia9WR9SD5b6ohcs2nNYt5X9QYeat4Bc42IbrdMKH9lIOqo5/bbkuQIdPP8MWzGw0JNl2CLj0VZEEDoUGKlVlAnQnVddoLBWQ1lnJNmkTvHR6Jgd5PzQSv2KA+F1jC98CSde701I8jBe2uc+XqdMWt9FkMwsnIwYKQXeepys2MYTbvNqHIf5CP+K2QQ7nZsLY8UujZsemU3UNJDgRlIdY2U9VCPhzxj9e8QYtJLmXXWmw2886I8DiBzndl2aG1us0823fhIXAxDL44zBFl6tTEXqu1HGJq+PKNClHFF2NWmM3EI56OxSJo+1aL5kj2VTrr27BoS9U60S9GQHAzEo+g1nBrbl1Xtk0BPq2mDkk4V638xVVMSC9kq71w8Z+aESLdQ6rq2FQANvZ82Nf84UpXbt3JVct7TsQofQDYVQ4OuZ0jvpltbsa7uZO+6wOEJ8xi8zw6VOGlLABV2oqVD/++sDUxCsR7I+0ZEA9JcIp7JCdc1lcimgZlaNO673kPZOzmG73dlvq6D/mYAMVtYIXqJjghGQpwoNMwuMF0vz3K76+OiPiIdvmPVb/h3qeo/6Dq
 fTP4mstJ
 zE/TfqFMA0DT1cctrNkCHQCtvIMuQizy6PNvWouHq/QEyyKOsWP+X2Sp0vBGNPntfOmjigc3ejohtTqoO4PnU3aGbQ6HvZV5rKAO0ljwsjAvvB0ih9pKOpw7StbEk+T0eSIdtrh8BvSl8Top0w0IfYLJmzhAoGpHm94lXvez0BwzGqWFvvkg19ckyDHgV3aL6Ppjy0lxUh5Bk2+T5NIuFmwDFW0+RCeRxNYkSNoT1TqVtPD4UIX8T1NbC9/6hIERQyk7EQ71QnVgGtnqVmiEDZjcRJk5md57A5uWjiRSX6Q/GdGHM/5h2BZbguafwWCbHmrSiMHvT6K4tVHdD0qBZhh7KqxaQMjy/gVkylVdQrlHwChKLDjo8W+DKvhiMexRAW4CG4TeutJ8iE3LQB1SMBHrQThAV2qBvvEgg5newf3N5h3n2vPPUD5SQErWKXNNqFTffHNnoG0bsSLDuClJOcXOpGGdoW9RkikYmLVF7ZngUWHXIUOlS0M4RAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Initialize selinuxfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> SB_I_NOEXEC. selinuxfs never holds executables. SB_I_NOEXEC also
> refuses PROT_EXEC mappings but the status and policy files are only
> ever mapped for reading.
>=20
> But selinuxfs needs device nodes. The kernel replaces file
> descriptors
> with /sys/fs/selinux/null on exec via dentry_open() which doesn't
> care
> about SB_I_NODEV. Android init however opens /sys/fs/selinux/null by
> path as /dev/null doesn't exist yet at that point. So clear
> SB_I_NODEV
> again in sel_fill_super().
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
   I.=20
> ---
> =C2=A0security/selinux/selinuxfs.c | 5 +++++
> =C2=A01 file changed, 5 insertions(+)
>=20
> diff --git a/security/selinux/selinuxfs.c
> b/security/selinux/selinuxfs.c
> index 310e19efff1d..d7ae853b6d68 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -18,6 +18,7 @@
> =C2=A0#include <linux/vmalloc.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/hex.h>
> =C2=A0#include <linux/mount.h>
> =C2=A0#include <linux/mutex.h>
> @@ -1852,6 +1853,9 @@ static int sel_fill_super(struct super_block
> *sb, struct fs_context *fc)
> =C2=A0 /* last one */ {"", NULL, 0}
> =C2=A0 };
> =C2=A0
> + /* Android init opens the null device below by path. */
> + sb->s_iflags &=3D ~SB_I_NODEV;
> +
> =C2=A0 ret =3D selinux_fs_info_create(sb);
> =C2=A0 if (ret)
> =C2=A0 goto err;
> @@ -1955,6 +1959,7 @@ static const struct fs_context_operations
> sel_context_ops =3D {
> =C2=A0
> =C2=A0static int sel_init_fs_context(struct fs_context *fc)
> =C2=A0{
> + fc_init_pseudo(fc);
> =C2=A0 fc->ops =3D &sel_context_ops;
> =C2=A0 return 0;
> =C2=A0}

