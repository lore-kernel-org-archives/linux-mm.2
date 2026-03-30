Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3367810D14A1
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4B66B0095; Mon, 30 Mar 2026 07:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC2B6B0096; Mon, 30 Mar 2026 07:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8A76B0098; Mon, 30 Mar 2026 07:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4ECED6B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:18:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E5FDBB79E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:18:08 +0000 (UTC)
X-FDA: 84602480256.24.B882CB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E72D6140003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:18:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dlm89U4F;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774869486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWbg7c/dl/99TDKsSBmko/L6vqpZcgKV/525bIG9uLE=;
	b=n9jkx4LrzYbum6CHULbECnf0ZpWwM+BB/MPE3/FxEE45FPLcDp9M0hD3IOxO0VGSLP0kWz
	GhRAJXXFEiXeahj9tljitd6oh4738xmX72fkny981YtJ0eInMovny6E4UkwAUnFUIcdWf5
	ITBYQ7K3PiDTIb+sNxQk20L5XLjfsjg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dlm89U4F;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774869486; a=rsa-sha256;
	cv=none;
	b=GGeW/inWNPet8+Fag/NEJly3xmIRMr/QlroaIfYT5a2ik6jbIHEpCEbxRqyEJwj4ndldko
	Hd+ry4iKrkFUNvofyMzNuPGqEKWCdJkfuJNVQBbh4tzSRzg06An2d/UCD12ZQj5VvZlmOX
	PQ6DoAXtyMSvnhSQf4pROrdQ6LohExc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51072600AE;
	Mon, 30 Mar 2026 11:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC25FC4CEF7;
	Mon, 30 Mar 2026 11:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774869486;
	bh=bcehu9930zv7akkD3oS1tlm215YYcd6YLKnqN2zQwhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dlm89U4FcOq9CCM3y3iJOU23PncWWcU9P3CA6Ls3Wwm8CcxQHAJKAp+okUduyKLTR
	 awCb/XkUaxKoK4q2Tiprz2PZb7dpp334Ovi1SG22va6xcetBu31JZeroLegZ7tui4p
	 gbhMv5TGGdtdnKNUaHzAlcxeNnAqjIKXkN2kmti0b6faHVyvBw2Z4ZWiQFcjE+EGnf
	 bvd57kjV8JEh0GLzZgunjm9vDT7oq186s3TFMkyoaJ6p4uVuWH9NOo+tvD706lgp4G
	 zCe4eIj8ama1T1KI/JbQLy+nh4sTzc3H2mNgW9mL/LS5GVGlJXP78qIGk/fT4C/5zx
	 UzI2PcGDSQPmg==
Date: Mon, 30 Mar 2026 12:17:57 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: WANG Rui <r@hev.cc>
Cc: ziy@nvidia.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org, clm@fb.com, 
	david@kernel.org, dev.jain@arm.com, dsterba@suse.com, jack@suse.cz, 
	lance.yang@linux.dev, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, npache@redhat.com, rppt@kernel.org, ryan.roberts@arm.com, 
	shuah@kernel.org, songliubraving@fb.com, surenb@google.com, vbabka@kernel.org, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <32679321-b2d3-44d7-be2e-f7a6a166a510@lucifer.local>
References: <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>
 <20260329040742.17269-1-r@hev.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260329040742.17269-1-r@hev.cc>
X-Rspamd-Queue-Id: E72D6140003
X-Stat-Signature: xqio53acknega6g351n55ijhwfd3r63k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774869486-981522
X-HE-Meta: U2FsdGVkX18KysahGoXc3/Fev2m5hhGtgPoenmzFumIx/p/QQdYbsbWunVg688sLegL9mT7DtVBUsId1Hw7DoTYbp9hYLq7rqX/NjCSvK++3BpjeokQJpb38AtX2DFGA1uO46duFTqd67wqK+VsX6STnOWLlo64SdFcxyAPthgVqnVqs+QZ3O3PCD2lzu7KErWI5RQndGpsJwz+enaE+h6+F9/ZkwUCHq7S/DKYi/09E2oM4MUBvDKCH2qku6KEt5b3GpbbGXviHG1sBwtM2jr/O038pM26g57KDh9BYDrm0vkhgSHIaphkoE4o8kyHcgyNRQzpjp6J528Z5eg7QreR218Uar5p7ASj0HefR4Fxc8I5NyYWNO2KrGxHz7aVSBjPZrKQayemWnDSYQuuiSpxgkMCfteDwLluimy2+1ztTKu/JxPSlq+AiqLU/UWjAdzFNeVr19kNXM+QX9gdITVRfjPBbNcOuIlVPNLBkeBzHsvkgeJ/u+gZhoTFwLkQj4hauBwkjgTo/igeJ2MnTOzT4MkUmwFjlGEuAJk06cJ7w4yJETOCupNdpGwxTClcwZXQe23BNQTmQNxu+J6hoC1QsMhStTPpQb1IySe7XXVuDOTmx6CwH0Nrz/6wNafh+Xv99DCLKbThP0nM6G4e2QtzJedRPBqH+WiHcLXzLw+vxqa/OreGf7R4Hv9/kr6cd0kYglcREnqK+F3uBu4HPxAq6E7c1XfWrOoo3WWxD97B96L0LJdGqEyloW5fuNJ5BqMwVPVU3FK9TC96Gkjl0OrrKLh1ST7yBKoaBZLbQMSuKImRp8dejbt/CJ0Yh+u21tg0DguqKkuAnrTYQUG2CMQCzKF36c6Nw5329XDoQhof1A/abkTYZJp8/ZX7wE6eTcZZftn83wuHJ1HoWPCJmHNWTUpIB0gp8B/aG42ErZTWh7YWV8V1d6Mv1SvMdPG2L+zc5AnhmyOo+PpQgBU9
 F/OjmllX
 GnX+ydjk4W0Z8irPk+qs1388t9mjEp/IuaoJwxJODnVwxcaeMGu3+zYQ84F6cXU0MerRmKyhzgy1PJdUirlTMVzymvMu3sZMsJ72XDAnjy+zlukCas4FKAfnOgLje95sYP5kwzQGj44DqXFowTqHuuYXvJVZ1kOSYGllKzIWLzeeiNDJ8DQnrRDvcx1uSaZes9ETw2U6/zuNs4VSAxITkVasseRA/TzNh+/50hMBTbBHfm83N7tGfTSiPD+xF+i5vHzxyUgo2WwAmO4w77mK20dRE4y2dRIq/nvd3nBsyoHj27V70ngJS8T4ArZLaaTm5t4uOGpaN1NtMEWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 29, 2026 at 12:07:41PM +0800, WANG Rui wrote:
> Hi Zi,
>
> >> Now without READ_ONLY_THP_FOR_FS you're going to:
> >>
> >>                        |    PF     | MADV_COLLAPSE | khugepaged |
> >> 		       |-----------|---------------|------------|
> >>  large folio fs        |     ✓     |       x       |      x     |
> >>  large folio + r/o     |     ✓     |       ✓       |      ✓     |
> >>
> >> And intentionally leaving behind the 'not large folio fs, r/o' case because
> >> those file systems need to implement large folio support.
> >>
> >> I guess we'll regress those users but we don't care?
> >
> > Yes. This also motivates FSes without large folio support to add large folio
> > support instead of relying on READ_ONLY_THP_FOR_FS hack.
>
> Interesting, thanks for making this feature unconditional.
>
> From my experiments, this is going to be a performance regression.
>
> Before this patch, even when the filesystem (e.g. btrfs without experimental)
> didn't support large folios, READ_ONLY_THP_FOR_FS still allowed read-only
> file-backed code segments to be collapsed into huge page mappings via khugepaged.
>
> After this patch, FilePmdMapped will always be 0 unless the filesystem supports
> large folios up to PMD order, and it doesn't look like that support will arrive
> anytime soon [1].

I think Matthew was being a little sarcastic there ;) but I suppose it's
hinting at the fact they need to get a move on.

>
> Is there a reason we can't keep this hack while continuing to push filesystems
> toward proper large folio support?

IMO - It's time for us to stop allowing filesystems to fail to implement what
mm requires of them, while still providing a hack to improve performance.

Really this hack shouldn't have been there in the first place, but it was a
'putting on notice' that filesystems need to support large folios, which
has been made amply clear to them for some time.

So yes there will be regressions for filesystems which _still_ do not
implement this, I'd suggest you focus on trying to convince them to do so
(or send patches :)

>
> I'm currently working on making the ELF loader more THP-friendly by adjusting
> the virtual address alignment of read-only code segments [2]. The data shows a
> noticeable drop in iTLB misses, especially for programs whose text size is just
> slightly larger than PMD_SIZE. That size profile is actually quite common for
> real-world binaries when using 2M huge pages. This optimization relies on
> READ_ONLY_THP_FOR_FS. If the availability of huge page mappings for code segments
> ends up depending on filesystem support, it will be much harder to take advantage
> of this in practice. [3]

Yeah, again IMO - sorry, but tough.

This is something filesystems need to implement, if they fail to do so,
that's on them.

>
> [1] https://lore.kernel.org/linux-fsdevel/ab2IIwKzmK9qwIlZ@casper.infradead.org/
> [2] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc/
> [3] https://lore.kernel.org/linux-fsdevel/20260320160519.80962-1-r@hev.cc/
>
> Thanks,
> Rui

Cheers, Lorenzo

