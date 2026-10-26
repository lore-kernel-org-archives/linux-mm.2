Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8198B606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uy4OF1Z8
Received: by kanga.kvack.org (Postfix)
	id AB2C56B05B7; Mon, 26 Oct 2026 11:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89D16B05B8; Mon, 26 Oct 2026 11:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7046B05C3; Mon, 26 Oct 2026 11:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 784146B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:56:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20BB1A83EC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:56:40 +0000 (UTC)
X-FDA: 85365230160.15.4E69679
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 47DC68000C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:56:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uy4OF1Z8;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793030198;
	b=akRY0lar0ux9sKIU32yIUH/WCb6Ods0JJan98FeG1Tbc0TCNk7vnPwX73WLoMDStiuaiUz
	PoJXkSkoqayFVykhN/1QkMbSyweG6gSL6jqTR9fa084T70c+hSlpzBLVnPXmmVKahg1R7k
	t1CqyHi/9GS1nwK5SMJVRtswqyYw+yI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uy4OF1Z8;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793030198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YIwg1aJhq4WGjRolwPANaDv/TOTLrhkHYOeCEH41Oc=;
	b=aN/gIFHyQcS6ZFunBV95SNfIdzrGbDNfyYdtvN1zrCHjtLns766wfNXXme8eiABr9B6HY3
	QejhUN0v0+4/pD4UCpkl08Zpu3JpLnk1prcxQvR5y74yRqarJZBgYRvfPY0ooHJy35BnDJ
	ItEW48NfsEMlazLWHn5+hR8Yt+Mlz7Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DBCC437F9;
	Mon, 26 Oct 2026 15:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3F61F01828;
	Mon, 26 Oct 2026 15:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793030197;
	bh=6YIwg1aJhq4WGjRolwPANaDv/TOTLrhkHYOeCEH41Oc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uy4OF1Z8nc+aGLqmD0I6DdudJyArIB6exyFC9Kl8vVB86ytNblhhLlaRS3H9itES1
	 9GSQ+zpQxO2RAMQqg9+pWfk20mfy7l2rhyePnD0MgUP9jfo3hJdBkyl6hnzOUs61Vz
	 6XawunPDVCOwoHA/PfrzK75cEhkN0H08rPz7eC9c=
Date: Mon, 26 Oct 2026 08:56:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, "Liam R. Howlett"
 <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
Message-Id: <20261026085636.4cc194fdd7aad8e7d3e68c4e@linux-foundation.org>
In-Reply-To: <44405019-7494-446a-86b4-05b2ac03f768@kernel.org>
References: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
	<533c4ef7-e008-4439-be40-1aa2a074dfd8@gmail.com>
	<44405019-7494-446a-86b4-05b2ac03f768@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 47DC68000C
X-Stat-Signature: fhehsoqso5szaj1qzrdgqz5qsudeb8au
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793030198-796800
X-HE-Meta: U2FsdGVkX181iX9EtfnBw0IDuV+BdZqiVhwF4o6JS952h48rXsRtvb27pkKymHng/qDOjYfYIKiZnq4il8mSMAUKy7bU8iwOmcIbLhun95yp3vt+qIVXErUdBuCKpwg5cC6hGh9ENPRuvqpG1t5S+4Yz0ymR4J0Zw2vyW1ppnjWEVPN67NKUodd8T7D0T9aG4sTqFAHNdEkxIpyBCAJDcmf59bqA1gd50meGa7yF2Af/DaT5XYAVOoQUIzOgD0Du85U7LH7LOcD/HKqHRJiLGZJFTw0qK2g75eSn7zL58iSQ6f9GP5mfhxTwQeveYlRnHrE1UePdIO1wGMX/5A9DVSC7bIgRNaLh4+iNGux+W4b6L5khgIuOblQn89de32BHvYvXPMYf4JZzOe7eZvL2M9LuOwveswFDROqn1Lsye+57bNaxci4YyTUG5RZTD3blIcIv6SSu+y4nfcHiHTV4FRb/+7XXXwtr/B+BOhpbq5A6uwhYBX6eIcvCgaDoxj8U3O46nP44lCD6Cj7YZ6PvdPfVEuo/EN2DacjvQ1nJ6PC0Risz7/3bPdIgyczNXm+IilV90cpjnSkcVsaswXne/TIpq6P1/79qUnL8NQSB7Hj2uZ59Q0l96qim3d5YPyZDgnVDGIzkIEjsMHMnfaSdnRZgLpvQcVxwzLf0GkDwqgQ+Xo0eIbxmHlcGDfSEqOhkcr27yVOiIOTutaeKhFFCGFOkR6dcvVm3aq6B69Jlr3Kn+/OgWtWpHP7MInRsEoq2xugIBqk+GbG7BQiP+Qo1spyPmZztNMuKut86Y6NP5RqJuY4ybgPlD49k0wcgs3a2cqwCeXIJyCHPxtZB3mY+YJrVddOgup1Rdi8FPx1/pvfNeJhSH1fK49AC/b0FtT0BAv815wWxcEqtQxAoenvayqWxJxRDR9m0XeI6k2QVYbKbZCrTAemEH4vFdZKPgPhdyWYqJIDR1YdnoM8IYWY
 YssznMeZ
 OKN7R4dPhTYyOaPqQSs8Trtg690Xv0/VSYulJo54Y/McMlEUuwh5QwN0FP5e2J/jYguyxLsZnNbEa4gJ+Rnm9x6don5yYI9k90hMbeEpGjuM0z6b9sONn8D7zhcx7ZY5SX6j6XubAn141IER2NPrwTKdI16adng+BTLsNKHYiAPoXebA5K5CZ7l+/zZtvmcTHhA1tOObt2A5RQMeE8E7GRe6vkRLxX3SeftHflfqdQ+tvjWYWJigzOxVS3ym1CUPaNqcjmsUzJc01rmrclOotI0FlyYSXLSzc7So2vKfekajU3UPmd/Qe5Simisi2US9u0Yly
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 11:04:23 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > 
> > PROCMAP_QUERY does the same fresh lookup, shouldn't d9d1c2d81797
> > ("fs/proc/task_mmu: execute PROCMAP_QUERY ioctl under per-vma locks") be
> > here as well? (commit tracked down by an LLM)
> 
> Hm, very likely I missed that. So yeah, let's just add it. I assume it won't
> matter much because 5631da56c9a8 is the oldest one either way.

I made that change to the mm.git copy of this patch.

