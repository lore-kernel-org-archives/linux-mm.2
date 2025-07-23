Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07904C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D568E0001; Wed, 23 Jul 2025 05:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5C86B0098; Wed, 23 Jul 2025 05:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6223F8E0001; Wed, 23 Jul 2025 05:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 502E46B0088
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:32:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3AF71DB066
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:32:20 +0000 (UTC)
X-FDA: 83695013640.23.FA76A99
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9AE5D20009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:32:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="hHZd pvL";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf03.hostedemail.com: domain of liuqiye2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=liuqiye2025@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753263139; a=rsa-sha256;
	cv=none;
	b=rcA23K4+QaazXCZW5dO1MvcoZbekK5/dF9q6Jik/2U5k3qOmXLrozM2zu70W7Fv2cJZmK/
	MxdiMHG3qrBm5wkgBBCc/zzvZOgwqdO0DBEYkkPzxw5fMtttwCtzCb58s0STNeF50x26mP
	eA6nWeT3uZEzpOnJBxOLwc0NvO+xZZg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="hHZd pvL";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf03.hostedemail.com: domain of liuqiye2025@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=liuqiye2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753263139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oIe4Smzjsv9oiMD/3VSb2vW3Ngt6hxJltJ6vmcd+YX8=;
	b=WXuCIFf4PXEiytRrTNsP8X8JP+N17rIo2YIwMchf5PVgjHGqq/JuCncNj3u+KBliyn0BPk
	9j8OTbYNQ/GlppKmzF+e5giLBuuu+VA0wtkf8lzZBr/EAC7XHKk4GQYUgw+psTWFJdvB+l
	ryrxxW8GRGpe+bTyYWKBwQQZD/HMshc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Content-Type:Message-ID:Date:MIME-Version:Subject:
	To:From; bh=oIe4Smzjsv9oiMD/3VSb2vW3Ngt6hxJltJ6vmcd+YX8=; b=hHZd
	pvLK5BoaEz+ZnkbWm9Hcopaboe2QEiOdYfEx21sWkCogF+Sxkkbg7uneHH8uel7/
	Zf7/eA8nLUnDIXip1zYAYk9pomP7ShvEcsBqUCD3va0rPr8e2Sd/K6lHEOFbqPaA
	1pxhXUuWwys/gE15oly3kwFI8THwwgr/taiuBwo=
Received: from [192.168.22.151] (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wCXBgb+q4Boul3JGw--.7490S2;
	Wed, 23 Jul 2025 17:31:47 +0800 (CST)
Content-Type: multipart/alternative;
 boundary="------------FsDPGNLzVDXMymY3XaBDtbuo"
Message-ID: <b6774d8c-fc7d-4459-b2da-5a5fd7a3a284@163.com>
Date: Wed, 23 Jul 2025 17:31:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add stack trace when bad rss-counter state is
 detected
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250723072350.1742071-1-liuqiye2025@163.com>
 <202507230031.52B5C2B53@keescook>
 <c7a32d87-efbd-47bd-9a18-9eb51e441a7f@163.com>
 <119c3422-0bb1-4806-b81c-ccf1c7aeba4d@redhat.com>
 <8dd1e8f6-f96d-4d36-ac2a-c258ac842f75@redhat.com>
 <5cdd3e44-3e3c-4697-905a-ecc61093f7bc@163.com>
 <270d8240-fb64-46e0-a534-80790c4cc905@163.com>
 <9be97451-dfce-4dd2-a034-284da0f19bfd@lucifer.local>
Content-Language: en-US
From: Xuanye Liu <liuqiye2025@163.com>
In-Reply-To: <9be97451-dfce-4dd2-a034-284da0f19bfd@lucifer.local>
X-CM-TRANSID:_____wCXBgb+q4Boul3JGw--.7490S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxGFy3Zr1xAw4DCr43tF48Xrb_yoW5WF4UpF
	4rK3ZxGr1vyrWSyrn7Aw40yr15trs5C3y5G3s5W347K3s8WFyIqF4xKF4UCF1jkr9YkFZ2
	vr4jvr1DCa90vFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UNiSLUUUUU=
X-Originating-IP: [223.70.160.239]
X-CM-SenderInfo: 5olx1xd1hsijqv6rljoofrz/1tbiMAqTUGiAp4JxUAAAsV
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9AE5D20009
X-Stat-Signature: qb5me8oakkikq7h3opnr3zhcmuyinsyr
X-HE-Tag: 1753263137-588135
X-HE-Meta: U2FsdGVkX1/oWtvoY7/0FlvVwomrsdeHhmfuWpdq3suwwGK9ssy05+s30izkpUW/F2hnbxqxUAdjKHLftIJDenIvg01PZoPGhLf7CZtyz3RecdQFFiUK5G1q4jHQRHdNP8NsJlqkeaaHRgXIC9ogO65hHZaxCPAF0b8PywW/nahpUcydKO/rtv2HKAeN9yZ+g7d1402Qt2AzBiiBSMf9rbQHDhU5opMK4oxuUlnUeL8d1NTRi0hNR34NgCK60a3GUNSEEgqE3TMTijzy1MeGggKPyasi2E4cS01Z5KnREjS/O2TwBEpT3a2vqzvEgn7l/xYpZM0yyeP5Nwf7e8Pi7MUmNQWTDi6jOBdPY1//m7V42rogU1WOr6DYSMwWKo/tqyYlgmjc4y1nnp94v4BvXT7HQOpvQru5gEHJhfxV0T7a8UDuB2tlavQo+V21+lfn5P3o+lpbNtquj3e9OmafOyuNfyp2/bAVEEvMRxFEUSCENxjodZCJ9itMOJC17nKFEZ9m3GhIW9TajwnSIPCv37FKA/KLvZ2AbD9Y1Ov6x/w7opZ6XN3lTgioFg64QvEfdvtfwQ4yImA7ZJ6E7n0o/v18qlMJfcWKndUUvLlDyPgZr+1Vzwq5Aq2wW4JLJENkzjhaQRjdP+q39DYV++7NomejzDQ4iacX3ZN6HBu5ZtFtM3K4xcbbWwx7cBERs1tqugCtAhsuB/3zxFAHnbjX22wDdyVix8gAZlnEpFy90ICXCfn7r24Cmk937T5E2HlijnZCVvCCZgAiJfyW9tqlWBVZRi1zyFVJLepbB//4boBNCo9nkg7WGC5YyPgXjXMH0C4eFzezWZkPVDP9GMsoxyB7b7p7/akj5ki5f0qO6V0nbfypOwkgiafjWIxmgo+MzG0OEoTSA9SrfzMHK71b74U02zdhSfj/Z35oIbXs2FYBdtWoP8UXuS9QJJOS+wkPJoXE/iyPj5xu5ScTntI
 z6eVYc3X
 Bcv8MiAP2JygrbY3kPX5NLR68nyT9qtkdJYgDlk1ce6fWJdicL/mkwqZgTl6Jr4WzvcnWmxI5m1u7CYwacPSTgW7N/8QR3Pm5udLquignFTT9pPEkuzrVjMCkzigozchdc35HP6sO0qKTMiibh9Cs7nBWALTYti2SBYwklbyThtKjYPrW8HJeOke3GLAX03g5ZvbhZvaGGIl/hZ5eLTIyrjH8bZV7E9pcwOPlg4YDbWIbKGMSr0RCk3y/aUdHneVPUIwxzeom4pyn5AsbeE6mtBeV9ieLrUaivzoLAjBNeBd+C5eg1kh3U7S1rV6aIDuAV6dJc5h0sLOAxA+rl+WlGJ/4OZBpq8kAfQPtcAbGhly2asI4SB/4KQa+tfhYAftXi9xNhlxgmVO5VMVkQR/O2HpokajjT1xg+1XLx1Ou5ZJLSbq/2WijyOWDXa5ai2F1io8NP/RjitQ2KxJnzG27jmUtjGFu1JkdyTS9aBJKsoji8dffXj1NrnUTYff3i0Ab/4SrY+duNp0EWRJV3qZGRQhgtE+2Ddhi4rhn1dA82TjtBWbJ+zk7sT/h5sw9EIughZTujmPe/bXnHx2mAKOga8vdpMi9et1NMo2EgL1WKx24kMyyoeLOEV0LEvlWLanN2fuDizV/LqW07w8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------FsDPGNLzVDXMymY3XaBDtbuo
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


在 2025/7/23 17:22, Lorenzo Stoakes 写道:
> On Wed, Jul 23, 2025 at 05:14:19PM +0800, Xuanye Liu wrote:
>> 在 2025/7/23 17:10, Xuanye Liu 写道:
>>> 在 2025/7/23 16:42, David Hildenbrand 写道:
>>>> On 23.07.25 10:05, David Hildenbrand wrote:
>>>>> On 23.07.25 09:45, Xuanye Liu wrote:
>>>>>> 在 2025/7/23 15:31, Kees Cook 写道:
>>>>>>> On Wed, Jul 23, 2025 at 03:23:49PM +0800, Xuanye Liu wrote:
>>>>>>>> The check_mm() function verifies the correctness of rss counters in
>>>>>>>> struct mm_struct. Currently, it only prints an alert when a bad
>>>>>>>> rss-counter state is detected, but lacks sufficient context for
>>>>>>>> debugging.
>>>>>>>>
>>>>>>>> This patch adds a dump_stack() call to provide a stack trace when
>>>>>>>> the rss-counter state is invalid. This helps developers identify
>>>>>>>> where the corrupted mm_struct is being checked and trace the
>>>>>>>> underlying cause of the inconsistency.
>>>>>>> Why not just convert the pr_alert to a WARN?
>>>>>> Good idea! I'll gather more feedback from others and then update to v2.
>>>>> Makes sense to me.
>>>> After discussion this with Lorenzo off-list, isn't the stack completely misleading/useless in that case?
>>>>
>>>> Whatever caused the RSS counter mismatch (e.g., unmapped the wrong pages, missed to unmap pages) quite possibly happened in different context, way way earlier.
>>>>
>>>> Why would you think the stack trace would be of any value when destroying an MM (__mmdrop)?
>>>>
>>>> Having that said, I really hate these "pr_*("BUG: ...") with passion. Probably we'd want to invoke the panic_on_warn machinery, because something unexpected happened.
>>>>
>>> The stack trace dumped here may indeed not reflect the root cause ——
>>> the actual error could have occurred much earlier, for example during a
>>> failed or missing page map/unmap operation.
>>> The current stack (e.g., in __mmdrop() or exit_mmap()) is merely part
>>> of the cleanup phase.
>> Dumping the stack still has some chance of helping identify the issue — at the very least, it
>> shows which task triggered the check.
> The stack will be actively misleading because it's highly likely to be totally
> unrelated.
>
> if you want to know the task, just output current->comm  :)
>
> I think it's not only of no value, it's _ACTIVELY_ misleading. So it's
> definitely a no to a dump_stack().
>
> I am also not in favour of a WARN_ON() for the same reason.
>
> Really we should be catching these elsewhere.
>
> If you want to send the patch just outputting thet ask then all good.

we can start by adding |current->comm| and |task_pid_nr(current)| to help identify the triggering task. 

As for possible detection or monitoring mechanisms, we can continue the discussion.


>
>>> Given that, how should we go about identifying the root cause when such an issue occurs?
>>>
>>> Is there any existing way to trace it more effectively, or could we introduce a new mechanism
>>> to monitor and detect these inconsistencies earlier?
>>>
>>> Let’s brainstorm possible solutions together.
>>>
>> --
>> Thanks,
>> Xuanye
>>
-- 
Thanks,
Xuanye

--------------FsDPGNLzVDXMymY3XaBDtbuo
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
    <div class="moz-cite-prefix">在 2025/7/23 17:22, Lorenzo Stoakes 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:9be97451-dfce-4dd2-a034-284da0f19bfd@lucifer.local">
      <pre wrap="" class="moz-quote-pre">On Wed, Jul 23, 2025 at 05:14:19PM +0800, Xuanye Liu wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
在 2025/7/23 17:10, Xuanye Liu 写道:
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">在 2025/7/23 16:42, David Hildenbrand 写道:
</pre>
          <blockquote type="cite">
            <pre wrap="" class="moz-quote-pre">On 23.07.25 10:05, David Hildenbrand wrote:
</pre>
            <blockquote type="cite">
              <pre wrap="" class="moz-quote-pre">On 23.07.25 09:45, Xuanye Liu wrote:
</pre>
              <blockquote type="cite">
                <pre wrap="" class="moz-quote-pre">在 2025/7/23 15:31, Kees Cook 写道:
</pre>
                <blockquote type="cite">
                  <pre wrap="" class="moz-quote-pre">On Wed, Jul 23, 2025 at 03:23:49PM +0800, Xuanye Liu wrote:
</pre>
                  <blockquote type="cite">
                    <pre wrap="" class="moz-quote-pre">The check_mm() function verifies the correctness of rss counters in
struct mm_struct. Currently, it only prints an alert when a bad
rss-counter state is detected, but lacks sufficient context for
debugging.

This patch adds a dump_stack() call to provide a stack trace when
the rss-counter state is invalid. This helps developers identify
where the corrupted mm_struct is being checked and trace the
underlying cause of the inconsistency.
</pre>
                  </blockquote>
                  <pre wrap="" class="moz-quote-pre">Why not just convert the pr_alert to a WARN?
</pre>
                </blockquote>
                <pre wrap="" class="moz-quote-pre">Good idea! I'll gather more feedback from others and then update to v2.
</pre>
              </blockquote>
              <pre wrap="" class="moz-quote-pre">Makes sense to me.
</pre>
            </blockquote>
            <pre wrap="" class="moz-quote-pre">After discussion this with Lorenzo off-list, isn't the stack completely misleading/useless in that case?

Whatever caused the RSS counter mismatch (e.g., unmapped the wrong pages, missed to unmap pages) quite possibly happened in different context, way way earlier.

Why would you think the stack trace would be of any value when destroying an MM (__mmdrop)?

Having that said, I really hate these "pr_*("BUG: ...") with passion. Probably we'd want to invoke the panic_on_warn machinery, because something unexpected happened.

</pre>
          </blockquote>
          <pre wrap="" class="moz-quote-pre">The stack trace dumped here may indeed not reflect the root cause ——
the actual error could have occurred much earlier, for example during a
failed or missing page map/unmap operation.
The current stack (e.g., in __mmdrop() or exit_mmap()) is merely part
of the cleanup phase.
</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">
Dumping the stack still has some chance of helping identify the issue — at the very least, it
shows which task triggered the check.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
The stack will be actively misleading because it's highly likely to be totally
unrelated.

if you want to know the task, just output current-&gt;comm  :)

I think it's not only of no value, it's _ACTIVELY_ misleading. So it's
definitely a no to a dump_stack().

I am also not in favour of a WARN_ON() for the same reason.

Really we should be catching these elsewhere.

If you want to send the patch just outputting thet ask then all good.</pre>
    </blockquote>
    <p>we can start by adding <code data-start="71" data-end="86">current-&gt;comm</code>
      and <code data-start="91" data-end="113">task_pid_nr(current)</code>
      to help identify the triggering task. </p>
    <p>As for possible detection or monitoring mechanisms, we can
      continue the discussion.</p>
    <p><br>
    </p>
    <blockquote type="cite"
      cite="mid:9be97451-dfce-4dd2-a034-284da0f19bfd@lucifer.local">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">
</pre>
        <blockquote type="cite">
          <pre wrap="" class="moz-quote-pre">
Given that, how should we go about identifying the root cause when such an issue occurs?

Is there any existing way to trace it more effectively, or could we introduce a new mechanism
to monitor and detect these inconsistencies earlier?

Let’s brainstorm possible solutions together.

</pre>
        </blockquote>
        <pre wrap="" class="moz-quote-pre">--
Thanks,
Xuanye

</pre>
      </blockquote>
    </blockquote>
    <pre class="moz-signature" cols="0">-- 
Thanks,
Xuanye</pre>
  </body>
</html>

--------------FsDPGNLzVDXMymY3XaBDtbuo--


