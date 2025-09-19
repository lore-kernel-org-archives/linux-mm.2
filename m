Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE7A2CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 06:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 010D094000B; Fri, 19 Sep 2025 02:46:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0388940009; Fri, 19 Sep 2025 02:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF2C894000B; Fri, 19 Sep 2025 02:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D091B940009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:46:10 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 702911DF91A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:46:10 +0000 (UTC)
X-FDA: 83905065300.28.49A448A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0A3F940002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:46:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v5YiIpPk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q4Mi42fy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v5YiIpPk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q4Mi42fy;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758264368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDGGyeA/RK80z6sO+bdZ8MAsem2abesqIqZO0Jb7ekU=;
	b=mYgADrXjycGumG58ZEa9OZSUyKMaZMljR9Ghfa4eOTq67mngaoSEKIOpYTBtwv+rX3SyLL
	7dWlmcS5rw3L233TGVvAD6zfNKtL+HXNM+/aSrdWisfhHMLODdlEqDOKZ1VWnna7g9mTPp
	Tzm0j7mWkvz2vuIu+gmv9EexM2Dmn/w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v5YiIpPk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q4Mi42fy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v5YiIpPk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=q4Mi42fy;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758264368; a=rsa-sha256;
	cv=none;
	b=VhWtzHv01OzPIFAhADAAPwei4hHn/+l2hE2UZeV0Y08xgIVzQoahUuh9tnrF/t+hKHl6iT
	JJmXQIPRiJkSZhoC8c7JkZoRzQJ9qZLENlpGbLthUe8UocLshGwbfC9cLrA7ndC5asmeSn
	HkIi+CfFrfQRlW5Vjb6KtDVXyEqVD7Y=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1965F21FD2;
	Fri, 19 Sep 2025 06:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758264366; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KDGGyeA/RK80z6sO+bdZ8MAsem2abesqIqZO0Jb7ekU=;
	b=v5YiIpPkbl1xKSfBAShcQy3ID7av6mYdAQLTzaqMl3DOejnJyhAQaO6rHs/ESWsgZUEBpD
	D7D5Kk1chPjet6+OYaD/apIDA21b75XczbgW2D6vuMpGvc3SFRopd87PZ2PjeYMlHoasxm
	kk6rCkVyVF09OF856vUwxCoFIBkp+pU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758264366;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KDGGyeA/RK80z6sO+bdZ8MAsem2abesqIqZO0Jb7ekU=;
	b=q4Mi42fy/iMPlMiNymx/6t6BuRBXU3WhsNOBW0rWZAbe6wEtZRKNDOY/b4nXCMmPeS2/lH
	SHNIMVx0SPQVLzAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758264366; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KDGGyeA/RK80z6sO+bdZ8MAsem2abesqIqZO0Jb7ekU=;
	b=v5YiIpPkbl1xKSfBAShcQy3ID7av6mYdAQLTzaqMl3DOejnJyhAQaO6rHs/ESWsgZUEBpD
	D7D5Kk1chPjet6+OYaD/apIDA21b75XczbgW2D6vuMpGvc3SFRopd87PZ2PjeYMlHoasxm
	kk6rCkVyVF09OF856vUwxCoFIBkp+pU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758264366;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KDGGyeA/RK80z6sO+bdZ8MAsem2abesqIqZO0Jb7ekU=;
	b=q4Mi42fy/iMPlMiNymx/6t6BuRBXU3WhsNOBW0rWZAbe6wEtZRKNDOY/b4nXCMmPeS2/lH
	SHNIMVx0SPQVLzAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EA99813A39;
	Fri, 19 Sep 2025 06:46:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EI8uOC38zGiGAgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 19 Sep 2025 06:46:05 +0000
Message-ID: <e8121724-a436-47d5-af3a-a16f81cd0649@suse.cz>
Date: Fri, 19 Sep 2025 08:46:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/show_mem: update printk/pr_info messages and replace
 legacy printk(KERN_CONT ...) with pr_cont()
To: Manish Kumar <manish1588@gmail.com>, akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250918181403.93812-1-manish1588@gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <20250918181403.93812-1-manish1588@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0A3F940002
X-Stat-Signature: bszqr5u443jkwy85c3qcarc7cp7p9i8u
X-HE-Tag: 1758264367-962282
X-HE-Meta: U2FsdGVkX186P64+td2RGeSaTF9WgJxtbjTJ171v89FyssFz374h/1+JjC/FNEE7EuAGzh18erlPZYHQRA7LEDOZ54hicJGZ+URTcmIOCLzRnb7uXmjbmDi+frrKUtMfnkiqNW2o7fuLnffjYvLCwL03k9l53H4rQOCHApa2VMev5okoJxR0MUmCPxDB20FTfnHfRQb94wXUfiHQL80xzG6YUzUZWVm5CZ7ekGUm/mMGqAogtORoR21iAkgmJ8EyS7uvQrjkUbVnWKqnNqq6Q+dSZYC8VdhM3EJirra6Jd/ktaFWwCUavfx+q2qp3nsR2SUMhvtVhL0MTu9wFBUHdL1ANw++A9odby+/xIpJ3DB82GWOUh316pT2IF5pnXrnxheSsClvU6K+eUj+50CwWwuiAvxLqPmp2ykwMeSl61+geKOyly4SW5fUurwTMXrHHKBH7dB35WdXA5hGFLafQjDU2oPN0UiJCzxXNUUlRCwUGxoeUkzPh5L0njnPMF6CaDUNVYKdOmEY51QQ5Qegv4hLDh/20bkOUFoCkM7SVHRaD73FVWi8UW5DJbVSBzTk5/+lvFbk0/ZT4UTZ3S2aW42SrT8CD+e6+8XCTqIsYaPl4s0YSNEVqNqwlIe1W4Gn60SzdHjOI6Ono/XnT8G7FTz52iUEDwY1BKdvwnP9AwBwMoZNgewoBt7fUpU6qeuc66QGLAtv8LqmxMXhNX6ear9Tbesy10Mmur7va9W7vKtRyUsDSzEcbWxb+7ZDVwxeHVr3yDlVG4kT6OBWM4vLvnagoTQNc1MeZjus50ysM8ZDC2gdXm2Pm43R0hc4mbUC8jmlGfBv6fS4MrklMrweIOpeCYQ3DeagqtQzKFUgxI9mBGakxn+sesfP6gGdlVK6e5FFWczSjQXXNyof/R6oaE9XQA6Jk5YN1NgIWzfQiNnqoK9EAnmFrRnoJ20Vrhwe2R4RdJ+qg9NYA1Dbl7g
 p2sze7CL
 keUJWeKyAhykEjEujk1BaxBepk44UnvVZBWRH+1F85CWXuavMq2eOxE3Cxb8qN8GSdEGBrVtrstNXsiGK01VgouJrZkKHhXxgJTNH0Cq/alS2T0plAdRr8ngEtB+8ZCMHsRuTNur+0VhEBbF+6L1YreIdjbUsE5oTOGA2oFC9nZSDEEW4Wg6uL2AMRAQ22pd1GQwF8xWMz25a4ktiuVOzSzNtpwNgEB8d5RgFXloGIK9lFo2uMV+KrwlymZ5jCvBfEOds3DcJv0Ja6Ovq33wAAbI6Odh2rHePHe02O0uOi4Sb5PwsnmnBYn6P4fq8gfDnBd8SoCqIHLfLTe4HRQrgzIzYzO0DGjHRJBwc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog should not be empty even for trivial patches.

On 9/18/25 20:14, Manish Kumar wrote:
> Signed-off-by: Manish Kumar <manish1588@gmail.com>

This changes 2 of X in the file. Why only these 2? And no, I'm not
encouraging to resend with a full file changes. We do these modernizations
to new APIs only while changing the code for other reasons, not separately,
if there's nothing wrong otherwise with the legacy api. The churn isn't
worth it.

> ---
>  mm/show_mem.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index 0cf8bf5d832d..798949d10ce1 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -26,7 +26,7 @@ unsigned long totalcma_pages __read_mostly;
>  static inline void show_node(struct zone *zone)
>  {
>  	if (IS_ENABLED(CONFIG_NUMA))
> -		printk("Node %d ", zone_to_nid(zone));
> +		pr_info("Node %d ", zone_to_nid(zone));
>  }
>  
>  long si_mem_available(void)
> @@ -156,7 +156,7 @@ static void show_migration_types(unsigned char type)
>  	}
>  
>  	*p = '\0';
> -	printk(KERN_CONT "(%s) ", tmp);
> +	pr_cont("(%s) ", tmp);
>  }
>  
>  static bool node_has_managed_zones(pg_data_t *pgdat, int max_zone_idx)


