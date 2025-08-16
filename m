Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69705CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 09:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A788E0015; Sat, 16 Aug 2025 05:06:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB608E000F; Sat, 16 Aug 2025 05:06:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11288E0015; Sat, 16 Aug 2025 05:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEB458E000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 05:06:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 39C9D58CCC
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 09:06:59 +0000 (UTC)
X-FDA: 83782040958.20.7777228
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3E2D1C0007
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 09:06:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dKJlyiZn;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755335217;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/LQurfHVWRXzjR+U/ALC8pxEl3NgEhyHv24zYTbsLk=;
	b=bXrNTlwseV1B5wOX2QmAnUjlZ+GqFCwxXkcQI7s/KVdKECUZEIDtfE0u4YeFp0RHbB7JUq
	hhh081fMValAUGx+bKtVzXPe7uSUesNL8cP2eK28AISrnnl+sAd2OHaaxRaO5wwSjzmLJI
	klJzOSfbt3t1n6mxObuT5JJGdTSxYYU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dKJlyiZn;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755335217; a=rsa-sha256;
	cv=none;
	b=z9pd+YeQPUTXGxZcbv/IUmWDCCNCYaXW2LiJzvN7dUO0nK/TzW2TuVE9XKwGZdIoHknHaz
	eNBAgvZ1molhMubiKVXIoTa8S3weid8GTYSVuIptKkslVEYj4J/7Fxij3ZgvMB1+i/PapH
	4J4OwGQGqn5O4nkjl2kQugDhXLk9fpU=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-afcb78ead12so382875066b.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755335216; x=1755940016; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O/LQurfHVWRXzjR+U/ALC8pxEl3NgEhyHv24zYTbsLk=;
        b=dKJlyiZn2aUDOedLr0iiB+ZVFrRjXgwZ9AlYmAoi33/6FNoVKxFJBTuyIWyQVfzr8s
         054mcpeeK9pHgBgQksEpeAermjHIicoccZ80bpisrMVmpqcy87jMPrYpxhjX1Lh9eBsY
         xM71sLqT+WkKXF2QGOmh8SY7P3d5Z53x0SILDJMudmpvgdqrp6g6eCHNqjhW0y/X1tH9
         leDV/0AOmYqfAtk7cBQO5MBwhNlcqSAPL7jLlp3ZGFsqFY8EMfgZksSF3b7kPM19+9Ff
         rCafEPj9xQZXNS5boT7B9Bs3mWo1AYfBkunf/mohKVQKnFx2O5ODZdzYDjcsB+B8+g4G
         yjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755335216; x=1755940016;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O/LQurfHVWRXzjR+U/ALC8pxEl3NgEhyHv24zYTbsLk=;
        b=LOQlQNfatJkF2BdjFOcPdwyoHTdjJfhut6qG1TOpqgrCCEfw4nmNqU/XH9synnqqti
         M8vIFtraOVN+SNuRWa74U2vt4/1egExMVppPh+LhUo3hH1JPwKvDTgfrhy8MOT6G4Yxm
         3apVpXlg6oo0oIjhOiTnZbpwp8FcGbA6ajs7MN4oVe2qbY3PlwlHKmleMoH6Nf+RrfSf
         wfGowqawhuTdto4Ina3uMybic8bPpJWutWbV8BynODhPrlXKqb6VZQOk0c9RcI/KUYnk
         /Z2jNkfFSFyGqaEam6H4WT9p5PMa/dVA/bjfLAAjFeIhkous+9fxwo5ruoZ5GK3yhExQ
         8bEg==
X-Forwarded-Encrypted: i=1; AJvYcCWzqvntgNufM370/BwibOU0LfyIoJ7QVjw4nHAB0EER3mjPgSPxx1iKGLtwjrI6TptTImzolRv8tA==@kvack.org
X-Gm-Message-State: AOJu0YwWflQlsd0l4OxY9T5NSgufp7PmRsPu16EtzpJXiNbzdAJY8AX0
	LDKJjw9XgtmWMRuSYQIA2+Z/BdjaCRtWh3bzoYbHtqyUsOvfwS4zYX5p
X-Gm-Gg: ASbGncsK+Q9JKUACFyg97m08p3M9KM/1Gz/pzP6xvOWQYhjRQJ78I1npl5rlKH5crOm
	JfBvoMqkZ2oH+gWrRAOBH0Wte7pyQ2sz3mSyPAqRFwTJir5odN9tbVPpK7MGs9GXfH9uB+8Xirf
	z1GXlt8pnT8NCfHyIugBiym1WILRZNeqNK9ZTj6esZptxtX/cTBJG9ZGaSj0CjQzvE+6Ikmsnvw
	a3/GNGiwZWWsXmJIl7vzx89CG5dPWQF360MkerQh2l/wgmPoeQcvX8c0xLgHqTPYzZdHB1ffl2Z
	JxFmWmgMcjXtfRFqur7Bhp4UupO3qV3iAgucv4H347MmfNgKHMaOAi6PG8rwvHtSLjS4KPxKu3S
	H5nmLsGe+anbmWXRijhjtzw==
X-Google-Smtp-Source: AGHT+IFI8ybExaSnOm7NYdbtYEpDyS+F0MEE5iKxBGvg8Bd5y/rgFpo6Hgz4roVBR0iMu+VljTuVSg==
X-Received: by 2002:a17:907:a46:b0:ade:6e3:7c4 with SMTP id a640c23a62f3a-afcdc193edfmr381139866b.23.1755335215385;
        Sat, 16 Aug 2025 02:06:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdce53d6csm334155866b.6.2025.08.16.02.06.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Aug 2025 02:06:54 -0700 (PDT)
Date: Sat, 16 Aug 2025 09:06:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	riel@surriel.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	harry.yoo@oracle.com, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm/rmap: could be partially_mapped only after no
 entire map
Message-ID: <20250816090654.u5eoys2vkpswe553@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
 <20250815084943.23063-3-richard.weiyang@gmail.com>
 <458c4ea9-1e33-4159-a545-6ad2c5b81add@lucifer.local>
 <15ccbbb0-8ebc-4c50-a1c8-fbe5416ecf46@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15ccbbb0-8ebc-4c50-a1c8-fbe5416ecf46@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3E2D1C0007
X-Stat-Signature: gt7ygw1du7prxixe9i8o13a6pk9x98k8
X-Rspam-User: 
X-HE-Tag: 1755335216-501416
X-HE-Meta: U2FsdGVkX188iwILqEWISFSvnjRuU0c05DSJ8EGHq5w2o2aXRih1QBdnDgUnspzYLGq/kc9yc8Jpmo3LmIKlbcXmMkBhSpTohGnO+T5tEmZPmqfjkVdDMyIT6MvaznY5TQZBQi6veBAdZ2QKop0Ud3zVyVcH9z0+XF4fd1rVsZnjroZcNzp6//N+ECKfTIojUSVccp3hre9reguD6JbUrl7+EFK4oK4V2Pn2UVfFcvjb1XUl8/YMv37XJvuDKccDJVY8tTTb4xnEogEbrG+jf7XWubYC0jhvzEKTbK0bw7yq/1bXfmclYAfo5Oo42DkIp7ETsAeWqq5Nw87PkNOMqMTmPWn49nwraPIdHyFcP4YGi35G0DM2CqDcTQ0Pqg2n12GXexAlNI0RcLGnlEM/eLuKUbPH6LdyKzJ7PhbE6+ukD1thAW3vus+Clcsd5vhblPf6smiWiASVkgBN0IP2M0Y1yme137KRFq7/a2wGbf5oDxIkDoO67H5gn24LfjQf0UffZ6URtH60TLwPC3JgZ8edwGSyTjtCvuYW+1e8S0rFE1JGKslTBkgjCvWvOU2JmlPNK/jMizChUSweL0A6V5g8V7EUkTbIlyafOcS5ExVZJMu8Kf9DKYDcPEpv9g07iNljpkUFmT033Hqj1MJTVSMhDPbau0nl5dTWt5E1eSFoq1jzei4Z8t8YJgFHhTvL7n6TKo4tONN53q50xZJOINkiUPSfsoFzYiB1pMxpshmyrOyDooAUo7k97o3FKvE93aQ/xEuoOgcOL5xfOHyNHhEaDCT4/jUYWPC5KhiGRWBjvh8X0VVJJt/hkS/o3gRXPX0yy0Z7/QB2EV6opK0hHVHTQ0avvy7Bj1wHjjuggJIARUxIbn/lUEF5CQn50n/1jA+6VguWOcZFtuEOkcbdmB/02VrwdBqHJhpwtU7Nh0AWqJpZepRwaw3YG3zzvdSQnoqhRzPHsLwBn0lJaS4
 r/eHHsjE
 fYnBpF8jb+3vbb9kXUWZBbvnFjCTfZVXE2RngljOxdi22G//AtI+UInV1WOX2Ro7Y/1ni3xVo8h6Cdp/gVWLTEf61EKHfDiZlnN5j/xeMdR2b958BanQNdaP263XMX1dSjpAkX2G232gMRcM5tYge3MxRs4oo2oWxYHjfufpjftq2J0xg0hBIxPK0GcSFjKNY6aDlzFqvsSUmshOoz0oA8FRjvuhdeQwQvi5anyjr2Fo95wkqKdhqSkd7WxniJPNjjdlfX5G6HK2AJ05ZANk567A5Fm81p7Yf5ub0CororNBv9GdF0gmm0o42gTkO49I4q0Jt9Kzg0/raZKk7+8DbqQ1DP0Wz9nFCdZaSBUIseWlkyFz5jYJHsxfJGfrdB4UOF2EwLj14gDE3+ZukZyrfeQbjjV4A7jGsVPj0QyH9K202TdQuyYcBAJBE7KIi1fuYUtnZyOOmlhFoOWunzQwZ3uux9tFIjpanSCceqtMetaweruKB9RaKUFh3PlugrfIACNGeTZlKP6Na0VRqYt3vdZLp38VnOuPDUXGYdbd64aZoTNzt8t8R/PaLYGvwQqTxDSZvlJVLCrxC3jJzAdiiBDb/g3ElSKAbYQNN0muzuTPglMwJqm/ZvMTi2pQyg/DN4ta1RyMY7BusOw6MxYiPB+kAR18YrYYFqk6hNGadJoh27yt2RIRNP4i5L018r7QNVVOOTjw8VkzxGFF478mnlCXRjmQwc4zL4W+XnA597Z+54VZKQJXKBydmJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 08:31:59AM +0200, David Hildenbrand wrote:
>On 15.08.25 12:08, Lorenzo Stoakes wrote:
>> On Fri, Aug 15, 2025 at 08:49:42AM +0000, Wei Yang wrote:
>> > If it is not the last entire map, we are sure the folio is not partially
>> > mapped.
>> > 
>> > Move the check when there is no entire map.
>> > 
>> 
>> This one I don't like, you're having to sit and think about why it is that
>> this would be the case, vs. just unconditionally doing it.
>> 
>> Again, as mentioned on previous series, just because we could do something
>> doesn't mean we should, unless there's statistically reliable perf data on
>> something real-world indicating we _must_, code clarity absolutely beats
>> everything else on importance.
>> 
>> So yeah, sorry but no to this patch, please resend with just the two
>> reviewed (unless David radically disagrees with me :)
>
>The compiler can figure out that "nr == 0" if the "if (last)" branch is not
>taken.
>

Per my understanding, last is a run time value. I don't figure out how
compiler could help here.

I may miss something. Would you mind giving more hint?

>So I tend to prefer keeping it as is.
>-- 
>Cheers
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

