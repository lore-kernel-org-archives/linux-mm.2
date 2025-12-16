Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AEA0D5E133
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 12:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2EBF6B0005; Tue, 16 Dec 2025 07:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE67F6B0089; Tue, 16 Dec 2025 07:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F286B008A; Tue, 16 Dec 2025 07:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA2B6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:21:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 409EC1A0292
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:21:51 +0000 (UTC)
X-FDA: 84225245622.21.5A1F0C3
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf06.hostedemail.com (Postfix) with ESMTP id 502B0180018
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:21:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U69mnwiJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765887708; a=rsa-sha256;
	cv=none;
	b=2U8+fwGR2De2SdhKr+ORrHVx9voUtejIgZoAF0M+7PXhYAsMQ61zR55W+Bu/50vTpCmqfk
	iaL0OM+VkM6RAF2zq59EmSbPJIltkG5Fy6nIhdAKUJS0kGdeh58hnP9TZvMCy7kYWgkh2p
	aV0zQl9KPTHFT4h+vT2+bLzst65698c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U69mnwiJ;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765887708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbF0u0Cag/xUt4G/7VIbR2C8b73uQF4HyJnwoavvYk0=;
	b=i9aVJg5P6EZDrGdmI/hkYGeqrzLdq2zNTs652F4rmuFdadY+KA0IuGqvA09yN4hQJOy2b5
	QwgOsMoLVceXP6bDfX1g4ppfJCYK7iPbyXv+owP/9ArEK5ZV6awa2DhpGaGqy45yu1PMKK
	ypolr5a1IkRHrawSat0N79THCw7Nvjk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765887704; h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:From;
	bh=pbF0u0Cag/xUt4G/7VIbR2C8b73uQF4HyJnwoavvYk0=;
	b=U69mnwiJi4hK5Wk6vV0U6QmShqrIJq1WNzMYP4sshoV9Z4FKNM3mx8tDfYYTGNFe1/NvN2327F3eoMMugKApP/kAIZOPfbNwdpKySa3z932N5cO4Rl4mevmCThfPEhXK3x03NMpHaenAsyofyq/x4jconEoWZJ1BW4Va+jY2V5E=
Received: from 30.251.44.100(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0WuzbAXT_1765887702 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Dec 2025 20:21:43 +0800
Content-Type: multipart/alternative;
 boundary="------------lYJC5HRBWJqlBZ4uGxqIeQOs"
Message-ID: <cbab4998-25ee-40b8-b789-8ecd92471fdf@linux.alibaba.com>
Date: Tue, 16 Dec 2025 20:21:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: add mTHP swpout fallback statistics in
 shmem_writeout()
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
References: <20251215024632.250149-1-tongweilin@linux.alibaba.com>
 <3c86d612-aab7-4e80-bc6a-3ccf2bab9c34@arm.com>
Content-Language: en-US
From: Weilin Tong <tongweilin@linux.alibaba.com>
In-Reply-To: <3c86d612-aab7-4e80-bc6a-3ccf2bab9c34@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 502B0180018
X-Rspamd-Server: rspam10
X-Stat-Signature: pqeipcdjc476pdwbkapr1wn6a5iai764
X-HE-Tag: 1765887706-415640
X-HE-Meta: U2FsdGVkX19b82GACKHKsIFtpPHkuSk7qCdm1EEEKmZ0DiwaOd7hXUDmzxMdpGyxpb3dMiqG6IFU8kALND/+Mde27I+oxCDT6lSIfXVC+Ms4ZZ5CIu2Cx+rR9xrXWOViHdnSNVWCCVrTcf4YJnIifjywX71RYGygEu8ePmd0LS53X9hRj6R2hAgRlDY2mDFYl5I1pn8aokQm3fRUVrlOjFeVPXCBo0CH87QA47390xpZUuuzLM7jWqaNPOwfHozfKaJAvGbb0fWnfVB/Sxj0yOiny9L6EVNvnuni5GwmRo5wiH+mZCxynEw1W43VVwFQIpJQDmkqWGsmaoGwHNfP8mrSXkCk89WLdG6qTZQH16rmK4D02JllzNGLqTB+l9XHFK3TBcGbWFXIkQVItbO3a0SFFgFGDxq3RhkLf6p907Zq57yCoR5d9y8pyoxeWm9JQBELtSCmPB5lC8qdccCZCl4+zVcIzXdwwsv7NdKTtqsxiX7t9HaAPT2MxHymoSq+AGcCmJyNbi44KInB7P1ewZbxrOAOE0rpl7xdCun14581JQ7qO47ntxRqNa1gEgKB+jlIPD7FC+doD0UCSfXxES+RJKQTO3YarEd7E8Zk7CLBdzK9BXVgzZum3E7+v94dnHom7I3iWWN/W3YRcsRzhb9U+YCDZpdx17F1fVVz6pvUOTD+KtvsejnhcoRo3PHpgOSe43/3Kd6whe1mOEVZ1gibAYY9wamR822tX9R/6LZeu5w3r9dep3wZkyfb6ND4nN+7UIjn1Kx9jUnAh6+BA5GnxhHOFfL1GQz9cJUQyBc8c4FlyHxR41BLG7p1MKhbp3XQ87YsM4hVJTZQxVDaYqsaj7zNZ7jE7o3Mtt5VyB1wtnmEV4540XpdVjWD1P2aqbCV2zF7UUYxuLnfVdQlrhi4RXBlMcNGpCt1YKT0rpaHkND6z+quZpLE4gf6ANSibhzxSvcb2DtyHvJhuDe
 0FeMJGZI
 /JJtzaQN6pyM6wddfpG6JNgC5yLrJUPcNh9upH2yCz3a9YDPr0JuhjzG2sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------lYJC5HRBWJqlBZ4uGxqIeQOs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/12/16 14:34, Anshuman Khandual 写道:
>
> On 15/12/25 8:16 AM, Weilin Tong wrote:
>> Currently, when shmem mTHPs are split and swapped out via shmem_writeout(),
>> there are no unified statistics to trace these mTHP swpout fallback events.
>> This makes it difficult to analyze the prevalence of mTHP splitting and
>> fallback during swap operations, which is important for memory diagnostics.
>>
>> Here we add statistics counting for mTHP fallback to small pages
>> when splitting and swapping out in shmem_writeout().
>>
>> Signed-off-by: Weilin Tong<tongweilin@linux.alibaba.com>
>> Reviewed-by: Baolin Wang<baolin.wang@linux.alibaba.com>
>> ---
>>   mm/shmem.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 3f194c9842a8..aa624c447358 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1593,11 +1593,23 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>   	}
>>   
>>   	if (split) {
>> +		int order;
>> +
> Could this be moved up near the 'nr_pages' declaration instead ?

Thanks for your reviewing.

IIUC, this|order|variable is only used inside the|"if (split)"|code block, so it's best to define it here. This keeps its scope limited.

>>   try_split:
>> +		order = folio_order(folio);
>>   		/* Ensure the subpages are still dirty */
>>   		folio_test_set_dirty(folio);
>>   		if (split_folio_to_list(folio, folio_list))
>>   			goto redirty;
>> +
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +		if (order >= HPAGE_PMD_ORDER) {
>> +			count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
>> +			count_vm_event(THP_SWPOUT_FALLBACK);
>> +		}
>> +#endif
>> +		count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
>> +
>>   		folio_clear_dirty(folio);
>>   	}
>>   
> Otherwise LGTM.
--------------lYJC5HRBWJqlBZ4uGxqIeQOs
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/12/16 14:34, Anshuman Khandual
      写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:3c86d612-aab7-4e80-bc6a-3ccf2bab9c34@arm.com">
      <pre wrap="" class="moz-quote-pre">

On 15/12/25 8:16 AM, Weilin Tong wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Currently, when shmem mTHPs are split and swapped out via shmem_writeout(),
there are no unified statistics to trace these mTHP swpout fallback events.
This makes it difficult to analyze the prevalence of mTHP splitting and
fallback during swap operations, which is important for memory diagnostics.

Here we add statistics counting for mTHP fallback to small pages
when splitting and swapping out in shmem_writeout().

Signed-off-by: Weilin Tong <a class="moz-txt-link-rfc2396E" href="mailto:tongweilin@linux.alibaba.com">&lt;tongweilin@linux.alibaba.com&gt;</a>
Reviewed-by: Baolin Wang <a class="moz-txt-link-rfc2396E" href="mailto:baolin.wang@linux.alibaba.com">&lt;baolin.wang@linux.alibaba.com&gt;</a>
---
 mm/shmem.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3f194c9842a8..aa624c447358 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1593,11 +1593,23 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
 	}
 
 	if (split) {
+		int order;
+
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Could this be moved up near the 'nr_pages' declaration instead ?
</pre>
    </blockquote>
    <pre><span
style="font-family: &quot;PingFang SC&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, Tahoma, &quot;Microsoft YaHei&quot;; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">Thanks
        for your reviewing. </span></pre>
    <pre><span
style="font-family: &quot;PingFang SC&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, Tahoma, &quot;Microsoft YaHei&quot;; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">IIUC,
        this<span> </span></span><code class="blog-code"
style="box-sizing: border-box; font-family: monospace, monospace; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">order</code><span
style="font-family: &quot;PingFang SC&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, Tahoma, &quot;Microsoft YaHei&quot;; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"><span> </span>variable
        is only used inside the<span> </span></span><code
    class="blog-code"
style="box-sizing: border-box; font-family: monospace, monospace; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial;">"if
        (split)"</code><span
style="font-family: &quot;PingFang SC&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, Tahoma, &quot;Microsoft YaHei&quot;; font-size: 14px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: normal; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;"><span> </span>code
        block, so it's best to define it here. This keeps its scope
        limited.</span></pre>
    <blockquote type="cite"
      cite="mid:3c86d612-aab7-4e80-bc6a-3ccf2bab9c34@arm.com">
      <pre wrap="" class="moz-quote-pre">
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre"> try_split:
+		order = folio_order(folio);
 		/* Ensure the subpages are still dirty */
 		folio_test_set_dirty(folio);
 		if (split_folio_to_list(folio, folio_list))
 			goto redirty;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+		if (order &gt;= HPAGE_PMD_ORDER) {
+			count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
+			count_vm_event(THP_SWPOUT_FALLBACK);
+		}
+#endif
+		count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
+
 		folio_clear_dirty(folio);
 	}
 
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Otherwise LGTM.
</pre>
    </blockquote>
  </body>
</html>

--------------lYJC5HRBWJqlBZ4uGxqIeQOs--

