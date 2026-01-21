Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12745C4453A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 13:45:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0606A6B0005; Wed, 21 Jan 2026 08:45:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E3F6B0088; Wed, 21 Jan 2026 08:45:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52AF6B0089; Wed, 21 Jan 2026 08:45:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D43336B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 08:45:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E1191AF25D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:45:12 +0000 (UTC)
X-FDA: 84356092464.23.7C61BB6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6CFACC0006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:45:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769003110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BbMCIGu3sbu4F+Pm6bWzzprjVhcgq4cBnYs4hQ+r4Y8=;
	b=bTNvsd3mglpTkM8mi07/jq7X8h84CUoa3kQ7zVf3x5Z92vvr/cePmOgrUJdogqO/3zTzHO
	h4LOe19Tpg872SliNr8WgJqkpxPruBN7WVmwWDnusEpN43LnSIr42sEyutYCZ+ceCPyy1N
	UxN8+gDyF0AY9lkUsGVCj5nB8m2GuRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769003110; a=rsa-sha256;
	cv=none;
	b=7jCvuWfu0caJqORs9sQbHP7XDtX4WzuTuuDFoCEEDoVZoygGYQc3gkibbA4o+szcbYI9yG
	a35RLPGqvePD/W/gr3JTfCESf2TmoCypRfDveKqDawR/l8Ixl81LMe/OSeR4ONB7jPl/Wz
	gEx/NbeE6fovaxRn5uIGDjt+xb0osOo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBA411476;
	Wed, 21 Jan 2026 05:45:02 -0800 (PST)
Received: from [10.57.49.179] (unknown [10.57.49.179])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 75B453F632;
	Wed, 21 Jan 2026 05:45:07 -0800 (PST)
Message-ID: <0b82e184-2a2d-41e9-a2ee-2664c382fa8a@arm.com>
Date: Wed, 21 Jan 2026 14:45:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] selftests/mm: report SKIP in pfnmap if a check
 fails
To: Ryan Roberts <ryan.roberts@arm.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-9-kevin.brodsky@arm.com>
 <09c214df-c3aa-48e4-9587-c54c667c6ce9@kernel.org>
 <46e50e9d-0e4a-4f81-8b43-61b897ad9c34@arm.com>
 <42b9825a-adef-4e80-bbf3-bf01b9fb0054@kernel.org>
 <ee3750f6-dd8b-459f-bc19-8c4a857d40a7@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <ee3750f6-dd8b-459f-bc19-8c4a857d40a7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7rtdixjgjz1fzyiaq4k1kwgdmqmq3wc6
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6CFACC0006
X-Rspam-User: 
X-HE-Tag: 1769003110-634336
X-HE-Meta: U2FsdGVkX18LcYJPbKg1dpjAX5GRJDy30Ztt7+uHVrxvaB1mEHT6bRidYFVXPEZPwaSVJa6/wIf1pVSyKSBG8kh/2Yoi8z+HF16iUbcJU3nwbFLSGFjtnOVKuYBXY53nwvG2TFWkFiT1KWbjCuGbf/gqWOper70Gt3efbCNuHXBy/8Irx+XAVirpZr1QnTsNlSthTk8Ov1Uw0s9wk28Y/V2QX7csB/KLerEJRvOgZTk+X7zhz6dnnw5h+nrN3Ydlfi5VmiP7widwtVyXwgrxx/ucokAX+T6nJO9MnG0gmlzSyofmSwDlP6MMqPMj3cp5K49ZzycbvFoaVHPe1QVBJqV+7ajXXk3akeBqq0as9jbkB/RTx6Ct9jSQmXLowU+LQczqdo3OxjYGT5TWJo7yo8g+yR51Vm2gj+6EaG6fJkpJcRSSLlIRRezV+bEGhZ+jmOGmIJXQZVNF/iyzzD/MuYMw8kj9tCbHvn22hYPFFVptbCXohg1COhswA3eKDL/tQ/okvZhLyNEHUe9fZq0Ez46NUTjf4fZNP4rDKQU2YN+iz+n+I+Ci2T3ZwOBp8pElTFA7a6KvSgcyDIIy0aN1OdOcaa/TXfOocKVmdgWAB5ub51sCjm9ri41QR7VRAK5yyr3q6rcbXzNnfm+Bu2uZ3BBEaTPkZD2qf8ACfrdkxBMVCG8V7BttKmhlFgzPohKSh/t9cDcq6hwrjYCwpZFgLaCmY0CtJZfOn2IK7GOCIzYjr96kect7DLeTw2HcJoyncCLsQRqnp/rZJ6kQbX3H3hrXZQVBNGu8fSjuYKVOgPRsKKlIgTpYWYNSzgM+HkiUDd2wkrc1QAK5qXQXIYi8HHblBm9H/A0ZVCUo8hGg2zWgeerm67w6aEj1gsr9HiD+MUsBnozb/9xepM2HaS3ituvVrpAiTUJiQ5sQxdM7pBTWVfWOT4S5hxABfR4YIpKhrLq0NyT6LtIgD70o4zb
 KG7YBbxw
 hBZLoCasruFbNLFbb9Ylan8cS9tS7qKeQJikBBDYjsqntnTSHaDTv5zgZh6UpPzfwtj4QFhxM0Vy7Qv+YWVgX/7NQEoEHYnoVZT/AkUyuO67TPm3YXD47c/bva23VFVjrDaGOc45KnA0JJcU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/01/2026 17:27, Ryan Roberts wrote:
>>> But if you think that concern is unfounded, certainly just opening it once and
>>> reusing will simplify.
>> I would just keep it simple here, yes. If this ever becomes a real problem, my
>> intuition would tell me that probably the caller is doing something unsupported
>> that we just cannot easily identify+reject.
> Yeah fair enough.

Cool, will make the fd a global as well then.

- Kevin

