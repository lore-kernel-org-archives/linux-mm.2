Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE710CD8CBE
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 18:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0226B8E0008; Thu, 13 Nov 2025 13:24:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13DE8E0002; Thu, 13 Nov 2025 13:24:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDB9C8E0008; Thu, 13 Nov 2025 13:24:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA1A78E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:24:33 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C4864D732
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:24:33 +0000 (UTC)
X-FDA: 84106409226.20.482169C
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id C500A180019
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:24:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SmwKD6Fx;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763058271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tmW/lrZxV0+WT3hTfIHsxdxTRQDqTIF0lpXFC7BFWnc=;
	b=1BUNxz2rHb2dWyNm08j8j9qv7aXVJingpFLKPsxcHKtGTf0AbnEAWFcajMY7KOp6MZrsU7
	tAkNhU0FvEvzQm03lJraMDXwHJpgdHExqCqmNJT63RtDSZPvoYo1cW9Jnu312XpRny8ay5
	Moo6eJgjCE5Ooi/RYwr9rdTh55xMlDw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SmwKD6Fx;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763058271; a=rsa-sha256;
	cv=none;
	b=euAiY37c+iky9hYSd5FjvC6M99Rfqy3mn4u/bOq3rtfIck0KnwPh6QS1XYAvx3dkHTv4j2
	Vsa8nJl2kG3ek+RtDSD1qGBYoMLLGDLh0ln4loSPMC53TXZqOm3VPiRkuFakaY/0L7FWT4
	D4u+GU4kPiIgPXCPxpQXx56mLwT5OIQ=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7aad4823079so1128795b3a.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763058270; x=1763663070; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tmW/lrZxV0+WT3hTfIHsxdxTRQDqTIF0lpXFC7BFWnc=;
        b=SmwKD6Fx3Pqm1/NrfRW9rM4cZg7JY0q0jesKEiyE9YGTF276auWTPuLYH7OEXvRx8x
         6zXW7hiY48wyQiV+lo2NlSS2ZRQc4W6A9JMaje//TVHnAjs5zPJ7tBI5Hbh8R8I832QH
         EHu8Dd4+A7wytUqpUYQ8EyZDTyVmMlL8qs1L7SuOYS67jWyCW6/j2FF/dZ7MrO3qGh/w
         vkN+w4U7iGUviga2hgVa02meCPYACTpkjJusj83zi6yiMdk1apjN5vsCDVAu6uqDZ26j
         9Ud4hI8wH/jR6ZOfW7qw7miMCg+9tsml7rn5CdvzzKGRRlVkqWFroqTN7SSSncYICT8E
         WPlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763058270; x=1763663070;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tmW/lrZxV0+WT3hTfIHsxdxTRQDqTIF0lpXFC7BFWnc=;
        b=b3JeJJXn60b/xo3WlHE0NDAeohtIJvvKxmgjUwWpWBxKFF3OcLFzE/uvEoAhhDaTlT
         nf24X+vV65sWhI6xNjuOozYw6/dnM23F8d+N8yz4gz8rjAbivi9J7D0hQbDai+YZNGOb
         Tc/9GdWJpOmcAGYw1dNHR6mXNE1LHo8jBiIV7cGkY3jDNDH5SUApexDAG8lpI2ony7M+
         9GufU0GKqRezGWSlnTuFVESxNxIcZ3hQa+RfYh4mvhTdhln8XUfcb1f/HKckpPvkphq6
         pN/YpuvA9VfzmldRXVLEqAit0Avg1oyLx4dYatMA8B4aaBYjgHs8kWwsDFFSuDg3l4+G
         IS/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUAoEww93DUfonSWnEKMnUIGZbFQGhxseb0q+oEcRY8Tt7+Wfy641tuzqNhscQsOtW08PhdUHYqFg==@kvack.org
X-Gm-Message-State: AOJu0YzhkuhsBGOkzCjbNi9M4EAiqFgZzHYaMq5KhOozjYS9aZJDEjVK
	CxszYZlAOrRsQ11HYsTxrtVuhm2+rGxWj8XkM2Nd5ErI3zEVw8KcI8G9zzS3cQ==
X-Gm-Gg: ASbGncugFrZKSmfzic2NNL7crynBP0zMTu4g/ta7BRbr42d7z2O78YQE86s+LITI5Wb
	v3fmBm9TfszlZJXdjuw4Jajarw3+80LUvgjps2w/ioR/NiimQWKeROnBBfbyNKCtiGgKW8yW7lw
	CKY63+kSR+m1YgNhUckKZ5ULu6CHegXELLqwwRpoyqJLK1lMQCcTbO+kK2X4Mv6+nUX5H8V4HPY
	zAXm4MHb3MEYtENYYgq/YvLlaHLBKhbZe8NaRp1auPaRXv97hjxjOWBhkN79faNZwpEE8LHzBNy
	O70ax0FmGlFVd6jmHeM8XwPTk9++68iHgdrshUGb2+7a7kBi3BsawtYF3ZZ3KIGKftlBWpvt2Qt
	BZpnkEXVNwvxGkf2BOygRrgGqk+4DXqYJsrwseCzItuRWWtrKvd+uy2LOHZX3NYvm5Z8lH0aZ9B
	ru/YZTRI0nxDtSTQNR58OJPIlMJU4JcpR4
X-Google-Smtp-Source: AGHT+IGNEuBxfc90jh4KNHh4KsS5YAfC+2WlLTOhWLaDZRi8wLpcgjZIQ0XdbPIXV74gkeb51xJxpQ==
X-Received: by 2002:a05:6a20:a110:b0:33f:df99:11ed with SMTP id adf61e73a8af0-35ba12ad351mr719526637.24.1763058270412;
        Thu, 13 Nov 2025 10:24:30 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b9e3f288b1sm1168801b3a.7.2025.11.13.10.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 10:24:29 -0800 (PST)
Date: Thu, 13 Nov 2025 10:24:27 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] mm: Use frozen pages for page tables
Message-ID: <aRYiW91uAGH02UGL@fedora>
References: <20251113140448.1814860-1-willy@infradead.org>
 <20251113140448.1814860-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113140448.1814860-2-willy@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C500A180019
X-Stat-Signature: 6yk4n9ryu3mkt1xqico1a3guxxwt37zw
X-Rspam-User: 
X-HE-Tag: 1763058271-377321
X-HE-Meta: U2FsdGVkX1+YreuV+qh4hbH6evv7zzKTGZh7YQ1a3jo50LWbR6qchUzLG7H0HxD9DZc4ax98sHmNjI8BEDdA4XcDFjYJjrdO6yA8H4/hhM4il3MCKkalsF5DOmRfOoVKuu2OLCBntVzm907UcTHwaJrQwW3V7uIEYfqRy8kMW2czBWWjrJkPwIFMJVRulna51DO9FvVJQFojSblSstLDu1MuVlY8r4uwFEzngRCorhsaeTvliF0fygSrm2jJySiq7mzj0ffgGYgJqdAGANvzG2nXVI39ZrWVAnabMUh0WIBYn9prIa+oVtXIAcS+ezUs0Nwjv+G2Clr73fqgZ3RUgf0y5rCoidT8CCYVrXp+W22JnjPKgRCGq3x6wpt154qJdYZPs7uBTlA8V3qVb6Pdja8vkhi+E3Ghjh44HjrhCQzCSzbWXSvsi3EdUncnFxLBgyv/tePBXCwghLT+ilmd9enVzJKs0qUNlw+DaSblObLHxXHciNQnMzIvF+S+XZlnoBxWNvYkZ40GnTEYOS+gVakAlG1XlfkP7oyr+M8V1IZmuqJkN8+0ED7Fsaf6mIyoGStSNKxXiPBeL0GRYFqF01wfc9hUKQYz4wnf/a0ygVrHaH6WJpH3R7PeCQgtuyIC1zaCxVGidM/hSXR694UlmQOuiVs1bKz5m6q6IFvPopGvclU4Q7tRJbQqR4YBLUJv93CO7GrWlbnsDwCIB5PLYlfz4UdlvYG5VDVQB9o50Og8zuJ0UrIVXKeIl9pdKeCfbC+U0eNamipzYL4ipAItrhqINXue+J9qZYZYvIa6ZfT8GIj2AwlouJCA+VGA7FaVgNxNye1875NmjkZ/Nj39MC0Gxmr9jaX+f0U4WCl15dYAvzP5KbKHZPLDrm5adDSpUHyBwMDmq+1o/Fn+yCGo20cweEPmo3MGPtcUwgnU4ZpAedQ5GJQsFuzq1q2nOBrV5yokjHBdkMwOq5ky66b
 egLibOZw
 K+5jK1iOtyJX3TGCU7jI4EK1/t9hqR9dv4aUijkS/mPywPv7Qx5fYOy9UTkHvrnShAROVxVm5zo90yFS1RfvwLJcl2bXp7MQ4vNDfO0mhVzovVoK0AG8n6+A8YyxQO/KZhjXd+U0sgBlKnmwdANFSlQX2o7m2tXyfA3UZxarfQNoyOM0RMpiWo4ZHvAOy2Zwge0EcvZQGfHq1izwFGuNvty3n+C2nvKhgcACNay9dFM9WbxvwVGoPHAAET0SGR0XgfivQ9mTTx+/ODB+dNQsdawugYMDzb3BVZ094ty9MdRwd0j5HMxYcd+/teI2MUWaee7F8NjxVpZ4+V++zj98erBJpZTrvXLfL6+2VIuK4OPMJDC1b7s41L+MRSRIobl1aEf7qwhu6m2unTB32azeXexeLDZJ42RST9QrCuPd8w1ianoDFlO9rWRLkLYbmekBeH09WH+98HI3yKeQF3U/spS7tgYwqXPCpPGbmw3u2H5hxnY5cxdKI6rSOCbLfCW8rurWaCQY+ACesuzubea1FSDLWqnw1PAwXh7e6b6LpwMzbArpOgsEHTavywiIwyamr9iAx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 02:04:43PM +0000, Matthew Wilcox (Oracle) wrote:
> Page tables do not use the reference count.  That means we can avoid
> two atomic operations (one on alloc, one on free) by allocating frozen
> pages here.  This does not interfere with compaction as page tables are
> non-movable allocations.
> 
> pagetable_alloc() and pagetable_free() need to move out of line to make
> this work as alloc_frozen_page() and free_frozen_page() are not exported

Nit: s/page/pages/g

> outside the mm for now.  We'll want them out of line anyway soon.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

LGTM.
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

