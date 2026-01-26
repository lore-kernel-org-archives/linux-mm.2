Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4ED0D13C0D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 13:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C4F6B0088; Mon, 26 Jan 2026 08:28:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED9D6B0089; Mon, 26 Jan 2026 08:28:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5A56B008A; Mon, 26 Jan 2026 08:28:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9DE726B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:28:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 164881A07A2
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:28:37 +0000 (UTC)
X-FDA: 84374194674.16.201BD06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 84FB680006
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:28:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LVEvzMkT;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769434115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWoqNlu1Snaz4A/LOpRb9Egp68rV/2sDGEDAJtkaYCQ=;
	b=B5PNrnWJipOYv3sf2xBDduTVI7Z+SMJdiBZtMYW/NFqjoK1zNu+qzDbi+Ldzz433QQ/+jV
	LtwfCM5r3lkZJlYU2o+zRDDT1oyctAn/NSLK06wEng9USKLlLWXR7xU09ZCD9dE4AiLy6Z
	GNi7mYzkV5Ya4FdT1FFdZa4IbmvbFRs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769434115; a=rsa-sha256;
	cv=none;
	b=nPTa/9zuR9+Yj62weqLrtzCjzOgTvKtKXkHIeEm5azmCGrql2LQmXMagqAPDv4oziJU1SM
	Q33WTwK/n1VCyOAHmz/St0/X83rp1PwwgRLmlm5ItMfrLdlcLvFGbWdDkQ7UhRNLA94nnX
	UH/VVwy4MKdWb4ZBGUmqfGZLoX/Sm2M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LVEvzMkT;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EBC7E6013D;
	Mon, 26 Jan 2026 13:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC11C116C6;
	Mon, 26 Jan 2026 13:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769434114;
	bh=H7OFhvg3HcLsfNokdY9oulWOfJXzLJ3YBmdWEdKruwg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LVEvzMkTJzhW/0E6Jyo967XIlN4poj6qVqU9YZm/d7y8No1fhZJrTE6HLyQ/TfNc6
	 heX4Cj8Q2JHNoiVb/sSJoXAhqM+esrNm5cJakXwombgHUJq0cjcoJtXoQqU+QSjfD1
	 qam3UrUjxY+C6162GL24CyWrAC9Ob2jMfWtyOTOnV6F1zQdnIT40i2XP5rUTtan6f6
	 ffss6B21TEBZS/vkiN6rBgJUnAFDyudF/bGvQi6lQQylvAsJppcr4yQdUGaPI6sGv6
	 epWPYf6hPs9wIdZftz9k9sJWLzzB0GYT1WO/32h6ylHsETeyp4z6DEqr7TzP9dk75O
	 vDtZNkbKmfeBg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  rmikey@meta.com,  clm@fb.com,  riel@surriel.com,  kernel-team@meta.com,
  SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4] kho: kexec-metadata: track previous kernel chain
In-Reply-To: <aXdTEzsm88JKu9zY@gmail.com> (Breno Leitao's message of "Mon, 26
	Jan 2026 04:01:11 -0800")
References: <20260121-kho-v4-1-5c8fe77b6804@debian.org>
	<aXdTEzsm88JKu9zY@gmail.com>
Date: Mon, 26 Jan 2026 14:28:30 +0100
Message-ID: <2vxzikcoa4g1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 84FB680006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 69obucewkqj8pq57fs59mab6133asoof
X-HE-Tag: 1769434115-143099
X-HE-Meta: U2FsdGVkX19C4tB4rYMV4M8H5uPh+Z4hXZSRrIjit/tIbiFm2PSmW2SBxWSRstFOYj14uB+lgBrUjtsiEy0naKbJ2TNcskJdzbU7YKfOAVL5KKEIReBOHbmIMZS1T4b1V7zymdch/wM/stwqroDh3FTKQowoI5jD/JIvUjTou/ldkWY/40xLqx/ZMcafPz2Qvb14ikAiob02r34iRIT42LxIfVdqOp8HLjkyHLvMqPb2c5GCjfQzWR4O862HeHXUhtEdiSmslvbYhO+Rp5sjIKstW8uXIs8YmM6CpvMJSdFhgQrZOqkYtQAyT3j0h0DhTv80ICI/icJXJXh6l+5T1WoqsA926I4AXxJs46iSeX8DP6W8KDw4u+er7aJPGugLN5yrNzMQ6JT7y7/botV28dxD/CJyCUaIHxcS15IecCrGbhM+yqHMOW5q4opkUdJf22vIkj5XbCH4u6AO9ZSGNtYcT0s1tzTJNRoNYMDCG4CoZKLxm79oy4krqugR0Qe4oHxBtzFxeUjXnoGdh+9vXO9QK6/lOhENuoo/JOnlHQI2psmU7053IXIKxM9Mnc0uIcCY4nsxWh6GykGoKBMZoSXryKv1G5apzu2+n6k8nfdq82A7Em2hFx4eLXrahb/BpG3zMqv19J1THI30OkORj/xB8++JTj17LWho+U5JtqRt04vx2QnUbrQ5s7KLcc6j54o12l5VPFKDDQCa3N0Kz4p+0GrE4ITKYoIP5FQaqDUYudeLRB4jZvcAZqh5zkYJCJ8zVJiRiAyZerw+y42U054Ee5jfMUNRCHLHxCPx9Lg+OaxMZEVTvTZ8g++mt/AYV6qEbMHAsjN2IEE/B9Mw+eAWgJMji69XfglgLxPhl9SsxCPdT8QTtXMQSGMfDG7Nbc6GVdy01jVmmBJwinFgf6fHR819y5HxQDxVLFudjDdtVTy6j5GqVrKYHcO9nAgIKuwynvqG1tXUDdz86h8
 /N8+jVrm
 056GtKUERL6i99FNgf0fkxE8soZne8Qm0vyqtD2bZnNJyb5utOqkTTXLMBYK/QunXbt/2mKqm4V0Z7BCgaMFrWV7anhCrMYOU6x5q73mwbgLUc+A9c0VwPc3D+HB86ADw8ZQql7zoadsR9CHQI4pEuOhDsCKjv2xfKEixoHlhwetuvSfCYtqv+tAW1errfCZME8WxwpovFc5jquXjPPglqJUOFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Mon, Jan 26 2026, Breno Leitao wrote:

> On Wed, Jan 21, 2026 at 06:50:38AM -0800, Breno Leitao wrote:
>> +static __init int kho_populate_kexec_metadata(void)
>> +{
>> +	struct kho_kexec_metadata *metadata;
>> +	int err;
>> +
>> +	metadata = kho_alloc_preserve(sizeof(*metadata));
>> +	if (IS_ERR(metadata))
>> +		return PTR_ERR(metadata);
>> +
>> +	strscpy(metadata->previous_release, init_uts_ns.name.release,
>> +		sizeof(metadata->previous_release));
>> +	/* kho_in.kexec_count is set to 0 on cold boot */
>> +	metadata->kexec_count = kho_in.kexec_count + 1;
>> +
>> +	err = kho_add_subtree(KHO_METADATA_NODE_NAME, metadata);
>
> There is a hidden bug in here when CONFIG_KEXEC_HANDOVER_DEBUGFS is set.

Good catch!

>
> kho_add_subtree() expects a fdt as the second argument, and we are
> passing a pure C struct. That works fine, except for debugfs, which
> does:
>
>  1. kho_add_subtree() calls kho_debugfs_fdt_add()
>  2. kho_debugfs_fdt_add() calls __kho_debugfs_fdt_add()
>  3. __kho_debugfs_fdt_add() executes fdt_totalsize(fdt)
>
> The fdt_totalsize() macro reads bytes 4-7 of the input as a big-endian u32, and
> this will hit struct kho_kexec_metadata, given I am passing a C struct instead
> of a FDT.
>
>   struct kho_kexec_metadata {
>       char previous_release[__NEW_UTS_LEN + 1];  // 65 bytes
>       u32 kexec_count;
>   } __packed;
>
> Bytes 4-7 would be characters from previous_release (e.g., "0-rc" from
> "6.19.0-rc4..."). Interpreted as big-endian u32, this gives a garbage size
> value.
>
> The alternatives I see here are:
>
>  1) Come back to FDT instead of plain C struct, similarly to the previous
>     version [1]
>  2) Created some helpers to treat C struct fields specially just for this
>     feature, and we can do it later if we have more users.
>  3) Move this kexec_metadata to work on top of LUO (similarly to memfd), but
>     that would be an unnecessary dependency just to have this kexec_metadata.
>
> That said, for the next version, I am coming back to to FDT.

Please, no. Don't go back to it just for the sake of this bug.

I think KHO's assumption that the subtree will always point to an FDT is
broken, and we should fix that. I think KHO should expose the blob of
serialized data and let userspace figure out what the format is and how
to decode it.

To do that, we would need to update kho_add_subtree() to take a size
parameter from callers, and pass that down to debugfs code. I count 3
callers of kho_add_subtree() - memblock, LUO, and test_kho. I think all
3 should be fairly easy to update, but I am happy to help out if you
need.

>
> Link: https://lore.kernel.org/all/20260108-kho-v3-0-b1d6b7a89342@debian.org/ [1]
>
> --breno

-- 
Regards,
Pratyush Yadav

