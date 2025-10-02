Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B80ECAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 17:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520C88E0007; Thu,  2 Oct 2025 13:39:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AACF8E0001; Thu,  2 Oct 2025 13:39:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3725F8E0007; Thu,  2 Oct 2025 13:39:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 206878E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:39:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CA6601DFEC3
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:39:26 +0000 (UTC)
X-FDA: 83953885932.06.DC22F75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 29B7C1C000C
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 17:39:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OCHxKw3Q;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759426765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VfeBtM33yWSRKGpySMwO8DRmuqVNOBoCWLKZJzlUgaA=;
	b=iMS7VYyNffW4V2EOmpclsn3eS5Km4GwADKiAsRlS3+aVDS669Te8af60T7GD5VJBBQ+pov
	xFdQZaiqUAD0zs45uW5yaZLBQ+pht40bh6DTEVkN4uyOWDaUFESew8/Eiki+fOKmp0Et3q
	zUDgwu6pNPEsCzZ3yX/kUE3se005NhM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OCHxKw3Q;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759426765; a=rsa-sha256;
	cv=none;
	b=EHNtgrrHXRL1VlvRgncLwuJsy0vXmU9oMF/tZixNtwQfdE9PNla4B8Q3iK27DYCxGqUpA9
	xkpGkvsD1SNiixPc94LoWufILFCpH8DzsaWovnySyw1+15xYWa1AWi5hKyLqrRWlQKaK/f
	NuZmvz7tb8UVUBCJIW4S0o8FR+FKvfI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C1C6945270;
	Thu,  2 Oct 2025 17:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFBAC4CEF4;
	Thu,  2 Oct 2025 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759426763;
	bh=CpJbQiQzc/Zz/i3BHy97csps9TKRZRRFA7h8wc9Gjbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCHxKw3QHv9Ms+pj2fBRFuGDY0andUTExnAAnUFn8xjqxtx+2ZqTFaCOMfpno4uTA
	 ZCmUttYtM2OIxkJvLCbIkQKIa3DF8QZz0X+24NMCABVSFh86IhgNuoMk4umCwWvgtE
	 zYkzD110A5Gy0OGomks2/nungiYWmTKSiRbvhvAeJwSNEx9Xo6sJ1WwT3sLU/17TD9
	 n3aCqnZINIVuSUf16/+DLfWMyK9KQJFiT3XdYwRrvvyiFgRCJGWlTVR8koG+QnXIs9
	 7Ym7+aETMhBUleHyUFK6qf3omBfGQmQBJAWg4SfJzFvot+ng5e9YytXv4+Yqfta9Qi
	 1a319zyP2LT0g==
From: SeongJae Park <sj@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	Jakub Acs <acsjakub@amazon.de>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	peterx@redhat.com,
	axelrasmussen@google.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm: redefine VM_* flag constants with BIT()
Date: Thu,  2 Oct 2025 10:39:20 -0700
Message-Id: <20251002173921.58664-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <fc539c61-7a28-42ee-a28a-fef987967958@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 29B7C1C000C
X-Rspamd-Server: rspam05
X-Stat-Signature: a7ud38fq5pkzagfrc6c5jnezcmzpn5xo
X-Rspam-User: 
X-HE-Tag: 1759426764-196574
X-HE-Meta: U2FsdGVkX19JP/i8WLziUZJxlMPJCfvlxuUc9HJy50L0Ab9OGKio62u0R3jO+ash/BWmrzii+f7RawJDn/26A/ADvuVJxW2+FYPCydB7LswQS0E02is2vxSiyZ7vujVSFbVnCz/3rDoPrPaGTq7r7AyO6lMoj8BRpnyn+r/xIuDoNW7B5ud85E6RrYc2i2BtwwnLV+tiH7qYpcAxCddJgLl+1gLwPGKVkNzqJDq56uMgQOqcet2t1iuxPE70tpMvB63UuWvIKlz0iKUxWM10WAJ5h2WQPWVIjDSc+WqnlD9bYAVN39xeuDwzJwU3fUyLemsSceMNKsJDs712sinD5eKanEwbEABi6xIDxbyOMsRpnwBTftRe26+GgR+y6EiIIAlHmqBcib7lLIPS+4chFm9K3zP0wjmwP87IKYPGCD8aMUavuw3WVj7ZT/MfG7dR29smCVEt8tib442rPT8v+LnGr5DpIEi+M9RGiml59ZdT6RYZryiYkUgNiREn587HZrQuglqG6f3Bok2ew9abhSL8HYpiKoLt9LvWP/AgCMviNstamkFvFDbtSYa4xGF106x9fUHtsmVIVkHpc0VeVbOWP9WG31VcP9h3gvMsNwoKgNlNfaRvpABfmu/Q93NqxfT6X1pZW04B3OdSO9pJbEet3zVCAr9VIWtD+wi1jvMO5DcX4XVH+X0PlB8BnhsRkXJ934jcbCxbiDNvEU4nOssj7aEfWyTBHqXuxbf31U/Cpmi+rUPjykG7MHk7U71o8YQsBtZsxAoTJp+qry7h7H2dBYxBxgs4AKiOOxHlZhS1/nInu7f4eioSgdT87fX2gBKFlmrR9oK1onHcCLHmpwiKPZxT5VznR8n7CU2HXsY3v8RUuzKGp0YQezkuh2GigFTdSBo9+CnQPYQqf8+ww4HKhjvbQtcGnnGL177dz8hbsBz9pjq6VSr1ZMLTXvAUyA2eONG/p6Yy+gzYryw
 P0IhS6LW
 sADDhfaTIhNTVznFg3lcpk5ADl99jFje/65FwF6umicf030TSa1lGBWrrrQlbcEqMKEce7LdcXcjgGggoLfk3CyKiKzifgQBguDgEdATekyY9//o/vILjsS3Z8uqG9lUYHceKW3RH1L832UYUWxnVY6lfw6gKYLJ13q151cb09dFO4IF6W2NrlAS7qq6kHTj0B6Mc+wKBTNPV5sf1cMN5D+QO+BXcT2AMUpLRiv20PdrAh7MzPcUWKFC7ZqbgpDrAakvpnMYp0OldMLq+d8B3Ts+5F43UquEO89N1NxsUhDzbbV6KUVlWaviqszwsQxw9M3U20bnhpHXY4SqpAJ44lgNXRaZpHgSEauTk2PVFBUzVOBxrty+ulg/5BXRIhIyAOs4P+swgc29UrpV9D9cJhvp2/ON7OIt7oF6X4JfMzH3A5+PgKY3PCHfar73ZV952LdjuKCFuZP3faQPaop9x6u/qd/by+YZO/4mQ+rLkEQ8+WRxrPBCE9TPx0zDpJtJvyH2rvbQxduIE39GyQC6AlEOR5VwLdTxicMMn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2 Oct 2025 09:29:37 +0200 David Hildenbrand <david@redhat.com> wrote:

> On 01.10.25 18:51, SeongJae Park wrote:
> > On Wed, 1 Oct 2025 09:03:53 +0000 Jakub Acs <acsjakub@amazon.de> wrote:
> > 
> >> Make VM_* flag constant definitions consistent - unify all to use BIT()
> >> macro.
> >>
> >> This is a separete follow-up fix after we changed VM_MERGEABLE
> >> separately to isolate bugfix for easier backporting. As suggested by
> >> David in [1].
> >>
> >> [1]: https://lore.kernel.org/all/85f852f9-8577-4230-adc7-c52e7f479454@redhat.com/
> >>
> >> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: David Hildenbrand <david@redhat.com>
> >> Cc: Xu Xin <xu.xin16@zte.com.cn>
> >> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> >> Cc: Peter Xu <peterx@redhat.com>
> >> Cc: Axel Rasmussen <axelrasmussen@google.com>
> >> Cc: linux-mm@kvack.org
> >> Cc: linux-kernel@vger.kernel.org
> >> ---
> >>   include/linux/mm.h | 66 +++++++++++++++++++++++-----------------------
> >>   1 file changed, 33 insertions(+), 33 deletions(-)
> >>
> >> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >> index c6794d0e24eb..88cab3d7eea2 100644
> >> --- a/include/linux/mm.h
> >> +++ b/include/linux/mm.h
> >> @@ -246,56 +246,56 @@ extern unsigned int kobjsize(const void *objp);
> >>    * vm_flags in vm_area_struct, see mm_types.h.
> >>    * When changing, update also include/trace/events/mmflags.h
> >>    */
> >> -#define VM_NONE		0x00000000
> >> +#define VM_NONE		0
> > 
> > I'm wondering if it could be more consistent to use 0UL instead.
> 
> Not really required, and if we're switching to BIT already there is not 
> a lot of consistency to be had. Would be different if we were avoid 
> BIT() is in patch v2.

Agreed. :)


Thanks,
SJ

[...]

