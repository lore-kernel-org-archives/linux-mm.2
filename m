Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98944606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rqcluRyp
Received: by kanga.kvack.org (Postfix)
	id 97AB46B0983; Wed, 25 Nov 2026 05:06:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92BAC6B0985; Wed, 25 Nov 2026 05:06:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869496B0986; Wed, 25 Nov 2026 05:06:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54CE06B0983
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:06:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3929160DA0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:06:34 +0000 (UTC)
X-FDA: 85473211908.15.22257EB
Received: from mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id A0DA0100009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:06:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rqcluRyp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=enze.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601193;
	b=2aS9glGe/Joim0+NNRIko3iw/lecUkgAuzCBAlsIutWNdbPqLfDiTdp8/io9NCmtlnTfoE
	ePWEiOPtxXYPkaPVv9HOJjpdIMisguQYn6nM//hSQtV2L8Y2ZaDhUtGSjRpqPV3r5HJWmM
	AnAeqQR4HSagZmQ9go9O8xDeqbxAq8Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Arx3BJNS+dbXZzp4h/tce0DGEBdUqyAuZtL9wSo0Tdw=;
	b=XdfTllTUEthUlWyDbFsoVOpOqhFuACA6SPsK2wVSCl8Q3cQ8HzJC+QTYVFJTXxOIQ1pn1C
	cLlkJeru6xOKa1u01B5lSN2418O74SRrbQXMLTlltHfskA5wkWwfjvYyCtHPcsb8wRX8NS
	DTy+UmGsbASOD180wxexn0gOgWCdupI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rqcluRyp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of enze.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=enze.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PsZOw7bb0SZdIWP30vhMxqaF4WJhPkOQJioKFLKp5zU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795601190; v=1; x=1796205990;
 b=rqcluRypAtOkPq8Eh2yvStZDZFUGNDNb6iZcpxVjGuSVpiwAja6utt8HZmkoJQ3tN4BzwRrD
 dRb2Oim7V5lHkRsQcjFSOeMh6afyuzoerFEPzw/Fr8VlfGsHZI9ryn8aSUh1HlcOS8YHNoOx/xP
 O+Sm3+onzhyBTawWGd9hr2Sk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 74f8e64801debf3e;
	Wed, 25 Nov 2026 10:06:30 +0000
X-Mizu-Trace-ID: 74f8e64801debf3e
X-Migadu-Flow: FLOW_OUT
Message-ID: <17263a6c-b812-4a03-b64a-338224142e35@linux.dev>
Date: Wed, 25 Nov 2026 18:06:27 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/27] mm/damon/api: introduce struct damon_report
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org,
 Aveline Noir <jm5905938@gmail.com>, Lian Wang <lianux.mm@gmail.com>
References: <20261124153636.91854-1-sj@kernel.org>
 <20261124153636.91854-2-sj@kernel.org>
Content-Language: en-US
From: Enze Li <enze.li@linux.dev>
In-Reply-To: <20261124153636.91854-2-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A0DA0100009
X-Stat-Signature: xdksfxnc59t8nzznfyda5rgadqngtmp9
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795601192-122661
X-HE-Meta: U2FsdGVkX1+Ean9Wvz9r8Bekx2R+tma+cvpg2J+dgixF+obYskHXPROM1zS2rIc07Z7PLu5iCX+hoISXHlGmH4s2eD8UjTPNFqX9EVOakh2n4Wxhf44sVPhZFpc0uWa1Py79Q1CTHGvd5G9d9Qtz7LJXY0Vu/jeWQIDLe/oZKotuxrc74i98vzwrM6F1578+vie33b1kOwekB5D5j4Gm5nzCUtn1OOuxM8beY+PLWbThHpTBtbPjPZzONx7ufEAyMuBAkYjN843HeqPRipzYrjEGzfSdMVJDTTwv/UbtNPeNMitLO2tDPBAegzRZIYGLGWR9vClvbtoV169Tt1JKL/Fx67gZzWoBEY+YFTFJAEjxxzlkVsZQyQio6fSyc0BjDsPki57dNOlz9sj7zQQvH0X5Hdjcb8a/XrCLQaNhoWfuOlAHyFDDG16PT/JIfwG2M7rypzuB4NuqID91I1UYPqc2hwDTxfFKjL/uT0QJVWFQM+WlP/TMvxZ78qKkBnywHO/XYV7nCTvL1Y91hTQYfP1fR0JvXm7cu4I+WgrPEwqkCpqNAeySaQdr440uAD+8RicwZ0SJ5YEM7nXsM4RCr32bIvvWgIbqY3T9Ar9gq5onvoOAGNnxM7YkxbOibisZlcmRPbXC2URmgOxiNSEOyDZi56vg/UYdWpz3B1zhc614qrtA5Vi529xekSqkvfGEoJgPtR33jqN0XLhE/plqlMolj8WSWlrkcr/tBXDbjUJx2OdSxBcrRxY7SpqgJ5Iu6Hpkc/TSlqmtCkh7RogvVj5OA4RfFnMKQC4tyr/WDbBOWfneZC7t1953mE+KEXSAkEFV9nEgbX07ghNf1hesQoEATeOB8Vs4Zh26V4Ljl+1FLib+S/ELnks77iqjK8xpKk6q2YDJw/Bj7mjcXxHkBGP/Lle2rTCOVATaXUDNLxiOUjO8dNTaKeXXkqr9fRDYdjygPBYHcbI1e7m7l75
 AO9FeDQs
 MMHIldVKvdDQi1q8FFFJbt83Q4YdL8bIgz+1eBV8P77EU6oD5yBRjqtEDtC9k0Fp0OtLgBpyOkJWlXOg9byH1P2pcpjkq3rGNNkPgvLmd8uvrAE0iHa7HnLnR+ed+ODIFY0+LAv3i/Gg6epWoiPs6NlLRDy9RUwrRBFD1NVDmMH4OV46v76GSn+vOVMptLr6KeQHUKLE/dzYdqgqJiHyPOL8yuNBGP5wjlKLVcBIkJp9PXFGumypZfKONz2bkLJswxRzHRwZfsRh/W+e0XxH3ik39Fo/mas4xpt71b4bMhWfGJAAEZRJQxC6LUmSlAywyYOyIxt6CIcSxn4S7bpoXnEe8AsJv2ix2H8XidkH2vV2jCg1qDtt8sl7eAQggtlD7YMR2ps7BTvwyqCKNtKLnQ/yh4QiqRki5RBIffzs6jiXSTP6MMSN7UQ0ad6kta190Ryx5u87xWnQole2Z90nJpq3YQceh54xRHv3SIq1xJRII6hBuNLOx5cYyYIwfK0Xb4I1SWpSKJB2pdGt41yTXjaeO9Vny2AbRGwi9ECT3Xu7ng9/igwyx22QHqlEtDgnYw/YvbEB/pN20qq4l0qgPIFBUntnKIgiKo8YJ+D5DFy23RLHBTxi4whfbaV5P1dxbTfzcpDVjyk+0TqdYwVS+rCCvtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 23:36, SJ Park wrote:
> Define a struct for data attribute report.  The struct provides public
> fields for the type and the memory address range.  The type field
> represents the type of the report itself.  The address range is for the
> memory of the reporting data.  Data attribute producers can format their
> report using those fields.
> 
> It also has a private field representing when the report is submitted.
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: SJ Park <sj@kernel.org>

LGTM, thank you.

Reviewed-by: Enze Li <lienze@kylinos.cn>

Thanks,
Enze

