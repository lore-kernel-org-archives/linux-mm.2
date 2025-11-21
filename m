Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C01CFC510
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 23:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412E06B0029; Fri, 21 Nov 2025 18:45:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EA776B002A; Fri, 21 Nov 2025 18:45:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFF86B002C; Fri, 21 Nov 2025 18:45:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9396B0029
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:45:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DCB91304EB
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:45:00 +0000 (UTC)
X-FDA: 84136247160.27.A84CEF3
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7472A1C0005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:44:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=EOD73ij5;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.44 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763768698; a=rsa-sha256;
	cv=none;
	b=n6PkbuSilFHdiWENKxxdxYebo4LjMwdJzRCcLHXj9E4HFnpMH2s/dXdtwfCqLDN8OpxCoY
	YIBPRzBpAL0AgZXkQPWrWHjXEg63ibWbIjY2GsM2aPLzgdqrzO1RiMRLxqsNa/2OWhCPFP
	SiqLXyoZbx7qb4pm217+Gx19ltX4pgY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=EOD73ij5;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.44 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763768698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=94wkD2Iff42VLMlQNWegA9dtRPkkPQ7m6y0iMS1EKU4=;
	b=ygiS/vdMJCd8F5nKG3NYiLLcGUz05G7+jSRWCNQAt9CPB43rv8+DqKdfhw9OW8cvEssz6/
	H5cKAoQI0bx7EKHOJ3P6SMlgWN3V37FxFii+BhCRLqoEcxvs0mta3ylN0fkVjpNu/6BgC0
	uwRv79oGTg6BO5/msoksWehwalvHnqk=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8824ce9812cso28377376d6.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763768697; x=1764373497; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=94wkD2Iff42VLMlQNWegA9dtRPkkPQ7m6y0iMS1EKU4=;
        b=EOD73ij58mx+3si5593Q/MuHlwoiXfWsbVzJAUzY1a7l4ReQnDhaPUIGO+xT+UcdOA
         pXsLl0Ut/EWArhLrkD+SqIh6cIAOZZ0y4lrj72h4Csge77/wLo8PMqb7ni4PR0Z9Ub/G
         W3EqXdgdTTDYE2TNFOBACCmlHM3WOT0C/W7yLKAQzXr0y5T/oiW7mW8vPb4phb8PPRuo
         WCxyEx9niHhf+cZePyigXOz9Pjz42SgYZI8Omyzrtf5rZ9JcfI/DSvQ1vhSQoM1zsS+d
         /0ii0UdesMRmXCFL6BJuiLkWqqhBaoubo4CCQpVseW2inFwUUjaNo5ZXvkxbKSMtAc8/
         WsHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763768697; x=1764373497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=94wkD2Iff42VLMlQNWegA9dtRPkkPQ7m6y0iMS1EKU4=;
        b=qWNnIhQBtOclVC11CzlaG7nFVCKwASahOgEeA7HyCORVmicoOFGVkGNcMluZNzai/v
         GTKcb8dH8A74i8U4JKXbUaj70wNpaa5wrc7/R7R62ijOeJi0gAL9XWmFHns5QwJGsp1K
         jXy8/7yFEsJxBALanJdKQDhyyCUSQWIcxUxMKMauQtH0+oABrYkiWTkBjhRnDng3OmBy
         dC7ARFsnSX7yA75HPanRS29GEN81JRZlnDs5W/AL1EwO//7hQ7nhoOJv+TnjYL93WZJS
         QE1J6EW6Lg8ZGZd81jC6wsNkWc7qXBdlCRsQL2Ob4zymtE/ml/LkfiAyeuvST2AWd2sB
         mkDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXtCrlqerd5Ic24qbLWFVPtJkszFmxi+a7vG1uUnfF/Ip06K3pR8JMq2zqv+WnYwOHxhx1AgfR1w==@kvack.org
X-Gm-Message-State: AOJu0YxoJw8AyeZsuWCTJHxgCgiXbpcpRf759naHwIHZdSD3VbFNqXDC
	Od1pxH8kWh+15P/1iKAXZk+l779gQhArI4N6OuN78QxFbOWgF1Rmq8PzRhnwdFqSndw=
X-Gm-Gg: ASbGncuWHoYPHgWqdiVLWbIU8K6cYKT9OyIKvks/UP1bkzx9qtJIv6QnxHjyfqnhVBZ
	nw+XfvWY1ILmkqDyedsZpy93uQXN9ElQAPycmu5TBCXFhBQH9YkRFZ/9zTvYkR7E+JwL4XzQAEo
	K2QpKSwIIMJi/CQgmaQl5uWlP0KyYSWF0V2+vqVNhMdIN/KXVxLgvFU69dMlpSDC5MWJxhcZs+e
	sRHyZEdHXhZ8zOoCX69gnHPQWKagCb4rfzZkSNgcVmfAkmSyn0uR/QWTjHU9QUiW6HpRus7IASD
	1/5G3fMjqOSf6QTLvTlVqW7HBiTVXSsy0dWOeVDAsNYnUOeDjCyKFHVINOM9ZrwmUDbsIxWW/qA
	NVjr0x0e6N1r0VGN30XV/y7DvGKIMT+7i4v3BNxrDX9089IvUBLTvYV5YH3T42b552jcXXryxU3
	KJ0eSF7raVtSE379O2E9BSZGZs81r41iZC8z248dc8S9opAYrJimIEF1Iy
X-Google-Smtp-Source: AGHT+IEos7T2Axz389Mmy3AFU8+Jfh3PFehz2HfOxc6qgzO/Its691H7QS0uM/0VDIYstKPPxEQUqg==
X-Received: by 2002:a05:6214:226c:b0:87d:fc3e:6d9b with SMTP id 6a1803df08f44-8847c525de0mr61714186d6.42.1763768697300;
        Fri, 21 Nov 2025 15:44:57 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e54c32csm48350666d6.37.2025.11.21.15.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 15:44:56 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vMaoC-00000001bmD-0arX;
	Fri, 21 Nov 2025 19:44:56 -0400
Date: Fri, 21 Nov 2025 19:44:56 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
Message-ID: <20251121234456.GA383361@ziepe.ca>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7472A1C0005
X-Stat-Signature: 9kutqbozkf71bssxnj7rammbof7ckbbb
X-HE-Tag: 1763768698-898307
X-HE-Meta: U2FsdGVkX18FmZY4FofxOv3ldMsSG2xcyT1rQp2WexgtT05eBa7LLt876AitAusHx2ZhYwkLEIW325ynpcipFngBp0PCf/ChgiV9hai63nnHZkZc9JWQrBltggqZ0XgqAiQGLN2OAgIkR1xAG4+JZv3KPD1Ie6I8oWdewEaVW5t5KsQkuz9WYr/1+rMjSrMK/iTbbbTS+1HNY9uHmldvyG543aqUsHawvrv7xC7US0QTpOp7HcudBUeK6QKoWYKEijXHdzlx5PcxOTEcF0jbtTMcD/AWQUSjRqG/khVF42MnGUF1PItmyljR4AQTdy2iZfix0qnJjSk9eYcPWpgAGaAsI8/xHS9Tbeia0YXwt/TXJqXK8q5vF0MJgFzqCQXZsb4S0BdUF75qsMRnX394M6mtpdYU12qb/jGaHYHABocWcDAhltGDxiv5gz0xUt4goZGvcL/DEuNfjUEIY04q0BkeT4fvOXDjRONMNSijaXxAhWMX8mS6D+BftCQbSLrpwZ0Sn03eoOOWfw6ZIXc29RToc530y766bMLNrlIfCCMKa9iDD9f3/dU3sTCxG1DSOdaQknTQ6x4iIL35Q0c+dCT4py1skPXMbVHb5gwM0RI3uwyiFZmZEcTUI3uN+XkQtbAQrpwePTE8zDY87GaqU0EmYWtvG2oCKNQLMgfvVreqL+bpYYspO3DRzn97dbfAlGtcq9x8yKKPYMPrvW4oh/nBMLrFU7DIkZ2xyyMgyU9CMJuEd9NqCUDXD+wTE6vMVB1xM0LWyFjD+30zL9mw/x3Vq6EHbEa1loJVGw5Wxd1M8rTN22Ou3AT7QJGyysAQvQayMxXWl5M7FUCEqp3Buajt4oSJqT9tX5ykJugo6XZhzJQHJf0JdSDXov1GZALHXa3GBqJojdah3+cBp1h022v8I48F2uVwczuAh47HvXRUd5ihgIDTzSVI9fWDJsMRjYtGK/UWmeDJJFkiIqH
 3lACDmDi
 sTgdc1/8AOsPUzMR5AkmMsgYGL99BRU93XVFS9Ww0dsaF2iV2hSSOkKN2J4PuRoLj9eiVlpQBd18vuyfVRGGcH2Mj7OMD7Hwu/O/PuNc0EUSsy+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 10:21:18PM +0000, Lorenzo Stoakes wrote:
> There's an established convention in the kernel that we treat leaf page
> tables (so far at the PTE, PMD level) as containing 'swap entries' should
> they be neither empty (i.e. p**_none() evaluating true) nor present
> (i.e. p**_present() evaluating true).

I browsed through this series and want to give some encourgement that
this looks nice and is a big step forward! Lots of details to check
the conversions so I wouldn't give any tags due to lack of time..

Jason

