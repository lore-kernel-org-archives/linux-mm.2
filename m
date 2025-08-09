Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEA1C87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 00:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A037B6B009B; Fri,  8 Aug 2025 20:18:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4336B009C; Fri,  8 Aug 2025 20:18:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4086B009D; Fri,  8 Aug 2025 20:18:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 790826B009B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:18:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 358CF116658
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 00:18:34 +0000 (UTC)
X-FDA: 83755307748.23.539D630
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf24.hostedemail.com (Postfix) with ESMTP id 85B9F180008
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 00:18:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QLGz7YjA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754698712; a=rsa-sha256;
	cv=none;
	b=tOoB/iLlsk7qWhfkHKumymSXRYSov0Yl/dPINFJ/Za2nehWcMnEC+/TwOH4qRiZy8Sxkte
	yZQIWK/NRunNnzzTClOAhMkiqJRyrk8q3OQqDtQCPkkQCzhsXKwjCXcdAZnLKjGoOmCMyc
	P0s1fFmLlLJMNbPh6hgs3cEFE4zi/AU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QLGz7YjA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754698712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NZ5Hfz76U4JyCPZwlz+tmM7NrvUkEzOuwYd0kEZxwg=;
	b=yfgAf3MLPQYgCSaM+6wiJb8f9UE05OPciXRSt+LOTrXDZLj6UfoEDwvPLNUKxAvykSni1n
	Q6fHT/oCWuRmqINEkLJZH+8kHq0vKSRp4n4Fk4mMbQ4H95/q+UzNUvKDFhCIAdUBgJKedh
	PCxhC7qEDQqracGL5rutyL5ZU+yv5/g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 6F9C85C56CE;
	Sat,  9 Aug 2025 00:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDABEC4CEED;
	Sat,  9 Aug 2025 00:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754698711;
	bh=8doMMvey/cAn6n5o7Hp9cEa5vwfjbJoKSTQWo7Z5reM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLGz7YjAk8ddG5N5SfJAwWnXN0IJ5tMZGuITqwd6OGIXH/3Zf9WH3B0Je3kq89oj5
	 1AyotAOAaRvrcV+aNCdDqZWtcQEYYfH59RTJgMnyWTBFDpyBYD6A8uj1bicNtogtXy
	 TaHoXKXXmBLqpVPF4Ey/JVh6H9iqOQshwyvO7npSrp4RMEFpmtTQaK4uiMFIPt1nd3
	 nddIUGgtvpirpJAhP2PV2bdZdlxW6/kvY5U8iiPVMyM/j0uGoyW1BqqWj3XsLEwaqw
	 88ntL7uHRXxx9oXpMQy6ZD0NoRQjceFmUlj39yplZTeUyJg9aSPfZ3qoW23NxO9IL9
	 0co8f8fl4JJHQ==
From: SeongJae Park <sj@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>
Subject: Re: [PATCH] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Fri,  8 Aug 2025 17:18:28 -0700
Message-Id: <20250809001828.51611-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAKEwX=NF-HBs_sMMm5v82SHFnv5SUrNjOR-=6KJcxQsNt=26Rw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 85B9F180008
X-Stat-Signature: sbtsgppmm6x3pzm7i9yyu3xys3wrigf4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754698712-936999
X-HE-Meta: U2FsdGVkX1+WjSJznEZec40lvs2CYlKuWnQ+iR5xz9SwzAOx87mvdmQFfPs4bY+GNi11VswtVweWOJykt4abQRaXOMeIFjnX8f6YVqb6ilayX+d7Y1rGFzsn49kiTsQ9diG5SgAi9ZnbUfnFjbPREZfxuNII5zbeBmwvbeTUugtKLfUkz5bekVmXPRebdxp/yK3VN7u9rYoygvQA36a/RhHVzlEH3Av/CZ+Xb4MHdIfxS8VDF2cogBzcRsuEYhSFR+SM/sTfoDFATr7gcX3EKToMyindXssLF/FS7evZX8GJc3SFFfcV3V13e7y1xDJkvVAeE4xrRuaL5O4dpfn+/Ckg+Tl9ynyc2i0gDXwoiiak+Iciurz0NqrtZWj58OsRPqY7+d20mtHigbINbwWbs8mQHKJxIfF+V+07GKbVbe5mv8j8k9IqY66GqWJRF4zqaKtf4g81Cs6xPkBM8WbZXGpRLoUG3KZoUV4C4Y3G6Ap1ack366igrLkvbqQoSZHN4ZS477UfDEXQLOJyMc2+u4E0TyfVHnM+o8TUybpfoHMZ+VEjmFtLuTd7rHVGWeZYsx3v0e+ZULm0F227DUSQw8PvgP0RSzWCdhuWaw3Q7B6/XeysihGHM1x3YjEO4P9YVgp3K4wIRlseG969Xta2giaAFXNc2OQTa49dORZa0TU+7dzDWUcZMWrchVlW5eSuahIkGgMFp2I6rv5mvrRKjTqxFtClc4rZCLG2KKe+nc3QOVYs76ybhhp3h/RBcMueH3Fr3zVmp9OSIFjX8MF4JImhRHfCPheHJNkju8l1IW7GcN2Stud2ZiCHQr3GyPMDfDPfvFWVoa4/X67qXql3iGteSaSRJn3F7Eq6w7zul0MEJfi6wmyEXNM0J4XFK3i1NMut81SUfiX3U60IcZlzHkcVdOQbJnbwzgZNS90XmLRR/azVFHy5QVWk8GruXWRHZ/w2oQLr3iao+iQn3dl
 gH0v55wf
 ABtn+rQ1TpVOw2WAqo17YlmMNQWaO79FgrxvQk+GKCrC48QXyMQY2LTKCYKctbpitUtmPFnoC01y8nZoAgb8VM6SChnnhyhN71slHCUwoxyrM/k3v9CjkVtAbL3+mqbk9Iuym6oxeZ573qky5A1E9n3kD1Z1Bq1LOCToVADq+FEV6WsTyR+rKcQgh0f1582/Yx0TOpTw2rRQ9y8/AvKr8syBKe23LdpU/sFGkVeQSuJCvQrsJHCp5Y+6C5mXHz7jPFPlM7ut43ayozylWmLIEZPNBDq+gKNlvxeF46bNBg4ylNPR7G6ySekjf+uVV/ZBXgzsQ0UPVQSRgqbzFtO/7UjjhrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 8 Aug 2025 16:37:15 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> On Thu, Aug 7, 2025 at 4:54 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Thu, 7 Aug 2025 16:03:54 -0700 Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > > On Thu, Aug 7, 2025 at 11:16 AM SeongJae Park <sj@kernel.org> wrote:
[...]
> > > Also, can we fix the counter value?
> > >
> > > I assume we want:
> > >
> > > else if (comp_ret || dlen = PAGE_SIZE)
> > >      zswap_reject_compress_fail++;
> > >
> > > or something like that.
> >
> > I'm not very clearly getting your point.
> >
> > I was thinking we should increase the counter if we "reject" the page (does not
> > save the content in the zpool) due to failing at compressing the page's content
> > into a size smaller than PAGE_SIZE.  This patch implements the behavior.
> >
> > Am I missing a mis-implementation of the behavior in this patch, or the
> > behavior is not what you think it should be?  More elaboration of your point
> > would be helpful for me.
> 
> Ah yeah, maybe "reject compress fail" is not a good name here. But
> sometimes I like to know how many times we fail to compress, even if
> we do save them.

Thank you for clarifying, that makes sense to me.

> 
> We can rename it to just "zswap_compress_fail", but that's breaking
> API, so it's kind of annoying. Maybe "zswap_stored_uncompressed_pages"
> suffices (see comment below).

The suggested name sounds good to me.

> 
> Johannes, any suggestions on what to do here?

+1

> 
> >
> > >
> > > And what happened to the incompressible page stored counter? :)
> >
> > I don't get what counter you are asking about.  Could you please elaborate?
> 
> I meant "zswap_stored_uncompressed_pages" in your RFC v1.

Thank you for kindly elaborating this.  I implemented that not to provide an
additional observability, but only for keeping zswap_total_pages() account the
pages including the uncompressed pages, though, since the version was not using
zpool.  The internal counter has dropped from RFC v2, since we started using
zpool, thanks to feedbacks from reviewers including you.

> 
> That could give us a nice breakdown of how much memory in zswap is
> actually compressed memory, and how much is uncompressed.

I agree it could be useful information.  Unless others raise different
opinions, I will implement this in the next version, with your suggested name.



Thanks,
SJ

[...]

