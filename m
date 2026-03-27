Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A249410BA435
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2A86B0005; Fri, 27 Mar 2026 03:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA526B00A9; Fri, 27 Mar 2026 03:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7176B00AC; Fri, 27 Mar 2026 03:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCF7F6B0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:51:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 684881A101D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:51:33 +0000 (UTC)
X-FDA: 84591073266.05.4C9F736
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id DAAA2C0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:51:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kXxPCsMm;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774597891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPdVi31yYMgkdOGdMwmDGCPoWqEBQPdLwRzwUBvVOKs=;
	b=wEg3qFz05M2LiSkDE6uch+YnNToZ2s1piMdpbBUDJR+rU0hPZ6ZY+RmRfOlU2UCett0Z/f
	shY/Yc/Pe2on7Ks8po4RmsbdnNNCLpXRxuNoeTZ+/P1pUp9peswfGMCzxiMrvol4rcJw61
	DInB/qrTR7C9Mh60ifnWhTQni4IklNI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kXxPCsMm;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774597891; a=rsa-sha256;
	cv=none;
	b=wQRJTfD7BEmvfb3A83+scI6qXVjOj9iit3a0vZQ7ivu8CVf4ROIIMLKQBjgALzIWGnllB6
	z4agOrgRlACNsNApqVEtcl0YsIVnM7OzoIFz+VqFVdfcGcMHope6bkWXLswlxHl8DOaR6f
	aMHtfdNxZmB4b6nK77azy/ZUiR5G+jY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 22AD660133;
	Fri, 27 Mar 2026 07:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAA66C19423;
	Fri, 27 Mar 2026 07:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774597890;
	bh=bQQlwZ4SeBxVMr54+IT9zGQQHRyh4SojeHmnIsWX4Vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kXxPCsMmsglasjUC56YN66BuUwkCXnonxDBVLcZlbpxknQvkF3ucezBc240psEPeq
	 aJi1TkZiKgApAaz6haTHQOtDpDifLpsFoERji2pyYLL83lLBzlu5lRUznjExBycEr1
	 daoR1DBcB8FVEG7g4C3SzMX8ZLbImaYPvIOzZo5ujEDBJH+mhpGx5grshS1ldmOb+R
	 3KExS2+cK3btkg7d05CdQFlHDT2dRaGxBxDUwhpO6rRnXcFC7NywHf2idJIyAQNugo
	 UjQX8iJLjPfL2RD+9EsG8LbLfUZU30NrUhmsfCBYc1O3wuAczR/9tlg5CoOYtShj+A
	 RIPml0qVQOSyA==
Date: Fri, 27 Mar 2026 07:51:22 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com, 
	yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, hamzamahfooz@linux.microsoft.com, 
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	"Harry Yoo (Oracle)" <harry@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 4/4] mm: memcontrol: fix unexpected massive positive
 number in memcg_state_val_in_pages()
Message-ID: <c826e6de-3ffb-484f-9abe-fe1f440e71e6@lucifer.local>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <e19052a28a7b604c012bfdfc900fd09543976284.1774447069.git.zhengqi.arch@bytedance.com>
 <54c2b09c-84f8-4118-96a6-acc13ca2f245@lucifer.local>
 <b6462703-9744-409e-a770-b9a7ca5fa198@linux.dev>
 <9ee51ac2-c87c-44f6-b983-44ac9007cb35@lucifer.local>
 <20260326170622.8fa7ca34d1425c241525bd41@linux-foundation.org>
 <0cf08b3f-6fed-41c4-8728-c925e8a55f29@linux.dev>
 <20260326201349.f63af08fb120b2ecb1623211@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326201349.f63af08fb120b2ecb1623211@linux-foundation.org>
X-Rspamd-Queue-Id: DAAA2C0002
X-Stat-Signature: zqyqahop8ztmo9nmpaoy6mn6jogb418h
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774597891-298487
X-HE-Meta: U2FsdGVkX1/KbHYhDf/q/7e9bF66PVMzvB0M9l0+RLhZKY3QkXbXsY1euJEMeZYa2QynJeWfP87FDOCAlNgAh/zjr9NC2bU0ENmv+V3zpwbtnNy/dJUht61CevNcYtdW5ODctMNI+gi6/R8b+bG7n9nWYx0tyhq3/zle5rsx7E84vIg51B1Qf0hO0TWIRRBKCa9AUd1uL0PFAzaxxgXtue0sBy40oRPtAyKdql56Qbq+t7/lZtR+mfV5YF73UdieZVzPlAbGwNt0cAh2dqPKiGmHBVr+2qi7/HIPtyStnAx3fZT994pPlVbO34zoBkwWvIRIaRGSt1zeWxkCHTAFkksrqRPybBY091hZaY+zkb1yJsu3J4BpPGof2qSd+BNXBqXu73ZkO6yZUgYxUIFGr7bKCcQVN9MYjJA/g6RjxP/rBcE7POIH+gK4uHtqNBcoEBCb25ipZMXXl6LRdfkcLl+bzEqamxgIlIFV0YvpFb5rIhj+ycoiCZay240JS7AJfwHgGViAKPromy/OgXz0eS07XXYTT0ef0Uu3B6cQXp4tmVf44Fgg8xcyEuA43ITP91mpB6PsTF222BimTjSnsFmqLwdf3G2HYnZ1zJXMpWa6zZg6fW8QtYxx2E+BBRqucSRUrVkid2kLk4HONIVf0Ol1oy4s5R/jgevqtVJyqjQ9+q9xpcO+n1PyDqULHar7Zfbtiej9hTncAz6W5AvmpNga2LdwOyc7+WUeih9eBNEQR/V7M03M2D6cFD6PLQuCIRlvw9GqMJ3DJM2DfmP9duMrZlXQW5XxL2g2C92LexibHCuWEdyKbpBACpNal7nFYL4cgkclHmrI3qDWKtOGVaVsfFnky+8hfL2a6QBjsheXkCjtgtv5/7TztkWsPcM85iS+vteXWHqIZWMCjDYJPOh9901glflKi+DLdY22TbFq9sLxWlu3/jaROJ+k5TKzzPoBnpFOHKWxkuU8Ibq
 bPZCHWHI
 Lfqjaj90QreX7Cqz7fAKL4pngAAqcUVTQjc0Lkku6bBY0hrVs/dgRqWmH8V1t0NmpkLw1jY62jy90M3bgYo6AFpJFE/PwOhDjWsgZm/ltli8cL+vXIvzfdCsSnVZN+fwFnJm0fxePtvpDb+vfIwkmzUbA5FSDatZQGkDkfJLD8AwJnGO4BTdHotX0EVCn4Oo1hiRGl9yWH8K0m9pchVNf+5Hy2ugvVZCvGdlt9wF4Mi5nXGj+Oupfx2Fwu+j6RPNO2wWUEpE9YCVJtT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 08:13:49PM -0700, Andrew Morton wrote:
> On Fri, 27 Mar 2026 10:42:52 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
>
> > > a) Redo this "fix unexpected ..." series on top of "Eliminate ..."
> > >     and tolerate the bisection hole (easiest).
> >
> >  From my personal perspective, I prefer this approach. The issues fixed
> > by this patchset aren't too critical; it's just that the counter might
> > overflow (and only with CONFIG_MEMCG_V1). If it can be included in
> > v7.1-rcX along with "Eliminate ...", I think it's acceptable.
>
> Cool, thanks.
>
> I've dropped "fix unexpected type conversions and potential overflows
> v2" from mm.git to give you a clean mm-unstable to work against.  I
> expect to be pushing this a couple of hours from now.
>

Yeah this works for me too, I think given low chance of hitting we can tolerate
a small bisection hole!

