Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A773C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626176B009B; Thu,  6 Aug 2026 15:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D72A6B00A5; Thu,  6 Aug 2026 15:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED556B00A6; Thu,  6 Aug 2026 15:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F13E6B009B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:27:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DC5EC01E5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:27:17 +0000 (UTC)
X-FDA: 85071828114.28.3F9F504
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D6A6040004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:27:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BHfeaGOe;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786044435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/FakDfQK+vOcHqnEJilwJjIVartku7nBkuKc4bqJazc=;
	b=wo8w2MbnhCdtQEg+j8N3T1jk1b1cUhtxKsHvmJVQhrQdRp1IgWkbLyLpYMcRZmRsehLIJe
	7tk5dE7RZNYKmOIs8J3oBgEqEPGlxZA84femX5BgmQfo//67/rjC6MEc0Gdz38veAgVxF+
	odFbKFIFPXDvjb02lUw7TnJ7uGtT59o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BHfeaGOe;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786044435;
	b=2VfqT86saB6Ap/8osdXVO3phpeK78+yYJcfOcICl6Sbd9hP6q9PI8/y9KAgXoRLo0VhUdx
	GCz08fg8bHU7QiQyWw6Vr3D2gsUeWbpHypmVAmPnuAx7QvUYPcRaLxtBI4SD9o5Pm/TYka
	FNoHDegEZGiPKdH9V5cyQddv/jdFNTI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46220600AF;
	Thu,  6 Aug 2026 19:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5BD1F000E9;
	Thu,  6 Aug 2026 19:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786044435;
	bh=/FakDfQK+vOcHqnEJilwJjIVartku7nBkuKc4bqJazc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BHfeaGOeTqu6EldjOfoUEzbZY9uMseNTWlSLVnUsKF+OlK2TOACWNcwNjxSK1IxlN
	 VROpOTuNT6UFbIMpB0T39OueCrFyS4iR4623kR+lPHzCO6QclwpD8YXoy6+mWoOCHc
	 n5Z4UZx4oHmS3zjxMevmRYc0wnwRDr0Ap5oXO8jM=
Date: Thu, 6 Aug 2026 12:27:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Audra Mitchell <audra@redhat.com>
Cc: david@kernel.org, jocolema@redhat.com, raquini@redhat.com, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <shuah@kernel.org>, Muhammad Usama Anjum <usama.anjum@arm.com>, Andrei
 Vagin <avagin@google.com>, Colin Ian King <colin.i.king@gmail.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Correct __pagemap_scan_get_categories return value
Message-Id: <20260806122714.08ef839853939a22de815db9@linux-foundation.org>
In-Reply-To: <20260806181843.1839943-2-audra@redhat.com>
References: <7d6b4401-e230-4ca7-b64f-c1277fa643b8@kernel.org>
	<20260806181843.1839943-1-audra@redhat.com>
	<20260806181843.1839943-2-audra@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6A6040004
X-Stat-Signature: zu9tay1hyuyttj8bzqo5kohwujmucfqz
X-HE-Tag: 1786044435-769603
X-HE-Meta: U2FsdGVkX1+tEIwk2XGg99PZyzWBpCdlkbnogdYsjbpIPw1tMW81ERBBU7aXtgV+GKAfWHi/leuGKqE9SmlXVfO9x5DvDwqP2TlDgvKXNxrZ8Bomo7LFJaZSSqmukOaz3kaYUY1IN3yvm3P6YfqQbVWQ/O1OoRiSi8/8T8H+CdjamfjQhAJICKqMTBzuW6GkSBqekrrRJ5DZze7JnPTtFUUIaoJB5Gcf9qFPLrSknRghMzHBIfTLK1x/qRocZVTfz3JiVDI6aMw3tOSvK/9J34nNH2o9RsyFJsOiFv7qJV5AyiWD3DovF5l23PxfBnuaOuEiv1y6n8cSxqqut2LS47BNWkSGDPOcZ+UPFfAxEKRWFUpxkq4BaIfFLUq9JaBOgibZlNpxbcLRmoD/W3YsTBLAX+XMIDCQjPtg2PEzoKvWbWeDgFwsU+O5ykY9QnJLQxE/L7kZ4HUcyh+JlTXoJOQcwhr6q2bSeRHAk+IegZ+DQX/WyOxmx57c2q+x0d98MhiQFePP6WNeSzLyuTD3ZqiYJOcO1Ie7weiwe1Fot5W25jIBDsi3zBDlC5WWmNoj+/h8lQz182yCnrMs2iO1tFG+qiEeBrkvCMwQWeY2qcdBoOx1rDDg54+yMaz4Lbl+dzOv/H4eWldH5CbJet7MFoTNRayv+NWdei4ozh0H9T4GmpEc+RDd0pusJ1Lw3WIP/6FcAAOLZKt7SIglwtXMDTaDUQktm5dKGt9O6EdcCfXLu3I9pjftLKQgXKgAtqyVxRPARF1HksXYEid6ebblR8HTOkqP3VohkqVVogHX3cafx3TxVNR0zJmOQEZTg3HFr53BrepWXvoUEnkG37S0nuD0WjuhkwIlgN+Meih3DkzXaq0mtTfTTwyhkJC/q2QQSKkFVXeXKPchloF+Hk21cbtOPVNTDsJD0lGv25v2/Ixjl4U2lRq4qkwK/33qGoZYpyUq5WaE+QuUPWu7JeF
 9nbwSn1c
 c2tptqy+cYricvwVWs1ISpeXH9eJy++SgSe6KZahSzw1FKn6DsUm40hi4fkLR1nDltGA2EGHYOuLI0twi9MWiwUzyroywm5Qe+sopUDCqrBgqf1Naq+vq/ZDzmVXsIP8DJqsFqkp9b3HRWN8Uzz1YCx4YOP8A05HmkHRCdkdHe5gwQh93kZPkDWLD0CjvVCh8/w1fK2D/Wn5oLSbNzljRx0nc1neb7XzAvK/BR9yO9Tkiof5xmJa2gn2uw0/cBZF+FK6MfM7/db2LstBnJe+mbbm0qzrFKXxGmVtT873d17CMoKWFQocF6EKr1NaOKOwDoP95klFBApuy+zIz+Vx5jbIjUnB7D5JGun8PFs7/tmrdS+NRNZJ1FaVc/HRo50IeDmVFQImUKHrEzvhVCKvlLW3Eod8aEhJniSCUHuMwYEwvfw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Aug 2026 14:17:03 -0400 Audra Mitchell <audra@redhat.com> wrote:

> Currently __pagemap_scan_get_categories returns the result from the
> ioctl call which should be an int, not uint64_t. The ioctl may
> return -1 on error, which will be interpreted as UINT64_MAX. Adjust
> the return type to use the correct value.

I don't know why these were resent.

It's conventional (and useful) to include a [0/N] cover letter when
more than a single patch is being sent.  That's the place to tell us
why a new version has been sent.

And please see how people are tracking versioning infomation in the
email subjects.

And it's nice to prepare a Subject: which identifies what part of the
kernel is being altered.  I think the main audience here is those who
are scanning subjects wondering "am I interested in this".

So to sum up, a good title for this patch would have been

Subject: [PATCH v1 1/2] selftests/mm: correct __pagemap_scan_get_categories return value



