Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85B76C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 09:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C3A6B0093; Tue, 11 Aug 2026 05:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8741C6B0095; Tue, 11 Aug 2026 05:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0D46B0096; Tue, 11 Aug 2026 05:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58ACC6B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:04:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 760CE1A01B3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:04:23 +0000 (UTC)
X-FDA: 85088402406.26.29BF8B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CDE744000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:04:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHxjSLAZ;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786439061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqd0jBYucjRBBUhQ/CcI4j1gic+E8ObUl1M7bAWuqvA=;
	b=bKWBQMSn3R53I2PaOqC0haB6Eb+zFJZhkoaxbDlstYtovjSJo+WXdkw+h5EnFc6mv7i/DF
	UwPfVTSArdg2VSe/2Bg6iZYuCTn2SBi1v78g3QScH7U0YMfAcq69r3hi45J6iHWMaZt/SG
	9+Q3BmPi5s21p/G9YD3T0qplAxQpFtk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786439061;
	b=4s7wcJzzJc2t79DkO8DPIcX0u2NgWwOy+SwPh63p5QUhOFEa2k0D3ln3e54is+1/ilvMaI
	Ixyle73QkvKuUWStluxtKSmmOHqlAUrZIxtCDhptUnwQtBzsSKt+BaNOWd+FuhutfAGxIN
	oZRfmrRsOVT0H1epSLpf91fGLrEKmEo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DHxjSLAZ;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B4F9600BB;
	Tue, 11 Aug 2026 09:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267BA1F000E9;
	Tue, 11 Aug 2026 09:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786439061;
	bh=bqd0jBYucjRBBUhQ/CcI4j1gic+E8ObUl1M7bAWuqvA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DHxjSLAZxstCOZdlWaaelyCKBFtsdMcV2ge5KXIjA8vZ65GdLVQy+H8GIqOPLJFZW
	 Da1rDvYNPw06du5swwJ7r0/NQbszmClZgdoff1tArrkF87WMAR10wknrraAmE6rbgN
	 SZ4RBiAnvBqn2i6r1HBwy+AKmOkvUTd2DITf+Fg8u8nxC3agSFHVCsAi68JjPzdFPh
	 /AZTX9D9GBoFatNuuNYjyqFo/dThjXpU7v6bFji6dwmz0z0pLEfbnJT9jQ0+g1LRB2
	 V24q6/KCYtKJHuzgK5StDbdVSLjk+JD9IRKklOBpDSCS+occ+mU9I8A651lncFP0pL
	 gxKMbkhkr3xgQ==
Date: Tue, 11 Aug 2026 11:04:12 +0200
From: Christian Brauner <brauner@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Xin Zhao <jackzxcui1989@163.com>, ljs@kernel.org, rppt@kernel.org, 
	pfalcato@suse.de, viro@zeniv.linux.org.uk, corbet@lwn.net, 
	skhan@linuxfoundation.org, akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	surenb@google.com, mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, mjguzik@gmail.com, 
	ebiederm@xmission.com, jack@suse.cz, jlayton@kernel.org, chuck.lever@oracle.com, 
	alex.aring@gmail.com, arnd@arndb.de, keescook@chromium.org, mcgrof@kernel.org, 
	j.granados@samsung.com, allen.lkml@gmail.com, kuba@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6] coredump: Add bit 9 of coredump_filter for pre-exit
 files before dumping
Message-ID: <20260811-abzweigen-zukunft-einpacken-668f1aad2ed1@brauner>
References: <20260804001703.1340667-1-jackzxcui1989@163.com>
 <8c763f1b-85ad-44b9-b36c-becd7598fe77@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8c763f1b-85ad-44b9-b36c-becd7598fe77@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CDE744000E
X-Stat-Signature: twjinr4ftq55ye431k361xwnpsyurcu9
X-Rspam-User: 
X-HE-Tag: 1786439061-215262
X-HE-Meta: U2FsdGVkX196mswkqt+sroeOIMnblHy5lQjRjWjqcQuxFI1dQy/TX1zH33pAPDY84PVItb8UNowtqllW+LRQEZ1dT7q2MtwXu2s1c4LdYFyp+L/ej7N+uzNeUCW1cuRh58wicMYELsBTQYf/GSRnTRcaJ3FSLVTnKAJSD3UjWwBhxWzcFOlGiiWUhl04r1I48FUXDmeLGNKlBWG19KhCo5bTArA99IJNzmV90uDpSawuVnmXcFtPgaMfsRfhim4AWvJtTE9ZlRB6O8bfk59oGLKSYN3VVpKgavvtlcUPlUNZnKkOtHAgoEXhle3FQJkIDSQ8D2cF1gYZP8AxsMVWSKrBjGAA4Zne+H7zE5XSlD9MhfEbZ8SPtW/hGCkp5bHHvvSVR3zsgkZony4vSN++K7Kbzw65awvHHhmpPiN6+SSpqe4O7jxRwgsUTaLWlWbtO6bvS4FeE0jC2zQ7rdsfM0OzRYkTQJeR48uxjvCMKIQmkYCDYjEaVMLPRJfQb0RNr2kwkpcUNRbYhF4T0PV3LVDKBy8eR8pKGnLkMu8x113Ts2AZ3uJsE/jTyaA9a0+4dVVI28i9sN069j8NC6hcjpSRakGXkPDXjHZqCdGwpIFH1BS1KlmoaPOmThJdou1SoHToF16ytaAq03Kb3kAn0+7nJvLFlSuNqn9NthK9t+ukpV/N0NFwxOz1cwf3Y+8dp9ca5GIHqUD62kzWobg4EE/fklAGwdhcPcBLGK7g+1MXGc7TzZJvdvPB0wq48LMw3O3b1Pbxn+H55StWpjKCxof5gAVoVG2yYpvrfYOwTCKuO8aElswTR5Bk4xIbLtsnbLzopEiUo+TsBMN1/CpA9Qcd7KzIdihL4qHzUdQMomvkL1LIjygWGzc67e8BuEkDAncvNd8L3Vdmc7+mvY72T4VYnbN4ZIunfOiSs93MB580CUOzaEm4b66F9stPDbcZUlLRnCZMFuNZsSub/W0
 jg0DkGl7
 LbIlQ5ONG9tVN0V0YJUNw0e4HXMNhXBHyC1A075Fw1fKX1LSdB3Q54Wd/Tt9s3pT+MNxnx5y2EkZcyVSlSvOd7qTM+VmeNwLtMvUkWgECUiB/jmhfdBcpinftCPVEZit1WjT0UO+NJgwh2mTdu9Xy7nSRuH1reTzYmwk3mXs2sJT6xHVvDm0lCXfqsZE8yeGUSTF2OUubtR0RzlFaWzt9PV3bQWDs+tJRfgaUUboBFTO6bGZa2htJeT9VoVTTCQcIkT8LKJPI+xWm1XqeHXfSdRweuuZ71l9/WDWh8S/2EJO59vKyrHKojxmk1qzLc+ccdd0OlOTIwRKdXCcW79yvjADz9ASiGXllcacErDVSBZx3/OdrR7yFxfrZu5NGWDY5cWIcC2QuwiLjKn2Tv3S9GkdHbxcjXazcfsC5Nj+wsHt+NgoGW44GYdforVP4tEKJ8v+TQBs9AllNIkBl178jb8TgrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 04:01:55PM +0200, David Hildenbrand (Arm) wrote:
> On 8/4/26 02:17, Xin Zhao wrote:
> > A coredump typically takes seconds or even longer to complete. If we
> > happen to hold a write lock with flock just before triggering the
> > coredump, that write lock will not be released during the entire coredump
> > process. As a result, other processes attempting to acquire the same write
> > lock may experience significant delays. Another typical scenario is that
> > some custom management modules for shared memory also need to release the
> > reference counts of the related buffers as soon as possible, rather than
> > waiting until the coredump is complete.
> > 
> > Add a new bit(9) of coredump_filter to tag whether need to dump fd list.
> > We set it by default because tools like systemd-coredump go through the
> > fds. Some other coredump pipe programs like minicoredump do not use fds by
> > default. If you are sure that your coredump backend does not use the fds,
> > you can clear bit 9, which will allow some file resources without VMA
> > references to be released earlier.
> > 
> > In fput(), check FP_DUMPCORE task flags to NOT release file by task work,
> > otherwise file put operation will NOT execute util coredump finish.
> > 
> > Test Case One - flock
> > Test program send signal SIGABRT to the program which owns the flock,
> > output the wait time(unit ms) to successfully attach the flock.
> > Test program malloc 500MB heap and memset it.
> > If NOT set bit9 of coredump_filter, waitms is 11280.
> > If set bit9 of coredump_filter, waitms is 0.
> > 
> > Test Case Two - ion buffer
> > Test programs include ion buffer publisher and ion buffer subscriber.
> > Ion buffer publisher output the ion buffer hold_time if the subscriber
> > NOT send ack to publisher and NOT release it. The subscriber will trig
> > coredump by itself in some time.
> > If NOT set bit9 of subscriber coredump_filter, max hold_time is 19591ms.
> > If set bit9 of subscriber coredump_filter, max hold_time is 320ms.
> > 
> > Signed-off-by: Xin Zhao <jackzxcui1989@163.com>
> > ---
> > 
> > Change in v6:
> > - Fix operator precedence in PF_KTHREAD/PF_DUMPCORE check.
> > 
> > Change in v5:
> > - Not add another bootargs for the feature,
> >   as suggested by Christian Brauner and Lorenzo Stoakes.
> >   Add bit9 of coredump_filter to tag whether need to dump fd list.
> >   Set bit9 to 1 as default.
> > - Al Viro, Christian Brauner and Lorenzo Stoakes point out so many
> >   problems of the code related to umap that was added in v4, delete all of
> >   it which is unnecessary. The management of reference counting for shared
> >   memory generally does not need to be released through the release
> >   operation of files that have VMA references. Traversing all the threads
> >   within the process and executing exit_files() is sufficient.
> > - Fulfill comments and commit log,
> >   as suggested by Pedro Falcato and Lorenzo Stoakes.
> > - Link to v5: https://lore.kernel.org/all/20260630075604.52533-1-jackzxcui1989@163.com/
> > 
> > Change in v4:
> > - Christian pointed out that the coredump process will traverse file
> >   descriptors (fd), so certain fds should not be closed by default.
> >   Rework the whole feature, add /proc/<pid>/coredump_pre_exit for user
> >   pre-exit resources selection, default is NOT pre-exit anything.
> > - Mateusz suggested that walking the fd table and release the file-lock is
> >   reasonable. No longer release all the fd(s). Based on user config, only
> >   the flock fd(s) and the fd(s) correspondent to file-backed shared memory
> >   will be released at most.
> > - Link to v4: https://lore.kernel.org/all/20260624145552.70143-1-jackzxcui1989@163.com/
> > 
> > Change in v3:
> > - Add comment and commit-log to explain why do the MMF_DUMP_MAPPED_SHARED
> >   mm_flags_test() check, note that memory mapped files keep their own
> >   separate references to the files. The case to work around is that early
> >   unlocking a flock on a file allows other processes to lock and modify
> >   the mapped data protected by the flock,
> >   as suggested by Pedro Falcato.
> > - Link to v3: https://lore.kernel.org/all/20260619122419.3954581-1-jackzxcui1989@163.com/
> > 
> > Change in v2:
> > - Get rid of the implement of adding new fcntl API, the issue does not
> >   worth inflicting the cost on everyone,
> >   as suggested by Al Viro.
> > - Call exit_files() in coredump_wait(),
> >   as suggested by Eric W. Biederman.
> >   Add MMF_DUMP_MAPPED_SHARED mm_flags_test() check to filter cases that
> >   need to dump file-backed shared memory.
> > - Link to v2: https://lore.kernel.org/lkml/20260618150301.3226517-1-jackzxcui1989@163.com/
> > 
> > v1:
> > - Link to v1: https://lore.kernel.org/all/20260618030700.2511668-1-jackzxcui1989@163.com/
> > ---
> >  Documentation/filesystems/proc.rst | 14 ++++++++++++--
> >  fs/coredump.c                      | 21 +++++++++++++++++++++
> >  fs/file_table.c                    |  7 ++++++-
> >  include/linux/mm_types.h           |  6 ++++--
> >  4 files changed, 43 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > index db6167bef..d590a1dda 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -1939,6 +1939,7 @@ The following 9 memory types are supported:
> >    - (bit 6) hugetlb shared memory
> >    - (bit 7) DAX private memory
> >    - (bit 8) DAX shared memory
> > +  - (bit 9) fd list
> 
> "The following 9 memory types are supported: ... fd list"

Fwiw, I still refuse this patch for the reasons I mentioned in the
various other postings of this...

