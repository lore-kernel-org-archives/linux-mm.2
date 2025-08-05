Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEFBC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 13:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D266B00A6; Tue,  5 Aug 2025 09:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5AC6B00A7; Tue,  5 Aug 2025 09:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3D736B00A8; Tue,  5 Aug 2025 09:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E108A6B00A6
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:52:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6946F1406D2
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:52:48 +0000 (UTC)
X-FDA: 83742844416.20.3226A44
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2AB4B1C0006
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:52:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TFaK1Air;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/oIFz6ep";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TFaK1Air;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/oIFz6ep";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754401966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QiAh53zY1lvWrZrojt1yd+p+oDdF0IdKFV8KZZpy14Y=;
	b=Xs49Ic/SOR9ozdOhjukA5t7R6pXLCHcqjVNqEGLm6MYkQAxmwVIcyWYmKra/EPWzTKWKRP
	lJPNcEkMKJfw3lIIQ9cdJJIvyTJ87t0tE8Ulz6YhdDy+UU5Ab5pCqBNNjYhGrnO47GZGZf
	uz85Ewjeg9ubduFpADPMVM9Y6JRI70k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754401966; a=rsa-sha256;
	cv=none;
	b=YjBZ3Kl8hZTOGuTA9ih5U2hRINx8DbDreRQNliEKMfXRjLTE43UjcY/qrgs07JpcI8eT8+
	YDq25cHwTpkIdt0QNJrQJEM3PXUYbJo4I6Vqs/3/5zFJVdCDmXC1UzMkBLA4vXaV3k5H2y
	HbXX1KqPMzSOe53dA6G9PIEXmFAYlD4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TFaK1Air;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/oIFz6ep";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TFaK1Air;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/oIFz6ep";
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 925051F38C;
	Tue,  5 Aug 2025 13:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754401964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QiAh53zY1lvWrZrojt1yd+p+oDdF0IdKFV8KZZpy14Y=;
	b=TFaK1AirMexI4X+ZixOzrgEw3F9VDJGrF4Y9gA6fnYAVLnSEHo3TFPtyZ0oiReyNqjuEyD
	eyJYoB4sZUR6vnlP5PN4MBl9vv6tMSrAMDMlbigQuArtx4JQHngIJgFa/eHVuzLQKYl2G1
	Wf4W+zi54se9wsrXMVLq/HjIVxVD/TA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754401964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QiAh53zY1lvWrZrojt1yd+p+oDdF0IdKFV8KZZpy14Y=;
	b=/oIFz6ep0M4knK8jczmZOc0+Qyd5T/bnhVZ6KqhKwOb8us1kG9HHzyRE5cDBTcqKBBvPnL
	Y3JOJPIk40Fge8DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754401964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QiAh53zY1lvWrZrojt1yd+p+oDdF0IdKFV8KZZpy14Y=;
	b=TFaK1AirMexI4X+ZixOzrgEw3F9VDJGrF4Y9gA6fnYAVLnSEHo3TFPtyZ0oiReyNqjuEyD
	eyJYoB4sZUR6vnlP5PN4MBl9vv6tMSrAMDMlbigQuArtx4JQHngIJgFa/eHVuzLQKYl2G1
	Wf4W+zi54se9wsrXMVLq/HjIVxVD/TA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754401964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QiAh53zY1lvWrZrojt1yd+p+oDdF0IdKFV8KZZpy14Y=;
	b=/oIFz6ep0M4knK8jczmZOc0+Qyd5T/bnhVZ6KqhKwOb8us1kG9HHzyRE5cDBTcqKBBvPnL
	Y3JOJPIk40Fge8DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 776A813A55;
	Tue,  5 Aug 2025 13:52:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DfPoHKwMkmhcJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 05 Aug 2025 13:52:44 +0000
Message-ID: <1eb5d0ef-efea-4ed5-85b1-bf4f685ddb90@suse.cz>
Date: Tue, 5 Aug 2025 15:54:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] fs/proc/task_mmu: factor out proc_maps_private
 fields used by PROCMAP_QUERY
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com,
 peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, mhocko@kernel.org,
 paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com,
 brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com,
 linux@weissschuh.net, willy@infradead.org, osalvador@suse.de,
 andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu,
 tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20250804231552.1217132-1-surenb@google.com>
 <20250804231552.1217132-3-surenb@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <20250804231552.1217132-3-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fk3wer7mgg1q59edmrcouuobmq7is5ph
X-Rspamd-Queue-Id: 2AB4B1C0006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754401965-691252
X-HE-Meta: U2FsdGVkX18Hapu/2GsmHMqjJF6VNiIBQ5M6iW3eM0VAV5FpwjxxqNsZ+e/l3Pbox6tpus2ZYmyae4AMvTBWxJd+KxzDj1Y5exgBDdBJl+CAgR9n+8zvndERSIEWmGNORVBpgw9XwE5nhOkaI2Lj0fsgUMYJJcTeFpmfFvml4kaW++8LRB0BSEAMrUDH+INPp7kP78/lvg10DM5WRiAxkTMcX8WrdKH57xunuqYmVz+LGU1SPdrbtVw3Yij54B3YscMexng8njhaoucMj+Q8G6KQYYmMRGlDL6G+ZcKEoi0B2fsXVPQ9/exHYj/9RgcC+wFbdDQtvXG1VtGpUtM28XrK7ijZQOop1Vhd4MVeqyyIZtLZYbR9KuUemhYr4btDibHYW6fCpMid83kIrKnOB17nCocYVDjzpT72WuCMr+5ywIserN1lYFYTHt3DPzTMcYPD+yHOu82EnvRryZtRxX1nzqTJDsXMON7JTD2ANZRlZHStCQ9SItz3Xc/OLI6yvRh4xjisl0m73pvueU2kvhSi1grSM1l2EggYWgju2J+rTTfol5mbXfUKnfjFwMCp4YZ7VdlOdT8x2Ic2taFsKWHPPY2QSbqmTN8CKIph67C9BzczL7nBZHCVfDOYlVsD2LZisOEgK6O4uCOMbea6SPqTLsJ0oA0QdOSRtZney+F/7+kAZpiRNNiF45FU+qKADjnt4GpYoj08zvwKk0ivQpbWdvESdaWDrl9vHn5D3yupAJq7UqzZA7PWFDN8DplkpvxY1iMWvr4r4WS3wq67IJybJ/pwVEDAw/XsIoj9i5knJRFqIZJcT1lqYgEX+iQwLbQIAF3L36E8SoKOBPPnhZXi4vhxOkK9yJl/p7y/ZfnTEAgZD2+GQSMIYVDLF0h1UsD6p2Od9mgOfhDO2YYrQ3Dx+SiS5X6TDKV5V28ErVRFlftLpjZEfJnDo7ihjdZFbItGKbUQXA+vxd0DZ+q
 Qbt9Domv
 bDdXoIaN6Xa11nyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/25 1:15 AM, Suren Baghdasaryan wrote:
> Refactor struct proc_maps_private so that the fields used by PROCMAP_QUERY
> ioctl are moved into a separate structure. In the next patch this allows
> ioctl to reuse some of the functions used for reading /proc/pid/maps
> without using file->private_data. This prevents concurrent modification
> of file->private_data members by ioctl and /proc/pid/maps readers.
> 
> The change is pure code refactoring and has no functional changes.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


