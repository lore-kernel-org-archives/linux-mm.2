Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99C42CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 020AB8E014C; Fri, 19 Sep 2025 06:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A898E0053; Fri, 19 Sep 2025 06:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50078E014C; Fri, 19 Sep 2025 06:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D05F48E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:37:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 882221DFB17
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:37:34 +0000 (UTC)
X-FDA: 83905648428.19.0BE8C81
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9BF3C20009
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:37:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758278252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X9U9gZIYVtcJesnIs4Ndokeg4wnbvz5UlSNhlgDM20k=;
	b=6sm1qUPyGJYsVoNIv2Khq2oDIl9PUDS2vupWhYyMSfZxgSszvCXTFsdshaxrUy0pSj6sOV
	S3psygy2CoDDGdRr91NFTDGT8zZSJHYVfjLlaomBMedziXE7j0WkmIDlaItWw7F7AOYIbA
	ggajhl/DAUk+XYPNLf6DQgCR/FOabvY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758278252; a=rsa-sha256;
	cv=none;
	b=yz8gptZ/7IxSO1JgKCk3f+/MPfd05SfSmtgXCTxEkQnek+c7U5j6z5IGp+oD3NCm7ZL4qZ
	zs0wldiHtX+KDapX5o4mHMsvbl0+/P5xAVymoI7zHcLVzo3CJbswrZwXQoPEpr6pCMGKz2
	NdthYF3ILLWCyitTfGPZSCsOeb8KFro=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b2381c58941so194522566b.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:37:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758278251; x=1758883051;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9U9gZIYVtcJesnIs4Ndokeg4wnbvz5UlSNhlgDM20k=;
        b=VjH/Xj+rCiCs0XfukchsfSUg1r1LVhLWfggYzTriqX77xUMZ1/ycRQ/dEnac83gUJz
         jF0N2FRPCxF4I/+RoQsCzXpcHDN4EhymG8VqnWtD4umLINGhCcENYIEbP8dhOQ4e/EnU
         8Mfy41enD6WrPvjvBJEf0nHVAMjGDn+fQFRWKgVFSA/JX2HaPgeU7IgxORLBVypc4+u6
         P8SRgONfLDpY5q5sqQqwm3XwzbwbH6acQV9rt0WJotfhVUFRzAIfUy/JXGbPLmn0Ka4u
         fUnTMgTkI5R28EuO7iq1fOChk0E6qzzUPZAwp7MFOocibqtWmGl55R4WB2H+W+tLSDiA
         XPTA==
X-Forwarded-Encrypted: i=1; AJvYcCXB7OpD8fYe+6t9IDcnEuJjSalT57gXeNG4O0DT6Yqb0J+2lu/mrgQnjqyKr8YBNuAxrMy1uJpttA==@kvack.org
X-Gm-Message-State: AOJu0YzYe0yxRETXdcx3slGnd4lDmN6OYzfAMdU6ndjlI7XqnlFcN/No
	A5inSV9JRwwj0C6qiIdIXI7R8HZZW2awoS0VqfSJFdlGemk7da5/RcPs
X-Gm-Gg: ASbGncurGMHo0nTFE1azNjGAxBhHHnYs5pNCv/QvITz6lKlXjRl3P5rOzHynX3X+TdZ
	5dN6g7TV1OV+qSUrkjAyKeMQV+NTvYQC4FkTr7clLGxsG1zVOuVHljsq/EAkKbuQPkW6531HdC2
	Af12WP2izkOWQhfNoMaYCNxZauP0zjrZhQ/mBMwpe94+krIOTkkbHFSwLR6vzR9r+D1TEkKI+yF
	lEZ9aQ+VGxnSU6tIukgcmBBgo49OPimC+VcUuXDn/VRU10ZgJ3rky8OkCj6+EBr447OpE9R5TFY
	8z0oTI+CQBRLcfrAyiEVp2gJX/WL1Ke+L8qX2mSzZRHD5WyT3choGem+NKzZSYNE8APGiPFeuK3
	9tVfKZRDZNDRjQg==
X-Google-Smtp-Source: AGHT+IFglqUodAXwS+ScFaUf0u5cK7hW01o3j0jrGwN7eAFMAQqVtLyd+PtU4bJWyqZbJ2fZ6V8QnQ==
X-Received: by 2002:a17:907:6eab:b0:b21:b4f6:d676 with SMTP id a640c23a62f3a-b24eedb9ee5mr318558466b.25.1758278250742;
        Fri, 19 Sep 2025 03:37:30 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:73::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fc890c608sm408296566b.45.2025.09.19.03.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 03:37:30 -0700 (PDT)
Date: Fri, 19 Sep 2025 03:37:27 -0700
From: Breno Leitao <leitao@debian.org>
To: Gu Bowen <gubowen5@huawei.com>, catalin.marinas@arm.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Waiman Long <llong@redhat.com>, stable@vger.kernel.org, linux-mm@kvack.org, 
	John Ogness <john.ogness@linutronix.de>, Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v5] mm: Fix possible deadlock in kmemleak
Message-ID: <5ohuscufoavyezhy6n5blotk4hovyd2e23pfqylrfwhpu45nby@jxwe6jmkwdzb>
References: <20250822073541.1886469-1-gubowen5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822073541.1886469-1-gubowen5@huawei.com>
X-Stat-Signature: 5i88iys8pj8fmii6kyu4xuzba757shee
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BF3C20009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758278252-947927
X-HE-Meta: U2FsdGVkX18JEulmtaZ1shtojM5gcNDVOIjsmLyfhmrXz1h9Uh+b9nU7bptjNLVv9tBKfchXYkrLi5sslUUxMXBXN0Yxs9oelyxsZh9JFtHOGckByvGIPEzDwROuXwATp8liYKGVCLItAdJr1mOhNjbbbLwXhUrS/BPJitWFjx7PVwBT+6L5q/Q5L4Um8ytQTej9hJAdmQ27lhxZvSJvi2GZ/s/IwJ6m5iHAg29+pevNiXQbLC4O6/hTnjKFNiZzYydXFGjh1pT1bKxuXvtB4GectG2eRGc4/kCjw/j6WNgZpeRT9wdEPoukJu/o6x/bB+leJoxIgLJlXN7oVZLYN0PHO1/rIvhCkl7/AI6J/UExCU/ED0YmxPBf7hnWyJPQ4zKJW5LUScfb4v1awC4bSMiiT4fLXjMg4dYJyZOGibmZLIbl28sXFxatgI9mZw9lBt9uAbzWOsNKTe5K8uLGAtDN0s9lzCp8KHRViMCDeJRzTO6+YA3luW0SPlk50YlWUIK4VrGEtMlao6i6x/yNk+A4jPI391ItauipNvCYBQCRgvxF6aPhxEjeSWJfHB3emcok4SNx+M9Ihs395u/dBtQbbi29C6yaBHZdXDnXUIECXjaM5fkLl77YOzobB6QWg0v14QVrfuqWYkhbYiiYq2KsomS1OxBJexmgTc3aAoJSmAmCPwRWjseg+o4Lou+tTpGrGnOoFi6xqbo3/pa20CMnQlGCS/0VjLBbyK03pLwfqAEMNaHfHIS0Vb+5ICOiibUgZsfwye3IF/a4ERw28409pvG43N0IJL+KTKcjIFsW2jBunfimJ45ZRlANPbRbaVhVhHu4PKeOEGljJn7jm1G02Y+qcVFbfGYinl/zt3fYDmHGU6VoUMpkPP0LftTd9xZDPo8Y9bAxCTLSVbL0cQabffUqbSASPVcBwOFGq9NGqN3H4G4fXX6dy+uQxYpGd8dT6/WQHWtGvoUGbeN
 T+gWqzzt
 uCe8fK6JuSFW6WlR3buj0Ky2SVV8SuzaAYj3mfOIQntG33YxlMKARIyavljgtiZbJ2CEu0fh52trxygkvzp4WCb1t/ytMUBls26purE05qooXr50Ze/c7T9zUeDxXlr0RLBlXRGI5yM0llO6tndFdlKGZz6SkNhR6ddOwEVkNKPr2Pp80jyOFz2hlZy9rercVFwSQrm2ymnrWAENyz7nLfDbpCVGFvTStZfdp8sQU9Ro0wGYVV+NyOa/GyhXHZdXZoBH+oFsOrWhtk7WiLeCC+AtVFxMocxA4Hx+SpPbDMCdYuysWtF3zgBfRvMsGkf0kc+vgEVW+fXvo/cr4Hr/QFdahntML3xNB6YPTdZFIOsHgfxC2qOYNmup8Lng6i5S1BEnL+SnJf2bIA5kvaURdy1imtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 03:35:41PM +0800, Gu Bowen wrote:
> To solve this problem, switch to printk_safe mode before printing warning
> message, this will redirect all printk()-s to a special per-CPU buffer,
> which will be flushed later from a safe context (irq work), and this
> deadlock problem can be avoided.

I am still thinking about this problem, given I got another deadlock
issue that I was not able to debug further given I do not have the
crashdump.

Should we have a wrapper around raw_spin_lock_irqsave(kmemleak_lock,
flags), that would defer printk at all? 

Then, we can simply replace the raw_spin_lock_irqsave() by the helper,
avoiding spreading these printk_deferred_enter() in the kmemleak code.

For instance, something as this completely untested code, just to show
the idea.

	void kmemleak_lock(unsigned long *flags) {
		printk_deferred_enter();
		raw_spin_lock_irqsave(&kmemleak_lock, flags);
	}

	void kmemleak_lock(unsigned long flags) {
		raw_spin_unlock_irqrestore(&kmemleak_lock, flags);
		printk_deferred_exit();
	}

