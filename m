Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3EBF109C028
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EFBA6B0096; Wed, 25 Mar 2026 11:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0326B00A5; Wed, 25 Mar 2026 11:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48FAE6B00A6; Wed, 25 Mar 2026 11:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32D136B0096
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:01:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB26516099F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:00:59 +0000 (UTC)
X-FDA: 84584897838.21.80F3765
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5658140027
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:00:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OiWnelp3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yXWwMd8t;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OiWnelp3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yXWwMd8t;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774450857; a=rsa-sha256;
	cv=none;
	b=c9ATwSZ8L9bmWbeAzX8jhjkKwmr4Z9m64bXSPW9jlDMf4QjlHJr/lD72mSr7aQ1LHnjS+c
	H2/REhtHe+wu6zwfBLlXAaQyn4DuCYV6oH0OaZqjC9x/Gv+Py4I5uQY5BjtNdLat3UYSZk
	yqV5rHbVdtZhl9OmODbsHVz7+LTBWWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774450857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4WIwNjO8Ivdnpf/43NO8kG4T+q8Ih8+YrqD2Bkvxx7I=;
	b=HrGZ5nXm26JXHp/mun0Z8ofccDMKahS6BRv0lLgFjWW0K3imam5uzBe5wdZE6tgHzWW9ZF
	SAhkWBoSoc27LkgokuaetZNgegJWz6JM6WWUy0QmnYML03eJiwG+xM7z+LgIV9DbCvX+pe
	oC4eQKpUSm/hhRWEDoLwMW4jHD44ZRc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OiWnelp3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yXWwMd8t;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OiWnelp3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yXWwMd8t;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C608D5BD68;
	Wed, 25 Mar 2026 15:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4WIwNjO8Ivdnpf/43NO8kG4T+q8Ih8+YrqD2Bkvxx7I=;
	b=OiWnelp38hYUDlfFs6JxnGilYjT0j0pX0vseLRXxmen3NfmlKBMjYPVGFyc631FDfwcYg2
	JOgp23ALS+vR7zG01eND+lgoJnBebvXN95YzqI8qldQ1723oazabeAywxEwbDqP9gvRuWM
	V7hW4TZx0KrrmNoiHeeovc69OUSyG3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4WIwNjO8Ivdnpf/43NO8kG4T+q8Ih8+YrqD2Bkvxx7I=;
	b=yXWwMd8tPWZeWdLjfZnOMJhUGoDwZ9oysPd7YDZwvQMYMHebIkeIMFgzd0raIKir/4QhhF
	JhpZsAZ99ScfZAAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774450855; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4WIwNjO8Ivdnpf/43NO8kG4T+q8Ih8+YrqD2Bkvxx7I=;
	b=OiWnelp38hYUDlfFs6JxnGilYjT0j0pX0vseLRXxmen3NfmlKBMjYPVGFyc631FDfwcYg2
	JOgp23ALS+vR7zG01eND+lgoJnBebvXN95YzqI8qldQ1723oazabeAywxEwbDqP9gvRuWM
	V7hW4TZx0KrrmNoiHeeovc69OUSyG3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774450855;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4WIwNjO8Ivdnpf/43NO8kG4T+q8Ih8+YrqD2Bkvxx7I=;
	b=yXWwMd8tPWZeWdLjfZnOMJhUGoDwZ9oysPd7YDZwvQMYMHebIkeIMFgzd0raIKir/4QhhF
	JhpZsAZ99ScfZAAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1192844468;
	Wed, 25 Mar 2026 15:00:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NODGAKX4w2kIagAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 25 Mar 2026 15:00:53 +0000
Date: Wed, 25 Mar 2026 15:00:51 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, 
	Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 6/6] tools/testing/vma: add test for vma_flags_test(),
 vma_desc_test()
Message-ID: <ylzddvi6xi24cknpzdyt6cb3p24zh4pmji2tmebecdy53hbsn3@wnt6as4xuycf>
References: <cover.1772704455.git.ljs@kernel.org>
 <376a39eb9e134d2c8ab10e32720dd292970b080a.1772704455.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <376a39eb9e134d2c8ab10e32720dd292970b080a.1772704455.git.ljs@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5658140027
X-Stat-Signature: szf6k8xgu1pc78xyersm8r5zdzh6ccw6
X-HE-Tag: 1774450857-82192
X-HE-Meta: U2FsdGVkX1/E5JxGUgzXbkmxpg+ad63Cz5gg5fKexSQWs3hR0Zh2DD/+gHnkzcFPu1GLQVPGBE4b/pKsi/X0OKFnkdKVdwd9VOHh9Ugw1TO1MWsAnqei01FoCcz4gFDRn6l89ZOStErvoamGZ5ohTkEFgztHSZM73uIimY0ENz/YakPGIMBoEHhIxXLS0sZ8jncAgUJdkTbZ2hWEe1xcddVzERfUGf0jHD5tl+PppBSHg4CJWEstkyhLhRVZfUrbtVLwYT8DGru/RpzZwQ6zAlfAXUQxso+5huwJrpqOYITni5svuUKgecv3T/328q2AGlgMG6lGv6UHL8w3+gM690OiGqLqCRRey8YRzTJpXrHtQpyDKFzxwbUmH6ykSyXhqCZpFRpovYfWIwTvyui9rIuDEXK0xwta8FLwcB9aLNnZvz+VPtSJVPhwiCosWytq7zfjaE4wcTQSMSyZR1ci2No66v5uh+9fZr9Wmzg00OXNDZdgnywXOceqDajgJFaqdSsWhbkN9J36UnUBMTRBCaH9cU9+QpQlMuBL/Gyv1bO9ddN5hWpUtzyclWjfB5yDrRf/ygthaej6/ixHe5F10WBDN/kOOOXqPXPAYdYnMKtZat+rWkRU/JMH9qMD5gVURRF5FdpooFZf/co+ffJjZULQ/nsrAnMjBpMT30ct8Pz3cEfXg4Gpfc4EGsUKCulNbzZVIZVQ+KB40J5lo0uCtKs34mwq9/6fG77BGiQjqVFltKGlpe6RFYTwF5Vk4/brgTaAbMCofdizUItBaSlPPJLQKtp7QLKYHD1TmW5bqDz6jm7K5u38tIRbht63MJBYfbbCAJJtr/FnfnopQcoKWMI7p25Cd5iSG+S/p6YLzDUp0o0rsARcfZ5W7TWLGTd+CCn+9AGosT4vJIyAlhPqydGPRlL7nVR9hA97yAfBHswKSBhWd/9sKYoWkr93nxrguw+WGdVFwPVF3wwzjxR
 p0BLS+nA
 fd6K2MdUci+kARcwd2blnGhsH7bMSk422+TtFmoWJJbXwnt0SPNXiqNW4dLnoAjHmTqrWtxMnPKFp+eCt65VxvMBs1JlBsV8gIt8ZkvwvROI9JpqF08d7+Sx1X9QIjaZvpGnpxpN3rGsv1xgo+8XUXplFv8UAVoiB3o0kSm8yVoJC8Taw0pWduD8bapSh5i8boOL9Zt/ErwKj+rRbGGdoLyoQYiexLk1NyEJTH614w43G2WEbhQyAy4ZWti8EbGc3bjbY26Dz+I5ZfSSyTVNfxeuZBlGs9wDtX6sM75TqfXuHDLhIleW+bYUkVU96Uz1VIdZjNVKajNik573uqGeaMAEDwATMSicRRscJ+SbZlkII2gM1yEyE4lpW7Er14nNe0lBWWzB4ofWPVjRSUIA6aLqk4jLOvoFVL7CI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 10:50:19AM +0000, Lorenzo Stoakes (Oracle) wrote:
> Now we have helpers which test singular VMA flags - vma_flags_test() and
> vma_desc_test() - add a test to explicitly assert that these behave as
> expected.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

