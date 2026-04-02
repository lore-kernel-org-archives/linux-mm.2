Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA54CC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082526B009B; Thu,  2 Apr 2026 00:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 032AC6B009D; Thu,  2 Apr 2026 00:36:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E64626B009E; Thu,  2 Apr 2026 00:36:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D38886B009B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:36:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E6D38B87F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:36:42 +0000 (UTC)
X-FDA: 84612355044.10.B2A4BE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 045CA180003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:36:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gqcNtByW;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775104601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wi97ymt/w86ufhdt4AlGhgoo5rwc3xArA4BR6lHRjr0=;
	b=BBys0vjR3y8uKKko+5dGYYubxRBc02Jb10CB5iyw1ZEDzrdmYwQJ+DCXwSbskdQLCVlVfN
	eVkJIKjZPSYUkdc65OWHAPoISEYOzraGEE1tSYgm1jJGp7/Uk/qqB6rwFgQh5J4lUFo6Sc
	upV5Q9NwdjiRBoRE+waFjCbR85vx8Tw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gqcNtByW;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775104601; a=rsa-sha256;
	cv=none;
	b=aFgCnllfzRGSr59SAjf1m38QgNcNA0jis7OcJrUalhl9J8y6VYohwkuWkIUjvTYh4Nue5i
	DCITaulGmH4sAOL+Q2Ct58bZL4VsWvHH5SQtgk8LIon5xHlDI7DgGJU87AneJ3YFBGwI8T
	yUWm6gthDKyYXjYXoer/9tJDlzUvraQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D21761858;
	Thu,  2 Apr 2026 04:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2B2C19423;
	Thu,  2 Apr 2026 04:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775104600;
	bh=BO7fsz3RgyTfGt+qlAE8Bxk0+VWTbQ00x2Lk1ONZHt8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gqcNtByWtkQTQsw0jAe6rL7YrwTF43tjIQnYEYJvhKocqUKTazKj+U0NtDDdgSVj9
	 PPPOcN5qR+/3PV9PS2bXWxShnlL9s+povpRCGvGMgKf0M/y4oEu/T0A0ObQecQnxEq
	 CZyLKctaCMPGy28ehZM4mruaAZtp5GRovrtzKuxrhTUnlWesSR5XUImiu47/SWZjly
	 96XCdyUiuPbdcEbb9+pM8b65GfTbFbm35BF1+2y/Ri8zF8ySeA2N1DrXbXmUTqAS7W
	 TSUPWUxcmY0cyJ+vZ3wuww5/gQi4I9fp3HUPq9XQDhd2/8gvVrhM6XBj6Ds76F+U/v
	 5o7jwiTOXS71Q==
Date: Thu, 2 Apr 2026 07:36:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 02/15] userfaultfd: introduce struct mfill_state
Message-ID: <ac3yS0F7clWYDptU@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
 <20260330101116.1117699-3-rppt@kernel.org>
 <actxscYZGFiyvUcs@hyeyoo>
 <acva_NKf7T5rbIC8@kernel.org>
 <acvnEd3-s6XI26vb@hyeyoo>
 <aczK4-vrULRiTvyh@kernel.org>
 <20260401103717.b236b271a2856d536a48663b@linux-foundation.org>
 <20260401104449.42123600e33e08b5ebad10a5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260401104449.42123600e33e08b5ebad10a5@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 045CA180003
X-Stat-Signature: zzg7nbaw41smnh5u3o86ibdm98x7zyr8
X-Rspamd-Server: rspam06
X-HE-Tag: 1775104600-78315
X-HE-Meta: U2FsdGVkX193K7Xo2Gs0V7FDYcaRzOS9BlkQIRe9xmpFSU0utX/K/oOg8JBT9/7YEaK/9047+YVh77CcmK+v8JBrFNop/xKd42WJ39ZVhW/Cv/nyQicPPT7a+1wdNT4pwsuvIU+Sb7We590DCDrqpKbSLN7+tJtP0Zw9dgcUrApLk1cugai0CG13UXAttBjXNsLmIFSXG07DoJ136EM4uQ3wUX8KdxLaCwPrb6zSAxlHPC8yS+8aA8eKnL/QcknfUJ//RBlpXBAq3NtdHIQ9Qn13XuxyA5CiMJWDKhRXs5rHuzhZhrMsZpbSuSGsN8jcqldLRo+LMFSrpram7Wf/fu889YKU3HDsXLzVnecK9sXAPppt/E8uAcFNWNnJaTmgHkyKSHycFVuIeaBel4ntFeyagxEcrKWU0G09m0i7qK+Xc+6TQCPbC2Vii0N/OW7qN7X4soJf2dsRE9r7CN1cDDB96D/oL/L5LlV4hf8N2BGU6lHxEU7/6QjBT07UGjTM39PGTKoa44QdsKsQ/2XiHYkjtsOMSmG9V9eivEGf1prZ9iVOfClk7RL3mNXIiUVQsnhN+YFymwfDWRmBWNVL92wM0rcRCV5MAC0rsUOvDfuH295ranp4TSqIYSKIzcQ0AliCFAB2cq9mmftB8K86Q/rCYOKRkTwFseVbfmm34W31faEuQbH6OY08v/0WSPVN30SvBJkZ2yy3zoAok0c8qLTOzOznnJVtE1Eq2JJNC8NPPlUo9H0Fcx5qjLcpHxdWO4xsHS/ezfiZgltK7uOlQpEzKWJX9E/S+x3G5HsbsTq6pe8wEf8R3Y4D6nhsZKxTZs8uQbFYymRz1cvFtm4b44zfMMo3qiXdUJqo0vEXKpkqFWm3HG92QLRyKTrtykWco4DOzgZBklCSNTz7pDAPV5xZnHprnG0Dmzij648NyAQ7PYVYuaT7jiGCKvl9x/Y3dgNQNL4gq8VI37NxlWC
 x1ccCvzt
 y5TtJ/WAWl2y6KuCrTT3IPSOTdKulydb4GsB6CvsaAQOywoj3SiIevgPE8quZ7+4j8cwLFsyy7Ma5gCOP7EcRmEA1tIcfnk8o6AWOX0Qy+PleryUDu6iT6w6pDCC7zvhUeZWWy+dE1QcIFJnGNk1Eb7cx0d8/3jRhee8N84P18nI6wpxYJc5mIFIgjnnsSMs8sHmx8KbH/kmzWaXjlHVWWLwMKv8faJUdwSo/x2AqGmdI60qHczw+xU3NzitOUczmz6WIh64w+ZTFyyXM1FI9DiHEAtYEK6nh6Ob7xufN2LRUUHwa4Rwc8JdM9ESgoF83hamltDs0j/wYmrh6U/uS8aB8GSZv1PnqqzGbUAcvMMvNL7bZofgUSvoFgwIMQrQmvk2A/DEwmq504ChAuGmDqb34JN2U4xDqq/0N5X9dJz6PFfzMmH5AIcDPK4cup4/WZRJQ8eRWmb1+V0F34yMJfQkkKqUgFrweXInmIQCLsxkEaIA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 10:44:49AM -0700, Andrew Morton wrote:
> On Wed, 1 Apr 2026 10:37:17 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 1 Apr 2026 10:36:03 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > > Here's a fixup (it causes a conflict in patch 4 though).
> > > Andrew, I can send v4 if you prefer.
> > 
> > Looks pretty simple.  "userfaultfd: introduce mfill_get_vma() and
> > mfill_put_vma()" now leaves things like this:
> 
> err, actually, it gets messy.
> 
> Can we please have a v4?  I think there are a few other things pending?

Sent.
 
> I've noted
> https://lkml.kernel.org/r/202603311743.uZYPu1Gn-lkp@intel.com

Alice fixed this on the Rust side and the fix is queued to char-misc-linus:

https://lore.kernel.org/all/CAH5fLgg63SYHQ34yqy7o2cA5f2Gh0aNTwTeQkzbWb+kV4Rr3Qw@mail.gmail.com

> https://lkml.kernel.org/r/acqrtd7E6UxrX6Ji@casper.infradead.org

We've been through this since Peter's first posting and I think there's a
consensus about necessity of vm_uffd_ops and the argument was about what
exact API they should have.
 
-- 
Sincerely yours,
Mike.

