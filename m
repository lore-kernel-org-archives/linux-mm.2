Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39FEA606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CJIYbDcl
Received: by kanga.kvack.org (Postfix)
	id 5A8396B05B0; Thu,  5 Nov 2026 11:52:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 550056B05B1; Thu,  5 Nov 2026 11:52:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F816B05B2; Thu,  5 Nov 2026 11:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3426B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:52:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB2C2140B44
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:52:38 +0000 (UTC)
X-FDA: 85401659196.05.6E5EE9A
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id D9F30140003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:52:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CJIYbDcl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793897556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+a5U8fHtsX3E5MaoZwCfMwFhX7Hac3DauAHwFYDfPc=;
	b=yI9tI12j0GBQODVwomQkG8t3sW8XJ/bGJB5npbwPP/gbeIZcjBBHbX3w7uA+jjv3s9mSZJ
	PsW6C5tV4bBB2PJylg6EhWDsNU0f4inImvg054olkV8pABb+moVbdXSfjqo1a0WwuE/JMo
	QASU7jP9Jt+Loi+3vW6MwzL5jevuwJc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793897556;
	b=aJEr2kyesKKEL97NHtJMHRf8jtD6mO0VuhLMy62joj9BtCAdzJgSc4ebHKRZeZiqXXCCtQ
	zGOpmhA+W29fMmjibah3WJA1JQaSpzcyxCPJg9OimyAVwUWbOlEXWcfRDrmJFUutPdhzRp
	y7R1q9Mh3emAD60y+YTo3aqVre7agTc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CJIYbDcl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a06ca6e8f4so1516299b3a.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 08:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793897556; x=1794502356; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7+a5U8fHtsX3E5MaoZwCfMwFhX7Hac3DauAHwFYDfPc=;
        b=CJIYbDcllus5jqiFyx9K1XLiHcKNRLpcxWybqeSJm6meVTlbsPPl78MtYGo4FJWFrj
         ncEhKsISaW541GGSLaaE0qM1dEQC2R1RLCkrKBhAqgVJh5YH5obIZO4udCK6POXLRQ8e
         9Tmnu7jmIIHKr+lVNPeq4x1YnfZxddqLIieuon3Vt0B8y6B6Ry5DP8mXtf05vxsf0RVU
         UhYtaO9Kwzq9v9FQdfINbuvCawe3YIF/UO+V0LkoDqcvnb1xZ96PHl0AjYpr3/kzo3qn
         ZokRwkdEnORa4vRn5wvBqezNgDEK5KcQJ2VAWDG+E9ob2FEQnyKN4p7y5SFylwVrF6UG
         flQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793897556; x=1794502356;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7+a5U8fHtsX3E5MaoZwCfMwFhX7Hac3DauAHwFYDfPc=;
        b=vxR7vkf1fSnvMuSWags7Jcdh4d8GhLydKx6OheLNQUUVPeeePpt15B16cynSqBrrlq
         Nd0In4wvV0YkwPDWZV+bQAT6Udkh8iPlHRKviXj4iq+re2JFfZemplbPmEdF0WYhwDvI
         3hM/dSlO7fk7p7JzcgXZ+12qresv1EzjPKvUs4MwYGmLQG8UK3OS2+OJtNK9Y0kcRKKO
         L1s1B9xx+ZJNRz9VMAj6MruN4ZDbYBlLB7Xxyg7U2BmSxbkI+3PizLprvPxUJmjcvL81
         0Xycj/Nzc1AfgrGrBfbZ9xXGRub2z6i1k5PQcyYwH4ZjVOU+UB7cbiV7sOfVcJcEclCC
         Okrw==
X-Forwarded-Encrypted: i=1; AKwUvBxMgvrTZOnfGw7rFF0huN++Rj7ep7xC4y5xMjLByjLuVZOCV7rMu8sScIfSXRKcrKxDOErmRLGgeg==@kvack.org
X-Gm-Message-State: APuU4Z83UtuCtiB4SXiJXwHAgQ7fUPonwLG/C4UMQ6nbliFrBA2UZoZI
	shhKJ09PMOclZi15ORuQRWJccD99cDz53ndvB5jjj0RbW/5xku/Iz1fu/hGHZXfXyw==
X-Gm-Gg: AYBFou0xDRazYziRVUzrFqhKzJdm3QC1UCRdpZwR+X9bIzVHXxfuXc6k30QJFAeoG34
	cBD6u8Bj0MJ5AL2rD4QFqYxvMW8x1v4SEA70C1dc2alrpSnWs6Q8HdFgGH1ufL+a4ihGqPBefuJ
	T4oDpS8LK1DB8QtjMqRExsxSEoBwSZk4w5oAvD+4EybMTlwvUANLbk+Wrfd4aDzcbcJMnyuvjg6
	y8OhGD1VDj3Aa3VFTK3wBfl8Rr6geYcQ/glBWmK1evxGeC6bE1rIFgKGF5kkg2EHvUpW6YPZvln
	8xe/dSoZDMvYdgbYnRBC/PwBQC44ZwPyBzVqLZ7fKRJUXql3+fYv9EpqaC8MInntpeVAbcED+nX
	eOlmpttE2tR2xhl/VoQw1CyNUIEWLo98jPDI8utpA4EYireWYIEuySavK2vy4A2eG3v4UYqO1+R
	bdyNzHA/hL6S0+n/2FW+1BkAtPHQa4jlvw0ywEEkWtH05eeUhglfsLFB74nmeoC9CNdY91aT8yn
	IqJvoftUN6odKYivHMKjkw/ZejZ8rCRnQSni8KUP9s7jnBUMVFZOwyC3vlwM0qVv0TT7fHT/CX0
	EPRqcn9lDFLDfckG0RxQjDJfvZFQgDT2LFkvUEkzvCLDTBNmT+L0KOkjUJF83TpqSaoA/Ib/yfL
	b/13gCmWMYA==
X-Received: by 2002:a05:6a00:e11:b0:882:359f:ef17 with SMTP id d2e1a72fcca58-8a9bb7a0b64mr18260859b3a.12.1793897555111;
        Thu, 05 Nov 2026 08:52:35 -0800 (PST)
Received: from google.com (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bb48410sm2298197b3a.46.2026.11.05.08.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 08:52:33 -0800 (PST)
Date: Thu, 5 Nov 2026 16:52:30 +0000
From: David Matlack <dmatlack@google.com>
To: Christian Brauner <brauner@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
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
Subject: Re: [PATCH v3 00/10] liveupdate: Preserve tmpfs files across Live
 Update
Message-ID: <auy0ThryqW5nVx20@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261105-sitzordnung-nahkampf-ausbleiben-6db911d0333e@brauner>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-sitzordnung-nahkampf-ausbleiben-6db911d0333e@brauner>
X-Stat-Signature: d3gcxegsatdubygmrj777hqmwpzahr51
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D9F30140003
X-HE-Tag: 1793897556-512671
X-HE-Meta: U2FsdGVkX1/T5qERe2AAgRwQDesUSUTxeR2uEBO7X3zF/56+JVFfLzID51x2fqeg7BkN8SFGJnWEwRp8iijTEmfw1eObep5YbiskOX4Gnbr3rQjhCV1xmDgPZU9w0xBDmeJNn7Jd45ZRmVQgMi5MAm6GtWTyaUeIO1Y+wqhrumdNHHOadQCrdBGKVqFZ+oEJxmhL8gehiQQ8P2Om/abXd/ign/Ru5FTHvwwIRkwH0nCKXuQ/o58RBvj/TDp+S/haDCD9DWa6c8IoVcA7KYOfItFe6/4Ql3hFH4I1DTtcPVXMpFRgFgSeO1/YCkFVr/O4zt+UcyVeK3iGmUExD1OrWPk/A7kpjBUySfTQRPULHHq0wYSSL/sfYv+ui5Z5XRT2sM1o+pK2twLanv4/x3BYglNmAjkYpDWPXVkv+1jU1KC9UJ+XaRKIXrx35rX3DeohsgqF3KVFg2Wo9He8ar4H8x3ZEI0/2jukraRMK/+Osh/jF/BNk6f22oFXIPRNExyt1r1DKyemgoGoU6xeEI0ptsNoUOv1J9nlRvf4ju5hLtu/Y6WGxYEQOCBUBCe4izeywDADo/X15WJI5MJFCR2ULIFRz1aEfVuzUKklIK2NJ7hrq3gHV6oK5JDT1Y8Q3H0f9A4xObWEHrTDRt9h7v89jEhgQcuFbrkj9BdJ9MWpJQkhMrFOGYee/7e4cxx8NnMNJ+8f6l2yphAL0NEAZ8yUEgCk1mbqxYeqpZOAxB+Uv4Tw3KdbzLFGKtElwGK5DMqRBtkNd/oAuR/7qL79ViMyayB2oBqWjia6F6aYK5JsxBVDTDwlwgQy9975eXU8xiM05Jr2y2/Z6Zn7KMkXaI2livtsPJxkxFgySCFkEin4a8u1ZhPLgL3IU5QK7ViyP0WT8NuDHu9+KiHmU96iWngOMyshIKMSaMgjMU4mCy/yGDGBMdCN4XUVg9IGULWBlN80Z1Jy7Z7Ei3H8MQhQeV+
 B4iKEenw
 kY8N9XM7XZ0tMekXR5QhoPlflQ98gDbX6PgYUcC9ELwWZgIhXkbK+PUH0KfQAL0jo6p3nEKt8DVBCdJVm0ji9oGuyrKyE/vbNSFA5tspb0CeZa3W5UhKBFfwEiDH/Dg3yx6PmDPW9jgm9M17GOVANcfXt8RCBhtaqsIzubV+e7IjeNRYmpW/k/FMzN6c99VBcZkz6iNjlHUlNdzHb369aEM0DPvYygtixH9KU5nmc5HHvKwKSRMs5PqrwpDQfbLHvTM0ixKkm/rJXBYkN8O0J8S/5rKKtOt+c1Ne+I6wwcn8fPvxiit4yTK4zuCB5iKAEgqQWtlnrNfLhG/5VoeEkHx6jHK5D4LFIwOCMCJpu0YrNTYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-05 04:42 PM, Christian Brauner wrote:
> On Tue, Nov 03, 2026 at 01:02:06AM +0000, David Matlack wrote:
> >   4. Retrieve files that were preserved from a tmpfs mount onto a tmpfs
> >      mount chosen by userspace, via the new struct
> >      liveupdate_shmem_retrieve_arg. The kernel creates the file as if by
> >      openat(dirfd, ".", O_TMPFILE | flags, mode), so the file gets the
> >      same flags, owner, permission checks and security labels as any
> >      other new file in that directory, and is charged to that mount.
> >      The kernel fills the file before returning it, so nothing else can
> >      access the file before it is complete, and userspace links it at
> >      the path it wants with linkat() (patch 7).
>
> No, sorry. That's not what we discussed at LPC and it's not what the RFC
> and v1 did.

[...]

> So instead of LUO handing out a file descriptor for a file it invented,
> let userspace create the file, O_TMPFILE, O_CREAT, whatever it likes,
> with the owner, mode and xattrs it wants, and let LUO put the contents
> into it. That's what the RFC did.

I'm fine with going back to that in v4. The retrieve argument will just
be a file descriptor for the target file, and LUO will only restore the
contents and size into it. Everything else about the file is up to
userspace.

> The checks on the target are trivial: a writable fd to an empty shmem
> file with the inode lock held while you fill it. A tmpfs file can't be
> sealed, it only ever has F_SEAL_SEAL, so there's nothing to restore but
> contents and size anyway.

Sounds good. The one other check I plan to add is rejecting a target
that LUO is already managing, e.g. a file that is preserved in an
outgoing session and whose size is frozen.

LUO will also add the folios while i_size is still 0, and set i_size
last. So reads, page faults and memfd_pin_folios() wouldn't see the
folios until the file is complete, and if the retrieve fails partway
through the target is left empty.

> I also really dislike file_open_root() for this. It's an openat()
> emulation inside an ioctl which is completely terrible.

That is fair, it is ugly. That all goes away in v4.

> > - Is patch 9 (retrieving tmpfs files with O_RDONLY) worth merging?
>
> No. With userspace creating the file this doesn't exist.

Ack.

LUO holds a reference to every retrieved file until the session is
finished. Since the target has to be writable, executing a restored file
will fail with -ETXTBSY until userspace finishes the session. But as
Pratyush pointed out, userspace can put binaries in a special session
that can be finished immediately so that the binaries can than be
executed.

> The preserve side seems fine to me. If you freeze the size of a file
> for everyone you better be allowed to write to it.

Thanks for taking a look.

