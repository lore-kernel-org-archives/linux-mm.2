Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA417D6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E15F6B0089; Thu, 18 Dec 2025 08:20:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564646B008A; Thu, 18 Dec 2025 08:20:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46FF46B008C; Thu, 18 Dec 2025 08:20:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 349D76B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:20:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0620A140153
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:20:29 +0000 (UTC)
X-FDA: 84232650978.09.272645B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id DA67680013
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:20:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766064027; a=rsa-sha256;
	cv=none;
	b=lWr/cdWSba0Vjg6Ij1Kg9LAXDYoPLkN21L4Q0J6NNsqUXnsXXrkBNiY7NIIqK9W7uANfww
	0lv3jc7MOcxMVETGkj4W6vvC5694dlUIoxGDvqXhn8M3Hg+zIbgfXhb/ribPYuxFnrKq1A
	JXFwJYysXVR9bjOF0K/xqJgWhU2vJco=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766064027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v4yndrISFtkx47Swp3d9Du198Lt25mkPyu4bhD0CsiU=;
	b=que1Q2notGfxjBanF6vdF8TmESRmRs7dIWpW2C7+ZdAJ0stDOhO60UzQaV5t7VMTqMaLh3
	81FIIp7bGBsixx62O45ULT0TjS6j1nrUC+T01nttp1djsHovEe2fe02dZJHGzXHPNDZOpf
	L1nxMkOdbGkTdGx40LLFaLuI++mi8OE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DD0EFEC;
	Thu, 18 Dec 2025 05:20:18 -0800 (PST)
Received: from [10.57.45.71] (unknown [10.57.45.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D09D3F73F;
	Thu, 18 Dec 2025 05:20:23 -0800 (PST)
Message-ID: <eb2587b2-6d5e-443b-8604-4008070e821a@arm.com>
Date: Thu, 18 Dec 2025 14:20:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] selftests/mm: fix exit code in pagemap_ioctl
To: Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Usama Anjum <Usama.Anjum@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-5-kevin.brodsky@arm.com>
 <67e61dd6-2a44-42f5-980e-e9196d672540@sirena.org.uk>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <67e61dd6-2a44-42f5-980e-e9196d672540@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: DA67680013
X-Rspamd-Server: rspam03
X-Stat-Signature: bfbr5wxnux5ntae4jhnwqhj1bgg36rxx
X-Rspam-User: 
X-HE-Tag: 1766064026-821867
X-HE-Meta: U2FsdGVkX1+YnNr/wfSK4LCmmsZf6kITVUvlXvJ331g/Q7sUCGmZD9x4ml/2fP8wl30DLCBdwGsp5j1yum2iXKk8IAFWGR37Zh8LM1mCsDYW2AcosGyJfJrvpeJzohEN8kiyeYABiYQOXPGJbK4nevepMZfk9/z8EuE5Ea2e4Q9HRLCSbd3RUmjcrU+aXqDYw33U2LZxnjqA6kfuXrx13CRZ1AiBCIjx2MHYL/2u0uZTGrn4kL3CgLsPR9iF4WH1T0vMBX7PAbQcedKnZ0PeZdGn19POpEgNQ89A7C9EXaIuiiBGpSZvzXFwdx1dCAfCKCH3rMvWf3qNrf/EY/H7ghwPjnTVoGKk+HrZ06rAFPD+TVpM1HM8U5u2TwZ+JwitiKOp5RaDcAk9bJ/YtrkkZNCeaY8gBqGrvTw9CE1q2u/DJxE2/WTqFFHOGBxK0nleOhjAzVi1HdueGQeZ2+OYgHMtyrLtlcj1VIB7jvf7B9odvaxgEWBbRdUnFZAx57Lr8tpoGxhb1FyseepKf8+JDMBwqDER3c3KIL+R5w1g/O5BXyWO4YsIw/cNeqv7kK+NqZSltGLxo5h0+RuYkpETReEBbVs4TBZEGMS5Qp5G2AcGZY3jO6IwS1kJ9n4e6J8U7VBKLzk4BhNWrTHpuUrLRXtPL4bVAwfx7EolVs3zAPlkpFrdnEuHDdG9rxBdXRYGluDX8y7hMDIdSdT6T+e+PmRytVDg4UjT+cDptY5HzBrRkZFwgtqDk6Ur0CvgotcGJH6rB3Ml86ngr79Dt0vn+5ToQxBZLb38KgWxY3eVYmAM/aPDwDLHxdqpFgj190ULXU7NPITXoCFgGY8BLAYEz8dK7j67SwdvpqoIs5KNBoLnVPraGl1ReRsfxy7aByAspvlelPzz2fh8je/idSbHNeOC88oWBCzQylNZzNjAiQ7OcfBMru1w7nZq00o77oeVZIWAC/+ao4Cw4MlKqMS
 CgW/YE8g
 RD6iWTBjYD1TTP5EqCFzuhl9iMj6bXHkdoDFVN8YXEvVESoRebigrAWWShEDzB42hbdAyTyl0jGTm2Rhoj4GGJ4ZuPIkC0xuakvP5jOgX4pki8LXn0AyODgSPD2J+OSkl8tbC3l6xswHBp5M0Q8+Rv+n4/BQ2KW45Qt+6E2CbEYkws/PHH1zlmOTbT1kSI/RfxJlg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 11:08, Mark Brown wrote:
> On Tue, Dec 16, 2025 at 02:26:33PM +0000, Kevin Brodsky wrote:
>> pagemap_ioctl always reports success, whether the tests succeeded or
>> not. Call ksft_finished() to report the right status.
>> While at it also fix the exit code in unexpected situations:
> This is a general sign that you should have muliple patches...

I can reword the commit message so it looks less like it's an unrelated
add-on ;)

>> - Report FAIL if we failed to open /proc/self/pagemap (returning
>>   -EINVAL from main() is meaningless)
> If you do a new version it's probably worth noting that this is a
> non-optional feature introduced a long time ago so the open should never
> fail.

Good point, will do.

- Kevin

