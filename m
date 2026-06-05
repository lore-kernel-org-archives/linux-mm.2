Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C01CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAEDC6B00A4; Fri,  5 Jun 2026 12:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D865C6B00A5; Fri,  5 Jun 2026 12:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9CBB6B00A7; Fri,  5 Jun 2026 12:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD9C96B00A4
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:30:36 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D8928C7AD
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:30:36 +0000 (UTC)
X-FDA: 84846397272.17.AB0A768
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 242631C000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:30:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dKaFqsfr;
	spf=pass (imf21.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780677034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2WV80dwMeo/Oh+o/H20bt+QiS4rQvxiM6pL+lxNyrA4=;
	b=vdTDbgeHVqDlGiyBid6b+b6MAe6Po2D+A3lKZEugaFe/KyzKXmSAag3/kLV1hQP1mPjflg
	6K4705igH4lkUVPWYO7RcnqivJaSBPfVKJ2S+L3HPFObZ07FlG/4UHPRryoP1iMLwN1+sm
	ejgBNANNhN8sjgwGH4HaT/oCPpMr2Ys=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780677034;
	b=MnCUn+cXcBAHFEhOID5cxmBB3KY+LAfx1wD2VvHPY/x55EWunGDcIDFZ2DNsh/nwJtYuRX
	aK5xcWcQr1bFV/lVO+ZPIYW5G2m3VzcUeRxxsOvn652RDO8y+jv1M6p7HaCOaSkV73FJ3W
	RG7amdgEISzuRVV7H3x3/EBjnnWnHH8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=dKaFqsfr;
	spf=pass (imf21.hostedemail.com: domain of fweimer@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780677033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2WV80dwMeo/Oh+o/H20bt+QiS4rQvxiM6pL+lxNyrA4=;
	b=dKaFqsfr4DIvRIJD4RQz+iNfeUL5NtIy9qS9rK/r305axILaWiFdzM1PI1t4/+k8/bZhPU
	Cl0m4MTAaaFt+Ns2XU1QbC/npniEuYwh9qEIOWuzLJZM7dj+a0DFRCRa2d+5JactEe2mQ1
	mSIgKDT8PrMgq3lmp8TWFkH8rCBLJ5A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-384-g4IP06-0Mb-aHZMfCcNRyw-1; Fri,
 05 Jun 2026 12:30:30 -0400
X-MC-Unique: g4IP06-0Mb-aHZMfCcNRyw-1
X-Mimecast-MFC-AGG-ID: g4IP06-0Mb-aHZMfCcNRyw_1780677025
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7DA421800370;
	Fri,  5 Jun 2026 16:30:24 +0000 (UTC)
Received: from oldenburg3.str.redhat.com (unknown [10.44.50.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEEB01800351;
	Fri,  5 Jun 2026 16:30:18 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Laight <david.laight.linux@gmail.com>,  Askar Safin
 <safinaskar@gmail.com>,  metze@samba.org,  akpm@linux-foundation.org,
  axboe@kernel.dk,  brauner@kernel.org,  david@kernel.org,
  dhowells@redhat.com,  hch@infradead.org,  jack@suse.cz,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  miklos@szeredi.hu,
  netdev@vger.kernel.org,  patches@lists.linux.dev,  pfalcato@suse.de,
  viro@zeniv.linux.org.uk,  willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
In-Reply-To: <CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
	(Linus Torvalds's message of "Fri, 5 Jun 2026 08:54:07 -0700")
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
	<20260604100609.6b37f500@pumpkin>
	<CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
	<20260604183829.63c35fd9@pumpkin>
	<CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
	<20260604223216.73468830@pumpkin>
	<CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
	<87se71jps4.fsf@oldenburg.str.redhat.com>
	<CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
Date: Fri, 05 Jun 2026 18:30:16 +0200
Message-ID: <87wlwdhrvr.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: zQ3_1OT3ixv1zDmgYV0PXcDnYB1-_CgSYSlnhuDl5mw_1780677025
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspamd-Queue-Id: 242631C000A
X-Rspam-User: 
X-Stat-Signature: yrhf65tis1cqnzu5md4er6m3o6hfht3x
X-Rspamd-Server: rspam08
X-HE-Tag: 1780677033-231688
X-HE-Meta: U2FsdGVkX19GG+992SkU6K6uOvutQyWIhvCY0RfYfCOt7PVoI3PVSaoI37rbWe2ND5UDw+6XkD07nue3J3ugsoatOFSuC90KH/KKmeFj3oLVhl1Fijy7W8kl74LGLL11y3kBXF29sd0OQpqUR1Z34Zbawu56LR2p6KrfBSb0QcewuGxE2nSsPK6wVuTYjF281t8fuURavaU8mB4S6rG0nyYgs0gPdspOLOCmVPs61V0CsdQ8BvouSyDO6sNxNxVR5Fq6I8GAmopVulURDMaI6Q1qggcozpM1tdGeW28lUOoNss8cPtzhxClGMvUrGYCR8em3dk/PbGyZFZW53+CJq4uMgdTZIjcb9PR3KpEBAOMATjixkgjK1Tn2anQ44lkP16kBLme4xUBnC4EuWM+y4nlATfH1GEHjaKakDw6KbYebYtwSybxZiw3Eb/4c+M8BvVtY8eLpot81I/khv7nn3JNslF1Hr5NN/bfLvpw1wVs/OZ7MyTRefrEXLk2ROaWSJnOpy8vHXkr6YmSgvk5obuKVyFxVr+aoLddNSqTo+Zz+cwPpSXpJhTLme7t770l24PmAfBrQB+iHo956QLnNlohFRM0/UD0jg2L0GsZmL0H8apfjfOSFtnUh+54bSta+5HlLmPVpeIJqASy+sPinwxWrg1QV1a+cko8OfI+IFFFHlm9zr8zWy2x2csH9hm8UuDIsKaZLN/A/Ujhy7++ozVgrwO53eUBR+0EHbevzJ81h2s7klCZbBFxbTI9GgkG0i2uNsRI8RpLqDZlm2Ie0t3WSrQCzxcjFyasERrvoj9gKnmhKfLiepsNL2Ed+CeBZ5dgDjX9Mf6hlpErNuUkvbs66NnHEZdiryp2zXhRtt9oOLlQCmkGqQH32Cm9DRkVvaT4A5877H702hhsk26ySgciBgmBoX3T6TUOtzYasyF7KBeWlvc9N0aBbJ1w7RxazNeohxTfHYjYbwxvlo3r
 v8x+F/72
 tA1FbLCLTKlUTN1qMdXmabGB7m/TeUscMEcsi7Z5WRRXjkC4V6O8HmY/IkH3pMWV0li79C54/kTFeVAgLep9aLOiDrA3jDcqZvz+FncLT8VAV6avjXb4L3z0dCUjkxyZR68ZMfbSI7FxfSfRcXLQSYafGUp59QcLAScKSAdJFsvUCwft5y5SFo3CwhTNl7XBqUaxwj1PiygrlzJEBWHpFNwOBmGRV7YhzHlMh6pLXYKDI7mQavVcsKW2q2lihFdleI+mZX7eo02NxgkvSl4sA6QIlLCUrSTba/RgsSv0IvpT/kkJZ8XXIpHx31V+pATAmZ2NTsqS+Gg2wd4SAmNWpWFIDpRgPSb8XT/F8c2CQUNaS2QdRWmqvB8loLVoy0uScFxnV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Linus Torvalds:

> On Fri, 5 Jun 2026 at 02:33, Florian Weimer <fweimer@redhat.com> wrote:
>>
>> * Linus Torvalds:
>>
>> > x86 really doesn't *care*. If the caller zero-extends or leaves high
>> > bits set randomly, according to the x86 ABI that's perfectly fine: the
>> > callee will only care about the low 32 bits. So the high bits are
>> > simply not relevant for the ABI.
>>
>> Please note that Clang does not implement the x86-64 ABI and requires
>> zero extension.  We see increasing problems from that, now that we have
>> more C code calling Rust code.
>
> Uhhuh. But that is only specific to 'bool', right?

Also char and short.  This

extern int a[];
int
f (short i)
{
  return a[i];
}

gets turned into:

f:
	movslq	%edi, %rax
	movl	a(,%rax,4), %eax
	retq

This code assumes that the short value has been previously sign-extended
into %edi.

As I read the original psABI, this assumption was not valid, and the
extra bits were unspecified by omission.  And GCC tends to use shorter
instruction encodings without extension if that does not result in
partial register stalls.

> If it were to have the same issue that powerpc(*) had - that 'unsigned
> int' has to be passed to functions with well-defined high bits - that
> would be bad.

I would have to ask around.  It's hard to tell from experiments what the
expectations around int/unsigned arguments are.  Clang and LLVM treat
the upper bits from int/unsigned return values as undefined in some
cases.

> Anyway, for the kernel, this shouldn't be an issue simply because we
> typically avoid 'bool' in arguments or structures that are exposed to
> outside.

Right, but array indexing with u8/u16/s8/s16 function arguments is
impacted, too.

Thanks,
Florian


