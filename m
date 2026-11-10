Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D568B606A337
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ukz+9Mhm
Received: by kanga.kvack.org (Postfix)
	id DA3146B05B7; Tue, 10 Nov 2026 10:45:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53FE6B05B8; Tue, 10 Nov 2026 10:45:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69E36B05C9; Tue, 10 Nov 2026 10:45:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A375D6B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:45:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 352C7160874
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:45:40 +0000 (UTC)
X-FDA: 85419634440.23.6281444
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 949E640005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:45:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ukz+9Mhm;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794325538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T4MRWNIKTZkEJgt6oLMqXnO3+RBTvl3UjB+JLMtpOKY=;
	b=GhY9Db3p/nFu9hGeYz3xpcxuHRUBOn63VdxxpnerBSiP9Xzb/6sAk2W7uYiq5M7dP3dgtP
	eVYpb0BTstFFfz7HFD3sPD78jIayWfgUGX8BuoLodLS0Hvr6lTm0ea6BHImd+jXG0zUPPU
	3AhcTn3Tkqik7gHtZH6ZMBePpgMQ1aw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794325538;
	b=fYNM8M7bdmI8JNReEqKB0S5P4yp3LpgJvBH/V9s8JrNTLg3HNS4DUbB3JxJOwmDBFHF8H8
	0Q7WrMhDXPNRM94fYZh3Sil+TTvjPXGNBGNaL3Y0mGz90xWpLHZBQ7BHfxJgrXrSXhuIis
	64HnCOOIqAE0NRCHSlku0wdTwx8voms=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ukz+9Mhm;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D720263A37;
	Tue, 10 Nov 2026 15:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F171F008A1;
	Tue, 10 Nov 2026 15:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794325537;
	bh=T4MRWNIKTZkEJgt6oLMqXnO3+RBTvl3UjB+JLMtpOKY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Ukz+9MhmJgvTDWk/SeEpiCCkI/fDF9KMsJ5erGKGHdcFKSmOVmYTuc9CGKNmi6DYO
	 dkn7GN9I36tJwFurwtLxd9tnH4rhP3ZTL0xTnvt8Ej6TGmAUntAB+/8ZIcRXL2dQ+g
	 rifN3NXh9WBsTGWuMkwOlo+7aSbKUH3BUb/8YMVD5rvHHb+nZAmuu1RZ1qGQrm8aKZ
	 kcR26N0KwEtsC9GIr9bPuaxztpOFhhIPld6MzOkHAzbhZ/SmJaUr+k1/kb1ShQvPaB
	 ut0RjG/3MNIuOJ6mZDzOQw2lxSHNBQf8C7PmVh9omoU0F2pwM7nyjwYn7HlSS1l2OV
	 uoB3ljY2gbHUw==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Christian Brauner <brauner@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,  Alexander Graf
 <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Baolin
 Wang <baolin.wang@linux.alibaba.com>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 00/10] liveupdate: Preserve tmpfs files across Live
 Update
In-Reply-To: <auy0ThryqW5nVx20@google.com> (David Matlack's message of "Thu, 5
	Nov 2026 16:52:30 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261105-sitzordnung-nahkampf-ausbleiben-6db911d0333e@brauner>
	<auy0ThryqW5nVx20@google.com>
Date: Tue, 10 Nov 2026 16:45:32 +0100
Message-ID: <2vxzbj7witb7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6ngyzek53o9u1d11mhupowa3qppoqhyt
X-Rspamd-Queue-Id: 949E640005
X-Rspam-User: 
X-HE-Tag: 1794325538-828281
X-HE-Meta: U2FsdGVkX19yr84hOWyUyv8MTzawpzUqPkHe18z3hR5iSCDVwy3hNzek+jZgfHbH4cKD/xepapN2R2pYewxkVdEMUX9wTeAjEdCI6wS1xpr8QorXFozuvrRoAgzR49oQgplTYmqemVTfyXlkrdoavbknijac4LeiL8a5CiERmqYWBwjtKWTYJYvRgTw3IluQsCZyudVYMJDTIOdZk3neuwhp0IqP8S7n/8MXMHD1EXiz807RoP2cncBZvSZ8n1VPL/giSv24qxxGSrr0ciGBUDTjBOqbYke0ygdQwWgbz8Ly0FuMd74WhGlhe5OiVifMSK1cxjCRj8xogA9G8cgD+rRxzyraumUxk7SE4BAnpSrprtuos4xO0nNQPKDQV1s8h2Xq5yYeJxgMlmQFeLxz3ZcCkJ3E0Qjns/X0i9w98ZQqlMHgHCVW41zdOQ22ccT1A3FLiou1DC0/Xf9xB+y9IqOaKL8v7Gq/oX3rD1zIH9MVs/O9FXjxOYihK515CMw8yUck+V9YpK4+fi6ALfJg05rpiVi+iooBG8tWrgmlTiLZCI5+FVR9cEsP32zK0cqgwOGh3/R7+KO8uyqazqQz/w+hyju74pN2m74oWhRCHpcPx2yHbD8h7vSgVAqe3If4hGce8tgF4ElKblk1AhzJtIPt1xyhJ5qB5oW4yo3sYeThR064d4KmIylHtuofbOtqIwl/HgCxxRMPVWyjaRkzLMVdQ3opXKHEmxDFd3GZF+KWFK8rWzbpNJy1IrndH3Rs64gWS2QIPgRLwmxY8QJU682TBpPufohIkVi8uwC1GsthWu2g+dDYwNyoBmdKiASegci39TqGhisR1KRJfk5qiVO2WoYV8VEZZ0vZZcil6QZCl7d5lGdbiU6Z2ADl5LEyOQ1d5J0y4PeIOip08Gqt3cuQAE1/ZzqA6JbLfrAM2MbcprAbQHZy0a3Y8YrhdP0GAIxJ7/thpRfN4O0csGm
 r2PZb9u+
 sVq97M2HZPBw7AFFQtF+MI/CikY7Ld5cQUmLD1adkLABZ4W251j2isIeHAyi1rC/chSaDUX1SAr++7z03tiIVDQCUTWg0xwCYv3L5TdxSDO5no3Jb0nVhBuKa0xpo9c5Cbbz8tBf7XqpsxcIFNmGXe3tOBT0C47WcMAPFrliJyCGgFVWd+kvhVGC3eWAt/n9qccwLZfkP4IP4BFogd1W6j82o7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On Thu, Nov 05 2026, David Matlack wrote:

> On 2026-11-05 04:42 PM, Christian Brauner wrote:
>> On Tue, Nov 03, 2026 at 01:02:06AM +0000, David Matlack wrote:
[...]
>> So instead of LUO handing out a file descriptor for a file it invented,
>> let userspace create the file, O_TMPFILE, O_CREAT, whatever it likes,
>> with the owner, mode and xattrs it wants, and let LUO put the contents
>> into it. That's what the RFC did.
>
> I'm fine with going back to that in v4. The retrieve argument will just
> be a file descriptor for the target file, and LUO will only restore the
> contents and size into it. Everything else about the file is up to
> userspace.
>
>> The checks on the target are trivial: a writable fd to an empty shmem
>> file with the inode lock held while you fill it. A tmpfs file can't be
>> sealed, it only ever has F_SEAL_SEAL, so there's nothing to restore but
>> contents and size anyway.
>
> Sounds good. The one other check I plan to add is rejecting a target
> that LUO is already managing, e.g. a file that is preserved in an
> outgoing session and whose size is frozen.

I have been playing with this idea too, and I also stumbled onto this
problem.

You also need to make sure a preserve doesn't race with a retrieve.
Since userspace has access to the file, it can do both at the same time.
I think LUO should expose a "register file" function that registers the
file in luo_preserved_files. This should be the very first thing
retrieve does.

Also, today LUO core expects a fresh file from file handlers, so it
always installs a FD to that file in the task. When doing the "retrieve
into FD" thing, that will result in two FDs to the same file. While it
isn't a strict problem, it seems kinda ugly from a uAPI prespective.

Perhaps we should let retrieve signal to LUO core that "I already
installed the file", or a "I have no file to install", or something
similar?

>
> LUO will also add the folios while i_size is still 0, and set i_size
> last. So reads, page faults and memfd_pin_folios() wouldn't see the
> folios until the file is complete, and if the retrieve fails partway
> through the target is left empty.
>
[...]

-- 
Regards,
Pratyush Yadav

