Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A92A10A88E0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72CCB6B009D; Thu, 26 Mar 2026 12:40:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DD146B009E; Thu, 26 Mar 2026 12:40:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3096B009F; Thu, 26 Mar 2026 12:40:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA176B009D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:40:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4D1A140E37
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:40:58 +0000 (UTC)
X-FDA: 84588778596.29.C0BE8BB
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf22.hostedemail.com (Postfix) with ESMTP id B61EFC000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:40:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=MvVfAHOF;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf22.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774543257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jK6Uz6T7OCeiZ6ME5STgQy0ZxUTHM7aH7G9hl9oeWnc=;
	b=Hh1MyKxTUr+WqQvIAXCG/jDYkmzVs4dsbj133xcVJCMuz9ZULyLGlfejw82UquN47BTf8j
	iwg1+hwTTIePSNynXXN1rAXSI1BI6GtrenlaTGB2Bp9Xbtv4fCgSS3Nax7t3mENXfy7Coi
	m3OfpncNbTO4B7n3w6mUkctyoL0MLLc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774543257; a=rsa-sha256;
	cv=pass;
	b=OPqs3h2RtonEjA2SMd1WCzMXi9H0U1lfaqdVJ3+O25hPhu+qvdbkyFhHs1XxLrZfV6FpGe
	70lDoFNZ30kFnwBveNeCPl+rBTObqKVv4NPvz72oFU/JkEra1hH4Rh8qE56fERyQVv4P96
	qelwRL56BbAHAupct9wWLMqaxu6Kf4E=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=MvVfAHOF;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	spf=pass (imf22.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1774543242; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=gQjRr2k5TprDysxV6vXubqEUpN4oxQwBUxZ8r1QhyZpMMrwtbElXwQw3IwldBfRpP8xwRCFT5bw9kIFKSMBAygPqpuEembZHcBjL6PhVdwpZhtV6oA/F5V6mCeQ8Nyv9H/LBvz1Tq/UHRuq1o1BaMD8/gzcBzjfJ1Z6L49T4VPE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774543242; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=jK6Uz6T7OCeiZ6ME5STgQy0ZxUTHM7aH7G9hl9oeWnc=; 
	b=X5vseiur9iOXKLL8cXw46r+ssuC7cyOskgS1J+LIprrA3pPR0cwGwxvB4FduiFf3xoORTHMT5Ae4i9YwtWcMZbqcrgA8+a+4N8R8okaKg5y9/+TrmptZB4Xu1MFOrpO7NVgjPKzXI+HmAgrfuCXQ7JX3He5VtFMneNo6nyNV/kU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774543242;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=jK6Uz6T7OCeiZ6ME5STgQy0ZxUTHM7aH7G9hl9oeWnc=;
	b=MvVfAHOFH8ma5uLR0bv6GIuZ56wli1Cr1+SOrV2LiOFmuvX8FOH9XciryNs5Orw5
	DU3oDrQF/lHl/2OYME7NM7KtaOrD6R2c+aweDTXP66PmsuYCIHllzpo+pdFOlbyLN2M
	rIxoJ+y4IJMMBbxjWuIPwAmep7IVIPxCP3q1/Q6U=
Received: by mx.zoho.eu with SMTPS id 1774543240502241.26226366341768;
	Thu, 26 Mar 2026 17:40:40 +0100 (CET)
Date: Thu, 26 Mar 2026 16:39:54 +0000
From: Josh Law <objecting@objecting.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
CC: Krzysztof Kozlowski <krzk@kernel.org>, Josh Law <hlcj1234567@gmail.com>,
 SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 Christian Brauner <brauner@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/damon=3A_introduce_DAM?=
 =?US-ASCII?Q?ON-based_NUMA_memory_tiering_module?=
User-Agent: Thunderbird for Android
In-Reply-To: <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
References: <20260326072737.341964-1-objecting@objecting.org> <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local> <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org> <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local> <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org> <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local> <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org> <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org> <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org> <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
Message-ID: <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Queue-Id: B61EFC000B
X-Stat-Signature: pr5ogoeegi76ihomsk4p6p7gnmp5qrdo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774543256-148154
X-HE-Meta: U2FsdGVkX19GyVKEyfzOnhysQATgrf+X8a2KfMnIe28IvqBw7KvAI6RKY8WePMrD1om2LZFuE0VWW1NwDhKJj6gVkLjGG78+g3Rqq2JOEg/9T7hdqgYrjVhM5ZTs21o0hPtlnYS1Kc3DaP9zcawArzMWQ0Az4XTMf/GfyN1u3hWU00UopWxuJnYKbLgcani7MpZt8OmbqL5ReQNdTC1ruUh6lLsaXbfTlLtfczPK0ZheELk4QFDn0xW6UpZyIdrkDzaOAS3MwcVz+9guRtcZaVVDCZhLRsNIB5OzxC18BtBnUR7KkFyg+NVR3ztWX/jPVX34XoGb1p9DYzMTYBmMkkxsi9VJhiqAZgZCODZTznPAJ7vOoagwn2d0b7FHFnBgcl8qFyGzXVeFOaQSTIjGSlaL0QgzcoaM7BKIfkZV9t+6KbwRcNNGl821ATYY7Pzwivsl1HcCTlNBv9/SNXzaxJ4MwiZIDoa4tBKsU1gXmLZ0wOop43CL9GStgNP4PlaxUcV7dBwc7+5uioZIgV5DgEu7Wr83O3RhvOb85UOC4j83VXFeztUxjj/eikKKoVbER4Hg85IheCcnfdIzXGvWhkR/rE+Lq1Fdv8N8eoaObfMSHmdkojuxJI1bgzUkJ/XFUSWZIWwhdYene7YCbcQijzEiF/ze0qCNTqOGwwT5Uso/487sufG2YQPYZdJexYmggk95UfcC1Qz2iBMS7qwRBOqp+u5SAzps4lFL2fMvxJUvK8IjwJ9MCTw3H6Gtv1162gK/8Kq84KT5mlGC9LX69ebZMyheOXaHrTYjK6Chj8thQdMgfh0jeuubpqIzBDmoaA4MkSp2Bivjb6WriyTtYYP6+jfW4q78MBQ229SDUE/SIAXmuLVCY3cYxW97Pn+8qKRq6eMH9dILE1WwrngwgXlg4naes0tJXfZJ2hjtOlucAOSXfUkl6spdkhyjkVlbtoElXr06A4piySyh0GZ
 UndRdx6J
 BlXMHKs72Tzo8IHcZ0hmkLRysWfdKfJVffLta7YakHJdVCAsS/E8U1coZ8Fav/bHgQE75P9juWArO/GNWL6ElSYlrG/mRVDyjPzDXMOJrc46CioyxI0LeUPNt20d6+aiFAWPLOTkcNXSmFubnVOmIYdyg2Bogb1IrQK9dZFXDslu4um1GgTuCFHKWtMwKXidK785aSfS7lvOsp3wtIfr7bV94Pe8OVo0CDzjC6Nowwandi/xUhupotoZaZpwcozqwpJ7zmXVdyR1tnDjxMWYM9ht2DNscBwbKANdwKoxDPiHDM+tE7vsjQOi5FJ2uAA7p378Pl2d4wIjsNI0rDGemOOavEj75FMaUtW346KjadzytzU5pqXVMde2+8ttN8j4Gb8RuBkNqrBR1lWwwO3jn+EVBmxGhezc2JGJfV5Rkl6jpeDQ+zymf66+3qupwKC9csluWXwtOs+ciou1c9J6fpIzwUVKh5STM7GNROHjHLaEEeWYTKhGFpGnpnF0vz93Ajl03QFBytk/cfymKEwBW7J3jAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26 March 2026 16:33:30 GMT, "Lorenzo Stoakes (Oracle)" <ljs@kernel=2Eor=
g> wrote:
>On Thu, Mar 26, 2026 at 04:10:42PM +0000, Josh Law wrote:
>>
>> I will be absolutely transparent with all of you here, The commit descr=
iptions
>  (The long ones), Use AI, to be exact! Claude sonnet 4=2E6,
>>
>> Additionally, I will make a promise here,
>> All of the bug fixes I made, all of my lib/ bug fixes, are made fully b=
y me,
>> (minus the commit description for some of them) And I can promise you t=
hat on
>> the bible, If you have any questions about this, You can always ask me
>>
>> Forth thing: My patch volume
>>
>> To justify my patch volume, I am a "excited" Developer, I love the Linu=
x
>  kernel, and I have a passion for that, I am very very sorry I filled up=
 your
>  mailbox with my slop descriptions
>
>You're obviously lying, and you're not very good at it=2E
>
>To reiterate:
>
>  Assessment: ~95% probability all contributions are AI-generated=2E The
>  evidence is overwhelming:
>
>  1=2E Volume is humanly implausible =E2=80=94 ~30 emails/day, 5=E2=80=93=
10 new patch
>     submissions per day across unrelated subsystems, from a contributor
>     with zero prior history=2E
>
>  2=2E Breadth is the strongest signal =E2=80=94 no human newcomer simult=
aneously
>     finds subtle bugs in bootconfig, vsprintf, base64, bch, maple_tree,
>     assoc_array, io_uring, AND writes a new DAMON NUMA tiering
>     module=2E Each of these requires deep domain-specific knowledge=2E T=
he
>     pattern is consistent with an LLM being pointed at different source
>     files to systematically find issues=2E
>
>  3=2E Bug-finding pattern =E2=80=94 the patches cluster around unchecked=
 return
>     values, type mismatches, resource leaks, off-by-ones, signed/unsigne=
d
>     issues=2E This is exactly what an LLM produces when scanning code fo=
r
>     potential problems=2E
>
>  4=2E Rapid revision cycling =E2=80=94 bootconfig went from v1 to v8 in =
~1 day=2E This
>     matches AI regeneration, not human revision=2E
>
>  5=2E Feature additions from a newcomer =E2=80=94 glob_match_nocase(),
>     glob_validate(), debugfs BUG/WARN interface, and the DAMON NUMA
>     tiering module are all non-trivial features=2E A first-time contribu=
tor
>     proposing features (not just fixes) across this many subsystems
>     simultaneously is essentially unheard of=2E
>
>  6=2E Zero ramp-up =E2=80=94 the contribution stream started at full thr=
oughput with
>     no learning curve visible=2E
>
>Please go away=2E
>
>and >/dev/null to any further correspondence from you, other than NAK's w=
hen
>necessary=2E


I am withdrawing all pending patches, I am not gonna even touch artificial=
 intelligence again, and I am going to take a couple months break


Goodbye=2E


Josh Law

