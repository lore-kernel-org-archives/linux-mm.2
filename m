Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88689CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E592B8E0008; Fri, 26 Sep 2025 05:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30558E0001; Fri, 26 Sep 2025 05:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1F078E0008; Fri, 26 Sep 2025 05:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C006B8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:46:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7889B1DFE6F
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:46:53 +0000 (UTC)
X-FDA: 83930922306.13.B7C4BCE
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 832FE4000B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:46:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="P0bjGCp/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gFFgjL4p;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="P0bjGCp/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gFFgjL4p;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758880011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FTHG5VPu023TpqFFP4aeKMhpYwa8T0tvJRQfdx1F98=;
	b=P3UpiueHu9XpYthPhQiCDQXIlKgK5B13HwWvT1ypAIxNuImSqvzBffZp01WNG4mImH4dqm
	sQ7t/hIo//4ZYQGcDAjKClmO7Vqm3/jsFHhmx/YToyoeU4zyxlmWUijCUzWMvGqlzalSNf
	hzuu+dND692HTO0RjH26YkncLKXcF8o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="P0bjGCp/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gFFgjL4p;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="P0bjGCp/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gFFgjL4p;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758880011; a=rsa-sha256;
	cv=none;
	b=Et8nK9BeMohBT3RWVwbi2Pv530u6Uk6IKMMZaXvRXis83pfxWsuFqJXgwGajQLVaA3U39R
	Xp2Gwu+XNcS4d9YVxly/ivO28A0q9Er+++E8uC7d3aNqQnQInJQkFEx6FyYY8acf2cTarx
	lgUf7gvqiZ4L/lFzu9ACe6F1jun3QIE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 130742408A;
	Fri, 26 Sep 2025 09:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758880000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0FTHG5VPu023TpqFFP4aeKMhpYwa8T0tvJRQfdx1F98=;
	b=P0bjGCp/UYqjSJ0ZN/1YOb6qLOmH8JRj7qtNBB2LALa99JynIxZKszeTFeh/Qwp4wTyJuL
	JQIK/wasKd8Ksa6DU2bm++LMpdXFQmvZxCCf/xEA/gZuTGCwbGVhxh/8P+X1fmZNjKNbc6
	W9Ys2ViQODHk6CzS8aT/3qVg2RR1jgo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758880000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0FTHG5VPu023TpqFFP4aeKMhpYwa8T0tvJRQfdx1F98=;
	b=gFFgjL4pbQAoOPk39RBp6E9pKc08ohddq/g+moLf7n+aM004quj2iz0Ku4oj5TpsFCCer7
	QLyGAqFA2Rij9zDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758880000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0FTHG5VPu023TpqFFP4aeKMhpYwa8T0tvJRQfdx1F98=;
	b=P0bjGCp/UYqjSJ0ZN/1YOb6qLOmH8JRj7qtNBB2LALa99JynIxZKszeTFeh/Qwp4wTyJuL
	JQIK/wasKd8Ksa6DU2bm++LMpdXFQmvZxCCf/xEA/gZuTGCwbGVhxh/8P+X1fmZNjKNbc6
	W9Ys2ViQODHk6CzS8aT/3qVg2RR1jgo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758880000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0FTHG5VPu023TpqFFP4aeKMhpYwa8T0tvJRQfdx1F98=;
	b=gFFgjL4pbQAoOPk39RBp6E9pKc08ohddq/g+moLf7n+aM004quj2iz0Ku4oj5TpsFCCer7
	QLyGAqFA2Rij9zDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB7761373E;
	Fri, 26 Sep 2025 09:46:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U1F4NP9g1miREAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 26 Sep 2025 09:46:39 +0000
Message-ID: <7c41eaf6-d0d1-495c-865d-21cbdceb23b7@suse.cz>
Date: Fri, 26 Sep 2025 11:46:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: silence data-race in update_hiwater_rss
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: elver@google.com, Liam.Howlett@oracle.com, david@redhat.com,
 harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
 syzkaller-bugs@googlegroups.com,
 syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com
References: <20250926092426.43312-1-lance.yang@linux.dev>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250926092426.43312-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 832FE4000B
X-Stat-Signature: 6ke8y1j3geh8h5x1ksuwexrmhdhmx8st
X-HE-Tag: 1758880010-128303
X-HE-Meta: U2FsdGVkX1+/6y+HkKIHsDbtnzhPQXAgclU5t+IkBwKpVNOnDADA3mulmxYDs8IQghN3X5SmeuOXdoUZh16LjiTTiAeDt/jpd/GC1x2CtMjaRq6CNWf2kR5tHiHsPFXJXKMSNz6RKQneh0bwJj5x3+TN1J/ioyvYEFgXwKxRZ673h4K3TpXnWCRLkrv4QBuMmJx+oKDz/qudUffx1kMv9aGLkrbZPbRJnKjbtLZc/MJZgCYOZ2r0Iu1ORO4XM/8IbDlRfMdbNEj/+uhTRqo1JAO1Eyx08+ScfT9cyFv6UtT5T9JdPs0aIpCgreu9uw8Af4oZLyU42bn3UW+qyNbwDfAPWPd8mhh+/cY69oB2ePTcAf77frdUcj12qn4zEzZDSLqLzIf8gdoeSLAYXRUvNUzo33NSz6lGHNllaSWc9TiE1Ml2XBR+WwvTFnAasI8eU1SI96GCODGMAu/w4dqQHaGXeyoOCdnl4My+Dk8mnEGNCPp5bru1oqasyv1VurIuFJK3hSBTt3YVt3R4kVYJyAgo9Xt71WdTI4KsYWP57W329Dvr8tqIVNVH67NgBv99+b+SazfPRHeG++C8r25pQmRkKUOEt0KJncCtvsZJFk2hjcLUcbDf+AjnL73tgZm4eaco+RfpHt/QFLp4axOgqUd5zNE+on03AGj9HOz2rwWg6VlyrxREmvKTn0HSwV75YupvoWlOSqNeV17tnJNzovtM+u6paKQykhTaUOiTQ7/0GuCIgnNyb9Q1WgLwk3X37/F6g5Gps2N0Mv1DDwi/sSbC66xcyPpNHzMzSGOUnpjMQF9q9HcK5n01+2isWkLH7UJKKOzKAa3QVNF3JgIutCr4DNC/lEm0DS3920e3KDT5rbpIUM1ZO0rjickXNyOcG2s89No8/XjRaOs/7ph8wRDIEttagN13+Au0RopWyHQ3OlfzTPp5yLIt8jnrr9mdYM5Kr7MxpyJK1V+WR4g
 xVTy+bam
 R2m/XBch4xcSZDaTqhzKKeWWekMd9rDc8BJoNb2xN8lHVh3+oC7s6BBP4wSAiGu3f+F+/8XRroHjxmeBDtdwFV/thz3VEyJA+yZlyrztEAKMzDaJH3eVM1QBCWwOGqqa10w6FjdVwJM4Iq+JiCDgoQoaizXNTNfUr0hsTOuDtD5cCwh5HGiOyh/hcDGiRu1pPfc6KKGqE8CbI5DtxEkpH3eOL1EMsQjWlTMPkhoEFNa7sdG1wl+VVQxgT0nZfltoNHue/4vkloB30TIiMOZk9peOUA2gIatgOd+AutUIlEPmGgenp7ZSpVCezIMNQKqTWcdY39LUV4rc83v5xsOxNDjNBIDxUrp3PkwOWieCZ9H0eYYNSV6KoLs3V79gZJ4bkye4VFdGJNa9DngSQakG+4ci64xaq8863s5o/VsmoKd09lJoeVw0PuNZQ8ZFPhT7p94H5/Cbf0pTrhktUW3qJHoh1pLwAGp89qW6SENM4+OyuKobdBVRUFiB2TWEgnI97t6PAdX4alYLKhum9GCszocb82eGtJ190KfRa7+F5CQKqZZzljnK6ZR3/R0CreeuAm+Pd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/25 11:24, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> KCSAN reports a data race on mm_cluster.hiwater_rss, which can be accessed
> concurrently from various paths like page migration and memory unmapping
> without synchronization.
> 
> Since hiwater_rss is a statistical field for accounting purposes, this data
> race is benign. Annotate both the read and write accesses with data_race()
> to make KCSAN happy.
> 
> Reported-by: syzbot+60192c8877d0bc92a92b@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/linux-mm/68d6364e.050a0220.3390a8.000d.GAE@google.com
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  include/linux/mm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6b6c6980f46c..dd93335e3a13 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2757,7 +2757,7 @@ static inline void update_hiwater_rss(struct mm_struct *mm)
>  	unsigned long _rss = get_mm_rss(mm);
>  
>  	if (data_race(mm->hiwater_rss) < _rss)
> -		(mm)->hiwater_rss = _rss;
> +		data_race(mm->hiwater_rss = _rss);
>  }
>  
>  static inline void update_hiwater_vm(struct mm_struct *mm)


