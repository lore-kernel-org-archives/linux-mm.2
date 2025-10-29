Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F6F8CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8158E00DE; Wed, 29 Oct 2025 15:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84D28E00B2; Wed, 29 Oct 2025 15:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95258E00DE; Wed, 29 Oct 2025 15:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C58C28E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:22:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3216113BEF4
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:22:19 +0000 (UTC)
X-FDA: 84052122798.11.BF8AF8B
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 32BE040002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:22:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=FNsgn51m;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761765737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfIXEvPunijsVQuODQPeiqITAMmRR37QOmIAdEcsp8I=;
	b=7Y2D6Xx8qx/wzNofyVe6MFJh92g+Jf9juXPxfT7Y7o3dfayq54fnE30ysSxeF6ZNWsoKEn
	aGdcDYtgoAHmoqMGd1la4MuCs+b17lJuYYzQmB6/vbOwIYc3JXqEUX4csgRgaiPk9d0QyQ
	ltItgQtGfsoXCsnCfi9FXJfp7ISooM4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761765737; a=rsa-sha256;
	cv=none;
	b=iU/aHSqVRWp6j/g+v79rdaTKJStu8DhzL4C6hbp0hlhNdJ2cy98F6qnGarAM8QRfdzdZcx
	UqYRu3EdJNdk45l8oAs6rqpn3TjKRGSO2ddTRuM6jc3UL2a0IsSHGxshAJnSTxDUzZDmNN
	tAWUEvj2xGXlYMzkkZ3PSNNS7G1KlQQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=FNsgn51m;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ed0d2a949dso1314191cf.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:22:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761765736; x=1762370536; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HfIXEvPunijsVQuODQPeiqITAMmRR37QOmIAdEcsp8I=;
        b=FNsgn51mKhR3jRscsFGJoiSu1Uo/u3rncffDS85m4cQbAvkpvEnIL415cnKJeT5Bfu
         tQyM+a77/LBBZU4Y2jxQSCxs2fE5nxdRZmA9KNw6ucj/6T2vM3izJLxUUrp1wzZHZVIq
         anQILOm+MVvr7NnlcjpL0Os2x2KFjtPw2myCm9qI29+T+2L1P5SIN9kLW14EoczbPhOE
         4RAv8S7kGJax4s/Smr74+ybQwKXQ0e2qDy5qd6D+1/rZHjBTECSNsHHzKNIk3mjTdMkj
         4BEGK1tcMpfkhV900fSgxIwtFylqNUCYUsKmEL/zlJZ6Z9x4hggtPgcL4jSG8qJu6zuN
         oRoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761765736; x=1762370536;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HfIXEvPunijsVQuODQPeiqITAMmRR37QOmIAdEcsp8I=;
        b=cktykh7x7napywGTHaue2cd/qV4pylfDvV3uMuJB4h6B0VvVLTksYiZ973TikvXW+6
         ODltXUT3khZT6ENoJeuRWvq5QA77Z7YPiy3Cy3UQZRTqZkmwg4Ejc2sa1JLnyXG77ijJ
         T2XKvCkceuwV5OSy7xxk/OEyDF5nZ9BoO+GLk1fiDBwatbDoaGQCjFXmhTg7GExwRvpB
         712xxnZbfws+YNnV+jMkB48YTCwRAh2VYXJnIxSoLE4zLQJORk20Eqi4K4WC81fpBMoA
         XsV3AN1xK0R7j1XjN6qu7wNuiBHzW7lDrKITsopqLO399Sm8F5rFd+74z/Fr/l8j1zNU
         pyxg==
X-Forwarded-Encrypted: i=1; AJvYcCWWVIdWAsux+pmwL1ZXr+QWFrKmIRdVAQbhp69jNESwQ1oxyT+LvUnJ6HEFbAGDgjgP4zsQ2Umijw==@kvack.org
X-Gm-Message-State: AOJu0Yy2YwHzOu8DBCfccPlfZmqKDXK9/3f4VSt6QQfUFbz/AjTxctMI
	vgVVIUDB+R0t2qfF7z3bxnzB70vO+e3bR3wbJ1cmBriR5iNy0rdm+dF6jpQ9FTUHt6k=
X-Gm-Gg: ASbGncsLuPYfG5QXOMtScUAn5yLc6iHC0VKTnIBesvH0OR1iev+O0otS9NkUfhtA35R
	NTH9o/1Xidi6Bcf0AHJ3bLVbm1K5J/JefVLxGaI0C4JPstNthwEmB2PatklFmpxHoqzFl6MxudD
	hkexUoQxDktBZ9gYKLmJMwgtoe4WINa2sCNBVL9ZXGSp/J5XHgoEKSkALNMecorKNlASRSVe85b
	t16Fg55zcSRv5pAWnoL5SUNET6HzIirBt1pLbX/NKgqDEjjPUTbT9nkmkHZNo00hS2m4I/80MGF
	nFrPnSd9MDki4jSz+7ukVtRn+fozVlLEVPxilNt3rI8h8DKzHi7mNGo79/OVidB4Q59kN+FS9aB
	NhPJGyzwdOlKP63HCc5GiTFp6sXjwUnCj94aXu7MxqAcjfA18hr9PyGd57LLPIRi05qSnfaBgMF
	SIWKh0ZO0ir5IaiW1CYmIC3WS8inZKAHtotwKZfd0YnOUikw==
X-Google-Smtp-Source: AGHT+IGVRBhpr0YCJrxmGJz0F6X/D7oq9NIhu9pswYWpNbC/PlxAuIyihNKYSR7/JFQ9FslbSzKeuQ==
X-Received: by 2002:ac8:5954:0:b0:4b0:8e2e:fd9b with SMTP id d75a77b69052e-4ed229fd4fcmr4752601cf.28.1761765736088;
        Wed, 29 Oct 2025 12:22:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eba3803e96sm98354441cf.19.2025.10.29.12.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 12:22:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vEBkM-000000051hV-46Wr;
	Wed, 29 Oct 2025 16:22:14 -0300
Date: Wed, 29 Oct 2025 16:22:14 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] mm: introduce and use VMA flag test helpers
Message-ID: <20251029192214.GT760669@ziepe.ca>
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
 <c038237ee2796802f8c766e0f5c0d2c5b04f4490.1761757731.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c038237ee2796802f8c766e0f5c0d2c5b04f4490.1761757731.git.lorenzo.stoakes@oracle.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 32BE040002
X-Rspamd-Server: rspam02
X-Stat-Signature: j7bwm85ypedmiocq7hcjxiocnw4jaduu
X-HE-Tag: 1761765737-905031
X-HE-Meta: U2FsdGVkX196i21KtdU7S5wQRc+RsF4hB5SupiraqZK8zRd+rsIsKvsrmzu8nSMCUscWiu8csadT+zWb32rodYPctEj5a/6fLaFmjWNlDpueWyzd+2LpWFU+CljIR/23pXuX9+aNPdZJwdeApifPUxrp5UNxj2cgsCxFLWF3l5jEfRQHLvYSBSDfC3T/Ro0pTQYE1uyZrMk9FiMvHl0RX/P1EPVtKhbX2Gi/4YC9nBJVfbO+mC2ue3dPHk0RwDTU0EvmHPVdDBDXl+daIXZeLGL2gATS77mgR4s0yND39Em/4tzr5LUmQFTxQ0vnNY0tTkcQCq3DVte6VM/cV4erXT+uaEMUYld7Enwp3ZhoFIkpf3qE2MPqiQ4BJ7B3RvApFhJz7b0/OAzDk5qrbBMPm5Kqu2qSI8hyrdyi5bkHkMrvGbwoSdTmFav3ElAGNvmWAl+UvZxQVCACyX1nzKUdePn5qkmsSCuYaU0d5sdfb/nnVtcIvtkhshx+mmJCSFvMtYof8fT0y96FBF/u8sMmERaeGGP/1IaVd6OHBdD7Rh3tCJRMS0X4Uwmi6pF0p2dTd4xn680FYYI+PwzBMrOxBB+6olPIG6q+z23YhXFmHwUB/VeDcG6mMUVPO+DChviey6kopvGXk5q8eU98p2Mz5b6RRlX22gQFds9PGo7YlZRSPKcj8rsKQt4ggWnJkrehMGCu4lJuEwXhMouJ1SWYnkcWXAhohSM54eI36JCTNQRUfTIX4hcaMZUOQ+dxt3v0bBjYOdcILoGSViKrgJLMSUgGrftW3Lw/z+vsJNSiH7KkBzYssuAga+b3XFh8a4y+dW7S0TbcqvJ5CdQRqcwrmgwBqq3NGjF71K6QooJfAQszRj5ls6x8F02I8cAW3UWaYwNjd+al0hTmuxhi/HmgwAd7Zv6Wf7jq5ZDY++5A95vF9VLILa00vVO/m+A6udcksxXBy75paOExMRpX3RD
 BPflvXrV
 XTtkwdlIGXNTSwtJ8SszlcyJ139fUn0buI43saEyBHFAfcyCGkqguwv8ri0XZVTMjx5lD+a90bFDZXS0hXhKQ4+HJkpBXOQgt4sBQM8/rQU/TioyPx80FLdJC1UYJtQ/kfy8W1onMVOULe7jCkdYLxuNUHV+VUa03lI9aYt8jvmtbwheG3US0hNUomWzsnUBv83RlmcPR2GAsOEnNe99VnOyL4/LwN2N9s/5cfkZdaqkwML5p554/I4BZmmbaEx/6HaNNnAs0z2Uh+dgQ4GmzaEUJUgq0AjXGtnhFBHnfCe59ltTYM6cDr9Qtej+kKxVjMZ+XAFSyCD0xqwEERyYlFe9Elf7fQsIQ8vf/HmPgS1ECL2tqgLIraKFs6CW/KxJ7CTus
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 05:49:38PM +0000, Lorenzo Stoakes wrote:
> We introduce vma_flags_test() and vma_test() (the latter operating on a
> VMA, the former on a pointer to a vma_flags_t value).
> 
> It's useful to have both, as many functions modify a local VMA flags
> variable before setting the VMA flags to this value.

Hmm, sure would be nice to not have this inconsistency though.

It is a bit wordy but with the C preprocessor we can make this work:

struct vm_flags_t {DECLARE_BITMAP(..)};

void func(..)
{
   struct vm_flags_t flags = OR_VMA_FLAGS(VMA_READ_BIT, VMA_WRITE_BIT);

   flags = vm_flags_or(flags, OR_VMA_FLAGS(VMA_MAYREAD_BIT, VMA_MAYWRITE_BIT);
}

Where OR_VMA_FLAGS's OR's together its __VA_ARGS__ and returns a struct vm_flags_t.

Would that be interesting? Eliminate the inconsistency?

eg

https://stackoverflow.com/questions/77244843/c-macro-to-bitwise-or-together-a-variable-number-of-arguments-lightweight-solut

Or other similar solutions.

The compiler is pretty smart so this would all fold away to very
few instructions.

Then everything only works with _BIT and we don't have the special
first word situation.

Jason

