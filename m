Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0571FCD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E1C06B008A; Mon,  8 Jun 2026 17:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592866B0093; Mon,  8 Jun 2026 17:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8906B0095; Mon,  8 Jun 2026 17:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3F56B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:19:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 042C01C1699
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:19:43 +0000 (UTC)
X-FDA: 84858012288.25.35414BA
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7158740007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:19:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Syr8Mk8V;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780953582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ec90fDW6R1sxEf3CKA876D/56qUgFC7LMDsU+008II0=;
	b=U2mU/KrEGd/5ln/iYi0sGKJR6qMDYnYsklw01h3tKQPkZGNlHaqlFS1xedwCQIhqHD/Hxa
	QDBh0RGWcTWguviorJtHtOcr+4Jt+zpBfRgHGQ6Fp/I+DJ4NDJNuiVcUhmuQB6SggVSfjN
	SYXx0f+LvY18SdIRpgQ2++O3qkL/1xU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Syr8Mk8V;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780953582;
	b=brx/AoqbqQCFKCmbGTxUZMOMIEpAd/Qa40n5ef9LjbRKSfbDI+Uc7szi9/ot+qB1saZaAw
	c8Sjvx/Ejnp6BuGLbpL8Bk7oUKV2vx3KI6ZZUKTKJrBOIIoDy6W0p+kWfnahAzlOrKQAgo
	iwdCQL7ywyfLmFxQPSDMUzdFjX0HiK8=
Message-ID: <744aae62-ad99-4534-906e-92ddad978ee1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780953579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ec90fDW6R1sxEf3CKA876D/56qUgFC7LMDsU+008II0=;
	b=Syr8Mk8VuYBPuflxy2C5a+UzMAxzS2VQ7Z/rDte8Wea1S+sZyARjZHSFqQCG/9wawqPSle
	mseN3YCCbFVrGJn+n3/CLJ1yTpWTd0pYGf9NJSrkQC3L9Gq3wEiyUkuyao95bnHpoTy4fy
	bgm7AUI4gXHGKSP9R4O+mMFYCkl2O6Q=
Date: Mon, 8 Jun 2026 22:19:36 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] mm/vmpressure: reduce CPU, memory and code overhead
 on cgroup v2
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, mkoutny@suse.com,
 roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org,
 ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, surenb@google.com,
 vbabka@kernel.org, kernel-team@meta.com
References: <20260606114158.3126210-1-usama.arif@linux.dev>
 <aib11jSWosT6635u@linux.dev> <750406a5-1819-4ca6-81d8-5a1d82e0644b@linux.dev>
 <aicdqucZVqAUfh7N@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <aicdqucZVqAUfh7N@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7158740007
X-Stat-Signature: y4c4yueaipi5qdy3pskbp9tpqz6rrbe5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780953581-243703
X-HE-Meta: U2FsdGVkX18xtqoPhILriVDVLc8zntzYqF6EWS5/NKdGiuQbU2RJInmSzRADIlU/8WgcLb3ZuY+NujEydXhqQZo0xnQKqdfqw6+A6vEPn3NJUTzJM9rzJ07tazpH/REaRLEbux5fcEqitvXwinML3BV7NNi9LjpqWuxlI8NSg4214nz6nqPfE+WtgLvBLOVcXaUgBqItAaOTeOQlFOsh2zIxDBquUkF57N9LHBJQN60fCO9J9Dwtz87a5mqczJyR/0CPceAcnDp8ypoKWz9rPsu/Wv/YJnmQXsqiYd1LKP9KeCDt8q30CeRzaAyAq5TiMzfQEkDftltRnlr8E0LIp9Zm5i/zTr16OSLkvNVtsCwCnE5G1P0T/87ayFVOIt2p7QRj7EFYJpQNFTM1q2RCRYRGXftS+3NoC6M1jYWmCVk42WRRs9bR6MQLADyheoiDxbugOdDUIDKOpIHVlhIWsTdQBl7TeqwfLTnhLwRPAtNFKQKDQ2lHr7qQJmK4pwp8oQ4b+V9OoO+WnJW80PVyreoWNqA/KRkKToUNjm5KNoaMVClPRwk5Z7t8kQAZbnXWj50R2LIv6LMR3TtAf8rbAV7fej3sAcXIa35Ifo3Ir7YZcrLuUYsuH2OvnPT6e2ocoGmELyjC9KPgNfHjtZ4r1O2cQxq6EtYpEuD20AYtfrk7eQt/3IvWhCvSZLr2snKas0KNSmSU3pzncwIH7CgAed/3DcWQUmUS4x0GftmTKuvZTtmjGfpijRnH6SPXXkqzoLeUr9rAN2UvUtiykAHaEeiPOBR7oqdDRVIr92CWYKAavnMvqTXyZxQ29vcF308VUES4BC2LyWSGU33zwRu/qy/8iY0nP2/ZuklfsxDUxC+q82VdV8zjgZ4eVQPpFP7hlFbMDYvmMV/v5dAd1f/1FKKF1R6rl/kqQRYa3ALEtOw7Je0H82e1jbQ7gsxXjOixABD7cHbJJP+bnsnwfSC
 mUBtj2xM
 P8pKOFxXUSedNHLQ7x80fq1x4WX3A3XOMK1kzFWkMn/XNggFYCTg0AekNbrSbvt5V03A9TC+K8VA6Gz4yc+iKeatrfR4ljj7WyhB/mahXC+TlrvIGQcs8TYHuA2f12FK79KOwFPUj+Ugce6x6CjWrEG1YGnH7lX0AO0yNLA9TZ2ZuNfsyRaHCdj5qunrszdRS93K9LJckO5HYXY559rNZJ2D/lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/06/2026 20:56, Shakeel Butt wrote:
> On Mon, Jun 08, 2026 at 07:49:45PM +0100, Usama Arif wrote:
>>
>>
>>>
>>> For this, I am wondering if we should just go ahead and work towards making
>>> vmpressure memcg-v1 only unless we foresee a lot of or complex work is needed
>>> for that and only then patch 2 makes sense.
>>>
>>
>> I think there might be a transition needed? Because vmpressure and PSI
>> do not work out to be the same and people might notice a regression with
>> increased memory usage or a hit in networking performance and might want to
>> opt out? A solution might be to switch socket pressure to PSI while
>> keeping vmpressure around gated by a defconfig. And then in a few releases
>> remove it completely for cgroup v2 if no one complaints. If we go down that
>> path, we would need patch 2 for the medium term.
> 
> Yeah the reasoning that PSI is not an exact replacement for vmpressure makes
> sense and it will take couple of iterations to transition v2 (networking) away
> from vmpressure. Can you please update your commit message with this and about
> the midterm or transition plan.
> 
> I assume eventually we will just have vmpressure-v1.c file which will be behind
> MEMCG_V1 flag, correct?

Yes.

How about something like below in the commit message? :

This split is the first step toward eventually making vmpressure
CONFIG_MEMCG_V1 only. The v2 in-kernel socket pressure path
(tree=false) cannot be removed today immediately: PSI is not an
exact replacement for vmpressure, and switching networking socket-buffer
back-off to PSI may regress networking performance or increase memory pressure
in workloads that today rely on vmpressure's hysteresis. The medium-term plan is
to introduce a PSI-based socket-pressure path, keep vmpressure available for
v2 behind a defconfig as an opt-out for several releases, and only then
drop the tree=false path entirely, at which point everything that
remains in mm/vmpressure-v1.c is the whole subsystem.


