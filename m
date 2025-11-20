Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD487CF8860
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 14:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1116F6B000E; Thu, 20 Nov 2025 09:12:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2706B0023; Thu, 20 Nov 2025 09:12:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1A336B0088; Thu, 20 Nov 2025 09:12:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DDDEC6B000E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:12:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8E4FC013C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:12:37 +0000 (UTC)
X-FDA: 84131175954.07.E42ADAF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E9BB1A0018
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 14:12:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iRJp0FDv;
	spf=pass (imf19.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763647955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmVXTswOAqNajDezrGGdWgEnq+jAHEwyzXHyRBch8jE=;
	b=jIZR08Qv8JeP1JZqQYGiBdcKVVKuKzoKuKemDzbzL8xjKt9KZz9GJdycRk3NvUyA8uERNJ
	ttwHepSyIXRmO/IgGO/7zaHh2l4YAwX5JYhXXSjyFhiGAw7mTUfjgi1jjDiFOyfxV5jkZc
	92DmlDan1DqDna1AAXz6/yAyUE6lFgE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763647955; a=rsa-sha256;
	cv=none;
	b=PcSb/FDaha8vE5SyK6JtqRl5hFCHXb9R0mrOObFqrq8rr7L+8SqcStKfKK+ZWfrcf9Zko/
	viE2rXuKFGd33Pr+Aq6qGhUhAFyKYp8T6xDUzFwlaVQcTrE4oYrhIDu5Kd9ejnevt/3777
	Ygvkv+LJYGTgsSZIMqjJR8ZQNTld0cQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iRJp0FDv;
	spf=pass (imf19.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763647954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xmVXTswOAqNajDezrGGdWgEnq+jAHEwyzXHyRBch8jE=;
	b=iRJp0FDvuouR8HR0HUiBNEtOd9Nro5vLfNi6nHbgyH+ZMdIejO0P6xGRGBUBAV+jsNX6dq
	5/myLVeQG28JwpMTHeeSvUutU2jLPC3ObyzNNhUKVDGEE7XLp41lTD1YhXRWVcyQLQbN2r
	XiuFpBW/eEVzoYNsCYu7cc8EZvN/GPk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-376-ow1p2xe3NweVW_XUGX1s8Q-1; Thu,
 20 Nov 2025 09:12:33 -0500
X-MC-Unique: ow1p2xe3NweVW_XUGX1s8Q-1
X-Mimecast-MFC-AGG-ID: ow1p2xe3NweVW_XUGX1s8Q_1763647952
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B2EE1956046;
	Thu, 20 Nov 2025 14:12:32 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.29])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C104F3001E83;
	Thu, 20 Nov 2025 14:12:31 +0000 (UTC)
Date: Thu, 20 Nov 2025 09:12:29 -0500
From: Brian Foster <bfoster@redhat.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 1/3] tmpfs: zero post-eof uptodate folios on swapout
Message-ID: <aR8hzf2gbJsFnTgZ@bfoster>
References: <20251112162522.412295-1-bfoster@redhat.com>
 <20251112162522.412295-2-bfoster@redhat.com>
 <c1978ef3-251b-4a57-8244-b047e66b6ab3@linux.alibaba.com>
 <aRyFOsUk--AtbEGM@bfoster>
 <9e696091-9c40-46cf-91b9-c95e1d38a1a8@linux.alibaba.com>
 <aR3PWnNFhOckoHvc@bfoster>
 <8e766a2b-0d54-4905-9f67-53ef1397b8dc@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <8e766a2b-0d54-4905-9f67-53ef1397b8dc@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UfaiU-EBUFjv2cY-iyPbO8zSQBdEnGl-C7a1pZKd7ss_1763647952
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E9BB1A0018
X-Stat-Signature: mbuwm6qq3c37xgnqguna1oerw9n1s3uy
X-HE-Tag: 1763647955-721111
X-HE-Meta: U2FsdGVkX1++vptNIYnuD7bVG0/1ufi/rllO/Kwrct0myy04PC3aiVmb8GgHH1qrQmvybUNd/HFKd5WhL6535xTyAhP9vgYkhwTCq+Yh6LRIhif9alrdJcVRamMoIARJhrb/1w4me3z58NsRfvDave+PyuPcbjNeXghG0qPowXXHXwauGQHIfCuuaJ/co0lEdHs5QhLlluZagg1P8mc1KbiMUbP2CM8Q/z0zFlURutDY4S2zHngxKTEwYe7UZpolSdS39eDFGTfM42DmE85Tx7/Mrp1CSJdsDXf1qPValuQY+s/PIgX3VBjK8DeY3ScqEMtuupY5VDYJFPa5UEluSDgzRNU66OYfmNgUJPRFx7Tn4zonQpDA1J8npzVCuEgazr/546k6E3A64uxIa6lnlncmGs13Mw0HZ9A2e8dFc86CdtwZAv5uIgHBCfltfJjwLkfAcrb7o96rUV45fuD5g6vPe8eMkiQJGpXGuoykAARLEqdAO7FQuB4iZqtN28sp4zkxdFTPri6f4VEU+W0mpbscoL/rTvpBivfZVygHKPgo4RDtD1G2uv+AYh0U5JrP0nlHqNaDtcg5rDUTOBU0BO7OzfD3NFBQQXSJDrPYmza3m1loTJNZ6lvMElzh0zkIfyGC+NGpikLGdJQXswLkhxds/VV9ADR0ykTPpj1tiBQvoX64JnuQLtP6Vw6C7Dgn8IDW9NNXCeTNjHhUiFVWXgKK+04ArcpbP86id3qVfzN/mNLxL/EPBXK+iVnn5IZiGEIVPiVxNrBhtMJsMJX7voLTLDzMDnRknk6zijwGBNt6T512RfWGJTSd8TEFAF6utgDBflRCSLByJTqajDqE7jANdmillxiGcH54NaontafJihz9AEaaCQcysAYPuX5hqFAFaitjWbkIJcFlTr90fYuNHg8C2kdtEYMrqb2RtZEP5ZTMjgJBU1/WstjEK+0WhczJ33Ss3l5D1Oejtwq
 ZY8y8xV1
 QQQkqgen1hIODAQ9E13WhK7TK1rQCnVF8O+ZxKU7t9XT+wDq4Yrh5IcFkezCGc4cBD6EhnF6W3BCuKYjDvr7/YLRGQFpGXMCruF9quHZpdxgWPsZMWQFoDII+rLmNcPWfM7h7c2QdT9MkBnkiG04G0auY+oGgubHHzEEmcp0rx6VO3AumQiWvATbblB28/DnQf2xSaEgoBpNgWSDJ4b4aTVAYJ0CCy80TzGFzJmUWpzjaxVQr09w6rpXQc5MojCpGgXrbVcKVa2JasAXL+5j92IoVWmMjH3VnSPUG/lFIZmoyciQQr64mSdmuzvFlQ3K3WK6gfB9WmdK1ujXYQSef4TGKmWEoPhBoZTu0OrORyuXn+mSgVPM5eAPLuRijJK1iWUiIN1S6Xjq/FmNY+BhdaTyyQPyP6nlbxH0wOsBnyJGfnvPpXQUCH1mz2WQiM4LAMeD6qZ0z2E15MWsJtQrg94f2G98cLxCYLvUo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 09:57:40AM +0800, Baolin Wang wrote:
> 
> 
> On 2025/11/19 22:08, Brian Foster wrote:
> > On Wed, Nov 19, 2025 at 11:53:41AM +0800, Baolin Wang wrote:
> > > 
> > > 
> > > On 2025/11/18 22:39, Brian Foster wrote:
> > > > On Tue, Nov 18, 2025 at 10:33:44AM +0800, Baolin Wang wrote:
> > > > > 
> > > > > 
> > > > > On 2025/11/13 00:25, Brian Foster wrote:
> > > > > > As a first step to facilitate efficient post-eof zeroing in tmpfs,
> > > > > > zero post-eof uptodate folios at swap out time. This ensures that
> > > > > > post-eof ranges are zeroed "on disk" (i.e. analogous to traditional
> > > > > > pagecache writeback) and facilitates zeroing on file size changes by
> > > > > > allowing it to not have to swap in.
> > > > > > 
> > > > > > Note that shmem_writeout() already zeroes !uptodate folios so this
> > > > > > introduces some duplicate logic. We'll clean this up in the next
> > > > > > patch.
> > > > > > 
> > > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > > ---
> > > > > >     mm/shmem.c | 19 +++++++++++++++++--
> > > > > >     1 file changed, 17 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > > > > index 0a25ee095b86..5fb3c911894f 100644
> > > > > > --- a/mm/shmem.c
> > > > > > +++ b/mm/shmem.c
> > > > > > @@ -1577,6 +1577,8 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> > > > > >     	struct inode *inode = mapping->host;
> > > > > >     	struct shmem_inode_info *info = SHMEM_I(inode);
> > > > > >     	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
> > > > > > +	loff_t i_size = i_size_read(inode);
> > > > > > +	pgoff_t end_index = DIV_ROUND_UP(i_size, PAGE_SIZE);
> > > > > >     	pgoff_t index;
> > > > > >     	int nr_pages;
> > > > > >     	bool split = false;
> > > > > > @@ -1596,8 +1598,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> > > > > >     	 * (unless fallocate has been used to preallocate beyond EOF).
> > > > > >     	 */
> > > > > >     	if (folio_test_large(folio)) {
> > > > > > -		index = shmem_fallocend(inode,
> > > > > > -			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
> > > > > > +		index = shmem_fallocend(inode, end_index);
> > > > > >     		if ((index > folio->index && index < folio_next_index(folio)) ||
> > > > > >     		    !IS_ENABLED(CONFIG_THP_SWAP))
> > > > > >     			split = true;
> > > > > > @@ -1647,6 +1648,20 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> > > > > >     		folio_mark_uptodate(folio);
> > > > > >     	}
> > > > > > +	/*
> > > > > > +	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
> > > > > > +	 * traditional writeback behavior and facilitates zeroing on file size
> > > > > > +	 * changes without having to swap back in.
> > > > > > +	 */
> > > > > > +	if (folio_next_index(folio) >= end_index) {
> > > > > > +		size_t from = offset_in_folio(folio, i_size);
> > > > > > +
> > > > > > +		if (index >= end_index) {
> > > > > > +			folio_zero_segment(folio, 0, folio_size(folio));
> > > > > > +		} else if (from)
> > > > > > +			folio_zero_segment(folio, from, folio_size(folio));
> > > > > > +	}
> > > > > 
> > > > > As I mentioned before[1], if a large folio is beyond EOF, it will be split
> > > > > in shmem_writeout(), and those small folios beyond EOF will be dropped and
> > > > > freed in __folio_split(). Of course, there's another special case as Hugh
> > > > > mentioned: when there's a 'fallocend' beyond i_size (e.g., fallocate()), it
> > > > > will keep the pages allocated beyond EOF after the split. However, your
> > > > > 'end_index' here does not consider 'fallocend,' so it seems to me that this
> > > > > portion of the code doesn't actually take effect.
> > > > > 
> > > > 
> > > > Hi Boalin,
> > > 
> > > s/Boalin/Baolin :)
> > > 
> > 
> > Sorry, Baolin! ;)
> > 
> > > > 
> > > > So I get that split post-eof folios can fall off depending on fallocate
> > > > status. I'm not sure what you mean by considering fallocend, however.
> > > > ISTM that fallocend contributes to the boundary where we decide to split
> > > > and/or preserve, but i_size is what is relevant for zeroing. It's not
> > > > clear to me if you're suggesting the logic is potentially spurious, or
> > > > this might not actually be zeroing correctly due to falloc interactions.
> > > > Can you clarify the concern please? Thanks.
> > > 
> > > Sorry for not being clear enough (for my quick response yesterday). After
> > > thinking more, I want to divide this into 3 cases to clearly explain the
> > > logic here:
> > > 
> > 
> > No worries. Thanks for breaking it down. Much easier to discuss this
> > way.
> > 
> > > 1. Without fallocate(), if a large folio is beyond EOF (i.e. i_size), it
> > > will be split in shmem_writeout(), and those small folios beyond EOF will be
> > > dropped and freed in __folio_split(). So, your changes should also have no
> > > impact, because after the split, ‘folio_next_index(folio)’ is definitely <=
> > > ‘end_index’. So the logic is correct.
> > > 
> > 
> > Ack, but we still want to zero any post-eof portion of a small folio
> > straddling i_size...
> 
> Yes.
> 
> > > 2. With fallocate(), If a large folio is beyond EOF (i.e. i_size) but
> > > smaller than 'fallocend', the folio will not be split. So, we should zero
> > > the post-EOF part. Because 'index' (now representing 'fallocend') is greater
> > > than 'end_index', you are zeroing the entire large folio, which does not
> > > seem correct to me.
> > > 
> > 
> > Unless CONFIG_THP_SWAP is disabled (no idea how likely that is, seems
> > like an arch thing), in which case it seems we always split (and then
> > the split path will still use fallocend to determine whether to toss or
> > preserve).
> > 
> > But otherwise yes, partial zeroing should be the same for the large
> > folio across EOF case, it just happens to be a larger folio size...
> > 
> > > if (index >= end_index) {
> > > 	folio_zero_segment(folio, 0, folio_size(folio));
> > > } else if ...
> > > 
> > > I think you should only zero the range from 'from' to 'folio_size(folio)' of
> > > this large folio in this case. Right?
> > > 
> > 
> > However index is folio->index here, not fallocend. index is reassigned a
> > bit further down the function just after the block try_split: lands in:
> > 
> >          index = folio->index;
> >          nr_pages = folio_nr_pages(folio);
> > 
> > This wasn't introduced by this patch, FWIW, but I suppose we could make
> > the fallocend block use a local for clarity.
> 
> Thanks for correcting me. I mistakenly assumed that the 'index' represents
> 'fallocend' from your patch:
> 
> +		index = shmem_fallocend(inode, end_index);
> 
> > So given that, the logic is effectively if the folio starts at or beyond
> > the first page size index beyond EOF, zero the whole thing. That seems
> > pretty straightforward to me, so I'm not clear on why we'd need to
> > consider whether the folio is large or not at this point.
> 
> Yes, you are right. After you corrected me, I understand that index refers
> to folio->index.
> 
> > > 3. With fallocate(), If a large folio is beyond EOF (i.e. i_size) and also
> > > beyond 'fallocend', the large folio will be split to small folios. If we
> > > continue attempting to write out these small folios beyond EOF, we need to
> > > zero the entire mall folios at this point. So, the logic looks correct
> > > (because 'index' > 'end_index').
> > > 
> > 
> > Ack..
> > 
> > > Based on the above analysis, I believe the logic should be:
> > > 
> > > if (folio_next_index(folio) >= end_index) {
> > > 	size_t from = offset_in_folio(folio, i_size);
> > > 
> > > 	if (!folio_test_large(folio) && index >= end_index)
> > > 		folio_zero_segment(folio, 0, folio_size(folio));
> > > 	else if (from)
> > > 		folio_zero_segment(folio, from, folio_size(folio));
> > > }
> > > 
> > > The logic here is a bit complex, please correct me if I misunderstood you.
> > > 
> > 
> > Hmm.. so I'm not really sure about the large folio check. Have you
> > reviewed the next patch, by chance? It occurs to me that I probably
> > split these two up wrongly. I probably should have split off the
> > existing !uptodate zeroing into a separate hunk in patch 1 (i.e. as a
> > non functional change, refactoring patch) and then introduce the
> > functional change in patch 2. I'll try that for v3.
> > 
> > But in the meantime, this is the logic after patch 2:
> > 
> > 	/*
> > 	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
> > 	 * traditional writeback behavior and facilitates zeroing on file size
> > 	 * changes without having to swap back in.
> > 	 */
> > 	if (!folio_test_uptodate(folio) ||
> > 	    folio_next_index(folio) >= end_index) {
> > 		size_t from = offset_in_folio(folio, i_size);
> > 
> > 		if (!folio_test_uptodate(folio) || index >= end_index) {
> > 			folio_zero_segment(folio, 0, folio_size(folio));
> > 			flush_dcache_folio(folio);
> > 			folio_mark_uptodate(folio);
> > 		} else if (from)
> > 			folio_zero_segment(folio, from, folio_size(folio));
> > 	}
> > 
> > So factoring out the preexisting uptodate logic, this looks mostly
> > equivalent to what you posted above with the exception of the large
> > folio check. I could be wrong, but it kind of sounds like that is maybe
> > due to confusion over the index value.. hm?
> 
> Right. My example is wrong due to confusion over the index value. I think
> you are right.
> 
> > 
> > In any event, I'm trying to make this logic as simple and clear as
> > possible. The idea here is basically that any folio being written out
> > that is either !uptodate or at least partially beyond EOF needs zeroing.
> > 
> > The split logic earlier in the function simply dictates what folios make
> > it to this point (to be written out vs. tossed) or not, and otherwise we
> > don't really have to care about state wrt zeroing post-eof folio ranges
> > (particularly if any of that splitting logic happens to change in the
> > future). Let me know if I'm missing something. Thanks again.
> 
> Thanks for your work and explanation. Now I think your patch is correct, and
> I will continue to review the following patches. Feel free to add:
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> One nit: using 'fallocend' instead of 'index' can avoid confusion:)
> 

Great, thanks! Agreed, I'll fold this in for v3..

Brian

> diff --git a/mm/shmem.c b/mm/shmem.c
> index 371af9e322d5..7f7bdb7944cc 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1586,8 +1586,8 @@ int shmem_writeout(struct folio *folio, struct
> swap_iocb **plug,
>          * (unless fallocate has been used to preallocate beyond EOF).
>          */
>         if (folio_test_large(folio)) {
> -               index = shmem_fallocend(inode, end_index);
> -               if ((index > folio->index && index <
> folio_next_index(folio)) ||
> +               pgoff_t fallocend = shmem_fallocend(inode, end_index);
> +               if ((fallocend > folio->index && fallocend <
> folio_next_index(folio)) ||
>                     !IS_ENABLED(CONFIG_THP_SWAP))
>                         split = true;
>         }
> 


