Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71145CCA476
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 00:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E94E8E0003; Tue,  7 Oct 2025 20:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 699728E0002; Tue,  7 Oct 2025 20:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588D88E0003; Tue,  7 Oct 2025 20:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E61F8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:53:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A22AA16036C
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:53:47 +0000 (UTC)
X-FDA: 83973124494.01.B02936C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id DE39916000A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 00:53:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="PT4mQTP/";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759884826; a=rsa-sha256;
	cv=none;
	b=sS4wQJzUicTQKKWuYjODspqfIpz4uvVzvGzFQQUuBtjV7LhVl32RbKTOg9FtTdBovVRcPj
	jWLUoKNzzNqHfqA4BoY927WpYmMgcFa1T4n+0kVeqomcWh6cSAbwiMIyUA03ngP1lz8d73
	QtFw6g7rUN52YFhasGf7aOSM41329G4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="PT4mQTP/";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759884826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6Us2eJbtOq+WD7KkAszcbGrpA0B58B3AL3OEitRlxI=;
	b=NrTVEJUI47f0aENRnecbX4/3/g6eh2ISNUqd47XQU0ck1BWGXE6k6Afv4dZe7wEswyl1Yp
	GTFA1eHriJHHXip/vlG8+TKLuToYy8/2z7HzpeSCqBoNsxYwnAS3JjmD5/uX7MAL6NTNdM
	PmkIpSvPpRBRVsqnVrrDk8WpOp5SY20=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8033144CED;
	Wed,  8 Oct 2025 00:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36594C4CEF1;
	Wed,  8 Oct 2025 00:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759884824;
	bh=1/BSCo/joxh3w0gawL9XVBCVbqacTF5mYaO97AtXT5s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PT4mQTP/K6GkWEsNf4ei2POarUVxGgv3MHpmHQcTv80pfoGWUt0yxbUzuKJSoyP1D
	 RTdHMumSMr2EloY0EbO2htHUtkg4jgpM8Dqbbd0EbEgX23Ovl+iW+6HYEp2cabfhRQ
	 ejoIL9iUlKMHQ5zLx+MTg1jnQ/Kwoy4S3lETa+10=
Date: Tue, 7 Oct 2025 17:53:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Dev Jain
 <dev.jain@arm.com>, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: readahead: make thp readahead conditional to
 mmap_miss logic
Message-Id: <20251007175343.107b17191734cddd7bbdeb54@linux-foundation.org>
In-Reply-To: <87play1fzy.fsf@linux.dev>
References: <20251006175106.377411-1-roman.gushchin@linux.dev>
	<20251007153424.1b46a4018e17d5dafd7fb126@linux-foundation.org>
	<87play1fzy.fsf@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: txk9w4f4syiug6bae6t9hw6sreazpnrx
X-Rspamd-Queue-Id: DE39916000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759884825-792171
X-HE-Meta: U2FsdGVkX19F5QRDgUeQgIMc0jVQ0nUjSC6FXZZJeM2Mf9xNmKLCCfGEWmiGiJmHE19XXRQPiDjTr8AVnl+sf/dOEjqO3fmQDmsGdbSwTSiT9jh0IzINbAmqFWDx/zqyvVfLphu11bFzkRJCnB7GvuxUREYILIb9jz9KkmBED1R6CYL0QhcaWkdRbE8fv8b5Pl9A5ip6rzLN68Q96u4j3q+7fV8O/NWhPz9AF3tQhh7tn4FFsk82CBzWS8eafwGfYJl/JVkzcu3N2Ue4x7lW0XxhUePTj1iJcVh4cRFIKGymqxdl9TIVs3RrbY9b3wFEqPzpqU+R0HcJvL0QvMIK7CI/hoISXWh2MCKdYG2MWto84lluTY8sthtc+5xYggYsO4zVofDAgzlljxxaRCoqiGL+LsEB8PI0+P0kbCyrsDnxCwPXBPMeMak7k+MQD6aHdPsWpvXgD7p1FvB0GLeYXle7FrzDwSgfESYao3tldsMN2F1rzI3i6KHa9Th7AG9alWhmD4nfoVXaJDvd/KEboeCmTbbEnxabyegie2SSUHxOPoYsd/fGamdZXoUZE6mIFPPYF2HpF2KRdzWK1hqUQ8wLZGUAT+ssVQTpPblKfRs7WznG8dS0i5db7O6YOFvmcB23tG+YB5cZAtBRGBTHqKH48HgMbafQm1nrvvn0xdyqoGS5MzizI01p3bwjBot4gS4+MueTHNst+Lb/NIoaDyAFw6Z9NApOyhLOTIfHjZTof0yLwdegl92qfsOsqmfZPBbVOdCEX0AHGLqWEfQKRxDnBqzBmQ/f28nDORwlVRGIh3b4uaV0fOQ+pCHwWyK859WdsBTi21bVYBOScXgWCDo4D4mysqZ0IqTLxBwhjz17omDkMAYlfPfze+/HorVBGNrfOddPYag0BSlFMohuAknzCf6EL69WCMH7x6xnU5FqfwxVWlJzHZOPJkjRY0AsdNEeqxG9OvIiqVU2aPt
 buKJTdH2
 kYCW2GlQ3tzWBGDZOLu9yC7521jyliFhp2Nbdm0Xa+z6bme/GwCjqf/PmwXKaJhh6F6Ywk56EB/bl+D6WNn+VUKElhcGnQEBeOfF2td760idJRJmn39AKaQZ5Gu/0NxHGZz1m+fQ34PQnZPWh0BN85/gzebGUOvf+8rKD3kgtlO+vd7RoWWj7JNI8GIeA3QCDAN2XqKof8yZTDv++rWSYw3w0kh8Ma/9TYLbUE9z4ZqdLe/oHvlTfmHTvaqmHXhSo1LUBb0z3NQqRSCqVXCqXGs1Wa+3hrdWzWRpY8U4FaEszbRwNdeLxxuzXjCMrEcV4tjhIytaWCHVXCC6viIyYtDgN/rgXxAGb0zaAOsTvsWYPKn7esYu/4uxg6W6eCJT39Uoi6n3X4rDCTu/3rXGTOXaJjL5Guh7j1SHd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 07 Oct 2025 15:52:49 -0700 Roman Gushchin <roman.gushchin@linux.dev> wrote:

> >> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> >> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> >> Cc: Jan Kara <jack@suse.cz>
> >> Cc: Dev Jain <dev.jain@arm.com>
> >
> > But I'll slap the Fixes: in there, it might help someone.
> 
> I'd do exactly what you suggested: Fixes + no stable backport.
> 
> But I guess it still might end up in the LTS tree thanks to
> the automation picking up all fixes. Should be ok too.

They've been asked not to override the MM developers' decisions (ie, mm
is special).

I'm not sure how reliable this is...  And I'm not sure how they
identify the dont-do-that patches.  Maybe mm/*, maybe mm.git, maybe
s-o-b:akpm.  But I haven't seen any transgressions in a year or three.


