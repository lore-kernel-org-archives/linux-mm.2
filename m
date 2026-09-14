Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7773BC88E6E
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 16:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432DD6B0095; Mon, 14 Sep 2026 12:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E43F6B0096; Mon, 14 Sep 2026 12:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3446B0098; Mon, 14 Sep 2026 12:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F35E06B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:00:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E4581A01A0
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:00:48 +0000 (UTC)
X-FDA: 85212830976.05.E3192A3
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 42D8D180014
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 16:00:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SjNhM7qY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789401646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vnhKlSBSQOh8ZFl8Jf+/YlwJHlkv+MXRYwatR7ezOHY=;
	b=XPC3Srsdxb8/s1vL6N/lbwheEjSwVncPgjTBaKpIZ/kYB4wewXqGgs6fnn03GFuGQcz5hu
	iy+YBDXEOhrU63QqdySitam1GMcu5682GS0rxCGturRuz1R3VgjVIvBhTrOpeYy4tS7U64
	Gklfkd9nsotYFAaDN4CfB2JI1kI4zfo=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SjNhM7qY;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ackerleytng@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789401646;
	b=UiWf9zyCEIwtrHTBJy8nNQqg8XiBdf5UDzG006XyGQdN61pRenvihGtmshz5bqDaQ3f4sU
	jtbCasO0XyhAONohbKiYkpJfAQuEMaffKS8v+8fzNPchn3KU0cmOTfx1J4hC6OYEboKRxx
	1Lmb+u3CQ/Nk6Uj4AIF7/0nbVvvNBYY=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-857ff9fef54so26479637b3.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:00:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789401645; cv=none;
        d=google.com; s=arc-20260327;
        b=eZ0AnHKgfb9pq77MELtr6OJbRz2M8hw4AUHsGs6o7qNeHvaw8P8zfotSoBqu1NaVmb
         frYOo2wi+N3CvwyDErwQNT7h53AZ/szgLbXX/3d5AcRqRMfJVcz4TLomRnGeoxd1YCZ4
         f7Y/uwbdfhRawi+6PF1MlcMbrgN2BVuj6Da4/T6je6ZkLv7O6CJfmB1CaWhKLVMLpaEx
         uPSv1Nn9WR7TmFD26URQrcIF3bXbg36J/r9GewW6bVOLucbYYxJk4iQKZFarnT/LBxqF
         KwM3f/sWOw+2jZuk0p+4iFnpmjZGXM7Y/poeB0eromon6p8IrYhEIa3UiFQtLfVvYj+n
         jorg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=vnhKlSBSQOh8ZFl8Jf+/YlwJHlkv+MXRYwatR7ezOHY=;
        fh=2NlDOyiAJlo+SJhV078cpKCHf1bY0+W3DKzvh6FmpHI=;
        b=lREbXJzdNMhjphP00/XCwwCzMXwVSoah5SYVXPc0Djd2eesKg71i4v1oBn6BDLD/2/
         umUwfBVp+jo18AXGJmSp1o/1nZnBZytOZ/n3O+eORyGTbn0Y9Z9y3DJqSE0aqBUqGjtA
         MSMngfqqxYzClwGjvFou61gzQVtwlBt2MzGCr4qMSo5QMM26RVC+jRUeyS/JcJ12WjtA
         zBmdYvI4fLgl0fJdtb0jKVRqLncJCj4XK3Zq7Eq/NfUi/o9rnLRxQm2/yR7wTQOVaKyz
         Ac2EsoiscTjnzE/JoWb4TL/KhqPAkDE3hGwkRGFB0r2sLCUzrXkXH7HjEPmHHbxBVZu0
         gQlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789401645; x=1790006445; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vnhKlSBSQOh8ZFl8Jf+/YlwJHlkv+MXRYwatR7ezOHY=;
        b=SjNhM7qYbGFWt6kHoQ3+WlrvAhylCQDhGKlwoRiSuw83rTPyXHev76dNfzaOS3LTOT
         BMC0XtYwtnPLbepGFAgWp4e7L0xhjsQy5DcCjN88uHioQPAZRGqXhUrSpMqdcA8h6qD5
         T4K3Y+cmPIvx/3r/MXyCBqq4V4PfnkuUWd5Er1LM0geedE9OzgCV2UVxG3eNGfaux5Qo
         Igzaxic3G/N6FEa3wD9eyJm/HhTTRlf9zYDgnhRTTzYlk2tnsNt+2ub5rjJq/Y4KaYRh
         +wiRY4psCDu6ptj4LingNQfKvyxqQp5tzenKppeFHK77/iey8yn5e4TSf7RtDy3QICj4
         ww3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789401645; x=1790006445;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vnhKlSBSQOh8ZFl8Jf+/YlwJHlkv+MXRYwatR7ezOHY=;
        b=pINUe2yLnT3wNm07W3mZXgbvh9pJwAak668zNKJPkJ6H509/rvStYJlotZ12TkAruG
         GSp/5oxyOLgFxQwgAQO4spSYFnNR7NFhHmkQPfn9pQTslKkoVknSDaTGX5aTj1bjjw+O
         hRs4axlmcX3TBtXRq8IL/tQOIcZpdGWUpY74bqQbTqi88eUsF8zpljjzJbqBSj7MgIrL
         tjadxa/AM/XdcqCIc0KqQOFKKjEJMg4hZPrRIVjfZXgKoqxa2Btq9ltRZvONoflJE9MZ
         UWz67B2LSGWhBapMXnjDCLGXQOw7tF5Flv/LGv6tHOaCL7QchMjy1wmuqQ6W7rTeBwh6
         Omlg==
X-Forwarded-Encrypted: i=1; AKwUvBzpQ1kofZ78qx9Umg8SnFpaKwOSaJowDqK9DX3hKtZLHFYA4avJAmUQambZWlRTc8rCY7rDAJEw7w==@kvack.org
X-Gm-Message-State: AFuF++nUGbPYC/li4zFuEsD/axP0I8A/d4u0+FRO+y1D3bwbkIWk5kEj
	bHeCNRzwVBiC77mbB1s3T6KoCTPyw3Tv9JT03i5ykBR9bAvs3I5/xu0PSpE1uU2C702RMmxCHrp
	FgzPRPv2NPQNML1K4o3dCeYrkduJNjAuM5H+2Lolk
X-Gm-Gg: AYBFou3LuU2bDSk/fsdQvycTvJ5RNs7zXzGP+o6mtVsEGGJz0CrCbhkdprGih+MSWCD
	8xXGudJvtlpQYO8nLzburIA8lpp0qVyfAoGx0sDV8cUSWrBGfSEhP9iL6D24Gg71f+d9WxG98mI
	s2RvU16C2WVv+79TNBMqdexjDKkcZOFEBCtEd6/x8mpNGqQDsLyniLSAb9qkH4eYBw8hvKA2wPY
	SstUWiys240IN8/sN02xsZbqoPF7NWE4bo3Q2OitcEQTnNO1qadGJ9DZkaqXFbLv1d8HTeROJQK
	Gjr3LQXIF+HbIOawM6hwc9CprGI0M+AN9fe+R84+rRS06WzrJhqBQAbsISLg1LfGXYZgybWmHV/
	+C02awjqnvfWUn0rClScO
X-Received: by 2002:a05:690c:7483:b0:85b:946f:129e with SMTP id
 00721157ae682-88d21832f4cmr13001707b3.33.1789401644112; Mon, 14 Sep 2026
 09:00:44 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 09:00:43 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 14 Sep 2026 09:00:43 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260911143726.3689114-1-joshua.hahnjy@gmail.com>
References: <20260911143726.3689114-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Date: Mon, 14 Sep 2026 09:00:43 -0700
X-Gm-Features: AcwNN1VDnqeI0nANt9JGLFAAqZR4p_p34VigeOi4yaGir0FMb_J4_8lM3yPMIDM
Message-ID: <CAEvNRgHsJKS5gszvJRpoJ2YHn3A3n_V4F_zgpFQMPdVcRvKffQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] mm: hugetlb: Fix out_put_pages subpool reserve calculation
To: Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Dongliang Mu <dzm91@hust.edu.cn>, Hongxiang Lou <louhongxiang@huawei.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Michal Hocko <mhocko@kernel.org>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Wupeng Ma <mawupeng1@huawei.com>, 
	Yanteng Si <si.yanteng@linux.dev>, fvdl@google.com, jthoughton@google.com, 
	rientjes@google.com, vannapurve@google.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: fdscftbmipchxosksj8xekir4j647cxu
X-Rspamd-Queue-Id: 42D8D180014
X-Rspamd-Server: rspam07
X-HE-Tag: 1789401646-474966
X-HE-Meta: U2FsdGVkX19omh5yeSTi5mSgKhCkk3nnPn5fJN2QxZHIW4hukFzIp/fxGMQY4w6s613H8oVrbHdD7lwssp7gfDauxMpkJG2DwFMxrdOpSIdX8SviIrjL56/FY6QLN0JgNUrUn9ljwK8JAyZ94t9AtH6xB9yQZEraIvrDzEhMrUc5s1MEp6qXYDeXWXAvB36G5SJVn5qiSSKDa+xbF075oAD8zVNJpgSMo4tnCGm4WyXMmImyR+n2zb1fTt3fJHtJHxG5NTAWdJeWSvrcrFarIfrbsvWJ6o7OdFQxup0mgGS4gppR2dyDSarNlYQGrCRbPWkqE5ijkmJCKb/vyXlGzNXOWWw38ST0GgT2rOhbw8EniiO5D47GhGLkVc+ei3GvzJYLhPCVyzk97/yxxU4438GhppgjVPBxS8r3dXQzDu4suLdJ40dmc3Hn4cdPgLdJL8wI/jHMzUsy6OkddQ77TRD5ENUVvmDcMD6MFcWwMd3dLoxvdEDIYU296HB21DV+tRh4ms5JOVW7UEx85zGraQ+3aglXnsECYsJ0VoOHolcaN+yqQ+TSA9k0Eobr/ybCOGUWP1AEhs+Y1eXhD1iOyBBR4aUlZtUkF6ULYlctF3AX8RyLi30Yc8VItpkQWct6g4HHwCTKpO7hZsyH9qBjHYw9Qzdsv4cfAKP3fU5aNRLp14zPoC0dLmn84xqwnBM5vVA+VDBJReuH/mKf+p7AXRWfp+FLd0icfgeNkGe/8GFVHZStnjSl4c7/XcQHwSBofEwbMbugbDLFJP06FFr5UbxF/RGNtpAIbBs4mdm075F89Up/LUFsRc0uGPMVUisA7jUSBhSc5ROFj3crKEKrtGzPky174mio/QP/wFHpkkeqX+UqD27aYyqpp+tGc+sHfo8Fhe56DNfAO4zoNXpBWfiDY2OCjbMXiiDR9+ORhjlxYiwswYDV0vxIe0epu8F/hevSbfVoCjD+rvTjOll
 q0BXSmlf
 WsZWDv86V5lA2dHHL+w/5SnQMfb/yQS7c2LYK57PujY1jtSOJwCuCK2jHisS10htSvRsw2B7wA8zbaMkF4jly8dELawF0t6iSdfui39XliS1CJCld+/mE621jpheJIfkmFaxXimuaCya1AvBUINpreuMFaziozbNa7AjmNWLUILM79sicG67YL+8viSKEL9n9mzd0SRReAop/cGv98XsYn2c29OJV58YWni518WnigtS4ZZssxnYmxEbpS0Nhy9qYFO5vUlbj2OErYroDUa4BGuQVPZeT9kXcBAw9lS/HKwKaLkeFrhS1xWpoGuNJRFoLGLPAbgUtvWxjhccubQuvD+KKFeHqaty6OdKkpmHNotfqU0l5SP0qxGCxO9rYiFicYOU2vki2Muxmz2JVWJm05aNsTNInOQoyCUdEzfGqBtEp8GdW0tDUXf41Nes41917P32GTCTTTC8OaMjIR338l4UryuxddKUStdu2DhgjYWXFVkYvmXjDlUnuae3AeCTMfy2a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

>
> [...snip...]
>
>> @@ -6821,26 +6823,21 @@ long hugetlb_reserve_pages(struct inode *inode,
>>  	}
>>  	return chg;
>>
>> -out_put_pages:
>> -	spool_resv = chg - gbl_reserve;
>> -	if (spool_resv) {
>> -		/* put sub pool's reservation back, chg - gbl_reserve */
>> -		gbl_resv = hugepage_subpool_put_pages(spool, spool_resv);
>> -		/*
>> -		 * subpool's reserved pages can not be put back due to race,
>> -		 * return to hstate.
>> -		 */
>> -		hugetlb_acct_memory(h, -gbl_resv);
>> -	}
>> -	/* Restore used_hpages for pages that failed global reservation */
>> -	if (gbl_reserve && spool) {
>> -		unsigned long flags;
>> + out_put_pages:
>
> I'm not sure if this section warrants these two comment blocks anymore.
> The logic is quite straightforward now that we don't have to worry about
> managing the global / subpool reservations separately and rather just
> simply do the subtraction to account the memory.
>
>> +	/*
>> +	 * Return all that was requested from the subpool, let subpool
>> +	 * tell us the new number of reservations that need to be
>> +	 * returned to the global pool.
>> +	 */

I think this could be removed if you think it's obvious enough.

>> +	gbl_resv_put = hugepage_subpool_put_pages(spool, chg);
>> +	/*
>> +	 * There may be a difference between the number of
>> +	 * reservations to consume and the number to restore now if
>> +	 * there are multiple threads interacting with the subpool -
>> +	 * restore the difference.
>> +	 */

However, this other thing about threads racing needs to be emphasized
imo. Both subpool and hstate tracking are global. I believe pretty much
anything that updates global state based on local variables only in 1
thread is going to mess up the global state.

>> +	hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
>>
>> -		spin_lock_irqsave(&spool->lock, flags);
>> -		if (spool->max_hpages != -1)
>> -			spool->used_hpages -= gbl_reserve;
>> -		unlock_or_release_subpool(spool, flags);
>> -	}
>>  out_uncharge_cgroup:
>>  	hugetlb_cgroup_uncharge_cgroup_rsvd(hstate_index(h),
>>  					    chg * pages_per_huge_page(h), h_cg);
>>
>> --
>> 2.55.0.1007.g17ff1f9808-goog

