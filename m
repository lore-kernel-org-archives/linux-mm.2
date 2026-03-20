Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9634D1099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8DE6B0133; Fri, 20 Mar 2026 14:37:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99E36B0134; Fri, 20 Mar 2026 14:37:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B888B6B0135; Fri, 20 Mar 2026 14:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A315A6B0133
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:37:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4176014032D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:37:54 +0000 (UTC)
X-FDA: 84567300468.10.2E9E7AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 785E1140002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:37:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gQB+q95v;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEQY1P3IACX+aYdtqGHGKmnLWrHiTvocF0ixuzeDO6Y=;
	b=CET7B0joWvxjxCoQGf+IHGnNlf5vQ/JOFnJX7Cb+a3q0uguvzmnqoLhArZ/kjq9SF5poPY
	iaqloat/Mz71tzpBfaNg5HDsiXoKPRGLDDp/bGJ+re0IgJiAlFFJ/bWGn9V6gcinDL6Wtn
	2eFR3X/00U/55Rd0ZSTE+hZJ5wYE8Gw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031872; a=rsa-sha256;
	cv=none;
	b=39E4w0MKJ+5QYgjWWI5NofDzbtvaPcu8ffmqeuJkYj8Y71am2ONXGaJkdI82cSjb9E6jST
	ec4asAqrr5pIBJvccu1Y3wJwrh9J7TM6nIUMAW1o3KcUB5Ledk64zQbFuJ+nZA07h9gIFq
	YlP0fUXsrYDp6nIKT5jQnblD6BmNbyA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gQB+q95v;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE74560141;
	Fri, 20 Mar 2026 18:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31155C19425;
	Fri, 20 Mar 2026 18:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774031871;
	bh=Si/E4AKh8qn1kql7kpmHNbEQyC5EiKA7FzNvumpl4l0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gQB+q95vuWWmWlYLKoP/h5xQefi+w2bdCkJ1HU3uwb/ccOuEaovJz2Zo2+YodNmQ5
	 pV9wutTtq0piWY20f3p+ZI1YbB/7Lv1XPKIuj8FdlOvrqF94Vya6ZYMVLGKqryzuyF
	 63f6oZwFlzIcHUG2/nqXohmfyU0tjVawi5TddbtZ6vvleLvc9eqqDyRllrWDOd8u13
	 yyg6CuwsToO8GffTF6L4ENQTKJI2ArnFmftO0XS/AMgsYOEYI759P9Z1lVk6hBO+T5
	 /J28pR7jhzsMXDXyFjqTph31XT0RpybKTuMbop6YOhNOzhn3rJXBkj2iQXaTl6K9QE
	 qf6U9gAsTa30Q==
Message-ID: <7e3f204f-121f-4f84-8e58-97c7763615a9@kernel.org>
Date: Fri, 20 Mar 2026 19:37:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/14] mm/bootmem_info: remove handling for
 !CONFIG_SPARSEMEM_VMEMMAP
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-7-david@kernel.org> <abpfBcnGOemxQxzL@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abpfBcnGOemxQxzL@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: paxs5e3hw46aesemd681631cjmdk3qqs
X-Rspamd-Queue-Id: 785E1140002
X-Rspamd-Server: rspam03
X-HE-Tag: 1774031872-403441
X-HE-Meta: U2FsdGVkX19dYapYgN75/gUXQgvkIgmgTxzxeT+jrQzi4F54JfAXGJ1vYmvPgFKZsbafmKITvLdJfEIDx1tlDUdkrmflG7rZTo2pOhkw4wSQ0fOk6bI+fjH3TRQGgBcwlJGfz81FALvz7aNf8U4l9OguVn9YlD7o2JpsPsRjoyqOu7ZcgDt7m1BICGsKODd4CVWnHIGU2YUV8ezBWXlOqOqnQwv8g8aQxx2qLY7No0TkeBt+dT5y5IEoxp6kSXOjb2wd1BUMtrtsdtX/GbfiSijYfm8bFaucgtdfYL5jAQ59JKDos+o/FUw94/ShuaWZFJ998LtZfOwQ4Z+Z9wNRAHRFqaG+CaQ9PFgPmrjyz/PrB+xd+pkmo5Fu2Tlij40qTrUIvQVvZ9oxxAXR3YAF9RfbuBob1X4B9JMK3qcfrLuJ0iKWcGUclg7vA5Knvu3fHTajWmc92BwsQ0fD/O97n81c5XJFdXuYQlp+VIqnQPXo9UU/emFKu9SJMwI32bbEGZjQzUa0+GUf8x1EgXbviawI6AoF1OYrqcY/+XrdtUPaGUX8qEqYCAknpaf7gaMM/IenqyQ1+D37zlT/m3RoBPWdtJwB8jd/bgTuUYrcYUZFtNQ8rryjomZBRXqjPw93HNaik3C9peNI/1MgyAFkvLc8tq60VNE3CFRyjFpYVvEp/ESdumz/ZvOvVES6+jhK485XT//0pmKYcCwvpmMuxwyD+NDgn8d5GK1Z3+au1UD98EREbbp9vfo7XB/25eD1JUsgca5Oi8WiM+MAe4St58giNzlG8ou0bKPtAdh3fN7N8RKH3jXgaGiUPzhJfJjxTxj3LO7TPK2xY82dJ7UGRCa2VIyjGeuRAj9SOww7R94wzPrYAtlrdmclNH2VFdNfzglD1MT+Toi2FZxlrS+EUUajoX6T0CV7kkKQYucmeW61F7nsEcBLDkHTGhfHp8on9ZHzR+8kGTT6iKynt0E
 9IG/ghIB
 gHNA8N2DtY1p58FngzGTKniv+IQGcAMXe90WdvSsNlUqN6E0TjvzJ6ItfzVTXvx5uHg4dxCU5y0ih58tXQbu0arZQhi7c1S/dgDCUL+Q2wSSQTN3cFsOTj77rd5gER7GNn9py39jzLJYmB82TLBeE1bZiRor3TC3edInbfuY9+pgwA7K2yQyjfXgrhHbZCbQ2t6GVgjyDHyAkwVa1H017IgIyt+T+M/96q2FbujssGq+UPg/EJi8pfO9jVccK18bPN/aBnADGrWY6aM/MJE/0Xf/0ESKMnJPfC+cCDiOGPeWko3Ky3fYJpKbK2HUVi7gx1e3wrhWcrrNsjcpSHBJUlK6ybPHOGAxt027Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 09:15, Mike Rapoport wrote:
> On Tue, Mar 17, 2026 at 05:56:44PM +0100, David Hildenbrand (Arm) wrote:
>> It is not immediately obvious that CONFIG_HAVE_BOOTMEM_INFO_NODE is
> 
> Would be nice to make it more obvious, e.g. something like the patch below.

Given that I'll remove CONFIG_HAVE_BOOTMEM_INFO_NODE completely soon,
I'll not perform that for now.

If, however, I don't get it done within the next month I'll send such a
patch to make it clearer. :)

-- 
Cheers,

David

