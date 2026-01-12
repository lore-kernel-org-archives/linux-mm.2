Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED44C9EC64
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 10:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52A736B008A; Mon, 12 Jan 2026 05:25:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5028C6B008C; Mon, 12 Jan 2026 05:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 430026B0092; Mon, 12 Jan 2026 05:25:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 34A416B008A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:25:53 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5A341608F6
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:25:52 +0000 (UTC)
X-FDA: 84322930944.10.9E999C5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0C5FF4000B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:25:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768213551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QoYipf2xQsgeEpz3/au1t51XLiDI6lfHBI0rPv81JV4=;
	b=L0gjF62kUjxoMRcgDj3no+EV6i0OFvZMUXqlT3XhBJT+xEPHFxyrL01x0fYe2QW8xEdIyb
	muvnPK01NtKkHomM21u+oM/MPZn+IfB+YQTV4rPcesgdBQP/FtL5d4eWZ4UYmikixBnn5v
	IQIRMapB116H68aa8yZvN1CMIe5/cr0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768213551; a=rsa-sha256;
	cv=none;
	b=A/4WuDyVPJ6lM2eFWctFKkdhyHHnFu6VoT2GDa8xjXlQqFrkIQQdmzWhWyh1ow7sJbeALe
	gxSG4I+bX4D2ktXofRJMDw4yO9PzSuqcGqzcWRnIgcQbdtOO9XZ8HybJXCMnfAbUt3QYBA
	k2FgpsbU6JyfXCZzQoADHc4UTWkhSA4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 66F8D497;
	Mon, 12 Jan 2026 02:25:43 -0800 (PST)
Received: from [10.57.95.123] (unknown [10.57.95.123])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE8833F59E;
	Mon, 12 Jan 2026 02:25:48 -0800 (PST)
Message-ID: <ac7ca47b-3ef7-4b54-8539-c75871ed7472@arm.com>
Date: Mon, 12 Jan 2026 10:25:47 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/8] selftests/mm: report SKIP in pfnmap if a check
 fails
Content-Language: en-GB
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-9-kevin.brodsky@arm.com>
 <315a7239-f5ce-474e-bd0d-f1deca3a7b26@arm.com>
 <105c747f-5721-4ee8-8eb2-1bf298de9adf@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <105c747f-5721-4ee8-8eb2-1bf298de9adf@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0C5FF4000B
X-Stat-Signature: 7xh1j3iksayceonintnmobroaxmqxhsn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768213550-339781
X-HE-Meta: U2FsdGVkX1+PV550tUw6zA1CgdcoVGE5vfIjZGa4IlAMOKTiY3sJZXohuS6TKrn5th8x2RiJ0hwMK2pQ6yq7St6rMcqzgXalyGjlMMWQGjDJeXnT1iJevXvZ9Buo+oBUI5Xa6tqIK2cmte9N+iRT4nnzsPmfJjX7UMc6XmzaPlRmBORJFuagsPo1DBfqWszvUeGdhqpoV2Jw063VNx+PpkyEz2d+ogQde6Hej3ZfRa2Q0UP2mH157c97tvLk8ZLeYzpawH1e/AnmRPQsKSkxOnzzFUbgdStYQbdXh5zLPX+wGBEX3lw67XPhjggShAcWszhXgpexdJS64D9D35NZOvhnQsx999aM774NbuPuEw8mpg5I58kfZ2bHpzJO+vZa75VgYfKhzB4SNcEEccHLqn/ORiwoJjLPh+h0LDcOoKSXSb/harxCIvAtt+HRfpQ90IngtHDYICe44YQF/4aHTFaBb9oBIaIU6lmwMchZituRQ62aN/j7vjxFo2OewVi3JiyxLioAeekgfvbLrRc3tOpiaPHmNvA8yY73sqRAHgXf5rzVGbSsMueT0nO60FDtiTXRlf18gVxIrglYuTYdGV05uMTts/MoyoWx8BC6fbe4ebYjSYIaI7ZSRd3B6PHwPY75WaBwxOsMCzOpaho03/+FBUIUcb1GbVAn9RAsPLX3CFvEo+cxLLgjwRcxNsXFAdFxkJpMWy/6jSVSpCBf/qk2yRlXmHyOF7lCtbMwv2XnsUzClqt/o3EYrucDq3Ivv0ng4+v4mqzU+nYoMnhqmoFEMhfDWCExbBsOsn60XsUtfQVICxQElLTZt9LpVtoUhYKtB+VTpPS8qpgWNriZm1jGJ2QPjeDnxzGEOAALFQjvM/bqU+VgABQPkxpOJkpD2xByteZKuTsBSHMLQRI/heKfRjPSExRo4e/EbYsLM+j/aXcgPrztpqVI1Xn4kiZC2ReV68ZgawKGvYboxZT
 Dvcx+Yay
 X2uMrp+30JcjLZ875c31+XxgEE7RPxEJ18rgNnXUuKi8pRZ4exmVDbNyCQKdUB7qc3DL0UZ5qr/iF+1jlz+Lf+FJWeOVIeMAGP1W2lDEQZ9BpJViB1RqnKk4h4pTch9JeXEJ7TjSfbhYF+PCuTDZUg8fvCN0bjkl38Cl5cGRd9PyX29w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/01/2026 10:03, Kevin Brodsky wrote:
> On 12/01/2026 10:34, Ryan Roberts wrote:
>>> -	if (!check_vmflag_pfnmap(self->addr1))
>>> -		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
>> I wonder if we still want this check per-fd, but upgraded to a fail?
> 
> It seems very unlikely to fail though, I can only think of the
> underlying file having changed in between but I really wouldn't expect
> that for such special files. I was trying not to duplicate the checks
> too much.

Fair enough. No strong opinion from me. I just thought that given this is a test
that claims to be checking the behaviour of pfnmaps, then we ought to be pretty
sure we have a pfnmap.

> 
> - Kevin


