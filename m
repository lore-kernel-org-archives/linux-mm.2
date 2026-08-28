Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C47C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 12:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6E56B0088; Fri, 28 Aug 2026 08:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869416B008A; Fri, 28 Aug 2026 08:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756646B008C; Fri, 28 Aug 2026 08:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CAD86B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:23:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C54F2140388
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:23:26 +0000 (UTC)
X-FDA: 85150593612.05.1098E82
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id D2CD940006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:23:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B60hhyc5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787919804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLuOPVgzMrabh8iP2CrClpX8J/e3bzGLeeBKYH4Ndlo=;
	b=C+CaQXicwofKVjr2gwq+8pwU7V54yttJLIEs/8KFSboqYw+Ml147j2kM+3seeKMNB0SW9l
	K43ZXYb7OYekTVPD7gRL8JZ+Y1YtCbxgN/KOwJherPmLk+29SrK+1pyVMtp8t3rHsBy36E
	Ozzpk4g5kIx0EbrBOyyiijz9t30uREk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B60hhyc5;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787919804;
	b=6Pe4f2IanonpsMOMr9crAb+KyF5Igh3DF2e3doao2ouZL25FG/ybkFp7TYdVuYI6RcYQtO
	GwgAiVc8wNlHu+zRBfPNCo7SGy6E05ZKLL77pq5s6fEvGOq4E1ekrFvvSQkB7eMNdf8qGn
	kL2hzTXuEqmV2ougxfoJADVIAk9gMuM=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c20ce3c118aso172070566b.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:23:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787919803; cv=none;
        d=google.com; s=arc-20260327;
        b=TOP32t89CDMyp40ozjOR5NgpZcDlsVTW2KXyD8IODMhTbx+Y2X42s+z2kDQJ7eShuc
         bazy5YA+dO+dNr2kWgSBmbK2iTDRuDix92tTGut+wOIa516gOZMNed5JGWcWvV+3ild4
         leXmukcxmMhr1Kd9JP60+X3aRyZTSS/7VryfsC+FGr1J180ZLtZbpurc1E1Dtr9Y75SI
         O0l9afS5t2c8AM9uS2o3lKIWM0Dw3Pdtt50gmd3GzPvdOmCQgHNhWAdwix/3IvuKTKms
         uDPJ3++JgTrwK1V04dLLXTipjCBxD8WPC8++v/54oXfH7LbVzagCIaZIG2p0DG7v+ObX
         zbdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PLuOPVgzMrabh8iP2CrClpX8J/e3bzGLeeBKYH4Ndlo=;
        fh=PEmik6XX2tosYBi3DE2Gzm4xfnX2daBAWVquFdSDYSQ=;
        b=EHtnxIOObRwDT2tpgMIiSPZfs1xRBTQ/v698+VK1u13x7/iqHIMUPCBIoXPpBNSgYE
         472/RNRvArGlsnQMwXzfsIUqEp4NavqUa1snp3sRf15NnA+zvhx7CFwp5oQqgjc2YgdY
         12w49iEaqYj9tQLwohEqkbYwdfr84/MapLfG7Kufe9TFQTr/abAQt/ekSfzSRgr+Mdd0
         U4OF+MUbiuHesPKM/icvIrkCN9uBaYSuQA2sJJNEPxt9Gw3Y7oFjFeZJpO9wDc0D6aK8
         481noFDo/NmuQLWk30ybICv03m6W/W5vEl8QpI75W4c5MSOCwj1ch7W50Us9K+cBJwJ9
         oBUQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787919803; x=1788524603; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PLuOPVgzMrabh8iP2CrClpX8J/e3bzGLeeBKYH4Ndlo=;
        b=B60hhyc5qxSJXEs1GKfmb8uP+wsCZ8i0j9LlJ4G7Ry+YHRP5390pADKCdObo+yzJcF
         HTXHvPpXlK/rzfmDdElbu/YAGUAXa8//5rrxyE+5NzLXOVNROYoarPbIvq+vZzl9x1Oy
         tjxWF4c193HMtPYicFL4mvi0HQilGexZLU3tz4yqzRbAVzYXyUyVbPKQZv/JUW0k8nzH
         c89pS6wHQtb30om0m/IdvF7MRfIjQ+VOEaT5BZ1KwOgIBjg4vSWbvXeKA5plaFr2nQ0/
         SnQqgtTMSAAMPbtwlxWRlWJuhteilfcWK4PAPA78Ptx/0ch+CO3PQ1Cud7+Rh6zboYKq
         RVAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787919803; x=1788524603;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PLuOPVgzMrabh8iP2CrClpX8J/e3bzGLeeBKYH4Ndlo=;
        b=a2yes95tnh3LpPm6zuFmMrBFfdj4P9SA5s/oXcim9G+zRQAXr2i3zkAKZ2Lfrn1EOB
         QAuDiJXDhgCzWxyzWpgP0kWDQITikz1thdYo8jaMUt51OeDCNG1xqfg8raBr1pGTNTdZ
         YDgVgkR5jUdi+sWO3fKtFMhEaHhreDFQMTpEZrUwfjNrRKPhSGMIS/oHNbZc9a1BbWD9
         s/n9emaAjBEew3u+xHvyw2rIuV2l0UVn6k/1AJOTfUtpR27OYT2tcZa0pqX5vGHao0j0
         OTivvWJH34DgSrXbejEO6GMU/EC9BmrA7eVNJrhTxwNe4SWQpvP3Ydj8B3Rbq8N5acif
         KmgQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp+x/Gejr7vbo4+kNI2Pcby84PEcZqdXwKRdkyAcKnoUbEm6MpkTnmQOZCdkqD7bemrGiJLZysamw==@kvack.org
X-Gm-Message-State: AFuF++nh58ZrxF1Ya+ldpOGcW/w4qNdx0qUxAwMPxpG3zJ/NsKJCoadb
	SKe5eXFwGbuezerZbj3Qcl0oM3rCAvDJrT7G1h3kkdfC3OAKB4SpW56OMpI9dm9o3ddT+4FCPtB
	F+U9+eFWdakgMezVt1BoB3RDSNiIzImI=
X-Gm-Gg: AR+sD11wFhUWS9eFPvrkGkR+fr+is/uKPnVp16nss3sNb8PhXs8mCHvLmTGw24IAVi/
	qo2XvLynpRK6urSoxg4HoWxZZtimPc46qnVfo6EZ4oIp88My3qHofIN8/qyvuf61naLVKInZ01K
	M2kVlwsfEbqL+olllynN4Eh5SzMYsJnYp6tpOzY1MSSudGtKD4mdY0Z4om2Z8cfrJd59E+VbqLR
	1kAqSQCTe8F4UA1YNyz8fFxAz5OrsdY76b4685VMQkxiJUJkh8132dKFRdnh8/hDuYmSFSVLWcM
	mSDxnlAzUnKw7xSF/TgBO/fdGAshampqZqJ9FYTWDu5OWZpuQa6kTZ9o
X-Received: by 2002:a17:907:1b0e:b0:c1c:2218:f317 with SMTP id
 a640c23a62f3a-c2535eab9b1mr1082654866b.2.1787919803004; Fri, 28 Aug 2026
 05:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260827170718.497-1-aa9736195201@gmail.com>
In-Reply-To: <20260827170718.497-1-aa9736195201@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 28 Aug 2026 14:23:11 +0200
X-Gm-Features: AcwNN1Xe-iVgNN_CSVbFy3js4YMDBqwZBjkmZg_1221I6kuu3xfgQZkLpUKwgHI
Message-ID: <CAOQ4uxjxDV0U9yrDA_StN968P_6cpjRAN2mBCx1c_RYd7BF4Og@mail.gmail.com>
Subject: Re: [PATCH] ovl: implement ->get_unmapped_area()
To: Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, Linux MM <linux-mm@kvack.org>, 
	Matthew Wilcox <willy@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	"zhangyi (F)" <yi.zhang@huawei.com>, tujinjiang@huawe.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jkoimtd3mhn5diqmpd357kmq64w6cjtw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D2CD940006
X-Rspam-User: 
X-HE-Tag: 1787919804-287960
X-HE-Meta: U2FsdGVkX1/8k6pHXCyJCkW58dmU4q+UC9iAaZiqbPhHA0eODompKV3s7wHBeT7o79xqf6qezFLGzg71cqVbzf+h1JrcwDTHvdd1RzTHts8qf9/p1eIYLpbePvWGYZDIgbV0jk8NPF3+Eq4auE0NkkhWApvQlJjwchrSVpXzYCReXQFtjH60CtRYyFdVeDXXqvCu7dNPkbIEthqHbmc0B4nTwuipHxBgZIEgAN7dW5j5fBvc+CobrYhGKjdIt/NANs70yciXbPcYMlbBHsnR/Z7ztrQgaxyLUEM7MeLAEavGfTJMW+dU4BmtV0Ygp4/vdP/NIldrngiQ+3DiXC5oMuQN0L+8yoAhjGaYTroyeMsPBi+b7r2hDSCYpyE1QWWhAeEZSKaPpSCh9IdGWgtkLK7AV6FpjOj+XnM2Yltnmd1jKGtrZ+qufA3zrZyNzI5knN4VSWjyTrsGHsnElG7ChrezWQnyduegVGO7o/uIvawbXEdFFqISBbIZu9p6nGHYn6/dsTAH+YW1rW+IbpERPODK3dqx4qCr7kiONuVbb4Ok9mPe3dENXJvaU0ZKvomSmZfjYNvny5T8fFrjt/+NlEwvNpgCQoDf2bPcJ59wpt626SFuF1rehulGAOeyiVFpT+exu+MfJS/unqg+K8w4n4j0tmJMSC9yCf+vf+H0TFg2B/9se+pJcvR4JF2FxiIhk6O3nFj4GzGZZOrPCE0+Qr6oOW9YWmMlGrQi7gCkuyzchxKeBgtlm8VBSnW5LNMWUwFW6J43Q/ulUetqW1VZvXQpPNyBIsUmsvBHel6g2Qz5xjxSLKCsoVDTAE4/LUeAKwFUCLahMdfcrz3KGnAFDwWQr+XKeyasAykSCqmc46io++yIWchY0mPYfXiJfnvKeZ8s4JvKihrudNBO/FpITtTvakAr424RuTIAHTgAOo78sBZjOxN62XFKJkXbCBp3Sg6XYaxec8vfsuEhWLL
 UDug8exF
 7ry21yl7VbO8hzCSNSJ2igBrTHzoO+Jo6qoXxz2xLFyMMB9qcZYvkMOrqbLMuC0r9bvJBICDaD7SN9sgtER6mQ28WygQ2qy99HkZucjiYZAH2j644EG2DSPQvO6xjVvxc61TMgdkIbUfpsBwRj1C7KHkQy8bvL9WBracpmW+oHizgjKhX5O5XYhjMI9XmvzrmYZTYNkUgpIPZibaj9DXeSVi4h3PE33kcOzHkxZpdCMP3LYohmiMt1NhLTn5zg8L4zVCE/TeEXja+aeHz0Jtakw1o+DN9qtWL6kgN1SRw9QSs0SanjMVjARkpW3EdhzHtXMr7GFWto/XUiwArbar9KbmhDbairchrGTe6CtIz1/jRRLarJ2TyBCeytPS9SmNckgMIM1kMMOkXPnfLiHTm3lCKmEluZpOYMHa0v1wlGhL7y2V2SMkhNQCRyBKLmXtISlVwmx7x1A0rioeIWRAHiUh3KBPPoxcPFEsH6e6GjZ8nxOjWDSsIWm5B3UDt8BJx/YbjlQCtzJooA0Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 7:07=E2=80=AFPM Yuan-Hao Hsu <aa9736195201@gmail.co=
m> wrote:
>
> ovl_mmap() passes realfile to the underlying filesystem, so the VMA it
> returns is backed by realfile, not by the overlayfs file.
>
> Address selection is not delegated.  __get_unmapped_area() looks at the
> overlayfs file's f_op, ovl_file_operations does not implement
> ->get_unmapped_area(), and the mapping lands wherever
> mm_get_unmapped_area() puts it.  ext4, xfs and btrfs all point
> ->get_unmapped_area() at thp_get_unmapped_area(); none of that is reached=
.
>
> vaddr - file_offset is then not a multiple of PMD_SIZE,
> thp_vma_suitable_order() rejects the VMA, and the PMD-sized folios the
> underlying filesystem already has in the page cache are never mapped by
> a PMD.
>
> Delegate to the file ovl_mmap() will use.  Calling thp_get_unmapped_area(=
)
> here instead would force alignment on filesystems that deliberately do
> not implement ->get_unmapped_area(), which commit 34d7cf637c43 ("mm:
> don't try THP alignment for FS without get_unmapped_area") avoided.
> fs/proc delegates the same way in pde_get_unmapped_area().
>
> Reading a 1025M ext4 file through mmap(NULL, ...), 97% of its page cache
> in PMD-sized folios, 15 runs:
>
>                      PMD congruent  minor faults  page tables
>   ext4, directly             15/15           764          68K
>   overlayfs, before            0/5         16186        2056K
>   overlayfs, after           15/15           764          68K
>
> Fault counts had 0 stddev.  Median read time 17.4ms -> 4.80ms, against
> 4.92ms for the same file on ext4.
>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
>
> ---
>  fs/overlayfs/file.c |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index f3d97eb146e8..0d985025f4c8 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -13,6 +13,7 @@
>  #include <linux/security.h>
>  #include <linux/fs.h>
>  #include <linux/backing-file.h>
> +#include <linux/sched/mm.h>
>  #include "overlayfs.h"
>
>  static char ovl_whatisit(struct inode *inode, struct inode *realinode)
> @@ -465,6 +466,30 @@ static int ovl_fsync(struct file *file, loff_t start=
, loff_t end, int datasync)
>                 return vfs_fsync_range(upperfile, start, end, datasync);
>  }
>
> +static unsigned long ovl_get_unmapped_area(struct file *file,
> +                                          unsigned long addr, unsigned l=
ong len,
> +                                          unsigned long pgoff, unsigned =
long flags)
> +{
> +       struct ovl_file *of =3D file->private_data;
> +       struct file *realfile =3D of->realfile;
> +
> +       /*
> +        * ovl_mmap() hands realfile to the underlying filesystem, so the=
 vma
> +        * ends up backed by realfile.  Let that filesystem pick the addr=
ess
> +        * too, or one that needs a specific alignment - to allow PMD map=
pings,
> +        * for example - never gets asked for one.
> +        */
> +       if (realfile->f_op->get_unmapped_area)
> +               return realfile->f_op->get_unmapped_area(realfile, addr, =
len,
> +                                                        pgoff, flags);
> +
> +#ifdef CONFIG_MMU
> +       return mm_get_unmapped_area(file, addr, len, pgoff, flags);
> +#endif

That looks quite ugly.
Can't we have a noop inline helper for mm_get_unmapped_area()
fo nommu?

> +
> +       return addr;
> +}
> +
>  static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>         struct ovl_file *of =3D file->private_data;
> @@ -654,6 +679,7 @@ const struct file_operations ovl_file_operations =3D =
{
>         .write_iter     =3D ovl_write_iter,
>         .fsync          =3D ovl_fsync,
>         .mmap           =3D ovl_mmap,
> +       .get_unmapped_area =3D ovl_get_unmapped_area,
>         .fallocate      =3D ovl_fallocate,
>         .fadvise        =3D ovl_fadvise,
>         .flush          =3D ovl_flush,
>
> base-commit: 26260251022fbc2f248a3d747a9b2b961b18d2d8

Since mmap is going through backing_file_mmap() probably a good idea to
pass this method through a backing_file helper as well.

But more importantly, adding MM people to this patch review, mainly the one=
s
that participated in the discussion over patch to fix similar issues
in 2024 [1].
Most of the concerns in that patch seem to have been addressed (?)

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20241205143038.3260233-1-tujinjia=
ng@huawei.com/

