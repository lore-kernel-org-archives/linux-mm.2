Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62AE9CA0EDC
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EE5A6B0095; Sun, 17 Aug 2025 22:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F4D6B0096; Sun, 17 Aug 2025 22:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DBD16B0098; Sun, 17 Aug 2025 22:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 280C86B0095
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:05:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97AAC16072A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:05:26 +0000 (UTC)
X-FDA: 83788236252.04.81908A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C96991C0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:05:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wncmtFwz;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755482725; a=rsa-sha256;
	cv=none;
	b=i2LhuJ3/yZlKCseA7mKuVsZtDGUxOiPZR5bkmsxxgWin2NYoDzzH/QzdfTZ9AioO+8sMbI
	JmiZH6ec5Ul33JE4iCvelb/XluDEE8aEVQuxCvWv3IHRFaX7Z/bSX6g332l7W6Vsn+jin5
	PmxjjyFyELysKgsSmAgI7moAjBIPKzg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wncmtFwz;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755482725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9rkSUgk6pu7Zmpdu1849pi+uvwsak7OxrlbRxOhAdmE=;
	b=cX9xDZ+ZJghR+VroPgONY8SyufJ0i1sKFXSO0M/Nr5t93BlB0lVGcoYf/RbWSaG0Ey0svh
	EudFVEgmbN7ki2VMumYEbMqU/rTND9VpxiqkRld1XpbySKtc7TA1WOeSQ+KvQ69FzMhFdo
	Lfjd76Zcdj1Tc/U9KMNPeexcl/xf+TY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B36F44B0D;
	Mon, 18 Aug 2025 02:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37AEC4CEEB;
	Mon, 18 Aug 2025 02:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755482723;
	bh=sCitdFsgMabtdBW+wAaC7f3MIZ/jaGkRaCjSsZy6Ohg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wncmtFwzI8x96VfDWTnKm2xg324AlqXyEB1vrDUxJI6o0VODK5YpvBa7jv055Leuf
	 JHFGmv2Xicc6MreGEVA5XvScqw+QGe83GjWRIQN50JsMVi1THhUpm2QY7D/IC6slqF
	 kTtG8kjg9ATZ0bWwUeixKr8Wx92eiUg8eMM6Wumc=
Date: Sun, 17 Aug 2025 19:05:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@redhat.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [Patch v2 1/2] selftests/mm: put general ksm operation into
 vm_util
Message-Id: <20250817190522.399e2ef126b816b72082948c@linux-foundation.org>
In-Reply-To: <20250816085753.n2zxaxilg5ghcljd@master>
References: <20250726025223.350-1-richard.weiyang@gmail.com>
	<20250726025223.350-2-richard.weiyang@gmail.com>
	<20250815064717.hlkehch75t6blj6e@master>
	<20250816001811.7f85b64fe8c748dcd6d47c27@linux-foundation.org>
	<20250816085753.n2zxaxilg5ghcljd@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C96991C0003
X-Stat-Signature: f8ut98rxzsias3fwjrtrwa69ucpnzt3y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755482724-433084
X-HE-Meta: U2FsdGVkX1/cgOzlBDmcGPCWx7KUmcSL+nrdwFGPngTo5U0YJy0t9lfe0h2Ky+TL9gC/hZQAqZuXODPORX+ph5SKTGcCX2e8VHw25vd8DPdOoJWRPdd2guw1BSQ+oWXDNRZlvzCei/tt+Jf79ImN3KeWw0mb5VHvTFiChFWU5yrbbesmgF/8ZqhW4olfWMJgMIU658M4Ntz/60Ipd5zLrY5ArymtXhI11+qt4ocHHU57I8JOplo/z+bIc8eWmbbH/rp80xtwq7O4XEuBKIfZAF5TpwaTrwVLYdQA4gWAffYa6zfIr+POEOwlsu0xpoPXMbnqFYxERntRbXxIHseTPDeExZTCNNmmDOt16laPYh12RwlxNVDxUMb0mrIV0zh4bGNWthDlVH0v58SywAqbMYVtDDb280WU56XnQka1EyeR9WRIPuJSuaw3BSe5oFtjCaijl0IAskOuntJdLRGi49BRJm/4aJMOYHOiOpAmmfUR2JLZSXFmjvdRiH9sYygfm7p4GLa2P1u3kRidJT5anFbocKANes98rcEdij+lbSJUmB6yfaryMn+jSTtHvD7ipWPrBuzIToHIF79oT6b/RzwlxCyF3wHxQrHuIfd/LVFMprgLB8uCPy2ozYFsn/HRTd/568quPYOYrukQ1lnPyBl4LGDKTG06/dWQpXeE1qTrkgXdy+CLi3dTDjVpKuB22h5M/pHAeUkHIu2qFzGl5ROcW6WqxjQ3LkYKbPvNcO9K4u3e8oUtugwE9heYIgqyyftBQnp7Wps5dhI3nQyIsI9MI6s+6hJySwnz6XJWQ97StDnb4+/twCvJ0xsZq8EhmkAt7eTU4JPn2tq0SyEW2cqcVCi01CHBaDoOM07BdNq1k1LDFdAII0GGbCm6dQ3XnTtUXv+D2wEn07clERf/YjQ5LQgBAWOVyZVOlU5510D5ACa6BGs+0SMIbMbovhRAGKhJHRHkQ/zsggcICyN
 hi3Z0m9A
 t2ryFIZC1qyZlVEVVJSshgQNW475spYy81RSXP/FY0J5vPizQ4MkZAgsabWp2e7wFMMs5d1rX1pThgoT/9Rmp6E5sRZOJn1uwHK9qeH8b2X+gMivGeiqoVZ5s/W8g51+5XL3mLZwLJcwwFSnTMo/EREPzYNsiXTE1lFMXJvNzMOEjXD45/BAkXZ8jKMkydB/+VJDRYgfPJD96RC4g6spWr2kdi3ww3z8bDeT0Uyq1KTYKW5XXFIHUeyK6i+NCUTlRd+TpWFMcGgGWg3VznPxBm1AEgMYUcjp3RWy35ccAy9mG9f8HlKDEZyZo5J5Gnprtf1ZKMY72x/fKv6rC9tH+myTDkIn9x9WyIZqYutZQxb9L3+OBEqhPVT63CePgNSULRGOEiVgVPfRJZpV4q/FZit9JZrRL4GsiEn/Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 16 Aug 2025 08:57:53 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> On Sat, Aug 16, 2025 at 12:18:11AM -0700, Andrew Morton wrote:
> >On Fri, 15 Aug 2025 06:47:17 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
> >
> >> Ping...
> >
> >Pong.  https://lkml.kernel.org/r/20250728020930.w7sv5eccp4kcizts@master
> >indicates that we're awaiting v2?
> 
> That is a trivial error handling issue. I just want to point it out ahead and
> wait for other comments.
> 
> In case this is misleading, I am sorry for that.
> 
> If a v3 is preferred, I will resend it.

Now is a good time to fix and resend, please.

And it's a few weeks old, so perhaps a redo will attract some reviews
this time.


