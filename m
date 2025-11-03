Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8FCCCCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 12:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175D78E0078; Mon,  3 Nov 2025 07:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126788E005E; Mon,  3 Nov 2025 07:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F301D8E0078; Mon,  3 Nov 2025 07:39:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCEBD8E005E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:39:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A714914010B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:39:52 +0000 (UTC)
X-FDA: 84069252624.10.28AFB78
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf22.hostedemail.com (Postfix) with ESMTP id 47503C0003
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:39:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762173591; a=rsa-sha256;
	cv=none;
	b=UGzzjTF6KuXy1eYhXG17nuJZrEfT0tKhfSx/JeUKV+iEWKjbZMPZ2qdQ+vz49VdJ38GBCt
	MjcVHT+obvqaVekwsWGXLu+zSelGkxQV002TUiMGF3E5usCsWjs40ZadSSxo2xJVXmVz9X
	nX0TPHFBCUbHrQjzvXfxXhufqHiZbXA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762173591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GqwW+ikKcHMqpfzJMJht+qhb0tBTn8CGY3TRN/VHZUs=;
	b=UPAownavBAHKDzERzfOteTzBfqG+91Bbk+0/u57lSNh6xW9ElS828lZZoQx2RoOcbBwlvD
	DKLVniOaYo4BUzTSi60yqr/ef/SQuIb1fb8WoJyoqBc5o5qtJIhy1kEQ6+5O9T5GSqyG9J
	KtNkQligAJ60KeC0nfxTLcQe4NvfnLU=
X-AuditID: a67dfc5b-c2dff70000001609-34-6908a293b816
Date: Mon, 3 Nov 2025 21:39:42 +0900
From: Byungchul Park <byungchul@sk.com>
To: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc: linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
	john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
	leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
	andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
	akpm@linux-foundation.org, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	horms@kernel.org, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	almasrymina@google.com, asml.silence@gmail.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [RFC mm v5 2/2] mm: introduce a new page type for page pool in
 page type
Message-ID: <20251103123942.GA64460@system.software.com>
References: <20251103075108.26437-1-byungchul@sk.com>
 <20251103075108.26437-3-byungchul@sk.com>
 <87jz07pajq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87jz07pajq.fsf@toke.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTYRSF889MZ6YNjUNF+BETTV3jAm6J17ihUfMb18QHN6I2MtLGAqYo
	glGDiFsVXJBIC8aqEShCwCq0JWKUHdwIbjXK6oJBrMhSqahIUSNvJ+eee777cHla0SIZyWsi
	9oi6CJVWycoY2WevK9OSr/Ka6dn1AOl5OSzc6I2BzCabBNw5rRSkZxci6Ha/5qC/uAJBV1kl
	C59KOxFcu+KiIf1JAgM9ed9psBe1ImhLzWXhfUULBzcsq6Ex4wMDd45baWg5U8VCYkIfDcVu
	JwfxtqyB4ltxHNQWJkngwvfrNFjjmjh4WpTOQkNOvwQ+lCQyUG00M9CRUkZDY1IwVJh8wfWg
	HUFZnpUC1+lLLDw3FFFQUPycg+Q6EwtvExoR1JW2MJDy4wQLaYeTEPT1DlQ6z3ZLIK28gQsO
	JIcdDpaUtn+hyW3zK4q8SD3HEMfdGorYjfUcMVn2kltZk4neUUcTS/ZJllg6z3PkzYs7LKlK
	7WOIvXkusdu6KJJ4xMmuG7FZNj9U1GqiRV3Qwu0ydZU1hdr9zSum9ls5E4ceyvRIymNhNnYd
	raD+6fziR4xHM8I4XJ/slng0K0zEDoeb1iOe9xEW4we9YXok42nByeH+3FbakxkubMBfHA2D
	ebkA2PrSPOgrhAO4sib5r++Nqw3vBvtpYSq2F7xhPZ20EIAzf/F/7NH4SEHa4KpUGI8NJz8i
	jx4hjMX3CispDxcLp6S4tLof/bnZH9/PcjBnkbdxCMI4BGH8jzAOQZgQk40UmojocJVGOztQ
	HRuhiQncERluQQOfl3HwxxYb6qxdX4IEHim95MTEaxQSVXRUbHgJwjyt9JHrYwcseagqdr+o
	i9ym26sVo0pQAM8o/eQzXftCFUKYao+4SxR3i7p/U4qXjoxDqcPjQfGoZ9W7sDX2Cf7SkHy/
	jWE7V+Z68eruoI9PfZucSm/X8qZ7ywzP2uMv7njML22OH2OZsmBYUChp65nVnZ9wLPhyuXvt
	z3kHTDcNZ6Y0H1tBxr6SjcpcpN3I+EWqAzLaQoT9VujYfKhvyaY5XZO2mv3R15fRD9dytnPl
	HZfMSiZKrZoxmdZFqX4DHLABhHUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA03SbUxTZxQH8Dz3eXrvpVp3ZahXCdHVt4woSjLMmRqjwcQnJho/LBr9InXe
	0AYoplVCF02qEJ2NrSI2QqlaNQMpNZAilHZ0cYC86BYZBFdUwDEtBpQaxUoBRYoa+fbP/5zz
	+3R4HNskW8RrtIclnVaVqWTlRL5zQ97qwmu8Zm2o+juwV7pYqBjNhbIndTKIuAYYsDtrEYxE
	HnEw6W9G8KaphYWhxtcIrl8NY7DfzyfwtnIMg9c3gGCw6CYLz5r7Oahw74C+0iCB+lMeDP1n
	W1kw549j8EeGOThRd2MKrjZy0HipTQbttRYZXBj7DYPH+ISDTp+dhV7XpAyCDWYCbbZyAq+s
	TRj6LJuh2TEfwvdeIGiq9DAQPnOJha5iHwM1/i4OCjscLPyf34ego7GfgHXiVxZKjlsQjI9O
	kcPnRmRQcqeX27yGHg8EWNr4IoTprfJuhj4oKiA08MddhnptPRx1uI/Q6huJ1BTowNTtPM1S
	9+vzHH38oJ6lrUXjhHr/+5F6694w1Jw3zO6av0++8aCUqcmRdGs2pcnVrR4rc+jd7Nz2d3eI
	Ef0lN6EYXhR+EKv8f5NoJsIysacwIotmVlgpBgIRbEI8HydsEe+NppuQnMfCMCdO3hzA0Z1v
	hT1iKNA7va8QQPT8Wz7dxwpHxZa7hZ/7uWJb8dNpHwurRG/NYzZqYiFeLPvAf6oXi3k1JdOn
	McJysfj0cxTN84Sl4u3aFuYcmmObIdlmSLavkm2G5EDEieI02pwslSYzJUmfoTZoNblJP2dn
	udHUb5UemyioQyOd2xqQwCPlbAV18JpYmSpHb8hqQCKPlXEKk2GqUhxUGX6RdNn7dUcyJX0D
	iueJcoFi+x4pLVZIVx2WMiTpkKT7MmX4mEVGlFyG1+/NGNiuujbIXCcPLXbmxIr3Pun7Hlib
	fLFr1jfGKlKfcGVw6M9S24RBedSdVKH90Hbx/SnfyytVJ0vMY/7E+suzxteHljjM/2wLLnT5
	f3rqSt/6Momk7A6tWubcZbds3RhUr1waVIc749bdTrP+viI1q5saH6U4w6kJ1gNKolerkhOx
	Tq/6CMKBWTFXAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 47503C0003
X-Stat-Signature: xtmo3psdju31kd4t67pjebwpsyge4cxd
X-Rspam-User: 
X-HE-Tag: 1762173589-734320
X-HE-Meta: U2FsdGVkX1/Z6OkT4jEKdnwizIWUh91rceB3b+TCve3b4lTN8hl8kFecBApVTJS5OCYXHCBrKUg4QsZlA2jYLZP5qa46wF4xa0KPi9Z/avjipGORz5dgrWXwBwBAUEeAucDfoib2HUtjiYjxzlnUwNf2VlUp84UuLkCQ7MnG5TNH6JtzQyOccCKOFiFgzb0WEb7Ghw+WJH41LdNRuX1QPvqyeCUzSf5vNWaq0vrGPV2CzIg7sviOEvV83Ir85wlP8JlK0pSGaN8oSOK4wdBxqcKC8j0xh0BL73yPZAjdxJrn5Gq5FpMe/5CdG3gUnW62I6zVM/alcw+cAPf3crRH2VEUyOVOSxw5tTRWl8Rr6jkX0AAEpQM/5I5dLUHcKrbryqeJ8nGuU7pHO4Q5VsPrLdAOSCf24Q1WtNnu5KAF1+xqcUllzY+Y2S6ZvCGaJg9i0gBnL0PMJYZq0YIQ7zRr5wTdLUCvK+YXU7Epq5IXl82tyc09ZnM4x4CrSKuspfrRCWV0+6Owg7FKHmRVTtrE1VD4xgVGlZ3gg2X19Y5awuXFAWdn37wg4ctObSeVTJc9eojvzy3DhjkKP5JGBMlkrQAYFW0mcDqxv4I0ef8VD+Zz6DkexUYt6TIcqWgPeCD4UWPH4jVLc2oDfxqVoLrCTZzuaPMrtGd7eDOnlzRyn5v9buWC7W/H1YJjkhi0SGtmPcvHxisY2A+fg7AXoWFIvEN7dHyzUq1r+WaWDe90AHs5dy/y6hfKAcRBXaAuRNqyjCiIbdNQ0ECqRwrl73cSkm9MYzCmtNMeEvDICDRwRWdOlnUFEVKpzae4tLQSuX4GfnThuJCqHh2cqyeZaqn+AL/BxYtO+8aHWtCNbKuB25zCuTZszR7ctpPgz8eaIA0KzEfe98FGo4yuepXBq/ZL9Dfwz6jscePhao2AKuaYibd9+nNvcFm710G6WPmeaWeojVngYSX/3INXjKiCsHr
 2CfQH5R3
 nKfTeWvZHzjwMaBUkdv33I0G5m/EcMGH/RILa6w0T/SnZ4MvdeRQIY2W1oI37LuVp0V5Ga6qoSuHeKQqdWu87BzJXXTlDc77B5GBYYUXKAyraNrFMSQkLgmAgvRnmPXHN7HE+GsDSUlRP+XhlkTncdRKp3MPgdSHV9YPVZY5aOE4jCA2GxalI8ytAl4FFR3LafaQ9MfEkSHDALeTupY1E9aO8/a7+et9EVXW8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 01:26:01PM +0100, Toke Høiland-Jørgensen wrote:
> Byungchul Park <byungchul@sk.com> writes:
> 
> > Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> > determine if a page belongs to a page pool.  However, with the planned
> > removal of ->pp_magic, we should instead leverage the page_type in
> > struct page, such as PGTY_netpp, for this purpose.
> >
> > Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> > and __ClearPageNetpp() instead, and remove the existing APIs accessing
> > ->pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> > netmem_clear_pp_magic().
> >
> > This work was inspired by the following link:
> >
> > [1] https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> >
> > While at it, move the sanity check for page pool to on free.
> >
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Acked-by: Zi Yan <ziy@nvidia.com>
> > Acked-by: Mina Almasry <almasrymina@google.com>
> 
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> 
> IIUC, this will allow us to move the PP-specific fields out of struct
> page entirely at some point, right? What are the steps needed to get to
> that point after this?

Yes, it'd be almost done once this set gets merged :-)

Will check if I can safely remove pp fields from struct page, and do it!

	Byungchul
> 
> -Toke

