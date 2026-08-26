Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4D13C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 14:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E70A6B008C; Wed, 26 Aug 2026 10:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997B76B0092; Wed, 26 Aug 2026 10:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 886CD6B0095; Wed, 26 Aug 2026 10:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 682056B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:10:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE47D40117
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:10:36 +0000 (UTC)
X-FDA: 85143606072.13.F69E1B4
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 01EEB18000F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:10:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=NgtdTqYN;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787753435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/foZ+M7MX7oIG5rAsNJns1XV1eb4qctVVygdk5kNIxs=;
	b=DRkHbysnBV80dWK2rWyd/3PetgRj7ASxgXMKpHLo1/+uWFJMfouJXZv0ec+S9szlK8OmED
	c00lFFco/WFUxRnAcDRUdoR3eog0p6njcbJiyS1IucirQdScK20pgcUgwLPIMkVxwWopvH
	0SggE3pzrKHl7UZO9V33vhaWO7Dr5eE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=NgtdTqYN;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787753435;
	b=okT5/Q26mh7PuP8QeESEtIXi1WqPK7pvEk5I6rSVegye6rNCGi7iSpMzhgZRExC29VTmpW
	E8ezJAI1bttudH7qQUoMFG1QmM80mizkd0U0yQmUoMqJWgb6nPijsB/x/20A0ZLcsDbdJG
	3VJfM+BBVnQzstgcNYXBbt/7xklNB6A=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92f0b5ed131so86058585a.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1787753434; x=1788358234; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/foZ+M7MX7oIG5rAsNJns1XV1eb4qctVVygdk5kNIxs=;
        b=NgtdTqYNZFbpHe9jLtCSrT11DRH/UpJB1QB4unXt809AGJ/dTu5kA38nq91H3/tOC3
         knlJZeQeQ6E1oeEJWe/MhLTfLelnGDDbXIWTzXxvznWDxgUFPnmbdFVDZIEUvcJmml4X
         cGca/Z0H3sj2G+Xx57D9ncBAU+QSFzDggbxH3ATP9Gj+EpIU6WO/JfXsVKz+X7G7KUJs
         6w+YlLK3PhJIM0dD8bOWF0ooHq02JfylHJTsx4dUtUVcsE6NGAuNSdmcNNq7WY1lQWJ2
         MVPpVlSPokq7ci2RX2X9GGJtnRVfLPDZZNliy+iAtTXpgNfo8BBihNZEOwIOvwia1xeL
         lhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787753434; x=1788358234;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/foZ+M7MX7oIG5rAsNJns1XV1eb4qctVVygdk5kNIxs=;
        b=iDSB0L+A/G3Nmz+tQ7yu6/DQdcPboGh8bzphXD5Ouzv+nCuMHcgRNRODUdqgGWYgH4
         l6p29FOdEqbaY3xZoxzqCXpNnGj66BsrHU5zO4TqxkEy4qPhzaeQ2WCMyyvISQxYp7KF
         KddnBsDOt5EMSRO0jxhSRZHhTwaeog/38UTpt+y1BcP2XIXpfKnMQqXb9ETB7nXevXt1
         YpW8IbXoCoTGdhQV4C/kFZBN0hLyMsk+9dmj/tqUfaBBZDSuniDTZihU6GlyIEqZGsLT
         SXc/z+xv14nqfzuKMaB0mXoAvaHjqJPfkDlVK2fuEjBZnCKdfQxP+VaMjeBMxlqh21ZJ
         WyWw==
X-Forwarded-Encrypted: i=1; AHgh+Rpe/QiBi/pCtx53z71YW5rPqlkRxIWIYcbUUeyz5NzZSV+2KSfzdB+D1eQLjCXQMG2sQwMzMy4p2w==@kvack.org
X-Gm-Message-State: AFuF++l57tdOm/EnBB56vdqQuYRZcbeEKK6b/m/tvMexrkWVAypbqMPi
	PQXXm6GGMNj5w95hV9a/tVWPCuUmGXM1xTWJJuv85y0DMPOZaF+Rk/is7MlvPBcd+dw=
X-Gm-Gg: AR+sD12YIU/4mrXoe8JmZsghYqbzwWxfN8trWWOcm13hbezN5Te+MK1hwGbce4AikgH
	x0l3OtLB8TjDGk8tbsPbLptgWNWtN+xefPfuC0WFrjKKu1+kZ/PYs0fGu1LTDfeACbTaWSD/Mte
	qAwuKI7h82+fBOwhlCUYpcyd4Ytd6XqJxsPD2zIbql3IIVlNThjED9twKwyHwoZuOJB8AZaiHsX
	aQhVCPw2LmVmkRBu6g9ruvCy5XsJQq4A2mcpdR1DdCTnZ8aE0Aj+4I5hrhN6+VjmShnJOmcAKC6
	9zW67OwFvD6lWuz1D4SDmDQRkd5JpF1rtEHSgqSMRVMUq9x7ZTquneyjbjGKfCacSoT5LRwyR/j
	Id2Q0ktjyZDFTmw7GKE6qzYEqd4V+ZVZwdVYnW6U3cZnCbCm41weA0ImnyuP2hToA72O3fvbyXL
	bqCioj4wUD4ayOhdvUzGA1NuSXMNo63gOvnjtenMpecmrnNA==
X-Received: by 2002:a05:620a:240c:10b0:936:e192:e394 with SMTP id af79cd13be357-9378047c277mr498130485a.31.1787753433893;
        Wed, 26 Aug 2026 07:10:33 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9377e658a3asm218414285a.36.2026.08.26.07.10.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 07:10:33 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wzEKm-0000000FQfM-2V2G;
	Wed, 26 Aug 2026 11:10:32 -0300
Date: Wed, 26 Aug 2026 11:10:32 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Liu Dalin <liudalin@kylinsec.com.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Liu Dalin <liudalin@kylinsec.com>,
	Deng yingchao <dengyingchao@kylinsec.com.cn>,
	Qin yungao <qinyungao@kylinsec.com.cn>,
	Luo Qiu <luoqiu@kylinsec.com.cn>
Subject: Re: [PATCH] mm/gup: add NULL check for unlocked parameter in
 fixup_user_fault()
Message-ID: <20260826141032.GE1449020@ziepe.ca>
References: <D1CF78FF9DD1C630+20260826062943.3255351-1-liudalin@kylinsec.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D1CF78FF9DD1C630+20260826062943.3255351-1-liudalin@kylinsec.com.cn>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5xgpp3uqdh9ut53pbcg1zruroyhy94i5
X-Rspamd-Queue-Id: 01EEB18000F
X-HE-Tag: 1787753434-682696
X-HE-Meta: U2FsdGVkX18tok0+2WwoXpwvc7Qj8SQFlOgMg4KbLEIKg1BXcMcJjWO33POhhyrs9mJ0GgfApMpdTxT9u3BquJpAEBUGgOZei6vXaUrmCLNEb2XP+d/UYe0rPn9yB6pGIPPqrjcnFsKCwlJJ3nyo1oTCJ40OVZylkyDVn8GS+75h/boRrg0GvlZFjAYP5f8Kb1Q4tnmGRUESX+Zqgclt5Gkh4ZpwkgJXtXgTqnyRex5Q7v7NdRvcD52+pr+Q/44PQwTRo3UHko7b8IDIV3jQHHOv9qfnRTPipyaXXNFNipYjFFj7JOi3r+RUGgpP3atgWNNSK5+aLHtxLPEg02+SjEl6oZxXGwkVL4ce72sZDD3HCl3TdeJsW/NDS26ZIxv6OpQWMDaDkeB2aaU+BFIijJsOr4/lZbHJVDyBPheJtGfNMrGv1FCSShu5NS+quOICzJH7SLKjRM3cldAt5v1c2ez2YUVj6OaExaeR2AIG7ILoaW3F/8x7NWmblHY+CCjIv27ecfUPwPfEfU/Tkxvh8j79mLFEGxJocqz5XJcDo3O0ePFgX7H4aqrSI8VsBI7T3gUic+rIwqXtF2dmA2fSQD34T0ek+l+b36BrDr6BL33DiV7iBeq08UyEGsESPVq06BBrx4HftI6f7daEsTnVWM5PlosmUTgL2R7b+2RwwQN8Gv4TOG/FRloQ8lEDzcRAo73U8F0eTAKOMwZqg5gn3dd7fxaSeeUNQPk7s2B7MosLlsaaykCyqYYarXF6tTrn2RwUBL3TdTLziBj9J7j8+BrToDbO594OMqL/vb8u/5IYuPRGvB8ypTKQmEc1psw1tWPzGtC9fViirzSIJeow6SWAzdIPXs5NAQM56jtS4X/haKsJ37HqDGa+Zpbuz7Tc/QiOqT2xQvYNdZ8TCdGPZos6RSJg6Mcxva4BalXIf7hGp1p+op2aBXZzC/zJrhxIAc0re6fx3SVYlDQOQ3l
 1jS6xTBg
 W2RR5ohFuNeT8CEiZln11NtrwdX+wXKT3e8xTlUfnq9BW88tkhV1TMWtZIdl/8Vwjjo8F1PM7XMjG8UQCr8uGKVDHvWK3g1QkUog2FBXlt8ByQzBqjpVW+v+TS3AWIqRf76+DL+0jvMeJoAGC9fqDTihf6Px4bnWNsepXrl9NdU+M0xofArm93Qv80VpOmLIQmgyfzshy1hkAzWVnkARrKilNjE1vxFhgkPxb1vCmTqvSCrsMlVWrGgLvppzJY4MNrD/Fq4bXKBrEueoVC0lj8zbs9cgRN2lOkh7vTpp+5PRIH96RZzHsjo/Pwo5YM7ffPW4ll17Qxo1ktUc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 02:29:43PM +0800, Liu Dalin wrote:
> While the current callers either pass a valid pointer or explicitly
> pass NULL (indicating they don't need the unlock notification), it is
> safer to add a defensive NULL check before dereferencing. This prevents
> a kernel crash if any caller passes NULL and handle_mm_fault() returns
> VM_FAULT_COMPLETED or VM_FAULT_RETRY.
> 
> Fixes smatch warnings:
> - mm/gup.c:1597 fixup_user_fault() error: we previously assumed 'unlocked' could be null (see line 1573)

It would be better to remove the previous check:

        if (unlocked)
                fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;

And update the kdoc if it is now true that the unlocked parameter
cannot be null

Jason

