Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1935BFD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779306B008A; Wed, 25 Feb 2026 17:54:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 723D96B008C; Wed, 25 Feb 2026 17:54:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6120F6B0092; Wed, 25 Feb 2026 17:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB196B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:54:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F376913A0AB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:54:05 +0000 (UTC)
X-FDA: 84484483650.23.C28896F
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id D9BCF4000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:54:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ubOtOA7Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772060043; a=rsa-sha256;
	cv=pass;
	b=ny/YOmCRLyRKPUAdVQEou82XbuLamGMJDChh6kWyImVuLXl5hMPV1bELr7CxFUI3gkmFKl
	dmR6v474EY2nUAptc5LzTKG80NBQimO81yp2m8TPS1ULRIc1jJfX9k27oxPwbVm2OLr9Ck
	ukLG2RcMxsXeHPJSCpToQekf6dpgzQo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ubOtOA7Y;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772060043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HuRDvA6p5zItbneJew7P4gaYb7aavWFbfaGOQjNc2g=;
	b=Xj43wVb/Q7wTU7R5jPjx2YJ84Lcjk6cw1XCP2kJitgPa23LI64oTj0BW955exrIzYjy5Y4
	KG1yB7BE3GVa4vre06SLUoZnHgm4r+f1cAVyK3ZStyhaRgrXwkNrCcSI8tY0Pl0wAqaqTL
	ZZCXn72ZJBOvbxDRdXeN2FPJcQED+X8=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ada9e4ea32so15175ad.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:54:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772060043; cv=none;
        d=google.com; s=arc-20240605;
        b=j/x3uIo4Hx7+2Cef36KYJ17jW8Ib2e4VFr/0tzzcKYGJKj1Pk+KJHkfep8kpFKpUB5
         rBvLQZQYECyzVi9/NeguS0txgnoOxPgISBWfwHvpqJ6XV/DA5BEwYso3N7PieJehe7J2
         msCwO73wuNZsmLaoCzbHcnGBQ+7VViORYwmKqKhrKK1z8J7Kgj96vinRx1MRGJgaJGV2
         vwrvjYzc3AiYxvGVFXcO67gx8RvMK7zDkP+mF/KcU+MAZ+6yx3wuaLqcmy0UiIINQrZh
         4yT9IlsO+xFr/ioUN4bnUBke4uUZP01brx/ldvcmvcBA6Mk6m7yx5iH9CuCOPxC01tF9
         4GWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4HuRDvA6p5zItbneJew7P4gaYb7aavWFbfaGOQjNc2g=;
        fh=ekSmaWKOqYBbKH/B0FEiPb4HZNvsXMXH1iVUiz+QkKU=;
        b=fODZyxI59s0QdBqRzrvDtSRAQ7W1DL5DwneXk3j1dB6XhPWfpRwq3jF7bTrQYlT6bB
         UbC60BX1PZ2+4/sNJ67n9zREe4xYKVy3iUgF27bcVcN0NNCGtTEyARegd1qBOgo1gyXx
         upVcFlezs4F6dZrcOFD3u3h40iqlHmHQwu9qPfRmIu3s6WsiwSI0wgfE1FQP7lDf/4ie
         UqOj1xvyPOQpf9aIFBImWNSVH2wCH9GMmq/KfheP5/xSYgP33xilGsqsnNFquhvisQzc
         wUhjYNiImcB22JW3hU1NMeBLS8uF5TXOGMNQUKBi+GQhIaaHsFO4O/+vkc20TU74QUaw
         CQug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772060043; x=1772664843; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HuRDvA6p5zItbneJew7P4gaYb7aavWFbfaGOQjNc2g=;
        b=ubOtOA7YXLyH250GbxRApNg28l4Bc8Rg6fCbaxop2DBUXFbw0UjM/aiEVR6TTtzUte
         3FCpX+Lu1v/TKnebUHqA3iY0K4X34VtScZvvV6DwisEmb1/RWqi9M8wCy9XtXoZXSjBf
         fvENfc2eAnx57z2IcnTC2g+MZF0GEJbszhPo12qVf5n0Hg0nZXNJyMZqUnosH/E3yWIz
         EoBq/q1LBlTDlJTQsk37QwD3mqSbqrKueCtNtwRlwG/+KIs7kIib2SCKgKK76A9D0EjD
         odRmTqWgm/inxpFKVbL+VFQxlr1fiTr6nbKLwEarivlNi2CSUDCuYReGf0q7cF8nUR6O
         nsWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772060043; x=1772664843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4HuRDvA6p5zItbneJew7P4gaYb7aavWFbfaGOQjNc2g=;
        b=Nh/VNbt2kGIcleHji9I8lO4EwldJsy8tZqMwUqONv+vHUdUeH9rTlmGSesj8DVGAmc
         mgoCnk7fGj6S3Nzy1jJHiTHnEcKz3tj90dU2Ypch6xKDVGS9SB88SV/ddc6xACG99zhe
         WRc2BSPOjYtdU/qWWkrv66S5vDClRmRuh39pYOGOtI65tIYbwsz/zOlubAKo55nN1kCx
         DzTPA4nqX6hAGT5YqmvAjWMHOV0Cw8Mu8NyWCwzJZcBy1FemPCjTP022/paBGd94LovP
         COs65+bOvV+Qm0i1RtGc/Fg1jV5Lxldu50bhjCTy6T3fzPhBC3Qhp+wa2KIiI0TaeAcm
         ducQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrpIsrLBw5KV3W47bDy7A8wvW8Oll7FMTFFq/O44deH8EMCiGbHmcN+EDo+voAwXEXQyZ8fHDe1A==@kvack.org
X-Gm-Message-State: AOJu0YzVurD0a0ZlPnJTWqXCMYFk/KWcd4Z89vHBVJFEKJl43+4b3iai
	5Fy6w2Lgh3hcULuDwq7Ks5dBgXEBHdsa5Dc+UEMBXWsqCRQolytMSb5jY7Tsx9PJCTHzP0EEmrZ
	o+ooy21IvXKdJyi1UJ74k+D1Zh7pHFf/B4cDZUuCY
X-Gm-Gg: ATEYQzyHo2GZ1Omdlgk+6Tbivn5IIMPJDJq+PTtGJuoE49/1UNmsDHrvszd5bRMOlHh
	4cvr7AjYjx2B8+BAOaSDH3reHxzyKMIMIWTE401UdfXY8Ag9WzEhPDDnXmw417X5Lu1iN3Tp1fA
	KAf7TCu1JBfR2UZk/3qIepnyaFMCwcQZw8GgCG75xOTT7N4A26gg9ijv0T7WGRaKbVreuyy0l7p
	qXq0qV0UGEuK2EzztQUNtV8BvrWureX+OA2vWFjrXwJe2GZ68KEr85BPlm8ni6iZLPlIo7y+MAy
	vRv8mdYqoBxOjyhCrAybwqpvSLEFKF1uE+V92g==
X-Received: by 2002:a17:903:8c4:b0:2a8:ffed:4663 with SMTP id
 d9443c01a7336-2adf7738436mr799085ad.12.1772060041893; Wed, 25 Feb 2026
 14:54:01 -0800 (PST)
MIME-Version: 1.0
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <CAC_TJvcaJdEzK8n9BK0qgEXdzjzXtbA_Zk-ybfmG8kjNExVCzw@mail.gmail.com>
 <fqabaahjjlmoc2xh4cwh4ykbqyu3rnzvjw5epxi5wwpmgqth7f@d3mqpjozwmo4>
 <CAC_TJvdRsfzYohiKW=82N8Ofi5V26rX1GS0M8HeaX6CEsgc+PA@mail.gmail.com> <7302e25b-dfcb-4117-85f9-870632999dc3@oracle.com>
In-Reply-To: <7302e25b-dfcb-4117-85f9-870632999dc3@oracle.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 25 Feb 2026 14:53:49 -0800
X-Gm-Features: AaiRm5115WEriTEwyOL6pAVEQGUSdPho0h6nJ0kCy4aKIpi-RiI2rNOQ4qeMtvg
Message-ID: <CAC_TJvc+Ld19MrqQbTLkLXbLe3D8nYNP2DkD0knv+u7mjRC++A@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
To: anthony.yznaga@oracle.com, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	andreyknvl@gmail.com, arnd@arndb.de, bp@alien8.de, brauner@kernel.org, 
	bsegall@google.com, corbet@lwn.net, dave.hansen@linux.intel.com, 
	david@redhat.com, dietmar.eggemann@arm.com, ebiederm@xmission.com, 
	hpa@zytor.com, jakub.wartak@mailbox.org, jannh@google.com, 
	juri.lelli@redhat.com, khalid@kernel.org, liam.howlett@oracle.com, 
	linyongting@bytedance.com, lorenzo.stoakes@oracle.com, luto@kernel.org, 
	markhemm@googlemail.com, maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, 
	mhocko@suse.com, mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de, 
	osalvador@suse.de, pcc@google.com, peterz@infradead.org, rostedt@goodmis.org, 
	rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com, 
	willy@infradead.org, x86@kernel.org, xhao@linux.alibaba.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org, android-mm <android-mm@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D9BCF4000B
X-Stat-Signature: ox7ybgdzzdjzm86pwbd16cqxjf87xeut
X-HE-Tag: 1772060043-59876
X-HE-Meta: U2FsdGVkX1/MrjYTN3i4mlQlRUSFdforfQvfD5tkgZPrfUcEVYCJ3yvRWv3d9uIJTEUgkA09kITYCs4ohKPCIv+NjXkDz+ewXLt5D1VtrooHd4gfQts/7rKJ3CwF793q/mgkPbv66u1Hnu58WR10mBQlEGb82eJXQqFHvGNWpWmslw0jTTTp7fR11XQhI5WtdqqRGlo81BVVbjK0hQJ79CZUwGdVMB3sow2rlX5mVPuiZfnTYSvvF9dJ8zeN30QY0igTqkDnDvkC/DxTR1Q9uJsgOvpDYECfE+nKJSe5VKiU18oiQx6ZrSeGlNTbOv9RkcUlMoEhv75hcbESVxvHMLF+2rCcRFAlB1U+VRePbIeHnusDqs3NSwm5AXPX4GYfktZV14/Bv2+1B537Cn+fFq2hYMiCvX+aKHZJ6W7SXDsx1bKxUZhHOYqh1YCf+6rNZFfvO0PcTpCzNuAqNUlHaodJp2SUujkNxUvjmfHRm05ZzwsT4aULemIaOAXnThnHTDjBuaYPGZjqfQr/9U2hVAjS+xhwM6DfKmDHkrPe//JY8hSvlQdtrTzDi6H29uaR2/FjK1QJjckGUaBEn0ZGGDQ6jtXdHAzty6b8xDAOPYyuJGeIL5cZBVEH3srjfhU35DoknG1CdibsOuhT44NMR7REbPbsFJ9LoNIzhz708ioC+/xq2KI9mbfiAGpBPzBq4GwFBF2fJOAQ2Tprdh/ccekxJJ4bbIxdOCo8MGnV5DlV0l9+Y3TBOxBzOFEPkRDIGgTGm4UqLjoBVpnm5P5RJJsKykqVY2l8CLiEQ2gZpnLOx9qYNwgM8UpkedrqjqXp93TRcHuNjTVJwmhNyRNdg8OEirWktMYTTWLcLvwdc9h1OeoAt7T8v1tdQtUuQRURKRpH05eNIRdF+PI7HkDB4YqYNMVyjAw3fdlItrZXKRhgQJoiWdIjmPPji4aLIhbaUPWt6/CwAdXuLg0BUFg
 69mRvkkd
 Z5tmLusi+pFE728cONvMP1yRcQ4UmxnYBT/Ye/ABa3m+SSf5LiRGVI6DqXXcjd/cS0J/2lRFheuRmvvMv2Su4nd4tY37aEHjnPrNWRCPFBN+BfRufmEK5oKdXDpQLCznQi3ktMz62bz5EMDyGC06ZPK+piz7PhZWVCnP2JE+NF1iPWg3S+JZB9sRHcaVXgxWS4pFmRRQaI52PByR8L4iBRqdPKHN2JlNfTx69yqYY4+NgxzhT4iokhS2Kd5fbiaRUnJL9cPGqSc9OK54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 11:59=E2=80=AFAM <anthony.yznaga@oracle.com> wrote:
>
>
> On 2/23/26 9:43 AM, Kalesh Singh wrote:
> > On Sat, Feb 21, 2026 at 4:40=E2=80=AFAM Pedro Falcato <pfalcato@suse.de=
> wrote:
> >> On Fri, Feb 20, 2026 at 01:35:58PM -0800, Kalesh Singh wrote:
> >>> On Tue, Aug 19, 2025 at 6:57=E2=80=AFPM Anthony Yznaga
> >>> <anthony.yznaga@oracle.com> wrote:
> >>>> Memory pages shared between processes require page table entries
> >>>> (PTEs) for each process. Each of these PTEs consume some of
> >>>> the memory and as long as the number of mappings being maintained
> >>>> is small enough, this space consumed by page tables is not
> >>>> objectionable. When very few memory pages are shared between
> >>>> processes, the number of PTEs to maintain is mostly constrained by
> >>>> the number of pages of memory on the system. As the number of shared
> >>>> pages and the number of times pages are shared goes up, amount of
> >>>> memory consumed by page tables starts to become significant. This
> >>>> issue does not apply to threads. Any number of threads can share the
> >>>> same pages inside a process while sharing the same PTEs. Extending
> >>>> this same model to sharing pages across processes can eliminate this
> >>>> issue for sharing across processes as well.
> >>>>
> >>>> <snip>
> >>> Hi Anthony,
> >>>
> >>> Thanks for continuing to push this forward, and apologies for joining
> >>> this discussion late. I am likely missing some context from the
> >>> various previous iterations of this feature, but I'd like to throw
> >>> another use case into the mix to be considered around the design of
> >>> the sharing API.
> >>>
> >>> We are exploring a similar optimization for Android to reduce page
> >>> table overhead. In Android, we preload many ELF mappings in the Zygot=
e
> >>> process to help application launch times. Since the Zygote model is
> >>> fork-but-no-exec, all applications inherit these mappings, which can
> >>> result in upwards of 200 MB of redundant page table overhead per
> >>> device.
> >> This can be solved by simply not using the Zygote model :p Or perhaps
> >> MADV_DONTNEED/straight up unmapping libraries you don't need in the ch=
ild's
> >> side.
> > I think that's a separate topic, but that model is used on billions of
> > client devices :) The common runtime for apps and other core system
> > code is preloaded to significantly reduce app startup latencies.
> >
> >>> I believe that managing a pseudo-filesystem (msharefs) and mapping vi=
a
> >>> ioctl during process creation could introduce overhead that impacts
> >>> app startup latency. Ideally, child apps shouldn't be aware of this
> >>> sharing or need to manage the pseudo-filesystem on their end. To
> >>> achieve this "transparent" sharing, I would prefer Khalid's previous
> >>> API from his 2022 RFC [1]. By attaching the shared mm directly to the
> >>> file's address_space and exposing a MAP_SHARED_PT flag, child apps
> >>> could transparently inherit the shared page tables during fork().
> >> So, we've discussed this before. I initially liked this idea a lot mor=
e.
> >> However, there are a couple of problems here:
> >>
> >> 1) mshare (as in the mshare feature) isn't really aiming for transpare=
nt here.
> >> There is e.g a specific need to setup an mshare region, with a few fil=
es/anon
> >> there, and then later mprotect/munmap parts of the region - and have i=
t apply
> >> on every process that has it mapped. This is why we're aiming for diff=
erent
> >> system calls (not ioctls anymore), doing munmap(mshare_reg, 4096) is a=
mbiguous
> >> as to whether you want to unmap the mshare VMA, or a VMA inside the ms=
hare mm.
> > Since we are interested in sharing text here, how does this play with
> > stuff like symbolization for call stacks? I believe this is another
> > reason where we might want to avoid mapping the pseudo mshare file
> > wrapper?
>
> I haven't explored shared text, yet. There may be dragons there.
>
>
> >
> >> 2) Sharing the page table at all (even worse so, Transparently(tm)) is=
 a huge
> >> pain. TLB shootdown becomes much harder, and rmap as-is isn't suited t=
o deal
> >> with this case. The way things are going with mshare, the container mm=
 will
> >> have one single entry in rmap, and then actually doing the shootdown i=
s a
> >> huuuuge pain (which, fwiw, will probably need a per-mshare TLB workaro=
und),
> >> because you need to find out and shoot down _every_ mm that has these =
tables
> > I agree the TLB shootdowns would be a pain. Perhaps, if there was a
> > concept of a shared ASID/PCID in the hardware, that would make things
> > less so ...
>
> That would certainly help. sparc64 has a secondary context, but that
> doesn't do us any good here. :-)
>
>
> >
> >> mapped. And then, naturally, since you're sharing page tables, doing A=
/D bit
> >> collection on these becomes extremely useless - and that will naturall=
y pose
> >> problems to the reclaim process if you abuse it.
> > I think in the use case I described, it would mostly be sharing
> > MAP_PRIVATE stuff, and the access bit should still apply for global
> > reclaim. However, I agree it becomes difficult to reason especially if
> > you throw memcgs into the mix.
>
> mshare won't support mapping objects in it with MAP_PRIVATE. Sharing
> PTEs to memory that can be COW'd is problematic. If it's something that
> can be adapted to use MAP_SHARED then maybe things can work.

I can see how mapping .text and .rodata as MAP_SHARED could
technically work, assuming the sharing process strictly mseals them to
guarantee they remain immutable. However, RELRO (.data.rel.ro) is a
different story. It must initially be mapped MAP_PRIVATE and writable
so that the dynamic linker can resolve relocations. Because these
modified pages cannot be written back to the backing file, they become
private anonymous pages.

If there was a way to allow an initially RW MAP_PRIVATE mapping to
resolve its relocations, be write-protected, mseal'd, and then have
its page tables shared, that would solve the RELRO issue. In the
Android Zygote model, this works perfectly because relocations resolve
before forking, meaning the resolutions are identical for all
children.

But how would we express this in the msharefs model? Transitioning a
post-CoW MAP_PRIVATE VMA into a shared page table structure seems
fundamentally at odds with a strictly MAP_SHARED file-backed
pseudo-filesystem approach.

>
> As for memcgs, the current idea is to have an owner associated with an
> mshare region. Currently this is the process that creates the region.
> Mappings in an mshare region will be evaluated against the mem cgroup
> the owner is a part of.

I'd also like to think a bit about what happens to other standard
memory metrics. Should accounting that actively walks the page tables
(like /proc/pid/smaps) still work correctly and see the mappings?

What happens with the counter-based metrics tied directly to the
mm_struct rss stats?

Since msharefs manages its own detached mm_struct, should we include
those RSS counts across all sharing processes when reporting in
/proc/*/status? Or will we need to introduce a new UAPI to
independently expose and understand the RSS of each msharefs
mm_struct?

Thanks,
Kalesh

>
> Thanks,
> Anthony
>
>
> >
> > Thanks,
> > Kalesh
> >
> >> 3) other misc problems that make it hard to work transparently (VMA al=
ignment,
> >> levels which you may or may not want to share, you need to revisit mos=
t page
> >> table walkers in the kernel to get a completely transparent feature, e=
tc)
> >>
> >>> Regarding David's and Matthew's discussion on VMA-modifying functions=
,
> >>> I would lean towards the standard VMA manipulating APIs should be
> >>> preferred over custom ioctls to preserve transparency for user-space.
> >>> Perhaps whether or not these modifications persist across all sharing
> >>> processes needs to be configurable? It seems that for database
> >>> workloads, having the updates reflected everywhere would be the
> >>> desired behavior. In the use case described for Android, we don't wan=
t
> >>> apps to be able to modify these shared ELF mappings. To handle this,
> >>> it's likely we would do something like mseal() the VMAs in the dynami=
c
> >>> loader before forking.
> >> mshare_mseal!
> >>
> >>> Perhaps we could decouple the core sharing logic from the sharing API
> >>> itself? Since the sharing interface seems one of  the main areas wher=
e
> >>> we don't have a good consensus yet, perhaps we could land the core
> >>> sharing logic first. Keeping the core infrastructure generic would
> >> I think the core infrastructure is relatively generic (at least the
> >> small core mm modifications to get this to even work) already, but
> >> perhaps Anthony can comment on that.
> >>
> >> --
> >> Pedro

