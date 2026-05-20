Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E26A9CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 19:47:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E59C6B0005; Wed, 20 May 2026 15:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3968B6B0088; Wed, 20 May 2026 15:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AC556B008A; Wed, 20 May 2026 15:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6856B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:47:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCC771C0273
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:47:23 +0000 (UTC)
X-FDA: 84788832366.06.CB8AD7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3DE7180013
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:47:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMmjx6FX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779306442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zUBwN8Y8OEE9k8HCBknlKh/MvjhR0z+pYdH7MNYdko=;
	b=1Va31dDmZ1v5SnCfFKa4t4EXeNrKOfLBEJaliCi02aQdOFvukXETv0WVRKe7IX7Z6tDz40
	c6qkCdqrqBDG2Rx2FkBMUMNJGRgetvr+anJZ0XnZrcPAm9wKu76YhaPmfIghzVWkG+E7Xf
	pYQaLfBNp1d1hblHv0nPRl0UPB1zGOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779306442; a=rsa-sha256;
	cv=none;
	b=YU98It/Wy2dbIfangnMdPxy1NvnqtzDrNLJGfmjdZWT4Miw7D2K2FT9tsxzcWRnQYFN5at
	wM7/Fg3rd+qUekkaED+fA/XXS2tKNnVgOhYOubcgCRDJDi+559DUyspQDe/g/iWMQXGxrY
	Ftx0vLwKXvX41SpsfpTiuKG4qJGR5KQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMmjx6FX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7BAF601FC;
	Wed, 20 May 2026 19:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD4A1F000E9;
	Wed, 20 May 2026 19:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779306441;
	bh=5zUBwN8Y8OEE9k8HCBknlKh/MvjhR0z+pYdH7MNYdko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TMmjx6FX9tQLPrbTmrEuKeDzs+2rTIv8FXIedffRWHsWAZgOjw6PN9EDJEakAED9w
	 WuODt2sJrNSJLlHIBe52kIxtwTrQi/7nQcEHrk6bZXXGndZWLbwUdnQGjzE7o9+vNJ
	 U4xe8cGVppyq5Iges3rQureX4Y8IcvtV4O2q0qiEKBaCgBLh+D//j2lY+4Ii98VUVY
	 5EOT65OhI+GbpDS6/arXai2+aaWXa9uA/R4W8CVCqmBLQn725lglReyyqgok8Nlk0F
	 cwRBJIa0Lcrdks5YI+kYnQ8PEqBSjoAKfVCl7KvOCNHYARcJCcBViiLyxUn4X1LnDy
	 PLbFflHjMm8ow==
Date: Wed, 20 May 2026 21:47:15 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, 
	Oleg Nesterov <oleg@redhat.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Qualys Security Advisory <qsa@qualys.com>, 
	Kees Cook <kees@kernel.org>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v2 2/5] exec: introduce struct task_exec_state and
 relocate dumpable
Message-ID: <20260520-landkarte-blutwerte-31aada53a844@brauner>
References: <20260520-work-task_exec_state-v2-0-9ea88ceb09e6@kernel.org>
 <20260520-work-task_exec_state-v2-2-9ea88ceb09e6@kernel.org>
 <CAG48ez1kGGGDzHfEMVOWo_mSk-D5MaX+EtjqDju-bheuvhBYrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1kGGGDzHfEMVOWo_mSk-D5MaX+EtjqDju-bheuvhBYrQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DE7180013
X-Rspamd-Server: rspam04
X-Stat-Signature: g8zme8ggh5q4zxix6nxnwgei5ms1u1pw
X-HE-Tag: 1779306442-997619
X-HE-Meta: U2FsdGVkX19xpLzVXSLt6jz78EH4AjtPC/oE4TSxnBNEtalOxx4XYGIPBR+CjS5BA012tgzAE9Oq7RVjdB5usRpHDDhQKewZX1pHywYuqt+efoqKK5gNMnHmvLX53fWJQeSrhefbHqLQEQAKJRmhXf36Ht8QMtIKW+oJ1p+dHK7aS70kRgqizcUzgA7uAjodP+b66/XjZnWw//71Y4j7Ez41LikzeYpo9ZnWjXw6A/B5cYEmvQ3UtzHHMhctOnVhycl/Uvn/O9NUnWinn+RHNVZb4GsJTRRKvAmQ3KpMS0I5aEnp3ezhhyYJctOBuZ0pq3oZfxTgstD97eZ5bmR2mA1mH5OM4+ql//d/45/jj0ruOGid0I8H1N2oa/xIS6+xG6HrsKyKSqT5H5bDxcXxEeFdWZ5Se6N0PVJ5C1rD/F7hq0qAr6an/T0bbbgvGRW1aw+m94XnAhbxd2rvoKTHzdmcGW5s6gJViAVpfo2orMxTa41QTs6Rn7iBbng+9EdDo1VhZWnez7d5W/ajAM98lO/EXZzMhiB+gI4/OBfH42oBlCDQD4XCZgMsmhYRm/faOuHV0BymbKOewYzY315gHVfG9qANnpo+YcE7hVrvVUlphgySNwaSd+3d+McJAYncSLdh7AhNppINS/cKg5Pzxxwj/QYQchN2fEAaEr7TbSCr/cmrSFErIEWdTyZne10l3RRsO3dfdQ1XkPxwWus6JswPSumILVUbwzKv3GSHe1ZPsjgeEsS2ONYNPtNWwzum7+opH7+13O6m2DN1NyO2T0oRFqWBjFMfSUeY/qFahn7Yo0EJGCh2+1/gpH8zA9GkoAcFTjSR2fLKFWcBb8BTkGfrBUgtHp+Hn2hwhBZ5N/Lyqr95w9v1ZA5d8JXWMTsTWObMQBi6+3C3GsbXQ/v6GqK95h7JFKqphoesomfcZkiOZQNpusWFRnUyGTS/db2DWxwAMNysNurSjz1vmKo
 u8owXMLw
 oelXsqfKd+HvFqNDWcbtA8Jit6aMT6q6PebS1dRqUM1NUNK0OOaTJ2CxPsYpfXOF7OOSmp9t4Ez3j+QzDmcSSDJ9b8WvaMkLTbxVPBhzdiTKKMBNem0jKjoUYEfNaNUmaLjZPKyCgz4wxCkjn6ae6QpkWyCoBcxcXZazT47Gk/42dX4fwOLSFxCh6DDoJD3Z1rS5Nb9HKaS362D6hVzR0zU5pUe9ldhtOEw92M+XE/Ox7M4bSVN/ZJBMVNUSAA9mQ3yLWMV+bC+ghgGsz10keIFYpralWXDybOzx1N1E/q0lYpAatwZ5nkDp/cZ0JoP/UGAQdWP7TBUDiOB4hsn7ZYTRIBSb/bpphYq4b2xqCLeSZva6eA67FKkl+LjByG3WuEkhPIAzqRTX/DBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 06:27:56PM +0200, Jann Horn wrote:
> On Wed, May 20, 2026 at 4:43 PM Christian Brauner <brauner@kernel.org> wrote:
> > Introduce struct task_exec_state, a per-task RCU-protected structure
> > that holds the dumpable mode and stays attached to the task for its
> > full lifetime.
> >
> > task_exec_state_rcu() is the canonical reader: asserts RCU or
> > task_lock is held, WARNs on a NULL state, returns the
> > rcu_dereference()'d pointer.
> >
> > Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> 
> (you signed off twice with different names, idk if that's intentional)

No, that's just incompetence.

