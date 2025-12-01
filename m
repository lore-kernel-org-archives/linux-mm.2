Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D07D3D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 15:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0A66B0008; Mon,  1 Dec 2025 10:23:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E888D6B000C; Mon,  1 Dec 2025 10:23:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0076B000D; Mon,  1 Dec 2025 10:23:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C881A6B0008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:23:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BA92139CFA
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:23:55 +0000 (UTC)
X-FDA: 84171272430.11.36AE749
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 22B5D16000E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:23:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ije2gOoW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="lqk8Anu/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=p9gFsivR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="rI2VA/3C";
	spf=pass (imf08.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764602633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAQKP7v+Ibe8q7BVB4/nqAajnVlMQ1ph4Phc3yhzw4s=;
	b=ceF8pq8DPo+LRn/0sNCu3bUZm+tgfwBgL2pxR7WPTilKxN4D7GFobC/D9UA8hg+vNkkuvI
	N/tQc5iDn1/r5RBB1JIXgHzYoa0j8+LU/89+w2TA5hqGSAMfNJV82wGyt+L0rgx0B4v7eY
	oj7MnjjZn+2uQwrib91D14P5tv+/PgI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ije2gOoW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="lqk8Anu/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=p9gFsivR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="rI2VA/3C";
	spf=pass (imf08.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764602633; a=rsa-sha256;
	cv=none;
	b=pGgkmPso3RnXRy0URJNiUqbcqNySPqCKDRKIj/HhkdD0Ij4ADBn9ONELNBUe2A+mVI1CGT
	8DWQcJbVLBGP2ZvzS6u3UpLDZrFQU7mgR4LbyFfrF4H0J2A5QjXUWHVkRacL/G7YA7dow/
	UIFt7XEODQyjfhRZSp/Bi1zxwjoyU8s=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 173F55BCCD;
	Mon,  1 Dec 2025 15:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764602631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jAQKP7v+Ibe8q7BVB4/nqAajnVlMQ1ph4Phc3yhzw4s=;
	b=Ije2gOoWwme9kCE9ifCw/vdbvBGpa8gPAtBAWLKp4SmRIZYXSdCiilo6cjXw56f3rf1GBn
	9WeDjckjwU3qHdvfHVfPzSygRCsfpPxsaq3ZYniP8K4JwA4jAtQ3SuIQxlgelZIup+xyHV
	J9IDa1b/emJ8X3WQJjyJekumHCYWt6Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764602631;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jAQKP7v+Ibe8q7BVB4/nqAajnVlMQ1ph4Phc3yhzw4s=;
	b=lqk8Anu/Kr3w0MDLWalVoxaDw2o0hNNi95m8tUANM76eF+z62KpWXJj9CIGhEle3XlhVM5
	TQP/IsHf8awhCWBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764602630; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jAQKP7v+Ibe8q7BVB4/nqAajnVlMQ1ph4Phc3yhzw4s=;
	b=p9gFsivRbacas/GZNRn4R9HWNDGNJkYSkPD3pvZrmXZ6YpS5yr1xi6kA61DTQjvqYjicIt
	UFX2hAbM+zH83RvfctFpTHTgFiGexh0+vYoYKP2kuxjEE8yScwmdWdbU3Jt/rdK7wSigHE
	1Dwt6SlQvi8wkkh1XXybWXK+PcQxc9o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764602630;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jAQKP7v+Ibe8q7BVB4/nqAajnVlMQ1ph4Phc3yhzw4s=;
	b=rI2VA/3CpKmWvJJiW4NRI8ZMlWzhVXv87vNs9t0H2FLegMt2jXnYvQBJJPxdDDPNVecrO3
	SLjLRPEOyi9TRgDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B95E63EA63;
	Mon,  1 Dec 2025 15:23:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xzvQIQWzLWm/HAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 01 Dec 2025 15:23:49 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Jan Kara <jack@suse.cz>,  Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Shakeel Butt <shakeel.butt@linux.dev>,
  Michal Hocko <mhocko@kernel.org>,  Dennis Zhou <dennis@kernel.org>,
  Tejun Heo <tj@kernel.org>,  Christoph Lameter <cl@gentwo.org>,  Andrew
 Morton <akpm@linux-foundation.org>,  David Hildenbrand <david@redhat.com>,
  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,  "Liam R. Howlett"
 <Liam.Howlett@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,  Mike
 Rapoport <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,
  Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
In-Reply-To: <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com>
	(Mateusz Guzik's message of "Sat, 29 Nov 2025 06:57:21 +0100")
Organization: SUSE
References: <20251127233635.4170047-1-krisman@suse.de>
	<f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
	<yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
	<CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Date: Mon, 01 Dec 2025 10:23:43 -0500
Message-ID: <877bv6i5ts.fsf@mailhost.krisman.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 22B5D16000E
X-Stat-Signature: 7cg85sqb1n6kmsae8njra3w69wta9zj6
X-Rspam-User: 
X-HE-Tag: 1764602632-12913
X-HE-Meta: U2FsdGVkX1+pXgLas0lGS9fCMuI9YJT6JhQUJ5Egi7G5E6MhxDABFdyxqeigY4do4KRO6os0d8PTHazBI7wOurawREl2eun+NAk8U9yAX4pnL33/gLHRvqpMZkPcyutampHwYPJ3Em2TaEd2iaNrU3tgQBnJpYBx6hxU3vrBQ+02pgYsmQXq0Ya/i2oH/9MyWcINFho2kwKi412hZqnX8dv7yYO0aJwfyW+PUt6W2B+est/jJNSH58rFjsMDqwnDS8fO+u0BwJfjWyvEanNKPAQf82mKTDja1THBFWsmG/yAKQg/dSeXQILXEl4wUiAdeE4/xvdckSBk/pfjfIpfa34aHcGkt7Df7zZWjyCP4DW2bsiaGk1tT9ZOfNcNBMUDuwdxiCSBUMlG6fn9GaFpPCmYtBBxp+G8TULgFE3JYQdMHAqGU1dKBj+4EIzPe/uACAf7lDfpcddnWIpCwuX0aaYFCx17AobCCCMHqX0agoxlYTS7unP5mf1P+9vWD5VLtRQc1kWp2BHizLgZ0v/3vEB5WaldcsU975SIEw/4AUgPoDcvlf3N4CNjSNhfu9RuoukryH3s065mIs/w/fwQyRHCgOVsHWvnqchj19aVGnHnZ25yjTEvfdqeoRBg9NABuz+bVVfekNPiceYerJUCBiRBDEfIiiw9t7NaISjvWOAbm1ZaPJyzK3S681lm+kp3On8dQExsxQGsSf3mg6/EAV1aC8Px3/pXa1WysJSIfydsT+R8J3kesAV1b0VwAXbCqq7RoXTpbT5wNxzGHxAZPwIXh5UaHLndN+6CZZBzEDG0Jur/OYEqr+4HWA3Zc5VUpVPFF5FHjn6JSm/cffaRP6of44XuFsxMAUR8Nz4gKXZ0XnwbfTUKyuEhGr89bbEQlLHfP0zdbXc99p31QCmc88/boo7Xoc7SY5IEkyp1541Ov705X/SX35ikZeetUOHG/oguzT46sGa5JiK7c/e
 omVjgMuA
 3+IuKOZTsDnA4k52m0i+qPl0h7GBN3vhukGWU6hnUtDBYubUi5IYBqroAEcUFSGjGQrZvdRqFLoRSaShb6Nk2CheS8ukiMUKFprMxI4/T9oPiZ1hDGHdgK+kDVYc5V8WRxIN9yAfQ4GhZ43MfJSv8hYvOqAAjwSAishITxZ4ncr5qrHYVP00H2ADSACjwxnLVYiezDzlXh4BTKJFz0JfeTMn7vG5NRTuAN7RM+Kn74nMKkf3vRhdhhnnPzcY4STBbdjAaogUAXr5UTcVotRRK1QO6gq2TbimthAUqBfz1oSuqU/9vUu4WhD8cESxukLWXr5zXR/wmxRpy9/PjP2iskWjLTNtN9Yap1JjI9aTi12OUTOI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mateusz Guzik <mjguzik@gmail.com> writes:

> On Fri, Nov 28, 2025 at 9:10=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>> On Fri 28-11-25 08:30:08, Mathieu Desnoyers wrote:
>> > What would really reduce memory allocation overhead on fork
>> > is to move all those fields into a top level
>> > "struct mm_percpu_struct" as a first step. This would
>> > merge 3 per-cpu allocations into one when forking a new
>> > task.
>> >
>> > Then the second step is to create a mm_percpu_struct
>> > cache to bypass the per-cpu allocator.
>> >
>> > I suspect that by doing just that we'd get most of the
>> > performance benefits provided by the single-threaded special-case
>> > proposed here.
>>
>> I don't think so. Because in the profiles I have been doing for these
>> loads the biggest cost wasn't actually the per-cpu allocation itself but
>> the cost of zeroing the allocated counter for many CPUs (and then the
>> counter summarization on exit) and you're not going to get rid of that w=
ith
>> just reshuffling per-cpu fields and adding slab allocator in front.
>>

Hi Mateusz,

> The major claims (by me anyway) are:
> 1. single-threaded operation for fork + exec suffers avoidable
> overhead even without the rss counter problem, which are tractable
> with the same kind of thing which would sort out the multi-threaded
> problem

Agreed, there are more issues in the fork/exec path than just the
rss_stat.  The rss_stat performance is particularly relevant to us,
though, because it is a clear regression for single-threaded introduced
in 6.2.

I took the time to test the slab constructor approach with the
/sbin/true microbenchmark.  I've seen only 2% gain on that tight loop in
the 80c machine, which, granted, is an artificial benchmark, but still a
good stressor of the single-threaded case.  With this patchset, I
reported 6% improvement, getting it close to the performance before the
pcpu rss_stats introduction. This is expected, as avoiding the pcpu
allocation and initialization all together for the single-threaded case,
where it is not necessary, will always be better than speeding up the
allocation (even though that a worthwhile effort itself, as Mathieu
pointed out).

> 2. unfortunately there is an increasing number of multi-threaded (and
> often short lived) processes (example: lld, the linker form the llvm
> project; more broadly plenty of things Rust where people think
> threading =3D=3D performance)

I don't agree with this argument, though.  Sure, there is an increasing
amount of multi-threaded applications, but this is not relevant.  The
relevant argument is the amount of single-threaded workloads. One
example are coreutils, which are spawned to death by scripts.  I did
take the care of testing the patchset with a full distro on my
day-to-day laptop and I wasn't surprised to see the vast majority of
forked tasks never fork a second thread.  The ones that do are most
often long-lived applications, where the cost of mm initialization is
way less relevant to the overall system performance.  Another example is
the fact real-world benchmarks, like kernbench, can be improved with
special-casing single-threads.

> The pragmatic way forward (as I see it anyway) is to fix up the
> multi-threaded thing and see if trying to special case for
> single-threaded case is justifiable afterwards.
>
> Given that the current patchset has to resort to atomics in certain
> cases, there is some error-pronnes and runtime overhead associated
> with it going beyond merely checking if the process is
> single-threaded, which puts an additional question mark on it.

I don't get why atomics would make it error-prone.  But, regarding the
runtime overhead, please note the main point of this approach is that
the hot path can be handled with a simple non-atomic variable write in
the task context, and not the atomic operation. The later is only used
for infrequent case where the counter is touched by an external task
such as OOM, khugepaged, etc.

>
> Now to business:

--=20
Gabriel Krisman Bertazi

