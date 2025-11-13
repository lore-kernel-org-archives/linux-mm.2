Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60162CD5BA7
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 09:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3738E0008; Thu, 13 Nov 2025 04:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBAEA8E0003; Thu, 13 Nov 2025 04:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0858E0008; Thu, 13 Nov 2025 04:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA818E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 04:33:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4460C89C56
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:33:10 +0000 (UTC)
X-FDA: 84105070140.30.889AA77
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id B64D640012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 09:33:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qxDTpslu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o+q13OFP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qxDTpslu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o+q13OFP;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763026388; a=rsa-sha256;
	cv=none;
	b=VSTOr8ffOL1Og+hEpIguMhx/muyi8bLO0qLgbpNkZl+SGfk6y3F+YTuHaDwP/CANm2W6Fk
	FBp1UWRneY8uFJ0wUMn2DuOyao9IN7sdef4TFFwuibcXhqDlIyW7XzHYMee2PctJm7xl23
	jNF8wSRlF/kScLVLDdVHMOw4ufATU5U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qxDTpslu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o+q13OFP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qxDTpslu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o+q13OFP;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763026388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ht+jTsoWx43UjLvYFNFvSWNGbgFIbF0ywzc5k0/5BGM=;
	b=xk5HYoLzcY/pyUpFWmsZNsL7v/MBHNIODvPl33tSgjAiNn2SAmxnG/TqNkDEYjGJHBtNbV
	3bkZdmNNnNfi0RkiEpbPqFJe4byRNgRxyUyZMZcauRI5lqa44KBS/5Nj2B0j13v84LanLV
	b77GDTy62l4ihTv7D/E+tn+Avczx1XI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0829C21216;
	Thu, 13 Nov 2025 09:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763026386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ht+jTsoWx43UjLvYFNFvSWNGbgFIbF0ywzc5k0/5BGM=;
	b=qxDTpslufx/jMFcFMCx8xPxGwmdCyDIs3925/40qVCl4YtYFxW2ID7m03/6pkptP/Xyemk
	MtBW18FJLrSNc/B0329JgZsg/+2Yg1emd4gwR3eDzfzycNmHQZ7vLuy0MlvOUP9xhjdpoH
	qSkoPl+jYolF54pgJk+iidlLjlWWjqs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763026386;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ht+jTsoWx43UjLvYFNFvSWNGbgFIbF0ywzc5k0/5BGM=;
	b=o+q13OFP9gRiFkpxnwck6nnckFlQgSZV8CxcUIm7nKNyrmUmz1gFjO/pu8yPD62MjpfoKX
	IifbhLrlT/PQ/NAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763026386; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ht+jTsoWx43UjLvYFNFvSWNGbgFIbF0ywzc5k0/5BGM=;
	b=qxDTpslufx/jMFcFMCx8xPxGwmdCyDIs3925/40qVCl4YtYFxW2ID7m03/6pkptP/Xyemk
	MtBW18FJLrSNc/B0329JgZsg/+2Yg1emd4gwR3eDzfzycNmHQZ7vLuy0MlvOUP9xhjdpoH
	qSkoPl+jYolF54pgJk+iidlLjlWWjqs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763026386;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ht+jTsoWx43UjLvYFNFvSWNGbgFIbF0ywzc5k0/5BGM=;
	b=o+q13OFP9gRiFkpxnwck6nnckFlQgSZV8CxcUIm7nKNyrmUmz1gFjO/pu8yPD62MjpfoKX
	IifbhLrlT/PQ/NAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA0F93EA61;
	Thu, 13 Nov 2025 09:33:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FJvTONGlFWladwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 13 Nov 2025 09:33:05 +0000
Message-ID: <61cdfa0c-ef35-4602-b26c-137b25d2709a@suse.cz>
Date: Thu, 13 Nov 2025 10:33:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: simplify list initialization in barn_shrink()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Baolin Liu <liubaolin12138@163.com>
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Baolin Liu <liubaolin@kylinos.cn>
References: <20251111122205.29940-1-liubaolin12138@163.com>
 <aRWYsexGnCmTVut9@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aRWYsexGnCmTVut9@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B64D640012
X-Rspamd-Server: rspam07
X-Stat-Signature: ijt47869acpwj1wime9djuhmrrcy1gc3
X-Rspam-User: 
X-HE-Tag: 1763026387-905530
X-HE-Meta: U2FsdGVkX18vIQhZikXO4DEOLzxgTzbTkbhNaQiHeB01WXL0W91W1ohfBM51Fp2R//dge0ZQfbT0qSXYxstBId9F26wNnkYlSkDpgJh0P5GoE9oeMeXbVsPD2HmgMi04TBYEj6H7qxo36g1H8G99GY5hwJIseAJJ19wYXhnL1WKEXltJsT20CGM+HNxVP70nxsJoruOQgL3BXA1zFDcO33baer91DYRV5LJcLupGSNQr9HnKGilBvvo1ys7qDlMEtsSHu5R3bE8uNG5OW3Bvm8Ad57zjnH2C8G9PPQ19jZAxXw0ynruWYcevLoXUH3kPzKwJzEEGrL0mrJDdPh4+Tfk4O4pRcIE5x5L7CQTKI3+2erPzAWD2qT9Vv/KnMwAGmZ6siWUooAaeUKWvTrf6XTldi29Rx+mxLI3TTTlCDKHEH9Pt1a/OB7wfOT5BQW39ms+h6KZP9kfHmt6K389Tj+UddpmKv/usG7j0PPGCcLmyc0v/NVYT/h6qxh0q2TW9T4/MiglbhZKn3CLhV+EE55wFZtV/Nj3DAxnJr/6bSiDMkfk7Qx7IR+ukz0D46DHrll1yYyUIyuuZAxflNdYCtf1R76hdayA9/TpTFYvJ04+1dvz1ZdRofYHGrIL8jrayKOSeHcgsiDHyXiwymSCuhM9lzaR6j4iypVjTbdPIc7qt00ZX/2AcYPuddgEsAsiMhfHpXkWlpZ8nX6nrTdV9jiRoZwjrP3WtK6sUMxnnyVgDiZXxXLbbnDesEvgtvoZZ+sV/Oa5Zp6WJd/ujzalPdcT2pEBYe2CrvOT0C5Yt1eZx1SxvEG2d/bxfEm3KS2k6xBszDwaUfXWSJJHndQX16IsSgxkIH8ZMQynT3c3eTrv/il0MdnzH3I9J9/Eravyq3c0uLVOnFw1QcSt/AxDU4DE0ZglZBf3HWOB7rPKSAV7GP3YZ6tzyVmX6WXo6I3xRSM2mDBZGEamING6lhEm
 mwYwbYFH
 6JV3IwiowphpoqpZ46wATCEMMfj8QIW1RGgjZKWrHDG6Xwp1WMNGZshSb6zGV7GLyF2IMG656o3WtxpjusZDj0zap2A8VB+DQVK7fgdwD3nhIHVr2eAGLQb+x/vwdPDQvjzMZFSfeKsrVfaYywwu+bpKA84g3Dm/WMOHDsWDi96gefu7LHkOnBeH7T59R8GVGP5VXvx77n698AOY4iZJbsyoEFxQeuV/rKneuoEtbw+2X4fV6v87rkUcKy+iC37uYkrEb8wY/+wZQ7Z1NYyypxODwJvo5+8M7FZbYZl2/oEA1A0XMRIHOk4R3Np20TIGz//IvTE19b3VFwBPqg6dQNGYr8A13kxMupe4V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 09:37, Harry Yoo wrote:
> On Tue, Nov 11, 2025 at 08:22:05PM +0800, Baolin Liu wrote:
>> From: Baolin Liu <liubaolin@kylinos.cn>
>> 
>> In barn_shrink(),use LIST_HEAD() to declare and initialize
>                   ^ nit: need space after comma

Fixed up locally.

> 
>> the list_head in one step instead of using INIT_LIST_HEAD() separately.
>> 
>> No functional change.
>> 
>> Signed-off-by: Baolin Liu <liubaolin@kylinos.cn>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Thanks, applied to slab/for-next

