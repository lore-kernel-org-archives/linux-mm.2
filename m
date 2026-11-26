Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 178BC606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 16:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Njt9YdYH
Received: by kanga.kvack.org (Postfix)
	id 2C7FA6B05B0; Thu, 26 Nov 2026 11:10:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278646B05B1; Thu, 26 Nov 2026 11:10:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167966B05B2; Thu, 26 Nov 2026 11:10:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2A106B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:10:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03BE81A0FD1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:10:09 +0000 (UTC)
X-FDA: 85477756980.10.6EA264A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5F85040014
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:10:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Njt9YdYH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795709407;
	b=2lIQPdnFAJhCrCdZJh/uiFJGE8E6Gfqq0n9UpLjhm2tqb6dXFxprLzpVRJmBVaYuAMqAGs
	WzpBjoaUIVzfjzzM/J6b7mBZP2ChY4t0RK1w5GU+dDhxKbXmjAKigx9OU4o75dyat8ePtd
	OFKsZxyNxGInkLQzRoOR9twUMRM16jg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795709407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wxm0q+9pqrQa87GpYE9M2lUimiUIeR4Fl+shQ/7gsqI=;
	b=4t7Y7rzR+lFWWNr/nKtclmm7EwlAnMLc5xBj7JcDmWoSOvUBLQBglCJJ+/PbUU4dcmko5Q
	EP9IjPItEFB/xk7OcJW6vMHjsQkEo80EIqTe/CBbtve9AuHHgsLIUas2Gtz6BIwV+j9eED
	wYL0AxRKyRM7iGnNs8OcDFQnP4jLcV4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Njt9YdYH;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795709406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wxm0q+9pqrQa87GpYE9M2lUimiUIeR4Fl+shQ/7gsqI=;
	b=Njt9YdYHCv+3LwKsUy4LFmJRmM/UiiI1WoKDkPz9zDv4FtXJJqbcXU3+LwSO6434dbDfi5
	9Tv1lony+Xego12J06r312G+J8/gCHY+pLIHS0vW8mIsLzY3QYqHhGlQ2kEli23P94b+01
	CSiONo+AXbDVKpJApRcAirMARLekiBE=
X-MC-Rep: binary re single
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-BEzMEeasPfykXkqN9jE0MQ-1; Thu, 26 Nov 2026 16:10:05 +0000
X-MC-Unique: BEzMEeasPfykXkqN9jE0MQ-1
X-Mimecast-MFC-AGG-ID: BEzMEeasPfykXkqN9jE0MQ_1795709404
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4bb680f0ac4so50436095e9.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:10:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795709404; x=1796314204;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wxm0q+9pqrQa87GpYE9M2lUimiUIeR4Fl+shQ/7gsqI=;
        b=cT8XO/3DUFnIPGvpdgcz482ZXXEAXbJ1pA0zGEbS2lXbwJwOMixfdm8PK19PPqykJ2
         iSthvX56E/7AZxoDFpupN6RehZMd3jL52WNUtMQO8TccB/UqUOBxeDk+BdHPnj5hYHlh
         e6ujoKbKapj/4z9Ni0KYVqexWWUg93p6treZGd7LWJUC49X3AhwUL+NvZmddqgtaMXIq
         UCjPczZGV5neaUfaCd6xvz3CeeEfmx0FRr9FblOyoZWWI9VR82LOppc9w7SysWpE3hp2
         GhN3jTxg/eMUsw1VU8nvZbYjUx9TO73y+6crMWfjJ9tGdwCPKtHp/J/7Qp8AmNym1pq+
         irRw==
X-Forwarded-Encrypted: i=1; AL+hErE+lNifnmsjtuvgjBtBCmFpEDNXH2yFzhguUfWvDciDmR/dtVOid0QUJGR7KJxfM0BtTUEl3EdTAg==@kvack.org
X-Gm-Message-State: APuU4Z+ZD7RvYPFvu3ArJ1juVcx4/U/qCm8omRYFkji2VtdYj5B1zULu
	WXMd6Cw+SMiu3Q+mzQhOGY6yO/0E85nh0YhCFOXWpiD8hA33hZkUrjqm7bjPhFdcC86Im2S85eL
	5WpzPh/Elu9xXkbdOSsAO6557B3pL0UNABnQreqi3h0q/zm2fMiIn
X-Gm-Gg: AZFdTZdrcRtBymYRVDS1uxq27x5tB9438AhasHa3a992o6otc0yQhEE6M6SiTcEqQTq
	ScmYStSEn/CFe/WmzgEv3/VUwjhWhG18u2I0Mr6OVWBM8PPj2Q3yrg+3b3E7cuWXfBzBQh4bhrr
	T8zZelq82g7wdq+kDxxAier2DPF6CS7Q0t2erhO9/EdBrp97IP9eUYiKxi7fmAz+STsuj0K/HUH
	dcliKMYoRWMClAL6HOKCB7jz5skWlkzOHRFiy8K2UnhB/qT0A0ImlTMfFtt/gATjSNhneIRMhrv
	H7Mg7XZhuY0yB0lUJBb53E4IvGbkgmzi07OoEMaNNREnysSlLcWr6uqdRBJUzvbSmPRhbQDA++i
	4tzIli1mgZcA71KY2pNevdfZcwIEzd9ZjIHFDnwL/YKNtQnHn/fwVotuVidFMkuUVZjsx3iqnu3
	VZDOqvpMdckncXEHTfw5Mq1eC5X/jMe1RU6R4n3okOFSzL
X-Received: by 2002:a05:600c:8210:b0:4a1:dbdf:17a8 with SMTP id 5b1f17b1804b1-4bb887e25e8mr430750395e9.2.1795709404065;
        Thu, 26 Nov 2026 08:10:04 -0800 (PST)
X-Received: by 2002:a05:600c:8210:b0:4a1:dbdf:17a8 with SMTP id 5b1f17b1804b1-4bb887e25e8mr430749705e9.2.1795709403638;
        Thu, 26 Nov 2026 08:10:03 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884865b1sm622216265e9.5.2026.11.26.08.10.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 08:10:03 -0800 (PST)
Message-ID: <bcbb57bd-6447-4faa-a56c-9bdf1c7bc90a@redhat.com>
Date: Thu, 26 Nov 2026 17:10:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 4/4] net: skbuff: limit folio refcount when splicing
 from sockets
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>,
 Song Liu <songliubraving@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Rik van Riel <riel@surriel.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
 <20261118-skb_refcount_overflow-v1-4-5551b4954c3f@kernel.org>
 <14059088-7992-4d89-ac6c-1e6d1f61b3c8@redhat.com>
 <832f42a7-1d44-4138-a7f5-7cead4a28e57@kernel.org>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <832f42a7-1d44-4138-a7f5-7cead4a28e57@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: f6kk6f-etu7c9g39UefCr18c5TGCP0259pxpbem-2iw_1795709404
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5F85040014
X-Stat-Signature: d9yieas6kt8fiajqriwukjpd4onqrkaf
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795709407-344578
X-HE-Meta: U2FsdGVkX19OoZ1oX2ZAP79CkiKfWK+QniQjRWNrg7UEIhuk6TwPmt/viTFjimilKsZtEV5AYf3duuCgwnT9DI2YXlp5lIQJLKCtCBu5V4Z0QHEitOlyQwhmFknkqMwNbGR6+xJrnexFHpQ8bz69hL80qj93AGW7rp37KpwIGFju4SyzRXeSntWr2ZmDLvvZcqpiRGlXkewVpWLVNGXQ150nNXr1Y8kDY2OqduWm+zQFuBvhqBmRtA0sv+aLn8d7bQsLV5AE+itoRs4PyEnskyBrpmEC/pUL7bBaQU6X96BTKyTJamAbC0CfEBDrwp6SBOrbMSrWTVWvF6UhkcGw8OkpUnI/bnmBqWLkM7bMN10s9+Rd2tPbytrOBXbTV5/nKUgX7JsegqFP60YMz6c9A4UmibNEbVkqofUBfBsSTcEV1LEFXykBg1ovfWGw50/WFuZcW8jExXxdVQ0E0Mk1f/f3tBT8TQRGzVQwpqjxA9vwU0VoNGBiVe8kULCTqk+ypm3GPY0te5/CRLG8Int7Mrr18RsJYbiyfSTg19AA+ZIGhRbXGYQKtFCPIhrZo++sgGAepghn0kzkshqsHVmufITjYu1DlCW+Absuxr12Gz9iKz9FU1Pd5cnh0Lp0k0V7GwWeNSmjbfjArGr1fpCze45dO5fJ6CapmK0HqnyIu7u6fguJC6V9lvEg3/cVFGmqQdIwb/WVt8rlwg1VzwZUghdDdhyPmBYFT2+TY2aYmHlgx4JJuI/W7St9IlPUTjIoKcc4r6wfVSoHI2jY6hatMgS6VZflOegEKECsy392zIDFdbicmh4XHLyMxLSbW66ghYQb/Nusb1ITqXFaHU8g2U/PdwKu42GyZLmw5Yf0N+XTArwQerU9RdJ7zGUzwlyMwMW7skJp+W9CPrjsojP9abTVkjNoimVL0zeYKVK4CMGpIi36XtbDzaLdHtKzRlYhFwe/MRmCcP7i+4+YMvF
 7z0dSYkY
 33HGFD1Wy6i5HfspLOcgfIJBH/IhaxQEgDtFR8OaxJ1QSCww8wPJh5RbiudfUBs2HfIM1Nva6oNq/v8FFmbgaqG1YzlTGp1wMejvuoad0PA6wLC9tmHQ8EFhdcGJrf1eBBqLO7UYA5zVOkV9Rh3uy0rK0NeH7iaIPfWjM3VgLtCPvAH7iDJb18QWPvM6hWYeYsPMY/11B4ZdUEgKhFuJrliiZUJP3e0Ute+6cdzCwFzgZm5S1ZiF5VAPpg4bzAEhDP+eT0juG3qS6uoKjenxrHVPMfUyfRe6RrWIx/X2zAlS3L7QnwUc8Ldrl6HIaFOB/tHgkJYaH03+qUjrdGGvB9fpMlsmEjkz2QoytzbPZcDFXPpeQOzNKLEQtQlACGU7AM2L9Hj/oTUJz4KxnJK0urd+YayGZNeI5XGXBuskWbQRCc7drLX4Dfqfhwt6QiIg3HJThmWtYq8wFUzrbTUKAILRmO4mhiRhAYCHxARwMXOa9AgsbvDqLOnImFeYoJh1CiM362ayy+l3TMQ1ntKQBkouULzmjME0FVEDufgM1fHN6I2ikgqKqUrQbtHUFQEyNeDfQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 15:44, David Hildenbrand (Arm) wrote:
> On 11/26/26 15:18, Paolo Abeni wrote:
>> which is arguably ugly but IMHO no more than the tristate
>> return value in the current version.
> 
> That doesn't work. "len" you write in the function is not tlen ...

Sorry, I rushed it too much.

> __splice_segment() passes &flen.
> 
> Further all these lengths are unsigned int, not signed :/
> 
> Also, I think we have to respect spd.nr_pages.
> 
> If we want it minimal, a separate error pointer might be the easiest way to fix it. Still
> ugly, but I tried to get it clean above and there is no way around some churn I'm afraid.

I actually prefer what you suggest here more than the current patch.
I suspect Willem may have some other option avail, but he will
not back for a few days.

/P


