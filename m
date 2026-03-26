Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40E4A106F30F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:18:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C5706B0088; Thu, 26 Mar 2026 05:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976666B0089; Thu, 26 Mar 2026 05:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3216B008C; Thu, 26 Mar 2026 05:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2C66B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:18:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28FD3160C5D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:18:32 +0000 (UTC)
X-FDA: 84587663664.16.1CF85B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 60827160006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:18:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nInQ7EEo;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774516710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SEjf138xK5eE7YCgAWz9t5p0xv1RKe3kiMDhSCQ84c0=;
	b=zs6/7dbZF3IHw1KwTXs1APUhT61hkx4ZoqZP8josOfTkE3XVOVdM+y4X8yJnhThp9CyOst
	diq21r9ml5MAh2Q6rdZNmQB2jn3PYz/dB0c+96D6wMiS70kj+9I66DLuwj175qyci0VFhT
	+CeEgUPKfUj0SW2SmZfGFsFdDlN9pHc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774516710; a=rsa-sha256;
	cv=none;
	b=S6KNuoYAiSOFBacwwTUicNscATENTTl8HK02/lh009ZA5wwB5zikoiJcc+Ejf/ArIgn7bj
	HEcOCP/fawcLm1BfdXrXxmBiTGb76jrQJeh/LAPynV9F8OjrGhzCBc7qtMO4tRzJeQ759Q
	Bz/kM5Br04Yo8ldFn/mZP+d4g24DNO8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nInQ7EEo;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CBF6A60053;
	Thu, 26 Mar 2026 09:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBECC116C6;
	Thu, 26 Mar 2026 09:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774516709;
	bh=/bCzqTTRsxypcnV6uFRndogSJYo9EXu8deYZEOzzRE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nInQ7EEofumA+5b/diIf+9MN/nNqLVykcabEDbj3vaX76/0q+EY+rmtMmg89ch+oM
	 IWvB8HR3Gc2nwqvpMfs4W01nwBrRREQ+PImHogdIruFMlC+GtpuaT2eJ8dD4ePc2FN
	 j2MZgTcWdIbnW6Y/JTOd9KX9OJvWLy4Jt5MR4v0yGB6qwLcYlWWKpw4oSqaFLSNy0w
	 Kq332mRxa27usVlk6+Efa/ylcu4QwjX0T3qsHEeNgqwfajNPv5jSZ/3ei5fI7w7aMV
	 VfdUymBgM5/DJiZ2JQ8h0f2chGy14eYhZ98VgmsaYrPj4/zv1QOuwfawGIJ7RiPby7
	 lbFKJQaSpTdGQ==
Date: Thu, 26 Mar 2026 11:18:23 +0200
From: Mike Rapoport <rppt@kernel.org>
To: oskar@gerlicz.space
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Baoquan He <bhe@redhat.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 0/5] liveupdate: tighten handover cleanup and session
 lifetime
Message-ID: <acT5354RhFpOm-qU@kernel.org>
References: <20260324212730.65290-1-oskar@gerlicz.space>
 <CA+CK2bCiqCg1Tt0WgP3KszrK96Qahcgfyfige4eUQOkMVyLUqg@mail.gmail.com>
 <7628da0465cd09bfc16bf9353f37045c@gerlicz.space>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7628da0465cd09bfc16bf9353f37045c@gerlicz.space>
X-Rspamd-Server: rspam12
X-Stat-Signature: c45djhfe1u7ujs6yc16eztf61c4j1rbq
X-Rspamd-Queue-Id: 60827160006
X-Rspam-User: 
X-HE-Tag: 1774516710-565168
X-HE-Meta: U2FsdGVkX18n4/fZNvlSaQ16ipvPEijLlXfd6T7ajE6dGnzRcx19LzeCnC5cdKiumlbeHGNjdxZkY3c9U90nGco6mIkwFZsK8lGPXl4x9qiGof5OymVw9pxhqmvueKD2OJmvWEnZohSfDQ5cnMaybzOcQzhJ99GXkUHIpsa392gxatpK9HqHNoXMpR9UlpiOcLFSmuAIiFnPwj+wnwQgEN4vIXiaUNvCbJV7GpSrTUS8AD/+C6qUCS2NSCFvCRjYMvKPyKicYUk3lEr88if5BUYhPLzqb8bZdcDdtG88EldyObuPmIcKIcCYQnp8sxfbtoggSR+UBvgJ8qfO491T2ut1pAfjQRDRzreFLM3GtHfKSFwEb3FhP2dWz+2dJAidPlIOH//Y/UrEkB+2rWmHrzjI1BCt888GBV7UTQWPjbwjBXpa55Ex8RKsjsQfFrbgSEGbRoyXeZdUfjHI9uSEbzugE+2CIyDBqQrGkYxgXswIRAKddOAW+TLHaWStMWoVvZ83k4OZNMJ9W219xYHuRkGrb7xnxoFsfEge99OoueZJEP7BKSISIt7boyRWXVkHzjCbYWix0wt0OVL2h3lHh4bSwITaQa+n1BNu55N9YiZ1N7Hf78W/SnzFYJGdG8YxCEF5bBJpstQItoKymUN9R/bivP6M5ONlDuKV55G1crRvkH6+OWQSOq/n51a+v8eScGJgzftiF5g0Egf/i79p+JeA0eyMkNk7bIm3b7xphP0a2P4cZulj0/ZWYj380j2trQozum2Sm3IyrhsHQZP110uMI26H/Z49Spd/TebN6/gFpabzR1a6RRIvsqWfyUV3jS4xz1XnY7DjnwnPgu1RLFKg8EVUYyCSbYeShV+Bte8vmMAXzi5qarqwoyl5S1Bf9aMcyu5JehXJY/rHEGvtB+Dn9/r2VhdIFYL//Cwv0xoYnCgYUUODIFUb+tYD15D5JrA7/s41LgIJyho1AMR
 UvkPpVhr
 f+dbFU6x0AjHL4Raf7NNWq2FTuo+Kqk5EysacgoJfD9Tq88z5tFaT4+z/Nh1a6T23Gx+aDdyj1Lt0KnzmzdSh4vjtS+UF2fLoDkXvCMQK1pi7auaN0iHfcM0DwHID0vtw5X6l/MG8eUawkxlngkXOpaO62cnNxiMk0w185UIReXvql3234z8iBLwAk37iLLCC9IpSHVR8Oyi2tyPQwbWGtKnDc/nUgJEeXobDI8L0CVI84IKWdluxv7C6HxmTlH9WhM0khshEdSU1d5fWH+fuICWiz6gNRW1OYyOTKV6g11oEFtVdn3sDPKhMfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oskar,

On Thu, Mar 26, 2026 at 07:47:03AM +0100, oskar@gerlicz.space wrote:
> On 2026-03-25 14:38, Pasha Tatashin wrote:
> > On Tue, Mar 24, 2026 at 5:29 PM Oskar Gerlicz Kowalczuk
>
> Hi Pasha, thank you for the detailed feedback and for sharing your patches.
> I understand that my previous version was overcomplicated. I will rework the
> series to follow your approach and keep the changes minimal. I plan to send
> an updated version later today.

When you are resending please make sure to avoid deep threading of the
replies so that all patch emails would be In-Reply-To to the cover letter.

> Thanks,
> Oskar Gerlicz-Kowalczuk
> 

-- 
Sincerely yours,
Mike.

