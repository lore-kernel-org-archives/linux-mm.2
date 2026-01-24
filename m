Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E9BFD778B1
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 01:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92276B0575; Fri, 23 Jan 2026 20:21:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F986B0576; Fri, 23 Jan 2026 20:21:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80356B0577; Fri, 23 Jan 2026 20:21:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A93976B0575
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 20:21:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72D771601A4
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 01:21:46 +0000 (UTC)
X-FDA: 84365105412.30.8F2358E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8A5D8180009
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 01:21:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=igSrjhCO;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769217704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dpCxV+RRWIvlr5NP30NBERy12MavEkaOfOLkpLkKCVw=;
	b=pIKI4R0gjd4nHBpGlRwK04yX+JVhieHvGteNBSR+itmEbbGBj17b0Ss0rMupQlW6anQR2x
	DmXGHVCePwtM01tJ74BFGddn3ug8VkFHXoSLBQKGkiB7KAx5OEi6Tp2BmS8KcHmWO9QrgT
	Y00/egvq3T0phcCFRVndv5pwq2YcHnw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=igSrjhCO;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769217704; a=rsa-sha256;
	cv=none;
	b=Txx/DBqrgfSi0ATQsnGn6BvGowH9dNSZI/9GbWTAlwSRZMq7U3bE0SZd6Hrf+gTmpEiAlX
	n9gOCMzcYfVFym82JfDdVgh5mX+eiI9Z60M9gCJoGNmdsxh00FSsw1bXsGnExNvJmAK0PG
	AnIAkX7GGmZAk4KYISF6GnfL1QHRBhk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A2B543E3B;
	Sat, 24 Jan 2026 01:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7907C4CEF1;
	Sat, 24 Jan 2026 01:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769217703;
	bh=00WbMUzAQnN9I1jPeJC3yMlN67r8CEu8MJSgu37GGo4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=igSrjhCOt1C3ikvNK04MoxSamznh/YF7Ie010d2C03CG6lgk8Q05RVTMEPRA0Oov9
	 clbV9O2XJiVuyt9Qpe6/2+s2l4ZDh2O8ynNGcdTbtIe1pIC6oFpIye1Nh29O874DGZ
	 8kW5qmzywKEvjm4Qk2Qp0f3UhmGueNRJ2re/7UEU=
Date: Fri, 23 Jan 2026 17:21:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Dev Jain <dev.jain@arm.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>, Anshuman Khandual
 <anshuman.khandual@arm.com>
Subject: Re: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control
 static
Message-Id: <20260123172142.4bcdee865bc768d5c70b6a50@linux-foundation.org>
In-Reply-To: <ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com>
References: <20260118192253.9263-4-shivankg@amd.com>
	<20260118192253.9263-14-shivankg@amd.com>
	<6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com>
	<afc56f8f-0c22-4bac-a99b-b46df346334d@arm.com>
	<ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: rkn5bbnreb6dbknkpxgwcegwwyenwk6i
X-Rspamd-Queue-Id: 8A5D8180009
X-Rspam-User: 
X-HE-Tag: 1769217704-66838
X-HE-Meta: U2FsdGVkX19DB7Mqzpraa7jtQ9SothXfU1uqIznEJpxn3/VP2BO6Y8dnCJbCgazV3innOJtN/zCKDjlXo/y4/264CcKWCqIASxGXIAHjnmGuOnQBjepiC6kbG84LnLChwd+/zcDVfnJpZb3bMKjmrPNShQPXmByLVTicBNdzHyCfcUNF7jjeF6yRQO74gt090mNAKrlHVI9ZucMr2LPrcFQ8aHGJPpB6YVFpKV7Vxfii6Tj8xdlz8N4HOQ0afzz3m55mkEuyuvSwR0jFoKDWNfdEDfLJUwK6B5reT/IfpF47wNzuG0H3ddGnkojdXke9BvfRUPk6AMV7Bn4g4e+5tmwkXRiwCZzKZXu6cd27R6nqnv5qKQmXHZa7m75e6Z+mJsXS/ZcJevs+0kQWf8RaGqtH4tHbozxAS0nawRieKPCxrEUOmaWSyNrhuCjGUD9lCMtDJMnsxSyL64VbhR/ZSOXv5TQx9616bltEWz66QTJm84hBwkk7k091zlz0o3uXI3XiBOehMFoXUKT7dF7P/VjWSkHhRuig676qkbWrU4CqXfAfftUVeokfLdsAaPVmRGjVRn9zAqXVM2MrJ4cTeImG7h6o5MTVY5ZjuF9lVs9VSctC6ouKQSzvZkh3UlfCWGUeuYceAhp1wlS7s0sbg0bHgWKZAbU/HhKK4tvIFgUZMcE8jqGyzXLkfNwoBExwMBw7HNhzedpzCTEwc5NIinahKUSv9oZwsrF08P5yQ9jQdNzHo5nFp9zY4e5NG5xvgfFs084v6ILwxZjKijSb+sTBjGqGxx1H+PnoQL9LXwUXSeuSTlWenN5VmRzULfZGLH6qhKM8J78U7Mj/kFoWyW1mZTX5H6OMKfHaSrkqgSgOLlZmm3KOSxU2et8OAvbdOQH3OH+ZnQaN8fSzKfiBKqpisHMQhhbWBpabB2E1bAZCxMb/hirO/cXmSG+l5xyWuyHY3mXCqcf3Daedxfl
 lxMl7EAC
 anNC+xqgIRwauOxn4IIbvkivNqqXoAVmLDTgXVPkWgUtEh3aI7+XC9vXFI+pdT4XY6FHenJymgHefTPfUmqfaA9icmBD3wXLrUZBe5MyBq15WFUjGTMrHl7Vvr5AOmHmWoVqL+wIbMvo32DNTeRsAImtuh2rNRzhC8aA26upc/O8RovPrWvhgxSKOeWiXXla91P8shuVtvLmT/O2AJU4jw7MrEipkGx1mjFWRjzQAUG5bp/f4U7hMOyU1sxZDON4+mVKnXuiD0O/iFRBXuLfPb1avqLbMBPLIOs72hSi1dE2NVN1ftjaGee5ogB+V+j2hwVVESG0sW3oIuVTNCRLgOXR3KMKPDkeALbeIsEalj325iq5tqU3OJ4wIruuIGl0HS8jTEd2v9j7TtPAQeMdpez4sowK4hdkL9VHUBL9eyBDknV20PhW7j7/M9IRbbYH13+n33n1zTraCK0ReM4LzK+vr9iRvqnwpmbXZ/fnJQaSnkJJl4OcbaZxlNf0aJJvP5GVaRdp51sSNUXTF8VMOij/C0CqzU6kA/hZMVWH6vhA5to1k9oLIMq2jjpgojGm45bWsppvryUcenwyhGpo37c0PCpGUAXmxBQ6jIfmnrI812d+jGgFkwrdnAi2Oo9yA0iD5/lIEG1GvAt6nfSo8ozkJWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 23 Jan 2026 15:03:58 +0530 "Garg, Shivank" <shivankg@amd.com> wrote:

> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -829,10 +829,6 @@ static void khugepaged_alloc_sleep(void)
>  	remove_wait_queue(&khugepaged_wait, &wait);
>  }
>  
> -static struct collapse_control khugepaged_collapse_control = {
> -	.is_khugepaged = true,
> -};
> -
>  static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
>  {
>  	int i;
> @@ -2629,13 +2625,16 @@ static void khugepaged_wait_work(void)
>  
>  static int khugepaged(void *none)
>  {
> +	struct collapse_control cc = {
> +		.is_khugepaged = true,
> +	};
>  	struct mm_slot *slot;
>  
>  	set_freezable();
>  	set_user_nice(current, MAX_NICE);
>  
>  	while (!kthread_should_stop()) {
> -		khugepaged_do_scan(&khugepaged_collapse_control);
> +		khugepaged_do_scan(&cc);
>  		khugepaged_wait_work();
>  	}
>  

lol, OK, I droppped $Subject and did this:

From: "Garg, Shivank" <shivankg@amd.com>
Subject: mm/khugepaged: make khugepaged_collapse_control a local
Date: Fri, 23 Jan 2026 15:03:58 +0530

Make this collapse_control instance local to the only function which uses
it.

Link: https://lkml.kernel.org/r/ba4502f7-0c35-460e-a42c-d32dea9ab9eb@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-make-khugepaged_collapse_control-a-local
+++ a/mm/khugepaged.c
@@ -827,10 +827,6 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
-	.is_khugepaged = true,
-};
-
 static bool hpage_collapse_scan_abort(int nid, struct collapse_control *cc)
 {
 	int i;
@@ -2618,13 +2614,16 @@ static void khugepaged_wait_work(void)
 
 static int khugepaged(void *none)
 {
+	struct collapse_control cc = {
+		.is_khugepaged = true,
+	};
 	struct mm_slot *slot;
 
 	set_freezable();
 	set_user_nice(current, MAX_NICE);
 
 	while (!kthread_should_stop()) {
-		khugepaged_do_scan(&khugepaged_collapse_control);
+		khugepaged_do_scan(&cc);
 		khugepaged_wait_work();
 	}
 
_


