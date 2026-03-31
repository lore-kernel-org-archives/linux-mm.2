Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F91B1061B28
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 02:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FDBC6B008C; Mon, 30 Mar 2026 22:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5646B0095; Mon, 30 Mar 2026 22:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB5E6B0096; Mon, 30 Mar 2026 22:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 793856B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 22:01:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE5058C9AD
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:01:24 +0000 (UTC)
X-FDA: 84604706088.12.832D417
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3EF6B1C0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 02:01:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BpffuDXi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ke.zhao.kernel@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=ke.zhao.kernel@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774922483; a=rsa-sha256;
	cv=none;
	b=n9PI5+dVh60Ix3X70uI6nly7XCNqebyfOa5OzsUqqgzSF8n0bTEVYVgJ3QAtr1GDC21ZYu
	CqNdwhQcHWaaNv3h2Sc/rTK9wJRokedUAAu9qDMcdUfJhnwnc4qCf/n04CgppX7O3RvTwt
	Hgy/HAJV/Jj0+M6/EsC75v+tYrRl4mg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BpffuDXi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ke.zhao.kernel@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=ke.zhao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774922483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qO6f7tVO2sQ2qt+WUP3bpo7jlPnELNHIScm521J1ZOU=;
	b=A6lgcR1fTCFA++6o4caAEgP6nJl3B8qE4M2TVzYVcAABYz7wICQ2m5ySRDlWLvJ1bTuFSs
	V7omLmFDFGjVMyO7Za6nLXvgYpQcp2Cw4L6IxL2jVI+JmPZILvEZqi7dOEgA+ukDdggdjO
	Dxv27EPy9CuI3aHhSHfjWAlI2/acZc4=
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2ab46931cf1so44637005ad.0
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774922482; x=1775527282; darn=kvack.org;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qO6f7tVO2sQ2qt+WUP3bpo7jlPnELNHIScm521J1ZOU=;
        b=BpffuDXiYcvTZ3uMivPFPeAu3CfqxNi+qcxflJ2iJLtuhjQMpUk325I4Zx+OzFyM3q
         wIyNtnPE1KsGIPIMAJnLzOBNkzOlEfgvEM4KauAKVLeqQwPvmRitHSUcioekOKfWlxzF
         5GKaVY480KzPnpxswiaFx756iweasbsWhuaTkMBG3eNKhTYk3PWumqHNFhJFGdd2P2Yp
         W22JTsSAv5uv3kWDHna1HkEWR9J9lUGuTvoeOAqjcjBTHajgDOLR4FNp8K7XFz7cqE1w
         FnUK1wYV6xhz2aioeX7S0LzP4sNyuSooQ0YueP0JpjTF+k+J5xvsKnYztWz0/A8Y60zs
         IKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774922482; x=1775527282;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qO6f7tVO2sQ2qt+WUP3bpo7jlPnELNHIScm521J1ZOU=;
        b=deeSNDi9km6VMx0xeyrDwxXwbhsCKAAP2v5TXgYrbgwy+l7hpFhmlxAGDtqA64RLrE
         5hQ7kAN6v+dlJ7djDgZDcW9ddn8JFUSfClzRDg3q2H8hhGSi/yf+D84TPBOgnG1F7a2q
         yyUFu8QK07ZUy2XrxAcDm2OC/TfpIFpR5P6xaKbLhbJdowc0ejBX5eylf+9+5N61lcwe
         txgbKAMc0V967mOXO0k4LowtZpVrg0mAouKOP4nqFoKQtVyi7NoqdF6jByHLFE1zopVf
         b+ljmJHv9vIKAMY7tSd2CvQCduVGOnFUGHvYFr65jQig7aazK+tScFRcPKSSX1+GK/Og
         Mysw==
X-Gm-Message-State: AOJu0YyzsQtEfaJEI2tneGz8VHruXa7OHMr20Ub9h4jjA70iQJen8BUt
	TYaHJvyu+aR7A/QwvX/MdW4cjVeMDafDF0IR1eFVpdo6TPzOkrEGM3Kk
X-Gm-Gg: ATEYQzxPxJJaf3t90CEE69Hy/X9RLqYvaank/HSN9Aakq+njw3SAAWI7dK7WVdyeYC+
	flvY1AIdBbEQ11ZK2hDhj32xBEhm9DQweE184024/pfviwCirK1TLJH/Lz2UEOoncw6uiiTdGHX
	XFHFm57w9l00bXBrl37QvgHocTriv9FSXYf2aYE8uAnTmPdYxbMyiblgSrmOVy05c9NQ9Y3XNL+
	XsonHu7uuw5fmV2j4O6Vg4+L4Xi4Jvo7Ikzs2PldNCtAKSvrpfx2alQxakWxn9+eQLH/uztkaHr
	4aiXqBSfDrAFiUuIqap5Hz2ES6a6Z11u6v6lFmVZsbOcK9Ag9UgFxBvCGO9JiOBhTqwl6OhztXp
	gTUxha9w9yjNM6q58YmGHyqIqAE/A83B2VNEvjaognOyaDvWVJG514B48ag1VPsN68Bix0bK5o8
	xVhb1gwO5/K4aC6tSyUuZ1tK2SQL2Y1R12EQ2LeuyAiZ97ZtAfLqXnmiucemM=
X-Received: by 2002:a17:902:ef10:b0:2b0:6068:4c5f with SMTP id d9443c01a7336-2b25ee9769emr16006265ad.8.1774922481815;
        Mon, 30 Mar 2026 19:01:21 -0700 (PDT)
Received: from [172.19.21.154] ([112.64.138.194])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427c4737sm108760525ad.80.2026.03.30.19.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2026 19:01:21 -0700 (PDT)
Content-Type: multipart/alternative;
 boundary="------------aFCDR0y0A0OcCVdMSha2tHo3"
Message-ID: <7c0e9735-51fa-49f4-9c39-c8c0f2db2f09@gmail.com>
Date: Tue, 31 Mar 2026 10:00:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm, KMSAN: Add missing shadow memory initialization in
 special allocation paths
To: Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
References: <20260330-fix-kmsan-v1-1-e9c672a4b9eb@gmail.com>
 <1dfbe39b-d052-4810-81d8-2ab74263bd7a@arm.com>
Content-Language: en-US
From: Ke Zhao <ke.zhao.kernel@gmail.com>
In-Reply-To: <1dfbe39b-d052-4810-81d8-2ab74263bd7a@arm.com>
X-Rspamd-Queue-Id: 3EF6B1C0005
X-Stat-Signature: inipa45er5acgcuabddb1j4ebxdaqb8z
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774922482-281837
X-HE-Meta: U2FsdGVkX19eVe5LCTMSv4wsf2vCQHSk3/D+RfqPEKMGSmvRwS1L4zE6dUDcVAxXQKlUg78VNdwcPooaOREkLW6S6ExpN4MfssABIF8a79QfiFwXYyoGxa2iTqxyHdRZOGvmJKfqdDW2KSTYjlA+yTkLGmuDaJ+3qEgB0oHD+/VyG0SmO8Txb1YqU1Eq4N0x/T5ZlS87GOm4bezBNh+7pflahEs4vvbmPPzvOL9/1LL6Q6+7+Rt9+VHamepAxompOw8F0ejriGD34mAkMRcP9fr75YzmCT3U31ygoq+lDgkXDze2gSvUvdikplhmH2OnoApsZevobqqSPFoIQd1AA7zOtvu+igNqW7by+UmtHymTITexNJ+qiyIXi6QvMqHRxRn3KdJilAaIY1aky87iry5aNKx9HX417cbeTs+nHk4ZCBx2njl/PAk06/8LQ7Kx3bJAoUn4FH55dz/pMFPfP2xxTYR9JGFcNYjGmAWERt1X4jqL7bpBHYRbgah6CGkrTKJLkJi0MFw9eBt4Z3UeHX89SvE/4yr/2mTmqf12yp/Pf9Zxr2tTl3yulv5TFY1xdKayvBvprU5OH26JAs6xR6yXIb4WY785+IU9H68BUhaeLyLTrUiLUo5lboyeJu3wYJstv80VmJtf2r+GsJQRXiQdIWT/2/FsDA2AmNrfNVjyywPwZmk8lNHaH9DEOGfJD241g3boqbewo/mTivwgAZ3ZMLYpOn3ci9eghGCViDfKVAv3wDA78Ni8psmV36c72YsBLfN+yg7FX+qLoGjVddo7mr0gNONlbgBq4hcX02T+Rw9AHWnCdrq1RUv9Yz/BDHw7s+Y+6bKn+ddP8isAmvvj6rWQoHgZiXGSOuHEDeDzhv9+FuWn9BN4ekaHta7kB3IE0Ag0vkZ7vfjZ7ds0oK1PHNOpiY6icdg/CQhBXXWsN1fsXyu21Iu8oHx72MNScnHFoPCsz8jOYuVF06W
 yPB1dKAE
 C2VVptlSFVf8XsMcp5pSUYm88nvK+1jtYf++BRbjwOokpkRnYuXQiCtI9mrvUBUCf3q/1B2/oxjtfa89dohlO689PT5/kFItaJmxXDh35tigG5gCKWogHPNtp2C9VMkfU5DZZqezuQJbSPW3+8OEqe2RCxKaNR/5yf0CfBboEz6IintD0OW+F+w62i8DcqtkSsnOAUL28fdHYu6I9oxiIyYLyTqMgPh2WISBUJ1+oNW6nXVJHrmfY8iBHDxWXCQ9GXQNWXuD/R2pKbkexV6o91uuyhf8P0YzGjqVs/x2hpI1QFiavPRX+4vPZAzUedY8n2/QG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------aFCDR0y0A0OcCVdMSha2tHo3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 3/31/2026 4:39 AM, Usama Anjum wrote:
> On 30/03/2026 9:36 am, Ke Zhao wrote:
>> Some page allocation paths that call post_alloc_hook() but skip
>> kmsan_alloc_page(), leaving stale KMSAN shadow on allocated pages.
>> Fix this by explicitly calling kmsan_alloc_page() after they
>> successfully get new pages.
>>
>> Reported-by:syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
>> Closes:https://syzkaller.appspot.com/bug?extid=2aee6839a252e612ce34
>>
>> Signed-off-by: Ke Zhao<ke.zhao.kernel@gmail.com>
>> ---
>>   mm/page_alloc.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 2d4b6f1a554e..6435e8708ef4 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5189,6 +5189,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>>   
>>   		prep_new_page(page, 0, gfp, 0);
>>   		set_page_refcounted(page);
>> +
>> +		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
>> +		kmsan_alloc_page(page, 0, gfp);
>> +
>>   		page_array[nr_populated++] = page;
>>   	}
>>   
>> @@ -6911,6 +6915,12 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
>>   			int i;
>>   
>>   			post_alloc_hook(page, order, gfp_mask);
>> +			/*
>> +			 * Initialize KMSAN state right after post_alloc_hook().
>> +			 * This prepares the pages for subsequent outer callers
>> +			 * that might free sub-pages after the split.
>> +			 */
>> +			kmsan_alloc_page(page, order, gfp_mask);
>>   			if (!order)
>>   				continue;
>>   
>> @@ -7117,6 +7127,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>>   
>>   		check_new_pages(head, order);
>>   		prep_new_page(head, order, gfp_mask, 0);
>> +
>> +		trace_mm_page_alloc(page, order, gfp_mask, get_pageblock_migratetype(page));
>> +		kmsan_alloc_page(page, order, gfp_mask);
> There is no page defined in this function. Most probably you wanted
> to use head in place of page here.
>
> How did you compiled and tested this change?
Sorry, I just simply compiled with the change but add wrong code into 
the commit. I can hardly make an environment that could trigger the same 
warning here. I'm not sure if I can trigger syzbot to test this.
>>   	} else {
>>   		ret = -EINVAL;
>>   		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
>>
>> ---
>> base-commit: bbeb83d3182abe0d245318e274e8531e5dd7a948
>> change-id: 20260325-fix-kmsan-e291f752a949
>>
>> Best regards,
> Thanks,
> Usama
--------------aFCDR0y0A0OcCVdMSha2tHo3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 3/31/2026 4:39 AM, Usama Anjum
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:1dfbe39b-d052-4810-81d8-2ab74263bd7a@arm.com">
      <pre wrap="" class="moz-quote-pre">On 30/03/2026 9:36 am, Ke Zhao wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Some page allocation paths that call post_alloc_hook() but skip
kmsan_alloc_page(), leaving stale KMSAN shadow on allocated pages.
Fix this by explicitly calling kmsan_alloc_page() after they
successfully get new pages.

Reported-by: <a class="moz-txt-link-abbreviated" href="mailto:syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com">syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com</a>
Closes: <a class="moz-txt-link-freetext" href="https://syzkaller.appspot.com/bug?extid=2aee6839a252e612ce34">https://syzkaller.appspot.com/bug?extid=2aee6839a252e612ce34</a>

Signed-off-by: Ke Zhao <a class="moz-txt-link-rfc2396E" href="mailto:ke.zhao.kernel@gmail.com">&lt;ke.zhao.kernel@gmail.com&gt;</a>
---
 mm/page_alloc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..6435e8708ef4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5189,6 +5189,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 		prep_new_page(page, 0, gfp, 0);
 		set_page_refcounted(page);
+
+		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
+		kmsan_alloc_page(page, 0, gfp);
+
 		page_array[nr_populated++] = page;
 	}
 
@@ -6911,6 +6915,12 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 			int i;
 
 			post_alloc_hook(page, order, gfp_mask);
+			/*
+			 * Initialize KMSAN state right after post_alloc_hook().
+			 * This prepares the pages for subsequent outer callers
+			 * that might free sub-pages after the split.
+			 */
+			kmsan_alloc_page(page, order, gfp_mask);
 			if (!order)
 				continue;
 
@@ -7117,6 +7127,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, 0);
+
+		trace_mm_page_alloc(page, order, gfp_mask, get_pageblock_migratetype(page));
+		kmsan_alloc_page(page, order, gfp_mask);
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">There is no page defined in this function. Most probably you wanted
to use head in place of page here.

How did you compiled and tested this change?
</pre>
    </blockquote>
    <span
style="color: rgb(34, 34, 34); font-family: Arial, Helvetica, sans-serif; font-size: small; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">Sorry,
      I just simply compiled with the change but add wrong code into the
      commit. I can hardly make an environment that could trigger the
      same warning here. I'm not sure if I can trigger syzbot to test
      this.</span>
    <blockquote type="cite"
      cite="mid:1dfbe39b-d052-4810-81d8-2ab74263bd7a@arm.com">
      <pre wrap="" class="moz-quote-pre">
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre"> 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",

---
base-commit: bbeb83d3182abe0d245318e274e8531e5dd7a948
change-id: 20260325-fix-kmsan-e291f752a949

Best regards,
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Thanks,
Usama
</pre>
    </blockquote>
  </body>
</html>

--------------aFCDR0y0A0OcCVdMSha2tHo3--

