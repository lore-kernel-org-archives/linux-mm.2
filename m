Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23430D59F6F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 07:22:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445016B0005; Sat, 13 Dec 2025 02:22:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F68F6B0007; Sat, 13 Dec 2025 02:22:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C006B0008; Sat, 13 Dec 2025 02:22:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 211086B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 02:22:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1D781A0516
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 07:22:16 +0000 (UTC)
X-FDA: 84213604272.05.39B3C90
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 011D740006
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 07:22:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=fltvT9Uk;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765610535;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jzmbE0f51Wo+UCICFtoAAZFgv4mhRqnt1ZueZdlnSx8=;
	b=1h60L6TD5quCBJoOGLeQizMn3dwEHI3ciHQCQvB0QLiaW13H/gFxh1ddLNsoCbh/gzqru+
	YYAOP9vJ7tdzTlEpIEM9kmlfEe6VJNVXTrNU85ANqau3zyr2m68MapXR4kBq5NK1XOGbHg
	AxqnD+6pbiE32HN6jmOgmSFu6z4sJWs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=fltvT9Uk;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765610535; a=rsa-sha256;
	cv=none;
	b=VruSNph99Eh98CV0jas2C1k08i7T80bq4KcrH4iIFv/16uyFhpuh/keIkWcwO6enHhY5EA
	6J5p0BL2NBXl4sMUhLgCrrDbkutr/H6XyR2nPvXg8MnMsGIVg2wQhTxPqjhagw7Gux9IXx
	Gt1uwzNYIAU9QfNrexJagqoLH0PgMkw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jzmbE0f51Wo+UCICFtoAAZFgv4mhRqnt1ZueZdlnSx8=; b=fltvT9UkLNu+8PoclHWABfa/2f
	HP7Y3G5hzMe/WHcqxamYDg8kJ0d3IuyU9ekBnCTzQBP6BmdhMKublw09N20RR2NEmZXzC+eLd5sWY
	+3FlgMt4mNa27kf1NTAZV+l4EUZ4Gqs5OEPT5A0pRWZY8ixYIIgzRY9CwlXkfJS9+wT4+eW+TXrsw
	MhMmUSyQjihqU+BTcdmwh5g5t4OCjvdacEHw0q3B+mJq2ugjQIiDrNkzL3AxOev0NlCZppRM+quJk
	StIjY6kJpegJZ9kwR2xgIc6HGXff6HhARQAdJ2Sz0gO0BYwacMRTvKE4n6acrOMis4b7Yy4wb55Tq
	Hl9JbqiQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vUJxh-00000008Axs-1dGQ;
	Sat, 13 Dec 2025 07:22:41 +0000
Date: Sat, 13 Dec 2025 07:22:41 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: 6.19 tmpfs __d_lookup() lockup
Message-ID: <20251213072241.GH1712166@ZenIV>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
 <20251212050225.GD1712166@ZenIV>
 <20251212053452.GE1712166@ZenIV>
 <8ab63110-38b2-2188-91c5-909addfc9b23@google.com>
 <20251212063026.GF1712166@ZenIV>
 <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
 <bed18e79-ab2b-2a8f-0c32-77e6d27e2a05@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bed18e79-ab2b-2a8f-0c32-77e6d27e2a05@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 011D740006
X-Stat-Signature: u4ky66kgshk7dypzj5sez1t7386tfhf8
X-Rspam-User: 
X-HE-Tag: 1765610534-338975
X-HE-Meta: U2FsdGVkX1/3XdMQv016uVv4rDsAzgSXFDxvss+HUg/2E3c3QZoAD1oD5ewBhqQNWnhpOne1Kg6mpRvMNbvjbKOSI/7xOvfXtzCPxjE/+TDFQGA6Eb7dORtkBPp1nAVLwzaiKbYadF1khCoKL2m9UcLqPUMVIeT47dQqhXB6xYfuEaar58Oo0900Qgu/xFzd6SLgqZe2amYi9RLiaZ38Ejv3ANM0zeRkC8KEYLV2zndCGVabIwWLLYzh4c64FXU0oGSAwl44JzAM+JY8mO0a4JMNBJWF63qKOxDMErqv7LV/er6n2CFkEe6u38b4ogJwmpxRiwxUSNh7Ew3q9rc8FBToPBMGYFuf8A9gZ+8He5sqnv05Ox/F+ZyMQ7GpB63obTtZ1Wkc6k3Lb41/8EehHWk0ooW6zPw7KuvV8LaY4Z+utp/anM68ILPwTgzKJpf0DTuzzCck7PSWfMXUjfvOMCWmg1QmU0ul1ujPGo6B7U83HprR89DI8BXcWYkH8hM/riix3SBkOqDQfp3wFrlBsiTC+Dki0PYHPUf4ljcBXNne6GUXJ0uA5YS7f9cA/GBXMMTfrr/LTZewXB5RThENvOwNOIZ3VTLToDGwSRfolMNqzLYofpj/5Y0wA0557p/F5oCCKbYzLgqjw4qGmiBvwezX6ePSmLBAjHEKELZ+SHsLHEZGOYZ1xEGCwH2EIXeJ6FO2wtB9D5SnmRF7bQdw0uhQkiCCfRiY8kLrVFOHQ1Mb+paS0To92phdEEs24zCLfjtNTdkGX9apqRBKvLi9L4JucQ/vzFEPhUxVVWsGbtmifldaqRWyAaEjLr+/hI1I49iYQVCRKKe/oaTWv/InpVMBBpJbz2ag0P729YFz+ebJtSmqPMIG2Xx6sbuvcyF0URcdjDbmTliE9sN63PGKEnMKgToDuoNiehRZ8JkEFrrQun/AB93vlDGfOWSCzvwgdOZcBLG9eh+u64KiCVX
 PNq4rC4f
 4t+KBw6MXX4wdV1sQmdd21RugrgCG6Gxj/RkKLJ3p0aecijgzKnGHf85fPdI1+TIJDOuR0m1PBkDjmSXs0+Jk1AFJZOyAi37wP06A3A191TlIQ1yxNiDSAShR5A2RjiohgSOcZQbNMuLBSOHwB5h5qJaYYGLnJTXUIP91oEzyv4S3NdlEj2Jn2vplqy2zgRbrWEIOEAZfdOdz0yO0YWZCPaKRNEH4pt2Rq+ms23b8a2aWYZUBhneLrZ+HBG6avpRX1RhfizXM9IFcx8iD/aT7EADwinAxE8AGYR81HPzghmLYdvdesTtbWJzlOGA9sd6YKFBbpE6XauxKVSM3RFzXEhB+s7MY1hEl0BZ+J1TqA4t8SkYEn+dZXaItTAURlErxtG4IqsA24gUTEgJAOCuVAPGNvTvPRbXv4syZ8Jmkne0yGBzUTzU4am+/Wl0AjrrgeCqjgL8LdA3PtNk5hs3W1YWqTRNz2S/tAZQpVCgvdYmIQuMaYI8uKV/VFhVWMoJCSKUL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 02:12:17AM -0800, Hugh Dickins wrote:

> Well, more than that: it's exactly the right thing to do, isn't it?
> shmem_mknod() already called d_make_peristent() which called __d_rehash(),
> calling it a second time naturally leads to the __d_lookup() lockup seen.
> And I can't see a place now for shmem_whiteout()'s "Cheat and hash" comment.
> 
> Al, may I please leave you to send in the fix to Christian and/or Linus?
> You may have noticed other things on the way, that you might want to add.
> 
> But if your patch resembles the below (which has now passed xfstests
> auto runs on tmpfs), please feel free to add or omit any or all of
> 
> Reported-by: Hugh Dickins <hughd@google.com>
> Acked-by: Hugh Dickins <hughd@google.com>
> Tested-by: Hugh Dickins <hughd@google.com>

	The problem is that the comment is not quite accurate ;-)
What it's trying to say is that we get whiteout and old_dentry
sharing parent, name and both hashed, but that won't last for
long - as soon as we get to d_move(), old_dentry will change
name and/or parent.

	The trouble is, it might not _get_ to that d_move() at
all.  It used to be guaranteed back when shmem_whiteout() had
been introduced (shmem_renameat2() used to have no failure
exits past shmem_whiteout() returning success), but it's no longer
true - not since a2e459555c5f "shmem: stable directory offsets"
two years ago.

	Failure, AFAICS, requires severe a OOM, but it's still
a bug.  What's more, simple_offset_rename() itself does not recover
from a failure, without any whiteouts being involved.

	What I'm going to do is a couple of patches - one fixing
the regression in this cycle (pretty much what you'd been testing),
then a separate fix for stable offsets failure handling (present
since 2023).  I'll feed them to Linus; I hoped to do that with
old regression fixed first, to reduce the PITA for backports,
but if I don't have that debugged tomorrow, I'll send the recent
regression fix first.


