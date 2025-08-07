Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C81FC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 15:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE798E0008; Thu,  7 Aug 2025 11:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C58F28E0001; Thu,  7 Aug 2025 11:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B210A8E0008; Thu,  7 Aug 2025 11:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BAAA8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 11:58:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE0AB116D21
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:58:11 +0000 (UTC)
X-FDA: 83750417982.09.0EDD302
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf24.hostedemail.com (Postfix) with ESMTP id 590CF180011
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:58:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTpXlaOV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754582290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FG1TiY9/QLbU6IkXqXsNwmBGloYWvJkNch0YcgKgz60=;
	b=irwc8tslSyUV+7/VIcRiqY7eoXEuQVk4GWrg2HHDON5fIuN8Avsqw+iC9RanETPw0qo3G+
	jhVzYHH+y6We458HMwPQ9H2kNfRvAuB7xxYu/vUkM2nK/85HdCatrh8tZbmR4j3L6JCsuJ
	vg8aiuJiauh8MRg5yb8oVOri+kbwfDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754582290; a=rsa-sha256;
	cv=none;
	b=ckQp2/x0K4KLamUDxdMCn2VHViik3QJCpc5SwP81VgWZjux7N2+OwhHz5xYmhLKULkDgY7
	6eEjNYdMvxKtm+6UD5PGEW+Denpt763YoKR7xZMCfeyOPkFGIgL3BCYGYaT3iq+K/k/JAj
	3G3E3QKlFELWB94zAI2vwIgkDjIexCM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTpXlaOV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 4D02C5C2707;
	Thu,  7 Aug 2025 15:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6029C4CEEB;
	Thu,  7 Aug 2025 15:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754582289;
	bh=FD/LxcPGni3IIHeLKZstBs+UbIbv3l8UHKH1/4wo2Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTpXlaOVHb6nXsUTsQ3DV9tbu0j1ZSNqGCkpgK3mbC11IiT98agKW6XBspsYvK1Rg
	 FJQohNGfyCiNXvxpp4cLg+97A/4NNWKlglQmiUBhJXJsX2sqcsu91fIZMkz0mW28OK
	 aKFrCIVfv9SBXt25y3siLhF/LG8sT16C+mdzFt4PA4hUjmdeiSI27cb7uRk+S243cj
	 HKOHshz5+BGJ4Y+FfqSVQt8B4dCiDjFMxb43+XRQfDt2r4r/SI0cZmhU6ao1mjWDnj
	 GgNzUwmbNq4J88T3cS9l0a37WJr8+2PtDhKRtckvNINyNPuTJLltxP7SSpd5s9r5As
	 0NW/EpPbC/Bjw==
From: SeongJae Park <sj@kernel.org>
To: Philip Li <philip.li@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	kernel test robot <lkp@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [sj:mm-new 42/45] ERROR: modpost: __ex_table+0x1584 references non-executable section '.rodata.spk_ttyio_synth_probe.str1.4'
Date: Thu,  7 Aug 2025 08:58:05 -0700
Message-Id: <20250807155805.25652-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <aJRS3iAcvITYGKxq@rli9-mobl>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 590CF180011
X-Stat-Signature: x6u14bepbh165ca5wiy67jgx54pdbr5w
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754582290-886826
X-HE-Meta: U2FsdGVkX18rz2ZPul8j2qlAMIh0ZanNby+sVoa0EYosZA19MeJ0zHfYLNbevHuoT8Kn6sVT3ndKz14GfI75ABNN0rIh/oe+vpyqwN4GEjeOGsbSvmidKb7XkorUqUdN4nIZxcOAp7RCKMdUmWqrm/+ZdLJ4fYpRk7Obv51sA7WfHXUYWQPV0ZHySEa5QYBEpvGVwwuqRN8IP1cT4tnwNwfjXnKp+w9BnkqCONviW5QCej/aTYYR0qfXJSmLw92p5PB959h6PptCH+lfTomvAwznkg6wSYBNTGNtbo4Wij7J30YLcDB2Zzmqd9GvzbVVYWz/R0ig/00kwiXmcKKt/FHGvt6cR9ntfPKN1QiwSQZG4dgt8xxdzw2FxvVaVR4euB2VV9LlFrzrTn1YV4L/DfElwJKymwT4ye+5NFFxzXTBxiHIzQHfA63q8bhor1e1Ki/w32FGp068DPEI7CuhKU5c7UOSD4E2ZmEtmDky7ONjvCSHYkD+s8hMPpCcA68rq7UpCrRSxNZKxl4N4LUx2skMUoOpzkMMZbvehCDKlH9TrPF9EMTHvrIczv6o4BUTqAEq6OtO+22Akmxx5YdDpHmS2PUKFWcUWUH20B1OmLslkb5nidW/NZYHIatVWr43/WQiwGXZBZPJKrmAN8W/ZhzVrAZaDBeVwCxIm52hAHFonGPlZ6v43xbfVmVjsM3kPaqKIb/QwDoNeEWO5TinDo2nPMFTY5c/xkQVFpe1/5plWTsv7Iiru6f5bkDyZPQv+aEVkZDoEQn9H/X7ivGyT+VcXzefuw6SLdZtOXS34nIP25nC8hlVkpCznQuhKHKO4PvaHCRCSCD5wQkjSI73Z4UU9Q4gnMlZUJfsqDzqeQXmzGwcrflLasX5MSvbfQmb9Qari+keyjjs0otCdIBpXrdFu2xM7hxEQiiNA990BCQhCHm2KxccZ5VsMGO7zJHQsDm/odO4CzMlUtvz4sQ
 TI/cxHPo
 7pFW57Ku+vPA4uOZVI88ZRH9YoZeoqedoF2QwdS5kQJjd7lldyutgqFmoYmpX014Me/awIv6ZqYwEDYkCkYf27l0GKXX8rGAdsh1tJn/2zkfQx6XQKYy32RMg2d8BAI4VGnP9Z5JROYcGO2bA9/BA2tHOHUCJPg3uvKjHuWfD5KiVlkqrovjjkWEobwt7jpE6a9nWsTRkxeWw/2MxXrSYv3/cnIKy1fW6TFadyM/2J4YCo4vLWfVhqio+n8m06qjHYVSLCK0o93T9t7r/Ty6nSbHVzE5Sw5eYnyIEqeLytmHG7pC7KZC4QuAEgFPeqaVpoL2x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 7 Aug 2025 15:16:46 +0800 Philip Li <philip.li@intel.com> wrote:

> On Wed, Aug 06, 2025 at 10:51:38PM -0700, SeongJae Park wrote:
> > On Wed,  6 Aug 2025 22:43:49 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> > > On Thu, 7 Aug 2025 06:31:25 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > > 
> > > > +cc SJ, as his tree :)
> > > 
> > > Thank you, Lorenzo!
> > > 
> > > > 
> > > > On Thu, Aug 07, 2025 at 12:03:03PM +0800, kernel test robot wrote:
> > > > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/sj/linux.git mm-new
> > > > 
> > > > Not sure why SJ isn't cc'd when it's his tree?
> > > > 
> > > > Not sure how easy it would be for the scripts to figure this out.
> > > 
> > > As people might already realized, it is Andrew's mm-new branch.  I started
> > > pushing Andrew's mm-{new,unstable,stable} branches to my tree for backup
> > > purpose, since DAMON development branch (damon/next) is using mm-new as its
> > > baseline.  Seems it caused confusion to kernel test robot and other people.
> > > Sorry about that.
> > > 
> > > kernel test robot, is there a way to mark mm-{new,unstable,stable} branches on
> > > my tree be ignored from your tests?  If there is no good way, I can remove the
> > > branches from my tree.
> > 
> > To stop more confusion first rather than waiting for the answer, I just deleted
> > the mm-{new,unstable,stable} branches from my tree.  I don't really depend on
> > those branches on my tree since I can keep fetching Andrew's tree or using my
> > trees outside of kernel.org.  So this is no problem for me.
> > 
> > kernel test robot, please let me know if there is a way to mark specific
> > branches on my tree be ignored from your tests, though, if you get a time and
> > have an idea.
> 
> Yes, the test bot supports this to ignore branches by pattern, for example,
> 
> 	branch_denylist: .*-wip|.*-v[0-9]*|.*-[0-9]*
> 	branch_denylist: mirror/.*

Cool.

> 
> Do you want to just ignore mm-{new,unstable,stable} branches, I can configure the
> repo to handle this?

Great, could you please do so?


Thanks,
SJ

[...]

