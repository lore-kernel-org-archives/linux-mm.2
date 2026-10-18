Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB685CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 22:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62DDB6B00B3; Sun, 18 Oct 2026 18:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DECD6B00B4; Sun, 18 Oct 2026 18:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F4F36B00B5; Sun, 18 Oct 2026 18:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 228E36B00B3
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:48:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00E5E4021E
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:48:50 +0000 (UTC)
X-FDA: 85337238462.19.5CC004B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 57DEF1C0005
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:48:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4peT3hN;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792363729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTS+377+qfH82v/tIU4D9gzx0DSVopZH/Ul399TkRyQ=;
	b=0FdJ6hK9K4kR2x5BZpOz1ZfLs8kVmlsNSyF1MiUpWRLWUzs6U2B02f1dWvNk9T8x3XY6+J
	MyR7pAPLqCcaNsfo5OQyAVweAV2pe1+P1nB0msLCuRfecDmq3zmnskwqVMCIO+gyAZvZMT
	AiLUwCxMkOBU3iqTr+Uz7tyB98y+aWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792363729;
	b=02FE0zInjQ/q/uXJEkmRJ1NO8/aMblWeyn1esbUvuCqBVlymhnrrYrpFkfTkla9v9IdpxW
	GaP7QUOWnsG8ESDaSTijjj9cuhyQXmQXhHTbOlODF31XLFEnqpDMFIZSFSi0lOhx6fmuuf
	62/8Wjg/CFv5hc5jDugx9edUh0vLNMs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4peT3hN;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4BCB60D9F;
	Sun, 18 Oct 2026 22:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEC01F000C4;
	Sun, 18 Oct 2026 22:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792363728;
	bh=kTS+377+qfH82v/tIU4D9gzx0DSVopZH/Ul399TkRyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C4peT3hN5dydzeV1t8d8epwshIEUPWDe7/XOXLQ/+5OVZFlpMWPlVPtV22dRExIIh
	 XOTdd1S4+xgul771MVmuJH3hjGduYKyKj5yyv5JHBbVjfaEe/SV/ZFw32urkIBFNLo
	 Fp7uj6IEslvL2SRVWG1BjgWdi43ZEiiuHLoTcDe/ww53qanka6K5OjQEFafyWOMPg8
	 E82IgVUvpxNmJvv60LYM2xOHcQ6hh1LoFcNy2Chve2MvTAjsuE/ytYb7LpylP30PYb
	 mLObRFfe2KyAZx91MR7PMPW/WyrK1cMqyxQ/sbzn3zT2mVX0oPuFUI/erXRQWuE8zj
	 /b69vl0C2KmsA==
From: SJ Park <sj@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	ackerleytng@google.com,
	akpm@linux-foundation.org,
	chriscli@google.com,
	hannes@cmpxchg.org,
	harry@kernel.org,
	jack@suse.cz,
	liam@infradead.org,
	muchun.song@linux.dev,
	shakeelb@meta.com,
	ziy@nvidia.com,
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: Sashiko change proposal
Date: Sun, 18 Oct 2026 15:48:28 -0700
Message-ID: <20261018224830.160147-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <7ia4o6ct7lqi.fsf@castle.c.googlers.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qd77jzk6i5ajwzq14dfpf9fwhtmog7tc
X-Rspam-User: 
X-Rspamd-Queue-Id: 57DEF1C0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1792363729-105013
X-HE-Meta: U2FsdGVkX18jlt3upKb84DcGXLNLklNjTqfDqhyHdQhqZlGp8V4ZrbO0LYD9FJ5K5rbLXb7yU2sj0Euw2MJkxqObMdTOpmC1gS6GirureYLkrR8hrU9Zu1qf1NSVvAeUmHjjBxVaLDoIWhW8W5rXdcTjMDnzSWl7lrcejUCLcSG3f6YB+FnWIyaOn/zjMRES286d5FrC4ysQJ75SrQtxhr4I3i2k/4WtZe0dXeDopZTw8FWXvEsN92qzELaQynoW7U4lJk6aK3xwcqb1w3C4wc+Gy2b1A0mgn32DVuo0lvX71/+jBG28aAi8geLpX3PgMw5ncMpvKrKax8Y3qtF1qMBcODeze/PHblii5FmzN9tbokDw4guMYZ/ngV2ViacKwSV3UP+7DupVv2ye7vZVjiqAj7vlPzKTcD0fZaMDvs8HGVcvM3aDOUzNFZQ0g4SZHDzG6/XHjO2bTwhCVtPxqpM3QcfSOWaza1gh8GdpBO3adgqWWOSHgewf3cd5sIAsLGIbL/JZRpSLrfY8/J5T48kWxn10G4lvxDBw7OXuuewayLqZJ/GramyuOJYHdhw5BR7lA+4v6mHVoGT7OtQNpjsIRpaB6cMkZcSyd14GOtQ4tRlnQ0KGfPwmPL9/MHR2y/S/mmspDYHZiax7K2pLZp1bPE7amc3o0yv9H+ahNdwoJEr7T2ZkDYZdr4yUlPTGYjOJv41gLZktdNnsUavwvifRHTGNgRHr9fNasQc6jyuvJMc2nUHr3LdDTG4jHM81jRnxpEL7VKb/V7GES1W1QTosWWenZHgy9aB7i+uL/V5/6lTpvWXdVQJMrudfMEysyZ/yvNflajHL6ivapmW2eD8dCTt1h+zN/yFyJTbSFRcv/a86i0Fy4e9lo7/DnBzSyp0N5d81B3LbEiAGoSzyD5ktrhfiL2eFrrac2xl+VMSl4vKDoWnua3zUR/u6K1zztwm5hDsN9gxmAYlD3ia
 zu9WIntV
 xy3TzIKCbxiOhxfm7wGVN1A6RNVAtA5DL13AlMtMsF5d3BAq5+MYKb0x8TU02kfOWsnAjHG7c9glK2iLShXKs+j0l4sCCy30/8fEwf5VJt47iP2kcTBn4dayxmlOu5W5uygb7X4HadQ026lJgIEfC7QxmZBxQXcifFfAOMbEAvgImq41A5xndCMJHXbBvKlv0I0nm1w5B03tOfuSW1DZKNp9UZ+oJduv6HcWjJqk46+Q09UZxKG0TO9gnBZwQ3AgqsuJSG+LOUT0gZ3FfPF0OnkWwogH32O9x12gRckAws0AdtH0n5YojUcpB0AHMasI6XXgwzZm7ZTum8GqdgHcDfbnWCHV0U/+CKTA8gw4V4sdwHtKSwFON2uLgAOgJhILNDmdnzBYP9v5Tvi7KD3JCnAuqEDIRAm2/REY+JAeHnQLOKASY+P56rzvclY8EZPV+fdiYaGBRuUlFEmnaZgvqw3GgvSl4D0xqke0omBhf/jqDXAr7tZN/4kIU38bkhT+k/WDR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Oct 2026 14:39:49 +0000 Roman Gushchin <roman.gushchin@linux.dev> wrote:

> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
> > On 10/16/26 02:15, Roman Gushchin wrote:
> >> Yosry Ahmed <yosry@kernel.org> writes:
> >> 
> >>> On Thu, Oct 15, 2026 at 1:38 AM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
[...]
> >>>> I suggest the following sashiko change for linux-mm:
> >>>>
> >>>> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_lists.toml
> >>>> index a9198de..ba123da 100644
> >>>> --- a/projects/linux/mailing_lists.toml
> >>>> +++ b/projects/linux/mailing_lists.toml
> >>>> @@ -46,7 +46,6 @@ ignored_emails = ["patchwork@emeril.freedesktop.org"]
> >>>>  ["linux-integrity@vger.kernel.org"]
> >>>>  ["linux-kernel@vger.kernel.org"]
> >>>>  ["linux-kselftest@vger.kernel.org"]
> >>>> -["linux-mm@kvack.org"]
> >>>>  ["linux-nvme@lists.infradead.org"]
> >>>>  ["linux-omap@vger.kernel.org"]
> >>>>  ["linux-pm@vger.kernel.org"]
> >>>> @@ -315,3 +314,7 @@ reply_to = ["author", "list", "recipients"]
> >>>>
> >>>>  ["fsverity@lists.linux.dev"]
> >>>>  reply_to = ["author", "list", "recipients"]
> >>>> +
> >>>> +["linux-mm@kvack.org"]
> >>>> +reply_to = ["author", "list", "recipients"]
> >>>> +embargo_hours = 24
> >>>>
> >>>>
> >>>> Which means:
> >>>> - Embargo 24h
> >>>> - Mails sent to everybody (author, list, CC list)
> >>>> - No positive-review ("looks great") mails (default)
> >>>> - No other static email addresses that receive a copy (default)
> >>>> - No additional ignored author email addresses (default)
[...]
> https://github.com/sashiko-dev/sashiko/pull/699/ , landed.
> 
> I'll roll it out later today.

Now linux-mm@ and damon@ has slightly different configs.  damon@ has no
embabrgo but send mails to only the author and the mailing list.  It is a
faster but narrower-scoped delivery setup.

I was assuming linux-mm@ side change will not make any change to damon@ side,
but apparently it is not.  DAMON patches Cc linux-mm@, and seems it results in
applying linux-mm@ side setup.  For example, this patch [1] got a sashiko
review, but it was marked as embargo on sashiko.dev.  I found and clicked a
button for releasing it.  It resulted in sending the review mail to all
recipients, not just the author and damon@ mailing list.  Correct me if I'm
wrong.

Could we keep the old behavior for DAMON patches?  For example, let damon@
setup to override linux-mm@ setup for DAMON patches.  After a second thought, I
realize this would be not very simple.  Identifying if a given patch is for
DAMON or not is implicit.  Maybe we could see if the subject contains "damon"
keyword...?  Still not perfect but maybe work for most cases?

For now, I will release damon@ patch reviews as soon as I find.  I don't mind
clicking the button multiple times, but I'm slightly concerned if someone might
be distracted, because DAMON patch review mails will be delivered to not only
the author and damon@ list but all recipients.  Please let me know if that
really distracts you.  Let's find a way if that's the case.

[1] https://lore.kernel.org/20261018220253.158238-1-sj@kernel.org/


Thanks,
SJ

[...]

