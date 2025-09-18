Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D8DACAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 19:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73118E0146; Thu, 18 Sep 2025 15:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B258E00F6; Thu, 18 Sep 2025 15:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939CD8E0146; Thu, 18 Sep 2025 15:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81F968E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:12:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 249991A0378
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:12:14 +0000 (UTC)
X-FDA: 83903316588.18.27CEB70
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id E2331180010
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:12:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=e1PjzYEw;
	spf=pass (imf16.hostedemail.com: domain of "prvs=5356f0da48=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=5356f0da48=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758222732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7WMUyT5L/wA654bmEoUeQzuO+YeNxS6ichaQfAm4K0=;
	b=Ip0AUYAxXi8GoeCi70r2mEt4UjKqDOkKdPCZhYginibFMfKjj6M0nF26Pc8O5BRAKE0u/X
	ug9xr6nVKWMqpXpIhqmrTBg5PRFDlDXGxQEdZzcgisaLJequIQI7rrXUCZmxNX1J7h0VFF
	pNABjQnRkNi+PJSx79SrEscYcEmibDU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=e1PjzYEw;
	spf=pass (imf16.hostedemail.com: domain of "prvs=5356f0da48=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=5356f0da48=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758222732; a=rsa-sha256;
	cv=none;
	b=AFX2LbSDv5sLWreIt7zxw84gDn0ixepHtnHF1/T/FN71XmGawgfdWiKXOPHIYU3+Iw3EAE
	g+pqXasJPv+qKit5sbhyccFkUbm/oBc4RzT/yhnbJ4WhWbpIAcHUq48znJzpJJyFDy5iup
	aJlN1nOdvUgLx2HynPU4PdblyQFw7xo=
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58IHFrYs3277934;
	Thu, 18 Sep 2025 12:11:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=n7WMUyT5L/wA654bmEoUeQzuO+YeNxS6ichaQfAm4K0=; b=e1PjzYEwP6rW
	SfUk5eeciJxn+YRaNAOwJfo0mF1M9af1ue6fOutyvFad79DSht413xYSjq60mDZn
	YfAeHI3teHoLHj2Ahw36GPsEKjr9nWC6XNFV5yDHpZFkBziHEg6+zY9tRtbFHZ7L
	euLc+3yKJdYsaDbCHeYUrokmz4OdnyNONXB/EoFpk84RGhgSRcJayfWUqspezpej
	t5GboU+18x4kwUz9VDEY546JJy77c6NrIDp7S3nspwxS3VyRR3cDcJUXjns/AlUx
	vHU6c1NA5Yk/53XX8iJhs34HuxkDG9lTlReCBuQkPbYQPU3FHSiVsk3ft4wTv6TT
	ArN8tU50uw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 498f7yccgs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 18 Sep 2025 12:11:41 -0700 (PDT)
Received: from devbig091.ldc1.facebook.com (2620:10d:c085:108::150d) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Thu, 18 Sep 2025 19:11:36 +0000
From: Chris Mason <clm@meta.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>,
        "Thomas
 Bogendoerfer" <tsbogend@alpha.franken.de>,
        Heiko Carstens
	<hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
	<agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S . Miller"
	<davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann
	<arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Dan
 Williams" <dan.j.williams@intel.com>,
        Vishal Verma
	<vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre
	<nico@fluxnic.net>,
        "Muchun Song" <muchun.song@linux.dev>,
        Oscar Salvador
	<osalvador@suse.de>,
        "David Hildenbrand" <david@redhat.com>,
        Konstantin
 Komarov <almaz.alexandrovich@paragon-software.com>,
        Baoquan He
	<bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young
	<dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Reinette Chatre
	<reinette.chatre@intel.com>,
        "Dave Martin" <Dave.Martin@arm.com>,
        James Morse
	<james.morse@arm.com>,
        "Alexander Viro" <viro@zeniv.linux.org.uk>,
        Christian
 Brauner <brauner@kernel.org>, "Jan Kara" <jack@suse.cz>,
        "Liam R . Howlett"
	<Liam.Howlett@oracle.com>,
        "Vlastimil Babka" <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Michal Hocko
	<mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>,
        "Uladzislau Rezki" <urezki@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        "Andrey Konovalov"
	<andreyknvl@gmail.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-csky@vger.kernel.org>,
        <linux-mips@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <sparclinux@vger.kernel.org>, <nvdimm@lists.linux.dev>,
        <linux-cxl@vger.kernel.org>, <linux-mm@kvack.org>,
        <ntfs3@lists.linux.dev>, <kexec@lists.infradead.org>,
        <kasan-dev@googlegroups.com>, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 11/16] mm: update mem char driver to use mmap_prepare
Date: Thu, 18 Sep 2025 12:11:05 -0700
Message-ID: <20250918191119.3622358-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aeee6a4896304d6dc7515e79d74f8bc5ec424415.1757534913.git.lorenzo.stoakes@oracle.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:108::150d]
X-Authority-Analysis: v=2.4 cv=Wr8rMcfv c=1 sm=1 tr=0 ts=68cc596e cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=QLIaiyCFZkuJlwHvl48A:9
X-Proofpoint-ORIG-GUID: yzU4eNHLhAUfSh4h33V6r2BXOldJckJZ
X-Proofpoint-GUID: yzU4eNHLhAUfSh4h33V6r2BXOldJckJZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE4MDE3MCBTYWx0ZWRfX+OH6/CZXfYF1
 ZQZSd3MY5d1+huXM92tmUuaixGbvXh9eslNEM1bRcbWXduWBJkY9hM7pAwYK1UmVGB6+KtMLK3+
 5xu0OvXnTYTE5X3/j7r0YUT9jTEQIyg7vs2wzGv7et2oYHzPIQqFSONTUbrUfKZtQGE+5Ql2G/m
 FB+fFTcxSnJqueTYbtn/kFdO7ZXWcwZvUvPEHQAajQYNZXBbU5RIDDKbQMkKIDQGqkR8eZiO5xs
 q0uwGSCKiMwePOEm2hD3yphFf7LSfGFQnTUqyn0uufzwKaznKzrNA1c2BW91Ht07S88ASQbLxJd
 y3Z61QWwzOnbaToH1kdrhAuNayIEpInurTQIzwra/DJzb/lInqX9Bhz50sofEw=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_02,2025-09-18_02,2025-03-28_01
X-Rspamd-Queue-Id: E2331180010
X-Stat-Signature: 8wnu1f4qgpswfs5fept9zt5rr8j11dpp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758222731-4001
X-HE-Meta: U2FsdGVkX18SAZ90JZzBrdJMYBoMpO5Oz8oV5rBoVCTPhhL2NJ/rrVgrm5VlsohCmn3q4PrcrbH9TL4/8Zp3XwpA7NPM6Z/B346KkijCE9k9YsrrlJi4wJGATGaZU/S+uS3GkVfHB2y3l1kA5xDtz1hEVY9YQ81SXl8asdPmyZqKxxXzNZ+VFl0QFZz5VapkKIyix3vSDu9K+DSI7X4ka0JOICCHntYwmHcKH4LbmG9JZI2OibJpA788fK1hEOar8LqZIgKCWdv3F9A15FY0tUW9cJlhJb/WAO4QYlsN1rdF7+CyP/QpGV+8T39i8z/www/w4y/IA6i1t4yYyLSEwCSpt4ZhPy0to1B1KmSpuUKAHKKR4qbGu6D4Vy7noCduvegeORhkY0vC76I0WugRjPGtwHPtezDsJApd0sq3R6AbgK5kaET+MtXk461c9/g8IUKN5OOpSD1OV3OMUhG2cZ0hsPyQUd4UVi+olXKuGYNRSI6xV+ZzXGInhwGbzA8D6rytixnQRlflV4wR/1NWy78OMWk4eEA0vpOxP6WBpLjLxzsctb3XD+oulPJcfizT2N+2r0BEbrm3f3bsPCuriXGs2ZlWnsq3oCFgOog1NJ8gIf1g+uR4gr7Yej+Il9j1OC0N6W9mCZ1XUp03Yfk7Fbem89agWGOMcomS1iVl5rk16Hl7jLUF2IrsobpV0EOhCGg/fbw21qGtIKZQtAZiax2gECw3nENlrep+i4t/8boRcq30huAhjXX6HZdS6mw3fAGIJvVVnRjdCqNbBMQCYI2IbSfea++KVpPqhOQuEvf2qekmyDACJ4RAL6Hr9B8KO3N+AxoqDYroaKmRx82+G8t9BuM0MBCLlnBc/vbmT+HCpS9CI8+bGHsqK6miTNQRXJn1oIz/pAqdP2+epKVaFKmYnLyW4tHzV6mrmP6ajVqIGAycdLOGgQJfXojDLk4CwpT1B8Jg1t4nrT7DFBq
 XsFrpSSY
 2a9bfC52z6CP2H0n2TkpZgDq0FZ6OqkM8kl6/fam1d0BdXAtIb4iox3OtdvICqxsuYaBi4wsJmhweRbpmdr7jJU1xtLCWc+6e+dSRbJUIAnQkgDmy248bCysysgq6OoxB/NmMLJcr49QTLhgM8XzytqB1Cb/gVdrvDn1F4NdG63yhLpzBI+ozCLnUk9QbmpdqoIUjdEMa5ynfSSALR7+Nvi0MVO570eiK4gkXCmdgODG/ibcee1Y95o8h5Rw/It0P+yuX3WzNws//L/ng2PeGO0gfwfVakVhSFOrgFNYAaO5TAVPf0XO8E2tFXvWxOut3lsDdOZOG7PYUzDs4j1iVg5qbtODRIxTBeGyQLBM+Ecn648Yd4yuHT79glsH7WbVqoHIM3aR6gVHz1rJyGUPrBbEEevWbT6MyopOXFR1rP6fUt++BecsJJhFiF3hXFrkZoZ8zUmw24veSm73Xn2jTG5yg62a+3Wk62LRwvKIhasfGZdo+eVTvTmT/Z6Fe4h4a1Si1eTgmE7W+oX3uZYnskWtW9LqQ261kYAEsGPH8N6sz/bYc7rEaCdibiHYvWgnpAeLag7pHC7tYD5z7Bo2mHtrOwUxJmg1L7JUS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 21:22:06 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> Update the mem char driver (backing /dev/mem and /dev/zero) to use
> f_op->mmap_prepare hook rather than the deprecated f_op->mmap.
> 
> The /dev/zero implementation has a very unique and rather concerning
> characteristic in that it converts MAP_PRIVATE mmap() mappings anonymous
> when they are, in fact, not.
> 
> The new f_op->mmap_prepare() can support this, but rather than introducing
> a helper function to perform this hack (and risk introducing other users),
> simply set desc->vm_op to NULL here and add a comment describing what's
> going on.
> 
> We also introduce shmem_zero_setup_desc() to allow for the shared mapping
> case via an f_op->mmap_prepare() hook, and generalise the code between this
> and shmem_zero_setup().
> 
> We also use the desc->action_error_hook to filter the remap error to
> -EAGAIN to keep behaviour consistent.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  drivers/char/mem.c       | 75 ++++++++++++++++++++++------------------
>  include/linux/shmem_fs.h |  3 +-
>  mm/shmem.c               | 40 ++++++++++++++++-----
>  3 files changed, 76 insertions(+), 42 deletions(-)
> 

[ ... ]

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 990e33c6a776..cb6ff00eb4cb 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c

[ ... ]

> @@ -5920,6 +5925,25 @@ int shmem_zero_setup(struct vm_area_struct *vma)
>  	return 0;
>  }
>  
> +/**
> + * shmem_zero_setup_desc - same as shmem_zero_setup, but determined by VMA
> + * descriptor for convenience.
> + * @desc: Describes VMA
> + * Returns: 0 on success, or error
> + */
> +int shmem_zero_setup_desc(struct vm_area_desc *desc)
> +{
> +	struct file *file = __shmem_zero_setup(desc->start, desc->end, desc->vm_flags);
> +
> +	if (IS_ERR(file))
> +		return PTR_ERR(file);
> +
> +	desc->vm_file = file;
> +	desc->vm_ops = &shmem_anon_vm_ops;
> +
> +	return 0;
> +}
> +

Hi Lorenzo,

shmem_zero_setup() does a if (vma->vm_file) fput(vma->vm_file) dance.

It looks like we need one here too?

-chris

