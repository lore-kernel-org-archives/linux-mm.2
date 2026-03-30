Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E7901061B08
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 21:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90CF6B008C; Mon, 30 Mar 2026 17:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61886B0095; Mon, 30 Mar 2026 17:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99EB46B0096; Mon, 30 Mar 2026 17:22:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 86B766B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 17:22:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EF2DBA44E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:22:09 +0000 (UTC)
X-FDA: 84604002378.26.3C73EC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8260080010
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 21:22:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TlMRVBcn;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774905727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAdq/SJUiudTGO47+DxXCSmYP/+26WL5Y69NRg9+7M0=;
	b=VoHHFYIq+qd2wEMyzoS9c202mIGwUHecF/ctvNZClVwqq0PE3A3eHBcO7U2d2Es4njmGFr
	jAXEVePcnOpRy67p+FWS6KuOijkUJTliAd1qumNIibSspkUgQ9m8Ml8MX/oMu2AJt4AuS4
	Da4SKLahU6O9ZEsv29MbKYz1FHX/3jo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TlMRVBcn;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774905727; a=rsa-sha256;
	cv=none;
	b=0gbINQ+fk0jRXX731Qe+03WyppHX4F57YRBmauvf66VvhDylVuo7KqanR+2rMMf8P+uVQL
	ed2MXxLUg6WNho7vdjk5EN1BtAyJ0aM100Qxp84TCWub8siFqJZ2gmDVYMVRjMH7dVPW7l
	T7RtZiBq2Opl+GsXI/AhG1kHeoPqZ0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B76F16013C;
	Mon, 30 Mar 2026 21:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA31FC4CEF7;
	Mon, 30 Mar 2026 21:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774905726;
	bh=MEWRnboV2bNkwQiahJ5k+v6T4kmH5A38Tmwfekx5+Z8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TlMRVBcnpychpAEroWbQz7/sAYailQgoeMk8W8f0z1h/YGHYywR6Bt3lOAXDRsq0q
	 A0jJ/r6ZD23d96zmJTcG5wWHOjnAu4ikN297Kfk3Kc6loPxpro/ziWHHloQMnFbS/P
	 Y00IMW9Oh84qfrPXQfXH2tjBThYn173ju1hh6ZTo=
Date: Mon, 30 Mar 2026 14:22:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "# 5 . 19 . x" <stable@vger.kernel.org>, David
 Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lorenzo
 Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, Roman Gushchin
 <roman.gushchin@linux.dev>
Subject: Re: (sashiko status) [PATCH 0/2] Docs/admin-guide/mm/damon: warn
 commit_inputs vs other params race
Message-Id: <20260330142205.e7c7d7b47ec15a634f6eebf4@linux-foundation.org>
In-Reply-To: <20260329193226.59025-1-sj@kernel.org>
References: <2026032915-library-embolism-b48c@gregkh>
	<20260329193226.59025-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1753pua8yyfzcjh9pep8kfzbq7sgu8wq
X-Rspamd-Queue-Id: 8260080010
X-Rspamd-Server: rspam09
X-HE-Tag: 1774905727-675040
X-HE-Meta: U2FsdGVkX18TsuvnkQtJYX4+y25074v21YoZSf9fpnTU1MFAO3fUC3EaXgGjrPodZjqsYDxtXPRaS4+6/yAuXogUM61wQ4dj+BRuKsCQkBqHefJWMNhp6x1ZqNx3E0WGiMm5UpaLu3ighCRz5JbOeSWeI575xYvNQnWPdeiLvzD1CmWBKaMyyOecg+P7uCKfNPLi7N11kIJo1dvPNecAYJQKAU/mZ8WZyX/K/F8SEckta8ePEUo66M5kbodqMw/jI1HHaaA0xKa4mpsyKljNYFuG8Ym6wlS5+sxVDnNxZVhqSTKOsIAiMSiziD4FcTaVLf5Ag1M4sUYimNleBQ6yt3OaTQlKN2BjKthDnzeBc4k9FMwo9IjV0BryhmjPGvvzpu0tYVBPAT7HjCwkaepspsWIAREf7Uyecnj6Bj0nmnRduCBabcbZqEHmnymplJ8eNTG05zeHrLgOvXHKkwYtDF3dz8v6XZEWcaZb1gFtJJFpfLKo6IVQqQmHQm2W23Gn/O7OppxikQWVvXhLdSZGWa8ixcBqW7PLFXB6h1ECXBOfNybZUmTsmis+WjpdGB4AOrt1Dvj37kZNNoqXTxw42B3BuB3n0wCuh4cess4CMFbqWWZPU9hLW/JVAo1pf3Hns3cwl8ko/imKOKK89M5I5Nler3+GjljOKJ+f1SdoEboG10GPihe93hhL+NFAyxn/iWdnjPjjUuQjNrgeAIyYhNWpL+dI1qPFyYGEPv3HOYHvf+MWusLI66rqvCtyi7NUfn6dL03n4BVvfoOAoCsGtvrj3WDTMCPdRxZF2l+XrSbrkvAb+A9kHvfCbGaE2CUocM/uhuowZwQMiAulYkdq5Pq5CBXNYcqzmtLy6siwwmk2bSxosEnajMpZI5dLCC4iEvYkLfkhKCtVDy+NyxcotqJAs0jmRGiaqYSnjyj+E4y9Lw4Cj/TDKrrVBMvKmv8OSYZGiXec2MtPZBqXxEG
 FSXfnUcG
 FQp0jG17tYpTPr8mU6MR43HHQiA7AHr6P43JAohmLmLxCujgJKXkqt+TDYJtbLKj9JPOX19p+F/Dg+GEYwy/QO6wQM5D8m6k6Au94oKNCrl4b2Jn5vVVNbG060rblr03LfqyKm5snSc9Ma2MKDly1AjsXP+SCbUbfdkZdqr/vrRBol2uKinBEL/P0ja80KlCr3AZblHTC1vyQUTTZuANzQ0UB5ssYisaYP/DYjNc6OhWusdeUEsW/I1N7pOpUr0cxfi6eCaPGXce7GUM3+J0vNXAuogOrp3/BZE2CA/C6dQ+zAuG5O0svL0wHAJOv88vfPutSKs6Y4Orm1PhpaR8SLFVZwXAgMQKivfoq//1O/EKacLqlmiou3EAKJg37dP0ZbH+o1lDMAe7F2oU/wrR/COLpOYkrt3V9Xgh+bRpmts8W5YBgFr9EX5yG+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 12:32:26 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Sun, 29 Mar 2026 20:05:53 +0200 Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Sun, Mar 29, 2026 at 08:49:16AM -0700, SeongJae Park wrote:
> > > Forwarding sashiko.dev review status for this thread.
> > > 
> > > # review url: https://sashiko.dev/#/patchset/20260329153052.46657-1-sj@kernel.org
> > 
> > Why are you doing this?  If we want to see the review, can't we just go
> > and look at the tool itself?
> 
> We can.  But it is bit cumbersome to opening web browser and moving my focus to
> there.  Reading everything on the mailing tool is easier for some people like
> me.  Like some test bots send reports are replying to patches, or we sometimes
> forwarding bugzilla reports to mailing lists in a form of a plain text mail.
> 
> Secondly, I have to share my opinions about the reviews, as many times AI
> reviews need human's opinions.  There is no good way to do that on the web ui
> of the tool (sashiko) for now, and I think this mail based flow is the best.

I do agree with Greg that it's all a bit excessive.  Thanks for your
your diligence, but perhaps dial it back a bit?  It's OK - we're all
trying to figure out how best to utilize this tool.

I view Sashiko as primarily an author tool.  Sometimes I call it
checkpatch++.  In a better world, author would be able to sort out
Sashiko issues before ever sending out the patchset.  But in this
world, a public send is needed to obtain that review.

So what we're presently seeing is author development activity which is
unfortunately and inappropriately being conducted on a public list.

Personally, I pay only a little attention to author's Sashiko activity.
Just enough to see whether I should pay more attention.  If author
says "oops, let me redo" then fine, I'll await the next spin.  If
author says "that was all nonsense" then fine, time to take a closer
look.

