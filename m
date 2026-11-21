Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8473F606A330
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K8Akihat
Received: by kanga.kvack.org (Postfix)
	id 9F9826B05B1; Fri, 20 Nov 2026 20:07:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA7A6B05B2; Fri, 20 Nov 2026 20:07:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA3C6B05B5; Fri, 20 Nov 2026 20:07:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F55F6B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:07:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDBE11602A2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:07:54 +0000 (UTC)
X-FDA: 85457339268.15.FF966AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 47D311C0006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:07:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K8Akihat;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795223273;
	b=VZKpq9mx7mWo0UzfBMWHSJbH2jnTJckSzg0ANdZO2pM3i6QZcoetht9nxHWB2Wf+RVCtID
	e6mVpDBnNXnEoWSsp9z/ACRNKP1bhCRehLv6Sx0tIlXzu5Gj7QtKm72ASpd/7CpqvuE807
	J1/9Cv3ad9bmlWq0ieGYBAZaeDKqsyI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795223273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgExItfbGmUuZ10iqGpss2vMHMrko+DtSglCtXO0IVE=;
	b=EuMK1ZKmfA7/eOZlVnerFLe+2d/hl9ShTvbG6uc8FMcCRARg5qVbDyAJxuWdL0yazPD3la
	eLdktQ3ueWJGbRDWhE96t2v4SMIITPwrffhWSHzMcg1i6ivvOFPq6zjXH9U0wcn0qWTbw1
	j5bQrvIKWjB2pDpDWFv5SFSwwTTDFi0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K8Akihat;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D672461FA;
	Sat, 21 Nov 2026 01:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D99A31F000CA;
	Sat, 21 Nov 2026 01:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795223272;
	bh=VgExItfbGmUuZ10iqGpss2vMHMrko+DtSglCtXO0IVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8Akihat8Dj/+bVqWQCY3uH8/1TDnPSe/SKifdtFSVWtGNqNKOAk43pv/OLDcBQhH
	 XjOI3PMsyIubJ85+dCB8HYtHf0TOJQAKKowdA/C0H64wMKa1cHdphWxbwQPCqZy/hl
	 ghc5mno1e5BMu4Ucm8hHO8Jcbx8gUE2P3tRi1BNGuE7sgS0YWFOQRbqWWk6ioYIoJh
	 L5Z5sJkn+bdU7ZHNAlDr2YmFGiMHLrmyqgQWXF4jVCGCCiQ5CXEmU++gdWGQqWIby8
	 m2yulF+Wg6EjyT5Ash1Tsf4z5t7h7iGWTOA4yF0FUQuTpvk7yOI3jy/FrvhyH+TYH6
	 RZP9d2KxgIsgA==
From: SJ Park <sj@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Jann Horn <jannh@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Wupeng Ma <mawupeng1@huawei.com>,
	Ding Feng <dingf3ng@gmail.com>
Subject: Re: [PATCH] mm/msync: return -ENOMEM if page-aligned length overflows
Date: Fri, 20 Nov 2026 17:07:44 -0800
Message-ID: <20261121010744.83351-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 47D311C0006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wfsowd4c39wy3waqdn5ogcak86gowqwt
X-HE-Tag: 1795223273-313020
X-HE-Meta: U2FsdGVkX18LGFWbq7oidn6Wfuq0rHdMUYLJ+XzEW7cbdgJ5/1yhWT2ZiZ7HBL+y0Mh0OXON4iP6+CUK9xj0/wCQVblDgkLtgOyYXWrx9MayThgftH3xqwg+xKm1wGkjYdozNcF1h5a5uvR8oNZiDffyN3xgW4vpL68PPs13+ipExnFtnfSdpO7aL2VI9ftWBEkQhjCf2hLH8x/dCq3O+n34T12oq9zHATYw0iGKuas0DGvig2/k4JSynr5lv3SE7RgVd5C520jwwbECVDFkiBsi1vgHgsOAn6qI+Gbas+D5rtrNCX+1iOKv9ky3ebN3P3HeH91DFwU0nt+Mh2oBlqsh6LkJrBSk0ZxfkWLwtCJ86c6rk6z20Iew/snIa/gBWEoJs1tswRlm5yLMyL9HFnRVSS17w+1XuhJBcQ55XU+y251LgB2WrjmiEhhcvRlAvjFVsAq+P+XatL6cYx2ebbonbDAhMeK41EyhA5QLCdFmcjpM2C8qfpxI21d30ZJCFE/d2vM3YSSVWgfkIOjo0Ttzf7jLA0y5IdldNFur2ag2H3ZTfAAB6oHnaEt1DHoW0dG7geiGpJgjnBMWjP+XA6S+BMygjcrET9DNEG4JSFB69osEc0HPzYmSU7vzX7t/UA8eRIqKjhhO/+NN0g0TpUOgwFVR+e18UOVGC0e5mR1SIkeGOLkUsKae6GKoarXqmuaVvJGBJcOoCnUaY5vyuWkMvVJZkOKAmuTGDyqsLI6Gs603oiHpv2Lgxwf00DZ7oNU4XCaTyGFPjS4PgCdUyRJRDNlielGMb88lJqDk0pHjBqcfYmLah3l3wx41WHiu1Q34uQasyJpAs82RKLRIutxtllJCvyNRvZmUDqyAcXuyEWMzpH5iATowO36b59WAGHEx9XKTAGJm2tuotxnrCVQ1LHfmPq7UA+rPp8mQuHty9u/sc21srkfwulqNS482nVT4TF3CcyqpFJUl6Yw
 aieW8vR3
 OUQIIFGFBnJc7Fz8TkVlFyPvdxF8ZnPaZneUwYdlY0ZqFXj/TVtL+iUPL5KM5FdMS6RM5C2PCUSTt0r83Vn6vbKIcUQVgh58vR2ql+clDk3vnWi/NJBBBftariv5qHznnYdktd3iLVat9yJM3D3DS+wK1pQ9i9Nu8PxEtzC+06W1Iv9Nwc/q7dG1fzBW8DBX+TSS4jMhIE7TylynNWN/XPOnzMFMiSow5iI6CwTr9fZaMrFyMV3J022GcXB5CgyArIfCfOALcEx04zE/reyAmjIG8uKtrP9GtVmh7A2Yk3U733G7dCH/+8RxEeeQGS5Yu8calIXCgVWXoIHNJacym5VjFQISUfYvgOoN1soIQpNtLr0MNsAPvzGfOOg+NGhnp1WzwjkP8yuCfGQGSq+Uxa96kYs5DVpKaCJEpeWz5wphQ4aXKnEKeTVjPxx3JcqVndF7mK5nmQfZGS+zMyypZIFJIkuZUF1aBf8fMzqo/gnzf34MOJ94ww7MyN8hezzaL6Nfa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 10:59:56 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Currently the msync() system call will simply return 0 if you provide a
> length parameter which, when page-aligned (rounding up) overflows (i.e.
> SIZE_MAX - n, where n is in the range [0, PAGE_SIZE - 1).)
> 
> This requires broken input, and nobody has complained about this, but for
> correctness this should really return -ENOMEM, so do so.
> 
> Also, since error is assigned within the following loop, remove the
> unnecessary assignments prior to it.

Looks all correct and make sense to me.

> 
> Link: https://lore.kernel.org/linux-mm/20230321074035.1526157-5-mawupeng1@huawei.com/
> Reported-by: Ding Feng <dingf3ng@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20261120051413.46167-1-dingf3ng@gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

