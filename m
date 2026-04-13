Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE2A7EBFD18
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 08:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0760F6B0092; Mon, 13 Apr 2026 04:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D286B0093; Mon, 13 Apr 2026 04:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7F846B0095; Mon, 13 Apr 2026 04:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D68F26B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 04:46:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6EB945D210
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:46:46 +0000 (UTC)
X-FDA: 84652902012.13.1F8BE08
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id E71D5180002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:46:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3JH9s5Uf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="k/eGmCKT";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3JH9s5Uf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="k/eGmCKT";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776070004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5agqwrJT2AkhcCX6tI8RQWaticWktVRky7unduqbP58=;
	b=FcqcL7ILswGM0y69aPQZwGNn/1zo+QuGdsG+TaZN1i2JuSq3YMg3Gwlq0V9m6ISL97GIpI
	rJL42Y2bw5Xb7zOOkizFQrgKqick4hm/wC9v2q5hcKMExpcvW+ymhUpr7KUc8egsUHUETb
	pJZsaBy/aVpA8zouy8A0GkqLyGum8qk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776070004; a=rsa-sha256;
	cv=none;
	b=cDorhtrtsuj7sVKBGHMhphIgxTq54TJC1ig4Ebd0NEhpyBevTvx1c1uNGUpseNLxGQhFYZ
	7vF27t8stZEWYWVUnJ+YA4FqHPJQf045SBqn3bNub+yipejxmRE37GlXYmudz5Fpn+XoW1
	5JNuNfYiwUgt7xuKewt7Ue5O3vA7yS8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3JH9s5Uf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="k/eGmCKT";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=3JH9s5Uf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="k/eGmCKT";
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3C37E6A891;
	Mon, 13 Apr 2026 08:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776070002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5agqwrJT2AkhcCX6tI8RQWaticWktVRky7unduqbP58=;
	b=3JH9s5UfURzKVTl6JkyrKDL6Fj9s3sYm6bRkyrbQ6jONbBGSq2wYSokinRtQCmRNqWikSZ
	FsK3aL6TsShrp1ieISWoNir+3MD3AHMF0QS+DjKGRvcaRcDIKe3+r4dWwYKkfRO6bgSU+h
	ynAsWUV2hG7AYPHWK8huGRjwuKGFww0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776070002;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5agqwrJT2AkhcCX6tI8RQWaticWktVRky7unduqbP58=;
	b=k/eGmCKTIf/+JW5VCdKBK8iwb2TpQ7FweWl5lf8TaL7wlKJF1pGYslVij2+QvOMfkuFi9f
	96PwGwKsvh+OJ0Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776070002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5agqwrJT2AkhcCX6tI8RQWaticWktVRky7unduqbP58=;
	b=3JH9s5UfURzKVTl6JkyrKDL6Fj9s3sYm6bRkyrbQ6jONbBGSq2wYSokinRtQCmRNqWikSZ
	FsK3aL6TsShrp1ieISWoNir+3MD3AHMF0QS+DjKGRvcaRcDIKe3+r4dWwYKkfRO6bgSU+h
	ynAsWUV2hG7AYPHWK8huGRjwuKGFww0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776070002;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5agqwrJT2AkhcCX6tI8RQWaticWktVRky7unduqbP58=;
	b=k/eGmCKTIf/+JW5VCdKBK8iwb2TpQ7FweWl5lf8TaL7wlKJF1pGYslVij2+QvOMfkuFi9f
	96PwGwKsvh+OJ0Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E97C4ADCB;
	Mon, 13 Apr 2026 08:46:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3htaC3Kt3Gn8IQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Apr 2026 08:46:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E5C64A0AFF; Mon, 13 Apr 2026 10:46:37 +0200 (CEST)
Date: Mon, 13 Apr 2026 10:46:37 +0200
From: Jan Kara <jack@suse.cz>
To: Andres Freund <andres@anarazel.de>
Cc: Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <2hwc3ixfwvpnaazsm7y2vgrdh5em4fosxdcs2lhszcsn7mlcca@u3c5czxxcatv>
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-6-ziy@nvidia.com>
 <s2dr4cedsmqby6e3ijauv5p55vrde7c4ldyk5gxdw5iku66rbc@x3nipjpgqjh2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s2dr4cedsmqby6e3ijauv5p55vrde7c4ldyk5gxdw5iku66rbc@x3nipjpgqjh2>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E71D5180002
X-Stat-Signature: k17mygh9srbn535hp79wfbtyte4c334d
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776070003-32287
X-HE-Meta: U2FsdGVkX19z497ZF8JWvIG5iczkvVsz9pmq54u/gUn/+nibp4zfR9WOsi+oSfp3vKbfibZt/PwmSHbAtrRNPAAWYgwxEmxUS8qYbAIF1Shr7/17Fcf5iy9OoLHb6Q21C/0f7Jrqhm9G2u5I22hzToP+n/AsKnwhn55iqrPsMqfg/lT9s8hJda0JJbZY+TJNeKxJ44RdgSLV5eR+wh82h8MXzlD+R0DusE/nfenVv/HPt1PwWdrR1kmDK/gtApgyTJFgkmMxYqTAY0l3VskJLHk+KMnTt2+iHn8llqLjkDjaA5RmXW8XihP0uZj+xhX3/k4He0aZABN21oULzDVjYn8xu9rG2Yuq7iXgOc/cBeXab24jnjjhxbiIM0XPSDJDEqoQHdbXa+Lto5DK3DRc+yzy9p+ZWoxmTWsOzcse60Pc8diCU8GC/A3bePmMQ2ZKd1tUkCetxOs9zkAyOoJpVWPmqr2W7Dy1MzwwlQz9ioMLJEoDVAX6tGV6mdCAfr/dbnNd0ebBsfRAtrfh2axw6rl33HDquWuctWIHeTAR9eN/rEZpmizUzq1nf8ZpnnZ0mzyvvqZrPucFb+UzUT+u4yimRYgZyuybm4T8FytOd5OJ8d9w6H1ZVMerpyocS2DA7EflOsa5wAbcht+nstnuu/AwWBiEFLJDzWzvLYs8rCf+GAhBBovIi7FkxOuRX3COrNFwB0pRJDEsH6TavQr2vpuGRLSroqDgudqMVqNDBFWwBqAT3XOb1KyI7wqPAzcM0cx+jqm6z6tRNK/x1srGs2PRfJu9q1Orr6JnuBhg7krgKOLWBg51awUL24RnSytxaCV36HvIGcb40T5ctGdSVRyaPof/uJ+roDS4g4u89iWN3y7SMZG+ibMgi0EaWh36dOg9HqNQlLcT3SLG5HFvkc7bcGRpsOJI9He5JQFFdmADFjw/DutNtmRD4EFL9qtR6+CzpnKhTxJpRvyaT5x
 JWO96kKK
 Dd8pFzurFfwOOEzLacT+y1bZ5r7FLH8x+8Fva1LUtdfjETe7iBZ38utkyc9yk9bXYna6t/LQE34E9lZLid1ue9JBJpdcOMLD/Tg6y+APibN9gbhZvK5/Ngar+ZZEb5JNrAZg0f9ykB1/jPNYVWTBhoVO4gKJVh6SrroeM9xWziN4SORu2gSmH0pVu4aRY/6ONvUi4+hVnrgkyB1ThsjJPhz0Bqm5kWghBx8eE5IpMzpg1nI8gVVLatD/ddWGq1+0AKwO74i4i0KikRcesvoqt2zjBNobr4iZ5FDkmMoIr/rUgUVVtx9h86LUm939i4emstIssDqRzfYks2gAmM/o3btVLiJiDAw2z2cin4TwwBARb9h8IMWfEizPp4rH+WS8dEDAHtVQHyssSj102cTXfQHILQlvJJjZOx7Aw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 10-04-26 11:06:23, Andres Freund wrote:
> Hi,
> 
> On 2026-03-26 21:42:50 -0400, Zi Yan wrote:
> > Replace it with a check on the max folio order of the file's address space
> > mapping, making sure PMD_ORDER is supported.
> 
> Question from a user space developer (who learned of this via LWN [1]):
> 
> Right now MADV_COlLAPSE on file mappings appears to only only work with
> CONFIG_READ_ONLY_THP_FOR_FS.
> 
> That's pretty sad, because I see quite consistent gains (~15%) from doing
> madvise(MADV_COLLAPSE) on e.g. postgres' .text - but because
> CONFIG_READ_ONLY_THP_FOR_FS is not enabled default (or at least not commonly,
> I think?) in distro kernels, it never quite seemed worth the fiddliness.
> 
> 
> Do I understand correctly that by replacing the check here (and the
> predecessor commits), madvise(MADV_COLLAPSE) on file mappings might actually
> start working in more situations on typical distro kernels?

FWIW we soon might be creating PMD sized folios for executable VMAs by
default [1] (at least for archs with 4k page size). So there'd be no need
for explicit MADV_COLLAPSE to get the gain.

								Honza

[1] https://lore.kernel.org/all/20260402181326.3107102-3-usama.arif@linux.dev/

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

