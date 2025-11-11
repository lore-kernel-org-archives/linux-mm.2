Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E146ECCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18EB98E0007; Tue, 11 Nov 2025 03:58:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F578E0002; Tue, 11 Nov 2025 03:58:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006CF8E0007; Tue, 11 Nov 2025 03:58:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E192C8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:58:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 871E31604A5
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:58:57 +0000 (UTC)
X-FDA: 84097726314.25.0B23AFB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id E9345180012
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:58:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcob6+DN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PumvvZgl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcob6+DN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PumvvZgl;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762851535; a=rsa-sha256;
	cv=none;
	b=ce0VOU2VabFgPIKfVtNvTSJTTCCsYdpc9eqnBECAW7Uy3w9yL5msHjmuLcYgxiM5CcOlL2
	W55HmQ5HfeIEt/tFoof8J4ul84odv75riuGIJslE3JZKk9ZGFS2BJ42y7c/5Bzp/nRFVPd
	+R9bm7KHxoo0lDPWDoeCe7mAUX1gtQE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcob6+DN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PumvvZgl;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xcob6+DN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PumvvZgl;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762851535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQi5t2ppqnxMZiF2+yuTxUMxBfuIQhNC225DGGQI5iY=;
	b=kdMz8gObzGrKETOdJvqJPPPJ3VEH/j+8ktihcwgRKQ6jQ60dU9hJZHqLT2pZVT0Hufeypb
	dBCAmvCkELDczISMYUEoOxU6AaJQC9JukaxROy7rbdnqNlIfqYftB+g/jpFKkI5RsKQZ9t
	rWNon6lkFa8dNTuXmCnFpE/WdR+eQeo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 09FB621D5F;
	Tue, 11 Nov 2025 08:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762851533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PQi5t2ppqnxMZiF2+yuTxUMxBfuIQhNC225DGGQI5iY=;
	b=xcob6+DNn8NXlkB+h36tF4QZlPySD9Hwg3wkdQ9SeOFVoeWNIvDXtMU8EAnKJ5sjyOYkqH
	Azi8MGI2TFyEiKQ4lAXLFrnjN0fGUrZI6IFx58dnWABybdDdR69kPcQBNv5eO6U4ep/Dkh
	BOi65TO9TlNYb9dGQccK/WIb1voY+f4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762851533;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PQi5t2ppqnxMZiF2+yuTxUMxBfuIQhNC225DGGQI5iY=;
	b=PumvvZglfBjGGSuPXuN27HB6L0uCbopLjC/xiLGwODJTVehV3BsqipL8SLbsnWkvCow5ZJ
	yKan1utz5AWmA0Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762851533; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PQi5t2ppqnxMZiF2+yuTxUMxBfuIQhNC225DGGQI5iY=;
	b=xcob6+DNn8NXlkB+h36tF4QZlPySD9Hwg3wkdQ9SeOFVoeWNIvDXtMU8EAnKJ5sjyOYkqH
	Azi8MGI2TFyEiKQ4lAXLFrnjN0fGUrZI6IFx58dnWABybdDdR69kPcQBNv5eO6U4ep/Dkh
	BOi65TO9TlNYb9dGQccK/WIb1voY+f4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762851533;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PQi5t2ppqnxMZiF2+yuTxUMxBfuIQhNC225DGGQI5iY=;
	b=PumvvZglfBjGGSuPXuN27HB6L0uCbopLjC/xiLGwODJTVehV3BsqipL8SLbsnWkvCow5ZJ
	yKan1utz5AWmA0Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE6111488E;
	Tue, 11 Nov 2025 08:58:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nFJ3Mcz6EmnGTwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 11 Nov 2025 08:58:52 +0000
Message-ID: <0192016d-dd7c-4e60-b655-8ea7d2b8e0b3@suse.cz>
Date: Tue, 11 Nov 2025 09:58:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: Add vma_start_write_killable()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
 Chris Li <chriscli@google.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20251110203204.1454057-1-willy@infradead.org>
 <20251110203204.1454057-2-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251110203204.1454057-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E9345180012
X-Rspamd-Server: rspam07
X-Stat-Signature: sbzeo9hza9f36517to73ny714xe315fh
X-Rspam-User: 
X-HE-Tag: 1762851534-891891
X-HE-Meta: U2FsdGVkX18pJ+fjDjftmgPdloV8g6iqF909sR/hhPa5F/pqKItieP1nJYBqbKwc4Z1c8kTLWHWVZsxdiP34FQS79uFx/nPOFUUCac8wD+h5z3ARVw2Cppgd5JWqPuwu8EWC8AKGhNdgzpYgdrj/A3/g0efjk/ma2YSYvFucKXvtquN52rqgshQlKGlGFH8NTtjIfpGk0DApIYqe5HYS+CmMpwZeMNmbvFrTvDdUGJQMMyY790n2jqp8g53jC/Ha3R9odCCEwIphGy5q2FKFRHCaj2QoJ3wJxubmGq3Gzr61Aqkxw5CEHg+Uh/QxehQtQz/lRTw+lp1NKzqvTiNZuIFQo3ozXC8wxgCz6GVS1ffVO5qnjjrNpKvyaL1cgejYAOpAs/jygFSaj/iCBJaM66iNDjTQD57Afd1CTMk7j4ZMd1cDz4s0cJ5kSxqOOuZ6W7kH/4RLJfbIf24q3ovhR7oIvMVj+xUyaV/ondPfs9oq0iSme36N/+rLRlABqPDbu1h2BvnqOt1nSg/iIZQ+1aZlA1OfWOw6gk2TvOJbTi2mMP2rGCEl5gZZnuUtg5qdusdAKijPS1FlTiy9X6aBf5LYxgwHy5qNQ66S5tg83Y3SvHtrD/dA4mGeVvVqZ5IPGbrzVFkpEFkys3oDCL09KeynzdbjaKOKgAmzwusTJvgjV6rEr/mOqwb3D3orHx+qdiEDyhplPEcMpdrj7ANJMOYl6QhmZzlDhf+gTnyG/YhKZDosEXydeGPp4T+MHRAQbmHwu7mEPvfZk27TCF7Gvd5/Xsu/51V/5F9YsG1lQMgE+wk4LPZ0ZUKSL377IgiV+Y9sbMbBA2O1tfRuA5Rz4zFH+Pxt2LUuh91BrSQbC0cL+/F1fe6kCn8nhXPu/yOtb2yhBgYDFYbQgSWd2X4KNQAqHOIrpRCakzYX2z4l92oqdtBBCPOFx4e6KaaYzeYjQStb9FP3KSLDl+MVfzu
 lyKm+i+x
 fH2pBOUxWbWwtcjdiNXzp6BxDw0YdD/LT1BlpoZHq9qgMNpomXVX3hqHJlc801YmrSu3SHreez2y/SyysiP2gXEmxn7yIl5+7O2XQTkhPSGhj9BvOY7EwbZ5LtPRprXmyFcy657Q0COQSba0b8Oh8ecypws5vsRMg1lx+CcI0RDelqdZ66300YbGTHj3ePH91EKeZrGqU8ihUP4gH3wRNegRSZKrDuOsmrO6+c+KqRDXKpS5uVPxEskwrklrhwDT7Qyfp1wnwEmsVSCCB49V33a8+nJ0OYQPB+dvanGWWJc5RGJxYqbv8Wj+RSNRlMuPqs4hN+XnGUAvFyRRnEJg2W8g/Y2s0iG6vtv4a1E6M4dVoIa78xfrPdM94yE9LnrVNtEhjYRLnTP+98RLSNMKqwcj/f3rp4XLGOFwTF6omqx4XGgXRdEOfMwr1K2MXqpKyW7UFTDXqc3TIYBlh4doOAktx8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/10/25 21:32, Matthew Wilcox (Oracle) wrote:
> The vma can be held read-locked for a substantial period of time, eg if
> memory allocation needs to go into reclaim.  It's useful to be able to
> send fatal signals to threads which are waiting for the write lock.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


