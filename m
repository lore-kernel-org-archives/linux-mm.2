Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB6FFF4946
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 05:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C776B0092; Mon, 30 Mar 2026 01:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDBA6B0095; Mon, 30 Mar 2026 01:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED02C6B0096; Mon, 30 Mar 2026 01:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D905E6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:48:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 783C78C34E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:48:00 +0000 (UTC)
X-FDA: 84601648320.15.C068226
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id EFBE58000E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:47:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=s6CxoxH0;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774849679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P89ivFoRddOm1/L7DwzV63tbNNOcrWerngUhqcGSbgM=;
	b=qacI07cNi7QCJp1OoxA/THm+LbEK3xqQxlMGjes8E+GVqUh0Yu/SL9ZGdAOvHxO+MGAKiT
	CTvwCjCrzG9MhP6fCc9f1ny/2ny1hfJoe633rtCslJmzm9xg132LbVhpCxyKgjc+t4T/rr
	pfePA6rsbUZMmQBEJ0VvDIZ/bYoAUsc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=s6CxoxH0;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774849679; a=rsa-sha256;
	cv=none;
	b=IaZ28wgZKc5nZCoLGotvOw9mi0m7Ich4ANE5xTDo5vlKoEVZ5SN8TOf4paqJ1EESNDLuMH
	OPLucOq/D0sxhEU8+9usIRQd91xEvUeU21HxOCyHPNrwNP4FXqqOq2/EqoiQXfXAKqfj0J
	tYfiaLOwYFS5BRLXp6AwiBy3x8DUGcQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 521E360054;
	Mon, 30 Mar 2026 05:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F97C4CEF7;
	Mon, 30 Mar 2026 05:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774849678;
	bh=qyDqUEOyuGKVWNwH/c11TUyv3guz+h7W/2xYEx83qdg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s6CxoxH0HeeGjkoRHRYMsUCMx1bmeebfIP/QXjBDYhu3WBZcQ3seFDg7iH3ojeAsx
	 NwHNs5oe8IiLJHe8it1Exk6k4SJArLYUlsGy9Lap4JOq4U0kUr1qApjqCXRPo0fClg
	 /PzekReHjwvzt9G5P1YnFoF9TSvZqY3xrNKx1id0=
Date: Mon, 30 Mar 2026 07:47:54 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, damon@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: (sashiko status) [PATCH 0/2] Docs/admin-guide/mm/damon: warn
 commit_inputs vs other params race
Message-ID: <2026033013-drainage-stylized-43d6@gregkh>
References: <2026032915-library-embolism-b48c@gregkh>
 <20260329193226.59025-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329193226.59025-1-sj@kernel.org>
X-Rspam-User: 
X-Stat-Signature: xm7rrkmxrnnu3wm8djcbekcyaog5dbw5
X-Rspamd-Queue-Id: EFBE58000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1774849678-175779
X-HE-Meta: U2FsdGVkX19s+Qt8riydd/n3ycW2XLC0CK48JqR+RnExik9e38iVVonFz97PXMvorVnYix04EeP3rXGMG81PQKyGXw+IjD1G6IhdgGdxaBqLI7a4n4YT9TWBjrD7vdyINls3lT8HIuxMTChe8jcJl9XFyPRIjc07HD42MyyX6AZVGDB0WWTi243nNQvxYqOx8BZ6GlGnPD+orKVrkKeHmvnm020j6T1ZGerUo545RlNFqt0W9+u+p1vcRhQpMGp7pb1JO3oyec8yHiGwbEDKLV4zyuezsJrdRhN3OqS1Mh6HqglV4ak4A/NFNcfQq3mq0KyzHPkLyJ/wQsLcMQDvGOFDRTPEUUvYaxNepoFmcyKmU5RvqJpLCFdF7j+zpoyF+oJvk7diUdhMCFWgD6SsN+OQMmxoQVSiUcY+9AYP3uBraWoxCft2VW3d4mA775szRsNX9Kn03X+j7INJBAY/ypjP2opQ+Rpm9lKwk6jjvdgM2mhOqWOIONgUMWttmmH94ot5n1IVvYhp2S+IT7wj/VuL/zIljXqpsEt4B71V/3RZtHeRZdiydz+j+7EJ4CZuRfA0vGyhZzsfHvvz/swCFjN2T1HNGKQIgOwSbo1eWU5Qfxu1DsRRO5nZuxTC6xd+VRL1nc+GkQZ9nusc1MTsBezz9f2PvjZ8u1dDheOnui33dMDsxYnlLoxdrbY1yeyRux8yQg8j635g9VSNUgAfPdTDShGVUla6IJuEUtxMBUOQogdd04TzQaebWLmE6lZo1bN2IlN3pV8TCfZeQ9KlJy+7uX2GuL/6k9tgVVaTSLthVFEpCEzDyCza8ObjQQ13QQ3vs/rn4ZTACsc4RemPsvxvI+JakAp5ntQ/R458lsRdXEFIcm4HW3ljFRhjYhq0OLnFxLtN+/x6gtcWJesKmzvHsXcXeqWGwsN6wkJ18etyqZMqd5E9UqTB7NzsStezE+Z8dMvvC+lCShHqiIq
 p3pzDAfy
 vwTT2l8d2O6fQGJIm6EVakL+dtaMHhpKp630g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 29, 2026 at 12:32:26PM -0700, SeongJae Park wrote:
> + Roman for a case he has any opinion about my sashiko usage.
> 
> Hello Greg,
> 
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

Sure, but are you going to now forward all random tool reviews that are
run on your subsystem to all of these lists (your distribution cc: is
quite large here)?

> Secondly, I have to share my opinions about the reviews, as many times AI
> reviews need human's opinions.  There is no good way to do that on the web ui
> of the tool (sashiko) for now, and I think this mail based flow is the best.

That is assuming that you can fix up the AI reviews, is that happening
here?

> And anyway I'm supposed to share at least my review of AI reviews, in mm
> community.  If I ignore, I will only make Andrew have to reply asking that.
> 
> I used to share only my review of the AI reviews as replies, instead of
> forwarding AI reviews and then replies to those.  But it was
> 1. cumbersome for me (should summarize AI review and then my review; feeling
>    doing work twice), and
> 2. feeling not optimal at sharing all concerning comments with others.  My
>    summary might miss some points of AI review but other reviewers might just
>    believe me and don't read the full review due to the additional web browser
>    opening work.  Also some other reivewers might kindly review AI reviews
>    before I do, and save my (or their) time.
> 
> Hence I ended up to do this bit odd workflow:  Forwarding the full AI review on
> the mailing list first, then reply my responses.
> 
> > sending it back to all of us feels odd,
> 
> If this is polluting your inbox and/or distract you, I'm so sorry for that.
> Please let me know if this is distracting you.  Maybe I can filtering people
> who don't want this kind of replies out of the recipients for the forwarding
> mails.  Or, if you have a suggestion about what need to be changed, please let
> me know.

It just seemed odd, and might get crazy over time if this happens for
all random AI tools that happen to be popping up now, right?  If this is
the "official" one for -mm, that's fine, but consider the distribution
and intended audience a bit please.

thanks,

greg k-h

