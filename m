Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 686ED606A338
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dymmx6qI
Received: by kanga.kvack.org (Postfix)
	id 09D576B00EF; Sun, 22 Nov 2026 10:45:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075596B05B0; Sun, 22 Nov 2026 10:45:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA7056B05C2; Sun, 22 Nov 2026 10:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA8CB6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 57A2F1206DE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:44 +0000 (UTC)
X-FDA: 85463180208.25.5E74D03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 963B88000B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:45:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dymmx6qI;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362342;
	b=fdigX1Z6pc30hRCt/FZCR2xggPqlG5blaSQ8Ptdn6txKdrdhvFTRIlNUHFWvfJE2/hjCdd
	k9hnP6ex7tedqhS81Whoxnm8ogm/i9NTdqWpzPESO6mKZUF5dPm2Kna1UAGKiNtQjU/v8g
	wzqp2M6OrQizn55rEa3mC1Hp7g7cnFY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qP2i0fv4WE8/ipxTLPLincxefCJhx+1CzzN1jBqfoUY=;
	b=dPtZBBfqtHB5NsSlDYazLdyC8KouBxcSrryIHRF+ZQMwHhT/N3kXOYcDGViKJaw6o8lI/q
	eTxxCRoCfSC2tXF6Iw9R/rLkuZjinHmCSXdcvqGRUwG0AjGZCrelRGTahmOt2sduSk4DCo
	nH7OwrMqEsz0pCsin3axhIdGicfyjgs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dymmx6qI;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E50244408A;
	Sun, 22 Nov 2026 15:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6E91F000E6;
	Sun, 22 Nov 2026 15:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795362341;
	bh=qP2i0fv4WE8/ipxTLPLincxefCJhx+1CzzN1jBqfoUY=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=dymmx6qIIpA3rlijmZ/+JB+sfVuETUqDVF91cVYW3+atJAQgn9IWkFqJWFIDoPAcw
	 lnDt1wq+OtDCkmNG6BT1XPW3EBXuxEosPxQhfsGgZkagI/71TVNv+OHoKreroCp+qV
	 iP71Zn/rjZzsKOK+5Qj5FXk36hKRXr2dzjXlVzNbWlG5kE86baxHH4UERvEJNtWGds
	 30JK790FV8zUyTGMCKghisnBysakrG2jOlY9FcF1p72mPe7GrJNcr7itE11Gc6PUQV
	 A2eS4pwlrmdEXtcSN8JLsZfyeYr4ekr1AuobWKdAIaMg2U0GsXyNE+xeXTz/Qirt0u
	 uR3xsLcloIBtg==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 08/11] mm/mm_init: make __init_single_page() static
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261120100856.16929-9-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-9-songmuchun@bytedance.com>
Date: Sun, 22 Nov 2026 17:45:01 +0200
Message-Id: <179536230138.3933282.3756742305375299607.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 963B88000B
X-Stat-Signature: 55wgapx6snsiyqaeawp45wict9mzccru
X-Rspam-User:
X-HE-Tag: 1795362342-522444
X-HE-Meta: U2FsdGVkX18h+3sdb5uNFaYCs9V8g72/IagVPKIzITWRCbMDLbmW2IHnN/ipU5RN5L3y2TgynGXP977oQp8BXdeNAtHzFsMBkMFDAYc2RiosMNM7rHqba3f+AnDvPCsauSy6ErROuWCymEnWTLYAb1qFZoTxxFeylWxbRNAXSCszSkW8g+49hC5Mrr71GjixV0jFxtmSUO7acP3Ev/v2dv3fLOgn7fRm0bs6BsWglNKDHu9FqaP/eyoFT/OHZCl2rSkFE4NRnKZ2GzDv+28H45d2zljPiV5Q9TDvp1asKk7OS7Rpdp1EVfzmhcjV3kJa9ptxB5VI57II/oLVUslShjivhhlWdKtk2lCG5w7NfC9k28MPuIaPAlJp7NTP/8uf2NDjx+kBbtISwM4vJ2GlM7oYtVXketBP29iAWHEAmfnaByhxTrPLUEFP+UTsNOvPEq1FzPLscTUx1ktHggoFYGLNjO5MMMeP8VQBQ3Q/+rb/yglE3IxRlwtH2UtAyG/gIQ6DnQbvmsKsxRouDwWnNBB6FFUzsbNKhqjYnBpiG42RDnu8s7xrTb3+zu8gXxrxu3tEm8O4i+N7oA9eL9phhZD5a87AIcY8tiT9iYTxaicAlNHB9UwaVHUpabkmygvWVeMhomyVr8eOae6/iUzGOm04pUl3kIIfMc+BcEX0AexHEJrJFGCoF8/F5cmWo4VKyT3Kv543IcTEdEaJC9+qQVD5OlLOutYUjC8bNh3Y8L5aPsn8J7zO7GHw9H10LcOqzlbFqqdh+9NYoMIQ5CrrmrScLur0pw6iYCdmOqd0prZEnPdXaax/iwLld8n7oAjoLfKnvlAHuF2gCwvotDklzvV8WuGo7rpX9kYsVBB/o/TCghcuHLKPXytPkc3nM0haBV6WyoykMPaq7RTYn/a0BVgijCxHfnMKxxeq/7ZAXTrnHnF98DtiRzs+icMiZGcfGDqgzDiXi24QM8zlSKP
 1YAhde0R
 dofSevhkSOuJuyS4IyVSwGyxe45o4R+zVDiBw6SNMnl+Son0tpSulN08OBut1WUkfDt2p+smMuCNBobNorOkJY7+HQ2PfUI+r3WWSgA7dTTYDWeoVe9elRyG82SW4Nl65sxGxgj8TjSukDe2uLHrPw5rAkO4LmRTbtUntVJbzW7LrMtVF4fauRfm+rBi+8BwinklAEa4vpjLsnF99b2HMP6vpOpm+hyvYkLuCSxvGZvI+caOZ70aBPv4brp+JffUVr3BEoxrNQ8PaypzXk5UBDuRQFXqCLBz48UirGtwD/eo9yx3v+RWV9BzhToQaPWRP/+hWAm+kG03o03FJ8eVTc9TfBjvueBwaEjEmvTHQQBWiaVeBRomphcbgHFTXnHr/EXYdW+xJtWvonSdupxJPJHX18fIDKprMLisk9DeHi3r0C8mdzBnDlZkaiKbFo9RccgW2IQpm18oLTGPqtFzT7dhIOFFNMERUKlqxka5i9cBD3B5ULyEqnNpIDXiu+0fA0gx3Tssx/IdOkTZASk1EYx5L0DKuf7bnCrwLdxl4nvszwnITk4psZVYq3Cry1iAzVQMo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 18:08:53 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> __init_single_page() is only used within mm/mm_init.c, so make it
> static.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


