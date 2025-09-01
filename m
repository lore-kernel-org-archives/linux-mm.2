Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28D21CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F348E0027; Mon,  1 Sep 2025 11:46:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E75F8E0003; Mon,  1 Sep 2025 11:46:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF0AB8E0027; Mon,  1 Sep 2025 11:46:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAE588E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:46:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F039C0900
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:46:34 +0000 (UTC)
X-FDA: 83841108708.26.10AC8CF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 449B64000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:46:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JPhR1svw;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756741592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PzNw3w80hvmKc2szGkyzapLug1++OJIHZvZqlMCZvgM=;
	b=iZsvw5hQmNsBtwpleLtSECAvLT9Fm4jD9p9Uax5R9p96htHSPaEgvmNiF/bAJsVrE1TQi4
	bFKyMAt9eLiZ81B0cJaPyOkQPVDBwBx/3RNHAj5BQ1/rpjaqq3AuPpR9urLGxm6rpwLSP5
	Iu8vy5IP0e4mlMIrRDZ2+xhZu/wxbXk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JPhR1svw;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756741592; a=rsa-sha256;
	cv=none;
	b=usz/1ClocgNBM2CLGFoSmwOnYNRsn7xdCHKWX+zbZRORZEnvImHzHEOHG3CTAO5bF+I9db
	+7UlD3Algtt9pADo+3YJ05rJDMUiCCCRJuP6b7pRrPk92cxNa14KnJK7Cfq8/O5ryZ9aSU
	0tSmLgx623Ze6m6WyjYKMwaJsn29W2w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756741591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PzNw3w80hvmKc2szGkyzapLug1++OJIHZvZqlMCZvgM=;
	b=JPhR1svwVu7qnSJCKWs957FTd7oGdxZN996ZRUgr9sZDmGbM7+AKrfAd9tf73enYy6Fzuu
	qF10s5cXbiqa0O7OZ/OGSMts5eKoIFNF/jNf6PnVIcZHlEvvYa5NobuuGNK7fIdCFzfC6t
	DAZKudKs9/7Dsbvie0pxjiMAP1te4bo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-qZVSlooaPZ-YmSG8twnplA-1; Mon, 01 Sep 2025 11:46:30 -0400
X-MC-Unique: qZVSlooaPZ-YmSG8twnplA-1
X-Mimecast-MFC-AGG-ID: qZVSlooaPZ-YmSG8twnplA_1756741588
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3d226c3a7c2so1703568f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 08:46:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756741588; x=1757346388;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PzNw3w80hvmKc2szGkyzapLug1++OJIHZvZqlMCZvgM=;
        b=uZg0ROpVHgEmbDQqbZ6r0YrSC0atruZhCsHNRr2dd3hs4kqeGuw+zu4nM2/iIYD7RK
         6VlgOhLFbWHf39GQYAFu9B4sTkrG9mKeFYx9G33+6t7qyedOv4SGUwSC5rr+pMXSh688
         ajUwOd+8xCB9gfDhDY6yk3AkYDxHF6Fd9tWAzJ166UrrsHy/D/Q4M4cQqVq77TzFeLGI
         Zxsk+5TG/+OE3hnRUBhtIdsd4rkpeMtvHb5ELBzwdeEzNc4KDX1fAYrHbQv0YjRjuL+9
         U/Hb4D8udX/uO9XdTkn7H4IdT32hjUeGeCLEe0KOn2iWOlDYUTUGU4hEtoNzEoT6SHoD
         dNRA==
X-Forwarded-Encrypted: i=1; AJvYcCU/dqI2CB6qWjgz5cb94q3Pezl0cN6vo9jtRC/4+qtuhW3jpWJUE+HspoxWC3p2LpVMWkS7pXeElw==@kvack.org
X-Gm-Message-State: AOJu0YyR67WIUsICS8ky/yMXdytr8vsIkZgPd2e+6OdxPzv6Z/k1gYRE
	nVHakaomdxuvlx2irQh1wDHI1QmuWBZvczifCbFKHDIkG+/QTbnUArKHr9VY+95XCD4mZJR/1lR
	d4a9dvOhkD0dER+77bJh6sDDcBhlVVbht3tOSUHSqFiJZwRtGLZ5v
X-Gm-Gg: ASbGncuNaLfuZRDKybXhIEL7dmKS3NSyXFZ32dfpMV2v49HhqwSyLh0NLrhPU3H3zl7
	KqKBlyVKw8Z+joikmRi6zTfmGCJtEihxcqeB3EkuhqhUnajETOTnfblk0f5AOMaGhSrBnvmML/h
	kzOGOLFRkh+wYiG62d4HAUXFx9xoBGYzJpFXufsnBoY0IyUJBV/Rqlvhtn0wlQqR9oPyoITwnuH
	dP99LIxTPq7HTiLrYlwMXXF8tsE+iHWnJtYvhSkjQYR/55eVnGCw7UjHy8TXXIH3ViuzfRZr1IT
	Yb4FgmGLFn9FhmBeMOYigq0uL7ug0ni+Ya0oQ6clbndHz6DbWpRtlctBtrdPXF8E8jSXvzc8uVu
	Ll5PME2ggTPG6WjvNY3/08QlPKj2Wc1kp7CRi47qlTmrIzxmX+9xi8LBa+X+yn2i5bCY=
X-Received: by 2002:a05:6000:144e:b0:3d4:eac4:9db2 with SMTP id ffacd0b85a97d-3d4eac4a063mr4753077f8f.5.1756741588120;
        Mon, 01 Sep 2025 08:46:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBYT5TgSpKRkvicbHylPpOsy8Xr3P8FMNUZL88fb8BwkJlu+padub4ORveSQeiGgs6YCSa/w==
X-Received: by 2002:a05:6000:144e:b0:3d4:eac4:9db2 with SMTP id ffacd0b85a97d-3d4eac4a063mr4753061f8f.5.1756741587715;
        Mon, 01 Sep 2025 08:46:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33adf170sm16870007f8f.33.2025.09.01.08.46.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 08:46:26 -0700 (PDT)
Message-ID: <044e7890-b237-49d7-8c9c-3656efea4557@redhat.com>
Date: Mon, 1 Sep 2025 17:46:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 22/22] mm: Remove redundant test in
 validate_page_before_insert()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20250829154728.3397606-1-willy@infradead.org>
 <20250829154728.3397606-23-willy@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250829154728.3397606-23-willy@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: W_oGDpKkYMm6kJfuWtyaWSWdU6gPBlghTVVFajVv7ZY_1756741588
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 449B64000C
X-Stat-Signature: iwuwcuub1woh3nx674fm5zg78jgubh6y
X-Rspam-User: 
X-HE-Tag: 1756741592-327718
X-HE-Meta: U2FsdGVkX1+/AMSFBAkFqTbHt7rhRcxkoHjdL2d8j0IdM/5FdTRzt3OgJu2G7ukJTdzoALmk0b92pt8Zpsga6pfeq5+03+RtgufjY7RGotu4Xq9K3wLoQXbApux4UWpWHlJ0urNM0ULRQysRBb2uv/0EE9RbWt8HPMwQ4jm1rBqB4b4ji6UySyg/0GRFINrY/qzdA+EWKFHKKAaSeSuRE93lN/WgyXmjzfgP5vAq93XgBab2I7quo/qRi0g6GQgdd8650exiMutaz3SLO5SSLWpigM1gg+USU4PqZqODU5SzKR46vZZwcpWvZ9uPOjQojMeJ6L2Em+icSGee5aoqZaUlcgCXs6Gof4K4DnDQobOd/qTkrrOvij1FLZgv7dOGC0qNtbG1sQsJwEUZnlMlbK1OEKMLVSnfELexKN0ikJrpnx4UolODbvSBD3/hHA8pX+99tMmd2KqefmPwoW7HwoEhBB/GQmPHbQfm2uiG6Xg1HQmqBgnk4myjsLM7Ru2xwGav3bJ+LhlprpA0yksu0JzH5+zVtyirpTTqSpj6VSogbuWRZujKcRn0k+xv5P3Sz95TVmppTYEtbtsAg+MW8CaWcNM7NLY39C/2SuLa9TH0afWbYiLcT7m1vRADKK1+Zys+GB1nblr9kbukDG3+2Nq0NDiDmwRs++OJLv5VQd3TBUGqoKcI7JDkWwngg1BNLM3slA2TYtqpBxBdX6O0irIjMWFLlgydLEH3H/CPTe0ZdQiQutynnb09g8x/3IZjSAYgblRDmFyFbQaZGpcjvXFcIQqFSEz+ub23QGKWap+8x0vzSFd2NI/hkqOCbmrH31cZLZ8r+tOMcEN4qERAlFqn3vFk6taq3hhqBgJNdRm+Zyi3nbza5OU2yPpu9bTctoqKZEnR/RdoFAj+E6ADbgq+InZBPCVi5svaze6NwkYtKSVKBVqtMRhtYyjKWk/7IBnPfyMX9gMgx8f4eOn
 se8qBVgk
 4rtRQOyyjF85Qa0LYkS5NKd20ogRNHJgXKQv4MHYroHUpAzaaVyDFV2UsJUA+KzGpI7dPvstdZxKnWehkVzVNOYvn+7ovFyiYezHmA3WZ+6F/Wx7cQqWd08a7PJQmB88VqzjktTgb1Vjkk0rpCXmZOmnwjJCyOboGbU0wX3KH21Lli7hwLiAdzN1Z7Kcq7h2O6TyMpuVROGDc40G+kS9jWNubg2q62WAEBSwjmFJSae18Un2ddQvxhHhlDQw2OhVX1MrWNPo/ZV3pWchtxg+k/V4dUyZaQNQzeSfBjQA8ahQY4UMxqt+9JmU3iTLqno4RxG25S7bTCHiFceztp1Pzh+tPahVF63E5P10PhVgw/BQ7eshXqA7xt+OAvN4zLSfCzjiJHU8CAnIV8yxL5hTOZUHdg/qyH7tt0xKLiz+OSQfH9kFz2dzXVh9yDODDi9TWMX+1X986EhkHn8yXDEq/LRBLDaWt0HV0YKNQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.08.25 17:47, Matthew Wilcox (Oracle) wrote:
> The page_has_type() call would have included slab since commit
> 46df8e73a4a3 and now we don't even get that far because slab
> pages have a zero refcount since commit 9aec2fb0fd5e.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


