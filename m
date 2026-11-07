Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D45D606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 12:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JgHytq8+
Received: by kanga.kvack.org (Postfix)
	id 428316B05B0; Sat,  7 Nov 2026 07:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9736B05B1; Sat,  7 Nov 2026 07:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0446B05B2; Sat,  7 Nov 2026 07:42:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF276B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:42:11 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88D1D1C36F3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:42:10 +0000 (UTC)
X-FDA: 85408285620.13.2F9B6EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E8624140003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:42:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JgHytq8+;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794055329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cV4x1ttF2piQ+fPr0c3b26+zl31Ni+hq6coRnnOJGt4=;
	b=NKAwdNjGMmkp7F+K0QFt7JRgG/zCKjm+2Ej+z2MTe7PRn3x0vNtJpoThsKb81qOxa8fyrP
	0nGZfb0xNLZP0gYxb4n98btpcTRQLtSeUJ9BCmZDW2ZW/JO/2YjPVKHDOXBlS4JsinUnoY
	eEe8qVKqH1vBf7/qglfh1pkgAsyORqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794055329;
	b=iaAUAbrwc5hI85ppq3HKdBJ3BdDSXItlQLC49cvkPEJulb5WyrabiFDCApRl3ndwgXIUnN
	bmvQO+7YykUZdsFikMAUoRGXbfhXbnuEU9k5thLIjdxhx83FDLvUhknSrZ9zNj7i7vYn1x
	AnJElXGK+yZscnIcnfzPfaacEQnToaI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JgHytq8+;
	spf=pass (imf23.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B8FE60145;
	Sat,  7 Nov 2026 12:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6081F0089F;
	Sat,  7 Nov 2026 12:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794055327;
	bh=cV4x1ttF2piQ+fPr0c3b26+zl31Ni+hq6coRnnOJGt4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JgHytq8+LC4i1GMMDzJWG+4RP8UfKxpwPDZIewWf+awPTc104SO/aVMbC9ViRPzj2
	 xCfq+Al+UyosK37OFtU99ywsvzo9cVlhMIa019ZVVL2rjoCqO9ZKR2oojIa8ZN2Jhi
	 aWjLJV5Y+ZKdUzXzTB5YgoHxNCGwgDCycLh7cyYV8khgxQ95Gc9iVvK2vXzDNsO30Q
	 Ulf5574S6IHrv0/6HkRvvwsW6XgpwpUgF/eCsUYgSuh/svFb4e2Lo4Fp1K8l/3z9UD
	 DhPNpCCP6XyuDFqK3mCvGX+I2wqcust+6l6qDZb6dJo4RwQ17ze2Nw1gpoq2O6SO70
	 yw9doaEZkuWQg==
Date: Sat, 7 Nov 2026 07:42:06 -0500
From: Sasha Levin <sashal@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: add CONFIG_DEBUG_FS to the config fragment
Message-ID: <au8cno0UHsD_Fxp3@laps>
References: <20261105171801.2189772-1-sashal@kernel.org>
 <179397467526.9397.17872200045070830000.b4-ty@b4>
 <20261106185218.1766376-1-sashal@kernel.org>
 <8fdcef66-3130-4c90-aecb-050ae624f42c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8fdcef66-3130-4c90-aecb-050ae624f42c@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: mcw3y6yzxwzxmruo6eobo44gwn959ojz
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E8624140003
X-Rspam-User: 
X-HE-Tag: 1794055328-887607
X-HE-Meta: U2FsdGVkX1+QhTSGqVvBg/bsLpdxCprbXhuz4vxB9WbmWaco19ZjimIPUpl3tOQ64IBJOVnyqlSZK6e9u+u5Ttdd1Erf+8qpocsfZYqllLFal9SMRzxlO194hlYk+3PuGAD+8LeibCI0Gdn+yVsh1Y1hn6oH7gLY+D+KDGdYjbLrUr9jDpeYM2lgdS0a8z2JHzCAIKsgvECMYZSgok9PE7fczlyBbqk2UpDh6qa8aiTsufh53E5yyAhw+q5R8xc4vktv2LmH+jt6uhLfMfa5z9zmUn4KEQj5G6fD2QF68w8JYFjA4STf9KahaRw42fVOCLnH2k5rotQSdQ9wYEPGU1ZZBpam0g6Ut681Whdnjvp4142NXtBn0sMB7za9UWEk/D2AbfDangr2kAyQ074zDzrVTF0w5lfe9rSkYaF93cdJbqUkDr4yHD0Xty3dq+WNGRhfLlPoda8UnyGae37jkqv7zUZzAVYvpqX0zV6SY3AqUQV6lMI/RN+vB5ttTho2GjypCtidaYyj51OBi9ax7gh2wI9/UFk7pV51YOI7E0DN929r+e9qszTNM/wjohOi6EHOAvKpEyxiQE0b+vs2qEH3GV14uGpfeMCzK5hdqPtGeO0SW01PrliR8LRpQyU4k5nNg21PzRqcFAer1jYeSNPSL1YvAkShD9O1aEUH257Enf+IKvlf9zOPOgk43A8R1BOWlPGRGJbqVRDWK+FKEk8W7wV55LVSKq2/dszXrB3Az16iZm/8l5m1yXUYf3dTj1UVzmJGRcmTqrhjXh7KR5G2HLwGTu9/1bjV1O2Y3jtCx84Dc1AG59birJEvoJdqF4F/6CTzjGlfJSFSD+UYA89AzyOE6N8UrlS06uzJoBaqzjoyY/FdxDaLfnUude3mWdH7ToLiqxWdC6j7nejZxT9BKHSIC/abzTrwkMoAUJosBVJ9RjD3hGRcxQsvdfFXGrnhAcJH9kyYlMpx47C
 ZqF30ECZ
 CWQ9YE/VPg/GXdir8E/oUis7M+xkYvh0VX+HTqedg5rmhdn8LO2rUEgZa9JVpIvH8lk771NPOghcJKGUUw6pcwZYpuJwFHb20KQryrmBlyA0YemF3YO5ol1GlxI4FXk1kuGxqsKy6289houMEoWuECPLwjUY8mj1ODDYbDfT3SwfJeuL+V4Sc3b+KkSyFa4IVQuOuGaXDFnKl73ZOZGRZo8BGqESB94sioHnDAPY7WEtQcR6FCX01WeOmqMldSitKnifagSCouXfhEbzJmNqBfImBXjwg3fJlRGLijEWmGQ1cCvQIxOBWRaBBaWVDzKm1DsBZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 10:32:27PM +0100, David Hildenbrand (Arm) wrote:
>On 11/6/26 19:52, Sasha Levin wrote:
>> On Fri, 06 Nov 2026 15:17:55 +0100, David Hildenbrand wrote:
>>> [1/1] selftests/mm: add CONFIG_DEBUG_FS to the config fragment
>>>      https://git.kernel.org/mm/core/c/31ea5515
>>
>> Thanks! It looks like this one landed on both thp-7.5.misc and
>> core-7.5.misc:
>>
>>   31ea5515bf59 ("selftests/mm: add CONFIG_DEBUG_FS to the config fragment")
>>   194b63198811 ("selftests/mm: add CONFIG_DEBUG_FS to the config fragment")
>>
>> Was the thp-7.5.misc one meant to be the split_huge_page_test skip patch?
>>
>>   https://lore.kernel.org/all/20261105030242.1241448-1-sashal@kernel.org/
>
>Fixes.
>
>b4 shazam gets confused when patches are sent in reply to patches.
>
>Which is why we shouldn't do it ;)

Remember my gripe about how subsystems are starting to have more and more
custom rules around process? :p

Our docs currently say (Documentation/process/submitting-patches.rst):

	Explicit In-Reply-To headers
	----------------------------

	It can be helpful to manually add In-Reply-To: headers to a patch
	(e.g., when using ``git send-email``) to associate the patch with
	previous relevant discussion, e.g. to link a bug fix to the email with
	the bug report.

I suppose it's okay for parts of the kernel to deviate from the "standard", but
it's a bit hard to keep track of these preferences.

-- 
Thanks,
Sasha

