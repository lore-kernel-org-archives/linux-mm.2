Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA51C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 00:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F556B007B; Mon, 28 Jul 2025 20:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE03D6B0089; Mon, 28 Jul 2025 20:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1CFA6B008A; Mon, 28 Jul 2025 20:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94DE56B007B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:58:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21D5359001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:58:59 +0000 (UTC)
X-FDA: 83715492798.13.C4393DD
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1EBF3180004
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 00:58:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xrwEEQVv;
	spf=pass (imf24.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753750737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8sHiU/z1+EfhzcvKq8hAl8DbAdb9A/SIystch4PdxfY=;
	b=8f4gA74rkVODs2dDnCAbuUrprjkA6lItrl28A2v4iBYTlWhWq/W3hk1ydK+DakxPfTN6xJ
	+Gy7zn1MLxoy3NmzFrBkIBPGduuRwWRAfT4O9AxKAcH5iX8lwE+w3youh6IX51+GkKmeBQ
	iNjheTRdZ7I2RzHsevV8qidywJPVvBY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753750737; a=rsa-sha256;
	cv=none;
	b=yN431iicE2QWaUf5LTeBZ9/G88y+Be1IMcgcDlL9enDpMVPrKTe5F+RAySQlzOosBwVjkH
	Wnf0lucMRanq6UDu/2wmbW136HwXjh/AGaU8UQFVVsqeI288mop4SsNNAiWWNPvWG/EDfq
	sS3YQ4c4fo0LS0rYuD5ou4w7DwFss5U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xrwEEQVv;
	spf=pass (imf24.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753750733; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=8sHiU/z1+EfhzcvKq8hAl8DbAdb9A/SIystch4PdxfY=;
	b=xrwEEQVve1hdA7jvf2x78zvLftnNc7oSXsyb08K9sz45qxTk2ofcEPWhyoPpJeDrT+N44ncLGhT+xbJp5jShxIgeFj3RViQ4oE8x4y+rebetnn2ZvgGsKDWVOP49ReOwi5MxMNJioIqkUD/gJRN6JAmvNxfF8/GMjbKdPu/8zfM=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WkNec9L_1753750730 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Jul 2025 08:58:50 +0800
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
In-Reply-To: <20250728145109.1524733-1-joshua.hahnjy@gmail.com> (Joshua Hahn's
	message of "Mon, 28 Jul 2025 07:51:07 -0700")
References: <20250728145109.1524733-1-joshua.hahnjy@gmail.com>
Date: Tue, 29 Jul 2025 08:58:49 +0800
Message-ID: <87tt2v24om.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1EBF3180004
X-Stat-Signature: ko6w68pqxnqzfayzzepmnsieisewtm33
X-Rspam-User: 
X-HE-Tag: 1753750735-925290
X-HE-Meta: U2FsdGVkX19K4pmmMGcNbkZJTavZCv4AZecWkCYlsTUf+CZX+EaGyYkHKl1WCoQughzqzqlGLh0YqdKb0BxQ8hDCYCEqt7acQVx3hzM174wStU5esrn+NDZKzFoQpujzbjQtnRiWnpEYVwd037NEw8pFWJDK0jTPNOOtnayDGQo8hZ1HCvD4eVKf1F3cuKtmdY01MS9SKlrF1JwBN81gdpSzGFKzeFxHa3wOhZOVZv6Sfq8T6sHdFPYjod+s5bQBxYk8+5EMRzDoiT/mivDPbt+0rWypUriraOLrri6E6f2MwuALyY5aGkn9THzF0SM+csqOl/O0pnJyDkT16/cLtvEQc3hX7l6uisiiZOuExM3NAHYuHwUBmWVYmI+f8PGRyqTtJ9GSyx4CRNkHeMqDCHLSES5Z3Xrq0HlqnPXAGXJsm9yx2U+NFuzN6dAfdcOni2/YnwA9OGLPKaSjm5yOxkLLa2UaucmA5VR8NhXamJbByfeavFCgCi8fezjywhhNjiK9QItk9fjmr6MHh4fqTheXk0NKzmpBKR+SIAJNeN7/8YYuTJZuHJQ5bgH11jcR7mvkGC39hhe9LPXdlGJoK20zYU8/GGxUap7hLMAnJsIgTXihitFZxcz/cPkaZJSQxO5Y+tGU6J0zLtnpWzx0DUBABYPFJ0NiO2MQYCHbHIGuhm+NMnNMi8T441kmE8BIq+2djiz29sVRhEi+jaBv78OsBv+wsc2HnF1wH+CGQNmcq8q1SghoLJKJ5SIqFwXvRhLl1DTdI/j8OKLB6p7lZK9Nh01DtGMwOKtXtjOThZ3oPlVEVyzbtIbW79IbdqlqFeu9q7VB7etmLbIU7kIB/WJ4aS5HGCVhgebGJ+P9AmN1NN3zElHJ+744GSKjuutthBkNnaLQyPIFaH0/WQMfG5E5euWmhYzYsDtuVtDRp+lplLp2aYXmYiFCtVrwY+eg+DCXy4W8q03rvzBikDJ
 B34vYQ6x
 p3z7On34s6IGVaHQfXDDOe1+UQZa+s42cAkfrIx7qy9FImZU+sNmkD/a6OdLJ44TPy9rKgr5J/LtZG5A4qeGPWdUNTk9TMbKKRMMvQ+HfgRG/IA7JiLRJNvGhzeu0RETN+4HNw/Jn3/uhmpJy64F1Uu78DXkOhkZXO3/6PsYGwGl+M0t/lOaZS2D3rpbW4t3CfLLH7xosAB3QCicxmvwVxcDX+SlA6ZjqHqjCEcspMxbMuT9KbgzT96KZLhJgiAzzou4u2f77xSwjDIHggG5DAVjea9R12h3uB6IonCAkcEd62QMf6sqZPSB9Ymd781MYSJ3ohHaBzojkyhv0vQCndqqpdvDLbteqZSiF35JpdyIgo/3PWycIMYvz+JRmSOhGZCT1eKdm+WqAb9Brdc/ZihK2iaQgf0ewsR4I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Mon, 28 Jul 2025 09:44:06 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:
>
>> Hi, Joshua,
>> 
>> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
>> 
>> > The zone_reclaim_mode API controls reclaim behavior when a node runs out of
>> > memory. Contrary to its user-facing name, it is internally referred to as
>> > "node_reclaim_mode". This is slightly confusing but there is not much we can
>> > do given that it has already been exposed to userspace (since at least 2.6).
>> >
>> > However, what we can do is to make sure the internal description of what the
>> > bits inside zone_reclaim_mode aligns with what it does in practice.
>> > Setting RECLAIM_ZONE does indeed run shrink_inactive_list, but a more holistic
>> > description would be to explain that zone reclaim modulates whether page
>> > allocation (and khugepaged collapsing) prefers reclaiming & attempting to
>> > allocate locally or should fall back to the next node in the zonelist.
>> >
>> > Change the description to clarify what zone reclaim entails.
>> >
>> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
>> > ---
>> >  include/uapi/linux/mempolicy.h | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
>> > index 1f9bb10d1a47..24083809d920 100644
>> > --- a/include/uapi/linux/mempolicy.h
>> > +++ b/include/uapi/linux/mempolicy.h
>> > @@ -69,7 +69,7 @@ enum {
>> >   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
>> >   * ABI.  New bits are OK, but existing bits can never change.
>> >   */
>> > -#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
>> > +#define RECLAIM_ZONE	(1<<0)	/* Prefer reclaiming & allocating locally */
>> >  #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
>> >  #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
>> >  
>> >
>> > base-commit: 25fae0b93d1d7ddb25958bcb90c3c0e5e0e202bd
>
> Hi Ying, thanks for your review, as always!
>
>> Please consider the document of zone_reclaim_mode in
>> Documentation/admin-guide/sysctl/vm.rst too.
>
> Yes, will do. Along with SJ's comment, I think that the information in the
> admin-guide should be sufficient enough to explain what these bits do, so
> I think my patch is not very necessary.
>
>> And, IIUC, RECLAIM_ZONE doesn't mean "locally" exactly.  It's legal to
>> bind to some node other than "local node".
>
> You are correct, it seems you can also reclaim on non-local nodes once you
> go further down in the zonelist. I think my intent with the new comment was just
> to indicate a preference to reclaim and allocate on the *current* node, as
> opposed to falling back to the next node in the zonelist.
>
> With that said, I think your comment along with SJ's feedback have gotten me
> to understand that we proably don't need this change : -) 

TBH, I think that it's good to make some change to the comments.
Because IMHO, the original comments are bound to some specific
implementation details.  Some more general words may be better for the
user space API description.

---
Best Regards,
Huang, Ying

