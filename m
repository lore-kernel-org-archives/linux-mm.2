Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D954606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZwEcwZeS
Received: by kanga.kvack.org (Postfix)
	id 9A5CE6B05B0; Mon,  9 Nov 2026 07:56:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956EA6B05B2; Mon,  9 Nov 2026 07:56:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86CD36B05B3; Mon,  9 Nov 2026 07:56:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65AEA6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:56:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED84E4065A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:56:11 +0000 (UTC)
X-FDA: 85415578542.14.5F82C8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 545C3A000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:56:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZwEcwZeS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794228970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RlHXEngYq18Jj8tFRRJ8jj4MrDZLmQ3Qo9NJGm/ux7k=;
	b=SSRGYNm/l2Qhf+up6zXsO68DktjPVPhT7IfczRj0S57ORYAd1izL5bOXnnw5zbrFBcRdhT
	Sy3cvObgInUUHWDNuIJXU8kby1jJEEpXDJlLo/hEJdtIM7n6HXPEj71FPo395cvztwcpEv
	7caupU6ifp5gwVNPFOaVIHM7aOT0dAU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794228970;
	b=g16fxRp0VlKyRHiigJNrL+9bKqtLk2T1ebQMNSyjn9uKNVNjv+wcP+83f9kxbdi7mFSxnw
	SmKYinHUbFBMAS0RBMgLrXnqfj09NmKLiJh86jXr3pLljo3S8QCwV2ewakaw2dsYkZz56V
	cFlmYh7qXnG1T8Dfk3Eadp8p6IPsYGg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZwEcwZeS;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB6BA60D2C;
	Mon,  9 Nov 2026 12:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1481F0089F;
	Mon,  9 Nov 2026 12:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794228968;
	bh=RlHXEngYq18Jj8tFRRJ8jj4MrDZLmQ3Qo9NJGm/ux7k=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ZwEcwZeSanDenPa0eeRoFDyCiLtGCr2CMJ5FgJf5XZdSbIB0N8JBOb9RV7uCoDe1g
	 eqjAIdB2AoI1r84cuzlN+g0R+zafTQJzGQVMEiJyeMDWSGMw0cPlXQKn1bSmLEV/2y
	 QSEJ92Drya8zv0iK7yfGnYk9PFYUvsvv+A30rzX5Ffmcibck0nlEnj91yoBQR4C4+h
	 8pILX51p0G0GbivHQT0O/bd3QrH8Md1XutNjypqw0DiWLS8NODfHcgjjy78bdADmVC
	 UC+3gEv6E0ZJL5ZRsVG7mYCPdCFb6cCvOLfpa+byHIjPklVa7FXilFtfbTHD3zZ7Xb
	 9GQ9mc5d8rcdA==
From: David Hildenbrand <david@kernel.org>
To: akpm@linux-foundation.org, david@kernel.org, shao.mingyin@zte.com.cn
Cc: linux-mm@kvack.org, ziy@nvidia.com, matthew.brost@intel.com, 
 joshua.hahnjy@gmail.com, byungchul@sk.com, gourry@gourry.net, 
 ying.huang@linux.alibaba.com, apopple@nvidia.com, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261108142831046W_fbNCAFfuY0BjHPCCHgi@zte.com.cn>
References: <20261108142831046W_fbNCAFfuY0BjHPCCHgi@zte.com.cn>
Subject: Re: [PATCH v2] mm/migrate: fix softlockup in do_pages_move() with
 huge page arrays
Message-Id: <179422896536.6396.2331659018342056694.b4-ty@b4>
Date: Mon, 09 Nov 2026 13:56:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: ih387zrfmy8466n9i3ndq5xrkwu515ez
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 545C3A000B
X-Rspam-User: 
X-HE-Tag: 1794228970-853107
X-HE-Meta: U2FsdGVkX1/xCA/suet/XSoRYe0HalLHP9K9R9iz8pXx0ni/j+gvnCTDxEqHg/cEfWmPneDCb0OJdcpBAg75gM1XfIJUxHNzUklUZOxQQiG7CTqUUnz/avM5MrffolZGHWesLEBbrehs5Pif1WekqtNT9tJeDfRTSjzD4F76obWCpurRkN9YV7ItcjX6si3YzvLL1dCDxmYa1IcbY3DZ5izjzXy+NAek6K80uEajEyCrV5saGKOO6IY69iQ8fJy1OF9RzuGLF//fGHbn3xy3Del3WKKCo932dZO6xvpUsifRprztw/bCequTrUKoFEPYbs1Ts15Qo05ZqfBUukZwhKWjJJQCQPsl48PW4mUlDZg7p+EcwPuHdDp6Xvb0Qy0C9SMOHcK3NlahjPtIUT9URG0t1yuP7eWZmDjyJXCd3AdhKMKSj7sUKVz80bSScTFAOC6MRPVIFMrKqsyffUQr3LmIzVDk/z2WuOK4cPbuENEDaIPGDIFbGWGNi9p+tSwi1WW4mWwVBvuwYrlfUM4aACIi/xfHJQ13Tn9u/N+gm1MMFON0QKQRVmd+szK5UFzJeWTWWT/f5bQN2ZwvZqxoy64p/286xOz6JjCCjicJuCBZHjmF2RTstQEd33rlVxd4LxXJM0bQ6JopHKqiT3PwFhyCWjxKyNxnCUc3emrHFFMGkJQfh9dkE+h5cpmk9G8tR9YLYHjDPMl7qRFVALGrYfrBFfv254uwzKWAVG9ED1/EKjZKY+Wv3O+bN1JVvp+KHNTaFeJSZFSQQzxLDrbAw78cxD8z+krn/IWTy5e+Yjouhi1nxfvS0bqekTax5dQ/ahi17j9TDPSj0vL/8u3GABlYhtyLOsGf8dKOIoAa01tSROoG0EJ0qOXVsOfQb+99/WEVtZGPloxWFdj8gUS7nRnT8lSDvQ+OdSG1rdd4IC7rt+ZTJ68uZKPQdj9NbyT5LR4N3uMB3gpdkz+WRxY
 KbIbhD9j
 xrWwGGMdPGUkFE0rMjKmoeQTZDsmzQc0vHOPl++9gjflYcdL/5EXTsHli2kZEX2WPVWEGj8w/fnH90XzRT5r06BBwzKUZ49EH1CdTJv6V768Jf8+uSeFt+sbDAn6f3049JtiTg5nhxsWDSuumTvWfyf53L+4O7xsFtaLIAonfIKevjCgIa8bcdCVtQ/IOcl1LAhjGr+uDLz3BhNntNJoRRqZpvJgeSrVTzGdNcYt5a7rDPx9xmCPU65rnkKJEdvJVRd0WQ9E7j6qi/L8uVk2fOn3PshcsQm8Fp1k1cmtd+0NueEABDPqAzub4lYDqL9UD1OSSSY/dH0ORrr23Il53gV2ZJs3UQhpLWq7xT2DSBe/IWtg9l3wdP3PwAhmMyA9I17XQc0J6BdZMIuQ4O7Cpbpm5qiZL6l79RZZGpBorLF9zv6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 08 Nov 2026 14:28:31 +0800, shao.mingyin@zte.com.cn wrote:
> mm/migrate: fix softlockup in do_pages_move() with huge page arrays
> 
> do_pages_move() walks the array one page at a time.  An entry naming the
> node its page is already on is never queued, so the loop runs without a
> voluntary preemption point on a non-preemptible kernel; the existing
> cond_resched() calls in the migration code are only reached after a
> folio has been queued.  nr_pages comes straight from the syscall.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: migrate-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/migrate: fix softlockup in do_pages_move() with huge page arrays
      https://git.kernel.org/mm/core/c/e200153a

-- 
Cheers,

David


