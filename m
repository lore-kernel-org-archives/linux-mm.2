Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B0FCD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 14:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 709B86B0005; Fri, 15 May 2026 10:13:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA676B0088; Fri, 15 May 2026 10:13:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0696B008C; Fri, 15 May 2026 10:13:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5116B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 10:13:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD52486CE6
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:12:59 +0000 (UTC)
X-FDA: 84769845678.03.45C84B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3F2C180005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:12:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z8XzLjTV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778854378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L5DLw9MtmNxRMA/CKO2Cx4ZYsoSLnJm/D4rJh0SGZfk=;
	b=e8d2cwzoLNZ+HYgpYAZV0NFCrRIaMXq1+vNIwIU4JKULSCu9hxFdUGI9ikosYHneDiDPzb
	UqBWilFgJomVglwlb/Uefl/gPxP28bEf9hBY7TfsBJwzOcA9dm8mBZ88PDhWTF21thFPSL
	LmHl7kyxn6dEz8j91ksknLcUkdQ1w40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778854378; a=rsa-sha256;
	cv=none;
	b=fnlL9hTzKOVV43rJeMFI+Ia3NkafpqMgSZGKwZe1NEHMc+/lTzMZ4bx1vC46R1xB186L2b
	n8vXo5zWyC7R/xwb/VUCp1IMwKm5pCDK3240LzeuQGwA/047jCZb5JPMHRiLoqTRBh6BkD
	YBhpuFtSIfVk4veVY04jQg8ZI6lXqn8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z8XzLjTV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8946E6013B;
	Fri, 15 May 2026 14:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44A0C2BCF6;
	Fri, 15 May 2026 14:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778854377;
	bh=9UNiRIOMItKEXLdbm4ULxBk3vf+YjPTZzQWrvLl0NcM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z8XzLjTV5ekKX/GeDS/yLSmSwfJaxqT08w/d/U/NL0/fzuBuk2Wdtx00Mc8QRL6US
	 eClFl/yaJm+fwI06gCwoyOVI/91BHC8nvE+sxIBrDyt6+PxHZuLwW+BirBYqn65qtd
	 pp6pN1nMkktbVMSBZ9M+ggziCl7HyNUFYY1zBAzM1XyQTHAocml47qa/q0N+HB4/Zs
	 x+HmCrzPp1DMQCYTgjB1/yU5DQ4TIOKwZopvS/dnZNArU15mzlpsvIHvGUyhrsXXMb
	 cNscvKBY4M9j6Fj7sitMd4VePlGGpB1rf2vZVNbCiNey8UrfKjaJEizyrAL3upyuh+
	 Au2HKI2ZmiFOw==
Date: Fri, 15 May 2026 16:12:52 +0200
From: Christian Brauner <brauner@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>, akpm@linux-foundation.org, 
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, surenb@google.com, timmurray@google.com
Subject: Re: [PATCH v2] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <20260515-leitung-pyramide-13b63e9b621f@brauner>
References: <20260429211359.3829683-1-minchan@kernel.org>
 <afMnKrYT0xG_a-b3@tiehlicka>
 <afUYfpwWsUQoB9hz@google.com>
 <afhQB0CWEcflXpOi@tiehlicka>
 <20260505-wegbleiben-deshalb-f929089dbdab@brauner>
 <afoUt3te1k2TNao-@tiehlicka>
 <afowD31YsGVdVUBP@google.com>
 <agJN2esiIGIhUlMG@google.com>
 <agQeABD0W7wn4pCt@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <agQeABD0W7wn4pCt@tiehlicka>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3F2C180005
X-Stat-Signature: ekz8sdy653y9q3xw7h41yi88bqqdph5f
X-Rspam-User: 
X-HE-Tag: 1778854378-34205
X-HE-Meta: U2FsdGVkX1+bWsTBoF0DBrX+4Zem9Tm1KOe4ApJfQnEh5WdqrJ5IV2Kt/Q8j+DxsYdJNR0xCyX4csjRS3qwrjeKQdpR8dOcnGW7n7tgMF8xURl4PZPxnxeTMe/n+PMSuAGzNlYjk9w94Rtk9VG9DpDafKmnHHMpi4XNOxrJMBpYw2dNI57ttEHf9BsrNJH421+cNzrG6q+iB7TXtd+tCUSXbOXmTdJFsekyS8dyFcZiErebSeBdVdH4GjB/ap/rGskRNsRIWDXimk14DkA98yi5v7SIyK/cs0sI9Y5gmK66a8NT832AQfsbZEtNUx6vd6EqS95JPHr7lMAWG2JP6mQvmHnCv5gCflS9wwsG6yeIWKmj6OFMcmt7oLwI/jnJapcxOmLu341f/vIo5OLs9RRJVCnOsSzMIADgNA/5l6qgnhcdOIh3tp8vERl1vHbsIlH8+6irx05dG5klW2e6TJg//rzTEvRNbacsM24KNXJ0o+4W+sNylUcMutCL3tYmorbNBTkLL4iTyG0zv2rgOIgUphdgVIVgJLqPfPWrobhZyj9rpgWpGWBuBgYVXGzWBIyyVUNtGlfq8t2XWvo1g6ld9oUa0BVPE9f5C7ZZb2N5L0mhpqvwqsSgbu6kLVRsSlgKsBjTrLGYD2ns8wm5X/XcQqjvfU5g6/Nk+Z6bip1GW6SXEs98SpB1shhctubmhGAO2vkP8HKKkq3qLOBY9jm1hWnbQD1Tpxwo/lXYi5AI1gsHgybG8wDuZJe+CdhbgVolo2ajNIfV0O1uSxQn9V6/ZJ6F3zwb0YnxC66Q1RmP/qXsgh+f+5dNqC8VfVWJOcg5MfXO3nJ1jOez052ENzFkG0fua4yQx8wO1hLFKpltcoUE0PprEgqTzCjkBYc6QDp6dqIUZ6GihG7HKeXQpKQigCBykdd2dYwt/swdB9iRy4n2JkF77z+ir7saXMBnH+bY6Nd7CHQofqmGVI0I
 H5iO2cFz
 nEV3arMsFh5I4N924zfGRHmEKlYs5Pqx53RQ5AqdlVEECcqGtnk2GBczNetlMfqZq7V2ceL5zScOr5jOcpxv7NNhmTPYwoTBydRvITbiDck/mLzDVgRnTCzuxdkpv0fqjR1PzcyZXHpfUk2m6KTjYeV1uQ9RzefF4bIwBYTnV19vYdsog2aCWm4HyS6N7XxBYy5EXq8sAsQb03RkbNy9lozwexLi4lZwq/h2dwXkoPiF4/nQNvW04B2KwNa8lIuNi/0Cy/hflhUuORnupSAK+X+TqyzGUgzE3b2qkUoM74sunyT4FoEF5Cpx0c3ULOZia232xedtkkD/3+ZBlhFQhjdlfGRthX7JzLZnCnVuEMX4s/V1KjX3GIcM+Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 08:45:20AM +0200, Michal Hocko wrote:
> On Mon 11-05-26 14:44:57, Minchan Kim wrote:
> > Posted v3 - https://lore.kernel.org/linux-mm/20260511214226.937793-1-minchan@kernel.org/
> 
> Is there any reason to fragment the discussion into yet another email
> threat? I believe Christian is still catching up after LSFMMBPF last
> week so give him some time to have a look at this proposal before
> sending yet another version please.

Yeah, thanks. Frankly, it's very hard to follow what's going on in this
patch series. Let me see if I can find the latest posting.

