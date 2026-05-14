Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95D17CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 10:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2B376B008A; Thu, 14 May 2026 06:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDBF16B008C; Thu, 14 May 2026 06:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF17A6B0092; Thu, 14 May 2026 06:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFD436B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 06:09:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A5AE12053C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:42 +0000 (UTC)
X-FDA: 84765603804.20.147BF16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A65C24000F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QB8ilueI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778753380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=78M8sg8j/5Lcv2d6orEU2RGDq4djTy0v54Dbzq+uaF4=;
	b=QEycGJPaPRi8/FQx8waLrcJaWfp9ZgHvrKGPWHaiQ5VFIGO2gOcn2r4Sruq781+Y+Ejkvb
	LVkedNnR//disENGi83If4Svjay4mD5280wDsEGZoKGu5Zg9OiFmmdjcyqg/LyxbmmxYwW
	gBdtnwcJDgvgGpTknZ3m4vTO2DXJN6o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778753380; a=rsa-sha256;
	cv=none;
	b=dOzXW0xoJtBDCXUc0oEyXwKlH7jW81N2QXHg76joGQA9AA0kK8DL1WvB1S5v9miQK0ngYn
	/zWS1mYt7P00wYkiz7XzD4OlxhrESKdoY83yeG5ihNmhqys0v4sxfm5NOz3G5RBl7XpHfE
	OwXz2DzNOQQXOWUu0WVAmYssTbLPetM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QB8ilueI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AAA06012B;
	Thu, 14 May 2026 10:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6FBC2BCB8;
	Thu, 14 May 2026 10:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778753379;
	bh=NHFi+ZN0DxhqAObytOz95z+znYJzoFR8tNEwrKza858=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QB8ilueIZ8dtkFqneoDKaezRhf/3GiLsA9b5zMPjGKXGJL+9UR5aC+ARkNkj6ZRnH
	 RclT5APtND4inI+KfpZgMrJQGy25w4H8b8qXH2FR8/EQg4uE73guKww/qBAonDWl5s
	 F/ufNuCEPoOmbMjqVg4nna+qCXMWGXR5W29BQEGn/6t38iFGD9r+9j8GBs9QOAJ8BV
	 FRvWKhKVDCUaG892h+7cHWHaRQPbf/+iSnAMikP5nYNGZgiE/smvfkkzYpn7zVLLAV
	 cusxM4UYYs+AKSXotZyGzXdlgXZFqjhnOJuMKfnjM1+G+eY5M8bHq1PeNjwDg8o7IC
	 0rpPhV8uZegPw==
Date: Thu, 14 May 2026 19:09:37 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Levi Zim <i@kxxt.dev>, linux-mm@kvack.org, rcu@vger.kernel.org, 
	bpf@vger.kernel.org, Hao Li <hao.li@linux.dev>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Puranjay Mohan <puranjay@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Amery Hung <ameryhung@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: kmalloc_nolock() follow-ups, including kfree_rcu_nolock()
Message-ID: <3aza75jldxj4g3o4kqdif3hubsnzkv53jvj52y2crohfxzto74@ofzzq2wfc4tz>
References: <esepccfhqg7m6jo76ns2znj2cnuaepx2xvw5zaygtwohq4psma@563ypprp6rr3>
 <9bea1536-534a-4a59-9b5f-92389fb05688@kxxt.dev>
 <6wvjo33urd5i4jvbf6rwp7kwe3ppn3ktgmjk663hq2jxax65gm@kxljf3hkqs5e>
 <1315d145-49ee-412f-ad91-0f6c61c4c2c9@kxxt.dev>
 <2dhbxmhg4l35gupk3wgwtufsf735rnk4czmcoyspzckvexie3z@nswohkoipx44>
 <be7a2a06-cd81-446c-9875-fafb198caf78@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be7a2a06-cd81-446c-9875-fafb198caf78@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A65C24000F
X-Stat-Signature: gc3q63c93breb3qkkfxje1c9farzrxhw
X-Rspam-User: 
X-HE-Tag: 1778753380-190397
X-HE-Meta: U2FsdGVkX1+4KRL/IOx4tDoikrAKap6HQ+v6LG11+tKo1/jiIRx8YBgeXOXW82HWnafBCqyKowYqj0wlIKH+4lDvT0//JJQFuWLgofWDmSdQ4IUu5LbmPI86qCIV9Any4ibWVwk3qcemAZmm5zOKFn+AlWQHrZnuLrYnnq2aMY2thrN16eRWTHnc5ELTwIjb8zC48yzbSdsQGhHKYOoBWYFIye8YntzLq36IBpXG0uJ9r9DVOj9QRAm5ICXz5Pa88rcHye0oG/mIFFvRTVEjnxlB0/CKjTn1e65am2kB8yHXfSWGxcSCZ3Bn0o0iSYTT7F8noDH9+5eokEEjfHVpYCB86NI7ay5qwh+7/YBsvaCd0z4YgxewcrNcwxcr/Q5xHKSXzrAwwg9X/4/jiTS3Yk/vVChsFyzP5wyd+p1k1nmxNQMiSd5ts+ipiix1B0/g+Igv8rhwIZ8EEP5sm5SY1WyE/d7XGtpZwHsLgGwD+hH/1/JKDn0WeYpdRH9H/Xt3ovuOTSjIEysSf1DzBVCR/JnZ55lCq102pE3O3w66P2b1uSPXxHCjmfayJ4/y14W915mOqK5MmeCJeXEXnsoa2oVShhq2QdUb+yMl9vXHVZ/QgDvQfqvcOVbwg9VCzkS2SxHKJjqpA4oAzPZEOeeNDVOm3s+zsYuuLu5RRM8muaxPjWzP4WvjqUtCzaW//Y56McnZwBcH91ayl7rvt9XN3W0Cwxse0+NZ0zMDDJ9/xSR/73pM92dXbVrQXwY8N8PU79lMgz/ZlKkv1T1npu4z7riCIfAd3zEAdHAqQzXtxiXuZypH56cuD/QRFYhON6vZ26SEe+2PCcC0cALPqEHQiihe8Gfc76vmYvhqZ/LMEh0U3gIuh0dZTj99o7rznkKtKmVzQJOl+lZnIS8Fj0WPxaC4xF7MACHc4qqcZni77IpYBwHBe7tWtqQHFSOWGlnxCINjwF4PN+LiRhJ1dj0
 7EFW/Jcc
 QU5GC7D0+H6j0dcatXvmSXMILis0Rd73w6otN675z0t5dAZxPJyOxvLTREHm0AQIH5gibeQOgG8rrhHxaCiKjG92KrMk4vs9ArfEN7IOAzMOgRMRZJnqhZ1GQKmcORgpqPWF6oi5+XleTM70VxcZ5XHr89jAkf53mimaC17k5zdr4wNIRDQqQvtR5dFVsrT4kdY02ZbZcKUXRq4kuCkf9V9CEChuUuygwlSUFWG/4XDlp598mlJBgURrgEC1jqkdtQ5zWhe54KHXhpYAbkba8bq3yg0qwtAJ53RRHxJMFma9eiI3/uJUSB3C7uH7WelW6LfsD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14, 2026 at 11:39:50AM +0200, Vlastimil Babka (SUSE) wrote:
> There's still the fallback to the larger bucket, right?
> That pretty much guarantees that if we fail due to a local lock in one
> bucket (due to preempting its holder), a local lock in another bucket won't
> be locked at the same time.

Right.

> However if local sheaves are exhausted, we might need a shared lock (barn,
> list_lock, slab bit lock when no double cmpxchg) and that might be held by
> another cpu in both buckets. But should be very rare.

I'm not sure what makes trylock failure on a list_lock rare?

When the local sheaves are exhausted, we're relying on either:

1) another kmalloc or buddy user on that CPU (w/ allow_spin = true)
   refills the local sheaves or PCP 

2) trylock on list_lock or zone->lock succeeds

Without async refills unlike the BPF memory allocator.

-- 
Cheers,
Harry / Hyeonggon

