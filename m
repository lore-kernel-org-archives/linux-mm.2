Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E8A9606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=IQvQ+jx5
Received: by kanga.kvack.org (Postfix)
	id 751B46B05B2; Thu, 26 Nov 2026 09:18:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 702446B05B6; Thu, 26 Nov 2026 09:18:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F03D6B05B7; Thu, 26 Nov 2026 09:18:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EB956B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:18:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D2CB540463
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:18:55 +0000 (UTC)
X-FDA: 85477476630.19.3CB3CE7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id ECA7AC0012
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:18:37 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795702718;
	b=yrZyrUkmkve/NdXIlxI4JPleNr9l2JlAgzsAZJaxpsqfveIBou7VMCn9qDOUhnIkfAaUjb
	gKvkyfgyCKk/ptKt5QFRzjFcPsl9aBsXgIELLAbjeZwt5zKtoVDtUpp8g2kO1hvuAtY3NP
	3N3uLuoK4IOpconL+7XPZBX20Bdb80U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795702718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oc0e78R7GnTku6S9kDpVJbJPkJaWrIi7MbRLcQ86nNY=;
	b=KpVPeVTklbSZW4UpM17Vl/avOwJ+WUlptyI0bexXURQnBy+zrN+Q3SLwC7HKuGoBslZwNK
	NxS9YFgN2qjKaN261nSl+8jvS0ZHlvtCr3UflMtXayGqoVYjvSAshLwkE5ggqtGVi2scMq
	x4jcHA2RAfa4AcHfDc0Sd4+K1GXBm98=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IQvQ+jx5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of pabeni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pabeni@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795702717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oc0e78R7GnTku6S9kDpVJbJPkJaWrIi7MbRLcQ86nNY=;
	b=IQvQ+jx506yOy/x4yvg8d6uOB9A6r/WEYX4lq96Ol2I6Rv/SlmUr6Y6RxajOMnSma/aAfd
	A9bsKYZHhHPRKwe1XRTSGD6XOfgn6zcqFI8wEOdhbakXxWiWRVjfreWXDApHhL6SGSdQP/
	xPyk3/mNX1NLhwjyKf3BrOTNQvAYLPU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-ZnUBqhuINXGM8oDEppiZNQ-1; Thu, 26 Nov 2026 14:18:35 +0000
X-MC-Unique: ZnUBqhuINXGM8oDEppiZNQ-1
X-Mimecast-MFC-AGG-ID: ZnUBqhuINXGM8oDEppiZNQ_1795702714
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4b9fde3044dso50603855e9.0
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:18:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795702714; x=1796307514;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Oc0e78R7GnTku6S9kDpVJbJPkJaWrIi7MbRLcQ86nNY=;
        b=qKt+70K0zxxaGmiUo8xi3dCi37qCKzHHt+dHZnDJap/c29QZKhnVAJofZDYfxLzv2l
         UT8sj5FE/8o3HTflE1jLYGfEhyyOa0lhVOov1yySvP4sGd3FH/4ttlZcGoXiUQHdvgKD
         ikE02P14N9pGONLxtAOA5K/MEjFEPbhz9xc1RE9QnUG9Qp5nJ/eMqgRNpFm5NojkbHUg
         ZLx+mL0AT7dN18PongG5RKli9p9J9Q4fUvJ92c/Uptc7oMUMo5bSb5PWsCQ6ta+K9ZZo
         O9gg8Xe1UqvTldVAo4ggU6t107pdy+5rwvGkMd6VN3zRqfI21AgmG8YanDfgRU4zW1fR
         QrFQ==
X-Forwarded-Encrypted: i=1; AL+hErGDe/HWO3sfUM78gwK/BRtOsx/MgN5wxZE9KKGw9epD3YYjwWkEHwvDZPtHr0hYqbOuQWNaX9a8EQ==@kvack.org
X-Gm-Message-State: APuU4Z/TnEC1mW39lTSSyQyZuZy5G6egHCVYFAea+A3iLTqhERIEkvIo
	TxEi7tiLrUDbVgcqElY9YLize0SXvaYvLtKxx+cUGH5TVDlyUvGL1/EoGuEToikj5vax7AIGhBP
	tWKUzI11qmeaiovFAHYQlPevdbs7LVXvxUJCQdB3YlTi9f6ilhqv6
X-Gm-Gg: AZFdTZc9deBn6GjUzYI+NfEuTnWn6lDwkz8DNFd3b5q8kehMEf3JKy+UrbiuTb9DN0o
	+q/el/HIcG8H1kBHObfWN52EipKGoEatrBLcnvh2Q8KPbeVveIq0UvwjphQGtmRKrt/PvIJnTsu
	G+5qqSC1xrg0MwwKF4U/yCeskEAXsL8IzNhrXz4IECeG2O54jwUU0+qxj8P+efDLt9ym8rP+hvl
	ct5CL1OdySAdO/yBzK5V0HyNMxZb3cAji814G3jhD6eB6Escl3lJGbtlGOK5hfrCgCmTjUevqL9
	dVpHjqiOYwGHiVh7XWaResvDWXvZw5WE5bnOXTWJ8nkk9595OM5UJ1NTo7q6wCfoJmx7M1djZfj
	Jy67ayHKDdT/uU4pYACtbEg7cK3fPShwQsAeX4lLKwXTOm+ROGW9mZxjOh3p2aYzDRxNcO+ftPN
	QBX17zmkZWAGoVXDx6vWs0I5LOOOigbGT+h6sEdkUoEAhD
X-Received: by 2002:a05:600c:190d:b0:4ba:2bfc:c8b5 with SMTP id 5b1f17b1804b1-4bb888267aemr430554115e9.10.1795702714052;
        Thu, 26 Nov 2026 06:18:34 -0800 (PST)
X-Received: by 2002:a05:600c:190d:b0:4ba:2bfc:c8b5 with SMTP id 5b1f17b1804b1-4bb888267aemr430553595e9.10.1795702713623;
        Thu, 26 Nov 2026 06:18:33 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b09bsm1120826425e9.4.2026.11.26.06.18.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 06:18:33 -0800 (PST)
Message-ID: <14059088-7992-4d89-ac6c-1e6d1f61b3c8@redhat.com>
Date: Thu, 26 Nov 2026 15:18:31 +0100
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
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261118-skb_refcount_overflow-v1-4-5551b4954c3f@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IeHOgYvu6nrjvxMe340zwWZvsmMRhwcF-m8nBo3FeB8_1795702714
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HE-Tag: 1795702717-371241
X-HE-Meta: U2FsdGVkX19lLDowi85VmK5J1C86VhdKAI3vh8NP3jMbiYA+/lo84OoBjDaHRCjjnIcc/IgxE+VG7vsczwtFIZTq6HWAbnzebxmRpQ6N28P0CFrxQvSECLJeDH0y8w4Se4/GcDPDy86SwXAhGc3jXFixv6+N9Rr945YXk3giZiKw359ahaIFlGrOQbXmBpLjD8G1V8aq7gsvbmV7L+gUgcuAKiH+GHnC4pfLPRc1GQeLezyID4u5TLA9sTLt+NfuINb4kswS1zwds+o2HWNNoF+shApGl4C9moaeWFujTtXukhiKL72qYeICNRoRYNRCqYQWOSOJ71R18e4Le9SUjHeX9tEts52j0Mq/OTB7WY6u84XXL4IJ1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 09:32, David Hildenbrand (Arm) wrote:
> @@ -3299,14 +3311,14 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
>   		.ops = &default_pipe_buf_ops,
>   		.spd_release = sock_spd_release,
>   	};
> -	int ret = 0;
> +	int ret;
>   
> -	__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
> +	ret = __skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
>   
>   	if (spd.nr_pages)
> -		ret = splice_to_pipe(pipe, &spd);
> -
> -	return ret;
> +		return splice_to_pipe(pipe, &spd);
> +	/* Returning 0 would make callers report EOF. */
> +	return ret < 0 ? ret : 0;

AFAICS the above introduces a change of behavior:
caller with tlen==0 get 1 as return value, while they
used to get EOF. I think the return code from
`__skb_splice_bits` should be ignored, when not negative.

I think the churn here could be reduced re-using the `len`
ptr argument to store the error code; something alike the
(completely untested) following:

---
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 85d5caa08887..9fd5116f33f3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3177,6 +3177,10 @@ static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
                 spd->partial[spd->nr_pages - 1].len += *len;
                 return false;
         }
+       if (!try_get_page(page)) {
+               *len = -EFAULT;
+               return true;
+       }
         get_page(page);
         spd->pages[spd->nr_pages] = page;
         spd->partial[spd->nr_pages].len = *len;
@@ -3299,6 +3303,8 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
         int ret = 0;

         __skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
+       if (tlen < 0)
+               return tlen;

         if (spd.nr_pages)
                 ret = splice_to_pipe(pipe, &spd);
---

which is arguably ugly but IMHO no more than the tristate
return value in the current version.

Possibly some comment around __skb_splice_bits and/or
spd_fill_page() would make this option more palatable.

/P


