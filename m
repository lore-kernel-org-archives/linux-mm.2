Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69AA4CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 949106B0088; Mon,  8 Jun 2026 04:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F98B6B008A; Mon,  8 Jun 2026 04:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810096B008C; Mon,  8 Jun 2026 04:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 704216B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:25:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BEBE1A09D0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:25:30 +0000 (UTC)
X-FDA: 84856061220.21.BA7C572
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5776A40009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:25:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xXdr2MqU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g/cl94r2sn+iv8ffB105PChTgE1EOVBWGfW9oWrFA4E=;
	b=e/qgNKfuCdFay+Tuz176mtEL12HNkHLsLUYERcZ2blbLMUD8XxMyDmEsYbldyESK4PluQO
	gqoKSEABEKGOmeuO2YrMnop5zk+SX9jHwmEBs22z8ahndVx+ZZgccw+U4nEKHmcoSxyoRC
	+zgndS7JyH3tRQZn+NNUwwWt2nBT410=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xXdr2MqU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907128;
	b=0A75SVsZIHQ7vILtYGI1BusZjrIQs9Yi2AZuAfy1BXpilvNOw2dl44mrecG249tROT0I6F
	DredeC8ItJKu5IxpqemIE7pUUbRQBG+MRfN0HwzINCpkQHfs9FDHn6ZDpwl1nC8SExwjYm
	QrL9dZbqfyQskiQu4SSmBTw9AIembjQ=
Message-ID: <a58e659e-5f54-4511-9a29-dc921002d102@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780907123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g/cl94r2sn+iv8ffB105PChTgE1EOVBWGfW9oWrFA4E=;
	b=xXdr2MqUm4ZO5i3k+RxHcUjI4HpIhji3s70NJnUCFzQ1RESXVF1DKKPCbLWyRtNO1MLOHL
	RuI/3Yb+fiy5ZTTGzVhl/1ILrYag9MVjYJDIRSMkikfpV8kef9FWbLzkDtlKcDq2neBBzU
	xB/FcZW1UKV4zGpe09dq4VzJX+EHLJA=
Date: Mon, 8 Jun 2026 16:24:50 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 4/6] alloc_tag: add accuracy based filtering to ioctl
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Sourav Panda <souravpanda@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
References: <cover.1780701922.git.abhishekbapat@google.com>
 <b608a6f7d71e3b728f766dbc6dfa1d1753ddcff5.1780701922.git.abhishekbapat@google.com>
 <1ec17313-cd2b-4389-a05d-998757af30b3@linux.dev>
Content-Language: en-US
In-Reply-To: <1ec17313-cd2b-4389-a05d-998757af30b3@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5776A40009
X-Stat-Signature: ms8sfb8d41w9ac3qt9b1qwnbkud831nx
X-Rspam-User: 
X-HE-Tag: 1780907125-33540
X-HE-Meta: U2FsdGVkX1/U41jMJP6KNoPEZb4PkLMlcMND37Lc1HdfQ4eKlRfZ1is4cUjNCFQOTaZWmh34f6ha4pPPk/lVEzHzK4bMgjhqeJlN89sBvx3eMMjJkfptyaPWihKESlC842eMMkVot7I+UCJWlBWlTCFNgYOfoUSJ9LpYepmOvFvhQKsr3XFDp3fH8fmI7vmQ190gjq9CoaKQEBjIL8UX/8lSJA6Q/Q2l9bQADuOWgK/ceUFLdyVf7GzPNomHICA2yke0H4kx6nBwb2Ekt7AV369mW9Gw0BffUBxb1YIaawqtslmzLWIZO97Qgkuq9zeQp1Re4T9dWoKdxDxxJNIJv3Q+zUK6FMfNdDqTBL59sa6z4bGMCMAhYvmTsjOIRy84IWOfLixcGEoukkw0C958BGrpUScjRppaDqkbaXsCIQ6aSsf46sIa8waQdui7nO/+GFlup7a5ly7/It71CbReNEuCbHl6VwJFc9ZRryu01aZssYld9cqGqUjHWFazArQ/LFYwcHbUTpf0o3UFuxLmkEh9uGxRn2rzFXPeLSHtpM+FL4uuGMBCCaArBYv4DsfCPGJXURveqfKA2ycWT/eAjcnHbDJ/PhP1JPv200Wi5EbZdLzpE9oSvNKQjxQJhk5WysSfk1bPze6cfsUE9Cxoq5B0fJJDRRgsMeR83GklJzr1qpQKXmspd6vFGng3Wl2cURkAewtuHyb6YhQY9PaNpQVYJZJJT2ll3n2fYWyQ3JExmYHg67XEIgp26pxGSnlBUrXSvRj/7t9DT/g4cIGSZb9Iwt3bsq6dEkPCGStD648xdzYsFN08Vf1rd60i/S0E7WTEvpE0svInj0JanteKLUoZsLrNnGed5gDfyY2FHnQFtmw6ZNC+MuBEK0mF0qabaxMwZXcmJ/LiMbrwBs0xp5xDiMwXzV/T3NPVzUOD6LiroHrmBtj3MbhsRWMhSyGbqA2GJEw9mBev8mVj9x4
 98TL13dL
 sZFf3yGAjCM+FWR2BL1V0ONQuX0VpOWJCPebnG64mOgR+PHU0IoEzPkSsiP64ceBEkXG2cJCnyRt8DiuUhDXKEItgj87z/VRBBtxLtHVLVaeSn4r722Xb2fWSMjNm44Ho5Vq9tg00QPEGngOOVHClvM4JoRbo2uZCBwUvigoC06uCKlMyh8keNt843mrurKYEmB9xOSNTXo/Xffsmt8iMhRSR4LpXmZ416U8vDPRhGyeHKN8ucEkZwkkuKp0qzwISpiwgIV/XnLyv7uvII5Rqkwj7PbtzuQtU9ZGmXZdIrYZE/qxBmq8q0oFe4O3HJic4z4hiKSLzuraK1QM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/6/8 14:22, Hao Ge wrote:
> Hi Abhishek
>
>
> On 2026/6/6 07:36, Abhishek Bapat wrote:
>> Extend the allocinfo filtering mechanism to allow users to filter tags
>> based on their accuracy.
>>
>> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
>> ---
>>   include/uapi/linux/alloc_tag.h | 3 +++
>>   lib/alloc_tag.c                | 8 ++++++++
>>   2 files changed, 11 insertions(+)
>>
>> diff --git a/include/uapi/linux/alloc_tag.h 
>> b/include/uapi/linux/alloc_tag.h
>> index 0e648192df4d..42445bdb11c5 100644
>> --- a/include/uapi/linux/alloc_tag.h
>> +++ b/include/uapi/linux/alloc_tag.h
>> @@ -20,6 +20,7 @@ struct allocinfo_tag {
>>       char function[ALLOCINFO_STR_SIZE];
>>       char filename[ALLOCINFO_STR_SIZE];
>>       __u64 lineno;
>> +    __u64 inaccurate;
>
>
> I was wondering if it would make sense to define inaccurate as a flags 
> field
>
> (e.g. __u64 flags with ALLOCINFO_TAG_F_INACCURATE (1 <<0)),
>
> so that only bit 0 is used today and the upper bits are reserved for 
> future use,
>
> aligning with current kernel codebase.
>
> This design also allows for better extensibility if we need to
>
> add new flags for any reason in the future.
>
> We also need to add flag validity checks if we go this route.
>
And I've reviewed the issue reported by Sashiko, and I think it's valid.

When we expand the allocinfo_tag_data structure

struct allocinfo_tag_data{

     char modname[64];

     char function[64];

     char filename[64];

     __u64 lineno;

     __u64 inaccurate;

     __u64 bytes;

     __u64 calls;

     __u8 accurate;
   /* padding */

}

I think user space may see two fields related to inaccuracy.

How do you like these modifications?


diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -20,7 +20,6 @@ struct allocinfo_tag {
      char function[ALLOCINFO_STR_SIZE];
      char filename[ALLOCINFO_STR_SIZE];
      __u64 lineno;
-    __u64 inaccurate;
  };

  /* The alignment ensures 32-bit compatible interfaces are not broken */
@@ -40,7 +39,7 @@ enum {
      ALLOCINFO_FILTER_FUNCTION,
      ALLOCINFO_FILTER_FILENAME,
      ALLOCINFO_FILTER_LINENO,
-    ALLOCINFO_FILTER_INACCURATE,
+    ALLOCINFO_FILTER_FLAGS,
      ALLOCINFO_FILTER_MIN_SIZE,
      ALLOCINFO_FILTER_MAX_SIZE,
      __ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
@@ -50,16 +49,20 @@ enum {
  #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 << 
ALLOCINFO_FILTER_FUNCTION)
  #define ALLOCINFO_FILTER_MASK_FILENAME        (1 << 
ALLOCINFO_FILTER_FILENAME)
  #define ALLOCINFO_FILTER_MASK_LINENO        (1 << ALLOCINFO_FILTER_LINENO)
-#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 << 
ALLOCINFO_FILTER_INACCURATE)
+#define ALLOCINFO_FILTER_MASK_FLAGS        (1 << ALLOCINFO_FILTER_FLAGS)
  #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 << 
ALLOCINFO_FILTER_MIN_SIZE)
  #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 << 
ALLOCINFO_FILTER_MAX_SIZE)

  #define ALLOCINFO_FILTER_MASKS \
      ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)

+#define ALLOCINFO_FILTER_F_INACCURATE    (1ULL << 0)
+#define ALLOCINFO_FILTER_FLAGS_ALL ALLOCINFO_FILTER_F_INACCURATE
+
  struct allocinfo_filter {
      __u64 mask; /* bitmask of the filter fields used */
      struct allocinfo_tag fields;
+    __u64 flags; /* bitmask of ALLOCINFO_FILTER_F_* */
      __u64 min_size;
      __u64 max_size;
  };
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -249,8 +249,6 @@ static bool matches_filter(struct codetag *ct, 
struct allocinfo_filter *filter,
                 struct alloc_tag_counters *counters,
                 bool *fetched_counters)
  {
-    bool inaccurate;
-
      if (!filter || !filter->mask)
          return true;

@@ -277,10 +275,11 @@ static bool matches_filter(struct codetag *ct, 
struct allocinfo_filter *filter,
          ct->lineno != filter->fields.lineno)
          return false;

-    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
-        inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
-        if (inaccurate != !!(filter->fields.inaccurate))
-            return false;
+    if (filter->mask & ALLOCINFO_FILTER_MASK_FLAGS) {
+        if (filter->flags & ALLOCINFO_FILTER_F_INACCURATE) {
+            if (!(ct->flags & CODETAG_FLAG_INACCURATE))
+                return false;
+        }
      }

      if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | 
ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
@@ -318,6 +317,10 @@ static int allocinfo_ioctl_get_at(struct seq_file 
*m, void __user *arg)
      if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
          return -EINVAL;

+    if ((params.filter.mask & ALLOCINFO_FILTER_MASK_FLAGS) &&
+        (params.filter.flags & ~ALLOCINFO_FILTER_FLAGS_ALL))
+        return -EINVAL;
+
      if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
          (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
          params.filter.min_size > params.filter.max_size)


Thanks

Best Regards

Hao


>
> Thanks
>
> Best Regards
>
> Hao
>
>
>>   };
>>     /* The alignment ensures 32-bit compatible interfaces are not 
>> broken */
>> @@ -39,6 +40,7 @@ enum {
>>       ALLOCINFO_FILTER_FUNCTION,
>>       ALLOCINFO_FILTER_FILENAME,
>>       ALLOCINFO_FILTER_LINENO,
>> +    ALLOCINFO_FILTER_INACCURATE,
>>       ALLOCINFO_FILTER_MIN_SIZE,
>>       ALLOCINFO_FILTER_MAX_SIZE,
>>       __ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
>> @@ -48,6 +50,7 @@ enum {
>>   #define ALLOCINFO_FILTER_MASK_FUNCTION        (1 << 
>> ALLOCINFO_FILTER_FUNCTION)
>>   #define ALLOCINFO_FILTER_MASK_FILENAME        (1 << 
>> ALLOCINFO_FILTER_FILENAME)
>>   #define ALLOCINFO_FILTER_MASK_LINENO        (1 << 
>> ALLOCINFO_FILTER_LINENO)
>> +#define ALLOCINFO_FILTER_MASK_INACCURATE    (1 << 
>> ALLOCINFO_FILTER_INACCURATE)
>>   #define ALLOCINFO_FILTER_MASK_MIN_SIZE        (1 << 
>> ALLOCINFO_FILTER_MIN_SIZE)
>>   #define ALLOCINFO_FILTER_MASK_MAX_SIZE        (1 << 
>> ALLOCINFO_FILTER_MAX_SIZE)
>>   diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
>> index ddc6946f56ab..cbcd12c4ef9c 100644
>> --- a/lib/alloc_tag.c
>> +++ b/lib/alloc_tag.c
>> @@ -249,6 +249,8 @@ static bool matches_filter(struct codetag *ct, 
>> struct allocinfo_filter *filter,
>>                  struct alloc_tag_counters *counters,
>>                  bool *fetched_counters)
>>   {
>> +    bool inaccurate;
>> +
>>       if (!filter || !filter->mask)
>>           return true;
>>   @@ -275,6 +277,12 @@ static bool matches_filter(struct codetag *ct, 
>> struct allocinfo_filter *filter,
>>           ct->lineno != filter->fields.lineno)
>>           return false;
>>   +    if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
>> +        inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
>> +        if (inaccurate != !!(filter->fields.inaccurate))
>> +            return false;
>> +    }
>> +
>>       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | 
>> ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
>>           if (!*fetched_counters) {
>>               *counters = allocinfo_prefetch_counters(ct);

