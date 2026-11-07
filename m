Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC0C2606A32F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 18:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C1sYa023
Received: by kanga.kvack.org (Postfix)
	id 94F1C6B05BE; Sat,  7 Nov 2026 13:20:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90EA36B05BF; Sat,  7 Nov 2026 13:20:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF5D6B05C0; Sat,  7 Nov 2026 13:20:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 527B16B05BE
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:20:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE0A71C3788
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:20:15 +0000 (UTC)
X-FDA: 85409137590.11.79478BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 08E511C0006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 18:20:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1sYa023;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794075614;
	b=FClwbIXwdKvSaqL5IOjTavXawqcVWPeBgKpmPRQy4j5N/nDY6XZ59EhyZBhP9/7qqNcmvH
	gWOKeFOzHrrcfOE13TLU1pndIEq3jGcn/4Pg3IKAKzl3B5IZcNPxfRyB+hb3ODSfO91Ulo
	HQxwDpzYgH3//wY5/wii1KmWqsLvwnY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C1sYa023;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794075614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pjnHje6Qb1kHlz8WaN4eNa2MT/clIj+haAeBAgYG+k=;
	b=X+u73dkYdFd57u3EKTTdiLgsGQjQQGcOQOxfPK7yY+WZH/AAh0jlNUjLJCV0sSH5YLbXVK
	mp5uingyEV3MtRBlGUISG9hhuJBOawfdqmXfcNvBMFEWZ/MOoZMCBisLr/v13VoYUsRG+z
	Zk4VIUZsfCly3+krWGlBG4gxoqD4ibw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3DC7412C7;
	Sat,  7 Nov 2026 18:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0C21F0089F;
	Sat,  7 Nov 2026 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794075612;
	bh=1pjnHje6Qb1kHlz8WaN4eNa2MT/clIj+haAeBAgYG+k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C1sYa023IOebqDzktccEL/GnqdyMhlnIn18DNUC1Sgtp9yv+XhSCgYpBawdgnNPGJ
	 1jmy08jxGm7xQR2DKYEEO9QPKbm2XQU3r1B6N5nBPd4HMWoU+CLSk9mGC3982NUaYj
	 0WEc5R8QPvn/ArI2m14ey2IbiN5/k/GUKWBYoD7IV96S6YDdd3ctTYzroOtVACDTPn
	 kCLsaKsYERXgamn3Tv2at/jQX1x0iPX4Pp8A4dLYVt25eXkKVSqioBAPcwYkpQgKy4
	 PHJHTdaktocbt0gsWvH+P9L7jyt0OWP9th65AJD+QgiWizezgsGd0MHJDlQm91ilHr
	 mScwirajJmJQQ==
Message-ID: <af5ad990-bae9-4bdf-9109-1ac3e6c15e94@kernel.org>
Date: Sat, 7 Nov 2026 19:20:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix softlockup in do_pages_move() with huge
 page arrays
To: shao.mingyin@zte.com.cn, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20261107213856462Jx8pIdgdtLvPLfOFTwV4X@zte.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261107213856462Jx8pIdgdtLvPLfOFTwV4X@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3nqyupigsgc65pseq6rick7mwdne6y5f
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08E511C0006
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794075613-607418
X-HE-Meta: U2FsdGVkX181K529rr3fhCBxxcfVLQpNL28qT6sME1B+m654Z5YAzMqSLyFIGWYsGzxiXqWtH81gY59+f3bB0BLirsC6TIHNKbsZsB2/5Rq15spE1vPzIEMkq68YyN7q5+8Zh+dKksXG5KlR6n7znic9z20IYriAl/SUbPpOpfp49QTiNYb25EP9+4LXWZ1O4lLFbPk8qVxxMiqjvEE5jgHz8KGip5lfDDKlO/fhWmUcmT1SPMvjySqb9upEvs8MvW3PAibsoB4h5O9BynLJBNB0+NoYWlFKki/Yg2TFUrwuhYUYeZqrl3RHKCjw4XbiXJ9iSMh64kTfgHG1/3DLTQSCM2zxbgehjXV12FFnurQr+/1SKvyC/T5jwVQfy4BXjz+IhdYzlc0eL4pU+aaPDBBlro5Yok4HO7kAGqcOt2HIeHorS+GZMym8RKHjPfvzvthsU0+A5PIpMXm7CAhy5RTyDVzOaEdNTlEgyoC2U8xEa5YytHbuG168DcN6Npx5uKDeJqlDKhhtCCNdVvqmVanIGq/miYqMjfL0hRtj7HLhnylrSlHytVjr6KpZ0lxBt4a6OwmhwP1Twy3DlP/jmZrIqq8yTDHYBxAd7HfyMcmMo6hJmAcBAGDwzLt7iW4NWN1Sz9SRuwv/7lLRE1KozsDoKqeWgfkNtqwDvC80Y2GqZK10Gyk6OKQdDoac+R7LZhPu+DAWvjz+hL6YmpKmc2sBS9AHoNxTZjBdgTVNYP4kjSXWgVhakGZOfTkw7SBi+BUF3ELudhJPru2cFXy/M08sYwB/eEwwXMBtCsFeNIvQv3agIVHXgbGv/jdQ6sGhfOezGX1tu/S4OrrP0d5CIaMVsVPwblnYk/j5dgacOpmoKEA/0G8eNOef0I8XLEvbwSWdE8dPhH3RakMZ2RQW3FySsMr/XT5niOcADzA/w5D9UBoAa4JzdVJUbXBp9+DL1k3u4kyIa6OjxMgRIRR
 U2ZEmY16
 VVeJyXsWup/lF53qSbqRpPW5uKmR/K1RESjuaPvK4RT+SLRbRl8OF/XRDUlCTUOph6ceA5hj+X++ZG0tJFzxvxcH7Mybr6VwVI3N58maWi7Z9LEYpE1pNXrutDbJNl2OnbJTe9ciIsaulJvVD3UdwSrFH3t3c9JwTFVBzUOMtlKH9y3udnE3wQUkevSY3zZGhy/ip8ux6QUQcLJRIc5azvSs3i8kbCHnwe2Deh71gYyJONu8EU+qrAYNxO9z4lWT3/8df4gMtBft1FUOflBon23IaPXK7uf1AwOfgTA0w/bObD7vFwuDTrG0yvzPVXhnuFh96zE02fo/XCFwtMry8ZAetc3/6wmiCUZ+qYo/96YibWsq9mEpV67qLnfI4yO90aHyCcXsxBNhoDZSJCoaY8F+WL2qV7Yuo5wibidRg6/UW82UD8RxK824rAVEaewT5Ke7Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 14:38, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
> 
> mm/migrate: fix softlockup in do_pages_move() with huge page arrays
> 
> do_pages_move() walks the user page array one page at a time.  For each
> entry it performs two get_user() calls, an mmap_read_lock()/unlock()
> around a folio walk, and an optional store_status(); none of them has to
> sleep when the arrays stay resident and the rwsem is uncontended.
> move_pages_and_store_status() returns early while the page list is
> empty, so an array whose entries all resolve to the same node can run
> the whole loop without any scheduling point.  nr_pages comes straight
> from move_pages(), so a huge array can hold a CPU past the watchdog
> threshold on a non-preemptible kernel; with KASAN and function tracing
> enabled, ten million entries can exceed it.
> 
> Add cond_resched() so that long calls yield periodically.
> do_pages_stat() has the same problem and is being fixed separately.  In
> current mainline only alpha, hexagon and classic m68k can still select
> PREEMPT_NONE, and they cannot enable CONFIG_NUMA, so this mainly
> targets pre-v7.0 stable kernels.

Please share a real kernel splat from a real system.

-- 
Cheers,

David

