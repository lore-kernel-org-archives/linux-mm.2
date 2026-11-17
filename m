Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ADBF606A88C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 08:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=DR3YvcDv
Received: by kanga.kvack.org (Postfix)
	id 5F99D6B05B7; Tue, 17 Nov 2026 03:26:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1876B05B8; Tue, 17 Nov 2026 03:26:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB026B05B9; Tue, 17 Nov 2026 03:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2797A6B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:26:48 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2D5F16037A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:26:47 +0000 (UTC)
X-FDA: 85443930054.21.78DC6F7
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf15.hostedemail.com (Postfix) with ESMTP id DABC8A0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:26:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=DR3YvcDv;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of alex@amutable.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794904006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
	b=72InFWrlVPJFp0xwpAg+RDOWuAgwPM8orfqljEjsJrzQZH7nzLnGIRaPuF2bDH+KYHA5UE
	zCk14dTfmhx4kfZqQyflsm1ZXxEOGu/F/ngJawIP+JgP82c/CEX0oGkJSjs8iUrdyxyjX+
	zOxSu6kfmJbmlVrzCuD5BABIxD1QfYw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=DR3YvcDv;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of alex@amutable.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=alex@amutable.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794904006;
	b=ATvdiNQ7Uvryx+QUp2+ucHkx4p6aqNb8UuO7KKB2cOEzjWN0ozTcGvGo7HviBqD9LjEWUt
	D89LUOCZA1ZJxY05a3BJ4++NM0DpjFq1FuQNykSv4rUkm8W/boLFHnn67dnQFbJFc8VRMV
	sYIYxfnE6VJFZ4zN3/UUW4CIoqescwA=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-49412eb1474so2231630f8f.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794904004; x=1795508804; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=DR3YvcDv89GXEqB3BBJsVfqbHGRDKLJtRfG5sg/86/efBNzdD97sLLY+hr3JkJD4jQ
         Z1OBxgo9mUuJY7WkoJuw6pkIRtwANH7wuWztdeAYHBYhmg8YAZHQo915kGNO1sbg7W8n
         hBTuZ0zoZPUiywqeDHCpd3ph9vsKYAia84Q8f4veOQPgOX/DMss+1IyLPmOJiDouIG/f
         4HRSx62oJAEX1GZ4qGR8ayBIqCoSH85SSLOLxC/tynPyMq+r1wyH6i5ExFbi99X50OMw
         M8WrxqHBX5rZpMQyWZn0ynnzah7Zs8/GrBXKkDe+wxzL8Q4YMuO1vT7nnEdtlDej9H/h
         KSlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794904004; x=1795508804;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zuUcsMvbqw5dxN0Fzu67367bPJAUtTqv88LLlRQCTVU=;
        b=k/gH59qDOMug68zSfxIx9dN7cOHhO+OHJ+gaxMHEdENvaVvZq56xIy/QFoH0niom/f
         Opl8MD1FnREl6BSnMQJ420ohXcxHcTqkK3wEtMkUPweHPpYP0sRuZ41nfM7n+rMf+R6b
         cSs0tjEGfwDAGFQgkCfSTw/eC15Z8gk3NokBFsmQ41ysuHQLAxIz1qCjy12S3Vz5RRwg
         HDKCRQPps4Hyst093WWHMog1i4lr6LgWzz+uAaRm9Yfxq4fukPqvQ7Q0qn/gyWBH6siT
         v1drE+EfGudBQ6HcTgfldf1cr48F0aQfGU1mqySMB3Vqbu88L8Qg7ap5DWUl9w4HvnUU
         Fosw==
X-Forwarded-Encrypted: i=1; AL+hErGfdxduemkWulWA3OYEfy43yTcQxcRlDeMIHWB6eX5uGJ5SUdX2A6T4AIdlpSKfXFzsGvGJcJ3eAw==@kvack.org
X-Gm-Message-State: APuU4Z/LqL1vk1Z0RKSytuc1Y/mBl9JLk0Yp6LBQiyWD8+kDckb3PkRw
	oMiQXsgxf7fD6juQSDANrQMWrF9SGNxzH4M4sTYZk3GAzyniBavSyYlppJZC3/aVLM/9
X-Gm-Gg: AZFdTZd9ZUUWTe7OF0OXs8blTDeIsemOhQTJU3A6WqMwcMlJNcDrLsYa9Bm9SZ/4zcJ
	pVJWZRb6B8ELc5FKL14f4mfnAI1ZdX+1FvJnvCfTEPSCbHzNObMtdBj+NH0h8/Uo8Dy7Vik8Oor
	k2o7+2oxgpng9bi5nOvNkrq+8gQ8giWPglYVy3v5GvRxP3c/30RHx3zVBPLpEavEaQswNNhGbQu
	iGxsQrToEGuUeRh+nTx3DW1vtnDccAQt01DNMTB6cnBj61Y2w5Rv3ga2SIrIzKANtSXnBt7oV5q
	gI+2ejG6TE9ZRuefPwvpDum2AbsZL4eJwdLamhbJ7oqTdAuvvaOmqlEtbAE3pYGzi7h9jLpj2pj
	u+yZPp8LZMsmIZuJXCIRh+VCDs7p9QUwO1VdCJnTCz2aIQaqbTjcHrm7Lx1q17IQc0N37Vh+zcT
	DISm6u50cTXewgrG3Ge5YgMoPMsdtbpqXy4CCeip81WXzTk4yQN8Ls7x7nAbgsXTy9oa2e+2GSo
	jN4cgkQ7etZ8w6gDpPXxdRSYZo8rDZexLO3e4dHbgKzIpZaEW3hEmiJfB7yYJ2X42rHRR+UCx70
	T79c/LwMGGRExnVfhAQvScmKp7UxutiFkOKMySg4wzgIr2Y4xAHjIe0UWsTb2tyudInh248Gbvj
	pY92NuQjh90E+fjPiT+IXOs84aPxyY+KUbOhidTsbSxJu38K40KHTnOz4
X-Received: by 2002:a05:6000:2009:b0:4a5:2e5b:51c2 with SMTP id ffacd0b85a97d-4a52e6a947bmr243585f8f.29.1794904004601;
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:de4c:6789:33ce:97c2? (p200300cf572c2800de4c678933ce97c2.dip0.t-ipconnect.de. [2003:cf:572c:2800:de4c:6789:33ce:97c2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a4de4cb1c3sm977858f8f.8.2026.11.17.00.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 00:26:44 -0800 (PST)
Message-ID: <c43d70badf41f62f8e149ac024bab3df979fa756.camel@amutable.com>
Subject: Re: [PATCH RFC v3 11/44] failfs: use fc_init_pseudo()
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
Date: Tue, 17 Nov 2026 09:26:42 +0100
In-Reply-To: <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
	 <20261116-work-loop-pseudo-v3-11-8cbbea1cf34f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DABC8A0004
X-Stat-Signature: hwugbtk3dwzxsk8qfq955adcmdtbyeyt
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794904005-564682
X-HE-Meta: U2FsdGVkX1+eYtNhPLct3WlG4OqsrC2OUnBaiQvxoD6mAq1+30JAmyEST7GCRUIexuRmjYowFTNaZhmx9vnA8KegQU3gpNnM6LKvLB1fWJZQrybEiJeyxdovBKKAXnTT+cQaL6D1dfVqrh/DGsP9f0zPEGJLkkz4OZT1/x64NJ37gvLeqaqPLfRwPx6z1n9lOmZKxfOdGHjdWMzlX448ar4/wp1GE2FvgQYrjiVUvfnPdAkfKVFTcnfiHGrdF/iP/QHDp6PWGFhNq3cSnrtiENlegKWIuNP9MEUsnwQRmESq3bRuj8gnEIP7c8mVvfENoXoOsTx1Kw+SED0GgbSrJy1QseXwyuhs4ehqUJOHHeGuY+Bl26RUIiWErOBRWVINNt8uT5nK+Js+BWwBEyKFO1hZ6hlmbDBWDEIp/JbqtULnIDLnOG/D0NNHKP9b/Kqe94WVHhWQTdQ5XWkeKN3auBdTtZgbU1VR08jHQLJHshEqrLwvnV9YZTRzmaz+GULE0M45yDjF7PTyWlP/0IvEWzx1TzsCSZwHH4a4Mkcu9NTgMsMgMmgkc3gYpSq7RoZJdOKTbqG5pFL+CWaDjuESOB+eQkqSYdWl4XeefcINZOw58OS9EmtWV9YHfgnXKMX7d/vFz5CdQ9Cl8Si8F2ShgQayvfiWRij17IkezwAbrqj0dQf3ZTwC6yp2RLY6fWzrr6OcnK/XNVtE7nkK4YsilqDrqPTVAfFVSWVMo1/0uNPTOJ59fG28Shgcy+SS1vDtoakyUauuKo/JhS9hsIe/NSy8rUNVmuKdYIi6sPsWW5+d0Qy8yPsj/Hh0ajMdAzpFoZ12i8GmOZ7EUpw8q+aiJkmocSN1L1P2Feodrs6tEomwQBscNYyStfrBsYCoESWru4NMK776DS29wd/V5Efc8wgCewhh44FyODS2ZSfebx7D7LQ1elhtwdHJxb2tD7+UrgRnaxGslUtIMnVgP0m
 budmRW9y
 Lim6tajcXN0ZNJh7YNfK48l14b1y86Q4Vtvz1L2/RvXXBGY7VqAI8apfn7fCLdw1Md5vRVgp8CYBq92ajZ9xIhAIGLF4bOUjY+wG80oUj9M2QYUlBqCAVWVMnOwXnVJJVtd0/vFz0kRyxHv0uBBn6x6tVo4WO+Inyn9u9i1ZaI6NCXR95vzhwl9bhHUGFQUKgDIOp9CIhZCBqJRNicFb0rJA7PtUc/qOPmHjwH2UQdzMWv0GpJyCR6C9JSo50JKAVo/SikR52UtRASeTnFi23HIdpzrHSiUUQ+KpLrfwvbKs+ZWBQaqJQr/zSbAXczip2aZrX/Ckzh3F6xH63QfZZv0KpEgqe2Vo5qYLACLaRBCKErrzIJZc+oqkwsEyZF5B5Ut5xtjbu6I2HjiX4ABGpPgzycgxIERxmTE1mXmfwCBovoGEW9GaQiaYKUNJL9RuKAuyBff00V6zLO3YRirx4rrrPMHUK90jwC8pF4NrsE+sRfWMaJeLlVoXGX39E9ahZZiySu0rWTMCVYdwnIy478ZicB+xPxQDNAB13
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 2026-11-16 at 12:04 +0100, Christian Brauner wrote:
> Initialize failfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
>=20
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chris Down <chris@chrisdown.name>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0fs/failfs.c | 3 ++-
> =C2=A01 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/failfs.c b/fs/failfs.c
> index 437cdc981c2de..f03334f361c0e 100644
> --- a/fs/failfs.c
> +++ b/fs/failfs.c
> @@ -3,6 +3,7 @@
> =C2=A0#include <linux/fs.h>
> =C2=A0#include <linux/fs/super_types.h>
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
> =C2=A0#include <linux/fs_struct.h>
> =C2=A0#include <linux/magic.h>
> =C2=A0#include <linux/mount.h>
> @@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct
> fs_context *fc)
> =C2=A0	fc->ops		=3D &failfs_context_ops;
> =C2=A0	fc->global	=3D true;
> =C2=A0	fc->sb_flags	|=3D SB_NOUSER;
> -	fc->s_iflags	|=3D SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0

