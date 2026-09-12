Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F37C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 13:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6536B0088; Sat, 12 Sep 2026 09:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7576D6B008C; Sat, 12 Sep 2026 09:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6471F6B0092; Sat, 12 Sep 2026 09:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 375466B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 09:29:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F9F71A0440
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 13:29:41 +0000 (UTC)
X-FDA: 85205192562.01.FAE3908
Received: from mail-vs2-f5.google.com (mail-vs2-f5.google.com [74.125.227.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id 20C10140007
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 13:29:38 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ouENGM4z;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.227.5 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789219779;
	b=3GPYkeA2E3LSzATqQCkoSsFNNHoSH4FAdgiShYnBXEklQZioI4gIBa3m6D5SyOsCFLfBP7
	F0PMQvoKHzcrM/4DrAvoXhISgHxW9YtovnSFSMpurlUaSAWK5Q65M1K5zG41TNdiN43POe
	zUIzbXENz7DCJ3g61aGpuDTDgIJUfxQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ouENGM4z;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.227.5 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789219779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dLw2loIG/Pp0pl9OY2tY1bLAD5HMO+AaOJKL7LkY40=;
	b=ES1GxAzj902pfteRfFfASl0MSeUbX/pdZ5QMNXQ2noDpsEawlfWgE66OrYX7kabKtRX31u
	HPUrFdFqejpsRMbq32SIxMArHNrpO10NYC6fEMTzYZMrkYSTHLO4m7FMOeK8yfwr+9P3ys
	k3U8VaPCBqMGaBRmRjbbVAtTvwxsXTY=
Received: by mail-vs2-f5.google.com with SMTP id ada2fe7eead31-78333cbe5bbso1580571137.1
        for <linux-mm@kvack.org>; Sat, 12 Sep 2026 06:29:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789219778; cv=none;
        d=google.com; s=arc-20260327;
        b=Ze8jUANvz0meVbTlMWBhJFjWH/2A9tEpOCaUHLDuLWZzCYqzm3ddv9W8IDNEPNrmQn
         k94nrJpsKdi8HnqpWn/xF4isoV22aomC47W77bGvGjmE8Ud0rOrjBTBj195kY4Zef8PQ
         Qh+qU5reeP7DWsaSNVhSx5s+gieJkGVve7KHHuvW+euy0dchefr7AAKKy1kNfayk6Geg
         Z97AwWjy1vjZZhCVrm1lqAnZmKhpSt5mFboxzLjBbEYzzY+/ytME2v8B5JZUhYUYHJ3J
         I7k5QBTAOiOqe1GAFXzAuEp388CVj6wwRYIHP3TQghQ1gJpcatkgzJDb9NNf16L1QLaR
         lR3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5dLw2loIG/Pp0pl9OY2tY1bLAD5HMO+AaOJKL7LkY40=;
        fh=Be/mV0NNa/Wrh/mqCw9HEmZt/aOSQjGALDWaBBD0Bv4=;
        b=LoXHxUgVzLp1DtUFM+5Xxk2E6beV94sHkeDXbrFW6fE+au8FMnVPbgDP7MWXOWBzPf
         53r/ayIPAnHu4o/5Lg0rKpwiIsx8UfTynsfFB6kXhpK+eZTzFPHgSjW00kLDH6QPsABA
         0uhPVJ74GIz3N84apy2jknISm3Ykzdx623BAYLyLOPPlo+WfJsZ5A30XPfuEYEKzb12Z
         9DS3/1sx2ebWThSQdcPQ7n8Kg13H4rNqs9l+0lSr+RYCyXqgaLd6SIdYGP70NnPi6HF8
         zQ55FKLrWNEgA95aYfCZF1Az8au0MmsosH0wtKy1r1L3uf5aQ/awpmP98xoGeDORkr/r
         mRdg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789219778; x=1789824578; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5dLw2loIG/Pp0pl9OY2tY1bLAD5HMO+AaOJKL7LkY40=;
        b=ouENGM4z5oJTO0O3aHP5xdeFgWqK6907w0ZNzcsLzodTk5ITz3vvvT0EHNasMtek3R
         /gb1V8jX6Lc+pn8xsPH/p86GUGBGM6iuehlXR1gK6L0iAkHkvPEG8/6Sp4miFTf9cFSE
         S2bbR6qeGfgWHibhi76ZjH+IF1Wt3Z/Rgg9m0n7BcitbUu7dxYenYasbSIi37HsZnq5Q
         FD/GrAUFZVEuqDTz10QPVEdxrXJ3/wH3evcQSYQ5wh5wG7Z5u3VP3bBFQAhhtt4V6ckZ
         9s9FvpKN3dBVV9UzxqJkmDVdNrQ7nEPUTY3WXH8ZmzOem35d2EOLONikp7k+0wKRYpSN
         0zEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789219778; x=1789824578;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5dLw2loIG/Pp0pl9OY2tY1bLAD5HMO+AaOJKL7LkY40=;
        b=O0IsZ1qLyN6e9p5eLj5IbUHco8tNTucOSuOLNvKSp09sicPgsfbxyCoQ9kJypD1Fj7
         o5ENqMQrk+Is6gCVOWRdj4Dvut8IHDMCrNePmffg3R03KY2qHH6eBSqV/VxErwAWXo/4
         VtAHZbOEjYvn30K9Yz8tZ8AmtyZ5De/jWU6YSML5B+D5VRigD1XgG80Tt2NNpQGqNsQV
         29l83FN6jRBrLc7YEVXF9e6jAqm85dMmidsi49K3t2b5pVA5B8xixB2nuQivkiJMKB6I
         OfUkJIoiYWpjy77Qd88pwInnayR1xsnLeymCLrTGARatNzlA5HUYDi44tEMYBoRRnwKQ
         PXsQ==
X-Forwarded-Encrypted: i=1; AKwUvBweww9/ipaDRIoYVlaOCQKmkLLLIox0LdVkFUUZcP0FKbHH1s1Qp/CjIrIuVKy/QtT97SnOJxg+vQ==@kvack.org
X-Gm-Message-State: AFuF++kGGyl3RLKu8z0UqCP13tU3V4sCS9lmUnDOrO/dYNwdl4akN7QW
	mEGFC1bWqc3PFeNGMuMpNx14bRdFtIjjAgk+78YFlMcayIaVvLkJuk90DkK626kNc2MY2o9mlZn
	/k0ZnaFWvWFEJq21iOFyvZsYkG3hlItM=
X-Gm-Gg: AYBFou3iHhXLJrW9WyJYds4rmbaXbBEQ7yMuOPjUW/oXiUfgJMgt/7sXhf3EIKNUY36
	nso0ovRk/OLi0MC4aAiVMtYRDsev6VKtKADbF2JfrXatzQ9ziIfZ0kg80m6g135mP87Hju3Zdmv
	EXtGcloOuPgWobl3AfuLZ5JyxmA82WHvwGENkhI+dbeWtSW98Vui1ZECgSneH4eIzfgZkHu2i0H
	deqMQ4Gf0lBiFt30syy/BqeOgV26VuaGOwu0gEfTq8N52zPYp0n2h1CHtmFouUG8WcMbdyn8OBu
	y9qM3zngpCrYjcfhEDMW1V6cqTNDNOHJwyzcB8l0m8F4Fji8KIYgf5KwA7t1xi4oUfZoRTcQNFt
	WSKNjtRIP7ufeGHiBdqX2Eadr1nXEL4z2yzKPZAN30rQuSw==
X-Received: by 2002:a05:6102:3313:b0:790:235e:4209 with SMTP id
 ada2fe7eead31-792edf64392mr4768111137.12.1789219778089; Sat, 12 Sep 2026
 06:29:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260911124517.63714-1-jaeyeon.lee.dev@gmail.com> <CC87B3D6-D5BD-42D2-B84C-47745ACAD0AA@nvidia.com>
In-Reply-To: <CC87B3D6-D5BD-42D2-B84C-47745ACAD0AA@nvidia.com>
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Date: Sat, 12 Sep 2026 15:29:26 +0200
X-Gm-Features: AcwNN1Wq5ZTrxV3k1NjhhPK4dlwMKgsnXpdc_cmQ2xjSE7CLbOE09_kryz33d1Y
Message-ID: <CAD+X6aA=0f8mLN0j-h3tqHCRAq_pi4Xp80FUA6GcZVcZa142-g@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: skip khugepaged file tests if mkfs.xfs is unavailable
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, david@kernel.org, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 20C10140007
X-Stat-Signature: wi9c3surc8poh47c7zt38ogt3sbh5e46
X-Rspam-User: 
X-HE-Tag: 1789219778-400984
X-HE-Meta: U2FsdGVkX19JhEk05/xVXjdS990+ufZc7ymDwl7KzV+aOqCWVWq5TYytv7ufipKGHvK9+Wcvi6KWO0WetzXQyxc/3BCrFZIrzMdanizr/AptR4Xnh/HjL7u1ToDcjYxvAo2fCPmBvBtPRUd5NBnBdCf98IfMnJGDLw2vhrWij3uotiTQ5UeVfXAsX2wcIhiulvCtNDfnOojCLiNkmGlrgoMANWHNlXv60hrl64WoIj/tOR20LqVtojreUGfObWzakUmj9VysEQJMjVSWWWmJzrkb+fNA4d+kOlgix4igtPslgXl6PkdSgmonraVAYrmE2CsLSiypLlpXxnzwuTU0thh26V2SEbLysPfjxCq1zOEL0oWktHlvoxdOfFuPFeYLIhKUZS05z+X70R8SQGthjBeP6hOienxCf4VK4BNi7PoQK3f7zoea8RptEddDnXwOwRDIt/qyFDzxC6DgvrKJULq3u6zJXROnYaM7yqUkNdpNaJbwEEMvWWieX8WnQoJl7wi/DKQoquXlSrWlinXVIFQLVQAXtAaWIHYoYZpk9+5uSyIbdUBe0MWNwETTP+G9Qf9BoLsTleJu39MVC358XtEbFw5i/o4G80tPosvfNhdjf/rMb9eMjZwVv54ltVZJt1u6vCtTGucr0k2eu3GuQPs9lSztJ2t6drwZ3/p7tIi0bd9b/AF4rxsCR0Mz/poR6kJGmt3I9HQdndbQ/fwY2nRKRG0gnXFK2t0A2D8Ly3iE/QJnuRzuWu6GcaJX2l09iHHhcQwfNvvtfHWxzSK2V/4KfiO7PfXBU2LmpbI333h7FP3TKy2RfwW4oiPMp87p26XBJcIgnriTL8e0xBnEIviq5/Kvh6M+vgsmsPS4WjBJF2to3Xb+XL2d2Mtar21OJa0EbBYvoVltUPqSBiqRzEe6yQiYQze/iqp1L/L6ugyutK2TFfDUE6FRbBeKKwpbmQO3EFSQ6lw2yecSIyT
 0yx7B0VV
 /eIP4YwLjpiZfdB0QB1apNb73URIeuntM81McdB/293zZFc8y6tIci+F4B8zXDC7PksYSP8dGieBKFU3whcrxny3nmF8cz1GmleRcTfp5eU5w4ma+C/b+wSzmyj2sd+cgdKogJhcYQpkS4qb1i+8S4YvPIhLubTytyfkkgze0evdtABHwW4vLcRhWnl7Jvf1QeQxTPms1OJ5t6AGGzgS8B1NIfn9QJGuqciC/Ejq9BxyCn8s9xT808x/VXDN3HF7EKK9yVa6pbOC7/4+ut1mll8QYQWq9jhShB/8qeQEWluY1q5rTNDNoZdsMXIYgro4c28NM/s6DLd7naXRYtf6cAdV44ON8AM2a86i/xHXEFXGuoXA09GciK6D8uw1ejnaOR1IXC3lpNKEK0drH31S3wqc0CsliLeGy/110QvRaL/ffX25ZW6eqxOKLU+UY2l3zhEAd4Rw0NMi60Ic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 2:06=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
> This might be more robust, since it can detect mkfs.xfs and mount failure=
s.
>
>   if grep xfs /proc/filesystems &>/dev/null; then
>       XFS_IMG=3D$(mktemp /tmp/xfs_img_XXXXXX)
>       XFS_DIR=3D$(mktemp -d /tmp/xfs_dir_XXXXXX)
>       truncate -s 314572800 ${XFS_IMG}
>       if mkfs.xfs -q ${XFS_IMG} && mount -t xfs -o loop ${XFS_IMG} ${XFS_=
DIR}; then
>           SPLIT_HUGE_PAGE_TEST_XFS_PATH=3D${XFS_DIR}
>           MOUNTED_XFS=3D1
>       else
>           rmdir ${XFS_DIR}
>           rm -f ${XFS_IMG}
>       fi
>   fi

I'll send v2 with this, adding a Suggested-by: tag and fixing the
Assisted-by: tag format.

Thanks for the review.

Best regards,
Jaeyeon Lee

