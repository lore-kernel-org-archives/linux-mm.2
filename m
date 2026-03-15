Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B334CF30283
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 23:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FCD86B00EA; Sun, 15 Mar 2026 19:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AB4A6B00EB; Sun, 15 Mar 2026 19:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562D46B00EC; Sun, 15 Mar 2026 19:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4433A6B00EA
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 19:23:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA35B8D070
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:23:28 +0000 (UTC)
X-FDA: 84549876096.18.C4E1E2F
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id AFD001C0003
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:23:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y8P+jdtk;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773617006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OT8Iw6M557aLYwHQwbfjFt5SgiwLxQR3GJ4aDtnOQyU=;
	b=4ecfIImPlsYRUjcpVloLrJ9Bxdj0nSSEiVhrVvfiNakEJ4gajVKTbOjZXTT5HtZjKBHYIn
	HaheBn7h+HugIIwY9AEacLjogupBiDpjBYU5MtMuYC5b9RXh5X8b6EgbQyeuu0uPlKKrmH
	EjddhFrHcgAlkNQ+Y/A7G97EvIwCwqs=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y8P+jdtk;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773617006; a=rsa-sha256;
	cv=pass;
	b=StA7UGfnL6JJcMijnuBqDMIL8sUagJfxZEWSgonDIR25cgRrwjHZ5hIA6L9GnISkNa1zXm
	S5bFvIhz71xFFRUpFv4yhhajJD21ppNgSheLZ4Hazsw0tRv8EdOjSyzBeKPw4HkKXlpnbw
	EG4++Vj69B5IQLpHAcUqdDsVlyklJ7Y=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5091ed02c54so711031cf.1
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:23:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773617006; cv=none;
        d=google.com; s=arc-20240605;
        b=crr5sxWm5c4Zsb+WiKktOcH0afMlUefHpOtCkRztDznHBKm06TwWQf5ltFd7m2G85E
         eilJZNy2A1VdyvxCVZW7P2aXc6dyvg8HE9n+MCJ/YHQXHmKZ0c/lB6mRq56Ej3p9SHwx
         UJw9JEaAn4wWbZJOv8O7egGwxzeF3JUmMKMduCrdEmO7Q0aN4jSknB4t5Myq8j50HMo2
         STB3c+/o8XjjC78mjJdfeDcK1wWVvKp7V8+7gXlgj84E+C2pY02wIyTBJJXUDAzlZYJa
         s0KKISO/d3GrJzL3aIakjmoEbDcAondTSyVwVqpc9HjxPmk6JvJLptom6AJFIJDo20nz
         fVNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OT8Iw6M557aLYwHQwbfjFt5SgiwLxQR3GJ4aDtnOQyU=;
        fh=aJN9fec4mXWJzeYN5zbnjsBxac3BpQKRSszhw/XRZSI=;
        b=dzFbYsvvJ5gsUHULzKZg5JCBaryHXKt4KVlFu84c/gT4dWhyHcjbD5/P4TNyTXPlzC
         cLriNqruipsjDTgomvqqmFkRPDPkxQW0p7hPTg6zy59iFnn9zNgA9+Q0jN75qpFm+yp3
         g2eR548H3quJDq0AnrzVT+N9uh6b5IrIZeJbW5rPs5ZH6azjVjC9lubICw87OX680+wh
         pSwBH5z2+EDjPceLu3RYRMfNhPtDRVV4n37VGSJvRmuqRIpfX1KoPUKcIcf9/8usARGi
         kK/oX7HeC5PV1xzJ7/T4kt5F0HvPXacYha9UiXVTO1g0lGcX16V3rKVaeol8fK0Y8B/r
         W+ng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773617006; x=1774221806; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OT8Iw6M557aLYwHQwbfjFt5SgiwLxQR3GJ4aDtnOQyU=;
        b=Y8P+jdtk/bHUviR2dt+cwUXR6Kj1f1Apf4aZPAkYWJ21ZmwgTY1n6t+fg7y/UWokq+
         6ikr2mtNduEZmb4fMYlIWQd1uJS2+uyc0LtRqbg27FCe5C1X0B9XS5GfuArXjTGhQ2aH
         ihg5bwzIqwHys+sGFW5Vh9hBdymiyInTB/nzWbH5tePoSLspjXd6c20Oy6XNPRtEbE7u
         Mg/f8OOq3Ct5bP/82wOfoxC2OheDe82AwZr1RkEYMwdHZKyqpfGphNYLNZj4duBQNrdO
         vA6BYTW/BcsNkqlJIinBg/1y9RrgMjEKBjsTHEMwdxJTJ22n61II4Pi3w8AJCpd0sL6f
         977Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773617006; x=1774221806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OT8Iw6M557aLYwHQwbfjFt5SgiwLxQR3GJ4aDtnOQyU=;
        b=r17zuIrYotdk0ZS2hbKMCUZ6jurw4TMyOb3XGp37UIEAsC1AkRWnRixMOPN5to2Oh1
         T3AyTk+L6iSgZ6303venw6pNEbRRKARuSMcZVgJw8CSz0qrZNblgRGGgujN1GU2XnZPU
         6HP7GWGdG1rVT9UNKmhJKMubY6yFf7WNdhK59+wA7YH8VuJg7uo4+hsIaRqLR8/P08kQ
         2lRwjx+VHoA7/9pixt36SsBBJZAP9ZVku5+ybhNMWeCbRYKyejWAQx2ZKiXq2qCm5HKY
         vootHTBjZzYN8p64FbCdtc+Yl6BZv3X0gax/+wGSyXOMGvWv7O8Ab536Ns/ag5OhAI7I
         5Qkg==
X-Forwarded-Encrypted: i=1; AJvYcCXLNvpdWqH70O2ETn96noUVjIwL9XbPnLN1DSuk+0IMpB+I0e84q6oyX9BMTUTLc/7Bvb6N3VXUbg==@kvack.org
X-Gm-Message-State: AOJu0YziiQbkt5NZ2oCodfi7MB98DEt6Ob0wy8fAyBxCHP0lqDvGGToJ
	Ka2fdRGlQRI7sy08ZcRDC7U74VG5LXbVZAYpStFKdUN7ZERyZgLybxisf0Y1l33GOkf+UAPxMuw
	SdgvJaTeaLHp5OzEh8XuwnKvhdjjsi/wGuS0V4net
X-Gm-Gg: ATEYQzwQKx5L0zs3OL2gfW8ycEt+gzkRgqwlCpgbGeh0y8NJgVjkNWpdqDmfyN+PqR7
	X6kyzbxS9BF06eqSVsWcEPSL8UmmspFl9KdmJiN357uqQsfm3V+rdn9lZrIo0mP6prg/7a7ncd0
	MI7CFpYXUGukNJRnfhj+GyGRZkMK3tWvEaWNF6sQI5bXQJeFY+euZdNH1iYO4tnIWUmGdkXM/9g
	S6yyLTevjuA7tJZ+IV7c+HPJmjH9NKdTpvxov4qCCkGGWhePnEXjEx/qGR2cl74q8d8bSL++ehX
	cj5wpt5e3jOM7vlf
X-Received: by 2002:a05:622a:1822:b0:509:1d4b:f86f with SMTP id
 d75a77b69052e-509694fc2a0mr18649221cf.14.1773617005021; Sun, 15 Mar 2026
 16:23:25 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773346620.git.ljs@kernel.org> <c5bb61cf789df1ecb32facc29df9749987c7ddfc.1773346620.git.ljs@kernel.org>
In-Reply-To: <c5bb61cf789df1ecb32facc29df9749987c7ddfc.1773346620.git.ljs@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 15 Mar 2026 16:23:14 -0700
X-Gm-Features: AaiRm50msQxab5MfkpLsIIibDHC-kfdIQCyqr3kXogsNup53_Z_U3j15wVPbEHM
Message-ID: <CAJuCfpGd702=Xop3X5Aop9rrScdiAOQEEooTu1gcJqR9pmO5GA@mail.gmail.com>
Subject: Re: [PATCH 02/15] mm: add documentation for the mmap_prepare file
 operation callback
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
X-Rspamd-Queue-Id: AFD001C0003
X-Stat-Signature: wifw9y8np4qmxkeoydptwzj4gx4tpauz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773617006-914072
X-HE-Meta: U2FsdGVkX19g9WMTZzfa/qZSOjFCiRj2ZzJCouh1tVYZQpMxXZI8oGbAn76fx4dkezPp86UwCCTXBiNWi8/885vp/CHDPO2Z8JVKsqyG6XT8ZHLNWsySHknrX2v9fs7rmlqvaWeF8suTtUiV/Cq8p4YVciLOCJoZWcItAkRLDqGi/JTyAbayPEQrks7lWzrQAM0sySUoFu8JI38QTE1xM41v1RRb4tZ8KZOTgrIA2lFVQssBYK0yr2Nnqzhk77LGDGCznEIflGrwbz4FYL25DtActDXsv7hmjEXZm9quA8aq6bhAYSHVQyNA/0cRy4RPvs2hL7ieXHU1JlNISVw8AzJ2wOQD/2tGffp4yC/Fb0/9+g1wbA1sDxxtiNqlZXG2ZB+PjmIH38hpoq2Ws7xvdy/wrDBSDEZS1EPVltRghHzosABXN1s6zE3EWpWH1VkXv+BaoQQtUqdzLYFZu9CmTd2OA948Xp/Hny3RlMPfon/jPZtbnb7Bjb9V3WqRxIg8N1p03Fku9lwzpJlOW3g66/UCVSxX7BBf8JhSnzJlGLKf3IpJzjmX92BJoeBZ0iUmEk8kPg/sVR7ezfL/Znzf4uEhpmwRjBdq47zyaZzLkFxmb/uVVHW1bYEKMRdemVwyctbZO8oDUCBtKwmMYlQAKBlldYhLurJFewx2pMkv3K058dZcBm6sbz9aUbShTH5P6qErVkqYFMnj2DQGo8UGPI81wUi5M+vW9ty4Ps0UAxAHuuQsI16MxtrB19qN5ukiOueYHnH1TRD+Tfo1SFeta7S41x9k2yjfGFtSDZ/aQjUAw1o25xVM3fOE5qde2XrhtcwvK5m4yOmonJ5G5Iwtw4hbacdecVUj+lJPnMlULFXKC9e06hlKHYdb97FMo5FRIKvCKLe0DK0Umi9VfC1pPTr6GVJ7xrpRESQrCfDAJmVFTz2B9ZWzErlRoDgKvQA6pbgNIu/aQwyU4Ng+zLq
 uNOEq2cR
 GZxY97FBTaJfSYQZ/fz5/e+fGuxi9Z4hmf5KH36k/uc9vWg95VMNfN91OSK4GZZV4taE4vUeG7sP11cX+AFoaBfyP++S/9Pej9+VqPcGvmd73bbvHS+Ui2ngHATYLxB4cGMQ31hSVoehKhe8JNazprC8KkwVa6OmkKQVWhf/OCnx6aJl8y0aC3nvaM2ezwmjYaBb9rROLMpnbqHdx1xWlt7mYoSJep65I5JFZhVr4697mwjuzG9siFE8KXcNrqNOcZH02hKVPJyFGqpNViNA5lZcLWNCo7JjqYBgsmSyaJhq9zE3TwFbT6oritgeznmIl+H0PbLNfjjBIavdTRAA50qgLKwQbGZoqWVRNW8AvTntSvkXI61ap+h5Qt1Xdnuioazob
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 1:27=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> This documentation makes it easier for a driver/file system implementer t=
o
> correctly use this callback.
>
> It covers the fundamentals, whilst intentionally leaving the less lovely
> possible actions one might take undocumented (for instance - the
> success_hook, error_hook fields in mmap_action).
>
> The document also covers the new VMA flags implementation which is the on=
ly
> one which will work correctly with mmap_prepare.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  Documentation/filesystems/mmap_prepare.rst | 131 +++++++++++++++++++++
>  1 file changed, 131 insertions(+)
>  create mode 100644 Documentation/filesystems/mmap_prepare.rst
>
> diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentation/f=
ilesystems/mmap_prepare.rst
> new file mode 100644
> index 000000000000..76908200f3a1
> --- /dev/null
> +++ b/Documentation/filesystems/mmap_prepare.rst
> @@ -0,0 +1,131 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +mmap_prepare callback HOWTO
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +
> +Introduction
> +############
> +
> +The `struct file->f_op->mmap()` callback has been deprecated as it is bo=
th a
> +stability and security risk, and doesn't always permit the merging of ad=
jacent
> +mappings resulting in unnecessary memory fragmentation.
> +
> +It has been replaced with the `file->f_op->mmap_prepare()` callback whic=
h solves
> +these problems.
> +
> +## How To Use
> +
> +In your driver's `struct file_operations` struct, specify an `mmap_prepa=
re`
> +callback rather than an `mmap` one, e.g. for ext4:
> +
> +
> +.. code-block:: C
> +
> +    const struct file_operations ext4_file_operations =3D {
> +        ...
> +        .mmap_prepare    =3D ext4_file_mmap_prepare,
> +    };
> +
> +This has a signature of `int (*mmap_prepare)(struct vm_area_desc *)`.
> +
> +Examining the `struct vm_area_desc` type:
> +
> +.. code-block:: C
> +
> +    struct vm_area_desc {
> +        /* Immutable state. */
> +        const struct mm_struct *const mm;
> +        struct file *const file; /* May vary from vm_file in stacked cal=
lers. */
> +        unsigned long start;
> +        unsigned long end;
> +
> +        /* Mutable fields. Populated with initial state. */
> +        pgoff_t pgoff;
> +        struct file *vm_file;
> +        vma_flags_t vma_flags;
> +        pgprot_t page_prot;
> +
> +        /* Write-only fields. */
> +        const struct vm_operations_struct *vm_ops;
> +        void *private_data;
> +
> +        /* Take further action? */
> +        struct mmap_action action;

So, action still belongs to /* Write-only fields. */ section? This is
nitpicky, but it might be better to have this as:

        /* Write-only fields. */
        const struct vm_operations_struct *vm_ops;
        void *private_data;
        struct mmap_action action; /* Take further action? */

> +    };
> +
> +This is straightforward - you have all the fields you need to set up the
> +mapping, and you can update the mutable and writable fields, for instanc=
e:
> +
> +.. code-block:: Cw
> +
> +    static int ext4_file_mmap_prepare(struct vm_area_desc *desc)
> +    {
> +        int ret;
> +        struct file *file =3D desc->file;
> +        struct inode *inode =3D file->f_mapping->host;
> +
> +        ...
> +
> +        file_accessed(file);
> +        if (IS_DAX(file_inode(file))) {
> +            desc->vm_ops =3D &ext4_dax_vm_ops;
> +            vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT);
> +        } else {
> +            desc->vm_ops =3D &ext4_file_vm_ops;
> +        }
> +        return 0;
> +    }
> +
> +Importantly, you no longer have to dance around with reference counts or=
 locks
> +when updating these fields - __you can simply go ahead and change them__=
.
> +
> +Everything is taken care of by the mapping code.
> +
> +VMA Flags
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Along with `mmap_prepare`, VMA flags have undergone an overhaul. Where b=
efore
> +you would invoke one of `vm_flags_init()`, `vm_flags_reset()`, `vm_flags=
_set()`,
> +`vm_flags_clear()`, and `vm_flags_mod()` to modify flags (and to have th=
e
> +locking done correctly for you, this is no longer necessary.
> +
> +Also, the legacy approach of specifying VMA flags via `VM_READ`, `VM_WRI=
TE`,
> +etc. - i.e. using a `VM_xxx` macro has changed too.
> +
> +When implementing `mmap_prepare()`, reference flags by their bit number,=
 defined
> +as a `VMA_xxx_BIT` macro, e.g. `VMA_READ_BIT`, `VMA_WRITE_BIT` etc., and=
 use one
> +of (where `desc` is a pointer to `struct vma_area_desc`):
> +
> +* `vma_desc_test_flags(desc, ...)` - Specify a comma-separated list of f=
lags you
> +  wish to test for (whether _any_ are set), e.g. - `vma_desc_test_flags(=
desc,
> +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)` - returns `true` if either are set,
> +  otherwise `false`.
> +* `vma_desc_set_flags(desc, ...)` - Update the VMA descriptor flags to s=
et
> +  additional flags specified by a comma-separated list,
> +  e.g. - `vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT)`.
> +* `vma_desc_clear_flags(desc, ...)` - Update the VMA descriptor flags to=
 clear
> +  flags specified by a comma-separated list, e.g. - `vma_desc_clear_flag=
s(desc,
> +  VMA_WRITE_BIT, VMA_MAYWRITE_BIT)`.
> +
> +Actions
> +=3D=3D=3D=3D=3D=3D=3D
> +
> +You can now very easily have actions be performed upon a mapping once se=
t up by
> +utilising simple helper functions invoked upon the `struct vm_area_desc`
> +pointer. These are:
> +
> +* `mmap_action_remap()` - Remaps a range consisting only of PFNs for a s=
pecific
> +  range starting a virtual address and PFN number of a set size.
> +
> +* `mmap_action_remap_full()` - Same as `mmap_action_remap()`, only remap=
s the
> +  entire mapping from `start_pfn` onward.
> +
> +* `mmap_action_ioremap()` - Same as `mmap_action_remap()`, only performs=
 an I/O
> +  remap.
> +
> +* `mmap_action_ioremap_full()` - Same as `mmap_action_ioremap()`, only r=
emaps
> +  the entire mapping from `start_pfn` onward.
> +
> +**NOTE:** The 'action' field should never normally be manipulated direct=
ly,
> +rather you ought to use one of these helpers.

I'm guessing the start and size parameters passed to
mmap_action_remap() and such are restricted by vm_area_desc.start
vm_area_desc.end. If so, should we document those restrictions and
enforce them in the code?

> +    struct vm_area_desc {
> +        /* Immutable state. */
> +        const struct mm_struct *const mm;
> +        struct file *const file; /* May vary from vm_file in stacked cal=
lers. */
> +        unsigned long start;
> +        unsigned long end;


> --
> 2.53.0
>

