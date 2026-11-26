Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35A2D606A327
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dds1NovW
Received: by kanga.kvack.org (Postfix)
	id 58EE26B05B9; Thu, 26 Nov 2026 09:44:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517C56B05BB; Thu, 26 Nov 2026 09:44:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0416B05BC; Thu, 26 Nov 2026 09:44:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0FF3C6B05B9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:44:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D392A8CCF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:44:30 +0000 (UTC)
X-FDA: 85477541100.08.283B7AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C9DB81C0006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:44:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dds1NovW;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795704268;
	b=SqsyX0/qV1Cza1wZWX61csrX4M5hr+1XaVXOAnAf1u56d7j2LYDuw/t3/lkmgqZ73ftrrv
	5d2t83QqjuGHRcrY4X3iYmaCz6P0Xn3VbJG4QFXQoN27ujnuVPI91yP8Sw6GQpAgq3j174
	1ZiE0vMgDvRaf6WSYLjnkWu/ilYiK6E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795704268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/F03eUzlSZS3lGGItRD6xh+3pnGh0qbk1j8Zd949jzY=;
	b=1lsbYG5gdAfR2b4AnTfEKWayAllQdOQYo+Xr0ENrPfJlkcptA0bkSQQPKRNZvctNrnavfK
	zT/QdDRI3gQLa4WcedJu+avTGqvfQKS76QuggFQGw6w4oFcBhD3G0RjD26W4h8y9WjHSWh
	sjyPfJkz6byvzRvYhZlksmfvqASPaQg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dds1NovW;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6231C60605;
	Thu, 26 Nov 2026 14:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B27C1F000D4;
	Thu, 26 Nov 2026 14:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795704268;
	bh=/F03eUzlSZS3lGGItRD6xh+3pnGh0qbk1j8Zd949jzY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Dds1NovWaL+F3h5ErqE94Q4IEGbX9rOZO2Dse6iWjZccsYtCTsI4yE4Xw4g3nxUSq
	 As3x6YWAY/RbkBTL+WsVUPWvYR/ouJEDFWTJY0YgLzrZ7cO3il05uDapQMWXzGHG3p
	 AyBb7DssURFJhCcjVBFcSNdrgZ7Yr05KivIpmHGt8FudqeKidwLcleuE4whJNf/4NE
	 kKChoEYtGotRVKk6bqldkEXMOBl/Ybk4BJQnQTZCfpaxvMxpCyTZDbi4HiNJTrNF2r
	 qMXsylCKUYo8YgWdGlRb9dFtmW6bIUpS/yupfJtaRoeBJI3BXVZ78NBp8A7bBkbchQ
	 90PcYt/tBPEPg==
Message-ID: <832f42a7-1d44-4138-a7f5-7cead4a28e57@kernel.org>
Date: Thu, 26 Nov 2026 15:44:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 4/4] net: skbuff: limit folio refcount when splicing
 from sockets
To: Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kiryl Shutsemau <kas@kernel.org>, Song Liu <songliubraving@fb.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
 <20261118-skb_refcount_overflow-v1-4-5551b4954c3f@kernel.org>
 <14059088-7992-4d89-ac6c-1e6d1f61b3c8@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <14059088-7992-4d89-ac6c-1e6d1f61b3c8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: C9DB81C0006
X-Stat-Signature: upp6tc35qrpyg7yfuhw6du95p7ogzywp
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795704268-862506
X-HE-Meta: U2FsdGVkX1+ZrN71xG/SrPSd8GbpbLHJGxgoMgMyhSepbM2wjSk9XZA0Rtjyo8t8M330Xq9FHI5AYhHpNkDsCLoBoS8HQN+lwlwJrKVCL6AEYxSyhkZkktrbrNorei809JTfFUkg2g4XVIY0bhC5ZIvXJZCBIjzPhrGHbO6lsQP4HikG4kUNipiLZruHNBvX8xGUFVZR4KOaemexIw6oxXlz6GniuE40MDsKs+XAa6BDMEHhqMhxFI/lWlwf5o9YOFTqM7HMrLVmD9EnfAEW7HsCIp3C59Vq2g8cupPwMUoi/6cdj9snCzHNU/XFjlRIjwBhFpdE9a70ZoM9Z2jClwO6l3/aeds9WMBqdxvszIZmUcGBp1OIgJtZkQzIx7Y8wI5qRbsgCKpsTmsKi3qTkhilM3feVMdsRAadUzmEVah7Kaa9tHz01NAbGiNW6OhOTeOtaC35L4f8u/Wdie3OzrXm8oKjSKIbo9T5lOfXd3uzGXArqexgisdgAXiiyymxgTQ6024kFsf/qKe+nI+ZRYOzEKcOCfEayYEcIBotflb88wZUd8I137FAKxBnqrmBQo1jw/2NKrchXJp1GN1Sguyb1ZO1gMkv2Xw+fQGEJyUFMkWMWxt1ekNw4u6c/7fqqG3apGUthNAtYo6y8/0iuUrF2e8KoiJV/jGNTPH54kOXerf5B2713YXs2qCb3TZA64d/+M8w7gZ+ozD3Ee87D7WtK8G94xasLnguBgqEFw+4/D1XtAq+N7g3CR087+dl9dlt3tGPHDS7ojbUxHEmWb1ga4ziaAZX0GckyXgZmqItei4UNZmKnP9JQCH2JzgrJk8jAVZMV00uvcNaPEHkBW7bVoZ4ju46seoCXXJp1mdwWEfm9SbQRlnR2NGJ15ezopD+XHh1AQD6wbXreegM7XkfBA78CIbk7xMAynUZ2I5Ajg5GqdTh5h+KeFiIAu3KjGQBv938nbmPNgwqRaP
 SBCmRHjw
 R9xNZ8+qzvTJsjQAeMKUgbcXvfu3sl4WlddnHJkqB6xT4/zQ8Mr6NTLcDJODpUlDTmwEHHM9LTBBknZuvn4nxIbL65CZwZenNT/Onfc0pdrWR+1rUR5tUDg0AkimvZSzq5jgRIjN4H30hDJViMpC/mbDmYnuvY/CCvvNuXNbLB+jtRxjtfUcdoLH3AckubaBPNAbuwj3Ye19tbsG/KoGz+FwiX43J6qe+pfmQe9YOP/Yg+jvaOoBIA+e8ycZvVxrxpcBrlAqCAc15W7Ak7UnnuUiO8EQ2DSpnyuAq/NV5QV4YGt6FtO3tYe98PvZ95EkbuKev6EErBABol/3dAhm66yUN1liXjwKcm504ym3F+A788xA+C/LLCy7uhNjAcHIAHWs5MhZ8CQjVHYGyii3TzJCaowpVeYO3C/MQUDoXH0v+grTvkQf3TOvzXjAg42FalorVqG8mGckH6L+f3ziYr5D2s4kR9uwit7h/rHAHhSoUvMw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 15:18, Paolo Abeni wrote:
> On 11/18/26 09:32, David Hildenbrand (Arm) wrote:
>> @@ -3299,14 +3311,14 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
>>   		.ops = &default_pipe_buf_ops,
>>   		.spd_release = sock_spd_release,
>>   	};
>> -	int ret = 0;
>> +	int ret;
>>   
>> -	__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
>> +	ret = __skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
>>   
>>   	if (spd.nr_pages)
>> -		ret = splice_to_pipe(pipe, &spd);
>> -
>> -	return ret;
>> +		return splice_to_pipe(pipe, &spd);
>> +	/* Returning 0 would make callers report EOF. */
>> +	return ret < 0 ? ret : 0;
> 

Thanks for having a look.

> AFAICS the above introduces a change of behavior:
> caller with tlen==0 get 1 as return value, while they
> used to get EOF. I think the return code from
> `__skb_splice_bits` should be ignored, when not negative.

I think you are right.

> 
> I think the churn here could be reduced re-using the `len`
> ptr argument to store the error code; something alike the
> (completely untested) following:
> 
> ---
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 85d5caa08887..9fd5116f33f3 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3177,6 +3177,10 @@ static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
>                  spd->partial[spd->nr_pages - 1].len += *len;
>                  return false;
>          }
> +       if (!try_get_page(page)) {
> +               *len = -EFAULT;
> +               return true;
> +       }
>          get_page(page);

Double get, easily fixed.

>          spd->pages[spd->nr_pages] = page;
>          spd->partial[spd->nr_pages].len = *len;
> @@ -3299,6 +3303,8 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
>          int ret = 0;
> 
>          __skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
> +       if (tlen < 0)
> +               return tlen;
> 
>          if (spd.nr_pages)
>                  ret = splice_to_pipe(pipe, &spd);
> ---
> 
> which is arguably ugly but IMHO no more than the tristate
> return value in the current version.

That doesn't work. "len" you write in the function is not tlen ...

__splice_segment() passes &flen.

Further all these lengths are unsigned int, not signed :/

Also, I think we have to respect spd.nr_pages.

If we want it minimal, a separate error pointer might be the easiest way to fix it. Still
ugly, but I tried to get it clean above and there is no way around some churn I'm afraid.


diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c937d74eed6ac..f471bea7fb26e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3166,7 +3166,7 @@ static bool spd_can_coalesce(const struct splice_pipe_desc *spd,
  */
 static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
 			  unsigned int *len, unsigned int offset, bool linear,
-			  struct sock *sk)
+			  struct sock *sk, int *err)
 {
 	if (unlikely(spd->nr_pages == MAX_SKB_FRAGS))
 		return true;
@@ -3180,7 +3180,10 @@ static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
 		spd->partial[spd->nr_pages - 1].len += *len;
 		return false;
 	}
-	get_page(page);
+	if (!try_get_page(page)) {
+		*err = -EFAULT;
+		return true;
+	}
 	spd->pages[spd->nr_pages] = page;
 	spd->partial[spd->nr_pages].len = *len;
 	spd->partial[spd->nr_pages].offset = offset;
@@ -3193,7 +3196,7 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 			     unsigned int plen, unsigned int *off,
 			     unsigned int *len,
 			     struct splice_pipe_desc *spd, bool linear,
-			     struct sock *sk)
+			     struct sock *sk, int *err)
 {
 	if (!*len)
 		return true;
@@ -3212,7 +3215,7 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 	do {
 		unsigned int flen = min(*len, plen);
 
-		if (spd_fill_page(spd, page, &flen, poff, linear, sk))
+		if (spd_fill_page(spd, page, &flen, poff, linear, sk, err))
 			return true;
 		poff += flen;
 		plen -= flen;
@@ -3230,7 +3233,8 @@ static bool __splice_segment(struct page *page, unsigned int poff,
  */
 static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 			      unsigned int *offset, unsigned int *len,
-			      struct splice_pipe_desc *spd, struct sock *sk)
+			      struct splice_pipe_desc *spd, struct sock *sk,
+			      int *err)
 {
 	struct sk_buff *iter;
 	int seg;
@@ -3245,7 +3249,7 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 			     skb_headlen(skb),
 			     offset, len, spd,
 			     skb_head_is_locked(skb),
-			     sk))
+			     sk, err))
 		return true;
 
 	/*
@@ -3262,7 +3266,7 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 
 		if (__splice_segment(skb_frag_page(f),
 				     skb_frag_off(f), skb_frag_size(f),
-				     offset, len, spd, false, sk))
+				     offset, len, spd, false, sk, err))
 			return true;
 	}
 
@@ -3272,10 +3276,10 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 			continue;
 		}
 		/* __skb_splice_bits() only fails if the output has no room
-		 * left, so no point in going over the frag_list for the error
-		 * case.
+		 * left or on error, so no point in going over the frag_list
+		 * for the error case.
 		 */
-		if (__skb_splice_bits(iter, pipe, offset, len, spd, sk))
+		if (__skb_splice_bits(iter, pipe, offset, len, spd, sk, err))
 			return true;
 	}
 
@@ -3299,9 +3303,11 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		.ops = &default_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
-	int ret = 0;
+	int ret = 0, err = 0;
 
-	__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
+	__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk, &err);
+	if (err && !spd.nr_pages)
+		return err;
 
 	if (spd.nr_pages)
 		ret = splice_to_pipe(pipe, &spd);
-- 
2.56.1

-- 
Cheers,

David

