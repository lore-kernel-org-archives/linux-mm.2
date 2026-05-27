Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F3D8CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 17:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A197D6B0143; Wed, 27 May 2026 13:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9C46B0144; Wed, 27 May 2026 13:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DFA26B0145; Wed, 27 May 2026 13:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EEC06B0143
	for <linux-mm@kvack.org>; Wed, 27 May 2026 13:01:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C688140640
	for <linux-mm@kvack.org>; Wed, 27 May 2026 17:01:02 +0000 (UTC)
X-FDA: 84813814764.01.AA4A5C4
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3316D1C0013
	for <linux-mm@kvack.org>; Wed, 27 May 2026 17:01:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EujYxGCq;
	spf=pass (imf20.hostedemail.com: domain of wyihan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779901260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Og5FR/9qWtaybmoKawxFptjk13+mvY5AZnqWPtKcDM=;
	b=cJJlyQOJsFKZgbair0WBEgRbj8YHyJsFZHqZEswmdRPDJPCIDEeX1oQZka38I6ffypCf/U
	UOf+IJnqIfF8YLBaWTSJzTs9pgKvineTcdSn5RFfqjjo9rm7URiQC4Ju45k2zYh00odXqF
	r9Y5iY+/rK0DFJz8oivHYpbq3vYOmPk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EujYxGCq;
	spf=pass (imf20.hostedemail.com: domain of wyihan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=wyihan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779901260; a=rsa-sha256;
	cv=none;
	b=uYNcNTg6+GZPvbF6HAb9LaEaiaikd2HMXAIL8miaq/Bh2aq55395TldLhssmDh/kdgZYC7
	Td3X0dvR0jVPA+MHQsC8ySizlMJJJDrufbXZxw6qhlsAtaq0WEP/sCpOomPo8aGZiPZhQY
	N/TAXAhWmhg8q5+qhnDlo+96ADq/fJA=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ba3b9bcf69so135ad.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 10:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779901259; x=1780506059; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Og5FR/9qWtaybmoKawxFptjk13+mvY5AZnqWPtKcDM=;
        b=EujYxGCqRQfb4qTNJ9iDJ4Yc1SQ+OCaSk9pvqNlsuQo3sw5kS8JSt4xqwQ5aGSzpEZ
         wOYNqhD0B+nW10Rp06s5ZUYD6crvdPtZdBjmPIEo+/y0Fa67hf8qATFmYgod/hK7V/6i
         +PM9N73LniAIlkIwLQTqPoPqvjnZj0d1ajxJB7gBOkZjKUPzCMG8eZHfwy8QnPT6knCw
         ffws5kZCmZ6cH3xPNRwZdWryLzX+wt/k52GuR0J4+hJ/iEfy9pAL4CUBfYuoirfUt/JG
         Lqcp65abbBdrTjdOwZ0dmJDx2Pos7+FQ2QAdv/SHVVfusTLUyyEU19JBEfXrHGG/GeUz
         PQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779901259; x=1780506059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Og5FR/9qWtaybmoKawxFptjk13+mvY5AZnqWPtKcDM=;
        b=iqu3eMdOfwYFDOOxzAQaL/t3vW2CZcsrDhn6fjxELODHHy+ujlszGNlFYd34Gzi3Fn
         B5GvomQ+7NwReX01dMZeCmwg92ARHBNEvDEsud/zKv7OMtdszGzxpEAoF2/GYTTsNbmi
         xC/v6zV4DPweV+mWVqkHcEX05JlbZsnb0yHAEpI3A1a/g07Ww4QhuAV0l0ikRA1czyTX
         gfarRjbC+URbV1Y+0omlPlFVVQ45MllhytEuEfTk8SH5EuP165MvSjI6P1pWVK1ceJyk
         VI1WwEHad/VkuK5Xdac8CpLWgsp2j+ulrWV4C4FQ0B0d2XGUtFTC5QJvztkXqm4CI8Ga
         xayg==
X-Forwarded-Encrypted: i=1; AFNElJ9Dz6FjD0dQ4b7aPE4upvpYIqJcXMO8QzVKpZywE5ByN/e/dAU+EmsAuqduiU0B5P10EA7SqhJ4+A==@kvack.org
X-Gm-Message-State: AOJu0Yw6r7m4Q9ErPnTEal0Ctl2eFVl50jpC6c6d/qYWWpCnXmdZd7Im
	y9zT2gzCVa8xZi65Y9X0eTm2bXRK3nMQ28Nb2khIYEP9LUHP++CXlRJkW8S1zLLrPA==
X-Gm-Gg: Acq92OEQGO/7t391gU3EccLNoFCQKzhM8aAPTE6eMuCxE8kujx/BinnVQwqvgpt3tlE
	nPmfWZmIBGLqtN2YGo7QGhkz0Nej7GC7BkI3kDq9WgDbT8T3D2pMFa+GTFizPKO7KHUt1umYkob
	AOWkCTwIUp6/igQMmrbwcF8egn5EiNBz7XNYkOdVbHJMUA8zqEjUe6K1ir0YGf3SO9Ydcy62aBI
	Ag/mSXxNYLpakopgdvpcDWh66swNHBtND4jqY/qnNeF0dq4aKglEEszqQ5cRZ0OqcgtSi4qIoyK
	i5mHRVMWHgvdCXC9arCr9GdLrKujdSuFOD6+WuEKxNWzzMExbXU+NCDH/2cw53UKliKILOKX+dB
	WiXnsFlgkP1mxQeu/UqVjvIGEHz5qw6zC6nY+fM95lXkLb1ADwpbocVEUUGk9CpemBxxTZvJ2KY
	vVwFktxeJA6usaBteXe2HaoH3HJnzPk76vtn8yOfRULEA+4XP9qVgwH+AnckDTXQ9al9E=
X-Received: by 2002:a17:902:e551:b0:2bd:7e8e:ad56 with SMTP id d9443c01a7336-2bebe9feb6emr8862045ad.6.1779901258238;
        Wed, 27 May 2026 10:00:58 -0700 (PDT)
Received: from google.com (230.0.127.34.bc.googleusercontent.com. [34.127.0.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36b7653c9ffsm334915a91.4.2026.05.27.10.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 10:00:56 -0700 (PDT)
Date: Wed, 27 May 2026 17:00:52 +0000
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
	tabba@google.com, dave.hansen@linux.intel.com,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kselftest@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v3 5/7] mm: selftests: Add shmem into memory failure
 test
Message-ID: <ahcjRGwLFEN2NH3b@google.com>
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
 <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-5-718f45eb7c75@google.com>
 <9effbeca-3453-f0fe-571f-85f8923e1385@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9effbeca-3453-f0fe-571f-85f8923e1385@huawei.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: jy6jyohdfwa5tyae74gc4ai1wqs4pep3
X-Rspam-User: 
X-Rspamd-Queue-Id: 3316D1C0013
X-HE-Tag: 1779901260-787458
X-HE-Meta: U2FsdGVkX18q4Fm2sDnxC+IHE6nyvoAcuti+vP+CAi61ehwfDgATgB6GDfFMUA11IegzsZ8ZBCcj2UwO7d3AaxPs4FpzjRTqvf7WEeD6GwVNnmj0gDKMmIkIy8/qVOeJT9UYw0rHdIOfdRNfr9jd9zYBDsgODigPJCwR+f81spu7UCs0D6aNvb6oW/sjwT76phparWTAoQHIVwE4+wBfWyvhfy3+Hx6wtjoGMHO86vEJA0fAzOfSDhkCXSh/gabKUrjVTdB364yKaasF464+/6W9OEgUQSjSQ6a8ZYFWZBQOERC9m5E0UFfc82rxlKWoHYWS9alXUz5NREgAwDYQ76egE6SZD9EUj/Y0xLq2lxQdX/MVeJmsVG+ZZwoNvnsqFPw1NnnW1jdNdlDMxp1pJk/tr1lKW0CPhHNI4+GKnh6ryN7GTLQd/7jyaWPQUIL2yNcj27Ry5nBtVy0+6nYh68ZylPe9oGx/trITnmxjuPJz8w8hlOzhxJiBJ6PQZeycYdNHilmsw3RtfG7ofsibSlA6NjHcUp8z/HHH6PsEDLVRF8r0GAYkPeprhq7v8y509DtN3qWhIgreRWbB7VY3AIp3hBC35BMCMMGrI2sUO21wO58PITaqOAg/ce8Vu0OE6NSgT+DfScAgBaUC8hwXYOBl01aGoSa4GFDDqNcjL3bb4M797Ndg5E//+MmhYF5HdpfX/YG3tTfMlZG5BnB8fyWFWbekLQwMgIysPGQX0auBQO9DmQbSnDY6qmfippU5xpN4/sm6sRf5jIBipcM8Ro+F2oDuPm66rIueSTfycUpMWBq8q4aHVdkpU84YHB9yx4j2PrcyyPWPRbAdre2zy01XALkkt7sHqd94DrawsSHzRFePuYKADKstMYHpO2VMzxdVojuCth14FsaoAHipBxr+ArB4ZQkFzVZgUEJzOV7qYdLdQKH48MBu6nx9T8ovoRhs8Vbl2TsCXdCiyyO
 FJTfBNcS
 5rDlUfj5f5QKjI8LAUx3NmZcn9z0zR0/IBJuW3ZqL79GWt9gW/Z0pN2kGvlA+QvyEBdSr52yrk6yJLs/h227mva5+eWbsaw5nYc9Qijr1HSfLNgGbTni6bvAGhii6g4pmfhAdZS2kuq3nUqlR2YHI4YTiO8Z1OZjiRBroM4hwP/5bpY56GqJKWYaKdbo/kvalcTJvzzbWajZ4iN80+l5HG+dQahVErP1xsd0p6LNJ2EfseIxib07wmKSiCCMgyYXvk/MXtnjDDHcLT0m+ZmIpgmk9hAtsoTirXXkijmGNv4S/3Efr0GeeNAg3Whf8j5CH7aoyFwCeexTSTmkkkqvQvm0XS6l3QQMm7NWNQbPal0UO6JheQXuu15kkLqFfC1e8h2qNg7TJe1MeoC+cOE8wnfzKSs8b+2qs1yu69AUfgO7S9mT4yQ0mFdfGFO9q9Y8XAvmGrVGW/YMvieeBLm9ZmWdhAkSGWViUrkMcCa0l0/kL7WLFZLnyIaePqrNTAl5LlFUVAhtrTZZ+ZFpOFWI0sb2siN4vPoy8qZrc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon, Apr 13, 2026 at 07:57:55PM +0800, Miaohe Lin wrote:
[...snip...]
> > -
> > +	case MADV_SOFT_DIRTY_SHMEM:
> >  		/* The page content should remain unchanged. */
> >  		ASSERT_TRUE(check_memory(vaddr, self->page_size));
> 
> Why we skip check_memory() for case MADV_SOFT_CLEAN_SHMEM?

Because we did not write 0xce to clean_shmem.
The difference between clean and dirty pagecache is whether we synced
the dirty pages to disk. However, the difference between clean and dirty
shmem is whether we initialized it with 0xce. Thus, we need to skip
check_memory(), which checking 0xce,  for clean_shmem.

> > +	case MADV_HARD_CLEAN_SHMEM:
> > +	case MADV_SOFT_CLEAN_SHMEM:
> > +		/* It is not expected to receive a SIGBUS signal. */
> > +		ASSERT_EQ(setjmp, 0);
[...snip...]
> > +   if (variant->type == MADV_HARD) {
> > +           check(_metadata, self, addr, MADV_HARD_DIRTY_SHMEM, ret);
> > +		ret = sigsetjmp(signal_jmp_buf, 1);
> > +		if (ret == 0)
> > +			FORCE_READ(*addr);
> > +		check(_metadata, self, addr, READ_ERROR, ret);
> > +	} else {
> 
> Should we always add a FORCE_READ() just after variant->inject to verify the accessibility
> to the addr for soft-offline case ?
> 
> Thanks.

In dirty_shmem, check() already verifies accessibility to the address
through memcmp(). Thus, we only need FORCE_READ() in clean_shmem. Will
add this in the next version. Thanks !

Lisa

> > +		check(_metadata, self, addr, MADV_SOFT_DIRTY_SHMEM, ret);> +	}
[...snip...]


