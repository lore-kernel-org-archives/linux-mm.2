Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40FC606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 23:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FQUme22a
Received: by kanga.kvack.org (Postfix)
	id 9726E6B05B1; Wed, 28 Oct 2026 19:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC5F6B05B3; Wed, 28 Oct 2026 19:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB7A6B05B4; Wed, 28 Oct 2026 19:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7D36B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:22:24 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2E1AC0280
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:22:23 +0000 (UTC)
X-FDA: 85373610966.04.E03D964
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7811A0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:22:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FQUme22a;
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793229741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErACdD6wnsCj5BI4BkkTwpFvg1ap5ibaSYHTkZSlAoQ=;
	b=QPK3fqxlvU2+SaVfqBJNg1KTVi+BKWOuBxUgTPdvPJFAy72eBSUOCnVD8XIaDmsoTjh9a5
	uruugbbMcOj/LOVzWNmfmfkbTsjdqsgBuJstt+351xyDmIbanqs3LJmbrORkoK9Amx5sVZ
	4zbZGuAe1SgLCTRBawWr2rxRBRLpoRQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793229741;
	b=imy4WbTJ2QS7LC5/aTx2aBvHyhtpyB/k2jRVCTv6olWDR0iAUzeXlIylqg3KuPtT8heZs/
	Szen/M3HbJy/eJFCp1gnx/n358Yc261L46uHXDHyHz6GYMMaHhTO8glUxZlmMb6eSRW26T
	3xag5wZX8Js7E2gcbv0lIu6OnH6R6dQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FQUme22a;
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cd5cd8d89a7so795024a12.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793229741; x=1793834541; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ErACdD6wnsCj5BI4BkkTwpFvg1ap5ibaSYHTkZSlAoQ=;
        b=FQUme22aMgA62vnhFDFIhc8YPEvXlB6rjCmtez1kXkj2B/ON+nimch0ydqxg8jmg8g
         zjZ8BdaX5G01kk4EhrdAVck1JtHDwNxcY8sVDCxiYzv8rLBGidKyPjBPF4mHfUAnNUY5
         LzHD3EQM1Dhz28z9QM31Coqc8VIltBXoNG8viidbsdR+KTqqo8KObGTGHM6nfP0lpXTW
         lzFZDhSflOE7GVI9L5No7cK8UHZaozTrwWH9EAaCstCETjpMbfFCSAyZ2dhY+Bs+K0wT
         jkurb+09xlYBCwIeILNf4OLKsKhOSQ6izAhtbhM0iWGE7DxLzhh855pTQ6hFgpdEDSQb
         sKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793229741; x=1793834541;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ErACdD6wnsCj5BI4BkkTwpFvg1ap5ibaSYHTkZSlAoQ=;
        b=FB3Rq4EdE8eqY+M5nZSJSbm8DGI2DDtfyD6TK1yP8kbXP1zsqwCKf6vTy5h4FAyYJx
         Jt89uzGfeLpWKEiRlZMp/CeTc/gX/jzqREYPgh3WMLxkCDYpNuHI/kmq2JM1AFE5qwgH
         3aC6YJfRq4os/3YyZ6t2xvWxarUZJ3k/fpmhTeqGRujzi4nc7k9wXJXhYYd+UeiWBGt3
         8qNdbYuGQ4piHA0frAuddF8PMechoaimk4uoLOOCv9CpJmnlP8tqgKvCUKcR9ECoNUqL
         nMFvrm6cT62qd7Y0QW/6jl9Bnkz1FA8TQ60JJKug2ZwM81Lm+7J2XBytd+rEh+7qz78C
         VxSw==
X-Forwarded-Encrypted: i=1; AKwUvBxf4CUYa2wNGEUeEpLeMwiBDTxQEgHIKYiic7kaVFvQrlpRczO/HBdx2ejzKS7X6UugoN/ODt9Qgw==@kvack.org
X-Gm-Message-State: AFq9FYIdidZz1W2JQHp+nN39x586VVRnfvS4dwRaneC3h3ICaoK93ylC
	kQfz9J+qvpLZ23817XRrtmtfCBxGh2QmnosHOnC2HB4y7b/QXAgvTfXQphMcFU6Z4g==
X-Gm-Gg: AYBFou0PxNjH43LVR0rrAbYnekMAba5ZMBPw5faEiAyZno7cc9VpcnFoUapO0QS25kr
	Y1NSiP51dCIc6kOjvyzgg1xP9U3wUROL1kT8hzVBEEE7zedllPQLZr8aeN7xaN3c31/UmEmOp3v
	Mch3kxzmklHG8Uq+rzY8gnVWiV/ExSOblOyqgZ3nNzDymq69Aljyu3qFGgv/dHIN0dAcgU3NSvr
	TsSZ41VSXpQ3C0tBrMRkbDj3qScrPfFWaot9Iy+S3a9Hs0ANDCQ51hFbhSWk3bJaz2ZTYd57EI0
	KX3YDyr+mOMTenDldFdazEmmNZ/fWQ8WIvzI+q+YWMXLJxq8MuYsEoCD32m8FWJ/p3Dr/9+x7cX
	BeVskf9mzL30cxuZBIOhcjD/0Ti1HA8akbusUvPPbDoZnp15UQoB1+7AraX5yJUOoA5GTsxDL8t
	XZy9sPIWx24IpdhPOMTOdFGzzmRgUJQ4+C5HhA+RRvqcKm18m+v3cHQ7df+AXZs7mSBVKnad8wq
	ATyIZ5Dm6E1RRKyRX8dTU6+jUE6dDsg4GvE5f7DdlotlRICsAti3l5zt+7MnIzAbUNB9bdml0Wg
	fgRAZuZI5olz9KMGqbMBls04kUFNKHrA0K8mislHmZrFY3GSwmJrdVzQxK8Mt9g5JFMqzA5G
X-Received: by 2002:a17:90b:1b0f:b0:3a4:967c:6947 with SMTP id 98e67ed59e1d1-3ae580cb98emr2772733a91.21.1793229740129;
        Wed, 28 Oct 2026 16:22:20 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae57a56a1dsm2552085a91.4.2026.10.28.16.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 16:22:19 -0700 (PDT)
Date: Wed, 28 Oct 2026 23:22:15 +0000
From: David Matlack <dmatlack@google.com>
To: sashiko-reviews@lists.linux.dev
Cc: kexec@lists.infradead.org, linux-mm@kvack.org,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 08/10] mm/shmem_luo: Allow preserving tmpfs files that
 are still linked
Message-ID: <auKDp6MfztVCIzp2@google.com>
References: <20261022225035.377445-1-dmatlack@google.com>
 <20261022225035.377445-9-dmatlack@google.com>
 <sashiko-outbox-183327@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-183327@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7811A0002
X-Stat-Signature: wz9a81x77zbo6mboh9z18ab7xbqb7g3q
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793229741-88937
X-HE-Meta: U2FsdGVkX19wcmuiXOVbeBAANJyqxjPi4J//9Xh4EKnZeOu9yA35zvbdE17OvO7j2ZS9o9ASI01cWmGiAPXlDA1LWPmj6WMhsog/okJnUx4T8P9jURX8bADl7/yFOhYQtOQuPscq3FSfAOuEmm6m2tAvuAn5uT2TRiJ98TTO7BSrXOxmvkNOZAQZ2ZAxNzozdDgGEG2zTGhx2GyKzY5KMrwqejF1DQky0DZpFY15UEExRyDPBkE7g9i77XGbLB8qB3BRclAuzO4L5snt+AbCyXjSeoN4y/NbPB0cy6QBlN2MOUO6GFof8B/Ixs7ujPP2pmP2bBAuX9wJUX5/TdtgHmFB+TH2GrtQsulk0cAAc/5RSR6A6/AkH2z4AtcQ0O+x/RdPTSoUqVuuzjQHozMOGJObAiMYR1stC0u9IUuUP7QOin0v0v60uYw+hp3oXNeeq7Fv2R90HWekG+FSNieoquGla09W46TIiz+Ln8Zwdan1zMznfE2mClG3SgkW/IpqDJQXIIxf+0oOb/oIqsW6JOchpDOpt7kZasnLevA/G4NYn1xdxMZBcZZ53nbscRULF72nCHoECD5KThe9KBE2mlunPpZilUvTgLINrgSSN0O9Etq4lvRETXvYZ4J/dbENACk3fymjBcBF1IAoTLXkJH2O6OhaIPC2YrFJF8rhy8zk7XhvluLe4CpGcEoJlqvf+WfJ7ZOpbyFo59VMwhdjIUa1qvwWlIdV3jhHE+GmCTiPc3eEc9eZ/tnFOeSB2OVTdsYjqtCK6D9ioard6vA+Tw/yXUsPp4Lzu8LrRkWI850Dm4RNdJIytp/I3OYDlTw3bOeb+3p+DsIFrtt4MmesThMbJWOmSTaL5qyogpD+JcWbqzvnbXrElT6OdglJrp70/hv5iNmvY+6/ScGGXSBplvyUlEvwsb6U5DsPTrgyYkwWC6gVfIWCMyPkMmUfCHwc+d7C++Q+93G83l+1iev
 BDCeFFwW
 /E90vz7DSE5cZeaKt37wD+QYCr1VRP3nJLNTPTt+FDe5lDb1H8Ebb7aCrY1RC0RfhNR8pXmC3RI7LZhnW4BDRSLvzPLUhrIyNPyvOFRH10GMjlkzoed/BdKwGiMwXi6k6GymJOOSOYJbBXHSXLxqkvLQJKHo5MYygMdr8dBMYhquQ23H6agn3VSK8Vdyk3NaPjB1mjyKPOFGQ2KASPHw+3iCh/SS7DlL9CKoF8u5jHlrx79+V6f9tAbLjQHbvIalD4/LKvUdNyv0cehQo64cMHRTeAeaTX7vmUPjqdWwBF5k5UpWJuTJHWht1vS3m8r5CyBVUuRUeV/icYfvHYta7PENNdhVz0umnnXWeqqOxKloIj+q8Jg/ar6q9OOf2mZjMYRPdPOWC8z6UNOAAbGiX/W5tX3ILjdCFdo3keERzRJcLkWE8GArmfSHZ+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-23 10:51 PM, sashiko-bot@kernel.org wrote:

> > +static int shmem_luo_may_preserve(struct file *file)
> > +{
> > +	struct mnt_idmap *idmap = file_mnt_idmap(file);
> > +	struct inode *inode = file_inode(file);
> > +	int err;
> > +
> > +	err = inode_permission(idmap, inode, MAY_WRITE);
> 
> [Severity: High]
> Should shmem_luo_may_preserve() in mm/shmem_luo.c also verify that the file
> is open for reading (file->f_mode & FMODE_READ) or that the caller has
> MAY_READ permission?

> Wouldn't that allow a caller with only write access to read the file's
> contents after retrieval?

Yes. I will fix this in v3 to require the file is open for reading and
update the selftest to cover this scenario.

> > +	if (err && (sb_rdonly(inode->i_sb) || IS_IMMUTABLE(inode)) &&
> > +	    inode_owner_or_capable(idmap, inode))
> > +		return 0;
> > +
> > +	return err;
> > +}
> 
> [Severity: Medium]
> What happens if shmem_luo_may_preserve() in mm/shmem_luo.c is called on an
> append-only (S_APPEND) tmpfs inode?
> 
> Tmpfs supports setting S_APPEND via FS_IOC_SETFLAGS in
> shmem_fileattr_set() -> shmem_set_inode_flags() in mm/shmem.c:
> 
>     if (fsflags & FS_APPEND_FL)
>         i_flags |= S_APPEND;
> 
> Unlike IS_IMMUTABLE(inode), inode_permission(idmap, inode, MAY_WRITE) does
> not reject S_APPEND inodes. In fs/verity/enable.c, fsverity_ioctl_enable()
> explicitly checks IS_APPEND(inode) after checking MAY_WRITE:
> 
>     if (IS_APPEND(inode))
>         return -EPERM;
> 
> When a caller with MAY_WRITE permission on an S_APPEND tmpfs file preserves
> it via LIVEUPDATE_SESSION_PRESERVE_FD -> luo_preserve_file() ->
> shmem_luo_preserve(), shmem_freeze(inode, true) sets SHMEM_F_MAPPING_FROZEN.
> Because all writes to an S_APPEND file extend past i_size,
> shmem_write_begin() and shmem_fallocate() in mm/shmem.c will then fail with
> -EPERM:
> 
>     if (unlikely((info->flags & SHMEM_F_MAPPING_FROZEN) &&
>                  pos + len > inode->i_size))
>         return -EPERM;
> 
> Should shmem_luo_may_preserve() also reject IS_APPEND(inode) with -EPERM so
> an append-only writer cannot freeze the file and block future appends by all
> users?

I am not sure on this one, but rejecting S_APPEND inodes for now does
seem like a reasonable place to start.

A writer of an append-only file can only add data. It can't destroy
existing data or stop others from adding more. preserve() blocks all
future appends, so arguably it could be abused.

I will update v3 to reject S_APPEND inodes. If someone has a use-case in
the future for preserving such files we can revisit this and look at how
to support them.

