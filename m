Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DBCA1112250
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 02:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43C36B0088; Wed,  1 Apr 2026 22:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD486B0089; Wed,  1 Apr 2026 22:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995506B008A; Wed,  1 Apr 2026 22:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8502E6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:13:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 355D01B74B9
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:13:37 +0000 (UTC)
X-FDA: 84611994474.27.99A53FA
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4F2FB140007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:13:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="x5/1ZzSQ";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of yangyingliang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yangyingliang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775096015; a=rsa-sha256;
	cv=none;
	b=Xn7cqd+6M+4N2pgXosm+lmGNrXCR9lYAwnOaF3dF/ZJ13yXlCGAAgmP3VeA1OFbVO/LHGX
	wd22F+dHnKET8+YloXjcXGxwGEu/G5HiBasKVfSreBhufaAwvWbgQapq/YyeQxKFNCQjAx
	kQAT3c+9LQvftUsOGjVMTGJ+q783duc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="x5/1ZzSQ";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of yangyingliang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yangyingliang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775096015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5qLEOXfUTk8DL9LxyouvXtAoe4C1SePsVgMFt8tP36U=;
	b=HvNQL7fN+Gt3Vr4m6WUZ6Dqc51cHCdeI8oQDAg0ERkQal0F/pWojN6V+H7xX7XgVGwJA/D
	TOwpIoRaMIN7ad55vh7bm4+NihIdRDmNStoB9RW0/+p4z0gkRNxYHvwX/bIkWEvqcJy5dp
	TS2r0qQLaUZa4LM7/3bGHMhmnllUtp4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5qLEOXfUTk8DL9LxyouvXtAoe4C1SePsVgMFt8tP36U=;
	b=x5/1ZzSQzLqAmm/k2nYixO7Fiucl0o4zNrB4VGXu1c8j3JxBNMoU2iY9qb3LMIGhUNEgNKofO
	FQnK44C4GyeskgGgtCe/r6uabtMKVGlHsAF9Z/25Y2Gufp5RmAomN9/EzRax+N6yDrsd9EO3PQd
	wBVC9NQ1UH6yp54CW38t1e8=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4fmQGz5b0XzpT0L;
	Thu,  2 Apr 2026 10:07:39 +0800 (CST)
Received: from dggpemf200002.china.huawei.com (unknown [7.185.36.244])
	by mail.maildlp.com (Postfix) with ESMTPS id 08EEB203B2;
	Thu,  2 Apr 2026 10:13:29 +0800 (CST)
Received: from [10.174.178.174] (10.174.178.174) by
 dggpemf200002.china.huawei.com (7.185.36.244) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 2 Apr 2026 10:13:27 +0800
Subject: Re: [PATCH -next] mm: vmstat: make refresh interval take effect
 immediately
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<liushixin2@huawei.com>, <hucool.lihua@huawei.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Yangyingliang
	<yangyingliang@huawei.com>
References: <20260326075546.3357901-1-yangyingliang@huawei.com>
 <f65f3910-f444-40bf-9d15-42a8b6215a56@kernel.org>
From: Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <e72e2b72-d408-8af1-9316-2f3ddcaacaf3@huawei.com>
Date: Thu, 2 Apr 2026 10:13:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f65f3910-f444-40bf-9d15-42a8b6215a56@kernel.org>
Content-Type: multipart/alternative;
	boundary="------------AEE0935252EE36F7617A5695"
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf200002.china.huawei.com (7.185.36.244)
X-Stat-Signature: 4pe14bakh5hnrr6bmnjcyfyty576qcy3
X-Rspamd-Queue-Id: 4F2FB140007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775096013-584804
X-HE-Meta: U2FsdGVkX1/0kUtNiVn7RDRZoIhLJhUE9BmhkMsFwEa0oUEB/2FxMDEkR4MUHy84Xq0Z6g5Ba/aJc9ZPmFbTAxW5FEEFH26HgXTcoEQVu6mQjQiwkjUyiTQSoOrzvavr0ngqEz8BEBhjUaG6TvhJDenzA68XA9XmjFPsWxxkro54zNomH+E6kVEa9HMOMRtfWqXxhj7/s5jDzUmyIZgqH9KCYqiKYqIkbs40DZUgAqVu7zp7xnL4qz+eI47WHt/LRj4qNjY+bA9Ybza4A8O7iN72kfuOHXQDxWLTSrjwhcC6eSTAuiGkLAIV8n5jmKseDZecp1FGFfQBN6hSY1fGbBqJVXhJsf1omv7qmg1U9IexzeB0X8g6ZrkEUWR8cSLqIojRVEI86ONLdPsoTR8/umswtBYK2/keCBFtvalSFUWWGut8OZF4Mr7/yZ/gSGgRs4NNyjl65wnMAKsPU6KC7ynqVrs+sFs/EKVgZ7eiY7DJl0OJUNdi54fywAg/TfFi33wXMuQQzvP4EUHRIowTCu/5u4gJCUh6DavaaUNlGX6RoscDdhg8Ctaih6Cq5IqWAfXOlizSesHodHbYjaFJDQIK89CqKlFZlnHE3erHBcwIofU14xDjX20mQjhp/8HTO+UUUvY3QpNP8y5umUWK47+yVpPx+AA2/r4/az4jJpvA8R4G6o5kWXhBImlQr3N6aDDthipehy1qpUNkueT9Vmr4bqBEGqYS9JGfazCglZi9CZENEDHgwdbU2FZ315K+gIbho/Vtu0FoQMCyPR9HTRswfuttxBcMOJHDKRldL8lorw0kkTQzl90QMvJUqSh+q6l8/2eOi6aDFeXcydQs1vOHrtgRS5bAjhlGFRZAw2OmBU0f5EF9nAivFy7lXExI4pP0UPqOdAV07jKS1ByRsgq5puv7dJSMcMieotFmwXTpjkS3BiNXsN8nq1/zcfoaeIKwj8N0pzcGxe7emZK
 /l1z11lK
 4ZjFOil0H99vNAvzyootai+xsIaOZlcg//VWOTXsDPp9ZTP8E0AoJ8sbbVyhYfIg8uzo53N7A3oNrqTLkGtTkUm9aVSw13HrkiKyQhtXbXD0DrR/EKbuMGpDm8lsS+T2MobBzRz3GqM2nDqIrQON3XmEAvTJF6g2ljchoFBk8Gvp8jv7SKcfMhv5DwYUihJsVDipvw8YvOHcuP9veT6lxkFxTIwCLiO3kwFJwrdrjXPH96vO3FW21w2OUxMJ0w5Bfer7NyoNo+yfPorKIzAQwih1SBfLc+Z8TkDG92y0FUTbv6gHM4BCdOBSEmOuLW5cj/DQxxhOJGx8QBmkbUlnE7V4kWr3BTbPrWYr8b0DEaXvjAsf4iOyIbLQCmdFrojBqrVaUNeUMAkfxI86xK2GkPnsQ/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------AEE0935252EE36F7617A5695
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit


On 2026/3/26 18:09, David Hildenbrand (Arm) wrote:
> On 3/26/26 08:55, Yang Yingliang wrote:
>> The refresh workqueue is re-queued after last timer is triggered, so when
>> the refresh interval is set, it doesn't take effect immediately.
>>
>> It leads a problem like this: if current interval is 8640000s (100 days),
>> and we want changing it to 1s, the new interval can't take effect until
>> 100 days later.
> Well, yes. But, the default is set to HZ. If you set the default to
> 100days you are probably doing something very wrong in the first place?
It's a fuzzy test.
>
> What's the use case that warrants the complexity? Even when set to, say,
> 30s, waiting 30s is not that bad.
>
> Would we maybe just want to set an upper limit to which we clamp? That
> would be a lot simpler.

Is this too strict ? If someone want to set 1min or more, but it's 
limited. Some existing

scripts function may be broken.

>

--------------AEE0935252EE36F7617A5695
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 7bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">On 2026/3/26 18:09, David Hildenbrand
      (Arm) wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:f65f3910-f444-40bf-9d15-42a8b6215a56@kernel.org">
      <pre class="moz-quote-pre" wrap="">On 3/26/26 08:55, Yang Yingliang wrote:
</pre>
      <blockquote type="cite">
        <pre class="moz-quote-pre" wrap="">The refresh workqueue is re-queued after last timer is triggered, so when
the refresh interval is set, it doesn't take effect immediately.

It leads a problem like this: if current interval is 8640000s (100 days),
and we want changing it to 1s, the new interval can't take effect until
100 days later.
</pre>
      </blockquote>
      <pre class="moz-quote-pre" wrap="">
Well, yes. But, the default is set to HZ. If you set the default to
100days you are probably doing something very wrong in the first place?</pre>
    </blockquote>
    It's a fuzzy test.<br>
    <blockquote type="cite"
      cite="mid:f65f3910-f444-40bf-9d15-42a8b6215a56@kernel.org">
      <pre class="moz-quote-pre" wrap="">

What's the use case that warrants the complexity? Even when set to, say,
30s, waiting 30s is not that bad.

Would we maybe just want to set an upper limit to which we clamp? That
would be a lot simpler.</pre>
    </blockquote>
    <p>Is this too strict ? If someone want to set 1min or more, but
      it's limited. Some <span data-slate-fragment="JTVCJTdCJTIydHlwZSUyMiUzQSUyMnBhcmFncmFwaCUyMiUyQyUyMmNoaWxkcmVuJTIyJTNBJTVCJTdCJTIyaWQlMjIlM0ElMjI5VnFubDNROTVHJTIyJTJDJTIycGFyYUlkeCUyMiUzQTIlMkMlMjJzcmMlMjIlM0ElMjJzb21lJTIwc2NyaXB0cyUyMGJlaGF2aW9yJTIwJTNGJTIyJTJDJTIyZHN0JTIyJTNBJTIyJUU0JUI4JTgwJUU0JUJBJTlCJUU4JTg0JTlBJUU2JTlDJUFDJUU4JUExJThDJUU0JUI4JUJBJUVGJUJDJTlGJTIyJTJDJTIybWV0YWRhdGElMjIlM0ElMjIlMjIlMkMlMjJtYXRjaGVzJTIyJTNBbnVsbCUyQyUyMnRyYW5zbGF0ZWRCeSUyMiUzQW51bGwlMkMlMjJtZXRhRGF0YSUyMiUzQSU1QiU1RCUyQyUyMnRleHQlMjIlM0ElMjJleGlzdGluZyUyMiU3RCU1RCU3RCU1RA==" style="white-space: pre;">existing</span></p>
    <p><span data-slate-fragment="JTVCJTdCJTIydHlwZSUyMiUzQSUyMnBhcmFncmFwaCUyMiUyQyUyMmNoaWxkcmVuJTIyJTNBJTVCJTdCJTIyaWQlMjIlM0ElMjI5VnFubDNROTVHJTIyJTJDJTIycGFyYUlkeCUyMiUzQTIlMkMlMjJzcmMlMjIlM0ElMjJzb21lJTIwc2NyaXB0cyUyMGJlaGF2aW9yJTIwJTNGJTIyJTJDJTIyZHN0JTIyJTNBJTIyJUU0JUI4JTgwJUU0JUJBJTlCJUU4JTg0JTlBJUU2JTlDJUFDJUU4JUExJThDJUU0JUI4JUJBJUVGJUJDJTlGJTIyJTJDJTIybWV0YWRhdGElMjIlM0ElMjIlMjIlMkMlMjJtYXRjaGVzJTIyJTNBbnVsbCUyQyUyMnRyYW5zbGF0ZWRCeSUyMiUzQW51bGwlMkMlMjJtZXRhRGF0YSUyMiUzQSU1QiU1RCUyQyUyMnRleHQlMjIlM0ElMjJleGlzdGluZyUyMiU3RCU1RCU3RCU1RA==" style="white-space: pre;">scripts function may be broken.
</span></p>
    <blockquote type="cite"
      cite="mid:f65f3910-f444-40bf-9d15-42a8b6215a56@kernel.org">
      <pre class="moz-quote-pre" wrap="">

</pre>
    </blockquote>
  </body>
</html>

--------------AEE0935252EE36F7617A5695--

