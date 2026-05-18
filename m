Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFFF8CD4F49
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C58D6B0005; Mon, 18 May 2026 04:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3767B6B0088; Mon, 18 May 2026 04:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2652F6B008C; Mon, 18 May 2026 04:24:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15C536B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:24:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF5AFA089E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:24:34 +0000 (UTC)
X-FDA: 84779854068.15.DEDDAE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3361540009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:24:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GNf23WV0;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779092673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxxA8OAwNz2aOXj4DGnG0KiImL1QPG0K90ekgA/nwuM=;
	b=Ul4LtqvCcE9eTeA51x2vOF+mg3h6wTit/mac2F8gvsAie9YUFgawSntxVB5h9A1HZWEeYN
	0CF1FxXTphV9R0PS7y5WkgHAyOxPaCg7k/Dpn78Pt6LeqwVEdgup/Pvrsc46cgl0AGxHH+
	TYRQNHwJgPAJLQqLTFUxxnUS13SC2v4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GNf23WV0;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779092673; a=rsa-sha256;
	cv=none;
	b=44AWCQA4CvgCrnIdnhPD5wyJp53aFHJkEgqP57ioMikOUKe8eNRzsHoSgAfADI6ieIkFNb
	OMtjPyq1NvgkUX1aOZIYiMkmdNYt/rJHyzbeMwkNJ4bOOJCEb70bFPSSyB3ryKp4KTnjYm
	C9BqyOv1xs+Hc5lOzOlUJkTYFJpvcSg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81BB660055;
	Mon, 18 May 2026 08:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE34C2BCC6;
	Mon, 18 May 2026 08:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779092672;
	bh=dP02SKNit0+Jm7JhPU/U/F270rPRC3qrNHHL6WhTXKM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GNf23WV0JvPZwY2QElh33775c5c7VrdM0vLY6vGAqD/IBOzeeqkNLn37QCi/smmNP
	 rx8j9UJnzdJ+dlb8eGgw3Vi+Kq5Lq2tMGA0Np2pJ1eT7+5/iij2ErPyEgCLybG0//v
	 JOa7f9DWs5x+gfU3Y0IaIS823SZlaaXJP7Wu5+kF2xZXyg6QMPRDM9fBeP+euwqGfq
	 +ssstIRq9JZFl+KS8weZjpdJxjdc5ihfGa1qrIsJk80GbPGT0furHR7YZ9KnsmLQM3
	 njhWi6y8s4Pqrrq5/O1aDN4HqOEMSyh2ysuqUTdOhN04+m2tw5K/GwUoKYOxILAGy7
	 JFoiEGxYQDLFA==
Message-ID: <cf552999-0b17-4abf-889e-2400c28628a9@kernel.org>
Date: Mon, 18 May 2026 10:24:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: restrict zero-page remapping to underused THP splits
To: Lance Yang <lance.yang@linux.dev>, npache@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, yuzhao@google.com,
 usamaarif642@gmail.com, baohua@kernel.org, dev.jain@arm.com,
 ryan.roberts@arm.com, liam@infradead.org, baolin.wang@linux.alibaba.com,
 ziy@nvidia.com, ljs@kernel.org, akpm@linux-foundation.org
References: <f2f218fe-a14b-4714-9893-465a4edb4570@kernel.org>
 <20260514081130.7199-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260514081130.7199-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: junruuwesufwq1hgzm7rxk8t8u7h4xq4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3361540009
X-Rspam-User: 
X-HE-Tag: 1779092672-485815
X-HE-Meta: U2FsdGVkX19sMcJDeJGWNOEvvUUP9l5hR3Lgd2LnenTDoeoodDFgAxrfd8Tj7PN4mixu1PDuDhpRSNIapDbOStDZWuIzaRYRqC00bmMTvfXRme/Xr+IquwIwYu6qSoisfn84YkTY3mF/tLqH6r+rWh0SA7xucEGN4g7UM/zPPddIKnv1Sx0TIwf9QMxBTwhMA6ca+OSqZ4BcUDcKR90mAclyX2FYtUXEh7qtPiGhjOxn8QCNXCOKHLjukG/Z718AuKjS7bRbuJW8R0CtzHQ3oDsT9z5Bz7rGVrBCwdge7G8lCTVIw9c+Ztwmd7HI1rxKJoZmVsxKCAEA6tj7TFjhKSpCteFHIAbfh35okXlD2qc/VbYMTdDjA3iNZS3HsSKPDJTtWW9OMxbph3QlXP3qu/pUGLr7NoN3WKNh+S53uuHMLA0wu3kzeOs6wlFpi+str/IVP/O3IHkLKJsoei5YecPlTYAqBWzzgzPhp51SDqmzPxt8AlPVbuIvQKT434l6dkEWZhRyvvmiZhO6d315LA+vF9t5gW6izYQe9l+YTZQsT0Vk5gISNLPsrSJR8ipDvcN7amYgj6V6NY3Mor69pCH5rxXrUsQXaIJbfbLYZ7sKECOpyDTujU/EP5fOlApxuY+xQltsocZdaPK0jxPjyoxfSOdgc3mYjHw08f/w12YXPqyTmrbFqI1369IBiLvTvXFEq2NH2IgjOERNeQdD/EDU821SurWuK4fm84mXEKs68XkrFNNwrxZO46cTNX8As8lhtftBiTdrXJXGGt4TjMXM4Mg8Xa7N+yl6cjmfELPgbpGxRZi5rCwchxVqu+mp9JhhbvqeqNvfpnpneJxDk6Erhv9KrAiHUBX3C5N72wnX5nbnoWveC3nh5vVzNACKzKyloPZtDjuigXvyJlFzM62LWHpKPU/oo573TNZ8XnMPOroi5JlXkuKQ6Ppgz8+6lOH39FTZ05E+Zp7Ww0N
 GzMo39vH
 qYXBER3dq1dgixHix/h5MDhihC2z0xxUW9QwK0PLWkbLA2VbMXvos1KDCQ1XV0qDq3ufgbXlav6u0cYpqQbSuwnotC1Y60b9qyQeNlGoM3G3t/8n4pD8SbeuwprhUXN6/tspG8kAQCdOwsib0Y/1actuHM18XrXYurCNBhCOFIb3ii/C8PW3s2DtXOYw2+QgpAyhp8NfVmvPJBCXZfKKyqlWTisg0zc3QHoqLYIUrpsOZHxgo1ctrzksvnGD7DubP1IlogMfaoHUNI3JABerbicZJkjb05/sAAwNcvG72RshcusO8ncoMvDOgKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/14/26 10:11, Lance Yang wrote:
> 
> On Tue, May 12, 2026 at 09:02:38PM +0200, David Hildenbrand (Arm) wrote:
>> On 5/12/26 20:36, Nico Pache wrote:
>>> On Tue, May 12, 2026 at 1:05 AM David Hildenbrand (Arm)
>>> <david@kernel.org> wrote:
>>>
>>> I meant before b1f202060afe ("mm: remap unused subpages to shared
>>> zeropage when splitting isolated thp"). Sorry, I should have been more
>>> specific.
>>>
>>> As in before the underutilized shrinker (and commit b1f202060afe), we
>>> had the exact problem you describe above and no way to handle it.
>>> Correct?
>>
>> Right. That's why the underused shrinker was added, to directly free pages that
>> have been over-allocated with a THP, but are actually never "used" (remain zero).
>>
>>>
>>> I guess at reclaim THPs would be split and we would swap out a zero filled page?
>> We don't necessarily split during swapout, we try to swap out the THP if
>> supported. But yes, that can happen.
>>
>> I'm more thinking about other reasons to split a THP (e.g., migration, partial
>> MADV_PAGEOUT/MADV_COLD/MADV_FREE), where the behavior would be changed.
> 
> Yeah. Today any successful anon split gets TTU_USE_SHARED_ZEROPAGE. Would
> it be better to make KSM opt out, so other split paths keep the behavior
> they have today?
> 
> That way we do not have to worry about changing anything else at the
> same time :D

This is (1) here:

https://lore.kernel.org/all/04ea0e68-de56-49c4-8c9f-1734139d5e7f@kernel.org/

There will still be interaction between both mechanisms. So I'd prefer that in
VM_MERGEABLE sections with KSM enabled, only KSM would take care of deduplicating.

-- 
Cheers,

David

