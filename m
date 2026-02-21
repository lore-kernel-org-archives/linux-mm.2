Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6411EC61DE2
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 12:40:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272B36B0005; Sat, 21 Feb 2026 07:40:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FEF6B0089; Sat, 21 Feb 2026 07:40:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 101B36B008A; Sat, 21 Feb 2026 07:40:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED5F56B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 07:40:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F0601604DB
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 12:40:42 +0000 (UTC)
X-FDA: 84468422724.03.5CF9A1A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2CA7120003
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 12:40:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jrOe8ov3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D7VDnLHe;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jrOe8ov3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D7VDnLHe;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771677640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4DZA0cZrsuyUDUuxvrOVRkY0/iTG4B7ICkpMg3aNYg=;
	b=jq9WwD3Yp/c2MvVvM7jRBFIltQOZhFW+Eb2EHE+ZnAKzIhtqx31jtU8MAvwahWH6JmY/va
	rfvQb3BLB73mW1SHIiG9CgXPVoBUsJ7IIUOxTnvWUSrBXsWmTIwBQcFRt3dkbK9EOG36Ex
	fuXjG1YzE/KnI7jkJcyfi5uwI5oCBg4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jrOe8ov3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D7VDnLHe;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jrOe8ov3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D7VDnLHe;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771677640; a=rsa-sha256;
	cv=none;
	b=Xw8zFsQ24KF3lpmq04M+esy/i0x8m23yc2BG6/lbfAOC3OmfVa/PSeMdX4pKX4W5rMgyU4
	B366RkEDIQJaWx5buETMNRcm9d1NEV3CFdqT0ufFvqpnU2HEn8//mkaxYP4EA1MpRzVfRt
	1Xv3JwS7ovlwhc0j4ZwvAk+33g0scis=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3050D5BD3F;
	Sat, 21 Feb 2026 12:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771677638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J4DZA0cZrsuyUDUuxvrOVRkY0/iTG4B7ICkpMg3aNYg=;
	b=jrOe8ov37EkB2K7QUZplzqcG8pi2oFUc+DYcV5zsv+Xkl2edFU7SkkkDGLgvMAToMW3SH+
	7vcbBFZPYExHZI69VAyShBS8Kf24Z/6Uwf6v9iLGPtjZgGs/zDZwO/LnTT8vH6pcMKKtYb
	gXOA/9laRLea0QhjV9HmHcNE5tn711c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771677638;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J4DZA0cZrsuyUDUuxvrOVRkY0/iTG4B7ICkpMg3aNYg=;
	b=D7VDnLHe6UuPsUfysJ7Ghv4MGZ8WJ9s9uJwsuA4Dj32i9htGLmbvxBcMAHDU3/gQvETS2l
	ItKxEdXlWgd7+CCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771677638; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J4DZA0cZrsuyUDUuxvrOVRkY0/iTG4B7ICkpMg3aNYg=;
	b=jrOe8ov37EkB2K7QUZplzqcG8pi2oFUc+DYcV5zsv+Xkl2edFU7SkkkDGLgvMAToMW3SH+
	7vcbBFZPYExHZI69VAyShBS8Kf24Z/6Uwf6v9iLGPtjZgGs/zDZwO/LnTT8vH6pcMKKtYb
	gXOA/9laRLea0QhjV9HmHcNE5tn711c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771677638;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J4DZA0cZrsuyUDUuxvrOVRkY0/iTG4B7ICkpMg3aNYg=;
	b=D7VDnLHe6UuPsUfysJ7Ghv4MGZ8WJ9s9uJwsuA4Dj32i9htGLmbvxBcMAHDU3/gQvETS2l
	ItKxEdXlWgd7+CCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 155683EA63;
	Sat, 21 Feb 2026 12:40:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Jg9uAcOnmWm7UAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sat, 21 Feb 2026 12:40:35 +0000
Date: Sat, 21 Feb 2026 12:40:33 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de, bp@alien8.de, 
	brauner@kernel.org, bsegall@google.com, corbet@lwn.net, dave.hansen@linux.intel.com, 
	david@redhat.com, dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com, 
	jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com, khalid@kernel.org, 
	liam.howlett@oracle.com, linyongting@bytedance.com, lorenzo.stoakes@oracle.com, 
	luto@kernel.org, markhemm@googlemail.com, maz@kernel.org, mhiramat@kernel.org, 
	mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, muchun.song@linux.dev, 
	neilb@suse.de, osalvador@suse.de, pcc@google.com, peterz@infradead.org, 
	rostedt@goodmis.org, rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com, 
	tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com, 
	willy@infradead.org, x86@kernel.org, xhao@linux.alibaba.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
Message-ID: <fqabaahjjlmoc2xh4cwh4ykbqyu3rnzvjw5epxi5wwpmgqth7f@d3mqpjozwmo4>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <CAC_TJvcaJdEzK8n9BK0qgEXdzjzXtbA_Zk-ybfmG8kjNExVCzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC_TJvcaJdEzK8n9BK0qgEXdzjzXtbA_Zk-ybfmG8kjNExVCzw@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CA7120003
X-Stat-Signature: ch1u8nkqudkusybgztg1w6zwt9q53bws
X-Rspam-User: 
X-HE-Tag: 1771677639-304943
X-HE-Meta: U2FsdGVkX1+MS4BfT0vU1uz1f7ltVDVT5wPw/OODfHBjZXTSTYANktOLb+8SvlACVpEwjCk6+j7DXtl7jkKrTVTL6dak4h79wfahT78Cex20H1OfI80xGsuLMSaWu5dJE12nCBEKHrlfJ1vy24wan0zp3gKDpSkK9LdeVtfRut9g7QqMQWOxACi8oH8fgO+nL4W7GF6PGWFW05lZkovXD4CpJZLBk7dMKSKP08EiEQGMG0NadUpRlkl1zoagbPQTV5dg8as3hP5wkF/BqQFo+tdUNgbF88FJdr20D/K/PqPmd2kG3Q7xP2nLLC1VIDONHDG6YUBlAn7mC5G8gInM30hnUa9FX2B6RPfLbTWpgLk/TbXnq7MnFbV8uigHk9ZnQ8IyDKOI2XCJhIrg094OBTluu5VFC49vUkKYBdcU1u0df6J1oJkkiC/Lc2XY4Cqx/CbN50oAr51FNTCBMzsjzJO0ckPihA7MM9ijncPgOtYBtTok2oMWJSF/xYkxA91uga6ErDNSJz6R1jwOeWc4aATw/LzZXFfE3tJ17EUcFtLXLFqnwptTypSx1JfzK05UtSBiZRCPSARi56O+4kj2d18mIFCYchfJSeNgdZPF9WmGpq0hdYcfY6zp+XEKprrJphVvIGPYFIxyVFUJmSQPb1B5ePy2YBKT6mVNUPyq26Y8+8G1VOhFu4eQJ3EO4Oxm2Z9YZj0u9vZg7Kfz/bAEolA8F2cOkFYXHxfFpMaFXv07/88fSqL2CDRAQKYLxtQn9/uaYHW7OKkPMw2xdwjvkKbdD6QiS9ExHnC4G51KyGc8ygk6lYN/P7ZhFoCeGRf13Pceb5PWZKiEAdIUlf7rvccI1uw/JPWxVEppq/+yIV9hPS29vtdZvysv2KeJNS//ItZmYkqkqsHSNSQtqoxLyfqOePsZlBC5Zmsz5/GVouTRVB14HHrkxmNUyPQLNWfnQi3IIszq4mX7iLAKDOu
 zjrzUB5H
 r1dULpCQAv9jV+qwnaAVZ5dUBArlj6koVk2G/MjPuo+TMsYqWO5Tk53Q8XAd9d9bYkTpiChBscXA9c0bpKC4E6n0DPOpAjdiT3gCJ5AYFu+EzL89YjQ2cjsvWCLbn9WKsKFSsGS9RU61aUolcLb3Gy9B56ZskmsjPJv819LqapHcu5tBqdovma2T+YYWrUC/66TsxhDcgwocKTtWoR3iDeOn7aveGOUM6ddtrzJZ1uGIvfVpg+aZRR9hk7w5jAgD596+ZA7CdCn0pZYwU3/ly34kMdtPyXPikoYwSCbpdlXfxEaIunBPaeJYhrDe3Jiie7inzfJ1FL1bPsowmfqOBGxQHQeRZjyDXOLmL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 01:35:58PM -0800, Kalesh Singh wrote:
> On Tue, Aug 19, 2025 at 6:57 PM Anthony Yznaga
> <anthony.yznaga@oracle.com> wrote:
> >
> > Memory pages shared between processes require page table entries
> > (PTEs) for each process. Each of these PTEs consume some of
> > the memory and as long as the number of mappings being maintained
> > is small enough, this space consumed by page tables is not
> > objectionable. When very few memory pages are shared between
> > processes, the number of PTEs to maintain is mostly constrained by
> > the number of pages of memory on the system. As the number of shared
> > pages and the number of times pages are shared goes up, amount of
> > memory consumed by page tables starts to become significant. This
> > issue does not apply to threads. Any number of threads can share the
> > same pages inside a process while sharing the same PTEs. Extending
> > this same model to sharing pages across processes can eliminate this
> > issue for sharing across processes as well.
> >
> > <snip> 
> Hi Anthony,
> 
> Thanks for continuing to push this forward, and apologies for joining
> this discussion late. I am likely missing some context from the
> various previous iterations of this feature, but I'd like to throw
> another use case into the mix to be considered around the design of
> the sharing API.
> 
> We are exploring a similar optimization for Android to reduce page
> table overhead. In Android, we preload many ELF mappings in the Zygote
> process to help application launch times. Since the Zygote model is
> fork-but-no-exec, all applications inherit these mappings, which can
> result in upwards of 200 MB of redundant page table overhead per
> device.

This can be solved by simply not using the Zygote model :p Or perhaps
MADV_DONTNEED/straight up unmapping libraries you don't need in the child's
side.

> 
> I believe that managing a pseudo-filesystem (msharefs) and mapping via
> ioctl during process creation could introduce overhead that impacts
> app startup latency. Ideally, child apps shouldn't be aware of this
> sharing or need to manage the pseudo-filesystem on their end. To
> achieve this "transparent" sharing, I would prefer Khalid's previous
> API from his 2022 RFC [1]. By attaching the shared mm directly to the
> file's address_space and exposing a MAP_SHARED_PT flag, child apps
> could transparently inherit the shared page tables during fork().

So, we've discussed this before. I initially liked this idea a lot more.
However, there are a couple of problems here:

1) mshare (as in the mshare feature) isn't really aiming for transparent here.
There is e.g a specific need to setup an mshare region, with a few files/anon
there, and then later mprotect/munmap parts of the region - and have it apply
on every process that has it mapped. This is why we're aiming for different
system calls (not ioctls anymore), doing munmap(mshare_reg, 4096) is ambiguous
as to whether you want to unmap the mshare VMA, or a VMA inside the mshare mm.

2) Sharing the page table at all (even worse so, Transparently(tm)) is a huge
pain. TLB shootdown becomes much harder, and rmap as-is isn't suited to deal
with this case. The way things are going with mshare, the container mm will
have one single entry in rmap, and then actually doing the shootdown is a
huuuuge pain (which, fwiw, will probably need a per-mshare TLB workaround),
because you need to find out and shoot down _every_ mm that has these tables
mapped. And then, naturally, since you're sharing page tables, doing A/D bit
collection on these becomes extremely useless - and that will naturally pose
problems to the reclaim process if you abuse it.

3) other misc problems that make it hard to work transparently (VMA alignment,
levels which you may or may not want to share, you need to revisit most page
table walkers in the kernel to get a completely transparent feature, etc)

> 
> Regarding David's and Matthew's discussion on VMA-modifying functions,
> I would lean towards the standard VMA manipulating APIs should be
> preferred over custom ioctls to preserve transparency for user-space.
> Perhaps whether or not these modifications persist across all sharing
> processes needs to be configurable? It seems that for database
> workloads, having the updates reflected everywhere would be the
> desired behavior. In the use case described for Android, we don't want
> apps to be able to modify these shared ELF mappings. To handle this,
> it's likely we would do something like mseal() the VMAs in the dynamic
> loader before forking.

mshare_mseal!

> 
> Perhaps we could decouple the core sharing logic from the sharing API
> itself? Since the sharing interface seems one of  the main areas where
> we don't have a good consensus yet, perhaps we could land the core
> sharing logic first. Keeping the core infrastructure generic would

I think the core infrastructure is relatively generic (at least the
small core mm modifications to get this to even work) already, but
perhaps Anthony can comment on that.

-- 
Pedro

