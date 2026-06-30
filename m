Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCC2C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 17:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4346B00B4; Tue, 30 Jun 2026 13:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC256B00B6; Tue, 30 Jun 2026 13:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2A26B00B7; Tue, 30 Jun 2026 13:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCDA46B00B4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:19:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F40FC3107
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:19:35 +0000 (UTC)
X-FDA: 84937240710.20.1C6215D
Received: from mxout1.mail.janestreet.com (mxout1.mail.janestreet.com [38.105.200.78])
	by imf14.hostedemail.com (Postfix) with ESMTP id 17AE1100016
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:19:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=janestreet.com header.s=google header.b=QcUs3kXp;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=COtkADUn;
	dmarc=pass (policy=quarantine) header.from=janestreet.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of gleventhal@janestreet.com designates 38.105.200.78 as permitted sender) smtp.mailfrom=gleventhal@janestreet.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782839973;
	b=CG4zwUNIhitfCOwTu2HSqLabEBUaJC0rd4ebUo7ndOmHngdOFAu+H07Y5F6Br+gWkZ6IxH
	sLH9kr8A2Hl1tzx9i3sNGndkytAK8xHVmjDb1qCcq17rJ9TsGMbdVfd8+hdpqfyqNpN/22
	VxQAK8n+bnq3RTIfA7YRgQYW5yhnSpc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782839973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3BDFr13lzvW17ABaI0/sIN4i/vOburrsEmcy0l5nOs=;
	b=oqXJ5Rdnwi8hjmGYw9+Bf+Pt/5Yrtxe7tv2UAho/koP6bBt6aDUglNcJ0de7fqB6h/3TiA
	qIoFE4dPaZlAoSqb1IX+U2TFacBJ0Cn5SakNFA+TrPhJVVscUkOYYyj3quQ1gBGuKzwW1G
	MvAWio+jJpUeCFOXkUuA6NvEoQGSCsA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=janestreet.com header.s=google header.b=QcUs3kXp;
	dkim=pass header.d=janestreet.com header.s=waixah header.b=COtkADUn;
	dmarc=pass (policy=quarantine) header.from=janestreet.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of gleventhal@janestreet.com designates 38.105.200.78 as permitted sender) smtp.mailfrom=gleventhal@janestreet.com
Received: from mail-lj1-f199.google.com ([209.85.208.199])
 	by mxgoog2.mail.janestreet.com with esmtps (TLS1.3:TLS_AES_128_GCM_SHA256:128)
 	(Exim 4.99.4)
 	id 1wec7Q-00000008PpA-2QJE
 	for linux-mm@kvack.org;
 	Tue, 30 Jun 2026 13:19:32 -0400
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-399c5ee9eeeso26285271fa.3
         for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:19:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782839971; cv=none;
         d=google.com; s=arc-20260327;
         b=nn6vjno4PTe6RGMdQUyyF83v0YwoIX549B8g1Q3P0/2HD1xPtbV2Zc8AKn2mdRtGYv
          SSXr1gynQ4UMt+JKH5W5k44bq8MKbZhvW/CZzZN+7aVOc9ha0gXsXxzueRlWtlPK6xPL
          6AgXUAPi4cSWmMpdVtCBjM5yVdiXkoXJdw7G0FqdZJUMCLuPwzF1FtSEDJM5/cTTbfHo
          LLa2gxd7eiGxDt8DkvWjvCxLyeqXsvEYmQjSliiZqCgGsHyvmOMG+X1n0VHvLNrd5PX7
          5Q3Z0j3x7dXDrNfDfrvWjCcyJ/ouRojpc0REpSEs6pvJ31TKX+qgfdjZpY63Fwd95kT3
          z/PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
         h=content-transfer-encoding:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:dkim-signature;
         bh=l3BDFr13lzvW17ABaI0/sIN4i/vOburrsEmcy0l5nOs=;
         fh=BRl0NpvSdgqycc4risaqvJWc8tICMg7n/4JD/pUBwZg=;
         b=BDpdHLIteh20btMaWuGxAa2NTFg40HM02YivSC/6Yk5SW4tSpJ3ugJRglFhGV+Kj4S
          InN6v5AnT1NrfvQHuGAISrwZ+UPkMew1yskgdk37OU9ql7AHyfVqkSk/KlgbpAziTpaZ
          x+eeqULLsipEzFShnbT9H/EfbnQtUgmNVbH3DdWIGIX4KNTHgmov/9Qs/soPaq2DZnoX
          XLizD1aa7vM6eDZLEFO+b56trh7/jjqeiI3aaxULm3fRtvpP8sqjvvoSII2rJTjZmfGU
          Hbjy0jerbpbIkk/YMGPrMTAfQEyQT4ryOtORORmuhJpRlbnesK+JSd0nVkATj+rxLF0M
          rMlA==;
         darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=janestreet.com; s=google; t=1782839971; x=1783444771; darn=kvack.org;
         h=content-transfer-encoding:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:from:to:cc:subject:date
          :message-id:reply-to;
         bh=l3BDFr13lzvW17ABaI0/sIN4i/vOburrsEmcy0l5nOs=;
         b=QcUs3kXpchvhuTb7fFMw5Pm04iLIwMo/x6ngzK9lfi+x9sip7Fel/xK8Zfxzsz/jze
          XM2GRLkc8NxKND8JDTlcM/ae7fH+E349UdkS2nkMlhsRUByGeFexsHL32u+4/bmlg4KQ
          XKcOtn91UvVmRU0gOz9hfVVIIUPadsilVlo1M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=janestreet.com;
  s=waixah; t=1782839972;
  bh=l3BDFr13lzvW17ABaI0/sIN4i/vOburrsEmcy0l5nOs=;
  h=References:In-Reply-To:From:Date:Subject:To;
  b=COtkADUn1zxMonUYM/WWwbl9kMxb+xhWQUXhVEcAegni0oP5oFy5hgiQc31bQXFVi
  L2ovkMoVMBWnvIQVkdc0zNioGNxMbrTaiAQGS64pgi4sKRymsiAw+sXekG9wJhfqg1
  OWQg7qNGCUVP1J/Fqwjq04qUFZDeBQoL3iyS1iAr0yiEZtiakzkntOVpBGuljMifpO
  28QKrTNfvu0icfWTcR2sv2POzRPRr0LMYMX2XMi0uRoPzcZNUF72Vdf/UtiprGXmgX
  hNYWihgoRUketm3rtqNHashDx9VwFjZAQNN4fqqRNhR6S+qUWGp4M4hOVGJjn4LdxV
  5WfrU7JiTLqDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
         d=1e100.net; s=20251104; t=1782839971; x=1783444771;
         h=content-transfer-encoding:to:subject:message-id:date:from
          :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
          :to:cc:subject:date:message-id:reply-to;
         bh=l3BDFr13lzvW17ABaI0/sIN4i/vOburrsEmcy0l5nOs=;
         b=SczCJMg2rYb/pclj9JKFiSeyASUDsAETQ7KPZyY+llOTwBjQw7lhHveDWYwYmv1loR
          4KoqADqLKPmO99zMOEF+wsur0LUc+iJFxZ0QDFdhZpySW1xO664nxRSSc133S8M+9IVq
          472u+elbl+avh1J5HJGkEa2qWNofocwyuKWCDSpWbgRNp5o7HKxSnl/m8O03+6QZvhEr
          16de+kbtO0uniqPj0J+YSnwBq8FtcfJyckHx8KHF7fW7AEf+TpxryndHgC9llnJGInra
          cUIzQAX4/WWE0rv2yykwwlLYU3d1wK/rbHE0hj+vllzedHYln++AoF55Lczmf4AhKqSl
          ZA3A==
X-Forwarded-Encrypted: i=1; AHgh+RpeFbvd+2IOOmyfGQ7+aVEzyNx8eN4TA8I3JFowd7htr67mY29kxydmcc9OFbBdXZHSyHraZhkDqg==@kvack.org
X-Gm-Message-State: AOJu0YxQ8/XnLwla1KMjhAxPwPoMmQc4CbtcJZhmtpIC1zZSQyWBbftf
 	KBowKSv1pa1z+VjmoKZGWALIAi68tC4TtGU+p5jx5CPqGp4M9eU0YaAd7a+CueIqJUwMjkQiPYk
 	YodmxJMD3YF6FxuFt6LfKr3PZyiCUkW7Fuq5Tbml6HHqNK91mRSl0MaXRQUp27I0Z54zd11JEv6
 	XPEdwD/oB1Bldhws4DMaBQZxNYmw==
X-Gm-Gg: AfdE7clYJZ7MnYocsq5fc86ko5eWCQDpALN16I5Rk6+uzUnAM36ZX7l4EcRxFKqlI6z
 	ugxTE8Wtroak/qF3KNb/HJf2Ou03t6CY+tHYimsymENli5sMFb0lBtxbuyK5gQerrib1lsBqAH+
 	Fuq0JpHDCkUtABsIoVzj3DKn3lJqA8hInPudG+QJ+QCNZvJ5ycL6zz50ZXSPPIne0qMQk=
X-Received: by 2002:a05:6512:3f11:b0:5ae:b8c8:f2fa with SMTP id 2adb3069b0e04-5aebdbdef7emr1141212e87.50.1782839970990;
         Tue, 30 Jun 2026 10:19:30 -0700 (PDT)
X-Received: by 2002:a05:6512:3f11:b0:5ae:b8c8:f2fa with SMTP id
  2adb3069b0e04-5aebdbdef7emr1141194e87.50.1782839970509; Tue, 30 Jun 2026
  10:19:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
In-Reply-To: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
From: Gregg Leventhal <gleventhal@janestreet.com>
Date: Tue, 30 Jun 2026 13:18:52 -0400
X-Gm-Features: AVVi8CfkmjNR5nURtk2mdnYIAyOLZkKQSNyy9kqgwVeZ-P7zxW9roFxBxwv7kcc
Message-ID: <CAFN_u7FLMQ1JYCzD8+RDhSH6X4W6yHnp8GcidjEm1rvNMmZK2A@mail.gmail.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
  dirty page cache
To: "To: Alexander Viro" <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
 	"Cc: Jan Kara" <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
 	Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, 
 	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 	linux-kernel@vger.kernel.org, Eric Hagberg <ehagberg@janestreet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 17AE1100016
X-Stat-Signature: echg91mij8tbmyh6oyitpi4q1cpzt3oe
X-HE-Tag: 1782839972-954913
X-HE-Meta: U2FsdGVkX1+T6HMMfSWsZ/ZzpRKWuKciEaV9TyJityKp2+0GALkklWVSn5FrMKrcVNi+/YI9T5QVu4JiLKPdEIXvGkux4xb/OGYDJlLQJo6QLcj2hvlALaU39p35604gXtNHoyZPCih/VIr/AFVG56M3zlkTsd2ERYaPB4eOAKBZ+zPehbB50ePn35zu4pEzVzMNUNWo+S5CUVloNKalIWutRlT0nRDjecS+MpIyvvYW+Lg8mxD+FQTU+vry9ltULIXWvp1HOayxJjjUU9VKJcFvwH9iYtq9H0EwGXPTWMEqdJPpZZxlnNVmLa99ILu9S5Wj6lrMa+gigvPZUx7FV61m23ioPNAwCkKd9rCiOa2EJSItN3hUKvtSZ/MvRjwEEb4hLD+Rz3tKG0z0H/ifF11pTizZmhEy4q3eRnAO4JOCx7FWGliBSIShbxSktq+aXxOcmzunAPR+Ptk8izduL8pEgRMzOAeoEPyWvjrqSQeLE86335lzqDCdqwYivegFcb5UVWYWwYQ96OGpLpI0lmtm7robVyc+ghaU03INjlOSUIqKcTl/HhMoKqGbYo2tT5kEXGg8Jg1JhiolZVzXPTvDTolNm7EZA6yGryM6sbqTaFYZ9YxbIhGWxslI4odRRt3puVU6JRyl35YsBuJ5Bjyzir+paaKLB6Quas1yURJ85cRzmd/0nEWMkW3ATOsd99QKv995hwgkdPjFJ7J3qkjHgGcbcC55LhlguZ1pHZAkaDI6KJvHvQCskdXrN9FznYwV3LSz5WCuJNa02A7A5R+sfQCquyYpD8MoAGpIIf6xKgl2q0tqgVEs3S3qfXM/jG7/r+lNJBIpx3v6TVhlnuspbhRkwI/UnK2okM7Jczm/rgaMMC85HvKsmvO58gBrh8X8wWZMKsXJsGiudS2Zqf1slWWf6L9pX288XlcgONYnxUQNKWUmZUxubdeDeyAOMB0K2iVd4Dl39o2Jvrv
 EKs0xfT4
 tXOfB/vgjyyC9FWOTNduNmJyg7xgmeqNCaoPuYx5TI25eIayGBOO5qT6kHu8e7sSm6fjQFt3CPYTkdElHS2rfupzB/0YK88D70V2dIWOkCPgpEihKcf58xtEaFaheD/vYbupp44jzKlFIM1p9iNAZorGWxkhSkC2oWAfKR7X/dh0YsJSLe1ARZXBUohhBMROeAZB4aGnxlT6hH+vxfm7ev925nhl/x7i6v/FO3ZUTAI9Nm7R7zrYPELdghWLCM2uyHRaAyKQ1v5ZCoGgT4RPyjPXIHPE+gKPwLQVj1zWOGS7VTgUtDmCG5/Xe+MvojjebLPzG6claQ61EYYXuXaXX4AhMtaYmwTBBM2+UcmrxsMvOOKpVAhuPNDjkCLDTED/rEo7W+hXxEawSgsVgSkoovoazAw9rfzvBAHnNXwuLiL+By1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Also, just to be explicit and prevent some potentially-wasted time:
This does not repro on XFS!   You need to point the reproducer at
Btrfs or Ext4 (or some other susceptible file system, but those are
the only ones Eric and I have confirmed, personally).


On Tue, Jun 30, 2026 at 1:01=E2=80=AFPM Gregg Leventhal
<gleventhal@janestreet.com> wrote:
>
> Hello,
>
> We (Gregg Leventhal <gleventhal@janestreet.com> and Eric Hagberg
>
> <ehagberg@janestreet.com>) have a reproducible data-loss issue involving =
file
>
> THPs and write-open, impacting filesystems that do not support
> writable large folios.
>
>
> Attached are:
>
>
>   - thp_write_open_cancel_dirty_repro.c
>
>   - thp-open-writeback-before-purge.patch
>
>
>
> Summary
>
> =3D=3D=3D=3D=3D=3D=3D
>
>
> On an affected 6.12 kernel with CONFIG_READ_ONLY_THP_FOR_FS=3Dy, a file c=
an
>
> contain read-only file THPs installed by khugepaged / MADV_COLLAPSE. When=
 that
>
> same file is later opened for write, do_dentry_open() notices
>
> filemap_nr_thps() and drops the page cache:
>
>
>         /*
>
>          * XXX: Huge page cache doesn't support writing yet. Drop all pag=
e
>
>          * cache for this file before processing writes.
>
>          */
>
>         if (f->f_mode & FMODE_WRITE) {
>
>                 if (filemap_nr_thps(inode->i_mapping)) {
>
>                         struct address_space *mapping =3D inode->i_mappin=
g;
>
>
>                         filemap_invalidate_lock(inode->i_mapping);
>
>                         unmap_mapping_range(mapping, 0, 0, 0);
>
>                         truncate_inode_pages(mapping, 0);
>
>                         filemap_invalidate_unlock(inode->i_mapping);
>
>                 }
>
>         }
>
>
> This is unsafe if the mapping also contains dirty folios.
>
> truncate_inode_pages() is not just a clean cache-dropping primitive. It c=
an
>
> call truncate_cleanup_folio(), which calls folio_cancel_dirty().
>
>
> In the attached reproducer, dirty appended data is discarded and later re=
ad(2)s
>
> return zeros.
>
>
> We observed this on btrfs and ext4, though most of the testing involved b=
trfs.
>
>
> The same issue should apply to any filesystem where file THPs can be crea=
ted
>
> by READ_ONLY_THP_FOR_FS but writable large folios are not supported. The
>
> do_dentry_open() block above is also unchanged in current mainline, so th=
is
>
> does not appear to be strictly 6.12-specific.
>
>
>
> Instrumentation
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> Tracing the failure shows the dirty folios being invalidated from the
>
> write-open path. INVALIDATE_DIRTY and CANCEL_DIRTY below are labels from =
our
>
> own probes:
>
>
>         do_dentry_open / vfs_open
>
>           truncate_inode_pages_range
>
>             truncate_cleanup_folio
>
>               btrfs_invalidate_folio
>
>               folio_cancel_dirty
>
>
> A representative stack from the failing path:
>
>
>         INVALIDATE_DIRTY ...
>
>           btrfs_invalidate_folio
>
>           truncate_cleanup_folio
>
>           truncate_inode_pages_range
>
>           vfs_open
>
>
>         CANCEL_DIRTY ...
>
>           truncate_cleanup_folio
>
>           truncate_inode_pages_range
>
>           vfs_open
>
>
> This confirms that the appended dirty page-cache contents are being disca=
rded
>
> by the open-time THP cache purge rather than written back.
>
>
>
> Why this happens
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> The do_dentry_open() code is trying to handle the fact that some filesyst=
ems
>
> do not support writing to file THPs. The problematic assumption is that
>
> dropping the page cache is a safe cache-management operation.
>
>
> It is not safe when dirty folios are present, because truncate_inode_page=
s()
>
> cancels their dirty state without writeback.
>
>
> Note that the read-only file THPs themselves are clean. The data that is =
lost
>
> is unrelated dirty folios elsewhere in the same mapping, here the appende=
d
>
> tail, which get caught in the blanket truncate_inode_pages(mapping, 0) of=
 the
>
> entire mapping.
>
>
>
> Suggested fix direction
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> Before dropping THP-bearing page cache on write-open, write back and wait=
 for
>
> any dirty folios. After writeback completes, the folios are clean, so the
>
> subsequent truncate_inode_pages() has no dirty state to cancel and the da=
ta is
>
> safe on disk. A later read() simply repopulates the cache from disk. If
>
> writeback fails, fail the open rather than silently discarding the data.
>
>
> The attached patch does this by adding filemap_write_and_wait(mapping) be=
fore
>
> the unmap_mapping_range() / truncate_inode_pages() sequence.
>
>
> Two caveats we are aware of with this approach:
>
>
>   - filemap_write_and_wait() flushes the entire mapping, so any write-ope=
n of
>
>     a file with filemap_nr_thps() > 0 now forces synchronous writeback. T=
his
>
>     path already did a full unmap + truncate, so the extra cost is probab=
ly
>
>     acceptable, but it is a behavior change.
>
>
>   - The writeback happens before unmap_mapping_range(). That is sufficien=
t for
>
>     the reproducer, where the dirty data comes from buffered write(2), so=
 the
>
>     folios are already marked dirty. We would appreciate guidance on whet=
her
>
>     unmap should precede the writeback in order to also cover data dirtie=
d
>
>     only via a writable shared mapping.
>
>
> An alternative would be to replace truncate_inode_pages() with a
>
> clean-page-only invalidation primitive, but then dirty file THPs / dirty =
pages
>
> may remain in the mapping and need careful handling.
>
>
>
> Mitigation
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> As a temporary mitigation, setting khugepaged's scan interval very high
>
> appears to prevent the issue by effectively stopping background file THP
>
> collapse:
>
>
>         echo 4294967295 >
> /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs
>
>
> This is not a complete fix. It reduces or disables khugepaged background
>
> collapse, including file THP collapse, and may reduce THP-related perform=
ance
>
> benefits for workloads that rely on khugepaged promotion. Fault-time anon=
ymous
>
> THP allocation is not disabled by this knob.
>
>
> Disabling CONFIG_READ_ONLY_THP_FOR_FS also seems to mitigate, but both ar=
e
>
> suboptimal, performance-impacting trade-offs.
>
>
>
> Reproducer
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> The attached reproducer does the following:
>
>
>   1. Creates a regular file with non-zero data.
>
>   2. Maps part of the file read-only and uses MADV_COLLAPSE to force a fi=
le
>
>      THP.
>
>   3. Opens the file for writing and appends non-zero data, leaving it dir=
ty in
>
>      page cache.
>
>   4. Closes the write fd.
>
>   5. Re-collapses a read-only file range so filemap_nr_thps(mapping) is
>
>      non-zero.
>
>   6. Opens the file for write again, triggering the do_dentry_open() THP =
purge.
>
>   7. Reads back the appended data.
>
>
> Whether any single iteration reproduces is a race against background
>
> writeback, so let the full iteration count run. A single clean pass does =
not
>
> by itself prove the kernel is unaffected.
>
>
> On an affected 6.12 host:
>
>
>         # ./thp_write_open_cancel_dirty_repro Maybe_corrupted_file
>
>         path=3DMaybe_corrupted_file base_size=3D67108864 append_size=3D16=
384 iters=3D200
>
>         REPRODUCED iter=3D0 bad_bytes=3D16384 first_bad=3D0 zero_count=3D=
16384
> append_off=3D67108864
>
>         first 64 got:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ..=
.
>
>         first 64 want: 5c df 63 e6 6a ed 71 f4 78 fb 7f 03 86 0a 8d 11 ..=
.
>
>
> The corrupted range is visible as a run of null bytes at the append offse=
t:
>
>
>         # rg --text '\x00{64}\x00*' $PWD --only-matching \
>
>               --byte-offset --no-line-number \
>
>             | awk -F: '{print $1, $2, length($3)}' | head -n1
>
>         /root/Maybe_corrupted_file 67108864 16384
>
>
>
> We are happy to test any preferred fix direction and can provide
> additional traces, as-needed.
>
>
> Thanks,
>
> Gregg Leventhal
>
> Eric Hagberg

