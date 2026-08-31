Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB566C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBA256B0092; Mon, 31 Aug 2026 04:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69D46B0095; Mon, 31 Aug 2026 04:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58DF6B0096; Mon, 31 Aug 2026 04:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 974F86B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:18:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21B35A3F99
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:18:48 +0000 (UTC)
X-FDA: 85160863536.15.096A1F5
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9D16A40005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:18:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=KYiOkET7;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.169 as permitted sender) smtp.mailfrom=miklos@szeredi.hu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788164326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xkiZoIxNervah7q7cypbGBqjGwr4LoCCTOgNZ2t/KAw=;
	b=Iki+Gd6cS5DWMY/HF8XbBkcGNefRiHtQkPFSMI82jUxb4kddzWFjp5OIufhGkr9YeMJxyi
	O7t0u+4gta0d+pV98l7ITvrPj0t+LgOpoRpDWQ/jtlUyHfbuS0MkTovh5cEDvNaq7E7FaS
	AmQQlIYoSj9Cz402IOHNMDXC0u+R6ak=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=KYiOkET7;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.169 as permitted sender) smtp.mailfrom=miklos@szeredi.hu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788164326;
	b=MUNbUc8IO14vhmbNk8gHqYBUPkwwRT/BCcGVmtjcTNsYFwKui7XljEjkE6hASNQ6RflZTs
	Sn/I6GGwR5oYJDxI4FIsZEQbhf4kqcGfnwpGb5mgN77Ns7p8fJDOm863V2BiEJba2yMbet
	dti+uyUI4aZsCFI107h/jS6Gaz24sRU=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52d7a3defe8so29508861cf.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 01:18:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788164324; cv=none;
        d=google.com; s=arc-20260327;
        b=lEWpoiXTwwdEHun157OUDIzgMBd6CwLyNPTyJmKtYUF0LgsIgDBpNEATVlGfr9JlWx
         RH9CVBb5Q9jtU4rlI/9oIuzy98Kx1+KfuC6/aRwO9etHYEynvDXxpRMzGL1QE5q6HNgf
         ohWxzUOIpTEPyIZ6Mpkx1cFHpW4Nnsuo3iQoILAQrz5z+EdAf7RceVh3ZPZ7T4qKR0uU
         t+xV3bTp5ftKVObIrh9FpjxdWkHjNQFZwaUzLuu0GGuumLSzTu53k8cOPgz5zI+xdROO
         XvdzCx6KhJ5w0deHjtq27IATfJLl1BkbQDvtifJ0ud3OTiAlluy/cjHHXqITRbsS2/CT
         6U3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xkiZoIxNervah7q7cypbGBqjGwr4LoCCTOgNZ2t/KAw=;
        fh=KifG6Y/5EKQ+qKZVQnivaPN5dzAGIUYmr5F/f7+jga4=;
        b=iuIje2IA8VHcOX/u5G9n4syVibKaGfSWEEZfImGjt1kEJvX0sWrBOUoHz7jqufhhEE
         IuZojDM3/46i83J9Q7nK6isejhD6qs+15WzTHM8lbx66xyrI51Ku5+j06nY2U4rSxC0x
         170IbfUYZe7D0sYOShy5ycOah7Oqf5YDRL/dUXKLyJ7cERFcJdLqndevLjdYKcRLwQVv
         5bWw/vxyf/adquJ06CQE3dRrdASrlhraJNFIb0M95d7WOifPqCwFKbgy10mMP1qM9e9i
         3OM5P8lDKrVRAbPfnFJn+S1DO33WpBmI0POhmhXavarGlueeI9UxRPMOqOnKuNDOmZNm
         hMBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1788164324; x=1788769124; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xkiZoIxNervah7q7cypbGBqjGwr4LoCCTOgNZ2t/KAw=;
        b=KYiOkET7RoWyr+wyU1p6kY7TIfhlgMxfjdcA93i2FprcZ2MnmeJlHpyXUfNNdIIknp
         o4hQJ1n+Ux7P+8HpQFhva1KPHUiwwrfqWlyPbjq6a71CBiGFRgspk3ahVB5d8QHdX1DI
         Kn2NJy3HVZ1X0TVq4ReM+f92bb+yZaholdnCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788164324; x=1788769124;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xkiZoIxNervah7q7cypbGBqjGwr4LoCCTOgNZ2t/KAw=;
        b=Tzqs+GMFzyvBkkkhVFl05L8Ajil5kKjnMg4w03D88lNVi3k4na/BylQwVnLuZuHlJE
         CPT2FCoxY8XBxFb0XbRP/VuP3yL6jwBkOX8LyncWSHyV+RKMz49JjicfBB+RSGFOrsVM
         tH958G0G6LDmcjjspYQ2cbhnj45oi8Wy18YK7YVeGUTLsV7Fy1gIp3Sam9Qtmew9LF8E
         YNk0/mAsQcDGhRwBGPG8/SeyzFbaM7OtyeoZGMKo07SDwSqTwR9ghXt2aPhOmqZ00Yxm
         3kDUZtUnIEsaIyxDDk6k9NZc+hqAkvIz6J/Vxs2vSs+SURRc03Pc8yns2nSuxBvBxCV0
         5ipw==
X-Forwarded-Encrypted: i=1; AHgh+Rp67PjB2vZ9rUyXEAww65kYgLcmRCg3z918nDNlRUlZooHrxc11PpGc70wm5nkWx7GNKpWUc1UWKA==@kvack.org
X-Gm-Message-State: AFuF++kRfHO7ShUX3yuuxcTEmi4O6d+OujjSLLmNrKhp0CjxDGJ9za+8
	Uw64P2ttNpQXwmoVTOVF7ddd3N/2FVWlEGPe8bWZ9VofesUFrDl409mXUYhilM8mVbKV8umVstU
	AlEQHddFE0Hpc9zwio6+7wOfd7YJH4x9FK9e29Lj/7A==
X-Gm-Gg: AR+sD13ziHsxJgXP+zK5ZUAsaKIxd6fa55zPnPjtA/pd/sNgoOym7iFnHNnAZXG5fF2
	YuLfsRvXdvZilPEf3vj0j+yfZ37YsIiDGbLVULjkpFruJzN8MoBOgwuhs/2eyBZ6Y/mSOvjmOxh
	psIG88ozclXPfdkWLKL7q8QnEGDzVX3Q85szlwTZtktPTp/UDsqo4hrWD7zdbMxfHKkDmYYhdI2
	s7c1zmvK9uA3J35OTzEeNGjSaKo3xMlxzDQHX1gzcWL8xmRSxEpfkJo61+5Iz+woIFttuqUDAu1
	2jHZqRvaceRLCpEqW7aKEtTlvpr9q01KBTquCdFdbzBadU3DRGsFbVTDgkj72NPN03dRsC2xZ9Q
	WhwyM203FKJU=
X-Received: by 2002:a05:622a:1b0e:b0:51c:1cf8:ca4d with SMTP id
 d75a77b69052e-52fb94b76acmr354793171cf.13.1788164324676; Mon, 31 Aug 2026
 01:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260827170718.497-1-aa9736195201@gmail.com> <CAOQ4uxjxDV0U9yrDA_StN968P_6cpjRAN2mBCx1c_RYd7BF4Og@mail.gmail.com>
 <apGCDtf-gE1osJqE@casper.infradead.org>
In-Reply-To: <apGCDtf-gE1osJqE@casper.infradead.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 31 Aug 2026 10:18:32 +0200
X-Gm-Features: AcwNN1WtuG1c2F0CSiDk17jHE9we46hn9ZVdZmfYdI6sy7esBdj1sJKhsZBvuCE
Message-ID: <CAJfpeguhxCEs3pZuqAZ-gpG5gm7NV-TuzniSkCCrgAQ-TV6ZpA@mail.gmail.com>
Subject: Re: [PATCH] ovl: implement ->get_unmapped_area()
To: Matthew Wilcox <willy@infradead.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Linux MM <linux-mm@kvack.org>, Christian Brauner <brauner@kernel.org>, 
	"zhangyi (F)" <yi.zhang@huawei.com>, tujinjiang@huawe.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D16A40005
X-Stat-Signature: 5nbg74zp5dmhxs1qxi8ouygbxw1xz3yj
X-Rspam-User: 
X-HE-Tag: 1788164325-621231
X-HE-Meta: U2FsdGVkX192dHIfqFgVE/YqVZmYostkRMmjePHf0Pyuj7PGY/KICXeptbv8xbe4ooEAGe5HluLKllQBQ2WQ5uC35T2WGWlnATLR6fNFTAB2CJ0vACkcXXmfqYEcO/mLU++CMdAdQD/hDaThpimb2MGkCKQBHvahl4irX5F0R7eRYLPIntMq73SKZ0oZRQs5b4KVOIGYzLHkkGOjTXhFSy9JF/N4ZjnQsxolZNYBkHM7yA1LD+C+h+v75L/AgrG5pzHkQ1orFa/nBo4ZMKBIwDMoPmKdioDqJUig041UjWuulaUYGNgl53jatZyPq35YuXm+FRohVPmAk/EpIOfelfJZOLJKEmp+pDYCTFtm/oKWj0b+fVelduVVGLKRSCCvId8nv7Kxhms3AEorFiDnR5ihNkxc7VX52uY+VVYoJOnHcBGHC4WIlYAagATk6xtE16AIs8bEWKZn83xI8r6h+YoaL9YAf6XrgjUEE6fpnLwW8uws4GBQoeR3K+ZnS8QwrptUf0fgmjK2jGew3hUKeJboCNO9O0/8rWvUf+/DuEOlfIaYULREYYVswjHL4pBR7DO8vQZYXpyXJZEf1Ec6Nc+qE9dw8OAfAPAPfH7kj3qMMcX9CLLFCsXOewvwAQQgh7GEFsO8TnzePHJsbaAUwTCh2af59KGO7fFeYY5cJmkKeyXYMRywBpfsdhURCPZNbD+ylxPT6PYpU1S8SZ6pjbwbOvLzSI2spNsrzBg6ZHbVB3Eiwxp06NaNKLrkJ3IvRV8JLA5UEXVsFQW2o5n2r59SBJF/lEXOMbnTIfe18DSrZe47JwJijzBOBqmjlR3B8cs/+f4npd+Hmgm1Mhm6seRYO5UDkfiefWcFo27+nL63hwLqQ9OkXHUaXrPbzf/0ZG6r0qKralBEpvzzualX5wHYB3Yqjw1x7I96/aoaN8T9Dn6AjPPul5srYdu5a6tAcwgHm0hcNFyqqcCvmW8
 7J/ZTTnd
 8gtnGauFlXv9ob1XoTmVB2GMSj0LLv1DvT3SwcRouK6PH9Vjnqpc6tBjU44flpVslw3zC+ob07Y98WMIlKODG95vBv1Gxe4jgsX5okXaQ1w830hQUoPyMOiy43ULID4+vz+69vr1czTBtbxlSfZZuip/NJULxGwbR7RufwBE10eutFRfJyaL4clQqu/E/uJvqmcxyrDPKkRU7FDn04nyjVFnu3SkJUARAkvpoNGOQ2t/gAwMJogNF3SSaGPVuam2JcutMq276gk3P5nB/TNbJaFnA+VLEY9TLdAGZe4JCSRzQ3yjdGww2WK194oUe/xjnn1eS0310YrPd8gJAJ4OtCysC2v9wasFyk5iCld8lYtvtdHQER+l+Mv6SeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 at 14:41, Matthew Wilcox <willy@infradead.org> wrote:

> No, not at all.  All this patch needs to be is:
>
> +++ b/fs/overlayfs/file.c
> @@ -657,6 +657,7 @@ const struct file_operations ovl_file_operations = {
>         .fallocate      = ovl_fallocate,
>         .fadvise        = ovl_fadvise,
>         .flush          = ovl_flush,
> +       .get_unmapped_area = thp_get_unmapped_area,
>         .splice_read    = ovl_splice_read,
>         .splice_write   = ovl_splice_write,
>
>
> All this "oh we have to call the underlying filesystem's
> get_unmapepd_area" betrays a lack of understanding of the problem.
>
> And Lorenzo suggested this in the linked thread:
>
> https://lore.kernel.org/linux-unionfs/69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local/

There seems to be a logical fallacy in saying thp_get_unmapepd_area is
the most suitable value, yet not making it the default for all
filesystems.

Saying this without any understanding of the subtle difference between
setting .get_unmapepd_area to NULL and to thp_get_unmapepd_area.   All
I can see that the difference is indeed subtle.

Can you please explain?

Thanks,
Miklos

