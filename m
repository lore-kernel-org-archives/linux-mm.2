Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C99C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5135C6B0099; Wed, 23 Jul 2025 05:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C41F6B009A; Wed, 23 Jul 2025 05:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA2B6B009C; Wed, 23 Jul 2025 05:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DBB06B0099
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:12:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07F60160530
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:12:27 +0000 (UTC)
X-FDA: 83694963534.06.B6ED7F9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id A8AAC140006
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:12:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="jmeKu/kD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Dbz1NhsD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="jmeKu/kD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Dbz1NhsD;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753261945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdAiNS6VWlnCR1LlIYd3kVNJP7PQkgVoL3Myd4rUmjo=;
	b=7zNtQpl71McFdp2YBxWO4Y1+GaXYh94yNjS2dbXcsJJyYQG1g7bLI8DviKyZZMx9/JDkh/
	Y5ZarqlPTIy8k8mirf6fxntgtZpLcH0NeJusvKKdg6evX3AwUM3QZPdBEqD8/UFDYf4yJZ
	EdmS0ynpu6CvnI6fg4E6h65A8SgZdbw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="jmeKu/kD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Dbz1NhsD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="jmeKu/kD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Dbz1NhsD;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753261945; a=rsa-sha256;
	cv=none;
	b=aEnXOL3ioMCQixG5P8ZyAadW6DO49eFFw+uabRWL1Az/5vnDhEISuSVUeDeD+ATMRopcDg
	+W9cpiZTLQ9WfnAfT+04CDQvAjwrP4YkxCXDx4QO019t7uzvC+M+t+frjrz7fGCXGpl4QZ
	sGdAGkUnVkjR/QFg2Tm3X8A3PKQNGDo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 31870211EA;
	Wed, 23 Jul 2025 09:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753261943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gdAiNS6VWlnCR1LlIYd3kVNJP7PQkgVoL3Myd4rUmjo=;
	b=jmeKu/kDGnpYgn6Lu13qSQ43V/s1YWHh0zJsm3vLnpkB5oTVeG3nYdbVMKg7syHqa/lxwB
	Oa5uHJhIQmN4IWRx6HGgo56eFdgCPoYQAIqVmi7X/P0rGOL6ouJhgkmLlosiTUQWoBRKGQ
	MTsCydRTOYmDGMqIHuZSADYhaKNfZ6E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753261943;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gdAiNS6VWlnCR1LlIYd3kVNJP7PQkgVoL3Myd4rUmjo=;
	b=Dbz1NhsDMcSyX82JRXh5fZOK4Er2gvkInOtsso/QPPtVrxNGrXLE8BiYAA3OVYY2d33mQF
	QfsSPpbZ5lG/ldAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753261943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gdAiNS6VWlnCR1LlIYd3kVNJP7PQkgVoL3Myd4rUmjo=;
	b=jmeKu/kDGnpYgn6Lu13qSQ43V/s1YWHh0zJsm3vLnpkB5oTVeG3nYdbVMKg7syHqa/lxwB
	Oa5uHJhIQmN4IWRx6HGgo56eFdgCPoYQAIqVmi7X/P0rGOL6ouJhgkmLlosiTUQWoBRKGQ
	MTsCydRTOYmDGMqIHuZSADYhaKNfZ6E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753261943;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gdAiNS6VWlnCR1LlIYd3kVNJP7PQkgVoL3Myd4rUmjo=;
	b=Dbz1NhsDMcSyX82JRXh5fZOK4Er2gvkInOtsso/QPPtVrxNGrXLE8BiYAA3OVYY2d33mQF
	QfsSPpbZ5lG/ldAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 203B813302;
	Wed, 23 Jul 2025 09:12:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vzaGB3engGiGUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 09:12:23 +0000
Message-ID: <b3aa14b9-5c80-4aed-acfe-bc2b34c50040@suse.cz>
Date: Wed, 23 Jul 2025 11:12:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add missing interval_tree.c to memory
 mapping section
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20250722171528.141083-1-lorenzo.stoakes@oracle.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250722171528.141083-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A8AAC140006
X-Rspamd-Server: rspam06
X-Stat-Signature: q48kyd1tjxg4b3nk7hxwcrmzp7733wsi
X-HE-Tag: 1753261944-430352
X-HE-Meta: U2FsdGVkX19MP4xVIIKMM8vR+Kq0EYahHzuNo9X73+IFvO6NcWg2ELmaW0b6dOdr2b+lOM4M324Ab+DgL92MxBYED0okW2p17o41x4SdLFB8JoUzvDZ/PoKSWNl1wEGuFRttx3OfCVQiqu6ySjqEHv8XLL6sXO7QlZDnlkojbbRW55otj1bZcFdOr3506dj95W4/cwKZnkqUWWJ42cnnt9CnYIgaWHYHHkC/dUnXhTOFvgwExQVRtidiewseNnT7QGuRmRFycANxVo4W442ANZxeAri+SyBsv4jl2V5xSqf9vw+Ya4pKQ0dqKT7kAZ9NMh7kqfncNPCX1mjqGvnE8xnc4nHg8guEEH71n8Du4n3LGyEBsJc6IGVUEmWrWJ2reok6IoHMzcCsxXtDR8gy7jzMxYl5PMt0k5ngIQ8HgXouuVEI9OgmMmwe6aatp9F6cuVA9+EeNArfubp6vxb3qOle5EBSSRDHSvniugmMxRbMPfKnkKvQeqGhSqukdwEt2D3rlVR04oedJdC5rBVlks7RqyE1Ds/IIEC/JbTpgUM4jWsprKqtOyqNuoSKiw957hc6c60wf1J/UzusKRNtH/XraegzNMJE27m5rTalh7+QHmFRpxXSEo3GH5in38hYq5xLqgYIJlsEoUHtcmLwgYC7KnptVkisuCxGnOiPnoN40XgdB9xL2VG+4Ui7ji3LFnkxPHc1R03DxlL6+YHF56nMpQ4A4vBbt9zUd8mh1X3Ed8jPWdB+CbwFfL1ofbRsxkHiVItnk088DwE4/WJ6KutJ6ah3dp9oa8zPJk0qoDzqE5E3qyk//o6sZj5BHV5KjI/hZjI03We+JTCSA8zV+n61wp8n8A+0ugDaP2oN6aLJg/sfha4JyF6cqYp1d5CkdL0K1GP8dEF5Q0QW3SXJgOAirxCzyxYC0BpkcJCRPofn9mwryN0bRSYnHI9EnD4eYOwt1zSK2RzgodCItBo
 eicU1ud7
 7hITJgdOPhFsT8oIWITNO5JO71/qo/7FSKqS9+9X5gwPh3ECD5s7waaEZF3HQUX3dHzarEj2m7NWWmiUGNePlM0rdIm1IVbxUr7nNfB3ORB7xZ2wZ1uyLkS2mwwx7LXvCX/BmkJuALpWiPU8v2Zs3AdmXr+0CDsnKISt/7L+ZuNJbzY8lKSSv93oX486hGzUXCYkdqZM2eYvu0wbjl/VjMRAHWDO+ysgOBS7kwBYsT4EzTS+bqhxG4ypubhFPfQseCOKJIu9nLxJUU6vuBHwf6hxXTY8v7mOiFEhYnx1TDM3IpRUCqq8sYm0Q5EMB5GmG7BWL8HAI/kLJWK+Mydox36g1tVkX4SijQrG0/P5RKI7YdBv9M9eXgYmfZcy8LH4jaHc31NhvSmZk6UCw7jyRVpldLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/25 19:15, Lorenzo Stoakes wrote:
> This seems to be the best place for this file.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 837bc5cd6166..ec8db35c0d6c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16008,6 +16008,7 @@ S:	Maintained
>  W:	http://www.linux-mm.org
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>  F:	include/trace/events/mmap.h
> +F:	mm/interval_tree.c
>  F:	mm/mincore.c
>  F:	mm/mlock.c
>  F:	mm/mmap.c


