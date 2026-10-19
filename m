Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9DEACCF2DE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D536B026D; Mon, 19 Oct 2026 09:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD7C6B026E; Mon, 19 Oct 2026 09:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FA9B6B026F; Mon, 19 Oct 2026 09:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33E256B026D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:54:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBD1B806DF
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:54:04 +0000 (UTC)
X-FDA: 85339519608.01.65381C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1CB1340009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:54:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TLtVbW4t;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792418043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/7HJtb6+Lht2UwV3mRdqEstIbANi/Ys/pJBas6kykI=;
	b=uKb8T3G6GEm05rDLHQjeeSRSXjIZZXNcAlBcKg5DC6ZA/SgZCszlw1yhCMrYmv94O41vaK
	C3SOkB7tbyVRceJGQ3n86asdVQVDiv9foe9rF/LvTkbwyjjq8slBLfzc0RCJienzzC18Oz
	hOPkp1XjX1Uq4dC+adn1NbjxT/GSwrM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792418043;
	b=F/pvacmLqOpuTHODiySTBRiBG646LhiPHLU2xW31uqWXX1PEokNsdP9ay6YLmjahuf6vGm
	Lvgfx/wcPe4VElzsd2fDlVn42J9cH4g5qrsZAW537UarQNY1q0YsF5xCuwbjUiEEBwWTjA
	YZF5M1THQZ31CRmDUc+cY+/XJ/5hSoc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TLtVbW4t;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A53C260136;
	Mon, 19 Oct 2026 13:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259CA1F000C4;
	Mon, 19 Oct 2026 13:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418042;
	bh=h/7HJtb6+Lht2UwV3mRdqEstIbANi/Ys/pJBas6kykI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLtVbW4tAFTyV2J2WBygjBhShYTN1UW44rrFgBJc2zNZFqpjTikm+kOY02YN46KvA
	 l2qxFi5A3tgPOcA75yuYVq3yvAla/0Zzvk4cQqzjhKEqSwKv3XYA4stUQfOoRPiFon
	 pUka423K81R0Gkl5Y7rbM7pLXkDIr6mzi5rPTWSKrpQRCumZGPe1ByJnIWm9Xu+L0w
	 eMT2xUHXdIsi01sJFczisu6PG2L+IxRHZvjGaO0IdSxc+w8IeRN8MrVwtODcK0fUhy
	 r6vT3JF1lE+fsuhSwtM1avcKQpsJDTjJ8BrYjy+ZOWm9OQk46vIMdindesBvuPvmCb
	 rRmiafew9Tk7g==
From: SJ Park <sj@kernel.org>
To: Dan Carpenter <error27@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] tools/vm: rename tools/vm to tools/mm
Date: Mon, 19 Oct 2026 06:53:54 -0700
Message-ID: <20261019135355.87175-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <atYOvqkdVSgjXZVM@stanley.mountain>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7qzo91t3j4rdi9dkuuquxjwzp6f7rjfr
X-Rspam-User: 
X-Rspamd-Queue-Id: 1CB1340009
X-Rspamd-Server: rspam10
X-HE-Tag: 1792418042-154991
X-HE-Meta: U2FsdGVkX1+T5+kVrYGENyEw/m6lBowjBmk18JVhpP4Z6KOzfEATqV2HnSnsnGg6a3asCrmjAUcTpOx0BISDV0XgJa+8O6Rp2M/pCqXCaBBrgLdboM6/kV/qwX/9mny0UHv5J4zLcrW5UUOP6cBcf4D20/xE7QK0TTfOOwgpWSrcujGA4R54nTzn8Gw2ULGyDOP54Un9IU+afCdH0jTce2ILRMKtxWHzoqlH9WfH8T14pyjAnGHUtP6+dQ0PwtgTYDqKgwff1hcBRWnlJhYAzTmQtp+wRXmleuCl4S+sqJg1Q+j/Vgpo/67uohJYHPmvvlt7wqu2UWAxAidr2ertLDFYFlmOTHgetGv9Gbfz/xcXQpyGdNGlk3pGFHcM4J/jRD9L5jaPAHx0dGVp3ha3moIhZ7p7FtDSMPodzKx1WA2JytRXXu2amVXZpQD5xIiQzm5JdiwzDGmrtob8nY8QUaimhmwuOr727UlDRL/hjcDUFrsG3Sw83rwHp9swSPVX7pkJ/03ifK9z0eIVXErA621c9B0JfF3ZDDl71wSl2upZWUFEPym29g/TFTGQQqPoWKIHz+eS12Z3LV/Ap4pcGGiC2+lPQwmAVdS0sDsg5+ao0oyAwr3YvPeLIX8m/drMgUGdqfvXhms3WwGmL/NzBOlEmmv095w+z822TOfZWs4VDtof7K4inolsRIn+Jju9GpEKPEMIQ+cW19BwwR5hrgAgqXC1eHPBxoiV27lmfEY4S6suFP4jlVi337bT66HMUKaTVqLiNacU3FFb5NV24ZAfRBqWXfo0CFfEqIEV6i3gquUnU65RVFwytyPlirwmo8MO9j6u1WjPD9eQjovED7wbvjzFhH7uSFHCyuzmeOwryb13acn04w7iPws2/LFgkSFBPZnwQIYcGmWRYXaUYBm+dIIjhmsK5osqs8IeZkMKxzvdWCvbLJMVBave7nC+2Q/T56cANj7ePlKBJfm
 W2OyY216
 J67umIH20Fiz7bXdO0cdJ/Am7Efw8Pssv0WC/oDx5fhX5b9mjYT3lUSwOPbMpQPWd0o9wdvZCGgug7i0PZdsVZEH8MdwqIEdCtcVU0khYZJ6sh08MBZTp1G2xNujuvFcpXj+XAk6NUjo2IFFVHb2P/RqiDn4dij1xqi/xebjcI3rbR+BAk0r1ZoEapEkl8esSIJIiP2PGVv0RyS9vsWUjq/0a1QMhJhNF3228OKpxZCXv/d9fz2AHv1qAAooCN/roTV73RpncfrCAZIDvuv6DxhrUqJ5g5pAB+2ZaQFjpA9oDwLO000yzvQVnvI328ED+5/EEFlEERFt9lPHnPDbqyeDu03X5O0ijjCIQpbW1+GA+9xYQq/4tZ9RSzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Dan,

On Mon, 19 Oct 2026 15:36:14 +0300 Dan Carpenter <error27@gmail.com> wrote:

> On Tue, Jan 03, 2023 at 06:07:52PM +0000, SeongJae Park wrote:
> > Rename tools/vm to tools/mm for being more consistent with the code and
> > documentation directories, and won't be confused with virtual machines.
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  Documentation/admin-guide/mm/idle_page_tracking.rst | 2 +-
> >  Documentation/admin-guide/mm/pagemap.rst            | 4 ++--
> >  Documentation/mm/page_owner.rst                     | 2 +-
> >  Documentation/mm/slub.rst                           | 2 +-
> >  Documentation/translations/zh_CN/mm/page_owner.rst  | 2 +-
> >  MAINTAINERS                                         | 2 +-
> >  mm/Kconfig.debug                                    | 2 +-
> >  mm/memory-failure.c                                 | 2 +-
> >  tools/{vm => mm}/.gitignore                         | 0
> >  tools/{vm => mm}/Makefile                           | 0
> >  tools/{vm => mm}/page-types.c                       | 0
> >  tools/{vm => mm}/page_owner_sort.c                  | 0
> >  tools/{vm => mm}/slabinfo-gnuplot.sh                | 0
> >  tools/{vm => mm}/slabinfo.c                         | 0
> >  14 files changed, 9 insertions(+), 9 deletions(-)
> >  rename tools/{vm => mm}/.gitignore (100%)
> >  rename tools/{vm => mm}/Makefile (100%)
> >  rename tools/{vm => mm}/page-types.c (100%)
> >  rename tools/{vm => mm}/page_owner_sort.c (100%)
> >  rename tools/{vm => mm}/slabinfo-gnuplot.sh (100%)
> >  rename tools/{vm => mm}/slabinfo.c (100%)
> 
> Is there a reason we left the tools/vm directory even though
> it's empy?  Is it for backwards compatability or something?

No, I think this patch didn't leave tools/vm/.  I cannot see that on my tree:

    $ git log -1 799fb82aa132fa3a3886b7872997a5a84e820062
    commit 799fb82aa132fa3a3886b7872997a5a84e820062 (HEAD)
    Author: SeongJae Park <sj@kernel.org>
    Date:   Tue Jan 3 18:07:52 2023 +0000
    
        tools/vm: rename tools/vm to tools/mm
    
        Rename tools/vm to tools/mm for being more consistent with the code and
        documentation directories, and won't be confused with virtual machines.
    
        Link: https://lkml.kernel.org/r/20230103180754.129637-4-sj@kernel.org
        Signed-off-by: SeongJae Park <sj@kernel.org>
        Cc: Jonathan Corbet <corbet@lwn.net>
        Cc: Shuah Khan <shuah@kernel.org>
        Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    $ git show 799fb82aa132fa3a3886b7872997a5a84e820062:tools/vm
    fatal: path 'tools/vm' does not exist in '799fb82aa132fa3a3886b7872997a5a84e820062'

If your local tree has some git-untracked hidden files under tools/vm/
directory, the directory might not be removed.  That could made you think this
patch left the directory?


Thanks,
SJ

[...]

