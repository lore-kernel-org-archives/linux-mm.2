Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD550CD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 00:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0E16B008C; Thu, 21 May 2026 20:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150CD6B0096; Thu, 21 May 2026 20:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066C86B0099; Thu, 21 May 2026 20:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA6406B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:57:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A0CE1C1EAB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:57:56 +0000 (UTC)
X-FDA: 84793243752.27.16EA0FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DE7A580005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:57:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GLFqsSlv;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779411474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwUYo0zI2vSQiwfY3hlowk3OeV3gQXWwuYQbo44sx+s=;
	b=v+tVWDP3S+j/5fmYBhTiPNCiOJjbqSZo17hipsbHnr5SxuR500Vrcw5AAOvOPhJ4/YyCTJ
	23g+viRyRbP3Trz2zwIqV1Ya4XfxD6tKBDQtAxBY+vbOgBAu724cr/loTjN9aUHC2vnftn
	cyYhcrVhEJRP3V/o85znIVYt+DvUA00=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779411474; a=rsa-sha256;
	cv=none;
	b=rz51dUYdePMKmHmpKR0Re6v27x8/MuMxlBneU9w3Q1IxW1xQGVShxkwVrKLE2obghNfz4Q
	nqoT0rgDvC8ZclccHqEgfTlYk9Ya6lD2R5znCV6wV/IZ18ETSGueQk6m8vhiLGaFEp/okf
	zes36JpCC3H6mPhJR6Kf+YDTzzORu/U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GLFqsSlv;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C5B160136;
	Fri, 22 May 2026 00:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B136B1F000E9;
	Fri, 22 May 2026 00:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779411474;
	bh=fwUYo0zI2vSQiwfY3hlowk3OeV3gQXWwuYQbo44sx+s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GLFqsSlv76JXr7aoo+Q+pAlwRISlMiA1Pf1vnZceSOmAV/8QHj6cYJyLiLf2fdcVk
	 J+MQxyvS/v7PDlzNMGLZhG8yrTNAnqnUMLvaBj1EiRvDTDIWIQ2vMplk7Val/SzuMY
	 ZCsLy2/KvALt3xQkPBEMcBqu2IjhcsGSdxzuO+ck=
Date: Thu, 21 May 2026 17:57:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, David Hildenbrand
 <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Lorenzo Stoakes
 <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport
 <rppt@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RESEND 0/3] mm/damon: reposting three reviewed patches
Message-Id: <20260521175753.3c6369dd3fdb52ea3816ff2b@linux-foundation.org>
In-Reply-To: <20260520012104.93602-1-sj@kernel.org>
References: <20260520012104.93602-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE7A580005
X-Stat-Signature: wh5891c4ottn931ujcakzey63ou31r96
X-Rspam-User: 
X-HE-Tag: 1779411474-635626
X-HE-Meta: U2FsdGVkX18xFqw8b0n6B04BLi/est4MwcvO31IObubzp7yEQsRmZhAP/Z7YzNT5ZL+F72KnNnX+YYmxsTHBL5JnLyX8nv3asKecyDl6l7oBeurp3EG7CT4Cwfk1n8FbhOWXWym0IW/viQEvcSdPIqaUsyAoFD46I7IkcbB1m6S/G+QGTuFcxF6RQGpt0Kst+Xx1kuuWMZ5rHBstRkFseYf2Y2RLPW6tZO6+UIK3ckfOwvZEEvnwrPSoFVkaHKM+dwIXd3gOyPi/AlK/64ke15Gm+HKJDx+DYxASGS9HrjabYP3ygFouxZTPx0a9CNU6bBsnnvxliViA3LD0W94csHmuibwJ0CF5D5pDBR04PBVd/GPcRIbyggTAOjNfsVZszNnJgEoUShNfdCHP348EaMPkGi6ncb+UYIQxRRxGYcXuaGZnnldQeV6rBzzTtErWVgRJImph98d0a4Oz6GZJ10W32XD3iEoM4Xumuje+xhAAGb7sDI6N+CBN3BHhvpbRmitJslUMFWO+frHVsczbAaDvoiV9cSiW9uhslNTlEMJKhiHgsay1TXDssHHOBTtVliR0lwPzJHfhAhr5jyReoUWZs7HNGooVdfjoS+lu0qgCXOf4Ks6x9s2HouEXi/ZJ2do4ZdCCCqm1HZdCCdBqLLzC/Etcg2N/iV4nELXBY1ja+p8zlGhuRpBFL3+ZcqEFpZAGzcYBziN0D/8ffKf9aP88x+mKZR+bVOtJQBRtXKGoGmDsKa+lDmOk2vCxNnnBJd9ipn7lxOOt+lfAClJBsX6l4+P2rpuj33hQWp8yrmZNUHv5mbTy9l0/s+pdMwBSudwUwFE0P28sHV/iHJw25PjFggkCXynA4hmh2BwUJ1ei7PkrArlQFJMNFvCa/JsseMeHqpDb+h+4m7p0af+CdRQKbeIr7Rxqre2E8jV2+OLyxAFBKKDbHaaTNStdw/8Zlt2WL0FEXBrDArOAToR
 vERdqTIH
 zqFAUrE2zgt9i9GUZmsBvmKl0/AhWSRw3VvYHHO/0ALpzF1Y3EJbjXvgcvTJuQvV3YiZdmsHTvyCiwlRI+7YgJfhSA+WOwCAcXxQF2Nlqr1OOF/JSg5aFH79PCHEotORb/PsSc0j+rmdyR+iQv8gPZIA2u6g4wGSh+2a49EbOuJepfL9RCRBhFedls912sBonXj6zh2rIxUnwrJbBbwQSsH6v354QHeuS41t4Y0jOGQPYXZ0BqlT4dgSp7cWmuLaynYGMi0n4QlHbOGgIU1K5QmKkGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 18:20:58 -0700 SeongJae Park <sj@kernel.org> wrote:

> Subject: [PATCH RESEND 0/3] mm/damon: reposting three reviewed patches
> 
> ...
>
> This series reposts patches that were reviewed by the DAMON maintainer
> but not yet added to mm-new, for more visibility.  From their last
> posted versions, only minor changes including commit subject update,
> Reviewed-by: and Acked-by: tags collection, and rebasing to latest
> mm-new were made by the DAMON maintainer.

fwiw, I don't think the Subject or the text are appropriate/useful for
the long-term upstream kernel record.  It's all short-term
development-time info which is best kept below the "---" separator and
discarded for the permanent record.

I rewrote the Subject: to "mm/damon: documentation and comment fixes"
and left the [0/N] cover-leter empty.



