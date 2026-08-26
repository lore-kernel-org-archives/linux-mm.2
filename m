Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02527C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC83E6B0088; Wed, 26 Aug 2026 08:52:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78A36B008A; Wed, 26 Aug 2026 08:52:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68636B008C; Wed, 26 Aug 2026 08:52:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 801FF6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:52:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BDFD160370
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:52:36 +0000 (UTC)
X-FDA: 85143409512.25.5EE8DF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 643BC20009
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:52:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ce7ENld0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787748754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZRrc6y5To8D21KDibYndEDQcpp0k23gYz0wKlA9weEE=;
	b=VZWE4+dNHVwCK7wJXYKPxw7hTBUyr8IgMJkwvEXK/qW5gcNMtft64ptlPW22KmKpgMuFWL
	zGccmBhLvLsGujQ51O2znkGesGgBVMLynOq8KITctnP4mqWQU1e0y2/e2x17dn4XYAG6V2
	tJpWKhrgXmk8GJwqp+30OzAMholxRWg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ce7ENld0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787748754;
	b=QAlqAKSNxDWfm8J6T5QYrRoIaP9bu6qIDjvdSHlzd218ZWxqK30B2IKGO+XMinHjYG5e0P
	ukFoyFkuDdw5SE4QlTLj9BXzLaPjO1zS+Sz/Mt9ECTm+jz6U8xXBPUdGiqmRNyQttrSys1
	9uI9CltwCMtYJWgLyMYXPnqfnf38TKk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A75466011F;
	Wed, 26 Aug 2026 12:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1BE1F000E9;
	Wed, 26 Aug 2026 12:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787748753;
	bh=ZRrc6y5To8D21KDibYndEDQcpp0k23gYz0wKlA9weEE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ce7ENld0osegSbAU+SmlEQhyoYlhfrZH0wRQfCMWwbfYHvGhv221rdGo7MLd9BLLz
	 IO+SCg5alPxCPqZF/snZuuofMI0ypsbzfnvnm+3Pkulrn6sd+0hYDHdFEswCHfpRin
	 CetrNiYcoEzrMydhY0ZM3GvABLh3HUlx5RQhTBFPm2ZhNRfD3HCVp2nFUT0WvDjGz5
	 FGPfNU41O2ehUrdyUqHUHVSu149K9D/pva6YSqpnzTeJ3HuAhvMSqb8Ndb/hG0RSH/
	 PNyg1m3gy8pZf14jc3MaQOXYBBgDmBGJIzwcOyJLi7ckv6cM4PXq9r3TjPUEaaEtDg
	 BcjGCu5c2FrUg==
Message-ID: <adf90329-020f-4a2a-bac5-fe815b692a7d@kernel.org>
Date: Wed, 26 Aug 2026 14:52:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
To: Kiryl Shutsemau <kirill@shutemov.name>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
 <ao7S-wjzcMIgM3s-@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ao7S-wjzcMIgM3s-@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 643BC20009
X-Stat-Signature: w6u7dc6xcmem8ewmatyetox335e1gxb1
X-Rspam-User: 
X-HE-Tag: 1787748754-425201
X-HE-Meta: U2FsdGVkX1+ocZ1q+jQ2WuwwFVdWvK0zuj3PdOSfSlTZKD7T/fzPi183yPR15rIBXroXb27sjVwk2Fm+R004+HxZQGzEx95JUg2jTSh6KGc21sOVV+JAzTi+o5NweIw17pEEeCz4VzPp+CTXRZODvbDKivXAbK61thFxzIw+6eDbzMWHbP7DfwTJZV2EZDcX4cXnxtXloHc5+PnKJsgO173daaDfiqPVyHQHJlNMEmuT821JKFVxvXjShEdp+dmI4Tc+EwndxKHJGbFPrahkdPbPliXbGChnXbp/2dRKJicWM4eA94MKInNlb1PvBEMpkcPIj3XvZKlp8u9cqjtpNIwyUpAligXW9SOS+4IXNYJj3g+l7TnCS/cG9lHOEhfnzChlNiThun38QUUFmBVnluU/zgLn+ntVLqCNB7rSMXvI6q+sHGN6aU/A7Y3Krqp1N31IERn5CWxj3OkMLcsI7n8q+pq9Olk2IZdJH44uiLiR07uFvDKu5/1uy6cxdd5VBrkbvAs8IYpWCk2uRS5NaO6RiXst8ZjqKAo2BgvGkO/O4qG1rMmyQNPr2Yj7pUdyG5Vwx+/hCyou20CXsjNBxKxiLNBEZR4HKr2haRrcCZd7ZA3gq+BIfz48yHjGn4zpIby8sn0OlT0A7hNY/IwvMY9iDvTePahnK6PbU3VHxYFWWM7/tMlBShw2HocoJdbAu2MJ1xnU7IZh/6VySbjh79mWyr0dKltjfXajjnT1TeNhjq4LfdTyeXgyY++1lar+pbJgzXWtQsiy+vSn5Fs0LY2Q66EcZ9ODmsCbxVDLL1aXokoXcsCJOHIBM8l1BVr0/BcPDpIsuexIUoyjdziUSO3cqTFZu/khGq1ohtsDd3DT4/5KloqpZonNh2BrvDke8WsZPF4qTRj7UBalaF3KV7i+QuAGwcM7eMrdCIopdXRBthN8JZTaYEyJ/FeGEtGp+19Yx59v8fplT4S5UyJ
 E2rUfh/o
 98PAUQ66gK++koWJTF7DpzTUgv/OYXhIJUVX6JEBePV7z4V2tXEdn+Yge68RdzUPh/4s1mrX86rtJdPOFi4SQYjSFsIzwO2NOQviTxzLB4vRbLngteqhF7XBNVJ/Y9b/DpVDEbCK07Dd/ilPaCIbf0lbTdVB8xae5hgk6JgZ8dmZ2/7oh9e1QFC0FhYSyAMxmuXu8CVtzX3BosdcPqurgPs6iwrEyLeZHJAcRF9xSS9qdT2A+aFmMd6TWLQKBo04cSPOm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 14:04, Kiryl Shutsemau wrote:
> On Wed, Aug 26, 2026 at 10:56:39AM +0100, Lorenzo Stoakes (ARM) wrote:
>> Unfortunately my workload is such that I simply no longer have the time to
>> give THP the focus that it deserves.
> 
> Ouch.
> 
> I guess my 57-patch series did help the situation :/ Sorry about that.
> 
> It would be only fair if I share review load for THP. I will try to be
> more active on review.
> 
> David, I can send patch if you are interested in my R:. I know thing or
> two about THP and can be useful there.

Yes, please! :)

-- 
Cheers,

David

