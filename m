Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F15FCEDD9B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 14:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87BD66B0008; Tue, 18 Nov 2025 09:40:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82BEF6B002F; Tue, 18 Nov 2025 09:40:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B006B00A2; Tue, 18 Nov 2025 09:40:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFE96B0008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:40:05 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0842E5977F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:40:05 +0000 (UTC)
X-FDA: 84123987570.10.7EE8EFA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id D5DCE180009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 14:40:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aeCBfhXF;
	spf=pass (imf16.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763476803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZVTmRvQii60FOo2suFrzGjPzAxPAukOqBRsXtq0Q6E=;
	b=TmpOA80hDiC6E4bvUow7ckqAtgwc9VbYigOrciVyY5V4p4iKLzq4bsEkm/ABtQumeNvDss
	d1iTTRcqGRyaJa8uIU2WiWsR/dAmxxvlrxXkoQWrfQw6NOc9HYDH1abXms12aGDHa5191j
	25dqy61NHSQcko4FcOzxk/4wAs/aF8g=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aeCBfhXF;
	spf=pass (imf16.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763476803; a=rsa-sha256;
	cv=none;
	b=bQgi9+aUAfmpS5jYV7rN+/nvk5GCAEp7YsctXnDc+MsvH1NwRF7AZmZowCHdK49xS1oTfm
	2FS2LrG2BkHJZb58N3UUvQruVVg9Vjy6v5wdaRvHMM6L6kxsMBNE+M4LMuRaUnZPuHL8zF
	Gl+8svXZbMuOf5cuwAqZuf/jIFhR8F4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763476802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OZVTmRvQii60FOo2suFrzGjPzAxPAukOqBRsXtq0Q6E=;
	b=aeCBfhXFFIdgUOjyRn6vzlHRCgvP8ZOzMaWiuug+0QPpX1QOQnG4JTxTbGJ6ykr7JvtE3L
	LaM5YSA26j54vPDH2RcdCwHoE85DVAfrK/mApk1w2ltkNaWmlOlbNLgcj3JiVmwa7O9giB
	yYM4sIS/T3VLIWyK7sVSGnrwMubvBUo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-50-u1u40BvyNUmrANy5rHhMfA-1; Tue,
 18 Nov 2025 09:39:59 -0500
X-MC-Unique: u1u40BvyNUmrANy5rHhMfA-1
X-Mimecast-MFC-AGG-ID: u1u40BvyNUmrANy5rHhMfA_1763476798
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD56B180047F;
	Tue, 18 Nov 2025 14:39:57 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB2ED19540E7;
	Tue, 18 Nov 2025 14:39:56 +0000 (UTC)
Date: Tue, 18 Nov 2025 09:39:54 -0500
From: Brian Foster <bfoster@redhat.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 1/3] tmpfs: zero post-eof uptodate folios on swapout
Message-ID: <aRyFOsUk--AtbEGM@bfoster>
References: <20251112162522.412295-1-bfoster@redhat.com>
 <20251112162522.412295-2-bfoster@redhat.com>
 <c1978ef3-251b-4a57-8244-b047e66b6ab3@linux.alibaba.com>
MIME-Version: 1.0
In-Reply-To: <c1978ef3-251b-4a57-8244-b047e66b6ab3@linux.alibaba.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KBdyti8K6YtGSosCT2DFbi7gXvnAktySU9vjdexa7yk_1763476798
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5DCE180009
X-Stat-Signature: y6t5scpwp3btbxd4b3i5yeth6pmrsxo8
X-Rspam-User: 
X-HE-Tag: 1763476802-360876
X-HE-Meta: U2FsdGVkX19rySKqrw1HwQlVcv2hxvGxdj9E/vLos3Agb4T7YEwN2DIfxCcxel7NRIQlKu3nd/idSyJt9kEj/SSJ5Jn2/s97FOv7TcU5A7aepio2R1feh4D0vC7AeGRo3Ir3fWlV43BnQ7c5kHEY7dMX2/OlA5KpmV1Cuq4uclel9V5IBTmxvQlSK1k47XpUgvQTdeKN7KoAQIlScBEUcty43MjiGQ72h8rmuBu/RAB6XDZrh9tznljdXkUpatA5ffNzfGchA9bdO1mXZxR1NNc4dpRD0GM+SL+V0Hmp0RCrBz1SQP2TXlantcZkBR2mNoLHYc0UMoCGHWgmesgbBptDsc1KzHLAjW704QZjfW9PM89DITbSSOWX2aksC1gx2lZae+pgNvL98B86J02bj8IhYLzoc4Tahf8l/NwsqFn6LLDCG5jVHatf2Hxqjvr8USfu/3ganWyIUSQ1HmflsgwOzVNsnGSC/AX2pgdl2GcczqPa5rRrz+Fg421JbEiu9adhH+iI727ZL5+FhoTUJhBEG0uYlFmGZdA66ytwAR5VeK9e3+XfMTbmQS8xDGs5lBdq5MueR11cT5r13Mp0n2jcJK4ydpw7M9RsuM86ibQuWJLzMRskCrMY9FJlV2dsk53vn7Yl7ihxxCSsY8Ok+dyVzra2hrjspD+RYqCrFzdJsEX7eJFRJytjEMXRxgvcdAlvjLEB+ktXygpnkVlsma9U6MIbg6xjpgVl6Q0C6eYu/9o0uAygQ8BoxDA4PBTGO9Dg8dPiUH38AkRqf0yOIvuUwXljuxCDDax+YV+c4BvkIYObWQqrJpe5xGY9nGliZtwT4p76oSTDocNpCsg4eBv5v1WZVOcOgm7ndPvtUk4GVyy/bJ+VYWLEdWHkTGtjL0a+y1vbuNyCRL6myL9mZC/bAKPTiGm3WYyuJ/yXcY5mDUZFNoLHwXYmhMpeEsM3JHm1/K6akSIwpMOuGVP
 YcCZGw5A
 DXXQRPyuQLlqMYqaoxAOVSYlGyyt4tz1uYWPThfUbGkZt3ByAJRvDXQEwxjODt4nnjbdc7Yfh0KMUPXrkv78Q+21/6A/Bse5wp9wCfJhQ9gQiPgRi/FRxpfFj/Pb0rINIwwzuUNMdwfWmyU0KcgS53FYIVo3HsY3WQ8+Xb6ZiPPMWoH6Ngvp8GKeX+ig5+asXXmYcSzw2gSMzOuZ8n6C/WJXxCMYO5bVyq2yZhJEVhen37hKbjcz1rqpwgew4rEZukMdLIp+3NfmyY/JIHEqsxwij9YBzHu+agcVhHL56/1SCWFUfn+em4UJwiymdLlVmRzdu2nygMSZM3p/ky6dx7CjAkFlCvOr+SnNnC2f7NLIpuY/rODAssOqpoN6sCKYTJS5a0o3lNMmLnunjOYJwy4zVG5gRcY4ZhLGt8MJQ65N6aUPp7+awshOcmCQqNTEdNtB+F4lTjX4DriW3WU1vJQi77db+f31UeG0s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 10:33:44AM +0800, Baolin Wang wrote:
> 
> 
> On 2025/11/13 00:25, Brian Foster wrote:
> > As a first step to facilitate efficient post-eof zeroing in tmpfs,
> > zero post-eof uptodate folios at swap out time. This ensures that
> > post-eof ranges are zeroed "on disk" (i.e. analogous to traditional
> > pagecache writeback) and facilitates zeroing on file size changes by
> > allowing it to not have to swap in.
> > 
> > Note that shmem_writeout() already zeroes !uptodate folios so this
> > introduces some duplicate logic. We'll clean this up in the next
> > patch.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >   mm/shmem.c | 19 +++++++++++++++++--
> >   1 file changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 0a25ee095b86..5fb3c911894f 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1577,6 +1577,8 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> >   	struct inode *inode = mapping->host;
> >   	struct shmem_inode_info *info = SHMEM_I(inode);
> >   	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
> > +	loff_t i_size = i_size_read(inode);
> > +	pgoff_t end_index = DIV_ROUND_UP(i_size, PAGE_SIZE);
> >   	pgoff_t index;
> >   	int nr_pages;
> >   	bool split = false;
> > @@ -1596,8 +1598,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> >   	 * (unless fallocate has been used to preallocate beyond EOF).
> >   	 */
> >   	if (folio_test_large(folio)) {
> > -		index = shmem_fallocend(inode,
> > -			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
> > +		index = shmem_fallocend(inode, end_index);
> >   		if ((index > folio->index && index < folio_next_index(folio)) ||
> >   		    !IS_ENABLED(CONFIG_THP_SWAP))
> >   			split = true;
> > @@ -1647,6 +1648,20 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> >   		folio_mark_uptodate(folio);
> >   	}
> > +	/*
> > +	 * Ranges beyond EOF must be zeroed at writeout time. This mirrors
> > +	 * traditional writeback behavior and facilitates zeroing on file size
> > +	 * changes without having to swap back in.
> > +	 */
> > +	if (folio_next_index(folio) >= end_index) {
> > +		size_t from = offset_in_folio(folio, i_size);
> > +
> > +		if (index >= end_index) {
> > +			folio_zero_segment(folio, 0, folio_size(folio));
> > +		} else if (from)
> > +			folio_zero_segment(folio, from, folio_size(folio));
> > +	}
> 
> As I mentioned before[1], if a large folio is beyond EOF, it will be split
> in shmem_writeout(), and those small folios beyond EOF will be dropped and
> freed in __folio_split(). Of course, there's another special case as Hugh
> mentioned: when there's a 'fallocend' beyond i_size (e.g., fallocate()), it
> will keep the pages allocated beyond EOF after the split. However, your
> 'end_index' here does not consider 'fallocend,' so it seems to me that this
> portion of the code doesn't actually take effect.
> 

Hi Boalin,

So I get that split post-eof folios can fall off depending on fallocate
status. I'm not sure what you mean by considering fallocend, however.
ISTM that fallocend contributes to the boundary where we decide to split
and/or preserve, but i_size is what is relevant for zeroing. It's not
clear to me if you're suggesting the logic is potentially spurious, or
this might not actually be zeroing correctly due to falloc interactions.
Can you clarify the concern please? Thanks.

Brian

> [1] https://lore.kernel.org/linux-mm/097c0b07-1f43-51c3-3591-aaa2015226c2@google.com/
> 


