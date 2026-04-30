Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E020FCCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 11:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF186B0088; Thu, 30 Apr 2026 07:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0276B008A; Thu, 30 Apr 2026 07:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EC9A6B008C; Thu, 30 Apr 2026 07:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5B46B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:58:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1AE211B89DC
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:58:05 +0000 (UTC)
X-FDA: 84715073730.22.00FEFA7
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf29.hostedemail.com (Postfix) with ESMTP id 67ED5120002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:58:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkBRgshz;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777550283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=rueCD1ZsgcCsQQilyqi458mm+zVO0hUPiotgswNp7CE=;
	b=m4hD3QmQzqKUyadpgrppIzL8k2xkWEJCvCIPwr+P435XJtwwiJWFFjg1WL3m2RtK+NC5XG
	BJXb7SlujdqH+CR/M07NFJlSlfPTMac0AkT/8IedjFzAU4wmZ8Rx4tDB7egqgYo9NcsH2g
	LalGQjep9ZcRDM7KMZ3NdLOU3NTqzlc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkBRgshz;
	spf=pass (imf29.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777550283; a=rsa-sha256;
	cv=none;
	b=RFQpM0NhMHeYwrONUPFuqA56zpI0MtnAe0c+6koxf8Gt21kbheYmX984otQNSuR3I8boNb
	3LnOkBICj3/0RBbzFO4hwHIP4JWJH72E068AkaN4gsz/6oFIgbbGeXjhHtXAz8J/oCA/BO
	NTdjznknScVF7u01v8zryzySvbJ5hOw=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35d90833cacso633777a91.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777550282; x=1778155082; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rueCD1ZsgcCsQQilyqi458mm+zVO0hUPiotgswNp7CE=;
        b=lkBRgshz/lQfJw7eZp4hZgmAZ+0PtGU5C9Z5hHUYFhEkacTM5KAsBFxPjFAa1OPYa5
         PN1mB9GD/PgRgskA4a3mUkpeK7F+WlU+28w4wTg+NBy00Cax+qs9JI54qYnkYXNoIQkM
         rjUZ/UJjC2La6qHwLRYTRPSBweyjiaK0t9vtMiRzVcQG/NjBpjG5iuo2/dl4O4XwRCfd
         OLTWlp78JLWPXse1QCiC+CHSXXxhi111Vt+GwKNJP3VdL7MJIe75ztFCn+crRk6TT3/q
         VzHXXFekaPmymSrG4PEA1qAU4PKRgleP8QnA6uCENKzhtLpkm1EOI07rbEC5JjCmVDmB
         4tEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777550282; x=1778155082;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rueCD1ZsgcCsQQilyqi458mm+zVO0hUPiotgswNp7CE=;
        b=eyflwzoZ2vrv6G9b4k6ZjztdzEdULG6a7h+fj8Dtw26dXUXpKDb/QOj8QYLVz74W2+
         WZEm2VuWx0i2YaFd26fNTmwhsnKCsLD6/nkv1j85QBNwulxgEFN3gYDaGd70Q0hRDJGP
         zQUZaEhw131ZDaGXqWWY+Y1nvVm2GVqz2hlymdJ1I+0e5CsQD7vvO5t9zGkZuXF6bSv+
         0B/2SZQb1sJiVvYPUdEbgFuL/6TesMkf1Mv0j+bH/D2NWqZjhT9G2hMFC53/S+49MPct
         E+6efA1uXIml6S+2lsI/aR6aManb9Q2A4Nanj2ysILISAWqou5c7FxNFiLibPTBuwbxu
         1IZg==
X-Forwarded-Encrypted: i=1; AFNElJ/mkNLGGbDpq6hoG3qVttuovOjYgNDSccVoA3jJuWv1yR0xB7K6JzAUHCmZLhH0So7GxRgoxrnxRA==@kvack.org
X-Gm-Message-State: AOJu0Yz6s6BnXhR0Wi+vkZZxzjbcJz9EDh1x4R0SKz9oWrKNA59i/gt/
	L8Jnjs7TumI5HFUTzWp29sxDJO7Ex8WPXWV40wc82vDSI6h5CWpGCf2u
X-Gm-Gg: AeBDieup+sK3dD+aRIVUZZ+IKYCIr6V6aSA+wXOcZ20mL8KikNlQGyNHGDG1T7SZBtG
	wGvre/7MpwFnlU9zOjTrMbBWjcooZnoDwDXtnNdFtPm3siGALrCEohzz6CYwdkuMffgi72kA8fD
	6BAyJbyusXMxYD1KGWK44f5+mc/8IHzIitwmekgxdPVd5uvh+785HGysJwHFAcr/aVQNTQpB6+P
	4vAbhOrV27EyWX5ZG0a4QmDN9fcrCpMgHZpc/K/QYbXj+/6+zlfzQSyOs32vuU9i2b6mKSX8LVj
	Yeg1nMmJ5A5vmtjSjWfx1lTT8g+U7QlbI2CN/ti1F7xyLYSuoxRuiPFSM7j2z4YgU+z4HuBohqi
	IAYrC3i10o+swoA8O1mX+cE1C0ENgZYEZUsvKpBVs2Zer35Yon0TPi/IAi1S9EPoYpuO0DzbFas
	gJYqYpKrMOe/VNJawDfAtV1NbmHHNqIO4m
X-Received: by 2002:a17:90b:17cc:b0:364:919c:b52f with SMTP id 98e67ed59e1d1-364c30ff32fmr2632823a91.24.1777550282152;
        Thu, 30 Apr 2026 04:58:02 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364bdf2aa41sm3638926a91.4.2026.04.30.04.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 04:58:01 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, lsf-pc <lsf-pc@lists.linux-foundation.org>, Gregory Price <gourry@gourry.net>, Bharata B Rao <bharata@amd.com>, Donet Tom <donettom@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>, Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: [LSF/MM/BPF BoF Session] Numa-Aware Placement for Page Cache Pages
Date: Thu, 30 Apr 2026 17:03:37 +0530
Message-ID: <h5ossmwe.ritesh.list@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67ED5120002
X-Rspam-User: 
X-Stat-Signature: pokyuqj8mzm5fjsgg95bd9k5nuacbx5x
X-HE-Tag: 1777550283-941472
X-HE-Meta: U2FsdGVkX18tAtFFPJi6TUl1StFgDTsaGlKVaxERkZTfUUDoX9BT1xCzmblLRyNwPEwJ/dPWbOnKBu9tGcaCPn1TU9CXcZAZ5KY52uo9EsF1KXx14DV/x5zJ6iJ9sHJuadCh69QtTV7Cwf1M8KJUtK6WjraP0VQvmJDZOuGcaF3nSqG8ibpjc9eCG/ZkBcTqknZAuTPeXs778YOGeT0ec7rezU4nAOkVQrd+ZgP+xy2O/LaIZ9RhpwURILDJeO4dHUn/gQw2tn/TDHnZ0iggpglkL1jTli9+r9S5RImgOReTQDtWXgTPTaU5xeG2ckHdl68NRT/Ioed4zKYgCbqCV49yO5Mk6HT6TnZGryoyff0JHATFYfxL2E8hkTybD8n5pg0mJwczk3EJ0vvWhad1dT+leJAT/s3kXG6zFtQyAJNBdbveLPhDLiArbcazSY9FLVkz44xDqVkTo4CSB8zVvYue+4OZGELAjZTaslTvhr07yiS2RQpM68UVR4a/S3LeykmTy323pyykbDFQV4jjOjyVXdzG8kAszTD+FNnK93wual7qXoBwFiQ6FGXyKxUAPUCIVxxntNGgHxsukN6O6P4wFZDFnfwIa/isYPfjTze79ZLZhiyFxcWXb3FlWXU+fr15A2AOck3w+/CuWuIrrwcSytITwOBn/KISYDv7m8Z7IZ04ml0Hd/q95P8bHYNsfzogzgSPJSzJ/iWrEWoZKMym0RJzoh774agXSJUvKa4CgV75nOB8W6FsXQY1u8v1pJgEqWX0bk+LrBw2Ejwz6vfdKGITRL+TWlHfxCCwrQzSPK9AvnYZ8MvDwpMv4Tfrfo7ttxYS81Na2Bx9Gyl3UcM4/k2ZL1yQ43eGKQaEiHLh30n/VpHVGNvUUFEajLQpgiOqa1CewxduOfnTDhycbMOFIgKfHla/XXepb+wHcXt6MPT2SSwptv/hWBHTcUZOLDHvXdBPd5xx/IA4WyR
 Y/t4a+h7
 pr1Rx2NrCN/X8GyZs5ys3jTrOvoa69TTHZ0ajbNkAhuLba6O+oF68iqYJa6yTAvBfc1OM9hjZ/J/atzP1MjUlNRchS8encrLModTCO/r2F1MevQDgTc4b2+S82ES6Q0D5RcZpLir+XlGWNigxoCK0fQjdbuAzhG3ZSjLwZ2wCCuSv1g80V9erkAxQAXoK5aURRnwlvGcfH6ZgKRyAfu1Aiqivy0mhtiKw34ZM78RhkfU1dlrkAy4kCTUNvDCPdRe3LoBDhbS51X7R3UWPWyzDPWkMb66WSUJd6LHnKDN7AHCQWOUJwy6U822TMHj1y334mnI/kHzwMfeQCCajcirwuGTvgNR7scWRQs9CKA2b2NJHk7mMOYNOXq9sUC3cH1UxeR/e5/SsQdCKtxW65bwIlYmCG3IpFhFe45Fl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi All,

Amir insisted for this :)
> IOW, bring the Hallway session into the room, so that other people
> can participate and we can use the hallway time for gossip and
> stuffing our faces.

So, since we might have few slots available in FS breakout sessions -
here is something that I was hoping to have a discussion with you all
in hallway. However, I thought maybe it will be a good idea to initiate
this thread here, to see what do you think about this.


Linux already supports memory tiers and there are ongoing discussions around
promotion of unmapped page cache pages, which lets kernel do the right thing
for userspace page cache pages on a tiered system.

v6.17 added support for per-node global reclaim via
/sys/devices/system/node/nodeX/reclaim, which lets users perform per-node
reclaim of page cache pages. We also already have interfaces that let userspace
define the lifetime of page cache pages, such as RWF_DONTCACHE and
FADV_DONTNEED. These are increasingly useful because locally-attached DRAM is
a costly resource and we don't want unwanted page cache pollution there.
Userspace, sometimes is in a better position than the kernel to know the
workload's access pattern and whether it makes sense to drop page cache pages
once the I/O is done.

So the question is:
Do we need a userspace interface for the placement policy of page cache pages on a per file basis?

Note that we do have per-task placement policies like set_mempolicy(), but those
are too coarse and don't help if userspace wants per-fd control. mmap+mbind()
doesn't reach unmapped page cache. shared_policy per-inode works for
shmem/guest_memfd but not for other filesystems (I think so, but I maybe
wrong).

So what I would like to discuss with others is:

1. Is there a need for an interface that allows userspace to do per-fd page
   placement and maybe per-fd page migration?
2. Are there applications that need such an interface or would they benefit
   from it?
3. Even if applications may not need this today, should kernel developers start
   thinking about it now, before users start abusing some not-well-defined
   existing interface. e.g. the story of echo 1 > /proc/sys/vm/drop_caches,
   which became a production workload tool despite never being intended as
   one?

Let me know if people think that this discussion qualifies for a BoF discussion at LSFMM?
Or do you think it's a bad idea altogether, if that is the case - Then
please help me understand, why so?
Before starting to jump on the implemention of any of this - I would
like to gather feedback on what do others think?

-ritesh

