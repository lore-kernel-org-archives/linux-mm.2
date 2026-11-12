Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02910606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gWmPDlF1
Received: by kanga.kvack.org (Postfix)
	id E70296B05D6; Thu, 12 Nov 2026 14:15:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20116B05D8; Thu, 12 Nov 2026 14:15:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D10906B05D9; Thu, 12 Nov 2026 14:15:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC7F26B05D6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:15:22 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45124140CE7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:15:22 +0000 (UTC)
X-FDA: 85427420484.26.74D2A0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8C0124000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:15:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWmPDlF1;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510920;
	b=gMpyuqtVLoBIJNdOkxN4pfzuMAI2c977jrf3wfhdhoZ3dTRj7VvV8MEkG0HRi5z/rbNGyf
	aAGwWus7RVWaO8TTiZra4SLQmIa5LCQ2Ka0UvYZO4HDUPV1vWTeie35ftuQxODC35tecje
	TnGkkTJMjMK5ifLeTaPbh06pYUEuaO8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gWmPDlF1;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQqZHDN7sbU6LhPjRDha9kLuoQ88Z7yb10zf83LJBxI=;
	b=48ksxUdSVnBg0IwN6jcqvx9AVZ8Ix/an97EqJWHwQTxUIOIA134JOzXCzZthUJCoQWSqLX
	rH8wMe/3GMx+tZx2cQA1xRBwlrWSBpy9KLTwI5eRGnXS6PWg1tyTe8kk3rlHUNTFWzQ5x7
	AiuPJS0sbrFR9I2qGGRGOc2AWf8cqPI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCEDA43967;
	Thu, 12 Nov 2026 19:15:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B7C1F000C4;
	Thu, 12 Nov 2026 19:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510919;
	bh=uQqZHDN7sbU6LhPjRDha9kLuoQ88Z7yb10zf83LJBxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gWmPDlF1val16ZjKXedNPnCxMzpzAng/zfovWxeBLCayEGTOGGXxVM6X+Ll7q97eg
	 cWVNr3znfkJuOln7L/5gSTA1SbO4ytS64tzUhmAFsXyS6DcbR66XqNdKczjDkGNKcV
	 LsJfrOMF+q1iPixZLl0yJ1oGedZkvah1XfhqyteTfwr5QdwGSGYoGdrsiTK/fg31og
	 6TWHhiHZ/Iv5HKOGDXpsqgIQQPVU+vS0KWntCndnK/xtEdHSdGVMARu9P8h7MLfW6B
	 UbKMvS0IUQykAIChWVCk3U2V7NP9+NERWtYKYQvaYUAmPJOBKSwc3aHEayKyv28ONs
	 mwbyYy33ozMew==
Date: Thu, 12 Nov 2026 19:15:07 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Balbir Singh <balbirs@nvidia.com>, =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
	Mark Brown <broonie@kernel.org>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
Message-ID: <avYQAYzkmS9Z8mcZ@gremlin>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
 <179450279073.482102.1691484916250559829.b4-reply@b4>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179450279073.482102.1691484916250559829.b4-reply@b4>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8C0124000C
X-Stat-Signature: 566ex34phejaasa73e6je8tg4a79nj9s
X-Rspam-User: 
X-HE-Tag: 1794510920-82480
X-HE-Meta: U2FsdGVkX1/rjewCWS04hNZ8HReabpw2enof64pempMHsN5nC92Rl76Tk0krEGSvjCYEXkpK4ctIo8RSWQN+YZeU9+7uuc611Dj+L9QLRAhkTNkG/XFXnua/dW65IPWbDKdWb15d5ri6d4oNGwfxTqyu7pCQXaKNtSWhdwF/ZhCpzVObxY/2EmoU1/CgobuijqkcnYtURjYCiJSkbudDcUqkMaQxoXNnHrOqkFiYhF0HSJtD43Qw224NahNpfoRhUBm2BBsNLKUn9WAcoZCwj8B76eMTFDCLXNKIJ2K67V3RNUMuXuiA0MBI3br+XXCy/64NBZUm+HgxtT95Bug2LvdIE/yrrD0TRqUEf/fA9rvWuCytDndKnqjDxy59Vsd6Zntb5TuptcX7aZbv8VvCZVecBZl4wx4TJ/YL/3awReWxyLCQXoVRcK6RRDt1O21FawbzmlJO9Zm8qkx3cRqY6+l8tVZZbgNbLFKMbjtRliaj9fylYq4/nSkReeghj4WapxCeX3wwyfgqm5lNgxs76OCEhvHEK4JKsqBBW1uTALkM5HGvqpsa4GcnGtdtq1n/zAuZACTSXYigWkz/1carFRvE4xtKR6HsDz+nilgT5V9wO2qUXG2FUC4wzPi4PXo2UtPjL3ZCSkSuI+bVMBpAzFXT+u7S8RJRc/oY5nES31S6JcFenfIBR/GiToUg0D9vndLh5C8jK98Ij9+QuQJIcoWaHZkIwADQi40iq1j++DFSDH61MqhOtGso2V54GECKbHrwkfrEJpV68bgY4oSvBxNxWrMn5VS5qsB3fsJTMCnFXSPlFJ6nkKWSnafAJ274tyvjahJywBsdOQwkM9vGCVDWotjitTr7tjQ3Ue60ptJl9Qi7ZuXLgIk9jkax8wQBsh1lN+wrlFQhzoFM3st1BIHM0Ti+laHGIRssMBQ4jEVpTI8sPI3fwBTCTTNdoLMQd51tIUZA0MvVG//RR9m
 kmBKWKBS
 dALs0HBj4ZIREiOTI+hxRMsDhc3KL61PkDUZHXcEPbKSaAy2QpxpBHC+4fNIsgoXhJcRHPpeOr0smC4R7lOuKChBqjYnM4h0xKJTfXnade8lpYPJgXGc5ZlSp9abZYbvQCcvvAKORxCJcLfWoMQYECDaFf6pVKQFIpMvjWmHTCoiPTlDJuA7O9fvT3EIMGdl9Gor3TaPaKdvT5aZ9pPy//lTfxp2mefukOF6xaMjn4PRBdpcqnQKU7oiZzkaW4b3kz9MRfuM43v1lnt9ILWkS1nplzkC4XjxRwk0qzrUGW+U/0pBju7Q6Qt0Z+vZ/KibzroCru227J08tlsZKb9cRfmpGDPjohn0OTkzJVYsBmaHQftedyeAB1GRNOhI5YGJP4jGtPVszBwSfcP9Xeza6RuBss1INT8NWYlmxt0NSB4pgzAtUNW0Wk4SZoWP2AdpoAWzQfU65cQVQNc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:59:50AM -0500, Gregory Price (Meta) wrote:
> On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> > The OOM killer can quickly trigger again after having selected a
> > victim. That victim might not have freed its memory yet, but its mm will
> > be marked MMF_OOM_SKIP by this point, so the OOM killer will ignore it.
> >
> > This can cause the OOM killer to kill an innocent process when the first
> > might have freed enough memory to relieve the memory pressure.
> >
> > Fix the issue by freeing the memory before marking the mm MMF_OOM_SKIP.
> >
> > Note that the task which calls mmput() might not be the victim - if it
> > took a reference on the mm (e.g. ptrace), it may hold the last reference
> > and release it when it calls mmput().
> >
> > Therefore we cannot rely on current to tell whether the mm belongs to an
> > OOM victim. Instead, partially revert commit b3541d912a84 ("mm: delete
> > unused MMF_OOM_VICTIM flag") to reinstate MMF_OOM_VICTIM, which
> > mark_oom_victim() sets on the victim's mm, and check that.
> >
> > Reported-by: Chris Mason <mason@kernel.org>
> > Fixes: bf3980c85212 ("mm: drop oom code from exit_mmap")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> I was able to reproduce/observe the unfreed batch and the second victim
> issue.  In the base series i could kill a second victim with the
> in-flight oom in about 26/512 attempts, and 0/512 attempts with this
> patch.

This sounds a little like an episode of Dexter but thanks :))

>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>

Appreciated!

--
Cheers, Lorenzo

