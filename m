Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15C59EB2700
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 20:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514106B0005; Tue, 10 Feb 2026 15:52:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C21B6B0089; Tue, 10 Feb 2026 15:52:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3296B008A; Tue, 10 Feb 2026 15:52:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AE736B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:52:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9F8EBA3F5
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:52:25 +0000 (UTC)
X-FDA: 84429745050.04.1CD38AE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 95C0740010
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:52:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PywHh+/Y";
	spf=pass (imf07.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770756743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MrCEFLIbdwEIb4gpQxK0QNreKVswbTUWGMdqr2Xi3hA=;
	b=H5gBTC7dQwkAhjwSEaTGhjuusub/to9RMLmLAbQYA+idF+v6HGkuhet8vHIfTMd3qE02UU
	Oaqhb7gEqD2huWYFNHfuRxGcKnz6i+HKq4wDCCQ05hboNR1CNHCQcGt2kEreGFrlkA/mkJ
	NHBXOsdf84OYD7RBjhyPr0kYZsONIcQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="PywHh+/Y";
	spf=pass (imf07.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770756743; a=rsa-sha256;
	cv=none;
	b=y4DZ89Xy6GwPTcPjrpeREhdq8jTWxmxlfJGo9n3HGG5A9L1b3aJDqO+N4if7cnACxYk5LG
	cdUU4cFv/T1bPfIdI9tJfhGwYQxzDmqeY89EOxGgbZFaABPy5pFIsLx5IRNDrqM3Zi4yLC
	/7QXN3Pxd/bak9Qfma924lf/H1+YTwg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770756743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=MrCEFLIbdwEIb4gpQxK0QNreKVswbTUWGMdqr2Xi3hA=;
	b=PywHh+/YRX/oVPDU8N+ceZN0YdY7lrEHAxMp2AP9J3NkXMCDqiHGIlX6j6B6t0uAeMSrom
	hcY5VBLsGmLrFCA0yUZAA+lO3Qd9z3YNjy4pdtuWa+JXdqCnj6R+CkMkPvOG1LBmDUyCm6
	9RqkfxXwWF8QSExqD02SO6WX4Z5PQCw=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-TWuGZ_tROb-ASQpFHqGqTQ-1; Tue, 10 Feb 2026 15:52:20 -0500
X-MC-Unique: TWuGZ_tROb-ASQpFHqGqTQ-1
X-Mimecast-MFC-AGG-ID: TWuGZ_tROb-ASQpFHqGqTQ_1770756740
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5033c6265d2so48078011cf.2
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 12:52:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770756740; x=1771361540;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MrCEFLIbdwEIb4gpQxK0QNreKVswbTUWGMdqr2Xi3hA=;
        b=qgVeunaTblzZnCrp22qMWJskMzJmYSqr/ofh3n7L3u6LcDjxfPXyB4YrpF0SI7oBCn
         XHMb7pJ+uYm8RGwaC65AuQCEhTd3anH8IMGjm87Kvog2QsPZt0Ho9x2f40x/9dGXk6te
         Ot8AeFSDMd8/xeBEQuI4uqnOiR8lfzOzgW3LrmI6Nyw0D2cgG9xgJGcpzjgtYUCNpti8
         q940WQfoBMMEUhToQa3llkVGLStgd8Soa/Qe9nl1MNFK5PG0LB7UtPwfCEmtxlMJUkav
         h2WbCs205olERuGUIR/Rvn8FOgSaadAKmvzd0ICLz6LvS4EndLoj/Uatx+Ybjj7rZnav
         AABA==
X-Forwarded-Encrypted: i=1; AJvYcCVE5/KI3xuNKErzcTQhXtpNL+GjqP2M2N5/kbkhtsgYwl/HiQh5NfdRImeFcqKvg5Ge9+ftpvVTlg==@kvack.org
X-Gm-Message-State: AOJu0YxcQReCZBD+rHEH4JdblyvLhFzQMItLW51T/QAz3FMRXGLqTS8v
	4TCqLAd5RoLysEf1UOsMUFeMxPHmaZY4qqycntmgtZBJSvwsYt4t7cwoBiA0CIjpFjO+UtY/0Ot
	DjR9QIxoWNruduGt36O8pupKKn7VdjOjPJd8gHboU3XVBfzBDRU43
X-Gm-Gg: AZuq6aJQqchkzSwZlpGFxKsdn7ZekY7BeLa8lUeCbf+DmYGjy8tWH1/5kAN8qx5HcN6
	o1bFP/Tyh9oZBLdEhkf1WYpDqVoE4YuIZXPwlRdG61XcdxRSVhlZUnPBi+UI1ZiVhkV6vuhaE5e
	8YjOiHnt17FA+ovW7Xwc5SN0lEMVlx3pmlRZE9xa3OUxmB0tL5EXH6dTqCrRVKdPtNc3C1ogp3F
	F5HztYGZ1+0TLLThyg/x8XQTxgRIr7j4Nobcdgy7IgI1UprheMyt7fbIL7SjIXA3Xt+D6s8SYN5
	h1CkYsqUo6cnUizS4IB4VLrg9GAF7HSuUuCsIA/EI8WBImSvwVavGIISiclv8zd7LbULRYUkqCW
	MJ9wfBN58q9UCOg==
X-Received: by 2002:a05:622a:54d:b0:4ed:2edb:92b9 with SMTP id d75a77b69052e-506399da643mr228209531cf.81.1770756740025;
        Tue, 10 Feb 2026 12:52:20 -0800 (PST)
X-Received: by 2002:a05:622a:54d:b0:4ed:2edb:92b9 with SMTP id d75a77b69052e-506399da643mr228209331cf.81.1770756739560;
        Tue, 10 Feb 2026 12:52:19 -0800 (PST)
Received: from x1.local ([174.91.117.149])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8953c056e78sm109453876d6.39.2026.02.10.12.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 12:52:19 -0800 (PST)
Date: Tue, 10 Feb 2026 15:52:07 -0500
From: Peter Xu <peterx@redhat.com>
To: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [LSF/MM/BPF TOPIC] Userspace-driven memory tiering
Message-ID: <aYuad2k75iD9bnBE@x1.local>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YKboaQYdk8O2KYwOOlIbsSjRHvteJJh0MYybqqQUQ6Y_1770756740
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: 9nfbs86t5q56c3yy9fpibwqgsw1jcrcb
X-Rspamd-Queue-Id: 95C0740010
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770756743-960635
X-HE-Meta: U2FsdGVkX19UWJmFZ0zaI95e2eXpVcEPcG2fdaWJ7GANm+JWBbSGey9olp+0qj9/cCaM5rQF38T2OOVunLH7PSdt2Af1SL1579ocQwjcZxzk0bG9J0vHq7EdjBF9/NQMtqQanwDEcIMwN37brNDbGYdwQE1nwiKRoOoLp5ug8nTXAciN7Zvz8qJ29oHcmhj/Vtrykan6V0N0+E7SSI9bRgooFZaZPKc5g8NwJ+iHNYif7sHKAi54D5poN9J77xN305edxLYWcKESAXYsjpLmrsENeprIsiF2wHTQnBphIRe0XQ8oRR3Ma/vPjPEFUwftAxgBGng8N8wRMBLFm58OxZ1Frrylgj/Tk6/40kXFPfBtFavMZerRdT7f5n8u5C36H+SjGs/WQ2KH/MarqisaYhWcYVkWsl4JcnsInNd6VElyiH0+waiuFw9p/N9iIAnboVkYA84vuhl9FaAMKmv5umFVZYlC5+IJe6Ek6u+SZecOtktcUeWc2REjl9fqSL1wIANea12mroefKa4NbHQhO0Yv90Bm9quLfimExgD/8Ee4ohRh5N6QZjnHcTz5vMmkL35sRtrjdYgpPrhzOx0IHAvNyzpyN1uWadRuyrfw9O5K1cufdRE5XrCfI2I6JM+L4g0xGd8Z2Go9jmIBGcILEFA2IHvWb/fzOgwijvgXJvKT8E/g7D+I/EPYVGYHqwqE1DcGCf+HJTqbxavL96yu9Qwc8td5gAQfu6Rek8LqQUlf62yPF4wiIJXKOP420lAK4iIH98hM9H8D0woSloPS3bHc8QThNEGsu67/2Ywl2+w4mHfD0z1sjRh+gID5urwF+Q1T5jjRqqZAxVjZ3UWxYyCQc+zbRc8iHFA+zCm+Bzdvn7D1XJAQHrgktbWEy37soXLlstiVqDVhns2IWhw8RnkLMbEJ353+waecQYlQ/xZaxuQTWHtuKVttBafn9HYwb1tiqN9zVs7MbxbSk+o
 Mr9Fk4Uk
 qUhFfNHJBIEIHGsvk1zeW0dBvCNQKhCioiCgPSg8FwTMEJITh1VUm9fC8EVHug9Bgx5yh88pLVytSBUjZ1lq5PBRr57K8Di8OkOrvrxku/YtpBow8o0gXo4/Wbv1EOo2r03ZJ/i6OfMJka8v5wmPo5gj+AKFtfDMsZD9MLEFaECgaudQ7vFo3N9729vPWncMn1xPLnrLG8o0HXfBOyoLja4fMsRafHaAdzP87SVgvNf7zvzAls266aLBbBCYU0w5QXfQKnXXWpuQJjXogwUurN8UnA0VJs5H3cNXykvpRz3/q/qt9NcOJ1kynBNeE4aFtEZIY72PSTtZ6OvJC2JToQkiPkR+qmWAQaO+dUL4PMt3bV1XMvmiUhrnWOH+pr5X+bJCs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I would like to propose a topic to discuss userspace-driven memory tiering.

Note, that neither the subject nor contents are stablized; currently, the
only thing that is for certain is the use case.  The hope is below content
will define well on the topic, and especially, the use case to be discussed
here to collect feedbacks.

I'll try to make the topic more condensed and focused if this will be
selected and discussed on the conference.  If anyone thinks below is too
much for one topic, I am open to spit it into two or more.

It's also possible I make stupid mistakes below as I didn't code anything
up or test yet so I may overlook things, please kindly bare with me if so.

Problem
=======

Here, I'm not yet looking for anything more complex than two tiers.  The
use case can be as simple as: one process, having only a portion of its
memory serviced by fast devices (like DRAM), the rest serviced by slow
devices (e.g. SSDs). In a VM use case, it allows a host to service more VMs
with over provisioning.

With the help of memcg and MGLRU, Linux swap system can do this well
enough, except that it misses one pillar stone of VM where we want to be
flexible enough to move VMs around all over the cluster.

When that happens, the hypervisor needs to scan the VM pages one by one and
copy them to a peer host in a busy loop.  Here, by the nature of swap
transparency, the userspace will need to fault in all the cold pages to
fetch the data for moving.  Meanwhile, after migration the hotness
information is also lost because of such "transparency", because we must
apply those data on top of RAMs first.

In this use case, memcg is almost great to service multiple needs.
However, it is still coarse grained from some aspects: it allows specify
swap usage, whilst it doesn't yet allow to specify swap device to use for a
process, or IOPS allowed to be consumed on the swap devices.  This is less
of a concern in the whole picture, but would be nice to have.

Some possible solutions I would like to collect some inputs below.  NACKs
are more than welcomed, then it may also help to find the right path
acceptable to everyone.

I'll start with the solution that I think might be the most efficient and
straightforward, and I'll only try to discuss the solutions from the kernel
perspective.  The last solution will be fully userspace-implemented.  I'll
only mention it; there's nothing we need to change from Linux POV.

Possible Solutions
==================

(1) Backend-aware Swap Data Access

To solve the major problem above, we want to know if there is way an
userspace can directly access a swap device but without causing it to be
faulted, polluting hotness information (in case of MGLRU, on generations or
tierings), or consuming DRAM / causing folio allocations while doing so.

Considering we have mincore(2) system call, would it be possible we can
provide a similar syscall, besides knowing "whether the page is resident in
RAM", also access the data on the back when it's a swap?

(1.a) New syscall swap_access()

  swap_access(addr, len, flags, *vec, *buffer)

  addr:   start virtual address of the range
  len:    len of the virtual address range
  flags:  operation flags (e.g. read / write for swap)
  vec:    an array containing pgtable info (e.g. is it a swap?)
  buffer: an array containing data buffers (for either read / write)

Examples:

When the userapp finds mincore() reports a swap entry, to read the data
instead of fault it into the mapping, it can bypass the mapping and issue:

  swap_access(addr, PSIZE, SWAP_OP_READ, vec[], buffer[])

It will check the page in the pgtable to see if it's a swap entry first, if
so, read from the swap backend, put the data into buffer[0], setting
SWAP_FL_READ_OK in vec[0] saying it's a swap entry and read successfully.
It doesn't touch the pgtable and keep the entry to be a swap entry.

OTOH, when the userapp knows some data is cold (but still useful), and want
to populate some data directly from swap without allocating folios at all,
one can use:

  swap_access(addr, PSIZE, SWAP_OP_WRITE, vec[], buffer[])

It will first check if the pgtable is empty and not allocated, if so,
allocate a swap entry, put the data (in buffer[0]) to swap device, then set
vec[0] to SWAP_FL_WRITE_OK saying data populated.  The pgtable (after
syscall returns) should have one swap entry populated without any folio
being allocated.

NOTE: due to the transparency, there might be race conditions on
swap_access() v.s. the page being swapped in/out on the fly.  We can either
make the swap_access() be serialized with those, or directly fail those
swap_access() saying "concurrent access / -EBUSY".  Normally it means some
page are being promoted to hotter tiers, hence failure to userspace would
be fine; it implies to the userspace that this is a hot page now and it can
directly access from DRAM.

Both anonymous and shmem support should suffice in this regard.  We could
really start from one of them, say, anonymous, if this would ever be
anything useful.

(1.b) Genuine O_DIRECT support for shmem

Shmem supports O_DIRECT since Hugh's commit e88e0d366f9cf ("tmpfs: trivial
support for direct IO") in 2023 (v6.6+).  At that time, it was only for
easier testing purpose, and I believe there's no real use case.  Maybe we
can re-define this API so that O_DIRECT means "read/write to swap"?

It means reads/writes will need to be 4K-aligned with shmem O_DIRECT, all
operations happen directly on swap devices without updating the page cache
with real folios.  We'll likely need to properly serialize concurrent
accesses but it's fine; when doing O_DIRECT it means this shmem page is
already cold, so slower is OK.

It also means we can't easily support anonymous use this method,
unfortunately.

(2) Hotness Information API

One step back, if above solution won't work out for whatever reason, it may
mean the userapp needs to implement the swap on its own to be able to
access the backends directly.  Then, there's still chance we can share the
information on page hotness with the kernel's vmscan logic.  Here as MGLRU
seems to be a better candidate now, I'll focus on it.

MGLRU by default doesn't work well with idle page tracking.  It's likely
because nobody should be using idle page tracking when MGLRU is
present.. However if an userapp needs to manage swap for one single process
for whatever reason, we may want to allow most of the host run with MGLRU,
however for the specific process it will manage swap on its own.  The
single process may still need page hotness info.

Then the question is: can this process still be able to share page hotness
information with the kernel, so that we don't need idle page tracking
(which will almost stop working well with MGLRU enabled)?

It means allows per-page / per-folio reporting of MGLRU hotness information
on either generations and tiers.  One way we can do it is via pagemap or
similar interface.  Would this be acceptable?

To make things further, consider if we move a cold page from one host to
another, then we want to apply the page with the same hotness alongside
with the data to be applied: would we allow a reverse operation of such so
that we can provide hotness hint to kernel from userspace?  E.g., consider
ioctl(UFFDIO_COPY) with a gen+tier information attached, so when the new
folio is atomically created and populated, it will be put into proper
gen+tier.

(3) Fully Userspace Swap Implementation

This will almost always work with no kernel change needed, with the help of
userfaultfd.  I'll skip all details whatever to happen in an userapp.

Except that we may still need idle page tracking in this case if above (2)
will not be accepted upstream.. so either we may want to conditionally
enable idle page tracking with a CONFIG_ option (so distro can opt-in
enabling idle page tracking together with MGLRU), or somehow allow MGLRU to
work properly with this specific process knowing it may use idle page
tracking.

-- 
Peter Xu


