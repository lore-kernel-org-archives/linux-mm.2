Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213A1D3F09D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 17:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA1F6B0088; Thu, 29 Jan 2026 12:02:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3578B6B0089; Thu, 29 Jan 2026 12:02:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E6A6B008A; Thu, 29 Jan 2026 12:02:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0EC676B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 12:02:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE20A1B04B0
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:02:10 +0000 (UTC)
X-FDA: 84385619220.12.C0A07AE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 31091A0014
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:02:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rVLG4EJ6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Vp/0RU4a";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hQKsUp5w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kDHS7+eU;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769706128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2KLAb0gtngg0dMxjuY2YbPb4S1CnU/UGU9Et3A57DXE=;
	b=PCQYCy8uixHMxHP+jWErB2A2yaeDtMwGL1Mc3Gi/VH0oITYI4MxxNiAY3UMY7MuNhNJdL0
	gp6xlEBH+iyuMG5VUj+P7GoDGgauTvfcR47Lna1kF8fQIdYJ9vvF4oyr2bOsIOFkAbHn7b
	pdAJ3N9HPxQRDGP9Fhu3XJDHUg/alX0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=rVLG4EJ6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Vp/0RU4a";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hQKsUp5w;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kDHS7+eU;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769706128; a=rsa-sha256;
	cv=none;
	b=sn/iyW0W6kTIDpWRowejRsi2sLueNZvoJeSlFMKNMk8WnUYm0uOIhx5bTrLaXKa+33uP07
	zc74FNSzfyr59naWQ+gAsBlOZmE0sTv/xP2Lwg8DSpvLz3hUBTKeDzJ2B1vX02whSUjF85
	oyYYP8OghQCEYfmp0i+2Sze5o1zvRNg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 00D4534214;
	Thu, 29 Jan 2026 17:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769706124; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2KLAb0gtngg0dMxjuY2YbPb4S1CnU/UGU9Et3A57DXE=;
	b=rVLG4EJ6s8EwNDY8j3fLtYUPRlFcvgjhDpPIamRLTUBOAr4zb+fBE02HrBlCMzpNGqOmDJ
	pAFjYPO/KYubhVY+MopuRl5nU8pBo73SCwoNRG3O0c1WBizNDrYWmRn9W+IxevUhH2J4nh
	xwMIIQqC48BDquhRUwWewPRrbkPgDrE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769706124;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2KLAb0gtngg0dMxjuY2YbPb4S1CnU/UGU9Et3A57DXE=;
	b=Vp/0RU4am9As4tETfKn3lfMoRaSXfPE7fLrU2KIlAIafgGOhf4QF50hYvLlSIExwIxKjNm
	2B09QdxfHJrLIBCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769706123; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2KLAb0gtngg0dMxjuY2YbPb4S1CnU/UGU9Et3A57DXE=;
	b=hQKsUp5wd5hYClKgBdXf+zw7hxy3yix45gSVNFq6AYWYWHsJ5cUFdrlnRcJI3zGxudzL4T
	fhD1DZ7FFdvJQuani0bOdtncr3Y2rBSaSPP41ROzJAxL4iewIyvrCnGn1rXYbqw+KwQxsh
	DYhMIj7JLIWlTudrVBiU1MsVYvBglRs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769706123;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2KLAb0gtngg0dMxjuY2YbPb4S1CnU/UGU9Et3A57DXE=;
	b=kDHS7+eUKTtrOPTX1c3yX6HezXJHCBJVQh8eTyQFlsD3hv8D3li2P8N1dKE9sFjBA7v+Hy
	YLHMf/bN3cSPNbAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C07DD3EA61;
	Thu, 29 Jan 2026 17:02:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C0eWLoiSe2lZOQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 29 Jan 2026 17:02:00 +0000
Message-ID: <74286aca-a565-489f-ad2c-886c650ea2bc@suse.cz>
Date: Thu, 29 Jan 2026 18:02:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/11] lsm: consolidate all of the LSM framework
 initcalls
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Paul Moore <paul@paul-moore.com>
Cc: linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 selinux@vger.kernel.org, john.johansen@canonical.com, zohar@linux.ibm.com,
 roberto.sassu@huawei.com, wufan@kernel.org, mic@digikod.net,
 gnoack@google.com, kees@kernel.org, mortonm@chromium.org,
 casey@schaufler-ca.com, penguin-kernel@i-love.sakura.ne.jp,
 nicolas.bouchinet@oss.cyber.gouv.fr, xiujianfeng@huawei.com,
 linux-mm <linux-mm@kvack.org>, David Hildenbrand <david@redhat.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org
References: <20251017202456.484010-36-paul@paul-moore.com>
 <20251017204815.505363-12-paul@paul-moore.com>
 <20251017204815.505363-21-paul@paul-moore.com>
 <0146e385-935b-4f66-9e6d-51bb47ae4bdc@lucifer.local>
 <14638978-b133-457a-ae9c-31ba54e3964c@lucifer.local>
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
In-Reply-To: <14638978-b133-457a-ae9c-31ba54e3964c@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Stat-Signature: 3jcm3rc1t1jfqnscn4ooetcotjhyc5w7
X-Rspam-User: 
X-Rspamd-Queue-Id: 31091A0014
X-HE-Tag: 1769706127-178928
X-HE-Meta: U2FsdGVkX18A3yb740jlsUzcrGu+CIMri3Md/VLT1ZABuMh4W1FrU6TnjxL/up1GsaKyFy5ZRdItuiFnLXLaX5LJ1HqBgZBFkjajjH3ZzC/nC1ocNDwYiRnuaRGdIJQ3LW9BB7WDJgI+rkZBgOza14/n+dkJhbhcQZFyDtHd2j+MHWgSeebTDGwdRVVR0b2ABy1kzxLdeCzZVXWef51DG/gIli7tuxonrEu3XhHGYNn5R458+ZOx1QnFiJTXInTy2/xneRoi+vRAmCZ9Cz2kCTkqPqkO9HNX40sELEn/Oy35p214iM70AlrEN4W/q0GQI2XwJ3mTy9ICz+rDAGdeedyj6hC9doH/XFe5V5lhY5AXAO2Tf+sWGzTNu5cn+RcXBokDpp2DjaShP9RgzVFiLrBcv71PXYLc/JCvYzna7KjH+qfh/PEwvG3FH9MVfzeVUNibJtyEaz2uyMQb/RNct1y089hBFvauY49afYUDy+IUepdcpgTRE+wmiboFfNQLt69jeyiLIZUclCm3IyceYzrpyH4u4vyDrXuWm0f63SbKm5/o8e17ImHwn78HW+OhbkbrjiWT8+uJFT8LQ2RXbNG0OHbp1c33pEzqGkQcBYP1RnRUm9noDK2NQ2WWYrirk9j/e1/uvoxJTTAXmvsP8vAvFZUQxVDjf7gVXRK5syNIYBwb3dYcHfOvOeS6qU+rxDtRwEPkiFUnHOoccyt/uCrM3eHFkt2ReO98XlUxjLdh8PncyF+EDOeqphkSAeWcFVD2s+dFHMCSFnAdSB5SVQI5Ae059kqoExMf5u62kh8CH2MTj4l1fTmgCdhIO4MTgd8zOyNNRSQucfYhiVywBiySgG92vFpvo7K94Yp36Xi37SKNEnVNsFfQBantoKDR7/wvKwyrWwvxUzeGRcTr76uP7jct/bRltHxcIWjijME+Zs+eD1IVUBYetkRRqe2bkTcniADwILSnxui4HGW
 wvt5U7Zq
 mCRhQORlm2E1dtqmDTurKLHFcPVfMiXBNpKjFiPVqoJ2NLrajkFn0daiFtdfAFwOKfNC5+a8GVyo3ru+ng1OvrIMwJz+NALImQjiJ0TOH1Kg52K7q2VK2DwSDChtrCvkKvC0Y5UADJ70GobUSV+SsdwxA5W2CS/Lg7iijeQsQEauh0FGLjpDQJ6HeykRKhYu3lTaFfXedOXfz3OkcZEA+s/o2lc8Ys8A6X4JX0HGp5M++42lh4ZdLyKaDvuqCwHeU4imA6czpBa+juaxkrb263qNni1Dw5lq5P3Px
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/26 17:48, Lorenzo Stoakes wrote:
> On Thu, Jan 29, 2026 at 04:31:16PM +0000, Lorenzo Stoakes wrote:
> 
> Sorry to clarify here I meant to say - if I set CONFIG_SECURITY but _not_
> CONFIG_SECURITY_SELINUX the tunable does in fact still appear (and afaict
> still work...)
> 
> So LSM_MMAP_MIN_ADDR is really weird to require SECURITY_SELINUX, perhaps a
> historic artifact where we wanted a different default or something like
> this?
> 
> I know that we use that in preference to CONFIG_DEFAULT_MMAP_MIN_ADDR if
> specified.
> 
> The description really probably needs updating.
> 
> The key config here we should be looking at is DEFAULT_MMAP_MIN_ADDR which
> emphatically does _not_ require CONFIG_SECURITY and also in its description
> explicitly mentions the tunable:
> 
> 	  This value can be changed after boot using the
> 	  /proc/sys/vm/mmap_min_addr tunable.
> 
> The mmap_min_addr global value exposed in min_addr.c is referenced in
> several places in mm and other parts of the kernel - fs/exec.c,
> fs/userlandfd.c, kernel/sys.c, mm/mmap.c, mm/vma.c.
> 
> So this now silently going to zero everywhere and ignoring
> CONFIG_DEFAULT_MMAP_MIN_ADDR is surely a userspace-breaking regression and
> needs fixing in rc8?
> 
> Which means that... people can now mmap() at NULL everywhere despite setting
> CONFIG_DEFAULT_MMAP_MIN_ADDR > 0? :)
> 
> That seems like a _really bad idea_ (TM).
> 
> So this is emphatically not a report of a trivial self test break, but
> rather of something more serious AFAICT.
> 
> So yeah I think this has to be reverted/fixed.
Agreed, the mmap_min_addr should stay visible and applied unconditionally.
AFAICS the only relation to SECURITY/LSM is whether CONFIG_LSM_MMAP_MIN_ADDR
is used as an additional lower limit to both CONFIG_DEFAULT_MMAP_MIN_ADDR
and the sysctl-written value?

