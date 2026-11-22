Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D67606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 17:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D2LgC6w4
Received: by kanga.kvack.org (Postfix)
	id B3F5C6B05BA; Sun, 22 Nov 2026 12:18:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF1B6B05BB; Sun, 22 Nov 2026 12:18:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8C26B05BC; Sun, 22 Nov 2026 12:18:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7296A6B05BA
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:18:19 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53E8212070A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:18:18 +0000 (UTC)
X-FDA: 85463413476.04.26A0B5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B6A5B180004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 17:18:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D2LgC6w4;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795367896;
	b=KXYofzd8VKav6hl0p7pICAlceukD/z9leDrUIrinlVTBBU6mWucjT3hzzmioeK3QWwhoXD
	Rt5Ib1mo3uLQMPqzbyiwLFV0kaxCcKS7z7nc5bX0ABi7f0l5JTe0TSCwjxo5oYEuVmCceq
	jH4IOcb2WctO7dN3eY4lD9SAYPD9pLA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795367896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGKXMuVis8cRkv30mPNpaMsvVpQQKLnxJm/yA1Jm/ug=;
	b=HyBy5GDdru7SeA9jgiFzv3QHX2OlEcbSRUIVOg2FKFi1aau80Fp28tSAJXYzzdgmsEf+El
	AXGUsp/q6jUqxk7Slx2OacvFPuxK8RIpCt8cKf0hi/SM04f5PvBsIwYIuzMLiWnYZLWRtk
	kuwy4TQWKP+DepnH13W4XjqvYJpEZgo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D2LgC6w4;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0C5041185;
	Sun, 22 Nov 2026 17:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E70F1F000C0;
	Sun, 22 Nov 2026 17:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795367895;
	bh=VGKXMuVis8cRkv30mPNpaMsvVpQQKLnxJm/yA1Jm/ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D2LgC6w4Xvsf4tl+B+40npG6+OEBFuxljDzDaDc1prmdZzy+B73Qgnfunp63Keygb
	 bh1wML9GzZ/keUz1upu48d5oFFJC/rYhp+0SMgCReNG32SnsoTOmTK/KgWGz+kkqkY
	 mLu0z0G0APRAatjPV1Wjz//C2VdLfdobznkV2hj+atE5eqjLj7bV8en+4pZ4hsAZI3
	 RlIHMuUMqL4hZ8VE8CxsGMac7POfwEig1xsvQUndMHolMOayBghcrmAbZHFtkcd0Vf
	 R1h45OYw6Uesbp4vmo150hH5ZI3ilnSbobG1SeGb/NA7Znnxxt21d8gFAS7IqGmnFf
	 wzuT9jDXtHeWQ==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 13/27] mm/damon/core: introduce damon_report_exist()
Date: Sun, 22 Nov 2026 09:18:08 -0800
Message-ID: <20261122171809.153322-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122131652.72647-1-lianux.mm@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B6A5B180004
X-Stat-Signature: ok8dyw8qiprxs443o74ihpajismyeu85
X-Rspam-User:
X-HE-Tag: 1795367896-36595
X-HE-Meta: U2FsdGVkX1860aJyCatPuHSxNEG8UP+pO3MkuMyPZrwVUZiKh7BrxEKh30gzs4a0Uc7/Xq58Y359dQXewWYTiWwKO6EbS99nrZO8m44NUo2cNakR6SU5kCsqftKULdHPgC/2w/Ie1xGXrbDsYbUkgXDT6WqUr6zuV1YkLgXYemsO8W4LtV6afxbDIvoxyOM9Sf1n+nBEr3axUfBpsrjVTMDlp16ldxjrbko8vol3CeH9Our2luv6hdNv7dajy6nBoGd8YgbttQHvlmlbOJnp8KmcmXpABVS9vpsJlX4JixGMTwO6/Ephxm8tfXO9sUt+7bGy2MyxmhGazVaAyr5eRmg/WbAwPkflUlNxvt21bVF/odJDsTATK3/Gfv8kRcbrQ5vuQF41JkPujziuRmKnA0PCn2bLYswtrPDnlNE+1JZPv23XRZ7ozcpJby7t7jyxcHkO4DflobzzO7U129eKUOqcgnVBSOLP+eEDVfAVH7uErHmtnKMwMj6Eybje98K56kVHiAunmVoB47YjNNAIDQduG6HI5fmD1iWHPTUNP4tt8Js2DLLKB0KpXrEGWp1VfbAQB2BpxoNmdrZzNTIvxi+eiW4/7ZvJCDI/jg3hF6e6dGdHK8XaaAqD9ASfoXLCN/Yz1/NdGeyl3TYWx+etrCAqh1Ea7FaebpYiPqlJdozZYfMsKHjisMc4gi/OJdLMJsf88z7+1b2KkNUOqg/aN90hbBMHPPpTS3k5GDEP96KdjDhVYRixwXW76WXl40rLEZiENu5fk9gk71dXQVoRPuJ9Qm1PV/31Cgp5z5T5a2Ju8Hy/4tf/CXtdggOapCa8PLb3usQasZc44yZDmzvcma9VNFxt/PuWTm7n+B4JkWsC4+/3hYoQpsTHS3kL6EvIT6vsNKC6azneIxYbUwrbg7ksIiGeipgRUKC3MbuiaQfKM2i7U+kyy58RnJFZ2hjp9+8uKYeslnWWGtL/pNe
 lF9QRHgp
 SemyrFwEc9zY5st+pikxQUbuKF/IyxLN3ncLrSyHu02Z+w/FfyTIBXg2o6/tgCwSN21rDwRz7IG1tWJNi1lVoaKxTROJa3x6nEEPlckVKCMPGG6634ptXvxu54uHvVer6RvfKZxZ5zVrSgr0Gr8Dqf9nwzNW3RfbvTtSGYwUppWqnZyBph+IHVHA7cYEOwG2HcnygHH+nWVLP+jf2E96Mr4lDpDz+1MUJl299xG4dQeh3++xar12UPLmTfd4lk7ctHWyocsMMCDJZjmpdh4mVtG0VmvO2jcC/+OsReSHJ2n2wuD60xv6jh5vyRX+BN0VLWG0ZtFjnEg2eoKw5MVIl1dIwTI4mrEyfkT95SSU0GlqkfsLtJKAFJxnR+h4Qx7BmRiE1WOSyAFC2OsNf3roCcEVVJ9TFIt9gxJYKbF3ueL4bTYpmu1budXawOiqytzzRlYomsfDgF2XDPwpgaewR8lNWDqcSdm3OyyH4Wfz3Aixbkw2XO9zsri1rOrz3S6kzstye+tduwRdwfSV6bO9YslQy9i25BKAItt5JYmS1KT6w/7jMgRVwyXDB0Ydem2NA0bml+Z7eSnKioUQhyD8Lziswmjii35ZuIzv47YNhCX+YC0eUT1/s6XFPNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 22 Nov 2026 21:16:23 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> Hi SJ,
> 
> On Sat, 21 Nov 2026 12:59:57 -0800 SJ Park <sj@kernel.org> wrote:
> 
> > +		if (time_before(report->jiffies, jiffies_old))
> > +			break;
> 
> damon_submit_report() sets the timestamp before taking queue->lock.
> If A is preempted after that assignment, B can enqueue a newer report
> first, then A resumes and enqueues its older report.  Both submissions
> succeed, but this early break can miss B when A is expired and B still
> matches the requested time, type and address range.
> 
> Could we set the timestamp after successfully acquiring queue->lock,
> so that timestamp order follows enqueue order?

Aveline raised a same question:
https://lore.kernel.org/20261122131652.72647-1-lianux.mm@gmail.com

Let's continue discussion on the thread.


Thanks,
SJ

[...]

