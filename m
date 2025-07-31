Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E7FCC87FCB
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 01:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF1E6B008A; Wed, 30 Jul 2025 21:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD50E6B008C; Wed, 30 Jul 2025 21:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12096B0092; Wed, 30 Jul 2025 21:49:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 927E46B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 21:49:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1143F16059B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:49:22 +0000 (UTC)
X-FDA: 83722877364.12.96C61FC
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4FB17100002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 01:49:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iW3lBMCI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753926560; a=rsa-sha256;
	cv=none;
	b=4V24eP7/z1wTCu2XVwKjqJT1nlW4m+Q+BMaDCqsv9RvGNPIc18pPDLCAzN2GYFmIFCF0Bm
	9AgXkY84783wVG9p/Ks+ajdDLiEt08OROdO06bp0kvQW1SrJuWBgFSfXjmUaE+PLl4JhTe
	QehodfH+WCKbJ14h5R65oglHEryDsxI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=iW3lBMCI;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753926560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FoVQBKqrO0J50OdfYlBRAT9heWx+qni6PljTTrIPCl4=;
	b=mA+yrBWQqTZklGUpIoFwE+uJMs6pHJ2ZL6Vw7i2nxA7T1kUIcRfRgpX1CxeEjX76R3z5L0
	8Ghe56dXR2RsAKBJbZ/0SGah1BNq3SxIu3B5rSg96TWcRIx2DRXq3bi7gvK0AJjv4vHlIg
	4o/dA9+xuPAQ4iEKxxknpMPel2p/6NQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753926556; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=FoVQBKqrO0J50OdfYlBRAT9heWx+qni6PljTTrIPCl4=;
	b=iW3lBMCIEhMek+VOvbjIDEjTYOw0ONTDHCRWEH0PPO6TpKzfcP5lOyrQ8ival9oZLFvgFTzkQKtJ94IiOhjxL0qQw1+sdOVsrfob8wQMmg6oSx32PnIbCXH1HOlF3He2Hh80wtc+ML2/JJainzcedKXNkImmQkOVJKz+9u+sHqI=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WkWQwrt_1753926535 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 31 Jul 2025 09:49:14 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@redhat.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Zi Yan
 <ziy@nvidia.com>,  Matthew Brost <matthew.brost@intel.com>,  Rakie Kim
 <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  kernel-team@meta.com,
  Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH] mempolicy: Clarify what RECLAIM_ZONE means
In-Reply-To: <20250730201908.2395933-1-joshua.hahnjy@gmail.com> (Joshua Hahn's
	message of "Wed, 30 Jul 2025 13:19:07 -0700")
References: <20250730201908.2395933-1-joshua.hahnjy@gmail.com>
Date: Thu, 31 Jul 2025 09:48:54 +0800
Message-ID: <87tt2t9lkp.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4FB17100002
X-Stat-Signature: g1rfr96ktqmdmnd3ntcyg56e6iretpmq
X-Rspam-User: 
X-HE-Tag: 1753926558-532157
X-HE-Meta: U2FsdGVkX18IX4RBgsULxFr0lDsHXxt6x6oTezrdBCHeobSPRz6Xnc9M4jw9P2M2PUvDUQe5rhHvm7MJMgjWD1kOEFgTkrj72pEBI0SBEcvCTUGWHuGoYn6fkbx2u7MgvoDfm0MDd/AaMa4GxItmF6dNmeZvVjQLet45+/8ory9+jgokUDO8pIrLhyG+3ZiZxlAdpzK7hcaB1SBfE58Q3oqktZ5nGCAdsnlbnTMJcxehAlSpjXNW/n2EqbM6gR3HIuRazoWpcaki4SwfjtiSYXZ52SKDTcxhyQF5YtfCd0PK2mnYtlCQJe2DjQJ+3nQWbqmxDGRMfoquvsb4obR3ZRnwf2L2a8WojnGMD1hE3Ae8jWPrQaFgcmWrXXXOtoIPFUu14pofLiIhYRFCFlNsHl48yxJ8iL9MjbZGSfiT/p3VsWaUqPoHeh+S7zrr9gmRjsfDthraqDXDz1LBCk1t1SfAj7qYu61HAmFRzXkC9z1KKy+zWPRoqEorKviSb4ZK4plBh4zptQXvqniHQ5kkZVe3+CUAblJ7hRT1h3sWNWAJA1Msuf1M5sx1BClqMAjxW3lef+q3e0OIZ1vT6qsUheO5HxHpfHELfLcRPdX+rc9GEF4SFl/YNdUyYBp/JWEl8vVkjjAHv/DLKmi3ykdvu7gY8gvfOcm8pK8g3PyNwrMjHCsxEI8qJDFptsXTTjr2jmpOTY0xU87YxiEBqN5kmGdK2WcbYQJFYYS0JdfYZq4//LUH6CMVXx2i0GOfp2NvDE7RX8idVCZ80bOQrq4uM1zB7Rl617a0R856uyXnaCOGgm50r7B2THRP+ORHwtCTrRv+iwhzwxvAsdgyc9dN6c6P/A3nJaugb4bi3OeRSzgIcDFja9ps3FUZpnJFCc4HRCub+jynKgtOM683aTohvEl6f90HIlgkJThIP7Xz/ZV492i9nCcx65TosUaLxBWmFU8iKm284cDWt6dIk2z
 IV09hUR0
 xNX7geufBgH5KGjctYCYhRUXh/MntZy8QvVddE6y0EoNhp1oJ2RJNAiSStKn6eMl9s95OMG5jb4YQbyGlHD60cyjggSJp3VkNE4MvDyPbefyD899fRFqXRXRkTZw9Jn6YgvKbzTgIXO8o9KcMUpeggHoT5IBGtw2eWAZyBBV5lo3cXz+QQpvrvSa8NQ1PwhuDIjj9gQ5OEk4cTrAW8z6lcFsTaVenJo24BYmw6lqPPn8aosIuYNAv9qQfqNWaswLSIpLQYtxCRycJRIWa+FnfdE3DuwxaeApFsWss5FNQdcXcmftLCl+3TgERtPmWNQnSnb+8jw/MNG0QF6ibK0lizQP5PCL7kkkryxiNuyPRm/1Z7DWOBszE1nqtR68AbDtx+Mq/2MJ5QCmfGSyHTGSBV1iPDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Tue, 29 Jul 2025 08:58:49 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:
>
>> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
>> 
>> > On Mon, 28 Jul 2025 09:44:06 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:
>> >
>> >> Hi, Joshua,
>> >> 
>> >> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
>> >> 
>> >> > The zone_reclaim_mode API controls reclaim behavior when a node runs out of
>> >> > memory. Contrary to its user-facing name, it is internally referred to as
>> >> > "node_reclaim_mode". This is slightly confusing but there is not much we can
>> >> > do given that it has already been exposed to userspace (since at least 2.6).
>> >> >
>> >> > However, what we can do is to make sure the internal description of what the
>> >> > bits inside zone_reclaim_mode aligns with what it does in practice.
>> >> > Setting RECLAIM_ZONE does indeed run shrink_inactive_list, but a more holistic
>> >> > description would be to explain that zone reclaim modulates whether page
>> >> > allocation (and khugepaged collapsing) prefers reclaiming & attempting to
>> >> > allocate locally or should fall back to the next node in the zonelist.
>> >> >
>> >> > Change the description to clarify what zone reclaim entails.
>> >> >
>> >> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> >> > ---
>> >> >  include/uapi/linux/mempolicy.h | 2 +-
>> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >> >
>> >> > diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
>> >> > index 1f9bb10d1a47..24083809d920 100644
>> >> > --- a/include/uapi/linux/mempolicy.h
>> >> > +++ b/include/uapi/linux/mempolicy.h
>> >> > @@ -69,7 +69,7 @@ enum {
>> >> >   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
>> >> >   * ABI.  New bits are OK, but existing bits can never change.
>> >> >   */
>> >> > -#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
>> >> > +#define RECLAIM_ZONE	(1<<0)	/* Prefer reclaiming & allocating locally */
>> >> >  #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
>> >> >  #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
>> >> >  
>> >> >
>> >> > base-commit: 25fae0b93d1d7ddb25958bcb90c3c0e5e0e202bd
>> >
>> > Hi Ying, thanks for your review, as always!
>> >
>> >> Please consider the document of zone_reclaim_mode in
>> >> Documentation/admin-guide/sysctl/vm.rst too.
>> >
>> > Yes, will do. Along with SJ's comment, I think that the information in the
>> > admin-guide should be sufficient enough to explain what these bits do, so
>> > I think my patch is not very necessary.
>> >
>> >> And, IIUC, RECLAIM_ZONE doesn't mean "locally" exactly.  It's legal to
>> >> bind to some node other than "local node".
>> >
>> > You are correct, it seems you can also reclaim on non-local nodes once you
>> > go further down in the zonelist. I think my intent with the new comment was just
>> > to indicate a preference to reclaim and allocate on the *current* node, as
>> > opposed to falling back to the next node in the zonelist.
>> >
>> > With that said, I think your comment along with SJ's feedback have gotten me
>> > to understand that we proably don't need this change : -) 
>> 
>> TBH, I think that it's good to make some change to the comments.
>> Because IMHO, the original comments are bound to some specific
>> implementation details.  Some more general words may be better for the
>> user space API description.
>
> Hi Ying, sorry for the late reply.
>
> I think that is a good point. Then maybe in that case, we can take SJ's comment
> and leave information about both the implementation detail (i.e. that it will
> perform shrink inactive_list on the zone), and that it will prefer this over
> allocating on the next node as a general description of what happens?

Yes.  Something like this, or

Try to reclaim in the current node/zone before allocating on the fallback.

> On that note, one thing that I felt was slightly undercaptured in
> Documentation/admin-guide is what "zone reclaim" actually means. What it does
> is of course well captured by its name, but it misses the nuance of preferring
> reclaim over fallback allocation.
>
> Actually the whole motivation behind all of this conversation is because I saw
> zone reclaim preventing allocation into a second node in a 2-NUMA node system
> and was a bit confused until I understood what the implication of having
> zone reclaim was.

Yes.  It's good to improve the document.  If it makes you confusing, it
may make others confusing too.

> Anyways, I can probably spin the patch to include information about what
> zone reclaim is, in the comment block above the bits.
>
> But please feel free to correct me if you feel that the descriptions available
> in both the mempolicy.h uapi file or the Documentation/admin-guide is already
> enough.

Thanks for doing this.

---
Best Regards,
Huang, Ying

