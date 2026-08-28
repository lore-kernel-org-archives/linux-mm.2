Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3210AC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F1F66B008A; Fri, 28 Aug 2026 14:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2DD6B008C; Fri, 28 Aug 2026 14:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B96A6B0092; Fri, 28 Aug 2026 14:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FE4E6B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:56:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0538A3D9C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:56:33 +0000 (UTC)
X-FDA: 85151584266.20.A6E46A2
Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9342DC000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:56:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D27vTXo3;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787943391;
	b=R4VWjgcc5+0qdNQsssGrYUQ3ZTtJB1GXswrkNbY4pY73zHuhjOHt3GrnaufKcADyS6+P0I
	hpl1BubfNFo6D6M2CxIaqOHgghyQca6MEIm3/m7SmkAJZ3VE+F56BCojdkc5HLBDgnmdnM
	XHDNv4qr4CiOQ5BkcEe/Ekt9J/YX464=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D27vTXo3;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787943391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2FM9TT69Ljcb9SugwXV1nBlWkfDsb/3v+jdpe3Hb00A=;
	b=7YurjugVQnXAUk2XZAmhvXiNR/gBcfuJ59oUDHigGydp0ooFsmoipfK/zMLRfYu0lFaixr
	BZoIGq0du/vg0docq4vfRX3MNSqiOy1CRy1UQstez5uUgACKfBuSxB3x0xJ5mC4JDMcOUC
	OLQQm44loBOGwZbIVovnUq2TKQgc9O0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=COHTECr9DeZAX32asUSS//tsR/rFjizcv3IDQHcOnVU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787943387; v=1; x=1788548187;
 b=D27vTXo3I0zVioIGEzXP/NUMSyfjk1F4R4aR0+9ZYgDw0uMHkZStrpg7uYiW5cRvwUe+S76I
 hyoH9wic34ZB3zA93DHOo2Vce6FS5/8uE/cmrdNzTzPMGtESVYVkD4dNMGCvde6t+RVHYm+/Vv8
 S2A5dhriYmOBzgzrngMH4Jew=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b3b004b6420231b8;
	Fri, 28 Aug 2026 18:56:26 +0000
X-Mizu-Trace-ID: b3b004b6420231b8
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 11:56:25 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
Message-ID: <apHZti_C5udMRh2i@linux.dev>
References: <20260828135036.7d44361f@fangorn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828135036.7d44361f@fangorn>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9342DC000C
X-Stat-Signature: zgxm5eew5a1a8t9fxudcpfu8w4hadhr4
X-Rspam-User: 
X-HE-Tag: 1787943388-907362
X-HE-Meta: U2FsdGVkX1+AiNyJliu4tJMc7NfgBncpTakgMsxlnbpi2kulUEhfeFDu2cygcmfCJCqATMge0ygHjLJya0+eVwdXiEilD/n4RKYgUdyPdsneLoXUS865PQeGWftJmopOY0i8d8Gh9jJnjg0VbJS8uPKA+LoAdaIWZyIeqcQFgVfXBn1KroO9KIKiieJVqFESBNNMwVO4LRI8UO830928ASKEmNFeZdDwN04XoO9Zr6XWPhRY1ZUjWJP/EwO6hY1VE6k6riJ+ejj7STkp0gotgVlSVBkYVzFMqvBW2OKMwtHJrnWb68ilIcUdn9hj0ETLWjy0gQciSp12LaejVKX2QgYIuRlFGo7NJJGWhSw2QAho1bE+NoySTEaaAM1Vyhb+YbwL0e37cTfHxqfcbqN2tld+X/RxV5211QBhnKYe9NGOiKeX2gNUVHuDWNj+jQ2uRFVzgl/9aGOTMXR6A+OgfVV7XTdFU1BYeux+gPU3N7io++owGYaYN/DMVNzWDwBnnLPGyol8cz/rIysZL+txJ5j6FF7TWHKzRj/pw4horG6wX9HfjNxWDoYuNpVA3reZ4pIeNBgh1P936Whx6+GIkGNiizx4Swj9A5psVvU+/g0CLWGNN0j7yyNs6JFUOWk8l6HvVsmW4IcXa0XHr5n0diLCE4NqA9ZjtGWF6ii2YRsKy1yJg4PjiaMalLzqFz1keS1apgBFJMMgnNfWHIqlCb4A4TkL1XfXIsER5TUMtJQnlNCrddyGI9eMq3r5I+2xaxI5HX5hewul6sbJ9eVDV5FmsnGY0Uq+27Xfk4GTdEFJUfpSpgORSWwsQqF1BaEhAfNVAk3C3AnWcMvLPUECaOqSW+KsxqTRhmqz7PSGLDugzbA+L3i9PDMWANto+cyuQgzHzzx7Gd+Z3mh99UXMPhmQIJCVxSYyqic6uiNqiXqPsDFQSoKJBopzGCQGhPsCeFSEpMPE7QOwOCaHfWg
 R9fciWgC
 /QoR+V/E5I308iWmLlXIPA3cr72REPmy1AhgoGZN9kG20ZCnxhGcbFz69JpOI7IZ1MXcX1O/96QnKw3+HQGE6e0Okzsm4KxpFl6MycPcnvyqMpntJd16fo5w87aiGL6bXrwkvNgqDWLDnDn076MqfSzl3DXdvxziIeOD6SIYZGnIihdB69iIXH8qv0IY1k+tyWlZU6fUtPHRypUJKZ9vJnSIk1Sli7z85ouLT+GJBPzw0/IGG7lwQHqgZ2w81XU5nRD/FhEOK5gi1DBB7Aj5XgFUSp2Fmdu9/jf+NOvb61lQHZd66vMugCl0IZFQ47Q4VpDTV6lyJ/UBLNmx945o5JoMAmK7qvlo3LnKhA1uyDrVPy9ZFrtaZcQ1bydC9Hu0Hf7vYQlmSiMQw2wOdrLUb7snuh2gu1qK4z0nTEiMbvjmECop0TVYnXODhPu/Ye0DbiK/aukvLPOnRLKl21mGczzg95sW82/NWDQKFxDsIQ3exGQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 01:50:36PM -0400, Rik van Riel wrote:
> When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
> isolation, schedule_drain_work() can drop the work in a separate RCU
> critical section, and housekeeping_update()'s synchronize_rcu() can race
> that second check, leaving the flag set.
> 
> drain_local_stock() only clears the bit for work that ran, so the flag
> remains set and the stock is never drained again.
> 
> Have schedule_drain_work() return whether the work was queued, and clear
> FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
> isolated, so future drains can retry.
> 
> Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
> Cc: stable@vger.kernel.org
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Rik van Riel <riel@surriel.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


