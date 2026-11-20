Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1E79606A333
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 14:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OcpkTujT
Received: by kanga.kvack.org (Postfix)
	id DC8AD6B05B6; Fri, 20 Nov 2026 09:13:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79D36B05B7; Fri, 20 Nov 2026 09:13:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8FE96B05B8; Fri, 20 Nov 2026 09:13:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC6AE6B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:13:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A8ADB1C421F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:13:50 +0000 (UTC)
X-FDA: 85455691020.10.557FDCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E515E120006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:13:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OcpkTujT;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795184029;
	b=ESXqkAFL77Hj4ODedRPc3S7HBUTIkd0zjzpk/+O7dVPGdPDkJxiFeEYGC1HuVgylHXzpRL
	5nnpdVOMUHnH37vN55FggHD91WBEqzm/zCp+M0lN2gi68i6h8CX1bLgee/vqkv2L0ANQa1
	sPupFnx22d20lo0hjJB9HrY65Pwkhg8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795184029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7xxl9ib2LqWIPIDuuTmmVpFcixqIcABe6BvoXtmroY=;
	b=TdvdXDJpP6UN1uQy0l8TUZP90MvXK9G/b/q9bBi2kk1Jem8anyX9rzw8sSa/SZkLsh3ZP4
	ZudL8FJc1/BLsWo5F2ytgyadvGBpRVWHDZ1/rgLezdF3+4fFfQGSya10o+R6X5tT220NEr
	dhq389XaU97VP52Z9F9MvjcQWwG1l28=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OcpkTujT;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CD8A4128B;
	Fri, 20 Nov 2026 14:13:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D0F1F000C6;
	Fri, 20 Nov 2026 14:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795184027;
	bh=p7xxl9ib2LqWIPIDuuTmmVpFcixqIcABe6BvoXtmroY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=OcpkTujTra3EqsIxic2PIYwT7E3kKerIKzEEOgEyn7fGTy15YlySl/QtE57TmgqUJ
	 RiWqM0XSpS4wcSKDiOjICof/RZke9GxGuyEMdbIckGW3AtC/lL5y8FRljGu8MpIGxp
	 oetlVXJRiznDvhpKRl4Jy+j46LQNJHqgh/tVCuvrwmR7BZ4a+XLsxlbWQc89Epqfbr
	 UEot67d1cGwfgwEY3TEsrcZachRsEfYiAR62abMn+tIitXpJ8B9AithSGObQ0anX4W
	 XoFOSOhsCu2EJEwdb5bGTqk0H9tRAXFCpT5hUNW4A56SOThRw2eJbVPsdCqlOZLtd0
	 1qDlOGBBvPv5g==
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Ding Feng <dingf3ng@gmail.com>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Shuah Khan <shuah@kernel.org>, linux-fsdevel@vger.kernel.org, 
 linux-unionfs@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261119183039.1505892-2-ptikhomirov@virtuozzo.com>
References: <20261119183039.1505892-2-ptikhomirov@virtuozzo.com>
Subject: Re: (subset) [PATCH] selftests/cachestat: add overlayfs test cases
Message-Id: <20261120-zurief-ballon-beinfreiheit-4ff56c59f8fd@brauner>
Date: Fri, 20 Nov 2026 15:13:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-04696
X-Stat-Signature: 68aswmxjzkf7r6p1npw6cyeidxzqj7uy
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E515E120006
X-HE-Tag: 1795184028-516682
X-HE-Meta: U2FsdGVkX1/wtiWCgf0haRhysCj3Q/ekUaSWcx2m3FESOF016nXZzeY0BRRi0tQFPb8eM3FcVT+GoWfjNKKvDgbcAStKW4tQ0qhi8d7XX2ihYJSG4ZNnA6nyPCtYW+FdGJOhZ7Kdi/047jIZEJBqudH0l6Q0Wf6xehK13QejqEnY+wiB3xaUqyZ8fdv4BnH9wXeXQk9uHE7kg416mSxbXzB0FGNnnVr1YnfBZHYbU9acuDpNNbEam2Bdh0Z1UG14PYaVwm7FZn89U1C4qcgx4OrOmKpAzDNAsnanlGbcT71pqDv3+zpaqUZBFuA82//4zjIvkGI447Xw5Xz7qSkSg2nEfTL3RK4dE3CIpAEO+n5FWtPBRKRAnIacrABitudwflAqKcb0sPWXftc3onCXjwSExr6Sq2AsewGOqffKWC+erAsNtUD9TkXBQ+hBM7+MnbHSy5FkqLZHMrOm+DFwqqgJeriD4saEAbgy/j9VEv/nBTUhwAQcllL3cpt5AWm3fPu9eMsCv83fXLa0Ob4iTF2xdiZeaLrWgfCp2FKFG5qqFrNqh1pIbkP1PGj/YvLB7Sxws/0+TKyuCTEUY9litT6tZFwcdEfVaAG3IIGUGfr5AhGpZ4Er/G22URjx7k2fLWIuYt/uMQKjcFbh3j7oknqvD7WtXy25old9Z082A6azjpUjCHtJPQzxrRuRmnMQIdczn1AFhCI1fMOUdUzPSMEljThAJLvqE7n802zXDkKj6XjBSA5wiaABQiVobzKFDXt66JWEbN489Py08hw31ZBqhlE+7h28+UkvayBkzR1baK+NS8QmIHgmMctRy6cEm1uNbrv8+s1NNTKvjtw7itfPyFydAShEGDms9Gk36BZoCySr5E6Eq/AK18q7LyzWcT0h6lQ1EAQAXSsLG6ttiU55X9v0mW4jcUp+tBgT7P8bJhGdyN+dUbz7lBlvaqZOKhyG1uA4zJ9RsX2MIP1
 tuy3zrde
 L1F9J3n4fSbcHSnnEoitG8mLtYZ2g94TDOJMOfvra78TSDEXa+2UJO218O0Vly7O2C3S51lzzOYYVRdwgvwUyQytbRwilZak5jzGR8OwK3zVynvrjd5fvmjRLOWEhTnpgka3usLKFMTwGVWGx/FnN6RYHqlsA6H7Ge1iLtJSlsu1GKsF161AxfWwhUBx8Wd8/rScR1IVqyT+EbWibCZfSazQdjvekKPDrA430kURTw1PNvK2uegs0Udcntem0zfn7oqFKMSisPeHKAiGAj6b+igncB0IhQ93TBwXhHj1ENq7kW4uKPfN5wGV9DZSQ/XPp9BAWNcx/Vo6CSwFU/Gxh8AGa5KiyEQvjQImfXXw19KFcqtO+zKfB9pnlqL3nYOVhyhZMYqSVJwiAFz1iDr/S2HKlvevwO5Ks9KOcCpBOHDjKpGOsp4fUarcAUR47rayQO2uM9nk48m0ZTaZGwNv4ZA3Ldi1ZJ0XhzPpJkr39HCozHhw/AkyKcqnkHrpZrpF0C0co3mORzWkrwVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 19:30:40 +0100, Pavel Tikhomirov wrote:
> Run cachestat() on overlayfs files in four variants. The file is written
> either to the lower dir of an overlayfs or through its mount, so its
> page cache is in the lower or in the upper dir. Then it is opened
> read-only, so it is not copied up, and checked:
> 
> - through the overlayfs mount: the page cache is one stacking level
>   down;
> - through a second overlayfs mount, which has the first one's merged dir
>   as its lower dir: the page cache is two stacking levels down.
> 
> [...]

Applied to the vfs-7.5.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.misc

[1/1] selftests/cachestat: add overlayfs test cases
      https://git.kernel.org/vfs/vfs/c/ab5ec75b9f6d


