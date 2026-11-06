Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9179F606A33D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=pvRI/D8R;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AzVXIHVV;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=pvRI/D8R;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AzVXIHVV
Received: by kanga.kvack.org (Postfix)
	id B66C36B05B8; Fri,  6 Nov 2026 09:13:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E306B05B9; Fri,  6 Nov 2026 09:13:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A541E6B05BA; Fri,  6 Nov 2026 09:13:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0486B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:13:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1744C1C4429
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:13:54 +0000 (UTC)
X-FDA: 85404887988.11.B413BD3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id F0951180003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:13:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pvRI/D8R";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AzVXIHVV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pvRI/D8R";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AzVXIHVV;
	spf=pass (imf16.hostedemail.com: domain of jbohac@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jbohac@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbWVk74jXjpvpjgKYrK4/CAQhS2u1tHZBMZnBzvHIS8=;
	b=LXNzwoMpP2dMHt/ibzQvfDYnhFF3i26ABvISEE+inJ5vFIBmrK7x92H1scppFjVPLv9giE
	L8eXFM0p7ZA30tS/Cuv37RB0eRdUWcjdrJgq+tM+cdg6NbSxg3+1p7IEKm07YZjt/8xT2j
	bnW5/gFpGRFVD73emru3rgYpf/BHavI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974432;
	b=SiK3V35XPOXP6iAvbVBK1i49d1QIkwWwSQVT2Ms2G9oFftRm7nF3L1V6SG8yevRlTTcrLH
	vpyZ6tK702NuPGBRbTifXZCKdTxFjmqO2tMdBpzrf7hVl6MiuP3Ax9T/5Jrydolhe3JMGp
	joHH5YBdiyJSL1TM/Po+WPFyikVUyEI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pvRI/D8R";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AzVXIHVV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pvRI/D8R";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AzVXIHVV;
	spf=pass (imf16.hostedemail.com: domain of jbohac@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jbohac@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A268E22130;
	Fri,  6 Nov 2026 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793974430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbWVk74jXjpvpjgKYrK4/CAQhS2u1tHZBMZnBzvHIS8=;
	b=pvRI/D8RopcbFtgNPfW+iZ2eH21pmmfyjNXaTBk2vE1ikaUyi5ZiBfpUI9DBHxSg056LZ/
	bgaYzzIfmdjyGKdvkKYDTONndhOEEdBNMQoBgWoZ/a8TN+unCtfVpYKTENumVFgNiyx8PU
	jzG6MUyNuwxCdK8tH73YdFpwQlrjj68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793974430;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbWVk74jXjpvpjgKYrK4/CAQhS2u1tHZBMZnBzvHIS8=;
	b=AzVXIHVVE8uagLfECKc27F9aiHHqwykOgSHiYeP032HqnsmkIBLN0HR+sxphwH+ZhZ+jLJ
	ogoAPHclIxaMcyCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793974430; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbWVk74jXjpvpjgKYrK4/CAQhS2u1tHZBMZnBzvHIS8=;
	b=pvRI/D8RopcbFtgNPfW+iZ2eH21pmmfyjNXaTBk2vE1ikaUyi5ZiBfpUI9DBHxSg056LZ/
	bgaYzzIfmdjyGKdvkKYDTONndhOEEdBNMQoBgWoZ/a8TN+unCtfVpYKTENumVFgNiyx8PU
	jzG6MUyNuwxCdK8tH73YdFpwQlrjj68=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793974430;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DbWVk74jXjpvpjgKYrK4/CAQhS2u1tHZBMZnBzvHIS8=;
	b=AzVXIHVVE8uagLfECKc27F9aiHHqwykOgSHiYeP032HqnsmkIBLN0HR+sxphwH+ZhZ+jLJ
	ogoAPHclIxaMcyCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7AC9C134E9;
	Fri,  6 Nov 2026 14:13:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ao+wFZ7g7WoTZAAAD6G6ig
	(envelope-from <jbohac@suse.cz>); Fri, 06 Nov 2026 14:13:50 +0000
Date: Fri, 6 Nov 2026 15:13:50 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Usama Arif <usama.arif@linux.dev>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump: Give crashkernel CMA areas unique names
Message-ID: <au3gnsckVTK6tUs5@dwarf.suse.cz>
References: <20261106104309.3669583-1-zaslonko@linux.ibm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106104309.3669583-1-zaslonko@linux.ibm.com>
X-Spam-Score: -13.30
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: r6axp4ba8hquf5647rnwj8dio914ffce
X-Rspamd-Queue-Id: F0951180003
X-Rspam-User: 
X-HE-Tag: 1793974431-399002
X-HE-Meta: U2FsdGVkX1+YOhqD5Ki7AZ8geDY+IT8l+yVbe4rUl8eigu7n4sT1ViIwHael+jGHpIy1gBq1IT0Aaf6pSSSzbesdnq7k9yddHygIQEw7KLf4FFou9ZNnqQ/McUyy7wmy8L8cIMdyNabuGDfTHzyWeOqeU34wseQ/cQ5sFVFoM9RBbCRez2J5NfWwUGIsMgYP5QEMX68UiWAE2X2ZOFXF/Co46WYvC6jc1IuVIGqbM0+K4QnxN0x/ixwhAA8P1jBV0yHlqVQKpX+BzXWpNL545fUtAVrNy2/Y19Hlr2QairVauPHxwijT+f9Mbr68e7ik8aPz1x8CwRk5Q9XJbDJXBGwqOAtnBqDKkHJnchOBSg96tMW9TAra8umkGpVZLDJPXCVS+xGkwGCl9VJ5sodSwAVqxHGYDq335/xpoyMcYBKDh/2cRDuIQuQ10UUXB3aZGgpI6qGb6dioCzoa7qjhOO4xK+DGyTN1oJEZI7twU+tSxRf4IUz/IeCGkLo2WM4xelelffufLBRTbTXXe7rN25Z2LCJlAbnc03Q9hNfnsMTU4pb7I53Zae3hLWFUf6hchVT+409c50XDQampigvc/ueQcdQeOm4/nbslO+cR1VEbhhEL4qpKA45NkUJMnvYujtXWN5iTJKF5YkrZ6jbdWygSMjQsL6FysRdkCMcn1FMqUBTPXDYzEDvNrrdFw7NyXbJ/vd+9xcrWwe+Wc/YRDXSILfsNoTxZFz/ors8+HNoRDGc9wIre5YvTwmDz5MIpiQDxC+TpXVdnYSmLWZccsQQAlmWZCGVgK5OuMmg+lNLh2Uff+ai9RTNmAZwoASt6tYjTxfr1y9a1sk66mtavdiU3Gx4bd3MGkFKn0s+1rkSWTgUhdPEi+epzrfK9MkjTA9xDVjF0obtb/kcVtrEQow/IpHicEiFNYMwzdgeHVBGmBgSSlYYY4xi5+eFSwQ1sp9gpL0J8V8wN5wVit22
 kINepqpO
 IwzmxcUBqdA7Q92qBkc+juv93oztPk4EqeWGJcbbjnpxNI6+ZI9vZRAS90VdEH0iHprTq7pJOi2U7/xRB6tHeCCkMFmOVRyaGtQ4apGu8L0yFbye/a0LTYTKTP3wUAgBLbtAOIUwAOS77FmeKeiFwTZl1WO8rX1K97roqkVH9mqMN3JMoCtG13TrjnEQnNYGGrNbEdlhOCUeF3gLtd4XgNTU3e0XTrchWBpRkSybjMCTnbN9OVm7KWAuaNTjlE3aA0kQwBDCKdT5Stmdd7ISdd83rWxZLnA/JWUXq042o0vkCLoeGMv+7Ar+mDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 11:43:09AM +0100, Mikhail Zaslonko wrote:
> reserve_crashkernel_cma() names every CMA area it reserves
> "crashkernel". If the requested size can't be reserved in one piece,
> it falls back to several smaller areas, all with the same name.
> With CONFIG_CMA_SYSFS, cma_sysfs_init() then fails to create the second
> directory:
> 
>   sysfs: cannot create duplicate filename '/kernel/mm/cma/crashkernel'
> 
> and the error path removes the sysfs entries of all CMA areas.
> 
> With CONFIG_CMA_DEBUGFS, debugfs refuses the duplicate directories as
> well:
> 
>   debugfs: 'crashkernel' already exists in 'cma'
> 
> so only the first area shows up in debugfs.
> 
> Keep the name of the first area and add the index to the others:
> crashkernel, crashkernel1, crashkernel2, ...
> 
> Fixes: ab475510e042 ("kdump: implement reserve_crashkernel_cma")
> Signed-off-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>

Thanks for fixing this.

I don't think we really need the special case for crashk_cma_cnt == 0 
and that "crashkernel0" would be fine. But I don't mind either way.

Acked-by: Jiri Bohac <jbohac@suse.cz>

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia


