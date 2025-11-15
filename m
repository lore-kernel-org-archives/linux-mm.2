Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33045CEB2CA
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 09:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785088E0011; Sat, 15 Nov 2025 04:43:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75C688E0005; Sat, 15 Nov 2025 04:43:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6996E8E0011; Sat, 15 Nov 2025 04:43:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5547C8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 04:43:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D2165AAC9
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:43:05 +0000 (UTC)
X-FDA: 84112352730.01.17608A9
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 18273100012
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:43:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KD3UcUeI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763199783; a=rsa-sha256;
	cv=none;
	b=CNBkOWscV6R5PmFoHI4lLp7lmI+fiyH69SDlgwP+OS42nBBcn0zvgwn2izZUuszmyhqpiK
	4ZoP3NE20WhQbOSe4SxLtXybnHxHz/0OYUQKlwF6v43+lx0qXpX54yo/5mi93TCJFGs9Tg
	3FJXAN2f4Bg/epmbMGaIrcPaPiJoaqU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KD3UcUeI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763199783;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bu/YvVGS6f/qPnY5owZrNEIEYGYSg1/BJENMGejEMt0=;
	b=p12ua4qt6jMDU8elxkYpRZ+TF8Cjs3MqyMyS3FRkBogSVhCA4/pHdShUOllcqkQDCwOftb
	Eq5KlRq26Q+HAS3vvl3T5kOKiytHN7dX+yo8XhX5JrWanB6tWUNPC0jvLrRKqjAUIfbGEP
	x8sxNRo94gYYn6HkQV5AxYu06/elj4g=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b7370698a8eso164968666b.0
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 01:43:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763199781; x=1763804581; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bu/YvVGS6f/qPnY5owZrNEIEYGYSg1/BJENMGejEMt0=;
        b=KD3UcUeIfCcuz0nFxVLYPYHfQq44A9WOO7xIcqonjMkt3bh1ctMqUK4ptcIJN4hqer
         mtDVVJlBV1Nj/aZBEtYUu8iagDF8UJ4ufakhwlLm3L9811mZzk3H2PHX9JxcrGo904iT
         5WmmlAUTAT1kwJxl90rw8KGjy3YeUerJrWoLjmH3ozZCjEGPjbo/Fd+QUVYxOOCXn4pg
         5QMKPTwSFBdtAoi+uEeqDrgmXMaHAQDoVXYYd8gm2B1a6xzBW2ZiMlDJeSRtujJVmYzs
         DS0p05pMfTCkYevB8Iz4B0DaEz0/oZp411y0TVM+G05pQOM81cI/8GXSpIrz2h/QnoPZ
         kWsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763199781; x=1763804581;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bu/YvVGS6f/qPnY5owZrNEIEYGYSg1/BJENMGejEMt0=;
        b=Vu9nlh1eG1N3MSlThzGj9LWnq8tegTfM2jy6ihTm1qscy4xPAqqAMovM0dCwFdterf
         S4JUzU/U7DLl90iMiBoFeNvWj2d3yzV71e3E1WAUPdVdadLsdQjJBelM2Lq5OmFmM99c
         3CKO9vgXMghjddBAjDZC+1yoi5kZReSoVXhI0XBujC6AoHQrjZ5yQv5RmW2sS/nu/h/w
         HPqYnFIezc3LWBcdB3fO4LI2am6sqDI7VDuxIG3/wODgOswEwCEipXSCX8NoFHC60T4u
         bTn/wUtBb2mDfKhwGiZzuQJ+LdVWyAFz7W9i4HCgolB29kpH+Jikitjo8ueVO/1Rz5mO
         hFKg==
X-Forwarded-Encrypted: i=1; AJvYcCVrrCFc2UYv1zf2pCFgAnBR6FsHJ066YjvkihM/o4RaambXAU9gJN/lPVD/2hBkLjLKAVZ1nOrRSQ==@kvack.org
X-Gm-Message-State: AOJu0YwEwKbUv+JtFMUze0zPNzzkgaFnw1xAb5DdvfPUcIAN/bfRBMS3
	ujs9RILOKAl0Jt8qiVNJUCI6yugPq9zFohYUlE5c/EU4lBUDkraWRRtfgP82CA==
X-Gm-Gg: ASbGncuJ7HMAO/B4jaJhAf09JM9FrlsXpvD0SfcXaNqm/KKnTqqKKrLdsWJXWNJqjHv
	2oZTualQosCAlNsQE2mzMeowqYwBKT4r4eos4aj5UfA/O7fsypLd7YQi1sx4TNElTrr+jatKoy/
	5+FxszqnSEZnopkOTmwCrGbufxrGzLShLMcblO65VdaGhsf0rYT5OXVxXzyKM/m/o2n6zNsO9bp
	U3WFnsrDwa1WoPLZ7zoCeAeYKy3VlXrKxAT03Rrw21QT7hqjtN5JxGTHRTKFwQ2/pjN/qOZxBGD
	MIUICmmDSn74MWRmP1Cd/dRd684XymrlXN+zdOfT/+Rdr8latGrQV6bXVqA+NCFiUNyoH3n8aPs
	n2NsWFz4gFkqhtA+FA1oK6xGYAZfm3C0/fELIg27ZcZDA7hdxCoXqObT9wT06ZWNTqaXRPehrbG
	qKpPzAmlVctYQjlA==
X-Google-Smtp-Source: AGHT+IFHioosJ5jTazsiziwouzPq3smTtQsChFlOL19ZuV0U6amI73JZiw1PCFxxEy+MouamqQ1NYQ==
X-Received: by 2002:a17:907:7f09:b0:b3c:193:820e with SMTP id a640c23a62f3a-b736789d3dcmr582744066b.13.1763199781290;
        Sat, 15 Nov 2025 01:43:01 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fad48dcsm575104566b.25.2025.11.15.01.43.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 15 Nov 2025 01:43:00 -0800 (PST)
Date: Sat, 15 Nov 2025 09:43:00 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: consolidate order-related checks into
 folio_split_supported()
Message-ID: <20251115094300.rgdhse2v73xoivq5@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251114075703.10434-1-richard.weiyang@gmail.com>
 <827fd8d8-c327-4867-9693-ec06cded55a9@kernel.org>
 <20251114150310.eua55tcgxl4mgdnp@master>
 <64b43302-e8cc-4259-9fa1-e27721c0d193@kernel.org>
 <20251115025109.yerb7gbty4h7h63s@master>
 <aRgKoQT2ZYH_x2wa@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRgKoQT2ZYH_x2wa@casper.infradead.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 18273100012
X-Rspamd-Server: rspam07
X-Stat-Signature: gqha4oo7buudjon5q3azmr3c1bes8cqz
X-Rspam-User: 
X-HE-Tag: 1763199782-945290
X-HE-Meta: U2FsdGVkX18JYGLb35MxLiOAyXbku+1cwJb9iou8ylWERXV3mdpThkDPH6uemLj11qk+uvoxjTpm1AJ73kTPIMur9WhsRN41/l6u9zTFW0xcrYIRxZhEwbtfm3ICGvcU3g+cxs4jZfw3RNJE5HN8drQeS9dB//W2+RNq5lSxmYQGuJ50Xge1ntcduhm4vGOSZgXUAkDxCP23BGE1Ca7F4UHqS7IvLK7w8GgnmcVPbkT4Yr03rJL7I3Qp1gqzfsnas2PYOHe3b5rHaBG73DdDy7E0NYv966zTdqitR6A1xh3Jrt8SDIm5fUwCDEiVTxXtVPl2LYBIVZrkN9OzX1c5QQ5Z7J1gsj6E8QrhohAZKStax2VKyp2tkPWJThj5xrgjjOhmEDOp6dOgBxQiDZMI0oDI1AJ7I/uJSdPIazLSZc9QEwa0QZe5f0IkE7HqhLLqXUh0XvoeXIhTAqcLzf01RcSlr7XofPAKoD3qxj4jB3cfZ8BKHCk5SsnJFKSo3I65g96lDXFO1UgCICY4KguAXVlJl1+8rRRz3MqdLbgEQuEwNG5YrpnMe2oRHMew37CHuGwbMZcFChCUSKYt6q7sfKppmkzMowBO//+oM/oa1olDOqlXnjhoz3rsCrbwNxx4OCUk4mcz1WSfKFV5uD3maXaTpiJ8Kc57RYWdhjWk5xxyWpHBU31nFqGhuu3vNOwATALFPrC9LbZAfq/xCgKuPToV+WlYtfJnS5kZ9fY/Sqm/+dNDfUJTTXH9V53YXGQvL73jrGwF/cZvKOg/vqg4CN2hwUf5KSd2bdcIJ3XoCkfDbMASmKqeJPRpY1mI1p29KvKUelH0q7nXvZ1qRJoJ9qoTzA4uZZ/MBtHlagLLWR+yuwvBrwVhK6Tvuiig9l/g8jv+TSaAaGNCaUOi6Bnr6nBhzeJbIrb3g08Cjr1X4Qnsi5vqg0NXnIWRjXbg47/eUACdsc0+K7CVGU0C2Dk
 JlpC7xi2
 fLLI8QLN9w2WCk28Cfxt+k+5WBha8CkjQ08zNKWGPlAXocC+L8yGVVLTS/T+SeVs0gI8tw2zw38p5hzMyq7kPWvWAuW1N++CnaJ5GbwgCd6OJGqE1usEZ2AbY00Ljxpw6j/a+xnGhjjBZOQUNhwDK4zP0GJd5VlQzxAQwa8wxcSiGhgpNIliiJgzxHjTIX/8XgkE16YGer9EHa4SlVOskPUWPH23i86PZBixTat3fqajcglNFPc8dRWWr7ZGFxHVgajATUqwFozykjn8dfn3RsRjAFXSMNyN2sDZufCgFvY7JLDihwMa/qnqewWpFBYk6O6RBO3H1M8103ng6cIBof2g5L2ru8CpPCslIHlx2NKpvy84t+Nq/dzEmr1Ky8NUalE4NYzf3xotFJYQWRLRwnqrU6tnkK04Kctu/NwAiP33jv2Ur5kn0v+PYOsIz22QBu14hKYHlqa55gjbrJR+5OHkDCOH3nsFOhWUIe+fRuhhIxAppZ5VfdPtawlHa+QiaoYruV1lK4O/S6DxyD7+6pIg7WTgx/mxYlIRu7Qm6CjZCR8Qagz3fkhdMVXSjhNSI8SESIa+8ubtP7eExhnXYu1i3Vi410vGy3tENBG94gse9tJzYXPi+bnqCffRVHgyUbp9FBb+00ydPw3bhBO0M6F5/FiPDMGqlMDe99DEwMHvGguH8yV5bxmbiBMAx/bWFuFFzSf0MOHJvjGZ/ZZyM0BHsNwU7X9T6Tl9d1GZNFtK2OPN3BeSULt1X3V7KN8jDWs9H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 05:07:45AM +0000, Matthew Wilcox wrote:
>On Sat, Nov 15, 2025 at 02:51:09AM +0000, Wei Yang wrote:
>> I am not 100% for sure. While if we trust it returns 0 if folio doesn't
>> support large folio, I am afraid we can trust it returns correct value it
>> supports. Or that would be the issue to related file system.
>> 
>> To be honest, I am lack of the capability to investigate all file system to
>> make sure this value is properly setup.
>
>Maybe you should just give up on this instead of asking so many
>questions, misunderstanding the answers, and sending more patches full
>of mistakes?

Hi, Matthew

I am glad to see your reply, but your comment makes me feel frustrated.

Well, I think we still talk about the fact. You pointed out three flaws:

  * too many questions
  * too many misunderstandings
  * full of mistakes

Per my understanding, there is only one question: whether
mapping_max_folio_order() works universally. I think it does and also Zi
suggested to use it. But since I am not sure about this, we can revert it to
keep the logic same as current.

For misunderstandings, I use the word to be polite and avoid conflict. I
went through the discussion with Zi and thought I did what he suggested. In
case I do miss something, Zi would correct me.

For full of mistakes, I am confused. I did some contributions in kernel, small
of course. Mostly correct and get merged. I know sometimes I made mistakes,
but full of mistakes, it seems not to be true.

Well, I still think this is a common review process, I am open to comment and
questions. And also glad to take suggestions from community. I still think it
is reasonable to combine the EINVAL handling, while the detail need to be
settled down. 

Have a nice weekend all.

-- 
Wei Yang
Help you, Help me

