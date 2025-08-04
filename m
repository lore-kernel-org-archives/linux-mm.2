Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5309C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 16:57:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BAC96B00B0; Mon,  4 Aug 2025 12:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3440D6B00B2; Mon,  4 Aug 2025 12:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20BE36B00B3; Mon,  4 Aug 2025 12:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 086726B00B0
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:57:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D844160828
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:57:06 +0000 (UTC)
X-FDA: 83739680052.14.C2B31C2
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf22.hostedemail.com (Postfix) with ESMTP id 23A8AC0002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:57:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RIkqJcqC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754326625; a=rsa-sha256;
	cv=none;
	b=WukuN7b9vS1635o70KUx1X8tkrQp1suQlAIG3m1/9qGulIVl62ziXEanJ+M75vkUr5MUM7
	QtvznG1MjZAm0xYZMOEtq6nZPI6EzHnxYugj2Q/05AvKZRnUepmzkp4We+2QkQgnxqQ4P+
	bBOLU8zHJe0ehOWPSOW00DZsKZ7nx00=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RIkqJcqC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754326625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qdnep49OoaH1ezrDNXXG3BM9LFFRvvoChf5QLfFPMeI=;
	b=gff4oRPMvd4XoeevlDV83LeJ5oQ6sheNiKg7M/Olwz9Aj6my3I39l7zLfbP7XmSnVm1i0j
	ji4A8jMmNHDFMCHBhXSVVvbKaFa+azAhEv8IV/N5+NeaHRcijzhMX5jgkiJ65bNfnAp2hM
	B+sl+1LSf7szg07tOvKVbXv+FsL2JcU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 6AE4CA55AB2;
	Mon,  4 Aug 2025 16:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D6DC4CEE7;
	Mon,  4 Aug 2025 16:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754326624;
	bh=KgrilMzrEhJRh14HSH0aWw+CjVXehntvFtCz3/m8aWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIkqJcqCoAt2/gW+CTzEp3bXhnHd7afe0dwZSB26D476vDZiWuRK7m5g2/ucoggUH
	 G31C9l9D63v+UAge+qfOZzllcrneFutLtwI/NVCqvdklXLZfw61dBryhna9eWzJohz
	 hQGsbVWKk98Mu4xgBg67zrKr9KZ+yV+wPv+e9IgyI4TN/jbnty0Gx/1vOuTbepQmzG
	 ZeiSciyGBQUnI1WcZq6tMBWFGCelGiTBWSusCeVaWfrlkjjjmr9olYOqAorTDo7pv5
	 DqK3zU5gVX2Zd1mgKdL25QWfnPImSx+XYi2398jYkS61PHfhXep4a6gAZJMMP5rgGN
	 qu0vUCNNB1c7w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Paniakin <apanyaki@amazon.com>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Jann Horn <jannh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Michal Hocko" <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	amazon-linux-kernel@amazon.com
Subject: Re: [RFC v2 0/7] mm/damon: extend for page faults reporting based access monitoring
Date: Mon,  4 Aug 2025 09:57:01 -0700
Message-Id: <20250804165701.55642-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <aJAfTUh-49pYuhbg@3c06303d853a>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ajo7kstx8pmxaktcfgijgn55obgceeex
X-Rspam-User: 
X-Rspamd-Queue-Id: 23A8AC0002
X-Rspamd-Server: rspam02
X-HE-Tag: 1754326624-654436
X-HE-Meta: U2FsdGVkX19+ZJ5oBsmeltQft8mD+Ls940nB/KP2Ofc8cyVzd/O+cNGEyIwyOFIzOueroHw6W/v9ykgeGqJBYRBTzn6mqj6Yta2QNeXPdxYahxzMRDdT20Zp1v3kT0QnjpjHxuDguNktAFh6DxhJ0p3+upHCPLYME2euCpGVdT/qLjW/uef6/pcHe9AUZGcK9VfeFLGq719C0XVAKvhs/n8gydMOzfRVThfbS3JAy39FKB6LaCig7aanpmdhnKb6VlZvCISCc6crVlj4PHt/wTc7kqpcTn6n2DiHQeAjIat+HfeE9OQPWXH7iMLwuiStucfwBVAezQ9TYqZUwqdOF4Iv1g/h9Wi9efjiwtRzA9lDhviezBI2HeVYg5zyXoCLAdJSG1HMagkEFEm7KwBEUzt7t5LKSqBtOrXppJFlYQHP08qqp0FHN19tiSDH94RtOaLGLdTn6erAiEycSVW/VkxBm/PSqqple6y6IWEnWcOcY5N4fPkWpIr+zBbWvQ2cxiej8PLLxBNmqTGRE7qD9U9qH1U8vNbk9GAL9ztZCcEdsdiAWbJNy34vceBNgSRPXOtvzdOIih4GLgLDRabhumO+qMMISOxIIAqqaGHrIE3p5StFP308mvN/l3anjx6pouHex/fOo0+zgJO2DCxJw6MXDM5UTE6vzTl0y1pmSptw/q9hZbIYptaYAVsbHjldZUl1pgRZiuC0OxxJR8UyzG2vHDsFOYjshBDyHUhvMVuKenkx4rcQkVHfrkZE+mHgwhS1lMWuZJ9n40I4DapO66duhXjxr+5sygXTUMroOy8xC5KahVkkoVVW9qEFbEQhij7Ru7WF+/WCTU49eVspTVbufCj57qcF7egjSdFx/ogxMIZiXqRLaKQ5fePffkSCVRh8I4EpmXN9P5oF83Y9vBEz+CGqP2zl4C909vIvHBvOThRuHg9SFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 3 Aug 2025 19:47:41 -0700 Andrew Paniakin <apanyaki@amazon.com> wrote:

> On 27/07/2025, SeongJae Park wrote:
> > TL; DR: Extend DAMON interface between core and operation sets for
> > operation set driven report-based monitoring such as per-CPU and
> > write-only access monitoring.  Further introduce an example physical
> > address space monitoring operation set that uses page faults as the
> > source of the information.
> 
> Thank you very much for starting this update. RFC mentions write-only
> monitoring, this feature particularly would be really helpful in some of
> our use cases such as lightweight live migration target selection, so we
> are looking forward to collaborate in development and testing activity!

Thank you for letting us know your interest, Andrew.  This should be helpful at
better prioritizations.

Now development trees of DAMON and DAMON user-space tool support[1] write-only
monitoring.  The implementation is dirty and not upstreamable for now, but
please feel free to test and let me know what you see if you don't mind.

I will continue working on more testing and making it upstreamable.

[1] https://damonitor.github.io/posts/write_only_cpus_only_monitoring/


Thanks,
SJ

