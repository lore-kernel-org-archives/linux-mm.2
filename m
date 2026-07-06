Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA42C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F256B00BB; Mon,  6 Jul 2026 09:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0596B00BC; Mon,  6 Jul 2026 09:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBEF76B00BD; Mon,  6 Jul 2026 09:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A22A16B00BB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:16:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D8871A03EB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:16:06 +0000 (UTC)
X-FDA: 84958399932.25.3E85FFF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8AAB2140007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:16:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BR3jgFgY;
	spf=pass (imf09.hostedemail.com: domain of agruenba@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783343763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AxMOA32PrhBgJC1rEErLDcIUQtikuP/rNGrPj73qrKE=;
	b=HaVty0egLav/R0v3soUSWmUS32awFHUXWhw7qhR3nxjkSYt4/XrP4/LzUFCEH3uBetdTFN
	sNna2vg/XsKmzbEE+cjQgwx3zl41o9Lks9LuGD71cgw8zghseWtQdI3XSaVs4xu5beuZy8
	D4vg+Vak6QRJduQI3LEpepkyzR9APdE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BR3jgFgY;
	spf=pass (imf09.hostedemail.com: domain of agruenba@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=agruenba@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783343763;
	b=P5x6+HQZU9u3eEad32f6nTvw3IXmFY46i6ey8htJs3iDgi5KMbHWe47HJ55uuYG1C03E+m
	vkzyCfUqj2jfjuYfaaAYXNbUHMZe16Okvgf9HHe+G/ixCBo/vVuBWmqGm/dwTMH3dkyIXK
	cY8txdlnQqdEFv80vUHiIBrOcWDATl4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783343762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AxMOA32PrhBgJC1rEErLDcIUQtikuP/rNGrPj73qrKE=;
	b=BR3jgFgY/l6L5HuyPWMXrVbBdcrqblKug/KEL+B0zIh1Mt/sucQl5+5l/LA/7Ccxz9JZgC
	GgGS8bPfnEMiANI825taH6bA94WXM7D9bLmMHjM/fyoPSuJSJG74Er2zjVE8FloIJd3CtO
	QCbqmozYmK0CyYdKrXst0NivdoEouMo=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-bJoQr4VTMS2VDbZnmv_low-1; Mon, 06 Jul 2026 09:16:01 -0400
X-MC-Unique: bJoQr4VTMS2VDbZnmv_low-1
X-Mimecast-MFC-AGG-ID: bJoQr4VTMS2VDbZnmv_low_1783343761
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-6652046121eso6063837d50.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 06:16:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783343761; x=1783948561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AxMOA32PrhBgJC1rEErLDcIUQtikuP/rNGrPj73qrKE=;
        b=l9OWx48H2BuPEoAppk6q5yPnvsHA9GQ24tLZGym2hxcQSHdqGIiejEhOGw/wkLsTJr
         HN1dSH/TajD2N0SIqXNQQG7sv6UyDkCWwZA8DnSHWz3f1g66JkWmqO464crc8S8Zm6Ge
         8XmsrhbWDWMM/4P1kgOvIJf0cSY0SGPGmilYnP7M6otiTI27nQDCM2HaJyfipnQTTek9
         P1+IT0y/uVaaVg+1dXZo/+3gri0CuSN8JLJNhcNUP45g7AxueMWvRy2p+fk9f4dY8tZ6
         fSFcfnZ7jPcuyK/vedj8NYdKKVtmLKGaUWdUOT9hH+nprlk3dlRngnVUfDiZHG6xEN6o
         mpqw==
X-Forwarded-Encrypted: i=1; AHgh+RrSxugfZ1TxL/5dQo9OdmwSRws0jrLBrMmepcvtnSqbEgOqnuzRQ98PmbwwF4wsxIA8DEDstTdf/w==@kvack.org
X-Gm-Message-State: AOJu0YyAYAss17fonXnXF1rDCMNsfZIbZduJKbI++0tSUVCGPJUFJPD7
	8Oo7xpkssTISTPW49vTYglzkC4yRnWQtp955p7g5oHALkLdd8Ql0CxHHuO0Bw1dCQ2+jxuVfrD/
	alacY+9Z6w37tTQZs5fQArpfs1qSw+t2Z8qPIz4Sm9ZCvUR68daDfjCjVqJ9LV52g1Vu3s7S2Xc
	A5K1XvQ7vj6ngUVhLi2MkJFa9T4MQ=
X-Gm-Gg: AfdE7cnqGRzqkdlsFUnEOOvBxDL2yx8AN0uPQdYUQ13i+zjGnLdP5QMAegLey2N9Rqo
	aFL8Pa3GPHjZiOmf9DaucXWJtH6Tn7DkjmvBUtepOZIPoCurypnNZvwrVF2OwHIhWc7R3rh5lGr
	Ks8OpsiTrUkED2BTaenX2MIFtBR3ZYJAPMfD8VQc2v7ePt1BAJa/b1oyvCatM9tGWhxze+uKDgZ
	4EH1YCCavfypBJiokhVbAVLMINVrv7BxEFb85iUW/VEaNXt4W6s2fA=
X-Received: by 2002:a05:690e:2027:b0:666:53bb:bc1f with SMTP id 956f58d0204a3-6677fa5a3efmr346422d50.1.1783343761037;
        Mon, 06 Jul 2026 06:16:01 -0700 (PDT)
X-Received: by 2002:a05:690e:2027:b0:666:53bb:bc1f with SMTP id
 956f58d0204a3-6677fa5a3efmr346388d50.1.1783343760532; Mon, 06 Jul 2026
 06:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAHc6FU4tz8-HmEf2_XKT0NT8N=rv5OMcY79PxTACkXAVLOAUpg@mail.gmail.com>
 <akZEjH2Hf8-RR8yQ@infradead.org> <akhaWrUHXcubQQab@casper.infradead.org>
In-Reply-To: <akhaWrUHXcubQQab@casper.infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 6 Jul 2026 15:15:49 +0200
X-Gm-Features: AVVi8CeZ90TZOgMX_QaiF2EyLUwZK6uqeXE5eQFowT0YnNBZfC21D0pOzkVqfoY
Message-ID: <CAHc6FU4-GsE1jtw8kXe0h_-T6VK2bB5QuVm2w16Ek6FiUV77tg@mail.gmail.com>
Subject: Re: iomap_writepages WARN_ON_ONCE(PF_MEMALLOC)
To: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, gfs2 <gfs2@lists.linux.dev>, linux-xfs@vger.kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E7IxKyQyt0404RW7vHG8Deq_A4ptvfx2zzcVEJHFOO0_1783343761
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8AAB2140007
X-Stat-Signature: x48p7ix8dhin4kjyqtxr1w1e1z8dwz9j
X-HE-Tag: 1783343763-785663
X-HE-Meta: U2FsdGVkX18yc1ZreuBPhqkumNxku03pYl91JzyuUJFxdnjaL0dRXRgGXgM/3FGgORMZxIBK4jd2n7GK6/JdU7Fb/GN0mlpgt9zrELlThTnP9zq8NAYgxOsbIqTUhH+OTxBV2HYhZOwgKghoR+PM3fqOFiKs/JWAxE8mXa+HlvnCBKv7i/9rxqtXf+NibPKICCaZ2pHigVHe3b3hE7lA10ux+imZHb38m9bs+ZsqFbr79ruv3CK5pkMEgdqMPRI6vfVkHovR2rcPl+qaZkoS/yyw56HATo+cyMXE3rsjLVwzyIevg6uo9h/sf1CSH4wjsCbks2TGAOCauzlDTr7d/j/WJqCYs9EEWO+JpEPpqt9mA+af6T4jZ9UF9A2po0UKZK6K0hK48v21RFPC+Wrg82Ypv6byka1UbvZoJhxwYEcqeTgEh+3+VGZ4obkYAfAtZ2umbtSwBqEkFtGhV5VTlosGUZIacz+IWcqmn3kpofj1FOVASpQx90Kgbk1xfboLCjhsqgLhaKA8lC5i1EgOpIQi4aTFeMl76Xm/bj3jJgGbuYZdQPqN2ABmy8mTtenom7Gfph9q0A2bZEVpBdDDRexZahtb2rKm9Olth81ELLm8Wymxr3tM2n+fcqyI5h0AnW2FPRZYjChNhAhjk09AGW5iM10zi3Ji4HoCtXzNhEFzT6zJoXXR/HM03W5IHQoxDeZaqaxN024nlQQsKTGYJz2ZT+m0woa+Btu5fdazwcVoG4wRClFuaF5d1QF2/JCQYXYW4P4kIT5kN11Z5nHec6yzeS6J7SexjlOjugBwTTetyVFLm8xI9gIHj/NSZZFKvcVZuqtBpjgZ5S5o+nPUW1l4lZsrTuCPJlbUVmqn3LfTl38REOPliMouKvChB+gVdEg8lJcktk2xYh2GfiwnU5OlR0AfvCPpPpfuuzOfQj2uool0SmIUi9Ga3n/BaBK0ICinIpN8hIufVGLmuQH
 hL5MGKxK
 +b33Np5o/pbKbfhHk4t9MsdnQgh6u82fdZvTQamtm/gQAvNYlVzCbD76jPAyfVQGBPohTzXzpfTjmnGPAA+lsCFt3M6GgcG3MjhFAWPksGMNZ5wHgFlBqY0Kjv4QUuDBuF8qQjf7SbnGtfxk6O+gr5Ogn2Po+fTIYKaWL1IkG7rabL019cKwwhYVArlpssPH0Nt12e+uuLOQoMfSFYqOzGezl3UGk8JhFfhIOlEFlppWyJCO5kQbuGqYTkWIRXKXi20ybIHBXugdZ0cx5J5elD45l+5eVRtiW1OXW2uuKC755l0qTgtTYHyNSLM83bFAhj9bIiIw02rNltQQYHMSpdh/rv2NTGPQ91lJuY3NB2j0bMeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 4, 2026 at 2:57=E2=80=AFAM Matthew Wilcox <willy@infradead.org>=
 wrote:
> On Thu, Jul 02, 2026 at 03:59:24AM -0700, Christoph Hellwig wrote:
> > On Wed, Jul 01, 2026 at 10:51:06PM +0200, Andreas Gruenbacher wrote:
> > > Do you have any suggestions?
> > >
> > > The above is on RHEL-8, but a similar code path exists in cgroups v2,
> > > triggered via:
> > >
> > >   echo reclaim_amount > /sys/fs/cgroup/.../memory.reclaim
> > >
> > > That code path starts with:
> > >
> > > memory_reclaim -> user_proactive_reclaim -> try_to_free_mem_cgroup_pa=
ges ->
> >
> > PF_MEMALLOC is a sign of direct reclaim.  cgroup code is doing really
> > weird things when it is set and it is doing writeback.
>
> If we're going to blame the cgroup people for doing weird things, let's
> cc them so they stand a chance of seeing this ... original at:
>
> https://lore.kernel.org/linux-fsdevel/CAHc6FU4tz8-HmEf2_XKT0NT8N=3Drv5OMc=
Y79PxTACkXAVLOAUpg@mail.gmail.com/

This is all pretty ugly: inode_lru_isolate() selects inodes that have
a clear i_state to evict. Among the inodes selected is at least one
gfs2 inode that has the GLF_LFLUSH glock flag is set in
GFS2_I(inode)->i_gl->gl_flags. That flag means that evicting the inode
requires flushing out revokes. Before that log flush can happen,
ordered inodes need to be flushed (ordered journalling mode). And this
is where iomap_writepages() got called.

Unfortunately, filesystems cannot refuse to evict inodes once they are
chosen by inode_lru_isolate().

An acceptable way out may be to set an i_state flag whenever the
GLF_LFLUSH glock flag is set so that inode_lru_isolate() will skip
those problematic inodes.

Thanks,
Andreas


