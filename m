Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523BA606A329
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=A9SqFO2H
Received: by kanga.kvack.org (Postfix)
	id 51A306B05BC; Tue, 17 Nov 2026 03:32:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1D56B05BD; Tue, 17 Nov 2026 03:32:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407C96B05BE; Tue, 17 Nov 2026 03:32:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13EDA6B05BC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:32:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8A580A7D83
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:32:26 +0000 (UTC)
X-FDA: 85443944292.06.90BC8D2
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id A623480008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:32:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=A9SqFO2H;
	spf=pass (imf02.hostedemail.com: domain of alex@amutable.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904344;
	b=GIx4BdI8rpPKAPUiXi1WzIY106hXVialzmojLKAhNXtjFXJ9PPOi06IutgGbVpWi8Sn8Cb
	ZDGQvxO+VohnHP2EQNzQ+NdRQcQqVDACszAi/fayQG0aW7F7uNjma36yFRHRcr9of/+RKz
	6Insu9tUwzbaxi56vHkuuPizckMjxU0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=A9SqFO2H;
	spf=pass (imf02.hostedemail.com: domain of alex@amutable.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
	b=wZ0blAQ7qv/UBF7NwuvBrIK72u4zg1uE3BVF7cG29w2awO3DMthXAaKlkWMfvV01tT6MJ3
	Jzl5x1AXC+nAeyi48pH66pLwfO+N7hNbGff+HSXRZwJjKVz4F5jBUyfXCbwl4ctJb0N54B
	uIePL7Ir5uV0+iglUuYCpLVWPYdFKeQ=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-49412eb1474so2235569f8f.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904343; x=1795509143; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=A9SqFO2HH1gGsrYVTXe35tsTKj/+YlVl7zvPJ8fUk/2ewKwYitH+PCYEDEaBC5o979
         QhqHC1SxllsAQj+otV139i286NQxbQNA7KbyAmep+B1s4ahs3iUuMPi9pVJi2u9vcNWS
         5b3sRaMY4SqftdyuiOpnG0qCaGFw32n3QAGKvzq03fkkelSw8N+qAazD/ghITPKKCVL/
         lSJmrLvurkx00VcbqZa+WKHI9V3YzrkW1Vdvlcot6Yfyx72EY7jSerLBGVp90SMw1Kie
         RPbemGozdc78aoIp4Uow/VT3tz4W3DNoeKpdkIDwqJF5cGdMVrWI6//Wqnrne6t/usGK
         PDFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904343; x=1795509143;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iGZ2JImQ8AaSp09QdDpLN1PoylGc+Kk+7WphF44IQ4E=;
        b=C8RhX+44iPAeLtknpwOcQ6a5cSfNHKwjHD6FFwvmE5xEIHOEahjsb01XgsPeM8v9oO
         M4T2fnU8o9YkrgKTPDG3+xrM18qYLTFDTx0nvHXjxCHWycNReXXCBZ1mf/nC1ANFBzaj
         yc+x/AKSEXOO17h0KQa/IODgCYBrZYooWbTIYvFfJooAJDqgNKhYGfBtHt2/qCpAkQjO
         baGJd7+I5T2q0BvgpLQXTrStq5jonAcCvhmn9CDD6uNzwRhsMN8pBddPGSt2EgHs3nHM
         i03gc7mr+kulddZec4lerqkgTuRR71UGbr+r7lKHb5SnIsJ3RJUEPeA2e914ixBFGPZL
         OJMg==
X-Forwarded-Encrypted: i=1; AL+hErHVUZSLjufuH7dz80DHa1Vu8PXNnaMfUjZx8iJ0Huvko1nqbU2DussApDNIzXCMn/XMFESeKhel8g==@kvack.org
X-Gm-Message-State: APuU4Z8/botFFu8xzsHEKv6V3IRlaM0TECokgsnrehVbIny0lOwoLK5A
	pvcA0zLRPO1WKlE7PmfK27Mwxet6OPe/lAVenvdpfDd64RMOLracFwNLjH4J9ZG5ASXW
X-Gm-Gg: AZFdTZcQb/w96YF207SZrijMwEAO94SKacDqj6vBASU+ujNSlaYRFvWWH8O9m5D41Se
	O1DC3cpRZL6zWpmfE4pxqDueUFjjIfrIoub+PvkHNlAVfhJ5nsI4/lVZlzuvHXai7yC1n3WxrOC
	2MhE5gBg8f5l2po8J3HiRJyP6WTpD5wh7E3y6S5DQ+XQJ1bBv6uqIcDXe3piiI/z8AZKeoOQpH/
	EuZHLLxqYnwu+E/AUHdRaTmm5devXWVHFZSBIZFYnLQxRYWWD2h8E1tMKRYB0Fk4JnxtnWFafuw
	KiVDuR957448fp7bHR/iqGxH1NzZOA3yfmolcPfoMfKHqZREOufUp/sxE0LhvH0VVyIADPKkDBR
	9bANDB9GCbCOx1fTCQ05tfsvxRj9GBQcrUGAYfSJVIja14OZE84H6traq9gHEldLB++f+3oR6h+
	jg1ZI96Kk38rtcMKJBwwbwBLc+SERWkASTnT3sQnmCYRnHoXI3dxOYpDm/NB2C7Po5u3PMOk742
	955xN8lrcm0AKK4/Hwe4aG+ew/BKmtB5LX6GNEH+dJkiO5C6GShEf4mXVM3ksz5hcn6djBcO/nE
	uaa+EWnLlkAzLFKARCWMBhHIfAOxM4phXQ1gguwRurB2qS0e1j4g/3Mifvm0bYUXdPnrE/PpJZh
	K6SzFzaXfR8SrRVpnf/1CFX4gxh0bqDMOPZpXlXj6ZA6BxD0vHcyom8Qa
X-Received: by 2002:a05:6000:3108:b0:48d:f9dd:e3de with SMTP id ffacd0b85a97d-49c7353c415mr27089117f8f.45.1794904343236;
        Tue, 17 Nov 2026 00:32:23 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c608d10b2sm43646659f8f.44.2026.11.17.00.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:32:22 -0800 (PST)
Message-ID: <fd39200976086130cc82d59699a988fc3e0689cf.camel@amutable.com>
Subject: Re: [PATCH RFC v3 27/44] openpromfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:32:20 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-27-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A623480008
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 96fxutyspsjzybfgr973zkujxf76in54
X-Rspam-User: 
X-HE-Tag: 1794904344-784237
X-HE-Meta: U2FsdGVkX1+D8urjj27UHDl2+k99iTurfPyi4Llgla00KVmQeqJ8Qo8eaRFiszKDwplnjxWv18KUA5R/Batb287R8iUL4Tk3gPveT9gGFNNOobTHQhlDaX4Uy3VrnanDqhbEkbqLTrDpbPKJFpFMSmuGvdIkOmdtjE4ZwJQKtOpoA89iz6PWZ0C+kxhBUMzgzotPTmSwZFOMV6g8pSPFodxKTmE8Q8AypRmdhyflYmgxguxLRnGJsArunRs+fOsd3cWLqfTyrsJYHA9OR8/qbSphNOkXeVwxv6hMKHezHXvhanMUEGzZkVQr0iXZjgIlN4LlgISyehg6TNnzVwObp+8B4NhiXJyVyybGx9PANYihikvjkCyW+w/prpdk2irmS8o8QAvfoFs6e6IPB/M+vIILL/9SAxZsxiUr8SdvZctEb8CmHKzsHAXjC7/yz2Z5XoykskCTAcO5www0LPaJVtqayzHS3g3G9kqJkJpJ9ClSSeh5ynqdzGpAHXSbfqv7plgLIvxSrgyQ3cvIBwVTGPxP8Sk8MsLDu0msxiV4jrPcxUQVBZ93l5S7sCS04xh+7VO1AbhB1omd2S+Fovj284sSHqwjTtd+FwDp5C8CAVRkmIFOhV0LkjarNcgrEEwSp9FRaBGugW02lTG6n33alDRY2aFwc8PPT7RyUetAkKrtPiXIKn4vIvpn6ie1Qijz4utuhuhKpNYzoYT3Yo4TBGKub3ErZ/ZF1qd2bJtcKe7GaTlvIDT+IlLLgA6ZIPHaxqVPE5mSS3LKUmAC+F/LT72+3HM0s4t1/v+AOZwo2oMQQdBSuhSIK+AaOicBJ/taJYWVH8Hry5TPMw9i5fpeTW6bT0VA8o5L5aYgUOEul/75PzCv3nyDmQq8l0X2DwHaDdE9mookMv0aSNb9tf37oI1dJ5P8ZbXcIwUNPSeIf4x5o+GzdnIedF7oGmWT4jc0FpCjlu3DAw+UT8N9MC4
 JnWMFGJy
 EdcncAdWZAeH3qUuOVDa9xv6ASRticqlzruFE/B7nSiT4+K1nLgqnEum5FDG/CHuy7/81djF3rn13sn7NJa+AYDWRUNasSmny4jPpMS8N67hdCJZ2zkLDS0yt8rKUfVjf1YDFD9zMNoiPBi6B1J3QPuqzEoq4zyQ9PnnFNN26Nddp0v27OSiSrtvuu6Pcy3voTLY7JFfm6cydU1m8T0nObV5ffKNzuz87M6ohM6Ysn5qq71NeEIiE9ap1P7SWtteWqR2KZprTrfnkL07zC9jmqLdNprF6GK4iLR3tU/JQZFNKqkPGjZMP8j07bO1B+lbQR4c/1Wr6SmYrEhQCla5QFLSFhWw4IQmS9CInyhvZZJQCPCSqDd+q3fHSPHukSNDW3X3iD+ncj4lyxrXIrrGGyVqfWa3/lH+1XBI1dKISI58/SkVicYNcJRazZ9NJbLUCQQNXByPN2g7Q05D8tCy66T8UJ+Ojo0I+QD40SgDysJaJ0QkeFr5fRQtUHoSANj7hnewBXG6Hkonehs+iUp/jlBMXJ3x7wTXJUcALoxd0sBMvOV8bU6u+fZ1WL20mTTW50u14tAFKbwUR90Y1ZEQZoPcwQgS1BYg0lKMSu5Fhml4zAwbjofbwIxqBIcPxL6rRuwBnhzdTWtMgmAr2fBLZRlNRwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 12:05 +0100, Christian Brauner wrote:
> Initialize openpromfs as a pseudo filesystem. This raises SB_I_PSEUDO
> and
> also SB_I_NOEXEC and SB_I_NODEV. openpromfs never holds executables
> or
> device nodes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/openpromfs/inode.c | 2 ++
> =C2=A01 file changed, 2 insertions(+)
>=20
> diff --git a/fs/openpromfs/inode.c b/fs/openpromfs/inode.c
> index fb8d84bdedfb2..6cd02d456bac9 100644
> --- a/fs/openpromfs/inode.c
> +++ b/fs/openpromfs/inode.c
> @@ -10,6 +10,7 @@
> =C2=A0#include <linux/string.h>
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/init.h>
> =C2=A0#include <linux/slab.h>
> =C2=A0#include <linux/seq_file.h>
> @@ -419,6 +420,7 @@ static const struct fs_context_operations
> openpromfs_context_ops =3D {
> =C2=A0
> =C2=A0static int openpromfs_init_fs_context(struct fs_context *fc)
> =C2=A0{
> +	fc_init_pseudo(fc);
> =C2=A0	fc->ops =3D &openpromfs_context_ops;
> =C2=A0	return 0;
> =C2=A0}

