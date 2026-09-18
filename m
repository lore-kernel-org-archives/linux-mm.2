Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E5B7C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 11:32:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977946B008A; Fri, 18 Sep 2026 07:32:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927AD6B008C; Fri, 18 Sep 2026 07:32:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EFDF6B009E; Fri, 18 Sep 2026 07:32:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5889E6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:32:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4C1CA60F8
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:32:06 +0000 (UTC)
X-FDA: 85226669052.01.36B617B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6F70140003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:32:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=msnhd0UY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NqStikK9;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JSEofGrj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6L1HpnEf;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789731125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16VPl1VnEWjYKKn2b0VatZqqKxwtk4sxaC4QgUhEMps=;
	b=HpdN2v+QQ/3z3RH1Kvnvk+1j93F9lo3YijeATGH8RTi2qVJp+zqSm6X9Av2EpculEY02VX
	mRokJrMq9vdChoW99AOLnDAVyBDa3PfHh0f51mD3moG6kmvumS6qrjuQluGD6JHr5OruIZ
	8JWxtfRa+BeYPnmjPbhios2P8nlILs8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789731125;
	b=p9E1TffNzeD/o7Y4DTyTKz1NoUIkXhp5Pt+hTnf5f0CR6HmWlQI+y8MdnTVjV5/rvmnhWO
	7KKGJLv1TgZjaMGgZBcyIp2VMia6eHLJaoTbKkDsOAp6PdbH67VUUlM4hLlYDjlTlMnAcM
	LzQcOQxvhig9lCbgQ33DXA4o8pOaQBE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=msnhd0UY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NqStikK9;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=JSEofGrj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6L1HpnEf;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0A2A11F750;
	Fri, 18 Sep 2026 11:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789731119; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=16VPl1VnEWjYKKn2b0VatZqqKxwtk4sxaC4QgUhEMps=;
	b=msnhd0UY7XBEygV4zpJsichyutt/FvkLNxgEaqVvEAaQXcsXno9pCujTVafi/y3lyO05Dh
	oS5/2ggGU2z7GO+Yof2bvqs6EaR0AKEqrcijU73wlSJoU3rMlYvf5lkPhS9iWwS3Z44L9x
	CPjGXgH04gxrYVKTUw/lJe8JH2zOnhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789731119;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=16VPl1VnEWjYKKn2b0VatZqqKxwtk4sxaC4QgUhEMps=;
	b=NqStikK9HHMaMzU7DdZCQp1NuHC0eodVh8h2ldxDgLs/oJJd3P97j2IlFNgj+lU50eeQL/
	/kLJKLw4mucl9TAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1789731115; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=16VPl1VnEWjYKKn2b0VatZqqKxwtk4sxaC4QgUhEMps=;
	b=JSEofGrj3K9xy5rBCGR9RM03EUSv9MIirWaPUIpsV/6o2Y1SsdnlZNBDJ2Eo4xvkV5qLFw
	3yfQ/t3DdCk2iEaj9LqCHJItMDbrQ1KQGOdSe1rKt62d0LR9eGQi1ZHDIYZ+tAaVlvgg3C
	Uabfd84mA9jNlMFcxmBzl2thku7n9dk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1789731115;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=16VPl1VnEWjYKKn2b0VatZqqKxwtk4sxaC4QgUhEMps=;
	b=6L1HpnEfyUGSKDuZfIBN9LnhkSHDYxk3ds3mBJ2Tt9oF/tcDxaw+DLCa8E1rc44JodXLgY
	3axm0IQ24XIzPbBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6E45F133CF;
	Fri, 18 Sep 2026 11:31:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id k0nRDighrWpEQAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 18 Sep 2026 11:31:52 +0000
Date: Fri, 18 Sep 2026 12:31:50 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: update comments to refer to anon rmap rather
 than anon_vma
Message-ID: <aq0dInU5aaJN_eMa@pedro-suse.lan>
References: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
 <20260917-vma-is-faulted-v3-3-5c22314a72e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-vma-is-faulted-v3-3-5c22314a72e7@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D6F70140003
X-Stat-Signature: j37ds443hochdpfxjqcdnjgmft4qzsp6
X-HE-Tag: 1789731124-645055
X-HE-Meta: U2FsdGVkX19OUxPUAOzVoXBU6LES7vJpwXa9MFKXfkdWn6fGUQUKPzOWSBN1Ovyl4fL35yoJ7qrR6Z9vAK+oSIn4dzHKxx1m/nj0hmKaAdWvl1pndA61Ajb2n6+p9+E79ip/iHL3Lx68ewCASfXVPHisM9LdqtHBqP31MFLyAJIJKrQ+CwZrC1g7XWysuvW9qop3276d58wVP4L3brBpp3g78hYoqLvsa4z5/zRWzu8YtOL/JTCWsLSAHWBJZ7hfbmrEP1n3EqjXtBcxeztpK1el5rLwoeZkDt7MPDinZcVhPDyYGUNilev0QFKQjk4UoQF2cewTfIP/7bXLOAdpfuFl7Lpg7hsz67VPrXAUXj0FihajyNPm6Mq/vyGr6fvRm53elUa9A3Brn7fNZ45h1EmbaLULxsvkczWFQwHzQ0UKB2maH1ExqdvPaKsxl0nAaJPoA12xv43tj4dUW+0J79+cNZNUwkAdxuFngC46EVCMtW6GGMZS3zWP2DAQvjeXhncOoCklQnsnIMdnKqRB9GF8XNpWA8dWV2NXnrwJN5XW9aMa6N4dwHSChMWSBBi60olqH4A9hiGFm0IcZvCT9k75xPNUHZVRgzW4FQs52K9GH6VmR08ftDQy5IKrziGjikuYT9OmrcUu7Vc82y+1lvriyR4S1HBRvDpw8EAiUq1QDdf3KBUt6k/Hvyw7WTJsAAzrqEf0ifrnEb/HalUxky1eV6V/83lLJUusw6q86P0XzJosJhFrNfEc74cEXiCp0mQYYze5Se1KQ3DQ3iYKTo823oICS2JDtUXMgYV/VmK6aj0wnI2cpEzDvgIotUebP39xZhPdDt0Y48sg1vRXPNTV74b5QMlHEja2wisqYWj9IOIPIM2WLsXQt5ACLwX83M7iLt5PN2ybtxJqBTR2yrqdDfiouWW4S3B4W2mkXoNFZZgihn1r2VWGqfvbGo1KrhLXY5RYC3Z6v4bJvOZ
 PLA3ylFR
 eIl/wlBt5iOivsiccpfJcOFuUbOLjgArhbx8u6nWUYtk117n/qDMuZnBi7WQxv71eG9B68Dkx7+3fkd6rXDo/IguhRrCozxjpX9tEiE+xHy6UggLdN/LPTBzpUuu9qxEIKEEQSG2B8hoYI/zisa5n5ng9Q4SrmwZM4zPlhrOm8G7QyQF39ol9AAMTk2qU84SCrpOLzRQAQV1VV6Yg2k3jj8YZXF220XzmpbOMGwxFrQE/Fqvv3hY5dkZFizH++fTUfKreBZMbd37vtSDUH2JI1HlCi7kelsAPZVXV7aylK2IxBPZEDbU+7LQcBfaI9IFRCq/1bbh6RYnt6N2ACaS2ZXX0vj14Jbv6k326wo1RFxEY0EYqRFVglpJwsKIy8IWcwZTiiLhSPAqrajVQ//LscpAXGSdyM+QtzJWv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 08:47:43PM +0100, Lorenzo Stoakes (ARM) wrote:
> Now that vma_has_anon_rmap() abstracts whether a VMA has an anonymous
> reverse mapping, remove references to anon_vma and instead reference the
> anon rmap.

Hmm, I guess this is where we figure out if "drop the anon rmap" or "insert the
anon rmap" or "iterate anon rmaps" makes sense, language wise.

Wouldn't the rmap be the map itself (e.g the current cursed
anon-vma-anon-vma-chain structure, or in the Glorious Future your remap
tracking tree)?


> 
> The anon_vma is an implementation detail and should be treated as such.
> 
> Do not update mm/rmap.c which implements the anon_vma mechanism as it is
> reasonable to directly reference it there.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Anyway, you're the native speaker here, so I'll let you decide:

Acked-by: Pedro Falcato <pfalcato@suse.de>

Thank you for the series!

-- 
Pedro

