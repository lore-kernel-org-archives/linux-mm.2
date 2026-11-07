Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A16A606A332
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 13:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JUS/oqay
Received: by kanga.kvack.org (Postfix)
	id 85A4C6B05B0; Sat,  7 Nov 2026 08:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80AAF6B05B1; Sat,  7 Nov 2026 08:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F9B96B05B2; Sat,  7 Nov 2026 08:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4213A6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 08:12:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C2D31C37E7
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:12:49 +0000 (UTC)
X-FDA: 85408362858.21.F6DFFC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 64FB61C000C
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 13:12:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JUS/oqay";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794057167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQ5mfxv7UGgbtsfCEUxK8ReBmH/PIdEtaJHCFZGwPmA=;
	b=4xJdnjd3HK9O58o7wYV4Yz6hnwenwlyWstySqoDJ0thuGX2B4aGTH656NGwNDnwMdFzOU/
	ld2djzGXv4ysOmAdABJVp+/WYSvlGvN75rucpSK+rtEKkBGJVRSypUQPH9yjul2a9ykUWW
	QcR5sRsO+VNKAcZ4K5TpcraoSBqifZE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794057167;
	b=HNmrahLtT1i2OLS0aqnFiRjxfLup1V53nUfiJWvgac6E7TIpQ8BUmLZuaGmLdkG/klmVL4
	9pcMJTJQuibZshnpONLP1xkftQc+RdiiQASQWIxN3I3QPmvZEr89EWbm2R5ypXrlIVmGny
	olAl2xyHEJae2fLNM8Z5Mzu2YNYvnsk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JUS/oqay";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5970F41AD4;
	Sat,  7 Nov 2026 13:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145861F008A1;
	Sat,  7 Nov 2026 13:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794057166;
	bh=CQ5mfxv7UGgbtsfCEUxK8ReBmH/PIdEtaJHCFZGwPmA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JUS/oqaySD8cio8i1WThawooJC6rRvaqc0iBBqZkJRZoFctClT4hjpL9J4h1ktQPp
	 vea7BwYjtqdGF+qJV/XdL8YfRUye33ufwZvYtli83Lb3GCIxg9ZMPJJnwHmsCQMMKn
	 Ddh7wtj/Buear6TmdR3WMDmeq7DB6xy9W0UTCzUmxfsi+cRmI/NKjRN+Z+GY7s663F
	 C3iepRVCfS//c9ud1HQO9XezYIqTQCoi578Y4/xnn0uf0RsqMz/7YWEd7FycBV+EcS
	 HWg5jE/bwqsolX6UWAkhTzpDwnRHvN4cPJnYiEvMgwyV8IIJK90ZP5WjO9fT3leUY6
	 K+WgkbTlsOGQQ==
Message-ID: <6525d30b-6de8-4b3f-a79e-fafc6b1cc9dd@kernel.org>
Date: Sat, 7 Nov 2026 14:12:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: add CONFIG_DEBUG_FS to the config fragment
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261105171801.2189772-1-sashal@kernel.org>
 <179397467526.9397.17872200045070830000.b4-ty@b4>
 <20261106185218.1766376-1-sashal@kernel.org>
 <8fdcef66-3130-4c90-aecb-050ae624f42c@kernel.org> <au8cno0UHsD_Fxp3@laps>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <au8cno0UHsD_Fxp3@laps>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: f5ymusm8383a1nduwbpxfokcqmuymwag
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 64FB61C000C
X-Rspam-User: 
X-HE-Tag: 1794057167-516009
X-HE-Meta: U2FsdGVkX19bmpjITsy7FL5qF6hg+wERZh/PbnVQGl1AmsJkOc3/Hj7vS7nRVAML77h0guT5zBlh9KI/rj9nXXZJLngcYCNAnHzbO2mqBhQlCMek91i3iaMjHUVETNjyeDxdX5g7lx++HkcGQVAm0M8QPOyVvFpQ1T3WLlVLmdIYvKtbCSAneII9AUYMQvsR+9S3JnCTcbnbcAwothYP7g0nx9hj+SNVK0/6sXtp6kSQuEvWkJ56rlKpdjoDY2PjuEkIFCXM1gVZh8IXCqSoRCpxOhd3HmuJRD8n9GcK+vcX3zfMRNjgnWQPR2XU+edQTE8xgEw/7XK/AVSwcALaVcDowVu3hXiP+rv7GPMCA4k+Fz6uJgRqRav0lvT78O1jxPn9oCKjFf1yVoPI4doiAJgfC15t1sEnONatiK+CIYjKvElGfbvMxCf/yzEhZSmm9sqwhHDpOhab3RZ+UVvW3j4z7fg07z1+VReqQGyUKqwgFyirhDtdw4QGnI+HxdHvBr93NbXHhMA6eRrziVYdPlJaoevhHgMe3m//4J8HaFR0V0eFgqRN5zu+bX44dGvV+dgFYKNhan7sSdrAJ+XqwDjN6ZXw/HD7rrHtiTSTKfHFPOAxvfQ9hc1P5X9m1uwieHCyXMu1wOoSRIUkje4dDPLkgOKuzBK1tR0+1t4mh7xds8UYzbKDMuBx14gju6RklDkmkBsXXw8KWG+Lgt6I368xX9JPy39NCjs4go5YUP0ziwSqWLwoyFgcJ6IHVAiev+HG2G9WPEpUOBb1m5GobJcmA+oBBKCiGJnY/5j/zDmstcGeA+/oQWiSkXXelaWm6MOvigFsOQxZ2QsW5vLo/Fd+HRWr3PgBVC7KI7JdsjrfauOyySIWip/MJR06D0YKmN9PS2tcdIlxZg3vPoCTGtd/5UjllZxpFtjrzuXODwa6Bm9MvHyAB6cLcxLMNysOlcCtQtMQkLqisLLaznm
 /OmTC0iA
 ZUa9IK2Yu2HvGQOmzFUKx/IS+hd69LPyV/6FgKTAIc02SeNN8z02dVio8t+LpXJtftCREC3FtIufmUgXp4QOftHMzoG+ZBpE0qvnatKoAloqBbweLf2tjw9Bf/aNLszYB1Y6CLPxlVhUNq0LabxWV234CZJ/u2zCeau/BZQMVOukU3Ykz15fCXEktdpDuOU+Fnbq8dGoPcuvSupRqyUoroDysdNvvwpe+CtNwumXGdbxceOtEjyYZ7l0fK5AQxTi8HHAp4B5JJvWM62Viol+HXffpwpuKqCLMXwIuEDfjICkvNhc6/FxBNw9fL0x1OjX646bvh7uMGBdASB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 13:42, Sasha Levin wrote:
> On Fri, Nov 06, 2026 at 10:32:27PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/6/26 19:52, Sasha Levin wrote:
>>>
>>> Thanks! It looks like this one landed on both thp-7.5.misc and
>>> core-7.5.misc:
>>>
>>>   31ea5515bf59 ("selftests/mm: add CONFIG_DEBUG_FS to the config fragment")
>>>   194b63198811 ("selftests/mm: add CONFIG_DEBUG_FS to the config fragment")
>>>
>>> Was the thp-7.5.misc one meant to be the split_huge_page_test skip patch?
>>>
>>>   https://lore.kernel.org/all/20261105030242.1241448-1-sashal@kernel.org/
>>
>> Fixes.
>>
>> b4 shazam gets confused when patches are sent in reply to patches.
>>
>> Which is why we shouldn't do it ;)
> 
> Remember my gripe about how subsystems are starting to have more and more
> custom rules around process? :p

Let's not twist my words. I said "we shouldn't do it", there are no rules around
it and also I don't want any rules around that.

And the example below (bug vs. bug report) makes perfect sense.

> 
> Our docs currently say (Documentation/process/submitting-patches.rst):
> 
> 	Explicit In-Reply-To headers
> 	----------------------------
> 
> 	It can be helpful to manually add In-Reply-To: headers to a patch
> 	(e.g., when using ``git send-email``) to associate the patch with
> 	previous relevant discussion, e.g. to link a bug fix to the email with
> 	the bug report.
> 
> I suppose it's okay for parts of the kernel to deviate from the "standard", but
> it's a bit hard to keep track of these preferences.

Just to be clear, patch in reply to patch to me is something different than
patch in reply to discussion.

People tend to ignore certain patches because it's not relevant for them;
burying something related but more generic in there is not always the best idea.

But it all doesn't matter, because there are not any such strict rules and I
just have to learn to properly use b4 :P

-- 
Cheers,

David

