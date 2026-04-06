Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBCA0EF4EA4
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 08:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090066B0088; Mon,  6 Apr 2026 04:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0199F6B0089; Mon,  6 Apr 2026 04:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E23276B008A; Mon,  6 Apr 2026 04:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD7146B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 04:35:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C6AD1B78A8
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 08:35:47 +0000 (UTC)
X-FDA: 84627472734.02.92BD097
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1A4B1C000C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 08:35:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EuZWg+9w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="2pmHk/tH";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EuZWg+9w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="2pmHk/tH";
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775464545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGn3YqVusQfcpkRlU/Al/6e+9PEsnYlLqJj0S0m0v7k=;
	b=ixq1gelksFDQfZ4VnD3GRNM/4BOEQkCSy3HNqBN1nElYi+Ytyo+HnI0Vhk0eL3fuWCmsYd
	/MlhpPxdrMuNK2X4morxMi/DU3LfMAfRU6iAJEh8mCP52VfEXX2jhZvpVrVQvrEI9anj60
	/39t8HDVszitTHThkoLH/zqOFw2Adzc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775464545; a=rsa-sha256;
	cv=none;
	b=AJX/pxmsEYGhJ+BuFODPqGabqwL2Ikct+H9upy069fzPyZ0dRH/7uuvVnCvJE/WvD6TBag
	/83EG0RIKRnSZVreqhTEVRf2Alw7jPbfgh8mmz8R/ZgKJx8JPDGqK2yKdqPu/FJP4W8auP
	xtD2NPSmDv1Fr+XnoZpLqllokMOyO2U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EuZWg+9w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="2pmHk/tH";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=EuZWg+9w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="2pmHk/tH";
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 71BF35BE07;
	Mon,  6 Apr 2026 08:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775464543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mGn3YqVusQfcpkRlU/Al/6e+9PEsnYlLqJj0S0m0v7k=;
	b=EuZWg+9w9RbxXJp7OB9syQGDnt7KHZL/sl66NwO23c4RFBz5ZbCkTNm3hL6DjjaqLEYFWB
	V0/nZXDKgdxj6xfp0CxSNQAq+14C4k5es56AUo3FWr/sUG1m5gIX/pSSkqh2y7Bj0bAkuX
	8qqAxStk17fFzBZ3XgJJ/T90zi+IiyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775464543;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mGn3YqVusQfcpkRlU/Al/6e+9PEsnYlLqJj0S0m0v7k=;
	b=2pmHk/tHwbWs0sP75f6badDDoruGdJKfNjFLA86DRWalUIEu20DhzpkMPXjoyKlJYus5rA
	VN74UsBnsBS2cWAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775464543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mGn3YqVusQfcpkRlU/Al/6e+9PEsnYlLqJj0S0m0v7k=;
	b=EuZWg+9w9RbxXJp7OB9syQGDnt7KHZL/sl66NwO23c4RFBz5ZbCkTNm3hL6DjjaqLEYFWB
	V0/nZXDKgdxj6xfp0CxSNQAq+14C4k5es56AUo3FWr/sUG1m5gIX/pSSkqh2y7Bj0bAkuX
	8qqAxStk17fFzBZ3XgJJ/T90zi+IiyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775464543;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mGn3YqVusQfcpkRlU/Al/6e+9PEsnYlLqJj0S0m0v7k=;
	b=2pmHk/tHwbWs0sP75f6badDDoruGdJKfNjFLA86DRWalUIEu20DhzpkMPXjoyKlJYus5rA
	VN74UsBnsBS2cWAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 778D34A0B0;
	Mon,  6 Apr 2026 08:35:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hTG7GV5w02lYIQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 06 Apr 2026 08:35:42 +0000
Date: Mon, 6 Apr 2026 09:35:40 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jannh@google.com, Jason@zx2c4.com, shuah@kernel.org
Subject: Re: [PATCH v2 1/2] mm: fix mmap errno value when MAP_DROPPABLE is
 not supported
Message-ID: <aa5xuslgioyrxko7lmkwp6y25v7smyihjcbsnj62lvc37otec4@74bk6pmugq7w>
References: <20260402235933.10588-1-anthony.yznaga@oracle.com>
 <20260402235933.10588-2-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402235933.10588-2-anthony.yznaga@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1A4B1C000C
X-Stat-Signature: sspypu8jmypup8usdx7jqujfjex1xyjg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775464544-131017
X-HE-Meta: U2FsdGVkX1+fAA9o2X4XKOESSzL/24j6EvlZ66sNcWLzB8xc24KEc+UmZ2NP2jDgZqTrBLT9JH2B7XWrlfTy3SZ3Ut3YnS3adlBt68+cwiAFf1xCvA41gvvLbIEL1a/+06TsutScfqrU41FWVAh9NSsYbcvDBm9i+yBdQ4r5Kraala5t2dEgQzkOdOjryhjKxreiMghYo1OXh4f5k9B1/mfFzElLk8XSl9JlRBX4Np9oJC++Q8HEKH83ygffpSyXxK8g7dWcImVXCd5S3Siqa0MHUW37HbvjxeBVxihgc/NHoxFghco9fduGVIDM2mTrq30I2eW6lvZ8N6Sj/Xjfq3HtowaH+jh/pjv+jH5UbomvVG/oIRzwm1ecMpEXCYdzYv08kauWWYTFwyN0TKDDsk4ST4t4wgzJofD6CprFsNDPZhjkwHweAoMFs/b/NqeF0RaEKzf89oyHOC1ViPcLw70GjWtQeZU7RFiKqtzqExupJDu+JIHtySbzwEG2IzwW+8WO7wDykqxHcd5Ir0bCiDnalHL05G00k1irFdXExmaGOU/RTbvgRXqDpWEXIhxlWP/O+geszqeBwOqahzQ2luPHRw1L+Y5/R2Z3LyGVTh7vouLFmpK0QQYQw0q21dtPAtQqHls8YI2iFZmRB+rI6mv/AxHohSPHCyavV5BIW2WyW0IGfQoSsd4g6Tx7Tz44ohCzfTpZjN2gqT7tVHexgqRQlq29x5d7NCZh0sUp1winENMcrU/83cs/TZwYwTTz5mJlqqwnla0MGC8Yuzhr127B/76rjRyxuevrqxVP+0KHqQLyAu7hVUc7LQBW92iXbqpHxJGv5oVIHyr5SfHuXPTDGPU+mS7nhvrPnSY0tGnNBVooeDQf6Y+RLzm9p6NFJ8u0tmQvAzT5FA+XO8/o5MFRN7sHfCVcSVeMbWCe9lflr5/qd7E8nD7i1QqOqetCqFM+C0csZsijmgu6svB
 A1BDJZwF
 wUYdSIp54Gsdv0MNGmpcZRPYrIRUgFCNGAIaB2fpAV4AySlliFIsSWuW9sLClSEtOBJvxmNwnydR2xWhewFdYEF8lDtf6ncnUZqUnGx9IayLklzVeSH35bXOWDhRtIXDJeJ1H8KOrul1//W6K5BL2eb1ok3mhx9yihmRe4qxBoKCY/zSYlkjXGzAld60FOEizRuz1Ma8wtPoCi45xEE3FbS1/oUOqedIfxsJ76svHQgLkOGIcE80yDntR4EpPKBUomXIaRwt9e2LpHoLkqo2SUm/mhsPrwIGA7ne5m9tdbv+HfY2grYBI4anmUT/gvmH9UoQ5bAtWp/L3ZRbPxBphAkKdw2dfBRqfK4VV9lO6o7sw5ZYbiydbkfd/FCOTevSYzvfaeb7B27itl1gR4LDXalUXCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 04:59:32PM -0700, Anthony Yznaga wrote:
> On configs where MAP_DROPPABLE is not supported (currently any 32-bit
> config except for PPC32), mmap fails with errno set to ENOTSUPP.
> However, ENOTSUPP is not a standard error value that userspace knows
> about. The acceptable userspace-visible errno to use is EOPNOTSUPP.
> checkpatch.pl has a warning to this effect.
> 
> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>

FWIW I'm not a huge fan of EOPNOTSUPP here, because there's no precedent for
EOPNOTSUPP (it would perhaps normally be EINVAL, but the kernel does recognize
the flag, it just can't implement it...)

Anyway,

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

