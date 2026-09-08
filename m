Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49262C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 06:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A3B6B008A; Tue,  8 Sep 2026 02:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50B276B0093; Tue,  8 Sep 2026 02:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422036B00C0; Tue,  8 Sep 2026 02:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2237C6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:40:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACF83A03BE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:40:23 +0000 (UTC)
X-FDA: 85189645926.13.78E24F2
Received: from mail-m127213.xmail.ntesmail.com (mail-m127213.xmail.ntesmail.com [115.236.127.213])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8FAF118000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:40:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 115.236.127.213 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788849622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zGSumJiJaaHChErf9w8J+E3GDcThdjqb3i+OaPlWdas=;
	b=BV9L+FlsaE7RwJ2XKD44hhPcB9kULfih13JSKUNtz9bY4zZApXIcX6E4TjGvqmfhYt4gyE
	XG4swVtwjaWBmP+vEwo0jdRts1oyXcD2IIaiq0e0gDIClCquVUAubdLMegcr2ycYU3NvLE
	Kodr/N/pQPiF2qFTqo8HJXXWUscDihc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788849622;
	b=vzglvWpdyiPCBwE7Ha9lXeverBg++IFuHkZLWhGOjRvDH6qPRgktXpqQ2tzXayVNV84J5U
	9YgaXmgB3a+BDQO22K7vIxBoD60wHuC2r3CkVYSRUpIx3Wf/gFmuFUZNOjkrOlzZbTpvCG
	UhW6hGEzyy3zAcNfd+B2p5B6fJQlU/M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf06.hostedemail.com: domain of zhen.ni@easystack.cn designates 115.236.127.213 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ed122a35;
	Tue, 8 Sep 2026 14:40:10 +0800 (GMT+08:00)
Message-ID: <048d7470-a813-4252-a4f0-0ec29694f639@easystack.cn>
Date: Tue, 8 Sep 2026 14:40:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: Weijie Yuan <wy@wyuan.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
 <a6ce8684-116b-42f2-a88c-154eb86bad59@kernel.org>
 <a98bde94-d1fb-4246-b7c6-e64303d8388a@easystack.cn>
 <5d4c247c-b8ea-4d3f-b2b9-d442d372fd03@kernel.org>
 <6744bcdb-3456-4ba2-95a0-a58c354bfbfa@easystack.cn>
 <ap-qDThi-NQgVXVD@wyuan.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <ap-qDThi-NQgVXVD@wyuan.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa07fbedeea0229kunmc6aacfca1acab9
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQh1OVkoZSB1DThhNShhKTFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9CTFVISU
	xNQlVPVUhLS0pZBg++
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8FAF118000C
X-Stat-Signature: rr5rfs31rtu7deaof7iozw6c7ttrstr3
X-HE-Tag: 1788849619-958070
X-HE-Meta: U2FsdGVkX1868hgrMKoAE+ok0zIO0r4HUyBOX9PBpshMEcIuBXRSRSILCfRpKKu6wz9omAhJ6kMU5ITAS0kALKhau6CjkSix86Ohn3r08rGHYi/zwvQQEcMilMCNvx49rhdaVoKzuCO4RgVcgF1ziHoYzXPVApRZTXfQ0EjlTRFZHLzdASOR0Raui/ovulddMcdD1oToFobdvVUJ6Km80QMmYA1cMbRsrplBVg+cCALEOBffutng0iNMZuoEb2G5K1klByeRLzGK7waXns8efLIn8b1kNDKKtkq7wVw2Oyum9ueM1y3qPK6wTJ1pRjv+WepFrL9WMC2juVZun8tIxp6kGV9AiPPpP6Nadw35ALmq38WOY1ebTPPJz5vgwwLyDusCwB1M13YHV4IhNcqXBXnM7cHCIsPy302Hp2XkeF88FoPdL6JQ1xQunjSbtv54UvYW3EUWKgLpAL7xRXtp4RccvZmi3imtEW2jI4m3A4nUX22ixaZGTrRLQJRiYrJ8k1rGVcF50wD6P6CARHHgeiuivfbJXb/0DquE7hv6gl5oLvmW8c5XxlcnOEZBU5cIOvYv8PemwSFrplXJT1nE+dVNJEYcW+eBjRB8z1Mwmj0DMgZ1QtEtUOdIlR03jJ/NmUAmJUoWCI6Xyn0eheeGI7K4B2bPKbNfxXFptxkgF8TiyqEmna4fhSqZnDBcLDT0yl1Pqu5jxH6TM2oBvEpsZ7YJcpRf5sBb/oW8/ZPZp85id30A2LiTj9Qbuke8nhSbUNr4QzSnc+1EscBeY7pwanUILV5TRGe/m9f+FSGipTS1b/awg+jGd5dnUxhulJmSZSl5V1+O+x8A5SvrXHd/dXZIX4uhUH9XOLB9GfsxHea/afpsknB4h7DTEurY3kT8RfdRJPTuIjQchOaZa7gNi+WLomsatVx19T5vxc7nuUu4XxpZOsZ6gZRX62fbvBld2ez7jtgoMqzBUOuu7LI
 prvSc0kf
 MZyxJd9i8jrHnpCFrGLSYo1BRMceRlWqigC7ubYRCFiYHJXy3Kma64dZ2TtvsobkcVohkkAMfdd94hXDGTkuPfZia4sIWMnmdv2EhwJXLQpzyvbQlWNI3qokgTc2GCIQvoAuPefJEppHj4dZ3exHXi2f4g7wPA+qukh2Ulnju4P/XOLkByFG2SrI2pD1jkQFbTB3aMFqvahvNH7k/FnKxdMD5fjDM3inHJbxv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/8 14:24, Weijie Yuan 写道:
>  From an outsider..
> 
> On Tue, Sep 08, 2026 at 10:41:23AM +0800, zhen.ni wrote:
>>>
>>> Sorry but your whole reply reads like a LLM slop. It took a lot of
>>> mental effor to actually try and engage with it.
>>>
>>
>> This reply was written by me, and its viewpoints are not simply copied
>> directly from an LLM. The LLM only assists with the wording.
> 
> So that's probably the reason. Your previous replies was indeed very
> much like the output of an LLM. Even if the idea is your own, after
> being "polished" by LLM, it's hard to read. I know English is not our
> first language, and it's not that easy to speak like a native speaker.
> But may I ask you did you read it before sending them out? I really
> found this bunch of overly formal content a little painful to read.
> 
> So I suspect the LLM may have taken too much liberty in polishing your
> text, to the point that your replies no longer read like something a
> person would naturally write.
> 
> The "Summary and Plan" in your reply in v1, both in its formatting and
> wording, looks quite similar to LLM-generated text to me. So I can
> understand why Lorenzo asked whether you had used an LLM. Come on, we
> all know what LLM writing looks like.
> 
> That said, I do not know exactly how you used the LLM on your original
> text, so please forgive me if I have this wrong.
> 
> Thanks.
> 
> 
I really can't distinguish the LLM flavor that clearly in English. I'm
sorry for causing some trouble.

My normal reply process is to first describe my ideas, then have the LLM
check for logic and grammar issues, and do a round of polishing. I check
the final draft once more to see if it has deviated from my ideas, and
make corresponding revisions.

Thanks,
Zhen

