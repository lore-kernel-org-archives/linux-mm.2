Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04FD8D2A532
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6538F6B0006; Thu,  4 Dec 2025 15:59:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629CA6B002D; Thu,  4 Dec 2025 15:59:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F936B00AC; Thu,  4 Dec 2025 15:59:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1856B0006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:59:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA44F88AF3
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:59:21 +0000 (UTC)
X-FDA: 84183004122.27.D33EB9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1FE9E10000C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:59:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tA78S6gr;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764881960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41V0btNF7KA2O1dznjGGyHba5bnZAFC6fB5jUVf1x/U=;
	b=6EKHWqUC+sqKuj1JRqHK8ZLZquMmqoJo95i9uVldmmOc6akapaYXBtPT53Eb9MPiEJ6sdb
	bUpbRVzd2n62a/asoa/kSCED0P10Yui3F+GCMUlPXKJ1kGkx79ZWsQGXE/+iuUicdLsQ0T
	OgEvB2MhS/+yNVYUwAyJZkTBt2ZRP8I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764881960; a=rsa-sha256;
	cv=none;
	b=iXINF7trb5l3sR9Uy19BRK/0P5PcNpmJ6bwgd1ZwsJ+c3C6b+PXoFqJUvWEu2eZrCDfFzr
	Vd6/P9k33VmzlGF6KxnzS3SCItTFLRLYe93MVCnF6fPoTQlayY7GifREvXCCqn2yYZWdLB
	BuJV5S7B/MJBWn+bDW8yYjjzStDDXwk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tA78S6gr;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E4FA443A6E;
	Thu,  4 Dec 2025 20:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90672C113D0;
	Thu,  4 Dec 2025 20:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764881958;
	bh=4O9Ah99qQTol32t/P1TpxoZv82j3pnx84+70Fb5YdUY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tA78S6gr+Qh7bTbz1ZeQsKn2yGl8q4Zf+nVGht3F99N8vJ/cfaY3BEbh1wNMwik04
	 6yI4dWNE7oOeGtCS8nDKTWo023FfpA2DYMkTLCkIv2pNSHah+uEDPIdVrQ37UbYhHa
	 PEmBvcA84WFCfGaks4Q6Kk3d796ZNH8pgOvqH3/bZLB/x2gqMu5lY17lL5C+mbbxG0
	 l+fkHGM4GZfABuGw+vc9NNNnO7Zn6vH+qVtRfH9DEqIMQF0/UAxuZKXiAqcoKofPwq
	 t5jjTTwFiUSnt6w8ox3aYTVelANQ+D9kaLir7yFW1Pta6MLisJFL68Lpv0Cijor3wI
	 xZH0ghAZwUgMQ==
Date: Thu, 4 Dec 2025 22:59:10 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	akpm@linux-foundation.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
	npiggin@gmail.com, christophe.leroy@csgroup.eu,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, masahiroy@kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
Message-ID: <aTH2HqxZjmFHWlSJ@kernel.org>
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
 <0b007374-1058-487c-8033-4f0d2830dc89@kernel.org>
 <aTErsX-wfnxkNJ1G@kernel.org>
 <78af7da4-d213-42c6-8ca6-c2bdca81f233@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78af7da4-d213-42c6-8ca6-c2bdca81f233@linuxfoundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1FE9E10000C
X-Stat-Signature: kdz9f8f1y9y1zmmrerm87pjeoezt6yy4
X-HE-Tag: 1764881959-209636
X-HE-Meta: U2FsdGVkX1/9N8YpxhahpmRmjqKOKPmqZ7wCfjSm+PpAKdjMrdfSQy83JU65leOMABASHO5KnV+xFWAwUnHcaIG40af2rhs/EKpuhWtrzcdOmc6pKCahgR7cTMWjkSnMlqQ08K8EjC+2689LUJ3V80W6uyaLQoAzHw8xJXRIQwzmhYGhXNGJePXjVR9rik1a4K2kp1bwqMyegPQrsOQW+cl0T6JSw2CgHO90oQ/uSG0YQEIenHu9o7A9HkO4ThR25LaDCSHgggYWjWQPt+ND3PJ84VffCZBdOmFuho6Sr+DggD+f3dMWkR61roYBfAoqewSZYp2cR4lGYjJfy9tAzO5WRz7uTVt8HBvJHy6y61WUV41KnGsRLCOPX8YXQ5SOSx9oP//IKCRWIZ86o9/F04BeUNeAN0MT6/Ws4y2Es6PBcPvHnkiLYGUUmRBLziYBsb0nwEcHK9aei78T15j04Qpy5OY8Qk8j/XYvocC+fStv04IRGTGOWy0xo1sjbex7cZJxw6FNGPNxcVImjErNw0KFRFip2oN1EYFUAlE2Znn2XiXzJjsJ0TGYob7MgXHOpZP4lKrhUb5jcosbuk9P8jH/pgGhohq8hbRb0P2wCxQxrespj2hamEDXN6+DzDA0lQ4msCvHCH/CCq8zUqK7+kFwKrs8QWMFWmFWaUTp4j4xI0SnNy/Gq+uDDTjwwq/5qItTzjtJx/nrAlKXIPWYY1GFbECmeG1JlcGbn4l9OPhYtYi2Gm92X+I5g014sAOK0tFl3H/RWLP4iA6a/IYoWrIXeX1nXOYtH6UwTy+OuosdAOilQ6uZtMx4C44OsI4aYTYdtzOVOKK/asORrnojT8ikZLGXXqiRgpwrJBqLc0pnoKq7VtNVlbjoSo4rDxzC63rf1N8ENdd23wBCpCMXTT+Rylwye/X1CLMiluIuFxNr4z8FMQZfeZKLYgqdj41jbwOlNvR/0/Ug8woUwEk
 1t60GvCF
 TQMHe/716oVRNf90jGsb0eItJNmzYZ6VDwjFk3mEXQmXujmxZzi3OgUM1ZzlPTINd4M47bnaxPy0lUjrP7NOVZi466xKQtdT8v9cfZtJNzXAU8KtyQLU7Y59t7eCxPmtkxa7ykZny6RPbCle0dsKCCvbWjcC7Pwu7HL4ckcY8fh5WfrDy3ZNjYeW4n7+2inrtdYi296KjKXWONSsg/acyRa7647VuusViEVEod/c1cyF4sUm8AUHq6YENZbYmWXcFw7UdzdD/6nkIi3tYZJYYqXZJ143NBUw0IM+EOYkewv/DsJd+4BzPvdF+u6RmqL/PVYWRMoNPQAGKOUc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 10:03:09AM -0700, Shuah Khan wrote:
> On 12/3/25 23:35, Mike Rapoport wrote:
> > On Thu, Dec 04, 2025 at 07:17:06AM +0100, David Hildenbrand (Red Hat) wrote:
> > > >
> > > > The blow is is one of the git clone failures:
> > > > 
> > > > git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux_6.19
> > > > Cloning into 'linux_6.19'...
> > > > remote: Enumerating objects: 11173575, done.
> > > > remote: Counting objects: 100% (785/785), done.
> > > > remote: Compressing objects: 100% (373/373), done.
> > > > remote: Total 11173575 (delta 534), reused 505 (delta 411), pack-reused 11172790 (from 1)
> > > > Receiving objects: 100% (11173575/11173575), 3.00 GiB | 7.08 MiB/s, done.
> > > > Resolving deltas: 100% (9195212/9195212), done.
> > > > fatal: did not receive expected object 0002003e951b5057c16de5a39140abcbf6e44e50
> > > > fatal: fetch-pack: invalid index-pack output
> > > 
> > > If I would have to guess, these symptoms match what we saw between commit
> > > adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
> > > and commit 5bebe8de1926 ("mm/huge_memory: Fix initialization of huge zero folio").
> > > 
> > > 5bebe8de1926 went into v6.18-rc7.
> > > 
> > > Just to be sure, are you sure we were able to reproduce this issue with a
> > > v6.18-rc7 or even v6.18 that contains 5bebe8de1926?
> > > 
> > > Bisecting might give you wrong results, as the problems of adfb6609c680 do not
> > > reproduce reliably.
> > I can confirm that bisecting gives odd results between v6.18-rc5 and
> > v6.18-rc6. I was seeing failures in some tests, bisected a few times and
> > got a bunch of bogus commits including 3470715e5c22 ("MAINTAINERS: update
> > David Hildenbrand's email address") :)
> 
> I am sure this patch is the cause oh the problems I have seen on my two
> systems. Reverting this commit solved issues since this commit does
> impact all architectures enabling HAVE_GIGANTIC_FOLIOS if the conditions
> are right.

The issue reproduces for me with 39231e8d6ba7 reverted as well.
If I run git clone <linux repo> in a VM with 2G of ram it becomes
unresponsive at about 40% of "Receiving objects" and than git errors out
with "invalid index-pack output"

-- 
Sincerely yours,
Mike.

