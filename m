Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7972606A698
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 21:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GOgX0mLj
Received: by kanga.kvack.org (Postfix)
	id 9418F6B00EF; Fri, 20 Nov 2026 16:01:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F24D6B05B0; Fri, 20 Nov 2026 16:01:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B99B6B05B1; Fri, 20 Nov 2026 16:01:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5000E6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:01:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3DED2A61F3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:01:27 +0000 (UTC)
X-FDA: 85456718214.06.60BE73B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 673A91C0011
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:01:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GOgX0mLj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795208485;
	b=h3mZmWXc/GQyb7P8JXhAcHgq+YoJ15/j3kLGFnQdReXz1prBA+BzV6HPUi9OJBabgEnDhE
	LMMC6nlVKI6SXFcE7T1SH4dx+hVeo/4rsRt5u6kAqZC2XbuJV0iWBNDxldGfy2S7W4Ti6U
	HsiQcZBo2h6/v1iQIp0WPXtVxeTV5/0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795208485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5goPGg+WDIckAjo0y+m2U6zzWKb+HVqL7jjH8fkywk=;
	b=hG07qePkaZpvzfJzskS+F9dGLDc+uZtIZ/tBm3bFSEayK6G5iDzbX3vJmqp8UG0hNqLjG5
	1sOqsCjDEdcBmwlxv54Lh8roWmyPzf5xDkn1GFCrP3FCPgPfe09XHGNv3D5G6QM3y7GZ4D
	MATSgmgI3zOqYRum0JmSyztFx+mHurI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GOgX0mLj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E47C1608FA;
	Fri, 20 Nov 2026 21:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42101F000C4;
	Fri, 20 Nov 2026 21:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795208484;
	bh=W5goPGg+WDIckAjo0y+m2U6zzWKb+HVqL7jjH8fkywk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GOgX0mLj54E9H90rvK6W0y+jRPmLdcrlX+0ZhEVqNgkd0nRgvqmtDHCmboKD9fpFK
	 s/iscvIH6Y58jhFrxmY/jxNyrvzylLSOCb8YrN2E/IsOq5SkSZ2WWaUgIY0FQ1O4RB
	 ls9tXQFhzJs1R1eZNmyqBPw3M34GcVN4XX/rZxy6vvMnCsuvrj8o7/4fyDV5iINLQi
	 iwQ4yjGIVGez1zjcalCy1kFe2KbPnmLfg+4Um8V6CB60etK5YIobQFugfSxU8P3nui
	 /q2Cxa/FzkK2EvXwkwjlSfQiME1H6qFbv4rEHsuQ7u36qeMwrU1xdfvhJ0owXLMSGq
	 RfDPieHKs6zxw==
Message-ID: <cd61f39f-db93-4f37-9836-7a81f7a82f9c@kernel.org>
Date: Fri, 20 Nov 2026 22:01:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/4] net: skbuff: limit folio refcount when copying
 skb frag references
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kiryl Shutsemau <kas@kernel.org>,
 Song Liu <songliubraving@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Rik van Riel <riel@surriel.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Pedro Falcato <pfalcato@suse.de>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
References: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
 <20261118-skb_refcount_overflow-v1-1-5551b4954c3f@kernel.org>
 <awBy7PoxdEMEGWyW@devvm16445.scu0.facebook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <awBy7PoxdEMEGWyW@devvm16445.scu0.facebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 83bkne5b3g6k5y4t58ohqmuxyipzf984
X-Rspamd-Queue-Id: 673A91C0011
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795208485-137041
X-HE-Meta: U2FsdGVkX1+xzHgbvk7xJ2AKVHeeEFsH4yrQtxdyaQ9VuSgOdPQc9iNxPEasEWkYHmbVwes9rO3khCHkDHXurICLg+0ng/qEPD39D1hsih3lkUtnzxCFRNs4Z1LiaTpcs+RqNVWdsL0pbeKOvhQTDhdS3Py3TDGhQ3eLWz27nwJ5RPw5UW9MGFqVNC+C54xHTkseo7ng8ru36Bn2wyH0BlxO2ULvzM+UEhEz/VZhSEvlezsO6efhwRGM0PlQPpboCyihGDDTp8lmhuPupuK7KotYMIaJIGFBWJVwUYehtnvq57ZkHZ6fptK8ONNsMsSYX+7kk13jlD/nfuD4U/mFtbjeJxsDLC1m0/9dB7GMMissXIWW96Cq5vv5fCf4jZsHguJUb2DMwv27Vw0fv/awMKxs+FPzmSzD950UMOUQycYc7lO2ECEyk8SAdtnN7hPUBSJewHpjanSR4FboT9BKi8is3EadFSleB7glLQ/JiMiPjIsBJpuL+n9/q6ypchdz8qzkDUFkAsc9J6SbSntH4f7dQX/2OE+z59TKNdsvGQ8rK91IaFrA9A41AeWLpCxj5U8R0hBDz7V0HBdcH4kY+aHkoxzWo82pQpwdMWc7Lr+SzPavT8YqAzUX/VzSV1r438Bs9b3j66wMjhhHfb0AA3KDR1lPNqat4h7P3wGqUALgqQ7ldcui4OxwyI85wNRGW22kNA6gZhEto9VYCkySlAJGSile00iC3QCFa6oiZSC4cnraX2UcqoC2Ah2tHPRWYzbSCpJu7/HUfDxGz3Mu3WdKDCskOJ6GAghgjkl8ouCN+XBtnNLfNrU5pAWq70+GdmTPiNILbspHTeKyKuEnbYfp18VPUEjqD6+0i1G8dZmt/QWQAOp4nq6CyDzVb8Pp89Ie62cWyCXKk7jP1WUpZzybpLLT0LGPjsZ7PrwMZQ0oQj9Y/zrO0i6ZArzJQrb4yjFH2jOJzlWgbD+LppJ
 lN5ae4I5
 pRjXj39O1l/JUyoDzFJUkpancoKZ7gINWzxGVp+NObmnHtHSMzICGrkX4H/dZggay+tMvuOQ8LEISL/ky4xPTtVbSOV0fahssGZ6g3dTxfwwJ/lgQLWFuIoX4PFGjJrOzDPTUKDwlfJnRs1Hm67ntm6QDOHF/lncOvWP08np8wSAlCBhLSufMzLAB0dbpgBxS52TT3zy+AAoGs0ohQ5HqygOOi9RsEgMT8RAgUKfVqa3B8PiNOSBWTwOb/JGtfUJDH57aZVFChl41QqBe4mGZ2uRW6llHl0pOWNnVXQ3IjaFxa3gwI6VTTT+NMbRK7mjxZO1+67OsAhG8tuVyUNwPU2U1ATuKd8+f1+zV3UeEh+jQVMtvdC8Wy9dB91LoSGfWyxts4wVMiq+LcM5QN91FJQiv1+2Nz7IciqCp8BxD2pza+Q8cK5eHpcj10f2jQ6HWKpj8sEuA7ztC84LawQBCkyCHfIxHhy/DCMTcAsvVLLJloXL1L5BrmU9GtjHcOuK5BpdXUUfOmrKCo8lJm/XHZPMR5LCdycZLuac/g68qqZOhc8r3l3eEholAP1rrwN/5xWwbdSG5AZW9nKDn/lFWmdMS8EQZwrsZ7tBnepBh5xEXEVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 17:21, Stanislav Fomichev wrote:
> On 11/18, David Hildenbrand (Arm) wrote:
>> Various networking features copy frag references of an skb, for example
>> when unsharing a cloned skb (AF_PACKET trimming a clone), when copying an
>> skb (nft dup) or when building NFQUEUE messages. This is an effective
>> way for multiplying folio references held by an skb, allowing for
>> exceeding folio refcount limits.
>>
>> This is not specific to large pagecache folios, but with them it is a
>> lot easier to reach the refcount limit, as page table mappings can cheaply
>> create many references.
>>
>> Let's introduce skb_frag_try_ref() and skb_frags_try_ref(), which use
>> try_get_page(), and use them in pskb_expand_head(), __pskb_copy_fclone(),
>> skb_zerocopy() and pskb_carve_inside_*(). All of these can already fail,
>> and their callers handle that.
>>
>> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
>> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
>> Cc: stable@vger.kernel.org
>> Acked-by: Pedro Falcato <pfalcato@suse.de>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>>  include/linux/skbuff_ref.h | 53 ++++++++++++++++++++++++++++++++++++++++++++++
>>  net/core/skbuff.c          | 35 +++++++++++++++++++-----------
>>  2 files changed, 76 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
>> index b6f6da556ee90..560ddc863bbec 100644
>> --- a/include/linux/skbuff_ref.h
>> +++ b/include/linux/skbuff_ref.h
>> @@ -44,6 +44,33 @@ static __always_inline void skb_frag_ref(struct sk_buff *skb, int f)
>>  		       skb->pp_recycle);
>>  }
>>  
>> +/**
>> + * skb_frag_try_ref - try to acquire a reference on a paged fragment of an skb
>> + * @skb: the buffer
>> + * @f: the fragment offset
>> + *
>> + * Like skb_frag_ref(), but acquires non-page_pool page references using
>> + * try_get_page(), refusing additional references to a page whose refcount is
>> + * at its limit.
>> + *
>> + * Return: True if a reference was acquired, otherwise false.
>> + */
>> +static __always_inline __must_check bool skb_frag_try_ref(struct sk_buff *skb,
>> +							  int f)
>> +{
>> +	netmem_ref netmem = skb_frag_netmem(&skb_shinfo(skb)->frags[f]);
>> +
>> +#ifdef CONFIG_PAGE_POOL
>> +	if (skb->pp_recycle && napi_pp_get_page(netmem))
>> +		return true;
>> +#endif
>> +	if (netmem_is_net_iov(netmem)) {
>> +		net_iov_inc_ref(netmem_to_net_iov(netmem));
>> +		return true;
>> +	}
>> +	return try_get_page(netmem_to_page(netmem));
>> +}
> 

Hi,

thanks for taking a look!

> I don't see you removing original skb_frag_ref implementations after
> the conversion, any specific reason? 

As explained in the cover letter, I want to get these fixes here upstream asap,
to backport them alongside the core fixes that already landed.

The focus is on the skb users that allow for multiplying folio references easily.

> Do we still have any skb_frag_ref
> callers left? 

Yes, after this series there are still some left. Primarily ones that are not
considered harmful for overflowing the refcount. And some of these require a bit
more work to convert, like skb_split().

> Maybe at least you can make skb_frag_ref do 'return
> (void)skb_frag_try_ref' to avoid duplicate code?

That would be bad: calling code would assume that it obtained a reference but it
actually didn't.

There is some headroom above the folio refcount limit to allow for such harmless
users that are not converted yet. The immediate problems are the users that
allow for unbounded folio references.

> 
> (optional) Also, an easier way to migrate might be to make the existing
> skb_frag_ref return bool, convert everything, and then add __must_check.

That would require teaching all callers about handling errors in one go, because
callers would otherwise silently ignore failures. That's nothing we can
backport, really.

I agree that as a follow-up, all code should be converted to use a single
function that can fail.

But that's nothing for this series that focuses on fixing folio refcounts in a
way that can be backported.

Thanks!

-- 
Cheers,

David

