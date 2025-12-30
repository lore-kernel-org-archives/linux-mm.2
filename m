Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9BBAE95A98
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 20:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EDD96B0088; Tue, 30 Dec 2025 15:48:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B126B0089; Tue, 30 Dec 2025 15:48:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5106B008A; Tue, 30 Dec 2025 15:48:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F00A66B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:48:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9038AB7E55
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:48:13 +0000 (UTC)
X-FDA: 84277324866.05.EC4C5CD
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf19.hostedemail.com (Postfix) with ESMTP id A81D51A0018
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:48:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wub7OS+L;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767127692; a=rsa-sha256;
	cv=none;
	b=M8OSwdnUhjadCePe9W13+KHKiJlnlos5ke/xgje5BV0LEWZhoNfyk6kd5lCoiZXWAvKMoM
	c4xyKwBCjfT4A0o3L985fY+htJcaFZ9rPDBOKptPnR4kVq8eUkHbW2wih2PB5yUn4O3qtE
	7Bvly3ynRbd8uTKNF7vrFgxY+YNnTkw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wub7OS+L;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767127692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVuULU9DWzbX35aYTs+GdWerbt0qAG31AAAaM0plU/A=;
	b=wt1b5VKaECZFYUjMG7nMgNyq/8zaVQ5w/zy/83DiMsWRruawI8yqnKhexTf7t2LSAhPghu
	Qgp+fZ21WOunEFwnJlXtczDYB6xTelDKpzUXrclGWPLxU2eBRS3hlW7Z+FpZmnQctLiLoG
	9mK9+8BL0ZUouH60KbWhE9IqTfmlZ3o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767127689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UVuULU9DWzbX35aYTs+GdWerbt0qAG31AAAaM0plU/A=;
	b=Wub7OS+L16NbJTJN4pl2A/cialO1q+2ltjN+k35LpGDOQBzBCQXojN0OAFrER0w8ETJ7lW
	1FCtFaQlRsMZzpL0etDfrf+cr+AGLIeSwHdeihmiQkt0JaZiGfAfGZB1fhI+feDT7CepUs
	3HJ/XszdHWrhdNwDQRkaEX46ErWO+cw=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Qi Zheng <qi.zheng@linux.dev>,  hannes@cmpxchg.org,  hughd@google.com,
  mhocko@suse.com,  muchun.song@linux.dev,  david@kernel.org,
  lorenzo.stoakes@oracle.com,  ziy@nvidia.com,  harry.yoo@oracle.com,
  imran.f.khan@oracle.com,  kamalesh.babulal@oracle.com,
  axelrasmussen@google.com,  yuanchu@google.com,  weixugc@google.com,
  chenridong@huaweicloud.com,  mkoutny@suse.com,
  akpm@linux-foundation.org,  hamzamahfooz@linux.microsoft.com,
  apais@linux.microsoft.com,  lance.yang@linux.dev,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  cgroups@vger.kernel.org,  Qi Zheng
 <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
In-Reply-To: <6o2gnpjd7z7hxl2lu2lyevawtkcas6xar6z4zip4zc3unq27cf@k4bhpnfclnkj>
	(Shakeel Butt's message of "Tue, 30 Dec 2025 10:36:52 -0800")
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
	<7ia4ldikrbsj.fsf@castle.c.googlers.com>
	<423puqc6tesx7y6l4oqmslbby2rfjenfnw5pn5mgi63aq74jwj@jwgorel2uj3m>
	<87ecoc7gnp.fsf@linux.dev>
	<6o2gnpjd7z7hxl2lu2lyevawtkcas6xar6z4zip4zc3unq27cf@k4bhpnfclnkj>
Date: Tue, 30 Dec 2025 20:47:58 +0000
Message-ID: <7ia4wm23y9vl.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A81D51A0018
X-Stat-Signature: 5je5tsdzbme8cbnwpw69e6o3joigmodf
X-Rspam-User: 
X-HE-Tag: 1767127691-36098
X-HE-Meta: U2FsdGVkX18Q/sGHXsAciwBuWYRRB8CkBDL0BQu1vVQOeyXbsyRRCNaG9iGlcMrYaM5nlaP+7InKCQJgFmwUHV8MJa7U8a0PL4KVdnnv13weZsOBZ44b0ta1c60871Coi4m+u0AiYt41tq58KUIk1aFF3bRA2bCSJWzDAnyS95AczC1ULoau6/4ep6J+VoRJIOXLAd7GYqVXAF/FxZeXJqNaBHqvoWywm4M4rao3Mexu8GL0SqDlndvLDEI8WRBIzaoU3aNgi7JQft2ShjNQvrB3PTq2rvI4d8HRfhkBvTUQLaPM1Ciy2qCwH8TpxEAoQUEwXxv/jfNSN2yCbd9RDpCVhNDaXZdhY4vIdsfvrTyHaFRy2TRm8gM0onKIT/xSGwx/JM7ZkkOdpCBhgtK9stqPUBzuwcN7wCTXW3XKazmYLTS/Lb3LjD9tQamk/pTK7aY+uqSywCeufhdGfHBZ6kf1KChLiSBBot1B3RUk2E7Hv8lvfxCZKV1eHU1466s/TLeo/WYg233DzXehF7vlRE8sAeUfS+ocANItqBe2MQjyo0n4JklTY1oF3jCCH4gnOOXD2xrEQR6Ne5r/mp8xSZGugCh3EfmywedeoZhMxvwdsXavqaK9I39P53l8EuioaslxRuuKDIkMSEKd6J/ElsVyL0J590+9Ae50fMtZS9X7QQxdIwsOCVNK0UWlZ4CxmFYH1BTBrxEB/rQQUFuptUwS4weYt1aXEJL5eeVivvWl5BjeNXchI/QWgG68Wv2Q8ycUfvGAhA/A7zugz+tAmQG1syQulZY7kawHQ3YslMTnLWWaaGBPZ2q9ABk1k2oUp7Jf0jqDbfMWFzX9mf7dzg9c5pJukgJIMPNWshn5PgttAWX9ddU49tatGmWxqB3Y9ADoZ+iO/iUi6dA6rXiJTvfoUiHLX8wyQY7G0viXS8NM6IisnWvS2+PUPED/C7+vKRivrVHVqZNKsgchnwZ
 okesNNjY
 Rl5RUneGGI2GmqpZ+bk8yU+jR7SHJyEyREnK7tGd2YYclP6RjhwneIUxskW/BmW12mnQhdaZNhBzBZKbfmDw9/uE8Vcz2SYrIPh9Md2JMorhAiqvZ1G5w6367tcd9HCFjIPITDm+OOY+teN7daXvG2eBZgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Mon, Dec 29, 2025 at 08:11:22PM -0800, Roman Gushchin wrote:
>> Shakeel Butt <shakeel.butt@linux.dev> writes:
>> 
>> > On Tue, Dec 30, 2025 at 01:36:12AM +0000, Roman Gushchin wrote:
>> >> Qi Zheng <qi.zheng@linux.dev> writes:
>> >> 
>> >> Hey!
>> >> 
>> >> I ran this patchset through AI review and it found few regression (which
>> >> can of course be false positives). When you'll have time, can you,
>> >> please, take a look and comment on which are real and which are not?
>> >> 
>> >> Thank you!
>> >
>> > Hi Roman, this is really good. I assume this is Gemini model. I see BPF
>> > and networking folks have automated the AI review process which is
>> > really good. I think MM should also adopt that model. Are you looking
>> > into automating MM review bot?
>> 
>> Yes, absolutely. We're working on it, hopefully in January/February we
>> can have something reasonably solid.
>
> Can you share a bit more about the plan? Are you working more on the
> infra side of things or also iterating on the prompts? (I assume you are
> using Chris Mason's review prompts)

Mostly on the infra side. I want to look closer into mm and cgroups
patches, but I need a bit more data and infra to do this.

As of now we're building some basic infra to run it on scale.

> On the infra side, one thing I would love to have is to get early
> feedback/review on my patches before posting on the list. Will it be
> possible to support such a scenario?

Absolutely.
You can do it already using a local setup, assuming you have an access
to some decent LLM. In my experience, a standard entry-level pro
subscription which is like $20/month these days is good enough to review
a number of patchsets per day. This works well for reviewing personal
patches and/or some targeted upstream reviews (like this one), but for
covering entire subsystems we need more infra and more token budgets
(and this is what we're building).

Btw, I mastered a pre-configured environment which saves time on setting
things up: https://github.com/rgushchin/kengp .
I've been testing it with Gemini CLI, but it should work with other
similar tools with some minimal changes (and I'd love to accept patches
adding this support).

Actually I think there will be several rounds of ai-reviews:
1) Developers can review their patches while working on the code and
before sending anything upstream
2) AI bots can send feedback to proposed patchset, as it works for bpf
currently
3) Maintainers and/or ci systems will run ai reviews to ensure the
quality of changes (e.g. eventually we can re-review mm-next nightly
to make sure it's not creating new regressions with other changes in
linux-next).

> On the prompt side, what kind of experiments are you doing to reduce the
> false positives? I wonder if we can comeup with some recommendations
> which help maintainers to describe relevant prompts for their sub-area
> and be helpful for AI reviews.

I like Chris's approach here: let's look into specific examples of
false positives and missed bugs and tailor our prompt systems to handle
these cases correctly. The smarter LLMs are, the fewer tricks we really
need, so it's better to keep prompts minimal. We don't really need to
write AI-specific long texts about subsystems, but sometimes codify some
non-obvious design principles and limitations.

> On the automation side, I assume we will start with some manual process.
> I definitely see back-and-forth to improve prompts for MM and someone
> needs to manually review the results generated by AI and may have to
> update prompts for better results. Also we can start with opt-in
> approach i.e. someone adds a tag to the subject for AI to review the
> series.

Yeah, there are some things to figure out on how to make sure we're not
creating a lot of noise and not repeating the same feedback if it's not
useful.

Thanks!

