Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DE97103E199
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:33:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FE856B0276; Wed, 18 Mar 2026 11:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0126B0278; Wed, 18 Mar 2026 11:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077AC6B0279; Wed, 18 Mar 2026 11:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E828C6B0276
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:33:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 805331B8A94
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:33:43 +0000 (UTC)
X-FDA: 84559578726.21.F73970D
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id A1356A000F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:33:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mqcdum8w;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773848021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGhskv71iGk4a6C8n6je30dgNR8JdURCG8MPG7t6BPg=;
	b=LWQm0OwKWsgmbQEzXf6IEVVKF6yYQ0S/m3qtmoN8PEBxeNZnRTojQc+J1KzzsvgwJ+JQZc
	W2cMow8wJbrLkGCeDT0fVOdsLO8Ak0Iryj6x7R/fbKyLflJPBK1CEiV9a1jK8zLi6X8M3l
	sNzf4EOxTKg6yml9WxZiU1e4wli+jdU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773848021; a=rsa-sha256;
	cv=pass;
	b=e0IVOxIxYOWeY/k3qkgun/F0vjBzw8fYCeIBG2UE+sWtST/QgtgsSI+vDKNNsRozLDAFaT
	GyGsX+8fK8istOcGveoHTMsFB0u1rD8tyJhVof8QMrCGQqRevjW3WQtbTVH4QaWsAoGGBN
	sVA1KjTOGkOq2HArvLJXKdaTUdx6OmA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mqcdum8w;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50906a98ffeso571971cf.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:33:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773848021; cv=none;
        d=google.com; s=arc-20240605;
        b=CTTO/dv3byhBuR94H82icnwdRLP0MV15UAUndR4WoUvh78h9ccz8+ixMJurqtZP28s
         gasRbW5iB/3rbtzWHZVjNqxYg/3wzAoE/euPNtg3VOShK67vhwz1XTx/n5Z2NHvnU96C
         RRlB5exxKKZER+k23yu3idUVgDUXoZSjqJOL90On+39sIaeBQWaDtJoHLo979YZIW191
         nwZ5CVGC4OyccVVf+tsM3MUM7z39peV4y0OSK/xjgtPn46cXGztC3bQoT6yNP27mdN7p
         uMXV8zwiRPBI8dbdI9Oe2+zL6948m6Cl3hxq8GxnOkrmwf/7Zy35GtTZ4QBVyAUb74Yp
         CZFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nGhskv71iGk4a6C8n6je30dgNR8JdURCG8MPG7t6BPg=;
        fh=jfqxfJmyYR7DdSZV1fpxq2lvrpWLGVn4vW6sj6xg3Qg=;
        b=CjI8XvlE/iBz+qCwtMWFz21qtvNswWoGtbFIRyJlBlssUEzSAh3ii4KS/erbjvpxEY
         uo87UeG3EXyGslzWSuhppOzZ7Faf208K9jATstAHKDdxEzPJ9fH4+9cKb1uM9U9BHssl
         OTrG/DLJqlsCkRnfknIUjYt6RlqMJi1TtT8dUmQTpM4xsjDzhLKTJmXClxsiN2eAdIhP
         Q0kxrlE2e1qhCz1lf1/IILJpLMRXT5NzEpvDwRW+9YnWOFbK4an/KTJFGsiKMejdIPYu
         H/PQRZlEXLyhu+e1kmeeFj4W4bQFkUbVhAcGOlXLt7hziUzG9DPqgip2eiuzi1j2C+OY
         +6kA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773848021; x=1774452821; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGhskv71iGk4a6C8n6je30dgNR8JdURCG8MPG7t6BPg=;
        b=mqcdum8w3ZiZY0RfacofeGo4CMRCFGlRb7Iyv7xbDAq3wHkR0IdwpEThrjZh7e7PbY
         uBtok7Bqne+5yo4Eq+VC0GVgmA0DEZwCwcM1wFEtR18l1A2/YTtwBv9vPQ/lyr7e68xo
         3wKQm+yuo/E8TQr1FKN7M/vueYDvc8tjBj/IWKlWascHaTYALlJZV3ztZQTcC24YAUA+
         RCSXOoxTutG5p9T2UwsqBkuXiIZhd1vDGUMvv/1ZEmmJ4coQrMeVuPhhWMV4/cW4YEvG
         rnge7+x03HxpX9+6AOYohYfWqjCxQqgD9DE1TPfG/709jvueY3j+qmqSLIKE/MUkf3D0
         rppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773848021; x=1774452821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nGhskv71iGk4a6C8n6je30dgNR8JdURCG8MPG7t6BPg=;
        b=HQQVHyYrPt4vd3PMaCCFPrJrFB3suj8/xIN4iRMgPnrg6nHkKoOocUdGUZQa/ZlTIB
         Y5ofISRWPRA70ZisYst30Vi+LQZWWUt4K19o1Wgo4qQrkw7obXcDok+/fw5RPMxCUPo3
         HX2T+PNsUN+FutujFhZN6Wqp3b7jrF1QYmDBRNZxBdzNwGLDnZ1BkI3+VvGPSMQP4qVz
         Rq0SGe0vvoTQSXzHuuLyzHAlTMGaO52qYXDraOBVshpsVcGnnRJUOSI2k16mRMVHWE4l
         x6ekfphNp5pr4pvqycDg8aQqu0Jb/tfcpaCTxZdUi2zetGc0edf6uIGeGSwf5ROE/PvI
         HHgw==
X-Forwarded-Encrypted: i=1; AJvYcCWXvw7yA6WFvz8sUgbQEEBmdkWTgjuJHJae5yLUHh0GKrCvbn2tncYlclA9LLNMftf64Bgon2Mjpw==@kvack.org
X-Gm-Message-State: AOJu0Yz2JFJFmrs8HnJBye6d062Oz6hBev4lCAwJrv+HJDBzjANymXRN
	bxvlY472NJoO1IxYmILJsV63SjJ6mkN7TYdyHwmgoiu5Fq4CszafaBeQMrtRqgdQ4W/GWeYauXO
	VBh+mSrs9pmysaOtyB43lwv9qtiF+d3Bfwp5UQypI
X-Gm-Gg: ATEYQzwVhR0VIqeplb6G291kxTptkncyep2Egrjt+m7PBxYtTQI11xogeIZ6MpJ1Jhp
	GQQvMVrIroP/DFnm6tzLpF6V3FrJlFjNa5gYTJMD9V6vEgvDE5CbiKJDRLxAz8wkLZ6ETDxXeZG
	p5D8P+4p87fsTdJ3cXjijdJx0VKl+OGC0boh1zURflw3DhKifpaRG6hr6jfCjuqckbqBrflzY6M
	zvjjCyTT/7SWcBYWS9iN01rn6+Ho0qcooUyyd866qfK0T67cX0NcEs2Yz8wQsh0dxTPMkKBzY1v
	QyKtzN3Ou/zKsphF7WRh7Xml4vDjTjEVFC8u5Q==
X-Received: by 2002:a05:622a:1ba1:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-50b15a39ceemr13764641cf.3.1773848019468; Wed, 18 Mar 2026
 08:33:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <72750af6906fd96fb6f18e83ac3e694cf357a2c1.1773695307.git.ljs@kernel.org>
In-Reply-To: <72750af6906fd96fb6f18e83ac3e694cf357a2c1.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 18 Mar 2026 08:33:28 -0700
X-Gm-Features: AaiRm508CWHJHcUlp19xyhaUwtV3CnPlFdxPDN6Oc3HfEVsGmxYRJXSDE9dIRHk
Message-ID: <CAJuCfpFr8_uU28S=v7y74Opa4L_4s9J70NgUXg1WGmraDhsxRA@mail.gmail.com>
Subject: Re: [PATCH v2 12/16] mm: allow handling of stacked mmap_prepare hooks
 in more drivers
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: eoi337mrxuci55pnwontcgudnadssezm
X-Rspamd-Queue-Id: A1356A000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773848021-689129
X-HE-Meta: U2FsdGVkX1/M3fMoa4h6GNpW856EetLNyYkYSotWyLp31M8yXY4SG9cPrNpd2n8J9BzQB+C2pnjAKmD1oTzgEwVCRld4+XsHXDMi4QjyzsmqtbhSLSELPE0n5F/X0FD5xqiyiKu/GzIYHZlk1lAFhjUkrc/ggz7Wmdq3w0Bz9TkpWQUQRpDXc40rBRmakIVyiDfwS+n7qwIyQyd4XQz1QtW0fnQDG88Y9s0Sr+41rGqyUhMjZBJ2TKvVqd9J6J/TmA6GAZQ2H8Oj6JzTUfAUQMiQ12XDRHK6oTMZEMn9Gt9XH+E6zYxDbrT9YhW+r7NJUF0iGYqoWUEUhVQLYBpSy7tpEgBrlqqiSgqsBPg4eKoqBhj9NVKrd8oKdVZHSY52nz9KqaHsYbVpJo8fo5ZvH6QFf0jeKtSv7SXHLEvaNh5u05ZryCoLQXM8CfGaS4DbJP0Cbl1ejlvCC44rC1z/wM1frI+FxIY4FosuvjLd3UR8O9b7FIV7r0qIE/nTnQRuJqosqY2VoFCBJKrFGEXE5A3yZFsya1QxwbKjI/aMP99V3rhKyFrUS/pRe4vpCiyJRbHEXFY4tteKhKJCUCug4s3VXA3x2xLL8xrH7EgEw8WS9enzoHbXJdy8CG3du//M4zOFgQkY9o41+sAnzOoxZ+bAUczDXnEBhrthSZkfAwFVa2y93mhPGeuyCZCHXTPDCjBrTcaNpoU/49ds+gGeaEL6kdO9KeJ+8GLLTG8iSQSGLujgN5vnOnJuppzRPkBRPPjwlkjzdV6xG+jE4exJVuuTtXREYFO1S2oJTx+wqj1minTEgJSLMyDjfCATK9Fy0dudRaGukmPMuRWyvjCJrUanL2dq1ANAx07wG7utn7GALHlctgDXcvAODYc35ApYwNrUvwV/oWFxMaw6U0o2DRfUzOx1LpcEUYHeS7y0VywTWQdy8u+LW73j6Wvtl5WeX17MTDBGwq2LeaZ0mop
 nBZUTT+i
 FF2naVjQT+5KKB+GOxxStTvSWRPjy1G10f4FoK8bRyhzceaI9LJLqN3pKmIyazgD5KggqP36CBJz1f40eCVyMpycilR9e9wAl3A8r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> While the conversion of mmap hooks to mmap_prepare is underway, we wil

nit: s/wil/will

> encounter situations where mmap hooks need to invoke nested mmap_prepare
> hooks.
>
> The nesting of mmap hooks is termed 'stacking'.  In order to flexibly
> facilitate the conversion of custom mmap hooks in drivers which stack, we
> must split up the existing compat_vma_mapped() function into two separate
> functions:
>
> * compat_set_desc_from_vma() - This allows the setting of a vm_area_desc
>   object's fields to the relevant fields of a VMA.
>
> * __compat_vma_mmap() - Once an mmap_prepare hook has been executed upon =
a
>   vm_area_desc object, this function performs any mmap actions specified =
by
>   the mmap_prepare hook and then invokes its vm_ops->mapped() hook if any
>   were specified.
>
> In ordinary cases, where a file's f_op->mmap_prepare() hook simply needs =
to
> be invoked in a stacked mmap() hook, compat_vma_mmap() can be used.
>
> However some drivers define their own nested hooks, which are invoked in
> turn by another hook.
>
> A concrete example is vmbus_channel->mmap_ring_buffer(), which is invoked
> in turn by bin_attribute->mmap():
>
> vmbus_channel->mmap_ring_buffer() has a signature of:
>
> int (*mmap_ring_buffer)(struct vmbus_channel *channel,
>                         struct vm_area_struct *vma);
>
> And bin_attribute->mmap() has a signature of:
>
>         int (*mmap)(struct file *, struct kobject *,
>                     const struct bin_attribute *attr,
>                     struct vm_area_struct *vma);
>
> And so compat_vma_mmap() cannot be used here for incremental conversion o=
f
> hooks from mmap() to mmap_prepare().
>
> There are many such instances like this, where conversion to mmap_prepare
> would otherwise cascade to a huge change set due to nesting of this kind.
>
> The changes in this patch mean we could now instead convert
> vmbus_channel->mmap_ring_buffer() to
> vmbus_channel->mmap_prepare_ring_buffer(), and implement something like:
>
>         struct vm_area_desc desc;
>         int err;
>
>         compat_set_desc_from_vm(&desc, file, vma);
>         err =3D channel->mmap_prepare_ring_buffer(channel, &desc);
>         if (err)
>                 return err;
>
>         return __compat_vma_mmap(&desc, vma);
>
> Allowing us to incrementally update this logic, and other logic like it.

The way I understand this and the next 2 patches is that they are
preperations for later replacement of mmap() with mmap_prepare() but
they don't yet do that completely. Is that right?
To clarify what I mean, in [1] for example, you are replacing struct
uio_info.mmap with uio_info.mmap_prepare but it's still being called
from uio_mmap(). IOW, you are not replacing uio_mmap with
uio_mmap_prepare. Is that the next step that's not yet implemented?

[1] https://lore.kernel.org/all/892a8b32e5ef64c69239ccc2d1bd364716fd7fdf.17=
73695307.git.ljs@kernel.org/

>
> Unfortunately, as part of this change, we need to be able to flexibly
> assign to the VMA descriptor, so have to remove some of the const
> declarations within the structure.
>
> Also update the VMA tests to reflect the changes.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  include/linux/fs.h              |   3 +
>  include/linux/mm_types.h        |   4 +-
>  mm/util.c                       | 111 +++++++++++++++++++++++---------
>  mm/vma.h                        |   2 +-
>  tools/testing/vma/include/dup.h | 111 ++++++++++++++++++++------------
>  5 files changed, 157 insertions(+), 74 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c390f5c667e3..0bdccfa70b44 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2058,6 +2058,9 @@ static inline bool can_mmap_file(struct file *file)
>         return true;
>  }
>
> +void compat_set_desc_from_vma(struct vm_area_desc *desc, const struct fi=
le *file,
> +                             const struct vm_area_struct *vma);
> +int __compat_vma_mmap(struct vm_area_desc *desc, struct vm_area_struct *=
vma);
>  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
>  int __vma_check_mmap_hook(struct vm_area_struct *vma);
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 50685cf29792..7538d64f8848 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -891,8 +891,8 @@ static __always_inline bool vma_flags_empty(vma_flags=
_t *flags)
>   */
>  struct vm_area_desc {
>         /* Immutable state. */
> -       const struct mm_struct *const mm;
> -       struct file *const file; /* May vary from vm_file in stacked call=
ers. */
> +       struct mm_struct *mm;
> +       struct file *file; /* May vary from vm_file in stacked callers. *=
/
>         unsigned long start;
>         unsigned long end;
>
> diff --git a/mm/util.c b/mm/util.c
> index aa92e471afe1..a166c48fe894 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1163,34 +1163,38 @@ void flush_dcache_folio(struct folio *folio)
>  EXPORT_SYMBOL(flush_dcache_folio);
>  #endif
>
> -static int __compat_vma_mmap(struct file *file, struct vm_area_struct *v=
ma)
> +/**
> + * compat_set_desc_from_vma() - assigns VMA descriptor @desc fields from=
 a VMA.
> + * @desc: A VMA descriptor whose fields need to be set.
> + * @file: The file object describing the file being mmap()'d.
> + * @vma: The VMA whose fields we wish to assign to @desc.
> + *
> + * This is a compatibility function to allow an mmap() hook to call
> + * mmap_prepare() hooks when drivers nest these. This function specifica=
lly
> + * allows the construction of a vm_area_desc value, @desc, from a VMA @v=
ma for
> + * the purposes of doing this.
> + *
> + * Once the conversion of drivers is complete this function will no long=
er be
> + * required and will be removed.
> + */
> +void compat_set_desc_from_vma(struct vm_area_desc *desc,
> +                             const struct file *file,
> +                             const struct vm_area_struct *vma)
>  {
> -       struct vm_area_desc desc =3D {
> -               .mm =3D vma->vm_mm,
> -               .file =3D file,
> -               .start =3D vma->vm_start,
> -               .end =3D vma->vm_end,
> -
> -               .pgoff =3D vma->vm_pgoff,
> -               .vm_file =3D vma->vm_file,
> -               .vma_flags =3D vma->flags,
> -               .page_prot =3D vma->vm_page_prot,
> -
> -               .action.type =3D MMAP_NOTHING, /* Default */
> -       };
> -       int err;
> +       desc->mm =3D vma->vm_mm;
> +       desc->file =3D (struct file *)file;
> +       desc->start =3D vma->vm_start;
> +       desc->end =3D vma->vm_end;
>
> -       err =3D vfs_mmap_prepare(file, &desc);
> -       if (err)
> -               return err;
> +       desc->pgoff =3D vma->vm_pgoff;
> +       desc->vm_file =3D vma->vm_file;
> +       desc->vma_flags =3D vma->flags;
> +       desc->page_prot =3D vma->vm_page_prot;
>
> -       err =3D mmap_action_prepare(&desc);
> -       if (err)
> -               return err;
> -
> -       set_vma_from_desc(vma, &desc);
> -       return mmap_action_complete(vma, &desc.action);
> +       /* Default. */
> +       desc->action.type =3D MMAP_NOTHING;
>  }
> +EXPORT_SYMBOL(compat_set_desc_from_vma);
>
>  static int __compat_vma_mapped(struct file *file, struct vm_area_struct =
*vma)
>  {
> @@ -1211,6 +1215,49 @@ static int __compat_vma_mapped(struct file *file, =
struct vm_area_struct *vma)
>         return err;
>  }
>
> +/**
> + * __compat_vma_mmap() - Similar to compat_vma_mmap(), only it allows
> + * flexibility as to how the mmap_prepare callback is invoked, which is =
useful
> + * for drivers which invoke nested mmap_prepare callbacks in an mmap() h=
ook.
> + * @desc: A VMA descriptor upon which an mmap_prepare() hook has already=
 been
> + * executed.
> + * @vma: The VMA to which @desc should be applied.
> + *
> + * The function assumes that you have obtained a VMA descriptor @desc fr=
om
> + * compt_set_desc_from_vma(), and already executed the mmap_prepare() ho=
ok upon
> + * it.
> + *
> + * It then performs any specified mmap actions, and invokes the vm_ops->=
mapped()
> + * hook if one is present.
> + *
> + * See the description of compat_vma_mmap() for more details.
> + *
> + * Once the conversion of drivers is complete this function will no long=
er be
> + * required and will be removed.
> + *
> + * Returns: 0 on success or error.
> + */
> +int __compat_vma_mmap(struct vm_area_desc *desc,
> +                     struct vm_area_struct *vma)
> +{
> +       int err;
> +
> +       /* Perform any preparatory tasks for mmap action. */
> +       err =3D mmap_action_prepare(desc);
> +       if (err)
> +               return err;
> +       /* Update the VMA from the descriptor. */
> +       compat_set_vma_from_desc(vma, desc);
> +       /* Complete any specified mmap actions. */
> +       err =3D mmap_action_complete(vma, &desc->action);
> +       if (err)
> +               return err;
> +
> +       /* Invoke vm_ops->mapped callback. */
> +       return __compat_vma_mapped(desc->file, vma);
> +}
> +EXPORT_SYMBOL(__compat_vma_mmap);
> +
>  /**
>   * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
>   * existing VMA and execute any requested actions.
> @@ -1218,10 +1265,10 @@ static int __compat_vma_mapped(struct file *file,=
 struct vm_area_struct *vma)
>   * @vma: The VMA to apply the .mmap_prepare() hook to.
>   *
>   * Ordinarily, .mmap_prepare() is invoked directly upon mmap(). However,=
 certain
> - * stacked filesystems invoke a nested mmap hook of an underlying file.
> + * stacked drivers invoke a nested mmap hook of an underlying file.
>   *
> - * Until all filesystems are converted to use .mmap_prepare(), we must b=
e
> - * conservative and continue to invoke these stacked filesystems using t=
he
> + * Until all drivers are converted to use .mmap_prepare(), we must be
> + * conservative and continue to invoke these stacked drivers using the
>   * deprecated .mmap() hook.
>   *
>   * However we have a problem if the underlying file system possesses an
> @@ -1232,20 +1279,22 @@ static int __compat_vma_mapped(struct file *file,=
 struct vm_area_struct *vma)
>   * establishes a struct vm_area_desc descriptor, passes to the underlyin=
g
>   * .mmap_prepare() hook and applies any changes performed by it.
>   *
> - * Once the conversion of filesystems is complete this function will no =
longer
> - * be required and will be removed.
> + * Once the conversion of drivers is complete this function will no long=
er be
> + * required and will be removed.
>   *
>   * Returns: 0 on success or error.
>   */
>  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> +       struct vm_area_desc desc;
>         int err;
>
> -       err =3D __compat_vma_mmap(file, vma);
> +       compat_set_desc_from_vma(&desc, file, vma);
> +       err =3D vfs_mmap_prepare(file, &desc);
>         if (err)
>                 return err;
>
> -       return __compat_vma_mapped(file, vma);
> +       return __compat_vma_mmap(&desc, vma);
>  }
>  EXPORT_SYMBOL(compat_vma_mmap);
>
> diff --git a/mm/vma.h b/mm/vma.h
> index adc18f7dd9f1..a76046c39b14 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -300,7 +300,7 @@ static inline int vma_iter_store_gfp(struct vma_itera=
tor *vmi,
>   * f_op->mmap() but which might have an underlying file system which imp=
lements
>   * f_op->mmap_prepare().
>   */
> -static inline void set_vma_from_desc(struct vm_area_struct *vma,
> +static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
>                 struct vm_area_desc *desc)
>  {
>         /*
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 114daaef4f73..6658df26698a 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -519,8 +519,8 @@ enum vma_operation {
>   */
>  struct vm_area_desc {
>         /* Immutable state. */
> -       const struct mm_struct *const mm;
> -       struct file *const file; /* May vary from vm_file in stacked call=
ers. */
> +       struct mm_struct *mm;
> +       struct file *file; /* May vary from vm_file in stacked callers. *=
/
>         unsigned long start;
>         unsigned long end;
>
> @@ -1272,43 +1272,92 @@ static inline void vma_set_anonymous(struct vm_ar=
ea_struct *vma)
>  }
>
>  /* Declared in vma.h. */
> -static inline void set_vma_from_desc(struct vm_area_struct *vma,
> +static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
>                 struct vm_area_desc *desc);
>
> -static inline int __compat_vma_mmap(const struct file_operations *f_op,
> -               struct file *file, struct vm_area_struct *vma)
> +static inline void compat_set_desc_from_vma(struct vm_area_desc *desc,
> +                             const struct file *file,
> +                             const struct vm_area_struct *vma)
>  {
> -       struct vm_area_desc desc =3D {
> -               .mm =3D vma->vm_mm,
> -               .file =3D file,
> -               .start =3D vma->vm_start,
> -               .end =3D vma->vm_end,
> +       desc->mm =3D vma->vm_mm;
> +       desc->file =3D (struct file *)file;
> +       desc->start =3D vma->vm_start;
> +       desc->end =3D vma->vm_end;
>
> -               .pgoff =3D vma->vm_pgoff,
> -               .vm_file =3D vma->vm_file,
> -               .vma_flags =3D vma->flags,
> -               .page_prot =3D vma->vm_page_prot,
> +       desc->pgoff =3D vma->vm_pgoff;
> +       desc->vm_file =3D vma->vm_file;
> +       desc->vma_flags =3D vma->flags;
> +       desc->page_prot =3D vma->vm_page_prot;
>
> -               .action.type =3D MMAP_NOTHING, /* Default */
> -       };
> +       /* Default. */
> +       desc->action.type =3D MMAP_NOTHING;
> +}
> +
> +static inline unsigned long vma_pages(const struct vm_area_struct *vma)
> +{
> +       return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> +}
> +
> +static inline void unmap_vma_locked(struct vm_area_struct *vma)
> +{
> +       const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> +
> +       mmap_assert_write_locked(vma->vm_mm);
> +       do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> +}
> +
> +static inline int __compat_vma_mapped(struct file *file, struct vm_area_=
struct *vma)
> +{
> +       const struct vm_operations_struct *vm_ops =3D vma->vm_ops;
>         int err;
>
> -       err =3D f_op->mmap_prepare(&desc);
> +       if (!vm_ops->mapped)
> +               return 0;
> +
> +       err =3D vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff,=
 file,
> +                            &vma->vm_private_data);
>         if (err)
> -               return err;
> +               unmap_vma_locked(vma);
> +       return err;
> +}
>
> -       err =3D mmap_action_prepare(&desc);
> +static inline int __compat_vma_mmap(struct vm_area_desc *desc,
> +               struct vm_area_struct *vma)
> +{
> +       int err;
> +
> +       /* Perform any preparatory tasks for mmap action. */
> +       err =3D mmap_action_prepare(desc);
> +       if (err)
> +               return err;
> +       /* Update the VMA from the descriptor. */
> +       compat_set_vma_from_desc(vma, desc);
> +       /* Complete any specified mmap actions. */
> +       err =3D mmap_action_complete(vma, &desc->action);
>         if (err)
>                 return err;
>
> -       set_vma_from_desc(vma, &desc);
> -       return mmap_action_complete(vma, &desc.action);
> +       /* Invoke vm_ops->mapped callback. */
> +       return __compat_vma_mapped(desc->file, vma);
> +}
> +
> +static inline int vfs_mmap_prepare(struct file *file, struct vm_area_des=
c *desc)
> +{
> +       return file->f_op->mmap_prepare(desc);
>  }
>
>  static inline int compat_vma_mmap(struct file *file,
>                 struct vm_area_struct *vma)
>  {
> -       return __compat_vma_mmap(file->f_op, file, vma);
> +       struct vm_area_desc desc;
> +       int err;
> +
> +       compat_set_desc_from_vma(&desc, file, vma);
> +       err =3D vfs_mmap_prepare(file, &desc);
> +       if (err)
> +               return err;
> +
> +       return __compat_vma_mmap(&desc, vma);
>  }
>
>
> @@ -1318,11 +1367,6 @@ static inline void vma_iter_init(struct vma_iterat=
or *vmi,
>         mas_init(&vmi->mas, &mm->mm_mt, addr);
>  }
>
> -static inline unsigned long vma_pages(struct vm_area_struct *vma)
> -{
> -       return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
> -}
> -
>  static inline void mmap_assert_locked(struct mm_struct *);
>  static inline struct vm_area_struct *find_vma_intersection(struct mm_str=
uct *mm,
>                                                 unsigned long start_addr,
> @@ -1492,11 +1536,6 @@ static inline int vfs_mmap(struct file *file, stru=
ct vm_area_struct *vma)
>         return file->f_op->mmap(file, vma);
>  }
>
> -static inline int vfs_mmap_prepare(struct file *file, struct vm_area_des=
c *desc)
> -{
> -       return file->f_op->mmap_prepare(desc);
> -}
> -
>  static inline void vma_set_file(struct vm_area_struct *vma, struct file =
*file)
>  {
>         /* Changing an anonymous vma with this is illegal */
> @@ -1521,11 +1560,3 @@ static inline pgprot_t vma_get_page_prot(vma_flags=
_t vma_flags)
>
>         return vm_get_page_prot(vm_flags);
>  }
> -
> -static inline void unmap_vma_locked(struct vm_area_struct *vma)
> -{
> -       const size_t len =3D vma_pages(vma) << PAGE_SHIFT;
> -
> -       mmap_assert_write_locked(vma->vm_mm);
> -       do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
> -}
> --
> 2.53.0
>

