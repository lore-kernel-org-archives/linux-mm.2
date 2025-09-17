Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D796CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 00:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77E68E000B; Tue, 16 Sep 2025 20:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F698E0001; Tue, 16 Sep 2025 20:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964D98E000B; Tue, 16 Sep 2025 20:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 855EA8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:56:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24B231DC7B5
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:56:44 +0000 (UTC)
X-FDA: 83896927128.26.2082673
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4DFA91C0006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 00:56:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OVmESGHI;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758070602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFqlaPgMmBbBuFNM60YiZSQk7+741HZaf3B4eRGE/6M=;
	b=q2rZDJvN5prvby3Re+OFmzlePaIHt/Iv3euFzh1hx/a8yTkd4ovgpxx5n4IVyKinHeaDiC
	N9WIJmwl0nRzGk/CQ5GJxF3/LPw+53gm3Y4imhr/4XP9yioRqQebfcieEzjbJdgvr/ReNB
	FHtL2ROskQwrbFFKGTp4JKxssAfSsZo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OVmESGHI;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758070602; a=rsa-sha256;
	cv=none;
	b=clp4K6W5xdGFGKXCHitopYFygwZaBKw8/EbPjVNI1IkxXuGdWk/4YiTPZqSaMKnXtgLWYX
	MSvxV2IMkUNxJtUbVwlJ9p4UtSjSxguZ+sCm6DfT++afs1ZRuSA9YWqFroOtC5LoJVXq8k
	btD8JvcnPvJvih9uqmld6RUz4t8+tI4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9B85408F5;
	Wed, 17 Sep 2025 00:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19DAEC4CEEB;
	Wed, 17 Sep 2025 00:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758070600;
	bh=kN+NGCVBMUoWfbiflAXY+vstv5YMeUL20qWoyAdAJDQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OVmESGHIIFGkkDubiKZqf7FYfPatb/hvLIU9LdRirkf41miv4FzHSnGOra9NqM0+L
	 Gxbh8ztusglpGX8N3oGu87lUBFyWDFQVOBaW14lhJZki8VnxG+f0HpJRC2uFEHu3SV
	 hmNEq84s6lErCVuE0Ih2XI963DoP3n0vuIJUzzfU=
Date: Tue, 16 Sep 2025 17:56:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, kent.overstreet@linux.dev,
 vbabka@suse.cz, hannes@cmpxchg.org, rientjes@google.com,
 roman.gushchin@linux.dev, harry.yoo@oracle.com, shakeel.butt@linux.dev,
 00107082@163.com, pyyjason@gmail.com, pasha.tatashin@soleen.com,
 souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] fixup: alloc_tag: mark inaccurate allocation
 counters in /proc/allocinfo output
Message-Id: <20250916175639.2368772636d5e543faa5b13b@linux-foundation.org>
In-Reply-To: <4c4e97c1-7f93-4c09-a235-ab169a998ef0@gmail.com>
References: <20250916160110.266190-1-surenb@google.com>
	<4c4e97c1-7f93-4c09-a235-ab169a998ef0@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4DFA91C0006
X-Rspamd-Server: rspam05
X-Stat-Signature: 6qiafau5fmnadnwxofnptx6rzopqqiuy
X-Rspam-User: 
X-HE-Tag: 1758070602-512965
X-HE-Meta: U2FsdGVkX18UVEpsWZO/hyYiyWIkUOYIoej9bGMEYOA5gP2pVSClyi6bgo2Oq3Zd8yyas0Mzf8Gu1LdcxVq09tHQWJBHbi2S/TfbdwFJMAIsRbTXZ0q0Bj/gvEfB+wdyy92BWCbpYZl9ynI+tOVNGaWY1XSrJbRcrLb8Dcwg4BF0J7I5CXlIUHWH3O72uXdW/jzpmKG9fyxsH1kK7sU+U6Gl9x18b/f1KT8WV8ixOFSjTllIjooYCN1e9ZRgf+4lPSzQcGAu3waymi+M3+ihkDFr3dR5KW4Ykz3WgF59xajK2nuhKdxt7JJhsIQeeoQ7k6jdnYH+oCMBi9lbpHuYteM0tALET8S8+BpXJH8r3mCn+Q01ckOISGc+1lxJlAEG/eqfNYgNuUB3bkwf7AfjIN9wsSEU8MTehAJMDvTGpNt1Un66O7hpZ2IUhaalvu2/T5v4q/Rv9Zhd+oSG+V+0DeO/+HTsn0t1zX6TVk77lwJ4zsFf9UpKogdZOVEWKKNT8b8WJT8pTD1957y0OhPPzV47KgFheWfJkSGojWzvbOfoxGXZb6Uyb8m8g5MtdF0V0Bs8bzrYtdO3tHvT2kD4jQSMxXVFLxnkvRs+0Mh471zoK7f1Nk7XMviteADSM52RAgsdwNhvQXF+UIGx9wHrWrF1IzGGHWypDX3mPmav+szowd1Eew1ljCErM58V7TQmCWHVg9xUv1R4J4VPNVjxqjbDIqHr3h/sOKEkHOjIH42hTTvWCNJu0SUNFgdsZWNm9FKeHdsNM5rIaEk6JDR9BKRHh/CoWbmrK7k8sUEk9nRIuz5KGo21hnI4rxI32V4CYjxFTo0ClbutsSDfz+slwMYXQ93aAWOvkbAxpTHSf0CgKSMgDQTo70xQedH4hp+fwVNi6gbmrlG46A3fHMLwZESih8a6c7Y7zel2nJI0UmO5SE0uleXyQdFn2maOdh2xuZj5fMjV69XxIRWLKw4
 v1IH/L8Z
 oHlhsct6QW/9VuH334bBQ0rsDP5rIxgGbu8YBbg5SDa/J6cigPUTpmP1Yv9Ponq0qVFzTN63CyJc2ee0ByosiFlQh5ZWrk9+VuaqGZCmkV4fNdA5pCDdMIb9Uo3OC3V29lC2ZWp3ZSZSA+lPZpXYfpNtULQ+ahIF61Cb81aR0w9cA63wRGGlWWTA9RHIYGTTiCrjhsPjUydFXr3n1FMQTl78akw01pJTtXL38JYg6Fx475duF+867vo9Bz7hhgq+ajge01edY7bDVQF9slbxe8GuGjO947jQsBX9EwuErF9CvNgTCoBk8dQ0tYetMQEILdSUpBQwqphj72N2FtDzLABeLdk1XYfG2xSJpCcnAaiMDnii87ZH1WYW6YCnuvYdApLJjnhMHQtEBDF9ooPjlrdmHR/+ILMEyb+21Y8y5Q8XnqDwjD0Y6odX5YQCu/ZcYR39bLSf/0x2oq0h8joUuesaIcz5o/jcElBnFbfw/2FTiNFgIC4ZMpWSsUUD/HNb0YbRduu68SiINackAt2QWHI2azWCuMo8Pz4UDaKC09hfmtX4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025 21:50:51 +0100 Usama Arif <usamaarif642@gmail.com> wrote:

> 
> 
> On 16/09/2025 17:01, Suren Baghdasaryan wrote:
> > Document new "accurate:no" marker.
> > 
> > Fixes: 39d117e04d15 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")
> > Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> > Based on mm-new
> > 
> >  Documentation/filesystems/proc.rst | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > index 1776a06571c2..17668f82ff1c 100644
> > --- a/Documentation/filesystems/proc.rst
> > +++ b/Documentation/filesystems/proc.rst
> > @@ -1014,6 +1014,14 @@ If file version is 2.0 or higher then each line may contain additional
> >  For example if the counters are not accurate, the line will be appended with
> >  "accurate:no" pair.
> >  
> > +Supported markers in v2:
> > +accurate:no
> > +              Absolute values of the counters in this line are not
> 
> s/values/value/ maybe? :)

That's OK as-is.

> +              accurate because of the failure to allocate storage required
> 
> s/storage required/memory/

Sure.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix
Date: Tue Sep 16 05:53:33 PM PDT 2025

simplification per Usama, reflow text

Cc: David Rientjes <rientjes@google.com>
Cc: David Wang <00107082@163.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/Documentation/filesystems/proc.rst~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix
+++ a/Documentation/filesystems/proc.rst
@@ -1016,11 +1016,11 @@ For example if the counters are not accu
 
 Supported markers in v2:
 accurate:no
-              Absolute values of the counters in this line are not
-              accurate because of the failure to allocate storage required
-              to track some of the allocations made at this location.
-              Deltas in these counters are accurate, therefore counters
-              can be used to track allocation size and count changes.
+              Absolute values of the counters in this line are not accurate
+              because of the failure to allocate memory to track some of the
+              allocations made at this location.  Deltas in these counters are
+              accurate, therefore counters can be used to track allocation size
+              and count changes.
 
 Example output.
 
_


