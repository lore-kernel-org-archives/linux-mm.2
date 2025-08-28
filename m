Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27739C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9BB6B0026; Thu, 28 Aug 2025 05:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A18F6B0092; Thu, 28 Aug 2025 05:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE358E0001; Thu, 28 Aug 2025 05:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2999A6B0026
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:49:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D92FD1DEE0E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:49:02 +0000 (UTC)
X-FDA: 83825692524.07.1B09E0D
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9091D140002
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:49:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OtirnCyn;
	spf=pass (imf23.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756374541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9FIo0yR7pw/C8uHryFZDSCVYk7EfCY6IS4689G0Qg4=;
	b=3rEcxMdgIcTfNgOiP9qNnUW8AqM5v08gjGumtoGeEPp3aCEoqnc4k4o+eM5c5r7ciTFbKw
	n5F/16PqVqPHeJQkw9xGG4UR/H8Ov1mI4lP0XghJf/mbjqiLl7RhaLVeplAlhx2sHScvDQ
	9LkK6xeaGuo0ZIjvyFqFQL15iTI4NV0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OtirnCyn;
	spf=pass (imf23.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756374541; a=rsa-sha256;
	cv=none;
	b=YRT1xTII9UXFPIrtUOflWFo7NcJ73WH1U/rJUHMCpGGgaxvKwvswYMf7kJQoteZDPW/3Qz
	uE5m9ADu4n1qynaQJFQ2Gb5mASsOhsHLelbJVz4Y+3q40WQDY9Bcbb99oSHuuYMQQfkMf4
	1lCsRHInYpQPhmB9QPWZhbK4RV9xHPo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756374537; h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:From;
	bh=K9FIo0yR7pw/C8uHryFZDSCVYk7EfCY6IS4689G0Qg4=;
	b=OtirnCynO32hLoqCYm6xp1ZtKiPIbIrxIOuqBttcstyAD9TWr4CNzdaRVWl7qEcJSIrebXj3W+Zhx2b7pTQ6rOFJ2jKDhQQZVoHOmTEczu9yzYs7wB5sUnawrEjNQjwtxbT+HjALOmkpRske6X4ONVyeOmPfZ7gObYH2JdcPZOc=
Received: from 30.74.128.191(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0WmmqVlQ_1756374534 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 Aug 2025 17:48:55 +0800
Content-Type: multipart/alternative;
 boundary="------------roG0Ka1AQlHScCBKwXxEcPJD"
Message-ID: <9639adfe-13ba-4c27-8ba6-8bf3e2190450@linux.alibaba.com>
Date: Thu, 28 Aug 2025 17:48:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm: Use pr_warn_once() for min_free_kbytes warning
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@suse.cz,
 surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-kernel@vger.kernel.org, baolin.wang@linux.alibaba.com
References: <20250828030602.204332-1-tongweilin@linux.alibaba.com>
 <aK_7GKJ4BWjye4tZ@tiehlicka>
 <35e0a580-ae78-4485-b285-7f71f91e046d@linux.alibaba.com>
 <aLAj-itGT9DD3SU3@tiehlicka>
Content-Language: en-US
From: Weilin Tong <tongweilin@linux.alibaba.com>
In-Reply-To: <aLAj-itGT9DD3SU3@tiehlicka>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9091D140002
X-Stat-Signature: xqadm9hc6csf9btyhurw85u713zuq6bi
X-Rspam-User: 
X-HE-Tag: 1756374540-248581
X-HE-Meta: U2FsdGVkX1/d3Ja6roBAT45sIxYPzs7VUnKPRx7NTYJi9MHNgI53E0NSwP/iSbsidugS3VWV7YugEZb1h/wRqw+rGZSSOqPgOCsZSyRLeF9uAAyhsMAR6bWC5eHpt4MZxZqsobysVQapvT7mhyD3u2cJ5msMpaFv/vw4zOPnhnRCnFzril4CMw+ss+iHaLrvrrWdPixOh4smxTc6GTsqeZuGseRlXYqyjOqLYeGaolRu2kOitedwKUrmKv24AZbQ4rbCMHxPDxmjh9XFBDSRdAbwpVVq8+rgYHlHk20HSoAz+zhjlEYuqOyHLLGlwlAsoi0LBlqLni9y8j/xN4uYy6spxQ3AUHZaH/Ua+N8wzXCCyO+hZwappctH+EcbwQsSgw+2J+ePEozsbNUtVLW4C4/JxFXw8dzfzOgfAyEUZOC2g1nEAnmZo+HO+nA3OAsFBY6ywUNvCy+dP/fToKPt/nRTP6ampEksfD3og4JJG+Iqo6CL1+35xu2RdVqwQjpFn6VZitY3WXjLN2Q9VPNeSRy7TBHcV/DsVDCEM6K41/YCebFkTGgy4AEhd7JBfA5Q5e9SPLqLlgLxMwIV9Nzc2+uSwwhkS2zUaRFkmWR34jVEo0i8j1P360WQAe7/3c0n351tiyzEwYJl6Guep2bOw3NZCKId5P6iETX9XZp1/wEvpAvlynE7URLfYiSJ6AR/QctxUCWgSoae7Ay8XLvUmzCtRy25+HRlqWD6LsoV8hQ4OqAaoQJ8ZhZQIchitIl0sm21pY6+ro9/k7h04gf8d8rVwurDmNUV/XTjducPSaeE/XuB5N/oTnFg+kmXHY1alNFk4iivLT4cCy0P/Cdt1T1mNF1NKr4diQNECkP98f6pvXHmc7Pyt3nsvGpzpeltC1cfb3yNLFQFkouPnSCYfXpY6gIcGPqZd80XlbF/6LbWXKG4BaZcpiSws2tJ3O9uAPEYg7zMhcEPB7kFlTJ
 WZbkm+kg
 vc9AEN7XNHKWqfW/Nr90h5zLH1be5S7Z9Zr0EluP70D84ZV5PCc4yrdd8xCrNulLl9HbhAn5cXLATnjDOHdC2qtPmvZrfCnWXGJcVAaFlkjSOlb8LSHDrUrwxDS641n47N/yOPfHBsOlC5xsdzm8CrZ3WgpmWCuySXGjH49s7KJw+LsbqncE+Ji/aBO7YdPbik5yyGip4ERJAQkfnjNtHEAQTYA8/vkI4vsJqzsqDWh1invcSP/KtSSgWwfp3xeAk+WIXe1Ok2MABx7fIAiqSOqKosHk1nAuNAVonFCXOu1/2ttcDqcd1cJ6zpf6UwaFSjVQZurJ9MHqiwHi9DDBpOoXKvg5Vi01nbrPLNGpoFLCCeRtIll9Z2tlF3BxilvOldR2BBvBZpWpJyV6T/JndEFyzUyZ8JESL6pB5hKStpjjMhWiPk0WXK/vvWTQrG9mfhBYX5k8P1+U13vlSQvF9FUjBNJbDgCj87BOnRvxA6MfCXEy5mZgPr9Oz2/pBQXjmwcnzDdHz30tQF0Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------roG0Ka1AQlHScCBKwXxEcPJD
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/8/28 17:40, Michal Hocko 写道:
> On Thu 28-08-25 17:23:40, Weilin Tong wrote:
>> 在 2025/8/28 14:45, Michal Hocko 写道:
>>
>>> On Thu 28-08-25 11:06:02, Weilin Tong wrote:
>>>> When min_free_kbytes is user-configured, increasing system memory via memory
>>>> hotplug may trigger multiple recalculations of min_free_kbytes. This results
>>>> in excessive warning messages flooding the kernel log if several memory blocks
>>>> are added in a short period.
>>>>
>>>> Sample dmesg output before optimization:
>>>> ...
>>>> [ 1303.897214] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>> [ 1303.960498] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>> [ 1303.970116] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>> [ 1303.979709] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>> [ 1303.989254] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>> [ 1303.999122] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>> [ 1304.008644] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>> [ 1304.018537] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>> [ 1304.028054] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>> [ 1304.037615] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
>>>> ...
>>>>
>>>> Replace pr_warn() with pr_warn_once() to ensure only one warning is printed,
>>>> preventing large volumes of repeated log entries and improving log readability.
>>> pr_warn_once seems too aggressive as we could miss useful events. On the
>>> other hand I agree that repeating the same message for each memory block
>>> onlining is not really helpful. Would it make sense to only pr_warn when
>>> new_min_free_kbytes differs from the previous one we have warned for?
>> Thanks for your feedback!
>>
>> The dmesg output above comes from hotplugging a large amount of memory into
>> ZONE_MOVABLE, where new_min_free_kbytes does not actually change, resulting
>> in repeated warnings with identical messages.
> Yes, this is clear from the changelog
>
>> However, if memory is hotplugged into ZONE_NORMAL (such as pmem-type
>> memory), new_min_free_kbytes changes on each operation, so we still get a
>> large number of warnings—even though the value is different each time.
> We can check whether the value has changed considerably.
>
>> If the concern is missing useful warnings, pr_warn_ratelimited() would be an
>> acceptable alternative, as it can reduce log spam without completely
>> suppressing potentially important messages. However I still think that
>> printing the warning once is sufficient to alert the user about the
>> overridden configuration, especially since this is not a particularly
>> critical warning.
> The thing is that kernel log buffer can easily overflow and you can lose
> those messages over time, especially for system with a large uptime -
> which is far from uncommon.
>
> I am not entirely enthusiastic about rate limiting because that is time
> rather than even driven. Anyway, if you can make ratelimiting work for
> your usecase, then no objection from me but I would rather make the
> reporting more useful than hack around it.

I agree with your suggestion.

With respect to your suggestion that “we can check whether the value has 
changed considerably” I would like to seek your advice on how to define 
what constitutes a significant change in this context. Do you have any 
recommended criteria or thresholds for determining when a difference in 
min_free_kbytes should trigger a warning?

--------------roG0Ka1AQlHScCBKwXxEcPJD
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
    <div class="moz-cite-prefix">在 2025/8/28 17:40, Michal Hocko 写道:<br>
    </div>
    <blockquote type="cite" cite="mid:aLAj-itGT9DD3SU3@tiehlicka">
      <pre wrap="" class="moz-quote-pre">On Thu 28-08-25 17:23:40, Weilin Tong wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">在 2025/8/28 14:45, Michal Hocko 写道:

</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">On Thu 28-08-25 11:06:02, Weilin Tong wrote:
</pre>
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">When min_free_kbytes is user-configured, increasing system memory via memory
hotplug may trigger multiple recalculations of min_free_kbytes. This results
in excessive warning messages flooding the kernel log if several memory blocks
are added in a short period.

Sample dmesg output before optimization:
...
[ 1303.897214] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1303.960498] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1303.970116] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1303.979709] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1303.989254] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1303.999122] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1304.008644] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1304.018537] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1304.028054] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1304.037615] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
...

Replace pr_warn() with pr_warn_once() to ensure only one warning is printed,
preventing large volumes of repeated log entries and improving log readability.
</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">pr_warn_once seems too aggressive as we could miss useful events. On the
other hand I agree that repeating the same message for each memory block
onlining is not really helpful. Would it make sense to only pr_warn when
new_min_free_kbytes differs from the previous one we have warned for?
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">Thanks for your feedback!

The dmesg output above comes from hotplugging a large amount of memory into
ZONE_MOVABLE, where new_min_free_kbytes does not actually change, resulting
in repeated warnings with identical messages.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Yes, this is clear from the changelog

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">However, if memory is hotplugged into ZONE_NORMAL (such as pmem-type
memory), new_min_free_kbytes changes on each operation, so we still get a
large number of warnings—even though the value is different each time.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
We can check whether the value has changed considerably.

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">If the concern is missing useful warnings, pr_warn_ratelimited() would be an
acceptable alternative, as it can reduce log spam without completely
suppressing potentially important messages. However I still think that
printing the warning once is sufficient to alert the user about the
overridden configuration, especially since this is not a particularly
critical warning.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
The thing is that kernel log buffer can easily overflow and you can lose
those messages over time, especially for system with a large uptime -
which is far from uncommon.

I am not entirely enthusiastic about rate limiting because that is time
rather than even driven. Anyway, if you can make ratelimiting work for
your usecase, then no objection from me but I would rather make the
reporting more useful than hack around it.
</pre>
    </blockquote>
    <p><span
style="color: rgba(0, 0, 0, 0.88); font-family: Inter, -apple-system, &quot;system-ui&quot;, &quot;Segoe UI&quot;, &quot;PingFang SC&quot;, &quot;Hiragino Sans GB&quot;, &quot;Microsoft YaHei&quot;, &quot;Helvetica Neue&quot;, Helvetica, Arial, sans-serif; font-size: 16px; font-style: normal; font-variant-ligatures: normal; font-variant-caps: normal; font-weight: 400; letter-spacing: normal; orphans: 2; text-align: start; text-indent: 0px; text-transform: none; widows: 2; word-spacing: 0px; -webkit-text-stroke-width: 0px; white-space: pre-wrap; background-color: rgb(255, 255, 255); text-decoration-thickness: initial; text-decoration-style: initial; text-decoration-color: initial; display: inline !important; float: none;">I agree with your suggestion. </span></p>
    <p>With respect to your suggestion that “we can check whether the
      value has changed considerably” I would like to seek your advice
      on how to define what constitutes a significant change in this
      context. Do you have any recommended criteria or thresholds for
      determining when a difference in min_free_kbytes should trigger a
      warning?</p>
  </body>
</html>

--------------roG0Ka1AQlHScCBKwXxEcPJD--

