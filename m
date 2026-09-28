Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10AF7C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 13:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4526B0088; Mon, 28 Sep 2026 09:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1657D6B008A; Mon, 28 Sep 2026 09:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07A946B008C; Mon, 28 Sep 2026 09:00:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D26FD6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:00:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69CF3A01E5
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:00:07 +0000 (UTC)
X-FDA: 85263178854.23.F7CFBF7
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3125780006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:00:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790600404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0gy9tI2VUDyS5179bfLeapYH2Erx+K7a0aawD55gr34=;
	b=aF6z9MEkzmteSuXyqkHfleVjezrbbKoFCR8mcfP26Wo61R+5Z18ucsSoprRvP0HzOaqcDu
	/lrop4LkgFP+yKWbt5FchcRrCw5yHJV8N/OH5Xi/snAdADvLLpPa0Bgccb6oyJ0nZpwqNh
	4TS2FMWY458b07ooY2nqlP5mcqS0EMs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790600404;
	b=Cs1So9LbaTR6D5a97ovS1FX1maXcCMwIkTwhSPYa9uLOZsyvKzuXpba2TjfO7IvI+DR8Mz
	hiS3AKw0kyjjAroRtq/JR9Ax2boC5afEgkEemxMUSGBlG4QwJ1C+Li98O8O18eTOCb9c2Z
	uUVgdMkOH2Mlwtzj6LQ8qH6GL84uosw=
X-UUID: 7cf4be08bb3c11f19a56ed5b684f684d-20260928
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:55f35981-00d2-4575-b6c9-7b287aadb6f6,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:55f35981-00d2-4575-b6c9-7b287aadb6f6,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:c9b1ec987c3220615bbed103939654c3,BulkI
	D:260927180756KXK67MMP,BulkQuantity:2,SF:17|19|64|66|78|80|81|82|83|102|12
	7|841|865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil
	,Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7cf4be08bb3c11f19a56ed5b684f684d-20260928
X-User: lienze@kylinos.cn
Received: from [192.168.3.106] [(111.193.136.161)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 490693840; Mon, 28 Sep 2026 20:59:49 +0800
Message-ID: <b1774aea-aac7-4399-815e-19b830d883a9@kylinos.cn>
Date: Mon, 28 Sep 2026 20:59:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Enze Li <lienze@kylinos.cn>
Subject: Re: [RFC PATCH 0/4] rust: damon: a first small step, plus a Rust prcl
 sample
To: SJ Park <sj@kernel.org>
Cc: ojeda@kernel.org, boqun@kernel.org, gary@garyguo.net,
 bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org,
 aliceryhl@google.com, tmgross@umich.edu, dakr@kernel.org,
 daniel.almeida@collabora.com, tamird@kernel.org, acourbot@nvidia.com,
 work@onurozkan.dev, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, damon@lists.linux.dev, linux-mm@kvack.org,
 enze.li@gmx.com
References: <20260927100735.41931-1-sj@kernel.org>
Content-Language: en-US
In-Reply-To: <20260927100735.41931-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tp5m56y9t6n48t91h4gdae1hz5wwmafo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3125780006
X-HE-Tag: 1790600402-678620
X-HE-Meta: U2FsdGVkX18RlV7Q5SeEVTLIJZnEAIMhQjYcIuvZzjdouyr4W1j3r+ej5A5ow0u+XQjnTWMwnuoCA5V94pPVXkxFDRSSh716u7ZUK3+opkBmxEtJx9FQx6wWxuFcP01PUhxkWoT2t2Ir3TA4lR9h99hbkaAHXYOfNKkzjy3d6hcKGZzJ3gATIwJTEx08ped6bey7JNLhFOLzHnMAGSBz9JIS4eO1aCGZpEWGiEwJc/iVe9LfVJ+zq1P9/1i3JRW2wQ3b4S8DtW6sOo0yvzQTNIGzRqEcfg7yDlIN+Wx3oWUmoeKSvXl2Vo/Zq9CNBFCAU90UyASbjGPO8NbLlLSQqn2ofIGzYDMXhnb0WKlVRVrj/OUvb7POuMbsBUcwpC4TUw3LEZNyKK0j9XzEyW8sTeDfRbMFUoprjbt6BKKRzRatP/t1CrD/7FGpXlNWsReqkMIPy20ItIdYkOS7aCBMiG41rcpZjMqXtOeVP3TGOY8p3CRF9A2PgkG1WalHzFTu7xa66Ora1g+z7jqldXoRUqy+B2+rminDOzBCvIPV48UgLR5590wdng5k3Q5R1u6xsJROznyuuCPVpvJ07qS0/tt98Nc3AYIwso+1hoasf9hQq42EmZcm37boKqVQ3e98w8ydqzEZjUtsgj4hrM2R/KT86RS//WE/GRYM2YkmGuTBMJcmfrfied2NvB3Nt0v5wIWtnpINguSgeQXnw23CSpBQve8yBalr/dcy0+QRN3FHyI5wLjqyYfIeLyAp4roT00xqvRk2sTmqE0od8c/Pi5MJAN55a1Per1LkCi43LziZqojnSqoFN2ZdOuKXjk3lwbM7Ybh4+pYSq16IIiTYG6sVfZ1EgA5nMN4x5XHO87slrSooythhbRFjDPh6xvP+NX1xDqVzkF2RJLlL+g+0oYaw6xrRbu7BsYaN7GNbUzQsVgrCp+4iGoSRnnLqZ1rQYPkrATXxtnCwniNoMZI
 kbM/aTEh
 OWowgxHVp/IjjbQBXx4uGV9b1WAQAJrWE++fULoHrazJVut33gJrSmpc1Qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thank you for the detailed reply.  Comments inline below.

On 9/27/26 18:07, SJ Park wrote:
> Hi Enze,
> 
> On Sun, 27 Sep 2026 15:28:08 +0800 Enze Li <lienze@kylinos.cn> wrote:
> 
>> Hi SJ, hi all,
>>
>> Almost a year ago, right after a memory-leak fix discussion on this list, I
>> asked whether introducing Rust for some DAMON modules could be worth
>> exploring as a proactive measure.  SJ's answer was positive: he was open to
>> Rust adoption in DAMON, both in kernel and user space, and even mentioned
>> he had been wanting to write a Rust sample DAMON module himself since LPC,
>> but had not found the time yet [1].
>>
>> So, here is my attempt at making that start happen.  This RFC is
>> intentionally small: it adds just enough Rust support for DAMON to port the
>> proactive reclamation sample (prcl.c), and nothing more.
> 
> Thank you for this patch series!  Yes, I'm interested in Rust, though I didn't
> have sufficient time to dig in yet.  I'm planning to attend Rust for Linux
> training day [1] on next Sunday.
> 
> TLDR: I feel like we might need to wait or focus on module parameter support in
> Rust, ongoing DAMON extension works before adopting Rust in DAMON.  Also, I'd
> suggest starting with wsse, which is simpler.

Agreed, and after thinking it over I am fine with deferring the series.

For context, the original goal was never really the sample itself: what
I was hoping to start was a thin Rust compatibility layer for DAMON --
the damon.rs wrappers -- with prcl serving only as its first in-tree
user, to validate that the wrappers are usable so that others can build
their own DAMON-based modules on top of them.  It is therefore a bit
unfortunate that the first step ends up blocked partly by something
outside of DAMON, namely the lack of writable/sysfs-backed module
parameters in Rust.

That said, I understand the position and I do not think waiting is the
wrong outcome: the parameters have no committed timeline, and the DAMON
API reconstruction is actively changing the interfaces the wrappers
would sit on, so starting now with a debugfs-only interface we already
know we want to replace would just add churn to moving APIs.

> 
>>
>> The series has four patches:
>>
>>    1. Generate Rust bindings for include/linux/damon.h.
>>    2. Add thin safe wrappers in a new rust::kernel::damon module: contexts,
>>       targets, access patterns, quotas, watermarks, schemes, plus
>>       start/stop.  Everything FFI-related is confined to the wrappers, with
>>       the usual SAFETY comments; error codes are returned as kernel::Result.
>>    3. Add samples/damon/rust_prcl.rs, a Rust port of prcl.c.  It watches the
>>       virtual address space of a target process and pages out cold regions
>>       with the DAMOS_PAGEOUT action, same access-pattern filter as the C
>>       version.
> 
> I'd suggest starting from porting wsse, because it is simplest.  By scoping
> down to it, you could drop the wrappers for DAMOS.
> 
>>    4. Add a MAINTAINERS entry for the two new files.
>>
>> Two differences from the C sample are worth noting.
>>
>> First, the control interface.  The C prcl sample is driven through
>> runtime-writable module parameters (target_pid and enabled, the latter via
>> module_param_cb), neither of which Rust can express yet -- its module
>> parameters are load-time only and do not show up under /sys/module/, and
>> there is no general sysfs abstraction in mainline or the RfL rust-next
>> tree.  The debugfs abstraction, however, already provides the safe
>> read/write wrappers we need, so the Rust sample exposes the same two knobs
>> under /sys/kernel/debug/rust_prcl/.  This is a temporary detour, not a
>> design preference: the sample will be switched over to match the C
>> interface once Rust supports sysfs-backed module parameters.
> 
> Do we have a timeline for module parameters support in Rust?  I'd prefer to
> avoid use of debugfs and directly start with sysfs.

I am not aware of one.  rust-next still registers Rust module
parameters with perm 0 (load-time only).  I will keep an eye on the
rust-for-linux list; if anyone picks it up, I would appreciate being
Cc'd.

> 
>>
>> Second, the functional scope.  The C sample also repeatedly reports the
>> estimated working set size via a repeating damon_call() callback.  This
>> initial Rust version covers only the core monitoring/reclamation path
>> (context, target, PAGEOUT scheme, start/stop); wss reporting needs safe
>> wrappers for damon_call() and region iteration, which will come in a
>> follow-up series that also makes the Rust sample's output match the C
>> one's.
> 
> As I abovely mentioned, I'd prefer porting wsse first, and later extend to
> DAMOS-based samples like prcl and mtier.

Noted -- when this restarts, it will be the wsse-scoped version, without
the DAMOS wrappers, and the compatibility layer will grow around only
what that sample actually needs.

> 
>>
>> A quick word on the longer-term plan, so the design discussion here can
>> happen with the destination in mind:
>>
>>    - Over roughly the next year, I would like to port the other two DAMON
>>      samples (wsse and mtier) to Rust as well, and let the DAMON Rust
>>      compatibility layer grow together with them, wrapping only what real
>>      in-tree users need.
>>    - Once that layer has matured, I would be happy to try Rust for the
>>      production modules - damon/reclaim, damon/lru_sort and damon/stat.
>>      That is a much bigger step, of course, and it only happens if SJ is
>>      comfortable with it.  Consider it a willingness statement, not a
>>      promise.
> 
> I think that's a good plan.  However, I'd like to call out we will also need to
> make each step with good and sufficient discussions.  That is, for each step,
> we will discuss if the previous step change was helpful and therefore make
> sense to proceed to the next step.  If the conclusion is oppostie, we could
> even revert the previous changes.  It would be great if we could make it driven
> by data.
> 
>>
>> Regarding the MAINTAINERS patch: I listed myself for the new files, but did
>> not add SJ as a reviewer yet, since he mentioned limited bandwidth for Rust
>> work in that earlier discussion.  The existing DAMON entry already covers
>> samples/damon/, so the sample reaches him regardless; adding him to the
>> RUST [DAMON] entry would only additionally route future changes to
>> rust/kernel/damon.rs his way.  Happy to add the R: line if he wants it, or
>> leave it out if he prefers.
> 
> I think I should at least review the patches.  Also I feel I am responsible to
> the maintenance of the code.
> 
> We are extending DAMON to work for not only data access but general data
> attributes.  I'm also planning to refactor DAMON API quite a lot in near
> future.  Some interfaces will be added and removed.  DAMON API callers
> including sample modules would also need to be changed a lot.  If we make the
> Rust sample module with the current API, we may need to make changes not only
> in C but also Rust parts.  I concern if it can introduce more breakages that
> require unnecessarily long time to fix.  Among all, my lack of Rust
> understanding is a big concern.
> 
> I understand this patch series is a kind of experiment rather than for a real
> use case that has a hard deadline.  If I'm not incorrect, I feel like this
> might not be the best time to start the experiment.  Could we wait until
> fundamental parts including module parameters support in Rust and ongoing DAMON
> reconstruction, or my learning of Rust are done and stabilized?

Yes.  I will park the patches and restart once both are true:

1. Rust supports writable/sysfs-backed module parameters.
2. the DAMON API reconstruction has settled enough that wrappers can
   target the new interfaces directly.

Meanwhile I will keep working on DAMON in C as usual.

Enjoy the training day, and good luck with the Rust learning.

Thanks,
Enze

<...>

