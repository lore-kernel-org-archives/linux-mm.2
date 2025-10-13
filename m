Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED33CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDDF48E0010; Mon, 13 Oct 2025 03:56:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB51E8E0002; Mon, 13 Oct 2025 03:56:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2238E0010; Mon, 13 Oct 2025 03:56:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE0E38E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:56:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54D1311962B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:56:30 +0000 (UTC)
X-FDA: 83992333740.23.5A91C90
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id F21DF80011
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:56:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Vfs++J5i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DtLGvF40;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J8VFdhHl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WVhrkLKQ;
	spf=pass (imf30.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760342188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PX880TA/77/yrgYUzZYJ9ptGRpChgW/jGJJ8qYIOliA=;
	b=QPEdjxXxDsFjbkT7vt9cgthdFhPxMrpcfO1nAN6ybbdtsVZ2X7IDUESe6jQBnqXd8ldXyd
	ppfkzYsaIBJbTPD0Pq9GUyVuvKzYhSt7RVzSLDWCC0Urh+1mP3dVseZB2cWgYoKtga/Bzw
	EEZHJw//qlQ1NHZvYSWQnxebAhXAOtA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Vfs++J5i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DtLGvF40;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J8VFdhHl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WVhrkLKQ;
	spf=pass (imf30.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760342188; a=rsa-sha256;
	cv=none;
	b=ROn4mw7Zr5u0ZFO39B59RohFm+b51y8ebNd8quw2x+c1odiiH/jqTkm9/w0YQ7ECotWKYH
	8ywnFA30OxPZDeY0Jxqo6AiwGHb/CXC4oSaGB8gswEQ+RPHimwAoghNVBMPu1ULmNtFxyE
	XTYsx9/hIKpHsEz+syTnpVuPDEB3rMM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 253F5211B4;
	Mon, 13 Oct 2025 07:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342186; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PX880TA/77/yrgYUzZYJ9ptGRpChgW/jGJJ8qYIOliA=;
	b=Vfs++J5iE5Vf+i6+pSlQesYltQxk/PixZNz6SgTCTa6+uwJmSOr8xRXP06iuJeVvH1u64X
	hbiZUq57LJD5nW4KQ+qj6B4dhOiSQ515tIgtGVZV5DPre/+I305cLWI4j4EVA+dcsRWDUi
	rbFzuIzjEOiD+hAXy5prs25PKwOGmLg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342186;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PX880TA/77/yrgYUzZYJ9ptGRpChgW/jGJJ8qYIOliA=;
	b=DtLGvF40H7FBAeyeAUkcfpsddi0LOHAHJcrB+yIuvZD3Aaai6mqyb9wToy/4RALiNPodQl
	PtyOZLOltnjIvDAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760342185; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PX880TA/77/yrgYUzZYJ9ptGRpChgW/jGJJ8qYIOliA=;
	b=J8VFdhHlx7doAxqdrJY11dDWSvtAhIpVKO4HtdzdF0Qh26Nkyn2w2s0toKxzCuNhE2kk2b
	xaIjD08b8qD3eFoueKEfsXKZwVvGj7Oq/WMPaiX9tZ59PweMiwH5aWuW+1wcEWTErJ6Ant
	R7TYLxDqwzZ2iGLTbau4kG5w5/tdrO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760342185;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PX880TA/77/yrgYUzZYJ9ptGRpChgW/jGJJ8qYIOliA=;
	b=WVhrkLKQQe2+Ur0EQdAWDpWIZ1glyXkwJlzIdAcyQAD/tJKKLaRSrSkMRkaWqTWUeS8Zu/
	hwrDc7ahVXAGzyAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80A9C13874;
	Mon, 13 Oct 2025 07:56:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qyJ2HKiw7GhGDQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 13 Oct 2025 07:56:24 +0000
Date: Mon, 13 Oct 2025 09:56:14 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Usama Arif <usamaarif642@gmail.com>
Cc: muchun.song@linux.dev, david@redhat.com,
	Andrew Morton <akpm@linux-foundation.org>, shakeel.butt@linux.dev,
	linux-mm@kvack.org, hannes@cmpxchg.org, riel@surriel.com,
	kas@kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/hugetlb: create hstate_is_gigantic_no_runtime
 helper
Message-ID: <aOywnmyYj7R-CFVd@localhost.localdomain>
References: <20251009172433.4158118-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251009172433.4158118-1-usamaarif642@gmail.com>
X-Rspamd-Action: no action
X-Stat-Signature: a3jn7z163ri7ttzbxaiz6niqr6fc11oc
X-Rspamd-Queue-Id: F21DF80011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760342187-135241
X-HE-Meta: U2FsdGVkX1/An80y+0c9fqDNwpDfrpJ+b2wuJePflSrCO8smD+GmoHyf7WHWv7VRZuPBeWN9hBKmpigpmva1iDZ862YU4m6n2VcyaoYYYfgxojiUB6uBhYLDumh+DSvcp3JGw+mFECweaEJIXwhjOc98QAFaDj4ewcxIvPmVCloD9iTSj6Pg64oaEfF931B87QBY8LQq6JCTmu7SF1krjPM6epDbP9v810FAg1q6YCfw3jDF3+ZF7D+7oeYUhglT66S3iKeumUaPCHviz7FyaLgVvep0uRrig/dDlBhzDbRKygSOke6Shj/jHLuHMeHj9rPsmh49tk+C0+EshQVs1nAA4MecjZqhAYlDfHK6c1Yz91HHUMwcbcXYy0hEJuwtto9c2yIO6U/hE8/KH2bQlhhspdkHbWT27VLskDEKYj0I5qayiX9raSp90BPSxwnl/mqvdVrsk75+UmvorSjFRituI7d9KL/c9d64HynxvYmAnZZRabUcpGQ58ERCLQa1QFGFLn1QdWNn1DKlqtSgSOlbPJ641vq76OBuvVq1iZ9GAcf8pis6r8+aCfKJfc09oopHXispx+lL0Tz7xpYUMtpbD+Di0x1PcswKRQ8tbOlTjgdXsphIYxs4o0KezD4NbVDIKUHpih9tCu+ct5ZURP04pFXJ5bLh5iD6fVDNhZrRcmsRvXpo0+6oF7P0vu0f1VGrjpAKjZY0XUTBDtUPRHGh1m5YlGI3/yW9X02cZpJSlYT+zs8hzkPgw9emdI/virYKQnWqw3pI1EmdUF6I0QWAkuvWgl9hJK8g9VjUhw2ZA7IB8TK12g6gX55bTP4FIofGLgdtuc7tCHM74p0BmqPVsEiYXr+XBdKnDY6BHD8UIVfDpslbRxSTRUauLc5TJxIhZcTkIm6dx5iSkR8VOWGg6FaNT00yAGXrEwC7QJ8qSzHc5c7DkdT61Vynep4L73TQLz+CRsZztrZhWaI
 6VwW/gRQ
 08errEte9fULKkZAyksqAflBtZUYKb6XtxYe0eW33Uv0cABWKIHTXCgwykFWSU7d8xNYslCAS3cO1leh7cwv78R77mT0PsYUUGaxXP3KkPKwLg3wROYKnmPw3OxYCRF4A032GOXS97XaUiY4DwR8kkmHBZO7Jz0Q/J0kHGg7Rl9hTwWMinJlwl3zDH0gs0jP7VQ45qdftzhSsCXohmxA7gZ77bEm09lkNxlyqxkF3MfPwGHNBvnXnb/03rwQLSmzQw6hkCAKUfsesnR4ON3pLkt8NakyQ1+yzlJ81gzo815OfV87LpVa19gUqGEQHxhIvc+q/XKljref8NTyO5Ro70uNjjPaMC25NobcgXlPRiKvSnwxT0j380xGQq77ZZo8eHUsI+/7vIkn9lus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 06:24:30PM +0100, Usama Arif wrote:
> This is a common condition used to skip operations that cannot
> be performed on gigantic pages when runtime support is disabled.
> This helper is introduced as the condition will exist even more
> when allowing "overcommit" of gigantic hugepages.
> No functional change intended with this patch.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Acked-by: Oscar Salvador <osalvador@suse.de>


-- 
Oscar Salvador
SUSE Labs

