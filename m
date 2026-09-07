Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 816B2C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7726F6B00A4; Mon,  7 Sep 2026 12:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7234B6B00A5; Mon,  7 Sep 2026 12:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EAE86B00A6; Mon,  7 Sep 2026 12:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33F5F6B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:21:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B83731401EC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:21:37 +0000 (UTC)
X-FDA: 85187481834.11.B7B93CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 091AB18000F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:21:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WioyDUTT;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788798096;
	b=xAS1cnCVWkaOCW+384pzVaAhOD32BS9hgv+HFMpCtCgeUUkVzuBqFfetGzvRODSBatgjfj
	+prevgMfzkgn2v/sUFZgv4R/e3ssM4YtP811xCT3wtitJd1mgep2abIAWr0c2/VBPoT3Ux
	5qvsv4UlhG3n1ITyzOekcXh1ETkSnKE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WioyDUTT;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788798096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FcNaC3tk4BXA1Rw0dktdlxAia8YznUdS4WNauHXOFY=;
	b=iAfwc7/KTcrHlf+ioSlnSW9vNxSwp2HEg/nll5payunj3/vYpAAcvkSl7Dabo4ccDIcUUP
	rqyqh+ae8Wi4gqWE1xwtC1OqdrDkYNb1F7MQAk5wlkNZ2sXbrv++nf+NGuIAZTBrA3Ob31
	UJidfYebcOMoOSXCfpCqVSCO9P2vX9U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BD5E601DB;
	Mon,  7 Sep 2026 16:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4641F00A3E;
	Mon,  7 Sep 2026 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788798095;
	bh=1FcNaC3tk4BXA1Rw0dktdlxAia8YznUdS4WNauHXOFY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WioyDUTTj2SiZw9LN5ke28ZFLliBYvU9wN/q0/x+LOXIMH7mcf/0D27FC7YFtJeKK
	 ESRHLr22hys2gbj0GZXm6i5sPjXSobpyGsHbKEy4X5VdOOSBZoaNPmaJJ0B+JKdl7x
	 bOlo1MY6Am+P+mVK1amJkr0tl/iNAmL8sllqLqxB4g4qdAoz0UnpLuxs1bxh7X7cNw
	 L/N5EOxXwQ468K8MQsNbEJEy2xqeCIjMI/5O0xK4u4p0DeqNJchIatLOLoVAXGTIEv
	 sLyn1+/KK8yns9tOK72XsILWbA2QWSAoL6rrJSMBJake+IyZPgb02XvITcPjEATZ3+
	 kN9cnET569djA==
Message-ID: <292b27a7-94d1-4a2e-8346-a53e80fd2ed0@kernel.org>
Date: Mon, 7 Sep 2026 18:21:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] mm: implement file_is_dev_zero() to uniquely identify
 /dev/zero
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
 <20260902-map-private-dev-zero-v1-2-a578c730cec7@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260902-map-private-dev-zero-v1-2-a578c730cec7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 091AB18000F
X-Stat-Signature: 4uhjydpidtn6wkw14xb9amw76cuyxxsu
X-HE-Tag: 1788798095-72715
X-HE-Meta: U2FsdGVkX19iaQr7LlZU8SLla0F5hCgCCNvozuIYkLD9DRZxJo/tMQkd6wyS8r25vaxBdfNmD+0npt8qFf8WlGnHlwUncttQ4saqs+AjR1HVgVbbut35Ngx3fCgd3/WFLx3JmSoEy4Uwavg7hVu223fR/p1UJJZusExd3TMCC/CFJVwyMqFUn+Oo8P6SgM8CPlhMq0MZZezZ6ZGak2sn9qRKKnCIxbaeGBut0ID6dd6cjcw3QEzFNhBQQIz+ZJdPHHRTu32nH8L7h7goABTc4inSjUT7T0Q9FEM2gEajasf9ghhmTMJxB7I30xaz5S2oK79zI8NhMzbtLUosFo15+4PBNKfYRYRLshdbvo4pwgKJT25hXswRZIqMEL1FGr26fws4uhChlPKVbEbCad+oXr9FZGN76cSfjZb7E+InVis8xNYHu0UaSXa8Ihw9MI0EbhpxemJeoK2YYCM4QpuxFV8K9ROKZgfXjsZQpLjJCbZi3NiMA7KmEcAzXxZwbi0V4XvsyX3aIoGn9NdSMtm1lB2rBbBNLML0ErvOqHi6FoyF4geshB1v/6IU8PAgn6JpyAXoXf2uwyZLtCxaQoBGEj7ojssR4FS5xyGIPsjfSwX6NhFJmZXrPY4wvgvTgvtzs8eAriaV2hzqPKSxp+U/FyDL4LfHf/96sOjbmy+98kd51whlXVNC1iFLf++vZEx13K6+HREFAaaj4SAus70vI3RITHyjkaPleITgakl5AumuEwrZ3A/B3BZVJ7aVitkqePCHEd/sbEboLAgcusxUQr3DWycujrRU/vkdW0+/knxFJC23QJiZGXxambH383H/EYq/Oe1lvKy4TfdkEiNv3FrIixzZ1hov41aRnrh7F1BxrN9ZLsv6WxidBfgoBpjYyz3ETr/WcaXav7i7FyBkCzUaWXMHUnSXehs9htEDlH6XuV1/mnubYwOvNUHwa/cTfFZUwEaZDvvkkVDQvHu
 nWMIFVwV
 vsefPkvKfT4VuQQWfqJNWcuWUwXO+vTR5U23cwwLRYFa9QHKbwWjJ2J/McJ8VQrO6CaMN0zS7Lue33hcIodZgDYXpZL0/LRJdfdIkGvnY92KnLVqhQOWkIDKfAn3eehsPmuIXCWuqCmQD7R/ze904HYJPc2FTI/h6J3p91RvZXwAZL/lPpKvXeKMNZbc4RZkBgbVk5ZquvW98t6dMqUCYTi4QWzhA+8cqM9dTtNIFn3FSox3BoCKEcTeX63s5X98+ldlQYRUdKMnlJSKzXAgt8zhsUMFAtn0X2lrRIeE9/WzVEbOmZEHdEBLlAbZTsHfa9HrIYZfWNg7iReg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 20:00, Lorenzo Stoakes (ARM) wrote:
> To lay the foundation for a future change that converts
> MAP_PRIVATE-/dev/zero mappings to be truly anonymous, add the ability to
> uniquely identify these mappings.
> 
> With the memory character device now part of mm/ this is trivially
> achievable through a file_is_dev_zero() predicate that simply tests that
> the file operation hooks are zero_fops.
> 
> Also update userland VMA tests to expose file_is_dev_zero() and provide
> a stub zero_fops for testing.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

yes!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

