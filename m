Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4687CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 20:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3356B008C; Thu, 15 Oct 2026 16:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA4266B0092; Thu, 15 Oct 2026 16:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A953F6B0095; Thu, 15 Oct 2026 16:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 742E56B008C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:39:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 744981A0175
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:38:58 +0000 (UTC)
X-FDA: 85326024756.19.80CA115
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id A1F284000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:38:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ee6EqKJD;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792096736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTVoFwqUnsU0sdHOYobwPK++xcK+Lshjclao26R+uqM=;
	b=S8hghC1nnpvbi4J1KBGx/gtzNhuE/6bkqJW7bA3bMfNQxL4jBb6ki81uBdOVn/qpgtlLw/
	3ZgRfRvdEawtVSbFBlHIuXKQ1CyY9Zt9juRX6BrBVuxqy0rTxwg+d06u3nP82q0pLjpQ2c
	uq1v/mTs6RM3HMui17DH6cueIHokaeY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792096736;
	b=JEsl6hhTWEIQM4VDG2EJ5T5I3adVFG0cBecTwJiou/UtoR3dwDOpyyDX1rlZhK1Q/53Vx6
	56FdsPtV2auiSUmXaxe8/mlBAtB33h8HyM1z1EOUvvAgC9RDggb27xXYMFs62yMC0qoh/p
	OGKY7hnp7ZF+GTKV8y9lb3raBiiivas=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ee6EqKJD;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-9906034086cso816624241.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 13:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792096736; x=1792701536; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RTVoFwqUnsU0sdHOYobwPK++xcK+Lshjclao26R+uqM=;
        b=ee6EqKJDptFOVMDQQXigZHVIujjkRqC4+Gag13wp71oywYmwV+0hEyaRO7yAUHnEQM
         m5+5yFqUu0+iuYVtN8P0VcBlKVyfE17cmzAlHEErnP0Xq80nz8H2AZwXqOkRxBDDZPWU
         hsWXcu818zK8PiA9thsBpg2CN+9pk88SDFCo8+br5J5wA8Y9ANemxP9gBJCli9tKEOPE
         s2EGyf7/thQ+ZU5Ec7M/r4Rlg1iClY49i8MFqgZDTWE7Cf8nacmHlsehLDwkaDemWsUm
         BxVZCfbk/hNsUFgz0mSm4JDbam7FFb58Azm3VysHFE4u+KfbNLe2eycxA+Z44ic1Nh/j
         oiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792096736; x=1792701536;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RTVoFwqUnsU0sdHOYobwPK++xcK+Lshjclao26R+uqM=;
        b=OmjNY4/8jC50nic/UYZ8C6oA3MvgPb720RXeueuVeXAEuDLE8qJ/h00dAloeTyWAvi
         5C/zzMjuIc1FoOy4wDFg8tJmjVyLmo3b7rI/QQKuAeCq7FqkCrdbk0/Rhp7WfmSFbVY1
         YGmEUYNBY0UOcJ88RNEchuNk9wNX3heHlsQvG9P15ElG7EEohOeszNQlKqmYQrib+8Ms
         80e2W0WbpVMQ3sQXwZ1Qmy8RkDy7J7LUdTQNjp/9/dzCZ5TPZTq1lI+AyR9DXMYwZod7
         HU7NWymSYkKtlK3tnEgNAQzSiDKCPU9Ca586RWSWcqGT0HfQbYATimRoxJEZXwSdCkiq
         psFQ==
X-Forwarded-Encrypted: i=1; AKwUvBwWKOL5ww+QMGQgc8QbWpPFbpH0eY3UA7nxo5F78qRFPbo4XLLKgxnS03nMFPz9cir0bE5mB8wQXA==@kvack.org
X-Gm-Message-State: AFq9FYKS4D2lzPb3hLFOMvWwW7yvCXv1RmtrrrdA4jwaEGHD6kdR9eEP
	wKjbrEOQdFvU14LnePbKRbkFJVwaZC5ACVuiAmu/P7TkZ/5QVW8o1oW6E2zpCTEuCuU=
X-Gm-Gg: AYBFou1DzjGVXmon7eN6SNvVD6TeCPSOjvezC2GYCQWYsDoXAUcCg2Mo/pN/hAdHvq+
	mOc+hz2568QM3JUzpOkzffpUHMgIpz5Zj1bCrJrt7I5zWOCiQVqfvLHgflSv0xhsNmwoI62qrPO
	w9vh0HqnzgNU8NSt0+sdatQI7Yz7VkxYrmZLyBlqjhf/ukzEDeA86eyki0qst0qyDPvou5R0fVQ
	cHDoSok4hRXrgLak8rFi/UT/YnnNPY5YPT4awJaGQcTx4Pl6KP2kJjcRkn5ysxoTu5tGIt+euOG
	lezGN71ysuO66p/LRCp8hqoxLdT+jzIIdfM4qFaK7CMoL+lBheHdnv4Wn+RHh8NZUINySC3HubD
	gyqsdz1lMWvwy/DTCHvO2F6ssHXv90UpeFmlMmqP09qIPPiAgjX7WkKJcJsx9p8C6CXyvtMW7Lb
	WMQxuuTmdb1Tm21zA8utnetA6AHC6gKhWD1oaaZxNlyO5SRvmzTrQ/NdLrMUFG156ud8I3Vy7EV
	7FYGlkNiyWSHUmPI8ZCZcUxL3A7VbjeGgXZI2UJllhivp9z1VZK+JSNuSJouKF+/T91FsMF4Q0=
X-Received: by 2002:a05:6102:a49:b0:7c3:83a9:edca with SMTP id ada2fe7eead31-7cb36886005mr5673629137.3.1792096735597;
        Thu, 15 Oct 2026 13:38:55 -0700 (PDT)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b4ae2e2sm114784e0c.7.2026.10.15.13.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 13:38:55 -0700 (PDT)
Date: Thu, 15 Oct 2026 16:38:54 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org, vipinsh@google.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	pratyush@kernel.org, graf@amazon.com
Subject: Re: [PATCH v1 0/7] liveupdate: tmpfs preservation and early freeze
Message-ID: <atE53vmlDeA4cWD2@google.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
 <atESAwf17pJ11S9U@google.com>
 <atEaPuWNOm5VLc7A@google.com>
 <atEhc20Zawj4D62x@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atEhc20Zawj4D62x@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A1F284000B
X-Stat-Signature: kfxqprt3fmz6bozckasw348ipyeeed6r
X-HE-Tag: 1792096736-279383
X-HE-Meta: U2FsdGVkX1876sePAr+5aVzXkyivQoiT66y+P7N0eAe+RDLDhN8SRkSL1qSGOy2SNSgKmOHnSLTOfDHoSdgxdjI9IaRfJOQU5/Ki/OklxFWKvuUdDJ14W8RSWsTwfincVAvgLRPvM7U+etnXezn+s9LGvr3LG4Cb3MiO29zXYe1Fn8O/uekAiw2NqMQEHAyukMJ7U22DVW3S6nZHmRZijYYSN7p5OBXAu/DfP3oNC4SD2Qzfb76+PcvECaUqU4jV9n2Iux92Mg0EYISZFL+XV0jnI8PdbK8uf63qXDUAK7H3Hh4x04EwGehzYR6rE2xTwTXXHUGyF2/WJ22bQZl0HcYc1L/HJhmCk+9cr1Ji11RdOgU2iUb+IZ9fUgofsF/fpFLImeVWswYXMpjwtpyGz8cTcO9BYB/dv+H/uOoQyn7YrqSE/XPr2WibeaCtQbR/iKnYg81jG9eEKIc2UdZYcK4HQTBtO+85CqpB0dfSbV1qIXAJWG7hJD3Ii/1MQHtSt3uap7XHtH42sw9NNgb8fRhrMdUiL898jVLCj1O9jFVBZNE6UtfUOFBJFkuS4ZYqps0WvqFtwwXQcBILhN07U0/N1VexUvC/VN9SOesUem3WkmSMQIV5L3x1zLcfh2auvR7YHPGJS/Vmx/ftG6r6XpndL6kzSn2XkBhZE5K3kNu7xEy0CUhOI/blMyumkIMrV+BB9ATdqOn9HAQseiX5pKkGdjtmE9UVHoQ55zz7+74nuiDaqKsVmtclWa18MzXtJzBxkd7I96dim2fFRSYjVdgYhwK/FSwpjOba6hSlATt0SL+6SJGLx50Wl+g4uKUzf9WcKwjoUHmE1U9kut8icQiNACnF3rE6wBu92Z/69czOhWVv3IbAjU2xf8IGkXE+tvKz18yHPDmrRzz3rjKttXtMUO7xl6aMcE5OFU05rq2+jlkQMQtQGhz3miZMPORgebtwGPOd+1WvltqHZ37
 e6gergZP
 Whgf18MzHgazDRTKge7WkmluDXa2fhI/9pw45QTXRyiUcOOhfic5fcXgWeQWCZ8ds1jZosI2ZoDbRcjNUDztR4iaAraBQKz6he57jUiYfcCMZgEU5o48lQGPk8xzLh96EZgLBYa6Imr67r/f/A/dvgw4unuNq2EoHlWqXu9ly77FkbnkhY0A55P2x79G/ZtFXzbZDHkvWixXN4xcIr2bHNkQQMOoJtfCgkuyTjmXjuW9eeYeh0b6HaD6n/59MxI8IVoBbXNYlAZLKljgoyuExR5WsIEbgDfltou565w2W/j1z4m3sTXAqes38r2JdWBbo6Biyh4yqueYxpkCOOC5gosm3rvX5rBc4ca/ockOMjY+KR+tMKwyXhRcdW+LKBru0xDOJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > >  - memfd_pin_folios() doesn't require the inode lock, so iommufd can
> > >    pin folios of the target while they're being added or truncated
> > >    away. v1 starts with two patches that make iommufd take the lock
> > >    and make memfd_pin_folios() assert it.
> > 
> > Hm, isn't this mostly orthogonal to the change we're making here?
> 
> Kind of. Today .retrieve() fills a brand-new memfd that nobody else can
> reach until the ioctl returns. Retrieve-into fills a file that other
> processes can already open by path and pass to iommufd, so pinning can
> now race with the folios being added, or truncated away on failure.
> 
> In the failure case a folio can stay pinned (and mapped for DMA) after
> it's been removed from the file. Retrieve-into introduces the race, and
> the fix is two small prep patches.



> > We originally agreed that if retrieve() fails, we fail permanently and
> > leak resources until reboot to avoid memory corruption from ongoing DMA
> > activity. However, now that we have the retryable option, we can start
> > relaxing what is considered a permanent failure vs. a recoverable/early
> > failure that .finish() can clean up.
> 
> Ok I think we are ligned that we need to keep the preserved folios
> around until finish(). I think this point was saying there are bugs in
> the existing memfd_luo code and in this series that leak the folios even
> after finish(). Either way I'll fix them up.

I think we are solving this problem incorrectly, LUO should still always
re-create files, even the tmpfs files.

What if instead of retrieve-into an existing file FD, userspace passes
a dir_fd on the target tmpfs mount where the file should be restored?

During preserve we can record the file's basename if the file was linked
(or mark that it was unlinked). On retrieve, creates a brand-new file in
dir_fd (e.g. starts as an unlinked O_TMPFILE on that tmpfs superblock),
populates all the folios and metadata while the file is still unreachable
by anyone else, links it into dir_fd under the preserved name at the end
(or leaves it unlinked if the original file was unlinked), and returns
the FD of the new file to userspace.

That way:
1. Just like memfd today, .retrieve() always populates a brand-new
   file that no other process can open by path or pass to iommufd until
   retrieve succeeds, so the memfd_pin_folios() / truncate race goes
   away completely.
2. Userspace gets back a single new FD from RETRIEVE_FD instead of
   ending up with two FDs (the pre-created one and the retrieved one)
   referencing the same struct file.
3. Unlinked tmpfs files are also supported on the target tmpfs mount
   (preserving mount options and size/inode accounting) instead of
   silently falling back to the internal shm_mnt.

We can even postpone linking the file into dir_fd until finish(), so
that it only appears in the filesystem once it is fully populated.

Actually, I think, this is the right way to do tmpfs preservation,
instead of relying on user to provide the FD of an open file to us.

> > I do not want LUO to change the type of a preserved file across live
> > update. Take seals, for example: a memfd can be sealed with the
> > guarantee that it will never be modified, whereas a regular tmpfs file
> > does not support sealing. Allowing a preserved memfd to be retrieved
> > into a tmpfs file would create a loophole to strip seals (or bypass
> > mount/superblock boundaries). I strongly prefer keeping the file type
> > strictly the same across preserve and retrieve.
> 
> I agree that seals must not be strippable. I am not proposing to allow
> that. Regular tmpfs files are created with F_SEAL_SEAL, and v1 refuses
> to retrieve into a target that has F_SEAL_SEAL if the preserved file has
> any seals the target doesn't have. So a sealed memfd can only be
> retrieved into a memfd that allows sealing, and gets its seals back
> there the same way F_ADD_SEALS would add them. Only unsealed memfds can
> be retrieved into regular tmpfs files.
> 
> On mount boundaries, retrieving into a tmpfs file charges the blocks
> to that mount, so its size limit and quota apply. That's stricter than
> the unlimited internal shm mount that memfds live on, not looser.
> 
> This is what I mean about enforcing the fundamental requirements, rather
> than enforcing something artifical like MEMFD_LUO_FLAG_TMPFS.
> 
> BTW, MEMFD_LUO_FLAG_TMPFS is set based on i_nlink, so it doesn't really
> track the file type. An O_TMPFILE or unlinked tmpfs file gets preserved
> without the flag and comes back as an anonymous memfd on the internal
> shm mount. That changes its type and drops its mount's size limit and
> quota, which is the boundary crossing you're worried about.
> 
> If you still want the type to stay the same, we can define it by
> superblock instead of i_nlink:
> 
>  - memfds (on the internal shm mount): plain retrieve only, as today.
>  - files on a tmpfs mount, linked or not: retrieve-into only, into any
>    empty tmpfs file, including O_TMPFILE files.

I would like file type to stay exactly the same, I really don't want to 
play the game where LUO can magically change file from one type to 
another even if from Linux internal implementation they share a lot of 
code, they are still a different file types from the user perspective.

