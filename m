Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C77AC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:25:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466AB6B018D; Tue, 18 Aug 2026 10:25:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4172E6B0191; Tue, 18 Aug 2026 10:25:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357FB6B07B5; Tue, 18 Aug 2026 10:25:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 165706B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:25:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96F94C02BE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:25:10 +0000 (UTC)
X-FDA: 85114612380.22.2F1B907
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf27.hostedemail.com (Postfix) with ESMTP id CBF6440004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:25:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787063108;
	b=MHauh7hUTEPYtHoTUh26uNC63XfjyK/M5WpEQj33BV3NL1/Cs2j83SWo/0o2td4DxBT78b
	ngXZJSoNHncIw0ncL/VtLvNS9nzZwasLvPQCWHxntr3IHQ9Bar1x776OHFj2Ii8X/tOqQH
	sAKvuZnxyjHqZQUQLsJTLt/huiDF8qw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787063108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5/rGVzlBcnqQpnTv5+IlQUiwRUmnA0eNZNFu07RT0g=;
	b=BkwgclC2WEY0xF3w26evIn7i7C/CJu6CJCy0vjrKO5sV5O2lh75xBsiozUazV8UdYDEDYy
	VTG4f2RBS0rDVxnQN12CwjDJ9QpDZFdRUc6PRLiKkqEt4cmWI1k1/LdXhqvKCBsbVxH3Ps
	64s6h37+L+uglsv8YmhWv2ONiBE50d4=
Received: from omf09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47FB1160279;
	Tue, 18 Aug 2026 14:25:07 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id 1F44720028;
	Tue, 18 Aug 2026 14:25:04 +0000 (UTC)
Date: Tue, 18 Aug 2026 10:24:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: =?UTF-8?B?6auY57+U?= <gaoxiang17@xiaomi.com>
Cc: Xiang Gao <gxxa03070307@gmail.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lorenzo Stoakes <ljs@kernel.org>, gao xu <gaoxu2@honor.com>,
 =?UTF-8?B?5Y2w6Zev?= <yinchuang1@xiaomi.com>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [External Mail]Re: [RFC] tracing: aggregate ring-buffer usage
 statistics
Message-ID: <20260818102456.03f52b8f@robin>
In-Reply-To: <11242d2e40eb4fd4b439ac66ebbe26ed@xiaomi.com>
References: <20260811114818.1449933-1-gaoxiang17@xiaomi.com>
	<20260811100830.7976bbe8@gandalf.local.home>
	<cd441eb194d54265b1bf9ab659716c45@xiaomi.com>
	<20260812114704.2f61bc5a@gandalf.local.home>
	<d5bb28119dbb4ff1ab1059bb2564ad29@xiaomi.com>
	<0e42953988164786aafe175ef0f4e745@xiaomi.com>
	<11242d2e40eb4fd4b439ac66ebbe26ed@xiaomi.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18HcnJ66CNnHw+pNMNxXyVfBT9aUSk6dI0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=E5/rGVzlBcnqQpnTv5+IlQUiwRUmnA0eNZNFu07RT0g=; b=pcx/LIHkxu0dCkt1AI/WVyNjJ8VXYVGo8ykVn0ey5hjtthg0MkTrRYIH6uDDJxQcoX8FfbLii8T3kNJApi2+JJDryyNgmzE6iLw04cI5g/aVEtAFiOampkXLAHPHxiBnPtoJTFFrEvE3MKj7FZTw9z3dppi19WMOIKdaVh7TG4s=
X-HE-Meta: U2FsdGVkX19kUE2e7JTYzjcyI5IvKIsVRELHE9ewQ+N343pZipCABDOGQz64cQSxwJ4o2fcR6NWOhHoFj+3b6ozab+17Hu8SayjboJSOAnWDSqwUmxkwycjgHBKUCFaRikeY10PNzAW018wJCNoXbtC5G12ud8WH86ZNmPz0WCU8O/7pkqTg1ZGo3d21/aj1z0hDx0vfnzZZo660/+kjgoaAxJrlJsXY3NNWaH10bv+fRBHuPtNrSAxKqPRiKK9xlswp41YH6jaSDj0fbITYLx2adfbbA1Pr7CVj5/L3nEknweLaIWByM38VU+B0m2h4xj6ejmIULnwi+hlvWu1piRLGLb0T0Bwa
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CBF6440004
X-Stat-Signature: 9zprk6udzdaksuhwujqxs1tos18bd7xf
X-HE-Tag-Orig: 1787063104-385141
X-HE-Tag: 1787063108-534809
X-HE-Meta: U2FsdGVkX1+0Q0ss2KIx2r5H3GJgi6asOZR+Z5F4QzZXmYheAuBQ/noW2DZBdO60S8EJy834Rf2XR7yB3Fw4m6IhImbQZIK6eKZq08P5puqxrTVfL3wj6570qbQThRfp6iCljG9lRlGxHm+JbByZWXFqb5Iute8kGPCoaPiuA1ncoJlRvpFhr1ARE5e4XsZ7lm/reaHLYjgvwzUIoWf6se4BfRPNPpTp2bxfukI64tPaakMN5qHYtpy3S4+yp3n7DPCPskmgYecfA2+rortmpHkTH/fdMaFpcNUhsRqDyToJFc7zKstSmmoRDFb460Ulg2Kk8meLn+KSqC3hDBgq0QshHUBgXjZjw+jNmYBvnqdv5/+UW+Y3ktVu7xt+vOOLRXIivlX/LWoaW9eH7kXAzVXk5NECxx3r4O6owl4d8XNWI960TSAKq0JweoFhntqpjcVtvKrXb5xdoqLQYT+iL1OzM7LT2m+eZggu7RhKvzDY+pJTmB60KuhtK6JxF/ffF/JVCJX3YKx+E8+hW/cKcdNuWegpeLq1aVBbBXiTAKA/GAhkdvL7y9beBMoT7JoydfTkqq27t/9S0TA2dW+tnUsXfFrII0ecTqDiZwh4ZCz29Du+95SQzGNHo/dVp3QBe8bVUgcDdXD0uo1oYuTj93IbVNKjYvRvThOPG/uzlVmwPlf+9Xm37B3tdFHDhkJ5ffCDifXdEOFt0+1jfKBJgVKPKG1LlsZhc3+yHxbAmeOATe3FdS1R/kiVUeEdGGzezDIHPPA0c4KWHWsKWYRaCBWlPxpLVx6H/NEFhohkh2iFjgLhoB2xwJHindADkExKus1n3fVlb7naT8gjVvE7vTvOheAklOEQYx6bDumSN5LxpJ9nfjWC5B92jrcVbBHbyyBFr/edkD7OeOil++8zOXrD0f4I1YN7kmHHRp0t24fSJD+79uv/V9QDxNIzrxj3Om59fKZH/Vs5zcTN9Fe
 ulSKyUnZ
 xoo2Vcrmmme1K6Ze5ejOPFhmd68jkxy43Fee+aBWqntulMcTetSp1baJd2M7w3OSV68yHNalBhO0kH44aWZvuroKIrg7A7LHDiaJlBKgcBUwsFx1nv8bl67LlVPDnRy1uxJXebF68JuGvJ+8MUBNs8rj5w6vyE2kl+Kz1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 13:30:26 +0000
=E9=AB=98=E7=BF=94 <gaoxiang17@xiaomi.com> wrote:

> Hi Steve,
>=20
>=20
> Just a gentle ping. I have the RFC patch ready for
> trace_stats/total_memory_kb, with the buffers_mem and
> snapshot_buffers_mem breakdown.
>=20
>=20
> Would you prefer I post the RFC patch for review, or is there anything
> you would like to clarify about the accounting scope first?

I'm traveling this week. Can you send another RFC next week.

Thanks,

-- Steve

