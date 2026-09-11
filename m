Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58979C88E58
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 18:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 377E36B0096; Fri, 11 Sep 2026 14:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328B66B0098; Fri, 11 Sep 2026 14:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E286B0099; Fri, 11 Sep 2026 14:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF71A6B0096
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:15:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51725C02E7
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:15:46 +0000 (UTC)
X-FDA: 85202284692.27.BBDFD21
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7ED8780008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:15:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ay6N/5OR";
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789150544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoB/yhujSeic4Z83ePKaRXKf1DWcrbuqnOKvr88NN90=;
	b=VChSP0kTsw9QIvw9Peh8tCcj4/jj+usYw4ZSk2rWUaq8LVGFQetTcndmZCxsL6sAOaPI+Y
	jt8wyUY6qnGmpcsROxC+in6SJXnaeIBqG7xWuxbEZX5o+r1r0hEdkXX29IgCxyyBcgpsco
	sv2bXtNbBbKd8ThKPnQMPmlc/T8xu1I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ay6N/5OR";
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789150544;
	b=8hLDqe8voC6nztB7VqH//J7mernhAjbCEUtY5vZLHxR9jN1i5zFhvSs6S8+SqHqyvQ0QkR
	dPrNDEB5d+OSR/8QgkT5UxZ6Xcw7bv/+fkJBag7vHC/zk2cXUx5ELv0nbjfTsp278QgrtS
	1NVYbdaKYNAP49wP2fUuAq9qw29OQSo=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cc4d64bcea5so344467a12.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:15:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789150543; x=1789755343; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UoB/yhujSeic4Z83ePKaRXKf1DWcrbuqnOKvr88NN90=;
        b=ay6N/5ORuEVJnDaagODEnX9Twv/IyzZlIrJ2wSfrjTJRAW8uQzFkk7J78Trst8x/YD
         WviLodhGU8XqZct4QkbDrigqG/02y4wJOiC2vUitf9Xot1d63hXCe4bZOxS4fKv3w/bs
         lYj1ALfobabQTxH3lGKaQMXtp6Z5HgsPqz/aku+PdPDBPzr8AxTPrd9+qeNyHT6mq/ly
         /7CS5I6xXX/0DrW467FFOPEc56SV8XMQMekmEsBD17SN1HO5jaUMMfYj1XncfijMeuyv
         K26tJBzhvwT3D+8SbjHZJVIFRBMUONAoktt0PB0TXpKCuwz/lByqzerfXbZEoN5xOVHs
         GVyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789150543; x=1789755343;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UoB/yhujSeic4Z83ePKaRXKf1DWcrbuqnOKvr88NN90=;
        b=VN861FIHVOdJSow8c0tLd8LXSAzLovFf59cqqUKTyMXg38GXj69CfUjCEpMXGzztt8
         iFTkeGkyUA9fANsoDTUVNNZwSp4sVruI+fMJdQrqjztAdV5O1TQjW3zFkZpVH3pCqetI
         4IJBnhsT7WFli4ZIenOTEL97UgAnkpXTvJocPb1JfApeBvxA/q083i2ELMqogzyhm9AA
         JYvAWrIXh0TUWvuMpc/5addTxXSTlDPCVOYdo9fF9tpKHMX/DEbgu1JISqn0xI/E9T3i
         SZvzRULVW8dNP9u1qTRCNMr5tVnd8InnqJi+weuMFrwg0H/8Cc9sq4mpJX27xk1L99sT
         Mg8Q==
X-Forwarded-Encrypted: i=1; AKwUvBxRG8fgcxXt5nkq1jU8YBEmpdpny28rQL1v1gEgtQd5+b4JT/zNKKYZSC44rS23vdeJ05k9wwxSBA==@kvack.org
X-Gm-Message-State: AFuF++ldnv9WydD3jhPH/DsAeLNKWTN1k+Um0ffVu4fboHuFzgUquGsn
	oMB648ktPCd729IIQTHVdO39wMMLiOby8HBA7nHMN/hwp8OVNuytzzzt7VUCGjWZow==
X-Gm-Gg: AYBFou2QgwQCUj5/8K3oRY6y56b16qYMPKMOS7NvdzGKZG1MkJU9Qecvi8Ii0kFmrik
	CzXAJHjxHItAXOkX8Na+oyCM8zJ+CeT2cbQYlY3u3IgZl87M9773Oj8qK6HSCbVlCdHyJtdRudm
	TEHWFEFji3GVX4FvBEFUWWXMhRV6qKeYvzZ2H+WQVt8Exns433CRUmSoLtT3h4ZuhyRS/fsHskG
	gN5iFLW21LAD5lxBNL5rLIlZ9NUL8CpteyjSu8YjYgnZnAM2LwlX1AthNoB/X4k7KNucRw5lG1+
	JD7bnm3bVAlLjStFqQPzQieT+vUe+J3vSUP++nu5Cb0stWqXI06ON+NSu0vPkpMZav/H7TsPd/N
	su5MtfUJIakZz/ZxZX0c5pZTVOFbYx7ZLcGPG4MeSOsjXl37Wtx12JT1Ffra9V0XIM+BozmVrpb
	oJ/Ef2sgqeLptQ4AT+3kXiGesg0IB/KVmVwVuEac3M1utlt1jtC3Z9EhkmBfA143R2KTzXOOaLp
	uqN9vt5FHFdasbPzagis0cGjMKP7KJXaYdA3fP+
X-Received: by 2002:a05:6a20:3ca8:b0:3da:bb98:b1f9 with SMTP id adf61e73a8af0-3daed4bba1dmr10454732637.9.1789150542427;
        Fri, 11 Sep 2026 11:15:42 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6550e06sm1594193a12.14.2026.09.11.11.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 11:15:41 -0700 (PDT)
Date: Fri, 11 Sep 2026 18:15:38 +0000
From: David Matlack <dmatlack@google.com>
To: Ackerley Tng <ackerleytng@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <shuah@kernel.org>
Subject: Re: [RFC PATCH 0/5] liveupdate: LIVEUPDATE_SESSION_RETRIEVE_INTO_FD
Message-ID: <aqRFSiicubfsw3N6@google.com>
References: <20260901180713.4185641-1-dmatlack@google.com>
 <CAEvNRgEs82CVTL_CUn=Ovrwvt86U1dxzr8psWGu=nk98ZH6Esw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEvNRgEs82CVTL_CUn=Ovrwvt86U1dxzr8psWGu=nk98ZH6Esw@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7ED8780008
X-Stat-Signature: pbp7fxdgu6cxraukq9cpxaaybzfbsosg
X-Rspam-User: 
X-HE-Tag: 1789150544-821603
X-HE-Meta: U2FsdGVkX19qcB4vhFVJwieJw6N0eB4Ye1dFlb5P9yDUx3pQEuahgnCabdzL9ggjhjmLB1/9LgNnH+pdCAXhxll6yhX/m/bq76tTJegRxA+448TYM4W01fNBGy47tWK9wM2uhltVxLA6bmXmBNri8NZH3lTwAOvhrAK2cEjs12Iq/5j2/fbIZ5P5vXlBSEGVeEvb958RoYeOmWO8GdcSJ/b/QxCiMMW7cUsvHdmyckWHVS2sxAjIr6my85bg2ZMxBjE6Mk+e8EMTZoVJftrl0aB06MR1Cyw7h0oAXIVeIf4M4IVdU00g/RnZspDljbB4DxEILa2Glt1Uxu74XeKr4F44785sVk5FQViB+HCpFqslBAbdyhdnMlNAiNf4fEV0HKVgn48wXwVQGzmlIKdgaDmPzHoMt+LURa7FcsJmGJDlwQnAiH/arEyOqZNnoTFV0SabKuP6gpXubzbAv17YZfJS0IPzPHHdjI4MnVYuZO2BsZF5yOUoMS6cqrr3n9bpbgMILt37PVppni5FUeTN/4TlN0KEAQTEZZNm3VBH+cuzf8Zuk0ZOyUejFuTir9CEdmlqcUATWhOhzjfwevNTGRZMezErJz4UfzvPb9+gTfOMNqFldhp4gZ8/olAmFD/SYoy0wSPalUILM6MREqNuQahzwhWEzL8ezRp490rVXkuCfd/+V282+iKzs6RHkdeGXV5L3dbWA2V4qUl88sDjj9PRT0OhrxMY2OJCUCv8ap3Avz+h8fDqm2vd2qAjyUmZmUXMH/7wxpX0PpKVeFo1P5naF/MlCcGOkGh84JL3RNq4D3+iIunGRMRNZKigxNHGaAUvNJ2bI4SeFWDFdFPyHXMfzhPIlfPI2hkc4HpLgoKno9rk7zMuybSL9jBNwt8beb+v9sMqAo1kV8vYJpV/jJ8fjtUMLLsbL5M7MFjvmvNNd/RKzv6l4s+Fst6Oq5w3gE58zNRXfb3Bv2EK6CO
 f4O1nrE2
 Uug28FPrsxm4n1wf4eATyI3CCbgAg2gFjWgreYuA+hAtconx3pi2siLf17dB2kg6VzUVA3FBa8oBxgBskmWNCOnJOXYqJObHfRG79iBui8OaJSK7I6vxsOTKZy9nMJQawR4AXhYJ5TSRZ7IksTcM8EOY58vjpeLFWgid7ac/Ns7O4cU2W1rUbddLG1x2KuZ7qbX4GfdaXp5+VUXrJ2hFpkaVTOCGxFGuU2Srpd62y1nwIOjLVBKOCE2O78kB48lFdAeo903d10FIhvmwHG430+4i0VUkn4578a/Ye3mxumCOwCOEWfrMIIpYEStiyLuBhL61zXnjvdpo7QG9aOZ2xNDu0J4sBzWvcJiy2VUu+KbNXoq73uWNqv3XbR5DNfhAQ9H5UsUKQD1tOhgs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-11 11:04 AM, Ackerley Tng wrote:
> David Matlack <dmatlack@google.com> writes:
> 
> > This series adds support for LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, a new
> > UAPI to enable preserved files to be restored into a userspace-provided
> > file instead of a kernel-allocated file, and uses this to support
> > preserving tmpfs files in-place without any changes to the LUO ABI.
> >
> 
> I'm interested in the idea of retrieving folios into an fd for a
> different reason, I'm exploring handling over ownership physical memory
> to a guest_memfd.
> 
> > The Live Update Orchestrator (LUO) API currently explicitly returns a
> > new struct file for every preserved file during retrieve() (e.g. via
> > memfd_alloc_file()). This then forces userspace to use anonymous memfds
> > for all in-memory files it wants to preserve. This works reasonably well
> > for VM guest memory but does not work well for other types of files that
> > userspace may want to preserve (e.g. in-memory logs, binaries,
> > configuration files, etc.).
> >
> 
> Does this assume that VM guest memory is usually provided using
> anonymous memfds?
> 
> More generally, is the problem that there isn't a simple way to
> implement retrieval into anything other than anonymous memfds?

Roughly, yes.

> > Preserving entire tmpfs mounts in-place would require a large amount of
> > kernel support and would effectively make tmpfs an ABI, which is a
> > non-starter (or so I hear). Instead, we can delegate the reconstruction
> > of the tmpfs mounts (directory structure, permissions, etc.) post-kexec
> > to userspace. The kernel just needs to preserve the contents of tmpfs
> > files and provide userspace a mechanism to restore those contents back
> > into a specific file on the filesystem after the kexec. Hence,
> > LIVEUPDATE_SESSION_RETRIEVE_INTO_FD.
> >
> 
> Suppose pre-kexec, the data was in a tmpfs file (and fd), how would the
> preservation work? Would the user have to
> 
> 1. Transfer the data from tmpfs fd -> anonymous fd
> 2. Preserve from anonymous fd
> 3. kexec
> 4. Set up the tmpfs fd
> 5. Retrieve into the tmpfs fd

No, the proposal in this series is to support:

1. ioctl(LIVEUPDATE_SESSION_PRESERVE_FD, {TOKEN, tmpfs_fd})
2. kexec
3. tmpfs_fd = open(..., O_CREAT)
4. ioctl(LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, {TOKEN, tmpfs_fd})

No transfering to or from an anonymous fd is required.

> > An alternative approach to restoring data to a named file would be
> > supporting a zero-copy sendfile() that can be used to convert named
> > tmpfs files to/from memfds across the kexec. But this poses significant
> > challenges on the *preserve* side since the preserved file might still
> > be actively in use. The benefit of the retrieve-into approach introduced
> > in this series is that it does not require dealing with two different
> > files. There is only ever one file that owns the preserved memory.
> >
> 
> Would it be more symmetric if the process is
> 
> 1. Transfer the data from tmpfs fd -> anonymous fd
> 2. Preserve from anonymous fd
> 3. kexec
> 4. Retrieve into anonymous fd
> 5. Transfer the data from anonymous fd -> tmpfs fd
> 
> As to the exact details of "transfer", I think the best we could do
> would be some kind of move from one fd's page cache to the other fd's
> page cache?
> 
> Is the goal of the transfer to avoid any memcpy and fully transfer
> ownership (so, not just by increasing folio refcounts?)

Yes this is the alternative proposal that has been proposed and
discussed a little bit off list, with sendfile() and copy_file_range()
being the possible mechanisms to do the "transfer". I think there are a
few fundamental problems with that approach on the pre-kexec side.

 1. iommufd requires that fds mapped into it are preserved. If the file
    mapped into iommufd is tmpfs, but then we transfer that file to memfd
    for preservation, iommufd will fail to preserve because the tmpfs file
    is not preserved.

 2. Even if you only use this feature for files not mapped into an
    iommufd, transfering the contents in a zero-copy way seems
    challenging. What do you do if the tmpfs file is still in use when
    you want to transfer it?

> > By leaving file and metadata allocation purely in the purview of
> > userspace, programs can create the target files where they want, with
> > the names and security permissions they desire, before directing the
> > kernel to restore the preserved folios into them.
> >
> > Currently, only tmpfs shmem files are allowed as valid target receptors.
> > Attempting to target populated files, or anything other than an empty
> > shmem file, will trigger -EINVAL. HugeTLBfs files could be supported in
> > the future.
> >
> 
> Is this basically that at some point, all in-memory filesystems' fds can
> support transfers?

Yes, theoretically.

> 
> >
> > [...snip...]
> >

