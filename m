Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F4C6C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 00:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2CE86B0092; Fri, 10 Jul 2026 20:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE3B6B0093; Fri, 10 Jul 2026 20:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3FB6B0095; Fri, 10 Jul 2026 20:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF63F6B0092
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 20:35:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25031C3D62
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:35:23 +0000 (UTC)
X-FDA: 84974626926.13.3C74BEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 67DCB80004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 00:35:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vpZBreY5;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783730121;
	b=W0Okvrb+ovdiQ27ElG9w096wb+iGRcJmbkMyMRx0SCmQuO7GcdR/19d45rl2jGWGwtawVi
	2Xu+AE7WrhtOVxKrPzNRK+sttbO/S2lgJTeGX3zzU/GqbWRlj85hBQgMewfhE5mTYfFcr3
	xtEKiiK9HJcXC7k+6ESjaHUBx3uM98M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vpZBreY5;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783730121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/XpuYVonAgaCueqKAIAJqADpLtictQ6WOctvnY06bA=;
	b=m8q80jOKjZ9NuB943EcRarnkoaud+/LrVbKA/HNjDqkBOYqeAHVsx31IZkoagN8k6RQ8F8
	CGsZW/kbs1/gO1Z1OJwXNB/4jlS/H9pocqRDyf/6g+5orBCNdxkLbc3usl/IPbcblJjS/c
	hwvZr0GTAZsPJcBn83GQy820ctSSD44=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84DE343D9D;
	Sat, 11 Jul 2026 00:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95EC1F000E9;
	Sat, 11 Jul 2026 00:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783730120;
	bh=e/XpuYVonAgaCueqKAIAJqADpLtictQ6WOctvnY06bA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=vpZBreY504FDMjm/FcEd7LyqQsOpS/rcRUt02q0MAeMBgAPJsEAu4mMs1vFozFlYE
	 1nyeQMmClvMdHYjQnGTHVIiA6Czr62I9WWfhxSMsTANPD0fDPwJhjzQw0zrxvedBPX
	 UPoQcivLf/Tb1zbNIWN7v3AmHJJimJ8g+w8UeGg0=
Date: Fri, 10 Jul 2026 17:35:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH v2 5/5] mm/rmap: add anon folio unmap dispatcher
Message-Id: <20260710173519.d7659f9705afa37ad62e7bbb@linux-foundation.org>
In-Reply-To: <42300e6c-523b-4f58-98f7-672ce9173fe2@arm.com>
References: <20260710055915.638659-1-dev.jain@arm.com>
	<20260710055915.638659-6-dev.jain@arm.com>
	<00467fbf-0360-47be-94bc-d1456323e5a1@kernel.org>
	<42300e6c-523b-4f58-98f7-672ce9173fe2@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 67DCB80004
X-Rspam-User: 
X-Stat-Signature: hj6yyrgxufn8upw19uzj6znx9d6pcurp
X-Rspamd-Server: rspam03
X-HE-Tag: 1783730121-145154
X-HE-Meta: U2FsdGVkX1+9AQVb0yjE6fNaytwR157esfM3CIDH8nVPLTW5s72lzkrDHSVSkmg8NleGeWeHyyX46okn82NqT34rnF6pn0uEUMGebjlcdvBShWam010rDd4I59z0OB+mFTi35iQWhEftNEYBaL8UBtxuMQPrjxT1xyMd29pTj/9IeBbLkR+ohLUQUUrDPMbRUCMWAT7uDIxNNEV1/6MRbBwrNy4uT6Sr9JWE3p40QofY1UKnAXRlrbfXGjtIJAmZfvS2ts8DvHz1EPwQJ4b4JL0cvWFtS0srPhBuQsxZLqvYunjhQuM8v54tgF/9zZ8uVxIUtnSmrVfCbDnXZcy2OGMoVfJGiA5gXx3ZDZEagUbnUjVoaxsOuRJekOcp0r+AaAuxsJD9wgfE/vkVhW1NaawjjARGzjWC1WrVHw3sKa+xczXSq5NHtTKXnryAM90q/qaV+r3ZwjKpjISnnDU4vaothxX+aVfVxnbH/PglG4hIyIfkACcyOWYcKFvIAUKInmLgkH2INXfSE6IiJpEwl9LOrBuA5es5csngO7V0scHsPXtGNhraiP+mktnENxAcuojdumI3gLKL9KlUAJ7otUqfABevYPkAebTY9ji7YKgOwOvrsl7RFJSKHNk7uFNbnuD+VqZFEt12pXoWC+N/g1mFlHqqTzECvKFHXuyyI0juD79SqSNxqmhsvl9U6waziGzVKiLtlcb4gbqIEDKaDsDmN3F8Kw+yPL0ksdgTtlhLWh4UtjY9PU++L9LUsglh26SHLmktRmHAN7SQmJlb5x0KkeKypfAcwBXcZDtVDs4RBbEBB5AnpMTjPikWAcpN6xOYv1YOPaNOyVl/ocNOug5rKr4l9fsBf33+i8AXiMbM4m3eVguG5oOTz8r+BO2zaBVHvph9QH7Iw8dZMh8ztZI4DmHksKsSdATMmbOXCSQRWeK+CBcQqYa/4R6upYGRv+W8FDWvaB6V14mHPkg
 sF2E9fRM
 KKK54SMFao5HovKVHtnA98UWwS8AOI7R7PE0Gbch2UjNGdjf+F7Ux8Zo4v0BfxOB7IOoW2GjSGN+RsDYbkuub/pTyvfGfph/Vd+KdGkc3Nday+qdZTB45JjWx6x1znmXBUIfIISQMTIDNEyAS9jdA/xiH9zwrL17MmADDXDM7krHB8/EdUhiubxOWqHEEHK3K1dR56FPyo38ojnur7OgQT3Hg/tYqLw/Xe9FCdECleQoJeOft9s2nnPu+3GpPbGRyC4YuizHqm5dbvL0dt5kfYWOxVv4/IMfLxrXPqn6U51uist1anJx/nQRNDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 18:43:14 +0530 Dev Jain <dev.jain@arm.com> wrote:

> Andrew, could you you squash this diff:

I think I'll await v3, please.  I'm getting a big reject in rmap.c and
methinks we're all a bit firehosed at present.

Are we all agreed that we'll be "batching anonymous large folio
unmapping to optimize it"?  If not, is this series pointful?


