Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73CCC105F7A4
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 12:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08C36B0005; Fri, 13 Mar 2026 08:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD05F6B0088; Fri, 13 Mar 2026 08:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DBF86B0089; Fri, 13 Mar 2026 08:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C71E6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:13:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C90FB5CA2
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:13:56 +0000 (UTC)
X-FDA: 84540931272.21.CD0C842
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9BF9240016
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:13:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DB6dRsTQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773404034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91RpXhmhG1y7Y3R2yiY+A7xQRPuRiR0gbkywSMYhLXI=;
	b=bXqL+Hq3rEaabtkcmCzbANmsy0exs7Kq3nvOZ8SpV3DSY7kAld4Ap0u9VcUQkcQM2dTtS9
	xYOqRFJkNeJwsPSP1WYyP5JYqOZ5D7+dxzji+/8BX6ZH6HJcxMrRi8TZffz1quoSU45I5m
	l4/i7Z2B1AjBzjyJOlWWkMouG7SkEwY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DB6dRsTQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773404034; a=rsa-sha256;
	cv=none;
	b=0fQyFiTIDfWFWRoZWy56FuVF5Yy/GlChH1RaF87SOGBzfWg6ARy46qQJyLSkXU5F+HL5uV
	Tzp1hZC1RBsreA6oD7ZEgCnfPvWvu+hfS2p9f3j6vUR9c7G8BKzGMqM4MYE0UuqQUBLSMu
	fJ3ZHJq+aEg30CWCT1ZFVTz1USZF/HM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F053660142;
	Fri, 13 Mar 2026 12:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E0DC19421;
	Fri, 13 Mar 2026 12:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773404033;
	bh=YTSstfxoFHiBrx/2m0P/t3MkgTKyeJ4OyC8gGdFgfg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DB6dRsTQ08n3qOo3LbHGR1u+n0kWeOhSwb+ENV+XLmec/F+YIQ0TbkSpcxXc4SxOp
	 vHeCf5xRAJLRPuA8hMqRPDPvUtF/PM2u9MLhTGgfq0Ae11MF9gBBhHXccmzR/v45mn
	 xB0zSI5yzSzGTansN0d4x/wNLnx0ndS+Dl4B+JhsaH2l6nIzblj937L039TmtA4rml
	 Dr6J3+ATKRtvGj3D+6JSEUu1hbMWQTHb7OHl+ygHlVZiX0nXmiZRiVxI/hdDdKQZaN
	 hT2R8s+ucuXlNHEKl1rR953D/AJ1NweqQI8U1F2poQTAT5Z/pBYTS88vUfrR7KVI0X
	 7ogwZcTeTjd3A==
Date: Fri, 13 Mar 2026 12:13:42 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH 01/15] mm: various small mmap_prepare cleanups
Message-ID: <fa6bf4b1-b4da-4679-bd4d-7a0884b45fbb@lucifer.local>
References: <cover.1773346620.git.ljs@kernel.org>
 <56372fe273f775b26675a04652c1229e14680741.1773346620.git.ljs@kernel.org>
 <20260312141425.1837736829210f2d0b00cac6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260312141425.1837736829210f2d0b00cac6@linux-foundation.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9BF9240016
X-Stat-Signature: kguqk58yiwgg41strynbts7ou3ujcpec
X-Rspam-User: 
X-HE-Tag: 1773404034-557993
X-HE-Meta: U2FsdGVkX1/EeuQbZobpynFfEmRtkxvzJMyQixd6VHqkMzyf+Uu9780TyYCRqN2cnOiqn1cgtdE/IDuN0MD1wCKTxl/IXGRWwS8GOy4pxBLV1FD2y4YO6sTfWbKe2slwPEdct3+CB4V6pJRH5ESRUzCfTMW8C6Q5TnF8Y+WIHFkH+z/TGjXUCfdWQ0rUrLBRxq66IVMi3ogT62+7OTtJadYs/Fy7eep4GTO6v0fG2I0NX1j4ns9huDV6fm7jFlitxh+BsGUxHiNtzYqVAu9OJQLA+U8vwXW/Zpr9L8had0MPIOh4pRAMkOupdy+GEWlmIUqkje69FvrRF34021WODLpa0FsDCiLacksxbxJCVa0SIuoFJaNW8d6rL6+OE8gOBp4IHTfBxm9JjLVLYFPq4laHqvtWabiwb2es1MnL4DeZ16S0r8/T4VPLdimER7+Di68h2QBT50kWDTinXjl1lpa5+XQuYe3228+utuTaADQrRS4kbmqM8hkN6yB61lPuL+GRMm9gN4Xk+PBhZQm822ktgFqm0oCrRtLFWuDayTR/smyeOT21e0decSMTTo75cPyR0qLzS1vsQYKRRUOCPNxK5rS8hgg0vJ+rtJgP0KcMGszUct8Ubw2cCIKh7TFe+/vY1lAAaYijFJ8ZQJPrCIJJN2ujcQ0icakOsO5PjvgxB2x46mhoQzgIuxS0G5o4RjylNnc5xF85DXT8qSe9dx8/HTwqUsoMLFpcnKu4B4edWpdAOub8+pJE/Ho75pqRGhjc4JXknxnFYoWcoqnwVrpEvCTr2E7ylkb//X9vCL1wZ/lVpa3nUt20ASGxdaqSBlTOL/JhcuVjw99C9eq5TOQ07r8ku+zDqMiTxkxPjpGHdA3pzPhxVmL/7uK99O/KlKaPbBxgKYVWlqDX6D8JpXah3rtzlRIcnTp31jl5YxMebADEfqG57+zkJ0KWTEOhUxpWsT6VaxxJNgsMNil
 Bw4S7Q/Z
 EKow6Z8W+vRFctiNNLd7ZDw5gm0V4Tk6gA52c2CPKNvoUaJYUhkLnN6l4tah3ZNPX5tV/ajU/9kheUdEa7qNV66El8iWrNOjdtMBOD61l470tqN+Q56Gx1WfQX+XPqYqX2Pt0mFzrdWZr1Wu8bMe43siRn+KlVM4hT9iBnx6MoMoCzd+MoFjmiWYGY6F7CVk1EIQoOa2/sgYvdro843FugXn96u46YUKSVERZWr6BB4n7w97npRPpUqrl1ABFgCDIktCqN/vvcW35nB8FXjtx6WJScumKzzFRUlF7bg9jzZ+H6gG5Uq3WcvTNpiRPDpRxcHdCWXIlHVImfxnJqHiuAYP/E1VZgRQkh0bX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 12, 2026 at 02:14:25PM -0700, Andrew Morton wrote:
> On Thu, 12 Mar 2026 20:27:16 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > +int mmap_action_prepare(struct vm_area_desc *desc,
> > +			struct mmap_action *action)
> > +
> >  {
> >  	switch (action->type) {
> >  	case MMAP_NOTHING:
> > -		break;
> > +		return 0;
> >  	case MMAP_REMAP_PFN:
> > -		remap_pfn_range_prepare(desc, action->remap.start_pfn);
> > -		break;
> > +		return remap_pfn_range_prepare(desc, action);
> >  	case MMAP_IO_REMAP_PFN:
> > -		io_remap_pfn_range_prepare(desc, action->remap.start_pfn,
> > -					   action->remap.size);
> > -		break;
> > +		return io_remap_pfn_range_prepare(desc, action);
> >  	}
> >  }
> >  EXPORT_SYMBOL(mmap_action_prepare);
>
> hm, was this the correct version?
>
> mm/util.c: In function 'mmap_action_prepare':
> mm/util.c:1451:1: error: control reaches end of non-void function [-Werror=return-type]
>  1451 | }

Seems different compiler versions do different things :)

In theory we should never hit that but memory corruption and err... rogue
drivers? could cause it ofc :)

Will fix on respin.

>
> --- a/mm/util.c~mm-various-small-mmap_prepare-cleanups-fix
> +++ a/mm/util.c
> @@ -1356,6 +1356,8 @@ int mmap_action_prepare(struct vm_area_d
>  		return remap_pfn_range_prepare(desc, action);
>  	case MMAP_IO_REMAP_PFN:
>  		return io_remap_pfn_range_prepare(desc, action);
> +	default:
> +		BUG();

I'd probably prefer a WARN_ON_ONCE(1) return -EBLAH; will think about it on
respin.

>  	}
>  }
>  EXPORT_SYMBOL(mmap_action_prepare);
> _
>

Cheers, Lorenzo

