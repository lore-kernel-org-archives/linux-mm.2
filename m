Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9AFCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 12:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19F938E0139; Tue,  4 Nov 2025 07:57:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177348E0124; Tue,  4 Nov 2025 07:57:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F648E0139; Tue,  4 Nov 2025 07:57:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EAE7F8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:57:39 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BCF412BE83
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:57:39 +0000 (UTC)
X-FDA: 84072926238.18.F7BB887
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1A78640006
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 12:57:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ocxp9Vs3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cqK8EHzF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ocxp9Vs3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cqK8EHzF;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762261057; a=rsa-sha256;
	cv=none;
	b=YtXY3OKh0PW9s9LXHpBs49tshFOuyeZ4HP2n528m/Bsr4Ui1K8RX1dm2506DwNK5GMg9dn
	z5B36izJMA2XZcnyuadR3biCa/d0ifZ9QG18p4tJ6xeg2+ST5+3aS8ViDPt/c4WWKNetzW
	4TvYtEkmHykUTCnSOOuI5zaNSxQpwLo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ocxp9Vs3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cqK8EHzF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ocxp9Vs3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cqK8EHzF;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762261057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRbSnf5HPjCvD5W0ZK49O8zVxenDHk8tqcNADgcyFzM=;
	b=ugbnPtpjrtiKNZEgHuUKSB2i8k4QbtqwYxGADOA+7cQkMbFFoSzKcD+xhtvHyfzNYnp7cS
	bybhR3Tkl3j1MTW/au4KxqjdMxMOtOGCYRFknBsUVMB2ZHUJ7xFDRL6lYSl/LAB1S+eDUC
	EIaB2ywwHkLUpwAVn1Z5f8R4iMnsrsU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 806B31F387;
	Tue,  4 Nov 2025 12:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762261055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRbSnf5HPjCvD5W0ZK49O8zVxenDHk8tqcNADgcyFzM=;
	b=Ocxp9Vs3i7eYnIeXk8HbPCIwrBJYvAlsqA5UaQMCjulJV0oSiv54ACLl83Z3Gcg37c+34w
	pfVo+/YVR+ask5Lsa2L5HwZbHMdAaGNqU4aXcEZda6JciGS139vRW99KqOdYirbl6lPEnF
	Pv1q88TC5CxHek41Tmqu/ZgJlaypUyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762261055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRbSnf5HPjCvD5W0ZK49O8zVxenDHk8tqcNADgcyFzM=;
	b=cqK8EHzF4XHsCKDdkHSTbHDzL56QBJ6ElBJ//q/4o6cWn6yMZLV55+7+hVCpWDv5+HgOhI
	o4ZYjIRou1ha9tDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762261055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRbSnf5HPjCvD5W0ZK49O8zVxenDHk8tqcNADgcyFzM=;
	b=Ocxp9Vs3i7eYnIeXk8HbPCIwrBJYvAlsqA5UaQMCjulJV0oSiv54ACLl83Z3Gcg37c+34w
	pfVo+/YVR+ask5Lsa2L5HwZbHMdAaGNqU4aXcEZda6JciGS139vRW99KqOdYirbl6lPEnF
	Pv1q88TC5CxHek41Tmqu/ZgJlaypUyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762261055;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRbSnf5HPjCvD5W0ZK49O8zVxenDHk8tqcNADgcyFzM=;
	b=cqK8EHzF4XHsCKDdkHSTbHDzL56QBJ6ElBJ//q/4o6cWn6yMZLV55+7+hVCpWDv5+HgOhI
	o4ZYjIRou1ha9tDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6DAFB139A9;
	Tue,  4 Nov 2025 12:57:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id De18Gj/4CWkKbwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 04 Nov 2025 12:57:35 +0000
Message-ID: <188a95ba-6384-4319-bb74-c0d9ec6c4079@suse.cz>
Date: Tue, 4 Nov 2025 13:57:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to
 BLK_MAX_BLOCK_SIZE to support LBS
To: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, libaokun@huaweicloud.com,
 linux-mm@kvack.org, akpm@linux-foundation.org, surenb@google.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, jack@suse.cz,
 yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
References: <fwm7tynepbnpq3db7u2fqrzmeq55gs5472r7wbggxmndap3k26@ngwgdcy26vxx>
 <qfo7raavlfupjqwbgl2mnmfvmn3z5oslnxcehorib3xjdgf4yo@bp76xmxplre7>
 <aQTb0NdyN3tU50ss@casper.infradead.org>
 <k6k5azen4otnvlc35hj5ak7dmz2gxbb4lrgdu7cirewotggnp2@55cywarovlvs>
 <aQTqELGGKCN3JTIm@casper.infradead.org> <aQhf5LJJMlvT-rrE@tiehlicka>
 <9d5790f0-4a07-4cca-9f94-de101084a7e6@suse.cz> <aQh1EmVd8IPHK0Gh@tiehlicka>
 <aQnV73KorhS0AWH5@tiehlicka> <a0015508-e72b-4b1c-9993-7e66076a0a19@suse.cz>
 <aQn2fIcj9LduzsmI@tiehlicka>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <aQn2fIcj9LduzsmI@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A78640006
X-Stat-Signature: ug5i8zam5xad5tpgq4ztc7p1k3aiind3
X-HE-Tag: 1762261056-155801
X-HE-Meta: U2FsdGVkX19EjmUUoi213H8jm+67E72BElWEAgjdMll99nU1yb6yCAtfBUn7DnGKCdt0+8meuSvMSM9zZVX/FhM3jXctnxxUV5mjAPgRNgYLBH7sbqgqapF8ynuvdvl17l6gqqqYDKTi6MLUoHQwiT9OEZBcugLWtqz/cQXFWjzjK7YELwE6/fmyiG5bZ/WTnyT89+lrZJJMOuBu0zm3o5n/7YM5vhDI7fvKGAJnbagLdpDdn8X9YPjhVA6vJdx4W1R0rt2VEam5QrrjeDU/HQtY1T99bFOlf1tI7s0UBLKZCPPHnAbf/UwNeJg8geu2Pk+P2AgEipYkw0deg+Qlyzq1ak+eC6IPQtoqoXVGs2zluz9vbPMWzFzN5aM3LBvxe0+ZVd1jYpoxFEtJW2bbdYXxCrdMNKOGzeS/mZGPDHuVv/kuo20Nhqk0huAPo46wYzsGpOVW0AVT1My5IuhOKM6lG1Ac7VGN8OKvKlJTPnlJcYf6+K6psEZMkybVpPIdhm7RmhKIvZCkcRC3lMfkUTGFDzF/JxuEu4kca1RsZ5x9NcNV5dRlZ4FMPXocAh6hs/bovXBvFzvfuoa7aV3B+u1RCbAm4Ozx1X/na7j020fA3WGkB8jfUQMCdtIJBVyOGgY5/hpyzeLRdJjKkphP5ONfjIPA8Im1ugMAZOYLJsT3mrxzXy+q24BVigBdbC91urR81mM63/m1RM/o7LheEnlzMIkFlNA1OFQOiHxOYbaFIlav56iWUZ+iv84X/M+HEv9Lc+FdD3i3vvl6oacia7I2GpuEt/QwIlfXM/rVSwbB25CBTjCtsgSjXHJ3A0qpDioQ6Idsg6kQ7EVAAxF1MVPoaz7AxHDXFOwvZVznmrUTYwjwaHbMDKwR6ti3YUNMz7ttRBhEnrRm+LkIP/LCSnScoZwTlgbfrU+akwAtUV18Zd9LPdHeDM/CeW/C9mjX/2e6bRXeVl+6LoJDbej
 Cbat0frM
 fvwfzkG1KzGqQZF2RgPgisSzcXoQ412aFrU+gG7YrFHxSFOWwG6hiuLCb62jKm7Bg0YcAmHiGjf4GKnAuKTxbWHIIN80x84VWt6CvKtDKNwtmv+keK7Og8d5bhThecLADl8s5FvoBL+Jan+W71aPq1pp5yHCUEFpTbHSrSnxJ9NwxvY73+LjjaIjhGlsdJZ8f8dh2XzsKYvE0JMLAYxR3ZPm+3VpA88J4hdg0P1zJE+V2CwxUYn7Fb8932RlcxEfDfO3iNW9UO5ykCA9Ych7hp8a4kWfCN3RG5ohDGvDdn5WULrWA2Pzn1A2HLDKCAYTHBH3Uak6i69rjeRo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/4/25 1:50 PM, Michal Hocko wrote:
> On Tue 04-11-25 13:32:52, Vlastimil Babka wrote:
>>
>> OK, it might not create an order-3 page immediately. But I'd expect it
>> allows compaction to make progress thanks to making more free memory
>> available? We do retry reclaim/compaction after OOM killing one process,
>> and don't just kill until we succeed allocating, right?
> 
> Yes we do go through the reclaim/compaction cycle. Do you think this
> warning is overzealous? Th idea is that a flood of OOMs could be easier

I think it's too odd to warn for a specific order and not that or higher
orders. We would risk someone would make the allocation order-4 instead
of order-3 just to avoid it.

> to pin point with this in place. It doesn't have to be full WARN_ON,
> maybe pr_warn would be sufficient as the backtrace is usually printed 
> in the oom report.

With gfp flags and order also part of the OOM report, I think we could
risk just removing the warning completely and seeing if such (flood of)
reports ever comes up?

