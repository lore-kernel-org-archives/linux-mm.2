Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E636606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LNVf3e2f
Received: by kanga.kvack.org (Postfix)
	id 8F0D46B00EF; Fri, 20 Nov 2026 06:36:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F226B05B0; Fri, 20 Nov 2026 06:36:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5E36B05B1; Fri, 20 Nov 2026 06:36:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AF156B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:36:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEDFEA8C5F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:36:10 +0000 (UTC)
X-FDA: 85455293700.12.C57E9CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2F6EBA000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:36:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LNVf3e2f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795174569;
	b=OvXNxER/x0VDk4XKz+0D3upp9mFWbY5Q0YnySE9nd2BRNFFXlwb32Ps0sVmHKlEY1fA1Jc
	5j6RS61J4FPIlw7/KZiL9KnY0NBsy9oE/K2gEb3JMVyvlzKTnUvT8h3LqEl5F7/oPrX+z5
	vjCdF7ouW6wkNp5z5RVvLACTmbPuP6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795174569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIe3hOKLCnHqFNzGUF054ejmgeEIVGuZTJTbO+auWw8=;
	b=sWDjeHl/x44jS0uWvSii3xhzK5wo6TccEkybg/E5ihoHzSwR+K9qAPjGEFB2W2FkzFWeFd
	q45pJP1q5dtcNqnOGuWVBbB157Ry7uMclWzPoih4ir290faiLjkysphPRziJTyQvqHE1AY
	8AggwF8MZvArvVHIjI/V0kGYrHtAc+s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LNVf3e2f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D0EC6265B;
	Fri, 20 Nov 2026 11:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C0E1F000D1;
	Fri, 20 Nov 2026 11:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795174568;
	bh=NIe3hOKLCnHqFNzGUF054ejmgeEIVGuZTJTbO+auWw8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=LNVf3e2fuB6sV6i+MOVpjyM8ou9ybEJWd/y2YnESvyNqyqZDV/JUVifcofk3GSUh9
	 wdDRIJZgSFB03R34CTubN4uNtnYupEInqCHzDpZSNOvG391LTBj34OpEYqI8reWNJF
	 fxGiQTz24XlLet/fihwDGBNU9jRmT5QHyqZ4XW2KeqI+1m7PNKK022IPB1zUXwsRuf
	 o9/IvtHEr8a8yFSdiQOcoB9AEKq4dXLYytA8O11f5kEhZrEBfMs8qPfnTvKsOsJEaZ
	 wzbWR5kBFfbuI/qOpigQGtu4DM8/GbQsjMEEquZ3MudbSYuenkNEPnv/ezcqMiAkS4
	 oGlsk2V2hEp5A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: David Matlack <dmatlack@google.com>,  kexec@lists.infradead.org,
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
Subject: Re: [PATCH v4 08/19] liveupdate: Let file handlers retrieve into an
 existing file
In-Reply-To: <20261120-gedulden-rausgeflogen-spruch-cea76174d5e2@brauner>
	(Christian Brauner's message of "Fri, 20 Nov 2026 10:23:28 +0100")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-9-dmatlack@google.com>
	<20261120-gedulden-rausgeflogen-spruch-cea76174d5e2@brauner>
Date: Fri, 20 Nov 2026 11:36:01 +0000
Message-ID: <2vxz7bi73fby.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F6EBA000B
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: nwxkbx6pjwfkxdwjept9d9xhwqaxndpk
X-Rspam-User:
X-HE-Tag: 1795174569-827946
X-HE-Meta: U2FsdGVkX1+s/vr90gqC7ZCbODyAtqhpDkCGu2rfJw6bf5MMAUYXXRyI+ZJLDEDrOQmyMeT79gQx8vXvU8o1jIyGm5EbyzX0ttiVCAnVTUMojT/Ac7g9ssjLtJevK2GzRmwYMH8jm1swDP5w0i6u9jn7kK0ccNGBjZ/JMoDyycM1Jmf3mIcE72XJq07x6uAxVbKLUnlmmfxGPAZOgSB+tdfM8yXJaIGIflgoFmngrKjxqZtZFFPZ1tJQ+v8yVgS0sDFsX9QMcjWnfiwuWFEIvErgGXGGbiE7uGEFfyz572pQhlFUA2mdmRiBmvCDohnNi/frilAHcrC2ag8UktVXUinOxSUfqB+P/GRhKgXUbULTQ50xV+JskjQyQN7J0gjpA+asFqyUwoG1c2jWJPOHXWxJxacZpimKq1SEb0Lzbyf0zX3hUdMD/D6BLguuiYl7d/DKYfzRhle6OF9piNBZn6leONqXoSZyRWPoc9aosqfWGOMRujsGQz8WfUzdy2uE9GTPOp7W657GiIeBza+LYV1v65lkt87t9xFukp3W3XcAqYsG42NfECHkBx1uYSzdRLwJV9TBgCUEuz9ZDew2zpGiye/1bFXJqTlrYEF9Ew0dbkohEtNXzjUQuD6dCf0tbSkgfg5bwKnhjlmYQMpplI1Y+VvIbh2eUYVGS6clNSZVRol4ZJgAyx1HL+mg+W3Sgpn5yXPjdZccl5jKOEKqQaeQJw0dlhN4dB3v1CS/9I9/59wWuttTd+ObYiEUIfF7OCLLmB4umwD6l6y0GQ0TUvqSiKyhEcYo1tRDyXo6ViIY8m7xntHKBO4HC5zZoRjQDZ3crxY/J5B2G31VsNz7AXvLe16uF6UZcOQaqKJO9hNzs1S24G3bdfcfYM/EMbUF2r/SfySG3+3OuZq07KKGQ9ywoexplDmyD70pZyn7aDU7TsXIMVbRIuUEf2aYk4mjb8MNNGfhMQct9aIS1Fx
 VdqFiC+Q
 9zLsBw1XXGkIpirk7L16esXeK/sW3HW99l8y3EItr0DDqV2h5NyVlej4zJKJ1KTfn8VmWefIMZhHltg2vCTn7+j40GwsipselAcbFaJX2f7jAJXpy54KkLqMs2xJcVlPKlzcb8B8qcPRUKffmOJEQYup3IUEGHbeZYKFTYxlYJ5h8+3rJcnu74q/pO+K29YoPBnu59W/MPMgEIPBHBE91r2iwHpseWqKwvILN4ZVl2G0GXLVhduX/KsJg4Q+Sysa+JVlY9ZE2QJcSd8ni/wDA0OiFnsQrunMZmID7AsCo9x3uDw7PZtkibEZQUJjz4alttmIFEhiyKYXKLBw/7c17VMzm+b9sSn9X3BL5rJ34w53GK5utDXc0HNzNRe0XwTV/osxUrX0raiFfN3MHyZfUP5K6gjzOVdYPxpgJEPB2+yLxSv4+Bog28wZLwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20 2026, Christian Brauner wrote:

> On Wed, Nov 11, 2026 at 12:23:46AM +0000, David Matlack wrote:
>> A file that is restored into an existing file is already open in the
>> caller, so installing a new file descriptor for it would just leave
>> userspace with two file descriptors for the same open file. Retrieving
>> the token again later still returns a new file descriptor, like for any
>> other file that was already retrieved.
>
> Thanks, this looks way better.
>
> One thing: Please just install a new fd like for every other retrieve.
> I think it's pretty meaningless to return the fd number the userspace
> just passed to the ioctl.
>
> The fd number is also not useful as it's not tied to anything. The shmem
> handler looks the fd up once and LUO keeps a reference to the struct
> file:
>
> 	CLASS(fd, target)(arg->fd);
> 	[...]
> 	args->file = get_file(file);
> 	args->fd = arg->fd;
>
> Which means, another thread can close() that fd or dup2() something else
> over it before the ioctl returns and the fd you hand back refers to a
> different file fucking over the caller (shared fdtable etc pp).
>
> That also gets rid of @fd in struct liveupdate_file_op_args and the
> special case in luo_session_retrieve_fd(). And a retrieve into an
> existing file then behaves exactly like retrieving the token again.

I suggested this approach because I found it odd to return a FD that
userspace already asked us to retrieve into. Any sane userspace would
just end up closing one of the two. I didn't think of this race though.
I reckon we could return -1 in the FD that LUO returns, and let
userspace use the FD it already has to work around this. If userspace
wants to close the FD in the meantime, that's their problem. They don't
get the file they asked for.

While I like this more, it's not a super strong preference. So if you
still insist on having a new FD, that's fine too I suppose.

-- 
Regards,
Pratyush Yadav

