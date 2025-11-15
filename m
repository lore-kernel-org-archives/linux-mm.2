Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD66FCEACEF
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 02:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 477058E0034; Fri, 14 Nov 2025 21:42:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427AD8E0005; Fri, 14 Nov 2025 21:42:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 317108E0034; Fri, 14 Nov 2025 21:42:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A6228E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:42:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A72A312DE05
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:42:06 +0000 (UTC)
X-FDA: 84111291852.27.ED0AAD7
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7CA8C140004
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:42:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mf6wR6ZO;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763174524;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPMKhOUZaVUnn2C31CanvV6ROA+8+FTIUKMzyBfKTUQ=;
	b=ESRe1wJhNvYYiZXAPZA6TR1Oopnl6FY4T2knuSwRS4V1s2BhTGvegun7N4ppeWjo14EVUj
	/QkqXhPmHPBDYJVyO6ksANkntNVfLfXsBqh9IUGM683uTAhNab1VuDkreaH8jT9d3f10Wm
	WSkmzVSHtaNPHL+tryfEbf7mePKKOwU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mf6wR6ZO;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763174524; a=rsa-sha256;
	cv=none;
	b=3u+tjJIIwm0bVg/4uHH+naRJHOd6LKGQ3l45P51GgVJpwrUJe7OhQnamY/fmBu1uTHy7j4
	heEsGYOh1v6I2YpEjXjI203ruEfg7xdIHXsJZjp92v0ixNUSdi2N7EnGuQJ5EfHXrgRBFe
	mXEqXlAWRm968wWDuDV8jU4WBU7Gua8=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b736ffc531fso186402466b.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:42:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763174523; x=1763779323; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qPMKhOUZaVUnn2C31CanvV6ROA+8+FTIUKMzyBfKTUQ=;
        b=mf6wR6ZOSAJWw0LurA3akkLU5aDVmuPMQCjumnEzCKSqcg/aRrv3H5fgLh9xD43vCe
         Ptn4XRBp+2lNWDv98oBAsE53zQCtS4lPYMfBhMNu73vMl5jmshY1EUgKv4tw8mAe10kH
         nqhKlHqW0fUkOZBwmrD51JPCqs8YpKhVdgW6aKlNKhTxcYKxZPCjTPloyE8J1r3gV5fh
         54a0z9ZWu8ezi9aV879PxTvsP4CTJFjQiyDmGrx2m9ruq++aVSIe3Cv3nwwozU/fHxyw
         uDpoN+KQDxnQpjYoMtbsYjxr3uENR7DHaO6zo9Nwj7k8dHFBNCmt24jh+8Vo7ViDCgPi
         G4GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763174523; x=1763779323;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qPMKhOUZaVUnn2C31CanvV6ROA+8+FTIUKMzyBfKTUQ=;
        b=D6T76zsmnCW6W/7YgGwJspgjk83P6J/f/zqknrKbSLiRDlVIh09ieNN8ZlIaK9LmMx
         FrnOE6VMc2nR1vPBzJ4CbvIPAgTjrsM4i+mdajkeS8BDQxvkijJMek1OBemD8KouL2o9
         afs5JJayMSr3XQq7QkSY2LTxAxTYqBS8MAjlc3Nf+s1Rhx9/xS+1+MUm3O3IA1gwR42T
         dRtCU3uYHRbsahgKDXUxPRVch7hlWNCYwHDrarpQZoVC9Z9mUOPWetoMuq4sbBs44vLp
         Og+nd4ex0PjCXTrkZ/Gkj0rLat2JXW77ke4p/bFO4QJ0AMKbTfLDZAiZLNBMf+LbPCAs
         xSLA==
X-Forwarded-Encrypted: i=1; AJvYcCXr5G/SvMauD1IeCJg62bWB8xsLIzTKVjgJUOjz53VSxNzrNoxWyTGtW49OOffDbgWj9TLpDKsBJg==@kvack.org
X-Gm-Message-State: AOJu0YyE4/+CIjrgLHiE19PJMPDZ73U3BWQZ/v5BixzYK85NwLHhfkPM
	ImVlbMOKYRwlFCB5oAQiqI0bZ0ghhQaLnZIwqMNNoWhSsViq3QW6Ugj6
X-Gm-Gg: ASbGncsssnJCSVXwqV70MbPBWxAnm/uwq0FqFR1vr12zQot6sX1WFGaFSzfnB3ceJyS
	GmyzuWYIF8lGW0oF5SsaJOTzXdxQvyXHYiTHstoXyvRV7EU2+MWFsxldTRTuOWrQKAsBmcpb56W
	wW3BOiVDSQihJVPvLqH3Yr1L4ZfE84QGN4DhwqYcjRngP4r6bLzVzXwX/G+NSRJZUkCnWszKL/1
	Pw/YHysAZv1W16VSMYwDA5fkjTUz43FdXIAYXUQyltL96IHsYhX7u6lbtCgvM49kfpXeclBwnr+
	DNvt1n8fX+f+6HsWCdXPSGu1+vvdl5ZAvd/jpGUU7ubNfijq9HUButcv3qWcaJzP2FMNmspJIie
	r/J7yy2UExGcsyw1fuGq3hGlRpP19xaSR8jSLlwYl2H+pEddI+OOpulA+D7acuFmQCU16kVdU6B
	RyVwK8y9LyR2mx/A==
X-Google-Smtp-Source: AGHT+IG0lwtyDR6cW/rRWitLb88FryxT0kFjAGRvlTdFqe0ZdPrZDl1uF/dPMJk2wneDffuOKwEbcA==
X-Received: by 2002:a17:907:d0d:b0:b73:43ee:a262 with SMTP id a640c23a62f3a-b736794c425mr586316766b.51.1763174522437;
        Fri, 14 Nov 2025 18:42:02 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fa811e2sm516858666b.5.2025.11.14.18.42.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Nov 2025 18:42:01 -0800 (PST)
Date: Sat, 15 Nov 2025 02:42:01 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	willy@infradead.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/huge_memory: consolidate order-related checks into
 folio_split_supported()
Message-ID: <20251115024201.jb5qaenbmlmdfx2y@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251114075703.10434-1-richard.weiyang@gmail.com>
 <827fd8d8-c327-4867-9693-ec06cded55a9@kernel.org>
 <01FABE3A-AD4E-4A09-B971-C89503A848DF@nvidia.com>
 <20251114143015.k46icn247a4azp7s@master>
 <AE04E232-34A2-47A2-B202-3F1E32AFAC0C@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AE04E232-34A2-47A2-B202-3F1E32AFAC0C@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7CA8C140004
X-Stat-Signature: dfkkhec8qtgny3yxz7enqkrnnnfo6y3h
X-Rspam-User: 
X-HE-Tag: 1763174524-458903
X-HE-Meta: U2FsdGVkX1/tUWdRurBrKs+jIoHV6OhW6xDBbMy6LyOFXRUg1HRsaDWaeMWyaXEx6gZU6pjq2Htg9lfujiRLcT6O4UwKCl85+oFxXjCV75ZzDaVPzv3lLOX/5uokjy+Ts8CfCjVrDo/fiODPMKsON8kl+eWUQyWfM02dpRnzJUhMOcRRwxJpfu9odU9tX1HtkweAP/DhY46vrgXFX2MZfdjAXJAJnrGIRmPJjWDy5yxMvBGY1zfgv2xXDzAnh2rabbyiIMfCGrrZY0bHZu70C6xvF+dd864ZqGWqeYpmqF868oVw0TSlHmKDSghwDO7NU0ZDO8cL5ah46DEzLSZrx+naMpfHbvlABHqkT3GFkBh9hfhQc/RdULJ4aMZo4rfSaxEkwmJTjJtjCONtbZbvm3EPXzg+4wFrdnT2Jf7xqtS+hhhrikpUx5HQMM024F1vo4AY/5Y7lrBfU+MvQte/+WF5gJgTA/qwF/9siQPJ3pUx7yZ/dHuWn11wB+G7MjUJS2AvrjWjqb2KddgHMcE7eXE1XxXM0lHihkk+9o4FCmMtzAb+CtvyJtZLUcc/SuqQxZ23fzYyvEiMW0EKp+fMX8g5veQYfKmLBxdPLcrkh080UL8jksMtes5FTGWI9FCwfCgbpXG2AF+u+EJQe4Mej5U5wAFIYFo52FhjmRoQDjE3lrtUyyJmTsIcX0F1tIwIU5ByeNoD+XbFVrAelTrjU64IwH8cXmm5pe1griesuyTBdQxw78nikuWMnSr/ZMiDZ3POnitc5jY77b98b9gfntKwB+Ni3N8A9T6iZy8A0g65q3cmqnO+lh/JNAH9ERjXZeLfIgQ51PG4zeBO5ZUvVjJykLL9i7CVNvBkNc9faa3vru+YhuIZgsWFckxoMFT5P0XQBDc/wgkGRI8yrYwLnguY8o7WxjkoSX7gH8haaE07HLodRjFhQvNmMwtnq15KUpMibjvL+sv0oM3raWL
 /1mgsHUG
 hMgVOngoOkj9va8QVLUcntnQ9G1nG3lGJqFhKi6ZGcFfNwchZS3XxvUJ6Ns5B5LGlpbBoBVhHO/uuQ+Dw7qU2Fd1dqZqTCWvOkaHa5upZO6iX19wbe9uIzw82gvEP/BAyofWiV9c4Duyvd17Lm7KswEauaGa+h2AU/Ejc0pdNsAgf5O+QSjyOD1dQhF2s6+8qrEtl5BlVNcrzm5QtMxFpd+jAsxsf/OIJ0JHxvX40COqindROvOaEsyW0/NVFLzagiCKVM9i4WegbxOwyTte+uyK6uAvJ/hx02rIQrHkyav07+6uStmRB6c3A0xxDKMvdWiLVsjl6hqrGOa6HvMv7BKNDT6fNwKi9xLV9x6h3PJzmwSwK9Y+6iSq0BDMmDRXtT+jQ9Vt7XWwJvIiE9pE9J0XlSyfrE7C4E0xssg3LpteBKa+9gqVifBKnRZC73F2TT/yPUHpnbQEnaEudCKnQFy7TuJZ3kWYRS//SpP8svaRVPqK6mdMR55ZQN0ykjhCpBMC4Uw8DQMrFpPty1Xe0o2bOE49olBpdvzgm9hv+U0YXHQ8ht9YRA1NIGQ513u+/s0kMMksR23Pph9GXrpANgFPuPvxjBVX08fR8B4AtEcs5GCxRKYsSiTtV10N8Ysh4H9csx8d5iexvvmjqvG+fGPdq8SzILjwqhrR0PHwNBBn0nc/v9DIzmvRENErghxZwpUwX7sbxni+ZcpOjpbxaIB2kStFyv0kDAOgF5KJSLrCL3b3ykKZLnQxIIjJZ4x9U+1RdLLG/xRfzYhNjCldTJOmT+UtP4/nAc7qS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 03:53:42PM -0500, Zi Yan wrote:
>On 14 Nov 2025, at 9:30, Wei Yang wrote:
>
>> On Fri, Nov 14, 2025 at 07:43:38AM -0500, Zi Yan wrote:
>>> On 14 Nov 2025, at 3:49, David Hildenbrand (Red Hat) wrote:
>>>
>> [...]
>>>>> +
>>>>> +	if (new_order >= old_order)
>>>>> +		return -EINVAL;
>>>>> +
>>>>>   	if (folio_test_anon(folio)) {
>>>>>   		/* order-1 is not supported for anonymous THP. */
>>>>>   		VM_WARN_ONCE(warns && new_order == 1,
>>>>>   				"Cannot split to order-1 folio");
>>>>>   		if (new_order == 1)
>>>>>   			return false;
>>>>> -	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
>>>>> -		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>>>> -		    !mapping_large_folio_support(folio->mapping)) {
>>>>> -			/*
>>>>> -			 * We can always split a folio down to a single page
>>>>> -			 * (new_order == 0) uniformly.
>>>>> -			 *
>>>>> -			 * For any other scenario
>>>>> -			 *   a) uniform split targeting a large folio
>>>>> -			 *      (new_order > 0)
>>>>> -			 *   b) any non-uniform split
>>>>> -			 * we must confirm that the file system supports large
>>>>> -			 * folios.
>>>>> -			 *
>>>>> -			 * Note that we might still have THPs in such
>>>>> -			 * mappings, which is created from khugepaged when
>>>>> -			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>>>>> -			 * case, the mapping does not actually support large
>>>>> -			 * folios properly.
>>>>> -			 */
>>>>> +	} else {
>>>>> +		const struct address_space *mapping = NULL;
>>>>> +
>>>>> +		mapping = folio->mapping;
>>>>
>>>> const struct address_space *mapping = folio->mapping;
>>>>
>>>>> +
>>>>> +		/* Truncated ? */
>>>>> +		/*
>>>>> +		 * TODO: add support for large shmem folio in swap cache.
>>>>> +		 * When shmem is in swap cache, mapping is NULL and
>>>>> +		 * folio_test_swapcache() is true.
>>>>> +		 */
>>>>> +		if (!mapping)
>>>>> +			return false;
>>>>> +
>>>>> +		/*
>>>>> +		 * We have two types of split:
>>>>> +		 *
>>>>> +		 *   a) uniform split: split folio directly to new_order.
>>>>> +		 *   b) non-uniform split: create after-split folios with
>>>>> +		 *      orders from (old_order - 1) to new_order.
>>>>> +		 *
>>>>> +		 * For file system, we encodes it supported folio order in
>>>>> +		 * mapping->flags, which could be checked by
>>>>> +		 * mapping_folio_order_supported().
>>>>> +		 *
>>>>> +		 * With these knowledge, we can know whether folio support
>>>>> +		 * split to new_order by:
>>>>> +		 *
>>>>> +		 *   1. check new_order is supported first
>>>>> +		 *   2. check (old_order - 1) is supported if
>>>>> +		 *      SPLIT_TYPE_NON_UNIFORM
>>>>> +		 */
>>>>> +		if (!mapping_folio_order_supported(mapping, new_order)) {
>>>>> +			VM_WARN_ONCE(warns,
>>>>> +				"Cannot split file folio to unsupported order: %d", new_order);
>>>>
>>>> Is that really worth a VM_WARN_ONCE? We didn't have that previously IIUC, we would only return
>>>> -EINVAL.
>>>
>>
>> Sorry for introducing this unpleasant affair.
>>
>> Hope I can explain what I have done.
>>
>>> No, and it causes undesired warning when LBS folio is enabled. I explicitly
>>> removed this warning one month ago in the LBS related patch[1].
>>>
>>
>> Yes, I see you removal of a warning in [1].
>>
>> While in the discussion in [2], you mentioned:
>>
>>   Then, you might want to add a helper function mapping_folio_order_supported()
>>   instead and change the warning message below to "Cannot split file folio to
>>   unsupported order [%d, %d]", min_order, max_order (showing min/max order
>>   is optional since it kinda defeat the purpose of having the helper function).
>>   Of course, the comment needs to be changed.
>>
>> I thought you agree to print a warning message here. So I am confused.
>
>This is exactly my point. You need to know what you are doing. You should not
>write a patch because of what I said. And my above comment is to
>CONFIG_READ_ONLY_THP_FOR_FS part of code. It has nothing
>to do with the check pulled into folio_split_supported().
>

Yes, I thought they serve the same purpose(checking supported folio order), so
print the warning both.

If should not, I will remove it.

>>
>>> It is so frustrating to see this part of patch. Wei has RB in the aforementioned
>>> patch and still add this warning blindly. I am not sure if Wei understands
>>> what he is doing, since he threw the idea to me and I told him to just
>>> move the code without changing the logic, but he insisted doing it in his
>>> own way and failed[2]. This retry is still wrong.
>>>
>>
>> I think we are still discussing the problem and a patch maybe more convenient
>> to proceed. I didn't insist anything and actually I am looking forward your
>> option and always respect your insight. Never thought to offend you.
>
>Not offended.
>>
>> In discussion [2], you pointed out two concerns:
>>
>>   1) new_order < min_order is meaning less if min_order is 0
>>   2) how to do the check if new_order is 0 for non-uniform split
>>
>> For 1), you suggested to add mapping_folio_order_supported().
>> For 2), I come up an idea to check (old_order - 1) <= max_order. Originally,
>> we just check !max_order. I think this could cover it.
>>
>> So I gather them together here to see whether it is suitable.
>>
>> If I missed some part, hope you could let me know.
>
>Based on the discussion in [2], your patch mixes the checks for FS does not
>support large folio and FS supporting large folio has min_order requirement
>and I told you that it does not work well and suggested you to just move
>“if (new_order < min_order) {“ part into folio_split_supported() as an
>easy approach. Why not do that?
>

I may not follow you. Let me try to clear my mind.

My first approach is :

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dee416b3f6ed..ef05f246df73 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3704,8 +3704,8 @@ bool folio_split_supported(struct folio *folio, unsigned int new_order,
 		if (new_order == 1)
 			return false;
 	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
+		unsigned int min_order = mapping_min_folio_order(folio->mapping);
+		if (new_order < min_order) {
 			/*
 			 * We can always split a folio down to a single page
 			 * (new_order == 0) uniformly.


Current patch does 3 major changes.

1)

Your comment to above change:

```
   This check is good for !CONFIG_READ_ONLY_THP_FOR_FS, but for
   CONFIG_READ_ONLY_THP_FOR_FS and !mapping_large_folio_support(), min_order is
   always 0.

   ...
   
   OK, basically the check should be:
   
     if (new_order < mapping_min_folio_order() || new_order > mapping_max_folio_order()).
   
   Then, you might want to add a helper function mapping_folio_order_supported().
```

So in this patch, I introduce mapping_folio_order_supported() and replace the
(new_order < min_order) check. Still use (new_order < min_order) looks not
correct. Or I misunderstand your suggestion?

2)

And then you mentioned this check is not enough:

```
    Hmm, but still how could the above check to trigger the warning when
    split_type == SPLIT_TYPE_NON_UNIFORM and new_order is 0? It will not
    trigger, since new_order (as 0) is supported by the mapping.
```

What come up my mind is to check with old_orer - 1 is also supported. So for
SPLIT_TYPE_NON_UNIFORM, the after-split folio range [min_order, old_order - 1]
are all checked.

3)

Also I remove the first "if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order)".

Because in original logic, when split_type == SPLIT_TYPE_UNIFORM && new_order
== 0, we should still check (new_order < min_order). If not we would miss
that.

But sounds I misunderstand you insight, I am sorry for that. If not too
bother, would you mind sharing it again?

>>
>>> Wei, please make sure you understand the code before sending any patch.
>>>
>>> [1] https://lore.kernel.org/linux-mm/20251017013630.139907-1-ziy@nvidia.com/
>>> [2] https://lore.kernel.org/linux-mm/20251114030301.hkestzrk534ik7q4@master/
>>>
>>> Best Regards,
>>> Yan, Zi
>>
>> -- 
>> Wei Yang
>> Help you, Help me
>
>
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

