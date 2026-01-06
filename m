Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7597CEFCE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 17:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2A806B008A; Tue,  6 Jan 2026 12:52:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7C26B0092; Tue,  6 Jan 2026 12:52:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAC856B0093; Tue,  6 Jan 2026 12:52:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A57646B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:52:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F19CC25D8
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:52:21 +0000 (UTC)
X-FDA: 84302283282.28.F7AACE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB2FE180003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:52:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IbPCy0It;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767721939; a=rsa-sha256;
	cv=none;
	b=gdLYp6jjqXqRsYOysnzlcp2i9feVAkFuFaxqs9ypDFy6SK4E9SMuvDB+JWKwZ48rDqi+jE
	mnsPNY+01Ul+TMqxT42NchhlVRcuzZFYZ94RiwITPr97sER4VdMmqU+Fsf1Tpc9rhea5pE
	zAUijP9NYaynM+I7Pe1womfMVJcztEs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IbPCy0It;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767721939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/CCcTi8r1YhegimpVdREms4A9cZmIkZfo3o4Pe972Y=;
	b=fxNDkmY8h7I2lxyLbwLFDUyJ1UITKCVYR+Q3eIpCH/qQfmk7wZV/bw6+5gfRWNHXoGPZZp
	H3r4WHxkgAMoy8SGyyS8s9+FQjSNcDahRNIR1s0zQC6TmIaoHwI2ujDIAd4tLe68AndtrS
	88ydc+J5jeYzz63AmZF/oIdk3i8iLF4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D392A60007;
	Tue,  6 Jan 2026 17:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D18C116C6;
	Tue,  6 Jan 2026 17:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767721938;
	bh=p1c3WMeUaHTT26OVRketCaLs++7iT/cuCyQgsuGHZIg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IbPCy0It3SRpYwFSDcRT1suC5krs1BsSmVkpDa3GSz4AoBiDOk2SLido9BDPE6+tw
	 o6S//pbNCzHmzNhiVS/RMdb8z4SULvMlbDR1mGJoj/kVB5wXNZs+tkSUyvBpdbBHlQ
	 1bPAyPvVhYhXOUrv2KTmH3Ou9JkV6braCMg6E6K57RynXGfK/gMd8R8IsCxiTZKXxg
	 SN7t8OUkY+V6xdFq9oaDSAdjyPVXnzGKH1idzHDZKZlasJMVjicRgGEt+EFUQ7L0JI
	 bFDxF0YobYZx5ky34zeue8BR8W6NLU9M/sbiNSKnvcPHGtFMYmBzqOwZBobA6lz2Er
	 2p0emrh5DWvgw==
Message-ID: <9575e042-39f4-4f01-80db-34aaaa9312e6@kernel.org>
Date: Tue, 6 Jan 2026 18:52:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hare@suse.de
References: <20260105203611.4079743-1-gourry@gourry.net>
 <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
 <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BB2FE180003
X-Stat-Signature: 8jzpqp7q84u3e9ey6mfbj5isb6icun3z
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767721939-246618
X-HE-Meta: U2FsdGVkX1/0PTqpeFb4Mp9Q4WiyAN6SjUZEJJmLdwTgkHHZ9tZmNyDrfUROkkv61Oo23s7dxosE+4uBLZOOWT7QocdOiugXjf0GzH92zBtCODGxboU8wHiGc1EsdagaizY3eUnXYf8inMC0X3TX2r/sIXdEqOK2LmSAJhNEbMVgl3z0Nb0BAaCjqCN3z3TI7V7Xqs3COk5Fv6rkGhIiboNLMxVjHVvwdlFg+Yxw4Yit1A7DqqL+WFFYqCaERawV2qd0rXgCOi4lTGuUkMDTj+CUNvO3S7SRiYDXIEpqrJ8ZjBOTYg5G9+orJkI4Iar43vlgvZyeWGkVSJ2A0zhVyp6v+AzCAlQXX6EVuXE1hZjUc3X2TdK9Rqv9EZfqVgtM+CwkzWBRuHNIPXe6xIhn5hlwm86sG6WzbXGjthNLXBVSZoxokDi72pbkcQuYDSeSX9BfWizp9+JAHLy/0v4gukPw2fb9+JEUmaknGbUtk6w3AFv0Xs1IxYxyQxCnBfcMI1R6ESTqKH8xPM8oWszVSH1Jphqw0VxEutvm2xKkqkiwjw256PUk+hyNMFW47WLg+wNw5+GAgsxXv2x+jU69/MlSRQ2riWAfBIWV8WiMdAsYKfgwmZt3LkH4X/vb8lzeSUPALoMtdyU09ySfOQoaLmKlUvOKYqkMB2E47f/o/DhJsln3YIZJ3G6gPT4JEnwCDkrpMk1KhzTss/zUaFSeG2KEg9kNDrC6RUU+R4Yw0CibGNxpW2Sb9JVSV8AusRI99gUJVGQIcDKBhO+4QTyIGRafNpzOjNvY3wXBZ3F5HJ4/X0PifMUNme60XGwDujKE6bMm+qsdmJyEKwLs6jrl4Lyf9lwgedki04nzETfMb2QEklhIqYn5HllCmcGsyQqJkF+ouNmXz8ZsXrPlzlfO5jdzP5T0VFyaWSxh0h0XT0J0AGggzi+Wr+LT0eim85+NEeROVheU1+vS63ml3Sl
 rt4VwY3s
 xbihJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 17:58, Gregory Price wrote:
> On Tue, Jan 06, 2026 at 04:24:21PM +0100, David Hildenbrand (Red Hat) wrote:
>>> +/*
>>> + * Restrict hotplugged memory blocks to ZONE_MOVABLE only.
>>> + *
>>> + * During offlining of hotplugged memory which was originally onlined
>>> + * as ZONE_MOVABLE, userland services may detect blocks going offline
>>> + * and automatically re-online them into ZONE_NORMAL or lower.  When
>>> + * this happens it may become permanently incapable of being removed.
>>
>> If it's really only that, we could also look into simply making a re-online
>> without a specific mode ("online") to use the previous mode.
>>
>> We could glue that to the "contig-zones" policy only, to not affect
>> "auto-movable".
>>
>> That is, remember the zone to which it was previously onlined, and then
>> simply re-online to that one.
>>
> 
> I know we do this in memory_hotplug.c to rollback to prior state.
> 
> I did notice in... i think it was either memory.c or hotplug.c... that
> we end up setting mem->online_type=MMOP_OFFLINE after comping an online
> operation.  That seemed confusing and maybe we can use that to store the
> current state.
> 
> I'm not against this idea, but it also makes the sysfs a little more
> confusing (`echo online` now does different things based on prior
> state).  

Right, but only for the contig-zones policy.

But maybe you really want the default for such memory to be "movable" 
even when not onlined beforehand? So I am not sure if the description of 
the problem here is accurate.

Isn't one problem also udev racing with ndctl?

> I preferred just failing if the block wasn't compatible with
> the zone (maybe making it more clear with a dmesg print?)

The thing is that this block is compatible with the zone, no?

In a system where you would never want to offline that memory, why 
should we stop someone from onlining it to a kernel zone? I'm sure 
someone with a weird use case will show up later that will complain 
about this.

But the patch is missing details on who would actually set 
MHP_MOVABLE_ONLY. A user should be posted alongside the core change.

> 
> Anyway, let me know what your preference is, happy to pivot however.

Restricting memory to be movable-only to handle a user-space problem as 
described here sounds like the wrong approach to me. You really want the 
default of such memory to be "movable".

Almost like an optimized "auto-movable" policy :)

Or a new policy that will respect a provided default (MHP_DEFAULT_MOVABLE).

-- 
Cheers

David

