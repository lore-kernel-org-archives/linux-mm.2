Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84BB9C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:14:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979A26B00A1; Thu, 30 Jul 2026 10:14:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92A7E6B00B1; Thu, 30 Jul 2026 10:14:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840D66B00B2; Thu, 30 Jul 2026 10:14:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1496B00A1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:14:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB25A120183
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:14:41 +0000 (UTC)
X-FDA: 85045638762.11.B3D5F76
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id ED68BC0007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:14:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FRKifv90;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ak6SYqcwxupBqQSY0jHSI19b9OizZFsFl8QcJo9jk7w=;
	b=VFidIhKID+TtaJFDcGNQaoTEkiVU+4fUo+4NpeoDNqmIGgkllj9aF4GZuXnLq6CeV66kok
	b9zykMC2izvdWcPXLv6qLPDfVdarGHaiKGzJpWIRteGBJmWjfNbYAPKuqA3iaVsj7NKG6d
	iK3tyFvZTn+m3qQnWHtl+6lU4HDOJoE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420879;
	b=WZPMjNnzlOelQ6eKrm/6RKDD3nCBSiVLaMAsaKv05lkcCdWe2Jmhi3Ecm4iodKXmk5bNN6
	8/yRmxLp1TAO836+DcWiWKZ6vqICKkxKy2yHm68c2dNMkb47UW+WuxwcfXUOf3SO4z4188
	xCVi+4C8Ox/hXLBBlaROO/KhgX79tH0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FRKifv90;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-69fc6a09b5aso3636319a12.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785420878; x=1786025678; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ak6SYqcwxupBqQSY0jHSI19b9OizZFsFl8QcJo9jk7w=;
        b=FRKifv90J/b5SYiU+x4mZmCtaHF/YmAo/DXsHEKYNnUWGzrN8VcUKPMr6VZmW3yInq
         VkVEl5mRbWfZo8UpOckt+Tye4pKOvEr3bwteZoiwc84tQfSBhBu8euxNE9ipX2u9eoIC
         lEKYLhdQEqZ9ANMqF7PvXJQZGdiaW+uC9SP34KLs6c86xYZB5WX8xiiabux0h+IXGiCg
         HhrPB88oQQCzDa4fb9P9OXLtO1D7+6lr0XVqHikdShqzrfo13Z9Oi8LvOe/6oS6FOwBj
         tv0al/CXP9Axs2rGd23xuKm88ROvuhpPNO00eBlpkwzb9/yI6F8gIldkQRY6W7dGprOO
         +MMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785420878; x=1786025678;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ak6SYqcwxupBqQSY0jHSI19b9OizZFsFl8QcJo9jk7w=;
        b=iyyjwvAEUxLe3FCUWmbAq7piEHX/i5s1ZdCDYlAWCX+40bZMQ+VCyoQwpQcrH0mbbE
         2RsfXvnQ3GFqbbpbRUSPVr/9mXxAs7kGF8ftGyJlPIrIYcp+qItC1P8Ua3oBIYlvz8UJ
         jqUpMnluBBWmAdlDaUSQHeS7ykiF9+vHWDIt7+uyJ8lMK//3cSjp3kehezGUOSXVxrkM
         hR/QyBfgqBrjICJg/5st6v9+w4l2dgStOxJ+3Wj1yCLTkK3Nqb5tBlK5+RKtV9OlivHM
         QR2nZvxQLlhM9D+GWUs8BQ5heagmoQEKhwjXeestjtN/PSXdfrAV/pvvPwka1s7HED0v
         Pv4w==
X-Forwarded-Encrypted: i=1; AHgh+RoVfcO1Wy7UkuFpYhCHL+UUnstnXX0Z5D9TAAPkkNlwEkP1pPrgkFeyU6yfznLPu19x4/eFeMuD8A==@kvack.org
X-Gm-Message-State: AOJu0Yw9D3n9GM1ohB5tEHyhOTkBZWMEFr4d2gOW1Pfglo+Gplr4GIgQ
	uEcQ/LIsktTEJZ/T2x3h+d/1L7CJRiqRoR1BZCcrZjOacsGSrrDTOY7R
X-Gm-Gg: AR+sD12Y+3lZD965xS8PjRJFqF/yEsvi4iCGW+pB5VfTxPq5irGfD0M3PVhAtJ3Q/RX
	vwc9TZNXEdqe++ajE7lkNJedwZ39+ObMlXpqdGLU/CVYFga8EnTT/w2QqjubjpLKz4EyEBbb+2/
	jFeRc4xGJ1pL9QPYmw7Ok8+yRqBxOYsHkmUNYapTHRzmjKs5B1sF13kBCyIqYdxPx74ckRZgc3l
	ix9aX4crg32q6l9LeQKkKe64CWXYGo22kEaU5YGJli8+2BeCOZNnANyVAJMKCrQQLILv6cK1riT
	Xn/IK7QOKQAIHmDY5hKoeMIk4/Bx8EQAgsrX4LdLsz2YT2APjB1wnUTvqyG1GRxdDS17iiCQq7c
	3JapE8H0DjemLyyyJsQHkk6Loy654cquLfbr6PpWLcFeIRD0ChEOXESepLtJsfLbPeGeH51Jjik
	6BFLxQvgkymW/sC1N1g22RCXz1Rw==
X-Received: by 2002:a17:907:9729:b0:c16:8799:fcb4 with SMTP id a640c23a62f3a-c1fbca57f27mr39736666b.19.1785420878014;
        Thu, 30 Jul 2026 07:14:38 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa857800asm74494366b.16.2026.07.30.07.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 07:14:37 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 30 Jul 2026 16:14:35 +0200
To: Barry Song <21cnbao@gmail.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Matthew Wilcox <willy@infradead.org>, kees@kernel.org,
	akpm@linux-foundation.org, gustavoars@kernel.org,
	linux-hardening@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com, david@kernel.org
Subject: Re: [PATCH] mm/usercopy: harden bounds checking for vmalloc
 allocations
Message-ID: <amtcS9NiXJj_eIl5@milan>
References: <20260722142936.3287702-1-dev.jain@arm.com>
 <f3db438e-6cf7-4ccf-bd4f-379c549d1e9d@arm.com>
 <amXldUo3LfIGs-zs@casper.infradead.org>
 <0a312983-3d63-4d60-8ff4-d53dcfff7819@arm.com>
 <amckUdXO-7TtzhNg@milan>
 <CAGsJ_4wGGSf2mhwykH137aA5enhgLGj=-asKe0B09tAOVP8qvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4wGGSf2mhwykH137aA5enhgLGj=-asKe0B09tAOVP8qvg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ED68BC0007
X-Stat-Signature: bgmif5fuszfabn43gec8mt3tcgg1ztop
X-HE-Tag: 1785420879-494795
X-HE-Meta: U2FsdGVkX1+c0w/7bFkNGFxTXyMWUVAXTg9jBPDALWMJMbLTndFfJIgDR2Dc8ZId9viH+7iKIhdfEeul6hEM/VemKp2ti9lIPBzguJ7/oudB9i2IyLiqfrGKXeY31hoi99a9vpJwv5z19cxjGCUHQ6/9lyTBcFALhdzDkdO5zMtZX2IhdqlJyuszeJhzetSPcE2DSXW/1K3FAVUzBwOVlkFC7QxuaiPNb11YG49Un6SSuvAMZSefouZ4c/AYLom2qfJmuS9fnLew5Qjd6WJLGLVC8LA8OLwnMWKVKjM5w6LgjjfQEWkDBwbE9TTOaGTu8fvh3PVsbadXw4kRFd6WMcOwRizENK8PUlZUmkPUjnufly5gP2X0CEOf5pS84JJIMd24tvmAeIxlbANigzYzD2/WziDXgOcmoMi8JI+hX/mBBhFygyL9PF2ylamGajvKEeMzGglYWBPXrTmVgcVO06aNBXMkrPF6agNl6dSUNwOs8THiOHPIvxkcrSRj67fGGISJpa/6a1vpBCbCmv60sywj64XAlFbqgj+ck4yAJFnShqFIipR+lGzTnEWfQZcGMvwBczc5/8Seu8wWuMFH4aAlzYwihZQv1Tz7xsUAemMYKezSQPz+FpbahkNe06VDJMP3jXa89U/ZbZCRPwQ58oTilLDijiZ/nRMmzAt+Itp3ssOoztriFUm4rPlMUuSi9frkIsLWKgsmkKKoqmPHO734g7kU0IUBIh+aWClsuBtlhsKAvR6iSoRyYAexcHTTVliq1AHE6dFYPHkNg8bs98epQTLq/KFkYRjakonzy7gY1xNmx/iwFJ2VjXr43DvdstYJflQzOkuvolaYiXeNjnlgpIw1Nxoyd0aql1u0OVw6OFGlWfUgDQTQe30KyL9nqNdCvyzHZHx5H/4ZJiYx15CrZErvL22ATuf5EWT75dT4vD9XJbHzDxy9iOv8gSJar5OrT2dOM0U5EK+Darx
 a0zAQX2D
 jTeLyiIr5k8aXn3g0uADrTJZ2GYUiGytwP6uQ0upIKRQfxEffCiacdvD3D+GRp1ESFjn6Ymw6Se8QFJIhOJsgpRky1HSb4WSNCcUu/U6x+Z8M05UI49A2ksNxSYwdajbnoq1eMaT9tWg8no34/n0kF7daxw+xNiRygTJ7doe5y4GnhngU5E4t3lHFFMrHGvVPj9tvRUQQJDU82fP10c/Iagz4GsMT/kxothl3dX4EhQDE2dvU51uv4NmuGeq8haizU9SusNidagiHBxKGjTYRWWeQun0pQfJnvDoE+P/9MU8pQrfwEGYcaavHYg7bAvDqwgf2ppnQM8RX6C5PWBL6QDVGL8aq1yS3ZfFkiWibUjxGgRam/cApgwZKX7rsFhITVHgI38Hqddwm/BZ05iP6kRk55m909hYIW142OrML+zYeE7Oxfzn7jz8fEnl7GVz+SACi7khpvRGP95LBZzCylkCDVMws4jo8hKyVgM7haXd2umAl8UesuvMVGLk0vgkhA5xW43kk6n3T0DmqnXUghalNE2xPPW1mZ8PmjtqhlFwt/pM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 06:22:57AM +0800, Barry Song wrote:
> On Mon, Jul 27, 2026 at 5:32 PM Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > On Mon, Jul 27, 2026 at 12:33:49PM +0530, Dev Jain wrote:
> > >
> > >
> > > On 26/07/26 4:16 pm, Matthew Wilcox wrote:
> > > > On Sun, Jul 26, 2026 at 02:23:20PM +0530, Dev Jain wrote:
> > > >> On 22/07/26 7:59 pm, Dev Jain wrote:
> > > >>> The vmalloc allocator stores the actual allocation size inside the
> > > >>> vm_struct structure. We can use this bound in usercopy instead of the
> > > >>> page-aligned va_end to catch usercopy beyond the actual allocation size.
> > > >>>
> > > >>> For vmap, the requested_size field is always page-aligned since it maps a
> > > >>> certain number of pages. Same for vm_map_ram (alongwith, not even having
> > > >>> a vm_struct). So the check is only relevant for vmalloc mappings.
> > > >>>
> > > >>> Because there are early vm areas registered even before vmalloc_init,
> > > >>> requested_size may be zero. So also check whether the requested_size
> > > >>> is set.
> > > >>>
> > > >>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> > > >>> ---
> > > >>
> > > >> Sashiko:
> > > >>
> > > >> 1. "Does this locklessly access area->vm after find_vmap_area() has dropped
> > > >> the busy tree lock?
> > > >>
> > > >> If an out-of-bounds pointer falls into an adjacent vmap_area, and that
> > > >> adjacent area is concurrently freed by another thread, its vm_struct
> > > >> is freed. Additionally, when the vmap_area is moved to the free tree,
> > > >> area->vm (which shares a union with subtree_max_size) is overwritten
> > > >> with an integer size.
> > > >>
> > > >> Would dereferencing vm->flags later in this function cause a use-after-free
> > > >> or a wild pointer dereference?"
> > > >>
> > > >>
> > > >> I don't get it. So usercopy is checking OOB for an object but shouldn't
> > > >> assume the existence of that object while using it?
> > > >>
> > > >> It is a bug in the caller if someone does vfree() while usercopy is operating
> > > >> on the vmalloc object. I don't think usercopy should handle it. For example
> > > >> we don't handle it for slabs currently.
> > > >
> > > > I think the question Sashiko is getting to is how we handle:
> > > >
> > > >     char *p = vmalloc();
> > > >     copy_to_user(p - 4);
> > >
> > > Thanks Willy, I completely misread Sashiko's point.
> > >
> > > I think this is an existing problem? We are using area->va_end currently,
> > > so we can access freed memory.
> > >
> > It is a bit mess here since now we need also take into account a
> > requested_size due to vrealloc. We have requested_size, nr_pages
> > and size in the vm_struct.
> 
> 
> I see that vrealloc() always updates vm->requested_size to the new size.
> So we could always use requested_size? no?
> 
Probably :) But i am not sure what the patch fixes. There is a race anyway?

You check VA on CPU_1 successfully, after that CPU_2 unmaps the pages by
calling vrealloc() and CPU_1 is about to read unmapped pages.

--
Uladzislau Rezki

