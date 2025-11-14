Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD8BCCEACCC
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 22:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6E288E000A; Fri, 14 Nov 2025 17:39:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F218E0005; Fri, 14 Nov 2025 17:39:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B348B8E000A; Fri, 14 Nov 2025 17:39:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A26DB8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:39:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 390181A03EF
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 22:39:13 +0000 (UTC)
X-FDA: 84110679786.07.FB44B19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 73A4120005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 22:39:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i8uaM4bq;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763159951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oOfjNAlO0nvilpPyayqmAIFebVDoMM6ym2Gp5aDA3rY=;
	b=ahTURL6V7vNIKUMW0B1LDyv27ZMyPAw2r0HVbRXBIXlLoW3W81JupPQAXDdKGo/G9S01ka
	OB5IjKcM7HgRk/F3/K0jgKBeBn+spCF9aaXIYIrOLWUzmdIDWINTDNfP1ltTCMGAlw70oY
	GqjOHn0a05lfnHgng3fXua5QqYEYEaA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763159951; a=rsa-sha256;
	cv=none;
	b=0tey+aVqi43eOrxWQGjnq18ej4PHhk6oeac0WQtvFVKrz5a/0xtor4Hov9F9c60dsH7zQK
	RMFEsRnoisb9ZWJ1/7Dptudq3lFgFMP44AeqprXOHIGsCEVAVRPpJHY3INzemlm0AluVSe
	1EuQBXZ3zItE0goE9uF1E9DZ2Go8YlI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i8uaM4bq;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 91FEA60192;
	Fri, 14 Nov 2025 22:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF69C4CEF5;
	Fri, 14 Nov 2025 22:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763159950;
	bh=MYESjMwsofYhqqquOVfZchs52Vx8aKwvtmP2Lmh5LHE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i8uaM4bqM/bAoszT1IjaRnvMQKaHJOAf2cjkjEQMgfdFGodOKmrvYIXQ72E7IljE2
	 wMLOmULdxSobtPEPSgdfYKeEuuC2Hw7V/uPUKlTFV0IvsQICMERyNtvFwZHby9fF+p
	 B/R2us7EVhMEVKTjjFgmroiAhM5yIjim9sXODTgc=
Date: Fri, 14 Nov 2025 14:39:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Carlos Llamas
 <cmllamas@google.com>, Peter Xu <peterx@redhat.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, Ujwal Kundur
 <ujwal.kundur@gmail.com>, Brendan Jackman <jackmanb@google.com>,
 kernel-team@android.com, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, "open list:MEMORY MANAGEMENT - USERFAULTFD"
 <linux-mm@kvack.org>, "open list:KERNEL SELFTEST FRAMEWORK"
 <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] selftests/mm: fix division-by-zero in uffd-unit-tests
Message-Id: <20251114143909.14ecee31b88f179bc2858e30@linux-foundation.org>
In-Reply-To: <9d30836b-9ddb-4432-aa39-85e32c2ea645@kernel.org>
References: <20251113034623.3127012-1-cmllamas@google.com>
	<e0be6864-4260-4843-a432-d47437b5d43f@kernel.org>
	<4a60a703-d9c2-46a8-83b4-a7ecff7f6ba2@lucifer.local>
	<aRXyxWeh81-aTHaC@google.com>
	<b4291d0d-b913-4e61-9f9d-fbebd1eb4720@lucifer.local>
	<20251113153205.6507ecb308e7d09362905da7@linux-foundation.org>
	<9d30836b-9ddb-4432-aa39-85e32c2ea645@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jbuqjxiotmjbh5xkom7xgw7rpzsmghzs
X-Rspam-User: 
X-Rspamd-Queue-Id: 73A4120005
X-Rspamd-Server: rspam01
X-HE-Tag: 1763159951-627398
X-HE-Meta: U2FsdGVkX19Ro6jNwfgl+IdJKYc5uBxdQuCfho0M6E30d+GnAOnQLbN1ynTcHkEwNAvTDYU4aAYlGFJ86BSST/2CRjrcKUaM2Px3inxc/8KQbUcVq3sQH4jYe2Jg7EK2Ws0PxdMVrYA1LeE45sZGAhX9j8Gge3amSGTn5ddKMYI6NC+RicAX27OzJmIwtXrQ1gax6wcc6eELnRSbzy5Kzctx4KlkWFeb/tvP0mcxo2kKRCR3L1yNtSYw1LySoqlj4TlaYXCohwxwfqvDw8Xi0DSNTJO+6Pm9HlRMLfOEru41LkpoQL1fpty1N9ly4fdnhQJ3vkw3yj9ZO1AkdSBJ3uXZZ5eAEmCL2ta8dbT0R5kno2uLK0kHpF26w2VuBtJACoNY0AVcWYUaK6mWrcFRPr83ABQOPbtu6ilc2dd89dIbosGjZkZa2k4FZFa7wypMBRPP48sJQMcABXPy8L3hAx6m/5tiSQ3v+VUAsCQojSkihc+LG0ZbfkV5z+S/DfEkjVxP0ehlACJ/LxEGTvRAugiHjhTGOZO5EH2HXM5lfMqfOIN2OZ/hErjcuwJoxDz0O4vkVy0V7V4EZg26WDXFmcffk0VfOzd1m9ETmJh424mLkqNVbAH7wuytDWKVzB49iaBrsivySj9ugl22Ni670ult0F1SxdSuGZmCa+TUQnyWi+ilSlaeRQDtdnqnTcZ/JEf2jc8xl+iB4ycL25pCNwkm1h6Ep8mtHNfsEmiz4X0RK+Nb0d7/Dw9UEl1pEEnrQvt+0EzqnqN5LMMB5hNN6mvssGfYHwRkKq+/a3fuwv+NiqpXt8JfcQIB9/t5sdX0bmBzTvsjltgwX1894/sPLP2KyvjvyiwGK7OMBh+lg1oZ6Txh8yfYzGFgomDRQmbuOwkweE9yAv0WDPKVbx6bpfje/gMpdmvh3tMox+5ntEqh3hz8HF7aDrWkKpbsu/PLgI9y1SAhk28DC6BpjZ4
 DIGtd5cU
 u7JMkMB53MkdxC/lOec7poYMUZEWXMlf9HHmb0RS406pHIMm+5beN6rQIt30k2HCzzuPqrui1r+wsXLbZhoUadmRH7ppPW6JZ0llOTfImlZjtiETXbVeam6O47WjUMLkvpcmFpcjBFxX0ur5gtEwf7rG/d7t8OR5GAYK5jBkNI2lJ8VDqfzaR+1IKkXXbWlYnGIKF9RywniTgeUM9CvHQTnEk2rYfEoZjlCHQf6bKFmX+nqkwYuRieriopdRNgr8CS9GoxYOesRGaw/BCaHAD4qEctm0Ex1onAxqLD+VftYqGhh6vYUKyBIN320bES+Fv2C5O353yMRG9P9VFc3vx3YDVnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Nov 2025 09:11:40 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> >>> Oops, I keep getting confused about this Cc stable thing. Please let me
> >>> know if a v2 dropping the tag is needed.
> >>
> >> No need, Andrew should spot the objection and drop the tag :)
> > 
> > I actually add cc:stable tags to selftests fixes!
> > 
> > Because why not.  Why leave people running known-to-be-buggy code when
> > our backporting processes are so well-functioning and lightweight?
> > 
> > I'm not getting the objection?
> 
> I thought we were so inconsistent on that that it ends up being a wasted 
> effort to even try taking care about stability of selfests in stable trees.

Oh,  I try to be vigilant about it.

hp2:/usr/src/mm> git log tools/testing/selftests/mm | grep stable@|wc
     44      89    1462

I pass selftests patches through the same brain algorithm as
I do everything else, shrug.

