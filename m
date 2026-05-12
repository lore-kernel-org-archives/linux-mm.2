Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F5CCD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3981B6B008C; Tue, 12 May 2026 04:39:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348A26B0092; Tue, 12 May 2026 04:39:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2101E6B0093; Tue, 12 May 2026 04:39:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10F736B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:39:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB48D8CACB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:39:03 +0000 (UTC)
X-FDA: 84758117766.25.444C519
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 799E580005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:39:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=B24BTupO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="XZLe/pWb";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z4qmOL+i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nkIJGcsG;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778575141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRmCTdeVkPT2NuaQu5a1eLxhY8w1hkEcHcyxJVJjlzY=;
	b=Mxrba2i0kWJh6LqwxP2FFq0GXQIBNkFjq//H4ik2K8k9h0AQJbX0bSfEsmO3IUM5Mfb/yD
	gzY9opM/+hPq0i4wvyJpEf+DuZogOtHYBnwSFvwcHj6j/TRzBt/+5jBBWvS6sJjI7ZVaHi
	Xi2lOX1kWdHeBg8uJIsQGGl5EYieopY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=B24BTupO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="XZLe/pWb";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z4qmOL+i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nkIJGcsG;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778575141; a=rsa-sha256;
	cv=none;
	b=lv0Lf0YZwYS/FAqKJA6b9nG2Ty1ICCEMMr2xmVIRRPrywdOXBdhhQtuRY+t4KZPmGWjBOR
	HtR/bGDwgJMFzeK4B+PDaJ/5I0jEzkU4zmAAnw1fpCS4H3tofKeDDHcKnLb4h1q2p25htC
	qwTT0qjN+xOxqH5gxYj/ie790KlDVZo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D14CD6BF73;
	Tue, 12 May 2026 08:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778575140; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cRmCTdeVkPT2NuaQu5a1eLxhY8w1hkEcHcyxJVJjlzY=;
	b=B24BTupO5JD9b26rwUH+K9d1/Vcxshhn52OYk9URYHhW436cIHAcJ5Vn9NDb3R/VmHnt+A
	cYBPHakUFtxh7DWa7mBoUfuFlt/MQIhnuYJnoVtjcHTkPpy7Dd+E30iqB7kbl02XE0cBDM
	7YCh3HdiM45BD/uV2O0o/nSt4iYbtUM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778575140;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cRmCTdeVkPT2NuaQu5a1eLxhY8w1hkEcHcyxJVJjlzY=;
	b=XZLe/pWbKYtYi19GVwMZY/8qyCkUAAmKF9/VmTP6qz18Z/+WD8g/3EBKvKtPmU1lJ3juOd
	hDzcDCS2jGG7GHBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778575138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cRmCTdeVkPT2NuaQu5a1eLxhY8w1hkEcHcyxJVJjlzY=;
	b=z4qmOL+ipch1HGEOuXBJglkJcbrzuLP0/yWV+sZjFrdb8mn2mm/2d67A3ITeIcejAQGxR/
	RdFe8Skzfs1Q2ocyTDFeb7DByE/k3whOFxeLqYBe7XWtPbR7TIm+Nw09k14Vr/EhxhyVGP
	TRRlokoiixe8q5/sUxRjtZkAzEWJ01Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778575138;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cRmCTdeVkPT2NuaQu5a1eLxhY8w1hkEcHcyxJVJjlzY=;
	b=nkIJGcsGKfpKdIByts87clqd4f1+DPMfWm7jsnBwweokDo5anFQqhbyqLq5lx7kwRFlN5L
	NTStTSZDy+fb8QBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A89CD593A9;
	Tue, 12 May 2026 08:38:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mOqnJiHnAmpiBgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 08:38:57 +0000
Date: Tue, 12 May 2026 10:38:52 +0200
From: Oscar Salvador <osalvador@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 7/8] s390/mm: use free_reserved_page() in
 vmem_free_pages()
Message-ID: <agLnHDFulmuyhxGi@localhost.localdomain>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-7-3fb0be6fc688@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 799E580005
X-Stat-Signature: ty1tmxdynw9aaf3bsxka8ufyxo7kmpcd
X-HE-Tag: 1778575141-880709
X-HE-Meta: U2FsdGVkX1/C+qUYsXpU2Pnkdl5fmySiMILlMkGA7EVyvnMoNQKkYrJhffw4cimAjeWAZ1br7iGzOUrDQifnF+4cLyva2Q9L0cr4wYHCBecMjV59Ahoog4O6vhvDWQOOpvm3sUm6xnf4FCJPvCuVC0JPf5feOF3Gh02z7owo7t/eZjJwnQW4OkShwkHWItjXk2ELaa4wFF5TNpah4GbNvUQjZIER09Yp3aZxaetwll5uqtVmqS2q5dZhhH3xUPyiY9ZgX4ZMbWNHghHpS3FX9eKYj/f3VZao/e5lqTP7ZeBZfwntMz4EzGWYy7Db3krZzg5J6ZkBxhZIUDXTSEHkuZ70jCyCnBU3jSnbxbGElO3wD86L8EJEMmUmArPPqw7XuR84AyllJyp0a9XdfFDJCate+JCyfp+1hdnrL4Nk9XvN2qrF3qqaLWf+2l3RU9JvWGjso8EBX7FZp+Zj6NrIjybBZplbpPgNfiIc85ibvoVovp04TOQbB654/AE9aT4KRYPUGdkOjQMtcc3MnO3JR+ZPQkcGjhXu+xL408onB2qcSVHF0czDyrjB5MlSZVBWS95IbKxEAq3qy9yhz793YOeEC7PpcybyS4g0CnTB/UWHFVcMNThX2Db0maIQEtjfEYxw+RTznKuU9hzD2xjvVxL9CjJanzTww9Ijs8nHsflww/ZlKbnxDErO3iSLZz+nDd8nlQwMPDNm142hrD6OJE7f1I9h271CA0V1wDt9Zd2Tx70lVHVZiRGU25BFTim24QMaOABQH0/Fu6bX4+KADBDkbWEKnRxuPLs9nPC2CHXrnRCfRlJ94/9fjXQLRv6pFWWCoFsXw/oJGkIdLo736Np7n6WQkHp7IcOA5JNU6UK81f+6/0BF1hyjzlQk6MCFhwaAQ9cKmKh5oqhTCB/1jiJLKKJoyZYiGz17EpEH4HN1/S280cr56UQXLSYjfyi1Rp/YBmMkjyLfypUlZ1Q
 fLl319+W
 SC+a0cK5LHENKzBnK7ONv/ivT9ykCgTOigyuV6z9b3s10cQzy1IK908mdhuuNzbbJgesBsPUO/dVCASutkuc5DbXUz6gckluMsMG1BZe1XLFfRjp1O4g6ESMq8We+//YgS16zEdzPZcXcLIO9w6qgTS8jGsJcDlpdOW2r28okWykMvvAKDfp8RiYQGiX8Z+5QYI6R6NgEW/3Ikf8FjbJv6hMepAT7mAjR00xE/ojO0FuWrNrbj01vM9/bohSqGi4WuWvZ6HMYGxRJmVUthAPgrwH+vqPEQT27X4UH76y6ACjjP67jmZnhxT8n+Y/SMTdQKS47rSTBaS0cuP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:35PM +0200, David Hildenbrand (Arm) wrote:
> We never select CONFIG_HAVE_BOOTMEM_INFO_NODE on s390. Therefore,
> free_bootmem_page() nowadays always translates to free_reserved_page().
> 
> Let's use free_reserved_page() to replace the free_bootmem_page() loop.
> We can stop including bootmem_info.h.
> 
> Likely, vmemmap freeing code could be factored out into the core in the
> future.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

