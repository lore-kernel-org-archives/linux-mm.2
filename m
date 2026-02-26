Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40BDAFC590F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604FA6B0088; Thu, 26 Feb 2026 04:03:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC8E6B0089; Thu, 26 Feb 2026 04:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C34B6B008A; Thu, 26 Feb 2026 04:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 371446B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:03:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7D29BC83C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:03:10 +0000 (UTC)
X-FDA: 84486018540.02.D62C2BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2FA37100004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:03:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cS5t3jCM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772096589; a=rsa-sha256;
	cv=none;
	b=GCN1jxQVboEcMFQSsC/ephp3jrVhE3R2nlShi9BYZW4P19ZBMAW96OgiRuoRA+WPZkgsJf
	rk3P8CRAR5PKQThVvAs9VAPBuVKrDUx+DzTuFbl8Sle49UmYPJ5tN13HxVYYVHFSrastwB
	J4lqwVtUJwVKbw0oLBa27pDEejtkpI0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cS5t3jCM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772096589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KZdFcI4eXpZoyKT13kC5vn8pi69nFwJf20ayen5sF8g=;
	b=jAij7eAg1YmyAaMukEEEBZVlicTwDJgzQ0CPrAYx5esQDb5bqEbEVBV2RWeHcoLeLi6t1G
	jY/3huI02cS4f9cKNV9ywBQWBIvrldg7P7+u8uNC+XARbbeWFcAhsY1jiefHGA/OXdhFBA
	rt4Fm/s8eQrRgiwgJ1/xGTGF9ASCFw4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C1C8243FA8;
	Thu, 26 Feb 2026 09:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9432BC19422;
	Thu, 26 Feb 2026 09:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772096587;
	bh=3jJF19kOL002PKzJx7tPe3WBmaVpoZDKGRO68cQdyfc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cS5t3jCM4TrHZ3kAmS1dfNZ+wIyDioyr3ft5LuPrWwAX5oBaTf1vyUh39Kp9J6msd
	 83R6ym3iza2RRsZKN8v88nTU4m+b7nQKcZIMAR5QEeS+KZg406nDTyOx5agcsUa/05
	 cIwbgSJUCljCwUiiZgiqyrZ2/iCrzIlEXIUnR7p31XwSDYSE1IsOewBop2zlJGVEMA
	 3i4JBeC0fknZ7c8W3YcmOqaa7JeUnFjaJqELCTIEy7aYOT/WloyKoNmNc2NldY33Ok
	 IF20rLgwo3ySPQmH2SdEYuwfELlhhcMBXeE5l7mF5R8tKybZrUFi4t051Vn7d6tZuw
	 fbGsJHc8zqAeA==
Message-ID: <b5dbdeda-4d7e-4056-aca1-4e1be73a267a@kernel.org>
Date: Thu, 26 Feb 2026 10:02:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/22] Add support for shared PTEs across processes
To: Kalesh Singh <kaleshsingh@google.com>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
 bp@alien8.de, brauner@kernel.org, bsegall@google.com, corbet@lwn.net,
 dave.hansen@linux.intel.com, dietmar.eggemann@arm.com,
 ebiederm@xmission.com, hpa@zytor.com, jakub.wartak@mailbox.org,
 jannh@google.com, juri.lelli@redhat.com, khalid@kernel.org,
 liam.howlett@oracle.com, linyongting@bytedance.com,
 lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
 maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
 mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de, osalvador@suse.de,
 pcc@google.com, peterz@infradead.org, pfalcato@suse.de, rostedt@goodmis.org,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz,
 vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com,
 willy@infradead.org, x86@kernel.org, xhao@linux.alibaba.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org, Isaac Manjarres <isaacmanjarres@google.com>,
 "T.J. Mercier" <tjmercier@google.com>, android-mm <android-mm@google.com>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <CAC_TJvcaJdEzK8n9BK0qgEXdzjzXtbA_Zk-ybfmG8kjNExVCzw@mail.gmail.com>
 <b82a5ac3-33e9-4cbf-892a-f0c7f6fe0c20@kernel.org>
 <CAC_TJvdgvyjyJsU4v6W+3tHKx_2e8UMJU3RT2HKLSngcC+yH3Q@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAC_TJvdgvyjyJsU4v6W+3tHKx_2e8UMJU3RT2HKLSngcC+yH3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fqou44qkjmaitibups1usrm566adegte
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2FA37100004
X-HE-Tag: 1772096588-162165
X-HE-Meta: U2FsdGVkX19/Qw1UjJUiXiX6fvb1v1VUBnZWe9t+DGumc3T8MKVouG4QiltMR2Ae7Fwb5FqCioJkJZMUvPEQT4grd6Gv6tDwvzJZiq6OZGyImPFNf0yOOnsHvoZmxqL8DyTP4wauFDXNWdTJnNmBleQaSUsCicHd0bYfdxL3ZnCY11hiP/HXkNd4j4hSRfH5wsYWXJOmfe/TxsER4YdygGKlkSqVkOB3JPJpfpNVYiMFxad4C6Z8K4Wevfj15s2T0Ix6d0N/m3znUNVsNHZuE5ivyDJ9qvyLTJQicdu/h9EOJquam9Ib0WpUyO7d4t+98wGpx6/XlHjrMO2bls16pDmUjfUb+PQDM+oT4wRIm+49qRQPFJokzL27Oo42AkHCANxy5xPZipdW+6IN960GWjYxojzrsiTToGstyygaogRFCL1lz5Npbbp7297aMrylIU3R/2KmWm+yo2+UOHeHX38hn76ee3/e0uIO9L8Yu07XmP85WOP741NQ2uJsGDI54eRXkmFb9eoHkhjK33t7CSqcwAfbK4waZunMrH+xOV5q9P2ZZuflPhBSzvZYzNUZNwSMOTNUN7RLoqoOggrw047OFG6CKgBJrSjDxUm59/bJXvV2787byWd2Ko/uQIolO3JZQVgLmqiOoODDFdwxJI1v4fg5CbLSxVv3mWdrCCKdIi6QHheJtqkwiZ7adYEYHD3mw7Yk1Y/3O8WkMwOzAd8TOEtwm98sdFG6+KtW/kR8v3C9PExGNwmufc/cs9HwTfj4j0HFm3c4mBnhZNGKKT4cuUTPdp9mjkaK7LkZAAQ/5jW+HCPGPVItUMRtn2TQoNBQHVm7SiW+vsIQHdiNlvGc3fqyWy0loBrtB81LLXbKGv0lsgVbafZRi3fYY4zm21ywPH8QauAeKVpW7BuzAoNruJqR1K8gdYL5+kpymX8SRne+hA34vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 00:06, Kalesh Singh wrote:
> On Tue, Feb 24, 2026 at 1:40 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>>> I believe that managing a pseudo-filesystem (msharefs) and mapping via
>>> ioctl during process creation could introduce overhead that impacts
>>> app startup latency. Ideally, child apps shouldn't be aware of this
>>> sharing or need to manage the pseudo-filesystem on their end.
>> All process must be aware of these special semantics.
>>
>> I'd assume that fork() would simply replicate mshare region into the
>> fork'ed child process. So from that point of view, it's "transparent" as
>> in "no special mshare() handling required after fork".
> 
> Hi David,
> 
> That's agood  point. If fork() simply replicates the mshare region, it
> does achieve transparency in terms of setup.
> 
> I am still concerned about transparency in terms of observability.
> Applications and sometimes inspect their own mappings (from
> /proc/self/maps) to locate specific code or data regions for various
> anti-tamper and obfuscation techniques. [2] If those mappings suddenly
> point to an msharefs pseudo-file instead of the expected shared
> library backing, it may break user-space assumptions and cause
> compatibility issues.
> 
> Perhaps we could advertise the shared VMAs in the /proc/*/[s]maps
> entries for the processes sharing these areas?
The current plan is to have special "mshare container VMA" representing
an mshare region. What's actually hiding in there is defined in the
mshare MM.

One could, add support to walk the VMAs hiding in there instead; I don't
remember what out latest opinion about that was. But I do recall that it
involves a lot of complexity :)

Applications must be aware that this mshare region behaves completely
different than non-mshare regions. There should definitely be an
interface for an app to introspect what exactly is (currently, anybody
else could modify it concurrently) hiding in there.

-- 
Cheers,

David

