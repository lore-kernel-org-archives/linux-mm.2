Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE398EA8112
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3456A6B0092; Tue, 10 Feb 2026 08:31:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316096B0093; Tue, 10 Feb 2026 08:31:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243676B0095; Tue, 10 Feb 2026 08:31:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 165C66B0092
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:31:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97E3959276
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:31:39 +0000 (UTC)
X-FDA: 84428634318.11.B4D73E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id EFA7118000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:31:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3ioH6XU;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770730298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZs9tRM1hrD70CslL15qthWhSdEUv+AbkPAICfyQGfU=;
	b=wqNj5ojebvt7Tkx3N4v8IaSN5hSoCIhdgAZ98A0dJj83j4y9CceokrRPJE1vthOQx8bV/G
	Qu1zTu/y9Le/gAAigPoj0pJ9QBaYH4u2Joa9+r2/zjL/038sAytxoxLQ6YHyoFI2Z1nx6a
	4JnAmMcKfQMnlQDGHq8hlFlafNrzaIA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3ioH6XU;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770730298; a=rsa-sha256;
	cv=none;
	b=aRvAUVA8Vn7oYvq2KBtpzVIMBMHl2W48NQvEAa8KOv3uo8vBWxJL6cX3cbPEMJ3hnchILl
	aA1B2oPe4qmFlI8CKrZInjhTKf0qXIML2asHjup9Pu4BQ53ek2yqof+KAFpf1F30ycjrKE
	yvF07t21CVTQUj41fffRbtqIUToAlcs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E64360127;
	Tue, 10 Feb 2026 13:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11841C116C6;
	Tue, 10 Feb 2026 13:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770730297;
	bh=3HeREPRJ+703K8NPuBAJ4km2oIpg4L6gON5eMLrj2hU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=U3ioH6XUgBHIUsxl3nVC5oBWbVa8bMCOGAhaOU1T/P1s1Y0TwVN4PAjCSZXmt/eka
	 t/h9WHLgNJMsBbOQyBUWiY/9hLcAbtq9vV54GRFy0KL8/eTFJDYF3Eos8JSuVX8Bqa
	 I70VyRN/BaJfpyo0BFMkJvJ9odH8Nn6qfVCYu8ga+kGDN0lLPIdrlE/L3hM4sVKOFY
	 QOZXcyEz7n9M2aU2OHzouU+ER4NASWz8SZkuFM2kGMMz8o1X380LCodDte5JOTIBsF
	 yJPDMwDYFzMvbQ0OiAmfDzbwTdXKQO+yGgqPr/rtd5j0MWLQJxLU8UlzGwWLKfCWy0
	 4hDKwE0+2zoPg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 2/2] liveupdate: luo_file: remember retrieve() status
In-Reply-To: <CA+CK2bC9WBdYoQfJXZs+K6DQjDkrGmppbevL18mJ=DhO0TkG1g@mail.gmail.com>
	(Pasha Tatashin's message of "Sat, 31 Jan 2026 10:31:38 -0500")
References: <20260126230302.2936817-1-pratyush@kernel.org>
	<20260126230302.2936817-3-pratyush@kernel.org>
	<CA+CK2bC9WBdYoQfJXZs+K6DQjDkrGmppbevL18mJ=DhO0TkG1g@mail.gmail.com>
Date: Tue, 10 Feb 2026 14:31:34 +0100
Message-ID: <2vxzbjhwu3m1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: EFA7118000C
X-Rspamd-Server: rspam07
X-Stat-Signature: frt3th9ufpi943yarz7id9toemyctpm4
X-HE-Tag: 1770730297-987368
X-HE-Meta: U2FsdGVkX1+8+cO75/+1vXj7IkY2MeMGSeVEfQD0ilBbbvJZzROA6oFtSmSQSkj9lVH1+lbii12Np+Uz8/AF36z7tgim8KsVl3QspAKLVTaEzoq9yLXnkgVvE/PZ2n1W5NQRV0adlnrwUjtJ7VLX7pmrfNylJ3loiTs4Qf9/VRuQA8I3oBE4GGi8tnBRzuRL1kJhgmo2CmsOFZNHsQp9loOmoRy2L3qixY2S0tAoeFhLn4GUey05zn9k0Utkc6fY2RHTeY0lXIq5Yf5vilgcMlfxkea1qB5jD2FoMwC4Fq2ef2cc/a5BbZe9QRyinAdMrq4QHCIuCVVtX2E2GMOWn1UMzQiczUrDCIGW4Rn4IY7oZl21FeL+peY5J/+BSsrqdc20/uwLf9lik3qOU36Skf/jDjcSsv6L9Od0F9SR7q8f+so1KlCNGd2lrHhS+3kgppQJIfsya+eIaRAOR7Ctzx0aBGO3mA5xL/XrEcupq/S5/sAVqAHx+I6FY4SS6SayoRDQd62fR2o8888bjBpOOf0GC1bpf2JucZ6ZCncfcYnMSK8MLb2jJt8ezc6UunhK65o6rswjcjLkO7CtYx8sSl08qwoSIPsSaXdCVC69fzPbKWC278rbW4p0zpWTzqtVAWJEqQeTErroENXjTmUifKgyvZ0ayf7GFzWIMLss1MRuIQhq5iS+1SAkAe4f9uWVihbzpaUzhfpqr5znxKWFy42bdMLTtHyQ9wU2uK81tMQ+LHZzNSjgWcmpIcFBF4hJGC98lClTtP//1rn5k89Aro6ySY7pkvWu6BDhMjmuZSEDJbI+UZ9wVhcNdBl8q97hGB/zTmDDhfoi6iKa2nYgsEoRitkzqk0qwpIbKNlTFqdZQKjiBOpMtufTtw9gMcqGuvSXEArpX98azp9r4zRmlu4GXeqPFnD2jtzS2WfRgl1WgWTYKW4tQQqdY6lJsuKEc9Tq5v4WvSosdIOnfja
 nNSo17Er
 ZbX4AELDEo8yvKa0ZcBqqZqDToSlUt6+Fsd7YisPd9Ya8azFDSMB0lwbdkxc9e9fTUYLv6Z9PuhJNx7TvDFa9wJdQhpmzFUQFj92Qc+us4QtvaaTYdpVvKqx1vxq5Xjnd+KVywTEhGUupGqcwQL7P3wsA7P8LaBpfCUtwhLe7vsSZB6UAu3QWiE7forfMtbvhi0wAxRRW0v7Dd9ULtCykp+jrHKNanKl3VlaeyLHJ+hLRMy/Is0uG5ovX8oXHqCeJfQUQkC3BAGkusgbewsTMxHeENZ9dmDa11GKuvC5Wzw7uKF1FJknmHFe6S5DbhayWg9zK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 31 2026, Pasha Tatashin wrote:

> On Mon, Jan 26, 2026 at 6:03=E2=80=AFPM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
[...]
>> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
>> index a7f6ee5b6771..a543a3a8e837 100644
>> --- a/include/linux/liveupdate.h
>> +++ b/include/linux/liveupdate.h
>> @@ -21,7 +21,10 @@ struct file;
>>   * struct liveupdate_file_op_args - Arguments for file operation callba=
cks.
>>   * @handler:          The file handler being called.
>>   * @retrieved:        The retrieve status for the 'can_finish / finish'
>
> Rename retrieved to retrieve_sts

Will fix. Thanks.

>
>> - *                    operation.
>> + *                    operation. A value of 0 means the retrieve has no=
t been
>> + *                    attempted, a positive value means the retrieve was
>> + *                    successful, and a negative value means the retrie=
ve failed,
>> + *                    and the value is the error code of the call.
>>   * @file:             The file object. For retrieve: [OUT] The callback=
 sets
>>   *                    this to the new file. For other ops: [IN] The cal=
ler sets
>>   *                    this to the file being operated on.
>> @@ -37,7 +40,7 @@ struct file;
>>   */
>>  struct liveupdate_file_op_args {
>>         struct liveupdate_file_handler *handler;
>> -       bool retrieved;
>> +       bool retrieve_sts;
>>         struct file *file;
>>         u64 serialized_data;
>>         void *private_data;
[...]

--=20
Regards,
Pratyush Yadav

