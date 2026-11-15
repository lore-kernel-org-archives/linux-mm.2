Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF74606A337
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 16:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jvHqkk7S
Received: by kanga.kvack.org (Postfix)
	id B9FFF6B05B8; Sun, 15 Nov 2026 11:47:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28FA6B05B9; Sun, 15 Nov 2026 11:47:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A18136B05BA; Sun, 15 Nov 2026 11:47:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 801396B05B8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 11:47:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E86FA807F8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:47:39 +0000 (UTC)
X-FDA: 85437934638.13.E8C6BC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5DD9280003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:47:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvHqkk7S;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794761258;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VHi+DdyTRZX0LciE1ZadFJ8slRcoMrJ27AotO0+Eq5k=;
	b=U7C5MtwlhzcKXSjjFkf+OUnkMFYbDyoCSbYu8Kkx0B2Q2guSfy4o3dz5gIYtUJYLiTj98N
	A9KUrH1WUHnfED/2Irxh4W4mgmx0Ees10eJNhp/uqEXp3qfGxr2EYV+ZkY+wj6lKkEu/lg
	y3CkoPXw6squp2VN1d2V7YxHYUUTnmk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794761258;
	b=HMksXyWfPX5cxjScggT8spjYIA01n4SjS9Ryhtbvtsosdtsm5ahgEatJx+IO0wylEVyKH+
	UPEtkfnUJABeJVWxnAzHD95Q0GmnQb+WqcYeW18gjbvbC8OVGsCTyz9pl0li7dg/OXiloU
	HHRt9rHt9XdkeFUQHrnZOOffdt2IC8Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jvHqkk7S;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7670615AA;
	Sun, 15 Nov 2026 16:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B51E1F000C5;
	Sun, 15 Nov 2026 16:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794761257;
	bh=VHi+DdyTRZX0LciE1ZadFJ8slRcoMrJ27AotO0+Eq5k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jvHqkk7SE9MXPdFBozdVLcRfFH3hkh0mPvIjksbOI+7V6lXXhNMmAMZ2hWK63dzOO
	 No/ORd3ont9Hmspr9nm80a2Pv7W6AY6JtqktT+PR7L/mjPzBfAn/vMCLDjV5TZvrlj
	 x+ITQelPeDLL2xNulsvPiJSj2YAfLENO0pDHn9j5s9Ic6Buq/Czd67NvxNMPg8zn6F
	 2uqVZWKjAXpZWpN9sb8v3WIWHeqh5VfXky8p/u4gzfAs9nGUXEBOCi8u7etnPOo8ix
	 tRr+xhM0VsLZ1ACdTXzsx9eGCwjgHin4CJclO0jF1j31u8+DmG6ghQlAJFerWlw+o8
	 bsftKIPB/volQ==
Message-ID: <sashiko-outbox-215659@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/kmemleak: fix scan period truncation on 32-bit
 platforms
Reply-To: sashiko-reviews@lists.linux.dev
To: shao.mingyin@zte.com.cn, catalin.marinas@arm.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org
In-Reply-To: <20261115004702358r2RJLihSrqbK4dr026bcI@zte.com.cn>
References: <20261115004702358r2RJLihSrqbK4dr026bcI@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 16:47:37 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5DD9280003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pqe3g9na5f5gupaxuzunia13z8ypdei6
X-Rspam-User: 
X-HE-Tag: 1794761258-803272
X-HE-Meta: U2FsdGVkX1+zkv40iEwFe7bfroufVo0gWR5BIoGGPe3KFwcTFOnBxc3aqn7tQKLWhlG8iIX9O2l+rokP0JxqYPcJXSzZ/EHBeYjsMVEt1xTQ0a+87kFSSDYUzymPBEpWcJuYKg+vwDuvahWaR34nzzCs1gqudVURFtsuN5yj2kUnMcdy+Gu7q+BVzGC1l9W+I83YFyYXXiGuzggi280FkjlXnIVfvxtek8bkhJOQIIve+EJDgmwRQJtoAQNCBUNafFpM0lTQ9q2btCNzUgX7N8kkuMAW1lDS4uSvuSPykwyA1m3hgc4V8ulC+ifuP6+5m5+RRIzQioGvulP+q6PKPskCVSY+CBuW54vAwiHZgEk2FRQDq5TR9WmMOTeG0jTFCgIygVYeFyZcNzSfIFfqoOEZ5a58dOyMJB0G3RNsx/fbp6rvEf/wly3bnFI0jkbA3P1/Vo9voK14Xhj9eJyCMdnebW+n9vTVTNX0Yi9X8n0VMQDMShN3nHwQgvhbXuAfZhGR6Mvqlk/EFXFimyURjSVlkXYRvpzui5u4WSu05B8xe049pnMqr7KZmPmrcBoE29joROpNWKFmqGWZ+iKF0L5sAcKnkfYYIe3c3IuMdBLoMK+baHksas0sGIWs02JEHqxlI2w6XoROx0CzTEjOkhqJaALwXkRm7b0SPwN2J3scjqscUkgRFMdLfMCu2LKbUIM+74HCS0kLdhPil0fPA9hO0etkkMoyni0qEliTGnx/UqEGAAyOXo2pM8LevxbnubTX3w5vjlNwG3z4OPf70+sT/Zv0AeMCVBzIMh6aQ5XpqfYP0oq8g0P144cKntLppeDgzDgQ09Q1SmTcaGUCdrkc/3WYQDHF47YdelzkKGjENZepD9TBpYDXBNkL7zFIdHmO1zj+nGEAbouWOS+UA+IOiHW47wYnrg+YYiX+7hUcfzj4fsCpwTWIEgluiJbANpNDn2d+FK9ohncT6RN
 xGh2rtMp
 xSMAQIsPJ+7VbYQKYzQEEkWyEhUyNbI0FiFoaVVhGPZa6KiGeeWFNUGWE9YsVA8mzEem7Teyr/8OFz+nMK6CUX0wfaNHYjToOCp1qRMKf1BSyAokUOonOxoGkZlygXzPpmRXyQWN1+zoDlstr5fVSAmgBGX8yHFKxux2GonYbbmfvnviRTOjK0ijIp7eMcHN4EunUadef0oZuM+bz6KPSm08k3GBN7s6oMBgfLD1hcgVmSOiNLJmNHdW8ybTOFif4xo05bqAU4xpeaGLuI2CkyOZQNXp9OZIKH12SpJYav+MpLLlBuAkVBVyB78mtnA81KJXQITFyKKr3czZG3oa24W81qZDLZImrNSVJQPefhYeHX7fX00rqgnlwbFnL/TfeAWADFJtD4uw90U50LFVCMC4ulTUvFegLpoC1sEBKYX1gVvDA+tq2Dqx5Bupss1Nogr7r8QoXNiTBQVBUw3m8pN9qfjim8IpTMFsYJ2H0+OlvCloxVH7rPXq3lVtpU0ZMW3Qs6pQYUbiuxqOe2sxuvtJA34LjUWvEevap5yCyDEkZO4MD5BzOSfilK3cxtre4QDWg4PtnZ3PYYQ7G5Ni2SbDqQfaXbald6geIAPu2+Yt1xlAM98xtpKrrZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/kmemleak: missing Fixes trailer and duplicate subject in
  commit message
--

commit 807561d4895dc6a557b90ff7973974cbbb93309d
Author: Shao Mingyin <shao.mingyin@zte.com.cn>

> mm/kmemleak: fix scan period truncation on 32-bit platforms
>
> mm/kmemleak: fix scan period truncation on 32-bit platforms
>
> kmemleak_write() converts the scan period from seconds to milliseconds
> before clamping it to UINT_MAX. On 32-bit kernels, unsigned secs and
> MSEC_PER_SEC (1000L) are multiplied in a 32-bit unsigned type. The result
> wraps before the clamp can detect overflow.
>
> For example, scan=3D4294968 produces 704 milliseconds instead of the
> UINT_MAX millisecond limit. Perform the multiplication and keep the
> intermediate result in unsigned long long, preserving the existing
> 64-bit behavior and the later msecs_to_jiffies() clamping.
>
> Commit 54dd200c5a25 ("mm/kmemleak: fix possible wrong memory scanning
> period") added this clamp, but it cannot work after a 32-bit multiply
> has already overflowed.
>
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

[Severity: Low]
Since this fixes the scan period clamping logic, should the commit message
include a Fixes: trailer:

  Fixes: 54dd200c5a25 ("mm/kmemleak: fix possible wrong memory scanning per=
iod")

Also, the commit subject line is duplicated as the first line of the commit
message body.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115004702358r2=
RJLihSrqbK4dr026bcI@zte.com.cn?part=3D1

