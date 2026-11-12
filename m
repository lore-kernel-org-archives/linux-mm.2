Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8E73606A880
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=cpLtdDDm;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SDOOkIMu;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=cpLtdDDm;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SDOOkIMu
Received: by kanga.kvack.org (Postfix)
	id DA4686B05C8; Thu, 12 Nov 2026 07:28:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7C2C6B05D4; Thu, 12 Nov 2026 07:28:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C926B6B05D5; Thu, 12 Nov 2026 07:28:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0C156B05C8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:28:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48A2BA813F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:28:58 +0000 (UTC)
X-FDA: 85426396356.29.B83A2D1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 300CF180003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:28:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cpLtdDDm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SDOOkIMu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cpLtdDDm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SDOOkIMu;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794486536;
	b=NoDjdexuu6LjubAd5fB+86WLPVVARV6TzU5o+YAT4dY4jpLIk4tDI8FPzXkPysjfjmqoHP
	sZZsDH9+f4oK61MZ5A0AekUcih9hZh9wAIiOwXtJVKHGHBiR8z90F1+LTcgZ8FJsBfnVMp
	qwoU0+NS+NCxI1irJkNIP56UKjm6G+A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794486536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qGWIy9jrwH5t2YwM/1gqH/yjp5nXKZYTPr3EnVErx6Q=;
	b=xMPMSDwft0hnm2mppBIXWi4lzQ8V6KxA3r5YZ0p3Fq0Tttel80RlBmx7rG4P47M633R8Z/
	j+s9UIeJFtIj4fHnGiIDfmd7SGt8LVf9Q9AwJML9ISkJLqmToNgjDSdJcdqu7xwNk/VZSG
	YEySFL6xK8lBXYKtWMrl3MzdxV8ea0w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cpLtdDDm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SDOOkIMu;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cpLtdDDm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SDOOkIMu;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf06.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BDD531F388;
	Thu, 12 Nov 2026 12:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794486534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGWIy9jrwH5t2YwM/1gqH/yjp5nXKZYTPr3EnVErx6Q=;
	b=cpLtdDDmyE3zufzafwIxz2avs3IEH+P9VxuhjgmnooAzAhIFht1q11S8RNbPG+tWFkMs1X
	p0Yo8uTA5MjM0fcTXKw7hJYRXDHwxC8SZYUWXtZ/FGR9IUBlBe0eO0FIyNdU5n9bSJnB8e
	OMosXMbCLf0WBdQvC+SSCCoa7y9jJuI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794486534;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGWIy9jrwH5t2YwM/1gqH/yjp5nXKZYTPr3EnVErx6Q=;
	b=SDOOkIMuS+3Vq06vEb82CmSuINp9k+XDhDTnLMbqnXQzXgjOB+7GC+fw9pvWIgwKVdQwxq
	/vQYWUOBmpmHVABQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794486534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGWIy9jrwH5t2YwM/1gqH/yjp5nXKZYTPr3EnVErx6Q=;
	b=cpLtdDDmyE3zufzafwIxz2avs3IEH+P9VxuhjgmnooAzAhIFht1q11S8RNbPG+tWFkMs1X
	p0Yo8uTA5MjM0fcTXKw7hJYRXDHwxC8SZYUWXtZ/FGR9IUBlBe0eO0FIyNdU5n9bSJnB8e
	OMosXMbCLf0WBdQvC+SSCCoa7y9jJuI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794486534;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qGWIy9jrwH5t2YwM/1gqH/yjp5nXKZYTPr3EnVErx6Q=;
	b=SDOOkIMuS+3Vq06vEb82CmSuINp9k+XDhDTnLMbqnXQzXgjOB+7GC+fw9pvWIgwKVdQwxq
	/vQYWUOBmpmHVABQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2AC1C13432;
	Thu, 12 Nov 2026 12:28:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lxSfOgOx9Wo5RAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 12:28:52 +0000
Date: Thu, 12 Nov 2026 12:28:50 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
Message-ID: <avWw2I3Or0z1OmqE@pedro-suse.tail5790ac.ts.net>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
 <avWgulaWoKBfIFlo@pedro-suse.tail5790ac.ts.net>
 <avWtxdIHSJJ_uNwG@gremlin>
 <avWunRPQJQctsvYl@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avWunRPQJQctsvYl@gremlin>
X-Spam-Score: -11.80
X-Spam-Level: 
X-Rspamd-Queue-Id: 300CF180003
X-Rspamd-Server: rspam12
X-Stat-Signature: 56ntrtf1iifqwuo9w4r5jsyprhexq15i
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794486536-894263
X-HE-Meta: U2FsdGVkX19DDlFSXIFRAEZlW4VPT+Ptb8iWSF4tcXUKjGXBc+4GEN3kfZmjcAt/CATW+gmZ1AGGVOSOTT+HvC8mzrJau6TDR9TJnCV7jMVcyU9+9FbhnolJ9LDIsfXDSBcQ+5Xmq9D+5uKNKMZTsnYRYNUv4y4tCMpmp2dVxadBkf/9PYCg+335yX7erhJGNOCYBV4lhgDiU5mLu37ddY9sAElCdMjwttb/jBX5msNqhn4Xh7m874l89vpHjMno8AOy/lwd81LSxX2S0oLJVPCHu/Zyc0LIqdH/W3JudY/zgHArAlJX2xc+YCPjj/DUCfvgcIrYYwdUHLlGByWLgaK7RcxDWEa+gEY9tEumJJX3rBFzk7bFpqLY2Pm7Cp//O+X0WBiiqbBRDtQeW8mpnZcLETnPnLCCyFxKh8GyOIMDkv6jit9KsulRmvFKpHt2zSQURK8K29M3tQeIGBVwNnA5Ko4GYP5JLUGyzQQxjzrE6QDqlagLjkFMhB1bH1N6DdWcViiICZPpVNALjkd2z/QcbqvpwEMsRcC6HxDriAMFtf9khrc334pgv8xlSe455Mc5p2G9cGZsRlbVMEArYXt3d1byIttQriOtceOJXEbw77ro0WRaErFxfLTegtt9lKEyH3hHWJmwPgsK9m2DXfP0X8lqEp0/u6LZ32DeYjnmpCSQsmrpGLyH1cBq0Nnep8SUjGnnd8WwZukngOf1WXT4KIWJRc7LKvH8Elgb6FqAjZkHCD2AimcHlQaC630P6tuhnEsTm4XQHeWvs+IC3FQdKBgxBNAdm7yqJ/H0qhrZ2zxyKACPvoqQkS6ZIxF9BKphV5SbYJi+emJALm2lc335XQ3V6DYVfUhtowHnI56sZq5hLFNhycA/jLVQkdDeoP95xhWLRHgbuCyjfTZBzd0bMwkin7gr2IGp4ILSVy6YEPWBTgmw9+ErDypks8+S0/AUvgpKw5CX5r+2wdU
 GIGIo/nR
 IlILXvpyF6II12mFB+ToIlXtsiFEWzvoNB+QclvUiPWbV4BEkQuPOxNDFklQiCm57sNF5cGS5QuAEvFgoic9fivvy4U/ISN80BQ382cOs9KD8y81Axc3xuOrufcQtMID5AZ7UWkyrn6xTd1vkHo5vtPJxgb1giG+UnTKY0r4xhLIMcAUlZ/HkwrwmcWWBIFpRcJCOtRo4lrL3vChdCwILZUjTMtbBJ1KGPDQdS5Qvmz6vXe5MTeW9oSowLaKrcS6SDBhRi9KkOmUqKExTEtS+JvoromH0vlLM7BY7gNYhI24jtr2iFkJ23z77kkRCcPDR2lcXSorp1g2FPXzGfPK6cPz2i21k+kYbJOxmfop6ocyo6ugYUvl3XDblOHa63jYpyxh85natHqQusJhheCgv7STtL8lkJTEDXRooERd6EjOm/DbvfiQ/pTf4fpMrjjpVpf4UhS3PGbx7WC68Z2DKjXP10GEhK/KkWrObPxooZJ6iMLDoV2bncDAink+ZEBZPEK4Ne2dCDyTN8JPGiJb7q+LoenaiSnTYvrkb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:18:46PM +0000, Lorenzo Stoakes (ARM) wrote:
> On Thu, Nov 12, 2026 at 12:17:21PM +0000, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Nov 12, 2026 at 11:21:38AM +0000, Pedro Falcato wrote:
> > > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> >
> > Thanks!
> >
> > > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > > index 7618e72766a5..4cb18b217048 100644
> > > > --- a/mm/mmap.c
> > > > +++ b/mm/mmap.c
> > > > @@ -1313,11 +1313,18 @@ void exit_mmap(struct mm_struct *mm)
> > [ ... ]
> > > > +	if (mm_is_oom_victim(mm))
> > > > +		tlb_flush_mmu(&tlb);
> > >
> > > I see there's a different tlb_flush_mmu() call below (in the actual function).
> > > Is tlb_flush_mmu() idempotent?
> >
> > No, tlb_flush_mmu() is cromulent.

Naturally.

> 
> (kidding, yes it's idempotent :P)

Great! Thanks for the cromulent reply.

-- 
Pedro

