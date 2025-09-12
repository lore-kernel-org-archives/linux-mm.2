Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30773CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1AB8E0011; Fri, 12 Sep 2025 05:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B958E0001; Fri, 12 Sep 2025 05:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B018E0011; Fri, 12 Sep 2025 05:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 578978E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:15:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEB0D11AB77
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:15:35 +0000 (UTC)
X-FDA: 83880040230.20.696A898
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 559961C0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:15:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gvw6DLOQ;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwGQ8oRQVn8AznJxnnkbUw/mxHPMDYaUjd124dgKqzk=;
	b=hAiBM/GAyRXOyKpSiFJ/w8otHgycwAE9GUSmXOlg5aV54dnHT/qdfzeMHUkJjYZy8lotxr
	9LMEvMY91z68bbZfT6SPVqjiSdKHdkaclgbbJj8cmGgvVSeI16D8X1QTfP7p8ROYWIwq2l
	7TdwzBwGUWC1wjNMt8kLIGBj7zdZG6c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668533; a=rsa-sha256;
	cv=none;
	b=An5UYPt1W3ZEZnsPyBfLxfXeHfWcCbDWfFqtWaLhVhpt21P4Ig7hTzQX/UIW6RkO07qgax
	GWP4qd2Lq8v2dLr9Ln/MjnFJfD9/GHtwUwnjD5XAV3qF1fs+ItLwKAkvNKWxLE8/UrvhPA
	GDCx3xgEZIjZ6TqxKgnfJ1KCWptzCcY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Gvw6DLOQ;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757668532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=KwGQ8oRQVn8AznJxnnkbUw/mxHPMDYaUjd124dgKqzk=;
	b=Gvw6DLOQFmwXAxAcQNJI0IscWy5k+/vBQqmZv3C4lB6eu+XuRTe3uTVR6gtdmcdlmDUTaV
	T/K2iXE0yzyhU9ZuVU/DXJ9Tm4S01p/Kxcnyv+je0h3f+FlZkJkCgixyivVuOBzReJi6PN
	mrmh97NDKqcZlQAaKp7zHiZLAkSFNSw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-0KwmC92RPmeYiZJ_XTbnUw-1; Fri, 12 Sep 2025 05:15:31 -0400
X-MC-Unique: 0KwmC92RPmeYiZJ_XTbnUw-1
X-Mimecast-MFC-AGG-ID: 0KwmC92RPmeYiZJ_XTbnUw_1757668530
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45cb5dbda9cso10131835e9.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757668530; x=1758273330;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KwGQ8oRQVn8AznJxnnkbUw/mxHPMDYaUjd124dgKqzk=;
        b=ThKzAA5984ES8z3Ml7MLqEySA1revQ5S5e/vvigoU1tLHIhzR2ZFu4XliWUYT8+P6E
         JdKln5VbMI2ijE1QJAOs2vEJWwQccPyKlfpB+M1Q9VYEOLGaNw8J5/gHxaadgeeZMkZ1
         dzQSL4Nn0tEnbCcO2qIMB8OFGOoDe+/byLPPTzHXC7aCwxgrOZ4jLWb/ZNRhS9kjPQJg
         LIs1SFcI2euwFffJeGm2NIJa3HdjtE4kpS6ShA9vpcIF6MdyzyrIk0itaJduLG7guN0O
         R0MUhHw22vFMbh6/enWlMZBQdmJ3ITBl855+Pfgv5rNbdKtSLwtZTnP2o8MI4vDQVMyC
         LkHg==
X-Gm-Message-State: AOJu0YwDq0nhQ4eKE2WtI50Wsvy6JmmVZo/kHz5qVwppdDwA8YDYGwQp
	mS/oHdgSclNVfkRKDQG4PWfodHLs0XIq1I4Q+MGQtv22lVZDwj49w1zBelbSPUQv6RvcR/EYrwM
	jewVUCEQz6Y6rfJcSLzTHjXE/CRJMhg5x/1UHVjCeGBVC6dqNVLDn
X-Gm-Gg: ASbGncuSQcTIpSLKfEooixRnqUrkBNgurM/j4tVdn2UeryR8fRsCGhRdpKiSSCI8sll
	u6VrW1ktR8qI2de6z1fxIflF3IrVB+ju+yFOqr5rJrI98Ake1j/c/wX7FWZd4MDg99CnPilZOML
	iBELpUqVFuTHoTr7Rl7b2EAUm93lv3swDcy3bqMOtcMX0+fn6HB4sKfzbITnIRLA1EO1pLeP1zZ
	cEiSROgUwPjh1D8mAwvnT/5rnbVrWWSZMsJLabMMu2FhXK1cC4l3pRhT5joRZSdU0eClQwcpRDG
	uSbKZgvBXFDjL7gx+QDXzzy8xyUS+9xquqxaRr8FodGBDFgyQ8PfXbTac7p5dNDwAVtCoS/dkYA
	ITmQmzyidUjb9zUs9p0Lq+KJLAGVnlYdc1/++auSbbaPWCkbxU8B1hisG0PlSX6WdCd4=
X-Received: by 2002:a05:600c:c8d:b0:45d:f7e4:87a3 with SMTP id 5b1f17b1804b1-45f214ac212mr14750015e9.3.1757668530120;
        Fri, 12 Sep 2025 02:15:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyZ+ZVWih3ILYxCOj18FtSTdXX8I6pWIX0mSZkf9d4mAPmcu4mKQKXPB0bNUIkus0NV8nx2A==
X-Received: by 2002:a05:600c:c8d:b0:45d:f7e4:87a3 with SMTP id 5b1f17b1804b1-45f214ac212mr14749825e9.3.1757668529665;
        Fri, 12 Sep 2025 02:15:29 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e766659ea0sm2434868f8f.43.2025.09.12.02.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 02:15:29 -0700 (PDT)
Message-ID: <0177c2db-a62f-4ed2-954b-6de8d3974ef3@redhat.com>
Date: Fri, 12 Sep 2025 11:15:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] userfaultfd: remove anon-vma lock for moving
 folios in MOVE ioctl
To: Lokesh Gidra <lokeshgidra@google.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <20250908044950.311548-2-lokeshgidra@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250908044950.311548-2-lokeshgidra@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JDZCvX94HHbNvlrBRcUWj4Z4HX8CCeda8-4-q_7O1lU_1757668530
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oqcudx5nfnmugd7qci3grmmicrrykhib
X-Rspamd-Queue-Id: 559961C0006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757668533-346636
X-HE-Meta: U2FsdGVkX18q2xhd8hdWRqhilMxChLWYi32xA4UZAsxg3QpWThFQKb+M39SNqp7u4GcDayUUr/iMst+u4Dl7gCLQOFLc1owvLfxTaD7LumW2jah+TGmyZ8lwACwCRZn73Y90NCUCo9pP53UHO8w4vEVSTcEogUIKj2ygeXkaNRqnxdQ49ki96X0KCT5KkeQSdfyRzfAbBQ/jDnhcgZe5aeDukEC2n7hKXfovaBulUmiKv/8MmiIC0hyyTNCNM5v9Wg8i3zd3byUfaxmTDPPBInH4QzZ0yP55f1/7LGNYT2bfzzXuW1UAUDvoWDOQ1VeRkCFf9mi0d7djQrJIBi3hnljBsRtD5G+nrFTLmea0OEbyKUixCmOqwx/z68poKq4/i+D5I4LAxXJubQ39mg2BCLEgXmUom0+2gbWgvB1mwLKNLUIvefu/oKIjOn8rA/g+NJZmrAFyhQggjAtDM92JkhD3AbLd7+oIaidT8t5IANJjWCrXquXjxI2N5+tfIgPNfry5S7kG5PXZHE9e8Lxjc1yGTYYu/QCtwLE8M+wiQ8YyejnE46kG1EWOF8v8IehoNN1N+80UTjFiW4IMe/Biu1VYV+uTOvrN9bELzbtF939R2OBDNAUklrsRuiuS7zcUoSsd9D2azQTsiAxdzr/TYo6DWtG8iRb3oWY/5f6GBhh4HLaLVG3fJTE7qiiR9McjiEzRnXFGx/6Njna2VGtF0k/XXUtdmYw44mjP4nYDoaUSCYvjeHuykT+ksbnN3q0L/GqDCiK8gP6YdoNPT3YocyH2lGeDYg2p+VbUPqT5e8jAjvqqXpQNe38p1gjvE3I4XIrU7yIBsUTJB6r5idOULd79VCJ7qFdelHPDfRNaKw30EeTHn4DPwsBhoF0D42ekHLyPi5oB74d5oqc4pbQPfVBbzmDgQlsB7QXHLAPvVbMasbLig0dwSUORxsIIiWsuBIabeWWwB4M+ZbOeYIq
 6rAjiU7X
 Qc5kqbWs8WhFhcAeTDTCO6f9n4TYG7V/tpg/gQDhsZN4NHhLPZYPs5/Nvt9mKTgals2h082MO0yw0HIRa27udXdO/HXpsbYDy4jqyZ007FqFkArjvxne4XQVJ9V5vWKKVf7NS8fYSpaKknAbZpvL9gHbtzOzYJjkS0IFGt8jdc1KqklemEhGXB2NzVgZXvi6JrN7SFtnc6+aoTg7Y+yC2FO9hdcOxC+InogZtpgEXo19R7Oo+UxTP/9pkhD1yxGg2tAPNqS5hhUG1V+0rMGRA1TRQfk7uJPxLTYF9rjxfqYywb3VtIKv6UNWY4gHDdhap+mL/XGVSuW0tLp2MOSZ/A1qEIb2PyM84SrN57iKC8wJbz22gSlHCWII5f8X9qJITy4zvFirFnIUXXpOv+1xeTpwdZpGwTna4KACPohR+P8sRDUE74E1no+i+jXlf0QNJw94gxQCEsOLWDHpXW2ceF515mscSyd1fcMXPmA0ttdOp7+8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 06:49, Lokesh Gidra wrote:
> Since rmap_walk() is now always called on locked anon folios, we don't
> have to serialize on anon_vma lock when updating folio->mapping.

I would write that as

"Now that rmap_walk() is guaranteed to be called with the folio lock 
held, we can stop serializing on the src VMA anon_vma lock when moving 
an exclusive folio from one a src VMA to a dst VMA.

When moving a folio, we modify folio->mapping through 
folio_move_anon_rmap() and adjust folio->index accordingly. Doing that
while we could have concurrent RMAP walks would be dangerous.

folio_move_anon_rmap() already enforces that the folio is locked. So
when we have the folio locked we can no longer race with concurrent
rmap_walk() as used by folio_referenced() and the anon_vma lock is no 
longer required.

Note that this handling is now the same as for other 
folio_move_anon_rmap() users that also do not hold the anon_vma lock -- 
namely COW reuse handling. These users never required the anon_vma lock
as they are only moving the anon VMA closer to the anon_vma leaf of the 
VMA, for example, from an anon_vma root to a leaf of that root. rmap 
walks were always able to tolerate that scenario."

Something like that.

> 
> This helps avoid contention on src anon_vma when multiple threads are
> simultaneously moving distinct pages from the same src vma.
> 
> CC: David Hildenbrand <david@redhat.com>
> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Peter Xu <peterx@redhat.com>
> CC: Suren Baghdasaryan <surenb@google.com>
> CC: Barry Song <baohua@kernel.org>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> ---



-- 
Cheers

David / dhildenb


