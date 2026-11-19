Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40980606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 10:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UaA7sgxE
Received: by kanga.kvack.org (Postfix)
	id 618A16B0602; Thu, 19 Nov 2026 05:07:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EFF66B0603; Thu, 19 Nov 2026 05:07:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 505B66B0604; Thu, 19 Nov 2026 05:07:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24B2D6B0602
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:07:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89B19120A28
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:07:19 +0000 (UTC)
X-FDA: 85451440998.14.B9CE60D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D2F2DC0004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:07:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UaA7sgxE;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795082837;
	b=F5Ai+vvX6v8+1xELbdhGgIbRETy8CQyOeEIYlee/pVqhA1vIfRkgM4nBnmgBNXNuQO1q5f
	hTrNn7ev4BZ4WFzzfYhi829ZJ1Lzq72dazzqKjMNC1zueA87KXFDXm31b9jqvw9n9YRGq4
	bRqHA6UIJIsFmO+XCvpN8bcK617VF84=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795082837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGwpdbTlNY+DvHr0Ucumf9a6qslnhFBKpJ6OXW/8N7I=;
	b=cSpyNwjPuUHIk84c3dfVl+A3ie9ihDAfUwl3YR4HG6sVXccEBt3Qe4fKoEHoH57BTb9T4w
	6ZiqCeDNjbabQdx9sV8I+70gIvOkzV2uNjUuhLhOMQFPmYaKU/tsTMHaei7vHzvOeFluUU
	Xd+TSBiv+v4s1p6adzNyw5fE47NBndY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UaA7sgxE;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B72062FF3;
	Thu, 19 Nov 2026 10:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32DA1F000C6;
	Thu, 19 Nov 2026 10:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795082837;
	bh=HGwpdbTlNY+DvHr0Ucumf9a6qslnhFBKpJ6OXW/8N7I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UaA7sgxEjbnM9lsll7m5KgsMYFJd/s3uxUFI2bLYfNkP4xiiVSWClXJzP34gFqFMF
	 8MmD49ZJs6FL2WkajJH2j3ammOlkMKuaM6TcpGjjbp4cYNc66vQRjmNkMADx2boICr
	 JduAvVFaZQWFxYapXoKoPRFJR1F+EEzidfb9tvrMYNRtmI99XYA1UjGk8f6CAMo92F
	 o+CBlayFEkHfgA8LmOMCoE7Vl84FXAal8356EtDgdIs3vRhREPuV/tCObC4w04Tx+2
	 XcrTVHER/wnlamJeik+PtnHk9nWTrw9qkzip/nFkR/GHcJxthFGLb4X086JZQN6FHW
	 cqxmnoImQ4Z6Q==
Message-ID: <b7474fd4-eb88-4472-9e8f-26ef6c646694@kernel.org>
Date: Thu, 19 Nov 2026 11:07:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Using In-reply-to: <patch posting> in mm-commits mails?
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, mm-commits@vger.kernel.org
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
 <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nswzc6satqnr4eyrmpj7xtmk6mn1bpn1
X-Rspamd-Queue-Id: D2F2DC0004
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795082837-199009
X-HE-Meta: U2FsdGVkX1/juHNfk5McW0jji8q1io/Ln4UZePvAaAg3ps+AGAVnH+iajVBDq6fuYZzXGTU6WG2Y1urcTxtB63xQj22dHRatAHcwjxSHiiIpTSIkbt48Ft8I+etbMJo7d/Bep5ZChNDrSAqwO4IBB6MgK7xvEw7ZWKMyWt4CIpyWVRjaMDx8qohtmpzDaUz4h/D0aFLejSG+MnGuZINpl82FgGHdh+MSUwWFQt0yvhSmcLYsknwhA5oPs2VZxTUv6X0HjyW9DyK+9AEuYxFrCWBM0tXtW/r1nJaMtvGo1fo+Mr77DQqt0WrfT4vt9GJV6mW3h9dUyCBXb0sOs/+XutposkxpCo06jb7zXxd29qEZNxc6akdfsS6Zg1Ql0y4R69zTPGlBJcHefY+1QftzouzlLzaV/MvYSEURh3r8ycP29f4z/GJzKOF/Ze+h5bD69wCaFlwzEgZR3WfgePfaWB9ZGUmwLEGshQignX/BTjsc++o7QgW8/40hZhnrjZQLVTeZeO62aW1rVcXU9pJB1FSSeVHhG9aSZ67gH1ILc4M31bFTqiPS1chxK9PCeHtypqGG33j2a45dksLFC5jZANrGrDeQqf8oRKYL68cCbnOj7Vz9VV//fY7RYoyiGZPUrrrp1IsGd6zExGa+gHeDYzZDDlEoyTqWt+HVmocYz7XsRck+zTO1cPzSi8V0MjbiNWEgo3qERBwmslvxeHempXwCp+JS0Lx8DhhWsfT4SQOtvf5ggyY7yb0DPwNCK5wrcNZDMkxmTqCrpRIdlCY1lWOtXOFosedAd5LNaZPbS7K+7JSoDNb1QTvtf2NBxS+eqIF6s6GzVfxIGvkyBQ6mZh0Wfyvy/IWSLALuXKTaR6+f47BGIm1/+eFbYQrcwFpxgkt9Vze/7+eoqjANcdj3VLg/19P8jSHvPKhfCw7mp0RqEYJ8fLBbLEq35w3sGhVttwmbC0Mv2Aev+x26JNB
 B1MEKCuq
 CRXjkW6IvfqrQni/Dj6gak45NimmrcK8GpOTByTas11DENrW7lDGVrsUF+VLAefpeZiET1Ihn4t/te1uasquDQmtR01vWNWLrcqIVnnJVxaoqI4RKVjpW/vh9VbU38JbqYiKMirlJyJUd5FHH4o6Mtp1ZSxBGkgSuIUUVuHCt5UT1/1w4Y/xKJUURVg4a3oQwoTpckJcMHtqQIixYh8XKPvqETHIQf9RDBiOJSwpuYaLRgCumH90LMH7+N0V9/Rmr82MGeFCEyHP6cdu1shVGbDhCmBvbsPCEr353QUfS+kH63azEVW18aH+n6i5N6GzRaXPX2gxzJ22F0RTk1hmt+1fno3Rf1Q1brCciNRbvJj/N8I71QNHCUfJuiSkWYtqZLgSdyHd80OxvfZQKpWSAfuRDksv/UDFUkQ+LDtg4R11t35UTAYMRk7iwmBmi4OG8zDgiPXk1TnAZnLlPmDqrt3NUDqMl5W8/QLATuYcD1uBQQdFr3JJw/s/6rtII89OREH7JYoT9j8aSyf/PrkHl/7EeuSiA4zVfB2PtwBle42AP8wJ2cIKFrWNUX9wYgXXNPiC/EDPBMVqtAEigux1px7jZGMpGCronocaPOKp62+BRWW9DovKxYdiCkdgMA+/z8odeJ3TZPE175E5JX9S0troGxjBcMFuTW3HW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 06:25, Andrew Morton wrote:
> On Wed, 18 Nov 2026 11:21:47 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
>> Hi Andrew,
>> 
>> during some chat with Lorenzo, it occured me that it could be useful if your
>> mm-commit mails (addition, merging to mm-stable, drop etc.) were replies to
>> the respective patch postings, which would put them next to the patches in
>> everyone's inboxes. I think Lorenzo started to doing that on his receive
>> side with postprocessing.
>> 
>> While I haven't checked your scripts, I naively imagine it shouldn't be hard
>> to add that In-reply-to: <msgid> header. You already have the msgid for the
>> 
>> Link: https://lore.kernel.org/<msgid>
>> 
>> part. Maybe it's tricky when there are more Link:'s than the patch posting
>> itself. But actually after Linus initially hated these automatic Link:
>> additions, he later settled on the Link: https://patch.msgid.link/ template
>> as acceptable to him. It's sort of documented in
>> Documentation/process/maintainer-tip.rst too. So changing to use that
>> template should allow to easily grab the right msgid to reply to even for
>> later actions on the patch, than the initial addition.
> 
> np, that should be working now.

Seems it is, thanks a lot!

> I switched it to patch.msgid.link for just the Link: to the original.

Yes "just to the original" is what I meant.

> Konstantin's
> https://lore.kernel.org/all/20240619-docs-patch-msgid-link-v2-2-72dd272bfe37@linuxfoundation.org/
> was helpful.
> 
> I hope patch.msgid.link is durable.  It's owned/operated by the LF so I
> guess it'll be there for a while!

Yeah. After all, the same is true for lore.kernel.org :)

