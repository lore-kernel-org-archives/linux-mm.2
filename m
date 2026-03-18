Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD25103E199
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 16:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 004CC6B02AC; Wed, 18 Mar 2026 12:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7FD6B02AE; Wed, 18 Mar 2026 12:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6416B02AF; Wed, 18 Mar 2026 12:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAEC26B02AC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:00:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8AF5C1D97E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:00:34 +0000 (UTC)
X-FDA: 84559646388.21.60E5694
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id D5694C0009
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:00:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l8i1e0vQ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773849628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8q0J7KCNx+A8Y+J2RSy7VQj65zrNoynNXfOuxxJlza4=;
	b=oKKnkT5nD7DG1rpg1GBsgRcLHK1nr8rEcjopLm06TFYDolXPk/5Y92Fy6O4xkqlDRD4o5k
	RXsWgXJ5blCZ00BcOQSpeAIN9PXqMu0jZN2CrsCsjIZfXMODDc7nD/74sLA1AGhqpHGdoj
	ElkErJiJZ/TbWOVT3lZondueb9evung=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773849628; a=rsa-sha256;
	cv=pass;
	b=XZSCWBvg8othv2llklNgbWSdb1bLxO3Cya6BEBY/b45rTZmP/h308IhXAaDPLBkIei1eXi
	OAJ+lTXPeXi9OoEZzE+VKgxDZMbuaZzfdIzZbMFWXmUo8bjco/+291Il5X4a30SgOO/QQT
	rbAVHJX3RxI78g2XkPRxdnkGZFfYgU0=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l8i1e0vQ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5091ed02c54so687901cf.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 09:00:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773849627; cv=none;
        d=google.com; s=arc-20240605;
        b=Ekmk+MfVf6TbbnZZmR11CCbX3GrFPxF7SeUMp3kKjBPqODaXP+RC0mp5E9vlIS5RgE
         z5ulPJqsxWZ/OCJD0MtvtEXw8YFkfn8Xff5NPZXj3T8xqCFmFfcIxddJC3ydflKcCFEK
         J0q4Im5nadBdC8ho40wA5HLG/pRysCpesHu2Bwh3uKhTe25ohEVcRdjFuPqX9iz1XBLa
         0ciiG+5X5Edvuaf5j0SwL9KWOymaaOhS4saYHkKM0L5a1WSe+9C+qF+CrC6fj3INScaT
         ZD+9eXTnNCGqVsvaDfoQ9GbfljM5rgysGf58GDLmHz5obCiDQgAOYVSqwoafzkye2KsD
         MC1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8q0J7KCNx+A8Y+J2RSy7VQj65zrNoynNXfOuxxJlza4=;
        fh=2gneQMu+5eH0g48LsBj0iDx4kIjK88+wWWjDF7KlOHE=;
        b=QuIbMnrix+j4LgmWpOcqnm/TALqq7aqOqo4h84sljWSklzz4ND6YISHaIvmrFLx0nQ
         ims2UTGWbeW0AU+vF+m00j+LuqrpJAmtB3r0Io03tcP4o7NDDYb/AITuLI3FT/m2NYhX
         /s30hMd8rpobSfWxdxKcIwJwkMExg5GKSRJTsmNc7To2+XIoxqRPJqYLkCuaS6I0oMsZ
         J5vDiDV3GbqgyG7yBT7SR98+G/g2hXXYaEpRT/IldPU4kwgp5o3zQS6se7JWubAIsP8S
         A/wzJcX45U8376G0y2LQRut4SKezBUkuTHE6/zGLqJ2BqXh85rvDJrEXuGF5/zwXW63n
         FP+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773849627; x=1774454427; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8q0J7KCNx+A8Y+J2RSy7VQj65zrNoynNXfOuxxJlza4=;
        b=l8i1e0vQvtCa4eUAz93awAwtBuRx2QUpyKQpnePNeLQHI3aGHv5bZg+FCXRDvBofyg
         jW7D8lBNGPr6WCk2fH4JwxFIZ0O6QQ2iwyb67pHQF6dn2WUJ7IacujXzcDZHDL/dOLHT
         xxDVgBNyQEUzYmvm0b6+6Wz4gCz4CJUuFeFgmQDVlL9WQoWpoB7cdNL+YRVcOpCN52Ho
         tuiac4uQwF7F/navAXxx6VE9TFy1QsiiKHC/2M9GzVLNmVBDPUNRBMi/JvslOXusegi2
         XVk7H6JkLMa0aVjSlCwOapGCpmHCJSrE4zr81QmEk7E2aV0vWlj+YciL0huP0cYlkEgF
         9ylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773849627; x=1774454427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8q0J7KCNx+A8Y+J2RSy7VQj65zrNoynNXfOuxxJlza4=;
        b=Nh1uOkWdTOHTmFop1NMB9aycA0SPdtAR7qG4NBfjFWHt0z2WTyI3QDPfveOTLgmOUD
         nAekWqpQhRQSIsjfK3mcAmV/OHuz49GxxYkx1BCYNnyNeYf9oMgCbrpPYOf9eGjzlnYz
         pGegzAQLQy/HGGWSum2gDHAJx7EouzzfBAOpXlfeKLvEVZsLhZf8vYeAnCIaj7u1K6hC
         4c4juVZlUpumo2WGN+6HhCaTwbnnsfPzDcTJ8PsjXsKZX2Rqn4xfXxQmthZzraqJxVYT
         xD/KHfHfwkwJyB77+C2Ed1LFso5JF81OZusP0mPWhxxy0bCZn8s1CzqcPkWJmDHRiu+Z
         3nTA==
X-Forwarded-Encrypted: i=1; AJvYcCXyKh0sliRETrPe2xToGbydTABNZTcNowX7C8FplYE9li8N1MeEcKziRLbegaDyWCmN6mhBDUHXBA==@kvack.org
X-Gm-Message-State: AOJu0YwChAebB5ZATZ0sVjBNKL2pcusi5iNfd40h2sN7wLcDBlyN1j+1
	0Yytftvxu5paW7Udn/zkvVetH2xgvc9iS4J7HC1K7IUxSBix0gKv/+49KTER+CBLwzThjlrp/qa
	o2NYfG2yRZhi2WJLTxHx+p2AH35d18QPdCVN4RmYv
X-Gm-Gg: ATEYQzwhA//y+Jdm4fCULCsT6eIH1H1HxGNhNY/5iyku8S79lWC0Gd4B8060PT5yrbw
	+X2pidlOOF3Xp2SxTZ3GOjdlUTMV/noe51FAXFpeP14wNCqYdz8muCJna4fBvT/F0mHLqjgk9ib
	7SjtRvBDJZ5bLLf+/7/OHL0RqoLcfyaMcS5bAdY3BbERttfsNe/tyZYYC27q1/vHnhWf1tc9sgk
	FtdPAbfbjFo7d5pmqnqNWoiMJGAi4l6GkwHCt8JPaXlZ9dGz3m/1ohnm+JskTz68jERwNmDRhi7
	h+LBvz7uTmgL4hI8Vf80ZwedDdZ5yiAYHotuMg==
X-Received: by 2002:ac8:7f4d:0:b0:509:174d:3224 with SMTP id
 d75a77b69052e-50b15c109d1mr14316251cf.11.1773849625679; Wed, 18 Mar 2026
 09:00:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <8e28e4b63bae67bfa1a59ccbac9dc6db1442d75d.1773695307.git.ljs@kernel.org>
In-Reply-To: <8e28e4b63bae67bfa1a59ccbac9dc6db1442d75d.1773695307.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 18 Mar 2026 09:00:13 -0700
X-Gm-Features: AaiRm51xXcSMS3sQHOtwlzL9JQsE-2S39fLY5xwjkClhFBo1kCA372O2Zp37zjU
Message-ID: <CAJuCfpF6eS18HLgNvQtkLGd=7N0_L1JPmF0GzM-Z0QimRWT7AQ@mail.gmail.com>
Subject: Re: [PATCH v2 15/16] mm: add mmap_action_map_kernel_pages[_full]()
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
X-Stat-Signature: z9xa8mf4zg1zgobro6a1zbayqxtwu3wk
X-Rspamd-Queue-Id: D5694C0009
X-Rspamd-Server: rspam03
X-HE-Tag: 1773849627-809253
X-HE-Meta: U2FsdGVkX1+nu0UADN7UUR5zuebJ7I89vaE5V9TnkVoEUubf2JzTC9773K0dnHPg/Zq8hxBy4y4vwCZ30vvFL6A4AK9regC4G5h1HASDeF6H05tfuSYoBJ/nJIL0qK4Lb/XGzyFbhwT/hvsUrkIZftZiycYNkXEtM6B1tUC/ApVFQzSJeEtVJpZGQ3hP1bq2pmd2ANqWkHPLSnB4/ZK8oYs76zkCCIwE+SRJ8QfyNr9EW7D8ovZweYZNEgCd9ph3VeCsHYchN9BKkB2eKO5OOs0lI90SrBbzyrUAC+v/3L9V95Bf3TolBkYMd3sjSIMVIn0HoARVy/zEKhsjcU2WuEdj/XZhOxCeiWx7l5ctHZSSE8SrpP1lJVeMF4oMg7nkBQl1YYcrku8AbF7y5eUWQ6RUYpdOijn1YO0O1DW1ULBqZtCJgBjH3lK/g+PyYN5qy+xrSeRveIf2j8ky47Q+rcucIaZU3MuOgGoRwHUuu8jeRrLvMIIfIeFqevFVV/Uy0q+jOEUQfaCAj8JAF+MD2NFEmqxQbdy1zk9Y+pFTAjPTUAI7WNscSYOQvaHz7J90GBDIEDGUtZtnP64azXrN3ZjLUY4kTQEttzftvYAW8l4H2NK8f8gj9ptXOScNWduGhISnSvOZO5EGK97V0TJHTAZK0+z/ioJ5xoRgASAKZDJSvRFKPguuxjqhuztZySj7H1D7mD7zfiaU7Mko+Hg5R2OeMk2u4ocfVNqHA1qdTEbcpUufm2j7rhakY+ffsjUQKAGCatv2G8amn4fwKIonsQr0Eus7baBFBcClKmVbi0GNyCT9KCJ23GDeZhjtCuvqKs+oTtZWIM3kZDmgV495kl3ku4CjgA9hn3kGo/23S7ywBIhRyux7lsD1e+NF6k06+iCpAevQWDPKaLV+0Nie9ddNgP2ItRX5oFJgbTvQSxksSlIl8u4y+ooPxJhynVa99CkWTvoUfQPU87EsNdV
 t7WGsp2R
 hul5IxkRHMP116BBsKlIHzuP1In4+oSi5l5IOpwwIOc3ee524OQfOGFrPljuDMU+xYCCqz09HLUWqV2zT6MO5vuI0lONJ+LCUwK84OWsPIx5cl51aWZCLAcLfE743SaLImh1BfUG7GeDx53R4ZunRHXiBdRy2GQKVbB4GJrmM3CZlSmkkHdjyl77PrQ76LiTSIIWPvv4yMYM5j8gV58z2DQ+/MeAmnyNusdSgjhl2xQxxd08Ev6AeD2JBHVch2WctuFBY73xHgm7XmF7xhGh3eUWLvk5JWshxdZFSyTkWhETvx8hNbAXftZ+vSK4Qdh374/ZaZwsG74Jb81xFdrl5GDHlHE4SfFrq12eVXzCIpVkCyyqNUZJhBEa+qDiWcQFXUhUk0VG+/JSCsAL6gIYvH3cxiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> A user can invoke mmap_action_map_kernel_pages() to specify that the
> mapping should map kernel pages starting from desc->start of a specified
> number of pages specified in an array.
>
> In order to implement this, adjust mmap_action_prepare() to be able to
> return an error code, as it makes sense to assert that the specified
> parameters are valid as quickly as possible as well as updating the VMA
> flags to include VMA_MIXEDMAP_BIT as necessary.
>
> This provides an mmap_prepare equivalent of vm_insert_pages().
>
> We additionally update the existing vm_insert_pages() code to use
> range_in_vma() and add a new range_in_vma_desc() helper function for the
> mmap_prepare case, sharing the code between the two in range_is_subset().
>
> We add both mmap_action_map_kernel_pages() and
> mmap_action_map_kernel_pages_full() to allow for both partial and full VM=
A
> mappings.
>
> We also add mmap_action_map_kernel_pages_discontig() to allow for
> discontiguous mapping of kernel pages should the need arise.
>
> We update the documentation to reflect the new features.
>
> Finally, we update the VMA tests accordingly to reflect the changes.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

With one nit,
Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  Documentation/filesystems/mmap_prepare.rst |  8 ++
>  include/linux/mm.h                         | 95 +++++++++++++++++++++-
>  include/linux/mm_types.h                   |  7 ++
>  mm/memory.c                                | 42 +++++++++-
>  mm/util.c                                  |  6 ++
>  tools/testing/vma/include/dup.h            |  7 ++
>  6 files changed, 159 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/f=
ilesystems/mmap_prepare.rst
> index be76ae475b9c..e810aa4134eb 100644
> --- a/Documentation/filesystems/mmap_prepare.rst
> +++ b/Documentation/filesystems/mmap_prepare.rst
> @@ -156,5 +156,13 @@ pointer. These are:
>  * mmap_action_simple_ioremap() - Sets up an I/O remap from a specified
>    physical address and over a specified length.
>
> +* mmap_action_map_kernel_pages() - Maps a specified array of `struct pag=
e`
> +  pointers in the VMA from a specific offset.
> +
> +* mmap_action_map_kernel_pages_full() - Maps a specified array of `struc=
t
> +  page` pointers over the entire VMA. The caller must ensure there are
> +  sufficient entries in the page array to cover the entire range of the
> +  described VMA.
> +
>  **NOTE:** The ``action`` field should never normally be manipulated dire=
ctly,
>  rather you ought to use one of these helpers.
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index df8fa6e6402b..6f0a3edb24e1 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2912,7 +2912,7 @@ static inline bool folio_maybe_mapped_shared(struct=
 folio *folio)
>   * The caller must add any reference (e.g., from folio_try_get()) it mig=
ht be
>   * holding itself to the result.
>   *
> - * Returns the expected folio refcount.
> + * Returns: the expected folio refcount.

nit: I see both "Returns:" and "Return:" being used in the codebase
but this header file uses "Return:", so for consistency you should
probably do the same. This also applies to later instances in this
patch.

>   */
>  static inline int folio_expected_ref_count(const struct folio *folio)
>  {
> @@ -4364,6 +4364,45 @@ static inline void mmap_action_simple_ioremap(stru=
ct vm_area_desc *desc,
>         action->type =3D MMAP_SIMPLE_IO_REMAP;
>  }
>
> +/**
> + * mmap_action_map_kernel_pages - helper for mmap_prepare hook to specif=
y that
> + * @num kernel pages contained in the @pages array should be mapped to u=
serland
> + * starting at virtual address @start.
> + * @desc: The VMA descriptor for the VMA requiring kernel pags to be map=
ped.
> + * @start: The virtual address from which to map them.
> + * @pages: An array of struct page pointers describing the memory to map=
.
> + * @nr_pages: The number of entries in the @pages aray.
> + */
> +static inline void mmap_action_map_kernel_pages(struct vm_area_desc *des=
c,
> +               unsigned long start, struct page **pages,
> +               unsigned long nr_pages)
> +{
> +       struct mmap_action *action =3D &desc->action;
> +
> +       action->type =3D MMAP_MAP_KERNEL_PAGES;
> +       action->map_kernel.start =3D start;
> +       action->map_kernel.pages =3D pages;
> +       action->map_kernel.nr_pages =3D nr_pages;
> +       action->map_kernel.pgoff =3D desc->pgoff;
> +}
> +
> +/**
> + * mmap_action_map_kernel_pages_full - helper for mmap_prepare hook to s=
pecify that
> + * kernel pages contained in the @pages array should be mapped to userla=
nd
> + * from @desc->start to @desc->end.
> + * @desc: The VMA descriptor for the VMA requiring kernel pags to be map=
ped.
> + * @pages: An array of struct page pointers describing the memory to map=
.
> + *
> + * The caller must ensure that @pages contains sufficient entries to cov=
er the
> + * entire range described by @desc.
> + */
> +static inline void mmap_action_map_kernel_pages_full(struct vm_area_desc=
 *desc,
> +               struct page **pages)
> +{
> +       mmap_action_map_kernel_pages(desc, desc->start, pages,
> +                                    vma_desc_pages(desc));
> +}
> +
>  int mmap_action_prepare(struct vm_area_desc *desc);
>  int mmap_action_complete(struct vm_area_struct *vma,
>                          struct mmap_action *action);
> @@ -4380,10 +4419,59 @@ static inline struct vm_area_struct *find_exact_v=
ma(struct mm_struct *mm,
>         return vma;
>  }
>
> +/**
> + * range_is_subset - Is the specified inner range a subset of the outer =
range?
> + * @outer_start: The start of the outer range.
> + * @outer_end: The exclusive end of the outer range.
> + * @inner_start: The start of the inner range.
> + * @inner_end: The exclusive end of the inner range.
> + *
> + * Returns: %true if [inner_start, inner_end) is a subset of [outer_star=
t,
> + * outer_end), otherwise %false.
> + */
> +static inline bool range_is_subset(unsigned long outer_start,
> +                                  unsigned long outer_end,
> +                                  unsigned long inner_start,
> +                                  unsigned long inner_end)
> +{
> +       return outer_start <=3D inner_start && inner_end <=3D outer_end;
> +}
> +
> +/**
> + * range_in_vma - is the specified [@start, @end) range a subset of the =
VMA?
> + * @vma: The VMA against which we want to check [@start, @end).
> + * @start: The start of the range we wish to check.
> + * @end: The exclusive end of the range we wish to check.
> + *
> + * Returns: %true if [@start, @end) is a subset of [@vma->vm_start,
> + * @vma->vm_end), %false otherwise.
> + */
>  static inline bool range_in_vma(const struct vm_area_struct *vma,
>                                 unsigned long start, unsigned long end)
>  {
> -       return (vma && vma->vm_start <=3D start && end <=3D vma->vm_end);
> +       if (!vma)
> +               return false;
> +
> +       return range_is_subset(vma->vm_start, vma->vm_end, start, end);
> +}
> +
> +/**
> + * range_in_vma_desc - is the specified [@start, @end) range a subset of=
 the VMA
> + * described by @desc, a VMA descriptor?
> + * @desc: The VMA descriptor against which we want to check [@start, @en=
d).
> + * @start: The start of the range we wish to check.
> + * @end: The exclusive end of the range we wish to check.
> + *
> + * Returns: %true if [@start, @end) is a subset of [@desc->start, @desc-=
>end),
> + * %false otherwise.
> + */
> +static inline bool range_in_vma_desc(const struct vm_area_desc *desc,
> +                                    unsigned long start, unsigned long e=
nd)
> +{
> +       if (!desc)
> +               return false;
> +
> +       return range_is_subset(desc->start, desc->end, start, end);
>  }
>
>  #ifdef CONFIG_MMU
> @@ -4427,6 +4515,9 @@ int remap_pfn_range(struct vm_area_struct *vma, uns=
igned long addr,
>  int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct p=
age *);
>  int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
>                         struct page **pages, unsigned long *num);
> +int map_kernel_pages_prepare(struct vm_area_desc *desc);
> +int map_kernel_pages_complete(struct vm_area_struct *vma,
> +                             struct mmap_action *action);
>  int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
>                                 unsigned long num);
>  int vm_map_pages_zero(struct vm_area_struct *vma, struct page **pages,
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 7538d64f8848..c46224020a46 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -815,6 +815,7 @@ enum mmap_action_type {
>         MMAP_REMAP_PFN,         /* Remap PFN range. */
>         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
>         MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> +       MMAP_MAP_KERNEL_PAGES,  /* Map kernel page range from array. */
>  };
>
>  /*
> @@ -833,6 +834,12 @@ struct mmap_action {
>                         phys_addr_t start_phys_addr;
>                         unsigned long size;
>                 } simple_ioremap;
> +               struct {
> +                       unsigned long start;
> +                       struct page **pages;
> +                       unsigned long nr_pages;
> +                       pgoff_t pgoff;
> +               } map_kernel;
>         };
>         enum mmap_action_type type;
>
> diff --git a/mm/memory.c b/mm/memory.c
> index f3f4046aee97..849d5d9eeb83 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2484,13 +2484,14 @@ static int insert_pages(struct vm_area_struct *vm=
a, unsigned long addr,
>  int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
>                         struct page **pages, unsigned long *num)
>  {
> -       const unsigned long end_addr =3D addr + (*num * PAGE_SIZE) - 1;
> +       const unsigned long nr_pages =3D *num;
> +       const unsigned long end =3D addr + PAGE_SIZE * nr_pages;
>
> -       if (addr < vma->vm_start || end_addr >=3D vma->vm_end)
> +       if (!range_in_vma(vma, addr, end))
>                 return -EFAULT;
>         if (!(vma->vm_flags & VM_MIXEDMAP)) {
> -               BUG_ON(mmap_read_trylock(vma->vm_mm));
> -               BUG_ON(vma->vm_flags & VM_PFNMAP);
> +               VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
> +               VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
>                 vm_flags_set(vma, VM_MIXEDMAP);
>         }
>         /* Defer page refcount checking till we're about to map that page=
. */
> @@ -2498,6 +2499,39 @@ int vm_insert_pages(struct vm_area_struct *vma, un=
signed long addr,
>  }
>  EXPORT_SYMBOL(vm_insert_pages);
>
> +int map_kernel_pages_prepare(struct vm_area_desc *desc)
> +{
> +       const struct mmap_action *action =3D &desc->action;
> +       const unsigned long addr =3D action->map_kernel.start;
> +       unsigned long nr_pages, end;
> +
> +       if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
> +               VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> +               VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> +               vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> +       }
> +
> +       nr_pages =3D action->map_kernel.nr_pages;
> +       end =3D addr + PAGE_SIZE * nr_pages;
> +       if (!range_in_vma_desc(desc, addr, end))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(map_kernel_pages_prepare);
> +
> +int map_kernel_pages_complete(struct vm_area_struct *vma,
> +                             struct mmap_action *action)
> +{
> +       unsigned long nr_pages;
> +
> +       nr_pages =3D action->map_kernel.nr_pages;
> +       return insert_pages(vma, action->map_kernel.start,
> +                           action->map_kernel.pages,
> +                           &nr_pages, vma->vm_page_prot);
> +}
> +EXPORT_SYMBOL(map_kernel_pages_complete);
> +
>  /**
>   * vm_insert_page - insert single page into user vma
>   * @vma: user vma to map to
> diff --git a/mm/util.c b/mm/util.c
> index a166c48fe894..dea590e7a26c 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1441,6 +1441,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>                 return io_remap_pfn_range_prepare(desc);
>         case MMAP_SIMPLE_IO_REMAP:
>                 return simple_ioremap_prepare(desc);
> +       case MMAP_MAP_KERNEL_PAGES:
> +               return map_kernel_pages_prepare(desc);
>         }
>
>         WARN_ON_ONCE(1);
> @@ -1472,6 +1474,9 @@ int mmap_action_complete(struct vm_area_struct *vma=
,
>         case MMAP_IO_REMAP_PFN:
>                 err =3D io_remap_pfn_range_complete(vma, action);
>                 break;
> +       case MMAP_MAP_KERNEL_PAGES:
> +               err =3D map_kernel_pages_complete(vma, action);
> +               break;
>         case MMAP_SIMPLE_IO_REMAP:
>                 /*
>                  * The simple I/O remap should have been delegated to an =
I/O
> @@ -1494,6 +1499,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
>         case MMAP_REMAP_PFN:
>         case MMAP_IO_REMAP_PFN:
>         case MMAP_SIMPLE_IO_REMAP:
> +       case MMAP_MAP_KERNEL_PAGES:
>                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
>                 break;
>         }
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 6658df26698a..4407caf207ad 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -454,6 +454,7 @@ enum mmap_action_type {
>         MMAP_REMAP_PFN,         /* Remap PFN range. */
>         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
>         MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> +       MMAP_MAP_KERNEL_PAGES,  /* Map kernel page range from an array. *=
/
>  };
>
>  /*
> @@ -472,6 +473,12 @@ struct mmap_action {
>                         phys_addr_t start;
>                         unsigned long len;
>                 } simple_ioremap;
> +               struct {
> +                       unsigned long start;
> +                       struct page **pages;
> +                       unsigned long num;
> +                       pgoff_t pgoff;
> +               } map_kernel;
>         };
>         enum mmap_action_type type;
>
> --
> 2.53.0
>

