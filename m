Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BBDDF3D605
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFF316B0095; Sun, 29 Mar 2026 11:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6C16B0096; Sun, 29 Mar 2026 11:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C142B6B0098; Sun, 29 Mar 2026 11:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AFC216B0095
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:55:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54D261AF5C7
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:55:22 +0000 (UTC)
X-FDA: 84599550084.29.5507782
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E7F244000E
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:55:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bS2RE7Qh;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774799720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZqVlHIkApbnTXreo3VQR7xXGonLtSjzTEbcCaNQkDg=;
	b=phuoyvqKjtBf/lrAzclaSqEmzVctPnP6Q7GkSdDo5NcKj96PUhL533ueuO3nbyavAgq+Cg
	s3vJnoZ5bV70lWIIfx5fzO2YPQNz2RxcAtlAaO6EpeWz/GESt3Dyys4v931Ezi6jjS5+Jz
	4zxko12SSqSOFtjnY5BSqK5CS7e5yE8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774799720; a=rsa-sha256;
	cv=none;
	b=yJ0xarM4qZZ1a9DdRkbEXJPZVsc88keEm7A0u5bS2MWBQXEQaca54nEtPxYaNM3hC4ePIs
	86H1KG8lDKu3CbXaxiHTOZXrQtoe4Mb6MxIb63G4hic10Se6Z2XCjAU3pZecNfdMWp4y3o
	odl2ztQW7jUzKHrwaKPPC8Nw11F8WJ4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bS2RE7Qh;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AC46600AC;
	Sun, 29 Mar 2026 15:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48ADC116C6;
	Sun, 29 Mar 2026 15:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774799720;
	bh=xRSBuwTmcffpDU+g+Mc46aO4EghhJ94s6UtHGQiUX8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bS2RE7QhcPhAVTQBOFgwuZKQKbO/ELb+0jFsMPuS+20gEmqJ71WWBYONUeao+oIjZ
	 /5Ad/BF3xbCz4YHe0G8ogB4/QwqsJrArzPG5u0HIS6tiav08RmGldTNdJi/NkIUWv/
	 cIT786OR6EVU2fEzcZIRCzoaWfGis6yZk2M38Ubb/kWJ8BlMD5qXqiOiqLO3+yaI7g
	 0cfvfMfhwgUYJaSjkYSxzxJWrK456Yf2kUnKVlSa8ch0HeuLXFA6vWB6wvAhysEKu2
	 ppUnVJ6NAfjFSrp0CIdxWeoqUuqdam4Z1kIXAdq3agppIiy1VG1iC+mWFUBfUFleC8
	 LeImTzAH7xMtw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 6 . 0 . x" <stable@vger.kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH 2/2] Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
Date: Sun, 29 Mar 2026 08:55:18 -0700
Message-ID: <20260329155518.48149-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329154955.47813-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E7F244000E
X-Stat-Signature: 38rb5qi5ij5yae7m3htp9nfyytiryjg5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774799720-963701
X-HE-Meta: U2FsdGVkX1/nPwhmhdsGRI6/IVeUsxQONCMz97IohGZ20nhlK/Ocll8zAcjpjuiQ9HyELcS7RiJkDq8Ut3O1721beXUvsDSoaBqnZlLID4d5SV0ZJF2OhzjNtHX/Ih9tOhALb6LYILi2APoNmII8EnY2maOiu/GeUVATRGDu1Cb9OpZO7rPCxPVzWAfTSi6vOqhNoRFqG1A1HXvlwgmgsna3Q3JPEfj+H/xfZRrLGSS5mohu1cRcBO3Q7mNGJ6hU/4OuZzTaAU1XQlRdZRnoF90AuYo34fXMrxSRe3NNlQoWQ9l3rQwHJ2navbirwBNhxpfFf1gHR5wC+R0v/KONpeEonDmvrkx1qZXwAPHvh1tXM9i9e06bKsEeEF1nCqd3AfM5mzFidAh2glT8TcKHEtUiisNwt1Lt02UCWF/9c48QfK0oc0mIv2M70LkCo6kKX58r6+M4Vpo5q8B7afOzZyLzJcmTX8BZFSpwOX7qNnQBhrq+r53LVg/Md2tnkkusl3vjz/qZY9Xk1XvZ0483rWd5L4etvKXY4k+ODoIjIl2Lz+F5wF72i4Y4gXZMPnhNcOQU6KshdDD3cPMA4nKYD8ArQqwzlAyBU2Jx7OPD02GQaX4zqaF6wSjHmyR1q7kj1c5Tzgle7rl+UilfbgDXo8VI2rrEaIquMw5iRC/b7X4eWfDLhBD4zBtxyJPhFf8ltZnW5a6Qs5RzUEInBNy5Shc59MvD4r6sOu+HhYjSFl6wArTOhgc++WPThhz7vFbg8Y8L1edCycyz1hKAVOeUAWOKRzrKUhqFkYOXf3htFI3WWamyj6ygoRQje1wQy///9M9hAGkJvAQ796Y0oYBcmU1ZN554lZpAVUtbeqbP3bmElGh3zSrsbgh+0/hYafthwwjeZmQtEh0TZoiGNgNcB2BOmarnELmLPmOYx2kueCOjqFkCPlOYTShL1GF4AWsX6M/46qrHQdze4McyxOD
 taHAE1NA
 qUPgjhY+M71PkEB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 08:49:54 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260329153052.46657-3-sj@kernel.org
> # start of sashiko.dev inline review
> commit 7f5e14b7be3b4aea36d62a6c529ef25dde22e973
> Author: SeongJae Park <sj@kernel.org>
> 
> Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
> 
> This commit updates the DAMON LRU_SORT documentation to warn users against
> modifying module parameters while the kdamond thread is processing a
> commit_inputs request. It states that violating this rule can cause races
> and undefined behavior in the kernel.
> 
> Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org
> 
> > diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
> > index a7dea7c75a9b..14cc6b2db897 100644
> > --- a/Documentation/admin-guide/mm/damon/lru_sort.rst
> > +++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
> > @@ -79,6 +79,10 @@ of parametrs except ``enabled`` again.  Once the re-reading is done, this
> >  parameter is set as ``N``.  If invalid parameters are found while the
> >  re-reading, DAMON_LRU_SORT will be disabled.
> >  
> > +Once ``Y`` is written to this parameter, the user must not write to any
> > +parameters until reading ``commit_inputs`` again returns ``N``.  If users
> > +violate this rule, the kernel may exhibit undefined behavior.
> 
> Is it safe to rely on userspace following documentation to prevent kernel
> data races?
> 
> The kernel is generally expected to be robust against concurrent or unexpected
> userspace inputs. Does addressing a data race with a documentation warning
> leave the kernel vulnerable to crashes or instability if a user ignores this
> rule?
> 
> Could this underlying race condition be resolved with proper synchronization,
> such as locks or mutexes, rather than documenting the undefined behavior?

I answered same question on the previous version of this patch.  In short, I
think this is ok for stable kernels.  For mainline, Liew's patch [1] that can
fix this issue together is on the way.

[1] https://lore.kernel.org/20260329075415.36775-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

