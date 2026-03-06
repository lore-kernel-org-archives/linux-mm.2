Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276A0F01821
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90E696B0005; Fri,  6 Mar 2026 05:30:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B82F6B0089; Fri,  6 Mar 2026 05:30:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5DC6B008C; Fri,  6 Mar 2026 05:30:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 713B86B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:30:45 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17860160475
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:30:45 +0000 (UTC)
X-FDA: 84515269650.12.1D84C6E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6289AA001B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:30:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ajbmjid4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772793043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypir9ACeo9fn0O3giSko3MK+rMH4jE3BtswSlrDHXBE=;
	b=ZYg/NIxu+zNZCHaR+wHJCHgsq1XJS4RbgkTNt8udPjptuIy96X1eN0Sv0ngHWvxyiLDInH
	dBw9MuZDZmNMPTYaAWDa12Cm/oGRnzWUtuOAUKMztHtNnJS1MO2NELWoAUPP5HrHmUPk6n
	zqyd7QBGE0LrvaeilTOG20cVbKs0l24=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ajbmjid4;
	spf=none (imf15.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772793043; a=rsa-sha256;
	cv=none;
	b=Ihy4rDvP+TAhEz7sCAItqi2my6CO2Jvp6t91IIskDZzRwF6vT9iB9NCpVoUnqv0eY4Pu2k
	nqn0xKgQ68xMdCvMGn7yk65Hps/9a/PjSKXwh7WovFrRHj6m0ngacy3z8h5Dod/wqsZvSB
	uSCTOula3av73+O3ZfdbDxy3yDNzfHc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=ypir9ACeo9fn0O3giSko3MK+rMH4jE3BtswSlrDHXBE=; b=Ajbmjid4ZiOJjJUGjMlYBw310B
	1GkbvHzGSBbVjnipO1Eg5hFp4eexPzSkC/zhnX4VqOWT6TkvVNscl7zvBZQP3z9U295jXQuzLonjp
	WuEDDU+tR+TT0a1ozpA4MeEpZFLgvZo98PdW+oelam21K5+UYq4XiEYH9b2wEBsnLeR7RTdrKOqgB
	Twoe5PnwQ+Gv3K5IZfadHefBWsDq0cS7t9xFj9XTDLYOB/W1Ts83nBkKd6n4I97dlSgwsmjYNWCgl
	ktr7lnJgt9DadaOGOPwQfSg7FbCK4uqwR5qOKQH4ohXJnOH/O/AeBcnW85fVXOaWSF8IskVOZ1NFW
	9aschnKw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vySRw-00HR95-Dq; Fri, 06 Mar 2026 10:30:28 +0000
Date: Fri, 6 Mar 2026 02:30:22 -0800
From: Breno Leitao <leitao@debian.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/3] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Message-ID: <aaqr6n3X-KRP_tTp@gmail.com>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
 <20260305-thp_logs-v2-2-96b3ad795894@debian.org>
 <8b238664-4375-413c-a8cc-105d98430362@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8b238664-4375-413c-a8cc-105d98430362@linux.alibaba.com>
X-Debian-User: leitao
X-Stat-Signature: wbbcftrayk6cg6nrajnma5ncd7wbncz4
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6289AA001B
X-HE-Tag: 1772793043-64433
X-HE-Meta: U2FsdGVkX1/Fs9nvEo7EWYZd+olywoa+THtooTYSgTnctkRBCA3EtGYl+nTlG+wXn93bthIVrPuULOudUs9bvvQRasucmuzWZl62DTDWXdPkKdqxL1bKhLYVhSn8N108a6lRxtFmRnpHW9sc/bNXtHG0S9xNiv5CMOaHBcn/hderJwDz4+lgEepzcDBSPm+dl1M7RSFJIZ1lYHpYlYMLJo5iRwCLRyLIWiZ/50Wi0ekPsUNBY9Rb2K5KGG+kUPw7ogOBomeDCBKv0K2KI/B4bN+DNA0elrN9mKUinBUv14LONUuTVOBP1OQ9jvX1WHREnPI/ruHThZGKhbU7vux1B0R3tMaspR0XCnJt6jfXN071x0yfgUGz+Pl4GKAvHl588nc1mV2pV0vKf1L3N0Jydtecjp3H5wCkeYyaOlTHA0/fT8p2GL1UvEJAiwflkTMSsM1nnjy0z9aJq6ACGTqQ/FG1GVGsf/LZhbEHn7lEGRCZTyCv30gm4i3+IBKzq4rOnykcVX2/vshrni2uzYzv6RNlFYz2PcVBKqi3FiTixedQGtks/Vd2SLjq1boIvmGOOJb5J1hmhuEow5QURjZ+KgRIWi4vZ92zNbIZX56GNIMTBJzBbbKgjiyj/wu5dARSTu0OipFlnBDtnpg66I5/9WYOpXndnxnCapJeXmWQMQ+2ZA+QjkPpkfmeBx3Aig/RyWrAMpFh5XO48YwWt9uHtiuKe+n31Yel4ZOp/MNqLWCdrEZuW5YwbUZNB+VpWMoXVu4tc0TVTM5TAF+sOizy8XVLK3zYI+H+nD9JV6hlbp3Fi07Yq3sNONt2khya/UcObEMvpWs7v8cJx8S5Cc+QAZ4gpr6qwGjOqBUU50QXpFiG6YOHIL0GyS6qn/JJO2gEvyflQ5GzOIO1Ci3QRx192QiHP7wIZZpRhUknEITf/d5w4k5SbVbuNpSYBbsDCrd8iumHXe7o30uE8+/NRCS
 vmmke0e0
 7YvunoT8glFd51d+9SL/7/ibr2XIwo/yeF/UXsQkMaMOuk59uID0MT9wgc5peFBJCTuj1PpNMRajwRybw7ptiUo6KNFtR0vDuFRGyk5qa+9NQzTrcyVCUGYExE+5KzrPmFL9B8T+OyxjaswMuoFDtygFCTWuWoHJsFvBsKBRZbVT7LRi9p4Twcxj3ohzwjiN9P4hJNFEhNne/TsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 02:07:50PM +0800, Baolin Wang wrote:
> > +	mode = sysfs_match_string(enabled_mode_strings, buf);
> > +	if (mode < 0)
> > +		return -EINVAL;
> > -	if (ret > 0) {
> > -		int err;
> > +	if (change_anon_orders(order, mode)) {
> > +		int err = start_stop_khugepaged();
>
> Thanks for the cleanup, and the code looks better.
>
> > -		err = start_stop_khugepaged();
> >   		if (err)
> > -			ret = err;
> > +			return err;
> > +	} else {
> > +		/*
> > +		 * Recalculate watermarks even when the mode didn't
> > +		 * change, as the previous code always called
> > +		 * start_stop_khugepaged() which does this internally.
> > +		 */
> > +		set_recommended_min_free_kbytes();
>
> However, this won't fix your issue. You will still get lots of warning
> messages even if no hugepage options are changed.

Correct — this was part of the earlier discussion, where the suggestion
was to retain the set_recommended_min_free_kbytes() call even when it
is a no-op.

As for the warnings, I see a few possible approaches:

 * Remove them entirely — are they providing any real value?
 * Apply rate limiting to reduce the noise
 * Something else?

Thanks for bringing this up,
--breno


